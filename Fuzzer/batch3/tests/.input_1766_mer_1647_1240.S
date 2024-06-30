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
_s0:    srai x27, x4, 63                          ;
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
_p0:    la x10, _p2                                       ;
        srai x10, x10, 1                          ;
        csrrw x12, pmpaddr2, x10                  ;
_p1:    xor x12, x12, x12                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 6                          ;
        add x12, x12, x12                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 16                         ;
        add x12, x12, x13                         ;
        csrrc x10, fcsr, x12                      ;
_p2:    csrrwi x11, medeleg, 12                   ;
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
_l0:    la x3, d_0_26                             ;
        addi x3, x3, 12                           ;
        amoand.w x28, x8, (x3)                    ;
_l1:    fdiv.s f15, f27, f6, rne                  ;
_l2:    lui x5, 685564                            ;
_l3:    sltiu x10, x14, -0                        ;
_l4:    la x25, d_4_12                            ;
        addi x25, x25, -0                         ;
        amoor.w x7, x18, (x25)                    ;
_l5:    fmadd.s f9, f9, f4, f19, rtz              ;
_l6:    xor x19, x19, x19                         ;
        addi x9, zero, 3                          ;
        slli x9, x9, 3                            ;
        add x19, x19, x9                          ;
        addi x14, zero, 3                         ;
        slli x14, x14, 20                         ;
        add x19, x19, x14                         ;
        csrrc x23, sscratch, x19                  ;
_l7:    subw x9, x23, x3                          ;
_l8:    beq x9, x22, _l28                         ;
_l9:    fsub.s f25, f25, f21, rmm                 ;
_l10:   jal x4, _l66                                      ;
_l11:   blt x21, x9, _l61                                 ;
_l12:   fmv.w.x f7, x3                            ;
_l13:   la x4, d_3_2                              ;
        addi x4, x4, -28                          ;
        amoswap.w x12, x22, (x4)                  ;
_l14:   mulhsu x13, x10, x0                       ;
_l15:   la x16, _l17                                      ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l16:   csrrsi x7, pmpaddr3, 12                   ;
_l17:   divu x7, x2, x5                           ;
_l18:   fsub.s f25, f25, f1, rdn                  ;
_l19:   la x24, d_0_15                            ;
        lw x22, -0(x24)                           ;
_l20:   la x6, d_1_7                              ;
        addi x6, x6, 20                           ;
        amoor.w x24, x23, (x6)                    ;
_l21:   slti x0, x20, -199                        ;
_l22:   sltiu x29, x19, 23                        ;
_l23:   slliw x6, x16, 4                          ;
_l24:   fsgnjn.s f0, f28, f28                     ;
_l25:   bltu x15, x11, _l59                               ;
_l26:   la x15, d_5_8                             ;
        lh x9, 4(x15)                             ;
_l27:   la x2, d_1_24                             ;
        addi x2, x2, 0                            ;
        amominu.w x29, x2, (x2)                   ;
_l28:   fcvt.w.s x4, f7, rup                      ;
_l29:   addw x3, x6, x21                          ;
_l30:   mulw x6, x25, x16                         ;
_l31:   srai x13, x20, 58                         ;
_l32:   ecall                                     ;
_l33:   la x5, d_1_24                             ;
        addi x5, x5, -0                           ;
        lr.w x7, (x5)                             ;
_l34:   li x29, 1                                 ;
        la x12, pt3                               ;
        addi x12, x12, 0                          ;
        sfence.vma x29, x12                       ;
_l35:   fmul.s f22, f30, f20, rup                 ;
_l36:   rem x13, x13, x17                         ;
_l37:   fsqrt.s f2, f18, rmm                      ;
_l38:   xori x0, x12, -1108                       ;
_l39:   la x1, d_5_27                             ;
        addi x1, x1, 8                            ;
        amoand.d x13, x29, (x1)                   ;
_l40:   csrrwi x29, fcsr, 14                      ;
_l41:   la x30, d_1_14                            ;
        lhu x12, -24(x30)                         ;
_l42:   xor x8, x8, x8                            ;
        csrrw x16, mepc, x8                       ;
_l43:   fsgnjx.s f27, f15, f27                    ;
_l44:   li x14, 0                                 ;
        la x4, pt2                                ;
        addi x4, x4, 40                           ;
        sfence.vma x14, x4                        ;
_l45:   slliw x5, x15, 22                         ;
_l46:   csrrwi x30, pmpaddr3, 31                  ;
_l47:   la x7, d_3_3                              ;
        addi x7, x7, 0                            ;
        amoswap.d x9, x21, (x7)                   ;
_l48:   la x20, d_0_25                            ;
        addi x20, x20, 4                          ;
        lui x17, 0xffe00                          ;
        xor x20, x20, x17                         ;
        amoadd.w x8, x17, (x20)                   ;
_l49:   slli x8, x8, 63                           ;
_l50:   bge x11, x27, _l64                                ;
_l51:   mul x10, x0, x1                           ;
_l52:   fdiv.s f21, f21, f27, rdn                 ;
_l53:   li x9, 1                                  ;
        la x5, pt1                                ;
        addi x5, x5, 0                            ;
        sfence.vma x9, x5                         ;
_l54:   addiw x18, x13, -28                       ;
_l55:   fadd.s f9, f11, f23, rne                  ;
_l56:   csrrsi x18, mie, 15                       ;
_l57:   la x4, _l95                                       ;
        flw f17, -20(x4)                          ;
_l58:   sllw x9, x17, x30                         ;
_l59:   srliw x25, x18, 0                         ;
_l60:   la x18, d_4_21                            ;
        lw x12, 12(x18)                           ;
_l61:   srai x7, x5, 4                            ;
_l62:   fadd.s f4, f9, f16, rne                   ;
_l63:   ecall                                     ;
_l64:   la x23, d_3_3                             ;
        sd x27, -16(x23)                          ;
_l65:   fle.s x15, f24, f19                       ;
_l66:   fcvt.l.s x7, f21, rtz                     ;
_l67:   la x11, d_5_24                            ;
        addi x11, x11, 0                          ;
        sc.w x17, x24, (x11)                      ;
_l68:   la x10, d_2_18                            ;
        addi x10, x10, 0                          ;
        amoor.d x10, x5, (x10)                    ;
_l69:   xori x17, x11, 555                        ;
_l70:   la x14, d_0_18                            ;
        addi x14, x14, 28                         ;
        amominu.w x13, x2, (x14)                  ;
_l71:   jal x30, _l77                                     ;
_l72:   sllw x14, x16, x26                        ;
_l73:   la x25, _l78                                      ;
        jalr x19, 0(x25)                          ;
_l74:   la x10, _l98                                      ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l75:   fcvt.lu.s x5, f25, rmm                    ;
_l76:   fmax.s f20, f2, f12                       ;
_l77:   la x21, d_5_0                             ;
        sd x15, -0(x21)                           ;
_l78:   rem x6, x28, x30                          ;
_l79:   beq x10, x21, _l100                               ;
_l80:   la x2, _l101                                      ;
        lbu x22, -5(x2)                           ;
_l81:   la x20, d_1_16                            ;
        addi x20, x20, 8                          ;
        lr.w x20, (x20)                           ;
_l82:   feq.s x6, f16, f20                        ;
_l83:   la x2, d_1_2                              ;
        addi x2, x2, -28                          ;
        amoxor.w x4, x11, (x2)                    ;
_l84:   la x6, d_0_13                             ;
        sw x14, -16(x6)                           ;
_l85:   div x24, x13, x11                         ;
_l86:   ori x27, x19, -19                         ;
_l87:   bge x16, x21, _l91                                ;
_l88:   srli x21, x20, 44                         ;
_l89:   la x20, d_3_10                            ;
        addi x20, x20, 0                          ;
        amominu.d x7, x12, (x20)                  ;
_l90:   csrrsi x13, mstatus, 9                    ;
_l91:   la x3, d_1_14                             ;
        addi x3, x3, -28                          ;
        amoadd.w x28, x29, (x3)                   ;
_l92:   la x29, _l96                              ;
        csrrw zero, uepc, x29                     ;
        uret                                      ;
_l93:   fnmadd.s f26, f13, f28, f18, rne          ;
_l94:   la x1, d_3_12                             ;
        addi x1, x1, -24                          ;
        amomax.w x21, x16, (x1)                   ;
_l95:   csrrsi x29, mie, 3                        ;
_l96:   lui x20, 52514                            ;
_l97:   srlw x0, x1, x16                          ;
_l98:   srlw x21, x0, x9                          ;
_l99:   srliw x2, x20, 30                         ;
_l100:  xor x9, x9, x9                            ;
        addi x1, zero, 3                          ;
        slli x1, x1, 18                           ;
        add x9, x9, x1                            ;
        csrrw x29, sstatus, x9                    ;
_l101:  auipc x27, 22                             ;
_l102:  la x23, d_5_23                            ;
        addi x23, x23, -0                         ;
        lui x19, 0xffe00                          ;
        xor x23, x23, x19                         ;
        amoswap.w x18, x19, (x23)                 ;
_l103:  la x7, d_2_20                             ;
        addi x7, x7, 4                            ;
        amoor.w x6, x29, (x7)                     ;
_l104:  fsgnjn.s f20, f21, f22                    ;
_l105:;
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
                .dword 0x14219b1112a8b196, 0x1433b4bb8560ffef
                .dword 0x916e4ee588a464d5, 0xa77ce0f18d9014fc
d_0_0:          .dword 0x49845db0465f308d, 0x92d6886e711f56a1
d_0_1:          .dword 0xabcc1fb7cfdbce80, 0x7ea2656c2f3832b8
d_0_2:          .dword 0x5b089c80145f15e4, 0x6a1db36281ed3549
d_0_3:          .dword 0xd5ac13feb1b9d0a1, 0xbc0ef4441d324765
d_0_4:          .dword 0x39c38e8f29c42263, 0xe49757a194f1122e
d_0_5:          .dword 0xfc8c77e153ed22da, 0xf21969d2c403a2e6
d_0_6:          .dword 0xac4cc0d04570a4fe, 0x432d415b76693761
d_0_7:          .dword 0xd3d2a00c19baacbb, 0x0e3d91cd1a2777e9
d_0_8:          .dword 0xae5a8796822006e2, 0x9473e2da61228cac
d_0_9:          .dword 0xaf19031f5c0df815, 0x11f18d908ee5675f
d_0_10:         .dword 0x9f61e0e896c4269b, 0x335df423d0421be8
d_0_11:         .dword 0xd96e2d9883769561, 0x7f4613cff582668c
d_0_12:         .dword 0x8ceb2b12138feedf, 0x1d30d4cc9f9ce304
d_0_13:         .dword 0x25527d7d3f58aa24, 0x8c607026099c7d26
d_0_14:         .dword 0x7993d113b317a5bb, 0x77818a5ad99cd1da
d_0_15:         .dword 0x4aa6fe6c5d658e1e, 0x3e1d6804ab33e45c
d_0_16:         .dword 0xbc4acbb9faee7ff4, 0x31050991e9fc51fe
d_0_17:         .dword 0xee20d0b530ba129f, 0x35a445bfad30481f
d_0_18:         .dword 0xd3f97bf7635b4ad1, 0xf82e2fa6b43b8d4e
d_0_19:         .dword 0x8045fcd261279f64, 0x2dfeef9ef539d363
d_0_20:         .dword 0x82c5034501039656, 0x1e2da85a4869cc4e
d_0_21:         .dword 0xf171f8076b90278c, 0x65c5a6619129a5f7
d_0_22:         .dword 0xdbd62b14a1a95418, 0x3ce5adfdf54dc23d
d_0_23:         .dword 0x0a3d3212aea38a55, 0xea5c2b1c8e608172
d_0_24:         .dword 0x6312ce56d1fdaebd, 0x18818eb75aa55d0b
d_0_25:         .dword 0x3898cf9016235538, 0x52fe663f919b97fc
d_0_26:         .dword 0xec7a99e95b4a9303, 0x022b0f5034310f9f
d_0_27:         .dword 0x40d57be0c47ea100, 0xb0bd4720c264551f
                .dword 0x14ad4229a9fbf7d7, 0xc7f65e91ad8c9b5a
                .dword 0x09f15da7a05d085f, 0xd67c3c5a581b0a6f
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xd6dc172e2bde97a6, 0xeb859d945af816df
                .dword 0xc4666f4e003c83d0, 0x9624436d77a3325e
d_1_0:          .dword 0xbbbe1c54771a7e2e, 0x4743e6ea4209ba93
d_1_1:          .dword 0x527ebbadfe76487b, 0xb6e1cbe331414bee
d_1_2:          .dword 0x2ec599dc39ed5125, 0xe9de8558dc13442b
d_1_3:          .dword 0xacd8f101e601766d, 0xfb4ba89c9fcec35c
d_1_4:          .dword 0x492acd78b7163b25, 0x1aabb83852efd03b
d_1_5:          .dword 0x982b52b080b9179d, 0x397efc581447d966
d_1_6:          .dword 0x4b69a869c2c06cf4, 0x2ae5477c4a1ed051
d_1_7:          .dword 0x3920dc3fd49d627f, 0xfa3d0466b57e1fa6
d_1_8:          .dword 0x963ee52657f3bfd2, 0x6118abadcdf82125
d_1_9:          .dword 0xf2f0e9d019769d1e, 0xeb4bdd5069d0e691
d_1_10:         .dword 0xba315dbeaf543a5e, 0x125dab37855247bc
d_1_11:         .dword 0x8dc18a6f24504fe2, 0x595f175bdc1f343c
d_1_12:         .dword 0x7fde44ccee4aa529, 0x9d60318e29e08f3c
d_1_13:         .dword 0xd3665ba7110ae353, 0x2e2a87da91d0d557
d_1_14:         .dword 0x2c947bf6ece70c3a, 0x4bd91e1b06b6d83d
d_1_15:         .dword 0xbd8d9785bcf2c3cf, 0x3b653f7f33554b6e
d_1_16:         .dword 0xe23771732da544d8, 0x6720d9d781cf632d
d_1_17:         .dword 0x0e05b5f1c410918c, 0xdb64a572c531ad62
d_1_18:         .dword 0x10018752b2b361ad, 0xfbff10974a48a789
d_1_19:         .dword 0x321878a902434347, 0x2f597c34cb629578
d_1_20:         .dword 0x7aca73085411b090, 0x9e359f536232b21f
d_1_21:         .dword 0x9bfe5e48712f2138, 0xe9a80cd7318ed64e
d_1_22:         .dword 0xadd35f360e13e9bd, 0x431f67b0962459e3
d_1_23:         .dword 0xcfa6ef2a1244e345, 0x4cfbbc07d6438924
d_1_24:         .dword 0x7cde5d96a525941e, 0x042117c693f7dcf8
d_1_25:         .dword 0x5bb6040e4db2ce5d, 0x7c203f4b30c14bb1
d_1_26:         .dword 0x8f3191776bbe8e04, 0xc6fc6a6b8d447988
d_1_27:         .dword 0xb42fe7c290e21535, 0x67c720e837a6861a
                .dword 0x1ac65489a263b20a, 0x355b078df4f4c147
                .dword 0x0e8d7fa691ea2cc8, 0x13a9135e0d8a7457
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xda90dcef214e56dc, 0x61c2d510e677302d
                .dword 0x6e21d55784d4f2b5, 0x6c6a3d988482eeb5
d_2_0:          .dword 0x2c42e80aff11d357, 0x698e87a830bac0f3
d_2_1:          .dword 0x64db7b497d60e4cd, 0x356063f38ab94b17
d_2_2:          .dword 0x37f3642348c5602a, 0xfde2bc28e6a55c6d
d_2_3:          .dword 0xbd33f359d483cc68, 0x8a3bc15605868777
d_2_4:          .dword 0xbebc0b0bc5dea172, 0xe130695f86980030
d_2_5:          .dword 0xcf208189a548b78c, 0xff1409ab7320a014
d_2_6:          .dword 0x5c351b8b3809ceca, 0xcd0d042e37f5fbf4
d_2_7:          .dword 0x2adf1599b57b5db6, 0x775deb5c45758a4d
d_2_8:          .dword 0x62e8646ce3b59a2e, 0xbe52786bf4d5c477
d_2_9:          .dword 0xee960a73d6a8eae0, 0x8ef2c0121b20cc39
d_2_10:         .dword 0x9cb2f0c54771f328, 0x1d5ef9e3cc2b4942
d_2_11:         .dword 0xb09a9bb01d645548, 0xcda3b336d7795846
d_2_12:         .dword 0xa48226a1573a0b40, 0xdb4e2832da1e2792
d_2_13:         .dword 0x22c828f86f8d036c, 0x772dc6665485be0d
d_2_14:         .dword 0x2d4fd3991aae3a25, 0xe4b4b42f2d6f6037
d_2_15:         .dword 0x783e7bfb0a8a2b62, 0xb46f2686585e7802
d_2_16:         .dword 0xb3240f62dbbd844f, 0x7554d215e527b504
d_2_17:         .dword 0xf42918a57ce675cd, 0x1d22c6a7b6f8e1de
d_2_18:         .dword 0xda7a807191e10e66, 0x0e7f405089688614
d_2_19:         .dword 0x672dac52ef7fadc8, 0x4f9b05016f0f84f3
d_2_20:         .dword 0xfabb1200a2b15d1e, 0x7704a1437e8b5d33
d_2_21:         .dword 0x0245e019d9f16770, 0x009530e68af9f92d
d_2_22:         .dword 0xe83a51ad7555bd19, 0x8d207f13260c0d53
d_2_23:         .dword 0xa3f8027917f5d6fb, 0xd0a96ce6f19b3d08
d_2_24:         .dword 0xab535a1c84a7fb7c, 0x18c3fb570a4a3258
d_2_25:         .dword 0x020bfd65d1c2e4e1, 0xa11fecbe2a114c59
d_2_26:         .dword 0xf9fce1684522cec5, 0x1f66add401261df0
d_2_27:         .dword 0x54b8995cbc384ac4, 0xfe54ec640ea12255
                .dword 0xb64a27f6f94b281d, 0x5b20a2c3bc5a1cef
                .dword 0xb5bad529b15aebbc, 0x41692e948e6d9b03
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xd0a8f42b43c10256, 0x1009973b84da66d5
                .dword 0xac05e7770a68d087, 0x36b1f35019552ef5
d_3_0:          .dword 0x11a66e1a6f6e2928, 0x2821b1846c1ff175
d_3_1:          .dword 0xac430fa49dac7068, 0x3bd53d46096e9a84
d_3_2:          .dword 0xb7a8255b8682e307, 0x2c579f7f7c404b6d
d_3_3:          .dword 0xc2f15a416cb78b2b, 0x5d73cdaf179445a7
d_3_4:          .dword 0x30348fe283523457, 0x9f034c52286f9d9f
d_3_5:          .dword 0xcbde70e259ffe8bd, 0x6bda24bd2956f3db
d_3_6:          .dword 0x1fca8f9ec32a4c65, 0x4307b2eb643657f6
d_3_7:          .dword 0x0402138780377f0d, 0xeb1093e87a2d498b
d_3_8:          .dword 0x3cd78e9849284593, 0x89ef153b37fa6606
d_3_9:          .dword 0x0c9fe521102ce0b5, 0x5c789cbca23b0638
d_3_10:         .dword 0x9e584937841c02e4, 0x43f1e1b009d750f6
d_3_11:         .dword 0x5b76206d738fafa8, 0x451cd8eabd72b8a6
d_3_12:         .dword 0xd9b974d56cfa19b2, 0x8e56f87d40e06334
d_3_13:         .dword 0x45bcc52867df0bed, 0x6ad36397a52fb091
d_3_14:         .dword 0xbeb3f03397cb1ec4, 0xfa92a3496b8c9f83
d_3_15:         .dword 0xa040b9a4cc2a025b, 0x24645e97534f11af
d_3_16:         .dword 0x349b7f9fdd801ab9, 0xf57c052d0d16f1d7
d_3_17:         .dword 0x39e14152618b9994, 0xdbf0adc6cd6316fe
d_3_18:         .dword 0x05014d882eff6cba, 0x1bbcc1c9390db008
d_3_19:         .dword 0xc39b9eac137fa475, 0x3f4d91ca106b1b8d
d_3_20:         .dword 0xb9172a729f226c95, 0xb4bc8781ab9b29b4
d_3_21:         .dword 0x0d5b40ec071801b4, 0x01f1eea17e34affc
d_3_22:         .dword 0xfedbda5819ddb5ba, 0x8f75553fe5cc54c3
d_3_23:         .dword 0xcd23de80034bbaf9, 0x2706dc4a4035888e
d_3_24:         .dword 0x4931b1f638d3eb60, 0x1a3c8cb188a3ec1b
d_3_25:         .dword 0x5ddfb0beaa53e123, 0xad2a96f58b3cfb02
d_3_26:         .dword 0x785b95baa0a769c2, 0x592ce21b950598ad
d_3_27:         .dword 0x11afb13fcda0c0f2, 0xfbfe45390b0359c5
                .dword 0x28356c0e8220a6fc, 0xbae8055c28fa7a0b
                .dword 0x630eb8a21ab9a597, 0x049a194462ff72af
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5eeb844bebea6c1d, 0xedaaeaf37046f418
                .dword 0xa548d4bc6c0e393d, 0x40ca4ea54fadc7ef
d_4_0:          .dword 0xfecd9b06f1d1296b, 0x06d596edd67b12d8
d_4_1:          .dword 0x1558e4738b09d60a, 0xf6e8de5fa08ab6a3
d_4_2:          .dword 0x591dd86e4b6952d2, 0x896f250743f2cb36
d_4_3:          .dword 0x0c4a3dc940f933d4, 0xc492a2a40ac86456
d_4_4:          .dword 0x9e36494ad6dfeb5d, 0xfaf201e91c511dea
d_4_5:          .dword 0xb8f50119851cc914, 0xacb4deee3e0b22fc
d_4_6:          .dword 0x0c2dca92e646db7e, 0x48bcd9f0e126c86d
d_4_7:          .dword 0xd06ae953242cdf70, 0x34f005fad810a4ab
d_4_8:          .dword 0xfcf49473851cb81b, 0xc19441afe9dd93ce
d_4_9:          .dword 0x29a86b27be6af0ba, 0x9dae430585de4a66
d_4_10:         .dword 0x80e6ec756e3eb8ba, 0xbb99ef50a03de58b
d_4_11:         .dword 0x22eceb9106568e91, 0xf363c0cfeead3388
d_4_12:         .dword 0x0e1b38d88289b315, 0xfdccba12fb8efa57
d_4_13:         .dword 0xf1392c43b431540d, 0xcd707345730a44f2
d_4_14:         .dword 0x9f557604133b3828, 0x6f1524228f798c67
d_4_15:         .dword 0x3bc3a697e169571f, 0x84183d65613e61fa
d_4_16:         .dword 0x8349e7181a9fb027, 0xc64047d1daba80e7
d_4_17:         .dword 0x6f690dfa1e89e1fc, 0x8fa2a7f0bee5634a
d_4_18:         .dword 0x727c3ef190d9a52b, 0xd152f971f20f62ea
d_4_19:         .dword 0x0aa0e2191d739d8a, 0x9fa9c5c21e2f36a2
d_4_20:         .dword 0x27baa028d5b34140, 0xe03cb093e35e87a9
d_4_21:         .dword 0xfd3e3f5f2deeed10, 0xba8da4a192dea536
d_4_22:         .dword 0x1ddf94398883b1f0, 0x282072bf48a13af0
d_4_23:         .dword 0xc17cdcca43cf0e8b, 0x780d8c67b7dd7838
d_4_24:         .dword 0x8524d7ee1ca867f1, 0x50bdc48ae1254d3e
d_4_25:         .dword 0x0ce0635dd9518bfe, 0x1c9c4de0c8e2101e
d_4_26:         .dword 0x9413f3aec85f13c4, 0x7a2ad8f46c834528
d_4_27:         .dword 0x2a1cc7899e663e0e, 0xb39741f9561828e2
                .dword 0x5726cae3301a6e21, 0xd1c8b252531b55e1
                .dword 0x6122df8597a5ec34, 0x23e123c20d5eb81b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xac97e46595b1ae99, 0xd0c888f25827bc8d
                .dword 0x14964f47316894ea, 0xd6340c5a16050930
d_5_0:          .dword 0x5e1688a5de998a36, 0x8f00cda9be6f9358
d_5_1:          .dword 0x6610e98d791daaf9, 0x698a505a8d71592e
d_5_2:          .dword 0xf9fe5451480fa3eb, 0xff40b1901e7b40be
d_5_3:          .dword 0x26bf34216da1d84f, 0x00f9f09e1f5639ac
d_5_4:          .dword 0xf369526f222ce550, 0xfdb2f1ad9692d40b
d_5_5:          .dword 0x334ecdec272c24b2, 0xcbeb45dc5633a315
d_5_6:          .dword 0x66ad705fda0e00e5, 0xc9a32ae47d88e9b7
d_5_7:          .dword 0x439a4542a89e7434, 0x9b3d7259eb32962d
d_5_8:          .dword 0x72d2f260c30b92cb, 0x0e5bec8c63fd8b81
d_5_9:          .dword 0x75d02b29ad83d18f, 0xc2548b66e291e987
d_5_10:         .dword 0x923450384afbf43f, 0xfcd25c62fbcf1c20
d_5_11:         .dword 0x40de48d1df1ba673, 0xdb39a34a3ad905ee
d_5_12:         .dword 0x67aae0dd707b1201, 0xd129d3347ee112df
d_5_13:         .dword 0xbc073dd1982a1d67, 0xed57d86c5a2e6439
d_5_14:         .dword 0x497977df69c14ca7, 0x61f9c41875b2e5ef
d_5_15:         .dword 0xc9f2391825a61a35, 0x6d4b1ecb7b820e88
d_5_16:         .dword 0x8f6bff14ef2f4492, 0x294c5d93ee8f411f
d_5_17:         .dword 0x94da145ad95cd0e3, 0xa9e7a535cff30530
d_5_18:         .dword 0x66a629f79bb419b0, 0x98ff21a1bc644d21
d_5_19:         .dword 0x5d22339456beae52, 0x0a0e8a56c47a5647
d_5_20:         .dword 0x3a34786e3c4bc3f5, 0x64cfea5f3c9cf2f2
d_5_21:         .dword 0x0ff756c7742f4d2c, 0x873871055521cda0
d_5_22:         .dword 0x9c77022132a3c64e, 0x7ae005514b5e4d48
d_5_23:         .dword 0x0ebf9ee22df29f7d, 0x5141391873d6f6ff
d_5_24:         .dword 0xcaaa24db7befe3a0, 0x702070a0b9c72af1
d_5_25:         .dword 0x4b405ad6c4a9c44f, 0x0228218d6b694fdc
d_5_26:         .dword 0xc82765ede53f4376, 0xf7fce0d37f10b7db
d_5_27:         .dword 0x4da9267239d75d04, 0x3bd2e6b90dc20036
                .dword 0x2933ebb3310674cb, 0x2001ba0dd90190d5
                .dword 0x83897f94f1fabc61, 0xb2efc5fe0ac190fb
         /* Random data */
_end_data5:
              
                 
