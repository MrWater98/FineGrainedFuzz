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
_p0:    csrrci x12, mepc, 6                       ;
_p1:    csrrci x14, satp, 13                      ;
_p2:    csrrci x10, sie, 31                       ;
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
_s0:    li x6, 1                                  ;
        la x6, pt2                                ;
        addi x6, x6, 8                            ;
        sfence.vma x6, x6                         ;
_s1:    addiw x17, x4, 1666                       ;
_s2:    srli x17, x1, 60                          ;
_s3:    mul x2, x22, x15                          ;
_s4:;
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
_l0:    la x17, d_2_1                             ;
        addi x17, x17, 24                         ;
        amoadd.w x24, x24, (x17)                  ;
_l1:    srai x14, x27, 1                          ;
_l2:    andi x6, x17, 331                         ;
_l3:    la x11, d_5_22                            ;
        lwu x17, -8(x11)                          ;
_l4:    la x22, d_5_0                             ;
        ld x6, -16(x22)                           ;
_l5:    la x25, d_5_25                            ;
        addi x25, x25, 24                         ;
        amoxor.d x1, x14, (x25)                   ;
_l6:    la x3, d_2_10                             ;
        addi x3, x3, 24                           ;
        amoor.d x18, x4, (x3)                     ;
_l7:    addi x27, x14, -6                         ;
_l8:    la x26, d_4_6                             ;
        addi x26, x26, 16                         ;
        amominu.d x18, x21, (x26)                 ;
_l9:    fdiv.s f9, f8, f20, rup                   ;
_l10:   fle.s x23, f26, f7                        ;
_l11:   la x9, d_2_15                             ;
        addi x9, x9, -24                          ;
        amoxor.d x3, x12, (x9)                    ;
_l12:   la x16, d_2_20                            ;
        addi x16, x16, 16                         ;
        lui x23, 0xffe00                          ;
        xor x16, x16, x23                         ;
        lr.d x26, (x16)                           ;
_l13:   bltu x24, x18, _l182                              ;
_l14:   fmsub.s f19, f23, f23, f26, dyn           ;
_l15:   fnmsub.s f29, f9, f19, f6, dyn            ;
_l16:   mulhsu x9, x30, x27                       ;
_l17:   bge x5, x30, _l26                                 ;
_l18:   xor x9, x9, x9                            ;
        addi x19, zero, 3                         ;
        slli x19, x19, 6                          ;
        add x9, x9, x19                           ;
        addi x21, zero, 3                         ;
        slli x21, x21, 24                         ;
        add x9, x9, x21                           ;
        csrrc x19, fflags, x9                     ;
_l19:   bne x17, x18, _l94                                ;
_l20:   la x10, d_0_13                            ;
        addi x10, x10, 0                          ;
        lr.d x16, (x10)                           ;
_l21:   fcvt.wu.s x13, f19, rup                   ;
_l22:   la x28, d_5_25                            ;
        srai x28, x28, 1                          ;
        csrrc x21, pmpaddr4, x28                  ;
_l23:   auipc x19, 0                              ;
_l24:   xor x22, x22, x22                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 20                         ;
        add x22, x22, x29                         ;
        csrrc x29, sstatus, x22                   ;
_l25:   andi x5, x19, 1314                        ;
_l26:   fence                                     ;
_l27:   bltu x29, x8, _l112                               ;
_l28:   la x31, d_5_24                            ;
        lwu x28, -20(x31)                         ;
_l29:   addi x8, x8, -2047                        ;
_l30:   addiw x28, x13, 1343                      ;
_l31:   la x26, d_1_8                             ;
        addi x26, x26, -8                         ;
        amoadd.d x21, x25, (x26)                  ;
_l32:   remw x8, x23, x16                         ;
_l33:   la x28, _l180                             ;
        csrrw zero, mepc, x28                     ;
        mret                                      ;
_l34:   la x9, d_0_10                             ;
        addi x9, x9, -0                           ;
        amoadd.d x24, x29, (x9)                   ;
_l35:   mulhsu x11, x17, x14                      ;
_l36:   fdiv.s f10, f10, f15, rup                 ;
_l37:   la x8, d_0_20                             ;
        addi x8, x8, 24                           ;
        amoswap.d x5, x24, (x8)                   ;
_l38:   csrrci x21, pmpaddr6, 31                  ;
_l39:   la x14, d_1_12                            ;
        ld x18, 8(x14)                            ;
_l40:   la x27, d_3_14                            ;
        addi x27, x27, 8                          ;
        amoxor.w x23, x19, (x27)                  ;
_l41:   la x26, d_5_8                             ;
        addi x26, x26, -8                         ;
        lui x25, 0xffe00                          ;
        xor x26, x26, x25                         ;
        sc.w x20, x25, (x26)                      ;
_l42:   addiw x8, x12, 386                        ;
_l43:   la x18, d_3_19                            ;
        fsw f9, -12(x18)                          ;
_l44:   mulw x28, x7, x11                         ;
_l45:   la x2, _l46                                       ;
        csrrw zero, sepc, x2                      ;
        sret                                      ;
_l46:   ecall                                     ;
_l47:   mulhu x3, x0, x20                         ;
_l48:   fmul.s f1, f5, f10, rdn                   ;
_l49:   ori x0, x12, -1976                        ;
_l50:   fmadd.s f3, f10, f11, f21, rdn            ;
_l51:   ori x6, x13, 1356                         ;
_l52:   la x21, d_2_17                            ;
        lhu x6, 16(x21)                           ;
_l53:   bge x21, x21, _l141                               ;
_l54:   la x24, d_4_9                             ;
        lw x16, -0(x24)                           ;
_l55:   fmin.s f19, f25, f10                      ;
_l56:   fmsub.s f3, f29, f6, f30, rmm             ;
_l57:   la x11, d_4_15                            ;
        addi x11, x11, -24                        ;
        amomaxu.d x9, x16, (x11)                  ;
_l58:   la x6, d_2_14                             ;
        addi x6, x6, 16                           ;
        lr.d x6, (x6)                             ;
_l59:   la x26, d_5_16                            ;
        addi x26, x26, -8                         ;
        amomaxu.d x4, x30, (x26)                  ;
_l60:   ori x21, x23, 2047                        ;
_l61:   addiw x17, x28, 1181                      ;
_l62:   remu x30, x0, x12                         ;
_l63:   la x2, d_4_19                             ;
        addi x2, x2, 0                            ;
        amoxor.d x19, x3, (x2)                    ;
_l64:   srli x27, x1, 0                           ;
_l65:   la x30, d_0_22                            ;
        sh x13, -24(x30)                          ;
_l66:   srli x23, x8, 63                          ;
_l67:   la x28, _l97                                      ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l68:   srli x9, x6, 32                           ;
_l69:   fsqrt.s f19, f28, rne                     ;
_l70:   jal x10, _l78                             ;
_l71:   fcvt.s.wu f4, x1, rup                     ;
_l72:   divu x11, x3, x16                         ;
_l73:   la x24, d_0_7                             ;
        addi x24, x24, -8                         ;
        amomin.w x11, x5, (x24)                   ;
_l74:   la x19, d_2_0                             ;
        addi x19, x19, 24                         ;
        amoadd.d x18, x30, (x19)                  ;
_l75:   fle.s x22, f26, f20                       ;
_l76:   fence                                     ;
_l77:   csrrsi x18, pmpaddr1, 20                  ;
_l78:   la x21, d_2_8                             ;
        srai x21, x21, 1                          ;
        csrrs x22, pmpaddr6, x21                  ;
_l79:   fmax.s f16, f26, f31                      ;
_l80:   ecall                                     ;
_l81:   addw x10, x25, x13                        ;
_l82:   divu x30, x3, x24                         ;
_l83:   fcvt.lu.s x22, f1, rtz                    ;
_l84:   xori x7, x22, 759                         ;
_l85:   fle.s x21, f20, f7                        ;
_l86:   li x5, 1                                  ;
        la x27, pt1                               ;
        addi x27, x27, 16                         ;
        sfence.vma x5, x27                        ;
_l87:   la x10, d_3_19                            ;
        addi x10, x10, 0                          ;
        amoswap.d x1, x24, (x10)                  ;
_l88:   fmv.w.x f8, x19                           ;
_l89:   la x2, d_1_27                             ;
        sh x14, 10(x2)                            ;
_l90:   fcvt.w.s x22, f8, rmm                     ;
_l91:   la x17, d_0_27                            ;
        addi x17, x17, -12                        ;
        lr.w x25, (x17)                           ;
_l92:   lui x26, 851269                           ;
_l93:   divu x11, x1, x6                          ;
_l94:   slliw x3, x30, 24                         ;
_l95:   la x24, d_5_16                            ;
        addi x24, x24, -24                        ;
        amomin.w x19, x28, (x24)                  ;
_l96:   mulw x18, x19, x9                         ;
_l97:   ecall                                     ;
_l98:   la x22, d_4_7                             ;
        addi x22, x22, 12                         ;
        amominu.w x23, x23, (x22)                 ;
_l99:   la x15, d_3_14                            ;
        addi x15, x15, 8                          ;
        amomaxu.d x26, x3, (x15)                  ;
_l100:  la x10, _l17                              ;
        lwu x13, -24(x10)                         ;
_l101:  la x18, d_0_27                            ;
        ld x13, 16(x18)                           ;
_l102:  la x14, d_5_21                            ;
        lbu x16, -27(x14)                         ;
_l103:  la x24, d_4_26                            ;
        addi x24, x24, 8                          ;
        amoxor.d x14, x18, (x24)                  ;
_l104:  fcvt.s.lu f6, x21, rup                    ;
_l105:  bge x2, x15, _l161                                ;
_l106:  sraiw x1, x22, 20                         ;
_l107:  fcvt.l.s x25, f2, rmm                     ;
_l108:  ebreak                                    ;
_l109:  la x16, d_3_1                             ;
        addi x16, x16, 16                         ;
        amomax.w x26, x3, (x16)                   ;
_l110:  fcvt.s.wu f6, x1, dyn                     ;
_l111:  sraw x22, x3, x11                         ;
_l112:  fnmsub.s f29, f23, f28, f9, rup           ;
_l113:  fmax.s f27, f25, f12                      ;
_l114:  mulhu x19, x16, x19                       ;
_l115:  la x23, d_1_26                            ;
        addi x23, x23, -24                        ;
        amomin.w x10, x18, (x23)                  ;
_l116:  la x7, d_2_3                              ;
        fsw f6, 20(x7)                            ;
_l117:  fclass.s x7, f13                          ;
_l118:  bge x26, x27, _l154                               ;
_l119:  xori x30, x30, -25                        ;
_l120:  la x7, d_2_12                             ;
        addi x7, x7, -0                           ;
        amoor.d x6, x20, (x7)                     ;
_l121:  la x28, d_0_4                             ;
        lwu x21, -24(x28)                         ;
_l122:  remuw x11, x10, x20                       ;
_l123:  auipc x12, 331                            ;
_l124:  fmv.w.x f5, x5                            ;
_l125:  fsgnj.s f18, f17, f25                     ;
_l126:  la x28, d_0_12                            ;
        addi x28, x28, -16                        ;
        amomax.w x5, x11, (x28)                   ;
_l127:  flt.s x7, f21, f21                        ;
_l128:  la x8, d_1_20                             ;
        sw x22, 12(x8)                            ;
_l129:  la x25, d_3_12                            ;
        addi x25, x25, -16                        ;
        lui x4, 0xffe00                           ;
        xor x25, x25, x4                          ;
        amomaxu.d x23, x4, (x25)                  ;
_l130:  la x22, d_3_2                             ;
        addi x22, x22, 20                         ;
        amominu.w x17, x3, (x22)                  ;
_l131:  fle.s x17, f13, f16                       ;
_l132:  la x23, d_1_4                             ;
        addi x23, x23, 8                          ;
        sc.d x25, x23, (x23)                      ;
_l133:  la x1, d_4_15                             ;
        addi x1, x1, 0                            ;
        lr.d x6, (x1)                             ;
_l134:  mulhsu x20, x24, x3                       ;
_l135:  la x14, d_5_27                            ;
        lui x6, 0xffe00                           ;
        xor x14, x14, x6                          ;
        sw x6, 16(x14)                            ;
_l136:  fdiv.s f24, f13, f3, rdn                  ;
_l137:  addiw x5, x13, 0                          ;
_l138:  fmin.s f31, f5, f22                       ;
_l139:  la x5, d_2_0                              ;
        addi x5, x5, 4                            ;
        amomin.w x17, x17, (x5)                   ;
_l140:  fmsub.s f25, f26, f9, f20, rne            ;
_l141:  li x5, 0                                  ;
        la x21, pt2                               ;
        addi x21, x21, 56                         ;
        sfence.vma x5, x21                        ;
_l142:  la x1, d_0_23                             ;
        addi x1, x1, -0                           ;
        amomaxu.w x11, x21, (x1)                  ;
_l143:  csrrci x14, sepc, 14                      ;
_l144:  fsub.s f31, f29, f16, rtz                 ;
_l145:  bge x18, x30, _l162                               ;
_l146:  la x24, d_5_27                            ;
        sw x9, 0(x24)                             ;
_l147:  la x16, _l171                                     ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l148:  la x21, _l26                              ;
        flw f12, -28(x21)                         ;
_l149:  bne x30, x27, _l187                               ;
_l150:  la x7, d_5_1                              ;
        addi x7, x7, 0                            ;
        amoor.w x6, x1, (x7)                      ;
_l151:  li x2, 0                                  ;
        la x16, pt2                               ;
        addi x16, x16, 0                          ;
        sfence.vma x2, x16                        ;
_l152:  div x26, x27, x23                         ;
_l153:  remuw x10, x28, x2                        ;
_l154:  fsgnjx.s f1, f27, f29                     ;
_l155:  fmv.x.w x27, f9                           ;
_l156:  fnmsub.s f9, f30, f9, f12, rmm            ;
_l157:  la x11, d_3_20                            ;
        lbu x17, -13(x11)                         ;
_l158:  jal x17, _l176                                    ;
_l159:  slliw x17, x19, 31                        ;
_l160:  csrrsi x7, pmpaddr4, 27                   ;
_l161:  la x6, d_2_17                             ;
        addi x6, x6, -8                           ;
        amomax.d x10, x19, (x6)                   ;
_l162:  fnmsub.s f16, f1, f24, f0, rmm            ;
_l163:  la x5, d_3_17                             ;
        lui x1, 0xffe00                           ;
        xor x5, x5, x1                            ;
        sh x29, -16(x5)                           ;
_l164:  mul x26, x4, x9                           ;
_l165:  la x19, _l193                                     ;
        csrrw zero, sepc, x19                     ;
        sret                                      ;
_l166:  beq x28, x7, _l183                        ;
_l167:  divw x11, x2, x28                         ;
_l168:  la x10, _l195                                     ;
        lw x13, -0(x10)                           ;
_l169:  fcvt.s.w f23, x0, rne                     ;
_l170:  fcvt.s.lu f6, x24, rup                    ;
_l171:  fadd.s f2, f15, f23, dyn                  ;
_l172:  la x28, _l150                             ;
        lbu x18, 28(x28)                          ;
_l173:  la x21, d_4_10                            ;
        addi x21, x21, 8                          ;
        amoadd.d x26, x15, (x21)                  ;
_l174:  div x25, x12, x27                         ;
_l175:  fle.s x28, f9, f9                         ;
_l176:  ori x12, x19, 500                         ;
_l177:  subw x28, x25, x12                        ;
_l178:  la x11, d_2_4                             ;
        addi x11, x11, 4                          ;
        lr.w x12, (x11)                           ;
_l179:  fnmadd.s f18, f31, f20, f22, rtz          ;
_l180:  beq x4, x4, _l181                                 ;
_l181:  sllw x8, x30, x30                         ;
_l182:  csrrwi x11, sepc, 9                       ;
_l183:  fdiv.s f25, f0, f31, rtz                  ;
_l184:  la x4, d_4_17                             ;
        addi x4, x4, -16                          ;
        lui x14, 0xffe00                          ;
        xor x4, x4, x14                           ;
        amoand.d x27, x14, (x4)                   ;
_l185:  remu x5, x6, x25                          ;
_l186:  la x27, d_2_8                             ;
        addi x27, x27, 12                         ;
        amoor.w x5, x30, (x27)                    ;
_l187:  csrrsi x19, pmpaddr3, 21                  ;
_l188:  fclass.s x10, f17                         ;
_l189:  sltiu x16, x19, -1728                     ;
_l190:  bgeu x1, x8, _l195                                ;
_l191:  blt x29, x18, _l192                               ;
_l192:  fmv.x.w x7, f31                           ;
_l193:  la x9, d_0_16                             ;
        flw f23, 20(x9)                           ;
_l194:  csrrci x10, mhartid, 6                    ;
_l195:  fsgnj.s f26, f8, f22                      ;
_l196:  auipc x2, 307186                          ;
_l197:;
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
                .dword 0x193d625611339129, 0xaeecca1049eff71b
                .dword 0xa23649f14e2793e8, 0xb500913bd189c469
d_0_0:          .dword 0x6de9e51e4822c459, 0xcfb6d1fb759a6280
d_0_1:          .dword 0xd11d3b353f31e688, 0xcae4803f86e8a095
d_0_2:          .dword 0x028fb2aead40e009, 0x40e6d4e243852d7e
d_0_3:          .dword 0xa901d0069ece1dba, 0xcb1fe96e680078d9
d_0_4:          .dword 0x6b55ecb3cd9570b2, 0x033ebc5eacc797a6
d_0_5:          .dword 0x935ec5b983c81ccb, 0x85a28a1696d5152e
d_0_6:          .dword 0x8b918901936c623b, 0x494f1da21d921a48
d_0_7:          .dword 0x60943b3158f45a0c, 0x0df6c72612fa49ed
d_0_8:          .dword 0xe08a2863d85103e4, 0xc5ff58466450015d
d_0_9:          .dword 0xff073a551845fcd1, 0x80ff2168409f1ffd
d_0_10:         .dword 0xe8f1815ce189697e, 0x0090ff0917f1b782
d_0_11:         .dword 0x498200f4bc6d39ba, 0xd91a85e898270008
d_0_12:         .dword 0xc209543686bf0c63, 0x690556d0aff14f1c
d_0_13:         .dword 0x9867bcacde7253d7, 0x67872342dafd5aaf
d_0_14:         .dword 0x82d89ba7e0061ba8, 0x9d919acb2b5b9f49
d_0_15:         .dword 0xe2c60931920a5316, 0xdacec0878b7f1641
d_0_16:         .dword 0x102f477aa337267e, 0x7f9843318f9a8952
d_0_17:         .dword 0x0e6abab69f53f849, 0x61660c1fcaca2f3e
d_0_18:         .dword 0x47234c8a51711dda, 0xd3ae5e407f4f9b36
d_0_19:         .dword 0x0c9eb056a5f8061b, 0xab3b3e89aae58b8a
d_0_20:         .dword 0xaa67ad8d987f4243, 0x15d6c57a6696c7fb
d_0_21:         .dword 0x7a6fafff4ccaee5a, 0xf3b1847a4cb93a1b
d_0_22:         .dword 0x29c6fd9aa2579729, 0x1ab39838fa95f60f
d_0_23:         .dword 0x3d745d71896ad2e8, 0xba6b616d082ef80e
d_0_24:         .dword 0x6857dbfc731ed45f, 0xa4212af742b6fb3a
d_0_25:         .dword 0x0240b792070e046a, 0x24c5ffdf2a0db63a
d_0_26:         .dword 0x5a348993cca67ee7, 0x88103919a4990d71
d_0_27:         .dword 0x67a12476f0548dc6, 0x96c59c03e1909e65
                .dword 0xeb31cf8291611013, 0xff2abffd5079476a
                .dword 0x4dd192cbe2879241, 0x2d8288d8ff7bec9e
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x25f5249bed5598e6, 0x2148b72d53695677
                .dword 0x3ce149797d1ad81b, 0xab9b37c39a9342ab
d_1_0:          .dword 0x7352a63c9b7f67d0, 0xde9764d6156957dd
d_1_1:          .dword 0x7678e96dae517987, 0x2c95784851bb6293
d_1_2:          .dword 0x4495414c51a36a2b, 0xe608db2437d7b0e7
d_1_3:          .dword 0xddf5c3f5240cd8ee, 0x74215f30305f5735
d_1_4:          .dword 0x717e03452366e392, 0x03420283d93e72cf
d_1_5:          .dword 0x4f53305a5f230da9, 0xa18f04e058bba31c
d_1_6:          .dword 0xe085b8e927d06b8d, 0x8f6f447dd4d59d1a
d_1_7:          .dword 0xef62dc2fa8bd10b0, 0x043f11ec92034c3f
d_1_8:          .dword 0xcad19f3768752bbc, 0x09249cf21e774879
d_1_9:          .dword 0x4f5a745fd81de0fc, 0x44b42d2a71b37a32
d_1_10:         .dword 0xd09843f15ddeec4a, 0xf03780acde75d97e
d_1_11:         .dword 0x41f9d3fd9f260c89, 0xbfdf7854e917bcf8
d_1_12:         .dword 0x84fa618d6680e42b, 0xe067ea737880e3ff
d_1_13:         .dword 0x259c3f0e97a99bcc, 0xe3e443a84f15fa3c
d_1_14:         .dword 0xdd0008956a2fafb9, 0x3f40f718cd2c45eb
d_1_15:         .dword 0x6518dacda5a1ecec, 0x8884550ac051360d
d_1_16:         .dword 0x659f87ac0f8fbb37, 0x98f09e5b3807e5a1
d_1_17:         .dword 0x190efaebcc692630, 0x04a703214df17924
d_1_18:         .dword 0x3ba8c41e0fd249c8, 0x16a21f1a369b28da
d_1_19:         .dword 0xafcb0aad16e400fd, 0xc818d141b2b19b28
d_1_20:         .dword 0x1c3dc4b2b459aab4, 0x979d33c36081297f
d_1_21:         .dword 0x8fb6054edb4c8e99, 0xdeb8676b5b7b1106
d_1_22:         .dword 0xb017d0d006b60a03, 0xc1ce6035f8d0f468
d_1_23:         .dword 0x85516c3fca878e33, 0x5cf7f2ccb78ce18d
d_1_24:         .dword 0x7fac2c009f64fc95, 0xda978a1e217f8c0a
d_1_25:         .dword 0xff2da3efe2f19dfa, 0xde60b1afdfe3e8dd
d_1_26:         .dword 0x77c0ab0de4011b0d, 0x90e282f58a1a3283
d_1_27:         .dword 0xd9911296dd6ead51, 0x5fda122d81669c47
                .dword 0xd1fe284a28fb79db, 0x6e43d78fd397fc77
                .dword 0x30803e23ddf0cfba, 0x794b08556398aea1
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd9acf6c4a29735c5, 0x1971e1c3357b0f9b
                .dword 0x3868c6980056acb2, 0xa2344fb064346db8
d_2_0:          .dword 0xc1f8f9ef95c2d717, 0x61399e38cc549962
d_2_1:          .dword 0x6d243ce4862934db, 0xd1873b42690ee85d
d_2_2:          .dword 0xab1370ee77e16b5a, 0xcc058e77c2cbd50f
d_2_3:          .dword 0x07b692149598deb4, 0x5a26a5bcf11fd63b
d_2_4:          .dword 0x132edf23d632cc29, 0x9435f81812c771f4
d_2_5:          .dword 0xcd14ec4ce25a0cb3, 0x112a735c039f267b
d_2_6:          .dword 0x0f1622ed8849b9b8, 0xf2073d6c7458bd33
d_2_7:          .dword 0x8cd70f9cf564d571, 0x675a27949beb3465
d_2_8:          .dword 0x842ba00a500ae01b, 0xa9a5cd745856cb02
d_2_9:          .dword 0xfd11c650712f9a30, 0xd21b901b700958f4
d_2_10:         .dword 0x229ceebfe8aff447, 0xb7456e0d7ae9f66f
d_2_11:         .dword 0x3422e8820cc70807, 0x6e6fce4417c4978e
d_2_12:         .dword 0xb5cc93adc7a777f0, 0x8378eb1d7adcb87c
d_2_13:         .dword 0x036e771be76c0f33, 0x64b287c679be0712
d_2_14:         .dword 0xce578256b6f58d0c, 0xc3367645ee9953b7
d_2_15:         .dword 0x73e49dbbbd4cd85a, 0x7ca596c120b6c8fa
d_2_16:         .dword 0xb7f048f717474ae7, 0xaf94464565402782
d_2_17:         .dword 0xf6fb8e2d9335bf0d, 0x838ce07f29cfbb8f
d_2_18:         .dword 0xa3e7e7223dfef9c6, 0x7cc9b6f2779d8de5
d_2_19:         .dword 0x956d47248d461eaf, 0x11ee120625e7a826
d_2_20:         .dword 0xe95f02ea32874e1c, 0xa5c8cd2cfdc4743b
d_2_21:         .dword 0x6cb3a071a8ecc883, 0x0002e0103e84c40e
d_2_22:         .dword 0x316f5102003e9949, 0xc22e17053d76ccb1
d_2_23:         .dword 0x827c61e114c50c1d, 0x12281fbd75c9ff89
d_2_24:         .dword 0x8d74012965782564, 0xec5a524c72c3f571
d_2_25:         .dword 0x216aaaef4eb07c98, 0x9cdc6fe6523726ac
d_2_26:         .dword 0x194c93008211943d, 0xdbbfd1d3041a4f2d
d_2_27:         .dword 0x07318e9bff0f0283, 0x482d5d15d3820822
                .dword 0xb07fedd3d0030d16, 0x77941fb6c66807a9
                .dword 0x90975b9831c02643, 0xb415ae4d6687f7c1
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x39147d8d937c12ea, 0x5314181fbcd00fb2
                .dword 0xb4725942a2e7e81e, 0x5b65d7fb99b8141e
d_3_0:          .dword 0xc7173ef6c6bbc9b9, 0x35f3216320e8ce65
d_3_1:          .dword 0x0ec24dc9732ca36f, 0x89dc05d1afece164
d_3_2:          .dword 0xafdf403c33e30cdd, 0xa4a044f948147a49
d_3_3:          .dword 0xc6ff9b8ec978025f, 0x72772e61729cfb64
d_3_4:          .dword 0xac1aac4607a71801, 0x9c79d77592caee28
d_3_5:          .dword 0x2bc19fae20667325, 0x2cd1fcfcb0a7bb46
d_3_6:          .dword 0xb61c2778f952c91e, 0x15ebcc061693f89c
d_3_7:          .dword 0x62825f9440186961, 0xac2b4f4dfac090e1
d_3_8:          .dword 0xe9a155118a38f0d8, 0x53e8d793a0e96089
d_3_9:          .dword 0x7f0eea946c04959f, 0x4bdb22a4ad1a3380
d_3_10:         .dword 0x51454edaf6ae972f, 0x94376c073052e2a6
d_3_11:         .dword 0x6589827492c97c30, 0xb7072d27030fb687
d_3_12:         .dword 0xa4c126c2b3bcf0b2, 0x739c3611d4f54ac9
d_3_13:         .dword 0xa9552713dad35613, 0x30cb03ab6c0bc085
d_3_14:         .dword 0x1ea9378180a09c58, 0x22aa305534d7e97a
d_3_15:         .dword 0xee5fd7bbbd13bbc2, 0xcb0aad2dd219a37e
d_3_16:         .dword 0x8c392a4d6f406dec, 0x78fee7b2d274cb32
d_3_17:         .dword 0xfc30092c73f3d0f4, 0x204a18fee4ceb387
d_3_18:         .dword 0x52bc5e45b786ed12, 0xa3e26a1197f4cc4b
d_3_19:         .dword 0x1db2460454334bd6, 0xad83a8a80a43fa04
d_3_20:         .dword 0xdc47a47bf0ad81d1, 0x4cca6f0d38479bac
d_3_21:         .dword 0x97a6860dbf89a3b5, 0x3a8b195c56a809b3
d_3_22:         .dword 0xd5ef2de3f140118e, 0x10eaa9610526002c
d_3_23:         .dword 0x18f9aae39987a0bd, 0x49844d253aca2ef7
d_3_24:         .dword 0x369b70a7dd2546fe, 0x4b675627d57f14f9
d_3_25:         .dword 0x07828339bd9642da, 0x6228f78e27951b91
d_3_26:         .dword 0xdd950b04a0a9f5fc, 0x165babf4e054febf
d_3_27:         .dword 0xdc1fb69f0d59ef02, 0x956b08d66dda3399
                .dword 0x749b29a07636eec9, 0x62fca3302b8a4061
                .dword 0xe0fd5ea6a76088c3, 0x8236e117126f3a3f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x504d06e6e5bb67df, 0xc93f54991c8cc3bc
                .dword 0x64131741601ac462, 0x887e3941a7f962e3
d_4_0:          .dword 0x22110b35cd647e4e, 0x5bd8381479b966fb
d_4_1:          .dword 0x4eedf82ec834f2bb, 0x9155a23042f73fba
d_4_2:          .dword 0x0b4efd3e930ff92b, 0xb3c184214725fdd8
d_4_3:          .dword 0x33e9eabdca2b4850, 0x37250b25fcaa2f2b
d_4_4:          .dword 0xef4b43914bf0128a, 0xca06b6c1323e7aa6
d_4_5:          .dword 0x2ebcbb57f84f3c16, 0x70f3265ce090c54e
d_4_6:          .dword 0x79444c1a0d8a3b47, 0xa7a5241a1e4fd217
d_4_7:          .dword 0xf41a7e865e014c10, 0x5d77e74f58faeba2
d_4_8:          .dword 0x9b295bc8ab0edc77, 0xcee8dfbbc9f98267
d_4_9:          .dword 0x453c5616ae201b22, 0x22b834ca9dd12e14
d_4_10:         .dword 0xfdf889a520ac376e, 0x053112ee66b56ba4
d_4_11:         .dword 0x77a03eb3cf713dfa, 0x9734f72ff64ae4e8
d_4_12:         .dword 0xf820d4a474bee0f4, 0x913e2c3ca09d8558
d_4_13:         .dword 0xfe39b926a7443746, 0x3fb9b9cd71112f3a
d_4_14:         .dword 0xa470ecec02141a08, 0xfc50e5c19d3022e5
d_4_15:         .dword 0x61459d899018fc01, 0xc0e7f5ea04ac0120
d_4_16:         .dword 0xca968799254810fd, 0xaede98b66c6ed156
d_4_17:         .dword 0x3ad49de916c7534d, 0xd38cd88fb8a28eb6
d_4_18:         .dword 0xf1b4c0c5ab81ddd0, 0x8b1cb8e774db51bd
d_4_19:         .dword 0x9469a2cd77e12243, 0x1098fcb581bd5fcd
d_4_20:         .dword 0xfcace91016c244b2, 0xd6ae4e4a4b841ff0
d_4_21:         .dword 0xb2fa060614ffe6ac, 0x917c63ac47786a6a
d_4_22:         .dword 0x87827a8b40e3a81b, 0x6a94e3ca251b0bfa
d_4_23:         .dword 0x3dd10a2b0fbfa895, 0xe4a01628f26a18c5
d_4_24:         .dword 0xb47cd129072bcb61, 0x85c51870cebf7d1e
d_4_25:         .dword 0xd909e61e2700c735, 0xb7e9449976bdf805
d_4_26:         .dword 0x1c499d76142c0df0, 0x43963c7d41bdc9ba
d_4_27:         .dword 0x8be9e1f6e6f96dd2, 0x78af76603ca02b14
                .dword 0xc62dd5d9d973afbc, 0x312fcd5585f0b9c3
                .dword 0xebb3b716c1ea14f2, 0xbae11cf8c7b3d19d
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x2071617d95b57845, 0x50ac60ebb4e9daba
                .dword 0x58a9f91260ed14f1, 0xc14a3dc5c2e77d59
d_5_0:          .dword 0x39525405e84489d8, 0x710f9a101f053f72
d_5_1:          .dword 0xf8ba8c081c8056b3, 0x9b8e5e933eef88d4
d_5_2:          .dword 0xd3654d1d0aa988dc, 0x816dc9c8eb455a44
d_5_3:          .dword 0xfdc176946eb8788e, 0xee46d95a9107c4a8
d_5_4:          .dword 0xaf677c2a246ec2ca, 0xe8b4c31c027e81d4
d_5_5:          .dword 0xad212a04f5b35ca6, 0xe6a851d190426807
d_5_6:          .dword 0x107bbe752b911a79, 0x3797ca910aa6d79a
d_5_7:          .dword 0x6dd5caa16305259c, 0x62aa80d833b005ad
d_5_8:          .dword 0xb6f195b7b631b82b, 0x1c632392a8493bcd
d_5_9:          .dword 0x46c59326c4ab9c04, 0x478ef44fb2a10a3e
d_5_10:         .dword 0x05b46b72e9fb0f3e, 0x0b4ca6cc23049957
d_5_11:         .dword 0x47759e541c6ac8d4, 0x7cdd9fa8c1579685
d_5_12:         .dword 0x5348c2ad40ce5938, 0xf7e2087fec883569
d_5_13:         .dword 0x35af37f571a2da19, 0xebb7720fbf010666
d_5_14:         .dword 0xf00f977e6702fe01, 0xe9b5d97d5d5ecd76
d_5_15:         .dword 0x6c172d98ff511f13, 0x8c6be6a1a621bc5f
d_5_16:         .dword 0x4c8b7195cba69206, 0x963763da21423eed
d_5_17:         .dword 0x33dde6ec1b333976, 0x91d38bcbe43babae
d_5_18:         .dword 0x38398e78c5af9743, 0xfa5f84a6e6dc17f0
d_5_19:         .dword 0x6c264e9608ffa270, 0x3d308b0683c7b1c4
d_5_20:         .dword 0x51e52a524c051d7e, 0x477d29d3d3975b37
d_5_21:         .dword 0xc8ef0086aab433a4, 0xf952ae4b0a7e0c90
d_5_22:         .dword 0xf177819b8c76f8af, 0x23cc105f24a42ade
d_5_23:         .dword 0xfa1a3a116a3caaef, 0xd86b7f66ed636676
d_5_24:         .dword 0x476ed9e773c7dd95, 0xe3f5391cb10de00f
d_5_25:         .dword 0x5b0f92b95548343b, 0x94bf3dabea52fb4e
d_5_26:         .dword 0x31a4b934a6462251, 0xccfd194952f4ce3f
d_5_27:         .dword 0x957443bff9cfa139, 0xc8245f13721a8fe3
                .dword 0xf55f0ce5ed67ff46, 0x181136ac5bed50b8
                .dword 0x544989c4298e274c, 0x305ea249e196a8d6
         /* Random data */
_end_data5:
              
 
