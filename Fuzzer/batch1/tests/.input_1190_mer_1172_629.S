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
_p0:    csrrci x14, fflags, 27                    ;
_p1:    csrrci x14, pmpaddr6, 0                   ;
_p2:    csrrwi x10, sscratch, 13                  ;
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
_s0:    la x25, d_4_5                             ;
        sh x30, 6(x25)                            ;
_s1:    addiw x7, x22, 49                         ;
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
_l0:    beq x6, x24, _l82                                 ;
_l1:    div x8, x10, x18                          ;
_l2:    fmul.s f15, f15, f12, rmm                 ;
_l3:    sltiu x18, x18, 1110                      ;
_l4:    la x18, d_5_20                            ;
        addi x18, x18, 16                         ;
        amomin.d x20, x13, (x18)                  ;
_l5:    la x9, d_4_8                              ;
        addi x9, x9, -16                          ;
        amoand.d x13, x21, (x9)                   ;
_l6:    bge x20, x22, _l39                                ;
_l7:    la x23, d_1_24                            ;
        addi x23, x23, -0                         ;
        amoswap.d x2, x7, (x23)                   ;
_l8:    auipc x0, 749934                          ;
_l9:    fmv.x.w x9, f6                            ;
_l10:   la x5, d_3_3                              ;
        addi x5, x5, 0                            ;
        amomaxu.d x19, x26, (x5)                  ;
_l11:   la x1, _l96                                       ;
        lb x7, 11(x1)                             ;
_l12:   la x12, d_0_16                            ;
        sh x28, -28(x12)                          ;
_l13:   fmsub.s f12, f13, f13, f17, rtz           ;
_l14:   la x13, d_4_25                            ;
        srai x13, x13, 1                          ;
        csrrc x17, pmpaddr4, x13                  ;
_l15:   la x5, d_3_27                             ;
        addi x5, x5, 0                            ;
        amoadd.d x3, x25, (x5)                    ;
_l16:   li x3, 0                                  ;
        la x30, pt0                               ;
        addi x30, x30, 48                         ;
        sfence.vma x3, x30                        ;
_l17:   feq.s x27, f0, f1                         ;
_l18:   fcvt.l.s x17, f3, rdn                     ;
_l19:   la x1, d_3_8                              ;
        lbu x28, -22(x1)                          ;
_l20:   andi x13, x5, -38                         ;
_l21:   sllw x17, x11, x20                        ;
_l22:   la x22, d_5_22                            ;
        addi x22, x22, -28                        ;
        sc.w x23, x22, (x22)                      ;
_l23:   srai x8, x19, 63                          ;
_l24:   csrrwi x8, stval, 9                       ;
_l25:   csrrci x24, mhartid, 12                   ;
_l26:   remu x22, x8, x27                         ;
_l27:   flt.s x10, f22, f0                        ;
_l28:   divw x23, x0, x3                          ;
_l29:   la x10, d_5_4                             ;
        addi x10, x10, -16                        ;
        amominu.d x24, x12, (x10)                 ;
_l30:   la x29, _l82                                      ;
        srai x29, x29, 1                          ;
        csrrs x1, pmpaddr3, x29                   ;
_l31:   la x17, d_5_14                            ;
        sb x26, -15(x17)                          ;
_l32:   la x15, d_5_8                             ;
        addi x15, x15, -8                         ;
        amoswap.w x22, x13, (x15)                 ;
_l33:   fcvt.s.wu f4, x24, rmm                    ;
_l34:   mulw x17, x25, x28                        ;
_l35:   la x24, _l50                                      ;
        jalr x19, 0(x24)                          ;
_l36:   la x3, _l92                                       ;
        csrrw zero, mepc, x3                      ;
        mret                                      ;
_l37:   sltiu x2, x7, -0                          ;
_l38:   slli x12, x19, 59                         ;
_l39:   fmadd.s f6, f24, f12, f13, rmm            ;
_l40:   jal x9, _l88                                      ;
_l41:   la x8, d_0_9                              ;
        addi x8, x8, -0                           ;
        amoand.d x19, x1, (x8)                    ;
_l42:   la x26, d_4_9                             ;
        addi x26, x26, 28                         ;
        lui x27, 0xffe00                          ;
        xor x26, x26, x27                         ;
        amomaxu.w x4, x27, (x26)                  ;
_l43:   addi x26, x5, 1887                        ;
_l44:   la x12, d_4_25                            ;
        sb x23, -12(x12)                          ;
_l45:   fence                                     ;
_l46:   bne x2, x5, _l53                                  ;
_l47:   la x8, d_1_14                             ;
        addi x8, x8, -16                          ;
        lr.d x19, (x8)                            ;
_l48:   fmsub.s f3, f25, f8, f5, rdn              ;
_l49:   subw x1, x20, x4                          ;
_l50:   divw x1, x25, x23                         ;
_l51:   la x19, d_0_27                            ;
        ld x6, 16(x19)                            ;
_l52:   fsqrt.s f10, f10, rdn                     ;
_l53:   fclass.s x7, f20                          ;
_l54:   fmsub.s f5, f27, f27, f8, rup             ;
_l55:   slliw x0, x5, 6                           ;
_l56:   la x18, d_4_12                            ;
        lbu x6, -0(x18)                           ;
_l57:   la x7, _l71                               ;
        lwu x20, -8(x7)                           ;
_l58:   la x23, _l21                                      ;
        ld x12, 8(x23)                            ;
_l59:   feq.s x25, f17, f29                       ;
_l60:   fence                                     ;
_l61:   bne x25, x6, _l62                                 ;
_l62:   la x25, d_1_7                             ;
        addi x25, x25, 24                         ;
        lr.d x19, (x25)                           ;
_l63:   la x6, d_2_9                              ;
        addi x6, x6, -24                          ;
        amoand.d x7, x29, (x6)                    ;
_l64:   srai x29, x19, 49                         ;
_l65:   andi x18, x28, 1360                       ;
_l66:   la x6, d_0_26                             ;
        addi x6, x6, 24                           ;
        amoxor.d x7, x13, (x6)                    ;
_l67:   bge x14, x21, _l84                                ;
_l68:   fcvt.s.l f5, x21, dyn                     ;
_l69:   sllw x8, x13, x13                         ;
_l70:   la x22, d_0_17                            ;
        sh x13, -6(x22)                           ;
_l71:   la x21, d_1_13                            ;
        ld x9, 0(x21)                             ;
_l72:   fcvt.s.w f24, x2, dyn                     ;
_l73:   la x28, d_5_18                            ;
        addi x28, x28, -16                        ;
        amominu.d x7, x13, (x28)                  ;
_l74:   la x3, d_0_16                             ;
        lbu x4, -22(x3)                           ;
_l75:   fle.s x23, f20, f13                       ;
_l76:   la x16, d_3_22                            ;
        addi x16, x16, -20                        ;
        amomax.w x1, x12, (x16)                   ;
_l77:   jal x15, _l100                                     ;
_l78:   la x27, _l90                                      ;
        lwu x13, -4(x27)                          ;
_l79:   remuw x24, x7, x2                         ;
_l80:   csrrci x1, pmpcfg0, 3                     ;
_l81:   slti x2, x19, -1267                       ;
_l82:   xori x15, x18, 2047                       ;
_l83:   fmv.w.x f24, x14                          ;
_l84:   fence.i                                   ;
_l85:   li x15, 1                                 ;
        la x6, pt0                                ;
        addi x6, x6, 0                            ;
        sfence.vma x15, x6                        ;
_l86:   la x12, _l94                                      ;
        lh x14, 10(x12)                           ;
_l87:   fadd.s f28, f13, f16, rtz                 ;
_l88:   fmv.x.w x24, f24                          ;
_l89:   divw x15, x10, x1                         ;
_l90:   divw x3, x0, x9                           ;
_l91:   auipc x14, 905185                         ;
_l92:   fcvt.wu.s x16, f15, rtz                   ;
_l93:   flt.s x9, f1, f4                          ;
_l94:   la x12, d_2_12                            ;
        addi x12, x12, -0                         ;
        lui x14, 0xffe00                          ;
        xor x12, x12, x14                         ;
        amomin.d x14, x14, (x12)                  ;
_l95:   la x22, d_1_3                             ;
        lb x21, 0(x22)                            ;
_l96:   la x16, d_0_14                            ;
        lb x4, -3(x16)                            ;
_l97:   addiw x22, x9, 691                        ;
_l98:   fmul.s f24, f30, f15, rne                 ;
_l99:   ori x10, x25, -0                          ;
_l100:  csrrwi x26, pmpaddr1, 15                  ;
_l101:  addi x12, x7, 1902                        ;
_l102:  la x30, d_5_12                            ;
        srai x30, x30, 1                          ;
        csrrw x25, pmpaddr0, x30                  ;
_l103:  fadd.s f29, f9, f19, dyn                  ;
_l104:;
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
                .dword 0x0a14223d7966106a, 0x3f8e634335e23222
                .dword 0xa3093e52d8679973, 0x490a291bac74885b
d_0_0:          .dword 0x258a4bfc3c245cdc, 0xdbc75d349e228b57
d_0_1:          .dword 0xdb624f92261e05fa, 0x08c6d5fa1b128129
d_0_2:          .dword 0x9d8a0b8c83ae60b0, 0x86d78888c6326fbb
d_0_3:          .dword 0xce4599ba64ca014f, 0xca26cab61ee33fe7
d_0_4:          .dword 0x186b2af2fef845bc, 0x6e10436b61296dc3
d_0_5:          .dword 0xc111abb0257608d1, 0xe0e4ddc28ae0945d
d_0_6:          .dword 0x2709d2361bf88123, 0x373e9b6a0c68c84a
d_0_7:          .dword 0xdf498946719f5aab, 0x5ccddfa032e1fbf5
d_0_8:          .dword 0x6a851c09e3f77469, 0x752818d8cc17625c
d_0_9:          .dword 0x51a81856d7489ff6, 0xe3ebe7c021be3b7f
d_0_10:         .dword 0xb5dca1efbe4ed293, 0xae1d67c33e30bd68
d_0_11:         .dword 0xa26f8034e9dc6957, 0xd15bd639a70e0ebf
d_0_12:         .dword 0x050984240004f637, 0x65a75bf619a25d76
d_0_13:         .dword 0x1cf340bb60eddbbb, 0xcb7b3c4a4ac0bb26
d_0_14:         .dword 0xbc027625e65f441f, 0xa21b06e2208bc13d
d_0_15:         .dword 0x70723cfadf73a38b, 0x6dbfbd356023df5e
d_0_16:         .dword 0x6495c6a26368a604, 0x6d202b9cbece471d
d_0_17:         .dword 0xccd2d6ed7685fa68, 0x8cf35a59d4d4056a
d_0_18:         .dword 0x264b312e90ad2ddf, 0xc6d219021f354399
d_0_19:         .dword 0xf16b9dbb5f1e0b0e, 0x16157054c8fe283f
d_0_20:         .dword 0x3de1e78683a689bf, 0x87804e7337279e53
d_0_21:         .dword 0x3e98dfa3c1240e15, 0x48416097be34800a
d_0_22:         .dword 0x96c5b952c8648229, 0x7039a69adac77ca6
d_0_23:         .dword 0xd0f258529a715cb0, 0x7ac8898ebff58505
d_0_24:         .dword 0x1b0c1e18798c9c62, 0xb441c3c493417fc5
d_0_25:         .dword 0x0323f88d08a695dc, 0x1b66915346f527ae
d_0_26:         .dword 0xfd23e58720083b93, 0xa83e2a95917cc547
d_0_27:         .dword 0x1391bd7d97fb7380, 0xb8af3f43b5caba90
                .dword 0x8325658ccf172d35, 0xac57321644c69bdf
                .dword 0x3323b96ef24030d5, 0x62c6b6bf8442fa47
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x056572ea9002767e, 0xc9fd456bd9077bde
                .dword 0xa91e24082afd60be, 0x7685dd1347740705
d_1_0:          .dword 0x2fe61abc48241080, 0xe170c3b2406968e8
d_1_1:          .dword 0x9d7f3e3673f1ef9d, 0x36e9a6139d952765
d_1_2:          .dword 0xb36e9a841785ccf5, 0x3bc4764bba80e212
d_1_3:          .dword 0xd8a047046f2a429f, 0x87dfdcdc0822a907
d_1_4:          .dword 0x68972b1f91bdfaea, 0x6e85a0fe65dcaf1a
d_1_5:          .dword 0x112622d7ffc28893, 0x256c00ba8ec8e011
d_1_6:          .dword 0x8e163934f62269c5, 0x44b4386e6f79b64b
d_1_7:          .dword 0xa96e8561dd63dd35, 0x59af7185f7185c40
d_1_8:          .dword 0x9ce7b75be5b12a59, 0x6d645a1138b5feb7
d_1_9:          .dword 0xcef404d30d8bfe66, 0xa1fed1abd576301c
d_1_10:         .dword 0x8aa288b34608d3a6, 0x642f66c3605eb5e3
d_1_11:         .dword 0xd116a4abaf8e748f, 0xa5e6b2e4c72f31a9
d_1_12:         .dword 0x24f4448770587490, 0xb786d556f9928f7a
d_1_13:         .dword 0xc0ae8653e00ff512, 0x3fdda4cfe441f1f5
d_1_14:         .dword 0x92d78074fc246c66, 0x8c2cf5492f28766e
d_1_15:         .dword 0x2f45bd7a65db059e, 0xbfd2bbdb7fd918d9
d_1_16:         .dword 0xf360c9554b680120, 0xc2f85190af7c1c36
d_1_17:         .dword 0x2028969ee44692e7, 0x8c1ddb25288f3317
d_1_18:         .dword 0x7506fe8afe271aae, 0x82f723785c9814b6
d_1_19:         .dword 0x5d71dad4b9e931d4, 0x6b582d56adaedd60
d_1_20:         .dword 0x3078b190f903cb98, 0xf88b4046a27d4af5
d_1_21:         .dword 0x476539014e6ca822, 0xeba60fd849c9bca9
d_1_22:         .dword 0x3478fb073f46dbc8, 0xe49e9dcd9d3c52b1
d_1_23:         .dword 0xe7ce027fc138192b, 0xbe246d26e5c5a5a0
d_1_24:         .dword 0xac867d84266d317d, 0x6016afaf90a2ed54
d_1_25:         .dword 0xf7647f3e72cbc02c, 0xe38870b800454e9a
d_1_26:         .dword 0x9958573a7a84d76b, 0xc1c28a7c727a6246
d_1_27:         .dword 0x9da921b081675341, 0x8fb4d3026dd8cf98
                .dword 0xc67ca52f195d5ad1, 0xc48e45e71eb0ee95
                .dword 0xb874582834fd57f6, 0xe6f3b21070ddf573
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x995af7aeec5e1fa5, 0xbdbb95138caa7040
                .dword 0x9b69495dae9239da, 0x02667b9655667958
d_2_0:          .dword 0x813013588a80e197, 0xba22785f315c5e19
d_2_1:          .dword 0xc45aecc41e3bc6f5, 0x779460204aa92c31
d_2_2:          .dword 0x1da5c18a274cbaf5, 0x7df191f5e7aeaa7b
d_2_3:          .dword 0x497f20019450eea2, 0x120ea0f232b9be02
d_2_4:          .dword 0x5d8035fa78856275, 0xf46789fda76733d3
d_2_5:          .dword 0xd316c863b5758819, 0x44a13adc902f240a
d_2_6:          .dword 0x7ceb6dc58b972718, 0xa2efe41a2d6e0fa3
d_2_7:          .dword 0xeabd68c72f2c80af, 0xa290d8e6aa07edbb
d_2_8:          .dword 0xc59122f7ca6686db, 0xd13624156d53dd24
d_2_9:          .dword 0xe4d94912e31f36df, 0x07431f42d4be8d73
d_2_10:         .dword 0x84ceedd510ac9e0c, 0xff12d57f1480200b
d_2_11:         .dword 0x3e5066537d082026, 0x2973a372c9f4d4e2
d_2_12:         .dword 0xcc168daf0cacefb6, 0xdee89ae0a3460d41
d_2_13:         .dword 0xeb426a05922e01d4, 0x64ed61bbf4badd33
d_2_14:         .dword 0xbb22547d305884fa, 0x8b17e8b98208678d
d_2_15:         .dword 0x9dcfa05eda60a80b, 0x9df88f6e16e101ed
d_2_16:         .dword 0x2588b2f1e3cb05f9, 0xfafb0e270974a1ba
d_2_17:         .dword 0xd978294984a5a2c4, 0x0c7200e76d17a4b0
d_2_18:         .dword 0x3e4fc57523ea0e25, 0x6025744bd906cf5c
d_2_19:         .dword 0x70a6275c657045b8, 0xfb501e81de62bf40
d_2_20:         .dword 0xd566a955cd7d02c4, 0xac4c051006bd392f
d_2_21:         .dword 0x86eaad1a7314efaa, 0x99095a0bf5d7614e
d_2_22:         .dword 0xefaed1ad024175b4, 0xe18ba0b7a107ac10
d_2_23:         .dword 0xc67b099b5394e411, 0xff65bb6102e67c08
d_2_24:         .dword 0xd4eb66dc86f1d1b8, 0xc9a90aaaf993a113
d_2_25:         .dword 0x3d6c3ae652e1cd10, 0x122389d51697b844
d_2_26:         .dword 0x52ada874a643a290, 0xc1bd400c78baf04e
d_2_27:         .dword 0x31a9e3abe504c148, 0xa8a3e2feae08730f
                .dword 0x8b4451c0f475b2a0, 0x8a823eda6f3af853
                .dword 0xfb33458ada61f2c1, 0xdcb487ea19b1a9cb
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x4271b47a7e0cdb8a, 0x443b2db4bdb0c0ca
                .dword 0x2158260c6cc70fa3, 0x9c4c1aeef267ef41
d_3_0:          .dword 0x35a803ca0428685e, 0xc8d0ff6b0b2b559f
d_3_1:          .dword 0xcace7f4c06efe81c, 0x4f9bebd56f4a129f
d_3_2:          .dword 0x0a473d536f736e94, 0x113db60b05d26fb6
d_3_3:          .dword 0xa81e8e6c804c382a, 0xdbb5708007dfbb11
d_3_4:          .dword 0xdd790f364e030cc1, 0xc18b2c8819260d97
d_3_5:          .dword 0xc85e38d268895ee5, 0x0588a9c4efc07b24
d_3_6:          .dword 0x09eb87cd1e2d2102, 0xcfa1ce3295980463
d_3_7:          .dword 0x5ae5d78e9155a7c4, 0x8fe9e8d230502cea
d_3_8:          .dword 0xb8ad0f1010eca668, 0x7a1a640371fdd71c
d_3_9:          .dword 0x9485016a0be42b1e, 0x8329e4519a0307d3
d_3_10:         .dword 0xea5c6d9efc1fdc12, 0x35d84e2f35fe7d57
d_3_11:         .dword 0x502ca43ec3893fba, 0x97b5ec504830ea74
d_3_12:         .dword 0xef1c0116b975c1f6, 0xbd4699e286624b86
d_3_13:         .dword 0xd511cd3b4e7cb62b, 0xce45f32d82be9dc1
d_3_14:         .dword 0xb0b5a219e576e0b1, 0x232b335a9f05c039
d_3_15:         .dword 0x9f27e73e3b51e410, 0x4a570ddb14def4b7
d_3_16:         .dword 0x2d08fb05ac36b5af, 0x7ac00f6f005b57ce
d_3_17:         .dword 0xea4f962bdbd70f6e, 0x29fb2ddcde868b1b
d_3_18:         .dword 0x4b9437227a797e22, 0x43c867e69bc77abb
d_3_19:         .dword 0xc3859e9a611bc32d, 0xa9b7344fd46fe0cb
d_3_20:         .dword 0xe7a7338efa836143, 0xc52dac702297105f
d_3_21:         .dword 0x2b5459081d1ef452, 0x188ac069ef626b9c
d_3_22:         .dword 0xe7e8b13a7cbc4256, 0xdb9dcd9fd9adc372
d_3_23:         .dword 0x6693c6c88d559268, 0xcb0aab363737a9e3
d_3_24:         .dword 0xde6a7dc8a04da004, 0x800ded858a8d287c
d_3_25:         .dword 0xfe1b9d08838ec045, 0xa5dfdcf42f22ce2d
d_3_26:         .dword 0xdcebc613808770fa, 0xb541e07b758401f4
d_3_27:         .dword 0xca3eff08ff7a507c, 0x0dc8928dc47423de
                .dword 0xa16e382ec6a958ad, 0x700471e8d5a898e3
                .dword 0x96264ad3172fe527, 0xf13b43f742c43a3a
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x4248b3d0503b1437, 0x53fe4b104ca57ef9
                .dword 0xa6564a84f4e073c9, 0x46310498adfe75f5
d_4_0:          .dword 0x7a4f3001add9ad89, 0x2de8cc49ebe72791
d_4_1:          .dword 0xfe575566d705c54b, 0x2d12aa90e977d37a
d_4_2:          .dword 0xa4e9090f318664fa, 0xa2cbe0c37212eeee
d_4_3:          .dword 0x7bd944014b581803, 0xe70629fadd4a98c1
d_4_4:          .dword 0x723c990953e1c9be, 0x9d4c9d0d94d59e61
d_4_5:          .dword 0xb4ed7d880bc3e5ce, 0xc423614eefb02ac7
d_4_6:          .dword 0x638e9a9ff85eaa96, 0x3e1916172ac34e11
d_4_7:          .dword 0xaab510091af0c17a, 0x53c9e406196c7c80
d_4_8:          .dword 0x2a353c63e88992f8, 0x3728b0b4fb7a45f6
d_4_9:          .dword 0xf033bfb6b7095c45, 0xe2516125a1d5352d
d_4_10:         .dword 0x888f32ecbbd84f11, 0x32a810ac0bb3a4c7
d_4_11:         .dword 0xbbf7ba4ab848a447, 0x3d90bbd5d9ee072a
d_4_12:         .dword 0x3caf059ba31778e5, 0x93a1907526ee91a0
d_4_13:         .dword 0x08835b4f4a2b7de1, 0xa82546d413af9e61
d_4_14:         .dword 0x50856ff7c09f03db, 0x1b6f957caa0627c1
d_4_15:         .dword 0xec7bb05f7060b205, 0x0e9f07204b2a73ae
d_4_16:         .dword 0x84cf1390821b1c65, 0x8c1121f9852383dd
d_4_17:         .dword 0x23ae4f182ed31903, 0xdf7e35e579c83c60
d_4_18:         .dword 0x9fbfc9c94f0e132a, 0x452675c62e59d07f
d_4_19:         .dword 0x1f8d18a8d49535d5, 0x8220d136f5b9e867
d_4_20:         .dword 0x55c09e85f666af4c, 0x25d1290d77e7f0d2
d_4_21:         .dword 0x6c27a2ad23481996, 0x17adbad8e311ea02
d_4_22:         .dword 0xf60e0e8ea8859295, 0x129e2c6475504fb8
d_4_23:         .dword 0xa98a0321a8b770ca, 0x9dbe5b6b817ecb1b
d_4_24:         .dword 0xa10b24d8e58e5d21, 0xe54098a4098aef2d
d_4_25:         .dword 0x288631c61bde7b58, 0x3b165dbb329b9345
d_4_26:         .dword 0x21a328476c886336, 0xe0614bd8fcc66329
d_4_27:         .dword 0xd829fe847b3a2a12, 0x48cbae9bc2bb39ba
                .dword 0xe080b7d07b28396d, 0x334e391b3f5e1387
                .dword 0x6e2e11e3b47a05de, 0xf66801c15d8c936c
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x8abc9779d74d9e0d, 0x7a01679784b94001
                .dword 0x761eeff5013ea2a5, 0x2f1c76c37ab77039
d_5_0:          .dword 0x8966c96fea70e487, 0x5a07c62250a340eb
d_5_1:          .dword 0x02a215f8d8a9fa1f, 0x4b5cc1e2434113ac
d_5_2:          .dword 0xa4ee12f04712bdca, 0xf224bab631f05c9e
d_5_3:          .dword 0x9bee973c30c2af77, 0x4dce6bda35ae70ac
d_5_4:          .dword 0x4dc5f0c69226e9e1, 0x550f70a7cca88cdd
d_5_5:          .dword 0xe168dbec5c7e1bcf, 0x9da72134a59ee406
d_5_6:          .dword 0x5821523d5d6751b4, 0x41698ba4e85eee72
d_5_7:          .dword 0x89e5aaf7439cb7dd, 0xbb46ce626f7be7a6
d_5_8:          .dword 0xa37f32a1e0234c2b, 0x112b7f540cd50e78
d_5_9:          .dword 0x4bf1b1130e6104c5, 0xf2ab3e4970b2f352
d_5_10:         .dword 0xcb40f181ea41097d, 0x275a7a6db0764d9f
d_5_11:         .dword 0x1c5bfa4ff9e2d62f, 0xa664c02dc9d2d979
d_5_12:         .dword 0xe6088046723c7a8b, 0x690d5262bb67969e
d_5_13:         .dword 0x2ff06775a233ed28, 0x6d56611074987ff4
d_5_14:         .dword 0x2be88e1fe186a8a9, 0xe80e4e5502b9cbcd
d_5_15:         .dword 0x69996e2e70670373, 0x2e46e9fd439db7d6
d_5_16:         .dword 0x3bf8aa8eb6b632b5, 0xc36771b0bf49556f
d_5_17:         .dword 0x47e753ae475fe3ab, 0x2d975cedb32782a2
d_5_18:         .dword 0xdc221bf4370d8532, 0x29805014a0b2046d
d_5_19:         .dword 0x54bdbd8983a7b546, 0xa08e552368411ddd
d_5_20:         .dword 0xa07b42af01e377bd, 0x598be9f3b2bf58f6
d_5_21:         .dword 0xffb875cd5c0968ad, 0x811df2491077a945
d_5_22:         .dword 0x2d9bff1915e70d73, 0xcca737c984940384
d_5_23:         .dword 0x80524a8b53fce4a0, 0x9d02e40cd1d70fa4
d_5_24:         .dword 0xfea1292851735e47, 0xf82eddbf666dd04e
d_5_25:         .dword 0x28508b7be32e30af, 0xbdb889e0585d9068
d_5_26:         .dword 0xb6d05676ac8c189e, 0xf920ecfc5047521c
d_5_27:         .dword 0x53af0b45c18daeb6, 0xe697689f8f89fed0
                .dword 0x35b6b274680f22b3, 0x04aad8a7acbd70f1
                .dword 0x47d8e62c57ca1cd0, 0x1203082b5047b979
         /* Random data */
_end_data5:
              
 
