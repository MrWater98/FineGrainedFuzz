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
_s0:    la x28, d_0_18                            ;
        addi x28, x28, -8                         ;
        amoor.d x8, x8, (x28)                     ;
_s1:    xor x26, x26, x26                         ;
        addi x17, zero, 3                         ;
        slli x17, x17, 4                          ;
        add x26, x26, x17                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 5                            ;
        add x26, x26, x2                          ;
        csrrc x17, satp, x26                      ;
_s2:    bge x30, x23, _s4                                 ;
_s3:    la x19, d_1_12                            ;
        fsw f5, 0(x19)                            ;
_s4:    remu x26, x27, x29                        ;
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
_p0:    csrrwi x14, sstatus, 27                   ;
_p1:    xor x14, x14, x14                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 14                         ;
        add x14, x14, x12                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 2                          ;
        add x14, x14, x13                         ;
        csrrw x10, medeleg, x14                   ;
_p2:    csrrwi x12, sstatus, 31                   ;
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
_l0:    subw x4, x8, x10                          ;
_l1:    la x19, d_5_18                            ;
        sd x7, 24(x19)                            ;
_l2:    blt x20, x19, _l8                                 ;
_l3:    srlw x10, x10, x8                         ;
_l4:    la x18, d_1_14                            ;
        addi x18, x18, 8                          ;
        amomaxu.w x21, x21, (x18)                 ;
_l5:    la x18, _l161                                     ;
        jalr x15, 0(x18)                          ;
_l6:    la x24, d_5_21                            ;
        addi x24, x24, -28                        ;
        amominu.w x24, x21, (x24)                 ;
_l7:    fcvt.w.s x13, f28, rup                    ;
_l8:    remu x21, x21, x1                         ;
_l9:    la x24, d_0_7                             ;
        lbu x21, -31(x24)                         ;
_l10:   div x20, x20, x18                         ;
_l11:   fsgnjn.s f2, f8, f8                       ;
_l12:   remuw x26, x0, x26                        ;
_l13:   la x18, _l53                              ;
        flw f4, 24(x18)                           ;
_l14:   remw x3, x12, x29                         ;
_l15:   ebreak                                    ;
_l16:   li x3, 0                                  ;
        la x7, pt3                                ;
        addi x7, x7, 8                            ;
        sfence.vma x3, x7                         ;
_l17:   ebreak                                    ;
_l18:   la x21, d_1_26                            ;
        addi x21, x21, -8                         ;
        amomin.d x30, x5, (x21)                   ;
_l19:   la x27, d_3_22                            ;
        sw x18, 0(x27)                            ;
_l20:   ecall                                     ;
_l21:   csrrsi x11, pmpcfg0, 0                    ;
_l22:   la x26, d_2_23                            ;
        addi x26, x26, 0                          ;
        lui x26, 0xffe00                          ;
        xor x26, x26, x26                         ;
        sc.w x27, x26, (x26)                      ;
_l23:   la x24, d_2_11                            ;
        addi x24, x24, 12                         ;
        amoswap.w x22, x28, (x24)                 ;
_l24:   sltiu x19, x29, -0                        ;
_l25:   la x11, d_3_23                            ;
        lwu x28, -24(x11)                         ;
_l26:   la x13, d_2_4                             ;
        addi x13, x13, 24                         ;
        amomax.d x24, x12, (x13)                  ;
_l27:   la x8, d_1_12                             ;
        addi x8, x8, 28                           ;
        sc.w x9, x16, (x8)                        ;
_l28:   la x21, d_1_19                            ;
        addi x21, x21, 0                          ;
        amomin.w x22, x22, (x21)                  ;
_l29:   la x28, _l103                                      ;
        csrrw zero, mepc, x28                     ;
        mret                                      ;
_l30:   li x24, 0                                 ;
        la x4, pt1                                ;
        addi x4, x4, 16                           ;
        sfence.vma x24, x4                        ;
_l31:   divw x22, x20, x30                        ;
_l32:   bge x11, x20, _l80                                ;
_l33:   sltiu x10, x28, 628                       ;
_l34:   div x26, x21, x10                         ;
_l35:   beq x12, x9, _l116                                ;
_l36:   fnmadd.s f6, f6, f5, f7, dyn              ;
_l37:   la x13, d_2_5                             ;
        srai x13, x13, 1                          ;
        csrrw x27, pmpaddr4, x13                  ;
_l38:   la x13, d_0_4                             ;
        srai x13, x13, 1                          ;
        csrrw x29, pmpaddr0, x13                  ;
_l39:   andi x27, x1, -9                          ;
_l40:   fdiv.s f27, f6, f21, rdn                  ;
_l41:   fmul.s f26, f26, f14, rdn                 ;
_l42:   la x21, d_5_3                             ;
        addi x21, x21, -4                         ;
        lui x30, 0xffe00                          ;
        xor x21, x21, x30                         ;
        amoadd.w x19, x30, (x21)                  ;
_l43:   addw x24, x7, x19                         ;
_l44:   slli x21, x24, 18                         ;
_l45:   fsgnj.s f14, f22, f17                     ;
_l46:   srliw x6, x15, 31                         ;
_l47:   fence.i                                   ;
_l48:   fcvt.w.s x27, f26, rmm                    ;
_l49:   fsqrt.s f22, f14, rup                     ;
_l50:   bgeu x3, x17, _l75                                ;
_l51:   fsgnjx.s f0, f20, f6                      ;
_l52:   andi x9, x2, -1842                        ;
_l53:   la x13, d_0_27                            ;
        ld x26, -0(x13)                           ;
_l54:   la x26, _l68                                      ;
        lh x16, 24(x26)                           ;
_l55:   fsgnjx.s f9, f25, f7                      ;
_l56:   fsgnjx.s f14, f12, f8                     ;
_l57:   la x18, d_5_8                             ;
        addi x18, x18, 8                          ;
        amoor.d x7, x3, (x18)                     ;
_l58:   divuw x0, x10, x9                         ;
_l59:   bltu x2, x1, _l129                                ;
_l60:   rem x9, x7, x29                           ;
_l61:   la x25, d_0_14                            ;
        addi x25, x25, 8                          ;
        amomax.d x13, x14, (x25)                  ;
_l62:   la x20, d_2_27                            ;
        sw x14, -20(x20)                          ;
_l63:   srai x26, x30, 20                         ;
_l64:   la x2, d_0_9                              ;
        sh x22, 6(x2)                             ;
_l65:   remuw x26, x12, x4                        ;
_l66:   xor x2, x2, x2                            ;
        addi x5, zero, 1                          ;
        slli x5, x5, 9                            ;
        add x2, x2, x5                            ;
        addi x24, zero, 3                         ;
        slli x24, x24, 4                          ;
        add x2, x2, x24                           ;
        addi x16, zero, 1                         ;
        slli x16, x16, 28                         ;
        add x2, x2, x16                           ;
        csrrs x29, stval, x2                      ;
_l67:   fcvt.lu.s x15, f9, dyn                    ;
_l68:   fnmsub.s f1, f22, f9, f15, rmm            ;
_l69:   mulhu x18, x28, x2                        ;
_l70:   mul x3, x9, x6                            ;
_l71:   addi x18, x27, -2047                      ;
_l72:   fcvt.s.l f7, x29, rup                     ;
_l73:   la x29, d_0_26                            ;
        addi x29, x29, -16                        ;
        amomax.w x12, x4, (x29)                   ;
_l74:   la x30, d_4_13                            ;
        addi x30, x30, -24                        ;
        amoor.d x24, x6, (x30)                    ;
_l75:   subw x8, x11, x6                          ;
_l76:   lui x17, 962138                           ;
_l77:   la x19, d_4_9                             ;
        lui x2, 0xffe00                           ;
        xor x19, x19, x2                          ;
        flw f14, -0(x19)                          ;
_l78:   la x15, d_2_23                            ;
        addi x15, x15, -28                        ;
        amoor.w x10, x24, (x15)                   ;
_l79:   fcvt.l.s x23, f2, rup                     ;
_l80:   rem x9, x8, x22                           ;
_l81:   bltu x7, x22, _l132                               ;
_l82:   remu x15, x1, x23                         ;
_l83:   sllw x9, x22, x8                          ;
_l84:   la x14, d_4_15                            ;
        ld x14, 16(x14)                           ;
_l85:   la x18, d_1_3                             ;
        addi x18, x18, -8                         ;
        amoswap.d x14, x18, (x18)                 ;
_l86:   sraiw x11, x5, 22                         ;
_l87:   flt.s x11, f3, f0                         ;
_l88:   fcvt.wu.s x0, f5, rmm                     ;
_l89:   la x15, d_2_19                            ;
        lb x18, 0(x15)                            ;
_l90:   mulhu x16, x24, x16                       ;
_l91:   sllw x11, x8, x1                          ;
_l92:   fmv.x.w x17, f21                          ;
_l93:   la x19, d_4_10                            ;
        addi x19, x19, -16                        ;
        amomaxu.w x14, x19, (x19)                 ;
_l94:   rem x15, x9, x15                          ;
_l95:   mul x21, x17, x13                         ;
_l96:   la x16, d_0_26                            ;
        addi x16, x16, 16                         ;
        amoadd.d x18, x21, (x16)                  ;
_l97:   jal x27, _l144                                    ;
_l98:   flt.s x18, f30, f14                       ;
_l99:   fmin.s f22, f5, f28                       ;
_l100:  xor x16, x16, x16                         ;
        addi x31, zero, 3                         ;
        slli x31, x31, 24                         ;
        add x16, x16, x31                         ;
        csrrw x2, sip, x16                        ;
_l101:  srai x6, x3, 27                           ;
_l102:  sllw x16, x19, x27                        ;
_l103:  la x1, d_0_3                              ;
        lui x21, 0xffe00                          ;
        xor x1, x1, x21                           ;
        lbu x21, 19(x1)                           ;
_l104:  la x3, d_1_17                             ;
        addi x3, x3, -12                          ;
        amoor.w x7, x13, (x3)                     ;
_l105:  lui x6, 556990                            ;
_l106:  andi x16, x24, -25                        ;
_l107:  fcvt.s.lu f1, x14, rne                    ;
_l108:  fcvt.w.s x2, f10, rup                     ;
_l109:  mulhsu x19, x22, x27                      ;
_l110:  la x26, d_0_17                            ;
        addi x26, x26, 16                         ;
        amoswap.d x30, x1, (x26)                  ;
_l111:  sllw x27, x24, x27                        ;
_l112:  la x15, d_1_1                             ;
        addi x15, x15, 28                         ;
        amomaxu.w x27, x3, (x15)                  ;
_l113:  fcvt.s.wu f26, x26, rup                   ;
_l114:  divuw x22, x12, x11                       ;
_l115:  fsub.s f11, f24, f10, rtz                 ;
_l116:  fnmsub.s f3, f23, f0, f21, rdn            ;
_l117:  fnmsub.s f10, f3, f6, f25, rtz            ;
_l118:  la x3, _l166                              ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l119:  sraiw x11, x18, 2                         ;
_l120:  fcvt.s.wu f8, x19, rmm                    ;
_l121:  slli x12, x0, 4                           ;
_l122:  la x3, _l76                                       ;
        lui x23, 0xffe00                          ;
        xor x3, x3, x23                           ;
        ld x6, 24(x3)                             ;
_l123:  la x20, _l143                                     ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l124:  xori x14, x23, 1193                       ;
_l125:  fmul.s f16, f12, f10, rne                 ;
_l126:  srli x21, x6, 21                          ;
_l127:  csrrci x27, sip, 5                        ;
_l128:  la x18, d_2_3                             ;
        addi x18, x18, 16                         ;
        amomin.d x29, x21, (x18)                  ;
_l129:  fcvt.s.l f31, x19, rne                    ;
_l130:  la x9, d_2_5                              ;
        addi x9, x9, 16                           ;
        amomax.w x4, x27, (x9)                    ;
_l131:  fmadd.s f27, f11, f2, f1, rne             ;
_l132:  subw x4, x28, x19                         ;
_l133:  fcvt.s.l f23, x30, rne                    ;
_l134:  fmin.s f11, f24, f21                      ;
_l135:  addw x18, x21, x0                         ;
_l136:  xor x11, x11, x11                         ;
        csrrw x18, mhartid, x11                   ;
_l137:  rem x16, x6, x12                          ;
_l138:  fdiv.s f25, f21, f25, rdn                 ;
_l139:  la x4, _l148                                       ;
        lh x4, 16(x4)                             ;
_l140:  la x25, d_2_21                            ;
        addi x25, x25, -24                        ;
        sc.w x1, x16, (x25)                       ;
_l141:  srlw x2, x23, x0                          ;
_l142:  la x20, d_0_11                            ;
        sd x22, 16(x20)                           ;
_l143:  la x24, _l150                                     ;
        jalr x26, 0(x24)                          ;
_l144:  li x0, 1                                  ;
        la x8, pt1                                ;
        addi x8, x8, 40                           ;
        sfence.vma x0, x8                         ;
_l145:  la x2, _l75                                       ;
        flw f10, -4(x2)                           ;
_l146:  la x17, d_4_5                             ;
        lh x26, 14(x17)                           ;
_l147:  mulhsu x2, x28, x12                       ;
_l148:  lui x3, 104206                            ;
_l149:  fnmsub.s f4, f11, f21, f30, dyn           ;
_l150:  la x12, d_4_10                            ;
        lh x2, 26(x12)                            ;
_l151:  la x22, d_2_15                            ;
        lui x11, 0xffe00                          ;
        xor x22, x22, x11                         ;
        lbu x8, 20(x22)                           ;
_l152:  la x27, d_3_26                            ;
        fsw f27, 12(x27)                          ;
_l153:  mulhu x8, x16, x12                        ;
_l154:  la x1, d_2_3                              ;
        addi x1, x1, 0                            ;
        sc.d x16, x1, (x1)                        ;
_l155:  feq.s x5, f4, f0                          ;
_l156:  addi x10, x4, 1914                        ;
_l157:  fsgnjn.s f0, f26, f8                      ;
_l158:  la x1, d_0_16                             ;
        addi x1, x1, -0                           ;
        amoor.d x27, x17, (x1)                    ;
_l159:  la x11, _l175                             ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l160:  divuw x17, x16, x10                       ;
_l161:  xor x19, x19, x19                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 1                          ;
        add x19, x19, x27                         ;
        addi x26, zero, 1                         ;
        slli x26, x26, 21                         ;
        add x19, x19, x26                         ;
        csrrs x10, mhartid, x19                   ;
_l162:  bge x5, x22, _l163                                ;
_l163:  fsgnjx.s f16, f2, f14                     ;
_l164:  csrrsi x19, fflags, 18                    ;
_l165:  sraiw x2, x4, 13                          ;
_l166:  divuw x10, x10, x17                       ;
_l167:  remw x25, x21, x10                        ;
_l168:  la x15, d_3_20                            ;
        addi x15, x15, 4                          ;
        amomax.w x9, x23, (x15)                   ;
_l169:  remw x2, x30, x18                         ;
_l170:  la x18, d_5_11                            ;
        addi x18, x18, -12                        ;
        amoadd.w x12, x3, (x18)                   ;
_l171:  csrrci x30, pmpaddr6, 26                  ;
_l172:  la x10, d_4_3                             ;
        addi x10, x10, -8                         ;
        amoswap.d x26, x12, (x10)                 ;
_l173:  addw x21, x14, x7                         ;
_l174:  remu x10, x30, x16                        ;
_l175:  remw x16, x0, x28                         ;
_l176:  la x8, d_5_6                              ;
        lui x29, 0xffe00                          ;
        xor x8, x8, x29                           ;
        lbu x22, 8(x8)                            ;
_l177:;
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
                .dword 0x600f0624bdcff1f3, 0xcd23527f93b0b3d1
                .dword 0xdbf4dd8f208a3f6d, 0xecf1b7d3d1dbdccc
d_0_0:          .dword 0xf18ce7ac802ebe6a, 0xfa452043d728a0ca
d_0_1:          .dword 0x9d3802d2de6b7a83, 0x9edb3a4fb787625d
d_0_2:          .dword 0xa4b187f3ad297928, 0x4a761bc27b15e8d2
d_0_3:          .dword 0xafda136f6537e956, 0x7d814a495c90bad9
d_0_4:          .dword 0x5657724f81d6e971, 0x669b2a5108745ef9
d_0_5:          .dword 0x0ba6864bc5efea4f, 0xa693860ee26b0972
d_0_6:          .dword 0x4dcc98d9f028121d, 0xb2c9a0ffc65a3878
d_0_7:          .dword 0x84bd285f3bc7e9bd, 0xb299be2b0f4e98f4
d_0_8:          .dword 0x2a8610a1e3e87af2, 0x44fc79ad18005a44
d_0_9:          .dword 0x2220b37025186ec8, 0x1f94cd656df90a88
d_0_10:         .dword 0xb7c403fe0757b01f, 0x1a6d2caa1b7c133c
d_0_11:         .dword 0xb4d941ab63abd86b, 0x9cc99f0026eb95f5
d_0_12:         .dword 0x396c6f0412bb25bf, 0x016a51a85961342a
d_0_13:         .dword 0x7dcc28a5897cbac0, 0xe9aa878120bc2c74
d_0_14:         .dword 0x639182f7c932fc86, 0xb21accc0e04322d1
d_0_15:         .dword 0x8214c9131cf9118d, 0x99446a6f75572a45
d_0_16:         .dword 0xce8558dbd099db56, 0xbfffce83399df595
d_0_17:         .dword 0x1547e3116bd03706, 0xbdb3473f6166bc15
d_0_18:         .dword 0x30307af1a606f613, 0x63b008fcc5711379
d_0_19:         .dword 0xfd7c18fba632a2c5, 0xb323b4cf14ca0992
d_0_20:         .dword 0xa7d85df3b2a42663, 0x9396ee9e5473753f
d_0_21:         .dword 0xf6a5b1626baa3072, 0x90d6ae8dfb6947fc
d_0_22:         .dword 0x52419764d6ab626c, 0x6e3a63d5589a443f
d_0_23:         .dword 0xb61f673d9bba1e3d, 0x710db0492cf3ed21
d_0_24:         .dword 0xd9983a6b1dab44fe, 0x75404805c99619a7
d_0_25:         .dword 0x6979a8ba423fd4a9, 0x0e6de86153aba213
d_0_26:         .dword 0x194c75b2adf81b9f, 0x6588ab659a81b68f
d_0_27:         .dword 0x906f2f8affce4771, 0x9553f67f9df106fb
                .dword 0xb15b7034608ab941, 0x16e12cb4f3f67f88
                .dword 0x9c6269f79f4569de, 0xb2b5647638c33a97
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x27024b091e8b2ed7, 0xb7551c86f804eb1a
                .dword 0x4cd102fcea25f5b8, 0x813d9ea32e619cc5
d_1_0:          .dword 0x3c83bcc7457011a7, 0x06e054acd799f880
d_1_1:          .dword 0x08ac51871c1bf69c, 0x0e079dbbfba5e0ca
d_1_2:          .dword 0xead955f5aea82d43, 0x6297b39a5e597684
d_1_3:          .dword 0x87afea47a910c8c5, 0xa76d32c92045645a
d_1_4:          .dword 0x0b6ecdf1c37c77db, 0x28674974b6537679
d_1_5:          .dword 0x1979df5daf793f20, 0xec37b8173dfd26fa
d_1_6:          .dword 0xb353d978c3875f86, 0x502b961d708bac06
d_1_7:          .dword 0x8a7497314b632ba9, 0x3b28eacb5a6ad875
d_1_8:          .dword 0xbf8a0945f486217b, 0x4d804fafc4b32ae9
d_1_9:          .dword 0xe46f0b43a56f7f91, 0x8e4647073dc5a4c6
d_1_10:         .dword 0x9aa09192f8a60c2c, 0xb2effa0bcccadaee
d_1_11:         .dword 0x1754412ce59cce0c, 0xc8813bf01c755378
d_1_12:         .dword 0xbe13fe9dc9e06999, 0xfa3099909c734c0a
d_1_13:         .dword 0x977939339d2a4e02, 0x93cf3a6d22fdac34
d_1_14:         .dword 0x503eb5077d21d096, 0x62824c779f2a402a
d_1_15:         .dword 0xa04ab97ed30e0a40, 0xdf8c080087072e85
d_1_16:         .dword 0xb37548fe1963ec02, 0x9d793ac672aaf2a7
d_1_17:         .dword 0x8b78538f367482a4, 0x5ce5df6f170fbfbe
d_1_18:         .dword 0x2a28f4ffb429868f, 0x9eadff86b99b08ec
d_1_19:         .dword 0x172f67a02f6ed887, 0x9eb94ae51f01707e
d_1_20:         .dword 0xe940550aaf013016, 0x18c1896b01d2e81b
d_1_21:         .dword 0x4bc7be0eb43cdec8, 0xf49a2bcad3dec6a9
d_1_22:         .dword 0x1715439ac9d62237, 0xf2b9ec33a029d978
d_1_23:         .dword 0x2a87cd695c4a6b13, 0x3bddf77113ee0994
d_1_24:         .dword 0x642778a1a7f9e71b, 0xc0e7bf0025c9299d
d_1_25:         .dword 0x695983bff39d960a, 0x23b901ba7fc8bcd7
d_1_26:         .dword 0xaef7415fe7ae3010, 0x82c2a1091e1f03e3
d_1_27:         .dword 0xcedec15f94c35941, 0xe7b149f08cc14154
                .dword 0x82d8496d92eb32fb, 0xa62d18fa6e37b1b8
                .dword 0x77995067c533ecee, 0x13b2dd52d6312710
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe70a37a7851bcb32, 0x036ff9056f0c0f34
                .dword 0xc113dd480ab07c8b, 0x82f7fb021340dfce
d_2_0:          .dword 0x7fb70f2a5aa4a1f0, 0xd8dd8297eab57b0a
d_2_1:          .dword 0xcc6e113ae01eb53e, 0x6ed468bad2719e90
d_2_2:          .dword 0x55c38c94662d12da, 0x9b18eb831972a498
d_2_3:          .dword 0x079954147681d3ed, 0x1711342a75353f94
d_2_4:          .dword 0x765377930c12d70c, 0x6c09a162065fcadd
d_2_5:          .dword 0xaa1106c9a0f82c9a, 0xf0f7859463b1a0e1
d_2_6:          .dword 0xf836ad6945722f4d, 0xc00901f8130b88d0
d_2_7:          .dword 0xaa2627591345d96c, 0xc6362a74a8ed5e70
d_2_8:          .dword 0x3f1089a348828324, 0x731c247f7eab3aab
d_2_9:          .dword 0x27e4b093b57ca2d3, 0x835a135657e69a81
d_2_10:         .dword 0x243e743f0bd744e4, 0x691954487553599f
d_2_11:         .dword 0x8d6f4516dc2750eb, 0xa8afec4c9b9e6276
d_2_12:         .dword 0x491391c53d279477, 0x649c21af995da971
d_2_13:         .dword 0x5693f05264eee20b, 0xd9a8588efdd352d5
d_2_14:         .dword 0xa95011e417788d1f, 0xa0c152ee83346b21
d_2_15:         .dword 0xc2b916d4f25e6b85, 0xf1c364e76e32b57b
d_2_16:         .dword 0x862ce5eec0906f62, 0xe0d452aa5104d61a
d_2_17:         .dword 0x21c66294ce307d71, 0x02067abc167bfc4f
d_2_18:         .dword 0xdc9d0e80be76a47f, 0x877e47f69e5f83eb
d_2_19:         .dword 0xc87f69ce473a0e55, 0x86b78cacd265e587
d_2_20:         .dword 0xc6dd744adbd79996, 0x5e33dad9da2d251a
d_2_21:         .dword 0x98e512830e48e757, 0x7feda6dfdfb71d5a
d_2_22:         .dword 0x5a32826a45a3d0b4, 0x8c2a732403ae59d7
d_2_23:         .dword 0xf4484735e9290163, 0x4098e0cdb7eb6cc5
d_2_24:         .dword 0x01b7091193f54dd9, 0x62fe7e9aa647d85f
d_2_25:         .dword 0xdd9949a5e549352d, 0xedca90e4f31dbc09
d_2_26:         .dword 0x069c9124ac7f4244, 0x9b6697d002cda405
d_2_27:         .dword 0x9f04efd4999617ed, 0x3e17558bb3f680c5
                .dword 0x786a39a008577388, 0xe71f3db9741119b6
                .dword 0xc62b08e29c08607c, 0x6b231c81e47d89b9
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x1ef75747048edb50, 0x808f18694d7a19cb
                .dword 0x8711a7b55fc7ace6, 0xcb95554d11e7bbe2
d_3_0:          .dword 0xf50495c98ac826e7, 0x1cdb02859b7a43dc
d_3_1:          .dword 0x51ac71c4f64dde61, 0x07461284629fc474
d_3_2:          .dword 0xb81e80ccde60ae75, 0x350abf2d38bfa2d8
d_3_3:          .dword 0xb2fb25c8c69c3a7a, 0xfe54fc083ceb9f20
d_3_4:          .dword 0xfdcedffd3540d7ec, 0xdcd9084ced7cbc9c
d_3_5:          .dword 0x2b82828d59fe5084, 0xde79035652bbcf58
d_3_6:          .dword 0xbc188cc2ca26031c, 0xe4c0da38a8f7a4fc
d_3_7:          .dword 0x029b0381cc89ce8a, 0x39cf56f764341bf0
d_3_8:          .dword 0x09da7852ed5c3fff, 0x598ccc9841327286
d_3_9:          .dword 0x2cebeb0ad7b3cd60, 0xe5ee2db6b3021aa5
d_3_10:         .dword 0x3e7aabefc0492492, 0x29b360baaa582b14
d_3_11:         .dword 0xdf7bcf01bb3beb81, 0x063c4904ff022dd8
d_3_12:         .dword 0x2e26a65d4d818f3a, 0x57d51f31a3a5da40
d_3_13:         .dword 0x8c55ad305e507cca, 0x34c65514aaa1228b
d_3_14:         .dword 0x2196fa5358e04e6f, 0x6f98e618d17616b8
d_3_15:         .dword 0x74e459d35715e59e, 0xafe2c45850e9178e
d_3_16:         .dword 0x592901eff358f91f, 0x16bcd464472d8c16
d_3_17:         .dword 0xd35c9eb8a533d4b9, 0xa4116ee37fabc116
d_3_18:         .dword 0x60f36f8aecd62bbc, 0x43b4a474566d4198
d_3_19:         .dword 0xe78486d780664416, 0xd8d3a07438b6b10c
d_3_20:         .dword 0xbc6cc62df119f732, 0x2d8a196e4ce1db0b
d_3_21:         .dword 0x77ab8b5968e0f02d, 0x93f71731abdf0304
d_3_22:         .dword 0xfbfb15f419d12251, 0xe1e58b84ccf73011
d_3_23:         .dword 0xd7dd7306248b3db1, 0x51a13d00270a9420
d_3_24:         .dword 0x7c68a5dda87cda23, 0xd2bdd7e8b3079c05
d_3_25:         .dword 0xd0a9eb919f271996, 0x1cc854551a0d7b45
d_3_26:         .dword 0xa2259e6b2f0970b4, 0x3fff799811b1770a
d_3_27:         .dword 0x46c3e71f8fb06258, 0xd7177584dfedeb8a
                .dword 0x86142385768c0efb, 0x9b6e2fb0f934d4ea
                .dword 0xbf96bee3ab7c9774, 0xf7dcacb930e608e9
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8ed7919e08b13823, 0x9ca22b00a4e104de
                .dword 0x8ce5f6f5a4ced662, 0x78394f6ef95d9b15
d_4_0:          .dword 0x554db7e844ae023d, 0xbc96047f72f07705
d_4_1:          .dword 0x8f83c7c467f9d24a, 0x46a8b8f4fabbfc4e
d_4_2:          .dword 0xccd93b5e69406e9f, 0x57ec5751f5b23843
d_4_3:          .dword 0x5ea19123456876a0, 0x0e0b2efc1c7718a8
d_4_4:          .dword 0xd23cf15634451cf3, 0x29f9827bffcf124b
d_4_5:          .dword 0x82bb493a93106fcc, 0x2ec3116c6c6f4f83
d_4_6:          .dword 0x1edac1523b798e23, 0x00d1bbbec73f343f
d_4_7:          .dword 0x5ab591a3759d2552, 0x73bb86071a427881
d_4_8:          .dword 0x867de836ccfc35a2, 0x459c1e171371dd65
d_4_9:          .dword 0xe90fdfdd3245436e, 0x21b5de18b4f00e0b
d_4_10:         .dword 0x0eeee69a61aeba74, 0x008f3f55388e057a
d_4_11:         .dword 0x3f8308cd524c6293, 0xb822d11b21133b9b
d_4_12:         .dword 0xa6a391a3b0e0c3c7, 0x60023d93617f230b
d_4_13:         .dword 0x8be647e158ea4b9f, 0x609021620c4eb3e1
d_4_14:         .dword 0x2d313cfd65125041, 0xab4718d123123542
d_4_15:         .dword 0xec94d1b6f3e1ab8d, 0x540acc5aac2f5020
d_4_16:         .dword 0x1371afdebf73af30, 0xf9d280d0c482c2cc
d_4_17:         .dword 0x78565250682ca3ae, 0xab6f3cb3664e83ec
d_4_18:         .dword 0x2a41e8706bbe8d42, 0x4a31517568b7ed8e
d_4_19:         .dword 0x69ff464bfd10e7d0, 0x4b29d9e757726a67
d_4_20:         .dword 0x2ca0fbad8dd55ea4, 0x21141506117220db
d_4_21:         .dword 0x30da407711c42cdd, 0xb9cbeff165b3c60b
d_4_22:         .dword 0x9ac4432d56ec3604, 0xb68f60a9501bb217
d_4_23:         .dword 0xab716ef1971bba63, 0x85ae58dde0146a42
d_4_24:         .dword 0x618774221dc0c2d9, 0xa2e0337a3049d55f
d_4_25:         .dword 0xd6944116fbb4aeed, 0xcc304f0eaac0685e
d_4_26:         .dword 0xcc2ec81f0a34b6e8, 0x617124ede083c3c4
d_4_27:         .dword 0x5a2dfe7ed624edaf, 0xe17274ee8cfb1024
                .dword 0xfb2071be8ea8e10e, 0x3f6d2ee9327d9477
                .dword 0x7252f345f8d68213, 0x9579a9fda329eac3
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xe59e9e7d6b740b5c, 0x5d805e539ab857f5
                .dword 0x4b98c2b810e9c5d6, 0x8019f71c4937e4c0
d_5_0:          .dword 0xdbc24fb4c8cb64c3, 0xfcc95f329acbe6d6
d_5_1:          .dword 0x9decf1c3141760ee, 0x23986d81c5fc795f
d_5_2:          .dword 0x5a16efad06773426, 0x9b09eae987296ea2
d_5_3:          .dword 0x9953f1dff74f2a4b, 0x60bf30749541f297
d_5_4:          .dword 0x845df6bb7ce8583e, 0xd6b38046cb162b95
d_5_5:          .dword 0x744f91ac2e57f23c, 0xdd48b8fa6304c3d4
d_5_6:          .dword 0xb48a9e4fd5ce745d, 0x13f612cf5ee83048
d_5_7:          .dword 0xfc8569f5cd6341cb, 0xfa9c744eb4753689
d_5_8:          .dword 0xcbf60b8f1965e129, 0x425ad4c988bf2c60
d_5_9:          .dword 0xcf8336e9642236ea, 0x30003ccc9c8a6f99
d_5_10:         .dword 0x1817780c6abfa480, 0xfc72ddd2ba997196
d_5_11:         .dword 0x8bcebfc56217aaad, 0x12802cbb27729d38
d_5_12:         .dword 0x19b4bd662c9cafec, 0x3ece8454cb191cd7
d_5_13:         .dword 0x8738cea298a4e7a5, 0xbfdd7a6efe4c4305
d_5_14:         .dword 0x57a02e73166fb65c, 0xf94b1b4b2ba46e70
d_5_15:         .dword 0x80b678fa9f485693, 0xbd6a814bd7f1a228
d_5_16:         .dword 0x4e43f580cc87ea48, 0x4cae9b5c5b1a00b7
d_5_17:         .dword 0xd3c2365f5459b6f1, 0x1c70dc749b826ed3
d_5_18:         .dword 0xf97a74b71ac1f3fb, 0x6ed6c881e102c771
d_5_19:         .dword 0xbefb422374acf28e, 0x24b6533901bf71ff
d_5_20:         .dword 0x6dd5a45effdbcb92, 0x9c43ea176efb7ae4
d_5_21:         .dword 0x3b6e9c5d7ee881cf, 0xd601f0ec4026834c
d_5_22:         .dword 0x23cbe1f7d8abe0aa, 0x35ad87e12fb3f572
d_5_23:         .dword 0xde5c0a77586e76b4, 0xef9c8c431f5901af
d_5_24:         .dword 0xfdfc048e63d7b7dc, 0xa448c425491faef3
d_5_25:         .dword 0x2aabb029d5d1b3cc, 0xc2109f61b03f2df7
d_5_26:         .dword 0x21747ccff45beddc, 0x4955313987535fea
d_5_27:         .dword 0xdc65e6f99aad1e0f, 0xd3ab76c277a7d507
                .dword 0x2917bb9a523e2d80, 0x102103eff57c1091
                .dword 0x3d8109a7821a908c, 0xf99ea5088a715186
         /* Random data */
_end_data5:
              
                 
