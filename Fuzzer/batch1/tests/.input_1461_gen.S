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
_p0:    csrrci x12, pmpaddr7, 29                  ;
_p1:    csrrci x13, pmpaddr5, 7                   ;
_p2:    csrrwi x13, sscratch, 0                   ;
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
_s0:    flt.s x23, f8, f29                        ;
_s1:    srli x13, x23, 18                         ;
_s2:    fcvt.wu.s x18, f14, rmm                   ;
_s3:    la x23, d_1_24                            ;
        sd x25, 8(x23)                            ;
_s4:    fence                                     ;
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
_l0:    fcvt.s.l f13, x4, rdn                     ;
_l1:    addw x9, x2, x24                          ;
_l2:    la x4, _l7                                ;
        lwu x24, 28(x4)                           ;
_l3:    mulhu x25, x21, x19                       ;
_l4:    la x21, d_0_8                             ;
        addi x21, x21, -24                        ;
        amoadd.w x16, x2, (x21)                   ;
_l5:    la x13, d_1_11                            ;
        sb x16, -25(x13)                          ;
_l6:    div x13, x10, x16                         ;
_l7:    fsub.s f13, f11, f11, rdn                 ;
_l8:    fcvt.s.lu f9, x29, rtz                    ;
_l9:    fcvt.wu.s x24, f12, rdn                   ;
_l10:   flt.s x3, f30, f9                         ;
_l11:   la x8, d_3_2                              ;
        sd x19, 24(x8)                            ;
_l12:   la x18, d_5_23                            ;
        addi x18, x18, 4                          ;
        amominu.w x9, x16, (x18)                  ;
_l13:   divuw x3, x8, x29                         ;
_l14:   bge x29, x2, _l59                         ;
_l15:   blt x8, x16, _l48                         ;
_l16:   la x4, d_0_23                             ;
        addi x4, x4, 24                           ;
        amomax.d x22, x8, (x4)                    ;
_l17:   sraw x9, x28, x3                          ;
_l18:   la x11, d_2_27                            ;
        addi x11, x11, -24                        ;
        amomin.d x30, x26, (x11)                  ;
_l19:   la x30, d_1_12                            ;
        addi x30, x30, -12                        ;
        amoswap.w x4, x10, (x30)                  ;
_l20:   la x20, d_1_16                            ;
        addi x20, x20, 4                          ;
        amomaxu.w x24, x2, (x20)                  ;
_l21:   srliw x30, x5, 7                          ;
_l22:   fmsub.s f16, f28, f14, f14, dyn           ;
_l23:   fsqrt.s f8, f13, rdn                      ;
_l24:   bgeu x2, x15, _l183                       ;
_l25:   remuw x8, x11, x10                        ;
_l26:   addiw x19, x0, 29                         ;
_l27:   la x14, d_3_15                            ;
        lwu x3, 0(x14)                            ;
_l28:   slliw x14, x27, 24                        ;
_l29:   fsgnjx.s f16, f19, f21                    ;
_l30:   la x2, d_3_2                              ;
        addi x2, x2, 0                            ;
        amomin.d x13, x3, (x2)                    ;
_l31:   ebreak                                    ;
_l32:   la x11, _l128                             ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l33:   fmv.w.x f21, x25                          ;
_l34:   la x7, d_3_0                              ;
        addi x7, x7, 8                            ;
        amoswap.w x30, x21, (x7)                  ;
_l35:   ori x18, x18, 326                         ;
_l36:   la x13, d_3_12                            ;
        fsw f20, -0(x13)                          ;
_l37:   fsqrt.s f8, f20, rne                      ;
_l38:   la x16, d_2_25                            ;
        sd x15, 24(x16)                           ;
_l39:   subw x23, x5, x6                          ;
_l40:   fmv.w.x f0, x17                           ;
_l41:   fnmsub.s f11, f16, f20, f21, dyn          ;
_l42:   la x13, d_1_25                            ;
        addi x13, x13, -24                        ;
        amominu.d x22, x29, (x13)                 ;
_l43:   remu x29, x29, x5                         ;
_l44:   la x16, _l181                             ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l45:   mulw x21, x22, x30                        ;
_l46:   bltu x5, x20, _l134                       ;
_l47:   addiw x6, x5, 2016                        ;
_l48:   div x8, x13, x28                          ;
_l49:   la x25, d_3_5                             ;
        ld x11, -0(x25)                           ;
_l50:   fmul.s f19, f24, f30, dyn                 ;
_l51:   mulh x11, x22, x10                        ;
_l52:   la x23, d_5_21                            ;
        addi x23, x23, -4                         ;
        amoand.w x21, x3, (x23)                   ;
_l53:   sllw x3, x28, x15                         ;
_l54:   lui x20, 14                               ;
_l55:   la x23, _l23                              ;
        lh x9, -10(x23)                           ;
_l56:   la x2, d_1_10                             ;
        addi x2, x2, -20                          ;
        amomin.w x14, x18, (x2)                   ;
_l57:   srli x4, x17, 0                           ;
_l58:   la x10, d_5_27                            ;
        addi x10, x10, -8                         ;
        amominu.w x14, x24, (x10)                 ;
_l59:   la x26, d_2_3                             ;
        addi x26, x26, 20                         ;
        amoxor.w x10, x24, (x26)                  ;
_l60:   fadd.s f26, f24, f19, rup                 ;
_l61:   remw x16, x22, x14                        ;
_l62:   fcvt.wu.s x16, f14, rup                   ;
_l63:   la x12, d_5_19                            ;
        addi x12, x12, 16                         ;
        lui x26, 0xffe00                          ;
        xor x12, x12, x26                         ;
        amomin.d x9, x26, (x12)                   ;
_l64:   fsgnj.s f26, f12, f17                     ;
_l65:   la x27, d_3_14                            ;
        sh x17, -20(x27)                          ;
_l66:   fadd.s f15, f22, f14, rtz                 ;
_l67:   beq x22, x13, _l163                       ;
_l68:   la x23, d_1_15                            ;
        lui x22, 0xffe00                          ;
        xor x23, x23, x22                         ;
        flw f19, 4(x23)                           ;
_l69:   la x29, d_1_21                            ;
        addi x29, x29, -0                         ;
        amomin.d x24, x25, (x29)                  ;
_l70:   la x23, d_5_18                            ;
        addi x23, x23, -20                        ;
        lr.w x24, (x23)                           ;
_l71:   la x26, d_3_1                             ;
        addi x26, x26, -20                        ;
        lui x28, 0xffe00                          ;
        xor x26, x26, x28                         ;
        amoswap.w x21, x28, (x26)                 ;
_l72:   la x29, d_5_23                            ;
        sd x27, -16(x29)                          ;
_l73:   la x14, _l74                              ;
        csrrw zero, uepc, x14                     ;
        uret                                      ;
_l74:   la x6, d_4_1                              ;
        lhu x30, -2(x6)                           ;
_l75:   addw x27, x30, x10                        ;
_l76:   fmax.s f6, f4, f0                         ;
_l77:   div x10, x19, x12                         ;
_l78:   bne x27, x1, _l156                        ;
_l79:   la x21, d_0_14                            ;
        addi x21, x21, 8                          ;
        amomax.d x13, x6, (x21)                   ;
_l80:   la x14, d_1_27                            ;
        addi x14, x14, 8                          ;
        amoxor.d x22, x6, (x14)                   ;
_l81:   la x25, d_3_9                             ;
        addi x25, x25, 24                         ;
        amomin.w x5, x17, (x25)                   ;
_l82:   sraw x13, x22, x19                        ;
_l83:   addi x9, x10, 1024                        ;
_l84:   la x7, d_5_22                             ;
        addi x7, x7, 0                            ;
        amoswap.w x28, x9, (x7)                   ;
_l85:   fcvt.wu.s x11, f9, rdn                    ;
_l86:   addiw x1, x7, 776                         ;
_l87:   la x19, d_3_23                            ;
        addi x19, x19, -20                        ;
        amoor.w x23, x1, (x19)                    ;
_l88:   la x26, d_1_26                            ;
        addi x26, x26, -0                         ;
        amomaxu.w x5, x28, (x26)                  ;
_l89:   mul x24, x3, x27                          ;
_l90:   srlw x17, x15, x3                         ;
_l91:   csrrsi x7, pmpaddr0, 26                   ;
_l92:   beq x29, x4, _l181                        ;
_l93:   la x25, d_2_13                            ;
        sb x30, -31(x25)                          ;
_l94:   ori x9, x28, -1657                        ;
_l95:   la x8, d_5_26                             ;
        sh x1, -16(x8)                            ;
_l96:   sraw x13, x6, x21                         ;
_l97:   la x14, d_0_19                            ;
        addi x14, x14, 0                          ;
        lr.d x27, (x14)                           ;
_l98:   feq.s x27, f15, f11                       ;
_l99:   slliw x16, x12, 30                        ;
_l100:  subw x28, x12, x23                        ;
_l101:  mulw x21, x24, x16                        ;
_l102:  fsgnj.s f19, f22, f0                      ;
_l103:  fmin.s f10, f22, f20                      ;
_l104:  la x23, d_1_0                             ;
        addi x23, x23, 0                          ;
        amominu.d x6, x17, (x23)                  ;
_l105:  la x11, d_4_0                             ;
        lbu x4, 27(x11)                           ;
_l106:  la x24, d_2_25                            ;
        lw x21, -4(x24)                           ;
_l107:  la x26, d_4_13                            ;
        lbu x16, -28(x26)                         ;
_l108:  blt x13, x7, _l127                        ;
_l109:  la x8, d_1_19                             ;
        lwu x15, 20(x8)                           ;
_l110:  la x21, d_2_27                            ;
        addi x21, x21, 16                         ;
        amoadd.d x22, x24, (x21)                  ;
_l111:  fnmsub.s f26, f3, f1, f8, rmm             ;
_l112:  la x25, d_4_2                             ;
        addi x25, x25, 0                          ;
        lui x13, 0xffe00                          ;
        xor x25, x25, x13                         ;
        amomax.w x13, x13, (x25)                  ;
_l113:  remw x0, x7, x19                          ;
_l114:  la x22, d_3_25                            ;
        sw x16, 16(x22)                           ;
_l115:  la x27, d_0_0                             ;
        addi x27, x27, -8                         ;
        amomaxu.d x27, x8, (x27)                  ;
_l116:  la x15, d_3_15                            ;
        lhu x20, 30(x15)                          ;
_l117:  auipc x18, 1048575                        ;
_l118:  fmax.s f27, f24, f13                      ;
_l119:  la x4, d_5_1                              ;
        addi x4, x4, 0                            ;
        amoadd.w x7, x23, (x4)                    ;
_l120:  fcvt.s.w f17, x9, rup                     ;
_l121:  sllw x6, x25, x26                         ;
_l122:  fcvt.s.l f30, x24, rup                    ;
_l123:  fdiv.s f6, f11, f24, rdn                  ;
_l124:  mulhsu x1, x15, x5                        ;
_l125:  slti x14, x15, -1756                      ;
_l126:  fmsub.s f3, f15, f16, f0, rne             ;
_l127:  la x24, d_0_22                            ;
        addi x24, x24, -28                        ;
        amoand.w x24, x29, (x24)                  ;
_l128:  la x11, d_5_13                            ;
        addi x11, x11, -24                        ;
        lui x2, 0xffe00                           ;
        xor x11, x11, x2                          ;
        sc.w x28, x2, (x11)                       ;
_l129:  la x17, d_3_19                            ;
        addi x17, x17, -28                        ;
        lr.w x18, (x17)                           ;
_l130:  la x21, _l187                             ;
        csrrw zero, uepc, x21                     ;
        uret                                      ;
_l131:  mul x1, x23, x4                           ;
_l132:  fence                                     ;
_l133:  fcvt.s.l f6, x2, rmm                      ;
_l134:  fcvt.s.w f15, x25, rmm                    ;
_l135:  mulw x21, x17, x15                        ;
_l136:  la x11, d_4_17                            ;
        addi x11, x11, -0                         ;
        amominu.w x18, x4, (x11)                  ;
_l137:  fsqrt.s f18, f8, rup                      ;
_l138:  la x29, d_2_4                             ;
        flw f22, 16(x29)                          ;
_l139:  la x23, d_4_27                            ;
        addi x23, x23, 24                         ;
        amomin.w x25, x8, (x23)                   ;
_l140:  fcvt.wu.s x29, f13, dyn                   ;
_l141:  slti x3, x28, -1002                       ;
_l142:  la x21, d_5_19                            ;
        lwu x8, 28(x21)                           ;
_l143:  la x26, d_3_23                            ;
        addi x26, x26, 20                         ;
        amoand.w x7, x7, (x26)                    ;
_l144:  fsqrt.s f20, f3, rup                      ;
_l145:  fence                                     ;
_l146:  la x1, d_2_11                             ;
        addi x1, x1, -0                           ;
        amoswap.w x8, x24, (x1)                   ;
_l147:  divw x25, x20, x25                        ;
_l148:  remw x5, x19, x10                         ;
_l149:  la x10, d_2_20                            ;
        lui x12, 0xffe00                          ;
        xor x10, x10, x12                         ;
        fsw f5, 16(x10)                           ;
_l150:  la x11, d_5_6                             ;
        addi x11, x11, 16                         ;
        amoswap.d x18, x18, (x11)                 ;
_l151:  fmsub.s f20, f14, f4, f30, rmm            ;
_l152:  divuw x1, x23, x2                         ;
_l153:  la x14, _l157                             ;
        jalr x28, 0(x14)                          ;
_l154:  la x19, d_4_15                            ;
        sd x16, -8(x19)                           ;
_l155:  xor x17, x17, x17                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 31                         ;
        add x17, x17, x14                         ;
        csrrs x30, mip, x17                       ;
_l156:  la x10, d_5_15                            ;
        sb x11, 10(x10)                           ;
_l157:  sraw x5, x17, x4                          ;
_l158:  la x26, _l178                             ;
        csrrw zero, mepc, x26                     ;
        mret                                      ;
_l159:  subw x21, x10, x14                        ;
_l160:  slti x8, x30, -1024                       ;
_l161:  xor x14, x14, x14                         ;
        csrrs x17, sscratch, x14                  ;
_l162:  la x10, d_5_23                            ;
        addi x10, x10, 16                         ;
        amoor.w x2, x29, (x10)                    ;
_l163:  ebreak                                    ;
_l164:  fclass.s x24, f23                         ;
_l165:  la x24, _l173                             ;
        jalr x2, 0(x24)                           ;
_l166:  srli x19, x13, 16                         ;
_l167:  fcvt.s.l f13, x29, rdn                    ;
_l168:  fence                                     ;
_l169:  srliw x9, x22, 27                         ;
_l170:  addi x27, x7, 116                         ;
_l171:  fle.s x21, f25, f0                        ;
_l172:  la x28, d_4_22                            ;
        addi x28, x28, 24                         ;
        amominu.d x20, x16, (x28)                 ;
_l173:  la x1, d_4_13                             ;
        addi x1, x1, 16                           ;
        amominu.d x9, x13, (x1)                   ;
_l174:  la x7, d_2_6                              ;
        addi x7, x7, 24                           ;
        amoadd.w x26, x21, (x7)                   ;
_l175:  la x29, _l196                             ;
        csrrw zero, sepc, x29                     ;
        sret                                      ;
_l176:  la x27, _l81                              ;
        lw x7, 28(x27)                            ;
_l177:  ecall                                     ;
_l178:  la x13, d_4_19                            ;
        sb x6, -19(x13)                           ;
_l179:  flt.s x13, f15, f18                       ;
_l180:  andi x22, x17, -0                         ;
_l181:  fsgnj.s f14, f30, f11                     ;
_l182:  csrrsi x24, pmpcfg0, 0                    ;
_l183:  la x22, d_5_6                             ;
        addi x22, x22, 8                          ;
        amoswap.d x1, x20, (x22)                  ;
_l184:  fclass.s x18, f19                         ;
_l185:  xor x11, x11, x11                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 31                         ;
        add x11, x11, x19                         ;
        csrrw x10, mie, x11                       ;
_l186:  blt x12, x1, _l193                        ;
_l187:  div x16, x1, x21                          ;
_l188:  la x8, d_5_1                              ;
        addi x8, x8, 0                            ;
        amoswap.d x30, x24, (x8)                  ;
_l189:  remw x23, x25, x10                        ;
_l190:  la x19, d_4_13                            ;
        addi x19, x19, -28                        ;
        sc.w x6, x13, (x19)                       ;
_l191:  mul x1, x6, x1                            ;
_l192:  fmax.s f28, f11, f28                      ;
_l193:  fence.i                                   ;
_l194:  li x30, 0                                 ;
        la x30, pt2                               ;
        addi x30, x30, 56                         ;
        sfence.vma x30, x30                       ;
_l195:  csrrwi x18, pmpaddr3, 6                   ;
_l196:  la x12, d_5_1                             ;
        addi x12, x12, 0                          ;
        amomin.w x4, x7, (x12)                    ;
_l197:  fsgnj.s f29, f26, f14                     ;
_l198:  fmax.s f0, f17, f23                       ;
_l199:  la x2, d_5_17                             ;
        sw x4, -24(x2)                            ;
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
                .dword 0x6526ed424d1b9d96, 0x92511869f197c0f1
                .dword 0x84160b62d20fd9e0, 0x9938e7c6887787fd
d_0_0:          .dword 0x3e82610fbe0789d5, 0x5761f974f38e07eb
d_0_1:          .dword 0xe2d0ed342f38bfc8, 0x81fe95958347a640
d_0_2:          .dword 0x1004d004a1eb2ab0, 0xe67e3ba690f02669
d_0_3:          .dword 0x9baaed7e58a5a799, 0x9b54ce2a8df9310b
d_0_4:          .dword 0xab360702d5cea126, 0x150b91e933f1b082
d_0_5:          .dword 0x3c0e6fd4e85434e8, 0xca8a716407aa31b3
d_0_6:          .dword 0xe2ba7a6a5145c45e, 0xc239574d3684effc
d_0_7:          .dword 0x63700ad23673af6e, 0xec3b8864e5d3179c
d_0_8:          .dword 0xff6f96af4d476f7b, 0x5b33253480fd473d
d_0_9:          .dword 0x989c4434b3894e3c, 0x7a172c906a4166a3
d_0_10:         .dword 0xd764f5f1b959f765, 0xce5c09e7e67473bd
d_0_11:         .dword 0x7c1d9cc35b3e97ce, 0xda3768fe543268a6
d_0_12:         .dword 0xde0616f75618d251, 0xa71a278d70f62f67
d_0_13:         .dword 0x443505fef2c44d2e, 0x07d010fe09bfe751
d_0_14:         .dword 0xf672af7e0101d80b, 0x38d46ed92ba46413
d_0_15:         .dword 0x5ff63369a12aebf8, 0xcf727491eeee0fa9
d_0_16:         .dword 0x626509b9e93441a7, 0xd71ced0645dd3e04
d_0_17:         .dword 0xec0b41ae2f7ab8f6, 0x1c73a5125d1ad3ba
d_0_18:         .dword 0x13da77fb285f2469, 0x88ecd1747847ac59
d_0_19:         .dword 0x7cbe7320cfa3dbaf, 0xff4080e93870c829
d_0_20:         .dword 0x02e897bc64cea521, 0x8fb6a9ae1c6c6b88
d_0_21:         .dword 0x79fc66a652f2e613, 0x68fd344d414d017b
d_0_22:         .dword 0x64f99b82b5c39357, 0x3a0bef3126a498a3
d_0_23:         .dword 0x95f5f7fe74a77457, 0xab0b823210bd4d9d
d_0_24:         .dword 0x79e70f28f484bb33, 0xe2ae4179280d35b5
d_0_25:         .dword 0x6cb25498328e2cba, 0x234c7c3d8a3a87fd
d_0_26:         .dword 0x343751cba6a3dadd, 0x797d94684c425f0c
d_0_27:         .dword 0xbc55d9b59b5291bb, 0x475ceb712a86ecea
                .dword 0x02bb0073c9c7dd8b, 0x74641dd775d7e736
                .dword 0x307a12b1d6b52613, 0xc310d9fee279f636
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xf9ad9da16db39dd2, 0xdca48fb4b58ba42b
                .dword 0x92efd19d9ada37a5, 0x5af32f5fa5da5e2d
d_1_0:          .dword 0xb7b241bfbe614c41, 0xa1693b77f69ecd00
d_1_1:          .dword 0x56fdf5c7d779557a, 0xe85a479bda311c1e
d_1_2:          .dword 0x949f8e5f8daa57d8, 0xce5a34ca6837e18a
d_1_3:          .dword 0xb379eb055d147784, 0x8cdbb4a824ecf545
d_1_4:          .dword 0x62f214f365be127f, 0xd2753af663a77894
d_1_5:          .dword 0xa2ce84906a407e58, 0xd8012f35b17d2268
d_1_6:          .dword 0xaf1cf02a0669f562, 0xaf173925e0f792fa
d_1_7:          .dword 0xa6bdc98e08852735, 0x956ea28eca8e75d3
d_1_8:          .dword 0xe8bdac757ba726b5, 0x4b06d2ef02547495
d_1_9:          .dword 0x24f807750bf63a59, 0x6e53c3b9b3edcbed
d_1_10:         .dword 0xa52dbd39493b9a47, 0xdaceb4e88f988309
d_1_11:         .dword 0x7a084891d0d5ecf7, 0x36380c6350e0ad93
d_1_12:         .dword 0xcb2d935d168f0b1b, 0xe956a95eafe15f36
d_1_13:         .dword 0xa857ef66fb63bd28, 0x1054e7f4475cd181
d_1_14:         .dword 0xb5c75cc29d816e54, 0xc932ca3e83c8e53b
d_1_15:         .dword 0xb90f09d29b1a8a18, 0xadcb009a9d84bc25
d_1_16:         .dword 0x9fbdba59d4a6fb54, 0x437ae4123c6fd2ab
d_1_17:         .dword 0x94448f54bbeedef1, 0xc42ba081cf2e238d
d_1_18:         .dword 0xb0dd6b68ff479839, 0x015e04dc30ad4701
d_1_19:         .dword 0xd1f43d8faf371424, 0x4f03a9a1926d5b38
d_1_20:         .dword 0x4d0a0d8b6d55e568, 0xf60b125fbb811322
d_1_21:         .dword 0x37f4095abc2cfeb3, 0x9d530a4a251c7da3
d_1_22:         .dword 0xe8b54347e4ad29c4, 0x3e66fe0e9969defd
d_1_23:         .dword 0x644b6c4115313276, 0x9d1d4f09e8008e20
d_1_24:         .dword 0x8efee606e60a5175, 0x9ba1f779aac755b0
d_1_25:         .dword 0xfa0073716defc35e, 0x08c5cfe2f70fb0b9
d_1_26:         .dword 0x07027d674f158da1, 0xb82efee845dcce82
d_1_27:         .dword 0xbbd7037fcfd08480, 0x512d597e008ad242
                .dword 0x9380c468714496f9, 0x1c0b442840535060
                .dword 0xd1a517e3f20f40be, 0x4b8b710a538f021b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x150e5e59138551c0, 0xafbb889c23b81c0c
                .dword 0x62025fa949e93598, 0x6c1bd2c7f5143e24
d_2_0:          .dword 0xa9c26ec413859b91, 0xc31d9e3b70d295d9
d_2_1:          .dword 0xf0c2b1c436d1c353, 0x624e71af49d431fa
d_2_2:          .dword 0x07b7e4a87e2195f9, 0xeebc0e71b87b3c47
d_2_3:          .dword 0xfdd62232fd1e3db5, 0x74dfd38d81513fb0
d_2_4:          .dword 0x1a27d84b5d6d1eaa, 0x7b41bba158f15877
d_2_5:          .dword 0xe2c63ee114f97bde, 0x3ae1a35db9247a7c
d_2_6:          .dword 0x8108d930313151e3, 0x3ddc5f23f2933996
d_2_7:          .dword 0x25d51fae22231173, 0xbc1851061792ccae
d_2_8:          .dword 0x45fed71f4b04ef71, 0x45e80cbab33cff08
d_2_9:          .dword 0x1201bb9988ed0ffa, 0xf927f8883b6fbfc2
d_2_10:         .dword 0x4226eccd9215fe50, 0xbc95a69a598a7950
d_2_11:         .dword 0xf91c835eaee63419, 0x08450f2528d64535
d_2_12:         .dword 0x31e0f38235f6347e, 0x1e04888420b2498e
d_2_13:         .dword 0xf96199a89657e93a, 0x0eced7c4f05856c4
d_2_14:         .dword 0xa8c285b284f3f738, 0xbaaf7944158aad06
d_2_15:         .dword 0x39408e27a3c24783, 0x1f43d54ef283a5bc
d_2_16:         .dword 0x6144175704ee2f4a, 0xadc0781c206284fc
d_2_17:         .dword 0xe5d6db0f09cb90a3, 0x1259a03c1a54b42f
d_2_18:         .dword 0x8feca290237cdc4c, 0xc7354debbd362bb0
d_2_19:         .dword 0x0721f868e4654d9c, 0x81a6d3d6222a42d2
d_2_20:         .dword 0xd9b0d187906b4f53, 0x44bcf848d6ca2c59
d_2_21:         .dword 0xed27c669a4f20ed5, 0x19b8358a91cc89bb
d_2_22:         .dword 0xf78ce3fdb6bbed1c, 0xaa6e5b2e0064bf65
d_2_23:         .dword 0x395efe6957287834, 0x6e250a2f0fa47f13
d_2_24:         .dword 0x491ff61f54dafed2, 0x61d5210705c3e527
d_2_25:         .dword 0xd2c7ae69e393ef05, 0x599b91bbd2012625
d_2_26:         .dword 0xa73932cfcfa56c5c, 0xd8a0a7a776e7a95d
d_2_27:         .dword 0x0a1d4879e832cae2, 0x338c5ce22cbe765f
                .dword 0x5507db602cfb86ff, 0x4640f48b29e1dd00
                .dword 0x21db080398ac1c44, 0xe2526a91e96003a3
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x42ce973b45caaf5f, 0x5fcff8bb4a36a195
                .dword 0x5d98b126eb0b72eb, 0x546df6a84e241882
d_3_0:          .dword 0x809588099719ea2f, 0x61c417d613d3faa8
d_3_1:          .dword 0x32273046216e204c, 0x23be63c6d6153a9c
d_3_2:          .dword 0xea0cf4cdbe40d648, 0xd5eb06b2d9df2d8a
d_3_3:          .dword 0xb6713e715b13d373, 0x84927bcc81d2b727
d_3_4:          .dword 0x006a791cea5de196, 0xa277037aee470afc
d_3_5:          .dword 0xa9f7b0a2086e36c6, 0x5636d7a3f0f78652
d_3_6:          .dword 0x733795a3828b3989, 0xf47a51b7704128d8
d_3_7:          .dword 0x861092fa90d8fcd5, 0x2e4b9222e994059a
d_3_8:          .dword 0x432ac1a0ab1b137b, 0x0f0e89156559716f
d_3_9:          .dword 0xf2020e800f92cd78, 0x00c0bd5ce0fc01b9
d_3_10:         .dword 0x67e3da1c90110c72, 0x64030fcbe731b8a9
d_3_11:         .dword 0x2aa490e784927d15, 0xba67ead7ffc620a0
d_3_12:         .dword 0x796dfe431fa1d731, 0xbab8150e1c82000f
d_3_13:         .dword 0xc2c31dfc170352dd, 0xf82ae43c459c3531
d_3_14:         .dword 0xe5071b723bb95844, 0x716b2fbb8cd9f468
d_3_15:         .dword 0x6833a512f67a8467, 0xf8d38783434c671e
d_3_16:         .dword 0x0b7494a61fc11d3d, 0xfe8d056a10a963ba
d_3_17:         .dword 0xc6db32ac9309bb71, 0x9e8d9a72b739b5e8
d_3_18:         .dword 0xa9656452f83bc46d, 0x6d727c227e51add4
d_3_19:         .dword 0xa2a075c64c400e6e, 0x4ef6b152600b31d1
d_3_20:         .dword 0x795d0bc4c9ba6f4e, 0xaec2b231be53aa1b
d_3_21:         .dword 0xc1fee0e971cf0d58, 0x8c29b3bf15e09be3
d_3_22:         .dword 0x0c41095dbb637bf1, 0xec047e01f2794fbc
d_3_23:         .dword 0x897027ead864bbc5, 0x17b8cfdf3fffb530
d_3_24:         .dword 0x47413a8d3c4ae4cd, 0xc8231c9d49af1e56
d_3_25:         .dword 0xdb6cf8ad11b13982, 0x4f768b961d2f1cd6
d_3_26:         .dword 0x20313bcc019911eb, 0x1f0eeb4e2db51906
d_3_27:         .dword 0x36460d63fe6f594b, 0x5f70beeaeee6b6b3
                .dword 0x555ba83fffa5a6fe, 0x9fcb70cf1617a261
                .dword 0x3efbd657887b716a, 0x6ed1eca0e8ebe4bc
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xe5b70888eabeb354, 0xb7e66afbcbaee03f
                .dword 0x5db915df413f7e1a, 0x28368651f0567bbd
d_4_0:          .dword 0x0a6d857de1f977c1, 0xa4c9fb5e10d2462f
d_4_1:          .dword 0xf10408e7205d0228, 0xcf2eb4c681a101e1
d_4_2:          .dword 0x4564f8e783b2dec4, 0x840fc46f780818ea
d_4_3:          .dword 0xc8de19940a936630, 0xbb48cb72b91d6ac8
d_4_4:          .dword 0x80bbbcda77782088, 0x8489c20aef4be793
d_4_5:          .dword 0xdfc03f7f0fa188d0, 0x0712577f5b1d865b
d_4_6:          .dword 0x3797bc7ee7bce49e, 0xd2b94baf49cd14da
d_4_7:          .dword 0xb195364babb6b0c7, 0xe2e66fb7921e6e3d
d_4_8:          .dword 0x15f85df8425a13a7, 0x80561b3148fca33f
d_4_9:          .dword 0x1203ae534ba36d9f, 0x0c637af3589bfb94
d_4_10:         .dword 0x655b708c962ddde9, 0xe805181d0bf3a042
d_4_11:         .dword 0xcb17b249727f8220, 0x90e0f93af0fbb8e3
d_4_12:         .dword 0x5c5934df03b80843, 0xb10dd376f89e7b06
d_4_13:         .dword 0x62690bdb0e3d1253, 0x9d610ea8e500c102
d_4_14:         .dword 0x2f6d8a6e8c850b05, 0xebb55670a43327d9
d_4_15:         .dword 0x2b99d163e782e37a, 0x073ac1203707465e
d_4_16:         .dword 0x933eace031863aa7, 0x85c5025288516ef2
d_4_17:         .dword 0x222568fe7522fddf, 0x9e9447a696fcd106
d_4_18:         .dword 0x82b251469480fccd, 0xde8423fba770544b
d_4_19:         .dword 0x4c6d6d85decc6fc4, 0x38eed5a7dbee7694
d_4_20:         .dword 0x388ec4a67f6eacbf, 0xebabca27342f8b4f
d_4_21:         .dword 0x64df6161f9f534be, 0xa2c2f30255b0ee4c
d_4_22:         .dword 0x56dcd73a32426b53, 0x3e32876b6f80e413
d_4_23:         .dword 0x6cb8aec92101e5c1, 0xbec5977d0117988b
d_4_24:         .dword 0x17bdd19615bbd0e5, 0x3a5e0ae99f1e99f5
d_4_25:         .dword 0xeebab5c0dad69a74, 0xef3010cd79bee2db
d_4_26:         .dword 0xa61545d8d176337d, 0x7a891fb55fc9f001
d_4_27:         .dword 0xce9adbef0d662970, 0x0bfa36f90240de70
                .dword 0x879db9a8c7f71e2e, 0x591e46ca73ef3836
                .dword 0xcfc57ccbf39611b3, 0x31195eab2ada85f5
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xcf91b792a9cd60ff, 0xd5e965b4d3bb5d80
                .dword 0xbdbbb14c27fb557b, 0xbc2d098703a6eae6
d_5_0:          .dword 0x9024d28b5e53a904, 0xa0d22bc19e174f4b
d_5_1:          .dword 0xea2f480785a0c7b6, 0xf024b752f872f48f
d_5_2:          .dword 0x9df0c6a78353b125, 0x1c1be3d8fc685ca6
d_5_3:          .dword 0xbec05e82466a7169, 0xfafbf2c2ae7f78d0
d_5_4:          .dword 0xb452a22fb69a1d34, 0x11b5b8c86476716d
d_5_5:          .dword 0x76f6acba7f654a93, 0xa4eae6d7301b122e
d_5_6:          .dword 0xdd1d5989ee97343a, 0x885ffec46eb529a7
d_5_7:          .dword 0x1349c26e004b3977, 0x5abfdec025cc8c6c
d_5_8:          .dword 0x25204f4aaeb10e2f, 0xd1349a41359f2983
d_5_9:          .dword 0x927d9ef774d9ff11, 0x31f14dd75ca066bf
d_5_10:         .dword 0x4784720363ef4a28, 0x49fe1de72e6ad0f9
d_5_11:         .dword 0x1504737be686960c, 0x4270538b74115702
d_5_12:         .dword 0x58d4a30935dc004d, 0xfa6b56e3807aff15
d_5_13:         .dword 0xf7c44ee23725318e, 0x49d64074e4ac7cff
d_5_14:         .dword 0x458cf5e8ada69ec1, 0x09106a99ef1fe056
d_5_15:         .dword 0x989ce3b192bb0bb8, 0x5ac83989b786138b
d_5_16:         .dword 0xf29a42c79d5e7096, 0x5849b57394dfe107
d_5_17:         .dword 0x4f0bf5d49f73c2e5, 0x8d01536e3f069d41
d_5_18:         .dword 0x0ebb9e33ca64aa68, 0xce2f7848982aa8e7
d_5_19:         .dword 0x84ae5d9c974a028c, 0xcd9040e858432738
d_5_20:         .dword 0x730ab897be32eb28, 0x73536b9770f4cc1c
d_5_21:         .dword 0xaee6f7233ffc0921, 0x92b6f0e658156b80
d_5_22:         .dword 0x7e75520bd15d14b1, 0xe5a27fc18613a9f0
d_5_23:         .dword 0x2f0415e64392b158, 0x6864c34cae93d652
d_5_24:         .dword 0xcabc85964b9161bb, 0x59cbf90bbe73c38a
d_5_25:         .dword 0xe63591b64c22e846, 0x9059725e744647a0
d_5_26:         .dword 0x4b2d9658d23dd5b6, 0xdff61756b59652c3
d_5_27:         .dword 0x7de92a9b9ce4ca41, 0x4776abb2ed547cdb
                .dword 0x3fc33261d72ad252, 0xaa6ab36648c067c0
                .dword 0xfd3c93b79f6f7096, 0xdba0549a0ddea92e
         /* Random data */
_end_data5:
              
 
