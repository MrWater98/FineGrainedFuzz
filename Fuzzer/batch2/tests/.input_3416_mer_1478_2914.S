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
_s0:    fsub.s f3, f28, f31, rdn                  ;
_s1:    fsgnjx.s f9, f20, f30                     ;
_s2:    ebreak                                    ;
_s3:    la x19, d_1_19                            ;
        addi x19, x19, 0                          ;
        lui x22, 0xffe00                          ;
        xor x19, x19, x22                         ;
        amoor.w x8, x22, (x19)                    ;
_s4:    fence.i                                   ;
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
_l0:    fsgnjn.s f27, f25, f11                    ;
_l1:    la x10, d_4_13                            ;
        addi x10, x10, 4                          ;
        lr.w x3, (x10)                            ;
_l2:    la x9, d_3_27                             ;
        addi x9, x9, 0                            ;
        lr.d x28, (x9)                            ;
_l3:    fnmadd.s f11, f18, f17, f30, dyn          ;
_l4:    fcvt.lu.s x10, f28, dyn                   ;
_l5:    la x11, _l105                                     ;
        lhu x11, 30(x11)                          ;
_l6:    la x24, d_4_13                            ;
        addi x24, x24, 0                          ;
        amominu.w x11, x17, (x24)                 ;
_l7:    la x7, d_0_12                             ;
        lb x3, 10(x7)                             ;
_l8:    ecall                                     ;
_l9:    srli x10, x15, 43                         ;
_l10:   xor x1, x1, x1                            ;
        csrrs x17, scause, x1                     ;
_l11:   la x3, d_4_25                             ;
        addi x3, x3, 0                            ;
        sc.d x20, x3, (x3)                        ;
_l12:   la x5, d_3_20                             ;
        addi x5, x5, -0                           ;
        amomaxu.w x1, x20, (x5)                   ;
_l13:   la x12, _l91                                      ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l14:   la x20, d_4_24                            ;
        addi x20, x20, 0                          ;
        amominu.d x5, x30, (x20)                  ;
_l15:   la x20, d_2_1                             ;
        addi x20, x20, -16                        ;
        amoadd.d x7, x24, (x20)                   ;
_l16:   remw x11, x30, x23                        ;
_l17:   rem x15, x8, x30                          ;
_l18:   la x1, d_1_19                             ;
        lui x13, 0xffe00                          ;
        xor x1, x1, x13                           ;
        lbu x22, 2(x1)                            ;
_l19:   la x8, d_1_1                              ;
        addi x8, x8, 0                            ;
        amomax.d x25, x10, (x8)                   ;
_l20:   fnmsub.s f31, f3, f28, f21, rmm           ;
_l21:   addiw x20, x28, 23                        ;
_l22:   remw x16, x23, x21                        ;
_l23:   la x15, d_1_10                            ;
        addi x15, x15, -24                        ;
        amomin.d x7, x5, (x15)                    ;
_l24:   fmv.x.w x5, f18                           ;
_l25:   ecall                                     ;
_l26:   la x17, _l88                                      ;
        jalr x28, 0(x17)                          ;
_l27:   la x6, d_0_1                              ;
        sb x2, 25(x6)                             ;
_l28:   mulhu x30, x25, x1                        ;
_l29:   la x11, _l120                                     ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l30:   fnmsub.s f18, f26, f11, f28, rtz          ;
_l31:   srai x4, x10, 48                          ;
_l32:   mulw x7, x25, x28                         ;
_l33:   la x27, _l41                                      ;
        jalr x1, 0(x27)                           ;
_l34:   la x2, d_3_19                             ;
        addi x2, x2, -24                          ;
        amominu.d x10, x21, (x2)                  ;
_l35:   srliw x9, x18, 21                         ;
_l36:   ecall                                     ;
_l37:   mulh x12, x17, x15                        ;
_l38:   xor x8, x8, x8                            ;
        csrrc x12, mscratch, x8                   ;
_l39:   flt.s x17, f11, f15                       ;
_l40:   csrrsi x4, sstatus, 5                     ;
_l41:   la x10, d_3_3                             ;
        sh x5, -16(x10)                           ;
_l42:   fcvt.s.l f28, x4, rmm                     ;
_l43:   la x4, _l55                               ;
        csrrw zero, uepc, x4                      ;
        uret                                      ;
_l44:   fmul.s f30, f19, f4, rne                  ;
_l45:   mulhu x18, x21, x14                       ;
_l46:   fcvt.s.l f18, x9, rtz                     ;
_l47:   la x15, d_3_12                            ;
        addi x15, x15, 0                          ;
        sc.w x17, x1, (x15)                       ;
_l48:   la x23, d_4_27                            ;
        flw f15, -16(x23)                         ;
_l49:   srai x6, x9, 0                            ;
_l50:   fmv.x.w x27, f7                           ;
_l51:   fmv.w.x f16, x17                          ;
_l52:   csrrwi x19, mtval, 6                      ;
_l53:   la x26, d_5_18                            ;
        addi x26, x26, -0                         ;
        amomin.d x14, x2, (x26)                   ;
_l54:   la x30, _l13                                      ;
        srai x30, x30, 1                          ;
        csrrc x24, pmpaddr3, x30                  ;
_l55:   fclass.s x5, f2                           ;
_l56:   csrrwi x18, mip, 7                        ;
_l57:   la x10, d_2_18                            ;
        addi x10, x10, -20                        ;
        amoadd.w x19, x9, (x10)                   ;
_l58:   andi x22, x7, 1478                        ;
_l59:   fmin.s f28, f13, f14                      ;
_l60:   fnmadd.s f3, f23, f30, f1, rdn            ;
_l61:   la x16, d_1_22                            ;
        addi x16, x16, 8                          ;
        lui x1, 0xffe00                           ;
        xor x16, x16, x1                          ;
        sc.d x23, x16, (x16)                      ;
_l62:   la x10, d_5_21                            ;
        addi x10, x10, 8                          ;
        lui x23, 0xffe00                          ;
        xor x10, x10, x23                         ;
        amomin.d x12, x23, (x10)                  ;
_l63:   fmax.s f8, f6, f11                        ;
_l64:   fmv.w.x f30, x1                           ;
_l65:   fcvt.l.s x3, f19, rtz                     ;
_l66:   ecall                                     ;
_l67:   sraiw x28, x6, 6                          ;
_l68:   fnmadd.s f7, f29, f18, f3, rtz            ;
_l69:   la x6, d_5_2                              ;
        addi x6, x6, -16                          ;
        lui x27, 0xffe00                          ;
        xor x6, x6, x27                           ;
        amomin.d x3, x27, (x6)                    ;
_l70:   fcvt.wu.s x26, f31, rmm                   ;
_l71:   la x16, d_2_25                            ;
        ld x21, 16(x16)                           ;
_l72:   slliw x15, x14, 18                        ;
_l73:   sllw x5, x26, x30                         ;
_l74:   fmax.s f2, f11, f17                       ;
_l75:   fnmadd.s f20, f30, f26, f24, rmm          ;
_l76:   fence                                     ;
_l77:   fsqrt.s f24, f19, rup                     ;
_l78:   sllw x10, x5, x24                         ;
_l79:   fcvt.s.lu f22, x21, rtz                   ;
_l80:   la x16, _l98                                      ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
_l81:   fsgnjx.s f21, f18, f19                    ;
_l82:   divu x22, x28, x27                        ;
_l83:   mulh x6, x23, x1                          ;
_l84:   fle.s x2, f7, f23                         ;
_l85:   la x3, d_0_10                             ;
        lb x9, -20(x3)                            ;
_l86:   la x30, d_5_18                            ;
        lui x26, 0xffe00                          ;
        xor x30, x30, x26                         ;
        lwu x16, 8(x30)                           ;
_l87:   fence                                     ;
_l88:   bne x11, x9, _l110                                ;
_l89:   rem x8, x1, x5                            ;
_l90:   fmsub.s f16, f30, f10, f15, rtz           ;
_l91:   la x3, d_2_26                             ;
        addi x3, x3, 0                            ;
        lui x12, 0xffe00                          ;
        xor x3, x3, x12                           ;
        lr.d x21, (x3)                            ;
_l92:   la x14, d_2_16                            ;
        addi x14, x14, 12                         ;
        amoswap.w x1, x9, (x14)                   ;
_l93:   la x5, d_5_10                             ;
        addi x5, x5, 0                            ;
        amoand.w x1, x23, (x5)                    ;
_l94:   slliw x11, x27, 31                        ;
_l95:   subw x12, x11, x11                        ;
_l96:   la x24, _l100                                     ;
        jalr x29, 0(x24)                          ;
_l97:   la x21, d_0_27                            ;
        addi x21, x21, 8                          ;
        amomax.d x28, x25, (x21)                  ;
_l98:   la x20, d_1_26                            ;
        addi x20, x20, 16                         ;
        lui x10, 0xffe00                          ;
        xor x20, x20, x10                         ;
        amoadd.w x17, x10, (x20)                  ;
_l99:   fcvt.s.lu f16, x3, rmm                    ;
_l100:  addiw x7, x5, 2047                        ;
_l101:  la x11, d_3_2                             ;
        addi x11, x11, 0                          ;
        sc.d x5, x11, (x11)                       ;
_l102:  feq.s x11, f5, f1                         ;
_l103:  remu x19, x3, x11                         ;
_l104:  fmax.s f0, f21, f14                       ;
_l105:  beq x26, x25, _l110                               ;
_l106:  rem x19, x12, x7                          ;
_l107:  fnmadd.s f22, f11, f22, f19, rdn          ;
_l108:  fsqrt.s f30, f8, rdn                      ;
_l109:  csrrsi x7, mie, 9                         ;
_l110:  div x15, x20, x11                         ;
_l111:  fcvt.s.l f18, x1, dyn                     ;
_l112:  la x10, _l120                                     ;
        csrrw zero, mepc, x10                     ;
        mret                                      ;
_l113:  flt.s x8, f11, f4                         ;
_l114:  la x10, _l120                                      ;
        lwu x5, -8(x10)                           ;
_l115:  fmv.w.x f22, x21                          ;
_l116:  remu x16, x25, x3                         ;
_l117:  fsgnjn.s f28, f17, f30                    ;
_l118:  slliw x5, x5, 2                           ;
_l119:  bltu x22, x13, _l122                              ;
_l120:  fmin.s f12, f22, f7                       ;
_l121:  la x20, d_2_17                            ;
        addi x20, x20, -24                        ;
        amomaxu.w x13, x18, (x20)                 ;
_l122:  la x22, d_3_2                             ;
        lui x10, 0xffe00                          ;
        xor x22, x22, x10                         ;
        fsw f29, 8(x22)                           ;
_l123:;
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
                .dword 0x966f1cfb7a7e0e38, 0xf5443afac515fc0b
                .dword 0x33f89a146e140b70, 0x59eea220c3aea16b
d_0_0:          .dword 0x38c6c574e8a297ba, 0x962761acbbfc0eb7
d_0_1:          .dword 0x89ce8d58e2c4c6eb, 0x5f95e83b19ce1801
d_0_2:          .dword 0x8790898822dc68f0, 0xc9681065d65bd7b8
d_0_3:          .dword 0x80849925a349b908, 0x42d54021cfb8afb2
d_0_4:          .dword 0x5dfd72fe52151583, 0x24e15de16cfb163b
d_0_5:          .dword 0xc0993e0a5d87e6b8, 0x40b90ec3eb1e822e
d_0_6:          .dword 0xd6d443b86117e969, 0xa040aec5bc8b1688
d_0_7:          .dword 0x5c9668aebb92a10e, 0xa1f4a759eb63e218
d_0_8:          .dword 0x2005fad41b993e78, 0xa20890a5ce078330
d_0_9:          .dword 0xdf5390987ad1e47a, 0xf9cb395ac06af02e
d_0_10:         .dword 0x97bd11d2e9b9b672, 0xcb02aa18488685d8
d_0_11:         .dword 0x92e66854fb9e4ac0, 0xc6424c099db58fe6
d_0_12:         .dword 0x7c4617931d076f9a, 0xefc96351e58ddc48
d_0_13:         .dword 0x329008327e1cb73c, 0xf2579454c99e6d53
d_0_14:         .dword 0x2a142aeda51ecf19, 0x49026b6208f9928a
d_0_15:         .dword 0x71d5b93af5c8b0f8, 0xf690eab88e00360b
d_0_16:         .dword 0x5380696a0a1da8ea, 0xe0f0361826fa95dd
d_0_17:         .dword 0x95ebf5686532d019, 0xf0e3dced0908657d
d_0_18:         .dword 0xee842ac3ecd5a001, 0x84664829afb64d64
d_0_19:         .dword 0x12ecabfee71e41da, 0xc35dddba2b519f3c
d_0_20:         .dword 0x937c0dbd2fca63a4, 0xc88a523a47d88ab5
d_0_21:         .dword 0xc165c433022599e7, 0x790514c8a9cb9028
d_0_22:         .dword 0x7ec1e2b69acf698f, 0x5f13b8a898dcf08e
d_0_23:         .dword 0x02f73154ef7072b3, 0xa7d5dc6f25392810
d_0_24:         .dword 0x864b3c6234143ef9, 0xc514fe1a6c5d0133
d_0_25:         .dword 0x9301bfee1f295e0d, 0x56f010ac14df66e7
d_0_26:         .dword 0x1b5dbb39e28b9d71, 0xe3ba444a43af614d
d_0_27:         .dword 0x33405b745474a55b, 0x33166efbafc877c1
                .dword 0x1c182698669ad701, 0x5f4020514133092f
                .dword 0x5d01181f0a7d87dc, 0x7db02868e9f78ada
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3f43614d6799e2ae, 0x7e9c8e126cdd38d2
                .dword 0x4db096f96b9c52e1, 0x795e5d8f35bd1780
d_1_0:          .dword 0x41232b77986bca33, 0x558a08b3fa21aa1d
d_1_1:          .dword 0x43756497c46af38f, 0x38a897644aa6f032
d_1_2:          .dword 0x2a5086e743eeb25a, 0x2c84305399995561
d_1_3:          .dword 0x7616742e948c57f2, 0xfbcc4fd0f7e9fbc6
d_1_4:          .dword 0xbb2590da8df69804, 0x7fba7bc3cbfecb60
d_1_5:          .dword 0xbc430ce0705851cf, 0x9502cc037f641a2d
d_1_6:          .dword 0x1e35f45b3cc6036b, 0x9654c45364891ea6
d_1_7:          .dword 0x353e4784d72a89ef, 0xc9ac3549f49e48d3
d_1_8:          .dword 0xa9fd9adca77cbb6d, 0x7aaced85390ec0b3
d_1_9:          .dword 0xe7133a9148473109, 0x1585f4145486c7fc
d_1_10:         .dword 0x6b29c0675c429239, 0xce6b9ea1a53802bc
d_1_11:         .dword 0xc45b1107d42081bc, 0x1114cedc66b4df15
d_1_12:         .dword 0x65365bcd4fc03d9f, 0xa957392bbdc706e0
d_1_13:         .dword 0x43691155efe1dfca, 0x14fb2f940e4f0b98
d_1_14:         .dword 0x84b817629976177c, 0x25f7b2a516ed3a28
d_1_15:         .dword 0x2d119ee29d88c844, 0xd8a39f40406bf299
d_1_16:         .dword 0xa8132b7c41802467, 0x4ddc4a2d05dba80d
d_1_17:         .dword 0x67bfefd445401120, 0xf5858bf33b7c7a7e
d_1_18:         .dword 0x1adfecff9801ad91, 0xd122dd3befb5e063
d_1_19:         .dword 0x27ad930d681e8818, 0x2ecc4cc15f5642c7
d_1_20:         .dword 0x03ad158cb2253fa8, 0x476bc5330f7cfc59
d_1_21:         .dword 0x52d192fa2847e4b2, 0x58695bbe5e3d825b
d_1_22:         .dword 0xc86918cb4251f475, 0x693636fc49196743
d_1_23:         .dword 0x237ef46c9074bdc7, 0x8c0a938300dcad7c
d_1_24:         .dword 0x08380b0ff33668d6, 0xff04c604a86c7a05
d_1_25:         .dword 0x09e38eb20ee6d56c, 0x3a9877ef8c51cacc
d_1_26:         .dword 0xa505cc25b22eb192, 0x6fe84017c99d2557
d_1_27:         .dword 0x9d478e9dc702b2a2, 0x18c1565e02b470ab
                .dword 0x4d598dde3dd430c7, 0x0def7b635b8177f2
                .dword 0xe9378c2027d6f23c, 0xdabf4ee3bcf3e513
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xfb980461a19ebf61, 0x467db8d759d325b9
                .dword 0x1d8c03e50e84fe43, 0xd20ee0ef737d1c18
d_2_0:          .dword 0x4261d384eba7af07, 0x2784bea2c749c228
d_2_1:          .dword 0xc76d63113c2b3cc0, 0x31ccf8eb5fe030cd
d_2_2:          .dword 0x99801faddc606925, 0x6d076b293ceedf47
d_2_3:          .dword 0xe810402c12fc4503, 0x6cf9b5940147fa6c
d_2_4:          .dword 0xe8c95280443b88a5, 0x44510919da57fad7
d_2_5:          .dword 0x8a312a2fa8033757, 0x4d0d2a0af0cc8deb
d_2_6:          .dword 0xab9555386926b6b4, 0xd08d7282d961b280
d_2_7:          .dword 0x2baeb0970d63e200, 0x567e50d6198deb22
d_2_8:          .dword 0xa646eb1262809301, 0xcebd959b532462c7
d_2_9:          .dword 0xb04349297c1a6dc0, 0xea222a2350432ea2
d_2_10:         .dword 0x2671bda7d185833d, 0x4b6542b1166d3b66
d_2_11:         .dword 0x7dcfe1a5892500ff, 0x4322c1f67507b20d
d_2_12:         .dword 0x5edcd9b5b0a46239, 0xdd363188b6e11a39
d_2_13:         .dword 0x049919dd3521bf6a, 0x7c86485c17f30050
d_2_14:         .dword 0x3bf4bed3cbb533dd, 0xedd7b90d34076ef1
d_2_15:         .dword 0xabe309211813b42c, 0xddd3ef2c1dc403df
d_2_16:         .dword 0xe5edc8faa3e24118, 0xcae2a2cff26e4404
d_2_17:         .dword 0x982458c2633b450c, 0xf832759b16b09c32
d_2_18:         .dword 0x36ff3f7cb02a2b34, 0x0338d187d03f2bdb
d_2_19:         .dword 0x1639e6c8fa9ca62d, 0x025ba36a2c80b838
d_2_20:         .dword 0x4d331758d4d8ddb5, 0xa19c6aaec70f6e42
d_2_21:         .dword 0x620dd6bc51088667, 0x0f32ff090f91e62c
d_2_22:         .dword 0x0837ccaac2a62918, 0x18a02fa87f8088e5
d_2_23:         .dword 0x0631199f76305d28, 0x36cfd37477021116
d_2_24:         .dword 0x3acca55a503260e7, 0x218d6dc135cb8ff7
d_2_25:         .dword 0xb183bf1af6ac3e75, 0x8ab857fadde81522
d_2_26:         .dword 0xbe484c56fa66dab4, 0x0207fff91974e2ff
d_2_27:         .dword 0x47d27bf03999cf02, 0x2d81fbd27f3aa66c
                .dword 0x17c9fb29c9ffa817, 0xc2b786469e632b7b
                .dword 0x5678781c2b7ba7db, 0x87f9787b4085c1a0
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xb00b40c3d567c4d8, 0x03f8e8ade0f8cb6c
                .dword 0x2ab8cde095e09e7e, 0xdc52a1e776512c6f
d_3_0:          .dword 0xe91c6b7418682b27, 0x89a3393cc750abd5
d_3_1:          .dword 0xf3ec1ff46858deca, 0xbf88d2db13657c6d
d_3_2:          .dword 0x7cf3a48c2f29671a, 0xbb747d2ec3109fca
d_3_3:          .dword 0x4c7ad551e1cab935, 0xa5e7669ee5dbcd8c
d_3_4:          .dword 0x0e79b75d3fcfa206, 0x1f3fbbee647724b1
d_3_5:          .dword 0xd9e273ad418ae656, 0x4b24782f384de586
d_3_6:          .dword 0x76c02c9377d651d3, 0x308e1327256e3241
d_3_7:          .dword 0xa1ac04e9f5fb1be9, 0x6f4a3e7f5cc00b81
d_3_8:          .dword 0x660a86c6f873c815, 0xb909a8a0722829bd
d_3_9:          .dword 0x5e5dd07cb726aa34, 0x6e7e9e666c348308
d_3_10:         .dword 0x22066ceec3e58acc, 0xbdd62a36b5e6481d
d_3_11:         .dword 0xf33bf1a20bfe6e5a, 0x2a51744cd51d6589
d_3_12:         .dword 0x69ccfd06e02fc8c3, 0x18b36f3dc7613042
d_3_13:         .dword 0x867a1e0a82841aec, 0x21f9a1373e3b33c7
d_3_14:         .dword 0x516da70387fc78ae, 0x0e1d8820db915b31
d_3_15:         .dword 0xf90b2377f4e9356b, 0x7fc56013b501e89d
d_3_16:         .dword 0x06f15fc10fd5f6d1, 0x67d0fdd87ba5f5a4
d_3_17:         .dword 0x93a2178c0d141213, 0x72441b9b1cfc5989
d_3_18:         .dword 0xd86f2d3544bffb12, 0x34185289ccab5450
d_3_19:         .dword 0x7fd1e540590272ff, 0xf143a357df02ac4f
d_3_20:         .dword 0xffc842acc91a038e, 0x8f5a91b5f52cb87d
d_3_21:         .dword 0x355ada5ba1f60338, 0xbd2ce7d22f331f5f
d_3_22:         .dword 0x3140561c9d8710c3, 0x8f6cfdb05fc6e95c
d_3_23:         .dword 0x5373b20f88c41902, 0xc6865551254452d9
d_3_24:         .dword 0x1f5e344543a5c9d9, 0xbb337f2e7494f3e0
d_3_25:         .dword 0x97e4f69800ad5dad, 0xf45895101c202557
d_3_26:         .dword 0xd223f4ba3bf7a659, 0x3010d65c9cf5e623
d_3_27:         .dword 0x6b1d07779401d75e, 0x40288ef4acaf6c88
                .dword 0x76e914811f3a2538, 0x75a9c304cbeb83e9
                .dword 0x9ce2a5f4df1acfef, 0xe016581ad941fffd
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xed44aae870bde893, 0x25d48f8b99a785d4
                .dword 0x4a4155016fa14081, 0x19f637f7b82790ba
d_4_0:          .dword 0xdb063e55880fc6ce, 0x4f10a9e43b38fd94
d_4_1:          .dword 0x9614d9e08d9bf4b9, 0x1d01f1b7a18a55be
d_4_2:          .dword 0xf79b92d5695da14b, 0x3de7e36acdeb17de
d_4_3:          .dword 0xbd9fae7940caf343, 0x5b0bf0c2d24c6f71
d_4_4:          .dword 0x9b1265a21e979272, 0xbd88b9bc5e384981
d_4_5:          .dword 0xc8c55332f7bbba81, 0x506f8e535d70c6fc
d_4_6:          .dword 0x580ad39483c569ad, 0x0225239d1a52ad43
d_4_7:          .dword 0x024ee2a26bbe7187, 0x5e8cc711a64115c9
d_4_8:          .dword 0x9284991b80532313, 0x802f4e806f2a965e
d_4_9:          .dword 0x044d980ee8e749ac, 0xbc4274de9c1261cc
d_4_10:         .dword 0xc97fe8f02aa93f57, 0x31456d14a45221ca
d_4_11:         .dword 0xffe93545f3e46a5c, 0xe0af81a5835ec3ed
d_4_12:         .dword 0xcef964ddee7a2e28, 0x63884e8151850807
d_4_13:         .dword 0x60083f7fb26ee5bd, 0x0570a45a056071ef
d_4_14:         .dword 0x85e80769da1bc497, 0xa9c358010802ea0b
d_4_15:         .dword 0x516901e8d5bd7a02, 0x1493c3cea76a3d0c
d_4_16:         .dword 0x69e43723d0f23c97, 0x2cb1a4aba49eee1d
d_4_17:         .dword 0x7f0c694b18b7d7b9, 0xee16bfa23dc2fed5
d_4_18:         .dword 0x756743d2db1e8099, 0x954f3dfadfd5f94d
d_4_19:         .dword 0x813aecc2974921cb, 0xc27079e198d59cc3
d_4_20:         .dword 0x190547f39492dc3d, 0x2adc04570ccf0644
d_4_21:         .dword 0x6c848a5407d227a4, 0xa52d664ff1013484
d_4_22:         .dword 0x5e29f33c4a70a247, 0x4327572cb9962055
d_4_23:         .dword 0xdd5dc88d35044be3, 0x498ce3a63cba7860
d_4_24:         .dword 0x11aa577cdbd477ab, 0x19d572446ba7b264
d_4_25:         .dword 0x86b0150fde71adb1, 0xf42e88c163ca4f30
d_4_26:         .dword 0xf4a4a33cfbab52bf, 0x2d71a05d888937f7
d_4_27:         .dword 0xae9c5a52e53cfb7c, 0x0ae74fc10544185f
                .dword 0x84a23d2b4b783d19, 0x29caf392ea4c925d
                .dword 0x6ba3588f0d18034f, 0xc3be7a1d0d18a5af
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x1a13a29c44784584, 0x7a69d89c96afbf95
                .dword 0x6e7bf7671f872ebb, 0x2d44c70e194d09e9
d_5_0:          .dword 0x64fc7cbb52a83264, 0x556fafc5739293b0
d_5_1:          .dword 0x40fad463c00d4f9b, 0x491c84001cd19af5
d_5_2:          .dword 0x70ceba6a1d091731, 0x1e6dca4d98c0dfa1
d_5_3:          .dword 0x5f2457155adcb0a7, 0x0928ed759f4c0c01
d_5_4:          .dword 0x38b9c9b22a70988e, 0x9601c2142a4f79d3
d_5_5:          .dword 0x11a60cada5b1b8d9, 0xce84e56ee0b01dc9
d_5_6:          .dword 0xab299373de326289, 0xf13f379cc3de97af
d_5_7:          .dword 0x5a8a3b42c99b1656, 0x8bd1f4ab147dcaf2
d_5_8:          .dword 0xe5105d49852505a2, 0x1e016c3cb7ba1a14
d_5_9:          .dword 0x2f48553040062dcd, 0x24ace6c4398e071b
d_5_10:         .dword 0xc5ddcd684cd0ea49, 0x129c663b36a5c32e
d_5_11:         .dword 0xa695c983ed1ac2da, 0xf03ac4c54a0d20f3
d_5_12:         .dword 0x36c527a0c1ab89a9, 0xd686bab801ac955b
d_5_13:         .dword 0xdb6c0e423ca9c33b, 0x66e592e909e58892
d_5_14:         .dword 0x4292417936a4322e, 0x1eecb746c21d3dba
d_5_15:         .dword 0xa3f8e12ec4562b38, 0x532aa6a65c1e6874
d_5_16:         .dword 0x6c1b84fc79d49245, 0xb41b8262c9149405
d_5_17:         .dword 0x37bf154bb04c1cf3, 0xb85b6c53cae0e4bf
d_5_18:         .dword 0x740112e2f44bf215, 0x5e87a4a439357aad
d_5_19:         .dword 0x11da629b5a4dac31, 0x732efbb8f0fc24c0
d_5_20:         .dword 0x1991bf7c795f9a96, 0x084d2b45d4d4394c
d_5_21:         .dword 0xa1427ffa5044eab9, 0xf999a45b0b11c241
d_5_22:         .dword 0x9b10f51c3412afd9, 0x3664778e77b0d1cd
d_5_23:         .dword 0xe6ef0d4882bf95e2, 0xd977c1fca487e0be
d_5_24:         .dword 0x154c680341f519f9, 0x2dd21ee460ca7b5a
d_5_25:         .dword 0x18c614ca9d8377f8, 0xad16f34deaa099ca
d_5_26:         .dword 0x7e3414ff38dc2ad3, 0x6af1ae0d4e039519
d_5_27:         .dword 0x549eae3626b79538, 0xa73c7d1ef48e28bf
                .dword 0x5625452c1bb072fb, 0xce957ec7d1f686eb
                .dword 0x62e4fd8d264e1f36, 0x2c63a088ef7332ac
         /* Random data */
_end_data5:
              
                 
