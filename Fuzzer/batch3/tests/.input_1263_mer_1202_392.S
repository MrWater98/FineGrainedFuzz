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
_s0:    la x23, _s3                                       ;
        csrrw zero, sepc, x23                     ;
        sret                                      ;
_s1:    la x22, d_0_27                            ;
        addi x22, x22, -16                        ;
        amoxor.w x24, x11, (x22)                  ;
_s2:    fcvt.wu.s x15, f20, rtz                   ;
_s3:    fmadd.s f1, f25, f2, f10, rtz             ;
_s4:    mulw x4, x27, x25                         ;
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
_p0:    csrrsi x11, sscratch, 0                   ;
_p1:    la x13, d_1_17                            ;
        srai x13, x13, 1                          ;
        csrrs x13, pmpaddr4, x13                  ;
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
_l0:    la x14, d_4_9                             ;
        sb x7, -31(x14)                           ;
_l1:    fcvt.s.l f16, x3, rdn                     ;
_l2:    la x20, d_2_23                            ;
        addi x20, x20, 0                          ;
        amoor.d x14, x1, (x20)                    ;
_l3:    beq x10, x10, _l157                               ;
_l4:    mulh x23, x1, x8                          ;
_l5:    la x23, _l58                              ;
        csrrw zero, mepc, x23                     ;
        mret                                      ;
_l6:    la x1, d_2_10                             ;
        addi x1, x1, 24                           ;
        amominu.d x8, x28, (x1)                   ;
_l7:    fcvt.lu.s x14, f13, rne                   ;
_l8:    addiw x0, x25, 78                         ;
_l9:    la x17, d_2_21                            ;
        addi x17, x17, -0                         ;
        amoxor.d x20, x17, (x17)                  ;
_l10:   la x6, d_3_19                             ;
        addi x6, x6, 24                           ;
        sc.w x11, x18, (x6)                       ;
_l11:   la x20, _l68                              ;
        lui x6, 0xffe00                           ;
        xor x20, x20, x6                          ;
        lh x6, -30(x20)                           ;
_l12:   sltiu x26, x28, 0                         ;
_l13:   fle.s x16, f17, f11                       ;
_l14:   subw x22, x19, x0                         ;
_l15:   slliw x17, x16, 0                         ;
_l16:   fsgnj.s f14, f10, f23                     ;
_l17:   fmadd.s f12, f23, f25, f17, dyn           ;
_l18:   la x23, d_2_23                            ;
        addi x23, x23, 8                          ;
        amomaxu.d x17, x8, (x23)                  ;
_l19:   la x25, d_0_25                            ;
        sd x10, -0(x25)                           ;
_l20:   la x29, d_3_8                             ;
        sh x1, -28(x29)                           ;
_l21:   fmv.x.w x15, f3                           ;
_l22:   mul x2, x21, x27                          ;
_l23:   sllw x24, x29, x18                        ;
_l24:   remw x10, x29, x8                         ;
_l25:   rem x30, x2, x3                           ;
_l26:   la x16, _l85                                      ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l27:   la x19, d_0_17                            ;
        addi x19, x19, 24                         ;
        amoswap.d x2, x25, (x19)                  ;
_l28:   subw x12, x13, x13                        ;
_l29:   la x18, d_5_8                             ;
        addi x18, x18, 8                          ;
        amoadd.d x10, x6, (x18)                   ;
_l30:   xor x19, x19, x19                         ;
        csrrs x21, sscratch, x19                  ;
_l31:   la x14, d_1_2                             ;
        addi x14, x14, -0                         ;
        amomax.w x10, x27, (x14)                  ;
_l32:   bgeu x20, x17, _l122                              ;
_l33:   la x29, d_5_20                            ;
        addi x29, x29, 24                         ;
        amoadd.d x8, x3, (x29)                    ;
_l34:   lui x25, 151755                           ;
_l35:   fle.s x8, f17, f0                         ;
_l36:   addi x21, x16, 29                         ;
_l37:   la x12, d_0_8                             ;
        addi x12, x12, 24                         ;
        amomaxu.d x3, x21, (x12)                  ;
_l38:   div x15, x26, x1                          ;
_l39:   rem x26, x28, x0                          ;
_l40:   slti x0, x19, 570                         ;
_l41:   ecall                                     ;
_l42:   bltu x12, x1, _l175                               ;
_l43:   beq x23, x12, _l59                                ;
_l44:   la x8, d_2_9                              ;
        lw x21, 28(x8)                            ;
_l45:   la x12, d_3_16                            ;
        addi x12, x12, -8                         ;
        lr.w x26, (x12)                           ;
_l46:   addi x19, x14, -1633                      ;
_l47:   mulw x24, x26, x24                        ;
_l48:   csrrwi x19, medeleg, 5                    ;
_l49:   rem x27, x26, x25                         ;
_l50:   la x16, d_1_22                            ;
        addi x16, x16, -24                        ;
        amoswap.w x8, x2, (x16)                   ;
_l51:   sraw x18, x24, x14                        ;
_l52:   fnmadd.s f25, f30, f5, f21, rup           ;
_l53:   la x29, d_2_20                            ;
        sd x5, -8(x29)                            ;
_l54:   srliw x13, x13, 31                        ;
_l55:   la x26, d_4_10                            ;
        addi x26, x26, 12                         ;
        amoor.w x7, x30, (x26)                    ;
_l56:   mulhsu x10, x19, x27                      ;
_l57:   la x15, d_3_27                            ;
        addi x15, x15, -8                         ;
        amoswap.d x20, x29, (x15)                 ;
_l58:   fmv.x.w x11, f13                          ;
_l59:   addi x10, x14, -8                         ;
_l60:   fcvt.s.w f16, x8, rne                     ;
_l61:   slliw x12, x0, 2                          ;
_l62:   fmadd.s f27, f12, f12, f14, rup           ;
_l63:   la x20, d_5_5                             ;
        addi x20, x20, 8                          ;
        amoand.d x19, x9, (x20)                   ;
_l64:   ebreak                                    ;
_l65:   fmv.w.x f22, x11                          ;
_l66:   fmadd.s f11, f8, f2, f29, rtz             ;
_l67:   feq.s x26, f17, f18                       ;
_l68:   fclass.s x9, f5                           ;
_l69:   la x21, d_3_10                            ;
        addi x21, x21, -16                        ;
        amoadd.d x2, x7, (x21)                    ;
_l70:   fcvt.wu.s x18, f5, rup                    ;
_l71:   csrrwi x26, mip, 2                        ;
_l72:   auipc x2, 1028756                         ;
_l73:   la x21, d_0_23                            ;
        sh x15, -18(x21)                          ;
_l74:   la x19, d_1_1                             ;
        addi x19, x19, 28                         ;
        amomax.w x13, x22, (x19)                  ;
_l75:   la x10, d_2_21                            ;
        addi x10, x10, 8                          ;
        amomin.w x13, x23, (x10)                  ;
_l76:   fcvt.lu.s x23, f30, rup                   ;
_l77:   srai x12, x8, 41                          ;
_l78:   la x24, d_3_26                            ;
        lui x7, 0xffe00                           ;
        xor x24, x24, x7                          ;
        fsw f3, -24(x24)                          ;
_l79:   fadd.s f11, f31, f30, rdn                 ;
_l80:   remuw x2, x30, x8                         ;
_l81:   remu x10, x10, x21                        ;
_l82:   ori x3, x1, -8                            ;
_l83:   la x6, d_1_25                             ;
        addi x6, x6, -0                           ;
        sc.w x11, x17, (x6)                       ;
_l84:   fnmadd.s f1, f1, f17, f15, dyn            ;
_l85:   div x2, x29, x17                          ;
_l86:   remu x12, x12, x21                        ;
_l87:   slli x9, x12, 47                          ;
_l88:   fdiv.s f27, f9, f8, rmm                   ;
_l89:   mulhu x26, x1, x2                         ;
_l90:   auipc x29, 752841                         ;
_l91:   xor x12, x12, x12                         ;
        addi x15, zero, 1                         ;
        slli x15, x15, 25                         ;
        add x12, x12, x15                         ;
        csrrs x25, medeleg, x12                   ;
_l92:   la x19, d_1_9                             ;
        addi x19, x19, -0                         ;
        amoadd.w x3, x24, (x19)                   ;
_l93:   fadd.s f1, f14, f19, dyn                  ;
_l94:   divuw x16, x5, x21                        ;
_l95:   la x10, d_1_22                            ;
        addi x10, x10, -0                         ;
        amoand.d x15, x25, (x10)                  ;
_l96:   fcvt.s.wu f16, x7, rdn                    ;
_l97:   la x24, _l200                                     ;
        jalr x6, 0(x24)                           ;
_l98:   fcvt.l.s x22, f14, dyn                    ;
_l99:   fmin.s f8, f16, f28                       ;
_l100:  la x7, d_0_17                             ;
        sb x28, 18(x7)                            ;
_l101:  fmv.w.x f20, x7                           ;
_l102:  la x12, _l165                                     ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_l103:  srai x14, x25, 38                         ;
_l104:  bge x10, x4, _l145                                ;
_l105:  fmadd.s f17, f25, f25, f25, rmm           ;
_l106:  fcvt.w.s x27, f10, rmm                    ;
_l107:  xor x6, x6, x6                            ;
        addi x12, zero, 3                         ;
        slli x12, x12, 31                         ;
        add x6, x6, x12                           ;
        addi x11, zero, 3                         ;
        slli x11, x11, 10                         ;
        add x6, x6, x11                           ;
        addi x17, zero, 1                         ;
        slli x17, x17, 8                          ;
        add x6, x6, x17                           ;
        csrrs x24, mstatus, x6                    ;
_l108:  blt x3, x22, _l122                                ;
_l109:  csrrwi x29, mtval, 28                     ;
_l110:  la x24, d_2_7                             ;
        addi x24, x24, 4                          ;
        amoswap.w x11, x26, (x24)                 ;
_l111:  srai x29, x18, 13                         ;
_l112:  la x25, d_3_6                             ;
        addi x25, x25, 0                          ;
        amoand.w x25, x26, (x25)                  ;
_l113:  fclass.s x29, f25                         ;
_l114:  fcvt.l.s x24, f25, rne                    ;
_l115:  la x24, d_0_5                             ;
        addi x24, x24, -0                         ;
        amominu.w x2, x5, (x24)                   ;
_l116:  fcvt.l.s x20, f16, dyn                    ;
_l117:  mul x19, x20, x10                         ;
_l118:  csrrwi x7, sstatus, 29                    ;
_l119:  fnmadd.s f1, f11, f27, f0, rtz            ;
_l120:  fmin.s f30, f20, f18                      ;
_l121:  la x27, d_5_11                            ;
        addi x27, x27, -8                         ;
        amoand.w x26, x25, (x27)                  ;
_l122:  la x21, d_0_13                            ;
        sd x19, 0(x21)                            ;
_l123:  jal x14, _l142                                    ;
_l124:  bge x8, x27, _l139                                ;
_l125:  fcvt.s.lu f13, x22, rup                   ;
_l126:  la x30, d_0_20                            ;
        sh x13, 30(x30)                           ;
_l127:  slti x14, x11, 773                        ;
_l128:  la x13, _l111                                     ;
        lui x16, 0xffe00                          ;
        xor x13, x13, x16                         ;
        lb x16, 23(x13)                           ;
_l129:  mulhsu x10, x0, x11                       ;
_l130:  la x9, d_0_17                             ;
        addi x9, x9, -28                          ;
        amoxor.w x30, x11, (x9)                   ;
_l131:  la x18, d_2_9                             ;
        lwu x23, 8(x18)                           ;
_l132:  la x14, d_4_23                            ;
        addi x14, x14, 24                         ;
        amoor.w x14, x23, (x14)                   ;
_l133:  remuw x25, x14, x23                       ;
_l134:  fmul.s f10, f24, f1, rmm                  ;
_l135:  fmv.x.w x30, f2                           ;
_l136:  la x11, d_3_2                             ;
        addi x11, x11, 24                         ;
        amomin.d x1, x27, (x11)                   ;
_l137:  slti x14, x22, -0                         ;
_l138:  fsub.s f30, f25, f20, rmm                 ;
_l139:  la x7, _l197                              ;
        jalr x14, 0(x7)                           ;
_l140:  ebreak                                    ;
_l141:  feq.s x11, f31, f27                       ;
_l142:  la x25, _l191                                     ;
        jalr x28, 0(x25)                          ;
_l143:  fmv.w.x f15, x30                          ;
_l144:  fsub.s f23, f22, f6, rtz                  ;
_l145:  la x22, _l14                                      ;
        srai x22, x22, 1                          ;
        csrrs x13, pmpaddr0, x22                  ;
_l146:  fmsub.s f31, f30, f4, f10, dyn            ;
_l147:  srliw x23, x1, 2                          ;
_l148:  fcvt.s.wu f16, x23, rdn                   ;
_l149:  la x28, d_4_5                             ;
        addi x28, x28, 8                          ;
        amominu.d x27, x20, (x28)                 ;
_l150:  la x14, _l89                                      ;
        lb x14, -17(x14)                          ;
_l151:  subw x15, x12, x5                         ;
_l152:  la x10, d_1_9                             ;
        addi x10, x10, 24                         ;
        amomaxu.w x16, x23, (x10)                 ;
_l153:  la x3, d_5_13                             ;
        addi x3, x3, -20                          ;
        amominu.w x2, x10, (x3)                   ;
_l154:  beq x17, x28, _l189                               ;
_l155:  la x14, d_3_18                            ;
        addi x14, x14, -16                        ;
        amoor.d x24, x12, (x14)                   ;
_l156:  slliw x21, x14, 1                         ;
_l157:  sraw x1, x12, x10                         ;
_l158:  ecall                                     ;
_l159:  sltiu x19, x27, -1294                     ;
_l160:  remu x3, x0, x25                          ;
_l161:  mul x8, x26, x6                           ;
_l162:  fnmsub.s f1, f26, f26, f28, rtz           ;
_l163:  fmsub.s f11, f25, f18, f7, dyn            ;
_l164:  la x15, d_1_2                             ;
        sw x1, 12(x15)                            ;
_l165:  la x28, d_1_12                            ;
        addi x28, x28, 8                          ;
        amoadd.w x5, x20, (x28)                   ;
_l166:  slti x29, x5, -1806                       ;
_l167:  fnmadd.s f26, f4, f13, f26, rmm           ;
_l168:  fsgnjx.s f8, f10, f0                      ;
_l169:  mulhu x2, x7, x4                          ;
_l170:  sraw x6, x9, x22                          ;
_l171:  slti x14, x28, -467                       ;
_l172:  mulhsu x20, x27, x13                      ;
_l173:  fmsub.s f11, f18, f16, f28, rne           ;
_l174:  csrrsi x7, pmpaddr3, 16                   ;
_l175:  mulh x5, x8, x9                           ;
_l176:  fence.i                                   ;
_l177:  la x26, d_5_19                            ;
        sh x24, -8(x26)                           ;
_l178:  fmax.s f4, f27, f11                       ;
_l179:  div x1, x6, x19                           ;
_l180:  csrrwi x27, pmpaddr1, 4                   ;
_l181:  fsgnj.s f31, f17, f21                     ;
_l182:  srai x15, x2, 19                          ;
_l183:  la x7, d_3_14                             ;
        srai x7, x7, 1                            ;
        csrrw x22, pmpaddr3, x7                   ;
_l184:  remuw x6, x12, x16                        ;
_l185:  la x26, d_2_14                            ;
        addi x26, x26, -0                         ;
        amomax.d x26, x28, (x26)                  ;
_l186:  la x6, d_4_3                              ;
        srai x6, x6, 1                            ;
        csrrw x2, pmpaddr7, x6                    ;
_l187:  la x10, d_1_10                            ;
        addi x10, x10, 24                         ;
        amoxor.d x21, x17, (x10)                  ;
_l188:  la x9, d_4_11                             ;
        lbu x7, -3(x9)                            ;
_l189:  fsub.s f27, f31, f23, rup                 ;
_l190:  fmv.w.x f1, x6                            ;
_l191:  fmsub.s f7, f23, f18, f11, rne            ;
_l192:  fcvt.s.wu f30, x22, rne                   ;
_l193:  csrrsi x16, sepc, 3                       ;
_l194:  la x12, d_5_0                             ;
        sb x12, 10(x12)                           ;
_l195:  mulh x9, x8, x9                           ;
_l196:  fcvt.w.s x2, f7, rup                      ;
_l197:  la x12, d_0_11                            ;
        lh x3, -12(x12)                           ;
_l198:  fsgnj.s f6, f14, f10                      ;
_l199:  la x15, d_3_20                            ;
        fsw f17, -20(x15)                         ;
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
                .dword 0x09eb4a62814cf87e, 0x8ceea600dda954aa
                .dword 0x88ba801685f0ad8c, 0x727be292b9c243cd
d_0_0:          .dword 0xbf3e08e0c6456f8b, 0x1e003fa19a35b31d
d_0_1:          .dword 0x1b7aaf617f7d61c6, 0x9befaccaa2334232
d_0_2:          .dword 0x22110279f4257751, 0x946146b83ee96221
d_0_3:          .dword 0x7e3136a78535faf4, 0x296f8ee8468117cc
d_0_4:          .dword 0x130a569efa4eaf37, 0xb3b9369504b550ef
d_0_5:          .dword 0x0e6ec6c29673eb87, 0x3841f5e0eb3d9504
d_0_6:          .dword 0xc93886fa15c9ae46, 0x94761170038475f7
d_0_7:          .dword 0xd816a36e8652a43c, 0xecec52e482a206fb
d_0_8:          .dword 0x2d13e4672f7126de, 0xd40549bdaef5e0a9
d_0_9:          .dword 0xceec68b3b7412d11, 0x9e83acba39342cca
d_0_10:         .dword 0xa9efaf6957cc46ef, 0x7ee752bddc3bac96
d_0_11:         .dword 0x1786fba372c44041, 0xe75ed140f0c96c3b
d_0_12:         .dword 0xaf2fdc1f9fcfdfb9, 0x23236a39ca78354c
d_0_13:         .dword 0x975cb86c838c3ec5, 0x50aa5b15ec9e1767
d_0_14:         .dword 0x2ca11e177a417b37, 0xac4a9e0a46007596
d_0_15:         .dword 0x70b96048deb137dc, 0xa77044a6b277060b
d_0_16:         .dword 0xba236f1dd1404b7e, 0xf7a5944967310d59
d_0_17:         .dword 0x82cea87d767e9411, 0x043515029f4791c9
d_0_18:         .dword 0x0e91dd997e9d1a09, 0x2b7550740487ea75
d_0_19:         .dword 0xab3de6a25215c76d, 0x0f140761d894414a
d_0_20:         .dword 0x8bf4fc07e2d79edf, 0x2a890ada9f8a7cfc
d_0_21:         .dword 0xb79298143b846033, 0x045db44f49d67410
d_0_22:         .dword 0x2f1b1f2c5c411c2f, 0x6cddb38faa7821d8
d_0_23:         .dword 0x0808ea0f98e7a2e3, 0x188c6b8d7ffc00db
d_0_24:         .dword 0xc4b283c21b15219b, 0x36073798aec27c97
d_0_25:         .dword 0x69f3567ed6c938c1, 0xee8c6eebf007beec
d_0_26:         .dword 0x85d9724d5b6f62f6, 0xb4418ca2c6e6e414
d_0_27:         .dword 0x965593502e223370, 0xbe937782a9daa586
                .dword 0x4daa15b663cbb065, 0x547c1303fb329e6d
                .dword 0x471a0ace38cb7b77, 0x7bf2cfa76fc0c114
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xfa0c23c8b6658cef, 0xe4ac09f571c7868e
                .dword 0xfdffcf908ae37d9f, 0x870f058a1923c812
d_1_0:          .dword 0xb61882efb3a6599a, 0x4cd675ddb13e900a
d_1_1:          .dword 0x93db5b682f6a58f2, 0x70d56828eef5f0e9
d_1_2:          .dword 0x3e5da4cdede3e85b, 0x3421abaedd6a05ef
d_1_3:          .dword 0x7f8c49cb78e78008, 0xc5f973391aae0774
d_1_4:          .dword 0xffbdd6c1e0393557, 0x1454dbc8c40b3b97
d_1_5:          .dword 0xc2822e7b3765bc30, 0x5b20bf4eafbb682b
d_1_6:          .dword 0xfab695b80406872f, 0x1b3b508d71537491
d_1_7:          .dword 0xe2adca478b82d952, 0x9d6dee78d7010b82
d_1_8:          .dword 0xe091316d428811d7, 0xf64967f837d88b8c
d_1_9:          .dword 0x9a742d519232e65b, 0x643f432c7a239209
d_1_10:         .dword 0x845327150f7150fb, 0xe9e82c931a994827
d_1_11:         .dword 0xb810448584aa1674, 0x7e1ef79899d2abc8
d_1_12:         .dword 0x2b92b0d1c4d53871, 0x7c175375e1d35cd2
d_1_13:         .dword 0xec43d945707ec578, 0xa2dd968c7913467d
d_1_14:         .dword 0x466f1282757db896, 0xf776db2d0685262d
d_1_15:         .dword 0x999513ad95d2828a, 0xa3c7e85249829cd6
d_1_16:         .dword 0x4e9217341a89fede, 0x3a24ece8f8b6b850
d_1_17:         .dword 0x2cf50e013f7dddaf, 0x8f30600edaff8e26
d_1_18:         .dword 0x280948c99c0b68ff, 0xb143c54b66e5405f
d_1_19:         .dword 0x135520e6ad04db12, 0x700093e9127fcb22
d_1_20:         .dword 0xd34cb017c8b5f4c9, 0x89c7aa05fb4939b8
d_1_21:         .dword 0xf66374d50e0aabac, 0xe49dc0b44828ff53
d_1_22:         .dword 0x0f87b5f5b627fe82, 0x340cd5b06eb26183
d_1_23:         .dword 0x746aa639ed478c73, 0xa3e2f998368938c5
d_1_24:         .dword 0xdcefaa5c2da521aa, 0xda842cadf5bdd6b1
d_1_25:         .dword 0x29369cc09afe7513, 0xc322632e49145b39
d_1_26:         .dword 0x4be9071354165334, 0xa2e16c3abb556301
d_1_27:         .dword 0xda787fedfe049ffb, 0x4fc5860dab2f32ff
                .dword 0x445b16932065ebe1, 0x28cb1ae15c06807a
                .dword 0xad65e8e309d98214, 0xcfcdf49a37496b81
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x5ce49d66b0b41637, 0x424404da3f6ade4b
                .dword 0x1ddd0dfc379f5d8d, 0xb5570718945ed3ca
d_2_0:          .dword 0x2909e86699c4e2be, 0xe9d864b1c9c9d2bc
d_2_1:          .dword 0x990a2424aef19313, 0x721fe73f54e1451c
d_2_2:          .dword 0x7a3e0662e7167de9, 0x0f615c8fe9ba7432
d_2_3:          .dword 0x5cd0cf4664c0e9b2, 0x757fcdd8ce2f26ec
d_2_4:          .dword 0x1e1ab61929d60374, 0xc3204aa85eec2a6b
d_2_5:          .dword 0x3756305223008cae, 0x8ca84f0f82b1a850
d_2_6:          .dword 0x46b94da3230483d2, 0x16d098ef4da225e2
d_2_7:          .dword 0x73b1b6d4efef8711, 0x773adc6ccb0721c1
d_2_8:          .dword 0xf0a0cf62bc5d9836, 0xbdc94e10fd096995
d_2_9:          .dword 0x3c7eb83c1cdfa289, 0xa1df02139ab203a6
d_2_10:         .dword 0xbe5671e8c81898f9, 0xf182ec0af7c043ac
d_2_11:         .dword 0x042c3cbe6af57e63, 0xcb6ef9fba29204e2
d_2_12:         .dword 0xd158465f202617d0, 0x7ca08bc2bff02f7c
d_2_13:         .dword 0xa5b9187b15ca8679, 0xa6dd16d87ca37987
d_2_14:         .dword 0x749ed8300a1ef449, 0x0806704b6638a44c
d_2_15:         .dword 0x7d33d8d51f79db91, 0xb9de109c947e2192
d_2_16:         .dword 0xe6a92ce1c0cc81e6, 0x74ad8e8d63216d26
d_2_17:         .dword 0x2c3c4760095a1fda, 0xe1890da4ea671d39
d_2_18:         .dword 0x4d8e44480650c9fb, 0xceecd5eb05ab64b2
d_2_19:         .dword 0x64d22d749f832ea3, 0x993581d559e2acd6
d_2_20:         .dword 0x22f5f6f622c99cfd, 0xec04b713bad673db
d_2_21:         .dword 0xb11cfb243fe1c4e7, 0x9effa729079fc9c7
d_2_22:         .dword 0xd5b81034330d213b, 0x0fec335bdc8d58be
d_2_23:         .dword 0x70f83a50a0937056, 0x3442be1402710c5f
d_2_24:         .dword 0xed965f0d349dcd9c, 0xc18db76893640b30
d_2_25:         .dword 0xb690409980af5d49, 0xa284277e3239fc44
d_2_26:         .dword 0x1dbb92be01ceff4e, 0xefcb2bb7eb0ad85d
d_2_27:         .dword 0x115304bc26785489, 0x6f45a1a525e81d75
                .dword 0x64192bcc19306760, 0xdc04a3d218b6099f
                .dword 0x179ecfc953389a08, 0xd60f76e1a3991aa4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x3d0aa070a50496cb, 0x0fec963de2a5e0a9
                .dword 0xbc36de878f4e4a6a, 0x444e414aba886819
d_3_0:          .dword 0x298134b698b2a8cf, 0x27ce4a151fab3fd6
d_3_1:          .dword 0x092e1bbd03a6224a, 0x61f004365e69d68d
d_3_2:          .dword 0xc54d7ba8b413c722, 0xc4f2fc8e613e3c73
d_3_3:          .dword 0xa9d5c1dc7a651a53, 0x143de689e21d9741
d_3_4:          .dword 0x3e5e4c8a95da11ee, 0x301314bb43ccfe76
d_3_5:          .dword 0x5652caeb61c9d561, 0xcbde613a6aa9edc4
d_3_6:          .dword 0x007851ce66d51e4a, 0xd84cc65af9ba3d48
d_3_7:          .dword 0x19cba91d1e05b7e3, 0x057dd73917cf3ce0
d_3_8:          .dword 0x322ef84825de2102, 0x6a2b576ef6faa4e0
d_3_9:          .dword 0x20d06205de118492, 0xde98afce355a3f9d
d_3_10:         .dword 0x451cdb806fc192d2, 0x4e68bba5faffca31
d_3_11:         .dword 0x952c205d2017fb75, 0xf8a6560c10d26d74
d_3_12:         .dword 0xfa7b7942ed5db2fb, 0x5ba4b1de1d6ca15d
d_3_13:         .dword 0xb180bcc6515b4a12, 0x6d1d0dae5a0ef902
d_3_14:         .dword 0xfef1b519cadf2ca6, 0x8fc1b83afb742740
d_3_15:         .dword 0xc04a77310b453139, 0x0f6f6d91d05a0121
d_3_16:         .dword 0x627634ad30e4605d, 0x3ad845acff76a3ff
d_3_17:         .dword 0x97718fa82a12c48f, 0x964ad3c97a6c2659
d_3_18:         .dword 0x0770ba5324c71d6c, 0xdb6b17bfe0d3b86a
d_3_19:         .dword 0xe8147eb04538dff5, 0x1bce5ab0c08eb292
d_3_20:         .dword 0x8bb697d742bcacff, 0x6acc8bdb90f823b4
d_3_21:         .dword 0x0bc09570c8c1fd4e, 0xb58498a15314acd5
d_3_22:         .dword 0x4518151824ad157f, 0x7affdf187a7e1345
d_3_23:         .dword 0x9eaf2461dfff2c4d, 0x575513a1481631fc
d_3_24:         .dword 0x05516db430982855, 0x4268b9092a5b4916
d_3_25:         .dword 0x7a25c01b647b0e83, 0x6c1d0129774cb215
d_3_26:         .dword 0xd7f03deb927cd0e2, 0x9a3c306802298a46
d_3_27:         .dword 0x1ab0074d0af143d7, 0xd1585023a1a6d6c7
                .dword 0xe0125c05b47c1e7c, 0xa0041b429136a90f
                .dword 0xd9e8b02e3401b133, 0xb9f002459afc32e5
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8fa02091ef2f363b, 0xf725b0ff5fd2a24c
                .dword 0xf0c2a9b0a206c3ba, 0x85f4736b90db39e3
d_4_0:          .dword 0x7affe2932f4335ba, 0xdfbcd4f9e453808f
d_4_1:          .dword 0x5572cc251d1b4932, 0x7a78762371b56671
d_4_2:          .dword 0xa4f16015c512639e, 0xb56f4493603ea8b4
d_4_3:          .dword 0x0939f1c9a5cd66d8, 0xbf46bc06385dd87a
d_4_4:          .dword 0xe5d9ff2ff0ec2a01, 0x35de86c1dec61d28
d_4_5:          .dword 0x90deaf4ce7a50b10, 0x39f262542d713bf0
d_4_6:          .dword 0x820094e94b8cfe54, 0x038db1db9cd4fff0
d_4_7:          .dword 0x01c2c9b46c950c32, 0xdcfdb4e917630283
d_4_8:          .dword 0xb343d90478526695, 0x138b1f96801b2dd9
d_4_9:          .dword 0x3ed2bbaf4d097599, 0xac151f314bd66dab
d_4_10:         .dword 0x54691012278e0e7c, 0xd253408de268c090
d_4_11:         .dword 0x4f5bf09dddf7d4c2, 0x942041411c70f735
d_4_12:         .dword 0x7ba8c9e8f6e3d37a, 0x763c882c00970298
d_4_13:         .dword 0x9fc099e91f400c1b, 0x01bda3970935c87d
d_4_14:         .dword 0x6dc8f95d92758ac6, 0x3bf83dbb859f0797
d_4_15:         .dword 0x932167d310326681, 0x6950266958221281
d_4_16:         .dword 0xdebb1aaad41dc999, 0x870b838046414ba9
d_4_17:         .dword 0x61fee44f62996f4b, 0xaaa7f7d28b0e2729
d_4_18:         .dword 0x65593ff41f2650b3, 0xa91520f663baf1d6
d_4_19:         .dword 0xb299fded583e3352, 0x5f269afa6afaecad
d_4_20:         .dword 0x47ef565ea286db6e, 0x686ff4aaa1f25c7b
d_4_21:         .dword 0x32117c277f3e441f, 0xf43157c28210108d
d_4_22:         .dword 0x8924d05cc489d0f0, 0x30f6e09a7b484815
d_4_23:         .dword 0x7275d7b9c78f2ff0, 0x92bb09aedc910f76
d_4_24:         .dword 0x92436f0fcaf2fa0f, 0xc6eb5b241bdd719a
d_4_25:         .dword 0xaf13a2545437a60c, 0xe5978e5f9eb23382
d_4_26:         .dword 0x6f2fce0f6ebf2c06, 0x3b707a9c2a8f5677
d_4_27:         .dword 0x1bbce5cdbf261926, 0xa6baf814cb360d4d
                .dword 0x0073702fe5239fde, 0xbf0ccf357daaefcd
                .dword 0x1f1a0fa9f3f4d913, 0x7b64826f660cf3a7
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xcd96c20ef42885e2, 0x0ee1e984661993e4
                .dword 0x7922339d7f9fce43, 0xf1fba63da3390a3c
d_5_0:          .dword 0x0bb8576b943e46ab, 0x59bc2db757ed2942
d_5_1:          .dword 0x1717a1636d36c21a, 0x462285b8cd822c93
d_5_2:          .dword 0xbfa64e0bc2693ff4, 0x218ad19f282fdfd8
d_5_3:          .dword 0x13102ce4cef329c7, 0x0afc07a5ab5cb036
d_5_4:          .dword 0x8a779609f67ca785, 0xf17ae8fed5feb416
d_5_5:          .dword 0x9f21afcac78ad1e2, 0x7285f5c1688ea2ba
d_5_6:          .dword 0x9adf107c2a0ad780, 0x6e4d913cad7cb798
d_5_7:          .dword 0x15c574faad0a5d62, 0x2eb7ad4f52f16781
d_5_8:          .dword 0x69db9813b7c18877, 0xa3492e2f00aca26a
d_5_9:          .dword 0xb92ff617788e025b, 0xdb54b36d5bb97bf4
d_5_10:         .dword 0xab886f433d84347c, 0x9e2010bd50168611
d_5_11:         .dword 0xf12eed4dab82218f, 0xbc29e57432378bfc
d_5_12:         .dword 0x0959207e8d8105a9, 0xa5e1a0097c6a3577
d_5_13:         .dword 0xcd309ac8e678fb56, 0x468ac62b4d162e91
d_5_14:         .dword 0x4c60af0e888190e5, 0xcc9e07df2b6621d3
d_5_15:         .dword 0x7829670ffb15b1bf, 0xac0be19405372c8e
d_5_16:         .dword 0xe61c33caf13042f8, 0x58c8a3051783274f
d_5_17:         .dword 0x35de8ee97ac9aacd, 0xa6d8ec023d1c4e6c
d_5_18:         .dword 0xf2d98678107cc661, 0xede6d6805f835fa3
d_5_19:         .dword 0x2449f2bb4cd62204, 0x67944760f7285d79
d_5_20:         .dword 0x8c10df92f2901ed5, 0xf7a0ea243ba04478
d_5_21:         .dword 0xd602bda8ec3d1d60, 0xbbdf9f03d216cbea
d_5_22:         .dword 0x7ce2eb2b038235b3, 0xc5eeb1aa7b97d3d8
d_5_23:         .dword 0x9f07ea34a454fda7, 0xf55342a3958578a2
d_5_24:         .dword 0xfaa81255d4940c89, 0x2f11e3d8714ef2d3
d_5_25:         .dword 0x268cded4e6eee088, 0xbeca622bcc858c65
d_5_26:         .dword 0x0a43619bb70c951c, 0xd5589478b9242e05
d_5_27:         .dword 0x138524711784223a, 0x5e454299f887bddb
                .dword 0x3158d1a99cec356e, 0x39542e7ae62f704e
                .dword 0x97c6a7d4659c95fa, 0xaf70002ed2226899
         /* Random data */
_end_data5:
              
                 
