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
_p0:    csrrsi x13, satp, 25                      ;
_p1:    la x14, d_3_24                            ;
        srai x14, x14, 1                          ;
        csrrc x13, pmpaddr3, x14                  ;
_p2:    csrrsi x11, pmpcfg0, 25                   ;
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
_s0:    rem x12, x11, x17                         ;
_s1:    fmul.s f20, f30, f14, dyn                 ;
_s2:    srliw x26, x18, 30                        ;
_s3:    la x18, d_5_23                            ;
        addi x18, x18, -24                        ;
        amoor.d x13, x27, (x18)                   ;
_s4:    subw x24, x18, x15                        ;
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
_l0:    la x11, d_1_19                            ;
        addi x11, x11, 24                         ;
        lr.d x27, (x11)                           ;
_l1:    la x10, d_5_16                            ;
        addi x10, x10, -20                        ;
        lr.w x10, (x10)                           ;
_l2:    la x19, d_2_7                             ;
        addi x19, x19, -8                         ;
        lui x24, 0xffe00                          ;
        xor x19, x19, x24                         ;
        amoadd.w x25, x24, (x19)                  ;
_l3:    bne x21, x14, _l64                        ;
_l4:    fcvt.l.s x26, f4, rmm                     ;
_l5:    bne x16, x10, _l137                       ;
_l6:    fmin.s f12, f21, f21                      ;
_l7:    la x5, d_5_16                             ;
        addi x5, x5, -0                           ;
        sc.d x16, x5, (x5)                        ;
_l8:    fclass.s x10, f20                         ;
_l9:    bltu x10, x20, _l136                      ;
_l10:   la x9, d_3_11                             ;
        addi x9, x9, -4                           ;
        amomin.w x20, x12, (x9)                   ;
_l11:   xori x21, x4, -0                          ;
_l12:   la x29, d_4_6                             ;
        addi x29, x29, -4                         ;
        amoadd.w x26, x26, (x29)                  ;
_l13:   la x25, d_5_22                            ;
        addi x25, x25, 8                          ;
        lr.d x29, (x25)                           ;
_l14:   auipc x25, 0                              ;
_l15:   la x22, d_4_3                             ;
        addi x22, x22, 0                          ;
        amoswap.d x20, x15, (x22)                 ;
_l16:   sllw x2, x5, x20                          ;
_l17:   la x19, d_4_13                            ;
        lui x3, 0xffe00                           ;
        xor x19, x19, x3                          ;
        lwu x9, 24(x19)                           ;
_l18:   li x14, 0                                 ;
        la x17, pt3                               ;
        addi x17, x17, 0                          ;
        sfence.vma x14, x17                       ;
_l19:   la x23, _l133                             ;
        lh x17, -0(x23)                           ;
_l20:   fdiv.s f21, f8, f20, rdn                  ;
_l21:   slli x14, x0, 1                           ;
_l22:   la x9, d_2_22                             ;
        lui x1, 0xffe00                           ;
        xor x9, x9, x1                            ;
        lbu x10, -0(x9)                           ;
_l23:   mulw x22, x24, x6                         ;
_l24:   fcvt.s.w f27, x9, rne                     ;
_l25:   fmin.s f16, f26, f4                       ;
_l26:   mulw x12, x26, x17                        ;
_l27:   la x3, d_4_24                             ;
        addi x3, x3, -0                           ;
        amomax.d x6, x29, (x3)                    ;
_l28:   fsub.s f12, f8, f30, rne                  ;
_l29:   la x25, d_0_27                            ;
        flw f26, 4(x25)                           ;
_l30:   la x22, d_3_26                            ;
        addi x22, x22, 8                          ;
        amoxor.w x12, x18, (x22)                  ;
_l31:   csrrci x13, sip, 13                       ;
_l32:   la x26, d_0_0                             ;
        addi x26, x26, 16                         ;
        amomaxu.d x22, x5, (x26)                  ;
_l33:   srliw x22, x27, 8                         ;
_l34:   andi x24, x7, -1399                       ;
_l35:   divw x2, x19, x28                         ;
_l36:   la x9, d_0_25                             ;
        addi x9, x9, 8                            ;
        lui x1, 0xffe00                           ;
        xor x9, x9, x1                            ;
        amomin.d x3, x1, (x9)                     ;
_l37:   csrrsi x15, pmpaddr7, 21                  ;
_l38:   la x12, _l158                             ;
        lb x2, -30(x12)                           ;
_l39:   la x11, _l132                             ;
        lh x13, 10(x11)                           ;
_l40:   la x12, d_2_1                             ;
        lh x7, -30(x12)                           ;
_l41:   mulhsu x5, x23, x24                       ;
_l42:   slli x15, x20, 22                         ;
_l43:   flt.s x10, f1, f0                         ;
_l44:   ori x27, x12, -550                        ;
_l45:   fcvt.w.s x12, f8, rne                     ;
_l46:   bge x30, x20, _l188                       ;
_l47:   sraiw x16, x13, 8                         ;
_l48:   fsgnjn.s f30, f9, f27                     ;
_l49:   bgeu x17, x20, _l151                      ;
_l50:   auipc x7, 961410                          ;
_l51:   la x25, _l83                              ;
        csrrw zero, mepc, x25                     ;
        mret                                      ;
_l52:   fcvt.l.s x20, f5, rup                     ;
_l53:   fclass.s x30, f8                          ;
_l54:   fsgnjx.s f1, f20, f11                     ;
_l55:   bge x19, x7, _l97                         ;
_l56:   subw x22, x6, x17                         ;
_l57:   fmax.s f21, f18, f10                      ;
_l58:   auipc x28, 970859                         ;
_l59:   la x23, d_3_15                            ;
        srai x23, x23, 1                          ;
        csrrs x7, pmpaddr5, x23                   ;
_l60:   csrrci x16, medeleg, 13                   ;
_l61:   divu x30, x7, x23                         ;
_l62:   flt.s x4, f25, f11                        ;
_l63:   la x3, d_4_21                             ;
        addi x3, x3, -8                           ;
        amomaxu.d x23, x20, (x3)                  ;
_l64:   la x5, d_1_13                             ;
        lb x2, 11(x5)                             ;
_l65:   fnmsub.s f3, f27, f28, f24, dyn           ;
_l66:   fnmsub.s f30, f3, f16, f15, dyn           ;
_l67:   jal x17, _l139                            ;
_l68:   li x7, 1                                  ;
        la x2, pt2                                ;
        addi x2, x2, 56                           ;
        sfence.vma x7, x2                         ;
_l69:   la x14, d_1_8                             ;
        addi x14, x14, 8                          ;
        lr.d x8, (x14)                            ;
_l70:   srai x24, x23, 63                         ;
_l71:   la x18, d_3_22                            ;
        addi x18, x18, 0                          ;
        lui x5, 0xffe00                           ;
        xor x18, x18, x5                          ;
        amomax.w x20, x5, (x18)                   ;
_l72:   fcvt.s.lu f19, x0, rtz                    ;
_l73:   la x18, d_2_24                            ;
        lhu x2, -30(x18)                          ;
_l74:   bge x13, x12, _l86                        ;
_l75:   ebreak                                    ;
_l76:   div x0, x19, x21                          ;
_l77:   srliw x30, x26, 19                        ;
_l78:   la x20, d_1_14                            ;
        addi x20, x20, 8                          ;
        lr.w x30, (x20)                           ;
_l79:   slli x12, x24, 29                         ;
_l80:   la x23, d_1_23                            ;
        addi x23, x23, 12                         ;
        amomin.w x2, x16, (x23)                   ;
_l81:   remu x3, x30, x4                          ;
_l82:   fcvt.lu.s x14, f30, rup                   ;
_l83:   la x30, d_0_5                             ;
        lb x13, -27(x30)                          ;
_l84:   la x20, _l159                             ;
        ld x10, -24(x20)                          ;
_l85:   la x23, d_3_13                            ;
        srai x23, x23, 1                          ;
        csrrs x1, pmpaddr1, x23                   ;
_l86:   la x8, d_4_16                             ;
        addi x8, x8, 16                           ;
        amoadd.w x6, x26, (x8)                    ;
_l87:   la x23, d_0_2                             ;
        addi x23, x23, -16                        ;
        lui x17, 0xffe00                          ;
        xor x23, x23, x17                         ;
        amomaxu.d x8, x17, (x23)                  ;
_l88:   xor x4, x4, x4                            ;
        addi x4, zero, 3                          ;
        slli x4, x4, 27                           ;
        add x4, x4, x4                            ;
        addi x17, zero, 3                         ;
        slli x17, x17, 13                         ;
        add x4, x4, x17                           ;
        csrrc x29, mcause, x4                     ;
_l89:   la x7, d_3_12                             ;
        addi x7, x7, 8                            ;
        amoand.d x26, x26, (x7)                   ;
_l90:   feq.s x29, f28, f24                       ;
_l91:   slliw x18, x22, 6                         ;
_l92:   fcvt.l.s x23, f7, rup                     ;
_l93:   fnmadd.s f22, f9, f24, f13, rne           ;
_l94:   la x6, d_1_6                              ;
        addi x6, x6, -0                           ;
        amomax.d x9, x2, (x6)                     ;
_l95:   la x13, d_5_21                            ;
        lw x14, 24(x13)                           ;
_l96:   fcvt.s.w f11, x5, rtz                     ;
_l97:   xor x30, x30, x30                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 24                         ;
        add x30, x30, x11                         ;
        csrrs x8, sie, x30                        ;
_l98:   la x18, d_3_23                            ;
        sb x9, 18(x18)                            ;
_l99:   beq x17, x30, _l119                       ;
_l100:  la x19, _l3                               ;
        ld x3, 0(x19)                             ;
_l101:  fclass.s x25, f27                         ;
_l102:  ebreak                                    ;
_l103:  bltu x12, x20, _l194                      ;
_l104:  fmsub.s f17, f11, f11, f3, rmm            ;
_l105:  fsqrt.s f12, f2, rmm                      ;
_l106:  la x17, d_3_10                            ;
        srai x17, x17, 1                          ;
        csrrc x1, pmpaddr5, x17                   ;
_l107:  xori x30, x8, 779                         ;
_l108:  la x2, _l158                              ;
        csrrw zero, uepc, x2                      ;
        uret                                      ;
_l109:  feq.s x6, f30, f2                         ;
_l110:  srliw x14, x18, 6                         ;
_l111:  la x10, d_5_18                            ;
        addi x10, x10, -0                         ;
        amomaxu.w x14, x3, (x10)                  ;
_l112:  xor x3, x3, x3                            ;
        addi x15, zero, 1                         ;
        slli x15, x15, 24                         ;
        add x3, x3, x15                           ;
        csrrc x20, fcsr, x3                       ;
_l113:  addi x10, x18, -445                       ;
_l114:  slti x7, x11, -1                          ;
_l115:  la x1, d_2_9                              ;
        sd x16, 0(x1)                             ;
_l116:  la x6, d_1_2                              ;
        lw x30, -20(x6)                           ;
_l117:  fcvt.lu.s x21, f4, rdn                    ;
_l118:  lui x8, 950750                            ;
_l119:  la x27, d_3_4                             ;
        sd x17, -8(x27)                           ;
_l120:  fsgnjx.s f10, f2, f13                     ;
_l121:  fmsub.s f16, f24, f24, f19, rdn           ;
_l122:  addw x30, x29, x2                         ;
_l123:  lui x12, 1048575                          ;
_l124:  la x20, d_0_19                            ;
        lb x18, -12(x20)                          ;
_l125:  fadd.s f13, f20, f25, rdn                 ;
_l126:  sraw x30, x30, x5                         ;
_l127:  fmax.s f7, f25, f17                       ;
_l128:  fcvt.lu.s x17, f7, rup                    ;
_l129:  bltu x28, x11, _l184                      ;
_l130:  xor x8, x8, x8                            ;
        csrrw x14, sscratch, x8                   ;
_l131:  la x17, d_0_13                            ;
        addi x17, x17, -0                         ;
        amoand.w x30, x1, (x17)                   ;
_l132:  fclass.s x14, f9                          ;
_l133:  xor x15, x15, x15                         ;
        addi x8, zero, 1                          ;
        slli x8, x8, 18                           ;
        add x15, x15, x8                          ;
        csrrs x10, satp, x15                      ;
_l134:  xori x20, x5, 6                           ;
_l135:  sltiu x12, x24, -2047                     ;
_l136:  la x2, d_2_21                             ;
        addi x2, x2, -16                          ;
        lr.w x2, (x2)                             ;
_l137:  mulw x25, x2, x15                         ;
_l138:  mulw x4, x30, x18                         ;
_l139:  fcvt.s.wu f15, x8, rup                    ;
_l140:  subw x5, x7, x25                          ;
_l141:  fmul.s f22, f9, f20, rtz                  ;
_l142:  fsqrt.s f25, f13, rtz                     ;
_l143:  fcvt.s.wu f20, x0, rup                    ;
_l144:  jal x28, _l159                            ;
_l145:  la x16, d_1_14                            ;
        addi x16, x16, -16                        ;
        lr.w x1, (x16)                            ;
_l146:  la x28, d_5_19                            ;
        sw x24, -24(x28)                          ;
_l147:  la x30, d_3_10                            ;
        addi x30, x30, -12                        ;
        amoxor.w x27, x30, (x30)                  ;
_l148:  mulhu x28, x10, x21                       ;
_l149:  la x29, d_3_21                            ;
        addi x29, x29, 8                          ;
        amomax.d x2, x6, (x29)                    ;
_l150:  fmul.s f16, f22, f27, rdn                 ;
_l151:  beq x28, x23, _l183                       ;
_l152:  fence                                     ;
_l153:  la x25, d_0_27                            ;
        lhu x5, 6(x25)                            ;
_l154:  la x15, d_2_22                            ;
        fsw f10, 20(x15)                          ;
_l155:  la x30, d_3_7                             ;
        addi x30, x30, 0                          ;
        lr.w x24, (x30)                           ;
_l156:  fnmsub.s f5, f13, f1, f22, rdn            ;
_l157:  fmsub.s f13, f11, f14, f26, rtz           ;
_l158:  ecall                                     ;
_l159:  srliw x28, x12, 31                        ;
_l160:  fmin.s f29, f9, f6                        ;
_l161:  fsgnjx.s f1, f5, f1                       ;
_l162:  xor x12, x12, x12                         ;
        csrrs x16, pmpcfg0, x12                   ;
_l163:  addi x22, x13, -667                       ;
_l164:  feq.s x2, f24, f13                        ;
_l165:  la x16, d_2_5                             ;
        addi x16, x16, -0                         ;
        amoswap.d x23, x23, (x16)                 ;
_l166:  la x29, d_4_16                            ;
        sh x8, -8(x29)                            ;
_l167:  srai x17, x0, 48                          ;
_l168:  la x14, d_3_16                            ;
        addi x14, x14, -4                         ;
        lui x1, 0xffe00                           ;
        xor x14, x14, x1                          ;
        amoor.w x1, x1, (x14)                     ;
_l169:  fcvt.w.s x14, f8, dyn                     ;
_l170:  la x21, d_1_24                            ;
        addi x21, x21, -0                         ;
        amominu.d x23, x13, (x21)                 ;
_l171:  fmul.s f26, f29, f7, dyn                  ;
_l172:  la x14, d_5_4                             ;
        addi x14, x14, -20                        ;
        amomax.w x10, x9, (x14)                   ;
_l173:  la x19, d_4_20                            ;
        flw f11, 28(x19)                          ;
_l174:  la x30, d_3_15                            ;
        addi x30, x30, 28                         ;
        amoxor.w x29, x21, (x30)                  ;
_l175:  flt.s x30, f10, f25                       ;
_l176:  divw x3, x15, x19                         ;
_l177:  la x12, d_3_15                            ;
        lwu x11, -16(x12)                         ;
_l178:  ebreak                                    ;
_l179:  fmul.s f21, f28, f2, rdn                  ;
_l180:  mulhu x18, x1, x22                        ;
_l181:  xor x27, x27, x27                         ;
        addi x26, zero, 1                         ;
        slli x26, x26, 25                         ;
        add x27, x27, x26                         ;
        addi x3, zero, 1                          ;
        slli x3, x3, 23                           ;
        add x27, x27, x3                          ;
        csrrw x19, pmpcfg0, x27                   ;
_l182:  la x25, d_4_8                             ;
        lwu x15, -16(x25)                         ;
_l183:  rem x1, x25, x10                          ;
_l184:  fclass.s x6, f22                          ;
_l185:  la x4, d_2_2                              ;
        fsw f1, -24(x4)                           ;
_l186:  fcvt.s.wu f7, x20, rmm                    ;
_l187:  la x1, d_3_10                             ;
        addi x1, x1, 0                            ;
        amoor.d x12, x19, (x1)                    ;
_l188:  mulw x20, x13, x14                        ;
_l189:  slliw x23, x29, 31                        ;
_l190:  fmv.x.w x3, f0                            ;
_l191:  slti x10, x30, 38                         ;
_l192:  csrrsi x22, mip, 0                        ;
_l193:  la x29, d_0_12                            ;
        addi x29, x29, -8                         ;
        amoxor.w x10, x12, (x29)                  ;
_l194:  fmv.w.x f7, x29                           ;
_l195:  srliw x19, x25, 23                        ;
_l196:  fdiv.s f11, f7, f13, rup                  ;
_l197:  div x15, x8, x21                          ;
_l198:  fmv.w.x f30, x11                          ;
_l199:  ecall                                     ;
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
                .dword 0x3fb5077127c4f0f8, 0xec54b1ad89ca3919
                .dword 0x7b158d4844e3946d, 0xada2b548fe2e7ed3
d_0_0:          .dword 0xf4d3b92680bbef53, 0xd654f461040f6a11
d_0_1:          .dword 0xbc0f18507736bf3c, 0xb0b2ef43a240a616
d_0_2:          .dword 0xf935a4e91614a6b5, 0x9563fbc9d318c79e
d_0_3:          .dword 0x5ff8a8fd12111793, 0xfb8460399fc98bcd
d_0_4:          .dword 0x3cebde160285dbd9, 0x2865cd2190e79726
d_0_5:          .dword 0xc5ddfa3f55487d9a, 0xbd9d94e6a597a91c
d_0_6:          .dword 0xafdee0d7d93e294f, 0x93eeef80addb5553
d_0_7:          .dword 0x5b78fdac5dc0e29b, 0xbf003b586c3acf0f
d_0_8:          .dword 0x4bdf25643ea58677, 0xd7001f5b8442315e
d_0_9:          .dword 0x40abd11bbafb96f4, 0x63a91246c5116d31
d_0_10:         .dword 0x030fe92038dfaf7e, 0xc5b77f2dbfb91bb6
d_0_11:         .dword 0x77670475fe6c46f9, 0x01c0454b8c870331
d_0_12:         .dword 0xffbf5e64bb0b0aa9, 0x89a3c4917b3fd89d
d_0_13:         .dword 0x3276322a1051c26c, 0xa6752c1102de8cd6
d_0_14:         .dword 0xa798cddfd58930f9, 0xb5dab88a49ef9ad0
d_0_15:         .dword 0xeb2fc38eabb42902, 0x9c922789aa0de9da
d_0_16:         .dword 0xe8aa3ab4b6fbee78, 0xb01babe003072cc2
d_0_17:         .dword 0x42799e317da7f238, 0x22da724b5147c896
d_0_18:         .dword 0x08687853d6b7b445, 0x18887239cb6bfb85
d_0_19:         .dword 0x77ca717565d5d1cd, 0x87ce7519d1bbd0f6
d_0_20:         .dword 0x688974850992bd62, 0x79ee69e1ba5e8886
d_0_21:         .dword 0x5f27146e1095c9b5, 0x00dafbafe7a88692
d_0_22:         .dword 0xabeb4e8f6b0b59a4, 0xd2017d4de7c925e7
d_0_23:         .dword 0x035ff47d159099a6, 0xfedccb4dc932b69f
d_0_24:         .dword 0x0e78a87cbb7599f8, 0xcc045c647addd273
d_0_25:         .dword 0x7bd69870071cba4b, 0xc3236810d4106e16
d_0_26:         .dword 0x46163b82be6f1569, 0x58621df674f1a828
d_0_27:         .dword 0xb312d08b8021be99, 0xfbaab0e82b954e94
                .dword 0x12690aef9b7c68b1, 0x66791ad39a6d3cba
                .dword 0x75ffec8e7bf50bda, 0x8d3e84f9a12b3dea
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xb8c8c88707541457, 0x47ce5b3873cec6e5
                .dword 0xd4eb47f525317340, 0xfa2dd3b23322b80f
d_1_0:          .dword 0x89d41185b15e0b5a, 0xf0be04ef732c9566
d_1_1:          .dword 0xbb0c76ad061457f0, 0x006c031a398255e1
d_1_2:          .dword 0x8c182d398cc9fea8, 0x9bdcc3e446716df9
d_1_3:          .dword 0x3195531a0af02bac, 0xb6337e4dec99a872
d_1_4:          .dword 0xccfd785be7e0f5c0, 0xa2e25450e33eee53
d_1_5:          .dword 0x3ca415ab844bd9f2, 0x85202ee6492d33c0
d_1_6:          .dword 0x681ed393cc7fe668, 0x4998ccc5011dc559
d_1_7:          .dword 0x38930227c0b13ad0, 0xca627994b529a684
d_1_8:          .dword 0xfb84ce59c4121dc1, 0x806b3f967dc215e2
d_1_9:          .dword 0x55516dc3a35ba03c, 0x90d10bfcc936fde3
d_1_10:         .dword 0xfcc423f5b1df7106, 0x5b20be5cc136e107
d_1_11:         .dword 0x581ad09b2388a0bb, 0x0af40aba2d127a5b
d_1_12:         .dword 0x0372b8a304d12a7a, 0xd9f3566453997fb8
d_1_13:         .dword 0x18c47e1b0cfd82db, 0x30f1db4b163981c0
d_1_14:         .dword 0x4200aa99d4c3d653, 0x19301e2d5f55868b
d_1_15:         .dword 0xc8078830c104b150, 0x4b5241e012407dc6
d_1_16:         .dword 0xf51182b14f96cd8d, 0x31ab3f66b498c8eb
d_1_17:         .dword 0xcbf9d229027642f5, 0x682a91de466df912
d_1_18:         .dword 0x152b0b305bec9447, 0xfc8b908489c11e32
d_1_19:         .dword 0xf47822e080f58f4c, 0xd29527ee62842302
d_1_20:         .dword 0xbb91ec64e9e95567, 0x55360e772281dede
d_1_21:         .dword 0xb4990b7a2c5689af, 0xff7e0874dd6fd93c
d_1_22:         .dword 0x709d70899eda7128, 0x881bbfc33265e3a1
d_1_23:         .dword 0xeaab0ac329fc21e8, 0x00e214f723b4efe6
d_1_24:         .dword 0xb980ba7c88374dab, 0x07e6481b13fc55a9
d_1_25:         .dword 0x924cb6240b27bb04, 0x7f7bf664933003a7
d_1_26:         .dword 0xe39ee627c0f2b3ec, 0xf7ab78adff79742a
d_1_27:         .dword 0x18f67e82bae0b991, 0x45eb5bb5b9333aa9
                .dword 0x4ea8821b9331ff57, 0x17514751d93cf188
                .dword 0xebf779ca709d29b3, 0x6a07a65d95365432
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x87174588b69da4d4, 0x04cb1b61204ed9f0
                .dword 0x8d071d3400cbb561, 0xb0feb371da63dbb1
d_2_0:          .dword 0xf6bb36ae7b0c4734, 0xeb18f6c0b8224ac2
d_2_1:          .dword 0x4db007462a94c080, 0x36cd1f3950ce0462
d_2_2:          .dword 0x97396eb03261e876, 0xd5a104e25e7e9c19
d_2_3:          .dword 0xc22026d74c671c27, 0xae0a75e04120d0c3
d_2_4:          .dword 0x1d524c0b3e0bbf58, 0xac6486427f80ee8c
d_2_5:          .dword 0xee11383af28245b1, 0xb006953c9864e5fc
d_2_6:          .dword 0xb5af1f4aff384a64, 0xee4408f002970568
d_2_7:          .dword 0xb20405e7f86df710, 0x57303147dac32851
d_2_8:          .dword 0xbcc9ebbd4c06b27a, 0x3fe21d52b369c212
d_2_9:          .dword 0xcf64f8b24a4586c0, 0x6e5126fb9c1af431
d_2_10:         .dword 0xd33c5e0c4b47edeb, 0x2895286f1f60bc97
d_2_11:         .dword 0xf6f449315673da10, 0x2d8e5db8b17658e6
d_2_12:         .dword 0x9db27ac9dd26ea19, 0xaf1a985b3fdb7484
d_2_13:         .dword 0x09bbc1720b0b35de, 0xf37eec225365aea4
d_2_14:         .dword 0xa30d84f9ca8adba5, 0xd1d399b914c4d2dd
d_2_15:         .dword 0xe756bf56f3616604, 0xa0cf89f4c4d5a5f2
d_2_16:         .dword 0xf27284d90636a050, 0xe150dd3ef2460673
d_2_17:         .dword 0xbcad865ba6720004, 0xb4dfd0bb520b410b
d_2_18:         .dword 0x60f8cdae187a8fa9, 0x353b175d5391ac56
d_2_19:         .dword 0x0163278a9cf77adb, 0x9cd6e34647117a93
d_2_20:         .dword 0x3ec007f4e8c92e93, 0x2f191643e0b958d7
d_2_21:         .dword 0xaa5d75bcfca0d110, 0x2868cfdbef9d9dbb
d_2_22:         .dword 0x23ed66b0f6c345b8, 0x409499138a1d41d1
d_2_23:         .dword 0x82ab171f57ca840a, 0xa752f28d0453f893
d_2_24:         .dword 0x5c80bc2b14f5e07e, 0x782313455e61b206
d_2_25:         .dword 0xdaafe13367dff360, 0xdac2b9cb998ea287
d_2_26:         .dword 0x2eadb807b8d45257, 0xb5841f902bf15374
d_2_27:         .dword 0x9b87b67395831573, 0x6ac52e2ed5d6b59b
                .dword 0xcc51324069ff7cbc, 0xa40de0ae8f7f688c
                .dword 0xbd2692c24f1e5779, 0x0f76754afea4d86f
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xb2c9046580670e27, 0x68933051c9fbd472
                .dword 0x0dc322f89b6f867b, 0xa10313c9a408396b
d_3_0:          .dword 0xe621bd7a3c7fac22, 0x427fc98dd377e34b
d_3_1:          .dword 0x64ce13358fc53a1c, 0x754b090b15ac087d
d_3_2:          .dword 0xbcba7404e3bd8639, 0x2176a84e888f1493
d_3_3:          .dword 0xfa5aacc19259e5cd, 0x28dfb18c515c0457
d_3_4:          .dword 0x678b84eac79773b8, 0x7e0bf6f8c3080de0
d_3_5:          .dword 0x4e00449f28a32d12, 0x777d3f3a1d92509a
d_3_6:          .dword 0xcec2564255920669, 0x1fed7a7484d0b2dc
d_3_7:          .dword 0xcce7bd8317098996, 0xa4bd05ce0806abb6
d_3_8:          .dword 0x1d7f4c8530324703, 0x34b8eb279cb5fc21
d_3_9:          .dword 0x95632a8153f80047, 0xb63065175cc0e7c4
d_3_10:         .dword 0x41d5b6998cbfa5b5, 0x307d46617d094155
d_3_11:         .dword 0x0e56312e8a25845a, 0xbc29b48e52f19e0e
d_3_12:         .dword 0xe4c0f4c65bbb00c9, 0x62704a9ef84a5691
d_3_13:         .dword 0x89617bdce2c4036d, 0x02f114f9262679f7
d_3_14:         .dword 0x0d0e59b23e89ea7b, 0xbe28439196feadaa
d_3_15:         .dword 0xf6107276bcfad0cf, 0x5d9cfb7e0b88d6a1
d_3_16:         .dword 0xe195681e109485d8, 0xde10d8e453e824f1
d_3_17:         .dword 0x508b9edaab8b1ba3, 0xf6904e0ed54ccb9b
d_3_18:         .dword 0xd498a9480ba15df3, 0x4f5ecd918291e41f
d_3_19:         .dword 0xab0997e6f966959e, 0x8a16d62c041313fe
d_3_20:         .dword 0x95803325ff096143, 0xd5c182f420a31f59
d_3_21:         .dword 0x13f36139db6192c6, 0x16a480973b691dd1
d_3_22:         .dword 0x635b504551db9915, 0x779e4f2cb71cb723
d_3_23:         .dword 0xb4a6eadc3bf4c70b, 0x1c18d707f955ad43
d_3_24:         .dword 0xc8c9729ab93edc93, 0xb9c277b4d6dcbfec
d_3_25:         .dword 0x1ccf9ae3ea034db6, 0xfc02c9a85020003f
d_3_26:         .dword 0x42bc780430d9b0a1, 0x98cb72e0bf7d425e
d_3_27:         .dword 0xc94bef8bc0ab1bd4, 0x3a8c96af97ee828f
                .dword 0x29f9b0c99601e254, 0xcc7fe877ab412cb8
                .dword 0xf5a49122582eec63, 0xf6a80ffbfbd1a666
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x41b00c83c25dbe7a, 0xf417be3719f54188
                .dword 0x3a8f70248bb75e0d, 0xcc6d6be5f16b7677
d_4_0:          .dword 0x6e0f3164742718b8, 0xe5d413aa73224706
d_4_1:          .dword 0x2d49d1deb769d4ca, 0xcae12eb908198d95
d_4_2:          .dword 0x6751275edd79ab61, 0x10044aaec7adfdb1
d_4_3:          .dword 0x1d4f8481d6e108d7, 0xd18940daa10f1a72
d_4_4:          .dword 0xc48004b743aee2f2, 0xd543b7b08293e368
d_4_5:          .dword 0xb253fa57f4a415d2, 0x15d17668ec70fbc3
d_4_6:          .dword 0xd0eff26f1a7cc1ea, 0x7156acae55b737de
d_4_7:          .dword 0x629ec676509ea45c, 0x73a233859e1f5282
d_4_8:          .dword 0xd921d53eb46e8a94, 0x42b5acb6f60df92b
d_4_9:          .dword 0x5c8fa549e18c9e83, 0x44a318f067d76a1a
d_4_10:         .dword 0x1b5ac4c13f86e63f, 0xc2d15ffe4270009a
d_4_11:         .dword 0x931247f845d5b0cf, 0x8c8baa6d2f1a7394
d_4_12:         .dword 0x113ea2a45b1bb616, 0x3414685988f46238
d_4_13:         .dword 0xb77c275d94162dcf, 0x1943923a15d7bbd7
d_4_14:         .dword 0x4f8ee1dc9447c190, 0x5f4eaf9ae8e97be9
d_4_15:         .dword 0x05183f3741243224, 0x8a9920bffbaef5a6
d_4_16:         .dword 0xecc243dc80c98534, 0x13bc195c8d20723d
d_4_17:         .dword 0xcb3c7c49f3dae484, 0xdb8f4d278b024dfd
d_4_18:         .dword 0x75d85689f80eb1ac, 0x034c0a79150c1161
d_4_19:         .dword 0x4aafbdea6bbc873f, 0xa61ebb251089cf94
d_4_20:         .dword 0x9cafd95660ba985b, 0xaa4318753e926c31
d_4_21:         .dword 0xcedc3fb2205d2cbf, 0x14e7f77a04fbe594
d_4_22:         .dword 0xac60d8f5de6ba4a8, 0x8b4b0f8c84b1d054
d_4_23:         .dword 0xbbb9e628a3052236, 0xbda224f0570d6e2d
d_4_24:         .dword 0xb46decf53ac2a2a5, 0x73f9c3e18a56cdfd
d_4_25:         .dword 0x79551dd5e754b5ce, 0xde950b9123f78c0c
d_4_26:         .dword 0x98679a8609d5fab5, 0xae46b02f459ca4cd
d_4_27:         .dword 0xd96f2c0842891ddf, 0xd32b7df5a3288eb4
                .dword 0x119bd7973616c62e, 0x7cd500b6ca572f1c
                .dword 0x8180b7288cd817bd, 0x22a70fec83dace05
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x5bdb725fa35dd2dc, 0x4f7951ed4dc451a9
                .dword 0x71e35a5ae7bb6b7a, 0x8194b293a8aec02e
d_5_0:          .dword 0xe5d3348919cf08cf, 0xc7065435e4df85c2
d_5_1:          .dword 0xe0f964bf3cdb366e, 0x8ea7146bc5f647da
d_5_2:          .dword 0x8969c3f7e92e0f3c, 0x4d11508cdc8f05a1
d_5_3:          .dword 0xb970f515d40b0705, 0x47775a789939ec27
d_5_4:          .dword 0xec854517ddc5caa8, 0xb16b80fb8cd8d5f3
d_5_5:          .dword 0xc2dd12799591a038, 0x2429a90fedfb6e8f
d_5_6:          .dword 0x9e8f6253be4e3af6, 0xcd0cc1550a9fef3d
d_5_7:          .dword 0x766fef6577373f98, 0x43ece1c3fe15217c
d_5_8:          .dword 0x2dea58bd0358563d, 0x187ad20fa184c9cb
d_5_9:          .dword 0xc6c566e9e5362097, 0x27107b0cf54625e0
d_5_10:         .dword 0xdcf26db614da03a2, 0xb96f8ff05073e48a
d_5_11:         .dword 0x6743b8311d04755e, 0x13b9755f88eea1f7
d_5_12:         .dword 0x1275c649aafff85f, 0x31aba5ddbcd83f69
d_5_13:         .dword 0xf8ecffa487d93a41, 0x507e65f0397d640f
d_5_14:         .dword 0x56cffd94d081b4aa, 0x5bcfca34c5aae6bc
d_5_15:         .dword 0x4536ed81e9d9340f, 0x70d433c60105b86a
d_5_16:         .dword 0xa4caf9206489c04f, 0x93268cfcaa339f98
d_5_17:         .dword 0x2ba442922c4d86ae, 0x553d10595e6f0dca
d_5_18:         .dword 0x04cc343784b8fcfa, 0x3b3606e21ac465a8
d_5_19:         .dword 0xd4c5c392adadf34f, 0xce3b70dcdd716fc8
d_5_20:         .dword 0xf6eecf7f32023d64, 0xa9f74d16482e4f77
d_5_21:         .dword 0x79e0c749d63c7c00, 0xac456b8d517c4871
d_5_22:         .dword 0x2de7d791f29f126a, 0xf38ff034b720cbd6
d_5_23:         .dword 0xabe1bce0bc3d1ac9, 0xd76a49d27c18a28a
d_5_24:         .dword 0xa3bcfbd32b61b4f6, 0xbfc5cdda6e775ce2
d_5_25:         .dword 0xdfc08b6721f35bfc, 0x184c97ef6e66406a
d_5_26:         .dword 0x773abcb50518fc90, 0xe58ee7e4ac18d897
d_5_27:         .dword 0x75e1dd9eb129c552, 0x2f438472744459b7
                .dword 0xc04446745adf9b50, 0x6ceb110dddb4c386
                .dword 0xc7db88e415f913a4, 0x6b16c09aae1a21cc
         /* Random data */
_end_data5:
              
 
