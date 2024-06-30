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
_p0:    la x12, d_4_12                            ;
        srai x12, x12, 1                          ;
        csrrc x12, pmpaddr1, x12                  ;
_p1:    csrrsi x10, mscratch, 6                   ;
_p2:    csrrsi x11, satp, 20                      ;
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
_s0:    addw x22, x6, x29                         ;
_s1:    csrrwi x25, pmpaddr5, 0                   ;
_s2:    la x29, d_5_21                            ;
        fsw f28, -12(x29)                         ;
_s3:    la x26, d_3_27                            ;
        addi x26, x26, -24                        ;
        amoor.w x28, x7, (x26)                    ;
_s4:    la x6, d_2_0                              ;
        lui x12, 0xffe00                          ;
        xor x6, x6, x12                           ;
        lw x19, 8(x6)                             ;
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
_l0:    la x1, d_2_11                             ;
        lbu x11, -12(x1)                          ;
_l1:    la x29, d_1_17                            ;
        addi x29, x29, 28                         ;
        amoswap.w x14, x12, (x29)                 ;
_l2:    csrrci x22, pmpaddr4, 2                   ;
_l3:    fcvt.s.lu f28, x26, rne                   ;
_l4:    la x1, d_4_12                             ;
        addi x1, x1, 16                           ;
        amoor.d x4, x24, (x1)                     ;
_l5:    remu x16, x23, x22                        ;
_l6:    la x1, d_0_22                             ;
        addi x1, x1, 0                            ;
        amoswap.d x8, x6, (x1)                    ;
_l7:    la x29, _l188                             ;
        lbu x1, 30(x29)                           ;
_l8:    fsgnjx.s f26, f26, f25                    ;
_l9:    csrrsi x4, mepc, 10                       ;
_l10:   remw x10, x12, x24                        ;
_l11:   slti x0, x6, -1285                        ;
_l12:   fcvt.lu.s x17, f25, rne                   ;
_l13:   la x13, d_3_18                            ;
        srai x13, x13, 1                          ;
        csrrw x8, pmpaddr6, x13                   ;
_l14:   la x28, d_1_6                             ;
        lui x13, 0xffe00                          ;
        xor x28, x28, x13                         ;
        sb x7, -24(x28)                           ;
_l15:   csrrwi x8, pmpaddr7, 25                   ;
_l16:   slliw x29, x26, 31                        ;
_l17:   fcvt.s.lu f27, x27, rup                   ;
_l18:   fcvt.s.wu f28, x24, rup                   ;
_l19:   fnmsub.s f24, f23, f10, f8, rne           ;
_l20:   fdiv.s f26, f15, f4, rtz                  ;
_l21:   fcvt.wu.s x23, f10, rdn                   ;
_l22:   div x17, x26, x28                         ;
_l23:   fence.i                                   ;
_l24:   csrrsi x22, pmpaddr1, 31                  ;
_l25:   la x11, d_5_10                            ;
        lwu x5, -8(x11)                           ;
_l26:   la x10, d_5_10                            ;
        addi x10, x10, -8                         ;
        amomin.d x8, x18, (x10)                   ;
_l27:   la x21, d_5_18                            ;
        addi x21, x21, -0                         ;
        amoxor.w x1, x3, (x21)                    ;
_l28:   la x16, d_0_9                             ;
        lui x10, 0xffe00                          ;
        xor x16, x16, x10                         ;
        flw f9, 28(x16)                           ;
_l29:   la x1, d_3_22                             ;
        addi x1, x1, 24                           ;
        amoor.w x30, x6, (x1)                     ;
_l30:   bge x14, x22, _l167                       ;
_l31:   slli x2, x26, 27                          ;
_l32:   divuw x5, x22, x4                         ;
_l33:   subw x6, x17, x3                          ;
_l34:   csrrci x4, pmpaddr7, 0                    ;
_l35:   fadd.s f11, f2, f9, rup                   ;
_l36:   lui x3, 830774                            ;
_l37:   la x30, d_1_14                            ;
        addi x30, x30, 16                         ;
        amoxor.d x20, x27, (x30)                  ;
_l38:   la x3, d_2_19                             ;
        sb x15, 30(x3)                            ;
_l39:   fcvt.s.wu f11, x15, rne                   ;
_l40:   la x12, d_4_23                            ;
        sh x4, -16(x12)                           ;
_l41:   csrrci x1, pmpaddr3, 31                   ;
_l42:   sraw x20, x2, x7                          ;
_l43:   sraw x7, x22, x26                         ;
_l44:   divuw x4, x16, x19                        ;
_l45:   mulhsu x14, x5, x19                       ;
_l46:   csrrsi x14, mcause, 0                     ;
_l47:   la x24, d_4_11                            ;
        addi x24, x24, 8                          ;
        amoxor.d x26, x2, (x24)                   ;
_l48:   slliw x4, x21, 18                         ;
_l49:   bne x1, x3, _l177                         ;
_l50:   feq.s x5, f15, f15                        ;
_l51:   srai x12, x2, 32                          ;
_l52:   la x28, d_0_1                             ;
        addi x28, x28, 16                         ;
        amoxor.d x12, x17, (x28)                  ;
_l53:   fsqrt.s f16, f8, rup                      ;
_l54:   la x17, d_4_17                            ;
        addi x17, x17, -0                         ;
        amoor.w x30, x12, (x17)                   ;
_l55:   la x29, d_4_12                            ;
        addi x29, x29, 0                          ;
        amomax.d x9, x18, (x29)                   ;
_l56:   beq x9, x22, _l136                        ;
_l57:   li x14, 0                                 ;
        la x30, pt1                               ;
        addi x30, x30, 0                          ;
        sfence.vma x14, x30                       ;
_l58:   addi x13, x9, -1046                       ;
_l59:   la x12, d_0_22                            ;
        addi x12, x12, -0                         ;
        sc.d x2, x12, (x12)                       ;
_l60:   addi x1, x22, 1158                        ;
_l61:   fnmadd.s f28, f21, f5, f4, rup            ;
_l62:   la x15, d_2_22                            ;
        addi x15, x15, -0                         ;
        amoadd.d x21, x13, (x15)                  ;
_l63:   bgeu x26, x28, _l171                      ;
_l64:   srlw x10, x17, x11                        ;
_l65:   fcvt.w.s x10, f13, rtz                    ;
_l66:   fence                                     ;
_l67:   la x19, d_4_19                            ;
        addi x19, x19, 24                         ;
        amoadd.w x9, x19, (x19)                   ;
_l68:   slti x29, x25, -17                        ;
_l69:   fdiv.s f2, f13, f10, rmm                  ;
_l70:   xor x6, x6, x6                            ;
        addi x30, zero, 1                         ;
        slli x30, x30, 2                          ;
        add x6, x6, x30                           ;
        addi x20, zero, 3                         ;
        slli x20, x20, 9                          ;
        add x6, x6, x20                           ;
        addi x13, zero, 1                         ;
        slli x13, x13, 21                         ;
        add x6, x6, x13                           ;
        csrrc x8, sip, x6                         ;
_l71:   la x25, d_5_6                             ;
        lw x21, 16(x25)                           ;
_l72:   mulh x8, x14, x10                         ;
_l73:   fence                                     ;
_l74:   divw x30, x14, x30                        ;
_l75:   la x22, d_1_7                             ;
        lhu x24, 2(x22)                           ;
_l76:   sllw x29, x10, x10                        ;
_l77:   fmin.s f23, f30, f7                       ;
_l78:   fcvt.s.l f25, x12, dyn                    ;
_l79:   rem x0, x2, x21                           ;
_l80:   fmsub.s f30, f21, f11, f24, rmm           ;
_l81:   slti x28, x26, -2047                      ;
_l82:   fmv.w.x f10, x22                          ;
_l83:   la x3, d_4_22                             ;
        lbu x22, -31(x3)                          ;
_l84:   fnmsub.s f23, f5, f21, f20, rdn           ;
_l85:   fclass.s x19, f10                         ;
_l86:   la x17, d_2_4                             ;
        addi x17, x17, -0                         ;
        lr.w x1, (x17)                            ;
_l87:   fnmadd.s f28, f3, f12, f14, dyn           ;
_l88:   divw x20, x10, x21                        ;
_l89:   fle.s x26, f9, f4                         ;
_l90:   fence                                     ;
_l91:   fcvt.l.s x28, f8, rne                     ;
_l92:   fnmsub.s f16, f7, f6, f10, rne            ;
_l93:   divu x10, x24, x14                        ;
_l94:   la x28, d_4_7                             ;
        addi x28, x28, -28                        ;
        amoand.w x28, x18, (x28)                  ;
_l95:   la x16, d_0_11                            ;
        addi x16, x16, -8                         ;
        amoswap.d x14, x7, (x16)                  ;
_l96:   fmsub.s f12, f0, f9, f15, rup             ;
_l97:   la x13, d_2_7                             ;
        addi x13, x13, 8                          ;
        amoswap.d x12, x21, (x13)                 ;
_l98:   srlw x15, x1, x3                          ;
_l99:   fcvt.w.s x8, f2, dyn                      ;
_l100:  fmv.x.w x16, f24                          ;
_l101:  beq x7, x11, _l194                        ;
_l102:  la x19, d_5_2                             ;
        addi x19, x19, 24                         ;
        amomax.d x30, x13, (x19)                  ;
_l103:  addiw x4, x23, -1643                      ;
_l104:  remw x14, x25, x1                         ;
_l105:  lui x15, 16                               ;
_l106:  csrrwi x11, mcause, 12                    ;
_l107:  mul x2, x3, x21                           ;
_l108:  la x26, d_5_13                            ;
        addi x26, x26, -4                         ;
        amoxor.w x27, x30, (x26)                  ;
_l109:  la x8, d_4_18                             ;
        addi x8, x8, 28                           ;
        lr.w x27, (x8)                            ;
_l110:  la x5, d_0_19                             ;
        addi x5, x5, 0                            ;
        amomaxu.d x18, x4, (x5)                   ;
_l111:  addw x9, x24, x12                         ;
_l112:  la x14, d_5_27                            ;
        lb x9, -31(x14)                           ;
_l113:  la x28, d_2_17                            ;
        addi x28, x28, -16                        ;
        sc.d x9, x28, (x28)                       ;
_l114:  remw x15, x29, x19                        ;
_l115:  fsgnjn.s f23, f24, f8                     ;
_l116:  divu x6, x9, x1                           ;
_l117:  la x26, _l134                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l118:  fnmadd.s f27, f28, f14, f27, rdn          ;
_l119:  la x2, _l169                              ;
        lwu x7, 12(x2)                            ;
_l120:  la x26, d_0_13                            ;
        addi x26, x26, -8                         ;
        amominu.w x10, x10, (x26)                 ;
_l121:  csrrsi x25, pmpaddr2, 15                  ;
_l122:  csrrwi x28, mtval, 1                      ;
_l123:  la x25, d_4_6                             ;
        lhu x9, 2(x25)                            ;
_l124:  srli x25, x23, 20                         ;
_l125:  srai x24, x26, 63                         ;
_l126:  remu x9, x10, x18                         ;
_l127:  srli x0, x20, 62                          ;
_l128:  la x4, _l161                              ;
        csrrw zero, uepc, x4                      ;
        uret                                      ;
_l129:  la x10, d_5_23                            ;
        addi x10, x10, -8                         ;
        amominu.w x14, x5, (x10)                  ;
_l130:  la x3, d_3_25                             ;
        addi x3, x3, 8                            ;
        amoand.d x24, x26, (x3)                   ;
_l131:  la x30, d_3_19                            ;
        lui x30, 0xffe00                          ;
        xor x30, x30, x30                         ;
        flw f15, 0(x30)                           ;
_l132:  ebreak                                    ;
_l133:  la x13, d_3_24                            ;
        lbu x3, -10(x13)                          ;
_l134:  fcvt.lu.s x27, f27, rdn                   ;
_l135:  fnmadd.s f1, f23, f26, f4, rdn            ;
_l136:  la x23, d_3_13                            ;
        addi x23, x23, -0                         ;
        amomax.w x30, x15, (x23)                  ;
_l137:  la x13, d_4_4                             ;
        addi x13, x13, -0                         ;
        lr.w x26, (x13)                           ;
_l138:  srlw x4, x9, x21                          ;
_l139:  la x30, d_2_7                             ;
        lw x27, -28(x30)                          ;
_l140:  la x16, d_3_5                             ;
        addi x16, x16, 24                         ;
        amoand.d x19, x18, (x16)                  ;
_l141:  fle.s x18, f16, f31                       ;
_l142:  fsgnjx.s f27, f29, f16                    ;
_l143:  bne x29, x17, _l156                       ;
_l144:  subw x16, x25, x5                         ;
_l145:  xori x9, x9, -1111                        ;
_l146:  la x7, d_5_23                             ;
        addi x7, x7, 0                            ;
        lr.d x10, (x7)                            ;
_l147:  flt.s x20, f5, f30                        ;
_l148:  fnmadd.s f21, f29, f13, f31, rup          ;
_l149:  bltu x17, x29, _l181                      ;
_l150:  mulw x30, x17, x19                        ;
_l151:  blt x27, x16, _l154                       ;
_l152:  la x25, d_4_16                            ;
        addi x25, x25, 24                         ;
        amomaxu.d x10, x10, (x25)                 ;
_l153:  la x19, d_1_25                            ;
        lui x24, 0xffe00                          ;
        xor x19, x19, x24                         ;
        lhu x18, 6(x19)                           ;
_l154:  la x14, d_4_25                            ;
        sb x11, 0(x14)                            ;
_l155:  fadd.s f27, f24, f2, rne                  ;
_l156:  fcvt.w.s x23, f10, rmm                    ;
_l157:  xori x7, x22, 284                         ;
_l158:  feq.s x4, f4, f24                         ;
_l159:  fmax.s f28, f20, f1                       ;
_l160:  mulhu x0, x4, x25                         ;
_l161:  slti x12, x6, -1991                       ;
_l162:  fence.i                                   ;
_l163:  la x9, d_3_14                             ;
        addi x9, x9, -8                           ;
        amomax.w x30, x8, (x9)                    ;
_l164:  fsgnjn.s f16, f20, f18                    ;
_l165:  fcvt.s.wu f10, x26, rne                   ;
_l166:  la x12, d_3_22                            ;
        addi x12, x12, -28                        ;
        lr.w x14, (x12)                           ;
_l167:  fcvt.wu.s x10, f23, rne                   ;
_l168:  fmin.s f24, f21, f3                       ;
_l169:  mul x4, x8, x30                           ;
_l170:  la x16, d_4_19                            ;
        sb x23, 0(x16)                            ;
_l171:  srli x27, x0, 51                          ;
_l172:  auipc x9, 782335                          ;
_l173:  csrrci x10, mstatus, 0                    ;
_l174:  srli x11, x7, 13                          ;
_l175:  fcvt.s.l f28, x18, rdn                    ;
_l176:  la x21, d_2_19                            ;
        sh x12, -0(x21)                           ;
_l177:  fnmsub.s f6, f20, f5, f27, rmm            ;
_l178:  bge x30, x18, _l180                       ;
_l179:  la x17, d_2_26                            ;
        ld x4, -8(x17)                            ;
_l180:  fcvt.s.l f19, x23, rdn                    ;
_l181:  la x7, d_4_25                             ;
        addi x7, x7, -20                          ;
        amoxor.w x11, x24, (x7)                   ;
_l182:  la x23, d_1_6                             ;
        addi x23, x23, 0                          ;
        lui x24, 0xffe00                          ;
        xor x23, x23, x24                         ;
        amoor.d x9, x24, (x23)                    ;
_l183:  fmv.w.x f26, x5                           ;
_l184:  xor x27, x27, x27                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 14                         ;
        add x27, x27, x30                         ;
        csrrw x27, mcause, x27                    ;
_l185:  auipc x30, 1048575                        ;
_l186:  ecall                                     ;
_l187:  la x11, d_4_20                            ;
        addi x11, x11, -8                         ;
        amominu.d x22, x24, (x11)                 ;
_l188:  divu x5, x6, x2                           ;
_l189:  slti x23, x8, -1185                       ;
_l190:  la x2, d_3_10                             ;
        srai x2, x2, 1                            ;
        csrrw x2, pmpaddr2, x2                    ;
_l191:  subw x24, x26, x1                         ;
_l192:  la x29, d_3_14                            ;
        srai x29, x29, 1                          ;
        csrrw x12, pmpaddr6, x29                  ;
_l193:  fsub.s f13, f4, f30, rmm                  ;
_l194:  bne x2, x21, _l198                        ;
_l195:  fcvt.lu.s x29, f14, rtz                   ;
_l196:  fmadd.s f26, f5, f6, f21, rdn             ;
_l197:  auipc x16, 593558                         ;
_l198:  li x12, 0                                 ;
        la x5, pt2                                ;
        addi x5, x5, 32                           ;
        sfence.vma x12, x5                        ;
_l199:  mulhu x22, x20, x18                       ;
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
                .dword 0x74f8976f72caaa4e, 0x6d2324f2f4dee0c9
                .dword 0x25a1f19dd8cee0c1, 0xace696bf98ab8d45
d_0_0:          .dword 0x2d66432d203fc9b5, 0xe2757df22d5dd341
d_0_1:          .dword 0xf60e111a9349d1af, 0x533da1cc6717ca88
d_0_2:          .dword 0x1d164bbbaca2339d, 0xbeceef22fc7d24b2
d_0_3:          .dword 0x4ef53d461fc7a693, 0x237a9604369a3e50
d_0_4:          .dword 0x1b51bece9669fefd, 0xe72cf057f9dec1ef
d_0_5:          .dword 0xe33ecd94cff2c5f9, 0xac7be4e40cd70eaa
d_0_6:          .dword 0x13dc7cae0f845fd0, 0x84f2188becfffadf
d_0_7:          .dword 0xed258684156a30b2, 0x96bbb00d38f4a97f
d_0_8:          .dword 0x5d84394e4ae33b4e, 0xc528f5c406823f43
d_0_9:          .dword 0xb2674e1cdb7bd3f9, 0xe67c00d80de69ada
d_0_10:         .dword 0x6d40822d8868e0d1, 0x089ba6614c624656
d_0_11:         .dword 0x98a997d527ab873f, 0xe55f1dfb9c8261c6
d_0_12:         .dword 0x29ad6c2e7f760788, 0xfcecb4760a816583
d_0_13:         .dword 0xf8ad382419d31c52, 0xa4e36655e07aacac
d_0_14:         .dword 0xc390c65b7fa1386c, 0x2db6e3bf449f6650
d_0_15:         .dword 0xb099f99a490775c0, 0x4771b5dd4fda9dbf
d_0_16:         .dword 0xb583642b8c5108bb, 0x0572050a65268e1f
d_0_17:         .dword 0x425aface591b8a84, 0xe79bfa07ae503fd0
d_0_18:         .dword 0x5414e302882b5d3f, 0x8561b2b709df2cc0
d_0_19:         .dword 0x23d820b6a3d2a1a5, 0x9170881adb61b5ff
d_0_20:         .dword 0x1562807edc32b3ff, 0x7119f97d1b2fb693
d_0_21:         .dword 0x65653162595e84ce, 0x7d8c1d1669bdf1d5
d_0_22:         .dword 0xb0a68922a3d79049, 0x1318b56bd231822a
d_0_23:         .dword 0x8e854e28d42e6a42, 0x467dfd59c5eba7e3
d_0_24:         .dword 0x343cf2b9a8e1df53, 0x1b4c796eebc26eff
d_0_25:         .dword 0x4923001366c4245a, 0xf4974e82a34b874c
d_0_26:         .dword 0x1f3cf90c8c730b6f, 0xc4929a3e0c7d6bdc
d_0_27:         .dword 0xccff688cd88922a9, 0x1fa86502bafa099a
                .dword 0x3b195f52135eb7c7, 0x5d9257f3f766fba6
                .dword 0xd60f5a48bf3a8c8d, 0xb39614eef4f423a1
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9af24f391773cfd1, 0xf0a86b18db960e21
                .dword 0x7527762d19bccefe, 0x27c1baa647a9f238
d_1_0:          .dword 0x2a2cf469110ef747, 0x3db52750048db2b3
d_1_1:          .dword 0x461edc1721b4411c, 0x201ca0469a5db0d9
d_1_2:          .dword 0x65c9fe3cdabd56a9, 0x7e074e25f85efd9f
d_1_3:          .dword 0x5d09ff6cc5fe986e, 0x21496d3bef5de0fb
d_1_4:          .dword 0xc1e0ccd9fc6fdd05, 0x4a9abcdd7d531305
d_1_5:          .dword 0xf9e100831f73da5e, 0xc95e95052e4feb79
d_1_6:          .dword 0xe2c55db615721db7, 0x35bacca5b6b86ae7
d_1_7:          .dword 0x66f84481c02b2858, 0x2bc1362814850180
d_1_8:          .dword 0x392e5f1186dc8b89, 0xf2ed9059b0762980
d_1_9:          .dword 0x93e3e981fa1d6f76, 0x325d66e3e1d5cdf9
d_1_10:         .dword 0xb9abb7f2b726101b, 0x228b8588e51909fd
d_1_11:         .dword 0x3e4d9e05a5ae5299, 0xb62850b804bd20e1
d_1_12:         .dword 0x075c1c88868c2dc0, 0x8d8238c12a13ba8f
d_1_13:         .dword 0x21ee333a554409a3, 0xa70e1d35c1849379
d_1_14:         .dword 0xce41452f4d65b8c5, 0x786d910a779ebf40
d_1_15:         .dword 0xe8fe4ccf9cf5cca5, 0xb035c9239f75c9c9
d_1_16:         .dword 0xb8f40ff23c50d693, 0x322074287ed84940
d_1_17:         .dword 0x89fb2190ba8ef9a0, 0x895e878db276ab8f
d_1_18:         .dword 0xd57d1e59294ae663, 0x058bdab14232d087
d_1_19:         .dword 0x7df35f9e991c43cf, 0xdeeb4f9764d55a14
d_1_20:         .dword 0x8a4dc5d88db585a4, 0x5f17897076344f3a
d_1_21:         .dword 0x7936e6f746a7b1c0, 0x427f1c94072aa89b
d_1_22:         .dword 0x705bdf3ace002e34, 0x84f09d219afe8288
d_1_23:         .dword 0x32379e05453cc9d8, 0x4e50b77d861fe939
d_1_24:         .dword 0x14eba8a05f3615e9, 0xbf43aac869dcca6e
d_1_25:         .dword 0x6cf14c1603ca5cf3, 0xf6aae5df9560454f
d_1_26:         .dword 0xce6ba6ca21a97692, 0x095c08cea7031423
d_1_27:         .dword 0x502cccdc061d8d0a, 0x8e7256394187932c
                .dword 0x179833c5d7cbfad4, 0x6308f467e9485c95
                .dword 0xeb99835eb0b369a3, 0x883102f153dbd47b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xaa572a629561bc32, 0xb8dcc0800bb5fdce
                .dword 0x6f9d1b171a0e1d19, 0x108173508d5f9c6d
d_2_0:          .dword 0x3da419a77d384777, 0xddf51046aa692d8a
d_2_1:          .dword 0x24464772c4ac7176, 0xf37fa838a3ec3c04
d_2_2:          .dword 0x2089126e14a1c71f, 0x39db373e0da64887
d_2_3:          .dword 0x17e6f9cd12e0c91e, 0xaeb0a60f51d5356a
d_2_4:          .dword 0x260eb02b2c396ee9, 0xfa556a8ef68479d4
d_2_5:          .dword 0x5552424feaae0162, 0xf6bf351982987c76
d_2_6:          .dword 0x0de104624c4be2b0, 0x909995128e783ff1
d_2_7:          .dword 0x16a5a4c8fdaf0405, 0xdb688e4cb5c5387a
d_2_8:          .dword 0x628b3e37a6295936, 0x903ddb193df4532a
d_2_9:          .dword 0xda92fb100206b26c, 0x60b9e5adc83f14b1
d_2_10:         .dword 0x6083d43a2850b7d0, 0xdfc2fdbe4ddb8220
d_2_11:         .dword 0x4bb8d4f4397eed09, 0x9a3bb265d1b4dae5
d_2_12:         .dword 0x125b50973c240384, 0x23fe1c2c2f9d0214
d_2_13:         .dword 0x78838b16118e185d, 0x7238b0dce77e7ba4
d_2_14:         .dword 0x3aa7d6372aeca757, 0x76854a07ddbb1e3a
d_2_15:         .dword 0x6d49e193e11f50d5, 0xf6607471e4bd9366
d_2_16:         .dword 0x4bdebde49da03a69, 0xcc8c4658675b0255
d_2_17:         .dword 0xa73a9e7f9c5abb52, 0x286ea7cfe0de9a6b
d_2_18:         .dword 0xa0a58fc0487a79f6, 0xd5cc3c439eee2615
d_2_19:         .dword 0xe9f9b2ec638eb43e, 0xb10c1fe82ac40233
d_2_20:         .dword 0xfb0b5ec5c1af0e55, 0x1ab26455c02b7560
d_2_21:         .dword 0x0eaa84a36d399425, 0x7cb263e1ee29de12
d_2_22:         .dword 0x14ea73224175b60a, 0xae4daf3640a92f47
d_2_23:         .dword 0x26186898be500fe1, 0x1d8430b5213d738f
d_2_24:         .dword 0xbe8703da3f12206f, 0x17d2c7ccdc1d922f
d_2_25:         .dword 0x05bec73797816498, 0xe5e58a206b9fe776
d_2_26:         .dword 0x2d0d6ce176b8d80d, 0x528e3e25bb896bd3
d_2_27:         .dword 0x7f5cb385d5688aea, 0x54ba483864ef715e
                .dword 0x4d8262843552ccf1, 0x60ed1537f938891a
                .dword 0xe5a2cf93fea91d23, 0x5672dfbf2dff5f7b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x96056fad854712ef, 0x175a2244457660f7
                .dword 0x11ae29386e1f0399, 0xb7b9efeaefc6d286
d_3_0:          .dword 0x9b83eef881dcc312, 0x03fc74385f170730
d_3_1:          .dword 0x6dae5b85d8bf8664, 0x682fa61a5758a31e
d_3_2:          .dword 0x2a1e6ddc263acd56, 0xe2688e1d43081d04
d_3_3:          .dword 0x7acc5db2056a54f9, 0xbe0131d2f3c801ec
d_3_4:          .dword 0xbc38709b3e9ef8bc, 0x75b8dc33f3a26d08
d_3_5:          .dword 0xd47bd1d6fc7f54f2, 0x58c6bd327d2ec572
d_3_6:          .dword 0xab135be093c06995, 0xd14ef7a624974338
d_3_7:          .dword 0x10954c4ff576776f, 0x743c2a2440720727
d_3_8:          .dword 0xaa7ab2b6df3b7c13, 0x44f4053a72f7786b
d_3_9:          .dword 0x6133a61c4b1e76d6, 0xc539ed974521cbee
d_3_10:         .dword 0xac4cf0a7847ad0fa, 0x7afb1a2ee9e70cb8
d_3_11:         .dword 0x12e53ee0b850eaa6, 0x5ed5b6bb18d70193
d_3_12:         .dword 0x52e6f152303c24c9, 0xc014aa8ff423395a
d_3_13:         .dword 0x1e1b39736ea76b9b, 0xae2ae4644704ea8a
d_3_14:         .dword 0x04df6a719beecd6f, 0xe27801917178d437
d_3_15:         .dword 0xdf17e8fe5cabff4b, 0x6181506ad43405ba
d_3_16:         .dword 0xf6c41a81c37580eb, 0x9b42cf81473fb5c9
d_3_17:         .dword 0x8ee547478b78ef70, 0x1a9f9ff091be1eec
d_3_18:         .dword 0x53d81aa6ba9766dd, 0xc96570cc4a037d77
d_3_19:         .dword 0x7862c65ec7765d72, 0x20c0e95d078a80df
d_3_20:         .dword 0x4dd533b2f7552d0d, 0xb3047c792d42e50e
d_3_21:         .dword 0x32117c50b2fa9d7a, 0xf8ed624d75262040
d_3_22:         .dword 0x29e46561b273cb82, 0x86d19642825a27a5
d_3_23:         .dword 0x0108681929c62bdc, 0x0c42782e3f43ead1
d_3_24:         .dword 0xcdeed23187d7e315, 0x454c0767b8eab23c
d_3_25:         .dword 0xd1fda151e6e1dc26, 0x734a9065546db458
d_3_26:         .dword 0xd2811cfda1b53f54, 0x77e821e0efdd742d
d_3_27:         .dword 0xda3e85c51f3cc9f5, 0xa48ca3ff836e3ea9
                .dword 0x2adde25c4a030431, 0xf4769107e217f989
                .dword 0xce39034b2168796e, 0x377fcd0953368eed
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x63634cf0acc8a056, 0x19f5c332b78261ef
                .dword 0xcf634ecda1142ba1, 0x1cc2a478a6989ec9
d_4_0:          .dword 0x387deea8f9412678, 0xf40ecca8f8826e5a
d_4_1:          .dword 0x9e0a4b5c9d57f185, 0x13bbb6585cec1867
d_4_2:          .dword 0xb8d28830472aa0ed, 0x30ffcfcc5672a1f7
d_4_3:          .dword 0xeb8b6b762a2a362f, 0xcfcb41af5245c55d
d_4_4:          .dword 0x3a528614dfbe3cc7, 0x42cf0551557b223d
d_4_5:          .dword 0x8a2c7f2a638c4d2b, 0x46c2a799820d0801
d_4_6:          .dword 0x174b4df119b48e6c, 0x7b289444326ce780
d_4_7:          .dword 0x9f6735a90c2fe728, 0xc85f423a738f04d7
d_4_8:          .dword 0x400731f72c3c5893, 0x5b9ad004d4ed9c28
d_4_9:          .dword 0x6c026085cc9fdc75, 0xadafeecb3c7ceec4
d_4_10:         .dword 0x4035d8c5a53962d8, 0x06ca0c4e30e34063
d_4_11:         .dword 0x65312560468049ac, 0x0d4743b0024feb99
d_4_12:         .dword 0x4a0c3b877df8d370, 0x6d559fe0a5a48deb
d_4_13:         .dword 0xfb04138578b8d43b, 0x619010cf41ebfcad
d_4_14:         .dword 0xe6f0456e05ea94a8, 0x1e5e066530099dad
d_4_15:         .dword 0xa73700c345b2b299, 0x8191977ab993627c
d_4_16:         .dword 0xd39a400ce16764a2, 0x9b6f18492d7e135a
d_4_17:         .dword 0x3eb4f4794a98eedd, 0x0722d5d56c560f6e
d_4_18:         .dword 0xbc1e1aae49d628eb, 0xb778b3f4a3c8f233
d_4_19:         .dword 0x08957971c532948f, 0x35eb85e294998425
d_4_20:         .dword 0x9c66b0c501a0b57a, 0x5081871eb30aff52
d_4_21:         .dword 0xb7a384e18c81d1ff, 0xb2a4b9d342763b20
d_4_22:         .dword 0xbfb4278286acc323, 0x608189b91f0d4e60
d_4_23:         .dword 0x96616ab0c3777637, 0x22b53ad8aa3952ff
d_4_24:         .dword 0xd68a44335b39b0b4, 0x9bf1e66e3dbd5dd1
d_4_25:         .dword 0x2b541b875f61baf1, 0x19f67f3ad872d55e
d_4_26:         .dword 0xd4f6b0c6f89580ec, 0x83c3b0bd51325635
d_4_27:         .dword 0xd9bcca6f22669337, 0x22356f7c0dd77e05
                .dword 0xb44703ea34704aa5, 0xf9b6cc33c739e9ff
                .dword 0x4d6232af97de2311, 0x82a57290a5cbd5a1
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x58bccf5766607a78, 0xfd510a87f488a9cd
                .dword 0xceaa84c972044d43, 0x03fe3509154b4877
d_5_0:          .dword 0x9269a8e1949100df, 0x28fb77ade9a9df05
d_5_1:          .dword 0x0670acf6285d4216, 0xf01abbcf4b9df9d3
d_5_2:          .dword 0x7eb0079ef0ba4cad, 0x061728f0b8b0f0ed
d_5_3:          .dword 0x82e22888099a90b5, 0xc205180115dd44f6
d_5_4:          .dword 0xb747683bd60f9a34, 0x247c5afa4e9d8346
d_5_5:          .dword 0x7c07eef673a7e046, 0xbf6ed01c4f774214
d_5_6:          .dword 0x044f49ad38c47fe6, 0xe0ca3d23676d7e9b
d_5_7:          .dword 0xfb0cf3c90c2f2eab, 0x2324f00c8e42e5dc
d_5_8:          .dword 0xa39158c267f22969, 0x422782daeb25f8f6
d_5_9:          .dword 0xc60012d06743f74d, 0xe8b8569c8e539a66
d_5_10:         .dword 0x3ddd3863e8b0e9cf, 0xf518bd068f8fd106
d_5_11:         .dword 0x87e1fe266596914f, 0x2592675dd0b056f2
d_5_12:         .dword 0x27a5f253b8cbf10e, 0x51b6c12bac7f47a0
d_5_13:         .dword 0x815651459a57d311, 0x0cb061fc6709f44b
d_5_14:         .dword 0x5f3a818330952e8e, 0x5362633590709800
d_5_15:         .dword 0x5d8b87dc3748e6ca, 0x85b14f68775c2f34
d_5_16:         .dword 0xd7b68c2f40f3958e, 0xf302e918b0c8d0ca
d_5_17:         .dword 0x4f32db806ca98fb2, 0xf9c37ad1cd490023
d_5_18:         .dword 0xf21d0646c544c3ae, 0xe9bcaef721047cf7
d_5_19:         .dword 0x0f4fda5f284e5619, 0x16cc0bd521574f5b
d_5_20:         .dword 0x5277494353b35186, 0xd618ea3007f25d74
d_5_21:         .dword 0x647fde5aec6f4125, 0xe34868a37fe91822
d_5_22:         .dword 0x56b8a094a2fc7681, 0xe92ce7b2a2969342
d_5_23:         .dword 0xf481e0731a197694, 0xb10b4ae28c75dc7b
d_5_24:         .dword 0xcf0f86029caf1de5, 0x0eee69ea212a8f42
d_5_25:         .dword 0x1c8b61142bb1c53e, 0xc8f483ee3206bee3
d_5_26:         .dword 0xc46248f478850492, 0xd7158b55bc1b2030
d_5_27:         .dword 0x2e51bd8ada6a2746, 0x3de0e58ea0682076
                .dword 0xb381e6ea89f012a8, 0x9f648709dd01d103
                .dword 0x78a5f9cdd98b775e, 0x964e09e04b7358aa
         /* Random data */
_end_data5:
              
 
