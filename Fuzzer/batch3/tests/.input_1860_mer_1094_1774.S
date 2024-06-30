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
_s0:    slliw x16, x6, 6                          ;
_s1:    div x20, x19, x16                         ;
_s2:    la x14, _s4                               ;
        srai x14, x14, 1                          ;
        csrrc x12, pmpaddr4, x14                  ;
_s3:    srliw x18, x29, 15                        ;
_s4:    fadd.s f29, f17, f20, rdn                 ;
_s5:;
        /* Fuzz suffix */
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
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
_fuzz_prefix:
_p0:    la x12, d_2_10                            ;
        srai x12, x12, 1                          ;
        csrrc x14, pmpaddr4, x12                  ;
_p1:    csrrsi x12, medeleg, 31                   ;
_p2:    xor x10, x10, x10                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 31                         ;
        add x10, x10, x10                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 26                         ;
        add x10, x10, x14                         ;
        csrrw x13, mie, x10                       ;
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
_l0:    fcvt.s.wu f16, x15, rne                   ;
_l1:    sraiw x12, x18, 13                        ;
_l2:    la x1, d_2_25                             ;
        lwu x1, -24(x1)                           ;
_l3:    la x21, d_4_15                            ;
        lhu x14, -28(x21)                         ;
_l4:    srlw x7, x25, x5                          ;
_l5:    la x14, d_1_17                            ;
        lw x4, 0(x14)                             ;
_l6:    remu x12, x27, x1                         ;
_l7:    fence                                     ;
_l8:    fmadd.s f18, f18, f17, f14, rdn           ;
_l9:    la x18, d_2_4                             ;
        addi x18, x18, 28                         ;
        amoor.w x18, x18, (x18)                   ;
_l10:   fsgnjn.s f30, f21, f17                    ;
_l11:   fsqrt.s f5, f9, rmm                       ;
_l12:   csrrwi x10, pmpaddr1, 25                  ;
_l13:   sltiu x12, x0, -130                       ;
_l14:   fdiv.s f25, f3, f28, rne                  ;
_l15:   subw x25, x8, x10                         ;
_l16:   la x16, d_1_6                             ;
        fsw f21, -20(x16)                         ;
_l17:   fcvt.s.l f20, x10, rdn                    ;
_l18:   bge x24, x14, _l51                        ;
_l19:   addiw x22, x22, -0                        ;
_l20:   sltiu x15, x19, -1805                     ;
_l21:   fmsub.s f26, f26, f27, f29, rne           ;
_l22:   la x6, d_1_18                             ;
        addi x6, x6, 12                           ;
        lui x1, 0xffe00                           ;
        xor x6, x6, x1                            ;
        amoswap.w x22, x1, (x6)                   ;
_l23:   la x18, d_0_1                             ;
        addi x18, x18, 4                          ;
        amoxor.w x25, x29, (x18)                  ;
_l24:   beq x25, x4, _l47                         ;
_l25:   lui x6, 450077                            ;
_l26:   srli x28, x6, 5                           ;
_l27:   csrrci x22, pmpaddr5, 13                  ;
_l28:   la x25, d_0_22                            ;
        addi x25, x25, 12                         ;
        amoswap.w x16, x9, (x25)                  ;
_l29:   fence                                     ;
_l30:   fcvt.s.w f17, x18, rmm                    ;
_l31:   mulw x23, x21, x23                        ;
_l32:   la x24, d_5_22                            ;
        addi x24, x24, 0                          ;
        amomax.d x23, x23, (x24)                  ;
_l33:   sllw x20, x8, x14                         ;
_l34:   slliw x3, x20, 17                         ;
_l35:   la x2, d_1_24                             ;
        fsw f22, 20(x2)                           ;
_l36:   lui x30, 819516                           ;
_l37:   feq.s x29, f5, f18                        ;
_l38:   addiw x2, x8, -1899                       ;
_l39:   fmin.s f1, f11, f24                       ;
_l40:   ebreak                                    ;
_l41:   fcvt.s.lu f0, x4, dyn                     ;
_l42:   fence.i                                   ;
_l43:   sraiw x30, x4, 0                          ;
_l44:   lui x2, 0                                 ;
_l45:   la x3, _l74                                       ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l46:   remuw x18, x5, x10                        ;
_l47:   addw x22, x25, x11                        ;
_l48:   fsgnjn.s f28, f0, f6                      ;
_l49:   mulhsu x17, x26, x18                      ;
_l50:   csrrsi x13, pmpaddr5, 31                  ;
_l51:   la x28, d_1_11                            ;
        addi x28, x28, 24                         ;
        amoxor.w x15, x22, (x28)                  ;
_l52:   la x3, _l96                                       ;
        jalr x18, 0(x3)                           ;
_l53:   slli x2, x6, 58                           ;
_l54:   la x7, d_5_20                             ;
        lb x17, -17(x7)                           ;
_l55:   la x14, d_4_25                            ;
        srai x14, x14, 1                          ;
        csrrw x8, pmpaddr0, x14                   ;
_l56:   fsub.s f1, f5, f12, rmm                   ;
_l57:   subw x6, x12, x27                         ;
_l58:   ori x22, x19, 2047                        ;
_l59:   la x27, d_1_9                             ;
        addi x27, x27, 16                         ;
        amoswap.d x13, x24, (x27)                 ;
_l60:   srli x20, x14, 48                         ;
_l61:   srlw x2, x11, x16                         ;
_l62:   la x15, _l108                                      ;
        flw f20, -28(x15)                         ;
_l63:   remu x12, x14, x20                        ;
_l64:   la x12, _l109                             ;
        ld x29, -0(x12)                           ;
_l65:   blt x14, x23, _l93                                ;
_l66:   la x27, d_4_8                             ;
        addi x27, x27, -16                        ;
        amomaxu.d x13, x10, (x27)                 ;
_l67:   mulhu x10, x28, x8                        ;
_l68:   srlw x9, x10, x28                         ;
_l69:   beq x15, x24, _l94                                ;
_l70:   la x16, d_1_27                            ;
        addi x16, x16, 0                          ;
        amomax.w x16, x8, (x16)                   ;
_l71:   csrrsi x9, mtval, 9                       ;
_l72:   fcvt.lu.s x5, f19, rtz                    ;
_l73:   la x11, _l84                                      ;
        csrrw zero, mepc, x11                     ;
        mret                                      ;
_l74:   la x29, d_1_1                             ;
        sw x8, -8(x29)                            ;
_l75:   fsgnj.s f27, f14, f17                     ;
_l76:   divw x0, x20, x21                         ;
_l77:   la x26, d_1_22                            ;
        addi x26, x26, -0                         ;
        amoswap.d x4, x10, (x26)                  ;
_l78:   la x19, d_2_18                            ;
        addi x19, x19, 0                          ;
        amoand.d x24, x8, (x19)                   ;
_l79:   la x2, d_0_4                              ;
        lb x4, 2(x2)                              ;
_l80:   andi x2, x22, -0                          ;
_l81:   sraw x21, x27, x4                         ;
_l82:   la x17, d_2_25                            ;
        addi x17, x17, -28                        ;
        amoand.w x1, x11, (x17)                   ;
_l83:   la x16, _l96                              ;
        jalr x2, 0(x16)                           ;
_l84:   ori x21, x24, -100                        ;
_l85:   addi x11, x6, 1027                        ;
_l86:   fadd.s f10, f14, f5, rtz                  ;
_l87:   bne x10, x10, _l99                        ;
_l88:   la x16, d_4_20                            ;
        addi x16, x16, 16                         ;
        amoor.d x29, x1, (x16)                    ;
_l89:   fmul.s f27, f3, f17, rtz                  ;
_l90:   fcvt.s.wu f17, x16, rdn                   ;
_l91:   bge x29, x1, _l96                                 ;
_l92:   la x2, d_1_12                             ;
        addi x2, x2, -16                          ;
        lr.d x24, (x2)                            ;
_l93:   andi x16, x1, -2047                       ;
_l94:   mulhsu x9, x22, x3                        ;
_l95:   srai x27, x2, 2                           ;
_l96:   fnmsub.s f14, f11, f25, f26, rup          ;
_l97:   la x10, d_5_2                             ;
        addi x10, x10, -16                        ;
        amoxor.d x22, x5, (x10)                   ;
_l98:   blt x10, x26, _l104                                ;
_l99:   la x10, d_0_8                             ;
        addi x10, x10, 0                          ;
        lui x15, 0xffe00                          ;
        xor x10, x10, x15                         ;
        amoor.d x5, x15, (x10)                    ;
_l100:  fcvt.w.s x24, f25, rdn                    ;
_l101:  fcvt.l.s x11, f27, rtz                    ;
_l102:  bge x11, x6, _l107                                ;
_l103:  csrrwi x12, mepc, 3                       ;
_l104:  mulh x24, x18, x23                        ;
_l105:  lui x3, 450077                            ;
_l106:  auipc x2, 1048575                         ;
_l107:  srli x25, x9, 7                           ;
_l108:  la x20, d_5_9                             ;
        addi x20, x20, 24                         ;
        sc.d x11, x20, (x20)                      ;
_l109:  la x18, d_0_16                            ;
        addi x18, x18, -0                         ;
        amoxor.d x20, x8, (x18)                   ;
_l110:  fence                                     ;
_l111:;
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
                .dword 0x7c1199c0e12b3efe, 0xd4ed5748e8f553c8
                .dword 0xb3bdcc413865dc8f, 0xfa09a931a7282a5d
d_0_0:          .dword 0x8ffca399acbc9cbe, 0x19e5d9776b25e0d5
d_0_1:          .dword 0xd30c330112f9d78d, 0x46d26535d1c04881
d_0_2:          .dword 0xd06b7c26bb25739c, 0x281cdb013d14c8e9
d_0_3:          .dword 0xc1c240b29128972f, 0x7fb9b730e83ef59a
d_0_4:          .dword 0x437e43e396af383d, 0x464990ce75d3dd56
d_0_5:          .dword 0x74dd1fda10a52f3a, 0x603635d003319bb1
d_0_6:          .dword 0xdc75003f5e626360, 0x8913a5f1b4cd5ca2
d_0_7:          .dword 0x0d9f4acb82c4918e, 0x966b0f74c7af204c
d_0_8:          .dword 0x34f103a50be2bdcf, 0x9d79f6ebd00461d6
d_0_9:          .dword 0x9dfcc0b4f4b10bc1, 0x6a670c44b051036e
d_0_10:         .dword 0x184d0a06d6c678d7, 0xe430e57fba456e1e
d_0_11:         .dword 0xcf81c8a729aa51fd, 0x677f07b51b27ceb1
d_0_12:         .dword 0x0a9acf872b0bb4d9, 0xebccf847d5b179cc
d_0_13:         .dword 0x81419f86eafe11ec, 0x8514e1bd4d3c560b
d_0_14:         .dword 0x627a7fc995434b5c, 0x8bdb432aff71240b
d_0_15:         .dword 0xd6cabfbf92c2c868, 0x24890fa8458f90cd
d_0_16:         .dword 0xe228f52e0f9fc29a, 0x8f278bf375df889e
d_0_17:         .dword 0xffd110f0a0cf9352, 0xe7c55886f15ad343
d_0_18:         .dword 0x4d8262511c44f6f7, 0x716d1857cdd08791
d_0_19:         .dword 0x59f863ecac5d4ad2, 0xadfa362256430840
d_0_20:         .dword 0x6560278d9463451e, 0xc54cb8a1d51e5143
d_0_21:         .dword 0x86e08ebbd95006a1, 0x7cc64edbc725a408
d_0_22:         .dword 0x1ffff67a69cc5249, 0x0056804a1a7f7c86
d_0_23:         .dword 0xa0a05619dfe623d7, 0x72230d9187264b65
d_0_24:         .dword 0x43171be1e49ad66a, 0x94201dd7bea96f83
d_0_25:         .dword 0xb04ff058ea8c8961, 0x5d5a5ebc4c4b9362
d_0_26:         .dword 0x05319d5f270c9d2f, 0x968c0a925f64aa4d
d_0_27:         .dword 0xf5e558c33850c41a, 0xd873a9f6a4640ecd
                .dword 0x00cafa8834f9e2aa, 0xa8f25991411f6514
                .dword 0xb1fd40b94709c4ed, 0xb3986b9071c86f97
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x45fa51533dae58b6, 0xb0a325c388cb8745
                .dword 0x12f3f9c94809a48f, 0x245e1ec1c789b364
d_1_0:          .dword 0xdc0ef7c0ced8403a, 0x246f3ccc9e3d69c7
d_1_1:          .dword 0x74b538b220eef857, 0x5edeb246eb5fd7df
d_1_2:          .dword 0x2f4d507c31e98ec4, 0x9936abcfcf013989
d_1_3:          .dword 0x64278e51e02ff859, 0x0a4ef1c51d4070fb
d_1_4:          .dword 0x2f562734210695d9, 0xccd4716ec0ddd7e4
d_1_5:          .dword 0xd60cb3b67d1cb102, 0x004945eb1ba2ac02
d_1_6:          .dword 0xdf6efe90d0a3fe0d, 0xeca54fc19363220d
d_1_7:          .dword 0x7ea3b6aa66a4da48, 0x27d6ba5a2f8d0434
d_1_8:          .dword 0x7fe55c0bd7c0ffac, 0x7d4062bd6293a91b
d_1_9:          .dword 0xf473126a0f18fc95, 0xfc0af51cb6e63f98
d_1_10:         .dword 0x97b17814fad2636f, 0x98532ff07f16d774
d_1_11:         .dword 0xfa1bb555aa82c2b8, 0x7cb3737a14043a3b
d_1_12:         .dword 0x66954bd15dc6943e, 0xb8429df6033a5da4
d_1_13:         .dword 0xe003fbf3bb92a770, 0x3a71ad2bf22c4414
d_1_14:         .dword 0x16ff5ea86ac3c777, 0xd710aace6ba04ef4
d_1_15:         .dword 0xb62b0361a9b15ab9, 0xb79ab60699bbbd5f
d_1_16:         .dword 0xf3a90cf075f3c98b, 0xa11e8270a8454018
d_1_17:         .dword 0xf3ad47c78c4577a2, 0x841fc441835ca524
d_1_18:         .dword 0x967a713b1a258e9e, 0x795369023fc97f7e
d_1_19:         .dword 0xcb6f89c852a6bddb, 0x7ad5f9056927a887
d_1_20:         .dword 0xf613058afba94cda, 0x199f9f27cf4de486
d_1_21:         .dword 0xc0f0316e48f8f649, 0x31fe98d58fd48eea
d_1_22:         .dword 0xb4d5380d5a16d66c, 0x8cc1ba58b8bd9ce1
d_1_23:         .dword 0x4863559d435878c8, 0x780e38bbd1099db1
d_1_24:         .dword 0x0546c581de2b6c75, 0x7b9c9d7ce9e768cb
d_1_25:         .dword 0x4c647a9b5af533f5, 0xc4e386f29f662011
d_1_26:         .dword 0x9639740bf519cc9c, 0x4185f62e6874662d
d_1_27:         .dword 0x41f83992f8b3a48a, 0xc6dda2f1a3a586e8
                .dword 0xb5326a893a8a9498, 0x24029bca9132d91b
                .dword 0x72bdd61ec507a20b, 0x88a90304447ce785
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x803d320d0ca5be1f, 0x7d678216eece9a5f
                .dword 0x4e894adb1fb1ae37, 0x48baaea727091ffd
d_2_0:          .dword 0xc978167203da5ef8, 0xec3fd0ff3b0bb39c
d_2_1:          .dword 0x688620e06bb6d844, 0xd33e8fccc0597da9
d_2_2:          .dword 0x963b4acc99fd82ae, 0x47f607eb2e4c57cb
d_2_3:          .dword 0xf2ee70ffa629b693, 0x623fa92f3dbeae1a
d_2_4:          .dword 0xc70982d9fc08eb4d, 0xd760d6a4bd4f1319
d_2_5:          .dword 0x5bc893fde8cdccb7, 0xd77d27fa06a856d7
d_2_6:          .dword 0xd0c219b51c1ef154, 0xaee7b8dd0f8dd823
d_2_7:          .dword 0xc0b677a2c73d6512, 0xa58f406fff52fe47
d_2_8:          .dword 0x86d0f3313a174710, 0xf5f79d7ff7279796
d_2_9:          .dword 0xb1e9bdfa61930f7c, 0xa972999795fe5396
d_2_10:         .dword 0x80b7f9ced2dc18a6, 0xa680200517440f76
d_2_11:         .dword 0xf10f308a8b46650f, 0x7fcf928d910b61df
d_2_12:         .dword 0x8ce4f13a64a04b1c, 0xd2d2c1bef1132da2
d_2_13:         .dword 0x1a9bc167bb823713, 0x410e3587cf1addcc
d_2_14:         .dword 0xf1cbfd6dde76c76b, 0x07e63f9b140a5de4
d_2_15:         .dword 0x7179cb7b0327e2e5, 0x15e763c8e205be1c
d_2_16:         .dword 0x61facc1f302282d7, 0xb18d33d8b9c62300
d_2_17:         .dword 0xe639c18dab86423d, 0x9044c89150c708b1
d_2_18:         .dword 0x2eeda96316976b42, 0xa8d9ccf59ac87f1b
d_2_19:         .dword 0x6b7cf13c709b1695, 0xd6f672cc868eb94d
d_2_20:         .dword 0x0e1d1c5a622f3ad2, 0x66f1419e6d2cb731
d_2_21:         .dword 0x5bb79e1b286f84fb, 0x7cadd5059e516da7
d_2_22:         .dword 0x39e8cf044636ca43, 0x935e94146920c196
d_2_23:         .dword 0x5df07b17a140bd23, 0x2dc7d7d629f47196
d_2_24:         .dword 0xec880c6be2f8dfdc, 0x163c321f98edb919
d_2_25:         .dword 0xf74331e29efbd373, 0x8fa73d76c9b1f087
d_2_26:         .dword 0x14b3a2e29e780e48, 0xcb40cb3f2ddaba86
d_2_27:         .dword 0xf16e80a6927c5c03, 0x4e4179946d1ece04
                .dword 0x951fd8513b2796b9, 0x29e659c459fce7aa
                .dword 0xb67b677713078317, 0xdc41b2353f4b9d1b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x9de1b057e5924f7b, 0x478a14917b9b472d
                .dword 0x3201db512dfc086b, 0x4424349dc66ef63e
d_3_0:          .dword 0x145405e780249868, 0x3eb0f00d97f57de3
d_3_1:          .dword 0xa2ad5238c501564a, 0xeeabd250180ca96d
d_3_2:          .dword 0xce93197834ef60db, 0xf15280b7f9340c0e
d_3_3:          .dword 0xfab02fa6bde43dcb, 0x537d040e7ccb6ece
d_3_4:          .dword 0x35ccc45e54af2347, 0x82c18fb499e1df29
d_3_5:          .dword 0xb10dfa1a67e3ef30, 0x60bbfd6d18ab297f
d_3_6:          .dword 0xf0e38929e8a9db24, 0x9e8ddfb6c28a953b
d_3_7:          .dword 0x5f3d70049235a976, 0x81877a26fb731984
d_3_8:          .dword 0xf6e61b303d647f1f, 0xc42bcf9696d6418b
d_3_9:          .dword 0x44c5b972b1e85947, 0x98d528ff895fb39a
d_3_10:         .dword 0x4b7df890dd6dc0c0, 0x5048e5be7bbcdc4b
d_3_11:         .dword 0x79c6ea7a5e5ec2b2, 0x8c6a851b78326681
d_3_12:         .dword 0xa7decf1ab49fbee6, 0x6fae2cd10991215e
d_3_13:         .dword 0x97b480a32e246788, 0x23115cc5b899836b
d_3_14:         .dword 0x13e36e6d1d0e497a, 0x3067784dfa9f24a7
d_3_15:         .dword 0x87144e9d484c5dc3, 0x00d0f3255a9895fa
d_3_16:         .dword 0x4e97db6a9c999e31, 0x8cddabc71dafa7bb
d_3_17:         .dword 0x75b1219f8738ce11, 0xa88e600c05d2366f
d_3_18:         .dword 0x4efcb49efea833b9, 0xd6a6df798474d949
d_3_19:         .dword 0x25901af0b03c6c02, 0xfeb26557df7a270a
d_3_20:         .dword 0x84e5c86a8282ec51, 0xa3d2af1052b797c9
d_3_21:         .dword 0x8ad34f082c0ae22e, 0xbd20c731df165dff
d_3_22:         .dword 0x478595512ba79810, 0xaf7994b3550a9a89
d_3_23:         .dword 0x24abae677d3fffc4, 0x3b6a290797a06c0c
d_3_24:         .dword 0x9816b16906b449d6, 0xa80a9671fe82a1b5
d_3_25:         .dword 0x4c1523b95a89fd53, 0x280823801abdb011
d_3_26:         .dword 0x12880f0b9e4029e8, 0x006728c256539371
d_3_27:         .dword 0xeac49ccc150833eb, 0xab2a142f2fa5842b
                .dword 0x593c1e6dc18b8c67, 0x638ae372c1398713
                .dword 0x867e42b27ccb583d, 0xdc609db73f08b2a8
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x270656a275540080, 0x05ff730be58164fd
                .dword 0x4e5f8416bd2015a0, 0xf5b1e35d972859ca
d_4_0:          .dword 0x500bc61225b2c53c, 0x5bad9b9b5db4717e
d_4_1:          .dword 0x7d78f3d79548c6bc, 0x3d7618df6a7b115e
d_4_2:          .dword 0x88c66be88259addb, 0x178f3daf7a7c3c09
d_4_3:          .dword 0x41f8cfcd5e2c62f0, 0xf912a8062ea59d31
d_4_4:          .dword 0xffbfdc98097928e1, 0x5e180e897fe4b0ba
d_4_5:          .dword 0x8c6e2c253b61d1cb, 0xbd4e750ae07c06ba
d_4_6:          .dword 0x07a3e7cef388175a, 0x5023dec0e96061a6
d_4_7:          .dword 0x244d173612dbe4e5, 0xe8fdc7b0c65bd722
d_4_8:          .dword 0x6145cf00ce5c407e, 0x5b4960be6d5def75
d_4_9:          .dword 0x2c3e3f78c0cdbaf8, 0x93a944f77741ee29
d_4_10:         .dword 0x59ab02e4c31fa599, 0xbc96fc9c15a85a66
d_4_11:         .dword 0x2d6ede71b2c5fb5c, 0xe9693f5baaba541f
d_4_12:         .dword 0xd3b66d0ce69b7978, 0x391fddf5d6b49b7f
d_4_13:         .dword 0x8739ef0123f6d8e3, 0xb3cd7dd0a27292b9
d_4_14:         .dword 0xff6b6bd6ab598308, 0xefeca7fd57fcf0bc
d_4_15:         .dword 0x57885fcfc119baa1, 0x2c43764ded1b9c28
d_4_16:         .dword 0x478f0cfa17db6396, 0x4bfcbb3df6427262
d_4_17:         .dword 0xeccbe49fe87f3217, 0xdb920bbf8b0fa793
d_4_18:         .dword 0x7cb4c49bf4aaed07, 0x75bef7750619c498
d_4_19:         .dword 0x789845050c127ac6, 0x07a60c01b521ed9b
d_4_20:         .dword 0x15ec3711a6d7d11d, 0x19593e45ae0120af
d_4_21:         .dword 0x0d1d538f9856ca5c, 0x044e3cdb3f1f24d0
d_4_22:         .dword 0x8794118b9ec869b8, 0x5f3a84d1623cfc8d
d_4_23:         .dword 0xcf58dc899b5844e0, 0x55f6456e1ab469d4
d_4_24:         .dword 0xb4c902283c62f391, 0x3bd0fa94949f55ef
d_4_25:         .dword 0x9ae7cf78cf526a33, 0xa4726eb9edc6f2da
d_4_26:         .dword 0x6b66de5a0ac03d50, 0x421c2208b5f1a568
d_4_27:         .dword 0x9f3dfcdf673a0646, 0xbe508c22d727cf5f
                .dword 0x27ceeb9f817b7022, 0xa6938498a5acffad
                .dword 0x068432d5f325b6fa, 0x6300d17225bf1b09
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x0c749f3336eeeb94, 0xbb09b1f53898fdb6
                .dword 0x8ebd38e1f785b7b6, 0x473d6ee44541fbdf
d_5_0:          .dword 0x6ca48767657aeb64, 0x6a8b5a3345c8781c
d_5_1:          .dword 0x482e9da351cc9d8b, 0xad08cc776164aaff
d_5_2:          .dword 0x4b6c0cb925e63dd0, 0x9b987d3aa8391143
d_5_3:          .dword 0x89a11a883254fa9f, 0x23c5d12785c62a97
d_5_4:          .dword 0xd4549aa0c4792bf9, 0x33b1500c18acee05
d_5_5:          .dword 0x889de73cd4c7725f, 0x8207950640578f34
d_5_6:          .dword 0x458ee902ae9f3e83, 0xab2a207c000c88db
d_5_7:          .dword 0x8ffbc02c3e40811c, 0x8ea3b73c425989e2
d_5_8:          .dword 0x5401ebb4c799e811, 0xd8c34e11f5e19102
d_5_9:          .dword 0x73848f3a4bc064d0, 0xb6e01b6bb4d477aa
d_5_10:         .dword 0x8b48124051d3ae0b, 0x16ec3f46f342c3af
d_5_11:         .dword 0x9f966f5fa16c0475, 0xd2da57b46e867140
d_5_12:         .dword 0x6a4c74e635ae317f, 0x1a9eccbd7f0b2a5b
d_5_13:         .dword 0x7bc482bc31994447, 0x6dd73aa4177ce5de
d_5_14:         .dword 0xc3f591e42a33e727, 0xdb94d1e5843a737d
d_5_15:         .dword 0x7416bdcfc9b04633, 0xd98c3dd499b0bed6
d_5_16:         .dword 0xfc634ebac43103fe, 0x2579949c0ad4fe8c
d_5_17:         .dword 0x446b8a80cbd70787, 0xea793ef3f96fb4d3
d_5_18:         .dword 0xd6eeadb9898ce55d, 0x818f84603b43303d
d_5_19:         .dword 0x60eb465ce4da7f82, 0x143b9d017be319b3
d_5_20:         .dword 0xf96e7eb7481ef2e8, 0x07b3ecbc77a38d43
d_5_21:         .dword 0x6e9f319f13f3d69d, 0xae2760d006793dd2
d_5_22:         .dword 0x1e44e12aecf91e8f, 0x71bf75a998444602
d_5_23:         .dword 0xc8b224cdaf5cca61, 0x2ea3e3c0c91c4e21
d_5_24:         .dword 0x684b24ddde1f5665, 0x0594150e3069b518
d_5_25:         .dword 0xebaf5e7d38c59d11, 0x63a2c4fb50f76e27
d_5_26:         .dword 0x956f937b4b314de6, 0x216faee4b8cae107
d_5_27:         .dword 0x6f908be200d59644, 0x57ee6f8d6c0cfde5
                .dword 0x52138cd8d8f7c431, 0x290406fef9964cb5
                .dword 0xabfae233155d6e53, 0x5d987b74825474f3
         /* Random data */
_end_data5:
              
                 
