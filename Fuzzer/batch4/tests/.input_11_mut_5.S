# Assembly file template for fuzzing

#*********************************************************************
# test_template.S
#---------------------------------------------------------------------

#include "riscv_test.h"
#include "test_macros.h"
#include "fuzz_test.h"

#define TESTEND gp

RVTEST_RV64UF

// RVTEST_CODE_BEGIN
        .section .text.init;
        .align  6;
        .weak stvec_handler;
        .weak mtvec_handler;
        .global _start;
_start:
        /* reset vector */
INIT_XREGS
        j reset_vector;
        .align;
init_freg:
INIT_FREGS
        ret
        .align;
trap_stvec:
        clear_sie;
_fuzz_suffix:
_s0:    auipc x11, 870195                         ;
_s1:    andi x17, x16, 619                        ;
_s2:    jal x17, _s3                                      ;
_s3:    la x12, d_1_25                            ;
        addi x12, x12, -16                        ;
        amoxor.d x6, x27, (x12)                   ;
_s4:;
        /* Fuzz trap */
        /**/
_end_suffix:
        ecall
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
reset_vector:
        csrwi mstatus, 0;
        RISCV_MULTICORE_DISABLE;
        DELEGATE_NO_TRAPS;
        INIT_SATP;
        INIT_PMP;
        la t0, trap_mtvec;
        csrw mtvec, t0;
        li TESTEND, 0;
        CHECK_XLEN;
        la t0, trap_stvec;
        csrw stvec, t0;
        li t0, (1 << CAUSE_LOAD_PAGE_FAULT) | \
                (1 << CAUSE_STORE_PAGE_FAULT) | \
                (1 << CAUSE_FETCH_PAGE_FAULT) | \
                (1 << CAUSE_MISALIGNED_FETCH) | \
                (1 << CAUSE_USER_ECALL) | \
                (1 << CAUSE_BREAKPOINT);
        csrs medeleg, t0;
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0)) | \
                (MSTATUS_MPP & (MSTATUS_MPP >> 1));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
_fuzz_prefix:
_p0:    xor x10, x10, x10                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 10                         ;
        add x10, x10, x13                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 10                         ;
        add x10, x10, x10                         ;
        csrrs x14, fflags, x10                    ;
_p1:    xor x13, x13, x13                         ;
        csrrc x11, sscratch, x13                  ;
_p2:    csrrci x11, sepc, 29                      ;
_p3:;
        /* Fuzz prefix */
        /**/
_end_prefix:
        la t0, main;
        csrw mepc, t0;
        addi t0, zero, 0;
        mret;
  1:
      
      .align 6;

main:
_fuzz_main:
_l0:    la x26, d_1_9                             ;
        sh x9, -24(x26)                           ;
_l1:    mul x11, x11, x11                         ;
_l2:    la x29, d_5_27                            ;
        addi x29, x29, 0                          ;
        amoswap.w x11, x26, (x29)                 ;
_l3:    srliw x9, x3, 25                          ;
_l4:    la x29, d_0_22                            ;
        lw x23, 24(x29)                           ;
_l5:    fle.s x17, f2, f24                        ;
_l6:    la x21, d_5_25                            ;
        sh x25, -24(x21)                          ;
_l7:    xor x9, x9, x9                            ;
        addi x30, zero, 3                         ;
        slli x30, x30, 13                         ;
        add x9, x9, x30                           ;
        addi x16, zero, 3                         ;
        slli x16, x16, 18                         ;
        add x9, x9, x16                           ;
        addi x14, zero, 3                         ;
        slli x14, x14, 28                         ;
        add x9, x9, x14                           ;
        csrrw x7, sstatus, x9                     ;
_l8:    remw x3, x15, x0                          ;
_l9:    auipc x17, 268478                         ;
_l10:   sllw x5, x17, x30                         ;
_l11:   la x24, d_5_7                             ;
        addi x24, x24, -24                        ;
        amoxor.d x6, x5, (x24)                    ;
_l12:   la x30, d_5_13                            ;
        addi x30, x30, -24                        ;
        amoand.w x21, x8, (x30)                   ;
_l13:   la x9, d_0_8                              ;
        ld x3, 24(x9)                             ;
_l14:   la x25, d_2_12                            ;
        addi x25, x25, -0                         ;
        lr.d x21, (x25)                           ;
_l15:   fsgnjx.s f10, f21, f7                     ;
_l16:   csrrsi x3, stval, 4                       ;
_l17:   la x1, d_2_20                             ;
        addi x1, x1, 0                            ;
        lui x9, 0xffe00                           ;
        xor x1, x1, x9                            ;
        amomax.d x15, x9, (x1)                    ;
_l18:   la x17, d_1_7                             ;
        lwu x8, -0(x17)                           ;
_l19:   andi x13, x25, -341                       ;
_l20:   fmax.s f19, f24, f31                      ;
_l21:   ebreak                                    ;
_l22:   fdiv.s f24, f26, f1, rmm                  ;
_l23:   remuw x29, x5, x20                        ;
_l24:   fsgnjn.s f5, f28, f10                     ;
_l25:   la x21, d_5_24                            ;
        lui x4, 0xffe00                           ;
        xor x21, x21, x4                          ;
        lb x30, -0(x21)                           ;
_l26:   jal x9, _l52                                      ;
_l27:   xori x8, x3, -0                           ;
_l28:   fsqrt.s f21, f31, rdn                     ;
_l29:   srlw x27, x22, x3                         ;
_l30:   fsgnjn.s f17, f13, f8                     ;
_l31:   fnmadd.s f2, f1, f27, f5, rup             ;
_l32:   ebreak                                    ;
_l33:   fsqrt.s f11, f12, rne                     ;
_l34:   fcvt.s.lu f21, x21, rtz                   ;
_l35:   bge x17, x16, _l82                                ;
_l36:   fdiv.s f9, f7, f11, rtz                   ;
_l37:   la x10, _l89                                      ;
        csrrw zero, uepc, x10                     ;
        uret                                      ;
_l38:   la x10, d_0_1                             ;
        lbu x19, -4(x10)                          ;
_l39:   ebreak                                    ;
_l40:   bltu x7, x22, _l79                                ;
_l41:   sllw x21, x11, x25                        ;
_l42:   slti x26, x5, 114                         ;
_l43:   fence                                     ;
_l44:   la x6, d_5_18                             ;
        addi x6, x6, -16                          ;
        lui x26, 0xffe00                          ;
        xor x6, x6, x26                           ;
        amoadd.d x5, x26, (x6)                    ;
_l45:   rem x17, x5, x11                          ;
_l46:   la x13, _l66                                      ;
        jalr x7, 0(x13)                           ;
_l47:   la x19, d_1_8                             ;
        lhu x21, -10(x19)                         ;
_l48:   la x2, d_3_5                              ;
        addi x2, x2, -0                           ;
        amoand.d x4, x15, (x2)                    ;
_l49:   fmax.s f16, f25, f17                      ;
_l50:   la x4, d_1_10                             ;
        addi x4, x4, 24                           ;
        amomin.d x17, x2, (x4)                    ;
_l51:   fcvt.lu.s x16, f19, dyn                   ;
_l52:   srli x0, x11, 0                           ;
_l53:   la x12, d_3_19                            ;
        addi x12, x12, 16                         ;
        amomin.d x30, x12, (x12)                  ;
_l54:   la x29, d_3_1                             ;
        addi x29, x29, 16                         ;
        lui x11, 0xffe00                          ;
        xor x29, x29, x11                         ;
        amomax.d x10, x11, (x29)                  ;
_l55:   la x9, d_3_20                             ;
        lwu x27, -12(x9)                          ;
_l56:   ecall                                     ;
_l57:   sllw x28, x24, x1                         ;
_l58:   la x8, d_2_25                             ;
        sw x8, 4(x8)                              ;
_l59:   la x20, d_3_4                             ;
        addi x20, x20, 28                         ;
        lui x26, 0xffe00                          ;
        xor x20, x20, x26                         ;
        amominu.w x28, x26, (x20)                 ;
_l60:   addw x5, x20, x3                          ;
_l61:   srliw x9, x29, 0                          ;
_l62:   addw x22, x16, x24                        ;
_l63:   fnmadd.s f7, f24, f8, f3, rdn             ;
_l64:   la x11, d_4_11                            ;
        ld x29, 0(x11)                            ;
_l65:   la x4, d_3_0                              ;
        addi x4, x4, -12                          ;
        amoadd.w x8, x6, (x4)                     ;
_l66:   la x29, _l70                                      ;
        lhu x10, 22(x29)                          ;
_l67:   fdiv.s f25, f19, f3, rdn                  ;
_l68:   la x20, d_5_27                            ;
        addi x20, x20, -0                         ;
        amoor.d x3, x24, (x20)                    ;
_l69:   srlw x10, x15, x19                        ;
_l70:   fcvt.l.s x16, f27, rmm                    ;
_l71:   bne x24, x18, _l85                                ;
_l72:   fsub.s f27, f18, f1, dyn                  ;
_l73:   fmin.s f19, f27, f11                      ;
_l74:   la x20, d_0_21                            ;
        addi x20, x20, 0                          ;
        sc.w x3, x16, (x20)                       ;
_l75:   fsgnjx.s f16, f11, f18                    ;
_l76:   fcvt.s.wu f10, x28, rne                   ;
_l77:   la x23, _l100                                     ;
        csrrw zero, uepc, x23                     ;
        uret                                      ;
_l78:   la x13, _l95                                      ;
        csrrw zero, mepc, x13                     ;
        mret                                      ;
_l79:   la x23, d_3_19                            ;
        addi x23, x23, 8                          ;
        amoand.d x27, x15, (x23)                  ;
_l80:   la x2, d_5_18                             ;
        addi x2, x2, 28                           ;
        sc.w x12, x2, (x2)                        ;
_l81:   fcvt.wu.s x18, f19, rdn                   ;
_l82:   fsqrt.s f10, f17, rmm                     ;
_l83:   fle.s x14, f28, f9                        ;
_l84:   srli x29, x0, 43                          ;
_l85:   fcvt.l.s x14, f20, rmm                    ;
_l86:   addi x22, x21, 4                          ;
_l87:   la x11, d_3_23                            ;
        lwu x1, -8(x11)                           ;
_l88:   fcvt.lu.s x26, f8, rmm                    ;
_l89:   la x29, _l94                                      ;
        jalr x12, 0(x29)                          ;
_l90:   fmax.s f15, f21, f2                       ;
_l91:   la x13, d_4_6                             ;
        addi x13, x13, 12                         ;
        amoor.w x1, x20, (x13)                    ;
_l92:   la x13, d_4_13                            ;
        addi x13, x13, 16                         ;
        lui x8, 0xffe00                           ;
        xor x13, x13, x8                          ;
        lr.w x18, (x13)                           ;
_l93:   fmadd.s f31, f3, f10, f8, rne             ;
_l94:   flt.s x8, f0, f10                         ;
_l95:   slliw x18, x25, 0                         ;
_l96:   mulhsu x26, x6, x9                        ;
_l97:   csrrsi x21, pmpaddr5, 6                   ;
_l98:   la x15, d_4_2                             ;
        addi x15, x15, 8                          ;
        amomin.d x5, x18, (x15)                   ;
_l99:   bgeu x15, x26, _l100                              ;
_l100:  fsgnj.s f24, f5, f1                       ;
_l101:;
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

PT_BASES

    .section .data.random0;
    .align  8;

_random_data0:
                .dword 0xff1651882db8f9ac, 0xba615b4f63ff168a
                .dword 0x9b0e1322c4521cde, 0x01390c1c75de34f3
d_0_0:          .dword 0x43f5da7fad3b8c8f, 0x8d60ae6ea2138ccc
d_0_1:          .dword 0x1e3b87b166c4f536, 0x035cc702cd5f3947
d_0_2:          .dword 0xc3de43d4bf0c8b72, 0xdf4b159a2d5852f4
d_0_3:          .dword 0xd049306bc38944c6, 0x91bd829fe495cd45
d_0_4:          .dword 0x30c8e6704af27a20, 0x71f481a3098fe221
d_0_5:          .dword 0x09e9b9350c6543d2, 0x263073e0f9bba96c
d_0_6:          .dword 0xd0c9db320f85b6b8, 0xe17a7b876eb58ee0
d_0_7:          .dword 0x6479cccb1eb7199f, 0xb1eb0ebf5fd4fed2
d_0_8:          .dword 0x9fbb11122b1a3297, 0xe83851def6c671b5
d_0_9:          .dword 0x81203513c24a0ee4, 0x188bdd08b18f8860
d_0_10:         .dword 0x08485b5bed579907, 0xe82f651b765dda63
d_0_11:         .dword 0xcbe560e1b433fd33, 0xb7d5072427684599
d_0_12:         .dword 0xc6c8c9954badb5f7, 0xf8b4cfb4b2376ef7
d_0_13:         .dword 0x94aca9b1f4a1bb99, 0x39115fc4a4848229
d_0_14:         .dword 0x3dff7d76ec02ddd9, 0xffd78496bacbcd54
d_0_15:         .dword 0x79d55c1618e1381a, 0x404e657beb396b27
d_0_16:         .dword 0x0d903e8fdfc8b833, 0x32bbc6d84599d4de
d_0_17:         .dword 0x9c407c7e257e23ec, 0x5a5ed5d1c772e1cb
d_0_18:         .dword 0x3fef13a5e126d390, 0x01c271d749f2e543
d_0_19:         .dword 0x89aec135fbbdc7c5, 0xeb1be7b0d79a0a01
d_0_20:         .dword 0x2853ce0e15682bc7, 0x05eb2e6248904437
d_0_21:         .dword 0x9f66eca0208f7bfc, 0x158fbbff2efba035
d_0_22:         .dword 0x2dfe8f5d138b1e08, 0xb0d7d0cdd5ee333e
d_0_23:         .dword 0x4f7ebb269550f743, 0xbe725c011747258d
d_0_24:         .dword 0x75a05354a3d1de8e, 0x90af4a4400fe142e
d_0_25:         .dword 0x83322134509104e3, 0x2a43a60c4c3e7566
d_0_26:         .dword 0xc41b546946f041ae, 0x25a7ae467c8066b1
d_0_27:         .dword 0x1fa60d2db46664fb, 0xac6b2699bf27616d
                .dword 0x7ae4b0300cf9a925, 0xf97c31e42b7598ed
                .dword 0x80e69955a5dfb001, 0xa27e79d8a54342e2
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x5ed76922fa1e3445, 0xafd1f679b58813bf
                .dword 0x7e100375ca363584, 0x9d07d3aebbd38d8d
d_1_0:          .dword 0xa010fe808fb4c555, 0x339ee153d959a2bd
d_1_1:          .dword 0xfeaad28dba69d5da, 0xa81dd6339ac977a1
d_1_2:          .dword 0xa53f2b0a5428e30d, 0x4426a85466b32aa7
d_1_3:          .dword 0x68a4d5df3c4e6fe6, 0x719fc732b177a93f
d_1_4:          .dword 0x23a3303bca3b5a1c, 0x4f2d295333b33eae
d_1_5:          .dword 0xb598a2be3ba79ea8, 0x87c6b64e469f06ff
d_1_6:          .dword 0x2733e64dd040f748, 0x34e18025863d8c3f
d_1_7:          .dword 0xc3b333c0a4769632, 0x72f5888df581c0bb
d_1_8:          .dword 0xdffb435e0a920bd3, 0x3a11ebdcf89f8407
d_1_9:          .dword 0xbfd203ed49e548eb, 0xcc11ccf74d063795
d_1_10:         .dword 0x23604fc93ed2fe16, 0x76856bf1db91dd32
d_1_11:         .dword 0x86081b38d2e4c38c, 0xb5a4ff4388c4320a
d_1_12:         .dword 0x91062f3244ba7207, 0x0e58a6d02ea0e017
d_1_13:         .dword 0x18c540c1812a86af, 0x8037e39eba095b67
d_1_14:         .dword 0x2708f67f63af2a7c, 0xfc4a55c81caa0c5f
d_1_15:         .dword 0xf5bd3b9584800d85, 0x8a8d91187941fdc1
d_1_16:         .dword 0xa15e1b3937f45635, 0xdda50edabe8001eb
d_1_17:         .dword 0x6e3d39f4fc8403a9, 0x5c7bf8ef2b31d384
d_1_18:         .dword 0xf80e77fc2fc645ee, 0x088bee7a63748043
d_1_19:         .dword 0x4bc7738fcb34c728, 0xabfc61dba7ad8cfe
d_1_20:         .dword 0xf9451c2ec3bf3d06, 0x626bc9dbe3a147ee
d_1_21:         .dword 0x31e0584172c0c393, 0xf87af84dd4a8ba2d
d_1_22:         .dword 0x93c924e487099d21, 0x699ef4c11b857dee
d_1_23:         .dword 0x6db7a2cd32598d5d, 0xa645ba3182a864b2
d_1_24:         .dword 0xf9952b39a1d672fc, 0xf874239005d5b12c
d_1_25:         .dword 0x0ed8b632f4e0a7f4, 0x42b2e43a20e6bc59
d_1_26:         .dword 0xa2579729a693842a, 0x1f930db58a073d12
d_1_27:         .dword 0x2f4d90059aaf3855, 0x207ab99d056b358f
                .dword 0xb1535a462d4d1510, 0xa012fd3a3b2f5c15
                .dword 0xd7f9752765d0facf, 0x7f699f847718eaad
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x25f6da699d2b9951, 0x9eb2534d57721e26
                .dword 0xd8104aa686206b6e, 0x2241c236649c2850
d_2_0:          .dword 0x633042bf07bf8331, 0x7edee3aee97ee2f1
d_2_1:          .dword 0x19e46d0c0f1d45c3, 0xa2e6c6f3e4db4107
d_2_2:          .dword 0x83a555794828fd04, 0x87dc97fdd494444d
d_2_3:          .dword 0x7503f421f5904243, 0x9fe1fb78ec046d57
d_2_4:          .dword 0x17a133320d222246, 0xbeb5fc3ed6fc9f20
d_2_5:          .dword 0x7000b8609189e26c, 0x4deb0864109502ed
d_2_6:          .dword 0x78a5d09f55a163b6, 0x33d2a3850f91db77
d_2_7:          .dword 0x1710ea9b29809f99, 0x0b2b32a9df684b69
d_2_8:          .dword 0xd2b79238bd75968d, 0x5b036eaf994ed9c5
d_2_9:          .dword 0xea05827e941a68d0, 0x67b14d8159695b53
d_2_10:         .dword 0xb1553694f4c765dd, 0x1161c2f43ea77e86
d_2_11:         .dword 0x84befb7bc54478d6, 0x8821d48787afa9e9
d_2_12:         .dword 0x6b23a1a3249f5d47, 0xf6c5856f041d8b83
d_2_13:         .dword 0x1eb981cf3138c91e, 0x7dea2c786c424a4e
d_2_14:         .dword 0xa3fbd21b471c31be, 0x33c2620a5878fdd1
d_2_15:         .dword 0x9ca07750d92195ac, 0x82c19a933b312783
d_2_16:         .dword 0x5e826a00e693c6c2, 0xe98af1693cb85883
d_2_17:         .dword 0xacc1ac0598004e2c, 0x11281b87d19d9aec
d_2_18:         .dword 0xcf0c271b384761d9, 0x8a0513034099649d
d_2_19:         .dword 0x7f476a7b0eb645f2, 0x1ff808a804b34c9b
d_2_20:         .dword 0x8b263fcab6f7209e, 0xb85007015799daf6
d_2_21:         .dword 0xd7991d6867284d75, 0x8fa948ed2a78db60
d_2_22:         .dword 0x7230cfd8f0aa323d, 0x91df91466f4a73f4
d_2_23:         .dword 0xf39ab86c2ea222e0, 0x33214ee677b62f36
d_2_24:         .dword 0x08122d086a413c3b, 0xde95f5281e337139
d_2_25:         .dword 0xbda75d0d5d29fdaa, 0x48a0312166562ab9
d_2_26:         .dword 0xf9a80a3a1aff7fe8, 0x20ea68970a9051a4
d_2_27:         .dword 0x4e8a379c0f05f6e5, 0x56bc095be135f369
                .dword 0xa3ac0060a3a3e9cb, 0xcb6f77b51a9a98a8
                .dword 0xb31e03a61ef187b4, 0xd71ecdd310f72556
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe5729f385485c72e, 0x4484c005bbea86c0
                .dword 0x37cd426e080789be, 0x9dcfe629cd256c92
d_3_0:          .dword 0xfb0f245e31a47195, 0x8e519f4055ca32fe
d_3_1:          .dword 0x1517dd837ac15bbc, 0x75927f2d5f0d1657
d_3_2:          .dword 0x126262ef7c18a796, 0xf38bb61909eecd7b
d_3_3:          .dword 0xaea0a3ba2506166b, 0xd2428ea0098dd098
d_3_4:          .dword 0x91d1949f792480b3, 0x6ba0442dbd70efdb
d_3_5:          .dword 0x97b726a80174cb34, 0x76f0011d1982da33
d_3_6:          .dword 0x4b4807a8b5b85149, 0x766b69f921051012
d_3_7:          .dword 0xabad2d701a73650c, 0x925bd751c47422ae
d_3_8:          .dword 0xa7f630f68bb75ba7, 0xcfa8c1e1bb950550
d_3_9:          .dword 0x751f8f7c1af52e41, 0x5fe203a1010c82ac
d_3_10:         .dword 0x43c71b411e3683e3, 0xada62a80c4ece438
d_3_11:         .dword 0x1a5f594cc3086aaf, 0xba36f3382da1bd2a
d_3_12:         .dword 0x8ba3ffb7a74ea04f, 0x83ad6d76f9cedb57
d_3_13:         .dword 0x4799d72fba34ba11, 0x48b19b7baaabfed7
d_3_14:         .dword 0xbfce55a21a45fd01, 0x4f193efb544bd582
d_3_15:         .dword 0xf44577e4d9ce9f26, 0xf6012993791d066c
d_3_16:         .dword 0xe980a478c61aeabe, 0x18c621d89235e238
d_3_17:         .dword 0xb00ab72d59bc0762, 0xa70babb37c3c70af
d_3_18:         .dword 0x7028609aa8271b8e, 0xcf4621d606ee1dd7
d_3_19:         .dword 0xc1fbec54d92f1316, 0xad04a44e121fb8b5
d_3_20:         .dword 0x21bcb2a16497c9d7, 0xf509812894f051a4
d_3_21:         .dword 0xc3ea60e34000ebc4, 0xe9f5693e7c4f853d
d_3_22:         .dword 0x84993b9b34c03317, 0x7af923aba802ae7a
d_3_23:         .dword 0xc268604e9b9e69aa, 0xa564102d98f2a601
d_3_24:         .dword 0x06df0e83421faf98, 0x272d840d96eeb377
d_3_25:         .dword 0x69728e41aed98059, 0x609948a8f149ae1d
d_3_26:         .dword 0x940c6cd491d4d724, 0x05c3e52510e48027
d_3_27:         .dword 0x12218981c2f4eec8, 0xba60246d628e651f
                .dword 0x440de56fa18f3f80, 0x53f549b210bf5634
                .dword 0xc2a03201f7dd5dd4, 0xb230866e16f26600
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x1463c01258fbca5e, 0x367f9c31c47ee767
                .dword 0x78f5d9eb3f2f39b7, 0x6d4dccefe91e1215
d_4_0:          .dword 0xbe230de60f305447, 0x48521047f64f8bde
d_4_1:          .dword 0xee40e00633e15c5d, 0x40ae807aeffd0551
d_4_2:          .dword 0xedf7af24a66d9665, 0x2d297e2abe99929d
d_4_3:          .dword 0x20fd9a812e4f56c9, 0x8a0885429ca4bc4c
d_4_4:          .dword 0xbb6ffb0c0e3d4b6a, 0xb25583fcacad1bef
d_4_5:          .dword 0xe6f1ec056caf2659, 0x005ccafcf28334d2
d_4_6:          .dword 0x73c4eeceb9a7ce4c, 0x51304fe08e5091be
d_4_7:          .dword 0xc0bfd37429310b68, 0xfbed6e01a766de3f
d_4_8:          .dword 0xc80b3e423026ccd5, 0x02739f7f1a190fae
d_4_9:          .dword 0x620d7c558fd710f6, 0x1a194c1eaeac813f
d_4_10:         .dword 0x851693f1e38b7127, 0x52f6fcef3d49606c
d_4_11:         .dword 0x9ee2cd0b17a560db, 0x5a464753907e4586
d_4_12:         .dword 0x36a5b81b833fc81e, 0xe2fcc1ec63656274
d_4_13:         .dword 0x6617c440b6900043, 0xee430b7d71e839e3
d_4_14:         .dword 0x8a64fc04d7ef57a9, 0xd7efc21dedb4513e
d_4_15:         .dword 0x166074a1256f2f76, 0x8fc60258edaaa964
d_4_16:         .dword 0x131c96d4f821c049, 0x3a72691f8d4cd9be
d_4_17:         .dword 0x79141d7d51850d3e, 0x050f85218d078dab
d_4_18:         .dword 0x61b8bf09207af521, 0xf8ee4beb2e8c740d
d_4_19:         .dword 0xeda07c25c5af8dbb, 0x9a95e6d1ba6894c8
d_4_20:         .dword 0x8a31171b3588f8a2, 0x5d7c6cb7c49db2c7
d_4_21:         .dword 0xa7acff7a49ecad6b, 0x32dd3eb191c62ad6
d_4_22:         .dword 0x60220f49da68c11a, 0x153d830d98cfacbd
d_4_23:         .dword 0x01eb4f26cac6e7c4, 0x70dc2b245ac89717
d_4_24:         .dword 0xc1d089b8983c334e, 0xbcd0565945f8ac7b
d_4_25:         .dword 0x226b89bf1ea79307, 0xcbd80cdcabfbd4cb
d_4_26:         .dword 0xfcc3c412825201e6, 0x2c70ebd7e1f93877
d_4_27:         .dword 0x43b3e50a6e107766, 0xf045760a3c4763a4
                .dword 0x591cec220077467a, 0xcd20ddf37bbb9316
                .dword 0xbd761096866f828e, 0xe0b9ac83eaba306d
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x0fd36346af801733, 0x444806e13119b755
                .dword 0x86c90b1713159c3e, 0x5e3cde61cce351f6
d_5_0:          .dword 0x5edc05ce79923cf9, 0xe99e86ff4c80cdb5
d_5_1:          .dword 0xe39580d6f236251a, 0x2bea4f377a6e29a9
d_5_2:          .dword 0xa4c8bff15c000c43, 0x61fcf71426e03d58
d_5_3:          .dword 0x241faa346b80518d, 0x55b7a5ae801560dd
d_5_4:          .dword 0xf6120c0b03b369f7, 0x91a91387b13029b2
d_5_5:          .dword 0x5fb01f2fd310fb72, 0x90655c35f0ba860c
d_5_6:          .dword 0x78c33bc27ee2e500, 0xccf45d6c31baadc7
d_5_7:          .dword 0x220a551ffcc447a5, 0x1777f390acdd71a2
d_5_8:          .dword 0x07625f352bef800c, 0x7b488c009f436d74
d_5_9:          .dword 0xce93b5ae514e35ca, 0x71f9ecfbfc86a01d
d_5_10:         .dword 0xa11da68195adec45, 0x3e77aa5632749eaa
d_5_11:         .dword 0xa858fe9a5820744c, 0x622b3a2cf924a906
d_5_12:         .dword 0xcd78c726fc2d8feb, 0x72b7ef1a6fe4acb0
d_5_13:         .dword 0x8ac110526fee2c3e, 0xb49bb47aad355478
d_5_14:         .dword 0xa0c7ee1e1a738bbb, 0x434f1c65dbc18312
d_5_15:         .dword 0xbb6c9613a9fb102f, 0x13a25894a70e9d9f
d_5_16:         .dword 0x8dfb134805528ce5, 0x798f8a1741bdeb8c
d_5_17:         .dword 0x1c90a90d06c36807, 0xa5579e9261140637
d_5_18:         .dword 0x021e43eebe9abe1d, 0x860a8a5664dba861
d_5_19:         .dword 0x672301d50035707b, 0xe41dad0baca43044
d_5_20:         .dword 0x127161ff4d66daaa, 0xcab5944ed4352ee1
d_5_21:         .dword 0xe1ee012e6876e229, 0xcaee955b5288320a
d_5_22:         .dword 0x199b600ded00d952, 0xab2f304a142589f8
d_5_23:         .dword 0x8e32c152d644cb5b, 0x22276c681fe91caf
d_5_24:         .dword 0x44c9ba129c2814f3, 0xb5a9b25454f47c3d
d_5_25:         .dword 0x73ae3b4b2572c5b0, 0x036ebc8de7b5c15d
d_5_26:         .dword 0x9ab2fd461e14fb32, 0x1b3703fdff36109c
d_5_27:         .dword 0xc55b4ed51be6fbea, 0x6dbdb6e6fc2025f8
                .dword 0xc8f77c4c5f074f56, 0xa26fb3e14262e6e3
                .dword 0x82a0e5cc6cea7bbf, 0x6a5383d41bef3ad1
         /* Random data */
_end_data5:
              
                 
