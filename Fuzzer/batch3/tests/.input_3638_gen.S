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
_p0:    csrrsi x12, satp, 29                      ;
_p1:    xor x13, x13, x13                         ;
        csrrc x14, satp, x13                      ;
_p2:    csrrwi x10, mstatus, 29                   ;
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
_s0:    divuw x1, x11, x11                        ;
_s1:    mulh x13, x2, x25                         ;
_s2:    xor x29, x29, x29                         ;
        csrrw x7, mip, x29                        ;
_s3:    la x11, d_5_15                            ;
        addi x11, x11, 8                          ;
        amoand.d x9, x10, (x11)                   ;
_s4:    bne x20, x10, _s5                         ;
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
_l0:    andi x26, x13, 2047                       ;
_l1:    mul x29, x4, x29                          ;
_l2:    la x25, _l115                             ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l3:    xor x23, x23, x23                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 19                         ;
        add x23, x23, x22                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 29                           ;
        add x23, x23, x2                          ;
        addi x28, zero, 3                         ;
        slli x28, x28, 11                         ;
        add x23, x23, x28                         ;
        csrrs x6, frm, x23                        ;
_l4:    la x13, d_5_9                             ;
        sw x18, 28(x13)                           ;
_l5:    bltu x3, x24, _l154                       ;
_l6:    sraiw x25, x10, 31                        ;
_l7:    la x12, d_2_3                             ;
        addi x12, x12, -12                        ;
        lui x30, 0xffe00                          ;
        xor x12, x12, x30                         ;
        amoand.w x29, x30, (x12)                  ;
_l8:    la x14, _l180                             ;
        csrrw zero, sepc, x14                     ;
        sret                                      ;
_l9:    jal x23, _l104                            ;
_l10:   srlw x22, x3, x14                         ;
_l11:   la x30, d_4_27                            ;
        flw f7, 16(x30)                           ;
_l12:   mul x0, x30, x20                          ;
_l13:   fcvt.s.lu f10, x20, rdn                   ;
_l14:   ecall                                     ;
_l15:   csrrsi x20, mepc, 29                      ;
_l16:   remuw x22, x2, x19                        ;
_l17:   fsqrt.s f0, f5, rup                       ;
_l18:   ecall                                     ;
_l19:   la x3, d_3_20                             ;
        ld x6, 8(x3)                              ;
_l20:   slli x2, x20, 60                          ;
_l21:   la x19, _l159                             ;
        csrrw zero, mepc, x19                     ;
        mret                                      ;
_l22:   addi x3, x9, -1362                        ;
_l23:   la x11, d_1_12                            ;
        sb x26, 18(x11)                           ;
_l24:   la x15, d_4_23                            ;
        addi x15, x15, 0                          ;
        lui x9, 0xffe00                           ;
        xor x15, x15, x9                          ;
        sc.d x12, x15, (x15)                      ;
_l25:   srlw x5, x12, x23                         ;
_l26:   srliw x13, x20, 17                        ;
_l27:   la x15, _l151                             ;
        csrrw zero, uepc, x15                     ;
        uret                                      ;
_l28:   la x19, d_0_24                            ;
        addi x19, x19, -0                         ;
        amoand.w x12, x18, (x19)                  ;
_l29:   sraiw x20, x20, 25                        ;
_l30:   la x25, d_4_23                            ;
        addi x25, x25, -16                        ;
        lui x13, 0xffe00                          ;
        xor x25, x25, x13                         ;
        lr.w x3, (x25)                            ;
_l31:   la x20, d_5_6                             ;
        fsw f31, 12(x20)                          ;
_l32:   remu x25, x30, x1                         ;
_l33:   sraw x13, x22, x1                         ;
_l34:   la x24, d_3_3                             ;
        srai x24, x24, 1                          ;
        csrrc x22, pmpaddr2, x24                  ;
_l35:   la x11, d_5_21                            ;
        addi x11, x11, -8                         ;
        amomax.w x14, x19, (x11)                  ;
_l36:   feq.s x25, f31, f5                        ;
_l37:   xor x14, x14, x14                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 22                         ;
        add x14, x14, x27                         ;
        addi x8, zero, 3                          ;
        slli x8, x8, 19                           ;
        add x14, x14, x8                          ;
        csrrw x22, sepc, x14                      ;
_l38:   bge x21, x10, _l94                        ;
_l39:   flt.s x2, f26, f0                         ;
_l40:   fmax.s f13, f16, f13                      ;
_l41:   remuw x15, x11, x3                        ;
_l42:   sraw x17, x7, x23                         ;
_l43:   la x3, d_5_7                              ;
        lhu x11, -8(x3)                           ;
_l44:   remw x5, x3, x0                           ;
_l45:   la x4, d_2_18                             ;
        addi x4, x4, 16                           ;
        lr.w x15, (x4)                            ;
_l46:   la x20, d_1_20                            ;
        addi x20, x20, 0                          ;
        amoadd.d x14, x22, (x20)                  ;
_l47:   sraiw x19, x25, 0                         ;
_l48:   la x11, d_4_8                             ;
        addi x11, x11, 16                         ;
        lui x1, 0xffe00                           ;
        xor x11, x11, x1                          ;
        amomin.d x4, x1, (x11)                    ;
_l49:   fence.i                                   ;
_l50:   la x14, _l179                             ;
        lhu x17, -14(x14)                         ;
_l51:   ori x12, x19, 290                         ;
_l52:   la x1, d_2_27                             ;
        addi x1, x1, -0                           ;
        amomin.d x14, x23, (x1)                   ;
_l53:   la x6, d_5_3                              ;
        addi x6, x6, 0                            ;
        lui x22, 0xffe00                          ;
        xor x6, x6, x22                           ;
        amoxor.d x8, x22, (x6)                    ;
_l54:   la x19, d_0_21                            ;
        sd x20, 16(x19)                           ;
_l55:   la x20, _l164                             ;
        csrrw zero, uepc, x20                     ;
        uret                                      ;
_l56:   csrrwi x16, sepc, 0                       ;
_l57:   la x5, d_4_23                             ;
        fsw f30, 12(x5)                           ;
_l58:   la x18, d_2_27                            ;
        addi x18, x18, 4                          ;
        amomin.w x1, x8, (x18)                    ;
_l59:   sltiu x15, x8, -0                         ;
_l60:   subw x12, x22, x24                        ;
_l61:   fcvt.lu.s x9, f26, rne                    ;
_l62:   la x24, d_2_6                             ;
        lw x4, -0(x24)                            ;
_l63:   fle.s x13, f16, f13                       ;
_l64:   fsgnj.s f19, f16, f4                      ;
_l65:   la x12, d_3_21                            ;
        addi x12, x12, -16                        ;
        lr.d x19, (x12)                           ;
_l66:   xor x17, x17, x17                         ;
        addi x25, zero, 1                         ;
        slli x25, x25, 23                         ;
        add x17, x17, x25                         ;
        addi x5, zero, 1                          ;
        slli x5, x5, 21                           ;
        add x17, x17, x5                          ;
        addi x6, zero, 3                          ;
        slli x6, x6, 13                           ;
        add x17, x17, x6                          ;
        csrrw x25, fcsr, x17                      ;
_l67:   xor x22, x22, x22                         ;
        addi x9, zero, 1                          ;
        slli x9, x9, 19                           ;
        add x22, x22, x9                          ;
        addi x3, zero, 3                          ;
        slli x3, x3, 21                           ;
        add x22, x22, x3                          ;
        addi x22, zero, 1                         ;
        slli x22, x22, 13                         ;
        add x22, x22, x22                         ;
        csrrc x18, mhartid, x22                   ;
_l68:   mul x16, x20, x4                          ;
_l69:   csrrsi x15, mcause, 2                     ;
_l70:   fsgnj.s f5, f14, f19                      ;
_l71:   lui x29, 1048575                          ;
_l72:   fcvt.lu.s x29, f10, dyn                   ;
_l73:   la x24, d_5_1                             ;
        addi x24, x24, 0                          ;
        amominu.w x16, x19, (x24)                 ;
_l74:   fmin.s f21, f25, f17                      ;
_l75:   la x21, d_4_25                            ;
        addi x21, x21, 0                          ;
        amomin.d x29, x7, (x21)                   ;
_l76:   fsgnjx.s f14, f25, f18                    ;
_l77:   fsqrt.s f21, f19, rne                     ;
_l78:   la x8, d_5_23                             ;
        addi x8, x8, -0                           ;
        amoand.d x5, x13, (x8)                    ;
_l79:   la x11, d_4_14                            ;
        ld x11, 8(x11)                            ;
_l80:   fsqrt.s f27, f15, dyn                     ;
_l81:   bne x20, x3, _l171                        ;
_l82:   ecall                                     ;
_l83:   la x29, d_5_5                             ;
        addi x29, x29, -0                         ;
        lr.w x18, (x29)                           ;
_l84:   la x7, d_0_7                              ;
        addi x7, x7, 28                           ;
        amoswap.w x20, x10, (x7)                  ;
_l85:   csrrwi x27, mepc, 11                      ;
_l86:   la x14, d_5_22                            ;
        addi x14, x14, 24                         ;
        lr.w x4, (x14)                            ;
_l87:   fcvt.s.lu f23, x5, rdn                    ;
_l88:   la x24, d_5_0                             ;
        addi x24, x24, 12                         ;
        amoxor.w x19, x20, (x24)                  ;
_l89:   fclass.s x8, f19                          ;
_l90:   mulh x22, x3, x14                         ;
_l91:   la x13, d_3_7                             ;
        lui x4, 0xffe00                           ;
        xor x13, x13, x4                          ;
        lw x6, -12(x13)                           ;
_l92:   la x9, d_2_11                             ;
        addi x9, x9, 16                           ;
        amominu.d x29, x24, (x9)                  ;
_l93:   fmin.s f31, f17, f7                       ;
_l94:   la x8, d_5_7                              ;
        addi x8, x8, -16                          ;
        amominu.d x28, x23, (x8)                  ;
_l95:   la x20, d_5_8                             ;
        sb x6, -31(x20)                           ;
_l96:   fmsub.s f10, f21, f16, f24, rne           ;
_l97:   la x18, d_1_23                            ;
        addi x18, x18, -0                         ;
        amoxor.w x26, x21, (x18)                  ;
_l98:   sraiw x28, x5, 24                         ;
_l99:   la x2, d_3_12                             ;
        addi x2, x2, 8                            ;
        amoxor.w x31, x8, (x2)                    ;
_l100:  andi x28, x19, -24                        ;
_l101:  xor x22, x22, x22                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 19                           ;
        add x22, x22, x2                          ;
        addi x4, zero, 1                          ;
        slli x4, x4, 10                           ;
        add x22, x22, x4                          ;
        csrrc x9, mip, x22                        ;
_l102:  jal x2, _l193                             ;
_l103:  divuw x16, x19, x20                       ;
_l104:  la x19, d_4_8                             ;
        lw x8, -16(x19)                           ;
_l105:  fcvt.l.s x13, f20, rtz                    ;
_l106:  fnmadd.s f30, f5, f31, f4, rtz            ;
_l107:  bne x23, x8, _l141                        ;
_l108:  bgeu x17, x13, _l183                      ;
_l109:  bge x18, x30, _l179                       ;
_l110:  la x15, _l149                             ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l111:  la x26, _l147                             ;
        jalr x22, 0(x26)                          ;
_l112:  sraw x17, x8, x4                          ;
_l113:  la x22, d_3_13                            ;
        lwu x5, -20(x22)                          ;
_l114:  la x2, d_4_14                             ;
        addi x2, x2, -0                           ;
        amominu.d x1, x24, (x2)                   ;
_l115:  fmv.x.w x22, f6                           ;
_l116:  rem x6, x3, x14                           ;
_l117:  slli x27, x13, 63                         ;
_l118:  ecall                                     ;
_l119:  la x9, d_2_25                             ;
        addi x9, x9, -16                          ;
        amomin.d x12, x20, (x9)                   ;
_l120:  mulhsu x22, x6, x3                        ;
_l121:  slliw x20, x8, 5                          ;
_l122:  addi x11, x26, -2047                      ;
_l123:  addiw x12, x22, 2047                      ;
_l124:  mulw x1, x27, x29                         ;
_l125:  la x20, d_5_25                            ;
        sb x28, 3(x20)                            ;
_l126:  fcvt.s.lu f6, x24, dyn                    ;
_l127:  ebreak                                    ;
_l128:  la x26, d_0_24                            ;
        addi x26, x26, 16                         ;
        amomin.d x6, x27, (x26)                   ;
_l129:  la x13, d_0_4                             ;
        addi x13, x13, 8                          ;
        amominu.w x29, x6, (x13)                  ;
_l130:  fmadd.s f10, f19, f16, f0, rne            ;
_l131:  la x20, d_2_21                            ;
        addi x20, x20, -0                         ;
        amominu.d x8, x30, (x20)                  ;
_l132:  rem x27, x27, x4                          ;
_l133:  la x5, _l200                              ;
        jalr x24, 0(x5)                           ;
_l134:  la x29, d_1_2                             ;
        lw x12, 0(x29)                            ;
_l135:  remuw x28, x13, x29                       ;
_l136:  srai x18, x11, 8                          ;
_l137:  feq.s x21, f0, f8                         ;
_l138:  la x25, d_5_25                            ;
        lwu x30, -16(x25)                         ;
_l139:  ecall                                     ;
_l140:  la x11, d_2_10                            ;
        lw x9, 28(x11)                            ;
_l141:  fsgnj.s f16, f27, f18                     ;
_l142:  la x11, d_2_8                             ;
        addi x11, x11, 8                          ;
        amomax.d x13, x30, (x11)                  ;
_l143:  fence                                     ;
_l144:  srli x3, x14, 0                           ;
_l145:  la x10, d_0_9                             ;
        addi x10, x10, -24                        ;
        lui x12, 0xffe00                          ;
        xor x10, x10, x12                         ;
        amomax.w x22, x12, (x10)                  ;
_l146:  slli x9, x12, 54                          ;
_l147:  la x27, _l22                              ;
        lui x8, 0xffe00                           ;
        xor x27, x27, x8                          ;
        flw f19, 12(x27)                          ;
_l148:  fmv.w.x f19, x18                          ;
_l149:  la x5, _l8                                ;
        lwu x16, 28(x5)                           ;
_l150:  la x29, d_3_12                            ;
        srai x29, x29, 1                          ;
        csrrs x24, pmpaddr0, x29                  ;
_l151:  la x13, d_2_21                            ;
        addi x13, x13, 8                          ;
        lui x19, 0xffe00                          ;
        xor x13, x13, x19                         ;
        amoand.w x6, x19, (x13)                   ;
_l152:  srai x20, x27, 0                          ;
_l153:  fcvt.l.s x23, f5, rmm                     ;
_l154:  la x9, d_1_0                              ;
        addi x9, x9, -24                          ;
        lui x30, 0xffe00                          ;
        xor x9, x9, x30                           ;
        amomaxu.w x12, x30, (x9)                  ;
_l155:  fnmsub.s f26, f19, f23, f31, rne          ;
_l156:  xori x12, x8, -11                         ;
_l157:  mulw x29, x0, x19                         ;
_l158:  blt x26, x28, _l199                       ;
_l159:  sraiw x19, x1, 0                          ;
_l160:  addw x0, x14, x0                          ;
_l161:  sllw x10, x13, x1                         ;
_l162:  fsgnjn.s f5, f22, f5                      ;
_l163:  fle.s x6, f3, f3                          ;
_l164:  mulhsu x3, x9, x15                        ;
_l165:  la x14, _l167                             ;
        csrrw zero, mepc, x14                     ;
        mret                                      ;
_l166:  la x29, _l145                             ;
        ld x9, -0(x29)                            ;
_l167:  auipc x27, 260876                         ;
_l168:  sltiu x5, x11, -0                         ;
_l169:  la x9, d_0_5                              ;
        flw f3, -12(x9)                           ;
_l170:  fnmsub.s f1, f9, f1, f21, rtz             ;
_l171:  mulhu x11, x4, x10                        ;
_l172:  fnmadd.s f28, f26, f5, f18, rmm           ;
_l173:  la x24, d_2_0                             ;
        addi x24, x24, -28                        ;
        amoor.w x27, x24, (x24)                   ;
_l174:  la x5, d_4_27                             ;
        addi x5, x5, -0                           ;
        amominu.d x11, x9, (x5)                   ;
_l175:  remw x12, x15, x9                         ;
_l176:  rem x26, x2, x2                           ;
_l177:  fmul.s f14, f16, f16, rmm                 ;
_l178:  mul x16, x20, x2                          ;
_l179:  la x20, d_1_3                             ;
        addi x20, x20, 8                          ;
        amoand.d x23, x17, (x20)                  ;
_l180:  lui x19, 276169                           ;
_l181:  remw x1, x4, x13                          ;
_l182:  la x25, d_3_1                             ;
        addi x25, x25, 16                         ;
        lui x28, 0xffe00                          ;
        xor x25, x25, x28                         ;
        amoor.d x1, x28, (x25)                    ;
_l183:  slliw x14, x23, 31                        ;
_l184:  la x12, d_1_8                             ;
        flw f20, -20(x12)                         ;
_l185:  fmsub.s f23, f14, f6, f8, rdn             ;
_l186:  ori x14, x11, 0                           ;
_l187:  sltiu x21, x1, 559                        ;
_l188:  fdiv.s f29, f6, f21, dyn                  ;
_l189:  fcvt.lu.s x6, f23, rne                    ;
_l190:  la x5, d_4_19                             ;
        addi x5, x5, -16                          ;
        amominu.d x24, x21, (x5)                  ;
_l191:  fmsub.s f25, f28, f3, f0, dyn             ;
_l192:  la x26, d_4_21                            ;
        addi x26, x26, 8                          ;
        amoor.d x1, x9, (x26)                     ;
_l193:  beq x14, x10, _l197                       ;
_l194:  la x26, d_4_7                             ;
        lh x18, 30(x26)                           ;
_l195:  flt.s x9, f24, f23                        ;
_l196:  divuw x5, x12, x17                        ;
_l197:  la x1, d_5_11                             ;
        addi x1, x1, 4                            ;
        amomaxu.w x13, x9, (x1)                   ;
_l198:  la x17, d_2_23                            ;
        lwu x7, -24(x17)                          ;
_l199:  fsgnjn.s f24, f12, f22                    ;
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
                .dword 0x43b38b22e480efb2, 0xfc55fb0cc1cd9cbb
                .dword 0xd4669ad99ec8fc83, 0xd949c08d0f3c5e5b
d_0_0:          .dword 0xe24b84f1e7f1a3f8, 0xdb26661c5fab4fc7
d_0_1:          .dword 0x0dc2f678e7acd707, 0xaeafbc27220d9a6d
d_0_2:          .dword 0x16b3a268077381c3, 0xabe5b71b17c5b9e1
d_0_3:          .dword 0x76b6fc6c778b7175, 0x61de7afd29ec15b2
d_0_4:          .dword 0xdcba114d9eeba274, 0xa3cba6af2aa4d92b
d_0_5:          .dword 0x094f4023118ce35c, 0xc87dab6a15dc2684
d_0_6:          .dword 0xf0e58d1b51c6e92e, 0xc03ca8dfbbb76e77
d_0_7:          .dword 0xd46ee8bec17d3ef3, 0xd26c1d839a8dbe3d
d_0_8:          .dword 0xbdd58982e9021cf9, 0xa0e91616e2ffb15d
d_0_9:          .dword 0x969f0d3b0391fbb4, 0xfc035c3beb351a8e
d_0_10:         .dword 0xaa8713e3bf385319, 0xa12888b3cc937d3f
d_0_11:         .dword 0x36ec45b473d60aa8, 0xed5454866c749a45
d_0_12:         .dword 0x5f6c50b9e3d19132, 0x55cfe9807a437c38
d_0_13:         .dword 0xfc7be0afa2a680a2, 0x541137b84bd12f62
d_0_14:         .dword 0xfc591ee42982c8a3, 0x32fb4987124267a6
d_0_15:         .dword 0xc17b340ea7b46dc3, 0xb477d70eeb2cf2f6
d_0_16:         .dword 0x43bc7831e3261dab, 0xe25ee2ffe7f25b2f
d_0_17:         .dword 0xea1edf978cad663e, 0x9b110d0a86cba7a2
d_0_18:         .dword 0x3142a22db297cbbe, 0xb2c2edc148955b0d
d_0_19:         .dword 0xa42e2eb177fe7cdc, 0xe91ef9c769e64ee4
d_0_20:         .dword 0x7555b4693d3b2b1b, 0x1db040df89f0a8a1
d_0_21:         .dword 0x63610bdce09bd77b, 0x540ab31b725f6206
d_0_22:         .dword 0x72607bd18b6691e6, 0x6e8ecc27f5032ce7
d_0_23:         .dword 0xd926fc3c69e78415, 0xaee30d621dac4238
d_0_24:         .dword 0x9ddb9bae84fb1d75, 0x5e335ccb4b1f8943
d_0_25:         .dword 0x1f79053ef1ef5744, 0xd4c47037b8fd8899
d_0_26:         .dword 0x0ff9b86da2320b33, 0x4d0aee66bbeb2d4e
d_0_27:         .dword 0x5ba85ce06c310d84, 0x34534128bae1f322
                .dword 0x4cbbf22b598f13bf, 0x2d7d1539538eebd5
                .dword 0x2057453a113a8ec9, 0xa96b5749020135a2
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x622a6de365a3dd85, 0x39caaaaf651e52b5
                .dword 0xdce007401830f368, 0xc820b3a9c479fbf6
d_1_0:          .dword 0x1f585c451b6041bb, 0xa060da9c98c9a280
d_1_1:          .dword 0x871c3d247762bf94, 0x19da7360a3940d49
d_1_2:          .dword 0x8ad80247d39e6898, 0xb634fe8cd11260f4
d_1_3:          .dword 0xd1f3ee97356e334f, 0xdcf4ea2ad4beea23
d_1_4:          .dword 0x8b15a786c2bfffb1, 0xc831d491324154c2
d_1_5:          .dword 0x8620a54ee51cba13, 0x5c0bbbe7982cfa46
d_1_6:          .dword 0x8501b5c0293cfbc8, 0x744dbc44b64d7b00
d_1_7:          .dword 0x04aff1ec522a64c9, 0x1a25868bf2b715bd
d_1_8:          .dword 0xb074cde08b5de2bc, 0x35d4e3a820e925f4
d_1_9:          .dword 0xebcba3e0a11f19ae, 0x7d149b916bd604ba
d_1_10:         .dword 0x683cb5b5a9da7e09, 0xf4970097de4da963
d_1_11:         .dword 0x1976879063f1718e, 0x048c9ae1d832751c
d_1_12:         .dword 0xa6908a57afbd9331, 0x731bdb5ba8ef5f68
d_1_13:         .dword 0x550e577d7e19b7a6, 0xaff98fafd683d0fc
d_1_14:         .dword 0x69c54c3f7b680495, 0x84f29e7063c123d2
d_1_15:         .dword 0xdb9ce02168ffcefc, 0x3e8b54034e3d0c89
d_1_16:         .dword 0x858e576030f7ca7c, 0xc400c080c5f37751
d_1_17:         .dword 0x79fcd0a4a5e16cd0, 0x782d542b6528986e
d_1_18:         .dword 0x7517ed221e60ce9f, 0xf6b963746fcc2c89
d_1_19:         .dword 0x3e17f428957bfd74, 0xd08dbdbce4bf2c8c
d_1_20:         .dword 0xf546683bf12372e3, 0xfca9b97881d6586f
d_1_21:         .dword 0xc17b8bbb516eac83, 0x62e8af149decbe8c
d_1_22:         .dword 0x28d9604deb6ec0a7, 0x667b0ca0413fd361
d_1_23:         .dword 0x17bfb618dea2a6ac, 0x126cfc7e7a938ea4
d_1_24:         .dword 0xb94a12467e43c99c, 0x1b3dcda8be22d3f8
d_1_25:         .dword 0xffe0a8f89ae53097, 0x32d505af876e89b7
d_1_26:         .dword 0x2f2d9bdf0cee2094, 0x6744764c89070fce
d_1_27:         .dword 0xb63059c57e9dd7f1, 0xa95303837a84cf79
                .dword 0xf1d9ccd70611ec40, 0xee4f67b9df9597e6
                .dword 0x4dfc5b8c604ca962, 0x4fbde85494ecd014
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x7b8d567796c8fbea, 0x9ef1c0f96c4c5fa6
                .dword 0x5b58f942e35cb189, 0x67414038d068acbf
d_2_0:          .dword 0x581bd4b389465f04, 0x294e4a92e1e4898d
d_2_1:          .dword 0x253e5ce83bc1f493, 0x030ff3130a3863c2
d_2_2:          .dword 0x244ebcdf344bcb27, 0x1f9bec61413d7b0a
d_2_3:          .dword 0x82f925a77c298eb1, 0x67072f7ac567231d
d_2_4:          .dword 0x0c9deec802f5afa5, 0x80148373c2fac567
d_2_5:          .dword 0xc6bb884c8561926c, 0x478fdb600016bc00
d_2_6:          .dword 0xe1fe43b207ab28c7, 0x298153c47a4e47e4
d_2_7:          .dword 0xa87f6539c3d26b38, 0xe146a555341f10bc
d_2_8:          .dword 0x3e3550d966ab5c49, 0x5c1b49417a009cd9
d_2_9:          .dword 0xb838fcac776d11f5, 0x20626d7c922f0592
d_2_10:         .dword 0x128426bddd5f4bba, 0x6d6e22cb985e9d7e
d_2_11:         .dword 0x886d99583c28be05, 0x287459a5c31eb9aa
d_2_12:         .dword 0xf05f83671f80f6b9, 0xa8594f8dea55487a
d_2_13:         .dword 0xac43210c60e55feb, 0x62a79328235cbbb2
d_2_14:         .dword 0x4e9dbc4094dacdab, 0x42e8c2abc2742753
d_2_15:         .dword 0x7582f690381035df, 0x232a099206ce8b78
d_2_16:         .dword 0xcd87f22aabf381e3, 0x40542b88da3f122e
d_2_17:         .dword 0x6091dbe141eeaad5, 0x94c20fe3d3a85cab
d_2_18:         .dword 0xef09427290df5610, 0xd3ea384fc347fb28
d_2_19:         .dword 0x9ebd74a9615c4f1b, 0xfb9a9123fb0b69ff
d_2_20:         .dword 0x86b9d73818a36527, 0x78e068f18a78d31d
d_2_21:         .dword 0xa0756d9f17ee47ec, 0x5a806b3dd9b96ea0
d_2_22:         .dword 0x1c2f6c8a76e6223a, 0x9973f07161e7e681
d_2_23:         .dword 0xff953fc3d5f5abb9, 0x1a1abc18fb851c50
d_2_24:         .dword 0x256efb0ede0e32c6, 0xd8e024e36531aac6
d_2_25:         .dword 0x1ecf6c6b8b26810b, 0x64bd4e8e417b06d8
d_2_26:         .dword 0x0fcc93895d24058d, 0x164fa81035afc013
d_2_27:         .dword 0xe13f377da6e26a67, 0xea17c01a96c19b81
                .dword 0xf4433d22dd4eabff, 0x0015ee95aa9d248c
                .dword 0xb692be03e20ec49d, 0x2a1ed49feca6827a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xcc0c7efe4da2e67a, 0xaeea9a4ff14e9958
                .dword 0x0e75c949edf41597, 0xd5c4b661d7fce387
d_3_0:          .dword 0x345c278e787f97c1, 0x3ad0d1fb196b3636
d_3_1:          .dword 0xddd70be401a0b2f2, 0x67628ddb791b3ce4
d_3_2:          .dword 0xe0f4f05abe3428a7, 0x3d484a6397184ac0
d_3_3:          .dword 0xdc1757813b849d92, 0x78970b16b3ffded6
d_3_4:          .dword 0x202d9e7c74ee1cb7, 0x1e1a1fd183c0a3aa
d_3_5:          .dword 0x595ebadce50cb5a1, 0xa5368c1dcb57e507
d_3_6:          .dword 0xa45ed62e4ecb9d8f, 0xd6776f55d6e20e53
d_3_7:          .dword 0x15f99c10b4172fad, 0x05708bbb8c180cdf
d_3_8:          .dword 0xbfe3a3f46511cbbf, 0x42622c48c9d24d4f
d_3_9:          .dword 0x0909632fbdfdd5a9, 0x90f126e618d08335
d_3_10:         .dword 0x6c4ba4c498037260, 0xac064a5d5d7241d2
d_3_11:         .dword 0x840a51e2d51651d7, 0xdaed59d5f1b79d67
d_3_12:         .dword 0x3d39faf072963d9f, 0xd41747e82da2cdab
d_3_13:         .dword 0x912722f705ea0f90, 0x87e1293b5842fe92
d_3_14:         .dword 0xc6db91c4f014592e, 0xd2d4dbe80ee2cc22
d_3_15:         .dword 0xb2be88bae50aa246, 0xf0ebb5ed73f134f0
d_3_16:         .dword 0x75cb973015581afe, 0xc8daf9065ddfc7f4
d_3_17:         .dword 0x22b7fc8504913e57, 0x5ea57f7970531c93
d_3_18:         .dword 0x33847953b8c7fa7f, 0x8d3d06ad4343a0a6
d_3_19:         .dword 0x24b52770b899bfd9, 0xb11608598fdddca7
d_3_20:         .dword 0x7585cc1804434fdd, 0x0998eb1c55c08a22
d_3_21:         .dword 0x2f6552387b743ae7, 0x6bcc6c6c678c91ea
d_3_22:         .dword 0xfa091694a58ae172, 0xe095cf678df9555e
d_3_23:         .dword 0x62f8dd8b92939935, 0x8028c33f10fb6882
d_3_24:         .dword 0xa1a643eaa1c4c949, 0x2e6fa73dacc4f533
d_3_25:         .dword 0xc027422db879c7ba, 0x11544b41a670250c
d_3_26:         .dword 0xbd01619906fae7de, 0x3378f360fa7f7712
d_3_27:         .dword 0x8867822e41464800, 0xdcd439c73764f41a
                .dword 0x33c46a2cf26e86cc, 0xb3cff430003ce64e
                .dword 0x9b898ebc4a085b5c, 0x2eb1b406e657f7d3
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x1c4dad5d36acf9f5, 0x8035dbc58b094c2d
                .dword 0xf47be78023add49d, 0x56f9f78cc46d00b7
d_4_0:          .dword 0xf363833ca031f7ab, 0x880ea8e9f2010bb1
d_4_1:          .dword 0xbad1f3fa694d5968, 0x103bdb26d189b2d2
d_4_2:          .dword 0x4ab19800d10a1deb, 0x88c5163c8aafd212
d_4_3:          .dword 0xde2ff46c6034d345, 0x4664ddd2af30de4d
d_4_4:          .dword 0xd4627e5c0729561c, 0x3754115659a5314e
d_4_5:          .dword 0xee529cee59de68df, 0x4f28a353babb00ce
d_4_6:          .dword 0xc0c4bafeee552199, 0x737692a769045972
d_4_7:          .dword 0x53aac561bfd77d28, 0x37c05946e3d45864
d_4_8:          .dword 0xc744c0911952ecfe, 0x3051f857fce20441
d_4_9:          .dword 0xdf9200ace3fc2d8c, 0x27ef2d88b7bc3d90
d_4_10:         .dword 0x63c94ea8ffae71d2, 0x2831b78b359d723a
d_4_11:         .dword 0xffd3a56e9d25c559, 0x9442af5949f76feb
d_4_12:         .dword 0x0e4b3dcc0a3f8475, 0x7f92a9184446126f
d_4_13:         .dword 0x7a24c8d88d00efaa, 0x2f19722758820c77
d_4_14:         .dword 0xa87d8177a2a2ade5, 0x4c1767b996da7c81
d_4_15:         .dword 0x3df664b67e9ca0a9, 0x3047c54f8b540b7e
d_4_16:         .dword 0x6c56f6dfb08b983c, 0x8ad9ce77c276e693
d_4_17:         .dword 0x2140d73ed7cc63a8, 0x83bfaead2e83442c
d_4_18:         .dword 0xd770fd69def5c367, 0x937d6ff69cf8c8c2
d_4_19:         .dword 0x88d501c27fa83bf7, 0x9810b22cb7be2052
d_4_20:         .dword 0x87569826c4347b9f, 0x4b95a24edc563368
d_4_21:         .dword 0x9fa8915caef089ab, 0xe6deaa4f76d77bdc
d_4_22:         .dword 0x5a8e0c3bf5b73a3c, 0xa39b5c9c068c2bcb
d_4_23:         .dword 0x712d1b8c181c9bf9, 0x52b87ee6c159cf75
d_4_24:         .dword 0xae2aa355005c2b4d, 0x2d2f0cdefaccbc20
d_4_25:         .dword 0x6dd21df74d571c1a, 0xee3fe222d6541a06
d_4_26:         .dword 0xa24f84a3bdeb78c1, 0x556125a149ae96a3
d_4_27:         .dword 0x2fdbef025056e977, 0xf8be8206f8b6d1fb
                .dword 0x2fa751f0684dfc0f, 0x8ffae6f957fd5682
                .dword 0x3727df304bb3c4d1, 0x8670714832dd3a80
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x050848c2ca13ced0, 0x62de5379fdc623ea
                .dword 0xa699655f94082a68, 0xaefc62dddbccd0a3
d_5_0:          .dword 0xc166ebbbb9a28698, 0x4f5bcf0e68f522f1
d_5_1:          .dword 0x826867aed343de00, 0x85746579b18e15ee
d_5_2:          .dword 0x192e7259b762b99f, 0x2cd8ac8fc685d1bc
d_5_3:          .dword 0x03e83c0df6e04f83, 0x0613169b2bf70ad4
d_5_4:          .dword 0x7f36efbf727a8216, 0x46f6d45674fad1ee
d_5_5:          .dword 0xf976af191767dc2b, 0x2ded3d4987a41252
d_5_6:          .dword 0x9fb8ebe731a2f756, 0x2c7ee835b2defaa3
d_5_7:          .dword 0x20a5ae7504046a72, 0xbf98ad47470c90ca
d_5_8:          .dword 0xadca7ffd8d4d3d6f, 0x94c8b8a964f6d520
d_5_9:          .dword 0x337bd492145699ff, 0xfc90e063f931e160
d_5_10:         .dword 0x2ab7ce1c6705c135, 0xb033048bea31fb59
d_5_11:         .dword 0x126e7c1d2703738e, 0xd5192570ef7ed866
d_5_12:         .dword 0x3362947f21f40246, 0x70a782aaff578ef7
d_5_13:         .dword 0x349182f7c45b1655, 0xfe19a41aecfa455d
d_5_14:         .dword 0x3d5423416bd2e6b3, 0x343481261be2d4a8
d_5_15:         .dword 0xa035d97018b6e39f, 0x0b6d6ee5d7a21a9e
d_5_16:         .dword 0x75e6827c4b4844ac, 0x1f3adb24917c5d35
d_5_17:         .dword 0x58eeb8098ddb4b24, 0x02ab13ea4a4f7ef9
d_5_18:         .dword 0xf3a144f9b9da74d8, 0x57146ad9b1ec8593
d_5_19:         .dword 0xe594ccd3d9cb1d48, 0x4e42ba067e11a90c
d_5_20:         .dword 0x4be86b98fdf0773d, 0xf65a568f7ae5c15f
d_5_21:         .dword 0x45d8fa122c6ed7e0, 0xd5d0c2bd3a3631a2
d_5_22:         .dword 0x695baff5fef2bb0e, 0xdc799d7c8680df3c
d_5_23:         .dword 0xd2f1f0ea98f0c272, 0x0a2cd82589826e0e
d_5_24:         .dword 0x7b4f71762081d8d6, 0x3bab60dd28a08471
d_5_25:         .dword 0x3d8228382b4d5f4b, 0xcd5fe6e6f390a9a9
d_5_26:         .dword 0xc1f59e61867c9164, 0x19194f2890beb758
d_5_27:         .dword 0x12750226361dbf15, 0xc231320c95353ffd
                .dword 0xb637465e1e32471f, 0xcbe8273bfef318ca
                .dword 0xb0606710bf3abc26, 0xe4c26e913063e553
         /* Random data */
_end_data5:
              
 
