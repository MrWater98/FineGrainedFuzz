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
_p0:    csrrsi x14, mepc, 7                       ;
_p1:    csrrsi x11, pmpaddr2, 30                  ;
_p2:    csrrci x10, satp, 12                      ;
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
_s0:    la x20, d_2_7                             ;
        addi x20, x20, 12                         ;
        amomax.w x7, x29, (x20)                   ;
_s1:    la x27, d_2_2                             ;
        addi x27, x27, 8                          ;
        amoand.d x24, x10, (x27)                  ;
_s2:    la x13, d_0_19                            ;
        addi x13, x13, 0                          ;
        amoswap.w x19, x2, (x13)                  ;
_s3:    la x8, d_0_20                             ;
        lw x3, -0(x8)                             ;
_s4:    la x28, d_2_12                            ;
        addi x28, x28, -16                        ;
        amomaxu.d x7, x15, (x28)                  ;
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
_l0:    bne x8, x17, _l122                                ;
_l1:    fadd.s f10, f16, f16, rtz                 ;
_l2:    la x10, _l155                                     ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l3:    fence                                     ;
_l4:    bge x21, x17, _l75                                ;
_l5:    la x28, d_1_26                            ;
        addi x28, x28, -24                        ;
        lui x3, 0xffe00                           ;
        xor x28, x28, x3                          ;
        amoxor.w x29, x3, (x28)                   ;
_l6:    fcvt.wu.s x18, f24, rtz                   ;
_l7:    remu x14, x9, x7                          ;
_l8:    divw x8, x6, x11                          ;
_l9:    remu x16, x3, x22                         ;
_l10:   la x26, d_0_14                            ;
        addi x26, x26, -0                         ;
        amoadd.d x23, x12, (x26)                  ;
_l11:   fadd.s f13, f13, f0, rtz                  ;
_l12:   fclass.s x28, f2                          ;
_l13:   la x19, d_0_8                             ;
        addi x19, x19, -20                        ;
        amominu.w x6, x30, (x19)                  ;
_l14:   la x18, d_5_27                            ;
        addi x18, x18, 24                         ;
        amoswap.d x10, x24, (x18)                 ;
_l15:   la x26, d_2_27                            ;
        lui x3, 0xffe00                           ;
        xor x26, x26, x3                          ;
        flw f26, -24(x26)                         ;
_l16:   beq x16, x21, _l59                        ;
_l17:   blt x3, x14, _l128                                ;
_l18:   la x12, d_1_10                            ;
        sd x3, -24(x12)                           ;
_l19:   fcvt.s.wu f23, x30, rtz                   ;
_l20:   la x24, d_1_18                            ;
        addi x24, x24, -24                        ;
        amomin.w x3, x20, (x24)                   ;
_l21:   la x27, d_1_8                             ;
        lui x7, 0xffe00                           ;
        xor x27, x27, x7                          ;
        sw x3, 12(x27)                            ;
_l22:   remu x10, x29, x26                        ;
_l23:   fsqrt.s f0, f19, rne                      ;
_l24:   rem x0, x16, x6                           ;
_l25:   la x24, d_4_19                            ;
        lh x30, 30(x24)                           ;
_l26:   fmax.s f16, f13, f23                      ;
_l27:   sltiu x16, x22, 739                       ;
_l28:   la x28, _l90                                      ;
        csrrw zero, mepc, x28                     ;
        mret                                      ;
_l29:   la x20, d_2_9                             ;
        addi x20, x20, 8                          ;
        amomax.d x20, x20, (x20)                  ;
_l30:   divuw x22, x6, x18                        ;
_l31:   xor x1, x1, x1                            ;
        addi x2, zero, 1                          ;
        slli x2, x2, 5                            ;
        add x1, x1, x2                            ;
        addi x29, zero, 3                         ;
        slli x29, x29, 10                         ;
        add x1, x1, x29                           ;
        csrrw x21, sstatus, x1                    ;
_l32:   la x4, d_2_10                             ;
        addi x4, x4, 20                           ;
        amomax.w x24, x19, (x4)                   ;
_l33:   la x21, d_0_0                             ;
        sd x2, -0(x21)                            ;
_l34:   la x23, d_2_26                            ;
        addi x23, x23, -16                        ;
        amoswap.d x23, x20, (x23)                 ;
_l35:   sraw x17, x15, x9                         ;
_l36:   remu x4, x11, x14                         ;
_l37:   ecall                                     ;
_l38:   auipc x10, 0                              ;
_l39:   fmv.x.w x13, f26                          ;
_l40:   la x20, d_2_10                            ;
        sd x9, -8(x20)                            ;
_l41:   remw x27, x12, x27                        ;
_l42:   fmul.s f13, f16, f1, rdn                  ;
_l43:   xor x8, x8, x8                            ;
        csrrw x26, sscratch, x8                   ;
_l44:   fcvt.wu.s x9, f26, dyn                    ;
_l45:   la x15, _l129                                     ;
        lwu x11, -0(x15)                          ;
_l46:   la x30, d_4_9                             ;
        addi x30, x30, -12                        ;
        amoor.w x25, x12, (x30)                   ;
_l47:   la x8, d_3_1                              ;
        addi x8, x8, -8                           ;
        lr.d x3, (x8)                             ;
_l48:   la x27, d_4_2                             ;
        lb x11, 0(x27)                            ;
_l49:   la x30, d_4_2                             ;
        sh x10, -8(x30)                           ;
_l50:   addw x22, x17, x27                        ;
_l51:   fcvt.l.s x5, f30, rne                     ;
_l52:   sllw x18, x20, x13                        ;
_l53:   csrrci x21, fflags, 7                     ;
_l54:   la x7, d_1_6                              ;
        addi x7, x7, -12                          ;
        amomin.w x31, x14, (x7)                   ;
_l55:   srli x26, x5, 35                          ;
_l56:   fsgnj.s f10, f7, f31                      ;
_l57:   xor x25, x25, x25                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 20                         ;
        add x25, x25, x11                         ;
        addi x26, zero, 1                         ;
        slli x26, x26, 10                         ;
        add x25, x25, x26                         ;
        csrrc x1, mcause, x25                     ;
_l58:   la x16, _l127                                      ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l59:   fcvt.s.wu f31, x16, rne                   ;
_l60:   divw x30, x29, x3                         ;
_l61:   fsgnj.s f20, f0, f5                       ;
_l62:   la x3, d_5_13                             ;
        addi x3, x3, 28                           ;
        amomaxu.w x25, x5, (x3)                   ;
_l63:   la x24, d_3_14                            ;
        addi x24, x24, -28                        ;
        amoand.w x2, x9, (x24)                    ;
_l64:   sraw x20, x7, x15                         ;
_l65:   sraw x20, x2, x22                         ;
_l66:   la x10, d_0_24                            ;
        addi x10, x10, 8                          ;
        lr.d x4, (x10)                            ;
_l67:   la x3, d_5_4                              ;
        srai x3, x3, 1                            ;
        csrrs x21, pmpaddr2, x3                   ;
_l68:   la x27, d_2_22                            ;
        lwu x7, -0(x27)                           ;
_l69:   la x10, d_0_17                            ;
        lh x18, -18(x10)                          ;
_l70:   addiw x17, x14, -0                        ;
_l71:   la x15, _l74                                      ;
        lwu x28, -20(x15)                         ;
_l72:   la x20, _l89                                      ;
        lhu x15, 30(x20)                          ;
_l73:   la x29, _l116                             ;
        csrrw zero, uepc, x29                     ;
        uret                                      ;
_l74:   fsqrt.s f19, f10, rmm                     ;
_l75:   addi x13, x30, 2047                       ;
_l76:   ori x8, x29, 2047                         ;
_l77:   la x21, d_5_10                            ;
        lwu x5, -24(x21)                          ;
_l78:   sltiu x29, x19, 2041                      ;
_l79:   auipc x20, 120390                         ;
_l80:   ecall                                     ;
_l81:   sraiw x13, x19, 11                        ;
_l82:   remu x15, x13, x19                        ;
_l83:   fmin.s f23, f4, f0                        ;
_l84:   mulw x25, x29, x0                         ;
_l85:   srlw x15, x6, x1                          ;
_l86:   la x23, d_2_8                             ;
        sd x1, -24(x23)                           ;
_l87:   la x3, d_4_14                             ;
        addi x3, x3, -24                          ;
        amoxor.w x24, x1, (x3)                    ;
_l88:   la x7, d_0_13                             ;
        addi x7, x7, 0                            ;
        lui x4, 0xffe00                           ;
        xor x7, x7, x4                            ;
        amoand.w x29, x4, (x7)                    ;
_l89:   la x27, d_2_15                            ;
        addi x27, x27, -0                         ;
        amoand.w x14, x13, (x27)                  ;
_l90:   la x14, d_2_10                            ;
        addi x14, x14, -0                         ;
        amoxor.w x25, x14, (x14)                  ;
_l91:   la x5, _l127                              ;
        csrrw zero, sepc, x5                      ;
        sret                                      ;
_l92:   sllw x0, x17, x14                         ;
_l93:   la x3, d_1_10                             ;
        addi x3, x3, 16                           ;
        amomax.d x5, x23, (x3)                    ;
_l94:   srai x4, x2, 50                           ;
_l95:   srlw x15, x18, x20                        ;
_l96:   bne x23, x30, _l99                                ;
_l97:   la x27, d_5_24                            ;
        addi x27, x27, 28                         ;
        amomin.w x7, x26, (x27)                   ;
_l98:   fmv.x.w x5, f5                            ;
_l99:   la x27, d_2_12                            ;
        lb x2, -27(x27)                           ;
_l100:  mulw x10, x2, x17                         ;
_l101:  divuw x8, x11, x18                        ;
_l102:  la x1, d_3_0                              ;
        lh x20, 30(x1)                            ;
_l103:  mulh x2, x12, x1                          ;
_l104:  la x2, d_0_23                             ;
        addi x2, x2, -0                           ;
        amomaxu.d x1, x5, (x2)                    ;
_l105:  csrrsi x11, pmpaddr3, 3                   ;
_l106:  auipc x29, 26                             ;
_l107:  la x16, d_2_1                             ;
        addi x16, x16, -0                         ;
        sc.w x9, x12, (x16)                       ;
_l108:  la x24, d_4_16                            ;
        flw f22, 28(x24)                          ;
_l109:  remw x14, x23, x17                        ;
_l110:  div x12, x17, x21                         ;
_l111:  la x5, d_4_12                             ;
        lbu x25, -0(x5)                           ;
_l112:  fmax.s f5, f10, f15                       ;
_l113:  fsgnj.s f28, f16, f27                     ;
_l114:  xor x19, x19, x19                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 4                          ;
        add x19, x19, x13                         ;
        csrrc x20, mcause, x19                    ;
_l115:  beq x2, x20, _l138                        ;
_l116:  sltiu x13, x3, -1750                      ;
_l117:  fcvt.lu.s x25, f31, rup                   ;
_l118:  divuw x24, x20, x11                       ;
_l119:  la x17, d_5_7                             ;
        addi x17, x17, -8                         ;
        amomin.w x19, x1, (x17)                   ;
_l120:  xor x6, x6, x6                            ;
        csrrs x6, sie, x6                         ;
_l121:  la x6, d_3_20                             ;
        addi x6, x6, 0                            ;
        amoor.w x16, x24, (x6)                    ;
_l122:  sraiw x21, x28, 24                        ;
_l123:  fsqrt.s f20, f31, rdn                     ;
_l124:  mulhsu x9, x3, x8                         ;
_l125:  fcvt.wu.s x16, f18, rmm                   ;
_l126:  la x17, d_3_7                             ;
        addi x17, x17, 4                          ;
        lui x15, 0xffe00                          ;
        xor x17, x17, x15                         ;
        amoadd.w x22, x15, (x17)                  ;
_l127:  fle.s x22, f8, f9                         ;
_l128:  fmsub.s f8, f17, f24, f19, dyn            ;
_l129:  blt x8, x24, _l157                                ;
_l130:  la x27, d_0_16                            ;
        addi x27, x27, -0                         ;
        amomax.d x27, x21, (x27)                  ;
_l131:  la x1, d_0_21                             ;
        addi x1, x1, -0                           ;
        amomin.w x17, x6, (x1)                    ;
_l132:  fsgnjn.s f9, f20, f31                     ;
_l133:  fnmadd.s f23, f3, f17, f22, dyn           ;
_l134:  xor x1, x1, x1                            ;
        addi x28, zero, 3                         ;
        slli x28, x28, 4                          ;
        add x1, x1, x28                           ;
        addi x23, zero, 1                         ;
        slli x23, x23, 5                          ;
        add x1, x1, x23                           ;
        csrrs x9, mscratch, x1                    ;
_l135:  fcvt.l.s x28, f25, dyn                    ;
_l136:  srli x2, x6, 57                           ;
_l137:  bne x12, x6, _l145                                ;
_l138:  remuw x21, x20, x29                       ;
_l139:  divu x4, x0, x2                           ;
_l140:  bgeu x29, x11, _l159                              ;
_l141:  fcvt.s.l f6, x14, rmm                     ;
_l142:  fmsub.s f27, f23, f26, f28, rup           ;
_l143:  feq.s x28, f30, f13                       ;
_l144:  la x3, d_1_10                             ;
        addi x3, x3, -20                          ;
        amomaxu.w x26, x19, (x3)                  ;
_l145:  bltu x4, x17, _l157                               ;
_l146:  la x8, d_1_5                              ;
        addi x8, x8, 0                            ;
        lui x22, 0xffe00                          ;
        xor x8, x8, x22                           ;
        amoor.d x23, x22, (x8)                    ;
_l147:  bne x12, x9, _l157                        ;
_l148:  la x5, d_3_7                              ;
        addi x5, x5, -20                          ;
        sc.w x10, x17, (x5)                       ;
_l149:  la x16, _l68                              ;
        lh x23, -18(x16)                          ;
_l150:  la x9, d_2_3                              ;
        addi x9, x9, -20                          ;
        amomax.w x18, x27, (x9)                   ;
_l151:  fence                                     ;
_l152:  fmin.s f30, f12, f4                       ;
_l153:  la x22, d_3_24                            ;
        addi x22, x22, 16                         ;
        amomaxu.d x23, x11, (x22)                 ;
_l154:  csrrwi x22, pmpaddr3, 31                  ;
_l155:  la x13, d_5_3                             ;
        addi x13, x13, 0                          ;
        amomax.d x28, x28, (x13)                  ;
_l156:  la x12, d_3_5                             ;
        sb x28, -23(x12)                          ;
_l157:  csrrsi x10, pmpaddr6, 19                  ;
_l158:  la x14, d_0_7                             ;
        addi x14, x14, -8                         ;
        amoand.d x10, x8, (x14)                   ;
_l159:;
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
                .dword 0xc24e05369ff785d5, 0x6ed0ca330b28e9c1
                .dword 0x0b7def20b80d6bfe, 0x0dec4aadac67520c
d_0_0:          .dword 0xdb827f8012cc45c9, 0xd2ae72d185811a3f
d_0_1:          .dword 0x5c4a9707bac098c4, 0xd3733d76d74ec564
d_0_2:          .dword 0x67c908179d252138, 0xa7912338748cab48
d_0_3:          .dword 0x20f131f53d697fec, 0xb70cb48003f7ec06
d_0_4:          .dword 0x490b9a15b7203529, 0x7649f5643d607fc2
d_0_5:          .dword 0x81d64a2581567f3b, 0xdd09d97cde581439
d_0_6:          .dword 0x48aedaed109b8309, 0x1d8a876060cc8b95
d_0_7:          .dword 0xbdca0a69bfb7b6c2, 0x198e2e4f2d6ca54e
d_0_8:          .dword 0xe13d1703a4bae391, 0x9833b5fc72e34769
d_0_9:          .dword 0x7581023ed74aa783, 0x25e1a098a21b7cd0
d_0_10:         .dword 0x65a5ae0470dd012c, 0x4c149c0f7909a425
d_0_11:         .dword 0x53af653e176698c6, 0x6bd50f44fd95ce29
d_0_12:         .dword 0xa4536f86f6a8effb, 0x323b1a4637ec8faf
d_0_13:         .dword 0xbec737afa0ca3399, 0xf87c7ed6b1dffc81
d_0_14:         .dword 0x1e5e45949ab7219b, 0xf720491d1b4cb079
d_0_15:         .dword 0x9d3eceb92be4d5f5, 0x28153e63015e45b5
d_0_16:         .dword 0xa076425322bccace, 0x81f989ed734958ca
d_0_17:         .dword 0x501b1794763e129f, 0xbbe7ceccf2f0acab
d_0_18:         .dword 0xa8be9ea808d64cd2, 0xa6de50050638bea5
d_0_19:         .dword 0x665e5438be2f9ec3, 0x52b0ea038ea708d1
d_0_20:         .dword 0xdaabbbc4313475b8, 0x10e3599318df173c
d_0_21:         .dword 0x7f356443d3087cc6, 0x4e357861be214a1d
d_0_22:         .dword 0x8155895db201b3b0, 0x24c5ab595557f621
d_0_23:         .dword 0x64adf96b51cb41be, 0x1e3454dbd857acfa
d_0_24:         .dword 0x026041983ab5541a, 0xf95d4defac7dc2c9
d_0_25:         .dword 0x26f5c53b65870917, 0x24c3add9192b6206
d_0_26:         .dword 0x0427edf4a054645e, 0xa0c33f0961671d7f
d_0_27:         .dword 0xb3e8f3adc2c0767d, 0xfde12489d379080c
                .dword 0x2735c5f8b1715897, 0x6a722b4629782a34
                .dword 0xfd5c1dab38334085, 0x0882c6a038b5cb9a
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xf4fc3f436f866ba0, 0x38f4dbe01c492ed3
                .dword 0x1c03addeed5ac66e, 0x07a0e114f6cf114c
d_1_0:          .dword 0x0d1f43217cb84814, 0xefbab7f6c8fec25e
d_1_1:          .dword 0x11ff055d130c3da1, 0xcc6ee9809ae313f6
d_1_2:          .dword 0xfb1894863d3ccc65, 0xbb2c714819fb5b0a
d_1_3:          .dword 0xa6d541946fbfe99a, 0x290187ecf9321f70
d_1_4:          .dword 0xa41794471be83028, 0x29496392566e0e2e
d_1_5:          .dword 0x8d627d66b06f9b84, 0xbb9853c136b01209
d_1_6:          .dword 0x34007897709f0290, 0x1f46ec16628ce54a
d_1_7:          .dword 0x713cfb107b8d6c3c, 0x2f8c152766727c89
d_1_8:          .dword 0x589330d04d49f32b, 0x291dddfd4bbfffae
d_1_9:          .dword 0xe7475edabd24b1c1, 0x0b51f4e0c367490c
d_1_10:         .dword 0x84c50e2a67ec4b7d, 0x692e160066379d19
d_1_11:         .dword 0x35a4e7bf0261118a, 0x5a1aedaaa2bc63fb
d_1_12:         .dword 0xd09c044f23d28d55, 0x9b6ae2f4fc1ed8dd
d_1_13:         .dword 0x7390a02ebbfc2087, 0x682dd20170f0d0a5
d_1_14:         .dword 0x0792b0e6495f8e5c, 0x3c7a626ab3e6559a
d_1_15:         .dword 0xba49442ca8f99129, 0xa46c931688ed713d
d_1_16:         .dword 0x26e8afac17a795c0, 0x6d6a1002ced8b6a1
d_1_17:         .dword 0x9ad7f454a93e9870, 0xc1f00a7e6ead720c
d_1_18:         .dword 0xe3d719f1c669ff51, 0x26e4dc92c690cae9
d_1_19:         .dword 0xec1497bb1839b5ab, 0xa19dcb0513ba2f50
d_1_20:         .dword 0xfbbd87f8c94a54b6, 0x9c5c06ad064f300c
d_1_21:         .dword 0x66078a3713d86f9d, 0x94c0b5c26471e7b7
d_1_22:         .dword 0x1fc166ee2f0c7401, 0x72816dfca7c76e4d
d_1_23:         .dword 0xcffd949f14675fd4, 0xb77e925114303e9d
d_1_24:         .dword 0xdc6b9aef8f5ad0e7, 0x1a39209586862c8a
d_1_25:         .dword 0x06924a90cd5617ae, 0xeed0126fe5359e38
d_1_26:         .dword 0xb76e6c972de05c81, 0xfe2c0558bbf0a310
d_1_27:         .dword 0xad477792ff5fa7ca, 0x86d13edd97ec6d78
                .dword 0x604179570aa7c018, 0x26927f395943c088
                .dword 0x015065cd07dea852, 0xb534940e3c3b1242
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x7a56a53b8990eeb7, 0x02f194d94aa8803c
                .dword 0x5b330b180475c06c, 0x68f8e0907d12cf48
d_2_0:          .dword 0x2eb13557e82c8a25, 0x3c3ac1d347d02870
d_2_1:          .dword 0x8f3e7f4f5551f778, 0xf1b319988f1b28bc
d_2_2:          .dword 0x54acc22041065d81, 0xbad9c410c143416f
d_2_3:          .dword 0x49eb8bb731b0f593, 0x84972e4417e9b5c3
d_2_4:          .dword 0xd0f03727e2eb9bba, 0x5d5e2fecea95bba3
d_2_5:          .dword 0xede2b98859d024ed, 0x3e8fc2bbc5c55c0e
d_2_6:          .dword 0x756fd7dbd797a005, 0x428164825c1500ef
d_2_7:          .dword 0xce7c284a150f77ed, 0xb4568d9ca1a74b0a
d_2_8:          .dword 0xa639ff59f103bf82, 0x9868bce5d3354447
d_2_9:          .dword 0x56129918155239c9, 0x587bc145e6acdec2
d_2_10:         .dword 0x4b3d5c580b9a4dcd, 0x186d90c50ebaaada
d_2_11:         .dword 0x34ea0491548e0385, 0x9ec8d180bd77d4c1
d_2_12:         .dword 0x1ca948eaafa2be92, 0xca880a53134c9e5f
d_2_13:         .dword 0x7365a9a1f3546a4c, 0x0c5c46b0dd5be077
d_2_14:         .dword 0x69f6164aeb88b244, 0xae098df3e27dfe22
d_2_15:         .dword 0xf965825726fa32b1, 0xbe9ae8e1082a1f9b
d_2_16:         .dword 0x9832b5e99ba8a994, 0x27db06d3ead32dbb
d_2_17:         .dword 0x03c2135013884056, 0x084af05f2aaeb612
d_2_18:         .dword 0x56cc2b1288241cf3, 0x27a4a7b6905b1a81
d_2_19:         .dword 0xe92bbe12e9cabec1, 0xa9e1f4c7fb5c4c72
d_2_20:         .dword 0x8405398483db88f7, 0x47f4a0adde3a0a4b
d_2_21:         .dword 0x9c80f2e33326d92b, 0x4dc08bf4ad7c1547
d_2_22:         .dword 0xa7c01239adf1655a, 0xe0ec55cb37b3fae4
d_2_23:         .dword 0x49abf5dd442a955e, 0x0ce92a1edb97cb1e
d_2_24:         .dword 0xb0b8dca681f7c946, 0xb257553434adcd9f
d_2_25:         .dword 0x45da3f28c1c77791, 0x39fddba748933dae
d_2_26:         .dword 0x146b0732b7bce8ae, 0xcc1890160303497a
d_2_27:         .dword 0x42d0023d2718a609, 0x327f83f0b550d3a1
                .dword 0x2ee5d51dd44cde17, 0x0d0b3fdafc87a63b
                .dword 0x1430f9baf37a0090, 0x7d788f4ac0f0e609
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xc1632d3b8ca0f80d, 0x2595859e1f751acf
                .dword 0xb4e32481b3e93b17, 0xc831865bbdeb5459
d_3_0:          .dword 0x580d43701c8f846b, 0x4ec1db617be27e26
d_3_1:          .dword 0x072274adfad2098e, 0xa4df27c718f7dda0
d_3_2:          .dword 0xc4017dacd0081cf7, 0x7f6ab9a0f40d00f8
d_3_3:          .dword 0x0c46179444730a81, 0x7532d9020289a2f1
d_3_4:          .dword 0x780c4ce7d2e29f60, 0x3f11f2c7cab07caa
d_3_5:          .dword 0x2ef349f8e9a00082, 0xf6d834f740e6a02c
d_3_6:          .dword 0xeef3b4d99f78dc26, 0x9cce3955c7177fa9
d_3_7:          .dword 0x87cce0ad33157abb, 0x94cc3de9991b34c5
d_3_8:          .dword 0xb3ee8d3f5883ebcd, 0xa664dd916dfc4003
d_3_9:          .dword 0x6ecab3b51b6919dd, 0x6697812ee6f2ebc5
d_3_10:         .dword 0xab6d31211fb09970, 0xdaf90bc8fe1185ae
d_3_11:         .dword 0x3fad135770174df9, 0x5504a632f37b8b8c
d_3_12:         .dword 0xe766a68da0593c4c, 0x8b19928c1a62b1a0
d_3_13:         .dword 0xee52cba8aaff7944, 0x14dff7ba3cbee093
d_3_14:         .dword 0x895fc0a0238a6f03, 0x4344be91c51547ad
d_3_15:         .dword 0xd30c715ba0a85ff7, 0x107a16713c4b1494
d_3_16:         .dword 0x457bdebbc52316bb, 0x9f4c9b52ee4b3870
d_3_17:         .dword 0x15a6d31c7da177eb, 0x5a701fc8c8b27e36
d_3_18:         .dword 0x47d8de31f056379d, 0xc303db0ad6f1b51e
d_3_19:         .dword 0xbeadbb7c2e1a02be, 0xba22a0bdee92ab91
d_3_20:         .dword 0xfeb193717afc88c0, 0xa11d2c655497a3b4
d_3_21:         .dword 0x15d82ba1c4608fbe, 0x6f2af2d5597db6c5
d_3_22:         .dword 0xabe3717ddb4c531b, 0xb89d241fbe95167e
d_3_23:         .dword 0xc672de486f4c4643, 0xed76a6c011c35ca7
d_3_24:         .dword 0x74b8e57aa8686445, 0xc59376284b63f123
d_3_25:         .dword 0xf6fbde56d6c319c4, 0xcf7080d1cbba6e16
d_3_26:         .dword 0x59ef271b7c3490e8, 0xd443c0fc0939bf67
d_3_27:         .dword 0xf194da330a3d9345, 0xe34b566fffc13de2
                .dword 0x6abc22fb071c506f, 0x4c545b7d49a82804
                .dword 0xc3693ede48ec16e1, 0xbba123d631cd0422
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x240c8614a10189a5, 0x99be3c3dcf5a29cf
                .dword 0x2a25d3aff4c9bc8b, 0x38d529ac4b1aed64
d_4_0:          .dword 0x7154f34e8df26b2d, 0x56dd285da475cda8
d_4_1:          .dword 0x2c0363c5fe6222dc, 0x911d7f5e5211f804
d_4_2:          .dword 0x95ff888c4f862dd7, 0x845f5f81e4503d94
d_4_3:          .dword 0xa6ce4933a76096df, 0xa0a63e2107df9437
d_4_4:          .dword 0xc9887fbc4bacd5c9, 0x737e8d72a4995981
d_4_5:          .dword 0x468304bc6aa37dbc, 0x9f223524170818c2
d_4_6:          .dword 0x99ce589949606225, 0x1a9d0668e7ba1203
d_4_7:          .dword 0xd33b09fecb926b2e, 0x17619fb08d1d56ed
d_4_8:          .dword 0xb0f8adb599de8ed8, 0x0f23a42d4a3f24f8
d_4_9:          .dword 0x8756e3a1cc32b981, 0xa9b2e885bb344441
d_4_10:         .dword 0x3043513e0223ffae, 0xfe3595b878bed0b0
d_4_11:         .dword 0x4a85738456e3cc71, 0x9da5ac61f4df7ef0
d_4_12:         .dword 0xe3c4ef92d57760b3, 0x69792688bb694dc0
d_4_13:         .dword 0x3624845a30e96fa0, 0x5d567ab90a5b6660
d_4_14:         .dword 0x5039ae23e55a2646, 0x5ec85bfa7c2569c9
d_4_15:         .dword 0x356cdf74ec65108f, 0x09e1bab536fa08d5
d_4_16:         .dword 0x6731a6b8a28e6404, 0x162332880cb2ff2c
d_4_17:         .dword 0x003cc7292d5c3049, 0x2c97fc4909985906
d_4_18:         .dword 0xaff8c0f726739bba, 0xeb370ae91ab89606
d_4_19:         .dword 0xb9751ba429298af9, 0x1b654f7f56d9d9ef
d_4_20:         .dword 0x5be8c4526bc6391e, 0x750b50f82970c895
d_4_21:         .dword 0x6ad66283ad477e2c, 0xcd11455bd97d5790
d_4_22:         .dword 0x55653093e988391f, 0x199ad932ee168a79
d_4_23:         .dword 0xa5a1d4a8e32fe788, 0xc48dc9716d2788b0
d_4_24:         .dword 0x8262139eed51d0ec, 0xa839f6760237dddb
d_4_25:         .dword 0x481314a48bfd8de5, 0x927386ebaec1a909
d_4_26:         .dword 0xc4547eb165cb5855, 0x7fa4a8dd9d3d0913
d_4_27:         .dword 0x7bdba2beda334211, 0xfd89e49ea52918bd
                .dword 0xf361c78f82b3f426, 0x7cee4768039a940f
                .dword 0x36c07c20baa2d0d8, 0xa8adab5c49544850
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x45786188301f8aa4, 0x08a12a8d8a698b1a
                .dword 0xb3a19b3a96f1dc27, 0x98965762ab49f5e0
d_5_0:          .dword 0xf80268ea11e296f1, 0x72aa9401a1c2ce76
d_5_1:          .dword 0xdf31accbcdc43063, 0xda4e59c553e26816
d_5_2:          .dword 0xc5ac854400189889, 0xce1ef92e2cd0949d
d_5_3:          .dword 0xbec300cf59431b16, 0x1a929eb8c0c4818a
d_5_4:          .dword 0x5a9bca2a36b7e372, 0x0e27bdc0420efb04
d_5_5:          .dword 0x2e6d15df81d27b92, 0x412783f0ccff230f
d_5_6:          .dword 0xe80b5be69925b00e, 0x79719d1a5118b558
d_5_7:          .dword 0x3ccc45749f0e67a1, 0xf75e44e98e4c1441
d_5_8:          .dword 0xc06397372dfd0222, 0xd10bbbadb41d4647
d_5_9:          .dword 0x5bf8372516cffc3d, 0x44fc8e51fdea4cc2
d_5_10:         .dword 0x8eddc8067e3d0fbc, 0x0f145ecf3952410c
d_5_11:         .dword 0xadc0abbda69cb46a, 0xb0f7a00c7ef910d8
d_5_12:         .dword 0x4cec89a5f7171796, 0x84a36febf0b0d892
d_5_13:         .dword 0xb229504e9a0e0291, 0x0494a08f1bb578f9
d_5_14:         .dword 0x68c10e3212948fa5, 0x84b4873b5e7c8d3e
d_5_15:         .dword 0xb96a156bacd41645, 0xe00f012c7bee58fe
d_5_16:         .dword 0x52511868e811d917, 0xfbb39276360e3c6c
d_5_17:         .dword 0x25b65591821b8af5, 0x0c42b590ed5cc3a6
d_5_18:         .dword 0x85f9e0f993e8bd38, 0x4254340c051e4f07
d_5_19:         .dword 0x0c37cd7f91417045, 0xd7f1f0b7336313e5
d_5_20:         .dword 0x26f1f53ea22f681b, 0x8cd07264dcb04250
d_5_21:         .dword 0x94753590c979d9a8, 0x9fbd7e5eab87fc14
d_5_22:         .dword 0x42480bd31fadd66c, 0x618e13db06e8afb3
d_5_23:         .dword 0x637be9c17f0f4e94, 0xf7ca952cd0f8dc0f
d_5_24:         .dword 0x528ad34a11f06609, 0x993a07b8b3105749
d_5_25:         .dword 0xc3143976bfce8ab3, 0xfe755e24b25e82bf
d_5_26:         .dword 0xe5a8500c87717afa, 0x4833b05e6a9b4598
d_5_27:         .dword 0xa89090f6a84ca8d5, 0xb17177c97a3047c8
                .dword 0x9cb1518768dc5de6, 0xc26332a007fd8568
                .dword 0xa646b08f60ccb439, 0x62b7495e8dbea63a
         /* Random data */
_end_data5:
              
 
