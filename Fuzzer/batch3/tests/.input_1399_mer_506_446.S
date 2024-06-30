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
_s0:    slti x23, x11, 2047                       ;
_s1:    fnmadd.s f8, f29, f15, f15, rmm           ;
_s2:    mul x18, x15, x5                          ;
_s3:    ebreak                                    ;
_s4:    blt x29, x18, _s5                                 ;
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
_p0:    la x13, d_2_9                             ;
        srai x13, x13, 1                          ;
        csrrs x14, pmpaddr1, x13                  ;
_p1:    csrrwi x13, pmpaddr5, 0                   ;
_p2:    la x13, d_3_3                             ;
        srai x13, x13, 1                          ;
        csrrc x11, pmpaddr1, x13                  ;
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
_l0:    subw x11, x22, x5                         ;
_l1:    fcvt.s.wu f6, x16, dyn                    ;
_l2:    ecall                                     ;
_l3:    srliw x0, x17, 11                         ;
_l4:    bltu x24, x4, _l167                                ;
_l5:    la x13, _l53                                      ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l6:    andi x21, x29, 1339                       ;
_l7:    la x16, d_4_3                             ;
        addi x16, x16, -0                         ;
        amomin.w x11, x5, (x16)                   ;
_l8:    la x24, _l134                                      ;
        lhu x29, -26(x24)                         ;
_l9:    fadd.s f18, f11, f31, rmm                 ;
_l10:   la x25, d_3_10                            ;
        addi x25, x25, -0                         ;
        amoadd.d x18, x6, (x25)                   ;
_l11:   csrrci x11, pmpaddr3, 22                  ;
_l12:   fcvt.s.w f1, x19, dyn                     ;
_l13:   la x5, d_5_26                             ;
        lui x1, 0xffe00                           ;
        xor x5, x5, x1                            ;
        ld x5, 24(x5)                             ;
_l14:   fsgnjx.s f6, f6, f6                       ;
_l15:   la x4, d_4_16                             ;
        addi x4, x4, 24                           ;
        amoxor.d x3, x27, (x4)                    ;
_l16:   la x22, d_2_22                            ;
        addi x22, x22, 8                          ;
        amoxor.d x21, x2, (x22)                   ;
_l17:   mulh x24, x7, x2                          ;
_l18:   div x30, x3, x27                          ;
_l19:   la x9, d_5_5                              ;
        addi x9, x9, -16                          ;
        sc.d x13, x9, (x9)                        ;
_l20:   la x23, d_5_15                            ;
        lui x29, 0xffe00                          ;
        xor x23, x23, x29                         ;
        lw x16, -0(x23)                           ;
_l21:   slti x30, x23, -0                         ;
_l22:   srai x22, x28, 47                         ;
_l23:   mulw x10, x3, x5                          ;
_l24:   bne x2, x20, _l80                                 ;
_l25:   la x5, d_2_27                             ;
        addi x5, x5, -8                           ;
        amoand.d x23, x9, (x5)                    ;
_l26:   bltu x10, x8, _l47                        ;
_l27:   sraw x0, x29, x14                         ;
_l28:   la x12, d_3_10                            ;
        flw f12, 4(x12)                           ;
_l29:   auipc x21, 504868                         ;
_l30:   fnmsub.s f26, f15, f26, f15, rdn          ;
_l31:   addiw x22, x12, 280                       ;
_l32:   la x5, d_4_22                             ;
        lb x23, -31(x5)                           ;
_l33:   la x12, d_1_5                             ;
        sh x29, 0(x12)                            ;
_l34:   csrrwi x14, mip, 27                       ;
_l35:   bgeu x26, x10, _l127                              ;
_l36:   fnmadd.s f2, f9, f26, f9, rdn             ;
_l37:   xor x6, x6, x6                            ;
        addi x3, zero, 3                          ;
        slli x3, x3, 21                           ;
        add x6, x6, x3                            ;
        csrrs x9, mie, x6                         ;
_l38:   la x10, d_1_15                            ;
        addi x10, x10, 24                         ;
        amomin.d x4, x5, (x10)                    ;
_l39:   blt x16, x18, _l81                                ;
_l40:   la x7, d_1_12                             ;
        sw x4, 8(x7)                              ;
_l41:   la x10, d_3_4                             ;
        addi x10, x10, -12                        ;
        amoxor.w x3, x4, (x10)                    ;
_l42:   la x23, d_5_15                            ;
        addi x23, x23, 8                          ;
        amoand.d x28, x6, (x23)                   ;
_l43:   fadd.s f27, f2, f10, rdn                  ;
_l44:   fmul.s f16, f9, f27, rtz                  ;
_l45:   fnmadd.s f0, f19, f0, f31, rtz            ;
_l46:   fcvt.s.l f4, x17, dyn                     ;
_l47:   mulhsu x14, x19, x24                      ;
_l48:   fmin.s f20, f15, f19                      ;
_l49:   xori x25, x12, -14                        ;
_l50:   divw x13, x28, x0                         ;
_l51:   csrrsi x25, frm, 0                        ;
_l52:   fmadd.s f15, f10, f13, f27, rne           ;
_l53:   la x17, d_5_8                             ;
        addi x17, x17, 0                          ;
        amoxor.d x16, x26, (x17)                  ;
_l54:   ori x19, x2, -386                         ;
_l55:   sltiu x26, x23, 0                         ;
_l56:   la x5, d_0_22                             ;
        addi x5, x5, -12                          ;
        amominu.w x6, x6, (x5)                    ;
_l57:   srli x25, x30, 26                         ;
_l58:   fsqrt.s f28, f13, rne                     ;
_l59:   mulw x13, x9, x15                         ;
_l60:   la x9, d_3_16                             ;
        lb x23, 0(x9)                             ;
_l61:   ori x30, x2, -1901                        ;
_l62:   beq x2, x21, _l96                                 ;
_l63:   fsqrt.s f7, f25, dyn                      ;
_l64:   la x27, d_1_5                             ;
        addi x27, x27, -24                        ;
        amoxor.d x28, x9, (x27)                   ;
_l65:   la x15, d_1_20                            ;
        addi x15, x15, -4                         ;
        sc.w x10, x5, (x15)                       ;
_l66:   la x24, _l154                                     ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l67:   divuw x15, x8, x27                        ;
_l68:   la x4, d_1_2                              ;
        addi x4, x4, 0                            ;
        amoor.w x25, x26, (x4)                    ;
_l69:   addiw x27, x21, 3                         ;
_l70:   fsub.s f18, f26, f6, rne                  ;
_l71:   la x18, d_1_6                             ;
        lbu x26, 10(x18)                          ;
_l72:   bltu x18, x1, _l171                               ;
_l73:   blt x21, x28, _l171                       ;
_l74:   sllw x21, x3, x16                         ;
_l75:   slliw x21, x27, 31                        ;
_l76:   blt x26, x28, _l145                               ;
_l77:   mulhsu x2, x0, x27                        ;
_l78:   srliw x16, x19, 26                        ;
_l79:   fmax.s f15, f4, f16                       ;
_l80:   la x25, d_0_7                             ;
        sd x8, -8(x25)                            ;
_l81:   la x19, d_0_8                             ;
        addi x19, x19, 16                         ;
        amominu.d x3, x18, (x19)                  ;
_l82:   mul x19, x29, x11                         ;
_l83:   mulh x30, x6, x16                         ;
_l84:   rem x12, x5, x15                          ;
_l85:   la x30, d_3_18                            ;
        fsw f18, -8(x30)                          ;
_l86:   la x19, d_3_20                            ;
        addi x19, x19, -8                         ;
        amoswap.w x22, x26, (x19)                 ;
_l87:   bge x27, x5, _l129                                ;
_l88:   csrrsi x20, mscratch, 31                  ;
_l89:   la x9, d_2_2                              ;
        addi x9, x9, 16                           ;
        amoadd.d x26, x18, (x9)                   ;
_l90:   la x12, d_0_23                            ;
        addi x12, x12, 8                          ;
        amoxor.d x15, x29, (x12)                  ;
_l91:   sltiu x3, x13, -1923                      ;
_l92:   la x10, d_4_14                            ;
        sh x7, -20(x10)                           ;
_l93:   sraw x14, x19, x17                        ;
_l94:   la x2, d_1_20                             ;
        addi x2, x2, -0                           ;
        amomin.w x29, x20, (x2)                   ;
_l95:   mulhsu x19, x23, x3                       ;
_l96:   la x2, d_1_12                             ;
        lw x29, -16(x2)                           ;
_l97:   divw x22, x9, x29                         ;
_l98:   auipc x0, 0                               ;
_l99:   fcvt.s.w f25, x24, rtz                    ;
_l100:  xor x25, x25, x25                         ;
        addi x30, zero, 1                         ;
        slli x30, x30, 12                         ;
        add x25, x25, x30                         ;
        csrrc x9, fflags, x25                     ;
_l101:  la x5, d_1_17                             ;
        ld x5, -16(x5)                            ;
_l102:  la x2, d_0_16                             ;
        addi x2, x2, -16                          ;
        amoor.w x14, x24, (x2)                    ;
_l103:  fcvt.s.lu f12, x4, rne                    ;
_l104:  andi x1, x10, 1768                        ;
_l105:  la x21, d_2_4                             ;
        sw x24, 20(x21)                           ;
_l106:  fsgnjx.s f22, f23, f25                    ;
_l107:  la x30, d_3_7                             ;
        lhu x7, 24(x30)                           ;
_l108:  divu x11, x5, x8                          ;
_l109:  la x15, d_1_24                            ;
        lh x6, -6(x15)                            ;
_l110:  fsub.s f20, f16, f4, rdn                  ;
_l111:  la x22, d_3_11                            ;
        addi x22, x22, -8                         ;
        amoswap.d x25, x14, (x22)                 ;
_l112:  la x8, d_4_21                             ;
        lhu x7, -2(x8)                            ;
_l113:  srliw x4, x30, 0                          ;
_l114:  sraw x7, x20, x2                          ;
_l115:  fsgnj.s f22, f10, f1                      ;
_l116:  csrrci x25, pmpaddr1, 2                   ;
_l117:  fcvt.w.s x2, f6, rtz                      ;
_l118:  fmv.x.w x2, f27                           ;
_l119:  fsqrt.s f4, f0, rtz                       ;
_l120:  slliw x13, x28, 8                         ;
_l121:  la x22, d_1_23                            ;
        addi x22, x22, 24                         ;
        amoand.d x13, x14, (x22)                  ;
_l122:  xor x8, x8, x8                            ;
        addi x30, zero, 1                         ;
        slli x30, x30, 25                         ;
        add x8, x8, x30                           ;
        csrrc x30, sstatus, x8                    ;
_l123:  ecall                                     ;
_l124:  la x1, d_0_20                             ;
        addi x1, x1, -4                           ;
        sc.w x1, x30, (x1)                        ;
_l125:  la x25, d_1_21                            ;
        srai x25, x25, 1                          ;
        csrrc x9, pmpaddr3, x25                   ;
_l126:  fadd.s f31, f26, f26, rtz                 ;
_l127:  mulw x0, x9, x27                          ;
_l128:  la x27, d_2_11                            ;
        srai x27, x27, 1                          ;
        csrrw x10, pmpaddr3, x27                  ;
_l129:  fence                                     ;
_l130:  la x21, d_0_20                            ;
        ld x5, -16(x21)                           ;
_l131:  la x8, _l179                                      ;
        csrrw zero, sepc, x8                      ;
        sret                                      ;
_l132:  addw x22, x5, x6                          ;
_l133:  fsqrt.s f28, f2, rmm                      ;
_l134:  la x16, d_1_25                            ;
        addi x16, x16, 28                         ;
        amoadd.w x25, x21, (x16)                  ;
_l135:  fmsub.s f1, f28, f7, f28, rne             ;
_l136:  fmax.s f21, f7, f11                       ;
_l137:  la x20, d_1_12                            ;
        addi x20, x20, -16                        ;
        amoand.d x17, x20, (x20)                  ;
_l138:  bge x10, x13, _l153                               ;
_l139:  fmin.s f21, f7, f9                        ;
_l140:  beq x3, x12, _l151                        ;
_l141:  sraw x2, x4, x15                          ;
_l142:  la x26, d_2_10                            ;
        addi x26, x26, -8                         ;
        amoswap.d x19, x12, (x26)                 ;
_l143:  fmadd.s f18, f8, f20, f12, dyn            ;
_l144:  fcvt.wu.s x20, f2, dyn                    ;
_l145:  fcvt.s.w f6, x1, rne                      ;
_l146:  la x1, d_4_13                             ;
        addi x1, x1, -8                           ;
        amoxor.w x1, x9, (x1)                     ;
_l147:  divw x22, x15, x8                         ;
_l148:  divw x22, x21, x21                        ;
_l149:  la x21, d_5_2                             ;
        addi x21, x21, -28                        ;
        amoswap.w x8, x27, (x21)                  ;
_l150:  la x20, d_2_27                            ;
        addi x20, x20, 24                         ;
        lui x25, 0xffe00                          ;
        xor x20, x20, x25                         ;
        amoxor.d x28, x25, (x20)                  ;
_l151:  fcvt.lu.s x2, f27, rne                    ;
_l152:  la x4, d_5_10                             ;
        addi x4, x4, -24                          ;
        amoadd.d x12, x29, (x4)                   ;
_l153:  divuw x22, x4, x19                        ;
_l154:  la x30, d_2_15                            ;
        addi x30, x30, 16                         ;
        amomaxu.d x18, x21, (x30)                 ;
_l155:  la x24, d_4_9                             ;
        addi x24, x24, -0                         ;
        amoadd.w x18, x28, (x24)                  ;
_l156:  fmadd.s f2, f23, f21, f0, rtz             ;
_l157:  fsgnjx.s f20, f1, f23                     ;
_l158:  mulh x8, x17, x24                         ;
_l159:  la x26, d_4_25                            ;
        addi x26, x26, 24                         ;
        amoxor.w x29, x8, (x26)                   ;
_l160:  fcvt.s.w f26, x14, rup                    ;
_l161:  ori x21, x9, -1410                        ;
_l162:  sraiw x4, x14, 28                         ;
_l163:  sltiu x22, x22, 149                       ;
_l164:  li x18, 0                                 ;
        la x25, pt3                               ;
        addi x25, x25, 40                         ;
        sfence.vma x18, x25                       ;
_l165:  divuw x8, x14, x7                         ;
_l166:  mulhsu x8, x10, x6                        ;
_l167:  remuw x19, x16, x17                       ;
_l168:  mulhu x6, x13, x15                        ;
_l169:  fcvt.wu.s x9, f26, rtz                    ;
_l170:  fadd.s f6, f25, f26, rmm                  ;
_l171:  la x2, d_1_13                             ;
        addi x2, x2, 8                            ;
        amomax.d x29, x4, (x2)                    ;
_l172:  la x8, d_1_4                              ;
        addi x8, x8, -0                           ;
        amomax.d x6, x23, (x8)                    ;
_l173:  subw x15, x16, x0                         ;
_l174:  jal x17, _l183                                    ;
_l175:  la x1, d_3_0                              ;
        addi x1, x1, -28                          ;
        amoxor.w x11, x4, (x1)                    ;
_l176:  la x15, d_5_12                            ;
        addi x15, x15, 12                         ;
        amomax.w x15, x13, (x15)                  ;
_l177:  ori x11, x26, 1910                        ;
_l178:  la x20, d_4_12                            ;
        lui x15, 0xffe00                          ;
        xor x20, x20, x15                         ;
        sw x16, -28(x20)                          ;
_l179:  fcvt.s.l f23, x7, rne                     ;
_l180:  la x5, _l183                                      ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l181:  fcvt.s.l f21, x26, rtz                    ;
_l182:  fence                                     ;
_l183:  fadd.s f23, f13, f11, rdn                 ;
_l184:  xor x18, x18, x18                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 14                           ;
        add x18, x18, x2                          ;
        addi x16, zero, 1                         ;
        slli x16, x16, 28                         ;
        add x18, x18, x16                         ;
        csrrs x11, mtval, x18                     ;
_l185:  fle.s x21, f30, f6                        ;
_l186:  fcvt.s.wu f4, x3, rup                     ;
_l187:;
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
                .dword 0x1254ce8b221903ee, 0xffa4cbad2770a441
                .dword 0x5a2e7f8bb41c4c60, 0xbabce30cf8ee9ebf
d_0_0:          .dword 0xd3f35c83e1fcb7d7, 0x393237a1f3597624
d_0_1:          .dword 0x249dc940297690b2, 0x46cfc3ffefe535f3
d_0_2:          .dword 0xbed1d1bace942606, 0x1b442ebea18a351c
d_0_3:          .dword 0x2f1985b0eead2fe6, 0x8fc91d6857df86b1
d_0_4:          .dword 0x4fd7d9498b17c587, 0x0f9b1f1a446e4e35
d_0_5:          .dword 0x068f76546ce28fe3, 0x40a35cde88689ad3
d_0_6:          .dword 0x1c1c37cdb75276c2, 0x2328349591c5a735
d_0_7:          .dword 0xf85d0e7f446635c4, 0x4255d80d5d44007a
d_0_8:          .dword 0xb208c6bacb38b7e9, 0x15bd7995887ca69f
d_0_9:          .dword 0xe00d32e5b943e497, 0xd9b8bb545941021d
d_0_10:         .dword 0x59c939c714dd9382, 0x87980c4ede6ad643
d_0_11:         .dword 0x28fc14737fdf7d68, 0x7449c9b8626522c4
d_0_12:         .dword 0xd066f2b315ad0645, 0x9fc03f96865857f2
d_0_13:         .dword 0x5269eabb430e7ad5, 0x31361f8eb21c8865
d_0_14:         .dword 0xb0e4abf46734d2d4, 0x283e3df1ebbaf447
d_0_15:         .dword 0x3eb7aa8310a23424, 0xc5e0bc55f02137a4
d_0_16:         .dword 0x2279555c74f4764d, 0xafd071e10f46cd38
d_0_17:         .dword 0x1f48b4a2d47e4e73, 0x59a1a1269c962ef7
d_0_18:         .dword 0x66a8e081431a9ab2, 0xe5f44a7fe6256907
d_0_19:         .dword 0x5ec7801149b3c3ba, 0xdbe160c429437a3e
d_0_20:         .dword 0x80ea57447e1af3cb, 0x4f63c98521fef321
d_0_21:         .dword 0x4e9f1b1fa65e9fe2, 0x52929f2b4153d063
d_0_22:         .dword 0xb075315cdf0e231c, 0xb1552d1461e96af0
d_0_23:         .dword 0x05faf2c98c92924b, 0xb5bb5d4c54e5fe4e
d_0_24:         .dword 0x82f276cd48ce7c1e, 0xe2557af41e0c94ec
d_0_25:         .dword 0xe70125465cca9c5a, 0xafc6d91e550dbfd2
d_0_26:         .dword 0x85f198a9a8d3f2d2, 0x7d9d083ef147ff00
d_0_27:         .dword 0x9731d0cc6b1993b2, 0x01196f07cbf3f23f
                .dword 0x35b210c9f7cc4e64, 0x2c4ab13e9549f554
                .dword 0x1ea61387ed06d249, 0xe0aab06c9c8dd0a2
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x6b13f5a5546b5211, 0x9e31252e01739b1b
                .dword 0x7adf95e6da36fd44, 0x5733fad9be20be1f
d_1_0:          .dword 0x07e433d54bded4b0, 0x4d9135ff55a7c3e5
d_1_1:          .dword 0x82c888e42a735f95, 0x3a57453c0c41fcd3
d_1_2:          .dword 0x950b8d45b5402a6d, 0xc76dae69d84f271c
d_1_3:          .dword 0x9d4fa24a66daa127, 0x2fd856d603f09150
d_1_4:          .dword 0x44e3572e786d0259, 0xf38104b5fe2fdf05
d_1_5:          .dword 0xacf9e067394ce5a0, 0x9f50f5f9c1c534e5
d_1_6:          .dword 0xe53fb71f4d5fdb8e, 0xf3bba64dddc6bc74
d_1_7:          .dword 0x7589830c9f4d8873, 0x222b0782b8dcb23d
d_1_8:          .dword 0xd1daa230cb50b3c2, 0xfc0653cae0178662
d_1_9:          .dword 0xae6ec516517a850b, 0x72a4a8960afd8485
d_1_10:         .dword 0x341a1b78bd7d96b8, 0x1722587bbd0fe082
d_1_11:         .dword 0x91fde04a163b0146, 0xf0e8fcc9165e075a
d_1_12:         .dword 0x0981dde61221196d, 0x8e9839761a988ba1
d_1_13:         .dword 0xf791e1f739a93fcb, 0x05a72848b229ca77
d_1_14:         .dword 0xa939ecef546f0a56, 0x7ae930b80139dc43
d_1_15:         .dword 0x7ab9b0dce548e51c, 0xb52dc49e4f65b2cf
d_1_16:         .dword 0x30dae0a225e122c3, 0x5d0285cdd2c2440e
d_1_17:         .dword 0xe7e3b4d3ffef2956, 0x04cc09c9cf2ec857
d_1_18:         .dword 0x74d5d0127bfe41fe, 0xd86435fd200b46f5
d_1_19:         .dword 0xa7c5a7cd016a3bd6, 0x7e40efd5a6934a28
d_1_20:         .dword 0xd06f211d738218fe, 0x677f33234815c9d7
d_1_21:         .dword 0xeba5700e4d192dc4, 0xd39ac4aa1cedd0a9
d_1_22:         .dword 0xe8a22386d914e3c2, 0x006077bb63da2895
d_1_23:         .dword 0x73d33b6b1c17329e, 0xee9ddf5c73257217
d_1_24:         .dword 0xb21a2ac098523699, 0xda3bc7b233836a58
d_1_25:         .dword 0xb9c957f6334a1436, 0x08d1bfd65c1fdfcc
d_1_26:         .dword 0x91785b5cf1354d0b, 0x257f2bae0c2de671
d_1_27:         .dword 0xb74fa43c5318343a, 0xa475c8e5f8040e84
                .dword 0xca5942c5a5f12bf9, 0x32e7e083cb12857f
                .dword 0xdc56b68aaccc68e0, 0xe2b57046226181fb
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x11512bcdb412a0d6, 0x992bbe6efbb45a2b
                .dword 0x224c9f08746698f9, 0x1c7ab3a12cff4b7f
d_2_0:          .dword 0xa312f549420e369e, 0xccd87326f0237bb7
d_2_1:          .dword 0x944bdef72115ed1a, 0xc223ee7d1b2aa3f0
d_2_2:          .dword 0x6a7b8e87d67d9f4d, 0x8bc89a279c6fc9d9
d_2_3:          .dword 0xa57f263fda2d7abd, 0xbac47a9be74dd45a
d_2_4:          .dword 0x6487a75fab2d3648, 0xca156ca7bf72d649
d_2_5:          .dword 0xbeee3936fe656152, 0x7cbe8e5accd00d9b
d_2_6:          .dword 0x5c57d528e53cdafa, 0x8648a300b6497a81
d_2_7:          .dword 0x4472b6b3f6664d05, 0x2108a41c314894c5
d_2_8:          .dword 0xd8870d35be234b37, 0x8c3fb62d9088eecc
d_2_9:          .dword 0x5e7602c0302db47e, 0xa8133f7051ed9b97
d_2_10:         .dword 0x147ad1086022f6a3, 0xd86f7d9fff5f45d5
d_2_11:         .dword 0x8cbe0cf9c3f67713, 0x61573e16ccd65465
d_2_12:         .dword 0x2ffaa9d601b6b339, 0x82a7684389ab2d74
d_2_13:         .dword 0x430566a0d687adde, 0x0a19014485bf70b8
d_2_14:         .dword 0xb2e777a28d790781, 0xabadcee6395f9f91
d_2_15:         .dword 0xdda207c7a09912c6, 0xe8d1365ffbf50a41
d_2_16:         .dword 0x0d3dde1548c29a17, 0x0ada0d264cdd6938
d_2_17:         .dword 0xe309a097685a58a1, 0x308bff1807bce84d
d_2_18:         .dword 0x368ea9a9eaa182ec, 0xb09b5956136aa9d9
d_2_19:         .dword 0x97ac065f7dc591a8, 0xc6a77572f5d5e22b
d_2_20:         .dword 0xa96db868826c94c3, 0xbeb7d33c9d1ebe44
d_2_21:         .dword 0x3d1c322ff3172d7a, 0xc22a16b8fe25ca26
d_2_22:         .dword 0x01a562e1b0e984ca, 0x70a9d2456e0ee5ab
d_2_23:         .dword 0x2385e566d1439171, 0xaf032db9ac36aaa0
d_2_24:         .dword 0x2b1ea7f03edc5314, 0x179783703f186c5a
d_2_25:         .dword 0xcc38e98888d32f4c, 0x00b06ce6c70ee624
d_2_26:         .dword 0x6cdc08a46b7ba4f8, 0x383c51e225dc3228
d_2_27:         .dword 0x8d5215c37f604732, 0x70fed6ab6f04e14f
                .dword 0xc702778a9537bccf, 0xebdd59cd8fe51597
                .dword 0xa4c8224aa10efbf1, 0xd3af49d607718331
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc558883e11adde6c, 0x035a6fd330a4b0ad
                .dword 0x47b37bd9d9760f74, 0xa3f70d1751d5c573
d_3_0:          .dword 0x7181d04eaee3e9b1, 0x7a2bbcd71e10d20d
d_3_1:          .dword 0x380cf1de89ecb641, 0x14197db6f0af4dcb
d_3_2:          .dword 0x231655655c7bcb13, 0x59c9a7fd6eae80e4
d_3_3:          .dword 0x52af57ef1f8f6e05, 0xa4c00711cc80df87
d_3_4:          .dword 0x287466d463ed1e4e, 0x64ef845365f36da8
d_3_5:          .dword 0xb77396cb91e0d36a, 0x6c943b94fe919aa7
d_3_6:          .dword 0xd9a5ad700e5e9b25, 0x0b64bbcb502ecfb2
d_3_7:          .dword 0x1a18193eb512fa45, 0x44e0ab238060a607
d_3_8:          .dword 0xaa68cd0b3e148188, 0x697cac27e2d2c2d6
d_3_9:          .dword 0xfbef02c4b4e3a234, 0xa744ac3d8f521a99
d_3_10:         .dword 0x5fb3d9452fd84164, 0xf2baa2022fed286c
d_3_11:         .dword 0x1f7de0167f9b7a47, 0x005413b42f278a0c
d_3_12:         .dword 0x5ae384ff01bb20bc, 0x3a4901235ae36e78
d_3_13:         .dword 0x4d0f10b57441e234, 0xc70dc8852f398651
d_3_14:         .dword 0x16124ee5fbbe2646, 0x459416b3209223c6
d_3_15:         .dword 0x1cbb2de6c9325ede, 0x2d72e6b3e249b786
d_3_16:         .dword 0x35a00c855ca7cf54, 0xb47bb14eb2e79ef8
d_3_17:         .dword 0xd9811d7fa88e3418, 0x9ef88a02cddd478f
d_3_18:         .dword 0x5bfaaf43016796f0, 0x2086fd57b599dca7
d_3_19:         .dword 0xfcd4d7410f0e790a, 0x915584d954e04f28
d_3_20:         .dword 0xdd243c56ea2c728f, 0x86b741bf5fd3cf5f
d_3_21:         .dword 0xa973bc7b0b124f98, 0x4d826e5d3339806f
d_3_22:         .dword 0x242011079c5b9283, 0xef0ace4581977ba8
d_3_23:         .dword 0x8ee88463997eaccc, 0x50adf01a811c942f
d_3_24:         .dword 0x8fce9d88ce15fd78, 0x6d22ce60965a16f0
d_3_25:         .dword 0xd87c8eae9fd83583, 0x665cf2353bc04e73
d_3_26:         .dword 0xf1fe4da4c0e61bf6, 0x74076595a292117b
d_3_27:         .dword 0xb3928a26711e2037, 0x560a56456bdbe3f2
                .dword 0x24f998fcddcd6895, 0x846b150cadca3185
                .dword 0x45a68f0a21ab99da, 0x3fd4047c80c744bd
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xe60e12ebb783f9ac, 0x6f8a7b2271c2ad69
                .dword 0x3f84a6aa604de9b0, 0x70941804ee7c3db9
d_4_0:          .dword 0xecfa5364d8117023, 0xbd208c0edfdab872
d_4_1:          .dword 0x1a97415f6e323a6d, 0xc093197fd06e8dd2
d_4_2:          .dword 0x20a4331211432118, 0x65d1648c8d801e31
d_4_3:          .dword 0xb87e64fa21cf17c0, 0xce845c15a35748a2
d_4_4:          .dword 0x05110b61c73d539f, 0x3c210934ac81bbf3
d_4_5:          .dword 0x8370674a105a6af5, 0x47449ba6f984d209
d_4_6:          .dword 0xa01faaf5c88b6689, 0x04422560a9226181
d_4_7:          .dword 0xb080747853c6df4d, 0xa66a70a559fea4f1
d_4_8:          .dword 0x766b5d3987d332cb, 0xbd906d0cb7d34561
d_4_9:          .dword 0x55a723710df3a163, 0x034d949fba755051
d_4_10:         .dword 0xba19a2c46a315c59, 0x41c586735670bd96
d_4_11:         .dword 0xeaa8af6fd4399aa1, 0x1178ce582e33dc1e
d_4_12:         .dword 0xae13b838194ca110, 0x5bfedc86e81391e0
d_4_13:         .dword 0xf8b912aefd97e4e2, 0x561067c7142a5f0a
d_4_14:         .dword 0x9766f8121204a594, 0x2909e29fc750e270
d_4_15:         .dword 0xf60fada1b9c439f7, 0x56d920337d2f17b6
d_4_16:         .dword 0xc6de72f3fca86aba, 0x0ab992190b98d661
d_4_17:         .dword 0xdad0e79fc0f5abb7, 0xc91ada6efae0ab09
d_4_18:         .dword 0x8d8bbc05ca7e57ac, 0x09339a065a6ccadb
d_4_19:         .dword 0x34baa3c0da2854f5, 0xbf122525495f1e62
d_4_20:         .dword 0x3e350863b5be0e95, 0x22784df015ecb0c2
d_4_21:         .dword 0x6378f225b9cd5473, 0xe901d8d0882ae499
d_4_22:         .dword 0xbb5b2bd6452c3f5d, 0x2ac68bbddcd9b156
d_4_23:         .dword 0xeccac79ff3e9c051, 0x94dd8aab4ea83011
d_4_24:         .dword 0x239ec602ad4bda90, 0xca119a7849e7f7e8
d_4_25:         .dword 0x313cfbdd8db218e8, 0x992a63a40da8f80b
d_4_26:         .dword 0x8ad99a8ebc67e453, 0x040b8431cfd048a1
d_4_27:         .dword 0x267e06abaa4c52a6, 0x23bc9c8fffbd065a
                .dword 0x5a1e3651ecb5a73c, 0xa48d397182f4c052
                .dword 0xe8e0cc4d0dc10822, 0x42dc7b69645e90f3
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x199dc035fb34889d, 0x9a9bdb50d7b45532
                .dword 0x258f0b62d38dd681, 0xd9337351d2f5335e
d_5_0:          .dword 0x3b5bcebd122a42ec, 0xc704b1d02670de6b
d_5_1:          .dword 0x4b29f9b6eb9feaf3, 0x653c88e457290040
d_5_2:          .dword 0xb3f3a2ebc961136a, 0xe5066ced38585200
d_5_3:          .dword 0x4a62f5694b1b31cd, 0x659ab73be2a1d987
d_5_4:          .dword 0xbac3e52d2726e465, 0x64403adaf8648d80
d_5_5:          .dword 0x5726147a0bde9094, 0x36818799b4b508b4
d_5_6:          .dword 0x62395354c95ad94a, 0x4e3f163b66800112
d_5_7:          .dword 0x73927ea10a99ed48, 0x6d3c6e317857da5c
d_5_8:          .dword 0x99378de9d725b0bc, 0xabc60872ca21022e
d_5_9:          .dword 0x1a5445f6c8f29e89, 0x25f60bcc126d0266
d_5_10:         .dword 0xe5c70efd8c8e845e, 0x08e1df1640bc4ab1
d_5_11:         .dword 0x4b2cf5ad7486731c, 0xe1f97de8b8750f6f
d_5_12:         .dword 0x81f5fb108cc7efce, 0x8f640ba89b509f20
d_5_13:         .dword 0x7aefd8117687e705, 0x1732a71c2050d397
d_5_14:         .dword 0xe5738f13b9804b97, 0xa5ec73d6dd78c695
d_5_15:         .dword 0x9915e31310a18cd5, 0x3def51ccb0dbbec4
d_5_16:         .dword 0x1e1b1020b7bacd36, 0x704002e5d12a9d09
d_5_17:         .dword 0xf7f9f1400bf1ec73, 0x885ece6b60c11b42
d_5_18:         .dword 0x51ea892dd3181081, 0x1301cab9e36cfeaa
d_5_19:         .dword 0x9cf8ed6c0059b2bb, 0x0f0e738432edc65b
d_5_20:         .dword 0xce7636bb61b09669, 0xf940adb5ff2d0cd9
d_5_21:         .dword 0x2a42469a2837d1a8, 0x18c0b886086c99f2
d_5_22:         .dword 0xd8823155ebc229e5, 0x6d69ccf3d850ce84
d_5_23:         .dword 0xf543fd54ebb17795, 0x795b1f90b27648f2
d_5_24:         .dword 0x594e33ec157f6cb0, 0x7c353a87ac78e46c
d_5_25:         .dword 0x6f2af7d9d79d5066, 0x6d7dd58874b59382
d_5_26:         .dword 0xc5a0bda078efa065, 0x128f32fe67be1d21
d_5_27:         .dword 0x905f70122f54d419, 0x0d16f5cbe2c0272d
                .dword 0xb6975105cb1812f1, 0xce9f01e3af828d4d
                .dword 0x4e0cbe0a4b6bf8a8, 0xba93739bc047bef8
         /* Random data */
_end_data5:
              
                 
