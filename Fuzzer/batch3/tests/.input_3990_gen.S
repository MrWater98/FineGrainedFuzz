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
_p0:    csrrsi x11, pmpaddr1, 14                  ;
_p1:    xor x14, x14, x14                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 10                         ;
        add x14, x14, x11                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 22                         ;
        add x14, x14, x11                         ;
        csrrw x11, stval, x14                     ;
_p2:    csrrci x13, satp, 31                      ;
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
_s0:    fsgnj.s f22, f22, f1                      ;
_s1:    la x17, d_5_17                            ;
        addi x17, x17, 12                         ;
        amoand.w x3, x18, (x17)                   ;
_s2:    blt x7, x21, _s5                          ;
_s3:    sraiw x14, x23, 28                        ;
_s4:    la x24, d_2_27                            ;
        lhu x12, 0(x24)                           ;
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
_l0:    bltu x14, x14, _l94                       ;
_l1:    la x24, d_0_15                            ;
        addi x24, x24, -0                         ;
        amoxor.w x13, x3, (x24)                   ;
_l2:    bltu x13, x30, _l87                       ;
_l3:    la x16, d_4_13                            ;
        addi x16, x16, -8                         ;
        amominu.w x27, x3, (x16)                  ;
_l4:    li x9, 1                                  ;
        la x17, pt1                               ;
        addi x17, x17, 0                          ;
        sfence.vma x9, x17                        ;
_l5:    fcvt.s.wu f27, x24, dyn                   ;
_l6:    auipc x15, 0                              ;
_l7:    fclass.s x16, f13                         ;
_l8:    sraw x9, x3, x15                          ;
_l9:    la x11, d_3_23                            ;
        lui x27, 0xffe00                          ;
        xor x11, x11, x27                         ;
        fsw f22, 24(x11)                          ;
_l10:   la x17, d_0_8                             ;
        lwu x2, -4(x17)                           ;
_l11:   la x15, _l69                              ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l12:   fmadd.s f27, f2, f2, f4, rup              ;
_l13:   la x7, d_5_23                             ;
        addi x7, x7, -8                           ;
        amoxor.w x8, x7, (x7)                     ;
_l14:   la x12, d_2_15                            ;
        lhu x26, 14(x12)                          ;
_l15:   srli x8, x26, 45                          ;
_l16:   divu x0, x14, x30                         ;
_l17:   andi x16, x29, 1070                       ;
_l18:   fcvt.s.wu f4, x13, rup                    ;
_l19:   la x20, d_2_22                            ;
        lw x29, -4(x20)                           ;
_l20:   fsub.s f22, f10, f10, dyn                 ;
_l21:   la x27, d_0_24                            ;
        fsw f10, -4(x27)                          ;
_l22:   la x30, d_1_25                            ;
        addi x30, x30, 0                          ;
        amomin.d x18, x12, (x30)                  ;
_l23:   fdiv.s f17, f14, f13, rup                 ;
_l24:   la x22, d_2_8                             ;
        addi x22, x22, -16                        ;
        amomax.d x17, x12, (x22)                  ;
_l25:   fcvt.wu.s x9, f3, rup                     ;
_l26:   la x11, d_4_24                            ;
        lb x24, -8(x11)                           ;
_l27:   la x28, d_2_19                            ;
        lhu x25, 22(x28)                          ;
_l28:   la x25, d_0_24                            ;
        lb x11, -12(x25)                          ;
_l29:   fcvt.s.l f17, x3, rdn                     ;
_l30:   la x1, _l196                              ;
        lh x13, -24(x1)                           ;
_l31:   ebreak                                    ;
_l32:   la x6, d_5_18                             ;
        sd x17, -8(x6)                            ;
_l33:   fcvt.w.s x26, f18, rmm                    ;
_l34:   la x25, _l135                             ;
        jalr x8, 0(x25)                           ;
_l35:   fcvt.w.s x24, f6, rmm                     ;
_l36:   fle.s x3, f20, f30                        ;
_l37:   csrrwi x4, sie, 31                        ;
_l38:   la x11, d_1_9                             ;
        addi x11, x11, 8                          ;
        amoand.d x13, x15, (x11)                  ;
_l39:   fmv.x.w x6, f20                           ;
_l40:   fadd.s f0, f19, f25, rmm                  ;
_l41:   fcvt.l.s x18, f18, rne                    ;
_l42:   sraw x11, x13, x27                        ;
_l43:   la x26, d_3_7                             ;
        sd x25, -0(x26)                           ;
_l44:   la x19, d_4_27                            ;
        lhu x19, 30(x19)                          ;
_l45:   slli x26, x23, 12                         ;
_l46:   la x29, _l186                             ;
        csrrw zero, sepc, x29                     ;
        sret                                      ;
_l47:   srlw x10, x17, x3                         ;
_l48:   fsgnjn.s f2, f28, f27                     ;
_l49:   fsub.s f12, f13, f16, rup                 ;
_l50:   fsgnjn.s f22, f16, f10                    ;
_l51:   auipc x0, 679788                          ;
_l52:   la x2, d_5_7                              ;
        lwu x26, -16(x2)                          ;
_l53:   sllw x7, x21, x25                         ;
_l54:   fsgnjn.s f6, f15, f26                     ;
_l55:   la x13, d_2_19                            ;
        addi x13, x13, -8                         ;
        amomin.d x20, x29, (x13)                  ;
_l56:   la x1, d_3_23                             ;
        addi x1, x1, -0                           ;
        lui x24, 0xffe00                          ;
        xor x1, x1, x24                           ;
        sc.d x23, x1, (x1)                        ;
_l57:   fcvt.wu.s x20, f19, rup                   ;
_l58:   la x8, d_3_17                             ;
        addi x8, x8, -0                           ;
        amomax.w x18, x1, (x8)                    ;
_l59:   la x4, d_0_4                              ;
        addi x4, x4, 8                            ;
        amoswap.d x5, x9, (x4)                    ;
_l60:   la x25, d_2_4                             ;
        addi x25, x25, 0                          ;
        amoor.w x5, x26, (x25)                    ;
_l61:   sltiu x1, x29, 1082                       ;
_l62:   li x4, 0                                  ;
        la x3, pt3                                ;
        addi x3, x3, 40                           ;
        sfence.vma x4, x3                         ;
_l63:   srlw x27, x22, x7                         ;
_l64:   ecall                                     ;
_l65:   fsgnjx.s f12, f7, f14                     ;
_l66:   fclass.s x8, f16                          ;
_l67:   mulh x13, x27, x12                        ;
_l68:   andi x28, x0, -0                          ;
_l69:   fcvt.s.lu f3, x16, dyn                    ;
_l70:   la x18, d_3_8                             ;
        sb x19, 5(x18)                            ;
_l71:   la x9, d_3_7                              ;
        addi x9, x9, 8                            ;
        sc.w x19, x27, (x9)                       ;
_l72:   la x25, d_2_12                            ;
        addi x25, x25, -4                         ;
        amomax.w x18, x21, (x25)                  ;
_l73:   la x14, d_3_10                            ;
        addi x14, x14, -0                         ;
        amoadd.w x6, x3, (x14)                    ;
_l74:   la x10, d_4_14                            ;
        addi x10, x10, -12                        ;
        amomaxu.w x21, x13, (x10)                 ;
_l75:   fsub.s f25, f19, f14, rne                 ;
_l76:   fmv.w.x f16, x26                          ;
_l77:   srai x3, x16, 4                           ;
_l78:   div x19, x21, x11                         ;
_l79:   xori x13, x11, 0                          ;
_l80:   la x6, d_0_15                             ;
        sb x18, 16(x6)                            ;
_l81:   la x17, d_3_10                            ;
        sh x13, 12(x17)                           ;
_l82:   la x29, d_4_3                             ;
        sb x21, 11(x29)                           ;
_l83:   fcvt.w.s x2, f5, dyn                      ;
_l84:   slti x13, x26, -0                         ;
_l85:   jal x18, _l173                            ;
_l86:   fsqrt.s f6, f30, dyn                      ;
_l87:   fcvt.wu.s x7, f29, rup                    ;
_l88:   la x30, d_1_25                            ;
        addi x30, x30, -0                         ;
        lui x17, 0xffe00                          ;
        xor x30, x30, x17                         ;
        amomaxu.w x6, x17, (x30)                  ;
_l89:   la x17, _l172                             ;
        lui x23, 0xffe00                          ;
        xor x17, x17, x23                         ;
        lwu x28, 4(x17)                           ;
_l90:   remuw x15, x0, x17                        ;
_l91:   fmul.s f29, f19, f31, rtz                 ;
_l92:   fcvt.w.s x28, f30, rmm                    ;
_l93:   la x6, d_3_15                             ;
        addi x6, x6, 20                           ;
        amominu.w x23, x24, (x6)                  ;
_l94:   addi x21, x30, -1581                      ;
_l95:   mulhsu x0, x23, x27                       ;
_l96:   fence                                     ;
_l97:   bge x24, x25, _l129                       ;
_l98:   flt.s x4, f12, f15                        ;
_l99:   la x1, d_1_26                             ;
        addi x1, x1, -0                           ;
        amomax.d x8, x8, (x1)                     ;
_l100:  xor x25, x25, x25                         ;
        csrrw x20, sstatus, x25                   ;
_l101:  beq x3, x25, _l191                        ;
_l102:  la x25, d_3_17                            ;
        sh x3, -4(x25)                            ;
_l103:  remw x26, x8, x27                         ;
_l104:  la x14, d_1_3                             ;
        addi x14, x14, -4                         ;
        amoand.w x14, x29, (x14)                  ;
_l105:  beq x24, x2, _l179                        ;
_l106:  la x10, _l191                             ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l107:  la x29, d_2_6                             ;
        addi x29, x29, -8                         ;
        amominu.d x5, x26, (x29)                  ;
_l108:  bltu x13, x20, _l196                      ;
_l109:  ori x29, x19, 1813                        ;
_l110:  fcvt.l.s x8, f17, rmm                     ;
_l111:  fsub.s f13, f17, f7, rup                  ;
_l112:  fcvt.s.lu f25, x22, dyn                   ;
_l113:  mulw x7, x21, x20                         ;
_l114:  la x8, d_5_6                              ;
        sw x4, 28(x8)                             ;
_l115:  fcvt.lu.s x21, f2, rdn                    ;
_l116:  mulhu x8, x23, x7                         ;
_l117:  mulw x25, x26, x21                        ;
_l118:  la x24, d_0_3                             ;
        lb x13, 10(x24)                           ;
_l119:  slti x28, x14, 2047                       ;
_l120:  fle.s x27, f27, f3                        ;
_l121:  srlw x11, x18, x16                        ;
_l122:  la x20, _l175                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l123:  addiw x4, x1, 528                         ;
_l124:  sraiw x15, x4, 13                         ;
_l125:  subw x2, x7, x11                          ;
_l126:  sltiu x11, x1, -1792                      ;
_l127:  fcvt.w.s x21, f6, rup                     ;
_l128:  la x21, _l159                             ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l129:  la x2, _l54                               ;
        ld x25, -0(x2)                            ;
_l130:  la x10, _l131                             ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l131:  fnmadd.s f3, f30, f14, f7, rup            ;
_l132:  fmin.s f3, f20, f5                        ;
_l133:  fcvt.lu.s x0, f12, rne                    ;
_l134:  la x20, d_0_18                            ;
        lui x1, 0xffe00                           ;
        xor x20, x20, x1                          ;
        sd x2, -16(x20)                           ;
_l135:  li x6, 0                                  ;
        la x16, pt1                               ;
        addi x16, x16, 16                         ;
        sfence.vma x6, x16                        ;
_l136:  bne x11, x20, _l179                       ;
_l137:  la x19, d_4_10                            ;
        addi x19, x19, -24                        ;
        amoswap.d x7, x5, (x19)                   ;
_l138:  la x8, d_4_1                              ;
        addi x8, x8, 0                            ;
        sc.d x4, x8, (x8)                         ;
_l139:  srliw x1, x30, 4                          ;
_l140:  lui x11, 460517                           ;
_l141:  ecall                                     ;
_l142:  slti x0, x6, 482                          ;
_l143:  slliw x17, x23, 16                        ;
_l144:  remuw x4, x30, x5                         ;
_l145:  la x18, _l92                              ;
        ld x4, 24(x18)                            ;
_l146:  la x30, d_2_10                            ;
        lw x21, 8(x30)                            ;
_l147:  la x22, d_2_15                            ;
        addi x22, x22, -0                         ;
        amoor.d x11, x9, (x22)                    ;
_l148:  la x23, d_0_5                             ;
        addi x23, x23, 0                          ;
        amominu.d x10, x24, (x23)                 ;
_l149:  blt x25, x17, _l183                       ;
_l150:  remu x6, x17, x23                         ;
_l151:  la x26, _l38                              ;
        lhu x28, -18(x26)                         ;
_l152:  remw x18, x3, x22                         ;
_l153:  la x17, _l163                             ;
        csrrw zero, sepc, x17                     ;
        sret                                      ;
_l154:  la x21, _l186                             ;
        csrrw zero, sepc, x21                     ;
        sret                                      ;
_l155:  la x7, d_4_17                             ;
        addi x7, x7, 0                            ;
        amomin.d x28, x15, (x7)                   ;
_l156:  srai x8, x17, 57                          ;
_l157:  la x8, d_1_17                             ;
        addi x8, x8, -28                          ;
        lr.w x4, (x8)                             ;
_l158:  la x17, d_1_1                             ;
        addi x17, x17, 0                          ;
        sc.d x11, x17, (x17)                      ;
_l159:  subw x21, x4, x28                         ;
_l160:  xori x5, x7, 14                           ;
_l161:  csrrsi x17, pmpaddr5, 3                   ;
_l162:  la x19, d_3_20                            ;
        sh x15, -6(x19)                           ;
_l163:  auipc x6, 57                              ;
_l164:  bltu x10, x7, _l193                       ;
_l165:  fcvt.s.l f8, x23, rtz                     ;
_l166:  mulh x21, x10, x6                         ;
_l167:  fsgnjn.s f25, f25, f16                    ;
_l168:  la x11, _l190                             ;
        csrrw zero, mepc, x11                     ;
        mret                                      ;
_l169:  xor x28, x28, x28                         ;
        addi x17, zero, 3                         ;
        slli x17, x17, 1                          ;
        add x28, x28, x17                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 8                          ;
        add x28, x28, x27                         ;
        csrrc x17, frm, x28                       ;
_l170:  slli x30, x24, 0                          ;
_l171:  la x12, _l200                             ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_l172:  la x2, d_1_4                              ;
        addi x2, x2, -8                           ;
        amominu.w x5, x21, (x2)                   ;
_l173:  la x21, d_0_12                            ;
        lh x17, -24(x21)                          ;
_l174:  la x23, d_1_22                            ;
        lh x16, 12(x23)                           ;
_l175:  fcvt.s.l f11, x11, rtz                    ;
_l176:  fsgnjn.s f29, f10, f3                     ;
_l177:  mulhu x3, x20, x16                        ;
_l178:  xori x4, x8, -8                           ;
_l179:  la x5, d_1_24                             ;
        lh x9, 30(x5)                             ;
_l180:  la x24, d_3_7                             ;
        addi x24, x24, -8                         ;
        amoxor.w x15, x16, (x24)                  ;
_l181:  bgeu x20, x6, _l193                       ;
_l182:  fnmsub.s f23, f6, f10, f27, rmm           ;
_l183:  rem x7, x7, x7                            ;
_l184:  xor x9, x9, x9                            ;
        addi x20, zero, 1                         ;
        slli x20, x20, 25                         ;
        add x9, x9, x20                           ;
        addi x13, zero, 3                         ;
        slli x13, x13, 20                         ;
        add x9, x9, x13                           ;
        csrrc x12, mtval, x9                      ;
_l185:  fle.s x19, f5, f21                        ;
_l186:  fcvt.l.s x9, f21, rne                     ;
_l187:  la x16, d_2_3                             ;
        fsw f19, -12(x16)                         ;
_l188:  fcvt.s.wu f8, x22, rup                    ;
_l189:  mul x11, x26, x6                          ;
_l190:  la x25, d_0_27                            ;
        addi x25, x25, -24                        ;
        amoxor.w x24, x15, (x25)                  ;
_l191:  fcvt.s.l f31, x6, dyn                     ;
_l192:  la x27, _l195                             ;
        csrrw zero, mepc, x27                     ;
        mret                                      ;
_l193:  sraiw x19, x18, 9                         ;
_l194:  la x3, d_2_9                              ;
        addi x3, x3, 16                           ;
        lui x9, 0xffe00                           ;
        xor x3, x3, x9                            ;
        amominu.w x21, x9, (x3)                   ;
_l195:  subw x14, x30, x24                        ;
_l196:  jal x3, _l198                             ;
_l197:  la x27, d_4_13                            ;
        addi x27, x27, -0                         ;
        amomaxu.d x22, x4, (x27)                  ;
_l198:  la x12, _l99                              ;
        lh x13, 30(x12)                           ;
_l199:  la x14, d_1_25                            ;
        sh x28, 0(x14)                            ;
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
                .dword 0x1e7c7da68b82b922, 0x4befae1acd356eec
                .dword 0xfb0ac45b256b51c3, 0x392226c9bc771663
d_0_0:          .dword 0xb63386dcd7ab8769, 0x3367fb42abab868f
d_0_1:          .dword 0x78cb159b82707da6, 0x7de05cd6d909425f
d_0_2:          .dword 0x6daec6b5e4c8d051, 0x0d15227312f29618
d_0_3:          .dword 0x1d2cb4bf60caaa0b, 0xf0c3d24cf20ea737
d_0_4:          .dword 0x7d8ebb59a3130cf9, 0x422a0ec819e2c4cd
d_0_5:          .dword 0x022f01fccec90ab3, 0x758ee3dfb1f51225
d_0_6:          .dword 0x58706486a300383a, 0x4658a323f9646912
d_0_7:          .dword 0xd321d88575108adc, 0xfdbad7568908c1c2
d_0_8:          .dword 0x7b60b779dbcd6496, 0x2b3b04f191eeeda4
d_0_9:          .dword 0x0ae6da0784ba458d, 0x1b4382c1c7ec6108
d_0_10:         .dword 0xb50d1fd5ad09efd6, 0x127a506e4170aa13
d_0_11:         .dword 0x130776f59fc9cc0f, 0x8e6add4e06aa70a3
d_0_12:         .dword 0xb16ca30622c3ca79, 0x4fda2d6d23820d7c
d_0_13:         .dword 0x802f702e1575b40c, 0x561b219dbe266960
d_0_14:         .dword 0x4d8a8e7ea4e4985b, 0xe89cb447ee3ef297
d_0_15:         .dword 0x151865e2610f2aba, 0x8058403dcb04ac24
d_0_16:         .dword 0x1f339754dc5483cc, 0x4dffbde54bf94692
d_0_17:         .dword 0x02ff8bb977159003, 0xc715b39d6257a746
d_0_18:         .dword 0x8607b35f1c3e71fe, 0x25c7c0001cd2491c
d_0_19:         .dword 0x138e987ee42f70b4, 0x028772774b1f6959
d_0_20:         .dword 0x4c7db87c189c08cd, 0x76aba1313c43b414
d_0_21:         .dword 0x45490f0524a02903, 0x3bcda3d0516af674
d_0_22:         .dword 0xddd88cff2468ee99, 0x61419b74a0defedd
d_0_23:         .dword 0x6722d8e3f56ba44f, 0xb49e4b680e1ef645
d_0_24:         .dword 0x7892acf7614938c2, 0x83cdc39d2bc5edaf
d_0_25:         .dword 0x66a3bf71cb6e8533, 0xd50273eda098bc78
d_0_26:         .dword 0xa89836ca5c87da07, 0x362c78b7071a65e6
d_0_27:         .dword 0x074a7190d220d1d1, 0x76ca780dc2f8bcb0
                .dword 0x7be49007a0ba359b, 0xc3ad4f61b2ba0807
                .dword 0xe4f5c3f949aa016f, 0x987a5f53fbd1bd67
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x7e13091508dd5f13, 0x4e4e589080f0f301
                .dword 0x223e5f85db7b9bcd, 0xc83f219ccd931a37
d_1_0:          .dword 0xfc52a88d5992b4ae, 0x443fbb6892239c32
d_1_1:          .dword 0xabe70555e85372aa, 0xc6da880ac6e1aad5
d_1_2:          .dword 0xebb65ade8382b9da, 0xcb3f27ef5e56b5a2
d_1_3:          .dword 0x766ee32e6f0c53b3, 0xb0f3344b8d4a83e4
d_1_4:          .dword 0x61fb26c48913d1f5, 0x1f2fa2ead01df021
d_1_5:          .dword 0x4e50048a981b9001, 0xb40b434e87b8dc26
d_1_6:          .dword 0xa07ec7948110bfe9, 0x72771a9b552b1e90
d_1_7:          .dword 0x3c815da5a829a26c, 0x4e9215d8981312ed
d_1_8:          .dword 0x70a9e8de12c96181, 0x5e8aa7b8a10b3541
d_1_9:          .dword 0x2b2cbb6a917264d3, 0x9267f464ab8c70d4
d_1_10:         .dword 0xe5b2fd623ca8d39c, 0x9cc4c1da417abc2c
d_1_11:         .dword 0xce87c5c7f5ccb6be, 0x20ed57a3c9e1d7f8
d_1_12:         .dword 0x015f813fc4dd6c8c, 0xdaf8f7ee257049c0
d_1_13:         .dword 0xfae67d389a98827e, 0xca4547e9a4647044
d_1_14:         .dword 0x2a13081627ffba8b, 0x359861e901e627e9
d_1_15:         .dword 0xb08ef6d244146583, 0xea26731b5e2da9dd
d_1_16:         .dword 0x1cacaf6824ee41d4, 0xb65f556bb8b822f1
d_1_17:         .dword 0x610970c3a5c80c1a, 0x42946fd549d33f14
d_1_18:         .dword 0xa51d51959e9875cf, 0x7c9fca3ae0163bee
d_1_19:         .dword 0x235f8f7b53b79a6a, 0x98095bd14879ac48
d_1_20:         .dword 0xc76fbcb1b0c0d532, 0x95d7d86633a5665d
d_1_21:         .dword 0xf67a28fc819d02fa, 0x45788184f1e7d5bd
d_1_22:         .dword 0xaef8870a9f5c22b6, 0xbdbe0989992df2cf
d_1_23:         .dword 0xba35af7e0718c7e7, 0x34fc6dab7932bcb1
d_1_24:         .dword 0xe481d98e41330037, 0xb6a57bb43f55482c
d_1_25:         .dword 0x1d5d717cb39f8870, 0x293bcdf3f22dce4b
d_1_26:         .dword 0x9bca80907c6e0465, 0x472e52146854c5a8
d_1_27:         .dword 0xb45456d64e2feaf2, 0xd298a09647d91155
                .dword 0x838109cc8f6d54c4, 0xbde56bb6b66bcfd7
                .dword 0x300d48ec39ae0c99, 0xd3a9a9b84e54bf7f
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe1b3134054c3c992, 0x45069da0aa20ceb8
                .dword 0xa7af570227466724, 0xee7e386d6e66ee28
d_2_0:          .dword 0x779584859823c6fb, 0x5979ca4984e91648
d_2_1:          .dword 0x441090ee458750b6, 0xb02df38bb9b8e73a
d_2_2:          .dword 0xc67bff2570740de9, 0x317f1b8a99926414
d_2_3:          .dword 0xbe69378960e59c7a, 0x50a0ee0c0216ae8f
d_2_4:          .dword 0x178372e5bf087a55, 0xf290eb30821a4de5
d_2_5:          .dword 0xb8c09cd047cf4955, 0x2f8150c4037c6e4e
d_2_6:          .dword 0x2ffda010e97620fb, 0xa35e5b31c21ccfff
d_2_7:          .dword 0x6abb818dc95f2031, 0xe32e248ff573fbfa
d_2_8:          .dword 0x51462c62343ede3c, 0xfefb0b1b8dd73967
d_2_9:          .dword 0x313068048ef2b23c, 0x6becfb6a084b8913
d_2_10:         .dword 0x9b37c251673170fd, 0x9ba78f554a96c781
d_2_11:         .dword 0xf4d6d7e75b39c618, 0xf8c4cae6fecc8184
d_2_12:         .dword 0x966c987c4e5bc203, 0x3368532edcaa0cac
d_2_13:         .dword 0x6faf280c8764ef5a, 0xa6c9040fccb3c88c
d_2_14:         .dword 0x8fec3de52eeb567e, 0xfed708540580049d
d_2_15:         .dword 0x5753fa670a16a6a1, 0xea4c938b70f5394e
d_2_16:         .dword 0x387cd0c1bbf63d13, 0xef8942c2d5380966
d_2_17:         .dword 0xfb5aacd454da145d, 0x893f7fce90472203
d_2_18:         .dword 0xb15a3fb52ee3dacf, 0x75f3ea27163e4565
d_2_19:         .dword 0x39e5ec4f653dfb2e, 0x5ee5d0dfec958b3c
d_2_20:         .dword 0x4f61dc91ea896f5f, 0x1549f4a5ae252e76
d_2_21:         .dword 0x1182677601f1ad58, 0x41f494513e924d49
d_2_22:         .dword 0x35952c1081ee00b4, 0xcb2c654ffafe69bf
d_2_23:         .dword 0x009b4475e1b0a71e, 0x0122570358413e7d
d_2_24:         .dword 0x20137b862ac5488b, 0xe6fc64493ca5bf99
d_2_25:         .dword 0x2c9479cd4129b469, 0x2011a51225e8070d
d_2_26:         .dword 0xfdd94b5771e778c7, 0xf728986b19db5154
d_2_27:         .dword 0x9336a523faa3e846, 0x1b5e3919490c4b53
                .dword 0x8e50dec87910145b, 0xe0bbb3ad5c47480f
                .dword 0x3fa07d4e7f024b72, 0xcb5c8d934d1d7aa4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x3c5907e806ea687e, 0x8f5b9ee7ba2eb036
                .dword 0xdac386950ecc8fb0, 0xf55abfb80bc10e7a
d_3_0:          .dword 0x61cf61b9845c48c4, 0x544c8f63c1861806
d_3_1:          .dword 0x9702ac0cf9ce99f3, 0x5bdf35cbad011ac1
d_3_2:          .dword 0x5692766543a3d001, 0x415a05aa3f4f731e
d_3_3:          .dword 0xfabc26f07a5c36af, 0xb7ffa13f500d8ad8
d_3_4:          .dword 0x658226301079d63e, 0xcb63e66dc3e86a0d
d_3_5:          .dword 0x585406b4f61ef2e1, 0xfc6392a0f99c7d40
d_3_6:          .dword 0xee4a4a7f88b27936, 0x7a836aecdbd891f4
d_3_7:          .dword 0xfdeba171807df799, 0xa84036865526e855
d_3_8:          .dword 0x721ce20f4c35cf4f, 0xcd5a84c998d7d00f
d_3_9:          .dword 0x66dccbf15c635985, 0x455b49e5e85de078
d_3_10:         .dword 0x6df4b572fc06dc65, 0x48632c71a5a6cda6
d_3_11:         .dword 0x8afd3d849da9af24, 0x0607b5dfb4b58d3d
d_3_12:         .dword 0x10285d2cdce556be, 0xb6eb3761a628d175
d_3_13:         .dword 0xe16326001db73c55, 0x7e722d030b2186b1
d_3_14:         .dword 0x5f0434c28fb4c34a, 0xd08c838ddcbaeb70
d_3_15:         .dword 0xe50ced6c8e5ec761, 0x0551ae8b55de0a4b
d_3_16:         .dword 0x1969bca228b84d27, 0xfea95883859ac6e0
d_3_17:         .dword 0xa9036ed0e2ad3951, 0x36d84cab0b8fac44
d_3_18:         .dword 0x0f3ec2e71edfa894, 0x53438ad544c1b232
d_3_19:         .dword 0xb109aa00f78520a1, 0x2e2fb766f242609f
d_3_20:         .dword 0x843b8210217a4e94, 0x2208c9e605a265a0
d_3_21:         .dword 0x0bba2722a7efc77c, 0xd723cfeda6eeb764
d_3_22:         .dword 0x8a030b8ad197c740, 0x1ec1300e5ab25681
d_3_23:         .dword 0xa8c96cb61ab3c48b, 0xde6e00a415b1c9df
d_3_24:         .dword 0x4f61fbd73b9bd481, 0x0cda1b321bbd4b0f
d_3_25:         .dword 0xaaefb64b13f3ca00, 0x6551920aa6573807
d_3_26:         .dword 0x133583fa80ed85d1, 0xa6d34c1a0ac12868
d_3_27:         .dword 0xd7f8f1ee6d7e5a75, 0xa77386f84ade9e8d
                .dword 0x423437cdb11fcd2a, 0x7490200d7bc6245e
                .dword 0xc9b12a36c9254d21, 0x72ea392e65c54074
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x57e459a700b7c498, 0x3f5bfeb036d5d75d
                .dword 0x2f19f8f76a52f77f, 0x169988d1d3327aeb
d_4_0:          .dword 0x2cda023faecb13a2, 0x3162910edc43bb3c
d_4_1:          .dword 0x9aaadf7dedcb07fe, 0xf28d40c95051b667
d_4_2:          .dword 0xbc08998c1c84a003, 0x1ce76bec80ff5a5e
d_4_3:          .dword 0x9c4697d5b8b70e54, 0x882a14e12b2891eb
d_4_4:          .dword 0xf574ff59697be1bf, 0x6f4a9485be41affd
d_4_5:          .dword 0x280aa90caa467a0f, 0x5ce1eaf7b1085d20
d_4_6:          .dword 0x46f3518a03ec45ab, 0x74ab0acca498e9c2
d_4_7:          .dword 0x53d516a3ef0edb96, 0x2c0918aa5000d630
d_4_8:          .dword 0x02c6dd20541ca068, 0x180600d787fe9a6c
d_4_9:          .dword 0x6dfc29fae90b5fec, 0x922dafb42c8ef646
d_4_10:         .dword 0xf7c6c2e33a06fd46, 0x7dffe687cfc2c3fd
d_4_11:         .dword 0xbd77dd09515b3675, 0x168b4c560cf3f4a1
d_4_12:         .dword 0x187cddcbc47baa5e, 0x7dc7963d5d937fc4
d_4_13:         .dword 0x457e598194656380, 0x8eb7daceec0c0910
d_4_14:         .dword 0x4cd193adea3d2e07, 0x2949f2b43738c5cd
d_4_15:         .dword 0x7e93ba46e0e774d6, 0x707681cab996bfac
d_4_16:         .dword 0x14d344503aa38818, 0xe59668f57f3c68c7
d_4_17:         .dword 0x78a25d82e3c86dd2, 0x96d84a0ac2617264
d_4_18:         .dword 0x94d497fcb78de183, 0x0b3b3afa803b9ba9
d_4_19:         .dword 0x7f99ae8b2d535cad, 0x7b1f3bee8777f606
d_4_20:         .dword 0x3be945dd89d79d97, 0x124927ea4ef897c4
d_4_21:         .dword 0xbb8b5559f62f1ae2, 0x93d5d0c1b1cad634
d_4_22:         .dword 0x947aa165bd7b602a, 0xfcf00e43f17253da
d_4_23:         .dword 0xf3626c88ebf78f57, 0xd943b621131898a9
d_4_24:         .dword 0x85c144b35b51221b, 0x3ceecd414725f210
d_4_25:         .dword 0x0d4df669de31a151, 0xb7fd64d97c36a911
d_4_26:         .dword 0x735db15121fe3cdf, 0x3eb10536f8b21c8e
d_4_27:         .dword 0x74928a900bddc321, 0xd84cb460845b4aca
                .dword 0x379bb21ca81d13b1, 0x11609ce3eb2f4186
                .dword 0x1ea23398a8d900f4, 0xf3f2dfc36a1650bc
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x1d929068f0ea8bbf, 0x7772d88e58af15ec
                .dword 0x88405ebcef6b74d2, 0xe347c17e1af0674f
d_5_0:          .dword 0x7671fccf44006cc8, 0x56294f4a84a30389
d_5_1:          .dword 0x7925136a67fc861e, 0x35d3e117f63fd01c
d_5_2:          .dword 0xe4b97a2e4565a475, 0xb8c5e5e8a9ea7618
d_5_3:          .dword 0xa863b3d4eebdcca8, 0x629ab683805a9afa
d_5_4:          .dword 0x681cde1ad7ce5a9f, 0xb8f5ce8e398e9b89
d_5_5:          .dword 0x5eb003aaa1c1a443, 0x2c23f4049dc58004
d_5_6:          .dword 0xa4d7408c19660b35, 0x7ce7f1294b9fa8a1
d_5_7:          .dword 0xc2d04a0f053926db, 0x0a0a208de2461a71
d_5_8:          .dword 0x670180ed588124f4, 0x3c04e040b6bb5bdd
d_5_9:          .dword 0x7f6846993d56797b, 0x5cb3875f97e16a61
d_5_10:         .dword 0xf865658c479aa60f, 0x9656034bed5cbf92
d_5_11:         .dword 0xf68e80b295948e6d, 0x0aec0c24d0f585c2
d_5_12:         .dword 0x99ef4d07c557ecde, 0x230c695b6f014001
d_5_13:         .dword 0xe74af0551da1ccd4, 0x910a3744699ce05a
d_5_14:         .dword 0x39a19d3408eabec7, 0x3409a752529c8631
d_5_15:         .dword 0xfda3a90dd5a0ce6f, 0x3406e993ca34cbec
d_5_16:         .dword 0x99deb49e34efbfc2, 0x4b3094d53f249af4
d_5_17:         .dword 0xa0d0ed93fe5d0478, 0x64faf737de41f662
d_5_18:         .dword 0x0f5992ee5172cf47, 0x197a282bde8b2723
d_5_19:         .dword 0xd7e5b09592885ebd, 0x8daca6588091eb73
d_5_20:         .dword 0xd590e88f980c65ee, 0xf364fc33615b7f60
d_5_21:         .dword 0x0a6c2c3c97ab8c20, 0x3e5e5c82cd7e125c
d_5_22:         .dword 0x2e531bef0ea2f99d, 0xeaef14bb2db2afe2
d_5_23:         .dword 0xa60ac762efe3ceb6, 0x513592774552675e
d_5_24:         .dword 0xad775d8f78699b1b, 0x5954be856599dacd
d_5_25:         .dword 0x8be41ff4f4480bf9, 0x995279381610ddb2
d_5_26:         .dword 0x91d7239708858270, 0x30ad4021cdda02af
d_5_27:         .dword 0x040eb4e873bbfbc0, 0xfd18cfd3db573512
                .dword 0x6c4445feaf62a29c, 0xdecdcd3df22e2a6e
                .dword 0xd2ef14cffc35f617, 0xbdbc4c38eb11ee8c
         /* Random data */
_end_data5:
              
 
