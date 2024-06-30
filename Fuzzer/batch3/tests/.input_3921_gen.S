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
_s1:    srli x30, x11, 27                         ;
_s2:    la x14, d_0_8                             ;
        addi x14, x14, -24                        ;
        amoand.d x8, x27, (x14)                   ;
_s3:    la x27, d_0_27                            ;
        addi x27, x27, -12                        ;
        amoor.w x29, x21, (x27)                   ;
_s4:    feq.s x3, f29, f3                         ;
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
_p0:    csrrsi x12, pmpaddr6, 31                  ;
_p1:    xor x14, x14, x14                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 14                         ;
        add x14, x14, x14                         ;
        csrrs x11, mscratch, x14                  ;
_p2:    xor x14, x14, x14                         ;
        csrrs x10, medeleg, x14                   ;
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
_l0:    jal x15, _l69                             ;
_l1:    la x24, d_1_14                            ;
        fsw f7, -12(x24)                          ;
_l2:    fmin.s f9, f5, f14                        ;
_l3:    xor x12, x12, x12                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 30                         ;
        add x12, x12, x30                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 19                         ;
        add x12, x12, x12                         ;
        csrrw x28, sip, x12                       ;
_l4:    remw x17, x24, x21                        ;
_l5:    blt x21, x17, _l179                       ;
_l6:    la x27, d_0_9                             ;
        lbu x16, -17(x27)                         ;
_l7:    flt.s x7, f11, f18                        ;
_l8:    remuw x26, x24, x20                       ;
_l9:    bge x13, x14, _l66                        ;
_l10:   sltiu x15, x29, 159                       ;
_l11:   sraw x17, x2, x24                         ;
_l12:   bge x19, x13, _l184                       ;
_l13:   la x19, d_1_9                             ;
        addi x19, x19, 0                          ;
        amomax.d x13, x23, (x19)                  ;
_l14:   mulw x13, x0, x3                          ;
_l15:   la x13, _l181                             ;
        jalr x15, 0(x13)                          ;
_l16:   la x10, d_4_27                            ;
        addi x10, x10, -16                        ;
        amoadd.d x24, x4, (x10)                   ;
_l17:   la x13, _l85                              ;
        csrrw zero, mepc, x13                     ;
        mret                                      ;
_l18:   la x10, d_5_4                             ;
        lw x23, 16(x10)                           ;
_l19:   la x30, d_3_10                            ;
        sh x1, 20(x30)                            ;
_l20:   mul x15, x20, x27                         ;
_l21:   la x24, d_5_7                             ;
        addi x24, x24, 20                         ;
        amomin.w x26, x16, (x24)                  ;
_l22:   la x21, _l42                              ;
        lh x6, -28(x21)                           ;
_l23:   fclass.s x20, f18                         ;
_l24:   xori x8, x4, 2047                         ;
_l25:   la x14, d_5_10                            ;
        addi x14, x14, -28                        ;
        amominu.w x13, x20, (x14)                 ;
_l26:   la x24, d_3_2                             ;
        addi x24, x24, -16                        ;
        amoswap.d x21, x2, (x24)                  ;
_l27:   la x28, d_0_19                            ;
        addi x28, x28, 28                         ;
        amoadd.w x5, x29, (x28)                   ;
_l28:   la x7, d_2_3                              ;
        addi x7, x7, 16                           ;
        sc.d x10, x7, (x7)                        ;
_l29:   la x23, d_4_18                            ;
        sb x3, -19(x23)                           ;
_l30:   fcvt.s.l f27, x29, rdn                    ;
_l31:   la x26, d_2_24                            ;
        addi x26, x26, 20                         ;
        amomax.w x15, x4, (x26)                   ;
_l32:   la x16, d_2_14                            ;
        addi x16, x16, -20                        ;
        lui x14, 0xffe00                          ;
        xor x16, x16, x14                         ;
        amomax.w x17, x14, (x16)                  ;
_l33:   la x19, d_5_1                             ;
        lhu x12, -16(x19)                         ;
_l34:   fmin.s f15, f7, f14                       ;
_l35:   addi x18, x13, 2047                       ;
_l36:   la x7, d_0_25                             ;
        srai x7, x7, 1                            ;
        csrrw x26, pmpaddr1, x7                   ;
_l37:   addiw x14, x29, -1605                     ;
_l38:   la x26, d_3_25                            ;
        addi x26, x26, 0                          ;
        amomax.d x21, x21, (x26)                  ;
_l39:   xori x29, x7, 2047                        ;
_l40:   xori x20, x0, -892                        ;
_l41:   fmul.s f22, f8, f31, rne                  ;
_l42:   la x3, d_3_23                             ;
        addi x3, x3, 20                           ;
        amomax.w x11, x1, (x3)                    ;
_l43:   la x28, d_2_8                             ;
        addi x28, x28, 0                          ;
        amominu.d x23, x10, (x28)                 ;
_l44:   beq x23, x19, _l142                       ;
_l45:   fcvt.w.s x11, f5, rtz                     ;
_l46:   fsgnjx.s f24, f18, f23                    ;
_l47:   slliw x10, x19, 0                         ;
_l48:   fle.s x4, f16, f29                        ;
_l49:   la x16, d_5_13                            ;
        addi x16, x16, 4                          ;
        amoxor.w x30, x7, (x16)                   ;
_l50:   divw x1, x18, x12                         ;
_l51:   la x13, d_5_20                            ;
        lui x18, 0xffe00                          ;
        xor x13, x13, x18                         ;
        sw x10, -20(x13)                          ;
_l52:   la x26, d_0_9                             ;
        addi x26, x26, 8                          ;
        lui x2, 0xffe00                           ;
        xor x26, x26, x2                          ;
        amoswap.d x3, x2, (x26)                   ;
_l53:   la x9, _l197                              ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l54:   addiw x23, x25, -568                      ;
_l55:   beq x25, x12, _l64                        ;
_l56:   la x27, d_3_12                            ;
        srai x27, x27, 1                          ;
        csrrw x13, pmpaddr5, x27                  ;
_l57:   fcvt.s.lu f19, x5, rne                    ;
_l58:   la x3, d_2_0                              ;
        sd x27, -16(x3)                           ;
_l59:   bne x7, x3, _l177                         ;
_l60:   addi x13, x1, -837                        ;
_l61:   beq x6, x14, _l83                         ;
_l62:   mul x18, x7, x23                          ;
_l63:   remuw x16, x28, x16                       ;
_l64:   feq.s x23, f30, f24                       ;
_l65:   fsgnjn.s f19, f26, f8                     ;
_l66:   fence.i                                   ;
_l67:   la x19, d_4_1                             ;
        ld x28, -24(x19)                          ;
_l68:   fence                                     ;
_l69:   la x4, d_2_6                              ;
        lwu x17, -20(x4)                          ;
_l70:   la x11, d_0_24                            ;
        addi x11, x11, 0                          ;
        amoor.w x17, x12, (x11)                   ;
_l71:   la x29, d_2_25                            ;
        addi x29, x29, -24                        ;
        amominu.w x26, x28, (x29)                 ;
_l72:   la x2, _l170                              ;
        csrrw zero, sepc, x2                      ;
        sret                                      ;
_l73:   beq x30, x14, _l153                       ;
_l74:   bge x6, x11, _l84                         ;
_l75:   remu x13, x9, x3                          ;
_l76:   xori x18, x25, 0                          ;
_l77:   fcvt.s.l f10, x1, rdn                     ;
_l78:   la x9, d_5_16                             ;
        lb x8, -2(x9)                             ;
_l79:   la x4, _l114                              ;
        csrrw zero, sepc, x4                      ;
        sret                                      ;
_l80:   la x3, d_0_16                             ;
        addi x3, x3, 0                            ;
        lui x10, 0xffe00                          ;
        xor x3, x3, x10                           ;
        amomax.d x23, x10, (x3)                   ;
_l81:   addiw x11, x6, -186                       ;
_l82:   la x12, d_4_2                             ;
        sh x18, 0(x12)                            ;
_l83:   la x7, d_2_18                             ;
        lw x13, 28(x7)                            ;
_l84:   feq.s x12, f23, f19                       ;
_l85:   fmv.x.w x12, f1                           ;
_l86:   andi x14, x26, -1758                      ;
_l87:   la x15, _l156                             ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l88:   fence                                     ;
_l89:   divu x5, x30, x12                         ;
_l90:   la x13, _l138                             ;
        csrrw zero, uepc, x13                     ;
        uret                                      ;
_l91:   sraiw x0, x0, 8                           ;
_l92:   divuw x14, x8, x14                        ;
_l93:   la x28, d_3_22                            ;
        sb x4, 20(x28)                            ;
_l94:   mulhu x14, x29, x30                       ;
_l95:   remu x10, x14, x18                        ;
_l96:   beq x9, x28, _l132                        ;
_l97:   la x10, d_3_11                            ;
        lbu x9, -5(x10)                           ;
_l98:   fmadd.s f20, f6, f6, f8, rup              ;
_l99:   la x27, d_2_7                             ;
        addi x27, x27, -24                        ;
        amominu.d x26, x13, (x27)                 ;
_l100:  rem x0, x20, x26                          ;
_l101:  mulhu x28, x8, x19                        ;
_l102:  la x21, d_3_1                             ;
        lhu x13, -0(x21)                          ;
_l103:  srai x22, x23, 63                         ;
_l104:  mulhsu x20, x27, x19                      ;
_l105:  fence.i                                   ;
_l106:  la x19, d_1_18                            ;
        sw x21, 28(x19)                           ;
_l107:  flt.s x22, f27, f9                        ;
_l108:  mulh x16, x8, x10                         ;
_l109:  andi x14, x21, -0                         ;
_l110:  la x3, d_5_21                             ;
        addi x3, x3, -0                           ;
        amomin.d x20, x22, (x3)                   ;
_l111:  la x25, d_1_11                            ;
        addi x25, x25, 8                          ;
        amoor.d x26, x3, (x25)                    ;
_l112:  sraiw x11, x19, 4                         ;
_l113:  la x16, d_0_24                            ;
        addi x16, x16, 20                         ;
        sc.w x16, x21, (x16)                      ;
_l114:  la x5, d_4_1                              ;
        lwu x1, 20(x5)                            ;
_l115:  la x24, d_1_21                            ;
        addi x24, x24, 28                         ;
        amomin.w x15, x28, (x24)                  ;
_l116:  jal x25, _l171                            ;
_l117:  ecall                                     ;
_l118:  la x19, d_5_23                            ;
        addi x19, x19, -12                        ;
        amomax.w x2, x29, (x19)                   ;
_l119:  fsgnj.s f9, f6, f10                       ;
_l120:  fmsub.s f2, f18, f30, f16, rne            ;
_l121:  sraiw x3, x14, 26                         ;
_l122:  xor x12, x12, x12                         ;
        addi x15, zero, 1                         ;
        slli x15, x15, 10                         ;
        add x12, x12, x15                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 5                            ;
        add x12, x12, x2                          ;
        addi x2, zero, 1                          ;
        slli x2, x2, 10                           ;
        add x12, x12, x2                          ;
        csrrc x19, medeleg, x12                   ;
_l123:  mulh x23, x6, x22                         ;
_l124:  fcvt.w.s x13, f3, rne                     ;
_l125:  la x5, d_4_4                              ;
        addi x5, x5, -0                           ;
        amoor.w x26, x10, (x5)                    ;
_l126:  andi x8, x8, -29                          ;
_l127:  la x8, _l184                              ;
        csrrw zero, mepc, x8                      ;
        mret                                      ;
_l128:  remuw x8, x1, x22                         ;
_l129:  csrrsi x7, pmpaddr1, 27                   ;
_l130:  mulw x2, x15, x17                         ;
_l131:  auipc x24, 358813                         ;
_l132:  mulhsu x9, x2, x26                        ;
_l133:  la x17, _l154                             ;
        csrrw zero, mepc, x17                     ;
        mret                                      ;
_l134:  la x29, d_3_21                            ;
        sw x29, 28(x29)                           ;
_l135:  fcvt.l.s x11, f9, dyn                     ;
_l136:  bne x3, x15, _l168                        ;
_l137:  fcvt.l.s x13, f7, rtz                     ;
_l138:  remw x18, x12, x26                        ;
_l139:  la x13, d_4_23                            ;
        addi x13, x13, 8                          ;
        amoor.d x29, x29, (x13)                   ;
_l140:  la x10, d_0_9                             ;
        addi x10, x10, 16                         ;
        amoxor.w x29, x10, (x10)                  ;
_l141:  la x23, d_4_16                            ;
        addi x23, x23, -8                         ;
        lr.d x9, (x23)                            ;
_l142:  divuw x1, x28, x16                        ;
_l143:  fmsub.s f16, f10, f25, f30, rmm           ;
_l144:  div x17, x26, x17                         ;
_l145:  fnmadd.s f18, f29, f7, f29, rne           ;
_l146:  la x7, d_2_9                              ;
        addi x7, x7, -20                          ;
        amoxor.w x9, x29, (x7)                    ;
_l147:  la x28, d_3_24                            ;
        addi x28, x28, -24                        ;
        amoand.w x6, x12, (x28)                   ;
_l148:  la x16, d_3_18                            ;
        lbu x4, 12(x16)                           ;
_l149:  li x26, 0                                 ;
        la x27, pt1                               ;
        addi x27, x27, 32                         ;
        sfence.vma x26, x27                       ;
_l150:  divw x10, x21, x12                        ;
_l151:  la x13, d_1_16                            ;
        addi x13, x13, -16                        ;
        amomin.d x29, x18, (x13)                  ;
_l152:  la x7, d_4_18                             ;
        lhu x5, -0(x7)                            ;
_l153:  la x25, d_2_22                            ;
        lui x2, 0xffe00                           ;
        xor x25, x25, x2                          ;
        sd x26, 16(x25)                           ;
_l154:  la x29, _l181                             ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l155:  mulhsu x24, x0, x8                        ;
_l156:  subw x28, x10, x8                         ;
_l157:  blt x2, x5, _l185                         ;
_l158:  la x19, d_4_2                             ;
        addi x19, x19, -12                        ;
        amoand.w x25, x14, (x19)                  ;
_l159:  div x3, x9, x11                           ;
_l160:  la x3, _l192                              ;
        csrrw zero, mepc, x3                      ;
        mret                                      ;
_l161:  la x1, _l87                               ;
        srai x1, x1, 1                            ;
        csrrs x16, pmpaddr6, x1                   ;
_l162:  la x11, d_5_9                             ;
        addi x11, x11, -20                        ;
        amoand.w x28, x21, (x11)                  ;
_l163:  bltu x29, x9, _l174                       ;
_l164:  fnmadd.s f6, f10, f9, f14, dyn            ;
_l165:  la x4, d_0_24                             ;
        addi x4, x4, -16                          ;
        amoadd.d x14, x29, (x4)                   ;
_l166:  la x24, d_0_1                             ;
        addi x24, x24, -24                        ;
        amoor.d x12, x9, (x24)                    ;
_l167:  bne x22, x16, _l190                       ;
_l168:  la x19, d_5_22                            ;
        addi x19, x19, -8                         ;
        amoadd.w x9, x29, (x19)                   ;
_l169:  andi x23, x19, 1276                       ;
_l170:  sltiu x3, x0, -1924                       ;
_l171:  la x13, d_5_25                            ;
        addi x13, x13, -16                        ;
        amoor.w x5, x16, (x13)                    ;
_l172:  la x8, d_4_13                             ;
        addi x8, x8, -16                          ;
        amoor.d x24, x3, (x8)                     ;
_l173:  fsgnjx.s f10, f9, f7                      ;
_l174:  ebreak                                    ;
_l175:  la x12, d_5_27                            ;
        lb x8, 4(x12)                             ;
_l176:  la x21, d_0_27                            ;
        addi x21, x21, -16                        ;
        lui x2, 0xffe00                           ;
        xor x21, x21, x2                          ;
        lr.d x27, (x21)                           ;
_l177:  la x30, d_2_23                            ;
        sh x30, -6(x30)                           ;
_l178:  fmv.x.w x6, f24                           ;
_l179:  remu x27, x25, x6                         ;
_l180:  fcvt.l.s x4, f22, dyn                     ;
_l181:  bne x22, x29, _l189                       ;
_l182:  la x8, d_3_8                              ;
        addi x8, x8, -8                           ;
        lr.d x1, (x8)                             ;
_l183:  la x10, d_0_14                            ;
        addi x10, x10, 8                          ;
        amominu.d x22, x3, (x10)                  ;
_l184:  fnmadd.s f15, f20, f19, f10, dyn          ;
_l185:  sllw x7, x21, x18                         ;
_l186:  fle.s x11, f10, f6                        ;
_l187:  jal x28, _l197                            ;
_l188:  la x17, d_0_9                             ;
        sb x22, -1(x17)                           ;
_l189:  fcvt.s.l f7, x24, rmm                     ;
_l190:  xori x1, x27, 1276                        ;
_l191:  fcvt.l.s x7, f1, rup                      ;
_l192:  lui x20, 338754                           ;
_l193:  srai x24, x30, 32                         ;
_l194:  li x6, 1                                  ;
        la x9, pt0                                ;
        addi x9, x9, 48                           ;
        sfence.vma x6, x9                         ;
_l195:  la x12, d_5_13                            ;
        addi x12, x12, 8                          ;
        lui x11, 0xffe00                          ;
        xor x12, x12, x11                         ;
        lr.d x12, (x12)                           ;
_l196:  remu x24, x8, x4                          ;
_l197:  div x25, x13, x6                          ;
_l198:  slti x9, x18, -11                         ;
_l199:  feq.s x15, f19, f24                       ;
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
                .dword 0x4837b88351da094c, 0x3a672009e86c199d
                .dword 0xb4d0a451ba4f8fe7, 0xabbfbeb38650bafd
d_0_0:          .dword 0x61b1864677b26f93, 0x416bdd8b14ae4aae
d_0_1:          .dword 0xaa565e24e0de1444, 0x38c4f96a611de257
d_0_2:          .dword 0x9a380ff85a61eb34, 0x8ba93065ce37e546
d_0_3:          .dword 0x9318d6249a8232ee, 0xceaf5ed0bcfa87bc
d_0_4:          .dword 0xc17524f35e18ed20, 0x61b684945ed041c8
d_0_5:          .dword 0x2a35e9341cd218b6, 0x08309c06e420c64c
d_0_6:          .dword 0x0747910151dc369c, 0x4ac3a1cc7953f248
d_0_7:          .dword 0x86665d614e5c5804, 0xaa076558c8fb3bff
d_0_8:          .dword 0x3b51d34f59a0c0fe, 0xe44a8bca17dce8ea
d_0_9:          .dword 0x77013c50848c9afd, 0xeb767f0bf8426fbe
d_0_10:         .dword 0xbe343fae20b5f3bc, 0xfb7a3ff242692132
d_0_11:         .dword 0xf71ea850928fb07b, 0x010d43f56c1f74e1
d_0_12:         .dword 0x8d9b2bc4beec571f, 0x806d623324ef0062
d_0_13:         .dword 0x59d3f31edf82a20c, 0xff5446926f38208c
d_0_14:         .dword 0x952938cefd193127, 0x12a82e0de76e4e30
d_0_15:         .dword 0xad46e5108e7f1ef8, 0x2aaf836b343d83f6
d_0_16:         .dword 0x7194b2734cf8c34a, 0xd1ed0854279d133a
d_0_17:         .dword 0x9164f33b1c1e00e0, 0xc2b969f7427e3fa3
d_0_18:         .dword 0x26bf5564a847d5c9, 0x45c5162df8fe8d85
d_0_19:         .dword 0xd806902e31c30812, 0x792f48710551ec6f
d_0_20:         .dword 0x0659839ec8d960df, 0xa50ede23c9d29da0
d_0_21:         .dword 0x0b0c57a0d509be9e, 0x6cee699605691303
d_0_22:         .dword 0xfcb947a9d26100f6, 0x87a3627485167a21
d_0_23:         .dword 0x1b62b1e1774165e2, 0xd2c2e41277b354ad
d_0_24:         .dword 0xa83a3bc33e18b2a4, 0x8f6cfc09b21290a9
d_0_25:         .dword 0x8d3a1b337fecf352, 0x6fbb8f55250b92d7
d_0_26:         .dword 0x8b6f1084382e71bf, 0xde251f3dfe3493f2
d_0_27:         .dword 0x28c3bce7dc204229, 0x589863458a9c59ef
                .dword 0x61d76e37d271c69f, 0x047a13e3a550f9f3
                .dword 0xfe662c02503d7928, 0x6ca038f23f4e9e53
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xfb5d12d36c50dd48, 0x464c3a2f5a4735bd
                .dword 0x11d921529a052f70, 0x5c9c11415eed2c28
d_1_0:          .dword 0xe8b7b98d6b1e58c3, 0xf0178bac63df89a3
d_1_1:          .dword 0xdeef8baedb4f8b1c, 0xa5846539f772e102
d_1_2:          .dword 0xe77ca77baaf1739d, 0x2ae4b17ee8e9b86e
d_1_3:          .dword 0xd72983daf0372b6f, 0x391c859b2affe9e3
d_1_4:          .dword 0x6d21b8714fe722ea, 0xab3e0f3e00ab6cf4
d_1_5:          .dword 0x6e9746912b2b5456, 0x984c1e891f373678
d_1_6:          .dword 0xb8e5cf76af6280c5, 0x33a48482bdc239c1
d_1_7:          .dword 0x94585ab2833cc772, 0x3ccb33acd5b3a3d8
d_1_8:          .dword 0x2f113df0edad194c, 0x791078893ad19fe7
d_1_9:          .dword 0xfc3170da928d0803, 0x7c5e9d0a45334dd8
d_1_10:         .dword 0xdb616083ad8ef746, 0xb571f3570896476c
d_1_11:         .dword 0x7ec48cb2a8116f74, 0xcd07430758cf594e
d_1_12:         .dword 0x3f210fffbfee9c2c, 0x9043ad838aae6e1e
d_1_13:         .dword 0x5d189d0bf03d9a8d, 0x763c1c166d4a36ab
d_1_14:         .dword 0xc571211b0e228954, 0xe0c5b28c69911be0
d_1_15:         .dword 0x52c6687ccd6bf9bb, 0x3f6fc5d60926fed1
d_1_16:         .dword 0x0910f0f0d15a9e46, 0x01296ff68088971b
d_1_17:         .dword 0x20fb6528d8021952, 0xe1747a7178c35d15
d_1_18:         .dword 0x6081093ca5c9f1c0, 0xf4e44fd6788082c1
d_1_19:         .dword 0x910fa501c0d75afc, 0xf1b9e565718f32a0
d_1_20:         .dword 0xe4a695a1ace6834b, 0xc364eb4f612d365a
d_1_21:         .dword 0x347e97d833b80e38, 0x42f41f9c7a592dd6
d_1_22:         .dword 0xf3808ae4e721b9f4, 0x86c6cc1d4039eede
d_1_23:         .dword 0xb82fdb71ed8d7ac2, 0x9e00922109ea0294
d_1_24:         .dword 0xc3278a257af4bc39, 0x01469b08c2da3a82
d_1_25:         .dword 0x7e8ea0add673f16e, 0x33eb6d0614d70364
d_1_26:         .dword 0x9a4db7c773b4755f, 0xecf4fe03440acc2c
d_1_27:         .dword 0x97f7b13c7866cd6f, 0x2924cf8730c59af7
                .dword 0xdd279dd3a4b47838, 0xdfcdc40e8745d202
                .dword 0x00fe5e24c22add18, 0x1b5a2a2b3608d8f4
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8313c4e2bbb48d2e, 0xb26dd75b87d26320
                .dword 0x0701f56fb9128ec8, 0xb527b9cb585cf092
d_2_0:          .dword 0x9d27ab66da0cd5e9, 0x4523c682d3ef9766
d_2_1:          .dword 0xded547a4074cf725, 0x6b9c1770514fa380
d_2_2:          .dword 0x1c38c35884005c66, 0x876e976b2fd9d26b
d_2_3:          .dword 0x240d49464f7c6cd3, 0x8c1590d444aac18e
d_2_4:          .dword 0x054c8063323dab37, 0x1e9853f2167c529e
d_2_5:          .dword 0xbbcc60b78522543e, 0x1b2863d784738ff1
d_2_6:          .dword 0xc822525bc54e1893, 0xdff79ebaec81e651
d_2_7:          .dword 0x8496adb9e05c019d, 0xc8b582d7a9f7e5a6
d_2_8:          .dword 0x8b3b0c8048d3e895, 0xedcd4e0d74eaa3f9
d_2_9:          .dword 0x3b11ffd7e948bdb3, 0x029eba047e49b19f
d_2_10:         .dword 0x65523a1acf76b6bb, 0x80356cdf1a5f3ecd
d_2_11:         .dword 0x8d0dd41af5931474, 0xead435dc4415f3ae
d_2_12:         .dword 0xb486e8780495390b, 0xf54a43acaafb819e
d_2_13:         .dword 0x5691e16c5723eb6b, 0xacd8adbfc9753582
d_2_14:         .dword 0x0ae2aade148bd150, 0xf7b2a8158fdf008e
d_2_15:         .dword 0x388f29deb9eb57f0, 0x7ea99b6232f478ec
d_2_16:         .dword 0x11ff839af4c3c3e0, 0x4ba9552262d0bd3d
d_2_17:         .dword 0xc4ddbbd57ca04b2a, 0x91520517df4aba16
d_2_18:         .dword 0xf7dc0b9c3305c9a4, 0x6498c45347a928ff
d_2_19:         .dword 0x50ad30da84badb09, 0x4a0d3d20f9ab66f1
d_2_20:         .dword 0x465ceae46ed331c1, 0xe3503ffcacb2a3a2
d_2_21:         .dword 0x6eb3a5012f1f95c4, 0x72a77a7be3148a66
d_2_22:         .dword 0xbea1ecb3fb566a61, 0xf0d8ea4a728e723d
d_2_23:         .dword 0xa50a4b634e7621b6, 0x92ed215329a1521f
d_2_24:         .dword 0xb35095dc13aa2c4c, 0x26a54332cd864b1e
d_2_25:         .dword 0x700e699d01983852, 0x4d83bf1262b7b85f
d_2_26:         .dword 0x89d2e27aa740fccb, 0x2d76c30c199354df
d_2_27:         .dword 0xf13034ad664e26b3, 0x71e93b78f4f2bdbd
                .dword 0xf1fc4ca06dbe2680, 0x759068939edd9864
                .dword 0x63f5f6a40017b0cc, 0x2d797b065fd57745
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x5e07f8b8a77a60c4, 0x3660969a8a8d748e
                .dword 0x751ae95427e2cbfd, 0x2bc0ddbf2dbc614a
d_3_0:          .dword 0x27e0499a9ebcedc5, 0x0f51a6f0f748c3f9
d_3_1:          .dword 0xf789366cf7be1210, 0x3fd6edb0054b1086
d_3_2:          .dword 0x683c91ac14825946, 0xaa06e98ab7c01783
d_3_3:          .dword 0xa64b8e63006465b3, 0x6e0b003cf3afe043
d_3_4:          .dword 0x7de8d7c20e6005b4, 0xb00beac006c9d56b
d_3_5:          .dword 0xbb9c642a00379704, 0xb68c4393007a5d7e
d_3_6:          .dword 0x366a2c90b1b83844, 0x6d44d1143e11e513
d_3_7:          .dword 0x0be63b509c9ca519, 0x56e7737adf94afeb
d_3_8:          .dword 0x1b0ae551f7f6037f, 0xc37eec417f1aa0b7
d_3_9:          .dword 0x08e9dc2068a66dab, 0x0cd6268e3e8bb140
d_3_10:         .dword 0xf2ba6992db3f2443, 0xb990fa7b542deb26
d_3_11:         .dword 0x81925f7a94a7f9df, 0xd91e0bf121e9033a
d_3_12:         .dword 0x50cc44336773f77f, 0x25a608e41eb67b43
d_3_13:         .dword 0x40992d208bbdeb27, 0x98bc1ede9bd159ba
d_3_14:         .dword 0xb2012726d5b2507f, 0x2f844169aa2c8987
d_3_15:         .dword 0xec80f194e17f4742, 0x702c5fd4f6ebbed9
d_3_16:         .dword 0xcd84720f91af3483, 0x6e4c58a9cef948ab
d_3_17:         .dword 0xb4fe400e3c712015, 0xeff5c2a94a3ed2c9
d_3_18:         .dword 0x9e8d5d2b4ca48900, 0x2db43a71542b8f11
d_3_19:         .dword 0x8ca0533b940e2249, 0xd543c3359a21fa94
d_3_20:         .dword 0xa9ca782e783814e1, 0x5fd1e5df5cdec117
d_3_21:         .dword 0xa74fc4c6f45a5632, 0xb57ee313c572e320
d_3_22:         .dword 0xafad69971c91da1e, 0x5ce148f3e078ad81
d_3_23:         .dword 0x1d067b33bf0fa812, 0x2d8f6721ea8fe7cc
d_3_24:         .dword 0xb2987cf2147269f7, 0xda6aefb431ae4a26
d_3_25:         .dword 0xefbb2ea171aa0572, 0x4fb2a9af9594938d
d_3_26:         .dword 0xdf1859f32c8a117c, 0x030b674840e07581
d_3_27:         .dword 0xa340cb2dbc98862d, 0x8af5978618b1664e
                .dword 0x3a32d546ac04137c, 0x85f13c18b726fc2c
                .dword 0x830752f234cebac8, 0xb44b7caa12e9a996
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5c0e39c872762dd6, 0x75d04e01c93194c2
                .dword 0x2cd32283fe707ac4, 0x55820e64eddb408d
d_4_0:          .dword 0x2fc123e1828350cb, 0x7216d45b9ab0e445
d_4_1:          .dword 0xfde500014aa4750a, 0x485cd2bda6d501da
d_4_2:          .dword 0x085818240d691498, 0x3e5d1589486e1db5
d_4_3:          .dword 0xe21d6468c1576f4b, 0xf2353b80b8553317
d_4_4:          .dword 0x81a89bf85cc43ab0, 0x30b461f95f1e1b1a
d_4_5:          .dword 0xfdaf148603912bb8, 0x771e1bbb00956bb9
d_4_6:          .dword 0xf459ff88b078f169, 0xa046b83feb379be7
d_4_7:          .dword 0xbb3eea7b0b93695c, 0x64e7eb762c2dba7c
d_4_8:          .dword 0xf6c6b2ee2b5b709d, 0x3a68804bc53c3e79
d_4_9:          .dword 0x46f36588ca94c3d1, 0x3db531182811c90c
d_4_10:         .dword 0x3b86549c822512ee, 0xc48c484509e42955
d_4_11:         .dword 0x37f064596d9cab0c, 0x9ba906919fd3f487
d_4_12:         .dword 0x48aaeb29fdae3fd2, 0x2c5db41600de538a
d_4_13:         .dword 0xfa766f3ea0aeabc5, 0x194540e1c2ab5839
d_4_14:         .dword 0x937dbcf9517fc7fa, 0xac7ae82b0e4e6ccd
d_4_15:         .dword 0xf8375f24c806489e, 0x96835946fd5d0210
d_4_16:         .dword 0x455e47c2dcae6c28, 0x542810b42e0348ff
d_4_17:         .dword 0x3092eb7203cdac3b, 0x27a7504df1715cb7
d_4_18:         .dword 0xc7911f2bc9607686, 0x2f4bd55cb32908e1
d_4_19:         .dword 0x1f973949dc7a641b, 0x6feeb4f3289cc016
d_4_20:         .dword 0xf740175087da85d8, 0xcb9bf092492a37c0
d_4_21:         .dword 0x7b197819400ae5da, 0x3f65e749ce35443e
d_4_22:         .dword 0x43ac34fcec4ec252, 0xe09fb79d7dcb2cae
d_4_23:         .dword 0x056b97c9300844a5, 0x711ae1beb64f6da8
d_4_24:         .dword 0x1e19ff7833918e01, 0xde33926e41fd0c93
d_4_25:         .dword 0x7891c6df014bbb59, 0x4df7729d7507f820
d_4_26:         .dword 0x08e99b5234c29a84, 0x926b9b7e115284a9
d_4_27:         .dword 0x7ce083628272f0b8, 0x6c9865c6a69d409e
                .dword 0x21fddce180902faa, 0x33cf463a43b9c075
                .dword 0xc973f99bafb1c338, 0xfef33e5d08304b37
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf990d78e51ff245f, 0x79ab67cc3cc0940e
                .dword 0x9164ac60494cd976, 0x322813e25bccff05
d_5_0:          .dword 0x8428124e4705fabc, 0x4d550833a1c07210
d_5_1:          .dword 0xc575779b8a00a033, 0xee975f643769cc53
d_5_2:          .dword 0x9a9a767011f9e130, 0xcd28c930e3b9bb0a
d_5_3:          .dword 0x1f69af4f4995c872, 0x4350136576e20fd2
d_5_4:          .dword 0xa6b0e4edbe64cac4, 0x3ef4bb2b455a60dc
d_5_5:          .dword 0x04d62fe2301a3d29, 0x1fe9918cbd17d516
d_5_6:          .dword 0xb1d225ad32275d69, 0x2b8ae3ad19b5aa51
d_5_7:          .dword 0xf65008200df7a223, 0xeb032dab81c7f00a
d_5_8:          .dword 0x4b41736a558f8c84, 0xddf3dc32c166b5ee
d_5_9:          .dword 0xd3bc91cbbe3094f1, 0x7a0e4a3806175fea
d_5_10:         .dword 0x6a53048ca58fce0b, 0x7d455ce5d467d5ac
d_5_11:         .dword 0x282326ca5b6cd466, 0xd185dbc2a7706168
d_5_12:         .dword 0xda5f22196677c92d, 0x9ffd131aa23656cc
d_5_13:         .dword 0xa6e446254ae10591, 0x62b58af9e31112ef
d_5_14:         .dword 0x3cc981e3cb408ec9, 0xeb66ef18fc62bc2a
d_5_15:         .dword 0xb3147b6e681a8050, 0x1eb5ce48f2babbb9
d_5_16:         .dword 0xde542058c7f8b553, 0x1e3a70691626cc72
d_5_17:         .dword 0x5dfd8002a3504d8a, 0x3cac6836cf24295d
d_5_18:         .dword 0xb69c3e3622fa07a5, 0x95adda161301a528
d_5_19:         .dword 0x1e6092282d7db64f, 0x1dd5b8f0225a03b2
d_5_20:         .dword 0xd1e3af43f2496ad7, 0x78c4fe56ff99756f
d_5_21:         .dword 0x136b8bfe9af10aa8, 0xd073207a22297bc6
d_5_22:         .dword 0x9dd690c49c42dcf3, 0x0596946247b270a3
d_5_23:         .dword 0x244cfa5262e05e43, 0xb0cff4a74269f594
d_5_24:         .dword 0xd39d5cd89e61d728, 0x18d5f4a7156d65c9
d_5_25:         .dword 0x2a7aa00e14f97e73, 0x7b6f2a3e16714ebc
d_5_26:         .dword 0xb94baf698d614ac6, 0xde5f51c83bdba7ab
d_5_27:         .dword 0x4677aba701b8117e, 0xf0581e58a4ae9132
                .dword 0x975b682db728c7f1, 0x89feb81d7a32ae8e
                .dword 0x40638464ffb057ff, 0xa37b9ef53296b0c7
         /* Random data */
_end_data5:
              
                 
