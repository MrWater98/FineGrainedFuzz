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
_s0:    la x11, d_1_25                            ;
        addi x11, x11, -24                        ;
        amoadd.d x8, x27, (x11)                   ;
_s1:    la x26, _s2                               ;
        csrrw zero, mepc, x26                     ;
        mret                                      ;
_s2:    mul x6, x28, x5                           ;
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
_p0:    csrrsi x13, medeleg, 30                   ;
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
_l0:    mul x9, x17, x12                          ;
_l1:    andi x29, x9, -10                         ;
_l2:    div x8, x3, x24                           ;
_l3:    la x15, d_2_25                            ;
        addi x15, x15, 24                         ;
        amoxor.d x15, x7, (x15)                   ;
_l4:    xor x24, x24, x24                         ;
        addi x8, zero, 1                          ;
        slli x8, x8, 29                           ;
        add x24, x24, x8                          ;
        addi x5, zero, 1                          ;
        slli x5, x5, 10                           ;
        add x24, x24, x5                          ;
        csrrs x24, sie, x24                       ;
_l5:    la x7, d_0_13                             ;
        lui x27, 0xffe00                          ;
        xor x7, x7, x27                           ;
        sw x5, -28(x7)                            ;
_l6:    la x23, d_0_10                            ;
        addi x23, x23, -0                         ;
        amoxor.d x9, x1, (x23)                    ;
_l7:    mulhu x17, x26, x28                       ;
_l8:    la x8, _l12                                       ;
        srai x8, x8, 1                            ;
        csrrw x4, pmpaddr0, x8                    ;
_l9:    bge x28, x12, _l100                                ;
_l10:   mulh x17, x13, x17                        ;
_l11:   bltu x14, x15, _l76                               ;
_l12:   la x26, _l51                                      ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l13:   fmin.s f13, f7, f7                        ;
_l14:   ecall                                     ;
_l15:   la x23, d_4_25                            ;
        lui x22, 0xffe00                          ;
        xor x23, x23, x22                         ;
        fsw f17, 28(x23)                          ;
_l16:   csrrwi x27, pmpaddr7, 0                   ;
_l17:   fsgnjn.s f21, f12, f19                    ;
_l18:   la x15, d_2_1                             ;
        sw x24, -16(x15)                          ;
_l19:   la x21, d_2_24                            ;
        addi x21, x21, 16                         ;
        amoxor.w x24, x6, (x21)                   ;
_l20:   la x7, d_2_7                              ;
        sd x29, 24(x7)                            ;
_l21:   fmadd.s f27, f14, f23, f29, rdn           ;
_l22:   la x24, d_2_24                            ;
        lh x5, 18(x24)                            ;
_l23:   csrrwi x18, medeleg, 4                    ;
_l24:   la x12, d_4_9                             ;
        sw x23, -4(x12)                           ;
_l25:   mulhu x18, x14, x16                       ;
_l26:   csrrsi x15, fcsr, 31                      ;
_l27:   la x8, d_0_1                              ;
        addi x8, x8, -16                          ;
        amomaxu.d x8, x22, (x8)                   ;
_l28:   rem x19, x0, x8                           ;
_l29:   la x3, _l81                                       ;
        ld x10, -8(x3)                            ;
_l30:   fnmsub.s f10, f25, f6, f2, rdn            ;
_l31:   la x3, d_5_3                              ;
        addi x3, x3, -16                          ;
        amomaxu.d x3, x22, (x3)                   ;
_l32:   fmv.x.w x2, f5                            ;
_l33:   la x27, d_2_0                             ;
        addi x27, x27, 16                         ;
        amomin.d x24, x9, (x27)                   ;
_l34:   feq.s x8, f31, f24                        ;
_l35:   la x12, d_2_20                            ;
        lb x20, -25(x12)                          ;
_l36:   bltu x11, x19, _l50                               ;
_l37:   fmv.w.x f28, x6                           ;
_l38:   la x9, d_1_27                             ;
        lbu x16, -5(x9)                           ;
_l39:   mul x3, x4, x6                            ;
_l40:   sraw x19, x21, x2                         ;
_l41:   divuw x19, x7, x30                        ;
_l42:   la x22, d_5_18                            ;
        fsw f20, -4(x22)                          ;
_l43:   la x2, d_0_3                              ;
        addi x2, x2, 16                           ;
        amoswap.d x10, x27, (x2)                  ;
_l44:   la x9, d_5_22                             ;
        sb x11, -28(x9)                           ;
_l45:   fnmadd.s f30, f9, f12, f21, rmm           ;
_l46:   la x18, d_2_16                            ;
        addi x18, x18, 16                         ;
        amomaxu.w x5, x3, (x18)                   ;
_l47:   la x1, d_3_26                             ;
        addi x1, x1, -24                          ;
        amoswap.d x19, x4, (x1)                   ;
_l48:   sraw x16, x30, x12                        ;
_l49:   mulw x1, x3, x19                          ;
_l50:   sraiw x11, x13, 11                        ;
_l51:   la x16, d_2_16                            ;
        addi x16, x16, -8                         ;
        sc.w x12, x18, (x16)                      ;
_l52:   xori x5, x1, 1090                         ;
_l53:   srli x23, x6, 1                           ;
_l54:   fmul.s f5, f19, f4, rne                   ;
_l55:   mulw x18, x23, x28                        ;
_l56:   lui x3, 433883                            ;
_l57:   fence.i                                   ;
_l58:   la x2, d_0_17                             ;
        addi x2, x2, -8                           ;
        lr.d x3, (x2)                             ;
_l59:   la x4, d_0_14                             ;
        addi x4, x4, 0                            ;
        amoxor.d x26, x21, (x4)                   ;
_l60:   andi x11, x13, -833                       ;
_l61:   la x14, d_2_6                             ;
        flw f0, 0(x14)                            ;
_l62:   la x27, d_3_3                             ;
        lwu x30, 8(x27)                           ;
_l63:   la x11, d_5_8                             ;
        addi x11, x11, 16                         ;
        amomaxu.d x20, x21, (x11)                 ;
_l64:   slli x26, x15, 18                         ;
_l65:   fdiv.s f16, f22, f18, rdn                 ;
_l66:   blt x21, x15, _l81                        ;
_l67:   la x6, d_2_5                              ;
        lui x8, 0xffe00                           ;
        xor x6, x6, x8                            ;
        sb x23, 30(x6)                            ;
_l68:   slliw x13, x22, 22                        ;
_l69:   la x16, d_5_3                             ;
        sd x29, -0(x16)                           ;
_l70:   srlw x8, x11, x23                         ;
_l71:   rem x2, x17, x28                          ;
_l72:   fsgnj.s f12, f3, f2                       ;
_l73:   xor x7, x7, x7                            ;
        csrrc x28, fcsr, x7                       ;
_l74:   slli x11, x20, 26                         ;
_l75:   div x30, x15, x4                          ;
_l76:   li x9, 0                                  ;
        la x17, pt1                               ;
        addi x17, x17, 16                         ;
        sfence.vma x9, x17                        ;
_l77:   la x1, d_4_17                             ;
        sd x25, -0(x1)                            ;
_l78:   la x26, _l107                                     ;
        jalr x12, 0(x26)                          ;
_l79:   fnmsub.s f21, f8, f6, f6, rmm             ;
_l80:   rem x27, x21, x18                         ;
_l81:   la x10, d_2_6                             ;
        addi x10, x10, 4                          ;
        amoxor.w x15, x10, (x10)                  ;
_l82:   mulw x6, x26, x30                         ;
_l83:   fdiv.s f22, f22, f29, dyn                 ;
_l84:   mulh x4, x26, x21                         ;
_l85:   la x16, d_3_22                            ;
        addi x16, x16, 24                         ;
        amoadd.d x30, x7, (x16)                   ;
_l86:   fmadd.s f9, f20, f0, f21, rtz             ;
_l87:   la x7, d_3_2                              ;
        addi x7, x7, 0                            ;
        lr.d x2, (x7)                             ;
_l88:   fnmsub.s f17, f11, f24, f28, rne          ;
_l89:   fcvt.s.w f21, x27, rmm                    ;
_l90:   la x29, d_0_14                            ;
        addi x29, x29, 0                          ;
        amoxor.w x7, x12, (x29)                   ;
_l91:   xori x7, x19, -11                         ;
_l92:   fnmadd.s f16, f27, f18, f4, rup           ;
_l93:   fmsub.s f17, f30, f13, f22, rtz           ;
_l94:   mulhsu x4, x1, x11                        ;
_l95:   feq.s x16, f12, f21                       ;
_l96:   fmsub.s f8, f30, f30, f9, rdn             ;
_l97:   fsub.s f6, f27, f27, dyn                  ;
_l98:   la x11, d_2_16                            ;
        addi x11, x11, 16                         ;
        sc.w x24, x18, (x11)                      ;
_l99:   fcvt.w.s x13, f28, rtz                    ;
_l100:  la x9, d_5_16                             ;
        addi x9, x9, 4                            ;
        amoadd.w x27, x11, (x9)                   ;
_l101:  la x1, d_5_6                              ;
        flw f8, 0(x1)                             ;
_l102:  la x17, d_5_22                            ;
        sd x29, 16(x17)                           ;
_l103:  ecall                                     ;
_l104:  la x21, d_1_17                            ;
        lw x5, -0(x21)                            ;
_l105:  li x20, 1                                 ;
        la x5, pt0                                ;
        addi x5, x5, 56                           ;
        sfence.vma x20, x5                        ;
_l106:  la x11, d_4_26                            ;
        addi x11, x11, 16                         ;
        lui x9, 0xffe00                           ;
        xor x11, x11, x9                          ;
        amomax.w x5, x9, (x11)                    ;
_l107:  la x1, d_5_18                             ;
        addi x1, x1, 0                            ;
        amomax.d x8, x5, (x1)                     ;
_l108:  la x3, d_3_4                              ;
        sw x4, 12(x3)                             ;
_l109:  ecall                                     ;
_l110:  la x14, _l116                                     ;
        csrrw zero, uepc, x14                     ;
        uret                                      ;
_l111:  la x7, d_0_26                             ;
        addi x7, x7, -24                          ;
        sc.d x14, x7, (x7)                        ;
_l112:  la x11, d_0_10                            ;
        sw x2, -0(x11)                            ;
_l113:  fsgnjn.s f3, f30, f14                     ;
_l114:  la x9, d_5_13                             ;
        addi x9, x9, 0                            ;
        amoxor.d x2, x17, (x9)                    ;
_l115:  la x6, d_1_15                             ;
        addi x6, x6, -24                          ;
        sc.w x15, x2, (x6)                        ;
_l116:  la x3, d_3_23                             ;
        ld x25, 8(x3)                             ;
_l117:  la x30, d_2_18                            ;
        addi x30, x30, -8                         ;
        amomax.d x8, x2, (x30)                    ;
_l118:  fsqrt.s f0, f11, rup                      ;
_l119:  la x30, d_2_3                             ;
        addi x30, x30, -0                         ;
        amomax.w x13, x2, (x30)                   ;
_l120:  ori x24, x30, -2047                       ;
_l121:  andi x30, x16, -309                       ;
_l122:  addw x23, x29, x11                        ;
_l123:  feq.s x1, f8, f26                         ;
_l124:  la x8, d_2_15                             ;
        addi x8, x8, 0                            ;
        amoand.d x15, x9, (x8)                    ;
_l125:  rem x24, x9, x1                           ;
_l126:  fsgnjx.s f2, f10, f13                     ;
_l127:  la x21, d_5_27                            ;
        addi x21, x21, -8                         ;
        lui x9, 0xffe00                           ;
        xor x21, x21, x9                          ;
        amoswap.d x27, x9, (x21)                  ;
_l128:  addi x1, x27, -362                        ;
_l129:  la x26, d_1_12                            ;
        addi x26, x26, 0                          ;
        amoxor.d x15, x30, (x26)                  ;
_l130:  flt.s x20, f6, f26                        ;
_l131:  andi x3, x21, -708                        ;
_l132:  la x28, d_5_14                            ;
        addi x28, x28, 8                          ;
        amomax.d x21, x8, (x28)                   ;
_l133:  la x12, d_4_3                             ;
        lhu x26, -30(x12)                         ;
_l134:  srlw x29, x23, x24                        ;
_l135:  subw x15, x15, x7                         ;
_l136:  fsgnj.s f8, f27, f21                      ;
_l137:  la x20, d_0_9                             ;
        lb x27, -27(x20)                          ;
_l138:  la x8, _l41                               ;
        lui x22, 0xffe00                          ;
        xor x8, x8, x22                           ;
        lwu x12, -20(x8)                          ;
_l139:  div x20, x21, x6                          ;
_l140:  fcvt.lu.s x7, f14, rdn                    ;
_l141:  slli x18, x22, 58                         ;
_l142:  fmsub.s f3, f20, f3, f11, rtz             ;
_l143:  xori x5, x13, 1368                        ;
_l144:  la x21, _l159                                     ;
        srai x21, x21, 1                          ;
        csrrc x8, pmpaddr7, x21                   ;
_l145:  beq x13, x10, _l158                               ;
_l146:  la x17, d_4_27                            ;
        addi x17, x17, 0                          ;
        amomax.w x3, x6, (x17)                    ;
_l147:  la x16, d_5_16                            ;
        sh x15, 4(x16)                            ;
_l148:  fcvt.s.l f25, x8, rtz                     ;
_l149:  fle.s x6, f25, f7                         ;
_l150:  bltu x20, x23, _l153                              ;
_l151:  ori x17, x16, 0                           ;
_l152:  la x3, d_2_2                              ;
        addi x3, x3, 12                           ;
        amoand.w x30, x21, (x3)                   ;
_l153:  slliw x3, x24, 25                         ;
_l154:  la x19, d_2_2                             ;
        addi x19, x19, -8                         ;
        amoadd.w x1, x1, (x19)                    ;
_l155:  csrrwi x25, sstatus, 11                   ;
_l156:  sraiw x6, x14, 24                         ;
_l157:  xor x20, x20, x20                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 29                         ;
        add x20, x20, x10                         ;
        addi x17, zero, 1                         ;
        slli x17, x17, 7                          ;
        add x20, x20, x17                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 27                         ;
        add x20, x20, x22                         ;
        csrrs x18, sscratch, x20                  ;
_l158:  mulhsu x25, x25, x5                       ;
_l159:  la x17, d_3_17                            ;
        addi x17, x17, -12                        ;
        amoswap.w x16, x4, (x17)                  ;
_l160:  csrrwi x16, medeleg, 1                    ;
_l161:  srlw x7, x30, x9                          ;
_l162:  subw x5, x21, x14                         ;
_l163:  la x26, d_4_23                            ;
        addi x26, x26, -8                         ;
        amoxor.w x25, x13, (x26)                  ;
_l164:  fadd.s f1, f7, f6, rup                    ;
_l165:  la x19, d_1_25                            ;
        addi x19, x19, -8                         ;
        amoand.d x15, x5, (x19)                   ;
_l166:  fcvt.wu.s x13, f17, rne                   ;
_l167:  fence.i                                   ;
_l168:  la x16, d_5_10                            ;
        addi x16, x16, -16                        ;
        amoand.d x3, x1, (x16)                    ;
_l169:  fcvt.wu.s x2, f5, rup                     ;
_l170:  fmv.w.x f2, x15                           ;
_l171:  fence                                     ;
_l172:  mulhu x22, x18, x20                       ;
_l173:  bne x19, x7, _l182                                ;
_l174:  srai x22, x9, 0                           ;
_l175:  beq x28, x12, _l176                               ;
_l176:  lui x12, 447092                           ;
_l177:  la x20, d_3_24                            ;
        sd x6, -24(x20)                           ;
_l178:  la x12, d_4_1                             ;
        lui x10, 0xffe00                          ;
        xor x12, x12, x10                         ;
        lhu x27, -8(x12)                          ;
_l179:  la x9, d_0_20                             ;
        addi x9, x9, 16                           ;
        amoswap.d x8, x5, (x9)                    ;
_l180:  flt.s x13, f5, f9                         ;
_l181:  la x14, d_1_27                            ;
        addi x14, x14, -24                        ;
        amomin.w x8, x23, (x14)                   ;
_l182:  fsub.s f19, f6, f18, dyn                  ;
_l183:;
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
                .dword 0xe028e5ba8bf4e36f, 0x6ed2a5b46ca88646
                .dword 0x8767b8bb34bd0a22, 0xd9cd163ca2cdaff8
d_0_0:          .dword 0x482a4037dcd45d41, 0x70c2b151bce75d2d
d_0_1:          .dword 0x122e0577e5b516a2, 0x8066892bff35a51e
d_0_2:          .dword 0x0bebaf6c88ab802b, 0x95fcbe6cf388b297
d_0_3:          .dword 0xd522ae826bac5e9f, 0xb38ec1a251485d01
d_0_4:          .dword 0xd5010dd7b3250895, 0x528640a30edd0301
d_0_5:          .dword 0x7b25b5ed6ec32bab, 0x338b36af809ba149
d_0_6:          .dword 0x74b0d98f94f26cb2, 0x91a029b2135c396f
d_0_7:          .dword 0xfcc3a555f1be3ed7, 0x092ebc8d92a4d56a
d_0_8:          .dword 0xc79348eb49fced46, 0x16d2ba3dc508fb89
d_0_9:          .dword 0x2b79a4418384bcf9, 0x8ebd30a0b07cfd71
d_0_10:         .dword 0xaebdd4dee6933a9d, 0xa2521208a99bad37
d_0_11:         .dword 0xb45e28819aa216b4, 0x671433a326303858
d_0_12:         .dword 0x614793d8ae350be4, 0xe174904556272615
d_0_13:         .dword 0xc541bc1620f59a02, 0xaa4db1ea59f608c0
d_0_14:         .dword 0xf10189a6aad2e443, 0x169abd3fbe560239
d_0_15:         .dword 0x0817944fbb1f85c8, 0xe0f65e1371c26853
d_0_16:         .dword 0x6c78f097bca11253, 0xa8fd9776c28bf8a7
d_0_17:         .dword 0x728806ea3ddc767c, 0xc5c8b2a90155d82b
d_0_18:         .dword 0xea981f38d42722c5, 0xeec7e5b65a29a2c2
d_0_19:         .dword 0xd83bd09f196fcb53, 0x4683c3feb74a4ae2
d_0_20:         .dword 0x78a4d63032a21024, 0x2dd90583e714293d
d_0_21:         .dword 0x902e0d9b0833679a, 0x6316943cf1b8287a
d_0_22:         .dword 0x4f08e9e4bacb4762, 0xaa49ffa5a11fdf9e
d_0_23:         .dword 0xbf962d9ef3af6d33, 0x66c45b678a11cd80
d_0_24:         .dword 0x158f8c1a909ef116, 0xa5f013dfd4b8f0ad
d_0_25:         .dword 0xc5ddecf4fc5bfca2, 0xe93a0d85a6cca99c
d_0_26:         .dword 0xe669b77f8b67297b, 0x0aef54e4938ea6a0
d_0_27:         .dword 0x62df10ecb6c40e26, 0xf17763a10a449b47
                .dword 0xa5cace9216f0c2fb, 0xa3ac5116c16519e5
                .dword 0x3e7f9c1ca9dc0fe2, 0x6ee1f7ad09087244
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x627e666172121b41, 0x1bf6b67896675548
                .dword 0xef1a368cfe1755d1, 0xfcc82b9e10a4f28b
d_1_0:          .dword 0x4e80d1b149e584ce, 0x9d7c6a542e4a15d8
d_1_1:          .dword 0x115cb66ae390da88, 0xe3d00edb489c7360
d_1_2:          .dword 0x6a8feb5da872c497, 0x062ebd228b0b0501
d_1_3:          .dword 0x015c8d547f8a54b1, 0x36ab00261d83f0c5
d_1_4:          .dword 0x101c71a8851f924d, 0xd804c3a7883f7cf0
d_1_5:          .dword 0x0c11f62795562363, 0x780d926ee07bbecd
d_1_6:          .dword 0xfd65607e4e97e7cb, 0x738c90e85c8ec532
d_1_7:          .dword 0x44980ea0574e74a8, 0x733c963d5641b254
d_1_8:          .dword 0x679917a30ac84be2, 0xf2126945283951ee
d_1_9:          .dword 0xbbedb1f975f477fc, 0xba8bf07acb3ce458
d_1_10:         .dword 0x3bd689597afd516f, 0xa3d58211bf4a8f11
d_1_11:         .dword 0x5eab2986fafa570a, 0x7742bfdf9f217de1
d_1_12:         .dword 0xe219d944af0582f6, 0xf641cae022e4a7f3
d_1_13:         .dword 0x0a32b0cf4e02f388, 0x9f221ead11eee8c1
d_1_14:         .dword 0x8c1f595092ed4f26, 0xf0a6332cdf216608
d_1_15:         .dword 0xcb571a13897657ca, 0x5c4ede745a5f2a98
d_1_16:         .dword 0x74418ff3bd2283d3, 0x24d7ff14a62b4385
d_1_17:         .dword 0x827ac8256cd7fc0d, 0xd172d4151b2889f8
d_1_18:         .dword 0xa215867f9a1bb4bd, 0x2e35a7c4c7281c0c
d_1_19:         .dword 0xb37d31b50fb844c9, 0x47b93bced8ff935b
d_1_20:         .dword 0x0b0becf9936bdfa3, 0x4d5c09853369ff9c
d_1_21:         .dword 0x9c3d84cc22841176, 0xa80ed6690269f674
d_1_22:         .dword 0x605c4f79af1467da, 0x534ff9d88fc71fa7
d_1_23:         .dword 0x07ca4567a52554c7, 0xafce7d34800dc6ff
d_1_24:         .dword 0xce73aa6941ec0c11, 0xb11e1a5f18043b23
d_1_25:         .dword 0xc32f5d1f1f22dc8e, 0x483f1644d6716254
d_1_26:         .dword 0xe2825de091375865, 0xd39f56a45c833e93
d_1_27:         .dword 0x646556d8ac116f7d, 0x0026de855d335478
                .dword 0xd1c5d9b2c73332ee, 0x2ddf6de29d731ada
                .dword 0x31862ebda3df634a, 0xa82ba11b4c46795a
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xa7a89b06af7b0488, 0xe1f14d3bfc1444f0
                .dword 0xb19136ce321ecb44, 0x298cf00527607b2c
d_2_0:          .dword 0x5d20adce08332d82, 0xaad48f1fb947630f
d_2_1:          .dword 0x6cd1d5ad24937801, 0xba6b0e2e88aae36b
d_2_2:          .dword 0x1ee950e407c0fe28, 0xb7bb0aa89f4d9d8d
d_2_3:          .dword 0x10bd06666f92f2aa, 0xafcf617f897cf07c
d_2_4:          .dword 0xdc9da5c4f4c4f0db, 0x6109be1c1d1521b7
d_2_5:          .dword 0x5e580703604a0b22, 0x8b71245abb0c123f
d_2_6:          .dword 0x0ea696493b05a92e, 0xcebd717e8ae6172a
d_2_7:          .dword 0xb3aa135dadfcd6ba, 0xd434ede5fe9aab1e
d_2_8:          .dword 0x93b0218f8d61cdee, 0x5da25aeeebc36566
d_2_9:          .dword 0x03819b5d2df376f2, 0x2baeef7544c11b6d
d_2_10:         .dword 0xc5606c92ffaaa119, 0x106fc9015bce8354
d_2_11:         .dword 0x2ba6eb84f7c0ed12, 0x6774181097336597
d_2_12:         .dword 0x4747cff1e20e52d3, 0x36c8a68a667a5aa4
d_2_13:         .dword 0xdba2b9a7ed650b1c, 0x142421fffa84ef5d
d_2_14:         .dword 0xd16a116d7c3d4e0b, 0x9300248fae1c4e73
d_2_15:         .dword 0x9b94461a75a53fef, 0xfb99a52658c651ec
d_2_16:         .dword 0x727429a592f90b43, 0xa818c010ce5059ef
d_2_17:         .dword 0xd8711c5ae15d54f8, 0xec4976c211adb5e0
d_2_18:         .dword 0x94288b74978e3f11, 0x1c9b05e30298c48d
d_2_19:         .dword 0xd8846b6f7bb6bc1c, 0x295a42e3703f2480
d_2_20:         .dword 0xc5e8da519249bd54, 0x095375c654d1cc04
d_2_21:         .dword 0xb4328b7901caea71, 0x0b1d58c02af05e56
d_2_22:         .dword 0xe56504e95f373497, 0xf88afcd5a5fdbff4
d_2_23:         .dword 0x1464644fbf35a11b, 0xad7af4a67963ea53
d_2_24:         .dword 0x2be1534979d85148, 0xbb02988375bf031e
d_2_25:         .dword 0xc2409728e64b73de, 0x47a3f553da27c052
d_2_26:         .dword 0x2a3c99a703613765, 0x3ae169ae7bd49c65
d_2_27:         .dword 0x7c4eb08edadd56f3, 0x8d976fd7cf86727f
                .dword 0xcd11151be3ea005b, 0xcd24ab3357cc395e
                .dword 0xc2e91e8942b705cb, 0x7d92f416fb5e1308
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc549f61333b62efc, 0x1755a092830fcf38
                .dword 0x1aff161e10dccf8c, 0xd2b12d6103e268ef
d_3_0:          .dword 0xef96affc96d4682c, 0x1162bea2c44922cf
d_3_1:          .dword 0x45335cb5132e5446, 0xab2c0f7326a1875c
d_3_2:          .dword 0x2545a1df2844629f, 0xb76e45959afb86b6
d_3_3:          .dword 0x8a840099eb1d769c, 0xe99e3df92426800c
d_3_4:          .dword 0xd8f402da6dbb5efc, 0x797bb9e41043263c
d_3_5:          .dword 0x8c767d2681e27009, 0xa252eff4bbed7a7c
d_3_6:          .dword 0x73c63926393ed099, 0x98d08504a58924f4
d_3_7:          .dword 0x1de11a01da2b0ef1, 0x1cdad3b4389c2d95
d_3_8:          .dword 0x5159e55d907101eb, 0x0fc395f80502b3cb
d_3_9:          .dword 0xbb104b66c5561baa, 0xa2031c7ad12bf317
d_3_10:         .dword 0x8d48cb42ece56790, 0xfcdb4eac821c6cc2
d_3_11:         .dword 0x01780ae0bcd814f5, 0x8f105aefa58295ab
d_3_12:         .dword 0x9e20d035b1cb4921, 0x9716ebde158765e2
d_3_13:         .dword 0x31b5b6e4419219a4, 0x77c5fe1309734c88
d_3_14:         .dword 0xbb162dc102896cf3, 0xe13ef46e16b94c31
d_3_15:         .dword 0x3b79e5da4ea21058, 0x5807905ffc4bb6c0
d_3_16:         .dword 0x3516a4c894e82457, 0xe683512dda95409f
d_3_17:         .dword 0xf23b5e3312a68d71, 0xb4f35f640e289418
d_3_18:         .dword 0xc15d1a8cbf69d71c, 0xb4861d1bda44201d
d_3_19:         .dword 0x01a8e3f1f58cc409, 0xedeceacd9a60aa88
d_3_20:         .dword 0xfc3fedd29486f16c, 0xe1708ab5cc5c610c
d_3_21:         .dword 0xb9f762b92af2cb88, 0xb537e9f8b22ce5b1
d_3_22:         .dword 0x6c03ad633a16b441, 0xd591e0202102680f
d_3_23:         .dword 0x0d160409eb051b08, 0xa47e56a192c851ef
d_3_24:         .dword 0x40ed0380d9e161f4, 0x37d77d12e1ee9e78
d_3_25:         .dword 0x40d209558780b437, 0xea1fa1f064b82e8a
d_3_26:         .dword 0x30c3ad8ed855785e, 0x6b76f56a42e90309
d_3_27:         .dword 0xb61ef6d8c1a9dfe1, 0xb67d21f04c3bf042
                .dword 0x3925678661ccc6d1, 0x53580ccef1d2b733
                .dword 0x2b943f996bfc691f, 0xf9d10bcbcab841a1
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x1652d7ffff328216, 0x95f3823de955c852
                .dword 0x91dbd92a83b3efbd, 0xa47caf68181cbf7b
d_4_0:          .dword 0xd642f55c3d391fe3, 0x1ffc8c4f3872a0ec
d_4_1:          .dword 0x50c1a4f5911f31b6, 0x68372fdede892614
d_4_2:          .dword 0xe3c008d362afc54b, 0xc93f0ebcbf2328c7
d_4_3:          .dword 0x082589524f6fe72c, 0x610c8f494ffbb7c7
d_4_4:          .dword 0x3ccde61be76f5e36, 0x4b8d103bd5a13b97
d_4_5:          .dword 0xc204897ad8045fef, 0xa0986610bb1d326c
d_4_6:          .dword 0x3e093f1c753ec82e, 0xd6fd8a2839ce34d3
d_4_7:          .dword 0xfc9fa485be9f3ca1, 0x88fa77eb34dab43d
d_4_8:          .dword 0xa2def6de869d22e7, 0x4c7dfa4108d92e51
d_4_9:          .dword 0x41d674df59137e58, 0x547373c33aa169a4
d_4_10:         .dword 0x692a142c8ed5fc69, 0x1b1b1d132994e900
d_4_11:         .dword 0xd8fbc632ef736d6c, 0x69703cc9bc154546
d_4_12:         .dword 0x1efb36c7b0d30526, 0xa40b0510c0e05c36
d_4_13:         .dword 0xa7c0e705f9983939, 0x1adc38d0313d246a
d_4_14:         .dword 0x7cffd3a905f31ee7, 0x6c1d1049b13e69f7
d_4_15:         .dword 0x83933d8b3057ebbb, 0xef0301cdec23e884
d_4_16:         .dword 0xf99e3d17fcbcd8d4, 0xfb63abdc306fcc33
d_4_17:         .dword 0x61e963819609e10d, 0x18736af18390f058
d_4_18:         .dword 0x8b140a99c1f42b2d, 0xcb2f10f09535521c
d_4_19:         .dword 0x180fad1bdf2a4855, 0x6a636c9633d7871e
d_4_20:         .dword 0x56a43d81a4a84a57, 0xc9c9bf341804b9a8
d_4_21:         .dword 0xb2ee12c0326d24cc, 0xa341f728095643f4
d_4_22:         .dword 0xc26431fcf3488cf6, 0x0e53ea436d44aedf
d_4_23:         .dword 0x98b08c078246838a, 0xc1ce5a6f10a5861b
d_4_24:         .dword 0x415be38f820bc7e5, 0xc01d706211e2be77
d_4_25:         .dword 0x10c88a473ea0961d, 0x89f46b0877b05e41
d_4_26:         .dword 0x8cfd45f28df4166e, 0x5bb833bb61fb60a2
d_4_27:         .dword 0xbce26d07059f63b9, 0x75364d04078c20d0
                .dword 0x7bd63aa2e937732c, 0xe0637570f3431f7a
                .dword 0xa2dcf6b40996585f, 0x6303e6053d3f74aa
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf4d6b544092e268e, 0x5d46fc5a049eb2e6
                .dword 0xae1e3e2e3cf885ca, 0x4cf9bc50d03f1ad7
d_5_0:          .dword 0xa2cfe2e358017a90, 0xce7be4d259e3cfd3
d_5_1:          .dword 0x9889908fda28f4fa, 0x939b7dfaa3a4a53b
d_5_2:          .dword 0x80e41df7a160a49d, 0xd972df5050590429
d_5_3:          .dword 0x8efd2434345b458a, 0x5f7451cfa5f74095
d_5_4:          .dword 0xd90d3cb7a1b51dad, 0x8f515647c0fd8ab5
d_5_5:          .dword 0x746fda44ac2e9e89, 0xbc1f6ca40029fa5c
d_5_6:          .dword 0xe5bb3701c8f44a4d, 0x0e518fd2c559a3b1
d_5_7:          .dword 0xa9194deeea54853c, 0x50f2da2a2a2b1d25
d_5_8:          .dword 0xfcf774fca54ccb20, 0xffba203e9e91071c
d_5_9:          .dword 0x6ea04dfbd9c0d628, 0xeed1d60aebf0d9bd
d_5_10:         .dword 0xb98472f938b15378, 0x4f053e3e6191d75b
d_5_11:         .dword 0x57c7d9694418bf8f, 0xbe862b09172db1c6
d_5_12:         .dword 0xb971b36a52f4f2ab, 0x24c4b37e19acb205
d_5_13:         .dword 0xecb555ffff6e1597, 0x41ca425a37f70c41
d_5_14:         .dword 0xe34d6be784a74985, 0x14331669088e778e
d_5_15:         .dword 0xc847556d0676d88a, 0x65983a2de1c40ce4
d_5_16:         .dword 0x4e8013294ba9a81c, 0x2cba74d9b69a0127
d_5_17:         .dword 0x5c53e1185465fe8f, 0x90469e9086de9265
d_5_18:         .dword 0x499acfd819cd22d4, 0x6afc31de73304610
d_5_19:         .dword 0xfb77dbbfcc0d62d8, 0x41a0a8475fc8a273
d_5_20:         .dword 0xcb73997621ecda31, 0xd58fcf9f5ff080cb
d_5_21:         .dword 0xed3e18a2290cf4e8, 0x35cf92d6a5974604
d_5_22:         .dword 0xec3d60f1ab4e15f7, 0x2ff29de99c420e9d
d_5_23:         .dword 0x9cd8cc8c3c21146a, 0xa6794794145b6bfc
d_5_24:         .dword 0x1ee9ec734636f18f, 0xc4259a9ae7f5e57d
d_5_25:         .dword 0xec429a3a09213a22, 0x88ec6728b961809a
d_5_26:         .dword 0x89d8fc9dbacf7327, 0xa06a28cc54f7c8da
d_5_27:         .dword 0xf3e538954b97e2a8, 0xf1f5805833bd9938
                .dword 0x53d5212ac826680d, 0xe22fd129704f030f
                .dword 0x1f2c5e60c8765bbe, 0x47d6f0bb4dc2e4da
         /* Random data */
_end_data5:
              
                 
