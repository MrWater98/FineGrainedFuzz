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
_p0:    csrrci x12, pmpaddr2, 21                  ;
_p1:    xor x12, x12, x12                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 25                         ;
        add x12, x12, x12                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 8                          ;
        add x12, x12, x14                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 7                          ;
        add x12, x12, x13                         ;
        csrrw x13, sscratch, x12                  ;
_p2:    la x13, d_0_26                            ;
        srai x13, x13, 1                          ;
        csrrs x13, pmpaddr5, x13                  ;
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
_s0:    la x10, d_1_13                            ;
        addi x10, x10, 16                         ;
        amoadd.d x9, x1, (x10)                    ;
_s1:    la x5, d_2_11                             ;
        addi x5, x5, -16                          ;
        lr.d x16, (x5)                            ;
_s2:    la x2, d_3_22                             ;
        sh x7, -24(x2)                            ;
_s3:    xor x4, x4, x4                            ;
        addi x8, zero, 3                          ;
        slli x8, x8, 3                            ;
        add x4, x4, x8                            ;
        addi x29, zero, 3                         ;
        slli x29, x29, 6                          ;
        add x4, x4, x29                           ;
        csrrc x8, medeleg, x4                     ;
_s4:    addi x13, x29, 1799                       ;
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
_l0:    la x20, _l75                                      ;
        jalr x12, 0(x20)                          ;
_l1:    ecall                                     ;
_l2:    fmv.x.w x25, f8                           ;
_l3:    la x29, d_1_2                             ;
        flw f4, -24(x29)                          ;
_l4:    slliw x3, x4, 31                          ;
_l5:    sraiw x5, x11, 18                         ;
_l6:    mulh x8, x10, x23                         ;
_l7:    xor x10, x10, x10                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 7                          ;
        add x10, x10, x13                         ;
        csrrc x30, mie, x10                       ;
_l8:    la x3, d_3_9                              ;
        srai x3, x3, 1                            ;
        csrrc x4, pmpaddr1, x3                    ;
_l9:    la x21, d_2_3                             ;
        addi x21, x21, 16                         ;
        sc.w x13, x8, (x21)                       ;
_l10:   fsgnjx.s f27, f27, f16                    ;
_l11:   fcvt.s.lu f12, x8, rtz                    ;
_l12:   sllw x7, x7, x20                          ;
_l13:   la x15, d_4_17                            ;
        flw f15, 0(x15)                           ;
_l14:   la x10, d_1_12                            ;
        addi x10, x10, -24                        ;
        amomin.w x23, x25, (x10)                  ;
_l15:   fmin.s f26, f15, f8                       ;
_l16:   fmin.s f22, f24, f15                      ;
_l17:   xori x22, x20, -0                         ;
_l18:   la x9, d_4_18                             ;
        addi x9, x9, 4                            ;
        amomin.w x6, x15, (x9)                    ;
_l19:   fcvt.wu.s x11, f15, rne                   ;
_l20:   fle.s x4, f13, f30                        ;
_l21:   srliw x18, x7, 0                          ;
_l22:   xor x16, x16, x16                         ;
        addi x30, zero, 1                         ;
        slli x30, x30, 25                         ;
        add x16, x16, x30                         ;
        addi x27, zero, 1                         ;
        slli x27, x27, 26                         ;
        add x16, x16, x27                         ;
        csrrw x23, fcsr, x16                      ;
_l23:   andi x8, x16, -1826                       ;
_l24:   slti x22, x21, -87                        ;
_l25:   la x13, d_2_15                            ;
        addi x13, x13, 0                          ;
        amoor.d x8, x13, (x13)                    ;
_l26:   fence.i                                   ;
_l27:   lui x4, 868016                            ;
_l28:   fence                                     ;
_l29:   fnmadd.s f23, f26, f22, f1, rdn           ;
_l30:   beq x22, x3, _l74                                 ;
_l31:   fsub.s f12, f5, f10, rtz                  ;
_l32:   la x2, d_4_1                              ;
        addi x2, x2, 8                            ;
        lui x29, 0xffe00                          ;
        xor x2, x2, x29                           ;
        amoxor.d x7, x29, (x2)                    ;
_l33:   fcvt.w.s x0, f6, rup                      ;
_l34:   rem x24, x13, x24                         ;
_l35:   la x19, d_4_17                            ;
        addi x19, x19, -8                         ;
        amoxor.d x30, x9, (x19)                   ;
_l36:   fmin.s f11, f28, f15                      ;
_l37:   la x28, d_5_3                             ;
        addi x28, x28, 16                         ;
        lr.w x16, (x28)                           ;
_l38:   remuw x30, x5, x16                        ;
_l39:   fcvt.s.wu f0, x29, dyn                    ;
_l40:   sltiu x6, x24, 1839                       ;
_l41:   fmv.x.w x14, f17                          ;
_l42:   csrrsi x9, satp, 31                       ;
_l43:   csrrci x16, pmpaddr5, 0                   ;
_l44:   sllw x3, x17, x2                          ;
_l45:   bltu x17, x12, _l53                               ;
_l46:   jal x24, _l57                             ;
_l47:   csrrwi x1, mie, 24                        ;
_l48:   la x2, _l99                               ;
        lw x6, 24(x2)                             ;
_l49:   fnmadd.s f31, f8, f29, f29, rdn           ;
_l50:   fcvt.wu.s x1, f14, rtz                    ;
_l51:   la x23, _l103                                     ;
        csrrw zero, sepc, x23                     ;
        sret                                      ;
_l52:   ecall                                     ;
_l53:   la x13, d_2_24                            ;
        addi x13, x13, 12                         ;
        amominu.w x12, x14, (x13)                 ;
_l54:   fadd.s f12, f0, f16, rne                  ;
_l55:   csrrsi x20, mscratch, 31                  ;
_l56:   fle.s x12, f29, f1                        ;
_l57:   la x30, d_4_14                            ;
        addi x30, x30, -24                        ;
        amomin.w x27, x13, (x30)                  ;
_l58:   fmul.s f6, f16, f21, rmm                  ;
_l59:   bltu x22, x5, _l115                               ;
_l60:   ebreak                                    ;
_l61:   la x6, _l90                                       ;
        csrrw zero, uepc, x6                      ;
        uret                                      ;
_l62:   fnmadd.s f8, f16, f22, f26, rmm           ;
_l63:   blt x16, x16, _l91                                ;
_l64:   la x14, d_0_9                             ;
        addi x14, x14, -20                        ;
        amomin.w x28, x26, (x14)                  ;
_l65:   fsqrt.s f17, f14, dyn                     ;
_l66:   jal x21, _l131                                    ;
_l67:   div x27, x9, x11                          ;
_l68:   blt x27, x19, _l108                       ;
_l69:   mulhu x4, x20, x21                        ;
_l70:   slli x16, x17, 19                         ;
_l71:   csrrwi x22, pmpaddr7, 5                   ;
_l72:   fle.s x20, f19, f8                        ;
_l73:   la x8, d_4_13                             ;
        lwu x8, 16(x8)                            ;
_l74:   la x24, d_3_13                            ;
        addi x24, x24, -8                         ;
        amomin.w x5, x6, (x24)                    ;
_l75:   fsqrt.s f3, f30, rne                      ;
_l76:   addiw x11, x23, 1309                      ;
_l77:   la x21, d_3_14                            ;
        addi x21, x21, -24                        ;
        amoswap.d x1, x12, (x21)                  ;
_l78:   xor x30, x30, x30                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 31                         ;
        add x30, x30, x12                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 19                         ;
        add x30, x30, x20                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 10                         ;
        add x30, x30, x29                         ;
        csrrs x16, fflags, x30                    ;
_l79:   srai x17, x11, 23                         ;
_l80:   bltu x9, x22, _l102                               ;
_l81:   addw x26, x19, x30                        ;
_l82:   ebreak                                    ;
_l83:   fcvt.s.wu f6, x4, rne                     ;
_l84:   sraw x9, x20, x9                          ;
_l85:   remuw x29, x7, x14                        ;
_l86:   rem x4, x17, x22                          ;
_l87:   la x12, _l101                                      ;
        lb x27, 2(x12)                            ;
_l88:   fadd.s f2, f9, f30, rdn                   ;
_l89:   la x16, d_1_9                             ;
        addi x16, x16, 0                          ;
        amoand.d x12, x2, (x16)                   ;
_l90:   la x8, d_5_26                             ;
        addi x8, x8, -4                           ;
        sc.w x5, x18, (x8)                        ;
_l91:   fsub.s f17, f7, f17, rup                  ;
_l92:   andi x8, x25, 1826                        ;
_l93:   la x29, d_1_25                            ;
        addi x29, x29, -16                        ;
        amomax.d x27, x20, (x29)                  ;
_l94:   fsgnjn.s f5, f25, f18                     ;
_l95:   fcvt.lu.s x11, f10, rup                   ;
_l96:   mul x7, x14, x7                           ;
_l97:   la x17, d_2_9                             ;
        sb x27, -31(x17)                          ;
_l98:   la x11, d_2_9                             ;
        addi x11, x11, 12                         ;
        amomaxu.w x7, x20, (x11)                  ;
_l99:   addw x3, x7, x6                           ;
_l100:  la x8, d_5_15                             ;
        sw x2, 28(x8)                             ;
_l101:  fcvt.s.wu f26, x4, dyn                    ;
_l102:  la x21, _l63                                      ;
        lh x1, -0(x21)                            ;
_l103:  la x28, d_0_13                            ;
        flw f13, 4(x28)                           ;
_l104:  la x30, d_0_2                             ;
        lbu x7, -4(x30)                           ;
_l105:  sraw x22, x9, x8                          ;
_l106:  fsgnjn.s f4, f8, f10                      ;
_l107:  bne x7, x19, _l115                                ;
_l108:  la x27, d_3_23                            ;
        addi x27, x27, 8                          ;
        amomax.d x24, x19, (x27)                  ;
_l109:  fcvt.s.lu f11, x5, rtz                    ;
_l110:  srai x2, x13, 31                          ;
_l111:  fcvt.s.lu f14, x21, rup                   ;
_l112:  fnmadd.s f25, f19, f29, f23, rmm          ;
_l113:  la x13, d_1_14                            ;
        addi x13, x13, -0                         ;
        amoadd.d x8, x23, (x13)                   ;
_l114:  fadd.s f18, f6, f10, rmm                  ;
_l115:  la x10, d_2_15                            ;
        addi x10, x10, -8                         ;
        amoadd.w x20, x14, (x10)                  ;
_l116:  la x1, d_5_25                             ;
        addi x1, x1, -28                          ;
        amoxor.w x5, x6, (x1)                     ;
_l117:  la x23, _l125                                      ;
        lb x19, 31(x23)                           ;
_l118:  srli x30, x4, 60                          ;
_l119:  divuw x10, x26, x18                       ;
_l120:  bgeu x12, x18, _l122                              ;
_l121:  fnmadd.s f19, f31, f4, f4, rup            ;
_l122:  la x27, d_5_2                             ;
        addi x27, x27, -24                        ;
        amomaxu.d x8, x14, (x27)                  ;
_l123:  lui x24, 120223                           ;
_l124:  subw x18, x21, x10                        ;
_l125:  lui x7, 19                                ;
_l126:  la x7, d_5_26                             ;
        lh x5, 2(x7)                              ;
_l127:  ori x14, x2, -11                          ;
_l128:  fcvt.l.s x4, f30, rne                     ;
_l129:  sltiu x5, x11, -631                       ;
_l130:  addw x29, x11, x7                         ;
_l131:  div x3, x27, x3                           ;
_l132:  la x23, d_2_8                             ;
        addi x23, x23, -16                        ;
        amominu.w x26, x21, (x23)                 ;
_l133:  la x3, d_1_23                             ;
        sw x6, 0(x3)                              ;
_l134:  fadd.s f9, f9, f10, rdn                   ;
_l135:  fsqrt.s f30, f11, rup                     ;
_l136:  jal x14, _l137                            ;
_l137:;
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
                .dword 0xf03dc1d5e6df6064, 0x77c9712ff135a6db
                .dword 0xce3b5fdabd34d563, 0x51993eae74c2f351
d_0_0:          .dword 0xc4b2008f032d60ae, 0x7cf4c98aa9227add
d_0_1:          .dword 0xd6bbb8c9b5947b36, 0xa55de00eaccf0f2b
d_0_2:          .dword 0x4594ac3e319d0f82, 0xb33012e86a3c3bf0
d_0_3:          .dword 0xa2616587593ed3ac, 0x9edc072b26728c10
d_0_4:          .dword 0x5e2026b04e135d52, 0x97f5c6cfb10a51b6
d_0_5:          .dword 0xe995cb3d952e4887, 0xc2ca6dd2058a630f
d_0_6:          .dword 0x97ec2005a0e8ef02, 0x18f1bdf71f4f67a7
d_0_7:          .dword 0xf379b2a99c8f83b5, 0xbee9aa5593fe98df
d_0_8:          .dword 0xfe5676817ace3034, 0xa34071df12b502e1
d_0_9:          .dword 0xd432a61682097116, 0x514d67b7cc52b5f1
d_0_10:         .dword 0xbcbbe5d2678a3c7e, 0x2abad8d45b8c6c20
d_0_11:         .dword 0x17d3e16f1b24e3c1, 0x4a69d1dc7489f837
d_0_12:         .dword 0x876ee2a14f53b0e9, 0x948c9fd314460967
d_0_13:         .dword 0x76e80890098bfffe, 0xb7835af77145b9c3
d_0_14:         .dword 0xe346e27c1b61cb5d, 0xafec0ea87091deea
d_0_15:         .dword 0xfab997afbe880b34, 0x07dbb8f8d6b83bc4
d_0_16:         .dword 0x80893e3a28019dc8, 0xdc7d15614e8c6ad8
d_0_17:         .dword 0x63e3f2145dcd8118, 0xb39ece7e1e7d21be
d_0_18:         .dword 0x3ec37adce3094e30, 0xb887e520b850e084
d_0_19:         .dword 0xb3ef474aacaad416, 0x8afeaa119d415d22
d_0_20:         .dword 0x5a0e6811a7d2436c, 0x72975076728cee38
d_0_21:         .dword 0x742d84935d6c4821, 0x16eb745de1342fed
d_0_22:         .dword 0xe01d8ea956ec9a86, 0x815ed38ed3595869
d_0_23:         .dword 0xb1231f981178ff04, 0xca11c3bb6a55c183
d_0_24:         .dword 0x534646904239e3ad, 0xbafc1a6a4ee1d185
d_0_25:         .dword 0xe5ddc234a89c78f2, 0xe11f98a7f91b4d7d
d_0_26:         .dword 0x74677443feafb1df, 0x97c1e52c283c4dd3
d_0_27:         .dword 0xebfba01b7779a956, 0x5a2039264007a55e
                .dword 0x6a600a46e9dba47a, 0x0fe3673d79572aee
                .dword 0x86562866f71719a7, 0xaffb114b694d7ecc
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x5b59bf667b98b5db, 0x23d32f33f4bebb80
                .dword 0x73214041a50c22c8, 0x908553265c788d1a
d_1_0:          .dword 0x9b026326a0b488a9, 0xc821f8c41d5a81ef
d_1_1:          .dword 0x42019a6833ba7b31, 0x6c3bbabda104d5f5
d_1_2:          .dword 0x4bf4479140af255a, 0xd88784b946962f3d
d_1_3:          .dword 0x6094f5d4e8606015, 0x1e19c73652139bae
d_1_4:          .dword 0x36e1e729d24cab11, 0xb2be2ba17661194b
d_1_5:          .dword 0xae2f73bc0794264d, 0x2635c085537df1e2
d_1_6:          .dword 0x1efa84f52539edd1, 0xd9dc22af79085b50
d_1_7:          .dword 0x9acc03b6b5c7d6a1, 0x20a5e83f7ae4a6e5
d_1_8:          .dword 0x1d4c873c55088580, 0xd579f88bc5877afd
d_1_9:          .dword 0x7a0a138a2321612c, 0x898fc1cc8680d7de
d_1_10:         .dword 0xd1588dcc4e3f181e, 0x84f19e553273d09d
d_1_11:         .dword 0x3a8983839ec09c12, 0x0259ca876f71532b
d_1_12:         .dword 0xc60717daa3856b8d, 0xca1bf413f387b446
d_1_13:         .dword 0xd13b336ed80fdd31, 0xb8764f687264acf1
d_1_14:         .dword 0xb65fe5d89b77eb95, 0x69884850d3215eaa
d_1_15:         .dword 0xf45880100540c13f, 0x1ec68eec8f28fb6f
d_1_16:         .dword 0xf68b1de43ddbbb4f, 0x0f2a22be948cbe33
d_1_17:         .dword 0x02055d3881e4b8b0, 0x7fc3025de85a0dae
d_1_18:         .dword 0x92c8ccc687f6335b, 0xc88aeb2c754277f4
d_1_19:         .dword 0x95b03246217590e9, 0x37f98d02878cbe5a
d_1_20:         .dword 0xb98a95321d2ce83e, 0xc78f9e0965f88f49
d_1_21:         .dword 0xfd1ca729d16f90c5, 0x51c801635c63fcc8
d_1_22:         .dword 0xcfd882dc9ef821cb, 0x556407ce525f8c78
d_1_23:         .dword 0xda6451eb80820e4c, 0x5dc3446fbf71d3e8
d_1_24:         .dword 0xc44885c274e28d14, 0x32b13bdf4a264f36
d_1_25:         .dword 0x8000aec56c07b569, 0x107804752759c883
d_1_26:         .dword 0xb74c37082b6d3002, 0x9db782e8b69dd74d
d_1_27:         .dword 0x390567145901f5bf, 0x7c084ef70a83c4f5
                .dword 0x76da8b9c993b6ae8, 0x15fa9e080af5f84f
                .dword 0xbce3c9c701f728b4, 0xf34591c2ddd63d96
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xe42c707007843d2a, 0x69b79970dac1285b
                .dword 0x15c55950c96aca57, 0x6b972e4958ccaf82
d_2_0:          .dword 0x8011d50f7d0a404d, 0x90932a23d6d47704
d_2_1:          .dword 0x15e924a70385adc4, 0xd75ddd0dfe5485d3
d_2_2:          .dword 0x3cde0558ae8deae2, 0x0a290c44abdbe72f
d_2_3:          .dword 0xf584184bd33aa929, 0xbde219f70428b610
d_2_4:          .dword 0xa48ded4460a723f9, 0xc32ecb2724c885a3
d_2_5:          .dword 0xd0602e642441de15, 0xc4202fd1c7c15e89
d_2_6:          .dword 0xb5c5b12d6e148246, 0x97e15f15c38627a5
d_2_7:          .dword 0x5686cec1a8d9e46a, 0xc503b023ff3715d6
d_2_8:          .dword 0x950a79c8df8dda64, 0x2459d8d3c66695a6
d_2_9:          .dword 0xa1975506fe695f4e, 0xe4b3e29647c87f0f
d_2_10:         .dword 0xa60aec9281f2645b, 0x92450f4cee63f161
d_2_11:         .dword 0x76421b689a926276, 0x399b280bc4be0a08
d_2_12:         .dword 0x4109d084478aaa40, 0x4d5c03673a637c2d
d_2_13:         .dword 0x4df61c4286b94602, 0xbe8e465affa01e6a
d_2_14:         .dword 0x3764650556e71a87, 0x67be4562d47a87ba
d_2_15:         .dword 0xc75aeaf997dbcc0e, 0x9c62e60596da575c
d_2_16:         .dword 0x7b79052b72787e6e, 0x8583c855916727e2
d_2_17:         .dword 0xd6acea106d0755bc, 0xa6c08e05b97b51b8
d_2_18:         .dword 0x42847f6dd11e053a, 0xc5191b2607c54ad0
d_2_19:         .dword 0x0b56fc211063e84f, 0xb9286d58521611bd
d_2_20:         .dword 0xa80192f4263f4acb, 0x1da376caa64c28e8
d_2_21:         .dword 0x29a3fa2c25f24339, 0xa0c0da833d924c72
d_2_22:         .dword 0xa95c3a48f6259350, 0x385a7d50c2a612df
d_2_23:         .dword 0xf0c37b6fafdc86c5, 0x96fed1b70ec99daf
d_2_24:         .dword 0x8196a8456dc4573d, 0xe309d2c05cc2e880
d_2_25:         .dword 0x31511cc64716feea, 0x1ddbc65fb1422935
d_2_26:         .dword 0x97fdb2cbb61bd7f8, 0xee984adb9e269678
d_2_27:         .dword 0xf7721bf58a9235b9, 0x7f7650c442f0db47
                .dword 0xd4c0ada3328aa987, 0xebfa01dfb5872211
                .dword 0x110600188a461907, 0x9db1bf14295b6cc4
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x0b763e17841131c4, 0x445f3ce2312da8b3
                .dword 0x003f660f989f4933, 0x4392c9eae7647251
d_3_0:          .dword 0x9eea6e5edc1376c6, 0x8520e006e5f1f85f
d_3_1:          .dword 0x36de52bf9e373220, 0xb895b48481f6eb14
d_3_2:          .dword 0xc1f73c8fd8cfb45c, 0xfa5ef8a4f6e77837
d_3_3:          .dword 0x6e559f8cd0ac597e, 0xedc567cab25337d0
d_3_4:          .dword 0xdb37b0864b1ad4ca, 0xbf879b3b69114cb7
d_3_5:          .dword 0xa91065a479386f8d, 0xbcf2ac70e95ab9f0
d_3_6:          .dword 0x7534c5d7758b7b00, 0x74af90c384f36988
d_3_7:          .dword 0x9cdb40054ec23211, 0x095deb73051d1b14
d_3_8:          .dword 0x4ded909e311c22ee, 0xc6d62f1215853c36
d_3_9:          .dword 0x5e3bc11d1208bdf6, 0xca5e2e3ffed699cb
d_3_10:         .dword 0x22262afeec4be669, 0x04aa9df48869b172
d_3_11:         .dword 0x5701fedac6379a03, 0x3a4620f878d71273
d_3_12:         .dword 0xa1d25f6210ce6041, 0xd592a00525b8e482
d_3_13:         .dword 0x2001c505e18b395c, 0x35dbfafb4ff86ef3
d_3_14:         .dword 0x681fbe51a80daa44, 0x9140a1aafbaa905c
d_3_15:         .dword 0xac1cbf1a42dd2751, 0x1107869097ec4619
d_3_16:         .dword 0xb962111a53d08c7f, 0x4ba34dd94333e471
d_3_17:         .dword 0xbb385dd3b22bf030, 0xe6aded4dea94d1ed
d_3_18:         .dword 0x0089cff7dd6db6b5, 0x93fedb917d4a4bed
d_3_19:         .dword 0x6cee25dd08be176e, 0x1b44657ef2e33cb7
d_3_20:         .dword 0x43ebc8d4c5c7c173, 0x6ebbaa26d444ccaa
d_3_21:         .dword 0x35024cf1e82f856a, 0x29295bb734169760
d_3_22:         .dword 0xfac717a5375c71c7, 0xbd947ccddd8ead14
d_3_23:         .dword 0x7d60bfe02bb8d205, 0x2d0ec8208852a93f
d_3_24:         .dword 0xc677c22df75000ab, 0xe70d603352104fcf
d_3_25:         .dword 0x791b63a9302169f4, 0x928d6b952baede96
d_3_26:         .dword 0xa6cd264346eb82ac, 0x573a474b61de3c80
d_3_27:         .dword 0x42ff5b71e210aeb4, 0x5fab525dc7ef046d
                .dword 0xce6bb8b4b93d0564, 0x05cbad5f77e8a4ba
                .dword 0x65aec896d8ac44bc, 0x1f0b6ddded59ea3f
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xdc4bb9a3b8939c35, 0xbba504b8af8bf3cb
                .dword 0xb5e700a50536cafe, 0x825376be7549597a
d_4_0:          .dword 0x8c9c99d6fe63ee2c, 0x1ccccca6eef8cb54
d_4_1:          .dword 0x08843838e4f8604c, 0x6fb253186f12dd61
d_4_2:          .dword 0x19b7a92aea9bb050, 0xd7ea9438d36fcb37
d_4_3:          .dword 0xbb9034a20dad4f0a, 0x409cdc0c6ec56b4c
d_4_4:          .dword 0xa289ee4fc9bc2ceb, 0x850b8225306502da
d_4_5:          .dword 0x24e7fc3a8ba354f8, 0x069c5d723df6ad93
d_4_6:          .dword 0x561c92508b1800a7, 0x4ab2f203a1508224
d_4_7:          .dword 0x6cb569d33dba8e29, 0x5115a398090ba7be
d_4_8:          .dword 0xd530269c68fc128f, 0xafad7280676406cf
d_4_9:          .dword 0xf830392802990d64, 0x07698d4130ccd77d
d_4_10:         .dword 0xbfa2686bfa633470, 0xec98b81643f2139a
d_4_11:         .dword 0x7e703d10a791dbb1, 0xf702984f6cbb4ab9
d_4_12:         .dword 0x38ee63dc99504e2c, 0x597ef43f6a1aacd1
d_4_13:         .dword 0xea2095f2912fe298, 0xfb06e57cf73319af
d_4_14:         .dword 0x63e5cc9a793d2b3b, 0xf5947bcee95e4291
d_4_15:         .dword 0x02836836ffbb6830, 0x64cef584dd53d1c7
d_4_16:         .dword 0xd929e8ef92c2597e, 0xf2d21b34a777b8e3
d_4_17:         .dword 0xc6ae0c8437579a3c, 0x0b12725ceeae563c
d_4_18:         .dword 0xb66a87b54725d8bd, 0xb90c0e3c45205d14
d_4_19:         .dword 0xd5207fd02a1ea561, 0xc88632bc2b8703ad
d_4_20:         .dword 0xd5aa0ecf074b7947, 0xff2fdac095a54064
d_4_21:         .dword 0x0df4483d82398ff8, 0x17d5d4fc927fb946
d_4_22:         .dword 0xf05dfbcfafc2e1d0, 0x08d34195dc02db91
d_4_23:         .dword 0xeb23f3a4804cf0ca, 0x275043f6c576ace2
d_4_24:         .dword 0x1f7a886a2bcdd4ea, 0x5276bb7a016d7599
d_4_25:         .dword 0xc32678466e18741c, 0x59d72b681c4a8e26
d_4_26:         .dword 0x0fe39ba155873dfa, 0x9e82bae9817fe6e6
d_4_27:         .dword 0xbe668026b3e421c3, 0x83be744f9cb24d06
                .dword 0x14d4bf696ec1e4a0, 0x78cb7678843ffa85
                .dword 0x2642af1030248eac, 0x2c2040531fb8f065
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xb680208e2a082bce, 0xd410ab0305741020
                .dword 0x28f58e39e3b5d61f, 0x7cf2fec6ad9587c6
d_5_0:          .dword 0x2595a2032eec7ada, 0x010baef0125a998e
d_5_1:          .dword 0xfc717e20fc026667, 0xfb802c653ac69048
d_5_2:          .dword 0xbf8da24927520a86, 0x5593f93d2165775e
d_5_3:          .dword 0xd91b5cfbd27f5bc1, 0x5dcc6fea7fccf32d
d_5_4:          .dword 0x2dfdbd05308629cf, 0x5fbf433b03671ff0
d_5_5:          .dword 0xa6aa6313ce0e35a4, 0xf38fd9863372a7f7
d_5_6:          .dword 0x06acba74c4b0d732, 0x0ef06ab02ca3628b
d_5_7:          .dword 0x60bd87e5fdb32619, 0xc715b17954fc2341
d_5_8:          .dword 0x9436cc9d0a8a412e, 0xafcb75994ac9288d
d_5_9:          .dword 0x0bd9f523328aa497, 0xa75aefbf2a971960
d_5_10:         .dword 0xf088aca0b3a4b95c, 0x4980a26f935a13f1
d_5_11:         .dword 0x670e25f912c9f04f, 0x39c830f4d52164c1
d_5_12:         .dword 0xf2f124462c59a55b, 0xe2c5aab60248640e
d_5_13:         .dword 0x7cc5a4c68342bacf, 0xa6c15f20a90a0a65
d_5_14:         .dword 0xb2d12f1378008d3e, 0x60d7cfd77d47ec0c
d_5_15:         .dword 0xebaa2f2943edb254, 0xa35820fc5bdd9753
d_5_16:         .dword 0x0bea9ecf9e9262fb, 0xb4711e2ef03ef27a
d_5_17:         .dword 0x05d62a3facac027d, 0xcbea60ee1ffbda44
d_5_18:         .dword 0x42e74834642a32a3, 0x2c54783aa76ad4e6
d_5_19:         .dword 0x261ccaca0ff03bc1, 0x947e043e434761da
d_5_20:         .dword 0xa989213518a61524, 0xe2f76206db6da829
d_5_21:         .dword 0x73fcc1c0a38cf326, 0x56915c359ffc0ee8
d_5_22:         .dword 0x2307592afd576641, 0x15d72dfe748fa696
d_5_23:         .dword 0x637acf44d43e7fd3, 0x15fa85d6cfddfd87
d_5_24:         .dword 0x291e990a3fa0e18b, 0x77997453ae4cbc2a
d_5_25:         .dword 0x218e2c1f6b648286, 0xc0403f4d3b3f2f51
d_5_26:         .dword 0xb3fba61123f0a1dd, 0xad9897a182ba3a37
d_5_27:         .dword 0x22ff261c8e35c5d0, 0x497de06925b271cf
                .dword 0xd02ffdf811cf07ec, 0x709002f27c055e30
                .dword 0x3e19560d3c277ea5, 0xada1031787c52dde
         /* Random data */
_end_data5:
              
 
