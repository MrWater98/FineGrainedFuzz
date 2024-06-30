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
_s0:    la x20, d_3_6                             ;
        lwu x15, 24(x20)                          ;
_s1:    subw x25, x3, x8                          ;
_s2:    divw x27, x18, x27                        ;
_s3:    sltiu x4, x20, 7                          ;
_s4:    ebreak                                    ;
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
_p0:    xor x13, x13, x13                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 15                         ;
        add x13, x13, x10                         ;
        csrrw x14, sip, x13                       ;
_p1:    csrrwi x10, sepc, 2                       ;
_p2:    csrrsi x11, sie, 26                       ;
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
_l0:    la x28, d_2_25                            ;
        addi x28, x28, 20                         ;
        amoadd.w x12, x22, (x28)                  ;
_l1:    srai x28, x30, 25                         ;
_l2:    la x22, _l115                             ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_l3:    fmadd.s f0, f9, f17, f17, rtz             ;
_l4:    mulhsu x18, x20, x25                      ;
_l5:    ecall                                     ;
_l6:    fsqrt.s f25, f21, rmm                     ;
_l7:    csrrwi x27, stval, 15                     ;
_l8:    bge x14, x28, _l105                       ;
_l9:    ori x6, x6, -297                          ;
_l10:   la x27, d_4_10                            ;
        addi x27, x27, -28                        ;
        amominu.w x18, x2, (x27)                  ;
_l11:   blt x16, x28, _l54                        ;
_l12:   sraiw x1, x0, 26                          ;
_l13:   fadd.s f5, f22, f9, rmm                   ;
_l14:   fsub.s f21, f25, f7, rmm                  ;
_l15:   la x18, d_5_23                            ;
        addi x18, x18, -28                        ;
        amominu.w x10, x16, (x18)                 ;
_l16:   lui x4, 25                                ;
_l17:   fmax.s f0, f9, f30                        ;
_l18:   la x9, d_3_8                              ;
        lwu x22, -20(x9)                          ;
_l19:   la x25, _l49                              ;
        lhu x4, 8(x25)                            ;
_l20:   la x15, d_1_23                            ;
        lw x21, 20(x15)                           ;
_l21:   divu x15, x8, x0                          ;
_l22:   la x7, d_1_15                             ;
        lw x21, -20(x7)                           ;
_l23:   fsub.s f24, f12, f2, rne                  ;
_l24:   lui x27, 281076                           ;
_l25:   la x20, d_4_10                            ;
        sw x2, 0(x20)                             ;
_l26:   csrrsi x12, scause, 24                    ;
_l27:   xor x14, x14, x14                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 25                         ;
        add x14, x14, x19                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 23                         ;
        add x14, x14, x20                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 0                            ;
        add x14, x14, x2                          ;
        csrrw x2, mstatus, x14                    ;
_l28:   bgeu x27, x28, _l42                               ;
_l29:   la x4, _l59                               ;
        srai x4, x4, 1                            ;
        csrrs x14, pmpaddr6, x4                   ;
_l30:   addw x21, x10, x14                        ;
_l31:   xor x28, x28, x28                         ;
        addi x29, zero, 3                         ;
        slli x29, x29, 19                         ;
        add x28, x28, x29                         ;
        addi x15, zero, 3                         ;
        slli x15, x15, 12                         ;
        add x28, x28, x15                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 29                         ;
        add x28, x28, x28                         ;
        csrrw x22, fcsr, x28                      ;
_l32:   sltiu x7, x10, 1256                       ;
_l33:   la x10, d_2_22                            ;
        addi x10, x10, -16                        ;
        lr.d x13, (x10)                           ;
_l34:   la x2, d_5_22                             ;
        addi x2, x2, 0                            ;
        amoswap.d x9, x8, (x2)                    ;
_l35:   fcvt.w.s x30, f24, rtz                    ;
_l36:   mulhsu x9, x21, x10                       ;
_l37:   li x28, 0                                 ;
        la x25, pt0                               ;
        addi x25, x25, 24                         ;
        sfence.vma x28, x25                       ;
_l38:   la x25, _l47                              ;
        csrrw zero, mepc, x25                     ;
        mret                                      ;
_l39:   fcvt.s.wu f9, x26, rne                    ;
_l40:   andi x1, x18, 0                           ;
_l41:   la x19, d_2_27                            ;
        addi x19, x19, 24                         ;
        amominu.w x23, x13, (x19)                 ;
_l42:   fcvt.wu.s x22, f9, rne                    ;
_l43:   xor x14, x14, x14                         ;
        addi x26, zero, 1                         ;
        slli x26, x26, 25                         ;
        add x14, x14, x26                         ;
        csrrs x17, mcause, x14                    ;
_l44:   sraw x21, x7, x21                         ;
_l45:   blt x14, x19, _l67                                ;
_l46:   bne x4, x25, _l52                                 ;
_l47:   fmin.s f26, f17, f6                       ;
_l48:   fmul.s f7, f21, f30, rup                  ;
_l49:   la x18, d_0_27                            ;
        lwu x28, -8(x18)                          ;
_l50:   fcvt.s.w f31, x14, dyn                    ;
_l51:   la x11, d_4_27                            ;
        lw x4, 8(x11)                             ;
_l52:   mul x25, x6, x28                          ;
_l53:   la x29, d_4_7                             ;
        lbu x22, 31(x29)                          ;
_l54:   fmadd.s f5, f10, f1, f29, rup             ;
_l55:   fadd.s f14, f3, f25, rne                  ;
_l56:   mulw x25, x30, x19                        ;
_l57:   la x12, d_1_8                             ;
        ld x4, -16(x12)                           ;
_l58:   srli x14, x7, 5                           ;
_l59:   la x21, d_3_23                            ;
        addi x21, x21, -8                         ;
        amomax.w x25, x24, (x21)                  ;
_l60:   la x3, _l63                               ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l61:   la x27, d_3_18                            ;
        addi x27, x27, 20                         ;
        amomax.w x2, x22, (x27)                   ;
_l62:   mulhu x27, x10, x10                       ;
_l63:   divu x5, x12, x30                         ;
_l64:   remw x5, x3, x7                           ;
_l65:   fle.s x14, f28, f20                       ;
_l66:   divu x16, x23, x27                        ;
_l67:   fnmsub.s f5, f21, f3, f21, rup            ;
_l68:   ori x30, x3, 1587                         ;
_l69:   la x29, d_0_23                            ;
        flw f31, 4(x29)                           ;
_l70:   la x5, d_1_18                             ;
        addi x5, x5, 24                           ;
        amoswap.d x11, x28, (x5)                  ;
_l71:   rem x26, x15, x21                         ;
_l72:   csrrsi x20, scause, 31                    ;
_l73:   remw x30, x28, x22                        ;
_l74:   bltu x20, x28, _l95                       ;
_l75:   mulh x16, x21, x18                        ;
_l76:   fle.s x24, f12, f31                       ;
_l77:   la x19, d_1_1                             ;
        addi x19, x19, -8                         ;
        amoswap.w x14, x29, (x19)                 ;
_l78:   fcvt.l.s x7, f17, dyn                     ;
_l79:   divw x23, x25, x29                        ;
_l80:   fmax.s f20, f0, f17                       ;
_l81:   jal x29, _l91                                     ;
_l82:   fence.i                                   ;
_l83:   fsgnj.s f19, f26, f27                     ;
_l84:   feq.s x0, f18, f10                        ;
_l85:   la x24, d_4_23                            ;
        addi x24, x24, -8                         ;
        amoswap.w x14, x7, (x24)                  ;
_l86:   la x17, d_0_10                            ;
        addi x17, x17, -28                        ;
        amoadd.w x12, x26, (x17)                  ;
_l87:   srliw x1, x20, 22                         ;
_l88:   fence                                     ;
_l89:   fmadd.s f9, f24, f31, f13, rne            ;
_l90:   ecall                                     ;
_l91:   la x24, d_0_3                             ;
        addi x24, x24, -0                         ;
        amominu.d x29, x19, (x24)                 ;
_l92:   fence.i                                   ;
_l93:   fcvt.w.s x27, f28, rdn                    ;
_l94:   la x20, d_4_19                            ;
        addi x20, x20, 0                          ;
        amominu.d x11, x11, (x20)                 ;
_l95:   slti x1, x19, 27                          ;
_l96:   remuw x0, x18, x3                         ;
_l97:   la x19, _l114                                     ;
        csrrw zero, sepc, x19                     ;
        sret                                      ;
_l98:   ecall                                     ;
_l99:   la x30, _l110                                     ;
        lw x16, 28(x30)                           ;
_l100:  jal x28, _l113                                     ;
_l101:  la x5, d_2_7                              ;
        addi x5, x5, 4                            ;
        amomax.w x24, x29, (x5)                   ;
_l102:  fmv.w.x f7, x6                            ;
_l103:  addw x28, x10, x26                        ;
_l104:  srliw x10, x2, 4                          ;
_l105:  slti x23, x26, 0                          ;
_l106:  fadd.s f13, f25, f9, rtz                  ;
_l107:  mulhu x2, x26, x12                        ;
_l108:  la x29, _l114                                     ;
        csrrw zero, uepc, x29                     ;
        uret                                      ;
_l109:  la x26, d_2_22                            ;
        addi x26, x26, -0                         ;
        amoor.d x3, x24, (x26)                    ;
_l110:  addiw x29, x11, 2047                      ;
_l111:  bltu x11, x18, _l115                              ;
_l112:  srli x19, x4, 0                           ;
_l113:  andi x25, x3, -1420                       ;
_l114:  la x23, d_2_2                             ;
        addi x23, x23, 4                          ;
        amominu.w x25, x9, (x23)                  ;
_l115:  la x11, d_5_25                            ;
        lw x19, 20(x11)                           ;
_l116:  fcvt.lu.s x10, f12, rdn                   ;
_l117:;
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
                .dword 0xcc0d77e6decfb423, 0x942b8ebf1ede3c80
                .dword 0x2cec37d176f36a9a, 0x1b206eab17b18704
d_0_0:          .dword 0xa03d0875f45ee8aa, 0x72a9295957126065
d_0_1:          .dword 0x599f53a4c1bd6a8f, 0xd1f5e770bcdc9bbf
d_0_2:          .dword 0xc2a184b97fbc7263, 0x3a77918a13a2d2e7
d_0_3:          .dword 0x8eda3f356a6dd79d, 0xfbcd2288a7a8d931
d_0_4:          .dword 0x2cddd055b725064a, 0xf5ee7c4fab0d84fa
d_0_5:          .dword 0xb571fa28dc98f35f, 0x25f10867ddd7226d
d_0_6:          .dword 0xd8ef59691e245667, 0xc92ddda69802a02f
d_0_7:          .dword 0x8a5ff642c9b6a463, 0x6a06330b8d89703e
d_0_8:          .dword 0x339fb6d41257d4aa, 0xcbb50d452c56bbfc
d_0_9:          .dword 0x890c75226dd2ce0f, 0x101c10ed3a4357ab
d_0_10:         .dword 0xd3e7556ee6769a3b, 0x8d037fe4b58a7f0a
d_0_11:         .dword 0x48c1aabc56b62490, 0xfac25316cc4ec644
d_0_12:         .dword 0x89e5ee41afa1cbe7, 0x981364e414c225d8
d_0_13:         .dword 0xe0b5e6d86826cd6f, 0x6b57fe45e9a4869a
d_0_14:         .dword 0xf849339aa6bd4aa7, 0xd0cee454f3be6c3b
d_0_15:         .dword 0xf87a3ebb769d3fb5, 0x7ff3fbea319da422
d_0_16:         .dword 0xe0d56b5d3d25f821, 0x14d3a97ae078b819
d_0_17:         .dword 0x9780edfd405c7057, 0x4b259fec8602dc86
d_0_18:         .dword 0xa47dedbc86c796e5, 0xa81867b42301137f
d_0_19:         .dword 0x0c42f73990530ad8, 0x3411a2a981234ce0
d_0_20:         .dword 0xa34b31a8a937438e, 0x8bcace377fd2b68d
d_0_21:         .dword 0xf8f8dd9dce938b1b, 0xdf6d7d91e22978b4
d_0_22:         .dword 0xe899c2fed9da5066, 0xec471588a910e42c
d_0_23:         .dword 0xc681a4e2623b02b6, 0xd63457a7ebc49147
d_0_24:         .dword 0xd50bb64b2ebfdcf4, 0xee9958def4150a90
d_0_25:         .dword 0x69d1b89458e3307c, 0x667828d92eeaa59e
d_0_26:         .dword 0xdf88289564e145f0, 0xa95d69558abe5f62
d_0_27:         .dword 0x73e2892adab43464, 0x8c941d1672fe8dc7
                .dword 0x505676d9e3eb1deb, 0xe12e6130dff96aa3
                .dword 0xf8f8af950f8f599d, 0x8b1e3c4715df6737
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x7e2d1f8cb84934c3, 0xd2ad206611ca92cf
                .dword 0x6e45c164b192f4c5, 0xe42ede6b3927ee72
d_1_0:          .dword 0x18b9468bd6153be6, 0x38a0106f36a120e9
d_1_1:          .dword 0x7176147800877e11, 0x8fcd417b0bfd6022
d_1_2:          .dword 0xc8b99dd1ba0495d4, 0xc3aa7441905d29d3
d_1_3:          .dword 0x35c9137e16184b5e, 0x6274d7c76e50fdd4
d_1_4:          .dword 0x2a41408de0461410, 0x006810f1ab540f3d
d_1_5:          .dword 0x345cc58ee904ce6c, 0xa24246b3531869be
d_1_6:          .dword 0x623f43709e9efee0, 0xe24b75e432f6a799
d_1_7:          .dword 0xb2e89f6118d88521, 0x88e483edaf54aed6
d_1_8:          .dword 0x8793c7f599529230, 0x67489f019b51bcb9
d_1_9:          .dword 0xc97db01ed7846e10, 0x0adf2f9a613b4bb1
d_1_10:         .dword 0xbb9da5d86b937c57, 0xad25b40c8502e144
d_1_11:         .dword 0xc2049651dc956633, 0xcc14d2fe774559dd
d_1_12:         .dword 0xcfa296e0b5a4984b, 0x4ce7ca7041758b4d
d_1_13:         .dword 0xd43d7a2c1b896125, 0x53b7caa53f484014
d_1_14:         .dword 0xbe1ee2e768e8e523, 0xcd0f60e950d7ac13
d_1_15:         .dword 0x8cbb23cdaebf9c56, 0x17b970515a773248
d_1_16:         .dword 0x0cde28009c5980e9, 0xa457dd84e4ad47ce
d_1_17:         .dword 0x48e246eaf97b2c8a, 0xf566ab912c3b3ca9
d_1_18:         .dword 0x042a88e59ba534c8, 0x9c02c53d51a77c31
d_1_19:         .dword 0x5ede08eaa7193c87, 0xd2dd236d88114589
d_1_20:         .dword 0xb63210c5f573957c, 0xfc180e42afda94e2
d_1_21:         .dword 0xdc30dc4b096abf4e, 0xe782ee66aa763b98
d_1_22:         .dword 0x7f7b058f02a3cca4, 0xffc8e344fdc3fa93
d_1_23:         .dword 0x3fb79268b19fd57c, 0xbb9940853e1c7079
d_1_24:         .dword 0x69f25803f5bb6072, 0x17ec8ef925a49156
d_1_25:         .dword 0xcf3c50d8466755d9, 0xfc67da910fd0d7f2
d_1_26:         .dword 0x760a6576fb157252, 0x1b093658930c8fbe
d_1_27:         .dword 0x0a47dd9d57aca28e, 0xc437c01f85693418
                .dword 0x114fbf9c128fbc85, 0xcb3889e6c2c8e5a1
                .dword 0xa15ad783301f6402, 0xc71cdf400a6e4d8f
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xaf8d47756f7ecd61, 0x0469655a4df66a23
                .dword 0xb3f61f083a658e5c, 0xd9e7a2bf86f980f8
d_2_0:          .dword 0xf4a7a2c2cdfb8532, 0xbda9b4da9f634f4e
d_2_1:          .dword 0x7cfaf8440534f334, 0x49ee1ebdf11f3e23
d_2_2:          .dword 0xca22724d5f0a1fda, 0xfe105bded9a6fd20
d_2_3:          .dword 0xc972c9ebff80216b, 0x48ab12857fc23b2a
d_2_4:          .dword 0x0ea0677ebea96d0d, 0x24edaeaabafd67d9
d_2_5:          .dword 0xeba0c7f1687a31b0, 0xab892d100dc33765
d_2_6:          .dword 0xe4280cc65ac65c60, 0xd19437b68ade0847
d_2_7:          .dword 0xafa0ce2a846caf7c, 0x27c358990b216d72
d_2_8:          .dword 0x719422c4bce5c1da, 0x273cf196e5b54126
d_2_9:          .dword 0x77d1cfa0eaaa770d, 0x34524048fbf0861f
d_2_10:         .dword 0xeefa344f08d96cea, 0x5a8933174260ecc9
d_2_11:         .dword 0xe17707e89788b2b1, 0x7ef1f5bb207909f2
d_2_12:         .dword 0x13edc5b57c4a873a, 0xde36482055ca40be
d_2_13:         .dword 0xfcb0640311f328b3, 0x4552c39fda8d89e9
d_2_14:         .dword 0xff15f4762d5f8ccb, 0x86f18ee0c67b58cf
d_2_15:         .dword 0xcd9836956997852e, 0x8c085e8d21f02692
d_2_16:         .dword 0xdf33dc15464ecf09, 0x7aedcffb996c5d8a
d_2_17:         .dword 0xd0340575be30cdd4, 0xe5a6070cc1ba5955
d_2_18:         .dword 0xa11949951b2909f1, 0x20aacef5b7817ec4
d_2_19:         .dword 0x4dadf1169dbb8f02, 0x579bb71eb4e443aa
d_2_20:         .dword 0x147df9c7900c44d6, 0x74bf3ffc1a05f556
d_2_21:         .dword 0xb97c3287934ac421, 0x1a7dc468c1f2d5eb
d_2_22:         .dword 0x912652a0e9cfc34e, 0x1b3d157318193587
d_2_23:         .dword 0x566854cd69550249, 0x8cc6e174463945df
d_2_24:         .dword 0x5e73c907bbd94c35, 0xad4ecd5af3504814
d_2_25:         .dword 0x997b491d3b55c21f, 0x5934abca560ed3f5
d_2_26:         .dword 0x0c4610147a2304fa, 0x16ed98ce82e0ae5e
d_2_27:         .dword 0x878f54808a7124c5, 0x1cb38ac836500fe0
                .dword 0x3a4f9030169c3e8b, 0xe2da13b6bee2b256
                .dword 0xd69ab2629227aa1d, 0xab11efe906ec727a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x63f07202154eba72, 0x21c5dcc2a566a0ad
                .dword 0xa99e821e38ad4a6f, 0x7dfc2ca79ea44476
d_3_0:          .dword 0xa7352fce8fdc0cad, 0x07e94c153d39a51c
d_3_1:          .dword 0x8376e951542bc55f, 0xe6f8364eb52de2f7
d_3_2:          .dword 0x118fd9ebb5447030, 0xa45568ca2860b2f7
d_3_3:          .dword 0x986af7ca3b085180, 0x7144bc6192279a11
d_3_4:          .dword 0x5bba3166e6f07561, 0x579ae2858d23e8e3
d_3_5:          .dword 0xe88c980a3698ee40, 0xcdce0992b03786ea
d_3_6:          .dword 0x11e61ab593f14bf5, 0x4419a23ca0b9363f
d_3_7:          .dword 0x8ce34b7fad503f5c, 0x879293d505ba7ed3
d_3_8:          .dword 0x48ecb4038f5f9423, 0xd6faff5f51243d86
d_3_9:          .dword 0x5b4a91cc5b1a9a51, 0x7da6283916cec225
d_3_10:         .dword 0x22036d7194d741c8, 0xab24584eeb321de0
d_3_11:         .dword 0xb59000ae124ef0a2, 0x1cb7296b259a8e0b
d_3_12:         .dword 0x8e841b4a7ae89b4e, 0xe6734c1f5d822ba1
d_3_13:         .dword 0xbefeda40b3247e27, 0x927f9a001e27dbad
d_3_14:         .dword 0xac41d5c6b2e6912b, 0x163241345cf1df70
d_3_15:         .dword 0x3e94e75bbf8af6ec, 0x488af3bb477196dd
d_3_16:         .dword 0xa68f2098fefac02c, 0x7d4013d5e4f77647
d_3_17:         .dword 0x2705933d2e9b2547, 0x69b8a87cadaae5d5
d_3_18:         .dword 0x254df51fb70f2b0f, 0xf40ff22e5591a87c
d_3_19:         .dword 0x3849b91f02363f71, 0xd659dd0161ee15ff
d_3_20:         .dword 0x06dfc2da7499af54, 0x7de276bd9068a103
d_3_21:         .dword 0x07781ab79e73caba, 0xb95dc30377149af6
d_3_22:         .dword 0x2a9199909637f0cd, 0x4960d500202b5a1d
d_3_23:         .dword 0x789a3ab1c7c82962, 0x0f3360734df789dc
d_3_24:         .dword 0xb2df5fdd0377a896, 0xb9cf44da20b041fe
d_3_25:         .dword 0xc2da8a01addd7fff, 0x6135dd2626aa042f
d_3_26:         .dword 0xa82d71f0affa77b2, 0x71c77286c95dbc63
d_3_27:         .dword 0xde4121e225dd262f, 0xd99ecbbfe95afdc7
                .dword 0x7eed1d0ba327a234, 0xbe733ceb8bc9fe4c
                .dword 0x4dcb8c8f29c538b9, 0xac4021478bab7639
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xa349278f837874f4, 0x6ce2d794d492d0dd
                .dword 0xb15fc5de902e7d97, 0x1b7a3aa5be51cc7f
d_4_0:          .dword 0x161419798be571e5, 0xfe266ed057edc780
d_4_1:          .dword 0x965279b0381de365, 0xca839f3ab0e5c426
d_4_2:          .dword 0x724cd4c455f1f422, 0x168ef42177bcc173
d_4_3:          .dword 0xf182fe1762cfddc7, 0x04fb02a541167140
d_4_4:          .dword 0x891f82f3ab223e86, 0xd3d3774edec8cc85
d_4_5:          .dword 0xc0c409edae0dcce4, 0xa3c50fdbc47b82e4
d_4_6:          .dword 0xaf9343a0397a4a4c, 0x6e0c21485f4eead0
d_4_7:          .dword 0xc9ea87a0d0228ba8, 0x1b0649abcddaff5d
d_4_8:          .dword 0x1a4755ac2a6b1777, 0xcc97708128832070
d_4_9:          .dword 0xbae098429cb9aa87, 0x71c7d3fdbfc4856b
d_4_10:         .dword 0x94b33a9dd67eee45, 0x925bcc36cdee1899
d_4_11:         .dword 0xdef83b76a9b074be, 0xf1b58a11f0188ebb
d_4_12:         .dword 0xef370c6d08b9510a, 0x010b11e8838ab899
d_4_13:         .dword 0xf42fa7e1ad6c6d9f, 0x9da4c8b87dc7fa88
d_4_14:         .dword 0xdb6236ae4f07bf83, 0xb2c68da725040214
d_4_15:         .dword 0x076b332733507821, 0x929a568d1cad0337
d_4_16:         .dword 0x6c14bdf4393d5f75, 0x2f8b08957d3a8961
d_4_17:         .dword 0x5d904891abf3544c, 0x3d3c5f02b8090e0d
d_4_18:         .dword 0xe4dab2efe9d6d35b, 0x179a70127ca4d7e5
d_4_19:         .dword 0x3f768bd35f3e64c9, 0xa7b6768d6f76e761
d_4_20:         .dword 0x6fc17bce807ac1d3, 0x2764cb0b2f3524e1
d_4_21:         .dword 0x8b5189477881f595, 0xcb7efa416ad51fad
d_4_22:         .dword 0x546e21f038183303, 0xcfcdedc986c5f92d
d_4_23:         .dword 0x377dd097dea91a30, 0xb6e157cc647d23ed
d_4_24:         .dword 0xe6fd6d40a3b0d2c4, 0x43d2f9b91c292607
d_4_25:         .dword 0xd533df018a27414f, 0x3a5e9d5de15b426c
d_4_26:         .dword 0x6a845be36565f6a3, 0xd5cc98dad5ad6558
d_4_27:         .dword 0x53569439767538a9, 0x5d74871e5637b1f2
                .dword 0x66500deacf3fb268, 0x4e4a0b628c219d74
                .dword 0xc1246d1f4880c0cf, 0xe4a74629b86f0fc9
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x94c9e5dc875d0a7b, 0x9a9da6eeef1d30c2
                .dword 0x6c28288d64d83f36, 0x4c73110ec7376c18
d_5_0:          .dword 0xd176d4932b76b2d7, 0x8260eddc025716f8
d_5_1:          .dword 0x485c90dedfd7190a, 0x7544e873c6c8d668
d_5_2:          .dword 0x92f1aed01a4cdccd, 0xbbaa1183d47a989e
d_5_3:          .dword 0x928ab49f0723b0fd, 0xe3d2f91f81811895
d_5_4:          .dword 0xfb467a41d00bd4d5, 0x33a90f337c200b46
d_5_5:          .dword 0x8f4e2911b25ec804, 0x16d859932f2d94b0
d_5_6:          .dword 0xc2ca7ec59ccc4100, 0xc18d1451d9638567
d_5_7:          .dword 0x7d7269f535ef1387, 0xa4c4723d3d8651e0
d_5_8:          .dword 0x92b6e835adf50f24, 0x4fdcedd45ba6ab15
d_5_9:          .dword 0xff9a27fd540a2bdb, 0x0d246968faa4d76d
d_5_10:         .dword 0x942dfbfd8270b2b5, 0xea6b5b0dee609f19
d_5_11:         .dword 0xffed8c82aab0077f, 0xa7dd08d3af916ecb
d_5_12:         .dword 0xaeffb8da3e5e8712, 0xae0996336dcb679e
d_5_13:         .dword 0xa0bfd20ea08402f5, 0x00f26ba248413c4a
d_5_14:         .dword 0x10e8774c3a19543d, 0xe7c66ace343d83d0
d_5_15:         .dword 0x5568f2782eeace1a, 0xf55f3be2d7f055af
d_5_16:         .dword 0x6a804f1126e92e9c, 0x331a8096d7b91a52
d_5_17:         .dword 0x89c2474a145ed1a5, 0x6e059b891bcc0c48
d_5_18:         .dword 0x4cd10fcda0cdbd03, 0x1fa59d65cba39455
d_5_19:         .dword 0x3831b3a526c5ef6a, 0xa2dd8709fa4b2e5e
d_5_20:         .dword 0x20fbf7d07e0de04d, 0xa47499923defa20f
d_5_21:         .dword 0x4d824cd0e5624cc7, 0x5973e89fcafdaf48
d_5_22:         .dword 0xf855a850bbd84d1a, 0xcb8f8817f2794696
d_5_23:         .dword 0xb408fa888360d2b4, 0x20485cf5abd0ff74
d_5_24:         .dword 0x5b73d7cc05be3218, 0x73133f683e64b3bd
d_5_25:         .dword 0xaefcfcbda3fc7bcd, 0xb411f1b1a8c6fbd5
d_5_26:         .dword 0xdc123e77a5a6c460, 0xe176d2c3dddf9f51
d_5_27:         .dword 0xc537e259ff6125d6, 0xf1ec0090f2a4cea2
                .dword 0xd13ff37980850a64, 0xc883b8bf1c2c7274
                .dword 0x23a44e2e260da303, 0x806b8e0c7424364b
         /* Random data */
_end_data5:
              
                 
