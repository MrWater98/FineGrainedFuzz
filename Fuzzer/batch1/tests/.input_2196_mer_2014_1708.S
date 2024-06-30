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
_s0:    la x20, d_3_3                             ;
        addi x20, x20, -24                        ;
        amomaxu.d x17, x11, (x20)                 ;
_s1:    ebreak                                    ;
_s2:;
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
_p0:    csrrci x12, sscratch, 23                  ;
_p1:    xor x13, x13, x13                         ;
        csrrw x13, mscratch, x13                  ;
_p2:;
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
_l0:    la x25, d_1_8                             ;
        addi x25, x25, -24                        ;
        amoand.w x2, x10, (x25)                   ;
_l1:    la x26, d_3_23                            ;
        sb x22, -16(x26)                          ;
_l2:    remu x12, x29, x24                        ;
_l3:    slli x2, x2, 28                           ;
_l4:    la x13, d_1_3                             ;
        addi x13, x13, -0                         ;
        amomaxu.w x18, x14, (x13)                 ;
_l5:    mulhsu x2, x0, x5                         ;
_l6:    csrrwi x4, fflags, 21                     ;
_l7:    lui x28, 1048575                          ;
_l8:    srai x24, x5, 23                          ;
_l9:    ori x7, x28, -821                         ;
_l10:   andi x5, x26, 23                          ;
_l11:   la x4, d_0_18                             ;
        lb x20, -26(x4)                           ;
_l12:   fle.s x20, f26, f26                       ;
_l13:   la x9, d_5_16                             ;
        lh x11, -30(x9)                           ;
_l14:   la x23, _l37                                      ;
        csrrw zero, sepc, x23                     ;
        sret                                      ;
_l15:   la x11, d_1_22                            ;
        addi x11, x11, 0                          ;
        amoadd.d x23, x16, (x11)                  ;
_l16:   fcvt.lu.s x9, f10, rtz                    ;
_l17:   la x3, d_1_26                             ;
        lui x23, 0xffe00                          ;
        xor x3, x3, x23                           ;
        sw x15, -20(x3)                           ;
_l18:   la x22, d_2_26                            ;
        addi x22, x22, -0                         ;
        amoswap.d x15, x30, (x22)                 ;
_l19:   sraiw x16, x23, 30                        ;
_l20:   flt.s x4, f24, f16                        ;
_l21:   fcvt.s.lu f14, x26, rup                   ;
_l22:   fdiv.s f18, f22, f1, rne                  ;
_l23:   mulhsu x5, x4, x9                         ;
_l24:   fcvt.w.s x4, f12, rdn                     ;
_l25:   sltiu x14, x20, 1175                      ;
_l26:   srlw x2, x3, x24                          ;
_l27:   fsgnj.s f8, f8, f11                       ;
_l28:   la x14, d_5_22                            ;
        addi x14, x14, -16                        ;
        amominu.d x14, x14, (x14)                 ;
_l29:   srlw x15, x23, x3                         ;
_l30:   srlw x14, x10, x2                         ;
_l31:   beq x22, x15, _l56                                ;
_l32:   fmul.s f18, f8, f18, rdn                  ;
_l33:   la x3, _l91                                       ;
        lw x24, 0(x3)                             ;
_l34:   la x14, d_2_7                             ;
        addi x14, x14, -8                         ;
        amoxor.d x1, x23, (x14)                   ;
_l35:   div x22, x9, x28                          ;
_l36:   sltiu x28, x26, 1669                      ;
_l37:   fsgnjx.s f25, f20, f10                    ;
_l38:   srliw x0, x22, 31                         ;
_l39:   ecall                                     ;
_l40:   la x9, d_5_21                             ;
        addi x9, x9, 0                            ;
        lui x24, 0xffe00                          ;
        xor x9, x9, x24                           ;
        lr.d x16, (x9)                            ;
_l41:   sraw x15, x24, x9                         ;
_l42:   la x17, d_1_15                            ;
        ld x29, -24(x17)                          ;
_l43:   srliw x30, x13, 0                         ;
_l44:   sraw x3, x9, x27                          ;
_l45:   la x20, d_0_2                             ;
        addi x20, x20, -0                         ;
        amoadd.d x27, x29, (x20)                  ;
_l46:   la x14, d_1_4                             ;
        lhu x13, -4(x14)                          ;
_l47:   rem x1, x9, x24                           ;
_l48:   srliw x10, x18, 25                        ;
_l49:   fmsub.s f8, f10, f3, f4, dyn              ;
_l50:   sllw x26, x30, x11                        ;
_l51:   fcvt.w.s x16, f15, rtz                    ;
_l52:   fnmsub.s f23, f17, f3, f23, rmm           ;
_l53:   remw x21, x15, x22                        ;
_l54:   la x15, d_4_19                            ;
        addi x15, x15, 4                          ;
        lr.w x20, (x15)                           ;
_l55:   fnmsub.s f23, f17, f3, f23, rmm           ;
_l56:   addiw x0, x13, 0                          ;
_l57:   la x1, d_3_23                             ;
        addi x1, x1, 24                           ;
        amomax.d x30, x7, (x1)                    ;
_l58:   la x8, _l75                                       ;
        csrrw zero, uepc, x8                      ;
        uret                                      ;
_l59:   la x6, d_4_24                             ;
        addi x6, x6, -0                           ;
        amomin.d x28, x21, (x6)                   ;
_l60:   la x7, d_4_6                              ;
        sh x12, -24(x7)                           ;
_l61:   la x2, d_3_24                             ;
        addi x2, x2, -12                          ;
        amoxor.w x30, x4, (x2)                    ;
_l62:   divw x20, x18, x20                        ;
_l63:   la x14, d_0_1                             ;
        addi x14, x14, 0                          ;
        amomaxu.w x14, x13, (x14)                 ;
_l64:   la x14, d_5_9                             ;
        addi x14, x14, 0                          ;
        amomin.d x2, x12, (x14)                   ;
_l65:   la x29, d_0_24                            ;
        flw f29, -16(x29)                         ;
_l66:   la x1, d_3_3                              ;
        addi x1, x1, -0                           ;
        amominu.d x17, x6, (x1)                   ;
_l67:   li x25, 1                                 ;
        la x23, pt2                               ;
        addi x23, x23, 8                          ;
        sfence.vma x25, x23                       ;
_l68:   sraiw x19, x22, 30                        ;
_l69:   la x5, _l119                              ;
        csrrw zero, uepc, x5                      ;
        uret                                      ;
_l70:   ebreak                                    ;
_l71:   la x20, d_4_26                            ;
        addi x20, x20, -0                         ;
        amominu.w x3, x24, (x20)                  ;
_l72:   la x22, d_3_15                            ;
        addi x22, x22, 24                         ;
        lr.d x18, (x22)                           ;
_l73:   mulh x25, x13, x26                        ;
_l74:   xori x0, x24, -1223                       ;
_l75:   la x27, d_2_1                             ;
        addi x27, x27, -8                         ;
        amominu.w x18, x19, (x27)                 ;
_l76:   remw x15, x7, x21                         ;
_l77:   la x11, d_2_7                             ;
        sb x3, -8(x11)                            ;
_l78:   la x28, d_0_7                             ;
        sw x17, 28(x28)                           ;
_l79:   fmin.s f21, f1, f7                        ;
_l80:   mulh x26, x6, x26                         ;
_l81:   sltiu x10, x15, 1365                      ;
_l82:   fcvt.s.w f14, x11, rdn                    ;
_l83:   la x27, _l89                                      ;
        csrrw zero, sepc, x27                     ;
        sret                                      ;
_l84:   la x25, d_1_21                            ;
        lw x28, 0(x25)                            ;
_l85:   jal x19, _l102                                    ;
_l86:   bne x3, x13, _l133                                ;
_l87:   la x30, d_2_6                             ;
        addi x30, x30, -8                         ;
        sc.d x21, x30, (x30)                      ;
_l88:   la x22, d_1_11                            ;
        sh x17, -10(x22)                          ;
_l89:   la x13, d_2_5                             ;
        lbu x10, 19(x13)                          ;
_l90:   jal x19, _l130                                    ;
_l91:   sltiu x30, x5, 2047                       ;
_l92:   srliw x8, x15, 11                         ;
_l93:   fcvt.s.lu f25, x7, rmm                    ;
_l94:   xor x25, x25, x25                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 26                           ;
        add x25, x25, x2                          ;
        csrrs x16, satp, x25                      ;
_l95:   flt.s x5, f27, f7                         ;
_l96:   la x21, d_4_1                             ;
        sd x19, 8(x21)                            ;
_l97:   la x19, _l125                                     ;
        csrrw zero, sepc, x19                     ;
        sret                                      ;
_l98:   la x13, _l130                                     ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l99:   beq x9, x18, _l124                                ;
_l100:  csrrsi x11, pmpaddr3, 21                  ;
_l101:  fcvt.l.s x7, f27, rdn                     ;
_l102:  la x1, _l124                                      ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l103:  la x24, d_1_24                            ;
        lui x20, 0xffe00                          ;
        xor x24, x24, x20                         ;
        sw x23, 0(x24)                            ;
_l104:  fcvt.l.s x3, f12, rtz                     ;
_l105:  fmax.s f15, f31, f14                      ;
_l106:  la x16, d_3_11                            ;
        addi x16, x16, 8                          ;
        amominu.d x20, x4, (x16)                  ;
_l107:  div x27, x4, x5                           ;
_l108:  rem x14, x26, x29                         ;
_l109:  xor x3, x3, x3                            ;
        addi x24, zero, 1                         ;
        slli x24, x24, 21                         ;
        add x3, x3, x24                           ;
        csrrc x8, mscratch, x3                    ;
_l110:  beq x12, x1, _l125                        ;
_l111:  andi x27, x21, -1892                      ;
_l112:  la x14, d_2_8                             ;
        addi x14, x14, -24                        ;
        amoor.w x8, x19, (x14)                    ;
_l113:  blt x29, x8, _l132                                ;
_l114:  fcvt.w.s x10, f18, rne                    ;
_l115:  la x16, d_2_7                             ;
        lui x26, 0xffe00                          ;
        xor x16, x16, x26                         ;
        lb x9, -11(x16)                           ;
_l116:  sraiw x17, x11, 11                        ;
_l117:  csrrsi x4, frm, 22                        ;
_l118:  la x27, d_0_10                            ;
        flw f19, -4(x27)                          ;
_l119:  rem x24, x28, x12                         ;
_l120:  addw x28, x13, x1                         ;
_l121:  srlw x17, x23, x2                         ;
_l122:  la x8, d_4_16                             ;
        lw x27, -24(x8)                           ;
_l123:  la x19, d_4_26                            ;
        sb x7, 31(x19)                            ;
_l124:  ori x6, x30, 949                          ;
_l125:  csrrwi x2, pmpaddr5, 11                   ;
_l126:  la x29, d_1_16                            ;
        addi x29, x29, 16                         ;
        amoor.d x16, x13, (x29)                   ;
_l127:  sllw x20, x27, x9                         ;
_l128:  bltu x19, x13, _l129                              ;
_l129:  fdiv.s f3, f25, f14, rtz                  ;
_l130:  addiw x25, x18, 949                       ;
_l131:  beq x22, x2, _l137                        ;
_l132:  la x7, _l134                                      ;
        jalr x10, 0(x7)                           ;
_l133:  mulw x23, x8, x29                         ;
_l134:  la x11, d_4_11                            ;
        addi x11, x11, -20                        ;
        amomaxu.w x29, x19, (x11)                 ;
_l135:  fsgnjn.s f6, f14, f15                     ;
_l136:  ori x13, x12, 1115                        ;
_l137:  la x17, d_2_2                             ;
        sh x22, -30(x17)                          ;
_l138:;
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
                .dword 0x69d468bad26c79fb, 0x8cd503fdbebebcaf
                .dword 0x4ea44773da3826b3, 0x5a7b41197a3153a3
d_0_0:          .dword 0xbae090165dc08d36, 0x9f9a28a813ad74a7
d_0_1:          .dword 0x7fd9e603a6a2a6c7, 0xfff1da61784fb9de
d_0_2:          .dword 0x6cb09447ddd69ecf, 0x5a63d1521b5c7fa4
d_0_3:          .dword 0x4cbb91db279b96c1, 0xbd6011a1bd471fad
d_0_4:          .dword 0x4e6a4f5a1a4b8f21, 0xc940c5b71b658c0e
d_0_5:          .dword 0xc913e81ff9899bcf, 0xa04e63f383a2079b
d_0_6:          .dword 0x1a494aa0062e5015, 0xccc42a4017d8a777
d_0_7:          .dword 0xab50c8f9da46c05c, 0xcef14c1f85c6d768
d_0_8:          .dword 0x7746002d519f9cb7, 0x7fdb625754daf569
d_0_9:          .dword 0xa4042cd495979b2e, 0x854a86d1047a04bb
d_0_10:         .dword 0x09c2fddb24d7240c, 0xd6b2c47c2241d179
d_0_11:         .dword 0xa0e0e2bd124918af, 0xa019b35e1cabe29d
d_0_12:         .dword 0xede9c7c101d86bda, 0x0715d390903ed7a7
d_0_13:         .dword 0x68610b7ec0025abb, 0xacca7e41325978d1
d_0_14:         .dword 0xa5f7e8df20ffb30e, 0x83cea56396610836
d_0_15:         .dword 0x5068b906c6c62d4c, 0x43e116896688f26b
d_0_16:         .dword 0x4cb2f3173cadf17e, 0x571374b22d77617c
d_0_17:         .dword 0xae647423cf205181, 0xddc4d793e928638a
d_0_18:         .dword 0x30aa1f40071cd6e2, 0x3e19de4686a30d83
d_0_19:         .dword 0x1ed747859e89ee2d, 0x4d4e086233693b95
d_0_20:         .dword 0x13c08e4631b00930, 0x41e69f9bd78dbc8e
d_0_21:         .dword 0x2888ab617ee7c82c, 0xde95cbda40e8094c
d_0_22:         .dword 0x3f255874c38f04d8, 0x9a71c244168eccf4
d_0_23:         .dword 0xd5c368e33813373f, 0x0e5dec0ffe05ac43
d_0_24:         .dword 0xb1787bd79519fea9, 0x86e51dfedf397ae8
d_0_25:         .dword 0x231a2c0dfaa27a22, 0x2023f56517890d59
d_0_26:         .dword 0x444189c661759ff5, 0x4e442a8ff7720660
d_0_27:         .dword 0xa0e4e55a2e294e88, 0xa2b54a13e8659e74
                .dword 0xd14d9dc3c1d9e5c5, 0xd872d6999a239b9f
                .dword 0x86081ff78f7c6c86, 0xd99e1f4fa163ef66
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa6b08a83ca6dd8d1, 0x9f95f6c796c6fe5c
                .dword 0xe600e0e3a86392e5, 0xee5cb607b3954d2a
d_1_0:          .dword 0x7e6d38b864f2f805, 0x02a19e1e4477a5d9
d_1_1:          .dword 0x75216ff46b4650fc, 0xd2e45b30830da4f1
d_1_2:          .dword 0x8160afc1f7371876, 0xc4d49e9e14387798
d_1_3:          .dword 0xba3e66ca1b8ad93b, 0x8f3d15bb1c534ae6
d_1_4:          .dword 0x23a445de6be52e85, 0xf63db24c5fe3c598
d_1_5:          .dword 0xecefb1a71fd4922e, 0xb47f042f39997c1d
d_1_6:          .dword 0xf46b144f21a13e68, 0xaa28a2467301acd4
d_1_7:          .dword 0xfa82ca8cbf92c20f, 0x4af4dbbf5e749740
d_1_8:          .dword 0xf93d5fbe51039019, 0xc91d4fd003fb05ab
d_1_9:          .dword 0xf076ebbcf5377114, 0xa2b8ff8bfd883373
d_1_10:         .dword 0x97137733c37ac9c8, 0xc5be9fa49f2bce8a
d_1_11:         .dword 0x8de235fff0e166be, 0x12cdd75df7a07962
d_1_12:         .dword 0xfabc217cc7dda733, 0xcf88b24a24b94f12
d_1_13:         .dword 0x676ecb1f5744709e, 0xc226998c3d886baf
d_1_14:         .dword 0x37bdcf4acc311c7b, 0x59b120e5a0e4ef00
d_1_15:         .dword 0x1d18d3536960d0e9, 0xafb9126e7ac508d3
d_1_16:         .dword 0xf8e3de8b6d5d8d77, 0x8e7084d17d99456b
d_1_17:         .dword 0x909e16c5b99a2078, 0x5b1d49229632c316
d_1_18:         .dword 0x332d1fa5b4cc8069, 0x06baf0236e9f37dd
d_1_19:         .dword 0x743a763e9d35448e, 0x1119175f38d3f245
d_1_20:         .dword 0xd7bc5e2caaf72af6, 0x3634bf347533187d
d_1_21:         .dword 0x11bf6c9715911998, 0x1afb85f8f8044d90
d_1_22:         .dword 0xf34b973262a053d1, 0xaac4788dd08367a5
d_1_23:         .dword 0x8ae68122fd602091, 0xf794b42a0e5a55b8
d_1_24:         .dword 0x9deff27c42091860, 0x5321bd3fa29508a0
d_1_25:         .dword 0x6888d8c4eeea4ab9, 0xe782c8ac44ffdba5
d_1_26:         .dword 0x208364efeb132ef8, 0x74e36ffe8eab1c38
d_1_27:         .dword 0x656d7f319ce8b8be, 0x4d8787ef9412135f
                .dword 0xb2f73b41f35b2fd8, 0x8c28db32a569ce30
                .dword 0xd039daa104143790, 0x7f19594440b8acac
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xecda9e9118f14d10, 0x24d065b910a45e67
                .dword 0x2d90f3abc726017e, 0x628c01d978f4a4d8
d_2_0:          .dword 0x907f7114d056e74a, 0x7106d2ef32dac153
d_2_1:          .dword 0xd9a7291aff48e08b, 0xb9214f38b3fe7740
d_2_2:          .dword 0xa38cfca5aeb7a9bd, 0xcfd146682ffbac9e
d_2_3:          .dword 0x7add20263775cc97, 0x3a78afd6ffc2298d
d_2_4:          .dword 0xf3fdcbecc19cd510, 0xe92a1dfe9f0dbd74
d_2_5:          .dword 0xc3d0e3d7393e4e94, 0x241bd2e0ad94a195
d_2_6:          .dword 0x557174543893bc85, 0xe9c2bce716e5659c
d_2_7:          .dword 0x9c7a4b3abe55fddd, 0xa8743ac0e6142769
d_2_8:          .dword 0x9ff2dbe2714c20b2, 0x766ef365f0bf79b7
d_2_9:          .dword 0x02fdc139ddbefd65, 0x3cd5b4df6f99b3da
d_2_10:         .dword 0xcb50971840ab2801, 0x5d7f9d94bcd48cea
d_2_11:         .dword 0xead04c6ca85c6bfe, 0xe09dcefd7b7739b3
d_2_12:         .dword 0x833c1cdf4e59f688, 0x4c3b0226812f77e8
d_2_13:         .dword 0x6b00231c98a73386, 0xc4b4bfde58b2ca79
d_2_14:         .dword 0x91d0d0fc07307776, 0x4ed8b15d4d004cf6
d_2_15:         .dword 0xccfdfe4f8491abe0, 0x839de62398c47f90
d_2_16:         .dword 0x77f7117d3791aadd, 0x53e3f095cb311f84
d_2_17:         .dword 0x1e51dcded3bfa9a1, 0x00b1a1c8bb4eb8a7
d_2_18:         .dword 0x83c33d92109ddcee, 0x5f28e8e40ff4c45c
d_2_19:         .dword 0xc4f28daee3abe0eb, 0x759f36b20adc45c4
d_2_20:         .dword 0xc41767568359b2ba, 0xd40aacb92715b6a7
d_2_21:         .dword 0xb2033565334b79d3, 0x83d0df16587db93c
d_2_22:         .dword 0x42dfa5dca62a3b45, 0xf05ee9f5a5ea066d
d_2_23:         .dword 0x8579826c1feaf59e, 0xf9e1f86028f56bc4
d_2_24:         .dword 0x891f5593931ab578, 0xe1eb36baf6c03e83
d_2_25:         .dword 0xf2c74697013116c0, 0x3d5b9d2a1d7568f6
d_2_26:         .dword 0xafc718b3f3611229, 0xd3353d92b82ced91
d_2_27:         .dword 0x34152cfaa43af072, 0x014dc1592431b77a
                .dword 0x5ffb2704bcfeb2f3, 0x99ae1d44aa5ec1a6
                .dword 0x5c9693260680c3a3, 0x32912450839108f4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x2adb0867b7556834, 0x4321ca1d0179ff82
                .dword 0xc9312527d536c1be, 0x5cb25fad067be772
d_3_0:          .dword 0x8cfe7972247b6a73, 0xede1a45c5ab64e37
d_3_1:          .dword 0xfc7253ed5876980d, 0x140bf4b55085d861
d_3_2:          .dword 0x6688c35af328cff1, 0x323365735d81e28f
d_3_3:          .dword 0x23a3b26e2a8c9914, 0xad7ace144cf15d94
d_3_4:          .dword 0xb7f762bfae7ca6f8, 0x3ab26730b5fd5f69
d_3_5:          .dword 0x588b515e0cda4bdb, 0x92e7b6de2c887322
d_3_6:          .dword 0xc17a393e3df73de1, 0xe1ebd5a40496b01e
d_3_7:          .dword 0x684fa919614e862b, 0x7d5e04f43e3a472a
d_3_8:          .dword 0xaa310531a6ee05b7, 0x733cb7119f71f0c9
d_3_9:          .dword 0x3b0498525a6843c9, 0x16e3369e8a3092e7
d_3_10:         .dword 0x2362192c000a3b01, 0x19b53168a55f36c7
d_3_11:         .dword 0xcaa4f4fa84f3deff, 0xb7ed4b339c903c14
d_3_12:         .dword 0xfe3bef2f9249ab71, 0x491494a337d122ce
d_3_13:         .dword 0x012921df52acbf22, 0x5aa42dcd5df0e3fb
d_3_14:         .dword 0xe669af47a6cc5f9b, 0x321053ac79669355
d_3_15:         .dword 0x8c7c041ec11e3bcb, 0xa94bd13936b8bdc2
d_3_16:         .dword 0xa76d0ea4b36e434a, 0xaa3f7fddad1cca87
d_3_17:         .dword 0xd50601ed488502cf, 0x6c25a74c6aed8626
d_3_18:         .dword 0x7d3a3a3f2064aa49, 0x2de08e051cc7ce95
d_3_19:         .dword 0x30a094418edbf9df, 0xfed488abe1086587
d_3_20:         .dword 0x60fb8ead9567cd11, 0x64ee9e1c1600a225
d_3_21:         .dword 0xabe678202df886fe, 0x9058928606c00000
d_3_22:         .dword 0x68589c2a8ece7500, 0x76b0ebf1c18d1f6c
d_3_23:         .dword 0x85a70ab03e0427e0, 0xc27ab17ee7cb3059
d_3_24:         .dword 0x64c2793690e24526, 0x6cfd6918e9f6dfa5
d_3_25:         .dword 0x446c59c8967b19d8, 0x62027418596436d8
d_3_26:         .dword 0x6334af7bf1e15c78, 0x0ca634bef2b32b0e
d_3_27:         .dword 0xe1ffbe482ec67d14, 0x6981cbb1f64db2b5
                .dword 0x9f553f8d5a23681b, 0x8880af2f40ad3336
                .dword 0x398098a524157e64, 0xe802a37baf711688
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xe501ef1431a49576, 0x775674ca7019495b
                .dword 0x74c1b6a05abb5a24, 0xf88fe82821366bd3
d_4_0:          .dword 0xcf34b0ed989f4005, 0xb6ba150fe4376199
d_4_1:          .dword 0x9972ad91f22810a7, 0x38e98090525c44d3
d_4_2:          .dword 0xb9f0d5806cddd5d5, 0x30d9184605a85f6a
d_4_3:          .dword 0x87fb004337eaeb74, 0xd769fccab572b295
d_4_4:          .dword 0x0ce0b20a59b89438, 0x51bdddf0757ef63f
d_4_5:          .dword 0xedfe6c8da647295e, 0xfb8a488f4aab4f4f
d_4_6:          .dword 0x32646ab03b2d5c31, 0x47c46404dac71785
d_4_7:          .dword 0x49a04b1240a25fb9, 0x5bc82fdecb99559c
d_4_8:          .dword 0x4c67ab1d27bac485, 0xdd8178bb03e2f7fb
d_4_9:          .dword 0x53119dd9409ea575, 0x82593f15e50cf208
d_4_10:         .dword 0x45865168ee1f5e43, 0x58e03e296027fc17
d_4_11:         .dword 0x0ea2528662ca019d, 0x03fac8ec12f40a95
d_4_12:         .dword 0xeb4ebe8841329efd, 0xd0c9ea6ba734a360
d_4_13:         .dword 0x0a4caae9a7cc0ec8, 0x535a5414c2702a26
d_4_14:         .dword 0xf908bc29297bae50, 0x715f796aac88f5fe
d_4_15:         .dword 0xd3a846219b8384bc, 0x7ab379e5e66799da
d_4_16:         .dword 0x07ab94abdcfce1f4, 0xaf14191014808a5e
d_4_17:         .dword 0x89922557c5ed2fe6, 0x73061abe1bc410e5
d_4_18:         .dword 0x9696abdcdb115192, 0x6a1913c03b3a06f6
d_4_19:         .dword 0x56c978d1518824b2, 0x7c7e78752b955d99
d_4_20:         .dword 0xd5f08846c559f7c7, 0x898ee36c73a834ec
d_4_21:         .dword 0x09974453eafbd55d, 0x311abb4904ec1ac6
d_4_22:         .dword 0xdc7ff39c7a9b87a2, 0x8b851770a1864563
d_4_23:         .dword 0x3a9ad618e4fc618a, 0xefed07129c280dad
d_4_24:         .dword 0x6c309ebae541acc3, 0xdc4fd20186cefa52
d_4_25:         .dword 0x1970d68f7c91717d, 0x590b16409621f971
d_4_26:         .dword 0x9d4552fb9fa9d923, 0xe689f89c7962f25c
d_4_27:         .dword 0x6ae91181d1473403, 0xf0e74f5547359916
                .dword 0xe3ee5b9abc74eeeb, 0x0605bd4f866a68fb
                .dword 0xa43076f48c0382ff, 0xfae2f44829876650
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x0720286d8175ed8b, 0x124fc676bbfeb26b
                .dword 0x1b8d3362a6bb00f4, 0xa664bbf859622170
d_5_0:          .dword 0x7d5041cf2a3c3994, 0x5897090a7fd09b44
d_5_1:          .dword 0x0f9daed1e5b2a777, 0x0aeed7608685d5ab
d_5_2:          .dword 0xa8e746e5c88780d6, 0x685e882d42ab09bd
d_5_3:          .dword 0x400b8c39eff5fb12, 0xc433b654b7fb1ead
d_5_4:          .dword 0xf3c169f579ff29d2, 0x3933d944e2403c89
d_5_5:          .dword 0xbbf4115d2d00877e, 0xe3f219786cd2b281
d_5_6:          .dword 0xcfe4c66294e91b63, 0x6121c014804ccbe7
d_5_7:          .dword 0x7a6720a9bb4b1962, 0xd643bb837ca4ce29
d_5_8:          .dword 0x9a6d73d917f62f6e, 0x693ecca552aaabc2
d_5_9:          .dword 0x37f7c7f9a888011c, 0x0e496d3aeacff6e2
d_5_10:         .dword 0xe67e9dd72579d0b0, 0x46c459e73fddf2c9
d_5_11:         .dword 0x4807bc546ae15fb1, 0xc3f3f6942ad7b817
d_5_12:         .dword 0x9546e57fb6951f45, 0x24e9220e7b211822
d_5_13:         .dword 0x43585e07c54135d7, 0xaa08d93c31540796
d_5_14:         .dword 0x1c1fb88587076aaa, 0xf6f61920e31ba7b6
d_5_15:         .dword 0x9e781215c2ee1732, 0xc212f4215d1c9508
d_5_16:         .dword 0xb84d3c50917a0838, 0x8f83f90f5d8007b7
d_5_17:         .dword 0xe2e3aad332f839ca, 0x835022701ae25cd7
d_5_18:         .dword 0x3473ca90666dd5cf, 0x6e3e9c459a1944a6
d_5_19:         .dword 0x68ab2baf552f2b30, 0x9e4cad76a4f76aeb
d_5_20:         .dword 0x1961298a0ade2da0, 0x684169dd3fe80ad1
d_5_21:         .dword 0x4b7ab365242a2b26, 0xb96684878b51aad3
d_5_22:         .dword 0x15bb7c35df9635e0, 0x1b8da73c3f00063d
d_5_23:         .dword 0x44a593ba1ca57b6c, 0x510ef319b04bb27c
d_5_24:         .dword 0x842ca1c485e31d5b, 0x1ce99aa1e1fb731d
d_5_25:         .dword 0x18307c886d1a9c6d, 0x85282827976acd8f
d_5_26:         .dword 0x37e527dc3b03b248, 0x43522b4f52ca5e8a
d_5_27:         .dword 0x7b15bd672d3dbd2c, 0xbcfebd9998a9ae6c
                .dword 0x4876757dd8091017, 0x55918bded53381e5
                .dword 0xde98df3d8dafc781, 0x12bfc123dba52889
         /* Random data */
_end_data5:
              
                 
