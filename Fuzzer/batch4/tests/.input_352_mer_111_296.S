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
_p0:    la x13, d_4_26                            ;
        srai x13, x13, 1                          ;
        csrrw x11, pmpaddr5, x13                  ;
_p1:    xor x11, x11, x11                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 21                         ;
        add x11, x11, x12                         ;
        addi x10, zero, 3                         ;
        slli x10, x10, 6                          ;
        add x11, x11, x10                         ;
        csrrw x14, sscratch, x11                  ;
_p2:    xor x12, x12, x12                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 2                          ;
        add x12, x12, x14                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 23                         ;
        add x12, x12, x11                         ;
        csrrc x14, mip, x12                       ;
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
_s0:    la x3, _s1                                        ;
        jalr x22, 0(x3)                           ;
_s1:    sraiw x8, x3, 27                          ;
_s2:;
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
_l0:    la x11, d_2_17                            ;
        sd x16, 0(x11)                            ;
_l1:    la x19, d_4_8                             ;
        addi x19, x19, 0                          ;
        amoor.d x30, x6, (x19)                    ;
_l2:    la x21, d_1_11                            ;
        flw f7, 16(x21)                           ;
_l3:    bgeu x28, x12, _l39                               ;
_l4:    feq.s x6, f15, f10                        ;
_l5:    sraiw x29, x6, 2                          ;
_l6:    flt.s x26, f18, f23                       ;
_l7:    mulhu x0, x16, x0                         ;
_l8:    andi x29, x18, -0                         ;
_l9:    mul x25, x14, x24                         ;
_l10:   addw x12, x29, x25                        ;
_l11:   la x21, d_5_21                            ;
        sh x25, -18(x21)                          ;
_l12:   la x14, d_1_8                             ;
        addi x14, x14, 8                          ;
        amoor.d x24, x29, (x14)                   ;
_l13:   mulh x12, x23, x21                        ;
_l14:   subw x26, x27, x0                         ;
_l15:   fmin.s f21, f18, f21                      ;
_l16:   srli x23, x5, 10                          ;
_l17:   remuw x21, x17, x20                       ;
_l18:   fence.i                                   ;
_l19:   srliw x5, x18, 13                         ;
_l20:   fmul.s f7, f25, f7, rtz                   ;
_l21:   la x7, d_1_20                             ;
        addi x7, x7, -16                          ;
        amoxor.w x29, x3, (x7)                    ;
_l22:   beq x8, x14, _l68                                 ;
_l23:   srli x20, x11, 26                         ;
_l24:   la x21, _l117                                     ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l25:   la x8, d_0_6                              ;
        sb x4, -18(x8)                            ;
_l26:   div x20, x7, x1                           ;
_l27:   xori x20, x11, -1598                      ;
_l28:   bgeu x19, x5, _l100                               ;
_l29:   slliw x14, x5, 18                         ;
_l30:   la x3, d_4_24                             ;
        sh x8, 0(x3)                              ;
_l31:   remw x11, x8, x1                          ;
_l32:   xor x3, x3, x3                            ;
        addi x18, zero, 3                         ;
        slli x18, x18, 9                          ;
        add x3, x3, x18                           ;
        addi x19, zero, 3                         ;
        slli x19, x19, 6                          ;
        add x3, x3, x19                           ;
        addi x3, zero, 1                          ;
        slli x3, x3, 0                            ;
        add x3, x3, x3                            ;
        csrrs x1, satp, x3                        ;
_l33:   fmul.s f5, f30, f16, dyn                  ;
_l34:   la x10, _l124                                     ;
        jalr x16, 0(x10)                          ;
_l35:   fsgnjx.s f17, f19, f16                    ;
_l36:   la x18, d_5_4                             ;
        addi x18, x18, 8                          ;
        amoadd.d x26, x9, (x18)                   ;
_l37:   mulhsu x21, x14, x1                       ;
_l38:   remu x25, x7, x2                          ;
_l39:   la x5, _l107                                       ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_l40:   fcvt.s.l f17, x21, rne                    ;
_l41:   auipc x12, 15                             ;
_l42:   la x12, d_2_5                             ;
        addi x12, x12, -8                         ;
        amominu.d x18, x8, (x12)                  ;
_l43:   la x4, d_2_16                             ;
        sh x23, -28(x4)                           ;
_l44:   fcvt.s.lu f1, x21, rdn                    ;
_l45:   mulhsu x11, x0, x8                        ;
_l46:   la x28, d_5_18                            ;
        addi x28, x28, -28                        ;
        lr.w x5, (x28)                            ;
_l47:   remw x1, x9, x18                          ;
_l48:   la x10, d_5_10                            ;
        addi x10, x10, -8                         ;
        amoadd.d x6, x20, (x10)                   ;
_l49:   csrrci x7, frm, 10                        ;
_l50:   la x18, d_0_20                            ;
        addi x18, x18, 8                          ;
        amoadd.w x16, x2, (x18)                   ;
_l51:   blt x4, x23, _l53                         ;
_l52:   la x23, d_3_11                            ;
        lb x23, -6(x23)                           ;
_l53:   divuw x19, x24, x25                       ;
_l54:   la x2, d_5_1                              ;
        addi x2, x2, 0                            ;
        lui x9, 0xffe00                           ;
        xor x2, x2, x9                            ;
        amominu.d x27, x9, (x2)                   ;
_l55:   srliw x30, x17, 31                        ;
_l56:   fmax.s f0, f7, f10                        ;
_l57:   la x4, _l124                                      ;
        jalr x4, 0(x4)                            ;
_l58:   fcvt.l.s x30, f19, rne                    ;
_l59:   fsqrt.s f30, f21, rdn                     ;
_l60:   div x12, x9, x25                          ;
_l61:   beq x17, x14, _l134                               ;
_l62:   auipc x29, 462357                         ;
_l63:   la x10, d_2_19                            ;
        addi x10, x10, 16                         ;
        lui x9, 0xffe00                           ;
        xor x10, x10, x9                          ;
        sc.w x18, x9, (x10)                       ;
_l64:   li x6, 1                                  ;
        la x18, pt1                               ;
        addi x18, x18, 24                         ;
        sfence.vma x6, x18                        ;
_l65:   slli x4, x12, 0                           ;
_l66:   mulhu x18, x10, x23                       ;
_l67:   fcvt.s.lu f16, x11, rne                   ;
_l68:   auipc x16, 79889                          ;
_l69:   fadd.s f18, f18, f23, rdn                 ;
_l70:   srlw x12, x10, x19                        ;
_l71:   mul x28, x13, x21                         ;
_l72:   fmadd.s f24, f3, f0, f25, rne             ;
_l73:   la x17, d_5_25                            ;
        addi x17, x17, -16                        ;
        amomin.d x19, x3, (x17)                   ;
_l74:   la x29, d_4_27                            ;
        addi x29, x29, -28                        ;
        amominu.w x4, x18, (x29)                  ;
_l75:   ebreak                                    ;
_l76:   csrrsi x26, mscratch, 11                  ;
_l77:   fcvt.s.w f20, x8, rne                     ;
_l78:   la x21, d_5_14                            ;
        lb x18, -10(x21)                          ;
_l79:   mul x18, x16, x30                         ;
_l80:   la x6, _l165                              ;
        jalr x14, 0(x6)                           ;
_l81:   xori x3, x29, -898                        ;
_l82:   fcvt.s.w f17, x23, rtz                    ;
_l83:   la x11, d_1_18                            ;
        addi x11, x11, 0                          ;
        sc.d x19, x11, (x11)                      ;
_l84:   la x16, d_1_11                            ;
        fsw f14, -4(x16)                          ;
_l85:   la x27, d_3_23                            ;
        sw x30, 12(x27)                           ;
_l86:   fence                                     ;
_l87:   fsgnj.s f23, f12, f21                     ;
_l88:   la x18, d_1_8                             ;
        addi x18, x18, -8                         ;
        amoswap.w x4, x8, (x18)                   ;
_l89:   la x20, d_0_13                            ;
        lw x15, 8(x20)                            ;
_l90:   xor x4, x4, x4                            ;
        addi x28, zero, 3                         ;
        slli x28, x28, 26                         ;
        add x4, x4, x28                           ;
        csrrc x17, pmpcfg0, x4                    ;
_l91:   divw x0, x4, x27                          ;
_l92:   addi x10, x22, 2047                       ;
_l93:   la x18, d_3_4                             ;
        sw x28, 0(x18)                            ;
_l94:   la x23, d_3_9                             ;
        addi x23, x23, 8                          ;
        amoor.d x6, x6, (x23)                     ;
_l95:   la x25, d_1_25                            ;
        addi x25, x25, -0                         ;
        lr.d x5, (x25)                            ;
_l96:   fnmsub.s f22, f29, f20, f20, rne          ;
_l97:   la x22, d_5_13                            ;
        addi x22, x22, 0                          ;
        amominu.d x10, x8, (x22)                  ;
_l98:   fadd.s f10, f2, f17, rup                  ;
_l99:   la x10, d_5_4                             ;
        lui x1, 0xffe00                           ;
        xor x10, x10, x1                          ;
        lbu x30, 8(x10)                           ;
_l100:  fnmsub.s f16, f29, f30, f0, dyn           ;
_l101:  srli x3, x3, 23                           ;
_l102:  mulh x4, x26, x30                         ;
_l103:  fdiv.s f10, f15, f4, dyn                  ;
_l104:  srlw x12, x3, x8                          ;
_l105:  la x3, d_1_9                              ;
        addi x3, x3, -4                           ;
        amoadd.w x22, x23, (x3)                   ;
_l106:  csrrci x14, pmpaddr1, 10                  ;
_l107:  div x9, x25, x4                           ;
_l108:  sraw x8, x20, x2                          ;
_l109:  addi x6, x27, -769                        ;
_l110:  fnmadd.s f14, f12, f13, f1, rtz           ;
_l111:  fdiv.s f31, f25, f28, rdn                 ;
_l112:  slliw x1, x7, 12                          ;
_l113:  xori x22, x19, 284                        ;
_l114:  bge x18, x4, _l153                        ;
_l115:  la x24, d_0_25                            ;
        fsw f26, 20(x24)                          ;
_l116:  la x9, d_1_11                             ;
        addi x9, x9, -0                           ;
        amoswap.d x12, x1, (x9)                   ;
_l117:  fmadd.s f6, f16, f8, f24, rtz             ;
_l118:  la x13, d_2_7                             ;
        addi x13, x13, 20                         ;
        amoadd.w x13, x24, (x13)                  ;
_l119:  fadd.s f30, f26, f7, rne                  ;
_l120:  la x30, _l120                                     ;
        lwu x14, 8(x30)                           ;
_l121:  fle.s x8, f22, f12                        ;
_l122:  srliw x16, x1, 15                         ;
_l123:  addiw x30, x12, -224                      ;
_l124:  mulw x29, x16, x24                        ;
_l125:  la x20, d_4_18                            ;
        addi x20, x20, 0                          ;
        amomin.d x25, x1, (x20)                   ;
_l126:  la x12, d_3_16                            ;
        addi x12, x12, -16                        ;
        lr.d x27, (x12)                           ;
_l127:  lui x26, 1048575                          ;
_l128:  la x24, d_5_8                             ;
        addi x24, x24, -0                         ;
        amoswap.d x12, x19, (x24)                 ;
_l129:  fsgnjx.s f17, f25, f9                     ;
_l130:  fmin.s f8, f6, f1                         ;
_l131:  la x27, d_4_17                            ;
        addi x27, x27, 16                         ;
        amoxor.d x21, x23, (x27)                  ;
_l132:  la x23, d_3_5                             ;
        sh x28, -22(x23)                          ;
_l133:  la x17, d_3_25                            ;
        addi x17, x17, -12                        ;
        amoadd.w x28, x12, (x17)                  ;
_l134:  fcvt.s.wu f29, x19, rup                   ;
_l135:  slli x14, x8, 44                          ;
_l136:  fnmsub.s f20, f4, f28, f6, rdn            ;
_l137:  fdiv.s f25, f2, f22, rne                  ;
_l138:  fle.s x2, f17, f3                         ;
_l139:  fsgnjx.s f22, f30, f28                    ;
_l140:  fcvt.s.wu f3, x18, rne                    ;
_l141:  fcvt.wu.s x22, f21, rup                   ;
_l142:  fence                                     ;
_l143:  slli x3, x3, 62                           ;
_l144:  fnmadd.s f13, f29, f0, f0, rtz            ;
_l145:  blt x18, x5, _l152                        ;
_l146:  la x20, d_0_7                             ;
        addi x20, x20, 0                          ;
        amoor.d x7, x18, (x20)                    ;
_l147:  csrrsi x16, pmpaddr1, 3                   ;
_l148:  fmv.w.x f15, x1                           ;
_l149:  slti x2, x10, -1558                       ;
_l150:  la x4, d_5_15                             ;
        srai x4, x4, 1                            ;
        csrrw x8, pmpaddr4, x4                    ;
_l151:  divu x1, x1, x6                           ;
_l152:  ebreak                                    ;
_l153:  la x18, d_4_8                             ;
        lbu x10, -8(x18)                          ;
_l154:  la x20, d_0_27                            ;
        addi x20, x20, 8                          ;
        amoswap.d x25, x27, (x20)                 ;
_l155:  la x20, d_4_11                            ;
        lbu x18, 7(x20)                           ;
_l156:  fmadd.s f29, f12, f12, f6, dyn            ;
_l157:  fmin.s f29, f5, f22                       ;
_l158:  remuw x26, x20, x26                       ;
_l159:  fnmsub.s f29, f25, f30, f28, rtz          ;
_l160:  fcvt.lu.s x9, f7, rdn                     ;
_l161:  divuw x30, x23, x12                       ;
_l162:  divuw x12, x22, x22                       ;
_l163:  la x6, d_1_4                              ;
        lh x21, 28(x6)                            ;
_l164:  ori x14, x27, -108                        ;
_l165:  andi x13, x3, -1559                       ;
_l166:  fcvt.l.s x15, f0, rtz                     ;
_l167:  jal x14, _l168                                    ;
_l168:  ori x16, x28, -596                        ;
_l169:  xori x12, x17, 1675                       ;
_l170:  sltiu x16, x21, 535                       ;
_l171:  la x19, d_0_17                            ;
        flw f28, 0(x19)                           ;
_l172:;
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
                .dword 0xb2bc338b21905339, 0xe5cd3cf257247a27
                .dword 0xfbff826d9ce063e0, 0xdbf4963810ddb377
d_0_0:          .dword 0x4bc4ad1dc48e0fb7, 0x5b33c7d2c6f3417b
d_0_1:          .dword 0x4aef5154e7579a9a, 0x4a302602c14ad072
d_0_2:          .dword 0x1390aa2c3fb4c9e3, 0xf080efd1c3caac78
d_0_3:          .dword 0x8060a324b0d8cf4d, 0x67e02b251c289dcf
d_0_4:          .dword 0x43405d96364aaeaa, 0x8aae03110f880498
d_0_5:          .dword 0x92cd3f2e39268a28, 0xfeced7efbf1a2c05
d_0_6:          .dword 0x7b4eb6275e96aa9d, 0x5bfed5243d25ce47
d_0_7:          .dword 0x43e05424772be30e, 0x7720ccc0795ba99e
d_0_8:          .dword 0x20e93c509bfbe7d1, 0x8066d83293e94115
d_0_9:          .dword 0xc0ff63caf8b0dd7a, 0xc112b948f0fb630e
d_0_10:         .dword 0x8032ac155db4a776, 0xa8fe0f25587edd44
d_0_11:         .dword 0x18f32a7e809ab7f4, 0x112ed685eb592be6
d_0_12:         .dword 0x3d4b3bffc13f7312, 0xf48992daad507392
d_0_13:         .dword 0xf43031e97ab1626b, 0xe9e0b4012d93f89b
d_0_14:         .dword 0xfe5b8c8f6bac7da5, 0x21d7f9ac32ac2698
d_0_15:         .dword 0x1193f37481d7c98e, 0x1d68ff62ffeeecf6
d_0_16:         .dword 0xf0faa84bd4ddcd74, 0x13ddb25686dbfde0
d_0_17:         .dword 0x9f92d48cebaeabb3, 0x36edd9f579e5f140
d_0_18:         .dword 0x13e0a841e6660f81, 0x0f323156d89405d6
d_0_19:         .dword 0x695a432aca7c9593, 0xa8183f1460d65352
d_0_20:         .dword 0xe0f2218ce00afdd5, 0x8f1cc900866feb9c
d_0_21:         .dword 0xaa8629bc1572b09e, 0xf323af027241a8d0
d_0_22:         .dword 0xbe25755e5ca87001, 0x468ac96e1ef5ae87
d_0_23:         .dword 0xcd0b2d17201d98b1, 0xb9b56bbb087574c5
d_0_24:         .dword 0x82d4fe40a7ec8183, 0x9a196b3100e14928
d_0_25:         .dword 0x4ebaf279e9fb3230, 0x4d87f832a70d2d13
d_0_26:         .dword 0x2e2b149abe482fee, 0xe3748e269b94f5c1
d_0_27:         .dword 0x802110e5e6e7f325, 0x8f471e6c272324fc
                .dword 0x59d295eb78f9fe1b, 0x879045203adceb0a
                .dword 0x3bf035e9c4a5e18a, 0x37c27a239466db03
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8e79a621fb76a5c4, 0x1f7643b7a32d55da
                .dword 0x6fadc804231c9d2d, 0x1378c3fe614b9c9b
d_1_0:          .dword 0xfc7b378332048be1, 0x2f126d7c95b4472c
d_1_1:          .dword 0x24ba17548a054fd9, 0x950e8d31390b21e7
d_1_2:          .dword 0xb5b9c46ef9e9488d, 0x930171787d5332f0
d_1_3:          .dword 0xf494a2aea493740c, 0x071c1cca82f31644
d_1_4:          .dword 0x2c5ba2097085f434, 0x82595a0c3f57903b
d_1_5:          .dword 0x85613c028e7686ec, 0x2baca36dac1310f6
d_1_6:          .dword 0x9dae32d9fbf36abf, 0xa4c9356a5e32295d
d_1_7:          .dword 0x02c9ece9c6d5bf90, 0x52a8ade82f46ba9c
d_1_8:          .dword 0x6065c09fbf62924e, 0x758f9a9d33eae3bc
d_1_9:          .dword 0xe55fbdcbf7154aea, 0x4247f8dca7fe45fd
d_1_10:         .dword 0x1bca5886981d2be7, 0xbec1f775a1d0567d
d_1_11:         .dword 0x8b74f658808c3a7f, 0x89ac6ed60b8b96ea
d_1_12:         .dword 0x127952942aeb2754, 0x3dbc115db4c5e34d
d_1_13:         .dword 0x4ed17c97417a1887, 0x66f8ddf596bbdfd4
d_1_14:         .dword 0xb621e37a9f8823da, 0xa6a94a506dc6de94
d_1_15:         .dword 0x9f829301cfbd0ea9, 0xb845d299e79caffd
d_1_16:         .dword 0xb1050b1b1f80ad04, 0xd635a736d6ad4552
d_1_17:         .dword 0x501cbc47f54a030d, 0x227a53a4b3f1fdb6
d_1_18:         .dword 0x47b0af85e750860b, 0x7df335c1e027ecd0
d_1_19:         .dword 0x1135a0a0e1868f0f, 0x4a055884c2d93894
d_1_20:         .dword 0xb73e97cf14b07614, 0x215ec0aa3f59bdf4
d_1_21:         .dword 0xf503c60c7de7aae2, 0xd3fe002329f41f51
d_1_22:         .dword 0xda589317bd570eb3, 0x0375fac15ec5a5d2
d_1_23:         .dword 0x02096bd592e40c72, 0xffe8c04658e23e22
d_1_24:         .dword 0x292bab056172b26e, 0x7f034e8113fda23a
d_1_25:         .dword 0xdfbd281eca85eb3f, 0xf54200d62e05bc43
d_1_26:         .dword 0x00b81f57f3111eb6, 0xafb54a9612f03c36
d_1_27:         .dword 0x4b17836ff08f0dce, 0xa12c5da4b46ef9ae
                .dword 0x88ff4962a103fb9a, 0x4962381f1c4f1bbf
                .dword 0x2f29aeff465e3098, 0x6ed6bb293b226769
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x77f55a0454d0a9a6, 0x3d88d9c4abcdc84f
                .dword 0x2292c1f6bc5e4d0a, 0x252a12682bedbafc
d_2_0:          .dword 0xcd451ce8a630f7ba, 0x85044c4e33b9783f
d_2_1:          .dword 0x296c83bc99181bd3, 0x24bf27223007a08e
d_2_2:          .dword 0x4e4993fe2fc8ef61, 0x092add91ffbff9f1
d_2_3:          .dword 0x2ab6174f62a593ac, 0xada9fe62d078033d
d_2_4:          .dword 0xeacf0d4a76f5f87c, 0x86f02e98346a2bc3
d_2_5:          .dword 0xad4636a6239d6c0c, 0x1eef47bfac56f778
d_2_6:          .dword 0xd9f581114f425022, 0x8450a3994b9fb17f
d_2_7:          .dword 0x763f3de90a979714, 0x9f334cbb18c354d2
d_2_8:          .dword 0x23a2470b11f917b6, 0x26090b768440d494
d_2_9:          .dword 0xe417a25b5763e461, 0xb9fa1970d5fdf81c
d_2_10:         .dword 0xf310c92007b28fee, 0xfb4447b5042f6487
d_2_11:         .dword 0x6b39241712fe0f79, 0xf2e4e3dc666f4403
d_2_12:         .dword 0xd2ba876b2fedc427, 0x278d6af38a75486a
d_2_13:         .dword 0x1df651e2909dba37, 0xfc5da3e07c1b28b5
d_2_14:         .dword 0x6e82ab7bf15892ff, 0x94fe520736b21c25
d_2_15:         .dword 0x7f4c3df0b5899014, 0x734fcd5b971aa202
d_2_16:         .dword 0x7f34cb8e3aa311fd, 0x778156a46d1306eb
d_2_17:         .dword 0x051ded074ab3d3e2, 0x4edad50bfd13edd1
d_2_18:         .dword 0x71f1f12186b1fef3, 0x17288fedd89cd494
d_2_19:         .dword 0xcaca0b4b97cd5a41, 0x6e49eded5d015d98
d_2_20:         .dword 0x63815f1cb302912c, 0xb647e6dc9d11eb0a
d_2_21:         .dword 0x201fe127d8fd807e, 0x25800ca4befb565a
d_2_22:         .dword 0x83fca31ea82df3ff, 0x191fb61b51306d7a
d_2_23:         .dword 0xd3435ff4714d4581, 0x783a9e3a5fab0233
d_2_24:         .dword 0x1c1caac2e2c1ff59, 0x8105f3c0d5fa7921
d_2_25:         .dword 0xeaf844d783d55308, 0x45d03ace0ef93b71
d_2_26:         .dword 0xa8d58d7a18846fe3, 0x022bfe2e2f3b464b
d_2_27:         .dword 0x40b3eeb8ba08a5f3, 0xd0957a70cb414770
                .dword 0x09069df647360309, 0xbd01f23e34656844
                .dword 0x19c117cd3fd70fc2, 0x06cfe2ad79f99e31
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xbe3e39b33cdc6415, 0xb1117ff6561e6916
                .dword 0xa7d905c66c452604, 0xaa246ccc6aab3251
d_3_0:          .dword 0x1c9d8c68b0cc232d, 0x516abb3297436504
d_3_1:          .dword 0x357edfc1095a4c44, 0xfc76f4e487933aaa
d_3_2:          .dword 0x285e5c0065394bd3, 0xe56e43952346a26a
d_3_3:          .dword 0x2652986c1d329252, 0xc321bf123be97c08
d_3_4:          .dword 0xf44191367d12938e, 0xb028575bc8acf14d
d_3_5:          .dword 0x6d23d65bd122615b, 0xbd9647836b9bba8f
d_3_6:          .dword 0xebf1ec95fe98f748, 0x6a816c2ce1651f77
d_3_7:          .dword 0xde30cf36e308938d, 0xa5740570f916b781
d_3_8:          .dword 0x149fafc83e9bd18e, 0xf7cb02670097d496
d_3_9:          .dword 0xbfe67db4e59faea1, 0xc4044df9c9aec498
d_3_10:         .dword 0x710934ca394633ad, 0x4889a9dba6524934
d_3_11:         .dword 0xa8396ba8f6fed44d, 0x3d9259244b3200d0
d_3_12:         .dword 0x5af9223839478362, 0xe97a06010d0f7005
d_3_13:         .dword 0x311a5cd9eaf1f22b, 0x41a0bfa0da875be0
d_3_14:         .dword 0xbffcff7406a43883, 0x1a89598d4332df88
d_3_15:         .dword 0x2ec8f8ae4cd500df, 0x59b2b08035c4ce3d
d_3_16:         .dword 0xabd1b7e7ae0b17bd, 0x4c09e065e159f342
d_3_17:         .dword 0x27e43fb8d6924dbe, 0x269ce56ec4b4e2e8
d_3_18:         .dword 0x0edf978158ae6ec1, 0xf5e46f8c826d6f89
d_3_19:         .dword 0x65fb58d6fd7b2791, 0xcf3b9e96e627746a
d_3_20:         .dword 0xf18cbbe41b123768, 0xd30b6cfe830966b2
d_3_21:         .dword 0x27acf1ec39e166f5, 0xc277ace14af6e05f
d_3_22:         .dword 0xe84f7eb8d37d31b7, 0x89bf63696bc69853
d_3_23:         .dword 0x36dac896764532aa, 0x08337326e544fa83
d_3_24:         .dword 0x87c54b968662db0e, 0x5057ef35dd9a9d7b
d_3_25:         .dword 0x8aee0102bc3911a2, 0x667e1ae8abf0f133
d_3_26:         .dword 0xa7014c9bf0cd56ef, 0x3835577f8d8fa295
d_3_27:         .dword 0x1cc9dd56a28918f7, 0x297510065d4a780d
                .dword 0x0fcba487828c1629, 0x5e2f7147ea77b8b5
                .dword 0x2ce5223e33ca152e, 0x7d3d722bc2c24cdf
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x16f500122e6523e4, 0x54623ca43f7f3c9f
                .dword 0xee7cfab9791b543f, 0x1b4a5ab32b053364
d_4_0:          .dword 0x8c3468b4f38dd260, 0x6f252bfc7d134d17
d_4_1:          .dword 0xb953d9eea7ce6360, 0x058034ea38fb5aa6
d_4_2:          .dword 0xe85ef717bd5cc1cf, 0x9e886d178196adb7
d_4_3:          .dword 0xa054beec67884012, 0xa85c1047778a59c0
d_4_4:          .dword 0x15f5c02574d3f315, 0xa8ef567534f52d0d
d_4_5:          .dword 0x483df0bf30c50649, 0xb5c313123b9acaea
d_4_6:          .dword 0xf7f70f6446af2fdc, 0x07fedeb8531d88cf
d_4_7:          .dword 0x37cd6b56bb0dedad, 0xffc719737b26b816
d_4_8:          .dword 0x3a2cac19b1c7ad8c, 0x4fd5385bc721a69c
d_4_9:          .dword 0x511da02f5447abc8, 0x4953be5cabcda307
d_4_10:         .dword 0xe37f8f7484cc6439, 0x55b2f7351c842b53
d_4_11:         .dword 0xf39745b2d2ef6a3d, 0xfc93382323da46f1
d_4_12:         .dword 0x004e243f2db49891, 0x18a763dcd14d0d56
d_4_13:         .dword 0x592b135d501656c5, 0xe202e5524f840c41
d_4_14:         .dword 0x5bd3b225b616037d, 0x6e6cb07db03c904a
d_4_15:         .dword 0xf9b1a627a20ea56a, 0x98ab3b9ef01c6308
d_4_16:         .dword 0x36e5c390e7d34077, 0xb696c23c42a1892f
d_4_17:         .dword 0x12602d6092ebb930, 0x7dc30505ecc9aecb
d_4_18:         .dword 0x43509aab673da190, 0xf5690b8ca69d6d70
d_4_19:         .dword 0xa360262d33b60269, 0x5017f3e46cd8e922
d_4_20:         .dword 0xc0e6dd147da20374, 0x15bc6bd3df712b4a
d_4_21:         .dword 0xdbbecf51d6316554, 0x7d789e90e3a66313
d_4_22:         .dword 0x9e1762d6d4edfb2f, 0x8974137a163697d8
d_4_23:         .dword 0x0439394a9e61e8f0, 0xa1876fe40b59bc2b
d_4_24:         .dword 0x9f5a525c3fcb9999, 0x559cb593bbc861f9
d_4_25:         .dword 0x25d525e31537de2a, 0xcfc5019cd92c3595
d_4_26:         .dword 0xa58c939e7e169f59, 0x4b89dd77c5c9329d
d_4_27:         .dword 0x22837bb47397c1bd, 0x2610de00483b8c2e
                .dword 0xcb9142ff07426db2, 0x1610999a3831fd3b
                .dword 0x1cc5b3d38064b311, 0x2be2fdf5df1cc881
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x54dde04043df588d, 0x344ed7056f07c8d8
                .dword 0x357c1fbff0ba91de, 0xe4cb8d50c0417082
d_5_0:          .dword 0x9a822848c5d2eaa5, 0x939bf547153821ae
d_5_1:          .dword 0xd32533581f1d086c, 0xc328eb20f95b8d7d
d_5_2:          .dword 0x430b873b3260a241, 0x6fcbd0426c88a9d9
d_5_3:          .dword 0x9b074c25101ec5c2, 0xa9c527a29510de95
d_5_4:          .dword 0x6e6db9eae7abe20d, 0x7077d3b5b8a930b1
d_5_5:          .dword 0x4776fa6261783b37, 0xffd19b910098f489
d_5_6:          .dword 0x59d4296a806405ee, 0x31b11f2c62f94993
d_5_7:          .dword 0x76a4eed46c751db1, 0x8314e6d13c4e35b2
d_5_8:          .dword 0xba76bcc7c6269488, 0x56d00be11a86f662
d_5_9:          .dword 0xad10382284df003a, 0x237c4936337d4367
d_5_10:         .dword 0xabdc3c221347552b, 0x1f7ca57f39335b66
d_5_11:         .dword 0xe5785bb1bf861053, 0x501f2512418834c7
d_5_12:         .dword 0xff9a09d1abf07be9, 0x192eb0f0e7db8d01
d_5_13:         .dword 0xa14b7b8653406dae, 0xb699bac1326cb82f
d_5_14:         .dword 0x83d1eece8b9c7dc5, 0x8efd5e5b637d4be9
d_5_15:         .dword 0xf93cca82e4dc2142, 0x880017a7d59c2485
d_5_16:         .dword 0x994f6e0476b540d4, 0xeeea610a53c36c29
d_5_17:         .dword 0x02585be4b382ffcd, 0x2d6c024ae8c79404
d_5_18:         .dword 0x67db18092db7942a, 0x9ed509a469b00e23
d_5_19:         .dword 0x1e07a6c37377b100, 0x1f0bac5f20ada44f
d_5_20:         .dword 0x763eab52d5053bf8, 0x332345dfd2af0cf5
d_5_21:         .dword 0xd047fcc6fa4efd32, 0x5af21cdba6ed0e16
d_5_22:         .dword 0xd133348061463d91, 0xa1b51aa291aba5b1
d_5_23:         .dword 0x0631564419a58acd, 0x6a02643acebe9055
d_5_24:         .dword 0x2c83a0a0c59b39b2, 0x20d07b33fbeb60a6
d_5_25:         .dword 0x7ebfd60e0fe6d1c2, 0x152c94d990647364
d_5_26:         .dword 0xa8dd2edd17302801, 0xa7b220f46309875d
d_5_27:         .dword 0xb71087bbc8fc84b6, 0x80d8d994bf7dda1d
                .dword 0x033dc1725833bb47, 0x3138892be429a82e
                .dword 0x2f307bfbfc335273, 0xf9aad41b9d72fd58
         /* Random data */
_end_data5:
              
 
