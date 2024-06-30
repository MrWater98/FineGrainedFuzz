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
_p0:    csrrci x12, pmpaddr6, 0                   ;
_p1:    csrrwi x13, sscratch, 21                  ;
_p2:    xor x13, x13, x13                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 24                         ;
        add x13, x13, x13                         ;
        csrrs x11, mscratch, x13                  ;
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
_s0:    la x21, d_5_27                            ;
        sb x13, 4(x21)                            ;
_s1:    slli x25, x18, 1                          ;
_s2:    divw x12, x28, x0                         ;
_s3:    bgeu x30, x28, _s4                        ;
_s4:    sllw x22, x2, x19                         ;
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
_l0:    lui x26, 193659                           ;
_l1:    mulh x28, x23, x19                        ;
_l2:    remw x20, x24, x9                         ;
_l3:    srliw x23, x24, 5                         ;
_l4:    la x11, d_0_21                            ;
        addi x11, x11, 24                         ;
        amomaxu.w x16, x21, (x11)                 ;
_l5:    xori x17, x12, 26                         ;
_l6:    la x5, d_3_11                             ;
        addi x5, x5, -0                           ;
        amoadd.d x16, x12, (x5)                   ;
_l7:    srli x11, x19, 7                          ;
_l8:    la x11, d_2_18                            ;
        addi x11, x11, 28                         ;
        amomaxu.w x20, x8, (x11)                  ;
_l9:    fle.s x16, f10, f5                        ;
_l10:   la x5, _l72                               ;
        lh x30, 10(x5)                            ;
_l11:   blt x23, x2, _l191                        ;
_l12:   fnmadd.s f9, f9, f9, f9, rne              ;
_l13:   jal x13, _l84                             ;
_l14:   la x15, d_5_24                            ;
        addi x15, x15, 12                         ;
        sc.w x29, x3, (x15)                       ;
_l15:   fence.i                                   ;
_l16:   csrrci x3, sie, 2                         ;
_l17:   fcvt.s.lu f15, x3, rmm                    ;
_l18:   slli x13, x15, 5                          ;
_l19:   la x27, d_1_16                            ;
        lh x30, -4(x27)                           ;
_l20:   fcvt.s.lu f27, x23, rdn                   ;
_l21:   la x28, d_3_5                             ;
        addi x28, x28, -16                        ;
        amoor.d x26, x12, (x28)                   ;
_l22:   la x6, _l156                              ;
        lw x8, 16(x6)                             ;
_l23:   mulhsu x14, x19, x27                      ;
_l24:   la x18, d_0_6                             ;
        addi x18, x18, -16                        ;
        lui x4, 0xffe00                           ;
        xor x18, x18, x4                          ;
        amoor.d x3, x4, (x18)                     ;
_l25:   fle.s x11, f19, f16                       ;
_l26:   la x11, d_4_13                            ;
        addi x11, x11, 0                          ;
        lr.d x13, (x11)                           ;
_l27:   la x12, d_4_16                            ;
        addi x12, x12, 0                          ;
        amoor.w x14, x2, (x12)                    ;
_l28:   divuw x18, x23, x18                       ;
_l29:   la x30, d_0_7                             ;
        addi x30, x30, 8                          ;
        amoand.d x11, x11, (x30)                  ;
_l30:   bne x7, x29, _l118                        ;
_l31:   fmv.w.x f25, x9                           ;
_l32:   fmv.w.x f6, x13                           ;
_l33:   la x3, d_5_10                             ;
        lwu x11, -4(x3)                           ;
_l34:   fsgnj.s f0, f6, f19                       ;
_l35:   fcvt.w.s x30, f12, rup                    ;
_l36:   rem x17, x8, x15                          ;
_l37:   mul x5, x1, x17                           ;
_l38:   li x5, 1                                  ;
        la x13, pt2                               ;
        addi x13, x13, 8                          ;
        sfence.vma x5, x13                        ;
_l39:   ecall                                     ;
_l40:   la x2, _l103                              ;
        csrrw zero, mepc, x2                      ;
        mret                                      ;
_l41:   mul x12, x1, x1                           ;
_l42:   li x17, 0                                 ;
        la x1, pt3                                ;
        addi x1, x1, 40                           ;
        sfence.vma x17, x1                        ;
_l43:   la x8, d_1_19                             ;
        addi x8, x8, -24                          ;
        sc.w x29, x24, (x8)                       ;
_l44:   la x19, _l151                             ;
        jalr x24, 0(x19)                          ;
_l45:   fcvt.s.w f17, x13, rup                    ;
_l46:   la x13, d_4_13                            ;
        addi x13, x13, 8                          ;
        lr.w x9, (x13)                            ;
_l47:   slliw x7, x14, 8                          ;
_l48:   fmsub.s f17, f29, f5, f15, rne            ;
_l49:   la x1, _l88                               ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l50:   la x7, d_3_21                             ;
        srai x7, x7, 1                            ;
        csrrs x24, pmpaddr6, x7                   ;
_l51:   fadd.s f21, f15, f13, dyn                 ;
_l52:   la x25, d_5_24                            ;
        addi x25, x25, -0                         ;
        amoswap.d x26, x10, (x25)                 ;
_l53:   la x22, d_0_24                            ;
        addi x22, x22, 0                          ;
        amoadd.w x5, x15, (x22)                   ;
_l54:   mulh x7, x4, x19                          ;
_l55:   mulw x19, x28, x12                        ;
_l56:   fadd.s f11, f14, f0, rup                  ;
_l57:   slliw x6, x11, 7                          ;
_l58:   feq.s x13, f26, f11                       ;
_l59:   fcvt.lu.s x10, f11, rtz                   ;
_l60:   csrrsi x4, mepc, 28                       ;
_l61:   fmadd.s f30, f10, f13, f5, rdn            ;
_l62:   la x6, d_0_23                             ;
        lbu x12, -9(x6)                           ;
_l63:   bge x27, x11, _l80                        ;
_l64:   la x25, d_1_4                             ;
        addi x25, x25, -28                        ;
        lui x27, 0xffe00                          ;
        xor x25, x25, x27                         ;
        amomax.w x1, x27, (x25)                   ;
_l65:   fcvt.wu.s x13, f13, dyn                   ;
_l66:   la x2, d_3_21                             ;
        addi x2, x2, -8                           ;
        amomaxu.d x12, x27, (x2)                  ;
_l67:   auipc x0, 858513                          ;
_l68:   slli x14, x28, 13                         ;
_l69:   la x14, d_2_25                            ;
        addi x14, x14, -24                        ;
        amoxor.w x4, x17, (x14)                   ;
_l70:   la x14, d_0_17                            ;
        addi x14, x14, 24                         ;
        lr.w x27, (x14)                           ;
_l71:   mul x30, x24, x13                         ;
_l72:   remw x14, x24, x12                        ;
_l73:   la x30, d_5_6                             ;
        lbu x29, -22(x30)                         ;
_l74:   la x11, d_2_15                            ;
        addi x11, x11, 0                          ;
        lui x16, 0xffe00                          ;
        xor x11, x11, x16                         ;
        amominu.w x26, x16, (x11)                 ;
_l75:   remw x19, x6, x6                          ;
_l76:   fnmadd.s f2, f25, f14, f21, rdn           ;
_l77:   blt x1, x28, _l114                        ;
_l78:   la x30, d_2_17                            ;
        addi x30, x30, -0                         ;
        sc.d x11, x30, (x30)                      ;
_l79:   la x7, d_3_27                             ;
        addi x7, x7, -8                           ;
        amoxor.w x11, x26, (x7)                   ;
_l80:   blt x17, x1, _l86                         ;
_l81:   la x21, d_4_11                            ;
        ld x12, 8(x21)                            ;
_l82:   la x14, d_4_1                             ;
        addi x14, x14, 20                         ;
        lui x29, 0xffe00                          ;
        xor x14, x14, x29                         ;
        sc.w x28, x29, (x14)                      ;
_l83:   la x24, d_5_17                            ;
        addi x24, x24, 28                         ;
        lr.w x28, (x24)                           ;
_l84:   la x12, _l43                              ;
        lui x23, 0xffe00                          ;
        xor x12, x12, x23                         ;
        flw f0, -28(x12)                          ;
_l85:   csrrsi x25, frm, 0                        ;
_l86:   fmv.w.x f16, x12                          ;
_l87:   la x14, d_1_13                            ;
        addi x14, x14, -0                         ;
        amoand.w x14, x27, (x14)                  ;
_l88:   fcvt.w.s x16, f8, rmm                     ;
_l89:   la x20, d_0_22                            ;
        sd x11, -0(x20)                           ;
_l90:   xor x30, x30, x30                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 29                         ;
        add x30, x30, x22                         ;
        csrrc x19, mscratch, x30                  ;
_l91:   la x13, d_0_21                            ;
        flw f16, 8(x13)                           ;
_l92:   divu x27, x2, x23                         ;
_l93:   la x20, d_5_11                            ;
        addi x20, x20, -16                        ;
        amomax.d x23, x1, (x20)                   ;
_l94:   la x27, d_3_23                            ;
        flw f13, -20(x27)                         ;
_l95:   la x23, _l139                             ;
        jalr x25, 0(x23)                          ;
_l96:   la x25, d_4_0                             ;
        addi x25, x25, -8                         ;
        lui x7, 0xffe00                           ;
        xor x25, x25, x7                          ;
        amomin.w x8, x7, (x25)                    ;
_l97:   ecall                                     ;
_l98:   la x22, d_5_17                            ;
        addi x22, x22, -20                        ;
        sc.w x14, x28, (x22)                      ;
_l99:   la x24, _l136                             ;
        csrrw zero, mepc, x24                     ;
        mret                                      ;
_l100:  fmin.s f27, f12, f6                       ;
_l101:  la x14, d_5_21                            ;
        lui x15, 0xffe00                          ;
        xor x14, x14, x15                         ;
        lh x20, -30(x14)                          ;
_l102:  fcvt.w.s x8, f23, rmm                     ;
_l103:  fcvt.wu.s x9, f26, rne                    ;
_l104:  sltiu x9, x21, -0                         ;
_l105:  la x3, d_1_21                             ;
        sb x18, -3(x3)                            ;
_l106:  la x27, d_2_27                            ;
        sb x1, -31(x27)                           ;
_l107:  div x2, x18, x4                           ;
_l108:  srai x6, x29, 58                          ;
_l109:  la x3, d_5_0                              ;
        addi x3, x3, 0                            ;
        amoswap.d x15, x5, (x3)                   ;
_l110:  div x17, x15, x18                         ;
_l111:  fcvt.lu.s x18, f29, dyn                   ;
_l112:  fcvt.s.wu f17, x15, rdn                   ;
_l113:  la x1, d_5_27                             ;
        lui x7, 0xffe00                           ;
        xor x1, x1, x7                            ;
        ld x14, -8(x1)                            ;
_l114:  slli x2, x5, 48                           ;
_l115:  srai x3, x5, 63                           ;
_l116:  subw x6, x1, x9                           ;
_l117:  sraw x24, x8, x20                         ;
_l118:  csrrci x30, sie, 4                        ;
_l119:  bge x18, x9, _l180                        ;
_l120:  remw x7, x10, x20                         ;
_l121:  la x21, d_0_1                             ;
        lwu x3, 12(x21)                           ;
_l122:  la x29, d_3_6                             ;
        addi x29, x29, -12                        ;
        sc.w x9, x4, (x29)                        ;
_l123:  la x9, d_5_25                             ;
        addi x9, x9, 16                           ;
        sc.d x1, x9, (x9)                         ;
_l124:  remw x20, x21, x26                        ;
_l125:  la x29, d_0_4                             ;
        addi x29, x29, 16                         ;
        amoor.d x13, x4, (x29)                    ;
_l126:  fsub.s f22, f7, f0, rmm                   ;
_l127:  fclass.s x13, f27                         ;
_l128:  div x4, x3, x28                           ;
_l129:  la x28, d_5_3                             ;
        sw x27, -8(x28)                           ;
_l130:  ebreak                                    ;
_l131:  la x3, d_3_27                             ;
        addi x3, x3, 8                            ;
        amoand.d x29, x5, (x3)                    ;
_l132:  fnmsub.s f31, f4, f11, f16, rmm           ;
_l133:  fmsub.s f25, f9, f3, f20, dyn             ;
_l134:  subw x3, x4, x24                          ;
_l135:  fsgnj.s f30, f29, f25                     ;
_l136:  slliw x25, x24, 5                         ;
_l137:  la x19, d_4_15                            ;
        addi x19, x19, 8                          ;
        amoadd.d x23, x22, (x19)                  ;
_l138:  la x13, d_0_14                            ;
        addi x13, x13, 8                          ;
        amoswap.d x27, x14, (x13)                 ;
_l139:  la x9, d_0_17                             ;
        addi x9, x9, 0                            ;
        amomin.d x23, x16, (x9)                   ;
_l140:  la x26, d_3_22                            ;
        sw x13, -24(x26)                          ;
_l141:  fclass.s x5, f9                           ;
_l142:  la x3, d_0_7                              ;
        lb x18, -11(x3)                           ;
_l143:  slti x15, x2, -1627                       ;
_l144:  sltiu x26, x13, -785                      ;
_l145:  srai x29, x26, 39                         ;
_l146:  la x16, d_4_4                             ;
        sh x21, -24(x16)                          ;
_l147:  bltu x30, x8, _l196                       ;
_l148:  rem x3, x8, x10                           ;
_l149:  la x27, d_5_21                            ;
        addi x27, x27, -28                        ;
        amoand.w x20, x1, (x27)                   ;
_l150:  slliw x27, x24, 31                        ;
_l151:  srli x1, x17, 48                          ;
_l152:  divu x4, x15, x25                         ;
_l153:  la x17, d_2_18                            ;
        addi x17, x17, -16                        ;
        amomaxu.d x14, x21, (x17)                 ;
_l154:  la x23, _l46                              ;
        srai x23, x23, 1                          ;
        csrrs x3, pmpaddr2, x23                   ;
_l155:  sllw x25, x4, x29                         ;
_l156:  fnmsub.s f19, f2, f15, f2, rmm            ;
_l157:  la x15, d_2_26                            ;
        addi x15, x15, -16                        ;
        lui x16, 0xffe00                          ;
        xor x15, x15, x16                         ;
        sc.w x2, x16, (x15)                       ;
_l158:  la x18, d_5_25                            ;
        addi x18, x18, 16                         ;
        lui x23, 0xffe00                          ;
        xor x18, x18, x23                         ;
        amomin.d x14, x23, (x18)                  ;
_l159:  la x26, d_5_13                            ;
        addi x26, x26, -24                        ;
        amominu.d x22, x23, (x26)                 ;
_l160:  csrrsi x2, pmpaddr6, 17                   ;
_l161:  xor x24, x24, x24                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 6                          ;
        add x24, x24, x23                         ;
        csrrw x27, fflags, x24                    ;
_l162:  la x24, d_1_23                            ;
        addi x24, x24, 8                          ;
        amoadd.w x3, x10, (x24)                   ;
_l163:  la x20, d_0_12                            ;
        addi x20, x20, -8                         ;
        lui x3, 0xffe00                           ;
        xor x20, x20, x3                          ;
        lr.w x2, (x20)                            ;
_l164:  bge x10, x13, _l195                       ;
_l165:  la x18, d_0_14                            ;
        ld x2, -24(x18)                           ;
_l166:  fcvt.s.lu f17, x5, rmm                    ;
_l167:  la x14, d_2_23                            ;
        addi x14, x14, -8                         ;
        amoswap.d x7, x29, (x14)                  ;
_l168:  la x22, d_4_20                            ;
        addi x22, x22, -8                         ;
        amoswap.d x28, x3, (x22)                  ;
_l169:  mul x20, x21, x6                          ;
_l170:  addiw x1, x5, 152                         ;
_l171:  feq.s x24, f18, f3                        ;
_l172:  remu x9, x21, x2                          ;
_l173:  la x11, d_5_0                             ;
        sh x24, -16(x11)                          ;
_l174:  remu x17, x5, x10                         ;
_l175:  csrrsi x14, scause, 3                     ;
_l176:  la x19, d_4_5                             ;
        addi x19, x19, -24                        ;
        amomin.w x5, x27, (x19)                   ;
_l177:  la x27, d_0_17                            ;
        addi x27, x27, -4                         ;
        amominu.w x4, x15, (x27)                  ;
_l178:  la x2, d_3_9                              ;
        sh x24, -20(x2)                           ;
_l179:  remuw x29, x15, x4                        ;
_l180:  fence.i                                   ;
_l181:  fsgnjx.s f29, f21, f23                    ;
_l182:  la x12, d_4_20                            ;
        addi x12, x12, -4                         ;
        amomaxu.w x15, x8, (x12)                  ;
_l183:  sraw x30, x3, x13                         ;
_l184:  srai x0, x30, 36                          ;
_l185:  csrrci x29, pmpaddr2, 17                  ;
_l186:  srlw x26, x13, x13                        ;
_l187:  addw x12, x16, x1                         ;
_l188:  mulh x10, x1, x1                          ;
_l189:  la x21, d_5_17                            ;
        ld x15, 24(x21)                           ;
_l190:  mulw x0, x2, x22                          ;
_l191:  la x3, d_0_21                             ;
        flw f17, -8(x3)                           ;
_l192:  mulh x13, x10, x4                         ;
_l193:  fcvt.lu.s x24, f1, rne                    ;
_l194:  la x6, d_4_0                              ;
        lh x12, 16(x6)                            ;
_l195:  addw x13, x14, x27                        ;
_l196:  andi x19, x17, 1235                       ;
_l197:  xor x20, x20, x20                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 25                         ;
        add x20, x20, x13                         ;
        addi x28, zero, 1                         ;
        slli x28, x28, 26                         ;
        add x20, x20, x28                         ;
        csrrw x18, satp, x20                      ;
_l198:  la x11, d_3_2                             ;
        addi x11, x11, -16                        ;
        amomax.d x19, x30, (x11)                  ;
_l199:  la x22, _l200                             ;
        csrrw zero, uepc, x22                     ;
        uret                                      ;
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
                .dword 0xafac1ed7d5ff6348, 0xc501dce8f6826ced
                .dword 0x062d344d9ebb5c4d, 0xe96f7feaef4d08fc
d_0_0:          .dword 0xa45a2baed7a8c64f, 0xc8c17f267856171d
d_0_1:          .dword 0x832b09e15da28095, 0xa38d0bb0ee2032fd
d_0_2:          .dword 0xa911ea7d0b924375, 0x2920cd7fbd006e51
d_0_3:          .dword 0x1a8600d9a0514fb8, 0x8e005bde81b58ea6
d_0_4:          .dword 0xa0ebf49a707a68d5, 0x4d8b24866527f3cc
d_0_5:          .dword 0x56bbf0c17fedee76, 0x23af47fa0c85cba0
d_0_6:          .dword 0x264071abf165d68e, 0xdf01bbd7f9199884
d_0_7:          .dword 0x6912143a698b20ce, 0xd466640f9f1feb4e
d_0_8:          .dword 0x0d6a6b80181a7156, 0xa50df983b59091f8
d_0_9:          .dword 0x9d092aae57d96b37, 0x58b1e56740c3e209
d_0_10:         .dword 0x5216bc11f9281362, 0xdc013ee78c3fb918
d_0_11:         .dword 0x5c9dc448069fa2c1, 0x12359802058c2e95
d_0_12:         .dword 0x81421e7b2a16f44a, 0x1c90646036276486
d_0_13:         .dword 0x5ccd46bd5a8cf4be, 0x88ab682d26b3610d
d_0_14:         .dword 0x3c388e5f5d1b303a, 0xce8a109428575db6
d_0_15:         .dword 0x73b7df4cf2f96217, 0x6586a55ac1cdd5a8
d_0_16:         .dword 0x788ac3a4b68cfbab, 0x192b273bd30496a3
d_0_17:         .dword 0x8578607ee42b86db, 0xacff13207144e09c
d_0_18:         .dword 0xbcc95a3643a773c6, 0x8ab284f15b8800d2
d_0_19:         .dword 0xc47016b2ca2133fb, 0xabba8616afe6b62e
d_0_20:         .dword 0x1775c322d3da265b, 0x7ee36128ffe5a24a
d_0_21:         .dword 0x1f3d8fc9c8aebf8b, 0x8111ed473e0d40e5
d_0_22:         .dword 0xde117c1d27a3e6a9, 0x686011a2420a0cce
d_0_23:         .dword 0x1b452a815c1cc1c8, 0x17b496e0fcd42238
d_0_24:         .dword 0x0f0e07598969b77c, 0xfbaf4e66846e12ee
d_0_25:         .dword 0x0df63ec45facaa9e, 0xff69dd0f60b5f4f9
d_0_26:         .dword 0xa804da838342794d, 0xd2d0c476270f5fdb
d_0_27:         .dword 0xcbf3bb16cd72e486, 0x534f71a9ee91830d
                .dword 0x44f8f76f9d77d574, 0x0541c2b6c955a001
                .dword 0x1b1257b40bbfa2a2, 0xfc0d0545a0c53147
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x531831fcbc74446f, 0xa9c13387e9f72e43
                .dword 0xe2f1f6bb73490465, 0x95d2a1e02ae5fa90
d_1_0:          .dword 0xbcaeff6fe42e4697, 0x99c0f4ef37777cc5
d_1_1:          .dword 0x0b24865e83624600, 0x19e84934e4e4afe5
d_1_2:          .dword 0x7e797fe66d1679de, 0x49eabe4dc7d025e5
d_1_3:          .dword 0x841890db1b4fddfa, 0x174db86578b790e9
d_1_4:          .dword 0xa46dca200c111120, 0x293a08b039eec92a
d_1_5:          .dword 0xdf2fba542eb56654, 0xa05c96e3e386d53a
d_1_6:          .dword 0x4ca8e2f8b81b3387, 0xf638770e7f0b95bc
d_1_7:          .dword 0xfa28bb7e64aa67fd, 0x4c1607b671b085ab
d_1_8:          .dword 0x55b86287cf62a7ec, 0xffbf93f5d7690279
d_1_9:          .dword 0x90108ea2744be799, 0xf8b20bdb113e0bc2
d_1_10:         .dword 0x752150243175ef96, 0x3283c49d086ff0f5
d_1_11:         .dword 0x728328ddd0a58e53, 0xa932f18d6bcb06bc
d_1_12:         .dword 0xfb3ce4acd9acc327, 0x60317e7f3fbc8002
d_1_13:         .dword 0xba8589eb795bb9e4, 0x9cf5841ebec7e142
d_1_14:         .dword 0x74f23f2542d6ebb4, 0x11fd5e513a18e093
d_1_15:         .dword 0x4453306ebc5e59b7, 0x058462741497da58
d_1_16:         .dword 0xcaaa3e72f522473e, 0xde7935644b57fbf5
d_1_17:         .dword 0x502ff2ce254b8e71, 0x8d49de88992a9cf4
d_1_18:         .dword 0xf8ed5f91a1b63435, 0xce6cf14c0851fdd7
d_1_19:         .dword 0x26675ebb4ec2bcf1, 0x01253ffcbc211187
d_1_20:         .dword 0x0ffecb35c9b96f70, 0x59775f9c89036e10
d_1_21:         .dword 0x77b4c8ef3f2ba702, 0x8a124eb7cd2755ed
d_1_22:         .dword 0x626a8c4e9e0aec66, 0xf31abaa625aaf56d
d_1_23:         .dword 0x61294e07c4e918f9, 0xfea6a70a36e77cc0
d_1_24:         .dword 0x2a477dfcaec508ac, 0x6ac378419e846797
d_1_25:         .dword 0xc6a24627ceb7bae2, 0x734806d6a992bb0a
d_1_26:         .dword 0x03be3197d246321a, 0xaf63201d53db4191
d_1_27:         .dword 0x64708e18832625be, 0xf475f75bc16fbf74
                .dword 0x78dc446e16df6388, 0x8d4aee0d2dfd0d44
                .dword 0x049ec06a9d3302c5, 0xa7891833143562e0
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3278588162d0418d, 0xaa123fb891814035
                .dword 0x53934d5b47a55579, 0x3607622baf2ae723
d_2_0:          .dword 0xdbbc9ff51292ebe4, 0x347f2b3dc6b50d8b
d_2_1:          .dword 0x50c2053aba53cc82, 0x9c25bfaa9a9e6165
d_2_2:          .dword 0xc0b173034db0e51e, 0xdd801caebe3680b9
d_2_3:          .dword 0xc38d6d8eecbb4fa3, 0x12f66d4f7be7447e
d_2_4:          .dword 0x1e43c206319d7d03, 0x0d51610f7031d949
d_2_5:          .dword 0x31c572659d4a9cdd, 0xdc141f94d0e99172
d_2_6:          .dword 0x0b92721704b1de58, 0xcbf8e5a953bf009e
d_2_7:          .dword 0xe61815c8b1d0f4af, 0x0f6c61b1517219ee
d_2_8:          .dword 0xa25162267d5bb107, 0xc79be676feeb2cc8
d_2_9:          .dword 0x08649363e0fcef54, 0x8e81df3dcbbeee70
d_2_10:         .dword 0x798be5f1960dcec2, 0xb8d29bab49de8b3d
d_2_11:         .dword 0xc95d307b503e2799, 0xcfba16ec265ae13a
d_2_12:         .dword 0x67dcc52446ca41e1, 0xdc800f9f39611614
d_2_13:         .dword 0xbfad8aac9badd7c7, 0x64e5320d58bf9e7e
d_2_14:         .dword 0x6ab873e6f1037f0a, 0x3f334502322747d7
d_2_15:         .dword 0x68ca86bd99918074, 0x12f309f80bc7fd8c
d_2_16:         .dword 0x64cd726e9e4b28e5, 0xddc9fa57eed84b49
d_2_17:         .dword 0x16bd00e55e3e275f, 0xa43838b948dfc7e0
d_2_18:         .dword 0x668390a7392407bf, 0xa99117efd095a81a
d_2_19:         .dword 0x9bb7963132bf0c1d, 0xc47b470f569746b6
d_2_20:         .dword 0x515e5b19343ce8b9, 0xe510a61266777b56
d_2_21:         .dword 0x9645853d8c969d74, 0x4a5f2f3763df7d45
d_2_22:         .dword 0x7d30a5ad4848a965, 0xe3bc8c4423b67fec
d_2_23:         .dword 0x8a3cec5468c64561, 0x4dabf53bc35f0ada
d_2_24:         .dword 0x45419c5991e83a86, 0xd77101a230289161
d_2_25:         .dword 0x2a4f27fcbf449f65, 0x05bc89cdc833c813
d_2_26:         .dword 0x420cb86b2879785b, 0x3207ec98bf6d3a81
d_2_27:         .dword 0x19f9df3297d09575, 0xe3e32afa7a0f2062
                .dword 0xbd1adafd06df7bbf, 0xffbdaa0eeff8a182
                .dword 0x2abd2fd7437bac65, 0x4fd32f0134f16100
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xb93e9540bb258da2, 0xe910cdb9814c7f7f
                .dword 0xc15547449d3c16b4, 0x1ccb6d7ef334971a
d_3_0:          .dword 0x4e8c7429e380142c, 0x92282f766a026028
d_3_1:          .dword 0x16ad96976c4337e0, 0xe0cb416095316c78
d_3_2:          .dword 0x282f6745e676e229, 0x7c0071db13d970e4
d_3_3:          .dword 0x402c4a3b9ed96614, 0x841cefc880766711
d_3_4:          .dword 0x367384a66adb05f6, 0x2dc8ac3ad3f28072
d_3_5:          .dword 0x0e673a3464737a9c, 0x72a66db7271f6829
d_3_6:          .dword 0xe3e4cdf4b9f0be70, 0x34df5baf9810b3b2
d_3_7:          .dword 0x1e5e98a8199ab5a3, 0xa20b67f7b926e803
d_3_8:          .dword 0x9e7dde9ffb3f8717, 0x79c5d86e6796f881
d_3_9:          .dword 0x2893f93e58587b16, 0xc3c20d91020c38af
d_3_10:         .dword 0xd7fb7784c041a1ef, 0x4019569d59e0ca8d
d_3_11:         .dword 0xb829634049bd2c6b, 0x605ce12881bd0c84
d_3_12:         .dword 0x8a26545076d20279, 0x30c6297516745847
d_3_13:         .dword 0xfd730850fa4ee75c, 0x400c2aae923b1cd8
d_3_14:         .dword 0x90066d811dd5bafa, 0x6bc1a398dacb8483
d_3_15:         .dword 0xd354879a09a79d1a, 0x1b738891e8dcb84b
d_3_16:         .dword 0x807d9dfb74e14015, 0x55b81d7b681c7e64
d_3_17:         .dword 0x7cfa1c9bd312ad27, 0x8ca6e04824e732e1
d_3_18:         .dword 0x9d51a05d3f204b44, 0x8de404cd021351ee
d_3_19:         .dword 0xfbd1ca9f4612aee6, 0x4e43ec333e1e7221
d_3_20:         .dword 0xf247153c88dcbec4, 0x3503a3f0d64f0b5f
d_3_21:         .dword 0x5b4613f29cc6952a, 0x49f1e2553df2110e
d_3_22:         .dword 0x0cc0e141314641c5, 0x04c95d18f304e733
d_3_23:         .dword 0xf64b455a6670aca8, 0xcfba283fc6652b75
d_3_24:         .dword 0x64146b55bff610a4, 0x2aedab7ab40fc646
d_3_25:         .dword 0xeb11dba54fb95965, 0xbbfc0a2ce755c2dc
d_3_26:         .dword 0x192fa2e60b382fa7, 0x011d2b7d83a5daa6
d_3_27:         .dword 0xd8f817c57e672027, 0xe568f6af1a6ee82e
                .dword 0x88cc0e3efc386e01, 0x1128dc8a1c6a5b0b
                .dword 0xc3f0055ac55080e2, 0xe97fe5f75e8db20c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x90e84dd7f9b636be, 0x2df97f2fb1c777ff
                .dword 0xfbdc75f536e9a9fa, 0xe10e0d4a396b9644
d_4_0:          .dword 0x42e96798e22d8c88, 0x99234e64b2d7bcb2
d_4_1:          .dword 0xb3d16c9eb34b4681, 0x6bbb7f9e5786a86b
d_4_2:          .dword 0xfa35c247191b1dc7, 0x94b94408a4982a64
d_4_3:          .dword 0xaef3d5b393c4656a, 0xfa17780e12076b5e
d_4_4:          .dword 0x4a152d1950b95ddd, 0xc4cc359e0f86d867
d_4_5:          .dword 0x70ec995339f69787, 0x964e9d661c6a304f
d_4_6:          .dword 0x72beb122789b273a, 0xc6e657ce71f8d251
d_4_7:          .dword 0x84256e66dc08fb4e, 0x6c058fd228714bf2
d_4_8:          .dword 0xa67bae8a4a746c27, 0x1efe68806e3eeba5
d_4_9:          .dword 0x56b5391c952b9db7, 0x83e11fcae8c8b7c2
d_4_10:         .dword 0xee19a14ef72929e8, 0x313242187dcade9a
d_4_11:         .dword 0xbd5d164cdc8d8598, 0x034d32176f57156a
d_4_12:         .dword 0xdf90fe69096e0430, 0xf4983dc147541825
d_4_13:         .dword 0x80e11a67481113d9, 0x3c686ec94c6bb3b7
d_4_14:         .dword 0xc4c3cf56c4d9a9f9, 0x9323ec4dc305551c
d_4_15:         .dword 0xfc6610be5a731b1b, 0x18f431a7ce69663a
d_4_16:         .dword 0xc4c7a640077a4987, 0xa628592cf3654f34
d_4_17:         .dword 0xf3545ede32a6ce52, 0xf8322043cc8eb72b
d_4_18:         .dword 0x223ea69cb01d1ced, 0x5d50ff254935b4d6
d_4_19:         .dword 0x59fb815e49f8a610, 0x0b9886726eaa3426
d_4_20:         .dword 0x9bd0095b73855784, 0x765c232c5085a3c5
d_4_21:         .dword 0x0a1bcc3514a8ed0b, 0x5bc7319d9dd8a187
d_4_22:         .dword 0x5f0eda83bfe77034, 0xd88a811468435e36
d_4_23:         .dword 0x1d351029848aeaef, 0x234eef8d370eaa80
d_4_24:         .dword 0x5ef6c7d862e3d4bd, 0xb0f2fc943cd66256
d_4_25:         .dword 0xe72df852f330ec4e, 0x97b9711f28dfb6ef
d_4_26:         .dword 0xfc87c707523df4fc, 0x3403c4404e90ad9b
d_4_27:         .dword 0xef5d515ab58db803, 0xaa2e4821b80b00e9
                .dword 0xee613f0587d2de20, 0x888f8d70913525b1
                .dword 0xda6e3a213749df6b, 0xa16efd9bec491899
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x20a64731a337d684, 0x7eb97b2f9d353763
                .dword 0x0e1c3058b9c47b26, 0xff9e65ea807f5700
d_5_0:          .dword 0x93ba88a98284e1a5, 0x9cf08dfe88a9532f
d_5_1:          .dword 0xc955e6d9c3ef1df6, 0x37856e1767e2edea
d_5_2:          .dword 0x9542d1b79cb7f3ef, 0xf7d6fefd18c94716
d_5_3:          .dword 0xefb370e7648875d6, 0x672e639a936dec2b
d_5_4:          .dword 0x12f7a65604373d20, 0x860cdf6a65d86a04
d_5_5:          .dword 0x2175f28fe4dcb452, 0x70bf087d441c240f
d_5_6:          .dword 0xacc8e94aeb18d06c, 0xbad7af53c3c98310
d_5_7:          .dword 0x2293c4504c9df4a5, 0xf2f003102f14ae36
d_5_8:          .dword 0x990a9bf689c4bf0e, 0xcb95b0d4d2d38f5e
d_5_9:          .dword 0xbbac60ef18a8ef08, 0x3b37d337c26598e2
d_5_10:         .dword 0xa2f08cbbd95af8df, 0xd4f7fc76fa74416d
d_5_11:         .dword 0x28058356c1e133a8, 0x6124242bc26df3cc
d_5_12:         .dword 0x115343500e9634af, 0x419b38ffd661f1df
d_5_13:         .dword 0x1efa79428fb77fcc, 0x79c620a838d4d27f
d_5_14:         .dword 0xf121d2c765ea90ff, 0xd5d3da9fcd6c1960
d_5_15:         .dword 0xb6331d8001d3148c, 0x2be16841da31aa7f
d_5_16:         .dword 0xfa6f4d79e4b86794, 0x404e21ec162ae870
d_5_17:         .dword 0x48822d972cdce3fc, 0x5bccd8fc54524a13
d_5_18:         .dword 0xa609e4a72ffcc2d3, 0xe73643fa3e0a695b
d_5_19:         .dword 0x4a05f496d4f191a9, 0x13363cfda7ca17d5
d_5_20:         .dword 0xa24c9c5ced195f99, 0x619a0a1e401affb3
d_5_21:         .dword 0x735cfb136cefbda8, 0x9f94c8ea99043bc4
d_5_22:         .dword 0x546e14057567abf9, 0x2173f91d51d80081
d_5_23:         .dword 0x97470ce74a92e4e4, 0x86fcd34d37a7a589
d_5_24:         .dword 0x05c1e59e2c26473a, 0x27f501b339e01bca
d_5_25:         .dword 0x7a50ef5ba17a912e, 0x8c0bda9327929df4
d_5_26:         .dword 0x67997793c588ab87, 0x42339d2dc02341d7
d_5_27:         .dword 0x76a137bbf7f92034, 0x85b01625d22cd30b
                .dword 0x60db3f498d449486, 0xd25ffc704150f908
                .dword 0x49327bb114f2f787, 0x4e69cc338831d25d
         /* Random data */
_end_data5:
              
 
