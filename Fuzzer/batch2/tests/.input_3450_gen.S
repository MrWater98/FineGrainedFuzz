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
_s0:    la x10, d_4_9                             ;
        flw f11, -28(x10)                         ;
_s1:    li x10, 0                                 ;
        la x27, pt3                               ;
        addi x27, x27, 0                          ;
        sfence.vma x10, x27                       ;
_s2:    ebreak                                    ;
_s3:    lui x3, 646251                            ;
_s4:    srlw x18, x12, x28                        ;
_s5:;
        /* Fuzz trap */
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
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0)) | \
                (MSTATUS_MPP & (MSTATUS_MPP >> 1));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
_fuzz_prefix:
_p0:    xor x11, x11, x11                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 15                         ;
        add x11, x11, x12                         ;
        csrrw x10, frm, x11                       ;
_p1:    csrrci x14, mstatus, 14                   ;
_p2:    csrrsi x10, mhartid, 0                    ;
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
_l0:    mul x14, x1, x10                          ;
_l1:    fcvt.s.l f17, x29, rup                    ;
_l2:    fsgnj.s f17, f24, f26                     ;
_l3:    bgeu x4, x1, _l90                         ;
_l4:    xor x25, x25, x25                         ;
        addi x18, zero, 3                         ;
        slli x18, x18, 16                         ;
        add x25, x25, x18                         ;
        addi x5, zero, 3                          ;
        slli x5, x5, 1                            ;
        add x25, x25, x5                          ;
        addi x14, zero, 1                         ;
        slli x14, x14, 24                         ;
        add x25, x25, x14                         ;
        csrrs x6, mscratch, x25                   ;
_l5:    fclass.s x18, f26                         ;
_l6:    srlw x5, x24, x27                         ;
_l7:    la x9, d_5_27                             ;
        addi x9, x9, 16                           ;
        amominu.w x30, x16, (x9)                  ;
_l8:    la x4, d_4_5                              ;
        lhu x8, -2(x4)                            ;
_l9:    la x18, d_1_15                            ;
        addi x18, x18, 24                         ;
        lui x13, 0xffe00                          ;
        xor x18, x18, x13                         ;
        amoxor.d x7, x13, (x18)                   ;
_l10:   ecall                                     ;
_l11:   csrrci x27, mepc, 0                       ;
_l12:   fmv.w.x f16, x15                          ;
_l13:   fsgnjx.s f17, f16, f16                    ;
_l14:   mulw x27, x11, x20                        ;
_l15:   fmin.s f30, f6, f16                       ;
_l16:   ebreak                                    ;
_l17:   la x11, _l88                              ;
        jalr x26, 0(x11)                          ;
_l18:   fmin.s f31, f9, f25                       ;
_l19:   fmadd.s f2, f28, f4, f28, rmm             ;
_l20:   la x27, d_2_5                             ;
        addi x27, x27, -0                         ;
        amomin.d x20, x11, (x27)                  ;
_l21:   bge x15, x27, _l143                       ;
_l22:   csrrci x14, scause, 7                     ;
_l23:   la x19, d_5_14                            ;
        addi x19, x19, -0                         ;
        amoadd.d x21, x24, (x19)                  ;
_l24:   slli x10, x14, 2                          ;
_l25:   la x27, d_1_12                            ;
        addi x27, x27, 16                         ;
        amomax.d x15, x9, (x27)                   ;
_l26:   la x20, d_2_18                            ;
        srai x20, x20, 1                          ;
        csrrc x24, pmpaddr0, x20                  ;
_l27:   la x7, d_5_9                              ;
        fsw f8, 0(x7)                             ;
_l28:   la x1, d_0_3                              ;
        srai x1, x1, 1                            ;
        csrrw x14, pmpaddr0, x1                   ;
_l29:   la x20, d_2_10                            ;
        ld x13, -0(x20)                           ;
_l30:   fdiv.s f19, f19, f31, rdn                 ;
_l31:   mulhsu x19, x24, x21                      ;
_l32:   jal x27, _l111                            ;
_l33:   mulh x27, x2, x2                          ;
_l34:   la x29, _l93                              ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l35:   addiw x15, x24, -2047                     ;
_l36:   la x7, d_4_5                              ;
        addi x7, x7, 0                            ;
        amominu.d x14, x27, (x7)                  ;
_l37:   remuw x5, x29, x22                        ;
_l38:   auipc x19, 0                              ;
_l39:   la x23, d_5_25                            ;
        addi x23, x23, 24                         ;
        amomin.d x13, x22, (x23)                  ;
_l40:   fnmsub.s f21, f22, f12, f2, rdn           ;
_l41:   ori x29, x1, 20                           ;
_l42:   la x23, d_0_13                            ;
        addi x23, x23, -12                        ;
        amomaxu.w x24, x19, (x23)                 ;
_l43:   mul x22, x1, x10                          ;
_l44:   fmul.s f30, f22, f28, rdn                 ;
_l45:   sraiw x6, x4, 2                           ;
_l46:   la x18, _l182                             ;
        csrrw zero, uepc, x18                     ;
        uret                                      ;
_l47:   remu x10, x26, x14                        ;
_l48:   fclass.s x23, f21                         ;
_l49:   la x13, d_1_8                             ;
        addi x13, x13, 8                          ;
        amominu.w x7, x12, (x13)                  ;
_l50:   fmsub.s f2, f22, f19, f30, rup            ;
_l51:   fmadd.s f31, f2, f14, f9, dyn             ;
_l52:   la x15, d_3_3                             ;
        addi x15, x15, -16                        ;
        lr.w x23, (x15)                           ;
_l53:   xori x22, x7, 926                         ;
_l54:   la x29, d_0_7                             ;
        addi x29, x29, 16                         ;
        amoswap.w x25, x13, (x29)                 ;
_l55:   addiw x2, x23, 0                          ;
_l56:   bge x11, x7, _l148                        ;
_l57:   mulh x5, x17, x3                          ;
_l58:   fcvt.s.w f3, x5, rdn                      ;
_l59:   srlw x4, x13, x20                         ;
_l60:   xori x14, x18, 0                          ;
_l61:   fcvt.s.lu f18, x13, rtz                   ;
_l62:   fcvt.s.lu f18, x18, rdn                   ;
_l63:   la x20, _l109                             ;
        csrrw zero, uepc, x20                     ;
        uret                                      ;
_l64:   fsqrt.s f14, f27, rup                     ;
_l65:   la x1, d_0_7                              ;
        addi x1, x1, -16                          ;
        amomax.d x28, x14, (x1)                   ;
_l66:   flt.s x28, f26, f20                       ;
_l67:   la x23, d_1_22                            ;
        addi x23, x23, -0                         ;
        amoxor.d x13, x4, (x23)                   ;
_l68:   flt.s x5, f22, f16                        ;
_l69:   beq x6, x1, _l167                         ;
_l70:   xor x2, x2, x2                            ;
        addi x21, zero, 3                         ;
        slli x21, x21, 12                         ;
        add x2, x2, x21                           ;
        addi x1, zero, 3                          ;
        slli x1, x1, 18                           ;
        add x2, x2, x1                            ;
        csrrw x28, pmpcfg0, x2                    ;
_l71:   subw x22, x6, x26                         ;
_l72:   fmsub.s f25, f14, f19, f20, rup           ;
_l73:   div x19, x11, x5                          ;
_l74:   fle.s x2, f24, f13                        ;
_l75:   fcvt.s.lu f12, x6, dyn                    ;
_l76:   beq x25, x5, _l154                        ;
_l77:   addi x0, x25, 0                           ;
_l78:   fmadd.s f1, f28, f2, f0, dyn              ;
_l79:   remu x25, x28, x4                         ;
_l80:   fmul.s f23, f17, f17, rup                 ;
_l81:   remuw x12, x10, x8                        ;
_l82:   fcvt.s.w f28, x14, rne                    ;
_l83:   la x16, _l188                             ;
        jalr x9, 0(x16)                           ;
_l84:   flt.s x19, f18, f7                        ;
_l85:   bge x10, x14, _l143                       ;
_l86:   sraiw x6, x3, 13                          ;
_l87:   fsgnjn.s f1, f29, f4                      ;
_l88:   sraw x20, x23, x16                        ;
_l89:   mul x11, x0, x19                          ;
_l90:   fmax.s f10, f20, f26                      ;
_l91:   la x28, d_3_11                            ;
        addi x28, x28, -16                        ;
        amoswap.w x5, x23, (x28)                  ;
_l92:   remuw x20, x27, x1                        ;
_l93:   la x13, d_3_15                            ;
        addi x13, x13, -8                         ;
        amoxor.d x19, x6, (x13)                   ;
_l94:   ebreak                                    ;
_l95:   fsub.s f24, f22, f4, rdn                  ;
_l96:   slti x9, x29, 1970                        ;
_l97:   fsgnjx.s f5, f7, f10                      ;
_l98:   la x4, d_1_22                             ;
        addi x4, x4, -8                           ;
        amoor.d x4, x11, (x4)                     ;
_l99:   sllw x22, x9, x23                         ;
_l100:  fadd.s f14, f26, f3, rmm                  ;
_l101:  la x9, d_5_6                              ;
        sb x19, -12(x9)                           ;
_l102:  la x10, d_5_1                             ;
        addi x10, x10, 24                         ;
        amoxor.d x4, x4, (x10)                    ;
_l103:  beq x5, x4, _l105                         ;
_l104:  la x27, d_1_27                            ;
        addi x27, x27, 16                         ;
        amomin.d x3, x12, (x27)                   ;
_l105:  la x15, d_1_4                             ;
        addi x15, x15, 0                          ;
        amoor.d x3, x2, (x15)                     ;
_l106:  bgeu x29, x15, _l153                      ;
_l107:  fmul.s f15, f24, f11, rne                 ;
_l108:  divu x12, x22, x15                        ;
_l109:  div x22, x3, x28                          ;
_l110:  fmin.s f2, f23, f0                        ;
_l111:  la x29, d_5_5                             ;
        lhu x12, 0(x29)                           ;
_l112:  fnmadd.s f0, f6, f23, f27, rdn            ;
_l113:  fclass.s x20, f11                         ;
_l114:  fcvt.wu.s x30, f12, rtz                   ;
_l115:  mulhu x3, x14, x24                        ;
_l116:  feq.s x27, f7, f28                        ;
_l117:  csrrsi x22, pmpaddr7, 22                  ;
_l118:  fsgnj.s f16, f10, f19                     ;
_l119:  la x9, d_1_13                             ;
        addi x9, x9, -16                          ;
        sc.w x16, x10, (x9)                       ;
_l120:  la x20, _l164                             ;
        jalr x30, 0(x20)                          ;
_l121:  beq x21, x30, _l199                       ;
_l122:  blt x27, x30, _l163                       ;
_l123:  la x15, d_2_5                             ;
        addi x15, x15, 12                         ;
        amoxor.w x22, x12, (x15)                  ;
_l124:  remuw x27, x3, x21                        ;
_l125:  sltiu x29, x12, 238                       ;
_l126:  addw x22, x4, x7                          ;
_l127:  la x12, d_3_27                            ;
        lb x2, -12(x12)                           ;
_l128:  addw x22, x26, x8                         ;
_l129:  slti x24, x14, -1352                      ;
_l130:  fnmsub.s f15, f22, f26, f18, dyn          ;
_l131:  fnmsub.s f13, f12, f23, f5, rtz           ;
_l132:  la x24, d_0_23                            ;
        addi x24, x24, 0                          ;
        amoand.d x23, x19, (x24)                  ;
_l133:  auipc x21, 0                              ;
_l134:  la x30, d_3_10                            ;
        addi x30, x30, 4                          ;
        amomaxu.w x2, x15, (x30)                  ;
_l135:  bgeu x14, x29, _l180                      ;
_l136:  fence                                     ;
_l137:  csrrsi x16, medeleg, 7                    ;
_l138:  fence                                     ;
_l139:  fcvt.w.s x14, f24, rup                    ;
_l140:  feq.s x15, f11, f9                        ;
_l141:  la x1, d_2_20                             ;
        lui x16, 0xffe00                          ;
        xor x1, x1, x16                           ;
        lhu x9, -30(x1)                           ;
_l142:  la x18, d_5_27                            ;
        lw x15, 20(x18)                           ;
_l143:  la x22, d_4_0                             ;
        addi x22, x22, -16                        ;
        amominu.d x30, x4, (x22)                  ;
_l144:  la x22, d_2_24                            ;
        sb x19, -4(x22)                           ;
_l145:  fcvt.s.w f13, x20, rne                    ;
_l146:  bge x19, x24, _l149                       ;
_l147:  ori x15, x17, -512                        ;
_l148:  la x29, d_3_17                            ;
        lhu x7, 20(x29)                           ;
_l149:  sltiu x29, x0, -558                       ;
_l150:  fsgnj.s f28, f25, f21                     ;
_l151:  divuw x16, x18, x18                       ;
_l152:  fsgnjn.s f13, f17, f25                    ;
_l153:  fdiv.s f1, f20, f28, rdn                  ;
_l154:  srli x30, x29, 31                         ;
_l155:  fsub.s f14, f30, f5, rmm                  ;
_l156:  jal x28, _l194                            ;
_l157:  la x28, d_5_14                            ;
        addi x28, x28, -24                        ;
        sc.d x5, x28, (x28)                       ;
_l158:  mul x19, x17, x11                         ;
_l159:  fmv.x.w x14, f25                          ;
_l160:  csrrci x18, mtval, 6                      ;
_l161:  la x6, d_3_21                             ;
        addi x6, x6, -4                           ;
        amoxor.w x17, x20, (x6)                   ;
_l162:  andi x13, x29, 335                        ;
_l163:  beq x29, x27, _l194                       ;
_l164:  fcvt.wu.s x2, f26, rtz                    ;
_l165:  flt.s x0, f3, f15                         ;
_l166:  xor x2, x2, x2                            ;
        addi x23, zero, 3                         ;
        slli x23, x23, 7                          ;
        add x2, x2, x23                           ;
        addi x17, zero, 1                         ;
        slli x17, x17, 30                         ;
        add x2, x2, x17                           ;
        addi x14, zero, 1                         ;
        slli x14, x14, 7                          ;
        add x2, x2, x14                           ;
        csrrs x5, mtval, x2                       ;
_l167:  la x26, d_1_20                            ;
        sh x23, 28(x26)                           ;
_l168:  fadd.s f23, f28, f12, rtz                 ;
_l169:  ecall                                     ;
_l170:  la x1, d_4_16                             ;
        lb x16, 10(x1)                            ;
_l171:  la x24, d_2_13                            ;
        lb x18, 0(x24)                            ;
_l172:  slliw x22, x3, 31                         ;
_l173:  fdiv.s f11, f30, f20, dyn                 ;
_l174:  addi x18, x7, -1419                       ;
_l175:  divuw x20, x1, x12                        ;
_l176:  la x1, d_0_0                              ;
        addi x1, x1, 16                           ;
        amomin.d x19, x14, (x1)                   ;
_l177:  la x6, d_5_15                             ;
        addi x6, x6, 4                            ;
        sc.w x4, x1, (x6)                         ;
_l178:  la x13, d_2_16                            ;
        addi x13, x13, 24                         ;
        amomax.d x25, x10, (x13)                  ;
_l179:  andi x23, x24, 180                        ;
_l180:  fcvt.s.w f3, x28, rdn                     ;
_l181:  srli x5, x23, 50                          ;
_l182:  la x1, _l33                               ;
        flw f28, -12(x1)                          ;
_l183:  fcvt.w.s x6, f28, rmm                     ;
_l184:  fmadd.s f24, f1, f29, f9, dyn             ;
_l185:  la x7, d_1_17                             ;
        addi x7, x7, -0                           ;
        amoswap.d x4, x9, (x7)                    ;
_l186:  la x12, d_1_3                             ;
        addi x12, x12, -4                         ;
        amoswap.w x27, x12, (x12)                 ;
_l187:  fcvt.s.lu f4, x21, rdn                    ;
_l188:  srli x5, x29, 29                          ;
_l189:  la x16, _l198                             ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l190:  la x24, _l194                             ;
        csrrw zero, sepc, x24                     ;
        sret                                      ;
_l191:  fmul.s f3, f2, f26, rtz                   ;
_l192:  la x7, d_1_6                              ;
        addi x7, x7, 28                           ;
        amoxor.w x20, x10, (x7)                   ;
_l193:  la x20, d_2_5                             ;
        srai x20, x20, 1                          ;
        csrrc x7, pmpaddr1, x20                   ;
_l194:  csrrsi x16, mhartid, 29                   ;
_l195:  rem x8, x5, x26                           ;
_l196:  remuw x28, x8, x10                        ;
_l197:  fcvt.w.s x30, f17, dyn                    ;
_l198:  la x1, d_3_4                              ;
        addi x1, x1, 16                           ;
        amoswap.d x20, x5, (x1)                   ;
_l199:  fmax.s f9, f3, f10                        ;
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
                .dword 0xcdcb2f8ee8aa6006, 0xc90bb815bcadc480
                .dword 0x554ded252e73b265, 0x3a451fd0e37b0d66
d_0_0:          .dword 0xc866ea0ef371bb93, 0xef9254e4b63ca8c9
d_0_1:          .dword 0xfdcccb4fa5a8bf69, 0x08cd6017f1202913
d_0_2:          .dword 0x9386af204aa31de5, 0x42813ea7b3eaa3b8
d_0_3:          .dword 0x19052190c64758b1, 0x3ac9e503795865af
d_0_4:          .dword 0x49362140c685e1b3, 0xf46d9195cda0221f
d_0_5:          .dword 0x3a9b056bbed262e9, 0x867bb99b0416a8f5
d_0_6:          .dword 0x8c4879b19a497856, 0x444c5f0cc9439e99
d_0_7:          .dword 0x5baac7707c95918b, 0x56dc910dea6d58af
d_0_8:          .dword 0x59e272de0a22b39d, 0x29c742d9bea9271e
d_0_9:          .dword 0xf80cba9e4d176878, 0x91210a3712955821
d_0_10:         .dword 0x9a8f3b3507522506, 0xf7f6b69ee42909d8
d_0_11:         .dword 0xf8231d01647002b7, 0x79a08e7dc8776ab7
d_0_12:         .dword 0xe2076ae69411a584, 0x4c745f6b7f19d21d
d_0_13:         .dword 0x7f1677b9aeea2a3d, 0x5c8b467a8a02435e
d_0_14:         .dword 0x29c013a5128a08f8, 0xf94ed218f2497da8
d_0_15:         .dword 0x5d90a99ce359f821, 0xfa75902de0fbf871
d_0_16:         .dword 0xc602f6d17d17f84e, 0xa7d4a0e8d483d5aa
d_0_17:         .dword 0x0e1f3d40ce7991fc, 0x6ea2636bd34e99a1
d_0_18:         .dword 0x2608c936f5214e6c, 0xa4178013e54ad32f
d_0_19:         .dword 0x04ea117f61140635, 0x65919deebc13707a
d_0_20:         .dword 0xc0ae2e0e670cabe8, 0x53b06135b42704dc
d_0_21:         .dword 0xe494951440cf89fd, 0x974e596a148b4f82
d_0_22:         .dword 0xf2735f22b0a7ee4c, 0xbf0de5bda0165fb7
d_0_23:         .dword 0xfdf3a9394addb58a, 0x153c92cfa52a52b3
d_0_24:         .dword 0xcbe571c3afd649fb, 0x69b0d7a1ee092052
d_0_25:         .dword 0xd797d2f5fc006c4f, 0xc3f26d11590bd5f0
d_0_26:         .dword 0x5b1f4807294919c7, 0x15916504340fcff4
d_0_27:         .dword 0xef68b5fb36643158, 0x9d00ef2bcb5ce2b0
                .dword 0x38b84acc984ba958, 0x450fdfb991a1cc60
                .dword 0x9d43af82bc75be7b, 0xe4b7c05887f67a74
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9569808764895d2b, 0xf47e6e4659135d07
                .dword 0xda655dce5c32e774, 0xe10be4678692ef35
d_1_0:          .dword 0xefa88cae91bd49b8, 0xa9d7426bcc2ccd2c
d_1_1:          .dword 0xe441b70f001c9762, 0xf8849cd931c606f9
d_1_2:          .dword 0xeeb63593d5e24e7b, 0x972a7ffd4cb3b75f
d_1_3:          .dword 0x4e35540a7a95b569, 0x36b189ae6baf11d9
d_1_4:          .dword 0xe23b4569398bcbd5, 0xff23b9fe56f36ed0
d_1_5:          .dword 0xd157a4c5e003e450, 0x062a4cf3ce1b4a0b
d_1_6:          .dword 0x372563105c6dc11c, 0xb1ac86618548241b
d_1_7:          .dword 0x37fe43462715dcec, 0x77903dab04d6aa69
d_1_8:          .dword 0xb4629984aecfb794, 0xfa2d6ebaa4e455a9
d_1_9:          .dword 0x1c2a9e5b472e824a, 0x5d62bdd7dabfd5de
d_1_10:         .dword 0xb0b80d6fad92a9ff, 0x5d9a7848aed6d13f
d_1_11:         .dword 0x47690177197878ac, 0x7c22eb216c550c21
d_1_12:         .dword 0xd9f67332f824451d, 0x5b2bdbf8ba7d1373
d_1_13:         .dword 0xea46d004dbee82cf, 0x53494f4c1bfa501a
d_1_14:         .dword 0x1c392f59857f7c14, 0xe3bd1c917d769d2a
d_1_15:         .dword 0x650aafa891d357ff, 0xd8ae37f7d8d3d63a
d_1_16:         .dword 0x9ec79c6a1408c9ae, 0xe431e76beed75918
d_1_17:         .dword 0x83263d97479319ab, 0xfc53f5013119c779
d_1_18:         .dword 0x159e0d47bdf427c0, 0x55ded3ed5e1e2a16
d_1_19:         .dword 0x8c83ed4ea1493bce, 0x6bfa2cb2a717e841
d_1_20:         .dword 0x477b670d72c18075, 0xe16bad05d46a3076
d_1_21:         .dword 0x516ff4544212a771, 0x6031583b365e026f
d_1_22:         .dword 0x640362566bfea817, 0x8ff9df1d490f046e
d_1_23:         .dword 0x1a004d48f0c49599, 0xeac3872f03697c26
d_1_24:         .dword 0xc24af4347510bf93, 0xd4b3c458a3e261fc
d_1_25:         .dword 0x1de00402656003ec, 0xda3355928a66cdb7
d_1_26:         .dword 0x8922cd3eecbf0ff1, 0x36864c169dd20584
d_1_27:         .dword 0xe63465257f421c1f, 0x5862c0a72f782378
                .dword 0x84c179586d74cae5, 0x31f4af43efe00baa
                .dword 0x7c05ce16c77cb597, 0xad4b7312e559791b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe83cfb0058b7f0d9, 0x77123b0f9fce7436
                .dword 0x81745fb954fe9797, 0xbef3a9124e3fe47f
d_2_0:          .dword 0xaf7bae04727851ae, 0x05b28508f7c8cab0
d_2_1:          .dword 0xf32cce3b7357ef85, 0x55b373f727aac500
d_2_2:          .dword 0xc44df7c2168c15b6, 0x0a9fa4780f1e44b0
d_2_3:          .dword 0x057b32b48e9550a4, 0xe2e48d937ae95a4e
d_2_4:          .dword 0xad463aa1bd73f5ff, 0xf3c2d0746da59587
d_2_5:          .dword 0xa44f188e094b13cc, 0x04887d2776a4d728
d_2_6:          .dword 0x8dbd85b2cb9400f8, 0x770313897979bbcd
d_2_7:          .dword 0x9c664f3d312df2df, 0x290399c406bf3629
d_2_8:          .dword 0xf6fd2c30c2809a4d, 0x3818f0accba19e0d
d_2_9:          .dword 0x931f716a0e972b47, 0x8361dcdc4b8bcb8f
d_2_10:         .dword 0x724d8c9e393679f6, 0x43013fa6c2c76db5
d_2_11:         .dword 0x29f4ec178315b28a, 0xf5f16304dcc4a4c4
d_2_12:         .dword 0x30457f16cc194ad2, 0x4415b220620a2646
d_2_13:         .dword 0x2755e07a1522d857, 0x9e880f47182a9baa
d_2_14:         .dword 0xfcf5579b72e70f22, 0xd09cac75dc4e107c
d_2_15:         .dword 0xcb9d95723c74bb93, 0xfc6bc215d5e4d99e
d_2_16:         .dword 0x890cb4eb7d33b4d8, 0xd1ac6ce98bb72b02
d_2_17:         .dword 0x7ec25da8720da25a, 0x12c8cff59468bdda
d_2_18:         .dword 0x5daac7bda5d4a91c, 0x491767099738c9b0
d_2_19:         .dword 0x082055a7654dc751, 0x844fb520ce24f852
d_2_20:         .dword 0xe787b2a3b68beed7, 0xd2e5ee6004b27fa3
d_2_21:         .dword 0xc351d810a429ecd1, 0xc564acd2017f0577
d_2_22:         .dword 0x6b2e00cd69cb3b53, 0x698ff1172b83f4a8
d_2_23:         .dword 0x7a380dfd8b9efcfb, 0xbb15621fe92e5cc9
d_2_24:         .dword 0x725c40fc08fa0155, 0x593212d0c580cf7e
d_2_25:         .dword 0x71cec7de6fd5cfbc, 0x811b255e3bc8d6c4
d_2_26:         .dword 0xa286c69a07b001f2, 0x7e4f3cdff050ad52
d_2_27:         .dword 0x58ab7795100ff63d, 0x3ae2f1aa554683a1
                .dword 0xb57e1ef3f2959d6c, 0x333b607e9dc6de0f
                .dword 0xde0eaad84e79a090, 0xb488d17815ab123a
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x0489b7e29bbb2282, 0xc746936ae85ab680
                .dword 0x8b1b693b4c2bce98, 0x1c830504fbd69929
d_3_0:          .dword 0xab9a21aa5e8c3456, 0x4eec43581e6f983e
d_3_1:          .dword 0x760b0fba952f37a9, 0x45f1c2c12a8405f0
d_3_2:          .dword 0x21ccc81e9b6e361a, 0x0ee46c9e2bc453cf
d_3_3:          .dword 0xb6a75fd5a77c26b6, 0xe9d21d9b4c5e74d6
d_3_4:          .dword 0x2c09be6e080366e8, 0x22a44f1985f9142b
d_3_5:          .dword 0x71f2d5fd6c9c135c, 0x1a43e30110aecf1e
d_3_6:          .dword 0x031287d1189f62b1, 0x9e3270e4af69f31f
d_3_7:          .dword 0xe5316d9f74f858ba, 0x23e4c28eff2f584d
d_3_8:          .dword 0x9176e5e7be84d552, 0x2a74e5831f85256e
d_3_9:          .dword 0x4deab7bde3ed0366, 0x2def1772418b8349
d_3_10:         .dword 0x1e52096442fc2d38, 0x8f44ebe6dda130da
d_3_11:         .dword 0x065c40d8fb7824f7, 0xd496b70223194b97
d_3_12:         .dword 0x8418e67d75208366, 0x7e688c2957db2a62
d_3_13:         .dword 0x63e9e5361ff1e6f8, 0x197a6ed2186a0ea8
d_3_14:         .dword 0xad77d767c6408f40, 0x199e0c78b87bfdc1
d_3_15:         .dword 0xdb74283ff858728a, 0xb459fa8bfdc8b4d0
d_3_16:         .dword 0x4226b0105f6fb42d, 0x9e65997feda158e0
d_3_17:         .dword 0x92fbb06cc56a1d44, 0xafa8b66e662b3aa9
d_3_18:         .dword 0x517c51e65f4f11b2, 0x0d0a7b7b616472a6
d_3_19:         .dword 0x09012a99fd4e45fc, 0xe04df2a44067b787
d_3_20:         .dword 0x1de2558b1ee6bca0, 0x6618ce20425bad77
d_3_21:         .dword 0xc389751d973d027d, 0xacc740ac42d5690b
d_3_22:         .dword 0xd4de60d1cf7a9e19, 0x60dbfe4122b18e25
d_3_23:         .dword 0x1d60264601ab2c5c, 0x9f5a52b508a6c0e2
d_3_24:         .dword 0x9f2cf73ee33eb9b8, 0x9443dc99cb0fceb3
d_3_25:         .dword 0x7ea0c4ad7205fa58, 0xe96a8a0d3a06e672
d_3_26:         .dword 0x0cdf2acfee12190b, 0xd8989d921ed05c2c
d_3_27:         .dword 0x79a3e2e66c716433, 0x4a262e2cc5a67dde
                .dword 0xd2b90c7a8d2f41a9, 0xd85e4412699ca021
                .dword 0x735f0c33786dc4bd, 0x920d90efbf1fc042
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8d5402643de544ac, 0x9df8bc4cff4b0a65
                .dword 0xaa06dea5b1618323, 0xacd71357829198cb
d_4_0:          .dword 0x98c3569e3e0d7f3a, 0xea4b83ad72a8f523
d_4_1:          .dword 0xb69146c98c05efe6, 0xe2578a57d3fa3bc5
d_4_2:          .dword 0x961849b6356549eb, 0x0109a098930e88b8
d_4_3:          .dword 0xc146c3b904fb93b0, 0x546385aac555ee46
d_4_4:          .dword 0x43cc802ccaca49aa, 0x26b4f3d3a71faa92
d_4_5:          .dword 0xf9af29b6c07b5742, 0xb5ee82a3eead58e9
d_4_6:          .dword 0xf2af7362b4d2f47b, 0x925835c3870f8592
d_4_7:          .dword 0xb2605c8340d38be8, 0xcb4da57f98f011e6
d_4_8:          .dword 0x6ce29a2b4ebbd469, 0x7524a8c330e0407a
d_4_9:          .dword 0xa5b3537b96a8c6ef, 0xe57f415121ad6829
d_4_10:         .dword 0x0c1de27fc424db4d, 0xf3479191284687fc
d_4_11:         .dword 0x661fc4ea3052b1db, 0xb2e7d611761ed299
d_4_12:         .dword 0x69b4a53c7ce2d729, 0x751a80571951f7ed
d_4_13:         .dword 0x69ccd8f33e030e11, 0xa6ed6a959ce686ee
d_4_14:         .dword 0x5856efde6d7d14c9, 0xaf8e4df0faceb4f6
d_4_15:         .dword 0xa6737f9a69072cf8, 0x9e6772398cb0b9ff
d_4_16:         .dword 0xa9c6c57618697457, 0xa7c878cc527763c4
d_4_17:         .dword 0x571218331c05765e, 0x177f8b969e00d4e3
d_4_18:         .dword 0x3c17ec44a6d0e910, 0x029e71167dbb280a
d_4_19:         .dword 0x78c4ff3b7b40a291, 0x0e08d9ab672e6ddd
d_4_20:         .dword 0xee13b8b50ddb91ee, 0x97259cf48539e9a6
d_4_21:         .dword 0xb76f48f7ebdd90a3, 0xa5f4a35cc110b95a
d_4_22:         .dword 0xd10f97c3eb2bc471, 0x1c389367fac08ec6
d_4_23:         .dword 0x478179466f990d1a, 0x941ca24f78433fa5
d_4_24:         .dword 0xf9e074a51a3c7969, 0x81d6a197c67c4097
d_4_25:         .dword 0x7cfe38b967f57a0d, 0x6330d0f4d5e02372
d_4_26:         .dword 0x08f7eccb28226ebe, 0x01f10c2e4343b9a4
d_4_27:         .dword 0xb58463bf41c7cfe6, 0x2b4cc9bdfb5d2bbe
                .dword 0x76cdc009b60068ae, 0xe94c14a215a5c712
                .dword 0xec383e087c87ad82, 0x7c78e147ec25b970
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xd3a56366d2a787b5, 0x44dbe6ef12377a50
                .dword 0xd29373481ef34449, 0x247bf9e118490708
d_5_0:          .dword 0x874d6bfa2242171b, 0x82bd056986e0e7a9
d_5_1:          .dword 0xf6b3de2c54d453e5, 0xe4e7a27f838f2270
d_5_2:          .dword 0xc56ac735b5101dd8, 0xe1fbde0116dce049
d_5_3:          .dword 0x15e4c08a92d5c8b2, 0x1857f0ef33681d2b
d_5_4:          .dword 0xd9aee11d13092964, 0x37c72518ce3cfae6
d_5_5:          .dword 0x97a30de3526cddf0, 0x092b2b636069b7cd
d_5_6:          .dword 0xcdbcf2952221004e, 0x9cfb28b6e214cb98
d_5_7:          .dword 0x66081f8985c97559, 0xfb406bf70c25385e
d_5_8:          .dword 0x238f646d1fd26733, 0xb27b1436059ad55d
d_5_9:          .dword 0x11ab9d6397a33694, 0x14ead9ca92235ecc
d_5_10:         .dword 0xbe5f0acbfa09de4a, 0xb70a6d68aca7c4ff
d_5_11:         .dword 0xf739d12420609b19, 0x8cc8746063b17955
d_5_12:         .dword 0xd767236395db412c, 0x676c934b0846fc88
d_5_13:         .dword 0x225e3e2913ae4850, 0x4452dff261b79025
d_5_14:         .dword 0x9b176ae583f4157f, 0x8e9309ce991f52cd
d_5_15:         .dword 0x03a06ab4e5f00c3c, 0x810353e6c9f0b76c
d_5_16:         .dword 0x126a740cf9271a96, 0x08f1b050a87a9f22
d_5_17:         .dword 0xd2127963dddcd970, 0xf266a5bf7600f3d3
d_5_18:         .dword 0xb4ab714a4f9edac9, 0x1747e52ca3cb93d2
d_5_19:         .dword 0xaebeebcdfb3f7474, 0x3cd8efc64a98a4a0
d_5_20:         .dword 0x39014b230b6804a0, 0x2b133229ba2b36ae
d_5_21:         .dword 0x504465dff21ee7e3, 0x60cf2e3b7c5336b4
d_5_22:         .dword 0x57cc5d6ef40aafde, 0x24eb0f9ce550f8be
d_5_23:         .dword 0xf8317f66179d8508, 0xbc504ace930a328a
d_5_24:         .dword 0xd031c192f04b85eb, 0x9958527c804f855b
d_5_25:         .dword 0x7605b425aa5e66d9, 0xce88d51a1af6ef68
d_5_26:         .dword 0x1c45753f934c7b1b, 0xa3046e4903a4701d
d_5_27:         .dword 0x9ad9ae05ad01c532, 0x18a17abccc36ac88
                .dword 0xdd93d3c112974d61, 0x8961926d8de45515
                .dword 0xd63fa95c92e2e5d1, 0x2f1552a2df4db071
         /* Random data */
_end_data5:
              
                 
