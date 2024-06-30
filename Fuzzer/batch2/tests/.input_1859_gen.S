# See LICENSE for license details.

#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "riscv_test.h"
#include "fuzz_test.h"

# entry.S

#if __riscv_xlen == 64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

#define TESTEND gp
#define STACK_TOP (_end + 4096)

  .section ".text.init","ax",@progbits
  .global _start
  .align 2
_start:
  j handle_reset
  
  /* NMI vector */
  .align 2
nmi_vector:
  j wtf

  .align 2
trap_vector:
  j wtf

  .global _fuzz_prefix
  init_mie;
_fuzz_prefix:
_p0:    xor x12, x12, x12                         ;
        csrrs x10, pmpcfg0, x12                   ;
_p1:    xor x13, x13, x13                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 18                         ;
        add x13, x13, x11                         ;
        csrrc x12, mcause, x13                    ;
_p2:    csrrci x12, satp, 31                      ;
_p3:;
    /* Fuzz Prefix */
    /**/
_end_prefix:
    ret

handle_reset:
INIT_XREGS

  la t0, trap_mtvec 
  csrw mtvec, t0
  la sp, STACK_TOP - SIZEOF_TRAPFRAME_T
  csrr t0, mhartid
  slli t0, t0, 12
  add sp, sp, t0
  csrw mscratch, sp
  li a0, MSTATUS_FS
  csrs mstatus, a0
  call init_freg
  la a0, userstart
  j vm_boot

init_freg:
INIT_FREGS

        ret
        .align;

  .global trap_stvec
trap_stvec:
        clear_sie;
_fuzz_suffix:
_s0:    fsgnj.s f24, f0, f10                      ;
_s1:    srlw x26, x2, x2                          ;
_s2:    la x19, _s4                               ;
        csrrw zero, mepc, x19                     ;
        mret                                      ;
_s3:    fcvt.s.wu f18, x2, dyn                    ;
_s4:    mulhsu x18, x3, x27                       ;
_s5:;
        /* Fuzz trap */
        /**/
_end_suffix:
        ecall

  .global trap_mtvec
trap_mtvec:
        clear_mie;
  DUMP_REGS

   write_tohost:
        li TESTEND, 1
        sw TESTEND, tohost, t5;
  _test_end:
#ifdef BP_EN
  BP_END
#endif
        j _test_end;


  .global pop_tf
pop_tf:
  LOAD  t0,33*REGBYTES(a0)
  csrw  sepc, t0
  LOAD  x1,1*REGBYTES(a0)
  LOAD  x2,2*REGBYTES(a0)
  LOAD  x3,3*REGBYTES(a0)
  LOAD  x4,4*REGBYTES(a0)
  LOAD  x5,5*REGBYTES(a0)
  LOAD  x6,6*REGBYTES(a0)
  LOAD  x7,7*REGBYTES(a0)
  LOAD  x8,8*REGBYTES(a0)
  LOAD  x9,9*REGBYTES(a0)
  LOAD  x11,11*REGBYTES(a0)
  LOAD  x12,12*REGBYTES(a0)
  LOAD  x13,13*REGBYTES(a0)
  LOAD  x14,14*REGBYTES(a0)
  LOAD  x15,15*REGBYTES(a0)
  LOAD  x16,16*REGBYTES(a0)
  LOAD  x17,17*REGBYTES(a0)
  LOAD  x18,18*REGBYTES(a0)
  LOAD  x19,19*REGBYTES(a0)
  LOAD  x20,20*REGBYTES(a0)
  LOAD  x21,21*REGBYTES(a0)
  LOAD  x22,22*REGBYTES(a0)
  LOAD  x23,23*REGBYTES(a0)
  LOAD  x24,24*REGBYTES(a0)
  LOAD  x25,25*REGBYTES(a0)
  LOAD  x26,26*REGBYTES(a0)
  LOAD  x27,27*REGBYTES(a0)
  LOAD  x28,28*REGBYTES(a0)
  LOAD  x29,29*REGBYTES(a0)
  LOAD  x30,30*REGBYTES(a0)
  LOAD  x31,31*REGBYTES(a0)
  LOAD  x10,10*REGBYTES(a0)
  sret

  .global trap_entry
  .align 2
trap_entry:
  csrrw sp, sscratch, sp

  STORE x1,1*REGBYTES(sp)
  STORE x3,3*REGBYTES(sp)
  STORE x4,4*REGBYTES(sp)
  STORE x5,5*REGBYTES(sp)
  STORE x6,6*REGBYTES(sp)
  STORE x7,7*REGBYTES(sp)
  STORE x8,8*REGBYTES(sp)
  STORE x9,9*REGBYTES(sp)
  STORE x10,10*REGBYTES(sp)
  STORE x11,11*REGBYTES(sp)
  STORE x12,12*REGBYTES(sp)
  STORE x13,13*REGBYTES(sp)
  STORE x14,14*REGBYTES(sp)
  STORE x15,15*REGBYTES(sp)
  STORE x16,16*REGBYTES(sp)
  STORE x17,17*REGBYTES(sp)
  STORE x18,18*REGBYTES(sp)
  STORE x19,19*REGBYTES(sp)
  STORE x20,20*REGBYTES(sp)
  STORE x21,21*REGBYTES(sp)
  STORE x22,22*REGBYTES(sp)
  STORE x23,23*REGBYTES(sp)
  STORE x24,24*REGBYTES(sp)
  STORE x25,25*REGBYTES(sp)
  STORE x26,26*REGBYTES(sp)
  STORE x27,27*REGBYTES(sp)
  STORE x28,28*REGBYTES(sp)
  STORE x29,29*REGBYTES(sp)
  STORE x30,30*REGBYTES(sp)
  STORE x31,31*REGBYTES(sp)
  csrrw t0,sscratch,sp
  STORE t0,2*REGBYTES(sp)
  csrr  t0,sstatus
  STORE t0,32*REGBYTES(sp)
  csrr  t0,sepc
  STORE t0,33*REGBYTES(sp)
  csrr  t0,sbadaddr
  STORE t0,34*REGBYTES(sp)
  csrr  t0,scause
  STORE t0,35*REGBYTES(sp)

  move  a0, sp
  j handle_trap

RVTEST_RV64U
# RVTEST_CODE_BEGIN
        .text;
        .global extra_boot;
extra_boot:
        EXTRA_INIT
        ret;
        .global userstart;
userstart:
_fuzz_main:
_l0:    la x22, d_0_15                            ;
        lh x6, 24(x22)                            ;
_l1:    la x13, d_1_10                            ;
        addi x13, x13, -24                        ;
        amoswap.d x10, x10, (x13)                 ;
_l2:    fsgnjx.s f23, f23, f12                    ;
_l3:    fence                                     ;
_l4:    fnmadd.s f0, f26, f21, f9, rne            ;
_l5:    srliw x10, x26, 6                         ;
_l6:    la x13, d_1_9                             ;
        addi x13, x13, -24                        ;
        amoand.d x1, x20, (x13)                   ;
_l7:    ebreak                                    ;
_l8:    xor x11, x11, x11                         ;
        csrrs x19, stval, x11                     ;
_l9:    la x28, d_0_12                            ;
        flw f3, 4(x28)                            ;
_l10:   la x14, d_2_4                             ;
        lui x12, 0xffe00                          ;
        xor x14, x14, x12                         ;
        flw f25, 12(x14)                          ;
_l11:   la x26, d_5_18                            ;
        addi x26, x26, -16                        ;
        amomaxu.d x1, x21, (x26)                  ;
_l12:   slliw x10, x13, 31                        ;
_l13:   xor x3, x3, x3                            ;
        addi x18, zero, 1                         ;
        slli x18, x18, 0                          ;
        add x3, x3, x18                           ;
        addi x21, zero, 3                         ;
        slli x21, x21, 11                         ;
        add x3, x3, x21                           ;
        csrrs x4, sstatus, x3                     ;
_l14:   la x25, d_4_5                             ;
        addi x25, x25, -28                        ;
        amoxor.w x5, x12, (x25)                   ;
_l15:   divw x15, x4, x5                          ;
_l16:   bltu x15, x25, _l53                       ;
_l17:   subw x5, x12, x7                          ;
_l18:   fcvt.l.s x22, f10, rdn                    ;
_l19:   fsub.s f3, f4, f26, rdn                   ;
_l20:   fcvt.s.wu f28, x24, rmm                   ;
_l21:   fclass.s x7, f31                          ;
_l22:   la x22, d_5_8                             ;
        addi x22, x22, 12                         ;
        amominu.w x12, x17, (x22)                 ;
_l23:   la x8, _l79                               ;
        csrrw zero, sepc, x8                      ;
        sret                                      ;
_l24:   xori x22, x13, -14                        ;
_l25:   blt x24, x16, _l68                        ;
_l26:   la x25, d_3_15                            ;
        addi x25, x25, -8                         ;
        sc.w x27, x4, (x25)                       ;
_l27:   fcvt.lu.s x2, f19, rne                    ;
_l28:   auipc x23, 16                             ;
_l29:   la x5, d_0_7                              ;
        addi x5, x5, 8                            ;
        amomaxu.d x28, x8, (x5)                   ;
_l30:   bge x4, x27, _l72                         ;
_l31:   la x9, d_4_23                             ;
        lwu x6, 24(x9)                            ;
_l32:   csrrsi x30, mhartid, 17                   ;
_l33:   la x11, d_4_7                             ;
        ld x16, 16(x11)                           ;
_l34:   la x1, d_0_2                              ;
        addi x1, x1, -0                           ;
        amoswap.w x8, x29, (x1)                   ;
_l35:   li x9, 0                                  ;
        la x18, pt3                               ;
        addi x18, x18, 48                         ;
        sfence.vma x9, x18                        ;
_l36:   la x15, d_5_27                            ;
        sd x19, 0(x15)                            ;
_l37:   la x16, d_0_14                            ;
        addi x16, x16, 0                          ;
        sc.d x5, x16, (x16)                       ;
_l38:   la x20, d_4_10                            ;
        addi x20, x20, -4                         ;
        amoor.w x28, x22, (x20)                   ;
_l39:   la x18, d_2_26                            ;
        addi x18, x18, 24                         ;
        sc.d x24, x18, (x18)                      ;
_l40:   fdiv.s f5, f0, f5, dyn                    ;
_l41:   fcvt.s.wu f29, x14, rtz                   ;
_l42:   fcvt.lu.s x10, f19, rtz                   ;
_l43:   li x15, 0                                 ;
        la x17, pt2                               ;
        addi x17, x17, 32                         ;
        sfence.vma x15, x17                       ;
_l44:   mul x16, x26, x12                         ;
_l45:   fnmadd.s f9, f13, f12, f11, rmm           ;
_l46:   fclass.s x6, f2                           ;
_l47:   fcvt.s.l f3, x14, dyn                     ;
_l48:   bgeu x21, x16, _l168                      ;
_l49:   la x22, d_1_20                            ;
        addi x22, x22, -12                        ;
        amoand.w x26, x14, (x22)                  ;
_l50:   la x23, _l162                             ;
        jalr x30, 0(x23)                          ;
_l51:   la x30, d_0_14                            ;
        lui x28, 0xffe00                          ;
        xor x30, x30, x28                         ;
        lw x20, -8(x30)                           ;
_l52:   bge x20, x13, _l57                        ;
_l53:   fsgnj.s f13, f7, f18                      ;
_l54:   fcvt.lu.s x8, f8, rmm                     ;
_l55:   slliw x12, x13, 14                        ;
_l56:   slliw x24, x10, 31                        ;
_l57:   la x6, d_2_9                              ;
        addi x6, x6, 20                           ;
        amoswap.w x7, x20, (x6)                   ;
_l58:   la x12, d_2_26                            ;
        sb x7, 0(x12)                             ;
_l59:   fmsub.s f6, f22, f0, f7, rdn              ;
_l60:   fsgnjn.s f0, f13, f24                     ;
_l61:   csrrsi x5, pmpaddr7, 6                    ;
_l62:   fcvt.s.lu f14, x10, rmm                   ;
_l63:   bgeu x28, x4, _l121                       ;
_l64:   bltu x12, x1, _l128                       ;
_l65:   la x21, d_2_24                            ;
        addi x21, x21, -16                        ;
        amoxor.d x20, x16, (x21)                  ;
_l66:   srliw x10, x20, 0                         ;
_l67:   fence.i                                   ;
_l68:   fadd.s f4, f13, f8, dyn                   ;
_l69:   rem x27, x15, x24                         ;
_l70:   xor x3, x3, x3                            ;
        addi x29, zero, 3                         ;
        slli x29, x29, 15                         ;
        add x3, x3, x29                           ;
        addi x10, zero, 1                         ;
        slli x10, x10, 6                          ;
        add x3, x3, x10                           ;
        addi x14, zero, 1                         ;
        slli x14, x14, 7                          ;
        add x3, x3, x14                           ;
        csrrw x12, sie, x3                        ;
_l71:   feq.s x24, f8, f16                        ;
_l72:   ebreak                                    ;
_l73:   la x8, d_2_1                              ;
        addi x8, x8, -12                          ;
        amoswap.w x14, x11, (x8)                  ;
_l74:   rem x8, x8, x6                            ;
_l75:   bne x5, x3, _l118                         ;
_l76:   beq x14, x13, _l143                       ;
_l77:   la x10, d_1_1                             ;
        lbu x23, 21(x10)                          ;
_l78:   la x11, d_5_15                            ;
        addi x11, x11, 0                          ;
        amoor.d x13, x6, (x11)                    ;
_l79:   sraw x23, x6, x6                          ;
_l80:   addi x12, x9, 2047                        ;
_l81:   feq.s x15, f13, f21                       ;
_l82:   divu x10, x25, x14                        ;
_l83:   remw x5, x14, x3                          ;
_l84:   la x29, d_5_18                            ;
        fsw f12, -0(x29)                          ;
_l85:   la x6, d_2_10                             ;
        addi x6, x6, -8                           ;
        amomax.d x11, x1, (x6)                    ;
_l86:   la x1, d_1_18                             ;
        flw f21, -24(x1)                          ;
_l87:   la x17, d_3_18                            ;
        sw x13, 8(x17)                            ;
_l88:   mulhsu x30, x27, x4                       ;
_l89:   fmv.w.x f3, x9                            ;
_l90:   csrrci x24, mepc, 19                      ;
_l91:   divu x27, x3, x25                         ;
_l92:   la x12, d_5_4                             ;
        addi x12, x12, -12                        ;
        lui x13, 0xffe00                          ;
        xor x12, x12, x13                         ;
        amominu.w x9, x13, (x12)                  ;
_l93:   sllw x24, x26, x17                        ;
_l94:   srlw x29, x14, x20                        ;
_l95:   fmul.s f25, f0, f30, rdn                  ;
_l96:   srai x20, x5, 9                           ;
_l97:   fmul.s f18, f4, f12, dyn                  ;
_l98:   andi x9, x17, 2047                        ;
_l99:   flt.s x21, f13, f24                       ;
_l100:  subw x20, x7, x5                          ;
_l101:  la x11, d_5_15                            ;
        srai x11, x11, 1                          ;
        csrrs x19, pmpaddr7, x11                  ;
_l102:  remw x20, x16, x22                        ;
_l103:  div x6, x13, x15                          ;
_l104:  csrrsi x17, pmpcfg0, 16                   ;
_l105:  xor x11, x11, x11                         ;
        csrrw x25, mie, x11                       ;
_l106:  la x22, d_0_26                            ;
        addi x22, x22, -8                         ;
        amoor.d x28, x13, (x22)                   ;
_l107:  la x29, d_5_21                            ;
        addi x29, x29, -0                         ;
        lr.d x17, (x29)                           ;
_l108:  csrrci x9, mip, 22                        ;
_l109:  bne x4, x6, _l149                         ;
_l110:  fcvt.s.lu f0, x16, rne                    ;
_l111:  sraw x17, x25, x29                        ;
_l112:  srai x26, x26, 61                         ;
_l113:  fle.s x24, f9, f3                         ;
_l114:  la x25, d_1_1                             ;
        addi x25, x25, -16                        ;
        amoadd.d x2, x6, (x25)                    ;
_l115:  fle.s x21, f18, f26                       ;
_l116:  rem x0, x4, x17                           ;
_l117:  la x18, d_2_20                            ;
        addi x18, x18, 8                          ;
        amoadd.w x8, x11, (x18)                   ;
_l118:  la x2, d_1_18                             ;
        addi x2, x2, -4                           ;
        amoor.w x28, x25, (x2)                    ;
_l119:  la x26, d_1_25                            ;
        addi x26, x26, 16                         ;
        amoxor.d x19, x21, (x26)                  ;
_l120:  la x22, d_0_13                            ;
        srai x22, x22, 1                          ;
        csrrc x28, pmpaddr6, x22                  ;
_l121:  fmv.w.x f6, x13                           ;
_l122:  la x25, d_0_1                             ;
        addi x25, x25, 0                          ;
        amomaxu.w x28, x27, (x25)                 ;
_l123:  addw x19, x0, x20                         ;
_l124:  la x8, _l111                              ;
        lb x20, -3(x8)                            ;
_l125:  la x6, d_5_8                              ;
        addi x6, x6, -8                           ;
        amomaxu.d x25, x2, (x6)                   ;
_l126:  slliw x17, x30, 8                         ;
_l127:  fcvt.wu.s x26, f11, rtz                   ;
_l128:  lui x0, 2                                 ;
_l129:  srliw x3, x9, 31                          ;
_l130:  la x19, d_4_9                             ;
        lh x2, -8(x19)                            ;
_l131:  fcvt.lu.s x30, f7, rup                    ;
_l132:  fadd.s f29, f8, f10, rmm                  ;
_l133:  csrrsi x8, pmpaddr7, 7                    ;
_l134:  divw x3, x6, x3                           ;
_l135:  la x7, d_2_11                             ;
        lui x18, 0xffe00                          ;
        xor x7, x7, x18                           ;
        flw f0, -24(x7)                           ;
_l136:  xor x3, x3, x3                            ;
        addi x18, zero, 1                         ;
        slli x18, x18, 19                         ;
        add x3, x3, x18                           ;
        addi x8, zero, 1                          ;
        slli x8, x8, 16                           ;
        add x3, x3, x8                            ;
        csrrs x18, sie, x3                        ;
_l137:  srli x7, x6, 43                           ;
_l138:  csrrwi x23, mscratch, 22                  ;
_l139:  la x28, d_4_2                             ;
        lwu x5, 4(x28)                            ;
_l140:  sraiw x27, x30, 2                         ;
_l141:  csrrci x5, pmpaddr5, 12                   ;
_l142:  subw x12, x27, x2                         ;
_l143:  la x20, d_5_9                             ;
        addi x20, x20, -24                        ;
        sc.w x30, x14, (x20)                      ;
_l144:  slliw x2, x10, 6                          ;
_l145:  sraw x23, x28, x11                        ;
_l146:  divuw x23, x1, x19                        ;
_l147:  srliw x21, x29, 22                        ;
_l148:  la x22, d_5_20                            ;
        addi x22, x22, -0                         ;
        lui x25, 0xffe00                          ;
        xor x22, x22, x25                         ;
        amoswap.w x10, x25, (x22)                 ;
_l149:  la x4, _l12                               ;
        flw f14, -8(x4)                           ;
_l150:  la x30, d_3_11                            ;
        addi x30, x30, 12                         ;
        amoor.w x3, x28, (x30)                    ;
_l151:  la x26, d_4_8                             ;
        addi x26, x26, -8                         ;
        amoadd.w x20, x6, (x26)                   ;
_l152:  la x12, d_5_25                            ;
        lb x30, 6(x12)                            ;
_l153:  la x12, d_3_21                            ;
        addi x12, x12, 0                          ;
        amomin.d x17, x14, (x12)                  ;
_l154:  div x10, x22, x10                         ;
_l155:  li x27, 1                                 ;
        la x15, pt2                               ;
        addi x15, x15, 48                         ;
        sfence.vma x27, x15                       ;
_l156:  fcvt.s.w f22, x16, rdn                    ;
_l157:  la x25, d_5_1                             ;
        addi x25, x25, -0                         ;
        amoor.w x11, x25, (x25)                   ;
_l158:  fclass.s x23, f20                         ;
_l159:  xor x17, x17, x17                         ;
        addi x21, zero, 3                         ;
        slli x21, x21, 23                         ;
        add x17, x17, x21                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 29                         ;
        add x17, x17, x18                         ;
        addi x4, zero, 3                          ;
        slli x4, x4, 12                           ;
        add x17, x17, x4                          ;
        csrrw x25, mhartid, x17                   ;
_l160:  la x22, d_4_12                            ;
        addi x22, x22, -28                        ;
        amominu.w x8, x4, (x22)                   ;
_l161:  fmin.s f24, f7, f26                       ;
_l162:  divu x18, x26, x7                         ;
_l163:  la x18, d_1_18                            ;
        addi x18, x18, 16                         ;
        amoand.d x12, x11, (x18)                  ;
_l164:  srai x16, x30, 16                         ;
_l165:  fdiv.s f24, f6, f5, rup                   ;
_l166:  fmv.w.x f30, x10                          ;
_l167:  xori x16, x16, -12                        ;
_l168:  la x20, d_3_9                             ;
        addi x20, x20, -0                         ;
        sc.d x11, x20, (x20)                      ;
_l169:  srli x9, x17, 0                           ;
_l170:  la x3, d_1_13                             ;
        addi x3, x3, 4                            ;
        amomax.w x26, x20, (x3)                   ;
_l171:  la x24, d_3_2                             ;
        addi x24, x24, 16                         ;
        amoadd.d x7, x5, (x24)                    ;
_l172:  fmv.w.x f14, x20                          ;
_l173:  la x19, d_5_5                             ;
        sd x9, 8(x19)                             ;
_l174:  fcvt.s.l f28, x15, rtz                    ;
_l175:  la x8, d_1_20                             ;
        addi x8, x8, -4                           ;
        lui x19, 0xffe00                          ;
        xor x8, x8, x19                           ;
        amomaxu.w x14, x19, (x8)                  ;
_l176:  fsgnjn.s f14, f14, f22                    ;
_l177:  la x16, d_4_21                            ;
        addi x16, x16, -8                         ;
        amoor.d x6, x14, (x16)                    ;
_l178:  andi x17, x14, 0                          ;
_l179:  la x15, d_4_18                            ;
        lh x19, 2(x15)                            ;
_l180:  divu x27, x20, x16                        ;
_l181:  fsqrt.s f15, f19, rup                     ;
_l182:  sraw x28, x10, x30                        ;
_l183:  la x21, d_0_2                             ;
        addi x21, x21, 0                          ;
        amoswap.d x15, x24, (x21)                 ;
_l184:  fcvt.w.s x15, f16, dyn                    ;
_l185:  la x26, d_3_8                             ;
        addi x26, x26, -0                         ;
        amomaxu.w x23, x10, (x26)                 ;
_l186:  srlw x19, x21, x29                        ;
_l187:  la x28, _l183                             ;
        lh x10, -28(x28)                          ;
_l188:  la x16, d_3_27                            ;
        addi x16, x16, 8                          ;
        amoand.d x17, x4, (x16)                   ;
_l189:  la x12, d_0_1                             ;
        addi x12, x12, -0                         ;
        amoor.d x9, x13, (x12)                    ;
_l190:  divuw x22, x28, x27                       ;
_l191:  fsgnjn.s f15, f30, f28                    ;
_l192:  la x4, d_2_0                              ;
        addi x4, x4, -28                          ;
        amoand.w x25, x16, (x4)                   ;
_l193:  la x10, d_2_19                            ;
        addi x10, x10, -16                        ;
        amoadd.w x1, x10, (x10)                   ;
_l194:  fence                                     ;
_l195:  fcvt.s.lu f5, x16, rdn                    ;
_l196:  la x17, _l189                             ;
        lw x10, 16(x17)                           ;
_l197:  slti x23, x15, -603                       ;
_l198:  la x12, d_4_10                            ;
        sd x14, 0(x12)                            ;
_l199:  la x27, _l151                             ;
        lui x3, 0xffe00                           ;
        xor x27, x27, x3                          ;
        lhu x3, -28(x27)                          ;
_l200:;
        /* Fuzz main */
        /**/
// RVTEST_CODE_END
        ecall
        unimp
_end_main:
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp
        unimp

RVTEST_CODE_END

  .data

RVTEST_DATA_BEGIN

        .align 8
xreg_output_data:
reg_x0_output:  .dword 0x0000000000000000
reg_x1_output:  .dword 0x0000000000000000
reg_x2_output:  .dword 0x0000000000000000
reg_x3_output:  .dword 0x0000000000000000
reg_x4_output:  .dword 0x0000000000000000
reg_x5_output:  .dword 0x0000000000000000
reg_x6_output:  .dword 0x0000000000000000
reg_x7_output:  .dword 0x0000000000000000
reg_x8_output:  .dword 0x0000000000000000
reg_x9_output:  .dword 0x0000000000000000
reg_x10_output: .dword 0x0000000000000000
reg_x11_output: .dword 0x0000000000000000
reg_x12_output: .dword 0x0000000000000000
reg_x13_output: .dword 0x0000000000000000
reg_x14_output: .dword 0x0000000000000000
reg_x15_output: .dword 0x0000000000000000
reg_x16_output: .dword 0x0000000000000000
reg_x17_output: .dword 0x0000000000000000
reg_x18_output: .dword 0x0000000000000000
reg_x19_output: .dword 0x0000000000000000
reg_x20_output: .dword 0x0000000000000000
reg_x21_output: .dword 0x0000000000000000
reg_x22_output: .dword 0x0000000000000000
reg_x23_output: .dword 0x0000000000000000
reg_x24_output: .dword 0x0000000000000000
reg_x25_output: .dword 0x0000000000000000
reg_x26_output: .dword 0x0000000000000000
reg_x27_output: .dword 0x0000000000000000
reg_x28_output: .dword 0x0000000000000000
reg_x29_output: .dword 0x0000000000000000
reg_x30_output: .dword 0x0000000000000000
reg_x31_output: .dword 0x0000000000000000

        .align 8
freg_output_data:
reg_f0_output:  .dword 0x0000000000000000
reg_f1_output:  .dword 0x0000000000000000
reg_f2_output:  .dword 0x0000000000000000
reg_f3_output:  .dword 0x0000000000000000
reg_f4_output:  .dword 0x0000000000000000
reg_f5_output:  .dword 0x0000000000000000
reg_f6_output:  .dword 0x0000000000000000
reg_f7_output:  .dword 0x0000000000000000
reg_f8_output:  .dword 0x0000000000000000
reg_f9_output:  .dword 0x0000000000000000
reg_f10_output: .dword 0x0000000000000000
reg_f11_output: .dword 0x0000000000000000
reg_f12_output: .dword 0x0000000000000000
reg_f13_output: .dword 0x0000000000000000
reg_f14_output: .dword 0x0000000000000000
reg_f15_output: .dword 0x0000000000000000
reg_f16_output: .dword 0x0000000000000000
reg_f17_output: .dword 0x0000000000000000
reg_f18_output: .dword 0x0000000000000000
reg_f19_output: .dword 0x0000000000000000
reg_f20_output: .dword 0x0000000000000000
reg_f21_output: .dword 0x0000000000000000
reg_f22_output: .dword 0x0000000000000000
reg_f23_output: .dword 0x0000000000000000
reg_f24_output: .dword 0x0000000000000000
reg_f25_output: .dword 0x0000000000000000
reg_f26_output: .dword 0x0000000000000000
reg_f27_output: .dword 0x0000000000000000
reg_f28_output: .dword 0x0000000000000000
reg_f29_output: .dword 0x0000000000000000
reg_f30_output: .dword 0x0000000000000000
reg_f31_output: .dword 0x0000000000000000

        .align 8
csr_output_data:
ustatus_output:        .dword 0x0000000000000000                   
uie_output:            .dword 0x0000000000000000               
utvec_output:          .dword 0x0000000000000000                 
uscratch_output:       .dword 0x0000000000000000                    
uepc_output:           .dword 0x0000000000000000                
ucause_output:         .dword 0x0000000000000000                  
utval_output:          .dword 0x0000000000000000                 
uip_output:            .dword 0x0000000000000000               
fflags_output:         .dword 0x0000000000000000                 
frm_output:            .dword 0x0000000000000000               
fcsr_output:           .dword 0x0000000000000000                
sstatus_output:        .dword 0x0000000000000000                   
sedeleg_output:        .dword 0x0000000000000000                   
sideleg_output:        .dword 0x0000000000000000                   
sie_output:            .dword 0x0000000000000000               
stvec_output:          .dword 0x0000000000000000                 
scounteren_output:     .dword 0x0000000000000000 
sscratch_output:       .dword 0x0000000000000000                    
sepc_output:           .dword 0x0000000000000000                
scause_output:         .dword 0x0000000000000000                  
stval_output:          .dword 0x0000000000000000                 
sip_output:            .dword 0x0000000000000000               
satp_output:           .dword 0x0000000000000000                
mhartid_output:        .dword 0x0000000000000000                   
mstatus_output:        .dword 0x0000000000000000                   
medeleg_output:        .dword 0x0000000000000000                   
mideleg_output:        .dword 0x0000000000000000                   
mie_output:            .dword 0x0000000000000000               
mtvec_output:          .dword 0x0000000000000000                 
mcounteren_output:     .dword 0x0000000000000000     
mscratch_output:       .dword 0x0000000000000000                    
mepc_output:           .dword 0x0000000000000000                
mcause_output:         .dword 0x0000000000000000                  
mtval_output:          .dword 0x0000000000000000                 
mip_output:            .dword 0x0000000000000000               
pmpcfg0_output:        .dword 0x0000000000000000                   
pmpcfg1_output:        .dword 0x0000000000000000                   
pmpcfg2_output:        .dword 0x0000000000000000                   
pmpcfg3_output:        .dword 0x0000000000000000                   
pmpaddr0_output:       .dword 0x0000000000000000                    
pmpaddr1_output:       .dword 0x0000000000000000                    
pmpaddr2_output:       .dword 0x0000000000000000                    
pmpaddr3_output:       .dword 0x0000000000000000                    
pmpaddr4_output:       .dword 0x0000000000000000                    
pmpaddr5_output:       .dword 0x0000000000000000                    
pmpaddr6_output:       .dword 0x0000000000000000                    
pmpaddr7_output:       .dword 0x0000000000000000                    
pmpaddr8_output:       .dword 0x0000000000000000                    
pmpaddr9_output:       .dword 0x0000000000000000                    
pmpaddr10_output:      .dword 0x0000000000000000 
pmpaddr11_output:      .dword 0x0000000000000000 
pmpaddr12_output:      .dword 0x0000000000000000 
pmpaddr13_output:      .dword 0x0000000000000000 
pmpaddr14_output:      .dword 0x0000000000000000 
pmpaddr15_output:      .dword 0x0000000000000000 
mcycle_output:         .dword 0x0000000000000000     
minstret_output:       .dword 0x0000000000000000                    
mcycleh_output:        .dword 0x0000000000000000                   
minstreth_output:      .dword 0x0000000000000000         

RVTEST_DATA_END  

    .section .data.random0;
    .align  8;

_random_data0:
                .dword 0x69ff30dfaf6e74a8, 0x2b0232eb8a6a6014
                .dword 0xba33390a677bfa5d, 0xb3bb34a76a6a6329
d_0_0:          .dword 0xca01833c5feb7a67, 0x6727b85ec6bb4e96
d_0_1:          .dword 0x2ee8d6e92cc27e25, 0xa7929372562d79c4
d_0_2:          .dword 0x307e72ffb5b9b292, 0xd7520fb762597d0f
d_0_3:          .dword 0xe0d90f53f3326116, 0x9a38c7d7b9ea1334
d_0_4:          .dword 0x34dfb45a8ac70966, 0x02fdc3efef47f9e9
d_0_5:          .dword 0x90ec1aac92c927cb, 0xc5e965d155d37597
d_0_6:          .dword 0xa0de45348362d494, 0xd3596aff9cc84795
d_0_7:          .dword 0x7918f6425449f09d, 0xebf8bd5b11b7310f
d_0_8:          .dword 0xe9011950c6d35e76, 0x07175a0c6d8dd0d1
d_0_9:          .dword 0xd3ac043295757838, 0xe2707cb749f505c8
d_0_10:         .dword 0x598729430abc94cf, 0x49bb432b8d7f3a72
d_0_11:         .dword 0x33c959a2b60ee88f, 0x7129704996874f5c
d_0_12:         .dword 0x8f272cd3209212d1, 0x04c4cc46a4e1a00c
d_0_13:         .dword 0xb7a8cc8175e1c783, 0x8e122395080d0061
d_0_14:         .dword 0x2c55b119cd596c21, 0xf422d8081dc8644b
d_0_15:         .dword 0xbc8cd60738ddc786, 0xbcfe61e0295678c1
d_0_16:         .dword 0xdb099f01d52a53ad, 0x456c2b2fcf0edf4c
d_0_17:         .dword 0x429c6fd55b63fb23, 0xcc379c4b9ffc92ce
d_0_18:         .dword 0x726221f6a4d22822, 0xd19a16c84afca12d
d_0_19:         .dword 0x4c7d73358b5b2d54, 0xc5331021e5306bf9
d_0_20:         .dword 0x1a27d4e1ffb1ae62, 0x903aa6a51810f238
d_0_21:         .dword 0x4d9ef014d873197d, 0x7460f7c25a47ddd6
d_0_22:         .dword 0xa7dd6a585cf1bbee, 0x193686d96db6017d
d_0_23:         .dword 0x276ad4896dd97c93, 0x996e4e78db38f657
d_0_24:         .dword 0xe4285a37ab571f88, 0x5a7a8593794c1108
d_0_25:         .dword 0xc5b799dca5808d25, 0x58e041826a413dd8
d_0_26:         .dword 0xad9406525c1c6fc0, 0x05497847df2db5e4
d_0_27:         .dword 0xb01460505337f581, 0x06246dedcf2e2b5f
                .dword 0x605b16fd9c61a108, 0x114c03eda2aec2ac
                .dword 0x60286171e6013fbb, 0x2c13127829d1fd5b
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x42f6bdcc2d66f203, 0x63b1065f858dc105
                .dword 0x060ac5332a1748ee, 0x555504ae5803a002
d_1_0:          .dword 0x5bcc4d19797be1ad, 0xaf6e2bfc4b72c545
d_1_1:          .dword 0x735734963c89ff81, 0xbe3b55525c1f9632
d_1_2:          .dword 0x269a47bb0d60d3e0, 0xd6d0cdac1ea5f361
d_1_3:          .dword 0x6809ed7b561ad305, 0xdbc51986be15ea39
d_1_4:          .dword 0x9f154262537c8638, 0xc5f81a6b8cfa2d11
d_1_5:          .dword 0x7d9aafb928668f96, 0x02aea575a10082c1
d_1_6:          .dword 0x9d08420eeb1fac9d, 0xcc87ff4ba038def2
d_1_7:          .dword 0xc05cfc99d7473d49, 0xd6729c66c2f7268d
d_1_8:          .dword 0x5447f470121219d7, 0xd33623dd32ac38e7
d_1_9:          .dword 0xf4d89d31e484b532, 0x3954dc38e5e80ce3
d_1_10:         .dword 0x0bede9eebb28f6cd, 0x5b18dd8bdc32fc84
d_1_11:         .dword 0x70a78ed81e45fac1, 0x2a6b366979c5bc04
d_1_12:         .dword 0x2c903f32885197f5, 0x22ae059480868a7e
d_1_13:         .dword 0x354168d232f3cdf7, 0xa4e7af16e9989699
d_1_14:         .dword 0xa99bb78c6ab73792, 0x68d8cd0a25637a07
d_1_15:         .dword 0xf743ae3729489822, 0xf1d57482df1e2132
d_1_16:         .dword 0x78aad155751cafc8, 0xce849ebfc0aa29c6
d_1_17:         .dword 0x7af7205535a1040a, 0xd3591f5d47b49530
d_1_18:         .dword 0xf7ca40276c61d19c, 0x583afd4fcbec8a03
d_1_19:         .dword 0xc07f9a59dab6ab48, 0xf7ab2bdaedaf5d13
d_1_20:         .dword 0x2250943ef4f3bded, 0x36631f73e1603780
d_1_21:         .dword 0x2b9a9942e9c1ebf2, 0x83f6187a83dd67da
d_1_22:         .dword 0x97c3a4493cbb75d4, 0xac36f55e56810c53
d_1_23:         .dword 0x03bc3bb639672b47, 0x6122736fde3d4641
d_1_24:         .dword 0xe24791ee0c31345d, 0xcea5042bb4532a8c
d_1_25:         .dword 0x4480098b7998ec74, 0xd6f3c1469005b4b7
d_1_26:         .dword 0x049ea796d92d8415, 0x8af9f2827940ff3d
d_1_27:         .dword 0xafeca918e1462594, 0x747933daa3c336f0
                .dword 0x801347a03f2534d6, 0x66ac51d4cc684844
                .dword 0x275f92945ec4bfbe, 0x6f04938517339c91
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xafe31012bffba6aa, 0x02665bc509d78dd8
                .dword 0xfc0e430b8659de1d, 0x7ba7ba54b0d8a39e
d_2_0:          .dword 0x8f422e66dcbdc2ac, 0x1d159060ff22c218
d_2_1:          .dword 0x363d1087d2f1a94c, 0xaeb9e796034572ff
d_2_2:          .dword 0x37d856926455a13e, 0xbe49ab06898dcf12
d_2_3:          .dword 0x1cf6da127c08e4ac, 0xd2b057bac303e10a
d_2_4:          .dword 0xbcaefb68f30d8fba, 0x4091b7b17adf5eaf
d_2_5:          .dword 0x549e9bd794058a1a, 0x9f9fce6b353af955
d_2_6:          .dword 0x34cec19d94b76400, 0x7d57a3fedd18f5ef
d_2_7:          .dword 0x81f1d51dd06d8775, 0x69f2c81ad6d4227e
d_2_8:          .dword 0xc6153a44cc8917aa, 0x9db49bf97ac39f09
d_2_9:          .dword 0x18491634c2923c90, 0xd9e394008a6f1848
d_2_10:         .dword 0x520c12e637c2f19c, 0x4c4f587678d472af
d_2_11:         .dword 0xb72a790a833178ee, 0xc1289d509b82c70c
d_2_12:         .dword 0xca1e1bc88d2422c9, 0x4793bad0b37a7215
d_2_13:         .dword 0x51354afbecbe514c, 0xe1d56a7db2f6f908
d_2_14:         .dword 0xdca0483e721ac0b9, 0x4c05622b1befd244
d_2_15:         .dword 0x93775edabcdcd726, 0x435239e1a2b30d5f
d_2_16:         .dword 0xdbc5f96420974bd3, 0xe679dd4d65baec1b
d_2_17:         .dword 0x00fe2b3bf9b2339c, 0xdc7f71d0cb7a8ba4
d_2_18:         .dword 0x4249e235bff3412b, 0x2215f0f6fc376525
d_2_19:         .dword 0xa2b929104f239b4c, 0xc6eec4f2c4bac575
d_2_20:         .dword 0xe221a6ace198fffd, 0xc395c52ecaf3d431
d_2_21:         .dword 0x42a5542716e16f63, 0x315d9a44fb40ffd2
d_2_22:         .dword 0x17449ae84754576c, 0xcd57c1fdb80d083f
d_2_23:         .dword 0xbffc7afd22db807a, 0xe9f3c83cd49c1ed4
d_2_24:         .dword 0xe6a5ffb430dda271, 0x4bd0e65b59a58759
d_2_25:         .dword 0x817f6d1dbe6e2b7d, 0x85454d503d0ccb70
d_2_26:         .dword 0xa51a6ce8099882b2, 0x3eb3de03986097ed
d_2_27:         .dword 0x7f014f915448ba3a, 0x54413183423445d1
                .dword 0x597043eff390c778, 0x4df6b7498bd359a5
                .dword 0xa95d20b12c614c4b, 0xa1f3442f24fd6835
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xab12a4418def80de, 0x66ec816f2a1e7f02
                .dword 0x5b0dbfbbb45dd862, 0xd0160eb791ba3b49
d_3_0:          .dword 0xf605ad743a636734, 0xeb573a2882d7a469
d_3_1:          .dword 0x8f3148db039a120b, 0xac2b44ec23e077a3
d_3_2:          .dword 0x710d01f2ce101df5, 0x8cfab29051bd0daa
d_3_3:          .dword 0xa54a73b67c5aca46, 0x2e9b60657c35d9a0
d_3_4:          .dword 0x94c4826268080153, 0x0408871fca3da4f3
d_3_5:          .dword 0x417cb86225bf38b9, 0x56d7e5ee6e609015
d_3_6:          .dword 0xd185c90443c853dd, 0xe18f45c1eb0cd27b
d_3_7:          .dword 0x3e70c760f0af661e, 0x4c45f3493a2a70e5
d_3_8:          .dword 0xb9354626a2f218fc, 0x5e65ac49f19890b0
d_3_9:          .dword 0x0fee30df7e84c57f, 0x807cae69eb2b405a
d_3_10:         .dword 0xb7375f506dc97074, 0x766f0dfcbe21ed20
d_3_11:         .dword 0x89e6ed494a6759f5, 0x13beb9035544fb39
d_3_12:         .dword 0x8098c0f8b728c4ae, 0xd685b403d9a6e966
d_3_13:         .dword 0xe823a3abb4749dff, 0xffdbed32cf0f7239
d_3_14:         .dword 0x9076802b0fece312, 0xe08d3434a858b7e2
d_3_15:         .dword 0xa35d1955e910a707, 0x98697f78ffa0fb75
d_3_16:         .dword 0xd67e5d105085d5cb, 0x485c10e2fe2c31e8
d_3_17:         .dword 0xe88b2730bf0e3ff4, 0x2984e66b9806d9a6
d_3_18:         .dword 0x0b6c01702452b3dd, 0x2eae0c6a600a7f0b
d_3_19:         .dword 0xc7ac119000bb0a85, 0xc481fc6ff720a9ab
d_3_20:         .dword 0xd7e0fef90017455e, 0x98599593a51b5316
d_3_21:         .dword 0x14a55070145e2141, 0x0ab3e45bc1dad0dd
d_3_22:         .dword 0xc6f32d8a9a9e858a, 0xf81333dba2c23af3
d_3_23:         .dword 0x8d8bd8bee95c581e, 0x902caf6d874638d3
d_3_24:         .dword 0x710382637b2e843d, 0x03ce74776397b48b
d_3_25:         .dword 0xd26b22a84166b1cb, 0xc5937e81d0977558
d_3_26:         .dword 0xea8ad7601ec46c6c, 0x11af7d51482b9b7c
d_3_27:         .dword 0x12149199a005d36b, 0x812e40358651a44a
                .dword 0xfdc3651f691da0e1, 0xcf0626530176dadc
                .dword 0x2d53e9dde68d932d, 0x5af9b5c96e0d1bbc
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xecacb97f76f571c3, 0xc4d875ff7e39e2be
                .dword 0x7a89431536324d4f, 0x823f23b2b56542a9
d_4_0:          .dword 0xcd49381185a3d85d, 0x88a6a23ca75a4026
d_4_1:          .dword 0x4b28eaeb450ed7b1, 0x2d7677a8ebab4a39
d_4_2:          .dword 0x6c8eb08a6555d4b0, 0xed7c3344db9c3755
d_4_3:          .dword 0x12440ecf2aab30f7, 0x598c8b23556653e7
d_4_4:          .dword 0xa04a3b882612a069, 0x74e63743c413a4ac
d_4_5:          .dword 0xe181f30869eb1866, 0x64e78e06bc39800c
d_4_6:          .dword 0x4e36318c8589150c, 0xb46644b3030cc82b
d_4_7:          .dword 0x2d8a4f9f553cbb29, 0x0986752a0f368c2a
d_4_8:          .dword 0x1cf30bdf3e50d816, 0xc822bf18df04001f
d_4_9:          .dword 0x8dec647c5e5b889d, 0x287e3b3993e5c3bc
d_4_10:         .dword 0xee53df7dd192e218, 0xd91c13c1ca9e4049
d_4_11:         .dword 0x37d3bf035da8649d, 0xffb8451cead8e552
d_4_12:         .dword 0x73a7f5eda20a5dd1, 0x1906f6276f5565c8
d_4_13:         .dword 0x729e3f87beb4b75e, 0x862b7495adf7817f
d_4_14:         .dword 0xe49b11096b0ec421, 0x72d300c492a124fe
d_4_15:         .dword 0x443c297c11863b58, 0x1b6f39db9e8a1152
d_4_16:         .dword 0xd51af160178c4acc, 0xe1fe5e1091a444ea
d_4_17:         .dword 0xc3d4615a599168a1, 0xbb83bd81e0728621
d_4_18:         .dword 0xfb8a41fa9f307002, 0xbb251a6bcd405a9c
d_4_19:         .dword 0x98be2c6f4544e8fc, 0x532a9ea1cf0dc222
d_4_20:         .dword 0x7f174a67139072c8, 0x22cab2cc3115b7ad
d_4_21:         .dword 0x9e134767da8e85c2, 0x34bbf7c90cdd1bce
d_4_22:         .dword 0x535ef5cdd3930236, 0xe6792859a2293847
d_4_23:         .dword 0xb827b6865becebab, 0x65ad57d5a965abe9
d_4_24:         .dword 0x4c593d86a22ee61b, 0x43335f49ddbe4bb1
d_4_25:         .dword 0x881854321fbd54c3, 0x914a2cf9682a4c16
d_4_26:         .dword 0xef9851f3a4f0f978, 0x600b553f22e9051c
d_4_27:         .dword 0xe8aa314aac099537, 0xd71a457ec21d1a70
                .dword 0xd4d52a83f487fd17, 0x118c5174943f9310
                .dword 0x49a83f462b21847f, 0x93fe609e4f938214
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x3e985d9cab438e0a, 0x4a99b483343a94a5
                .dword 0x725d2ba7d913b824, 0x8ea03af15bb6a524
d_5_0:          .dword 0xb686e7e787733aab, 0x4cd24797bc902fd3
d_5_1:          .dword 0x4761325090c23d83, 0x05d7f8688f93ff37
d_5_2:          .dword 0x71776eb259e775bb, 0x5eeae11bfe36aaa6
d_5_3:          .dword 0x270e379c192aadee, 0x87c1918d0710870d
d_5_4:          .dword 0x00cfa38601d40cc2, 0x799ae45db715d7d2
d_5_5:          .dword 0x04faefcf372f2956, 0x26fb2bcc32e43ffa
d_5_6:          .dword 0x892bda832bae09b8, 0xf50f8d4ee9b96f6e
d_5_7:          .dword 0x3245f44823133957, 0x34801f085f648133
d_5_8:          .dword 0xaa4f771951f0f806, 0xc65f33596120f6b0
d_5_9:          .dword 0x6858fd8aa0efcbe5, 0xc2ba7d3bb9f2190a
d_5_10:         .dword 0x9adc040dd59558d3, 0xf3970bef2ad2d287
d_5_11:         .dword 0xd370bfcd5f75431a, 0x65307e4939f5c7ec
d_5_12:         .dword 0x32bd8393f68476fd, 0xfc2bf0900f8c4c3d
d_5_13:         .dword 0xf1943631a1da17c9, 0x0d3877fb58604810
d_5_14:         .dword 0xb60fd8b6f324be54, 0x9e0abf13277ff79d
d_5_15:         .dword 0x19000a43619efbc0, 0x9ca3e6deb618b70d
d_5_16:         .dword 0x45da9091e1cb4eba, 0x68789d64899ec007
d_5_17:         .dword 0xb88d65a0726c74ab, 0x3e834f97d9f1446e
d_5_18:         .dword 0x3226243970f9c522, 0x6e685bf2832e2dad
d_5_19:         .dword 0x9f79e0a534f31f64, 0x1582a207ba3c7f29
d_5_20:         .dword 0x2f21b4f1430fef2e, 0xe6c41e5457dff92a
d_5_21:         .dword 0x30e87940044df59e, 0x543150cc5eb753a1
d_5_22:         .dword 0xfab2b346832725bd, 0xb6d4b41d1bf89acd
d_5_23:         .dword 0x2e04dd46b20eb8d3, 0xb15ec7849b66a7a8
d_5_24:         .dword 0x6f3830a5130c4509, 0x91cc89e59ee1f0f7
d_5_25:         .dword 0xa87ff761cbfe2b58, 0x42513cf4804125fa
d_5_26:         .dword 0x07c2ed9342e16ac5, 0xf76dc6bd39bda501
d_5_27:         .dword 0x1081e3f7f6f55c92, 0xb2df61d65b0ac244
                .dword 0x1e6feeadc7378480, 0xcb351fe523231191
                .dword 0xab4b219e3e908c91, 0x877180083808426e
         /* Random data */
_end_data5:
              
 
