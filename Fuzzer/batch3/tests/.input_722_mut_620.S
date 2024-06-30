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
_p0:    csrrsi x10, pmpaddr5, 31                  ;
_p1:    xor x13, x13, x13                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 21                         ;
        add x13, x13, x11                         ;
        csrrw x14, sscratch, x13                  ;
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
_s0:    slliw x17, x21, 26                        ;
_s1:    fmv.w.x f1, x19                           ;
_s2:;
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
_l0:    bge x10, x19, _l44                                ;
_l1:    la x17, d_2_16                            ;
        addi x17, x17, -0                         ;
        lui x6, 0xffe00                           ;
        xor x17, x17, x6                          ;
        amoand.w x12, x6, (x17)                   ;
_l2:    sltiu x3, x12, 937                        ;
_l3:    la x18, d_0_6                             ;
        sb x10, -8(x18)                           ;
_l4:    auipc x18, 307611                         ;
_l5:    la x22, d_2_17                            ;
        lh x5, -8(x22)                            ;
_l6:    beq x24, x2, _l87                                 ;
_l7:    csrrsi x4, sie, 29                        ;
_l8:    fsgnjn.s f24, f30, f10                    ;
_l9:    beq x6, x10, _l51                                 ;
_l10:   csrrsi x29, sepc, 7                       ;
_l11:   la x4, d_0_13                             ;
        addi x4, x4, 0                            ;
        sc.d x4, x4, (x4)                         ;
_l12:   xor x13, x13, x13                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 17                         ;
        add x13, x13, x28                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 27                         ;
        add x13, x13, x19                         ;
        csrrc x10, mcause, x13                    ;
_l13:   fnmsub.s f21, f9, f30, f3, rtz            ;
_l14:   la x2, d_2_26                             ;
        addi x2, x2, -24                          ;
        amomax.w x26, x11, (x2)                   ;
_l15:   fmax.s f20, f27, f9                       ;
_l16:   xor x15, x15, x15                         ;
        addi x19, zero, 3                         ;
        slli x19, x19, 22                         ;
        add x15, x15, x19                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 27                           ;
        add x15, x15, x1                          ;
        csrrc x26, sstatus, x15                   ;
_l17:   xor x22, x22, x22                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 25                         ;
        add x22, x22, x11                         ;
        csrrc x4, mcause, x22                     ;
_l18:   la x28, d_4_15                            ;
        addi x28, x28, -8                         ;
        amoxor.d x8, x15, (x28)                   ;
_l19:   la x19, d_0_16                            ;
        addi x19, x19, 0                          ;
        amoadd.d x7, x24, (x19)                   ;
_l20:   la x5, d_1_9                              ;
        addi x5, x5, -28                          ;
        amoswap.w x24, x14, (x5)                  ;
_l21:   la x22, d_2_19                            ;
        addi x22, x22, 28                         ;
        amoadd.w x18, x27, (x22)                  ;
_l22:   blt x20, x15, _l84                        ;
_l23:   sraiw x0, x21, 23                         ;
_l24:   la x14, d_5_24                            ;
        addi x14, x14, 0                          ;
        amoadd.d x3, x27, (x14)                   ;
_l25:   la x25, d_5_21                            ;
        addi x25, x25, -24                        ;
        amoxor.d x17, x24, (x25)                  ;
_l26:   lui x21, 375357                           ;
_l27:   fmul.s f4, f14, f12, dyn                  ;
_l28:   fcvt.s.wu f7, x10, dyn                    ;
_l29:   rem x17, x4, x22                          ;
_l30:   csrrci x1, sip, 21                        ;
_l31:   slli x17, x13, 34                         ;
_l32:   fmadd.s f21, f29, f23, f17, rup           ;
_l33:   subw x4, x20, x23                         ;
_l34:   la x5, d_3_19                             ;
        lw x12, 0(x5)                             ;
_l35:   divu x27, x4, x21                         ;
_l36:   fmsub.s f18, f23, f0, f1, rup             ;
_l37:   fdiv.s f10, f31, f4, rtz                  ;
_l38:   la x22, d_1_17                            ;
        addi x22, x22, 16                         ;
        lr.d x25, (x22)                           ;
_l39:   divw x22, x18, x29                        ;
_l40:   beq x14, x13, _l99                        ;
_l41:   la x19, d_5_26                            ;
        addi x19, x19, -16                        ;
        amoand.d x1, x26, (x19)                   ;
_l42:   bne x6, x23, _l44                         ;
_l43:   fcvt.s.lu f3, x26, dyn                    ;
_l44:   fsgnjx.s f21, f27, f16                    ;
_l45:   bltu x14, x14, _l64                               ;
_l46:   fcvt.s.l f13, x17, rtz                    ;
_l47:   fmsub.s f21, f21, f30, f29, rtz           ;
_l48:   la x3, _l95                                       ;
        flw f8, 0(x3)                             ;
_l49:   ori x6, x5, 430                           ;
_l50:   la x19, d_0_20                            ;
        lwu x5, -4(x19)                           ;
_l51:   la x5, d_0_22                             ;
        addi x5, x5, 0                            ;
        amomin.d x24, x5, (x5)                    ;
_l52:   blt x14, x7, _l83                                 ;
_l53:   la x15, d_5_17                            ;
        addi x15, x15, 12                         ;
        amominu.w x21, x17, (x15)                 ;
_l54:   mulhsu x19, x17, x24                      ;
_l55:   fcvt.s.lu f7, x8, dyn                     ;
_l56:   la x21, _l87                                      ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l57:   remw x15, x4, x6                          ;
_l58:   fmv.w.x f1, x10                           ;
_l59:   xori x25, x12, -2047                      ;
_l60:   fclass.s x11, f3                          ;
_l61:   la x12, d_1_9                             ;
        addi x12, x12, 4                          ;
        amoor.w x17, x15, (x12)                   ;
_l62:   sraw x0, x0, x26                          ;
_l63:   fmv.x.w x21, f29                          ;
_l64:   addiw x7, x15, 1428                       ;
_l65:   la x3, d_2_2                              ;
        fsw f17, 20(x3)                           ;
_l66:   fcvt.s.l f28, x2, rtz                     ;
_l67:   fence                                     ;
_l68:   fcvt.lu.s x9, f31, rne                    ;
_l69:   la x18, d_2_13                            ;
        ld x11, 16(x18)                           ;
_l70:   la x11, d_0_3                             ;
        srai x11, x11, 1                          ;
        csrrw x23, pmpaddr0, x11                  ;
_l71:   auipc x17, 573449                         ;
_l72:   csrrwi x3, sip, 0                         ;
_l73:   subw x21, x12, x20                        ;
_l74:   xori x27, x7, -2047                       ;
_l75:   fmul.s f26, f18, f26, rmm                 ;
_l76:   la x29, d_3_6                             ;
        addi x29, x29, -0                         ;
        lr.w x18, (x29)                           ;
_l77:   la x28, d_0_10                            ;
        sw x7, 16(x28)                            ;
_l78:   la x21, d_4_3                             ;
        addi x21, x21, -24                        ;
        amoadd.d x2, x22, (x21)                   ;
_l79:   fence.i                                   ;
_l80:   csrrci x28, fcsr, 27                      ;
_l81:   fcvt.s.l f5, x17, rtz                     ;
_l82:   la x17, d_5_26                            ;
        addi x17, x17, 28                         ;
        amomax.w x11, x1, (x17)                   ;
_l83:   mulhu x14, x15, x28                       ;
_l84:   csrrci x15, scause, 10                    ;
_l85:   fle.s x18, f11, f25                       ;
_l86:   la x27, d_3_22                            ;
        addi x27, x27, 24                         ;
        amoxor.w x9, x14, (x27)                   ;
_l87:   fcvt.s.lu f4, x9, rmm                     ;
_l88:   la x11, _l102                                     ;
        jalr x9, 0(x11)                           ;
_l89:   la x14, d_3_3                             ;
        addi x14, x14, -16                        ;
        lui x6, 0xffe00                           ;
        xor x14, x14, x6                          ;
        amominu.w x28, x6, (x14)                  ;
_l90:   blt x22, x14, _l102                               ;
_l91:   andi x12, x23, -2047                      ;
_l92:   xor x10, x10, x10                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 30                           ;
        add x10, x10, x2                          ;
        addi x3, zero, 1                          ;
        slli x3, x3, 11                           ;
        add x10, x10, x3                          ;
        csrrc x1, mstatus, x10                    ;
_l93:   fsgnjx.s f30, f14, f3                     ;
_l94:   csrrwi x28, pmpaddr4, 23                  ;
_l95:   remuw x12, x16, x24                       ;
_l96:   fsgnjn.s f17, f21, f4                     ;
_l97:   lui x8, 1048575                           ;
_l98:   bge x22, x19, _l102                       ;
_l99:   la x10, d_2_16                            ;
        addi x10, x10, -0                         ;
        lui x2, 0xffe00                           ;
        xor x10, x10, x2                          ;
        sc.d x5, x10, (x10)                       ;
_l100:  bgeu x21, x7, _l101                               ;
_l101:  addi x24, x15, -1245                      ;
_l102:  bgeu x18, x4, _l103                               ;
_l103:;
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
                .dword 0x971d3068e0a48bfd, 0x3bac92779f85aed9
                .dword 0x928084d885e7e359, 0xdb99767d49f7d97b
d_0_0:          .dword 0x5825acb6f5dc6c2d, 0x315b0febeddf96a5
d_0_1:          .dword 0x2dffc20ccf456bb7, 0x3c5b97cc204faeab
d_0_2:          .dword 0x34c715e657d35166, 0x3e1fd9dbb7fa317d
d_0_3:          .dword 0x411f43b77282c80e, 0xfe6240e4f48dbca1
d_0_4:          .dword 0x0707f23ebb00ddfe, 0x117ab842c9a08d20
d_0_5:          .dword 0xa1221fb25eebf538, 0x9851f82de7799d34
d_0_6:          .dword 0xcc22ec7711d3eb88, 0x5272c81109e502e8
d_0_7:          .dword 0xaa6bde72bb151b7a, 0xa102a626e37ba735
d_0_8:          .dword 0xe38a7251c18227c0, 0x3a362435f876b93b
d_0_9:          .dword 0x64140d7fdd75fb2b, 0x2779f46e17f1a1ef
d_0_10:         .dword 0x7c5a13d24ae5ab63, 0xc427d39a0d294bd1
d_0_11:         .dword 0x3d9596f9d9bbce7b, 0x042e6a66a1708a9e
d_0_12:         .dword 0xbf193ffbc65acacb, 0x8c8d518534642b3c
d_0_13:         .dword 0x3f20782625fa0610, 0xa04f8092ae76d8ce
d_0_14:         .dword 0xa5553fc8bc5d8b84, 0x6111ac932d98e36c
d_0_15:         .dword 0x36850c78108c725b, 0x5ae525a1d1ba0528
d_0_16:         .dword 0x53cac6bdaaa9b632, 0x15e1e35117e818a1
d_0_17:         .dword 0xe7fb7f365875587a, 0x9e92a5979efc33cc
d_0_18:         .dword 0x182aaa488c0bac38, 0x98670dad063c63f1
d_0_19:         .dword 0xb1e67e15ab98d1b0, 0x846f87531eb579df
d_0_20:         .dword 0x61e0ecec3d7bf7ae, 0xb31741c08c758286
d_0_21:         .dword 0x47de3dae454af9dc, 0xee32310267f066cb
d_0_22:         .dword 0x16b4a43783e98e14, 0x17050fd3b5e01b68
d_0_23:         .dword 0x07acf2f5149a6d6d, 0x9b835ca5cbb81a9a
d_0_24:         .dword 0xfc84b6c9ff1f4578, 0x91c54e5f99f77a2e
d_0_25:         .dword 0x67b9651119133df4, 0x54fd1dca2f486c22
d_0_26:         .dword 0xc1e07d2025b1a04b, 0xc8e8009d37f6d4ca
d_0_27:         .dword 0xce0df593cd919074, 0x4142ec97134d007f
                .dword 0x915d76ec057f5aae, 0xd7cfb5f2c21b4e06
                .dword 0xb38c945ba3bd419d, 0x3b89d2d63d1d5a57
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xfbd0fdb54be8c72d, 0x43f9dd667833af99
                .dword 0x952bf11cc123f566, 0xae07730de4019330
d_1_0:          .dword 0x763d7765c99125ec, 0xd90de368985b9939
d_1_1:          .dword 0x617c87241a931c5a, 0xa05e2af38c8d8f7a
d_1_2:          .dword 0xa2fecc511f6db341, 0xc8db1fe41ee6244b
d_1_3:          .dword 0xf64059684d554cf2, 0x96a7527f49edf407
d_1_4:          .dword 0x11a44481f22a63fe, 0x8d97deaea51bb2aa
d_1_5:          .dword 0xb4ae1456454e8017, 0xed97d4edaa49abc2
d_1_6:          .dword 0xd2924346adf395f7, 0x7099d1ee5052f8bb
d_1_7:          .dword 0x4e6a19a3c1921d85, 0x06e8863eaa73880b
d_1_8:          .dword 0xdd851c08dc716201, 0x3cdbdfbd8697e474
d_1_9:          .dword 0xddb9c0a15aff4fef, 0xcc9f6454814a5b33
d_1_10:         .dword 0x4a3cb607aed8296f, 0xfe75722b6fefaa90
d_1_11:         .dword 0xf2972885d1ddb8da, 0x796be7ef96e7d04a
d_1_12:         .dword 0xfb2c0b2f1dd4b4c7, 0x70abc0badbd3f276
d_1_13:         .dword 0xd1253607b43df0f5, 0xb837258df04da036
d_1_14:         .dword 0xbc0eb0cfd6211387, 0x8b212b5cdd0f9a74
d_1_15:         .dword 0x37535c1a9be7fd8c, 0x6f0bbca03b62e595
d_1_16:         .dword 0x8cc98e1573b981a0, 0xf1a057fbec02d96a
d_1_17:         .dword 0x085638e55fff69c4, 0xb09d99f8dde6a24a
d_1_18:         .dword 0x353348e12e79e2e0, 0x624d0f1d55e53f7c
d_1_19:         .dword 0xa062ec8f527dfd71, 0xed1abc2c1906ac0e
d_1_20:         .dword 0x8fc46a872ccc1c72, 0x34396c17e2c73385
d_1_21:         .dword 0xce35e0dd3ef6eacb, 0x4f7989add0cfe4ce
d_1_22:         .dword 0xe1e0af1e1536852b, 0xc22c0fa62769f4e3
d_1_23:         .dword 0x57ceb428b846d08a, 0x52f666ed8423cf75
d_1_24:         .dword 0x1b5eb0dda5d20f8d, 0x6c2bd30be669f110
d_1_25:         .dword 0x3a1b6aef9e8d48c1, 0x1deb81baac81ae0b
d_1_26:         .dword 0xc41c7a2c942a7e7d, 0xe0f92ea6e5bde1f1
d_1_27:         .dword 0x83be3618b2c213d3, 0x982e70b1017b3948
                .dword 0x269a9607cc3a5d21, 0xbaafbd87d002dd44
                .dword 0xb65b38570ef7b6fe, 0xa4eb9bec71be389b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3507cbe55f22523b, 0x96273f1c69663a22
                .dword 0x4be65f511f07eaa2, 0x9069a5690a615f7c
d_2_0:          .dword 0x3757302fde79c2c3, 0xfb88a63426a34264
d_2_1:          .dword 0x2fa7066f98625646, 0x682f29929ada775e
d_2_2:          .dword 0x28474d91331fece5, 0x2b7520abd1af0a2d
d_2_3:          .dword 0x3940254b80be6285, 0x481b989eacbe8917
d_2_4:          .dword 0xc5113952c2b2a1cd, 0x74ca7db56139b447
d_2_5:          .dword 0xf30f4559ed25f2ab, 0x47fbb2c2f2863314
d_2_6:          .dword 0xf574afc2217759df, 0xa0dd127c47977cb3
d_2_7:          .dword 0xbe4c9bac56d7e639, 0x4dd1a30563f079e9
d_2_8:          .dword 0x880702fdec2bf82c, 0x988edf9edc9288eb
d_2_9:          .dword 0xc675eb7d2b5d4488, 0x9bad05ce6973eea9
d_2_10:         .dword 0x713723d0f94d2911, 0x52f47754de5a0dc1
d_2_11:         .dword 0x40c89643c9200f95, 0x2ba4925c0c2f9f3a
d_2_12:         .dword 0xe6006fa41dbf2ba4, 0x5475240c2286609a
d_2_13:         .dword 0x584a0c31177e33cc, 0x766f3d308ca4b049
d_2_14:         .dword 0x9d67837d09122e58, 0x95ade3ca74d46453
d_2_15:         .dword 0x02c68aa4ffd61dfa, 0xe554676b5588bcb5
d_2_16:         .dword 0xfb6fd5d7ceb0080e, 0x2c6798d48de4b3c2
d_2_17:         .dword 0x914c45ed71439bbc, 0xb7cdc8d2076bf12d
d_2_18:         .dword 0x36c33d5e65013e7a, 0xdc9f4890f0711204
d_2_19:         .dword 0xbe6b611e45864b54, 0x89f11dc9e4fee523
d_2_20:         .dword 0xa620de7209261e68, 0xf4093894299d5d76
d_2_21:         .dword 0x65949507b6c56255, 0x04dc00a436eb1fbe
d_2_22:         .dword 0x74b11c4492ec9260, 0x10d79c820ace655c
d_2_23:         .dword 0x75fb692410a3967b, 0xc21f92b4a9611a61
d_2_24:         .dword 0x3d94294ac37cc3ec, 0x6cf517fb397ccb74
d_2_25:         .dword 0xd6a2819e15fb166a, 0x82ab6cf71ee59df5
d_2_26:         .dword 0x7767cda79265d0be, 0x69621cbcf58dca14
d_2_27:         .dword 0x0143effb1ea9060d, 0x02a0cd7f35704576
                .dword 0x3c5a8a2f0addc1e6, 0xc6db71e9b66e6654
                .dword 0xf57eb3142a642f4e, 0xb5d7659a652f3673
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x9c02814ee4ffae0f, 0xf9aa005a36a8d049
                .dword 0xeb526ea135c64c95, 0x2ad821a5e69ea0e6
d_3_0:          .dword 0x21b05cb867ee9d6b, 0xf3349589d1ab354e
d_3_1:          .dword 0x650bd0b074a1bcf7, 0x1e426e6f9ebaf7dc
d_3_2:          .dword 0x4fd9513e815e17da, 0x789bd9603b086837
d_3_3:          .dword 0xc2a51c81ef59a969, 0x8024d0a64eb89182
d_3_4:          .dword 0xe3b31ed870b2c1f5, 0x05be5909e38ce5c1
d_3_5:          .dword 0x0ec674efb5cf1ed5, 0x6f862176d3c827f8
d_3_6:          .dword 0x1dddf8cf8832c554, 0x4cb1bde1e5762d8d
d_3_7:          .dword 0x01fc47d56012682e, 0x8a75af2454762b2d
d_3_8:          .dword 0xaa7280572e2fb3b5, 0x2d811928d39a7ffe
d_3_9:          .dword 0x5dee9c6094aea798, 0x48fa4356a98df309
d_3_10:         .dword 0x4638800070e6330f, 0xe98cca1250674e4b
d_3_11:         .dword 0x0362c275524cbc70, 0xd7160990c67fd911
d_3_12:         .dword 0x437c13396512cf2b, 0x1b7f9593fbf0c578
d_3_13:         .dword 0xf73e70c395e72471, 0xdad38704dcde8133
d_3_14:         .dword 0xe6dc8fa4fd45a221, 0x7153f4d158d0077e
d_3_15:         .dword 0x7ab8303eff5230f4, 0x4a1f6c37ed485a25
d_3_16:         .dword 0xae1f046ee0605578, 0x33fcdbb0e6ad37e0
d_3_17:         .dword 0x01f85a82677534f8, 0x333f21cad03e8994
d_3_18:         .dword 0xfdce4734d640c8fc, 0xfd60ae6ad3e9443a
d_3_19:         .dword 0xce0b353140082a11, 0xef12e9e0b4cc10e0
d_3_20:         .dword 0x8ca627174ccf80ae, 0x08084bc8c13574bc
d_3_21:         .dword 0x290a6a4f7578e5ec, 0xc5992b98084350e8
d_3_22:         .dword 0x21f788aaa1384871, 0xa312f5bcccfbfc26
d_3_23:         .dword 0xa1879814afb83f90, 0x38f2c2b94eca85d2
d_3_24:         .dword 0xfba4e203855f1e72, 0x773330cab2d00a78
d_3_25:         .dword 0x6fe6d630602f4fd3, 0xc19fbfb27d76b0de
d_3_26:         .dword 0x4b6bb8b65728d2b2, 0x4465218e8c24af5a
d_3_27:         .dword 0x6ec3edd00bbc251a, 0xc210a151aa121989
                .dword 0x27697b30542a7cef, 0xf30bfa462d3a642d
                .dword 0xf8f488e36a3066a6, 0x3e8fa4a89d7f5206
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xc5feb00019893848, 0x620e99c2b8b751e3
                .dword 0xdd69f4b37ea23019, 0xf8e51bf1096e302f
d_4_0:          .dword 0x914c927989fa6b85, 0xef9580ad084468ac
d_4_1:          .dword 0x223e68d9b5b3ca26, 0x52ee373a1f40d675
d_4_2:          .dword 0xb155404b91cd81b8, 0x69b41c95a09d5f93
d_4_3:          .dword 0x06468355397c438b, 0x410782bbdefc211e
d_4_4:          .dword 0x7dde86d27ed4d6d0, 0x23ffdbea34057562
d_4_5:          .dword 0xe6cea92c438c348e, 0x3f1e09b30e150f12
d_4_6:          .dword 0xe4c81bcf9cedd001, 0x0cdc0f0ceb0a095e
d_4_7:          .dword 0x318aff43552d5214, 0xd1f29e5fde4e3beb
d_4_8:          .dword 0x610a494b316f0285, 0xec727cbe6ed71646
d_4_9:          .dword 0x3d2aa2ff69959adb, 0x393bf2d7b27b7017
d_4_10:         .dword 0x37844c2dcf337d82, 0x8e286b04be006c49
d_4_11:         .dword 0xd5c90d84d3ba1268, 0x1601c300c500f3c5
d_4_12:         .dword 0xf26a23062d820b14, 0x3f071b663d5e1063
d_4_13:         .dword 0x738f32c8eab5f7e2, 0x50be1adebdb40021
d_4_14:         .dword 0x88c14afae8916ec7, 0xdd60984f35d4ad1b
d_4_15:         .dword 0x697b2b3bb15db2a8, 0xf6880a7de49eded0
d_4_16:         .dword 0x1cf15f919d26115d, 0xe9c63530f9a91b92
d_4_17:         .dword 0xee2d73dbfe1a5168, 0x9329bf8b63cb54eb
d_4_18:         .dword 0x24b37a849d22c298, 0x63a6ea198b7a47cd
d_4_19:         .dword 0x47dae838c7740226, 0x5f403bee19b89b68
d_4_20:         .dword 0xbaeb418fbab0bb39, 0x9b17cdf4fab475c1
d_4_21:         .dword 0xa1290625e550780c, 0xf2771d9038c0da9b
d_4_22:         .dword 0xc8f3586a6fe5407d, 0x2762159407e7f880
d_4_23:         .dword 0x80994d41a2153c09, 0xaa5d91062c4320b0
d_4_24:         .dword 0x2e05e5b835809f41, 0x76eff314624d97c8
d_4_25:         .dword 0xce57d448ecab736d, 0xf9205691972cd4db
d_4_26:         .dword 0xefcf2df32b976126, 0x18c90cb045753deb
d_4_27:         .dword 0x81ed239fcbc563cd, 0xa6e7c2048c7f1d7f
                .dword 0xac5e794964e22da9, 0x8ddbd4cd9bc1b00b
                .dword 0x2e8c57681ac2f6a8, 0x4ec8d1fa22f2bc3c
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x96f967f55b3de0c8, 0x1623e0ea837dcf9b
                .dword 0x6f3e0cfe270a651d, 0xd6872ebe6a7bcc5d
d_5_0:          .dword 0x3f123854ce57f3c1, 0xb30962834a31ca0d
d_5_1:          .dword 0xe51d6ae7808324e5, 0x060b7a95c5ecb2d9
d_5_2:          .dword 0x9f13fcca1cea079f, 0x022a01da98e40d3b
d_5_3:          .dword 0xbca4fde8e62613e1, 0x84d66a5e34b52364
d_5_4:          .dword 0xe03d46dd9b912408, 0x6194b93a3c2e2236
d_5_5:          .dword 0x7558047b9a97a6c7, 0xda326f7a26c01d68
d_5_6:          .dword 0xae2fa863c876ada7, 0x66efb1eda22d54bc
d_5_7:          .dword 0xc7cc5683fe47a6f9, 0x5af0b0a09f260a65
d_5_8:          .dword 0x1138d00da91be5cd, 0xb3e563b8bee10364
d_5_9:          .dword 0x344ee00ab35f03f5, 0xf86f7afb72fec7bd
d_5_10:         .dword 0x8f42d8e4e8800947, 0x75b9922ac6e91389
d_5_11:         .dword 0xbc9bef23218030fe, 0x85d4d607b2f28cdb
d_5_12:         .dword 0xed86dbb1e6a8d51f, 0x100fd03824bcf9e2
d_5_13:         .dword 0x68a86cd796f0ab99, 0x27f2b588b5d17545
d_5_14:         .dword 0x27e4d1eb8043be5a, 0xbf6e0f36a29e15d8
d_5_15:         .dword 0xe79774b3810ca3ce, 0x9e3b5363d55de153
d_5_16:         .dword 0x7034359683549274, 0x8cfb4e4cffbaa973
d_5_17:         .dword 0xc5e1b794e59955b7, 0xeea0d0667bdbab2e
d_5_18:         .dword 0x4cee318c16a3378c, 0x3cbd8d1c0d39514f
d_5_19:         .dword 0xee39093123efd71c, 0xa8d9223ce6f52d4b
d_5_20:         .dword 0xc7ca53a3b374d908, 0x5360337197e158bb
d_5_21:         .dword 0x126e42c7526082c9, 0xc11f01357a30a449
d_5_22:         .dword 0xe27618ca02201306, 0x8912dbef84481b39
d_5_23:         .dword 0x47dfbd2c9ac707d7, 0x430a38245072853e
d_5_24:         .dword 0xb26963a5f8446205, 0x09d21f7902ea215e
d_5_25:         .dword 0x64b4479adaf6ec14, 0x38c7cf16d7617412
d_5_26:         .dword 0x25fe1265cfebe057, 0x8162655be52f54dd
d_5_27:         .dword 0x06852b09497ee97a, 0xe088c4383efe0bab
                .dword 0xc5ae5faeca387542, 0x62b0c4736d316a6d
                .dword 0xd2c66d044c0ab487, 0xecbf866d9b3e8526
         /* Random data */
_end_data5:
              
 
