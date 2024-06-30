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
_s0:    la x1, d_5_17                             ;
        sd x20, 16(x1)                            ;
_s1:    slliw x13, x24, 7                         ;
_s2:    la x12, d_2_5                             ;
        addi x12, x12, -8                         ;
        amoand.d x16, x17, (x12)                  ;
_s3:    ebreak                                    ;
_s4:    la x16, _s5                               ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
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
_p0:    la x14, d_1_8                             ;
        srai x14, x14, 1                          ;
        csrrc x12, pmpaddr6, x14                  ;
_p1:    csrrsi x14, mie, 0                        ;
_p2:    csrrsi x12, medeleg, 15                   ;
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
_l0:    lui x27, 316021                           ;
_l1:    fmul.s f25, f24, f24, rmm                 ;
_l2:    remuw x27, x25, x18                       ;
_l3:    bgeu x6, x22, _l90                        ;
_l4:    la x25, d_4_15                            ;
        addi x25, x25, 28                         ;
        amoor.w x19, x14, (x25)                   ;
_l5:    la x28, _l46                              ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l6:    la x19, d_0_3                             ;
        addi x19, x19, -28                        ;
        amoor.w x23, x7, (x19)                    ;
_l7:    fcvt.s.wu f21, x15, rmm                   ;
_l8:    srli x1, x3, 16                           ;
_l9:    addi x29, x16, -1199                      ;
_l10:   la x27, d_2_1                             ;
        addi x27, x27, -4                         ;
        sc.w x21, x3, (x27)                       ;
_l11:   la x9, d_4_16                             ;
        lh x7, -26(x9)                            ;
_l12:   remw x22, x30, x2                         ;
_l13:   fmax.s f29, f29, f19                      ;
_l14:   la x17, d_5_22                            ;
        addi x17, x17, -4                         ;
        sc.w x18, x8, (x17)                       ;
_l15:   la x8, d_0_21                             ;
        addi x8, x8, -0                           ;
        lui x16, 0xffe00                          ;
        xor x8, x8, x16                           ;
        amoadd.w x5, x16, (x8)                    ;
_l16:   ebreak                                    ;
_l17:   la x12, d_0_23                            ;
        addi x12, x12, 12                         ;
        amomaxu.w x8, x30, (x12)                  ;
_l18:   la x28, d_4_16                            ;
        addi x28, x28, -16                        ;
        amominu.w x12, x28, (x28)                 ;
_l19:   srlw x30, x20, x9                         ;
_l20:   fle.s x17, f30, f4                        ;
_l21:   fcvt.lu.s x28, f31, rmm                   ;
_l22:   la x8, d_5_20                             ;
        addi x8, x8, 28                           ;
        sc.w x17, x24, (x8)                       ;
_l23:   fle.s x6, f30, f22                        ;
_l24:   la x27, d_2_27                            ;
        addi x27, x27, -20                        ;
        lui x21, 0xffe00                          ;
        xor x27, x27, x21                         ;
        amoor.w x11, x21, (x27)                   ;
_l25:   xor x3, x3, x3                            ;
        addi x11, zero, 3                         ;
        slli x11, x11, 5                          ;
        add x3, x3, x11                           ;
        csrrs x29, sstatus, x3                    ;
_l26:   fclass.s x17, f19                         ;
_l27:   remu x6, x21, x3                          ;
_l28:   lui x13, 496282                           ;
_l29:   slliw x20, x15, 16                        ;
_l30:   fnmadd.s f5, f13, f31, f2, rdn            ;
_l31:   la x11, d_0_1                             ;
        addi x11, x11, -0                         ;
        amomax.d x9, x17, (x11)                   ;
_l32:   la x14, _l153                             ;
        csrrw zero, mepc, x14                     ;
        mret                                      ;
_l33:   la x7, _l54                               ;
        lui x20, 0xffe00                          ;
        xor x7, x7, x20                           ;
        ld x29, 8(x7)                             ;
_l34:   la x3, d_2_4                              ;
        addi x3, x3, 16                           ;
        lui x28, 0xffe00                          ;
        xor x3, x3, x28                           ;
        amominu.w x26, x28, (x3)                  ;
_l35:   fsub.s f31, f26, f2, rdn                  ;
_l36:   fcvt.lu.s x5, f25, rdn                    ;
_l37:   la x3, d_1_2                              ;
        lwu x13, 16(x3)                           ;
_l38:   la x26, d_3_6                             ;
        sh x26, 18(x26)                           ;
_l39:   ecall                                     ;
_l40:   ecall                                     ;
_l41:   bgeu x3, x26, _l179                       ;
_l42:   jal x4, _l103                             ;
_l43:   addw x1, x24, x1                          ;
_l44:   bne x4, x11, _l117                        ;
_l45:   fmv.w.x f1, x24                           ;
_l46:   la x10, d_2_5                             ;
        lb x19, 21(x10)                           ;
_l47:   la x4, d_5_22                             ;
        addi x4, x4, 4                            ;
        amomaxu.w x28, x14, (x4)                  ;
_l48:   fmv.x.w x12, f31                          ;
_l49:   fsqrt.s f31, f3, dyn                      ;
_l50:   sltiu x24, x27, 953                       ;
_l51:   subw x15, x8, x2                          ;
_l52:   la x25, d_3_24                            ;
        addi x25, x25, 28                         ;
        amoand.w x29, x23, (x25)                  ;
_l53:   la x14, _l152                             ;
        jalr x5, 0(x14)                           ;
_l54:   la x7, d_3_6                              ;
        sh x12, 8(x7)                             ;
_l55:   divuw x22, x24, x21                       ;
_l56:   la x11, d_1_16                            ;
        addi x11, x11, -16                        ;
        amomax.w x12, x20, (x11)                  ;
_l57:   fdiv.s f21, f26, f28, dyn                 ;
_l58:   fsgnjx.s f29, f12, f19                    ;
_l59:   fmax.s f22, f4, f28                       ;
_l60:   fnmadd.s f31, f9, f19, f1, rne            ;
_l61:   srlw x4, x15, x16                         ;
_l62:   fnmsub.s f16, f19, f3, f26, rmm           ;
_l63:   fmin.s f21, f31, f28                      ;
_l64:   la x5, d_1_6                              ;
        addi x5, x5, -24                          ;
        amoand.d x12, x15, (x5)                   ;
_l65:   la x8, d_0_22                             ;
        addi x8, x8, 16                           ;
        sc.d x2, x8, (x8)                         ;
_l66:   feq.s x24, f29, f30                       ;
_l67:   slti x6, x30, 1190                        ;
_l68:   lui x0, 337350                            ;
_l69:   fdiv.s f12, f2, f30, rmm                  ;
_l70:   subw x16, x3, x4                          ;
_l71:   fmsub.s f13, f24, f18, f18, rtz           ;
_l72:   fcvt.w.s x29, f16, rdn                    ;
_l73:   fcvt.s.wu f25, x5, rup                    ;
_l74:   fle.s x20, f21, f28                       ;
_l75:   fsgnjn.s f14, f24, f12                    ;
_l76:   fmv.x.w x11, f4                           ;
_l77:   la x29, _l135                             ;
        csrrw zero, sepc, x29                     ;
        sret                                      ;
_l78:   bge x16, x20, _l95                        ;
_l79:   la x12, d_2_5                             ;
        lb x3, -26(x12)                           ;
_l80:   la x5, d_4_16                             ;
        addi x5, x5, 28                           ;
        amomin.w x12, x2, (x5)                    ;
_l81:   la x16, d_1_24                            ;
        lw x24, 24(x16)                           ;
_l82:   fcvt.s.lu f22, x28, rup                   ;
_l83:   fmul.s f16, f12, f13, rup                 ;
_l84:   la x18, d_4_16                            ;
        addi x18, x18, -12                        ;
        amomax.w x7, x20, (x18)                   ;
_l85:   fnmadd.s f4, f25, f29, f19, rtz           ;
_l86:   fcvt.s.wu f20, x23, dyn                   ;
_l87:   la x22, d_3_8                             ;
        sb x3, 3(x22)                             ;
_l88:   la x19, d_5_24                            ;
        lbu x20, -29(x19)                         ;
_l89:   srlw x21, x12, x30                        ;
_l90:   srai x5, x30, 34                          ;
_l91:   la x26, d_2_3                             ;
        lhu x8, 2(x26)                            ;
_l92:   la x9, d_5_22                             ;
        addi x9, x9, 4                            ;
        amoor.w x5, x9, (x9)                      ;
_l93:   la x8, d_1_15                             ;
        ld x14, -0(x8)                            ;
_l94:   la x16, d_4_12                            ;
        ld x12, -8(x16)                           ;
_l95:   fcvt.s.w f23, x23, rmm                    ;
_l96:   la x18, d_3_1                             ;
        lhu x16, -10(x18)                         ;
_l97:   la x3, d_5_21                             ;
        addi x3, x3, 0                            ;
        amoand.d x24, x11, (x3)                   ;
_l98:   rem x26, x5, x9                           ;
_l99:   mulhsu x23, x22, x2                       ;
_l100:  la x20, d_1_14                            ;
        addi x20, x20, 12                         ;
        lui x3, 0xffe00                           ;
        xor x20, x20, x3                          ;
        amoadd.w x27, x3, (x20)                   ;
_l101:  la x8, d_3_0                              ;
        addi x8, x8, 24                           ;
        lr.w x28, (x8)                            ;
_l102:  mulw x3, x26, x3                          ;
_l103:  fsub.s f13, f14, f16, dyn                 ;
_l104:  divu x13, x8, x0                          ;
_l105:  la x29, d_3_0                             ;
        addi x29, x29, -16                        ;
        amoswap.d x6, x24, (x29)                  ;
_l106:  bge x1, x14, _l150                        ;
_l107:  li x27, 0                                 ;
        la x3, pt1                                ;
        addi x3, x3, 0                            ;
        sfence.vma x27, x3                        ;
_l108:  blt x30, x15, _l157                       ;
_l109:  la x22, d_2_19                            ;
        addi x22, x22, 16                         ;
        amoadd.d x7, x7, (x22)                    ;
_l110:  la x22, d_3_5                             ;
        addi x22, x22, -12                        ;
        lui x20, 0xffe00                          ;
        xor x22, x22, x20                         ;
        amoor.w x28, x20, (x22)                   ;
_l111:  xor x23, x23, x23                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 29                           ;
        add x23, x23, x1                          ;
        csrrs x2, sscratch, x23                   ;
_l112:  subw x15, x8, x7                          ;
_l113:  la x21, d_2_13                            ;
        sd x15, -0(x21)                           ;
_l114:  la x1, _l69                               ;
        lbu x28, 30(x1)                           ;
_l115:  li x14, 0                                 ;
        la x2, pt0                                ;
        addi x2, x2, 32                           ;
        sfence.vma x14, x2                        ;
_l116:  la x18, d_4_25                            ;
        addi x18, x18, 24                         ;
        amoand.d x6, x24, (x18)                   ;
_l117:  csrrwi x9, mscratch, 6                    ;
_l118:  lui x3, 531131                            ;
_l119:  ecall                                     ;
_l120:  flt.s x13, f14, f24                       ;
_l121:  ori x13, x29, 29                          ;
_l122:  la x26, d_0_11                            ;
        sd x8, -16(x26)                           ;
_l123:  la x22, d_5_25                            ;
        ld x2, -8(x22)                            ;
_l124:  sllw x21, x11, x30                        ;
_l125:  srli x22, x6, 12                          ;
_l126:  la x20, d_5_11                            ;
        addi x20, x20, 16                         ;
        amoxor.d x16, x18, (x20)                  ;
_l127:  slti x19, x9, 508                         ;
_l128:  flt.s x23, f30, f11                       ;
_l129:  ecall                                     ;
_l130:  li x18, 0                                 ;
        la x28, pt3                               ;
        addi x28, x28, 16                         ;
        sfence.vma x18, x28                       ;
_l131:  ebreak                                    ;
_l132:  fence                                     ;
_l133:  li x22, 1                                 ;
        la x12, pt2                               ;
        addi x12, x12, 16                         ;
        sfence.vma x22, x12                       ;
_l134:  mulw x28, x2, x19                         ;
_l135:  fcvt.s.lu f15, x15, dyn                   ;
_l136:  bne x16, x30, _l187                       ;
_l137:  la x30, d_2_15                            ;
        fsw f18, -28(x30)                         ;
_l138:  ebreak                                    ;
_l139:  la x23, d_5_19                            ;
        addi x23, x23, 20                         ;
        amoand.w x2, x7, (x23)                    ;
_l140:  slti x17, x10, -1385                      ;
_l141:  sraiw x20, x13, 6                         ;
_l142:  fence                                     ;
_l143:  fcvt.s.wu f26, x8, rdn                    ;
_l144:  fadd.s f23, f17, f15, rne                 ;
_l145:  la x8, d_5_24                             ;
        sb x12, 18(x8)                            ;
_l146:  la x8, d_4_17                             ;
        addi x8, x8, 24                           ;
        lr.w x30, (x8)                            ;
_l147:  fcvt.s.l f24, x6, rne                     ;
_l148:  fnmsub.s f20, f9, f25, f2, rne            ;
_l149:  csrrci x21, mie, 3                        ;
_l150:  la x7, d_3_14                             ;
        lui x7, 0xffe00                           ;
        xor x7, x7, x7                            ;
        ld x23, -0(x7)                            ;
_l151:  subw x6, x4, x11                          ;
_l152:  divu x16, x15, x19                        ;
_l153:  remu x30, x22, x3                         ;
_l154:  fcvt.w.s x18, f31, rmm                    ;
_l155:  fcvt.s.lu f20, x9, dyn                    ;
_l156:  xor x22, x22, x22                         ;
        addi x24, zero, 1                         ;
        slli x24, x24, 11                         ;
        add x22, x22, x24                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 13                           ;
        add x22, x22, x7                          ;
        csrrw x30, mepc, x22                      ;
_l157:  fnmadd.s f21, f8, f25, f9, rne            ;
_l158:  fcvt.s.l f1, x2, rmm                      ;
_l159:  mulw x28, x4, x18                         ;
_l160:  remuw x23, x10, x10                       ;
_l161:  divuw x13, x3, x3                         ;
_l162:  la x18, d_0_21                            ;
        lb x2, -13(x18)                           ;
_l163:  la x9, _l190                              ;
        csrrw zero, mepc, x9                      ;
        mret                                      ;
_l164:  subw x16, x21, x9                         ;
_l165:  divu x22, x12, x10                        ;
_l166:  mulhsu x27, x15, x15                      ;
_l167:  la x21, d_5_26                            ;
        addi x21, x21, -16                        ;
        lr.d x11, (x21)                           ;
_l168:  fsgnjx.s f2, f22, f25                     ;
_l169:  la x16, d_5_27                            ;
        addi x16, x16, -0                         ;
        amominu.w x19, x10, (x16)                 ;
_l170:  fclass.s x2, f4                           ;
_l171:  la x25, d_4_14                            ;
        addi x25, x25, -0                         ;
        lui x12, 0xffe00                          ;
        xor x25, x25, x12                         ;
        amoor.w x7, x12, (x25)                    ;
_l172:  la x18, d_5_5                             ;
        addi x18, x18, -28                        ;
        amomin.w x11, x4, (x18)                   ;
_l173:  addw x19, x14, x26                        ;
_l174:  divw x24, x18, x23                        ;
_l175:  la x16, _l161                             ;
        lui x2, 0xffe00                           ;
        xor x16, x16, x2                          ;
        lb x19, 4(x16)                            ;
_l176:  slti x16, x29, 2024                       ;
_l177:  ori x6, x19, 0                            ;
_l178:  mulh x15, x16, x25                        ;
_l179:  la x12, d_4_25                            ;
        lh x4, -30(x12)                           ;
_l180:  la x10, d_3_14                            ;
        addi x10, x10, 8                          ;
        sc.w x11, x9, (x10)                       ;
_l181:  fmsub.s f0, f24, f0, f28, rup             ;
_l182:  divw x21, x2, x19                         ;
_l183:  bge x29, x4, _l197                        ;
_l184:  fmv.w.x f24, x22                          ;
_l185:  la x27, _l190                             ;
        csrrw zero, uepc, x27                     ;
        uret                                      ;
_l186:  sltiu x25, x27, -1221                     ;
_l187:  xor x23, x23, x23                         ;
        addi x5, zero, 3                          ;
        slli x5, x5, 2                            ;
        add x23, x23, x5                          ;
        addi x20, zero, 3                         ;
        slli x20, x20, 4                          ;
        add x23, x23, x20                         ;
        csrrc x29, mscratch, x23                  ;
_l188:  fcvt.w.s x28, f3, dyn                     ;
_l189:  slli x4, x18, 29                          ;
_l190:  la x29, d_0_15                            ;
        addi x29, x29, 24                         ;
        amominu.d x20, x19, (x29)                 ;
_l191:  la x5, d_3_11                             ;
        addi x5, x5, 0                            ;
        lui x9, 0xffe00                           ;
        xor x5, x5, x9                            ;
        lr.d x17, (x5)                            ;
_l192:  fcvt.s.w f20, x19, rne                    ;
_l193:  fsgnj.s f20, f30, f18                     ;
_l194:  la x2, d_1_9                              ;
        addi x2, x2, -8                           ;
        amominu.w x22, x29, (x2)                  ;
_l195:  la x17, d_5_18                            ;
        addi x17, x17, -24                        ;
        lui x30, 0xffe00                          ;
        xor x17, x17, x30                         ;
        amoadd.w x14, x30, (x17)                  ;
_l196:  bne x4, x11, _l200                        ;
_l197:  fnmsub.s f26, f5, f0, f3, rup             ;
_l198:  xor x16, x16, x16                         ;
        csrrc x27, sip, x16                       ;
_l199:  fmul.s f12, f6, f9, dyn                   ;
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
                .dword 0xbb2ec2929d4c071e, 0xc68af7df351e95da
                .dword 0x120db93f4d91711b, 0xf1fdf7a6cad99d11
d_0_0:          .dword 0x7715ffc4c5ef0709, 0x0ccdf8a5c9d3e379
d_0_1:          .dword 0xf68c2e927eb155e1, 0x70a6411b0119d86f
d_0_2:          .dword 0x3c38eb16c8bcbd9c, 0x6305e139e7d10d7e
d_0_3:          .dword 0x154e04d8e4c0ad19, 0xc3b9cd7541def64f
d_0_4:          .dword 0xc0fbba874f4d70c4, 0x4eae35deb45d4b91
d_0_5:          .dword 0x3597a12adfcdc86b, 0x2dd5e68b2fe7bad6
d_0_6:          .dword 0xb15f7ddda5051a40, 0xe6dc7f5a919f55c8
d_0_7:          .dword 0x7eb831f8ab12be50, 0xd583a797ca67e864
d_0_8:          .dword 0xaf97e15478d7ba7c, 0xbbdf42acf5b2217e
d_0_9:          .dword 0xadd0fc891110526d, 0xcced1937542aa92c
d_0_10:         .dword 0x314a771f5db2896b, 0x948ce6da46c30c24
d_0_11:         .dword 0xcdce2e75b0d9622a, 0x4631a118b19e1d16
d_0_12:         .dword 0x2d41845963dc6f1a, 0x3a81fd2fd2ed2dad
d_0_13:         .dword 0xe57906442275ee92, 0xb213e2a22d19a4d6
d_0_14:         .dword 0x3da163d75c93e798, 0x12373bd7856814ca
d_0_15:         .dword 0xa5a116a302d5f07e, 0x583c83e21f6e2855
d_0_16:         .dword 0xdcc986a8720c0cbc, 0x3b40a6e958952f07
d_0_17:         .dword 0x005a19214fdfdfff, 0x8f8de12dbf1713cc
d_0_18:         .dword 0x0bc5340ecd5405dc, 0xa9f5bd1d3d179d8f
d_0_19:         .dword 0xc861d1db9a4c4d25, 0x2199b4a26efd34a1
d_0_20:         .dword 0xa0ea11d3698e1c7d, 0x2456fa4d90fef546
d_0_21:         .dword 0x3a1e8ef06098287b, 0x6aa71e03ab88bf10
d_0_22:         .dword 0x6515012e5d77c333, 0x4b1ac492fb6f8a5d
d_0_23:         .dword 0x29e4d57588426661, 0x0d773d997a4669d0
d_0_24:         .dword 0xad0fd7710b8ae167, 0xbd0445e6f4cfc015
d_0_25:         .dword 0x9c7a8f674d813e40, 0xd2a22212b244c9f2
d_0_26:         .dword 0x1e73f2d599b3077d, 0x6a10c795c376b767
d_0_27:         .dword 0x1f05dfbd143090d2, 0x0f1fd46555a16627
                .dword 0xabef8532c97231ed, 0xd2ff2efa544501c5
                .dword 0x7e58dcdb751cf603, 0x39a3502f9e15e470
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x6a512c99028b2caf, 0x4ef7f6823b2efb08
                .dword 0x5fad24bb7b362e72, 0x370be1c2cd00b371
d_1_0:          .dword 0xdbe6fbb969616ba1, 0x595370f58b19d01c
d_1_1:          .dword 0xa527f31de535bef8, 0xeecab0ac207ebafa
d_1_2:          .dword 0xb965be5d93d5e688, 0x968ad356222671dc
d_1_3:          .dword 0xeb162a6b808d7845, 0xb16641319311c634
d_1_4:          .dword 0x8ec9138e9a996a4c, 0x2322e264777574c3
d_1_5:          .dword 0xaa23077d95c3ba9d, 0x7325e717cd3216ee
d_1_6:          .dword 0xb59cd33acda27516, 0x14c1adbfafd55dfa
d_1_7:          .dword 0x3d7c187ecc83630b, 0xaa437bdd9234c384
d_1_8:          .dword 0x364b6b9d80f49837, 0x7c96f33f447971c9
d_1_9:          .dword 0xc85b1bbdb0162754, 0x9a8b7c597f9369b8
d_1_10:         .dword 0x067f002f0ffc3930, 0x1a844dff6c374374
d_1_11:         .dword 0x393692d559af6221, 0x846f877ca44dc228
d_1_12:         .dword 0x2f309c42af27874b, 0x2221e9f3601c8fd8
d_1_13:         .dword 0xaa990b9096495ce6, 0x9c257cc92d27a2f1
d_1_14:         .dword 0xde753f4e1b185dea, 0x9e12f4f75c6e9c6e
d_1_15:         .dword 0x4d8be1ae965621c7, 0xeea8d31d6b5a6143
d_1_16:         .dword 0xcc1acdd82240590c, 0xd0293e501d51425c
d_1_17:         .dword 0xb210011203bb4df9, 0x93ca716af9cc6e65
d_1_18:         .dword 0x78ecf099e799aeb0, 0x721ebb41ddbbac1d
d_1_19:         .dword 0xf685b5fc9a126bc7, 0x1ca3714a163920ce
d_1_20:         .dword 0x704d83e491e3f236, 0xe51790f98b053675
d_1_21:         .dword 0x9e9e58ca3143e7cd, 0x930cb2f191d261b9
d_1_22:         .dword 0x684596a4ab7ad7c8, 0x0d0ecab5cb6d1032
d_1_23:         .dword 0xf169cbfa0cb62c6c, 0x1a75ac724f7e554d
d_1_24:         .dword 0xb2b8581fdbc5a58f, 0x93c02d56a7f4f407
d_1_25:         .dword 0x9705b365c040896e, 0x06aedd7101d7eaaa
d_1_26:         .dword 0x79ef5c439adfebc6, 0xd7dd210d71df141f
d_1_27:         .dword 0xf0e077b07bbeeece, 0xe1fc9dbc0ee2b3bc
                .dword 0x8dc33db33a0c4f21, 0x1e61f478fc16e989
                .dword 0x8abd4b7639619b04, 0xd553f2862c9df87e
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x9a4b2c608d2d86a7, 0xf35d313ccfc469ac
                .dword 0xb931825cdf5d9b83, 0xc378f859ce19bc2b
d_2_0:          .dword 0x52f980c63aba836e, 0x7e556f8fdf45834f
d_2_1:          .dword 0xca51571a8ae548d6, 0xf01b68ee61cd44d6
d_2_2:          .dword 0xec24dc88224908d3, 0xd01644d7ec115de7
d_2_3:          .dword 0xd1d7b34fed783414, 0x61eb5d6912fb17b7
d_2_4:          .dword 0xa7494db925995bab, 0x5918e9cbaeb8b131
d_2_5:          .dword 0x45e2a2881d60e00d, 0xe62a6b2b3242c867
d_2_6:          .dword 0xdbe4e3c9637bda49, 0x4e89bd168456b876
d_2_7:          .dword 0x5be4792b5a13febd, 0xc1a0ae6bdb88e475
d_2_8:          .dword 0xbb41df9a2162ba47, 0x39695e2a32465a06
d_2_9:          .dword 0x2d8fcbee4003aa3d, 0xe85147964718848c
d_2_10:         .dword 0xe60ad1e0d5b778c7, 0xdcdcc98789dde2cb
d_2_11:         .dword 0x0d88d3b9729c37b4, 0x1e240bc160e906d0
d_2_12:         .dword 0xa60c9a5814c78f28, 0x3fbb9755ee69660d
d_2_13:         .dword 0x7df1baaa75776fdb, 0x43108bf5f433fbb5
d_2_14:         .dword 0x0cec86b56944ca96, 0x6da23d845f6d85a2
d_2_15:         .dword 0x24cc3fb5dd57054f, 0x8530e48cc8b8b417
d_2_16:         .dword 0xbc4efc29fc039c94, 0xb0238655fd6fc258
d_2_17:         .dword 0x9ca314945feb3c00, 0xd60dc700dbe9d300
d_2_18:         .dword 0x38236e9d95baeffa, 0x8a9119ae09db67f7
d_2_19:         .dword 0xf7b311a80487efb2, 0x8cee1cdbaf39c481
d_2_20:         .dword 0x91afe952e9ade107, 0x92a49579a10cc46e
d_2_21:         .dword 0xf9841852e9f74a38, 0xaebbddbce2a9762f
d_2_22:         .dword 0xa5a4b7399c682dc5, 0x4cf89e546635667b
d_2_23:         .dword 0xb4cefee53a3559fb, 0xf8fa987348fbc348
d_2_24:         .dword 0x289f7f74cf4f5c96, 0x0df4daa8b6a9eb01
d_2_25:         .dword 0x524a7ad512f2aec7, 0x37c672c296de263e
d_2_26:         .dword 0x99117f2a6fb296b4, 0x237df0c4642bd698
d_2_27:         .dword 0x76e513cdafa54864, 0xda7e58e3995574bf
                .dword 0x86d8969c20c528f5, 0xfd5a37fa672a26f2
                .dword 0x28e318c2137d1da9, 0x794b704128d5376d
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc853e3f61d43b9cb, 0xed7b6319861b491f
                .dword 0xf79c96044b120687, 0xa631c90189ed0e92
d_3_0:          .dword 0xd8e32fcf99e1dc18, 0x8fdcf28b00c7554d
d_3_1:          .dword 0x09780a56f4113904, 0x562f09194b12e0c8
d_3_2:          .dword 0xd6029623515c614a, 0x7c9b9f1edec3b1ae
d_3_3:          .dword 0xd2e4e5b7e3218108, 0x7a159cc147dff576
d_3_4:          .dword 0x0b1f1a5122e5ef25, 0xda3f9d9c803f4622
d_3_5:          .dword 0xe751c9fa03370b1b, 0x9459f585271494e4
d_3_6:          .dword 0xc9d37f854092f781, 0x7ea7e18ba48abb43
d_3_7:          .dword 0x2eb7673881120f10, 0x13f28f3c4c5e82ec
d_3_8:          .dword 0xe2430ab91647cea7, 0x00258993b015b595
d_3_9:          .dword 0xd02b1a2a700eaf5c, 0xaccfef87d5e2a256
d_3_10:         .dword 0x8df3cff34ce52d2e, 0x47e5c456b1ef426d
d_3_11:         .dword 0x6cc13628fd567d49, 0x95d5fc2ce820a3ea
d_3_12:         .dword 0x8a42d628ad4ef29a, 0x748f02543bb7096d
d_3_13:         .dword 0xd8252a67332bd330, 0x4577b896d4b28a1a
d_3_14:         .dword 0xcae111d32441000f, 0x73121651618f789c
d_3_15:         .dword 0xb06948b87c0a4b29, 0x2f7b86313edc0356
d_3_16:         .dword 0x47a6d849ff571a0b, 0xed71fddd2bbb904d
d_3_17:         .dword 0x11266a52614c0350, 0x42dc6784b75f94c3
d_3_18:         .dword 0x347009da86a17c3f, 0x7d587f162025a854
d_3_19:         .dword 0x7e667f433d069f72, 0x4a11b557a7585c00
d_3_20:         .dword 0x6f89ee448b18c50a, 0xfd91844574f4872d
d_3_21:         .dword 0x84d410a08e742a19, 0xb2c302979ce038df
d_3_22:         .dword 0x0ddc2c3a26e85bbc, 0xda9114a231ad7d54
d_3_23:         .dword 0x91bc5bb0a1179981, 0x384c26b1e041544b
d_3_24:         .dword 0xa1fa5941426218ac, 0xef407fcfc94740e2
d_3_25:         .dword 0xd1aa2aa71a3a15f3, 0x59c0055fbacaf568
d_3_26:         .dword 0x0d8fc62eb07c5654, 0x6bf27f7ea1c26686
d_3_27:         .dword 0x63af9c7b4dc441e5, 0xfead3986d529f606
                .dword 0x71e8d7cd7f5461ae, 0x92045d16863c6ff7
                .dword 0x7025832091928051, 0x356536106cc290e9
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x646bcba59eb059aa, 0x4f7e551230aaaee9
                .dword 0xca8e585b268149dc, 0x248f120c8f6ceb39
d_4_0:          .dword 0x17fd3d893e73f0ca, 0x6d54f75e9f2a0c68
d_4_1:          .dword 0x85b466fcacd64bf1, 0x951f0fbacdf9abb6
d_4_2:          .dword 0xb7aabc70741468fb, 0xfcae998732b971d1
d_4_3:          .dword 0x38a7c00b65918681, 0x4136c1b4254c89c7
d_4_4:          .dword 0xb62274dcd878c35c, 0x3f60b288a99e56ef
d_4_5:          .dword 0x3b56446984ed5412, 0x5fdee340da72e767
d_4_6:          .dword 0xc99294f2109dd381, 0xe0d506612002e061
d_4_7:          .dword 0x6839507120538a35, 0x8fc7c7a59d451794
d_4_8:          .dword 0x003d96540fe6ce9f, 0xa784e01e648b0303
d_4_9:          .dword 0x6170992dd439fbcd, 0x5e1d0de88bc6cc6d
d_4_10:         .dword 0xd7fbc461a315cce5, 0x08011b293eac9b3b
d_4_11:         .dword 0x5d072a38bb2e2ec6, 0xc2354e900d2fd8a7
d_4_12:         .dword 0xe4a33d8e67d91d48, 0x1cc88d2e204a632d
d_4_13:         .dword 0xf1eef1a2fa2e1022, 0xe5c30e35e34bbee4
d_4_14:         .dword 0x88d410123253b1f0, 0x49aeea2fa70a19c5
d_4_15:         .dword 0xf0bb16749c487efb, 0x7a91bebec5d89043
d_4_16:         .dword 0xeb7ede369462ce97, 0x04f0e44eaeb20eb1
d_4_17:         .dword 0xb6dbedd2bb136576, 0x5cf3f69dd3547f1f
d_4_18:         .dword 0x75cd2eb0d4fbc60e, 0xbb3dd06b7af464f7
d_4_19:         .dword 0x057728ee2c10e5ae, 0x3274172a3d9959f6
d_4_20:         .dword 0x5b093a3452ed68ed, 0x0128a7a3481f74b7
d_4_21:         .dword 0x20c1ce723db1170f, 0x8f029b783818f2b0
d_4_22:         .dword 0x8a91657f0d2e5287, 0x6e8ac158a134d292
d_4_23:         .dword 0x744695656fde1490, 0xbe2e9e718578d479
d_4_24:         .dword 0xe64fa4f3526f090a, 0xa8469fc2b85eaec3
d_4_25:         .dword 0x76a6a62959e5c0e9, 0x47730505e177543d
d_4_26:         .dword 0x0d7981724dbe7574, 0xd4f7816632e03175
d_4_27:         .dword 0x44521615ff524922, 0xd2f7279b02cc80e3
                .dword 0x6928206ff825be3d, 0xa2485e4ed55a61da
                .dword 0x1b0443595204669c, 0x632c5ee12ddd02d0
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x08c8643efacb4db7, 0xbb8774643283e173
                .dword 0x7910bbe348714d43, 0x1bdfcd3786f4450e
d_5_0:          .dword 0x796b0b447d5ae5a6, 0x43410533b230826e
d_5_1:          .dword 0xdd7102ab237b13ab, 0xe3f112f67f596153
d_5_2:          .dword 0x887bc3c4fc2bc82e, 0x5ee03f8b2022ee17
d_5_3:          .dword 0xa61f8eb45eafc7ae, 0xbecd81c80d3cf74b
d_5_4:          .dword 0x23281ff783f39b88, 0x1a49843f25fd346d
d_5_5:          .dword 0xc408348a2e9859b6, 0x4a1ac200213894d0
d_5_6:          .dword 0x1680605d490644de, 0x6a939923d0def969
d_5_7:          .dword 0x9906a3c4efab4e07, 0x98b2cc22955cca2a
d_5_8:          .dword 0x0943daa8b543f028, 0x1a56b1caffb45a71
d_5_9:          .dword 0xf3bf45b6185e1efe, 0xa9e72e11439eaceb
d_5_10:         .dword 0x80c84abef650d591, 0xb100c485497ba046
d_5_11:         .dword 0x40d814b2a8ce294c, 0x1721019952a67474
d_5_12:         .dword 0xa2f7d9c7c6eb644e, 0x4588c1fbac7dd8aa
d_5_13:         .dword 0xc7b3d185e84ce397, 0x42a88cff058a797c
d_5_14:         .dword 0xf34f6de0a0fdff65, 0x6a801afd88335f39
d_5_15:         .dword 0xc6cf39374f33b982, 0x5bd29530bccb6d97
d_5_16:         .dword 0x4313c9b73792257c, 0x7f5087cbcb51b3b7
d_5_17:         .dword 0xc442331550a65116, 0xb70efca05ff1bb27
d_5_18:         .dword 0x9112b5185f1f1fef, 0xf8fc6a63c20cb1bf
d_5_19:         .dword 0x8c50172409dd7fc2, 0x8284a389c9669215
d_5_20:         .dword 0xf93c3ee48c35e6a2, 0x349197c5ab81e55b
d_5_21:         .dword 0xefba2b106982dfe0, 0xe8e8a04d39aaafba
d_5_22:         .dword 0xadc8d15677cd72f3, 0xe432928fd250494b
d_5_23:         .dword 0x51d56dc92fe9c50a, 0x0f87c217fdf6e0a7
d_5_24:         .dword 0x5887d88698518c83, 0x816cafe239230985
d_5_25:         .dword 0x0d25cf624854cf46, 0x3dff399f0d981450
d_5_26:         .dword 0x983a775b0a91cbba, 0x5fe2814935b8ccc7
d_5_27:         .dword 0x72dea31a1c085992, 0x4f7bfe45e36b3926
                .dword 0x02182e1a6b00fe8a, 0x64e68116ac949f6e
                .dword 0x21223ee8d863590e, 0xaf56c130bcdf4f13
         /* Random data */
_end_data5:
              
                 
