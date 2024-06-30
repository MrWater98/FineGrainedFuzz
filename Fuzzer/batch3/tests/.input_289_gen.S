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
_p0:    xor x11, x11, x11                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 21                         ;
        add x11, x11, x14                         ;
        csrrs x14, frm, x11                       ;
_p1:    csrrsi x10, satp, 24                      ;
_p2:    la x11, d_0_4                             ;
        srai x11, x11, 1                          ;
        csrrs x14, pmpaddr6, x11                  ;
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
_s0:    ori x20, x2, 53                           ;
_s1:    fcvt.l.s x23, f24, rdn                    ;
_s2:    fence.i                                   ;
_s3:    la x4, d_0_20                             ;
        addi x4, x4, -16                          ;
        amomax.d x12, x19, (x4)                   ;
_s4:    ebreak                                    ;
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
_l0:    fsgnjx.s f25, f23, f23                    ;
_l1:    divuw x13, x11, x25                       ;
_l2:    sltiu x11, x8, -2047                      ;
_l3:    fmul.s f25, f29, f23, dyn                 ;
_l4:    la x21, d_5_5                             ;
        addi x21, x21, 20                         ;
        amoand.w x21, x19, (x21)                  ;
_l5:    srliw x17, x13, 24                        ;
_l6:    fclass.s x25, f26                         ;
_l7:    srliw x10, x6, 30                         ;
_l8:    la x11, d_0_11                            ;
        addi x11, x11, 24                         ;
        amoadd.w x10, x21, (x11)                  ;
_l9:    rem x7, x20, x23                          ;
_l10:   la x2, d_4_0                              ;
        addi x2, x2, -28                          ;
        amomaxu.w x23, x29, (x2)                  ;
_l11:   bltu x21, x13, _l121                      ;
_l12:   fcvt.wu.s x13, f19, rne                   ;
_l13:   fmadd.s f12, f17, f17, f30, rmm           ;
_l14:   subw x23, x7, x11                         ;
_l15:   csrrsi x8, pmpaddr6, 22                   ;
_l16:   fmsub.s f30, f25, f10, f23, rmm           ;
_l17:   la x8, d_0_0                              ;
        addi x8, x8, -8                           ;
        amoadd.d x11, x10, (x8)                   ;
_l18:   fcvt.s.l f25, x5, rdn                     ;
_l19:   mulh x23, x19, x30                        ;
_l20:   fle.s x15, f10, f9                        ;
_l21:   la x3, d_3_15                             ;
        addi x3, x3, -20                          ;
        amoxor.w x27, x3, (x3)                    ;
_l22:   slli x21, x24, 53                         ;
_l23:   fsqrt.s f9, f30, dyn                      ;
_l24:   la x7, d_1_5                              ;
        addi x7, x7, 0                            ;
        sc.d x9, x7, (x7)                         ;
_l25:   remuw x5, x27, x15                        ;
_l26:   xori x12, x23, 2047                       ;
_l27:   fsgnjx.s f14, f14, f16                    ;
_l28:   la x10, _l185                             ;
        jalr x15, 0(x10)                          ;
_l29:   la x17, d_0_18                            ;
        lui x13, 0xffe00                          ;
        xor x17, x17, x13                         ;
        lbu x1, 0(x17)                            ;
_l30:   srli x18, x14, 63                         ;
_l31:   fcvt.s.w f23, x10, rdn                    ;
_l32:   la x14, d_3_13                            ;
        addi x14, x14, 24                         ;
        amoand.w x17, x8, (x14)                   ;
_l33:   mulhu x10, x21, x0                        ;
_l34:   la x6, d_1_27                             ;
        addi x6, x6, 12                           ;
        amoadd.w x27, x10, (x6)                   ;
_l35:   la x4, d_1_23                             ;
        addi x4, x4, -16                          ;
        amoadd.d x13, x23, (x4)                   ;
_l36:   flt.s x11, f29, f19                       ;
_l37:   la x18, d_4_0                             ;
        addi x18, x18, 8                          ;
        amoadd.d x21, x4, (x18)                   ;
_l38:   fsub.s f2, f9, f23, dyn                   ;
_l39:   csrrwi x8, sepc, 26                       ;
_l40:   la x12, d_2_15                            ;
        addi x12, x12, -12                        ;
        amomax.w x10, x8, (x12)                   ;
_l41:   fence.i                                   ;
_l42:   la x14, d_0_26                            ;
        addi x14, x14, 12                         ;
        amomaxu.w x7, x25, (x14)                  ;
_l43:   la x13, d_1_9                             ;
        lhu x1, 6(x13)                            ;
_l44:   fcvt.l.s x6, f17, rtz                     ;
_l45:   fcvt.s.lu f6, x15, rdn                    ;
_l46:   remuw x3, x2, x17                         ;
_l47:   flt.s x5, f9, f6                          ;
_l48:   xor x13, x13, x13                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 5                          ;
        add x13, x13, x22                         ;
        addi x26, zero, 3                         ;
        slli x26, x26, 19                         ;
        add x13, x13, x26                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 25                         ;
        add x13, x13, x10                         ;
        csrrc x18, mip, x13                       ;
_l49:   divw x12, x21, x21                        ;
_l50:   fadd.s f26, f9, f29, rne                  ;
_l51:   la x30, _l96                              ;
        jalr x24, 0(x30)                          ;
_l52:   mulhsu x9, x5, x1                         ;
_l53:   auipc x25, 911415                         ;
_l54:   fmadd.s f26, f6, f2, f2, dyn              ;
_l55:   sraw x4, x11, x27                         ;
_l56:   la x12, d_0_10                            ;
        addi x12, x12, -0                         ;
        amomin.w x9, x19, (x12)                   ;
_l57:   csrrsi x18, mip, 0                        ;
_l58:   lui x27, 619836                           ;
_l59:   csrrci x27, pmpaddr1, 31                  ;
_l60:   subw x12, x18, x12                        ;
_l61:   la x20, d_2_1                             ;
        addi x20, x20, 16                         ;
        amoor.d x11, x1, (x20)                    ;
_l62:   remw x5, x13, x20                         ;
_l63:   fadd.s f14, f30, f14, rup                 ;
_l64:   beq x18, x9, _l164                        ;
_l65:   fcvt.l.s x14, f2, dyn                     ;
_l66:   fmv.x.w x7, f7                            ;
_l67:   bltu x7, x17, _l133                       ;
_l68:   la x14, d_1_21                            ;
        addi x14, x14, 8                          ;
        amoadd.d x10, x8, (x14)                   ;
_l69:   fmul.s f10, f7, f10, rmm                  ;
_l70:   rem x19, x9, x5                           ;
_l71:   feq.s x16, f7, f2                         ;
_l72:   xor x4, x4, x4                            ;
        addi x22, zero, 1                         ;
        slli x22, x22, 4                          ;
        add x4, x4, x22                           ;
        csrrw x5, fcsr, x4                        ;
_l73:   la x20, d_2_20                            ;
        lw x27, -0(x20)                           ;
_l74:   fnmadd.s f25, f19, f0, f14, rtz           ;
_l75:   slliw x28, x2, 0                          ;
_l76:   slli x29, x23, 52                         ;
_l77:   fnmsub.s f27, f30, f18, f29, rtz          ;
_l78:   fcvt.l.s x19, f10, dyn                    ;
_l79:   remu x17, x15, x22                        ;
_l80:   la x5, d_4_13                             ;
        addi x5, x5, 16                           ;
        amoxor.d x4, x23, (x5)                    ;
_l81:   bne x22, x3, _l172                        ;
_l82:   la x16, d_4_25                            ;
        sh x29, 12(x16)                           ;
_l83:   bne x11, x12, _l110                       ;
_l84:   div x23, x17, x4                          ;
_l85:   la x11, d_5_20                            ;
        addi x11, x11, 0                          ;
        lui x1, 0xffe00                           ;
        xor x11, x11, x1                          ;
        amoswap.d x28, x1, (x11)                  ;
_l86:   la x23, d_2_24                            ;
        fsw f7, -16(x23)                          ;
_l87:   la x1, d_1_19                             ;
        addi x1, x1, -8                           ;
        amoor.d x2, x3, (x1)                      ;
_l88:   fcvt.s.lu f29, x3, rdn                    ;
_l89:   xori x11, x10, 1007                       ;
_l90:   mulhu x1, x30, x6                         ;
_l91:   sraw x14, x3, x14                         ;
_l92:   fadd.s f31, f10, f21, rdn                 ;
_l93:   fsqrt.s f0, f0, rdn                       ;
_l94:   ebreak                                    ;
_l95:   sllw x12, x11, x28                        ;
_l96:   la x8, d_1_6                              ;
        lui x17, 0xffe00                          ;
        xor x8, x8, x17                           ;
        sb x7, -29(x8)                            ;
_l97:   la x15, d_5_18                            ;
        addi x15, x15, 16                         ;
        amoand.d x7, x20, (x15)                   ;
_l98:   fadd.s f22, f0, f5, rne                   ;
_l99:   la x10, d_1_25                            ;
        addi x10, x10, -12                        ;
        lui x12, 0xffe00                          ;
        xor x10, x10, x12                         ;
        sc.w x21, x12, (x10)                      ;
_l100:  beq x29, x16, _l110                       ;
_l101:  divuw x15, x23, x28                       ;
_l102:  la x27, d_5_19                            ;
        addi x27, x27, 0                          ;
        amoor.w x14, x7, (x27)                    ;
_l103:  fdiv.s f19, f24, f4, rtz                  ;
_l104:  fcvt.wu.s x9, f19, rmm                    ;
_l105:  mulw x11, x19, x20                        ;
_l106:  auipc x20, 435092                         ;
_l107:  la x29, d_3_17                            ;
        lbu x21, 23(x29)                          ;
_l108:  bge x25, x13, _l157                       ;
_l109:  div x10, x28, x17                         ;
_l110:  remu x9, x12, x24                         ;
_l111:  auipc x10, 1048575                        ;
_l112:  la x16, d_2_12                            ;
        sw x7, -20(x16)                           ;
_l113:  xor x23, x23, x23                         ;
        addi x8, zero, 3                          ;
        slli x8, x8, 23                           ;
        add x23, x23, x8                          ;
        csrrw x27, mip, x23                       ;
_l114:  fsqrt.s f3, f27, rup                      ;
_l115:  fmv.x.w x7, f25                           ;
_l116:  la x21, d_0_21                            ;
        addi x21, x21, -0                         ;
        amomax.w x26, x30, (x21)                  ;
_l117:  srai x30, x11, 14                         ;
_l118:  la x2, d_3_8                              ;
        addi x2, x2, -8                           ;
        amoor.d x12, x9, (x2)                     ;
_l119:  la x20, d_5_26                            ;
        addi x20, x20, 24                         ;
        amoxor.d x16, x5, (x20)                   ;
_l120:  beq x17, x21, _l144                       ;
_l121:  mulhu x11, x14, x6                        ;
_l122:  fence                                     ;
_l123:  fcvt.lu.s x3, f31, dyn                    ;
_l124:  fmul.s f4, f13, f1, rmm                   ;
_l125:  jal x18, _l156                            ;
_l126:  remu x8, x16, x9                          ;
_l127:  fsgnjx.s f11, f8, f30                     ;
_l128:  remu x7, x25, x6                          ;
_l129:  la x18, d_3_20                            ;
        srai x18, x18, 1                          ;
        csrrw x12, pmpaddr4, x18                  ;
_l130:  fcvt.s.lu f29, x30, rdn                   ;
_l131:  la x25, d_4_14                            ;
        addi x25, x25, 16                         ;
        amomin.d x3, x8, (x25)                    ;
_l132:  la x11, d_1_21                            ;
        lhu x27, 6(x11)                           ;
_l133:  fsgnj.s f13, f5, f18                      ;
_l134:  la x20, d_0_8                             ;
        addi x20, x20, 0                          ;
        amoor.d x23, x12, (x20)                   ;
_l135:  fcvt.s.wu f20, x29, rdn                   ;
_l136:  addiw x18, x21, 1612                      ;
_l137:  fsgnjn.s f21, f11, f9                     ;
_l138:  srlw x28, x29, x23                        ;
_l139:  fcvt.s.wu f2, x5, rne                     ;
_l140:  la x20, d_0_4                             ;
        addi x20, x20, 16                         ;
        amoand.w x1, x9, (x20)                    ;
_l141:  xor x17, x17, x17                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 11                         ;
        add x17, x17, x28                         ;
        csrrs x27, fcsr, x17                      ;
_l142:  fmax.s f26, f20, f17                      ;
_l143:  srliw x29, x28, 5                         ;
_l144:  la x28, d_4_1                             ;
        sh x25, 6(x28)                            ;
_l145:  fnmadd.s f30, f5, f14, f9, dyn            ;
_l146:  fmv.x.w x27, f6                           ;
_l147:  lui x23, 818738                           ;
_l148:  mul x15, x29, x0                          ;
_l149:  xor x17, x17, x17                         ;
        csrrc x30, fflags, x17                    ;
_l150:  la x23, d_2_24                            ;
        srai x23, x23, 1                          ;
        csrrs x2, pmpaddr1, x23                   ;
_l151:  subw x10, x11, x21                        ;
_l152:  lui x29, 638520                           ;
_l153:  fmin.s f8, f6, f1                         ;
_l154:  remuw x21, x29, x20                       ;
_l155:  mul x5, x11, x16                          ;
_l156:  rem x6, x12, x17                          ;
_l157:  srliw x13, x17, 31                        ;
_l158:  la x18, d_4_15                            ;
        addi x18, x18, 0                          ;
        sc.d x22, x18, (x18)                      ;
_l159:  fsgnjn.s f14, f17, f16                    ;
_l160:  la x27, d_1_4                             ;
        addi x27, x27, 0                          ;
        amoswap.w x19, x19, (x27)                 ;
_l161:  feq.s x0, f15, f31                        ;
_l162:  fcvt.s.l f5, x23, rmm                     ;
_l163:  slli x4, x27, 60                          ;
_l164:  la x6, d_5_19                             ;
        lhu x26, -28(x6)                          ;
_l165:  div x15, x3, x17                          ;
_l166:  fdiv.s f24, f31, f7, dyn                  ;
_l167:  fcvt.lu.s x0, f7, rmm                     ;
_l168:  la x16, d_5_11                            ;
        addi x16, x16, 0                          ;
        amomaxu.d x1, x16, (x16)                  ;
_l169:  la x23, d_5_5                             ;
        addi x23, x23, 16                         ;
        amominu.w x2, x10, (x23)                  ;
_l170:  fmv.w.x f29, x21                          ;
_l171:  la x30, d_3_13                            ;
        addi x30, x30, -20                        ;
        lui x3, 0xffe00                           ;
        xor x30, x30, x3                          ;
        amominu.w x14, x3, (x30)                  ;
_l172:  rem x23, x30, x1                          ;
_l173:  addw x22, x20, x1                         ;
_l174:  mulh x23, x14, x19                        ;
_l175:  la x21, d_3_27                            ;
        addi x21, x21, -20                        ;
        amomin.w x30, x30, (x21)                  ;
_l176:  la x29, d_3_17                            ;
        lhu x19, 0(x29)                           ;
_l177:  auipc x29, 715101                         ;
_l178:  xor x28, x28, x28                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 25                         ;
        add x28, x28, x27                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 3                          ;
        add x28, x28, x28                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 14                         ;
        add x28, x28, x14                         ;
        csrrs x19, sie, x28                       ;
_l179:  li x16, 0                                 ;
        la x14, pt2                               ;
        addi x14, x14, 56                         ;
        sfence.vma x16, x14                       ;
_l180:  la x8, d_2_18                             ;
        addi x8, x8, -16                          ;
        amoswap.d x24, x22, (x8)                  ;
_l181:  fcvt.s.l f20, x22, rdn                    ;
_l182:  la x6, d_0_16                             ;
        addi x6, x6, 16                           ;
        amoor.d x4, x26, (x6)                     ;
_l183:  la x7, d_4_22                             ;
        addi x7, x7, -20                          ;
        amoswap.w x2, x4, (x7)                    ;
_l184:  sllw x8, x9, x3                           ;
_l185:  la x6, d_5_11                             ;
        addi x6, x6, -8                           ;
        amoand.d x17, x4, (x6)                    ;
_l186:  la x24, _l187                             ;
        jalr x15, 0(x24)                          ;
_l187:  mulhsu x18, x11, x6                       ;
_l188:  la x11, d_5_22                            ;
        sb x1, -30(x11)                           ;
_l189:  la x22, d_5_10                            ;
        sb x27, -16(x22)                          ;
_l190:  slti x24, x26, -1531                      ;
_l191:  fcvt.w.s x5, f16, rne                     ;
_l192:  fclass.s x27, f5                          ;
_l193:  fence.i                                   ;
_l194:  fcvt.s.w f23, x7, rup                     ;
_l195:  csrrsi x9, mhartid, 0                     ;
_l196:  fle.s x4, f23, f7                         ;
_l197:  fdiv.s f11, f1, f28, dyn                  ;
_l198:  div x25, x1, x7                           ;
_l199:  csrrsi x15, pmpaddr3, 16                  ;
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
                .dword 0xc838796776748845, 0xf6007b5f92bb4b87
                .dword 0x5a81f5d5dedc2e8b, 0x984081c8158499de
d_0_0:          .dword 0x80f70bdd5ccfc728, 0x2af23d42cd946835
d_0_1:          .dword 0xeb493a99e2dd58fc, 0x5bb33ae42a4a2fdc
d_0_2:          .dword 0x02677d473a4ad335, 0x1232a4777fefcf0c
d_0_3:          .dword 0x4239ffb25d0bd42e, 0xa9ec31b5af8250f9
d_0_4:          .dword 0xd7aa0d38f0a0128a, 0xddd20f97d6cafe1f
d_0_5:          .dword 0xe1e0d278377ad44e, 0x00b19a038ece40d8
d_0_6:          .dword 0x57551621603ed3a8, 0xd06ed21faca9c7cf
d_0_7:          .dword 0xd3a18a30f1e31e7b, 0x31519b5f58d13d92
d_0_8:          .dword 0xdd3eb004f24bd867, 0xa46fcc43431cce74
d_0_9:          .dword 0x6f50ec92a5022f3a, 0x04657d9f14109153
d_0_10:         .dword 0x3966a272b0aa69ca, 0xe686760820a0c74c
d_0_11:         .dword 0x6b634a7dfff62c9e, 0x3673998cc9a23ebd
d_0_12:         .dword 0x66e0d9a3f07be54f, 0x18b94fa746eba845
d_0_13:         .dword 0x3895fc820bb83f8e, 0x285102a96162392a
d_0_14:         .dword 0x1ca318030a2db7c7, 0x9c786776c317ee1e
d_0_15:         .dword 0x1086f2da9d6842e6, 0x9ed6fed5a8199218
d_0_16:         .dword 0xbacd5961578751b5, 0x43847a4dbfb03a67
d_0_17:         .dword 0x133c9d209250c76f, 0xa0bfcfc4c4665591
d_0_18:         .dword 0x4f287ba390875dfe, 0x09cc1cd5968e1f50
d_0_19:         .dword 0xc35ff16ffb79d5cb, 0x32f4297c33bc210e
d_0_20:         .dword 0x10e0047fe921ccb2, 0x442f81ffefb54d99
d_0_21:         .dword 0x525be7cc29f16ede, 0x6526b17e19d6b277
d_0_22:         .dword 0xdb54cf2f28223711, 0x8d2e27fff29ed2b6
d_0_23:         .dword 0xcc78d22251de30a8, 0x92173cf205661b5d
d_0_24:         .dword 0x02ba88902d6dba74, 0x48c7120b5ad09ad2
d_0_25:         .dword 0x74d690187ffd695b, 0xd28905fa8241c211
d_0_26:         .dword 0x0e0b17815fe8eb03, 0xa39e091bad17a0cd
d_0_27:         .dword 0x0e5c0331cc319352, 0x13596c9994c5ee1a
                .dword 0x75bc6fdf633a3886, 0xf59641ea15c18bc4
                .dword 0xbb314e8bc04ffaf3, 0x82eabb51dd7f348a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0d0bfc7278f15e88, 0x6402fa26c9579878
                .dword 0xadfbef1699502b98, 0xb3fc360cb1024415
d_1_0:          .dword 0x6f70d305e0532615, 0x18e6b15384e52489
d_1_1:          .dword 0xe52a33afe59f5e5e, 0x321b05c48d386054
d_1_2:          .dword 0x492d1ae2be87da77, 0x03c4bae8f4a97655
d_1_3:          .dword 0x36c3acd2727ead6c, 0x083138b52662dbd2
d_1_4:          .dword 0x40e7b532b0af0b43, 0x0a625b40001308be
d_1_5:          .dword 0xe509feda3d014663, 0xe99e058b261c46be
d_1_6:          .dword 0xea5331354f64f6ee, 0x1b23a888f56ce104
d_1_7:          .dword 0x2a92cd67cf499ef0, 0x361644d570e5052f
d_1_8:          .dword 0x508c9c721748a49b, 0x85574974b42a4cbf
d_1_9:          .dword 0x22f2fce89fdf59f1, 0xb6d93d13d3ee0ff5
d_1_10:         .dword 0x360dabf3efb09c1e, 0xb1df4bc6ef3ae97c
d_1_11:         .dword 0x357bddc343a5f06e, 0x3053f5fca063dd2d
d_1_12:         .dword 0x375b4b89013fee00, 0x054db5890c9ad082
d_1_13:         .dword 0xb8c6a06653e47206, 0x750559ae6193bfc3
d_1_14:         .dword 0xef771b82b976e7c2, 0x1b13569a4ee7d372
d_1_15:         .dword 0x5878bf0e06407d09, 0x3e0a91bcabaa08a0
d_1_16:         .dword 0xa8f6fc981df4a9db, 0xf1928232f21a3b09
d_1_17:         .dword 0x7e27d505a7ddefbd, 0x041590b96a5b91c9
d_1_18:         .dword 0x74fb15ae2ac64f4e, 0x1bfb0af7814839f5
d_1_19:         .dword 0x5e03a3e4946da964, 0xc32436a8e712e3b9
d_1_20:         .dword 0x2fdfa8da99c883a1, 0x33372166ce35d0e0
d_1_21:         .dword 0xce2946d21373fa4f, 0x665ee16f1f8a4198
d_1_22:         .dword 0x479d1b3670e5fe3c, 0xd24903d47880c704
d_1_23:         .dword 0xbf5bedb57c65cbc1, 0x57c1855d5d9f016e
d_1_24:         .dword 0x342504056d1daf3a, 0x40dce4f686d0e132
d_1_25:         .dword 0x51c9c160925cb390, 0xabce9cca225219c5
d_1_26:         .dword 0x48d691dd4df9a936, 0x0bfb23f3a4a97029
d_1_27:         .dword 0x9f4eed30aa860aa9, 0xe2d9c32d49820b23
                .dword 0x29e53b3b3820c735, 0x1d992579175d624f
                .dword 0x2964a3eaa9bf02d2, 0x363344e72bb1711f
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd0782e682490c3a1, 0x0bc908005bf02134
                .dword 0xe961d88424de4a1c, 0x2fec23b939a90d95
d_2_0:          .dword 0x184d4b4575a451a3, 0x6f8be83412d474ea
d_2_1:          .dword 0x5c3ad22030036595, 0xe5c7aa4d8cb378ec
d_2_2:          .dword 0x819855e6aa192071, 0xe4d8262e473557d6
d_2_3:          .dword 0x1eea8127393ce7f1, 0xdcf6717e79f4fe17
d_2_4:          .dword 0xb6fffd2034d41ec8, 0x9072d495d68548d5
d_2_5:          .dword 0xd52fca9ce1a2fea5, 0xeb8305d2219f7db5
d_2_6:          .dword 0xed3997758af11775, 0xe2a1602edfdc2177
d_2_7:          .dword 0x62d8288a0fa475f0, 0xc1905419d206813c
d_2_8:          .dword 0x018a0d8ef952a769, 0xc2f8719c14ab6d92
d_2_9:          .dword 0xd792ef95f50a375d, 0x803b32020da5506c
d_2_10:         .dword 0xd9cf229ecc140bf9, 0x6e4895e9932a3c90
d_2_11:         .dword 0x68046776496ace04, 0xdaa3ca3baa77889a
d_2_12:         .dword 0x1abf3bbe95a9866c, 0x415c611d96a0d23f
d_2_13:         .dword 0xdd3babf190cd3335, 0xc1011c448e68b8a1
d_2_14:         .dword 0x1d3b7537219499c5, 0x5d056de93415c1dd
d_2_15:         .dword 0x5bbad9e4a507e61c, 0xc5a8403896a011ad
d_2_16:         .dword 0xc2231475ec7c08cf, 0xf02c372d4c7a5707
d_2_17:         .dword 0xbc07794a7a604cee, 0xf82271a109db9e64
d_2_18:         .dword 0x39318a24ebbce64c, 0x7318c0a53a7167b7
d_2_19:         .dword 0x0899070906ee1534, 0xdf9770c5a21ce0b6
d_2_20:         .dword 0x8daaebcb4614d489, 0x716c199c91c380ed
d_2_21:         .dword 0x7d0d1bd1de4d271f, 0x1c8ad7d827162f3b
d_2_22:         .dword 0xd80d53a1623a39c7, 0x6ae21edf1a53600f
d_2_23:         .dword 0xd0f57b318f0ffbe5, 0xcce7c1c6b271e24b
d_2_24:         .dword 0x3bc38f15a008a56c, 0x3968499aa1ac7ea1
d_2_25:         .dword 0x943cb4cb3459e5a7, 0x0dbb4f387fcb6470
d_2_26:         .dword 0x3d5b7f6876a9007f, 0x8d05751f5e2be6c8
d_2_27:         .dword 0xaac0ca53d2968a57, 0x286bf37cab8415b9
                .dword 0xdf2b9177a12cbb23, 0xd7f908601866a410
                .dword 0x490db32f581f7d9b, 0x4b2c7806fd433c2b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x2a12a8a556b6a9eb, 0xdd0b3052846c6de2
                .dword 0x6c2318efdbecce72, 0x090e27595334f368
d_3_0:          .dword 0x9676c952e1300351, 0x0a05db3db6b00aca
d_3_1:          .dword 0xe0e0023423f05865, 0x48b91765d24f6f4a
d_3_2:          .dword 0xe4203b8f8b0bc08d, 0x57c8daccfdb5667f
d_3_3:          .dword 0x3a75eabab0beb6c3, 0xd12e55b0f36551ce
d_3_4:          .dword 0x9c7ef74e659eaaa9, 0x40d9f8dc48177825
d_3_5:          .dword 0x72b72c9b180356e8, 0x534b80c9dfcc9da9
d_3_6:          .dword 0xb65a5bd13b38bbda, 0x88b3ab6b1d02e4b7
d_3_7:          .dword 0x5b876e2afaa44518, 0xf419087cdabd65b7
d_3_8:          .dword 0x750cc4f44cb1cae8, 0xc9a3dc3f1e8178b5
d_3_9:          .dword 0x841379623203a293, 0xf7abb0f6717579c9
d_3_10:         .dword 0x6268b11ce7c78408, 0xb6ee90697850a626
d_3_11:         .dword 0xdc9dd4460064dbbf, 0x966b4d55a4faada5
d_3_12:         .dword 0x0ba2f75848c3c809, 0xe0545d100db17e09
d_3_13:         .dword 0x5372f62fec37bd41, 0x3e63255bdfaa1ce4
d_3_14:         .dword 0x11e0adfd00ae8500, 0xa5d46a177689e50b
d_3_15:         .dword 0x0141015ae741a89e, 0x6db79f68596ff0c3
d_3_16:         .dword 0x95ded517c3484570, 0x4084e4999883142c
d_3_17:         .dword 0x6c5ccef6c33fb137, 0x004f16c78f922d74
d_3_18:         .dword 0x0335c5af17cfb9de, 0xb73a8efe5782eff3
d_3_19:         .dword 0x2d034ac5f54ed95d, 0xac99b4ab87a7f26a
d_3_20:         .dword 0x7f7f9ef510403a38, 0xad99cb2a31f1b509
d_3_21:         .dword 0x09dd6a7c97709dc1, 0xd160bf4ffa5f44e1
d_3_22:         .dword 0xa685a752407a1dc6, 0x191f01b03ebeccd1
d_3_23:         .dword 0x6377b9887ade9016, 0xafbe12b0a6a1fe03
d_3_24:         .dword 0xab44b5e8ceadb0cd, 0xfe80dca692ed7481
d_3_25:         .dword 0x4c776c70989a9b6c, 0x28a670283bc42761
d_3_26:         .dword 0xd45c3c95ed19a5af, 0x03e6e38da9f6b761
d_3_27:         .dword 0xb685f131a9fc5c24, 0xaf4789bdd1e151de
                .dword 0xc8786abc1bd5c621, 0xd6ccf5ecd150cade
                .dword 0xee39a42e4ed04ee1, 0x59068ea86469f67a
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0ef20097dbcff9bd, 0xe58600b6e49cc5b8
                .dword 0xae149c48f65b9d61, 0xe7c3b52390fb5e39
d_4_0:          .dword 0x6cc3177631a49beb, 0x09c076edfc6782fa
d_4_1:          .dword 0x6d9eae34f06f1706, 0x5a16d5a5d775ab91
d_4_2:          .dword 0xfabef0f2e9d8efe1, 0x1f43a5d47bc5ba39
d_4_3:          .dword 0x5e252067615f10d9, 0x856de76c2272a76b
d_4_4:          .dword 0xd054530d6065103c, 0x02e4b39aff0357be
d_4_5:          .dword 0x8a716e0cfc25cd51, 0xf130ff31f397f09e
d_4_6:          .dword 0xd6d1b62cbe2e8433, 0x945de7a2acc090b2
d_4_7:          .dword 0xb1879a2bb7ff9819, 0xe2db0070a5a4b2c4
d_4_8:          .dword 0xa0ab931e6a04289f, 0x19c47c49c7cef719
d_4_9:          .dword 0xeccaa7269d632c77, 0x00bb7493cc17837c
d_4_10:         .dword 0xb008774c4416f366, 0x30f7c73b13babe8d
d_4_11:         .dword 0x3385a97074fd2396, 0x56e1e87b099769bb
d_4_12:         .dword 0x71dd74ac0f702638, 0xca3912cf45fef3cd
d_4_13:         .dword 0x95177acf2d38327c, 0xfd209e9f2a477586
d_4_14:         .dword 0x93e9174abf00699c, 0x2a8ada764e483f62
d_4_15:         .dword 0xd4234e15c988dda5, 0x8f0ed99b9c6cfa71
d_4_16:         .dword 0x9abdfd63189dbe01, 0x9253a6d010d08483
d_4_17:         .dword 0xba0963a49c12eb21, 0xef216434f2274062
d_4_18:         .dword 0xf55887c95197fb3e, 0x31b04dbbdbad1032
d_4_19:         .dword 0x6b3265119b0c0e43, 0x3b058cb27d093749
d_4_20:         .dword 0xc3690df11269d1dc, 0x0456ecea8e588a26
d_4_21:         .dword 0xf99e486b8aa65505, 0x758067e259287291
d_4_22:         .dword 0xcf4377d5c41b6e33, 0xb225d1924a24fe8c
d_4_23:         .dword 0x412675ee361cbf6e, 0xf23cf40cb82ff439
d_4_24:         .dword 0x490e04b37fb4affd, 0x9cf1a7483c2fabaa
d_4_25:         .dword 0x4c42578267e17efc, 0x5059acf2c85cfabf
d_4_26:         .dword 0x61070dcdce9307d2, 0x463aec889ade64fb
d_4_27:         .dword 0x295d174da7709d75, 0x5bd9db55f6160349
                .dword 0x918e0c09b11ce1f2, 0x7cba74f28470aa04
                .dword 0xc7ea9090b9c0353e, 0x3341f6b8584e0da3
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x73389109af6ffa36, 0x3efa7241c4d6882d
                .dword 0x894373324ad0b586, 0x49edc0f3d9598d6e
d_5_0:          .dword 0x36c8d454cfb034fd, 0x3a3248be293a406c
d_5_1:          .dword 0xe5a2dd224d05e461, 0xdb551a7931c621ab
d_5_2:          .dword 0x24c8a75c6ffe01ad, 0xde4aeec62eddf64f
d_5_3:          .dword 0xd14fa615163c0238, 0xf639d9cedc7fe5b2
d_5_4:          .dword 0x74b8e067b8f714be, 0x37b9031c315afb61
d_5_5:          .dword 0x8fa59c0fd9ea6eaf, 0xf68338a176e97efa
d_5_6:          .dword 0x07aca406b88bdf5e, 0xb43039dc8ab4f960
d_5_7:          .dword 0x9cdf3a406d18fdb4, 0xb89d410438370565
d_5_8:          .dword 0x80fb80e8f28cd880, 0x11e4a0243e891173
d_5_9:          .dword 0xaaad4af3194e45f1, 0x2d771bcaa1936453
d_5_10:         .dword 0x562b66ce8dac6cbc, 0xb99d6e7c9182b2fe
d_5_11:         .dword 0x74696d1f2a3523c8, 0xed0dced1c079f964
d_5_12:         .dword 0x1ff5244f601d3e9d, 0xf1ab64aecfd08613
d_5_13:         .dword 0x0f777b807113ee0f, 0x1d832803a26a7127
d_5_14:         .dword 0xe44fa8c02999d21d, 0x7e310f9d58dc5118
d_5_15:         .dword 0x42d152978a7243fd, 0xf144290a3a92b484
d_5_16:         .dword 0x96cad89774cadc05, 0xb8ea07a400220c0c
d_5_17:         .dword 0xb494783e40e9a4d0, 0x024aeaf21195445d
d_5_18:         .dword 0x1c86cf016ebb102e, 0xc679d787da3fcfba
d_5_19:         .dword 0x497788bdef2261c5, 0x4352cc3cee5916e0
d_5_20:         .dword 0xf204d34fd09dee8f, 0x2fa162b88823a5d1
d_5_21:         .dword 0xd17cf83e94c388e1, 0x4c39578fe0672615
d_5_22:         .dword 0x16456170ecd66f11, 0x0270882103dc8687
d_5_23:         .dword 0x5fd4c5f17eac896c, 0xddf2c54b7d1cb474
d_5_24:         .dword 0xb5fe42a9a6ced9ee, 0x4901414fd7cde68d
d_5_25:         .dword 0x302a6f01047c5c16, 0x9c9aead2a198156e
d_5_26:         .dword 0xf69164f7e064cc9d, 0xea96c06ca8dda510
d_5_27:         .dword 0x6bd099323e04c248, 0xa7062adad5534e32
                .dword 0xec63dbe63c4cbe0f, 0xc8bd08530a4807f4
                .dword 0xadd36112079ee4e2, 0x1db3f542b02ec35c
         /* Random data */
_end_data5:
              
 
