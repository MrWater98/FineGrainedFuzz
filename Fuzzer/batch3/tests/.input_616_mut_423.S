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
_s0:    divu x26, x24, x16                        ;
_s1:    mulh x6, x21, x17                         ;
_s2:    ebreak                                    ;
_s3:;
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
_p0:    csrrci x10, pmpaddr7, 0                   ;
_p1:    csrrsi x13, sip, 12                       ;
_p2:    xor x11, x11, x11                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 15                         ;
        add x11, x11, x11                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 28                         ;
        add x11, x11, x14                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 27                         ;
        add x11, x11, x12                         ;
        csrrs x10, sip, x11                       ;
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
_l0:    div x5, x13, x17                          ;
_l1:    fence.i                                   ;
_l2:    la x22, d_3_16                            ;
        addi x22, x22, 8                          ;
        amoor.d x28, x22, (x22)                   ;
_l3:    mulh x19, x11, x14                        ;
_l4:    fadd.s f28, f25, f28, rne                 ;
_l5:    ebreak                                    ;
_l6:    slli x28, x25, 63                         ;
_l7:    sllw x0, x21, x5                          ;
_l8:    xor x14, x14, x14                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 10                           ;
        add x14, x14, x1                          ;
        addi x26, zero, 3                         ;
        slli x26, x26, 11                         ;
        add x14, x14, x26                         ;
        addi x20, zero, 3                         ;
        slli x20, x20, 23                         ;
        add x14, x14, x20                         ;
        csrrs x18, mcause, x14                    ;
_l9:    mul x10, x19, x19                         ;
_l10:   beq x24, x20, _l40                                ;
_l11:   csrrci x24, mip, 0                        ;
_l12:   fcvt.lu.s x8, f23, rne                    ;
_l13:   la x16, d_0_17                            ;
        addi x16, x16, -0                         ;
        amomin.d x26, x21, (x16)                  ;
_l14:   sraw x22, x24, x22                        ;
_l15:   remw x12, x6, x8                          ;
_l16:   srli x15, x24, 23                         ;
_l17:   remuw x17, x0, x16                        ;
_l18:   fmsub.s f10, f12, f22, f19, dyn           ;
_l19:   ecall                                     ;
_l20:   fcvt.s.wu f22, x28, rup                   ;
_l21:   mul x14, x15, x10                         ;
_l22:   la x24, d_3_15                            ;
        addi x24, x24, -20                        ;
        lui x15, 0xffe00                          ;
        xor x24, x24, x15                         ;
        amoand.w x12, x15, (x24)                  ;
_l23:   fmin.s f4, f25, f12                       ;
_l24:   la x17, d_2_27                            ;
        sb x6, -3(x17)                            ;
_l25:   divu x6, x5, x6                           ;
_l26:   remuw x12, x18, x7                        ;
_l27:   la x25, d_5_19                            ;
        addi x25, x25, -0                         ;
        amoand.d x5, x6, (x25)                    ;
_l28:   la x4, d_1_7                              ;
        addi x4, x4, 0                            ;
        sc.d x17, x4, (x4)                        ;
_l29:   la x7, d_5_7                              ;
        addi x7, x7, 8                            ;
        lr.w x3, (x7)                             ;
_l30:   xor x19, x19, x19                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 21                         ;
        add x19, x19, x14                         ;
        csrrc x21, sstatus, x19                   ;
_l31:   la x5, _l71                                       ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l32:   fmax.s f25, f28, f18                      ;
_l33:   mul x14, x29, x15                         ;
_l34:   mulh x19, x27, x17                        ;
_l35:   la x22, d_5_3                             ;
        addi x22, x22, 0                          ;
        amoor.d x17, x4, (x22)                    ;
_l36:   la x30, d_1_23                            ;
        addi x30, x30, 0                          ;
        amoor.d x21, x18, (x30)                   ;
_l37:   mul x4, x16, x27                          ;
_l38:   la x15, d_2_14                            ;
        addi x15, x15, 4                          ;
        amoswap.w x29, x29, (x15)                 ;
_l39:   auipc x29, 12                             ;
_l40:   beq x23, x29, _l123                               ;
_l41:   fcvt.wu.s x28, f26, rup                   ;
_l42:   addiw x25, x30, -324                      ;
_l43:   la x30, d_0_16                            ;
        lwu x11, 0(x30)                           ;
_l44:   fmax.s f29, f6, f13                       ;
_l45:   ecall                                     ;
_l46:   la x17, d_1_5                             ;
        addi x17, x17, 8                          ;
        amomax.d x2, x8, (x17)                    ;
_l47:   fcvt.s.lu f16, x6, rdn                    ;
_l48:   fcvt.s.lu f8, x29, rne                    ;
_l49:   fcvt.s.l f14, x21, rdn                    ;
_l50:   xor x28, x28, x28                         ;
        csrrs x29, mepc, x28                      ;
_l51:   la x18, d_3_7                             ;
        addi x18, x18, 8                          ;
        lui x5, 0xffe00                           ;
        xor x18, x18, x5                          ;
        lr.d x14, (x18)                           ;
_l52:   la x15, d_1_25                            ;
        addi x15, x15, 0                          ;
        amoand.d x15, x23, (x15)                  ;
_l53:   addiw x3, x10, -57                        ;
_l54:   mul x30, x24, x0                          ;
_l55:   la x15, d_5_19                            ;
        ld x12, 16(x15)                           ;
_l56:   la x21, d_3_2                             ;
        addi x21, x21, -16                        ;
        amomin.d x1, x23, (x21)                   ;
_l57:   ecall                                     ;
_l58:   addi x13, x12, -1431                      ;
_l59:   sltiu x5, x25, -1628                      ;
_l60:   la x11, d_4_14                            ;
        addi x11, x11, -12                        ;
        amoswap.w x28, x16, (x11)                 ;
_l61:   fmax.s f31, f10, f28                      ;
_l62:   la x4, d_0_9                              ;
        addi x4, x4, 0                            ;
        lr.d x6, (x4)                             ;
_l63:   mulhu x8, x22, x28                        ;
_l64:   jal x18, _l98                             ;
_l65:   feq.s x1, f28, f31                        ;
_l66:   la x12, d_2_17                            ;
        fsw f14, 24(x12)                          ;
_l67:   la x21, _l89                                      ;
        lhu x19, -22(x21)                         ;
_l68:   la x14, _l112                                     ;
        lbu x1, -27(x14)                          ;
_l69:   fsgnjn.s f25, f16, f0                     ;
_l70:   csrrsi x27, mcause, 26                    ;
_l71:   rem x2, x6, x1                            ;
_l72:   fsgnjn.s f22, f29, f30                    ;
_l73:   ebreak                                    ;
_l74:   fcvt.lu.s x11, f14, rdn                   ;
_l75:   la x1, _l67                                       ;
        lw x16, 4(x1)                             ;
_l76:   fnmsub.s f25, f19, f31, f1, rmm           ;
_l77:   srlw x27, x2, x18                         ;
_l78:   la x4, d_2_23                             ;
        addi x4, x4, 8                            ;
        amoor.w x11, x13, (x4)                    ;
_l79:   blt x3, x14, _l99                         ;
_l80:   la x24, d_0_21                            ;
        addi x24, x24, 16                         ;
        lr.d x7, (x24)                            ;
_l81:   fcvt.wu.s x29, f27, rmm                   ;
_l82:   fcvt.lu.s x4, f28, rup                    ;
_l83:   andi x27, x16, 12                         ;
_l84:   mulw x12, x21, x30                        ;
_l85:   la x28, d_4_13                            ;
        addi x28, x28, -0                         ;
        lui x3, 0xffe00                           ;
        xor x28, x28, x3                          ;
        amoxor.w x2, x3, (x28)                    ;
_l86:   fmax.s f27, f24, f6                       ;
_l87:   la x15, _l94                                      ;
        lhu x21, 0(x15)                           ;
_l88:   addiw x6, x2, -116                        ;
_l89:   la x11, d_5_4                             ;
        addi x11, x11, 8                          ;
        amoswap.w x28, x7, (x11)                  ;
_l90:   rem x18, x16, x19                         ;
_l91:   fadd.s f27, f22, f29, rmm                 ;
_l92:   la x26, d_2_5                             ;
        addi x26, x26, -16                        ;
        lr.w x21, (x26)                           ;
_l93:   fence                                     ;
_l94:   ebreak                                    ;
_l95:   fmax.s f8, f16, f25                       ;
_l96:   la x25, _l110                                     ;
        csrrw zero, mepc, x25                     ;
        mret                                      ;
_l97:   divuw x19, x1, x16                        ;
_l98:   la x15, d_1_7                             ;
        addi x15, x15, -8                         ;
        lr.d x15, (x15)                           ;
_l99:   la x28, d_1_1                             ;
        fsw f18, -0(x28)                          ;
_l100:  rem x17, x22, x18                         ;
_l101:  la x27, d_5_21                            ;
        addi x27, x27, -16                        ;
        amominu.d x20, x8, (x27)                  ;
_l102:  fmv.x.w x22, f22                          ;
_l103:  la x24, d_0_7                             ;
        addi x24, x24, -24                        ;
        lr.w x6, (x24)                            ;
_l104:  remu x20, x24, x4                         ;
_l105:  sllw x6, x30, x21                         ;
_l106:  la x28, d_1_2                             ;
        addi x28, x28, -8                         ;
        amoadd.d x1, x2, (x28)                    ;
_l107:  sltiu x0, x6, 886                         ;
_l108:  bge x21, x26, _l111                               ;
_l109:  la x20, _l114                                     ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l110:  la x12, d_2_8                             ;
        addi x12, x12, 24                         ;
        amoswap.d x30, x23, (x12)                 ;
_l111:  mulw x24, x23, x1                         ;
_l112:  xor x9, x9, x9                            ;
        addi x6, zero, 3                          ;
        slli x6, x6, 20                           ;
        add x9, x9, x6                            ;
        csrrc x16, sip, x9                        ;
_l113:  la x23, d_5_15                            ;
        addi x23, x23, 4                          ;
        amomax.w x13, x23, (x23)                  ;
_l114:  ori x0, x24, 1184                         ;
_l115:  la x25, d_0_11                            ;
        addi x25, x25, -16                        ;
        amoor.d x22, x24, (x25)                   ;
_l116:  addiw x21, x16, -458                      ;
_l117:  fmsub.s f23, f2, f15, f1, rmm             ;
_l118:  la x5, d_1_4                              ;
        addi x5, x5, 8                            ;
        amoxor.d x23, x29, (x5)                   ;
_l119:  fmsub.s f14, f1, f25, f7, dyn             ;
_l120:  mulh x7, x0, x28                          ;
_l121:  la x14, d_1_3                             ;
        lwu x27, -16(x14)                         ;
_l122:  andi x29, x15, 896                        ;
_l123:  la x29, d_1_26                            ;
        sd x17, 16(x29)                           ;
_l124:  la x3, d_4_7                              ;
        fsw f0, 20(x3)                            ;
_l125:  mulhu x16, x29, x19                       ;
_l126:  feq.s x20, f28, f12                       ;
_l127:  fcvt.l.s x7, f5, dyn                      ;
_l128:  ecall                                     ;
_l129:;
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
                .dword 0xaca324c3dc4b9367, 0x4888e323dc132286
                .dword 0xc9efcbfb45acc85d, 0x3cc97ea8cbb88f6e
d_0_0:          .dword 0x38442e05baec7043, 0xfa0cabd1cedbe1ac
d_0_1:          .dword 0xa1dff2bf5020d2d1, 0xedad2108adf87282
d_0_2:          .dword 0x36f3ea742b6b9e3b, 0xb27d2ae468582cb1
d_0_3:          .dword 0xe6968306fb494f27, 0xe9b2785e7a19960c
d_0_4:          .dword 0x432584d9c8bc43cf, 0xce81c0a6ca5ba3d9
d_0_5:          .dword 0x13342c436a1ce8ec, 0x42c38b4ea6003365
d_0_6:          .dword 0x293ae7f06f583836, 0xf798376cb06c17fd
d_0_7:          .dword 0xd8a3aac8a1be1e25, 0x39feb4651e0ae5ee
d_0_8:          .dword 0x9f6f025c21a5bffc, 0x384fed4bda7a32d5
d_0_9:          .dword 0x19daa659115aad8d, 0x01b21ab9302aaaa2
d_0_10:         .dword 0x7de7259927f23ba9, 0xb6eb135e3d61bb96
d_0_11:         .dword 0x46c8fc874a866ac6, 0x9733e94c7824ff13
d_0_12:         .dword 0x4a146aae581cff7f, 0xa59232f2ea849c93
d_0_13:         .dword 0xf28d6f1a2901d630, 0xa007da245601f9a8
d_0_14:         .dword 0xe68c49dd39da6394, 0x655edde64f59a213
d_0_15:         .dword 0xcb136d47d4da54fc, 0x9d4a36a77aea2b7c
d_0_16:         .dword 0xf2c420c7c9cb79a1, 0x07de038b64225aaa
d_0_17:         .dword 0xd976ecbd834266db, 0x65e78555aa63e450
d_0_18:         .dword 0x8ef58c650302a408, 0x68fc2630c4a5d38e
d_0_19:         .dword 0xa9c3bbc61f710da8, 0x57cf28d086760d10
d_0_20:         .dword 0xf521d073d21a1719, 0xa5fb963a0e18b7d5
d_0_21:         .dword 0x003806ce1e271bcd, 0xc2d80556a6423cdb
d_0_22:         .dword 0xb712479e9f0f73b5, 0x4d58ed0eee1f33b7
d_0_23:         .dword 0x682484b88ad1640f, 0xead3318da3d581f4
d_0_24:         .dword 0xf30ec0d2098dc13d, 0x60d7b0229423262b
d_0_25:         .dword 0x9b668c6013cc4809, 0xb73f9eee58c22f3f
d_0_26:         .dword 0xd3f603020673b599, 0xbdc311d0fab0db59
d_0_27:         .dword 0x4e9ebf798a76b77d, 0xb193b46818dcfcc8
                .dword 0x87f3ed42fb62323a, 0x394bbd56b900a21a
                .dword 0xf646fbecd9016f00, 0x7d004cc6684926f4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8cc324b52bc7815e, 0x872707f917b3342b
                .dword 0x578f19d35940c66c, 0x22de97ea2b5eac41
d_1_0:          .dword 0xefec7d29f0e75275, 0xd0631002e44d2a1a
d_1_1:          .dword 0x1cffd946ab1c6bdf, 0x71a856c283f77458
d_1_2:          .dword 0x8f020262740e3654, 0x0e62b4d0c75d82a5
d_1_3:          .dword 0xf2a056a54359e760, 0xa768947813c21114
d_1_4:          .dword 0x056fb60419096f55, 0x98c550fae36e819d
d_1_5:          .dword 0x05a05a1992915e1f, 0x22e77648cd92b3fb
d_1_6:          .dword 0x796eec1a002063a7, 0x96bb1cb0dbb06fe6
d_1_7:          .dword 0x8b60a4058ba562b0, 0x1cd465be80397192
d_1_8:          .dword 0x6445ddfd9cf5d735, 0x7845ae7f618014ab
d_1_9:          .dword 0x32069ea9f6b57e21, 0x96cf91be339c54d5
d_1_10:         .dword 0x61d230d4f85114e5, 0x6d1a909cd67c61a2
d_1_11:         .dword 0xc9d2a850aa7071a9, 0xf79340f3c4aa2f43
d_1_12:         .dword 0xbc8863e9789100d8, 0x8a00b27e44e4218d
d_1_13:         .dword 0xc045e877a0766060, 0xe12ee333520a7845
d_1_14:         .dword 0x7175447039a8cab3, 0x5b3775bc46ee25a3
d_1_15:         .dword 0xd84f26e036126155, 0x2b1f2de2fd00d588
d_1_16:         .dword 0x0d3a7fca9a115d76, 0x7601c5d360e13006
d_1_17:         .dword 0x71ed2845751c10d2, 0x53533d91ba0be0dc
d_1_18:         .dword 0x3295801e781bc17d, 0x97dec9028620478b
d_1_19:         .dword 0xa61b74dd07e0b447, 0x9388e9281ec68d82
d_1_20:         .dword 0x9444c5a82840859a, 0x4d8662dab4fab81f
d_1_21:         .dword 0x0e59023939cd6540, 0x2b86b233534217f1
d_1_22:         .dword 0xc7f4253b7f823ffc, 0xc2d42e63809d4303
d_1_23:         .dword 0xf4327192d7314382, 0x4464e2cef5c5e508
d_1_24:         .dword 0x4959975be0ca4c16, 0x0ea12b4d70356c37
d_1_25:         .dword 0xab719620460d1921, 0x3f1e9ff4336a2df0
d_1_26:         .dword 0x7f637cc57cc04462, 0x82df48f91b8e205b
d_1_27:         .dword 0xb0a48046280440a1, 0xbbce023970a703b3
                .dword 0x3db6ede15a3667c8, 0x42102805df8984f8
                .dword 0xb6c77a7c69fd1dc2, 0x100699355b6e7d3f
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x68d72dd8e52cc9aa, 0x55503f4bd25ff28e
                .dword 0x77953294dbb88103, 0x5a93b81f0838b5a0
d_2_0:          .dword 0x726e58517b490ec7, 0x19f59e2b1fbd7e38
d_2_1:          .dword 0x6ac67f21946ac0d3, 0x08f08a8122494213
d_2_2:          .dword 0x31d136529eb6f546, 0x88aae175d55994e7
d_2_3:          .dword 0x2d48664120d9ad97, 0x74bb2f8da329b621
d_2_4:          .dword 0x70b7267b0b124de8, 0x91d6f49c9a5c3bba
d_2_5:          .dword 0x7ccea6eb062f9090, 0xd069cf5390915e79
d_2_6:          .dword 0xc0ef68bbbbf6dc83, 0x029af0d43ceecbd7
d_2_7:          .dword 0x2117ecca2548be10, 0x8fbdd829108382cd
d_2_8:          .dword 0x154fbc8114b2fff4, 0xc92018de3fea12c1
d_2_9:          .dword 0xc0f1fc0faeab49aa, 0x3970efd602d38583
d_2_10:         .dword 0x9a2206e628981df9, 0x9b634e9fe1ebc9d4
d_2_11:         .dword 0xef63d98ca5417b78, 0xc6f86c0ddc482983
d_2_12:         .dword 0xe5dfcb0e7cfbcdf9, 0xa16080a0175a40e5
d_2_13:         .dword 0x3bda7bcdeb3b9e4d, 0x3317a38f6ac3f0ef
d_2_14:         .dword 0x1837cb58119318bb, 0x24aa294caa44eb0d
d_2_15:         .dword 0xad1d1138d0429da0, 0x24947357230151f1
d_2_16:         .dword 0x7501e00bf2714ccb, 0x4190332187ae96d4
d_2_17:         .dword 0xa8dfbada33a07a85, 0x1697fdc709e60a24
d_2_18:         .dword 0x0a711a58fcd6da9c, 0xd9b2c0d6dbaa1039
d_2_19:         .dword 0x64fb13f111301ebd, 0x0a2e62fa1eb669f3
d_2_20:         .dword 0x5bcfc9edd4032c7f, 0x3a77b417e5931104
d_2_21:         .dword 0xdfeecbabe159ae7d, 0xa6b11284ba88d5f4
d_2_22:         .dword 0x7e63440c05d4105d, 0x00fb4b6c425f74cf
d_2_23:         .dword 0x5bce47673ed86c87, 0x1c963fa716880304
d_2_24:         .dword 0xe1d60f92338e14ae, 0x16fa92547470b2b6
d_2_25:         .dword 0x78ab5cb1eb7bed08, 0xc5ee633b055c1e57
d_2_26:         .dword 0x546294ff94b2e34f, 0x7a7a0582eda56f13
d_2_27:         .dword 0xaafa7c9713324214, 0x570df698e6bb30d8
                .dword 0x11f379f10059fba5, 0xc4a5de5f2c190028
                .dword 0x73fe46f8c1d2122e, 0xd0d8314ba04db93f
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x81265a57a45e9f1c, 0x9251b1bff7408ee1
                .dword 0x968f7617d41f0d5c, 0x81a7c59329fec87a
d_3_0:          .dword 0xb07c2a2b64af1d88, 0xa4cfd7c4c3348467
d_3_1:          .dword 0x1cf80705897b6a0c, 0xb15c2583ed9002c6
d_3_2:          .dword 0x6af703d2089afe5b, 0xdd0a4fb4cf04471f
d_3_3:          .dword 0x8b6cb4da9dd81619, 0x8cf58efd6bc104e1
d_3_4:          .dword 0x7815b51288b397ed, 0x70ec1bad397f5d02
d_3_5:          .dword 0xed50763bcca2d440, 0x3cc6595ee4e19076
d_3_6:          .dword 0xbe5cad47cc2786df, 0xc88c68d706b71813
d_3_7:          .dword 0xda1282cf02be73f5, 0x8870bfa14a579ac9
d_3_8:          .dword 0x4fc51d4c8ca2a3db, 0x1a5a9adfd016e3fc
d_3_9:          .dword 0x76ec8e850911fa1c, 0xc049eb1ec8ec9765
d_3_10:         .dword 0x75f9c15d78a3e0c7, 0x87aab6abbbc17ee2
d_3_11:         .dword 0xd19c1bb1d7bcf001, 0x0ecef5bbfa7a6719
d_3_12:         .dword 0x48bbc3665aef29ad, 0xd90eb29156f7a53a
d_3_13:         .dword 0xd4cf9ccd967af59e, 0x8af5c1e4cc177a9c
d_3_14:         .dword 0x63d648ce4dbcce22, 0x7a73e97d77067944
d_3_15:         .dword 0x07c4fe4309490ef2, 0xd666a8afe029a860
d_3_16:         .dword 0xa7335233b8669be4, 0x9285fb2ada9b3c44
d_3_17:         .dword 0xe09625d22f0a01f9, 0xc06dd4b715791446
d_3_18:         .dword 0x3ed5f1d49dbb4300, 0x8dc412a4ee46f443
d_3_19:         .dword 0xb5a71241e2b4c9b8, 0x1e28a5f7974ffdf9
d_3_20:         .dword 0xf7a1378f58560262, 0x2447348cb177f566
d_3_21:         .dword 0x75f49ffe9b3bf9c6, 0x6e44ffdd687f552b
d_3_22:         .dword 0x942c5a51d1159888, 0xa657bae989a3a0c2
d_3_23:         .dword 0x46036aa46138a770, 0xc0c6b8f48f9e975b
d_3_24:         .dword 0x98c8ed2eafd7dbd6, 0x9ec48e502e37bf20
d_3_25:         .dword 0x48bcd94eb8a21e29, 0xd938110cfbe78bd0
d_3_26:         .dword 0x2906c6aba002ebcc, 0x72a6d752a13d02dd
d_3_27:         .dword 0x95449fa157cd3bcd, 0x368d2b9d0f1bdcd9
                .dword 0x444a17c445756293, 0x8f16c22c437b1349
                .dword 0xd714e1fbf147af54, 0x751369073553d66c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x40a9868fc81e9e9f, 0xbad457429c2585ab
                .dword 0x9e9fe64047ae414b, 0x5122a4c5149a49b8
d_4_0:          .dword 0x6662a5bad3821452, 0xde51dce7ba932615
d_4_1:          .dword 0x4c2769da351aded4, 0xf945c609f5c90c60
d_4_2:          .dword 0xeb2556ffc34222d4, 0xa52460da6234f77a
d_4_3:          .dword 0x4aa0014acda0b88b, 0x304dbd5dcf4a21d2
d_4_4:          .dword 0xd0efcbe9666fb343, 0x649bd04442d282f9
d_4_5:          .dword 0xb5183653642ac6cc, 0xb771c875a5a9e317
d_4_6:          .dword 0xa8e5e3b6c92cb544, 0xba7ad6fa61843fa4
d_4_7:          .dword 0xd088b50cb6449d39, 0x63b7a29ecbf6e732
d_4_8:          .dword 0x35816cef9341ed99, 0x557fce727f8feb4a
d_4_9:          .dword 0xf326b617bb32c10d, 0xe96c714818def626
d_4_10:         .dword 0x5cdcbca8c22a3803, 0x1844152b58d5ad05
d_4_11:         .dword 0x46d325fd408fae68, 0x50af0d6d062d12bc
d_4_12:         .dword 0x3ac8984ed3260377, 0xfe2e6dc0523ba5ee
d_4_13:         .dword 0xf00222afe813a49e, 0x0644280b981100d3
d_4_14:         .dword 0xd0eecbaae26db808, 0x013e0a450e1878e3
d_4_15:         .dword 0xa235242925e8b047, 0x8ec649f3ff380eb3
d_4_16:         .dword 0x36e481f5953e6cba, 0xf51c4805a1a69b8c
d_4_17:         .dword 0x48720b4c38be6fdb, 0x5640c38d76a3547a
d_4_18:         .dword 0xc2bfe0c7979c3d68, 0x7e9d1bcca3154194
d_4_19:         .dword 0x694dde7c6b3c1b10, 0xeb2b3bc8fcff30c9
d_4_20:         .dword 0xb71471231cb66117, 0x815311579670429a
d_4_21:         .dword 0xb6ee86ee17dbdd1b, 0x28fff33733925caf
d_4_22:         .dword 0x75b672ca196795e9, 0xc2029f62d8c227a0
d_4_23:         .dword 0x7e75920c7d1266c0, 0x8b5a417477e6753d
d_4_24:         .dword 0x24824180ad4b9c4e, 0x1779644010aa0c45
d_4_25:         .dword 0x607bdf2f4a00c89a, 0xef7cb5524367f42f
d_4_26:         .dword 0x27a69170d3a798f9, 0x9cec0001b9200035
d_4_27:         .dword 0xc84a286cdb5b5dfb, 0xea02f04807ac2536
                .dword 0x1956f9c4c32fe364, 0x968b71f2ba1d96ee
                .dword 0x802507e22c8c4b9f, 0x92bfe526b2f3bd4f
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x85a8f872562283be, 0xac4ee41de3fbb8ea
                .dword 0xdc4896bad71cbdac, 0xdc30d984364ff3ce
d_5_0:          .dword 0x43c318311b6c29c5, 0x4516a1cf72e1abc3
d_5_1:          .dword 0x3c87ee2146f2e2c6, 0xd9d72f202a79db3c
d_5_2:          .dword 0xff93c7068c648c7d, 0xdcb71ffeaa2d3855
d_5_3:          .dword 0xbb36567c868997ed, 0xeb773248057eb691
d_5_4:          .dword 0x32730234e8a6c1da, 0x7a26004eb5898bf3
d_5_5:          .dword 0xda78e6cd034861af, 0xf9267d0b41dc88c6
d_5_6:          .dword 0x027f97d2f2f73ea4, 0xd19d900f55396de6
d_5_7:          .dword 0x36bba75b2661d881, 0x80e44a7918c4794b
d_5_8:          .dword 0x9a22c6ecb4735d8c, 0xe30cafc41aae32d0
d_5_9:          .dword 0xe06874db8308f652, 0x1125084bb2893fb3
d_5_10:         .dword 0xf0913df89916a070, 0xfa58b8840a7ff5f5
d_5_11:         .dword 0x04bdbca4223ce287, 0xdc63b0f56906e48e
d_5_12:         .dword 0xb3f678b250a6cbd3, 0x5934144310063e98
d_5_13:         .dword 0x94d1fc2427f98e39, 0xa3ed51efea64f438
d_5_14:         .dword 0x4d5070bb8b798d88, 0xd15c905384bbe085
d_5_15:         .dword 0xead3c4ff78669c93, 0x110ae42fc1478d02
d_5_16:         .dword 0x3d2fc10cf3442f34, 0xac2087c3565d6f58
d_5_17:         .dword 0xf591d8bda8b64fcc, 0x870a87ed5068fbf6
d_5_18:         .dword 0x2d8091c9b8b9ec05, 0xed7fe6aac97e5278
d_5_19:         .dword 0xdba0f53f4696a236, 0xc9889e1cafd4a622
d_5_20:         .dword 0x0a5e247a785446c7, 0x716503e62938941c
d_5_21:         .dword 0xcbd3933ef6927f8a, 0x62ac6418cfe71778
d_5_22:         .dword 0x73bea863865e355d, 0xa5a31e936a0968ca
d_5_23:         .dword 0xc898215f29747a48, 0x36dd5d05f21bbc2a
d_5_24:         .dword 0x5ede8556ff1e28ff, 0xbfea5931ffecc07c
d_5_25:         .dword 0x77cc37622b6814dc, 0x776d19419a145972
d_5_26:         .dword 0xabda6cddff969c07, 0x3f7e8be11d22847c
d_5_27:         .dword 0x2b99b7cfab69ff84, 0x570e1f74c301563b
                .dword 0xb10189ea18b6e5c8, 0x457171d14a0fca42
                .dword 0xdddd1de23120dc58, 0x6ead5fdd7d938a01
         /* Random data */
_end_data5:
              
                 
