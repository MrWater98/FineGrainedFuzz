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
_p0:    csrrsi x12, pmpaddr5, 19                  ;
_p1:    xor x11, x11, x11                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 1                          ;
        add x11, x11, x11                         ;
        csrrc x12, satp, x11                      ;
_p2:    csrrwi x10, pmpaddr2, 5                   ;
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
_s0:    fcvt.s.w f14, x0, rmm                     ;
_s1:    xor x5, x5, x5                            ;
        addi x11, zero, 1                         ;
        slli x11, x11, 28                         ;
        add x5, x5, x11                           ;
        addi x9, zero, 1                          ;
        slli x9, x9, 16                           ;
        add x5, x5, x9                            ;
        addi x24, zero, 1                         ;
        slli x24, x24, 10                         ;
        add x5, x5, x24                           ;
        csrrs x29, mcause, x5                     ;
_s2:    la x17, d_3_26                            ;
        addi x17, x17, 28                         ;
        sc.w x8, x22, (x17)                       ;
_s3:    sraw x22, x12, x25                        ;
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
_l0:    fsgnj.s f24, f25, f25                     ;
_l1:    la x8, d_5_6                              ;
        lh x29, -4(x8)                            ;
_l2:    fmv.w.x f21, x17                          ;
_l3:    fmin.s f2, f2, f25                        ;
_l4:    la x7, _l62                                       ;
        csrrw zero, uepc, x7                      ;
        uret                                      ;
_l5:    srlw x28, x12, x17                        ;
_l6:    fence                                     ;
_l7:    xor x22, x22, x22                         ;
        addi x26, zero, 3                         ;
        slli x26, x26, 0                          ;
        add x22, x22, x26                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 6                          ;
        add x22, x22, x19                         ;
        csrrw x3, mip, x22                        ;
_l8:    fsub.s f12, f2, f17, rdn                  ;
_l9:    fence.i                                   ;
_l10:   la x10, d_3_3                             ;
        addi x10, x10, 4                          ;
        lui x1, 0xffe00                           ;
        xor x10, x10, x1                          ;
        amoor.w x4, x1, (x10)                     ;
_l11:   mulhsu x16, x3, x17                       ;
_l12:   subw x11, x28, x19                        ;
_l13:   fsgnjn.s f17, f14, f31                    ;
_l14:   bge x21, x10, _l66                                ;
_l15:   la x25, _l65                                      ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l16:   bltu x2, x30, _l37                                ;
_l17:   sraw x20, x20, x28                        ;
_l18:   sraiw x28, x11, 10                        ;
_l19:   xor x10, x10, x10                         ;
        csrrs x23, fcsr, x10                      ;
_l20:   fmax.s f2, f17, f21                       ;
_l21:   divw x5, x2, x13                          ;
_l22:   la x25, d_3_18                            ;
        sw x23, 24(x25)                           ;
_l23:   la x3, _l92                                       ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l24:   la x2, d_4_16                             ;
        lhu x1, -18(x2)                           ;
_l25:   la x17, d_3_17                            ;
        lw x30, -0(x17)                           ;
_l26:   fdiv.s f15, f27, f7, rtz                  ;
_l27:   ori x1, x11, 559                          ;
_l28:   andi x15, x8, 0                           ;
_l29:   la x3, d_2_4                              ;
        lhu x20, 6(x3)                            ;
_l30:   slliw x8, x29, 2                          ;
_l31:   la x19, d_0_4                             ;
        lh x7, 28(x19)                            ;
_l32:   xor x1, x1, x1                            ;
        addi x3, zero, 3                          ;
        slli x3, x3, 28                           ;
        add x1, x1, x3                            ;
        addi x7, zero, 1                          ;
        slli x7, x7, 27                           ;
        add x1, x1, x7                            ;
        addi x11, zero, 3                         ;
        slli x11, x11, 15                         ;
        add x1, x1, x11                           ;
        csrrs x14, mepc, x1                       ;
_l33:   fmv.x.w x18, f30                          ;
_l34:   la x18, d_1_14                            ;
        addi x18, x18, 28                         ;
        sc.w x5, x19, (x18)                       ;
_l35:   fcvt.s.w f23, x25, rmm                    ;
_l36:   fmin.s f22, f20, f22                      ;
_l37:   la x4, d_1_14                             ;
        flw f23, -24(x4)                          ;
_l38:   la x28, d_2_13                            ;
        addi x28, x28, -0                         ;
        amomaxu.d x29, x23, (x28)                 ;
_l39:   slti x30, x19, 1096                       ;
_l40:   fmv.w.x f12, x28                          ;
_l41:   fence.i                                   ;
_l42:   fcvt.lu.s x18, f30, rne                   ;
_l43:   xor x18, x18, x18                         ;
        addi x20, zero, 3                         ;
        slli x20, x20, 19                         ;
        add x18, x18, x20                         ;
        csrrw x15, mscratch, x18                  ;
_l44:   fmsub.s f21, f20, f10, f28, dyn           ;
_l45:   auipc x25, 384                            ;
_l46:   remu x18, x29, x15                        ;
_l47:   la x12, _l89                                      ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_l48:   fcvt.s.wu f23, x27, rtz                   ;
_l49:   fcvt.s.lu f30, x1, rne                    ;
_l50:   addiw x5, x18, -102                       ;
_l51:   fmv.w.x f25, x21                          ;
_l52:   la x5, d_1_4                              ;
        sd x7, 8(x5)                              ;
_l53:   fle.s x8, f9, f19                         ;
_l54:   fcvt.s.lu f1, x11, rne                    ;
_l55:   fle.s x15, f16, f28                       ;
_l56:   fcvt.l.s x30, f0, dyn                     ;
_l57:   fle.s x15, f30, f24                       ;
_l58:   la x6, _l135                              ;
        jalr x1, 0(x6)                            ;
_l59:   la x16, d_1_12                            ;
        addi x16, x16, -8                         ;
        amoand.d x15, x15, (x16)                  ;
_l60:   sraw x4, x24, x23                         ;
_l61:   fsgnjn.s f21, f10, f12                    ;
_l62:   slliw x10, x22, 4                         ;
_l63:   fsgnj.s f27, f30, f7                      ;
_l64:   fcvt.l.s x10, f24, rtz                    ;
_l65:   fmin.s f7, f4, f17                        ;
_l66:   lui x30, 384                              ;
_l67:   la x22, _l71                                      ;
        jalr x14, 0(x22)                          ;
_l68:   mulw x16, x20, x6                         ;
_l69:   la x25, d_2_7                             ;
        addi x25, x25, 0                          ;
        amoadd.d x19, x12, (x25)                  ;
_l70:   fsgnjx.s f14, f4, f7                      ;
_l71:   flt.s x25, f31, f0                        ;
_l72:   la x10, d_5_3                             ;
        addi x10, x10, 0                          ;
        amomax.d x19, x2, (x10)                   ;
_l73:   srlw x30, x4, x19                         ;
_l74:   la x4, d_1_18                             ;
        sw x8, 28(x4)                             ;
_l75:   fsub.s f1, f1, f5, rup                    ;
_l76:   la x19, d_0_26                            ;
        addi x19, x19, 16                         ;
        amomax.w x4, x19, (x19)                   ;
_l77:   divu x30, x7, x2                          ;
_l78:   flt.s x20, f22, f4                        ;
_l79:   fmax.s f15, f29, f1                       ;
_l80:   fsqrt.s f1, f13, rtz                      ;
_l81:   feq.s x22, f16, f12                       ;
_l82:   fsgnjn.s f10, f9, f4                      ;
_l83:   rem x14, x14, x4                          ;
_l84:   xor x30, x30, x30                         ;
        csrrw x19, mie, x30                       ;
_l85:   ecall                                     ;
_l86:   fdiv.s f4, f25, f9, rdn                   ;
_l87:   la x7, d_4_6                              ;
        sb x6, 8(x7)                              ;
_l88:   la x12, d_3_8                             ;
        addi x12, x12, -0                         ;
        amoor.d x11, x13, (x12)                   ;
_l89:   remuw x23, x3, x6                         ;
_l90:   xori x21, x20, -0                         ;
_l91:   fcvt.s.l f9, x1, rtz                      ;
_l92:   fsgnjn.s f26, f24, f31                    ;
_l93:   fence                                     ;
_l94:   la x27, _l147                             ;
        csrrw zero, uepc, x27                     ;
        uret                                      ;
_l95:   fadd.s f27, f10, f27, rdn                 ;
_l96:   la x30, d_1_26                            ;
        addi x30, x30, -16                        ;
        amomax.d x27, x12, (x30)                  ;
_l97:   fcvt.w.s x30, f13, dyn                    ;
_l98:   fcvt.lu.s x25, f22, dyn                   ;
_l99:   slli x19, x23, 0                          ;
_l100:  csrrsi x26, mscratch, 11                  ;
_l101:  la x16, d_5_0                             ;
        addi x16, x16, 8                          ;
        amominu.d x5, x19, (x16)                  ;
_l102:  xori x3, x29, -898                        ;
_l103:  la x11, d_1_18                            ;
        addi x11, x11, 0                          ;
        sc.d x19, x11, (x11)                      ;
_l104:  la x27, d_3_23                            ;
        sw x30, 12(x27)                           ;
_l105:  fence                                     ;
_l106:  la x18, d_1_8                             ;
        addi x18, x18, -8                         ;
        amoswap.w x4, x8, (x18)                   ;
_l107:  divw x0, x4, x27                          ;
_l108:  flt.s x4, f23, f21                        ;
_l109:  addi x10, x22, 2047                       ;
_l110:  la x27, d_1_10                            ;
        addi x27, x27, -4                         ;
        amoand.w x1, x29, (x27)                   ;
_l111:  sraiw x10, x2, 30                         ;
_l112:  la x10, d_5_4                             ;
        lui x1, 0xffe00                           ;
        xor x10, x10, x1                          ;
        lbu x30, 8(x10)                           ;
_l113:  fnmsub.s f16, f29, f30, f0, dyn           ;
_l114:  srli x24, x28, 19                         ;
_l115:  la x3, d_1_9                              ;
        addi x3, x3, -4                           ;
        amoadd.w x22, x23, (x3)                   ;
_l116:  fcvt.wu.s x17, f14, rmm                   ;
_l117:  mulhsu x10, x9, x28                       ;
_l118:  bge x3, x13, _l134                                ;
_l119:  fcvt.s.wu f9, x3, rdn                     ;
_l120:  fence                                     ;
_l121:  sraw x8, x20, x2                          ;
_l122:  xor x5, x5, x5                            ;
        csrrw x1, mepc, x5                        ;
_l123:  fnmadd.s f14, f12, f13, f1, rtz           ;
_l124:  feq.s x23, f0, f27                        ;
_l125:  ebreak                                    ;
_l126:  la x3, d_1_3                              ;
        addi x3, x3, 16                           ;
        lr.d x15, (x3)                            ;
_l127:  xori x22, x19, 284                        ;
_l128:  la x11, d_1_9                             ;
        addi x11, x11, -0                         ;
        amoand.w x25, x9, (x11)                   ;
_l129:  fmadd.s f6, f16, f8, f24, rtz             ;
_l130:  fcvt.s.wu f24, x0, rmm                    ;
_l131:  la x28, d_2_16                            ;
        addi x28, x28, 16                         ;
        amoor.d x7, x16, (x28)                    ;
_l132:  xor x7, x7, x7                            ;
        addi x5, zero, 3                          ;
        slli x5, x5, 0                            ;
        add x7, x7, x5                            ;
        addi x18, zero, 1                         ;
        slli x18, x18, 5                          ;
        add x7, x7, x18                           ;
        csrrw x15, mtval, x7                      ;
_l133:  fcvt.lu.s x30, f20, rtz                   ;
_l134:  fle.s x8, f22, f12                        ;
_l135:  xor x11, x11, x11                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 26                         ;
        add x11, x11, x27                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 27                         ;
        add x11, x11, x10                         ;
        csrrw x28, mtval, x11                     ;
_l136:  ori x6, x17, 384                          ;
_l137:  la x8, d_3_6                              ;
        addi x8, x8, 16                           ;
        amominu.w x7, x14, (x8)                   ;
_l138:  addiw x30, x12, -224                      ;
_l139:  la x12, d_3_16                            ;
        addi x12, x12, -16                        ;
        lr.d x27, (x12)                           ;
_l140:  la x24, d_5_8                             ;
        addi x24, x24, -0                         ;
        amoswap.d x12, x19, (x24)                 ;
_l141:  sraw x9, x5, x2                           ;
_l142:  fsub.s f23, f31, f23, dyn                 ;
_l143:  la x30, d_3_13                            ;
        addi x30, x30, -0                         ;
        amomaxu.d x23, x21, (x30)                 ;
_l144:  addw x18, x4, x3                          ;
_l145:  fcvt.s.l f8, x16, rup                     ;
_l146:  la x21, d_4_13                            ;
        addi x21, x21, 12                         ;
        amomin.w x7, x13, (x21)                   ;
_l147:  slti x2, x8, -78                          ;
_l148:  la x13, _l149                                     ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l149:  fcvt.s.l f19, x23, rne                    ;
_l150:  la x14, d_1_7                             ;
        lhu x18, 22(x14)                          ;
_l151:;
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
                .dword 0xe126894f5812bb38, 0x00fa48deda68bdf2
                .dword 0x8d301e5f55dab2c4, 0x670e2a262ba1ea2c
d_0_0:          .dword 0xea49204940f47910, 0x04926ed9672c0372
d_0_1:          .dword 0x34cec8af57282e41, 0xd05ec19980ebe95b
d_0_2:          .dword 0xb1f9b9407cf07380, 0x6d590b61b21f000e
d_0_3:          .dword 0xb6e2412e7a3c8ab0, 0xdbfba0d4bf68b3b3
d_0_4:          .dword 0x079b38109cf377d5, 0x08599d66a19e4124
d_0_5:          .dword 0xe157ebab0fe1e8fd, 0x4c6f45864cfd2f99
d_0_6:          .dword 0x2176be9245c31f35, 0xd626869a23e32991
d_0_7:          .dword 0x495c68a442c3053b, 0x5d1e48244c565670
d_0_8:          .dword 0x2cefd25b66881fa5, 0x54419d574b118f8a
d_0_9:          .dword 0x891eb281f7e1d536, 0x0b1934ee562ff2ea
d_0_10:         .dword 0x68a6b40eb700c8f0, 0x835192dc42518345
d_0_11:         .dword 0xa039c22c61723fc2, 0xcfb66bb8700c828c
d_0_12:         .dword 0x140c2206a4d4a1e6, 0xea1dba535ad2f640
d_0_13:         .dword 0xbebb83d51dc3762d, 0x48b33829ce54c938
d_0_14:         .dword 0x0116e05477915640, 0xe3ba6f297573e101
d_0_15:         .dword 0x92ecb93453caa2fa, 0xf605c168962abcdf
d_0_16:         .dword 0xfcb69d33a5078106, 0xb98e5b3438d9ceb4
d_0_17:         .dword 0xaddd0787dd608604, 0x70face0c90f06618
d_0_18:         .dword 0xdacbfca3c3aa6251, 0x53c225044c672f2b
d_0_19:         .dword 0x354af3f2cf8ba54b, 0xd82045b13de10c35
d_0_20:         .dword 0xfab2c22186087b21, 0x659641052edc287b
d_0_21:         .dword 0xa70d47664093ccc5, 0x9e141246538f6737
d_0_22:         .dword 0x1aa3f3f5003b0321, 0xb7c97e3337af3ec2
d_0_23:         .dword 0x6eb53a8edf13502a, 0xc56f60dd67e12c82
d_0_24:         .dword 0xcef9c7f23e8239aa, 0xbe186c36d579c0af
d_0_25:         .dword 0xcfb1228937c40013, 0x68f417c9dfd41322
d_0_26:         .dword 0xd57b9850497ddda8, 0x80806363761f3a45
d_0_27:         .dword 0xe6fa56d4f2c180bc, 0x7bf2d3eef7d48f16
                .dword 0xee8835dac19a0eae, 0x3c63b55af79f7ca0
                .dword 0xa34bdc86655b0a5c, 0x984caf9801571fb8
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x7253355c95fea569, 0x8de837d80bd5d557
                .dword 0x5dda3ff5c18bdc0f, 0xe589725aa1c0c312
d_1_0:          .dword 0x1d2c78bfa2eec4f2, 0x121157a97376fc68
d_1_1:          .dword 0x1b71a89de4a1a11c, 0xb9fcfef081309978
d_1_2:          .dword 0xc7c9457a3395b73a, 0xf9b897c51edb9a28
d_1_3:          .dword 0xa44b1d7c37ebeb85, 0x9e1b90451300e92a
d_1_4:          .dword 0xe369248dd9ba1812, 0x053e4e7d8a84e84a
d_1_5:          .dword 0xf13824efca1651ea, 0x92b2e02d4e1d0055
d_1_6:          .dword 0x1c9dd3cc6dfedcb0, 0x0480bfdf0b0c74a2
d_1_7:          .dword 0xa890fd24c47aed31, 0xf2a79fa6dec72d56
d_1_8:          .dword 0x2a1708b67794c4d0, 0xb963be96a55e53c5
d_1_9:          .dword 0xdf85acc269bcd392, 0xa85c2026dc71f759
d_1_10:         .dword 0x136951ac4e048fe6, 0x7723c67aa786d93b
d_1_11:         .dword 0x2172a38f52a98d0c, 0x68869205380a38c7
d_1_12:         .dword 0xc447c3163e271c73, 0x795f9739e07890a5
d_1_13:         .dword 0xe1cabfb81ed91ebd, 0x45283257b25bda54
d_1_14:         .dword 0x6022152ba3dfa22c, 0xf3c147c12a5911e7
d_1_15:         .dword 0xe92da6ada4212f76, 0xd37ab345466c48d8
d_1_16:         .dword 0x8ffdd7e4020f8877, 0xccd6c7fc26b7f109
d_1_17:         .dword 0x4b41b9cca4e2efb9, 0x431ee123bce42d32
d_1_18:         .dword 0x48cb42f220cd2666, 0xdb62dc032eaa21ef
d_1_19:         .dword 0x994d553821028713, 0x0ff7b38fa141f1ee
d_1_20:         .dword 0x963a55354b805b3a, 0x8a3320e6251e8af9
d_1_21:         .dword 0x4b2ab92d2cf5e3ec, 0xf5733aad8a362a51
d_1_22:         .dword 0x1696efc2c2bc2dbe, 0x59234bd6a67932ba
d_1_23:         .dword 0x957612503a8b8c21, 0x1094e81b5164b46e
d_1_24:         .dword 0x8b492a47ba3d6be9, 0xd890e68a2aeb84be
d_1_25:         .dword 0xe721e51b9715b44e, 0x9e1c1770110077ca
d_1_26:         .dword 0x4fe51eda25a1a813, 0x2e26f9d0cd680ae0
d_1_27:         .dword 0xe117c3cb382e93f5, 0xb2124568345b732a
                .dword 0xa91a46bb177e0ba2, 0xb0674ea2efb58ef9
                .dword 0xc5ddcfc0dcdb2c4c, 0x470047c0bc197246
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe7f713ea67b24ef3, 0x933a93c3771c1c6d
                .dword 0x8846594b2bf6323a, 0x0add4c16f5373c91
d_2_0:          .dword 0xe3eb9d4bd626c37e, 0xcf2c811dc2a391e3
d_2_1:          .dword 0x7542c898eb5ad6c9, 0xc34fdd83bd4d6a88
d_2_2:          .dword 0xad8a9f3502b7104f, 0xabd2e96260d2ab43
d_2_3:          .dword 0x1cda08c4c0e7189d, 0x8f14fb88d2f084fa
d_2_4:          .dword 0x1cfcd31005b9c845, 0x58bc83bbc99aeb3f
d_2_5:          .dword 0x2111cbcea7014ce4, 0x05866aa68e3a09ae
d_2_6:          .dword 0xcd32cef3c8c2eb21, 0x56be32677c9919a2
d_2_7:          .dword 0x686df4e96583e282, 0xe693209eabdc94a3
d_2_8:          .dword 0x662ad3cbe48001e3, 0xf6604f798cd8ca7f
d_2_9:          .dword 0xfe3a0ebf9da3831b, 0xbe7a04392e643a38
d_2_10:         .dword 0xe7d0c09ce1dc4881, 0x682be22f49f7c9d6
d_2_11:         .dword 0xebfa0a35afc8635d, 0x66b02b587aa9f4fd
d_2_12:         .dword 0x63d95aaacc263c8f, 0xaf1d4a2e9a6ae787
d_2_13:         .dword 0xaf452322340bca7d, 0xe64a8fb589ac2b09
d_2_14:         .dword 0x48af6ddbc121ed8a, 0xe489c10a607ba3b7
d_2_15:         .dword 0x02900c6f56f146fe, 0x2b3956b8610fc377
d_2_16:         .dword 0x4de8dcd238c69075, 0x25b6d37c9bbbbcca
d_2_17:         .dword 0x161386011974cbf7, 0x059512b96eaf6a82
d_2_18:         .dword 0xcbabb3771578f013, 0x6fa618f1be5cface
d_2_19:         .dword 0x80323e016801d582, 0x33ad391227678eb9
d_2_20:         .dword 0x37e2c0e7176f1b49, 0x37debc640e12e997
d_2_21:         .dword 0x77f36ad93f7d99d7, 0x5306b48e97d3f6ed
d_2_22:         .dword 0x9573856649c7e3ce, 0xae7dbf8b1c67cef1
d_2_23:         .dword 0x416426e2d51d2813, 0xe2f9a9182e60d2ce
d_2_24:         .dword 0x8869f5f8fac5c17f, 0xc13afa0f6f631799
d_2_25:         .dword 0xa04cc1cf03e44316, 0x839579138797d774
d_2_26:         .dword 0xd8f65264dd82ee5c, 0xd86aa37c2285e32e
d_2_27:         .dword 0x5384b077c78b6c09, 0x3d7f2993ef7ff7a0
                .dword 0x420c8640b4b82da1, 0x4dcf10f99edad158
                .dword 0x8b67b16a75b0feb8, 0x646bcf89cd63e29a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x75872060dc60ee73, 0x7d9ea736b53a4c09
                .dword 0x31ef2b41e65b7309, 0x8f6f8021b1314074
d_3_0:          .dword 0x85655118725f0963, 0xda3cd4006fef67ca
d_3_1:          .dword 0xf9d3d1e46b6e0917, 0x916d65868aefb62b
d_3_2:          .dword 0xef3def309a4e3b7b, 0xce1a5257ad79c946
d_3_3:          .dword 0x31c372055aa83613, 0x3137ec470a0b22a4
d_3_4:          .dword 0x1b07013354ab9fa8, 0x063c99d6e3d2bdf8
d_3_5:          .dword 0xa973caf41367d833, 0x07d327f326d8602a
d_3_6:          .dword 0xa10d3a17e967726a, 0xc94956b857d7b815
d_3_7:          .dword 0x728916f217420159, 0x950465c852a1cbe9
d_3_8:          .dword 0xf9228baa4fd712c3, 0x08d30e8d2861cbfa
d_3_9:          .dword 0x2efc66ed25acb469, 0x1f9eb27a809b7547
d_3_10:         .dword 0xb8997f69281f6eed, 0xa209b147f9675469
d_3_11:         .dword 0x4b57611bbf532b6f, 0x8883980d12370886
d_3_12:         .dword 0xa2b80f6f8c8c0dd6, 0x0bcbbbca8f05e110
d_3_13:         .dword 0x261d61d4a6cd1c03, 0xe5f083f62c0331c0
d_3_14:         .dword 0xa93a44a9586f8563, 0xb657885930cdd276
d_3_15:         .dword 0x12861714ab4360cc, 0x539c9f471922c53e
d_3_16:         .dword 0xe77bd4f56ac5c433, 0x77518db04b56c774
d_3_17:         .dword 0x269100d788cbaca7, 0x8fbe13eae7ab467f
d_3_18:         .dword 0x49a2cfdc06dacf70, 0x053886a91c2e81b6
d_3_19:         .dword 0x3591006b4c8cc55b, 0xbc4399d700b018e5
d_3_20:         .dword 0x43b6e1b0939495ad, 0xb14cee15401c1cd1
d_3_21:         .dword 0x611a2735fc2b3cb3, 0xb8115a2d84559f16
d_3_22:         .dword 0x86f8260f50ba779a, 0x50a59a22ecc922fc
d_3_23:         .dword 0x3c16ba6440983629, 0x447830ad3fe9cd23
d_3_24:         .dword 0x8d5f6a6bf96d2861, 0x186f8a635816871a
d_3_25:         .dword 0xa0b263fc9764bcfc, 0xf46d84d3424328a2
d_3_26:         .dword 0xecc632b93a3d82ed, 0x52ac906caaf7c57e
d_3_27:         .dword 0x18b88ab84af48821, 0xfc5e1104a63344dc
                .dword 0xcae4308ab7d0d7ca, 0xb7fe634acfeeb885
                .dword 0x4a313b1c110ecb36, 0x592e9f4682430545
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xebdb40905bc11f8a, 0xa4dd64b3c36cdc62
                .dword 0xd9aee7c6903cdc6e, 0x6a3d7bf0ae58487f
d_4_0:          .dword 0x8c6dc9ddb78bec81, 0xdaa749813af3b372
d_4_1:          .dword 0xbd35508cb23fa0e4, 0x9e0efc9ddf1a34f6
d_4_2:          .dword 0x5b8ab917f89c1767, 0x8183fcf007be5dae
d_4_3:          .dword 0x5a91f219dae94333, 0x968ec42c3000ef8c
d_4_4:          .dword 0x83b9cf4d942fd153, 0x68b34a6287b2884d
d_4_5:          .dword 0xab9726866c054c55, 0x561bc11223fa42c6
d_4_6:          .dword 0xc025f0c6ac75d60a, 0x511ad29f54c636be
d_4_7:          .dword 0x4d03a72ba6a15f40, 0x92edd48786954fcf
d_4_8:          .dword 0xff915a85ae4c247e, 0x66f4e8d9ad960415
d_4_9:          .dword 0xfdba05803fbe44b0, 0xb5c790efbb4f5a00
d_4_10:         .dword 0x91e97aeca5235953, 0x3c46c50c1782d752
d_4_11:         .dword 0x3fa1bfe48b17b86e, 0xa6a7b48feaed422e
d_4_12:         .dword 0xc0485bc716414fff, 0x3c1ba011fa16025a
d_4_13:         .dword 0x8149d439fa876b12, 0xc398d34491129a5a
d_4_14:         .dword 0x05fd60165e617a49, 0xf0683d2a73e56117
d_4_15:         .dword 0xd896f067d088660b, 0x72cfb613af9dcd86
d_4_16:         .dword 0x96855f89c458edd0, 0xef99a6342460a5ec
d_4_17:         .dword 0x2fe1f046ec07ebd2, 0xeb63026408d5ae96
d_4_18:         .dword 0x5e39a6e8769577fe, 0xa502d62fb477c960
d_4_19:         .dword 0x94a563b9c39a0de5, 0x737866c264568e39
d_4_20:         .dword 0xd54d6e780d75d62c, 0xa7ac625577a60090
d_4_21:         .dword 0x6681cf2a6a02ab81, 0x2ef3a4f398c40ec3
d_4_22:         .dword 0x43c26e366ecf9542, 0x7f285473cb6bc47a
d_4_23:         .dword 0x4bacdc75083cb468, 0x6b4aa7d81ef8de03
d_4_24:         .dword 0x1d0ee00924628a63, 0xee8579f319b73fb6
d_4_25:         .dword 0x08e4ea8898897b42, 0x3f037c09f0ec36ac
d_4_26:         .dword 0x70b40c092bc5b7a9, 0x4407ac1df979ab56
d_4_27:         .dword 0xb5f8c550e7d76794, 0xf54e9621ca97d26e
                .dword 0xa6e6d5e549c42c06, 0x897e7da836329c00
                .dword 0xb6609bffdcd3c224, 0xf6d0853f97195b60
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x38f075ee7109120e, 0x1772fb07428003ff
                .dword 0x360675ae16708f28, 0x02596e366c0aecca
d_5_0:          .dword 0xef0b10704fe8ee12, 0x50cb4c01b4c90bbe
d_5_1:          .dword 0xacc4669404d0627f, 0xa326e92c6298caac
d_5_2:          .dword 0x694691edd25f4dc9, 0xac48ed0116007621
d_5_3:          .dword 0x065f6df0b23dfae1, 0x8985f9887ff9e584
d_5_4:          .dword 0x85fb56499748b102, 0xa7c1e318fb60a664
d_5_5:          .dword 0xfe44609c52c20468, 0x8cafe3be5ab032e7
d_5_6:          .dword 0x593db49a23d78656, 0xde3f907a0c3aeff5
d_5_7:          .dword 0x8c2053916e73335c, 0xdfc08b973033858f
d_5_8:          .dword 0xe43cc458a5cc2607, 0xa863fdade8964678
d_5_9:          .dword 0xdaee77c62bf0108c, 0xac0c895095df2d39
d_5_10:         .dword 0x04731ba92cc52d6b, 0xae2b5cbea64a53cd
d_5_11:         .dword 0x657ae12f0962f21f, 0x25751f0d15becf30
d_5_12:         .dword 0xc63db3781b5a0bbd, 0x4cd30da26493ad3f
d_5_13:         .dword 0xbc41cc5ac0a9e0f1, 0x83e3ccb9ac2fd89f
d_5_14:         .dword 0x1ddc6dd94edc431a, 0xa43fb56dc66e0182
d_5_15:         .dword 0x1d1c15b3e28a5491, 0x1727235a1ee2de6b
d_5_16:         .dword 0xf702ac2fdf8fb4df, 0xf6ba4816d16f90e4
d_5_17:         .dword 0x8ac0cf4cfb7bdd1e, 0xef3adb7efff528bd
d_5_18:         .dword 0xa4426711bf014b47, 0x2757b34b1e97604a
d_5_19:         .dword 0x64efa1a9c8c22391, 0x7897654215bb2c6f
d_5_20:         .dword 0xe0e7e7c7e1556a84, 0x2d1e942b53e20997
d_5_21:         .dword 0xb214c154c6e97267, 0xb2a65ab28f933755
d_5_22:         .dword 0x4870c56c48a25e44, 0x59a3cbfb54782741
d_5_23:         .dword 0x24b29833241c9537, 0x7f0c9574761e33a8
d_5_24:         .dword 0x32fefa9ca41c022e, 0xc179683f3ebf56c2
d_5_25:         .dword 0x496d8a79d411d3dc, 0x972dffe2ce17abfe
d_5_26:         .dword 0xdc526844d6048e56, 0x5fce49d61ff617e5
d_5_27:         .dword 0x9e461b323a4984ef, 0x71cabc8a29e7bfb8
                .dword 0x6f71ea3503805156, 0x5af9b21b24cdb87a
                .dword 0xfa491974d5dd54d7, 0x5d05827e14c660c0
         /* Random data */
_end_data5:
              
 
