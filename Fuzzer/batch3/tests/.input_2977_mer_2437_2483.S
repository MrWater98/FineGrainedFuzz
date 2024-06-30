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
_p0:    la x12, _p1                                       ;
        srai x12, x12, 1                          ;
        csrrw x10, pmpaddr4, x12                  ;
_p1:    csrrsi x11, medeleg, 6                    ;
_p2:    csrrwi x12, mip, 0                        ;
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
_s0:    la x15, _s0                                       ;
        srai x15, x15, 1                          ;
        csrrs x15, pmpaddr3, x15                  ;
_s1:    la x4, _s2                                ;
        jalr x30, 0(x4)                           ;
_s2:    fmin.s f11, f19, f4                       ;
_s3:;
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
_l0:    remw x27, x6, x10                         ;
_l1:    srli x28, x19, 0                          ;
_l2:    la x5, _l42                                       ;
        flw f23, 12(x5)                           ;
_l3:    la x22, d_3_11                            ;
        addi x22, x22, 0                          ;
        amominu.d x1, x16, (x22)                  ;
_l4:    la x14, d_0_10                            ;
        addi x14, x14, -4                         ;
        amoor.w x9, x19, (x14)                    ;
_l5:    div x22, x26, x26                         ;
_l6:    fcvt.l.s x24, f20, rmm                    ;
_l7:    auipc x10, 1048575                        ;
_l8:    fmv.x.w x19, f18                          ;
_l9:    div x24, x17, x26                         ;
_l10:   csrrsi x19, mhartid, 0                    ;
_l11:   beq x13, x21, _l69                                ;
_l12:   xori x19, x5, -655                        ;
_l13:   lui x14, 466617                           ;
_l14:   la x25, d_4_13                            ;
        addi x25, x25, -8                         ;
        lr.d x21, (x25)                           ;
_l15:   la x22, d_3_21                            ;
        addi x22, x22, -16                        ;
        amoswap.d x19, x29, (x22)                 ;
_l16:   fsgnjx.s f10, f10, f6                     ;
_l17:   srlw x28, x16, x28                        ;
_l18:   fcvt.wu.s x16, f17, rne                   ;
_l19:   csrrwi x5, frm, 0                         ;
_l20:   bge x10, x13, _l63                                ;
_l21:   fcvt.s.wu f20, x11, dyn                   ;
_l22:   fmv.x.w x9, f11                           ;
_l23:   fcvt.l.s x17, f4, dyn                     ;
_l24:   la x1, d_1_11                             ;
        fsw f11, 16(x1)                           ;
_l25:   sllw x10, x3, x3                          ;
_l26:   fsgnjn.s f20, f20, f16                    ;
_l27:   la x13, d_3_11                            ;
        addi x13, x13, -28                        ;
        amoand.w x27, x4, (x13)                   ;
_l28:   la x9, d_3_22                             ;
        addi x9, x9, 0                            ;
        amomax.d x13, x1, (x9)                    ;
_l29:   subw x14, x25, x29                        ;
_l30:   fsub.s f5, f6, f30, rne                   ;
_l31:   fence                                     ;
_l32:   fsgnj.s f19, f18, f4                      ;
_l33:   la x1, d_2_12                             ;
        lh x19, -22(x1)                           ;
_l34:   xor x21, x21, x21                         ;
        addi x6, zero, 1                          ;
        slli x6, x6, 27                           ;
        add x21, x21, x6                          ;
        addi x3, zero, 3                          ;
        slli x3, x3, 16                           ;
        add x21, x21, x3                          ;
        addi x7, zero, 3                          ;
        slli x7, x7, 24                           ;
        add x21, x21, x7                          ;
        csrrw x17, scause, x21                    ;
_l35:   fle.s x26, f25, f20                       ;
_l36:   la x16, d_1_21                            ;
        lb x25, 20(x16)                           ;
_l37:   srai x15, x22, 16                         ;
_l38:   fmadd.s f13, f3, f18, f26, rne            ;
_l39:   lui x6, 0                                 ;
_l40:   divuw x6, x8, x24                         ;
_l41:   la x7, d_5_21                             ;
        addi x7, x7, 12                           ;
        amomaxu.w x17, x20, (x7)                  ;
_l42:   remw x21, x8, x27                         ;
_l43:   remuw x20, x10, x3                        ;
_l44:   fmul.s f14, f5, f1, rne                   ;
_l45:   la x25, d_1_24                            ;
        srai x25, x25, 1                          ;
        csrrw x16, pmpaddr5, x25                  ;
_l46:   slti x7, x23, 155                         ;
_l47:   fcvt.w.s x5, f10, rup                     ;
_l48:   la x25, d_5_26                            ;
        addi x25, x25, -0                         ;
        amominu.w x16, x27, (x25)                 ;
_l49:   la x6, d_3_13                             ;
        lhu x18, -12(x6)                          ;
_l50:   jal x12, _l174                                    ;
_l51:   fnmsub.s f20, f26, f21, f25, rdn          ;
_l52:   la x25, d_2_17                            ;
        addi x25, x25, -28                        ;
        amoor.w x5, x14, (x25)                    ;
_l53:   divw x30, x1, x15                         ;
_l54:   addiw x30, x11, -2047                     ;
_l55:   fmin.s f25, f17, f25                      ;
_l56:   fence.i                                   ;
_l57:   la x25, _l174                             ;
        jalr x15, 0(x25)                          ;
_l58:   la x25, d_4_23                            ;
        sb x20, 30(x25)                           ;
_l59:   la x8, d_0_14                             ;
        addi x8, x8, -4                           ;
        lui x2, 0xffe00                           ;
        xor x8, x8, x2                            ;
        amoand.w x1, x2, (x8)                     ;
_l60:   remw x3, x6, x17                          ;
_l61:   div x13, x5, x8                           ;
_l62:   div x18, x21, x3                          ;
_l63:   fdiv.s f22, f29, f23, rne                 ;
_l64:   xor x23, x23, x23                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 7                            ;
        add x23, x23, x1                          ;
        csrrc x4, satp, x23                       ;
_l65:   remw x8, x13, x16                         ;
_l66:   li x13, 1                                 ;
        la x3, pt1                                ;
        addi x3, x3, 40                           ;
        sfence.vma x13, x3                        ;
_l67:   divw x24, x16, x7                         ;
_l68:   la x18, d_2_14                            ;
        flw f11, -12(x18)                         ;
_l69:   mulh x17, x27, x23                        ;
_l70:   la x13, d_2_15                            ;
        addi x13, x13, 24                         ;
        amoor.d x23, x20, (x13)                   ;
_l71:   fsub.s f31, f17, f18, rne                 ;
_l72:   fmul.s f17, f11, f28, rtz                 ;
_l73:   fle.s x27, f20, f7                        ;
_l74:   bne x14, x11, _l121                               ;
_l75:   la x4, d_0_4                              ;
        sb x20, -0(x4)                            ;
_l76:   fmv.w.x f10, x27                          ;
_l77:   la x4, d_4_17                             ;
        addi x4, x4, 0                            ;
        lui x15, 0xffe00                          ;
        xor x4, x4, x15                           ;
        amoswap.w x25, x15, (x4)                  ;
_l78:   srli x30, x15, 0                          ;
_l79:   fmadd.s f15, f6, f20, f7, rdn             ;
_l80:   fnmadd.s f7, f16, f17, f23, dyn           ;
_l81:   la x5, d_0_2                              ;
        addi x5, x5, -24                          ;
        amomaxu.w x1, x12, (x5)                   ;
_l82:   fsqrt.s f17, f2, rdn                      ;
_l83:   mulhsu x29, x29, x9                       ;
_l84:   la x29, d_5_24                            ;
        lh x29, -0(x29)                           ;
_l85:   fcvt.s.w f10, x26, rmm                    ;
_l86:   blt x20, x13, _l134                       ;
_l87:   la x9, d_2_27                             ;
        addi x9, x9, 20                           ;
        amoadd.w x10, x9, (x9)                    ;
_l88:   la x28, d_4_15                            ;
        sw x19, 28(x28)                           ;
_l89:   slti x15, x21, -19                        ;
_l90:   fsgnjn.s f2, f29, f13                     ;
_l91:   la x20, _l121                                     ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l92:   ecall                                     ;
_l93:   la x18, d_0_19                            ;
        sb x3, -21(x18)                           ;
_l94:   li x17, 0                                 ;
        la x25, pt3                               ;
        addi x25, x25, 0                          ;
        sfence.vma x17, x25                       ;
_l95:   beq x10, x13, _l142                               ;
_l96:   ebreak                                    ;
_l97:   remu x8, x2, x24                          ;
_l98:   la x30, d_1_14                            ;
        lb x10, -1(x30)                           ;
_l99:   la x18, _l142                                     ;
        csrrw zero, uepc, x18                     ;
        uret                                      ;
_l100:  ebreak                                    ;
_l101:  fclass.s x4, f0                           ;
_l102:  remuw x12, x28, x19                       ;
_l103:  srli x24, x21, 35                         ;
_l104:  fsqrt.s f10, f17, rdn                     ;
_l105:  la x28, d_1_14                            ;
        addi x28, x28, -28                        ;
        amomin.w x8, x19, (x28)                   ;
_l106:  la x6, d_2_9                              ;
        addi x6, x6, 16                           ;
        amoand.w x6, x20, (x6)                    ;
_l107:  la x18, d_3_11                            ;
        addi x18, x18, 24                         ;
        amoxor.d x22, x3, (x18)                   ;
_l108:  csrrwi x27, mtval, 12                     ;
_l109:  fmsub.s f0, f10, f23, f13, dyn            ;
_l110:  fle.s x17, f10, f18                       ;
_l111:  fsqrt.s f20, f19, rne                     ;
_l112:  remw x22, x29, x23                        ;
_l113:  la x27, d_2_17                            ;
        sh x21, -18(x27)                          ;
_l114:  xor x8, x8, x8                            ;
        addi x25, zero, 1                         ;
        slli x25, x25, 22                         ;
        add x8, x8, x25                           ;
        csrrc x1, sepc, x8                        ;
_l115:  fence.i                                   ;
_l116:  la x11, d_1_1                             ;
        flw f2, -8(x11)                           ;
_l117:  remw x25, x16, x8                         ;
_l118:  ecall                                     ;
_l119:  mulhu x2, x16, x20                        ;
_l120:  fclass.s x30, f7                          ;
_l121:  la x12, _l148                                     ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l122:  la x30, d_1_6                             ;
        addi x30, x30, 28                         ;
        sc.w x29, x5, (x30)                       ;
_l123:  la x16, d_2_15                            ;
        addi x16, x16, 28                         ;
        amoand.w x26, x15, (x16)                  ;
_l124:  la x3, d_2_27                             ;
        addi x3, x3, 4                            ;
        lr.w x18, (x3)                            ;
_l125:  la x26, _l165                             ;
        jalr x20, 0(x26)                          ;
_l126:  fnmadd.s f31, f4, f15, f1, rne            ;
_l127:  fsgnjn.s f31, f1, f30                     ;
_l128:  andi x16, x27, 17                         ;
_l129:  feq.s x24, f29, f23                       ;
_l130:  la x26, d_3_7                             ;
        fsw f25, 12(x26)                          ;
_l131:  divw x20, x14, x28                        ;
_l132:  remuw x5, x15, x2                         ;
_l133:  div x14, x21, x13                         ;
_l134:  rem x17, x10, x25                         ;
_l135:  fsgnj.s f16, f22, f29                     ;
_l136:  la x8, d_4_26                             ;
        sd x9, 16(x8)                             ;
_l137:  rem x30, x21, x30                         ;
_l138:  ebreak                                    ;
_l139:  fcvt.s.l f8, x21, rne                     ;
_l140:  fmul.s f1, f5, f31, rmm                   ;
_l141:  srlw x18, x9, x8                          ;
_l142:  fsgnj.s f15, f29, f24                     ;
_l143:  la x9, d_2_24                             ;
        addi x9, x9, -0                           ;
        amomax.w x17, x19, (x9)                   ;
_l144:  bltu x25, x17, _l176                      ;
_l145:  ebreak                                    ;
_l146:  fcvt.lu.s x11, f28, rmm                   ;
_l147:  fclass.s x17, f29                         ;
_l148:  fence.i                                   ;
_l149:  fclass.s x13, f15                         ;
_l150:  la x7, d_5_2                              ;
        sb x12, 20(x7)                            ;
_l151:  ori x4, x20, 2047                         ;
_l152:  fcvt.s.lu f12, x4, rne                    ;
_l153:  bge x14, x23, _l184                               ;
_l154:  la x8, d_4_25                             ;
        lhu x20, -30(x8)                          ;
_l155:  fmsub.s f5, f17, f23, f10, rne            ;
_l156:  csrrsi x11, sie, 0                        ;
_l157:  la x17, d_3_14                            ;
        addi x17, x17, -0                         ;
        amominu.d x12, x30, (x17)                 ;
_l158:  slli x20, x24, 45                         ;
_l159:  la x3, d_0_21                             ;
        addi x3, x3, -0                           ;
        sc.w x24, x13, (x3)                       ;
_l160:  div x17, x29, x29                         ;
_l161:  la x16, d_5_20                            ;
        lbu x6, 0(x16)                            ;
_l162:  fadd.s f11, f25, f20, rne                 ;
_l163:  divu x11, x8, x1                          ;
_l164:  fdiv.s f1, f23, f10, rup                  ;
_l165:  la x24, _l186                             ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l166:  jal x14, _l171                                    ;
_l167:  fdiv.s f10, f2, f1, rup                   ;
_l168:  ori x25, x4, 868                          ;
_l169:  ori x29, x28, 1102                        ;
_l170:  la x6, d_3_5                              ;
        addi x6, x6, -8                           ;
        amoor.d x1, x21, (x6)                     ;
_l171:  la x20, d_2_26                            ;
        addi x20, x20, 8                          ;
        lui x9, 0xffe00                           ;
        xor x20, x20, x9                          ;
        amoswap.d x24, x9, (x20)                  ;
_l172:  la x1, _l197                                      ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l173:  addi x20, x16, -252                       ;
_l174:  la x29, d_3_20                            ;
        addi x29, x29, 12                         ;
        amoxor.w x9, x4, (x29)                    ;
_l175:  fmadd.s f19, f3, f2, f24, rtz             ;
_l176:  fcvt.s.w f27, x23, rup                    ;
_l177:  la x19, _l170                                     ;
        srai x19, x19, 1                          ;
        csrrc x13, pmpaddr5, x19                  ;
_l178:  li x18, 1                                 ;
        la x11, pt3                               ;
        addi x11, x11, 16                         ;
        sfence.vma x18, x11                       ;
_l179:  ori x19, x27, 512                         ;
_l180:  la x16, d_3_23                            ;
        sd x19, -0(x16)                           ;
_l181:  beq x24, x1, _l190                                ;
_l182:  la x9, d_4_19                             ;
        lui x15, 0xffe00                          ;
        xor x9, x9, x15                           ;
        flw f8, -4(x9)                            ;
_l183:  srliw x16, x3, 26                         ;
_l184:  la x28, d_3_22                            ;
        srai x28, x28, 1                          ;
        csrrs x4, pmpaddr7, x28                   ;
_l185:  subw x16, x20, x15                        ;
_l186:  la x7, d_1_25                             ;
        addi x7, x7, -12                          ;
        amomin.w x7, x13, (x7)                    ;
_l187:  fle.s x5, f31, f21                        ;
_l188:  rem x10, x6, x24                          ;
_l189:  fmsub.s f21, f11, f27, f9, rdn            ;
_l190:  flt.s x20, f12, f20                       ;
_l191:  div x11, x9, x19                          ;
_l192:  fmadd.s f12, f16, f12, f19, rtz           ;
_l193:  divw x12, x7, x23                         ;
_l194:  feq.s x8, f15, f24                        ;
_l195:  la x25, d_5_9                             ;
        addi x25, x25, -8                         ;
        amomin.d x1, x16, (x25)                   ;
_l196:  la x11, d_0_13                            ;
        addi x11, x11, -4                         ;
        amomaxu.w x27, x9, (x11)                  ;
_l197:  fsgnjx.s f15, f21, f2                     ;
_l198:  mulhu x26, x20, x5                        ;
_l199:  ori x27, x29, -771                        ;
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
                .dword 0x7c1199c0e12b3efe, 0xd4ed5748e8f553c8
                .dword 0xb3bdcc413865dc8f, 0xfa09a931a7282a5d
d_0_0:          .dword 0x8ffca399acbc9cbe, 0x19e5d9776b25e0d5
d_0_1:          .dword 0xd30c330112f9d78d, 0x46d26535d1c04881
d_0_2:          .dword 0xd06b7c26bb25739c, 0x281cdb013d14c8e9
d_0_3:          .dword 0xc1c240b29128972f, 0x7fb9b730e83ef59a
d_0_4:          .dword 0x437e43e396af383d, 0x464990ce75d3dd56
d_0_5:          .dword 0x74dd1fda10a52f3a, 0x603635d003319bb1
d_0_6:          .dword 0xdc75003f5e626360, 0x8913a5f1b4cd5ca2
d_0_7:          .dword 0x0d9f4acb82c4918e, 0x966b0f74c7af204c
d_0_8:          .dword 0x34f103a50be2bdcf, 0x9d79f6ebd00461d6
d_0_9:          .dword 0x9dfcc0b4f4b10bc1, 0x6a670c44b051036e
d_0_10:         .dword 0x184d0a06d6c678d7, 0xe430e57fba456e1e
d_0_11:         .dword 0xcf81c8a729aa51fd, 0x677f07b51b27ceb1
d_0_12:         .dword 0x0a9acf872b0bb4d9, 0xebccf847d5b179cc
d_0_13:         .dword 0x81419f86eafe11ec, 0x8514e1bd4d3c560b
d_0_14:         .dword 0x627a7fc995434b5c, 0x8bdb432aff71240b
d_0_15:         .dword 0xd6cabfbf92c2c868, 0x24890fa8458f90cd
d_0_16:         .dword 0xe228f52e0f9fc29a, 0x8f278bf375df889e
d_0_17:         .dword 0xffd110f0a0cf9352, 0xe7c55886f15ad343
d_0_18:         .dword 0x4d8262511c44f6f7, 0x716d1857cdd08791
d_0_19:         .dword 0x59f863ecac5d4ad2, 0xadfa362256430840
d_0_20:         .dword 0x6560278d9463451e, 0xc54cb8a1d51e5143
d_0_21:         .dword 0x86e08ebbd95006a1, 0x7cc64edbc725a408
d_0_22:         .dword 0x1ffff67a69cc5249, 0x0056804a1a7f7c86
d_0_23:         .dword 0xa0a05619dfe623d7, 0x72230d9187264b65
d_0_24:         .dword 0x43171be1e49ad66a, 0x94201dd7bea96f83
d_0_25:         .dword 0xb04ff058ea8c8961, 0x5d5a5ebc4c4b9362
d_0_26:         .dword 0x05319d5f270c9d2f, 0x968c0a925f64aa4d
d_0_27:         .dword 0xf5e558c33850c41a, 0xd873a9f6a4640ecd
                .dword 0x00cafa8834f9e2aa, 0xa8f25991411f6514
                .dword 0xb1fd40b94709c4ed, 0xb3986b9071c86f97
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x45fa51533dae58b6, 0xb0a325c388cb8745
                .dword 0x12f3f9c94809a48f, 0x245e1ec1c789b364
d_1_0:          .dword 0xdc0ef7c0ced8403a, 0x246f3ccc9e3d69c7
d_1_1:          .dword 0x74b538b220eef857, 0x5edeb246eb5fd7df
d_1_2:          .dword 0x2f4d507c31e98ec4, 0x9936abcfcf013989
d_1_3:          .dword 0x64278e51e02ff859, 0x0a4ef1c51d4070fb
d_1_4:          .dword 0x2f562734210695d9, 0xccd4716ec0ddd7e4
d_1_5:          .dword 0xd60cb3b67d1cb102, 0x004945eb1ba2ac02
d_1_6:          .dword 0xdf6efe90d0a3fe0d, 0xeca54fc19363220d
d_1_7:          .dword 0x7ea3b6aa66a4da48, 0x27d6ba5a2f8d0434
d_1_8:          .dword 0x7fe55c0bd7c0ffac, 0x7d4062bd6293a91b
d_1_9:          .dword 0xf473126a0f18fc95, 0xfc0af51cb6e63f98
d_1_10:         .dword 0x97b17814fad2636f, 0x98532ff07f16d774
d_1_11:         .dword 0xfa1bb555aa82c2b8, 0x7cb3737a14043a3b
d_1_12:         .dword 0x66954bd15dc6943e, 0xb8429df6033a5da4
d_1_13:         .dword 0xe003fbf3bb92a770, 0x3a71ad2bf22c4414
d_1_14:         .dword 0x16ff5ea86ac3c777, 0xd710aace6ba04ef4
d_1_15:         .dword 0xb62b0361a9b15ab9, 0xb79ab60699bbbd5f
d_1_16:         .dword 0xf3a90cf075f3c98b, 0xa11e8270a8454018
d_1_17:         .dword 0xf3ad47c78c4577a2, 0x841fc441835ca524
d_1_18:         .dword 0x967a713b1a258e9e, 0x795369023fc97f7e
d_1_19:         .dword 0xcb6f89c852a6bddb, 0x7ad5f9056927a887
d_1_20:         .dword 0xf613058afba94cda, 0x199f9f27cf4de486
d_1_21:         .dword 0xc0f0316e48f8f649, 0x31fe98d58fd48eea
d_1_22:         .dword 0xb4d5380d5a16d66c, 0x8cc1ba58b8bd9ce1
d_1_23:         .dword 0x4863559d435878c8, 0x780e38bbd1099db1
d_1_24:         .dword 0x0546c581de2b6c75, 0x7b9c9d7ce9e768cb
d_1_25:         .dword 0x4c647a9b5af533f5, 0xc4e386f29f662011
d_1_26:         .dword 0x9639740bf519cc9c, 0x4185f62e6874662d
d_1_27:         .dword 0x41f83992f8b3a48a, 0xc6dda2f1a3a586e8
                .dword 0xb5326a893a8a9498, 0x24029bca9132d91b
                .dword 0x72bdd61ec507a20b, 0x88a90304447ce785
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x803d320d0ca5be1f, 0x7d678216eece9a5f
                .dword 0x4e894adb1fb1ae37, 0x48baaea727091ffd
d_2_0:          .dword 0xc978167203da5ef8, 0xec3fd0ff3b0bb39c
d_2_1:          .dword 0x688620e06bb6d844, 0xd33e8fccc0597da9
d_2_2:          .dword 0x963b4acc99fd82ae, 0x47f607eb2e4c57cb
d_2_3:          .dword 0xf2ee70ffa629b693, 0x623fa92f3dbeae1a
d_2_4:          .dword 0xc70982d9fc08eb4d, 0xd760d6a4bd4f1319
d_2_5:          .dword 0x5bc893fde8cdccb7, 0xd77d27fa06a856d7
d_2_6:          .dword 0xd0c219b51c1ef154, 0xaee7b8dd0f8dd823
d_2_7:          .dword 0xc0b677a2c73d6512, 0xa58f406fff52fe47
d_2_8:          .dword 0x86d0f3313a174710, 0xf5f79d7ff7279796
d_2_9:          .dword 0xb1e9bdfa61930f7c, 0xa972999795fe5396
d_2_10:         .dword 0x80b7f9ced2dc18a6, 0xa680200517440f76
d_2_11:         .dword 0xf10f308a8b46650f, 0x7fcf928d910b61df
d_2_12:         .dword 0x8ce4f13a64a04b1c, 0xd2d2c1bef1132da2
d_2_13:         .dword 0x1a9bc167bb823713, 0x410e3587cf1addcc
d_2_14:         .dword 0xf1cbfd6dde76c76b, 0x07e63f9b140a5de4
d_2_15:         .dword 0x7179cb7b0327e2e5, 0x15e763c8e205be1c
d_2_16:         .dword 0x61facc1f302282d7, 0xb18d33d8b9c62300
d_2_17:         .dword 0xe639c18dab86423d, 0x9044c89150c708b1
d_2_18:         .dword 0x2eeda96316976b42, 0xa8d9ccf59ac87f1b
d_2_19:         .dword 0x6b7cf13c709b1695, 0xd6f672cc868eb94d
d_2_20:         .dword 0x0e1d1c5a622f3ad2, 0x66f1419e6d2cb731
d_2_21:         .dword 0x5bb79e1b286f84fb, 0x7cadd5059e516da7
d_2_22:         .dword 0x39e8cf044636ca43, 0x935e94146920c196
d_2_23:         .dword 0x5df07b17a140bd23, 0x2dc7d7d629f47196
d_2_24:         .dword 0xec880c6be2f8dfdc, 0x163c321f98edb919
d_2_25:         .dword 0xf74331e29efbd373, 0x8fa73d76c9b1f087
d_2_26:         .dword 0x14b3a2e29e780e48, 0xcb40cb3f2ddaba86
d_2_27:         .dword 0xf16e80a6927c5c03, 0x4e4179946d1ece04
                .dword 0x951fd8513b2796b9, 0x29e659c459fce7aa
                .dword 0xb67b677713078317, 0xdc41b2353f4b9d1b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x9de1b057e5924f7b, 0x478a14917b9b472d
                .dword 0x3201db512dfc086b, 0x4424349dc66ef63e
d_3_0:          .dword 0x145405e780249868, 0x3eb0f00d97f57de3
d_3_1:          .dword 0xa2ad5238c501564a, 0xeeabd250180ca96d
d_3_2:          .dword 0xce93197834ef60db, 0xf15280b7f9340c0e
d_3_3:          .dword 0xfab02fa6bde43dcb, 0x537d040e7ccb6ece
d_3_4:          .dword 0x35ccc45e54af2347, 0x82c18fb499e1df29
d_3_5:          .dword 0xb10dfa1a67e3ef30, 0x60bbfd6d18ab297f
d_3_6:          .dword 0xf0e38929e8a9db24, 0x9e8ddfb6c28a953b
d_3_7:          .dword 0x5f3d70049235a976, 0x81877a26fb731984
d_3_8:          .dword 0xf6e61b303d647f1f, 0xc42bcf9696d6418b
d_3_9:          .dword 0x44c5b972b1e85947, 0x98d528ff895fb39a
d_3_10:         .dword 0x4b7df890dd6dc0c0, 0x5048e5be7bbcdc4b
d_3_11:         .dword 0x79c6ea7a5e5ec2b2, 0x8c6a851b78326681
d_3_12:         .dword 0xa7decf1ab49fbee6, 0x6fae2cd10991215e
d_3_13:         .dword 0x97b480a32e246788, 0x23115cc5b899836b
d_3_14:         .dword 0x13e36e6d1d0e497a, 0x3067784dfa9f24a7
d_3_15:         .dword 0x87144e9d484c5dc3, 0x00d0f3255a9895fa
d_3_16:         .dword 0x4e97db6a9c999e31, 0x8cddabc71dafa7bb
d_3_17:         .dword 0x75b1219f8738ce11, 0xa88e600c05d2366f
d_3_18:         .dword 0x4efcb49efea833b9, 0xd6a6df798474d949
d_3_19:         .dword 0x25901af0b03c6c02, 0xfeb26557df7a270a
d_3_20:         .dword 0x84e5c86a8282ec51, 0xa3d2af1052b797c9
d_3_21:         .dword 0x8ad34f082c0ae22e, 0xbd20c731df165dff
d_3_22:         .dword 0x478595512ba79810, 0xaf7994b3550a9a89
d_3_23:         .dword 0x24abae677d3fffc4, 0x3b6a290797a06c0c
d_3_24:         .dword 0x9816b16906b449d6, 0xa80a9671fe82a1b5
d_3_25:         .dword 0x4c1523b95a89fd53, 0x280823801abdb011
d_3_26:         .dword 0x12880f0b9e4029e8, 0x006728c256539371
d_3_27:         .dword 0xeac49ccc150833eb, 0xab2a142f2fa5842b
                .dword 0x593c1e6dc18b8c67, 0x638ae372c1398713
                .dword 0x867e42b27ccb583d, 0xdc609db73f08b2a8
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x270656a275540080, 0x05ff730be58164fd
                .dword 0x4e5f8416bd2015a0, 0xf5b1e35d972859ca
d_4_0:          .dword 0x500bc61225b2c53c, 0x5bad9b9b5db4717e
d_4_1:          .dword 0x7d78f3d79548c6bc, 0x3d7618df6a7b115e
d_4_2:          .dword 0x88c66be88259addb, 0x178f3daf7a7c3c09
d_4_3:          .dword 0x41f8cfcd5e2c62f0, 0xf912a8062ea59d31
d_4_4:          .dword 0xffbfdc98097928e1, 0x5e180e897fe4b0ba
d_4_5:          .dword 0x8c6e2c253b61d1cb, 0xbd4e750ae07c06ba
d_4_6:          .dword 0x07a3e7cef388175a, 0x5023dec0e96061a6
d_4_7:          .dword 0x244d173612dbe4e5, 0xe8fdc7b0c65bd722
d_4_8:          .dword 0x6145cf00ce5c407e, 0x5b4960be6d5def75
d_4_9:          .dword 0x2c3e3f78c0cdbaf8, 0x93a944f77741ee29
d_4_10:         .dword 0x59ab02e4c31fa599, 0xbc96fc9c15a85a66
d_4_11:         .dword 0x2d6ede71b2c5fb5c, 0xe9693f5baaba541f
d_4_12:         .dword 0xd3b66d0ce69b7978, 0x391fddf5d6b49b7f
d_4_13:         .dword 0x8739ef0123f6d8e3, 0xb3cd7dd0a27292b9
d_4_14:         .dword 0xff6b6bd6ab598308, 0xefeca7fd57fcf0bc
d_4_15:         .dword 0x57885fcfc119baa1, 0x2c43764ded1b9c28
d_4_16:         .dword 0x478f0cfa17db6396, 0x4bfcbb3df6427262
d_4_17:         .dword 0xeccbe49fe87f3217, 0xdb920bbf8b0fa793
d_4_18:         .dword 0x7cb4c49bf4aaed07, 0x75bef7750619c498
d_4_19:         .dword 0x789845050c127ac6, 0x07a60c01b521ed9b
d_4_20:         .dword 0x15ec3711a6d7d11d, 0x19593e45ae0120af
d_4_21:         .dword 0x0d1d538f9856ca5c, 0x044e3cdb3f1f24d0
d_4_22:         .dword 0x8794118b9ec869b8, 0x5f3a84d1623cfc8d
d_4_23:         .dword 0xcf58dc899b5844e0, 0x55f6456e1ab469d4
d_4_24:         .dword 0xb4c902283c62f391, 0x3bd0fa94949f55ef
d_4_25:         .dword 0x9ae7cf78cf526a33, 0xa4726eb9edc6f2da
d_4_26:         .dword 0x6b66de5a0ac03d50, 0x421c2208b5f1a568
d_4_27:         .dword 0x9f3dfcdf673a0646, 0xbe508c22d727cf5f
                .dword 0x27ceeb9f817b7022, 0xa6938498a5acffad
                .dword 0x068432d5f325b6fa, 0x6300d17225bf1b09
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x0c749f3336eeeb94, 0xbb09b1f53898fdb6
                .dword 0x8ebd38e1f785b7b6, 0x473d6ee44541fbdf
d_5_0:          .dword 0x6ca48767657aeb64, 0x6a8b5a3345c8781c
d_5_1:          .dword 0x482e9da351cc9d8b, 0xad08cc776164aaff
d_5_2:          .dword 0x4b6c0cb925e63dd0, 0x9b987d3aa8391143
d_5_3:          .dword 0x89a11a883254fa9f, 0x23c5d12785c62a97
d_5_4:          .dword 0xd4549aa0c4792bf9, 0x33b1500c18acee05
d_5_5:          .dword 0x889de73cd4c7725f, 0x8207950640578f34
d_5_6:          .dword 0x458ee902ae9f3e83, 0xab2a207c000c88db
d_5_7:          .dword 0x8ffbc02c3e40811c, 0x8ea3b73c425989e2
d_5_8:          .dword 0x5401ebb4c799e811, 0xd8c34e11f5e19102
d_5_9:          .dword 0x73848f3a4bc064d0, 0xb6e01b6bb4d477aa
d_5_10:         .dword 0x8b48124051d3ae0b, 0x16ec3f46f342c3af
d_5_11:         .dword 0x9f966f5fa16c0475, 0xd2da57b46e867140
d_5_12:         .dword 0x6a4c74e635ae317f, 0x1a9eccbd7f0b2a5b
d_5_13:         .dword 0x7bc482bc31994447, 0x6dd73aa4177ce5de
d_5_14:         .dword 0xc3f591e42a33e727, 0xdb94d1e5843a737d
d_5_15:         .dword 0x7416bdcfc9b04633, 0xd98c3dd499b0bed6
d_5_16:         .dword 0xfc634ebac43103fe, 0x2579949c0ad4fe8c
d_5_17:         .dword 0x446b8a80cbd70787, 0xea793ef3f96fb4d3
d_5_18:         .dword 0xd6eeadb9898ce55d, 0x818f84603b43303d
d_5_19:         .dword 0x60eb465ce4da7f82, 0x143b9d017be319b3
d_5_20:         .dword 0xf96e7eb7481ef2e8, 0x07b3ecbc77a38d43
d_5_21:         .dword 0x6e9f319f13f3d69d, 0xae2760d006793dd2
d_5_22:         .dword 0x1e44e12aecf91e8f, 0x71bf75a998444602
d_5_23:         .dword 0xc8b224cdaf5cca61, 0x2ea3e3c0c91c4e21
d_5_24:         .dword 0x684b24ddde1f5665, 0x0594150e3069b518
d_5_25:         .dword 0xebaf5e7d38c59d11, 0x63a2c4fb50f76e27
d_5_26:         .dword 0x956f937b4b314de6, 0x216faee4b8cae107
d_5_27:         .dword 0x6f908be200d59644, 0x57ee6f8d6c0cfde5
                .dword 0x52138cd8d8f7c431, 0x290406fef9964cb5
                .dword 0xabfae233155d6e53, 0x5d987b74825474f3
         /* Random data */
_end_data5:
              
 
