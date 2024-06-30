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
_p0:    csrrwi x13, sscratch, 31                  ;
_p1:;
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
_s0:;
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
_l0:    remuw x14, x1, x1                         ;
_l1:    fdiv.s f20, f12, f11, rne                 ;
_l2:    fmv.w.x f28, x4                           ;
_l3:    mulhu x23, x1, x3                         ;
_l4:    fdiv.s f10, f15, f29, rmm                 ;
_l5:    slti x1, x7, 792                          ;
_l6:    beq x21, x21, _l109                               ;
_l7:    la x4, d_0_25                             ;
        lwu x20, -20(x4)                          ;
_l8:    la x17, d_0_22                            ;
        srai x17, x17, 1                          ;
        csrrw x18, pmpaddr2, x17                  ;
_l9:    blt x5, x11, _l142                                ;
_l10:   ecall                                     ;
_l11:   fsub.s f20, f28, f19, rdn                 ;
_l12:   la x12, d_2_17                            ;
        addi x12, x12, 0                          ;
        amomaxu.w x8, x22, (x12)                  ;
_l13:   fnmsub.s f31, f19, f31, f22, rup          ;
_l14:   fle.s x30, f18, f19                       ;
_l15:   fdiv.s f24, f26, f21, rne                 ;
_l16:   bne x19, x26, _l24                        ;
_l17:   la x11, _l134                                     ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l18:   divw x14, x13, x17                        ;
_l19:   fsgnjn.s f17, f9, f10                     ;
_l20:   la x26, d_3_5                             ;
        addi x26, x26, -28                        ;
        amoor.w x23, x14, (x26)                   ;
_l21:   remu x16, x0, x14                         ;
_l22:   andi x19, x11, -4                         ;
_l23:   fcvt.s.lu f16, x12, rne                   ;
_l24:   fmv.w.x f6, x24                           ;
_l25:   mul x20, x18, x6                          ;
_l26:   xor x12, x12, x12                         ;
        addi x16, zero, 1                         ;
        slli x16, x16, 26                         ;
        add x12, x12, x16                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 3                          ;
        add x12, x12, x11                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 15                         ;
        add x12, x12, x14                         ;
        csrrc x1, satp, x12                       ;
_l27:   la x8, d_0_17                             ;
        addi x8, x8, 0                            ;
        amoswap.d x19, x4, (x8)                   ;
_l28:   fle.s x24, f30, f1                        ;
_l29:   la x9, d_0_14                             ;
        sd x20, -24(x9)                           ;
_l30:   fmul.s f29, f10, f4, rne                  ;
_l31:   fence                                     ;
_l32:   fcvt.wu.s x26, f28, rtz                   ;
_l33:   fmv.x.w x20, f18                          ;
_l34:   csrrsi x16, mscratch, 29                  ;
_l35:   la x6, d_0_11                             ;
        addi x6, x6, -8                           ;
        amominu.w x27, x29, (x6)                  ;
_l36:   la x6, d_3_5                              ;
        addi x6, x6, -0                           ;
        amomax.d x27, x10, (x6)                   ;
_l37:   fsub.s f10, f26, f22, rne                 ;
_l38:   div x25, x6, x21                          ;
_l39:   la x22, d_3_13                            ;
        addi x22, x22, 0                          ;
        amoand.w x26, x11, (x22)                  ;
_l40:   la x11, d_0_27                            ;
        addi x11, x11, 8                          ;
        amoand.d x2, x17, (x11)                   ;
_l41:   srlw x2, x28, x30                         ;
_l42:   la x12, d_4_6                             ;
        addi x12, x12, 24                         ;
        amominu.d x6, x27, (x12)                  ;
_l43:   csrrwi x24, medeleg, 9                    ;
_l44:   flt.s x2, f29, f14                        ;
_l45:   la x16, d_1_21                            ;
        addi x16, x16, 0                          ;
        amomin.d x8, x20, (x16)                   ;
_l46:   xor x15, x15, x15                         ;
        csrrs x29, satp, x15                      ;
_l47:   sraw x13, x19, x13                        ;
_l48:   bgeu x6, x9, _l112                                ;
_l49:   xor x1, x1, x1                            ;
        csrrw x23, sie, x1                        ;
_l50:   fclass.s x10, f12                         ;
_l51:   remuw x17, x10, x17                       ;
_l52:   ebreak                                    ;
_l53:   la x10, _l113                                     ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l54:   ebreak                                    ;
_l55:   slti x12, x23, -9                         ;
_l56:   srai x24, x6, 1                           ;
_l57:   la x19, d_3_21                            ;
        lui x14, 0xffe00                          ;
        xor x19, x19, x14                         ;
        flw f29, -8(x19)                          ;
_l58:   la x22, _l0                                       ;
        lui x26, 0xffe00                          ;
        xor x22, x22, x26                         ;
        lhu x29, -24(x22)                         ;
_l59:   la x20, _l121                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l60:   mulw x15, x29, x2                         ;
_l61:   la x2, _l127                                       ;
        csrrw zero, uepc, x2                      ;
        uret                                      ;
_l62:   la x14, d_2_24                            ;
        addi x14, x14, -20                        ;
        sc.w x2, x4, (x14)                        ;
_l63:   la x9, d_3_20                             ;
        lwu x15, -0(x9)                           ;
_l64:   fmax.s f17, f21, f0                       ;
_l65:   subw x1, x29, x1                          ;
_l66:   la x11, d_2_14                            ;
        sh x28, -6(x11)                           ;
_l67:   fnmsub.s f10, f31, f31, f15, rne          ;
_l68:   la x11, d_2_16                            ;
        lwu x11, 20(x11)                          ;
_l69:   la x1, d_3_10                             ;
        addi x1, x1, 8                            ;
        amoor.w x28, x10, (x1)                    ;
_l70:   la x7, d_5_15                             ;
        addi x7, x7, -8                           ;
        amomaxu.d x10, x20, (x7)                  ;
_l71:   la x30, d_2_23                            ;
        ld x7, -24(x30)                           ;
_l72:   fclass.s x28, f3                          ;
_l73:   la x15, _l78                                      ;
        lhu x10, 0(x15)                           ;
_l74:   la x20, d_3_15                            ;
        addi x20, x20, -8                         ;
        amoor.d x26, x12, (x20)                   ;
_l75:   la x6, d_2_18                             ;
        lh x28, 6(x6)                             ;
_l76:   beq x27, x13, _l100                                ;
_l77:   la x11, d_2_10                            ;
        flw f7, -0(x11)                           ;
_l78:   divw x19, x2, x10                         ;
_l79:   fmsub.s f22, f2, f2, f0, rmm              ;
_l80:   la x2, d_2_14                             ;
        addi x2, x2, 0                            ;
        sc.w x11, x12, (x2)                       ;
_l81:   la x25, d_4_15                            ;
        addi x25, x25, -24                        ;
        sc.d x6, x25, (x25)                       ;
_l82:   fle.s x13, f18, f18                       ;
_l83:   la x17, d_3_3                             ;
        lh x7, -0(x17)                            ;
_l84:   fclass.s x25, f10                         ;
_l85:   la x6, d_1_1                              ;
        addi x6, x6, -0                           ;
        lr.d x29, (x6)                            ;
_l86:   la x14, d_5_0                             ;
        addi x14, x14, -12                        ;
        amomaxu.w x16, x30, (x14)                 ;
_l87:   sraw x21, x14, x4                         ;
_l88:   la x11, _l84                                      ;
        srai x11, x11, 1                          ;
        csrrs x23, pmpaddr3, x11                  ;
_l89:   la x19, d_4_27                            ;
        flw f14, 4(x19)                           ;
_l90:   fmsub.s f20, f17, f15, f13, dyn           ;
_l91:   srlw x11, x23, x8                         ;
_l92:   la x10, d_0_11                            ;
        sb x27, -8(x10)                           ;
_l93:   ecall                                     ;
_l94:   la x25, d_2_23                            ;
        addi x25, x25, 0                          ;
        amoand.w x29, x13, (x25)                  ;
_l95:   fnmadd.s f31, f26, f6, f13, rup           ;
_l96:   la x11, d_3_14                            ;
        lh x19, -20(x11)                          ;
_l97:   la x6, d_0_21                             ;
        addi x6, x6, -0                           ;
        amomin.w x17, x30, (x6)                   ;
_l98:   sraiw x3, x26, 4                          ;
_l99:   la x30, _l144                             ;
        jalr x1, 0(x30)                           ;
_l100:  ori x6, x18, -104                         ;
_l101:  xor x24, x24, x24                         ;
        addi x6, zero, 3                          ;
        slli x6, x6, 14                           ;
        add x24, x24, x6                          ;
        csrrc x6, satp, x24                       ;
_l102:  la x2, d_3_7                              ;
        addi x2, x2, 0                            ;
        amoswap.w x30, x1, (x2)                   ;
_l103:  la x15, _l136                             ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l104:  la x9, d_0_21                             ;
        lhu x26, -4(x9)                           ;
_l105:  la x3, d_5_25                             ;
        addi x3, x3, 0                            ;
        amoswap.w x17, x1, (x3)                   ;
_l106:  la x30, _l119                             ;
        lw x27, 24(x30)                           ;
_l107:  sllw x26, x12, x22                        ;
_l108:  slti x12, x10, -0                         ;
_l109:  la x23, d_0_18                            ;
        lh x13, -26(x23)                          ;
_l110:  la x12, d_1_12                            ;
        addi x12, x12, -16                        ;
        sc.w x28, x29, (x12)                      ;
_l111:  fle.s x4, f30, f13                        ;
_l112:  la x29, d_2_23                            ;
        addi x29, x29, 28                         ;
        amomax.w x24, x10, (x29)                  ;
_l113:  fcvt.lu.s x27, f14, dyn                   ;
_l114:  la x10, d_2_22                            ;
        flw f23, -20(x10)                         ;
_l115:  la x28, d_4_26                            ;
        addi x28, x28, -16                        ;
        amoswap.w x21, x8, (x28)                  ;
_l116:  div x22, x4, x20                          ;
_l117:  sltiu x18, x30, -2047                     ;
_l118:  la x9, d_4_23                             ;
        sb x28, -12(x9)                           ;
_l119:  fmul.s f17, f30, f10, rmm                 ;
_l120:  la x11, d_0_7                             ;
        addi x11, x11, 24                         ;
        amoadd.d x22, x8, (x11)                   ;
_l121:  la x6, d_4_3                              ;
        addi x6, x6, -20                          ;
        amoor.w x17, x29, (x6)                    ;
_l122:  bne x3, x4, _l126                                 ;
_l123:  la x20, _l135                             ;
        csrrw zero, mepc, x20                     ;
        mret                                      ;
_l124:  la x5, d_3_17                             ;
        addi x5, x5, -8                           ;
        lr.w x6, (x5)                             ;
_l125:  fcvt.wu.s x0, f4, rup                     ;
_l126:  fclass.s x4, f2                           ;
_l127:  slli x19, x27, 59                         ;
_l128:  la x15, _l146                                     ;
        csrrw zero, sepc, x15                     ;
        sret                                      ;
_l129:  li x10, 0                                 ;
        la x21, pt3                               ;
        addi x21, x21, 16                         ;
        sfence.vma x10, x21                       ;
_l130:  fsgnjn.s f20, f0, f18                     ;
_l131:  la x1, d_2_18                             ;
        addi x1, x1, 16                           ;
        amoxor.d x22, x29, (x1)                   ;
_l132:  fmsub.s f13, f12, f12, f14, rmm           ;
_l133:  fmin.s f21, f2, f8                        ;
_l134:  la x16, d_4_3                             ;
        lbu x24, 15(x16)                          ;
_l135:  addw x0, x9, x11                          ;
_l136:  xor x16, x16, x16                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 11                         ;
        add x16, x16, x23                         ;
        csrrs x27, mepc, x16                      ;
_l137:  la x6, d_0_16                             ;
        addi x6, x6, -0                           ;
        lr.d x4, (x6)                             ;
_l138:  fcvt.l.s x7, f14, dyn                     ;
_l139:  lui x3, 70821                             ;
_l140:  srliw x1, x0, 0                           ;
_l141:  la x29, d_4_20                            ;
        addi x29, x29, 24                         ;
        amoand.d x27, x14, (x29)                  ;
_l142:  slliw x6, x19, 1                          ;
_l143:  remw x19, x27, x8                         ;
_l144:  la x10, d_5_7                             ;
        lw x5, -16(x10)                           ;
_l145:  div x10, x10, x6                          ;
_l146:  flt.s x3, f25, f22                        ;
_l147:  bne x20, x18, _l151                       ;
_l148:  fcvt.s.l f3, x25, rtz                     ;
_l149:  csrrsi x12, frm, 18                       ;
_l150:  slti x27, x13, -2047                      ;
_l151:  andi x16, x11, 1800                       ;
_l152:;
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
                .dword 0x21e96898fb57b11f, 0xc56230bcf1fe7245
                .dword 0x7fe6145f4561b920, 0xac2f56d03f918d89
d_0_0:          .dword 0x244c1ddcc356db50, 0xd603b73658b4b965
d_0_1:          .dword 0xe51a19a9ea8d9b25, 0x6f88057a78180ebc
d_0_2:          .dword 0xaca74a85caa7813c, 0xe0a41f8151e23db1
d_0_3:          .dword 0x1c1bd06fa3930031, 0xacb1392d8d3ef453
d_0_4:          .dword 0x805098b9c8e7feec, 0x4bf4cb0736e6e0df
d_0_5:          .dword 0xfd81a74515c2550c, 0x11db38efde119c2c
d_0_6:          .dword 0x2515d70dad9d8e26, 0xf490cb3859b5f1a6
d_0_7:          .dword 0x88a9fd0733707615, 0x23c308026dc54f7c
d_0_8:          .dword 0x3cf16c7bc016e8dc, 0xcd37efa7197a57d0
d_0_9:          .dword 0x4656bcf5d0864e7d, 0xc32b2ab00069f594
d_0_10:         .dword 0xe0feedac25522424, 0xe081a5e94840b98e
d_0_11:         .dword 0x82cafe28b6895766, 0x3a555c04c83a7352
d_0_12:         .dword 0x3b0c04b938558944, 0x1c3965afcebe5cbe
d_0_13:         .dword 0x9009862dac321105, 0x2327de3a417779d1
d_0_14:         .dword 0xd084a8e8987898d9, 0xe795429a61a544ab
d_0_15:         .dword 0xc54f5472ad3a469b, 0x7196ea66eb69e22e
d_0_16:         .dword 0x9e78f8bd4ef1492c, 0x2275c7db6eea8533
d_0_17:         .dword 0xfc0ccd55b06fd73a, 0xdce4bb54bd79e060
d_0_18:         .dword 0x301b19916a0d5e5b, 0x8915232ce3426a9f
d_0_19:         .dword 0x3e02d82a577cd134, 0x6575f965cbe287da
d_0_20:         .dword 0x88cd265133991b88, 0xbfe786340600d710
d_0_21:         .dword 0xfc90cba76ece76d0, 0x05d791fcc57ae57d
d_0_22:         .dword 0xb1c3dee88776e20a, 0x41fec7691f6ebb63
d_0_23:         .dword 0x163bf4e20cfedd35, 0xcb0fdcaa9edd4e87
d_0_24:         .dword 0x2621f60ee8566ab0, 0xc28b43b8c14da2db
d_0_25:         .dword 0x5679ad1d8e14fecf, 0xc3ac141654a98bf2
d_0_26:         .dword 0x584e53966cc2e07c, 0x07d2360a5d140f5f
d_0_27:         .dword 0x4b23399b91602830, 0x8cd9ef9ae46748f4
                .dword 0xad7b74d704f4c76e, 0x337c4ea28f9e80f9
                .dword 0x4f31207d6c36a509, 0x5e6ea193ff3ecb36
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xda1ddf463e570297, 0x804fcd4a2671ca21
                .dword 0xfd4933d6e9c1db60, 0x1b96756555b056f8
d_1_0:          .dword 0x0d3ddfb2fa6c1e41, 0x4fd900892dfa8ce7
d_1_1:          .dword 0x3e09a2d3926ff332, 0x5c159339a79a4786
d_1_2:          .dword 0x9df4a425a8d4c3c9, 0x979278472fd4128a
d_1_3:          .dword 0xf19738cf2d010d7f, 0xe4cc2f1e1d77d600
d_1_4:          .dword 0xf50930b01cd0e94e, 0xe90aeff49f7c0838
d_1_5:          .dword 0xcd8d2253778cf0e1, 0x9e9af6bb7a1af3df
d_1_6:          .dword 0x54332cb79989b217, 0xa9d428e7653c0720
d_1_7:          .dword 0x919d9e6130f6e6f7, 0x2dfa32880f1253ee
d_1_8:          .dword 0xd1052ef48b135d86, 0x31db197c76006480
d_1_9:          .dword 0xf92d48d97c9c1424, 0xfe680a0643628500
d_1_10:         .dword 0x70db88302d2e5b96, 0xa0a4810585b6192b
d_1_11:         .dword 0xc9f06d42da7ea7ef, 0x56c3deb882702535
d_1_12:         .dword 0x30eb8a8984fda612, 0xd871ffe9ebf23fae
d_1_13:         .dword 0x72c14c6dca34efac, 0xc3264908841f613a
d_1_14:         .dword 0x73c8566c7ba3f561, 0x48039fd50fd505f2
d_1_15:         .dword 0xa451d74b076a7fba, 0x27ea502b0da95766
d_1_16:         .dword 0x90a5da9bf7b2c7a2, 0x74a716bd45bfc3fc
d_1_17:         .dword 0xf37f0cb3b17fbe6a, 0x88c13f1669b5dea3
d_1_18:         .dword 0x7bdd54297316c022, 0x8979400d40814342
d_1_19:         .dword 0x74e94208bb4d06f1, 0xdbf65a9d5b824a54
d_1_20:         .dword 0xcfaa8174c7f82553, 0xd1b889cb614f60bb
d_1_21:         .dword 0x1a8103d2a011a7e7, 0x3b24de70649667a3
d_1_22:         .dword 0x9b621192c2042273, 0xad684c7ea4df73f3
d_1_23:         .dword 0xba564589741889f0, 0x8073b87f91a213d9
d_1_24:         .dword 0x80343f42a542ca1a, 0x00ebcb1ebc9fefc4
d_1_25:         .dword 0x981c52d6210a0258, 0x92a85cac24a2230b
d_1_26:         .dword 0xd9a4e485ccf356e4, 0x427ff61fcfdcd5d9
d_1_27:         .dword 0x333794d952c89f49, 0x98707142e2bdcd01
                .dword 0x0e3f96823f3978ec, 0x2df9f2f9de66f3a2
                .dword 0x596267d8f06755bc, 0xb021a519002cab83
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xcd188a2e759eaaab, 0x1614992752f29cd1
                .dword 0x39b8d649c214b674, 0xd120a8251ff23781
d_2_0:          .dword 0x1240c77c2f2f559a, 0xeb737e7e2396b0b0
d_2_1:          .dword 0x5f6c1cc45cb338a8, 0xe7c7094f4d60585e
d_2_2:          .dword 0xf1b2d7742196dcf0, 0x6ecdc4c25157928b
d_2_3:          .dword 0x2af36b394e83f291, 0x36217b1225a8ce4e
d_2_4:          .dword 0xa11e9523ca64bfe7, 0x47e61e84ae4b4625
d_2_5:          .dword 0xcd39f99b3ec7e3b1, 0x55a41984d0e6d71e
d_2_6:          .dword 0xf62f99678696a539, 0xe2e055b1bf47f844
d_2_7:          .dword 0x230e31d5767d88ca, 0x4b0af4c94018e879
d_2_8:          .dword 0xf269979f08732a2b, 0xed85f9718d06a972
d_2_9:          .dword 0x1514486dc1f0016f, 0x3ce24d88302893ab
d_2_10:         .dword 0x8147e55de627288d, 0x0bcf5a0c1e2d61f9
d_2_11:         .dword 0x9b419ab36e920c2a, 0x1d0dfcc761477514
d_2_12:         .dword 0x133f3a587d35cbbc, 0x9144b31eb0c59d11
d_2_13:         .dword 0x686c2d29fad345ee, 0x2112e9ef23e2b67c
d_2_14:         .dword 0x63d899e88d733572, 0xfbabcb56747bb15b
d_2_15:         .dword 0xf6525f56b1b742cb, 0xd034ac345f14111f
d_2_16:         .dword 0x0db76bc127db6504, 0x018349d85aebd812
d_2_17:         .dword 0x9eb0f54ee5fd9cdd, 0x912030fac26a64b0
d_2_18:         .dword 0x1edc5c3b2f3105e8, 0x9f4a5861cd406a7f
d_2_19:         .dword 0x3cdd4fc5ff8f306d, 0x05698f0cf76db9e8
d_2_20:         .dword 0xef52f57fcc47b189, 0xda8aeb3df7f9253c
d_2_21:         .dword 0x4ed0a774d18774eb, 0xfc15bae2c413e8e9
d_2_22:         .dword 0x0298acd5fabb840a, 0xdefc513de8b1ba16
d_2_23:         .dword 0x4140f137aa7bf9e7, 0xf50d3f4595c5c008
d_2_24:         .dword 0xdc120474d8760a88, 0xac79e2d2dab8a374
d_2_25:         .dword 0x20843ef1b163c95c, 0xf0d97c75f0f3928b
d_2_26:         .dword 0xb4e124b37ddc19c0, 0x721e44e6d0def981
d_2_27:         .dword 0x258f3550efbd2438, 0x3d0dd51df8104efc
                .dword 0x4a1fe59c5ca3bd99, 0x05b6323fbf0cce46
                .dword 0xb50ded07798ca3bd, 0x404940d5430f4321
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe41ff20b99eef807, 0x143032b3fe293591
                .dword 0xd19b22e5b686b406, 0xae2c6ee5c9e48c87
d_3_0:          .dword 0xd25c5bf5b9b7cb55, 0xd7e6fb35f8325425
d_3_1:          .dword 0xc5db18c0258e6c53, 0x36d6d0e92bf3cf14
d_3_2:          .dword 0xafe8a5c6faf58471, 0xf4da74cfae967596
d_3_3:          .dword 0xcf9a7f3cd7607350, 0x596fe1db0a82844b
d_3_4:          .dword 0xaf3151b3ec529124, 0x302984bc35e2c63d
d_3_5:          .dword 0xe0ca22aea7f78a16, 0x6f6c76408c0be277
d_3_6:          .dword 0xb170d4c10d652db0, 0xe98c5d4541069574
d_3_7:          .dword 0xbcfb23e4b9ebec19, 0xf3bf5c365e514847
d_3_8:          .dword 0xfbb3e82896a92017, 0xa03adcfe319195ce
d_3_9:          .dword 0xf74d3ac729b3ea4b, 0xa4a14cf8ea037821
d_3_10:         .dword 0x2439bfea9c9a9e66, 0xbea67ba4c7750f0d
d_3_11:         .dword 0x6fd65cfbc53e91c0, 0x7f319d0a06b288f2
d_3_12:         .dword 0x980d41137fd71dc0, 0x520897548acfd8ab
d_3_13:         .dword 0x8d7e7d969f591529, 0x34016679554a6c8b
d_3_14:         .dword 0xb1cd0abd0ace40e7, 0x1bf580221cc371fc
d_3_15:         .dword 0x65ad89a4f402eca6, 0x1b5d3c1b1aa01ee4
d_3_16:         .dword 0x3df9f5a33efb4c1c, 0x65931eba7f4d7658
d_3_17:         .dword 0x31c5f9efbedcf6b0, 0xab5a5332501d8094
d_3_18:         .dword 0x3cc58a862578f30c, 0x7d47bf0658e4da84
d_3_19:         .dword 0x01f7259a7e35f00f, 0x41dbb96b2e148ef9
d_3_20:         .dword 0x0eb6b7b3c96532d8, 0xf0baef6ce9a993c4
d_3_21:         .dword 0xa87fdc9b99bec54c, 0xdb52dc70f6308ed3
d_3_22:         .dword 0x9bb8a34a2473fc98, 0x20ab8b283140ad32
d_3_23:         .dword 0x963564147ac4390e, 0x8f8ec4cf8feff96e
d_3_24:         .dword 0xfd04dd5a08d16e47, 0x9c9b08d351f49708
d_3_25:         .dword 0x15feaa245e532580, 0xf4c6fea134450f57
d_3_26:         .dword 0x451f04b15993a47d, 0xa483d8cd76b5bbe2
d_3_27:         .dword 0xc5755805097fcace, 0x8c0ca3e814162e2b
                .dword 0xf71710fcd4d02236, 0x4fc4886f0f6d8535
                .dword 0x96e5d2763644ae05, 0x708db14dc157b08d
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8b6355afeae48105, 0x21243201e41ae6bd
                .dword 0x9f4ec3cf899b56d0, 0xdcf5a10f99bc386b
d_4_0:          .dword 0x8c0e6f831e7d4ffa, 0xc2f8b289fe9be33f
d_4_1:          .dword 0xd4ce469b18f2209c, 0x0d2dcfd19e0400ae
d_4_2:          .dword 0x557d8c1478b296a3, 0xa70afdae84032271
d_4_3:          .dword 0x0d723d4992a9bf88, 0x245208ae161fb26e
d_4_4:          .dword 0xee566bd5620d7434, 0x7c13b472579e95c6
d_4_5:          .dword 0xae494b4958b5cf66, 0xd5ac9ab484a7a9a7
d_4_6:          .dword 0xe69e05480a019137, 0x75bc2997b39a8ac9
d_4_7:          .dword 0xb87902d9238cc27a, 0xc0b7a0684c5c2e61
d_4_8:          .dword 0x9e3854147fcefc0c, 0x15831cbb6bf01497
d_4_9:          .dword 0x3e1491767cd9a944, 0x1c477cdaee58de8b
d_4_10:         .dword 0x0ad6e2e459bb07fa, 0x19a800c1310c0674
d_4_11:         .dword 0x4e0b89f181b716f0, 0xf2e7fc5864abda57
d_4_12:         .dword 0xc5de42ed735203e5, 0x9225a932b5f9650f
d_4_13:         .dword 0x7caa5eb0884515cd, 0xa254df779968a607
d_4_14:         .dword 0x873006f57ed2fe75, 0xb375b19ebde166c5
d_4_15:         .dword 0x5b0c44e5704808ba, 0xf37858ba628f2858
d_4_16:         .dword 0xf96d185b541e7f4a, 0xa64deb285cb23ef0
d_4_17:         .dword 0x0f253264733b99d9, 0x067d83bffb6f9386
d_4_18:         .dword 0x95c3481949a8740d, 0x3673f9bd3baecca6
d_4_19:         .dword 0x48861c1f909a1d6f, 0x94d3b1f0c4a31470
d_4_20:         .dword 0x8e458b1e99142844, 0x624f89b392cf1542
d_4_21:         .dword 0x26ae5a4bb13a7002, 0xc983b459d93fa92e
d_4_22:         .dword 0x7920827f9c12bc56, 0x9d21cc8b46ddbc99
d_4_23:         .dword 0x94228b2094033fae, 0x6b2c3184ad2386e6
d_4_24:         .dword 0x3b719524c467cc78, 0x168a98a69ecb71c3
d_4_25:         .dword 0xe18bbac17c508591, 0xc5fc91e26a1aa710
d_4_26:         .dword 0x7108e50d60517bcb, 0x0dcb5ce87f167a6a
d_4_27:         .dword 0xe3790e203cc66e4b, 0x21cf3164a378bcaf
                .dword 0xd66d12fb39aa68b3, 0x9a7306f3642ac192
                .dword 0x4da7656e40bc9234, 0x506f0c8d3bb378d9
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xd2edea20f1574b7d, 0x5810bc6300169259
                .dword 0x3f4b168da032706c, 0x1e4fc22af793c019
d_5_0:          .dword 0xe07ad52f7ec6a836, 0xf5fdb2bafce28033
d_5_1:          .dword 0x8cd677fb67736139, 0x659b28663e031969
d_5_2:          .dword 0x2f10da78fd9348a1, 0xff1aa0d53ef4a94c
d_5_3:          .dword 0xc7d513d0469a27b7, 0x43fee803510008f4
d_5_4:          .dword 0x8718bbf0eeb5065e, 0xb73b28fc967b3199
d_5_5:          .dword 0x17cbb8aa3aeeb45e, 0xb597d884b3675971
d_5_6:          .dword 0x29c667b8cf548bcb, 0x9dceffbd6c859afb
d_5_7:          .dword 0x9df0102d2688ce60, 0x5f0e40ee94da2f5e
d_5_8:          .dword 0xcecad516f7eb4dae, 0xbcadd28cf9c9778d
d_5_9:          .dword 0x43db2dd5120b632c, 0x39e060920a8bd7f6
d_5_10:         .dword 0x7c7f57f1e3c7fb90, 0x12a6902728b0456d
d_5_11:         .dword 0xc21591f3a38df1b3, 0xe5e4f9239c2baa58
d_5_12:         .dword 0xb496001083ce4f52, 0x57dc592d05eb61a3
d_5_13:         .dword 0x21d726cc887b27d6, 0x66b7d32dc486aaa0
d_5_14:         .dword 0x6e96421964904b80, 0x1985091acf61a0c2
d_5_15:         .dword 0x89f1ad6263ab3fb6, 0x1be157271fd3fad6
d_5_16:         .dword 0x502a9bc07b5d3df5, 0x63e485a61a2a5ccc
d_5_17:         .dword 0x2cefbf562bf0273a, 0xf9741626a489bba9
d_5_18:         .dword 0x9e4ae1f99c1cbc39, 0x1a26f8593761bcc3
d_5_19:         .dword 0x7db26c2548944c3a, 0x04bf0e560c9bbbcf
d_5_20:         .dword 0x0edec34a23e87de3, 0x93d7807433ffa1fc
d_5_21:         .dword 0x7683956a63377efe, 0xbb1697ced35642ba
d_5_22:         .dword 0x860d72abd6c806b8, 0xf487ed76622756e7
d_5_23:         .dword 0x191f238e8caaa8e8, 0x913109d19170a819
d_5_24:         .dword 0x528010223a9d36d6, 0x63d09e38b4ba3acc
d_5_25:         .dword 0x35ee7f4a5b0c114b, 0x4ada4d2da93055df
d_5_26:         .dword 0x3ae56009a562ce6c, 0xc999a1f10ce608f4
d_5_27:         .dword 0xf864ea7119dca6a2, 0x67e9666f3f1c4300
                .dword 0xfbe403bc2ed72c2e, 0xcd52dab77adf2f8a
                .dword 0x377d823f77525108, 0x8e8086c780365e6b
         /* Random data */
_end_data5:
              
 
