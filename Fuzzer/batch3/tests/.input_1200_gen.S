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
_s0:    la x5, _s2                                ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_s1:    la x12, d_1_13                            ;
        sd x16, 0(x12)                            ;
_s2:    la x16, d_0_0                             ;
        addi x16, x16, -28                        ;
        sc.w x14, x11, (x16)                      ;
_s3:    jal x4, _s5                               ;
_s4:    la x21, d_4_21                            ;
        addi x21, x21, -20                        ;
        sc.w x8, x14, (x21)                       ;
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
_p0:    xor x10, x10, x10                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 2                          ;
        add x10, x10, x11                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 30                         ;
        add x10, x10, x13                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 19                         ;
        add x10, x10, x14                         ;
        csrrw x10, medeleg, x10                   ;
_p1:    xor x13, x13, x13                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 11                         ;
        add x13, x13, x13                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 25                         ;
        add x13, x13, x14                         ;
        csrrc x12, mtval, x13                     ;
_p2:    xor x11, x11, x11                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 12                         ;
        add x11, x11, x10                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 29                         ;
        add x11, x11, x10                         ;
        csrrc x13, pmpcfg0, x11                   ;
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
_l0:    fence.i                                   ;
_l1:    fsgnj.s f25, f22, f14                     ;
_l2:    la x14, d_1_3                             ;
        lwu x13, -28(x14)                         ;
_l3:    blt x24, x21, _l143                       ;
_l4:    la x14, d_0_2                             ;
        addi x14, x14, -8                         ;
        amomaxu.d x11, x13, (x14)                 ;
_l5:    la x4, d_2_16                             ;
        addi x4, x4, 8                            ;
        amominu.d x8, x6, (x4)                    ;
_l6:    la x11, d_1_1                             ;
        lbu x4, 0(x11)                            ;
_l7:    fcvt.w.s x21, f15, rmm                    ;
_l8:    la x3, d_0_4                              ;
        ld x3, 0(x3)                              ;
_l9:    la x23, d_4_18                            ;
        fsw f0, -24(x23)                          ;
_l10:   fnmadd.s f14, f25, f14, f2, rup           ;
_l11:   fcvt.s.w f30, x18, rne                    ;
_l12:   la x25, d_1_11                            ;
        srai x25, x25, 1                          ;
        csrrw x22, pmpaddr1, x25                  ;
_l13:   la x10, _l157                             ;
        jalr x7, 0(x10)                           ;
_l14:   la x11, d_5_23                            ;
        addi x11, x11, 20                         ;
        amomin.w x4, x24, (x11)                   ;
_l15:   la x3, d_3_15                             ;
        addi x3, x3, -20                          ;
        amoor.w x23, x27, (x3)                    ;
_l16:   slti x7, x28, 2047                        ;
_l17:   addw x2, x23, x23                         ;
_l18:   jal x25, _l118                            ;
_l19:   xor x13, x13, x13                         ;
        addi x8, zero, 3                          ;
        slli x8, x8, 24                           ;
        add x13, x13, x8                          ;
        addi x17, zero, 3                         ;
        slli x17, x17, 29                         ;
        add x13, x13, x17                         ;
        csrrs x10, mtval, x13                     ;
_l20:   la x30, d_4_12                            ;
        addi x30, x30, 4                          ;
        amomin.w x25, x6, (x30)                   ;
_l21:   xor x13, x13, x13                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 11                           ;
        add x13, x13, x2                          ;
        addi x15, zero, 3                         ;
        slli x15, x15, 3                          ;
        add x13, x13, x15                         ;
        csrrc x30, frm, x13                       ;
_l22:   auipc x29, 783936                         ;
_l23:   la x21, d_0_27                            ;
        sd x29, 16(x21)                           ;
_l24:   divw x3, x11, x0                          ;
_l25:   la x16, _l163                             ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
_l26:   fcvt.s.l f2, x14, rup                     ;
_l27:   la x11, d_5_15                            ;
        srai x11, x11, 1                          ;
        csrrs x9, pmpaddr1, x11                   ;
_l28:   la x9, d_5_17                             ;
        addi x9, x9, 0                            ;
        amoor.w x25, x30, (x9)                    ;
_l29:   fmadd.s f2, f10, f14, f14, rne            ;
_l30:   addi x4, x1, -1571                        ;
_l31:   fsqrt.s f11, f14, dyn                     ;
_l32:   fcvt.wu.s x25, f0, rup                    ;
_l33:   remw x24, x18, x14                        ;
_l34:   sraiw x26, x4, 27                         ;
_l35:   la x3, _l80                               ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l36:   sraw x11, x11, x15                        ;
_l37:   divw x26, x29, x3                         ;
_l38:   rem x6, x18, x29                          ;
_l39:   fcvt.s.lu f6, x11, rmm                    ;
_l40:   la x2, d_4_5                              ;
        addi x2, x2, -0                           ;
        amoxor.w x2, x22, (x2)                    ;
_l41:   li x13, 0                                 ;
        la x30, pt3                               ;
        addi x30, x30, 0                          ;
        sfence.vma x13, x30                       ;
_l42:   fmv.x.w x20, f9                           ;
_l43:   srliw x19, x9, 22                         ;
_l44:   csrrsi x10, mcause, 31                    ;
_l45:   la x7, d_4_1                              ;
        addi x7, x7, 8                            ;
        amominu.d x16, x14, (x7)                  ;
_l46:   div x25, x10, x3                          ;
_l47:   fle.s x29, f6, f22                        ;
_l48:   beq x15, x12, _l49                        ;
_l49:   la x4, d_2_11                             ;
        addi x4, x4, -0                           ;
        amoswap.d x19, x19, (x4)                  ;
_l50:   fcvt.l.s x12, f10, dyn                    ;
_l51:   la x14, _l163                             ;
        ld x26, 16(x14)                           ;
_l52:   fsgnjn.s f13, f22, f16                    ;
_l53:   slli x14, x12, 21                         ;
_l54:   jal x17, _l195                            ;
_l55:   fmadd.s f6, f0, f14, f10, dyn             ;
_l56:   divuw x19, x4, x25                        ;
_l57:   la x30, d_4_27                            ;
        addi x30, x30, -8                         ;
        amomax.w x21, x11, (x30)                  ;
_l58:   jal x3, _l63                              ;
_l59:   divw x0, x23, x16                         ;
_l60:   fence                                     ;
_l61:   la x17, _l196                             ;
        csrrw zero, sepc, x17                     ;
        sret                                      ;
_l62:   addi x27, x8, -26                         ;
_l63:   fcvt.l.s x1, f3, rup                      ;
_l64:   mulh x16, x1, x29                         ;
_l65:   la x15, d_2_1                             ;
        addi x15, x15, 4                          ;
        amoxor.w x2, x19, (x15)                   ;
_l66:   la x3, d_0_9                              ;
        addi x3, x3, 8                            ;
        sc.d x1, x3, (x3)                         ;
_l67:   la x3, d_2_15                             ;
        addi x3, x3, -0                           ;
        amominu.d x18, x25, (x3)                  ;
_l68:   fcvt.s.lu f15, x6, rne                    ;
_l69:   la x6, d_5_22                             ;
        lb x21, -3(x6)                            ;
_l70:   ebreak                                    ;
_l71:   fmsub.s f24, f2, f6, f13, dyn             ;
_l72:   fle.s x30, f31, f27                       ;
_l73:   fcvt.s.l f30, x26, rdn                    ;
_l74:   la x4, d_0_8                              ;
        addi x4, x4, -8                           ;
        lui x20, 0xffe00                          ;
        xor x4, x4, x20                           ;
        amoadd.d x19, x20, (x4)                   ;
_l75:   mulw x4, x27, x1                          ;
_l76:   la x12, d_0_20                            ;
        addi x12, x12, -4                         ;
        amominu.w x9, x20, (x12)                  ;
_l77:   ebreak                                    ;
_l78:   fdiv.s f4, f8, f15, dyn                   ;
_l79:   sllw x3, x9, x1                           ;
_l80:   remw x29, x26, x17                        ;
_l81:   la x25, _l90                              ;
        csrrw zero, mepc, x25                     ;
        mret                                      ;
_l82:   blt x27, x21, _l188                       ;
_l83:   sraw x3, x30, x13                         ;
_l84:   fence                                     ;
_l85:   sltiu x0, x0, -1640                       ;
_l86:   addi x1, x7, 1328                         ;
_l87:   fcvt.s.wu f12, x27, dyn                   ;
_l88:   blt x26, x11, _l92                        ;
_l89:   ori x25, x29, 2047                        ;
_l90:   xor x15, x15, x15                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 9                          ;
        add x15, x15, x11                         ;
        addi x29, zero, 3                         ;
        slli x29, x29, 15                         ;
        add x15, x15, x29                         ;
        csrrs x30, sepc, x15                      ;
_l91:   flt.s x20, f13, f23                       ;
_l92:   srlw x0, x15, x11                         ;
_l93:   la x18, _l152                             ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l94:   jal x29, _l165                            ;
_l95:   lui x4, 580821                            ;
_l96:   fnmadd.s f15, f3, f24, f8, rne            ;
_l97:   feq.s x28, f31, f23                       ;
_l98:   la x5, _l106                              ;
        srai x5, x5, 1                            ;
        csrrs x13, pmpaddr6, x5                   ;
_l99:   subw x15, x19, x6                         ;
_l100:  la x28, d_2_10                            ;
        addi x28, x28, 0                          ;
        lr.w x6, (x28)                            ;
_l101:  li x29, 1                                 ;
        la x5, pt1                                ;
        addi x5, x5, 0                            ;
        sfence.vma x29, x5                        ;
_l102:  la x7, d_5_16                             ;
        addi x7, x7, 0                            ;
        lui x29, 0xffe00                          ;
        xor x7, x7, x29                           ;
        amomaxu.d x18, x29, (x7)                  ;
_l103:  div x26, x5, x24                          ;
_l104:  mulhu x27, x28, x3                        ;
_l105:  la x19, d_4_14                            ;
        addi x19, x19, 16                         ;
        sc.d x21, x19, (x19)                      ;
_l106:  lui x5, 160620                            ;
_l107:  fsqrt.s f15, f0, rne                      ;
_l108:  la x8, d_3_18                             ;
        addi x8, x8, 4                            ;
        amoxor.w x19, x4, (x8)                    ;
_l109:  divw x22, x23, x19                        ;
_l110:  addw x1, x11, x30                         ;
_l111:  la x18, d_4_20                            ;
        addi x18, x18, 24                         ;
        amoxor.w x19, x31, (x18)                  ;
_l112:  bge x15, x26, _l168                       ;
_l113:  sraw x24, x6, x14                         ;
_l114:  flt.s x22, f6, f30                        ;
_l115:  remw x10, x8, x0                          ;
_l116:  la x9, d_3_10                             ;
        sd x22, 8(x9)                             ;
_l117:  fmsub.s f10, f28, f13, f18, rup           ;
_l118:  fle.s x4, f15, f13                        ;
_l119:  xor x2, x2, x2                            ;
        addi x30, zero, 3                         ;
        slli x30, x30, 25                         ;
        add x2, x2, x30                           ;
        addi x8, zero, 1                          ;
        slli x8, x8, 24                           ;
        add x2, x2, x8                            ;
        csrrc x8, mscratch, x2                    ;
_l120:  fence                                     ;
_l121:  divu x20, x5, x1                          ;
_l122:  la x20, d_4_18                            ;
        addi x20, x20, 4                          ;
        amomaxu.w x12, x6, (x20)                  ;
_l123:  la x2, d_0_0                              ;
        lhu x16, -26(x2)                          ;
_l124:  srai x17, x9, 50                          ;
_l125:  fcvt.w.s x27, f10, rne                    ;
_l126:  divu x1, x15, x19                         ;
_l127:  mul x8, x3, x1                            ;
_l128:  fnmsub.s f8, f7, f8, f14, rup             ;
_l129:  fclass.s x9, f3                           ;
_l130:  la x22, d_2_26                            ;
        addi x22, x22, 28                         ;
        amoxor.w x7, x28, (x22)                   ;
_l131:  mul x17, x21, x28                         ;
_l132:  la x21, d_3_3                             ;
        addi x21, x21, 8                          ;
        amominu.w x16, x30, (x21)                 ;
_l133:  la x13, d_2_6                             ;
        lui x17, 0xffe00                          ;
        xor x13, x13, x17                         ;
        ld x17, -8(x13)                           ;
_l134:  remu x29, x12, x27                        ;
_l135:  slliw x7, x8, 14                          ;
_l136:  fmv.w.x f7, x20                           ;
_l137:  feq.s x15, f24, f15                       ;
_l138:  la x4, _l190                              ;
        flw f31, 0(x4)                            ;
_l139:  la x25, d_5_4                             ;
        ld x26, 24(x25)                           ;
_l140:  flt.s x29, f8, f20                        ;
_l141:  fmax.s f6, f25, f10                       ;
_l142:  bge x20, x16, _l171                       ;
_l143:  bltu x22, x30, _l166                      ;
_l144:  la x23, _l176                             ;
        csrrw zero, mepc, x23                     ;
        mret                                      ;
_l145:  fence.i                                   ;
_l146:  la x23, d_4_10                            ;
        lui x10, 0xffe00                          ;
        xor x23, x23, x10                         ;
        lbu x8, 8(x23)                            ;
_l147:  fadd.s f23, f31, f18, rmm                 ;
_l148:  slti x5, x13, 876                         ;
_l149:  la x13, d_0_1                             ;
        addi x13, x13, 0                          ;
        amomax.d x21, x15, (x13)                  ;
_l150:  mulw x20, x15, x13                        ;
_l151:  fmax.s f23, f27, f20                      ;
_l152:  bne x29, x30, _l200                       ;
_l153:  la x21, d_4_15                            ;
        addi x21, x21, 0                          ;
        amoswap.w x18, x30, (x21)                 ;
_l154:  beq x22, x10, _l187                       ;
_l155:  feq.s x30, f5, f20                        ;
_l156:  mulh x25, x23, x10                        ;
_l157:  div x5, x26, x22                          ;
_l158:  rem x10, x2, x14                          ;
_l159:  srai x7, x16, 24                          ;
_l160:  blt x26, x9, _l179                        ;
_l161:  la x6, d_0_22                             ;
        lbu x24, 17(x6)                           ;
_l162:  fnmadd.s f18, f12, f13, f20, rmm          ;
_l163:  fmsub.s f0, f9, f6, f0, rtz               ;
_l164:  la x2, d_0_6                              ;
        addi x2, x2, -28                          ;
        amomin.w x21, x14, (x2)                   ;
_l165:  la x13, d_4_11                            ;
        addi x13, x13, 16                         ;
        amomax.w x21, x27, (x13)                  ;
_l166:  la x10, d_3_10                            ;
        addi x10, x10, 16                         ;
        amominu.w x22, x25, (x10)                 ;
_l167:  la x29, d_1_8                             ;
        lui x26, 0xffe00                          ;
        xor x29, x29, x26                         ;
        lw x10, 8(x29)                            ;
_l168:  fnmadd.s f16, f2, f12, f7, dyn            ;
_l169:  srli x24, x2, 3                           ;
_l170:  fmin.s f22, f9, f5                        ;
_l171:  andi x28, x11, 132                        ;
_l172:  sltiu x20, x26, 12                        ;
_l173:  mulhu x11, x23, x3                        ;
_l174:  fcvt.l.s x30, f17, dyn                    ;
_l175:  la x22, d_4_23                            ;
        addi x22, x22, -16                        ;
        amoor.w x28, x24, (x22)                   ;
_l176:  fnmadd.s f12, f12, f8, f22, rup           ;
_l177:  ori x30, x16, 24                          ;
_l178:  jal x16, _l183                            ;
_l179:  fcvt.s.l f1, x3, dyn                      ;
_l180:  fcvt.s.w f27, x20, rtz                    ;
_l181:  la x21, d_3_5                             ;
        addi x21, x21, -16                        ;
        sc.d x24, x21, (x21)                      ;
_l182:  fcvt.s.wu f23, x12, rne                   ;
_l183:  la x18, _l188                             ;
        csrrw zero, uepc, x18                     ;
        uret                                      ;
_l184:  srai x2, x2, 16                           ;
_l185:  sraiw x28, x7, 0                          ;
_l186:  fsgnjx.s f12, f6, f27                     ;
_l187:  fcvt.w.s x6, f8, rtz                      ;
_l188:  la x28, d_5_9                             ;
        sb x10, 31(x28)                           ;
_l189:  csrrci x30, satp, 9                       ;
_l190:  la x9, d_3_27                             ;
        addi x9, x9, 24                           ;
        amoor.w x20, x1, (x9)                     ;
_l191:  srai x7, x30, 63                          ;
_l192:  fadd.s f1, f20, f24, rtz                  ;
_l193:  la x16, _l198                             ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l194:  fcvt.s.lu f21, x12, rtz                   ;
_l195:  beq x23, x28, _l200                       ;
_l196:  sltiu x16, x2, 614                        ;
_l197:  la x11, d_2_23                            ;
        addi x11, x11, -0                         ;
        lr.d x11, (x11)                           ;
_l198:  la x11, d_5_1                             ;
        fsw f15, 0(x11)                           ;
_l199:  beq x20, x26, _l200                       ;
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
                .dword 0xfff3b5a32582af6a, 0xb7ca7f3d4f167a7b
                .dword 0xbb8f4095b6914ae3, 0xebc351a517067dcf
d_0_0:          .dword 0x680a557b6620ccb1, 0xd18e004048fe9b17
d_0_1:          .dword 0x76d5f0090cef0dd5, 0x1765b441f462d06d
d_0_2:          .dword 0xc6335f00c01f69a5, 0x744f93089a1e25c9
d_0_3:          .dword 0x70908506ed9b05b9, 0xc677f0018477845e
d_0_4:          .dword 0x4c0c18920503895b, 0x8f4f1e199b6819fb
d_0_5:          .dword 0xcd718c6180b6a1fd, 0x4f4434c45f506395
d_0_6:          .dword 0x1b85165d5bda2c88, 0x2aaa451b853f875d
d_0_7:          .dword 0x870e347174c2a8b2, 0x1cc291c34c6150c5
d_0_8:          .dword 0xa8455fa8a63a6b84, 0x9a9d5679c80d19f8
d_0_9:          .dword 0x3318de95b876b73f, 0xb121d18dab2ead16
d_0_10:         .dword 0x5ec8897e909e0026, 0x43e76a88a5ce6986
d_0_11:         .dword 0x12926db13266212e, 0x6d31b0dd8d38155f
d_0_12:         .dword 0xf46b6b3b8c9caa36, 0x54a669da0e8a6c3d
d_0_13:         .dword 0xbbc389ee966c378c, 0xde096b975f98792f
d_0_14:         .dword 0x0746bb158b3fdc66, 0x85d1bbf20a1bcfa8
d_0_15:         .dword 0x0d7a10b5e919f57e, 0x360ace8d120e3d1d
d_0_16:         .dword 0x1c8f517359585dc0, 0xc4c033a2d90a0a7d
d_0_17:         .dword 0x4974066fc48036f3, 0x639647a41b54ef7b
d_0_18:         .dword 0xf9c925ae9866848e, 0x7e6493a1b07b8471
d_0_19:         .dword 0x11087d0eda057ae5, 0x2e5747d6344910e0
d_0_20:         .dword 0xd83b7397a416926e, 0x98397a32262c2e14
d_0_21:         .dword 0xb77ca0cf60673d68, 0x03d489d3f1b20424
d_0_22:         .dword 0xf9c2e4b4115c6469, 0x9f64f6a7a7fac894
d_0_23:         .dword 0x40bcc1f8ce5723c1, 0xd8051266224f95d9
d_0_24:         .dword 0x90119bc034371370, 0xc755ab547bdb54ea
d_0_25:         .dword 0xedfc02b46a0aff2a, 0x345a0534f429896f
d_0_26:         .dword 0xe149b2e667244efc, 0xe950a6c75facbdd6
d_0_27:         .dword 0x0b06686af4b22116, 0x77043f17d9963cbe
                .dword 0xe7d0cf4114e54f3b, 0x668a728364b5611d
                .dword 0xf520a8e2d1f130a8, 0x8c856d6faebf3a72
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9bd6cac6880fc31a, 0x6cdc174fcb3179a4
                .dword 0xb0bc044d3902f693, 0x6dfd86093647c31f
d_1_0:          .dword 0x3d3d9a89ac54e98f, 0x4e2ad8949e4fb564
d_1_1:          .dword 0x2db9bb7fd38bfcf0, 0x81d37ad0b4c9c1ab
d_1_2:          .dword 0x2daca91c54a28ab4, 0x3c0c4a3eefb257e2
d_1_3:          .dword 0xad45c78c5522e43c, 0xf341b473294f2d0b
d_1_4:          .dword 0xdcd48e6d269b4535, 0x8cfb1903d09c8bf0
d_1_5:          .dword 0xf7d91b2152e80e07, 0x48b3e80c7d54f58c
d_1_6:          .dword 0x13b9a84d7aa4ccf6, 0x3c1c835f1f68d171
d_1_7:          .dword 0xdc285db56aae6a15, 0x23f7eaaa54f2ea36
d_1_8:          .dword 0x30d63cc5b969d2d4, 0x3fd41b718544ff69
d_1_9:          .dword 0x63e04d5b77e904fc, 0xb01470cd2aec4d67
d_1_10:         .dword 0x9289cfdc81331aca, 0xca55ca89776217a5
d_1_11:         .dword 0x66c7c88aa46f6819, 0xc62b4c565b2d4a8e
d_1_12:         .dword 0x5407699d07fc6ded, 0x7a9b6be27c98f737
d_1_13:         .dword 0x9d939108e3eebd5d, 0x07a33a8cc8af14ae
d_1_14:         .dword 0x4b4a3fac0e8e35de, 0x26000a658d66234c
d_1_15:         .dword 0x6c95960e69711ab8, 0xd1b2748384784803
d_1_16:         .dword 0x6b7b16b21a25ccd5, 0x3ef7e32782f8bf77
d_1_17:         .dword 0xf6a2e05319136141, 0x041ccaca66e05051
d_1_18:         .dword 0x800ff46b87b5ee28, 0xb2d92613e60f85be
d_1_19:         .dword 0x0b82c003fd6c066c, 0x244cfdc286ea03e0
d_1_20:         .dword 0x185b12b9a20da629, 0x9c7420143bf0e061
d_1_21:         .dword 0x79db1601c33ad590, 0x595c6618272ff040
d_1_22:         .dword 0xec9fae1d77e6a06e, 0x6f8d9e4daf15b32e
d_1_23:         .dword 0x862c73bb981b1d8d, 0x9ad3b5a77e76b956
d_1_24:         .dword 0x8325211ca74985a9, 0x17f1abc3669709f6
d_1_25:         .dword 0xe6369a104c89beac, 0xd47f1b05ab0e01bb
d_1_26:         .dword 0xbb6fe2f2d8cdc900, 0x42ea030a8ff7a749
d_1_27:         .dword 0xc708748381efa5bb, 0xaee273ab0435fb77
                .dword 0x8aff8c6aab5149ff, 0x07e1a0ad28b363a2
                .dword 0x8e7fe1f080b40177, 0x4e9aac55de6ede3b
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x6d6d3830ccffbee7, 0xfef58097e042343b
                .dword 0x6a436e6f069fdbda, 0x7aa1bcdd2f55ec73
d_2_0:          .dword 0x84be22da348cd593, 0xb3313ee03d9bda98
d_2_1:          .dword 0x6b1f38b702f94668, 0xd4272b0ab285f8c2
d_2_2:          .dword 0x552f5b0992923801, 0x89764464a1221f77
d_2_3:          .dword 0x261d6356b085f4ed, 0x733cd983ab576274
d_2_4:          .dword 0xd565802dd6b6cd9f, 0x9e8329614ddff58f
d_2_5:          .dword 0xfc836451c96e35e3, 0x448e1ee23d1a6392
d_2_6:          .dword 0xe161520d6c066fef, 0x26939bda509b2253
d_2_7:          .dword 0x6ff5c7d20d9d34c1, 0x194d8fd6a8f0f4b3
d_2_8:          .dword 0x420eb6f6b1f220a1, 0x2992f994a65e92c7
d_2_9:          .dword 0x1cda94ff72c46e76, 0x72832e506266f826
d_2_10:         .dword 0x13efcb3c31621049, 0xfdd654f095e2a47e
d_2_11:         .dword 0x0eacc9f835d5ff18, 0xa957d3aed58f6c76
d_2_12:         .dword 0x22eca64e5eef4134, 0x15637343b34f900b
d_2_13:         .dword 0xf308860d037115ad, 0xe72c8cb512d4a119
d_2_14:         .dword 0x7eede4a38e2c5bd9, 0x7e5c350e5f04055b
d_2_15:         .dword 0x38b897820307ef48, 0x6ff203a0f06b103a
d_2_16:         .dword 0xb420bfe42493e656, 0x2c962eda48086d20
d_2_17:         .dword 0x6baad383fd88296f, 0xe58a5ffe67551ede
d_2_18:         .dword 0xfe3d8fe72a0c4588, 0x093b2585cfc13316
d_2_19:         .dword 0xc93247d75eab51cd, 0xf4b274665d47bd58
d_2_20:         .dword 0xe16aa45f0e7afbca, 0x915cfcfb14cd895b
d_2_21:         .dword 0xb61bb020adcbddc1, 0x572d0ad793f3d15d
d_2_22:         .dword 0xb211949c16c55803, 0xfe31b2fd6e7ea8c0
d_2_23:         .dword 0xdae9dc9a34d574a1, 0x36bc3b186fe072e9
d_2_24:         .dword 0x04380876216c3a47, 0x1e3807fcc1bc8e16
d_2_25:         .dword 0x3f73b90e2b53c5f9, 0xfc201dfe76395344
d_2_26:         .dword 0xcab663a9f251d96e, 0x6accef80756509f5
d_2_27:         .dword 0xfec226d42877d53b, 0x605a97cfc5f13a50
                .dword 0x310fb41e32170a6e, 0xc326ae0bd7d9f1e4
                .dword 0x7900fbac7d7e904a, 0x37ca3ddaf3be16fb
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x73d1acac563377fc, 0x0f8fe8eb45c7970b
                .dword 0x2dbf565044803f10, 0xd38b4d3c37311d76
d_3_0:          .dword 0xf0249c14b53cc5e0, 0x4f99f682be544dad
d_3_1:          .dword 0x7bef9cdd70974c56, 0x26de6bc4934e4332
d_3_2:          .dword 0x00248f2c7a251e52, 0x252c86d4ba158699
d_3_3:          .dword 0xd8cf5c15c2a26f83, 0x2e45b4a2d30b1b9c
d_3_4:          .dword 0xf43e95cda3f7d4d1, 0x26e150e1aaa2c35f
d_3_5:          .dword 0x2d92a8055bf9fba3, 0x2dff098da8fdef67
d_3_6:          .dword 0xe9f12e8f1b8be004, 0xfc0c877ada4d978e
d_3_7:          .dword 0xd2819b01921be40a, 0x5d279443ddfc9d76
d_3_8:          .dword 0x046f595e9e08733e, 0xf2363744402d64fc
d_3_9:          .dword 0x9985b11bfbe3e968, 0x18b2cc495afea740
d_3_10:         .dword 0x62c3b67f792654d3, 0xef3290b6309a700b
d_3_11:         .dword 0x37320d52022c19bb, 0x724e05eca4189d7c
d_3_12:         .dword 0x086b8d252cdded6e, 0x29dcadbc069eb75b
d_3_13:         .dword 0xa5028f7edeb71b15, 0x36ab44d5874929a2
d_3_14:         .dword 0x1008bbdbee316bb9, 0x2dade344d54cdad4
d_3_15:         .dword 0x3ffddbeb0e75bd63, 0xd8c5c24482de7c5f
d_3_16:         .dword 0xe7d078ceca61cc79, 0x6993eb6127d900bb
d_3_17:         .dword 0x87dbfb15b4638872, 0xed335eae332a2b7e
d_3_18:         .dword 0xb83fa09131c2b2f9, 0x174da5fe73d685db
d_3_19:         .dword 0xe430753ece858828, 0x31e62164237e0aef
d_3_20:         .dword 0x90df936710d5eb7e, 0x37bfd36ecafedf72
d_3_21:         .dword 0x1ec7e09bee516ce8, 0xd363b0d494f05046
d_3_22:         .dword 0x75875a23285928d3, 0xf7c87445fde2ef40
d_3_23:         .dword 0x82838758ec55498c, 0xfdc22a198f85a3fa
d_3_24:         .dword 0x5105f9a6e0d179e4, 0x44a47ececf55b48d
d_3_25:         .dword 0x1ec7df855c5830a0, 0xc78f4e852e7cb256
d_3_26:         .dword 0x0e343f9c41c816fa, 0x7e943858f7a1e316
d_3_27:         .dword 0x098fe70623edb7a6, 0xdaaf807947f088f2
                .dword 0xfcc78ff0cdc96de0, 0xe5de53b24261af34
                .dword 0x75e3c83ac15e811f, 0x1a653b2b72f9bdbf
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x25254376cb7072be, 0x1873e33bc807cdf1
                .dword 0x6767ecc6f78d1679, 0xd03c56891c76070a
d_4_0:          .dword 0x11e1621e8f3d9df5, 0x6ee2edc097e6d1f1
d_4_1:          .dword 0x7ad3814702306d73, 0x12852527e45e22f8
d_4_2:          .dword 0xbbe89cf4139f58b1, 0xb8df2fdd1e1b68d1
d_4_3:          .dword 0x36399c0f631b7126, 0x90dcab2cfe2516c7
d_4_4:          .dword 0xb0bfc095cce6d858, 0xae0a498d616f8621
d_4_5:          .dword 0x301965c209ae6057, 0xee47084128c1f2dd
d_4_6:          .dword 0xf0ba76ab26def423, 0xd6715b17ea22b90f
d_4_7:          .dword 0xcd0a647a72e37ce0, 0xedb668da3a1467b7
d_4_8:          .dword 0x724d6a927ffbbf4d, 0x2ef0e4bc563442f9
d_4_9:          .dword 0x83e730fe81f45323, 0x580cf44a85aa16b7
d_4_10:         .dword 0x0be96925dc5f3692, 0xc56ccb98554d03b7
d_4_11:         .dword 0x485e4d86c8db57e9, 0xa562734052363ec5
d_4_12:         .dword 0x634ced7df87e4c50, 0x1c04c9be53af81e5
d_4_13:         .dword 0x98873ba41e3e3e00, 0x7f975370ea71990c
d_4_14:         .dword 0xbebbca3b3119e295, 0xdc6851a031eff787
d_4_15:         .dword 0x4496d4f720734482, 0xffb9db3f0bbaacae
d_4_16:         .dword 0xffa53c775233ef1b, 0x617aea99e489a695
d_4_17:         .dword 0xdc14b85e7d60ece8, 0x93fd199603a85abe
d_4_18:         .dword 0x993a5e5ab7855e41, 0x2ea5ff2d6934e478
d_4_19:         .dword 0x044334acf709884d, 0x550fe79bbd75d1b0
d_4_20:         .dword 0x9b946b7db53c4709, 0x565325ee3b13d0ff
d_4_21:         .dword 0x498a590ab21560d1, 0x162e1f8efeda24f9
d_4_22:         .dword 0x58f928ba5a6f35fb, 0x4427959de86ab4ad
d_4_23:         .dword 0x1bbd92c0cc1bde1d, 0xc0654d9544c6b4a5
d_4_24:         .dword 0xa23a6691a13f8184, 0xa1e981fbd4eec6e2
d_4_25:         .dword 0x0d883cd0ebe4d59e, 0x226785be2471ea16
d_4_26:         .dword 0x2985c711b3ef04d5, 0xfccb1ee14c59a23a
d_4_27:         .dword 0xa5cb7a9420ea8376, 0x5882f20ed495ad02
                .dword 0xccdd6fbe8856a23a, 0x0a804a73dd103d31
                .dword 0xc322c2a5d3a79f9e, 0x8fdf45b4e4d84d6b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x9f7efde85e89f7b1, 0x4444ffaf820e1101
                .dword 0xfe20c467f49e95fd, 0x8c123eea1fd7c41d
d_5_0:          .dword 0x6fdf0b9f7c4a3c68, 0x02c29d64be347374
d_5_1:          .dword 0x1ddf50538f4e4271, 0x14d485b8d3868e2b
d_5_2:          .dword 0xeda79de9cf707939, 0xb1ce7e005652e3ad
d_5_3:          .dword 0x92c98f1f5086b9ff, 0x6a51fd7d187cc612
d_5_4:          .dword 0xe0d1d3757af9a61d, 0x10f45557167246a3
d_5_5:          .dword 0xeb6e1a025ff26c72, 0x71cf34f430206607
d_5_6:          .dword 0xc3af7ca2b8b42250, 0xe4a3159527665476
d_5_7:          .dword 0x9acad11e9e7e0f54, 0xacd036a245216b67
d_5_8:          .dword 0x19375319c19c9dde, 0x0cd90198f5a8595b
d_5_9:          .dword 0x5e01b877c77ebf72, 0xa40a0e109261000a
d_5_10:         .dword 0x4dbbda191c927a2c, 0x62c341e565255ec6
d_5_11:         .dword 0x09464c8103a246a9, 0xcbd6c914078b633c
d_5_12:         .dword 0xaad0b6f333a46384, 0xf600e2b1346780b1
d_5_13:         .dword 0x19b39ffd2d43699d, 0xa9b0a2f3a6ef7f32
d_5_14:         .dword 0x193403c157ca9177, 0xd3d29aa30a55d313
d_5_15:         .dword 0xc2628519ab2b85a9, 0x9b5e6e009e8e54eb
d_5_16:         .dword 0x51a5b487aab7f06e, 0x168398a5b84ccb61
d_5_17:         .dword 0xdbffc66d21c8dffe, 0xeb1d1cb78907a97a
d_5_18:         .dword 0x58e688ea3885a48e, 0xb519f220a0fe50cc
d_5_19:         .dword 0x632a96da86556600, 0xa50147fe901b4e46
d_5_20:         .dword 0x823b93a436a09413, 0xe367a3f310c83dac
d_5_21:         .dword 0x6d2afc271b0fb780, 0x0064ab84a44de620
d_5_22:         .dword 0x61ea1ba78bd77c71, 0x47f4913e0f120c7f
d_5_23:         .dword 0xe88ff14244a158b3, 0xd1bd7bc00161e8b9
d_5_24:         .dword 0x246e76e22d5758d2, 0xbb28c50c24f9ee07
d_5_25:         .dword 0x2d24c3a80394edec, 0x8f305c7936fea2ec
d_5_26:         .dword 0x094c8579785d137e, 0x5775073b21dad580
d_5_27:         .dword 0x6d6f7a0bdb9a9cf5, 0x2283e6ffa77a2b8b
                .dword 0xf1261a229007a0d6, 0xafb7f73c998023c3
                .dword 0x0b91f8e08b492cf0, 0xe9f2bcfbba238bf0
         /* Random data */
_end_data5:
              
                 
