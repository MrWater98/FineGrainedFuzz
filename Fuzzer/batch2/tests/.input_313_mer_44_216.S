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
_p0:    csrrsi x10, scause, 29                    ;
_p1:    xor x13, x13, x13                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 18                         ;
        add x13, x13, x10                         ;
        csrrc x13, sscratch, x13                  ;
_p2:    csrrci x13, satp, 28                      ;
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
_s0:    fcvt.s.w f20, x17, rtz                    ;
_s1:    fence                                     ;
_s2:    la x6, d_2_12                             ;
        addi x6, x6, -24                          ;
        lui x6, 0xffe00                           ;
        xor x6, x6, x6                            ;
        amoxor.w x15, x6, (x6)                    ;
_s3:    fsqrt.s f15, f14, dyn                     ;
_s4:    sllw x9, x4, x26                          ;
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
_l0:    lui x30, 220617                           ;
_l1:    bge x15, x25, _l30                                ;
_l2:    fsub.s f23, f12, f3, rdn                  ;
_l3:    fmul.s f5, f20, f24, rtz                  ;
_l4:    la x7, d_2_2                              ;
        sb x9, -31(x7)                            ;
_l5:    ori x10, x28, -7                          ;
_l6:    la x12, d_5_16                            ;
        addi x12, x12, 8                          ;
        amominu.w x21, x11, (x12)                 ;
_l7:    la x13, d_4_10                            ;
        lw x13, -28(x13)                          ;
_l8:    sllw x12, x18, x15                        ;
_l9:    la x24, d_0_19                            ;
        addi x24, x24, -24                        ;
        amomaxu.d x29, x13, (x24)                 ;
_l10:   la x26, _l88                                      ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l11:   la x13, d_1_22                            ;
        ld x1, -0(x13)                            ;
_l12:   bge x17, x10, _l84                        ;
_l13:   fadd.s f22, f20, f25, rne                 ;
_l14:   flt.s x10, f15, f9                        ;
_l15:   srai x17, x4, 52                          ;
_l16:   la x10, d_1_13                            ;
        sh x11, 6(x10)                            ;
_l17:   xori x6, x25, 1327                        ;
_l18:   la x8, d_2_12                             ;
        addi x8, x8, -12                          ;
        amomax.w x4, x28, (x8)                    ;
_l19:   csrrwi x10, sepc, 28                      ;
_l20:   addi x21, x3, -3                          ;
_l21:   addiw x21, x29, -2018                     ;
_l22:   bge x10, x11, _l26                                ;
_l23:   la x18, _l88                                      ;
        csrrw zero, sepc, x18                     ;
        sret                                      ;
_l24:   fsgnjx.s f23, f18, f7                     ;
_l25:   srlw x21, x30, x4                         ;
_l26:   rem x28, x8, x25                          ;
_l27:   fmv.x.w x0, f3                            ;
_l28:   la x3, d_5_7                              ;
        addi x3, x3, 0                            ;
        amomaxu.w x5, x8, (x3)                    ;
_l29:   bne x21, x11, _l55                                ;
_l30:   la x1, _l66                                       ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l31:   auipc x10, 12                             ;
_l32:   la x10, d_0_5                             ;
        addi x10, x10, 24                         ;
        amomin.w x9, x26, (x10)                   ;
_l33:   fcvt.s.w f23, x6, dyn                     ;
_l34:   la x19, d_1_17                            ;
        addi x19, x19, 0                          ;
        amoxor.d x29, x2, (x19)                   ;
_l35:   la x21, d_4_23                            ;
        addi x21, x21, 8                          ;
        sc.w x1, x28, (x21)                       ;
_l36:   la x18, d_3_10                            ;
        addi x18, x18, -8                         ;
        amomax.w x25, x13, (x18)                  ;
_l37:   sraiw x20, x14, 27                        ;
_l38:   fcvt.lu.s x27, f28, rmm                   ;
_l39:   la x20, d_3_5                             ;
        lw x15, 0(x20)                            ;
_l40:   div x14, x2, x30                          ;
_l41:   la x1, d_3_2                              ;
        addi x1, x1, 16                           ;
        lui x9, 0xffe00                           ;
        xor x1, x1, x9                            ;
        amomaxu.d x7, x9, (x1)                    ;
_l42:   csrrsi x9, pmpaddr1, 24                   ;
_l43:   la x1, d_0_22                             ;
        fsw f20, -0(x1)                           ;
_l44:   fsgnj.s f2, f0, f19                       ;
_l45:   divuw x6, x28, x18                        ;
_l46:   fcvt.w.s x11, f6, rmm                     ;
_l47:   la x6, d_3_13                             ;
        addi x6, x6, 8                            ;
        amomax.w x26, x26, (x6)                   ;
_l48:   auipc x6, 628106                          ;
_l49:   ebreak                                    ;
_l50:   la x25, d_5_15                            ;
        addi x25, x25, -28                        ;
        sc.w x6, x28, (x25)                       ;
_l51:   divu x5, x27, x12                         ;
_l52:   la x14, _l73                                      ;
        jalr x29, 0(x14)                          ;
_l53:   blt x18, x21, _l95                        ;
_l54:   li x28, 0                                 ;
        la x5, pt2                                ;
        addi x5, x5, 8                            ;
        sfence.vma x28, x5                        ;
_l55:   la x25, d_0_3                             ;
        addi x25, x25, 28                         ;
        amominu.w x26, x16, (x25)                 ;
_l56:   mul x2, x19, x27                          ;
_l57:   la x7, d_2_5                              ;
        addi x7, x7, -16                          ;
        amoxor.d x1, x16, (x7)                    ;
_l58:   beq x1, x10, _l90                                 ;
_l59:   fnmsub.s f24, f19, f7, f26, rmm           ;
_l60:   la x16, d_5_21                            ;
        sh x8, -0(x16)                            ;
_l61:   la x17, d_4_13                            ;
        addi x17, x17, -0                         ;
        lui x22, 0xffe00                          ;
        xor x17, x17, x22                         ;
        lr.w x16, (x17)                           ;
_l62:   la x23, d_3_18                            ;
        ld x4, 24(x23)                            ;
_l63:   la x27, d_3_14                            ;
        addi x27, x27, -16                        ;
        amomin.d x18, x1, (x27)                   ;
_l64:   la x23, d_5_17                            ;
        flw f28, -20(x23)                         ;
_l65:   la x9, d_5_19                             ;
        addi x9, x9, 24                           ;
        sc.d x25, x9, (x9)                        ;
_l66:   srai x22, x29, 7                          ;
_l67:   fcvt.s.wu f25, x13, rdn                   ;
_l68:   la x29, d_1_7                             ;
        addi x29, x29, 24                         ;
        amoxor.w x25, x22, (x29)                  ;
_l69:   srli x10, x16, 50                         ;
_l70:   mul x0, x23, x15                          ;
_l71:   sllw x7, x27, x22                         ;
_l72:   la x22, d_5_27                            ;
        addi x22, x22, -16                        ;
        amomax.d x20, x29, (x22)                  ;
_l73:   la x22, d_5_26                            ;
        srai x22, x22, 1                          ;
        csrrs x1, pmpaddr7, x22                   ;
_l74:   fence.i                                   ;
_l75:   la x9, d_4_11                             ;
        addi x9, x9, -16                          ;
        amoor.d x4, x12, (x9)                     ;
_l76:   la x2, d_1_10                             ;
        addi x2, x2, -16                          ;
        amomaxu.w x23, x17, (x2)                  ;
_l77:   subw x28, x25, x4                         ;
_l78:   la x20, d_0_26                            ;
        addi x20, x20, 8                          ;
        amoxor.d x24, x11, (x20)                  ;
_l79:   la x17, d_1_11                            ;
        lb x6, 20(x17)                            ;
_l80:   la x18, d_1_23                            ;
        addi x18, x18, -24                        ;
        amoand.d x29, x29, (x18)                  ;
_l81:   lui x1, 777051                            ;
_l82:   fmul.s f14, f3, f5, rmm                   ;
_l83:   beq x8, x15, _l93                                 ;
_l84:   fcvt.s.lu f6, x18, rdn                    ;
_l85:   fcvt.s.lu f11, x28, rmm                   ;
_l86:   la x26, d_4_27                            ;
        fsw f13, 24(x26)                          ;
_l87:   fmv.x.w x12, f22                          ;
_l88:   srli x21, x8, 58                          ;
_l89:   la x11, d_1_24                            ;
        addi x11, x11, 8                          ;
        amomax.w x3, x5, (x11)                    ;
_l90:   sllw x6, x1, x3                           ;
_l91:   xori x20, x6, -20                         ;
_l92:   la x14, d_1_8                             ;
        addi x14, x14, 8                          ;
        amoor.w x13, x18, (x14)                   ;
_l93:   rem x9, x10, x30                          ;
_l94:   andi x8, x12, -746                        ;
_l95:   la x16, d_4_25                            ;
        addi x16, x16, -0                         ;
        amoor.d x7, x21, (x16)                    ;
_l96:   la x4, d_1_2                              ;
        srai x4, x4, 1                            ;
        csrrc x30, pmpaddr1, x4                   ;
_l97:   remuw x3, x16, x24                        ;
_l98:   la x10, d_4_24                            ;
        lui x5, 0xffe00                           ;
        xor x10, x10, x5                          ;
        lhu x27, 16(x10)                          ;
_l99:   la x6, d_2_20                             ;
        addi x6, x6, 20                           ;
        amoxor.w x9, x18, (x6)                    ;
_l100:  fadd.s f6, f8, f15, rdn                   ;
_l101:  mul x19, x15, x24                         ;
_l102:  fcvt.s.lu f22, x21, rmm                   ;
_l103:  la x6, d_2_24                             ;
        addi x6, x6, -8                           ;
        amoor.d x30, x22, (x6)                    ;
_l104:  slliw x13, x25, 31                        ;
_l105:  fmv.w.x f0, x30                           ;
_l106:  div x11, x7, x15                          ;
_l107:  la x14, d_4_2                             ;
        lwu x21, -20(x14)                         ;
_l108:  fmin.s f16, f8, f12                       ;
_l109:  la x10, d_4_11                            ;
        addi x10, x10, -8                         ;
        amoxor.w x6, x5, (x10)                    ;
_l110:  fcvt.w.s x12, f7, rmm                     ;
_l111:  feq.s x18, f3, f26                        ;
_l112:  la x29, d_3_10                            ;
        addi x29, x29, -0                         ;
        lr.w x13, (x29)                           ;
_l113:  la x13, d_5_15                            ;
        lwu x1, 0(x13)                            ;
_l114:  la x15, d_4_12                            ;
        addi x15, x15, 16                         ;
        amomax.d x22, x19, (x15)                  ;
_l115:  la x23, d_0_23                            ;
        lui x9, 0xffe00                           ;
        xor x23, x23, x9                          ;
        sd x17, 16(x23)                           ;
_l116:;
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
                .dword 0xdf5d2beb041d0dda, 0x6ba9c7a62b866d38
                .dword 0x665d846a9f2f842b, 0xd2c426d25f011cf2
d_0_0:          .dword 0xc7477bbe56b2baab, 0xd505051d065db048
d_0_1:          .dword 0x5d06ba35d56a5017, 0x3171ee68f315b6ef
d_0_2:          .dword 0x5dd4c1e2d7735a71, 0xc94c81e11c3096d3
d_0_3:          .dword 0x1b5511423e0c87aa, 0x7bee692ed9579c11
d_0_4:          .dword 0x6818da924e0fd88e, 0x2c3301df60765310
d_0_5:          .dword 0xf5f58a795d53dee8, 0xe94e41ce46f14b44
d_0_6:          .dword 0x43beffc96e1dfffc, 0x85f8222a58afe18e
d_0_7:          .dword 0xb034c87d7304b06a, 0xdeaea4c449949b3e
d_0_8:          .dword 0xa7cfcb784c5daf65, 0x8a34f9fa2de8444e
d_0_9:          .dword 0xf657088c295e0881, 0x619bd2c52a07fc40
d_0_10:         .dword 0xfd5374ed35fe0585, 0x6d3bc726e5b6bc97
d_0_11:         .dword 0xb1ea7d6a2e54e2db, 0x8f871458135605f4
d_0_12:         .dword 0xd5962d0cca1c70fc, 0x1b8f7f674483e17a
d_0_13:         .dword 0x96c7088f2c0a65e8, 0x69646155e57d3de0
d_0_14:         .dword 0x0d73565fde268f23, 0xc34ccb17b6545864
d_0_15:         .dword 0xba0361cec8fc1908, 0x2d9573468fa1a4b0
d_0_16:         .dword 0xb8e829eea9334d3e, 0xf5a7c8a4bc5c2234
d_0_17:         .dword 0xadebf1ff26e04d45, 0x8e337da2f65336d2
d_0_18:         .dword 0x8fc13c79d17b1577, 0xd25b9acf3c21a416
d_0_19:         .dword 0x4a21291355e75cd9, 0xfc69cd39da952424
d_0_20:         .dword 0x039363c8584c5e54, 0x87cf5bb4fee91021
d_0_21:         .dword 0x859e719d2a7077ee, 0x4141ae4c1b4bc467
d_0_22:         .dword 0x44a2db32cd34839a, 0x2ab1afd2a53081f6
d_0_23:         .dword 0x7ebaa882d9732db7, 0xc6ab094ed76da0da
d_0_24:         .dword 0x43dd443fa5b69082, 0x9042687c784aad98
d_0_25:         .dword 0x3451efe7c5e5fb80, 0xeb8298c62e8ad51c
d_0_26:         .dword 0x3058f2ce2da67d8f, 0x52acde7d71047d32
d_0_27:         .dword 0x3ac657c43bfb3f95, 0x64e34f5e5f63b1b0
                .dword 0xd90b64b72bc6751f, 0x8a7b028c9a0c7c50
                .dword 0x2b4de1786e5e9f8d, 0x9a3a45179fe5fced
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xdd2a3162e8f051df, 0xdc22625724069a29
                .dword 0x6d31e6abb69d799e, 0x3d0bbd8f25af05f7
d_1_0:          .dword 0x163ea1b73c062c3e, 0xc6a7f6bf2f2adab2
d_1_1:          .dword 0x4cadce56e0de3446, 0xc7cb40f980230f10
d_1_2:          .dword 0xdad28d667d9a8ee7, 0x9f4037f4f28d66e1
d_1_3:          .dword 0xa6c2fa413940fcb8, 0x4136b5adef86b54b
d_1_4:          .dword 0xc6bab5eeddda2b31, 0x4aa84412fdb0e4db
d_1_5:          .dword 0xce5d5e902cce9f14, 0xde947730392a905e
d_1_6:          .dword 0xa9d98e9003555e2b, 0x5a7c0ea77f80dd58
d_1_7:          .dword 0x2daf922f4a362a27, 0xcff042b9fcb21b82
d_1_8:          .dword 0x2a8e8938dfbb8b48, 0x3afd0ef6e2034360
d_1_9:          .dword 0x0165ae02a73843fe, 0x0c74c20e98a1f784
d_1_10:         .dword 0x3d7e3122a25bc238, 0x958ea7e847aee795
d_1_11:         .dword 0x3f36832ac14b2edf, 0xd21ff17b6df0d770
d_1_12:         .dword 0xf5b46d126d40892e, 0xd08fd2019506d572
d_1_13:         .dword 0x43358d4e27415203, 0x1f0b791c4ec97dd2
d_1_14:         .dword 0x784ec72da9f7e134, 0x69b69521753eefc6
d_1_15:         .dword 0xdda221373678bd61, 0x70bb8587d7840a02
d_1_16:         .dword 0x2fb5613ea774fc76, 0xb3f3aef9e9783faf
d_1_17:         .dword 0x48cc29aeb0d90f6a, 0xf4643aa8d5935f2d
d_1_18:         .dword 0xc0261a0095bf6a8b, 0x19210fb923e1f3ea
d_1_19:         .dword 0xab5ebf2000853f72, 0xf3f73e46fc9e6ea4
d_1_20:         .dword 0xf15695bcfa7ad4b5, 0xeb7ca4dd1764f09e
d_1_21:         .dword 0x451f60512849dce9, 0x3d653732c3d741ff
d_1_22:         .dword 0xda5ab3d292e06560, 0x13bcecbd65c10abf
d_1_23:         .dword 0xbe9e0db6d02dd270, 0x3a5b90211a4fdc51
d_1_24:         .dword 0xe46e78762f2ebdad, 0xb0de3573450bb34c
d_1_25:         .dword 0x9b285a856f6faf80, 0xa2babcdb97351a50
d_1_26:         .dword 0xaac058bfc2631817, 0x1912ee2debc627f1
d_1_27:         .dword 0x8f5b187391781f14, 0x438ad22d377315e2
                .dword 0xeac44a6bd667974e, 0x1287eda780b38bfd
                .dword 0x43185bc63e3baac2, 0x8d41bc55f18d456d
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xba47f9bf23445f13, 0x69feee0ea235b118
                .dword 0x4482714a42a1b774, 0xce2ad2a7de48e500
d_2_0:          .dword 0x0d5562746bcad4aa, 0x5e00f62b4a11c0c7
d_2_1:          .dword 0x60a078ef12340963, 0x06e50d49725bd395
d_2_2:          .dword 0x47d8283cf648fe20, 0x02dc48862dbb3fb3
d_2_3:          .dword 0xd932c270cdb6c2aa, 0x81fcbbe091d06609
d_2_4:          .dword 0x93f841f7f6fb2b8a, 0x48880400cb3f2e0c
d_2_5:          .dword 0x54f39c1883af733f, 0x4a7845906bd2512d
d_2_6:          .dword 0x32e381134a34edaa, 0xe88b50adb492c699
d_2_7:          .dword 0xb36189ca25a6da96, 0x7bb3b773e899d4c5
d_2_8:          .dword 0xc925d7fdbd30629b, 0x9befa32854741e72
d_2_9:          .dword 0x78db80bce43b25bb, 0x8c2ff24327eb7bf3
d_2_10:         .dword 0x72090c5512fe938d, 0xbdcf4ac79dbdb9b7
d_2_11:         .dword 0x87fe94346d184263, 0x9057dddd0a30e059
d_2_12:         .dword 0xb7fe51f29a69a85e, 0x2018f9ceeec89a02
d_2_13:         .dword 0xcb6272d021c33416, 0xbc032d306f0d9b4b
d_2_14:         .dword 0x43a0b130ba0efb60, 0xe0725ddf5624e756
d_2_15:         .dword 0x1fd4632e243f16c3, 0x792a7f1f082b26b1
d_2_16:         .dword 0x91668e20a3d3f05f, 0x05fccd4379e07153
d_2_17:         .dword 0xe7f58eda1f664d39, 0xaf2332ba0eb81faa
d_2_18:         .dword 0xbfbc065370cfba2f, 0x8a4562049c34c584
d_2_19:         .dword 0x50afb5c52327e299, 0xae2ab75eb0a92a5b
d_2_20:         .dword 0x5497f25f66076b85, 0xc835647006d54f07
d_2_21:         .dword 0x8fbade9050b37ebf, 0x8783f218778af01b
d_2_22:         .dword 0x04942e2342877bc3, 0x4b918ae21580ad4e
d_2_23:         .dword 0x4e0b543eed79ee5f, 0x3c45e55943b6f70d
d_2_24:         .dword 0x64fe93c595a094c1, 0xe3ece34362b84c50
d_2_25:         .dword 0xe53aa2dde5e7303d, 0xbcb8e47f304565a2
d_2_26:         .dword 0x6b42c4c6a3fb4af8, 0x0f93f248812d365d
d_2_27:         .dword 0xe3243f03e649d5a0, 0xe0e849b217798ca4
                .dword 0x063efa366b7b08c6, 0xcd4fa184226d67e5
                .dword 0xe5f88de1554f7f5d, 0x6e01e252eec5ab79
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x87ba25cb07ff33d8, 0x0a4a7b519b4b2f93
                .dword 0xe51f4351e0d507b9, 0xb56aba66c3c662d1
d_3_0:          .dword 0x96d7f96e3bdd218f, 0x6d655c70c84361fd
d_3_1:          .dword 0xf3b6f716108d51b6, 0x669b6d3bde6b507b
d_3_2:          .dword 0xdb2e49ad293a8fcf, 0x005a3fe6d7413a58
d_3_3:          .dword 0x852f88aa909d1872, 0xa7d8049091027557
d_3_4:          .dword 0x4e0ad33fd4ab613b, 0xd1d38b1623b5ef45
d_3_5:          .dword 0x860f6b9ce436513d, 0xb30dfd512d66100b
d_3_6:          .dword 0x9a37a8748a0d9e1a, 0xe0413a974176ae71
d_3_7:          .dword 0x231a497863c5a57b, 0xb93bf6b830b4e5c5
d_3_8:          .dword 0xfab8e2ece9e7d61c, 0xfe36693be4bc5f37
d_3_9:          .dword 0x0cd795197304c4af, 0x426a89ac70ab7035
d_3_10:         .dword 0x81653ff7535cdc2c, 0x7cab76f9500299c0
d_3_11:         .dword 0xdf1df3ade26e9ea7, 0xe30a26723972adce
d_3_12:         .dword 0x1c997bcf6b64c17c, 0x43cf6ec249f8b961
d_3_13:         .dword 0x660d84ddbec478dd, 0xddd809bc59b6d1d1
d_3_14:         .dword 0x0e1d5dac867487f2, 0x1bbb4588ec4dc344
d_3_15:         .dword 0x4ff839ae6069688e, 0xe1fc5243206fd890
d_3_16:         .dword 0x9130286177933862, 0x47ef8315392c8225
d_3_17:         .dword 0x6a8f299715e267d3, 0x109792e6190a5cba
d_3_18:         .dword 0xf1b3e2376fcd03f5, 0xea954c3cf801c557
d_3_19:         .dword 0xe4ca317eabd910e3, 0xfee0c7099badf749
d_3_20:         .dword 0xf6535e0fcc957908, 0xfce5117ff7c6f776
d_3_21:         .dword 0xb9e104e625f3a2b9, 0xdf6fffa2f7b66c2c
d_3_22:         .dword 0x9042f8e8cedc7c91, 0xcfb4406422aacf68
d_3_23:         .dword 0x3a0b93d15b63cb5a, 0x5ab7e0f2c0974729
d_3_24:         .dword 0x051e309effc1ffba, 0xea427056586bb569
d_3_25:         .dword 0x799827819cd05a80, 0x11da34b4ca2b93f9
d_3_26:         .dword 0x12b89bbaa036df00, 0x8a04a443099f8878
d_3_27:         .dword 0x8a1ebc2f62beeac5, 0xfe5f076a1c17b370
                .dword 0x624846ce1aeebc98, 0x35e54a68407bcc0b
                .dword 0xc97c514e32d60730, 0x303d8bb4260ca820
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xf2ad4a1b6ea9a69c, 0xbb7f5b27e6ae0006
                .dword 0x937d9cadfb86bb0e, 0x1fd5022c8c4d6b8d
d_4_0:          .dword 0x2e8232d636425cea, 0x8bd935667476bb4d
d_4_1:          .dword 0xf5eda77abc36539d, 0x369d0881f3fb599d
d_4_2:          .dword 0x1fcdc88c8f251761, 0x414ebac35131971f
d_4_3:          .dword 0xd3b0e2889d71ac20, 0x91f2752dfae5dc79
d_4_4:          .dword 0x567a9dca7460a106, 0xbb6d33d82e08a4ef
d_4_5:          .dword 0x8d704c7de9d3a132, 0x39ae2e9393a9b391
d_4_6:          .dword 0x1fa92168461a6c39, 0xf93762594d09110d
d_4_7:          .dword 0xb03caf1ca2964e59, 0xa7c0c9dbb4047061
d_4_8:          .dword 0x7b0e19f8b1bc1a32, 0x25fd01665fbb1f64
d_4_9:          .dword 0xaf6230bb7639e247, 0x9f5e695232610a15
d_4_10:         .dword 0x9dd6ada5fde6aa41, 0x2782af6ce6103fe4
d_4_11:         .dword 0x02b373aee6bfd5e7, 0x1ddbcecdf47a885b
d_4_12:         .dword 0xc4b5df0f1caa086e, 0x774fef7e0211df66
d_4_13:         .dword 0x306c853e503c90a9, 0x5359c7d369c9d220
d_4_14:         .dword 0xbbdc641b6eca1243, 0x903f26ddb79c57b4
d_4_15:         .dword 0x07e5349e40183179, 0xd71ae94db995ef54
d_4_16:         .dword 0x1c45f29c1657c1ab, 0xdf24781850663b61
d_4_17:         .dword 0xa12d56bafbc52945, 0x869da82b987763d6
d_4_18:         .dword 0x7a81632d5b10e384, 0xe14af77a610e93a1
d_4_19:         .dword 0x6cce43a093ef443c, 0x49202f2e730337cf
d_4_20:         .dword 0x3b67ef9dc8ca9017, 0x30223215777dcbb0
d_4_21:         .dword 0xf719da918bdaec47, 0x9adb7835f8b9fceb
d_4_22:         .dword 0x8ac9bdc7e68bd851, 0xa8c51860648aee77
d_4_23:         .dword 0xfbbf7a0c9d40f9b3, 0x32b3536163311e3c
d_4_24:         .dword 0xbfca1e3f7199dad7, 0x9762977c08db1a6e
d_4_25:         .dword 0x79fd59598fed21ac, 0x1fcb029de571cd95
d_4_26:         .dword 0xaab403ce8f5f0844, 0x21279391208e40e4
d_4_27:         .dword 0xc7d477169194cf2a, 0x8a14b054002c4b11
                .dword 0x4f1ab23a993efea8, 0xace9f7729a4fee9e
                .dword 0xb15307a0c31afb54, 0xf4496131c92caec9
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x77b5e3c7fca2da24, 0xe0eeda84f417c663
                .dword 0x34afeb2b3770edbf, 0xc607dea076749f8d
d_5_0:          .dword 0x6400d4250a1b4675, 0xe1b84e898e3fc214
d_5_1:          .dword 0xea51653d060b037c, 0xda5672ec8feac090
d_5_2:          .dword 0x934f586a272ad926, 0x19df68b52838f055
d_5_3:          .dword 0x0044ac3762384e8d, 0x398c66e42e8c97f9
d_5_4:          .dword 0xa480357c2d074362, 0xecc02aa8d0b2c43d
d_5_5:          .dword 0x6e7b108fce0a3b0c, 0x4a5616fd6c91bc71
d_5_6:          .dword 0xbc343915b3c84627, 0x134008bfee37e62b
d_5_7:          .dword 0x9fd992726a6c7e59, 0x17907e03db5159a2
d_5_8:          .dword 0x359f8cf303f807c3, 0xc86cd75a2751222a
d_5_9:          .dword 0x95d4710dfebe9202, 0xa696cdd0a80a95d3
d_5_10:         .dword 0x7213f40238bd833e, 0x4dca8e02d7ab5beb
d_5_11:         .dword 0xf06c268660f6694a, 0x574a0b5fc7448a6a
d_5_12:         .dword 0x525d0f2cb562dfcb, 0x7a57834d4a4efca8
d_5_13:         .dword 0xb900bb119993115a, 0xc82b35ff23cdafa4
d_5_14:         .dword 0x78ef07678d1f3faa, 0xfcccead0752fe1c1
d_5_15:         .dword 0x5b692b3010c45b18, 0xb8e04b6b4041641b
d_5_16:         .dword 0x02de9cba79d09280, 0x2e45351d29bbf1a7
d_5_17:         .dword 0xb5678812d9d97a44, 0x88f62ce37d4e1c46
d_5_18:         .dword 0x21881c5b8026c441, 0x1ff6c84a4623559f
d_5_19:         .dword 0x3aa6fc3314536baf, 0x516cc19c7d34ca42
d_5_20:         .dword 0xe6eb6b16ddf63d90, 0x2f1a828790f7750a
d_5_21:         .dword 0x0b09ea9597e43448, 0x6351d130c07dca30
d_5_22:         .dword 0xb6813e37924a97ea, 0x13d0a100b4c4850f
d_5_23:         .dword 0xe5b9454f25785fd2, 0x96c86882d99c5af8
d_5_24:         .dword 0x97545e58ba961955, 0x952796621537dc50
d_5_25:         .dword 0xff0a4eda30d32861, 0xf6d9512e12cfde38
d_5_26:         .dword 0xaac81dad291ff3cd, 0x3ac1af303ccbc142
d_5_27:         .dword 0xd88b8ad02588d132, 0x8e7b4d444ea5d2bb
                .dword 0x7513698313b81ffa, 0xc005c332a6c6c017
                .dword 0x985cfbcfbbb758b7, 0x72a77dd94aa6559b
         /* Random data */
_end_data5:
              
 
