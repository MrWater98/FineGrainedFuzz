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
_s0:    la x15, d_0_26                            ;
        addi x15, x15, 12                         ;
        amominu.w x20, x7, (x15)                  ;
_s1:    la x4, d_1_0                              ;
        flw f17, -16(x4)                          ;
_s2:    addw x6, x13, x16                         ;
_s3:    la x4, d_1_7                              ;
        addi x4, x4, 16                           ;
        sc.w x9, x19, (x4)                        ;
_s4:    la x25, d_4_15                            ;
        addi x25, x25, -0                         ;
        amoor.d x13, x24, (x25)                   ;
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
_p0:;
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
_l0:    andi x25, x7, -1277                       ;
_l1:    jal x28, _l44                                     ;
_l2:    fcvt.s.w f6, x28, dyn                     ;
_l3:    fcvt.w.s x28, f16, rmm                    ;
_l4:    la x28, d_2_3                             ;
        addi x28, x28, 24                         ;
        amoadd.w x28, x28, (x28)                  ;
_l5:    feq.s x11, f6, f16                        ;
_l6:    la x10, _l75                                      ;
        jalr x28, 0(x10)                          ;
_l7:    fmv.x.w x4, f16                           ;
_l8:    la x5, _l32                               ;
        srai x5, x5, 1                            ;
        csrrs x14, pmpaddr2, x5                   ;
_l9:    la x13, d_5_8                             ;
        addi x13, x13, 20                         ;
        amoand.w x26, x13, (x13)                  ;
_l10:   la x24, _l39                              ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l11:   div x4, x20, x22                          ;
_l12:   la x5, d_4_10                             ;
        addi x5, x5, 0                            ;
        amoswap.w x14, x9, (x5)                   ;
_l13:   rem x19, x17, x28                         ;
_l14:   fmax.s f18, f18, f6                       ;
_l15:   la x30, d_3_3                             ;
        addi x30, x30, 0                          ;
        lui x16, 0xffe00                          ;
        xor x30, x30, x16                         ;
        amomax.d x7, x16, (x30)                   ;
_l16:   la x17, d_5_23                            ;
        addi x17, x17, -0                         ;
        amoand.d x9, x28, (x17)                   ;
_l17:   auipc x20, 1                              ;
_l18:   subw x2, x11, x20                         ;
_l19:   sltiu x1, x2, 1101                        ;
_l20:   fmsub.s f17, f0, f23, f2, rmm             ;
_l21:   blt x21, x27, _l71                                ;
_l22:   la x20, d_2_8                             ;
        addi x20, x20, 0                          ;
        amoor.d x22, x14, (x20)                   ;
_l23:   ebreak                                    ;
_l24:   fsqrt.s f12, f3, rtz                      ;
_l25:   blt x22, x20, _l26                        ;
_l26:   mulw x6, x6, x10                          ;
_l27:   fence.i                                   ;
_l28:   slliw x25, x12, 29                        ;
_l29:   srlw x9, x6, x4                           ;
_l30:   la x14, d_2_9                             ;
        addi x14, x14, 0                          ;
        amoxor.d x20, x26, (x14)                  ;
_l31:   fmsub.s f21, f14, f5, f20, dyn            ;
_l32:   la x23, d_1_24                            ;
        addi x23, x23, 0                          ;
        amoor.d x30, x24, (x23)                   ;
_l33:   li x11, 1                                 ;
        la x2, pt3                                ;
        addi x2, x2, 32                           ;
        sfence.vma x11, x2                        ;
_l34:   csrrwi x1, frm, 26                        ;
_l35:   div x16, x23, x3                          ;
_l36:   bge x24, x20, _l79                        ;
_l37:   la x30, _l39                                      ;
        lhu x10, -6(x30)                          ;
_l38:   sllw x0, x26, x5                          ;
_l39:   la x15, d_2_21                            ;
        addi x15, x15, 8                          ;
        amoor.w x27, x4, (x15)                    ;
_l40:   fsub.s f22, f12, f8, rdn                  ;
_l41:   addi x30, x13, -1569                      ;
_l42:   la x15, d_3_26                            ;
        lhu x10, -26(x15)                         ;
_l43:   lui x30, 605329                           ;
_l44:   srlw x29, x11, x30                        ;
_l45:   la x6, _l64                                       ;
        jalr x11, 0(x6)                           ;
_l46:   la x5, _l59                                       ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l47:   fmv.x.w x1, f1                            ;
_l48:   fmin.s f7, f21, f2                        ;
_l49:   fmax.s f4, f6, f13                        ;
_l50:   la x9, _l77                                       ;
        srai x9, x9, 1                            ;
        csrrs x5, pmpaddr4, x9                    ;
_l51:   divuw x3, x28, x26                        ;
_l52:   div x8, x7, x10                           ;
_l53:   fcvt.lu.s x8, f18, rmm                    ;
_l54:   remu x25, x22, x20                        ;
_l55:   fcvt.s.lu f13, x5, rtz                    ;
_l56:   fmax.s f7, f21, f16                       ;
_l57:   fmin.s f14, f16, f22                      ;
_l58:   la x25, d_1_13                            ;
        addi x25, x25, 8                          ;
        lr.d x18, (x25)                           ;
_l59:   xor x11, x11, x11                         ;
        csrrc x2, medeleg, x11                    ;
_l60:   la x30, d_2_2                             ;
        addi x30, x30, 8                          ;
        amoand.w x17, x20, (x30)                  ;
_l61:   fcvt.s.wu f14, x23, rdn                   ;
_l62:   slli x24, x6, 33                          ;
_l63:   xor x8, x8, x8                            ;
        addi x26, zero, 1                         ;
        slli x26, x26, 1                          ;
        add x8, x8, x26                           ;
        addi x28, zero, 3                         ;
        slli x28, x28, 12                         ;
        add x8, x8, x28                           ;
        addi x1, zero, 1                          ;
        slli x1, x1, 8                            ;
        add x8, x8, x1                            ;
        csrrw x23, mcause, x8                     ;
_l64:   feq.s x5, f8, f0                          ;
_l65:   fence.i                                   ;
_l66:   la x25, d_1_5                             ;
        addi x25, x25, -0                         ;
        amoadd.d x17, x7, (x25)                   ;
_l67:   la x2, d_1_19                             ;
        addi x2, x2, 4                            ;
        lr.w x16, (x2)                            ;
_l68:   fdiv.s f2, f28, f0, rne                   ;
_l69:   la x17, d_2_23                            ;
        addi x17, x17, 0                          ;
        amominu.w x26, x24, (x17)                 ;
_l70:   csrrci x16, mstatus, 31                   ;
_l71:   remu x20, x20, x27                        ;
_l72:   la x1, d_2_23                             ;
        sh x12, -30(x1)                           ;
_l73:   mul x24, x30, x26                         ;
_l74:   fsqrt.s f14, f6, rne                      ;
_l75:   mulhu x13, x7, x19                        ;
_l76:   fadd.s f19, f22, f11, dyn                 ;
_l77:   jal x14, _l93                                     ;
_l78:   fcvt.w.s x10, f17, rup                    ;
_l79:   la x1, d_1_2                              ;
        addi x1, x1, 8                            ;
        amoxor.w x13, x26, (x1)                   ;
_l80:   la x14, d_5_17                            ;
        lb x30, -1(x14)                           ;
_l81:   la x5, d_3_14                             ;
        lhu x29, -16(x5)                          ;
_l82:   slli x22, x7, 47                          ;
_l83:   la x11, d_0_3                             ;
        addi x11, x11, -28                        ;
        amoxor.w x14, x12, (x11)                  ;
_l84:   xor x22, x22, x22                         ;
        csrrs x30, pmpcfg0, x22                   ;
_l85:   srli x19, x27, 26                         ;
_l86:   fsgnj.s f28, f1, f7                       ;
_l87:   fcvt.lu.s x10, f2, rdn                    ;
_l88:   la x20, d_3_27                            ;
        sh x16, 0(x20)                            ;
_l89:   fcvt.s.lu f28, x14, rne                   ;
_l90:   sllw x14, x28, x21                        ;
_l91:   blt x9, x15, _l101                                 ;
_l92:   la x14, d_0_2                             ;
        addi x14, x14, 24                         ;
        lui x2, 0xffe00                           ;
        xor x14, x14, x2                          ;
        amomax.d x28, x2, (x14)                   ;
_l93:   la x6, d_4_13                             ;
        addi x6, x6, 16                           ;
        amoxor.d x23, x3, (x6)                    ;
_l94:   fcvt.s.lu f8, x17, rmm                    ;
_l95:   la x26, d_0_26                            ;
        flw f1, -0(x26)                           ;
_l96:   slliw x28, x6, 19                         ;
_l97:   fmsub.s f3, f30, f20, f21, rtz            ;
_l98:   la x16, d_4_24                            ;
        addi x16, x16, 0                          ;
        amoxor.d x4, x30, (x16)                   ;
_l99:   fmsub.s f24, f3, f5, f23, rtz             ;
_l100:  la x4, d_0_7                              ;
        fsw f29, 20(x4)                           ;
_l101:  fclass.s x29, f1                          ;
_l102:  la x11, d_1_7                             ;
        addi x11, x11, 24                         ;
        lui x9, 0xffe00                           ;
        xor x11, x11, x9                          ;
        amoadd.d x18, x9, (x11)                   ;
_l103:  srliw x9, x27, 0                          ;
_l104:  divu x22, x2, x21                         ;
_l105:  andi x1, x22, 1770                        ;
_l106:  fcvt.w.s x16, f6, rmm                     ;
_l107:;
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
                .dword 0xaa14c8a83d0a7cd3, 0x7719ca0686e248cd
                .dword 0x559ed55e2647b51c, 0x1cf836463c115dd0
d_0_0:          .dword 0x1ddd460e2a46a19a, 0xaffa00c8b5f5b83e
d_0_1:          .dword 0x8ea183e6ffcf18f8, 0x32a44637088795b6
d_0_2:          .dword 0x51061f199b00dca0, 0xbb6fa232ae7d4500
d_0_3:          .dword 0x2a1f6b6e26f13b0c, 0x6ac8758f74ff3745
d_0_4:          .dword 0x3f34cfc9aade6ad4, 0x25a2b713dd0cd41f
d_0_5:          .dword 0xa7a8f93999cda3f8, 0xf3558425f80077f5
d_0_6:          .dword 0x618929d47d791029, 0x11d70f6f30a0a6e9
d_0_7:          .dword 0xee034ca181448b6d, 0xbc393a568f8ddcd6
d_0_8:          .dword 0xae2ebcd11e995835, 0x580c1b1459ba9e32
d_0_9:          .dword 0x4959166ac59c62af, 0x3e209ef010f548e9
d_0_10:         .dword 0x842ac7588db0a9c5, 0xdc8aaa789efd936f
d_0_11:         .dword 0xb90097087d0d15ae, 0xce381630fa2ace46
d_0_12:         .dword 0xe34a990500448160, 0xc3fa00a1cbbfcb4d
d_0_13:         .dword 0x467922c99d464f59, 0xa8029326618877f0
d_0_14:         .dword 0xf9f12e37305c452e, 0x16cd3b36d4f1c45f
d_0_15:         .dword 0x75b2f692644fcd92, 0xc837df86b18d381c
d_0_16:         .dword 0x1c7ba1b95094301e, 0x7d6b3d9edb14dcef
d_0_17:         .dword 0x97d8e72d407afd40, 0xa226f3abfda9199a
d_0_18:         .dword 0xc3d02704360bd6d9, 0xf4ecb47fc3d803c6
d_0_19:         .dword 0x72dc274b343b01a9, 0x9d6f4adbb3bd01c7
d_0_20:         .dword 0xf551a5f30b6d7a52, 0xfeff7b71d47db6f8
d_0_21:         .dword 0x5043ea5c59cad6b1, 0x0aae0d23453e62f1
d_0_22:         .dword 0x5efc907f425aee53, 0x18fd88dffc035a84
d_0_23:         .dword 0x7c24864b45ae0d99, 0x6a4efd064fc82fd9
d_0_24:         .dword 0xedd113c8f4a4934f, 0x29b5762d0cfdcafe
d_0_25:         .dword 0x8d45573b3161dfb4, 0xc1e3f08d4d9395da
d_0_26:         .dword 0x503e32abbef8f9c2, 0xa5252ca467211a0c
d_0_27:         .dword 0xfb9bb0497b435357, 0x272735ca9563031f
                .dword 0xaa3e436c916b4c77, 0xa382fac80471d432
                .dword 0x33bec2d068add3d9, 0x03000340335b42ed
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8ca511194608037c, 0x394ac65939f56653
                .dword 0x18e1142d6ff3c3f2, 0x71052467b2359ee9
d_1_0:          .dword 0xc409d2e527d3deb0, 0x7966dbf17537f202
d_1_1:          .dword 0x4e23a4b8284c137b, 0xd72ab58a6c492516
d_1_2:          .dword 0xba67a9fcbe034bd6, 0xf09160a066e837d3
d_1_3:          .dword 0xbe7739a8ec3757bc, 0xb46f80f7db40407b
d_1_4:          .dword 0x66da5943519b6675, 0xa110d0cd677f9608
d_1_5:          .dword 0x8d756b5454d14265, 0x15bd95f487febd96
d_1_6:          .dword 0xa441cca62b9fd15a, 0x6f15d411533aa5b2
d_1_7:          .dword 0x4cffa24737957490, 0x021c175554b7e970
d_1_8:          .dword 0x896c6609aecd9d83, 0x678fe146f184719b
d_1_9:          .dword 0x1d74986ae5dd2f4c, 0xe00696909b94461e
d_1_10:         .dword 0xf314b5e5bd273ce0, 0x4e5750f3fea37e0e
d_1_11:         .dword 0xb35a42dac6743c4f, 0xf93cf662ecff854e
d_1_12:         .dword 0xf05ec84ecc2f0d72, 0xbcffd2ea739aa831
d_1_13:         .dword 0x964a49527d40b9a6, 0x4e07fb86fc7c3dcf
d_1_14:         .dword 0x4dbba69688b3ab1a, 0x61d7aeee4767ca87
d_1_15:         .dword 0x8376fef231be0cdc, 0xe5a881e8ab78e02a
d_1_16:         .dword 0x39838f61252bf3d1, 0x027d9d41eec26d48
d_1_17:         .dword 0x370eee5c5ca756e1, 0x62b172f2b6b4a332
d_1_18:         .dword 0xa44c058a2fd5db1a, 0x1b9c94eb796fdb6b
d_1_19:         .dword 0x8e0728103fbe5ef1, 0x3f767faa78d91196
d_1_20:         .dword 0xd8e95a755cdec83a, 0x8266475d7113bb53
d_1_21:         .dword 0x3600b7967b74ed28, 0x8ffc3c21b7c0714c
d_1_22:         .dword 0x17f293f1894707ff, 0xde8146feb0ee0005
d_1_23:         .dword 0x71af1cacac3ae5b8, 0x138ca35659a34e98
d_1_24:         .dword 0x690e4710645a6ace, 0x69e18780c8bd0e5c
d_1_25:         .dword 0x48a7853512cfb63b, 0x2e5a341a80b59e3b
d_1_26:         .dword 0x9da41c555b9718c9, 0xfab57e909888b26c
d_1_27:         .dword 0x1f8fb0fb19f588d0, 0x198c69a592a31786
                .dword 0x685e731b0737232e, 0x7bd71827ae80e8e5
                .dword 0xa8126e7c4cd85aa3, 0x8164a161a1afa789
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x0639d49296c362b8, 0xe1bbfd0607178b9b
                .dword 0x5e731640a6fcb214, 0x3c585a8f8bc77aae
d_2_0:          .dword 0x6b6cb895eb3fb28e, 0xded07fe97894e849
d_2_1:          .dword 0x27e92c324b5be806, 0x7385f3915b74204a
d_2_2:          .dword 0x5e1eef6dfe33c337, 0x29b0c949e61d37fc
d_2_3:          .dword 0x5cfcec94240106b9, 0x69fc953a4b1cff44
d_2_4:          .dword 0x3de0bb62b6d0ef3c, 0xd59b53cb8a574a75
d_2_5:          .dword 0x7307194eb6de4cd8, 0x72ea9f7d88a497aa
d_2_6:          .dword 0x1ed88b92eba2ed57, 0x968da0ef0c90a8ff
d_2_7:          .dword 0x25d842b2ad5a0c5f, 0x7a2a281de89f6539
d_2_8:          .dword 0x548404d80111d2ff, 0x72dab90d6309aa59
d_2_9:          .dword 0x62d0de3e827a89af, 0x0e6ff1ad56bbb45a
d_2_10:         .dword 0x1a23b24fea41fdb0, 0x271e3c994688b5ec
d_2_11:         .dword 0xe9cc5e53ddbb6ce3, 0xb9852296aa182574
d_2_12:         .dword 0x9c49be7cb5f23819, 0x737faff24252082f
d_2_13:         .dword 0xe6a91a73800ed71a, 0x8a70265ce745de11
d_2_14:         .dword 0x1f4c51fff824deba, 0x9b5d938475ea7948
d_2_15:         .dword 0x36f93c796bf2c9b8, 0xffc3768ac44e5b17
d_2_16:         .dword 0x749f80df0f566392, 0xd77fa0c382493889
d_2_17:         .dword 0xe2f78842061c0c69, 0x5de88c4159c415a0
d_2_18:         .dword 0xa2e27f5914011765, 0xaa08693875914b41
d_2_19:         .dword 0x910cc5df8a554cb6, 0x695a3be96a8a1408
d_2_20:         .dword 0x6906772f7622c33e, 0x2d1f06879c8b72f5
d_2_21:         .dword 0x8f966d76f225c394, 0xbb0b705993a2b65b
d_2_22:         .dword 0x926d085cdaa11fe1, 0x555730517fe6e71d
d_2_23:         .dword 0x4c5c8433d20855d8, 0x1c65cb3e575d6b2b
d_2_24:         .dword 0xcc6fa8271f78cd1e, 0xd028f2d9eba91d9c
d_2_25:         .dword 0x3d2802b9f0551f97, 0x44582a63482d8be2
d_2_26:         .dword 0xd2d068ed11b76f2b, 0x74cbad1c1bb8db30
d_2_27:         .dword 0x5173d24697ea4526, 0xbc61763ea25f779a
                .dword 0x0af32382f89978fa, 0xceea50ae92ae5e52
                .dword 0x3da95a6cbd0dc863, 0xa69d88ede519e206
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf3bebdb1dd1e9679, 0x406970b64b4f21c1
                .dword 0x9a631b09b6902a34, 0x29a403c69c26607a
d_3_0:          .dword 0x3282d29b171338be, 0x8ef8ec087acac6f8
d_3_1:          .dword 0x2d8204aac6a68a41, 0xb945fc0c676bcc8d
d_3_2:          .dword 0x8e16ea38abd5f574, 0x49fa18826712502d
d_3_3:          .dword 0x0c4b0692fc9cc22a, 0x8bf1c1f4d624ef6f
d_3_4:          .dword 0xc2cda21ec0d82eed, 0xf442c88fefa73ced
d_3_5:          .dword 0x51f235607151c159, 0x1c4791c47c8d2b45
d_3_6:          .dword 0xcb70a70efcf37950, 0xdb6a3d9a670d1175
d_3_7:          .dword 0xb37cd8eed0483168, 0x8c76037cef49ff5b
d_3_8:          .dword 0x49f4cc1947986954, 0x69e63dc64c56d03d
d_3_9:          .dword 0x2fe27e6eff61be49, 0x2501e168629766f0
d_3_10:         .dword 0x753360cf1af4fb2d, 0xb3de32fbbc301394
d_3_11:         .dword 0xb66f6d57572d4d32, 0x23a973f23e9a1603
d_3_12:         .dword 0x06ae4626d02426d5, 0x4f2061b3b1c237d1
d_3_13:         .dword 0xe98644a27fd19c86, 0xeabbf07e3f953670
d_3_14:         .dword 0x2874f64d4ec0ecd8, 0xb57a0f2a6889fd84
d_3_15:         .dword 0x87fa3af579561dd0, 0xd3848ff5bee7f4aa
d_3_16:         .dword 0xe5a4f7e9a6775c8e, 0x99d49ddfeb08a5b4
d_3_17:         .dword 0x419b9245f51de598, 0x7e4cc54fb43299de
d_3_18:         .dword 0x96160f06b040e332, 0x1d2ce6fe1faad399
d_3_19:         .dword 0x25949315da9e94db, 0x40e2f253fba1f9b5
d_3_20:         .dword 0x984b9660efa7d00e, 0xa520c76edea5c816
d_3_21:         .dword 0xeb68c4e65d4efa7d, 0x97bdaf32ab9d4963
d_3_22:         .dword 0x367188127d7da813, 0xb4be29e169b5ec0a
d_3_23:         .dword 0x047c86d644ac8316, 0x2b2d586b13836623
d_3_24:         .dword 0xb1db34bc89415c0b, 0x5b4d8d91112d5199
d_3_25:         .dword 0x3b2020c60c74a705, 0x50286043fe3d2b00
d_3_26:         .dword 0x6210e2a061c20d40, 0x7d3b4544529c516d
d_3_27:         .dword 0x99d9e3f233787dea, 0x9ac4a7f380e3b4ce
                .dword 0x75b190c776ddb30c, 0x4a7b7b0a66c8f2f4
                .dword 0xa6b17026c3bc0189, 0x83a369af2020572d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x1bdc434f62920ff7, 0xe2b28c86e7b6b264
                .dword 0x046973bfc70fb42f, 0xeec1e17b2f5ff681
d_4_0:          .dword 0xa551cafb35fad16c, 0x9d117bfac3afd9b0
d_4_1:          .dword 0xe60b6b06a9a0a031, 0x78c88f6af51b968c
d_4_2:          .dword 0x0b0fc9ee31c6e8b9, 0x53de5e6f3302d99b
d_4_3:          .dword 0x8f4a5d3574c16ed9, 0x5feac000aec3ebb9
d_4_4:          .dword 0x0352e6c6ff3fb7da, 0xc024697cd52316f6
d_4_5:          .dword 0x640ab77abcec34a6, 0x4b307bcb6050024f
d_4_6:          .dword 0x7140d08a77c9bf27, 0x7899eac83316df19
d_4_7:          .dword 0xdc496bcfc9b7e1eb, 0xbf29259e40f839d9
d_4_8:          .dword 0xa5ddb8b4ae28f667, 0x3ba6b8c74a1b2b06
d_4_9:          .dword 0x7b1a917250f6675a, 0x908f4518d59e446a
d_4_10:         .dword 0xd5ccc662aebebc15, 0xd5726220a4eda1b8
d_4_11:         .dword 0x8b39a732a1f7c0a6, 0x23d1393205b9be72
d_4_12:         .dword 0x8fc7fd7b634453bb, 0x0e3ac82d2683aef0
d_4_13:         .dword 0xd8e734de7cab2103, 0xb7ff4726e228665e
d_4_14:         .dword 0x1ed35f0121d84207, 0x2249c754c3264844
d_4_15:         .dword 0x45efc6de32e213a8, 0x88757b4ddde3bdf2
d_4_16:         .dword 0xb726c4121dd2bbed, 0xace43bc5ec199b7a
d_4_17:         .dword 0xd2d70aed6b6119e1, 0x0c13269612b92f98
d_4_18:         .dword 0x39a9a6813f1d8790, 0x9be795a1f7dc6212
d_4_19:         .dword 0x01f902dcb3e60079, 0xe4166b85584c6cea
d_4_20:         .dword 0x26f315b566f1f3aa, 0xa7a45bf421a805a5
d_4_21:         .dword 0x55890cf34b3943db, 0x413dd6eef4beacee
d_4_22:         .dword 0x46c11e6db367fe5c, 0x147d187d05a31557
d_4_23:         .dword 0x6d47314dd0bbbb8d, 0x7707e4c2e66fa01b
d_4_24:         .dword 0xc1e46d838351b622, 0x3a7e393807e92ad7
d_4_25:         .dword 0x7eb713493255c620, 0x42f69898d57a4177
d_4_26:         .dword 0xb06f196db6f4fd55, 0xbd62d2cf2bacc402
d_4_27:         .dword 0x111bccb886ed73f2, 0xd656fa81efb367e0
                .dword 0xf2d255feacfbcc82, 0xafa7586692b265f8
                .dword 0x94734a77bef3f9d7, 0x4cd62d0f1d930386
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x37b54b6682b2e1dd, 0xb18f78223aefafd6
                .dword 0xf863abad6bbd252f, 0xd14338d94e515c78
d_5_0:          .dword 0x3b9b25421f6fe0bd, 0x650cf28c8a1c7697
d_5_1:          .dword 0x252686b39c7c2bb5, 0x903b16a58b7e7fbd
d_5_2:          .dword 0x9bc3486bf9b48400, 0xe68c32e82d0a8894
d_5_3:          .dword 0x8544875881c61c3e, 0x3a7a372c9205d833
d_5_4:          .dword 0x254c7d2765386b90, 0xa3ac2c23ca9174d5
d_5_5:          .dword 0xc77fde0b99271ffc, 0x3c9e425e02db54c6
d_5_6:          .dword 0x64b2ef2dd0de4476, 0x2f62a80f649d67bc
d_5_7:          .dword 0xf3fb6732f3297928, 0xdf63697626273c3d
d_5_8:          .dword 0xda6725bd9359cabd, 0x3a44cefcb7f2b01c
d_5_9:          .dword 0x3f87eb295008f015, 0xf9b977946b3edd1a
d_5_10:         .dword 0x8144207d362e2fbc, 0x8511ebb29e3ba648
d_5_11:         .dword 0x58d71eba8a84a9bc, 0x43d27e42fe01562f
d_5_12:         .dword 0x94f6228e14308940, 0x20e41d90f00c00fb
d_5_13:         .dword 0xcf1064d251311916, 0x778bbadc2e8a50ce
d_5_14:         .dword 0x14de0aae61a3b03f, 0x7c3e35750467b7ef
d_5_15:         .dword 0x2e40a59ff222fb8c, 0xb4e590bd87d4a787
d_5_16:         .dword 0x918a02e578a38abd, 0xd0e9be7e520c5281
d_5_17:         .dword 0x1bafc515ea9ed60e, 0xbb31a247e7ffe396
d_5_18:         .dword 0xcbda834a79289da9, 0xc0f2615c11db7c54
d_5_19:         .dword 0x6dfefd5ef9f9e570, 0x1cfa429a9a5c2148
d_5_20:         .dword 0xbee5ddcf1b798aad, 0x0adf7ed904bd992b
d_5_21:         .dword 0xa01026170e823f2b, 0x5b3307f7ac1eb062
d_5_22:         .dword 0x06398eec5aceb3a0, 0xc3eb4a59c0301e48
d_5_23:         .dword 0x240d5b2c5948f3fc, 0x87796d5d8cad20ee
d_5_24:         .dword 0x2874c1bd3c830dfe, 0xec3abfb36ebf076f
d_5_25:         .dword 0x2516456b0297ad8d, 0x6ba19ae987a5d1be
d_5_26:         .dword 0x06d03856d160ccfa, 0x26aa2dab1d1df1b4
d_5_27:         .dword 0x9a8e00ec6cab3861, 0xe5093a01694119e8
                .dword 0x3910d5813e855e38, 0xc3ee7d4270e4cc8b
                .dword 0x2b6bc940fd538bfe, 0x797f651dc639c882
         /* Random data */
_end_data5:
              
                 
