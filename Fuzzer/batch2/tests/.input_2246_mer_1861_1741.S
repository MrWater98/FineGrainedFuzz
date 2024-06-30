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
_p0:    csrrwi x14, sscratch, 31                  ;
_p1:    csrrwi x10, scause, 16                    ;
_p2:    csrrsi x14, satp, 12                      ;
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
_s0:    la x3, d_0_0                              ;
        addi x3, x3, -4                           ;
        amoadd.w x15, x15, (x3)                   ;
_s1:    srli x20, x8, 10                          ;
_s2:    la x18, d_2_17                            ;
        addi x18, x18, 20                         ;
        lr.w x2, (x18)                            ;
_s3:    srai x11, x0, 11                          ;
_s4:    la x7, d_3_21                             ;
        lui x30, 0xffe00                          ;
        xor x7, x7, x30                           ;
        lb x1, 31(x7)                             ;
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
_l0:    addw x19, x19, x16                        ;
_l1:    fmv.w.x f16, x20                          ;
_l2:    la x9, d_0_12                             ;
        lhu x13, 16(x9)                           ;
_l3:    fsgnjn.s f20, f26, f20                    ;
_l4:    la x11, d_4_11                            ;
        flw f16, 20(x11)                          ;
_l5:    slliw x11, x11, 31                        ;
_l6:    xori x21, x25, -560                       ;
_l7:    la x12, _l191                                     ;
        csrrw zero, mepc, x12                     ;
        mret                                      ;
_l8:    la x11, d_4_21                            ;
        addi x11, x11, -0                         ;
        amoswap.d x11, x11, (x11)                 ;
_l9:    la x19, d_5_26                            ;
        lwu x28, 28(x19)                          ;
_l10:   la x14, d_1_1                             ;
        fsw f22, -20(x14)                         ;
_l11:   la x10, d_3_23                            ;
        sd x1, -16(x10)                           ;
_l12:   blt x17, x10, _l90                                ;
_l13:   la x10, d_0_9                             ;
        lh x26, 0(x10)                            ;
_l14:   fcvt.lu.s x28, f1, dyn                    ;
_l15:   la x30, d_1_9                             ;
        lui x6, 0xffe00                           ;
        xor x30, x30, x6                          ;
        sd x14, -16(x30)                          ;
_l16:   ori x12, x26, 1090                        ;
_l17:   sraw x24, x2, x3                          ;
_l18:   la x20, d_3_7                             ;
        sh x19, -0(x20)                           ;
_l19:   fsqrt.s f20, f14, rup                     ;
_l20:   addw x5, x6, x15                          ;
_l21:   la x12, _l32                              ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l22:   blt x9, x7, _l110                                 ;
_l23:   bne x25, x18, _l42                        ;
_l24:   subw x17, x28, x18                        ;
_l25:   la x8, d_5_20                             ;
        addi x8, x8, -8                           ;
        amomax.d x19, x14, (x8)                   ;
_l26:   mulw x2, x8, x7                           ;
_l27:   bge x30, x26, _l175                               ;
_l28:   mulh x14, x26, x14                        ;
_l29:   fle.s x7, f10, f25                        ;
_l30:   mulhsu x25, x22, x16                      ;
_l31:   fle.s x5, f23, f28                        ;
_l32:   fsgnjn.s f17, f29, f31                    ;
_l33:   flt.s x27, f14, f14                       ;
_l34:   fadd.s f13, f31, f16, rne                 ;
_l35:   fcvt.wu.s x10, f2, dyn                    ;
_l36:   la x18, d_0_20                            ;
        srai x18, x18, 1                          ;
        csrrs x5, pmpaddr5, x18                   ;
_l37:   fcvt.s.lu f14, x1, rtz                    ;
_l38:   divw x9, x11, x16                         ;
_l39:   la x18, _l18                                      ;
        lbu x22, -20(x18)                         ;
_l40:   bgeu x26, x26, _l114                              ;
_l41:   la x12, d_5_10                            ;
        lw x7, -24(x12)                           ;
_l42:   remu x1, x11, x15                         ;
_l43:   bge x19, x10, _l120                               ;
_l44:   csrrci x21, pmpaddr0, 13                  ;
_l45:   fadd.s f29, f23, f17, rne                 ;
_l46:   la x16, d_1_3                             ;
        addi x16, x16, -28                        ;
        amoand.w x9, x4, (x16)                    ;
_l47:   sllw x8, x17, x29                         ;
_l48:   csrrci x27, pmpaddr5, 31                  ;
_l49:   subw x15, x9, x11                         ;
_l50:   la x22, d_5_18                            ;
        fsw f20, -4(x22)                          ;
_l51:   mulw x0, x14, x1                          ;
_l52:   la x28, d_0_5                             ;
        addi x28, x28, 0                          ;
        sc.w x20, x22, (x28)                      ;
_l53:   ebreak                                    ;
_l54:   fsub.s f30, f22, f6, rne                  ;
_l55:   fcvt.lu.s x22, f24, rdn                   ;
_l56:   la x24, d_1_2                             ;
        lb x20, -31(x24)                          ;
_l57:   la x29, d_3_16                            ;
        addi x29, x29, -16                        ;
        amomin.d x20, x25, (x29)                  ;
_l58:   srlw x27, x27, x24                        ;
_l59:   blt x23, x27, _l85                                ;
_l60:   blt x7, x21, _l88                         ;
_l61:   fle.s x21, f0, f8                         ;
_l62:   sltiu x3, x14, -1677                      ;
_l63:   srli x23, x6, 1                           ;
_l64:   subw x28, x17, x23                        ;
_l65:   addiw x14, x28, -1935                     ;
_l66:   mulh x7, x20, x6                          ;
_l67:   fcvt.l.s x7, f15, rdn                     ;
_l68:   la x19, d_4_4                             ;
        addi x19, x19, 0                          ;
        amoxor.d x8, x3, (x19)                    ;
_l69:   fence.i                                   ;
_l70:   la x2, d_0_17                             ;
        addi x2, x2, -8                           ;
        lr.d x3, (x2)                             ;
_l71:   la x17, d_0_4                             ;
        addi x17, x17, -8                         ;
        amoxor.w x25, x22, (x17)                  ;
_l72:   la x18, d_4_9                             ;
        sd x13, 24(x18)                           ;
_l73:   srli x21, x8, 45                          ;
_l74:   fcvt.s.w f7, x7, rup                      ;
_l75:   la x23, d_1_4                             ;
        addi x23, x23, -20                        ;
        amomaxu.w x11, x18, (x23)                 ;
_l76:   fcvt.s.wu f24, x11, rne                   ;
_l77:   la x14, d_2_6                             ;
        flw f0, 0(x14)                            ;
_l78:   remu x12, x25, x25                        ;
_l79:   la x21, d_1_5                             ;
        addi x21, x21, 8                          ;
        amoand.d x1, x8, (x21)                    ;
_l80:   slli x26, x15, 18                         ;
_l81:   fmsub.s f17, f28, f4, f21, rdn            ;
_l82:   fnmadd.s f3, f20, f24, f13, rdn           ;
_l83:   fdiv.s f16, f22, f18, rdn                 ;
_l84:   sraw x22, x18, x18                        ;
_l85:   la x5, d_1_24                             ;
        addi x5, x5, -16                          ;
        lr.d x29, (x5)                            ;
_l86:   bge x17, x9, _l182                                ;
_l87:   la x16, d_5_3                             ;
        sd x29, -0(x16)                           ;
_l88:   bne x8, x1, _l100                                 ;
_l89:   fsgnj.s f14, f10, f27                     ;
_l90:   la x11, d_2_27                            ;
        addi x11, x11, 0                          ;
        amomin.w x23, x3, (x11)                   ;
_l91:   la x29, d_3_25                            ;
        fsw f6, 16(x29)                           ;
_l92:   la x18, d_3_6                             ;
        addi x18, x18, 16                         ;
        amoxor.w x17, x30, (x18)                  ;
_l93:   la x27, d_4_22                            ;
        sb x29, -0(x27)                           ;
_l94:   bltu x4, x19, _l177                               ;
_l95:   mulhsu x26, x6, x14                       ;
_l96:   fmul.s f14, f0, f15, rmm                  ;
_l97:   fdiv.s f31, f30, f0, rmm                  ;
_l98:   srai x30, x14, 0                          ;
_l99:   la x10, _l154                                     ;
        csrrw zero, uepc, x10                     ;
        uret                                      ;
_l100:  fcvt.lu.s x18, f0, rdn                    ;
_l101:  fcvt.lu.s x28, f7, rtz                    ;
_l102:  csrrwi x14, fflags, 19                    ;
_l103:  remuw x28, x23, x3                        ;
_l104:  srli x13, x12, 12                         ;
_l105:  fcvt.s.l f27, x27, rne                    ;
_l106:  bltu x26, x1, _l161                               ;
_l107:  csrrci x5, pmpaddr5, 22                   ;
_l108:  ecall                                     ;
_l109:  la x30, d_5_18                            ;
        lui x26, 0xffe00                          ;
        xor x30, x30, x26                         ;
        lwu x16, 8(x30)                           ;
_l110:  slti x5, x13, -0                          ;
_l111:  fmv.w.x f28, x2                           ;
_l112:  fsgnj.s f9, f24, f21                      ;
_l113:  la x19, d_2_21                            ;
        addi x19, x19, 8                          ;
        amoand.w x26, x8, (x19)                   ;
_l114:  la x13, d_2_19                            ;
        addi x13, x13, 28                         ;
        lr.w x18, (x13)                           ;
_l115:  addi x26, x16, -71                        ;
_l116:  la x1, d_1_10                             ;
        lw x18, -12(x1)                           ;
_l117:  la x25, d_3_13                            ;
        addi x25, x25, 8                          ;
        amoor.d x3, x5, (x25)                     ;
_l118:  la x27, d_3_6                             ;
        fsw f3, -16(x27)                          ;
_l119:  ebreak                                    ;
_l120:  fnmsub.s f8, f16, f5, f7, rup             ;
_l121:  csrrci x1, pmpaddr6, 16                   ;
_l122:  ebreak                                    ;
_l123:  la x16, d_1_7                             ;
        flw f14, -20(x16)                         ;
_l124:  fcvt.s.wu f14, x12, rne                   ;
_l125:  la x23, d_5_20                            ;
        sd x18, -16(x23)                          ;
_l126:  fcvt.lu.s x19, f23, dyn                   ;
_l127:  fmsub.s f18, f11, f4, f16, dyn            ;
_l128:  fsgnjx.s f21, f2, f15                     ;
_l129:  fence.i                                   ;
_l130:  fsgnj.s f20, f3, f24                      ;
_l131:  blt x27, x24, _l134                               ;
_l132:  la x13, d_0_13                            ;
        addi x13, x13, 16                         ;
        amoadd.w x5, x7, (x13)                    ;
_l133:  la x14, d_4_19                            ;
        sb x19, -31(x14)                          ;
_l134:  rem x19, x12, x7                          ;
_l135:  andi x19, x6, -1355                       ;
_l136:  la x21, _l181                                     ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l137:  fmv.x.w x7, f24                           ;
_l138:  la x26, d_2_18                            ;
        addi x26, x26, 0                          ;
        amoand.w x12, x27, (x26)                  ;
_l139:  la x3, d_2_16                             ;
        addi x3, x3, -8                           ;
        amoor.w x18, x4, (x3)                     ;
_l140:  la x13, d_1_9                             ;
        addi x13, x13, 0                          ;
        lr.d x12, (x13)                           ;
_l141:  fsqrt.s f11, f0, dyn                      ;
_l142:  mulw x22, x12, x0                         ;
_l143:  fcvt.s.l f23, x11, rne                    ;
_l144:  jal x26, _l174                                    ;
_l145:  xor x15, x15, x15                         ;
        addi x9, zero, 1                          ;
        slli x9, x9, 3                            ;
        add x15, x15, x9                          ;
        addi x10, zero, 1                         ;
        slli x10, x10, 13                         ;
        add x15, x15, x10                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 22                           ;
        add x15, x15, x2                          ;
        csrrw x26, sepc, x15                      ;
_l146:  andi x7, x15, -12                         ;
_l147:  la x20, d_3_2                             ;
        addi x20, x20, 20                         ;
        amomaxu.w x10, x11, (x20)                 ;
_l148:  la x20, d_1_11                            ;
        addi x20, x20, 28                         ;
        lr.w x21, (x20)                           ;
_l149:  la x8, d_0_15                             ;
        addi x8, x8, 8                            ;
        amomaxu.d x23, x10, (x8)                  ;
_l150:  mulhsu x29, x23, x12                      ;
_l151:  srai x11, x10, 27                         ;
_l152:  la x19, d_3_5                             ;
        lh x2, -2(x19)                            ;
_l153:  la x19, _l196                                     ;
        csrrw zero, sepc, x19                     ;
        sret                                      ;
_l154:  ebreak                                    ;
_l155:  la x27, d_5_16                            ;
        sw x14, -0(x27)                           ;
_l156:  la x5, d_5_15                             ;
        addi x5, x5, 4                            ;
        lui x6, 0xffe00                           ;
        xor x5, x5, x6                            ;
        amoswap.w x6, x6, (x5)                    ;
_l157:  andi x12, x21, 433                        ;
_l158:  csrrsi x8, mtval, 13                      ;
_l159:  la x9, d_1_8                              ;
        addi x9, x9, 8                            ;
        amoxor.d x14, x4, (x9)                    ;
_l160:  la x1, d_2_0                              ;
        addi x1, x1, 8                            ;
        sc.d x29, x1, (x1)                        ;
_l161:  la x8, d_0_22                             ;
        sw x11, 8(x8)                             ;
_l162:  remw x0, x22, x12                         ;
_l163:  feq.s x22, f11, f11                       ;
_l164:  lui x0, 462741                            ;
_l165:  fmax.s f5, f30, f7                        ;
_l166:  bne x5, x21, _l182                                ;
_l167:  la x29, d_2_7                             ;
        addi x29, x29, 0                          ;
        amominu.w x22, x3, (x29)                  ;
_l168:  fle.s x20, f16, f23                       ;
_l169:  remuw x3, x22, x2                         ;
_l170:  fsgnj.s f5, f24, f5                       ;
_l171:  la x27, d_1_10                            ;
        lui x18, 0xffe00                          ;
        xor x27, x27, x18                         ;
        lhu x7, -0(x27)                           ;
_l172:  fsgnjx.s f7, f23, f3                      ;
_l173:  bne x9, x20, _l193                        ;
_l174:  la x2, d_0_7                              ;
        addi x2, x2, -8                           ;
        amomin.d x4, x28, (x2)                    ;
_l175:  subw x27, x7, x30                         ;
_l176:  la x21, d_1_11                            ;
        flw f24, 28(x21)                          ;
_l177:  la x14, d_5_27                            ;
        sb x12, 24(x14)                           ;
_l178:  slti x17, x26, -2047                      ;
_l179:  csrrsi x19, fcsr, 31                      ;
_l180:  la x1, _l198                                      ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l181:  la x5, d_0_1                              ;
        addi x5, x5, -0                           ;
        amoadd.d x4, x11, (x5)                    ;
_l182:  la x16, d_5_7                             ;
        addi x16, x16, -0                         ;
        amoswap.w x9, x6, (x16)                   ;
_l183:  la x26, _l185                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l184:  div x26, x26, x14                         ;
_l185:  ecall                                     ;
_l186:  remuw x11, x26, x12                       ;
_l187:  fmv.w.x f30, x26                          ;
_l188:  divw x30, x3, x3                          ;
_l189:  ebreak                                    ;
_l190:  la x10, _l105                                     ;
        lw x13, -4(x10)                           ;
_l191:  la x30, d_3_11                            ;
        lh x11, 0(x30)                            ;
_l192:  addiw x1, x20, 1417                       ;
_l193:  beq x4, x14, _l198                                ;
_l194:  remuw x2, x6, x7                          ;
_l195:  slli x21, x30, 0                          ;
_l196:  divw x13, x0, x13                         ;
_l197:  fcvt.l.s x0, f16, rdn                     ;
_l198:  csrrwi x24, pmpaddr7, 11                  ;
_l199:  la x11, _l200                                     ;
        csrrw zero, uepc, x11                     ;
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
                .dword 0x0d0773997ce3acef, 0x8f720252a14e450d
                .dword 0xc632a8dd9a9b8d79, 0xa0a87f8dc752d5c2
d_0_0:          .dword 0x01a80c46a198ffac, 0xb2b3cfd5566acd89
d_0_1:          .dword 0x45d7260ae4944393, 0x55bee4c78f6b3527
d_0_2:          .dword 0xff8701d0658f25dc, 0x2e0ef577a7fcb89b
d_0_3:          .dword 0xa689fb2dbe67c860, 0x2a5b928666c7f234
d_0_4:          .dword 0x42e758dd87ae81df, 0xd65b7ebbf012323d
d_0_5:          .dword 0xc55b5ec7e4fc59ef, 0x2190edf8bd3f71ef
d_0_6:          .dword 0x5039c24822e94f9d, 0x97a5684a38b389a6
d_0_7:          .dword 0x3f166dd47564f96e, 0x957d223e3c0f8850
d_0_8:          .dword 0x230ed25fde78ce25, 0x0e0d86998b23aa6d
d_0_9:          .dword 0xc182d954052e8193, 0x9a92b09e8c8f3241
d_0_10:         .dword 0x0c6e7e82948129d1, 0x14b05c13fc0938b5
d_0_11:         .dword 0x89d4512b521f7787, 0x655686e4e9ca6571
d_0_12:         .dword 0xd00ac2154a11793b, 0xd17b00dd99bfc985
d_0_13:         .dword 0x08f418376597b67c, 0x1cf5bba174ba3d0c
d_0_14:         .dword 0x1edc5932328c57b0, 0xa7acd82efcaa0003
d_0_15:         .dword 0xc75943366b880a1b, 0x7bb9bd6385768e29
d_0_16:         .dword 0xa62bdcae71242b59, 0x868b02165d87de85
d_0_17:         .dword 0x3eaff74203b1db7c, 0x8861f9743caecf4d
d_0_18:         .dword 0xfa4e4ae1a8dbbada, 0xdf838bc77b0b1b5f
d_0_19:         .dword 0xf89d20204c305561, 0xa89b40e9d0dba14f
d_0_20:         .dword 0xe4b8dd6a0ed6affd, 0xbbdeeee2c8f52cb4
d_0_21:         .dword 0xf406d9707594230a, 0xf541a2f10b223ff2
d_0_22:         .dword 0x642c2409dec22bec, 0xd6f0d67091a4e682
d_0_23:         .dword 0x91fe3727df8b159f, 0x468b1357a3273361
d_0_24:         .dword 0x0ad6203593285165, 0x8d6785499283d6e9
d_0_25:         .dword 0xb9efcd3634990f5a, 0x58d118c718f32072
d_0_26:         .dword 0x37881d227579c3d7, 0x0880c01773555e7e
d_0_27:         .dword 0xce0cbac3f66081f3, 0x95f9be940c277aaa
                .dword 0x092ecbbf5dd9808c, 0x1156e678102e08ec
                .dword 0x9ebb48bf60e1f0b6, 0xe9e226cb18d37717
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8896eb31963f26aa, 0x18aca4ca9a0ff067
                .dword 0x37ea31ace4c247b7, 0xb25e9d34ee49e5e7
d_1_0:          .dword 0xaf51cff17fa483ae, 0xb04d2a0196e73a04
d_1_1:          .dword 0x4ea8ab10510e34b4, 0x36bb5ac7b08e2d07
d_1_2:          .dword 0x9570c1d8b6581d5e, 0x9862d63d9631ad02
d_1_3:          .dword 0xefd60a676b430367, 0x3a63be5372ada425
d_1_4:          .dword 0x0a60bd5393c61b03, 0xcf67c1da1d10a5a6
d_1_5:          .dword 0xe6ea72c0597932e9, 0x29ccaee8366257d6
d_1_6:          .dword 0x4705e4c0f80687ff, 0x58867cab8649d43d
d_1_7:          .dword 0x8dce382fb354e303, 0x8f0b5b5835ec7b3c
d_1_8:          .dword 0xfa836e45da91ec5d, 0xfe66672d8ae67542
d_1_9:          .dword 0x57d76328eb597b26, 0x1d0424eb04ae1543
d_1_10:         .dword 0x25ed323497a1946e, 0x138c12387b034894
d_1_11:         .dword 0xd49de6e6e5610499, 0xd62fb96cad9a6391
d_1_12:         .dword 0xe8c975a032761ef1, 0x5a32bae042885002
d_1_13:         .dword 0xe99db13c158f2da2, 0xbcadc96af9b1c827
d_1_14:         .dword 0xac02c84cd2d8b79a, 0xef7d384adb19b8f0
d_1_15:         .dword 0x51366274cdfdea3a, 0x9cb8fc90b7e088a3
d_1_16:         .dword 0xf733a8f15d67d1c2, 0x8153e65bda98be09
d_1_17:         .dword 0xeff9f42a2f61de80, 0xc15888ebf9d322ef
d_1_18:         .dword 0xd9dd7e39dd21f8e9, 0x65052f302336da6b
d_1_19:         .dword 0x18f65ad9fd4319ab, 0x48b90aa52b5ce6ce
d_1_20:         .dword 0xd851b4a3ab56cea4, 0x4e53d1e00ecbbc25
d_1_21:         .dword 0x150444b784764941, 0x57bc709f7de3b6a1
d_1_22:         .dword 0x8e84d6df0a0b0cce, 0x8f42916d62e1455b
d_1_23:         .dword 0xc2a47567b428489e, 0x52827c09ebbca5dd
d_1_24:         .dword 0xbc31f83a9551a908, 0x4e6e520b561d4923
d_1_25:         .dword 0x5f22b378915e164d, 0xe59f64264b094151
d_1_26:         .dword 0x0445999cdc9920e5, 0x2eb97a20151018c2
d_1_27:         .dword 0x93c189711e4b34ac, 0xe71f28dca1e27284
                .dword 0xd5d48539c2e27a12, 0xa3e59ac6bc08b7ef
                .dword 0x538ef859c8731b9f, 0x4786f24a26ee66f9
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xac3d94533b6f276c, 0x33f6c92cff5144a1
                .dword 0x132046f6dd34e1a7, 0xf241053155c70437
d_2_0:          .dword 0x227404b1cf894768, 0x9fc758382bba9b4f
d_2_1:          .dword 0x1276b0f67cd1fb33, 0x9a2444c548fccc3a
d_2_2:          .dword 0x9890f8588c3ac72c, 0xa85c2edf0528db52
d_2_3:          .dword 0x01418a4a5268bc6d, 0x5ad5f7f18faa6840
d_2_4:          .dword 0x782d4da024af93ca, 0x553ca071e91b161d
d_2_5:          .dword 0xb5c6706d2198da59, 0x372cdad61cb072ec
d_2_6:          .dword 0x0c0800b90d16123b, 0xa4039ae9c95a522d
d_2_7:          .dword 0x3c5c5461e6f01cfa, 0x916f847a12197bbb
d_2_8:          .dword 0xddc815b3e908eb50, 0x355c70991e9ff363
d_2_9:          .dword 0x64ab20b73a763fb4, 0x478aafda69dd19b0
d_2_10:         .dword 0x32a508d2ffd3afb3, 0x301dc367d05c4cbc
d_2_11:         .dword 0xc60070014934f9aa, 0xcc6e525af7564d5e
d_2_12:         .dword 0x5023638752ec1bb2, 0x9ac5d09511d092f4
d_2_13:         .dword 0xaee65bd4b40127d4, 0x78adf63c788779c7
d_2_14:         .dword 0xb19bd9f95742f38b, 0xfb807de87b1cdfa8
d_2_15:         .dword 0x87eb2f338848744d, 0xcede19262d706b77
d_2_16:         .dword 0xcb8f793b360a67a3, 0xb619e5da0e7af958
d_2_17:         .dword 0x1ea7be5315d6e221, 0x1fdabfb3c9b09f0b
d_2_18:         .dword 0x67c0a32afdb316f0, 0x8761d59873a5aab8
d_2_19:         .dword 0x2917a1b07dd07c39, 0xa60032054d3337a9
d_2_20:         .dword 0x1596c957399ad5ca, 0x285a0e5134f1bfa4
d_2_21:         .dword 0x0e1726e568784383, 0xc5b53033e48d0870
d_2_22:         .dword 0x7e4fd2987042791f, 0xc91068c5156b0bef
d_2_23:         .dword 0xba72e12d17ac8ee1, 0x154ce60fc37a1ba2
d_2_24:         .dword 0x94c8df045d3da8f3, 0xe59b9240bf7443ef
d_2_25:         .dword 0xb9ac80c5c867fd7e, 0x764148c4da50001a
d_2_26:         .dword 0xc28364fc259ce1ae, 0xd509ece086193022
d_2_27:         .dword 0x068ccb0ce37e43c3, 0x20f9c84f659d9d38
                .dword 0x3b826c59e49bdb9d, 0xbbda7df29c326196
                .dword 0xdd0500498a4951a9, 0x6a0cbc0839084ee2
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x6747657de43dfb4a, 0x8ef2db0c6eb48272
                .dword 0xa0257cb608dfedd8, 0x65716c34b1824e2a
d_3_0:          .dword 0xe7ab75d56b5ec288, 0xb4938a8afe01e1a1
d_3_1:          .dword 0x495c8b6c05cf4cfa, 0x68113cd7eba57b5b
d_3_2:          .dword 0x4a40997d3e4137ff, 0x71e5e5750684af51
d_3_3:          .dword 0xb1b51fd2cd80a051, 0x6475f2123c2f63fe
d_3_4:          .dword 0x10a3c610cf242299, 0x8195d7ee5f07719b
d_3_5:          .dword 0xdd70b0bc1c55abcf, 0x90e6c94471bb72cd
d_3_6:          .dword 0x419a66a8696cd987, 0xbc6a7a261b60f88d
d_3_7:          .dword 0x6b2f6368fd0d88dd, 0xf63cdc9bd91e3860
d_3_8:          .dword 0xe13199688e224128, 0x40c5afe1a8a47dde
d_3_9:          .dword 0xf4650fdcb708e93d, 0x6bc96dd01b118382
d_3_10:         .dword 0x1716a92976d63f1f, 0x0c2ac7369abd3b01
d_3_11:         .dword 0x8706f165344b4cf3, 0x3c2ba7ca07e6f463
d_3_12:         .dword 0x4d9d822d14124cb8, 0xaa22c61b02261e08
d_3_13:         .dword 0xab8cdcc2e511b035, 0x854a15de7305eba3
d_3_14:         .dword 0x65c54b3c46ca997b, 0x2e38ba67d09135ff
d_3_15:         .dword 0x50cce7745a4eb284, 0x0a7bb57725d43d12
d_3_16:         .dword 0xfceb7613164244b6, 0xfbb07a8e47cbf2e0
d_3_17:         .dword 0x7d46a5c2e5c02a25, 0x6ba7858381418463
d_3_18:         .dword 0x42ce89c6f3fc972b, 0x5295bce024b2407e
d_3_19:         .dword 0x3bbdd590e26e8931, 0x67e05a7bcab578b2
d_3_20:         .dword 0xb22464e220875090, 0x2b249a643dc86890
d_3_21:         .dword 0x131ed5c78d4c4db5, 0x08f8a2bd0b24a08f
d_3_22:         .dword 0xc21869130839fc30, 0xbcaebf9502db6d52
d_3_23:         .dword 0xa60c8c99ef184121, 0x53dc22807cb07c26
d_3_24:         .dword 0xac46dc92690a8926, 0x0874624165bffe40
d_3_25:         .dword 0x7f6cdf1befcc54c1, 0xf5cf210af17c1df3
d_3_26:         .dword 0x59460d16e8f217a0, 0xebce5b8b185e9369
d_3_27:         .dword 0xe2418d09dc538afe, 0xc389bbfdc09d9d45
                .dword 0xf836d25ea57ccc8c, 0xe199b9756a7c4eb1
                .dword 0x9970d9b9ab3bf431, 0x0e3996a6f941302e
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xff45c147aeacbf1a, 0xc642e2406f4dbf7d
                .dword 0x0cc26ebcd4715279, 0x98f9001a94b53981
d_4_0:          .dword 0x24865a5a24875831, 0x6c5a3a845f8ada88
d_4_1:          .dword 0x70da5c8df8267014, 0x6a60dcb0a5e93393
d_4_2:          .dword 0x0fc8e7d112d7dfae, 0x57a514643ad662ba
d_4_3:          .dword 0x742c0258fbf34a4c, 0x2cf5ac30c06e7db3
d_4_4:          .dword 0xa77fd9d663bb9f86, 0xb84bdb72fc2fa765
d_4_5:          .dword 0xb77b6f70750e60e9, 0x364e813c6e00cf9c
d_4_6:          .dword 0x5e1dfa46755a6d03, 0x7dc011bf9dcc7400
d_4_7:          .dword 0x05de8c2cc273a2a2, 0x4a3ee7e63ea20bcc
d_4_8:          .dword 0x3640e59548a0e945, 0xdcce73c5ad70910c
d_4_9:          .dword 0x705d7e91169ede15, 0x998c84ee492b8035
d_4_10:         .dword 0xb6a1e3b3b84b717b, 0x2b38f3ffee9267dc
d_4_11:         .dword 0x8ed6bc8f0b7f6565, 0xceb72cc03d54b618
d_4_12:         .dword 0xe2e393402f89998d, 0xb36ad6df4f887fee
d_4_13:         .dword 0xa73ef3fc12825451, 0x6ff27f4565755a70
d_4_14:         .dword 0xd0af5113f8212a46, 0x302bf78e43b1bf3b
d_4_15:         .dword 0x9aafdb6ca39afd32, 0x2e6e38fb94f73b6c
d_4_16:         .dword 0xc769d65c12792204, 0x30baa994a4e2fb67
d_4_17:         .dword 0x4bc96a12acff81d3, 0xb5a860fc0582fcb0
d_4_18:         .dword 0xff93a79fb7f33813, 0x6b8070bed79d7a92
d_4_19:         .dword 0x94bcc641072cc0a6, 0x74baa61c5987b368
d_4_20:         .dword 0xa8590018733f18fd, 0xc77e4401ffa0f8a4
d_4_21:         .dword 0xd4724371fa9e5259, 0x21bf49f1274df60c
d_4_22:         .dword 0x6a539476947183c3, 0xfed00c62956f69e7
d_4_23:         .dword 0x9e83600a43946623, 0xb9e4019588c751b1
d_4_24:         .dword 0x873f8fabbde8260d, 0x4136f48d5c29cc32
d_4_25:         .dword 0xa1e008b67b620027, 0x367e0465e8a223d6
d_4_26:         .dword 0xd145c04b37e0bfee, 0x0aa6f094e514dc74
d_4_27:         .dword 0xffa55dcc1c59bb85, 0xe86671de135c03a7
                .dword 0x206b585632da1f58, 0x7a2bbc9087ec29c8
                .dword 0xf63b84e5e5713921, 0x46fefca0135d8b1a
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xc4eb9ff6e1b7e2b6, 0xba2aa24e4f7d27cc
                .dword 0xf8c41e416800d172, 0xdf29b72c58cc1137
d_5_0:          .dword 0x64bf290fc3f1fa7c, 0xbb975114d6ac8ea0
d_5_1:          .dword 0x32e57c128560fee4, 0x351b3f278a2c4374
d_5_2:          .dword 0xb2e10042695b3cc9, 0xb2f14b95e19e5ffd
d_5_3:          .dword 0xd9f05f454f9da1fd, 0x4db58f517b393a90
d_5_4:          .dword 0xc1766292c25e65c6, 0xefc937c158a13ad5
d_5_5:          .dword 0x0796ac80dffbe58b, 0xf715e84a2493d910
d_5_6:          .dword 0x66475ab7f62c2d76, 0x01b47d50739819ce
d_5_7:          .dword 0xe15ba1e03039bde8, 0x050cccadd8ca924c
d_5_8:          .dword 0x376c742eebddbe41, 0x25aef3afa9f1557f
d_5_9:          .dword 0x4cb72088eeed2498, 0x6b45d99fafe9a7f5
d_5_10:         .dword 0x16c768722ce6151a, 0x1f80594fa8f3d76e
d_5_11:         .dword 0xe524c26f0cc19f04, 0x322c4809227108ef
d_5_12:         .dword 0xba83ac181b07ea59, 0xb2eebe84b1fc481a
d_5_13:         .dword 0x8f69f7a4fe361cbe, 0xe5c1e5589aa7b157
d_5_14:         .dword 0x43fecb8f94c0f0b4, 0x920c8851c28f2e7a
d_5_15:         .dword 0x6aa6a7ec422e1976, 0x94c9c188799ce575
d_5_16:         .dword 0x0c724c67b78d1784, 0xb93f373f895c78ea
d_5_17:         .dword 0xc6a5838f177cbea8, 0x5724f18866fbf824
d_5_18:         .dword 0xbf57dd649a95ceef, 0xdd2cb79ec074e00a
d_5_19:         .dword 0x4c6ee77880094042, 0xf913c8526679015a
d_5_20:         .dword 0xa614dd3cd998218a, 0xd2f5226270a08e06
d_5_21:         .dword 0x81b921a69c144916, 0xb0719acaf81b93b7
d_5_22:         .dword 0xcd8421c04897f2a6, 0xb2877e51980c7b4e
d_5_23:         .dword 0xdce6911e6829355d, 0x559581dcd75a5e54
d_5_24:         .dword 0x660be19e8ffd18aa, 0x2fc8bc611fedc7bc
d_5_25:         .dword 0x872acc27261ac82f, 0x0825e1a4b6fa1960
d_5_26:         .dword 0x0876a9fcaeb33285, 0xaba70c79936b086b
d_5_27:         .dword 0x847e36d49ff48ae2, 0x0b5b6e7db45d4d75
                .dword 0xc70f6c04c54b1e33, 0xb6ceca8cc27d950e
                .dword 0x1918c9824e80849f, 0xf2869a1c53c1c5d9
         /* Random data */
_end_data5:
              
 
