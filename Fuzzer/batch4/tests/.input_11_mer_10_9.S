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
_p0:    csrrsi x14, mtval, 31                     ;
_p1:    csrrsi x13, mstatus, 31                   ;
_p2:    csrrsi x10, pmpaddr7, 31                  ;
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
_s0:    la x10, d_4_17                            ;
        addi x10, x10, 24                         ;
        amomin.w x20, x20, (x10)                  ;
_s1:    mulhsu x9, x21, x12                       ;
_s2:    mulw x13, x11, x8                         ;
_s3:    la x18, d_0_0                             ;
        lw x15, 12(x18)                           ;
_s4:    flt.s x9, f27, f10                        ;
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
_l0:    fence.i                                   ;
_l1:    la x11, d_4_18                            ;
        addi x11, x11, -24                        ;
        amoswap.d x13, x13, (x11)                 ;
_l2:    fsgnj.s f19, f11, f5                      ;
_l3:    sllw x29, x9, x1                          ;
_l4:    slliw x28, x1, 14                         ;
_l5:    fmv.x.w x14, f22                          ;
_l6:    fclass.s x18, f22                         ;
_l7:    bne x9, x13, _l88                         ;
_l8:    addi x23, x17, 1963                       ;
_l9:    fmadd.s f11, f31, f15, f12, rtz           ;
_l10:   fcvt.s.lu f0, x10, rmm                    ;
_l11:   remuw x16, x28, x20                       ;
_l12:   la x5, d_1_2                              ;
        lbu x25, 2(x5)                            ;
_l13:   la x15, d_1_7                             ;
        sw x4, 20(x15)                            ;
_l14:   fsgnj.s f5, f26, f26                      ;
_l15:   la x16, d_1_1                             ;
        lw x8, -0(x16)                            ;
_l16:   mulh x13, x21, x25                        ;
_l17:   la x15, d_4_11                            ;
        addi x15, x15, -0                         ;
        amomax.d x23, x5, (x15)                   ;
_l18:   divuw x14, x2, x28                        ;
_l19:   fcvt.s.lu f30, x24, rdn                   ;
_l20:   la x2, d_4_19                             ;
        lh x8, 30(x2)                             ;
_l21:   fsqrt.s f8, f7, rup                       ;
_l22:   la x26, d_2_26                            ;
        addi x26, x26, 0                          ;
        lui x2, 0xffe00                           ;
        xor x26, x26, x2                          ;
        amominu.w x14, x2, (x26)                  ;
_l23:   la x22, d_3_5                             ;
        lb x17, -29(x22)                          ;
_l24:   la x13, _l30                              ;
        jalr x13, 0(x13)                          ;
_l25:   addw x12, x17, x11                        ;
_l26:   fsgnjx.s f0, f7, f19                      ;
_l27:   ebreak                                    ;
_l28:   divuw x18, x13, x15                       ;
_l29:   ebreak                                    ;
_l30:   la x4, d_4_11                             ;
        addi x4, x4, -16                          ;
        amoswap.d x5, x10, (x4)                   ;
_l31:   lui x12, 390588                           ;
_l32:   la x7, d_3_14                             ;
        addi x7, x7, -28                          ;
        amomin.w x13, x30, (x7)                   ;
_l33:   fclass.s x18, f4                          ;
_l34:   srlw x2, x11, x13                         ;
_l35:   la x25, d_4_24                            ;
        addi x25, x25, 16                         ;
        lui x27, 0xffe00                          ;
        xor x25, x25, x27                         ;
        amomaxu.w x3, x27, (x25)                  ;
_l36:   lui x1, 1                                 ;
_l37:   slti x5, x25, 604                         ;
_l38:   fadd.s f15, f4, f3, dyn                   ;
_l39:   rem x21, x16, x1                          ;
_l40:   la x14, d_4_18                            ;
        addi x14, x14, 28                         ;
        lr.w x18, (x14)                           ;
_l41:   fsgnjx.s f4, f13, f18                     ;
_l42:   bne x4, x29, _l53                         ;
_l43:   li x18, 0                                 ;
        la x21, pt0                               ;
        addi x21, x21, 40                         ;
        sfence.vma x18, x21                       ;
_l44:   ebreak                                    ;
_l45:   la x5, d_5_6                              ;
        addi x5, x5, -20                          ;
        lui x6, 0xffe00                           ;
        xor x5, x5, x6                            ;
        amoadd.w x16, x6, (x5)                    ;
_l46:   fcvt.l.s x3, f17, rne                     ;
_l47:   la x19, d_1_0                             ;
        lw x11, -28(x19)                          ;
_l48:   fnmsub.s f2, f11, f2, f28, rdn            ;
_l49:   la x9, d_4_18                             ;
        sb x11, 22(x9)                            ;
_l50:   la x3, d_2_20                             ;
        sb x7, 26(x3)                             ;
_l51:   fsub.s f5, f18, f23, rdn                  ;
_l52:   sltiu x9, x17, -1082                      ;
_l53:   lui x7, 236779                            ;
_l54:   csrrsi x26, mscratch, 31                  ;
_l55:   la x14, d_4_12                            ;
        addi x14, x14, -28                        ;
        amomin.w x27, x11, (x14)                  ;
_l56:   div x16, x3, x17                          ;
_l57:   divu x25, x12, x25                        ;
_l58:   li x8, 0                                  ;
        la x7, pt3                                ;
        addi x7, x7, 16                           ;
        sfence.vma x8, x7                         ;
_l59:   srli x29, x20, 0                          ;
_l60:   slti x20, x3, 37                          ;
_l61:   la x6, d_4_26                             ;
        addi x6, x6, 0                            ;
        amoswap.d x24, x5, (x6)                   ;
_l62:   flt.s x5, f2, f18                         ;
_l63:   csrrci x4, mstatus, 0                     ;
_l64:   la x15, d_5_0                             ;
        sd x15, -0(x15)                           ;
_l65:   fmin.s f5, f26, f30                       ;
_l66:   fsgnjn.s f9, f10, f20                     ;
_l67:   beq x30, x4, _l91                                 ;
_l68:   ebreak                                    ;
_l69:   la x5, d_4_27                             ;
        ld x22, -0(x5)                            ;
_l70:   csrrsi x1, fcsr, 0                        ;
_l71:   fnmadd.s f3, f15, f23, f13, rne           ;
_l72:   la x29, d_5_2                             ;
        addi x29, x29, -16                        ;
        amoxor.w x27, x9, (x29)                   ;
_l73:   blt x21, x19, _l85                                ;
_l74:   fcvt.l.s x1, f19, rup                     ;
_l75:   la x23, d_2_21                            ;
        addi x23, x23, 24                         ;
        sc.d x30, x23, (x23)                      ;
_l76:   fclass.s x6, f29                          ;
_l77:   beq x4, x10, _l107                                ;
_l78:   la x13, d_4_9                             ;
        addi x13, x13, -8                         ;
        amoand.d x28, x7, (x13)                   ;
_l79:   ebreak                                    ;
_l80:   la x10, d_4_18                            ;
        addi x10, x10, 0                          ;
        amoxor.d x9, x13, (x10)                   ;
_l81:   la x23, d_3_27                            ;
        lw x11, -28(x23)                          ;
_l82:   flt.s x1, f0, f27                         ;
_l83:   sllw x7, x20, x1                          ;
_l84:   xor x24, x24, x24                         ;
        addi x26, zero, 1                         ;
        slli x26, x26, 28                         ;
        add x24, x24, x26                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 0                            ;
        add x24, x24, x2                          ;
        csrrs x18, mscratch, x24                  ;
_l85:   mulh x30, x30, x20                        ;
_l86:   fsqrt.s f17, f8, rdn                      ;
_l87:   bne x18, x18, _l101                               ;
_l88:   la x25, d_5_22                            ;
        fsw f14, 12(x25)                          ;
_l89:   la x7, d_5_17                             ;
        addi x7, x7, 0                            ;
        amoadd.w x2, x1, (x7)                     ;
_l90:   addiw x30, x15, -973                      ;
_l91:   beq x14, x20, _l93                                ;
_l92:   andi x23, x30, 1325                       ;
_l93:   la x7, d_4_20                             ;
        addi x7, x7, -0                           ;
        amoor.d x10, x17, (x7)                    ;
_l94:   fence.i                                   ;
_l95:   mul x20, x20, x1                          ;
_l96:   la x1, d_3_6                              ;
        addi x1, x1, -24                          ;
        amomaxu.d x29, x7, (x1)                   ;
_l97:   bltu x22, x10, _l103                      ;
_l98:   fsub.s f26, f13, f7, rtz                  ;
_l99:   la x2, d_5_12                             ;
        addi x2, x2, -8                           ;
        lui x26, 0xffe00                          ;
        xor x2, x2, x26                           ;
        amoswap.w x29, x26, (x2)                  ;
_l100:  feq.s x12, f24, f1                        ;
_l101:  bgeu x26, x19, _l107                              ;
_l102:  la x1, _l109                              ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l103:  xor x21, x21, x21                         ;
        addi x23, zero, 1                         ;
        slli x23, x23, 6                          ;
        add x21, x21, x23                         ;
        csrrs x11, scause, x21                    ;
_l104:  blt x7, x11, _l105                                ;
_l105:  divw x22, x11, x29                        ;
_l106:  la x22, d_1_18                            ;
        addi x22, x22, -24                        ;
        amoxor.w x30, x14, (x22)                  ;
_l107:  addw x18, x5, x9                          ;
_l108:  slti x10, x9, -484                        ;
_l109:  fcvt.l.s x1, f23, rmm                     ;
_l110:;
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
                .dword 0x858eb4481de1d3ec, 0x49e82f2c9bd96371
                .dword 0xcd490bcd0165c55d, 0xef2a6262ac689e3b
d_0_0:          .dword 0x1ee517484de7c3fe, 0x192f8902a22b2de0
d_0_1:          .dword 0x8484b56c7cee320f, 0x3f5e68f087db7e75
d_0_2:          .dword 0xcd0bdafcb27d577d, 0x20707423a7c8a7ca
d_0_3:          .dword 0x3730617726544fdf, 0x9eb3bb673138e309
d_0_4:          .dword 0x448c5b80656363a5, 0x12b17f3fd9740cd9
d_0_5:          .dword 0xa1d5bb9000775e76, 0xb4086116d3a4fa96
d_0_6:          .dword 0x00004ba806ba5d56, 0xfa55b4381df2d07f
d_0_7:          .dword 0xbd3551c7268ff063, 0x8bd587a728b580cb
d_0_8:          .dword 0x8a6ea198ac2be0f8, 0x4c5b1bcaff083adb
d_0_9:          .dword 0x60088dbd90c0ac2e, 0xd6d0fd83c467c1de
d_0_10:         .dword 0x924319ad868294ed, 0xc70e889aa2c86a75
d_0_11:         .dword 0x26960d3cd0a76131, 0x4a5b17537a5123e5
d_0_12:         .dword 0x77a71bf8ab2cab9e, 0x3ec0c17482265f94
d_0_13:         .dword 0xc2dd755df4158bbe, 0x1f3ea7213ea11fa5
d_0_14:         .dword 0xf31f7390e5ed0edb, 0x04d7cf42c3998201
d_0_15:         .dword 0x66e1c365337d4d15, 0x2f562c2f559fd919
d_0_16:         .dword 0x6e75750984793ce6, 0xf391b389889f8aad
d_0_17:         .dword 0xd0694e6bd7476a1a, 0xc43e6de5a1ac193b
d_0_18:         .dword 0x34d41cd503902be8, 0xa77dc22d853205b6
d_0_19:         .dword 0xf01c1929c5b791d1, 0xdc0784a34b835771
d_0_20:         .dword 0xe2df1ca7fdc695a2, 0x875ccd6740d6f811
d_0_21:         .dword 0x69b171e82cb02431, 0x34e9d3ff57eefc79
d_0_22:         .dword 0x148b762249ec6d7d, 0xb127a32c8faebdb8
d_0_23:         .dword 0xe0814171716e09d2, 0x72ae32a3152a1df9
d_0_24:         .dword 0x7a25212f38537522, 0xeb78c20ea48cf624
d_0_25:         .dword 0x2ab6916e03263085, 0x0f422f7ba602850c
d_0_26:         .dword 0xf694d5d459eb4822, 0x86b484936642c552
d_0_27:         .dword 0x16836a7db1d9c394, 0x337313929b532854
                .dword 0x08a20a52fdee11c6, 0x7e1872a99e0a2dd1
                .dword 0x5e7f9f983cd4b338, 0x511fc10f795fed64
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xc5d15fff0d025e83, 0xafc5d9883a44d11f
                .dword 0x68c9ec999b67f825, 0x0c186b7e9a93330f
d_1_0:          .dword 0xa20c7806164773b4, 0xa9211fae1b837c4d
d_1_1:          .dword 0xaf90662c86703bf2, 0x03b2ca8d854a4559
d_1_2:          .dword 0xa313b5bceaed6e3e, 0x6f6d16e55ff4d70a
d_1_3:          .dword 0x930dbb28b66d9b31, 0x97ea2716887c0473
d_1_4:          .dword 0x67a241f3054badfb, 0x8c694a04b24072a6
d_1_5:          .dword 0x6be289b0f61e4584, 0xa91d7d73a8a61d68
d_1_6:          .dword 0xe3d705088cfa21fa, 0x6556ddb720c3f46a
d_1_7:          .dword 0xdcaeee977755b661, 0x9b4b215bc1d1e117
d_1_8:          .dword 0xfe88d9167c1b911a, 0x4bce8caf82d426b6
d_1_9:          .dword 0x368de5206d55057b, 0x711a1720d3049c80
d_1_10:         .dword 0x05d43291a3b42a59, 0xe1e0292307a596a2
d_1_11:         .dword 0x934742f270e73518, 0xa637a0a253f66ef9
d_1_12:         .dword 0x0b1c197156ec147e, 0xdc006d2d49c3c27a
d_1_13:         .dword 0xd90ae8e93ac31a61, 0x6af745bb46aae6e7
d_1_14:         .dword 0xc466c30015c848fe, 0xf1d5d78c5dd56d92
d_1_15:         .dword 0xab1144eeac8efc78, 0x2f9be9ebfc5010c6
d_1_16:         .dword 0xb67e8d8ba49fb515, 0x8f95a9ffb3a541c3
d_1_17:         .dword 0x27cd5d2a2d03bd6d, 0x204306d53abd0bab
d_1_18:         .dword 0xcebefed2e40b0618, 0xecb39920a35152af
d_1_19:         .dword 0x346f1afd9a327d0f, 0x4e1ff569a0ea8da7
d_1_20:         .dword 0x72d29a6b592ca5e3, 0xf1a68b52aff7b282
d_1_21:         .dword 0x8f4efee3e793790c, 0xd264418378d95691
d_1_22:         .dword 0xc2f8dccdd58549da, 0x7a5c58b1827c5ba0
d_1_23:         .dword 0xabb5b730bc44de99, 0x1bc86eba55360be7
d_1_24:         .dword 0x8d9830b89bd204c1, 0xea1dc8273d8f8ff8
d_1_25:         .dword 0xd524a64637432837, 0xcd7c2e8e9b86a97c
d_1_26:         .dword 0x75eaac338d99be0e, 0xa241fce72702903b
d_1_27:         .dword 0x6524563bfc2e37b4, 0xc95ed33f7107c36c
                .dword 0xeabc384270fcb2ed, 0x59e5ee3e2199a6ce
                .dword 0xb8e73c8f84b7bf4d, 0x5f09274a29a85906
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x4e6f9ad2171c23ea, 0xec56637d4c74b61e
                .dword 0xc73c2a1de2140083, 0xc5fee02ec87388bc
d_2_0:          .dword 0x360209fc518bf25a, 0x2274d0c3cea9cb77
d_2_1:          .dword 0x27dca2c193bfc781, 0xfa96ffdc8a803324
d_2_2:          .dword 0x28db324e31e20822, 0x1515ce332a4c9e74
d_2_3:          .dword 0x99055fd524257d35, 0x167a84b24cad6556
d_2_4:          .dword 0x001bc3adefc9e524, 0x6104927e156dea87
d_2_5:          .dword 0xb9d5fcbbbb9ea8cd, 0x2eb0937ad80c37e9
d_2_6:          .dword 0x299913bccfac911d, 0x2aad96581f062014
d_2_7:          .dword 0x5a2d1dbb0fd8eda2, 0xcaf28c1f1b78469e
d_2_8:          .dword 0xc412953f7cecd30b, 0x914a665b6a080cbe
d_2_9:          .dword 0xc051c81e0cc797de, 0x394dedf2427c31ce
d_2_10:         .dword 0x023f62e077e09dd3, 0x3cc35eab907f2f9a
d_2_11:         .dword 0x3cfc5ab6ce063cda, 0xb9ee27cda6775335
d_2_12:         .dword 0xeccef8db5a036c27, 0x20fff396be09b05c
d_2_13:         .dword 0xf523858daa18bd45, 0x67b0ee2b6b48033a
d_2_14:         .dword 0xf3e1f4ea254dec74, 0x78c4f3645af5d179
d_2_15:         .dword 0xc0ed162df8d9bbcc, 0x9d944c3937300b89
d_2_16:         .dword 0xd8ead53792136565, 0xa5e33629b8397782
d_2_17:         .dword 0x2795da44a2dc05c0, 0x3735d8aa6796ebed
d_2_18:         .dword 0x7b4b917c8613e1e7, 0x471e1953f5a31499
d_2_19:         .dword 0x85f1a568a929a430, 0xaffcf7d3d6bd1b1f
d_2_20:         .dword 0xc87b61808aa3e2ff, 0x956fd105aa0c9d1e
d_2_21:         .dword 0xe1b1786ba16b1bc1, 0x3588e2eed761db84
d_2_22:         .dword 0x0c2d6ea76559c686, 0xa588df2ce49bcd47
d_2_23:         .dword 0xf148ba27b9cddf80, 0x0701314b26bfa82c
d_2_24:         .dword 0xeec45a5bbfe5359c, 0xd131b6cbbf9819e5
d_2_25:         .dword 0x16c18933893272da, 0x6bc670b78dc3ec15
d_2_26:         .dword 0x72c2cb231ae6da62, 0xa98fad77c84f8a4e
d_2_27:         .dword 0x93889e98656bd70c, 0x2f276b4de5c262d6
                .dword 0x1159eac62eb77e66, 0x2ee42c2a4bfd656f
                .dword 0xf2d7940e58e24611, 0x91966a25c84f85b4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xeb97a2b54d8b4739, 0xcd3a3fe7b7dcc4e0
                .dword 0xf90d00967405db4f, 0xa76d27f51426bc59
d_3_0:          .dword 0x7e822f82b8e9227a, 0x2d2c59931a75e476
d_3_1:          .dword 0x3183f54d3e8e9881, 0xacf8c90dcf8b81ec
d_3_2:          .dword 0x8d872495368c58c3, 0x1629b3d08704d96d
d_3_3:          .dword 0x4e309abc3ef98a2f, 0xe55d7346a77560c0
d_3_4:          .dword 0x65b59aaef3d2ae3f, 0xd440776cc3dd48c7
d_3_5:          .dword 0x7648beaa4c74b0f7, 0xd637923309ca1d26
d_3_6:          .dword 0x417c809199360ab7, 0x36626eb096514f83
d_3_7:          .dword 0x756a8af676f9047e, 0xf5bf457ca753d50b
d_3_8:          .dword 0xe356c0bc50b323f9, 0xa87374a92a1faa62
d_3_9:          .dword 0xe18872fea394d9b4, 0xc90d08829a4f66fe
d_3_10:         .dword 0xba442fedad0e4e21, 0x7bd69a5161eeb893
d_3_11:         .dword 0x013513a5739cd11e, 0x74f32de78f7bb16f
d_3_12:         .dword 0xf0a22abff0658f3e, 0x155ffc73da8faeb8
d_3_13:         .dword 0x53efc4f8f2344699, 0xe8e5d31356cb0265
d_3_14:         .dword 0xf340fb151a12787f, 0x627590cacf98a0db
d_3_15:         .dword 0xed2e102fbaf17ac9, 0x48a1b1c8776d5773
d_3_16:         .dword 0x49e5f697527e38cf, 0xd53228cc0b0d2709
d_3_17:         .dword 0x5ee58d8bd42f0bfa, 0xc14170960d160579
d_3_18:         .dword 0x3ca9f31378a6775d, 0x7b151396f5f13ce1
d_3_19:         .dword 0x8dfe47e5d5077f18, 0xa4f46324b429c657
d_3_20:         .dword 0xab66d172b2162f88, 0x6265c108a755753c
d_3_21:         .dword 0x6b861015b54dc342, 0x8b4d239d6ca4d3ad
d_3_22:         .dword 0xff30c5e9618df9e4, 0x05b624bdc1a45a90
d_3_23:         .dword 0xe13ee5009c218ef5, 0xace57a60d56a7b2a
d_3_24:         .dword 0x81093df0f033ebfb, 0xdd27e3e6d3d0c4ad
d_3_25:         .dword 0x0d80c0f5b4d2760b, 0x82ae6d5273318031
d_3_26:         .dword 0x22fba1015fb73f26, 0x5307689e728d2ca2
d_3_27:         .dword 0xd2378fb470333d20, 0x47555f3411303d39
                .dword 0xc58a1e7df0633447, 0x6b476997b550b775
                .dword 0x863c4ccf7806088c, 0x3a53205b4f3a79cd
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x885561fad9b9e32c, 0xd2ef86fa5c854fc7
                .dword 0x18eed5b98b649ff5, 0x5f2b784aef048711
d_4_0:          .dword 0xd437ad1340c9d819, 0x2a3d7264c950a65e
d_4_1:          .dword 0xfb21a1ec8d727ba0, 0x64287173ab557149
d_4_2:          .dword 0x00e6fcde41955ee9, 0x2f985f24b2903ad1
d_4_3:          .dword 0xd0398f059156b28e, 0x17d3f1c818ddd764
d_4_4:          .dword 0xf02e7c6fc9b6dd7a, 0xe4000b0a042e9db1
d_4_5:          .dword 0x31a5aea521b1c13b, 0x6927bac8ac81b671
d_4_6:          .dword 0x178fb67565b6de84, 0xb22359e5abfc1d6c
d_4_7:          .dword 0xaf5ec3657c282945, 0x86f0621e9e107804
d_4_8:          .dword 0x92cbc22caa42e44a, 0x40c9365ad8a82f59
d_4_9:          .dword 0x92e0deb0837bf0fe, 0x876d49cece084480
d_4_10:         .dword 0x5d80b271bf5b4f89, 0x03e621b7b1442f1b
d_4_11:         .dword 0x99d16064e56b2d1a, 0xdd394c434e460954
d_4_12:         .dword 0x64c84bb5fa98ca90, 0x15fc7aeaff45eb44
d_4_13:         .dword 0xa9fbf96bc7156d37, 0x894f2f55ffdff41c
d_4_14:         .dword 0x22daadb6a346bed3, 0x8b6785615ce126cf
d_4_15:         .dword 0x93ab09f0a3686d34, 0x574e567750662418
d_4_16:         .dword 0x94a32d4d3e68b0d3, 0x61d6f8ae4b94befd
d_4_17:         .dword 0x3d1d57b6e3b6b062, 0x89d0297ca096a37e
d_4_18:         .dword 0x5d1d74111b4437c6, 0xd4f9d33d10fcad9b
d_4_19:         .dword 0xa458d3927c382aae, 0x512b498bda94b7d1
d_4_20:         .dword 0x0e275841efba6c0b, 0x9e03a760d83863aa
d_4_21:         .dword 0xdbb3e17672bc0c02, 0x1ab36bffbd9ad9ab
d_4_22:         .dword 0xe5315072bad6f635, 0x4146dcbf46560def
d_4_23:         .dword 0x02df3484781dc7b7, 0x372ada10f4b59626
d_4_24:         .dword 0x392582940b4772aa, 0x156ce73f67cc2850
d_4_25:         .dword 0x6b801f33057ee0e7, 0xafc987402228ee5a
d_4_26:         .dword 0xdd9a19a5caf24cbd, 0xeca6d7fee799a191
d_4_27:         .dword 0xfb354efb4f87e13c, 0x43c1d97dac92ba7e
                .dword 0xe1656143e26dc361, 0x5e99dcdcd09f050f
                .dword 0x8bc5d8a7fd461a9c, 0x64ae222f316544c2
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xe9367a72c3573fd9, 0x35a33ea9fbc326e3
                .dword 0x292767417c03e8ea, 0x05060508bf80d63c
d_5_0:          .dword 0x63dad7c7f1124a61, 0x30e57f1031eb2705
d_5_1:          .dword 0xef76c48c3b56c0cd, 0x493316fa0200bdbe
d_5_2:          .dword 0xa05f23a3eb3c0c03, 0x591af8a83ff9c43e
d_5_3:          .dword 0x547eea7c8f962610, 0x0ee0659f913cb5b7
d_5_4:          .dword 0xe9a3965d9efb7139, 0xdf8a5d78aaec0884
d_5_5:          .dword 0xce5bd24ae071a1d4, 0xbe22900743c5f3ef
d_5_6:          .dword 0x184fcb65f07555bf, 0xd48ff354b560d5d4
d_5_7:          .dword 0x01901d728c358f29, 0x779dafdf7b6eedcb
d_5_8:          .dword 0x8ea7996da708f304, 0x2bfd9424e841a05d
d_5_9:          .dword 0x61e88b295bce910b, 0x2d2fa8302bf3de8b
d_5_10:         .dword 0x7986739c8f8c2e8f, 0x452ca051fef46a4c
d_5_11:         .dword 0x6241a7bcef966023, 0xfb6e45036e822b0f
d_5_12:         .dword 0x604da861c098bd9d, 0x879e83c5b0993415
d_5_13:         .dword 0xc56a7e8a74a6def6, 0x5150530ff8afe196
d_5_14:         .dword 0x58c26d9d7aa86838, 0x365c10eb620fe310
d_5_15:         .dword 0xbd8e9c70944c6c7b, 0x75a3e05dd3b7401f
d_5_16:         .dword 0x02649f19e176dc9e, 0x163f8640c95a483e
d_5_17:         .dword 0x83471b1c4c97d98a, 0xe0fee7a7827378f3
d_5_18:         .dword 0x175a6a3a4ad44c42, 0xa02828431c5aca12
d_5_19:         .dword 0x1947f326346cfa04, 0x718558c0489871bb
d_5_20:         .dword 0x24502c64c7ffa706, 0x017c67988ce1ecd0
d_5_21:         .dword 0xf89c4b2a9eb5011b, 0x27d64bedde2e4eed
d_5_22:         .dword 0x0a3109143853ce7a, 0x9c8ad704128c4410
d_5_23:         .dword 0x4831ace31b760a22, 0x8032cea690b7772b
d_5_24:         .dword 0x7ff0a83b357c587c, 0x4a920c571b280b1b
d_5_25:         .dword 0x0b26633eae65f5e6, 0x60a9e6ccd96be11d
d_5_26:         .dword 0x3160d62b1767db6c, 0xbe2f59cc65be9f63
d_5_27:         .dword 0x3416c1fcecf76aca, 0x06c6f6e727f8c68a
                .dword 0x61876f3bc791e8c1, 0x735b7bd11ce18197
                .dword 0x8b3069e3eb1761c5, 0xbf55ac59521d283f
         /* Random data */
_end_data5:
              
 
