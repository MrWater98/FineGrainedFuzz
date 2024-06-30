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
_s0:    csrrci x12, pmpaddr1, 26                  ;
_s1:    srliw x18, x21, 16                        ;
_s2:    la x30, d_2_23                            ;
        addi x30, x30, 20                         ;
        amominu.w x18, x22, (x30)                 ;
_s3:    la x26, d_1_9                             ;
        addi x26, x26, -8                         ;
        amomaxu.d x20, x24, (x26)                 ;
_s4:    subw x8, x15, x21                         ;
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
_p0:    csrrci x10, mscratch, 12                  ;
_p1:    csrrsi x14, medeleg, 13                   ;
_p2:    csrrwi x11, pmpaddr2, 2                   ;
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
_l0:    addiw x22, x19, -2                        ;
_l1:    la x27, d_1_22                            ;
        sw x3, 0(x27)                             ;
_l2:    fsgnjn.s f26, f27, f22                    ;
_l3:    fmax.s f30, f13, f26                      ;
_l4:    slliw x7, x4, 23                          ;
_l5:    csrrwi x18, pmpaddr0, 12                  ;
_l6:    fmsub.s f3, f7, f28, f1, rtz              ;
_l7:    feq.s x13, f20, f27                       ;
_l8:    lui x19, 0                                ;
_l9:    fle.s x1, f27, f22                        ;
_l10:   la x17, d_3_26                            ;
        srai x17, x17, 1                          ;
        csrrs x7, pmpaddr7, x17                   ;
_l11:   la x17, _l188                             ;
        jalr x9, 0(x17)                           ;
_l12:   feq.s x1, f11, f24                        ;
_l13:   remw x3, x0, x5                           ;
_l14:   la x27, d_5_16                            ;
        addi x27, x27, 0                          ;
        lui x27, 0xffe00                          ;
        xor x27, x27, x27                         ;
        lr.d x10, (x27)                           ;
_l15:   srai x18, x18, 32                         ;
_l16:   la x11, d_4_11                            ;
        sw x19, 0(x11)                            ;
_l17:   fle.s x27, f7, f11                        ;
_l18:   la x4, d_5_1                              ;
        lw x21, 0(x4)                             ;
_l19:   fence                                     ;
_l20:   la x26, d_1_6                             ;
        addi x26, x26, -24                        ;
        amoand.d x26, x26, (x26)                  ;
_l21:   subw x3, x10, x8                          ;
_l22:   la x27, d_1_2                             ;
        addi x27, x27, 20                         ;
        amoswap.w x21, x17, (x27)                 ;
_l23:   sllw x22, x8, x18                         ;
_l24:   la x29, _l190                             ;
        csrrw zero, sepc, x29                     ;
        sret                                      ;
_l25:   bne x15, x6, _l175                        ;
_l26:   la x14, d_4_18                            ;
        sh x27, 28(x14)                           ;
_l27:   feq.s x20, f24, f7                        ;
_l28:   fsub.s f7, f19, f3, rtz                   ;
_l29:   la x11, d_4_6                             ;
        sd x19, -0(x11)                           ;
_l30:   la x20, d_1_26                            ;
        sh x27, -2(x20)                           ;
_l31:   remu x14, x22, x11                        ;
_l32:   csrrsi x8, pmpaddr5, 31                   ;
_l33:   fsgnjx.s f0, f16, f26                     ;
_l34:   fclass.s x25, f2                          ;
_l35:   div x27, x15, x2                          ;
_l36:   subw x26, x19, x1                         ;
_l37:   la x30, d_0_5                             ;
        addi x30, x30, 4                          ;
        amoand.w x23, x16, (x30)                  ;
_l38:   la x4, d_4_27                             ;
        lhu x19, 6(x4)                            ;
_l39:   la x13, d_5_26                            ;
        addi x13, x13, -28                        ;
        amomin.w x18, x28, (x13)                  ;
_l40:   addiw x18, x12, 1604                      ;
_l41:   la x10, d_0_5                             ;
        lw x29, -4(x10)                           ;
_l42:   csrrwi x3, pmpaddr1, 31                   ;
_l43:   la x11, d_2_6                             ;
        addi x11, x11, -0                         ;
        amomin.d x4, x17, (x11)                   ;
_l44:   fmsub.s f27, f26, f24, f27, rdn           ;
_l45:   fmadd.s f7, f26, f5, f24, rdn             ;
_l46:   divu x15, x30, x18                        ;
_l47:   srliw x9, x16, 24                         ;
_l48:   fmax.s f28, f29, f10                      ;
_l49:   blt x7, x20, _l74                         ;
_l50:   srlw x8, x13, x21                         ;
_l51:   fsgnj.s f12, f18, f24                     ;
_l52:   blt x9, x19, _l95                         ;
_l53:   srliw x29, x10, 28                        ;
_l54:   la x8, d_3_26                             ;
        addi x8, x8, -0                           ;
        amoor.d x27, x26, (x8)                    ;
_l55:   la x11, d_2_10                            ;
        addi x11, x11, 20                         ;
        amoxor.w x21, x27, (x11)                  ;
_l56:   auipc x2, 728202                          ;
_l57:   div x23, x5, x5                           ;
_l58:   la x16, d_2_4                             ;
        lw x14, 0(x16)                            ;
_l59:   remw x4, x25, x8                          ;
_l60:   la x14, d_4_25                            ;
        addi x14, x14, -8                         ;
        amomax.d x16, x18, (x14)                  ;
_l61:   la x11, d_4_5                             ;
        addi x11, x11, 0                          ;
        lr.d x18, (x11)                           ;
_l62:   la x9, d_0_11                             ;
        addi x9, x9, 12                           ;
        amoxor.w x2, x28, (x9)                    ;
_l63:   fnmsub.s f0, f3, f25, f16, rdn            ;
_l64:   ebreak                                    ;
_l65:   la x19, _l101                             ;
        csrrw zero, sepc, x19                     ;
        sret                                      ;
_l66:   la x15, d_0_0                             ;
        addi x15, x15, -8                         ;
        amomin.w x12, x7, (x15)                   ;
_l67:   divw x27, x13, x2                         ;
_l68:   andi x2, x3, 1330                         ;
_l69:   la x30, d_3_16                            ;
        addi x30, x30, -20                        ;
        lui x13, 0xffe00                          ;
        xor x30, x30, x13                         ;
        amomaxu.w x13, x13, (x30)                 ;
_l70:   sraiw x3, x8, 18                          ;
_l71:   la x16, d_4_18                            ;
        addi x16, x16, -0                         ;
        amoor.w x29, x10, (x16)                   ;
_l72:   srliw x5, x13, 22                         ;
_l73:   fmin.s f6, f10, f15                       ;
_l74:   remuw x10, x19, x5                        ;
_l75:   subw x20, x22, x13                        ;
_l76:   andi x24, x23, -1548                      ;
_l77:   fsub.s f7, f20, f1, rtz                   ;
_l78:   fadd.s f16, f25, f3, rne                  ;
_l79:   fcvt.w.s x17, f4, rdn                     ;
_l80:   fsqrt.s f16, f4, dyn                      ;
_l81:   xor x29, x29, x29                         ;
        csrrs x18, mscratch, x29                  ;
_l82:   andi x12, x9, -1038                       ;
_l83:   bne x28, x11, _l115                       ;
_l84:   fsgnjn.s f7, f17, f19                     ;
_l85:   fmadd.s f13, f5, f5, f27, rmm             ;
_l86:   fmsub.s f18, f14, f28, f27, rtz           ;
_l87:   la x20, d_5_20                            ;
        addi x20, x20, -16                        ;
        amomax.d x6, x4, (x20)                    ;
_l88:   fmv.x.w x26, f5                           ;
_l89:   la x6, d_5_4                              ;
        lw x16, -28(x6)                           ;
_l90:   fmv.w.x f27, x14                          ;
_l91:   fcvt.s.wu f2, x6, rne                     ;
_l92:   flt.s x14, f27, f9                        ;
_l93:   slli x2, x29, 46                          ;
_l94:   slti x17, x1, -2047                       ;
_l95:   bge x4, x5, _l165                         ;
_l96:   fence                                     ;
_l97:   fclass.s x0, f9                           ;
_l98:   la x15, d_1_24                            ;
        addi x15, x15, -8                         ;
        amomaxu.d x10, x28, (x15)                 ;
_l99:   remu x23, x21, x15                        ;
_l100:  la x18, _l182                             ;
        lui x20, 0xffe00                          ;
        xor x18, x18, x20                         ;
        lw x20, 0(x18)                            ;
_l101:  auipc x19, 0                              ;
_l102:  la x14, d_3_9                             ;
        addi x14, x14, 8                          ;
        amomaxu.w x17, x11, (x14)                 ;
_l103:  sraw x9, x17, x19                         ;
_l104:  mulhsu x3, x18, x17                       ;
_l105:  fcvt.wu.s x12, f9, rne                    ;
_l106:  bne x27, x5, _l177                        ;
_l107:  la x8, d_3_23                             ;
        addi x8, x8, 12                           ;
        sc.w x9, x6, (x8)                         ;
_l108:  sraw x12, x8, x15                         ;
_l109:  la x29, d_2_14                            ;
        addi x29, x29, 0                          ;
        amoor.d x21, x10, (x29)                   ;
_l110:  la x1, _l114                              ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l111:  csrrwi x21, mtval, 13                     ;
_l112:  feq.s x10, f12, f8                        ;
_l113:  beq x5, x20, _l123                        ;
_l114:  la x23, d_2_19                            ;
        sb x2, 10(x23)                            ;
_l115:  bgeu x24, x14, _l187                      ;
_l116:  csrrwi x7, stval, 10                      ;
_l117:  fsgnjx.s f1, f26, f7                      ;
_l118:  fsgnjn.s f28, f29, f16                    ;
_l119:  la x3, d_2_24                             ;
        addi x3, x3, -4                           ;
        amoor.w x27, x4, (x3)                     ;
_l120:  srli x12, x24, 48                         ;
_l121:  la x12, _l130                             ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l122:  la x11, _l194                             ;
        csrrw zero, sepc, x11                     ;
        sret                                      ;
_l123:  la x23, d_4_4                             ;
        addi x23, x23, -0                         ;
        amominu.d x25, x12, (x23)                 ;
_l124:  la x21, d_0_2                             ;
        addi x21, x21, -8                         ;
        amominu.d x20, x25, (x21)                 ;
_l125:  csrrwi x16, mtval, 5                      ;
_l126:  divu x0, x7, x25                          ;
_l127:  fmin.s f24, f7, f15                       ;
_l128:  la x11, d_5_5                             ;
        lwu x8, 28(x11)                           ;
_l129:  subw x15, x14, x13                        ;
_l130:  fcvt.w.s x24, f29, rmm                    ;
_l131:  ori x22, x10, -1655                       ;
_l132:  srai x23, x27, 50                         ;
_l133:  fmv.w.x f4, x27                           ;
_l134:  mulhsu x15, x21, x19                      ;
_l135:  la x16, d_4_4                             ;
        addi x16, x16, -16                        ;
        sc.d x3, x16, (x16)                       ;
_l136:  la x9, d_4_7                              ;
        addi x9, x9, 24                           ;
        amomax.w x11, x2, (x9)                    ;
_l137:  srlw x23, x5, x25                         ;
_l138:  addi x5, x0, -14                          ;
_l139:  fmax.s f13, f1, f12                       ;
_l140:  fmadd.s f20, f22, f9, f19, dyn            ;
_l141:  fence.i                                   ;
_l142:  la x22, _l185                             ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_l143:  slti x1, x1, -1343                        ;
_l144:  fmsub.s f2, f0, f8, f10, rne              ;
_l145:  mulhu x29, x19, x28                       ;
_l146:  la x29, d_0_3                             ;
        sb x22, -1(x29)                           ;
_l147:  addi x1, x21, -2047                       ;
_l148:  rem x8, x15, x18                          ;
_l149:  rem x2, x1, x24                           ;
_l150:  fdiv.s f13, f15, f30, rne                 ;
_l151:  remuw x27, x13, x26                       ;
_l152:  mulhu x14, x26, x11                       ;
_l153:  xor x6, x6, x6                            ;
        addi x1, zero, 1                          ;
        slli x1, x1, 2                            ;
        add x6, x6, x1                            ;
        csrrw x10, medeleg, x6                    ;
_l154:  fmsub.s f23, f20, f8, f2, rdn             ;
_l155:  la x6, d_5_19                             ;
        addi x6, x6, 0                            ;
        amomaxu.d x22, x27, (x6)                  ;
_l156:  la x9, d_5_5                              ;
        addi x9, x9, -16                          ;
        amoswap.w x19, x2, (x9)                   ;
_l157:  la x17, d_1_25                            ;
        addi x17, x17, 0                          ;
        amoxor.d x27, x12, (x17)                  ;
_l158:  fcvt.s.wu f26, x3, rtz                    ;
_l159:  xori x20, x7, 1219                        ;
_l160:  addw x18, x30, x13                        ;
_l161:  la x13, d_2_22                            ;
        addi x13, x13, 16                         ;
        lui x14, 0xffe00                          ;
        xor x13, x13, x14                         ;
        amoand.d x15, x14, (x13)                  ;
_l162:  fcvt.lu.s x18, f23, rmm                   ;
_l163:  slti x14, x29, 1056                       ;
_l164:  bgeu x4, x22, _l171                       ;
_l165:  slliw x3, x1, 12                          ;
_l166:  addi x11, x16, -290                       ;
_l167:  fmv.w.x f12, x14                          ;
_l168:  fcvt.s.lu f18, x23, rup                   ;
_l169:  la x30, d_4_17                            ;
        addi x30, x30, -16                        ;
        amoswap.w x26, x7, (x30)                  ;
_l170:  sltiu x16, x10, 2047                      ;
_l171:  la x20, d_0_11                            ;
        addi x20, x20, -0                         ;
        lui x13, 0xffe00                          ;
        xor x20, x20, x13                         ;
        amoand.d x9, x13, (x20)                   ;
_l172:  la x12, d_1_9                             ;
        addi x12, x12, -16                        ;
        amomin.d x26, x20, (x12)                  ;
_l173:  la x3, d_5_27                             ;
        addi x3, x3, -16                          ;
        sc.d x22, x3, (x3)                        ;
_l174:  addi x16, x24, 2047                       ;
_l175:  fmsub.s f16, f25, f6, f18, rdn            ;
_l176:  bltu x25, x5, _l181                       ;
_l177:  la x12, d_0_18                            ;
        addi x12, x12, -20                        ;
        amoor.w x25, x23, (x12)                   ;
_l178:  divu x19, x23, x28                        ;
_l179:  la x19, d_1_6                             ;
        lw x11, 4(x19)                            ;
_l180:  remuw x29, x19, x30                       ;
_l181:  xori x25, x26, -1871                      ;
_l182:  la x12, d_3_14                            ;
        addi x12, x12, 8                          ;
        amoor.w x28, x2, (x12)                    ;
_l183:  andi x27, x4, 329                         ;
_l184:  xori x3, x22, 1685                        ;
_l185:  xor x13, x13, x13                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 31                           ;
        add x13, x13, x1                          ;
        csrrc x19, mscratch, x13                  ;
_l186:  ecall                                     ;
_l187:  la x1, _l193                              ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l188:  la x20, d_5_27                            ;
        addi x20, x20, -0                         ;
        lr.d x8, (x20)                            ;
_l189:  la x17, d_3_19                            ;
        addi x17, x17, -16                        ;
        amoxor.d x10, x7, (x17)                   ;
_l190:  mulhu x10, x28, x15                       ;
_l191:  fnmsub.s f0, f7, f15, f22, dyn            ;
_l192:  bge x27, x12, _l200                       ;
_l193:  la x3, d_3_17                             ;
        addi x3, x3, -0                           ;
        amoand.d x13, x18, (x3)                   ;
_l194:  mulhsu x7, x19, x27                       ;
_l195:  la x6, d_0_4                              ;
        addi x6, x6, 8                            ;
        amomin.w x18, x18, (x6)                   ;
_l196:  slti x7, x0, -0                           ;
_l197:  sllw x13, x12, x30                        ;
_l198:  fcvt.s.lu f10, x4, rmm                    ;
_l199:  srai x12, x0, 18                          ;
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
                .dword 0xe70bb672ed33cf24, 0x7fb8b9a67210ecca
                .dword 0x1d960b4cdd651079, 0x76e31c20d88b24d8
d_0_0:          .dword 0x352586b4fb577782, 0x993741fe4a157bb4
d_0_1:          .dword 0xf3c0ef6b186c172b, 0x99984a106f5af0fc
d_0_2:          .dword 0x2f2ad2a79a1e9927, 0x834c225955084608
d_0_3:          .dword 0x35681dcf7a15810d, 0x477c46f4a7047028
d_0_4:          .dword 0x7654c1e70b1dafee, 0x432e71cb82512287
d_0_5:          .dword 0xaa2de61fd68e03ac, 0x6071c6e46c5846af
d_0_6:          .dword 0x6b75ff6b1b218839, 0x06029970539c5d45
d_0_7:          .dword 0x35dec974a3a65ed5, 0x7e60f0cd40742417
d_0_8:          .dword 0x673491d64bdda955, 0x42e3deaf8fa97584
d_0_9:          .dword 0x7f5a5371fd9aa459, 0x41a48efd127baf81
d_0_10:         .dword 0x4e461e48773bd34f, 0x604180aa4076d155
d_0_11:         .dword 0xe2ce8c0b34d5fbc8, 0xcec72e071a8616e2
d_0_12:         .dword 0xd6a3ff8c21c71639, 0x03baf2e8a07f6e51
d_0_13:         .dword 0x8791b36271d8eb48, 0xa55f54623f40b7e0
d_0_14:         .dword 0x930618b5f8f1a782, 0xece6d19933ac8427
d_0_15:         .dword 0x2cfeaa14a762e714, 0x27ef3eadaf8564f8
d_0_16:         .dword 0xec736307e715f5f1, 0x641bcf11f9ff9438
d_0_17:         .dword 0xae056d49eb2489fc, 0x8d9ebe462c2244cc
d_0_18:         .dword 0x1a76733e348dd2d2, 0x9779b3262c2ab51d
d_0_19:         .dword 0xdd90d7f415d588bd, 0x31e9bf4d3f302b8d
d_0_20:         .dword 0xfce93a19efb52596, 0x8aabf7796239b319
d_0_21:         .dword 0x8093b69f2ad2f964, 0xfb152718fc5e08f9
d_0_22:         .dword 0x26e0d21bf929787a, 0x060d357f3f305d16
d_0_23:         .dword 0xb208dffcbe70f822, 0x258282659d7d2adb
d_0_24:         .dword 0x9a433375ac2d6a40, 0xfc82f1998db19860
d_0_25:         .dword 0x007850ba9c740f0d, 0xd17a35b529f73926
d_0_26:         .dword 0x4baf9554b3ba598f, 0x90aa89462584b717
d_0_27:         .dword 0x2b28903b85ac1724, 0x62ec71db22f7f66c
                .dword 0xa9b0808dc2507ea0, 0x46898ef5b77253a0
                .dword 0x29e1a733d4df4392, 0x83992c4fb3093e92
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xb0475d2134ca3874, 0xe6f80c1a4a723df3
                .dword 0x0c159fb6d3c3662a, 0xabbc507e62775823
d_1_0:          .dword 0xa98ee3d64b9db3f7, 0xa993c558f509b2fb
d_1_1:          .dword 0x7d7aeba8e332739d, 0xeb7c41ef21f555ed
d_1_2:          .dword 0x6d035cb991e8fe36, 0xc3343048b4db78bf
d_1_3:          .dword 0x47ac340b176fa4ba, 0xd9fc97ec3f70ec2d
d_1_4:          .dword 0x02d98ceb1e077625, 0xe27e58f11888d948
d_1_5:          .dword 0x2a7291d48db39d6a, 0x1ef7325720c440ca
d_1_6:          .dword 0x207b26c70d12ed05, 0x34d46722c9c01f71
d_1_7:          .dword 0x94f7a63416bfb751, 0x35f9e0043c03872a
d_1_8:          .dword 0xa3789b0f38f4f877, 0x2756132ce7b29cc9
d_1_9:          .dword 0x1b9ca225f8bef938, 0x760e00e8e99d9c66
d_1_10:         .dword 0xe495a7b85b512f1d, 0xa8d1f1f4311592aa
d_1_11:         .dword 0x2052ddea353b405c, 0x87354d1663131f5c
d_1_12:         .dword 0xc3df11f308f80c79, 0xd00742569a4ffcc6
d_1_13:         .dword 0x73a935fbffc60c26, 0x8dc6703c6502f367
d_1_14:         .dword 0x5758abedd854dcc8, 0x98f67d8532dfa7ca
d_1_15:         .dword 0x3a215b9224a81354, 0x137d627e53766be1
d_1_16:         .dword 0x069ec706eb6776a5, 0xfa373e20068f82cb
d_1_17:         .dword 0x7a2769633ab7f221, 0x8fdd4424840a996a
d_1_18:         .dword 0xc1242c0a8d989d1c, 0x6a9b4725199c8748
d_1_19:         .dword 0x893eced00f690725, 0xc993a72b056d014a
d_1_20:         .dword 0x419810dd3431c150, 0x11233f0e34883c40
d_1_21:         .dword 0x6fa6253b74173c38, 0x23e88cf22e05119a
d_1_22:         .dword 0x84ba202e12aaadae, 0xbb2a1b8a786e241d
d_1_23:         .dword 0x8c29fba3eb30653a, 0xbe63249b534a47cd
d_1_24:         .dword 0xf4e578ef28d5c6a4, 0xfbd7493918dd3e97
d_1_25:         .dword 0x404be43fb9775558, 0x2ea37b3f94b233ba
d_1_26:         .dword 0x031994c1a9638455, 0x7093cd9e9624e4e1
d_1_27:         .dword 0x70dc51f594693dd0, 0x0c7c57ea882c7095
                .dword 0x03d9a769358db016, 0x0896e400d74e994a
                .dword 0xcba503a61bd63073, 0x6a7015b1ed03422b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8ca7c1dc36e0e755, 0x74a2c838c0a59353
                .dword 0xa336bb6ad591ebf3, 0xbdfd0e207c94bac4
d_2_0:          .dword 0xbf7904207085f4ff, 0x7d0436453c5c6356
d_2_1:          .dword 0xfff1f7505d33da22, 0x4796f5ed23feba1a
d_2_2:          .dword 0xba26d460c0a358da, 0x95a591dda851a2a0
d_2_3:          .dword 0xb2c25a91dce8245d, 0x87e9bbc074e45b38
d_2_4:          .dword 0x47e3cf9027a29674, 0xb28eb80af8f11c0a
d_2_5:          .dword 0x526d8ecfe4f392b7, 0xb544cfc7cf27b940
d_2_6:          .dword 0xd56a00f9484fb7c8, 0x8dfba353dba429dd
d_2_7:          .dword 0x1a2d4024e33c40d0, 0x014fbf02dd4900b3
d_2_8:          .dword 0x78232d4cc8a56127, 0xf870e3964c0599ef
d_2_9:          .dword 0x5e87c8ff9db37be8, 0xb2c0909c4a6d085f
d_2_10:         .dword 0x67263a04ef84eca0, 0xcef96ce438b35469
d_2_11:         .dword 0xdef4b4f7715690e2, 0x390250342a3551c8
d_2_12:         .dword 0xcab1e87b1193bcbd, 0x4146ddbc82c31824
d_2_13:         .dword 0x103dfc4fb5b4d906, 0xe8801e24a1b8091c
d_2_14:         .dword 0xf411ab42be9c1041, 0xc08bab90deb5813b
d_2_15:         .dword 0x5cff05e9c5952169, 0x7d03af2692730d0f
d_2_16:         .dword 0xcddc347567503728, 0x3e0ce89deef74d0f
d_2_17:         .dword 0x547cd4b7858ed2ad, 0x704debd0d3ee7368
d_2_18:         .dword 0x297de3ab6ff17488, 0xe29ee1aac8cd7e3e
d_2_19:         .dword 0xaf7cf2d9ab1c644f, 0x18ce9f2e331ba1cb
d_2_20:         .dword 0x4efecd8f4d4f84b7, 0x60ee130341032be9
d_2_21:         .dword 0xb54ee3c3f87846fa, 0x5e34ccc69a7521c5
d_2_22:         .dword 0xd2a167cd5456f229, 0x8735fa9079a14167
d_2_23:         .dword 0xe5758fb968869230, 0x36b659d02b4e00c0
d_2_24:         .dword 0x906135dd295111be, 0x642abaf64e0c2d17
d_2_25:         .dword 0xd0a56ec86e69d6b9, 0x540bebecbf4f603b
d_2_26:         .dword 0xf1aab12eaca3be5b, 0xb16aef02d84ddb51
d_2_27:         .dword 0xadc445d6809913b3, 0xb885261a1d26f111
                .dword 0x0b4776e1f461ea49, 0xee07775945496393
                .dword 0x291d4df212ae74aa, 0xaaaa826f0945aec6
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xef6c3085ec735785, 0xeb82a20e7e7ec40a
                .dword 0xb2c5ad7eb60e6493, 0xc4f0f3e610e1f5ee
d_3_0:          .dword 0xf79249162e0a19a6, 0x086aaf9326024564
d_3_1:          .dword 0xfb78b4a556bd0f4b, 0xb22340248587b8d1
d_3_2:          .dword 0x4578be40ecf841a2, 0xce8e3aa180ccea3a
d_3_3:          .dword 0xe5705032ac1dcbf9, 0x79b945e1febef056
d_3_4:          .dword 0xb357f737e0cbcb8a, 0xeeca7a705ed0dd0b
d_3_5:          .dword 0x300a3c1698abba66, 0xf2901075cfa20df6
d_3_6:          .dword 0x2232c38543b0eb49, 0xc3076a1747bd0a34
d_3_7:          .dword 0x5d6a030cdc79c4d6, 0x396bc53798a359e8
d_3_8:          .dword 0x428a76efb0b2361f, 0x51923b59a0777408
d_3_9:          .dword 0x8dae4377a9d3dfad, 0xde3f58d06c307934
d_3_10:         .dword 0x6fb0fe40e4625897, 0x4663e8208faf608e
d_3_11:         .dword 0x2802c5b1cac8817c, 0xa55b6cb5d478a752
d_3_12:         .dword 0xde1e5f43039e4d01, 0x69154fcb782c7970
d_3_13:         .dword 0xe457921a3cde4e15, 0x95b34887929ceb57
d_3_14:         .dword 0xd120c6078fdf0429, 0x6eb893b1728f8a73
d_3_15:         .dword 0x677c3753529eb067, 0x0ef3452d42bc312f
d_3_16:         .dword 0xf34317bc75d60b63, 0x5a7f6770f76b73b0
d_3_17:         .dword 0xf283ffd7cc416a27, 0xe29b9eab42364533
d_3_18:         .dword 0x9a5fc733a1228745, 0xeb1668ce7b6cf403
d_3_19:         .dword 0xddc5c2e0d8dd7c13, 0x5cc7858ceed57825
d_3_20:         .dword 0xa095f65d9c120ddf, 0x022204fa5f697300
d_3_21:         .dword 0xcf5df08d3b94e325, 0x25645abbcd62da42
d_3_22:         .dword 0x26cdda585e8c60a8, 0x68788172852cabf4
d_3_23:         .dword 0x586feaf3d62809d3, 0xbc57f61eb00fd7dd
d_3_24:         .dword 0x21b3453dbe83c106, 0x7a4619252aca6827
d_3_25:         .dword 0x41cab4b091971317, 0x9ffbf687033921b1
d_3_26:         .dword 0xc3fd303c484926c5, 0x7d1e17b5cc09cf04
d_3_27:         .dword 0x5701d941f3a01bcb, 0x726196c4897ba457
                .dword 0x4725ad35e33ea3c2, 0x79b41c02f6eb1796
                .dword 0x004927bed9f46532, 0xc4dca0ec675994eb
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x750ed24a7278eb16, 0x1bdd0abe0c085670
                .dword 0xebeb23e3201529bd, 0x40f02a98d7c3cc5b
d_4_0:          .dword 0x98bbd5b3e941a2f7, 0xf0dc7a8562691ddf
d_4_1:          .dword 0xe7a991a3449080c6, 0x063f716cddde7b0b
d_4_2:          .dword 0x0a089b1d9ee3c2a4, 0xe33f0daed142e4f3
d_4_3:          .dword 0x047a08c2096cbacf, 0xb72124a3a9fa5497
d_4_4:          .dword 0xac98140f499ffa6d, 0xcf47b7f3807d9548
d_4_5:          .dword 0xaa215a8e04b3523a, 0xfd7bfea7b51fd657
d_4_6:          .dword 0xb8626000fa355641, 0x9107b545d87a8b3a
d_4_7:          .dword 0x0da1e42fd9145be5, 0x3e15d4ca6fff01b0
d_4_8:          .dword 0xee482e2f00497929, 0x9db08fdb74fbab16
d_4_9:          .dword 0xc919229ed572ed39, 0xbf31334e2bfa5533
d_4_10:         .dword 0xf972c57400dc1dae, 0x2a4036a8474c0958
d_4_11:         .dword 0x926859b68f0ee490, 0xa63fffe970a30045
d_4_12:         .dword 0x7196133b6753ca02, 0x708bb41909b05f89
d_4_13:         .dword 0x4f140c3387b6bf3a, 0xa8158169c9345d2a
d_4_14:         .dword 0xcda7aa2900b22df4, 0xb982156da928312f
d_4_15:         .dword 0x90dce77804e9f139, 0xa18908a113aca189
d_4_16:         .dword 0x37b8ca90dea4834f, 0xa27ce60fe90c5876
d_4_17:         .dword 0xad471b77ea14f8ad, 0x359d878086defe45
d_4_18:         .dword 0x8f7522aa6e044bde, 0xa06d55ac70628030
d_4_19:         .dword 0x3703a9c7dbf18c31, 0xf657e74413570b6f
d_4_20:         .dword 0x20f86ff6cafe6b66, 0x9202e4e1fb801070
d_4_21:         .dword 0x0dc504887afbbad7, 0x926c0bb12a3c07e6
d_4_22:         .dword 0x5a9793ffd2d77841, 0xc4156f22b20cc99a
d_4_23:         .dword 0x55916eefb0131b1b, 0x00aa6eff50db9fa6
d_4_24:         .dword 0xcd39b356b3f91330, 0x11080180cf78094f
d_4_25:         .dword 0x596d7a1b4c338b2f, 0x4b1be05535d73d4b
d_4_26:         .dword 0xe5960454d8755ec4, 0x28e70616fd6e1765
d_4_27:         .dword 0x22b527da82fcc165, 0x411e7a58ed964c4b
                .dword 0x59d5b8a8bf3c61b7, 0xa4110e9bdb788a30
                .dword 0xcaf6558defc7ed28, 0x442b2461daa9eb95
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x1bb2527634ba5c27, 0x09955a5a5f40db15
                .dword 0x394494d035a41aba, 0x3cbb8595c91b4a30
d_5_0:          .dword 0x43c24b83b875cd75, 0xdc36f95f84a94cc5
d_5_1:          .dword 0x2695c553d346352a, 0x5bb255940339527d
d_5_2:          .dword 0xba7dcf07240911d5, 0xc5b64532a06a4dfa
d_5_3:          .dword 0x63c1f06501fb971d, 0x213b3a438d4df95f
d_5_4:          .dword 0x61ec6ba24eca8a4a, 0x002d319ae15f9dc8
d_5_5:          .dword 0x8372bd1862d11ca1, 0x2f44d521fe8c6647
d_5_6:          .dword 0x5201de92da157f18, 0x4acd9fda69b20d87
d_5_7:          .dword 0x5bb0e0ee2e054dd1, 0x50e562b4d7028744
d_5_8:          .dword 0xaea6d0866b8e867c, 0x3bae125c15ca15b9
d_5_9:          .dword 0x8b079c1f0b3f905e, 0x1dcd2a1d37d44523
d_5_10:         .dword 0x53943e91b29057df, 0xdc6949997fcb8b4f
d_5_11:         .dword 0x41632ce005b39103, 0x54211fdbfe46a40d
d_5_12:         .dword 0x86bf73aa345b076d, 0x944944b8e11b89f5
d_5_13:         .dword 0x6ca232fcc5b7bb7c, 0x2edc573b644007a6
d_5_14:         .dword 0xe4fe9cc071c8eb13, 0x4b0b8266a061a55a
d_5_15:         .dword 0xdc1122d6ce20eaec, 0x84ead178140897db
d_5_16:         .dword 0x8fe755d453c30a6b, 0x9b2d008d96f06f2c
d_5_17:         .dword 0x414f078d9b96067f, 0x2b445e667096302e
d_5_18:         .dword 0x85a7278a8052300f, 0x12df221b649c1193
d_5_19:         .dword 0x861b9b62bf56f6e2, 0xb20b09426fdd1edc
d_5_20:         .dword 0xa8f21adab315b138, 0xe0f655c245857dc9
d_5_21:         .dword 0x5f9197ded7db39ab, 0x46a216809311d19a
d_5_22:         .dword 0x7e6635d79ed00e7a, 0xb0c608fd228b09da
d_5_23:         .dword 0x9eaff517738b12b1, 0xe510bdf484d40bbf
d_5_24:         .dword 0xa240f36140186544, 0xdbc581c46674c6ba
d_5_25:         .dword 0xf48fed4f50e8e14f, 0xa221af5780887dc3
d_5_26:         .dword 0x77a670855a02fcc4, 0x047315811c130308
d_5_27:         .dword 0x58c35e96c3972f05, 0x83f2b0874b5efd38
                .dword 0x276128b80e452d35, 0x2ca09cdbdb9ec772
                .dword 0xf4b2a5a2d719763e, 0x9f5cbfac085fd1f7
         /* Random data */
_end_data5:
              
                 
