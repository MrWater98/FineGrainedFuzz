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
_p0:    csrrwi x14, stval, 31                     ;
_p1:    csrrci x14, satp, 31                      ;
_p2:    csrrci x11, fcsr, 1                       ;
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
_s0:    ecall                                     ;
_s1:    auipc x26, 1960                           ;
_s2:    addi x7, x10, -883                        ;
_s3:    la x11, d_3_3                             ;
        addi x11, x11, 16                         ;
        amoor.d x1, x2, (x11)                     ;
_s4:    fmax.s f24, f1, f21                       ;
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
_l0:    la x29, _l22                              ;
        csrrw zero, mepc, x29                     ;
        mret                                      ;
_l1:    subw x28, x12, x18                        ;
_l2:    fnmadd.s f30, f23, f28, f15, rdn          ;
_l3:    sraiw x29, x0, 19                         ;
_l4:    la x14, d_4_10                            ;
        sw x15, 0(x14)                            ;
_l5:    fdiv.s f16, f15, f12, rup                 ;
_l6:    csrrci x21, mhartid, 31                   ;
_l7:    la x12, _l61                              ;
        lui x10, 0xffe00                          ;
        xor x12, x12, x10                         ;
        lbu x7, -26(x12)                          ;
_l8:    fcvt.s.wu f2, x9, rtz                     ;
_l9:    la x11, d_0_20                            ;
        addi x11, x11, 16                         ;
        amomaxu.w x19, x28, (x11)                 ;
_l10:   divu x18, x9, x30                         ;
_l11:   fcvt.w.s x11, f19, rne                    ;
_l12:   sraiw x1, x28, 31                         ;
_l13:   fmax.s f28, f31, f4                       ;
_l14:   fle.s x2, f26, f10                        ;
_l15:   la x24, d_0_10                            ;
        addi x24, x24, 4                          ;
        lui x10, 0xffe00                          ;
        xor x24, x24, x10                         ;
        amoswap.w x28, x10, (x24)                 ;
_l16:   ebreak                                    ;
_l17:   la x18, d_1_1                             ;
        addi x18, x18, -0                         ;
        amoswap.w x18, x12, (x18)                 ;
_l18:   la x9, _l85                               ;
        csrrw zero, uepc, x9                      ;
        uret                                      ;
_l19:   fsgnjn.s f5, f2, f4                       ;
_l20:   la x8, d_2_21                             ;
        lhu x28, 20(x8)                           ;
_l21:   sraiw x29, x9, 0                          ;
_l22:   la x12, d_4_12                            ;
        addi x12, x12, 0                          ;
        amomaxu.d x4, x16, (x12)                  ;
_l23:   auipc x21, 1045875                        ;
_l24:   la x21, d_5_14                            ;
        sd x5, -24(x21)                           ;
_l25:   la x2, d_4_9                              ;
        addi x2, x2, -12                          ;
        amominu.w x11, x27, (x2)                  ;
_l26:   bltu x3, x19, _l96                        ;
_l27:   addi x2, x3, 131                          ;
_l28:   bge x16, x8, _l60                         ;
_l29:   sraw x6, x19, x30                         ;
_l30:   la x6, d_4_24                             ;
        flw f18, 8(x6)                            ;
_l31:   rem x27, x7, x19                          ;
_l32:   la x10, d_5_15                            ;
        addi x10, x10, -0                         ;
        lr.w x20, (x10)                           ;
_l33:   slliw x10, x16, 17                        ;
_l34:   fdiv.s f19, f24, f1, rtz                  ;
_l35:   addi x9, x14, 49                          ;
_l36:   divu x12, x6, x2                          ;
_l37:   fsgnjx.s f3, f23, f16                     ;
_l38:   la x8, d_0_17                             ;
        addi x8, x8, -24                          ;
        sc.d x4, x8, (x8)                         ;
_l39:   mulh x21, x9, x10                         ;
_l40:   srai x1, x28, 41                          ;
_l41:   bltu x9, x5, _l82                         ;
_l42:   la x6, d_2_11                             ;
        addi x6, x6, -16                          ;
        sc.w x19, x10, (x6)                       ;
_l43:   divuw x18, x1, x22                        ;
_l44:   bgeu x21, x14, _l108                      ;
_l45:   fsub.s f18, f6, f18, rup                  ;
_l46:   la x27, _l112                             ;
        csrrw zero, mepc, x27                     ;
        mret                                      ;
_l47:   bltu x1, x1, _l142                        ;
_l48:   subw x25, x2, x17                         ;
_l49:   csrrci x24, pmpaddr0, 6                   ;
_l50:   mulhu x10, x11, x18                       ;
_l51:   la x24, d_3_4                             ;
        lb x10, -2(x24)                           ;
_l52:   fcvt.w.s x27, f10, rup                    ;
_l53:   srli x10, x30, 37                         ;
_l54:   bgeu x17, x21, _l91                       ;
_l55:   mulw x18, x28, x5                         ;
_l56:   feq.s x25, f24, f1                        ;
_l57:   la x29, d_3_6                             ;
        addi x29, x29, -0                         ;
        amoadd.d x16, x15, (x29)                  ;
_l58:   la x17, d_4_25                            ;
        addi x17, x17, -8                         ;
        amoadd.d x8, x26, (x17)                   ;
_l59:   blt x11, x9, _l88                         ;
_l60:   divw x29, x11, x26                        ;
_l61:   fnmsub.s f16, f8, f12, f4, rdn            ;
_l62:   fcvt.lu.s x20, f17, rup                   ;
_l63:   la x18, d_2_26                            ;
        srai x18, x18, 1                          ;
        csrrc x20, pmpaddr1, x18                  ;
_l64:   la x14, d_2_23                            ;
        sw x15, -0(x14)                           ;
_l65:   bge x19, x27, _l96                        ;
_l66:   fcvt.s.w f17, x5, dyn                     ;
_l67:   rem x29, x4, x16                          ;
_l68:   la x14, d_1_22                            ;
        addi x14, x14, -8                         ;
        amomin.d x28, x7, (x14)                   ;
_l69:   csrrsi x27, pmpaddr5, 9                   ;
_l70:   la x29, d_3_13                            ;
        addi x29, x29, -16                        ;
        amoor.d x20, x28, (x29)                   ;
_l71:   fcvt.l.s x27, f18, dyn                    ;
_l72:   la x29, d_3_16                            ;
        lh x8, -20(x29)                           ;
_l73:   la x7, d_3_12                             ;
        lb x25, -13(x7)                           ;
_l74:   la x27, d_5_7                             ;
        addi x27, x27, -16                        ;
        amoor.d x21, x21, (x27)                   ;
_l75:   fclass.s x0, f10                          ;
_l76:   fclass.s x12, f23                         ;
_l77:   slti x22, x14, 1968                       ;
_l78:   slli x25, x11, 51                         ;
_l79:   auipc x30, 811856                         ;
_l80:   fadd.s f9, f2, f1, rmm                    ;
_l81:   ebreak                                    ;
_l82:   la x4, d_3_7                              ;
        addi x4, x4, -0                           ;
        amominu.d x22, x12, (x4)                  ;
_l83:   fcvt.s.l f26, x26, rmm                    ;
_l84:   divuw x16, x2, x16                        ;
_l85:   fsub.s f29, f27, f14, rmm                 ;
_l86:   fle.s x18, f10, f15                       ;
_l87:   fsgnj.s f23, f7, f20                      ;
_l88:   la x10, d_5_11                            ;
        addi x10, x10, -0                         ;
        amominu.d x14, x13, (x10)                 ;
_l89:   la x19, d_5_26                            ;
        addi x19, x19, 0                          ;
        sc.d x19, x19, (x19)                      ;
_l90:   csrrwi x28, sip, 12                       ;
_l91:   andi x21, x24, -0                         ;
_l92:   la x21, d_3_15                            ;
        sh x21, -24(x21)                          ;
_l93:   mulhu x3, x21, x19                        ;
_l94:   fence                                     ;
_l95:   remuw x29, x10, x24                       ;
_l96:   la x19, d_4_11                            ;
        addi x19, x19, -16                        ;
        amominu.w x27, x15, (x19)                 ;
_l97:   beq x28, x4, _l114                        ;
_l98:   feq.s x20, f10, f31                       ;
_l99:   la x30, d_2_7                             ;
        addi x30, x30, -0                         ;
        amoand.d x10, x10, (x30)                  ;
_l100:  csrrci x10, frm, 18                       ;
_l101:  la x25, d_5_21                            ;
        addi x25, x25, 16                         ;
        amominu.d x21, x4, (x25)                  ;
_l102:  fence                                     ;
_l103:  rem x30, x0, x1                           ;
_l104:  la x25, d_5_25                            ;
        addi x25, x25, 16                         ;
        amomax.d x23, x3, (x25)                   ;
_l105:  la x20, d_4_10                            ;
        addi x20, x20, 8                          ;
        amomaxu.d x24, x2, (x20)                  ;
_l106:  mulw x10, x23, x28                        ;
_l107:  la x23, d_5_22                            ;
        addi x23, x23, -0                         ;
        amominu.w x4, x28, (x23)                  ;
_l108:  fcvt.s.l f13, x30, dyn                    ;
_l109:  la x3, _l116                              ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l110:  fcvt.l.s x22, f4, rdn                     ;
_l111:  la x26, d_0_16                            ;
        addi x26, x26, 0                          ;
        lr.d x11, (x26)                           ;
_l112:  ori x6, x28, -1343                        ;
_l113:  la x12, d_2_12                            ;
        srai x12, x12, 1                          ;
        csrrs x29, pmpaddr0, x12                  ;
_l114:  mulh x20, x16, x28                        ;
_l115:  la x19, d_0_20                            ;
        addi x19, x19, 28                         ;
        amoand.w x27, x16, (x19)                  ;
_l116:  fmul.s f27, f31, f24, rup                 ;
_l117:  la x25, d_5_27                            ;
        ld x26, 16(x25)                           ;
_l118:  la x30, d_3_5                             ;
        addi x30, x30, -8                         ;
        amoadd.d x30, x20, (x30)                  ;
_l119:  la x10, d_4_26                            ;
        addi x10, x10, 0                          ;
        amoor.d x18, x9, (x10)                    ;
_l120:  fsgnj.s f8, f21, f28                      ;
_l121:  la x2, d_4_19                             ;
        addi x2, x2, -0                           ;
        amoadd.w x20, x2, (x2)                    ;
_l122:  srlw x17, x23, x21                        ;
_l123:  la x18, d_0_20                            ;
        addi x18, x18, 0                          ;
        sc.d x15, x18, (x18)                      ;
_l124:  divw x10, x24, x23                        ;
_l125:  fle.s x30, f26, f2                        ;
_l126:  fnmadd.s f12, f7, f4, f3, rmm             ;
_l127:  li x28, 1                                 ;
        la x0, pt0                                ;
        addi x0, x0, 40                           ;
        sfence.vma x28, x0                        ;
_l128:  la x28, d_4_11                            ;
        sw x12, -28(x28)                          ;
_l129:  sraiw x13, x23, 19                        ;
_l130:  la x14, d_5_19                            ;
        addi x14, x14, -4                         ;
        lui x9, 0xffe00                           ;
        xor x14, x14, x9                          ;
        sc.w x2, x9, (x14)                        ;
_l131:  fmax.s f15, f20, f12                      ;
_l132:  fsqrt.s f5, f18, rtz                      ;
_l133:  jal x17, _l160                            ;
_l134:  ori x5, x22, 1960                         ;
_l135:  xori x27, x8, 1847                        ;
_l136:  fnmsub.s f17, f20, f3, f10, rne           ;
_l137:  la x24, d_2_5                             ;
        addi x24, x24, 24                         ;
        lr.d x7, (x24)                            ;
_l138:  fence.i                                   ;
_l139:  fcvt.s.lu f16, x15, rne                   ;
_l140:  fmul.s f15, f4, f7, rmm                   ;
_l141:  sllw x17, x8, x8                          ;
_l142:  xor x29, x29, x29                         ;
        addi x29, zero, 1                         ;
        slli x29, x29, 9                          ;
        add x29, x29, x29                         ;
        addi x2, zero, 3                          ;
        slli x2, x2, 22                           ;
        add x29, x29, x2                          ;
        addi x28, zero, 3                         ;
        slli x28, x28, 9                          ;
        add x29, x29, x28                         ;
        csrrs x22, mtval, x29                     ;
_l143:  mul x21, x15, x28                         ;
_l144:  la x14, d_1_0                             ;
        addi x14, x14, -28                        ;
        amoadd.w x13, x10, (x14)                  ;
_l145:  rem x3, x23, x15                          ;
_l146:  fsqrt.s f11, f6, rdn                      ;
_l147:  fmul.s f28, f19, f5, rmm                  ;
_l148:  la x1, d_1_7                              ;
        lwu x2, 8(x1)                             ;
_l149:  la x14, d_3_1                             ;
        addi x14, x14, 0                          ;
        lui x17, 0xffe00                          ;
        xor x14, x14, x17                         ;
        amoswap.d x20, x17, (x14)                 ;
_l150:  bgeu x10, x16, _l162                      ;
_l151:  la x11, _l152                             ;
        csrrw zero, mepc, x11                     ;
        mret                                      ;
_l152:  andi x22, x10, 1463                       ;
_l153:  fnmadd.s f7, f8, f9, f30, rmm             ;
_l154:  la x1, d_1_4                              ;
        addi x1, x1, 24                           ;
        amominu.d x5, x9, (x1)                    ;
_l155:  fmv.w.x f4, x15                           ;
_l156:  mulh x3, x8, x4                           ;
_l157:  addi x25, x8, -2047                       ;
_l158:  la x1, _l30                               ;
        flw f18, -12(x1)                          ;
_l159:  ori x2, x6, 11                            ;
_l160:  fcvt.wu.s x11, f20, rdn                   ;
_l161:  la x10, d_3_25                            ;
        lb x30, -14(x10)                          ;
_l162:  addi x12, x14, -131                       ;
_l163:;
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
                .dword 0x8e0a9d4f56f6b397, 0x798a93b3c2717345
                .dword 0x92e88d498b62d1a4, 0x07f002af1da856b8
d_0_0:          .dword 0x2afdabd284b357ea, 0xb40c8d1887905fff
d_0_1:          .dword 0x20d580d311e17a52, 0xbe69969b6f5c5fea
d_0_2:          .dword 0x332ab8c75e55d770, 0xcf2ad20f6a60919e
d_0_3:          .dword 0xcc0897ebdfa6ca96, 0xead0fcb855c0ec73
d_0_4:          .dword 0x0a3654d2a34ee740, 0x3c55f8c61889c425
d_0_5:          .dword 0x2589cc98cf5916bf, 0x141c0bcab6400c2e
d_0_6:          .dword 0xd33f905862a8d26f, 0x00da75f90823ae99
d_0_7:          .dword 0xbace221868ef54c5, 0xa73dceaf02e34c2f
d_0_8:          .dword 0xd5c8d349357d8f0d, 0x8865c6fb9e23bb33
d_0_9:          .dword 0x81333bb931c7accc, 0x4ec3c5b0da5206c9
d_0_10:         .dword 0x37a7def0c8275012, 0xe75958f3611d09e3
d_0_11:         .dword 0x2c40b401f490ac7c, 0xbfe1f1930fa421ee
d_0_12:         .dword 0xb151b8cd4866949a, 0x3a086b2180519577
d_0_13:         .dword 0x4398fcf5d2068c25, 0xf0cd9e8d9e484525
d_0_14:         .dword 0xfb5609b1c92548fb, 0x017d82c0d7817f73
d_0_15:         .dword 0xdf98a45cad9dc0f1, 0x958afabc091c5a09
d_0_16:         .dword 0xef0faa0f511475a4, 0x444c2cf9f60202a8
d_0_17:         .dword 0xfb59698187519a84, 0x842c18c31dc25f9e
d_0_18:         .dword 0xfe208352530995d9, 0x83623c3c87df6ef4
d_0_19:         .dword 0x08aaaf5b09b8925a, 0x94e2478576efe9fc
d_0_20:         .dword 0x322e74f73233d026, 0x0f9ab49b5eb24c86
d_0_21:         .dword 0x997e18934fcb5ba8, 0x7b38dc0512a1f750
d_0_22:         .dword 0x245e4dece5f691e1, 0x34e564cf4c4e64e4
d_0_23:         .dword 0x7ebdfa83df9746fd, 0x44cb8cbb8736ccb2
d_0_24:         .dword 0x7120e445164b9441, 0x0ba0edba95c22fb3
d_0_25:         .dword 0x1f06ebd40ba4d510, 0x6aafa4f6c40eb5b1
d_0_26:         .dword 0x60930ad3f7bf708b, 0x2e442ac33b525c37
d_0_27:         .dword 0xf27b53e0369b5e37, 0xf87abf18a7e478a5
                .dword 0x941c4bc4564c615f, 0x04a36a1833fc31dd
                .dword 0xdd6b261f97b0137a, 0x0d7b7c965226f8a5
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0dc94cfbb45e0c1b, 0x98cb5e313a51d09e
                .dword 0x3ac3fccaac97ab23, 0x23b10e53fcde9511
d_1_0:          .dword 0x0e763b2adfad2bb7, 0x7f6070e95adb8a6a
d_1_1:          .dword 0xae4a82f34b51f72b, 0x88eb5c786b029cd5
d_1_2:          .dword 0x1de2dbfda8b496e7, 0x7132202efd7dc9a0
d_1_3:          .dword 0x409bc210b2fe2243, 0xb2620a8445381705
d_1_4:          .dword 0x9903d9aebcc1a889, 0x8a0c5f1ea6aeb260
d_1_5:          .dword 0x96c451a76f37bfa6, 0xcf0bfb7fb7f20b3c
d_1_6:          .dword 0x5dcc6ccc202b21be, 0xee0f315413966bd0
d_1_7:          .dword 0x30408c611f373397, 0xc39d254559a2bddc
d_1_8:          .dword 0x6941752f2fd54236, 0x4b1b9e7e92047b40
d_1_9:          .dword 0xa01900fbf36a2ae1, 0x39b3856a1c3ee9a6
d_1_10:         .dword 0x7dfd9e5344b9ef1a, 0x1d118cd420727aa9
d_1_11:         .dword 0xba1c72009a01b4db, 0x8c96bf9f0ba55ae0
d_1_12:         .dword 0x6f751a94af331305, 0xf4d3e3e057e836bb
d_1_13:         .dword 0xf15e4c03ea5912aa, 0x6654469b0ae739ea
d_1_14:         .dword 0xfcbe74fcb34749a1, 0x8543d7afb2a79480
d_1_15:         .dword 0xc103ba3a4951d660, 0xc23eb4c3fcc6512c
d_1_16:         .dword 0x99649b343b2861fc, 0x98144eca668c7d7d
d_1_17:         .dword 0xcd913fba2022c996, 0x5c431dba98b92f89
d_1_18:         .dword 0xb81570b5af5c95df, 0x8b7ad7ce5f16aed3
d_1_19:         .dword 0xcc0960225740f885, 0x8d841ed0ca9f5ea5
d_1_20:         .dword 0xf4540ef0d10999d4, 0x2d56380465b6a79f
d_1_21:         .dword 0x0f0387dd2b0ef4bb, 0x4259966db11e943b
d_1_22:         .dword 0x7ecc9cd91cc3ccf6, 0x6ed1790e30d89444
d_1_23:         .dword 0xfd17082347d245f9, 0x990f3482d31720ca
d_1_24:         .dword 0x6d8ef250af332237, 0x2a74e8dffaeb4cb9
d_1_25:         .dword 0xa516454862f5adf2, 0x9b861d9e007d7410
d_1_26:         .dword 0x8ea3348ff4df3ce2, 0x0f9188527fad479a
d_1_27:         .dword 0x241c4ce6afa5ac16, 0x8dbbafaac85db15c
                .dword 0x4ed269fe78ef5a4a, 0x04207f18712d7710
                .dword 0x15caf2a7264d6887, 0x613d4290b3e00bb2
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3067100710d1366b, 0x28994619fd36c38b
                .dword 0x408e85ec53b623bc, 0x7ac842c8cff974db
d_2_0:          .dword 0xc9611bba1438c080, 0x1959c076db4b96ba
d_2_1:          .dword 0x3ebb15c528ba80ec, 0xf10f613af58c16f7
d_2_2:          .dword 0x5e99620b567f9f8b, 0xe8f979e272b24958
d_2_3:          .dword 0x5c337696a9c9db30, 0xaff623199ff653b5
d_2_4:          .dword 0xfc5d2edc98dae654, 0xb1a8d19b579d1340
d_2_5:          .dword 0x0439a4726002dbfd, 0x3ac5393ad90617c2
d_2_6:          .dword 0x2e6a9bec0ef360ed, 0x97872048457f572c
d_2_7:          .dword 0x7e83b0acf293e89b, 0x5d818f3b8300e026
d_2_8:          .dword 0x5efa33dcf8dd3177, 0xec52cb5ead9f70eb
d_2_9:          .dword 0x033a0607396d79d0, 0xaaef9eb1ec335f20
d_2_10:         .dword 0x6c2568bdbd93c043, 0x8e7f29f6b3abaa90
d_2_11:         .dword 0x3c8dcf562ad99d75, 0xa5023093d913ef7f
d_2_12:         .dword 0xbf0dbead43dcc698, 0xfdb2737be44d6215
d_2_13:         .dword 0x8fcc61e242cacace, 0xdb0e76664441bcf4
d_2_14:         .dword 0x2d6867a30baa596d, 0xc5dea128ba1a4e8c
d_2_15:         .dword 0x902b50f71b42d6d7, 0x83f34f4fc5053ff2
d_2_16:         .dword 0xda0b9d3f21ad3bfa, 0x50811c95a28df743
d_2_17:         .dword 0x9e9e972f22554bde, 0xb2666e93665570f0
d_2_18:         .dword 0x34ee8d2d695dba24, 0x2a9671e2d7dab847
d_2_19:         .dword 0xe625fad6fbf891e3, 0xc53190793ffdd8d4
d_2_20:         .dword 0xcc3758016523b6dd, 0x87c27c444446d5b8
d_2_21:         .dword 0x583895772671ef8f, 0xf3a07235b47b19ad
d_2_22:         .dword 0x1c876ff118f88787, 0x8628cf2996cc44b8
d_2_23:         .dword 0x62e4aae99c74934c, 0x08f54c170605e463
d_2_24:         .dword 0xe69e54d46e76f793, 0xdf2e1358cefd967e
d_2_25:         .dword 0xfbea1041ab3b7310, 0x8158e3ba49bac520
d_2_26:         .dword 0x29aaeda12ab27211, 0x894db100218bffae
d_2_27:         .dword 0x86031d597631288a, 0x0b37ec27fd377ed0
                .dword 0xd4e9de5ef0b7c7b9, 0x09cfbb8504b4764f
                .dword 0x0c3d7675d2a7e18a, 0x201d347a9df21917
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x794501b14c14ba4d, 0x8dcf376cad66fd26
                .dword 0x3dfeac4505f4ef03, 0xc6d8b59b6fd93597
d_3_0:          .dword 0x7cef71b7a479e796, 0x452ee00ac4efa9aa
d_3_1:          .dword 0x202af91018233daa, 0xc2283e2b85640103
d_3_2:          .dword 0xda9cbabc2347db32, 0xa3c6c2002c3eb055
d_3_3:          .dword 0xf4314f812d4efcc6, 0x3f8e236d5ba041ba
d_3_4:          .dword 0x447a7d9104b232fc, 0x7e0475eece75074e
d_3_5:          .dword 0x7402b429d17f779c, 0x277219bbac8eaa14
d_3_6:          .dword 0xe7ea81830ada1b62, 0x8f19aecd60f279ba
d_3_7:          .dword 0x72c7e498e4567d9b, 0x638271e5ef362baa
d_3_8:          .dword 0xb7a1a079a0ad1ce5, 0x0e4897761d366adb
d_3_9:          .dword 0x7280ea3a4e358509, 0xa09c2bc6ef187cbc
d_3_10:         .dword 0xa2a40c9fb4d52de2, 0x2862516cc8c7bbbc
d_3_11:         .dword 0x4cd137be8a39a02f, 0xcc6d1857a76ca995
d_3_12:         .dword 0x36be0796f683c8ad, 0xb2d2fe71685b971d
d_3_13:         .dword 0x4777180258050a46, 0x1581d798bc50e1a8
d_3_14:         .dword 0xbb9d320fb850d6e9, 0xfc1fad4cf6c7b065
d_3_15:         .dword 0x17d079c46eb76e87, 0xdcc1d4dd3039e626
d_3_16:         .dword 0xe55487f3134a7995, 0x35114305ea182ce8
d_3_17:         .dword 0x1f3d976c7c7a9311, 0x1b965c2bb0b5fcfc
d_3_18:         .dword 0x87df4aa0fbd205fc, 0xb142047b38fdf250
d_3_19:         .dword 0xc41004c812b92563, 0x69b62a9b39720c74
d_3_20:         .dword 0xaead28b694816bb4, 0x93fd510d79af6eaa
d_3_21:         .dword 0x9e6a24d548ff42ed, 0x4b33a3a0ebf83da1
d_3_22:         .dword 0x8f25ea97beb65066, 0x34a9496fbcf7ebd8
d_3_23:         .dword 0xf16580211d4c3655, 0xd9c12a5938337c0a
d_3_24:         .dword 0x519be8b55076a9d1, 0x2ef81a1d797e332f
d_3_25:         .dword 0xb77bb23a1be5b784, 0xb45fcf8c81b277d8
d_3_26:         .dword 0x63af723775ad5984, 0x3dea7f7540e43db3
d_3_27:         .dword 0xb59dd5b6790e0b33, 0x4c4a4908dcdb9373
                .dword 0xeac31323aa3e4ccc, 0x42a9efc73b1dd46a
                .dword 0xa38b27cfe78de2ed, 0x0f3ccbd30bb51e6c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x16ac28fa6e7b2b18, 0xf716ebb0f94dc1c1
                .dword 0x93187939c1141474, 0xaadce1340bd9650f
d_4_0:          .dword 0xcedea8d48f748cdb, 0x01ea107b07979883
d_4_1:          .dword 0x2d68aaf264d71179, 0x1117fe68f5b387a9
d_4_2:          .dword 0x3e60a9f727b229e0, 0x3d26cd28c3ebaa82
d_4_3:          .dword 0x8e29affdd091ba87, 0x4705c4c2484aaf7f
d_4_4:          .dword 0x081ac68effbb3013, 0xeae6e45d87c2f876
d_4_5:          .dword 0xbbef2a12269411cc, 0xec313451194c0dbb
d_4_6:          .dword 0xa183615cbd37c31d, 0x1b3813c938a3b227
d_4_7:          .dword 0x6a1dd0aa89587792, 0x69bccec0b64f2c20
d_4_8:          .dword 0x8a9f24cb5b5e7358, 0x9193e347c1f12aa2
d_4_9:          .dword 0xc6de222fee71cd9d, 0x9a69b124d7d5857c
d_4_10:         .dword 0x0cd0b8b432ca0624, 0x9885646be10f32d8
d_4_11:         .dword 0xff4e33fa539e151d, 0x8f349088c9786f9e
d_4_12:         .dword 0x925ea1b611d9941e, 0xdb34f84df0dc8912
d_4_13:         .dword 0xf60eae5eaeeba7fe, 0xbb719ec9b90ab561
d_4_14:         .dword 0x97f881cdb8894ff1, 0x1306983533aeac90
d_4_15:         .dword 0xd8ef2a602518672e, 0xff917e294eddf4ea
d_4_16:         .dword 0x5b4f15f26bfacb19, 0xbc24641f678d4333
d_4_17:         .dword 0xaf1ef5b67d30b1f9, 0x3ed90c7d28545186
d_4_18:         .dword 0x4cc0d450d75d9e0a, 0xbd96ff3428760f7a
d_4_19:         .dword 0xc8e35281640b5f60, 0xb7a6c948134c27fd
d_4_20:         .dword 0x5f69f93e73739f49, 0xde4be41391126ed6
d_4_21:         .dword 0x526e1c5b4bc7b94d, 0xa65298a93615bbe3
d_4_22:         .dword 0xfac346f1e8dbe8d9, 0x2a1fa558974e100b
d_4_23:         .dword 0xa11791687f2090f5, 0x89eb79f4548eed66
d_4_24:         .dword 0x2e622b44ab276d46, 0xa4fdaba08fd729b8
d_4_25:         .dword 0xf665321e8e86effc, 0x1e168575bf8f1cb5
d_4_26:         .dword 0x297bb49b28fc2a97, 0x62cb9339fe2f5a69
d_4_27:         .dword 0x4ac55f0c3946eda5, 0x0a7c59858f06427f
                .dword 0x26292b3b7a7ae5b0, 0x56163a281cc80285
                .dword 0x313f37da4e7184c9, 0x6a5a87e87e183b99
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x78e05351f6c9fbe0, 0x0d7a249367a5ac97
                .dword 0x6a5ec1004ae0f4ab, 0x8d02a384a36444d8
d_5_0:          .dword 0xa6fc31a757768e9f, 0x59df3ac24976333e
d_5_1:          .dword 0x7327c52b98bc6d72, 0x8ab27fccfe9ec224
d_5_2:          .dword 0xb4553d669ec4c56e, 0x316b60fb3e23501b
d_5_3:          .dword 0x1b89677149daca8b, 0x77a8ed8c174caa6d
d_5_4:          .dword 0xd18dfdd9a0f20c0d, 0x77a9f65e04c240c8
d_5_5:          .dword 0x87c48f7753273b44, 0x4be263423e273e5a
d_5_6:          .dword 0x1ee372d26b2ea054, 0x857e109e42cd8934
d_5_7:          .dword 0xcda3f8e24b69e503, 0xa5801a456f783fee
d_5_8:          .dword 0x4474abd75863d97e, 0x2a33a22ec0a1b385
d_5_9:          .dword 0x993bde378627b054, 0x758edfb0c5b9201e
d_5_10:         .dword 0xe841d84d25a958dd, 0x2c0fa4523ca646b6
d_5_11:         .dword 0xc1e220d2003f6a06, 0x7f6d91a612f0e219
d_5_12:         .dword 0x275d83dc33357c7d, 0xbe0b6317734da6ac
d_5_13:         .dword 0x7dca4ef13107c8a1, 0x4dd3fc4f7e2946d6
d_5_14:         .dword 0x845d953df2cc1733, 0x531d6a45f34788ba
d_5_15:         .dword 0xc586dd40f50d84bd, 0xdee6161add0ef11d
d_5_16:         .dword 0x4020ed1db00b65d1, 0x018af80c3710ba66
d_5_17:         .dword 0x1b1d8b129651874b, 0x4c64537e38c13997
d_5_18:         .dword 0xeef893913338155d, 0xec371eb3197a766e
d_5_19:         .dword 0x3401135bba00122e, 0xafb8159a0b19bc8b
d_5_20:         .dword 0x55a1944fbab98dd3, 0xdbe82ed2a3a19761
d_5_21:         .dword 0x582e39da5dbcdb43, 0x36732c14d86ede76
d_5_22:         .dword 0x5d8c78aba64fb3f1, 0xb04033ff1a2d36da
d_5_23:         .dword 0xd06faf71435bffd6, 0x9d075edf16dd40f6
d_5_24:         .dword 0x3f000694cdddaa69, 0xfa77971045f1eddb
d_5_25:         .dword 0xc7edab1026813642, 0x4c2aa890c0a35a4c
d_5_26:         .dword 0x9fa3df0fb8600ca7, 0x88b279f7b2833f04
d_5_27:         .dword 0xd08ebf2f12d51942, 0x0d6b1c3cdf288787
                .dword 0x6112d552786cb8d7, 0xb5a64fab8a405ec8
                .dword 0x630e2e10b412169e, 0xfa94842082811ce0
         /* Random data */
_end_data5:
              
 
