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
_s0:    la x2, d_5_13                             ;
        addi x2, x2, -0                           ;
        lr.d x29, (x2)                            ;
_s1:    la x2, d_2_20                             ;
        addi x2, x2, -0                           ;
        amomin.d x24, x3, (x2)                    ;
_s2:    la x13, d_2_19                            ;
        addi x13, x13, -8                         ;
        amoxor.w x26, x10, (x13)                  ;
_s3:    la x12, _s5                               ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_s4:    mul x6, x5, x8                            ;
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
_p0:;
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
_l0:    fcvt.w.s x9, f17, rtz                     ;
_l1:    ecall                                     ;
_l2:    fcvt.wu.s x23, f24, dyn                   ;
_l3:    fence.i                                   ;
_l4:    la x5, d_5_6                              ;
        addi x5, x5, -0                           ;
        lui x5, 0xffe00                           ;
        xor x5, x5, x5                            ;
        amoand.d x28, x5, (x5)                    ;
_l5:    slliw x5, x5, 31                          ;
_l6:    bne x9, x21, _l169                                ;
_l7:    la x7, d_0_20                             ;
        addi x7, x7, -8                           ;
        amominu.d x30, x12, (x7)                  ;
_l8:    csrrci x29, mscratch, 31                  ;
_l9:    fmv.x.w x1, f24                           ;
_l10:   fnmsub.s f6, f13, f8, f26, dyn            ;
_l11:   csrrsi x9, pmpaddr6, 18                   ;
_l12:   rem x10, x10, x1                          ;
_l13:   la x23, d_0_20                            ;
        addi x23, x23, -4                         ;
        amoor.w x14, x27, (x23)                   ;
_l14:   fsgnj.s f1, f12, f14                      ;
_l15:   fcvt.s.w f9, x1, dyn                      ;
_l16:   auipc x16, 0                              ;
_l17:   la x8, d_0_25                             ;
        lbu x19, 0(x8)                            ;
_l18:   subw x26, x16, x16                        ;
_l19:   fcvt.s.l f30, x8, rup                     ;
_l20:   la x13, d_3_2                             ;
        addi x13, x13, -24                        ;
        amoadd.w x7, x29, (x13)                   ;
_l21:   remw x12, x18, x22                        ;
_l22:   la x14, d_3_6                             ;
        addi x14, x14, -12                        ;
        lr.w x21, (x14)                           ;
_l23:   fmin.s f25, f31, f18                      ;
_l24:   fmv.x.w x29, f10                          ;
_l25:   la x21, d_3_0                             ;
        srai x21, x21, 1                          ;
        csrrs x7, pmpaddr5, x21                   ;
_l26:   fsgnjn.s f9, f30, f31                     ;
_l27:   la x24, d_2_14                            ;
        addi x24, x24, -24                        ;
        lr.d x13, (x24)                           ;
_l28:   fsgnj.s f17, f0, f4                       ;
_l29:   fence.i                                   ;
_l30:   fdiv.s f24, f24, f7, rdn                  ;
_l31:   la x11, d_0_19                            ;
        sd x30, 0(x11)                            ;
_l32:   fadd.s f18, f12, f4, rup                  ;
_l33:   la x22, d_0_12                            ;
        addi x22, x22, -0                         ;
        lui x16, 0xffe00                          ;
        xor x22, x22, x16                         ;
        amomin.d x21, x16, (x22)                  ;
_l34:   blt x13, x19, _l48                                ;
_l35:   la x19, d_2_3                             ;
        addi x19, x19, 0                          ;
        amoadd.w x29, x19, (x19)                  ;
_l36:   la x11, _l184                                     ;
        csrrw zero, sepc, x11                     ;
        sret                                      ;
_l37:   la x7, d_1_26                             ;
        addi x7, x7, 16                           ;
        amominu.d x8, x29, (x7)                   ;
_l38:   blt x19, x21, _l62                        ;
_l39:   la x6, d_4_20                             ;
        addi x6, x6, 8                            ;
        sc.d x19, x6, (x6)                        ;
_l40:   la x22, d_0_23                            ;
        addi x22, x22, -0                         ;
        lui x7, 0xffe00                           ;
        xor x22, x22, x7                          ;
        amoxor.d x23, x7, (x22)                   ;
_l41:   fclass.s x7, f3                           ;
_l42:   la x30, _l110                                      ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l43:   fle.s x15, f12, f31                       ;
_l44:   auipc x16, 328674                         ;
_l45:   xori x29, x9, 2035                        ;
_l46:   la x8, d_1_18                             ;
        lw x13, -28(x8)                           ;
_l47:   divw x19, x26, x22                        ;
_l48:   la x27, d_3_12                            ;
        addi x27, x27, 28                         ;
        amoswap.w x18, x29, (x27)                 ;
_l49:   rem x1, x18, x29                          ;
_l50:   fnmsub.s f19, f17, f18, f3, rmm           ;
_l51:   la x25, d_2_8                             ;
        addi x25, x25, -28                        ;
        amoxor.w x8, x8, (x25)                    ;
_l52:   mulh x21, x0, x13                         ;
_l53:   la x27, d_5_16                            ;
        addi x27, x27, -8                         ;
        amomaxu.d x5, x22, (x27)                  ;
_l54:   la x9, d_3_24                             ;
        addi x9, x9, -16                          ;
        amoand.d x6, x3, (x9)                     ;
_l55:   ori x20, x20, -0                          ;
_l56:   srli x18, x2, 5                           ;
_l57:   la x20, d_5_5                             ;
        addi x20, x20, 0                          ;
        lui x19, 0xffe00                          ;
        xor x20, x20, x19                         ;
        amoor.d x21, x19, (x20)                   ;
_l58:   fle.s x12, f15, f5                        ;
_l59:   divuw x6, x7, x26                         ;
_l60:   bgeu x21, x13, _l86                               ;
_l61:   sllw x15, x4, x28                         ;
_l62:   divu x13, x26, x4                         ;
_l63:   srai x8, x2, 63                           ;
_l64:   fnmadd.s f7, f12, f15, f7, rdn            ;
_l65:   srai x14, x19, 6                          ;
_l66:   fnmsub.s f14, f21, f5, f25, rdn           ;
_l67:   la x10, d_2_19                            ;
        addi x10, x10, 24                         ;
        amoswap.d x24, x25, (x10)                 ;
_l68:   fcvt.s.wu f1, x30, dyn                    ;
_l69:   bgeu x11, x15, _l149                              ;
_l70:   divw x19, x6, x9                          ;
_l71:   csrrci x4, pmpaddr1, 14                   ;
_l72:   la x28, d_3_24                            ;
        lhu x16, 30(x28)                          ;
_l73:   fsgnjn.s f15, f28, f11                    ;
_l74:   addiw x27, x14, -926                      ;
_l75:   mulhu x29, x17, x23                       ;
_l76:   la x12, d_1_2                             ;
        addi x12, x12, -16                        ;
        amoxor.d x25, x11, (x12)                  ;
_l77:   slti x7, x28, 1952                        ;
_l78:   la x9, d_4_14                             ;
        addi x9, x9, -8                           ;
        amomin.w x2, x17, (x9)                    ;
_l79:   csrrsi x5, frm, 24                        ;
_l80:   xor x18, x18, x18                         ;
        addi x19, zero, 3                         ;
        slli x19, x19, 19                         ;
        add x18, x18, x19                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 2                          ;
        add x18, x18, x12                         ;
        addi x4, zero, 3                          ;
        slli x4, x4, 4                            ;
        add x18, x18, x4                          ;
        csrrw x1, mhartid, x18                    ;
_l81:   la x7, d_5_22                             ;
        addi x7, x7, -8                           ;
        amoadd.d x27, x8, (x7)                    ;
_l82:   sltiu x21, x13, 270                       ;
_l83:   fcvt.l.s x27, f12, dyn                    ;
_l84:   csrrci x19, sip, 24                       ;
_l85:   andi x13, x13, -429                       ;
_l86:   fmv.w.x f8, x18                           ;
_l87:   la x26, d_3_13                            ;
        addi x26, x26, -16                        ;
        amoadd.w x17, x12, (x26)                  ;
_l88:   la x7, d_4_21                             ;
        addi x7, x7, 0                            ;
        amoswap.w x24, x20, (x7)                  ;
_l89:   rem x2, x27, x8                           ;
_l90:   la x22, d_5_24                            ;
        addi x22, x22, 0                          ;
        sc.d x7, x22, (x22)                       ;
_l91:   fmv.x.w x7, f7                            ;
_l92:   fle.s x27, f14, f14                       ;
_l93:   auipc x16, 1048575                        ;
_l94:   la x9, d_2_27                             ;
        addi x9, x9, 12                           ;
        amoand.w x18, x21, (x9)                   ;
_l95:   li x0, 0                                  ;
        la x17, pt1                               ;
        addi x17, x17, 16                         ;
        sfence.vma x0, x17                        ;
_l96:   fcvt.w.s x17, f19, rdn                    ;
_l97:   subw x29, x6, x25                         ;
_l98:   fcvt.w.s x18, f26, rtz                    ;
_l99:   fclass.s x14, f2                          ;
_l100:  la x25, d_1_27                            ;
        addi x25, x25, 24                         ;
        amoxor.d x14, x14, (x25)                  ;
_l101:  fnmsub.s f10, f18, f19, f23, rtz          ;
_l102:  fcvt.s.w f20, x17, dyn                    ;
_l103:  fence.i                                   ;
_l104:  fmul.s f4, f4, f2, rmm                    ;
_l105:  lui x10, 143588                           ;
_l106:  fcvt.s.l f30, x5, dyn                     ;
_l107:  fence                                     ;
_l108:  ori x18, x16, -1600                       ;
_l109:  divu x3, x12, x5                          ;
_l110:  la x7, d_4_7                              ;
        addi x7, x7, -16                          ;
        amoor.d x3, x6, (x7)                      ;
_l111:  la x5, d_0_27                             ;
        sh x30, -30(x5)                           ;
_l112:  fsqrt.s f13, f4, rup                      ;
_l113:  mulw x30, x8, x29                         ;
_l114:  la x2, d_2_16                             ;
        lhu x26, 0(x2)                            ;
_l115:  la x5, d_5_23                             ;
        addi x5, x5, -28                          ;
        sc.w x14, x5, (x5)                        ;
_l116:  la x2, d_5_13                             ;
        addi x2, x2, -4                           ;
        lui x20, 0xffe00                          ;
        xor x2, x2, x20                           ;
        sc.w x7, x20, (x2)                        ;
_l117:  la x20, d_1_7                             ;
        addi x20, x20, 8                          ;
        amoand.d x4, x25, (x20)                   ;
_l118:  fcvt.l.s x0, f12, rtz                     ;
_l119:  auipc x8, 174047                          ;
_l120:  la x28, d_2_21                            ;
        lb x4, -23(x28)                           ;
_l121:  la x8, d_5_0                              ;
        addi x8, x8, 24                           ;
        amomin.w x25, x22, (x8)                   ;
_l122:  srliw x21, x20, 31                        ;
_l123:  addw x25, x23, x8                         ;
_l124:  slli x19, x28, 22                         ;
_l125:  la x22, d_1_13                            ;
        addi x22, x22, 28                         ;
        amomax.w x21, x8, (x22)                   ;
_l126:  la x17, _l153                                     ;
        csrrw zero, sepc, x17                     ;
        sret                                      ;
_l127:  la x12, d_5_10                            ;
        addi x12, x12, 0                          ;
        amomin.w x1, x28, (x12)                   ;
_l128:  la x7, d_2_15                             ;
        addi x7, x7, -8                           ;
        amominu.d x22, x12, (x7)                  ;
_l129:  la x17, d_1_7                             ;
        addi x17, x17, -0                         ;
        lr.d x20, (x17)                           ;
_l130:  fcvt.l.s x20, f18, rmm                    ;
_l131:  la x26, d_3_9                             ;
        addi x26, x26, -16                        ;
        amomaxu.d x2, x17, (x26)                  ;
_l132:  la x22, d_0_25                            ;
        addi x22, x22, -0                         ;
        amoswap.w x18, x20, (x22)                 ;
_l133:  mulhu x27, x2, x24                        ;
_l134:  remuw x22, x7, x20                        ;
_l135:  la x26, d_0_7                             ;
        fsw f22, -24(x26)                         ;
_l136:  la x19, _l197                             ;
        ld x5, -8(x19)                            ;
_l137:  fsgnjn.s f8, f5, f16                      ;
_l138:  andi x15, x28, 287                        ;
_l139:  remu x23, x9, x8                          ;
_l140:  la x12, d_1_25                            ;
        lui x7, 0xffe00                           ;
        xor x12, x12, x7                          ;
        sh x16, -30(x12)                          ;
_l141:  fadd.s f17, f16, f6, rdn                  ;
_l142:  la x29, d_1_9                             ;
        addi x29, x29, 24                         ;
        amoand.d x1, x2, (x29)                    ;
_l143:  fsgnjn.s f5, f18, f20                     ;
_l144:  la x21, _l56                              ;
        lb x19, -31(x21)                          ;
_l145:  la x17, d_2_8                             ;
        addi x17, x17, 0                          ;
        amomin.d x9, x15, (x17)                   ;
_l146:  fcvt.lu.s x8, f8, rtz                     ;
_l147:  fsgnj.s f11, f1, f25                      ;
_l148:  mulw x11, x20, x22                        ;
_l149:  la x11, d_3_20                            ;
        lui x14, 0xffe00                          ;
        xor x11, x11, x14                         ;
        fsw f1, 0(x11)                            ;
_l150:  la x11, _l92                              ;
        lbu x14, 0(x11)                           ;
_l151:  auipc x8, 1048575                         ;
_l152:  mulh x15, x18, x20                        ;
_l153:  fmsub.s f16, f28, f23, f4, dyn            ;
_l154:  la x6, d_0_19                             ;
        addi x6, x6, -0                           ;
        amoswap.d x12, x7, (x6)                   ;
_l155:  la x2, d_2_17                             ;
        addi x2, x2, -8                           ;
        lui x8, 0xffe00                           ;
        xor x2, x2, x8                            ;
        sc.d x2, x2, (x2)                         ;
_l156:  la x4, d_0_10                             ;
        addi x4, x4, -16                          ;
        amoswap.w x17, x2, (x4)                   ;
_l157:  divw x3, x22, x17                         ;
_l158:  la x24, d_2_11                            ;
        addi x24, x24, -12                        ;
        amoor.w x11, x13, (x24)                   ;
_l159:  srliw x27, x30, 29                        ;
_l160:  slli x28, x23, 0                          ;
_l161:  la x17, d_4_27                            ;
        fsw f15, -28(x17)                         ;
_l162:  la x9, d_5_26                             ;
        lb x5, -28(x9)                            ;
_l163:  xor x19, x19, x19                         ;
        addi x5, zero, 1                          ;
        slli x5, x5, 15                           ;
        add x19, x19, x5                          ;
        addi x15, zero, 1                         ;
        slli x15, x15, 17                         ;
        add x19, x19, x15                         ;
        csrrs x1, mie, x19                        ;
_l164:  la x28, d_2_14                            ;
        addi x28, x28, -4                         ;
        lui x7, 0xffe00                           ;
        xor x28, x28, x7                          ;
        amoand.w x14, x7, (x28)                   ;
_l165:  divw x19, x11, x23                        ;
_l166:  la x16, d_4_5                             ;
        lh x23, -26(x16)                          ;
_l167:  fclass.s x1, f5                           ;
_l168:  fmsub.s f7, f23, f10, f17, rtz            ;
_l169:  mulhsu x22, x25, x16                      ;
_l170:  addw x15, x15, x13                        ;
_l171:  fmsub.s f26, f11, f15, f18, rup           ;
_l172:  fmul.s f27, f3, f29, rmm                  ;
_l173:  slli x1, x2, 17                           ;
_l174:  la x12, d_1_20                            ;
        addi x12, x12, 0                          ;
        amomin.d x7, x8, (x12)                    ;
_l175:  ori x2, x12, 1558                         ;
_l176:  sraw x6, x11, x12                         ;
_l177:  addi x3, x0, 0                            ;
_l178:  jal x23, _l195                                    ;
_l179:  la x28, d_4_0                             ;
        addi x28, x28, -4                         ;
        amoand.w x13, x24, (x28)                  ;
_l180:  la x20, d_0_22                            ;
        lh x9, 8(x20)                             ;
_l181:  la x21, d_5_21                            ;
        lui x17, 0xffe00                          ;
        xor x21, x21, x17                         ;
        sh x6, -4(x21)                            ;
_l182:  la x2, d_0_24                             ;
        sd x25, -24(x2)                           ;
_l183:  xori x2, x11, -1457                       ;
_l184:  fcvt.l.s x30, f18, rtz                    ;
_l185:  sltiu x29, x13, 2047                      ;
_l186:  la x29, d_0_0                             ;
        addi x29, x29, -20                        ;
        amominu.w x5, x25, (x29)                  ;
_l187:  la x26, _l195                             ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l188:  ecall                                     ;
_l189:  divw x28, x23, x18                        ;
_l190:  fle.s x24, f8, f15                        ;
_l191:  la x6, d_3_23                             ;
        addi x6, x6, -8                           ;
        amomin.d x16, x23, (x6)                   ;
_l192:  remuw x12, x2, x1                         ;
_l193:  feq.s x5, f20, f28                        ;
_l194:  bge x14, x8, _l198                        ;
_l195:  remuw x22, x6, x10                        ;
_l196:  csrrsi x16, scause, 23                    ;
_l197:  fsgnj.s f25, f10, f4                      ;
_l198:;
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
                .dword 0x0742a4bdb1eb6346, 0x7b8bca0bbbd25460
                .dword 0x8e77498a1a9e67f2, 0xb71635e747660d6c
d_0_0:          .dword 0x12afd21556e1ce72, 0x029229e71ede4c87
d_0_1:          .dword 0x9ff140df7f0f5720, 0x3e747313182b82cf
d_0_2:          .dword 0xfbb7acadd1d316de, 0x566111ac50685695
d_0_3:          .dword 0x0811edd55fc97ecd, 0xba619a8a2403c9c5
d_0_4:          .dword 0xd5287d046aebcebc, 0x6ecd6b6d4411c46a
d_0_5:          .dword 0x06e783d749e5c587, 0x8dd5708c8db141f0
d_0_6:          .dword 0xa2e703a31f576322, 0x04d7adbeb9acdc41
d_0_7:          .dword 0xb59c37414bcdc7f2, 0xf18eaac37fee5d0e
d_0_8:          .dword 0xb817c6f9c2d55214, 0xc23ff90405cd0860
d_0_9:          .dword 0xbfe6ffd7942b6aeb, 0x0f71e34df7f9f4ba
d_0_10:         .dword 0x47aba97070350be9, 0xe37231b29ceed806
d_0_11:         .dword 0xbaeecc5e443cb451, 0x91e4ef423cbb255b
d_0_12:         .dword 0x904177c3ad828c16, 0x50fb2727eb6b2488
d_0_13:         .dword 0x5270050eac9edd26, 0xb48e8172e721b760
d_0_14:         .dword 0xafbc005f5b5b7171, 0x2c26fdb4c904e35a
d_0_15:         .dword 0x550f845c3162f7f8, 0x3d4639869a863db7
d_0_16:         .dword 0xe03d5f8845308d54, 0x59b559f2a3a95f12
d_0_17:         .dword 0x7125fd73941a4689, 0x9915d98be92fa424
d_0_18:         .dword 0x1ae0fcbfb890b250, 0x0d4885827463724e
d_0_19:         .dword 0x2a62e338fbc66600, 0xfe8034feb97bde09
d_0_20:         .dword 0xfd9ca523936897aa, 0x7b6a90e5b19f816b
d_0_21:         .dword 0x983ab4692e18acc7, 0x8159b1075705a4a8
d_0_22:         .dword 0x277f395c440da0c6, 0xe5c4527e3de5d26b
d_0_23:         .dword 0x788b8da4929d45b7, 0x29e163bddcb651a5
d_0_24:         .dword 0x2089032e81769e5d, 0x3fade577150bdf2f
d_0_25:         .dword 0x01058590afc2ea37, 0xd12757e58942eeed
d_0_26:         .dword 0x8cd2a5a27545a149, 0x3de9a32dcafd013a
d_0_27:         .dword 0x486409905ac3ea93, 0x77a4608a43660370
                .dword 0x71a2a7e33262219e, 0x876c13575c1ca8f9
                .dword 0xbdb4d7caea3e8146, 0xfeebd5b7baecba58
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xffd750cc5c97f3f3, 0xd4042488ad82fba8
                .dword 0x6dfc45ffcd60d7f0, 0x6c0594df7bf853cf
d_1_0:          .dword 0xab4505bfcee5da6f, 0x0935834d19523f47
d_1_1:          .dword 0x62661cb19cc5daa7, 0xf2d464f5a5271854
d_1_2:          .dword 0x23b5c1db747e763d, 0xae43f89e850a067a
d_1_3:          .dword 0x3e3b05119a489896, 0xbce87600d7fa2b53
d_1_4:          .dword 0xe9f8a09ef9794483, 0xf88a712929cda394
d_1_5:          .dword 0x88340ec9e5e1e686, 0x8b6647df4b9bfa30
d_1_6:          .dword 0x4895b903f9ed506d, 0x4840f220ba712246
d_1_7:          .dword 0xe1e533669bd94589, 0xe00bab470666e564
d_1_8:          .dword 0x2c23e26d8f76be11, 0xe6fa21133fcd2c5a
d_1_9:          .dword 0x155a8bf412c5163b, 0x195e3a2d476f84fb
d_1_10:         .dword 0xd7f79fb34b09cf88, 0x2aaa4ffddf709005
d_1_11:         .dword 0xe885ab99af8f6fbf, 0x7138c58517ce8820
d_1_12:         .dword 0x02d14647ce4c0531, 0x6116222f76c704ec
d_1_13:         .dword 0x5f6338a2c9a54b82, 0x7e6ddc04320e80bc
d_1_14:         .dword 0x35a889feec2ca0be, 0x042cb7837632c1ae
d_1_15:         .dword 0xeef4020d8a23af16, 0xada10e4607ec908a
d_1_16:         .dword 0xf3ee0e1fab3bcc7a, 0x0773b63a5a621ea3
d_1_17:         .dword 0x01e6353d40ee3b83, 0x0b863561e8365d03
d_1_18:         .dword 0x24fac0dfa3f49260, 0x3b3f862b70297bb0
d_1_19:         .dword 0x04fd835be0c7f199, 0xfd31455cb011910b
d_1_20:         .dword 0xde3d503cea1fb840, 0xae5775df54178ad3
d_1_21:         .dword 0x21aa12efd64f09b2, 0x8d53fc965007b4e7
d_1_22:         .dword 0x36f9f299146b37dd, 0x31381294f3b60b8a
d_1_23:         .dword 0xd77e9e0f3f995f2a, 0x6221a30b933e5835
d_1_24:         .dword 0x05d1f4f0797f5c44, 0x6c3ed9421657cae4
d_1_25:         .dword 0xdc9d56156680550c, 0xe0e9a187fd8a255c
d_1_26:         .dword 0xe9265ac0e399b05b, 0xeb6c34b7ce5e4e6c
d_1_27:         .dword 0x6bea4116f012ad78, 0x5314ce2dfacecf34
                .dword 0x26f190e684709edd, 0xc6ed84ca45e61620
                .dword 0xe8f50b963bbcd4ff, 0x7929ba2aff7832a8
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x353a0bfe8de5c50f, 0x7623eeb5daf41a7e
                .dword 0x9164e97a38178537, 0xe5ed573e67dde76d
d_2_0:          .dword 0xe7da93d597362c19, 0x6c9f1aaa3ff1566d
d_2_1:          .dword 0x0fdd8a06a77d4f1e, 0xad7e46c007bb694e
d_2_2:          .dword 0x80d201d68fbb4ab9, 0xc2253aca82bc5a47
d_2_3:          .dword 0xa2fd33c2760c2a5b, 0xf818697c071441ad
d_2_4:          .dword 0x2a817ec639cb896d, 0x315e61c23de6bcf8
d_2_5:          .dword 0xeed24477a9ea6a4a, 0x8e9f91c9f59ef287
d_2_6:          .dword 0x0091ab2b83b447bf, 0xa07fdcf41e89c0e5
d_2_7:          .dword 0x589600dfc9044f36, 0x05e662f24f33544a
d_2_8:          .dword 0x819c27cb9bc2f0d4, 0xb48c83bfdbfb74d0
d_2_9:          .dword 0x312a63e98d0902df, 0x819f6d088be2d2b0
d_2_10:         .dword 0x9b009c9a3fb747bd, 0x51b6a2eb8a3abd6d
d_2_11:         .dword 0x6f80e484812176e1, 0x1b1bfff16311eade
d_2_12:         .dword 0x0cf365cdf4354397, 0x588915150566983d
d_2_13:         .dword 0xdd4730b26e67a250, 0x512e65fee258daf1
d_2_14:         .dword 0xe3739dcd203e124f, 0xee772099b7fa7e57
d_2_15:         .dword 0xa19ab0ea4b5fab81, 0x931fb628288f12b7
d_2_16:         .dword 0xd13f989610ea9cfe, 0xeac445cffaead94f
d_2_17:         .dword 0xb86a473873f99f2d, 0x8792f2aa37d5e72a
d_2_18:         .dword 0xaf8831b7c5475685, 0x160cc9b76465326f
d_2_19:         .dword 0x02d0be1baea444e3, 0x43683250f07411c8
d_2_20:         .dword 0xcef88dfa006d0f03, 0x7d6f515a8a974005
d_2_21:         .dword 0x67eb46a8f5358adb, 0xe67db622547e7f09
d_2_22:         .dword 0x1118819e35e2e384, 0x07236eb6ffa06a15
d_2_23:         .dword 0x65e74b32160cb0c7, 0x99a1ad4fa0a50e6f
d_2_24:         .dword 0x85f37a762df34840, 0x9a4a80487fc41c67
d_2_25:         .dword 0x3664e75cd1abca4a, 0x2565418084c966a4
d_2_26:         .dword 0x3a53404ee402e92e, 0x6a539e8a7fad370d
d_2_27:         .dword 0x8ce4862740dc576e, 0xe768a6ba204f59ae
                .dword 0x1345fc759d865b81, 0xf359cdd4bb100e4d
                .dword 0x603c107b6dc15fc6, 0xd0f6f709d8b85cc4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc08c1b445b78e2f7, 0x547b7eecf3b5c461
                .dword 0x10c92372c621c21f, 0x3ee3fdeb1bbad26a
d_3_0:          .dword 0x1e4c89934bcb6312, 0x5137f4c63094f43a
d_3_1:          .dword 0xa147b69d5ac435fd, 0xcc34be3d6c0e76a2
d_3_2:          .dword 0x0a119aec8a7d8d73, 0x0f27180edae94a9f
d_3_3:          .dword 0xd83163c31416482e, 0xebbd5081caa54dbe
d_3_4:          .dword 0x7b994d1ceb1543e0, 0x7eea14dafed30385
d_3_5:          .dword 0x0282deb6b0064fce, 0x4f1219692b9d1dc4
d_3_6:          .dword 0xdf90840501faf845, 0x20224d4eec92a6f7
d_3_7:          .dword 0x7fd3064c8a1c324a, 0x101c09cf68fdb942
d_3_8:          .dword 0x4bf5ae6471d705be, 0x22ca7a678d96ff16
d_3_9:          .dword 0x9345351b72e54109, 0x863c5da785ffa27b
d_3_10:         .dword 0x1bab435f6a922f34, 0x79865822ae43f1c7
d_3_11:         .dword 0xd7718a46abae834e, 0x46c27028ff0cce6b
d_3_12:         .dword 0x9df116b412a8629d, 0x5e8ba2e91ecd2782
d_3_13:         .dword 0x6ca94631449a9a9d, 0x6bd1f28dd0ab4e46
d_3_14:         .dword 0x208bc357724a3ffe, 0xdcda36ba8f571ee9
d_3_15:         .dword 0x4d596065a07b24e0, 0x76d6eda2243c7b97
d_3_16:         .dword 0x46471a6840c0a3f4, 0x346f8c7b4a80ff6d
d_3_17:         .dword 0x8babec6e1cb42285, 0xb9fc9b12f7c1b44f
d_3_18:         .dword 0x908e4bbe4fc1c9b1, 0x8c2479ce31d9c101
d_3_19:         .dword 0xddf0f95e126663d7, 0xe62f485384881a0d
d_3_20:         .dword 0x83c5a51703183317, 0x964a57905acd9594
d_3_21:         .dword 0x0ddd03dfaf0252e7, 0x6366139fe4b1134b
d_3_22:         .dword 0x935bb7e1fc5bf903, 0x5e6c49d07617eddd
d_3_23:         .dword 0x752866294c3c6733, 0x860732849c84602a
d_3_24:         .dword 0x2cb2aded8a03949c, 0x14c8b7dea520b7bb
d_3_25:         .dword 0xe70b1039840537c0, 0x43582d0e876af63e
d_3_26:         .dword 0xc28a78bd053bbf34, 0xb3283726bbd2ad0d
d_3_27:         .dword 0x2e336888d0cbc9ed, 0xa138d2e7da804dce
                .dword 0x9c69dfa2d472397d, 0xa10821fcfee2e80f
                .dword 0xf89cd6ca3e2984c4, 0x727eb9f588cea4d3
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xe1d87ac3d9f9e075, 0x46458d5bd8db7264
                .dword 0xfdaff5b517a7a4cb, 0x790758686b8f9fdc
d_4_0:          .dword 0xc10d1b7e2b8565c4, 0x8c5cb88d16d719c8
d_4_1:          .dword 0x9d1dfd283b3b7c86, 0x226d7f8957e0c02e
d_4_2:          .dword 0x20dfe3d5f169774e, 0x8700920d48c9f8db
d_4_3:          .dword 0xdadc69dfc2f3fa1e, 0xf1dd9e295a942536
d_4_4:          .dword 0x00c2d1af069b730e, 0x65478bfb227c29f6
d_4_5:          .dword 0x63446f79ddc3599f, 0xc25ee0e5731f23d0
d_4_6:          .dword 0x7d3d77a56fff2b97, 0x7a95ea3a41db257d
d_4_7:          .dword 0x6c1c40b3c6d5cde8, 0x389f30622f330b4b
d_4_8:          .dword 0xd834876b0096769d, 0x7d168e42d3411365
d_4_9:          .dword 0xc786eaf1efeb63aa, 0x247fda9578216111
d_4_10:         .dword 0xbbbd5cef9a0d9808, 0x4d46951146daf2bb
d_4_11:         .dword 0x8b26ffd00266d769, 0x2af0cdd50f500ce0
d_4_12:         .dword 0x67b08673bf3f3517, 0x9ab3fcaff1868cd2
d_4_13:         .dword 0xecbfe29a9a83f190, 0xf4488d864afe6657
d_4_14:         .dword 0xf5b3e3d23f5034e9, 0xfba80d419d4678e2
d_4_15:         .dword 0xe71de7c7408f39bb, 0xa6822925afd9c480
d_4_16:         .dword 0x8488bc8b5ab1090a, 0xc97e653a48dd7d50
d_4_17:         .dword 0x060af984c259ed3c, 0xc774bfd97e1423bf
d_4_18:         .dword 0xfa1ed9e842be9a8c, 0x63a110dde8042c92
d_4_19:         .dword 0x9eb029dd6ff28a41, 0x2a022c78ffba1b3d
d_4_20:         .dword 0x1e7ff8bf8c4d74a5, 0x822726ff2728f580
d_4_21:         .dword 0x83207035b430b06c, 0xf185b39cbcbf8977
d_4_22:         .dword 0x161ac93db87720f1, 0xdbab0e776620afda
d_4_23:         .dword 0xd6bfc969d35d41c9, 0x896dfc09998c6b1a
d_4_24:         .dword 0x5e47eeb13397e174, 0x27e5d34c3cd10ba1
d_4_25:         .dword 0x4369d258cd38b121, 0x97a5e04c8a093c8c
d_4_26:         .dword 0x977ea7a9ddf6e581, 0xcb47e5dbd9a93148
d_4_27:         .dword 0x04d4824540597872, 0x94f974d3c2e4006e
                .dword 0xe0e50ec62bb3c207, 0xab89e379361e1fde
                .dword 0xdf9698dea45df346, 0x0237aa6fa44e1b90
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf259097428b3ec91, 0x55425a8dd30e1cd6
                .dword 0x9f89d8894939ccde, 0xe876c471da46fba9
d_5_0:          .dword 0x1053058710aa3257, 0x6e66486a9c7b1144
d_5_1:          .dword 0xe2bd0bfd8f8a6f65, 0x346a4e21fcadaa74
d_5_2:          .dword 0x58a105558fa29a4b, 0xdaedd18baac19576
d_5_3:          .dword 0xccceab013d96a8b1, 0x2cecc5ac0d0f6dee
d_5_4:          .dword 0xec69a8654d99a226, 0x80c6e3923b4388b4
d_5_5:          .dword 0xb0f367a48d4d04ed, 0x382d03751ec84eb6
d_5_6:          .dword 0xfcd97bc4899c793a, 0x352605da0c90b980
d_5_7:          .dword 0x250c350d292cdbc2, 0xff0ca4c9ac3e68b5
d_5_8:          .dword 0xf55e8183c3b87366, 0xaca0bfaaa0f263f9
d_5_9:          .dword 0x1b76b82f74f0cf50, 0x378d854c994087e1
d_5_10:         .dword 0x46495319df5cce46, 0x9cf6fad32e073d7a
d_5_11:         .dword 0xd78fde5134872c19, 0x6a3eb562c868b410
d_5_12:         .dword 0x0a3afe4684e328e1, 0x004c484d76013480
d_5_13:         .dword 0x1efa114f0ab0f11c, 0xa8ddc72299ab3b7d
d_5_14:         .dword 0x1faa2e3cec47fdec, 0xe6ba853ad5a7f43f
d_5_15:         .dword 0x009028923fc17a64, 0xa20efd894d8d7f96
d_5_16:         .dword 0x0ac634f667b08926, 0x33b6f65d971dc03d
d_5_17:         .dword 0xdf1e85abc74273d9, 0x718bf4c72775d1fb
d_5_18:         .dword 0x1dc39f9041a1a9a8, 0x8d2b30402e8e1bc1
d_5_19:         .dword 0x20ff6b895ef4274a, 0xd94cbbe73d729968
d_5_20:         .dword 0x79809de4481deac7, 0xf2e13f7fb881567f
d_5_21:         .dword 0xb6d3904f0fddbdd6, 0xff99973788076204
d_5_22:         .dword 0xddaba807a4be92e8, 0x9480e3ca450a0a76
d_5_23:         .dword 0x933b06ac9286b479, 0x06d6d6e2a45f61b6
d_5_24:         .dword 0x502793f0043be8ed, 0x472ff5ff657ced50
d_5_25:         .dword 0xb413e8a97b75b144, 0x4593c258a6eb3570
d_5_26:         .dword 0xf3cffcc9b741cd67, 0x2ee2ef237318316e
d_5_27:         .dword 0x40fe858a70714485, 0x2a82c27b7e755b0f
                .dword 0x0fa01866e65e1125, 0xa5a7edb8a12aef1c
                .dword 0x242a20cf898b40c7, 0xf7977780e0f53245
         /* Random data */
_end_data5:
              
                 
