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
        addi x12, zero, 3                         ;
        slli x12, x12, 4                          ;
        add x10, x10, x12                         ;
        addi x11, zero, 1                         ;
        slli x11, x11, 31                         ;
        add x10, x10, x11                         ;
        csrrs x10, satp, x10                      ;
_p1:    la x11, d_5_16                            ;
        srai x11, x11, 1                          ;
        csrrw x12, pmpaddr1, x11                  ;
_p2:    csrrwi x14, sstatus, 14                   ;
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
_s0:    mulhsu x8, x17, x19                       ;
_s1:    la x27, d_4_3                             ;
        sw x29, 8(x27)                            ;
_s2:    mulw x2, x0, x3                           ;
_s3:    csrrwi x16, pmpaddr3, 2                   ;
_s4:    la x18, d_5_22                            ;
        addi x18, x18, -0                         ;
        lr.w x16, (x18)                           ;
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
_l0:    xor x23, x23, x23                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 24                         ;
        add x23, x23, x28                         ;
        addi x20, zero, 3                         ;
        slli x20, x20, 4                          ;
        add x23, x23, x20                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 5                          ;
        add x23, x23, x27                         ;
        csrrc x17, mhartid, x23                   ;
_l1:    la x6, d_0_21                             ;
        addi x6, x6, -24                          ;
        amomin.d x10, x15, (x6)                   ;
_l2:    srli x26, x16, 63                         ;
_l3:    la x9, _l95                               ;
        lbu x12, 14(x9)                           ;
_l4:    la x9, d_0_8                              ;
        addi x9, x9, 12                           ;
        lr.w x11, (x9)                            ;
_l5:    fcvt.s.lu f22, x15, rdn                   ;
_l6:    srlw x24, x16, x10                        ;
_l7:    la x10, d_5_13                            ;
        ld x21, -8(x10)                           ;
_l8:    divu x23, x24, x1                         ;
_l9:    fmul.s f22, f17, f27, rdn                 ;
_l10:   fdiv.s f11, f27, f15, rne                 ;
_l11:   fcvt.lu.s x11, f3, rmm                    ;
_l12:   la x28, _l116                             ;
        lh x14, 22(x28)                           ;
_l13:   la x25, d_4_18                            ;
        addi x25, x25, 20                         ;
        amoadd.w x15, x8, (x25)                   ;
_l14:   la x25, d_3_15                            ;
        srai x25, x25, 1                          ;
        csrrc x15, pmpaddr3, x25                  ;
_l15:   ebreak                                    ;
_l16:   div x30, x17, x9                          ;
_l17:   andi x22, x23, 0                          ;
_l18:   la x22, d_2_8                             ;
        addi x22, x22, -0                         ;
        lr.d x24, (x22)                           ;
_l19:   la x24, d_2_7                             ;
        addi x24, x24, -8                         ;
        amoor.d x1, x14, (x24)                    ;
_l20:   addi x30, x0, -1863                       ;
_l21:   ori x15, x19, -2047                       ;
_l22:   xori x7, x20, 2047                        ;
_l23:   li x6, 1                                  ;
        la x9, pt2                                ;
        addi x9, x9, 56                           ;
        sfence.vma x6, x9                         ;
_l24:   lui x26, 705354                           ;
_l25:   la x5, d_4_11                             ;
        addi x5, x5, 16                           ;
        amoand.d x12, x1, (x5)                    ;
_l26:   fclass.s x11, f15                         ;
_l27:   andi x7, x9, -1081                        ;
_l28:   la x27, d_2_7                             ;
        flw f27, 24(x27)                          ;
_l29:   la x14, d_5_6                             ;
        addi x14, x14, 8                          ;
        amomaxu.d x26, x29, (x14)                 ;
_l30:   fmul.s f23, f7, f18, rmm                  ;
_l31:   bne x3, x28, _l77                         ;
_l32:   mulhu x20, x23, x6                        ;
_l33:   la x7, d_5_0                              ;
        addi x7, x7, -0                           ;
        amominu.w x15, x20, (x7)                  ;
_l34:   fsgnj.s f2, f13, f31                      ;
_l35:   mulw x25, x15, x30                        ;
_l36:   la x18, d_3_12                            ;
        addi x18, x18, 8                          ;
        amoor.w x20, x6, (x18)                    ;
_l37:   srli x22, x21, 63                         ;
_l38:   la x11, _l19                              ;
        flw f4, 12(x11)                           ;
_l39:   la x4, _l51                               ;
        jalr x20, 0(x4)                           ;
_l40:   fmv.w.x f25, x30                          ;
_l41:   la x19, d_4_8                             ;
        addi x19, x19, -16                        ;
        lui x2, 0xffe00                           ;
        xor x19, x19, x2                          ;
        amoand.d x8, x2, (x19)                    ;
_l42:   sraw x17, x29, x2                         ;
_l43:   fdiv.s f23, f8, f23, rdn                  ;
_l44:   la x20, d_2_17                            ;
        sw x25, -28(x20)                          ;
_l45:   subw x27, x9, x12                         ;
_l46:   sraiw x14, x29, 3                         ;
_l47:   slliw x0, x23, 13                         ;
_l48:   mulh x7, x26, x20                         ;
_l49:   fcvt.w.s x1, f7, rup                      ;
_l50:   la x9, d_0_18                             ;
        addi x9, x9, -24                          ;
        amoxor.d x9, x22, (x9)                    ;
_l51:   fcvt.s.lu f11, x12, rtz                   ;
_l52:   slti x15, x15, 548                        ;
_l53:   srlw x21, x21, x2                         ;
_l54:   li x13, 0                                 ;
        la x1, pt3                                ;
        addi x1, x1, 0                            ;
        sfence.vma x13, x1                        ;
_l55:   rem x30, x26, x30                         ;
_l56:   xori x14, x29, 801                        ;
_l57:   rem x16, x29, x16                         ;
_l58:   addw x9, x5, x1                           ;
_l59:   csrrci x20, sscratch, 19                  ;
_l60:   la x3, d_4_23                             ;
        addi x3, x3, -0                           ;
        lr.d x1, (x3)                             ;
_l61:   lui x29, 741033                           ;
_l62:   la x3, d_2_14                             ;
        fsw f13, 16(x3)                           ;
_l63:   fnmsub.s f25, f6, f20, f22, rne           ;
_l64:   fnmsub.s f18, f30, f22, f7, rtz           ;
_l65:   sltiu x30, x17, -1571                     ;
_l66:   la x26, d_0_2                             ;
        sb x12, 23(x26)                           ;
_l67:   la x26, d_2_26                            ;
        lhu x2, 28(x26)                           ;
_l68:   la x17, d_3_21                            ;
        addi x17, x17, 0                          ;
        amoand.d x14, x20, (x17)                  ;
_l69:   bne x22, x3, _l77                         ;
_l70:   la x19, d_4_7                             ;
        addi x19, x19, -0                         ;
        lui x16, 0xffe00                          ;
        xor x19, x19, x16                         ;
        amoor.w x12, x16, (x19)                   ;
_l71:   feq.s x4, f26, f9                         ;
_l72:   blt x11, x19, _l122                       ;
_l73:   srliw x8, x6, 24                          ;
_l74:   fmul.s f9, f20, f21, rne                  ;
_l75:   remu x24, x10, x6                         ;
_l76:   la x2, d_4_10                             ;
        addi x2, x2, -24                          ;
        amoadd.w x26, x8, (x2)                    ;
_l77:   remu x27, x0, x9                          ;
_l78:   fnmadd.s f25, f23, f27, f2, rmm           ;
_l79:   mulh x24, x22, x10                        ;
_l80:   la x16, d_5_13                            ;
        addi x16, x16, -0                         ;
        lui x6, 0xffe00                           ;
        xor x16, x16, x6                          ;
        amomaxu.d x30, x6, (x16)                  ;
_l81:   fmv.w.x f21, x4                           ;
_l82:   la x3, d_2_23                             ;
        addi x3, x3, 20                           ;
        amoand.w x19, x28, (x3)                   ;
_l83:   mulh x10, x0, x6                          ;
_l84:   csrrci x6, mepc, 18                       ;
_l85:   la x27, d_5_24                            ;
        sd x3, 8(x27)                             ;
_l86:   la x19, d_4_11                            ;
        addi x19, x19, -16                        ;
        amominu.d x10, x3, (x19)                  ;
_l87:   ecall                                     ;
_l88:   la x23, d_4_23                            ;
        lhu x4, -28(x23)                          ;
_l89:   addi x27, x20, -1579                      ;
_l90:   fcvt.w.s x9, f25, rdn                     ;
_l91:   flt.s x11, f20, f3                        ;
_l92:   fnmadd.s f20, f7, f14, f9, rmm            ;
_l93:   mulw x21, x21, x15                        ;
_l94:   fclass.s x0, f8                           ;
_l95:   fmul.s f26, f23, f22, rdn                 ;
_l96:   sraw x3, x12, x10                         ;
_l97:   la x13, d_4_27                            ;
        lw x30, -0(x13)                           ;
_l98:   bne x11, x26, _l131                       ;
_l99:   addw x14, x1, x17                         ;
_l100:  la x16, d_4_18                            ;
        sw x3, 0(x16)                             ;
_l101:  la x26, d_5_22                            ;
        sd x17, 24(x26)                           ;
_l102:  la x7, d_1_19                             ;
        addi x7, x7, -0                           ;
        amoand.d x22, x29, (x7)                   ;
_l103:  la x13, _l108                             ;
        jalr x15, 0(x13)                          ;
_l104:  la x18, _l127                             ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l105:  fsqrt.s f4, f15, rmm                      ;
_l106:  mulh x8, x7, x19                          ;
_l107:  fcvt.s.l f25, x18, dyn                    ;
_l108:  flt.s x23, f0, f4                         ;
_l109:  bge x4, x22, _l131                        ;
_l110:  la x4, _l113                              ;
        csrrw zero, sepc, x4                      ;
        sret                                      ;
_l111:  fcvt.s.w f26, x3, rmm                     ;
_l112:  fmadd.s f6, f7, f29, f22, rtz             ;
_l113:  addiw x26, x16, 23                        ;
_l114:  la x19, d_5_14                            ;
        addi x19, x19, -28                        ;
        lui x27, 0xffe00                          ;
        xor x19, x19, x27                         ;
        amoand.w x25, x27, (x19)                  ;
_l115:  la x5, d_5_7                              ;
        addi x5, x5, -20                          ;
        amomin.w x21, x14, (x5)                   ;
_l116:  la x17, d_2_12                            ;
        addi x17, x17, -0                         ;
        sc.d x24, x17, (x17)                      ;
_l117:  la x13, d_3_13                            ;
        addi x13, x13, -8                         ;
        amoswap.w x11, x27, (x13)                 ;
_l118:  fle.s x1, f20, f22                        ;
_l119:  divuw x24, x2, x2                         ;
_l120:  la x4, d_4_16                             ;
        addi x4, x4, 28                           ;
        amoor.w x15, x20, (x4)                    ;
_l121:  fcvt.lu.s x5, f25, rdn                    ;
_l122:  fcvt.s.l f3, x26, rup                     ;
_l123:  ebreak                                    ;
_l124:  fcvt.lu.s x27, f4, rdn                    ;
_l125:  beq x25, x1, _l135                        ;
_l126:  fle.s x24, f26, f25                       ;
_l127:  la x17, d_4_25                            ;
        addi x17, x17, 8                          ;
        amomin.d x2, x16, (x17)                   ;
_l128:  divw x19, x24, x30                        ;
_l129:  fence                                     ;
_l130:  la x28, d_1_21                            ;
        addi x28, x28, 0                          ;
        amoxor.d x1, x24, (x28)                   ;
_l131:  csrrwi x20, sscratch, 31                  ;
_l132:  la x3, d_0_27                             ;
        sh x11, -0(x3)                            ;
_l133:  slliw x25, x24, 7                         ;
_l134:  addiw x29, x0, -119                       ;
_l135:  la x2, d_5_0                              ;
        lwu x1, 12(x2)                            ;
_l136:  la x16, d_3_3                             ;
        addi x16, x16, 0                          ;
        amomaxu.d x21, x11, (x16)                 ;
_l137:  xor x2, x2, x2                            ;
        addi x2, zero, 1                          ;
        slli x2, x2, 0                            ;
        add x2, x2, x2                            ;
        addi x11, zero, 3                         ;
        slli x11, x11, 3                          ;
        add x2, x2, x11                           ;
        csrrc x26, fflags, x2                     ;
_l138:;
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
                .dword 0xe8eff104787b25d5, 0xa1563f98e8e2c660
                .dword 0x1290684d7bbca48e, 0xd9c49a78208f6dfb
d_0_0:          .dword 0x911bd3b05fdacb31, 0x9050d2041cc108b0
d_0_1:          .dword 0x814ca7d3c8ac7077, 0xf7f21a7c67d16876
d_0_2:          .dword 0x14dc59e87140ef7a, 0xa4281f336694a092
d_0_3:          .dword 0x9bc72d7d15ca51f1, 0x2485659fb57bf872
d_0_4:          .dword 0x0b9470c2f71a01f2, 0xa2644c917a881051
d_0_5:          .dword 0x1ecdf750231b45e9, 0xa0a2601b1d486803
d_0_6:          .dword 0x794eea8124d296b2, 0x506669648a3ab211
d_0_7:          .dword 0xc19d9db83510f64e, 0x365df21986e3aa84
d_0_8:          .dword 0xfdffe8d3d4c357ee, 0xa0b3e4518a8d4581
d_0_9:          .dword 0x3bd41af4bd48a858, 0x5c0c9e7749013479
d_0_10:         .dword 0x55488d57cfcc4bdc, 0xba93d4c900e353fb
d_0_11:         .dword 0xdeb77d97427d9e7a, 0xbe50557df93c90b1
d_0_12:         .dword 0xcfd71e609f75b5fe, 0x8dd80216f4ffa800
d_0_13:         .dword 0x8e8f3a761fd9fe69, 0x7961da43170a3c94
d_0_14:         .dword 0x62ad3dd4a7ca905e, 0xc3b9536bd6a3a81a
d_0_15:         .dword 0xf4cddc3a332a9832, 0x5bdec5c8b8733bdb
d_0_16:         .dword 0x8cee196376bf6381, 0xdf4655895937579e
d_0_17:         .dword 0x29f0b286b226b86c, 0x9e98b8839426d6f2
d_0_18:         .dword 0x366c7d2b2f6c7758, 0x4d678347ee4a1702
d_0_19:         .dword 0x021ee1cf126e0bd8, 0x288d244f8f0ac83c
d_0_20:         .dword 0x361dbb383dbf5b40, 0xcd4172dc2c389946
d_0_21:         .dword 0xa4b957bd322bd88d, 0xc5917af77a24e836
d_0_22:         .dword 0x34d3c53c4c926048, 0x3677df3df5a5d94f
d_0_23:         .dword 0x97045a65e75f463e, 0x761dc8c394ee5d48
d_0_24:         .dword 0x2c357a9d5a693d4d, 0x1c2093c05330c388
d_0_25:         .dword 0xa8fc07468bd60a22, 0x4309320db0492400
d_0_26:         .dword 0xe858f85670ef776a, 0x06457570910adc61
d_0_27:         .dword 0x30007ae9c0a1713a, 0x29ce42b1e9ba5703
                .dword 0x3b21a4f6b6d03786, 0x325de8a416ed7aa0
                .dword 0x02231a06ae47c0ee, 0xd2c5b670c3f14753
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x690f3b2050ae262b, 0xfae412b9d94e4220
                .dword 0x11648f03997ad183, 0x98424edcf6fb4e11
d_1_0:          .dword 0x6a45e83cfd2609fd, 0xac43990c0b13f74d
d_1_1:          .dword 0xdc4987c7b9a8c762, 0xb437c96932d65714
d_1_2:          .dword 0x3784858b20911ce4, 0x88d1c272d8873ede
d_1_3:          .dword 0x72ad555a76b89782, 0xa6a47a6a492e7e05
d_1_4:          .dword 0xb9e251e7e0a92f94, 0x03b85ea09816fcb3
d_1_5:          .dword 0x05119971f9459935, 0xae9e8f3aaaebf862
d_1_6:          .dword 0x0cfbdd1917f05840, 0x4f3e4af22ba42593
d_1_7:          .dword 0xb4f2e21f0a2e1a50, 0x930a837395cd667c
d_1_8:          .dword 0x4eaf40046a297ab7, 0x7a0d58179e3e645a
d_1_9:          .dword 0x13e2dd6cbfb3c7b9, 0x8c00ad3b3cec415e
d_1_10:         .dword 0x9fc59dd09bbf1862, 0xbd43ee258a1d9f85
d_1_11:         .dword 0x332435e1f2beeca7, 0xd47ef23c645df991
d_1_12:         .dword 0x0164e79c2333474b, 0xc54381f2fa889b8b
d_1_13:         .dword 0x359efa40145c39bd, 0x7ca168bd9eb6277a
d_1_14:         .dword 0x6b0fbc3d146711e9, 0x8a21c35f2794f1a9
d_1_15:         .dword 0x79b32400e57b55de, 0xf55c50b47b33db45
d_1_16:         .dword 0x711fce9bf38bb602, 0x6eae7ebd9bdae1bb
d_1_17:         .dword 0x58db679db3bdf25a, 0x7fead53251f110c9
d_1_18:         .dword 0x5e0f57b269a789d8, 0xf75f8cb0ee569d00
d_1_19:         .dword 0x7333ea05e70c28d2, 0x34299cdcd4329ea6
d_1_20:         .dword 0x95430841f8f4c4a6, 0x24cf8e729c75ba97
d_1_21:         .dword 0xccfaa87789e0f8bb, 0xc2ddd20fcb7d09a2
d_1_22:         .dword 0x9add659de69ee521, 0xdb37ddf5895feea1
d_1_23:         .dword 0xf24ff573f2408733, 0xde81348c01d08113
d_1_24:         .dword 0x224f8d8aa5662ade, 0xbefe30136a391f59
d_1_25:         .dword 0x707474e286cd8f30, 0xb57282dbd0f2f109
d_1_26:         .dword 0x33c2843545840194, 0xd1df43184018a5f5
d_1_27:         .dword 0x320704f20d92f6bf, 0xa0db34c95978c6ed
                .dword 0x08a0fce771bba61e, 0xeb0eec27d90d3140
                .dword 0x9578ab3132d6540e, 0x6a5dc8448ef4f5ca
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x813978e61aa98f0a, 0x9f0ad61b40833028
                .dword 0x5f4028b28c0f402b, 0xf675d62fb3adf08a
d_2_0:          .dword 0x6ed376b2b0d2c658, 0xedaccd0d207ff962
d_2_1:          .dword 0x290e8a7cd0d35407, 0x00925d75a6898f2d
d_2_2:          .dword 0x62f7502dcbe64bf6, 0xb8daf9f3f0b9021d
d_2_3:          .dword 0x13f02f3662fc8539, 0xc2f00b432305be2a
d_2_4:          .dword 0x4b89b3ba4f0a41dc, 0xcb55a816bdf8f1ee
d_2_5:          .dword 0xa9bf644c78be3f4f, 0x0aaac8ea6050dab5
d_2_6:          .dword 0x1ef71b9349c4f2b4, 0x63ed5dfb0b24b084
d_2_7:          .dword 0xa46132d79896a1de, 0xc6caf3d05faf1148
d_2_8:          .dword 0xb274d1428f65359d, 0xfbe3dbe600e25922
d_2_9:          .dword 0x958770624166e063, 0xc7896c5695b1f9da
d_2_10:         .dword 0xde326a55a9a8d8ba, 0x583c39b1db7b5a5c
d_2_11:         .dword 0x946d6f0e62a1dae5, 0x310a1329abb05cb9
d_2_12:         .dword 0x69605f5d833de93c, 0xc24817e64f0c78be
d_2_13:         .dword 0x707106bc37ef21d2, 0x415aab4d2408ada5
d_2_14:         .dword 0x351e66cddb4fc96f, 0x921b50179c93e7d9
d_2_15:         .dword 0xaea4f6cdee4d3734, 0x3497da59e90d52d3
d_2_16:         .dword 0x6cdedb9b4295d97e, 0x38697c7c6cddc22f
d_2_17:         .dword 0xff5d8084ae6abdd0, 0x9fc002c1c732617a
d_2_18:         .dword 0xd8734f7d6025e59b, 0xec598f21e44177b8
d_2_19:         .dword 0x75997bdea27ce2b0, 0xddb3a9d248c0d35c
d_2_20:         .dword 0xcf315a626ad18d7c, 0xa518eb1644f0bfd8
d_2_21:         .dword 0xd25b5aefe99ee0f8, 0x0d9d1c1a6af4cc09
d_2_22:         .dword 0x31927cf44043e646, 0x950bedb676281f0a
d_2_23:         .dword 0x0ef15b89ac5d9813, 0x15ca0e1b35a3d4b2
d_2_24:         .dword 0x777551814868d66e, 0xd6800b7aedf638cb
d_2_25:         .dword 0x254c0b73df99e9ae, 0x034dc8a565510f57
d_2_26:         .dword 0xb20345813b4383df, 0x3bdd4a52c2a70118
d_2_27:         .dword 0x84d33f9b027e7e02, 0xd5c8b06ea569f8c5
                .dword 0xb172089567ded83a, 0x8634fd845c93310b
                .dword 0xc29cf2a1237c8dd0, 0x3db75f0ddf77157c
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x85e9a06de14d0d02, 0xa3b44255e68b02ea
                .dword 0xa2fbfc4e59c85143, 0x544762525db571e2
d_3_0:          .dword 0x8e2095b3d3daced4, 0xbb658eac1aeb7abb
d_3_1:          .dword 0xacddc3d1c73dcec0, 0x2f0bb2ea3761eb0a
d_3_2:          .dword 0xb57232f586c3b1d3, 0x928ee3e8e12a8990
d_3_3:          .dword 0x1cb6a5e3ebe0da2e, 0x815b7f8a2600864d
d_3_4:          .dword 0xde059b3c662e186c, 0xce025792cc7f5a0f
d_3_5:          .dword 0xcb3546c4b1797063, 0x177f99c15bbecdb4
d_3_6:          .dword 0x6a72c245d36adf4f, 0x65c84e3db9306216
d_3_7:          .dword 0x8035ca924a762688, 0xbef74b1bc1c4c3c6
d_3_8:          .dword 0x5ad4fc7721d2bddb, 0xa63c2aad0dcb3698
d_3_9:          .dword 0x15fcdee82727da1b, 0x733efdcb1a716a79
d_3_10:         .dword 0xb350a31b60dbd75f, 0x49a640de9978daa7
d_3_11:         .dword 0x2eb3d86f18f3a11b, 0xa2da890536f26f81
d_3_12:         .dword 0x1edd2e419f9da42b, 0x4f3506abb193a90d
d_3_13:         .dword 0x221107ef426327ad, 0xf3fd6aec8fb47c0c
d_3_14:         .dword 0x85baa5a6acc01ca1, 0x5038b5c9bb7a5337
d_3_15:         .dword 0x94be5472fe9e2985, 0x9ce5c88efa429f07
d_3_16:         .dword 0xe6b458099e46c5f8, 0x0b0809a9c36bfaf1
d_3_17:         .dword 0x4a95010b69962d75, 0x508edfe8e9025d68
d_3_18:         .dword 0x43f6a0a948120c7a, 0x247f4d5bb1cdf0d6
d_3_19:         .dword 0x40e003a097495f2d, 0xf4d7760bd2226230
d_3_20:         .dword 0x54aab802c52bdac4, 0x08b42b960fe4c2ff
d_3_21:         .dword 0x075fffb4e0c6221c, 0x7055c9b57c5644fa
d_3_22:         .dword 0x1dc329e994cad438, 0x0f374b9b83ee2145
d_3_23:         .dword 0x1146f8c9bfd6a4e6, 0x7019d612a89f7cff
d_3_24:         .dword 0x3d912e0450ddb171, 0xe1aecb5ccc1e917a
d_3_25:         .dword 0xe58664a3f02bf489, 0xff4633a164948011
d_3_26:         .dword 0x190a3feab09362d7, 0x2e769177de51a2aa
d_3_27:         .dword 0x5919a58a6cd1e2b7, 0xc00b3e5817b1281e
                .dword 0xbf2cb14dea8a325d, 0x4a8c78e7cf650efa
                .dword 0x92e9b6a3d95cf0b0, 0x4a001f2ea1ffa10e
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xa3b061ff1b08f7d2, 0x0f596343147a9bd6
                .dword 0xbd103317a7ae5ecb, 0xf0067aff848c8517
d_4_0:          .dword 0xea0cafd76267ce2b, 0xe80bbda6f61e1bfa
d_4_1:          .dword 0x8e1f6131ecfb33c2, 0x028ce6d08615cf6f
d_4_2:          .dword 0x54495435e12bce1a, 0x2c3644f9d63d3e86
d_4_3:          .dword 0xa467ee04a3e5fbf1, 0x35cc6570e0797922
d_4_4:          .dword 0x11fbd61f144604f7, 0xa7263e3cadfcad36
d_4_5:          .dword 0xcd1e0e4abeb6a3d1, 0x000e291b377f4b66
d_4_6:          .dword 0x9b3a920844401353, 0x0b0a85fe1a3855a1
d_4_7:          .dword 0x0ba598176d6d8ccb, 0xeff0370c58b537e2
d_4_8:          .dword 0x4eb03d77cbf76ac7, 0x3da590e97ea9a096
d_4_9:          .dword 0x46bd63a7de66ea4b, 0x8556b43ab4928026
d_4_10:         .dword 0xdc1ecd4ec890b6bc, 0xb97f018d057592a4
d_4_11:         .dword 0x23f0b83afa44eb9b, 0x51f9e0bad143a602
d_4_12:         .dword 0x64c12b51a9a7a0ef, 0x11f17b68ef7c23c1
d_4_13:         .dword 0x42a00c5cff9757bb, 0xd7c3003471aa74c7
d_4_14:         .dword 0xfaccd2337629f4f2, 0x24a577f00f38e91a
d_4_15:         .dword 0x6068a11e3cc41b2e, 0x7c7ffb982eb59780
d_4_16:         .dword 0x7eec0515d97ee245, 0x55d37667ab5ef5be
d_4_17:         .dword 0xe8e9a27804369f73, 0x0704c35083127d10
d_4_18:         .dword 0xd1d8de953f7e2489, 0xaf0f3b6defb18c9a
d_4_19:         .dword 0xe6f7744a2d25580b, 0x5b5836ead6f9ae3f
d_4_20:         .dword 0x2786f76a2b76a702, 0xa621eb882b645b5a
d_4_21:         .dword 0x417a51e95fb1c534, 0x027485034f6f3ec9
d_4_22:         .dword 0x0b62f13ea7e769fe, 0xe19a547db3378f52
d_4_23:         .dword 0x4785d0a3338311f1, 0xa570565f1dcc25ac
d_4_24:         .dword 0x9aa396b1bdf00d71, 0xe022af47bb76f2a7
d_4_25:         .dword 0x3497881e286d6c7d, 0xc5904aa98b2758eb
d_4_26:         .dword 0x107936650c220ede, 0xddd86a7d9f0ccf26
d_4_27:         .dword 0xdedf1b292d2b2eee, 0xe6d49a7616f2706f
                .dword 0x18386651520230a6, 0x37e70070810497ca
                .dword 0x028d4566c09373ae, 0xf98d9d0d36255d60
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x7d7e0f5b23d3433f, 0x823ca5b9baf85d13
                .dword 0xcb6789b2c970e790, 0xba33f0013c41e992
d_5_0:          .dword 0x346d0861f07eb0eb, 0xe57af1a78372d7e5
d_5_1:          .dword 0xf4ea39ea2f43fb0d, 0x63fd983ba8fb58ff
d_5_2:          .dword 0xe4b0c54b7c896b05, 0xe97c48108e52b2eb
d_5_3:          .dword 0xc906bf02c684043e, 0xdcfec986a1a8b3a7
d_5_4:          .dword 0xc470997593324317, 0xadacc92f84d62fb2
d_5_5:          .dword 0xab4a9b46b97782d5, 0x7cf2dc8f0985d5c9
d_5_6:          .dword 0xb1672f01c1711fbe, 0x312152e4f2e9b032
d_5_7:          .dword 0x1f0ba4304d712f16, 0x0d3e08638cb3ad2d
d_5_8:          .dword 0x2dd6ad7576b74514, 0xd84fc4b2b60a9980
d_5_9:          .dword 0x8613a43a4f2d7321, 0x19cae28ba48f7898
d_5_10:         .dword 0x1b3060a72fb31b25, 0xe3fe3c933bdc15e7
d_5_11:         .dword 0x2c9fa6c3d71e6dd2, 0xfb4a60ec3423794e
d_5_12:         .dword 0x03e98fe5745425e5, 0x4ce0cd9caacd59c6
d_5_13:         .dword 0x15c1ec80bfd5c8cf, 0xa0db5e75ebada38e
d_5_14:         .dword 0xd7a6e4fec7e3b0a9, 0xe308139368798a64
d_5_15:         .dword 0x6ffda05bc375ad60, 0x1068261ed2dc5732
d_5_16:         .dword 0xb8731dab6fe73226, 0xf1ad5c520b7da113
d_5_17:         .dword 0xa72a1233ad27fffe, 0xeb18a4607f32023c
d_5_18:         .dword 0xb812416907fa767b, 0x03b63fe1fc2a5c40
d_5_19:         .dword 0x0bb5ea5586f1a44f, 0x163909ad44b04870
d_5_20:         .dword 0x303de8805ca589ed, 0xff9b42d291634161
d_5_21:         .dword 0x03b03f47998f11da, 0x96a1b43033ea7d64
d_5_22:         .dword 0xd9d4e8a24584c980, 0x0e0773c56d86c234
d_5_23:         .dword 0xbcfef1e2c9d57de1, 0xcb55848b87a2f6df
d_5_24:         .dword 0x88ec41ae94139be1, 0xf266717358d6fd8d
d_5_25:         .dword 0xa5f7ce7e97cc6846, 0x164252bfb4798905
d_5_26:         .dword 0xbfea6f0018ce7050, 0x3aee6ef74b5e82a6
d_5_27:         .dword 0x70ed850b99a49c96, 0x2d09008327c86ef4
                .dword 0x1c5aa857ee876b55, 0xac14a6b406fdf84c
                .dword 0x23c0cd7de4514430, 0x2936e60ff5f40385
         /* Random data */
_end_data5:
              
 
