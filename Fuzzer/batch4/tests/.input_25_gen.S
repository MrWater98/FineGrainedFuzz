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
_p0:    la x12, _p2                               ;
        srai x12, x12, 1                          ;
        csrrs x11, pmpaddr3, x12                  ;
_p1:    csrrwi x11, sscratch, 31                  ;
_p2:    xor x13, x13, x13                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 11                         ;
        add x13, x13, x11                         ;
        csrrw x14, mie, x13                       ;
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
_s0:    fmsub.s f10, f3, f20, f31, rtz            ;
_s1:    la x16, d_2_19                            ;
        sh x28, 22(x16)                           ;
_s2:    la x16, d_0_20                            ;
        addi x16, x16, 0                          ;
        amoxor.w x16, x13, (x16)                  ;
_s3:    la x16, d_5_15                            ;
        lh x12, 26(x16)                           ;
_s4:    fcvt.l.s x1, f7, rmm                      ;
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
_l0:    fsgnjn.s f5, f2, f27                      ;
_l1:    fence.i                                   ;
_l2:    la x18, _l99                              ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l3:    la x11, d_3_13                            ;
        addi x11, x11, -0                         ;
        amoswap.d x7, x21, (x11)                  ;
_l4:    csrrwi x10, mscratch, 28                  ;
_l5:    la x14, d_3_16                            ;
        lb x26, -4(x14)                           ;
_l6:    la x25, d_0_11                            ;
        addi x25, x25, -16                        ;
        amoor.d x26, x7, (x25)                    ;
_l7:    fmv.x.w x16, f5                           ;
_l8:    la x27, d_0_18                            ;
        addi x27, x27, -24                        ;
        amoor.w x28, x8, (x27)                    ;
_l9:    sraiw x10, x26, 24                        ;
_l10:   fcvt.l.s x30, f7, rmm                     ;
_l11:   fmadd.s f18, f7, f15, f3, rdn             ;
_l12:   fsgnjx.s f6, f20, f26                     ;
_l13:   sllw x6, x25, x9                          ;
_l14:   li x17, 1                                 ;
        la x9, pt3                                ;
        addi x9, x9, 56                           ;
        sfence.vma x17, x9                        ;
_l15:   la x8, d_5_26                             ;
        addi x8, x8, -0                           ;
        amomin.w x18, x4, (x8)                    ;
_l16:   ebreak                                    ;
_l17:   csrrci x9, mscratch, 8                    ;
_l18:   fmsub.s f23, f30, f24, f30, rmm           ;
_l19:   mulhsu x19, x8, x6                        ;
_l20:   fcvt.wu.s x8, f2, rtz                     ;
_l21:   slli x30, x10, 63                         ;
_l22:   la x27, _l27                              ;
        jalr x13, 0(x27)                          ;
_l23:   remu x7, x14, x18                         ;
_l24:   la x10, d_2_10                            ;
        addi x10, x10, 16                         ;
        amoxor.w x19, x12, (x10)                  ;
_l25:   la x1, d_0_16                             ;
        fsw f22, 0(x1)                            ;
_l26:   la x29, _l123                             ;
        jalr x6, 0(x29)                           ;
_l27:   fcvt.lu.s x4, f7, rdn                     ;
_l28:   srli x23, x23, 0                          ;
_l29:   fmin.s f19, f1, f21                       ;
_l30:   flt.s x5, f13, f21                        ;
_l31:   srliw x29, x6, 0                          ;
_l32:   slti x22, x18, 0                          ;
_l33:   fmin.s f31, f29, f10                      ;
_l34:   la x7, d_1_5                              ;
        addi x7, x7, -28                          ;
        lui x22, 0xffe00                          ;
        xor x7, x7, x22                           ;
        amoand.w x22, x22, (x7)                   ;
_l35:   la x18, d_5_15                            ;
        addi x18, x18, -16                        ;
        amomin.d x21, x22, (x18)                  ;
_l36:   addiw x26, x10, -1376                     ;
_l37:   fmadd.s f8, f3, f24, f5, rne              ;
_l38:   beq x18, x30, _l56                        ;
_l39:   la x30, d_1_3                             ;
        addi x30, x30, -24                        ;
        amoxor.d x18, x4, (x30)                   ;
_l40:   remw x27, x1, x24                         ;
_l41:   la x10, d_5_12                            ;
        addi x10, x10, 0                          ;
        amomax.d x7, x25, (x10)                   ;
_l42:   la x21, d_4_12                            ;
        sh x29, -18(x21)                          ;
_l43:   sltiu x27, x11, -2047                     ;
_l44:   mulhsu x18, x10, x29                      ;
_l45:   srliw x18, x14, 0                         ;
_l46:   xor x9, x9, x9                            ;
        csrrw x24, mhartid, x9                    ;
_l47:   la x29, d_2_22                            ;
        ld x6, 0(x29)                             ;
_l48:   xor x3, x3, x3                            ;
        addi x9, zero, 1                          ;
        slli x9, x9, 23                           ;
        add x3, x3, x9                            ;
        addi x26, zero, 1                         ;
        slli x26, x26, 0                          ;
        add x3, x3, x26                           ;
        csrrw x11, sstatus, x3                    ;
_l49:   la x18, d_5_9                             ;
        addi x18, x18, -16                        ;
        amoor.w x22, x2, (x18)                    ;
_l50:   remu x13, x20, x3                         ;
_l51:   la x15, d_2_21                            ;
        lh x13, -26(x15)                          ;
_l52:   la x11, d_5_13                            ;
        srai x11, x11, 1                          ;
        csrrs x2, pmpaddr1, x11                   ;
_l53:   la x28, d_4_20                            ;
        addi x28, x28, 16                         ;
        amominu.d x3, x26, (x28)                  ;
_l54:   la x25, d_5_17                            ;
        addi x25, x25, 8                          ;
        amoxor.w x4, x16, (x25)                   ;
_l55:   la x24, _l104                             ;
        jalr x4, 0(x24)                           ;
_l56:   auipc x2, 464885                          ;
_l57:   fence                                     ;
_l58:   la x5, d_1_13                             ;
        lhu x30, 12(x5)                           ;
_l59:   la x27, d_2_27                            ;
        sd x1, -8(x27)                            ;
_l60:   sraw x3, x29, x14                         ;
_l61:   fcvt.s.w f18, x25, rmm                    ;
_l62:   feq.s x23, f19, f25                       ;
_l63:   fmin.s f24, f3, f1                        ;
_l64:   la x26, d_4_2                             ;
        sw x30, 8(x26)                            ;
_l65:   slli x12, x29, 28                         ;
_l66:   fdiv.s f12, f5, f21, rtz                  ;
_l67:   li x2, 1                                  ;
        la x16, pt3                               ;
        addi x16, x16, 56                         ;
        sfence.vma x2, x16                        ;
_l68:   lui x15, 8                                ;
_l69:   la x6, d_4_3                              ;
        addi x6, x6, 8                            ;
        amoxor.d x8, x13, (x6)                    ;
_l70:   fence                                     ;
_l71:   sraiw x28, x9, 17                         ;
_l72:   la x14, d_4_19                            ;
        fsw f21, -0(x14)                          ;
_l73:   la x23, d_0_18                            ;
        addi x23, x23, 24                         ;
        amoand.w x24, x19, (x23)                  ;
_l74:   la x24, d_3_23                            ;
        addi x24, x24, 8                          ;
        lui x16, 0xffe00                          ;
        xor x24, x24, x16                         ;
        amoadd.w x13, x16, (x24)                  ;
_l75:   csrrsi x10, pmpaddr2, 24                  ;
_l76:   addi x26, x15, -470                       ;
_l77:   sraw x12, x26, x21                        ;
_l78:   la x14, d_2_6                             ;
        addi x14, x14, -24                        ;
        amoxor.w x13, x31, (x14)                  ;
_l79:   andi x13, x29, -774                       ;
_l80:   srliw x20, x4, 31                         ;
_l81:   flt.s x11, f16, f16                       ;
_l82:   la x1, d_5_23                             ;
        addi x1, x1, 24                           ;
        amomaxu.w x23, x27, (x1)                  ;
_l83:   la x4, d_3_4                              ;
        addi x4, x4, 8                            ;
        amoxor.d x12, x27, (x4)                   ;
_l84:   xor x23, x23, x23                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 14                           ;
        add x23, x23, x1                          ;
        addi x29, zero, 3                         ;
        slli x29, x29, 15                         ;
        add x23, x23, x29                         ;
        csrrs x7, fflags, x23                     ;
_l85:   fsgnjx.s f22, f7, f2                      ;
_l86:   srai x10, x3, 47                          ;
_l87:   la x12, d_1_9                             ;
        fsw f16, -24(x12)                         ;
_l88:   auipc x23, 1048575                        ;
_l89:   li x10, 0                                 ;
        la x23, pt3                               ;
        addi x23, x23, 32                         ;
        sfence.vma x10, x23                       ;
_l90:   la x17, d_1_26                            ;
        ld x8, -16(x17)                           ;
_l91:   fmax.s f17, f9, f1                        ;
_l92:   la x27, d_3_1                             ;
        addi x27, x27, -8                         ;
        sc.w x9, x16, (x27)                       ;
_l93:   fmadd.s f21, f24, f2, f31, rdn            ;
_l94:   la x1, d_5_23                             ;
        addi x1, x1, -4                           ;
        amomaxu.w x20, x1, (x1)                   ;
_l95:   la x19, d_1_22                            ;
        lhu x10, -14(x19)                         ;
_l96:   bne x29, x30, _l110                       ;
_l97:   la x28, d_0_27                            ;
        srai x28, x28, 1                          ;
        csrrw x5, pmpaddr4, x28                   ;
_l98:   fnmsub.s f17, f28, f1, f21, rup           ;
_l99:   la x14, d_1_11                            ;
        addi x14, x14, 28                         ;
        amoadd.w x22, x29, (x14)                  ;
_l100:  xor x29, x29, x29                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 23                         ;
        add x29, x29, x13                         ;
        csrrw x2, frm, x29                        ;
_l101:  bgeu x9, x19, _l117                       ;
_l102:  slliw x2, x27, 3                          ;
_l103:  fsgnjx.s f30, f2, f20                     ;
_l104:  la x29, d_5_5                             ;
        addi x29, x29, -8                         ;
        amoand.d x16, x8, (x29)                   ;
_l105:  la x13, d_5_26                            ;
        addi x13, x13, 4                          ;
        amomax.w x11, x10, (x13)                  ;
_l106:  srliw x16, x9, 31                         ;
_l107:  la x24, d_1_14                            ;
        flw f20, -12(x24)                         ;
_l108:  la x8, d_2_24                             ;
        lwu x7, -12(x8)                           ;
_l109:  la x6, _l120                              ;
        csrrw zero, sepc, x6                      ;
        sret                                      ;
_l110:  xor x8, x8, x8                            ;
        addi x30, zero, 3                         ;
        slli x30, x30, 26                         ;
        add x8, x8, x30                           ;
        addi x30, zero, 1                         ;
        slli x30, x30, 4                          ;
        add x8, x8, x30                           ;
        addi x17, zero, 3                         ;
        slli x17, x17, 21                         ;
        add x8, x8, x17                           ;
        csrrs x14, mepc, x8                       ;
_l111:  fcvt.s.lu f2, x19, rdn                    ;
_l112:  la x25, d_1_23                            ;
        addi x25, x25, -20                        ;
        amomaxu.w x18, x17, (x25)                 ;
_l113:  fmadd.s f3, f25, f26, f10, rup            ;
_l114:  la x24, d_2_22                            ;
        lhu x27, -12(x24)                         ;
_l115:  la x12, d_2_4                             ;
        addi x12, x12, -0                         ;
        lui x1, 0xffe00                           ;
        xor x12, x12, x1                          ;
        lr.w x16, (x12)                           ;
_l116:  la x22, d_1_22                            ;
        addi x22, x22, -0                         ;
        lr.d x13, (x22)                           ;
_l117:  fmin.s f5, f29, f18                       ;
_l118:  la x24, d_3_3                             ;
        addi x24, x24, 8                          ;
        sc.d x16, x24, (x24)                      ;
_l119:  auipc x10, 0                              ;
_l120:  ecall                                     ;
_l121:  la x22, d_3_17                            ;
        addi x22, x22, 0                          ;
        sc.d x27, x22, (x22)                      ;
_l122:  srli x6, x24, 6                           ;
_l123:;
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
                .dword 0xe8b50a31db6c0b03, 0x0f17426185760422
                .dword 0x20ca27f6f96ee383, 0x7bcbaf319e2e91e6
d_0_0:          .dword 0xf151d15c7ed7f678, 0x3d0e73eda4b861f4
d_0_1:          .dword 0xdc143d0ac91dc0d7, 0x144bce84ecdf7b10
d_0_2:          .dword 0xc5d603ffcddf7599, 0xf24db99c321d518e
d_0_3:          .dword 0xc458199c5a856daa, 0xbadbb8bc7b5b01d4
d_0_4:          .dword 0x0cb1099c123bdebb, 0x5b15f5e730feb9ee
d_0_5:          .dword 0xee20adfe68c80a08, 0x2f5e77221b12f073
d_0_6:          .dword 0xbdcc5dda274c4a8c, 0xebaed12c145de649
d_0_7:          .dword 0x89bfcfb47af8f326, 0xc7aac12b4568b2ed
d_0_8:          .dword 0x546a3e441650c0a0, 0xeada09b6b956bf09
d_0_9:          .dword 0x8bb181d989ee4eaf, 0x0e62adc4ffd84987
d_0_10:         .dword 0x8e011cc20f0164e6, 0x7fcdf5855f081611
d_0_11:         .dword 0x4c953420a72e709c, 0xfa239c17138caaa4
d_0_12:         .dword 0x479c4a40200eef83, 0x9ff0f32e3e0dd217
d_0_13:         .dword 0x1a0ff5ff1ecd472f, 0x1b27fbe554994ad9
d_0_14:         .dword 0x916527d8e52b7419, 0x2fdd543862e1b282
d_0_15:         .dword 0x225569ddeb4baf22, 0x86bc4dd5e779f21c
d_0_16:         .dword 0x5308417c9e5aaafc, 0x33b0184c6583b8fc
d_0_17:         .dword 0x33368e44091ca52a, 0x865540e5694ad6fb
d_0_18:         .dword 0x5db07f5f6cd51f47, 0xe0e5dc1ee61164bd
d_0_19:         .dword 0xd92d0ccbe97b14e1, 0xb4e658040fe80994
d_0_20:         .dword 0x4095a12b99a7b17d, 0xfca90072a4378688
d_0_21:         .dword 0x80715aa594c1a5b0, 0x21a1a24c443f446d
d_0_22:         .dword 0xb0caee50d0316a3b, 0x267e7f5946287bf1
d_0_23:         .dword 0x43cebb1c85e1717e, 0x947c6ac79385c3fc
d_0_24:         .dword 0x64a947c98b1620f6, 0xab99eb63739e736d
d_0_25:         .dword 0xca18d0659e0f6a40, 0x8bddb9d7a31dc9ce
d_0_26:         .dword 0x49e39f9a0d758e90, 0x81253010fe825ade
d_0_27:         .dword 0xe4bae43edaebfe46, 0xc04035b3f38f9486
                .dword 0x06fd5b10491bcb32, 0xc63b785d3420e251
                .dword 0x25e8e18741ccd712, 0xf4723f3591a51ab2
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa45fc2ef3afe7105, 0xa939a63b6cdbabb0
                .dword 0x908463650e731a24, 0xd1914a7067c6b374
d_1_0:          .dword 0xbd37ff03c597d59a, 0x41caaa467f893c76
d_1_1:          .dword 0x5834d0e0258c336b, 0x934a9ab386c316f8
d_1_2:          .dword 0x837323b84fbfc96e, 0x70e755fff9d35d56
d_1_3:          .dword 0x3202ba51fc512b6f, 0x2fc5547347e8096a
d_1_4:          .dword 0x9937a044be022950, 0x8e3f8aa3b0609321
d_1_5:          .dword 0xb25896274a0b5eeb, 0x3dd544fa7b28b278
d_1_6:          .dword 0x95a321eba7441dd3, 0x5819facb11189a3f
d_1_7:          .dword 0x7cb5c1792ca1599d, 0x2cc945dbad5e50ba
d_1_8:          .dword 0xfb26ce88c502791c, 0xba1dbfcdbe172512
d_1_9:          .dword 0xa2488df174bdb5c4, 0xb0fc5027b9751232
d_1_10:         .dword 0xba4c70805949b3ec, 0xb14902130e0b3b2d
d_1_11:         .dword 0xdfb75174248adc34, 0x94f31ab87bb429cc
d_1_12:         .dword 0xdfdeba2353462e3c, 0x613175d2b3f9dde6
d_1_13:         .dword 0xa85e9032716c3af8, 0x5ae587f45045bb49
d_1_14:         .dword 0xf45b132fd8ed6904, 0x29345d3290c3ec96
d_1_15:         .dword 0x57e2aa9a69fa173d, 0x6af59b76f463cf7a
d_1_16:         .dword 0xd191f05cde3d3692, 0x9d109f4dffe4a189
d_1_17:         .dword 0x3eb8b88a0de6fa06, 0xb7f68ce11e8df4b5
d_1_18:         .dword 0xd763f31e8aa5f1d5, 0x75ae490fca963653
d_1_19:         .dword 0x21fc95ddc6b410f5, 0x76d4fc21f18e04f4
d_1_20:         .dword 0x9c3f2caaabadca85, 0xb3ec824c32338113
d_1_21:         .dword 0x2d761bc4b07e4ffa, 0x98d13872c8a64240
d_1_22:         .dword 0x1c48abe444b5a61b, 0xe3ffccb90adbbba9
d_1_23:         .dword 0x7391697b59f0e8c9, 0xe0b2cde668da481c
d_1_24:         .dword 0x04b6b75c87d647b2, 0xe17818756c585780
d_1_25:         .dword 0x76e66d804a2411ae, 0x605f73f08042846d
d_1_26:         .dword 0xe8da0e28c48d6a2e, 0xaacc19d430d63df3
d_1_27:         .dword 0xb040a469456f0547, 0xb228667dc05174f3
                .dword 0x9f9e9e9b7c42dc96, 0xe66516bc27eb0e31
                .dword 0x5646b2602cb9e32c, 0xd1e48ed691e5a2eb
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xa4c488c339f0ecda, 0xc9098b3528cde063
                .dword 0x9f59687d3330f53b, 0xf44e93f2ca3bd76f
d_2_0:          .dword 0x7baf0d110e826d0a, 0x78e32ab553bce4c9
d_2_1:          .dword 0x8c572028de684b2a, 0x310adc09df0597ef
d_2_2:          .dword 0x627ed3c709742213, 0xc9f585f1a40aa4b5
d_2_3:          .dword 0x0aaf3352f40fe8f8, 0xa31d5ee420f3bde9
d_2_4:          .dword 0xe15799157210a670, 0x0d52b5afaf55c4a5
d_2_5:          .dword 0x2175d722984b3872, 0x416ab92735d7241d
d_2_6:          .dword 0xcaffd34dd1f910f7, 0x79f0a2b83a4d9f5d
d_2_7:          .dword 0x73b15063c519b430, 0x0209d8ac2d00911f
d_2_8:          .dword 0xff03c8217717bf07, 0x53bde2e2bb76bfea
d_2_9:          .dword 0xcd41e170578a6c80, 0xa2b59657b0cec92a
d_2_10:         .dword 0x86b122e1f153e0b7, 0xe2943a9be81a0382
d_2_11:         .dword 0x6f6d450266fa8fe1, 0x8f337f0eaab8c90a
d_2_12:         .dword 0x69b24de4658abbf7, 0x0b0d808078025a92
d_2_13:         .dword 0x84353302c9d623d5, 0x79d70c5f27f5da77
d_2_14:         .dword 0x5bf0e54e5bb848dd, 0xdbb1d9346b257002
d_2_15:         .dword 0x3ffc72955def90ce, 0x1588dadec0aded7d
d_2_16:         .dword 0xc36ac7054db85541, 0x3f96ed2742e4c970
d_2_17:         .dword 0x73575875f8b01684, 0x7b8ad737ad77d1ed
d_2_18:         .dword 0x2a87eddaebfef745, 0xe628567f598a5a03
d_2_19:         .dword 0x01ef4fec2995fd52, 0xa5e68956bd57a48a
d_2_20:         .dword 0x1b1002e3ce382d10, 0x68dacd4befdf6b8c
d_2_21:         .dword 0x9128dc874f3ee29c, 0x724e5d18c0e78cdd
d_2_22:         .dword 0xa32165bb04008a29, 0x4e96c8359d9a8344
d_2_23:         .dword 0x36063c148952c4fa, 0xc7c0d46cf9bcf636
d_2_24:         .dword 0xc5229434ad540ab8, 0xe6a37882d0ce1a99
d_2_25:         .dword 0xd1baf4946fba9bf2, 0x2cd3dab097f1b527
d_2_26:         .dword 0x88e3f229f7904c80, 0x7935710ff87fbc1e
d_2_27:         .dword 0xff0aaedbd1e9e90a, 0x0344a4f496829dda
                .dword 0xddda7a62e6ad33dc, 0x322a3ff7ff7ff149
                .dword 0xcc12f3785da487e4, 0xd02e9bc4a9e2a7e0
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xbc45405763f0d9a0, 0x6d95c36965c190af
                .dword 0x0e9e6f0a54758424, 0xa9a1fb1550829450
d_3_0:          .dword 0xbf91dde1e60c242d, 0xcce8c6228453b880
d_3_1:          .dword 0x61003609be8faef7, 0xf61de88f37c78383
d_3_2:          .dword 0x7aa8cbaf11e7ce0f, 0x32cab607ee42f8a2
d_3_3:          .dword 0xcfb1e9c3ca964bf3, 0xe8406c21ea47dc3a
d_3_4:          .dword 0xb78377d5d2e195e4, 0xd619086f7dac66b3
d_3_5:          .dword 0xb469afde74d3fe80, 0xe0e54176e6141df7
d_3_6:          .dword 0xe0a893e8fa53457c, 0x0a61cae806cd6433
d_3_7:          .dword 0x55c749a2d82716c6, 0x2243641909683bfa
d_3_8:          .dword 0x3e4fba7b2e504168, 0x8fd558147a89aafc
d_3_9:          .dword 0xb3c140f44d56d92e, 0x11c2e57c32520eb5
d_3_10:         .dword 0xb987c2f8340f0a83, 0x40f399413bab06a3
d_3_11:         .dword 0xa79afeba43474ddd, 0xd21f5f90f65ca84a
d_3_12:         .dword 0x46bb0716e7c73124, 0xe906dcbdfbb9620b
d_3_13:         .dword 0xd3eb2369906a5331, 0xc14a69ab9176b3c1
d_3_14:         .dword 0x5e859f4e878171bb, 0x3b704f2eb8cee00a
d_3_15:         .dword 0xebf15d07db3441a5, 0x2b9d6bde2e5d7d7a
d_3_16:         .dword 0xa8c2a703272fa287, 0xd15170683a1203bd
d_3_17:         .dword 0x982c3af4c155be66, 0x439f9026e2907bb5
d_3_18:         .dword 0x46f4118cc3b7d207, 0x153724374fa0975a
d_3_19:         .dword 0xe22fee6cf86e4777, 0x7f9e35d01bda978e
d_3_20:         .dword 0xb7673584bdee7120, 0x7cd373bedfa4abe4
d_3_21:         .dword 0xce6104b4730b3be6, 0x08fd72539d9ba82c
d_3_22:         .dword 0x801a800d19e20a0f, 0xb29dfe16fbe2accb
d_3_23:         .dword 0x26d8780ff0da59ad, 0x763b3f6b11d536e5
d_3_24:         .dword 0x7d3821d1721427b8, 0x17c63269d619c948
d_3_25:         .dword 0xfa78000794017f30, 0x187893874860a48e
d_3_26:         .dword 0xb903c94eecb60948, 0xd2df3d35188f2b8e
d_3_27:         .dword 0x2d4a720e0fb353aa, 0x4552b64b952306e1
                .dword 0x768f8d08cb15409e, 0xb3211cf30b72352f
                .dword 0x24689e3407e67ec8, 0x0459bc9953bcfb62
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x9d5898465a1551ec, 0xdd0926f8f6b8399c
                .dword 0x218137881ccdcc8d, 0xb8420f114506a055
d_4_0:          .dword 0xbe00b1cd21d0b97f, 0xecc16a2081750516
d_4_1:          .dword 0xceebe2543e0d869d, 0x9c58544b5c24d614
d_4_2:          .dword 0xc6a6d056bb9e0a90, 0x25b80b61ad6ac51c
d_4_3:          .dword 0xc27fc69d2f96819a, 0xccd11f8ce69bcacc
d_4_4:          .dword 0x8f0faec779ab2ef7, 0x8a087e198e4b2ab7
d_4_5:          .dword 0x94493536bc319720, 0xc25a4ef2a4b88a4f
d_4_6:          .dword 0xc623b512c601be6d, 0x8801ed079c4495cd
d_4_7:          .dword 0x0e9971f634d3eaad, 0x74f8e4ef2eb326eb
d_4_8:          .dword 0xe20c1144a268bc03, 0x2c0ed4bf1e24e448
d_4_9:          .dword 0x19b5121c4c244fbe, 0xca9c393fd9d391da
d_4_10:         .dword 0xe2bb5817b5fc69bc, 0x71cd4a4220c18347
d_4_11:         .dword 0x26aee3083a69dbbd, 0x521094db49be5975
d_4_12:         .dword 0x07664cae4bf4f763, 0x8c7e6d4c2cda3d56
d_4_13:         .dword 0xa2bcc977d5ac6f41, 0x3f0becf04136c1fb
d_4_14:         .dword 0xf513bb02d6aed14b, 0x4c93bc5534795916
d_4_15:         .dword 0xa51e3f4ab5bbb27b, 0xdd3d4d1a730c6439
d_4_16:         .dword 0x52ea5e37d5803e96, 0xa8c37e2c49a95b21
d_4_17:         .dword 0xcb026ce3f96a2f53, 0x52be12d72a2ed4bf
d_4_18:         .dword 0x84d42c962ea7bcc3, 0xa4a16c6f6e1c969a
d_4_19:         .dword 0xad50ff65963fdc7a, 0xf3846f423ffe496a
d_4_20:         .dword 0xbb4891e1dc47aef3, 0xc1ff9d27527366ac
d_4_21:         .dword 0x11dfbcd9679697ba, 0xed586d5e44fe5b06
d_4_22:         .dword 0x621b02529f436af3, 0x8e701abcdbe25fe9
d_4_23:         .dword 0xf271755376cd1613, 0xd41ff7319422735e
d_4_24:         .dword 0xc7f2185ebb06e9bc, 0xe95d335e3137b449
d_4_25:         .dword 0xcf16df2d295b41ef, 0x1fd58af5e4cd9b6e
d_4_26:         .dword 0x999f4710693f9014, 0x64417575bc889846
d_4_27:         .dword 0x3fd9e27625a0c6aa, 0x1f83e8f30da97930
                .dword 0x1531c01860e8aab6, 0x7751fc38ac5ffcdc
                .dword 0x3d178fa00f8c4e45, 0xf1181d7693c8900a
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x680b3b49893c2074, 0xc7d72405516c1033
                .dword 0x2748a69933f799b9, 0x6bc279e4be6eddb4
d_5_0:          .dword 0x328c6d7f32605de0, 0x96ef0179c3a3bdda
d_5_1:          .dword 0xda1468fe47476b6b, 0x7f0ad80cc7cd1ecb
d_5_2:          .dword 0xefc2416f80afde2a, 0x76bdbaa47d0b9b15
d_5_3:          .dword 0x50d13679837c0ce9, 0xc11ba315182f9b44
d_5_4:          .dword 0x7bfafc23a31eed1b, 0xcdbd1c1788ccc6e3
d_5_5:          .dword 0x26dafd2f36a458ac, 0x605f4edfee3fc91f
d_5_6:          .dword 0x393d4296a9f0244c, 0xc0d338ce5cd84074
d_5_7:          .dword 0xa65ba5d61c5ccde3, 0xecbe2ec0436161cc
d_5_8:          .dword 0x7ccda284068ce06e, 0x7b593fefb665efe8
d_5_9:          .dword 0xd8d7c265080383ba, 0x076084f430714983
d_5_10:         .dword 0x00689aa7d29490f1, 0xc3356e26b99a86ba
d_5_11:         .dword 0x853f3f3464aa7df0, 0x87f7c54720a3b4b5
d_5_12:         .dword 0x199b4323014d1d8b, 0xd4d5fcebc0c89018
d_5_13:         .dword 0x1afb73f650b98130, 0x2e41d5f000f26479
d_5_14:         .dword 0x7ddb9fb2547bdf20, 0xf98d3ed1b83597d2
d_5_15:         .dword 0xf75e48b4e285e36e, 0x81f951effe013aa7
d_5_16:         .dword 0x4198d296b4a0c9eb, 0xce0bb0710586c402
d_5_17:         .dword 0xf8b20cf0b7348c32, 0xd2da021f806a0b45
d_5_18:         .dword 0xf4ee56eb581dd4a9, 0xfe994143ce921eff
d_5_19:         .dword 0x104c1e7a83065a95, 0x7d07822d7fa2efbf
d_5_20:         .dword 0x2517bb3884d62d06, 0xf2d999907eeea634
d_5_21:         .dword 0x60bf31d4c4357099, 0x66e2cf280f730983
d_5_22:         .dword 0x6765a548a38ef18e, 0xa04860b4929fbf81
d_5_23:         .dword 0xf8a9baf760a35761, 0x1b5fdcd3d97c7632
d_5_24:         .dword 0xe864fdfaadd22303, 0x49d1d695b4fb9ba1
d_5_25:         .dword 0x4d9c6df65fbba184, 0xbf278fa97f4ae6a7
d_5_26:         .dword 0x27bc5f9f62ced3ed, 0x06541b049d7169fe
d_5_27:         .dword 0xec246e21eb319e24, 0x838460d920741d63
                .dword 0x1593fdc5a7a15938, 0x02a9bdd1a5df1c3e
                .dword 0xb90c5234f3cd938b, 0x1bffc7aeef217b3d
         /* Random data */
_end_data5:
              
 
