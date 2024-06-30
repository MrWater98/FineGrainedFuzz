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
_p0:    xor x12, x12, x12                         ;
        csrrc x14, mstatus, x12                   ;
_p1:    xor x14, x14, x14                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 2                          ;
        add x14, x14, x14                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 26                         ;
        add x14, x14, x12                         ;
        csrrw x11, sscratch, x14                  ;
_p2:    la x13, d_0_19                            ;
        srai x13, x13, 1                          ;
        csrrc x11, pmpaddr1, x13                  ;
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
_s0:    mulhsu x19, x1, x30                       ;
_s1:    remw x3, x17, x4                          ;
_s2:;
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
_l0:    fdiv.s f24, f19, f31, rdn                 ;
_l1:    fadd.s f3, f9, f3, dyn                    ;
_l2:    la x22, d_1_9                             ;
        addi x22, x22, -0                         ;
        amomaxu.d x22, x27, (x22)                 ;
_l3:    fcvt.wu.s x16, f9, dyn                    ;
_l4:    slli x24, x25, 18                         ;
_l5:    jal x11, _l32                                     ;
_l6:    flt.s x30, f26, f26                       ;
_l7:    la x13, d_0_21                            ;
        sw x1, 12(x13)                            ;
_l8:    la x12, d_0_26                            ;
        addi x12, x12, -8                         ;
        lui x23, 0xffe00                          ;
        xor x12, x12, x23                         ;
        amoor.d x23, x23, (x12)                   ;
_l9:    la x16, _l194                                     ;
        lbu x24, 23(x16)                          ;
_l10:   fcvt.w.s x8, f8, rup                      ;
_l11:   fmax.s f9, f21, f29                       ;
_l12:   divuw x11, x29, x24                       ;
_l13:   la x21, d_4_11                            ;
        lbu x4, 31(x21)                           ;
_l14:   fnmsub.s f30, f15, f6, f16, rmm           ;
_l15:   la x12, _l145                                     ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l16:   la x2, d_4_16                             ;
        sb x22, 2(x2)                             ;
_l17:   ebreak                                    ;
_l18:   bltu x16, x11, _l47                               ;
_l19:   srai x22, x9, 22                          ;
_l20:   addi x7, x2, 450                          ;
_l21:   fcvt.s.l f19, x23, rup                    ;
_l22:   addiw x19, x13, 2001                      ;
_l23:   la x3, d_1_2                              ;
        addi x3, x3, 24                           ;
        amomin.w x20, x16, (x3)                   ;
_l24:   remw x9, x20, x24                         ;
_l25:   fsgnjn.s f17, f21, f13                    ;
_l26:   mulhu x14, x22, x12                       ;
_l27:   mulw x28, x16, x29                        ;
_l28:   sraiw x13, x9, 24                         ;
_l29:   fadd.s f24, f3, f11, rmm                  ;
_l30:   auipc x10, 1048575                        ;
_l31:   la x14, d_2_3                             ;
        addi x14, x14, -8                         ;
        amomax.d x18, x22, (x14)                  ;
_l32:   fsgnjx.s f3, f2, f11                      ;
_l33:   la x6, d_1_27                             ;
        addi x6, x6, 8                            ;
        amoor.d x9, x27, (x6)                     ;
_l34:   csrrwi x14, sscratch, 13                  ;
_l35:   fadd.s f20, f28, f8, rdn                  ;
_l36:   la x11, d_2_10                            ;
        lui x14, 0xffe00                          ;
        xor x11, x11, x14                         ;
        lh x27, 14(x11)                           ;
_l37:   addiw x25, x17, -285                      ;
_l38:   fsgnjn.s f18, f13, f5                     ;
_l39:   fsgnjx.s f5, f7, f25                      ;
_l40:   la x18, d_2_27                            ;
        addi x18, x18, 12                         ;
        amomin.w x6, x9, (x18)                    ;
_l41:   fadd.s f18, f8, f26, rmm                  ;
_l42:   fadd.s f5, f18, f8, dyn                   ;
_l43:   la x14, d_4_6                             ;
        lbu x10, -17(x14)                         ;
_l44:   la x23, d_3_22                            ;
        lw x5, 4(x23)                             ;
_l45:   la x16, d_3_23                            ;
        addi x16, x16, -8                         ;
        amomax.d x8, x11, (x16)                   ;
_l46:   xor x8, x8, x8                            ;
        csrrc x11, fflags, x8                     ;
_l47:   la x27, d_3_22                            ;
        addi x27, x27, -8                         ;
        lr.d x26, (x27)                           ;
_l48:   csrrci x19, medeleg, 15                   ;
_l49:   fcvt.s.lu f15, x16, rmm                   ;
_l50:   mul x13, x2, x14                          ;
_l51:   fnmadd.s f22, f23, f22, f0, dyn           ;
_l52:   la x1, d_1_0                              ;
        srai x1, x1, 1                            ;
        csrrc x27, pmpaddr7, x1                   ;
_l53:   la x7, d_1_20                             ;
        addi x7, x7, 0                            ;
        amoxor.w x2, x26, (x7)                    ;
_l54:   la x7, d_1_27                             ;
        lh x6, 6(x7)                              ;
_l55:   fclass.s x21, f9                          ;
_l56:   lui x22, 63659                            ;
_l57:   la x1, _l124                                      ;
        lwu x15, -12(x1)                          ;
_l58:   srliw x14, x13, 31                        ;
_l59:   mulw x3, x2, x17                          ;
_l60:   fmsub.s f5, f15, f20, f15, rup            ;
_l61:   la x23, _l35                                      ;
        flw f6, 8(x23)                            ;
_l62:   fnmsub.s f24, f16, f7, f6, rmm            ;
_l63:   la x4, d_3_16                             ;
        lwu x29, -12(x4)                          ;
_l64:   jal x20, _l186                                    ;
_l65:   srli x7, x11, 47                          ;
_l66:   sraw x20, x12, x27                        ;
_l67:   fmv.x.w x22, f1                           ;
_l68:   fmadd.s f9, f18, f10, f30, rmm            ;
_l69:   mulhu x23, x2, x9                         ;
_l70:   la x21, d_1_3                             ;
        addi x21, x21, -16                        ;
        sc.d x20, x21, (x21)                      ;
_l71:   la x9, d_2_23                             ;
        addi x9, x9, -16                          ;
        amoxor.d x18, x17, (x9)                   ;
_l72:   sraw x8, x5, x28                          ;
_l73:   la x22, d_2_21                            ;
        addi x22, x22, -12                        ;
        amomax.w x14, x5, (x22)                   ;
_l74:   la x9, d_3_14                             ;
        addi x9, x9, 16                           ;
        amomin.d x30, x30, (x9)                   ;
_l75:   la x1, _l96                                       ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l76:   fence.i                                   ;
_l77:   fmsub.s f31, f26, f22, f24, rmm           ;
_l78:   slli x23, x3, 0                           ;
_l79:   fle.s x2, f27, f13                        ;
_l80:   mul x25, x16, x21                         ;
_l81:   la x3, d_4_20                             ;
        addi x3, x3, -24                          ;
        amominu.d x26, x16, (x3)                  ;
_l82:   la x23, d_0_22                            ;
        lbu x6, 22(x23)                           ;
_l83:   blt x8, x1, _l187                         ;
_l84:   remw x13, x24, x15                        ;
_l85:   la x10, d_0_13                            ;
        addi x10, x10, 20                         ;
        amoor.w x20, x1, (x10)                    ;
_l86:   fle.s x1, f3, f26                         ;
_l87:   andi x19, x23, -11                        ;
_l88:   remu x6, x22, x12                         ;
_l89:   andi x18, x15, 2047                       ;
_l90:   sllw x11, x24, x2                         ;
_l91:   slliw x23, x4, 13                         ;
_l92:   la x6, d_2_5                              ;
        addi x6, x6, -24                          ;
        amomax.d x28, x13, (x6)                   ;
_l93:   la x12, _l168                                     ;
        csrrw zero, mepc, x12                     ;
        mret                                      ;
_l94:   la x8, d_2_16                             ;
        addi x8, x8, -4                           ;
        amomaxu.w x25, x19, (x8)                  ;
_l95:   feq.s x13, f28, f12                       ;
_l96:   la x25, d_3_2                             ;
        srai x25, x25, 1                          ;
        csrrc x18, pmpaddr3, x25                  ;
_l97:   la x3, d_0_26                             ;
        addi x3, x3, -28                          ;
        lui x30, 0xffe00                          ;
        xor x3, x3, x30                           ;
        lr.w x20, (x3)                            ;
_l98:   fcvt.l.s x14, f20, rdn                    ;
_l99:   la x19, d_5_5                             ;
        addi x19, x19, 0                          ;
        amoor.d x6, x24, (x19)                    ;
_l100:  fmv.x.w x4, f30                           ;
_l101:  bltu x22, x30, _l169                              ;
_l102:  fnmsub.s f13, f5, f10, f3, rtz            ;
_l103:  la x23, _l183                             ;
        jalr x20, 0(x23)                          ;
_l104:  srai x3, x2, 0                            ;
_l105:  fsub.s f30, f9, f12, rne                  ;
_l106:  la x10, d_1_9                             ;
        ld x17, -16(x10)                          ;
_l107:  la x16, d_0_13                            ;
        addi x16, x16, 4                          ;
        lui x6, 0xffe00                           ;
        xor x16, x16, x6                          ;
        sc.w x27, x6, (x16)                       ;
_l108:  la x28, d_2_7                             ;
        addi x28, x28, 24                         ;
        amoxor.d x18, x27, (x28)                  ;
_l109:  ebreak                                    ;
_l110:  sraw x30, x8, x5                          ;
_l111:  fence                                     ;
_l112:  la x3, d_2_19                             ;
        addi x3, x3, 20                           ;
        amominu.w x7, x15, (x3)                   ;
_l113:  la x15, _l125                             ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l114:  la x18, d_2_13                            ;
        ld x11, 16(x18)                           ;
_l115:  la x8, d_4_19                             ;
        addi x8, x8, 16                           ;
        amomin.d x20, x20, (x8)                   ;
_l116:  la x28, _l163                                     ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l117:  fmv.x.w x13, f25                          ;
_l118:  fcvt.s.wu f3, x5, dyn                     ;
_l119:  srliw x28, x29, 9                         ;
_l120:  la x15, d_0_13                            ;
        addi x15, x15, 0                          ;
        amoswap.d x3, x15, (x15)                  ;
_l121:  la x21, d_0_26                            ;
        addi x21, x21, 0                          ;
        amoor.w x12, x24, (x21)                   ;
_l122:  bge x19, x25, _l185                               ;
_l123:  la x9, d_3_18                             ;
        addi x9, x9, -16                          ;
        amoor.w x11, x5, (x9)                     ;
_l124:  fclass.s x11, f8                          ;
_l125:  la x3, d_1_7                              ;
        addi x3, x3, 16                           ;
        amoxor.w x10, x8, (x3)                    ;
_l126:  la x24, d_4_24                            ;
        addi x24, x24, -0                         ;
        amomin.w x9, x27, (x24)                   ;
_l127:  la x11, d_1_10                            ;
        addi x11, x11, -16                        ;
        amoxor.w x15, x1, (x11)                   ;
_l128:  la x19, d_1_26                            ;
        addi x19, x19, -16                        ;
        amominu.d x20, x12, (x19)                 ;
_l129:  csrrci x15, scause, 10                    ;
_l130:  la x27, _l28                                      ;
        lw x30, 20(x27)                           ;
_l131:  fmv.w.x f13, x17                          ;
_l132:  srli x26, x17, 0                          ;
_l133:  la x18, d_0_13                            ;
        sd x4, -0(x18)                            ;
_l134:  la x20, d_4_26                            ;
        lb x25, -4(x20)                           ;
_l135:  beq x14, x9, _l137                                ;
_l136:  bne x16, x7, _l159                        ;
_l137:  la x28, d_3_2                             ;
        addi x28, x28, -4                         ;
        amomaxu.w x15, x28, (x28)                 ;
_l138:  la x13, d_5_12                            ;
        addi x13, x13, 0                          ;
        amoswap.d x5, x23, (x13)                  ;
_l139:  sltiu x22, x17, 0                         ;
_l140:  la x22, d_1_7                             ;
        srai x22, x22, 1                          ;
        csrrw x14, pmpaddr6, x22                  ;
_l141:  fmadd.s f15, f15, f24, f6, dyn            ;
_l142:  fclass.s x14, f19                         ;
_l143:  la x18, d_5_21                            ;
        addi x18, x18, -0                         ;
        lr.d x18, (x18)                           ;
_l144:  la x26, d_1_25                            ;
        addi x26, x26, 16                         ;
        amomax.d x12, x1, (x26)                   ;
_l145:  fmadd.s f14, f6, f30, f25, rne            ;
_l146:  la x30, d_5_3                             ;
        srai x30, x30, 1                          ;
        csrrw x13, pmpaddr1, x30                  ;
_l147:  beq x26, x19, _l169                               ;
_l148:  la x5, d_2_9                              ;
        addi x5, x5, -12                          ;
        amoadd.w x29, x13, (x5)                   ;
_l149:  la x8, _l154                                      ;
        csrrw zero, uepc, x8                      ;
        uret                                      ;
_l150:  fcvt.s.w f8, x26, rne                     ;
_l151:  la x24, d_0_21                            ;
        addi x24, x24, -0                         ;
        amominu.d x30, x22, (x24)                 ;
_l152:  fdiv.s f20, f6, f29, rtz                  ;
_l153:  la x13, d_5_0                             ;
        addi x13, x13, 8                          ;
        amomin.d x10, x30, (x13)                  ;
_l154:  div x30, x12, x29                         ;
_l155:  remw x30, x12, x26                        ;
_l156:  fcvt.wu.s x30, f4, rdn                    ;
_l157:  la x15, d_5_5                             ;
        sb x4, -30(x15)                           ;
_l158:  fcvt.l.s x2, f19, rup                     ;
_l159:  la x17, d_4_9                             ;
        addi x17, x17, 16                         ;
        lui x11, 0xffe00                          ;
        xor x17, x17, x11                         ;
        amoxor.d x26, x11, (x17)                  ;
_l160:  fcvt.w.s x4, f6, rdn                      ;
_l161:  mulhu x14, x7, x0                         ;
_l162:  fsub.s f23, f26, f26, rdn                 ;
_l163:  la x4, d_5_24                             ;
        addi x4, x4, 0                            ;
        amomin.d x21, x3, (x4)                    ;
_l164:  fcvt.s.lu f28, x10, rne                   ;
_l165:  fnmadd.s f0, f25, f7, f26, rmm            ;
_l166:  la x15, d_0_14                            ;
        flw f23, -0(x15)                          ;
_l167:  blt x4, x11, _l174                                ;
_l168:  la x16, d_0_2                             ;
        lw x16, 24(x16)                           ;
_l169:  andi x4, x4, -954                         ;
_l170:  andi x22, x3, 463                         ;
_l171:  divu x17, x24, x10                        ;
_l172:  bge x10, x4, _l191                                ;
_l173:  la x14, d_3_4                             ;
        addi x14, x14, 8                          ;
        amomaxu.d x18, x20, (x14)                 ;
_l174:  fmax.s f21, f27, f18                      ;
_l175:  feq.s x26, f10, f24                       ;
_l176:  bltu x25, x28, _l177                              ;
_l177:  remu x1, x14, x7                          ;
_l178:  fdiv.s f14, f23, f1, rne                  ;
_l179:  csrrsi x23, sip, 31                       ;
_l180:  la x6, d_3_1                              ;
        addi x6, x6, 16                           ;
        amoswap.d x15, x13, (x6)                  ;
_l181:  la x20, d_1_0                             ;
        addi x20, x20, 20                         ;
        lui x25, 0xffe00                          ;
        xor x20, x20, x25                         ;
        sc.w x21, x25, (x20)                      ;
_l182:  sraiw x29, x11, 25                        ;
_l183:  srlw x9, x14, x19                         ;
_l184:  rem x19, x20, x27                         ;
_l185:  la x25, d_0_17                            ;
        addi x25, x25, 0                          ;
        amomaxu.w x23, x28, (x25)                 ;
_l186:  la x24, d_2_2                             ;
        addi x24, x24, 0                          ;
        amomin.d x28, x11, (x24)                  ;
_l187:  la x3, _l198                                      ;
        csrrw zero, mepc, x3                      ;
        mret                                      ;
_l188:  la x2, d_0_9                              ;
        addi x2, x2, -16                          ;
        amomax.w x25, x2, (x2)                    ;
_l189:  remw x12, x5, x27                         ;
_l190:  la x13, d_4_11                            ;
        lhu x4, 10(x13)                           ;
_l191:  la x11, d_5_20                            ;
        addi x11, x11, -24                        ;
        amoadd.w x29, x24, (x11)                  ;
_l192:  bltu x10, x19, _l193                              ;
_l193:  bne x23, x17, _l197                       ;
_l194:  la x24, _l198                                     ;
        csrrw zero, sepc, x24                     ;
        sret                                      ;
_l195:  xor x28, x28, x28                         ;
        csrrw x4, mscratch, x28                   ;
_l196:  addi x3, x8, 2047                         ;
_l197:  la x8, d_2_26                             ;
        srai x8, x8, 1                            ;
        csrrs x6, pmpaddr6, x8                    ;
_l198:  la x5, _l120                                      ;
        ld x16, 8(x5)                             ;
_l199:  fcvt.w.s x17, f24, rup                    ;
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
                .dword 0x24b94cf27ea86e02, 0x1e3e7d0b6b2aca62
                .dword 0x134f6486727a07e7, 0x7debdb63f744e71f
d_0_0:          .dword 0x8d3d81886a8c6f92, 0x8fdfa62f43942d12
d_0_1:          .dword 0x52d2f3dfb15ae372, 0x74f0645ca8f41ea4
d_0_2:          .dword 0x6fa07face914dcf7, 0x235b037692696503
d_0_3:          .dword 0x4975d63a965ee848, 0x99a7e4cc5ca02d29
d_0_4:          .dword 0x2a77115cbeb58ea8, 0xf7a6c241f0696c7c
d_0_5:          .dword 0x8c911bd06ccf1e1a, 0xa5cdb897ab110aff
d_0_6:          .dword 0x7db411220f30273e, 0x9943c6d32ac966c3
d_0_7:          .dword 0x23ca6a243e1fdac4, 0xe5794bc4b275995e
d_0_8:          .dword 0xb2191153fff44ea8, 0x7061aa4d781d038f
d_0_9:          .dword 0xf67d740da27add7a, 0x9b0c1a8bc5352200
d_0_10:         .dword 0xdd5d7af91aad70da, 0x690bb4a7ef4c2c73
d_0_11:         .dword 0xbebeb4b3dda54174, 0xbfeaa4ccb45d0a1b
d_0_12:         .dword 0x6450d4ed93625fe9, 0xb1e2e003e1de9ea4
d_0_13:         .dword 0x42c827145d21211a, 0xb10781121e00c02e
d_0_14:         .dword 0x874f1dd66bef7ae5, 0x6ce896d82d38ef80
d_0_15:         .dword 0x77cc543e0275ee8d, 0x20ce60071419f9b9
d_0_16:         .dword 0xfa320e02e39da0b8, 0xb9fb8ad4daba8acc
d_0_17:         .dword 0x666ae8427cacd15b, 0xb7064f0e587b4a06
d_0_18:         .dword 0x562a047f9d7d05f0, 0xfaa61a54e806ff1e
d_0_19:         .dword 0x7ce558fde6c8af97, 0xc5215b581dfd3cd0
d_0_20:         .dword 0x3f51f79c93567562, 0x4d2c60273397dc70
d_0_21:         .dword 0xa2f2320819ececd6, 0x96f2720630d9425d
d_0_22:         .dword 0x2f83d31abe1c8da6, 0xd44be3ac0dc7b264
d_0_23:         .dword 0x976bb058c31ebd0b, 0x03f59518ddd57f90
d_0_24:         .dword 0xab7f39c803c225bb, 0xbcb5c72fc04ffd88
d_0_25:         .dword 0xc9124a6135eb6691, 0x490103365fe484df
d_0_26:         .dword 0x345b23ca0d983e06, 0x7522eb772424b978
d_0_27:         .dword 0xd31b33ed2312bd84, 0xae252859b8ade340
                .dword 0x9851a858e27ee48b, 0xe35f3488026b3853
                .dword 0x7081b653e509c647, 0x7d0ec4f1d5351d37
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x60e3683e2433574e, 0x1ba48e7ec444c005
                .dword 0x6785a4a6498f3ec7, 0xedb6d12a3dea322a
d_1_0:          .dword 0x7cb76255140cc44a, 0x6f198f22688f4e3b
d_1_1:          .dword 0x50fe0b3679fde67f, 0xdd697c76524473e4
d_1_2:          .dword 0x969d9322cde5877f, 0x8ada6d827ef73c46
d_1_3:          .dword 0x29d55ddea18fa3a5, 0xdf7bc28281ce6185
d_1_4:          .dword 0x3f40a1ab6f0e9b6a, 0x7a56af95fa604534
d_1_5:          .dword 0x258bc182d1501bc4, 0xdb104347186ecbbf
d_1_6:          .dword 0xfbe587f99d835f6e, 0xe73b25a000abb2cd
d_1_7:          .dword 0xe989d93baa9cc6c4, 0x1643746fbd22c51b
d_1_8:          .dword 0xf8a16d2584c40743, 0xc689c29c0a96ad37
d_1_9:          .dword 0x175012f7cd4782dc, 0x43ecc5add4058ff7
d_1_10:         .dword 0x6eb480e407aa7148, 0x898d188355d38b00
d_1_11:         .dword 0x8a792058f840d18e, 0x2b8f52e93df60742
d_1_12:         .dword 0x59c09b0404efaa17, 0x90b67cb616f32762
d_1_13:         .dword 0xa62b4d45b73a47b9, 0x18936cf79b3570dc
d_1_14:         .dword 0x92baa904b232398b, 0xb8c2b014cba5499c
d_1_15:         .dword 0x180c5ef1384de7f1, 0x667803b3294d9b17
d_1_16:         .dword 0x200878f0b76990a0, 0x0f3b38813f6f6efb
d_1_17:         .dword 0x45b8d16460e30825, 0x4600fde7b5c8e69e
d_1_18:         .dword 0x6ea601fab8ab0133, 0x7f7447ce06571c6b
d_1_19:         .dword 0xb8dddbc9d8c667bb, 0x4a1e56835a7dead6
d_1_20:         .dword 0x9599f8cbbfab1d6a, 0x231d75e4d68a2f8c
d_1_21:         .dword 0x9415775718d015e7, 0x7476ad5a51981bb3
d_1_22:         .dword 0xcf32bf1b62c76f46, 0x163abb11576cb350
d_1_23:         .dword 0xde86461a605364e2, 0x70498763a5e35167
d_1_24:         .dword 0xba82f2078bae8ea0, 0x6cc4e24af069d4b6
d_1_25:         .dword 0xcd2635546c1af415, 0x56d5ffb3ac996842
d_1_26:         .dword 0x084a595a6881fd92, 0x01d21e4d5d7a537d
d_1_27:         .dword 0xd6a0b01ad08661b1, 0x893723b319bac7d3
                .dword 0xb369c6c19171ea9c, 0x2eafa3c5923dc952
                .dword 0x11bac02adcfacae4, 0x53675e458f8007e1
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe5783538859087ea, 0x1e29c93cf286797c
                .dword 0xf82ca8fe09846abc, 0x92a4596131f56352
d_2_0:          .dword 0xbf7583de28079275, 0x3f534139f9b241d8
d_2_1:          .dword 0xadc6a5e5a60f3490, 0x114518de2df96210
d_2_2:          .dword 0x87049571e85028d9, 0xef4cd1143ea08a19
d_2_3:          .dword 0xacac513c31db1457, 0xe37f0c5e0df0f42b
d_2_4:          .dword 0x8a5db841b27a5977, 0x410270b7b9fd9323
d_2_5:          .dword 0xc57ccc99e8af0e86, 0xb6609d4a30ef25e6
d_2_6:          .dword 0x8a677ef21c05bf45, 0x47848bac0c9649af
d_2_7:          .dword 0x47fcbfe5d027e0d8, 0xbc0fa8ed00d231e8
d_2_8:          .dword 0x3fa7ab572084691b, 0x2d388db6004accb3
d_2_9:          .dword 0xd38a59c363a46926, 0x94e0b7550b67702c
d_2_10:         .dword 0xb8a115b47e0e72c8, 0xe1a08ac5b778535b
d_2_11:         .dword 0x849cebc45762e2eb, 0xa40f492bf4c38321
d_2_12:         .dword 0xa898b0dd56bd2e23, 0xc3b1814a1ae5c237
d_2_13:         .dword 0xbe25c80dfbf07fe2, 0xf2770e6f5369c427
d_2_14:         .dword 0xb61dab28f33feb13, 0x86bdfde97459cd38
d_2_15:         .dword 0xe99b1e83878c3d9c, 0xc03f958cec233ba3
d_2_16:         .dword 0x0af3ecf801650174, 0xe34c38b04fd6d826
d_2_17:         .dword 0x8499b93d17adb8d7, 0x75800dcc9b7f37a0
d_2_18:         .dword 0xefc53d75d24a5578, 0xed4306319a8b0876
d_2_19:         .dword 0x6e93e6f2d3ba0694, 0x6cb57ccf07eb839c
d_2_20:         .dword 0xf84a3ce4af7651f8, 0x70c0e4e4cd44b6c9
d_2_21:         .dword 0xc4e28f40d7221dae, 0x30b613f8351a1e9d
d_2_22:         .dword 0xb46562482873ff6a, 0x7065d627e4dd8069
d_2_23:         .dword 0x72d35dc4a000dc35, 0xd84c29a0eca40524
d_2_24:         .dword 0x38610598c09ccb19, 0x57c2ca6c361488ce
d_2_25:         .dword 0xe041582628233161, 0x5204b6383a4cd39f
d_2_26:         .dword 0x7e7d08b2f2263014, 0x372d1863669a44ab
d_2_27:         .dword 0x3092e7dec855e5a6, 0xefd87eef5452e4b5
                .dword 0xa11fd0ff1ed7e5bd, 0x68e9da405dec6ff9
                .dword 0x52ff66aa56c8a092, 0xaa2c1790315f7374
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xbe1b96380f437f61, 0x016dc8cf8663f908
                .dword 0x3cc743a42e7db0d4, 0x46f1e59902f559dc
d_3_0:          .dword 0x3b2681d34f39956f, 0xbe88b25701bc9dc3
d_3_1:          .dword 0xbadbf93382c29b9e, 0x78b66ad0d153dfe4
d_3_2:          .dword 0x6802ca9e272cac58, 0x48c16a275cf840ce
d_3_3:          .dword 0x0d45a3c45b71288a, 0xf5250464d98ddd3c
d_3_4:          .dword 0xb4c791b438fca95f, 0x5277d61a0ffc4747
d_3_5:          .dword 0xdc6d7b7ce105583c, 0x5a3c6797c24286c2
d_3_6:          .dword 0xba1e3008b54ef3ae, 0x3ed33798ff6e7a0a
d_3_7:          .dword 0xef6e0daf80d57013, 0xd5b8136cddd9a0d9
d_3_8:          .dword 0x8788cb07c00410d1, 0x0e25372144ab4ac8
d_3_9:          .dword 0x8a7cb274c30617dd, 0x4ebb29738387c1a4
d_3_10:         .dword 0x3d9520007e9217b6, 0x7ab9a2dcad89ed6a
d_3_11:         .dword 0x001a7f40c8480780, 0x8e179b8c2ec42712
d_3_12:         .dword 0x550f0a46a96879ad, 0x77980189ef0ebc17
d_3_13:         .dword 0x441d627fe31838df, 0x1b5e17c67330baf5
d_3_14:         .dword 0x1b6dff150da88676, 0x840a6f038409176d
d_3_15:         .dword 0x0ff193180cf1c166, 0x45212b4d530ee212
d_3_16:         .dword 0xfbf2ccfb173056ea, 0x9f7ab1ffbfa6f844
d_3_17:         .dword 0x5c998701bf920c27, 0x2880c5bb90384488
d_3_18:         .dword 0x129a601c7377e7a7, 0xe571b6a4820a1bd4
d_3_19:         .dword 0xa076a3e24dffa742, 0xd78ab83984d841ea
d_3_20:         .dword 0x13582c34317b8039, 0xe769f1c8e3c0170a
d_3_21:         .dword 0xdadebc5a6e82663a, 0xc1d20d9a81478fa2
d_3_22:         .dword 0x25b9e9c108abec6f, 0xbf4abe49ee03345b
d_3_23:         .dword 0x375a235976c510cf, 0xda1ff1591b42fbdc
d_3_24:         .dword 0xe687e1b878aaea59, 0x2d35dc73c7e9cb74
d_3_25:         .dword 0xf6bbec1c1616eadb, 0xc8220df7abd894aa
d_3_26:         .dword 0x407b65751c73b9cf, 0xa65e5ad5b49f6df7
d_3_27:         .dword 0x93bf3c097cfe8ea7, 0x0f03184b0e789cec
                .dword 0x357d895b32a90649, 0x92f399f3dd8f5ac9
                .dword 0x0ef758ab0615faf0, 0x00922a15904c5b60
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x6ce671dfc1fb6dba, 0xb7f1d143f08e7e2e
                .dword 0x5ab503d04480113d, 0xec1aaa133ad7811c
d_4_0:          .dword 0x55ba6312409bd04f, 0x75c4d7962661277d
d_4_1:          .dword 0x5a5fb93665af40f9, 0xb79c719b4808a1e5
d_4_2:          .dword 0x5d04d8f91ba71905, 0xc1c3931e8a4ffbfc
d_4_3:          .dword 0x870964a4b89855ec, 0x357431197db993f6
d_4_4:          .dword 0x2ca6f69592ed6b84, 0xc0db262dacc98fcb
d_4_5:          .dword 0x4281e033f90692bd, 0x81e120b2e9a290b2
d_4_6:          .dword 0xafc4c2643e2fe089, 0x074904078bb1c8c9
d_4_7:          .dword 0x2c521f4536eb4dc2, 0x9c60a04ff924b9e8
d_4_8:          .dword 0x08e38df5ef59b443, 0x8c5b68a90788b8df
d_4_9:          .dword 0xa90f872cdf105c3f, 0xa0d8af8116c95576
d_4_10:         .dword 0x8e675cc51d43bd34, 0xe42fed01c0480f3a
d_4_11:         .dword 0x5bcadb32607c611f, 0x50c22ca7779ad9e9
d_4_12:         .dword 0x490117ab5cc64f28, 0x611ab8bb9e8e1907
d_4_13:         .dword 0xd293ea88d84f0068, 0xbde29c2ac5df9549
d_4_14:         .dword 0xd6d31b99d672c21b, 0x77303ddb410dcd6a
d_4_15:         .dword 0x28ff24096b8304d5, 0xc62c10eb2254a9a8
d_4_16:         .dword 0x9c21853b6a4905de, 0x7038b57c28bb9857
d_4_17:         .dword 0x0ca5e54a01bcb31f, 0xed19d0b335dd8eb5
d_4_18:         .dword 0x2b47363da9d975f3, 0x10ef1f2fa7c87a90
d_4_19:         .dword 0x278afeb120430289, 0x98c413f02a48c387
d_4_20:         .dword 0x5764d3ca2f8339f6, 0xd9ff88fba48926c4
d_4_21:         .dword 0x25c1dfadbee9b40d, 0x7764d68c7dec8edc
d_4_22:         .dword 0xd1d1194f48a8a6f2, 0x850d818291989b09
d_4_23:         .dword 0x5cd3a48e543bdc17, 0x974365988cf2a69d
d_4_24:         .dword 0x6853538d84abb1e9, 0x389b7dbab0ffeb1d
d_4_25:         .dword 0x2f797b5aa3743b55, 0xced8edbad2f4dc26
d_4_26:         .dword 0xfd0345fe8736da85, 0x9cad4f9a69e636db
d_4_27:         .dword 0x4b24fe3e4d7631c9, 0xdb91ee262a431363
                .dword 0xd260cb80696a5af9, 0x19ddbbfd75d8f66f
                .dword 0xfda8fa3e5260eca9, 0x18fdf58e8c97c748
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4657bf735c476194, 0x12b4f3a5267ceab8
                .dword 0x009f685bad0f4aa6, 0x7a971e631036e874
d_5_0:          .dword 0x0fa7155d0830cdae, 0xb1896ef1abc906dd
d_5_1:          .dword 0xa195d6d9ca337503, 0xbbbedd297edfa5ae
d_5_2:          .dword 0xf1d2c19f75407562, 0x39455e159e0eb3ec
d_5_3:          .dword 0x0a362023afdc882f, 0xa7aee825e4384295
d_5_4:          .dword 0xa648267cc9c14fb5, 0xea85083dc2abfe31
d_5_5:          .dword 0x2c37730c1cd668f6, 0xbff7359c6b1cd3a0
d_5_6:          .dword 0x7253a4401c57da70, 0x74c0a4b2cd99be05
d_5_7:          .dword 0xabfb68ca54a76e79, 0xaf680cdc4a98c1cc
d_5_8:          .dword 0x899eb1fab75b84b8, 0x4145e949f34465a8
d_5_9:          .dword 0x39e814c9b5ebf7fb, 0x5eec2aa66d0e30e0
d_5_10:         .dword 0x34a7a8824426ecb8, 0x3df6e2ae85b5873a
d_5_11:         .dword 0xfef1947e8605774e, 0xbb6fd761f04b4c8f
d_5_12:         .dword 0x72a36cb30e0bdc1c, 0x26ec05a64d7835bc
d_5_13:         .dword 0x2ddab2f01a7ebd4f, 0x598b69600b9ed47c
d_5_14:         .dword 0xa3851f5d0b81dfa2, 0x16470c74634bdd09
d_5_15:         .dword 0x5d03ad52146dc595, 0x78d7302d01dbf101
d_5_16:         .dword 0x1ddd9ecca8633020, 0x52a60b6e741e1412
d_5_17:         .dword 0x69d808a7700947c0, 0x0a9a8a9e8de354bd
d_5_18:         .dword 0xbff7901783f07d85, 0x44e7d6ba39e08506
d_5_19:         .dword 0x3861e5f7bf857454, 0x0a7a9af99e265bfc
d_5_20:         .dword 0x4c5d23b4db49d029, 0x7581e33320306920
d_5_21:         .dword 0x4907d8d50c7b2dad, 0x8c944d4cea50e36d
d_5_22:         .dword 0xbf4c7ca010e5c41f, 0x4765f44a05bbfaed
d_5_23:         .dword 0xe1241b413e0c2704, 0x293f1357584db686
d_5_24:         .dword 0xc2659245fa57c8fb, 0x968b386bbd630f91
d_5_25:         .dword 0xee69c4f111c3a1da, 0x6ad4e1ac511000f0
d_5_26:         .dword 0x5e879cce52e3f250, 0x19620ca899945bda
d_5_27:         .dword 0xf97f6e7fb656407b, 0x8a3228de89376a88
                .dword 0xf12c73380792b044, 0x625dfa6ee7fbbaba
                .dword 0x5f5070dfc06a757c, 0xf5af8244f55efcb6
         /* Random data */
_end_data5:
              
 
