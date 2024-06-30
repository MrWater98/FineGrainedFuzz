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
_p0:    csrrsi x10, satp, 0                       ;
_p1:    xor x12, x12, x12                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 8                          ;
        add x12, x12, x12                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 13                         ;
        add x12, x12, x11                         ;
        csrrs x13, satp, x12                      ;
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
_s0:    xor x22, x22, x22                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 12                         ;
        add x22, x22, x30                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 30                         ;
        add x22, x22, x28                         ;
        csrrc x26, mip, x22                       ;
_s1:    remw x20, x6, x12                         ;
_s2:    la x31, d_2_1                             ;
        addi x31, x31, 20                         ;
        lui x28, 0xffe00                          ;
        xor x31, x31, x28                         ;
        amomax.w x25, x28, (x31)                  ;
_s3:    la x10, d_4_27                            ;
        addi x10, x10, 8                          ;
        lr.d x19, (x10)                           ;
_s4:    bne x13, x28, _s5                                 ;
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
_l0:    la x5, _l37                                       ;
        lui x25, 0xffe00                          ;
        xor x5, x5, x25                           ;
        lbu x8, -31(x5)                           ;
_l1:    la x14, d_5_12                            ;
        lh x27, -8(x14)                           ;
_l2:    fsqrt.s f14, f14, dyn                     ;
_l3:    fmin.s f19, f1, f1                        ;
_l4:    fmv.x.w x9, f9                            ;
_l5:    fcvt.w.s x13, f29, rdn                    ;
_l6:    la x13, d_3_15                            ;
        lui x19, 0xffe00                          ;
        xor x13, x13, x19                         ;
        lbu x7, -20(x13)                          ;
_l7:    ecall                                     ;
_l8:    mulw x21, x29, x11                        ;
_l9:    la x9, d_0_0                              ;
        fsw f20, 8(x9)                            ;
_l10:   sltiu x2, x0, 1334                        ;
_l11:   feq.s x22, f27, f3                        ;
_l12:   fcvt.l.s x7, f14, rdn                     ;
_l13:   lui x17, 443596                           ;
_l14:   mul x7, x13, x19                          ;
_l15:   la x14, d_5_24                            ;
        addi x14, x14, -24                        ;
        amoswap.d x21, x9, (x14)                  ;
_l16:   sraiw x9, x16, 31                         ;
_l17:   blt x5, x20, _l80                         ;
_l18:   la x14, _l20                                      ;
        lh x2, 16(x14)                            ;
_l19:   fsub.s f29, f2, f4, rne                   ;
_l20:   lui x15, 936889                           ;
_l21:   fsub.s f15, f0, f10, rdn                  ;
_l22:   addiw x15, x15, -1814                     ;
_l23:   mulhsu x9, x3, x7                         ;
_l24:   la x16, _l76                              ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l25:   bge x15, x21, _l28                                ;
_l26:   xori x17, x18, -1133                      ;
_l27:   la x28, _l80                                      ;
        srai x28, x28, 1                          ;
        csrrc x1, pmpaddr7, x28                   ;
_l28:   fclass.s x30, f18                         ;
_l29:   li x20, 0                                 ;
        la x1, pt3                                ;
        addi x1, x1, 56                           ;
        sfence.vma x20, x1                        ;
_l30:   la x9, _l40                                       ;
        ld x28, 16(x9)                            ;
_l31:   fadd.s f6, f0, f22, rmm                   ;
_l32:   andi x17, x27, -953                       ;
_l33:   andi x16, x23, -0                         ;
_l34:   flt.s x11, f1, f6                         ;
_l35:   fcvt.wu.s x18, f18, rdn                   ;
_l36:   auipc x9, 874445                          ;
_l37:   la x27, _l42                                      ;
        csrrw zero, sepc, x27                     ;
        sret                                      ;
_l38:   la x27, d_5_20                            ;
        addi x27, x27, 0                          ;
        amomaxu.w x21, x5, (x27)                  ;
_l39:   fcvt.s.lu f22, x16, dyn                   ;
_l40:   la x24, d_2_11                            ;
        addi x24, x24, 0                          ;
        sc.w x7, x11, (x24)                       ;
_l41:   addw x17, x16, x6                         ;
_l42:   la x6, _l71                                       ;
        lwu x10, -0(x6)                           ;
_l43:   la x29, d_4_23                            ;
        fsw f9, -20(x29)                          ;
_l44:   la x7, _l75                               ;
        csrrw zero, mepc, x7                      ;
        mret                                      ;
_l45:   la x11, d_0_7                             ;
        addi x11, x11, 20                         ;
        amomaxu.w x18, x21, (x11)                 ;
_l46:   fence.i                                   ;
_l47:   la x5, d_2_20                             ;
        lh x24, -0(x5)                            ;
_l48:   la x26, d_4_18                            ;
        addi x26, x26, 24                         ;
        amoand.w x28, x9, (x26)                   ;
_l49:   fcvt.s.l f24, x10, dyn                    ;
_l50:   la x21, _l51                                      ;
        csrrw zero, uepc, x21                     ;
        uret                                      ;
_l51:   la x2, d_1_2                              ;
        lui x16, 0xffe00                          ;
        xor x2, x2, x16                           ;
        sh x24, -30(x2)                           ;
_l52:   csrrwi x24, pmpaddr4, 22                  ;
_l53:   fadd.s f12, f20, f20, rtz                 ;
_l54:   xori x11, x24, -1237                      ;
_l55:   sraiw x14, x2, 13                         ;
_l56:   fmadd.s f12, f10, f5, f21, rup            ;
_l57:   la x17, d_4_9                             ;
        fsw f24, 12(x17)                          ;
_l58:   andi x18, x24, -417                       ;
_l59:   mulw x28, x1, x24                         ;
_l60:   sraw x30, x26, x16                        ;
_l61:   la x7, d_0_16                             ;
        lui x7, 0xffe00                           ;
        xor x7, x7, x7                            ;
        lh x11, -22(x7)                           ;
_l62:   la x25, d_0_13                            ;
        addi x25, x25, -16                        ;
        amominu.d x30, x10, (x25)                 ;
_l63:   fsgnjx.s f12, f14, f19                    ;
_l64:   fnmsub.s f30, f27, f1, f17, rne           ;
_l65:   remu x19, x11, x16                        ;
_l66:   fmul.s f16, f29, f12, rne                 ;
_l67:   ecall                                     ;
_l68:   andi x0, x7, -2047                        ;
_l69:   la x25, d_3_22                            ;
        sw x19, 4(x25)                            ;
_l70:   ecall                                     ;
_l71:   remw x19, x29, x22                        ;
_l72:   fnmadd.s f24, f20, f4, f22, rup           ;
_l73:   subw x15, x0, x7                          ;
_l74:   sraw x20, x6, x6                          ;
_l75:   fsgnj.s f13, f14, f3                      ;
_l76:   la x29, d_5_16                            ;
        addi x29, x29, 0                          ;
        amoswap.w x28, x10, (x29)                 ;
_l77:   bne x18, x23, _l80                        ;
_l78:   auipc x9, 294933                          ;
_l79:   mulhsu x8, x24, x26                       ;
_l80:   la x16, d_5_9                             ;
        addi x16, x16, 0                          ;
        amomaxu.d x21, x24, (x16)                 ;
_l81:   feq.s x23, f4, f9                         ;
_l82:   lui x11, 0                                ;
_l83:   la x18, d_3_23                            ;
        sh x3, -10(x18)                           ;
_l84:   srai x20, x8, 63                          ;
_l85:   csrrsi x6, mtval, 21                      ;
_l86:   la x21, d_1_1                             ;
        addi x21, x21, 24                         ;
        amoadd.d x26, x4, (x21)                   ;
_l87:   jal x15, _l89                                     ;
_l88:   xori x9, x25, 2047                        ;
_l89:;
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
                .dword 0xfd75c42d9632f739, 0xc3807413c335cb40
                .dword 0x84924009c3bfb439, 0x0373c0bd300b37e8
d_0_0:          .dword 0x5b01b7408f4507b6, 0x57ce94556d590952
d_0_1:          .dword 0x5899d0c2a4656a7d, 0x131bb4543f1cef09
d_0_2:          .dword 0xb93bb32132d1a00f, 0xf9dbbe22b2dc2b3e
d_0_3:          .dword 0xeefce1b9dd6f5c93, 0x37b5ba554c103ebd
d_0_4:          .dword 0xca5b41bf547116b7, 0x753a076ad5265a70
d_0_5:          .dword 0xd7877f30a07e6ee4, 0xc45f368258384291
d_0_6:          .dword 0x8c5d7e95027b5985, 0x8aaee8e5ebf3cbca
d_0_7:          .dword 0xf636464b7b998cba, 0x42de32a96106066a
d_0_8:          .dword 0xdcd846ad4c3ec687, 0x47a07e9524cac0ae
d_0_9:          .dword 0xb3e2ff6cc16ab2f5, 0xa607f4e465213f4e
d_0_10:         .dword 0xc32bf96428b1a78c, 0x0c491d243bda85ac
d_0_11:         .dword 0x1ac77c4bfb980f09, 0xf030e5747bcdca1d
d_0_12:         .dword 0xf700940f0aa549cd, 0xefcc0e5efd84791d
d_0_13:         .dword 0x8291408da3ddb4db, 0x2968652c8627ab09
d_0_14:         .dword 0x01b66b840bcd1915, 0xbdc50dffec1bce3c
d_0_15:         .dword 0x2b40c5e6da85b8de, 0x37fb39586c46e01d
d_0_16:         .dword 0xc93ca903e058ab00, 0x456b97101623b620
d_0_17:         .dword 0xbaae0da020d67806, 0x8815f81f14ec6423
d_0_18:         .dword 0x72f0c1432c9341fd, 0xe718db1b6dd74655
d_0_19:         .dword 0xd38a8f063e535cf8, 0x564902e97885c083
d_0_20:         .dword 0xf213d074965f543a, 0x449a2739a95e775c
d_0_21:         .dword 0xf93c62aa6e78d7e7, 0x340c8839c9f1ac40
d_0_22:         .dword 0xbf5c5b7dcb1a1fc6, 0xe374ababefe23530
d_0_23:         .dword 0x24fb8c6b5c051326, 0x8d9d39772558065d
d_0_24:         .dword 0x0cee426f57a9e99a, 0x9d35858be26eec38
d_0_25:         .dword 0xc0208f0d27e76179, 0xbedef09deff4d4be
d_0_26:         .dword 0xe502e1765c84112a, 0x3c7c68d2c2345b1a
d_0_27:         .dword 0xde023f0abf26ba39, 0xc1e0d05d129fe8ca
                .dword 0x0f5dac6d5e200599, 0x923e7954d7cee99b
                .dword 0xc32f75f77a18a762, 0xf69b891a4f5ce44b
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xd9d0b862c9448aa2, 0x1515d324cfd23ed7
                .dword 0xf18d7e7ec0eff3f0, 0x050a38244b0fc4ab
d_1_0:          .dword 0x8b5f8230315f0e1d, 0xbc9123d8fe4be674
d_1_1:          .dword 0xa6a5b2f9c3303dcb, 0x9102f3c47f496af0
d_1_2:          .dword 0xc60dbc1b282b8f1f, 0xe5e0fe2386ab6d0a
d_1_3:          .dword 0x7b03ac3b32cb1ed8, 0x44fe46728d02b8ee
d_1_4:          .dword 0xfe1b09b966633057, 0x30ce37a6fd4af73c
d_1_5:          .dword 0x96960ac57248d030, 0xfd3be1bcc9bd8484
d_1_6:          .dword 0x009a69c1b7cb3740, 0x5bf1af017fda0141
d_1_7:          .dword 0xd1030e41fa5c13c8, 0x10a6fdfc6908c6cf
d_1_8:          .dword 0xf1df62490e9e7e7f, 0x271c810d9f8f51cc
d_1_9:          .dword 0xa28a81f7dc20cbaa, 0x61b46a8802768e11
d_1_10:         .dword 0xf4e9b4e35148c35d, 0x0072db1f0532592a
d_1_11:         .dword 0x572f86b5880f659b, 0x0c6980bf56c31d68
d_1_12:         .dword 0x65246e073df275fe, 0x06bdfa670e75f725
d_1_13:         .dword 0xc8a71bcfdcb4a570, 0x94ce5a53f55dcec3
d_1_14:         .dword 0x61ea6bf2e5533a28, 0x97f741c84fb22ba0
d_1_15:         .dword 0xe1eb2adc04416baf, 0x0ac182769931dd3b
d_1_16:         .dword 0x03fe454e54750ece, 0x2069f7426ef2d86a
d_1_17:         .dword 0xbc4bdd5ce95a7386, 0xecd12ae18f064cc6
d_1_18:         .dword 0x3781a55a2d909ff0, 0x83072eb89f2bd8f8
d_1_19:         .dword 0x1f3c444c92b7fbf4, 0x4ef987499fd811ab
d_1_20:         .dword 0xf4890e800f52b291, 0x5a8d26dd3c4ad316
d_1_21:         .dword 0x559cbac0a3ffe2d1, 0x390ab3b6dba03daa
d_1_22:         .dword 0x66fe2ae4dba730b9, 0x100ba8bb05845da2
d_1_23:         .dword 0xe10948de5d19b5cd, 0xdf32dd18a3ff2135
d_1_24:         .dword 0x5092860632af6038, 0x7371adc067eb63a6
d_1_25:         .dword 0xd96024a3bb6c7d64, 0x52f785dc56bc6219
d_1_26:         .dword 0x1968f6a14b868a56, 0x277d97b9b716efad
d_1_27:         .dword 0xe3774bfe7185e590, 0x931d574079808aeb
                .dword 0x7bd6712fd2645228, 0xf6fddc4352e7e09a
                .dword 0xd7a4fb3cabfd80c4, 0x1e39ffa7b1e907b4
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x02951ec485ae073a, 0xaafd3db241b549da
                .dword 0x57e5a15af3c191db, 0x15ccb6dbb72ae8a3
d_2_0:          .dword 0x0c884199784f62ca, 0xf681fd5e61ce3a67
d_2_1:          .dword 0x30bcf131a3c2ac74, 0x9b3247a31d2261b4
d_2_2:          .dword 0x47ebe04f730f1888, 0x86e0c211d1fb692b
d_2_3:          .dword 0x3ec0e484e6328775, 0xfa07dc311dd6dc19
d_2_4:          .dword 0xf9fabd5951e873aa, 0x44ddd44be16e3840
d_2_5:          .dword 0xbde856f17bbd28bb, 0x4f4a975e5cb16097
d_2_6:          .dword 0x3cd601aebd9f8ced, 0x1e71995dc9e22038
d_2_7:          .dword 0xea79031d2de9fd70, 0x90385886e848d720
d_2_8:          .dword 0xc323673511049d3a, 0x937431d8ff6f4c70
d_2_9:          .dword 0xe6305f2ed421b4dc, 0xd9cb08baf3525b81
d_2_10:         .dword 0xf27bf99fb78bbe5a, 0x887915e5d3de1c3f
d_2_11:         .dword 0xa4624c126e68f546, 0xcabeeb371f9b48fc
d_2_12:         .dword 0x3b8fbd3851b054e7, 0xaeb56d90c1c5d2cf
d_2_13:         .dword 0xce737b8fb085ab4f, 0x6e58fe6b11ef247c
d_2_14:         .dword 0x60ea32671fc46029, 0x1250b652002d4b14
d_2_15:         .dword 0x75868c134d2294d5, 0x5a0022f9ccf472cc
d_2_16:         .dword 0x91ca2a73a18d3ae8, 0xb9f09cea68ac47a2
d_2_17:         .dword 0x27a3a3814988cd37, 0xe135efce38b71419
d_2_18:         .dword 0x9bb8462e5bbedd9a, 0x62e3452502e67403
d_2_19:         .dword 0x6adec992d8bf5089, 0x16bcc61357fdf8f2
d_2_20:         .dword 0xb2973cd3e85b89a1, 0xca19f1e9b83f3754
d_2_21:         .dword 0xea95c08614cef3e6, 0xcd9f26c72893a46e
d_2_22:         .dword 0x35368261afc2ccb4, 0xe57018ac871144b5
d_2_23:         .dword 0xc3c05ece0bda3b92, 0x04bd021c79355c37
d_2_24:         .dword 0x313829bed207ff84, 0x5022d4f06d57f305
d_2_25:         .dword 0x34bacf6f1e581c16, 0x4b5e43c02aa6bda8
d_2_26:         .dword 0x700bf0622d05cacf, 0x0f4c4225a6f80dbc
d_2_27:         .dword 0x3b5ac4b54dd519cd, 0x517a5ff53a03f7b3
                .dword 0x4d2f10b97467b55c, 0x20b477d511f5f8ed
                .dword 0x3cd2f80d242030ea, 0x36e81b4b178c3c06
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x180db6e1130b59d5, 0x6a2d667f3f5df67d
                .dword 0xf43d7077bf64b0de, 0x9032157a9288ee89
d_3_0:          .dword 0xeddbd6af12e542c7, 0x34eaa4d01a1e913c
d_3_1:          .dword 0xb80e5616123254d4, 0xdd091e60e8b6dc07
d_3_2:          .dword 0x0eb2d760f26de06e, 0x87db2836021acf65
d_3_3:          .dword 0xdc5540cad1297e27, 0x169b2ec9244deb03
d_3_4:          .dword 0x2b6d6103d927f982, 0x44236cb61b809d0a
d_3_5:          .dword 0x9129432c023955f0, 0xb2e9cc26a44aa702
d_3_6:          .dword 0x00e6f8fc9aa95e6a, 0x069e5b651e7976e9
d_3_7:          .dword 0x2dc45072b58527b7, 0x77a1c7b90c6a0110
d_3_8:          .dword 0x821adc1a4ee3b7c2, 0x77c3d1c0749355b9
d_3_9:          .dword 0x4dd5cf55d8159a0f, 0xd659fcbcc90a9eb6
d_3_10:         .dword 0x8cf5af42b5944d5c, 0x3fd1477320d715af
d_3_11:         .dword 0x6166640da137fbe1, 0xfab2c6497f9384eb
d_3_12:         .dword 0xe5efe3388decd2cf, 0x826296152775c259
d_3_13:         .dword 0x2a28fe1c0b15869f, 0x81f6f40cd92bec41
d_3_14:         .dword 0x53966039eb2c3bcf, 0x2580e6402ecb776b
d_3_15:         .dword 0x1358032089a3dbe8, 0x634758021915ab7f
d_3_16:         .dword 0xbaaaae4fc6cca946, 0xdedd79aaa281f991
d_3_17:         .dword 0x557fc8eb711f7f70, 0xfbf82ba3b855ef77
d_3_18:         .dword 0x291c33e2fc692b83, 0xdf656f23cdbb05c9
d_3_19:         .dword 0x106c90ae4f1e3b25, 0x8d3a9cf6ba9c81a4
d_3_20:         .dword 0xa2b7346ac5a84584, 0xa355391bbdc70be9
d_3_21:         .dword 0x8d8886761a310a54, 0x09be4debbfe65c99
d_3_22:         .dword 0x34f8d1f517e0a097, 0xc5f3f04e474ce3de
d_3_23:         .dword 0x33006b464eac852c, 0xe654cf8980c3637b
d_3_24:         .dword 0x23dd213754809180, 0xe1b30ad18d0a92d1
d_3_25:         .dword 0x7d3ce61d598e9dee, 0x9ef34299ec5e75e7
d_3_26:         .dword 0x52037b3d451aa012, 0x6e7d7955d6eb1d7b
d_3_27:         .dword 0x96b2a47b80ca7c65, 0xc9c30efafd5a7b51
                .dword 0xad49280e23bf7488, 0xcde0acd1c91f69f6
                .dword 0x670acf751c86adc9, 0x43ee00ddf50e0d7f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xd3935a3de5a484c9, 0x7c8cec165bb3846c
                .dword 0xd0dae896c53d7729, 0xa3f7b05d2f4b2f33
d_4_0:          .dword 0x1044991fbf0fcf6c, 0xc2e3fc2dc268ceab
d_4_1:          .dword 0x4e52e868e9ff4ad1, 0xcce52edb306ea36e
d_4_2:          .dword 0xef52963fb82ad192, 0x6cd8b97c41737989
d_4_3:          .dword 0x0337f76192e560d0, 0x2bb60deab8d3c65f
d_4_4:          .dword 0xd9135070c199432f, 0x7794c604282c1f55
d_4_5:          .dword 0xf11be939fc3dc2d9, 0x435f3594edbde25b
d_4_6:          .dword 0x514fcf78413849d1, 0xe2a02790c1386ebf
d_4_7:          .dword 0xa4939c8052d812dd, 0xb5d21ecda97453f8
d_4_8:          .dword 0x17a994014eac2961, 0x02ec21ca36d26fd1
d_4_9:          .dword 0x5d50ce0acff99f5b, 0x5e9d70249d0d234a
d_4_10:         .dword 0x0a086306213754c8, 0xccd764d9553a6968
d_4_11:         .dword 0x337576f900894ee2, 0xa6705fcfec6bad06
d_4_12:         .dword 0xc02de14a78f20b16, 0x1f4054d6905d77fe
d_4_13:         .dword 0x62740d66488c6c87, 0x281793acbb9a6a33
d_4_14:         .dword 0xf26bb94a1f5ce268, 0x253e082b824f3a1e
d_4_15:         .dword 0x52f2a62430089629, 0xcafeb42daf365934
d_4_16:         .dword 0x88374fcd9e16f0dd, 0x4a16e74bc024c2db
d_4_17:         .dword 0x91a6612a9f44c661, 0x0c21744a150e8e6e
d_4_18:         .dword 0x8f4048b1b697f14b, 0x35c3ab3ec6ba7bba
d_4_19:         .dword 0x4d8f17cf4467e8dd, 0xe1780cde0a6290b7
d_4_20:         .dword 0xab4a9fa3d7bb73b5, 0x9147d45e5b70fdf1
d_4_21:         .dword 0x397e3b3ec36ab6a4, 0xe9bdd963136d9785
d_4_22:         .dword 0x4a87439dfff69b8d, 0x088321edc853bbd2
d_4_23:         .dword 0xebe232197eb0bf3a, 0x4420dfb62373f949
d_4_24:         .dword 0x5e11bb8e87fce592, 0x0d5e95887ec49176
d_4_25:         .dword 0x420566c89d74ec5b, 0x99a757ca4632ec13
d_4_26:         .dword 0xf7a88f0430a045fb, 0xab3ed385cbfb39e8
d_4_27:         .dword 0xb8d7bf7b1eb1395d, 0xfcca3c6ecd608e13
                .dword 0xe1fb25d0532cfe1a, 0xe788c03c52da96a6
                .dword 0x2cce41d604d92c6b, 0x4488277c6d6654b2
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4af2d9acfc2be93b, 0xccc9348e4c10b2f6
                .dword 0xfff179bebed25204, 0x4d848952b8f80e6d
d_5_0:          .dword 0xdcbe40d53339c83d, 0x7838919670286d88
d_5_1:          .dword 0x60da609489ad8cbd, 0xe2b7a4748e62fe23
d_5_2:          .dword 0xbddc4680c1d07760, 0xc321495985a42d89
d_5_3:          .dword 0x2621745f6589d36e, 0xfd8be5c40b2bcd3a
d_5_4:          .dword 0xd394ba5cc65e847c, 0xeaf5243dfbf03463
d_5_5:          .dword 0xea750d692db77f15, 0x6927faa7cfc17943
d_5_6:          .dword 0x43a698a549c201cb, 0xc45d0fa317238d78
d_5_7:          .dword 0xa682ebce2b454147, 0xbc08336dfcef6871
d_5_8:          .dword 0x1061c1e2f9438a5b, 0x8884cb24e53eb0aa
d_5_9:          .dword 0x0074bf26d1d9b8e9, 0x52eb8f378a627ebb
d_5_10:         .dword 0xc437ad7ecbef4de6, 0x4491132a5519afc7
d_5_11:         .dword 0x1ad5133a1a318a3e, 0xdec6bb594fe49ec4
d_5_12:         .dword 0x60ad31f5094e2ca0, 0xc72da59f40d61fb2
d_5_13:         .dword 0x73151e9eca87bb11, 0x8f040fca581e0fdc
d_5_14:         .dword 0x7648f1d8dbae9142, 0x3683e85ac7b872ba
d_5_15:         .dword 0x22f345effe047889, 0x99d0d024717cb74c
d_5_16:         .dword 0x8e707c5e280a1b13, 0x37fd500bda7e9603
d_5_17:         .dword 0x34df7bb23d034e96, 0x9d1e980ed5e15619
d_5_18:         .dword 0xf35143855f993d23, 0x3af7ada3cc5f777b
d_5_19:         .dword 0x75d2832638acf4c5, 0x9d7356ed7b21fc2d
d_5_20:         .dword 0x02b8f4c636777696, 0xdd32fa560fde14ad
d_5_21:         .dword 0x979d8dfa153a0c97, 0x77cda64cd2fa3bee
d_5_22:         .dword 0xc4e5d1d626272d4e, 0xe1866eddc5c4fa46
d_5_23:         .dword 0x75233b86c9706469, 0xc5f72417401221e7
d_5_24:         .dword 0x9b3180f592c5a2c8, 0x514116bcc3658fa0
d_5_25:         .dword 0x256776a71d0baebd, 0xb7215e78b8e12758
d_5_26:         .dword 0x8d028a8e6b9e9d2b, 0xe1e3a56f543bccae
d_5_27:         .dword 0x07e4ac935d310c14, 0xb58df79a3e4dff35
                .dword 0xda93d4af3655fd1e, 0x89e741bc7b01d6d2
                .dword 0x5695cc110b0e167c, 0x4654ad9703165447
         /* Random data */
_end_data5:
              
 
