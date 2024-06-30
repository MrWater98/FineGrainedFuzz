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
_s0:    la x22, _s3                                       ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_s1:    mulh x5, x1, x17                          ;
_s2:    la x10, d_1_18                            ;
        addi x10, x10, 12                         ;
        lui x6, 0xffe00                           ;
        xor x10, x10, x6                          ;
        amoswap.w x18, x6, (x10)                  ;
_s3:    divu x4, x24, x22                         ;
_s4:    lui x10, 0                                ;
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
_p0:    csrrsi x14, sscratch, 0                   ;
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
_l0:    subw x19, x0, x24                         ;
_l1:    jal x2, _l41                                      ;
_l2:    srliw x1, x21, 31                         ;
_l3:    la x11, d_5_15                            ;
        addi x11, x11, 16                         ;
        lui x20, 0xffe00                          ;
        xor x11, x11, x20                         ;
        amoxor.d x17, x20, (x11)                  ;
_l4:    la x27, d_0_18                            ;
        addi x27, x27, 16                         ;
        amoand.w x22, x21, (x27)                  ;
_l5:    la x7, d_0_7                              ;
        addi x7, x7, 16                           ;
        lr.d x4, (x7)                             ;
_l6:    la x5, d_5_20                             ;
        addi x5, x5, 0                            ;
        amomin.d x14, x2, (x5)                    ;
_l7:    la x3, d_1_6                              ;
        addi x3, x3, -0                           ;
        amoadd.d x21, x24, (x3)                   ;
_l8:    divuw x1, x28, x14                        ;
_l9:    rem x14, x29, x19                         ;
_l10:   la x10, d_2_0                             ;
        addi x10, x10, 4                          ;
        amoand.w x3, x12, (x10)                   ;
_l11:   fsgnjx.s f3, f2, f28                      ;
_l12:   fmin.s f10, f15, f14                      ;
_l13:   addi x30, x14, 19                         ;
_l14:   la x7, d_4_2                              ;
        addi x7, x7, 28                           ;
        amoor.w x15, x25, (x7)                    ;
_l15:   addw x30, x30, x12                        ;
_l16:   fdiv.s f5, f5, f20, rmm                   ;
_l17:   ecall                                     ;
_l18:   srai x13, x20, 39                         ;
_l19:   la x16, _l124                             ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
_l20:   addiw x3, x16, -12                        ;
_l21:   fcvt.wu.s x29, f31, rdn                   ;
_l22:   mul x11, x12, x26                         ;
_l23:   bgeu x10, x25, _l111                              ;
_l24:   la x2, d_0_1                              ;
        lui x26, 0xffe00                          ;
        xor x2, x2, x26                           ;
        lwu x12, 4(x2)                            ;
_l25:   ecall                                     ;
_l26:   fence.i                                   ;
_l27:   jal x5, _l109                             ;
_l28:   fcvt.l.s x2, f3, dyn                      ;
_l29:   sraiw x28, x11, 5                         ;
_l30:   la x26, d_3_27                            ;
        flw f20, 24(x26)                          ;
_l31:   fcvt.l.s x12, f15, rup                    ;
_l32:   la x24, _l59                                      ;
        csrrw zero, sepc, x24                     ;
        sret                                      ;
_l33:   la x22, _l97                              ;
        csrrw zero, uepc, x22                     ;
        uret                                      ;
_l34:   fadd.s f29, f20, f1, rmm                  ;
_l35:   fmax.s f5, f5, f15                        ;
_l36:   fsgnjn.s f20, f20, f20                    ;
_l37:   la x5, d_1_14                             ;
        addi x5, x5, -0                           ;
        amoor.w x25, x9, (x5)                     ;
_l38:   remw x1, x24, x14                         ;
_l39:   fcvt.s.w f5, x2, rmm                      ;
_l40:   jal x9, _l80                              ;
_l41:   la x28, d_0_7                             ;
        addi x28, x28, -16                        ;
        amoor.d x12, x8, (x28)                    ;
_l42:   la x17, d_5_3                             ;
        addi x17, x17, 0                          ;
        amominu.w x14, x25, (x17)                 ;
_l43:   fmadd.s f8, f25, f3, f3, dyn              ;
_l44:   sraiw x11, x16, 0                         ;
_l45:   auipc x25, 402465                         ;
_l46:   la x7, d_3_9                              ;
        sw x22, -24(x7)                           ;
_l47:   bne x29, x28, _l132                               ;
_l48:   bne x14, x11, _l69                                ;
_l49:   fle.s x19, f2, f0                         ;
_l50:   jal x19, _l129                                    ;
_l51:   la x14, _l122                                      ;
        lw x25, 28(x14)                           ;
_l52:   fnmadd.s f8, f22, f0, f14, rmm            ;
_l53:   fdiv.s f13, f8, f5, rtz                   ;
_l54:   fsub.s f4, f31, f30, rdn                  ;
_l55:   remu x2, x22, x11                         ;
_l56:   slti x17, x15, 850                        ;
_l57:   la x13, d_5_6                             ;
        addi x13, x13, 0                          ;
        amomin.d x1, x26, (x13)                   ;
_l58:   blt x8, x17, _l100                                ;
_l59:   mul x9, x23, x24                          ;
_l60:   bge x16, x4, _l82                                 ;
_l61:   la x24, d_5_26                            ;
        sh x6, 12(x24)                            ;
_l62:   fclass.s x4, f2                           ;
_l63:   la x4, d_5_27                             ;
        addi x4, x4, -8                           ;
        amoand.d x24, x15, (x4)                   ;
_l64:   srai x14, x2, 2                           ;
_l65:   ecall                                     ;
_l66:   fcvt.l.s x2, f21, rtz                     ;
_l67:   la x4, _l109                                      ;
        csrrw zero, uepc, x4                      ;
        uret                                      ;
_l68:   la x23, _l76                                      ;
        jalr x23, 0(x23)                          ;
_l69:   addiw x10, x26, 13                        ;
_l70:   jal x25, _l110                            ;
_l71:   la x2, d_2_1                              ;
        lui x24, 0xffe00                          ;
        xor x2, x2, x24                           ;
        lw x9, 12(x2)                             ;
_l72:   sllw x19, x16, x7                         ;
_l73:   mulhsu x1, x6, x22                        ;
_l74:   la x6, d_4_7                              ;
        lui x30, 0xffe00                          ;
        xor x6, x6, x30                           ;
        fsw f15, -12(x6)                          ;
_l75:   la x4, d_4_18                             ;
        addi x4, x4, 28                           ;
        amominu.w x17, x28, (x4)                  ;
_l76:   srai x23, x7, 0                           ;
_l77:   ori x28, x12, -11                         ;
_l78:   la x15, d_1_1                             ;
        addi x15, x15, 0                          ;
        amoadd.d x5, x19, (x15)                   ;
_l79:   csrrwi x25, sstatus, 21                   ;
_l80:   fcvt.lu.s x11, f7, rdn                    ;
_l81:   la x26, d_5_26                            ;
        addi x26, x26, 16                         ;
        lui x15, 0xffe00                          ;
        xor x26, x26, x15                         ;
        amoxor.d x16, x15, (x26)                  ;
_l82:   la x17, d_4_13                            ;
        fsw f17, -28(x17)                         ;
_l83:   srlw x19, x10, x0                         ;
_l84:   flt.s x6, f27, f7                         ;
_l85:   mulh x12, x4, x16                         ;
_l86:   andi x25, x0, -23                         ;
_l87:   divuw x12, x13, x17                       ;
_l88:   fmadd.s f22, f5, f4, f29, rtz             ;
_l89:   la x19, d_0_25                            ;
        lwu x1, 0(x19)                            ;
_l90:   csrrci x8, sie, 18                        ;
_l91:   ori x24, x12, -779                        ;
_l92:   bgeu x14, x23, _l100                              ;
_l93:   slliw x17, x18, 21                        ;
_l94:   la x11, d_5_5                             ;
        lui x21, 0xffe00                          ;
        xor x11, x11, x21                         ;
        ld x13, -0(x11)                           ;
_l95:   xori x14, x15, -1432                      ;
_l96:   flt.s x2, f13, f30                        ;
_l97:   mulh x10, x12, x3                         ;
_l98:   csrrci x25, sscratch, 31                  ;
_l99:   fcvt.s.lu f4, x4, rtz                     ;
_l100:  la x9, d_3_4                              ;
        addi x9, x9, 8                            ;
        amoxor.w x13, x14, (x9)                   ;
_l101:  sraiw x24, x25, 28                        ;
_l102:  mulhu x20, x12, x4                        ;
_l103:  addw x29, x29, x25                        ;
_l104:  fcvt.l.s x17, f4, rtz                     ;
_l105:  fnmadd.s f15, f29, f31, f24, rdn          ;
_l106:  csrrsi x26, frm, 18                       ;
_l107:  slliw x3, x4, 1                           ;
_l108:  xor x6, x6, x6                            ;
        addi x26, zero, 3                         ;
        slli x26, x26, 31                         ;
        add x6, x6, x26                           ;
        addi x19, zero, 3                         ;
        slli x19, x19, 3                          ;
        add x6, x6, x19                           ;
        csrrc x10, sie, x6                        ;
_l109:  subw x13, x20, x28                        ;
_l110:  slliw x4, x24, 5                          ;
_l111:  blt x23, x28, _l124                               ;
_l112:  la x27, _l126                                     ;
        csrrw zero, sepc, x27                     ;
        sret                                      ;
_l113:  flt.s x1, f26, f31                        ;
_l114:  blt x9, x14, _l115                                ;
_l115:  bne x2, x16, _l121                        ;
_l116:  sraw x0, x0, x25                          ;
_l117:  csrrci x6, frm, 31                        ;
_l118:  bge x18, x27, _l126                               ;
_l119:  la x7, _l124                                      ;
        lw x25, 20(x7)                            ;
_l120:  la x18, d_0_21                            ;
        lhu x13, -8(x18)                          ;
_l121:  sltiu x19, x6, 1487                       ;
_l122:  mulhu x10, x30, x9                        ;
_l123:  bltu x4, x15, _l131                               ;
_l124:  fmax.s f31, f28, f31                      ;
_l125:  fmul.s f29, f7, f16, rne                  ;
_l126:  la x22, d_4_12                            ;
        addi x22, x22, 12                         ;
        amomaxu.w x19, x28, (x22)                 ;
_l127:  la x27, d_5_26                            ;
        lhu x2, 0(x27)                            ;
_l128:  fsgnjn.s f5, f31, f6                      ;
_l129:  bge x30, x4, _l130                                ;
_l130:  fnmsub.s f17, f5, f17, f29, rup           ;
_l131:  la x4, d_0_16                             ;
        addi x4, x4, 0                            ;
        amoadd.d x29, x3, (x4)                    ;
_l132:  ebreak                                    ;
_l133:  la x25, d_1_7                             ;
        addi x25, x25, -16                        ;
        lui x24, 0xffe00                          ;
        xor x25, x25, x24                         ;
        amoadd.d x20, x24, (x25)                  ;
_l134:  la x5, d_3_10                             ;
        lhu x16, 0(x5)                            ;
_l135:;
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
                .dword 0xbdf456c6570fae4f, 0xadd2f02620b4308a
                .dword 0x458fb2748534f3a3, 0xe2ae1c0922cd4f30
d_0_0:          .dword 0x01c7c7633e6748d4, 0x41ca32f237255816
d_0_1:          .dword 0xc05d2863d083849c, 0xf58560031d2f43f2
d_0_2:          .dword 0xfd7f297784d58ee7, 0xc2c990658e09e3ed
d_0_3:          .dword 0x332dc0c6b784d3a2, 0x3062e11843cbc059
d_0_4:          .dword 0xf255180981ec3649, 0xa067412810f289ea
d_0_5:          .dword 0x5d662d18447198aa, 0xf18f47c8776b2846
d_0_6:          .dword 0x4748381d099f764f, 0x494777e3dc2a667c
d_0_7:          .dword 0x532c115d82861250, 0xbb8343cd80134eb1
d_0_8:          .dword 0xec12045a136b560e, 0x07ca4e3d48de4c82
d_0_9:          .dword 0x3eb63f7e438c2578, 0x5d060014b8e7f77b
d_0_10:         .dword 0x3133ea9933c1fb9b, 0x126f596cb13aae8b
d_0_11:         .dword 0x25c2f4ad5ded4153, 0x2d959e0ee906934c
d_0_12:         .dword 0x69ebdc8bd1c204cb, 0x801b76760b275d8e
d_0_13:         .dword 0x94ae20b569e26596, 0x48e9985cf0d8621c
d_0_14:         .dword 0xd942540fd9e7da3f, 0x3ded0520c289063b
d_0_15:         .dword 0x3039d3eb321103eb, 0xa56eecc876abef7b
d_0_16:         .dword 0xdbba3e3be9e653a8, 0xa5a75ff8a46040a6
d_0_17:         .dword 0x9d7414000f96b478, 0xb4e29249ab0d8d38
d_0_18:         .dword 0xc0c45e9efbf27aed, 0x4646dc658ec05b1d
d_0_19:         .dword 0x9d8db4e6db89af03, 0x45c351f7408a6298
d_0_20:         .dword 0x2847f3919879715b, 0x52a818238d04db01
d_0_21:         .dword 0xac804c4f5ccf3f28, 0x3d80d904adbc0ea3
d_0_22:         .dword 0x0fd4f84d04e6497b, 0x14125d17a2b47e19
d_0_23:         .dword 0x394f8068704065cc, 0x4a6ef1359be3ad1c
d_0_24:         .dword 0x69924231c87476f9, 0xe85046e852cf20d9
d_0_25:         .dword 0xea2ee191f3946880, 0x07dd0ec3d49e249c
d_0_26:         .dword 0x36c4b5b54ff08514, 0x9576c62c60429e5e
d_0_27:         .dword 0x262d39e210551dde, 0xc4bdc629ce96215c
                .dword 0x8adc7d94b027bc84, 0x484df0d335be5a60
                .dword 0x05c17ec1253403d1, 0x82c9e49f7f2a7024
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xafefc831a611a6ef, 0xbc42ed95a39aa240
                .dword 0xd5f3708c49d4c986, 0x8298db94439c686e
d_1_0:          .dword 0x57409f9f5a0297f0, 0x106c10e0ea84e355
d_1_1:          .dword 0x3aaf52005ebc1838, 0x74354a2b6f689f69
d_1_2:          .dword 0x31aec6e6068474f9, 0xf789c7fac714af76
d_1_3:          .dword 0x00ef10cc6b571efe, 0x012b9f86ee665298
d_1_4:          .dword 0x98774feb46ec0010, 0xc30a83a39a64f0c7
d_1_5:          .dword 0x562f2bd3c9668c59, 0x265900196739ac00
d_1_6:          .dword 0x96f4a65122f6454b, 0x988638b65371c217
d_1_7:          .dword 0x8c43237c056462d2, 0x00d81131b9f6313c
d_1_8:          .dword 0x96ea083b467a8dd4, 0x185a79f6a5ed6a7f
d_1_9:          .dword 0x5fde2223435e12c7, 0x835e9593b86512fc
d_1_10:         .dword 0x4b8a340b10fdda02, 0x82e11e105a9bfb49
d_1_11:         .dword 0x8a085637fa165720, 0x148c3a36ea5c7ca8
d_1_12:         .dword 0x3b8ea1bdea61bc83, 0x5a4cbfc0a78d14d6
d_1_13:         .dword 0xf1d675e1a83b489d, 0x6ef71223f54a30c1
d_1_14:         .dword 0x6db61a4b327533cf, 0xcf3a86cf2af8ded2
d_1_15:         .dword 0x9a0e6a71004825a0, 0x7ccb9c1239a856e2
d_1_16:         .dword 0x319436b075b27840, 0xa6393f39c6bdd206
d_1_17:         .dword 0x2d8dd846a229fe9e, 0x8240d97b0ec27178
d_1_18:         .dword 0x1614787ab9343c95, 0xc9dbd12c7437c67d
d_1_19:         .dword 0x012f21c4443a5a9a, 0x954c372b6bda5a1d
d_1_20:         .dword 0xe6200b40b9665d4f, 0x53f1d31983cf3304
d_1_21:         .dword 0x2a6b6967a44692a7, 0x318bbdc506f8d1e3
d_1_22:         .dword 0x82fc742c7d5d7086, 0x4d40cd24ba0bf576
d_1_23:         .dword 0x578604395cbe2563, 0x872ab85dde160efb
d_1_24:         .dword 0x019002dfebeacf31, 0x8f0580ddab63acfa
d_1_25:         .dword 0x82740a37cf965f54, 0x92888ebd7fdc4052
d_1_26:         .dword 0x2f40d5894c4d1df9, 0x1aec70f4d5a5d5db
d_1_27:         .dword 0xd9623e3eb2b9e835, 0x22be5f3395264f20
                .dword 0xe542cdc3beb2b08d, 0xf93c0aa65e8de8a9
                .dword 0x7a046ec58c890112, 0x62b0a8c769e86159
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x0662763c8707c399, 0xa75387a24af0743f
                .dword 0xf39f71bd34c76731, 0xbcbcdc22d58cb638
d_2_0:          .dword 0x13552a42d64cb13b, 0x2e91b45607d89d80
d_2_1:          .dword 0x046f6ee63bbad876, 0x433beb146db07a4f
d_2_2:          .dword 0xb693b9c09ff2e413, 0x8abcdb00e14e8ca9
d_2_3:          .dword 0x7c3e5581d239b4bf, 0xa6ea26af1582cf7e
d_2_4:          .dword 0xc883ab8055b5d5be, 0x0789367b6a17e313
d_2_5:          .dword 0x1771113f241e0507, 0x2bd8b5162100e348
d_2_6:          .dword 0xca8351649f6fb204, 0x7de998bb30b5ad19
d_2_7:          .dword 0xde1c9e725a4131cd, 0xd92943a0971789c9
d_2_8:          .dword 0x42e7f916d315055e, 0xcd730bca9c9fc2db
d_2_9:          .dword 0x754f392921f2ee18, 0x095c04baa795ea1a
d_2_10:         .dword 0x4d6fa834adba8ac9, 0xd3ab2e82a6ec3e8c
d_2_11:         .dword 0x7696776c21b5f043, 0xfca58523674af3fb
d_2_12:         .dword 0x83b64fba88a12f11, 0xfec777ae57722f06
d_2_13:         .dword 0xbea9e93cb9e6deb4, 0xa71405f785517c56
d_2_14:         .dword 0xf65f13b3e40b954f, 0xab8828b49652c29d
d_2_15:         .dword 0xf533b9e687355665, 0x29fa013b7997b982
d_2_16:         .dword 0x9c626eec2ac19e66, 0x7122825b306f6841
d_2_17:         .dword 0x5e57a5f37d149f2f, 0x6c91eba6e792d776
d_2_18:         .dword 0x8f86b2873ef96565, 0x7be998c822a8526e
d_2_19:         .dword 0xdb76c7d61b56615a, 0xe6ee236cda1de280
d_2_20:         .dword 0x21484b9e7ca98b3e, 0x689b06088b26f4c3
d_2_21:         .dword 0x2608a83396b982cf, 0x466248f0c6790167
d_2_22:         .dword 0x6af1b5bed7c15db9, 0x185269146f6f533b
d_2_23:         .dword 0xb98a051b046879b5, 0x01f090fccc5e1be7
d_2_24:         .dword 0x892a95052643674c, 0x8f1c65e2fb87b79e
d_2_25:         .dword 0x2364a1ab0b752d2b, 0x00ba499d4cc06cc6
d_2_26:         .dword 0x54660497c04b436a, 0x61dae076b0afc199
d_2_27:         .dword 0xf6e771e777a03140, 0xa626a55caddbe4c0
                .dword 0x19b371bd5374ef65, 0x1f8c9533ae6b6108
                .dword 0x82b98bb5f95aec7a, 0x6d48140114b976e5
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x2b694db4ce7dd03b, 0xff4c939f7f124a69
                .dword 0x763491583ac40b92, 0x34a4e0f0763c796e
d_3_0:          .dword 0x3e67d1a673db7895, 0xb4477681fd905095
d_3_1:          .dword 0x51c5e0647398ed6a, 0x7a045fccc3456629
d_3_2:          .dword 0x34c8d9f5d5b0437b, 0x1fcc4de51cb93eaf
d_3_3:          .dword 0x6c2d80fdbe9a64e3, 0xfc2968d8d66abb1c
d_3_4:          .dword 0xe3aa027448a51467, 0x56fcdae191731e18
d_3_5:          .dword 0xfd2badb6690b2a06, 0x31a0ef0686f466f0
d_3_6:          .dword 0x0e32cefcc24f37b0, 0xd2fa39d1106ead43
d_3_7:          .dword 0x80acd02c86afa36d, 0x6984bb27f570f6a2
d_3_8:          .dword 0x61f9d43dc1399214, 0x8f62934805c77ea4
d_3_9:          .dword 0xe5a5bd7552fda820, 0x218d3fdb230453b7
d_3_10:         .dword 0xe77af4e0c564e485, 0x6197a2ddee165aa6
d_3_11:         .dword 0x83f8fa23939d6f85, 0x330366eeb1e8d47f
d_3_12:         .dword 0x549754813f7b9f5b, 0x6499e080692d21c2
d_3_13:         .dword 0xd9c159155083561c, 0xd8268f7f6b173e87
d_3_14:         .dword 0x34e1412a59aec668, 0x2868b87dfc52aa29
d_3_15:         .dword 0xc286f5876941d3fd, 0xf4e092d93fbf1d69
d_3_16:         .dword 0xc8971b396cb9d51b, 0xc52f3041f22ccc76
d_3_17:         .dword 0x879a914b7011e6a4, 0x5e44ff76693a82b0
d_3_18:         .dword 0xb10f985fb361f612, 0x7b7612c2a790e133
d_3_19:         .dword 0x45dc62a35479876a, 0x10ef97905ac8441c
d_3_20:         .dword 0xb7488ff2715fedff, 0xeb26987a269a27ec
d_3_21:         .dword 0xa998a32c8ff5742b, 0x3e23475b8fba3e30
d_3_22:         .dword 0x421fb2aaac9375a2, 0x000d60e1e4c9a36f
d_3_23:         .dword 0x282af795d17e51c6, 0x6933ff7951a7525a
d_3_24:         .dword 0x099fae77a552e74f, 0x7466685fbf70f0d7
d_3_25:         .dword 0x4808483dcbb6fa48, 0x0bf7c345516c6a91
d_3_26:         .dword 0xc56581580fe672a8, 0x97036879e8578406
d_3_27:         .dword 0x8b83e72c9211fe86, 0x7c558b101bc08382
                .dword 0x8c43f6e9435f660e, 0x0f04d24c8b39bd43
                .dword 0x7bd626b0097b0be4, 0xcbb856707659ad9c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xd0afb0818c472402, 0x4e5568e88d57228c
                .dword 0x3c8371bf77769d5c, 0x8311903f24457549
d_4_0:          .dword 0xafe687051e89bbb7, 0xbb18d6bbf1c6e280
d_4_1:          .dword 0xd61ca876ad699010, 0x036aaa8b8d2443d7
d_4_2:          .dword 0x3e64e04387d50bac, 0x7f71600e5dff4850
d_4_3:          .dword 0x482905fe0c268eb0, 0x876b1ef7ebc4b6c6
d_4_4:          .dword 0x20d344aa257e3538, 0x55db4627c125efc8
d_4_5:          .dword 0xc05f0b0e46877a30, 0xad4561dc1bf50540
d_4_6:          .dword 0x3a1582429eda08bb, 0xd7720e557b697bf0
d_4_7:          .dword 0xc0737a2bd7236183, 0xe44f51630ba616bf
d_4_8:          .dword 0x9e4763dc3a26c42e, 0x24cd5fd61fc07e13
d_4_9:          .dword 0xa641f60b29720c74, 0x2294ab4ffa0f1939
d_4_10:         .dword 0x800529e13c3986a6, 0xe61c1ab6ec677897
d_4_11:         .dword 0x87248385c24afeb0, 0x55fb26e8cda7ea2f
d_4_12:         .dword 0x36b5aa2a1328f8ff, 0x8f15ece861777eb8
d_4_13:         .dword 0x7936124c810ac847, 0x9df195083960c1cd
d_4_14:         .dword 0x81ff541c17be72b0, 0x688c4fcb6416cdba
d_4_15:         .dword 0xdbc5d0ced6dd9e63, 0x264357e70458bceb
d_4_16:         .dword 0x4aa789666701e13c, 0x3b6ce3ef9297553b
d_4_17:         .dword 0x3a41b87dac108bec, 0x040226ec84444b9d
d_4_18:         .dword 0x924b596b55cbe1c2, 0x484157d684cf29a5
d_4_19:         .dword 0xb6bce7b47b3e4e66, 0x63ea6981bb9e898f
d_4_20:         .dword 0x4d17544864b027cf, 0xa94565838a08acba
d_4_21:         .dword 0x44061679d7d2548a, 0xab69b0012ff618d3
d_4_22:         .dword 0x15cf9ffa067ce12c, 0x406bad15eda636ab
d_4_23:         .dword 0xabe201bfd597cbe1, 0x180b6cee54e37561
d_4_24:         .dword 0x26fdac098f5e15a8, 0xc7bc2e80beac9a36
d_4_25:         .dword 0xf5b4fa2eb81cafcb, 0x2bb01e702c771730
d_4_26:         .dword 0xc2a386820aa2a00c, 0x747c7f314fecb56b
d_4_27:         .dword 0x6e6d350a55031f63, 0xc7dc01f4556e24a6
                .dword 0x0df7b0fd35eb8d07, 0xd2d1be8a87c19dcc
                .dword 0x8497a6a5a177ff6a, 0x5df184a8cd5deb24
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xd94a241147ba057e, 0x05332489e1781931
                .dword 0x4a9f869fc4c4cb14, 0x203622934d34aae5
d_5_0:          .dword 0xa110e374b5bc8ea6, 0xe566f490524605f5
d_5_1:          .dword 0x51af5c93fbd943ac, 0xac39b484c2bf8d9b
d_5_2:          .dword 0xdba7fb7fe614a7f7, 0xff95ecc682167080
d_5_3:          .dword 0xba91affff44f203e, 0xd20891b151f39f69
d_5_4:          .dword 0xc52357007112ae02, 0x6d93b4fabd505ef1
d_5_5:          .dword 0xfad541f38fa765ab, 0xf2b38e27731a1267
d_5_6:          .dword 0x8248464b8d8e64a9, 0xf2f04a0fe7db89e1
d_5_7:          .dword 0x4c1e7697d9d40074, 0xe8a1a8dc4fd6b8c3
d_5_8:          .dword 0xc90546eaf5015257, 0xf57e9d72cf8151e1
d_5_9:          .dword 0xe524ac8f16930f64, 0xc31fb883ae1a7ff2
d_5_10:         .dword 0x9112ff1d72a55142, 0x64149447ed38a18f
d_5_11:         .dword 0x0060f754e53c119f, 0x9cb92c59b0f56654
d_5_12:         .dword 0x142c5ce22bf69a67, 0x5266909544df73cd
d_5_13:         .dword 0xb12af199bd1a7372, 0xacc83c72156b5c9a
d_5_14:         .dword 0x7cb1830b5f567225, 0x21832035dcd21135
d_5_15:         .dword 0xf93cbe940fe444ec, 0x3dd7a5472bc54fcd
d_5_16:         .dword 0x093bfdaf59fa8931, 0xea78caf8b115c604
d_5_17:         .dword 0x489030e4464450c6, 0x75eb644635b1a118
d_5_18:         .dword 0xcec327a6f02211db, 0xc0798dd15983dac3
d_5_19:         .dword 0x46ca1442cda1de07, 0x439911ee2a54ec1d
d_5_20:         .dword 0xc6d3493a9dcbfc53, 0x110bcbc35c7896b4
d_5_21:         .dword 0xbd45bfaa7d20bd8c, 0x9cc5d9b95566a629
d_5_22:         .dword 0x79db79bc0041261d, 0x4096340d467b7def
d_5_23:         .dword 0x8e5a2daa0cbd8034, 0x9328fb53fb6f8e5d
d_5_24:         .dword 0xe17ccff334ac9a1c, 0xe54db86baca87124
d_5_25:         .dword 0x6990498eb9964a56, 0x1691d12fdb93a288
d_5_26:         .dword 0x6fc376eb4d0d2b57, 0x3dfa3918e89e1569
d_5_27:         .dword 0xe082787ddea10774, 0x87fdc9b010eba459
                .dword 0xa65ef966959c346d, 0x380d0e8bc0702b61
                .dword 0xfef42565fc08a240, 0x24280cd6aa3db4ee
         /* Random data */
_end_data5:
              
                 
