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
_p0:    csrrci x11, pmpaddr7, 0                   ;
_p1:    xor x12, x12, x12                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 24                         ;
        add x12, x12, x11                         ;
        csrrc x13, sscratch, x12                  ;
_p2:;
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
_s0:    auipc x23, 1048575                        ;
_s1:;
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
_l0:    fcvt.s.lu f6, x14, rdn                    ;
_l1:    remu x10, x11, x9                         ;
_l2:    slli x17, x4, 51                          ;
_l3:    la x24, d_4_12                            ;
        addi x24, x24, -0                         ;
        amoxor.d x7, x17, (x24)                   ;
_l4:    la x9, d_5_6                              ;
        lwu x16, -0(x9)                           ;
_l5:    la x17, d_2_15                            ;
        srai x17, x17, 1                          ;
        csrrc x18, pmpaddr5, x17                  ;
_l6:    srlw x18, x14, x6                         ;
_l7:    fcvt.lu.s x18, f9, rdn                    ;
_l8:    remuw x30, x9, x7                         ;
_l9:    la x1, d_4_9                              ;
        addi x1, x1, 24                           ;
        amoor.d x8, x17, (x1)                     ;
_l10:   la x1, _l36                                       ;
        jalr x5, 0(x1)                            ;
_l11:   la x16, d_3_7                             ;
        addi x16, x16, 4                          ;
        lui x3, 0xffe00                           ;
        xor x16, x16, x3                          ;
        amomin.w x16, x3, (x16)                   ;
_l12:   la x25, d_0_9                             ;
        addi x25, x25, -16                        ;
        amominu.d x16, x18, (x25)                 ;
_l13:   mulh x2, x11, x3                          ;
_l14:   la x2, d_0_20                             ;
        sw x26, 16(x2)                            ;
_l15:   la x29, _l40                              ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l16:   la x14, d_2_4                             ;
        addi x14, x14, -0                         ;
        amoswap.d x26, x1, (x14)                  ;
_l17:   remu x25, x27, x12                        ;
_l18:   mulh x20, x14, x13                        ;
_l19:   la x2, d_0_1                              ;
        addi x2, x2, 0                            ;
        amoswap.d x17, x4, (x2)                   ;
_l20:   fmadd.s f8, f6, f23, f6, rdn              ;
_l21:   la x17, _l24                                      ;
        csrrw zero, uepc, x17                     ;
        uret                                      ;
_l22:   la x25, _l46                              ;
        lb x26, -22(x25)                          ;
_l23:   blt x21, x24, _l44                                ;
_l24:   sllw x1, x3, x12                          ;
_l25:   xor x27, x27, x27                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 14                         ;
        add x27, x27, x14                         ;
        csrrc x1, fcsr, x27                       ;
_l26:   la x29, d_1_27                            ;
        addi x29, x29, -12                        ;
        amomax.w x19, x12, (x29)                  ;
_l27:   slti x11, x6, 591                         ;
_l28:   flt.s x12, f19, f29                       ;
_l29:   la x25, _l55                              ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l30:   slli x4, x12, 25                          ;
_l31:   sraw x29, x21, x0                         ;
_l32:   la x26, d_2_3                             ;
        lui x17, 0xffe00                          ;
        xor x26, x26, x17                         ;
        sh x9, 18(x26)                            ;
_l33:   fnmsub.s f7, f24, f7, f21, rup            ;
_l34:   la x15, d_4_4                             ;
        addi x15, x15, -24                        ;
        amoor.d x28, x24, (x15)                   ;
_l35:   la x4, d_2_27                             ;
        flw f5, -8(x4)                            ;
_l36:   srlw x30, x11, x22                        ;
_l37:   la x30, _l39                                      ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l38:   fsgnj.s f0, f29, f26                      ;
_l39:   la x29, d_4_27                            ;
        addi x29, x29, -28                        ;
        amominu.w x18, x10, (x29)                 ;
_l40:   bgeu x14, x11, _l41                       ;
_l41:   fcvt.wu.s x0, f6, dyn                     ;
_l42:   beq x28, x6, _l44                                 ;
_l43:   ebreak                                    ;
_l44:   fcvt.s.w f0, x6, rne                      ;
_l45:   fsgnj.s f31, f29, f21                     ;
_l46:   addw x1, x18, x5                          ;
_l47:   addw x15, x2, x26                         ;
_l48:   la x3, d_0_8                              ;
        addi x3, x3, -28                          ;
        amoor.w x17, x20, (x3)                    ;
_l49:   la x8, d_5_24                             ;
        addi x8, x8, 0                            ;
        amominu.d x4, x9, (x8)                    ;
_l50:   fsgnjx.s f0, f6, f5                       ;
_l51:   divuw x7, x16, x23                        ;
_l52:   la x5, _l96                                       ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l53:   la x21, _l73                                      ;
        csrrw zero, sepc, x21                     ;
        sret                                      ;
_l54:   addw x11, x7, x11                         ;
_l55:   slti x28, x15, -0                         ;
_l56:   fclass.s x21, f9                          ;
_l57:   la x5, d_4_25                             ;
        addi x5, x5, -24                          ;
        amoxor.w x1, x5, (x5)                     ;
_l58:   la x29, d_3_0                             ;
        sd x1, -16(x29)                           ;
_l59:   la x4, _l89                               ;
        csrrw zero, sepc, x4                      ;
        sret                                      ;
_l60:   subw x21, x15, x17                        ;
_l61:   li x1, 0                                  ;
        la x10, pt1                               ;
        addi x10, x10, 32                         ;
        sfence.vma x1, x10                        ;
_l62:   la x26, d_3_20                            ;
        addi x26, x26, 16                         ;
        sc.w x17, x2, (x26)                       ;
_l63:   fcvt.l.s x27, f20, rne                    ;
_l64:   la x14, d_3_6                             ;
        addi x14, x14, 8                          ;
        amomax.d x13, x21, (x14)                  ;
_l65:   beq x5, x6, _l88                                  ;
_l66:   bge x23, x11, _l95                                ;
_l67:   divuw x9, x18, x29                        ;
_l68:   fadd.s f22, f22, f0, rup                  ;
_l69:   fmin.s f28, f13, f14                      ;
_l70:   blt x8, x25, _l78                                 ;
_l71:   slli x7, x18, 63                          ;
_l72:   ebreak                                    ;
_l73:   csrrci x22, pmpaddr4, 15                  ;
_l74:   la x23, d_5_7                             ;
        addi x23, x23, 8                          ;
        amomaxu.w x7, x16, (x23)                  ;
_l75:   sltiu x0, x25, -210                       ;
_l76:   fmin.s f7, f7, f9                         ;
_l77:   la x2, d_5_27                             ;
        addi x2, x2, -4                           ;
        amoxor.w x22, x17, (x2)                   ;
_l78:   andi x0, x29, -576                        ;
_l79:   srli x6, x10, 12                          ;
_l80:   slli x30, x25, 49                         ;
_l81:   addi x11, x18, -1363                      ;
_l82:   fsqrt.s f24, f19, rup                     ;
_l83:   mulw x11, x14, x1                         ;
_l84:   lui x12, 26                               ;
_l85:   la x29, d_5_15                            ;
        addi x29, x29, -0                         ;
        lr.d x3, (x29)                            ;
_l86:   fclass.s x21, f13                         ;
_l87:   auipc x27, 12                             ;
_l88:   sltiu x24, x24, -1229                     ;
_l89:   auipc x7, 79392                           ;
_l90:   fdiv.s f22, f27, f17, rdn                 ;
_l91:   la x21, d_4_8                             ;
        addi x21, x21, 0                          ;
        lr.d x13, (x21)                           ;
_l92:   fmax.s f0, f27, f2                        ;
_l93:   fcvt.lu.s x29, f6, dyn                    ;
_l94:   fsgnjn.s f28, f28, f31                    ;
_l95:   blt x14, x9, _l97                                 ;
_l96:   mulh x23, x16, x28                        ;
_l97:;
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
                .dword 0xc8178cf49611297c, 0x89729fb2f80e7649
                .dword 0xb37241f7d5bd75f3, 0xe9cf0bf4e3c926f8
d_0_0:          .dword 0x2d5e42a4fb1e55ce, 0x2d7a8c4790aeab0c
d_0_1:          .dword 0x031a376b8b31fadc, 0xada2b0a7deba09d7
d_0_2:          .dword 0x9d856385aecb5a59, 0xb25e8214c5721592
d_0_3:          .dword 0x59e402d453c60f25, 0x55b12d093f49a3a1
d_0_4:          .dword 0x73fc7db4322457bf, 0x0048b5e190fb301e
d_0_5:          .dword 0x9518fbf93c192086, 0x85f59d72e7b5d033
d_0_6:          .dword 0x4bc6ff7be37aef9f, 0x0db0fb61088ed1d6
d_0_7:          .dword 0x77f4a213ae5ceb69, 0x25239c4f03e4e000
d_0_8:          .dword 0x789073e694b01056, 0x7148fcde3073c99e
d_0_9:          .dword 0xb104d0f291b3ee21, 0xf3e82811c71869c4
d_0_10:         .dword 0x99f9a56d9cb74b82, 0xc2c83719a5e9db2b
d_0_11:         .dword 0xc9fe03692e2661cc, 0x7a4d097b3f234dbb
d_0_12:         .dword 0x76bbf41c205d00ef, 0x6018002b1ce0ad65
d_0_13:         .dword 0x19459c51775ca980, 0x0f829df83d8b77ec
d_0_14:         .dword 0x9f600c5652b2950e, 0x14331bc0a791d1d4
d_0_15:         .dword 0xbcfe1f703ab4abb1, 0xf99eaed944ba3ba2
d_0_16:         .dword 0x0431aa783be24d44, 0x610d2548b8de0cf8
d_0_17:         .dword 0xc854e15a54460081, 0x6c28a1e4ca2fdeb8
d_0_18:         .dword 0x7e33d1308c6d6c60, 0x424489c370bbab2c
d_0_19:         .dword 0x2d3dd06835e05aca, 0x5250998ee6cfbc9b
d_0_20:         .dword 0x19b74ddb8f902d03, 0x02b64cce5d0a671d
d_0_21:         .dword 0xc92fa2eec4950b0c, 0x2bc4f82e15c06e30
d_0_22:         .dword 0xb84c8f15650e2e19, 0xe81ed7b47e4928d6
d_0_23:         .dword 0x88f4fba35445ad04, 0x5b39442a4a7bb875
d_0_24:         .dword 0xec8a7e7ac6ff2cba, 0x7291598b4a5a5b8b
d_0_25:         .dword 0x0fb07fcdfe0fcb69, 0xe6b455ecc641aab4
d_0_26:         .dword 0xd937828ee2f4a77b, 0x24d7516c314ff003
d_0_27:         .dword 0x966171fcb3779340, 0xa773393451c8f956
                .dword 0xfb9d8d8cb1798b9d, 0xfdfb10f842be95ad
                .dword 0xeae46a92a0756f48, 0x2410d0d310bac70a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x69c8a51048188107, 0x4d4de10f4f54d61d
                .dword 0x5ffd284ac4e762eb, 0x32aee550c989a7b8
d_1_0:          .dword 0x51efe07103a14acf, 0x854c874f58c63bdc
d_1_1:          .dword 0x09fa645e3fc4d2a5, 0xfc48fd9f4b9791af
d_1_2:          .dword 0x2bb83473c95921ff, 0x87d6b36c9da66a9d
d_1_3:          .dword 0xa5e051d6abef8539, 0xce2e387ba1b8abea
d_1_4:          .dword 0x73e82c106c5510a4, 0x6108e6e757642471
d_1_5:          .dword 0xebeda5c5f02cc369, 0x05db74a75eb9e0de
d_1_6:          .dword 0x7c1457ef0213842d, 0x0a4f7105d30622da
d_1_7:          .dword 0x54c734e6b2a8f6ec, 0x424966b1be37bf7c
d_1_8:          .dword 0x66b686a24785e518, 0xc1b68fb99a908d59
d_1_9:          .dword 0x25d85577c8b2fa63, 0x6f2168bf911e43c3
d_1_10:         .dword 0x40f42733b83c6fc1, 0x896f198685bb6dd9
d_1_11:         .dword 0xc3483a3e13c58d71, 0xb29ca2eb91cded58
d_1_12:         .dword 0x69cbc9b467b266f5, 0x7b9b3e8a301596a8
d_1_13:         .dword 0xfed388871ef4c938, 0x7c30819ce335bd25
d_1_14:         .dword 0x82f6232a513570b7, 0x90ec8899ce47b483
d_1_15:         .dword 0x8c735dadfc778a80, 0xf4aeed7d0fdfbdba
d_1_16:         .dword 0xfb6fd1deeedc323a, 0x1b065ece9f4632ea
d_1_17:         .dword 0xfbe34b7a9e7cbc52, 0x2325bb35e9c19cfd
d_1_18:         .dword 0xd29a8e32468556cc, 0x3c1982dd322e6f1c
d_1_19:         .dword 0xc6e55f7fab1131c4, 0xcccc74174c5f0386
d_1_20:         .dword 0x87059a6af2bb35c0, 0xa964bab664b40e3e
d_1_21:         .dword 0x4d81aa93acc0138a, 0x8ec2dd3090dbddf8
d_1_22:         .dword 0xf147bc2f3e04b477, 0x4f816c07c699c349
d_1_23:         .dword 0xc97a23e743b4f7ea, 0x6882ff548768270b
d_1_24:         .dword 0x379d00819da2037f, 0x440fd6a3e6168ce5
d_1_25:         .dword 0xe96101a3bf0cab66, 0x903e4ac2ddf7013b
d_1_26:         .dword 0x4360bb0ea2a94f39, 0x702981c121cbfe31
d_1_27:         .dword 0x9d209a8e9ae0037e, 0xb76c12b97554c7be
                .dword 0xfff9f5bac8376bf4, 0x95c8b18e224afc90
                .dword 0x50d08abd6fe91965, 0x6663f73f1a624a15
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x680dce07408087d3, 0x6d8ca14db4f1d139
                .dword 0xcb28136c4a4b5c13, 0xe42e19b385264c36
d_2_0:          .dword 0x381235dbdd20510a, 0x97faab02b1e19f4e
d_2_1:          .dword 0x21f3a2d51e7e1056, 0xf0361ca08508e81b
d_2_2:          .dword 0x9c1d0e959d02134f, 0xfbb15b53c3fa6fa8
d_2_3:          .dword 0x27057dfca2f52525, 0x847645a9eec83960
d_2_4:          .dword 0x2f00de4048eeb6ea, 0x04b86d54c5e7f87a
d_2_5:          .dword 0x84ff41a2ba792a46, 0x1f99fb10420f5a1a
d_2_6:          .dword 0xded03ccb6d83817b, 0xb1e3ddb8401f1a05
d_2_7:          .dword 0xef00bcabe89c27b3, 0xa48b94adfd6ce0dd
d_2_8:          .dword 0x693cefc314c61723, 0x5ef680b7c55069e0
d_2_9:          .dword 0x23e5f2069ce3395b, 0xa18fbcbe6481a7bc
d_2_10:         .dword 0x77fae67503161294, 0x0514fe2797abcf9b
d_2_11:         .dword 0x058cf35cb0a1ea29, 0x5c8972111ef715a0
d_2_12:         .dword 0x0ce0a39635f02f3b, 0x67ba95465d935230
d_2_13:         .dword 0xe0e854759e8ba0c3, 0xde8b9849a876d89a
d_2_14:         .dword 0x5f01174b0ed92d4b, 0xd6ae81f3c77f4eff
d_2_15:         .dword 0x3e7ef5c3d8b68cd6, 0x33d5e40db45345b3
d_2_16:         .dword 0x5c6b410ecee0fe7c, 0xf0fa37ca23a82f63
d_2_17:         .dword 0xb4ad807866161b3d, 0x343d676c29fc6a53
d_2_18:         .dword 0xbc10d942f2f6640f, 0xd41553d86121523b
d_2_19:         .dword 0x82d044a7c319c7bc, 0x8e652a5608252b09
d_2_20:         .dword 0x1fa2e529ddb09d4f, 0x8179c06578aa7ee5
d_2_21:         .dword 0x2dadc076b8a11c55, 0x14674809712dcd3c
d_2_22:         .dword 0xb9f13c058058b63f, 0xe1399d4b02308582
d_2_23:         .dword 0xe678c24d30eb5ea1, 0xafead719591d9c5a
d_2_24:         .dword 0x366f6a11e721ee5b, 0x494385a0161da52f
d_2_25:         .dword 0x1a0b9047b370b489, 0x63df9b689c43a7d0
d_2_26:         .dword 0x35f41cd55392b909, 0xcecb03c1d8e2a44d
d_2_27:         .dword 0xf356b5854a56abd8, 0x539b0bc1f3a1ecfd
                .dword 0xee4e953b0c2c5fd1, 0x224ed31cafe7842d
                .dword 0xb7933a4a708a97b7, 0x99abeeb017117692
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x064991b514249760, 0xe73b54fcf888d18b
                .dword 0x2c2d3f45337fc05f, 0x9d315bf177b3509e
d_3_0:          .dword 0x425e4b9150a98af3, 0x766e2b44b00f47c0
d_3_1:          .dword 0x2bf8f6bfa81d35c7, 0x35deb3162c728f12
d_3_2:          .dword 0xab10f42528873bfe, 0x6144756a884a2ba4
d_3_3:          .dword 0x072f5d6a91585209, 0x3562b80c4519faa6
d_3_4:          .dword 0xbc439a9b1d26e991, 0xba4c70470ae32c05
d_3_5:          .dword 0x14df943e79b94bcc, 0x119412d7adfdd030
d_3_6:          .dword 0x802222747b38c506, 0x225c02563404d4d4
d_3_7:          .dword 0xa0cfff59b3a71f72, 0xd9bd3a9658b8c63c
d_3_8:          .dword 0x86f0b264874d0edf, 0x3ed8d67f1540d3c1
d_3_9:          .dword 0x08aaade9da54fe3c, 0xbae85adc5dd4fde4
d_3_10:         .dword 0x5ecbc5f7e108ef35, 0xee8368e19e9b5e27
d_3_11:         .dword 0x78b79da8ad6b1d82, 0x8421c361cea9c5d4
d_3_12:         .dword 0x0e41646ebbf8ede2, 0x5363d412ca959496
d_3_13:         .dword 0xd4e181a4d1a60baa, 0xa118800dd754db61
d_3_14:         .dword 0xdcb466a37d50e2bf, 0x94aad37bb8940dfd
d_3_15:         .dword 0x7bb8cdc996751769, 0x772cc34ca1331471
d_3_16:         .dword 0xd871ac2ddd63c26b, 0xb920f55af4721360
d_3_17:         .dword 0xe1e3fdc3f25ed5cd, 0x87fac9c8f14423c2
d_3_18:         .dword 0xf51dade054d43afc, 0x2d606c08778d1756
d_3_19:         .dword 0x80594afb308ecd98, 0xaae7c75ad8c99da9
d_3_20:         .dword 0x1dfc56b1d209eb3b, 0x7f90d5fa53ece719
d_3_21:         .dword 0x9c2e81818f8651c2, 0x50d55b3e5fd069eb
d_3_22:         .dword 0x26458d51305a152e, 0x8d71eb5642cf0956
d_3_23:         .dword 0x445fe808143d3ecc, 0xc9e7b4ca53ffc728
d_3_24:         .dword 0xf94c5eae754f9142, 0x4ac80ff86db251a5
d_3_25:         .dword 0xaeb50979fe5575c4, 0x6caddc4ab5844794
d_3_26:         .dword 0x4a3cdcaa978c2b26, 0x0272a5d17f66afce
d_3_27:         .dword 0xe27a30ba07bcca84, 0x4fecae874d9b49b5
                .dword 0x4d1499885c522384, 0xf71baffd20ece060
                .dword 0x48b5ae33314713f3, 0xeca57377f36b783d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xcf41348f3685aaa7, 0x930d5ae9a73892c7
                .dword 0xa1c56065651bbc82, 0xc889e3502f0ebaab
d_4_0:          .dword 0xd3dd24593cc806b4, 0xbf2ed2b3761702cb
d_4_1:          .dword 0xb713a49a8f83a175, 0x8f1d1ec55d93fcd6
d_4_2:          .dword 0x7567c1ca37213a26, 0x47bbcc9a6ac4117c
d_4_3:          .dword 0x875aa81bb8b2300e, 0x82ad6f3abcae8809
d_4_4:          .dword 0x15d26aa03151bf12, 0xfcbfedc00d1113c8
d_4_5:          .dword 0xb3ce1c6e7cb2d759, 0x30ab64c85a6ab8f3
d_4_6:          .dword 0xe959fec50ba94bd0, 0x39730e685ee8ef49
d_4_7:          .dword 0xecc044dbf99743a6, 0x4a5626ef1f878c99
d_4_8:          .dword 0x70c67e8898331971, 0xc81491240e491cde
d_4_9:          .dword 0x79cd53ab959b22c8, 0x18d1aa3d720d4261
d_4_10:         .dword 0x479a5f965db05b96, 0xb54e99e1fd98d097
d_4_11:         .dword 0xfebc6331e126abd9, 0xa2a92911a8be3da3
d_4_12:         .dword 0x006d5355132f4055, 0x6c6d8a7b6a7d5814
d_4_13:         .dword 0x8cb2e7c3beb4c04c, 0xb233d95aa717be84
d_4_14:         .dword 0x2a45d3c00370c103, 0x4220aefb878d936e
d_4_15:         .dword 0xa90ae439a24457a6, 0x51e602b73886acc6
d_4_16:         .dword 0xc47a97a9893612af, 0xbf6c6de9398bbb04
d_4_17:         .dword 0xed31c58ebbc8d60f, 0xfb8ef5ef36aa5649
d_4_18:         .dword 0x0c0d301483f4f08c, 0x0a44aa83716da748
d_4_19:         .dword 0x373743447c11bf27, 0x3a054041092cd011
d_4_20:         .dword 0xa4ff0905ae43f41d, 0x1b80a183902b9738
d_4_21:         .dword 0x1ff98f1614c03ab1, 0x2a857ea2c942bc83
d_4_22:         .dword 0x5cee5d08c72cdb7b, 0x2dd1096d5c568bf8
d_4_23:         .dword 0x91d2a939eff45362, 0x751196bc2176d498
d_4_24:         .dword 0xb78ae8ecbf709946, 0xc56f67a2cb65386b
d_4_25:         .dword 0x02d4adf73b033363, 0x966c85b72137ebef
d_4_26:         .dword 0xced2fda6148d99a1, 0x88980176f90da20d
d_4_27:         .dword 0xac747527ce2d3f16, 0xe1381fab4cac96fc
                .dword 0xd52054615d960dd6, 0xe5870373e82179a7
                .dword 0x9ec1849d67350b00, 0x02a971ae0f22ed69
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x541f6fe27c74319f, 0xbc1b52e283a3c474
                .dword 0xbe4cf1e4556c3fce, 0x2609d1e202d21acd
d_5_0:          .dword 0xafafd5a240cf8ba9, 0xdb54ffba053fe9cb
d_5_1:          .dword 0x2dfa5fa8f2695703, 0x888362995f843014
d_5_2:          .dword 0x2e821a2eb2f7d324, 0xcd3a60a162e90bcb
d_5_3:          .dword 0x49f03efcf6c0ddd0, 0x9f2c681bfa1b0432
d_5_4:          .dword 0x0a9808d1f48704b2, 0x833c6be3c990cafc
d_5_5:          .dword 0x33e4874c52114dc8, 0x89c8ef32c13396ff
d_5_6:          .dword 0x27fff3d758277334, 0xb95346ccc41b6dac
d_5_7:          .dword 0x4d91f6d4b4f415d4, 0x7cd3665d59a97fe9
d_5_8:          .dword 0x0a830ba6a1f749ce, 0x25d2c13be4a5de6c
d_5_9:          .dword 0x6fe53f8e942833f9, 0x1cf3419eb30c5e8a
d_5_10:         .dword 0x348c3c6edff01712, 0xb82a06cc35b23e19
d_5_11:         .dword 0xdc793157d1b64918, 0x2196d5e1b4b4a1dd
d_5_12:         .dword 0x775e578829f2bc06, 0x97e2b27d21037179
d_5_13:         .dword 0x4b84973772e1ac42, 0x9376dcbf0e997104
d_5_14:         .dword 0xe25f1720d5157785, 0xa903373d02d775a4
d_5_15:         .dword 0x64da2384630f576a, 0xef7fc9384dc569aa
d_5_16:         .dword 0xa8998f56adfbd685, 0x0d711047b023257b
d_5_17:         .dword 0x9bb48da2bafc00b0, 0xab9ed2a5e464f93a
d_5_18:         .dword 0x44edf4fb75cafd9d, 0xaa87e1c7b1928eee
d_5_19:         .dword 0x6a4216bb7ef845a1, 0xcc45173aa266a4fb
d_5_20:         .dword 0x8fdcd98891654e66, 0x63ddd12f42017866
d_5_21:         .dword 0x3418821dafcc2cdf, 0x2fc397c9ed519af1
d_5_22:         .dword 0xa7b067a79319c980, 0xdaf8550c3663c2e4
d_5_23:         .dword 0xb9738fb2dee3fed9, 0x028ac42bd94985b7
d_5_24:         .dword 0xeb4508c84d4ef305, 0x3e92d46632a70bf1
d_5_25:         .dword 0x189f336c7eed538d, 0x2c058c8450f72017
d_5_26:         .dword 0xb0635879b25a8410, 0x07096d9c9b8efbe1
d_5_27:         .dword 0x15c6153e57ada900, 0x5e335b91fd6087e0
                .dword 0x8f6db4cec66e9191, 0xef3a4713e725726c
                .dword 0x6049803223461929, 0x84d70e04ca1f1819
         /* Random data */
_end_data5:
              
 
