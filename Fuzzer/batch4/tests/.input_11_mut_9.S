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
_s0:    la x9, d_5_9                              ;
        srai x9, x9, 1                            ;
        csrrc x8, pmpaddr7, x9                    ;
_s1:    bgeu x8, x11, _s4                                 ;
_s2:    lui x1, 1998                              ;
_s3:    lui x11, 803507                           ;
_s4:;
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
_p0:    la x10, d_4_25                            ;
        srai x10, x10, 1                          ;
        csrrc x14, pmpaddr4, x10                  ;
_p1:    xor x13, x13, x13                         ;
        csrrs x10, stval, x13                     ;
_p2:    xor x11, x11, x11                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 0                          ;
        add x11, x11, x12                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 14                         ;
        add x11, x11, x13                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 26                         ;
        add x11, x11, x10                         ;
        csrrc x14, mcause, x11                    ;
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
_l0:    beq x12, x10, _l97                                ;
_l1:    la x7, d_1_1                              ;
        addi x7, x7, 4                            ;
        lui x13, 0xffe00                          ;
        xor x7, x7, x13                           ;
        amomin.w x10, x13, (x7)                   ;
_l2:    csrrsi x5, pmpcfg0, 16                    ;
_l3:    slliw x27, x16, 31                        ;
_l4:    div x27, x25, x2                          ;
_l5:    fadd.s f3, f10, f11, dyn                  ;
_l6:    fence                                     ;
_l7:    la x24, _l87                                      ;
        csrrw zero, mepc, x24                     ;
        mret                                      ;
_l8:    fence.i                                   ;
_l9:    la x28, d_4_25                            ;
        addi x28, x28, 0                          ;
        amominu.d x29, x1, (x28)                  ;
_l10:   la x17, d_2_9                             ;
        addi x17, x17, -0                         ;
        amomax.d x26, x27, (x17)                  ;
_l11:   addiw x28, x15, 510                       ;
_l12:   la x25, _l54                                      ;
        lw x9, 4(x25)                             ;
_l13:   bne x11, x14, _l71                                ;
_l14:   la x29, d_3_18                            ;
        sd x17, 0(x29)                            ;
_l15:   la x20, d_1_7                             ;
        ld x22, -0(x20)                           ;
_l16:   jal x26, _l38                                     ;
_l17:   fmv.w.x f31, x24                          ;
_l18:   fence.i                                   ;
_l19:   la x14, d_3_0                             ;
        addi x14, x14, 8                          ;
        lui x28, 0xffe00                          ;
        xor x14, x14, x28                         ;
        amomin.w x20, x28, (x14)                  ;
_l20:   la x29, d_1_6                             ;
        addi x29, x29, -28                        ;
        amomaxu.w x27, x13, (x29)                 ;
_l21:   fmin.s f4, f4, f4                         ;
_l22:   csrrsi x13, pmpcfg0, 31                   ;
_l23:   fence.i                                   ;
_l24:   la x13, d_1_14                            ;
        ld x13, 16(x13)                           ;
_l25:   fmv.x.w x11, f22                          ;
_l26:   csrrci x11, pmpcfg0, 16                   ;
_l27:   xori x4, x25, 47                          ;
_l28:   feq.s x29, f10, f31                       ;
_l29:   xor x4, x4, x4                            ;
        addi x12, zero, 3                         ;
        slli x12, x12, 6                          ;
        add x4, x4, x12                           ;
        addi x26, zero, 3                         ;
        slli x26, x26, 15                         ;
        add x4, x4, x26                           ;
        csrrw x4, sstatus, x4                     ;
_l30:   la x25, d_5_15                            ;
        flw f13, 20(x25)                          ;
_l31:   addi x13, x11, -1998                      ;
_l32:   flt.s x10, f23, f30                       ;
_l33:   la x7, d_2_21                             ;
        addi x7, x7, -16                          ;
        amominu.d x21, x8, (x7)                   ;
_l34:   csrrsi x20, mie, 5                        ;
_l35:   mulw x7, x28, x20                         ;
_l36:   fmul.s f16, f7, f17, dyn                  ;
_l37:   la x10, d_5_17                            ;
        sw x27, -8(x10)                           ;
_l38:   la x28, d_4_15                            ;
        addi x28, x28, -12                        ;
        amoswap.w x28, x17, (x28)                 ;
_l39:   li x28, 1                                 ;
        la x21, pt3                               ;
        addi x21, x21, 16                         ;
        sfence.vma x28, x21                       ;
_l40:   la x14, d_4_19                            ;
        addi x14, x14, -28                        ;
        sc.w x24, x4, (x14)                       ;
_l41:   fsub.s f2, f18, f0, rmm                   ;
_l42:   fmsub.s f24, f26, f13, f16, rup           ;
_l43:   bgeu x9, x18, _l88                                ;
_l44:   mulhsu x25, x10, x14                      ;
_l45:   mulhu x1, x15, x28                        ;
_l46:   la x11, d_2_20                            ;
        ld x25, -8(x11)                           ;
_l47:   xori x6, x18, -1674                       ;
_l48:   la x12, d_3_24                            ;
        addi x12, x12, 0                          ;
        amomin.d x1, x1, (x12)                    ;
_l49:   la x11, d_0_17                            ;
        addi x11, x11, -16                        ;
        sc.w x9, x26, (x11)                       ;
_l50:   mulh x13, x16, x23                        ;
_l51:   li x4, 0                                  ;
        la x25, pt0                               ;
        addi x25, x25, 56                         ;
        sfence.vma x4, x25                        ;
_l52:   slti x5, x19, 1817                        ;
_l53:   fle.s x7, f11, f8                         ;
_l54:   la x25, d_1_12                            ;
        sh x3, 16(x25)                            ;
_l55:   la x28, d_1_26                            ;
        addi x28, x28, -24                        ;
        amoand.w x18, x30, (x28)                  ;
_l56:   la x3, d_1_17                             ;
        addi x3, x3, 0                            ;
        amomaxu.w x22, x3, (x3)                   ;
_l57:   slliw x25, x3, 8                          ;
_l58:   andi x22, x26, -7                         ;
_l59:   divu x16, x29, x1                         ;
_l60:   fcvt.s.w f30, x7, rdn                     ;
_l61:   sltiu x23, x23, 306                       ;
_l62:   la x15, d_1_22                            ;
        addi x15, x15, -8                         ;
        lui x17, 0xffe00                          ;
        xor x15, x15, x17                         ;
        sc.w x7, x17, (x15)                       ;
_l63:   feq.s x27, f21, f0                        ;
_l64:   addi x25, x4, 48                          ;
_l65:   bne x4, x17, _l83                                 ;
_l66:   fcvt.s.l f23, x6, rup                     ;
_l67:   la x29, d_5_19                            ;
        addi x29, x29, 16                         ;
        amomin.d x28, x25, (x29)                  ;
_l68:   remu x23, x15, x12                        ;
_l69:   fmax.s f28, f26, f21                      ;
_l70:   la x20, d_0_11                            ;
        addi x20, x20, 28                         ;
        amoor.w x2, x4, (x20)                     ;
_l71:   bltu x20, x16, _l91                               ;
_l72:   ebreak                                    ;
_l73:   la x1, d_4_11                             ;
        addi x1, x1, -8                           ;
        amoadd.d x5, x5, (x1)                     ;
_l74:   la x10, d_5_16                            ;
        addi x10, x10, -16                        ;
        amoand.d x8, x30, (x10)                   ;
_l75:   la x29, d_3_23                            ;
        lhu x2, -6(x29)                           ;
_l76:   srai x28, x10, 17                         ;
_l77:   la x22, d_2_1                             ;
        addi x22, x22, 0                          ;
        amoswap.d x13, x13, (x22)                 ;
_l78:   rem x15, x3, x19                          ;
_l79:   la x30, d_5_2                             ;
        addi x30, x30, -0                         ;
        amomaxu.w x14, x15, (x30)                 ;
_l80:   la x21, d_3_18                            ;
        addi x21, x21, -12                        ;
        amoxor.w x11, x30, (x21)                  ;
_l81:   fsgnjn.s f10, f2, f21                     ;
_l82:   lui x9, 0                                 ;
_l83:   remu x19, x11, x29                        ;
_l84:   csrrci x19, pmpaddr7, 0                   ;
_l85:   la x27, d_2_23                            ;
        fsw f10, -8(x27)                          ;
_l86:   mul x23, x0, x30                          ;
_l87:   jal x30, _l97                                     ;
_l88:   fadd.s f31, f16, f17, rdn                 ;
_l89:   slliw x25, x1, 28                         ;
_l90:   xor x14, x14, x14                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 10                         ;
        add x14, x14, x29                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 20                         ;
        add x14, x14, x18                         ;
        csrrc x7, satp, x14                       ;
_l91:   la x16, d_3_14                            ;
        lbu x19, 31(x16)                          ;
_l92:   la x21, d_2_0                             ;
        sh x7, -16(x21)                           ;
_l93:   la x10, d_3_0                             ;
        addi x10, x10, 4                          ;
        amoswap.w x15, x8, (x10)                  ;
_l94:   srlw x5, x3, x0                           ;
_l95:   xor x28, x28, x28                         ;
        addi x25, zero, 1                         ;
        slli x25, x25, 29                         ;
        add x28, x28, x25                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 2                          ;
        add x28, x28, x27                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 20                         ;
        add x28, x28, x23                         ;
        csrrc x3, stval, x28                      ;
_l96:   slti x12, x18, 17                         ;
_l97:   srai x25, x2, 35                          ;
_l98:   la x9, d_3_16                             ;
        addi x9, x9, 0                            ;
        amomin.d x13, x13, (x9)                   ;
_l99:   sraw x7, x20, x24                         ;
_l100:  mulhu x7, x29, x18                        ;
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
                .dword 0x5b110658a33170bc, 0x5d95772edeb2e925
                .dword 0xff1bb58f10a52c8d, 0xb3481081db92158a
d_0_0:          .dword 0x8af6a3fc179cc86f, 0x1ff79fb81c2ed27c
d_0_1:          .dword 0x2a7900833689568c, 0xeccbc1fc664b9f95
d_0_2:          .dword 0x6375d56cef8b09f0, 0xcc7a06555462c08b
d_0_3:          .dword 0x0eec8daf8bd97d8a, 0x4267af050dfb7d5a
d_0_4:          .dword 0x776d78ea214c2950, 0x503feda17237656f
d_0_5:          .dword 0x72cdcfcffa912c71, 0x0548f5d24b90abb6
d_0_6:          .dword 0xf1f92f27082e3480, 0x4ffaba196dcaa4e4
d_0_7:          .dword 0xf6bd443b7989cea9, 0xf46bfeb012f580fb
d_0_8:          .dword 0x0370f5a525ec7ae6, 0x97c635150b90bd5e
d_0_9:          .dword 0x6faf6b063dac22ae, 0x96be617a8a5dd1ad
d_0_10:         .dword 0xaafd302d09a9c963, 0x7b2b5a0b9a81db1c
d_0_11:         .dword 0x72bf3dfb8f6b8022, 0xa26953ccfe81afd0
d_0_12:         .dword 0x284a03e58669a927, 0x59f6511248364b22
d_0_13:         .dword 0x6d4f6cffeed9c537, 0x394fa1eb63bef67f
d_0_14:         .dword 0x519a72e8420853c6, 0xc6e3b41a44ebb57d
d_0_15:         .dword 0x649e722a0b60668f, 0xe9a1a84999848557
d_0_16:         .dword 0x6dfb0b0e2551f3b8, 0x1efcba18a6cf5674
d_0_17:         .dword 0xbfec343fadb65016, 0x8106a73dafbbdf37
d_0_18:         .dword 0x25b590f72418498e, 0xc28cff47e223e483
d_0_19:         .dword 0x219d0e938aa9cfa1, 0x3a3215f2fca4fe09
d_0_20:         .dword 0x1adb3cea0c3c3ad9, 0x5f91fb2031c1f7be
d_0_21:         .dword 0x994f2d8a621e7c95, 0x2cf178b795b82ffb
d_0_22:         .dword 0x3059398e41f720b6, 0x0a7fe3cfd0e55913
d_0_23:         .dword 0xe78a759272ca600c, 0xb93edc0983ff0e68
d_0_24:         .dword 0xc63d4819973617d8, 0xf5570fd26475a65d
d_0_25:         .dword 0x663e47fe389046a7, 0xbb2496c5a1bf4da2
d_0_26:         .dword 0xbd9bd186243f2166, 0x92e08f2b44767066
d_0_27:         .dword 0x9764c7b5b4029af0, 0x5c6c674b2a423eb8
                .dword 0xb099c8fe6d196363, 0x1247bf47d9746876
                .dword 0x1f677c77db1b4f50, 0x883e94c273092b53
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x1579893d68f4aa3a, 0x202cdeea17a0fab4
                .dword 0x2cee85b6ad88c675, 0xbfa8a069935c97f6
d_1_0:          .dword 0xc7a2a6991da0f852, 0x3eff0042c9edb3e5
d_1_1:          .dword 0xdff3d8bea0384ca8, 0x1f4f1712bc5bcf08
d_1_2:          .dword 0x7a581e20a5a03655, 0xab036992a09ce086
d_1_3:          .dword 0x886ce14908a54e15, 0x95719b55335e7931
d_1_4:          .dword 0xcf13c0ee21ea2a4c, 0x49adc97621a3496d
d_1_5:          .dword 0x6ba00284338da965, 0x4d81e48a892c51af
d_1_6:          .dword 0x195aa5e2574162ef, 0x7db6d260d96d39df
d_1_7:          .dword 0xfd76ae9d1bf32f50, 0x925ae9e327aebd35
d_1_8:          .dword 0xec0f1fabc3e577d8, 0x619be9d57fccdf8a
d_1_9:          .dword 0x2ff20fa6e4bd6bde, 0x1e26aec8b2f2c2ec
d_1_10:         .dword 0x6f0210851d4aee6d, 0x894ec9a983dd7675
d_1_11:         .dword 0x7540b1fe6a5d4218, 0x3428b47d0d7f8f21
d_1_12:         .dword 0xa5ed92780a94c1f9, 0x1931a4bc291f0e47
d_1_13:         .dword 0xf877137b79441bb5, 0xc9cfecbc560ea063
d_1_14:         .dword 0x15ca75b3c804a69b, 0x3b281a0c28c2187a
d_1_15:         .dword 0x3ab984e5ad52eb6b, 0x81a42a42b894ee26
d_1_16:         .dword 0x38cc98ddd8557653, 0x6eb4cea14a7801c5
d_1_17:         .dword 0x283a60ec909b0f72, 0x3b87b360e431ba41
d_1_18:         .dword 0xadfd30d4bd2903fc, 0x9fb0537fe7672157
d_1_19:         .dword 0x9ad2cdb5ebd67454, 0x808407f5d2f9c6a7
d_1_20:         .dword 0xa68b64903c22341a, 0xa8317d18a462a364
d_1_21:         .dword 0x1b23b71005fc8744, 0xd841e35fb7463c06
d_1_22:         .dword 0xc341f17d59303a99, 0x7e7f4d2b73a4e682
d_1_23:         .dword 0xdd7bdabfa4700705, 0x1ed72375a8e502b9
d_1_24:         .dword 0x7455707121710eac, 0x1c84a86c124906c1
d_1_25:         .dword 0x155ab4b8e6618372, 0x0de08bd2b10c6e6f
d_1_26:         .dword 0x38d75de6cbbfc836, 0xab86ae06c1f056c4
d_1_27:         .dword 0x38d89012c7232577, 0xcbbf478b5ee82031
                .dword 0xa1b73d2d569070c2, 0x5c0ab8b35f401296
                .dword 0x383c2f41d78666c9, 0x2f11440d66fbe275
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x46c5c65bf1759f0e, 0x91ae12247a4d6982
                .dword 0x8c5c5b89ff2b7ca0, 0xf9b40498069974d8
d_2_0:          .dword 0xa81f16a3f8ff0c40, 0x272872c48bf1832d
d_2_1:          .dword 0xfb8dd13db819784c, 0x0d5c35d0ea5be420
d_2_2:          .dword 0xe228b50b0cb6e553, 0xa4657bed0fd33dc6
d_2_3:          .dword 0xac233e368a8887c9, 0x4bec9f1686db4eff
d_2_4:          .dword 0x40caa3b62e676698, 0xcf7d2e717fd3f978
d_2_5:          .dword 0x6c1a8e29e2a22413, 0x8de81f03dcd68016
d_2_6:          .dword 0xb847b1181a29c5cb, 0x89eaaed2d5f84a90
d_2_7:          .dword 0x4e2ac6d976d67413, 0x5e7b9d1506369887
d_2_8:          .dword 0xc5132dac592ec762, 0xbb2f23407d51f995
d_2_9:          .dword 0xe01c8103752bc2e1, 0xd1cfca40133af11f
d_2_10:         .dword 0x5b944191bac38c26, 0x0378e60f3b7c845c
d_2_11:         .dword 0x7825cb0b89c226ed, 0x64802f10dc65c468
d_2_12:         .dword 0xba0bfebc4db08682, 0xf571ecd58fcc00a8
d_2_13:         .dword 0x4a62f17ac26836ff, 0x8a87ea9567768906
d_2_14:         .dword 0xd9db6d648e5eb16a, 0x3236bc3048893a2e
d_2_15:         .dword 0x0879658053bf3d81, 0x1a8540825f21c79b
d_2_16:         .dword 0xc2cd4bcd25d2310a, 0x94b7a204ef479f83
d_2_17:         .dword 0xe0684117096ed50c, 0xfcf2303e8a46fad5
d_2_18:         .dword 0x563e4aa02bf6dec0, 0x4f1ceafa89c10897
d_2_19:         .dword 0xb769862293371786, 0x2fa6b1ef2514ae17
d_2_20:         .dword 0x90f4cbab3186449e, 0x07462e3f2df23e97
d_2_21:         .dword 0xa1d0a84f3a4f891c, 0x50f6169a74bdbd19
d_2_22:         .dword 0xcd758ed35923ede9, 0x1348f78d0784f11e
d_2_23:         .dword 0xef817fabd31fcb11, 0x5e132a865031c51f
d_2_24:         .dword 0xa92eface7d7f427b, 0xbf9087f050f7fa5f
d_2_25:         .dword 0x0b082fb8e63e1793, 0xd5ffe9bd0068f543
d_2_26:         .dword 0xb2d7c205d87c2e2e, 0xad3899c8c66675a1
d_2_27:         .dword 0x201a4e36c3d706ae, 0xc48de3cd5902beb1
                .dword 0x066115d84515e046, 0x0541f5b165382a6a
                .dword 0x92c19d1f9bba8543, 0x88ac3dfd1e066cb4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xcdf57f1eade24e48, 0x2cf696caedb96f91
                .dword 0x06b6f02a7debea42, 0xa6b852abae70d29f
d_3_0:          .dword 0xc45f502ce019da47, 0xcb7e191d2ac09618
d_3_1:          .dword 0x54d66d6583166d1d, 0x8e0d35dbf1f51ae3
d_3_2:          .dword 0xfcc132600ef5ad4a, 0x40a8cdcadd732e4d
d_3_3:          .dword 0xab27bbc5c7cc4472, 0x33d392957988381b
d_3_4:          .dword 0xf92013c76b1999f0, 0x4b7d2ed533377b7d
d_3_5:          .dword 0xa08f332ea3c46f75, 0x3159924cabbd6d97
d_3_6:          .dword 0xde542407b57ab8b8, 0xde89169d93e9f3c7
d_3_7:          .dword 0x61fe7793842efcac, 0x27e4cd08fa70df24
d_3_8:          .dword 0x2501601c3e33bf64, 0x25123e2b051bc157
d_3_9:          .dword 0xd6866f0b04e29c53, 0xa701c5eddb5750f5
d_3_10:         .dword 0x215f0672e4b73f89, 0x0c3a5b7a526b5be6
d_3_11:         .dword 0x0a55d73badadbad2, 0x9cd818c56ec0fe00
d_3_12:         .dword 0x5c02b224a25b77a5, 0x146eb15292aedc84
d_3_13:         .dword 0x612f71f02bbb1d15, 0x706ad87c404511a8
d_3_14:         .dword 0x5e9c1e4ccd6e8752, 0x671c0e8b6304751c
d_3_15:         .dword 0xe505d6d1d02ee140, 0x989ec54d2d0d8b1c
d_3_16:         .dword 0x754faf9bae27eaf4, 0xd71e4d98d429b1a1
d_3_17:         .dword 0x9a7ccd72e381955d, 0x61969f3ae9091dba
d_3_18:         .dword 0xd91f64ecc18ee17d, 0x22def7614d91d1fe
d_3_19:         .dword 0x65296e976018ea84, 0x8f2022851efb51ad
d_3_20:         .dword 0x71da1167c63e32b4, 0xb470d6dfb0caf79b
d_3_21:         .dword 0x53c62438e027b7e7, 0x8b5c78939bcbdaff
d_3_22:         .dword 0x5edb8486cfe4deea, 0x5501e51776beee1a
d_3_23:         .dword 0x99f7dfa02d3854cb, 0x1d71d399dcd3284a
d_3_24:         .dword 0xb8a6b09ae07005cc, 0x46cfaa4030c23d85
d_3_25:         .dword 0x2b700c42d8aa41b8, 0x569e36256e9b2763
d_3_26:         .dword 0xe3fa708405c3b98b, 0xf5ebd3016a8cf23d
d_3_27:         .dword 0xa2f1c97cc3991b14, 0xf720212feb5145ba
                .dword 0xbbf44758b05b8216, 0x66a7e449f3ebc39b
                .dword 0x5bcf53f14c707a96, 0xb912dad237f5f481
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x267a906544b3ebca, 0x4f25bb3d024e39f0
                .dword 0xf3ef2b001107d41e, 0x4fe775c29db90de2
d_4_0:          .dword 0x7b55bbd9c70490c9, 0xad0a2d00aa45e92b
d_4_1:          .dword 0xa3fb19dec288ec6c, 0x4cf467d91dfcfa0f
d_4_2:          .dword 0x402926d2b6e4401d, 0x2a4327ed9d0638cb
d_4_3:          .dword 0x0d9b634a87902a54, 0x46807e433ad32e71
d_4_4:          .dword 0x0bb9bf3cf0a72b5b, 0x31cf598b07e3a915
d_4_5:          .dword 0x7bd87a07bb42a1bd, 0x2549a36c7c5bd415
d_4_6:          .dword 0x914b4997bc78b52e, 0xc5cc7d07f2d9db60
d_4_7:          .dword 0x2e800a7ce57949f0, 0xa803bc881cf5e201
d_4_8:          .dword 0x784582a1288fa01c, 0x645b329a5a029b07
d_4_9:          .dword 0x41a0e3d4ae4326c9, 0x6d7d0e83b632748b
d_4_10:         .dword 0x7fa310fc67c8528e, 0xbbf3cb67c891a776
d_4_11:         .dword 0xf097d58a28b2421b, 0x82bdeb068e05d698
d_4_12:         .dword 0xc3c1861019f15227, 0xe58a81d99ab1d100
d_4_13:         .dword 0x7469e7ce14319493, 0x2506ae209fa4ae57
d_4_14:         .dword 0xaa1b3aaf20879059, 0x65f3eac8086027ed
d_4_15:         .dword 0x348fb6e0376ae799, 0x0f2a795a80bd0186
d_4_16:         .dword 0xc66efbb1c0cf54f2, 0x683dcb2f467bd6d8
d_4_17:         .dword 0xe051fa6abf2d6cc7, 0xb68e1afbf2181bf4
d_4_18:         .dword 0x5dbaea05891ddf6b, 0xd85b425fb5b11e93
d_4_19:         .dword 0x9369d7f59759b260, 0x1b12a077d31da26d
d_4_20:         .dword 0xc632c17a7ee4cfac, 0x22b47a9f013afc9f
d_4_21:         .dword 0xbe044573585bf586, 0x16a1771b63d6cc60
d_4_22:         .dword 0x276ffd43ae4e05a0, 0x3aa071844b531614
d_4_23:         .dword 0x87e06a00a36d77e3, 0x5358dd3026b1d9c7
d_4_24:         .dword 0x4ee4d934f357d506, 0x4989df467c6a1727
d_4_25:         .dword 0x9c4428d9f21d1526, 0x0d7af4106fd8f155
d_4_26:         .dword 0x479aa1b8e181385f, 0xbe91deeed391a9b1
d_4_27:         .dword 0x76813f0ae76e71df, 0x426f4b504b82e22f
                .dword 0xe8786d4db0a1ab78, 0x309f868d1e1d7cb2
                .dword 0x0ea34d0956260a8f, 0x97b3d49761ad6cf2
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4d4f876f305202ee, 0x5ff14ad6208189e4
                .dword 0x721e11017ad337e2, 0x962beeb8b3814b34
d_5_0:          .dword 0x8192c55718afb322, 0xdcdef42099d6b315
d_5_1:          .dword 0x2109047e5a774e71, 0xb5e5d1e3992d6517
d_5_2:          .dword 0xd00e7b5ab306b468, 0xbd90b9955c0a8618
d_5_3:          .dword 0x50f4b6f87c33fcb3, 0x9c55a89aab7f2f65
d_5_4:          .dword 0xd0d7aa4dde5e3838, 0xf88d9e838d7b9ff7
d_5_5:          .dword 0x768dc6f1c4ba24d2, 0xe5e5b617cedaed64
d_5_6:          .dword 0x635fab921f588f79, 0x36db82f7d1926bd4
d_5_7:          .dword 0x68b792a36d6c9248, 0x82d155c375fe0eea
d_5_8:          .dword 0x2cf4c5c332b2b7e8, 0x2e06daae423db979
d_5_9:          .dword 0x807c514386643873, 0xcf57dadfe9bbab57
d_5_10:         .dword 0xe628d31b974fb5f8, 0x3f660d95bafd057f
d_5_11:         .dword 0x8fbdfaa5f56f0400, 0xadc33d1adfd8ea5b
d_5_12:         .dword 0xae8eb3d5b97ca514, 0xb2a66c12cf50544c
d_5_13:         .dword 0x050ab724a0690b64, 0x78964e1023335bb4
d_5_14:         .dword 0x7ceabc9998f6a502, 0x380e0de3a0b08ac1
d_5_15:         .dword 0x4fa1544cd7e22c94, 0x617978e5754f9522
d_5_16:         .dword 0xc4c077bf1ae28e56, 0xa8fb1a5d9e567b50
d_5_17:         .dword 0x55741c5e84c69a09, 0xf9dc1e1adf9ec0f7
d_5_18:         .dword 0x8a88db0b9fc6e339, 0x9031e7497ccac29d
d_5_19:         .dword 0xb9d91a6898a4fd9c, 0xadc30fd6211ea428
d_5_20:         .dword 0xafce4b679eaaf7f5, 0x5edfd1bafadc387a
d_5_21:         .dword 0xed38af9d3cc3d202, 0x242853b331a712f1
d_5_22:         .dword 0x2677d5b5ca548163, 0x596cb033e5c4813e
d_5_23:         .dword 0xcce195082e8f079f, 0x5baef0d617006af3
d_5_24:         .dword 0x36149d525ca2df6c, 0xd1b58cba4640c2fd
d_5_25:         .dword 0xf2c47d1d427c3614, 0x735b2145827e51cc
d_5_26:         .dword 0x22dfb17a0524907f, 0xe8e4789ebcc0df2c
d_5_27:         .dword 0x9ac33e6b2a6a885a, 0x3a26dea150952a68
                .dword 0xc2c61ae2615c3a30, 0xaf37a800ba4ef72f
                .dword 0x1bf424dff9746dda, 0x0e4a977107ab621a
         /* Random data */
_end_data5:
              
                 
