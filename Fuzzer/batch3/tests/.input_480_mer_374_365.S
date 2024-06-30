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
_s0:    bge x1, x4, _s3                                   ;
_s1:    sltiu x9, x12, -12                        ;
_s2:    la x5, d_0_4                              ;
        sd x20, -8(x5)                            ;
_s3:    ebreak                                    ;
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
_p0:    csrrci x14, mie, 15                       ;
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
_l0:    slti x7, x14, -1289                       ;
_l1:    ebreak                                    ;
_l2:    la x25, d_2_6                             ;
        addi x25, x25, 16                         ;
        lui x29, 0xffe00                          ;
        xor x25, x25, x29                         ;
        amomaxu.w x18, x29, (x25)                 ;
_l3:    fcvt.lu.s x8, f5, rtz                     ;
_l4:    fmax.s f23, f22, f5                       ;
_l5:    la x2, d_2_21                             ;
        addi x2, x2, -0                           ;
        amomaxu.w x4, x11, (x2)                   ;
_l6:    fmin.s f25, f14, f9                       ;
_l7:    la x15, d_5_21                            ;
        addi x15, x15, 0                          ;
        amoswap.w x18, x20, (x15)                 ;
_l8:    remu x6, x29, x14                         ;
_l9:    feq.s x14, f5, f14                        ;
_l10:   fnmadd.s f26, f26, f22, f24, rtz          ;
_l11:   xor x16, x16, x16                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 25                         ;
        add x16, x16, x29                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 8                          ;
        add x16, x16, x27                         ;
        csrrw x26, sstatus, x16                   ;
_l12:   divuw x3, x9, x4                          ;
_l13:   fmax.s f5, f19, f4                        ;
_l14:   la x2, d_2_27                             ;
        lwu x25, -28(x2)                          ;
_l15:   la x1, d_5_26                             ;
        addi x1, x1, -16                          ;
        lui x10, 0xffe00                          ;
        xor x1, x1, x10                           ;
        lr.d x14, (x1)                            ;
_l16:   la x18, d_5_0                             ;
        addi x18, x18, -24                        ;
        amomaxu.d x25, x18, (x18)                 ;
_l17:   fence                                     ;
_l18:   fcvt.s.lu f4, x23, rmm                    ;
_l19:   fcvt.lu.s x5, f19, rmm                    ;
_l20:   la x29, d_1_16                            ;
        addi x29, x29, -0                         ;
        amoxor.d x22, x5, (x29)                   ;
_l21:   srai x26, x23, 63                         ;
_l22:   la x24, d_0_15                            ;
        addi x24, x24, 16                         ;
        amoxor.w x24, x21, (x24)                  ;
_l23:   fence.i                                   ;
_l24:   la x22, d_4_26                            ;
        addi x22, x22, 28                         ;
        amomax.w x27, x14, (x22)                  ;
_l25:   ecall                                     ;
_l26:   bgeu x3, x16, _l82                        ;
_l27:   srliw x17, x0, 18                         ;
_l28:   li x9, 1                                  ;
        la x26, pt3                               ;
        addi x26, x26, 8                          ;
        sfence.vma x9, x26                        ;
_l29:   la x14, d_0_0                             ;
        addi x14, x14, -4                         ;
        amoswap.w x28, x26, (x14)                 ;
_l30:   feq.s x2, f9, f25                         ;
_l31:   fsgnjx.s f24, f4, f21                     ;
_l32:   la x22, d_1_2                             ;
        lhu x23, 16(x22)                          ;
_l33:   fle.s x0, f5, f24                         ;
_l34:   srai x3, x30, 9                           ;
_l35:   fcvt.lu.s x16, f31, rmm                   ;
_l36:   la x2, d_5_3                              ;
        addi x2, x2, -12                          ;
        lr.w x24, (x2)                            ;
_l37:   slti x3, x12, 1027                        ;
_l38:   remuw x15, x8, x3                         ;
_l39:   mulhu x21, x6, x21                        ;
_l40:   addiw x12, x13, -2047                     ;
_l41:   feq.s x28, f31, f21                       ;
_l42:   mulh x8, x3, x27                          ;
_l43:   la x19, d_0_17                            ;
        sh x17, 8(x19)                            ;
_l44:   la x9, d_0_7                              ;
        addi x9, x9, 28                           ;
        amoxor.w x29, x20, (x9)                   ;
_l45:   feq.s x12, f19, f28                       ;
_l46:   ori x15, x18, 0                           ;
_l47:   mulhsu x26, x12, x22                      ;
_l48:   la x28, d_4_27                            ;
        sh x4, -20(x28)                           ;
_l49:   fsqrt.s f12, f26, rtz                     ;
_l50:   addi x16, x20, 2012                       ;
_l51:   feq.s x5, f16, f4                         ;
_l52:   la x25, d_1_8                             ;
        lbu x11, -22(x25)                         ;
_l53:   la x9, d_5_14                             ;
        addi x9, x9, -8                           ;
        amoor.d x4, x1, (x9)                      ;
_l54:   csrrwi x10, fflags, 31                    ;
_l55:   fcvt.s.l f7, x24, dyn                     ;
_l56:   andi x26, x2, -773                        ;
_l57:   addw x10, x29, x3                         ;
_l58:   blt x11, x4, _l84                                 ;
_l59:   div x1, x5, x16                           ;
_l60:   blt x27, x26, _l130                       ;
_l61:   li x15, 0                                 ;
        la x29, pt0                               ;
        addi x29, x29, 16                         ;
        sfence.vma x15, x29                       ;
_l62:   la x7, d_3_23                             ;
        lui x18, 0xffe00                          ;
        xor x7, x7, x18                           ;
        fsw f11, 0(x7)                            ;
_l63:   xor x29, x29, x29                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 19                         ;
        add x29, x29, x10                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 10                           ;
        add x29, x29, x1                          ;
        csrrw x11, scause, x29                    ;
_l64:   la x20, _l102                             ;
        ld x11, 8(x20)                            ;
_l65:   remu x22, x0, x19                         ;
_l66:   la x16, d_0_16                            ;
        addi x16, x16, -16                        ;
        amomax.w x21, x17, (x16)                  ;
_l67:   xor x7, x7, x7                            ;
        addi x20, zero, 1                         ;
        slli x20, x20, 16                         ;
        add x7, x7, x20                           ;
        addi x29, zero, 3                         ;
        slli x29, x29, 20                         ;
        add x7, x7, x29                           ;
        csrrw x9, pmpcfg0, x7                     ;
_l68:   fmsub.s f21, f22, f10, f17, rup           ;
_l69:   la x30, d_0_2                             ;
        addi x30, x30, -0                         ;
        amoor.w x11, x17, (x30)                   ;
_l70:   srai x3, x5, 43                           ;
_l71:   la x27, d_4_0                             ;
        addi x27, x27, 0                          ;
        amomin.w x7, x21, (x27)                   ;
_l72:   fence.i                                   ;
_l73:   fcvt.w.s x12, f15, rmm                    ;
_l74:   fmin.s f5, f17, f31                       ;
_l75:   beq x6, x6, _l134                                 ;
_l76:   fsgnjx.s f5, f23, f30                     ;
_l77:   la x24, _l130                                     ;
        jalr x26, 0(x24)                          ;
_l78:   mulh x29, x29, x30                        ;
_l79:   fsgnj.s f9, f30, f30                      ;
_l80:   slli x13, x13, 49                         ;
_l81:   fcvt.s.wu f8, x29, rup                    ;
_l82:   la x2, d_1_0                              ;
        lui x27, 0xffe00                          ;
        xor x2, x2, x27                           ;
        flw f25, 16(x2)                           ;
_l83:   la x6, d_5_2                              ;
        sd x1, 8(x6)                              ;
_l84:   la x4, d_5_10                             ;
        addi x4, x4, -12                          ;
        amomaxu.w x21, x25, (x4)                  ;
_l85:   la x17, d_5_7                             ;
        addi x17, x17, -0                         ;
        amominu.w x9, x25, (x17)                  ;
_l86:   fence                                     ;
_l87:   la x2, d_1_23                             ;
        addi x2, x2, 8                            ;
        lr.w x7, (x2)                             ;
_l88:   sllw x9, x12, x26                         ;
_l89:   la x17, d_4_23                            ;
        addi x17, x17, 0                          ;
        amomaxu.d x5, x28, (x17)                  ;
_l90:   fmin.s f4, f21, f23                       ;
_l91:   andi x18, x3, -0                          ;
_l92:   srliw x20, x28, 0                         ;
_l93:   la x12, _l135                                     ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l94:   srliw x26, x16, 0                         ;
_l95:   sllw x26, x8, x27                         ;
_l96:   la x18, d_1_22                            ;
        addi x18, x18, -0                         ;
        amomaxu.w x29, x7, (x18)                  ;
_l97:   fmax.s f31, f18, f1                       ;
_l98:   sraiw x5, x26, 14                         ;
_l99:   la x3, d_0_5                              ;
        lw x9, 28(x3)                             ;
_l100:  fcvt.wu.s x23, f3, rdn                    ;
_l101:  fmadd.s f7, f12, f11, f9, rtz             ;
_l102:  la x9, d_5_1                              ;
        addi x9, x9, -24                          ;
        lr.w x23, (x9)                            ;
_l103:  fcvt.s.l f28, x10, rtz                    ;
_l104:  fsgnjx.s f14, f23, f6                     ;
_l105:  la x25, _l144                                     ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l106:  auipc x0, 11                              ;
_l107:  la x13, _l129                                     ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l108:  la x17, d_1_9                             ;
        addi x17, x17, -16                        ;
        amoxor.w x28, x1, (x17)                   ;
_l109:  la x24, d_5_27                            ;
        addi x24, x24, -0                         ;
        sc.w x10, x1, (x24)                       ;
_l110:  fcvt.s.w f15, x9, rmm                     ;
_l111:  divu x11, x0, x29                         ;
_l112:  srliw x11, x5, 1                          ;
_l113:  la x28, d_0_12                            ;
        addi x28, x28, 0                          ;
        amoswap.w x2, x25, (x28)                  ;
_l114:  fmin.s f21, f3, f17                       ;
_l115:  fcvt.s.l f27, x14, rtz                    ;
_l116:  fmul.s f3, f4, f17, rtz                   ;
_l117:  fsqrt.s f6, f23, rmm                      ;
_l118:  fmsub.s f29, f17, f19, f28, rmm           ;
_l119:  la x22, d_4_8                             ;
        sw x9, 12(x22)                            ;
_l120:  la x30, d_5_16                            ;
        addi x30, x30, 0                          ;
        amoadd.d x26, x21, (x30)                  ;
_l121:  la x13, d_4_11                            ;
        addi x13, x13, -12                        ;
        amoand.w x2, x8, (x13)                    ;
_l122:  la x5, _l140                                      ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_l123:  ori x19, x10, 66                          ;
_l124:  la x4, d_3_27                             ;
        lh x12, 2(x4)                             ;
_l125:  fcvt.s.l f19, x13, rtz                    ;
_l126:  addi x18, x16, -1016                      ;
_l127:  la x21, d_1_24                            ;
        addi x21, x21, 0                          ;
        amoxor.d x11, x6, (x21)                   ;
_l128:  la x11, d_2_24                            ;
        sh x7, 20(x11)                            ;
_l129:  ebreak                                    ;
_l130:  la x3, d_0_24                             ;
        addi x3, x3, 0                            ;
        sc.w x19, x18, (x3)                       ;
_l131:  la x22, d_1_22                            ;
        sb x4, -9(x22)                            ;
_l132:  fmul.s f21, f4, f18, rmm                  ;
_l133:  addw x14, x29, x22                        ;
_l134:  ebreak                                    ;
_l135:  slti x0, x10, -2047                       ;
_l136:  ori x22, x24, 600                         ;
_l137:  mulhsu x28, x27, x4                       ;
_l138:  flt.s x27, f24, f18                       ;
_l139:  la x16, d_5_9                             ;
        lh x13, 30(x16)                           ;
_l140:  la x11, d_1_17                            ;
        addi x11, x11, 0                          ;
        amoand.d x21, x14, (x11)                  ;
_l141:  fsgnjx.s f12, f9, f19                     ;
_l142:  fclass.s x13, f26                         ;
_l143:  la x3, d_0_13                             ;
        addi x3, x3, 12                           ;
        amomax.w x18, x30, (x3)                   ;
_l144:  fdiv.s f23, f23, f7, rup                  ;
_l145:;
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
                .dword 0x519896fde8dff956, 0x20459b9b815cc250
                .dword 0x6031b18248f86de1, 0x28060d957bc6b9de
d_0_0:          .dword 0xfc48fc9a6014a64f, 0x92e900b6f20229e1
d_0_1:          .dword 0x6dd13480a95407a9, 0x67c12a495a1c2bfb
d_0_2:          .dword 0x2fbcc0fa5ebede29, 0x8d1804560c13358d
d_0_3:          .dword 0x298a84405a5fbcc8, 0xa0a5c13de017f43b
d_0_4:          .dword 0x16275f68b5e1f482, 0x27fbd5d7cac233b3
d_0_5:          .dword 0x6752fa1857ca2595, 0xc1e5240938e76869
d_0_6:          .dword 0xc20e9dbb292f7e63, 0x8701a59be188136e
d_0_7:          .dword 0x6304e96884f38bbc, 0x24dcdbefc4435bb8
d_0_8:          .dword 0xf6a8901ff0dd8cbf, 0x7bc1876365b7e05d
d_0_9:          .dword 0x34d8a117b045350e, 0x860e3b5335d5d31e
d_0_10:         .dword 0x513c0eeea8958eef, 0xa54598da5761acc4
d_0_11:         .dword 0x2f50a5cc251a1b5c, 0x558279dd965744f9
d_0_12:         .dword 0xc90774becdd6f35d, 0x3356e17c8b95dc7c
d_0_13:         .dword 0xb0632eed01a5882f, 0x6f85e18f241b4b40
d_0_14:         .dword 0xca6d9c546a54ecc4, 0x83ba61b703fee4a5
d_0_15:         .dword 0xb46b4ebb9e4033b5, 0x419f98d9a74bb259
d_0_16:         .dword 0x81e136cb3a10f359, 0x094a378c915b15ee
d_0_17:         .dword 0xb4e917e6c660f2b0, 0x18b66231df43f1a2
d_0_18:         .dword 0x1d7fcdfd636baf4c, 0x9e3694a3b6ed574d
d_0_19:         .dword 0xaa44a22f988c471e, 0x057b7668633f1c17
d_0_20:         .dword 0x66c81a11829f2c29, 0x91434ae28b529c22
d_0_21:         .dword 0x742fb980c96c1b39, 0x65ff11b143820878
d_0_22:         .dword 0x1a89306ddfe5c72d, 0x1b095b7d7f1e9fc5
d_0_23:         .dword 0xb302e5054ad68c87, 0x5bc5ca388b9005b9
d_0_24:         .dword 0x5cfbc825a2c7e56d, 0xbb62c861ff656423
d_0_25:         .dword 0xc8e2ca34c0c0da2d, 0xe664fd56df9f2ae0
d_0_26:         .dword 0xefe972a445eec536, 0xf1f2a7c84877eabf
d_0_27:         .dword 0x44b49f464aae21a3, 0xa9c20c636bfb0f08
                .dword 0x361c1cb2117ec463, 0xe855b00d7a722159
                .dword 0xa0646925e3b836ac, 0x0be919460df59295
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x24172e664158e4f8, 0x974e761dacf927df
                .dword 0xc85d3e77f578f859, 0x4e787bd989b07b05
d_1_0:          .dword 0x97aed4da0fa705de, 0x8a26c8c040459a30
d_1_1:          .dword 0x493d6a475090e564, 0x3239d2534e99c5d5
d_1_2:          .dword 0xf2494db5752379f6, 0x97c6f0a844055a4c
d_1_3:          .dword 0x2fe149b5468f5584, 0x2afc685ed3d11136
d_1_4:          .dword 0xf6aafe2e48d86102, 0x35231ea73e5a7ad2
d_1_5:          .dword 0x952708526fd26964, 0x2622e97e6e791ba5
d_1_6:          .dword 0x1f887a2284722e28, 0xb804132e5612d025
d_1_7:          .dword 0x228480e568aaea2d, 0xf10a27d507ab1759
d_1_8:          .dword 0x2f50f00306081fab, 0x235456a037f6dea6
d_1_9:          .dword 0x9b3554435932aec9, 0x708a8fab0319d7b8
d_1_10:         .dword 0x1d65f7145695cd67, 0x7506a523220288f8
d_1_11:         .dword 0x074451e72df1eacd, 0xf4788a371392077b
d_1_12:         .dword 0x32cbf10ec43f380c, 0xa86fdc17199d3b8f
d_1_13:         .dword 0x3cdc660dc5491bb3, 0x4a0775757f300f3d
d_1_14:         .dword 0x7f2efefc7969b8b7, 0x7183929d5ed2ff31
d_1_15:         .dword 0xf11b564e9a2258d4, 0x910c7e918d471c8f
d_1_16:         .dword 0x5fff0344c2485bff, 0x761db7c054c0baa0
d_1_17:         .dword 0x978f066c8e0aa1ba, 0xa06c03a27fe9866a
d_1_18:         .dword 0xe8675b991f7f5e34, 0x07106fe67c1674ec
d_1_19:         .dword 0x157f4cf1208b8254, 0x04386ef7cb0f8c67
d_1_20:         .dword 0xaebac335fe02369a, 0xb1cacc041f2c96f9
d_1_21:         .dword 0x903c4f798f7a5f0b, 0xee512eebbc1a5387
d_1_22:         .dword 0x9f33f3904cd5f273, 0x7c2c60276f450988
d_1_23:         .dword 0x1d4e23a062884bb2, 0x3c3569d580ee0510
d_1_24:         .dword 0xe8a25ccbfc3a1977, 0xf676d8a9321ff788
d_1_25:         .dword 0xa5f69cbd655ccb22, 0xe260f2b65030b83e
d_1_26:         .dword 0xa326d409fee15693, 0xa12ce9dc4b422f95
d_1_27:         .dword 0x456bf12d628a5e1f, 0x562f8808622b318f
                .dword 0x3c16fa0aa8eeac39, 0x032b690304f6d940
                .dword 0xfc44bd0706378192, 0xf628b100b5772793
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xafe57a55e2af60b6, 0xea0842dc5f2d343e
                .dword 0x94e8f21237775b06, 0x868d050e76d7bfdd
d_2_0:          .dword 0x8b3dcb2f41ba0379, 0xc8d6c1c536b438c0
d_2_1:          .dword 0xcd1d2dd8167d8fea, 0x8e4ff60ebdb27a9f
d_2_2:          .dword 0x8724cdef89be3c55, 0x125d1e2f61a53a68
d_2_3:          .dword 0x6fb45bf4327e07bf, 0xe253972737689c08
d_2_4:          .dword 0xe636493b9f05d6d0, 0xfb3449482164deba
d_2_5:          .dword 0x7b737801a531bfdd, 0xd368eba11636ee44
d_2_6:          .dword 0x353466a3a1d9f319, 0xcf466561847406bb
d_2_7:          .dword 0xbe2fa0a70d05dea2, 0x3c687c77b35c0488
d_2_8:          .dword 0x3a3ab39b72d82901, 0x0674c9f27bf9f103
d_2_9:          .dword 0x27b36aa6d2d3d526, 0x1e6cdf608d3100f9
d_2_10:         .dword 0x0d0814d316ffb760, 0xa1894a04347d3e87
d_2_11:         .dword 0xb735bc08d3530e5c, 0xef6045f8a6b80449
d_2_12:         .dword 0x53e4eca3b8906cf6, 0xeed5f7670357c1d2
d_2_13:         .dword 0xdb98cc986eda2e6d, 0x3a65b5e5d53d62b3
d_2_14:         .dword 0x96c2fd388eaae0cc, 0x501aebabeda32743
d_2_15:         .dword 0x339a8f8de265269c, 0xb23f3929f36f82a8
d_2_16:         .dword 0x9f6788dc0d557fae, 0x2b938bd7ab63dc0c
d_2_17:         .dword 0xee4ba81e482b53d8, 0x542936d44c980738
d_2_18:         .dword 0xffd1294f4e79565a, 0xde612c96fa2294a6
d_2_19:         .dword 0x281b263497976aff, 0x231c3cf090963cea
d_2_20:         .dword 0x04b110762d270d2a, 0x4ea1cf9c9b5569ce
d_2_21:         .dword 0x305354d75385dea2, 0xcdf41008ce011f75
d_2_22:         .dword 0x95b014a886364c97, 0x2e7453ead9c2d641
d_2_23:         .dword 0x946497dce88ef242, 0xe586f70c3614fad5
d_2_24:         .dword 0xa8d1a5c1747854a3, 0x21fe96f9cc3d0db5
d_2_25:         .dword 0x25afffc8a56e089d, 0xf2647200ae9ee1ef
d_2_26:         .dword 0x285e2d891c28792e, 0x9c5cc93015fc5975
d_2_27:         .dword 0x1f1dfc0b65c23a31, 0x9534249129c92197
                .dword 0xedab9cd297c1537e, 0x79703780aa58119a
                .dword 0xad322430d3476ead, 0x7284cc5424f50c9a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf4124fa64312bdea, 0x4b02a59aac611b60
                .dword 0xb68c96ce13ce435e, 0x77f423948ebe16ae
d_3_0:          .dword 0x52c76b005abbcc1b, 0x6898b4ef6ac135c0
d_3_1:          .dword 0x20cc3fac178e2453, 0x6bfbdd7d909cbf52
d_3_2:          .dword 0x5a59d93972d14742, 0x9465a0c5d98efeb4
d_3_3:          .dword 0x628c5a597aba061b, 0x5738c1c5db5f651c
d_3_4:          .dword 0xd1c135ca89052201, 0xf0517e6a3f97cadd
d_3_5:          .dword 0xb158edc5adf2abd3, 0x651f68ad0a9ce95a
d_3_6:          .dword 0xbe3d69c9d68b110b, 0x497ebe423ea4d369
d_3_7:          .dword 0x0df84af120cdbe00, 0x00ad1b422cc073cb
d_3_8:          .dword 0xe715077a61cebab6, 0xe7ae726ed6e98727
d_3_9:          .dword 0xbae6c1404b62fbe7, 0xb2f0af6c4ab6827c
d_3_10:         .dword 0x9892c9c0ae2d8dfb, 0x64612fe28b691c69
d_3_11:         .dword 0xdfc84a9cb00ab1bb, 0x2384b56194d86bb7
d_3_12:         .dword 0x8ebcec61a8340c6e, 0xe2c2d545feeef360
d_3_13:         .dword 0xfe78379573af4a6c, 0x0a5dc5527df42cd2
d_3_14:         .dword 0xc1501165fe09618a, 0x9574267108ab7343
d_3_15:         .dword 0xceed7556492c0d01, 0xe08f8217f4e6909d
d_3_16:         .dword 0xbfdcd0de5052331b, 0x1cb4d8f8b9f99f12
d_3_17:         .dword 0x82100f74d7cb208b, 0x5228dfc7b441be6b
d_3_18:         .dword 0xfd874cc8219dfd6a, 0x49bd4df751aaa646
d_3_19:         .dword 0xc0211a141bf65f9e, 0x90f4b214ec8557ef
d_3_20:         .dword 0x4133c474b23717e8, 0x2e255e1e098a3b10
d_3_21:         .dword 0x21dc7c4bfde3e694, 0x4a53e0097e75a4c9
d_3_22:         .dword 0xe247d1afdf8c68de, 0xf3be55aabf108b29
d_3_23:         .dword 0x95ad65bfc8ba007d, 0x4635f9ca612d037b
d_3_24:         .dword 0xb79e9304fda77305, 0x561a9558ffe0e2a5
d_3_25:         .dword 0x61a2f7ac1618b3da, 0x3cc52acf131a3d21
d_3_26:         .dword 0x46c90f74de79b2af, 0x1925636e8b2731d6
d_3_27:         .dword 0x2084c2c676acfdb2, 0x1d9e59192630b943
                .dword 0x9b8e20a24268c745, 0x23dc0396f6563458
                .dword 0xad17e115071ae60e, 0x6922b615b31f4b3e
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xb3ff3160b3aee59f, 0xb3de053182a236ef
                .dword 0x27edc82cbbf198ed, 0x05fac753bfcd689f
d_4_0:          .dword 0x87649ff36b277188, 0x1beeac76e3a9f2ab
d_4_1:          .dword 0x82ce627f53676f98, 0xb270970e0c5d1a9f
d_4_2:          .dword 0xce6db5d6940cbd21, 0xb1ca04a9f075669a
d_4_3:          .dword 0x016d7ab1de2124ea, 0x8e3081adb55c7f17
d_4_4:          .dword 0xcce291b3818eb015, 0x67e64d3d871f9263
d_4_5:          .dword 0x8bfe41c09045f7d8, 0x0dbc6950edc42f43
d_4_6:          .dword 0x72f44892ace36580, 0x8c916c9447cb070c
d_4_7:          .dword 0x6ec06305c728b726, 0x7c2f3d5ccb0ccbb1
d_4_8:          .dword 0x26ab2e5224c050a4, 0xd340e963f4451b9f
d_4_9:          .dword 0xd4a5373fb836d73a, 0xd73923aaf4968c26
d_4_10:         .dword 0xaf4ec314c1e6649f, 0xf37ecd9d48dfcfe4
d_4_11:         .dword 0x4f79774c15c6fae8, 0x4767f83c34892823
d_4_12:         .dword 0x37449dc58af906e7, 0x5bfa9f6449037ee6
d_4_13:         .dword 0xbc796a34dfeb8ee1, 0x9f67760eb429379d
d_4_14:         .dword 0xb87e2180b2604b58, 0x9bb6b0dcbe759840
d_4_15:         .dword 0x6c447e371189a905, 0x47bf6373fa1babda
d_4_16:         .dword 0x08d62a1aea400e7b, 0x4e1eaf2a6a46c0dc
d_4_17:         .dword 0x9dfec52da5fa52cc, 0xe549548ce5f4e3df
d_4_18:         .dword 0x37efc9f439ded6e7, 0x7546e869474ad0bc
d_4_19:         .dword 0x204fb24949cb77bd, 0xf7abd82fb7b1256c
d_4_20:         .dword 0x4c255127fb2bda51, 0xd7d0b9b742625dde
d_4_21:         .dword 0x2f079a0259234208, 0x2ce99ab6e38f1d5e
d_4_22:         .dword 0x69877ad8e8dcb05e, 0x812b9da42b0f1f46
d_4_23:         .dword 0xfc98e0448bd06c0d, 0x7ae79a1835a1ba3f
d_4_24:         .dword 0xbe77ce01cb1d4595, 0x8e03cb294e8f00bf
d_4_25:         .dword 0x9b9b3995d8d162c5, 0xe11a3f47491e53bf
d_4_26:         .dword 0xebbc3932be2d231f, 0xf8c119b739a65021
d_4_27:         .dword 0x2f5f114eb9332174, 0x7af6129c11d26b4b
                .dword 0x1c46e8ed01848d20, 0x65bd5a62ad6be470
                .dword 0x88219e556a557f14, 0x5bf8d66e5dd6158f
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x93d877347b15e2f0, 0xb47aadf2eac0f8c7
                .dword 0xce2b6b933fd4322d, 0xcf219ec3582acb25
d_5_0:          .dword 0x158aa21505223ddc, 0xfe81907ab97c36c3
d_5_1:          .dword 0xd4e016e5742aaa50, 0x4b677afc79e513c9
d_5_2:          .dword 0x89c52b755fd3771a, 0x3c17ab9f884f45ae
d_5_3:          .dword 0x9487cfb92cec09f6, 0x231b3be19de27ed8
d_5_4:          .dword 0x5c319b1c0d064411, 0x7e78a28e8c619ae6
d_5_5:          .dword 0x554b9f12ed2b76ab, 0x21748de4f5e09235
d_5_6:          .dword 0xbe84777b30c161c1, 0x1783ba791c2e3d20
d_5_7:          .dword 0x8e64cfbbdf42178b, 0xf3af054a4bf11ba1
d_5_8:          .dword 0x02280ec365d00d25, 0x546c5ef417e16e1f
d_5_9:          .dword 0xdfa98f80776c7f96, 0x1b6b6ac435a3c5d9
d_5_10:         .dword 0x8da7307f32b10013, 0x779e0cda384fc66e
d_5_11:         .dword 0x7d05dff2842e1dc2, 0xbc22511d736b008c
d_5_12:         .dword 0xb8433ddf5af42b88, 0xf41e758f2fdfaabe
d_5_13:         .dword 0xcbdd22a2f699ba74, 0x4f53088124b323b9
d_5_14:         .dword 0xddef76f62e464972, 0x9419ede83daed485
d_5_15:         .dword 0x389ff5cb4d6452e1, 0xdbb5d1e20c85c81a
d_5_16:         .dword 0x2220a60399134988, 0xab20cefb04232728
d_5_17:         .dword 0xa9bacdb45094f291, 0xc003c48f14014a5a
d_5_18:         .dword 0x86fc846df4e778d6, 0xe4c90ec7b6367eaf
d_5_19:         .dword 0x2c2ab015b7fb1306, 0xe06526628bde4ee0
d_5_20:         .dword 0x45a3ab24a28a8449, 0x83ec65f80df2ced9
d_5_21:         .dword 0x4793a9d2e6a67354, 0x91a6d697bf8103ad
d_5_22:         .dword 0xb787c43f2f38b902, 0x9c66063669b5a54e
d_5_23:         .dword 0xa9396ba7d962a5e5, 0x0826ae5439cd4237
d_5_24:         .dword 0x6c80854374b8c3cb, 0x4612dbcd2f4d0350
d_5_25:         .dword 0x742307fc3bb2b2ed, 0x50cab10fea971b32
d_5_26:         .dword 0xb3c1a086d1cd4810, 0x62d307e630e5fad8
d_5_27:         .dword 0x2e879d18c863ffe7, 0x7574729d7c00bc13
                .dword 0xb062aa001267e816, 0x9835e8a7c010a5bc
                .dword 0xf6beb8e1570e9f46, 0xb77c51c10e73d156
         /* Random data */
_end_data5:
              
                 
