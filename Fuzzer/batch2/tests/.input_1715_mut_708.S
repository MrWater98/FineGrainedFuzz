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
_p0:    csrrsi x10, medeleg, 30                   ;
_p1:    xor x10, x10, x10                         ;
        csrrc x12, mstatus, x10                   ;
_p2:;
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
_s0:    li x1, 1                                  ;
        la x14, pt0                               ;
        addi x14, x14, 24                         ;
        sfence.vma x1, x14                        ;
_s1:    fsgnj.s f27, f12, f18                     ;
_s2:    la x10, _s4                               ;
        csrrw zero, uepc, x10                     ;
        uret                                      ;
_s3:    fsub.s f23, f20, f20, dyn                 ;
_s4:    la x16, d_2_27                            ;
        addi x16, x16, -24                        ;
        sc.w x9, x23, (x16)                       ;
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
_l0:    srai x12, x25, 18                         ;
_l1:    la x16, d_4_10                            ;
        addi x16, x16, 24                         ;
        amomaxu.d x16, x10, (x16)                 ;
_l2:    mulhsu x2, x16, x1                        ;
_l3:    la x28, d_4_7                             ;
        addi x28, x28, -0                         ;
        amoor.d x15, x29, (x28)                   ;
_l4:    fence                                     ;
_l5:    la x2, d_3_23                             ;
        addi x2, x2, 8                            ;
        sc.d x17, x2, (x2)                        ;
_l6:    mulhsu x22, x23, x15                      ;
_l7:    la x8, d_2_21                             ;
        addi x8, x8, -24                          ;
        amoswap.d x10, x28, (x8)                  ;
_l8:    la x17, d_0_25                            ;
        flw f27, 28(x17)                          ;
_l9:    li x23, 1                                 ;
        la x3, pt0                                ;
        addi x3, x3, 8                            ;
        sfence.vma x23, x3                        ;
_l10:   fnmadd.s f5, f12, f22, f18, rup           ;
_l11:   la x1, d_3_16                             ;
        addi x1, x1, -24                          ;
        amomax.w x1, x25, (x1)                    ;
_l12:   srlw x17, x28, x0                         ;
_l13:   la x26, d_4_17                            ;
        addi x26, x26, 0                          ;
        sc.d x3, x26, (x26)                       ;
_l14:   la x6, d_4_10                             ;
        addi x6, x6, -16                          ;
        amoor.d x23, x3, (x6)                     ;
_l15:   xori x4, x1, 25                           ;
_l16:   fcvt.w.s x12, f0, rup                     ;
_l17:   la x9, d_2_17                             ;
        addi x9, x9, -28                          ;
        lui x23, 0xffe00                          ;
        xor x9, x9, x23                           ;
        amomax.w x21, x23, (x9)                   ;
_l18:   la x17, d_3_17                            ;
        addi x17, x17, 28                         ;
        amoand.w x1, x25, (x17)                   ;
_l19:   fence                                     ;
_l20:   la x28, _l145                                     ;
        csrrw zero, uepc, x28                     ;
        uret                                      ;
_l21:   fsqrt.s f10, f23, rup                     ;
_l22:   bltu x3, x8, _l27                                 ;
_l23:   la x1, d_5_7                              ;
        lui x9, 0xffe00                           ;
        xor x1, x1, x9                            ;
        lbu x11, 1(x1)                            ;
_l24:   divu x29, x25, x3                         ;
_l25:   la x23, d_2_18                            ;
        addi x23, x23, 0                          ;
        amoxor.w x11, x24, (x23)                  ;
_l26:   mulhu x15, x15, x28                       ;
_l27:   csrrsi x6, satp, 18                       ;
_l28:   fsub.s f10, f23, f1, rmm                  ;
_l29:   la x28, d_5_18                            ;
        sd x6, 16(x28)                            ;
_l30:   la x9, d_2_25                             ;
        addi x9, x9, -0                           ;
        amoand.w x18, x18, (x9)                   ;
_l31:   la x9, d_0_5                              ;
        addi x9, x9, -0                           ;
        amoadd.w x21, x4, (x9)                    ;
_l32:   mulw x29, x17, x27                        ;
_l33:   bne x27, x27, _l95                        ;
_l34:   fmadd.s f11, f0, f31, f21, rup            ;
_l35:   fcvt.lu.s x3, f21, rne                    ;
_l36:   mulw x23, x13, x8                         ;
_l37:   fnmsub.s f30, f4, f5, f13, rdn            ;
_l38:   rem x27, x26, x30                         ;
_l39:   bne x10, x25, _l75                                ;
_l40:   divu x9, x12, x21                         ;
_l41:   slti x21, x28, -0                         ;
_l42:   srli x4, x23, 13                          ;
_l43:   la x7, d_2_8                              ;
        addi x7, x7, 28                           ;
        amomax.w x13, x16, (x7)                   ;
_l44:   sltiu x26, x30, 18                        ;
_l45:   fmv.w.x f12, x19                          ;
_l46:   fsgnjn.s f23, f6, f26                     ;
_l47:   fsgnj.s f7, f10, f14                      ;
_l48:   xor x13, x13, x13                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 25                           ;
        add x13, x13, x7                          ;
        csrrc x12, fcsr, x13                      ;
_l49:   la x20, d_3_22                            ;
        addi x20, x20, 0                          ;
        amoadd.d x29, x20, (x20)                  ;
_l50:   la x19, d_0_27                            ;
        lwu x16, -0(x19)                          ;
_l51:   la x25, d_4_16                            ;
        sh x1, -14(x25)                           ;
_l52:   fmadd.s f16, f22, f0, f10, rne            ;
_l53:   la x26, d_4_14                            ;
        addi x26, x26, -16                        ;
        amomin.d x25, x18, (x26)                  ;
_l54:   la x4, d_0_21                             ;
        addi x4, x4, -0                           ;
        lui x11, 0xffe00                          ;
        xor x4, x4, x11                           ;
        amomaxu.d x27, x11, (x4)                  ;
_l55:   beq x19, x28, _l78                                ;
_l56:   la x13, _l94                              ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l57:   fcvt.s.w f20, x0, dyn                     ;
_l58:   la x3, _l76                                       ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l59:   srai x17, x27, 61                         ;
_l60:   mulhsu x28, x13, x6                       ;
_l61:   xor x30, x30, x30                         ;
        csrrc x18, satp, x30                      ;
_l62:   la x25, d_1_23                            ;
        addi x25, x25, -16                        ;
        amoor.w x3, x20, (x25)                    ;
_l63:   rem x17, x30, x2                          ;
_l64:   fsgnjn.s f3, f20, f27                     ;
_l65:   fence.i                                   ;
_l66:   la x3, d_0_17                             ;
        lhu x17, -28(x3)                          ;
_l67:   lui x17, 14                               ;
_l68:   xori x5, x1, 429                          ;
_l69:   li x8, 1                                  ;
        la x4, pt0                                ;
        addi x4, x4, 24                           ;
        sfence.vma x8, x4                         ;
_l70:   mul x30, x3, x29                          ;
_l71:   csrrwi x29, mie, 4                        ;
_l72:   divw x18, x30, x17                        ;
_l73:   csrrwi x13, pmpaddr3, 7                   ;
_l74:   la x27, d_1_25                            ;
        addi x27, x27, -16                        ;
        sc.d x4, x27, (x27)                       ;
_l75:   ebreak                                    ;
_l76:   la x18, d_5_11                            ;
        lb x23, 2(x18)                            ;
_l77:   la x2, d_1_25                             ;
        addi x2, x2, 20                           ;
        lui x25, 0xffe00                          ;
        xor x2, x2, x25                           ;
        amomin.w x15, x25, (x2)                   ;
_l78:   fmv.x.w x19, f10                          ;
_l79:   slli x14, x18, 18                         ;
_l80:   la x25, d_2_26                            ;
        addi x25, x25, -24                        ;
        lui x4, 0xffe00                           ;
        xor x25, x25, x4                          ;
        amoswap.d x10, x4, (x25)                  ;
_l81:   la x23, d_3_18                            ;
        addi x23, x23, -12                        ;
        amomax.w x21, x13, (x23)                  ;
_l82:   divu x5, x24, x12                         ;
_l83:   mul x26, x0, x14                          ;
_l84:   la x7, d_0_26                             ;
        addi x7, x7, -0                           ;
        lui x14, 0xffe00                          ;
        xor x7, x7, x14                           ;
        amoxor.d x17, x14, (x7)                   ;
_l85:   la x2, d_4_5                              ;
        addi x2, x2, 0                            ;
        amominu.w x13, x14, (x2)                  ;
_l86:   fmadd.s f23, f3, f15, f19, rmm            ;
_l87:   bne x1, x4, _l146                         ;
_l88:   csrrwi x16, pmpaddr2, 21                  ;
_l89:   la x5, d_1_0                              ;
        addi x5, x5, 0                            ;
        amoor.d x8, x20, (x5)                     ;
_l90:   xor x11, x11, x11                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 17                           ;
        add x11, x11, x7                          ;
        csrrw x29, satp, x11                      ;
_l91:   la x1, d_0_26                             ;
        addi x1, x1, 12                           ;
        amoadd.w x1, x27, (x1)                    ;
_l92:   slli x3, x23, 30                          ;
_l93:   fmv.w.x f15, x2                           ;
_l94:   mulhu x26, x22, x28                       ;
_l95:   bltu x9, x20, _l121                               ;
_l96:   srli x3, x8, 55                           ;
_l97:   bltu x22, x18, _l126                              ;
_l98:   la x15, d_5_3                             ;
        addi x15, x15, -24                        ;
        amominu.d x24, x5, (x15)                  ;
_l99:   fence.i                                   ;
_l100:  la x2, d_3_14                             ;
        addi x2, x2, 0                            ;
        lui x2, 0xffe00                           ;
        xor x2, x2, x2                            ;
        amomin.d x25, x2, (x2)                    ;
_l101:  la x18, d_4_14                            ;
        addi x18, x18, 28                         ;
        lui x29, 0xffe00                          ;
        xor x18, x18, x29                         ;
        sc.w x1, x29, (x18)                       ;
_l102:  ecall                                     ;
_l103:  fcvt.lu.s x21, f8, rmm                    ;
_l104:  la x16, d_3_18                            ;
        addi x16, x16, 24                         ;
        lui x15, 0xffe00                          ;
        xor x16, x16, x15                         ;
        amomax.d x25, x15, (x16)                  ;
_l105:  fcvt.wu.s x9, f20, rtz                    ;
_l106:  divuw x12, x2, x21                        ;
_l107:  la x7, d_1_2                              ;
        addi x7, x7, 0                            ;
        lui x9, 0xffe00                           ;
        xor x7, x7, x9                            ;
        amomaxu.w x3, x9, (x7)                    ;
_l108:  la x30, d_1_15                            ;
        addi x30, x30, 0                          ;
        amoand.w x22, x12, (x30)                  ;
_l109:  xor x19, x19, x19                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 18                           ;
        add x19, x19, x2                          ;
        addi x6, zero, 3                          ;
        slli x6, x6, 21                           ;
        add x19, x19, x6                          ;
        csrrs x21, sscratch, x19                  ;
_l110:  divuw x17, x3, x28                        ;
_l111:  la x26, d_5_6                             ;
        addi x26, x26, 16                         ;
        lui x22, 0xffe00                          ;
        xor x26, x26, x22                         ;
        amoor.d x19, x22, (x26)                   ;
_l112:  lui x30, 980369                           ;
_l113:  divuw x4, x22, x30                        ;
_l114:  fsqrt.s f21, f15, rmm                     ;
_l115:  la x11, d_3_15                            ;
        addi x11, x11, 8                          ;
        amoswap.d x15, x22, (x11)                 ;
_l116:  fsgnjn.s f20, f3, f13                     ;
_l117:  addw x4, x29, x24                         ;
_l118:  la x30, d_4_17                            ;
        addi x30, x30, -0                         ;
        amoxor.w x15, x20, (x30)                  ;
_l119:  ecall                                     ;
_l120:  csrrci x6, mip, 8                         ;
_l121:  la x15, d_4_10                            ;
        flw f13, 24(x15)                          ;
_l122:  la x28, d_3_19                            ;
        addi x28, x28, 20                         ;
        lr.w x1, (x28)                            ;
_l123:  addw x12, x8, x28                         ;
_l124:  mul x3, x22, x17                          ;
_l125:  srlw x28, x6, x11                         ;
_l126:  xor x14, x14, x14                         ;
        csrrc x16, scause, x14                    ;
_l127:  addiw x27, x10, 18                        ;
_l128:  bgeu x15, x2, _l156                       ;
_l129:  la x17, _l140                                     ;
        csrrw zero, sepc, x17                     ;
        sret                                      ;
_l130:  srai x10, x30, 63                         ;
_l131:  srliw x26, x18, 14                        ;
_l132:  la x20, d_4_4                             ;
        addi x20, x20, 20                         ;
        amomaxu.w x8, x1, (x20)                   ;
_l133:  la x26, d_1_15                            ;
        sh x4, 10(x26)                            ;
_l134:  ecall                                     ;
_l135:  la x30, d_5_2                             ;
        addi x30, x30, 28                         ;
        amoor.w x16, x18, (x30)                   ;
_l136:  srliw x25, x2, 0                          ;
_l137:  remw x2, x8, x1                           ;
_l138:  la x15, d_4_17                            ;
        lb x3, 0(x15)                             ;
_l139:  la x19, d_4_3                             ;
        addi x19, x19, 24                         ;
        amoadd.d x16, x14, (x19)                  ;
_l140:  subw x12, x10, x21                        ;
_l141:  mulh x22, x1, x9                          ;
_l142:  fcvt.lu.s x9, f7, rup                     ;
_l143:  ebreak                                    ;
_l144:  la x28, _l145                                     ;
        lhu x25, -24(x28)                         ;
_l145:  la x27, d_4_20                            ;
        addi x27, x27, 0                          ;
        amomax.d x11, x29, (x27)                  ;
_l146:  la x9, d_3_25                             ;
        addi x9, x9, -8                           ;
        lui x4, 0xffe00                           ;
        xor x9, x9, x4                            ;
        amomin.d x9, x4, (x9)                     ;
_l147:  srli x16, x17, 1                          ;
_l148:  remu x15, x10, x9                         ;
_l149:  la x17, d_3_25                            ;
        lw x15, -24(x17)                          ;
_l150:  srli x21, x5, 7                           ;
_l151:  mulhu x18, x4, x1                         ;
_l152:  la x29, d_5_12                            ;
        sb x2, -0(x29)                            ;
_l153:  sllw x25, x10, x22                        ;
_l154:  fsgnjn.s f30, f0, f4                      ;
_l155:  andi x22, x3, -504                        ;
_l156:  fence                                     ;
_l157:;
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
                .dword 0x44c0df990c050a00, 0xdd1c852deb682150
                .dword 0x37c09ce81fa7fb89, 0x32c338a88b698e4f
d_0_0:          .dword 0x75b275111d629424, 0x4d9a6dcb7db8d2f3
d_0_1:          .dword 0xfbac810785e4151f, 0x7cf49e3194a02c9a
d_0_2:          .dword 0x8314275c8eb89c42, 0x4ad834a0df4149d8
d_0_3:          .dword 0x8baf87d70daf2c2f, 0x067bf6e493d5a888
d_0_4:          .dword 0x595d64d01b5c8712, 0x5e8772a18b6d02de
d_0_5:          .dword 0xb1ddb1bc30f8a435, 0xacdf0e61f83944f1
d_0_6:          .dword 0x5e736ccf76038df6, 0xfaeb2595f8402f12
d_0_7:          .dword 0xae20e7b8fc15aa65, 0xe7f2060598949e3a
d_0_8:          .dword 0x39fe869a581ad67e, 0xee24c7f1e57c1fc0
d_0_9:          .dword 0x711ce09578c31816, 0x15104753a5dbe8f5
d_0_10:         .dword 0x4a01298c63b0514e, 0xecf638eb4d35a290
d_0_11:         .dword 0x3ff7995e56d71f4a, 0xe58ecc20d2af045f
d_0_12:         .dword 0xde51ef01b32f017a, 0x4a67ce9199bc36c4
d_0_13:         .dword 0xf7fe7c178273e948, 0x411d29939f770538
d_0_14:         .dword 0xf1f089460fa2afeb, 0x7d4fe4814ea2276d
d_0_15:         .dword 0x4c48cbfcea7c5c9a, 0x49c0411b9b7b62ec
d_0_16:         .dword 0x25bb65381e2c1218, 0x0b94d654bfaf370e
d_0_17:         .dword 0x96b86937d2c88358, 0xf889126233a93237
d_0_18:         .dword 0x245686881c4a5499, 0x457f6d87a614ddc9
d_0_19:         .dword 0x756b62cad8e1fe0e, 0x5b7926184cee894a
d_0_20:         .dword 0x74e7f8c264f1c8f3, 0x8c7cbc1ee9719e54
d_0_21:         .dword 0x956117992a893030, 0x920ea772b624ec7a
d_0_22:         .dword 0x7cec67f829351c97, 0x146d51ed480ff72b
d_0_23:         .dword 0x749b09e564d01ac8, 0x60cf068c205893de
d_0_24:         .dword 0xcfd10c177195f0a8, 0xccd056dc38363851
d_0_25:         .dword 0x297936d90bfbe938, 0x9d7db34251c13590
d_0_26:         .dword 0xa7b0c62953f9462a, 0x3330aab34895c137
d_0_27:         .dword 0x80b09b4a70a53fbf, 0x9077988bab699278
                .dword 0xf54574724ae84d77, 0x241c7aed768c4660
                .dword 0xcb12e57777a0c7e3, 0x43a29f5ca3320dee
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3d7e20bc30e18d6b, 0xdab2df8fc5edce06
                .dword 0x3eaa0105bcc46788, 0x96b62c8f1c1e5887
d_1_0:          .dword 0x7083f524ceda9698, 0x6a5aeaffae1f3747
d_1_1:          .dword 0x828d8ef743f204ad, 0x4e05358553a047d6
d_1_2:          .dword 0x68f54c91fccaab31, 0x30b38358220b20c4
d_1_3:          .dword 0x52e396d8ebd8d797, 0x773ece5ec45e7995
d_1_4:          .dword 0x047398c8955a4dcf, 0x29069f06e055b0df
d_1_5:          .dword 0x946f24aa9105a1da, 0x254d73436cfb0eb2
d_1_6:          .dword 0x2f71369130e6d1ca, 0x8d5e505bcd43404c
d_1_7:          .dword 0xbc9ce05a9215568c, 0xd45b83e80cd7807e
d_1_8:          .dword 0x7e527a41b53b1ffa, 0x3b5df82002cdd521
d_1_9:          .dword 0xdeee3965b2067adb, 0x66d342b1cefbc28c
d_1_10:         .dword 0x82c64a81d34af4fe, 0x58607c37a1bacc4d
d_1_11:         .dword 0x65cb8d3d770e4a3b, 0xdac4215aad960def
d_1_12:         .dword 0xb8d31f72bcd99c41, 0xc9153e82c50faeba
d_1_13:         .dword 0x8749af0098cfb6a3, 0x0e7a89a2bae6d39a
d_1_14:         .dword 0x3add75d843133cf7, 0xa37e23c3052e5b70
d_1_15:         .dword 0x8b5cbcca68510e82, 0x70917aeb835887e4
d_1_16:         .dword 0x82e799b0ee55875f, 0x040a05f1c7861a86
d_1_17:         .dword 0x2293cfc881fa446e, 0x0fc1bc8903a0d811
d_1_18:         .dword 0xf91e7316a51854d1, 0xd2b20524abfa71cc
d_1_19:         .dword 0x42f1d834f8a4ae66, 0xdb2ef17ee4c89b54
d_1_20:         .dword 0xad37b880c057da68, 0x6a509e63be46e063
d_1_21:         .dword 0xfe416240e9c0a0c9, 0x794ca2502e62cd1d
d_1_22:         .dword 0x747f6541123ecb36, 0x28bc84f6843851ee
d_1_23:         .dword 0x06b5117f6e0bda71, 0x9235dc126511176e
d_1_24:         .dword 0xd948b99f9e969f0d, 0x81284ffd3af30ae4
d_1_25:         .dword 0xa3853d959465672d, 0xb93e7bad6270d301
d_1_26:         .dword 0x340ffd09efb082cb, 0x272813e01522e8a4
d_1_27:         .dword 0xba298ddce1ee79f9, 0x08d1bdfabcbcf073
                .dword 0xd0fdd4f4a37fd70c, 0xc21625fd477d06c5
                .dword 0x07f84fd5f1f6c977, 0xdaf44a0d1307e7f5
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x57c8f9b7e4f13ea6, 0xf41d655d2a3091a0
                .dword 0x9f87e1c0d679f5bd, 0xef8f94c000211af1
d_2_0:          .dword 0x4fd30389a31ad1b9, 0x76b96dd55fbf38cf
d_2_1:          .dword 0x86dab701dcbc7cf4, 0x5c2d2f55692ba159
d_2_2:          .dword 0x00b18be933c2353b, 0xe10b2445099a620c
d_2_3:          .dword 0xbe7dfeec05d356ee, 0x20a6810d0fe12d26
d_2_4:          .dword 0x27f020f34bc18949, 0x3208381eead257c9
d_2_5:          .dword 0x60a65701ecc57433, 0x36c375ec25041863
d_2_6:          .dword 0x47b8846ad2678628, 0x42574e20d7bd08d3
d_2_7:          .dword 0x368e569ebed5a178, 0xb693911a4c380579
d_2_8:          .dword 0x47c75fb81b38c96a, 0x957f487d79cb1470
d_2_9:          .dword 0xdcedbc0d28f950ce, 0x5badd87b0832e475
d_2_10:         .dword 0x6a9458144a3c4f9c, 0xa9b34e7acb3fafbc
d_2_11:         .dword 0x77b957a44375a2b6, 0x088dbb7bb425c12d
d_2_12:         .dword 0x90eba00d7ccbfd7b, 0x2512cd209e72498c
d_2_13:         .dword 0x92681e3a0eb8bbe3, 0x8afec4ff89a6ebb3
d_2_14:         .dword 0xd880961141353bef, 0x4bb1c940ab001143
d_2_15:         .dword 0x8c2a2c72dc532ff4, 0x9dc57d6513756a69
d_2_16:         .dword 0x90029c169f4b4861, 0x262abfe07d837fc9
d_2_17:         .dword 0x1a64bab17c8b7a8a, 0xbdda9956dd394f37
d_2_18:         .dword 0x1d9d6fb610e28b9d, 0x1ee322c51cdae60e
d_2_19:         .dword 0x95584c10b1c83eb1, 0x690aeba1ac35bceb
d_2_20:         .dword 0x1d80039098decbb7, 0x5920f474e8822215
d_2_21:         .dword 0x73bf9de44d4060a0, 0x15ae655c48ce9a29
d_2_22:         .dword 0x8f17e9558183e670, 0x3aae3f578ead388d
d_2_23:         .dword 0x831fc1015c1301b0, 0xca2fb1ed7d696435
d_2_24:         .dword 0xe366477abb8d5ac6, 0x50f77595502a9ef5
d_2_25:         .dword 0xa5a71c4728cc33e4, 0xe9f7c93a976e17cd
d_2_26:         .dword 0x355fcd4c7363a9cf, 0x9d34d37b6b6d7de2
d_2_27:         .dword 0x32fd0e6ef45d1578, 0x2672dfd2f89ac740
                .dword 0x713e2036871846f3, 0xfb4c0267855bbf88
                .dword 0xb7edfe52fcfe57e9, 0x55c26aa6a1f01f39
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x273596f472187193, 0xa3226415b7e04b00
                .dword 0xbe4fdd501150eea7, 0x40e728627e4c6cc1
d_3_0:          .dword 0x2a5de8aa56a0dfd8, 0x87f5b231db8930e9
d_3_1:          .dword 0xd76f6f5b3d11f306, 0x4681773c22ff9161
d_3_2:          .dword 0xbdc82445350fe4c0, 0x7333c75d687fd7f4
d_3_3:          .dword 0xd7f951467c4736c9, 0xf8d28058e7bc92cc
d_3_4:          .dword 0xbbcbe33f203876cd, 0x6fb2f86b5616d3e5
d_3_5:          .dword 0xc007c9eb54b0bc04, 0x8aa855b5c612c760
d_3_6:          .dword 0x1cf778b713d27eab, 0x13665138b45b91c9
d_3_7:          .dword 0xffaa0a5641285f72, 0xa3ab24ef972a295c
d_3_8:          .dword 0x56e48bb907debffa, 0x2406267cd1510ffa
d_3_9:          .dword 0xd291e52cc9b751d6, 0x908c6919bc37cde4
d_3_10:         .dword 0x16ca022ce39ed356, 0xcf317606c234bf1c
d_3_11:         .dword 0x6bd7f82b5632fc5d, 0xcf119de8377e0ab5
d_3_12:         .dword 0x5c2caac9fc8af7cc, 0x243a955fd9561e52
d_3_13:         .dword 0xafddeb0d8a4c9372, 0x4bbf8bec6f3dcaa4
d_3_14:         .dword 0xbaf5eaf7d0a9cdec, 0x42d6e4320009feea
d_3_15:         .dword 0x664034541725da48, 0xdc4bdcd933f8da43
d_3_16:         .dword 0x0bed8a28620ed461, 0xaae307651dfb97ec
d_3_17:         .dword 0x08780c914c484876, 0xba5d948498e2bb2e
d_3_18:         .dword 0x93e9e872b3cf0225, 0xf490bddad88e2979
d_3_19:         .dword 0x33832029a08506ea, 0x8f8aa4870c57c1a4
d_3_20:         .dword 0x5ca36f9cdf884e5c, 0x6cb363defdc6ddb6
d_3_21:         .dword 0x826735ee5cb1077e, 0x96748e2b8b4f4c3c
d_3_22:         .dword 0xe715b84bc37605d1, 0x27a67836470b8ba4
d_3_23:         .dword 0x96a4d1ec794f66d8, 0x1b95515b2cfc3ef6
d_3_24:         .dword 0x1936c1aae9a9ea23, 0x7e52ff742da99318
d_3_25:         .dword 0xd6215f3c80ef54ed, 0x688df4c090b41358
d_3_26:         .dword 0xa24ec3676bccce2d, 0xaad884a85c83fe3b
d_3_27:         .dword 0xe5ce20ee6a4a6e95, 0x6803002c496f6afd
                .dword 0x72a6a05afdd68cc4, 0x1a5d9a3352b517a5
                .dword 0x2353c2fb4eb9ec65, 0xf02cb2e94bbab0a6
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x9dddde95e194d354, 0x056ec739a9747a60
                .dword 0x2af96b79843d14d6, 0x7b0791ca8cb3702a
d_4_0:          .dword 0xf86ddd77ee3387db, 0xa62e577cdbe40c29
d_4_1:          .dword 0x947b9711a79858c7, 0xacc7bec1aaf9e0d4
d_4_2:          .dword 0x9471bf8870f96fff, 0xb1196bf3953a7871
d_4_3:          .dword 0x25563a5589812bb1, 0x8d684df191654351
d_4_4:          .dword 0x89028d9788f2c965, 0xf6a4d1f0af78074f
d_4_5:          .dword 0x2bf0bd38ccc005a7, 0xdea482f7bc87b39a
d_4_6:          .dword 0x9eda4eca47d9f249, 0x901e89dc733f1321
d_4_7:          .dword 0xad003406f68b9716, 0x014087ce165eb88a
d_4_8:          .dword 0x3e778677a31b9db6, 0x9f52bf38f5476dd2
d_4_9:          .dword 0x3c5d8449aa28e347, 0x7191b0c598e23fb9
d_4_10:         .dword 0x081b82a5089f2d32, 0xe6270dcef240347f
d_4_11:         .dword 0x0727f6f507085952, 0x2c15171b91abebae
d_4_12:         .dword 0xbdf2d61886e3bfee, 0x4a11aaa24fcd891d
d_4_13:         .dword 0x1d21e58fc93d4a9a, 0xbb660fdda9006038
d_4_14:         .dword 0x01b75dd409af4f4c, 0x0b38ac68d15e19cd
d_4_15:         .dword 0xce9cfbab7b427034, 0x58ede494f533660f
d_4_16:         .dword 0x4a9e3c5f4726831e, 0x9aab365329308be2
d_4_17:         .dword 0x688dd8045f0cfc10, 0xbf4a4ca4e54a546f
d_4_18:         .dword 0xe59d88ca4b8e4cdc, 0xd10e872f9d493e6a
d_4_19:         .dword 0x050e5ff869c12c84, 0x3ad5e4b90123ddb8
d_4_20:         .dword 0xf297394b42d9f3ef, 0xde9b98e7f8a40b5f
d_4_21:         .dword 0x5fe7d17ced28a3ae, 0x6a01c85b156bdcb2
d_4_22:         .dword 0xfd79ae7885b5c504, 0x6ae4f27564c85f7b
d_4_23:         .dword 0x8bf1d3641a03f9c7, 0x3e9b3bc87019c926
d_4_24:         .dword 0xdc24eb81966b976f, 0x1601a3220888f5fc
d_4_25:         .dword 0xe4fe5e8bc83703db, 0x973dd74989bc7c4a
d_4_26:         .dword 0x2dd3bad25b433403, 0x58f4af9badf6befa
d_4_27:         .dword 0x74a93636b76837a7, 0xe9e2867a85200dc4
                .dword 0xf3e608e66cc18003, 0x27d0ebd450203b25
                .dword 0x5efeb5b6b179afb8, 0x2809fcfc9237b706
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x677c61273b050599, 0xa738ff5a9258c95c
                .dword 0xcb190436db7f4d98, 0x987012957df9d5f3
d_5_0:          .dword 0x39f52fb52f8f947b, 0x5e52396a9fc68b7e
d_5_1:          .dword 0x16b0d5b6a762f1a1, 0x1bc76d4c6f135ad2
d_5_2:          .dword 0x0dab56be3ade5c7f, 0xf99ce48678709e49
d_5_3:          .dword 0xb0086be51301c8c4, 0x3d09247129a8640c
d_5_4:          .dword 0x11a151201b2ca233, 0x26f4d16382f398ad
d_5_5:          .dword 0xef28d4a502622fd1, 0xabe417da0450a1d8
d_5_6:          .dword 0xb1ff1ed58b500bba, 0xa1c47926cc42f899
d_5_7:          .dword 0xb8274b56c3193731, 0x5b961f34b680d0cd
d_5_8:          .dword 0x01003448ca041bbf, 0x767ebde424371efe
d_5_9:          .dword 0x842714ab9079dc37, 0x08da79e7604f2b2d
d_5_10:         .dword 0xcfd458c64d8466e9, 0x19d1e9cad1f9bb34
d_5_11:         .dword 0x0f4cf8ed0d73beb6, 0x133fe85cde10a74b
d_5_12:         .dword 0xcdb9af8ec43f0ddf, 0xd9042ecc311b3440
d_5_13:         .dword 0x5bc2ff8d04a4990b, 0xda9d3991cfca3597
d_5_14:         .dword 0xd796c776f02960be, 0xc770a93d66a3f3c0
d_5_15:         .dword 0x20b2af35d1029e74, 0x5e5825d9ca4e01aa
d_5_16:         .dword 0xa5cbf9f4fa104b57, 0xa92dd36817ac2604
d_5_17:         .dword 0x226659a5baa3ce7f, 0x0863c9e2091f605c
d_5_18:         .dword 0xc09318fec3809451, 0x19aecb130c5f10c4
d_5_19:         .dword 0x9ee768b6be1e7e88, 0x6516e78b7e48a6cc
d_5_20:         .dword 0x57c4bf0306ae3e1d, 0xcdbc90ad544e7ffa
d_5_21:         .dword 0x1d74f83f5edc0852, 0x4af3bd9b3d5f1915
d_5_22:         .dword 0x5c1345feb9728056, 0xea3a114c54eb3829
d_5_23:         .dword 0xb9e6d62ee3757e9e, 0xf7129124e634708a
d_5_24:         .dword 0x4379503ec68b343b, 0x8a02185d4ad7917a
d_5_25:         .dword 0x5dac46228db03057, 0xea712dae4fc65c4c
d_5_26:         .dword 0x224471345c4bbee9, 0xc3a80131db84ff24
d_5_27:         .dword 0x09cd5fa60779e318, 0x37e06ac58f86d35a
                .dword 0x8c0dbdb14af78912, 0xc9080c44647c569e
                .dword 0xca4c3ca31663ebef, 0xcf4ffba7575973f1
         /* Random data */
_end_data5:
              
 
