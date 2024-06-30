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
_s0:    remuw x8, x7, x13                         ;
_s1:    ebreak                                    ;
_s2:    rem x24, x0, x8                           ;
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
_p0:    csrrsi x10, scause, 31                    ;
_p1:    xor x12, x12, x12                         ;
        csrrc x11, mie, x12                       ;
_p2:    la x11, d_2_10                            ;
        srai x11, x11, 1                          ;
        csrrc x10, pmpaddr6, x11                  ;
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
_l0:    fclass.s x2, f22                          ;
_l1:    mulh x21, x14, x13                        ;
_l2:    mulhu x21, x18, x4                        ;
_l3:    srlw x15, x10, x10                        ;
_l4:    srli x18, x24, 46                         ;
_l5:    la x14, d_1_24                            ;
        addi x14, x14, -8                         ;
        amoand.d x11, x19, (x14)                  ;
_l6:    fsgnj.s f9, f7, f24                       ;
_l7:    fnmadd.s f14, f11, f12, f1, rmm           ;
_l8:    subw x11, x9, x17                         ;
_l9:    la x2, d_4_21                             ;
        addi x2, x2, 8                            ;
        amoxor.d x23, x5, (x2)                    ;
_l10:   fmul.s f19, f4, f15, rne                  ;
_l11:   la x5, _l143                              ;
        ld x22, -8(x5)                            ;
_l12:   sraw x17, x2, x6                          ;
_l13:   fcvt.s.w f10, x5, rtz                     ;
_l14:   la x4, d_4_3                              ;
        sb x28, -0(x4)                            ;
_l15:   fadd.s f17, f7, f7, rne                   ;
_l16:   la x26, d_5_25                            ;
        lhu x17, -14(x26)                         ;
_l17:   la x19, d_4_4                             ;
        lw x18, 8(x19)                            ;
_l18:   fmv.x.w x19, f28                          ;
_l19:   fnmsub.s f0, f8, f14, f6, rup             ;
_l20:   ecall                                     ;
_l21:   xor x23, x23, x23                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 20                         ;
        add x23, x23, x29                         ;
        csrrc x18, stval, x23                     ;
_l22:   div x30, x1, x3                           ;
_l23:   srliw x20, x19, 8                         ;
_l24:   la x4, d_5_21                             ;
        addi x4, x4, 0                            ;
        amoxor.d x22, x18, (x4)                   ;
_l25:   la x18, _l118                                     ;
        jalr x27, 0(x18)                          ;
_l26:   fmadd.s f27, f30, f28, f28, dyn           ;
_l27:   la x13, d_0_1                             ;
        fsw f9, -28(x13)                          ;
_l28:   la x18, d_5_22                            ;
        addi x18, x18, 28                         ;
        lui x30, 0xffe00                          ;
        xor x18, x18, x30                         ;
        sc.w x5, x30, (x18)                       ;
_l29:   la x3, d_3_4                              ;
        addi x3, x3, -16                          ;
        amoxor.w x21, x11, (x3)                   ;
_l30:   la x13, d_5_10                            ;
        addi x13, x13, -20                        ;
        amoxor.w x3, x30, (x13)                   ;
_l31:   la x29, d_2_18                            ;
        ld x18, -24(x29)                          ;
_l32:   fdiv.s f19, f17, f24, rup                 ;
_l33:   fmadd.s f23, f11, f31, f18, rne           ;
_l34:   la x2, _l95                                       ;
        jalr x28, 0(x2)                           ;
_l35:   fmadd.s f6, f30, f6, f12, rdn             ;
_l36:   la x11, d_4_1                             ;
        addi x11, x11, 8                          ;
        amoor.d x8, x5, (x11)                     ;
_l37:   mulhu x18, x28, x1                        ;
_l38:   csrrsi x8, pmpaddr7, 0                    ;
_l39:   fclass.s x9, f31                          ;
_l40:   rem x8, x19, x17                          ;
_l41:   sraw x1, x5, x9                           ;
_l42:   ecall                                     ;
_l43:   fcvt.wu.s x29, f22, rmm                   ;
_l44:   bne x16, x5, _l95                                 ;
_l45:   fmin.s f16, f2, f31                       ;
_l46:   flt.s x30, f30, f3                        ;
_l47:   la x27, d_2_26                            ;
        addi x27, x27, 16                         ;
        amomax.w x26, x16, (x27)                  ;
_l48:   andi x24, x0, 1634                        ;
_l49:   fle.s x7, f22, f30                        ;
_l50:   sltiu x6, x10, 0                          ;
_l51:   la x13, d_4_20                            ;
        addi x13, x13, 0                          ;
        amominu.d x30, x10, (x13)                 ;
_l52:   la x6, d_5_6                              ;
        addi x6, x6, -8                           ;
        amomaxu.d x26, x11, (x6)                  ;
_l53:   fence                                     ;
_l54:   fsqrt.s f14, f26, rne                     ;
_l55:   fmin.s f17, f30, f27                      ;
_l56:   fcvt.s.lu f2, x26, rup                    ;
_l57:   fsqrt.s f2, f5, rne                       ;
_l58:   fence.i                                   ;
_l59:   csrrsi x10, mip, 31                       ;
_l60:   la x13, _l185                                      ;
        jalr x27, 0(x13)                          ;
_l61:   xori x29, x23, 0                          ;
_l62:   la x19, d_4_15                            ;
        addi x19, x19, 24                         ;
        amomaxu.w x29, x9, (x19)                  ;
_l63:   li x1, 1                                  ;
        la x2, pt2                                ;
        addi x2, x2, 0                            ;
        sfence.vma x1, x2                         ;
_l64:   addiw x23, x17, -1526                     ;
_l65:   fmul.s f24, f11, f25, rup                 ;
_l66:   div x0, x30, x1                           ;
_l67:   la x19, _l185                                     ;
        csrrw zero, mepc, x19                     ;
        mret                                      ;
_l68:   flt.s x0, f21, f9                         ;
_l69:   bgeu x21, x2, _l129                               ;
_l70:   fadd.s f14, f22, f4, dyn                  ;
_l71:   fsgnjx.s f0, f29, f12                     ;
_l72:   la x2, _l138                                      ;
        csrrw zero, sepc, x2                      ;
        sret                                      ;
_l73:   la x7, d_3_25                             ;
        addi x7, x7, -0                           ;
        lui x13, 0xffe00                          ;
        xor x7, x7, x13                           ;
        amoand.d x3, x13, (x7)                    ;
_l74:   divw x17, x12, x25                        ;
_l75:   srlw x29, x7, x0                          ;
_l76:   csrrsi x16, mscratch, 7                   ;
_l77:   slli x0, x9, 20                           ;
_l78:   fsub.s f8, f5, f8, rdn                    ;
_l79:   la x17, _l113                                      ;
        csrrw zero, mepc, x17                     ;
        mret                                      ;
_l80:   sltiu x2, x8, 276                         ;
_l81:   ecall                                     ;
_l82:   xor x24, x24, x24                         ;
        addi x17, zero, 3                         ;
        slli x17, x17, 29                         ;
        add x24, x24, x17                         ;
        addi x5, zero, 3                          ;
        slli x5, x5, 14                           ;
        add x24, x24, x5                          ;
        addi x19, zero, 1                         ;
        slli x19, x19, 30                         ;
        add x24, x24, x19                         ;
        csrrc x20, scause, x24                    ;
_l83:   divu x20, x28, x17                        ;
_l84:   la x27, d_2_5                             ;
        lhu x2, 10(x27)                           ;
_l85:   lui x26, 10                               ;
_l86:   andi x7, x2, 225                          ;
_l87:   fcvt.s.w f22, x10, rdn                    ;
_l88:   fclass.s x13, f3                          ;
_l89:   srlw x27, x7, x21                         ;
_l90:   srlw x2, x26, x26                         ;
_l91:   srliw x4, x5, 0                           ;
_l92:   srliw x22, x23, 3                         ;
_l93:   divuw x30, x17, x2                        ;
_l94:   la x9, _l118                                      ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l95:   srliw x5, x7, 20                          ;
_l96:   fcvt.lu.s x9, f19, rtz                    ;
_l97:   la x16, _l165                                     ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l98:   la x11, d_1_20                            ;
        addi x11, x11, -16                        ;
        lui x7, 0xffe00                           ;
        xor x11, x11, x7                          ;
        amomaxu.w x11, x7, (x11)                  ;
_l99:   la x25, d_3_4                             ;
        addi x25, x25, -0                         ;
        amoswap.w x4, x8, (x25)                   ;
_l100:  fsgnjx.s f29, f10, f19                    ;
_l101:  la x18, d_2_4                             ;
        lw x22, -0(x18)                           ;
_l102:  srliw x5, x13, 26                         ;
_l103:  mulw x16, x17, x4                         ;
_l104:  la x5, _l111                                       ;
        lh x8, 30(x5)                             ;
_l105:  fsgnj.s f25, f31, f28                     ;
_l106:  beq x6, x17, _l109                        ;
_l107:  la x7, d_5_19                             ;
        addi x7, x7, -12                          ;
        amoand.w x15, x15, (x7)                   ;
_l108:  remw x2, x14, x18                         ;
_l109:  remuw x2, x24, x2                         ;
_l110:  mul x16, x8, x25                          ;
_l111:  addw x12, x21, x24                        ;
_l112:  jal x16, _l150                                    ;
_l113:  sraw x11, x28, x23                        ;
_l114:  la x19, d_5_10                            ;
        addi x19, x19, 24                         ;
        amoand.d x10, x19, (x19)                  ;
_l115:  la x15, d_0_26                            ;
        addi x15, x15, 28                         ;
        lui x16, 0xffe00                          ;
        xor x15, x15, x16                         ;
        amoadd.w x5, x16, (x15)                   ;
_l116:  fsgnj.s f3, f22, f3                       ;
_l117:  fmin.s f30, f4, f4                        ;
_l118:  la x18, d_4_2                             ;
        addi x18, x18, -16                        ;
        amoand.d x10, x20, (x18)                  ;
_l119:  divuw x13, x11, x23                       ;
_l120:  la x20, d_4_17                            ;
        addi x20, x20, 0                          ;
        amoswap.d x21, x16, (x20)                 ;
_l121:  fnmsub.s f16, f7, f16, f2, rup            ;
_l122:  la x14, _l123                             ;
        csrrw zero, sepc, x14                     ;
        sret                                      ;
_l123:  srai x28, x26, 4                          ;
_l124:  subw x13, x1, x1                          ;
_l125:  fence                                     ;
_l126:  divw x12, x24, x28                        ;
_l127:  divuw x27, x25, x26                       ;
_l128:  slliw x4, x20, 14                         ;
_l129:  remuw x1, x8, x14                         ;
_l130:  la x16, d_4_3                             ;
        addi x16, x16, 16                         ;
        amomaxu.d x9, x18, (x16)                  ;
_l131:  la x13, d_4_11                            ;
        addi x13, x13, -12                        ;
        amoor.w x27, x19, (x13)                   ;
_l132:  srli x9, x13, 5                           ;
_l133:  fence                                     ;
_l134:  la x10, d_1_20                            ;
        addi x10, x10, -16                        ;
        amoand.d x21, x13, (x10)                  ;
_l135:  la x8, d_4_27                             ;
        addi x8, x8, -0                           ;
        amoswap.d x23, x8, (x8)                   ;
_l136:  li x25, 0                                 ;
        la x7, pt3                                ;
        addi x7, x7, 40                           ;
        sfence.vma x25, x7                        ;
_l137:  remuw x15, x9, x22                        ;
_l138:  flt.s x26, f24, f30                       ;
_l139:  slliw x11, x20, 10                        ;
_l140:  la x19, d_5_11                            ;
        lw x14, -16(x19)                          ;
_l141:  ebreak                                    ;
_l142:  fcvt.lu.s x12, f0, dyn                    ;
_l143:  mulhsu x6, x6, x23                        ;
_l144:  divuw x1, x4, x0                          ;
_l145:  slli x18, x28, 0                          ;
_l146:  mulw x14, x13, x12                        ;
_l147:  fcvt.wu.s x27, f25, rup                   ;
_l148:  feq.s x20, f29, f30                       ;
_l149:  fmul.s f16, f20, f9, rtz                  ;
_l150:  remw x5, x27, x15                         ;
_l151:  fle.s x23, f10, f11                       ;
_l152:  la x11, d_0_9                             ;
        addi x11, x11, -8                         ;
        amoxor.d x19, x11, (x11)                  ;
_l153:  fcvt.s.w f31, x10, rdn                    ;
_l154:  xori x15, x20, -1319                      ;
_l155:  auipc x5, 24                              ;
_l156:  remw x20, x6, x11                         ;
_l157:  sltiu x14, x30, 4                         ;
_l158:  la x18, d_5_21                            ;
        lb x29, 0(x18)                            ;
_l159:  la x23, d_3_16                            ;
        addi x23, x23, 0                          ;
        amoxor.w x21, x26, (x23)                  ;
_l160:  la x22, _l189                                     ;
        csrrw zero, uepc, x22                     ;
        uret                                      ;
_l161:  la x12, d_1_7                             ;
        sw x5, -0(x12)                            ;
_l162:  fclass.s x16, f23                         ;
_l163:  la x5, d_2_22                             ;
        addi x5, x5, 4                            ;
        lui x20, 0xffe00                          ;
        xor x5, x5, x20                           ;
        amomaxu.w x19, x20, (x5)                  ;
_l164:  fmv.w.x f18, x11                          ;
_l165:  divu x21, x1, x9                          ;
_l166:  remuw x0, x7, x20                         ;
_l167:  beq x3, x25, _l198                        ;
_l168:  fnmadd.s f31, f8, f18, f4, rtz            ;
_l169:  fmsub.s f24, f3, f8, f12, dyn             ;
_l170:  fmsub.s f5, f26, f11, f25, dyn            ;
_l171:  la x19, d_2_21                            ;
        addi x19, x19, 8                          ;
        amoor.d x4, x11, (x19)                    ;
_l172:  la x28, d_4_13                            ;
        addi x28, x28, -28                        ;
        amominu.w x5, x19, (x28)                  ;
_l173:  la x8, d_2_20                             ;
        fsw f2, -28(x8)                           ;
_l174:  ecall                                     ;
_l175:  la x4, d_0_18                             ;
        addi x4, x4, 28                           ;
        amoxor.w x26, x15, (x4)                   ;
_l176:  slliw x0, x12, 1                          ;
_l177:  la x27, d_4_15                            ;
        lw x24, 4(x27)                            ;
_l178:  la x13, _l198                                     ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l179:  remu x3, x27, x16                         ;
_l180:  la x18, d_5_19                            ;
        lui x16, 0xffe00                          ;
        xor x18, x18, x16                         ;
        flw f13, 4(x18)                           ;
_l181:  beq x1, x6, _l185                         ;
_l182:  rem x13, x7, x11                          ;
_l183:  sllw x23, x28, x21                        ;
_l184:  fence.i                                   ;
_l185:  remuw x27, x6, x23                        ;
_l186:  fnmsub.s f16, f4, f10, f21, rmm           ;
_l187:  fence                                     ;
_l188:  fcvt.w.s x2, f10, dyn                     ;
_l189:  la x19, d_2_4                             ;
        sw x6, -12(x19)                           ;
_l190:  fnmsub.s f13, f21, f0, f6, rup            ;
_l191:  sllw x10, x8, x29                         ;
_l192:  la x29, d_4_13                            ;
        addi x29, x29, -24                        ;
        amoadd.w x5, x8, (x29)                    ;
_l193:  rem x30, x25, x5                          ;
_l194:  xori x5, x29, -1280                       ;
_l195:  fence.i                                   ;
_l196:  la x25, d_5_26                            ;
        addi x25, x25, 4                          ;
        amomin.w x15, x18, (x25)                  ;
_l197:  la x20, d_5_7                             ;
        addi x20, x20, -8                         ;
        amoxor.d x16, x8, (x20)                   ;
_l198:  la x1, d_0_11                             ;
        lwu x22, -12(x1)                          ;
_l199:  mul x8, x8, x11                           ;
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
                .dword 0xe7b8bcee918fc0dd, 0xc32eede52f0cf9d9
                .dword 0x33c30813537d5d0e, 0xbe4ef8436b6255ba
d_0_0:          .dword 0x742c661056ad6e43, 0x65afcecf0fff93d6
d_0_1:          .dword 0x70b47a0a0e4c1ba0, 0x8ce419c4ccc72270
d_0_2:          .dword 0xe5458cdffbcd6a72, 0x42630824fad0d685
d_0_3:          .dword 0x06ac23868927f1c2, 0x519db03c46746432
d_0_4:          .dword 0x583391e020ca7e14, 0x6504714a4f15c0c1
d_0_5:          .dword 0x566687f4015818cb, 0x9847c7fbecf6c74f
d_0_6:          .dword 0x9716bea3e5a4f5f1, 0x74f6463f852d652f
d_0_7:          .dword 0x17039ad1c1d61139, 0x1fa89c2d78aed9cb
d_0_8:          .dword 0x7067e1d9166fb600, 0x6cd22822ed7fc576
d_0_9:          .dword 0x91f5f7e10737fe62, 0xf929ed2ecac1f6b8
d_0_10:         .dword 0x44a2844955ff1c80, 0x169d3049481c30f1
d_0_11:         .dword 0x95767b1ec8171ab2, 0x8371aad3d5195bf0
d_0_12:         .dword 0x24b92271279dad43, 0x0c816c90c3cfe852
d_0_13:         .dword 0x7fcad8569bfe3edf, 0xb70896fc150645ab
d_0_14:         .dword 0xcff36660fa28b514, 0x051610b085fcec6e
d_0_15:         .dword 0x77e8fa4c9177b207, 0x43275473a4922016
d_0_16:         .dword 0x940bf1c849fbcbd9, 0x4965d42db6aa87c8
d_0_17:         .dword 0x438ee3acbd9283c2, 0x95e64354d896ff97
d_0_18:         .dword 0x1869d1f3aed06f3e, 0x6b3c487dd5c91d95
d_0_19:         .dword 0x0f696339162a24da, 0x56b92fcd26ad1ccc
d_0_20:         .dword 0xf9920ff06a9b5170, 0x00c95c0018df9305
d_0_21:         .dword 0xe8457cb5aeb9ef50, 0x16f034131b1fa9a8
d_0_22:         .dword 0xda30e7e6cd5a429e, 0x0922e7376b523226
d_0_23:         .dword 0xee726db3b7d6305b, 0xb780c3733233204e
d_0_24:         .dword 0x6a1d06358a160def, 0x6e07d9ecf141c475
d_0_25:         .dword 0x312257799ee9b3ad, 0x3584fbf08c61197e
d_0_26:         .dword 0x7cdc1d12f84c98dc, 0xd44a1a3274967786
d_0_27:         .dword 0xc21aea82c5f4df71, 0x97f99b47eaf60ebe
                .dword 0xddfc5d8ab1a456f3, 0x364b044432501fa9
                .dword 0x63fd14f8768550d8, 0xa5f196f8e5cbaadd
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x055f95d081f29f61, 0x020d3fc8a86d1bc3
                .dword 0x5fe4e386f40543cf, 0xdd84efbbe62516a0
d_1_0:          .dword 0xa2bd1935819a4ffa, 0xa341f23f541821d2
d_1_1:          .dword 0x06238faa35a176ec, 0x7e7df38e5e909fb5
d_1_2:          .dword 0xb7b4e338a2a9db07, 0x3fac2d596460dff6
d_1_3:          .dword 0xbac8cb55b2d4517c, 0x110298ed7c42125a
d_1_4:          .dword 0xd3b2a20f07f57956, 0x730b6f2513c2ea66
d_1_5:          .dword 0xc1f9b0b5542684ec, 0x2e6ae4b828c16668
d_1_6:          .dword 0xaeeda1a313261e6d, 0xd179aba17d081cf5
d_1_7:          .dword 0x6f2676c5daf00ccd, 0x492836d07aa1e8f8
d_1_8:          .dword 0x2fe7a6f18f8eb62a, 0xdd93f22c86fb7555
d_1_9:          .dword 0x4355661af077e3de, 0x22f4784d123abe9b
d_1_10:         .dword 0x3afc4b42c0416818, 0x35467d05efe92fb7
d_1_11:         .dword 0xbdcbffcff3612632, 0x0b44a2e521e97833
d_1_12:         .dword 0x4b85440f69cc003c, 0xe1858b72f69d243c
d_1_13:         .dword 0x0b5a5bc4188ad4f8, 0xd22910adf744c8a6
d_1_14:         .dword 0x05203ed50fe9da9a, 0x6f638783ba15e501
d_1_15:         .dword 0xbc7550844f3eaeba, 0x8d16da765a2b6c3f
d_1_16:         .dword 0x10b6a1827decab8f, 0x0b891bb3a7a0c4fa
d_1_17:         .dword 0xb7373ccd2e9e6f9c, 0x3265248b133cbfa8
d_1_18:         .dword 0x700f896617cfe806, 0xd4d30b67e46a4231
d_1_19:         .dword 0x9e850d756d4ce82c, 0x9536fef60019ef14
d_1_20:         .dword 0x40be56e69eab6b6a, 0x0a561db8a2e68ca6
d_1_21:         .dword 0x6cd0c4d124d91230, 0x9d3fdba6205e1faa
d_1_22:         .dword 0x30005395c8aba8b8, 0x5f38686201b50e51
d_1_23:         .dword 0xf0ebaadb44f68f10, 0x51cfd15740d74d5a
d_1_24:         .dword 0x46a550d31ec3fdb8, 0xb12baa0aec67f42a
d_1_25:         .dword 0x392d67559181a140, 0x3fa0f6f313ad3754
d_1_26:         .dword 0xbe86b617a90cba52, 0x86131ab4ae7b46ac
d_1_27:         .dword 0x90b6bb383680bf40, 0xc879aa1feaec0c84
                .dword 0x3cf7680b9a37669a, 0x546718b6b48487d6
                .dword 0x310daf3ca31d73e6, 0x0026901886cc2191
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd209c1407a809c65, 0xff661072d6b39856
                .dword 0xe4f421bc7a860d64, 0x5f3f6059792cc059
d_2_0:          .dword 0x87a0f7932b320a7a, 0xd6488e49d8f612c4
d_2_1:          .dword 0xa1b2454b7ad8d19d, 0xa4a7687620751796
d_2_2:          .dword 0x02cc377b48d066f5, 0x7a02b0c7f85b25c4
d_2_3:          .dword 0x16d72172fb19d382, 0x1d46521f46d628ea
d_2_4:          .dword 0x11c0fa594929d295, 0x4bbbaa05fbe2ba28
d_2_5:          .dword 0x9a075f64816d511b, 0x9e5702462c6cdf0c
d_2_6:          .dword 0x27b7bb2274791c6b, 0x68c18f3e2f079026
d_2_7:          .dword 0x615e729cf23ad35b, 0x47a9d8038a2427f2
d_2_8:          .dword 0xa760b1cc256bb042, 0x02b848139a4ed13c
d_2_9:          .dword 0x5c8179812915caca, 0xa29b5324879fc204
d_2_10:         .dword 0x3368d2fa29ad0875, 0x2cf5505e5f3d16e1
d_2_11:         .dword 0x54913008e2fda03f, 0x52c0d5c792fd66a8
d_2_12:         .dword 0x2650a9ecd0731911, 0x52a4a27ad408a905
d_2_13:         .dword 0xcd2884eb47c043cf, 0xd1c63a5808331b49
d_2_14:         .dword 0x6c1bbad9fcef8710, 0xd03a86de377ca27d
d_2_15:         .dword 0x9c441767eb6320bd, 0x83fd209a61dd6da1
d_2_16:         .dword 0x3c7df03e41622d18, 0x603860ccbb775500
d_2_17:         .dword 0x79b84d4bfe51f725, 0x3c204cfa1971b7b9
d_2_18:         .dword 0x569022927e8e1b98, 0x768a1d50d8394860
d_2_19:         .dword 0x48d82966e07432d3, 0x66a9bd1c8385ea99
d_2_20:         .dword 0x05202ed3c69423a3, 0x1ca082834278ef1b
d_2_21:         .dword 0xa09dafd01f1a5e5f, 0xa32948f369a04a55
d_2_22:         .dword 0x5a56d4bce2d1a507, 0xca02c3605896af23
d_2_23:         .dword 0x126be2b0e6cd3616, 0xf071f590c63284f1
d_2_24:         .dword 0xc16323a798c6735a, 0xb4bfce52b57caaa5
d_2_25:         .dword 0xd6121c8f585faefe, 0x6eed0850417ff23e
d_2_26:         .dword 0x7ec8aed4712ec6e5, 0x2407d857f2d8c493
d_2_27:         .dword 0xb8f934ec03940a20, 0xfb1de085710ba7f0
                .dword 0x67e1dc666bd65e61, 0x6df0f1c66abc6e78
                .dword 0xa1e08ee82ab2bcbb, 0x9e6b5c114dc34eb4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x0c081428530bb59a, 0xf7c06cab862afb6e
                .dword 0xd25344a20c586b38, 0x0e4e8567affa4aaa
d_3_0:          .dword 0x29a925b175d70919, 0x8e1fbbd879c3900b
d_3_1:          .dword 0x70d97128acef16c9, 0x7b69953f333692d1
d_3_2:          .dword 0x79e80da60816b177, 0xe61cc62d382a5ece
d_3_3:          .dword 0xba1e6f652f95f2d1, 0xcb2659351ba19ecd
d_3_4:          .dword 0x8c1f0be897b86c78, 0xbc34c48a7c718b6d
d_3_5:          .dword 0xaaa3c0c2263f01fb, 0xbaf68b78e1673d4c
d_3_6:          .dword 0x11dc92d8cb2fe691, 0xef1617ad4a530bbd
d_3_7:          .dword 0x2d453bff5e773858, 0xe6a6a3ac963ce1df
d_3_8:          .dword 0xd9db61b68d6d394c, 0xd47a70dcd7a0b2f1
d_3_9:          .dword 0xc6ca9ac24918dcf8, 0xf5a32e849a3d1136
d_3_10:         .dword 0xd7decb1b8c793aec, 0x54337c3dce8e5a11
d_3_11:         .dword 0x93d4048d76b52267, 0x7fc34a4d70bed021
d_3_12:         .dword 0x479161b3b20ff383, 0x6462269b319b5742
d_3_13:         .dword 0x5bdcba7c8b7329a7, 0xf45474706d9c88eb
d_3_14:         .dword 0xa459aedf9ed03825, 0x4d703faa5e46b42b
d_3_15:         .dword 0xa28fd7a8dca2e957, 0xa517b3298d14ed8a
d_3_16:         .dword 0x669a4e08630d871a, 0xa707ffa89a3a1676
d_3_17:         .dword 0xdbd11a4d535b4225, 0x69f69e8c7e47ce0d
d_3_18:         .dword 0x40e83ac2a2487f39, 0x6d4cc426356fc8b4
d_3_19:         .dword 0x1e7225ca1a3c7ef3, 0x87474fd05cbe6f17
d_3_20:         .dword 0xf2d71f3a374da65e, 0xcd215a1efc605972
d_3_21:         .dword 0xda72a8411025c1ec, 0x3f94bb4b792e3d6b
d_3_22:         .dword 0xa8717eb3573da1eb, 0x414e39f91dab870a
d_3_23:         .dword 0x5e29f960ad814e02, 0x008806ebbbc1141d
d_3_24:         .dword 0xd28eb4e6ce81fa87, 0x6c657ff312e7f146
d_3_25:         .dword 0xb371ac22ec10ea46, 0xeaddb8997f6344ed
d_3_26:         .dword 0x615868cae574b3dc, 0x238295469091409a
d_3_27:         .dword 0x996bee43d84cfa73, 0x578d558837227157
                .dword 0x81789a64536860ad, 0xff1073107b87211f
                .dword 0x650953ebcfcf3ada, 0xe8bd9955f01bfc1d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0c534d786db144d6, 0x357ac59a8014efd9
                .dword 0xdc8de30ebdf00c62, 0x53652400772f9949
d_4_0:          .dword 0x49626cb668190f31, 0x6e8263225f014721
d_4_1:          .dword 0xe9382d159671ff14, 0x77de3aaf132cd950
d_4_2:          .dword 0x287621f391879dff, 0x8d2e906b14fda52c
d_4_3:          .dword 0xe8896a72a8fbf8d4, 0xee7bf04aaaea8370
d_4_4:          .dword 0x108ee59e1bcd9fe4, 0x8d29509f00d169e8
d_4_5:          .dword 0x923be5a2fbd61216, 0x657c40d4f03ac424
d_4_6:          .dword 0xf49b265f5b84f089, 0xd79b900760210bf6
d_4_7:          .dword 0x90dd073b2354bb44, 0x32793c8be87c492f
d_4_8:          .dword 0xa81751e8aa705d65, 0x9edc5c5986d45af7
d_4_9:          .dword 0x6ac3872579a8f4fc, 0xc60d2bcd041dbfcf
d_4_10:         .dword 0xdfc6d53f1cc5ac2c, 0xd3c40fcf9ff7976d
d_4_11:         .dword 0xe9378a8220c39acc, 0xeb3176399a88e59a
d_4_12:         .dword 0x4dd86793374b61b2, 0x4f42201a2f1cc71e
d_4_13:         .dword 0x15729a72edc48be4, 0xa0e237b75c6a183d
d_4_14:         .dword 0x92c8e230228a5469, 0xb71820d6e407e401
d_4_15:         .dword 0x49d032c6429bc238, 0x326fe94fcda8f774
d_4_16:         .dword 0xa497111cf27bc9e3, 0x50310f8247e34144
d_4_17:         .dword 0x9ed88b5fa9f87ad6, 0xe58244bfb9113c74
d_4_18:         .dword 0xdc4197c676d6b70d, 0x4adc7a20db5df6ca
d_4_19:         .dword 0x3c3c1b037979bf72, 0x8c261285343231b7
d_4_20:         .dword 0xf92684ae0a586d5e, 0x62ba0a55c9ed0e55
d_4_21:         .dword 0x2f4f0618e6386bf8, 0xe067bffdce678a30
d_4_22:         .dword 0x449e4ee4b15481de, 0xcb47f1987919fa4d
d_4_23:         .dword 0xcdeae982d8a52c78, 0x881094ab42b2cd08
d_4_24:         .dword 0x41fc2223ae966588, 0xd3fcdc0898ee3c7e
d_4_25:         .dword 0x3edc7e53c4161bb1, 0xd4cce638d910fd11
d_4_26:         .dword 0xa499223406438d33, 0x4ebf8d3b97fa6e49
d_4_27:         .dword 0x0d9d0b83fc7c2fa5, 0x17e7899cefc47b83
                .dword 0x8ff40aa590cc0fa7, 0x23e7cedca57cea64
                .dword 0x4f604c355ade752b, 0x5f23c43c0f092e58
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x1eb7d5125780cf30, 0x549b973f65e8db56
                .dword 0x781111c56dd3f4b6, 0x73f5e342635e0995
d_5_0:          .dword 0x0340d05377746e04, 0x6d29608b90c5eb96
d_5_1:          .dword 0x9e7a614629261a24, 0xd3aadf5a640b2fc1
d_5_2:          .dword 0x39da64feec674e83, 0xc3567e8b973802a3
d_5_3:          .dword 0x539d3352f03bfa7c, 0xd68577aee0bf1342
d_5_4:          .dword 0x8903aeeed2d6a3b9, 0x4b68a39dca30994f
d_5_5:          .dword 0x50e790e9b991351e, 0xa8057cb4dea3c3b2
d_5_6:          .dword 0x9e9b3c36e5a7cdbf, 0x026971ce6da0ce46
d_5_7:          .dword 0x8dd208fcf75c984f, 0x0986f0b1c9b7ddba
d_5_8:          .dword 0x4302110936ff3dd5, 0x007591b42c647beb
d_5_9:          .dword 0x4ca00fa6e00db317, 0x11f22af5552bc46e
d_5_10:         .dword 0x6365a8ba7d92e639, 0x68804cf67968bf83
d_5_11:         .dword 0x721eedc1ac896816, 0xbf48ee77b69666fe
d_5_12:         .dword 0x1d7eed7ee2bc2da2, 0x903a3b21af5df287
d_5_13:         .dword 0xe761805fdcb4b35f, 0x278fa72ff7f41495
d_5_14:         .dword 0xd8dc4621bb388c8b, 0x61b00e6a88d5f11b
d_5_15:         .dword 0xd69970869b13e2bb, 0x74dce91aaab90a4a
d_5_16:         .dword 0x4060079aa3db8106, 0x56df6fa6aae19a88
d_5_17:         .dword 0xd721a864972e5d0e, 0x5ab2411d7c577f1d
d_5_18:         .dword 0x0f972df1bbcf6274, 0xdbf5bfffab14bf06
d_5_19:         .dword 0xfd907c98538e4b35, 0x25f7776ff3d3f2fb
d_5_20:         .dword 0x56c02dc3a7238d9d, 0x7068a2949057332e
d_5_21:         .dword 0x75d39ce691bc5550, 0x20b3e21cbc005aa4
d_5_22:         .dword 0x4e8bbf48c7a8204f, 0x0912c810098e39ef
d_5_23:         .dword 0xafe5575e25380421, 0xf6ee29783581cad0
d_5_24:         .dword 0x5d6c16fb3dea4583, 0x84a70b2f0e9f8c66
d_5_25:         .dword 0x341c7e2568f14dc4, 0x5d9151d44c9d9f94
d_5_26:         .dword 0xc06ca4ef205f823b, 0x8c974c4e222b24a8
d_5_27:         .dword 0xb95994bb40500955, 0x62d3a5d87f55e571
                .dword 0x220f9a12e84abb8e, 0x0cebd9e8ba2935f3
                .dword 0x3cd0af292b867fc0, 0xac075ca17dd24fef
         /* Random data */
_end_data5:
              
                 
