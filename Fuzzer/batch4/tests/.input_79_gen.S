# See LICENSE for license details.

#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "riscv_test.h"
#include "fuzz_test.h"

# entry.S

#if __riscv_xlen == 64
# define STORE    sd
# define LOAD     ld
# define REGBYTES 8
#else
# define STORE    sw
# define LOAD     lw
# define REGBYTES 4
#endif

#define TESTEND gp
#define STACK_TOP (_end + 4096)

  .section ".text.init","ax",@progbits
  .global _start
  .align 2
_start:
  j handle_reset
  
  /* NMI vector */
  .align 2
nmi_vector:
  j wtf

  .align 2
trap_vector:
  j wtf

  .global _fuzz_prefix
  init_mie;
_fuzz_prefix:
_p0:    xor x10, x10, x10                         ;
        csrrw x10, sscratch, x10                  ;
_p1:    csrrci x10, pmpaddr2, 30                  ;
_p2:    csrrsi x10, mcause, 30                    ;
_p3:;
    /* Fuzz Prefix */
    /**/
_end_prefix:
    ret

handle_reset:
INIT_XREGS

  la t0, trap_mtvec 
  csrw mtvec, t0
  la sp, STACK_TOP - SIZEOF_TRAPFRAME_T
  csrr t0, mhartid
  slli t0, t0, 12
  add sp, sp, t0
  csrw mscratch, sp
  li a0, MSTATUS_FS
  csrs mstatus, a0
  call init_freg
  la a0, userstart
  j vm_boot

init_freg:
INIT_FREGS

        ret
        .align;

  .global trap_stvec
trap_stvec:
        clear_sie;
_fuzz_suffix:
_s0:    la x4, d_4_22                             ;
        sd x14, -0(x4)                            ;
_s1:    la x10, d_0_16                            ;
        addi x10, x10, 24                         ;
        amoand.w x19, x14, (x10)                  ;
_s2:    la x23, d_4_8                             ;
        addi x23, x23, 20                         ;
        amoadd.w x19, x16, (x23)                  ;
_s3:    fmv.w.x f30, x17                          ;
_s4:    la x24, d_1_21                            ;
        addi x24, x24, -4                         ;
        amoor.w x19, x5, (x24)                    ;
_s5:;
        /* Fuzz trap */
        /**/
_end_suffix:
        ecall

  .global trap_mtvec
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


  .global pop_tf
pop_tf:
  LOAD  t0,33*REGBYTES(a0)
  csrw  sepc, t0
  LOAD  x1,1*REGBYTES(a0)
  LOAD  x2,2*REGBYTES(a0)
  LOAD  x3,3*REGBYTES(a0)
  LOAD  x4,4*REGBYTES(a0)
  LOAD  x5,5*REGBYTES(a0)
  LOAD  x6,6*REGBYTES(a0)
  LOAD  x7,7*REGBYTES(a0)
  LOAD  x8,8*REGBYTES(a0)
  LOAD  x9,9*REGBYTES(a0)
  LOAD  x11,11*REGBYTES(a0)
  LOAD  x12,12*REGBYTES(a0)
  LOAD  x13,13*REGBYTES(a0)
  LOAD  x14,14*REGBYTES(a0)
  LOAD  x15,15*REGBYTES(a0)
  LOAD  x16,16*REGBYTES(a0)
  LOAD  x17,17*REGBYTES(a0)
  LOAD  x18,18*REGBYTES(a0)
  LOAD  x19,19*REGBYTES(a0)
  LOAD  x20,20*REGBYTES(a0)
  LOAD  x21,21*REGBYTES(a0)
  LOAD  x22,22*REGBYTES(a0)
  LOAD  x23,23*REGBYTES(a0)
  LOAD  x24,24*REGBYTES(a0)
  LOAD  x25,25*REGBYTES(a0)
  LOAD  x26,26*REGBYTES(a0)
  LOAD  x27,27*REGBYTES(a0)
  LOAD  x28,28*REGBYTES(a0)
  LOAD  x29,29*REGBYTES(a0)
  LOAD  x30,30*REGBYTES(a0)
  LOAD  x31,31*REGBYTES(a0)
  LOAD  x10,10*REGBYTES(a0)
  sret

  .global trap_entry
  .align 2
trap_entry:
  csrrw sp, sscratch, sp

  STORE x1,1*REGBYTES(sp)
  STORE x3,3*REGBYTES(sp)
  STORE x4,4*REGBYTES(sp)
  STORE x5,5*REGBYTES(sp)
  STORE x6,6*REGBYTES(sp)
  STORE x7,7*REGBYTES(sp)
  STORE x8,8*REGBYTES(sp)
  STORE x9,9*REGBYTES(sp)
  STORE x10,10*REGBYTES(sp)
  STORE x11,11*REGBYTES(sp)
  STORE x12,12*REGBYTES(sp)
  STORE x13,13*REGBYTES(sp)
  STORE x14,14*REGBYTES(sp)
  STORE x15,15*REGBYTES(sp)
  STORE x16,16*REGBYTES(sp)
  STORE x17,17*REGBYTES(sp)
  STORE x18,18*REGBYTES(sp)
  STORE x19,19*REGBYTES(sp)
  STORE x20,20*REGBYTES(sp)
  STORE x21,21*REGBYTES(sp)
  STORE x22,22*REGBYTES(sp)
  STORE x23,23*REGBYTES(sp)
  STORE x24,24*REGBYTES(sp)
  STORE x25,25*REGBYTES(sp)
  STORE x26,26*REGBYTES(sp)
  STORE x27,27*REGBYTES(sp)
  STORE x28,28*REGBYTES(sp)
  STORE x29,29*REGBYTES(sp)
  STORE x30,30*REGBYTES(sp)
  STORE x31,31*REGBYTES(sp)
  csrrw t0,sscratch,sp
  STORE t0,2*REGBYTES(sp)
  csrr  t0,sstatus
  STORE t0,32*REGBYTES(sp)
  csrr  t0,sepc
  STORE t0,33*REGBYTES(sp)
  csrr  t0,sbadaddr
  STORE t0,34*REGBYTES(sp)
  csrr  t0,scause
  STORE t0,35*REGBYTES(sp)

  move  a0, sp
  j handle_trap

RVTEST_RV64U
# RVTEST_CODE_BEGIN
        .text;
        .global extra_boot;
extra_boot:
        EXTRA_INIT
        ret;
        .global userstart;
userstart:
_fuzz_main:
_l0:    ecall                                     ;
_l1:    subw x9, x30, x12                         ;
_l2:    fmin.s f3, f8, f22                        ;
_l3:    la x14, d_3_15                            ;
        addi x14, x14, -28                        ;
        amoor.w x20, x19, (x14)                   ;
_l4:    la x30, d_5_16                            ;
        sw x5, -16(x30)                           ;
_l5:    fmsub.s f30, f1, f20, f21, rup            ;
_l6:    divw x25, x22, x5                         ;
_l7:    la x30, _l129                             ;
        csrrw zero, sepc, x30                     ;
        sret                                      ;
_l8:    mulhu x30, x14, x26                       ;
_l9:    blt x14, x14, _l102                       ;
_l10:   xori x6, x17, -2047                       ;
_l11:   fmv.w.x f21, x9                           ;
_l12:   la x15, d_4_6                             ;
        srai x15, x15, 1                          ;
        csrrc x29, pmpaddr7, x15                  ;
_l13:   la x12, _l154                             ;
        flw f1, -8(x12)                           ;
_l14:   jal x3, _l66                              ;
_l15:   slti x15, x2, -30                         ;
_l16:   la x15, d_0_24                            ;
        addi x15, x15, -8                         ;
        lui x28, 0xffe00                          ;
        xor x15, x15, x28                         ;
        amoand.d x3, x28, (x15)                   ;
_l17:   la x5, d_2_19                             ;
        sh x5, -0(x5)                             ;
_l18:   sllw x0, x14, x7                          ;
_l19:   lui x27, 449207                           ;
_l20:   xor x3, x3, x3                            ;
        addi x9, zero, 1                          ;
        slli x9, x9, 17                           ;
        add x3, x3, x9                            ;
        addi x26, zero, 3                         ;
        slli x26, x26, 23                         ;
        add x3, x3, x26                           ;
        csrrc x4, sie, x3                         ;
_l21:   fmul.s f3, f8, f15, rmm                   ;
_l22:   xor x17, x17, x17                         ;
        csrrw x9, mie, x17                        ;
_l23:   addw x13, x16, x7                         ;
_l24:   feq.s x6, f28, f24                        ;
_l25:   remu x23, x23, x6                         ;
_l26:   la x30, d_4_10                            ;
        sd x14, -8(x30)                           ;
_l27:   bne x12, x12, _l127                       ;
_l28:   sltiu x14, x5, -2047                      ;
_l29:   srliw x16, x29, 0                         ;
_l30:   la x20, d_1_0                             ;
        addi x20, x20, 8                          ;
        amoadd.d x30, x17, (x20)                  ;
_l31:   la x29, _l54                              ;
        lbu x18, 26(x29)                          ;
_l32:   fdiv.s f1, f14, f1, rne                   ;
_l33:   slli x27, x6, 0                           ;
_l34:   fsub.s f2, f24, f12, rne                  ;
_l35:   mulw x3, x7, x2                           ;
_l36:   ebreak                                    ;
_l37:   la x11, d_3_13                            ;
        sd x27, 0(x11)                            ;
_l38:   csrrci x29, medeleg, 12                   ;
_l39:   ecall                                     ;
_l40:   csrrci x12, pmpaddr2, 30                  ;
_l41:   remuw x8, x20, x17                        ;
_l42:   fence.i                                   ;
_l43:   la x13, d_5_22                            ;
        lw x18, 16(x13)                           ;
_l44:   la x9, _l131                              ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l45:   divu x9, x29, x19                         ;
_l46:   sraw x11, x13, x12                        ;
_l47:   la x27, _l144                             ;
        csrrw zero, mepc, x27                     ;
        mret                                      ;
_l48:   fcvt.s.l f20, x0, dyn                     ;
_l49:   mulhsu x17, x2, x19                       ;
_l50:   fmv.x.w x4, f2                            ;
_l51:   andi x17, x12, -1923                      ;
_l52:   fmv.x.w x2, f21                           ;
_l53:   subw x29, x5, x5                          ;
_l54:   la x31, d_3_13                            ;
        addi x31, x31, 28                         ;
        lr.w x11, (x31)                           ;
_l55:   fcvt.s.w f30, x0, dyn                     ;
_l56:   addw x10, x11, x6                         ;
_l57:   la x4, _l11                               ;
        lb x9, -16(x4)                            ;
_l58:   la x21, d_5_25                            ;
        addi x21, x21, -8                         ;
        amoxor.d x25, x17, (x21)                  ;
_l59:   fcvt.w.s x1, f4, rup                      ;
_l60:   la x1, d_5_19                             ;
        addi x1, x1, -0                           ;
        amomaxu.d x16, x20, (x1)                  ;
_l61:   divuw x29, x28, x26                       ;
_l62:   la x13, _l145                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l63:   xor x27, x27, x27                         ;
        addi x18, zero, 3                         ;
        slli x18, x18, 22                         ;
        add x27, x27, x18                         ;
        addi x26, zero, 3                         ;
        slli x26, x26, 7                          ;
        add x27, x27, x26                         ;
        addi x21, zero, 1                         ;
        slli x21, x21, 23                         ;
        add x27, x27, x21                         ;
        csrrs x24, sstatus, x27                   ;
_l64:   andi x2, x22, -2047                       ;
_l65:   bge x25, x18, _l136                       ;
_l66:   la x17, d_0_27                            ;
        lw x1, -0(x17)                            ;
_l67:   auipc x5, 706871                          ;
_l68:   auipc x24, 0                              ;
_l69:   la x28, d_0_18                            ;
        addi x28, x28, -8                         ;
        amoswap.w x10, x15, (x28)                 ;
_l70:   mulh x5, x3, x6                           ;
_l71:   la x23, d_0_10                            ;
        fsw f22, 0(x23)                           ;
_l72:   la x29, d_2_27                            ;
        addi x29, x29, -8                         ;
        amoand.w x2, x22, (x29)                   ;
_l73:   la x30, d_0_16                            ;
        addi x30, x30, 16                         ;
        lui x4, 0xffe00                           ;
        xor x30, x30, x4                          ;
        sc.d x25, x30, (x30)                      ;
_l74:   la x9, d_5_22                             ;
        sw x2, 24(x9)                             ;
_l75:   fsgnj.s f1, f18, f29                      ;
_l76:   la x28, d_1_3                             ;
        addi x28, x28, -0                         ;
        lui x30, 0xffe00                          ;
        xor x28, x28, x30                         ;
        amomin.w x28, x30, (x28)                  ;
_l77:   rem x23, x15, x14                         ;
_l78:   slliw x26, x20, 8                         ;
_l79:   divu x19, x23, x4                         ;
_l80:   la x30, d_1_1                             ;
        addi x30, x30, -12                        ;
        sc.w x22, x9, (x30)                       ;
_l81:   la x14, _l147                             ;
        jalr x9, 0(x14)                           ;
_l82:   la x12, d_4_16                            ;
        addi x12, x12, 12                         ;
        lr.w x9, (x12)                            ;
_l83:   fcvt.s.wu f14, x25, rup                   ;
_l84:   la x7, d_3_23                             ;
        lh x8, 22(x7)                             ;
_l85:   srlw x20, x1, x14                         ;
_l86:   rem x9, x7, x11                           ;
_l87:   beq x6, x27, _l88                         ;
_l88:   la x11, d_0_16                            ;
        addi x11, x11, 0                          ;
        lui x28, 0xffe00                          ;
        xor x11, x11, x28                         ;
        lr.d x19, (x11)                           ;
_l89:   la x8, _l4                                ;
        lhu x27, 8(x8)                            ;
_l90:   addiw x27, x15, -0                        ;
_l91:   la x18, d_0_12                            ;
        addi x18, x18, -0                         ;
        amominu.w x19, x15, (x18)                 ;
_l92:   sllw x14, x29, x17                        ;
_l93:   sraiw x7, x26, 15                         ;
_l94:   la x6, d_0_10                             ;
        addi x6, x6, -20                          ;
        amomaxu.w x9, x22, (x6)                   ;
_l95:   ori x2, x25, -2047                        ;
_l96:   sllw x2, x1, x0                           ;
_l97:   sltiu x26, x7, 1573                       ;
_l98:   fsgnjx.s f8, f15, f31                     ;
_l99:   fsgnj.s f20, f25, f6                      ;
_l100:  la x1, d_4_2                              ;
        sw x3, -12(x1)                            ;
_l101:  rem x18, x18, x29                         ;
_l102:  fmv.w.x f12, x1                           ;
_l103:  slliw x24, x0, 12                         ;
_l104:  srai x19, x19, 24                         ;
_l105:  bltu x28, x18, _l115                      ;
_l106:  la x7, _l116                              ;
        jalr x17, 0(x7)                           ;
_l107:  fmax.s f12, f4, f3                        ;
_l108:  sraiw x16, x22, 23                        ;
_l109:  fence.i                                   ;
_l110:  la x19, d_5_15                            ;
        addi x19, x19, 0                          ;
        amomaxu.d x19, x29, (x19)                 ;
_l111:  la x30, d_5_10                            ;
        addi x30, x30, -24                        ;
        amomin.w x19, x12, (x30)                  ;
_l112:  la x2, d_1_25                             ;
        addi x2, x2, 24                           ;
        amominu.d x20, x25, (x2)                  ;
_l113:  fmv.x.w x14, f8                           ;
_l114:  slliw x30, x22, 21                        ;
_l115:  la x9, d_0_11                             ;
        addi x9, x9, -8                           ;
        amoadd.w x16, x27, (x9)                   ;
_l116:  bne x5, x22, _l120                        ;
_l117:  addi x23, x21, -2047                      ;
_l118:  la x3, d_3_15                             ;
        addi x3, x3, -16                          ;
        amoadd.d x5, x1, (x3)                     ;
_l119:  fcvt.s.wu f25, x18, rne                   ;
_l120:  mulhu x29, x11, x30                       ;
_l121:  la x11, d_3_8                             ;
        addi x11, x11, 24                         ;
        lr.d x17, (x11)                           ;
_l122:  beq x23, x9, _l143                        ;
_l123:  rem x26, x12, x26                         ;
_l124:  bne x2, x23, _l168                        ;
_l125:  la x25, d_2_1                             ;
        addi x25, x25, -28                        ;
        lui x29, 0xffe00                          ;
        xor x25, x25, x29                         ;
        amoor.w x4, x29, (x25)                    ;
_l126:  la x14, d_1_7                             ;
        addi x14, x14, -28                        ;
        amomax.w x24, x25, (x14)                  ;
_l127:  la x1, d_5_7                              ;
        addi x1, x1, 8                            ;
        amomaxu.w x3, x20, (x1)                   ;
_l128:  sllw x14, x23, x9                         ;
_l129:  la x8, d_0_0                              ;
        addi x8, x8, -16                          ;
        lr.w x21, (x8)                            ;
_l130:  la x24, d_3_14                            ;
        addi x24, x24, 0                          ;
        amomaxu.w x23, x2, (x24)                  ;
_l131:  la x20, d_1_10                            ;
        sh x15, -0(x20)                           ;
_l132:  beq x25, x8, _l144                        ;
_l133:  la x12, d_5_21                            ;
        addi x12, x12, 28                         ;
        amoand.w x12, x7, (x12)                   ;
_l134:  la x27, d_0_6                             ;
        lhu x6, 22(x27)                           ;
_l135:  fmin.s f1, f1, f24                        ;
_l136:  fmadd.s f21, f30, f29, f30, rtz           ;
_l137:  fcvt.wu.s x1, f9, rtz                     ;
_l138:  fsub.s f13, f27, f7, rdn                  ;
_l139:  fsgnj.s f22, f27, f21                     ;
_l140:  la x26, d_3_18                            ;
        addi x26, x26, 0                          ;
        amoor.d x9, x30, (x26)                    ;
_l141:  la x4, d_3_6                              ;
        lui x21, 0xffe00                          ;
        xor x4, x4, x21                           ;
        lw x7, 20(x4)                             ;
_l142:  fmin.s f27, f10, f11                      ;
_l143:  la x29, d_5_3                             ;
        addi x29, x29, -0                         ;
        amominu.w x25, x16, (x29)                 ;
_l144:  la x19, d_3_22                            ;
        lui x26, 0xffe00                          ;
        xor x19, x19, x26                         ;
        sw x3, 20(x19)                            ;
_l145:  la x11, d_0_18                            ;
        ld x12, -8(x11)                           ;
_l146:  la x9, _l154                              ;
        jalr x25, 0(x9)                           ;
_l147:  csrrsi x13, sip, 23                       ;
_l148:  bgeu x5, x30, _l171                       ;
_l149:  la x29, d_5_7                             ;
        addi x29, x29, 0                          ;
        sc.d x26, x29, (x29)                      ;
_l150:  fcvt.lu.s x21, f4, dyn                    ;
_l151:  la x5, _l156                              ;
        jalr x14, 0(x5)                           ;
_l152:  csrrsi x23, stval, 10                     ;
_l153:  slti x15, x21, 647                        ;
_l154:  la x28, d_2_12                            ;
        addi x28, x28, 0                          ;
        amoadd.d x1, x30, (x28)                   ;
_l155:  la x16, d_5_20                            ;
        fsw f19, 4(x16)                           ;
_l156:  csrrci x17, mie, 0                        ;
_l157:  xor x4, x4, x4                            ;
        addi x30, zero, 1                         ;
        slli x30, x30, 11                         ;
        add x4, x4, x30                           ;
        addi x17, zero, 1                         ;
        slli x17, x17, 22                         ;
        add x4, x4, x17                           ;
        csrrc x12, sie, x4                        ;
_l158:  divw x9, x21, x27                         ;
_l159:  sraw x3, x27, x24                         ;
_l160:  fcvt.l.s x22, f26, rdn                    ;
_l161:  la x13, d_5_27                            ;
        addi x13, x13, -16                        ;
        amoxor.w x1, x25, (x13)                   ;
_l162:  sltiu x7, x5, 0                           ;
_l163:  la x30, d_2_26                            ;
        addi x30, x30, -8                         ;
        amomaxu.d x5, x12, (x30)                  ;
_l164:  mulw x26, x12, x0                         ;
_l165:  la x3, d_3_15                             ;
        addi x3, x3, 28                           ;
        amominu.w x2, x26, (x3)                   ;
_l166:  csrrwi x7, sepc, 4                        ;
_l167:  la x29, d_5_13                            ;
        lwu x7, 24(x29)                           ;
_l168:  fmadd.s f19, f26, f28, f21, rup           ;
_l169:  srai x14, x3, 24                          ;
_l170:  la x20, d_2_8                             ;
        addi x20, x20, 4                          ;
        amoxor.w x19, x14, (x20)                  ;
_l171:  csrrci x30, mie, 5                        ;
_l172:  andi x25, x1, -1859                       ;
_l173:  la x11, d_3_15                            ;
        addi x11, x11, 0                          ;
        amoxor.d x4, x15, (x11)                   ;
_l174:  fcvt.wu.s x23, f15, rmm                   ;
_l175:;
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

RVTEST_CODE_END

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

    .section .data.random0;
    .align  8;

_random_data0:
                .dword 0xecbdc18d53252d21, 0xea31651a84c259d7
                .dword 0x86b36939886ad3e9, 0x273611dd74ddd169
d_0_0:          .dword 0x57474918559fc45d, 0xb4775d15a7dd0cdb
d_0_1:          .dword 0x308010084006afe6, 0xe6fabaea8642e2f5
d_0_2:          .dword 0x7a0c36b6ac2a7a5b, 0xd3202f15de424c14
d_0_3:          .dword 0xb2a155a1d91becf3, 0x67b8f086f1421419
d_0_4:          .dword 0xb49fac5e58e219bb, 0x6d989bb4a501610f
d_0_5:          .dword 0x91a377647a4b784b, 0x1579119e9e7d1c1c
d_0_6:          .dword 0xfa6f902bb939d3f2, 0x46fe096854ebc568
d_0_7:          .dword 0xded74028d0eb1cfa, 0x3a4b4bb0c56c386c
d_0_8:          .dword 0x72b0aee121966fac, 0xb92de67d15ad6148
d_0_9:          .dword 0xbe8ada86625ad82c, 0x44527f0347d33818
d_0_10:         .dword 0x4555d36c365701ae, 0xfd3ce4df15a58d95
d_0_11:         .dword 0x9b9e078c18195a26, 0x66d295fbf5259832
d_0_12:         .dword 0xe1332200f1b0a16e, 0x71520440824f9fab
d_0_13:         .dword 0x151a45fc6a8496a5, 0x827e82e139c8e869
d_0_14:         .dword 0xca9b65480b09bd07, 0xb67fe86943d1c652
d_0_15:         .dword 0x25f37efdb74d9694, 0x66fd841708c2d4bd
d_0_16:         .dword 0xcdc1ef534f17f0a9, 0xf8437c9d8b761acb
d_0_17:         .dword 0xa6e59882d3e56a3b, 0xc6e2ac2dc8b44a4d
d_0_18:         .dword 0x6881f9f2fdace6d0, 0xe421c4a2099c3860
d_0_19:         .dword 0xe866582a90b73c73, 0x98a4f85806dee798
d_0_20:         .dword 0xe21a1ace8dd13911, 0xa37ceaf3d05ee82d
d_0_21:         .dword 0xc9b52b39c4008be3, 0xd829732c7f16db51
d_0_22:         .dword 0xf0a96d99e6e580ab, 0xa6366fee682bcffd
d_0_23:         .dword 0x9cecc923ad95a914, 0xc8e3103fae09ad2a
d_0_24:         .dword 0xc074d5db95e0d882, 0x0596329719376c2c
d_0_25:         .dword 0x100e303e7a232714, 0x4aa0ba5dd6fbbdf1
d_0_26:         .dword 0x91498b24d62269b7, 0x271434d113505e82
d_0_27:         .dword 0xa154dff96bbb4f20, 0xa9963025a0842233
                .dword 0x30b21c174d754ff3, 0x0e04f24a01d311d8
                .dword 0x483dd31e82784ba0, 0x02ca6bc36b5fb1a5
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa485d476fec2d29c, 0xdc4003b2a815b5f7
                .dword 0x9e04d128c5d4c785, 0x8534ae140665cdc8
d_1_0:          .dword 0x3318cc6bd2084130, 0xa80eda4a023d64f2
d_1_1:          .dword 0x0baf0b63063505fe, 0xe9d357194504c1a1
d_1_2:          .dword 0x1c3120d6cf029fa3, 0x5602f310745f4cc3
d_1_3:          .dword 0x2f863830bff1cd41, 0x6fb96b78c87882f8
d_1_4:          .dword 0xf8c00feb2295ecfa, 0x7a6a97f901b1c6fa
d_1_5:          .dword 0xc3f8c6ee86134c93, 0xc18679c52b623829
d_1_6:          .dword 0x3ec8cebe1ba8bb41, 0x7f9b163b791358fe
d_1_7:          .dword 0x525785f964023535, 0x05a5b64bcb97dc4d
d_1_8:          .dword 0x6874a64154677b85, 0x784f40a7ed455bca
d_1_9:          .dword 0xb99e6d25ea8300a4, 0x179902d321e3606d
d_1_10:         .dword 0x32155f3ef2d308a8, 0xaa2d36da0ad443eb
d_1_11:         .dword 0xb9c4d2889bfd2f0c, 0x072f52ed4d0a6a6d
d_1_12:         .dword 0xde0978e637c27101, 0x69c67e34e7bac006
d_1_13:         .dword 0xcde1a495ef81bda1, 0x82c0137fe08a2f68
d_1_14:         .dword 0xe97226d7e4243ef4, 0x1ed8394c51142ad9
d_1_15:         .dword 0xcad486a75482d066, 0xc72ec2c359db7bca
d_1_16:         .dword 0xffbde468aa7daef8, 0xfb89e8bad728a4e9
d_1_17:         .dword 0x49970bb793dd7e31, 0x0ccf87d9eea3b139
d_1_18:         .dword 0x6d72f6e11bf94272, 0xf4daf1722294977e
d_1_19:         .dword 0xfba493fbe5a563da, 0x1405c47f40b9fabb
d_1_20:         .dword 0xfb827310bbfea2fb, 0x440c5a6df92864c2
d_1_21:         .dword 0x31daae95f84a1d9f, 0x27c807bdadebebd1
d_1_22:         .dword 0x564059ca3dbdb87a, 0x1450072af955b5ab
d_1_23:         .dword 0xaa27a7f945850cba, 0x9c08f087e5734bf5
d_1_24:         .dword 0xd8d2c198b1d05e5f, 0xfb5388a81c12ce9a
d_1_25:         .dword 0xb803cc39e1258e0d, 0x3e2918498fe67570
d_1_26:         .dword 0xf83ce5f387fe400d, 0xc047654bd9a55f95
d_1_27:         .dword 0x59a0410622dc9dd7, 0x67644e3707b9391f
                .dword 0x1dc84dd371ff7c17, 0x68f7178b4707a7f3
                .dword 0x4c78605d3d6003a7, 0x053a4090ff451477
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xaf6a01a9bfb6b385, 0x2035161c054ad57b
                .dword 0x70bb5b3e17e998b9, 0x16732e7263e5be47
d_2_0:          .dword 0x88ce36ebf6449127, 0xa3681fc59edd4648
d_2_1:          .dword 0x15c699d1cbcbd5a7, 0x8f7598b656054e18
d_2_2:          .dword 0x8211d005150f1559, 0x73cc83043d5551e1
d_2_3:          .dword 0xebd5c98ac3ba3c89, 0xd15a1c6b11ca9548
d_2_4:          .dword 0x4d34981b959c4b62, 0x6c172e432227710d
d_2_5:          .dword 0x4a73a24c1eff5db2, 0xac8acfe9471bf733
d_2_6:          .dword 0x7708dec46af2afe0, 0x51695299f6be95a3
d_2_7:          .dword 0xd87d4dfa71706021, 0x9677d7a3698baf1a
d_2_8:          .dword 0x37e7a9079391058c, 0x99bf84916b106ab3
d_2_9:          .dword 0x2e16889a79f05538, 0x0bf26783e983ceb1
d_2_10:         .dword 0x611fb44036bdb0ff, 0xe1eb6ccee260b310
d_2_11:         .dword 0x1a390ba561013869, 0x15f21f69951cd414
d_2_12:         .dword 0x21accff91dfa9df9, 0x4e6ca631895743ec
d_2_13:         .dword 0xdc2f719f41e5ac04, 0x49d7864877cf91fc
d_2_14:         .dword 0x8fedae5065eb64d9, 0x01a5e39f5abbd5a0
d_2_15:         .dword 0xfc84cbb2fec23c1a, 0x5556fd77cb303283
d_2_16:         .dword 0xd0b44fca3992ff79, 0xe8515f8a16a07b3d
d_2_17:         .dword 0x4cece0917a001909, 0xc81ef23e916fec3f
d_2_18:         .dword 0x3dfce8a350c2f0a6, 0xab463383bf53cd5d
d_2_19:         .dword 0xa178121976adfe2c, 0x40b80af8457ffb6e
d_2_20:         .dword 0x90e78c6d28acd3c4, 0x97130d76fe6bf2bb
d_2_21:         .dword 0x44d0a24cf085f124, 0xed5327b42d8417d6
d_2_22:         .dword 0x56765f54738ef11e, 0x9e1d3aca6bbdd982
d_2_23:         .dword 0x72732f911fc8740c, 0x6f26349c45a96a59
d_2_24:         .dword 0x5040ee5f9b2443c8, 0x5e228879b8898af3
d_2_25:         .dword 0x7b396c8dd8de41e4, 0xe4faaa802b5aac40
d_2_26:         .dword 0xbc5c7838bcddeff7, 0x79c9962cd3c4426b
d_2_27:         .dword 0xfdf9ce8682484eee, 0x692032d2528895d8
                .dword 0x2457528511646143, 0x831a34ae88b82a90
                .dword 0x706cfff659ed2417, 0xfa6cd9ed56e54f94
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x90bca478a31da924, 0x269bc4eae3b039fd
                .dword 0x4a9b0e94f2112722, 0x94a9399f221eacd5
d_3_0:          .dword 0xdc980af1d4c6f1c1, 0x76e976491bcaa303
d_3_1:          .dword 0x4fcd4a6f20704973, 0xac321d4469aaaa4a
d_3_2:          .dword 0x24fc7006aa69cba7, 0x0605ee0952921229
d_3_3:          .dword 0x02b7f566947413de, 0x63c44b899a742d22
d_3_4:          .dword 0x1b48d5554d562722, 0xf4a15060c6326a55
d_3_5:          .dword 0xc9cc1eec753ff569, 0xcdd14f8a82a91a66
d_3_6:          .dword 0x6bd893a6cc22a3f6, 0x0f7388132159b9c2
d_3_7:          .dword 0x9f98562ec8426554, 0x88d7342e466c53e2
d_3_8:          .dword 0xbf9688dcbc739255, 0x417c6954081609be
d_3_9:          .dword 0xd761853d8de13f62, 0xee4c08d7891f82b3
d_3_10:         .dword 0xfd035d48bcfd9c66, 0xa7cda3dac7c62319
d_3_11:         .dword 0x8799c2b8bbd79ac6, 0xf0fe0ccc099cb1ca
d_3_12:         .dword 0x2e593b5e9899f7d2, 0xa303207e3e693cf1
d_3_13:         .dword 0x2a4144c680fdbcf7, 0x75fad506152c5d8a
d_3_14:         .dword 0x03e7e76772d64f90, 0x7dac74cc9ffab6e3
d_3_15:         .dword 0xe5470e0becb2b1c8, 0x314bb96e7ca94587
d_3_16:         .dword 0x1b4f3132af8c2204, 0xcdbee71973cfb851
d_3_17:         .dword 0xffddd88fdb346f14, 0xd226161c277875e4
d_3_18:         .dword 0xae89c5f0d5894288, 0xf3a13585b52dca0a
d_3_19:         .dword 0x37e2bdfd5c987784, 0x582ef5b9db96e907
d_3_20:         .dword 0xf5f04d5cf2517a46, 0x51f5b04d619220bb
d_3_21:         .dword 0x9db5b6bd1e837dd0, 0x40936eba84594d0f
d_3_22:         .dword 0xc1572f79688b5a84, 0xd52b2fe4dfcf7b51
d_3_23:         .dword 0xcde127741072296d, 0xe09e9919d5b3ac59
d_3_24:         .dword 0x90b79bcf58fc198f, 0x72590dc377279754
d_3_25:         .dword 0x5e7c844bc9f45026, 0x5f808ae5fac925f7
d_3_26:         .dword 0x59496fc142a36b6e, 0xc6bc43a273481d3e
d_3_27:         .dword 0x959faa51a5e5c8da, 0x20453c2a16c95227
                .dword 0x3508b12a7661858e, 0x7983e7828baf33ce
                .dword 0x9bae40e338ce22d6, 0xc9f16471f7490155
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5b81d6499c8d5720, 0x8b59d76ca86ad3a2
                .dword 0xc5bc31cd615682e9, 0xfabc5afd95a26a4a
d_4_0:          .dword 0x75493962880032a9, 0xddb77d79ec293e05
d_4_1:          .dword 0x5921db23aa3b2c8d, 0xe647db87c4e8c636
d_4_2:          .dword 0x8709848b3aa0a457, 0x146a4bb6e090abcb
d_4_3:          .dword 0xe8831f14575192f9, 0x5f5f47b28472c9a0
d_4_4:          .dword 0x1403ac8b11e9f2cc, 0xe45a95439ec476f5
d_4_5:          .dword 0xa62667cf9ed1864d, 0xc3f969099da46ae5
d_4_6:          .dword 0xd8803d101bf673b2, 0x2420331f5383f688
d_4_7:          .dword 0xb1c234430002634e, 0x4b97d0dd9ce551df
d_4_8:          .dword 0x8bb29b9c51c7e14b, 0xde631b4934999d35
d_4_9:          .dword 0x32593c890170236e, 0xc37e4c1eb2562949
d_4_10:         .dword 0x4db66217bad72081, 0xb22fc920ae5a58db
d_4_11:         .dword 0xb3a8820aa9f8e71f, 0x3ba809b93987cc21
d_4_12:         .dword 0xb458491987d4b542, 0x6eb0466b918b49a5
d_4_13:         .dword 0x9183da0d905ec6e3, 0xa3ca19cc95eb6ff6
d_4_14:         .dword 0xe27ab15f82809c76, 0x559a6ee582c04e25
d_4_15:         .dword 0xe3170e6b0f34fc80, 0x848a6208fe089f82
d_4_16:         .dword 0xe262e97cf12f7c74, 0x6c08da61bf8afcdb
d_4_17:         .dword 0x4e535db18518ca2e, 0xd5a74da5952b0118
d_4_18:         .dword 0x8cf279b5e7bdfc6b, 0xc9b39434366886a3
d_4_19:         .dword 0xc86489727e693964, 0x1d5dc83004553d9d
d_4_20:         .dword 0x06e90290a2602d24, 0x1a6c76ef1b5248d8
d_4_21:         .dword 0x60f30d21ed4e3c6f, 0xb3685572d09b52e7
d_4_22:         .dword 0x59ec4aea9caccd3a, 0x4bc4d8c1b4291cf2
d_4_23:         .dword 0x1d269e56aae63a6e, 0x2a1aae737b41dacc
d_4_24:         .dword 0x84a896ddbb8411fb, 0x5dc2df201498b94e
d_4_25:         .dword 0xd0a72687956448a1, 0x74231a2f95423998
d_4_26:         .dword 0x78663d3628d26778, 0xbf3a91988322392b
d_4_27:         .dword 0x5fd9e52d4c9b00ee, 0xc1304afdaba488d2
                .dword 0x0c760c75d40980a8, 0x44f584a30f82d06d
                .dword 0xc1b96c28a839d30c, 0x5c91695b7688fa97
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x5c367e50a2d126ac, 0x7a93d21ec381d51c
                .dword 0x7aa6da1b9d843f33, 0xca8d6fb0d6407233
d_5_0:          .dword 0x0877e86269418153, 0x1ee4ec8ca295efde
d_5_1:          .dword 0xd1463916cefca35b, 0xa63a2ac2f2f64478
d_5_2:          .dword 0xb74692c93bae70e9, 0xbf0d216fd437e5c0
d_5_3:          .dword 0x92f39d9cc74cf284, 0xa8604cf1f9e19b81
d_5_4:          .dword 0xb8b3b312f1beaef6, 0xa77c83d402821374
d_5_5:          .dword 0x03e587f53a6f1b08, 0x6b6727429103d7bb
d_5_6:          .dword 0x540f7bb421f4ba23, 0x95e0f56e892a06de
d_5_7:          .dword 0xd7e993136fa589a1, 0x400f0d2e0b1ed156
d_5_8:          .dword 0x012b070da90ba7f3, 0x2aee8854d0088b8b
d_5_9:          .dword 0x35be37536bc75eaf, 0xcdc1d0286527aaa4
d_5_10:         .dword 0x9fe12da04fc24a9c, 0x50a026d8c3cebd36
d_5_11:         .dword 0xb310ca199326e566, 0xd5bf974786106c78
d_5_12:         .dword 0x974cbd6bd90b1b69, 0xf7e7e839c6d2471e
d_5_13:         .dword 0x894bbdef14b97cc3, 0xb26cf0bd47f6281e
d_5_14:         .dword 0x921b90858dcc4b75, 0x3c833cbee9b34083
d_5_15:         .dword 0xb09ddbd1aaf3ad90, 0x982241770b31216a
d_5_16:         .dword 0x5b7beffaf7f4d683, 0x95337a4aa86c40d7
d_5_17:         .dword 0x94187d8b7b70f96f, 0xccabe272138804d0
d_5_18:         .dword 0x695dbdf300dd1d3b, 0x3ab78d5ec2701c8b
d_5_19:         .dword 0x42d10a0158addcdc, 0xa4c932dad157b34b
d_5_20:         .dword 0x03a43653f1499e6f, 0x42b1caea16ec978c
d_5_21:         .dword 0xe244390303b94d2c, 0xd032a4417d69e221
d_5_22:         .dword 0x81a24367021c92b9, 0x1961c6b4bb1ad092
d_5_23:         .dword 0xbc15a3f867a44323, 0x3112f63136807136
d_5_24:         .dword 0xe2088bcfb7e04e7b, 0xa230b66d1b6670ee
d_5_25:         .dword 0x8c39ace73381c2f9, 0x43877f29aa784111
d_5_26:         .dword 0x59876fcf0420545d, 0x5ad0c6981dd9a9a8
d_5_27:         .dword 0x81f43a53a33e353c, 0x7a126219749f3abf
                .dword 0xa1974a6a360251b1, 0x6b377199b821d224
                .dword 0x14457b4263c6449d, 0xa55288b7dd79fa06
         /* Random data */
_end_data5:
              
 
