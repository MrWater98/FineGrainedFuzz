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
_s0:    sraw x24, x18, x11                        ;
_s1:    mulh x22, x9, x6                          ;
_s2:    slli x9, x18, 44                          ;
_s3:    ebreak                                    ;
_s4:    la x24, d_5_0                             ;
        ld x11, 0(x24)                            ;
_s5:;
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
_p0:    la x11, d_2_10                            ;
        srai x11, x11, 1                          ;
        csrrw x10, pmpaddr7, x11                  ;
_p1:;
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
_l0:    fmv.w.x f10, x27                          ;
_l1:    la x9, d_3_18                             ;
        addi x9, x9, -24                          ;
        sc.w x21, x22, (x9)                       ;
_l2:    la x14, d_1_4                             ;
        addi x14, x14, 8                          ;
        amomaxu.d x6, x10, (x14)                  ;
_l3:    ebreak                                    ;
_l4:    la x15, d_5_21                            ;
        addi x15, x15, 0                          ;
        amoswap.w x18, x20, (x15)                 ;
_l5:    fmul.s f20, f14, f6, dyn                  ;
_l6:    remu x6, x29, x14                         ;
_l7:    fcvt.wu.s x29, f0, dyn                    ;
_l8:    feq.s x14, f5, f14                        ;
_l9:    fnmsub.s f26, f19, f29, f11, rup          ;
_l10:   xor x20, x20, x20                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 6                          ;
        add x20, x20, x20                         ;
        addi x17, zero, 1                         ;
        slli x17, x17, 28                         ;
        add x20, x20, x17                         ;
        addi x18, zero, 3                         ;
        slli x18, x18, 8                          ;
        add x20, x20, x18                         ;
        csrrs x20, sepc, x20                      ;
_l11:   la x15, d_3_10                            ;
        ld x21, 16(x15)                           ;
_l12:   fsqrt.s f22, f27, dyn                     ;
_l13:   la x2, d_2_27                             ;
        lwu x25, -28(x2)                          ;
_l14:   la x13, d_1_15                            ;
        fsw f13, -12(x13)                         ;
_l15:   la x14, _l86                              ;
        flw f16, 24(x14)                          ;
_l16:   slti x14, x25, -232                       ;
_l17:   la x26, d_0_12                            ;
        addi x26, x26, 16                         ;
        amomaxu.d x15, x26, (x26)                 ;
_l18:   fence.i                                   ;
_l19:   addi x20, x13, -2047                      ;
_l20:   la x20, _l42                                      ;
        jalr x30, 0(x20)                          ;
_l21:   fcvt.lu.s x5, f19, rmm                    ;
_l22:   fmv.x.w x1, f1                            ;
_l23:   la x21, d_5_6                             ;
        addi x21, x21, 0                          ;
        amoand.d x14, x21, (x21)                  ;
_l24:   rem x23, x11, x10                         ;
_l25:   fmul.s f25, f7, f7, rdn                   ;
_l26:   fclass.s x10, f10                         ;
_l27:   la x22, d_4_26                            ;
        addi x22, x22, 28                         ;
        amomax.w x27, x14, (x22)                  ;
_l28:   la x7, d_1_13                             ;
        addi x7, x7, -8                           ;
        amominu.d x22, x25, (x7)                  ;
_l29:   ecall                                     ;
_l30:   mul x9, x4, x0                            ;
_l31:   rem x20, x9, x25                          ;
_l32:   addiw x10, x17, 0                         ;
_l33:   fmv.x.w x15, f13                          ;
_l34:   addw x13, x23, x30                        ;
_l35:   sllw x20, x15, x9                         ;
_l36:   srliw x17, x0, 18                         ;
_l37:   csrrsi x14, mstatus, 30                   ;
_l38:   la x14, d_0_0                             ;
        addi x14, x14, -4                         ;
        amoswap.w x28, x26, (x14)                 ;
_l39:   la x24, d_2_19                            ;
        addi x24, x24, -0                         ;
        amoor.d x21, x27, (x24)                   ;
_l40:   feq.s x2, f9, f25                         ;
_l41:   la x26, _l99                                      ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l42:   fmsub.s f29, f9, f18, f20, rmm            ;
_l43:   fnmsub.s f29, f28, f0, f30, dyn           ;
_l44:   srai x0, x13, 35                          ;
_l45:   fnmadd.s f14, f31, f12, f20, rmm          ;
_l46:   la x28, _l73                              ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l47:   la x22, d_1_2                             ;
        lhu x23, 16(x22)                          ;
_l48:   ecall                                     ;
_l49:   fcvt.s.l f25, x25, rup                    ;
_l50:   addiw x27, x21, -18                       ;
_l51:   csrrsi x14, fflags, 25                    ;
_l52:   slti x3, x12, 1027                        ;
_l53:   la x17, d_2_9                             ;
        sb x1, 13(x17)                            ;
_l54:   srli x20, x28, 22                         ;
_l55:   la x7, d_5_11                             ;
        addi x7, x7, 8                            ;
        amoand.d x8, x7, (x7)                     ;
_l56:   la x29, d_4_6                             ;
        addi x29, x29, -8                         ;
        amomin.d x13, x23, (x29)                  ;
_l57:   la x12, d_0_3                             ;
        flw f30, -28(x12)                         ;
_l58:   mulhsu x3, x21, x30                       ;
_l59:   la x28, d_3_3                             ;
        addi x28, x28, 8                          ;
        amoswap.d x5, x23, (x28)                  ;
_l60:   fcvt.l.s x17, f6, rtz                     ;
_l61:   la x19, d_0_17                            ;
        sh x17, 8(x19)                            ;
_l62:   fsgnj.s f18, f21, f28                     ;
_l63:   feq.s x12, f19, f28                       ;
_l64:   la x25, d_4_5                             ;
        ld x8, 16(x25)                            ;
_l65:   fcvt.s.l f4, x28, rne                     ;
_l66:   srai x23, x20, 0                          ;
_l67:   fmadd.s f16, f16, f8, f21, rdn            ;
_l68:   la x8, d_1_15                             ;
        lui x24, 0xffe00                          ;
        xor x8, x8, x24                           ;
        lwu x24, -4(x8)                           ;
_l69:   la x1, d_5_4                              ;
        addi x1, x1, -28                          ;
        amoor.w x3, x10, (x1)                     ;
_l70:   fsgnjn.s f17, f24, f25                    ;
_l71:   blt x11, x4, _l77                                 ;
_l72:   div x1, x5, x16                           ;
_l73:   la x13, d_2_16                            ;
        sb x8, 0(x13)                             ;
_l74:   addw x11, x0, x22                         ;
_l75:   la x14, d_0_5                             ;
        lh x23, -0(x14)                           ;
_l76:   li x15, 0                                 ;
        la x29, pt0                               ;
        addi x29, x29, 16                         ;
        sfence.vma x15, x29                       ;
_l77:   la x6, d_3_18                             ;
        addi x6, x6, 0                            ;
        amoswap.d x13, x23, (x6)                  ;
_l78:   fmv.x.w x3, f14                           ;
_l79:   la x30, d_5_23                            ;
        addi x30, x30, 0                          ;
        amoand.w x21, x19, (x30)                  ;
_l80:   la x8, d_4_13                             ;
        lhu x5, -2(x8)                            ;
_l81:   fsgnj.s f10, f10, f9                      ;
_l82:   fsqrt.s f14, f11, rup                     ;
_l83:   div x13, x6, x22                          ;
_l84:   fcvt.wu.s x5, f21, rdn                    ;
_l85:   flt.s x19, f4, f5                         ;
_l86:   la x8, d_3_25                             ;
        addi x8, x8, -0                           ;
        sc.w x3, x7, (x8)                         ;
_l87:   blt x30, x17, _l98                                ;
_l88:   la x3, d_2_0                              ;
        lb x15, 19(x3)                            ;
_l89:   sraw x30, x2, x28                         ;
_l90:   fmin.s f16, f6, f0                        ;
_l91:   slliw x4, x29, 25                         ;
_l92:   fcvt.s.lu f23, x11, rtz                   ;
_l93:   la x16, d_2_8                             ;
        addi x16, x16, -16                        ;
        amominu.d x27, x14, (x16)                 ;
_l94:   la x22, d_5_8                             ;
        addi x22, x22, 28                         ;
        amoswap.w x21, x15, (x22)                 ;
_l95:   mulhu x13, x7, x9                         ;
_l96:   fcvt.l.s x9, f7, rtz                      ;
_l97:   auipc x15, 15                             ;
_l98:   la x25, d_5_8                             ;
        sh x30, -22(x25)                          ;
_l99:   fcvt.l.s x6, f8, rup                      ;
_l100:  la x1, d_1_18                             ;
        lui x7, 0xffe00                           ;
        xor x1, x1, x7                            ;
        lh x28, -16(x1)                           ;
_l101:  fclass.s x13, f9                          ;
_l102:  bge x13, x27, _l103                                ;
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
                .dword 0x5e9c7d37f7107073, 0x0ff8896252ce403f
                .dword 0x72cc84bc41c8ab4c, 0x9ac5e1424ebd82af
d_0_0:          .dword 0x296b64efe03f7071, 0x14d98b5c07c36138
d_0_1:          .dword 0xf20b898a6f432397, 0x1ff327b658fae7c5
d_0_2:          .dword 0xff083a9deb067bf9, 0x1207dddb0412894c
d_0_3:          .dword 0xc7f7c44550f862e5, 0xaf8097c999c4c5a2
d_0_4:          .dword 0xb6247b7ca73d6228, 0xffc66af2b4d3a44a
d_0_5:          .dword 0x665e8e422d261e68, 0xc3a28b536d9b12b4
d_0_6:          .dword 0xff4b3fdea2b072c1, 0x9714ab713b4155e1
d_0_7:          .dword 0x8f870055cf76e4c0, 0x3c4a7b273deb92ef
d_0_8:          .dword 0xcca04034945fb6da, 0x5d4b00b85d193f38
d_0_9:          .dword 0x65cea21a18d0e407, 0x3213a894ed82812f
d_0_10:         .dword 0x9eda9bbff9a5bc2e, 0xcd6571cb468f3ade
d_0_11:         .dword 0x0316049012583d9c, 0x0dd17725351bc8f2
d_0_12:         .dword 0x51d36d08ce6f1a8c, 0x72efde2708249218
d_0_13:         .dword 0x0b2bce4389a7c9a6, 0x1dabdcfe33190128
d_0_14:         .dword 0x27b8a87d3a0a05ec, 0x52546b057c7cf306
d_0_15:         .dword 0x6ce8a40d68c21f97, 0x7d1eef3c543530dd
d_0_16:         .dword 0x3856c01b3d14480b, 0x1d1808c80e427992
d_0_17:         .dword 0x250a9f33a8173775, 0xfc9df88482ad3560
d_0_18:         .dword 0x1e37cd23b71109fe, 0xed7d91d0cac168b5
d_0_19:         .dword 0x2dbb3f88aed37889, 0x16b2dbe5405600b3
d_0_20:         .dword 0x91080e296b75a17e, 0x781a022c8a7f010a
d_0_21:         .dword 0x024b24bc2586c73d, 0xa8d54b563d538fdf
d_0_22:         .dword 0x597a5798c6895bc9, 0xe609ca2a7d126f70
d_0_23:         .dword 0xb1b8ba5ff11bf425, 0x4ba977ad871d8d78
d_0_24:         .dword 0x9093f495c621a5ea, 0x9ca9331b0c908dbe
d_0_25:         .dword 0xe6f1c62b7c16c618, 0x640f4c7893d13cd8
d_0_26:         .dword 0xcd343c7246c4db43, 0xec7408e9c8efb09a
d_0_27:         .dword 0x8afcd495f3a29c0b, 0x69a96a7dab8c19b6
                .dword 0x06ea27fcba055b9d, 0x240fb8b23c874205
                .dword 0x84a0dcbc635d5824, 0xc28d5a4849515a2a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x320529ef62303721, 0xa568ee0419c91f48
                .dword 0x5c4d5d0a0c9c669c, 0x2dbe7daffbfaa79f
d_1_0:          .dword 0xa90dd201e2a44485, 0x8f0ed89d39a33e16
d_1_1:          .dword 0xe86a54757a7212c9, 0xad6d3718180e8e8e
d_1_2:          .dword 0xacf8bfe1749780fa, 0x2f9a178a3cc4d6e1
d_1_3:          .dword 0x21cf8d4e8bf2a662, 0x9cda3901eea00946
d_1_4:          .dword 0x7dff21a7f617047f, 0x5213df923b79a138
d_1_5:          .dword 0x76f046bdd60e78cf, 0xf1905102e76a9209
d_1_6:          .dword 0x2f3ed756f8747469, 0x28a721ffe265de8f
d_1_7:          .dword 0xd18f9a980d5da4f6, 0xc25b83ac35d3069a
d_1_8:          .dword 0x4b360cb30078506c, 0xd55f42c598ee11fe
d_1_9:          .dword 0xa6bc7ed4af1c500f, 0x910ab83736c310a8
d_1_10:         .dword 0xd892137135a8f512, 0x9cfb9f0dd88285f0
d_1_11:         .dword 0x7a71bbf370fd932b, 0x6a49f412ee14ebc0
d_1_12:         .dword 0xca8125d96282c537, 0x64cd6e3c7234a7fe
d_1_13:         .dword 0xc417661d2a0b0472, 0xad9f318dbe38086c
d_1_14:         .dword 0xd946c5dec0476879, 0xbbc8251b61d160ae
d_1_15:         .dword 0xc315775c1ec0d5f1, 0xf6b5ef85433cee03
d_1_16:         .dword 0xabfc6330229c9843, 0x146cfed41fa618d7
d_1_17:         .dword 0x4de2fea15fac843b, 0xd8256d4663ab2b98
d_1_18:         .dword 0xf3f8bcc3c04562d9, 0xc71755bd4c4209cc
d_1_19:         .dword 0x93762ff902b21689, 0x3d9df8b6f463071c
d_1_20:         .dword 0xa7614be392ec04d2, 0x017154b0e2bcf475
d_1_21:         .dword 0x2e2f438c3b0b2935, 0xdf8af7605bab7730
d_1_22:         .dword 0xfa7dfd0308cc39b0, 0xe0ebfc67dad8cd3b
d_1_23:         .dword 0x404c7a0c407f9854, 0xf97bbdef5c2e4e64
d_1_24:         .dword 0xe058029f61d9aac4, 0x28edfc3c91957f7b
d_1_25:         .dword 0x28c34772a95e95b0, 0x4d4c180034888ba1
d_1_26:         .dword 0x297beedc369a6d46, 0x5975000c7d652b5b
d_1_27:         .dword 0x4e5160970c8c831a, 0xe3ffcf0bc0ae35d4
                .dword 0x77f6ba9bead7c7e1, 0xef1c4897be3462ce
                .dword 0x3567499b548346c7, 0xb7eb4be64a3a2081
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x031b9944a1bf488d, 0xa123e7a46f140630
                .dword 0x8c42717cf14bdb96, 0x3109dc93d881e38b
d_2_0:          .dword 0x06fc35bc1ec5a78a, 0xfc2d758f555836ef
d_2_1:          .dword 0xaa6ae5786151e743, 0x36bb355606343186
d_2_2:          .dword 0x351f70584c6f304b, 0x1ad2e1d4853b0c52
d_2_3:          .dword 0x9c6d893ff983c047, 0x360a283253dfc3f5
d_2_4:          .dword 0x318d0b7ee006852f, 0x8db0c57b221ebd9f
d_2_5:          .dword 0x1945164a33b543ab, 0xbc1610c3186308a4
d_2_6:          .dword 0x2e1623146bde85c7, 0xc0a6106cd7ebc036
d_2_7:          .dword 0x16844f13e8df8a21, 0xeecd80da9f01b1d7
d_2_8:          .dword 0x3deff00085070ff0, 0xfa0507eb65f55ade
d_2_9:          .dword 0xfc8d6da4a7578765, 0x5735dad93c50ebdb
d_2_10:         .dword 0xea4808fc009c6bb4, 0xcfe569c36c3b1384
d_2_11:         .dword 0x9fb14cfa83c0d5fb, 0xab27efd471a37985
d_2_12:         .dword 0xac8e6976613c81f8, 0x2993c0fcc2d2a4f9
d_2_13:         .dword 0x9ea6de16c8a393e2, 0x60d5c6afca8743e3
d_2_14:         .dword 0xbf85d8601b105cf4, 0x155f1a6d4be0b2e7
d_2_15:         .dword 0xa9ae4835f0f2b00c, 0x520ad5ac23f21af4
d_2_16:         .dword 0x2ae15c73ca5d3cfb, 0x2166152363537dfd
d_2_17:         .dword 0x5a6463a6bd236c36, 0x2301708215f9fc4c
d_2_18:         .dword 0x0f186014b405b275, 0x3c56ee544ae6a435
d_2_19:         .dword 0x093f42a9ff40c119, 0xf02eb6ee366f5328
d_2_20:         .dword 0x02aa7ed2f02e3048, 0x91cdc2615c64bc0e
d_2_21:         .dword 0xe2d95f390cc53b59, 0xc280f66a10ba6d1e
d_2_22:         .dword 0xede8445afa40f412, 0xbe30c1e51ebf35cf
d_2_23:         .dword 0x9368ebda135af5cc, 0x66088c771d26932e
d_2_24:         .dword 0x8b10d10da6861bd9, 0x87585ca25521119d
d_2_25:         .dword 0x040876ebd40c46a8, 0xf1892f7821a7e0c7
d_2_26:         .dword 0x833a0dde4fa70522, 0xdda57756483f38d1
d_2_27:         .dword 0xab12605ca6ebd56e, 0xba9ff2935a448689
                .dword 0x9968ced2899f0590, 0xbefd34df93fa4de1
                .dword 0xd29dff3f1cca0fdb, 0xe0cf650d235b9d22
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc294a1bba71469ee, 0x3d9232c5da60fc96
                .dword 0x272f7471c4debc1c, 0x0b3a166ad283f19b
d_3_0:          .dword 0x71ce35d9333d6207, 0xda15404630004e79
d_3_1:          .dword 0xcf0197ca79ef3539, 0x8d9457e4bef62ab5
d_3_2:          .dword 0x2cd74ba8390bce23, 0xcc57e88f929d0222
d_3_3:          .dword 0x88e1217d449d3f85, 0x6420f39bc4b7389d
d_3_4:          .dword 0x72ab1114b9388c61, 0xc74fc3b99ac4cb25
d_3_5:          .dword 0x6b90692a933c249a, 0x9e1241f59ea3d86a
d_3_6:          .dword 0x3392f426b9c77c2e, 0x38be6ca110e46a4d
d_3_7:          .dword 0x4a94e8fd97e110b6, 0xb4634a229b077b84
d_3_8:          .dword 0x4b230829e8446c23, 0xe6bb247961774914
d_3_9:          .dword 0x00fa74ec38770cfa, 0xdf791d12ec64e30c
d_3_10:         .dword 0xb993c5f608c1fa9b, 0x7715aba325e46d83
d_3_11:         .dword 0xe13bdb967abc0688, 0x885fcd8b80488515
d_3_12:         .dword 0x67f98c0d0a895ee4, 0x9351b68d6f447a83
d_3_13:         .dword 0x5e4ac25bc949ddd6, 0xf10483fafd7e6aa3
d_3_14:         .dword 0xef553cefc7eff1a2, 0xda07d97c9ea25d52
d_3_15:         .dword 0xe2c45e3599108543, 0x3b0dad3a6a4f688f
d_3_16:         .dword 0x1ae81ce8d71c625b, 0x589576552cca7990
d_3_17:         .dword 0x444fbd9c78ea3d31, 0x19957e60fae6e01e
d_3_18:         .dword 0x9724025f44a0e836, 0xd888fa4acce170e7
d_3_19:         .dword 0x907ca042a415de5c, 0x95e43cc714a39b3e
d_3_20:         .dword 0x69ca661bae3cd3c9, 0xfd1b93722e4ebf60
d_3_21:         .dword 0x3089d770b9241279, 0x727747a1d6f494d8
d_3_22:         .dword 0xb927261a42fbe0dd, 0x2eedcb720c6ee2a2
d_3_23:         .dword 0x6aedfacd21132b67, 0xa3d3bbd6199daa9d
d_3_24:         .dword 0x02701a818a7a68fb, 0x91d686d7b69b7d6b
d_3_25:         .dword 0x8d1129453b7a78f6, 0x226a8a932473daae
d_3_26:         .dword 0x1ef9a2bf9b135e33, 0x4f6e7ad69934d11c
d_3_27:         .dword 0x79ef345140918e71, 0xa2f6b3c35c0ccf1c
                .dword 0x66c3fa5c352da4f6, 0x320d72f2c427422e
                .dword 0xd41cd0a971cd1058, 0xad22c528052e85c4
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x28c1c3c823b93f5c, 0x447cd954f078ca0a
                .dword 0xe5080db8947795f3, 0x2dd9eeaee29197d5
d_4_0:          .dword 0xbeba38be9236ecf5, 0xea7d572b258fd77f
d_4_1:          .dword 0xc68c8f7387416905, 0xb1f67abcb8be5899
d_4_2:          .dword 0x239cb1d9e0a96a90, 0xf9ef1fde468e9585
d_4_3:          .dword 0xa1e79a2de7484a60, 0xf8cc65345c1da504
d_4_4:          .dword 0xc8983d84a7e1268d, 0x9e5c94f44d1823ef
d_4_5:          .dword 0xb672a4f67b23750a, 0x2c3e595bac8db328
d_4_6:          .dword 0x7961af56b3ce29bb, 0xa7d6e528b0324e60
d_4_7:          .dword 0x6e3647763f45c940, 0xc78f6d915d8ce9bd
d_4_8:          .dword 0xc0e25c50862a0b19, 0xc599d2b5e5e65fe6
d_4_9:          .dword 0xefc75b9354bc54cc, 0x75a33dc715756f84
d_4_10:         .dword 0x069450fdf70baa24, 0x3f05147fdb08724c
d_4_11:         .dword 0xe3744456066489bf, 0xe6300a6738066e79
d_4_12:         .dword 0x2badf2049ef092e5, 0x15554d44837f81a1
d_4_13:         .dword 0xaf07ac60188aa77b, 0x048f6dc2d4cc817c
d_4_14:         .dword 0xc020f4b5c43192ea, 0x2dab71f6a58f0ca9
d_4_15:         .dword 0x949350ceca74d458, 0x521d965b20fc4811
d_4_16:         .dword 0xa9aeb0e771ecfedb, 0x2920fab87bb20992
d_4_17:         .dword 0x42ee638fda24c9f5, 0x4367ea95ce9f7ca9
d_4_18:         .dword 0x900638c5487a8baf, 0x81d39d5cb4254b08
d_4_19:         .dword 0x5cea00ae809d9f16, 0x31e5888820059819
d_4_20:         .dword 0x305398a719a9b752, 0x400fb8cf29a2a2e7
d_4_21:         .dword 0x80c90d3898129438, 0xc3a36755ef0ae6c9
d_4_22:         .dword 0x1fbf9c4ac1625200, 0x144832f9b4d0e00d
d_4_23:         .dword 0x54ebc39f93dc25d6, 0x7709aea41fb1d57a
d_4_24:         .dword 0x28405dd11d74e561, 0x78cb58fd17dd90f7
d_4_25:         .dword 0xfe9166c0183657a6, 0x94143be8b33c4e4f
d_4_26:         .dword 0x07002736c6cc275f, 0xb742d7c774350d17
d_4_27:         .dword 0xb65959d7bebd6837, 0x86ea0abf8ec81d7c
                .dword 0xe66fc157dde3a0ac, 0x62c7aa30932ba182
                .dword 0x81f0efe285eef876, 0x54757cd8a93bec9f
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xbb045e7e881b8d95, 0x2f85ec62f6dbd02d
                .dword 0xce61b489d2a2a8b3, 0x81d9bfe1253a4ff1
d_5_0:          .dword 0x9c3b87e842cf9135, 0x3f8b735a0d040735
d_5_1:          .dword 0x457f18ada07eff86, 0x2eb0ade9eebd575a
d_5_2:          .dword 0x3f9860d1d0a73893, 0x0a983536351524a4
d_5_3:          .dword 0x386eaed2afc40949, 0xcd2af0c093e7460f
d_5_4:          .dword 0xf69e7ebd299ff49f, 0x332374931f96135f
d_5_5:          .dword 0xd0b6054376f9fd36, 0xc2493df79ea36ffa
d_5_6:          .dword 0x110bb70b5d07f730, 0x3b13d0844a049773
d_5_7:          .dword 0x3a775b70d3d89b82, 0xce474c8104f572d4
d_5_8:          .dword 0xb3c0ab0ca1508479, 0x74f7cb9c500e9680
d_5_9:          .dword 0x94a5fa09fc1a64af, 0x6efd25f584f2d5f2
d_5_10:         .dword 0x78aaf8831a1c9eaa, 0x19899335db9f5c1d
d_5_11:         .dword 0x3aa348470cfbebcd, 0x6f36cc2144af1343
d_5_12:         .dword 0x9a9887e4f8b0757b, 0x4b9e78cd298a7665
d_5_13:         .dword 0xc2a15c731cfbf464, 0x4eca72748179976c
d_5_14:         .dword 0x81f039538144e365, 0xe519c9e85897ca54
d_5_15:         .dword 0x8ea6fcfc3a50ed8a, 0xfb8c1151bbe7a77b
d_5_16:         .dword 0xcde190fa98e252cb, 0x90a00f15f9ba843c
d_5_17:         .dword 0x21cdacc854e75a4c, 0x0cec7b1977e3231a
d_5_18:         .dword 0x965be9841a437592, 0x73fbd3a046df35bd
d_5_19:         .dword 0xa36d4e9b1f05eba7, 0x2d4b5bfb1bc5bd56
d_5_20:         .dword 0x127ad443747321b4, 0x78acd96b73e88187
d_5_21:         .dword 0xf914162a9d06aa95, 0x6da2c4cba8180732
d_5_22:         .dword 0xb0c2ccd49a840772, 0x0e04899d1dacaff9
d_5_23:         .dword 0xc278e02f4ed45793, 0x5948de1354bf7e47
d_5_24:         .dword 0xad7ca7bd66fc49b4, 0x855dd113dc62e207
d_5_25:         .dword 0xfa27f6ae34a65999, 0x218b585bdd204ecc
d_5_26:         .dword 0x583d665ff8ce36c9, 0xbec92498d60581f1
d_5_27:         .dword 0xa7a153c6751d031f, 0xf272a6e43772da1e
                .dword 0x8ae75803a4924568, 0x67dc11a218240bf1
                .dword 0xa9f819504cd17174, 0x93ab4e03a503f252
         /* Random data */
_end_data5:
              
                 
