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
_p0:    la x10, d_0_14                            ;
        srai x10, x10, 1                          ;
        csrrc x12, pmpaddr7, x10                  ;
_p1:    xor x10, x10, x10                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 5                          ;
        add x10, x10, x10                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 29                         ;
        add x10, x10, x12                         ;
        csrrs x11, satp, x10                      ;
_p2:    xor x13, x13, x13                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 18                         ;
        add x13, x13, x13                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 9                          ;
        add x13, x13, x14                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 29                         ;
        add x13, x13, x14                         ;
        csrrw x12, fflags, x13                    ;
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
_s0:    lui x18, 42153                            ;
_s1:    bge x2, x31, _s4                          ;
_s2:    la x22, _s5                               ;
        jalr x1, 0(x22)                           ;
_s3:    fmsub.s f22, f6, f14, f22, rmm            ;
_s4:    la x5, d_0_17                             ;
        lhu x1, 8(x5)                             ;
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
_l0:    la x4, d_2_10                             ;
        sh x25, -16(x4)                           ;
_l1:    la x4, d_3_5                              ;
        addi x4, x4, -16                          ;
        lui x27, 0xffe00                          ;
        xor x4, x4, x27                           ;
        amominu.w x14, x27, (x4)                  ;
_l2:    ebreak                                    ;
_l3:    la x6, _l186                              ;
        csrrw zero, sepc, x6                      ;
        sret                                      ;
_l4:    la x1, d_4_12                             ;
        addi x1, x1, 4                            ;
        amomax.w x9, x19, (x1)                    ;
_l5:    jal x22, _l55                             ;
_l6:    fmv.x.w x2, f23                           ;
_l7:    addw x1, x8, x21                          ;
_l8:    flt.s x5, f17, f15                        ;
_l9:    slti x5, x27, -0                          ;
_l10:   la x4, d_4_18                             ;
        addi x4, x4, -24                          ;
        amoand.d x21, x11, (x4)                   ;
_l11:   la x2, d_4_24                             ;
        lwu x1, 4(x2)                             ;
_l12:   la x26, _l39                              ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l13:   la x11, d_4_6                             ;
        addi x11, x11, 0                          ;
        amomaxu.w x23, x27, (x11)                 ;
_l14:   la x22, d_5_17                            ;
        addi x22, x22, 16                         ;
        amoswap.w x3, x13, (x22)                  ;
_l15:   la x5, d_1_20                             ;
        lwu x11, 24(x5)                           ;
_l16:   auipc x18, 19                             ;
_l17:   fmin.s f6, f22, f17                       ;
_l18:   la x17, d_3_25                            ;
        addi x17, x17, -8                         ;
        amoxor.w x5, x12, (x17)                   ;
_l19:   fsgnjx.s f6, f12, f20                     ;
_l20:   la x27, d_0_6                             ;
        addi x27, x27, -8                         ;
        amoswap.d x15, x8, (x27)                  ;
_l21:   fnmsub.s f13, f12, f17, f23, rne          ;
_l22:   la x6, _l141                              ;
        jalr x20, 0(x6)                           ;
_l23:   fcvt.lu.s x1, f14, rtz                    ;
_l24:   ecall                                     ;
_l25:   la x12, d_4_23                            ;
        addi x12, x12, -0                         ;
        amoadd.d x29, x20, (x12)                  ;
_l26:   mulhu x6, x25, x5                         ;
_l27:   la x20, d_5_5                             ;
        addi x20, x20, -0                         ;
        amoswap.w x22, x11, (x20)                 ;
_l28:   la x17, d_1_14                            ;
        addi x17, x17, -0                         ;
        sc.d x19, x17, (x17)                      ;
_l29:   addiw x21, x11, 842                       ;
_l30:   addiw x10, x9, -1727                      ;
_l31:   la x7, d_1_25                             ;
        fsw f14, 20(x7)                           ;
_l32:   fsgnj.s f23, f7, f24                      ;
_l33:   mulw x11, x21, x5                         ;
_l34:   fle.s x16, f22, f29                       ;
_l35:   ecall                                     ;
_l36:   la x4, d_2_12                             ;
        addi x4, x4, 0                            ;
        amomax.d x25, x8, (x4)                    ;
_l37:   la x13, _l136                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l38:   addiw x17, x1, -0                         ;
_l39:   slliw x30, x24, 29                        ;
_l40:   fadd.s f22, f19, f5, rdn                  ;
_l41:   la x20, d_1_23                            ;
        sd x22, -0(x20)                           ;
_l42:   bltu x22, x14, _l77                       ;
_l43:   ebreak                                    ;
_l44:   srlw x17, x8, x16                         ;
_l45:   div x16, x12, x8                          ;
_l46:   mulw x21, x1, x12                         ;
_l47:   fdiv.s f8, f30, f9, rmm                   ;
_l48:   subw x0, x14, x12                         ;
_l49:   fdiv.s f6, f24, f30, rtz                  ;
_l50:   la x19, d_5_4                             ;
        addi x19, x19, -28                        ;
        amomin.w x27, x30, (x19)                  ;
_l51:   la x24, d_4_5                             ;
        fsw f31, 20(x24)                          ;
_l52:   fsgnjn.s f4, f5, f27                      ;
_l53:   la x5, d_4_24                             ;
        addi x5, x5, 0                            ;
        lr.d x8, (x5)                             ;
_l54:   la x21, d_0_12                            ;
        addi x21, x21, -0                         ;
        amoswap.w x12, x18, (x21)                 ;
_l55:   xor x1, x1, x1                            ;
        addi x4, zero, 3                          ;
        slli x4, x4, 8                            ;
        add x1, x1, x4                            ;
        csrrc x10, sstatus, x1                    ;
_l56:   fmv.w.x f12, x19                          ;
_l57:   sllw x3, x5, x30                          ;
_l58:   srliw x17, x12, 3                         ;
_l59:   la x23, d_5_20                            ;
        addi x23, x23, 8                          ;
        sc.d x17, x23, (x23)                      ;
_l60:   fmsub.s f8, f9, f13, f5, rtz              ;
_l61:   la x9, d_1_4                              ;
        addi x9, x9, 0                            ;
        amoxor.d x26, x3, (x9)                    ;
_l62:   la x4, _l111                              ;
        csrrw zero, sepc, x4                      ;
        sret                                      ;
_l63:   fcvt.s.lu f25, x25, rmm                   ;
_l64:   remw x23, x10, x5                         ;
_l65:   la x22, _l154                             ;
        csrrw zero, mepc, x22                     ;
        mret                                      ;
_l66:   xor x27, x27, x27                         ;
        addi x28, zero, 1                         ;
        slli x28, x28, 27                         ;
        add x27, x27, x28                         ;
        csrrw x7, stval, x27                      ;
_l67:   fcvt.w.s x18, f22, dyn                    ;
_l68:   la x28, d_5_4                             ;
        addi x28, x28, -24                        ;
        amominu.w x21, x7, (x28)                  ;
_l69:   fsgnjn.s f3, f25, f30                     ;
_l70:   remu x17, x9, x16                         ;
_l71:   la x25, d_4_1                             ;
        addi x25, x25, 12                         ;
        lui x22, 0xffe00                          ;
        xor x25, x25, x22                         ;
        amoor.w x24, x22, (x25)                   ;
_l72:   andi x7, x21, 2                           ;
_l73:   auipc x5, 108052                          ;
_l74:   divuw x17, x27, x6                        ;
_l75:   la x20, d_1_16                            ;
        flw f17, -0(x20)                          ;
_l76:   la x5, d_2_1                              ;
        lhu x30, 8(x5)                            ;
_l77:   mulhu x6, x1, x11                         ;
_l78:   sraw x17, x10, x18                        ;
_l79:   srlw x6, x12, x25                         ;
_l80:   la x14, _l114                             ;
        jalr x27, 0(x14)                          ;
_l81:   fle.s x15, f8, f12                        ;
_l82:   fcvt.wu.s x23, f9, rmm                    ;
_l83:   bne x27, x4, _l106                        ;
_l84:   andi x14, x25, 341                        ;
_l85:   remuw x5, x20, x13                        ;
_l86:   la x7, d_4_1                              ;
        addi x7, x7, 8                            ;
        amoor.d x18, x5, (x7)                     ;
_l87:   fcvt.s.wu f20, x29, rne                   ;
_l88:   subw x7, x28, x11                         ;
_l89:   addw x12, x19, x16                        ;
_l90:   slliw x22, x12, 6                         ;
_l91:   bgeu x7, x19, _l180                       ;
_l92:   rem x9, x4, x23                           ;
_l93:   srai x6, x3, 10                           ;
_l94:   slli x22, x13, 41                         ;
_l95:   fence                                     ;
_l96:   remw x17, x4, x2                          ;
_l97:   remw x21, x0, x7                          ;
_l98:   la x1, d_0_9                              ;
        addi x1, x1, -8                           ;
        amominu.w x24, x16, (x1)                  ;
_l99:   fle.s x6, f5, f22                         ;
_l100:  la x9, d_4_25                             ;
        addi x9, x9, 0                            ;
        amomin.d x9, x2, (x9)                     ;
_l101:  fnmsub.s f4, f9, f26, f6, rtz             ;
_l102:  fnmsub.s f23, f24, f19, f17, rtz          ;
_l103:  la x12, d_0_12                            ;
        addi x12, x12, -28                        ;
        lui x19, 0xffe00                          ;
        xor x12, x12, x19                         ;
        amoadd.w x14, x19, (x12)                  ;
_l104:  ori x13, x13, -1727                       ;
_l105:  la x25, d_2_5                             ;
        addi x25, x25, 0                          ;
        amomax.d x24, x15, (x25)                  ;
_l106:  fdiv.s f14, f27, f15, rmm                 ;
_l107:  fmsub.s f6, f26, f6, f12, rdn             ;
_l108:  bne x7, x18, _l199                        ;
_l109:  fcvt.s.l f22, x7, rdn                     ;
_l110:  la x6, d_1_7                              ;
        addi x6, x6, -16                          ;
        amomax.d x9, x8, (x6)                     ;
_l111:  la x28, d_3_5                             ;
        lui x8, 0xffe00                           ;
        xor x28, x28, x8                          ;
        sd x19, 0(x28)                            ;
_l112:  la x30, d_3_16                            ;
        addi x30, x30, -16                        ;
        amomaxu.d x15, x7, (x30)                  ;
_l113:  blt x9, x15, _l173                        ;
_l114:  fle.s x0, f27, f7                         ;
_l115:  la x14, _l190                             ;
        jalr x29, 0(x14)                          ;
_l116:  fcvt.s.lu f23, x29, rup                   ;
_l117:  srli x4, x12, 63                          ;
_l118:  sraiw x29, x5, 9                          ;
_l119:  fcvt.s.l f28, x4, rup                     ;
_l120:  xori x21, x10, -1618                      ;
_l121:  xor x16, x16, x16                         ;
        csrrw x19, mtval, x16                     ;
_l122:  div x12, x29, x16                         ;
_l123:  fcvt.s.wu f24, x5, rdn                    ;
_l124:  csrrsi x14, medeleg, 8                    ;
_l125:  fence.i                                   ;
_l126:  fle.s x14, f4, f26                        ;
_l127:  la x16, d_1_21                            ;
        addi x16, x16, -0                         ;
        amomax.d x29, x22, (x16)                  ;
_l128:  fence.i                                   ;
_l129:  xor x30, x30, x30                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 24                           ;
        add x30, x30, x1                          ;
        csrrw x15, fflags, x30                    ;
_l130:  la x30, d_5_18                            ;
        addi x30, x30, -0                         ;
        amominu.d x2, x4, (x30)                   ;
_l131:  ori x11, x10, -396                        ;
_l132:  bge x6, x2, _l173                         ;
_l133:  remu x17, x18, x2                         ;
_l134:  la x25, d_4_4                             ;
        flw f14, 8(x25)                           ;
_l135:  fcvt.s.lu f8, x11, dyn                    ;
_l136:  la x2, d_5_13                             ;
        lhu x4, 0(x2)                             ;
_l137:  ecall                                     ;
_l138:  sltiu x9, x3, -22                         ;
_l139:  la x24, d_5_16                            ;
        addi x24, x24, 8                          ;
        amomaxu.d x16, x6, (x24)                  ;
_l140:  la x8, d_1_6                              ;
        addi x8, x8, 16                           ;
        amomin.w x11, x25, (x8)                   ;
_l141:  beq x26, x30, _l185                       ;
_l142:  la x27, d_0_23                            ;
        addi x27, x27, 16                         ;
        amomin.w x10, x1, (x27)                   ;
_l143:  la x26, d_3_1                             ;
        addi x26, x26, 0                          ;
        amomaxu.d x12, x22, (x26)                 ;
_l144:  la x5, d_2_20                             ;
        addi x5, x5, -8                           ;
        amoor.d x15, x21, (x5)                    ;
_l145:  la x29, d_0_23                            ;
        addi x29, x29, 16                         ;
        amoswap.d x18, x25, (x29)                 ;
_l146:  mulh x24, x21, x21                        ;
_l147:  la x25, d_3_0                             ;
        sh x20, -30(x25)                          ;
_l148:  remuw x7, x23, x2                         ;
_l149:  bgeu x30, x20, _l152                      ;
_l150:  fmsub.s f27, f28, f16, f27, rup           ;
_l151:  addw x18, x29, x7                         ;
_l152:  fmax.s f30, f0, f29                       ;
_l153:  slliw x19, x15, 9                         ;
_l154:  la x10, d_4_2                             ;
        addi x10, x10, 12                         ;
        amoxor.w x26, x13, (x10)                  ;
_l155:  la x14, d_1_5                             ;
        lb x19, 25(x14)                           ;
_l156:  la x5, d_5_20                             ;
        lhu x3, -20(x5)                           ;
_l157:  fcvt.s.wu f25, x2, rdn                    ;
_l158:  remw x19, x20, x9                         ;
_l159:  la x9, d_2_24                             ;
        addi x9, x9, 16                           ;
        lui x20, 0xffe00                          ;
        xor x9, x9, x20                           ;
        amoxor.w x25, x20, (x9)                   ;
_l160:  addi x11, x0, 2047                        ;
_l161:  la x28, d_4_13                            ;
        addi x28, x28, -8                         ;
        amoswap.d x7, x5, (x28)                   ;
_l162:  ebreak                                    ;
_l163:  la x8, d_5_22                             ;
        lw x8, 12(x8)                             ;
_l164:  la x28, d_2_27                            ;
        lhu x14, 10(x28)                          ;
_l165:  la x4, d_5_14                             ;
        addi x4, x4, -4                           ;
        lr.w x18, (x4)                            ;
_l166:  fence                                     ;
_l167:  mulhsu x20, x22, x8                       ;
_l168:  fmul.s f22, f8, f20, rmm                  ;
_l169:  jal x30, _l174                            ;
_l170:  la x6, _l176                              ;
        csrrw zero, sepc, x6                      ;
        sret                                      ;
_l171:  ebreak                                    ;
_l172:  xor x19, x19, x19                         ;
        addi x16, zero, 1                         ;
        slli x16, x16, 1                          ;
        add x19, x19, x16                         ;
        csrrw x29, stval, x19                     ;
_l173:  la x1, d_5_21                             ;
        addi x1, x1, 20                           ;
        amoadd.w x27, x13, (x1)                   ;
_l174:  li x3, 0                                  ;
        la x6, pt2                                ;
        addi x6, x6, 0                            ;
        sfence.vma x3, x6                         ;
_l175:  li x7, 0                                  ;
        la x21, pt0                               ;
        addi x21, x21, 8                          ;
        sfence.vma x7, x21                        ;
_l176:  fsub.s f31, f26, f18, rup                 ;
_l177:  fcvt.l.s x27, f6, rdn                     ;
_l178:  fence.i                                   ;
_l179:  fsub.s f30, f16, f9, rup                  ;
_l180:  la x18, _l196                             ;
        csrrw zero, uepc, x18                     ;
        uret                                      ;
_l181:  fsgnjx.s f19, f11, f22                    ;
_l182:  la x24, d_1_6                             ;
        addi x24, x24, 8                          ;
        amoadd.d x8, x10, (x24)                   ;
_l183:  rem x20, x21, x29                         ;
_l184:  fle.s x1, f5, f19                         ;
_l185:  fmsub.s f0, f23, f11, f13, rup            ;
_l186:  sraw x27, x17, x29                        ;
_l187:  la x26, d_3_9                             ;
        lb x3, -31(x26)                           ;
_l188:  fsqrt.s f6, f6, rmm                       ;
_l189:  la x7, d_1_10                             ;
        flw f20, -16(x7)                          ;
_l190:  la x30, d_0_6                             ;
        addi x30, x30, -12                        ;
        amoor.w x1, x18, (x30)                    ;
_l191:  fcvt.s.w f16, x0, rmm                     ;
_l192:  fence                                     ;
_l193:  fcvt.wu.s x29, f22, rup                   ;
_l194:  mulw x28, x25, x27                        ;
_l195:  csrrci x9, pmpcfg0, 0                     ;
_l196:  li x25, 1                                 ;
        la x12, pt2                               ;
        addi x12, x12, 40                         ;
        sfence.vma x25, x12                       ;
_l197:  la x28, d_4_6                             ;
        addi x28, x28, 0                          ;
        amomin.d x6, x6, (x28)                    ;
_l198:  mulhsu x10, x21, x23                      ;
_l199:  flt.s x25, f17, f0                        ;
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
                .dword 0xca41e551b3f8f31a, 0x061d1199fe208a90
                .dword 0x86eb5fac72f28b1b, 0xf3b7f18ace90f89a
d_0_0:          .dword 0xbb3a749ee12ea16a, 0x4abd3e61e5f00139
d_0_1:          .dword 0x11b2ba0acbc7225b, 0x44e4f007395f7107
d_0_2:          .dword 0x66b49bc27902e404, 0xb12487afceeb0973
d_0_3:          .dword 0x107f1015554b611c, 0x0460827c43290b59
d_0_4:          .dword 0xc0a4a3dff02bd6f5, 0x216916620f5401ae
d_0_5:          .dword 0x2cb3d9ff65766a97, 0x025088ddd83ff47a
d_0_6:          .dword 0xc98eabf432e9e1f6, 0x71b3f4331c4a6abf
d_0_7:          .dword 0x1ba13ef0855312f7, 0x2326d5f962c40a5c
d_0_8:          .dword 0xb701668f883f9efc, 0x6507737dd3c6478d
d_0_9:          .dword 0x0f451de173958d84, 0x491b69c8247d943d
d_0_10:         .dword 0x1cf2f9d00acedf12, 0xb3ce7d2a2d5aeb2f
d_0_11:         .dword 0xd38b5bf62ee65dc4, 0x29f4bd6f9e48f73e
d_0_12:         .dword 0xb1eb0f508253926f, 0x7f34cb5c7038bec5
d_0_13:         .dword 0x1bf71e1b705693a4, 0x915cfbec915ada26
d_0_14:         .dword 0x9a831433f7d42eb5, 0xc73898f1c677756a
d_0_15:         .dword 0xe1c0c9aa50cb9548, 0x932a5ea15a775206
d_0_16:         .dword 0x593518587f64ccbd, 0x40e5a217a5b51696
d_0_17:         .dword 0xef8c4f68a94e147e, 0x3b19eef7fb70b0dd
d_0_18:         .dword 0x3fd4e3529efc1c05, 0xf5778b597ca87720
d_0_19:         .dword 0x19b8d76d4189e123, 0xf5fa71999d0422bd
d_0_20:         .dword 0xc092908020cade90, 0x9bf0b7904de17b6b
d_0_21:         .dword 0xf58144e903da55a0, 0x6c9d7dc1910f1692
d_0_22:         .dword 0x331593f6a1a41d63, 0x31f8f38987c4eff0
d_0_23:         .dword 0x1567130b3296ba93, 0x62e91e63a4b73c83
d_0_24:         .dword 0x7936455c5f0b6fad, 0x3b663d363b918ea5
d_0_25:         .dword 0x0eb9d1dd6f824d16, 0xa6cffe8f4fe8a4da
d_0_26:         .dword 0x24b41d89a568303b, 0x5a73c936485f330f
d_0_27:         .dword 0x7a319dbfc6aa7ba1, 0x04893057826938cd
                .dword 0xce2569aca3794424, 0x27613f7144c819ec
                .dword 0x44f730235056a6cc, 0xf1ee5d6038411963
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa7bc28a001ed3d55, 0x1aab4be04a5bb704
                .dword 0x8ff2bec5e562d4b7, 0x743267749efd2eb3
d_1_0:          .dword 0x646f255764635d49, 0xffb217f4601d6fe1
d_1_1:          .dword 0x3338c5479d65c049, 0x438aece24603ce30
d_1_2:          .dword 0xfbc44638eeb15db1, 0xa41c85c30bbe2032
d_1_3:          .dword 0x4d348da6e5dab90d, 0x57153136da6f40d1
d_1_4:          .dword 0x77063d647a0c97d9, 0x0353b8f11676a12b
d_1_5:          .dword 0x70348d63f9bfd473, 0x02c1b7b1b28dd0a5
d_1_6:          .dword 0xccccc006c27788b1, 0x24561f2137a31947
d_1_7:          .dword 0xe5979c6ddab5d0e2, 0x03a9b9818b3e1825
d_1_8:          .dword 0x900dc07d0cc2d0a8, 0xf1a04a412766d645
d_1_9:          .dword 0x9359f59e9c6e8db1, 0x036e05d7f3c39c78
d_1_10:         .dword 0xf516a202f2f49482, 0xb612dc340d5907ba
d_1_11:         .dword 0x13881697fc2ffa9c, 0xe6012986ad6d322d
d_1_12:         .dword 0xe380af99357562e7, 0x25997a4600b7c6e3
d_1_13:         .dword 0x5fc7b7e06f3d7795, 0xfa6d65300e2a1fec
d_1_14:         .dword 0x2a0ec208e1158a41, 0xb6e65a07cf2274b7
d_1_15:         .dword 0x602228d2b151a795, 0x2d729ef5c144d95d
d_1_16:         .dword 0x7f224be1b1b014da, 0xcc68d459dc5006d8
d_1_17:         .dword 0x07c8a44c5d331f30, 0x5c3318c9db3da2ca
d_1_18:         .dword 0xe6141494a9c543ea, 0x02e409a1c61fec18
d_1_19:         .dword 0xa3fa421e17caaa44, 0xff20db3ec7e1d5b1
d_1_20:         .dword 0xde4570607c2f56a3, 0x9fc76d2dbdc73342
d_1_21:         .dword 0x8f63981ee5e29ab4, 0x2a45dd7e858c6c95
d_1_22:         .dword 0xe9ba0a37c55ddbce, 0x1f7fe4b708fe222e
d_1_23:         .dword 0x71fce863548394a8, 0x2a5e05768679d8bd
d_1_24:         .dword 0xdcdc8be9c5cdbd7e, 0x1be1c2fcacbba175
d_1_25:         .dword 0xa0221b0c77256703, 0x065328248a6149b2
d_1_26:         .dword 0x81d81f432b061600, 0x53c26240c2caf5d9
d_1_27:         .dword 0x5ecc84623d275aef, 0xcfe772c1f2e4b601
                .dword 0x0c49de7e139e0c17, 0x79e14c1956c293a4
                .dword 0x8c99b930f9707d5c, 0xd765db221d3365ba
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3d0ef4138d1907b2, 0x2880c8921c0c9712
                .dword 0xc04b56a77160263f, 0x68b553e85a27042b
d_2_0:          .dword 0x55546e06f9a32232, 0x11c9a0cf9d0ede32
d_2_1:          .dword 0x3dfbc86b1a06151b, 0x12cdd4161df1fba7
d_2_2:          .dword 0x2023381fd7f536c8, 0xcd96a7b8ac4dcc80
d_2_3:          .dword 0x99a30150cba126a9, 0xfbe9ca14cdc4d85f
d_2_4:          .dword 0x7968c986bd8dc3dc, 0x0dee6ef8187b8bd9
d_2_5:          .dword 0x9aa4a1b8925a840c, 0x144d8c46474607fe
d_2_6:          .dword 0x7a4f654480426587, 0x0e95f5dcde3a9f98
d_2_7:          .dword 0xf5fd2a1fbdad7011, 0x93890ed19eca6e0a
d_2_8:          .dword 0xfbd0170bb4a10539, 0xddf34007bc4c84b5
d_2_9:          .dword 0x8c03b88e51aab8d2, 0x5277158a6e30be00
d_2_10:         .dword 0x58294501a3ad1c0a, 0xf4de927593f4a931
d_2_11:         .dword 0xf881c91324707f15, 0xe03afac4f2a63481
d_2_12:         .dword 0x7a2b510f14b177a1, 0x52fb6044d381d4e6
d_2_13:         .dword 0x5d139fa63213bba7, 0xb2db2333db0ebe64
d_2_14:         .dword 0x98b9202912113f72, 0x95be11e7b3efecce
d_2_15:         .dword 0x35b56d05748ee74f, 0x4144b86bdc6dad46
d_2_16:         .dword 0x9e387913bb8030a4, 0xbe8fe9fe9f27dcdf
d_2_17:         .dword 0xedc64f3c2f259545, 0x082aebc8bcb3b9d3
d_2_18:         .dword 0x9de9c3760f63c4b4, 0x333ff55661cfc10d
d_2_19:         .dword 0xcd1107b618d981e7, 0xb027045b0a121b96
d_2_20:         .dword 0x19cfa6d15c6842fc, 0xaf2fafa2b776d087
d_2_21:         .dword 0xb9c2d460add34617, 0x3e45bb2bf5aad665
d_2_22:         .dword 0x314390d965e9a5fc, 0xe7a16d12dcd76d90
d_2_23:         .dword 0xa90db07ac1100b6a, 0x3da493709bd6a1ea
d_2_24:         .dword 0x096d6af991fb0e1a, 0x18012fbf0da25731
d_2_25:         .dword 0x6ce83529aa7a9df6, 0x9c5e423bf27cef1c
d_2_26:         .dword 0xc7c62dbdb47cc3bd, 0xb8dea15932bedaec
d_2_27:         .dword 0x9f93773f3ead42f9, 0xf4200590c001f047
                .dword 0xe7db64be057ea9db, 0xd64cec847cc44f78
                .dword 0xd60a89d899333187, 0x0d80ee6a8755f164
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x921485e1c9faf7f2, 0x9d5a20c5586f4f5d
                .dword 0xedfe27087d524faa, 0x0640f0cf4c85bdc7
d_3_0:          .dword 0x8d07071b9b73f8b1, 0x623d0b44f298aae9
d_3_1:          .dword 0xa85639bf35cf7401, 0xdaa91ec3d984c068
d_3_2:          .dword 0xbab39b8d3151458f, 0x11aa13809df7f6d9
d_3_3:          .dword 0xe2a9db6024db1e95, 0x14f052c3a8e5e273
d_3_4:          .dword 0x68aeb04e638584d4, 0x3ccaaab6c8ab577f
d_3_5:          .dword 0x91e6b4effd489c02, 0x09953fc0b9c066a9
d_3_6:          .dword 0x1d56758cf5cc8289, 0xb16580ee1c0dd647
d_3_7:          .dword 0xd1fdf2608befc26f, 0xe495a310aa653442
d_3_8:          .dword 0x547ac6b0463d4703, 0xec96f5d0422a9400
d_3_9:          .dword 0xace9b0e91e06bfac, 0x221cf7cfaa91ee6c
d_3_10:         .dword 0xb74dcede6fb6fe4e, 0x52ae6cc45b079f6e
d_3_11:         .dword 0x65112cbba21cccb2, 0x15f0436078f7f7ca
d_3_12:         .dword 0xfae97c4f78ec3e17, 0x8818eda59d53cc62
d_3_13:         .dword 0x0c8167a0736b2e6d, 0xb7f4f86ec37e3e0c
d_3_14:         .dword 0xcec13ae0d267ad37, 0xf5db2c4033d37c2d
d_3_15:         .dword 0x1f3f72d1328d8c4f, 0x920d5f57aeaf1730
d_3_16:         .dword 0xa431c9fe654fb251, 0x8cb07429ece952bf
d_3_17:         .dword 0x9a6edd4f7ac67db8, 0x8a461fd0053ea0d0
d_3_18:         .dword 0x6c206fe2675a339c, 0x04a0fed78c6bcb25
d_3_19:         .dword 0x58a67076fc7d07ef, 0x29d6946446e72ec9
d_3_20:         .dword 0x31852546745d7c23, 0x4b814e3de7548221
d_3_21:         .dword 0x201b7d3d520681e1, 0x17be483a2327e9e1
d_3_22:         .dword 0x0d254ba51a5387ee, 0xee557ffc80dccb27
d_3_23:         .dword 0x6b3fb03063ac46d2, 0xaa3cdef5ab013d44
d_3_24:         .dword 0x12fea3191d977d7d, 0x10b037f090400717
d_3_25:         .dword 0x7a1815827afc19b0, 0x6e302180fd22b9ed
d_3_26:         .dword 0xbef8a42e2cf07bb0, 0x4e4986e1ad5f6587
d_3_27:         .dword 0xc43d17b87540e4db, 0xdfcb6279a44fab52
                .dword 0xbac7c87f4701706a, 0xf4faf3b31fe7fd2b
                .dword 0x29516a9ff7c1eea6, 0x63cdaa19ba44e402
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xfb7fa60b93fa8d22, 0xda46b3a798d14fdd
                .dword 0x1444391496b31b29, 0x806e7a09a9cc3d10
d_4_0:          .dword 0x517f3735d4c0a86d, 0x6d7ed5d984f47f9f
d_4_1:          .dword 0xbda6d1def408c6d2, 0xaf74b43aa38ba4c4
d_4_2:          .dword 0x3f2700edef2dff2b, 0xe414eaa99f7c980b
d_4_3:          .dword 0x6b275ba16f0e5aa5, 0x70e554f564394066
d_4_4:          .dword 0xc899d32f610579dc, 0xe006491416552b72
d_4_5:          .dword 0xfe00ff458f6e5eed, 0x41a3533338692c9b
d_4_6:          .dword 0x9aa5564585090899, 0x9392e733dc2b150b
d_4_7:          .dword 0x931504b9c2d34c5a, 0x38f1e801536db030
d_4_8:          .dword 0xec020caf8a38b4f2, 0xe580e68d3c7b04ff
d_4_9:          .dword 0x548e8917625ba374, 0xa65a2b811af736fa
d_4_10:         .dword 0x45892f42445131cf, 0xcf8431489844baf1
d_4_11:         .dword 0x597c6594f56eaba0, 0x39f48b8ad2f4dd31
d_4_12:         .dword 0xb1599d6e7b0a23a3, 0x8bc17ffbbb422c77
d_4_13:         .dword 0x5565647c83894b3a, 0x2484f76a0a93ff7c
d_4_14:         .dword 0xcf9d079aac1352bc, 0xc3768b391ff973d1
d_4_15:         .dword 0x54581d7a8f5cb94b, 0x38e402f379800273
d_4_16:         .dword 0xb6a46425fa02fc5b, 0x8112a3e17178d24a
d_4_17:         .dword 0x7e96c30db8689360, 0x66dbd25f9a19665c
d_4_18:         .dword 0xfbc4fe32c383318f, 0x208a5a9f1f19a370
d_4_19:         .dword 0xcffd47f8129d6f44, 0xca46f40bbd8b3299
d_4_20:         .dword 0x5efcc20a8157b600, 0x41d281dbbd4d76a2
d_4_21:         .dword 0xae2573c43742c936, 0x71ee534afb3e65b7
d_4_22:         .dword 0x59e6547ad0d86e90, 0xb2e94befcfb934b4
d_4_23:         .dword 0xb6f5eb05b59be50b, 0x3d8f1972a50b9f36
d_4_24:         .dword 0x17c7ee7e3de9db30, 0xc2413ae271aa8885
d_4_25:         .dword 0x5f9c488307749c9a, 0xaa34e7db37e3d160
d_4_26:         .dword 0xabed4adf4d3c2c1e, 0x6a2296c462defcac
d_4_27:         .dword 0x887ecf64e3f974f0, 0x7d785268a8ae980d
                .dword 0x7992ebe7d6f0ab53, 0x819e993da3bac4e6
                .dword 0xc21eb4b659f7032a, 0x05af2eb2eb34bf36
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x5cb96722e71ffda1, 0xdd70634e898147cd
                .dword 0x678f4fae887eb079, 0x54f5e5a4f2fbf89c
d_5_0:          .dword 0x76d6bc6f51037acd, 0xb87045aa15b5ca3e
d_5_1:          .dword 0x07a5dcc5ecc34580, 0xcb6477cbe804c3ae
d_5_2:          .dword 0x08ec4da2746d3114, 0x81326d96e74edf3d
d_5_3:          .dword 0x1415cd5a7cf721b3, 0x5fb857c8d03576e2
d_5_4:          .dword 0x5e2a60244e3b0d01, 0x18fdb636e7e1f7c1
d_5_5:          .dword 0xc3c999147e9c7ff8, 0xaba6fc0baf79450c
d_5_6:          .dword 0xaa220ba8d4327f32, 0x4f70877a00fd4c33
d_5_7:          .dword 0x836b89b8a303cb24, 0x44f20de41070cba4
d_5_8:          .dword 0x0208d0a12e877910, 0xa05245c394cdcbd1
d_5_9:          .dword 0xde144704827c9140, 0x6c96a3e800af85c3
d_5_10:         .dword 0xd91da7b7dad3b17e, 0xf6f0d7b4ce4a50ef
d_5_11:         .dword 0xe89dba76c82133f1, 0xa800e6fc9de0fb85
d_5_12:         .dword 0x94e6fcccfe1e034b, 0xa539c60ffc910aea
d_5_13:         .dword 0x1569b0f0510e486c, 0xd4f63d6366284e8b
d_5_14:         .dword 0xaddf5c4769b39aee, 0xa40df8385436a8ab
d_5_15:         .dword 0x0711f6461ed43708, 0xa9d2b62eec1a76d8
d_5_16:         .dword 0x1ada1efa47816c65, 0x7c17528bfe94c930
d_5_17:         .dword 0x5bc5e3e5ac381bce, 0x7085eef720d23aeb
d_5_18:         .dword 0xe5e285eb8c56c810, 0x15861285b9fcf4e5
d_5_19:         .dword 0x7a62ae6953221b7e, 0xb801269964c91165
d_5_20:         .dword 0xb51d3de3686f2f57, 0x8bcf1e3804760b47
d_5_21:         .dword 0xde83bf2498745f39, 0x5dcfb985ff30bb66
d_5_22:         .dword 0xf1d71221da891ebd, 0xf5783b7591b98662
d_5_23:         .dword 0x4c911b3fb89ceebe, 0x4776efdabb759ce3
d_5_24:         .dword 0xc475bd4209062b6f, 0x39f9c1f9be3ddec0
d_5_25:         .dword 0x29e5ce2bcde8b14e, 0x28eb6a6fb5e9773e
d_5_26:         .dword 0x4cf1dba533e76331, 0x1d0684c29873039b
d_5_27:         .dword 0x26873dfdb51a7402, 0x37728e3bfb6bb37b
                .dword 0xbe0e65fabe1c8d5f, 0xe1523b7a2ec7f941
                .dword 0x32b4de3917e2b082, 0x9f1744763543368a
         /* Random data */
_end_data5:
              
 
