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
_p0:    csrrwi x13, pmpaddr2, 3                   ;
_p1:    csrrwi x11, sscratch, 31                  ;
_p2:    xor x12, x12, x12                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 4                          ;
        add x12, x12, x11                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 24                         ;
        add x12, x12, x11                         ;
        csrrc x10, stval, x12                     ;
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
_s0:    la x5, d_1_19                             ;
        addi x5, x5, 16                           ;
        amoswap.d x30, x4, (x5)                   ;
_s1:    la x23, d_4_23                            ;
        addi x23, x23, 8                          ;
        amominu.d x17, x26, (x23)                 ;
_s2:    la x2, d_4_8                              ;
        addi x2, x2, -28                          ;
        lui x8, 0xffe00                           ;
        xor x2, x2, x8                            ;
        amoadd.w x9, x8, (x2)                     ;
_s3:    fmul.s f26, f3, f6, rtz                   ;
_s4:    andi x22, x24, -0                         ;
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
_l0:    bgeu x18, x19, _l79                       ;
_l1:    fmadd.s f15, f27, f27, f21, rtz           ;
_l2:    divw x27, x18, x1                         ;
_l3:    bgeu x23, x2, _l107                       ;
_l4:    div x8, x20, x5                           ;
_l5:    la x22, d_2_19                            ;
        lbu x29, -8(x22)                          ;
_l6:    xor x17, x17, x17                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 23                         ;
        add x17, x17, x13                         ;
        csrrc x9, sstatus, x17                    ;
_l7:    fmin.s f25, f25, f27                      ;
_l8:    slti x10, x8, 738                         ;
_l9:    la x8, d_4_15                             ;
        addi x8, x8, 16                           ;
        sc.d x10, x8, (x8)                        ;
_l10:   sraw x22, x9, x8                          ;
_l11:   fadd.s f21, f4, f26, rdn                  ;
_l12:   la x14, d_1_17                            ;
        addi x14, x14, -28                        ;
        amoswap.w x6, x22, (x14)                  ;
_l13:   fcvt.s.w f30, x7, rmm                     ;
_l14:   fadd.s f18, f25, f4, rtz                  ;
_l15:   slti x6, x24, -1723                       ;
_l16:   la x7, d_2_3                              ;
        addi x7, x7, 24                           ;
        amomax.d x13, x17, (x7)                   ;
_l17:   divw x25, x25, x27                        ;
_l18:   blt x19, x18, _l63                        ;
_l19:   slliw x12, x3, 6                          ;
_l20:   fle.s x4, f22, f26                        ;
_l21:   remw x16, x11, x10                        ;
_l22:   csrrwi x15, scause, 18                    ;
_l23:   fsub.s f27, f16, f26, rne                 ;
_l24:   la x26, d_2_25                            ;
        srai x26, x26, 1                          ;
        csrrs x24, pmpaddr0, x26                  ;
_l25:   la x23, d_2_6                             ;
        addi x23, x23, 8                          ;
        amoor.d x30, x19, (x23)                   ;
_l26:   la x5, d_3_27                             ;
        lbu x5, -28(x5)                           ;
_l27:   srai x8, x6, 17                           ;
_l28:   la x23, d_2_1                             ;
        sw x26, 4(x23)                            ;
_l29:   mulhu x10, x10, x22                       ;
_l30:   la x21, d_0_24                            ;
        addi x21, x21, -16                        ;
        amoxor.w x19, x11, (x21)                  ;
_l31:   remu x26, x6, x8                          ;
_l32:   fnmsub.s f7, f4, f20, f9, rtz             ;
_l33:   la x12, d_4_17                            ;
        lwu x26, -0(x12)                          ;
_l34:   xori x29, x12, 1723                       ;
_l35:   fclass.s x2, f17                          ;
_l36:   la x16, d_1_8                             ;
        sh x10, -10(x16)                          ;
_l37:   la x4, d_1_8                              ;
        lh x18, -2(x4)                            ;
_l38:   mulhu x24, x22, x9                        ;
_l39:   fsub.s f15, f18, f17, rup                 ;
_l40:   mul x15, x23, x29                         ;
_l41:   fle.s x2, f31, f29                        ;
_l42:   slli x13, x12, 63                         ;
_l43:   csrrwi x11, fflags, 8                     ;
_l44:   srai x7, x0, 37                           ;
_l45:   beq x25, x22, _l74                        ;
_l46:   la x11, d_5_6                             ;
        addi x11, x11, -16                        ;
        amominu.d x10, x13, (x11)                 ;
_l47:   la x28, d_4_8                             ;
        addi x28, x28, 0                          ;
        amomax.d x4, x14, (x28)                   ;
_l48:   la x17, d_1_22                            ;
        addi x17, x17, 20                         ;
        amoand.w x21, x1, (x17)                   ;
_l49:   la x14, _l174                             ;
        flw f7, 4(x14)                            ;
_l50:   fmadd.s f30, f22, f20, f23, rup           ;
_l51:   fsgnjx.s f0, f3, f6                       ;
_l52:   fsgnjn.s f2, f7, f22                      ;
_l53:   slliw x10, x5, 31                         ;
_l54:   la x15, d_5_15                            ;
        addi x15, x15, 12                         ;
        amoxor.w x29, x28, (x15)                  ;
_l55:   ebreak                                    ;
_l56:   srliw x21, x21, 7                         ;
_l57:   la x9, d_1_4                              ;
        addi x9, x9, 0                            ;
        amoor.w x26, x29, (x9)                    ;
_l58:   subw x13, x23, x16                        ;
_l59:   divu x24, x15, x2                         ;
_l60:   fmin.s f19, f8, f3                        ;
_l61:   fsgnjn.s f17, f21, f31                    ;
_l62:   remuw x4, x26, x24                        ;
_l63:   la x17, d_4_12                            ;
        addi x17, x17, 0                          ;
        amoadd.d x7, x12, (x17)                   ;
_l64:   la x17, d_4_11                            ;
        lui x3, 0xffe00                           ;
        xor x17, x17, x3                          ;
        lwu x8, 8(x17)                            ;
_l65:   fmadd.s f3, f6, f6, f11, rup              ;
_l66:   la x21, d_4_6                             ;
        addi x21, x21, -4                         ;
        amomin.w x30, x11, (x21)                  ;
_l67:   blt x15, x3, _l151                        ;
_l68:   la x10, d_5_15                            ;
        sh x12, 0(x10)                            ;
_l69:   fsqrt.s f25, f12, dyn                     ;
_l70:   lui x10, 1723                             ;
_l71:   fmadd.s f23, f22, f28, f18, rup           ;
_l72:   sraw x8, x8, x13                          ;
_l73:   fsub.s f5, f10, f18, rup                  ;
_l74:   divu x10, x23, x6                         ;
_l75:   la x28, d_5_4                             ;
        fsw f20, 0(x28)                           ;
_l76:   ori x10, x4, 1621                         ;
_l77:   sllw x19, x21, x8                         ;
_l78:   la x5, d_3_15                             ;
        addi x5, x5, -0                           ;
        sc.d x12, x5, (x5)                        ;
_l79:   srli x0, x20, 8                           ;
_l80:   la x15, d_5_13                            ;
        addi x15, x15, 16                         ;
        lui x20, 0xffe00                          ;
        xor x15, x15, x20                         ;
        amoswap.d x25, x20, (x15)                 ;
_l81:   la x5, d_3_16                             ;
        addi x5, x5, 0                            ;
        amomaxu.d x10, x10, (x5)                  ;
_l82:   la x23, d_1_1                             ;
        lw x18, -0(x23)                           ;
_l83:   srai x22, x3, 49                          ;
_l84:   sltiu x23, x17, 1762                      ;
_l85:   fsgnj.s f21, f14, f18                     ;
_l86:   fmv.w.x f13, x28                          ;
_l87:   la x10, d_5_9                             ;
        addi x10, x10, 0                          ;
        amoxor.d x28, x27, (x10)                  ;
_l88:   addiw x23, x28, -37                       ;
_l89:   la x2, d_5_2                              ;
        lui x22, 0xffe00                          ;
        xor x2, x2, x22                           ;
        lw x4, 28(x2)                             ;
_l90:   fence.i                                   ;
_l91:   xori x5, x1, -0                           ;
_l92:   fle.s x4, f18, f16                        ;
_l93:   la x13, _l40                              ;
        lb x11, 21(x13)                           ;
_l94:   la x30, d_4_21                            ;
        addi x30, x30, 8                          ;
        amoswap.d x15, x7, (x30)                  ;
_l95:   slliw x7, x30, 27                         ;
_l96:   slliw x16, x20, 11                        ;
_l97:   la x12, d_4_18                            ;
        addi x12, x12, 0                          ;
        lui x18, 0xffe00                          ;
        xor x12, x12, x18                         ;
        amoadd.d x22, x18, (x12)                  ;
_l98:   la x16, d_0_25                            ;
        addi x16, x16, 8                          ;
        amoadd.d x9, x30, (x16)                   ;
_l99:   la x24, d_1_18                            ;
        lh x8, 18(x24)                            ;
_l100:  fsqrt.s f2, f13, rmm                      ;
_l101:  csrrwi x1, frm, 18                        ;
_l102:  la x7, d_0_20                             ;
        addi x7, x7, -4                           ;
        amomaxu.w x19, x24, (x7)                  ;
_l103:  la x16, d_1_23                            ;
        ld x4, 0(x16)                             ;
_l104:  ebreak                                    ;
_l105:  la x23, d_4_14                            ;
        addi x23, x23, -0                         ;
        lr.w x28, (x23)                           ;
_l106:  xori x7, x23, 1633                        ;
_l107:  la x24, d_0_4                             ;
        addi x24, x24, 12                         ;
        amomin.w x23, x4, (x24)                   ;
_l108:  la x1, d_5_25                             ;
        lhu x3, 12(x1)                            ;
_l109:  fsgnj.s f25, f2, f27                      ;
_l110:  la x15, d_1_15                            ;
        addi x15, x15, 24                         ;
        amoand.d x10, x9, (x15)                   ;
_l111:  divw x0, x22, x20                         ;
_l112:  fcvt.w.s x16, f3, dyn                     ;
_l113:  xor x8, x8, x8                            ;
        addi x30, zero, 3                         ;
        slli x30, x30, 8                          ;
        add x8, x8, x30                           ;
        addi x23, zero, 1                         ;
        slli x23, x23, 30                         ;
        add x8, x8, x23                           ;
        addi x24, zero, 3                         ;
        slli x24, x24, 24                         ;
        add x8, x8, x24                           ;
        csrrs x23, sie, x8                        ;
_l114:  fsub.s f10, f3, f30, dyn                  ;
_l115:  slliw x28, x30, 31                        ;
_l116:  fmul.s f19, f22, f26, dyn                 ;
_l117:  la x3, d_4_6                              ;
        addi x3, x3, 8                            ;
        amomaxu.w x29, x26, (x3)                  ;
_l118:  ecall                                     ;
_l119:  la x28, d_4_18                            ;
        addi x28, x28, -8                         ;
        amoxor.w x28, x20, (x28)                  ;
_l120:  fsgnjx.s f0, f14, f7                      ;
_l121:  bgeu x24, x28, _l182                      ;
_l122:  fsgnj.s f23, f3, f19                      ;
_l123:  remu x16, x7, x16                         ;
_l124:  la x28, d_0_2                             ;
        lbu x19, 24(x28)                          ;
_l125:  sltiu x11, x11, -9                        ;
_l126:  la x27, d_0_26                            ;
        sd x27, 0(x27)                            ;
_l127:  fmul.s f5, f5, f18, rmm                   ;
_l128:  fcvt.s.wu f1, x1, rdn                     ;
_l129:  xor x1, x1, x1                            ;
        addi x5, zero, 3                          ;
        slli x5, x5, 14                           ;
        add x1, x1, x5                            ;
        csrrw x18, scause, x1                     ;
_l130:  bge x28, x30, _l140                       ;
_l131:  fsqrt.s f3, f15, rdn                      ;
_l132:  la x22, _l27                              ;
        ld x5, -8(x22)                            ;
_l133:  ori x21, x3, -418                         ;
_l134:  la x4, d_0_17                             ;
        srai x4, x4, 1                            ;
        csrrs x12, pmpaddr0, x4                   ;
_l135:  fmul.s f6, f5, f16, rtz                   ;
_l136:  fsgnj.s f11, f23, f30                     ;
_l137:  li x3, 0                                  ;
        la x0, pt2                                ;
        addi x0, x0, 32                           ;
        sfence.vma x3, x0                         ;
_l138:  flt.s x30, f30, f16                       ;
_l139:  mulhsu x2, x4, x26                        ;
_l140:  fdiv.s f20, f24, f21, dyn                 ;
_l141:  la x25, d_1_17                            ;
        addi x25, x25, -28                        ;
        amomax.w x30, x1, (x25)                   ;
_l142:  andi x6, x1, 259                          ;
_l143:  la x11, d_3_21                            ;
        addi x11, x11, -16                        ;
        sc.d x17, x11, (x11)                      ;
_l144:  la x14, d_5_7                             ;
        lbu x25, 27(x14)                          ;
_l145:  fnmsub.s f31, f22, f29, f9, rtz           ;
_l146:  jal x1, _l160                             ;
_l147:  srai x20, x25, 38                         ;
_l148:  fmsub.s f22, f27, f23, f25, rdn           ;
_l149:  fcvt.wu.s x19, f11, rne                   ;
_l150:  srli x2, x17, 16                          ;
_l151:  la x8, d_5_0                              ;
        addi x8, x8, -12                          ;
        amoxor.w x1, x12, (x8)                    ;
_l152:  sltiu x11, x8, -804                       ;
_l153:  bge x19, x20, _l158                       ;
_l154:  la x12, _l176                             ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l155:  slliw x10, x23, 5                         ;
_l156:  mulw x20, x28, x9                         ;
_l157:  subw x28, x13, x21                        ;
_l158:  la x4, d_2_6                              ;
        addi x4, x4, -12                          ;
        amominu.w x1, x5, (x4)                    ;
_l159:  xor x2, x2, x2                            ;
        addi x29, zero, 3                         ;
        slli x29, x29, 28                         ;
        add x2, x2, x29                           ;
        addi x2, zero, 1                          ;
        slli x2, x2, 3                            ;
        add x2, x2, x2                            ;
        csrrs x13, mepc, x2                       ;
_l160:  fcvt.s.lu f17, x19, dyn                   ;
_l161:  addi x8, x23, 1852                        ;
_l162:  la x21, d_3_20                            ;
        flw f18, -24(x21)                         ;
_l163:  addi x5, x26, 0                           ;
_l164:  la x4, d_1_26                             ;
        addi x4, x4, 24                           ;
        amomaxu.d x24, x2, (x4)                   ;
_l165:  remuw x0, x13, x12                        ;
_l166:  fsgnjx.s f22, f27, f23                    ;
_l167:  la x30, d_2_9                             ;
        ld x6, -8(x30)                            ;
_l168:  fclass.s x1, f30                          ;
_l169:  fcvt.lu.s x17, f15, rne                   ;
_l170:  sraiw x13, x30, 2                         ;
_l171:  fcvt.s.lu f25, x11, rtz                   ;
_l172:  ori x17, x17, -157                        ;
_l173:  la x9, d_0_17                             ;
        addi x9, x9, 8                            ;
        lr.w x30, (x9)                            ;
_l174:  subw x4, x7, x2                           ;
_l175:  fadd.s f4, f3, f23, rmm                   ;
_l176:  divw x5, x11, x25                         ;
_l177:  fcvt.l.s x28, f5, rmm                     ;
_l178:  slliw x30, x8, 31                         ;
_l179:  fadd.s f15, f21, f7, rmm                  ;
_l180:  fence.i                                   ;
_l181:  la x24, d_3_15                            ;
        addi x24, x24, -8                         ;
        amomaxu.d x3, x27, (x24)                  ;
_l182:  flt.s x3, f21, f8                         ;
_l183:  ori x22, x18, 329                         ;
_l184:  csrrci x14, mscratch, 17                  ;
_l185:  fsgnjx.s f0, f6, f1                       ;
_l186:  feq.s x26, f5, f16                        ;
_l187:  fle.s x11, f0, f21                        ;
_l188:  fcvt.wu.s x0, f1, rmm                     ;
_l189:  jal x19, _l196                            ;
_l190:  fcvt.lu.s x30, f19, rmm                   ;
_l191:  slli x13, x5, 29                          ;
_l192:  fclass.s x28, f12                         ;
_l193:  feq.s x1, f9, f22                         ;
_l194:  fmsub.s f28, f20, f24, f23, rmm           ;
_l195:  sraw x8, x1, x2                           ;
_l196:  srlw x30, x30, x23                        ;
_l197:  la x28, d_5_16                            ;
        addi x28, x28, 0                          ;
        amoadd.w x9, x23, (x28)                   ;
_l198:  bgeu x29, x20, _l200                      ;
_l199:  fcvt.s.w f0, x20, dyn                     ;
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
                .dword 0x79a880045c1f897d, 0x6321dda53df0674e
                .dword 0xb64711142184f8c9, 0x7e6945b3aa47dcbf
d_0_0:          .dword 0x426ebca39b620117, 0x99f9bb91ca8cef9d
d_0_1:          .dword 0x249d7ead750ddbf2, 0xadc69ebbf52d15b8
d_0_2:          .dword 0xe5b0aadae8c3a6b0, 0x6dbaf0b0847a623f
d_0_3:          .dword 0xe00cc6cbc8fb23f1, 0x981d2a80f02482da
d_0_4:          .dword 0x555cc69d3f9a03a0, 0x0b240345e851b782
d_0_5:          .dword 0xefa22350d57ff135, 0xb5a8b6e11ef733b3
d_0_6:          .dword 0xc1d4863593102fce, 0x2e743688f8edca8f
d_0_7:          .dword 0x280c1879b5c5f401, 0x611e16aadbdd9dcf
d_0_8:          .dword 0x5e334be91e693caf, 0x057ac5fd759a976a
d_0_9:          .dword 0xd66256fef4480557, 0x9c068626d0ca2383
d_0_10:         .dword 0x75a6e867c808abff, 0x84a2a41dc4804896
d_0_11:         .dword 0xe9535967563c8cf6, 0x521160829ba9b961
d_0_12:         .dword 0xde6d6644fd5a3f01, 0xa67b3785e401f870
d_0_13:         .dword 0xc222d8a70e9def55, 0x245e428a6a5612c1
d_0_14:         .dword 0x68b2091185b2d717, 0xf78de5136136d9f6
d_0_15:         .dword 0x1e44e43cd0a7df7b, 0xe615bda29fd30c87
d_0_16:         .dword 0x7c0c35decce24f8e, 0x2d100c46409677f5
d_0_17:         .dword 0xd05133edc1f13845, 0x40976948150b58b8
d_0_18:         .dword 0x2ae90605d0a721fb, 0x0b95f9516ca0ccb3
d_0_19:         .dword 0x0f372a805dfed6ae, 0x71a765fdd7ddef76
d_0_20:         .dword 0x38e69327bc801817, 0x29b5fbf47db0d3a5
d_0_21:         .dword 0x525713a5c8646597, 0x70ec785e14d54547
d_0_22:         .dword 0x81f64292de3445c1, 0x61b378116688a38e
d_0_23:         .dword 0xf96b5bedd341e559, 0xbfe5caa04a28f97d
d_0_24:         .dword 0x55c1ccb8e8d02a0b, 0x7620a7eb015e5baa
d_0_25:         .dword 0x9014e39a6aa83276, 0xb488a3a6b2437b1d
d_0_26:         .dword 0x49f2074bda36f68e, 0xd978766e332953b8
d_0_27:         .dword 0x32bd31485ad769b9, 0x86606d199a1af24c
                .dword 0x883250db586d673e, 0xf2bd095ae2088c1f
                .dword 0x1186e794f65eea16, 0x09d8855070a756cf
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x210f8dc831999bce, 0x3b77c86a839cf9df
                .dword 0xce4f92b1e79b4f92, 0x1d94f156eeba4e7b
d_1_0:          .dword 0x69013c50ed75fce8, 0x608d5282da82d3d7
d_1_1:          .dword 0x51882af7625ecdbd, 0x1a521ed9ac4d00d7
d_1_2:          .dword 0xb0e9a8bb7cf4769f, 0x5bac6f6588953ba9
d_1_3:          .dword 0x070edb3e7e7d02b9, 0xb580bced84aac4a5
d_1_4:          .dword 0x1861c1aca4dbfb1e, 0xb732090ac21826f2
d_1_5:          .dword 0x3017cef0c35087a1, 0x19efcf44f7fa94d2
d_1_6:          .dword 0x44f2de9ecc48b878, 0x6f83456f150c5d6d
d_1_7:          .dword 0x3924e2f1404cf7fb, 0xb5197bf75aa84124
d_1_8:          .dword 0x5561e4a2df88ad65, 0x10c4775c85a8840d
d_1_9:          .dword 0x0cdf3617c82946e5, 0x814f130d45d48817
d_1_10:         .dword 0x52e322bf027dafc1, 0x6fd91875dd43f0f9
d_1_11:         .dword 0x98800c3e45bd4b6b, 0x582fe6ac35ba1e25
d_1_12:         .dword 0x23bd15c239dadf3e, 0xac8886541f078f2d
d_1_13:         .dword 0xf2720bffb45217fd, 0xbd95c2c2c4602eab
d_1_14:         .dword 0x6accebc20f7eed96, 0x2d0e796d218e90f3
d_1_15:         .dword 0xac4344992823a1c6, 0x3f600cb14dfa7b9f
d_1_16:         .dword 0xf4b4ce65e71ca08e, 0xc2cae40dd4b45191
d_1_17:         .dword 0x06699706305fd1ac, 0x55b6df05c5599ade
d_1_18:         .dword 0xad49f6942168589c, 0xf9df664901e5cb9c
d_1_19:         .dword 0xdaae1d216e261032, 0x5a1b25340d4a63b9
d_1_20:         .dword 0xdcec56e688324c7e, 0x37e698ee1f3e087d
d_1_21:         .dword 0x481c96ff7abd95a6, 0x25153747248fc25f
d_1_22:         .dword 0x3411700e38effc60, 0x51e45b34c0c5a4ed
d_1_23:         .dword 0xaa937c739be8fe07, 0x8dc17903bb35e734
d_1_24:         .dword 0x8e0a28fffe0c21e5, 0x809b6c7f314edd2f
d_1_25:         .dword 0x4ae21e0904d0b777, 0xda2c7a48f32503f5
d_1_26:         .dword 0x6dbb9ccde8bef28b, 0x9c2ea79167fb7f76
d_1_27:         .dword 0x35694a6620bfc90e, 0xbe3c3c4db4542261
                .dword 0xcdd4df9f8fa9bc9d, 0x0011bef71c84ce11
                .dword 0x58b01e5c0c5826d1, 0x50ffc4c1ff8eb140
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x205d24c52e93109c, 0x17e455356d9f53e4
                .dword 0xa2b156a04c025747, 0xf5795407b9d2a2c7
d_2_0:          .dword 0x9e489f20868a93b6, 0x8e5a9a0ffb4a04ae
d_2_1:          .dword 0xb14f062417501631, 0x9690bc36b93e565e
d_2_2:          .dword 0x25ed5c9d8bbfc552, 0x10216bd07b8f99f6
d_2_3:          .dword 0x55e8fa58a8550244, 0x377a05c79ccae794
d_2_4:          .dword 0x57a7d122c79a28c3, 0xd15dc32322d0d664
d_2_5:          .dword 0xa8b5eadca8f84339, 0x93c17f8ea5b35958
d_2_6:          .dword 0x5b2e429661d8ba34, 0xae12681b0e23f508
d_2_7:          .dword 0xedd0f15b2b56d565, 0xfa25231b3ea725b9
d_2_8:          .dword 0xc8aa3ec3746d0fe3, 0x5388c5e168f1a90d
d_2_9:          .dword 0x95d62312285eb08a, 0xad68df96b410a1e5
d_2_10:         .dword 0xaa3afeee10abd7aa, 0x6d39985310f1371a
d_2_11:         .dword 0xf170b807e296f0e9, 0x76b95166ca500eef
d_2_12:         .dword 0xe6a8ccd0c953f191, 0xd0bdf4d4182e6a2d
d_2_13:         .dword 0x150cd7b8b011e686, 0xfb96474238598131
d_2_14:         .dword 0x5a2344ad782a6cea, 0x82bd11c3e98d7b35
d_2_15:         .dword 0x5e25524c5044baca, 0xab571afc3bb40893
d_2_16:         .dword 0xc78936b6c38848ba, 0xe61d1078ff3ced42
d_2_17:         .dword 0x2769926bfb4687df, 0xd0e77587b7b43079
d_2_18:         .dword 0x3fda92b38988defe, 0x0470e80c2137f6cf
d_2_19:         .dword 0x36bb130731e7ba50, 0xf47cc8471241fe4a
d_2_20:         .dword 0x0e59e80d38a33b4a, 0x05bd305b9a6e0dd5
d_2_21:         .dword 0xeffdd6f92f7d8819, 0xee2be38349845d80
d_2_22:         .dword 0x21e5d1e2c23d733f, 0xe74cfc9426d0d603
d_2_23:         .dword 0x37bdef55955df701, 0x947f971b13991bb6
d_2_24:         .dword 0x5c079a80647074cc, 0x683c9e5b0d3c9587
d_2_25:         .dword 0x4f00a79bb2ef7160, 0xd0607ae2697ad13d
d_2_26:         .dword 0x392ddfdaf1242e8d, 0xbc2e2aed1967499a
d_2_27:         .dword 0x19ee6bbc008fae6e, 0x88faeeef7efac3c1
                .dword 0x603a683858319149, 0x2ed5e26ebe4c7a3d
                .dword 0xb17795d8908d49cc, 0x31d732788b1fc666
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x48493f7fa173e8a3, 0x65a7cf3dcf888258
                .dword 0xd515cf55989b30c7, 0xe457b91902236bb5
d_3_0:          .dword 0xc88de9320835db2b, 0x9b276d71edc89bfd
d_3_1:          .dword 0xc4b721b627f45c89, 0xe6d875c549f27e49
d_3_2:          .dword 0x3da0efa08cad1c65, 0xb7d3d1859a0a8dea
d_3_3:          .dword 0x9a497209a63ec5df, 0xdf90215e7b77efe3
d_3_4:          .dword 0x308d8c872501e434, 0x6977ba9351f45225
d_3_5:          .dword 0xaa6a8a24e94f29c8, 0x78b0e2c59417c9f5
d_3_6:          .dword 0x2926c34d0373a28b, 0x557bdadd3601af4a
d_3_7:          .dword 0xc79bfb5ddc72af6e, 0x3b02e7a9a0facf9d
d_3_8:          .dword 0x758aa1793d2d20db, 0x6d97c90f2491661e
d_3_9:          .dword 0xd4a5d5bf37694b49, 0x17b7d8fd99e689aa
d_3_10:         .dword 0x903acab5fa330249, 0x8a00d7fd306d9c1b
d_3_11:         .dword 0x8b91a76da385cc82, 0x8e5de42c5ced888d
d_3_12:         .dword 0xf6cfb394c93dfc14, 0xc5bc47ca94c64fdf
d_3_13:         .dword 0x1e1c0680d50b891d, 0x6b0505d12a535db9
d_3_14:         .dword 0x0093ab23934418bd, 0x41862e5595bfb4dd
d_3_15:         .dword 0xac874493c9922e71, 0x97066803e4524b69
d_3_16:         .dword 0xeca739c0ebbc8896, 0x14c189dbe83f5e61
d_3_17:         .dword 0xbc1cd0d83293fffc, 0x63523bc70bbbe80c
d_3_18:         .dword 0xa0074bf4347f5536, 0xa26e142f38dc8e65
d_3_19:         .dword 0xb28b1ca32e0f831b, 0xce3f27cd28425bfd
d_3_20:         .dword 0x95caad5c6abd2a3b, 0xc147d03ad584ba45
d_3_21:         .dword 0xe0aff910a68fa36f, 0x8ec85b83af174076
d_3_22:         .dword 0xd4e25598e676299d, 0x95e44a035a935e94
d_3_23:         .dword 0x25efc2736ab86a94, 0x992fbbc63cdfd58e
d_3_24:         .dword 0x843da52beec8aab4, 0xf85eec45940f4324
d_3_25:         .dword 0xe0bade131dc14a60, 0x3d6b8b2be9faeb5f
d_3_26:         .dword 0xb84ba81cd4451733, 0x851a2c8d8d078327
d_3_27:         .dword 0xe65b79ad1fba7a28, 0x1a159c650ea1b3e7
                .dword 0x31097e4f6e7eddcb, 0x77e76479390656cc
                .dword 0xf976be0833aa80c1, 0x015bc53b67e129f9
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x79cd7c28a0663786, 0xe2bcfa4113d5b711
                .dword 0x4daa2ecaff1a66b7, 0x12478cc5cc9240f8
d_4_0:          .dword 0x33f59b4edd1c1b7d, 0xf4dfbc53658470c6
d_4_1:          .dword 0x39550b34d4dd7a23, 0xe40a0f9390d876a3
d_4_2:          .dword 0xfc6c0a64cb24a966, 0x7f479eb5151114f9
d_4_3:          .dword 0x6973a25b119b3a3f, 0xc959a901ba65fe27
d_4_4:          .dword 0x6312f9eb76f736ca, 0xa493408cb791d1c5
d_4_5:          .dword 0xe2f58874e7ab4859, 0x2594a0bb5d99b5b6
d_4_6:          .dword 0x8b8f61d12402c7fd, 0x78120d114082ae1c
d_4_7:          .dword 0xa234e94859f94e21, 0xab3e219d0fb9d0ae
d_4_8:          .dword 0x736c3cae8d9bedfc, 0x0aa76c582a074196
d_4_9:          .dword 0x153c5f2c4614aee1, 0xb8475aecfc5393b8
d_4_10:         .dword 0x8652588d10dfb020, 0x743221ac551d1396
d_4_11:         .dword 0xb35da593cefbd252, 0x8b7946a23ef8b2e6
d_4_12:         .dword 0xd3093b030a4b69c8, 0xf1ef7c404d25ba32
d_4_13:         .dword 0xcb888812722b5100, 0x8dde23bbb46eee27
d_4_14:         .dword 0x92f7e7018a7b3912, 0x9e7a5960f0b59c72
d_4_15:         .dword 0x33dbc8feae44a02b, 0xf2fbf76bde67bbbe
d_4_16:         .dword 0xebf61653f263f0ca, 0x28dd321e93976f04
d_4_17:         .dword 0x419c45ddaebe470f, 0xd3e605bdd1437dd9
d_4_18:         .dword 0x483cf03da418b22f, 0xe68ecc2be1b44b48
d_4_19:         .dword 0x7fb9529f83e62a24, 0x812624bdbd673c11
d_4_20:         .dword 0xf6a47c30554606a1, 0xaa2b6a84e292e80e
d_4_21:         .dword 0x522046869c8ad054, 0x155b15fe1655b06b
d_4_22:         .dword 0x0c1161759666c2b1, 0x2134607149e710f0
d_4_23:         .dword 0x995a214063a67d9c, 0xf8eb7b3383179dba
d_4_24:         .dword 0x76087f219c302b5e, 0x14f78e5544d2d52d
d_4_25:         .dword 0x6603eb7bdb5d9c4d, 0x21c47f549036185b
d_4_26:         .dword 0x84695315542da020, 0x52982b4eefaffb64
d_4_27:         .dword 0x1ff2b9529229c62a, 0x7c5f31e48a016c2e
                .dword 0x0fd29987322c6951, 0xca75c3368ff2f1ea
                .dword 0xab36da04b0f58a77, 0xe20d0201dde7d6a5
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x19d01737be8ee74f, 0x694f8d01ba45c904
                .dword 0x3eed38cd20b929a4, 0x8b137042296758e9
d_5_0:          .dword 0xed2445c89eba9cf8, 0x168630dac134c2f0
d_5_1:          .dword 0x13dbcf1a5f39534f, 0xc0dbe9e55685543a
d_5_2:          .dword 0x50e3189fdd05f0de, 0x977cc89f3281eb6a
d_5_3:          .dword 0x1fb0c7170c8306ee, 0x6a930b44f88f522f
d_5_4:          .dword 0x1bf8b3d54237e817, 0x31d3066db7fadc37
d_5_5:          .dword 0xffa4fbf303c47403, 0x857a6a3b8e97d0fd
d_5_6:          .dword 0x5ac1095880c9a4ad, 0xe78ba5d33873e20a
d_5_7:          .dword 0xefd2a33e0929ccc5, 0x09761304c2e9fc46
d_5_8:          .dword 0x44b2b92500bb240c, 0x750ac64e9d52905e
d_5_9:          .dword 0x176a969526d475c4, 0x73ad38fb527533f0
d_5_10:         .dword 0x053ad0eca27acf88, 0x30ee67b98dba7944
d_5_11:         .dword 0x6c917266f9fd8f17, 0xebb34ba0cb627968
d_5_12:         .dword 0x8f15cbd45bd481fd, 0x75328a5702891060
d_5_13:         .dword 0x38342aa2d871a2b6, 0xe3a2fe8129df455b
d_5_14:         .dword 0xf161cf53d6e483e6, 0xa538a490994d6429
d_5_15:         .dword 0xee2a6a4041d07ff2, 0xb19ca5ff6c1d383f
d_5_16:         .dword 0x664d1b5031884c73, 0x54fa02f868632c37
d_5_17:         .dword 0xbcdafb31f511723f, 0x752ea41cb869d729
d_5_18:         .dword 0x7c8603eea6ddd95e, 0x02fa1f990ee02b59
d_5_19:         .dword 0xdc44a478aaaa05a1, 0x644aa15c2226fae2
d_5_20:         .dword 0x13407a2ad19696d4, 0x9a7a05bb73be38db
d_5_21:         .dword 0x430a318dc359b286, 0x962be9d557325023
d_5_22:         .dword 0x02b527ae23538c3b, 0x0c703d51c2327d70
d_5_23:         .dword 0x80dee755d269c473, 0x7c5010cdd2ad20a6
d_5_24:         .dword 0x3fa8c15a50aa6cbd, 0x4e6e5833564c0011
d_5_25:         .dword 0xa961b2bc9b2d721f, 0x1cc44988f087416a
d_5_26:         .dword 0xf3784dc745ac9dce, 0xaabdaabc26d178d5
d_5_27:         .dword 0x725b32d45d9ac6df, 0x3fc3720cf2cc63df
                .dword 0xcde0c668243d86c1, 0x9db11bd303b68653
                .dword 0xb519ba9b47a4478e, 0x72fb666398e84f7a
         /* Random data */
_end_data5:
              
 
