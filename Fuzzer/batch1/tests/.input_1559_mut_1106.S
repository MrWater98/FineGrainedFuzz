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
_p0:    xor x10, x10, x10                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 2                          ;
        add x10, x10, x11                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 1                          ;
        add x10, x10, x14                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 7                          ;
        add x10, x10, x10                         ;
        csrrs x11, mip, x10                       ;
_p1:    xor x10, x10, x10                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 21                         ;
        add x10, x10, x12                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 11                         ;
        add x10, x10, x11                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 5                          ;
        add x10, x10, x12                         ;
        csrrs x12, stval, x10                     ;
_p2:    csrrci x10, satp, 31                      ;
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
_s0:    csrrwi x22, pmpaddr1, 19                  ;
_s1:    la x12, d_1_19                            ;
        addi x12, x12, -0                         ;
        amominu.w x11, x18, (x12)                 ;
_s2:    fmul.s f30, f8, f30, rmm                  ;
_s3:    la x26, d_5_17                            ;
        addi x26, x26, 8                          ;
        amoswap.d x6, x3, (x26)                   ;
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
_l0:    slli x20, x13, 15                         ;
_l1:    divuw x27, x28, x16                       ;
_l2:    la x4, d_1_5                              ;
        addi x4, x4, -16                          ;
        amoor.w x10, x2, (x4)                     ;
_l3:    la x9, d_1_13                             ;
        sh x27, -0(x9)                            ;
_l4:    mulh x24, x4, x21                         ;
_l5:    la x6, d_5_13                             ;
        addi x6, x6, -0                           ;
        amoadd.d x25, x20, (x6)                   ;
_l6:    la x27, d_5_14                            ;
        sh x19, -6(x27)                           ;
_l7:    mulhu x5, x9, x28                         ;
_l8:    fcvt.wu.s x9, f6, rup                     ;
_l9:    la x28, d_4_18                            ;
        addi x28, x28, -24                        ;
        amoswap.w x6, x3, (x28)                   ;
_l10:   jal x9, _l29                                      ;
_l11:   la x7, d_3_3                              ;
        sb x11, -0(x7)                            ;
_l12:   fcvt.l.s x24, f10, rup                    ;
_l13:   fmsub.s f25, f19, f13, f31, rup           ;
_l14:   xor x7, x7, x7                            ;
        addi x21, zero, 3                         ;
        slli x21, x21, 0                          ;
        add x7, x7, x21                           ;
        addi x21, zero, 1                         ;
        slli x21, x21, 20                         ;
        add x7, x7, x21                           ;
        csrrw x25, fcsr, x7                       ;
_l15:   lui x22, 478584                           ;
_l16:   la x15, d_1_27                            ;
        sh x14, -30(x15)                          ;
_l17:   srliw x30, x6, 27                         ;
_l18:   la x20, d_5_13                            ;
        addi x20, x20, 4                          ;
        amoadd.w x20, x13, (x20)                  ;
_l19:   sltiu x21, x5, 1509                       ;
_l20:   la x12, d_0_22                            ;
        lwu x9, -12(x12)                          ;
_l21:   fnmsub.s f2, f22, f7, f2, rne             ;
_l22:   mul x19, x8, x2                           ;
_l23:   xor x9, x9, x9                            ;
        addi x14, zero, 1                         ;
        slli x14, x14, 10                         ;
        add x9, x9, x14                           ;
        csrrc x9, mie, x9                         ;
_l24:   auipc x27, 564388                         ;
_l25:   fence.i                                   ;
_l26:   fadd.s f0, f10, f3, rmm                   ;
_l27:   fsgnj.s f31, f2, f6                       ;
_l28:   la x23, _l102                                     ;
        csrrw zero, uepc, x23                     ;
        uret                                      ;
_l29:   andi x9, x3, 0                            ;
_l30:   la x27, d_2_15                            ;
        flw f2, -12(x27)                          ;
_l31:   fcvt.w.s x24, f11, rtz                    ;
_l32:   la x23, _l120                                     ;
        lh x6, -0(x23)                            ;
_l33:   csrrsi x20, fcsr, 22                      ;
_l34:   la x3, d_5_17                             ;
        addi x3, x3, 8                            ;
        amoor.d x29, x24, (x3)                    ;
_l35:   jal x20, _l161                                    ;
_l36:   la x8, d_0_4                              ;
        addi x8, x8, 12                           ;
        amoand.w x9, x9, (x8)                     ;
_l37:   la x20, d_3_20                            ;
        addi x20, x20, -0                         ;
        amomaxu.d x5, x11, (x20)                  ;
_l38:   lui x19, 1048575                          ;
_l39:   fence.i                                   ;
_l40:   fclass.s x30, f15                         ;
_l41:   div x17, x6, x1                           ;
_l42:   fsub.s f18, f16, f12, rne                 ;
_l43:   bltu x30, x25, _l128                              ;
_l44:   la x1, d_0_3                              ;
        sb x25, -23(x1)                           ;
_l45:   la x30, d_4_10                            ;
        lwu x25, 20(x30)                          ;
_l46:   sltiu x13, x20, 2047                      ;
_l47:   fcvt.lu.s x4, f1, rmm                     ;
_l48:   la x31, d_4_10                            ;
        addi x31, x31, 8                          ;
        lr.d x1, (x31)                            ;
_l49:   divu x27, x27, x2                         ;
_l50:   la x13, d_2_23                            ;
        addi x13, x13, -16                        ;
        amoadd.d x25, x5, (x13)                   ;
_l51:   sraiw x10, x18, 23                        ;
_l52:   la x13, d_4_24                            ;
        addi x13, x13, 16                         ;
        amomax.d x5, x28, (x13)                   ;
_l53:   la x7, d_3_17                             ;
        addi x7, x7, 16                           ;
        sc.d x18, x7, (x7)                        ;
_l54:   la x4, d_4_15                             ;
        addi x4, x4, 12                           ;
        amoor.w x6, x26, (x4)                     ;
_l55:   slli x15, x10, 63                         ;
_l56:   remuw x29, x18, x16                       ;
_l57:   fclass.s x13, f18                         ;
_l58:   la x25, d_4_21                            ;
        addi x25, x25, 16                         ;
        amomaxu.w x4, x14, (x25)                  ;
_l59:   la x15, d_1_16                            ;
        addi x15, x15, 0                          ;
        amoand.w x17, x9, (x15)                   ;
_l60:   fcvt.w.s x24, f18, rdn                    ;
_l61:   bltu x14, x22, _l139                              ;
_l62:   srai x5, x21, 43                          ;
_l63:   la x12, _l120                             ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_l64:   remu x5, x7, x19                          ;
_l65:   xor x27, x27, x27                         ;
        addi x4, zero, 3                          ;
        slli x4, x4, 14                           ;
        add x27, x27, x4                          ;
        addi x1, zero, 3                          ;
        slli x1, x1, 22                           ;
        add x27, x27, x1                          ;
        csrrs x18, mepc, x27                      ;
_l66:   remuw x23, x7, x29                        ;
_l67:   la x2, d_4_14                             ;
        addi x2, x2, 0                            ;
        amomaxu.w x27, x17, (x2)                  ;
_l68:   addw x2, x9, x21                          ;
_l69:   fcvt.s.w f15, x11, rtz                    ;
_l70:   fsub.s f2, f19, f23, rdn                  ;
_l71:   fmv.w.x f4, x6                            ;
_l72:   la x2, d_2_22                             ;
        addi x2, x2, -8                           ;
        lui x2, 0xffe00                           ;
        xor x2, x2, x2                            ;
        amomin.d x23, x2, (x2)                    ;
_l73:   sraw x21, x16, x25                        ;
_l74:   la x26, d_4_13                            ;
        addi x26, x26, 16                         ;
        lr.d x15, (x26)                           ;
_l75:   feq.s x1, f18, f26                        ;
_l76:   la x16, d_0_8                             ;
        addi x16, x16, 8                          ;
        lr.d x21, (x16)                           ;
_l77:   addiw x2, x27, 1398                       ;
_l78:   fmv.x.w x17, f18                          ;
_l79:   xor x26, x26, x26                         ;
        csrrw x8, fcsr, x26                       ;
_l80:   divu x10, x22, x29                        ;
_l81:   la x18, d_4_13                            ;
        sd x23, -0(x18)                           ;
_l82:   fmsub.s f28, f2, f24, f3, rtz             ;
_l83:   la x19, d_5_14                            ;
        addi x19, x19, 4                          ;
        amoswap.w x23, x25, (x19)                 ;
_l84:   fmadd.s f7, f10, f30, f3, rne             ;
_l85:   sraw x26, x16, x3                         ;
_l86:   la x20, _l174                                     ;
        csrrw zero, sepc, x20                     ;
        sret                                      ;
_l87:   ebreak                                    ;
_l88:   fdiv.s f20, f24, f1, rne                  ;
_l89:   srlw x8, x13, x12                         ;
_l90:   fence                                     ;
_l91:   addi x18, x25, -0                         ;
_l92:   addw x27, x10, x27                        ;
_l93:   sltiu x7, x15, 1070                       ;
_l94:   bltu x20, x12, _l182                              ;
_l95:   la x10, d_5_24                            ;
        addi x10, x10, 8                          ;
        amomaxu.w x23, x1, (x10)                  ;
_l96:   la x20, _l110                                     ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l97:   fmul.s f20, f23, f5, rup                  ;
_l98:   srlw x4, x28, x1                          ;
_l99:   la x20, _l175                                     ;
        lbu x20, -1(x20)                          ;
_l100:  srai x30, x22, 15                         ;
_l101:  la x6, d_0_21                             ;
        addi x6, x6, -8                           ;
        lr.d x21, (x6)                            ;
_l102:  fmv.x.w x22, f10                          ;
_l103:  fcvt.s.l f4, x17, rmm                     ;
_l104:  fnmsub.s f0, f5, f4, f6, rne              ;
_l105:  la x3, d_3_2                              ;
        addi x3, x3, 8                            ;
        amominu.d x2, x1, (x3)                    ;
_l106:  csrrsi x12, mepc, 7                       ;
_l107:  flt.s x17, f12, f17                       ;
_l108:  jal x21, _l187                                    ;
_l109:  beq x7, x7, _l122                                 ;
_l110:  sraw x29, x21, x27                        ;
_l111:  fmv.w.x f17, x5                           ;
_l112:  fnmsub.s f7, f13, f10, f28, rtz           ;
_l113:  ebreak                                    ;
_l114:  la x7, _l182                                      ;
        csrrw zero, uepc, x7                      ;
        uret                                      ;
_l115:  fsgnj.s f20, f18, f23                     ;
_l116:  subw x18, x9, x18                         ;
_l117:  bgeu x22, x5, _l176                       ;
_l118:  srli x4, x5, 62                           ;
_l119:  fsgnjx.s f1, f3, f3                       ;
_l120:  la x23, d_1_24                            ;
        lwu x15, 20(x23)                          ;
_l121:  fle.s x11, f8, f5                         ;
_l122:  xor x26, x26, x26                         ;
        csrrs x15, fcsr, x26                      ;
_l123:  la x2, d_5_5                              ;
        srai x2, x2, 1                            ;
        csrrw x28, pmpaddr4, x2                   ;
_l124:  addiw x28, x16, -1080                     ;
_l125:  la x20, d_1_6                             ;
        addi x20, x20, 24                         ;
        amomin.w x6, x30, (x20)                   ;
_l126:  slliw x9, x3, 26                          ;
_l127:  fle.s x2, f27, f31                        ;
_l128:  addw x18, x21, x8                         ;
_l129:  la x8, d_5_25                             ;
        srai x8, x8, 1                            ;
        csrrs x29, pmpaddr3, x8                   ;
_l130:  rem x28, x4, x25                          ;
_l131:  fcvt.s.l f30, x10, dyn                    ;
_l132:  jal x10, _l148                                    ;
_l133:  la x24, d_5_22                            ;
        lb x11, -4(x24)                           ;
_l134:  slli x3, x3, 54                           ;
_l135:  la x3, d_2_8                              ;
        addi x3, x3, 12                           ;
        amoxor.w x10, x16, (x3)                   ;
_l136:  la x26, d_5_22                            ;
        addi x26, x26, -16                        ;
        lr.d x9, (x26)                            ;
_l137:  fcvt.l.s x23, f0, rup                     ;
_l138:  la x4, _l163                                      ;
        csrrw zero, sepc, x4                      ;
        sret                                      ;
_l139:  la x15, d_0_16                            ;
        addi x15, x15, 12                         ;
        amomax.w x6, x5, (x15)                    ;
_l140:  xori x30, x24, -506                       ;
_l141:  fence.i                                   ;
_l142:  mulhu x5, x18, x3                         ;
_l143:  la x18, d_0_19                            ;
        addi x18, x18, -12                        ;
        amomax.w x7, x27, (x18)                   ;
_l144:  srli x13, x17, 56                         ;
_l145:  fmsub.s f23, f3, f3, f30, rup             ;
_l146:  auipc x5, 1012711                         ;
_l147:  andi x11, x30, -20                        ;
_l148:  la x1, d_5_10                             ;
        addi x1, x1, -0                           ;
        amomaxu.d x2, x24, (x1)                   ;
_l149:  la x27, d_1_13                            ;
        addi x27, x27, 0                          ;
        amoor.d x15, x8, (x27)                    ;
_l150:  bge x15, x25, _l170                               ;
_l151:  fcvt.s.w f4, x23, rup                     ;
_l152:  rem x24, x0, x21                          ;
_l153:  srliw x24, x0, 12                         ;
_l154:  mulw x15, x6, x24                         ;
_l155:  la x22, d_1_4                             ;
        addi x22, x22, 16                         ;
        amoadd.w x28, x9, (x22)                   ;
_l156:  fmul.s f4, f9, f18, dyn                   ;
_l157:  fclass.s x20, f26                         ;
_l158:  la x3, d_0_3                              ;
        addi x3, x3, -28                          ;
        amominu.w x20, x18, (x3)                  ;
_l159:  addi x26, x7, -1224                       ;
_l160:  addi x25, x7, -1213                       ;
_l161:  csrrwi x28, pmpaddr5, 28                  ;
_l162:  srlw x6, x28, x0                          ;
_l163:  la x26, d_3_22                            ;
        addi x26, x26, 16                         ;
        lui x15, 0xffe00                          ;
        xor x26, x26, x15                         ;
        amoswap.w x22, x15, (x26)                 ;
_l164:  la x8, d_1_16                             ;
        addi x8, x8, -20                          ;
        lui x3, 0xffe00                           ;
        xor x8, x8, x3                            ;
        amoadd.w x3, x3, (x8)                     ;
_l165:  fle.s x8, f15, f8                         ;
_l166:  fadd.s f30, f13, f7, rmm                  ;
_l167:  remuw x28, x18, x23                       ;
_l168:  slli x17, x25, 56                         ;
_l169:  srlw x14, x13, x10                        ;
_l170:  blt x9, x9, _l179                                 ;
_l171:  fclass.s x4, f4                           ;
_l172:  divu x19, x17, x16                        ;
_l173:  la x3, d_3_18                             ;
        addi x3, x3, 28                           ;
        amoor.w x1, x30, (x3)                     ;
_l174:  la x2, d_5_23                             ;
        addi x2, x2, -16                          ;
        amoxor.d x25, x16, (x2)                   ;
_l175:  la x26, d_4_8                             ;
        addi x26, x26, 0                          ;
        amomin.d x16, x25, (x26)                  ;
_l176:  rem x6, x18, x25                          ;
_l177:  fsub.s f13, f14, f2, dyn                  ;
_l178:  xor x13, x13, x13                         ;
        csrrs x19, sepc, x13                      ;
_l179:  auipc x0, 799743                          ;
_l180:  xor x16, x16, x16                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 25                         ;
        add x16, x16, x20                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 6                          ;
        add x16, x16, x10                         ;
        csrrc x25, mstatus, x16                   ;
_l181:  la x21, d_4_7                             ;
        lhu x3, -16(x21)                          ;
_l182:  addw x5, x15, x7                          ;
_l183:  la x19, d_0_13                            ;
        addi x19, x19, 16                         ;
        lr.d x24, (x19)                           ;
_l184:  csrrwi x6, pmpaddr4, 11                   ;
_l185:  mulhsu x23, x25, x5                       ;
_l186:  auipc x15, 505196                         ;
_l187:  la x24, d_5_26                            ;
        addi x24, x24, -0                         ;
        amoor.d x4, x8, (x24)                     ;
_l188:  fence                                     ;
_l189:  bne x19, x25, _l190                               ;
_l190:  addw x11, x18, x23                        ;
_l191:  la x17, d_5_11                            ;
        addi x17, x17, -0                         ;
        amoor.d x21, x18, (x17)                   ;
_l192:;
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
                .dword 0x6ea460cc1c8b0907, 0x3478cd2575652a58
                .dword 0x082d9652175f92d3, 0xd55909e520304772
d_0_0:          .dword 0x8acb44ac1674a2ea, 0x4085de8492ab5847
d_0_1:          .dword 0x8146abaa2968366f, 0xe203ca057cd60a94
d_0_2:          .dword 0x6b0d78a53d99a44a, 0x2c2f119dd505e489
d_0_3:          .dword 0xeb6e26a643af1011, 0x21306b31d7b0c351
d_0_4:          .dword 0x2724be88d5a87e09, 0x94368386fcaf545f
d_0_5:          .dword 0x5a1a38c46644a169, 0x092c077c05c862f4
d_0_6:          .dword 0x59849370c7dd1b5c, 0x1c737802bf250eeb
d_0_7:          .dword 0xe50dd33f5ccf975c, 0x4f7feb897d616789
d_0_8:          .dword 0x57cd5e398c1de01d, 0xbb9484263eb92a84
d_0_9:          .dword 0x291037e0d769823f, 0xbf5babdbaffa084a
d_0_10:         .dword 0x42281301ecc34bbe, 0x7600f30714962576
d_0_11:         .dword 0xf00424ec1118cb08, 0xa3b2d78b91fe3fdb
d_0_12:         .dword 0x33f4e47238dda09d, 0x23636aebacd771a1
d_0_13:         .dword 0x84902ac290c8bdc1, 0x4b5a85058e02a260
d_0_14:         .dword 0xeff3b49fb0d0eff5, 0x8b67dc9eb659db87
d_0_15:         .dword 0x9f8262dda4cadbd1, 0xc1d2d492ad5107c1
d_0_16:         .dword 0x94f692f3c8b15363, 0x4f6d4e0f22851375
d_0_17:         .dword 0xcaee432999cc6658, 0x30931388b2dbbdc2
d_0_18:         .dword 0x5a0d9a98acc47ba6, 0xc5cbdaf85d2bb32b
d_0_19:         .dword 0xf0321a9c0def6051, 0x2c322ec1005b0eb1
d_0_20:         .dword 0x3713c352ff187ada, 0xb469e2629c3cc4c9
d_0_21:         .dword 0xd9c9f1cc78e80501, 0x6235d94489dbe97a
d_0_22:         .dword 0x8c83af0b30ab7da9, 0x632906c27c3cfe4a
d_0_23:         .dword 0xac054677e8e8e84d, 0x06b8d7013f688fdb
d_0_24:         .dword 0x1f902c4bfb51ca23, 0x815add25f95c18f9
d_0_25:         .dword 0x5c890f88bba417a3, 0x9a55b3fc708e9d3f
d_0_26:         .dword 0x31ea396996f97023, 0xe6e3b465ca261ca2
d_0_27:         .dword 0x99c316dd4467a8d6, 0x4850133a46c6843a
                .dword 0x5cf06305b97db3b6, 0x05e51e0645dde880
                .dword 0x06db565d11ff7303, 0xe35c9d6ba7cf1ea1
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8f9a7d681882c23e, 0x77f9f00b7e0a4b9e
                .dword 0xe8190238b6c10446, 0x1f2132058c85675e
d_1_0:          .dword 0xf329835cf8f193af, 0xfcaf4cadc1d2ee9c
d_1_1:          .dword 0xdb976afdc6a6c767, 0x4e1b990b14dbae66
d_1_2:          .dword 0x8ebe78e55f8188ca, 0x9319bcca0f0adf37
d_1_3:          .dword 0x454e6ea2e034681f, 0xf96a8b0b556ef250
d_1_4:          .dword 0x658e59bdbc0d9d7b, 0x747e1132319e421f
d_1_5:          .dword 0x62681684d5115c1b, 0x0236b706589b72b5
d_1_6:          .dword 0xffebff5b91fe8882, 0x3edc21c0a38a9dda
d_1_7:          .dword 0xa42a64809d12a874, 0x412427f0b2bb570b
d_1_8:          .dword 0x2e28d109c98e6542, 0xeaad511deb278bf3
d_1_9:          .dword 0x2f574aba0e28ea16, 0xf518956ecdb5ce4f
d_1_10:         .dword 0x28eff3e6e9e034b2, 0x1d948821cff438c9
d_1_11:         .dword 0xdc1b84f8a7699d34, 0x04cdf06085366bae
d_1_12:         .dword 0xd7af32d21ba383b6, 0x24a6a8f0ac28799a
d_1_13:         .dword 0xb83fb219e338bce8, 0x456d55ed58090656
d_1_14:         .dword 0xb053ef809c7118c9, 0xe1186976cac9c54a
d_1_15:         .dword 0x40a3808838e52432, 0xc02a0794bf3ac96e
d_1_16:         .dword 0xe19fb2c1aa619f4d, 0x40213217cc6126ef
d_1_17:         .dword 0x44bfa6e47bc600b8, 0x2802a6ba96e2a764
d_1_18:         .dword 0x9d9142931c01c956, 0xf8aca63242ebc6cd
d_1_19:         .dword 0xfb47532abb31e95d, 0x082f7321836758fe
d_1_20:         .dword 0x406f2b2c052405b1, 0x13ce4bbb16ebb48f
d_1_21:         .dword 0x3a217fc4855abbc5, 0x5b61e294f5dfde0b
d_1_22:         .dword 0x9fd2832045ae1d7f, 0xbed484168939e776
d_1_23:         .dword 0x7e8a631f8c0365d0, 0x0da96a90f9b22738
d_1_24:         .dword 0xd8eda3bf80ce8946, 0x55a283571a6d0a9a
d_1_25:         .dword 0x38db71e60da6b8b6, 0x7e40d7fa6e7a59db
d_1_26:         .dword 0xee71ae7ed604b733, 0x04f27a72067e568d
d_1_27:         .dword 0xc1eeb134e9875d7a, 0x28f299392793eb41
                .dword 0xed81136589caef67, 0x62a94247f5b9e0c1
                .dword 0x04c6cdf0319a6862, 0x871d2938f8be2fc2
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x591b088277157b46, 0x50b8cee9ee8fe265
                .dword 0x35dd753f6312a51d, 0x32f2d0c811b5dfc5
d_2_0:          .dword 0x0c89e2929286ce8b, 0xe19685de1ca82313
d_2_1:          .dword 0x8556f8d8929ed146, 0xfd29391c87a030d4
d_2_2:          .dword 0xacdc5e0b52679d3b, 0x510bc6b960142277
d_2_3:          .dword 0xef8b50b539a566ce, 0xf2dbac1ede60e8dc
d_2_4:          .dword 0x14f574e01c2e4c90, 0x7b2229e08662b35e
d_2_5:          .dword 0x1fe9b83e0913c504, 0x8d850f0d3d56940c
d_2_6:          .dword 0x25630c031e0ba6e1, 0x8a50105bf88acb47
d_2_7:          .dword 0x4acb7dc425e88063, 0xd44d6810c69dfeec
d_2_8:          .dword 0x4721ec125b9b4de4, 0xee3cf64638b904c1
d_2_9:          .dword 0x920c9f1104d4d4d7, 0x9fc3d813c2662d9c
d_2_10:         .dword 0x7044abf85fd7d1b6, 0x0409dc2cc1ee4189
d_2_11:         .dword 0x6b184ff066eaf139, 0x0dab0e6c255ab90a
d_2_12:         .dword 0xdc8988f64087e11d, 0xf4239b1891c95040
d_2_13:         .dword 0x604328431e6a0178, 0x793d349c6eae1a99
d_2_14:         .dword 0xf8060d968ba94bea, 0x0094742df59bb6a3
d_2_15:         .dword 0x0a712132125e68cd, 0xd1149ab6b47a07ba
d_2_16:         .dword 0x3c4131a5cc225748, 0x8837e36bfd8fa5f5
d_2_17:         .dword 0x12610a986d7a1256, 0x143b01601a8c9769
d_2_18:         .dword 0x4ac32a2d12b2f817, 0xaf83244f1632c3c8
d_2_19:         .dword 0x43012f546c1e6f0a, 0x6d402d2ee4301e71
d_2_20:         .dword 0xb94b0d481e3cd02f, 0xdf51cb1b634c95a3
d_2_21:         .dword 0x338fe898607ae3e7, 0x5844b308c8ab9e07
d_2_22:         .dword 0x4a57edf8ed145c33, 0x4e0ef558ae1621fc
d_2_23:         .dword 0xe99dd76887ad3a78, 0x6b9a189a6f91d8df
d_2_24:         .dword 0x8a3355b8f29d6989, 0x673e3b0576949815
d_2_25:         .dword 0xda88327612cdb4ac, 0x8429a9edd7f37c8c
d_2_26:         .dword 0x3cd138c949f0ce00, 0x7af28deec38c3267
d_2_27:         .dword 0x19db343aa8a12a1e, 0x2a84bf5958afe613
                .dword 0x66e75f2ace7e9c4f, 0xa523cb5fc4994c8d
                .dword 0x5fcf46bdcf62c1a6, 0x134141ef7bceee63
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xaa5d164aa1a26c48, 0x2828c1a0541de611
                .dword 0x2018fd3885df24a5, 0xc9d8c9fb5ec1b19e
d_3_0:          .dword 0xfccff7afb8424fe5, 0xcd7007fbd5c47688
d_3_1:          .dword 0x249e8d06b005f516, 0xd574aae54cf0efa4
d_3_2:          .dword 0xa84aea11600ec64a, 0x67b580f000ff7c00
d_3_3:          .dword 0x964b1b346a12e445, 0x22cf99b79d0498bf
d_3_4:          .dword 0xc9133f13bdfd92dc, 0x1286d519df9018fc
d_3_5:          .dword 0x977f8f2a59796b78, 0x7f937f5ffcfa56df
d_3_6:          .dword 0x78bf02a584b4393d, 0x06b49fab52e5aec6
d_3_7:          .dword 0x1a6211ec18373d14, 0x303e7014fc7697ee
d_3_8:          .dword 0xdae591cb7b28eb88, 0x11eef1c9e04f5b2f
d_3_9:          .dword 0xdee70e9f4c4bb3ae, 0xe9dc635f8cd75cbd
d_3_10:         .dword 0xe78a39e51305e660, 0xd624fe487b85a748
d_3_11:         .dword 0x045c16ca441f551e, 0x6c9b7e050593eabe
d_3_12:         .dword 0xc7e7b85b9178f836, 0x1511f511288081bc
d_3_13:         .dword 0x1e0af97193f44743, 0xf68eb74b710189b6
d_3_14:         .dword 0x008c45b95ba4a10b, 0x3f5f33b5b79f58e2
d_3_15:         .dword 0xc1163001cfa45e25, 0x8215dc086b80f7b1
d_3_16:         .dword 0xe14064a3a5f60e5c, 0x2ba2b11aaaab8950
d_3_17:         .dword 0x0ab475f771420906, 0xab68710d5b65e482
d_3_18:         .dword 0x785fbc6357fc67b2, 0x8cf997553830f88c
d_3_19:         .dword 0x3cd572c476e70161, 0x6ec85afb8f85ca79
d_3_20:         .dword 0x8147bbb6ea178f2d, 0x5b122f5bec2815f0
d_3_21:         .dword 0x6323d4f79f54eaaf, 0x4687fa7e3aecf3ab
d_3_22:         .dword 0x42e549b8ad3e8403, 0xa49da175c459a93f
d_3_23:         .dword 0xdaa4283d12053ef0, 0x3015e2c21e4acf59
d_3_24:         .dword 0x6639aa8e13776249, 0x992907f7cbf24a5e
d_3_25:         .dword 0x819887b9077391d8, 0x1aa015872f131e22
d_3_26:         .dword 0x0874e111da37374c, 0x4bf003231f851cf8
d_3_27:         .dword 0x7e5abdbc5cab9212, 0xf5bec62d86d8e2be
                .dword 0x9e45d591dd528bff, 0xaee243ef5357388e
                .dword 0x32112ff1cd9a7606, 0x8bb119bd641d5fe1
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0513917bf918b80e, 0xa9766fc9ce64045d
                .dword 0xed34f08c7b31e10d, 0x157a80c632f11da4
d_4_0:          .dword 0xd9d26fc7ef23cbc6, 0x82293f89b444a962
d_4_1:          .dword 0x6d460fa86bf37b4d, 0x1bec90fa8c5fedc6
d_4_2:          .dword 0x93c02ca6da57410a, 0x025709e45ba7d4e1
d_4_3:          .dword 0xdb599a366b5c7760, 0x0d81140877c09c73
d_4_4:          .dword 0x23eb0f4981e29b9b, 0x9ac40d3bdb95ed3a
d_4_5:          .dword 0xbd4e271b1522fd32, 0x7c4252c2430a8a09
d_4_6:          .dword 0x56acaa655cf25c78, 0x6e231a3d13796060
d_4_7:          .dword 0x65f25738ceed668a, 0xe48c8e0e36505a3a
d_4_8:          .dword 0x646dfa05d99007b2, 0x8640b1ce9a5a855d
d_4_9:          .dword 0x0eecb94da7e30a47, 0xb2e10886815a3e86
d_4_10:         .dword 0x5c667961f027b9c5, 0x50c036adbd52d922
d_4_11:         .dword 0x16e66d1b553ec8d5, 0xa95779a92124edfc
d_4_12:         .dword 0xe368e250d38c2343, 0x191864344f6230b1
d_4_13:         .dword 0x2dd643636e3802ab, 0xcd54a0cce9410a47
d_4_14:         .dword 0xc4660e7f25d75489, 0x40c4cb1bc055b0d5
d_4_15:         .dword 0x2e691eda5e748d75, 0x247f80584fb81cf5
d_4_16:         .dword 0xa668bd28dd7556e4, 0xb37499bf9e251e8f
d_4_17:         .dword 0xdc0b712f34f31462, 0x6a2844c6ddec9bc2
d_4_18:         .dword 0x0e0b793a47f31800, 0x5f030c4ac15c483c
d_4_19:         .dword 0xcb033a3d9f9eff70, 0x106a2e249ea7049f
d_4_20:         .dword 0xf27903e270ee8442, 0xc8acc455cc98c166
d_4_21:         .dword 0x53ca0c9b07972db3, 0x5eccedace2a6b8e0
d_4_22:         .dword 0xd2fbfaf5a8db8f9b, 0x695aac637ef66940
d_4_23:         .dword 0x4e31a9af9cd1e1c9, 0x52bc032667b04a28
d_4_24:         .dword 0xf52a1335573235d6, 0x7358f956364678d6
d_4_25:         .dword 0x4a9a3c230a4eabe5, 0xf180951091c868cb
d_4_26:         .dword 0x5c5712a569fa0106, 0xb339f8d6f70137a7
d_4_27:         .dword 0xef50e4b614c15d2d, 0xeb070571733c7ef1
                .dword 0x0617fd2877919a6e, 0x340c6abf9881c3a8
                .dword 0x824b81cdb9f745aa, 0xeb4289be124e8540
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4dc2b0ca2edca0e2, 0xac36ab14b380a7eb
                .dword 0x483d427712a9d023, 0x603f40fbf53ae24b
d_5_0:          .dword 0x646668268e97e34f, 0x3d6703cb12e12e5c
d_5_1:          .dword 0x3c46de4cc352f27d, 0x9b42c7f94b0327a2
d_5_2:          .dword 0x8dd6a51450069d46, 0x016100003442fc75
d_5_3:          .dword 0x16f24b9d81bf0796, 0x2882ade50278a8a0
d_5_4:          .dword 0x90b6a95126926e81, 0x985061653244aa9f
d_5_5:          .dword 0xca15d4617775901c, 0xdf013c0638c67294
d_5_6:          .dword 0x1eeffd1846decae5, 0x45926c8ee3e30a35
d_5_7:          .dword 0x52bb54b82f89b7a2, 0xc70df5b200df6ce0
d_5_8:          .dword 0x124ce47e60cbb9fe, 0xf93a4207ea8e8560
d_5_9:          .dword 0xf1d5b694ac43f057, 0x25966a5cac5c3678
d_5_10:         .dword 0x16d57df3ff91a59d, 0x875c2adceca97186
d_5_11:         .dword 0x10d87361eb0ce639, 0xe4d54ef94b23cc82
d_5_12:         .dword 0xb8de5fc5b62a2ebb, 0x57d9dc3339c6640d
d_5_13:         .dword 0xac163e62fd9be519, 0x85c706da3c25c381
d_5_14:         .dword 0xfc26b6ed5e193a05, 0xcb7e2afe6d6523ec
d_5_15:         .dword 0xd8df8954b19190f6, 0xf68712baa4975025
d_5_16:         .dword 0x0229165dc52b2939, 0x571fc8969da9c210
d_5_17:         .dword 0xfdabd44f6ec0da1b, 0xcb2da2e2649d38f1
d_5_18:         .dword 0x6a1a2ad2c8d4da8a, 0x231c81ba4ba9ff8f
d_5_19:         .dword 0xa0e2937298b2d163, 0x8d682fe98788d924
d_5_20:         .dword 0x692b8d5f8cc6e2ab, 0xc58ad32ad765605e
d_5_21:         .dword 0x7494cce01d3c745b, 0xefbed3c97dc34519
d_5_22:         .dword 0x68d65bb2de5e4d34, 0x32c781df7112aaaa
d_5_23:         .dword 0xb82b079f6798a4d3, 0xeeea2f491dd06627
d_5_24:         .dword 0x478ff19c419fe9ae, 0x08aad0d1d10fb9cf
d_5_25:         .dword 0x72a46f43cbfd12dd, 0x3cf47114aded0098
d_5_26:         .dword 0xc014809f75b6e69c, 0x0f6d13f1cbec3293
d_5_27:         .dword 0xc6efb4f3780c492a, 0xeb32a73286e06bdd
                .dword 0x70380511d8c39cf1, 0x144adea43dd7124e
                .dword 0xa45cd4f3b377a136, 0x3791db73374fcd37
         /* Random data */
_end_data5:
              
 
