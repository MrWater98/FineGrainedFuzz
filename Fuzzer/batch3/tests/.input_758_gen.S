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
_s0:    fmadd.s f22, f3, f31, f21, rmm            ;
_s1:    xori x6, x23, 2047                        ;
_s2:    li x14, 0                                 ;
        la x6, pt3                                ;
        addi x6, x6, 8                            ;
        sfence.vma x14, x6                        ;
_s3:    la x2, d_3_14                             ;
        lui x29, 0xffe00                          ;
        xor x2, x2, x29                           ;
        ld x17, -16(x2)                           ;
_s4:    remuw x24, x11, x24                       ;
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
_p0:    la x11, d_1_3                             ;
        srai x11, x11, 1                          ;
        csrrs x13, pmpaddr1, x11                  ;
_p1:    xor x14, x14, x14                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 25                         ;
        add x14, x14, x11                         ;
        csrrw x12, mstatus, x14                   ;
_p2:    csrrsi x13, medeleg, 23                   ;
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
_l0:    mulh x20, x24, x12                        ;
_l1:    fcvt.w.s x10, f27, rup                    ;
_l2:    fclass.s x28, f19                         ;
_l3:    srliw x11, x3, 23                         ;
_l4:    la x13, d_4_0                             ;
        addi x13, x13, 0                          ;
        lui x19, 0xffe00                          ;
        xor x13, x13, x19                         ;
        lr.w x29, (x13)                           ;
_l5:    fcvt.wu.s x5, f28, rdn                    ;
_l6:    ecall                                     ;
_l7:    srli x24, x2, 2                           ;
_l8:    fle.s x22, f10, f28                       ;
_l9:    la x12, d_0_17                            ;
        addi x12, x12, -8                         ;
        lr.d x23, (x12)                           ;
_l10:   fadd.s f15, f15, f28, rdn                 ;
_l11:   la x29, d_2_25                            ;
        lwu x10, 20(x29)                          ;
_l12:   sraw x13, x12, x10                        ;
_l13:   la x21, _l164                             ;
        jalr x11, 0(x21)                          ;
_l14:   la x8, d_1_6                              ;
        sw x2, -0(x8)                             ;
_l15:   la x11, d_1_11                            ;
        addi x11, x11, 24                         ;
        amomax.d x20, x28, (x11)                  ;
_l16:   bne x8, x17, _l183                        ;
_l17:   la x7, d_2_26                             ;
        addi x7, x7, -8                           ;
        lui x17, 0xffe00                          ;
        xor x7, x7, x17                           ;
        lr.w x13, (x7)                            ;
_l18:   la x24, _l70                              ;
        jalr x28, 0(x24)                          ;
_l19:   ecall                                     ;
_l20:   la x10, d_1_26                            ;
        addi x10, x10, -16                        ;
        amoor.d x5, x14, (x10)                    ;
_l21:   slli x27, x8, 63                          ;
_l22:   fcvt.lu.s x11, f6, rmm                    ;
_l23:   mulhu x26, x16, x27                       ;
_l24:   bne x25, x20, _l38                        ;
_l25:   fclass.s x5, f24                          ;
_l26:   fsub.s f22, f15, f18, rup                 ;
_l27:   la x23, _l200                             ;
        csrrw zero, mepc, x23                     ;
        mret                                      ;
_l28:   la x27, d_3_24                            ;
        flw f5, -16(x27)                          ;
_l29:   mulw x7, x13, x15                         ;
_l30:   la x26, _l89                              ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l31:   addiw x9, x30, 1905                       ;
_l32:   mulhsu x24, x11, x7                       ;
_l33:   la x15, d_1_17                            ;
        addi x15, x15, 28                         ;
        amominu.w x7, x2, (x15)                   ;
_l34:   fmin.s f28, f27, f8                       ;
_l35:   la x27, _l95                              ;
        jalr x17, 0(x27)                          ;
_l36:   sraiw x11, x7, 31                         ;
_l37:   la x9, d_3_23                             ;
        addi x9, x9, -16                          ;
        sc.d x13, x9, (x9)                        ;
_l38:   la x2, d_2_16                             ;
        lbu x1, -6(x2)                            ;
_l39:   fmv.x.w x4, f18                           ;
_l40:   la x12, _l107                             ;
        csrrw zero, sepc, x12                     ;
        sret                                      ;
_l41:   fsgnjx.s f24, f24, f24                    ;
_l42:   fsgnjx.s f9, f27, f11                     ;
_l43:   subw x21, x10, x10                        ;
_l44:   lui x1, 730614                            ;
_l45:   la x9, _l112                              ;
        lui x6, 0xffe00                           ;
        xor x9, x9, x6                            ;
        lw x25, -0(x9)                            ;
_l46:   la x1, d_3_18                             ;
        lb x13, -29(x1)                           ;
_l47:   bgeu x6, x4, _l58                         ;
_l48:   la x25, d_3_16                            ;
        fsw f4, -4(x25)                           ;
_l49:   addw x5, x17, x11                         ;
_l50:   la x18, d_5_25                            ;
        lwu x15, 20(x18)                          ;
_l51:   fnmadd.s f18, f31, f28, f12, rtz          ;
_l52:   csrrsi x13, sepc, 8                       ;
_l53:   la x17, d_1_19                            ;
        addi x17, x17, -16                        ;
        lui x22, 0xffe00                          ;
        xor x17, x17, x22                         ;
        amomin.d x8, x22, (x17)                   ;
_l54:   fdiv.s f19, f21, f31, rmm                 ;
_l55:   la x21, d_1_11                            ;
        sd x29, 8(x21)                            ;
_l56:   feq.s x2, f5, f5                          ;
_l57:   la x11, d_0_23                            ;
        addi x11, x11, -0                         ;
        amoswap.w x18, x19, (x11)                 ;
_l58:   fcvt.s.w f29, x28, rdn                    ;
_l59:   flt.s x19, f23, f26                       ;
_l60:   fsgnjx.s f12, f0, f18                     ;
_l61:   la x20, d_2_18                            ;
        addi x20, x20, -16                        ;
        amoxor.d x25, x17, (x20)                  ;
_l62:   fcvt.l.s x5, f22, rtz                     ;
_l63:   fnmadd.s f12, f24, f18, f21, rup          ;
_l64:   ori x7, x12, 1347                         ;
_l65:   la x14, d_3_16                            ;
        addi x14, x14, -8                         ;
        lr.w x21, (x14)                           ;
_l66:   la x1, d_4_10                             ;
        addi x1, x1, 0                            ;
        amoor.d x24, x11, (x1)                    ;
_l67:   fsgnj.s f5, f8, f13                       ;
_l68:   fcvt.s.lu f26, x3, rdn                    ;
_l69:   subw x10, x13, x23                        ;
_l70:   li x16, 0                                 ;
        la x28, pt0                               ;
        addi x28, x28, 8                          ;
        sfence.vma x16, x28                       ;
_l71:   fmin.s f25, f11, f24                      ;
_l72:   la x27, d_1_8                             ;
        lbu x11, 30(x27)                          ;
_l73:   remw x18, x6, x28                         ;
_l74:   subw x14, x11, x19                        ;
_l75:   la x19, d_0_9                             ;
        addi x19, x19, -12                        ;
        amomaxu.w x27, x26, (x19)                 ;
_l76:   addw x3, x8, x24                          ;
_l77:   bgeu x31, x8, _l86                        ;
_l78:   xor x25, x25, x25                         ;
        addi x22, zero, 1                         ;
        slli x22, x22, 1                          ;
        add x25, x25, x22                         ;
        csrrs x11, mip, x25                       ;
_l79:   fsqrt.s f18, f27, rup                     ;
_l80:   mulhu x18, x24, x10                       ;
_l81:   fmv.w.x f23, x7                           ;
_l82:   la x1, d_3_16                             ;
        addi x1, x1, 28                           ;
        amominu.w x24, x21, (x1)                  ;
_l83:   la x16, d_2_17                            ;
        addi x16, x16, -8                         ;
        amomaxu.d x24, x8, (x16)                  ;
_l84:   la x10, d_0_4                             ;
        addi x10, x10, 16                         ;
        amoxor.d x21, x21, (x10)                  ;
_l85:   slli x15, x30, 31                         ;
_l86:   mulhu x8, x12, x11                        ;
_l87:   la x9, d_3_2                              ;
        srai x9, x9, 1                            ;
        csrrs x14, pmpaddr0, x9                   ;
_l88:   beq x23, x18, _l96                        ;
_l89:   slli x27, x19, 14                         ;
_l90:   la x3, d_4_6                              ;
        lui x11, 0xffe00                          ;
        xor x3, x3, x11                           ;
        flw f22, 12(x3)                           ;
_l91:   fmax.s f27, f29, f11                      ;
_l92:   bltu x7, x3, _l180                        ;
_l93:   bge x8, x4, _l116                         ;
_l94:   srlw x15, x18, x24                        ;
_l95:   mulw x28, x4, x19                         ;
_l96:   remw x17, x8, x16                         ;
_l97:   la x1, _l132                              ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l98:   srli x8, x26, 6                           ;
_l99:   fcvt.s.l f21, x6, dyn                     ;
_l100:  ebreak                                    ;
_l101:  la x17, d_0_13                            ;
        addi x17, x17, 20                         ;
        sc.w x10, x7, (x17)                       ;
_l102:  la x23, d_4_4                             ;
        addi x23, x23, 20                         ;
        amomaxu.w x11, x10, (x23)                 ;
_l103:  mulw x11, x21, x2                         ;
_l104:  la x27, d_5_25                            ;
        addi x27, x27, -0                         ;
        sc.d x11, x27, (x27)                      ;
_l105:  la x14, d_2_21                            ;
        addi x14, x14, -20                        ;
        lui x7, 0xffe00                           ;
        xor x14, x14, x7                          ;
        amoadd.w x5, x7, (x14)                    ;
_l106:  ori x4, x30, -1493                        ;
_l107:  la x11, d_5_27                            ;
        addi x11, x11, -16                        ;
        lr.d x2, (x11)                            ;
_l108:  sltiu x16, x13, 295                       ;
_l109:  fsub.s f21, f15, f29, rdn                 ;
_l110:  csrrci x3, frm, 0                         ;
_l111:  fence.i                                   ;
_l112:  bge x16, x15, _l191                       ;
_l113:  la x29, d_1_25                            ;
        addi x29, x29, -8                         ;
        amominu.d x21, x9, (x29)                  ;
_l114:  la x11, d_5_7                             ;
        addi x11, x11, -12                        ;
        sc.w x16, x18, (x11)                      ;
_l115:  bltu x7, x26, _l164                       ;
_l116:  fmv.w.x f10, x2                           ;
_l117:  srai x29, x4, 37                          ;
_l118:  slliw x4, x25, 24                         ;
_l119:  fcvt.wu.s x16, f13, rmm                   ;
_l120:  la x9, d_4_1                              ;
        addi x9, x9, 16                           ;
        lui x28, 0xffe00                          ;
        xor x9, x9, x28                           ;
        sc.d x5, x9, (x9)                         ;
_l121:  slti x30, x9, 1927                        ;
_l122:  flt.s x3, f21, f11                        ;
_l123:  la x5, d_5_12                             ;
        addi x5, x5, 4                            ;
        amoand.w x26, x18, (x5)                   ;
_l124:  la x12, d_4_5                             ;
        addi x12, x12, 0                          ;
        amomax.d x7, x25, (x12)                   ;
_l125:  fnmadd.s f14, f17, f15, f30, rup          ;
_l126:  addi x14, x3, 30                          ;
_l127:  fmax.s f10, f25, f5                       ;
_l128:  div x29, x8, x3                           ;
_l129:  addw x9, x28, x22                         ;
_l130:  subw x30, x30, x13                        ;
_l131:  la x23, d_5_16                            ;
        addi x23, x23, 8                          ;
        sc.d x26, x23, (x23)                      ;
_l132:  srlw x1, x23, x24                         ;
_l133:  la x4, _l184                              ;
        csrrw zero, mepc, x4                      ;
        mret                                      ;
_l134:  la x4, d_3_18                             ;
        addi x4, x4, -16                          ;
        lr.d x14, (x4)                            ;
_l135:  la x7, d_3_21                             ;
        addi x7, x7, -8                           ;
        amoswap.d x5, x12, (x7)                   ;
_l136:  fmin.s f31, f6, f26                       ;
_l137:  la x8, d_2_2                              ;
        addi x8, x8, 0                            ;
        amoand.w x2, x17, (x8)                    ;
_l138:  flt.s x8, f13, f6                         ;
_l139:  srai x24, x24, 30                         ;
_l140:  fmin.s f17, f25, f23                      ;
_l141:  mul x14, x20, x25                         ;
_l142:  la x20, d_5_9                             ;
        sw x9, -12(x20)                           ;
_l143:  la x18, d_5_13                            ;
        addi x18, x18, 8                          ;
        amoand.w x26, x23, (x18)                  ;
_l144:  fcvt.s.lu f22, x20, rmm                   ;
_l145:  fclass.s x18, f27                         ;
_l146:  la x22, d_4_26                            ;
        lbu x11, -22(x22)                         ;
_l147:  fence                                     ;
_l148:  la x29, d_1_3                             ;
        flw f4, 0(x29)                            ;
_l149:  flt.s x13, f15, f1                        ;
_l150:  la x4, d_4_10                             ;
        addi x4, x4, -16                          ;
        lui x16, 0xffe00                          ;
        xor x4, x4, x16                           ;
        amoand.d x12, x16, (x4)                   ;
_l151:  la x14, d_5_13                            ;
        addi x14, x14, 0                          ;
        amomin.w x30, x12, (x14)                  ;
_l152:  csrrci x5, fflags, 25                     ;
_l153:  bge x15, x5, _l190                        ;
_l154:  fmv.w.x f19, x15                          ;
_l155:  remuw x0, x26, x15                        ;
_l156:  la x6, d_2_15                             ;
        lwu x11, -0(x6)                           ;
_l157:  la x8, _l193                              ;
        csrrw zero, mepc, x8                      ;
        mret                                      ;
_l158:  feq.s x30, f5, f19                        ;
_l159:  la x12, d_2_4                             ;
        sd x10, -24(x12)                          ;
_l160:  remuw x15, x4, x19                        ;
_l161:  div x19, x17, x1                          ;
_l162:  fsgnjx.s f13, f31, f17                    ;
_l163:  la x21, d_4_6                             ;
        addi x21, x21, -24                        ;
        amoand.d x5, x20, (x21)                   ;
_l164:  csrrci x7, pmpaddr0, 31                   ;
_l165:  la x12, d_2_15                            ;
        addi x12, x12, -16                        ;
        lui x13, 0xffe00                          ;
        xor x12, x12, x13                         ;
        amoswap.d x7, x13, (x12)                  ;
_l166:  srli x17, x25, 30                         ;
_l167:  fmv.x.w x3, f20                           ;
_l168:  fsgnjx.s f12, f5, f7                      ;
_l169:  fcvt.wu.s x16, f18, rmm                   ;
_l170:  srlw x0, x3, x15                          ;
_l171:  la x17, d_1_8                             ;
        fsw f31, 16(x17)                          ;
_l172:  srliw x28, x10, 31                        ;
_l173:  la x30, d_3_4                             ;
        addi x30, x30, -8                         ;
        amoswap.w x15, x6, (x30)                  ;
_l174:  fmul.s f21, f27, f17, rup                 ;
_l175:  flt.s x18, f29, f17                       ;
_l176:  remu x30, x7, x9                          ;
_l177:  la x22, _l179                             ;
        csrrw zero, uepc, x22                     ;
        uret                                      ;
_l178:  la x28, d_5_3                             ;
        addi x28, x28, -0                         ;
        lr.d x30, (x28)                           ;
_l179:  bgeu x2, x2, _l193                        ;
_l180:  bltu x14, x15, _l183                      ;
_l181:  xor x9, x9, x9                            ;
        addi x23, zero, 3                         ;
        slli x23, x23, 8                          ;
        add x9, x9, x23                           ;
        addi x28, zero, 1                         ;
        slli x28, x28, 25                         ;
        add x9, x9, x28                           ;
        addi x24, zero, 3                         ;
        slli x24, x24, 24                         ;
        add x9, x9, x24                           ;
        csrrs x6, sip, x9                         ;
_l182:  fadd.s f4, f21, f5, rmm                   ;
_l183:  la x29, d_5_8                             ;
        addi x29, x29, -0                         ;
        amoadd.d x24, x8, (x29)                   ;
_l184:  xor x6, x6, x6                            ;
        addi x18, zero, 3                         ;
        slli x18, x18, 13                         ;
        add x6, x6, x18                           ;
        csrrs x4, mstatus, x6                     ;
_l185:  fnmsub.s f31, f5, f3, f28, rmm            ;
_l186:  lui x17, 13                               ;
_l187:  la x21, d_1_14                            ;
        addi x21, x21, -24                        ;
        sc.w x3, x15, (x21)                       ;
_l188:  srlw x29, x12, x19                        ;
_l189:  fnmadd.s f30, f26, f25, f1, dyn           ;
_l190:  sraiw x24, x20, 31                        ;
_l191:  xor x24, x24, x24                         ;
        csrrc x6, sepc, x24                       ;
_l192:  la x11, d_4_1                             ;
        addi x11, x11, -12                        ;
        lui x5, 0xffe00                           ;
        xor x11, x11, x5                          ;
        amominu.w x3, x5, (x11)                   ;
_l193:  fence.i                                   ;
_l194:  la x13, d_3_19                            ;
        addi x13, x13, 0                          ;
        lui x22, 0xffe00                          ;
        xor x13, x13, x22                         ;
        amomin.d x11, x22, (x13)                  ;
_l195:  xor x3, x3, x3                            ;
        addi x21, zero, 1                         ;
        slli x21, x21, 9                          ;
        add x3, x3, x21                           ;
        csrrw x26, mepc, x3                       ;
_l196:  ebreak                                    ;
_l197:  fclass.s x2, f5                           ;
_l198:  la x8, _l199                              ;
        csrrw zero, uepc, x8                      ;
        uret                                      ;
_l199:  divuw x23, x9, x21                        ;
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
                .dword 0x50b55e0fda3beb5d, 0xf8d53896e92a9be3
                .dword 0x63f4eae3db91d3f2, 0x86737bce2cb0ac4e
d_0_0:          .dword 0x0de3bf9e329ce7c3, 0xc5358181d268693a
d_0_1:          .dword 0x509b3e01873c9482, 0x98624be1a7a95bb8
d_0_2:          .dword 0x8d9eeb73c4f18708, 0x52294ff8b9b1f586
d_0_3:          .dword 0x894f19fd8d5873d3, 0x7304fa8c96165d2a
d_0_4:          .dword 0x3ce3ccbd8100f6b7, 0x16fc1278d47b9a91
d_0_5:          .dword 0xe599805a7ce8027e, 0x4fd4bd3e2b19ad49
d_0_6:          .dword 0x8351eade6757c24b, 0x7e11e5b0898442e0
d_0_7:          .dword 0x4dbee90cfd729365, 0x6325d6aebc343eb9
d_0_8:          .dword 0x100ca90e5620d895, 0x35461600927077bb
d_0_9:          .dword 0x45be5015e6286981, 0x458ae10cebac9a7c
d_0_10:         .dword 0x31926c9417296d08, 0x87ca2374e51313c9
d_0_11:         .dword 0x8d8e6b69b2eca6a1, 0x1905306989c5c9f5
d_0_12:         .dword 0xdbbc17537288f550, 0x699a9eb1b520c929
d_0_13:         .dword 0xb2b0a7b8ebb61466, 0x11e1e38c4ac270dc
d_0_14:         .dword 0x1182b8889c1212a7, 0x63a72e38368c2830
d_0_15:         .dword 0x9dd27618cb546e32, 0xb71c6aa51367776e
d_0_16:         .dword 0xa13a4c2685bee02f, 0x23adbd87ae477c7b
d_0_17:         .dword 0xc502abd3bd47dc3e, 0x98be3d4356e96651
d_0_18:         .dword 0xe72593f9216cbbfe, 0x7d8397bb81e2d321
d_0_19:         .dword 0xe6d528b1951450ba, 0x9619c652b4478c98
d_0_20:         .dword 0xe86fe36dd0b7fb36, 0x64bf3e5533d92b6d
d_0_21:         .dword 0x2eb51d7dac3fbfaf, 0x4ad46bba0d63ffbe
d_0_22:         .dword 0x34c1ecae6e5c56ca, 0x34639451addff60e
d_0_23:         .dword 0x8505685153876e42, 0x79178c685f2dafc9
d_0_24:         .dword 0xb2dc7ad0a17010dd, 0x242694031335bce8
d_0_25:         .dword 0x379ae848706b79a9, 0x5722fc6424e2ed8e
d_0_26:         .dword 0x78a69ba06f79ca82, 0x98db652d83d1bbfb
d_0_27:         .dword 0x38680725b4f32dd7, 0x72417e08953b9730
                .dword 0x1dbddc976e89d464, 0x0729eb87d7594b4c
                .dword 0x5e2f9fd1bbbe7efc, 0xaca2396e18989fea
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9d6deee376707f60, 0x478559248579b032
                .dword 0x96b8307973b3ac0c, 0xba17f49f3776fc29
d_1_0:          .dword 0x372481c06d555e11, 0x89340d9110420760
d_1_1:          .dword 0xa89e30f172126f0c, 0x5792fe8c76499013
d_1_2:          .dword 0xcfb7794a28dd7466, 0x0935d63dd653a005
d_1_3:          .dword 0xb6d418030ba6a781, 0x7222c615527e9dbb
d_1_4:          .dword 0x30b96c0f4473c251, 0x50ddc181179cb71b
d_1_5:          .dword 0x6dc4be2a95c2a6b4, 0x01e4d30219601277
d_1_6:          .dword 0x02b90a0151293650, 0x58eb5ed2490de51a
d_1_7:          .dword 0xd5a2c95ee0690c49, 0x28dee0dd1c752e75
d_1_8:          .dword 0xde1d88dbf2b91cd8, 0xb42e308ae33e73fb
d_1_9:          .dword 0x1e8aa98cc72c4a86, 0xf717437aa8d0eb05
d_1_10:         .dword 0xa7801b2cc7ebfaa9, 0x1af60142485d3b00
d_1_11:         .dword 0x6ff9d79f57aab412, 0xc77cc054966b29b8
d_1_12:         .dword 0x5a16b375b5702645, 0x99c44a74bd90327c
d_1_13:         .dword 0x9552b57f9f7e8299, 0x909ee14a2ae10369
d_1_14:         .dword 0xf2c1f823d8f0a15c, 0x19fc05b639c33bd0
d_1_15:         .dword 0x356c6284e6743595, 0xfcc7e4f2a8aab925
d_1_16:         .dword 0xfb45a76eb6183968, 0x541a9b5f2a75fc99
d_1_17:         .dword 0xed6d09963757bec5, 0x977b46b5d2fce70f
d_1_18:         .dword 0x7ca95d983a8c4be4, 0x79dd59602b83b8e6
d_1_19:         .dword 0xe01105fc78f29e36, 0x59151e330da28bb7
d_1_20:         .dword 0xfd5b53afd8437537, 0x622dc14c939dd5c4
d_1_21:         .dword 0x25b31ee37b539c20, 0x8c0b0571df3c7759
d_1_22:         .dword 0xe89631c30428d124, 0xad951e7a9b3c86f3
d_1_23:         .dword 0x0d7a425642c59979, 0x9bbe609904eede4e
d_1_24:         .dword 0x10799fe3322f000c, 0x08546eea9b34cdfc
d_1_25:         .dword 0xe5028ab10b53b763, 0x3296c26253f0e36e
d_1_26:         .dword 0x3fdf01db2621396d, 0x28768a298cdbb04d
d_1_27:         .dword 0xf575259c61b6d1db, 0x9b1d3ed09d628044
                .dword 0x2f206efc04d16a3a, 0x050461f5c53b35ff
                .dword 0xc4422d49b406fe23, 0x423bb8ddc0ded29c
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x105452da0023c8f2, 0xe8cabce77745c40f
                .dword 0x2059b604175554d1, 0xc8283fd6ee8abd12
d_2_0:          .dword 0xd0cb625390e8c384, 0x7d4354a64520649e
d_2_1:          .dword 0xfbdf8d0a046e6c8d, 0xb4af887cc632ef48
d_2_2:          .dword 0xf56adf86fe6c5258, 0xd889497bd55878cf
d_2_3:          .dword 0xc8b42348f03ec8d7, 0xf1d54db7e6b5f4f7
d_2_4:          .dword 0xe901d8b46a1a12bf, 0x091e5fde2e96816f
d_2_5:          .dword 0x315334c4f00af736, 0x522e079573b2c612
d_2_6:          .dword 0x3bd431a607bc1003, 0x135cab52f20d379d
d_2_7:          .dword 0x92e35afa3e43bf19, 0x782184967b3d9873
d_2_8:          .dword 0xd41c047e116a5780, 0xf4d19d473f27f5ab
d_2_9:          .dword 0x090fe2fbf13d58a4, 0x0c26393fea58c325
d_2_10:         .dword 0x4b60dc4e24453c09, 0xdab12ab332e1e4f1
d_2_11:         .dword 0x4d68a960f8a87289, 0x2400b1d8da110c9b
d_2_12:         .dword 0xcb6462faf36660a9, 0xccc817172dbfe4f1
d_2_13:         .dword 0xd310ddde55f507e0, 0x2d45d6fee67287a2
d_2_14:         .dword 0x49da0da287ee157b, 0x09d472b55172e2c9
d_2_15:         .dword 0xc7d3ec4b6bdb31d2, 0x463106d40c6c3e33
d_2_16:         .dword 0xc52c0967a591db50, 0xf263aafdcd562c63
d_2_17:         .dword 0x627d91028aca43ca, 0xac16f1fd88419d29
d_2_18:         .dword 0x422f8878705ed3da, 0x268a93f53601bf9f
d_2_19:         .dword 0xf50f34396eb67ee7, 0xfe069af07f7b2e8c
d_2_20:         .dword 0x3edcff99de86ddb7, 0xb48278caf18dbac5
d_2_21:         .dword 0xd99edbf3c3d00bfb, 0x2d4f381fcd44404d
d_2_22:         .dword 0x92d0bbedd0f80c3e, 0x3e8155af72788b6d
d_2_23:         .dword 0xf73cd40b103ddecd, 0xec67e435915792e2
d_2_24:         .dword 0x609bca0883ed4457, 0xc07d4630e2071543
d_2_25:         .dword 0xc10d3a3c92995537, 0xcb4d4433d95aeec6
d_2_26:         .dword 0xdac0094cc30cbdeb, 0xe99258b30e9fc6de
d_2_27:         .dword 0x50b7b8ee0c0de51b, 0x3916eedde9b0b3a1
                .dword 0x59dfa58a71826fb5, 0xfd7db833a26ae369
                .dword 0x6fb90f0730eacdd0, 0x89d82d0472de3330
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x8a566e73f250c4a9, 0xa596e36fb5731bef
                .dword 0xd2604ac925c99b80, 0x287f9d1035934c26
d_3_0:          .dword 0xa205182081c0b986, 0xfb655c7f62ccdd53
d_3_1:          .dword 0xde4b556f3402fda7, 0xb70b4d3e28d5bb0e
d_3_2:          .dword 0xc5378b63d4bc58a4, 0x7a0e743ef2a562f3
d_3_3:          .dword 0xf6841730b54301c4, 0xeb29c9d55089b4ea
d_3_4:          .dword 0x87242fbf8d178a3a, 0xe68f10d517a151d3
d_3_5:          .dword 0x1f9aba75482c8818, 0x1326d77c4bf6bc3e
d_3_6:          .dword 0x0d03e724e15c76a3, 0x3127625043a318d8
d_3_7:          .dword 0x92a23bbd057c8470, 0x297e58775b80f3fa
d_3_8:          .dword 0x2b9f3024dc8fc944, 0xfca33a1ada7e6f41
d_3_9:          .dword 0x428b6d41e0435371, 0x477952c5f24caa99
d_3_10:         .dword 0x2305a111201220d0, 0xf7ea0c72c550c369
d_3_11:         .dword 0x2ebc5e227a9d994e, 0x2194d1c2bc07b7e6
d_3_12:         .dword 0xb701e33d4ec43ceb, 0xc7c0daaec62c69d2
d_3_13:         .dword 0x32a8ba707f906b8d, 0x84c4b6e40f58580d
d_3_14:         .dword 0x02db2c090d3c9a4f, 0x1da3e5546c8b7f96
d_3_15:         .dword 0x17d43f9053076dbb, 0x7d56612d86de95b3
d_3_16:         .dword 0xa20f219a912879da, 0x32a938d12a0aa317
d_3_17:         .dword 0x82e633ecd39c44c0, 0xb5087858b4d156b2
d_3_18:         .dword 0x878f1da3d8175da7, 0x45215f6007b29fc1
d_3_19:         .dword 0xa043d3f3b0abf6ca, 0xe99e3796669abaae
d_3_20:         .dword 0xa649c6f9a3e96193, 0x84d7dd703cd91b74
d_3_21:         .dword 0x92a65add445ffcac, 0xdb0e7946219bdc89
d_3_22:         .dword 0x9580cba180e883eb, 0xea7f5847d553cd3f
d_3_23:         .dword 0x77d911c4c6676dda, 0xaad79009fffaa645
d_3_24:         .dword 0xab1e41bcbb749015, 0xf2458f8d5d4a9391
d_3_25:         .dword 0xfb0bb9aa3c24b1de, 0xd57d3c8b614841cb
d_3_26:         .dword 0x2407b1a6f33ca50b, 0x829384417500a5a6
d_3_27:         .dword 0x0e5575ddb329e199, 0xa6e38e769ed7db6b
                .dword 0x08caec529e30ef75, 0x22d161e27d9b8f57
                .dword 0x742ca6d8a16631db, 0xe9dba50d9790b375
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5305e5733da7ff38, 0xc7f8ead3eb3f4cc9
                .dword 0x9afc81e37825a7c2, 0xacb7e660822d27e4
d_4_0:          .dword 0x415a652312f73ddc, 0x1d17684c92487c66
d_4_1:          .dword 0x128c030076bbdb72, 0xea75ad8986fc2c44
d_4_2:          .dword 0x9c1f26a91444c9da, 0xc77c03f4122881c4
d_4_3:          .dword 0xc512e5147f337986, 0xde0abf780d09e373
d_4_4:          .dword 0x76167d420194e06b, 0x159e479822d1fa86
d_4_5:          .dword 0x7035100592cfdcdf, 0xed0fad3bce798e35
d_4_6:          .dword 0x21c8ce7db1127fa2, 0x705c2591816c564f
d_4_7:          .dword 0xc1ce4802003691ab, 0x96c5514280be6df1
d_4_8:          .dword 0xfbc8052358a808d6, 0xaf193d2c27e08444
d_4_9:          .dword 0x00b94ead89e505ca, 0xb4192e9c757703f9
d_4_10:         .dword 0xa0af29bddf892c48, 0xbad7f84405125159
d_4_11:         .dword 0x1ef4ea4f05e25825, 0x46322d8e09524814
d_4_12:         .dword 0x791382685c37d9e8, 0x3fd0116614213992
d_4_13:         .dword 0x121faa09456d989a, 0xb5e7745f303cd5e9
d_4_14:         .dword 0x29b5ee713ef26d6f, 0x02f2c48502022704
d_4_15:         .dword 0x33df56f3d941d3a9, 0x575b71d6f17e6402
d_4_16:         .dword 0xf5cccebde3d44cab, 0x27867446cbffe7ea
d_4_17:         .dword 0x048030baedef2f26, 0x4709d66875924bdb
d_4_18:         .dword 0x844d28c4a799f621, 0xc20e4148802f6c43
d_4_19:         .dword 0x9efa9dccc46566be, 0xb2ff62427d48d446
d_4_20:         .dword 0x2655ea007257fb70, 0x7692781055ddf97d
d_4_21:         .dword 0x1c83878e0f8f6775, 0x8896bf8f1fabfb76
d_4_22:         .dword 0xdb760d0fead85690, 0xee7bad5be6bee7de
d_4_23:         .dword 0xf4ef621e7a39931e, 0x6a527ae219ca5f1e
d_4_24:         .dword 0x36f123b0f70015d0, 0x2616ab86d59b3204
d_4_25:         .dword 0x0832dd41ad64dc3a, 0xc0ec7ca720b8d208
d_4_26:         .dword 0x0deeb197397df5ef, 0x06104ff59731005e
d_4_27:         .dword 0xcb732ec7c649ba5c, 0x29a5bc094333b1b2
                .dword 0xac0f223fefaf3915, 0x19e928649682530f
                .dword 0xbec5cf6505ddab26, 0x977df868e78fec5e
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x6bfd3ffd4a7fffce, 0xc380d1be82f06b21
                .dword 0x038d525de4890da0, 0x0097762576911a17
d_5_0:          .dword 0x954559002cbce9a3, 0x7b8e7bd8cd110b45
d_5_1:          .dword 0xd3b9de71a7000287, 0xffd84694c17e89b5
d_5_2:          .dword 0x3458e46372180852, 0x6140518a641871cb
d_5_3:          .dword 0x0ebd93c5aad37535, 0xd9a5c3955e6a3242
d_5_4:          .dword 0x5e43dcec4cddff06, 0xbc2a27ddeed99211
d_5_5:          .dword 0x885d4842b9977cdb, 0x2d39bc02aab68ac8
d_5_6:          .dword 0x8394170e81b9d57d, 0xd2ed7a0ac9a0e558
d_5_7:          .dword 0xaacf7230e909bfd3, 0xda8f2b21e5f74af4
d_5_8:          .dword 0xe8174b330bf6ffa8, 0x6db8269b5df8717d
d_5_9:          .dword 0x0549f9534209d18e, 0x5dd2849fef8c824a
d_5_10:         .dword 0xc4da9496f9d311b7, 0x035aba40728063e1
d_5_11:         .dword 0x6e4fb3c7ac4fc7be, 0x0d3224fe3af7380e
d_5_12:         .dword 0x365069e9616f0951, 0x441aa0182ed46fb6
d_5_13:         .dword 0x100563942148ae55, 0x4138c71bd5c23b19
d_5_14:         .dword 0x97867e6ad20a0bd3, 0xce0c3253f86de18c
d_5_15:         .dword 0x484cf1ed60b1e150, 0x9bc6069efb69d85f
d_5_16:         .dword 0x4894d62422be8d28, 0x1e5e182cbdd39108
d_5_17:         .dword 0x8561dfa2cfe6aced, 0xe9f10ec2af26d9b7
d_5_18:         .dword 0x0ead6468484994f2, 0xc6da07b2eb2ca66c
d_5_19:         .dword 0xc8112a3b90b5d0b0, 0x34eecfe3676e01e1
d_5_20:         .dword 0x7c886b058f06e64b, 0xb9198b174b2fa979
d_5_21:         .dword 0xbf1ec69baa9f17ee, 0x4be81f8218a80cae
d_5_22:         .dword 0x046e88370d6a370e, 0xc991d7ce830a5f64
d_5_23:         .dword 0x84cf9df470a8368b, 0x81f4466fd7586799
d_5_24:         .dword 0x6852b8a7bb174327, 0x0d5c818fe876b71c
d_5_25:         .dword 0x4451436521725ab7, 0x491d4310e32c1d77
d_5_26:         .dword 0x82c7c994b5f4f852, 0xca95d523deb51690
d_5_27:         .dword 0x6cb4ccb2fee11182, 0x3bdd4b67963c8385
                .dword 0xa918262f8c2589a3, 0x2baa5e112a49881f
                .dword 0x295c53a9a3d23714, 0xf5c95e6ee4829f2d
         /* Random data */
_end_data5:
              
                 
