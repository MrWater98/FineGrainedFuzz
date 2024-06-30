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
_p0:    csrrsi x13, satp, 30                      ;
_p1:    xor x11, x11, x11                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 4                          ;
        add x11, x11, x12                         ;
        csrrw x14, sepc, x11                      ;
_p2:    csrrsi x11, pmpaddr6, 30                  ;
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
_s0:    la x30, d_3_7                             ;
        addi x30, x30, -20                        ;
        amoxor.w x23, x23, (x30)                  ;
_s1:    fcvt.w.s x11, f7, dyn                     ;
_s2:    slli x2, x17, 0                           ;
_s3:    fmadd.s f23, f3, f12, f3, rdn             ;
_s4:    la x7, d_1_13                             ;
        sb x3, -31(x7)                            ;
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
_l0:    fclass.s x26, f17                         ;
_l1:    slli x11, x27, 30                         ;
_l2:    fsgnjx.s f15, f10, f17                    ;
_l3:    fnmadd.s f17, f16, f22, f16, rup          ;
_l4:    rem x23, x25, x11                         ;
_l5:    la x7, d_3_8                              ;
        addi x7, x7, -12                          ;
        sc.w x24, x13, (x7)                       ;
_l6:    ecall                                     ;
_l7:    la x14, d_2_24                            ;
        addi x14, x14, -16                        ;
        amomin.w x27, x14, (x14)                  ;
_l8:    xor x7, x7, x7                            ;
        addi x27, zero, 1                         ;
        slli x27, x27, 7                          ;
        add x7, x7, x27                           ;
        addi x5, zero, 3                          ;
        slli x5, x5, 15                           ;
        add x7, x7, x5                            ;
        addi x8, zero, 1                          ;
        slli x8, x8, 1                            ;
        add x7, x7, x8                            ;
        csrrc x19, mepc, x7                       ;
_l9:    la x28, d_2_26                            ;
        lwu x24, -4(x28)                          ;
_l10:   fmv.w.x f1, x17                           ;
_l11:   mulw x24, x5, x11                         ;
_l12:   ecall                                     ;
_l13:   la x20, d_3_21                            ;
        lbu x28, 23(x20)                          ;
_l14:   fsqrt.s f8, f1, rdn                       ;
_l15:   fclass.s x23, f7                          ;
_l16:   beq x10, x15, _l34                        ;
_l17:   fcvt.s.lu f3, x24, rmm                    ;
_l18:   sraiw x14, x19, 30                        ;
_l19:   fmv.x.w x2, f5                            ;
_l20:   la x16, _l166                             ;
        lwu x26, 28(x16)                          ;
_l21:   div x8, x19, x4                           ;
_l22:   fmsub.s f17, f8, f27, f7, dyn             ;
_l23:   la x22, d_0_12                            ;
        lwu x18, -28(x22)                         ;
_l24:   fcvt.s.lu f25, x25, rmm                   ;
_l25:   fmsub.s f27, f8, f6, f6, rup              ;
_l26:   csrrsi x21, stval, 16                     ;
_l27:   remu x15, x9, x14                         ;
_l28:   la x26, _l65                              ;
        lbu x29, -16(x26)                         ;
_l29:   subw x23, x23, x7                         ;
_l30:   fclass.s x26, f17                         ;
_l31:   la x20, d_1_15                            ;
        addi x20, x20, 24                         ;
        amomin.d x14, x10, (x20)                  ;
_l32:   la x9, d_1_5                              ;
        addi x9, x9, 4                            ;
        amoor.w x19, x24, (x9)                    ;
_l33:   la x17, d_0_17                            ;
        addi x17, x17, 16                         ;
        amoswap.d x4, x24, (x17)                  ;
_l34:   la x19, _l55                              ;
        lb x19, 1(x19)                            ;
_l35:   mul x27, x26, x21                         ;
_l36:   rem x21, x10, x9                          ;
_l37:   la x5, d_0_7                              ;
        addi x5, x5, -0                           ;
        lr.d x2, (x5)                             ;
_l38:   addi x4, x12, 887                         ;
_l39:   fmv.w.x f12, x11                          ;
_l40:   csrrsi x10, pmpaddr2, 12                  ;
_l41:   la x27, d_0_1                             ;
        lw x29, 24(x27)                           ;
_l42:   fence.i                                   ;
_l43:   srlw x6, x20, x15                         ;
_l44:   la x27, d_4_18                            ;
        addi x27, x27, 8                          ;
        amominu.d x16, x29, (x27)                 ;
_l45:   la x26, d_3_15                            ;
        addi x26, x26, -12                        ;
        amominu.w x30, x5, (x26)                  ;
_l46:   la x14, d_2_12                            ;
        addi x14, x14, 20                         ;
        amoor.w x20, x25, (x14)                   ;
_l47:   fcvt.s.l f16, x25, rne                    ;
_l48:   la x7, d_2_25                             ;
        addi x7, x7, 8                            ;
        amoand.w x1, x8, (x7)                     ;
_l49:   la x4, d_3_4                              ;
        lbu x12, -31(x4)                          ;
_l50:   srli x10, x13, 52                         ;
_l51:   la x11, d_1_24                            ;
        addi x11, x11, -0                         ;
        amoor.w x10, x22, (x11)                   ;
_l52:   bge x9, x29, _l82                         ;
_l53:   mulw x14, x10, x0                         ;
_l54:   slliw x2, x28, 9                          ;
_l55:   andi x18, x2, -1072                       ;
_l56:   fmax.s f22, f6, f1                        ;
_l57:   ecall                                     ;
_l58:   fnmadd.s f15, f15, f31, f17, rmm          ;
_l59:   fsgnjx.s f11, f10, f1                     ;
_l60:   fcvt.s.wu f27, x22, rup                   ;
_l61:   la x10, d_1_3                             ;
        addi x10, x10, 20                         ;
        amominu.w x6, x16, (x10)                  ;
_l62:   fmv.w.x f14, x7                           ;
_l63:   la x15, d_2_21                            ;
        sw x26, 24(x15)                           ;
_l64:   jal x21, _l85                             ;
_l65:   divu x15, x8, x28                         ;
_l66:   la x13, d_3_23                            ;
        ld x8, -8(x13)                            ;
_l67:   mulh x28, x18, x26                        ;
_l68:   la x17, _l26                              ;
        flw f0, -28(x17)                          ;
_l69:   remu x0, x11, x9                          ;
_l70:   fcvt.s.wu f3, x28, dyn                    ;
_l71:   sraw x0, x22, x15                         ;
_l72:   remu x24, x12, x29                        ;
_l73:   xori x3, x13, 635                         ;
_l74:   div x7, x6, x24                           ;
_l75:   fmin.s f16, f16, f1                       ;
_l76:   fnmadd.s f11, f7, f25, f8, dyn            ;
_l77:   andi x3, x14, -2047                       ;
_l78:   ebreak                                    ;
_l79:   div x2, x7, x15                           ;
_l80:   la x28, _l113                             ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l81:   xor x6, x6, x6                            ;
        addi x20, zero, 1                         ;
        slli x20, x20, 16                         ;
        add x6, x6, x20                           ;
        addi x16, zero, 1                         ;
        slli x16, x16, 13                         ;
        add x6, x6, x16                           ;
        addi x11, zero, 3                         ;
        slli x11, x11, 5                          ;
        add x6, x6, x11                           ;
        csrrs x8, sie, x6                         ;
_l82:   fsub.s f7, f5, f15, rdn                   ;
_l83:   la x29, d_3_19                            ;
        addi x29, x29, 16                         ;
        lr.d x14, (x29)                           ;
_l84:   ori x13, x8, 1072                         ;
_l85:   la x10, d_3_20                            ;
        lhu x22, -30(x10)                         ;
_l86:   fnmadd.s f24, f1, f17, f20, dyn           ;
_l87:   divw x14, x4, x14                         ;
_l88:   fcvt.w.s x26, f7, rne                     ;
_l89:   blt x13, x6, _l136                        ;
_l90:   la x18, _l182                             ;
        csrrw zero, sepc, x18                     ;
        sret                                      ;
_l91:   jal x14, _l157                            ;
_l92:   la x30, _l146                             ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l93:   lui x10, 519054                           ;
_l94:   flt.s x27, f28, f15                       ;
_l95:   srai x9, x1, 7                            ;
_l96:   la x2, d_0_0                              ;
        lb x30, 9(x2)                             ;
_l97:   subw x3, x25, x11                         ;
_l98:   la x1, d_5_24                             ;
        addi x1, x1, -28                          ;
        amoswap.w x4, x5, (x1)                    ;
_l99:   fcvt.w.s x17, f30, rtz                    ;
_l100:  rem x8, x19, x13                          ;
_l101:  subw x18, x19, x6                         ;
_l102:  auipc x17, 0                              ;
_l103:  xor x21, x21, x21                         ;
        addi x4, zero, 3                          ;
        slli x4, x4, 20                           ;
        add x21, x21, x4                          ;
        addi x22, zero, 3                         ;
        slli x22, x22, 4                          ;
        add x21, x21, x22                         ;
        csrrs x8, mcause, x21                     ;
_l104:  fmv.w.x f26, x29                          ;
_l105:  fclass.s x21, f10                         ;
_l106:  rem x14, x7, x17                          ;
_l107:  fence.i                                   ;
_l108:  remuw x23, x2, x9                         ;
_l109:  fcvt.s.wu f9, x1, rdn                     ;
_l110:  sltiu x23, x25, 1806                      ;
_l111:  fclass.s x23, f1                          ;
_l112:  fmadd.s f18, f21, f26, f20, rmm           ;
_l113:  fle.s x20, f5, f17                        ;
_l114:  la x3, _l190                              ;
        jalr x26, 0(x3)                           ;
_l115:  blt x12, x18, _l156                       ;
_l116:  addw x22, x20, x7                         ;
_l117:  srli x24, x25, 63                         ;
_l118:  la x2, d_0_4                              ;
        addi x2, x2, -0                           ;
        lr.d x25, (x2)                            ;
_l119:  remw x14, x22, x2                         ;
_l120:  remw x22, x15, x16                        ;
_l121:  la x20, _l155                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l122:  la x19, d_0_27                            ;
        addi x19, x19, -28                        ;
        amomax.w x1, x3, (x19)                    ;
_l123:  xor x6, x6, x6                            ;
        csrrs x18, mie, x6                        ;
_l124:  la x26, _l37                              ;
        lbu x21, 14(x26)                          ;
_l125:  subw x11, x28, x12                        ;
_l126:  fcvt.lu.s x12, f18, dyn                   ;
_l127:  fcvt.lu.s x7, f6, rup                     ;
_l128:  flt.s x17, f31, f1                        ;
_l129:  la x8, d_1_22                             ;
        addi x8, x8, -12                          ;
        amomin.w x3, x27, (x8)                    ;
_l130:  la x11, d_0_22                            ;
        addi x11, x11, 0                          ;
        amomin.d x20, x22, (x11)                  ;
_l131:  fence                                     ;
_l132:  xori x18, x1, -0                          ;
_l133:  la x30, _l168                             ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l134:  auipc x6, 0                               ;
_l135:  la x25, d_2_27                            ;
        lui x14, 0xffe00                          ;
        xor x25, x25, x14                         ;
        ld x1, -16(x25)                           ;
_l136:  la x22, d_0_19                            ;
        addi x22, x22, 0                          ;
        amoor.d x21, x27, (x22)                   ;
_l137:  fmv.w.x f6, x9                            ;
_l138:  xori x10, x11, -0                         ;
_l139:  bltu x15, x4, _l172                       ;
_l140:  mulhsu x27, x1, x23                       ;
_l141:  fcvt.l.s x19, f4, dyn                     ;
_l142:  la x26, d_4_13                            ;
        addi x26, x26, 24                         ;
        amomax.d x20, x27, (x26)                  ;
_l143:  fadd.s f6, f6, f8, rup                    ;
_l144:  remu x20, x10, x29                        ;
_l145:  xor x16, x16, x16                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 13                         ;
        add x16, x16, x27                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 18                         ;
        add x16, x16, x11                         ;
        csrrs x21, mtval, x16                     ;
_l146:  la x14, d_5_4                             ;
        flw f17, 4(x14)                           ;
_l147:  la x20, d_5_24                            ;
        lbu x15, 31(x20)                          ;
_l148:  fsgnjx.s f0, f31, f21                     ;
_l149:  fmsub.s f30, f24, f14, f27, rmm           ;
_l150:  la x11, d_0_13                            ;
        addi x11, x11, -16                        ;
        lr.d x13, (x11)                           ;
_l151:  sraw x6, x28, x21                         ;
_l152:  fcvt.s.l f10, x8, rtz                     ;
_l153:  rem x0, x6, x26                           ;
_l154:  srlw x5, x30, x27                         ;
_l155:  subw x20, x13, x28                        ;
_l156:  srlw x19, x6, x12                         ;
_l157:  fcvt.w.s x0, f5, rdn                      ;
_l158:  remuw x1, x29, x17                        ;
_l159:  fsub.s f27, f0, f30, dyn                  ;
_l160:  remu x16, x5, x28                         ;
_l161:  fence                                     ;
_l162:  la x24, d_2_18                            ;
        addi x24, x24, 8                          ;
        sc.d x12, x24, (x24)                      ;
_l163:  la x24, d_1_18                            ;
        lui x14, 0xffe00                          ;
        xor x24, x24, x14                         ;
        flw f7, -20(x24)                          ;
_l164:  ebreak                                    ;
_l165:  la x28, d_3_20                            ;
        addi x28, x28, -0                         ;
        amoand.d x25, x27, (x28)                  ;
_l166:  addiw x12, x24, 2047                      ;
_l167:  mulw x29, x14, x23                        ;
_l168:  srlw x12, x0, x28                         ;
_l169:  mulhu x4, x16, x11                        ;
_l170:  flt.s x24, f8, f13                        ;
_l171:  beq x12, x20, _l182                       ;
_l172:  sllw x26, x5, x23                         ;
_l173:  la x17, d_5_8                             ;
        sw x13, -12(x17)                          ;
_l174:  sllw x17, x10, x25                        ;
_l175:  la x28, d_5_22                            ;
        lhu x8, -12(x28)                          ;
_l176:  la x26, d_5_21                            ;
        sb x13, -0(x26)                           ;
_l177:  fcvt.s.w f4, x12, dyn                     ;
_l178:  la x16, d_4_5                             ;
        addi x16, x16, 4                          ;
        lr.w x28, (x16)                           ;
_l179:  sraiw x14, x26, 30                        ;
_l180:  srliw x4, x4, 7                           ;
_l181:  bgeu x15, x24, _l198                      ;
_l182:  fmsub.s f8, f6, f19, f5, rne              ;
_l183:  la x5, d_5_5                              ;
        addi x5, x5, 12                           ;
        amoxor.w x25, x26, (x5)                   ;
_l184:  fsub.s f0, f15, f17, rup                  ;
_l185:  la x27, d_0_20                            ;
        addi x27, x27, -0                         ;
        amoxor.w x4, x27, (x27)                   ;
_l186:  la x27, d_2_16                            ;
        addi x27, x27, 8                          ;
        amomax.d x6, x22, (x27)                   ;
_l187:  csrrci x30, mstatus, 30                   ;
_l188:  la x20, d_4_1                             ;
        addi x20, x20, -16                        ;
        sc.w x16, x21, (x20)                      ;
_l189:  fmin.s f31, f12, f7                       ;
_l190:  divw x21, x1, x11                         ;
_l191:  la x3, d_5_7                              ;
        addi x3, x3, 0                            ;
        amoadd.d x19, x26, (x3)                   ;
_l192:  la x21, d_1_26                            ;
        sh x15, 28(x21)                           ;
_l193:  xor x21, x21, x21                         ;
        addi x29, zero, 3                         ;
        slli x29, x29, 9                          ;
        add x21, x21, x29                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 4                          ;
        add x21, x21, x19                         ;
        csrrs x27, fflags, x21                    ;
_l194:  slliw x21, x29, 28                        ;
_l195:  la x8, d_1_17                             ;
        addi x8, x8, -8                           ;
        sc.d x20, x8, (x8)                        ;
_l196:  andi x29, x30, 1956                       ;
_l197:  lui x24, 22                               ;
_l198:  andi x16, x7, 394                         ;
_l199:  la x28, d_3_5                             ;
        addi x28, x28, 0                          ;
        amomaxu.w x5, x13, (x28)                  ;
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
                .dword 0x0da168a510f0cac8, 0xacd16d7f80788cf8
                .dword 0x2b781398b4eaa4c1, 0x1dbb41dc7342fbc9
d_0_0:          .dword 0x6513e2ce14b9d743, 0x0574f26464101963
d_0_1:          .dword 0x8f9d9f0cfa9a8a7a, 0x23f971e22c2058fc
d_0_2:          .dword 0x290c0dd8f2ecd22d, 0xaf8898804a1e383e
d_0_3:          .dword 0xe9c3350480150836, 0x7762d2f53a69815d
d_0_4:          .dword 0x0c184b3830af84b9, 0xa0a8f73ad1d63556
d_0_5:          .dword 0x6e8c71842694b898, 0xaaabac10fad45a6a
d_0_6:          .dword 0x464d3af52bcb8967, 0xe2bf3a6348c98e63
d_0_7:          .dword 0x62ceab96b8053917, 0xcf439a199bd0dfa5
d_0_8:          .dword 0x3be50e557b6e41ec, 0x5a42d7e8e6dd236a
d_0_9:          .dword 0x527d33f8fd001a45, 0xf5fa724c1f2ca130
d_0_10:         .dword 0x651d878a7c11ffe2, 0xc90a9361447d11da
d_0_11:         .dword 0xe56aca0006973d5b, 0xc48a7b5c37598e06
d_0_12:         .dword 0x6097ae1bc0f935e9, 0x89fad810a205a27e
d_0_13:         .dword 0x718ea92c1b22a38b, 0x3e252556d8a67746
d_0_14:         .dword 0x0073d627b45bd855, 0xb328b50afe5156ae
d_0_15:         .dword 0x0418fbdcad089545, 0xded96c729dbbeddd
d_0_16:         .dword 0xb2671991aea1bdb4, 0xd2122595a8d3da16
d_0_17:         .dword 0xa7fa4ff34f2b0b07, 0xa0fd5564b1a51c7e
d_0_18:         .dword 0x621e7aeaf79b5cf4, 0xfeae8c0d08bc1ea3
d_0_19:         .dword 0x82d08ec4e36984d7, 0xfccc79b5b65d8374
d_0_20:         .dword 0xa534d036ec0580e4, 0xbce1aafab0e17e74
d_0_21:         .dword 0xeaa7ef77381831c2, 0x858e417dac60e4e4
d_0_22:         .dword 0x1c4ff5f30eba7e98, 0x3ea2e633586bdc41
d_0_23:         .dword 0x6f85280635e03fd7, 0x7d29e1dbfa767022
d_0_24:         .dword 0xa53a7adbe839d8d3, 0x67645a5773fd3b15
d_0_25:         .dword 0xecd58b4e4c0d9791, 0xd5c3d697d9e7deb8
d_0_26:         .dword 0x79f10fc571965cc9, 0x5bc5ff63f07d265c
d_0_27:         .dword 0x8e1e2a620df20142, 0xa28ea5b804e6ba91
                .dword 0x73f072be3ba1f5df, 0x9d1e19ff71971175
                .dword 0xbc95ba1c5e129349, 0xb7a9febec711f554
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3cb3e4feab24a8f8, 0x557a814c209e79c4
                .dword 0x3cc735ec474fbb10, 0x9ef08d0264991ad7
d_1_0:          .dword 0x5be41b941556af2d, 0xf7ef88462ff2e989
d_1_1:          .dword 0xcbc870acadd27644, 0x3895149df4a50e74
d_1_2:          .dword 0x8f437513839648f1, 0xa12962ae524bb48a
d_1_3:          .dword 0x9518171c99347bde, 0x008938a752e4d1ee
d_1_4:          .dword 0xb83ede9aa4da0056, 0x7a707cecd305dca6
d_1_5:          .dword 0x6fee8220c01cd3c7, 0x563e16af83e07e35
d_1_6:          .dword 0x2836786e19090b7e, 0x4258cc5f409b0dc7
d_1_7:          .dword 0xb75185db84b31520, 0x100655b492ed1c82
d_1_8:          .dword 0xd557d336bab14adb, 0xe87d9c294dbed7ad
d_1_9:          .dword 0x943a10aa9380d727, 0x2f379d8560cceaf3
d_1_10:         .dword 0xb6354878e6424f05, 0x611c28e0615f8406
d_1_11:         .dword 0x0a914815531a49e1, 0xdd231edcd04ce9b6
d_1_12:         .dword 0x5506152c136b825d, 0xfdf150706d72db43
d_1_13:         .dword 0x492c8efc2ac67368, 0xc28a1a87e4750595
d_1_14:         .dword 0x74e16cc1f1b87c11, 0x35b9bc0ee73726b0
d_1_15:         .dword 0x900bfada63f3fb69, 0x52e3fe6ffbcf69ee
d_1_16:         .dword 0xafbe9bc3a704cadb, 0xb7213cfbd5b6a6ce
d_1_17:         .dword 0xb33b5a8157bbd577, 0xb58ea3955d170661
d_1_18:         .dword 0x5015e89e55b4ab8b, 0x6611a6436d1db504
d_1_19:         .dword 0xc419c417aca2a110, 0xcda003a5be1519cc
d_1_20:         .dword 0xaba5e7be81c23e87, 0x02d90a916f1ded00
d_1_21:         .dword 0x091ffea64cac6121, 0x9ff42d7c448c5589
d_1_22:         .dword 0x04019302dcdfbc92, 0xf0c2cb8eaf0688d5
d_1_23:         .dword 0xbab118c83eeb861d, 0x1ad3e0ccadb8b876
d_1_24:         .dword 0x0ae5ec58d6609051, 0x35a3480607a381e7
d_1_25:         .dword 0x3c0ce1a328a55179, 0xe54821e80fcfaf70
d_1_26:         .dword 0xa8b66511a7ec7c70, 0xd0f4bb797fb45f32
d_1_27:         .dword 0x06a61dd30c89d5c8, 0x14cf73432d3586a5
                .dword 0xfa3841a9cb8ffcd5, 0xde62043b4d66c603
                .dword 0x1588c79fb6802363, 0x95e03d97c9551d83
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8467552f86bb294f, 0xb1193868cda50904
                .dword 0x3a41e544a1c49221, 0xda7a6f8a8c77ef83
d_2_0:          .dword 0xa2e9d2c8d84d3885, 0x19c04c42599e142a
d_2_1:          .dword 0x7c31122620f0bc48, 0x2a9a2776a154e9d9
d_2_2:          .dword 0x7e785a6f6e9cac98, 0x6448540e3e966417
d_2_3:          .dword 0x83b8a73d0b91922e, 0xd9bf8b61e856c12e
d_2_4:          .dword 0x19e1d4d6e00729ed, 0xddeb38cf97c3bf3b
d_2_5:          .dword 0xd01a18be1fa6ee16, 0xacd8ceb031bdd72f
d_2_6:          .dword 0x2fc8c2c1de512aa0, 0xca92d8a29f6f4352
d_2_7:          .dword 0xab0608f3d362db62, 0x45a69bf5ab29e42a
d_2_8:          .dword 0xe9779bc3754ee0f6, 0x773abd90c3f3cfdb
d_2_9:          .dword 0x54abfe7f32ec5aab, 0x08e5d6b977705220
d_2_10:         .dword 0x8cda6629fff2b491, 0x251b82c000aa0331
d_2_11:         .dword 0x96d9db93b43dcd4e, 0x8e86278df713775c
d_2_12:         .dword 0x7a5a7f881d7f2569, 0x168d993e887321f9
d_2_13:         .dword 0x13e61e147e39c72e, 0xce06128a04e3f39a
d_2_14:         .dword 0xbb16c2693a92cc70, 0x6417eb12e1897439
d_2_15:         .dword 0x2b666e4b57b858a0, 0x1c52ec1a94762554
d_2_16:         .dword 0xab6ef3d423e57659, 0xdf022ac9c2e6f98a
d_2_17:         .dword 0x1b9dbd29069f2b8b, 0x2e06900ae01fc052
d_2_18:         .dword 0x4934a655f7e7153d, 0x896effc5b6f0f888
d_2_19:         .dword 0x96539c22fcd53c07, 0x4ee8205f7bfff621
d_2_20:         .dword 0xd39c0277c70a3bbb, 0xa0f5b9a98f127670
d_2_21:         .dword 0x8b5c723e4eb4c76b, 0xa450fc87bed1fe8f
d_2_22:         .dword 0x21444eef9e77c7a9, 0x6d1ef59a5a0aaaab
d_2_23:         .dword 0xf314d0038101038a, 0x368d19f776fffeb7
d_2_24:         .dword 0xfde77504de534473, 0x94014d38eb27da65
d_2_25:         .dword 0x14660ddbdd31c4a1, 0x0edee0d49a89cca2
d_2_26:         .dword 0x28e670755146af73, 0xa1c6b9a57eee2742
d_2_27:         .dword 0xd774f377534568cb, 0x164aa4722c352139
                .dword 0x08f01f764cd09d2d, 0xd31ac080dbe4aaf5
                .dword 0xc08cc46fcae5761a, 0x522b22240967ad70
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc3e3672695037cd5, 0x430d643c285f61f2
                .dword 0x15862bf3999c3e6c, 0x3d6d400a2390580e
d_3_0:          .dword 0xb227a83b1314e170, 0x7c2e409b759115fb
d_3_1:          .dword 0xf51a97abbbb5b60c, 0xf1d2ba44d6013dc5
d_3_2:          .dword 0x4c29a525160ebc7d, 0x61bea8e4634cdbd4
d_3_3:          .dword 0x93b29ee99c4ab6e7, 0x64f0d35510167747
d_3_4:          .dword 0xef5bdc1cd7e7dbc0, 0xd785fb9850d2d4d5
d_3_5:          .dword 0xeeedfe02ebd1aceb, 0x92eac257ab077bdf
d_3_6:          .dword 0xce149043bdfd9082, 0x51be860fd4b6240f
d_3_7:          .dword 0xfc297b577d3c5045, 0x46a2521f58d2f0de
d_3_8:          .dword 0xe13a3d6dd8d8cd3a, 0x90d98a13aa349584
d_3_9:          .dword 0xf1391e782cd71fd2, 0xe00bbfb3afccdf35
d_3_10:         .dword 0x139b820e5f78194b, 0x36009c2507ea6088
d_3_11:         .dword 0xda0dd0fbaebad32c, 0xec77509f8ba552e1
d_3_12:         .dword 0x36e19491a3e9cc7d, 0xa733dd8dbee20aa4
d_3_13:         .dword 0x0b3491f92aff10ea, 0x52389e1a7f707f9a
d_3_14:         .dword 0x67ea76a2b793566c, 0xe65a1a95c325e0c1
d_3_15:         .dword 0x497361a96136d0a1, 0x414e278e52c39cc8
d_3_16:         .dword 0xc0cc22eb1d1008f9, 0xbd4983cd347c1b32
d_3_17:         .dword 0x6603f8a090cc7cc7, 0x9e39b962c53e4a7e
d_3_18:         .dword 0x300ae34e5e881fb9, 0xd2c84aed0bc813e3
d_3_19:         .dword 0x1093ceea9411541c, 0x539e5e54536e130a
d_3_20:         .dword 0x0eef4e9ee2108afb, 0x1415b60ca8dafef1
d_3_21:         .dword 0x65aa142b8589f8e9, 0xb92a02bebacf4fa4
d_3_22:         .dword 0x72d29fc9183cfb8c, 0x1e421715dccb465b
d_3_23:         .dword 0xe53280702e8f5b57, 0xe73ea14bf844a439
d_3_24:         .dword 0x6214b87140fdc905, 0x00a89ca63fa817c0
d_3_25:         .dword 0xf50a2f6ca2ee9c67, 0xc8dd2977c7bce9a9
d_3_26:         .dword 0x46932b5231b3cdd9, 0x9190001cfb3dfa46
d_3_27:         .dword 0x7a83c877b7599644, 0xe7503050aeff9a3d
                .dword 0x5c5f3ea0c49f843e, 0x7fca788b7e6a32c7
                .dword 0x792c2522ec9cef5c, 0x63d93bd6776730ee
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x94524838885d4f6c, 0xc6389bcbadf6b2e6
                .dword 0x2a08400ca79801f3, 0x2425146bbc42e177
d_4_0:          .dword 0xad9211bb434534d9, 0x4767926bfe61cf64
d_4_1:          .dword 0xbc96a450811603ae, 0xe01766d6d753bc4c
d_4_2:          .dword 0xd2bb843b90e56909, 0x4d57311196c4683f
d_4_3:          .dword 0x2addacfbfcb9d319, 0x3b1cc1f33316b693
d_4_4:          .dword 0xddebdef00b84d687, 0xd916cfdd90f262de
d_4_5:          .dword 0x52d7d2f18d707033, 0xbce784fbc175e096
d_4_6:          .dword 0x0ecf31fa3e7e2fcc, 0x296d28445e19af44
d_4_7:          .dword 0xf319873823fcd85b, 0x53267f4a46cc089a
d_4_8:          .dword 0x5a920de406208938, 0x119ab8142feea3a3
d_4_9:          .dword 0x2bf7cf0bd782fdc0, 0x71f6aff54cf65b74
d_4_10:         .dword 0xaff0b3e02006b803, 0x349e27e55f20c0ab
d_4_11:         .dword 0x68fddb076d0a7529, 0x12527f2d16f7cd62
d_4_12:         .dword 0xff34338c200dbb42, 0x45d4d2382b96b18a
d_4_13:         .dword 0xcdfc44627214be49, 0xb44bf8c2eb7341e0
d_4_14:         .dword 0x7305d34326d8e61b, 0xa6e624c02edfb3b3
d_4_15:         .dword 0xd9a6f1753da9c409, 0xf121b2e564b6d329
d_4_16:         .dword 0x3b97280e91d8d54a, 0xe49d03423bef5fae
d_4_17:         .dword 0x96942e28a461dd4b, 0xb874854a82ccbef3
d_4_18:         .dword 0x8da58e355c409e0d, 0xa77948c24043e7c8
d_4_19:         .dword 0x6fea4ed46d1913e6, 0xc05762becceb15de
d_4_20:         .dword 0x53233b4226ffbefa, 0x57a008f8b3c707bc
d_4_21:         .dword 0x14f6355fc6c2cf79, 0x0f4165e2e7fd2cf5
d_4_22:         .dword 0xdce07c95843f3d05, 0x1919ccf4c36830ed
d_4_23:         .dword 0xc52a6dca94126b7d, 0x7d7fcc4f8e0b533c
d_4_24:         .dword 0x1e4c4c6b5e527d9c, 0xd1e16874c059a8c3
d_4_25:         .dword 0x023580fef25ae305, 0x7be10507424b4aaa
d_4_26:         .dword 0x80cabed9bb56ea25, 0x16c82152c95b632a
d_4_27:         .dword 0xb8e2428c319acf23, 0x7f69954afc1c246e
                .dword 0xbfd2f9d9a1968c28, 0x4078a818f224c60b
                .dword 0xe162db889eed4a88, 0x210fe45482568997
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x899461a013709c6c, 0x3609c24973789eaa
                .dword 0x7ce3ebcc05be5acf, 0xbb76e355dc37e8cb
d_5_0:          .dword 0xcde519b68c04a401, 0x839d24017313970b
d_5_1:          .dword 0x222a8c9ebee58ce1, 0x93b27e2a96107465
d_5_2:          .dword 0xed98c74e71c66331, 0xcae6b3f77b7092dc
d_5_3:          .dword 0xff88966b3153cdd2, 0x11ec95280cbf632a
d_5_4:          .dword 0x3b2f1989a74a9f43, 0x745525625c18ddc1
d_5_5:          .dword 0xffc6e49c9d662002, 0x4caf6fd743bee437
d_5_6:          .dword 0x84092cc924efa4cb, 0x77ee36f005af2c75
d_5_7:          .dword 0xf959d61bed207a02, 0xd2abca785d6efc2e
d_5_8:          .dword 0xcbb64341a49c6d83, 0x6931bdbc9204f797
d_5_9:          .dword 0x471d31cfd51734fd, 0xf2e4ab28fb7785b4
d_5_10:         .dword 0xcb76109588b64758, 0xd946fd7d9b29e768
d_5_11:         .dword 0x889a106e25ed7fb9, 0x2d1314b0b6a5a905
d_5_12:         .dword 0x67efefa413a1b928, 0xe81bcd82bf1220f2
d_5_13:         .dword 0xa4a0d510e3d73653, 0x14aa9b86cd64c3eb
d_5_14:         .dword 0x14de0beba0ff2a21, 0x5aee2c6263f3de5e
d_5_15:         .dword 0x581bdd6f4292c74e, 0x44a998127e8c460e
d_5_16:         .dword 0x1e5020e97cd42aed, 0x238c2a0bf2236164
d_5_17:         .dword 0x72a105b03e35f848, 0x49004a5ed93454fc
d_5_18:         .dword 0x4983b58eee8a2662, 0x5b5b17effa4d2d1a
d_5_19:         .dword 0x1dd9bad2e72fa513, 0x8aa7afa669a30c5a
d_5_20:         .dword 0x69307a90a9aea66b, 0x2ae06178776b009c
d_5_21:         .dword 0x23a3e3dbeea27be2, 0xb1f84d8e87e18e7f
d_5_22:         .dword 0xb2937027d3f070ea, 0xf0ad5db19ecc628b
d_5_23:         .dword 0x1edc1a4a30c938ff, 0xb28b3210e9abfb21
d_5_24:         .dword 0xfd6583ba30316e09, 0x5c232ada6a69fe82
d_5_25:         .dword 0x51350bd805eb2584, 0x4d6ce1b5d56e66ce
d_5_26:         .dword 0x84ae58579a433585, 0x90a36bbf5fa5b5d1
d_5_27:         .dword 0x9222ac56e9b54cc7, 0x5c6161058f635a4b
                .dword 0x896ec379e62945f6, 0xc53fc6afd23f4651
                .dword 0xe09d028e56c23e69, 0x8205c89bd7a2d6f9
         /* Random data */
_end_data5:
              
 
