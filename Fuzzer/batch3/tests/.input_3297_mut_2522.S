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
_s0:    andi x19, x6, 1593                        ;
_s1:    li x29, 0                                 ;
        la x11, pt2                               ;
        addi x11, x11, 48                         ;
        sfence.vma x29, x11                       ;
_s2:    ebreak                                    ;
_s3:    fsgnj.s f20, f1, f15                      ;
_s4:    la x4, d_1_3                              ;
        addi x4, x4, 20                           ;
        lui x16, 0xffe00                          ;
        xor x4, x4, x16                           ;
        amomax.w x26, x16, (x4)                   ;
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
_p0:    xor x14, x14, x14                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 30                         ;
        add x14, x14, x14                         ;
        csrrw x10, fcsr, x14                      ;
_p1:    csrrci x11, mscratch, 17                  ;
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
_l0:    la x27, d_3_22                            ;
        addi x27, x27, 0                          ;
        lr.d x8, (x27)                            ;
_l1:    auipc x1, 1048575                         ;
_l2:    la x4, d_4_14                             ;
        sd x8, -24(x4)                            ;
_l3:    div x11, x19, x3                          ;
_l4:    fnmsub.s f8, f8, f1, f1, rne              ;
_l5:    slti x23, x8, 446                         ;
_l6:    addi x12, x27, -1221                      ;
_l7:    la x21, _l41                              ;
        lhu x21, 22(x21)                          ;
_l8:    xor x8, x8, x8                            ;
        addi x4, zero, 1                          ;
        slli x4, x4, 19                           ;
        add x8, x8, x4                            ;
        addi x27, zero, 1                         ;
        slli x27, x27, 14                         ;
        add x8, x8, x27                           ;
        csrrs x26, sie, x8                        ;
_l9:    addiw x2, x24, -2047                      ;
_l10:   rem x27, x14, x0                          ;
_l11:   rem x10, x23, x21                         ;
_l12:   la x1, d_0_7                              ;
        addi x1, x1, -16                          ;
        sc.d x7, x1, (x1)                         ;
_l13:   la x23, d_5_0                             ;
        addi x23, x23, -0                         ;
        amominu.d x18, x3, (x23)                  ;
_l14:   fnmsub.s f22, f26, f15, f23, rup          ;
_l15:   jal x1, _l40                                      ;
_l16:   csrrsi x15, sie, 4                        ;
_l17:   fsqrt.s f8, f19, rmm                      ;
_l18:   srlw x29, x29, x0                         ;
_l19:   la x1, d_2_20                             ;
        addi x1, x1, -8                           ;
        lui x30, 0xffe00                          ;
        xor x1, x1, x30                           ;
        amoswap.d x9, x30, (x1)                   ;
_l20:   la x27, d_3_8                             ;
        flw f16, -8(x27)                          ;
_l21:   mul x29, x13, x20                         ;
_l22:   xor x19, x19, x19                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 18                           ;
        add x19, x19, x2                          ;
        addi x1, zero, 3                          ;
        slli x1, x1, 21                           ;
        add x19, x19, x1                          ;
        addi x9, zero, 1                          ;
        slli x9, x9, 8                            ;
        add x19, x19, x9                          ;
        csrrs x7, sip, x19                        ;
_l23:   la x23, d_5_19                            ;
        lbu x21, -20(x23)                         ;
_l24:   fdiv.s f8, f1, f12, rdn                   ;
_l25:   li x10, 0                                 ;
        la x6, pt0                                ;
        addi x6, x6, 16                           ;
        sfence.vma x10, x6                        ;
_l26:   csrrsi x28, pmpaddr0, 26                  ;
_l27:   la x23, d_2_13                            ;
        addi x23, x23, 12                         ;
        amoor.w x12, x2, (x23)                    ;
_l28:   fcvt.s.wu f17, x2, rmm                    ;
_l29:   la x9, d_3_14                             ;
        addi x9, x9, 16                           ;
        sc.d x12, x9, (x9)                        ;
_l30:   la x10, d_3_27                            ;
        lb x26, 27(x10)                           ;
_l31:   la x12, d_0_5                             ;
        addi x12, x12, -0                         ;
        sc.w x14, x8, (x12)                       ;
_l32:   la x1, d_1_20                             ;
        addi x1, x1, 0                            ;
        amomax.d x26, x27, (x1)                   ;
_l33:   la x10, d_2_24                            ;
        addi x10, x10, 16                         ;
        lui x5, 0xffe00                           ;
        xor x10, x10, x5                          ;
        amomin.d x25, x5, (x10)                   ;
_l34:   la x7, d_1_8                              ;
        addi x7, x7, 0                            ;
        amoadd.w x17, x26, (x7)                   ;
_l35:   la x23, d_1_14                            ;
        lui x11, 0xffe00                          ;
        xor x23, x23, x11                         ;
        fsw f29, -12(x23)                         ;
_l36:   la x16, d_0_2                             ;
        addi x16, x16, 0                          ;
        sc.d x17, x16, (x16)                      ;
_l37:   lui x15, 239044                           ;
_l38:   xor x1, x1, x1                            ;
        addi x28, zero, 3                         ;
        slli x28, x28, 8                          ;
        add x1, x1, x28                           ;
        csrrs x15, scause, x1                     ;
_l39:   fnmsub.s f9, f11, f29, f11, rdn           ;
_l40:   la x9, d_0_9                              ;
        addi x9, x9, 12                           ;
        amoxor.w x19, x12, (x9)                   ;
_l41:   sraw x15, x13, x11                        ;
_l42:   la x10, d_1_20                            ;
        lw x10, 12(x10)                           ;
_l43:   la x15, _l110                             ;
        lbu x14, -19(x15)                         ;
_l44:   bge x19, x20, _l113                                ;
_l45:   remu x17, x13, x13                        ;
_l46:   la x13, d_4_18                            ;
        addi x13, x13, 8                          ;
        amoadd.w x7, x16, (x13)                   ;
_l47:   ori x0, x5, -0                            ;
_l48:   la x1, d_3_12                             ;
        addi x1, x1, -8                           ;
        amoswap.d x10, x29, (x1)                  ;
_l49:   csrrsi x2, pmpaddr0, 11                   ;
_l50:   bgeu x20, x26, _l118                      ;
_l51:   beq x2, x2, _l129                                 ;
_l52:   fcvt.s.wu f0, x30, dyn                    ;
_l53:   la x21, d_5_15                            ;
        ld x6, -16(x21)                           ;
_l54:   mulw x8, x0, x17                          ;
_l55:   rem x7, x11, x13                          ;
_l56:   divw x30, x29, x16                        ;
_l57:   fmul.s f10, f8, f21, dyn                  ;
_l58:   la x6, _l38                                       ;
        lw x6, -20(x6)                            ;
_l59:   fcvt.s.l f1, x9, dyn                      ;
_l60:   divu x10, x4, x9                          ;
_l61:   la x6, d_2_2                              ;
        addi x6, x6, 0                            ;
        amomin.d x20, x22, (x6)                   ;
_l62:   fmul.s f31, f26, f20, rmm                 ;
_l63:   la x21, d_0_5                             ;
        lui x17, 0xffe00                          ;
        xor x21, x21, x17                         ;
        flw f12, 8(x21)                           ;
_l64:   fnmsub.s f6, f17, f15, f11, rdn           ;
_l65:   la x5, d_1_3                              ;
        addi x5, x5, 0                            ;
        amoadd.w x20, x27, (x5)                   ;
_l66:   slliw x5, x23, 0                          ;
_l67:   fcvt.w.s x20, f16, rne                    ;
_l68:   la x26, d_1_10                            ;
        addi x26, x26, 0                          ;
        amoand.d x5, x2, (x26)                    ;
_l69:   addi x17, x23, -2037                      ;
_l70:   la x12, _l78                                      ;
        csrrw zero, mepc, x12                     ;
        mret                                      ;
_l71:   ebreak                                    ;
_l72:   la x30, d_0_5                             ;
        fsw f10, 28(x30)                          ;
_l73:   srliw x7, x28, 5                          ;
_l74:   la x24, d_2_4                             ;
        addi x24, x24, 8                          ;
        amoswap.w x29, x30, (x24)                 ;
_l75:   ecall                                     ;
_l76:   fclass.s x8, f16                          ;
_l77:   fmul.s f13, f2, f13, rtz                  ;
_l78:   fsub.s f26, f1, f1, rdn                   ;
_l79:   ori x28, x23, 1654                        ;
_l80:   la x24, d_2_24                            ;
        sb x17, 0(x24)                            ;
_l81:   divu x9, x20, x14                         ;
_l82:   sraiw x19, x1, 24                         ;
_l83:   la x9, d_2_10                             ;
        addi x9, x9, 8                            ;
        lr.w x23, (x9)                            ;
_l84:   la x24, _l135                                     ;
        csrrw zero, sepc, x24                     ;
        sret                                      ;
_l85:   fadd.s f17, f10, f1, rup                  ;
_l86:   fmsub.s f23, f26, f0, f15, rne            ;
_l87:   jal x24, _l140                                    ;
_l88:   fsgnj.s f21, f17, f4                      ;
_l89:   la x13, d_1_1                             ;
        ld x1, -0(x13)                            ;
_l90:   la x15, d_2_16                            ;
        addi x15, x15, -12                        ;
        lui x10, 0xffe00                          ;
        xor x15, x15, x10                         ;
        amoand.w x8, x10, (x15)                   ;
_l91:   fsub.s f30, f12, f22, rmm                 ;
_l92:   ori x15, x7, 771                          ;
_l93:   la x16, _l96                                      ;
        srai x16, x16, 1                          ;
        csrrc x3, pmpaddr3, x16                   ;
_l94:   la x29, d_3_22                            ;
        addi x29, x29, 8                          ;
        amoadd.d x17, x23, (x29)                  ;
_l95:   fle.s x2, f24, f15                        ;
_l96:   csrrwi x10, sepc, 4                       ;
_l97:   srlw x27, x12, x30                        ;
_l98:   la x6, d_5_13                             ;
        addi x6, x6, 16                           ;
        lui x23, 0xffe00                          ;
        xor x6, x6, x23                           ;
        amoor.w x15, x23, (x6)                    ;
_l99:   div x3, x5, x5                            ;
_l100:  addw x28, x6, x22                         ;
_l101:  sltiu x8, x2, -1360                       ;
_l102:  la x11, d_3_10                            ;
        addi x11, x11, -24                        ;
        amomin.d x28, x28, (x11)                  ;
_l103:  csrrsi x24, sstatus, 12                   ;
_l104:  fsub.s f6, f8, f27, rtz                   ;
_l105:  fsgnjn.s f1, f26, f10                     ;
_l106:  fmadd.s f6, f25, f23, f16, rdn            ;
_l107:  la x1, d_5_23                             ;
        addi x1, x1, 28                           ;
        amomaxu.w x26, x26, (x1)                  ;
_l108:  la x24, d_2_26                            ;
        addi x24, x24, 16                         ;
        amomin.w x22, x20, (x24)                  ;
_l109:  fclass.s x20, f12                         ;
_l110:  csrrsi x20, pmpaddr0, 5                   ;
_l111:  mulhsu x7, x3, x13                        ;
_l112:  fsqrt.s f5, f24, dyn                      ;
_l113:  la x24, _l138                                     ;
        csrrw zero, sepc, x24                     ;
        sret                                      ;
_l114:  fmax.s f31, f18, f1                       ;
_l115:  la x23, d_4_4                             ;
        lw x27, 0(x23)                            ;
_l116:  srlw x17, x8, x7                          ;
_l117:  mulhsu x25, x5, x30                       ;
_l118:  remw x20, x26, x22                        ;
_l119:  bgeu x7, x23, _l121                       ;
_l120:  fle.s x10, f8, f3                         ;
_l121:  la x22, d_4_8                             ;
        sw x9, 12(x22)                            ;
_l122:  la x5, _l132                                      ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_l123:  xor x17, x17, x17                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 27                           ;
        add x17, x17, x7                          ;
        addi x8, zero, 1                          ;
        slli x8, x8, 12                           ;
        add x17, x17, x8                          ;
        csrrc x12, sstatus, x17                   ;
_l124:  feq.s x14, f6, f19                        ;
_l125:  la x17, d_1_11                            ;
        lwu x10, 0(x17)                           ;
_l126:  addw x4, x1, x7                           ;
_l127:  la x21, d_5_9                             ;
        addi x21, x21, -16                        ;
        lr.d x28, (x21)                           ;
_l128:  fsgnjx.s f6, f8, f9                       ;
_l129:  fmv.x.w x1, f10                           ;
_l130:  la x28, d_5_5                             ;
        addi x28, x28, 24                         ;
        amominu.d x2, x12, (x28)                  ;
_l131:  la x3, d_0_24                             ;
        addi x3, x3, 0                            ;
        sc.w x19, x18, (x3)                       ;
_l132:  fmul.s f21, f4, f18, rmm                  ;
_l133:  la x25, d_1_14                            ;
        addi x25, x25, -8                         ;
        sc.d x2, x25, (x25)                       ;
_l134:  fmul.s f30, f27, f15, rup                 ;
_l135:  la x29, _l137                                     ;
        srai x29, x29, 1                          ;
        csrrs x7, pmpaddr1, x29                   ;
_l136:  fsgnjx.s f10, f24, f9                     ;
_l137:  ebreak                                    ;
_l138:  remuw x16, x0, x3                         ;
_l139:  fmin.s f18, f15, f19                      ;
_l140:  xori x28, x30, -893                       ;
_l141:  slliw x3, x17, 0                          ;
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
                .dword 0x821e3d94f10785fc, 0x9d198aab81f4dd5e
                .dword 0xdce7050ed4608c5d, 0xb4dc7e967fccd588
d_0_0:          .dword 0xde4666b4c7cd785b, 0x0f80d07b3e745472
d_0_1:          .dword 0x3a291143802be03e, 0x936022fe00f99265
d_0_2:          .dword 0xdd90fe0f8e932e5d, 0xc55c989e07d8dcb2
d_0_3:          .dword 0xfd9a4384489388f9, 0x49e8d3221b335585
d_0_4:          .dword 0x488b82dd43b06b58, 0xa3c1f262733a0760
d_0_5:          .dword 0xa59683f2d56eb229, 0x80705701f95457f8
d_0_6:          .dword 0xaa8692a91401cf4f, 0x9a39c83a02a16e57
d_0_7:          .dword 0xa65aac255a0ea252, 0x923631e707bfd0f6
d_0_8:          .dword 0x6cf27650c1a1d5e7, 0x667050f944696c00
d_0_9:          .dword 0x9084381232195ff8, 0xab8667b06cbea6c8
d_0_10:         .dword 0x6b7fae49813712a5, 0xf0a428ff248eefaa
d_0_11:         .dword 0x50bedd22b585495a, 0x6b5f904b641ae6d1
d_0_12:         .dword 0xb4702c03edb886ec, 0xea493eead31f33c1
d_0_13:         .dword 0x796436ccdaf9febd, 0x3f2a2ce7d4eaf6d0
d_0_14:         .dword 0xc4c5c1c54d18ab33, 0x0227a44059d49c80
d_0_15:         .dword 0xae23abf2a9675b01, 0x524df091a64faa94
d_0_16:         .dword 0x313b2bc7ec7719ce, 0xbd8992ad8ef196e0
d_0_17:         .dword 0x5204a3e11ad41fa7, 0xdab087149f8f8a7f
d_0_18:         .dword 0x3bbcaf6e354a121f, 0x8478ca5635aeb875
d_0_19:         .dword 0x356312688759582b, 0xdd9635ab42d3594b
d_0_20:         .dword 0x33ec642c854ce253, 0x4660945ef9db5cc0
d_0_21:         .dword 0x6fd9aa00994ca181, 0x8df89d5078a76c49
d_0_22:         .dword 0x0dc0de8eb43072a4, 0xf36a9fc627fcce57
d_0_23:         .dword 0x4194cb9c23768dc7, 0xee764da4dba7fae2
d_0_24:         .dword 0xf82479a32f95cd46, 0x0258e87e92325909
d_0_25:         .dword 0xe7eb104557bf94c4, 0xe2bc36a230fe04bb
d_0_26:         .dword 0x607b275a2c90790a, 0xebc76043a8399988
d_0_27:         .dword 0x39181830e55ce05d, 0xd0c1968a8d3eb093
                .dword 0xe1517604c718ddd0, 0xef500be7a1ead69a
                .dword 0x85e7a3356b5cb264, 0x3b5eaa534073a8bb
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0184e6c180d2107b, 0x24d1e9e2ac5a084c
                .dword 0x572c3f50d6c030d8, 0x491b780f2499774c
d_1_0:          .dword 0x8eac7df8319e7113, 0x4802e88993da4243
d_1_1:          .dword 0x4c62a3e3c6b27c3c, 0x3b9cd1b7eb3744cd
d_1_2:          .dword 0xe2aa743f9bc61bcc, 0xeda251af60b219a6
d_1_3:          .dword 0x28152c8eca9ffdc4, 0x9a34b33de4b4224e
d_1_4:          .dword 0x8467f419ec085915, 0x4d66542afe36688a
d_1_5:          .dword 0xbef3cfa3ae6d249a, 0x5689726d0b9d42ee
d_1_6:          .dword 0xc5d688a5d00bfe72, 0xb5d56da77e4b6102
d_1_7:          .dword 0xa4cd30432253aa7c, 0x346d6175d9f08c62
d_1_8:          .dword 0x15fd84bb6a15097b, 0x48e7d8da00f90208
d_1_9:          .dword 0xc9cad4f64ba57cca, 0xfd6388b8bb444c13
d_1_10:         .dword 0x9ea504405c5cd283, 0xf55e57a752bd7974
d_1_11:         .dword 0xeea99ca69748a496, 0xe1709082a31271f9
d_1_12:         .dword 0x6b6909cbb21f8083, 0x7777a865ced8cfbf
d_1_13:         .dword 0x9d3cb42d8402ecce, 0x86a67e84bc125b27
d_1_14:         .dword 0x8fa5ee3b8391a62c, 0xe5e9467b66e4a5a4
d_1_15:         .dword 0x207df8fb2e8dc1e7, 0x2aaa9679b48e7a5e
d_1_16:         .dword 0x6df2cced3689a14d, 0xc9b839b5bdfad8de
d_1_17:         .dword 0x9d94624e89638b51, 0x794986de73ca0028
d_1_18:         .dword 0x49725147c783d7b9, 0xb90a871805ca7e2c
d_1_19:         .dword 0x62b423bdb2690d42, 0x52e431a588f0a859
d_1_20:         .dword 0x54c281382bd7be43, 0xb654709bd33c44ab
d_1_21:         .dword 0x205ae562f08c73b0, 0x8882cfe9fb0ad44a
d_1_22:         .dword 0xb7b93ec9fea9a1d3, 0x137ae2551f2558b8
d_1_23:         .dword 0xb3ca9b374acd8177, 0x7fc156c190d54cd5
d_1_24:         .dword 0x86042c1b7cb725d3, 0x88f483a979ac1597
d_1_25:         .dword 0x7c9e51f22816da97, 0x2c4cae5a5b3037ec
d_1_26:         .dword 0x366d87b449ac1391, 0x01ec00646f09a9b2
d_1_27:         .dword 0x5c18d36a80484d9a, 0xe37dee27ca962b55
                .dword 0xcd8178647d7c872d, 0x588dab49bee23b94
                .dword 0xaf2996262bc6cb31, 0xf69dabcc5d5825f6
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x86fad6e6b18b24eb, 0xead05c0ec6bc0c7b
                .dword 0x4b4f65107f766e01, 0x0262bd19d5138d21
d_2_0:          .dword 0xeeaf3039392efd38, 0xcecbdfcbbe9b5e78
d_2_1:          .dword 0x822401902b124674, 0xfcb5f10bc7f2459d
d_2_2:          .dword 0x3de686297354e8df, 0xddae5e0e75594121
d_2_3:          .dword 0x5878bafaa8ff57ed, 0x8adcef4d81a71133
d_2_4:          .dword 0x1fa5f84a3a599b35, 0x87b99d4a28a033df
d_2_5:          .dword 0x216e47230327fb4d, 0xb2addce93deb1ec8
d_2_6:          .dword 0xa57ae5a94895aea5, 0x3aa77110f8da0c34
d_2_7:          .dword 0x72bfc60ddb6ff040, 0x0057838dc12b960e
d_2_8:          .dword 0xd1adc8aee521af3e, 0x76c26a7b27b44ddc
d_2_9:          .dword 0xdeb11a6ac4b888ce, 0xaa34041676a3f4c7
d_2_10:         .dword 0x4daee46da670816a, 0xa8a0bf7a50d8efa0
d_2_11:         .dword 0x44b3df1237c2d838, 0xe781ce5cf04fc90d
d_2_12:         .dword 0x7aac959fc7fc2882, 0x84c85bd5a07b3aa0
d_2_13:         .dword 0xdda2159eec5ddaa2, 0x86defc02b9f1a17b
d_2_14:         .dword 0x171d9a2ab5c4f7f7, 0x6a8b19af5a4cf512
d_2_15:         .dword 0x074b2e57b4e38520, 0x4c96dcf8f1f77bea
d_2_16:         .dword 0x2e3abe7f7bccc847, 0x4a8bfeb28bd2bf87
d_2_17:         .dword 0xbfe284af56316a49, 0x0cc3e5ed678273d4
d_2_18:         .dword 0x78230541ed6cee43, 0xfe39126a3c2944ff
d_2_19:         .dword 0x17f9990f8c445abf, 0x2dd3f2378d89c4b6
d_2_20:         .dword 0xc1233b293f109cfe, 0xfff515359e1fb770
d_2_21:         .dword 0x52a28b32c2a2197a, 0x578b353ee61f7304
d_2_22:         .dword 0x0820ca4ed5148cc6, 0x48579701c2323399
d_2_23:         .dword 0x4b6cea19cb9f551f, 0x2b7ee3d5edf7a201
d_2_24:         .dword 0x6512fd386d2d39b6, 0xa2b2cf9af3d3ab59
d_2_25:         .dword 0x46144aa54c85f6c7, 0x7c31ea182ba7cba2
d_2_26:         .dword 0xf6ce863314532ec1, 0x2b8bfb6119a8145f
d_2_27:         .dword 0x6c868c2f3aeb7ea4, 0x7185baabe839abd4
                .dword 0x30f84d4844185481, 0x27ac3e5ce34f93ed
                .dword 0x27ca3587fca8a4fe, 0x8704bf5412d3baf7
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xdb4eecc76aa5c7a3, 0xaf2e318e664e3404
                .dword 0x581e805964956e50, 0x18b501c5b519d278
d_3_0:          .dword 0xe486d7c139208ccf, 0x5684f94ad1359386
d_3_1:          .dword 0xe1ed747541482a6f, 0x2abda6b8d6dee01a
d_3_2:          .dword 0xa8f959b7aeacb2f4, 0x69e38bbbb64f0ae4
d_3_3:          .dword 0x148ae88efee47468, 0xaeb087c199e47678
d_3_4:          .dword 0x4f962fafb0430174, 0x6dfd341a76988bde
d_3_5:          .dword 0xd784915e421cda94, 0xfbcba4672122dc3b
d_3_6:          .dword 0x4b6b19282be1cc93, 0x8919edfa24ceea8c
d_3_7:          .dword 0xffdd0ca925708887, 0x49e7648df8b90f5a
d_3_8:          .dword 0xc1b8ddd1922353b5, 0x833b3e33c1795ba9
d_3_9:          .dword 0x42eb511100fe4a0f, 0xa0097dca344a9a22
d_3_10:         .dword 0x44e824f2854ae53f, 0x37ff43c87f999cbe
d_3_11:         .dword 0xd96c511c908ca3e4, 0x87fee3831a664549
d_3_12:         .dword 0xc9022fa5b2238e1a, 0xd160cca5f67e44be
d_3_13:         .dword 0x3ebf6598aae6ad97, 0xcd2bd010417ef3dd
d_3_14:         .dword 0x53a5df9eb378d006, 0x034b11bf0107eac0
d_3_15:         .dword 0xe498bbeaa91147ab, 0xb62969cc88ff62d0
d_3_16:         .dword 0x0be1b0098cb590bc, 0xa7c7004b11699fe7
d_3_17:         .dword 0x3bd5d6ce750fcdd7, 0x5a2476cc913d99d3
d_3_18:         .dword 0x0b8be842b70b66df, 0x472ad68598a037f1
d_3_19:         .dword 0x254ac42eb6a3971e, 0xe48c99f872f7895f
d_3_20:         .dword 0x5f7e49e8e4e394ad, 0xe23a129b51b3e148
d_3_21:         .dword 0xfdf0cf055e50bb59, 0xc7c823fe56530ad2
d_3_22:         .dword 0x09ed8b99bacda765, 0x257c4b3d8f075c72
d_3_23:         .dword 0x9de9a6c6d826b078, 0xe465510a5c4ee01e
d_3_24:         .dword 0x90d96c4f1c41b3de, 0x835592294ab14cd0
d_3_25:         .dword 0x9ebbe0cb24a31a4c, 0x34bb1b60e7f11cf6
d_3_26:         .dword 0x76d043af5f9b1d3a, 0x6a0c678837d0d5cd
d_3_27:         .dword 0xe263bcd123c0ed13, 0xfc8de1a148f1631c
                .dword 0x746a8980d47e1b65, 0x03348990671e13d8
                .dword 0x72286e265724a70e, 0x3534f55c2289a330
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x90e620e6a1aca980, 0xc19c0cc5e6372d1e
                .dword 0x9ba138b641f2a5d4, 0xd73ac8e593db41dd
d_4_0:          .dword 0xe1e61f0dfb5534fa, 0x744bc2a78d9978b1
d_4_1:          .dword 0x2c895f471978418d, 0xe00ad7f801730ee6
d_4_2:          .dword 0x3a7db08910beef73, 0xc3aed06b9978c69b
d_4_3:          .dword 0x3de5ba36a5b31d95, 0x9f2ad85c08229563
d_4_4:          .dword 0x94907500af18d235, 0x6f1bf49c91f6b17d
d_4_5:          .dword 0xac68354ec2ca7b9b, 0x0a35095df91fbe19
d_4_6:          .dword 0xfdd1e22b87cc77d3, 0x1d10ea5582fa99b3
d_4_7:          .dword 0x062957c773a0a10f, 0x5067a1070524d72f
d_4_8:          .dword 0xb7799bdfabfa9bf7, 0xa0452aa62410ffa8
d_4_9:          .dword 0x043681b55b06e1c3, 0x73ef34a44f551474
d_4_10:         .dword 0xbff56aea6af8e9e4, 0x0cc09026be48256f
d_4_11:         .dword 0xe63e31f62d076b42, 0x88921092eda51f2a
d_4_12:         .dword 0x52c3d07507994b1f, 0xe902712805a64a73
d_4_13:         .dword 0x43363ea92d70051c, 0x37ac8b948c13376f
d_4_14:         .dword 0x2fb777b86781fb00, 0xc19ac4659280ee95
d_4_15:         .dword 0x27521b9a54d139a5, 0xdf4d101f3add52a6
d_4_16:         .dword 0xd2e3afe67e606cb3, 0xa48864130fdef824
d_4_17:         .dword 0x1898ae421313839a, 0x5e3d6a6d7dc0e0d2
d_4_18:         .dword 0x75557a2db7241dc5, 0x83e36b3bb3bdb4b3
d_4_19:         .dword 0xd225b6d427fbf26a, 0x2c4cab1481404a4c
d_4_20:         .dword 0x3343adcb7a960083, 0xa91d307be79a4ddd
d_4_21:         .dword 0xfdae2657e4035bbd, 0xecfb3108a6a652c4
d_4_22:         .dword 0xcec6f65110e349e3, 0xfee7a38b6bafe332
d_4_23:         .dword 0xe935a4ba759e4bf8, 0xa98a1a25a2ae1bd9
d_4_24:         .dword 0x35efe641f3fb62a1, 0x9460a30c2f685565
d_4_25:         .dword 0xd05418474307974a, 0x8106422da6c385e1
d_4_26:         .dword 0x7e5750f9d4bebfa1, 0xdff91d716272dcde
d_4_27:         .dword 0x0034e29e7b1524a4, 0x7164ed75a09993a2
                .dword 0xecfec5212118914a, 0x4b64c495514a7e7d
                .dword 0x98130332fb89ff39, 0xa06025976169a3dd
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xc726dc620d332ea3, 0x6c5f26e46a1a2c65
                .dword 0x224be3d7342ea9ba, 0xc435194f657650ac
d_5_0:          .dword 0x8eebbbc2dfde3e62, 0x6a37f4e7a0ba98c4
d_5_1:          .dword 0xf3c072224ac828df, 0x78343a1bc280a9a7
d_5_2:          .dword 0xbdccc5f553ce8a88, 0x62b82794649abedd
d_5_3:          .dword 0x1e714d438bb81d61, 0x1af7fc479e23a516
d_5_4:          .dword 0x1d591d215dbee372, 0x5c995070255b80d0
d_5_5:          .dword 0x1a711aa9e4bac7ac, 0xda38333ce39eb961
d_5_6:          .dword 0xd04601b0b5ae726c, 0x09a4ad23909fe212
d_5_7:          .dword 0xbd2cc4aaac5417fd, 0x0c7a6ee912e85613
d_5_8:          .dword 0xdfd49fc958d32548, 0x23a2375951c8c7b0
d_5_9:          .dword 0x596642e9bbbc7475, 0xc6045f66fedfd7cf
d_5_10:         .dword 0x1d25473d601b9f72, 0xe2f0b7c4f2009323
d_5_11:         .dword 0xda53400e20462279, 0x51c79655541cde96
d_5_12:         .dword 0x72aeac6e78d5c003, 0x48be71c6f8e73298
d_5_13:         .dword 0x1a5d413781362ff3, 0x6e3db5d1711c2719
d_5_14:         .dword 0x11634a70e92a49d8, 0xea9eeb044ebb2533
d_5_15:         .dword 0xe882195c5ecf7d8a, 0x7f5d3699641a6c13
d_5_16:         .dword 0x7c601f9e435c3dff, 0x37a7d3abfccf496b
d_5_17:         .dword 0x9bf9fb86e7e5a690, 0x38c8fd4a0122d2d6
d_5_18:         .dword 0x09480963d83d0bc9, 0x5f470dafe3fd960e
d_5_19:         .dword 0xe6f55d1eb68343ec, 0xb741d25bdab6e947
d_5_20:         .dword 0xd9c71ac33b97efc5, 0x2adf5c13bd29b6c1
d_5_21:         .dword 0x731fd81a3f90affc, 0x8516e41f60dc603f
d_5_22:         .dword 0x680ec9b1a26d1e0e, 0x93d16a07ac1f4afb
d_5_23:         .dword 0x73c7cd8b8b916ca7, 0x0dca165b5164ea06
d_5_24:         .dword 0x1cf003e56500f269, 0x8cf8fec87c13177d
d_5_25:         .dword 0x40a5b437ccbbac79, 0xbaa3706abbd981e3
d_5_26:         .dword 0x7bba850dbd6914ca, 0x54e6c9c2a7e83042
d_5_27:         .dword 0x8a368c63aab44cd4, 0xa84d81f40bd122e2
                .dword 0xc534735b342b40ee, 0xb6246036bc237644
                .dword 0x3d40c5dbbe85793a, 0xc16982e319fc8bd7
         /* Random data */
_end_data5:
              
                 
