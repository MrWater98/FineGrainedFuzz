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
_p0:    csrrwi x14, pmpaddr2, 25                  ;
_p1:    csrrsi x13, satp, 31                      ;
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
_s0:    sltiu x2, x15, 841                        ;
_s1:    divw x21, x12, x23                        ;
_s2:    la x26, d_2_26                            ;
        addi x26, x26, -8                         ;
        amomaxu.w x26, x12, (x26)                 ;
_s3:    fmin.s f13, f25, f13                      ;
_s4:;
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
_l0:    ebreak                                    ;
_l1:    fmv.x.w x22, f5                           ;
_l2:    xor x26, x26, x26                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 0                          ;
        add x26, x26, x28                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 26                         ;
        add x26, x26, x18                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 2                          ;
        add x26, x26, x13                         ;
        csrrc x26, sie, x26                       ;
_l3:    fence.i                                   ;
_l4:    andi x12, x24, -2047                      ;
_l5:    fmv.x.w x25, f22                          ;
_l6:    csrrwi x28, pmpcfg0, 0                    ;
_l7:    la x19, d_5_25                            ;
        lbu x19, 26(x19)                          ;
_l8:    ebreak                                    ;
_l9:    feq.s x4, f9, f22                         ;
_l10:   la x18, d_1_2                             ;
        lui x27, 0xffe00                          ;
        xor x18, x18, x27                         ;
        sw x12, 16(x18)                           ;
_l11:   flt.s x11, f16, f10                       ;
_l12:   srliw x15, x2, 5                          ;
_l13:   fmin.s f6, f9, f20                        ;
_l14:   fcvt.lu.s x14, f10, rmm                   ;
_l15:   la x22, _l45                                      ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_l16:   fle.s x12, f9, f4                         ;
_l17:   xor x22, x22, x22                         ;
        addi x11, zero, 3                         ;
        slli x11, x11, 19                         ;
        add x22, x22, x11                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 18                         ;
        add x22, x22, x18                         ;
        addi x23, zero, 1                         ;
        slli x23, x23, 21                         ;
        add x22, x22, x23                         ;
        csrrc x1, mie, x22                        ;
_l18:   la x4, d_0_6                              ;
        sh x23, -30(x4)                           ;
_l19:   bne x13, x26, _l122                               ;
_l20:   la x10, d_1_24                            ;
        lh x29, 0(x10)                            ;
_l21:   la x1, d_3_14                             ;
        addi x1, x1, 20                           ;
        lui x19, 0xffe00                          ;
        xor x1, x1, x19                           ;
        amoxor.w x1, x19, (x1)                    ;
_l22:   la x8, d_1_6                              ;
        addi x8, x8, -8                           ;
        amomax.d x11, x12, (x8)                   ;
_l23:   la x2, _l85                                       ;
        jalr x28, 0(x2)                           ;
_l24:   fcvt.w.s x6, f1, rtz                      ;
_l25:   sraw x9, x4, x3                           ;
_l26:   mulhsu x28, x5, x25                       ;
_l27:   srlw x4, x5, x8                           ;
_l28:   fmadd.s f4, f19, f0, f12, rne             ;
_l29:   addi x21, x22, -1148                      ;
_l30:   fsub.s f0, f8, f15, dyn                   ;
_l31:   fclass.s x29, f12                         ;
_l32:   mulw x0, x2, x16                          ;
_l33:   fadd.s f9, f5, f10, rdn                   ;
_l34:   fcvt.wu.s x18, f29, rne                   ;
_l35:   fcvt.w.s x24, f3, rdn                     ;
_l36:   fmul.s f15, f3, f1, rmm                   ;
_l37:   fcvt.wu.s x1, f5, rtz                     ;
_l38:   fcvt.l.s x19, f12, rup                    ;
_l39:   xori x16, x3, 122                         ;
_l40:   jal x12, _l125                                    ;
_l41:   sraiw x11, x26, 19                        ;
_l42:   la x14, d_0_2                             ;
        addi x14, x14, -16                        ;
        lui x22, 0xffe00                          ;
        xor x14, x14, x22                         ;
        amomax.d x29, x22, (x14)                  ;
_l43:   fle.s x13, f26, f24                       ;
_l44:   la x9, d_0_21                             ;
        addi x9, x9, -8                           ;
        lui x1, 0xffe00                           ;
        xor x9, x9, x1                            ;
        amominu.d x22, x1, (x9)                   ;
_l45:   la x5, _l46                                       ;
        csrrw zero, uepc, x5                      ;
        uret                                      ;
_l46:   srliw x28, x23, 28                        ;
_l47:   la x14, d_1_11                            ;
        sw x20, -16(x14)                          ;
_l48:   divuw x1, x6, x25                         ;
_l49:   ebreak                                    ;
_l50:   la x26, d_5_13                            ;
        addi x26, x26, 8                          ;
        amoxor.d x21, x26, (x26)                  ;
_l51:   fsgnjn.s f4, f0, f23                      ;
_l52:   csrrsi x10, mepc, 11                      ;
_l53:   divw x9, x23, x21                         ;
_l54:   la x23, d_3_17                            ;
        addi x23, x23, 0                          ;
        lui x30, 0xffe00                          ;
        xor x23, x23, x30                         ;
        sc.d x7, x23, (x23)                       ;
_l55:   fsgnjx.s f20, f11, f6                     ;
_l56:   feq.s x28, f6, f6                         ;
_l57:   divuw x6, x21, x1                         ;
_l58:   la x18, d_4_12                            ;
        sh x21, -10(x18)                          ;
_l59:   mul x25, x24, x5                          ;
_l60:   fmin.s f3, f27, f17                       ;
_l61:   sraw x13, x23, x13                        ;
_l62:   la x16, d_5_16                            ;
        addi x16, x16, 24                         ;
        amoadd.w x16, x14, (x16)                  ;
_l63:   srliw x17, x13, 13                        ;
_l64:   fsgnjx.s f18, f0, f29                     ;
_l65:   fsgnjx.s f0, f0, f10                      ;
_l66:   fence                                     ;
_l67:   fcvt.l.s x19, f15, rtz                    ;
_l68:   la x4, _l17                                       ;
        lbu x1, -15(x4)                           ;
_l69:   mul x19, x11, x6                          ;
_l70:   mulhsu x3, x16, x0                        ;
_l71:   srli x11, x27, 0                          ;
_l72:   rem x4, x13, x22                          ;
_l73:   flt.s x19, f23, f27                       ;
_l74:   jal x24, _l110                                    ;
_l75:   la x3, d_1_18                             ;
        addi x3, x3, -16                          ;
        amoor.d x20, x2, (x3)                     ;
_l76:   la x27, _l46                                      ;
        srai x27, x27, 1                          ;
        csrrs x21, pmpaddr5, x27                  ;
_l77:   fcvt.s.wu f12, x9, rup                    ;
_l78:   fclass.s x13, f14                         ;
_l79:   fmul.s f21, f30, f12, dyn                 ;
_l80:   la x4, d_5_18                             ;
        addi x4, x4, -0                           ;
        amoxor.d x1, x26, (x4)                    ;
_l81:   fcvt.l.s x4, f20, rtz                     ;
_l82:   fmax.s f3, f4, f11                        ;
_l83:   la x21, d_4_25                            ;
        addi x21, x21, -12                        ;
        lui x25, 0xffe00                          ;
        xor x21, x21, x25                         ;
        amoand.w x4, x25, (x21)                   ;
_l84:   srlw x22, x22, x12                        ;
_l85:   xori x4, x3, 777                          ;
_l86:   divw x0, x17, x3                          ;
_l87:   addw x16, x5, x10                         ;
_l88:   bne x17, x13, _l128                       ;
_l89:   fmadd.s f19, f28, f21, f15, dyn           ;
_l90:   la x1, d_1_14                             ;
        srai x1, x1, 1                            ;
        csrrs x9, pmpaddr3, x1                    ;
_l91:   la x20, d_0_14                            ;
        addi x20, x20, 24                         ;
        amomin.w x16, x8, (x20)                   ;
_l92:   bgeu x28, x14, _l146                              ;
_l93:   fmv.w.x f8, x28                           ;
_l94:   slliw x11, x15, 13                        ;
_l95:   fsqrt.s f25, f28, rup                     ;
_l96:   la x3, d_4_14                             ;
        lui x10, 0xffe00                          ;
        xor x3, x3, x10                           ;
        sd x25, -16(x3)                           ;
_l97:   mulw x24, x3, x22                         ;
_l98:   fadd.s f3, f10, f0, dyn                   ;
_l99:   fcvt.w.s x6, f0, rne                      ;
_l100:  la x26, d_0_3                             ;
        sw x13, 16(x26)                           ;
_l101:  fdiv.s f27, f13, f10, rup                 ;
_l102:  la x13, d_1_13                            ;
        addi x13, x13, 8                          ;
        amominu.w x9, x17, (x13)                  ;
_l103:  addiw x3, x14, 121                        ;
_l104:  la x25, d_1_3                             ;
        addi x25, x25, -28                        ;
        sc.w x28, x16, (x25)                      ;
_l105:  la x19, d_2_23                            ;
        fsw f15, 16(x19)                          ;
_l106:  fcvt.w.s x12, f2, rup                     ;
_l107:  bltu x14, x16, _l139                      ;
_l108:  la x25, d_4_24                            ;
        addi x25, x25, -20                        ;
        lui x6, 0xffe00                           ;
        xor x25, x25, x6                          ;
        lr.w x7, (x25)                            ;
_l109:  divuw x7, x18, x26                        ;
_l110:  la x4, d_3_21                             ;
        addi x4, x4, -16                          ;
        amoadd.d x8, x24, (x4)                    ;
_l111:  csrrwi x1, pmpcfg0, 19                    ;
_l112:  srlw x23, x0, x24                         ;
_l113:  divu x27, x22, x12                        ;
_l114:  fdiv.s f24, f5, f5, rne                   ;
_l115:  la x24, d_1_11                            ;
        sh x25, 22(x24)                           ;
_l116:  fcvt.l.s x21, f6, rmm                     ;
_l117:  fnmadd.s f5, f2, f2, f3, rup              ;
_l118:  xor x14, x14, x14                         ;
        addi x22, zero, 3                         ;
        slli x22, x22, 27                         ;
        add x14, x14, x22                         ;
        addi x24, zero, 3                         ;
        slli x24, x24, 28                         ;
        add x14, x14, x24                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 21                         ;
        add x14, x14, x28                         ;
        csrrc x16, mcause, x14                    ;
_l119:  bge x18, x19, _l144                       ;
_l120:  la x25, d_4_10                            ;
        addi x25, x25, -0                         ;
        amominu.d x29, x27, (x25)                 ;
_l121:  srliw x3, x24, 25                         ;
_l122:  la x7, d_3_7                              ;
        sb x6, 31(x7)                             ;
_l123:  la x1, d_4_21                             ;
        addi x1, x1, 0                            ;
        sc.d x24, x1, (x1)                        ;
_l124:  fcvt.lu.s x27, f0, rmm                    ;
_l125:  la x9, d_1_22                             ;
        addi x9, x9, 0                            ;
        amomaxu.w x29, x15, (x9)                  ;
_l126:  sltiu x4, x24, -1286                      ;
_l127:  xor x22, x22, x22                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 30                           ;
        add x22, x22, x1                          ;
        addi x21, zero, 1                         ;
        slli x21, x21, 18                         ;
        add x22, x22, x21                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 2                          ;
        add x22, x22, x14                         ;
        csrrc x22, scause, x22                    ;
_l128:  divw x12, x18, x5                         ;
_l129:  remuw x7, x20, x4                         ;
_l130:  mul x29, x4, x14                          ;
_l131:  lui x20, 0                                ;
_l132:  la x17, d_0_17                            ;
        addi x17, x17, 16                         ;
        amoor.d x20, x16, (x17)                   ;
_l133:  fcvt.s.w f11, x15, rdn                    ;
_l134:  la x27, d_1_16                            ;
        addi x27, x27, 28                         ;
        lui x30, 0xffe00                          ;
        xor x27, x27, x30                         ;
        amomaxu.w x20, x30, (x27)                 ;
_l135:  ebreak                                    ;
_l136:  fcvt.lu.s x12, f19, rtz                   ;
_l137:  sltiu x17, x2, 1007                       ;
_l138:  bgeu x18, x16, _l143                      ;
_l139:  fence                                     ;
_l140:  li x10, 0                                 ;
        la x23, pt2                               ;
        addi x23, x23, 0                          ;
        sfence.vma x10, x23                       ;
_l141:  sraw x4, x0, x11                          ;
_l142:  fdiv.s f12, f4, f23, rtz                  ;
_l143:  fcvt.s.l f10, x9, rdn                     ;
_l144:  auipc x7, 261913                          ;
_l145:  la x14, d_1_13                            ;
        addi x14, x14, -8                         ;
        amomax.d x11, x12, (x14)                  ;
_l146:  jal x7, _l147                                     ;
_l147:;
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
                .dword 0xbba95f427f62a32b, 0x4fa0a409bce90efd
                .dword 0x7988153968bbdb03, 0xaaf79a0b937f70b5
d_0_0:          .dword 0xbbd66927cd2f48cf, 0x11925bae21f8c697
d_0_1:          .dword 0x26f538628e21a91e, 0x294e0a378c7e94ca
d_0_2:          .dword 0x29309a5f6b2aa45e, 0x22aa88b75d72c577
d_0_3:          .dword 0x3db1196b53cc8de4, 0xdc314c07d72c391e
d_0_4:          .dword 0x8a75abca3eb6adb6, 0x7edffd687da3da67
d_0_5:          .dword 0x12c4b8a33d4c18af, 0xa974800dd267ae94
d_0_6:          .dword 0x31e00d2e2fc1be65, 0xe87ba1c7d1000fa5
d_0_7:          .dword 0xc059608772fb3344, 0xb8f0fb9d6bfc9717
d_0_8:          .dword 0xeaca02428f1462e9, 0x7ac18f72199ef9dc
d_0_9:          .dword 0xe87356b394034d92, 0x66b4217a280da258
d_0_10:         .dword 0x1816624d4b85a848, 0x3c560f1b828c7334
d_0_11:         .dword 0x5fa4c495c35be3d5, 0x184a055ba005e3c4
d_0_12:         .dword 0x32d1552467f9a766, 0x84111191912355b4
d_0_13:         .dword 0x6b636cd6e3ed1b2a, 0xda92e872774bb68d
d_0_14:         .dword 0xc60d299e7fe6e1cc, 0x266504ccddfe1430
d_0_15:         .dword 0xc2273dc666caea6e, 0xb3ec29342dffee9f
d_0_16:         .dword 0xbf8411bb96c1a8b2, 0xbbabb2d0e6d4aa26
d_0_17:         .dword 0xca771d5218ed6e94, 0xd5054e893ed2bc70
d_0_18:         .dword 0x2075b14e7957a218, 0x1db1fa096d8e0b85
d_0_19:         .dword 0x16a6eb3e29fe8748, 0x8e162540ff5eb4b2
d_0_20:         .dword 0x7de270c1195bdbf2, 0xbdd9aa6d962d6fad
d_0_21:         .dword 0xf6651ac5a07d10c6, 0xe7ca101a78583d90
d_0_22:         .dword 0xfbb885cf5fd3a135, 0x7835a906eccbc510
d_0_23:         .dword 0x80a08af478514996, 0xad02d975d8b50b79
d_0_24:         .dword 0xcbe5c27195ddea3c, 0xdc283cef3bcf6544
d_0_25:         .dword 0x1b5869bca582e78f, 0x170fb62303f37f4c
d_0_26:         .dword 0xd8e80fd58df5b869, 0x895c0ac4e77dfeee
d_0_27:         .dword 0xf404830a0d7ef13c, 0x3a7c448827146d65
                .dword 0x5ef0308e03e6ece3, 0xafbc0d67bf9467da
                .dword 0x084aa09bc006b6f5, 0xd3fadc97a8482180
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x9c609bd6b9e6def1, 0x2b3b9969fb607f7a
                .dword 0x2e36cfdaa82b0b34, 0x295b0cbd733dd911
d_1_0:          .dword 0xbfea268b88918674, 0x66c73c3530313bc2
d_1_1:          .dword 0xfa9fe6ca56489ade, 0xf949652d785cce22
d_1_2:          .dword 0xab3429d4ecd1a29d, 0xf36b46721d9fbee0
d_1_3:          .dword 0xa527745885923f1f, 0x473f4553f12fa654
d_1_4:          .dword 0x859fb1366b4557a3, 0xe295c7c93c18d3d5
d_1_5:          .dword 0xe93251f6e0268d1c, 0xa0694a85940f2403
d_1_6:          .dword 0xa130fb7dcea45025, 0xc345f9f41f0de28e
d_1_7:          .dword 0xb8202cf3a31a0fb0, 0x8962743ffeb361ec
d_1_8:          .dword 0xe7e3ae0211b56eb5, 0xe7fa8c5449ac719f
d_1_9:          .dword 0x95ba647dded5ed25, 0xdb03a45b7b9cfa96
d_1_10:         .dword 0xaa95502d4f17629b, 0xe21674962325da67
d_1_11:         .dword 0x51e6a286da4fdab2, 0x60a0374fe46ff1d5
d_1_12:         .dword 0x36a81cbea4d14924, 0x134dd124e2faccf2
d_1_13:         .dword 0xaf5f7f873bd3a72c, 0xd5683709f8be0438
d_1_14:         .dword 0x48ad64defd796dab, 0xb38ea280e3884a90
d_1_15:         .dword 0xdbabe52c92a53bed, 0x809c65d81a755241
d_1_16:         .dword 0x0ba5f58a8116a20b, 0xc8881e20f727cad8
d_1_17:         .dword 0xee1bcea2475ca9c0, 0x56e5470d846b7c3a
d_1_18:         .dword 0x5d55156c503e1de7, 0x92d5a119c0c74964
d_1_19:         .dword 0x954c8271170fc8f7, 0x0484ede6967fa9dd
d_1_20:         .dword 0x9e7f5802ae7479b3, 0x2408589205138ec6
d_1_21:         .dword 0x822850028a2ee065, 0xe138832ca1ad282f
d_1_22:         .dword 0xad60f2de6b5567e2, 0x8923eebb0d3b573e
d_1_23:         .dword 0xa2c400c2125ee645, 0xb271c69f6bb7053b
d_1_24:         .dword 0xa5b6f8fe13fe64df, 0x235fad84ecf7ce4d
d_1_25:         .dword 0x142321a2d4e2b22d, 0x0b57c4dd4e1ac899
d_1_26:         .dword 0xaee72f0e1fb60ed4, 0x5d7671000511ae32
d_1_27:         .dword 0x7caab7a0b151abf2, 0x92684de94aeea0de
                .dword 0x2579cff19d74b643, 0x865a4c92a9637512
                .dword 0x9b9161d3557df7b2, 0xb461d090c173f6ef
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x859a2e9579a4e0de, 0x7d32d7cf9907e93e
                .dword 0x5ce8cb89788ab127, 0x9b0933eddbe6c007
d_2_0:          .dword 0x4e59124c3e182667, 0x62bf14f8029fee4f
d_2_1:          .dword 0xb49e630439ca7520, 0x09a6f763abba46b2
d_2_2:          .dword 0xfa0a66cf8acadea6, 0x1ca63b12fa5443a7
d_2_3:          .dword 0x93afe28253c10996, 0x976c7133cf591f22
d_2_4:          .dword 0x7b9efdf29e511617, 0x153f729bb75df553
d_2_5:          .dword 0x89a35197ccc0fc8e, 0xd77a3353d965e907
d_2_6:          .dword 0xbc2b693caf2374c6, 0x259a78ebe24410bf
d_2_7:          .dword 0x09d79aba9e1d554c, 0x82b70705ff4ba9e7
d_2_8:          .dword 0x9d55683ccea46288, 0xa68872d8d164a243
d_2_9:          .dword 0xe183b6f1802ae83c, 0x489f6d7196e9805a
d_2_10:         .dword 0x89fa1db67715201b, 0xa0bee799bdb6c64d
d_2_11:         .dword 0xb9763c52921ee6f3, 0xf1a0bc271d747617
d_2_12:         .dword 0xb894711c13b186c1, 0x40a8a783f9f571e8
d_2_13:         .dword 0xbbcbd57479954497, 0x4afb4b57a9de80c7
d_2_14:         .dword 0xacd62a194932211b, 0x74c2172eda89ab15
d_2_15:         .dword 0x73408522d99fa4da, 0x28a3ba3949bc0dd0
d_2_16:         .dword 0x6102c4ce07127a8e, 0x25b858f0b325a17d
d_2_17:         .dword 0x901e8cbefb0e37f2, 0xcc5330da72a283d7
d_2_18:         .dword 0x73710a78cf698469, 0x262dbaedad1f9e5e
d_2_19:         .dword 0x31da4c79b704c456, 0x6307e5136f14d2de
d_2_20:         .dword 0xe3c24a223054d2ae, 0x1895e7dfbaa1cabe
d_2_21:         .dword 0xf6ea4275eef24ea5, 0xe06d24fa0720cf14
d_2_22:         .dword 0x3718944aec5a19d3, 0x3a7e1509067cce66
d_2_23:         .dword 0x96325695976e418b, 0xadaf4964728688a3
d_2_24:         .dword 0xa93cf0d73856ab80, 0x9c4bc85cd9bd950b
d_2_25:         .dword 0xfc626992b8517a43, 0x9bfd21747e294d52
d_2_26:         .dword 0xd8893aa001ae9ac3, 0x8e2d17011940d075
d_2_27:         .dword 0xb043e0f101ddba46, 0x78734178ddfb8e69
                .dword 0x6eea095208c0615a, 0x95644640589713d2
                .dword 0xe273f9528d748d95, 0xb83ab9ffb7544be4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x67331b6e9cfb2505, 0xaca0b82baf9f1aad
                .dword 0xce392a0276409fd0, 0x3cb43f63625429e0
d_3_0:          .dword 0x0ba2534c01f67630, 0x6f1706a44a41ccff
d_3_1:          .dword 0x7ed15cb648034f31, 0x609497b0e68edf8a
d_3_2:          .dword 0x1f9eea98d7757a22, 0x9f3482d91d2260d8
d_3_3:          .dword 0x893706386eef01dc, 0xaca9b300f24308e2
d_3_4:          .dword 0x867e7f02a33885db, 0xa04799f70ba3ee05
d_3_5:          .dword 0xdb0ef024039863e4, 0x792ddf8df4c9bf25
d_3_6:          .dword 0x075523e98ebbb1c9, 0xee4572477730d486
d_3_7:          .dword 0x72788e6f658595f5, 0xb051090c6a3dae90
d_3_8:          .dword 0xafae712c25054dcc, 0xb5e3c18426b8c34e
d_3_9:          .dword 0xaddf52a492fd928b, 0x50f9146f1489d676
d_3_10:         .dword 0xdb5edc81fcf58891, 0xd88f68869dce4115
d_3_11:         .dword 0xe4665c3149428477, 0x3b7460c374bf17c3
d_3_12:         .dword 0xf832ffba718a3220, 0x932a4aa245ba5907
d_3_13:         .dword 0x908a5cee25dcd6ca, 0xf49ba9dcf7548904
d_3_14:         .dword 0x8cf294b0fad16f29, 0x04896ce2f72818a1
d_3_15:         .dword 0x5fdfa39881a2f82e, 0xf57a4dbaff1f8de7
d_3_16:         .dword 0x8f89927a053c82ea, 0x61e324a0452f4f3e
d_3_17:         .dword 0x92d32a1f39a5d141, 0x3bad971b79701637
d_3_18:         .dword 0x062926593546a029, 0x806ba9606097c67e
d_3_19:         .dword 0x4cc44beacfb4b3b2, 0x2370993d8416ed58
d_3_20:         .dword 0x2d632f64f4d4961c, 0xd316aa701d925610
d_3_21:         .dword 0x8f86d381dc1ab868, 0x983b89e61fbcf4d5
d_3_22:         .dword 0x65fb2419137c38bc, 0x451df7afa50ff969
d_3_23:         .dword 0x8a70bffd053bf71c, 0xf5455ecc84238aa4
d_3_24:         .dword 0x79a94b5f36f4ce4f, 0x004985ad69040598
d_3_25:         .dword 0xd6f3e32fecb9e69e, 0x2b1982eec0f87d2e
d_3_26:         .dword 0x39c939df6f8cf1b7, 0xef25835da27de8ba
d_3_27:         .dword 0x33119932968b60d0, 0x97b2b3629de4f4e7
                .dword 0x4377aa1e1e456208, 0x0ce6c6b1642f3590
                .dword 0xcee696b410310525, 0x0662866a692582f3
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x91d96e5e3c956635, 0x1756540e451117fb
                .dword 0x202f938cd8342e13, 0x81706618e6a383f4
d_4_0:          .dword 0xb15681d559f51aab, 0xaaa05cb67b4a5633
d_4_1:          .dword 0x86838c41ef26b510, 0x2692ffa1fb8c5004
d_4_2:          .dword 0x24bab844d262b15e, 0xe9af88ed369bf05d
d_4_3:          .dword 0x99d213040b519f73, 0x84a9da3aa2563ea8
d_4_4:          .dword 0xa2113959850dd194, 0xd4f6b31b22cb81b3
d_4_5:          .dword 0xdc25c2b7ea8c86d2, 0x10e17a27953c9383
d_4_6:          .dword 0x243b2112585869a9, 0x791346303a7711d7
d_4_7:          .dword 0x383c39ae8319f6de, 0xbe2e4b6508efbe1c
d_4_8:          .dword 0x8ac3ea582ebeefc7, 0x08787cb2eebb373e
d_4_9:          .dword 0x1586807a4284c530, 0xc86ead1c6e32b8ef
d_4_10:         .dword 0x5747ab31f407c262, 0xb59644cebb8e5980
d_4_11:         .dword 0x753337405d77878f, 0x01c543bbb52c35ae
d_4_12:         .dword 0x017a9cb4534d0349, 0x5396f3d01000811d
d_4_13:         .dword 0x096a054390270ae0, 0xb3ab0541dc386f2f
d_4_14:         .dword 0xa441a162e8967c81, 0xf162087ef00c8865
d_4_15:         .dword 0x2399cdef78e91623, 0xd61292416c7fc92f
d_4_16:         .dword 0xb0168473cb61310b, 0xed63b8f773caf6f0
d_4_17:         .dword 0x7b94cf7fb46748e1, 0x74425f85659b697d
d_4_18:         .dword 0xec9c6809d6e02f00, 0x2d4e041e0d0d794b
d_4_19:         .dword 0x44042c8e4f384b41, 0x9ab8dedd09454173
d_4_20:         .dword 0xe0b68133b8df68bf, 0xbd5cd4e6149389d5
d_4_21:         .dword 0x731972c2c71bbb0f, 0x7ee19c2d1aaf74e7
d_4_22:         .dword 0xc553e062f080e761, 0x947324cfdcb866b6
d_4_23:         .dword 0x85a3af92b121668b, 0x7a68a18ff932b7db
d_4_24:         .dword 0x8ad194b2c1ff357e, 0x8be9af829a7038c1
d_4_25:         .dword 0x5e973cb5dc41aed0, 0x45bfea5afbaa4464
d_4_26:         .dword 0x6d8ab533b465a6a1, 0x1e8add945c1d761e
d_4_27:         .dword 0xc55e10ad5f773eaf, 0x7d244d610f86ac3c
                .dword 0xef4dacec518795e3, 0x70cbaf95c7b15725
                .dword 0x320ba3aa5c90ec03, 0x92b455db38647d85
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x60a3e67ddc6b7dbd, 0x31ef31d1690ffb8c
                .dword 0x78868b10a5776432, 0x994f606b3af439cf
d_5_0:          .dword 0x265930430ce26f42, 0x1bd43e24764b1536
d_5_1:          .dword 0x55e1857d696525ee, 0x16ab746f7afef558
d_5_2:          .dword 0x653833df92faeae5, 0x9877d5145b923ad7
d_5_3:          .dword 0x30773111c474b2e7, 0xbb96e2c47065bc02
d_5_4:          .dword 0xab1e0799927ccfc3, 0xc23f5a2e3b9f6177
d_5_5:          .dword 0x9d077ac48adc601d, 0x6058ead893ce5ac4
d_5_6:          .dword 0x52ea0e40038f636f, 0xa403f84920ccd1d2
d_5_7:          .dword 0xb384de749cba6ca4, 0x016384f5472ad918
d_5_8:          .dword 0x449dc508352b44c7, 0x3eeb94020d9fa3bd
d_5_9:          .dword 0x2c51a9ae50d035be, 0xd16c5676fbab91d7
d_5_10:         .dword 0x788f66c4e39edda4, 0x0074fcf2531df884
d_5_11:         .dword 0xa9b01577e67c0876, 0xfb93e4135e8f19d8
d_5_12:         .dword 0x81c0b056f24366b3, 0x6dc5408e6dc1879e
d_5_13:         .dword 0x0c9d7931bd4e4bc3, 0x5e34ad48159d1ecd
d_5_14:         .dword 0x8926769118f6f663, 0x67ed6e039308ff19
d_5_15:         .dword 0x5b35096bc931678b, 0xab057349f60940af
d_5_16:         .dword 0x00c7ec697dfef22a, 0x1243292f38870ef5
d_5_17:         .dword 0x6c230b72f207f29b, 0xbc77c1397e1f3a7d
d_5_18:         .dword 0x6c3d468c6172787a, 0x4dc2f7b5e21ad40d
d_5_19:         .dword 0x714e141435be8966, 0xe1cf56941f11f98c
d_5_20:         .dword 0x3c553b10e6db8162, 0x93ec25528b6b5c53
d_5_21:         .dword 0x5cd522454765ac64, 0x62915410f93db06e
d_5_22:         .dword 0x9e090b1282a3c7b7, 0x5ba77acad3534f05
d_5_23:         .dword 0xc49e30e467a4eb1f, 0x58ee4bec31ad9bef
d_5_24:         .dword 0x53df3fbe652418d8, 0x73e085e6f4d07552
d_5_25:         .dword 0x19d5a4ad45aefbd0, 0xec546950f4f5f854
d_5_26:         .dword 0x60838a147ab11cd2, 0x61b84dea1d409bf7
d_5_27:         .dword 0x2d028d41fa44a907, 0x695f01c68422df81
                .dword 0x3b6a24503b80a83d, 0x9e85f83d2c019407
                .dword 0x973dd025d7d4210b, 0xe2bb217b3830ea26
         /* Random data */
_end_data5:
              
 
