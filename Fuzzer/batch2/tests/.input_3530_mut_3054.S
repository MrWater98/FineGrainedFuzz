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
_s0:    ebreak                                    ;
_s1:    la x19, d_4_16                            ;
        addi x19, x19, 0                          ;
        amoor.d x30, x1, (x19)                    ;
_s2:    la x4, d_5_21                             ;
        addi x4, x4, -24                          ;
        amoxor.d x13, x6, (x4)                    ;
_s3:    la x20, d_2_6                             ;
        addi x20, x20, -0                         ;
        lr.w x4, (x20)                            ;
_s4:    fle.s x3, f25, f14                        ;
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
_p0:    xor x10, x10, x10                         ;
        csrrc x11, scause, x10                    ;
_p1:    xor x11, x11, x11                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 16                         ;
        add x11, x11, x10                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 25                         ;
        add x11, x11, x10                         ;
        csrrc x13, mip, x11                       ;
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
_l0:    li x22, 0                                 ;
        la x22, pt0                               ;
        addi x22, x22, 48                         ;
        sfence.vma x22, x22                       ;
_l1:    fadd.s f13, f26, f12, rmm                 ;
_l2:    la x29, d_3_5                             ;
        lh x23, -26(x29)                          ;
_l3:    la x18, d_4_22                            ;
        lwu x1, -0(x18)                           ;
_l4:    la x17, d_4_24                            ;
        addi x17, x17, 0                          ;
        amoand.w x29, x4, (x17)                   ;
_l5:    la x20, d_3_15                            ;
        addi x20, x20, -0                         ;
        amomin.d x3, x5, (x20)                    ;
_l6:    fle.s x28, f24, f25                       ;
_l7:    flt.s x5, f22, f22                        ;
_l8:    ori x28, x6, 2047                         ;
_l9:    addiw x27, x24, 1960                      ;
_l10:   fcvt.s.w f30, x10, rne                    ;
_l11:   fmul.s f3, f22, f21, dyn                  ;
_l12:   feq.s x22, f31, f20                       ;
_l13:   rem x10, x16, x1                          ;
_l14:   la x28, _l86                                      ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l15:   la x7, _l75                                       ;
        jalr x22, 0(x7)                           ;
_l16:   fcvt.s.wu f29, x29, dyn                   ;
_l17:   xor x29, x29, x29                         ;
        addi x8, zero, 3                          ;
        slli x8, x8, 31                           ;
        add x29, x29, x8                          ;
        addi x17, zero, 3                         ;
        slli x17, x17, 14                         ;
        add x29, x29, x17                         ;
        csrrw x28, frm, x29                       ;
_l18:   addiw x2, x1, -211                        ;
_l19:   fadd.s f10, f16, f3, rne                  ;
_l20:   csrrci x3, fcsr, 31                       ;
_l21:   la x23, d_3_23                            ;
        addi x23, x23, 16                         ;
        sc.d x21, x23, (x23)                      ;
_l22:   fcvt.s.l f29, x23, rmm                    ;
_l23:   srli x22, x13, 5                          ;
_l24:   la x17, d_4_17                            ;
        lui x25, 0xffe00                          ;
        xor x17, x17, x25                         ;
        lwu x29, 20(x17)                          ;
_l25:   la x26, d_3_15                            ;
        addi x26, x26, -0                         ;
        amominu.d x28, x21, (x26)                 ;
_l26:   fsgnjx.s f29, f9, f22                     ;
_l27:   rem x21, x8, x14                          ;
_l28:   la x21, d_0_27                            ;
        addi x21, x21, 0                          ;
        lr.d x6, (x21)                            ;
_l29:   srlw x18, x28, x19                        ;
_l30:   fsgnjn.s f19, f25, f25                    ;
_l31:   la x19, d_0_27                            ;
        lwu x16, -0(x19)                          ;
_l32:   csrrci x4, sie, 9                         ;
_l33:   la x24, d_5_18                            ;
        addi x24, x24, -0                         ;
        amoswap.w x30, x24, (x24)                 ;
_l34:   mulh x13, x14, x29                        ;
_l35:   divuw x8, x21, x15                        ;
_l36:   fclass.s x23, f23                         ;
_l37:   andi x10, x19, -2047                      ;
_l38:   bltu x28, x14, _l135                      ;
_l39:   sltiu x14, x26, -5                        ;
_l40:   la x17, d_2_9                             ;
        addi x17, x17, -28                        ;
        amominu.w x29, x29, (x17)                 ;
_l41:   fmul.s f22, f22, f5, rmm                  ;
_l42:   la x27, _l75                                      ;
        ld x3, 0(x27)                             ;
_l43:   csrrci x13, sscratch, 22                  ;
_l44:   mulw x25, x10, x28                        ;
_l45:   fence.i                                   ;
_l46:   bgeu x20, x27, _l108                               ;
_l47:   la x1, d_5_9                              ;
        addi x1, x1, 0                            ;
        amomax.w x10, x2, (x1)                    ;
_l48:   srli x10, x23, 34                         ;
_l49:   la x8, d_0_20                             ;
        addi x8, x8, 28                           ;
        amoadd.w x24, x2, (x8)                    ;
_l50:   ebreak                                    ;
_l51:   slliw x6, x4, 11                          ;
_l52:   ecall                                     ;
_l53:   slliw x26, x17, 0                         ;
_l54:   mul x11, x26, x12                         ;
_l55:   la x21, d_2_2                             ;
        flw f28, -0(x21)                          ;
_l56:   fnmadd.s f23, f18, f4, f20, rtz           ;
_l57:   la x29, d_4_1                             ;
        addi x29, x29, 8                          ;
        sc.d x9, x29, (x29)                       ;
_l58:   la x29, d_4_26                            ;
        sw x13, 8(x29)                            ;
_l59:   la x26, _l78                                      ;
        csrrw zero, mepc, x26                     ;
        mret                                      ;
_l60:   fmv.x.w x3, f1                            ;
_l61:   la x17, d_1_4                             ;
        addi x17, x17, 0                          ;
        amominu.d x13, x19, (x17)                 ;
_l62:   la x1, d_0_26                             ;
        addi x1, x1, 12                           ;
        amoadd.w x1, x27, (x1)                    ;
_l63:   la x26, d_2_11                            ;
        lh x13, 12(x26)                           ;
_l64:   flt.s x16, f16, f14                       ;
_l65:   fmv.x.w x24, f26                          ;
_l66:   la x5, d_3_8                              ;
        flw f31, -16(x5)                          ;
_l67:   csrrwi x3, pmpaddr4, 21                   ;
_l68:   slli x3, x23, 30                          ;
_l69:   li x12, 0                                 ;
        la x16, pt1                               ;
        addi x16, x16, 48                         ;
        sfence.vma x12, x16                       ;
_l70:   la x2, d_4_11                             ;
        addi x2, x2, 16                           ;
        amomaxu.d x23, x24, (x2)                  ;
_l71:   li x23, 0                                 ;
        la x5, pt1                                ;
        addi x5, x5, 0                            ;
        sfence.vma x23, x5                        ;
_l72:   la x10, d_5_11                            ;
        lw x22, -28(x10)                          ;
_l73:   slliw x17, x29, 31                        ;
_l74:   sraiw x4, x18, 31                         ;
_l75:   xor x1, x1, x1                            ;
        addi x1, zero, 1                          ;
        slli x1, x1, 12                           ;
        add x1, x1, x1                            ;
        addi x11, zero, 1                         ;
        slli x11, x11, 2                          ;
        add x1, x1, x11                           ;
        csrrw x24, frm, x1                        ;
_l76:   fmul.s f16, f16, f27, rup                 ;
_l77:   mulhsu x3, x3, x28                        ;
_l78:   la x26, d_5_6                             ;
        addi x26, x26, 16                         ;
        lui x22, 0xffe00                          ;
        xor x26, x26, x22                         ;
        amoor.d x19, x22, (x26)                   ;
_l79:   la x11, d_1_27                            ;
        addi x11, x11, -8                         ;
        amomin.d x26, x7, (x11)                   ;
_l80:   slliw x15, x8, 3                          ;
_l81:   la x26, d_2_19                            ;
        addi x26, x26, -8                         ;
        amoswap.w x15, x29, (x26)                 ;
_l82:   la x7, d_4_0                              ;
        addi x7, x7, -28                          ;
        lui x29, 0xffe00                          ;
        xor x7, x7, x29                           ;
        amoswap.w x26, x29, (x7)                  ;
_l83:   la x27, d_5_6                             ;
        addi x27, x27, 24                         ;
        amoadd.d x11, x29, (x27)                  ;
_l84:   sraiw x23, x2, 31                         ;
_l85:   div x19, x11, x30                         ;
_l86:   fcvt.lu.s x9, f0, rtz                     ;
_l87:   la x8, d_2_24                             ;
        addi x8, x8, 0                            ;
        amomin.w x2, x16, (x8)                    ;
_l88:   fclass.s x2, f16                          ;
_l89:   mulw x4, x23, x30                         ;
_l90:   xor x7, x7, x7                            ;
        addi x24, zero, 1                         ;
        slli x24, x24, 27                         ;
        add x7, x7, x24                           ;
        csrrc x21, fcsr, x7                       ;
_l91:   ebreak                                    ;
_l92:   fsqrt.s f18, f18, rdn                     ;
_l93:   la x9, d_3_10                             ;
        addi x9, x9, 24                           ;
        lui x18, 0xffe00                          ;
        xor x9, x9, x18                           ;
        amoand.d x30, x18, (x9)                   ;
_l94:   fmadd.s f0, f10, f19, f3, rtz             ;
_l95:   addi x23, x19, -1070                      ;
_l96:   la x5, d_0_16                             ;
        sh x17, -30(x5)                           ;
_l97:   la x14, d_5_13                            ;
        addi x14, x14, -0                         ;
        amomax.d x30, x22, (x14)                  ;
_l98:   xor x5, x5, x5                            ;
        addi x29, zero, 1                         ;
        slli x29, x29, 30                         ;
        add x5, x5, x29                           ;
        addi x24, zero, 1                         ;
        slli x24, x24, 25                         ;
        add x5, x5, x24                           ;
        addi x7, zero, 3                          ;
        slli x7, x7, 4                            ;
        add x5, x5, x7                            ;
        csrrc x2, medeleg, x5                     ;
_l99:   la x12, d_5_9                             ;
        flw f29, -4(x12)                          ;
_l100:  la x26, d_0_26                            ;
        lbu x19, -2(x26)                          ;
_l101:  slti x12, x16, 11                         ;
_l102:  auipc x23, 868236                         ;
_l103:  fnmadd.s f23, f23, f18, f1, rup           ;
_l104:  csrrci x23, satp, 5                       ;
_l105:  srli x26, x12, 2                          ;
_l106:  addw x12, x8, x28                         ;
_l107:  fmadd.s f1, f15, f20, f18, rup            ;
_l108:  srai x4, x0, 10                           ;
_l109:  la x30, _l129                             ;
        csrrw zero, sepc, x30                     ;
        sret                                      ;
_l110:  la x7, d_0_6                              ;
        addi x7, x7, -0                           ;
        amomin.w x16, x22, (x7)                   ;
_l111:  srlw x0, x12, x6                          ;
_l112:  la x10, d_3_27                            ;
        addi x10, x10, 24                         ;
        amomin.d x3, x21, (x10)                   ;
_l113:  srlw x28, x6, x11                         ;
_l114:  la x14, d_5_0                             ;
        addi x14, x14, 16                         ;
        amoor.w x19, x21, (x14)                   ;
_l115:  la x13, d_5_25                            ;
        addi x13, x13, -28                        ;
        sc.w x17, x12, (x13)                      ;
_l116:  fnmadd.s f19, f10, f0, f3, dyn            ;
_l117:  fsgnjx.s f2, f4, f11                      ;
_l118:  addiw x0, x7, -0                          ;
_l119:  auipc x26, 518907                         ;
_l120:  divu x26, x11, x25                        ;
_l121:  addiw x12, x9, -198                       ;
_l122:  fsgnjn.s f28, f22, f10                    ;
_l123:  la x2, _l136                                      ;
        csrrw zero, mepc, x2                      ;
        mret                                      ;
_l124:  la x8, d_1_4                              ;
        addi x8, x8, 16                           ;
        lui x13, 0xffe00                          ;
        xor x8, x8, x13                           ;
        sc.d x27, x8, (x8)                        ;
_l125:  la x8, d_5_20                             ;
        addi x8, x8, 16                           ;
        amoor.d x4, x19, (x8)                     ;
_l126:  la x9, d_2_26                             ;
        addi x9, x9, -4                           ;
        amomax.w x12, x22, (x9)                   ;
_l127:  fmadd.s f21, f7, f28, f16, dyn            ;
_l128:  la x19, d_4_3                             ;
        addi x19, x19, 24                         ;
        amoadd.d x16, x14, (x19)                  ;
_l129:  fcvt.s.wu f1, x29, rmm                    ;
_l130:  remuw x4, x21, x20                        ;
_l131:  sraw x7, x28, x12                         ;
_l132:  la x29, d_5_12                            ;
        sb x2, -0(x29)                            ;
_l133:  slliw x5, x20, 31                         ;
_l134:  la x14, d_4_22                            ;
        addi x14, x14, -28                        ;
        amomaxu.w x7, x29, (x14)                  ;
_l135:  la x3, _l141                                      ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l136:  fsgnjx.s f15, f15, f4                     ;
_l137:  subw x30, x16, x20                        ;
_l138:  la x30, d_1_15                            ;
        addi x30, x30, 12                         ;
        amoand.w x28, x1, (x30)                   ;
_l139:  xor x3, x3, x3                            ;
        addi x17, zero, 1                         ;
        slli x17, x17, 4                          ;
        add x3, x3, x17                           ;
        addi x1, zero, 1                          ;
        slli x1, x1, 19                           ;
        add x3, x3, x1                            ;
        addi x10, zero, 3                         ;
        slli x10, x10, 6                          ;
        add x3, x3, x10                           ;
        csrrs x20, mip, x3                        ;
_l140:  srai x19, x11, 32                         ;
_l141:  fsgnjn.s f13, f30, f19                    ;
_l142:;
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
                .dword 0x6d6db344219c237c, 0x53e9080f7e729787
                .dword 0x3cc16e55a5ab9e57, 0x36764573daf936f1
d_0_0:          .dword 0x6e11eab8577282a9, 0x45230718489305b5
d_0_1:          .dword 0x00decae20ab24a2f, 0xe9adfa627456e4d1
d_0_2:          .dword 0xc09253d7f5b0bec6, 0xec718958f0500b4a
d_0_3:          .dword 0x27a4c06550b28d85, 0x3d8220061a493624
d_0_4:          .dword 0xde3b3147553504f3, 0xea330d408524a7a2
d_0_5:          .dword 0xf589b78ada4c4f15, 0x189f8a06bbab32ca
d_0_6:          .dword 0x7be6f97784a939a9, 0x1e3c399f80b98c08
d_0_7:          .dword 0x33f13633dcf6f55a, 0xb5d76a897826e1dc
d_0_8:          .dword 0xbee4156fe9f978b0, 0x2cb71963aebd474f
d_0_9:          .dword 0x7eaf29eb1417f6aa, 0xc85dbc47b2894e0d
d_0_10:         .dword 0x339aa7860bbffede, 0x68fa4aa879f27592
d_0_11:         .dword 0x247123f726656937, 0x4cc1e3ea42d570d6
d_0_12:         .dword 0x0c8652ab565f270f, 0x02b0ee8b96c58e6b
d_0_13:         .dword 0x4cf762b46c1aaa12, 0x07ea42f7bd2738fc
d_0_14:         .dword 0xe5ca948ff0a8eecc, 0x1f8ad9126d42285a
d_0_15:         .dword 0x6b0c47ce157cca8f, 0xdf576353398b719f
d_0_16:         .dword 0x600d809b894fe0c1, 0x31bebb448be585d6
d_0_17:         .dword 0x8649d1dee6168310, 0xaf881f1dbc4aca09
d_0_18:         .dword 0x9ea04083fe62bcbc, 0x6a82fc83614d3321
d_0_19:         .dword 0x533d5e088760177c, 0x9a6f466165f83daf
d_0_20:         .dword 0x36c0323206d2fcf5, 0x162f290e651ebd9f
d_0_21:         .dword 0xa96f9fd2cba87e76, 0x0238c024c82dfd77
d_0_22:         .dword 0xd1a162bdba8b56fb, 0x6e4369f899a9737d
d_0_23:         .dword 0x2ffb79f97cb6c349, 0x10e19ba7fd87b66c
d_0_24:         .dword 0xe8cfcf5c41821031, 0x12a175c18bf69ec7
d_0_25:         .dword 0xbe04f9434e1350f7, 0xa9026e81efa52497
d_0_26:         .dword 0x77d9eff617f79f5e, 0x67837f9773f85e18
d_0_27:         .dword 0xbabce620be92b4d2, 0x3f1edda305fa7588
                .dword 0x6a3343c1ce8ba18d, 0x5c81731fd054ab13
                .dword 0x69e124f7cf9e1b4d, 0x4ffa210798535a19
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x4b7934b940caaf33, 0x153056c978513db1
                .dword 0x302455eeff80a95e, 0xb3ec34c87ec1dd32
d_1_0:          .dword 0x2f9756471f701af6, 0x3452ca769038cc83
d_1_1:          .dword 0xfb6c3aca2d885138, 0x31673cbdfb5c4433
d_1_2:          .dword 0x9ec43cc0931499b6, 0xf4faeea517e98cb9
d_1_3:          .dword 0x888cbd84cde348f2, 0x23dd8f62aaf8d31d
d_1_4:          .dword 0xd58e5c23ac3316a3, 0xbff96fe14ed9b9fa
d_1_5:          .dword 0x6eeb8c34b9f96791, 0x54616c992f43fcd6
d_1_6:          .dword 0x49d6855c904e5a41, 0x30d50cac083bc4a0
d_1_7:          .dword 0xcbdfcf34f47af008, 0xd2eee62b4e377331
d_1_8:          .dword 0xf7344442a3091b71, 0xbfb67a31ae27888a
d_1_9:          .dword 0x854623bf5b77ba5e, 0x4b8511443a84f2a1
d_1_10:         .dword 0x479603e0f6fac4bf, 0xabdc43948c2a5e15
d_1_11:         .dword 0xba7f55db2b49fcfa, 0x8f0380dbd21477bf
d_1_12:         .dword 0xabc2fd0835d3ef0a, 0xda89b031766a1172
d_1_13:         .dword 0x45cf222921d8ccd0, 0xc6954abc2371ff27
d_1_14:         .dword 0x09a5345ac350c599, 0x414f23429baa106d
d_1_15:         .dword 0x946ed9241cc458a2, 0x747c5d7ede1c8f2e
d_1_16:         .dword 0x7e5d5f9f2f51f084, 0x69aced5b0aea1c4f
d_1_17:         .dword 0x00a73e7be424f780, 0x32092552d3931310
d_1_18:         .dword 0x9349d7b231229abf, 0x857d5f1991c264b1
d_1_19:         .dword 0x26094b7bc4ad377c, 0xd3af7675081b0d42
d_1_20:         .dword 0x2238df1bc61da4c1, 0x30c5aae150c56d31
d_1_21:         .dword 0xe173905d61f5e243, 0x0460b362ebb5df04
d_1_22:         .dword 0xe5bf28e59587248f, 0x55c419218d5626df
d_1_23:         .dword 0x2e4661bd2c28050c, 0xab28d8e773cf40eb
d_1_24:         .dword 0xbc899ac1a4093b0f, 0x0ad9e9a7c35f3062
d_1_25:         .dword 0xe2b421dad5b5f770, 0xbe267fb8d475d452
d_1_26:         .dword 0x84d2c2e4d0591c17, 0x75afc346d791514a
d_1_27:         .dword 0x3248f2c55cd44ced, 0xa4e1a74d12451f1f
                .dword 0x361887bd9293fac3, 0x6f4bdd8856199dd9
                .dword 0x125254f8283953be, 0x78f933fb0f34a96a
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd4cc4fb629bafb12, 0x279df05607b6dbfa
                .dword 0xaf397aef62100155, 0x6d906dccdadb561e
d_2_0:          .dword 0x3bc3212039fa9e7d, 0x6553d31bdc94f6a6
d_2_1:          .dword 0xd20f10fd58753791, 0xb180e4fe7433fef7
d_2_2:          .dword 0xda40c863e96a7c3d, 0x7347898d1eb9376b
d_2_3:          .dword 0xbe1dd10efae45aba, 0x069d5b73d40835a5
d_2_4:          .dword 0xe4caab30ae3f6039, 0xac60abe3b2bb9a51
d_2_5:          .dword 0x566f336a19105a32, 0x19f0d319476971d7
d_2_6:          .dword 0xdbb96afe48d27ca4, 0x1a3ae5ead3ba12d9
d_2_7:          .dword 0x2b23ea849e8b5934, 0x7b3a2dabf5de9751
d_2_8:          .dword 0xe390cd3985c1bedc, 0x12b575b6ee38a38f
d_2_9:          .dword 0x77c293a5f0583ee3, 0xb39fa13bb0f352ec
d_2_10:         .dword 0xc833c0372ebf7cc7, 0x5f43de0cb2118471
d_2_11:         .dword 0x947343c35b569716, 0xd9039788290c29ca
d_2_12:         .dword 0x626eaaa2a7e3c250, 0x6e0560bcfda5085e
d_2_13:         .dword 0xada96a4fd03dc557, 0x1cf4f780b0acd090
d_2_14:         .dword 0xdc5549359c46cb7e, 0xfa5644c4c1308f82
d_2_15:         .dword 0x7698d77fe5fb6b6f, 0x0dba3ed6e3abb169
d_2_16:         .dword 0x87e56aab1ef32add, 0x0ed240c4a64b910d
d_2_17:         .dword 0x8fef62a5184355a3, 0x5bdff307acc1abe9
d_2_18:         .dword 0x9882d690b207cd2e, 0x1995717f40657274
d_2_19:         .dword 0x191154efd48872af, 0x6695352ac1d90ea7
d_2_20:         .dword 0x879d3623303a138c, 0x320bcd8418391931
d_2_21:         .dword 0x27e911e455b58d92, 0x2cd7ee44012f751e
d_2_22:         .dword 0x397d29fc57e341ab, 0xdc6861aee399c9a6
d_2_23:         .dword 0xf0bf30c1d4a1c56b, 0x3315d67cf637091a
d_2_24:         .dword 0x8ad18bd1198c8423, 0x20b504a05587444a
d_2_25:         .dword 0xaca0bd321982914b, 0xf50dc7eb5f7ef77f
d_2_26:         .dword 0x4a8f69bf79385935, 0x4d1d44a76f023d47
d_2_27:         .dword 0x503081d358c134e8, 0xfce96d5bba61f3fd
                .dword 0xca6d8738d713ead4, 0xf51e2253a4477ba7
                .dword 0xa59e09e87c792c03, 0x05def2907b14d72f
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xfd4567a462e46482, 0xe6a291c7ee801037
                .dword 0x56daa62e44c93134, 0x267ea3440ad6b33d
d_3_0:          .dword 0x0cd81934daabacea, 0x3641a96798f17b05
d_3_1:          .dword 0x072b1ac487f435c0, 0xba48f7edaaf5f3ff
d_3_2:          .dword 0x29f505d74db6f4eb, 0x4d67c128f63824f9
d_3_3:          .dword 0x96537dc21a6344aa, 0xd273ee4aea43bc86
d_3_4:          .dword 0x756c60bebab278bd, 0x0e43d0d5a9eed03f
d_3_5:          .dword 0xa9e651c203177933, 0x6f845dc9d3a6baae
d_3_6:          .dword 0x71c174501b70df65, 0x9427e9a3709c2569
d_3_7:          .dword 0x1054f2d9ad7d0d31, 0x2030cfc1bb6158b8
d_3_8:          .dword 0x601bd0814c4a89e7, 0xc75ef8028c22abe2
d_3_9:          .dword 0x96aeceba07f65958, 0xe09b2ee9dc33c055
d_3_10:         .dword 0x07597febb67f01c5, 0x12d7a66adb196e4e
d_3_11:         .dword 0x00622490dc0cdae7, 0x77be2e93abb540e7
d_3_12:         .dword 0x9e060fc0c34e152d, 0x785263d1f887942c
d_3_13:         .dword 0x08e490eac1b13387, 0x5b6ad7fd15959152
d_3_14:         .dword 0x5bdc167dfc2a59bf, 0xd090da12df13078e
d_3_15:         .dword 0x18206f53b26f5182, 0xd94ba162296af60d
d_3_16:         .dword 0xea2ffbe4ec3bcf1a, 0xe2970190d9d96a13
d_3_17:         .dword 0xc7fa02fcdd559bf0, 0x7a221efc461236e7
d_3_18:         .dword 0x26042703329ce004, 0xae1dae94427451c2
d_3_19:         .dword 0x5a5c1ff4e9065c47, 0x2109ade64cd40aac
d_3_20:         .dword 0xf033dd0f6d1dd3e4, 0x4e7b3b29fb7682fd
d_3_21:         .dword 0x1ec212a1a4e2c911, 0xa2d16b90496acb79
d_3_22:         .dword 0x0649fa0cee798c28, 0xae3a68e8fe7fc8b5
d_3_23:         .dword 0xfc7f0c5218478f25, 0xfbb92eabcd375b04
d_3_24:         .dword 0x0e6c05c8068aa866, 0xbe5ba51096204b12
d_3_25:         .dword 0x24303c879beed03c, 0xfcfd6cbcb5bc547e
d_3_26:         .dword 0xe6b88eacc081e942, 0x6a7c5ff5c0e96ffb
d_3_27:         .dword 0x00cd49bd598a20da, 0xa70c952ca804554c
                .dword 0xad453e893ed75c71, 0xaaab6d8e7eeff249
                .dword 0xa4207d4dfb3bf40e, 0xc5c38d7abd88728e
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x2280345604e63132, 0x840eee2614a68b61
                .dword 0x40d89417172ad064, 0x2a06f692c9cdcccd
d_4_0:          .dword 0x4282148e37785661, 0x416c4af566f0cc7e
d_4_1:          .dword 0x58a306f722f16394, 0x688c87ceb916d585
d_4_2:          .dword 0x7b271e171623b98a, 0x4f8b2dd9c504649e
d_4_3:          .dword 0xe6337b88e5087252, 0xb7374e0c61f5e5c3
d_4_4:          .dword 0xa5fb44c1ffa89a9f, 0x611a7403760198d4
d_4_5:          .dword 0xdb6ddbc0da46b872, 0xc99a5f6b959f7fce
d_4_6:          .dword 0x7003da7892963ec3, 0xc5cb9baf91f48088
d_4_7:          .dword 0x721dab926825faaf, 0xc3b07f8f1715af77
d_4_8:          .dword 0x5997cc707948bab1, 0xd3074a42f04ef41b
d_4_9:          .dword 0x61b7810e7c58e2d2, 0x4e04c4b98a3955bd
d_4_10:         .dword 0x382f310ecbd76d27, 0x8cbb98aef7bce1c4
d_4_11:         .dword 0x1ff980a512449789, 0xbd71b23dd58984d9
d_4_12:         .dword 0xafe79dc95a08c298, 0x6eeab910e940cd02
d_4_13:         .dword 0x417dff2385aaab2b, 0x057f4b2dc532b08a
d_4_14:         .dword 0x5306a64231a63d1e, 0x855ba59bd9813dc5
d_4_15:         .dword 0xd8228ddaab2f5225, 0x9a099aaabf5b7a8f
d_4_16:         .dword 0xe8a6c3498d56e34d, 0x6d88d0d504dc5510
d_4_17:         .dword 0x299454a9a87ba5c8, 0x0baa106dbbc70cde
d_4_18:         .dword 0x7e5c6b585a8088f7, 0x424167f9e639adf6
d_4_19:         .dword 0x9955ab71d8fa2c64, 0xe023800e16eae0c9
d_4_20:         .dword 0xa7ee89ed612a16ec, 0x5d366320f405d651
d_4_21:         .dword 0x621f0978c705cf5e, 0x36ea58bb315156ce
d_4_22:         .dword 0x239ab8cdbf6b988d, 0xdd80fab472e56940
d_4_23:         .dword 0xe5bf6a359dfe709a, 0xf9172d28960739a3
d_4_24:         .dword 0x780a5706b85a928f, 0x1dd7305c01cecb54
d_4_25:         .dword 0x00debeef3d898fea, 0x9775387bfcc2a74b
d_4_26:         .dword 0x338378d0bf54a80a, 0xea9ef898b4336dbe
d_4_27:         .dword 0x023ae5ccbf57d1c5, 0x3271a4f1273e6d53
                .dword 0x6a470b4c3f3dc911, 0x8be831004a5a23e2
                .dword 0x234b19404721c5ea, 0x77c7e26d4ad80737
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x6d07230c66b3a6cf, 0x160269f3114b8afb
                .dword 0x8f297b68c79396c3, 0xa8bf09ab015bc704
d_5_0:          .dword 0x75e4ab166afaaa83, 0x7f63de6700bd95ea
d_5_1:          .dword 0x803c061487d0a8a9, 0xec6ffeaa93b02a26
d_5_2:          .dword 0xaa77325028340a2e, 0xfc1a799f3be6823c
d_5_3:          .dword 0x176a8a0d7b79838d, 0x6e095e4624438370
d_5_4:          .dword 0xf0b109d9466b7315, 0xf3ce6c5d2adce2e3
d_5_5:          .dword 0x4455889e57ec0c55, 0x6145f101a29cc6b8
d_5_6:          .dword 0x356b7eb46319a494, 0x247d0be8349a405e
d_5_7:          .dword 0xb49e8805479c4d7e, 0x185493c3b1d4eb38
d_5_8:          .dword 0x0a65cbac6781403b, 0xdcb1fcc6e7423840
d_5_9:          .dword 0x42b33eb5a06ed536, 0x2c9d2ea441b87fe5
d_5_10:         .dword 0x3aaecfb1d2fd8e33, 0x2f0971f5d32611fb
d_5_11:         .dword 0x151f22374b611486, 0x58d568eda001da10
d_5_12:         .dword 0x3db03e04693bf8f0, 0xe6ea6e261beaa323
d_5_13:         .dword 0xa68296e890ace5f4, 0xf81c8e88c88d91b0
d_5_14:         .dword 0x14731f0d386079a4, 0x5c8fa7a516b09a6b
d_5_15:         .dword 0x524e27e8d188f6e2, 0xeb8e97143966d388
d_5_16:         .dword 0xf13de91a6953fef5, 0x24a42cb6e5740b34
d_5_17:         .dword 0xa988ec73e19f05fa, 0xd7a8999d1c6bafde
d_5_18:         .dword 0xbec5bde2c1776495, 0xd318c38f5de80c6e
d_5_19:         .dword 0x5479d1b37934089f, 0xab392bc58eb920ee
d_5_20:         .dword 0xf9c099470cfc14fa, 0x97b0823f8263c659
d_5_21:         .dword 0xe59d1a5ce2e441de, 0x5fbc1ffa52d466c6
d_5_22:         .dword 0xf9cb74ad7dfaeefb, 0x8161d3520e6aeb3b
d_5_23:         .dword 0xb709782bb386548a, 0xe5602021d6192893
d_5_24:         .dword 0x8bb08f3969d52d10, 0x31ade48cca1e0c4d
d_5_25:         .dword 0x1048ec0f54d699e7, 0x34e2c7715e377aba
d_5_26:         .dword 0x5403ad0b5191b0cf, 0xef188c0524385492
d_5_27:         .dword 0x750ae1a02d28efda, 0x146c82af5927936f
                .dword 0x6f180588c5579077, 0x9d7aca7dde9aadce
                .dword 0xe67f67c24dee000b, 0xca74bded84f743db
         /* Random data */
_end_data5:
              
                 
