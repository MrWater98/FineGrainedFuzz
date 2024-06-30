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
_p0:    xor x12, x12, x12                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 24                         ;
        add x12, x12, x13                         ;
        csrrw x10, mcause, x12                    ;
_p1:    csrrwi x11, sscratch, 0                   ;
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
_s0:    la x30, d_4_7                             ;
        addi x30, x30, 4                          ;
        lr.w x14, (x30)                           ;
_s1:    xor x18, x18, x18                         ;
        csrrw x8, scause, x18                     ;
_s2:    subw x15, x25, x27                        ;
_s3:    fcvt.s.wu f3, x29, dyn                    ;
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
_l0:    rem x25, x10, x1                          ;
_l1:    fnmadd.s f31, f5, f5, f14, dyn            ;
_l2:    div x24, x28, x18                         ;
_l3:    fmv.x.w x9, f14                           ;
_l4:    la x29, _l15                                      ;
        lbu x13, 29(x29)                          ;
_l5:    la x31, d_2_23                            ;
        addi x31, x31, 28                         ;
        amoand.w x1, x27, (x31)                   ;
_l6:    la x14, d_2_16                            ;
        addi x14, x14, -24                        ;
        amomaxu.d x11, x30, (x14)                 ;
_l7:    sraiw x23, x23, 25                        ;
_l8:    la x14, d_0_23                            ;
        lw x10, -24(x14)                          ;
_l9:    srai x11, x22, 43                         ;
_l10:   blt x10, x16, _l118                       ;
_l11:   lui x16, 968991                           ;
_l12:   la x9, d_5_18                             ;
        addi x9, x9, 8                            ;
        lui x21, 0xffe00                          ;
        xor x9, x9, x21                           ;
        sc.w x2, x21, (x9)                        ;
_l13:   fmul.s f6, f5, f14, rmm                   ;
_l14:   la x30, d_3_22                            ;
        addi x30, x30, 0                          ;
        amoand.w x23, x11, (x30)                  ;
_l15:   fcvt.l.s x11, f3, rdn                     ;
_l16:   fmin.s f12, f15, f10                      ;
_l17:   la x4, d_0_26                             ;
        addi x4, x4, 24                           ;
        amoor.w x12, x22, (x4)                    ;
_l18:   fmul.s f12, f2, f31, rtz                  ;
_l19:   ecall                                     ;
_l20:   la x16, d_5_11                            ;
        sb x19, -27(x16)                          ;
_l21:   fdiv.s f10, f10, f2, rmm                  ;
_l22:   mulhu x4, x27, x23                        ;
_l23:   fle.s x30, f23, f12                       ;
_l24:   mulw x9, x15, x15                         ;
_l25:   addw x30, x30, x25                        ;
_l26:   fcvt.lu.s x26, f10, rne                   ;
_l27:   fmin.s f3, f6, f14                        ;
_l28:   addw x23, x29, x2                         ;
_l29:   fcvt.s.wu f14, x11, rup                   ;
_l30:   la x7, d_3_0                              ;
        addi x7, x7, -4                           ;
        amoor.w x6, x20, (x7)                     ;
_l31:   la x12, d_2_4                             ;
        sd x2, -16(x12)                           ;
_l32:   fmul.s f10, f9, f1, rne                   ;
_l33:   mulw x25, x9, x29                         ;
_l34:   la x1, d_0_13                             ;
        addi x1, x1, -24                          ;
        amomaxu.w x16, x4, (x1)                   ;
_l35:   la x25, d_4_3                             ;
        addi x25, x25, -4                         ;
        amomaxu.w x10, x15, (x25)                 ;
_l36:   fcvt.s.l f28, x1, dyn                     ;
_l37:   remu x17, x12, x23                        ;
_l38:   sltiu x7, x18, -23                        ;
_l39:   la x11, d_0_15                            ;
        addi x11, x11, 12                         ;
        amomin.w x19, x17, (x11)                  ;
_l40:   rem x17, x25, x22                         ;
_l41:   la x2, d_3_9                              ;
        addi x2, x2, -0                           ;
        amomax.d x13, x14, (x2)                   ;
_l42:   srliw x5, x30, 23                         ;
_l43:   mul x2, x2, x2                            ;
_l44:   fnmsub.s f0, f15, f3, f19, rmm            ;
_l45:   la x3, d_0_3                              ;
        addi x3, x3, -8                           ;
        amoand.d x16, x16, (x3)                   ;
_l46:   la x25, d_5_18                            ;
        addi x25, x25, -8                         ;
        amoxor.w x5, x10, (x25)                   ;
_l47:   la x10, d_1_20                            ;
        addi x10, x10, 24                         ;
        amomaxu.d x20, x16, (x10)                 ;
_l48:   fcvt.s.w f26, x16, rtz                    ;
_l49:   addiw x12, x17, -1349                     ;
_l50:   la x24, d_1_23                            ;
        sd x11, -8(x24)                           ;
_l51:   la x20, _l121                                     ;
        jalr x15, 0(x20)                          ;
_l52:   la x18, d_5_26                            ;
        lbu x15, 0(x18)                           ;
_l53:   la x17, _l116                                     ;
        jalr x10, 0(x17)                          ;
_l54:   mulhu x16, x13, x4                        ;
_l55:   la x14, d_5_23                            ;
        addi x14, x14, 12                         ;
        amomax.w x9, x25, (x14)                   ;
_l56:   xor x17, x17, x17                         ;
        csrrs x4, mhartid, x17                    ;
_l57:   bltu x22, x17, _l167                               ;
_l58:   fmadd.s f28, f8, f11, f14, rdn            ;
_l59:   la x2, d_0_14                             ;
        addi x2, x2, -8                           ;
        amomaxu.w x13, x22, (x2)                  ;
_l60:   sllw x30, x6, x3                          ;
_l61:   addw x28, x3, x18                         ;
_l62:   la x17, d_2_18                            ;
        lui x8, 0xffe00                           ;
        xor x17, x17, x8                          ;
        sd x8, 0(x17)                             ;
_l63:   fcvt.wu.s x27, f12, dyn                   ;
_l64:   bgeu x9, x25, _l176                                ;
_l65:   fadd.s f26, f24, f0, rne                  ;
_l66:   div x11, x11, x27                         ;
_l67:   fsgnjx.s f30, f2, f5                      ;
_l68:   remuw x18, x3, x18                        ;
_l69:   fsqrt.s f15, f18, rne                     ;
_l70:   la x26, d_5_11                            ;
        sb x16, 4(x26)                            ;
_l71:   fmax.s f9, f9, f28                        ;
_l72:   la x1, d_4_24                             ;
        addi x1, x1, -24                          ;
        amoadd.d x12, x26, (x1)                   ;
_l73:   fsgnjn.s f20, f19, f5                     ;
_l74:   fle.s x22, f5, f19                        ;
_l75:   fsqrt.s f1, f10, rup                      ;
_l76:   la x6, d_4_4                              ;
        addi x6, x6, -8                           ;
        amoadd.d x6, x15, (x6)                    ;
_l77:   fcvt.wu.s x26, f31, rne                   ;
_l78:   la x16, d_5_7                             ;
        addi x16, x16, -16                        ;
        amoor.w x20, x6, (x16)                    ;
_l79:   fle.s x7, f17, f11                        ;
_l80:   mulhsu x2, x10, x6                        ;
_l81:   csrrwi x5, fcsr, 23                       ;
_l82:   csrrsi x20, pmpcfg0, 9                    ;
_l83:   fmin.s f29, f24, f19                      ;
_l84:   mulhsu x19, x3, x8                        ;
_l85:   srliw x15, x15, 31                        ;
_l86:   ori x19, x29, -1                          ;
_l87:   andi x10, x7, -7                          ;
_l88:   la x10, d_1_16                            ;
        addi x10, x10, -24                        ;
        amominu.d x17, x19, (x10)                 ;
_l89:   la x30, d_3_2                             ;
        flw f23, 0(x30)                           ;
_l90:   la x5, d_4_2                              ;
        fsw f10, 0(x5)                            ;
_l91:   subw x21, x4, x5                          ;
_l92:   la x22, d_2_27                            ;
        lb x1, 0(x22)                             ;
_l93:   bge x12, x9, _l141                                ;
_l94:   fmsub.s f17, f29, f11, f18, rne           ;
_l95:   fadd.s f28, f31, f16, rtz                 ;
_l96:   fence.i                                   ;
_l97:   mulh x16, x3, x15                         ;
_l98:   rem x1, x27, x6                           ;
_l99:   la x19, d_3_13                            ;
        addi x19, x19, -0                         ;
        amoor.d x6, x9, (x19)                     ;
_l100:  remuw x29, x23, x1                        ;
_l101:  fmadd.s f5, f19, f8, f19, rmm             ;
_l102:  la x1, d_1_22                             ;
        addi x1, x1, -8                           ;
        lui x8, 0xffe00                           ;
        xor x1, x1, x8                            ;
        amominu.d x17, x8, (x1)                   ;
_l103:  fsub.s f19, f17, f3, dyn                  ;
_l104:  beq x22, x25, _l105                       ;
_l105:  fcvt.s.wu f3, x27, rne                    ;
_l106:  la x27, d_4_25                            ;
        sw x9, 20(x27)                            ;
_l107:  li x27, 1                                 ;
        la x20, pt1                               ;
        addi x20, x20, 0                          ;
        sfence.vma x27, x20                       ;
_l108:  mulhu x13, x22, x23                       ;
_l109:  la x27, d_1_3                             ;
        lbu x22, 8(x27)                           ;
_l110:  bge x10, x5, _l140                                ;
_l111:  fmadd.s f9, f10, f15, f28, rdn            ;
_l112:  div x18, x14, x20                         ;
_l113:  la x6, d_3_23                             ;
        addi x6, x6, -0                           ;
        lui x4, 0xffe00                           ;
        xor x6, x6, x4                            ;
        amoand.d x16, x4, (x6)                    ;
_l114:  remuw x16, x30, x23                       ;
_l115:  slli x26, x15, 42                         ;
_l116:  la x10, d_5_14                            ;
        addi x10, x10, -4                         ;
        amomin.w x26, x28, (x10)                  ;
_l117:  la x13, d_0_7                             ;
        addi x13, x13, -8                         ;
        amoswap.w x12, x1, (x13)                  ;
_l118:  la x4, d_3_20                             ;
        addi x4, x4, 8                            ;
        amoand.d x3, x13, (x4)                    ;
_l119:  la x29, d_5_8                             ;
        addi x29, x29, -0                         ;
        amomin.d x7, x7, (x29)                    ;
_l120:  slli x30, x3, 55                          ;
_l121:  la x19, d_1_9                             ;
        addi x19, x19, 4                          ;
        amoor.w x22, x15, (x19)                   ;
_l122:  ebreak                                    ;
_l123:  la x29, d_0_5                             ;
        addi x29, x29, 16                         ;
        lui x27, 0xffe00                          ;
        xor x29, x29, x27                         ;
        lr.d x24, (x29)                           ;
_l124:  la x30, d_2_19                            ;
        addi x30, x30, 0                          ;
        amomaxu.w x2, x13, (x30)                  ;
_l125:  fcvt.s.lu f9, x15, rne                    ;
_l126:  la x3, _l187                                      ;
        lwu x27, 0(x3)                            ;
_l127:  la x4, _l169                                      ;
        csrrw zero, uepc, x4                      ;
        uret                                      ;
_l128:  remw x30, x12, x2                         ;
_l129:  la x27, d_2_8                             ;
        lw x14, 0(x27)                            ;
_l130:  la x16, d_0_11                            ;
        sb x22, -31(x16)                          ;
_l131:  la x8, d_4_27                             ;
        lw x29, 20(x8)                            ;
_l132:  la x28, d_2_14                            ;
        addi x28, x28, -24                        ;
        amoadd.d x8, x26, (x28)                   ;
_l133:  srli x1, x5, 0                            ;
_l134:  divw x26, x3, x2                          ;
_l135:  fcvt.lu.s x13, f4, rdn                    ;
_l136:  mul x22, x0, x29                          ;
_l137:  sltiu x14, x25, 1237                      ;
_l138:  la x6, d_0_10                             ;
        sw x15, -12(x6)                           ;
_l139:  la x5, d_0_19                             ;
        addi x5, x5, -8                           ;
        amominu.d x1, x1, (x5)                    ;
_l140:  ori x7, x0, 0                             ;
_l141:  la x3, d_2_19                             ;
        addi x3, x3, 12                           ;
        lr.w x4, (x3)                             ;
_l142:  fle.s x15, f29, f26                       ;
_l143:  la x4, _l152                              ;
        jalr x24, 0(x4)                           ;
_l144:  fnmadd.s f26, f2, f20, f27, rtz           ;
_l145:  fcvt.w.s x27, f29, rtz                    ;
_l146:  la x27, d_4_15                            ;
        addi x27, x27, 8                          ;
        amominu.d x29, x17, (x27)                 ;
_l147:  la x2, _l52                               ;
        ld x2, -16(x2)                            ;
_l148:  la x11, d_5_27                            ;
        addi x11, x11, -0                         ;
        amoxor.w x30, x20, (x11)                  ;
_l149:  remu x21, x19, x15                        ;
_l150:  feq.s x2, f10, f18                        ;
_l151:  andi x12, x28, 30                         ;
_l152:  divw x16, x4, x21                         ;
_l153:  fmadd.s f28, f16, f23, f15, rne           ;
_l154:  la x3, d_4_20                             ;
        lbu x4, 18(x3)                            ;
_l155:  la x8, d_5_21                             ;
        srai x8, x8, 1                            ;
        csrrc x5, pmpaddr5, x8                    ;
_l156:  fmsub.s f29, f22, f13, f7, rup            ;
_l157:  fmin.s f14, f19, f21                      ;
_l158:  mul x0, x17, x24                          ;
_l159:  bgeu x5, x21, _l185                               ;
_l160:  xori x29, x20, 0                          ;
_l161:  slti x22, x29, -734                       ;
_l162:  la x16, d_1_3                             ;
        lb x13, 17(x16)                           ;
_l163:  la x3, d_0_19                             ;
        addi x3, x3, 8                            ;
        amomax.d x13, x2, (x3)                    ;
_l164:  subw x2, x21, x28                         ;
_l165:  fcvt.s.w f20, x23, rdn                    ;
_l166:  flt.s x16, f22, f28                       ;
_l167:  sllw x5, x19, x28                         ;
_l168:  fcvt.l.s x24, f4, rtz                     ;
_l169:  addi x21, x19, -2047                      ;
_l170:  addiw x29, x0, -89                        ;
_l171:  la x13, d_4_24                            ;
        sd x13, -8(x13)                           ;
_l172:  fcvt.l.s x30, f23, dyn                    ;
_l173:  bne x7, x2, _l174                                 ;
_l174:  csrrwi x3, mstatus, 14                    ;
_l175:  la x13, d_5_5                             ;
        lb x27, -0(x13)                           ;
_l176:  la x14, d_4_5                             ;
        addi x14, x14, 0                          ;
        amoand.d x12, x8, (x14)                   ;
_l177:  fmul.s f10, f7, f20, rtz                  ;
_l178:  addiw x6, x11, -369                       ;
_l179:  jal x8, _l184                                     ;
_l180:  mul x1, x23, x15                          ;
_l181:  la x10, _l187                                     ;
        flw f0, -0(x10)                           ;
_l182:  fcvt.s.l f21, x2, rtz                     ;
_l183:  subw x13, x25, x2                         ;
_l184:  addw x4, x4, x6                           ;
_l185:  la x20, d_3_18                            ;
        addi x20, x20, 0                          ;
        lr.w x15, (x20)                           ;
_l186:  beq x28, x15, _l188                       ;
_l187:  la x1, d_0_19                             ;
        addi x1, x1, -12                          ;
        amoand.w x18, x25, (x1)                   ;
_l188:;
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
                .dword 0x80615de59e4adb81, 0xd6a22ff258d2ee10
                .dword 0x76123cf9fbf216d6, 0x18270494035fb7e3
d_0_0:          .dword 0x1ce488bf8ff551a9, 0x3dd037a1acda6ffb
d_0_1:          .dword 0xe87b168811066e1b, 0x7c3e13040cda6077
d_0_2:          .dword 0x070ebfbb7c1e3769, 0x3414a84b75333aaf
d_0_3:          .dword 0x7543a517a6a3de64, 0x245104afae818cee
d_0_4:          .dword 0xfd10660a6fb3bcfa, 0x59375886fdcd7e16
d_0_5:          .dword 0x7367ff988a252a91, 0x9d17d0335ee3f684
d_0_6:          .dword 0x7c352bb77904ff9c, 0xe18fccd4cd462cab
d_0_7:          .dword 0x61c7bca888bf2d77, 0x154e8ad9e4a2ea9d
d_0_8:          .dword 0x2d8052836976cf1e, 0x19b7a42a57341126
d_0_9:          .dword 0x1ca99f422d205f63, 0xfa238e9d87bf53d0
d_0_10:         .dword 0x028e25c130fa5b6c, 0xeaaeb412ae014ed8
d_0_11:         .dword 0xacb4f291bcb7603c, 0xc073a6308d2923aa
d_0_12:         .dword 0x33d4c2e5767386e9, 0x90e42bd4b8720d49
d_0_13:         .dword 0x70f2cef4d2e7116c, 0xc867e1ed30cb5def
d_0_14:         .dword 0x98dcb795d3b6826e, 0x0992fc434040eb31
d_0_15:         .dword 0xf1a5bf2a17b19c58, 0xf4401ce41763a36e
d_0_16:         .dword 0x6b756870f064d191, 0x7c908081c78641fa
d_0_17:         .dword 0x44b09a076a13b5c0, 0xb82606e17867dccd
d_0_18:         .dword 0xd43d4c34fce6546b, 0x28a01264002f3252
d_0_19:         .dword 0x1d0effcc47f6d112, 0x2ee88712a2c827cd
d_0_20:         .dword 0x2d4219eed955cb23, 0xb6e458417e6ec6fc
d_0_21:         .dword 0xa89c2a875d27fc0f, 0x1d98c671e27cdf8d
d_0_22:         .dword 0xcb3f5298023f6e3a, 0x01cbc9f526e9a476
d_0_23:         .dword 0xd24b34a5842cc2ae, 0xff1a245e34e558ed
d_0_24:         .dword 0xc0430673b666ffe2, 0x5f6d78bb05113f28
d_0_25:         .dword 0xae82c881a37e1651, 0x805da77bc14c7f56
d_0_26:         .dword 0x7d8ba20146832515, 0x9d8306c661c39a0d
d_0_27:         .dword 0xc9c824b2ab1faa51, 0x9f57c5be0a1be51f
                .dword 0x1728e09e4ad344a0, 0xdac94fd7fb872957
                .dword 0xb75e674157259eec, 0x33a484601ae11759
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x77b651bc8dda4cf5, 0x4814c04264f2f994
                .dword 0x14dc199d4f1d4a69, 0xc536003ab2073259
d_1_0:          .dword 0x8ed102ed1d5d9c37, 0x4e4e858ae5d180db
d_1_1:          .dword 0x3f1312f45c9a5e3c, 0x131511a292ba1adf
d_1_2:          .dword 0xb3c17c82f99b1aed, 0x09f83607a383e515
d_1_3:          .dword 0xe650622a9c4de057, 0x0cb70514a8d3e1a5
d_1_4:          .dword 0x9712049a8f1689ad, 0x817a353f2e68aca5
d_1_5:          .dword 0x97eafb31d28f3990, 0xef6e0672733526c9
d_1_6:          .dword 0xae7e404cf188e66c, 0x8487e8f27f968ea8
d_1_7:          .dword 0xcd887ed659e62eab, 0xb64578ca5fd1e146
d_1_8:          .dword 0xfa0155e7b0111376, 0x762d793ed792f8ef
d_1_9:          .dword 0xa1b1c022eb227fbe, 0xc88e5a4c678392a8
d_1_10:         .dword 0x08cb88d1dad91cbc, 0xf90f28e5737e2fa7
d_1_11:         .dword 0xcaa1cff8d1df3c5a, 0xa145279e501e58e7
d_1_12:         .dword 0xd0939eb039281338, 0x8e45ef466a1a5b83
d_1_13:         .dword 0x9a9295251af4f93e, 0xe4f6fe22bda0778b
d_1_14:         .dword 0x2520a0ac525dcc83, 0x9814b0a48a781f79
d_1_15:         .dword 0x5134d7cc740418d7, 0x2c4cd41e5496fe63
d_1_16:         .dword 0xe2533f03fe2523bc, 0x0bc8bde87fb2ee63
d_1_17:         .dword 0x2baca084bf422328, 0xcb0d4500f5ef6b12
d_1_18:         .dword 0xf41f2eb28a4b0462, 0x54dd9e6861a2582d
d_1_19:         .dword 0x2cca8c19bbd11285, 0xe71c3eb7b655862d
d_1_20:         .dword 0x76031a4897cacd37, 0xcda09b29d94ee8c7
d_1_21:         .dword 0x0499485dbeec3e47, 0xcd4863a5e98030fd
d_1_22:         .dword 0xda8db72153e2a037, 0x4174555b22a8224a
d_1_23:         .dword 0x4d6b70e076c11e7e, 0x9cf8134ee12bd6d1
d_1_24:         .dword 0x7638fda661ff11f4, 0xbe6b3a0f23729955
d_1_25:         .dword 0xf48512c513dca8d3, 0x1f85f56608f2c4cb
d_1_26:         .dword 0xe7e8921ebb48a508, 0x7480eb4ed8b8ddda
d_1_27:         .dword 0x71cdce54f530fe41, 0x6625bd40844869b2
                .dword 0x4a5d06862ca72900, 0xdef2d3a5c696563f
                .dword 0x1c27852b510038ba, 0xdbb85631576944ca
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x0c4d916188ff7f6c, 0x9a6866f581cd4873
                .dword 0x24e80ec80ff3eeb2, 0xb2bb9a66c4048044
d_2_0:          .dword 0x6490d794bcb87664, 0xc05dc0711c76f590
d_2_1:          .dword 0x4d2da57a82d6fada, 0x22379699ffa962c8
d_2_2:          .dword 0x96198152b4a00f1f, 0x378f5ca80f15827e
d_2_3:          .dword 0x1de8074b36a0d55a, 0xc057e81a24fe9674
d_2_4:          .dword 0xc55bc2479b1e51ac, 0x28735f42d25172aa
d_2_5:          .dword 0x120db2774a219762, 0x77b839acb4baa572
d_2_6:          .dword 0x2975eca79d31b538, 0x750b526dfdaa14d6
d_2_7:          .dword 0xb7b0d325ab2b2ae6, 0xde1527ea92086f8c
d_2_8:          .dword 0x3e8d163f9e337915, 0x2d172532004acbb5
d_2_9:          .dword 0x7f40e0d9b4d4a808, 0x4f03aa06355a3bb0
d_2_10:         .dword 0x8cfe9a1dcdc07e83, 0xf955f112b350508d
d_2_11:         .dword 0x7e7cb79000d38de4, 0x9da603203b241717
d_2_12:         .dword 0x0382a0a77b1f7e2f, 0x2855210df355a10d
d_2_13:         .dword 0x718569295f11450c, 0x0bb03c05a88aa2f1
d_2_14:         .dword 0x934fc67b081e2f6d, 0xa6c9a0861578480f
d_2_15:         .dword 0x98dce7193fd0fd6f, 0x29f73edbacd7b9ac
d_2_16:         .dword 0xaa6d11f83a0a0dbd, 0x492c70cacd7ec8c3
d_2_17:         .dword 0x71d18d654650aff1, 0x4c653bb28538641a
d_2_18:         .dword 0xd50e2e791cc37ff3, 0xa1adb2fab44ca769
d_2_19:         .dword 0x4bfc9d10dd1df63f, 0x95049733fd516d89
d_2_20:         .dword 0xce5fa5cf6dc36c01, 0x9f2d30f830c36df1
d_2_21:         .dword 0x31f8fba8136f4ff0, 0x1605078074eb04b6
d_2_22:         .dword 0xc9f05388653f1a6d, 0xa9d85864c144c478
d_2_23:         .dword 0x8d41ab7eb7c2334c, 0x13f833ed53d2201c
d_2_24:         .dword 0x0b6f3ee5b88268b3, 0xf192884cc68046bf
d_2_25:         .dword 0x1a084add31e79647, 0xbf2350228ffc440a
d_2_26:         .dword 0x80f919da82288bdb, 0x200d825e4681388e
d_2_27:         .dword 0x2ffc957cbf2866a2, 0x1330f825c198b2eb
                .dword 0xac4681e172e7edcf, 0x1351d052d1e24cbe
                .dword 0x310f9335b1f4b508, 0xda77305d9c8a5645
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x53698f52637f4b63, 0x688ff3f90a45a329
                .dword 0x0b7413290b289630, 0x9fca342aa46dc632
d_3_0:          .dword 0xa32f53d9473639ec, 0x486b593a32ae7527
d_3_1:          .dword 0x2b94ff6d1c5ff320, 0x4b73bd4ea60c85bd
d_3_2:          .dword 0x48c95cad5fcc90d0, 0x6cf4515d9415d137
d_3_3:          .dword 0x170cffea44804c23, 0xb9286145bbc30516
d_3_4:          .dword 0x4217cbf1433c6fa2, 0x8dbf0994490dc0cc
d_3_5:          .dword 0xe71737b652fca3a0, 0x7c4adddbd3e4da0d
d_3_6:          .dword 0x4ef921bc3ee5e196, 0x78f366d389bea369
d_3_7:          .dword 0xb9bf3a236517ff30, 0x905a669de5ae2cf3
d_3_8:          .dword 0xa46e4750a5302110, 0x3cc7a0dfcdc465c7
d_3_9:          .dword 0xf14fa8fad8949efb, 0xd63a65810e121d96
d_3_10:         .dword 0x21a043c1b482d253, 0x787f009740c85bef
d_3_11:         .dword 0xf27cb6881b728cb5, 0xa830b8983be9f89d
d_3_12:         .dword 0xb4d17443cfefd532, 0x248963c454cfa381
d_3_13:         .dword 0x3c7a26e5ec7fccdf, 0xe0da6efd6eb58c0f
d_3_14:         .dword 0x67799ae2341aeec4, 0x6ddb7b3ee0a59119
d_3_15:         .dword 0xb86b1a9dfa36c9e7, 0xc851c77c7a0f04da
d_3_16:         .dword 0x94a5fa6cae4d8656, 0x1588ce5c144a4c17
d_3_17:         .dword 0xd539db68ab598129, 0xccca2be136b8f1e6
d_3_18:         .dword 0x762d5f414c2b5600, 0xa7106f38e0d91e11
d_3_19:         .dword 0x912d4d1465613b56, 0x7fe3887579bad5a5
d_3_20:         .dword 0x58aa76eeaad70062, 0x637e55fa6ef2386b
d_3_21:         .dword 0xd900f1584668a6ac, 0x196461a9f9328759
d_3_22:         .dword 0x58e672fbcc4903d7, 0x9bd44a386703524f
d_3_23:         .dword 0x8a8663bdbd0a57ca, 0x4c4f4dbedba44ad5
d_3_24:         .dword 0x31932f4f1a0dd1e1, 0x2037abe5f3def636
d_3_25:         .dword 0x91eddf3e16f87ef8, 0x1e9ad84f4a129c5b
d_3_26:         .dword 0x548e431f7c0d87d5, 0x07d10955b9958676
d_3_27:         .dword 0xb76273a18e9f6ed7, 0x36097faf734ee036
                .dword 0xeec1ed6ee177d868, 0xa9fd1089189d0792
                .dword 0xd7cd95410a3f0109, 0x5ca6baabdfd2e7a0
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x41253f1bd5cec8f1, 0x8fd82f6b6b731fba
                .dword 0xa23dc18d51ae4527, 0xeb47b3820260fdf4
d_4_0:          .dword 0x9e0b1a6f1b26d885, 0x742a575867107d01
d_4_1:          .dword 0x0036f98c9f7a51cc, 0x206ad6a619c973c9
d_4_2:          .dword 0x880bf00b4dc6a4e2, 0x7f230977b75fe0dc
d_4_3:          .dword 0xa81e396f7ed22d0e, 0x36db691b75971052
d_4_4:          .dword 0xa969c70394235ddb, 0xe98bf6b6e93329be
d_4_5:          .dword 0xf89629758416951e, 0x3d8c5d4a3fc4211d
d_4_6:          .dword 0x084093d56f032efc, 0x5a0389d8e4487093
d_4_7:          .dword 0xa913dd985ff6199d, 0x7109fd5627acf22b
d_4_8:          .dword 0x11e5ff03e21b841a, 0x44bbc6c4150f321d
d_4_9:          .dword 0x0797e305fcc43664, 0x50012b2276dc922f
d_4_10:         .dword 0xbb6332228e6721b8, 0xeb28cc97bcc9a330
d_4_11:         .dword 0x2cf980aae1c2f6f9, 0x44826ea326dc6e57
d_4_12:         .dword 0x2fbf602dc045abba, 0x078730ea92675439
d_4_13:         .dword 0x5545ec368a8d315e, 0xe8647358d66c43b7
d_4_14:         .dword 0xf5b1172edd619ecf, 0xce5db371dd85f53f
d_4_15:         .dword 0x252ab209dc9c5fc5, 0x0b84f0f5920018a6
d_4_16:         .dword 0xf658ff1c1803bbdc, 0x890b32859beb7f44
d_4_17:         .dword 0x029a140b2ab99a19, 0x5e581c2db2843fa0
d_4_18:         .dword 0x163b45623be1e91b, 0x5523af791f6b9b11
d_4_19:         .dword 0x2049c1603d96082b, 0x5fa3ece6a5d2837b
d_4_20:         .dword 0x257f8bd1575bb3e7, 0xeec7850eb844cae0
d_4_21:         .dword 0x0b10ad783b4af9e2, 0x98ec9c57c6995734
d_4_22:         .dword 0xf4c7266f53568b7e, 0x27a90e493e9fd1e4
d_4_23:         .dword 0x1ba117ced6965b82, 0xdf370150b3105178
d_4_24:         .dword 0x9c1fb5d579c3c6ad, 0xc55e51f25395baa8
d_4_25:         .dword 0x2500df5269dadeb5, 0x687c332c4038cde1
d_4_26:         .dword 0x8eb9e0ed9f953c63, 0x6ccbb6baa31d3570
d_4_27:         .dword 0xa69fa1236d63ef6e, 0xa0827caff402b111
                .dword 0x636c5c51c1b036e5, 0xf3ce0cd15cb551a0
                .dword 0x5038a798ab6ad127, 0x9ddc284618da2322
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf95a3f3c19751bfa, 0xb4b15408d0ac7be8
                .dword 0x2ed180fe64f04699, 0x56d0329bef8c0ed3
d_5_0:          .dword 0xdec780bb87b465f2, 0x2121b97a8236e76f
d_5_1:          .dword 0xb3966d5f57ed28c4, 0xfd49a8af86e14412
d_5_2:          .dword 0xb10ff8ec9bbd6ecd, 0x5fbce2bd189a9137
d_5_3:          .dword 0xd367cafa5017a9bf, 0xda538404438c69f2
d_5_4:          .dword 0xe7e278b8eb070c0f, 0x3589bc91e939d8e6
d_5_5:          .dword 0x5fc95471126d91bb, 0x2b35278900d96221
d_5_6:          .dword 0xbafea95eb54e4a99, 0x1e0a0b38688726ff
d_5_7:          .dword 0xb790099ae9f7ca0e, 0x45af8fdbf1672d68
d_5_8:          .dword 0xe790c95833472c26, 0xbc85e27fcfdad666
d_5_9:          .dword 0x780d458b72e4b4e8, 0x93e71984801d16ad
d_5_10:         .dword 0x6269983fefba811c, 0xf56425f7fc48a800
d_5_11:         .dword 0xac8f72e5c723057e, 0xe16ae612519447bc
d_5_12:         .dword 0x87260517b4ad233e, 0x852044343b256b9c
d_5_13:         .dword 0x10eec291bddf450e, 0x631588697bb15017
d_5_14:         .dword 0xde0b380ba1f3fc32, 0xdbd1e9902040d08f
d_5_15:         .dword 0xcbd00e41b6b218fa, 0x8851e2ffa3f3e830
d_5_16:         .dword 0xcae6c3cb8621910f, 0xd63f7b168871efe1
d_5_17:         .dword 0x2c6cc85308fba652, 0xe3688eee7f8bd67f
d_5_18:         .dword 0x7eff6226d4d9e59c, 0xc88c70e1493e55db
d_5_19:         .dword 0x8cd1e785f03bb611, 0x39588c1abc08f6cf
d_5_20:         .dword 0x0a693c105f6fcec6, 0x566fa039a0ea0827
d_5_21:         .dword 0xc9099f2076495b30, 0x683f14f3dd73656c
d_5_22:         .dword 0xec44b11bcd30524b, 0xb07eb9b62b42115a
d_5_23:         .dword 0x4063a274d3d7589d, 0xc5d2864449abdbdb
d_5_24:         .dword 0x7577574688cb40ab, 0x251025bb44dd8af7
d_5_25:         .dword 0x34a4906f93e321e5, 0x14d18463207ff63e
d_5_26:         .dword 0x5e6874221111561f, 0x6ffa5a8da80b8119
d_5_27:         .dword 0x04460947783466d9, 0xa46003241389fe57
                .dword 0x8365f7940f22bd66, 0xc7af4d9029332b08
                .dword 0x7978c121c54e47da, 0x3b499cb5815f1e25
         /* Random data */
_end_data5:
              
 
