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
_s0:    fmax.s f9, f21, f10                       ;
_s1:    ebreak                                    ;
_s2:    fsgnj.s f28, f5, f1                       ;
_s3:    fdiv.s f27, f24, f30, rtz                 ;
_s4:    fclass.s x2, f8                           ;
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
_p0:    la x14, d_3_25                            ;
        srai x14, x14, 1                          ;
        csrrw x12, pmpaddr4, x14                  ;
_p1:    xor x11, x11, x11                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 14                         ;
        add x11, x11, x11                         ;
        csrrw x10, stval, x11                     ;
_p2:    xor x11, x11, x11                         ;
        csrrw x14, mip, x11                       ;
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
_l0:    fclass.s x20, f0                          ;
_l1:    la x28, d_3_24                            ;
        sw x4, -28(x28)                           ;
_l2:    la x23, d_1_15                            ;
        fsw f15, -12(x23)                         ;
_l3:    ecall                                     ;
_l4:    slli x17, x4, 51                          ;
_l5:    div x14, x14, x7                          ;
_l6:    addiw x18, x15, -24                       ;
_l7:    fmadd.s f1, f31, f2, f26, rmm             ;
_l8:    fcvt.w.s x24, f24, rup                    ;
_l9:    ebreak                                    ;
_l10:   andi x10, x3, 2047                        ;
_l11:   la x24, d_3_19                            ;
        addi x24, x24, 16                         ;
        amomax.d x5, x19, (x24)                   ;
_l12:   mulh x29, x7, x23                         ;
_l13:   la x15, d_3_26                            ;
        addi x15, x15, 0                          ;
        amoor.d x5, x28, (x15)                    ;
_l14:   la x24, d_4_12                            ;
        addi x24, x24, -0                         ;
        amoxor.d x7, x17, (x24)                   ;
_l15:   la x19, d_4_20                            ;
        addi x19, x19, 8                          ;
        lui x30, 0xffe00                          ;
        xor x19, x19, x30                         ;
        amominu.d x5, x30, (x19)                  ;
_l16:   la x1, _l158                              ;
        jalr x28, 0(x1)                           ;
_l17:   bne x15, x13, _l19                                ;
_l18:   remuw x30, x9, x7                         ;
_l19:   la x1, _l41                                       ;
        jalr x5, 0(x1)                            ;
_l20:   la x5, d_3_4                              ;
        addi x5, x5, -12                          ;
        amoor.w x5, x13, (x5)                     ;
_l21:   mulh x2, x11, x3                          ;
_l22:   addi x30, x22, 2047                       ;
_l23:   la x13, d_5_18                            ;
        addi x13, x13, 28                         ;
        amoxor.w x23, x23, (x13)                  ;
_l24:   bne x25, x6, _l86                                 ;
_l25:   bge x30, x15, _l99                        ;
_l26:   subw x1, x24, x27                         ;
_l27:   la x24, d_0_0                             ;
        addi x24, x24, 0                          ;
        amominu.d x26, x7, (x24)                  ;
_l28:   mulh x20, x14, x13                        ;
_l29:   la x14, d_4_16                            ;
        ld x2, -0(x14)                            ;
_l30:   la x16, d_0_23                            ;
        addi x16, x16, 0                          ;
        amoxor.d x25, x25, (x16)                  ;
_l31:   ori x11, x28, 1847                        ;
_l32:   fsqrt.s f11, f4, rup                      ;
_l33:   csrrci x3, pmpcfg0, 31                    ;
_l34:   la x8, d_0_10                             ;
        addi x8, x8, -8                           ;
        amoxor.d x16, x24, (x8)                   ;
_l35:   fnmsub.s f27, f27, f14, f6, dyn           ;
_l36:   andi x2, x16, -220                        ;
_l37:   sllw x1, x3, x12                          ;
_l38:   xor x24, x24, x24                         ;
        csrrs x7, fcsr, x24                       ;
_l39:   la x12, d_5_2                             ;
        lhu x16, -6(x12)                          ;
_l40:   addw x10, x1, x22                         ;
_l41:   la x29, d_2_25                            ;
        lbu x3, -0(x29)                           ;
_l42:   la x11, _l198                                     ;
        lwu x1, -8(x11)                           ;
_l43:   slli x4, x12, 25                          ;
_l44:   ecall                                     ;
_l45:   bgeu x28, x15, _l94                               ;
_l46:   la x15, d_4_4                             ;
        addi x15, x15, -24                        ;
        amoor.d x28, x24, (x15)                   ;
_l47:   srai x15, x0, 23                          ;
_l48:   divuw x30, x3, x2                         ;
_l49:   csrrsi x25, sip, 31                       ;
_l50:   la x2, d_2_17                             ;
        sd x6, 24(x2)                             ;
_l51:   fadd.s f25, f12, f13, rmm                 ;
_l52:   la x29, d_4_1                             ;
        lh x23, 4(x29)                            ;
_l53:   fmsub.s f17, f16, f7, f25, dyn            ;
_l54:   srlw x30, x11, x22                        ;
_l55:   csrrci x15, medeleg, 26                   ;
_l56:   la x29, d_4_27                            ;
        addi x29, x29, -28                        ;
        amominu.w x18, x10, (x29)                 ;
_l57:   fcvt.wu.s x0, f6, dyn                     ;
_l58:   beq x28, x6, _l119                                ;
_l59:   fmadd.s f6, f20, f4, f9, rne              ;
_l60:   divu x16, x0, x13                         ;
_l61:   la x22, d_2_10                            ;
        lw x17, -28(x22)                          ;
_l62:   srlw x28, x16, x12                        ;
_l63:   addw x15, x2, x26                         ;
_l64:   la x22, d_5_23                            ;
        lb x4, 14(x22)                            ;
_l65:   fmv.w.x f15, x15                          ;
_l66:   addi x11, x24, -607                       ;
_l67:   fcvt.wu.s x30, f26, rtz                   ;
_l68:   la x8, d_5_24                             ;
        addi x8, x8, 0                            ;
        amominu.d x4, x9, (x8)                    ;
_l69:   remu x5, x7, x8                           ;
_l70:   la x1, d_5_12                             ;
        sb x11, 20(x1)                            ;
_l71:   rem x12, x12, x11                         ;
_l72:   la x30, d_1_2                             ;
        addi x30, x30, -12                        ;
        amoor.w x7, x2, (x30)                     ;
_l73:   la x5, _l172                                      ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l74:   la x1, d_1_24                             ;
        addi x1, x1, -8                           ;
        amoxor.w x12, x9, (x1)                    ;
_l75:   sllw x28, x24, x29                        ;
_l76:   la x15, d_5_13                            ;
        addi x15, x15, 28                         ;
        amoor.w x19, x2, (x15)                    ;
_l77:   fcvt.l.s x22, f8, rdn                     ;
_l78:   fence                                     ;
_l79:   fmsub.s f1, f15, f8, f26, rup             ;
_l80:   la x3, d_5_23                             ;
        lhu x19, -30(x3)                          ;
_l81:   la x17, d_0_0                             ;
        addi x17, x17, 12                         ;
        amoxor.w x7, x29, (x17)                   ;
_l82:   bltu x19, x10, _l119                              ;
_l83:   la x20, d_3_15                            ;
        fsw f20, -20(x20)                         ;
_l84:   fence.i                                   ;
_l85:   fcvt.s.lu f4, x14, dyn                    ;
_l86:   divw x13, x5, x27                         ;
_l87:   fsgnjn.s f27, f0, f15                     ;
_l88:   fcvt.l.s x8, f6, dyn                      ;
_l89:   la x28, d_2_17                            ;
        addi x28, x28, -16                        ;
        amoswap.w x12, x17, (x28)                 ;
_l90:   la x16, d_3_24                            ;
        addi x16, x16, 0                          ;
        amomaxu.d x24, x21, (x16)                 ;
_l91:   srai x20, x21, 60                         ;
_l92:   fmv.x.w x23, f23                          ;
_l93:   la x14, _l24                              ;
        lhu x6, 12(x14)                           ;
_l94:   bge x13, x13, _l125                               ;
_l95:   la x26, d_2_7                             ;
        addi x26, x26, 0                          ;
        amoswap.d x6, x15, (x26)                  ;
_l96:   la x28, d_5_6                             ;
        addi x28, x28, -0                         ;
        sc.d x16, x28, (x28)                      ;
_l97:   andi x14, x22, -2047                      ;
_l98:   fnmadd.s f22, f21, f23, f10, rne          ;
_l99:   fmv.x.w x23, f20                          ;
_l100:  la x30, d_1_1                             ;
        addi x30, x30, -0                         ;
        amomin.d x9, x21, (x30)                   ;
_l101:  slliw x14, x6, 18                         ;
_l102:  slti x23, x20, 29                         ;
_l103:  ori x25, x9, 21                           ;
_l104:  la x20, d_2_1                             ;
        lw x23, -8(x20)                           ;
_l105:  fle.s x16, f25, f27                       ;
_l106:  divw x14, x6, x30                         ;
_l107:  fence                                     ;
_l108:  la x22, d_3_14                            ;
        addi x22, x22, 20                         ;
        amoadd.w x19, x20, (x22)                  ;
_l109:  fence.i                                   ;
_l110:  divu x22, x12, x23                        ;
_l111:  fmv.w.x f25, x5                           ;
_l112:  la x16, _l177                                     ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l113:  la x22, d_2_16                            ;
        sh x30, 20(x22)                           ;
_l114:  fadd.s f10, f31, f4, dyn                  ;
_l115:  slti x22, x2, 1310                        ;
_l116:  la x20, d_3_14                            ;
        addi x20, x20, 0                          ;
        amominu.d x2, x20, (x20)                  ;
_l117:  la x13, _l124                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l118:  rem x2, x13, x19                          ;
_l119:  div x7, x12, x7                           ;
_l120:  fcvt.s.wu f7, x4, rne                     ;
_l121:  fsub.s f16, f26, f11, rup                 ;
_l122:  addw x12, x4, x18                         ;
_l123:  sraw x11, x5, x27                         ;
_l124:  fmin.s f9, f27, f26                       ;
_l125:  la x3, d_1_5                              ;
        sh x15, -18(x3)                           ;
_l126:  la x20, _l116                                     ;
        lbu x9, 13(x20)                           ;
_l127:  fmax.s f17, f14, f4                       ;
_l128:  la x15, d_5_5                             ;
        addi x15, x15, 24                         ;
        amomin.w x4, x29, (x15)                   ;
_l129:  bgeu x26, x23, _l189                      ;
_l130:  bltu x12, x1, _l189                               ;
_l131:  fnmadd.s f1, f24, f9, f0, rdn             ;
_l132:  xori x8, x29, 3                           ;
_l133:  xor x7, x7, x7                            ;
        csrrc x18, scause, x7                     ;
_l134:  la x6, d_1_19                             ;
        addi x6, x6, 16                           ;
        amoxor.d x18, x20, (x6)                   ;
_l135:  fmv.x.w x12, f11                          ;
_l136:  sraw x18, x19, x24                        ;
_l137:  ecall                                     ;
_l138:  mul x13, x9, x15                          ;
_l139:  fcvt.l.s x5, f4, rdn                      ;
_l140:  sraiw x21, x25, 12                        ;
_l141:  la x23, d_3_18                            ;
        sw x1, -28(x23)                           ;
_l142:  sraiw x24, x11, 31                        ;
_l143:  andi x13, x3, -2038                       ;
_l144:  bltu x26, x12, _l160                      ;
_l145:  la x30, d_5_8                             ;
        lhu x15, -18(x30)                         ;
_l146:  fmadd.s f11, f23, f15, f0, rne            ;
_l147:  fcvt.lu.s x5, f2, dyn                     ;
_l148:  mulw x12, x6, x23                         ;
_l149:  ori x14, x19, 2047                        ;
_l150:  la x26, _l162                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l151:  fmadd.s f17, f5, f25, f3, rtz             ;
_l152:  feq.s x25, f22, f19                       ;
_l153:  la x4, d_1_0                              ;
        addi x4, x4, 0                            ;
        amoor.d x26, x29, (x4)                    ;
_l154:  la x7, d_4_4                              ;
        addi x7, x7, -0                           ;
        amomin.d x1, x24, (x7)                    ;
_l155:  srai x0, x4, 12                           ;
_l156:  auipc x11, 71060                          ;
_l157:  la x4, d_0_20                             ;
        addi x4, x4, -28                          ;
        amomaxu.w x17, x2, (x4)                   ;
_l158:  fadd.s f16, f9, f2, rup                   ;
_l159:  la x14, d_1_25                            ;
        lui x3, 0xffe00                           ;
        xor x14, x14, x3                          ;
        ld x17, -8(x14)                           ;
_l160:  fence                                     ;
_l161:  srli x27, x0, 8                           ;
_l162:  remu x0, x3, x23                          ;
_l163:  fcvt.l.s x2, f29, rup                     ;
_l164:  la x17, d_4_21                            ;
        lb x12, 31(x17)                           ;
_l165:  jal x24, _l176                            ;
_l166:  lui x12, 764832                           ;
_l167:  fcvt.s.w f29, x5, rmm                     ;
_l168:  fcvt.l.s x11, f26, rne                    ;
_l169:  csrrci x23, pmpaddr5, 18                  ;
_l170:  fmv.w.x f3, x17                           ;
_l171:  la x1, d_5_3                              ;
        sd x21, 24(x1)                            ;
_l172:  fdiv.s f28, f31, f23, rup                 ;
_l173:  sllw x18, x4, x9                          ;
_l174:  bge x28, x20, _l198                               ;
_l175:  beq x10, x24, _l193                               ;
_l176:  bne x18, x7, _l180                        ;
_l177:  fadd.s f25, f10, f11, rdn                 ;
_l178:  la x15, d_2_8                             ;
        addi x15, x15, 24                         ;
        amoor.w x4, x24, (x15)                    ;
_l179:  divuw x0, x16, x26                        ;
_l180:  la x23, d_5_6                             ;
        lui x9, 0xffe00                           ;
        xor x23, x23, x9                          ;
        lw x25, 24(x23)                           ;
_l181:  la x30, _l190                                     ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l182:  srlw x11, x23, x10                        ;
_l183:  la x7, d_2_10                             ;
        sh x3, -6(x7)                             ;
_l184:  la x22, d_2_0                             ;
        addi x22, x22, 16                         ;
        amoadd.d x1, x16, (x22)                   ;
_l185:  fmul.s f20, f31, f21, rdn                 ;
_l186:  fcvt.lu.s x24, f15, rdn                   ;
_l187:  bge x2, x5, _l200                                 ;
_l188:  ecall                                     ;
_l189:  la x30, d_4_5                             ;
        addi x30, x30, 0                          ;
        amominu.w x13, x8, (x30)                  ;
_l190:  bne x23, x2, _l199                        ;
_l191:  la x16, d_2_6                             ;
        addi x16, x16, 24                         ;
        amoadd.d x7, x12, (x16)                   ;
_l192:  fadd.s f11, f22, f6, rtz                  ;
_l193:  ori x29, x20, 429                         ;
_l194:  mulh x17, x29, x28                        ;
_l195:  la x27, d_0_14                            ;
        lh x12, -16(x27)                          ;
_l196:  la x3, d_5_0                              ;
        addi x3, x3, 16                           ;
        amoadd.d x18, x16, (x3)                   ;
_l197:  auipc x16, 26                             ;
_l198:  la x19, d_3_22                            ;
        addi x19, x19, -24                        ;
        amoadd.d x8, x24, (x19)                   ;
_l199:  fsgnjx.s f12, f7, f22                     ;
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
                .dword 0x8075d83ac9e2ade5, 0xa4dc3da8e46200e0
                .dword 0xb9d8d9118d84601c, 0xb45b813dd80f9cbb
d_0_0:          .dword 0x5a22026fc6e54ff9, 0xba64fc3d8f312188
d_0_1:          .dword 0x7857a959ce4b435e, 0x441a5c68c322fc45
d_0_2:          .dword 0x99d87f5d0a3f3e92, 0xf7b967ee7b2d01ee
d_0_3:          .dword 0xe3dabb01229a49c4, 0x57c15062ad814a25
d_0_4:          .dword 0xc63c14162f874738, 0x0f8f5576f7bf6291
d_0_5:          .dword 0xe72193c5a94d782c, 0x89de17698062b30e
d_0_6:          .dword 0xda1b739af2d25856, 0x23263694917f7c72
d_0_7:          .dword 0x2b3779ff2f9ed11f, 0xdfb899401f7233a8
d_0_8:          .dword 0x662b51b5cf77d4a1, 0x851dc1ba32f143c3
d_0_9:          .dword 0x192d8223a1f8249f, 0x5d51850f76519c2b
d_0_10:         .dword 0xf69eff6147918ba2, 0x3584682bcf709ab9
d_0_11:         .dword 0x4550a46f33b6c0fd, 0x05a2ad3a4149415a
d_0_12:         .dword 0xc4290529fdd0f1d9, 0x5620eaaa2b7ae49a
d_0_13:         .dword 0x65fdf162c9983751, 0x36795b8967d05805
d_0_14:         .dword 0xd3132dbdc84226d8, 0xf472ccf62e474ecc
d_0_15:         .dword 0x183d7a01fa0a9450, 0x1646a1e1da68efa7
d_0_16:         .dword 0xcda2d267a7e8e4e0, 0x2ecf8c6553df1f1a
d_0_17:         .dword 0xc8d00067ee36caa0, 0x001093e698fed5f6
d_0_18:         .dword 0xedff2ba641f854f3, 0xe186feabddcb7b4b
d_0_19:         .dword 0xf8968f2c419c7422, 0x5aa6925b5f169f26
d_0_20:         .dword 0xd8bde57dd0e1fab2, 0x49ad04c0a36c7308
d_0_21:         .dword 0x58efcd36c73b07c5, 0x57f97ea42e04afa1
d_0_22:         .dword 0x789231b98e55c932, 0x64d851c810f40e0a
d_0_23:         .dword 0x2e0a922c5398b6ec, 0x4c5b025739b67585
d_0_24:         .dword 0x28fe9a68ed66b7a8, 0xfe0f4c7d3e94cd0e
d_0_25:         .dword 0x8a88c4a8f12e626b, 0x2ebd261b41c2f046
d_0_26:         .dword 0xd9989b01bb1849bf, 0xfb36b12feecaf559
d_0_27:         .dword 0x6d85c590de51469d, 0x3fc267441206ae9f
                .dword 0xeba528df4759f578, 0xb4018b759a013822
                .dword 0xfac697c5275e5d30, 0x02b01e60834fe9a0
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xebbd4da099e98922, 0x4ecc9aac92d46138
                .dword 0x8a525979bc945844, 0x8accd7033fb7bc69
d_1_0:          .dword 0x1a11c08d54f62df5, 0x610901fd6411e3ae
d_1_1:          .dword 0x5bf89a7ed9f1aa77, 0x76d8cc085134e823
d_1_2:          .dword 0xf105566489fea1c5, 0xb0bfafc57f92b754
d_1_3:          .dword 0x2ce71b2a2f7ce583, 0x110efdbda86e3378
d_1_4:          .dword 0x6727f0f8fd04cc78, 0x1dc18ffaf0b9b752
d_1_5:          .dword 0x842a16456805e140, 0x95f7556251436035
d_1_6:          .dword 0xdb9fbe883873337b, 0x608b26e1e36ccdc1
d_1_7:          .dword 0xd5523c76ae90a8b1, 0xb64a0165ae7d3eb1
d_1_8:          .dword 0x803a53cd14195b21, 0xaef720c1f6e55bf7
d_1_9:          .dword 0xb548865c362e7d91, 0x4760fec0019f2244
d_1_10:         .dword 0xe8d8775fd3ef4b4a, 0x6e5770c61c5605b4
d_1_11:         .dword 0x8dd0aff81845c889, 0xa4c863c614f00fbc
d_1_12:         .dword 0xbc623b871edc5a16, 0xe2ae983ab1932049
d_1_13:         .dword 0x85f680bd68a3dd97, 0xe2f39563e1ec5073
d_1_14:         .dword 0x58564c6fce42173c, 0xbc0b8f5e3cc0c2c2
d_1_15:         .dword 0x3be965445c2c7da4, 0xbc02954507b4bf0e
d_1_16:         .dword 0x69e7643247076f7a, 0xae4bdd7bb6f44235
d_1_17:         .dword 0x904e9332d1aaa259, 0x6916f5939b089a32
d_1_18:         .dword 0xca073cf910046e5b, 0x251b7de73ca55d92
d_1_19:         .dword 0xba0189d8997b518b, 0xf8cff2cd64ceb818
d_1_20:         .dword 0xc0aa4aca81cb4aae, 0x6ed5a3397a089538
d_1_21:         .dword 0xb375cd45c3b28230, 0x59d4b633ec4d513d
d_1_22:         .dword 0xea2190c94a68fc67, 0x3f3d4b58813f48ad
d_1_23:         .dword 0x03368d2e10ba8303, 0x24d4bacd206c5423
d_1_24:         .dword 0xa4e4fd1e455af1df, 0x2734f094434ad843
d_1_25:         .dword 0xa296f03991718009, 0x4209d69a9b2a24e3
d_1_26:         .dword 0xbadd5c604e9d536d, 0xcc2441e5fcb0e257
d_1_27:         .dword 0xbddb5f0e036a3886, 0xceb906a222dd7f42
                .dword 0x382c9fb663914eec, 0x62a843d55790b0cc
                .dword 0xbc6e8cc7454c0c14, 0xd914dc5187d614d9
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x5156b3476e9fff80, 0xa187fb7165f43456
                .dword 0xc2a44e3b205148c4, 0x63df989ac93eca32
d_2_0:          .dword 0x08d149697720587c, 0x421620e71d063030
d_2_1:          .dword 0xe2733d4fa855db4a, 0x6ead7b304a8d2f41
d_2_2:          .dword 0xdd99984050fe563b, 0x1b251be590b4bc98
d_2_3:          .dword 0xb13ae30d7cf6847f, 0x071f3ab41f2fd794
d_2_4:          .dword 0xa8626c2cdaee541e, 0x82eb913cab9de596
d_2_5:          .dword 0xcf276c298ccc1408, 0x3588a172b650111b
d_2_6:          .dword 0x47434dea219d1013, 0xcd129f4c6d507a7e
d_2_7:          .dword 0xcb2a9fb63e5b45c4, 0x4cad4e9206b154ad
d_2_8:          .dword 0x11fe8d8dbbbbad6b, 0x305dd60913cc0f05
d_2_9:          .dword 0x66bf0dbe161ef504, 0x5e400087dd9ef211
d_2_10:         .dword 0xe44da1d93bf33385, 0x1eb12e382b735c15
d_2_11:         .dword 0x792dcfa5e1d43d14, 0x138212078ca21852
d_2_12:         .dword 0x7d1252d539d57d28, 0x1c3316423a844382
d_2_13:         .dword 0x7d37a75a4be6b882, 0x882bfdbd38fefba1
d_2_14:         .dword 0xafb6964f1b0b5142, 0x88a6adabbb5510d3
d_2_15:         .dword 0x985fa7a5077e9a33, 0xf5986d8ed08572a8
d_2_16:         .dword 0x69476e5d2eeacca7, 0xcae06f6a2b1f7ecb
d_2_17:         .dword 0xc13cf406296fff12, 0x982a706f2bc513e1
d_2_18:         .dword 0x0cc820b7770a3252, 0xc82a8a1c344fd037
d_2_19:         .dword 0xc4efcf2426087562, 0x376f292219f16d84
d_2_20:         .dword 0x67c3799c3e5ab1e7, 0x7a7b76dc26064c20
d_2_21:         .dword 0xb8234cb25980ef12, 0x846682b28bda1b2e
d_2_22:         .dword 0x79be6c2475ccba46, 0x0ac71117e29188ac
d_2_23:         .dword 0xebdbed4baab75337, 0x5069e30d1f642534
d_2_24:         .dword 0x1ba3fdfd4cdcff39, 0x01c594deb27a0696
d_2_25:         .dword 0x4c5e40d76dac448b, 0xa3ffc9cf9e2a9ad5
d_2_26:         .dword 0xd411078cb8625068, 0x97705f0190493734
d_2_27:         .dword 0xd2fbf7cf2c56acd3, 0x46b69661b1c25875
                .dword 0xf63dbc2e71762151, 0x2c74bb23ca6d4e47
                .dword 0x9eb653edd34d3bbf, 0x02954f540bfb476f
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x802e8c61be12c0dd, 0x44dc8648eaa80c24
                .dword 0x4c02926447cafd7b, 0x9f993ba0357b9004
d_3_0:          .dword 0x0bce206447f2f456, 0x743818197049ba3f
d_3_1:          .dword 0xfff8da7e03ccda9b, 0xb4eb438ab7ae9a53
d_3_2:          .dword 0x85bdbd5b1769f372, 0x64021ad952f364b4
d_3_3:          .dword 0x685ebbcc3af1f99f, 0xb07d94be3ff54bdc
d_3_4:          .dword 0xb0935d6367089e7d, 0x897f20dc11724bbb
d_3_5:          .dword 0x6b5e465750d294cb, 0xff30e5b78b5415aa
d_3_6:          .dword 0x2cfd258149ec49e9, 0xe05abcc61c21bcbd
d_3_7:          .dword 0x3fa3313b87ef53a8, 0xeda48b12836e3997
d_3_8:          .dword 0x2d9d224070e38832, 0x1dbd8840c35f360d
d_3_9:          .dword 0xae537e89b2e4f5b2, 0xd840ef549687fab9
d_3_10:         .dword 0x1b2bfeeded18d49c, 0xbc0bb0e9b81541dc
d_3_11:         .dword 0x9865d2f4c4333de9, 0x8d394ca50bc75389
d_3_12:         .dword 0x7754b70a56786da9, 0x58bde4f0584e88eb
d_3_13:         .dword 0x337ce28a355be47b, 0xe41132675c3f7555
d_3_14:         .dword 0x5f49239f4d39767f, 0x9d37bc7734b99c79
d_3_15:         .dword 0x976c1a7feae01b4a, 0xf11917112f8216d2
d_3_16:         .dword 0x3105a16041ab051c, 0x9c1d04c15b7af78c
d_3_17:         .dword 0xa6f419ae241900fe, 0xf5b65e1e4c8ba0dd
d_3_18:         .dword 0xb3017d766139398c, 0x3c43e7e794568ed6
d_3_19:         .dword 0xadd05519d9e8f12d, 0xcacfc3f37d996b7d
d_3_20:         .dword 0xb4c6837be62e87f0, 0x1eeb7969014800eb
d_3_21:         .dword 0x656de1974d4de0a8, 0xb640506143db7c63
d_3_22:         .dword 0x5f83ff4e177a5e2f, 0x9dbdb732159a747c
d_3_23:         .dword 0x08f82ef27214370a, 0x876a25a99ea73273
d_3_24:         .dword 0x301121f957d3dc5a, 0x0c35aecfe08faf4f
d_3_25:         .dword 0x66ec810e8789943e, 0x3a07cda9d75b0f4b
d_3_26:         .dword 0xd0e797cef493b45a, 0x515ed163452d3706
d_3_27:         .dword 0x0a29f1b838b03f48, 0x73bacbd08a4b03e3
                .dword 0x5fc86b3517f68e17, 0xdca85612a08de33e
                .dword 0x05bb2a1f23bc32ab, 0x08145d86e4b54bf6
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x6318c047033c1cad, 0x0459e215bd66c43c
                .dword 0x66b46b61ed4de6a6, 0xfb77bf7be7ff7b0c
d_4_0:          .dword 0xb27b52ceeb453870, 0x27931ba48d7e48a6
d_4_1:          .dword 0xc0017194f77fa4b6, 0xa8fbe5fdf9327818
d_4_2:          .dword 0xbaa51eed7e9f335c, 0xe23c12236a2a919a
d_4_3:          .dword 0xabe50dbc3ce03fed, 0xd7d8e560f3f65641
d_4_4:          .dword 0x1f60361cfc3dc83a, 0xd9ef7a9ff3dbf14f
d_4_5:          .dword 0x9159f15b2ec5eb3d, 0xa4631be0d2367723
d_4_6:          .dword 0xbfdf5ea975a0de06, 0x3fdeaf475be5e387
d_4_7:          .dword 0x83f4effb20a3997c, 0xd860f6206661978b
d_4_8:          .dword 0xb7167b0c2f44eca0, 0x407463a1b4b8962a
d_4_9:          .dword 0x3eec712a9cf5fd44, 0xc2cba723c020bd37
d_4_10:         .dword 0xa3583c792659f10e, 0x4000b0bc13fb926c
d_4_11:         .dword 0x39453704baacc578, 0x2c25552c06858b0a
d_4_12:         .dword 0x3280911b0c6ba165, 0x753ab038197a3de2
d_4_13:         .dword 0xdd56a9484302f974, 0x4dae41a9e0caa509
d_4_14:         .dword 0xdadae2276ed867c4, 0x79fdfd7a9cd8a95d
d_4_15:         .dword 0x8d0f8bf85260ef36, 0xcdea3a129bd70d1e
d_4_16:         .dword 0xbd6c08e7c58eae5c, 0x1178c7ef14654b9d
d_4_17:         .dword 0x46ba5bf7d8804dc1, 0xbe739b69dc7b0372
d_4_18:         .dword 0xf37413d08853b83a, 0x4b60185832996f73
d_4_19:         .dword 0x3d0dd711be7f7773, 0x0b7e5facbaf56fe2
d_4_20:         .dword 0xd33f48091dabcb05, 0x663c853ed9987611
d_4_21:         .dword 0x15224a49cc277bc2, 0xb5767fe0a4bb2d7b
d_4_22:         .dword 0x562e2f27291ca02c, 0x54e75434fdfa38e0
d_4_23:         .dword 0xd8d4678dd21e0f01, 0x794cdb25c6a4d460
d_4_24:         .dword 0x46ff3a8a62a31a5d, 0xe0cdad5a6d3fd811
d_4_25:         .dword 0x7fcbc4cf2dc66c25, 0x56e26988d1a39452
d_4_26:         .dword 0x41606771b7004b5e, 0x5184f1e727d9df1b
d_4_27:         .dword 0xc19cc583db691be0, 0x2b27e26ad2e1656e
                .dword 0xc2e68323f012f18e, 0x6d91c97cb7987383
                .dword 0x0a88c9466234895d, 0x6a19f8029b1a09aa
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x2c761d678e7a47c1, 0x20b0d216815b5bde
                .dword 0xbd172a9bac168654, 0x077be25d8712213f
d_5_0:          .dword 0x0345ca233ad03509, 0x8751b976479e735f
d_5_1:          .dword 0x432bdc12de002807, 0x9d77826ca73283a6
d_5_2:          .dword 0x6956d4046de31e1d, 0x6d13f7297fe2b79a
d_5_3:          .dword 0xfca2088815d76dcb, 0xe3acfa165da7b23d
d_5_4:          .dword 0x3967eefc446f2f3c, 0xfabc67099d8a731a
d_5_5:          .dword 0xbbacd8ae35e888d4, 0xf703ca7dd0b0c035
d_5_6:          .dword 0x25b9fbee79a56aae, 0x9ffcf9e7d62e17de
d_5_7:          .dword 0xb46bc576721c3d25, 0xab0957873fb1ae8a
d_5_8:          .dword 0xba856b05ad91cbc5, 0x77364ce0304bcd60
d_5_9:          .dword 0x87530841ec66b78f, 0x53659db5c1098f4f
d_5_10:         .dword 0x8b04d73bfc7164d3, 0x8933a00fbea4921f
d_5_11:         .dword 0x9ed440cda4668471, 0xb76aff599fe98b65
d_5_12:         .dword 0xb0d726eb2587cb77, 0x9b4ec1c18e3781df
d_5_13:         .dword 0x51e10fb92013bdae, 0x91c37c7eaa16f38b
d_5_14:         .dword 0xc0172f63f6831751, 0x3d6a6af894ab68ac
d_5_15:         .dword 0x50476103ba5ac705, 0xbcd817beeaa7064d
d_5_16:         .dword 0x1df88d74935d32ca, 0xa8137b7d15e81d8b
d_5_17:         .dword 0xbbc041bfe70fbb8d, 0xab7331edf2d9cbad
d_5_18:         .dword 0xa8c333ce4ced736b, 0x63a526838e2516fd
d_5_19:         .dword 0xcf7fc556238c0289, 0x1a0b2d155fb1134b
d_5_20:         .dword 0x4c97fcf59838f31d, 0xf65e5ea892981449
d_5_21:         .dword 0x14791e40136157ed, 0x162c870add95471b
d_5_22:         .dword 0x7daddef90d77ba7c, 0xcdf7e14f6bea38e4
d_5_23:         .dword 0xd1e7147b3c3c43c6, 0x13c3b030d0ee92da
d_5_24:         .dword 0x22dff88726234b76, 0x74a675aebccc1700
d_5_25:         .dword 0x65466f96905c8173, 0x321f291a610f452e
d_5_26:         .dword 0x6d42505e2a009065, 0xed544bc21d03e543
d_5_27:         .dword 0xd281ddd45f1b7abd, 0xfecda8def09af3ae
                .dword 0xc06c0860b35d224d, 0xf03fa60cf3720e64
                .dword 0x01331fcf152bb5b3, 0xb882a5b9ff7a8545
         /* Random data */
_end_data5:
              
                 
