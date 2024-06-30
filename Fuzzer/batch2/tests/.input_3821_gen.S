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
_s0:    subw x23, x25, x14                        ;
_s1:    la x22, d_5_2                             ;
        flw f15, 4(x22)                           ;
_s2:    subw x26, x17, x27                        ;
_s3:    fcvt.wu.s x5, f15, dyn                    ;
_s4:    la x9, _s5                                ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
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
_p0:    csrrci x14, pmpaddr2, 31                  ;
_p1:    la x13, d_3_2                             ;
        srai x13, x13, 1                          ;
        csrrw x13, pmpaddr6, x13                  ;
_p2:    csrrci x11, fflags, 1                     ;
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
_l0:    fclass.s x20, f30                         ;
_l1:    la x26, d_2_5                             ;
        addi x26, x26, 16                         ;
        amoxor.w x2, x10, (x26)                   ;
_l2:    ecall                                     ;
_l3:    la x2, _l161                              ;
        csrrw zero, uepc, x2                      ;
        uret                                      ;
_l4:    fmv.w.x f30, x29                          ;
_l5:    lui x14, 1048575                          ;
_l6:    la x14, _l116                             ;
        lw x14, 28(x14)                           ;
_l7:    fmadd.s f30, f30, f30, f8, rtz            ;
_l8:    fcvt.s.lu f8, x19, rne                    ;
_l9:    fcvt.w.s x6, f1, dyn                      ;
_l10:   la x14, d_5_16                            ;
        addi x14, x14, 16                         ;
        amoswap.d x13, x19, (x14)                 ;
_l11:   srliw x16, x16, 1                         ;
_l12:   la x15, d_2_13                            ;
        sd x8, -0(x15)                            ;
_l13:   addi x3, x15, 348                         ;
_l14:   la x19, d_5_26                            ;
        addi x19, x19, 8                          ;
        amoswap.d x10, x13, (x19)                 ;
_l15:   la x23, d_1_18                            ;
        flw f25, -8(x23)                          ;
_l16:   fadd.s f6, f30, f2, dyn                   ;
_l17:   addw x12, x21, x29                        ;
_l18:   mulhu x12, x9, x17                        ;
_l19:   la x27, d_4_1                             ;
        fsw f19, 0(x27)                           ;
_l20:   csrrsi x13, pmpaddr4, 22                  ;
_l21:   mulw x5, x15, x23                         ;
_l22:   la x23, d_4_17                            ;
        addi x23, x23, 0                          ;
        sc.d x23, x23, (x23)                      ;
_l23:   divu x16, x20, x1                         ;
_l24:   fmsub.s f2, f8, f1, f20, rdn              ;
_l25:   feq.s x14, f22, f20                       ;
_l26:   la x19, d_1_8                             ;
        flw f2, -28(x19)                          ;
_l27:   fcvt.s.lu f1, x23, dyn                    ;
_l28:   fadd.s f26, f1, f1, dyn                   ;
_l29:   la x17, d_5_2                             ;
        addi x17, x17, -16                        ;
        amoor.d x11, x14, (x17)                   ;
_l30:   divuw x1, x9, x21                         ;
_l31:   la x26, d_4_2                             ;
        addi x26, x26, -0                         ;
        lui x1, 0xffe00                           ;
        xor x26, x26, x1                          ;
        amoor.w x15, x1, (x26)                    ;
_l32:   divu x7, x10, x22                         ;
_l33:   feq.s x21, f26, f16                       ;
_l34:   la x4, d_4_12                             ;
        addi x4, x4, -16                          ;
        amoor.d x17, x7, (x4)                     ;
_l35:   la x10, d_4_11                            ;
        addi x10, x10, 8                          ;
        amomax.w x7, x19, (x10)                   ;
_l36:   fsgnj.s f27, f18, f10                     ;
_l37:   la x15, _l154                             ;
        ld x28, -16(x15)                          ;
_l38:   la x30, d_4_10                            ;
        addi x30, x30, 24                         ;
        amomaxu.w x7, x12, (x30)                  ;
_l39:   addi x4, x24, 997                         ;
_l40:   la x29, d_0_6                             ;
        lb x19, -2(x29)                           ;
_l41:   srliw x22, x22, 24                        ;
_l42:   fmin.s f24, f15, f26                      ;
_l43:   remuw x15, x26, x2                        ;
_l44:   fmv.w.x f4, x18                           ;
_l45:   la x3, d_0_0                              ;
        addi x3, x3, -16                          ;
        lui x19, 0xffe00                          ;
        xor x3, x3, x19                           ;
        amoxor.d x17, x19, (x3)                   ;
_l46:   la x15, d_3_26                            ;
        lbu x2, -5(x15)                           ;
_l47:   la x17, d_1_20                            ;
        addi x17, x17, 8                          ;
        lui x4, 0xffe00                           ;
        xor x17, x17, x4                          ;
        amoxor.d x11, x4, (x17)                   ;
_l48:   lui x30, 1048575                          ;
_l49:   fcvt.s.lu f8, x4, rne                     ;
_l50:   bltu x6, x30, _l65                        ;
_l51:   la x14, d_4_26                            ;
        addi x14, x14, -0                         ;
        amomax.d x20, x3, (x14)                   ;
_l52:   auipc x3, 634387                          ;
_l53:   divw x15, x19, x13                        ;
_l54:   la x23, d_0_26                            ;
        srai x23, x23, 1                          ;
        csrrs x8, pmpaddr1, x23                   ;
_l55:   fle.s x25, f12, f0                        ;
_l56:   la x13, d_0_21                            ;
        addi x13, x13, 24                         ;
        sc.d x21, x13, (x13)                      ;
_l57:   la x24, d_2_10                            ;
        addi x24, x24, 8                          ;
        amomin.w x22, x4, (x24)                   ;
_l58:   divu x19, x21, x15                        ;
_l59:   srliw x27, x26, 0                         ;
_l60:   slli x23, x8, 39                          ;
_l61:   auipc x6, 990176                          ;
_l62:   jal x11, _l153                            ;
_l63:   feq.s x26, f8, f2                         ;
_l64:   rem x23, x9, x21                          ;
_l65:   slliw x9, x29, 10                         ;
_l66:   fcvt.lu.s x9, f14, rne                    ;
_l67:   la x23, d_4_25                            ;
        lui x1, 0xffe00                           ;
        xor x23, x23, x1                          ;
        lhu x26, 30(x23)                          ;
_l68:   fmadd.s f19, f15, f21, f16, rne           ;
_l69:   bge x22, x16, _l190                       ;
_l70:   fsgnjn.s f17, f2, f1                      ;
_l71:   la x28, _l138                             ;
        csrrw zero, uepc, x28                     ;
        uret                                      ;
_l72:   fcvt.w.s x23, f15, dyn                    ;
_l73:   la x22, _l94                              ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_l74:   fnmadd.s f30, f19, f26, f12, rmm          ;
_l75:   fcvt.s.lu f2, x19, rdn                    ;
_l76:   la x29, d_1_7                             ;
        lb x28, 22(x29)                           ;
_l77:   fnmadd.s f7, f13, f15, f3, rmm            ;
_l78:   la x22, d_2_4                             ;
        fsw f19, -0(x22)                          ;
_l79:   fcvt.s.lu f11, x19, rtz                   ;
_l80:   mulhsu x7, x11, x11                       ;
_l81:   la x14, d_4_8                             ;
        lbu x17, -23(x14)                         ;
_l82:   mul x10, x20, x20                         ;
_l83:   srlw x17, x30, x24                        ;
_l84:   fmadd.s f19, f2, f0, f11, rup             ;
_l85:   fclass.s x19, f14                         ;
_l86:   remw x2, x16, x6                          ;
_l87:   la x15, d_4_21                            ;
        srai x15, x15, 1                          ;
        csrrc x11, pmpaddr6, x15                  ;
_l88:   la x15, d_2_8                             ;
        addi x15, x15, 0                          ;
        amoxor.w x15, x4, (x15)                   ;
_l89:   la x18, _l116                             ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l90:   fclass.s x23, f26                         ;
_l91:   bgeu x29, x17, _l156                      ;
_l92:   fnmsub.s f23, f23, f13, f20, rup          ;
_l93:   divu x8, x3, x17                          ;
_l94:   la x9, d_3_2                              ;
        addi x9, x9, -16                          ;
        amoswap.w x22, x16, (x9)                  ;
_l95:   la x26, _l177                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l96:   la x16, d_0_2                             ;
        addi x16, x16, -8                         ;
        amoswap.w x19, x4, (x16)                  ;
_l97:   la x3, _l14                               ;
        lui x24, 0xffe00                          ;
        xor x3, x3, x24                           ;
        lb x4, -28(x3)                            ;
_l98:   rem x1, x19, x28                          ;
_l99:   la x13, d_5_5                             ;
        addi x13, x13, 24                         ;
        lr.d x17, (x13)                           ;
_l100:  la x22, d_0_5                             ;
        sb x22, 10(x22)                           ;
_l101:  fcvt.s.w f26, x24, rne                    ;
_l102:  la x9, d_1_20                             ;
        addi x9, x9, 0                            ;
        amoxor.w x28, x8, (x9)                    ;
_l103:  csrrwi x14, pmpcfg0, 22                   ;
_l104:  srliw x23, x7, 12                         ;
_l105:  la x24, d_0_6                             ;
        addi x24, x24, 8                          ;
        amoor.d x2, x20, (x24)                    ;
_l106:  la x3, _l185                              ;
        jalr x7, 0(x3)                            ;
_l107:  mul x15, x8, x1                           ;
_l108:  addiw x22, x26, 2                         ;
_l109:  remu x19, x11, x18                        ;
_l110:  fmax.s f28, f16, f1                       ;
_l111:  lui x22, 1048575                          ;
_l112:  fsqrt.s f20, f5, rtz                      ;
_l113:  la x17, d_3_18                            ;
        addi x17, x17, 16                         ;
        amoand.d x21, x16, (x17)                  ;
_l114:  divw x5, x12, x4                          ;
_l115:  fsgnjx.s f8, f28, f21                     ;
_l116:  sltiu x4, x3, -24                         ;
_l117:  la x16, d_4_23                            ;
        ld x11, 8(x16)                            ;
_l118:  la x29, d_1_13                            ;
        srai x29, x29, 1                          ;
        csrrs x30, pmpaddr2, x29                  ;
_l119:  la x16, _l200                             ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l120:  csrrsi x11, frm, 12                       ;
_l121:  sraiw x1, x12, 8                          ;
_l122:  fmsub.s f14, f24, f30, f11, rtz           ;
_l123:  divu x16, x6, x28                         ;
_l124:  divw x23, x29, x25                        ;
_l125:  fcvt.s.w f26, x9, rtz                     ;
_l126:  la x29, d_1_10                            ;
        addi x29, x29, 8                          ;
        amominu.d x9, x7, (x29)                   ;
_l127:  la x30, _l145                             ;
        csrrw zero, sepc, x30                     ;
        sret                                      ;
_l128:  la x24, _l192                             ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l129:  lui x23, 0                                ;
_l130:  la x1, d_2_27                             ;
        addi x1, x1, 0                            ;
        amoand.d x19, x29, (x1)                   ;
_l131:  fsub.s f25, f9, f12, rne                  ;
_l132:  fcvt.w.s x29, f7, dyn                     ;
_l133:  fence.i                                   ;
_l134:  fcvt.s.lu f6, x17, rmm                    ;
_l135:  la x18, _l147                             ;
        csrrw zero, sepc, x18                     ;
        sret                                      ;
_l136:  csrrci x9, pmpaddr0, 5                    ;
_l137:  srliw x24, x24, 29                        ;
_l138:  srai x1, x5, 17                           ;
_l139:  la x6, d_4_17                             ;
        addi x6, x6, 28                           ;
        lui x3, 0xffe00                           ;
        xor x6, x6, x3                            ;
        amoand.w x17, x3, (x6)                    ;
_l140:  fcvt.lu.s x10, f5, rtz                    ;
_l141:  la x2, d_2_18                             ;
        addi x2, x2, 0                            ;
        amomax.d x30, x11, (x2)                   ;
_l142:  la x29, d_2_22                            ;
        addi x29, x29, -24                        ;
        amomaxu.w x11, x17, (x29)                 ;
_l143:  xor x30, x30, x30                         ;
        csrrc x10, mhartid, x30                   ;
_l144:  la x9, d_1_16                             ;
        addi x9, x9, -24                          ;
        amoand.d x29, x9, (x9)                    ;
_l145:  fcvt.s.lu f4, x2, rne                     ;
_l146:  sraiw x1, x12, 12                         ;
_l147:  srlw x12, x12, x11                        ;
_l148:  la x27, d_5_19                            ;
        fsw f2, 0(x27)                            ;
_l149:  fcvt.s.w f7, x26, rdn                     ;
_l150:  fcvt.s.wu f30, x9, dyn                    ;
_l151:  la x3, _l187                              ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l152:  remw x3, x16, x11                         ;
_l153:  remw x1, x4, x29                          ;
_l154:  andi x18, x6, 21                          ;
_l155:  flt.s x4, f23, f27                        ;
_l156:  fsgnj.s f9, f1, f21                       ;
_l157:  csrrsi x25, mie, 22                       ;
_l158:  subw x15, x29, x26                        ;
_l159:  fmsub.s f13, f5, f10, f31, rne            ;
_l160:  la x3, d_2_9                              ;
        addi x3, x3, -0                           ;
        amoand.d x15, x17, (x3)                   ;
_l161:  la x23, d_2_14                            ;
        addi x23, x23, -0                         ;
        amomax.d x9, x20, (x23)                   ;
_l162:  divuw x5, x6, x29                         ;
_l163:  la x8, d_3_1                              ;
        flw f6, -24(x8)                           ;
_l164:  fsgnjn.s f28, f15, f23                    ;
_l165:  la x23, d_4_6                             ;
        addi x23, x23, 0                          ;
        amomaxu.d x30, x21, (x23)                 ;
_l166:  mulhu x24, x24, x18                       ;
_l167:  fsgnjn.s f18, f13, f1                     ;
_l168:  remu x13, x10, x4                         ;
_l169:  sltiu x7, x11, -997                       ;
_l170:  la x1, d_0_16                             ;
        addi x1, x1, -8                           ;
        amominu.d x27, x7, (x1)                   ;
_l171:  feq.s x23, f19, f15                       ;
_l172:  mulw x6, x27, x16                         ;
_l173:  la x13, d_0_26                            ;
        addi x13, x13, 0                          ;
        amomin.w x13, x12, (x13)                  ;
_l174:  feq.s x13, f20, f25                       ;
_l175:  ebreak                                    ;
_l176:  la x28, d_3_19                            ;
        addi x28, x28, -8                         ;
        amoadd.d x27, x17, (x28)                  ;
_l177:  mulhu x18, x19, x29                       ;
_l178:  la x2, d_4_5                              ;
        addi x2, x2, 8                            ;
        amomin.d x8, x7, (x2)                     ;
_l179:  slli x24, x18, 19                         ;
_l180:  fcvt.wu.s x22, f24, rmm                   ;
_l181:  la x26, d_5_26                            ;
        addi x26, x26, -24                        ;
        amomin.d x16, x23, (x26)                  ;
_l182:  fnmadd.s f23, f30, f23, f29, dyn          ;
_l183:  la x12, d_2_20                            ;
        addi x12, x12, -4                         ;
        lui x21, 0xffe00                          ;
        xor x12, x12, x21                         ;
        amoxor.w x6, x21, (x12)                   ;
_l184:  csrrsi x26, fflags, 0                     ;
_l185:  la x13, d_3_12                            ;
        sb x27, -19(x13)                          ;
_l186:  fcvt.s.lu f31, x29, dyn                   ;
_l187:  sraw x6, x27, x5                          ;
_l188:  slli x16, x15, 49                         ;
_l189:  la x5, d_4_12                             ;
        addi x5, x5, 0                            ;
        amoor.d x22, x27, (x5)                    ;
_l190:  la x24, _l193                             ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l191:  sraiw x9, x14, 0                          ;
_l192:  la x16, d_5_19                            ;
        lwu x13, -28(x16)                         ;
_l193:  la x30, d_3_19                            ;
        addi x30, x30, 20                         ;
        amoxor.w x21, x27, (x30)                  ;
_l194:  la x6, d_2_14                             ;
        addi x6, x6, -0                           ;
        lui x19, 0xffe00                          ;
        xor x6, x6, x19                           ;
        amoor.d x16, x19, (x6)                    ;
_l195:  fsgnjx.s f28, f5, f26                     ;
_l196:  remuw x23, x16, x15                       ;
_l197:  la x10, d_1_0                             ;
        lui x12, 0xffe00                          ;
        xor x10, x10, x12                         ;
        lhu x11, 18(x10)                          ;
_l198:  slliw x30, x28, 1                         ;
_l199:  fmsub.s f31, f4, f5, f5, dyn              ;
_l200:;
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
                .dword 0x7bb4fcee82784d28, 0xa8dea2684d18efe1
                .dword 0x953028366f449147, 0x33d21d405fb789fb
d_0_0:          .dword 0x4e029fd7960d6fb9, 0xd8c93e7b990d86bb
d_0_1:          .dword 0x05ccbf0de8cdb3fc, 0xeb7624328081eb67
d_0_2:          .dword 0x741c780575716624, 0xd9b57ae3bc927429
d_0_3:          .dword 0x5afc4762743f523e, 0xe8069b33ce620ac2
d_0_4:          .dword 0x3ba3b8ef72c1f0cc, 0x3ea7b08f66dea8d3
d_0_5:          .dword 0x67bba696951f67bf, 0x059d05dc48b9bd92
d_0_6:          .dword 0x9e0bfb89d11149d5, 0xa6875ad46447014a
d_0_7:          .dword 0x76d70cdfeff75f9b, 0x844dc30afeea3ef7
d_0_8:          .dword 0x7dd859a4f89fba93, 0xf21260189c02cca3
d_0_9:          .dword 0x4056628f8ceb841c, 0x92b57dc9a7af7d82
d_0_10:         .dword 0xccb2260050e6f389, 0x56a15bb7f2876469
d_0_11:         .dword 0xe894a10410ead7f7, 0xd6737c89e2ce7a1f
d_0_12:         .dword 0x18d952e5e824d98e, 0x660c79a37c23beb0
d_0_13:         .dword 0xe4fa967597da22f0, 0x36925bef4fa7f04f
d_0_14:         .dword 0x5e6933c3dab9d571, 0x272e8a6fceb48d20
d_0_15:         .dword 0xad37f959fb10f8a7, 0x8a0af51d367d611e
d_0_16:         .dword 0x11f92380c2aee289, 0xb73b7acf007e0cc9
d_0_17:         .dword 0xd3b1f833593cb75a, 0xf1d304dafaa53fed
d_0_18:         .dword 0x5eeb484e477d16bd, 0x3db9f27814491ecc
d_0_19:         .dword 0xbca450b0d7bfee89, 0x3a21a32a7493caf4
d_0_20:         .dword 0xc1336e55588d55bc, 0x927acd15ea3b420e
d_0_21:         .dword 0x120dfe47b6cd66a0, 0x286c3ab5b1f69bf0
d_0_22:         .dword 0xc56fe63ef7ac52ff, 0x2fc02c36787a485a
d_0_23:         .dword 0x9fce6b078c86d061, 0x31e8032f33db02c3
d_0_24:         .dword 0x30e7955fbfde2e2b, 0xa3802bbe7fcaa5e6
d_0_25:         .dword 0xd8aae0f758a3ad6f, 0xe5606e97204f7378
d_0_26:         .dword 0xc040103a89f65009, 0xe4567f7c5fea5930
d_0_27:         .dword 0xafff10235274f170, 0xf5abb94a81be4830
                .dword 0x8f30e20a00be9d12, 0x0e393dfb221d0f4d
                .dword 0x758d390fae574d68, 0xb92ec0cc7b170376
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x194db6268b91b15b, 0xfcf214b424137749
                .dword 0x1788786f6dae5711, 0x2c1f10606dab200d
d_1_0:          .dword 0x8e396667da0f6f4c, 0xa694c34cc26e5f8e
d_1_1:          .dword 0xab41db80808308cd, 0x74edbc1866cfd59f
d_1_2:          .dword 0xdc002d4ea1476dee, 0xe036655fa6151e28
d_1_3:          .dword 0x28bc8e96724c07f8, 0xa013696d5508d8e2
d_1_4:          .dword 0x6690f75a546cab7d, 0x0b088066d7f501e9
d_1_5:          .dword 0x008f061d3daa3a6a, 0xfafe6757989c16c7
d_1_6:          .dword 0x10f7b6090fc43d77, 0x70d9ce877513423f
d_1_7:          .dword 0x3b5063b8b4795ed6, 0xf191c9bbf7245b90
d_1_8:          .dword 0x9728b65c044210b4, 0x42d3778f619f5994
d_1_9:          .dword 0xb8f40cdd7703ccd8, 0x1d41918bdc24848b
d_1_10:         .dword 0x7d42faf7e43a169e, 0x3ffa6fd319e67b76
d_1_11:         .dword 0x64fe91d58c1ce848, 0x172523fb70bf3a94
d_1_12:         .dword 0x0ea49317f328b27a, 0x4290d631e509e88e
d_1_13:         .dword 0xe91a163120ae5bed, 0x03094b2e9c911a62
d_1_14:         .dword 0x0e70e1ab9819f504, 0xf518024d282ebfea
d_1_15:         .dword 0xe84b6410dcd7bfb9, 0x2ee2254d36888bcb
d_1_16:         .dword 0x21d5007dd3e57711, 0xac17be32f1a8bdc7
d_1_17:         .dword 0x5be323f7158e7b1f, 0xfcd237b1de9e0cba
d_1_18:         .dword 0x163fa164960bb1c2, 0x06c96ee09c518f41
d_1_19:         .dword 0xde5fc3e169bc9639, 0xdb47c4522d76d177
d_1_20:         .dword 0x2f7174a322226864, 0x4d4bb7383ad28616
d_1_21:         .dword 0x6ab6cdf09b3653e3, 0x4d0778478495b3f3
d_1_22:         .dword 0xb2b2229c3f373854, 0x24795316235c7743
d_1_23:         .dword 0xc616e5abd131f431, 0x9d5b08b514d4bec6
d_1_24:         .dword 0xd346fe9bdc667cfc, 0x02801253ccbe4813
d_1_25:         .dword 0xe3039ae5a3ceb40c, 0x028a83baf0e4bf39
d_1_26:         .dword 0xb0b38914a2d402f6, 0x9560842ecd4a0b54
d_1_27:         .dword 0x000f16288fbca4ff, 0x9bfcd69b72eab287
                .dword 0xf790536a5f197bf6, 0xe2d5df986adaa2ed
                .dword 0xb2dd4a8bf1bfe2c7, 0x7fcc7edfaa49b875
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xf8841ad315f6628d, 0x6785cd06e2be8fef
                .dword 0x9bb6bedf1e7c3296, 0x25ac9e94580d9167
d_2_0:          .dword 0x2bafb97e0e79dfa1, 0x58189d5de61e9f60
d_2_1:          .dword 0xb62f80e7df330f38, 0x5b2e71dda06ef23c
d_2_2:          .dword 0x53210289157f7f77, 0xaecc15a60a22daab
d_2_3:          .dword 0x6dfeb49a6f7ceaf7, 0xe6f80855e04bcd0c
d_2_4:          .dword 0xbe457d98d9e7de7f, 0x37c009c364115859
d_2_5:          .dword 0xafd71e0bf5d6277c, 0x56d9077fcac5debb
d_2_6:          .dword 0x9b24b9eb5d69d3e9, 0xab22b02132695503
d_2_7:          .dword 0xb47f801a6532c22f, 0xa279ac209fa754bd
d_2_8:          .dword 0x647aeb9e6d82efad, 0x8f061c2121f755b0
d_2_9:          .dword 0xaecfa8661bedbe89, 0xc44ced1d351ab59c
d_2_10:         .dword 0xb6461efca299d1b9, 0xf7bf6228f513dc3f
d_2_11:         .dword 0x5add95272519707f, 0x5149db432fc7096a
d_2_12:         .dword 0x3f6432aa50909f8c, 0xd54e70893a8a4ca6
d_2_13:         .dword 0x4c4b23a27a2f034a, 0xf38ee19de8237426
d_2_14:         .dword 0x10ba816680c01e9f, 0x58b1c081311350cf
d_2_15:         .dword 0x36c62c6086f1cf5e, 0x2705f796eda42a86
d_2_16:         .dword 0x1d797de19674c6b8, 0xcb8282a19d49d0d2
d_2_17:         .dword 0xb18f9f7b99697716, 0x9740a9cb4bb715ab
d_2_18:         .dword 0x5e74d50d91f5dca9, 0x803984fe34b6b774
d_2_19:         .dword 0x94b80a0d6780e562, 0x28ae54cad6c147f1
d_2_20:         .dword 0x1c912d60acc6280d, 0x46c1c5e34c1b7450
d_2_21:         .dword 0xe4fb176e740cc839, 0x4275be367afc659c
d_2_22:         .dword 0x1ec08b0c2b456832, 0x96ccc211cb55e5ce
d_2_23:         .dword 0x630cadecbed0d01b, 0x4e9b5d6c97d948fa
d_2_24:         .dword 0xcc0a27b6f192764b, 0x0931319b83e597ae
d_2_25:         .dword 0xd3a8120207c71e85, 0xabfd5b172c23ded5
d_2_26:         .dword 0x3c02e9223c41d932, 0x3be2d9c7ff8bbecc
d_2_27:         .dword 0x9ae930624c4f44dc, 0x4690f4ea3096b8ca
                .dword 0x71415bb1929bb469, 0x9820bb34c59f22a8
                .dword 0x78f5085e0d2a3f48, 0x024cfa3c2d63a613
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xcb91eb5fbd685a46, 0x5d7ade2b31724172
                .dword 0xe61c96ba325b826f, 0xa464013267a6909d
d_3_0:          .dword 0x0f9f079ccdd7cd31, 0x4e1c3c2f018bd34b
d_3_1:          .dword 0xb2e8b8f3e402bfef, 0xd6ffa2dcaee441f4
d_3_2:          .dword 0x3aa3dc9dcb1c3213, 0x4f23fee3272fa48f
d_3_3:          .dword 0xd5db9c6538c65d3e, 0xa540ba8045cba28b
d_3_4:          .dword 0x3397c279d32eb365, 0xd9012a7eafebd6ac
d_3_5:          .dword 0x394506f81f69fafd, 0x5469cdf8b7875b18
d_3_6:          .dword 0x7667e1c992d200ef, 0x54e4e754621ba4f5
d_3_7:          .dword 0x7af6ec564d95ce0f, 0x882127bdd5b6ef39
d_3_8:          .dword 0x2a8464481e71365b, 0x1094dac048d59a0d
d_3_9:          .dword 0xe46c60432050ef5b, 0x99d178f79bd81ee3
d_3_10:         .dword 0xb359d11fe5747840, 0x37b1860720208cfa
d_3_11:         .dword 0x182438f2b856251b, 0x1a5708dc243579f7
d_3_12:         .dword 0x019694aa66647093, 0xc5283d6e48842170
d_3_13:         .dword 0xdba43a8ac3f2e3ad, 0x62c0632fbb31a3dc
d_3_14:         .dword 0x4b2af4a8ccd98a07, 0x4cea85c3b94faa1c
d_3_15:         .dword 0xa3d7c360c442a1ae, 0xaa4499dd2eb9a90d
d_3_16:         .dword 0x7400c749d8c508a7, 0x338e0be8e3beb45a
d_3_17:         .dword 0xe22055f957d8fce6, 0xe7d8bc64b01249ae
d_3_18:         .dword 0xefcd1eae60fc4f1d, 0xe7eafe40caf70ca9
d_3_19:         .dword 0x24c5f352c8d285fe, 0x3a31d224cda7fce7
d_3_20:         .dword 0xd92a945eaae493d0, 0x3daa149b9ee1b4ab
d_3_21:         .dword 0x44a01a645a795cc7, 0x674ced18ef44f99f
d_3_22:         .dword 0x5d3b5a6ee4e51655, 0xcdc4853a1965c015
d_3_23:         .dword 0x3fa9e106a04ee245, 0x2b7be9b2cd768596
d_3_24:         .dword 0x42f7c4dc38132586, 0x307fb00de28017a9
d_3_25:         .dword 0x1cbcf581670a04ac, 0xeb9613c1211796c9
d_3_26:         .dword 0x6a8b6570df81742a, 0x78867b3050ac2df4
d_3_27:         .dword 0xb2554d1d1db41e20, 0x086e44b40c4f919b
                .dword 0xd74ab9d1370386c0, 0xf75662ce2a5dd469
                .dword 0xbf3429536daaf20a, 0x3eb46f8335e62671
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x3012420c1c5226dd, 0x552b9f7cc836d39b
                .dword 0xacd664c618fbb97b, 0xd8c8374287f123f5
d_4_0:          .dword 0x74f7108500b41369, 0x636a33a017deac5c
d_4_1:          .dword 0x6345136151dd3969, 0x8eb2d90bdb91172d
d_4_2:          .dword 0x3821826ced2356fe, 0x0563aa3546eb7659
d_4_3:          .dword 0xee072f37f2a208c8, 0xcd20dc50472e8323
d_4_4:          .dword 0xce49ef68e84d1393, 0xdc68cdc2a0736c38
d_4_5:          .dword 0xa5b6fea3ce915420, 0x88392c8f5b5af693
d_4_6:          .dword 0x06a08412a9403330, 0xed723f6bcbeac9d7
d_4_7:          .dword 0x5de7439c27818f6c, 0x241f6269a665431a
d_4_8:          .dword 0x9a29ada49016727e, 0xe0fadb508d3a5229
d_4_9:          .dword 0x5bdce30f0dcbf88e, 0xcd80ffd02dfb01f6
d_4_10:         .dword 0x027af76d538c2bd9, 0x3be2b4b336c4208a
d_4_11:         .dword 0xf2d123961f691533, 0xa53210dc9121d6bc
d_4_12:         .dword 0xd5a48e3902a8ad09, 0xbd733f3a10838466
d_4_13:         .dword 0xf22b7e6ba4342f69, 0x4a79df4daecf09b0
d_4_14:         .dword 0x969def3af7262e7f, 0xf322df975e3b811f
d_4_15:         .dword 0xf38f279ea72617d3, 0x4ab3f6a8741cf59f
d_4_16:         .dword 0x4ab2ca8c2da21ec3, 0x0e7381c8b59b27c3
d_4_17:         .dword 0x29d7f25f5adea128, 0xfd261a1c6be7d34a
d_4_18:         .dword 0x30c23686dc754f52, 0x9a9fb9f2d2fd94c5
d_4_19:         .dword 0x6d073484a7c5900b, 0x375181d76e8626fc
d_4_20:         .dword 0xcbaea69a75ee9c63, 0x36174b804fe3f1f3
d_4_21:         .dword 0xbcb0212126930c2b, 0x07d06f44f3bc287c
d_4_22:         .dword 0x600d02809c420c4f, 0xd0717fa16975db69
d_4_23:         .dword 0xe42be9027bd82ddf, 0x065174c8110a4e01
d_4_24:         .dword 0xed1457b3541fd58b, 0xaa41de1237c6484f
d_4_25:         .dword 0x1e8417bb2c5471af, 0x6511f5f7c20a950d
d_4_26:         .dword 0x10267a040a7ff4f1, 0xb026ba14a2f21d3d
d_4_27:         .dword 0x6907b26237ff887d, 0x87cf44cc94df932e
                .dword 0x85cd6db751cccc15, 0xee53f1c6980b4860
                .dword 0x4f1359da04fb3e93, 0xa5492423cb3c5a4c
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x53ffb4f5a5d40113, 0x07b2c10675542615
                .dword 0x1dd0dc1bd1ab487a, 0xf2fb9bdf076eb407
d_5_0:          .dword 0xa52b6186624c79b9, 0xb92ac60dcefa1ee6
d_5_1:          .dword 0xf6e0cf1f75458b7f, 0x5ab809b83b96fbda
d_5_2:          .dword 0x630770a6aed231eb, 0xd90fed68bca82ab6
d_5_3:          .dword 0xd865395a2fc8db7f, 0x8108d34e4d7c145f
d_5_4:          .dword 0x54ad3a85c56129af, 0x3bb163d53e650d35
d_5_5:          .dword 0x5564561aec03fc44, 0x912abcb519caea2c
d_5_6:          .dword 0x2c4a08c719f53e8f, 0x96d2e5fd7c4a8bd6
d_5_7:          .dword 0x7e3c44dc01a28c48, 0x7f5e29fb0cff441b
d_5_8:          .dword 0x8eba6781e552d770, 0x432d852458f0be6e
d_5_9:          .dword 0x41a848f3fea7f4f6, 0xd0ccc25b387cb810
d_5_10:         .dword 0x54b95a409abc82c5, 0xc347cb474159cec1
d_5_11:         .dword 0x0053836cb466bd30, 0x1d484b00631170fb
d_5_12:         .dword 0x32666720eae33f97, 0xefa147e7da3f7466
d_5_13:         .dword 0x8d9ef87f56802233, 0x67ce46feb62b5e78
d_5_14:         .dword 0x39f07e9ef2693b3f, 0x6e3406134b85cbac
d_5_15:         .dword 0xefd3de191989b64f, 0x5b1f085c3d58e478
d_5_16:         .dword 0x515fa146b2aefd41, 0x961deba741f635ee
d_5_17:         .dword 0x4e467feb88731a7d, 0x85fdfd1a6b9d19a1
d_5_18:         .dword 0x1c5e1498bf09d91f, 0x8c99d26630d5e3f1
d_5_19:         .dword 0x67377efa27d956cd, 0xd42a886e30d4ec3c
d_5_20:         .dword 0x1f01438d5e30486b, 0x76037fe939cb243f
d_5_21:         .dword 0x7dda2d12aac962ef, 0xb3396e3ecf3ae066
d_5_22:         .dword 0xbf719aba5628449c, 0x6f1b1919710fae57
d_5_23:         .dword 0x47bda1dd9cef4ad5, 0x855b784a5e262ba5
d_5_24:         .dword 0x87bb7e2c6256bac0, 0xf7a65482194ec2f5
d_5_25:         .dword 0x6bbdf4c71ea395fa, 0x7e78c1e99536cc5b
d_5_26:         .dword 0x8b8cd77e5bb45a5d, 0x6dbbb56a9f29c414
d_5_27:         .dword 0xdbc5fba3fa5cd711, 0x7dbe67112ccd439b
                .dword 0x574aee05778cb831, 0xc7e1f3b4291c3810
                .dword 0xb4cbb4dc9553a142, 0xc1a83a586dd8bbbf
         /* Random data */
_end_data5:
              
                 
