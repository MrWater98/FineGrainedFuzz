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
        addi x10, zero, 1                         ;
        slli x10, x10, 15                         ;
        add x12, x12, x10                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 20                         ;
        add x12, x12, x14                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 19                         ;
        add x12, x12, x12                         ;
        csrrs x10, pmpcfg0, x12                   ;
_p1:    csrrsi x12, satp, 20                      ;
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
_s0:    flt.s x12, f8, f16                        ;
_s1:    fcvt.s.lu f20, x7, dyn                    ;
_s2:    mul x20, x20, x23                         ;
_s3:    addw x7, x27, x1                          ;
_s4:    mulw x3, x23, x11                         ;
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
_l0:    fsgnjx.s f6, f6, f18                      ;
_l1:    la x22, d_1_22                            ;
        addi x22, x22, -28                        ;
        amominu.w x16, x3, (x22)                  ;
_l2:    fcvt.s.wu f1, x13, dyn                    ;
_l3:    sltiu x22, x0, 685                        ;
_l4:    mulw x20, x10, x15                        ;
_l5:    sllw x28, x23, x5                         ;
_l6:    div x27, x11, x13                         ;
_l7:    la x22, d_0_21                            ;
        addi x22, x22, 8                          ;
        amoswap.d x10, x13, (x22)                 ;
_l8:    la x26, d_0_11                            ;
        addi x26, x26, 0                          ;
        amoand.d x11, x8, (x26)                   ;
_l9:    la x3, d_2_10                             ;
        addi x3, x3, -20                          ;
        amomaxu.w x8, x2, (x3)                    ;
_l10:   slliw x25, x26, 19                        ;
_l11:   slli x23, x25, 24                         ;
_l12:   sraw x8, x30, x7                          ;
_l13:   div x0, x15, x16                          ;
_l14:   csrrsi x19, pmpaddr0, 9                   ;
_l15:   fmadd.s f10, f13, f6, f12, dyn            ;
_l16:   la x9, d_0_19                             ;
        addi x9, x9, 24                           ;
        amoor.d x28, x7, (x9)                     ;
_l17:   la x8, _l23                                       ;
        csrrw zero, uepc, x8                      ;
        uret                                      ;
_l18:   remu x21, x1, x0                          ;
_l19:   bgeu x26, x6, _l43                                ;
_l20:   slli x11, x20, 44                         ;
_l21:   fmin.s f10, f4, f17                       ;
_l22:   la x17, _l18                              ;
        lhu x5, 22(x17)                           ;
_l23:   jal x20, _l110                                    ;
_l24:   auipc x22, 1048575                        ;
_l25:   la x19, _l39                              ;
        srai x19, x19, 1                          ;
        csrrc x16, pmpaddr7, x19                  ;
_l26:   divuw x27, x23, x22                       ;
_l27:   srai x17, x5, 8                           ;
_l28:   la x20, d_4_5                             ;
        addi x20, x20, 8                          ;
        amoxor.d x8, x8, (x20)                    ;
_l29:   beq x6, x10, _l63                         ;
_l30:   csrrwi x27, satp, 21                      ;
_l31:   fence                                     ;
_l32:   fcvt.wu.s x5, f21, rne                    ;
_l33:   fcvt.w.s x9, f0, rup                      ;
_l34:   sllw x17, x22, x13                        ;
_l35:   la x6, d_2_26                             ;
        addi x6, x6, -8                           ;
        sc.w x3, x17, (x6)                        ;
_l36:   fmadd.s f2, f30, f23, f17, dyn            ;
_l37:   la x3, d_1_10                             ;
        sb x10, 10(x3)                            ;
_l38:   fmsub.s f4, f26, f28, f8, rup             ;
_l39:   fnmsub.s f4, f3, f14, f24, rdn            ;
_l40:   fcvt.wu.s x1, f22, rdn                    ;
_l41:   fcvt.w.s x21, f30, dyn                    ;
_l42:   la x14, d_3_12                            ;
        addi x14, x14, 0                          ;
        lui x16, 0xffe00                          ;
        xor x14, x14, x16                         ;
        sc.w x25, x16, (x14)                      ;
_l43:   fdiv.s f12, f18, f20, rtz                 ;
_l44:   rem x24, x27, x25                         ;
_l45:   csrrci x30, fflags, 20                    ;
_l46:   csrrci x13, fflags, 28                    ;
_l47:   la x3, d_0_15                             ;
        addi x3, x3, -4                           ;
        amoadd.w x10, x9, (x3)                    ;
_l48:   remu x5, x17, x21                         ;
_l49:   fmv.x.w x19, f3                           ;
_l50:   fcvt.s.l f4, x8, rdn                      ;
_l51:   fcvt.lu.s x13, f24, dyn                   ;
_l52:   la x15, d_5_17                            ;
        addi x15, x15, -8                         ;
        lui x8, 0xffe00                           ;
        xor x15, x15, x8                          ;
        lr.d x25, (x15)                           ;
_l53:   flt.s x23, f22, f3                        ;
_l54:   ori x16, x7, 12                           ;
_l55:   bge x26, x1, _l168                                ;
_l56:   fmin.s f13, f16, f8                       ;
_l57:   la x6, d_2_21                             ;
        addi x6, x6, -16                          ;
        amoor.d x5, x12, (x6)                     ;
_l58:   la x25, _l147                                     ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l59:   remu x16, x5, x10                         ;
_l60:   fmin.s f17, f1, f11                       ;
_l61:   slli x1, x8, 40                           ;
_l62:   la x17, _l84                                      ;
        lw x27, 12(x17)                           ;
_l63:   blt x26, x11, _l90                        ;
_l64:   fle.s x12, f1, f5                         ;
_l65:   la x29, _l112                                     ;
        csrrw zero, uepc, x29                     ;
        uret                                      ;
_l66:   mulh x13, x30, x15                        ;
_l67:   sraw x29, x15, x20                        ;
_l68:   fle.s x25, f19, f12                       ;
_l69:   fcvt.lu.s x8, f17, rdn                    ;
_l70:   lui x11, 351519                           ;
_l71:   csrrci x25, medeleg, 31                   ;
_l72:   slti x27, x11, 0                          ;
_l73:   fmadd.s f3, f27, f22, f28, rtz            ;
_l74:   la x26, d_5_0                             ;
        lh x1, -18(x26)                           ;
_l75:   la x3, d_3_12                             ;
        addi x3, x3, 24                           ;
        amoor.w x27, x10, (x3)                    ;
_l76:   csrrwi x11, fflags, 4                     ;
_l77:   ori x7, x7, 990                           ;
_l78:   fcvt.s.w f22, x13, rtz                    ;
_l79:   csrrsi x30, stval, 28                     ;
_l80:   la x1, d_2_1                              ;
        sw x15, -12(x1)                           ;
_l81:   ecall                                     ;
_l82:   sltiu x11, x7, 965                        ;
_l83:   fsgnj.s f3, f22, f6                       ;
_l84:   la x8, d_1_5                              ;
        ld x28, 0(x8)                             ;
_l85:   srliw x4, x11, 10                         ;
_l86:   bgeu x10, x20, _l178                              ;
_l87:   fnmsub.s f29, f7, f22, f22, rdn           ;
_l88:   fmv.w.x f9, x26                           ;
_l89:   sraw x23, x5, x2                          ;
_l90:   la x9, d_0_27                             ;
        lh x2, -16(x9)                            ;
_l91:   la x10, d_4_26                            ;
        fsw f16, -28(x10)                         ;
_l92:   xor x22, x22, x22                         ;
        csrrw x9, frm, x22                        ;
_l93:   mulw x29, x4, x19                         ;
_l94:   la x22, d_0_9                             ;
        addi x22, x22, -4                         ;
        amomaxu.w x24, x21, (x22)                 ;
_l95:   fmin.s f29, f3, f10                       ;
_l96:   la x8, _l109                                      ;
        csrrw zero, uepc, x8                      ;
        uret                                      ;
_l97:   fnmsub.s f6, f26, f2, f30, rmm            ;
_l98:   la x13, d_0_12                            ;
        lui x25, 0xffe00                          ;
        xor x13, x13, x25                         ;
        lb x23, 0(x13)                            ;
_l99:   la x22, d_5_1                             ;
        addi x22, x22, -16                        ;
        amominu.d x9, x28, (x22)                  ;
_l100:  la x27, d_0_15                            ;
        sd x15, 8(x27)                            ;
_l101:  srlw x16, x8, x11                         ;
_l102:  la x6, d_3_20                             ;
        sd x21, -0(x6)                            ;
_l103:  xori x7, x0, -677                         ;
_l104:  fdiv.s f3, f23, f27, rmm                  ;
_l105:  lui x5, 1048575                           ;
_l106:  la x6, d_1_9                              ;
        addi x6, x6, 20                           ;
        lr.w x28, (x6)                            ;
_l107:  xor x1, x1, x1                            ;
        addi x18, zero, 3                         ;
        slli x18, x18, 26                         ;
        add x1, x1, x18                           ;
        csrrc x14, sip, x1                        ;
_l108:  divu x22, x7, x27                         ;
_l109:  csrrsi x21, sepc, 4                       ;
_l110:  rem x8, x25, x26                          ;
_l111:  bltu x24, x1, _l169                       ;
_l112:  addw x19, x7, x23                         ;
_l113:  fcvt.s.lu f15, x14, rne                   ;
_l114:  fsqrt.s f0, f26, rup                      ;
_l115:  la x4, d_5_19                             ;
        addi x4, x4, -4                           ;
        amoxor.w x20, x13, (x4)                   ;
_l116:  fmv.x.w x9, f13                           ;
_l117:  ebreak                                    ;
_l118:  divu x26, x30, x20                        ;
_l119:  la x4, d_0_13                             ;
        sb x12, -8(x4)                            ;
_l120:  csrrci x28, pmpaddr6, 31                  ;
_l121:  csrrci x24, sscratch, 30                  ;
_l122:  la x4, d_0_21                             ;
        addi x4, x4, -0                           ;
        amomin.d x27, x6, (x4)                    ;
_l123:  xor x30, x30, x30                         ;
        addi x8, zero, 1                          ;
        slli x8, x8, 14                           ;
        add x30, x30, x8                          ;
        addi x7, zero, 3                          ;
        slli x7, x7, 28                           ;
        add x30, x30, x7                          ;
        csrrc x22, mepc, x30                      ;
_l124:  la x11, d_5_25                            ;
        addi x11, x11, -28                        ;
        lr.w x4, (x11)                            ;
_l125:  la x10, d_2_0                             ;
        addi x10, x10, -0                         ;
        amoand.d x20, x26, (x10)                  ;
_l126:  la x4, d_3_21                             ;
        addi x4, x4, 0                            ;
        amominu.d x28, x5, (x4)                   ;
_l127:  lui x15, 377776                           ;
_l128:  feq.s x2, f2, f31                         ;
_l129:  la x20, _l98                                      ;
        lwu x24, -16(x20)                         ;
_l130:  flt.s x18, f16, f2                        ;
_l131:  fsqrt.s f1, f22, rdn                      ;
_l132:  fcvt.s.lu f6, x19, rmm                    ;
_l133:  srli x16, x1, 23                          ;
_l134:  fdiv.s f28, f25, f18, rdn                 ;
_l135:  fle.s x26, f0, f8                         ;
_l136:  blt x24, x24, _l149                               ;
_l137:  la x28, d_3_13                            ;
        lbu x16, 28(x28)                          ;
_l138:  la x20, d_4_1                             ;
        addi x20, x20, 0                          ;
        lr.d x2, (x20)                            ;
_l139:  remw x24, x3, x30                         ;
_l140:  addiw x9, x7, 497                         ;
_l141:  la x14, d_4_14                            ;
        lui x20, 0xffe00                          ;
        xor x14, x14, x20                         ;
        lwu x21, 12(x14)                          ;
_l142:  la x27, d_2_14                            ;
        addi x27, x27, 16                         ;
        lr.d x22, (x27)                           ;
_l143:  fmsub.s f4, f29, f14, f12, rne            ;
_l144:  jal x23, _l156                                    ;
_l145:  la x21, _l158                             ;
        jalr x12, 0(x21)                          ;
_l146:  la x6, d_2_9                              ;
        srai x6, x6, 1                            ;
        csrrs x27, pmpaddr4, x6                   ;
_l147:  fence                                     ;
_l148:  la x8, d_0_22                             ;
        addi x8, x8, 20                           ;
        lr.w x29, (x8)                            ;
_l149:  fmv.w.x f20, x11                          ;
_l150:  srliw x23, x22, 8                         ;
_l151:  fmax.s f0, f8, f13                        ;
_l152:  slliw x14, x26, 22                        ;
_l153:  la x26, _l100                             ;
        lh x4, 30(x26)                            ;
_l154:  srlw x22, x3, x8                          ;
_l155:  addiw x0, x26, 990                        ;
_l156:  fnmsub.s f2, f26, f10, f1, rdn            ;
_l157:  fle.s x13, f28, f14                       ;
_l158:  xor x17, x17, x17                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 2                          ;
        add x17, x17, x12                         ;
        addi x25, zero, 1                         ;
        slli x25, x25, 27                         ;
        add x17, x17, x25                         ;
        csrrs x20, mtval, x17                     ;
_l159:  fcvt.lu.s x8, f1, dyn                     ;
_l160:  la x24, d_3_15                            ;
        lb x29, -0(x24)                           ;
_l161:  la x4, d_3_20                             ;
        addi x4, x4, -0                           ;
        sc.d x5, x4, (x4)                         ;
_l162:  fmadd.s f21, f3, f1, f28, dyn             ;
_l163:  fsqrt.s f8, f22, rmm                      ;
_l164:  la x27, d_5_5                             ;
        lb x1, 31(x27)                            ;
_l165:  fsgnjn.s f18, f10, f25                    ;
_l166:  la x21, d_5_18                            ;
        addi x21, x21, 8                          ;
        amoswap.d x13, x7, (x21)                  ;
_l167:  srlw x1, x7, x3                           ;
_l168:  mulhsu x18, x29, x8                       ;
_l169:  csrrci x10, fcsr, 10                      ;
_l170:  fmax.s f3, f5, f1                         ;
_l171:  fclass.s x4, f19                          ;
_l172:  mulhsu x0, x0, x30                        ;
_l173:  fcvt.s.w f6, x28, rne                     ;
_l174:  ebreak                                    ;
_l175:  la x5, d_4_10                             ;
        addi x5, x5, -0                           ;
        amoswap.d x7, x15, (x5)                   ;
_l176:  fcvt.s.w f30, x3, rdn                     ;
_l177:  fcvt.lu.s x10, f29, rup                   ;
_l178:  fmin.s f8, f30, f15                       ;
_l179:  mulw x1, x27, x22                         ;
_l180:  xor x26, x26, x26                         ;
        addi x17, zero, 3                         ;
        slli x17, x17, 6                          ;
        add x26, x26, x17                         ;
        addi x17, zero, 1                         ;
        slli x17, x17, 17                         ;
        add x26, x26, x17                         ;
        csrrc x22, stval, x26                     ;
_l181:  flt.s x7, f4, f31                         ;
_l182:  la x5, d_4_14                             ;
        lui x28, 0xffe00                          ;
        xor x5, x5, x28                           ;
        lb x6, 27(x5)                             ;
_l183:  flt.s x18, f15, f22                       ;
_l184:  flt.s x8, f9, f13                         ;
_l185:  fmv.w.x f13, x18                          ;
_l186:  lui x13, 323283                           ;
_l187:  la x13, d_5_14                            ;
        addi x13, x13, 24                         ;
        amoor.d x8, x21, (x13)                    ;
_l188:  la x3, d_3_18                             ;
        ld x7, 16(x3)                             ;
_l189:  fcvt.s.lu f28, x28, rmm                   ;
_l190:  la x7, d_4_15                             ;
        addi x7, x7, 24                           ;
        amoand.d x27, x18, (x7)                   ;
_l191:  la x18, _l192                                     ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l192:  fmin.s f30, f7, f7                        ;
_l193:  fclass.s x0, f2                           ;
_l194:  la x13, d_2_27                            ;
        addi x13, x13, -0                         ;
        amomin.w x20, x2, (x13)                   ;
_l195:  fence.i                                   ;
_l196:  sllw x18, x0, x8                          ;
_l197:  la x1, d_4_7                              ;
        addi x1, x1, -16                          ;
        amominu.d x14, x14, (x1)                  ;
_l198:  mul x11, x24, x28                         ;
_l199:  div x9, x5, x15                           ;
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
                .dword 0x8653fbd2c14a28d8, 0xe5de25f36cc18fef
                .dword 0x4a618a989695a360, 0x373a88873c103b62
d_0_0:          .dword 0xb9c2557b2f7b35b2, 0x52eaa82f6a690c2d
d_0_1:          .dword 0xae1c25b383008bb5, 0xfc7738b7bead6249
d_0_2:          .dword 0x956434eb7a47fb30, 0x77745b4602c38d97
d_0_3:          .dword 0xa7ff3495f5d0c46b, 0x80826f40d0d7a8f4
d_0_4:          .dword 0xb2a5f9c1b7159a7f, 0xfbb4ab6fe089fb08
d_0_5:          .dword 0xb9d780e9dd90bda2, 0xd978ce467172b4bb
d_0_6:          .dword 0x6f21ff41469bcd05, 0x3234dcdf08bfea63
d_0_7:          .dword 0x9b21ba29323aceb1, 0x91b9a4f7e4017891
d_0_8:          .dword 0x9e1acc059bd0d879, 0x7e35e2e194748961
d_0_9:          .dword 0x8dc68b0988139baf, 0x7002a220a8b5dce7
d_0_10:         .dword 0xa8c3f523801c41d8, 0xce58343a486ba955
d_0_11:         .dword 0x83011cc86d072e67, 0x58b83b17896badfa
d_0_12:         .dword 0x453c11693f1d4573, 0xa32ae91ddca79644
d_0_13:         .dword 0xaa1b1dec226a5786, 0x475ef5f8187765b1
d_0_14:         .dword 0x1787a018a08c68c3, 0xa118156fc6025674
d_0_15:         .dword 0x74e5184aa23adbcc, 0xd638eaeeb30a0ead
d_0_16:         .dword 0xc9c5cdfe5582812a, 0x37fdbbdda32093da
d_0_17:         .dword 0x53420a1fa3b54673, 0x43e7f62b6b650159
d_0_18:         .dword 0x89c66afa3ed07a86, 0xd14a18c7ff007238
d_0_19:         .dword 0x2b6a198d1c93873a, 0xdd31972b038758f4
d_0_20:         .dword 0xee778f68b5cd453c, 0x3a937424b289ec0a
d_0_21:         .dword 0xfe6bd4068681b8b9, 0x43dee332c45faa74
d_0_22:         .dword 0x87281acb1ff7179b, 0xa8e06a219bf69c96
d_0_23:         .dword 0x75dfc47843c663a0, 0x14ef3563e6f45139
d_0_24:         .dword 0x653d96df09551e4a, 0x065c7e7219eaaf9e
d_0_25:         .dword 0xef9384402e4d87ce, 0x01fb409011524bfa
d_0_26:         .dword 0x04d71f0f64702638, 0x277d455d12ef7c18
d_0_27:         .dword 0x732110363d1841f9, 0x961177a56e90b00f
                .dword 0xc978247d385a9bba, 0x06cc6ff80a1b4bdb
                .dword 0x02dbbecc3129f334, 0xd320d1474db0e9ac
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x8e32ab70e5a21e07, 0xc40da9da9d994bec
                .dword 0x2bca1ae6ee1c101c, 0x8d74811381dd149a
d_1_0:          .dword 0xf18c14bb49163839, 0xda2899478ef2de59
d_1_1:          .dword 0xbed9b0d834b7f115, 0x4f4a8e5cc41826b9
d_1_2:          .dword 0xdf0ab0b2b59fa4c2, 0x063f8d4cc5d70d9b
d_1_3:          .dword 0x6ec29d2f14f9d505, 0xa5da04efcb59e885
d_1_4:          .dword 0xef6b8eb7dc18f5c9, 0xd5dd93a5cb209bf6
d_1_5:          .dword 0x1aa0fb94eb6d6670, 0xd3f73c0998f4f283
d_1_6:          .dword 0xf87d78e46bc15f96, 0x01381c2d6cd98150
d_1_7:          .dword 0x1ca244b41d6a8fd6, 0x1315e36ca3658dc2
d_1_8:          .dword 0x6ba36a2e9bcdf1f0, 0xb346914518646373
d_1_9:          .dword 0x6d6bb46afa005add, 0x808670ee211ebb7b
d_1_10:         .dword 0x01b01cb3531092de, 0x1f4f91313301c03d
d_1_11:         .dword 0xbdfb6de67297968f, 0x6ab2b9a7c61a436e
d_1_12:         .dword 0xc3b2fbdee1bb6f5f, 0x6e69336a75dcafad
d_1_13:         .dword 0xb0fa72aece221ea2, 0x2d6377ce6bb08392
d_1_14:         .dword 0x815a8d35d682f50e, 0x1e917db5b57ea0f9
d_1_15:         .dword 0x66776d1ee2752fb6, 0x8d6f8b60077b7bd2
d_1_16:         .dword 0x892bfacafe7bffee, 0xd5af642721d630cb
d_1_17:         .dword 0x67978d1b1be6a1f1, 0xd5393029a9897d27
d_1_18:         .dword 0xcb09a34b25e21aac, 0x7e4be546a1f08df0
d_1_19:         .dword 0xfe984a48552a95a8, 0x19aaee75c1bf682a
d_1_20:         .dword 0x06bfd08f79cd27cb, 0x2c93842fe6df72d2
d_1_21:         .dword 0x997076a272cc2d70, 0x5e79255624dc4bea
d_1_22:         .dword 0x8ccfadf087c14dd5, 0xca3e2533901399a7
d_1_23:         .dword 0x8c7555fd4304f207, 0x4f2925c6f05641e9
d_1_24:         .dword 0x0a97b9da218929f4, 0xb2f6d108173f885f
d_1_25:         .dword 0x94ea2b25d9ec5c16, 0xa82ad65a52b6a981
d_1_26:         .dword 0x70e845c552807f20, 0x8b241b0b37efaa2e
d_1_27:         .dword 0x892abe06b731f030, 0x8bfb88ff4ec53014
                .dword 0x6707f21bb888029b, 0x01e02a7d0b7d39cc
                .dword 0x580a332a57ae804a, 0xa8fa5977e25f15fe
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xac51216f593d6919, 0xbd47e9e0206d5040
                .dword 0x93b85b7ce556e0e6, 0x9b8c652bcf77147c
d_2_0:          .dword 0x399601b8479f4b43, 0x9250992f3d1723c9
d_2_1:          .dword 0x75b75001f7f0e1ae, 0x192c3d241be2b781
d_2_2:          .dword 0x48ca96e6d85259f2, 0x9a7aa34503daefd9
d_2_3:          .dword 0x605db1944df6f32a, 0x5ae24f715055b070
d_2_4:          .dword 0x1f62853aee61fdbf, 0x4eb25cbef68e8dd8
d_2_5:          .dword 0xc69553f8bd6c1d6b, 0x226f44daac98976f
d_2_6:          .dword 0xaba04352535967e7, 0xa1f90f186c00f8f3
d_2_7:          .dword 0xa412d697a376b950, 0x35bcb182982bc0c2
d_2_8:          .dword 0x38f33749fed97cec, 0xdcf91ccea1857c29
d_2_9:          .dword 0xd3cb1b889b490e7b, 0x4cb010c04d7a5d00
d_2_10:         .dword 0x35d34499f71b6ffd, 0x9ea144e90c377ba8
d_2_11:         .dword 0x63454708dda50d8b, 0x54d8c6b5c9bb6918
d_2_12:         .dword 0xa839987b7fef7fb5, 0x6e9d53fac9853218
d_2_13:         .dword 0xe77143b798c38c3f, 0x7daa93e9a63edace
d_2_14:         .dword 0x83b872f0d88f29f2, 0x0d29b913837475cd
d_2_15:         .dword 0xcb470882b342ce6e, 0xd756fbfd30737eb5
d_2_16:         .dword 0x86b3286a76eb4687, 0x476cca4badd6f328
d_2_17:         .dword 0x6b184931c2db5971, 0x33a3bbc68c6c3f6a
d_2_18:         .dword 0x3549ae0605c3a785, 0x4357160b36ac487d
d_2_19:         .dword 0x95ca3ef912fe4f3a, 0x7058e60cebca235f
d_2_20:         .dword 0x6460aebb75906e24, 0xe9711fe1cc8bd9e6
d_2_21:         .dword 0xbb97486c3278d334, 0x4fe4f60eda4babc8
d_2_22:         .dword 0x390da39f6bdecbe1, 0xd861a04a9a558cc6
d_2_23:         .dword 0x203cc2b157c081bc, 0x43a58355b4732895
d_2_24:         .dword 0x3abba5956e370a1a, 0x3ba7c335939e5c94
d_2_25:         .dword 0x4a66e298f13b693b, 0x212260f8ab908216
d_2_26:         .dword 0xb420fd47b72fd89b, 0x421f8cd8279d47e0
d_2_27:         .dword 0x2ed7728425cf7f16, 0x10a8530f6b22a2b0
                .dword 0x3d8f7bd582a12039, 0x43e7cd4c69b1c359
                .dword 0x9f811e784d3336ad, 0x03836cc8f7beb7f7
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x030101b21dc34f6b, 0x79cb11031fc52ba4
                .dword 0xcffdb786c982f328, 0x4c0597c17e82d770
d_3_0:          .dword 0x4fd6f02ee9cb79be, 0xaca1f4b4bd1ea464
d_3_1:          .dword 0x9ca617d7715b068d, 0xc795f14e4e29124c
d_3_2:          .dword 0xe748882722716588, 0xbd7973b1c449aa0a
d_3_3:          .dword 0x658342b9c8f38b9c, 0xc9e07af6c0ff5316
d_3_4:          .dword 0x6c9ca683ab177490, 0x101ee5f3462c6abe
d_3_5:          .dword 0x987234b40b4b9b74, 0xe3eb6b66784c2a21
d_3_6:          .dword 0x70392490e69fb90d, 0x02c065d5912a6692
d_3_7:          .dword 0xf5e0040e37baccf3, 0x49ff7939c91bbf28
d_3_8:          .dword 0x364a5fcb93dbaaac, 0x68377e26c3ff3657
d_3_9:          .dword 0xccd6d39416ea699e, 0x6914417bb09722d5
d_3_10:         .dword 0xc499890d08c55aa3, 0xe7e0af7331b466ce
d_3_11:         .dword 0x96b9fb1e5e1e1c5b, 0x47355f70dfcab50a
d_3_12:         .dword 0x5f2f8eb4d702485e, 0x79d3c4d294c9bb7e
d_3_13:         .dword 0xa663e3409569f782, 0xb3392a5035287a8b
d_3_14:         .dword 0x04527a5969744230, 0x86d53a190487af39
d_3_15:         .dword 0xdada6def76a2fa45, 0x3edcd65bca2765fe
d_3_16:         .dword 0xe020668aca4b4db6, 0xf10f14e5b1ffdc41
d_3_17:         .dword 0xb26f3d75f0784b32, 0xbd83ab012c83f085
d_3_18:         .dword 0x080374d98bc49a04, 0xedebe0a2090a4f29
d_3_19:         .dword 0x1d0dcd99d4a71984, 0xacc2d6109b7709b7
d_3_20:         .dword 0x156c7547f6f4752b, 0xe75308bf1b733fe7
d_3_21:         .dword 0x8cf9bfe67d81a18d, 0x34a6602e307fd6d9
d_3_22:         .dword 0xec9bff9d66382447, 0x078e69c9a3adeb98
d_3_23:         .dword 0x2bc0b2e4ce13b751, 0x4c1db6d685d79526
d_3_24:         .dword 0xeaef3f0bfabb08bc, 0xe01b86a21f97b2aa
d_3_25:         .dword 0xd10445108a2843b5, 0x064c2f4e6207d8be
d_3_26:         .dword 0x0eb3e20cf358cd4c, 0xcd131b9e61968455
d_3_27:         .dword 0x09813b3c348268e2, 0xc4046a314f53225a
                .dword 0x85d23c5f90a09fde, 0x29d71f276434d55b
                .dword 0x8fb1c46b538e688a, 0xd1c88512e62b7c58
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8911bb9d4772d922, 0xcaab8a97ebfe21bd
                .dword 0x75ec2083bbb155d3, 0xf30eb15f853adde4
d_4_0:          .dword 0xa98d199794a2264b, 0x3e59332518a2b7b6
d_4_1:          .dword 0x5f7bb0003dc28681, 0x2d51fff817a47729
d_4_2:          .dword 0x61e228e45e25c3da, 0x8ae883588e06c596
d_4_3:          .dword 0xa919cb6b39480fb7, 0x8ff81bbd459d7e83
d_4_4:          .dword 0x754b636a0b8589b1, 0x243881e04bac67a1
d_4_5:          .dword 0x2e6d12cfd9c4e0e2, 0xda2a2c40dc6026e8
d_4_6:          .dword 0xd098f22e176d63ac, 0xdaa124c088cd80e3
d_4_7:          .dword 0x3109a42fc58940e7, 0x74cc7a6999a63845
d_4_8:          .dword 0xd2540024736e0781, 0x9e0515dd48a18d9d
d_4_9:          .dword 0x742609cc4a0326e3, 0xdfc59d15ba067513
d_4_10:         .dword 0x052c3fed688a7dfc, 0xbe3b317d3df7deb5
d_4_11:         .dword 0x6c7660bfdcb7353e, 0x965c9ed116313454
d_4_12:         .dword 0x9bcf46967eaad37e, 0xc46dc48818c980a3
d_4_13:         .dword 0xdf3f6beddee4f9a9, 0xc1570807ded7a012
d_4_14:         .dword 0x1a121796bc43dc92, 0xf913b0d9cb453a9a
d_4_15:         .dword 0xb052742a6c606d38, 0x5149799838e99617
d_4_16:         .dword 0xdd1acee75937056f, 0x8996d49d85f7a3fb
d_4_17:         .dword 0x381e83e0f492a4c6, 0x64aa029840141d90
d_4_18:         .dword 0x26ac5e849e94d79a, 0x098a74eb31bfee7f
d_4_19:         .dword 0xc493dba4e732221f, 0x50a669e10f4f54fa
d_4_20:         .dword 0xf579c5816457dc56, 0xa0c0440a6cd805b5
d_4_21:         .dword 0x736edff518206e2a, 0x355fe6db1e04bbb3
d_4_22:         .dword 0x0522ff8b5930089a, 0xd3a63f2dab1e95d5
d_4_23:         .dword 0x5f0c08e637c67f22, 0x54d677a2276fcbb6
d_4_24:         .dword 0x7a656a300c3c2088, 0x83eb4c44f64c0f03
d_4_25:         .dword 0x25e0e30ad148578f, 0x963577a36d57d0f1
d_4_26:         .dword 0xaec2b1bf65bdb6a8, 0xb9a38d1f07bf59c8
d_4_27:         .dword 0xe7e286b532a93a14, 0x55057a563b33f431
                .dword 0x7ae426a6a3e5f9f1, 0x0feb29189c58c329
                .dword 0xa95abf7c92582118, 0x4f472bc352449f21
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf689cfcb04828a6c, 0x1896a358286187ec
                .dword 0x1ae8d0bcca1df0ea, 0x075324a73f481f9c
d_5_0:          .dword 0xfbd7883e70882ac7, 0xbfd7be88ff645778
d_5_1:          .dword 0xc94c54a01c36f23c, 0xb01ae7afcd6945cd
d_5_2:          .dword 0x01301e43bf837a98, 0xf59972f3bdda1ed2
d_5_3:          .dword 0x7f56e331a45865e1, 0x97fd9a58a1a82a47
d_5_4:          .dword 0x2cd3cb171d7e7fd1, 0xd908cfd12e8ec10d
d_5_5:          .dword 0xe88d4f39d3352aa7, 0x094fb8af05a16eb0
d_5_6:          .dword 0xefefd37053c0234e, 0x9535edca4986ff69
d_5_7:          .dword 0xa567fe2c7876994e, 0x7d6af141af9fa9d5
d_5_8:          .dword 0xeae26618c762f070, 0x099bc009f5e7b4a3
d_5_9:          .dword 0x0dcb580ca66f6c14, 0x57282961c8932f34
d_5_10:         .dword 0xce0548ca73067d02, 0x2283af037db68374
d_5_11:         .dword 0x8d69b201a2a063de, 0xdcda898efd51cb70
d_5_12:         .dword 0x36ac032cfc386520, 0x011a0e39c0ac71ab
d_5_13:         .dword 0xbdd8d83c279903e1, 0xa303e4c8db534246
d_5_14:         .dword 0xcaf492c58274cd1c, 0xa99a8a74810070bb
d_5_15:         .dword 0x02c6193034e834df, 0xf4c4cf54f3772c7b
d_5_16:         .dword 0x33e670e401b1b4cb, 0x9cfaabfbc9ea1ab6
d_5_17:         .dword 0x7fc844948455180c, 0x19a5aa4cf2152d29
d_5_18:         .dword 0x4a00a0e0b0799002, 0x48a3302166556062
d_5_19:         .dword 0xda8ec185f5c9849c, 0xe0ba4a38203ac559
d_5_20:         .dword 0x1c35317ac1b71d53, 0xcdaab31070db5ebb
d_5_21:         .dword 0x6412e79c8e61724d, 0xfddb34e61cea96fb
d_5_22:         .dword 0x38d96e7a875f3e58, 0x64a07a10ec93473b
d_5_23:         .dword 0xc3a69e426fda9db2, 0x88663772617e5b0b
d_5_24:         .dword 0xc9938155401b98d4, 0xd84aaee2f9fd179f
d_5_25:         .dword 0x6dd0d8705ae60ca7, 0x4f18a72185a49707
d_5_26:         .dword 0x70d1174e3acb73e0, 0x085c6ed53a330533
d_5_27:         .dword 0xa7e9307cbbc0e231, 0x4e9d1cc87d0ba9f1
                .dword 0x03a9010c659de880, 0xb6150c953f3e5bcb
                .dword 0x3e2af6482cdb814f, 0x0a74c01ceb016289
         /* Random data */
_end_data5:
              
 
