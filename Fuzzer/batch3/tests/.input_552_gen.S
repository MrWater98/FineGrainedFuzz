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
_s0:    la x19, d_4_8                             ;
        addi x19, x19, 4                          ;
        amoand.w x30, x10, (x19)                  ;
_s1:    la x15, d_3_15                            ;
        addi x15, x15, -16                        ;
        sc.d x2, x15, (x15)                       ;
_s2:    la x28, _s5                               ;
        csrrw zero, mepc, x28                     ;
        mret                                      ;
_s3:    subw x14, x8, x30                         ;
_s4:    ecall                                     ;
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
_p0:    csrrwi x10, mscratch, 22                  ;
_p1:    csrrwi x11, sscratch, 24                  ;
_p2:    xor x11, x11, x11                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 10                         ;
        add x11, x11, x13                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 1                          ;
        add x11, x11, x11                         ;
        csrrw x13, medeleg, x11                   ;
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
_l0:    la x11, _l149                             ;
        csrrw zero, sepc, x11                     ;
        sret                                      ;
_l1:    fcvt.s.lu f11, x10, rmm                   ;
_l2:    la x23, _l126                             ;
        csrrw zero, uepc, x23                     ;
        uret                                      ;
_l3:    subw x22, x6, x30                         ;
_l4:    divu x26, x5, x20                         ;
_l5:    bge x4, x28, _l91                         ;
_l6:    la x6, d_4_25                             ;
        addi x6, x6, 0                            ;
        amomax.d x13, x23, (x6)                   ;
_l7:    remu x10, x13, x12                        ;
_l8:    subw x19, x8, x10                         ;
_l9:    remuw x16, x23, x8                        ;
_l10:   fcvt.s.lu f12, x7, rdn                    ;
_l11:   fmul.s f12, f19, f30, rdn                 ;
_l12:   la x30, d_1_24                            ;
        addi x30, x30, -24                        ;
        amoxor.d x12, x3, (x30)                   ;
_l13:   andi x0, x8, 2047                         ;
_l14:   bge x7, x15, _l50                         ;
_l15:   sllw x7, x13, x25                         ;
_l16:   la x25, _l107                             ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l17:   la x23, _l21                              ;
        jalr x27, 0(x23)                          ;
_l18:   fnmadd.s f11, f10, f28, f11, rmm          ;
_l19:   la x27, d_1_24                            ;
        addi x27, x27, -16                        ;
        amoand.d x7, x13, (x27)                   ;
_l20:   fsub.s f28, f28, f24, rdn                 ;
_l21:   remu x29, x24, x19                        ;
_l22:   la x27, d_1_15                            ;
        addi x27, x27, -8                         ;
        amomaxu.d x26, x12, (x27)                 ;
_l23:   lui x13, 1                                ;
_l24:   ori x30, x20, 0                           ;
_l25:   fclass.s x5, f10                          ;
_l26:   la x22, d_0_26                            ;
        addi x22, x22, 16                         ;
        lui x4, 0xffe00                           ;
        xor x22, x22, x4                          ;
        amomin.w x10, x4, (x22)                   ;
_l27:   fcvt.wu.s x13, f24, rmm                   ;
_l28:   bltu x25, x8, _l120                       ;
_l29:   la x24, _l93                              ;
        jalr x24, 0(x24)                          ;
_l30:   fsqrt.s f30, f18, dyn                     ;
_l31:   fmsub.s f18, f24, f19, f15, rdn           ;
_l32:   fnmadd.s f5, f5, f4, f28, rne             ;
_l33:   ori x19, x17, 203                         ;
_l34:   slti x7, x20, 2047                        ;
_l35:   la x30, _l97                              ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l36:   la x2, d_1_26                             ;
        lui x18, 0xffe00                          ;
        xor x2, x2, x18                           ;
        sb x16, 31(x2)                            ;
_l37:   la x26, d_3_2                             ;
        lh x24, -4(x26)                           ;
_l38:   remw x25, x13, x30                        ;
_l39:   xori x0, x19, 236                         ;
_l40:   la x10, d_4_13                            ;
        addi x10, x10, 24                         ;
        lr.d x18, (x10)                           ;
_l41:   srlw x24, x17, x23                        ;
_l42:   la x26, _l80                              ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l43:   rem x7, x8, x17                           ;
_l44:   la x30, d_0_0                             ;
        fsw f19, -20(x30)                         ;
_l45:   la x16, d_0_3                             ;
        addi x16, x16, -0                         ;
        amoor.d x6, x29, (x16)                    ;
_l46:   fence                                     ;
_l47:   la x18, _l68                              ;
        jalr x26, 0(x18)                          ;
_l48:   divu x21, x28, x11                        ;
_l49:   fcvt.s.lu f22, x30, rup                   ;
_l50:   fnmadd.s f9, f5, f28, f20, rup            ;
_l51:   la x30, d_4_1                             ;
        addi x30, x30, 8                          ;
        amoor.d x26, x16, (x30)                   ;
_l52:   mulhu x12, x28, x10                       ;
_l53:   fmv.w.x f28, x6                           ;
_l54:   csrrsi x6, fcsr, 14                       ;
_l55:   la x8, d_4_6                              ;
        addi x8, x8, -16                          ;
        amoand.w x30, x21, (x8)                   ;
_l56:   la x4, d_3_22                             ;
        addi x4, x4, 4                            ;
        lui x8, 0xffe00                           ;
        xor x4, x4, x8                            ;
        amomaxu.w x3, x8, (x4)                    ;
_l57:   la x16, d_0_0                             ;
        addi x16, x16, 12                         ;
        lr.w x27, (x16)                           ;
_l58:   xori x25, x11, 151                        ;
_l59:   bne x20, x11, _l92                        ;
_l60:   fmax.s f2, f3, f26                        ;
_l61:   fdiv.s f14, f24, f9, rmm                  ;
_l62:   la x27, d_2_19                            ;
        sd x7, 16(x27)                            ;
_l63:   fcvt.w.s x23, f14, dyn                    ;
_l64:   la x18, d_3_22                            ;
        srai x18, x18, 1                          ;
        csrrw x11, pmpaddr2, x18                  ;
_l65:   la x17, d_2_7                             ;
        lwu x15, 8(x17)                           ;
_l66:   remuw x8, x12, x24                        ;
_l67:   srlw x22, x28, x5                         ;
_l68:   xori x12, x21, -544                       ;
_l69:   fence                                     ;
_l70:   fmax.s f28, f14, f9                       ;
_l71:   la x11, d_5_26                            ;
        addi x11, x11, 24                         ;
        lr.w x10, (x11)                           ;
_l72:   la x3, d_5_10                             ;
        addi x3, x3, 16                           ;
        amoswap.w x8, x13, (x3)                   ;
_l73:   fence                                     ;
_l74:   fmul.s f19, f24, f11, rmm                 ;
_l75:   fcvt.w.s x15, f29, dyn                    ;
_l76:   la x15, d_4_16                            ;
        addi x15, x15, -16                        ;
        amoswap.d x30, x23, (x15)                 ;
_l77:   fence                                     ;
_l78:   la x16, _l147                             ;
        jalr x16, 0(x16)                          ;
_l79:   la x25, _l158                             ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l80:   fcvt.lu.s x11, f24, rup                   ;
_l81:   fsqrt.s f26, f17, rmm                     ;
_l82:   beq x30, x29, _l128                       ;
_l83:   xori x5, x3, 986                          ;
_l84:   divuw x24, x3, x9                         ;
_l85:   mulhsu x11, x6, x13                       ;
_l86:   fnmsub.s f7, f6, f18, f4, rtz             ;
_l87:   la x12, _l58                              ;
        srai x12, x12, 1                          ;
        csrrc x18, pmpaddr0, x12                  ;
_l88:   subw x2, x28, x22                         ;
_l89:   la x15, _l180                             ;
        csrrw zero, uepc, x15                     ;
        uret                                      ;
_l90:   xor x9, x9, x9                            ;
        csrrc x5, sscratch, x9                    ;
_l91:   la x8, d_0_12                             ;
        flw f4, -24(x8)                           ;
_l92:   fnmadd.s f8, f1, f16, f6, dyn             ;
_l93:   la x23, d_3_14                            ;
        flw f21, 20(x23)                          ;
_l94:   mulh x1, x27, x16                         ;
_l95:   la x10, d_1_20                            ;
        srai x10, x10, 1                          ;
        csrrw x17, pmpaddr3, x10                  ;
_l96:   la x23, d_1_14                            ;
        lwu x28, 16(x23)                          ;
_l97:   remu x30, x8, x28                         ;
_l98:   bltu x22, x26, _l135                      ;
_l99:   la x6, d_2_16                             ;
        addi x6, x6, 28                           ;
        amomaxu.w x7, x23, (x6)                   ;
_l100:  rem x19, x16, x3                          ;
_l101:  bgeu x11, x13, _l197                      ;
_l102:  fmv.w.x f21, x28                          ;
_l103:  la x25, d_3_23                            ;
        fsw f21, -28(x25)                         ;
_l104:  subw x8, x7, x29                          ;
_l105:  fsqrt.s f30, f25, rne                     ;
_l106:  la x10, d_4_15                            ;
        addi x10, x10, 8                          ;
        lui x22, 0xffe00                          ;
        xor x10, x10, x22                         ;
        amominu.w x17, x22, (x10)                 ;
_l107:  la x19, d_5_21                            ;
        lwu x24, -16(x19)                         ;
_l108:  divu x24, x17, x12                        ;
_l109:  bltu x1, x16, _l197                       ;
_l110:  xori x30, x6, 15                          ;
_l111:  fsgnj.s f6, f6, f21                       ;
_l112:  fmv.x.w x30, f15                          ;
_l113:  fmul.s f29, f26, f2, dyn                  ;
_l114:  la x16, d_1_15                            ;
        addi x16, x16, 16                         ;
        amoand.d x12, x18, (x16)                  ;
_l115:  bltu x29, x3, _l144                       ;
_l116:  la x24, d_5_19                            ;
        lw x21, -16(x24)                          ;
_l117:  fence                                     ;
_l118:  mulhu x8, x11, x8                         ;
_l119:  la x6, d_2_27                             ;
        sw x24, -16(x6)                           ;
_l120:  fmv.x.w x6, f24                           ;
_l121:  la x1, d_5_6                              ;
        addi x1, x1, 16                           ;
        amoand.w x15, x2, (x1)                    ;
_l122:  bgeu x13, x27, _l198                      ;
_l123:  la x4, d_2_6                              ;
        addi x4, x4, 4                            ;
        amoor.w x19, x23, (x4)                    ;
_l124:  fnmsub.s f11, f13, f19, f11, rmm          ;
_l125:  beq x5, x6, _l187                         ;
_l126:  la x29, _l151                             ;
        lwu x9, 8(x29)                            ;
_l127:  la x7, d_3_16                             ;
        sh x14, 12(x7)                            ;
_l128:  subw x22, x16, x9                         ;
_l129:  fence.i                                   ;
_l130:  fsqrt.s f16, f26, rmm                     ;
_l131:  fcvt.s.w f27, x29, dyn                    ;
_l132:  slli x4, x6, 38                           ;
_l133:  addw x6, x4, x3                           ;
_l134:  csrrwi x4, mscratch, 0                    ;
_l135:  divuw x2, x4, x15                         ;
_l136:  fence                                     ;
_l137:  la x8, d_0_8                              ;
        addi x8, x8, 0                            ;
        amoadd.d x18, x23, (x8)                   ;
_l138:  fcvt.s.lu f13, x17, rne                   ;
_l139:  fcvt.s.lu f29, x8, rdn                    ;
_l140:  fence                                     ;
_l141:  la x1, d_5_24                             ;
        addi x1, x1, -16                          ;
        amominu.w x11, x7, (x1)                   ;
_l142:  fmax.s f3, f19, f14                       ;
_l143:  jal x26, _l177                            ;
_l144:  la x9, d_2_24                             ;
        addi x9, x9, -24                          ;
        amoand.d x5, x11, (x9)                    ;
_l145:  ebreak                                    ;
_l146:  auipc x22, 702836                         ;
_l147:  lui x4, 426424                            ;
_l148:  addi x2, x9, -764                         ;
_l149:  la x5, d_5_6                              ;
        lui x7, 0xffe00                           ;
        xor x5, x5, x7                            ;
        lhu x30, -18(x5)                          ;
_l150:  xori x2, x23, 1446                        ;
_l151:  la x17, d_3_9                             ;
        sd x26, 16(x17)                           ;
_l152:  beq x23, x14, _l161                       ;
_l153:  la x19, d_5_10                            ;
        addi x19, x19, 8                          ;
        lui x19, 0xffe00                          ;
        xor x19, x19, x19                         ;
        amomaxu.d x7, x19, (x19)                  ;
_l154:  mulhu x29, x29, x4                        ;
_l155:  la x16, d_3_11                            ;
        addi x16, x16, 24                         ;
        amoxor.w x16, x29, (x16)                  ;
_l156:  la x16, d_0_27                            ;
        addi x16, x16, 16                         ;
        amoadd.d x20, x26, (x16)                  ;
_l157:  xori x10, x17, 1158                       ;
_l158:  remuw x26, x5, x25                        ;
_l159:  srliw x7, x2, 11                          ;
_l160:  la x9, _l164                              ;
        csrrw zero, uepc, x9                      ;
        uret                                      ;
_l161:  la x21, d_4_18                            ;
        sh x11, 18(x21)                           ;
_l162:  xor x10, x10, x10                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 0                          ;
        add x10, x10, x30                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 30                         ;
        add x10, x10, x10                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 29                         ;
        add x10, x10, x12                         ;
        csrrc x21, pmpcfg0, x10                   ;
_l163:  fmin.s f16, f23, f29                      ;
_l164:  subw x21, x2, x15                         ;
_l165:  flt.s x6, f4, f3                          ;
_l166:  fclass.s x28, f2                          ;
_l167:  divw x19, x22, x17                        ;
_l168:  srliw x15, x22, 20                        ;
_l169:  mulhu x15, x9, x14                        ;
_l170:  li x4, 1                                  ;
        la x27, pt2                               ;
        addi x27, x27, 16                         ;
        sfence.vma x4, x27                        ;
_l171:  fcvt.lu.s x3, f28, rtz                    ;
_l172:  la x6, d_3_23                             ;
        addi x6, x6, -8                           ;
        amomin.d x15, x9, (x6)                    ;
_l173:  feq.s x6, f2, f2                          ;
_l174:  blt x28, x25, _l187                       ;
_l175:  xori x10, x18, -832                       ;
_l176:  bltu x5, x28, _l188                       ;
_l177:  la x5, d_4_26                             ;
        lwu x23, -20(x5)                          ;
_l178:  slti x24, x22, -870                       ;
_l179:  la x21, d_2_5                             ;
        addi x21, x21, -8                         ;
        amomaxu.w x10, x5, (x21)                  ;
_l180:  fdiv.s f0, f2, f2, dyn                    ;
_l181:  la x11, _l188                             ;
        srai x11, x11, 1                          ;
        csrrw x21, pmpaddr1, x11                  ;
_l182:  bltu x9, x16, _l189                       ;
_l183:  ebreak                                    ;
_l184:  la x29, d_5_2                             ;
        addi x29, x29, -0                         ;
        amoxor.d x9, x2, (x29)                    ;
_l185:  feq.s x0, f24, f24                        ;
_l186:  srai x22, x0, 51                          ;
_l187:  la x16, d_4_1                             ;
        sb x9, -0(x16)                            ;
_l188:  la x3, d_5_20                             ;
        addi x3, x3, 16                           ;
        amomax.w x23, x30, (x3)                   ;
_l189:  bge x1, x22, _l192                        ;
_l190:  fcvt.w.s x26, f8, rne                     ;
_l191:  mulhu x16, x5, x10                        ;
_l192:  slli x2, x30, 0                           ;
_l193:  la x14, d_0_8                             ;
        addi x14, x14, 8                          ;
        amoor.d x15, x14, (x14)                   ;
_l194:  la x14, d_4_11                            ;
        sh x26, 2(x14)                            ;
_l195:  lui x23, 764                              ;
_l196:  fcvt.s.l f10, x26, rdn                    ;
_l197:  la x11, d_2_25                            ;
        addi x11, x11, -24                        ;
        sc.d x6, x11, (x11)                       ;
_l198:  slti x17, x16, 1088                       ;
_l199:  fclass.s x17, f12                         ;
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
                .dword 0x6659e398de81fe87, 0xa8134a776e9a282c
                .dword 0x61fdfca6d9248c5b, 0xd59eacd0c34ecce0
d_0_0:          .dword 0xc36440e0dfb2f7ce, 0x2fa59e55633a82de
d_0_1:          .dword 0xf85c6c747c457534, 0xb66981ef243e7db3
d_0_2:          .dword 0x9f4c6ed0affa1f56, 0x0239d5ca946b2f61
d_0_3:          .dword 0x9adadf45d7a87508, 0x66bd90ef942539b3
d_0_4:          .dword 0x08103dd6c01d2674, 0x52f5f8b03d629ce1
d_0_5:          .dword 0x5a27f782170a4d85, 0x13cc7b75197c5cf8
d_0_6:          .dword 0xa926d48daa1cb659, 0x25a063069f1316a0
d_0_7:          .dword 0xeb47da2729c7c806, 0x497c54d46515f87f
d_0_8:          .dword 0x74f04a786888e4a6, 0x222d8f44696301c8
d_0_9:          .dword 0x298e206484e5b90d, 0xd598e10d247092e3
d_0_10:         .dword 0x01f8f86f405347a7, 0xd8704474a23825af
d_0_11:         .dword 0x03b2da1c1a2b60cb, 0xebb2f5757fe90b3f
d_0_12:         .dword 0x544694da4d3f4407, 0xe4333d5e6bf1c1ea
d_0_13:         .dword 0xa4107add5aca31e9, 0x3c28f464640591c8
d_0_14:         .dword 0x7b74f509c6fd6998, 0x5f919b634babb17c
d_0_15:         .dword 0xea32bb4783d74e5f, 0xa6fd4c8d09d333f3
d_0_16:         .dword 0xa2a3aadce1afbd20, 0x9374f52cf241d31c
d_0_17:         .dword 0xb3df8eb7c0f8b31d, 0x41095d9d42b85f2d
d_0_18:         .dword 0xc4d7bde0e6a821f3, 0x84630da069658d43
d_0_19:         .dword 0xbbb7046b1de5b0f7, 0x15c753905c731e3f
d_0_20:         .dword 0xe23c30934e0fafd8, 0x0e394b0449fceb80
d_0_21:         .dword 0xf66397411e95591a, 0x7f6935f0b7f47afc
d_0_22:         .dword 0x938ab91931591323, 0x6fc79a7958838530
d_0_23:         .dword 0x224bdf3819e47222, 0x2f9da27a2517962b
d_0_24:         .dword 0x141fe4f49eb76964, 0x000263416aaf3dd2
d_0_25:         .dword 0xe63d1cfc392d4859, 0xe095a31dd634fdf4
d_0_26:         .dword 0x3902cba85f02358f, 0xf186d4489944d356
d_0_27:         .dword 0x6a38b7a927e5db69, 0xbbc9e4c8be3b12eb
                .dword 0x3f864252b4964800, 0x8a0c1116422fac2c
                .dword 0xcdec92f6c06a522a, 0xf14ea653f488d3e4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xf6bbf74f01b49443, 0xfe9c4a6de5267f1a
                .dword 0xd61a6adcce46314b, 0x751f2d559b9999e2
d_1_0:          .dword 0x6cb93b21ebe9612e, 0xdf1a8a844d92bcaa
d_1_1:          .dword 0xdb6059197dd8a278, 0x9106ab5e5bb991b8
d_1_2:          .dword 0xd362373f28ad70ae, 0x0331877c9b87d659
d_1_3:          .dword 0x8459e127aacfeb6e, 0xc60cecc5fa169138
d_1_4:          .dword 0xbe32e81af246a459, 0xf45d78b0f3fe8166
d_1_5:          .dword 0xe17e6981e0dc7a49, 0x7741c4c76bb50e28
d_1_6:          .dword 0x819f657154593fe0, 0x6a9c9061c98bf24b
d_1_7:          .dword 0xd9f7667eba26d00e, 0xb7c509dc4d1e3f4a
d_1_8:          .dword 0xb47177972853bd63, 0xa870f3abbd02b9e5
d_1_9:          .dword 0xd96c6787e1bef262, 0xcc49c6a42ff9244d
d_1_10:         .dword 0xfe60778a9872d733, 0xb12d7df7952d3863
d_1_11:         .dword 0x27be2747b8ecc10a, 0x394eb334bf334b34
d_1_12:         .dword 0xf46d169055eae3e1, 0xc377d3891295edb2
d_1_13:         .dword 0x41e7c984fff79761, 0xa2eb67ee528622a7
d_1_14:         .dword 0xe50c639bf19c5e47, 0x866fcff1317880ba
d_1_15:         .dword 0xe1365b3066c6afca, 0xe34e0447e252e3fd
d_1_16:         .dword 0xecb57faf941a5b60, 0xaa1189b396079435
d_1_17:         .dword 0x3c2f771aa3588630, 0x52608dc492c0e627
d_1_18:         .dword 0xb844db2e38058599, 0x64f698e464dbd7c4
d_1_19:         .dword 0x46f83c61a47128f6, 0x5a77686529520f53
d_1_20:         .dword 0x985c6f67e44f7a23, 0x06c3265006e400b0
d_1_21:         .dword 0x0641df25cb7b8ea4, 0x6f348ab092857f9a
d_1_22:         .dword 0xb6c1667577f5ca48, 0x088bb8865a3cba96
d_1_23:         .dword 0x293107bdb16ae0ed, 0x9be8701cae1cd209
d_1_24:         .dword 0xba668257cc05c751, 0x22587d821d9aebcf
d_1_25:         .dword 0x2c0751e3f57b8eef, 0xe20c02b1000ad9a8
d_1_26:         .dword 0xb3686bc279028267, 0xbd89bfd391fd85cb
d_1_27:         .dword 0xe5e1c4c6638880de, 0xfc67543f121b24d7
                .dword 0xa34c14cc420bdcbb, 0x775cd39c51b23e33
                .dword 0x7f3d3fe6884c46fb, 0x15a201e00b7882b7
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe6c661a0bae7609b, 0x3febcf593826d1f0
                .dword 0x802a18006c86c07e, 0x63997f5acb39cf7e
d_2_0:          .dword 0xfb084da01b9afb2e, 0x398d6d41aaa67804
d_2_1:          .dword 0x6c4863c3ef4a69f3, 0xdd14df42b45efaf6
d_2_2:          .dword 0x498cf391c79c5387, 0x4ac9b0837eaadf89
d_2_3:          .dword 0xd17e40cfd6dde297, 0x7dec2dbc84762dad
d_2_4:          .dword 0x33cc35987f2dd0e5, 0x9d1e47a3e877dde0
d_2_5:          .dword 0xab7a00d201b841fa, 0x5d386202242e6a5b
d_2_6:          .dword 0x06c7a5301149c118, 0xd85d1c2a8dfa3283
d_2_7:          .dword 0xe3b6f845b43fd38f, 0x787183519dd88e92
d_2_8:          .dword 0xe73fd36cde511668, 0xc2aeee4950be86d8
d_2_9:          .dword 0x08831e806dc4a911, 0x5f52e25c3b74f4fb
d_2_10:         .dword 0x5bbf64daa0f72bfe, 0x830cb640c9d970e1
d_2_11:         .dword 0x1d0470de5add357b, 0xe3020feeb680f05d
d_2_12:         .dword 0xa66d9a997dc3fec7, 0xb1de2fc526faf816
d_2_13:         .dword 0xaf9b0e3ce5d62df8, 0x7748075d3d86cd8c
d_2_14:         .dword 0x48144c51f9376bbd, 0x460957ce78decbb5
d_2_15:         .dword 0x0df758dd76f66ca6, 0xfbb9c9722bb0e66d
d_2_16:         .dword 0x43771fc91b204eeb, 0xeb8be4bf27cac9b5
d_2_17:         .dword 0x3c88fec20acb17a3, 0xeddbafb166927d03
d_2_18:         .dword 0x844a589ed6f85ee9, 0x1a32044fbc9238c8
d_2_19:         .dword 0x9127515455ae28cf, 0x65e6f7ea0e35f41f
d_2_20:         .dword 0x9229058e27e2ea4a, 0xc1d64590cc5d594d
d_2_21:         .dword 0xa23dcfcb2cb08a8e, 0x572c120c0592cfe7
d_2_22:         .dword 0x8a62368d9f2c0e34, 0x2ac138fba535df40
d_2_23:         .dword 0x4c59666699bc48aa, 0x1b3edc32da350b2d
d_2_24:         .dword 0x80956247ee16d18e, 0x086e679576e5b0f7
d_2_25:         .dword 0x320e09761fa793ee, 0x7e13597617775c45
d_2_26:         .dword 0xcac8deaa27478371, 0x94f4b2326d52cea3
d_2_27:         .dword 0x71d8dc19f18bded2, 0xabc86cffed1505d9
                .dword 0x72cee28182c35866, 0x9534f9f6f5fc5137
                .dword 0x6479d166c00e2b34, 0x9fa19d8c98600125
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xb0f5f04e18748ed3, 0xa17b27a909d43cbf
                .dword 0x7ee3eca8a6365bdf, 0x8c32202041ed8757
d_3_0:          .dword 0x7e11e58f68d75e46, 0x0b281d8d190341ba
d_3_1:          .dword 0xc0515e9a74464c02, 0x77d1896751f33771
d_3_2:          .dword 0xe8ea09b447f6fefb, 0xd981455cd22a6d73
d_3_3:          .dword 0xc6ce198ec6d63f91, 0xd80368dfc5aa7b65
d_3_4:          .dword 0x1e36ae0cbb0d773e, 0x6b128c51b2a72508
d_3_5:          .dword 0x374e02bc8c8cef6c, 0x3014e2972db2ace3
d_3_6:          .dword 0x14a9ecbe8742a762, 0xf9b0e084150f26df
d_3_7:          .dword 0x9130a9f50874619f, 0xdc5a37fb00b30344
d_3_8:          .dword 0xf22330a0a050ca05, 0xb51646084cff4de2
d_3_9:          .dword 0x140ce8ed68212330, 0x94859bca9408d091
d_3_10:         .dword 0x45634ee4bea1c8fa, 0x0a28e83f731331f5
d_3_11:         .dword 0x1de696763cd2016b, 0xd596709c8e4b3418
d_3_12:         .dword 0x5671047419e00663, 0xc51b6c68262e0baa
d_3_13:         .dword 0xe1b98eb1aa22605c, 0xaa8d2009720c945a
d_3_14:         .dword 0x27add0fc8ecbaa4d, 0x95ec268b9e48258d
d_3_15:         .dword 0xf768f16c4f1004d7, 0x4c0321863a267661
d_3_16:         .dword 0x9f6c006ebbbfe7e5, 0xaf6309de1611e7e6
d_3_17:         .dword 0x6b835c3bfc43f687, 0xfaf020cc27550ba0
d_3_18:         .dword 0x49a1221be9a4c054, 0x5c82b6151762e171
d_3_19:         .dword 0xd6339e004c792bdd, 0x159f9b51bc4623c4
d_3_20:         .dword 0x703547b6413facba, 0xfd03d3b81c4fbe5a
d_3_21:         .dword 0x2a2d37a87f1eb706, 0xdcefac6d85de70fa
d_3_22:         .dword 0xd7bcbb45c2a2f75b, 0x9f9fa6449c8189f6
d_3_23:         .dword 0xe908b0924c52ed89, 0x754d23e5391cb469
d_3_24:         .dword 0x05b6067af8d9e17f, 0x206eb9a40632aa5b
d_3_25:         .dword 0xe404e02ff124cdfd, 0x7a84f8348c4701ba
d_3_26:         .dword 0xed49b0b5e264c027, 0xde5a93a0506f7cb4
d_3_27:         .dword 0x05bef7816ec2ecc8, 0x1d9b94f62d228c11
                .dword 0xf757abfed524181d, 0xd34807b3f7312fc1
                .dword 0x714ebafecc063db3, 0xe254bcada976bf34
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x442f3f09dd93e1aa, 0x31b21aacd7e35497
                .dword 0xc21a2b9173424662, 0x7b51738a128edd32
d_4_0:          .dword 0x96271276998190b9, 0x01d4084dd1c4d5cc
d_4_1:          .dword 0x5f16ee6d8cad6010, 0xdd53f209217aa677
d_4_2:          .dword 0xce0703bbbe86f63f, 0x7adc72728ad8c589
d_4_3:          .dword 0xb03c5b9552f5edc2, 0x295a10601b75a9e7
d_4_4:          .dword 0xb9652c29fe30545a, 0x698685776f734e63
d_4_5:          .dword 0x117989b6ef093413, 0x207d71706f400a95
d_4_6:          .dword 0xf02beadc70a7ce95, 0x0423247cde012c3f
d_4_7:          .dword 0x344a8ac38d089382, 0xf94a9c3b95bc9a4f
d_4_8:          .dword 0xbf125398ae97ef09, 0x82cc4cd97a687bbe
d_4_9:          .dword 0x28990971506a4518, 0x816c514aeeb5f671
d_4_10:         .dword 0x37e675c20c18ca73, 0xe5e7df04bac19be2
d_4_11:         .dword 0x0aa222908f0434f2, 0xd6b9e946558c322c
d_4_12:         .dword 0xf762868eb88d11e4, 0xee8714e14947b29e
d_4_13:         .dword 0xa23e9f86c821234e, 0xaece386d9eb0c554
d_4_14:         .dword 0x3ec7239498c4aff3, 0x9cbe435632bea164
d_4_15:         .dword 0xd6dbdafd6ca6c45e, 0x034fc3a86838005d
d_4_16:         .dword 0x22326e75d308b8d0, 0x207f10d0b1a20a86
d_4_17:         .dword 0xe95ab6c306d2ce68, 0x90823de74686cda7
d_4_18:         .dword 0x360aef52f7b93a2d, 0xfb6fe88c10ff8518
d_4_19:         .dword 0xf64086da163890cd, 0xc21984613b6a034c
d_4_20:         .dword 0x91f38c302643f225, 0xf5a287be920b211d
d_4_21:         .dword 0xefbac870b7bf5286, 0x25357af0ea5d8e1e
d_4_22:         .dword 0x585ed0859a2fee90, 0x4174685c2c3a903a
d_4_23:         .dword 0xe6f582c3adf84ebf, 0x55984ed2ae1d6d54
d_4_24:         .dword 0xe4982d4dd260bb8a, 0xa4a21bf0aee4ab8d
d_4_25:         .dword 0xb5011c5993ad27b6, 0x3932a0b71e4bf62b
d_4_26:         .dword 0x4dd069581765790e, 0x8264650b9364a75a
d_4_27:         .dword 0xa8de0e39838e30e9, 0x14cf2570b64c1752
                .dword 0xe032acdfa32be545, 0x450cd907fac03fc5
                .dword 0x2754d52e15d85815, 0x4c3138770cba63e4
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x69493b39d22457a1, 0x33b8d8591867c903
                .dword 0x3f9528742f811b88, 0x04113196de821d0a
d_5_0:          .dword 0x35748663a8cfe638, 0xb4feefe8a3dcc8ad
d_5_1:          .dword 0x3318b9ea2c478c8c, 0x18a218de2cf67580
d_5_2:          .dword 0xe04d537c12ba77e9, 0x44e9faf243ad64ee
d_5_3:          .dword 0x7709956870bbd569, 0x61a316973605abc3
d_5_4:          .dword 0xa57bd54d90eb91a6, 0xd932dc52eb2dc8e2
d_5_5:          .dword 0x685f99ce6bd2d78d, 0x62226a7d5193381b
d_5_6:          .dword 0x3415cec43f537456, 0x31085173ab1c0cdf
d_5_7:          .dword 0x5b8bae169c151831, 0xf9c2e7b44f03e573
d_5_8:          .dword 0x75c12cf93279a567, 0x9b933552b38d9797
d_5_9:          .dword 0x552e635019113d8e, 0xcc6ec68773a19ec6
d_5_10:         .dword 0xc75d4f7fb5ffa3b3, 0x3148243fd2f6f87a
d_5_11:         .dword 0xff3ba85d964a893e, 0x416bedf6709c8ad4
d_5_12:         .dword 0x069bf7172308de5d, 0x3cda901266f47458
d_5_13:         .dword 0x445922b81a286bf2, 0x519d29f72d20a24c
d_5_14:         .dword 0x04a19638b9d0d134, 0xd5323f838b89f27b
d_5_15:         .dword 0x8c6cb37966574d10, 0xea0aa7925e82d099
d_5_16:         .dword 0x0c03d735cadec2ac, 0xa053bd4b65975150
d_5_17:         .dword 0x474cdadcfece4867, 0xeeaef5efe6e30b1d
d_5_18:         .dword 0x752eb9d90dba1c3b, 0xb7471ac770b00591
d_5_19:         .dword 0xe0477cf02d8b98d7, 0x4ed238bf9dd9d041
d_5_20:         .dword 0x5998005fe87c69c0, 0x0630d36c30199bbc
d_5_21:         .dword 0xe138150ea7714f68, 0x2c7d47643a8c119f
d_5_22:         .dword 0x627e89015214c092, 0x285a3bc31c03a21f
d_5_23:         .dword 0x85e1b9ddf2752ad0, 0x257d44e7721ccb92
d_5_24:         .dword 0xc0c0e27914099529, 0x6559950218c7cf9d
d_5_25:         .dword 0x192c477be68df085, 0x5639dbbf1ee9bfd5
d_5_26:         .dword 0xfac8b86d91c47855, 0x3ca2bfcb1f72e917
d_5_27:         .dword 0x7e20fccf81aa5861, 0xdfa37c5a3f282d93
                .dword 0xe6a30b5f4acdf065, 0x50741e0425c9b860
                .dword 0xe7208b1cb0ea2ff1, 0x46fe8c3218c71402
         /* Random data */
_end_data5:
              
                 
