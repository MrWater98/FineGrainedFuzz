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
_s0:    fsgnjx.s f25, f2, f9                      ;
_s1:    fsgnjx.s f23, f23, f16                    ;
_s2:    divuw x16, x23, x6                        ;
_s3:    ebreak                                    ;
_s4:    fmadd.s f30, f28, f0, f16, rne            ;
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
_p0:    la x10, d_1_24                            ;
        srai x10, x10, 1                          ;
        csrrs x13, pmpaddr3, x10                  ;
_p1:    csrrci x13, frm, 20                       ;
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
_l0:    la x30, d_4_9                             ;
        addi x30, x30, -0                         ;
        amoand.w x22, x25, (x30)                  ;
_l1:    bltu x22, x19, _l125                              ;
_l2:    la x5, d_4_15                             ;
        srai x5, x5, 1                            ;
        csrrw x29, pmpaddr1, x5                   ;
_l3:    mulhu x12, x15, x19                       ;
_l4:    remu x17, x24, x18                        ;
_l5:    la x30, d_2_7                             ;
        addi x30, x30, -0                         ;
        lr.w x11, (x30)                           ;
_l6:    mulhu x5, x8, x8                          ;
_l7:    la x22, d_3_9                             ;
        lui x19, 0xffe00                          ;
        xor x22, x22, x19                         ;
        sb x16, -0(x22)                           ;
_l8:    fclass.s x5, f23                          ;
_l9:    xor x11, x11, x11                         ;
        addi x17, zero, 1                         ;
        slli x17, x17, 30                         ;
        add x11, x11, x17                         ;
        csrrs x5, sie, x11                        ;
_l10:   remuw x13, x2, x10                        ;
_l11:   la x13, d_5_2                             ;
        addi x13, x13, 0                          ;
        amoswap.d x28, x18, (x13)                 ;
_l12:   la x6, d_3_16                             ;
        addi x6, x6, -0                           ;
        lui x3, 0xffe00                           ;
        xor x6, x6, x3                            ;
        amoand.d x30, x3, (x6)                    ;
_l13:   fence                                     ;
_l14:   xor x13, x13, x13                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 8                          ;
        add x13, x13, x27                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 23                           ;
        add x13, x13, x2                          ;
        addi x4, zero, 1                          ;
        slli x4, x4, 24                           ;
        add x13, x13, x4                          ;
        csrrc x22, mcause, x13                    ;
_l15:   la x14, d_4_9                             ;
        addi x14, x14, -0                         ;
        amoor.w x13, x23, (x14)                   ;
_l16:   la x11, _l74                                      ;
        csrrw zero, sepc, x11                     ;
        sret                                      ;
_l17:   sllw x9, x25, x11                         ;
_l18:   fence                                     ;
_l19:   blt x21, x30, _l98                                ;
_l20:   la x21, d_2_2                             ;
        addi x21, x21, 0                          ;
        lr.d x25, (x21)                           ;
_l21:   la x16, _l58                                      ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l22:   subw x16, x16, x21                        ;
_l23:   fcvt.s.wu f28, x0, dyn                    ;
_l24:   xori x2, x25, 1605                        ;
_l25:   fdiv.s f16, f10, f31, rdn                 ;
_l26:   la x13, d_5_3                             ;
        lui x16, 0xffe00                          ;
        xor x13, x13, x16                         ;
        lbu x25, 18(x13)                          ;
_l27:   sltiu x14, x10, 1852                      ;
_l28:   mulhsu x2, x12, x2                        ;
_l29:   fcvt.s.l f20, x9, dyn                     ;
_l30:   bltu x19, x15, _l141                      ;
_l31:   fmsub.s f29, f10, f6, f2, dyn             ;
_l32:   la x5, _l89                               ;
        csrrw zero, uepc, x5                      ;
        uret                                      ;
_l33:   bge x19, x20, _l113                               ;
_l34:   la x13, d_5_16                            ;
        addi x13, x13, 20                         ;
        amoand.w x28, x27, (x13)                  ;
_l35:   fmsub.s f15, f26, f26, f31, rdn           ;
_l36:   fcvt.wu.s x29, f6, rne                    ;
_l37:   fcvt.wu.s x4, f16, rne                    ;
_l38:   srliw x6, x16, 6                          ;
_l39:   bge x7, x13, _l111                                ;
_l40:   la x15, _l21                              ;
        lwu x19, -4(x15)                          ;
_l41:   la x9, d_5_17                             ;
        addi x9, x9, -4                           ;
        lr.w x28, (x9)                            ;
_l42:   remu x21, x9, x21                         ;
_l43:   mulh x11, x7, x28                         ;
_l44:   la x13, d_1_21                            ;
        addi x13, x13, -16                        ;
        amoand.w x5, x24, (x13)                   ;
_l45:   la x22, d_4_1                             ;
        lbu x4, -18(x22)                          ;
_l46:   fmv.w.x f3, x21                           ;
_l47:   mulhu x21, x29, x0                        ;
_l48:   ebreak                                    ;
_l49:   addi x4, x12, -820                        ;
_l50:   remw x20, x6, x27                         ;
_l51:   xor x8, x8, x8                            ;
        addi x12, zero, 3                         ;
        slli x12, x12, 2                          ;
        add x8, x8, x12                           ;
        csrrc x10, sscratch, x8                   ;
_l52:   la x1, d_2_11                             ;
        addi x1, x1, 0                            ;
        amoand.w x14, x19, (x1)                   ;
_l53:   srai x25, x22, 56                         ;
_l54:   fcvt.lu.s x9, f10, dyn                    ;
_l55:   fmv.x.w x8, f16                           ;
_l56:   la x5, d_4_20                             ;
        lh x7, -24(x5)                            ;
_l57:   slti x7, x18, -7                          ;
_l58:   mulw x13, x0, x21                         ;
_l59:   fmsub.s f12, f28, f18, f28, rmm           ;
_l60:   la x9, d_5_14                             ;
        addi x9, x9, 0                            ;
        amoand.d x7, x15, (x9)                    ;
_l61:   fence                                     ;
_l62:   addw x5, x25, x28                         ;
_l63:   la x24, d_5_15                            ;
        addi x24, x24, 24                         ;
        amoor.d x17, x18, (x24)                   ;
_l64:   la x30, d_4_13                            ;
        addi x30, x30, -28                        ;
        amoand.w x23, x17, (x30)                  ;
_l65:   mul x26, x29, x12                         ;
_l66:   mulhsu x17, x7, x3                        ;
_l67:   ebreak                                    ;
_l68:   auipc x20, 157081                         ;
_l69:   fmv.x.w x18, f29                          ;
_l70:   flt.s x5, f10, f17                        ;
_l71:   la x28, d_4_24                            ;
        addi x28, x28, 24                         ;
        amomax.d x10, x23, (x28)                  ;
_l72:   remuw x3, x8, x5                          ;
_l73:   remw x4, x15, x12                         ;
_l74:   bltu x6, x22, _l142                               ;
_l75:   la x8, d_5_8                              ;
        addi x8, x8, -0                           ;
        lr.d x27, (x8)                            ;
_l76:   la x28, _l59                              ;
        lb x8, -24(x28)                           ;
_l77:   la x8, d_5_6                              ;
        addi x8, x8, -12                          ;
        amoor.w x8, x19, (x8)                     ;
_l78:   lui x14, 604312                           ;
_l79:   divuw x22, x28, x8                        ;
_l80:   fclass.s x10, f11                         ;
_l81:   sraiw x5, x12, 24                         ;
_l82:   remw x1, x12, x12                         ;
_l83:   la x27, d_0_19                            ;
        addi x27, x27, -8                         ;
        amomaxu.d x1, x1, (x27)                   ;
_l84:   la x17, d_4_12                            ;
        lb x6, -29(x17)                           ;
_l85:   fcvt.l.s x0, f9, rup                      ;
_l86:   fmadd.s f13, f29, f13, f27, rtz           ;
_l87:   fcvt.s.lu f18, x3, rmm                    ;
_l88:   fcvt.lu.s x24, f23, rtz                   ;
_l89:   andi x22, x18, 1321                       ;
_l90:   la x20, d_3_10                            ;
        addi x20, x20, 8                          ;
        amoor.w x15, x29, (x20)                   ;
_l91:   auipc x9, 657443                          ;
_l92:   la x2, _l99                                       ;
        jalr x29, 0(x2)                           ;
_l93:   div x17, x7, x1                           ;
_l94:   csrrci x24, pmpaddr7, 17                  ;
_l95:   la x7, d_3_15                             ;
        fsw f30, -28(x7)                          ;
_l96:   ecall                                     ;
_l97:   fcvt.s.wu f29, x10, rup                   ;
_l98:   addi x22, x21, 838                        ;
_l99:   fcvt.s.l f31, x3, rup                     ;
_l100:  slti x28, x8, 628                         ;
_l101:  addiw x29, x30, 56                        ;
_l102:  la x27, d_5_13                            ;
        lw x7, -4(x27)                            ;
_l103:  fmv.x.w x16, f6                           ;
_l104:  sraiw x23, x19, 19                        ;
_l105:  bne x3, x21, _l124                                ;
_l106:  bne x18, x14, _l126                       ;
_l107:  addw x5, x29, x8                          ;
_l108:  bne x14, x11, _l135                               ;
_l109:  sllw x6, x0, x3                           ;
_l110:  la x11, d_0_26                            ;
        addi x11, x11, -24                        ;
        amomax.d x21, x13, (x11)                  ;
_l111:  la x21, d_3_0                             ;
        addi x21, x21, 0                          ;
        amoor.d x19, x18, (x21)                   ;
_l112:  la x10, d_4_5                             ;
        addi x10, x10, 28                         ;
        lr.w x9, (x10)                            ;
_l113:  la x23, d_2_19                            ;
        addi x23, x23, 20                         ;
        amoand.w x21, x18, (x23)                  ;
_l114:  remw x26, x19, x11                        ;
_l115:  la x17, d_5_8                             ;
        addi x17, x17, -28                        ;
        lr.w x16, (x17)                           ;
_l116:  auipc x20, 482234                         ;
_l117:  sraiw x19, x6, 18                         ;
_l118:  fcvt.s.l f23, x7, rmm                     ;
_l119:  blt x12, x5, _l131                                ;
_l120:  fmv.w.x f17, x16                          ;
_l121:  la x11, d_2_10                            ;
        srai x11, x11, 1                          ;
        csrrw x18, pmpaddr5, x11                  ;
_l122:  la x17, d_1_17                            ;
        addi x17, x17, 28                         ;
        amoadd.w x17, x24, (x17)                  ;
_l123:  fle.s x30, f3, f8                         ;
_l124:  fsgnj.s f1, f26, f23                      ;
_l125:  fence                                     ;
_l126:  fadd.s f30, f7, f22, dyn                  ;
_l127:  la x22, d_3_4                             ;
        addi x22, x22, -24                        ;
        amomax.d x11, x19, (x22)                  ;
_l128:  la x12, d_2_9                             ;
        lw x10, -8(x12)                           ;
_l129:  la x5, d_1_1                              ;
        addi x5, x5, 8                            ;
        amominu.d x4, x18, (x5)                   ;
_l130:  ecall                                     ;
_l131:  rem x2, x1, x8                            ;
_l132:  xor x26, x26, x26                         ;
        csrrc x5, mcause, x26                     ;
_l133:  la x10, d_2_8                             ;
        addi x10, x10, 16                         ;
        lui x5, 0xffe00                           ;
        xor x10, x10, x5                          ;
        amoor.d x15, x5, (x10)                    ;
_l134:  sraiw x27, x2, 24                         ;
_l135:  la x3, d_0_0                              ;
        addi x3, x3, -0                           ;
        amoadd.w x16, x12, (x3)                   ;
_l136:  fcvt.lu.s x27, f22, rup                   ;
_l137:  fmv.x.w x30, f31                          ;
_l138:  la x20, d_1_8                             ;
        addi x20, x20, -8                         ;
        sc.d x6, x20, (x20)                       ;
_l139:  fle.s x16, f30, f25                       ;
_l140:  xori x22, x30, 1                          ;
_l141:  fsgnjn.s f23, f27, f5                     ;
_l142:  srli x7, x8, 55                           ;
_l143:;
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
                .dword 0xcf4c0fc80e8df3fd, 0x5519cb66ef947bc9
                .dword 0x9c913bf2db6df599, 0x5248604a4fc6cb8f
d_0_0:          .dword 0xce41439754046d7c, 0xef31d60533322496
d_0_1:          .dword 0x06ad2bbb9b3f3cb4, 0xde3b90ca15bc8cbc
d_0_2:          .dword 0x6b4090c1fee4f482, 0x7e513e4c31a463bd
d_0_3:          .dword 0x2f8e66a3f349714b, 0xd04211aa9e17f9bb
d_0_4:          .dword 0xc740c22a84660dcd, 0x93c9104836afa069
d_0_5:          .dword 0x2b88f02f284dd186, 0x2c7c49484c0ecca9
d_0_6:          .dword 0x28aba061cfc6d6ac, 0xa57affda5720481c
d_0_7:          .dword 0x6b7183a9cabfafb2, 0xb50f2d9cf7f96946
d_0_8:          .dword 0x78ee4cdb8c4f9ca3, 0x38fcefba0089f538
d_0_9:          .dword 0x9be677892de65503, 0x2a1a435d3cc95b62
d_0_10:         .dword 0x79586fa89f3a2b09, 0x5bb9b397a6acb152
d_0_11:         .dword 0xbf08a68a5d36f0ce, 0x58e263e5630daef9
d_0_12:         .dword 0x5ef25454b9b7c802, 0x831644deec34769d
d_0_13:         .dword 0xe014d5be153b0186, 0x721810c1593d79b2
d_0_14:         .dword 0x59eed34659966392, 0x68d5392a29faab6c
d_0_15:         .dword 0x05ec3fa8e5010f21, 0x8006072ef206bff5
d_0_16:         .dword 0xc69b05057c3f10a5, 0x487501784c9828be
d_0_17:         .dword 0xfc63aa801c27783d, 0xa3cfefcf5bb25964
d_0_18:         .dword 0xb28bee29a4d835ad, 0x864c2143e71e53e2
d_0_19:         .dword 0x073ade1f49963b65, 0x014b564ba27a66b9
d_0_20:         .dword 0x7803e4f0783153c2, 0x3eca21f3d83ff572
d_0_21:         .dword 0x08096e63690945d1, 0x430ab83a362b6531
d_0_22:         .dword 0x659f479c596e2465, 0xe0aa7c91f8df7701
d_0_23:         .dword 0xe598b18ea62e1628, 0xd16edba5554c74d0
d_0_24:         .dword 0xec03acaed79e78d6, 0x907ee04faf31a151
d_0_25:         .dword 0xf9846f570832792b, 0x30e7a46049b95769
d_0_26:         .dword 0xb2529bbc6e10cd39, 0x58eadeaaecad356f
d_0_27:         .dword 0x176b00c5b3a0a467, 0x2beb33a716dcbaa1
                .dword 0x89c309826d245efa, 0xb243c07e998b157a
                .dword 0x511cfffffdbc3ce8, 0x5410e7c50dab89fb
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x5277169c8f4bcdaa, 0xf78faa7f613fa83d
                .dword 0x0cd1f3004147d805, 0xebe6cacb19fd5ab5
d_1_0:          .dword 0xad35dcfb367e6c28, 0x67d8d47417452ca9
d_1_1:          .dword 0xf47b392e79c7f655, 0x7f86ede1329d9217
d_1_2:          .dword 0xdb29429ef39a3052, 0xcad867d556769e80
d_1_3:          .dword 0x61b654cbca68fb29, 0xfc4b6ed2c9fe52fe
d_1_4:          .dword 0x9ef46c5ddb570ea0, 0x58abd4ab3a7ed9c2
d_1_5:          .dword 0xf09e19dca8e8c156, 0x148fe8b8a000072a
d_1_6:          .dword 0x6f99f8130296e984, 0x9be899da51611249
d_1_7:          .dword 0xacef09fcdebe7360, 0xedfd360bfb24f2d6
d_1_8:          .dword 0x5d782cf57fab033c, 0x4de31df4981631df
d_1_9:          .dword 0xed3768b56bbec0f2, 0xe130df523cb4061b
d_1_10:         .dword 0xb56684ddc10872eb, 0x9ae90f88538d9fef
d_1_11:         .dword 0x4d026b88004ab17a, 0x9cdfcedcf386f1ee
d_1_12:         .dword 0x65f4920ed0381275, 0x34ffb06c172f122a
d_1_13:         .dword 0x575dbbbfa4446532, 0xfce94f05b438fa13
d_1_14:         .dword 0x2abfef068efa7834, 0x48f5a301bac8add9
d_1_15:         .dword 0x175628be8e1a2478, 0x0c153ee4b2a24121
d_1_16:         .dword 0x9c5a7a9583cfa55a, 0x017dc80ea5485887
d_1_17:         .dword 0x5243998851178ce7, 0x99452a4e56a7bb4d
d_1_18:         .dword 0xaf7e1aae64e6b60e, 0x8d676c3d47e236d6
d_1_19:         .dword 0x21d0fbb5470d2aeb, 0xf7b9d3ee55e196b7
d_1_20:         .dword 0xb04bf03d75cdefea, 0x4d2131b426a5ac07
d_1_21:         .dword 0x16f014dba4b80559, 0xd9de4d7b8a6532d7
d_1_22:         .dword 0x1f030a92cac58cde, 0x6b92a827c629fdd9
d_1_23:         .dword 0xc96d2074de01f45e, 0xaf67435b6d60b7ca
d_1_24:         .dword 0x53c6f75520633ae3, 0xed1196da6d2750d9
d_1_25:         .dword 0xffa07d733c351885, 0x642a2ad0de9fbf64
d_1_26:         .dword 0x24db72b74631e5c7, 0x097aee5e905ec995
d_1_27:         .dword 0x3e2aed40fa4890af, 0xc58ba3ed381a09bb
                .dword 0xcdf6e9e8455f9d1c, 0x80df8b555413ff43
                .dword 0xa931f9f071c7ee78, 0x564df2aa625c5aed
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x46d6d6a93ca7e3d2, 0x989772ee4f6d3206
                .dword 0x5129a8896acd502d, 0x00de0acf4784e67d
d_2_0:          .dword 0xec02c59eb95c9a6e, 0x1e5b16e04aa54dd5
d_2_1:          .dword 0x76a4587b192de5d1, 0x185329525aa0534c
d_2_2:          .dword 0x1db1f0edc9db553e, 0x13d360df097c08a2
d_2_3:          .dword 0xd6323502dade0df5, 0x7730cb9d020e2285
d_2_4:          .dword 0x5dab0e521f95d80c, 0x6e21e742f4d3a289
d_2_5:          .dword 0xf1857fff562969fc, 0xb9e92d853fdbf50f
d_2_6:          .dword 0x68292da5389febed, 0x483021f67ab9ba49
d_2_7:          .dword 0xb641f655d0102e8f, 0xbe36e4aa10955039
d_2_8:          .dword 0xac1014e6ee0890e9, 0x09cabd9e28186f28
d_2_9:          .dword 0x0cf5309f4312b456, 0xa4f1e93a2caa969b
d_2_10:         .dword 0xba4236312e819f1a, 0xc05c8da244b4f0d7
d_2_11:         .dword 0x7ae618e9e9b92ab4, 0x6e3f58097ac5a3ed
d_2_12:         .dword 0xf944cc983e008ee4, 0x8b245e4ae4b42de4
d_2_13:         .dword 0xe04aea8a56bff800, 0xc98123594fb0c872
d_2_14:         .dword 0x74abe79b918769dd, 0x475193a4c4894beb
d_2_15:         .dword 0xd8fad6d24999392b, 0x35872a0c60115e41
d_2_16:         .dword 0xade066f6953ed21e, 0x93204f72251a5f87
d_2_17:         .dword 0x0cb3613036e254d8, 0xcbd524844fbdc68e
d_2_18:         .dword 0x26e8100a4f672686, 0xb5f8b63444c9f9d0
d_2_19:         .dword 0x95ce9c4f8d94a246, 0x61e8b3d7c93ddf4f
d_2_20:         .dword 0x0e4f97e777763f26, 0xe1a6d63006b94eef
d_2_21:         .dword 0xcb55532bcb8d708a, 0xef6444d8666eccc1
d_2_22:         .dword 0xc0fa9be0d1f60ee3, 0x42e9c06fccb1d2e2
d_2_23:         .dword 0x830855bf63913a41, 0xe6ef29f987376d05
d_2_24:         .dword 0xdb083488969c9ea0, 0x196b14f0472cfffb
d_2_25:         .dword 0xee46a2a7bd867c1d, 0x12105642bce07121
d_2_26:         .dword 0xaedf3fe5778902a3, 0x1948c19d465e6c08
d_2_27:         .dword 0x97c9704139ffa93d, 0xd1fcd8113c838266
                .dword 0xe88d3299416c9cce, 0xa9e3f37ee297530b
                .dword 0xceaa55698444b7d9, 0x6a8416302c21f92f
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xdd8d30c69ac52c85, 0xf162d503f82902ac
                .dword 0x6043c285c7c00c0d, 0x699f9b1d72dfddf9
d_3_0:          .dword 0xce010b6a7ad24436, 0x57d04af8e4127a6d
d_3_1:          .dword 0xce841b2ed9b77c11, 0xb72462122bfab52a
d_3_2:          .dword 0xa3947874a2ac410f, 0x25aa868b3e76189c
d_3_3:          .dword 0x126934de235350d9, 0x2a225c94096ad21b
d_3_4:          .dword 0x62c8c564f0b05228, 0x451d3edfb5fb5787
d_3_5:          .dword 0xaad492ce9fafb52a, 0x3e0a89a6fccd626f
d_3_6:          .dword 0x605ac3e05b5bfbc2, 0xfaa19676af8c2f0c
d_3_7:          .dword 0xdb7572e22bd26a73, 0xc2ae44588620ced4
d_3_8:          .dword 0x26b5a006227ad027, 0x4a059ffd2b2e96f3
d_3_9:          .dword 0x042b8e14ff7ed6e6, 0x6d9edda19cc552e2
d_3_10:         .dword 0x01f2dbf561e0810c, 0xdffd688a51dadeda
d_3_11:         .dword 0x7679a22e4564df31, 0x1ce3739b8f05c30a
d_3_12:         .dword 0x86567deb907f0d9a, 0x2a46b610164fb45c
d_3_13:         .dword 0x3cf4919edf81f7dd, 0x215f013f0c423fdf
d_3_14:         .dword 0x7131f3b25d66436e, 0xab84b0e5c7a806be
d_3_15:         .dword 0x2308eb3086b4bbad, 0xe24e5abed751ee61
d_3_16:         .dword 0xfea98b87837e1847, 0x5e11c760252bb457
d_3_17:         .dword 0xca61bbe07e63ceb6, 0xe17d92f73105d94f
d_3_18:         .dword 0x427be2ea8e889681, 0x17f9a7cda74eed5f
d_3_19:         .dword 0xa895280a9d1fe616, 0xfddd23dede99958a
d_3_20:         .dword 0x8c1a8775f7f4bd7e, 0x84593ba24d09548c
d_3_21:         .dword 0x2e70b252e85ef705, 0xb9ffe935e5e8413e
d_3_22:         .dword 0x86a0dfb89355a2d5, 0xe028af008330c094
d_3_23:         .dword 0x10653ca8d7f103ec, 0xee6aa8b6b3a2a2e8
d_3_24:         .dword 0x0b0f07a7b5c0e39c, 0xc62b1f4f8ce29f1c
d_3_25:         .dword 0x852fc831d5fb1b04, 0xbee9ac48eee4b1a7
d_3_26:         .dword 0xf26681a1f613c3ac, 0x6bd7baafff90c8af
d_3_27:         .dword 0x0e498090a1775bbc, 0x998e532b02663d15
                .dword 0x704d6ba83ddbe512, 0x5305e418d4bfcaa2
                .dword 0xded129124a6e38f9, 0x298095452626ab14
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xac42e96e7fe3d0b6, 0xa36dd8a297a479f2
                .dword 0xa323ebbe5d50dc15, 0x525f221aa1e20655
d_4_0:          .dword 0x4cedd26bf397b3de, 0x32fb535c1c430775
d_4_1:          .dword 0x4e88b00b52af1d42, 0x9d6d1427c185ab0c
d_4_2:          .dword 0x814a64a224666bd3, 0xcc05115b28c3c7e9
d_4_3:          .dword 0x791639ee166d1eed, 0xc7e5c010cc133721
d_4_4:          .dword 0x64df6a803a7d89ab, 0x4c768a3d21220877
d_4_5:          .dword 0x4fb99f1390c53623, 0xe677234b8d5f1010
d_4_6:          .dword 0xa10e835eae3e2e32, 0x890179cee0056027
d_4_7:          .dword 0xccdc7f54fa867c0f, 0xac74507c9ae2df5c
d_4_8:          .dword 0x66b8f3f245a7fd25, 0x7540f878e7dbb99c
d_4_9:          .dword 0x7294f46b2207d8c8, 0x6fbca1334f8781e3
d_4_10:         .dword 0x0923412608e70abe, 0xe5d19e2d674c9e8a
d_4_11:         .dword 0x701adbd367c35f77, 0x8f788730283a7d5c
d_4_12:         .dword 0x03e70813425d19cd, 0x387ac18e3780308d
d_4_13:         .dword 0x38c12efe454779f9, 0x52b0a928bfcbae30
d_4_14:         .dword 0x3880ec9bae876b53, 0xb61384e59ce8ba91
d_4_15:         .dword 0xd56f470a5e172a46, 0x968d00f02ee60d17
d_4_16:         .dword 0xf5ad9ee584e7b87d, 0xfd2c4f055da7fda4
d_4_17:         .dword 0x7691c83228584ea2, 0xd1479a68309038ff
d_4_18:         .dword 0xc48263c5bbda5635, 0xe3bee017020e11a0
d_4_19:         .dword 0x2c1d00e8384ce530, 0xa02a428cf23e5479
d_4_20:         .dword 0x2784e97552d2a6d6, 0xd23a92551ef1d7c0
d_4_21:         .dword 0x8eb5ba24812e9b78, 0xb1972ec19a5f4f3a
d_4_22:         .dword 0x04f1fdc617d4de4e, 0x13bcd5dda5eeb407
d_4_23:         .dword 0xbd254aca2dddf93d, 0x39084cf498c004e5
d_4_24:         .dword 0xbfaeb491e74a09d1, 0xcc2669ad586b41e2
d_4_25:         .dword 0x4a11569b72d9ba86, 0xe3eb4e5592189d11
d_4_26:         .dword 0x416410c99d56a5a5, 0x54d4f9688b288378
d_4_27:         .dword 0xca2698c77a60c5e9, 0xcad99b2903256e88
                .dword 0x712cc5d960f00d53, 0x2cea11d1afcb84af
                .dword 0xef0931276b95d7e8, 0x67b9d9a9fa25c574
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x333d37680660b337, 0xac6c7d4f9713213b
                .dword 0x76c19a6ed3f019c7, 0x4e972de0cb9cace9
d_5_0:          .dword 0x8f60554dd16da8c0, 0xb74316f5047ee359
d_5_1:          .dword 0x3cf704845692c3a2, 0xdfd472e735659397
d_5_2:          .dword 0xe1bd07a5f6da6537, 0xa3caed973e7c8317
d_5_3:          .dword 0xe07780584aeafda5, 0x95a69af9d10c9bac
d_5_4:          .dword 0x97975f7fa6ea9b14, 0xb52787b311fe0d47
d_5_5:          .dword 0xd0947328487500cc, 0x4ff7a3b674d52749
d_5_6:          .dword 0x4ec815b723356d94, 0x4b2a789cdea5a1a1
d_5_7:          .dword 0x3ae10116348548af, 0x3c5aa223749dc353
d_5_8:          .dword 0x1ee010a00aab0324, 0xa96f2b448006a9f5
d_5_9:          .dword 0x9fcf17f4ee1d9f71, 0x82f0da7d6a1b0d20
d_5_10:         .dword 0xb2b733bd448087f5, 0xa47af0b896cd974d
d_5_11:         .dword 0x20b5e50562b2c837, 0xda2c99889da94978
d_5_12:         .dword 0x5b3ec86d0945627c, 0x40d0d9cd350ae87f
d_5_13:         .dword 0x45fac00655e86670, 0xce72f2aa2527c3c6
d_5_14:         .dword 0xeae0b0c16b6d1963, 0xb4d3fa1d2760c507
d_5_15:         .dword 0x89e488615ec8f1cc, 0xd65ca8ba46c976c6
d_5_16:         .dword 0x92318e7c8c872e10, 0xf31dc0180789bcc8
d_5_17:         .dword 0x0755dc9019271a7f, 0x5820dfc986c1dcac
d_5_18:         .dword 0xfdb02094d0d313e5, 0x0651743f9a6e0f2a
d_5_19:         .dword 0xe9e998cd4688d60c, 0xf684bbe052ca9269
d_5_20:         .dword 0x6204b5f4edfde85f, 0x5cfda2689520dfab
d_5_21:         .dword 0x7e48845e5f3e2a1c, 0x517b12cb42d1db88
d_5_22:         .dword 0xbd9836fefdb4c76a, 0xcfb4ec21c9f08414
d_5_23:         .dword 0x19b0285f175aa7f9, 0xc6e93fbd316dda72
d_5_24:         .dword 0xdf3d158b9ea6a33a, 0x25815dd5ebab992f
d_5_25:         .dword 0x063bba159c02e4e9, 0x9fa5c1005c86065e
d_5_26:         .dword 0x87503b232d615cac, 0x04f28fd6b4f510b1
d_5_27:         .dword 0xfc149ab8efd4e59c, 0x973deeb8956661a1
                .dword 0xf92d855fd5f862c8, 0xde265c74333994cb
                .dword 0x6cd1087b9c22c6df, 0xae48933da22ed37c
         /* Random data */
_end_data5:
              
                 
