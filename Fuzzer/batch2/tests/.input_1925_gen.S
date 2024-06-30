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
_s0:    ebreak                                    ;
_s1:    la x26, d_3_21                            ;
        lwu x29, -8(x26)                          ;
_s2:    la x16, d_0_26                            ;
        addi x16, x16, -4                         ;
        amominu.w x3, x8, (x16)                   ;
_s3:    fle.s x10, f11, f28                       ;
_s4:    fdiv.s f12, f21, f6, rup                  ;
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
_p0:    csrrci x10, pmpaddr3, 18                  ;
_p1:    xor x12, x12, x12                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 20                         ;
        add x12, x12, x13                         ;
        csrrs x14, scause, x12                    ;
_p2:    la x10, d_3_4                             ;
        srai x10, x10, 1                          ;
        csrrw x13, pmpaddr2, x10                  ;
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
_l0:    divu x28, x9, x22                         ;
_l1:    ori x9, x13, -609                         ;
_l2:    fcvt.wu.s x12, f24, rtz                   ;
_l3:    fcvt.s.wu f6, x22, rmm                    ;
_l4:    la x12, d_2_25                            ;
        addi x12, x12, 0                          ;
        amomaxu.w x30, x15, (x12)                 ;
_l5:    ecall                                     ;
_l6:    jal x22, _l79                             ;
_l7:    mulhu x28, x0, x25                        ;
_l8:    fcvt.wu.s x22, f5, dyn                    ;
_l9:    andi x13, x28, 0                          ;
_l10:   fadd.s f5, f24, f12, rne                  ;
_l11:   la x19, d_0_21                            ;
        lui x25, 0xffe00                          ;
        xor x19, x19, x25                         ;
        lw x19, 12(x19)                           ;
_l12:   divu x22, x18, x13                        ;
_l13:   fsgnj.s f11, f25, f5                      ;
_l14:   la x19, d_5_0                             ;
        fsw f8, 16(x19)                           ;
_l15:   la x21, d_1_13                            ;
        addi x21, x21, -28                        ;
        amomax.w x22, x3, (x21)                   ;
_l16:   bgeu x22, x30, _l153                      ;
_l17:   addiw x1, x3, -1360                       ;
_l18:   la x21, d_0_11                            ;
        addi x21, x21, -8                         ;
        amoadd.w x17, x23, (x21)                  ;
_l19:   la x12, d_3_11                            ;
        flw f16, 12(x12)                          ;
_l20:   mulh x18, x19, x2                         ;
_l21:   la x5, d_5_4                              ;
        fsw f5, -8(x5)                            ;
_l22:   sltiu x4, x24, 749                        ;
_l23:   fcvt.s.w f2, x24, rtz                     ;
_l24:   srliw x9, x3, 10                          ;
_l25:   auipc x28, 749                            ;
_l26:   xor x8, x8, x8                            ;
        addi x15, zero, 3                         ;
        slli x15, x15, 29                         ;
        add x8, x8, x15                           ;
        addi x24, zero, 1                         ;
        slli x24, x24, 24                         ;
        add x8, x8, x24                           ;
        csrrw x22, scause, x8                     ;
_l27:   fdiv.s f29, f8, f25, rmm                  ;
_l28:   fcvt.l.s x10, f12, rtz                    ;
_l29:   fcvt.lu.s x0, f24, rdn                    ;
_l30:   flt.s x14, f27, f10                       ;
_l31:   la x29, d_1_22                            ;
        addi x29, x29, 28                         ;
        amoadd.w x3, x28, (x29)                   ;
_l32:   rem x13, x0, x8                           ;
_l33:   la x10, d_3_27                            ;
        addi x10, x10, -24                        ;
        lui x1, 0xffe00                           ;
        xor x10, x10, x1                          ;
        amoswap.d x23, x1, (x10)                  ;
_l34:   subw x21, x11, x17                        ;
_l35:   fcvt.s.wu f21, x22, rtz                   ;
_l36:   lui x18, 0                                ;
_l37:   div x21, x14, x4                          ;
_l38:   srliw x20, x28, 15                        ;
_l39:   divu x5, x19, x26                         ;
_l40:   la x25, d_1_18                            ;
        addi x25, x25, 16                         ;
        amoand.w x4, x9, (x25)                    ;
_l41:   bltu x10, x19, _l185                      ;
_l42:   csrrci x16, sie, 6                        ;
_l43:   la x4, d_5_5                              ;
        addi x4, x4, -8                           ;
        amomaxu.d x18, x7, (x4)                   ;
_l44:   fcvt.s.w f22, x18, rne                    ;
_l45:   xor x5, x5, x5                            ;
        csrrw x9, mtval, x5                       ;
_l46:   fnmadd.s f10, f12, f0, f15, rup           ;
_l47:   mulhu x17, x12, x17                       ;
_l48:   remuw x1, x29, x8                         ;
_l49:   mulh x18, x23, x23                        ;
_l50:   divw x7, x24, x24                         ;
_l51:   fence                                     ;
_l52:   la x28, _l55                              ;
        csrrw zero, mepc, x28                     ;
        mret                                      ;
_l53:   slliw x10, x14, 0                         ;
_l54:   srlw x0, x13, x10                         ;
_l55:   div x3, x2, x15                           ;
_l56:   fmv.w.x f10, x16                          ;
_l57:   fsub.s f5, f18, f6, rup                   ;
_l58:   la x29, d_5_1                             ;
        addi x29, x29, -8                         ;
        amoswap.w x26, x5, (x29)                  ;
_l59:   la x7, d_3_27                             ;
        addi x7, x7, -4                           ;
        amomaxu.w x27, x9, (x7)                   ;
_l60:   divu x13, x21, x19                        ;
_l61:   fmadd.s f10, f0, f22, f16, rne            ;
_l62:   la x16, d_5_21                            ;
        addi x16, x16, -4                         ;
        amomin.w x15, x17, (x16)                  ;
_l63:   ebreak                                    ;
_l64:   la x30, d_3_12                            ;
        addi x30, x30, -0                         ;
        lr.w x11, (x30)                           ;
_l65:   div x13, x6, x13                          ;
_l66:   la x17, d_4_15                            ;
        addi x17, x17, 0                          ;
        amomax.d x16, x23, (x17)                  ;
_l67:   mulhsu x7, x19, x0                        ;
_l68:   sraw x8, x2, x6                           ;
_l69:   mulw x5, x25, x25                         ;
_l70:   la x21, d_5_6                             ;
        sh x27, 6(x21)                            ;
_l71:   fence                                     ;
_l72:   fmsub.s f25, f29, f10, f2, rtz            ;
_l73:   fmv.w.x f16, x6                           ;
_l74:   bltu x25, x16, _l184                      ;
_l75:   fnmsub.s f23, f13, f21, f1, rne           ;
_l76:   fclass.s x27, f15                         ;
_l77:   ori x22, x3, -421                         ;
_l78:   slliw x10, x15, 13                        ;
_l79:   fcvt.wu.s x7, f3, rne                     ;
_l80:   fsgnjx.s f15, f17, f23                    ;
_l81:   la x22, d_1_9                             ;
        sb x4, -31(x22)                           ;
_l82:   fadd.s f9, f9, f3, rtz                    ;
_l83:   srai x24, x24, 61                         ;
_l84:   la x27, d_5_22                            ;
        addi x27, x27, 0                          ;
        amoor.d x29, x27, (x27)                   ;
_l85:   srlw x4, x24, x14                         ;
_l86:   la x17, d_1_17                            ;
        addi x17, x17, -0                         ;
        amominu.w x2, x10, (x17)                  ;
_l87:   fmul.s f23, f23, f25, rne                 ;
_l88:   la x13, d_0_11                            ;
        sh x15, -6(x13)                           ;
_l89:   sllw x22, x17, x1                         ;
_l90:   fcvt.wu.s x13, f11, rup                   ;
_l91:   mulhu x9, x8, x13                         ;
_l92:   fmadd.s f17, f23, f9, f13, rmm            ;
_l93:   divu x29, x15, x30                        ;
_l94:   slli x18, x8, 4                           ;
_l95:   fcvt.l.s x11, f30, rmm                    ;
_l96:   fmax.s f27, f3, f2                        ;
_l97:   slti x23, x25, 30                         ;
_l98:   fle.s x17, f12, f6                        ;
_l99:   la x7, d_2_10                             ;
        addi x7, x7, -0                           ;
        amoor.d x28, x13, (x7)                    ;
_l100:  la x23, d_0_0                             ;
        addi x23, x23, 0                          ;
        lr.d x5, (x23)                            ;
_l101:  la x8, _l113                              ;
        csrrw zero, mepc, x8                      ;
        mret                                      ;
_l102:  fence.i                                   ;
_l103:  la x30, d_3_17                            ;
        lwu x22, 4(x30)                           ;
_l104:  csrrsi x3, pmpaddr7, 5                    ;
_l105:  divuw x26, x24, x5                        ;
_l106:  fsgnjx.s f0, f3, f8                       ;
_l107:  slliw x22, x18, 31                        ;
_l108:  la x15, d_0_16                            ;
        lw x26, 20(x15)                           ;
_l109:  srliw x19, x7, 31                         ;
_l110:  la x16, d_4_24                            ;
        addi x16, x16, -0                         ;
        amoand.d x14, x9, (x16)                   ;
_l111:  fcvt.wu.s x23, f13, rmm                   ;
_l112:  csrrci x5, pmpaddr7, 31                   ;
_l113:  la x3, _l200                              ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l114:  fmadd.s f18, f12, f11, f12, rmm           ;
_l115:  fdiv.s f21, f25, f1, rdn                  ;
_l116:  la x22, d_3_16                            ;
        addi x22, x22, 24                         ;
        lui x26, 0xffe00                          ;
        xor x22, x22, x26                         ;
        amoxor.d x30, x26, (x22)                  ;
_l117:  la x9, d_3_9                              ;
        addi x9, x9, 8                            ;
        amoor.d x27, x10, (x9)                    ;
_l118:  csrrci x12, mepc, 0                       ;
_l119:  la x23, d_3_4                             ;
        lui x10, 0xffe00                          ;
        xor x23, x23, x10                         ;
        ld x30, 8(x23)                            ;
_l120:  fmv.x.w x28, f4                           ;
_l121:  bne x24, x29, _l152                       ;
_l122:  la x29, d_3_8                             ;
        addi x29, x29, 0                          ;
        amoswap.d x4, x9, (x29)                   ;
_l123:  flt.s x20, f31, f8                        ;
_l124:  la x28, d_4_14                            ;
        addi x28, x28, 20                         ;
        amomax.w x6, x29, (x28)                   ;
_l125:  la x20, d_2_16                            ;
        srai x20, x20, 1                          ;
        csrrw x12, pmpaddr3, x20                  ;
_l126:  fmul.s f24, f23, f24, rup                 ;
_l127:  divuw x7, x26, x0                         ;
_l128:  la x6, d_0_15                             ;
        ld x7, 16(x6)                             ;
_l129:  fsqrt.s f22, f28, rup                     ;
_l130:  fcvt.w.s x13, f7, dyn                     ;
_l131:  remu x20, x12, x7                         ;
_l132:  srai x21, x15, 41                         ;
_l133:  la x12, d_1_19                            ;
        addi x12, x12, 0                          ;
        amoand.w x21, x19, (x12)                  ;
_l134:  xor x6, x6, x6                            ;
        csrrc x19, mhartid, x6                    ;
_l135:  fmul.s f8, f2, f8, rdn                    ;
_l136:  la x16, _l185                             ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
_l137:  la x25, d_2_16                            ;
        addi x25, x25, -16                        ;
        amomaxu.d x25, x12, (x25)                 ;
_l138:  fsgnjn.s f17, f10, f28                    ;
_l139:  srlw x25, x10, x18                        ;
_l140:  fcvt.s.l f9, x4, rtz                      ;
_l141:  fnmsub.s f7, f31, f18, f10, rmm           ;
_l142:  la x2, d_0_5                              ;
        lh x8, -20(x2)                            ;
_l143:  remuw x24, x16, x27                       ;
_l144:  bge x17, x25, _l191                       ;
_l145:  la x26, d_0_7                             ;
        addi x26, x26, -28                        ;
        lui x12, 0xffe00                          ;
        xor x26, x26, x12                         ;
        amoor.w x20, x12, (x26)                   ;
_l146:  fclass.s x30, f16                         ;
_l147:  rem x14, x20, x3                          ;
_l148:  fcvt.lu.s x2, f2, dyn                     ;
_l149:  la x12, d_4_15                            ;
        lui x5, 0xffe00                           ;
        xor x12, x12, x5                          ;
        lwu x3, -20(x12)                          ;
_l150:  la x23, d_5_2                             ;
        addi x23, x23, 24                         ;
        amoand.d x6, x25, (x23)                   ;
_l151:  fsqrt.s f29, f28, rmm                     ;
_l152:  subw x10, x26, x17                        ;
_l153:  csrrsi x27, pmpaddr3, 31                  ;
_l154:  srliw x11, x29, 10                        ;
_l155:  la x20, d_5_3                             ;
        addi x20, x20, 16                         ;
        lui x16, 0xffe00                          ;
        xor x20, x20, x16                         ;
        amoswap.d x28, x16, (x20)                 ;
_l156:  la x17, d_0_12                            ;
        addi x17, x17, 8                          ;
        amoor.d x15, x1, (x17)                    ;
_l157:  rem x16, x2, x5                           ;
_l158:  rem x20, x2, x20                          ;
_l159:  fcvt.s.w f23, x22, rup                    ;
_l160:  la x1, d_3_7                              ;
        addi x1, x1, -8                           ;
        amoadd.d x3, x13, (x1)                    ;
_l161:  xori x20, x14, -0                         ;
_l162:  xori x25, x13, 19                         ;
_l163:  andi x26, x1, 11                          ;
_l164:  ebreak                                    ;
_l165:  fdiv.s f18, f27, f12, rup                 ;
_l166:  addw x0, x23, x13                         ;
_l167:  srlw x23, x19, x20                        ;
_l168:  sllw x0, x3, x28                          ;
_l169:  la x5, d_2_17                             ;
        flw f30, 8(x5)                            ;
_l170:  la x23, d_3_1                             ;
        addi x23, x23, 12                         ;
        lr.w x22, (x23)                           ;
_l171:  fmsub.s f0, f19, f15, f16, dyn            ;
_l172:  fcvt.w.s x11, f15, rdn                    ;
_l173:  slli x26, x12, 16                         ;
_l174:  slti x11, x0, -2047                       ;
_l175:  slli x17, x6, 16                          ;
_l176:  fnmsub.s f16, f14, f30, f22, rne          ;
_l177:  srlw x25, x2, x12                         ;
_l178:  bltu x24, x1, _l198                       ;
_l179:  sraiw x6, x26, 31                         ;
_l180:  beq x22, x14, _l195                       ;
_l181:  fdiv.s f18, f24, f13, dyn                 ;
_l182:  la x26, _l200                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l183:  fence.i                                   ;
_l184:  li x23, 1                                 ;
        la x16, pt1                               ;
        addi x16, x16, 48                         ;
        sfence.vma x23, x16                       ;
_l185:  fsgnjn.s f11, f29, f13                    ;
_l186:  srlw x18, x4, x29                         ;
_l187:  la x25, d_2_8                             ;
        addi x25, x25, 28                         ;
        amoor.w x8, x17, (x25)                    ;
_l188:  la x12, d_1_0                             ;
        addi x12, x12, 8                          ;
        lr.w x10, (x12)                           ;
_l189:  fcvt.lu.s x25, f15, rtz                   ;
_l190:  blt x26, x7, _l191                        ;
_l191:  la x21, d_2_11                            ;
        addi x21, x21, -28                        ;
        amomaxu.w x15, x15, (x21)                 ;
_l192:  la x11, d_3_14                            ;
        addi x11, x11, -16                        ;
        amomax.d x25, x10, (x11)                  ;
_l193:  la x30, _l194                             ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l194:  la x27, d_5_13                            ;
        flw f6, -24(x27)                          ;
_l195:  la x22, d_5_16                            ;
        lui x29, 0xffe00                          ;
        xor x22, x22, x29                         ;
        sh x8, 30(x22)                            ;
_l196:  mulhu x4, x10, x0                         ;
_l197:  la x29, _l200                             ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l198:  slliw x2, x19, 13                         ;
_l199:  bltu x13, x28, _l200                      ;
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
                .dword 0xcb48cb0fc7d96383, 0xcc81ab990de04e0a
                .dword 0x8a7f238b5b93e32c, 0x4a699d35c258ae2f
d_0_0:          .dword 0x4c6310e089ab828c, 0x5f49288ab388b398
d_0_1:          .dword 0x22da200bdbd7547b, 0xb125e31f11553b88
d_0_2:          .dword 0x49c5cea9e6a6f24b, 0x4bec5bb3e63f9c71
d_0_3:          .dword 0x6f4cc7d63a4a1f0e, 0x5900b107b255e31c
d_0_4:          .dword 0x31c4528614177e96, 0x952eb23f1c299f54
d_0_5:          .dword 0xd1dbc40dd7e35799, 0x56bf2371f441d60b
d_0_6:          .dword 0x140d6ea4a9eb4ba7, 0x3fe059bd6a99d747
d_0_7:          .dword 0x8f60a34a0e071de6, 0x7b872e59fc2cafc9
d_0_8:          .dword 0xb2cc369c7d60afec, 0x3f457c59288b88df
d_0_9:          .dword 0xb7bbcf41c6521f14, 0x36b2a7e2e488867d
d_0_10:         .dword 0xfe1499cc7e2ecb8b, 0xac8992625568d316
d_0_11:         .dword 0x205eb6fe02c84180, 0x0f4fb8c2ff0b6df9
d_0_12:         .dword 0x9459cfe54e7aed77, 0x6283e991472ee5a5
d_0_13:         .dword 0x319abb805ee14587, 0xf1b1fe01947a8d5f
d_0_14:         .dword 0x5e190a160eaf8b38, 0xaa8ed280e732b36e
d_0_15:         .dword 0xda51b5932aa778d1, 0x888f5222cebb11c5
d_0_16:         .dword 0xd7cc3849cc2faef0, 0x5eb4fe10cd1d0cdc
d_0_17:         .dword 0x2d0f1cd9ccb617f6, 0x565a44fb4b77c3b3
d_0_18:         .dword 0x0fa04aeb9a411d1f, 0x907c892402a29a74
d_0_19:         .dword 0xff0024709d8d6d6b, 0x71b9f58e67e9adf8
d_0_20:         .dword 0xebe34c22623f4004, 0x0a08a9e5eceaeeea
d_0_21:         .dword 0xfde052509843ca37, 0x7dc5905d9a918c3b
d_0_22:         .dword 0x33c08595adb9c083, 0x20485569c995bb1a
d_0_23:         .dword 0x793a1bdca31e0003, 0x7f4dbe0124d2961d
d_0_24:         .dword 0x409a0e604fec2244, 0xaaf144024a6f7730
d_0_25:         .dword 0x72c2992fc1f7978f, 0x66055209addd6cb4
d_0_26:         .dword 0xa8ce6502bfd265cc, 0x131978549f942e41
d_0_27:         .dword 0x7545ebcfc57085ee, 0xa12daf6fb346285e
                .dword 0xf4b63a36521f50db, 0xb4363dbe4c8ae9b0
                .dword 0x1bc294b61e67c33a, 0xca50a15ddf593b4b
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x5d1b2633a97e7510, 0x47094c555a3f5565
                .dword 0xc788bd8ae58d5d14, 0xa435e87572b88a65
d_1_0:          .dword 0x37a1da724b59dc55, 0x604ae7da832e89fa
d_1_1:          .dword 0x482f4a7109655146, 0x348dcc14e3d83b42
d_1_2:          .dword 0xe485b1da5da78a13, 0x8f3183d35ad3b974
d_1_3:          .dword 0x4fe342b42889e3f2, 0x716c69b1d52daab8
d_1_4:          .dword 0xdf7bae139eaf5675, 0x48ddd6a1caa70c91
d_1_5:          .dword 0x266be1d9929823d1, 0xae2c99b5afaa61c7
d_1_6:          .dword 0xcd89b6ff61ca81b1, 0xbc29e5c2b8799d64
d_1_7:          .dword 0xaf4d58065ff917ad, 0x988b41493e59bffb
d_1_8:          .dword 0xbfd03e0af5c851db, 0x3a9b6c054f07dcb2
d_1_9:          .dword 0xb2db09e5ddd448cf, 0xf7fd39166459741e
d_1_10:         .dword 0x387cb6af5d49e719, 0x537bf11e4bf3e223
d_1_11:         .dword 0x0c948a27797ea816, 0x5ab293102f529816
d_1_12:         .dword 0x880ccb6b4f219844, 0xb24ee2ed4c238b61
d_1_13:         .dword 0xf0cf4fed57bf2b2f, 0x8505ab6c51858f40
d_1_14:         .dword 0x92e1973bf671a1d2, 0x916adc639d71402d
d_1_15:         .dword 0xefdf797ea1bdf5cf, 0xe97499e858f7986c
d_1_16:         .dword 0xabd89da4943711ae, 0xa3058f2766683f2d
d_1_17:         .dword 0xcdd0e82b44af5859, 0x39da0abd55922d5f
d_1_18:         .dword 0xe45fb836a2678704, 0x8f32dbc9afde41cd
d_1_19:         .dword 0x3ff2d55e2e7325d4, 0x390ac6a73ac3f7ca
d_1_20:         .dword 0x5ea11c5c36539c79, 0xd763328f5fb4d0ba
d_1_21:         .dword 0xcf35fc1435507159, 0xd2ae805f5d30e6a2
d_1_22:         .dword 0x65bcd1d972b5a483, 0xd5bc382cadee3ec4
d_1_23:         .dword 0xcc2327aa995bf6e9, 0x404d600f1fe3f99a
d_1_24:         .dword 0x20ac3d2631ba703c, 0xfe4e1f5c36c5b3dd
d_1_25:         .dword 0x9fec1e93e65fd049, 0xc3abf5cbc94237af
d_1_26:         .dword 0x111e86b2de1e6257, 0x480a89c8660e6d84
d_1_27:         .dword 0x99cca16e9e52bc35, 0x02d3aa715ad3c736
                .dword 0xdc127fe17ced7563, 0x38ee283090706123
                .dword 0xfcdd5998bb5ed3a9, 0x4c454bf8315518f7
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x472c9a92293decd1, 0x21f120a162b07a44
                .dword 0x8d323e38787ee323, 0x71f9ac01f36e0693
d_2_0:          .dword 0x81e8cfc8aa3f5802, 0x51c41bfa20423ef9
d_2_1:          .dword 0x246a4d6c1d588454, 0x1fb6afb840163e75
d_2_2:          .dword 0x06e68144a02033cb, 0xf497c6b5f87a3ba3
d_2_3:          .dword 0x8d1f8d67a6287423, 0x47e8a46d042d70ae
d_2_4:          .dword 0x4a779d9fbe638541, 0xaad06833f56794ba
d_2_5:          .dword 0x0c5d7847d9e9745b, 0x0459cf977360d2d9
d_2_6:          .dword 0x567b4d5477e80928, 0x032ec004f06db79b
d_2_7:          .dword 0x5ae0ccb6bb5ea583, 0x2fa0692076f4211a
d_2_8:          .dword 0x72d348831f12ffbc, 0x95d934e5471553df
d_2_9:          .dword 0x56c37b25f2d1a433, 0x601d74a8781f58fe
d_2_10:         .dword 0x8686d2d3234bfd46, 0x69fc8845558446f9
d_2_11:         .dword 0x76b98daff5568b77, 0xdfd2ce68c0b746c1
d_2_12:         .dword 0x48417ee0823f593d, 0x248251e42a34fba2
d_2_13:         .dword 0x7a4db6a485e2bb4c, 0xe610330915b56156
d_2_14:         .dword 0xf92c0a08fe56aef1, 0x998109acc60d6b03
d_2_15:         .dword 0x39430b3f76614cb3, 0x5415be454bec5022
d_2_16:         .dword 0x99d735d4bcf1d7d1, 0x86d695c2cb5f91fd
d_2_17:         .dword 0x4025f7b2ff06441d, 0x12c149a13ad0a691
d_2_18:         .dword 0x8289082e5d4bc346, 0x4f140b2e1211aa09
d_2_19:         .dword 0x22439d307dbd32a8, 0x3747db060f9d8dda
d_2_20:         .dword 0x01d67b56abce79fd, 0xa67bf40a7d18640e
d_2_21:         .dword 0x728f25c33eb71b62, 0x7d05c74fd15e8d1b
d_2_22:         .dword 0xff85f7968db5f0bc, 0x223cfaa4e7239a4a
d_2_23:         .dword 0x0718a7c5d39b9f74, 0x09987585e30316fd
d_2_24:         .dword 0x4bdcbc9f87fbbc68, 0x1284aa251be4f2e3
d_2_25:         .dword 0x9660c07ddffbb2b2, 0x69054b0bd9bc9439
d_2_26:         .dword 0x9d90e04121918fbf, 0x5dd836395c90a07c
d_2_27:         .dword 0x0817ff68696d7efb, 0x7c455b1c3bb6b941
                .dword 0x630b59351339a356, 0x4c478af50c583b0b
                .dword 0xd52125353922667a, 0x0f5b317d88dd7136
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xa8fd3a1936e256f4, 0x4a47530bd09f93f0
                .dword 0x81209aa1eb47b632, 0xb2f9d1488491c3b6
d_3_0:          .dword 0xe092b987a607ead9, 0xf281a16c5222c2b9
d_3_1:          .dword 0x51f2d5122cd61ca4, 0xd4ff2843f4a63acd
d_3_2:          .dword 0x3dd571e444eaa294, 0xd93bc96a04d004d8
d_3_3:          .dword 0xd758d9e7015eb203, 0x42c431627c162f49
d_3_4:          .dword 0x235f0ffea580375e, 0x493c801d95827b04
d_3_5:          .dword 0x1cab72a13e07e51b, 0x46ab7a29d65781b0
d_3_6:          .dword 0xbd50df169b15d849, 0x1701a436909ef3ac
d_3_7:          .dword 0x0d7fc044eeee522c, 0xafb712565eb04faf
d_3_8:          .dword 0x3a9dc72afa8e7498, 0xbb369672d377abfc
d_3_9:          .dword 0xe97e188fe81389db, 0xd96099919acadf54
d_3_10:         .dword 0xdaed1014da989364, 0x4da773bf352f3045
d_3_11:         .dword 0x48697ede28b1390f, 0xf22665177f1c8f24
d_3_12:         .dword 0xe4fe18d70ce085f9, 0x8b883d11dbf733be
d_3_13:         .dword 0x0ef2582467a5df94, 0xf1aadcefe6d7758e
d_3_14:         .dword 0x45b59a86015485cf, 0x3c1ec427b5482c7f
d_3_15:         .dword 0xc180a0a55a054413, 0x95355c00f0f18ff6
d_3_16:         .dword 0x1e79be49b691ddd1, 0x371edebb4c11a426
d_3_17:         .dword 0x4c1abb0b73f8f1e4, 0x8237da749c026894
d_3_18:         .dword 0xeafa1d0b9f8a1275, 0x2fbcf0429b4d23f6
d_3_19:         .dword 0x56959f1b50df1b49, 0x21500abbdb918d4d
d_3_20:         .dword 0x90dbc3eb4ff2ff4e, 0x8323c3625b35881e
d_3_21:         .dword 0x85de41134195659c, 0xa4cc5fa57871de1b
d_3_22:         .dword 0xa48fcce429d32e30, 0x44b929a9fc17bf43
d_3_23:         .dword 0x5c4e6e31b3cda561, 0x1992ce3e3e125794
d_3_24:         .dword 0xe8518bb2cb49fc19, 0xeb2ecc7b54d52c60
d_3_25:         .dword 0xac1453277d0b6d77, 0xa4ca8833de41dfca
d_3_26:         .dword 0xa403f074c6398332, 0x7f4eaecb5ce75101
d_3_27:         .dword 0x15d31184debff3de, 0xf32fde51645fd351
                .dword 0xa03347416076ba11, 0x942f714ae9d7b085
                .dword 0xfd323ad320bb4f2b, 0xbb73c9eb33147a8a
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x6fca2355a08295ce, 0x5b154dd226587a02
                .dword 0x2af89db1aee1291b, 0xa792991300e6a187
d_4_0:          .dword 0x2962b6a778cd4055, 0x90919b91be719405
d_4_1:          .dword 0x1b839ea233cbe016, 0xb24e1a1ac21760d6
d_4_2:          .dword 0xa00ab983676206f6, 0x2070ae56ce399e3e
d_4_3:          .dword 0xd76c5ef944231bae, 0x4d7e29501ce73372
d_4_4:          .dword 0xaad6cb98363e37ae, 0xda250fe66be52f1c
d_4_5:          .dword 0x05edb07bf37e02f9, 0x7d9b8b44b43fc9f7
d_4_6:          .dword 0xd654125617a7d5f7, 0x46995866338c978b
d_4_7:          .dword 0x8b4d989365c521dd, 0xff90fa2ff5f46d88
d_4_8:          .dword 0xc475dc3a06b8361b, 0x13d7831c75a9042f
d_4_9:          .dword 0x25e0f52f2944759a, 0xa978f5b917a750aa
d_4_10:         .dword 0x80b4ce7f685705b4, 0x0d08b8599bfc45ba
d_4_11:         .dword 0x8018ca3d9178f712, 0x63fdea07868a310c
d_4_12:         .dword 0x140ebd77b0656971, 0xadf164cdeb7b26a1
d_4_13:         .dword 0x474c5fc2e9d78b70, 0x9c93ed401c96884b
d_4_14:         .dword 0xb2ef9381deefde09, 0x6cc62fcb466393a8
d_4_15:         .dword 0xa622d95f05a76cea, 0x7d408f1a5f84c439
d_4_16:         .dword 0x504a13b125ea4455, 0x42bc720f1585b7c4
d_4_17:         .dword 0xb4acee275e6ccfe2, 0x09d721ded397e87d
d_4_18:         .dword 0x110a15b7c351ded9, 0x0b4dd4994f2c722e
d_4_19:         .dword 0xb0fd1d2ff0d5d0a4, 0x9a24d66cea6802a3
d_4_20:         .dword 0x301eebc5b8300926, 0x6122d097a743a447
d_4_21:         .dword 0xc166c20b422d9f2c, 0xa88c47155afa4b77
d_4_22:         .dword 0x1f95c5555c5e781b, 0xb053de3b1cea1881
d_4_23:         .dword 0x4995247de20e2156, 0x40fee03c2e1ceb45
d_4_24:         .dword 0x40e1ef530618613b, 0x7594f5756d0a97ff
d_4_25:         .dword 0xec3674b02d893c0a, 0xd1b937e99c723c04
d_4_26:         .dword 0x89fc89bf85c93212, 0xba6aea1bc3df4cbd
d_4_27:         .dword 0xd3f988c2825b1999, 0xefbf7bb374686d29
                .dword 0x4e4bf6f8dca12aa6, 0x67a67b64a410a311
                .dword 0x95a477227ae2812a, 0xf23c90e106241bbc
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xee92c19c8d70757d, 0x1b477dde718c8acb
                .dword 0x4cacf75b15b98694, 0xd2a18dd9a459e05b
d_5_0:          .dword 0xa8b28393c2455071, 0x57d6a25533ad1f80
d_5_1:          .dword 0xebf803a930a51bf0, 0x4d42bba3509c8ca7
d_5_2:          .dword 0xf68962022537e70f, 0x10acc5ff2ff230ab
d_5_3:          .dword 0x47329862aee78be2, 0xfdf27a641468cfd6
d_5_4:          .dword 0x1e0acf3337d8df14, 0x8dda05467425d608
d_5_5:          .dword 0x6e5ee803064ec912, 0x64aa4f045ad99242
d_5_6:          .dword 0xe46fc9f0105b60f7, 0x6717b230b282a0d5
d_5_7:          .dword 0xd57f1bc7bd5b56da, 0xd59e3b23b539e93e
d_5_8:          .dword 0xa4212bd25909958b, 0xe4733444b8d36927
d_5_9:          .dword 0xbb181df1ca001355, 0x5cfe7ee431aec86e
d_5_10:         .dword 0x4d38ed2d0d128aa3, 0x50deb1f8ba91d776
d_5_11:         .dword 0x28c397c7a34b8291, 0x906a0f42843a2a8e
d_5_12:         .dword 0x5b8026f50267cb6e, 0x9cf12e44ca780d0b
d_5_13:         .dword 0x888aa667f7e68a90, 0x7f497542f5613a13
d_5_14:         .dword 0xa5ce6ba414afcd98, 0xa1f95c54db9f1a82
d_5_15:         .dword 0xb461ab3ef041fd5a, 0xab82717c05a092bb
d_5_16:         .dword 0xe296e205886852df, 0x160d41b62db6e769
d_5_17:         .dword 0x4ff86d3143028636, 0xcba29e1acbfb9306
d_5_18:         .dword 0xbcc9e59400bff8a4, 0x73033e4f1b2660ea
d_5_19:         .dword 0xea86dcc76b4e4fd1, 0xe76f1ec527948378
d_5_20:         .dword 0x357e7169d42818bf, 0x4ca9fbe11df948ee
d_5_21:         .dword 0xb226b9d29abcda2a, 0x66d443b3f02d0793
d_5_22:         .dword 0xc9628193dea44f18, 0xc2148b8dd1e6bf44
d_5_23:         .dword 0x09b90b2ea9738294, 0x85f136ea9a8b435e
d_5_24:         .dword 0x6b2112510dd1e8b7, 0x263cf56ed9b7d0d4
d_5_25:         .dword 0x6dbf6512eff987d3, 0x2d73cec512ef4c7b
d_5_26:         .dword 0x518afc4639dfaf17, 0x5799acd98e219153
d_5_27:         .dword 0xef87112a5843dcd9, 0xf752458abd202fb3
                .dword 0x4d69df12b7417c09, 0x2f6e65177445c22a
                .dword 0x5997ec1d58c0ee97, 0xc7202e2aa0e11984
         /* Random data */
_end_data5:
              
                 
