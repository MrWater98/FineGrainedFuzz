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
_s0:    la x26, _s2                               ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_s1:    la x20, d_1_18                            ;
        addi x20, x20, -16                        ;
        amoadd.d x26, x26, (x20)                  ;
_s2:    srli x24, x29, 59                         ;
_s3:    la x30, d_3_15                            ;
        lh x13, 8(x30)                            ;
_s4:    addw x11, x14, x13                        ;
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
_p0:    la x11, d_2_6                             ;
        srai x11, x11, 1                          ;
        csrrc x10, pmpaddr7, x11                  ;
_p1:    xor x10, x10, x10                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 18                         ;
        add x10, x10, x10                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 31                         ;
        add x10, x10, x12                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 16                         ;
        add x10, x10, x10                         ;
        csrrs x14, scause, x10                    ;
_p2:    la x11, d_4_6                             ;
        srai x11, x11, 1                          ;
        csrrs x10, pmpaddr0, x11                  ;
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
_l0:    beq x1, x27, _l91                         ;
_l1:    addi x11, x23, 1185                       ;
_l2:    la x12, d_5_18                            ;
        lbu x27, -14(x12)                         ;
_l3:    fcvt.s.wu f1, x14, dyn                    ;
_l4:    la x1, d_0_1                              ;
        lh x21, 22(x1)                            ;
_l5:    la x20, d_3_13                            ;
        flw f1, 28(x20)                           ;
_l6:    la x10, d_0_3                             ;
        lw x18, -20(x10)                          ;
_l7:    sraiw x0, x26, 1                          ;
_l8:    la x9, d_4_5                              ;
        sh x8, 22(x9)                             ;
_l9:    la x12, d_4_20                            ;
        addi x12, x12, -0                         ;
        sc.d x16, x12, (x12)                      ;
_l10:   fcvt.wu.s x7, f2, rtz                     ;
_l11:   fcvt.w.s x29, f1, rne                     ;
_l12:   fcvt.wu.s x29, f21, rne                   ;
_l13:   la x12, d_3_23                            ;
        addi x12, x12, 4                          ;
        amoswap.w x5, x2, (x12)                   ;
_l14:   bge x23, x20, _l21                        ;
_l15:   srliw x7, x28, 26                         ;
_l16:   addi x28, x2, 207                         ;
_l17:   fsgnjx.s f18, f4, f17                     ;
_l18:   divuw x16, x18, x28                       ;
_l19:   fence                                     ;
_l20:   fcvt.wu.s x7, f4, rtz                     ;
_l21:   mul x1, x12, x9                           ;
_l22:   remw x23, x4, x10                         ;
_l23:   fadd.s f11, f4, f10, rne                  ;
_l24:   la x28, d_4_3                             ;
        flw f18, -20(x28)                         ;
_l25:   srlw x11, x9, x21                         ;
_l26:   ecall                                     ;
_l27:   la x11, d_5_7                             ;
        addi x11, x11, 0                          ;
        amominu.w x30, x10, (x11)                 ;
_l28:   fence.i                                   ;
_l29:   srlw x18, x29, x0                         ;
_l30:   la x3, _l52                               ;
        jalr x1, 0(x3)                            ;
_l31:   mul x20, x16, x29                         ;
_l32:   la x4, d_4_15                             ;
        addi x4, x4, 12                           ;
        amominu.w x29, x11, (x4)                  ;
_l33:   fclass.s x14, f6                          ;
_l34:   la x12, d_3_10                            ;
        sb x8, 10(x12)                            ;
_l35:   la x26, d_2_26                            ;
        addi x26, x26, -20                        ;
        amomin.w x25, x4, (x26)                   ;
_l36:   ecall                                     ;
_l37:   la x29, d_2_20                            ;
        addi x29, x29, 20                         ;
        amoxor.w x14, x14, (x29)                  ;
_l38:   divuw x1, x3, x22                         ;
_l39:   ecall                                     ;
_l40:   addw x0, x22, x22                         ;
_l41:   la x14, d_0_11                            ;
        lui x21, 0xffe00                          ;
        xor x14, x14, x21                         ;
        sb x27, -6(x14)                           ;
_l42:   fclass.s x21, f11                         ;
_l43:   la x25, d_0_21                            ;
        lbu x13, 13(x25)                          ;
_l44:   srai x26, x23, 59                         ;
_l45:   divu x8, x30, x18                         ;
_l46:   srliw x2, x1, 15                          ;
_l47:   fmv.x.w x8, f25                           ;
_l48:   ecall                                     ;
_l49:   srliw x24, x28, 7                         ;
_l50:   bne x17, x1, _l51                         ;
_l51:   srliw x6, x1, 14                          ;
_l52:   xor x25, x25, x25                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 24                         ;
        add x25, x25, x23                         ;
        addi x4, zero, 1                          ;
        slli x4, x4, 4                            ;
        add x25, x25, x4                          ;
        csrrw x9, stval, x25                      ;
_l53:   auipc x5, 558716                          ;
_l54:   la x3, d_0_22                             ;
        addi x3, x3, 24                           ;
        lr.w x29, (x3)                            ;
_l55:   la x15, d_5_0                             ;
        addi x15, x15, -4                         ;
        amominu.w x5, x24, (x15)                  ;
_l56:   fcvt.s.wu f8, x28, dyn                    ;
_l57:   fle.s x9, f7, f4                          ;
_l58:   fclass.s x25, f8                          ;
_l59:   la x14, _l37                              ;
        flw f30, -20(x14)                         ;
_l60:   la x5, d_3_4                              ;
        addi x5, x5, -28                          ;
        amomaxu.w x5, x1, (x5)                    ;
_l61:   fcvt.s.l f22, x3, rtz                     ;
_l62:   la x10, d_4_25                            ;
        srai x10, x10, 1                          ;
        csrrc x12, pmpaddr1, x10                  ;
_l63:   fsqrt.s f1, f2, rup                       ;
_l64:   fclass.s x18, f10                         ;
_l65:   srli x8, x11, 2                           ;
_l66:   flt.s x27, f21, f16                       ;
_l67:   fcvt.w.s x23, f8, dyn                     ;
_l68:   sltiu x6, x0, 1903                        ;
_l69:   fcvt.s.lu f4, x21, rdn                    ;
_l70:   xor x18, x18, x18                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 2                          ;
        add x18, x18, x22                         ;
        addi x4, zero, 1                          ;
        slli x4, x4, 25                           ;
        add x18, x18, x4                          ;
        csrrc x15, frm, x18                       ;
_l71:   bgeu x29, x9, _l164                       ;
_l72:   fmin.s f10, f11, f16                      ;
_l73:   la x27, d_2_14                            ;
        sh x10, 0(x27)                            ;
_l74:   la x30, d_1_23                            ;
        lw x6, -28(x30)                           ;
_l75:   xori x10, x21, -1614                      ;
_l76:   divuw x3, x1, x6                          ;
_l77:   fsqrt.s f16, f10, dyn                     ;
_l78:   div x27, x8, x20                          ;
_l79:   la x14, d_5_16                            ;
        lui x20, 0xffe00                          ;
        xor x14, x14, x20                         ;
        sw x6, -24(x14)                           ;
_l80:   fcvt.s.wu f1, x5, rup                     ;
_l81:   sllw x0, x9, x3                           ;
_l82:   divw x8, x14, x2                          ;
_l83:   fcvt.l.s x0, f1, rup                      ;
_l84:   remw x18, x19, x14                        ;
_l85:   fmv.x.w x26, f6                           ;
_l86:   fmadd.s f30, f31, f5, f26, rmm            ;
_l87:   la x18, d_2_2                             ;
        addi x18, x18, 24                         ;
        lr.d x9, (x18)                            ;
_l88:   ori x30, x3, -7                           ;
_l89:   mulhsu x14, x20, x9                       ;
_l90:   slliw x29, x14, 8                         ;
_l91:   la x1, d_1_11                             ;
        addi x1, x1, -12                          ;
        amomin.w x25, x7, (x1)                    ;
_l92:   sltiu x27, x27, 400                       ;
_l93:   srli x22, x19, 45                         ;
_l94:   la x27, d_5_0                             ;
        addi x27, x27, -8                         ;
        amoadd.d x20, x23, (x27)                  ;
_l95:   bltu x24, x21, _l182                      ;
_l96:   li x14, 0                                 ;
        la x12, pt0                               ;
        addi x12, x12, 24                         ;
        sfence.vma x14, x12                       ;
_l97:   mulhsu x14, x29, x22                      ;
_l98:   fmax.s f2, f22, f2                        ;
_l99:   fmul.s f16, f17, f27, dyn                 ;
_l100:  fsgnj.s f0, f9, f11                       ;
_l101:  mulh x14, x21, x22                        ;
_l102:  la x7, d_1_18                             ;
        lbu x25, -7(x7)                           ;
_l103:  ecall                                     ;
_l104:  xori x5, x15, -2047                       ;
_l105:  la x29, d_0_16                            ;
        lui x6, 0xffe00                           ;
        xor x29, x29, x6                          ;
        lhu x30, -10(x29)                         ;
_l106:  fcvt.s.w f25, x24, rmm                    ;
_l107:  slti x21, x16, 675                        ;
_l108:  fdiv.s f12, f27, f10, rtz                 ;
_l109:  mulhu x5, x28, x29                        ;
_l110:  la x13, d_4_21                            ;
        addi x13, x13, -0                         ;
        sc.w x6, x27, (x13)                       ;
_l111:  la x5, d_3_19                             ;
        addi x5, x5, 0                            ;
        amomax.d x2, x26, (x5)                    ;
_l112:  rem x28, x21, x18                         ;
_l113:  la x23, d_2_16                            ;
        addi x23, x23, 4                          ;
        amomaxu.w x22, x4, (x23)                  ;
_l114:  la x6, d_2_14                             ;
        addi x6, x6, 8                            ;
        amoor.w x19, x6, (x6)                     ;
_l115:  xori x11, x28, -2047                      ;
_l116:  la x27, d_4_19                            ;
        addi x27, x27, -16                        ;
        amoor.d x18, x12, (x27)                   ;
_l117:  la x12, d_2_9                             ;
        sh x22, 0(x12)                            ;
_l118:  sltiu x9, x19, -2047                      ;
_l119:  fcvt.s.w f15, x27, dyn                    ;
_l120:  la x30, d_2_12                            ;
        lbu x9, -22(x30)                          ;
_l121:  bgeu x4, x27, _l194                       ;
_l122:  fsgnjx.s f8, f30, f6                      ;
_l123:  addiw x23, x4, -2047                      ;
_l124:  slti x25, x1, 302                         ;
_l125:  la x4, d_2_26                             ;
        addi x4, x4, -0                           ;
        amominu.w x1, x6, (x4)                    ;
_l126:  mulhu x26, x11, x26                       ;
_l127:  la x14, d_0_12                            ;
        addi x14, x14, 8                          ;
        lui x5, 0xffe00                           ;
        xor x14, x14, x5                          ;
        amoadd.d x18, x5, (x14)                   ;
_l128:  la x6, _l156                              ;
        csrrw zero, uepc, x6                      ;
        uret                                      ;
_l129:  bgeu x19, x17, _l192                      ;
_l130:  ori x23, x23, 0                           ;
_l131:  la x28, d_2_10                            ;
        addi x28, x28, 0                          ;
        amominu.w x28, x22, (x28)                 ;
_l132:  la x30, d_5_26                            ;
        lui x9, 0xffe00                           ;
        xor x30, x30, x9                          ;
        lhu x26, 30(x30)                          ;
_l133:  lui x13, 236716                           ;
_l134:  addw x13, x7, x14                         ;
_l135:  la x8, d_4_10                             ;
        addi x8, x8, 8                            ;
        amomin.w x18, x26, (x8)                   ;
_l136:  fcvt.s.lu f2, x19, rne                    ;
_l137:  la x26, d_3_6                             ;
        ld x4, 16(x26)                            ;
_l138:  addiw x22, x27, 1437                      ;
_l139:  div x10, x22, x6                          ;
_l140:  andi x17, x6, -0                          ;
_l141:  fence                                     ;
_l142:  bge x10, x1, _l177                        ;
_l143:  bne x20, x21, _l157                       ;
_l144:  rem x7, x11, x2                           ;
_l145:  bne x27, x6, _l167                        ;
_l146:  rem x16, x8, x28                          ;
_l147:  csrrwi x8, pmpaddr3, 12                   ;
_l148:  fmul.s f10, f21, f6, rup                  ;
_l149:  xor x25, x25, x25                         ;
        addi x19, zero, 3                         ;
        slli x19, x19, 24                         ;
        add x25, x25, x19                         ;
        csrrw x11, satp, x25                      ;
_l150:  la x28, d_3_6                             ;
        addi x28, x28, -28                        ;
        amoadd.w x20, x18, (x28)                  ;
_l151:  la x30, d_5_23                            ;
        sb x23, 14(x30)                           ;
_l152:  xori x14, x25, -1185                      ;
_l153:  fcvt.s.lu f31, x28, rmm                   ;
_l154:  csrrwi x27, mscratch, 31                  ;
_l155:  remuw x6, x19, x9                         ;
_l156:  la x23, d_2_3                             ;
        addi x23, x23, 28                         ;
        amoxor.w x27, x6, (x23)                   ;
_l157:  remw x3, x24, x16                         ;
_l158:  fmsub.s f22, f12, f11, f8, rup            ;
_l159:  csrrci x9, pmpaddr5, 18                   ;
_l160:  blt x1, x6, _l191                         ;
_l161:  fcvt.l.s x9, f18, rne                     ;
_l162:  la x22, d_0_10                            ;
        lb x14, -8(x22)                           ;
_l163:  fsqrt.s f5, f10, rtz                      ;
_l164:  fsub.s f23, f26, f31, rmm                 ;
_l165:  fle.s x23, f31, f30                       ;
_l166:  la x22, d_5_25                            ;
        addi x22, x22, 24                         ;
        amoxor.d x8, x23, (x22)                   ;
_l167:  srli x13, x4, 3                           ;
_l168:  srai x21, x15, 27                         ;
_l169:  la x2, _l27                               ;
        srai x2, x2, 1                            ;
        csrrw x22, pmpaddr5, x2                   ;
_l170:  mulhu x3, x25, x24                        ;
_l171:  fnmadd.s f20, f21, f28, f27, rdn          ;
_l172:  la x14, d_4_7                             ;
        lui x11, 0xffe00                          ;
        xor x14, x14, x11                         ;
        lw x19, -0(x14)                           ;
_l173:  fclass.s x30, f23                         ;
_l174:  ori x6, x27, -100                         ;
_l175:  fmv.w.x f5, x2                            ;
_l176:  la x27, d_2_18                            ;
        lhu x11, -10(x27)                         ;
_l177:  fmin.s f0, f24, f11                       ;
_l178:  la x24, d_0_11                            ;
        sd x21, 8(x24)                            ;
_l179:  xor x15, x15, x15                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 19                         ;
        add x15, x15, x22                         ;
        addi x30, zero, 1                         ;
        slli x30, x30, 12                         ;
        add x15, x15, x30                         ;
        csrrw x16, medeleg, x15                   ;
_l180:  la x24, d_5_5                             ;
        addi x24, x24, -0                         ;
        sc.w x21, x22, (x24)                      ;
_l181:  srli x23, x16, 33                         ;
_l182:  la x10, d_5_27                            ;
        addi x10, x10, -0                         ;
        lui x12, 0xffe00                          ;
        xor x10, x10, x12                         ;
        lr.d x6, (x10)                            ;
_l183:  la x30, d_2_15                            ;
        fsw f11, -0(x30)                          ;
_l184:  la x25, d_0_27                            ;
        addi x25, x25, 8                          ;
        lui x3, 0xffe00                           ;
        xor x25, x25, x3                          ;
        lr.w x30, (x25)                           ;
_l185:  la x4, d_0_15                             ;
        addi x4, x4, 28                           ;
        amoxor.w x30, x28, (x4)                   ;
_l186:  ebreak                                    ;
_l187:  ebreak                                    ;
_l188:  fnmsub.s f10, f11, f12, f5, rmm           ;
_l189:  la x17, d_4_5                             ;
        addi x17, x17, 8                          ;
        amomax.d x6, x18, (x17)                   ;
_l190:  slti x6, x29, 1279                        ;
_l191:  la x6, d_0_1                              ;
        ld x30, -0(x6)                            ;
_l192:  la x25, d_0_22                            ;
        addi x25, x25, -0                         ;
        amominu.w x18, x21, (x25)                 ;
_l193:  blt x27, x2, _l197                        ;
_l194:  fadd.s f17, f15, f7, rne                  ;
_l195:  bgeu x3, x13, _l200                       ;
_l196:  srai x30, x7, 0                           ;
_l197:  fence                                     ;
_l198:  la x21, d_4_27                            ;
        addi x21, x21, 28                         ;
        lr.w x16, (x21)                           ;
_l199:  ori x25, x23, -0                          ;
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
                .dword 0xa24015c4ef554c1c, 0x65d810222466a18a
                .dword 0xc3f7a1c17c712d1d, 0xa81859a726d3e27e
d_0_0:          .dword 0xf795a4b8c6beb004, 0x8e97ee9c4b2f9d5d
d_0_1:          .dword 0x4b75188a18ae06fd, 0xb1949bc06ff0c113
d_0_2:          .dword 0x1170962bda3b25c7, 0x07ff3f9bd9989f23
d_0_3:          .dword 0xa4173b6f440a71f9, 0xf449faed5aad203a
d_0_4:          .dword 0xed7f502ab44ff5aa, 0xe896df3a8db474ca
d_0_5:          .dword 0xa97da3c58ac0b529, 0x065cf1ae0be0ede2
d_0_6:          .dword 0x271615ac37e7a960, 0x2d8235fc64ecf384
d_0_7:          .dword 0x203a31da9ceb5d6f, 0x9d673e27749f870d
d_0_8:          .dword 0xcad16dd68946cac4, 0xa1b03f7245d5acf5
d_0_9:          .dword 0x6c52dbf1a11c5d3f, 0x08380699cd826894
d_0_10:         .dword 0x29ae0ccff94af388, 0x563dd39b1e886832
d_0_11:         .dword 0x863860d434a3c9d8, 0x029e3f4c1c129b2e
d_0_12:         .dword 0x0875ab0caa61b150, 0xdf85ca06e08b8a21
d_0_13:         .dword 0x8197049c545a12d3, 0x13d8991962752cbf
d_0_14:         .dword 0x4ae89b854049bd2e, 0xc6f8f4f02fe3f22c
d_0_15:         .dword 0x87c28ab6eda3d52f, 0x5a5b6d415f3cf0f3
d_0_16:         .dword 0xc481d41163cdeb9e, 0x9b9574155188eedd
d_0_17:         .dword 0xe2c608accf29ac8e, 0x00b25da49c94873b
d_0_18:         .dword 0xe3d092479a19f72b, 0x7a7bbdf2679c29be
d_0_19:         .dword 0x4986922ad9d4cfc4, 0x182014ddef5cf185
d_0_20:         .dword 0x9db2d42a722e6c5f, 0x4aec0f31fe4d0e4a
d_0_21:         .dword 0xca944678e8c34894, 0xa0846dc2eb8df71d
d_0_22:         .dword 0x63ee134f5714bb8c, 0x5001ad970b144cbe
d_0_23:         .dword 0xe3473809a50b599c, 0xb154c03291698e81
d_0_24:         .dword 0x8b42e2ad751c57b8, 0x446dab22b50669f9
d_0_25:         .dword 0x56ab70c0769178a9, 0xac20def943ac8447
d_0_26:         .dword 0x5998e048fc3d20d4, 0x8c567797bd9a1a28
d_0_27:         .dword 0xfde4b99a788796c0, 0x50cf37ac28fd82dd
                .dword 0xacd94ee5a7882da7, 0xfefecf531c5bb187
                .dword 0x10a52cd3599772f1, 0x4f81c1b700baa490
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xdc5951517c0e17f3, 0xf97809a7a7381ffe
                .dword 0x1e1aa083031d0625, 0x33c4664753deae03
d_1_0:          .dword 0xd4a1543b1996dc3f, 0x6bad43941cccc515
d_1_1:          .dword 0xe60db2e35efde134, 0x91df62c87882bcf1
d_1_2:          .dword 0x994d79ba79c5c747, 0x6ec5a625e24e8334
d_1_3:          .dword 0xc79d3f84d39497b1, 0xb85cb5d116856b52
d_1_4:          .dword 0xdae789b142a1b6ed, 0x626ac2f0f23d97be
d_1_5:          .dword 0xdf84040b632abf26, 0xb3237024652c02a6
d_1_6:          .dword 0x040e4c4c523258a3, 0x04c5b5805c15286c
d_1_7:          .dword 0x32b8222dd66b8708, 0xc706fd402ea6d17d
d_1_8:          .dword 0x92c91adb15787610, 0x26fa662846cf585a
d_1_9:          .dword 0xa754493a8f32922e, 0xa5b4f3160d7b715d
d_1_10:         .dword 0x5c1ecbb386b8b94a, 0x5a653d7003935fa3
d_1_11:         .dword 0x8d562af5d756f9ee, 0x2c591ac9d92a5145
d_1_12:         .dword 0xa3cdca7ef54b97ff, 0x3cbcecfc28274eda
d_1_13:         .dword 0x708e3a787b5f56aa, 0xe911d8ced6ed2132
d_1_14:         .dword 0xa4062115905803f7, 0x45e030f45217afe4
d_1_15:         .dword 0x9cb26125b0667338, 0x17ec2526da83b1eb
d_1_16:         .dword 0x234cb252a1f65ffe, 0xab09b72d8e4bc626
d_1_17:         .dword 0x8b54cb4dfdb3ef9c, 0x540d1f1988a9848d
d_1_18:         .dword 0xc4e412c04b3cdebc, 0xe6aeca0baa9d3a24
d_1_19:         .dword 0xf76215e9b47aa9c6, 0xb50248956777f71f
d_1_20:         .dword 0x50c1d79342f249e4, 0xc3d955f6e62dc945
d_1_21:         .dword 0x3a739c1c401ae742, 0x7a6c31071f477439
d_1_22:         .dword 0xcbdfe19ffc4b98b4, 0x917d49474547b30e
d_1_23:         .dword 0xd1127868e5821aa9, 0x38dffa5dbfe809c3
d_1_24:         .dword 0x1a8a22a4f1a82d86, 0xcb6edd85a52282cf
d_1_25:         .dword 0x6b89f22c4871ab99, 0xab6890c4df968357
d_1_26:         .dword 0x2d0f674f28563ea6, 0xfb3416af7fa5f3e6
d_1_27:         .dword 0x630d89abd260d262, 0xbebe1b11f8a4cfff
                .dword 0x5172ca52c26de9fe, 0x5cb1e03ccda4c7e8
                .dword 0xdd705df5dc7d2efe, 0xee5353caf5ad4fa0
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x67bddc35146891c8, 0x89ccebbb78992e30
                .dword 0x6f0f12b2e2a92006, 0xf7b8b071533a104e
d_2_0:          .dword 0xd5ca6c680122711f, 0x21b9988a73302a90
d_2_1:          .dword 0x018cbcae7a02a678, 0xce5796b2900e325a
d_2_2:          .dword 0xc749b3127d7d79d3, 0xfcca4a7262aacc7c
d_2_3:          .dword 0xe9fa44e79b84cc98, 0xd20f715f62e7fdda
d_2_4:          .dword 0x73bcb9673693e22e, 0x9e0d9a5518e967c4
d_2_5:          .dword 0xb6484c229e4f3bc9, 0x26e964ea4f91cd3d
d_2_6:          .dword 0x478c4471fd6cbe53, 0x21bcf389e279d3ac
d_2_7:          .dword 0xee9e882740e3d069, 0x31e91ac555b476b3
d_2_8:          .dword 0x738ea304ae62f2ec, 0x8834bab40a4eb58f
d_2_9:          .dword 0x0c6c4577f4d39420, 0x24f8bd5315e30013
d_2_10:         .dword 0x974daaca21cd62db, 0x88617458183c9c56
d_2_11:         .dword 0x7f1a48026a96edac, 0x29018c60638c133a
d_2_12:         .dword 0xe884c99f9d72c26b, 0x9376ce251f704dec
d_2_13:         .dword 0x21e3c4d727186607, 0x0b24c04701c818bc
d_2_14:         .dword 0xa3caf70a5c42741b, 0xa92ec63021fdf14a
d_2_15:         .dword 0xf6d288cb48088986, 0xed2ca8d8b7ed54df
d_2_16:         .dword 0xedee440baf20132b, 0xe40f79e8fa5bd40e
d_2_17:         .dword 0xef0c4851d6a56722, 0xefaf74990402d91d
d_2_18:         .dword 0x5938b8bdb61066fd, 0x247ee4a7f25722d6
d_2_19:         .dword 0xfbc6e05e76e86354, 0x050a1474153a4cd0
d_2_20:         .dword 0x4772b81282f47207, 0xde28eac4895acfe5
d_2_21:         .dword 0xe033a3b97c7c2a88, 0xe3517503a72492c1
d_2_22:         .dword 0xe8855d4b3f78a092, 0x631f434f66a466b7
d_2_23:         .dword 0x56b597a9abcef80a, 0x08bf842d64339007
d_2_24:         .dword 0x4df4ff175cf3c070, 0x3324dbc3608e6617
d_2_25:         .dword 0xa6cd09c34661fb3c, 0xf8a2a55abb25b11b
d_2_26:         .dword 0x0df71425cfe2a327, 0x580e4810ce941c41
d_2_27:         .dword 0x04fd32ab43f504e6, 0xecb6a431844b6772
                .dword 0x045c6a7e0cf81f5f, 0xfb1e47de30138fb2
                .dword 0x0396d7fc4e6db77f, 0x43ebb7b3b7558465
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xa0eb43d28695e6ae, 0x87bb82293238307b
                .dword 0xe58adf48c1bea88e, 0x6c126fb3f25c9289
d_3_0:          .dword 0xc1a2ea7055306811, 0xc1d9ec0a1e4ecc28
d_3_1:          .dword 0x841c7f259fe2157e, 0xb5f8c9979199554d
d_3_2:          .dword 0x050056bf91eb7ecd, 0xaf0fe57e57139b36
d_3_3:          .dword 0x0e8cd4437bb6215f, 0x60bb410a054b053f
d_3_4:          .dword 0x044ade8dd3646385, 0xfc231c876bfb7055
d_3_5:          .dword 0x53792f1af1eeafee, 0x874bd59a9ea93b59
d_3_6:          .dword 0xf959b043ac5ba22c, 0xc324f1e0d73919a1
d_3_7:          .dword 0x405dc100190b1406, 0xfde94be594c61ac1
d_3_8:          .dword 0xdd9b29ef75c3b216, 0x8f8a6fd540f7eb1c
d_3_9:          .dword 0xdb82a604263ff862, 0xe978d0b9a0be49c5
d_3_10:         .dword 0x6a760019e817b3c4, 0x08a1e250ace5d2b9
d_3_11:         .dword 0x1ff7276b25324eaf, 0x55d5caf87631502c
d_3_12:         .dword 0xc8e13df056722781, 0x79a1ee3cd9aa7754
d_3_13:         .dword 0x0d9a62ebb4c923ce, 0xd0db44f0744d22b1
d_3_14:         .dword 0x391f4a1077886124, 0xa6f647b4272a21df
d_3_15:         .dword 0xc129dbf1edf42e20, 0xf900f159baf7e82a
d_3_16:         .dword 0xa161e59b83b17296, 0xf65e61078e6ac201
d_3_17:         .dword 0x40beb1900f9455b5, 0xfad628847f7c2d4c
d_3_18:         .dword 0x9f2d652561f75a99, 0xe6fef416f9ef0c56
d_3_19:         .dword 0xd9c62b980ad0c025, 0x01ed336ab1f8d25d
d_3_20:         .dword 0xc5cf35bdf804033a, 0xf990ce6bda07102a
d_3_21:         .dword 0x80a61b49f12c3575, 0x2b45b8ecc544c4e0
d_3_22:         .dword 0x3d5d58f76357e83b, 0x1fe3f74604c4b38c
d_3_23:         .dword 0x26fb3001b673ff6c, 0x5d8ec0a63e9677bc
d_3_24:         .dword 0x22159026c670027f, 0x85964405236ea91d
d_3_25:         .dword 0x86f01e32f225a5d1, 0xe866e8242bd854be
d_3_26:         .dword 0x5b22548c036415cc, 0x078b7d10799d55ba
d_3_27:         .dword 0xbe4f20317bc2be4e, 0xe0d54536d5ada8b6
                .dword 0x1f8346cef809674a, 0x3b750f0cc64e78dc
                .dword 0xeeb67766c8aea4d6, 0xb42bf130e9c5b289
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0f0d4e231e49c34a, 0x85ecf52d9640f60e
                .dword 0x77e0c23cff3d940f, 0x1ae91e92064c5b04
d_4_0:          .dword 0x86248facf29e576d, 0x0c8a10372e68efc7
d_4_1:          .dword 0x828e3e624125711d, 0xf24ab90fb9af72a7
d_4_2:          .dword 0xa85da2909a5efbf5, 0x0128ef4546d23e19
d_4_3:          .dword 0xea38739330a9f049, 0x5aff1e67beaff02f
d_4_4:          .dword 0xe613afd5006041d1, 0xf7a3c98e327311fd
d_4_5:          .dword 0x3ed3033ff23c00d4, 0x5c618f4b50263a18
d_4_6:          .dword 0xae1aa2d74c5b54b6, 0xb68401c737f5089c
d_4_7:          .dword 0x8e4240ab44a0b6a6, 0xb48eeb5c0b03d111
d_4_8:          .dword 0x59580115943e0094, 0x14e9b422acc240b8
d_4_9:          .dword 0xf470546e7942753a, 0x7352bbf4d5bb9dca
d_4_10:         .dword 0xedc9149ddf072f25, 0xf55727b5ac466f3f
d_4_11:         .dword 0x21ae04ebc0c5875b, 0x14ebfe9230deb91e
d_4_12:         .dword 0x86188d56c2b75424, 0x2ce5d9f60cf6d255
d_4_13:         .dword 0xb0612cc99e2003fa, 0xba90e93d87f2735a
d_4_14:         .dword 0x2fccfea06b05cfdd, 0xe9eb1b817dd4fd12
d_4_15:         .dword 0xa036a84776e88353, 0xba78dead823cf6e4
d_4_16:         .dword 0x8df2b3e42fcde4f7, 0xd3c80108c24b4cf9
d_4_17:         .dword 0xb0f66b7626de64ab, 0xb89a5b6bdde4a374
d_4_18:         .dword 0x25da7bd8d6895dfa, 0xca721dd739647dcd
d_4_19:         .dword 0x472dc251ab1e57ca, 0x19a17a5faadcae2f
d_4_20:         .dword 0x8ffadfa0c85d506b, 0xed1a567b94b73fd4
d_4_21:         .dword 0xeb63680744f157b7, 0xd6617c0c5d141c59
d_4_22:         .dword 0x175e13d6869e5bf8, 0x5b5145aa7a07cd3f
d_4_23:         .dword 0x6f2543fe9cbf9406, 0x0881f6b787b8ba54
d_4_24:         .dword 0x58251518edcc29a8, 0xf4f0e7f091d57bcb
d_4_25:         .dword 0x81efec4bee051956, 0xd65ba72e7feb56c3
d_4_26:         .dword 0x352705b3b245318c, 0xd00cfc550264b199
d_4_27:         .dword 0x1fb7d89a93cfc663, 0x39c7735599b5c6ba
                .dword 0x7495ce6d3544489f, 0x5a6d7d4729590e4c
                .dword 0xc2a4fdc117fc9d6a, 0x410817419f35ea1b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xb7f99ccce28e1f1e, 0x12a908e9858de663
                .dword 0x37907cac5047fa59, 0x9dd4f77a122793ac
d_5_0:          .dword 0x4e5da63ae3a60af5, 0x37192520fb6beef4
d_5_1:          .dword 0xdf28b84e6dc78155, 0x4c1fadceb671efb1
d_5_2:          .dword 0x1a38ff17928b724c, 0x55394b7ba88d45c9
d_5_3:          .dword 0x5b33f61dadce0b11, 0xf7b58436537b3af3
d_5_4:          .dword 0x5723beeafc0e2981, 0xf7526651173895a3
d_5_5:          .dword 0x8a97f8d7ba274780, 0x5d87b91cb23aaf03
d_5_6:          .dword 0x45eea88da5031edb, 0x9998b69c6b974775
d_5_7:          .dword 0x6ee7d91458bc6317, 0xbbab24bfa61e4122
d_5_8:          .dword 0xc2673084a61ca01a, 0x880a6c65902ce9ea
d_5_9:          .dword 0xf80741f41a9389b4, 0xee6cf148871d72b8
d_5_10:         .dword 0x4347fb887d460d55, 0x12acdc9f7167585b
d_5_11:         .dword 0xabc299653ab5be3f, 0xe27d3173d6f0a549
d_5_12:         .dword 0x57064a9b8b5fe7cd, 0x1f7cf0d1b0440603
d_5_13:         .dword 0x00c2bcc5fddd0cd6, 0xb345b4b2431e100e
d_5_14:         .dword 0xd889562724cc0620, 0x000055e24eae0145
d_5_15:         .dword 0xb8e1ac4bb4d5908c, 0xeba5c9b86a5bccbc
d_5_16:         .dword 0xeef683334052cb84, 0xce1df3fd79233510
d_5_17:         .dword 0xb0380e120b8758b5, 0x3b501644cabf5af3
d_5_18:         .dword 0x5205195ff570bca6, 0x8255b31f3582b3b2
d_5_19:         .dword 0x9e20c43a086b5b01, 0xa5364ccf0d492b67
d_5_20:         .dword 0x0ae8bbabab47fdd4, 0x145ccfbae03739cd
d_5_21:         .dword 0x67e7b89bbdceb4c4, 0x0c205d3e47beb5cf
d_5_22:         .dword 0x1635952937f29dd9, 0x55b85c8b4bfd4786
d_5_23:         .dword 0x381cf9d41418d1ec, 0xf075e7881337aaf8
d_5_24:         .dword 0xf8ded3ea52c34a4b, 0x533600bb1679153e
d_5_25:         .dword 0xd1c1eed18ca68554, 0xb4a09d41895dc808
d_5_26:         .dword 0xc4ffb3e6b7ffcb4e, 0xd9a5de2a58f339f5
d_5_27:         .dword 0xfee27acd8d12e508, 0x33d64cc875ee7cd9
                .dword 0x47896694e4189028, 0x370c8e05c9715b6d
                .dword 0xe452046697031956, 0x3dcdc1e95503f6d1
         /* Random data */
_end_data5:
              
                 
