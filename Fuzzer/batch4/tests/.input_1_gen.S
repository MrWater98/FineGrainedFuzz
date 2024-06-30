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
_p0:    csrrwi x11, pmpaddr6, 23                  ;
_p1:    la x13, _p3                               ;
        srai x13, x13, 1                          ;
        csrrc x10, pmpaddr6, x13                  ;
_p2:    csrrwi x12, sscratch, 0                   ;
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
_s0:    subw x15, x15, x14                        ;
_s1:    fmsub.s f24, f18, f12, f20, rmm           ;
_s2:    li x26, 0                                 ;
        la x20, pt0                               ;
        addi x20, x20, 56                         ;
        sfence.vma x26, x20                       ;
_s3:    srlw x26, x6, x3                          ;
_s4:    la x25, d_0_24                            ;
        addi x25, x25, 0                          ;
        amoand.d x21, x27, (x25)                  ;
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
_l0:    la x11, d_1_27                            ;
        addi x11, x11, 12                         ;
        amomax.w x7, x20, (x11)                   ;
_l1:    ebreak                                    ;
_l2:    csrrsi x4, sscratch, 31                   ;
_l3:    mul x1, x1, x0                            ;
_l4:    mulhsu x22, x12, x20                      ;
_l5:    andi x18, x8, 0                           ;
_l6:    addiw x11, x8, -933                       ;
_l7:    fence.i                                   ;
_l8:    la x25, _l33                              ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l9:    la x21, d_0_0                             ;
        addi x21, x21, 16                         ;
        amoadd.d x21, x21, (x21)                  ;
_l10:   fsgnj.s f26, f26, f26                     ;
_l11:   fmax.s f26, f18, f13                      ;
_l12:   la x10, d_0_24                            ;
        lwu x10, 12(x10)                          ;
_l13:   xor x1, x1, x1                            ;
        csrrc x14, mcause, x1                     ;
_l14:   bne x24, x25, _l85                        ;
_l15:   xori x10, x18, -20                        ;
_l16:   sraiw x7, x8, 3                           ;
_l17:   fsgnjx.s f7, f26, f26                     ;
_l18:   andi x22, x30, -763                       ;
_l19:   fmv.w.x f3, x27                           ;
_l20:   fsqrt.s f3, f5, rup                       ;
_l21:   la x30, d_5_1                             ;
        addi x30, x30, 16                         ;
        lr.w x9, (x30)                            ;
_l22:   fence.i                                   ;
_l23:   srai x9, x3, 63                           ;
_l24:   feq.s x16, f26, f12                       ;
_l25:   la x6, d_0_23                             ;
        sw x6, 8(x6)                              ;
_l26:   srai x8, x29, 18                          ;
_l27:   la x17, d_4_16                            ;
        addi x17, x17, 0                          ;
        amomax.d x1, x2, (x17)                    ;
_l28:   addi x2, x1, 2047                         ;
_l29:   rem x7, x19, x20                          ;
_l30:   csrrci x23, mip, 31                       ;
_l31:   la x17, _l10                              ;
        lbu x25, 17(x17)                          ;
_l32:   fle.s x7, f6, f13                         ;
_l33:   slti x27, x28, 2047                       ;
_l34:   fdiv.s f7, f29, f22, rne                  ;
_l35:   la x26, d_1_24                            ;
        addi x26, x26, 0                          ;
        amoand.d x15, x14, (x26)                  ;
_l36:   bge x16, x23, _l38                        ;
_l37:   blt x9, x23, _l51                         ;
_l38:   fence                                     ;
_l39:   bgeu x7, x24, _l81                        ;
_l40:   fcvt.s.l f7, x10, dyn                     ;
_l41:   la x26, d_5_14                            ;
        addi x26, x26, -8                         ;
        amominu.d x18, x20, (x26)                 ;
_l42:   csrrsi x14, pmpaddr2, 17                  ;
_l43:   fcvt.s.l f18, x30, rne                    ;
_l44:   la x5, d_1_18                             ;
        ld x25, 16(x5)                            ;
_l45:   fcvt.s.w f11, x18, dyn                    ;
_l46:   la x25, d_1_6                             ;
        srai x25, x25, 1                          ;
        csrrs x29, pmpaddr2, x25                  ;
_l47:   addw x25, x17, x4                         ;
_l48:   la x12, d_5_21                            ;
        addi x12, x12, 4                          ;
        lui x10, 0xffe00                          ;
        xor x12, x12, x10                         ;
        lr.w x17, (x12)                           ;
_l49:   fsgnj.s f27, f18, f1                      ;
_l50:   fmv.w.x f13, x1                           ;
_l51:   mulhu x28, x0, x3                         ;
_l52:   fcvt.s.w f10, x20, rdn                    ;
_l53:   la x21, d_2_11                            ;
        addi x21, x21, 24                         ;
        amoadd.d x25, x22, (x21)                  ;
_l54:   fmax.s f24, f19, f19                      ;
_l55:   la x29, _l87                              ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l56:   la x9, d_4_8                              ;
        addi x9, x9, -0                           ;
        amomaxu.w x29, x13, (x9)                  ;
_l57:   xor x24, x24, x24                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 3                          ;
        add x24, x24, x10                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 1                          ;
        add x24, x24, x22                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 18                           ;
        add x24, x24, x7                          ;
        csrrc x14, scause, x24                    ;
_l58:   fsgnj.s f26, f28, f12                     ;
_l59:   fadd.s f3, f25, f28, rdn                  ;
_l60:   div x9, x11, x28                          ;
_l61:   la x27, d_2_9                             ;
        srai x27, x27, 1                          ;
        csrrw x6, pmpaddr1, x27                   ;
_l62:   la x23, d_5_1                             ;
        addi x23, x23, -4                         ;
        amoor.w x1, x11, (x23)                    ;
_l63:   srai x19, x30, 7                          ;
_l64:   ori x5, x5, -2047                         ;
_l65:   bge x14, x22, _l87                        ;
_l66:   la x18, d_0_26                            ;
        addi x18, x18, 12                         ;
        amominu.w x1, x27, (x18)                  ;
_l67:   fsqrt.s f24, f25, dyn                     ;
_l68:   la x31, d_1_15                            ;
        srai x31, x31, 1                          ;
        csrrw x30, pmpaddr6, x31                  ;
_l69:   fcvt.lu.s x11, f5, rtz                    ;
_l70:   blt x28, x30, _l85                        ;
_l71:   beq x26, x21, _l92                        ;
_l72:   fcvt.lu.s x2, f26, rne                    ;
_l73:   srlw x22, x12, x25                        ;
_l74:   mulh x9, x26, x18                         ;
_l75:   bge x15, x5, _l99                         ;
_l76:   sltiu x30, x0, -11                        ;
_l77:   fcvt.s.l f28, x8, rmm                     ;
_l78:   la x3, d_5_8                              ;
        addi x3, x3, -8                           ;
        amomin.d x11, x19, (x3)                   ;
_l79:   flt.s x5, f26, f14                        ;
_l80:   la x23, d_2_27                            ;
        addi x23, x23, -20                        ;
        lr.w x22, (x23)                           ;
_l81:   li x9, 0                                  ;
        la x9, pt3                                ;
        addi x9, x9, 0                            ;
        sfence.vma x9, x9                         ;
_l82:   bne x18, x16, _l90                        ;
_l83:   fcvt.w.s x18, f10, rmm                    ;
_l84:   fcvt.wu.s x17, f10, rne                   ;
_l85:   la x22, _l91                              ;
        csrrw zero, mepc, x22                     ;
        mret                                      ;
_l86:   fcvt.s.l f27, x1, rne                     ;
_l87:   la x29, d_5_22                            ;
        sb x11, 20(x29)                           ;
_l88:   andi x3, x11, -1099                       ;
_l89:   xori x30, x15, -692                       ;
_l90:   la x28, d_2_15                            ;
        addi x28, x28, 24                         ;
        amoswap.d x25, x5, (x28)                  ;
_l91:   divw x15, x19, x22                        ;
_l92:   mul x30, x18, x27                         ;
_l93:   bge x12, x7, _l97                         ;
_l94:   fmadd.s f18, f20, f19, f2, dyn            ;
_l95:   srliw x17, x4, 3                          ;
_l96:   li x3, 0                                  ;
        la x23, pt3                               ;
        addi x23, x23, 32                         ;
        sfence.vma x3, x23                        ;
_l97:   la x6, d_0_2                              ;
        lhu x26, 8(x6)                            ;
_l98:   remu x27, x12, x20                        ;
_l99:   la x28, d_4_16                            ;
        addi x28, x28, 8                          ;
        amominu.d x17, x9, (x28)                  ;
_l100:;
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
                .dword 0x9c02b919984dcac7, 0x88bd45017d0396e6
                .dword 0x7b6214d7d654091c, 0x7f04ceb3abd11af1
d_0_0:          .dword 0x4b6a104371cf5469, 0x30de6e4221041b68
d_0_1:          .dword 0x423e78391ffd0dc9, 0x81ae02217f9b2448
d_0_2:          .dword 0x5dc75cd52d2f1fb6, 0x6b6cfd3b503f716d
d_0_3:          .dword 0x476ac2fed1431717, 0x0017a8fd345a8bec
d_0_4:          .dword 0x88e1777d6ef40c30, 0x36561c3f5be7d427
d_0_5:          .dword 0x174bddb2b36be7d5, 0x5fe0481f267181d2
d_0_6:          .dword 0x305c1f3badc150b1, 0xb83060c6abf7682f
d_0_7:          .dword 0x16dcc8560374e414, 0xf4c6ddaa2218e62a
d_0_8:          .dword 0x14fb5e0110845458, 0x59bc1d98df442c2d
d_0_9:          .dword 0x83387757b6df7322, 0xb51798cad88a6e21
d_0_10:         .dword 0xc986a7102040c199, 0x4014aaa235e49cb6
d_0_11:         .dword 0xe5ca4b1efe072d3f, 0xc0db221311cc0179
d_0_12:         .dword 0x7b927711df907a4a, 0x4ac888bb40f4e87d
d_0_13:         .dword 0x930720e369c7f6f3, 0xe6290dfb360fa3d8
d_0_14:         .dword 0x374e49ca7721c761, 0x504872245c69d4d3
d_0_15:         .dword 0xc1cf6af8ef9fcf4d, 0x29196838b356c9c9
d_0_16:         .dword 0x7b22f428ef85447e, 0x7fb9e3133c76bf64
d_0_17:         .dword 0x84c483447c8b941b, 0x67611fc9780be5a8
d_0_18:         .dword 0xeec59e6d7a696b71, 0x6470fc0ab6d61bfd
d_0_19:         .dword 0xce6b24a3eea9c0e9, 0x2b2732b3e30de4bb
d_0_20:         .dword 0xbe5ef88977b065ea, 0x3f9f033b066fb0fb
d_0_21:         .dword 0x447cfe67b310e80b, 0xf380bf81fcb30517
d_0_22:         .dword 0xcdc38cf372b8cc1f, 0x475ae3951a2fdd35
d_0_23:         .dword 0x81ad64b9c995d82c, 0x6b8a54af9506bc6a
d_0_24:         .dword 0x91a6f34b34b03200, 0xe357c8f4f8549002
d_0_25:         .dword 0xab61ad3cd4da1827, 0x0ad2ec58e4c5694f
d_0_26:         .dword 0xf53a02f169ae8550, 0x1428ee984e0ef983
d_0_27:         .dword 0x6654e499a65255a3, 0xf31b9235a73dc0ac
                .dword 0xd49933a864b5d8de, 0xbcd5a94faf51dc76
                .dword 0x5ba2bd93199575c9, 0x72723851756b1d12
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x2f1dc4c2491987be, 0xbd4bb9607fb22ca1
                .dword 0xe03e05275ad4c4ac, 0x274cef7398e5a584
d_1_0:          .dword 0x4744f200ce3b171b, 0xf47e236b8827ce1b
d_1_1:          .dword 0xf8e487cc0aba1513, 0x21e265d4ae76c446
d_1_2:          .dword 0x382adb5bfe97e33b, 0x42793a06d5682c8a
d_1_3:          .dword 0xd5c37512528ce2a2, 0xb07fbb91ab2530e4
d_1_4:          .dword 0x3dbb0af3d1eff246, 0x041b28b741c16bc8
d_1_5:          .dword 0x7f2a08c5b6bfabf8, 0x6d98c5ac1ef33744
d_1_6:          .dword 0x774ce6856ec6c16f, 0xb8f36e9ea4e7c57c
d_1_7:          .dword 0x3448a14fd47e748b, 0xfda9cb4b01296fc2
d_1_8:          .dword 0x3d72a6f278990997, 0xf07e68c73e742b15
d_1_9:          .dword 0xf1406894bcf29a71, 0x841e2e4604a13b3b
d_1_10:         .dword 0x2c7a3621affd2792, 0xb8fe794e0b058f90
d_1_11:         .dword 0x532aeb35b9d74a2d, 0x0329b6ef31838155
d_1_12:         .dword 0xced4e0bbe872c84d, 0x41ff9dc9f631248d
d_1_13:         .dword 0xd8330177fd254755, 0x1dcd622d846783ab
d_1_14:         .dword 0x440b25132d63ad3b, 0xe6cdfaf75e5b90ad
d_1_15:         .dword 0x2c1558ad5afe2c35, 0xf03da7aa880c0d56
d_1_16:         .dword 0x39ac69b9aadafba8, 0x404d08bae443c422
d_1_17:         .dword 0x867ed42ba5e7c268, 0xad067714d98344d6
d_1_18:         .dword 0xdb06ec53e1bf72af, 0x58fac166c54c5d76
d_1_19:         .dword 0x5fe429f72e9d4dd9, 0x86e22f4cb2026986
d_1_20:         .dword 0xfadd0a95783e487a, 0x6e8ec2e5a8ad0298
d_1_21:         .dword 0x71dafa0e05f97f24, 0x2c0e92c762627128
d_1_22:         .dword 0xa9c54b8613d44532, 0x34d7df063d05012c
d_1_23:         .dword 0x493e3b03e8eaeb39, 0xc110534ce9892586
d_1_24:         .dword 0x22f8054b8dd982ea, 0x8dce638eddccb9e5
d_1_25:         .dword 0xf3ec8839f8ec8aa9, 0xa3428ad7ae56de89
d_1_26:         .dword 0xc93dfde90c420765, 0x824fc8172e5acfe4
d_1_27:         .dword 0xf9fc33ba2ed5b411, 0x30608e8a208620d0
                .dword 0x95ad05c4478dd171, 0x8fc0ac567dc4c0c1
                .dword 0xf3ebbd65d1dff59c, 0x7fa3e575e622aeee
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc52d110c48903284, 0x4d5e6ff1ac849975
                .dword 0x3ca760e33cc05051, 0x95995078b3e7c1ba
d_2_0:          .dword 0xdf2e0252722d4692, 0xd71020c150cf6b01
d_2_1:          .dword 0xd0e2ca271561d50a, 0x12897b64228974fa
d_2_2:          .dword 0xdf4622bd4533b307, 0x42d2fbe9bf892db7
d_2_3:          .dword 0x4500213bbd5aced4, 0x9a7666058bb1d3f1
d_2_4:          .dword 0x13082378f22f65ad, 0x38fffa3702585c45
d_2_5:          .dword 0x3db1d1d6ab9431aa, 0xaf04066872af7df6
d_2_6:          .dword 0x05f850ede499fee7, 0x7d4677cf8c6c7b03
d_2_7:          .dword 0x3c15c6ee90819206, 0x3ad81cdd6bdb8802
d_2_8:          .dword 0xc5ade1ad29ebda80, 0xd4ff5a0703d97044
d_2_9:          .dword 0xb832bbbbda5cbfe5, 0x7ba48f4db6c64007
d_2_10:         .dword 0xceafd782dc116aae, 0x03bbfc0347ece129
d_2_11:         .dword 0xfd301a824fbaa826, 0x5d48bd4e42854e44
d_2_12:         .dword 0xfe25024d7d3f87d8, 0x9b612fb3c958a681
d_2_13:         .dword 0x3c38bec508f18a5a, 0xa86fce0e38380e23
d_2_14:         .dword 0x6661aa4dcf7ddb92, 0x9a7b6a40c3b94240
d_2_15:         .dword 0xb429baab1457f59b, 0x232bc3aa002c9194
d_2_16:         .dword 0xfdaafc3e83123ace, 0x01d9e14bfc15e237
d_2_17:         .dword 0x6ae777103dfab10a, 0x6c349c3d89be5a92
d_2_18:         .dword 0x1492f7da680c4e5b, 0xfc3fec68e2f454e4
d_2_19:         .dword 0x48cfa4d377f4caa6, 0x59676cd8b652ed5c
d_2_20:         .dword 0xf0a6577561c852fb, 0x169e2ba8a784b87c
d_2_21:         .dword 0x52f9fbb46e07c812, 0x2c6c90db6e406f1f
d_2_22:         .dword 0xb802583ed85d787b, 0xfaa6a69e0e62f221
d_2_23:         .dword 0xa39ebbcc3747efa5, 0x487241956bdb390e
d_2_24:         .dword 0xa0d11850c0d2aeb8, 0xcafd51f10ef4e978
d_2_25:         .dword 0xe2285866020cf6ef, 0x3c1fd19f2fa04ee2
d_2_26:         .dword 0xd1ca530c8dff5fd4, 0x5653f045beb04b32
d_2_27:         .dword 0x7406581f386dfda0, 0xcd9fd6e110d11643
                .dword 0x4e4b7a4e568813bb, 0xbf55037a5a8bc0ed
                .dword 0x2ca42daa95b5b281, 0xafd77514d445da2c
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x17f3e29f0afffe08, 0x1e413a337d6c1a22
                .dword 0x9699eaa22c7d8df7, 0xea70aa735a6d2ea7
d_3_0:          .dword 0x0fe263beec1528f3, 0x9cf2dd98db376ffd
d_3_1:          .dword 0xaa98e3b169d905ab, 0xad4347fc5d798d61
d_3_2:          .dword 0xca72119bdf46c0a9, 0x2d1d68157098be1e
d_3_3:          .dword 0xbdbb4660a9c10605, 0x75e2e5ff930fd2b5
d_3_4:          .dword 0x3366736b80f1c204, 0x60746b40779dbefb
d_3_5:          .dword 0xc6b24f5d61389aae, 0x1f2ae25a40934376
d_3_6:          .dword 0xc23a25e0d9ae75b8, 0xa1d052eb5cca4969
d_3_7:          .dword 0xea93fc2f41653c6d, 0xc537f0fb45cd38ee
d_3_8:          .dword 0x23db9a495edbe8e2, 0xbfdfe19083c77112
d_3_9:          .dword 0x663a6534df755e85, 0xb5f8004d5f25662f
d_3_10:         .dword 0x914a9d8b633129a4, 0xa4dfb97d9407d9c1
d_3_11:         .dword 0x7bc3e639dfe7ed21, 0x5cee3ad68e28ce97
d_3_12:         .dword 0x1311d2a2b9c3a041, 0x176980a557aa92bd
d_3_13:         .dword 0x7d4cec7e1025c64c, 0x9b2b1511fc75e858
d_3_14:         .dword 0xe0c30e3a4c2d2e86, 0xec53414080ec5c7d
d_3_15:         .dword 0x048b80a1ae25a82a, 0xdbf7c1ed56a900f2
d_3_16:         .dword 0x3727aaa3d1b26d77, 0x73a4825cba1ba1c9
d_3_17:         .dword 0x75e83b3201b7465b, 0xdd182d89fe145903
d_3_18:         .dword 0xd858e54ea178cbc0, 0x5c356fe20b2cbaae
d_3_19:         .dword 0xc7f9db96a9202229, 0xf5039bf6775ef9da
d_3_20:         .dword 0x32fdfcfee71f996f, 0x29623aa861666ef1
d_3_21:         .dword 0x857ec12b389c3859, 0xb5c8889275d4de6f
d_3_22:         .dword 0xb55c97c129bdc0c5, 0x9c0aa3435fff5f79
d_3_23:         .dword 0x031a6faa1a24bba5, 0xe240282d7585f227
d_3_24:         .dword 0xcecc2956d6c3006f, 0x4531bd68e4cb99c1
d_3_25:         .dword 0xa5275de61933276f, 0x5eb705584da5131f
d_3_26:         .dword 0x6b68fce0ade75e78, 0x042f2d335503dc3c
d_3_27:         .dword 0xc3c095a31f67f9a7, 0x52207fe667e0bfbf
                .dword 0x166a2127b504359f, 0x947dde5516836171
                .dword 0x7ed8d64cc239e749, 0xb3ed3423c16aba8f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8035a43d02f3c84e, 0xcbc7a1e623bc247b
                .dword 0xdcddb6de2a5d8f62, 0x96b6339ab35e166e
d_4_0:          .dword 0x6437584e91df2ec7, 0x0973e20075c1b06e
d_4_1:          .dword 0x84572e34f721ef1e, 0x0c71867ce7831b66
d_4_2:          .dword 0xbbb8e78fd6465362, 0xfe0e0064d862d7d4
d_4_3:          .dword 0x6c8dfb691bf90e0c, 0xc24ea6858867f048
d_4_4:          .dword 0x7b6b5c7665403372, 0xacad0d685c4ae055
d_4_5:          .dword 0x37b4d70e145262e0, 0xf20afc682c307cba
d_4_6:          .dword 0x2129f96b8dffba89, 0x38170ca71bc23012
d_4_7:          .dword 0xb3b6ed494ac1acf0, 0x19fbf6b1b93dbdb6
d_4_8:          .dword 0x35ad0618e2e88000, 0xdf3b498f30bcb0f4
d_4_9:          .dword 0x161f7c5ec4b9529b, 0xd14bdcd4dc39b219
d_4_10:         .dword 0xb49c3eb5d524167d, 0xf17f9706a20b4bd8
d_4_11:         .dword 0x57a54e62f55cae70, 0x6233e936b2522107
d_4_12:         .dword 0x5838107645706f4e, 0x6a3a59d9f384777c
d_4_13:         .dword 0x5fead081b9d4bf20, 0xbd477f6449ae919c
d_4_14:         .dword 0x6237c534718fd781, 0x99719459ded09dfe
d_4_15:         .dword 0xf1c6b73fd65f435d, 0xadc3aa9f71888b2c
d_4_16:         .dword 0x50ae23adcff84e09, 0x4c7f4ade77a7258e
d_4_17:         .dword 0x9c73119738e8c043, 0xc56a1e36a7768762
d_4_18:         .dword 0xccd54055ae197deb, 0x5c6917c23b319706
d_4_19:         .dword 0xec0c2d267cbcb0c7, 0x4baeaab0b9e9bd9f
d_4_20:         .dword 0x93740711956e14a4, 0xc24a35f5da35c4af
d_4_21:         .dword 0x9f883455362f5cda, 0xa105b82215188d5a
d_4_22:         .dword 0x7cb9962271c66dfb, 0x86bfffa1c7c41769
d_4_23:         .dword 0x7e1e6c50e665aec4, 0x774e890db8afb4e0
d_4_24:         .dword 0x1e5da8ce49fe1acc, 0xc7a511cd98d112e5
d_4_25:         .dword 0x2d92852a7517045c, 0xa1dfc5745b6d1f8c
d_4_26:         .dword 0x9a8c8c9ad72888a3, 0xa373df532a69d434
d_4_27:         .dword 0xe419a2d1bc90bebf, 0xfe7d677e775f0ade
                .dword 0x3010ded61e5cd0b7, 0xec4eba58b0495390
                .dword 0xbab98dd91149138f, 0x29fea67941ecfbdd
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x528f420cdb9f8d56, 0x95c0fd064980b0d7
                .dword 0x3c038da3fa4ff0c4, 0x95907bdd04d2ed43
d_5_0:          .dword 0x5cccaa01f61b3352, 0xd7139df1ac51f543
d_5_1:          .dword 0xab8c3da9fe32ac4b, 0x834688685cc4a810
d_5_2:          .dword 0x73911311a05fd788, 0x0f31a3fe4611e1e0
d_5_3:          .dword 0xd4ac3032930faf7b, 0xaf2b6ac214d589fe
d_5_4:          .dword 0x6d6dc24653045d1b, 0x923750d95c2339ef
d_5_5:          .dword 0x1ded98a04b87e06f, 0x5e898758405d660b
d_5_6:          .dword 0x27170e55258ce130, 0x0ca6afdb6b27496b
d_5_7:          .dword 0xd222d1135218b7d6, 0xf24f508b08c5fe78
d_5_8:          .dword 0xe88b0146d7d4619c, 0x9db31cc8e66750c4
d_5_9:          .dword 0xebe1fa4b3ff7c470, 0x8b83e9205edca4d6
d_5_10:         .dword 0x7160537fe5c82e58, 0x996749a0d935c2d3
d_5_11:         .dword 0xe4947b52488ec448, 0x32be8bcb936e8065
d_5_12:         .dword 0xdd5cf1809fbfae3f, 0x1862ed5d1e3b3b70
d_5_13:         .dword 0x3f65c8fa1d5dc1b7, 0xf87156820105735d
d_5_14:         .dword 0xff40802946a86a8e, 0x83284a19269e184b
d_5_15:         .dword 0x81df3c71a352bad6, 0x9fad175153858fd2
d_5_16:         .dword 0x9c1cd566e2cb4fd7, 0xfb93b7cbb85f2b07
d_5_17:         .dword 0xf9238cf4921feac1, 0x26a6b6ffc0c7a44f
d_5_18:         .dword 0x15a31f01e788aee1, 0xda054372268e0de4
d_5_19:         .dword 0x3774e6f2a4852f65, 0x6c1f75dc10dd5712
d_5_20:         .dword 0xa82df47926b5ff26, 0x2348e8cc0a4f0976
d_5_21:         .dword 0xe2d61e8deb5566ad, 0x2d99d63ad3cac0aa
d_5_22:         .dword 0x9811b20822f6940d, 0xb5a764b7adac259a
d_5_23:         .dword 0xd61d093e899be78b, 0x4f1e810c5e62f80e
d_5_24:         .dword 0x4601af13638eef6d, 0x26fbe8d28d99daf7
d_5_25:         .dword 0xdbdca3a5303333c3, 0x9881b18a800f5d14
d_5_26:         .dword 0x933df4852618c9bf, 0xac68a2b3c757160c
d_5_27:         .dword 0x2e6f410fa6cdde94, 0x9b50f70d419198d9
                .dword 0xfb9415f24464f742, 0x572b7f100081bf08
                .dword 0x1b18b2f75a139008, 0x63d267d4d42779c2
         /* Random data */
_end_data5:
              
 
