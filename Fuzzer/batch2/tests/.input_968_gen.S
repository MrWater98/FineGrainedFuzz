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
_p0:    csrrwi x11, sscratch, 11                  ;
_p1:    csrrsi x11, frm, 0                        ;
_p2:    csrrci x12, frm, 24                       ;
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
_s0:    divu x21, x5, x0                          ;
_s1:    fmin.s f19, f26, f29                      ;
_s2:    fcvt.l.s x1, f21, rdn                     ;
_s3:    fsub.s f3, f18, f30, rup                  ;
_s4:    bge x10, x18, _s5                         ;
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
_l0:    fclass.s x2, f28                          ;
_l1:    la x27, d_5_15                            ;
        addi x27, x27, -28                        ;
        amoxor.w x10, x5, (x27)                   ;
_l2:    bge x28, x7, _l46                         ;
_l3:    bne x26, x2, _l54                         ;
_l4:    ecall                                     ;
_l5:    fadd.s f26, f26, f19, dyn                 ;
_l6:    ebreak                                    ;
_l7:    la x21, _l76                              ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l8:    csrrci x3, fflags, 18                     ;
_l9:    csrrwi x8, pmpaddr6, 18                   ;
_l10:   slli x1, x11, 61                          ;
_l11:   la x23, d_4_20                            ;
        addi x23, x23, 16                         ;
        amomaxu.d x25, x11, (x23)                 ;
_l12:   la x20, d_2_15                            ;
        addi x20, x20, -16                        ;
        lui x28, 0xffe00                          ;
        xor x20, x20, x28                         ;
        amomax.d x10, x28, (x20)                  ;
_l13:   fence                                     ;
_l14:   mulhu x26, x9, x15                        ;
_l15:   andi x6, x12, -1522                       ;
_l16:   ecall                                     ;
_l17:   la x21, _l112                             ;
        csrrw zero, sepc, x21                     ;
        sret                                      ;
_l18:   la x20, d_0_22                            ;
        flw f19, 0(x20)                           ;
_l19:   fmv.x.w x27, f19                          ;
_l20:   fmax.s f28, f23, f26                      ;
_l21:   la x20, d_1_12                            ;
        sw x18, -8(x20)                           ;
_l22:   addw x20, x24, x17                        ;
_l23:   la x27, d_2_23                            ;
        addi x27, x27, 8                          ;
        amoor.d x25, x9, (x27)                    ;
_l24:   fmin.s f21, f0, f13                       ;
_l25:   srai x22, x15, 61                         ;
_l26:   la x17, d_2_25                            ;
        addi x17, x17, 8                          ;
        amoor.w x23, x13, (x17)                   ;
_l27:   fmul.s f3, f6, f0, rmm                    ;
_l28:   fcvt.l.s x22, f5, rdn                     ;
_l29:   fsub.s f19, f11, f2, rtz                  ;
_l30:   fcvt.wu.s x23, f3, rup                    ;
_l31:   bge x26, x18, _l75                        ;
_l32:   fsgnjx.s f20, f0, f1                      ;
_l33:   fmsub.s f17, f23, f25, f27, rne           ;
_l34:   bge x19, x28, _l59                        ;
_l35:   fle.s x29, f0, f5                         ;
_l36:   flt.s x27, f19, f10                       ;
_l37:   feq.s x7, f25, f17                        ;
_l38:   jal x17, _l145                            ;
_l39:   fle.s x21, f0, f30                        ;
_l40:   mulhsu x16, x17, x0                       ;
_l41:   jal x1, _l105                             ;
_l42:   divw x9, x11, x3                          ;
_l43:   fdiv.s f1, f5, f8, rmm                    ;
_l44:   fadd.s f30, f26, f0, rtz                  ;
_l45:   fcvt.w.s x10, f26, rdn                    ;
_l46:   fsgnjn.s f3, f18, f15                     ;
_l47:   la x1, d_2_18                             ;
        addi x1, x1, -8                           ;
        amominu.w x27, x27, (x1)                  ;
_l48:   la x13, _l152                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l49:   fcvt.s.lu f12, x12, dyn                   ;
_l50:   la x20, _l26                              ;
        lw x4, 28(x20)                            ;
_l51:   ori x20, x19, -18                         ;
_l52:   la x24, d_4_0                             ;
        sh x12, -30(x24)                          ;
_l53:   sllw x8, x17, x27                         ;
_l54:   xor x19, x19, x19                         ;
        addi x16, zero, 3                         ;
        slli x16, x16, 26                         ;
        add x19, x19, x16                         ;
        csrrw x7, mscratch, x19                   ;
_l55:   addi x0, x12, 422                         ;
_l56:   addi x11, x20, -2047                      ;
_l57:   la x26, d_3_17                            ;
        sh x4, 0(x26)                             ;
_l58:   la x6, d_0_6                              ;
        addi x6, x6, -28                          ;
        amoor.w x9, x11, (x6)                     ;
_l59:   fsub.s f29, f18, f10, rdn                 ;
_l60:   la x8, d_5_3                              ;
        addi x8, x8, -16                          ;
        sc.d x26, x8, (x8)                        ;
_l61:   la x8, d_2_13                             ;
        sb x16, 9(x8)                             ;
_l62:   la x13, _l121                             ;
        csrrw zero, uepc, x13                     ;
        uret                                      ;
_l63:   csrrsi x21, mepc, 26                      ;
_l64:   fle.s x4, f10, f18                        ;
_l65:   la x26, d_3_14                            ;
        addi x26, x26, 28                         ;
        amoadd.w x9, x16, (x26)                   ;
_l66:   fmsub.s f16, f23, f15, f23, rup           ;
_l67:   bge x4, x11, _l179                        ;
_l68:   xori x2, x29, -151                        ;
_l69:   la x8, d_4_3                              ;
        addi x8, x8, 28                           ;
        amomaxu.w x7, x21, (x8)                   ;
_l70:   la x3, d_3_21                             ;
        addi x3, x3, 24                           ;
        amomaxu.w x6, x11, (x3)                   ;
_l71:   fmin.s f29, f2, f30                       ;
_l72:   la x29, d_3_0                             ;
        lui x3, 0xffe00                           ;
        xor x29, x29, x3                          ;
        flw f30, -28(x29)                         ;
_l73:   fclass.s x4, f17                          ;
_l74:   la x9, _l88                               ;
        jalr x9, 0(x9)                            ;
_l75:   fcvt.s.lu f31, x0, rne                    ;
_l76:   addiw x18, x10, 1938                      ;
_l77:   fmin.s f8, f4, f27                        ;
_l78:   fsgnj.s f12, f13, f6                      ;
_l79:   la x12, d_3_13                            ;
        addi x12, x12, -8                         ;
        amomax.d x29, x27, (x12)                  ;
_l80:   fclass.s x15, f15                         ;
_l81:   bltu x20, x9, _l118                       ;
_l82:   fmin.s f24, f3, f11                       ;
_l83:   la x15, d_3_27                            ;
        addi x15, x15, 4                          ;
        lui x9, 0xffe00                           ;
        xor x15, x15, x9                          ;
        amoand.w x26, x9, (x15)                   ;
_l84:   flt.s x27, f29, f15                       ;
_l85:   la x5, d_2_25                             ;
        sd x10, 24(x5)                            ;
_l86:   la x19, d_0_27                            ;
        addi x19, x19, 8                          ;
        lui x18, 0xffe00                          ;
        xor x19, x19, x18                         ;
        amomin.d x2, x18, (x19)                   ;
_l87:   la x24, d_3_2                             ;
        addi x24, x24, -24                        ;
        sc.d x28, x24, (x24)                      ;
_l88:   srli x29, x0, 37                          ;
_l89:   fence.i                                   ;
_l90:   la x29, d_5_21                            ;
        addi x29, x29, 16                         ;
        lr.d x8, (x29)                            ;
_l91:   fmv.w.x f3, x15                           ;
_l92:   lui x27, 594441                           ;
_l93:   la x22, _l100                             ;
        csrrw zero, mepc, x22                     ;
        mret                                      ;
_l94:   xor x30, x30, x30                         ;
        addi x15, zero, 3                         ;
        slli x15, x15, 18                         ;
        add x30, x30, x15                         ;
        csrrw x1, mhartid, x30                    ;
_l95:   la x17, _l49                              ;
        lwu x22, -0(x17)                          ;
_l96:   fsgnj.s f15, f23, f2                      ;
_l97:   fsqrt.s f28, f14, dyn                     ;
_l98:   la x29, _l118                             ;
        jalr x12, 0(x29)                          ;
_l99:   fdiv.s f7, f28, f23, dyn                  ;
_l100:  li x6, 1                                  ;
        la x28, pt0                               ;
        addi x28, x28, 24                         ;
        sfence.vma x6, x28                        ;
_l101:  fcvt.s.lu f20, x16, rne                   ;
_l102:  bltu x12, x19, _l172                      ;
_l103:  li x25, 0                                 ;
        la x30, pt2                               ;
        addi x30, x30, 0                          ;
        sfence.vma x25, x30                       ;
_l104:  la x10, d_5_14                            ;
        sw x25, 16(x10)                           ;
_l105:  fadd.s f25, f2, f13, rne                  ;
_l106:  fcvt.s.lu f3, x24, dyn                    ;
_l107:  fcvt.s.wu f26, x26, rmm                   ;
_l108:  fcvt.w.s x20, f17, rne                    ;
_l109:  fence.i                                   ;
_l110:  la x9, d_5_0                              ;
        addi x9, x9, 12                           ;
        amominu.w x28, x20, (x9)                  ;
_l111:  li x24, 0                                 ;
        la x2, pt0                                ;
        addi x2, x2, 24                           ;
        sfence.vma x24, x2                        ;
_l112:  fcvt.lu.s x12, f14, rup                   ;
_l113:  fle.s x26, f25, f14                       ;
_l114:  mulh x25, x22, x19                        ;
_l115:  fcvt.s.l f18, x3, rmm                     ;
_l116:  la x11, d_0_9                             ;
        sb x28, 1(x11)                            ;
_l117:  la x22, d_0_26                            ;
        fsw f3, 28(x22)                           ;
_l118:  fence                                     ;
_l119:  mulw x13, x8, x23                         ;
_l120:  fdiv.s f6, f4, f1, rne                    ;
_l121:  fadd.s f5, f1, f2, rup                    ;
_l122:  la x9, _l169                              ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l123:  divu x13, x30, x26                        ;
_l124:  la x27, d_4_4                             ;
        sb x21, 29(x27)                           ;
_l125:  la x21, d_2_13                            ;
        addi x21, x21, -8                         ;
        amoor.w x4, x12, (x21)                    ;
_l126:  fsgnjn.s f13, f6, f30                     ;
_l127:  divuw x22, x2, x20                        ;
_l128:  remw x27, x20, x17                        ;
_l129:  slliw x11, x14, 27                        ;
_l130:  fcvt.wu.s x9, f9, rdn                     ;
_l131:  xori x4, x0, -645                         ;
_l132:  la x25, d_3_12                            ;
        addi x25, x25, 12                         ;
        amominu.w x23, x27, (x25)                 ;
_l133:  srli x12, x14, 59                         ;
_l134:  csrrsi x3, medeleg, 6                     ;
_l135:  feq.s x10, f15, f10                       ;
_l136:  ecall                                     ;
_l137:  la x17, d_3_14                            ;
        addi x17, x17, 24                         ;
        amomax.d x4, x15, (x17)                   ;
_l138:  la x20, _l184                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l139:  fle.s x10, f20, f19                       ;
_l140:  la x10, d_5_9                             ;
        addi x10, x10, -12                        ;
        lr.w x19, (x10)                           ;
_l141:  remu x24, x25, x0                         ;
_l142:  la x14, _l144                             ;
        csrrw zero, uepc, x14                     ;
        uret                                      ;
_l143:  fmax.s f14, f1, f28                       ;
_l144:  fsqrt.s f8, f10, rne                      ;
_l145:  fence.i                                   ;
_l146:  xori x25, x24, 939                        ;
_l147:  fcvt.w.s x3, f18, rne                     ;
_l148:  la x27, d_2_9                             ;
        addi x27, x27, 24                         ;
        amoadd.w x9, x20, (x27)                   ;
_l149:  fmin.s f29, f23, f29                      ;
_l150:  srli x7, x14, 23                          ;
_l151:  fcvt.s.wu f12, x24, rdn                   ;
_l152:  fnmsub.s f14, f24, f24, f7, rtz           ;
_l153:  fence                                     ;
_l154:  andi x17, x11, -1621                      ;
_l155:  la x11, d_4_19                            ;
        lbu x28, 5(x11)                           ;
_l156:  auipc x23, 11                             ;
_l157:  la x1, d_3_15                             ;
        srai x1, x1, 1                            ;
        csrrw x29, pmpaddr1, x1                   ;
_l158:  xor x1, x1, x1                            ;
        csrrw x15, pmpcfg0, x1                    ;
_l159:  fcvt.s.w f5, x8, rup                      ;
_l160:  la x27, d_5_4                             ;
        lh x27, 0(x27)                            ;
_l161:  fsqrt.s f15, f5, rdn                      ;
_l162:  fsgnjx.s f1, f18, f26                     ;
_l163:  bgeu x23, x10, _l172                      ;
_l164:  fsub.s f23, f4, f4, dyn                   ;
_l165:  rem x0, x14, x13                          ;
_l166:  fence                                     ;
_l167:  la x9, d_1_10                             ;
        addi x9, x9, 0                            ;
        amomin.d x19, x9, (x9)                    ;
_l168:  la x18, d_0_18                            ;
        addi x18, x18, -0                         ;
        amomin.d x28, x7, (x18)                   ;
_l169:  fsgnjx.s f1, f24, f5                      ;
_l170:  addi x17, x10, -151                       ;
_l171:  fcvt.lu.s x20, f3, rmm                    ;
_l172:  mul x9, x1, x20                           ;
_l173:  la x19, d_5_18                            ;
        sb x3, -17(x19)                           ;
_l174:  la x12, d_3_12                            ;
        addi x12, x12, 0                          ;
        amomaxu.w x30, x5, (x12)                  ;
_l175:  fence                                     ;
_l176:  mulhsu x23, x11, x2                       ;
_l177:  fmadd.s f27, f5, f18, f0, rne             ;
_l178:  la x9, _l200                              ;
        csrrw zero, uepc, x9                      ;
        uret                                      ;
_l179:  addi x9, x29, 2047                        ;
_l180:  la x8, d_4_6                              ;
        addi x8, x8, -16                          ;
        amoxor.d x10, x12, (x8)                   ;
_l181:  fcvt.w.s x4, f3, rmm                      ;
_l182:  bgeu x11, x2, _l187                       ;
_l183:  la x13, d_3_24                            ;
        sd x11, -8(x13)                           ;
_l184:  fcvt.s.wu f19, x25, rdn                   ;
_l185:  fnmadd.s f31, f25, f24, f28, dyn          ;
_l186:  mulw x13, x5, x5                          ;
_l187:  slliw x3, x20, 18                         ;
_l188:  fcvt.s.wu f26, x5, rmm                    ;
_l189:  srliw x27, x16, 12                        ;
_l190:  subw x19, x16, x15                        ;
_l191:  mulh x5, x20, x28                         ;
_l192:  fence                                     ;
_l193:  fsgnjn.s f2, f31, f17                     ;
_l194:  slliw x8, x26, 29                         ;
_l195:  fmv.x.w x26, f11                          ;
_l196:  la x4, d_2_27                             ;
        addi x4, x4, 0                            ;
        amominu.w x7, x6, (x4)                    ;
_l197:  fmul.s f23, f25, f27, rdn                 ;
_l198:  mulhu x0, x8, x6                          ;
_l199:  fmax.s f2, f22, f26                       ;
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
                .dword 0x376e69c614c3faff, 0xb1475817ef295d16
                .dword 0x81b613a5ce559457, 0x07940980612ced3b
d_0_0:          .dword 0xab22342935f5926d, 0x9ea86d0a404deabf
d_0_1:          .dword 0xd04fb1b4cc6bf48c, 0x547627890a39f4f3
d_0_2:          .dword 0x11c7e8c59a99d2d0, 0x1c3da876a20bbb3e
d_0_3:          .dword 0xf80177ed2a667583, 0xe3f7cf70ed379971
d_0_4:          .dword 0x32da04a88924266e, 0xfd85ffb4f4de2200
d_0_5:          .dword 0x7b134ae2f73d37ab, 0x82c6f23832ab76bd
d_0_6:          .dword 0xb929d1d9edf5691e, 0xae99259c42faf198
d_0_7:          .dword 0x6bf0563185b9d338, 0x0931954434312d15
d_0_8:          .dword 0x1d90bce6799acabb, 0xc133c060af13d030
d_0_9:          .dword 0x182614560e41fa93, 0x764f33f8f45186ed
d_0_10:         .dword 0xe72170e343a4dcfd, 0xa217f197386bfdd1
d_0_11:         .dword 0x2e92989497b5e055, 0x694ecb9948fe1bf1
d_0_12:         .dword 0x9c73640d3f1c51d4, 0x5ed6583e0ab74570
d_0_13:         .dword 0x752739b537682771, 0xd22819723c57d292
d_0_14:         .dword 0x2a407c7d269f155a, 0x64c27bd631d7eba1
d_0_15:         .dword 0x6c565520d5bffe48, 0xc88beb604e3ad1ce
d_0_16:         .dword 0x3955ae9fb4f92955, 0x77c278bb288650cc
d_0_17:         .dword 0x2bb5942822ec5ea2, 0x3b8a17996a9726a1
d_0_18:         .dword 0x46a5fa655f6a4f48, 0x991153524bdea8cf
d_0_19:         .dword 0x66fd7987e8065134, 0x550583b68b9a1355
d_0_20:         .dword 0xfce3b8f3af7d066e, 0xee0282252be4c811
d_0_21:         .dword 0x1243e12ca668810d, 0x59d10b3d8594bb4f
d_0_22:         .dword 0x1d0d7e0a289ef60d, 0x0d3f6275f02d85c4
d_0_23:         .dword 0x61a608c9d32e1a0d, 0xcd04e985c9cfc7dd
d_0_24:         .dword 0xb74df1129eee9078, 0x15124d4e59153d0e
d_0_25:         .dword 0xdb8932d1ed1a8766, 0x92ae2bf27f4a7b08
d_0_26:         .dword 0x87e0ee539f41a2c2, 0x2185ffb6190ca3de
d_0_27:         .dword 0x67a273855bad2f65, 0x398a81782b6ac10f
                .dword 0xfee2cb64535b0291, 0x41dfefac53518b58
                .dword 0xc7f98f94e3b032d4, 0x7942ae329aad614a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa14a26204d377998, 0x1c3f75aea5cb0e24
                .dword 0x3f11e0b2de418cd9, 0x1e09580122d29185
d_1_0:          .dword 0x2ba781f617d4415b, 0x790a8ad6c20a8435
d_1_1:          .dword 0x44750eb3e976ff79, 0x2df499ec3f552187
d_1_2:          .dword 0x698e402c141cc6e6, 0xcb01dff70bda5425
d_1_3:          .dword 0xb57e1afe0ae2f52b, 0x73b5d8ce3c5acafe
d_1_4:          .dword 0x64ed248ed77ad80f, 0x55d41ceb9ac2d35a
d_1_5:          .dword 0x0113b70c30772b44, 0xd82934a8173d2d88
d_1_6:          .dword 0x7d5ac4ad61ed1883, 0x62d1da82dc79a089
d_1_7:          .dword 0x593b9a82d3bfb3bf, 0x86d1f054d7c2f5c6
d_1_8:          .dword 0x21d6b768fc6051db, 0x409c348a0f6a2c53
d_1_9:          .dword 0xe412a5a4c2a606b7, 0xc006d7853ac2b949
d_1_10:         .dword 0xf15c912514cd6a54, 0x2b4e4329409800e2
d_1_11:         .dword 0xac565cd189996dde, 0xc3d932017ba297b8
d_1_12:         .dword 0xa462d37d45a4344a, 0x01e3bf0b44f9e36b
d_1_13:         .dword 0x3ab3c835607143a3, 0xd52719d594d90969
d_1_14:         .dword 0xc5919447f49a384f, 0xad7915c3a9f60673
d_1_15:         .dword 0xb5b7caeca66ecaa9, 0x22f2e89110b92700
d_1_16:         .dword 0xf3399f84a3b8f5b0, 0xdbd30fc1895bdd0b
d_1_17:         .dword 0xd33f3e8b18122e94, 0xc68ade96c5e2c065
d_1_18:         .dword 0xc62d25f37da87df5, 0x5723ca7afa556bcd
d_1_19:         .dword 0x1746e74aa4a5fcef, 0x2089f58284afa6c0
d_1_20:         .dword 0x4eaade258746df5c, 0x94b88d2d5afb404d
d_1_21:         .dword 0x80134dffc4d6f286, 0xa9c2d0abcd48a127
d_1_22:         .dword 0xe4bd05afd625c109, 0x95a9e594c3bc65d6
d_1_23:         .dword 0xcb9b5f6c29bf95d8, 0x139ccb0d6ddc761a
d_1_24:         .dword 0xbc4892787e29cf07, 0xbd4ff329c8a0d96c
d_1_25:         .dword 0xe3fb9b5e74443495, 0xf0f8f6ec6fbd7642
d_1_26:         .dword 0x2086880fdd56e4c5, 0x4917968ec08feb17
d_1_27:         .dword 0x39408a3ee4e3db0a, 0x3208791f80db3718
                .dword 0x577a4c716461906b, 0x1352f834415e235f
                .dword 0x57364fde70799e2c, 0x01a4856d040e2492
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc999dfa980e20f07, 0x593f77c969cd4a79
                .dword 0xf39d97b0044b6864, 0x9635be80cd091d54
d_2_0:          .dword 0x0db8d6100e91b442, 0x7effedaa5717f070
d_2_1:          .dword 0x64b76d65376ef126, 0xf5e9e453ebe406eb
d_2_2:          .dword 0xb1a6652462368bd8, 0x473683faa909ab45
d_2_3:          .dword 0xc66b5df605344a61, 0xa840676fdb265543
d_2_4:          .dword 0xee0b930d2ec99a48, 0x691dd5431f40dcf9
d_2_5:          .dword 0xf2678142306e87e8, 0x103166672a0edaa9
d_2_6:          .dword 0xb5ea8ba37c7b025b, 0x5a9e8c9c145a711d
d_2_7:          .dword 0xa2fc4331f092893f, 0x787b815308fb4b57
d_2_8:          .dword 0x98462cd48eb9499b, 0x64717c9ccc07ab81
d_2_9:          .dword 0x36aa0338e22098f2, 0xe7b003cd8598704f
d_2_10:         .dword 0x3a556c402a008d9e, 0x3b4b915bf6117aba
d_2_11:         .dword 0x59d63e644feed005, 0x6ab2cc31ea5291b4
d_2_12:         .dword 0xf0dee562abeaec34, 0xc6d55a622b93aa84
d_2_13:         .dword 0x7d8914cbfb15ad4d, 0xf54c73a6bc9e63ed
d_2_14:         .dword 0xd68bccf0e15ec62b, 0x40ec5d985eae0220
d_2_15:         .dword 0xa7ad5ae25a359c2e, 0xe5d519f723218875
d_2_16:         .dword 0x6f5e89d8cea99cf7, 0xda1fdffe7ef91e9f
d_2_17:         .dword 0x2e792ecd96c123c1, 0x7f1d4ed577858f9c
d_2_18:         .dword 0xc154d6b80da7d6a5, 0xa31a3321fd47bf33
d_2_19:         .dword 0xe0085d1f916ddc42, 0x83cc5728a3e6ea19
d_2_20:         .dword 0x2bd6a44646d3df73, 0x1d671388db9a65e2
d_2_21:         .dword 0x5da7a2e8ff929cc4, 0x14b71049d5061d94
d_2_22:         .dword 0x625a55c9eaeba1de, 0xb6f153aba5818f3b
d_2_23:         .dword 0xa312461130278521, 0x9e10e3c973753bda
d_2_24:         .dword 0xa04efedb57b13dd8, 0x904b263a0521d476
d_2_25:         .dword 0x1ed54fa2870795a9, 0x4fee45fe8a395d33
d_2_26:         .dword 0x07adf5756e803d20, 0x13303520dbb1d25e
d_2_27:         .dword 0x14bbbc710f712897, 0x871b28d3f0594e1c
                .dword 0x4f432f286ca524e9, 0xf66a3c00bc267ce1
                .dword 0x2fb8e7f7a0e2d711, 0x372f485625b13a6b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x143e78d8c57e91f8, 0xb11e3e8c7e2aa63c
                .dword 0xb796eda8ff2012ea, 0xfe4f8d6edc6e370e
d_3_0:          .dword 0x6472cad90a2632c2, 0x6f922b4a65c889d5
d_3_1:          .dword 0x8fb6040b8d439e45, 0x46b7d079d08caeb1
d_3_2:          .dword 0xf2d012f1de5f8179, 0x938ceafdb7e49d4e
d_3_3:          .dword 0x4c2de2e66b81b319, 0x66c3665afb53ced5
d_3_4:          .dword 0xe24bd98094eee5b2, 0xdfc5c89e87a47201
d_3_5:          .dword 0x9b51aad38290e149, 0xf28bd1bcf92584f7
d_3_6:          .dword 0x9dc6ee8e8e9668ed, 0xcd61bce6041a075d
d_3_7:          .dword 0x72016bcad28c4182, 0xa5371f612c24dc16
d_3_8:          .dword 0x1e678eb7a963bac1, 0x06ee7be4d91fc1cb
d_3_9:          .dword 0x8e55c1c0150afeee, 0x3b93fbecdd438841
d_3_10:         .dword 0x2d3129a8df06b135, 0xa9622a97a1c238cc
d_3_11:         .dword 0xf090743a859e1a86, 0x18aff9ffc1fb436f
d_3_12:         .dword 0x2668ab49556593b8, 0x480a403cde68977c
d_3_13:         .dword 0x9a1f89a69aea0700, 0xdf258f8a21a24a22
d_3_14:         .dword 0xf841a69f710859d6, 0x7e43da8925b696d7
d_3_15:         .dword 0x34306f7329f22a36, 0xc93bc43ae126399b
d_3_16:         .dword 0x0a4795afc94e8699, 0xc5eda07451298983
d_3_17:         .dword 0x305b12aab05b988a, 0xd26bfaba93c120de
d_3_18:         .dword 0x75b90c45041c120b, 0xc3bc002bcde4b186
d_3_19:         .dword 0x48d77a4b6d9a978a, 0x0269dd41654f69fd
d_3_20:         .dword 0x36e2a5f6f677f001, 0x55b2f13bf42dbe88
d_3_21:         .dword 0xa631ab809deaf157, 0x524d4db92b1729e0
d_3_22:         .dword 0xe26fc262e47fd76e, 0x0ca1f3125413e213
d_3_23:         .dword 0xfbf76a5b1c828ecd, 0xdcbb53e7b46fb46b
d_3_24:         .dword 0x714988e0e40161fe, 0xe5e33f3e460b816e
d_3_25:         .dword 0x81a8763dbe604951, 0x33ead0e19a30a9fc
d_3_26:         .dword 0xeaa43f0b810e6ad7, 0x477021cd9c89ef8b
d_3_27:         .dword 0xeea9851c3c13a328, 0x2324dae4a721d9ec
                .dword 0x0bb76ca667c93af4, 0x0094af083f8d6832
                .dword 0xc9e0aac04a5a6fd8, 0x6797ac46fb2e4e08
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x9c9396e878f1b169, 0x61519170e56439aa
                .dword 0xa63c96a574fa1218, 0x21fa7faf931cc00f
d_4_0:          .dword 0x71c1d9a8f8c813b5, 0x67b84a5bb9da208a
d_4_1:          .dword 0xf74f92f32d111fff, 0xa4dc1b19a618721b
d_4_2:          .dword 0xe11d089bd0f04518, 0xf37cb83494905d12
d_4_3:          .dword 0x8951142547410a1f, 0xaa5d99daa3ffd702
d_4_4:          .dword 0xfd4e9b59995586cf, 0x02170a4953f6d3ec
d_4_5:          .dword 0x7264cda6345e0fc7, 0x2a51ffd2a4b198a9
d_4_6:          .dword 0x69b6ef41b0caa7da, 0xbcf46057e2a9acf6
d_4_7:          .dword 0x7fa7a5001578a6c2, 0xa1a38df414d7ef9e
d_4_8:          .dword 0xe06a0197ca4d5037, 0xa6967c8e2ba4b19d
d_4_9:          .dword 0x91b2bc158325b966, 0xb22175c70e1bec7d
d_4_10:         .dword 0xd4b8ad47381621fc, 0x498489683b1cd752
d_4_11:         .dword 0x5af428e7131ed0bf, 0xfab24e3a031ec36d
d_4_12:         .dword 0xe0ca4bcf99e045a9, 0x76b54b2a9208b306
d_4_13:         .dword 0x819955ca1e25cd5a, 0x2d75257135a78e60
d_4_14:         .dword 0x4f23654b91cb5720, 0xd5e011cdebd715cc
d_4_15:         .dword 0x6d5587a20c70a9eb, 0x78eb55ec48449ce3
d_4_16:         .dword 0x03eb93944238dbd3, 0xf195ea47bb98e6f0
d_4_17:         .dword 0x1643dcdbba75951d, 0x4966ad438fd7b6c7
d_4_18:         .dword 0x98c7ce717c17dd93, 0x60c8e3f2c25ae517
d_4_19:         .dword 0xb9c52d43abdd8aba, 0x23f5c1ae6b3adb53
d_4_20:         .dword 0xf4046e72ec3fc44a, 0xa4184f9a6e083e1f
d_4_21:         .dword 0x00fd86093c02241b, 0x6ebf85f5b2bee115
d_4_22:         .dword 0x73b617038ab209a3, 0xf24ff8e68ec893b7
d_4_23:         .dword 0x1edcd86f6fa8940c, 0x6d9fe1fcc13df407
d_4_24:         .dword 0xcd4ec4c213458a98, 0xf3b8aa9cdbe415ad
d_4_25:         .dword 0x2c9eba4f02ddab58, 0x717b035c913b4e13
d_4_26:         .dword 0x31ac014479c5c9b3, 0x0b7d567ec6ecb74b
d_4_27:         .dword 0xd75cce52922eaa4f, 0x2cc8d6c6ab65f809
                .dword 0x50c2422bd1aa587e, 0xaf919e0a47a7ef26
                .dword 0x31d999fb27d26b3d, 0xa43ca493ec84c13f
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x983642530f30596a, 0xbf08d5fa33a34a47
                .dword 0xbfc7332c0757f4cf, 0x408c0c1215bbdacd
d_5_0:          .dword 0xa172f995444441d1, 0x948c45f6ef7a63aa
d_5_1:          .dword 0xff36124033a0880d, 0xb7172615fc88311e
d_5_2:          .dword 0x7066a281a6dabe81, 0xc0b9f6b4b3d072c4
d_5_3:          .dword 0x2ea4e0ce01626bf6, 0x9d7a441e000ebc25
d_5_4:          .dword 0xbf781ce8645d7532, 0x092d53599b66337b
d_5_5:          .dword 0xc941397d45bd2177, 0x37b36e75bef6176e
d_5_6:          .dword 0x6fd52ea89c6d17ef, 0xe31ae21c1a3e08a5
d_5_7:          .dword 0x60201781d9549132, 0x473d03e3d5b0cfa0
d_5_8:          .dword 0x5763a64f1bb1a407, 0x76fdaffb53bde65d
d_5_9:          .dword 0x5e0e850397c0a876, 0x77e6bcfc001f5e1f
d_5_10:         .dword 0x34e54f882e1b9d9c, 0x5f0b612c12f5440b
d_5_11:         .dword 0x91139cfbbcdd9ca4, 0x9df1bcb0e71f7ff3
d_5_12:         .dword 0xa877f2177ab40751, 0x49825b391bb4e43b
d_5_13:         .dword 0x0be9b2f6b0fcdee1, 0x524607550747ab6b
d_5_14:         .dword 0xcc8fc4d45505f952, 0xe04cc64ec0da0066
d_5_15:         .dword 0x06fbea25676fcea9, 0x27292e94eb3e89e3
d_5_16:         .dword 0xc1454d556fa406b5, 0x1ee802fa8b3ed407
d_5_17:         .dword 0x5b379ba57c678507, 0x23736fce46439929
d_5_18:         .dword 0x29ba7ecf545d1f1e, 0x9f0fc694768c5fdf
d_5_19:         .dword 0x0aa9857418477ada, 0x48cb4dbac4802611
d_5_20:         .dword 0x550cddc3f9920590, 0xc2c70f33907801f5
d_5_21:         .dword 0xf7934b57d001286f, 0xb8d5a636fff561fe
d_5_22:         .dword 0x914e4c4739149784, 0x90b2209d33a3a8b7
d_5_23:         .dword 0xb0801394319ba72a, 0x4280fad3ed4046db
d_5_24:         .dword 0x9d0da35a8762f4db, 0xb6cb0c277c7db3b9
d_5_25:         .dword 0xd255f2d92f967ccf, 0x6de84bde7d36e9c0
d_5_26:         .dword 0xe177afaddb5e491f, 0x0fe2c0221ccf9d47
d_5_27:         .dword 0xb1548d8a3dc5a73a, 0x2c75374b6759461a
                .dword 0xed7cfffb335ab43f, 0xe1001e5318510c33
                .dword 0x3b206417bbaf931f, 0x89a2f54c18c0cfaf
         /* Random data */
_end_data5:
              
 
