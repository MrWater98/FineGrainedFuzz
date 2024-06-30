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
_s0:    bltu x6, x30, _s3                         ;
_s1:    mulw x3, x11, x5                          ;
_s2:    xor x18, x18, x18                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 21                         ;
        add x18, x18, x27                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 2                          ;
        add x18, x18, x22                         ;
        csrrs x5, mtval, x18                      ;
_s3:    fcvt.s.wu f5, x2, rmm                     ;
_s4:    srai x24, x12, 27                         ;
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
_p0:    xor x14, x14, x14                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 18                         ;
        add x14, x14, x13                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 16                         ;
        add x14, x14, x14                         ;
        csrrs x11, sip, x14                       ;
_p1:    csrrsi x13, medeleg, 31                   ;
_p2:    xor x13, x13, x13                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 7                          ;
        add x13, x13, x13                         ;
        csrrc x11, stval, x13                     ;
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
_l0:    mulw x10, x4, x6                          ;
_l1:    la x4, d_5_7                              ;
        addi x4, x4, 24                           ;
        amoand.d x10, x19, (x4)                   ;
_l2:    rem x8, x13, x25                          ;
_l3:    flt.s x21, f22, f31                       ;
_l4:    ori x2, x14, 1029                         ;
_l5:    la x2, d_4_0                              ;
        sb x6, 5(x2)                              ;
_l6:    la x18, d_2_6                             ;
        lhu x17, 6(x18)                           ;
_l7:    fcvt.s.l f9, x15, dyn                     ;
_l8:    sllw x17, x2, x4                          ;
_l9:    la x22, d_1_11                            ;
        addi x22, x22, -0                         ;
        amomaxu.w x8, x20, (x22)                  ;
_l10:   la x20, d_5_1                             ;
        sw x2, -16(x20)                           ;
_l11:   fmv.x.w x1, f16                           ;
_l12:   fdiv.s f24, f24, f23, rup                 ;
_l13:   la x23, _l115                             ;
        lwu x20, 4(x23)                           ;
_l14:   fmsub.s f21, f30, f27, f17, rdn           ;
_l15:   fle.s x15, f17, f10                       ;
_l16:   andi x10, x14, 817                        ;
_l17:   la x13, d_5_9                             ;
        addi x13, x13, 16                         ;
        amoswap.w x27, x15, (x13)                 ;
_l18:   la x1, _l144                              ;
        jalr x27, 0(x1)                           ;
_l19:   srliw x28, x8, 18                         ;
_l20:   fmv.w.x f12, x23                          ;
_l21:   la x10, d_1_23                            ;
        addi x10, x10, 8                          ;
        lui x8, 0xffe00                           ;
        xor x10, x10, x8                          ;
        amominu.d x22, x8, (x10)                  ;
_l22:   csrrci x19, fflags, 31                    ;
_l23:   la x10, d_2_7                             ;
        addi x10, x10, -0                         ;
        lr.w x21, (x10)                           ;
_l24:   fcvt.w.s x25, f17, rne                    ;
_l25:   remw x27, x28, x11                        ;
_l26:   remw x29, x7, x24                         ;
_l27:   mulhu x0, x4, x18                         ;
_l28:   la x19, d_4_24                            ;
        addi x19, x19, -0                         ;
        amoadd.w x15, x25, (x19)                  ;
_l29:   xor x11, x11, x11                         ;
        addi x28, zero, 1                         ;
        slli x28, x28, 15                         ;
        add x11, x11, x28                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 17                         ;
        add x11, x11, x12                         ;
        csrrc x23, sstatus, x11                   ;
_l30:   remu x30, x25, x24                        ;
_l31:   fcvt.lu.s x6, f18, dyn                    ;
_l32:   divw x24, x19, x11                        ;
_l33:   fsgnjx.s f0, f19, f21                     ;
_l34:   bgeu x19, x25, _l158                      ;
_l35:   la x15, d_0_1                             ;
        addi x15, x15, 4                          ;
        amomin.w x21, x3, (x15)                   ;
_l36:   andi x19, x23, 266                        ;
_l37:   ori x18, x19, -817                        ;
_l38:   ebreak                                    ;
_l39:   csrrci x24, pmpcfg0, 28                   ;
_l40:   fsqrt.s f29, f26, dyn                     ;
_l41:   la x9, d_0_9                              ;
        ld x24, -24(x9)                           ;
_l42:   div x0, x16, x13                          ;
_l43:   fle.s x13, f22, f31                       ;
_l44:   fsub.s f28, f4, f2, rmm                   ;
_l45:   remuw x24, x0, x22                        ;
_l46:   srliw x20, x23, 19                        ;
_l47:   fmul.s f20, f1, f29, rne                  ;
_l48:   la x21, d_5_4                             ;
        addi x21, x21, 0                          ;
        sc.d x11, x21, (x21)                      ;
_l49:   fclass.s x24, f8                          ;
_l50:   fcvt.wu.s x12, f9, rne                    ;
_l51:   la x23, d_2_4                             ;
        addi x23, x23, 16                         ;
        amomaxu.d x6, x26, (x23)                  ;
_l52:   fclass.s x25, f31                         ;
_l53:   remuw x5, x30, x9                         ;
_l54:   la x16, d_1_8                             ;
        addi x16, x16, 16                         ;
        amominu.w x6, x28, (x16)                  ;
_l55:   beq x27, x5, _l144                        ;
_l56:   fsgnj.s f9, f24, f10                      ;
_l57:   remu x30, x29, x9                         ;
_l58:   la x30, d_5_17                            ;
        ld x29, 16(x30)                           ;
_l59:   xor x21, x21, x21                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 29                           ;
        add x21, x21, x7                          ;
        addi x25, zero, 3                         ;
        slli x25, x25, 21                         ;
        add x21, x21, x25                         ;
        addi x3, zero, 3                          ;
        slli x3, x3, 11                           ;
        add x21, x21, x3                          ;
        csrrc x14, mhartid, x21                   ;
_l60:   bltu x13, x7, _l160                       ;
_l61:   mulh x24, x9, x8                          ;
_l62:   fmin.s f11, f6, f18                       ;
_l63:   fmin.s f19, f29, f0                       ;
_l64:   la x20, _l170                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l65:   fclass.s x23, f20                         ;
_l66:   csrrwi x26, scause, 20                    ;
_l67:   ebreak                                    ;
_l68:   la x9, _l186                              ;
        csrrw zero, mepc, x9                      ;
        mret                                      ;
_l69:   fnmsub.s f1, f12, f20, f2, rdn            ;
_l70:   csrrsi x5, pmpaddr6, 16                   ;
_l71:   fcvt.lu.s x27, f22, rup                   ;
_l72:   bltu x20, x16, _l108                      ;
_l73:   la x30, d_5_14                            ;
        addi x30, x30, 20                         ;
        amomax.w x15, x30, (x30)                  ;
_l74:   la x14, d_1_13                            ;
        addi x14, x14, -0                         ;
        amoand.d x15, x15, (x14)                  ;
_l75:   la x23, d_4_21                            ;
        sb x6, 29(x23)                            ;
_l76:   fmv.w.x f15, x26                          ;
_l77:   la x23, d_2_3                             ;
        addi x23, x23, 28                         ;
        sc.w x21, x17, (x23)                      ;
_l78:   sraiw x22, x23, 14                        ;
_l79:   fcvt.s.l f29, x18, rtz                    ;
_l80:   la x25, _l176                             ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l81:   blt x22, x26, _l163                       ;
_l82:   rem x9, x2, x15                           ;
_l83:   mul x16, x14, x15                         ;
_l84:   fcvt.s.l f5, x3, rdn                      ;
_l85:   fmax.s f29, f13, f8                       ;
_l86:   la x9, d_4_3                              ;
        addi x9, x9, 20                           ;
        amomaxu.w x23, x4, (x9)                   ;
_l87:   fcvt.s.l f4, x21, rtz                     ;
_l88:   li x24, 0                                 ;
        la x24, pt1                               ;
        addi x24, x24, 8                          ;
        sfence.vma x24, x24                       ;
_l89:   la x30, d_4_21                            ;
        addi x30, x30, 12                         ;
        amomax.w x29, x21, (x30)                  ;
_l90:   la x16, d_2_19                            ;
        addi x16, x16, 0                          ;
        amominu.d x17, x5, (x16)                  ;
_l91:   la x7, d_1_17                             ;
        lbu x8, 25(x7)                            ;
_l92:   sllw x30, x21, x3                         ;
_l93:   la x26, d_2_5                             ;
        lb x5, -22(x26)                           ;
_l94:   la x17, d_4_8                             ;
        addi x17, x17, -0                         ;
        amomaxu.w x12, x27, (x17)                 ;
_l95:   sraiw x21, x13, 31                        ;
_l96:   fsub.s f29, f20, f11, rdn                 ;
_l97:   fadd.s f25, f15, f10, rmm                 ;
_l98:   la x13, d_4_21                            ;
        lb x14, -0(x13)                           ;
_l99:   sllw x11, x11, x30                        ;
_l100:  li x25, 1                                 ;
        la x24, pt2                               ;
        addi x24, x24, 24                         ;
        sfence.vma x25, x24                       ;
_l101:  remu x28, x23, x28                        ;
_l102:  fcvt.wu.s x3, f12, dyn                    ;
_l103:  mulh x30, x16, x28                        ;
_l104:  la x30, d_3_0                             ;
        lui x27, 0xffe00                          ;
        xor x30, x30, x27                         ;
        sw x11, 0(x30)                            ;
_l105:  fsqrt.s f20, f25, rup                     ;
_l106:  la x24, d_4_15                            ;
        lbu x5, 8(x24)                            ;
_l107:  la x6, _l173                              ;
        csrrw zero, mepc, x6                      ;
        mret                                      ;
_l108:  sllw x10, x1, x10                         ;
_l109:  fdiv.s f11, f3, f18, rtz                  ;
_l110:  slli x25, x22, 22                         ;
_l111:  addiw x25, x7, 2047                       ;
_l112:  la x6, d_2_3                              ;
        lh x11, 14(x6)                            ;
_l113:  la x30, d_3_10                            ;
        sd x6, 16(x30)                            ;
_l114:  fadd.s f9, f16, f18, rmm                  ;
_l115:  la x16, d_5_8                             ;
        lbu x14, -0(x16)                          ;
_l116:  la x12, d_0_24                            ;
        addi x12, x12, -28                        ;
        amoadd.w x22, x29, (x12)                  ;
_l117:  divu x10, x30, x15                        ;
_l118:  blt x3, x20, _l127                        ;
_l119:  la x14, d_2_21                            ;
        addi x14, x14, 28                         ;
        sc.w x28, x6, (x14)                       ;
_l120:  addw x12, x3, x9                          ;
_l121:  divu x9, x0, x11                          ;
_l122:  fnmadd.s f25, f0, f21, f21, rtz           ;
_l123:  xori x28, x8, 19                          ;
_l124:  sraw x15, x29, x21                        ;
_l125:  fnmadd.s f19, f5, f23, f14, rup           ;
_l126:  slti x22, x19, 0                          ;
_l127:  mulhu x21, x20, x21                       ;
_l128:  fcvt.l.s x0, f21, dyn                     ;
_l129:  fmsub.s f29, f3, f16, f22, rdn            ;
_l130:  slli x30, x3, 28                          ;
_l131:  jal x22, _l136                            ;
_l132:  srliw x25, x6, 0                          ;
_l133:  lui x24, 430289                           ;
_l134:  fmadd.s f29, f24, f17, f26, dyn           ;
_l135:  fmul.s f6, f1, f22, rtz                   ;
_l136:  fcvt.l.s x28, f24, rmm                    ;
_l137:  blt x10, x28, _l197                       ;
_l138:  andi x5, x24, 19                          ;
_l139:  bne x8, x29, _l143                        ;
_l140:  li x24, 1                                 ;
        la x9, pt0                                ;
        addi x9, x9, 0                            ;
        sfence.vma x24, x9                        ;
_l141:  fcvt.s.lu f12, x3, rne                    ;
_l142:  slti x4, x16, 0                           ;
_l143:  fle.s x12, f10, f15                       ;
_l144:  la x28, d_3_9                             ;
        lw x14, -24(x28)                          ;
_l145:  la x19, _l188                             ;
        csrrw zero, uepc, x19                     ;
        uret                                      ;
_l146:  fdiv.s f8, f15, f5, rne                   ;
_l147:  fcvt.s.lu f16, x16, rdn                   ;
_l148:  fnmadd.s f21, f22, f4, f0, rup            ;
_l149:  remw x21, x13, x27                        ;
_l150:  la x28, d_3_17                            ;
        addi x28, x28, 16                         ;
        lui x17, 0xffe00                          ;
        xor x28, x28, x17                         ;
        amoadd.d x30, x17, (x28)                  ;
_l151:  mul x9, x7, x21                           ;
_l152:  fadd.s f17, f11, f23, dyn                 ;
_l153:  remu x30, x30, x20                        ;
_l154:  li x30, 0                                 ;
        la x4, pt1                                ;
        addi x4, x4, 0                            ;
        sfence.vma x30, x4                        ;
_l155:  la x24, d_3_4                             ;
        addi x24, x24, -24                        ;
        amomaxu.d x12, x9, (x24)                  ;
_l156:  la x20, d_0_5                             ;
        addi x20, x20, -0                         ;
        amoadd.w x20, x11, (x20)                  ;
_l157:  xori x16, x19, 2031                       ;
_l158:  la x2, _l169                              ;
        csrrw zero, sepc, x2                      ;
        sret                                      ;
_l159:  fdiv.s f5, f16, f2, rtz                   ;
_l160:  auipc x5, 832591                          ;
_l161:  fadd.s f5, f16, f16, rne                  ;
_l162:  csrrwi x9, sepc, 0                        ;
_l163:  fsgnjn.s f31, f9, f28                     ;
_l164:  csrrsi x20, mie, 12                       ;
_l165:  fcvt.s.w f19, x2, rup                     ;
_l166:  la x24, d_4_20                            ;
        addi x24, x24, 16                         ;
        amoswap.w x25, x7, (x24)                  ;
_l167:  fsgnjn.s f26, f22, f17                    ;
_l168:  csrrci x7, sepc, 25                       ;
_l169:  subw x30, x6, x29                         ;
_l170:  fclass.s x5, f28                          ;
_l171:  la x14, d_3_23                            ;
        addi x14, x14, 20                         ;
        amoswap.w x11, x2, (x14)                  ;
_l172:  mulhsu x2, x15, x24                       ;
_l173:  la x16, d_2_23                            ;
        addi x16, x16, 24                         ;
        lui x24, 0xffe00                          ;
        xor x16, x16, x24                         ;
        amominu.d x9, x24, (x16)                  ;
_l174:  la x23, d_0_2                             ;
        lhu x7, -6(x23)                           ;
_l175:  addw x19, x9, x0                          ;
_l176:  mulhsu x16, x23, x12                      ;
_l177:  la x15, d_4_4                             ;
        lw x21, 28(x15)                           ;
_l178:  srli x20, x3, 24                          ;
_l179:  la x4, d_2_12                             ;
        lb x28, 19(x4)                            ;
_l180:  la x1, d_0_16                             ;
        addi x1, x1, 24                           ;
        lui x15, 0xffe00                          ;
        xor x1, x1, x15                           ;
        amoand.d x21, x15, (x1)                   ;
_l181:  la x9, d_2_25                             ;
        lhu x11, -0(x9)                           ;
_l182:  la x15, _l95                              ;
        srai x15, x15, 1                          ;
        csrrw x8, pmpaddr3, x15                   ;
_l183:  addiw x1, x3, -1411                       ;
_l184:  la x8, d_5_5                              ;
        addi x8, x8, -0                           ;
        amoswap.w x14, x24, (x8)                  ;
_l185:  ecall                                     ;
_l186:  fsgnj.s f21, f1, f28                      ;
_l187:  la x26, d_2_27                            ;
        sb x2, -0(x26)                            ;
_l188:  la x30, d_4_6                             ;
        addi x30, x30, -16                        ;
        amoor.d x6, x6, (x30)                     ;
_l189:  la x13, _l194                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l190:  fle.s x17, f11, f5                        ;
_l191:  fcvt.wu.s x29, f7, rne                    ;
_l192:  lui x19, 24                               ;
_l193:  la x12, d_5_26                            ;
        lbu x6, 31(x12)                           ;
_l194:  subw x26, x2, x29                         ;
_l195:  subw x7, x3, x15                          ;
_l196:  la x5, d_3_8                              ;
        addi x5, x5, 20                           ;
        amomaxu.w x28, x23, (x5)                  ;
_l197:;
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
                .dword 0xce195a3e1ca2099c, 0x14e8a47db024ce6b
                .dword 0xb74e9d58f318b244, 0x4a0139d84573d9df
d_0_0:          .dword 0xc7d40aa213c3d853, 0xcd705e53607018e8
d_0_1:          .dword 0x12051ccbbae3c035, 0x6d8b77b0d375176c
d_0_2:          .dword 0x09a689bb2c9bfece, 0x50cac90e3477b563
d_0_3:          .dword 0x68a6c318b48ef448, 0xe29e9c3577f18ac2
d_0_4:          .dword 0x26abb5660dfd9874, 0x19210bc6e2ef150b
d_0_5:          .dword 0xefa4b557e8a4bd45, 0x0d86a70ce6ecccb5
d_0_6:          .dword 0x5b548d274d2ac626, 0xbdc7c307949ee9a6
d_0_7:          .dword 0x647e3590f866df65, 0x9e858fff21bb41a9
d_0_8:          .dword 0x86912ca71eb6798f, 0x2d74348573cbe072
d_0_9:          .dword 0x4d58544b67744669, 0xcf68bcefb816dea9
d_0_10:         .dword 0xeb3809f9a223e102, 0x28fd86429ef99beb
d_0_11:         .dword 0xfd8d12ac06c4bcee, 0xa6600dc3ac00f086
d_0_12:         .dword 0x5091a90ff1cc6a89, 0x8bb034166a6a9f93
d_0_13:         .dword 0x43233d8132e5f466, 0xa7e5184c56f8101b
d_0_14:         .dword 0x37be7e2167c96459, 0x96adcdb2ecc5a4bd
d_0_15:         .dword 0xb699ec6c9355d361, 0x499d10475c932ec0
d_0_16:         .dword 0x635b83f7907c0e59, 0x341314264c2e3bd5
d_0_17:         .dword 0xd9a18206d428882d, 0xde1019037424ec60
d_0_18:         .dword 0xfe3422f3b583341a, 0xc53eb58d6e372fa3
d_0_19:         .dword 0xe44486f2496266bd, 0x74ef8a30c75dab2a
d_0_20:         .dword 0xc97b997100dce8ba, 0x1429ea13c2631521
d_0_21:         .dword 0xc34cc92801ca2a19, 0xc087369383ec01c8
d_0_22:         .dword 0x2f35affcaa04c408, 0xe81311f96edcfba9
d_0_23:         .dword 0xd0b10fbe7b7178c3, 0xba931ea667355370
d_0_24:         .dword 0xdf726db8b3845b91, 0xa890171488c29e1e
d_0_25:         .dword 0x693cb0bbd142f581, 0x8e3168bc5f90f86f
d_0_26:         .dword 0x4461ca0cbe726275, 0x8c3ea1b0609884bd
d_0_27:         .dword 0x0488fa0efef80bc2, 0x199850b3f6e094ba
                .dword 0x6215b05b25ed37f0, 0x6fefa386c38e59eb
                .dword 0x4ab254cc0270d095, 0xb4841a58d9253bcf
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x325f7834208eccb0, 0x3cb4d8114d58fb3d
                .dword 0x1d1efa46ee435cbd, 0x694cfd93f84e7efd
d_1_0:          .dword 0x63297d75e3630510, 0x1a94899daa3600b5
d_1_1:          .dword 0x961a25c69e0ce30c, 0x3b839dcf028e9092
d_1_2:          .dword 0x6364d72b2ffbf1ed, 0xef72ea8d8b8c5cfa
d_1_3:          .dword 0x071dbc1ead8c5160, 0x7a3e26834febe173
d_1_4:          .dword 0x43d48ec8a63c7ebc, 0x708c998e14608d74
d_1_5:          .dword 0xa1a1131315be860c, 0x7fc3ef29a41b8dfc
d_1_6:          .dword 0x458d1727fd0bef1d, 0x1ac993928f38ac30
d_1_7:          .dword 0xb8582189bda0b8e4, 0xde616569d15d15b7
d_1_8:          .dword 0xf41f05c8d33106c1, 0xb23f8a30f4d43d67
d_1_9:          .dword 0x7df0742f907d2f41, 0x7ef62ba36d22f04a
d_1_10:         .dword 0xbaf48c355c8ccb8e, 0x22bc1975497ddf55
d_1_11:         .dword 0xbdb3b6fcdbd1470c, 0x2309d81a8dcf8db4
d_1_12:         .dword 0xe6efc2a8bbbe5847, 0x65189f3f852760e6
d_1_13:         .dword 0x09753dc624f77ab6, 0xa03f293b50ce78a3
d_1_14:         .dword 0x56de39d1a0b32eee, 0x4f06f89ebcb2b4de
d_1_15:         .dword 0x8ea64127cda07795, 0xefc5cf5e6d211d81
d_1_16:         .dword 0xcde9ace444bc7eb3, 0x330a43ba4c71b90c
d_1_17:         .dword 0xc13d0dca7471e00f, 0x4f5717c80ca87560
d_1_18:         .dword 0xbd29c0ac1ec1fb70, 0x74a12e16fb4be392
d_1_19:         .dword 0x5619cd0e6b38559c, 0x2cba54e1e644bffe
d_1_20:         .dword 0x04b461663d48568a, 0xa209e649d8efbefe
d_1_21:         .dword 0xcde213d0ce7bc4d4, 0x7d2e91afd300793c
d_1_22:         .dword 0x8a65743f40122f98, 0x24b854a9d8a6b801
d_1_23:         .dword 0x35b3c422d5dfeaff, 0x59c8a127dd7645ca
d_1_24:         .dword 0xc5b78af864d4f8d8, 0x265fde9e6052932f
d_1_25:         .dword 0x43e36bf38d57068f, 0x95b80eb70f895397
d_1_26:         .dword 0xf06c8614ee5c9788, 0x716064e313ece326
d_1_27:         .dword 0xf06b118c1bf2257b, 0x9439bb7bc8da2ab6
                .dword 0xe03131ca3a6c8653, 0x4e54962ddcbc574f
                .dword 0xb8b25e2771cb2f79, 0x358a8f09070261f8
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xf8037032046e8025, 0x2f0326c041612a63
                .dword 0xd8db1911b8149bfa, 0x9333980ae3a9663d
d_2_0:          .dword 0x5c139b393673553c, 0x2b75013f28cc5aa1
d_2_1:          .dword 0xbf7ce95b2a9d8a9d, 0x2a308d93c759c6ad
d_2_2:          .dword 0x99417bbbfe344c5d, 0xc4b9cbc176abcffc
d_2_3:          .dword 0x335142a00508c471, 0x34be1726e16c5454
d_2_4:          .dword 0xca5a7b7f19b5883f, 0xcc6928b3dd55d9f3
d_2_5:          .dword 0x35c56c6e4e0b06c7, 0xab9c7ca99b8ba444
d_2_6:          .dword 0xb8963535cf2f4304, 0x7271eb95a05b709d
d_2_7:          .dword 0x8dfbb64336106f32, 0x10d1081515afb97a
d_2_8:          .dword 0xdfd9b4851f822079, 0x327049fd20d38a2d
d_2_9:          .dword 0xb738f194adde85ae, 0xba2ec89f7260a765
d_2_10:         .dword 0xcebf925f4719162a, 0xc65d0849b57ea79a
d_2_11:         .dword 0x430f6054da8976d2, 0x8bca9647609d2820
d_2_12:         .dword 0xe919e278238e583b, 0x843b6f23a1623b29
d_2_13:         .dword 0xd2e30b37169b1744, 0xc011d3a1b1febe8a
d_2_14:         .dword 0xa0f7002eba6eb1b2, 0x8e8c5e977b8135f1
d_2_15:         .dword 0x3e9b741ddb5599ef, 0x2d1f56920788452f
d_2_16:         .dword 0x2e6f8a278e439acb, 0xba431e6e2e089dc2
d_2_17:         .dword 0x322763fcbc214bb3, 0x2c6b9ceb9a12bb16
d_2_18:         .dword 0x93302b48747dba3e, 0xbdcaec2fbf30e2a4
d_2_19:         .dword 0x1eb428526f960d4e, 0x83d32775205be3f3
d_2_20:         .dword 0xf508b45027396ce7, 0x43a05ffd02217540
d_2_21:         .dword 0xc74223fa59580374, 0x5baffe9c7cdada52
d_2_22:         .dword 0x10c02817fd54330a, 0x23e69606fa846d1d
d_2_23:         .dword 0x76a80dee482665c8, 0x387e896398cc6bf8
d_2_24:         .dword 0xa0b7fcdc75f62617, 0x9e3bb57326aaedc8
d_2_25:         .dword 0xf741c84a7fc6b6a1, 0x4c1a463986d9c164
d_2_26:         .dword 0x00fcb165e7db642e, 0x70fe30f396dfb93c
d_2_27:         .dword 0x39bb1c38e79af89a, 0xd8c1245a7ef4b523
                .dword 0xf58a25e6ad821ef5, 0xaaf4e2f6512646b9
                .dword 0xb120ae1cdf633ef3, 0xcb86249f831cc4df
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe0bb9bc5139e11f4, 0x97e5b994405fc970
                .dword 0x58fc7b3e14a6a9e7, 0xee2b56f1e6e24052
d_3_0:          .dword 0xd1fbfd2c183a9e55, 0x9775643205ee7049
d_3_1:          .dword 0x9bba68342117715d, 0xba7a306a146fc842
d_3_2:          .dword 0xcd30ab8ceba975f6, 0xb87e4ec0e7cfa7f8
d_3_3:          .dword 0x3232a5dbf401ac99, 0xf92eb3ea47619964
d_3_4:          .dword 0x93f1093fb4a90919, 0x4ff68de010f98377
d_3_5:          .dword 0xd1598ace822f9c98, 0xc9546841438ee05c
d_3_6:          .dword 0x234e236a7837f282, 0x2e4c4014da7366ec
d_3_7:          .dword 0x5b8a4823c1a2df1d, 0x9ce23ad2fe55cdf8
d_3_8:          .dword 0x013085ee378a070e, 0x28369059c5521594
d_3_9:          .dword 0x9bfe8f5b4675677e, 0x7545dd4220524242
d_3_10:         .dword 0xc256dac36269a342, 0xd6a32044afecf34c
d_3_11:         .dword 0x9244bfd0656ebe9b, 0x4f6fab22886e142b
d_3_12:         .dword 0x6e69bd643392dd35, 0xe1e7394b13bccd52
d_3_13:         .dword 0xb82548b8679724cd, 0xb63030b4ea3ef23f
d_3_14:         .dword 0xafb4b4d9292e30d9, 0x33c67476a62c9349
d_3_15:         .dword 0xfa129ef74ef8d480, 0xd6bc47bc4b68684c
d_3_16:         .dword 0x762f0cf90b4bec6f, 0x5ca89fe1f9a05249
d_3_17:         .dword 0xff62a244fc94fd38, 0x0b01d18f42be924d
d_3_18:         .dword 0x259c56d334751137, 0x0a54d75ee13424e0
d_3_19:         .dword 0xf379eaec194c8d43, 0x40788fce739ff4a8
d_3_20:         .dword 0x4df90e3d39ea608f, 0x8a045333a2ee799a
d_3_21:         .dword 0x4a62bb7f46a17c28, 0xf07f0740c78147ec
d_3_22:         .dword 0x2c40189f9169403d, 0x2084dfbf9ba9735e
d_3_23:         .dword 0x8d79d228340768dc, 0x5c984a9e826edd72
d_3_24:         .dword 0x3e66ddcfaabe06c1, 0xc8253d4e97d31274
d_3_25:         .dword 0xbeeffaa662c4ef2f, 0x2e4832ca04f935e3
d_3_26:         .dword 0xce7ea7c7e16467d6, 0x25126c314d22691c
d_3_27:         .dword 0x73a0b727ba642e7d, 0x7ff1aac04b16ee5e
                .dword 0x7c904049dc33b351, 0xa9d57e0dd08a4383
                .dword 0x0ce8f734a8736fa4, 0xe1af2eb391b831b5
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x4612a5bf84eebeab, 0xcba01944faa02aaa
                .dword 0x82344eba76df03a3, 0x4b213392764bfeb2
d_4_0:          .dword 0xe29fb2ec90c86df1, 0x7f6ee1be030e45ac
d_4_1:          .dword 0x5d456cec3d50d80d, 0x713af093a98e84a3
d_4_2:          .dword 0x92794632667cb2b8, 0xc0627e495acb63b0
d_4_3:          .dword 0xfe59b989aff3eafa, 0x8e9c4c90f376bd6c
d_4_4:          .dword 0xd465c40c13d21aa3, 0x47901597c5a634b2
d_4_5:          .dword 0xf4d10dbe8264f5c0, 0xea7faa9c37601d9c
d_4_6:          .dword 0xaeac7ef7a77f4900, 0x714fb892c196dd09
d_4_7:          .dword 0x49aab94ab7c6e836, 0xb2a679fdf72f230f
d_4_8:          .dword 0xb2efcb470bab4ed3, 0xa8a367633e4a46ef
d_4_9:          .dword 0xbd044cdcef213b43, 0x42b6d9cd6396fddf
d_4_10:         .dword 0xd116fc9786a02d91, 0xe366f5e6f5b77ab8
d_4_11:         .dword 0xacb20fb8854213e7, 0xdc386d4f6aa4976b
d_4_12:         .dword 0x6e23720d4ddb56fe, 0xbb7364352c0c60ec
d_4_13:         .dword 0x7fd47c53c80bb5d1, 0x1bc4e1506424bb81
d_4_14:         .dword 0x8079d236689d00ee, 0xa08df12e091ff41e
d_4_15:         .dword 0x05aa90cd5dd1a649, 0x2b3aa7dd2e677e3b
d_4_16:         .dword 0x90cc454e5f334f65, 0x438d68a261bba607
d_4_17:         .dword 0x24aabf7234f51356, 0x284263cd270a0abc
d_4_18:         .dword 0xecb7c2ef1330d896, 0x923e7983d018235f
d_4_19:         .dword 0x8a416dcc43a36e94, 0x2421620eb9c7c178
d_4_20:         .dword 0xf9c3f6522de17797, 0xdc92ee3de0cc5097
d_4_21:         .dword 0x1c96824486a33636, 0x5fbdcf7a1accd10a
d_4_22:         .dword 0xe2c7d70b93fdc89c, 0xd06d404b398b92e8
d_4_23:         .dword 0x576e564f278d8910, 0x943ae8b7438b7e79
d_4_24:         .dword 0x61e326af1b0d2c9e, 0xe0541e5f008b8186
d_4_25:         .dword 0x2c96a0f407ebc6a5, 0xb9cb024292a91175
d_4_26:         .dword 0xfde18d6b585deab9, 0xebd9af9f15a61c3c
d_4_27:         .dword 0x12c94c465e02214c, 0xefd8f595df581f94
                .dword 0x03872f145b4027a2, 0x5c18026664b27e12
                .dword 0x820637a9f4434bec, 0x9d1a45779d6fb3f8
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x56495c4974c39edc, 0xa453c6667d35d3d6
                .dword 0x2c4f9545ebf4836a, 0xc12996b16767f00c
d_5_0:          .dword 0x61c854f8e021b5d7, 0x160b56d46a2d7a67
d_5_1:          .dword 0x1010f19ac6a7f267, 0x0f63e26c5900fba3
d_5_2:          .dword 0xb903314dc44c9d37, 0xacac9b54d7ab5ccf
d_5_3:          .dword 0x11c12290d376ffc6, 0x090c2b6463128822
d_5_4:          .dword 0xc0440b5bba143c8e, 0x396020f37fd9089c
d_5_5:          .dword 0x13a062a548efbda9, 0x843e7b4a66de3896
d_5_6:          .dword 0xbeb39726b1ffb570, 0x8af121e62e277551
d_5_7:          .dword 0xa784397fbc6ebde4, 0x52428f364cfca45f
d_5_8:          .dword 0xd441adbefe6c1260, 0x480376274394ed2a
d_5_9:          .dword 0xd2ca766e4a633df9, 0x876650ca4b96f759
d_5_10:         .dword 0x0b1d5df27a9ce455, 0xc98f12caad271cf1
d_5_11:         .dword 0x576ca97cfd5084c8, 0xcca13235baf6e788
d_5_12:         .dword 0x62d3bee4c3fef46d, 0x1b00fea27cb38928
d_5_13:         .dword 0xf60b1d9a169f7cc4, 0x3ded31882a7b1ebc
d_5_14:         .dword 0x8a1d221f9d657bd5, 0x499463a6e8962353
d_5_15:         .dword 0x3cffabea81e1f8a4, 0x6dc0beacab8291e4
d_5_16:         .dword 0x031973f9e2064856, 0xc53e65215946ee63
d_5_17:         .dword 0x7ae28f2f6f1bdcfc, 0x08bca27425157093
d_5_18:         .dword 0x82fbdc115e594066, 0xd9a06fb517306cc8
d_5_19:         .dword 0x6e5a2541bb3416c4, 0xf334343c8901bde4
d_5_20:         .dword 0x10193081a420b774, 0x344c643216acc3be
d_5_21:         .dword 0x608a71bfe6ca40fb, 0xcf1988a7ee439daa
d_5_22:         .dword 0x24f42ada6e73abae, 0xe7a9cdd57a4ef7ba
d_5_23:         .dword 0x0b0d640431d61824, 0xd818718c8d528e58
d_5_24:         .dword 0x5c7301c23a808296, 0x3a13423eb1072628
d_5_25:         .dword 0x49bffc96431f626a, 0x423df88765d7a622
d_5_26:         .dword 0xc529c9b4a35de73f, 0x10b2438439456f40
d_5_27:         .dword 0x235da4014e4dbf92, 0x2171c997d4b7ceaa
                .dword 0x21be49a48bab22a5, 0x98fe69501f746c5b
                .dword 0xb6f8bd353dd3b4c6, 0x1046610e67e04d24
         /* Random data */
_end_data5:
              
                 
