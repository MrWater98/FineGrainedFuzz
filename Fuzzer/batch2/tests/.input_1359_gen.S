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
_p0:    csrrwi x12, sscratch, 17                  ;
_p1:    xor x13, x13, x13                         ;
        csrrs x11, sie, x13                       ;
_p2:    xor x14, x14, x14                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 14                         ;
        add x14, x14, x13                         ;
        csrrc x11, mtval, x14                     ;
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
_s0:    la x17, d_2_18                            ;
        addi x17, x17, 24                         ;
        amoxor.d x15, x8, (x17)                   ;
_s1:    fcvt.w.s x28, f17, rdn                    ;
_s2:    fcvt.wu.s x23, f11, dyn                   ;
_s3:    la x22, d_1_27                            ;
        sd x12, -0(x22)                           ;
_s4:    la x24, d_3_20                            ;
        sw x29, 24(x24)                           ;
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
_l0:    la x17, d_4_26                            ;
        addi x17, x17, 0                          ;
        sc.w x14, x14, (x17)                      ;
_l1:    addiw x10, x21, 3                         ;
_l2:    fnmadd.s f10, f10, f10, f10, rup          ;
_l3:    xori x21, x25, 2026                       ;
_l4:    la x14, d_4_2                             ;
        ld x16, -16(x14)                          ;
_l5:    srliw x1, x3, 0                           ;
_l6:    fsgnjn.s f9, f31, f30                     ;
_l7:    ecall                                     ;
_l8:    fnmadd.s f19, f11, f7, f30, rup           ;
_l9:    div x16, x5, x2                           ;
_l10:   slliw x21, x13, 10                        ;
_l11:   mulhu x10, x12, x4                        ;
_l12:   srliw x1, x1, 27                          ;
_l13:   fmax.s f15, f10, f15                      ;
_l14:   fnmsub.s f31, f29, f7, f8, rmm            ;
_l15:   fmul.s f8, f30, f7, dyn                   ;
_l16:   la x10, d_0_11                            ;
        sh x18, -20(x10)                          ;
_l17:   sllw x8, x25, x21                         ;
_l18:   fmin.s f21, f16, f0                       ;
_l19:   la x14, d_0_25                            ;
        addi x14, x14, 24                         ;
        amomin.d x25, x10, (x14)                  ;
_l20:   mul x5, x1, x19                           ;
_l21:   fmv.w.x f10, x8                           ;
_l22:   addi x21, x10, 27                         ;
_l23:   flt.s x8, f12, f22                        ;
_l24:   fmax.s f25, f16, f6                       ;
_l25:   sllw x27, x30, x1                         ;
_l26:   divuw x12, x28, x14                       ;
_l27:   slli x16, x10, 63                         ;
_l28:   la x22, _l181                             ;
        csrrw zero, sepc, x22                     ;
        sret                                      ;
_l29:   subw x18, x5, x20                         ;
_l30:   bge x6, x26, _l80                         ;
_l31:   la x15, d_4_17                            ;
        lwu x2, 20(x15)                           ;
_l32:   la x10, d_0_27                            ;
        lb x6, 31(x10)                            ;
_l33:   fsgnjx.s f24, f28, f29                    ;
_l34:   ebreak                                    ;
_l35:   flt.s x11, f19, f25                       ;
_l36:   la x19, d_3_16                            ;
        addi x19, x19, 0                          ;
        amoadd.d x22, x28, (x19)                  ;
_l37:   divu x12, x28, x20                        ;
_l38:   csrrsi x23, fcsr, 27                      ;
_l39:   remw x13, x6, x6                          ;
_l40:   xori x27, x4, -2047                       ;
_l41:   andi x1, x9, -31                          ;
_l42:   la x26, _l123                             ;
        csrrw zero, sepc, x26                     ;
        sret                                      ;
_l43:   la x17, d_3_6                             ;
        lb x17, 31(x17)                           ;
_l44:   la x30, d_1_26                            ;
        sd x25, 8(x30)                            ;
_l45:   slliw x9, x14, 22                         ;
_l46:   la x2, d_1_6                              ;
        addi x2, x2, 8                            ;
        amoswap.d x6, x12, (x2)                   ;
_l47:   la x12, d_1_0                             ;
        sw x22, 4(x12)                            ;
_l48:   fnmsub.s f9, f0, f21, f26, dyn            ;
_l49:   fcvt.l.s x22, f6, rmm                     ;
_l50:   fdiv.s f11, f15, f31, rup                 ;
_l51:   la x8, d_0_26                             ;
        addi x8, x8, -16                          ;
        amoor.d x25, x15, (x8)                    ;
_l52:   la x28, d_3_22                            ;
        addi x28, x28, -28                        ;
        amoand.w x28, x24, (x28)                  ;
_l53:   slti x28, x7, 22                          ;
_l54:   la x24, d_5_21                            ;
        addi x24, x24, -16                        ;
        lui x20, 0xffe00                          ;
        xor x24, x24, x20                         ;
        amomin.w x28, x20, (x24)                  ;
_l55:   la x4, d_0_17                             ;
        addi x4, x4, 0                            ;
        amoadd.w x5, x13, (x4)                    ;
_l56:   lui x30, 3                                ;
_l57:   la x19, d_4_19                            ;
        addi x19, x19, -8                         ;
        amomin.d x4, x1, (x19)                    ;
_l58:   rem x23, x3, x9                           ;
_l59:   fnmadd.s f31, f15, f18, f20, rtz          ;
_l60:   la x26, d_4_8                             ;
        lhu x14, -28(x26)                         ;
_l61:   sllw x15, x25, x7                         ;
_l62:   rem x11, x6, x9                           ;
_l63:   ori x13, x12, -2047                       ;
_l64:   fsgnjx.s f31, f15, f9                     ;
_l65:   la x17, d_0_15                            ;
        addi x17, x17, 20                         ;
        amominu.w x15, x28, (x17)                 ;
_l66:   la x7, d_3_11                             ;
        addi x7, x7, 16                           ;
        lui x25, 0xffe00                          ;
        xor x7, x7, x25                           ;
        amoxor.d x19, x25, (x7)                   ;
_l67:   la x4, d_0_19                             ;
        addi x4, x4, 0                            ;
        amoxor.d x9, x30, (x4)                    ;
_l68:   csrrsi x5, fflags, 15                     ;
_l69:   fence.i                                   ;
_l70:   la x15, d_4_14                            ;
        addi x15, x15, 16                         ;
        lr.w x14, (x15)                           ;
_l71:   la x3, _l155                              ;
        srai x3, x3, 1                            ;
        csrrw x7, pmpaddr2, x3                    ;
_l72:   la x21, d_2_7                             ;
        addi x21, x21, -0                         ;
        amoswap.w x11, x5, (x21)                  ;
_l73:   ebreak                                    ;
_l74:   xori x26, x14, 0                          ;
_l75:   ori x19, x28, 1737                        ;
_l76:   fcvt.s.wu f22, x9, rdn                    ;
_l77:   jal x11, _l80                             ;
_l78:   la x28, _l125                             ;
        csrrw zero, sepc, x28                     ;
        sret                                      ;
_l79:   la x20, d_5_5                             ;
        addi x20, x20, -28                        ;
        amomax.w x15, x28, (x20)                  ;
_l80:   la x20, d_2_11                            ;
        addi x20, x20, -4                         ;
        amominu.w x22, x11, (x20)                 ;
_l81:   fnmadd.s f10, f23, f12, f16, rdn          ;
_l82:   la x28, d_2_3                             ;
        addi x28, x28, -12                        ;
        amoor.w x4, x14, (x28)                    ;
_l83:   ori x20, x1, -200                         ;
_l84:   la x17, d_4_27                            ;
        fsw f17, -0(x17)                          ;
_l85:   csrrsi x15, fcsr, 23                      ;
_l86:   subw x20, x23, x26                        ;
_l87:   la x17, d_0_11                            ;
        ld x26, -8(x17)                           ;
_l88:   mul x17, x15, x9                          ;
_l89:   fsgnjn.s f21, f13, f8                     ;
_l90:   la x24, d_1_24                            ;
        lui x28, 0xffe00                          ;
        xor x24, x24, x28                         ;
        lw x11, 24(x24)                           ;
_l91:   srliw x3, x13, 11                         ;
_l92:   fcvt.w.s x23, f6, rdn                     ;
_l93:   fsgnjx.s f11, f20, f12                    ;
_l94:   jal x30, _l148                            ;
_l95:   fcvt.s.wu f31, x14, dyn                   ;
_l96:   fsgnjn.s f18, f7, f9                      ;
_l97:   fmax.s f14, f7, f27                       ;
_l98:   slliw x8, x0, 0                           ;
_l99:   fcvt.s.wu f28, x28, rmm                   ;
_l100:  fence.i                                   ;
_l101:  addiw x9, x28, 2047                       ;
_l102:  bltu x5, x21, _l153                       ;
_l103:  fmadd.s f4, f0, f24, f27, rdn             ;
_l104:  fsub.s f27, f16, f8, rdn                  ;
_l105:  la x7, d_1_22                             ;
        ld x26, -16(x7)                           ;
_l106:  fsgnj.s f21, f10, f14                     ;
_l107:  la x13, d_2_25                            ;
        addi x13, x13, 0                          ;
        amoxor.d x6, x3, (x13)                    ;
_l108:  remw x21, x20, x8                         ;
_l109:  rem x12, x25, x2                          ;
_l110:  divw x24, x22, x6                         ;
_l111:  la x10, d_4_0                             ;
        addi x10, x10, -28                        ;
        amoand.w x23, x14, (x10)                  ;
_l112:  la x10, d_2_27                            ;
        addi x10, x10, -8                         ;
        amoor.d x23, x4, (x10)                    ;
_l113:  la x25, d_4_14                            ;
        addi x25, x25, -24                        ;
        amoxor.d x7, x23, (x25)                   ;
_l114:  la x9, d_0_23                             ;
        addi x9, x9, -16                          ;
        amominu.d x20, x1, (x9)                   ;
_l115:  ebreak                                    ;
_l116:  sllw x15, x2, x16                         ;
_l117:  fmul.s f12, f13, f22, rtz                 ;
_l118:  la x25, d_5_12                            ;
        addi x25, x25, 0                          ;
        amomin.d x17, x8, (x25)                   ;
_l119:  la x18, d_2_26                            ;
        addi x18, x18, -20                        ;
        amoand.w x28, x12, (x18)                  ;
_l120:  ori x23, x24, 0                           ;
_l121:  la x2, d_5_25                             ;
        srai x2, x2, 1                            ;
        csrrw x28, pmpaddr5, x2                   ;
_l122:  mulw x3, x29, x27                         ;
_l123:  rem x19, x7, x29                          ;
_l124:  xor x20, x20, x20                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 9                          ;
        add x20, x20, x19                         ;
        csrrs x9, mip, x20                        ;
_l125:  la x24, d_4_21                            ;
        addi x24, x24, 12                         ;
        amoxor.w x3, x28, (x24)                   ;
_l126:  divw x3, x26, x24                         ;
_l127:  xor x21, x21, x21                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 17                         ;
        add x21, x21, x23                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 30                           ;
        add x21, x21, x1                          ;
        addi x29, zero, 1                         ;
        slli x29, x29, 8                          ;
        add x21, x21, x29                         ;
        csrrw x2, satp, x21                       ;
_l128:  fnmsub.s f26, f30, f6, f16, rdn           ;
_l129:  la x18, _l198                             ;
        lui x20, 0xffe00                          ;
        xor x18, x18, x20                         ;
        lhu x10, 8(x18)                           ;
_l130:  fsgnjn.s f9, f25, f20                     ;
_l131:  fnmadd.s f20, f16, f9, f30, dyn           ;
_l132:  la x10, d_1_17                            ;
        addi x10, x10, 0                          ;
        amoor.w x18, x24, (x10)                   ;
_l133:  andi x4, x15, -2047                       ;
_l134:  fmin.s f3, f8, f6                         ;
_l135:  la x9, d_0_17                             ;
        addi x9, x9, -0                           ;
        amoadd.d x20, x19, (x9)                   ;
_l136:  remuw x27, x20, x7                        ;
_l137:  divu x20, x28, x8                         ;
_l138:  sraiw x20, x20, 0                         ;
_l139:  mulw x21, x5, x6                          ;
_l140:  la x16, d_0_15                            ;
        addi x16, x16, 0                          ;
        amomin.w x24, x23, (x16)                  ;
_l141:  la x24, _l70                              ;
        lb x14, 0(x24)                            ;
_l142:  la x13, _l148                             ;
        csrrw zero, sepc, x13                     ;
        sret                                      ;
_l143:  bge x11, x4, _l163                        ;
_l144:  div x0, x28, x3                           ;
_l145:  la x16, d_1_9                             ;
        addi x16, x16, 8                          ;
        amomaxu.d x1, x28, (x16)                  ;
_l146:  fsub.s f22, f7, f11, rne                  ;
_l147:  la x24, d_2_15                            ;
        addi x24, x24, 8                          ;
        amoxor.w x9, x19, (x24)                   ;
_l148:  xori x8, x24, -691                        ;
_l149:  la x15, d_2_11                            ;
        addi x15, x15, -8                         ;
        lr.w x9, (x15)                            ;
_l150:  ecall                                     ;
_l151:  ecall                                     ;
_l152:  li x29, 0                                 ;
        la x2, pt3                                ;
        addi x2, x2, 24                           ;
        sfence.vma x29, x2                        ;
_l153:  bne x17, x26, _l190                       ;
_l154:  li x11, 0                                 ;
        la x8, pt1                                ;
        addi x8, x8, 16                           ;
        sfence.vma x11, x8                        ;
_l155:  la x26, d_0_21                            ;
        lw x26, 16(x26)                           ;
_l156:  la x6, d_5_0                              ;
        sh x20, -12(x6)                           ;
_l157:  lui x11, 176429                           ;
_l158:  fcvt.s.w f28, x10, rdn                    ;
_l159:  remu x25, x16, x4                         ;
_l160:  la x10, d_5_24                            ;
        addi x10, x10, 0                          ;
        amoadd.w x28, x20, (x10)                  ;
_l161:  la x24, d_5_9                             ;
        addi x24, x24, 8                          ;
        amominu.d x16, x28, (x24)                 ;
_l162:  la x20, d_3_27                            ;
        addi x20, x20, -4                         ;
        amoand.w x17, x16, (x20)                  ;
_l163:  la x22, d_4_7                             ;
        lbu x5, 12(x22)                           ;
_l164:  la x26, d_5_22                            ;
        addi x26, x26, 24                         ;
        sc.d x14, x26, (x26)                      ;
_l165:  addi x17, x30, -0                         ;
_l166:  la x4, d_5_14                             ;
        lb x20, 13(x4)                            ;
_l167:  jal x21, _l186                            ;
_l168:  la x6, d_3_18                             ;
        addi x6, x6, -0                           ;
        amoand.d x9, x8, (x6)                     ;
_l169:  flt.s x17, f13, f3                        ;
_l170:  fsqrt.s f18, f25, rtz                     ;
_l171:  xor x10, x10, x10                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 11                         ;
        add x10, x10, x10                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 15                         ;
        add x10, x10, x18                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 30                         ;
        add x10, x10, x20                         ;
        csrrc x23, mstatus, x10                   ;
_l172:  la x26, d_3_21                            ;
        ld x12, -8(x26)                           ;
_l173:  fmsub.s f22, f10, f17, f26, rne           ;
_l174:  divu x21, x0, x27                         ;
_l175:  slliw x16, x24, 6                         ;
_l176:  la x11, d_2_9                             ;
        addi x11, x11, 12                         ;
        lr.w x21, (x11)                           ;
_l177:  andi x14, x6, 352                         ;
_l178:  divu x14, x16, x21                        ;
_l179:  la x13, d_5_23                            ;
        addi x13, x13, -12                        ;
        amominu.w x3, x27, (x13)                  ;
_l180:  xor x15, x15, x15                         ;
        addi x1, zero, 3                          ;
        slli x1, x1, 15                           ;
        add x15, x15, x1                          ;
        csrrs x26, frm, x15                       ;
_l181:  la x30, d_1_2                             ;
        addi x30, x30, 16                         ;
        amoadd.d x25, x25, (x30)                  ;
_l182:  la x17, d_0_7                             ;
        addi x17, x17, 0                          ;
        amoor.w x9, x11, (x17)                    ;
_l183:  addw x18, x23, x7                         ;
_l184:  remuw x25, x24, x5                        ;
_l185:  la x27, d_1_8                             ;
        addi x27, x27, -24                        ;
        lui x19, 0xffe00                          ;
        xor x27, x27, x19                         ;
        amominu.w x17, x19, (x27)                 ;
_l186:  sllw x23, x11, x24                        ;
_l187:  beq x27, x15, _l188                       ;
_l188:  la x19, d_4_1                             ;
        addi x19, x19, 0                          ;
        amoadd.d x22, x5, (x19)                   ;
_l189:  la x13, _l168                             ;
        srai x13, x13, 1                          ;
        csrrs x14, pmpaddr6, x13                  ;
_l190:  sraw x23, x27, x23                        ;
_l191:  la x2, d_2_17                             ;
        addi x2, x2, -16                          ;
        lui x19, 0xffe00                          ;
        xor x2, x2, x19                           ;
        amomaxu.d x11, x19, (x2)                  ;
_l192:  la x8, d_3_23                             ;
        addi x8, x8, 0                            ;
        amomin.d x28, x5, (x8)                    ;
_l193:  mulhu x12, x23, x13                       ;
_l194:  fmul.s f24, f4, f26, rtz                  ;
_l195:  la x18, d_2_10                            ;
        sw x29, 8(x18)                            ;
_l196:  sraiw x14, x17, 9                         ;
_l197:  la x24, d_5_6                             ;
        addi x24, x24, 0                          ;
        lui x12, 0xffe00                          ;
        xor x24, x24, x12                         ;
        amoor.w x7, x12, (x24)                    ;
_l198:  sraw x4, x25, x3                          ;
_l199:  divw x10, x24, x23                        ;
_l200:;
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
                .dword 0x7309a1ec94e80bcb, 0xfa52180aa1ba3d86
                .dword 0x474466ad37a602c9, 0xb126ea66cb82cbc7
d_0_0:          .dword 0x9481e42aaf47cd72, 0x7eca809f17749b09
d_0_1:          .dword 0x2800e3867bf54b49, 0x455f1e5d7df89aa1
d_0_2:          .dword 0xada0715c536a1766, 0x3ea94522825fd14d
d_0_3:          .dword 0x5fb344803ae66747, 0x10ee536b7444f1c6
d_0_4:          .dword 0x77a0da7f26552676, 0x3d3f8c6befcfc15a
d_0_5:          .dword 0x7c12f3c620f3e033, 0xa551445996ae35ae
d_0_6:          .dword 0x247e09cb4cd06b47, 0xb683791634ec3824
d_0_7:          .dword 0x406290d65d5280e8, 0xbe935efbeed36d7b
d_0_8:          .dword 0x28afb794147cae9d, 0x830f6d5e6cefb4e9
d_0_9:          .dword 0x89e42a2c31e60e5f, 0x0a26d92b4aed140f
d_0_10:         .dword 0x957ad53dde0be9f8, 0xad97b202c89378d2
d_0_11:         .dword 0x5faec5aad1ab527d, 0x760488620d5b4613
d_0_12:         .dword 0x45165bcd9b38799d, 0xaaf7461082dbf723
d_0_13:         .dword 0x19d49b5e5c204bdb, 0xbcfe13f89d4537b1
d_0_14:         .dword 0xd2abc76ff7049024, 0x74be62aedff90074
d_0_15:         .dword 0x2ad05d50a0bfd699, 0xea1c90b55817d51c
d_0_16:         .dword 0x9c6f8da2d23725fa, 0xaa432466acbc08ed
d_0_17:         .dword 0xab4a96c2e02f93b8, 0x34701d6dd72a1444
d_0_18:         .dword 0x082049158781618d, 0xdd230221f1bfb938
d_0_19:         .dword 0x24d33a2e659677bd, 0x88880cbb8c213800
d_0_20:         .dword 0x0c94b864775b6081, 0x72da5269f52f2771
d_0_21:         .dword 0x8a35ba26e6cf4b16, 0x72011515072743f9
d_0_22:         .dword 0x845a55dcad891661, 0x543e5198aa13dec5
d_0_23:         .dword 0x621bf973d7f8fe24, 0xcb2ed4fee228434e
d_0_24:         .dword 0x38389b525f10775e, 0xd1bc1c4f08a2395c
d_0_25:         .dword 0x1f1785a6fd772480, 0xc89cebe6db5cedb4
d_0_26:         .dword 0x6d5cfcd80362960e, 0x3a241a916068205f
d_0_27:         .dword 0x0687a738c34c3b6b, 0xb5b9c16eb914d87f
                .dword 0x1b288cc4c2cfa065, 0xbe6f175cd1c60ce0
                .dword 0xe562fc4a503a7cbd, 0x9cb81ddac0f373c4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xafe7ed3f7e079e5d, 0xcee65c83e03d1c60
                .dword 0xec800b7f2ee1b0fd, 0x8e68369c5810fe1d
d_1_0:          .dword 0x51d12541d6aba829, 0xc35b1dad32171842
d_1_1:          .dword 0xa2dc81351d64926e, 0x18a92a1916dce163
d_1_2:          .dword 0x54bb86adca9bc5dd, 0xea63eec760192fae
d_1_3:          .dword 0x6c60b1bce34c42d7, 0x2dd41caa32d28cb5
d_1_4:          .dword 0x2a955856666193ba, 0x516cf471f2cb7e20
d_1_5:          .dword 0x385d525266db7596, 0xca5324ee748fca72
d_1_6:          .dword 0xa957313f6c712d55, 0x58ae336030e3c2cd
d_1_7:          .dword 0x0c8d6c2ab2bcb5c6, 0x76a651d966c032e9
d_1_8:          .dword 0xee532c0e0a5e9752, 0x0e9d7f88e1fd3b00
d_1_9:          .dword 0x66bdd75caceada0e, 0xe08086b8fdfd43d0
d_1_10:         .dword 0xd10d90b5d058b116, 0xaba15a75c28b9258
d_1_11:         .dword 0x056b2ef12f519599, 0x130bf8a222a647e4
d_1_12:         .dword 0x18d443e9afa3df65, 0x7080dc9381e47443
d_1_13:         .dword 0x0c3f19c25adad9a8, 0x989308e97aa3edb4
d_1_14:         .dword 0x85ea38b87788ac20, 0x2e206524251cd913
d_1_15:         .dword 0xdfa435c2cb19698f, 0x00123fb4d274789f
d_1_16:         .dword 0x47093acc6fd81015, 0x0697e8642f52db38
d_1_17:         .dword 0x8b86c831cf3f6b6c, 0xa8b4c5733e787581
d_1_18:         .dword 0xb790acf6d0bebea9, 0x1ac8768b17642cb3
d_1_19:         .dword 0x29f2dd882f772d02, 0xab4f84b7b45b5d71
d_1_20:         .dword 0xa98f5f462d6b24b5, 0x53945947b899f0f4
d_1_21:         .dword 0x489e32e974aa83d3, 0x8937c2f4507b3d4a
d_1_22:         .dword 0x843e37a1976c4c96, 0xff77e043381da683
d_1_23:         .dword 0x631cd7dbc8edc850, 0x088d629e0e24cbf7
d_1_24:         .dword 0xd857bba62667acd5, 0xd574f1cfd14b53fa
d_1_25:         .dword 0xfe0812d9cbc862e7, 0xaa001508f6e8f404
d_1_26:         .dword 0x08416f18dc8753b1, 0x321d36708f1c8c1d
d_1_27:         .dword 0xc4033bb3dcfc62dd, 0xb075bd47286d332a
                .dword 0x6f820f1a36c0439e, 0xa2bcc596696be5c8
                .dword 0x83223e0555f5de7c, 0x37ac8c2aa65740a4
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x7c2bf7ba2d1ff23a, 0x0f948bb520b83009
                .dword 0xbcea2f2885594281, 0x9e666ea84a71f73e
d_2_0:          .dword 0x2111bfe97c7c1141, 0x2e0bf71f5f7d977f
d_2_1:          .dword 0xc129b0899e6692ce, 0xb9ba8f9d62d153e4
d_2_2:          .dword 0x463b58ea7b62074b, 0x9a91d794cd8b3c66
d_2_3:          .dword 0x1f1dfe3620a6187e, 0x1adf2549cf54582a
d_2_4:          .dword 0x99b928364512485a, 0xeaa2680b928c7e8e
d_2_5:          .dword 0xb91a39a0ac99b3bf, 0xb6dedf8b1400ca2f
d_2_6:          .dword 0x523fce7e6af53e55, 0x527f72af95ff49d3
d_2_7:          .dword 0x2eced8a744ce36e4, 0xe43ea486b490a24f
d_2_8:          .dword 0x0eae300788fef9bc, 0x662a165de1eb61af
d_2_9:          .dword 0x2d3c45fc87bf49e5, 0xeefc7e9993e7db12
d_2_10:         .dword 0x33d3325a220980b8, 0x7a68a586adec5075
d_2_11:         .dword 0x43a35ed250bfcb8b, 0x7a3e001d1eb02ce7
d_2_12:         .dword 0x0d85e0ec4fe72f97, 0x2c52149cc9192320
d_2_13:         .dword 0xa894672b58498bbe, 0x4636e3311cf9e4f2
d_2_14:         .dword 0x30596b93d51a5565, 0xfe7b7b5bd5e20166
d_2_15:         .dword 0xa47f0cc825bed0b5, 0xda3768ce49289ab4
d_2_16:         .dword 0xdd9c44a9f720b1f9, 0xd7f2849758a1b91f
d_2_17:         .dword 0xe89b1f74ca67d22c, 0x7b3943d2ab54181c
d_2_18:         .dword 0xe5510b0cb8de4e96, 0x78bef623db635b8b
d_2_19:         .dword 0x65c9b35b2fd33d60, 0x7753417c5afd1bdf
d_2_20:         .dword 0xacf16e3d2f67b74d, 0xbacb5bad43bba90a
d_2_21:         .dword 0x9ec4c16000772492, 0x6afab92b0f0953c0
d_2_22:         .dword 0xa61afe72a468f4db, 0xafdb69780fc869a3
d_2_23:         .dword 0xf29bf3dcf4b93ca0, 0x0a1eeef0c14c1f5c
d_2_24:         .dword 0xd06ed2cba44cf66e, 0xb85f88519717df4e
d_2_25:         .dword 0xee9087ebaeaa6c27, 0x49565b999737c4ec
d_2_26:         .dword 0x42507396b131f528, 0x15ef9a1e296b618c
d_2_27:         .dword 0x4123be6b43023bc5, 0x643839bf26850fb3
                .dword 0x6c5f12acbd18ab1c, 0xfaf5687d2dfc9a50
                .dword 0xeca90094fc1be46d, 0x59b34b8831918370
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xf2024bb710bcac15, 0x12d5d9bca8f8f80e
                .dword 0x3093acec3afd1c82, 0x88b331a2fadaa25f
d_3_0:          .dword 0x78d43301eb524358, 0x613b5e97297d4e87
d_3_1:          .dword 0x6dc7884fac4de9a0, 0x1128f8f28c04e7f3
d_3_2:          .dword 0x372ee201b3b9e09f, 0xeee6442d7c740369
d_3_3:          .dword 0xc058eaf4c112dc41, 0x06a519d6b3a71af5
d_3_4:          .dword 0x3a643af81b69baec, 0x79ddff68c4f1d520
d_3_5:          .dword 0x1a6f1061c5c9fb8a, 0x0c8fdc6739965c0b
d_3_6:          .dword 0x3f306b817a678be1, 0x01f9dac1203b1048
d_3_7:          .dword 0x944296f39ea81834, 0x7365046a9834063e
d_3_8:          .dword 0xfae62dc6d5d78bf9, 0xdd9a02e6df56bc8d
d_3_9:          .dword 0xa4c1f575b74cc268, 0x5ab3f670fb691fce
d_3_10:         .dword 0xcde8122eb71a0c39, 0x14bc4683c593cc31
d_3_11:         .dword 0x79e66cd2a9e22f05, 0x721dc7493abe4633
d_3_12:         .dword 0xcc851247955cd2a5, 0xfe310e489b7ed285
d_3_13:         .dword 0x66dc72529397244d, 0xf27ca277cf7d14f1
d_3_14:         .dword 0x7341ba00c19ddbb9, 0xb07f848f8c893a39
d_3_15:         .dword 0x4612015f0cc6fc21, 0x645d671984b407b7
d_3_16:         .dword 0xce7365312c4feb59, 0x7f9ab0d65ff75943
d_3_17:         .dword 0x8744d8e80417e6e6, 0x7bd892ffb99fe741
d_3_18:         .dword 0x66a17e27d90241d9, 0xb06ca54a87c7032d
d_3_19:         .dword 0x64613e4a0e231f6d, 0xa8ebb0fbbcccfe03
d_3_20:         .dword 0x4ba03a714f48d9b4, 0x6d5a0cfb0c6a2e41
d_3_21:         .dword 0x26a96965e4715413, 0x20ec36be8ba0bb44
d_3_22:         .dword 0x8c1bd3ca54f95e1f, 0xd9180f8d9f73b849
d_3_23:         .dword 0xef5cde8290a31dd9, 0xb07df97e3b84aba9
d_3_24:         .dword 0x78aab74140ff4551, 0xfc3c8f1eaf90d675
d_3_25:         .dword 0xe774b50085348679, 0x7c1c10a7ab400bb5
d_3_26:         .dword 0x7706960ddd28788e, 0xac7a4f7ea203f895
d_3_27:         .dword 0x2d131075ae0aba1a, 0x0e3cb0136f863f8e
                .dword 0xd049a0b798e05d15, 0x43a8bcd608be0e15
                .dword 0xf118508e7c3d85c6, 0xba448960f9e40e76
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xf55d8ab062b5cdc0, 0xa12fbd01fa67cdb3
                .dword 0xf045336ba99343e4, 0xa3f62e6fc2ded7d3
d_4_0:          .dword 0xbf829c90ae5f6a47, 0x1f4b43dd465da05d
d_4_1:          .dword 0x7e5815c77e04ab33, 0xa4c2db01f960d806
d_4_2:          .dword 0x08b93e5ccbc05bd7, 0xa2a838e83622807d
d_4_3:          .dword 0x727fdec5c2f1813a, 0xe027e3c89efab73a
d_4_4:          .dword 0x46d7d3ac5de8d7cf, 0x8e3c1c14f4b1eac9
d_4_5:          .dword 0x0cd090ed1a77a7c1, 0xba6ef30d7c8d4519
d_4_6:          .dword 0x42f327ff6025b945, 0x1f69d271fb461d05
d_4_7:          .dword 0x77e44335ba1d2303, 0xccf34ec2830a740c
d_4_8:          .dword 0x4a9e7236c80fe616, 0xbbaf65862611f4ba
d_4_9:          .dword 0xbc24e26462a47d68, 0x344f7f523ef0f5e3
d_4_10:         .dword 0xef9262fc78810626, 0x672c26df55e6d422
d_4_11:         .dword 0x4e7d0ca864e6d90e, 0xfba89a340e482c05
d_4_12:         .dword 0xc24b48005826e1ab, 0x997f0bd7991a98ab
d_4_13:         .dword 0x3789d65b208a22de, 0xb7c4238f7dd308a0
d_4_14:         .dword 0xf1bf82573c9955e7, 0xce0e36ab196af7f3
d_4_15:         .dword 0x5b510d4530061af3, 0xdb4dcb9beb46f787
d_4_16:         .dword 0xbf4cd76d3591b7b5, 0x45690797c5c7a588
d_4_17:         .dword 0xe3199c30c1065003, 0x75e1785860555aad
d_4_18:         .dword 0x89b15016cd94aeac, 0x7fb45c1531f2a7b0
d_4_19:         .dword 0x87208e324fec0b96, 0xbd5cdf41fade3a54
d_4_20:         .dword 0x15d54186b3a89d7b, 0xbba0890fa23b2589
d_4_21:         .dword 0x54d442c87eb0aabd, 0x4e73db00858e201f
d_4_22:         .dword 0x1d6de5352408ddc5, 0x18af2f6cb6e5bdbf
d_4_23:         .dword 0x02be3b2a40689dd1, 0x3f313a253b7fbec7
d_4_24:         .dword 0x3b25a69933c64904, 0x0a96a9e3255db8eb
d_4_25:         .dword 0x03c84a46e1105e68, 0x2427f5c657605c63
d_4_26:         .dword 0x63aed47d95d3523e, 0xa1d3c97fa1469cd7
d_4_27:         .dword 0xab64007a4f30a1fa, 0x19d0a20b475b36c6
                .dword 0x5091e2463bc6724d, 0xba28b2028d81e695
                .dword 0x14287c5bf4552a87, 0x25ee3c20092ab2ef
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xfe82983369cc4302, 0xff4fe1ca17921872
                .dword 0x13cd90c1c6fd0b90, 0xa4ddbae7369fc97b
d_5_0:          .dword 0x6bdd94bdc3a68143, 0x7ed42e64544ecc92
d_5_1:          .dword 0xb0deff0e26f719ec, 0x0b1967bd8b1ecd00
d_5_2:          .dword 0xa6f22dafc5cc3cd3, 0xaa8a5bb3bbde5482
d_5_3:          .dword 0x0e7c22534a2c410b, 0xf99ade6aef480293
d_5_4:          .dword 0xf4a66d5030dcbb3c, 0xa21375f045c9d5af
d_5_5:          .dword 0x5de6fc7960ede4c2, 0xdae8d2b63b9fec05
d_5_6:          .dword 0x8256747581a9c479, 0x1577f98ef1475e88
d_5_7:          .dword 0xd9f3527b5b15bd34, 0x56f37f41eefdcb4a
d_5_8:          .dword 0x6e4c73ffd7f3c2e3, 0x7b3ff0af59014bbd
d_5_9:          .dword 0x5b4dd51567c30c47, 0xd09f759cf93f52cc
d_5_10:         .dword 0xeed314d41c3c9cef, 0xa9c8efa439a4f295
d_5_11:         .dword 0x98c87508ff1c44c5, 0x5847eb01746ec9f7
d_5_12:         .dword 0xf3be24a965988f8a, 0x3083ef9ee9b2086f
d_5_13:         .dword 0x27677948883318ac, 0x7b53167e61b10e13
d_5_14:         .dword 0x9fb67f2bcc36e9c3, 0xd7b6f3b17014ef5d
d_5_15:         .dword 0xdb995ee3737f9418, 0x08ca92d8558c1b4f
d_5_16:         .dword 0x41488b7a788e7d7d, 0x9adb1013c980d88a
d_5_17:         .dword 0xa7e99651d1529197, 0x9f7bddabb52d0fc3
d_5_18:         .dword 0xd1cb0b9a64e450ce, 0xee873f919e48e9a5
d_5_19:         .dword 0x811101c82a5e2297, 0xf4464a649babaf98
d_5_20:         .dword 0x6990e47b34ac5dbb, 0xc7cb7f46a56d9aa7
d_5_21:         .dword 0xd6fe430a6e060525, 0x26c8a79c1852bae5
d_5_22:         .dword 0xaa1bad745ad11f5f, 0x075175e9bc348e46
d_5_23:         .dword 0x32e4d60f142af3e2, 0x4a823bc3839c9418
d_5_24:         .dword 0xd18713e18ce40b9e, 0xb202bdf74e3df7fe
d_5_25:         .dword 0xc4127a74179c1a41, 0xb17efea5dd56dd61
d_5_26:         .dword 0x2a6f1b32f095d86a, 0x6589054f432757e4
d_5_27:         .dword 0x344a0d2cd6bbf64a, 0x56d7c2a863145153
                .dword 0x23c2a43461dcf3e0, 0x9c73a282f8c0c7c1
                .dword 0x0f78a0d0267c7b1a, 0x6fa1ec93a8f20cd0
         /* Random data */
_end_data5:
              
 
