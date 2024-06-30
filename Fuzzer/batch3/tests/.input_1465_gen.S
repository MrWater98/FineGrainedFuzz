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
_p0:    csrrsi x12, fcsr, 0                       ;
_p1:    xor x10, x10, x10                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 13                         ;
        add x10, x10, x14                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 12                         ;
        add x10, x10, x14                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 1                          ;
        add x10, x10, x14                         ;
        csrrw x11, frm, x10                       ;
_p2:    csrrsi x11, satp, 13                      ;
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
_s0:    la x1, d_1_8                              ;
        addi x1, x1, -8                           ;
        sc.d x30, x1, (x1)                        ;
_s1:    srlw x2, x28, x7                          ;
_s2:    xori x1, x22, -1819                       ;
_s3:    divuw x24, x30, x3                        ;
_s4:    fclass.s x4, f15                          ;
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
_l0:    la x11, d_0_9                             ;
        addi x11, x11, 16                         ;
        amoand.w x19, x3, (x11)                   ;
_l1:    fadd.s f30, f5, f15, rmm                  ;
_l2:    srlw x8, x16, x19                         ;
_l3:    divuw x3, x10, x27                        ;
_l4:    la x14, d_4_11                            ;
        lhu x21, -16(x14)                         ;
_l5:    la x9, d_3_13                             ;
        addi x9, x9, 8                            ;
        amoor.d x25, x14, (x9)                    ;
_l6:    addiw x14, x29, -13                       ;
_l7:    beq x14, x16, _l118                       ;
_l8:    la x12, d_3_23                            ;
        fsw f20, 12(x12)                          ;
_l9:    slli x10, x21, 62                         ;
_l10:   la x11, d_5_14                            ;
        addi x11, x11, 8                          ;
        sc.w x5, x8, (x11)                        ;
_l11:   la x16, d_4_16                            ;
        sd x29, -24(x16)                          ;
_l12:   la x4, d_0_18                             ;
        lbu x24, -25(x4)                          ;
_l13:   fmsub.s f8, f6, f9, f25, rmm              ;
_l14:   fence.i                                   ;
_l15:   la x27, d_4_1                             ;
        addi x27, x27, -8                         ;
        sc.w x3, x23, (x27)                       ;
_l16:   sraiw x5, x25, 25                         ;
_l17:   remw x7, x10, x18                         ;
_l18:   fcvt.s.l f25, x4, rup                     ;
_l19:   feq.s x1, f31, f15                        ;
_l20:   fcvt.s.w f2, x24, rtz                     ;
_l21:   la x1, d_2_4                              ;
        addi x1, x1, 8                            ;
        amomin.d x24, x27, (x1)                   ;
_l22:   la x16, d_0_23                            ;
        sd x7, 8(x16)                             ;
_l23:   remw x4, x4, x23                          ;
_l24:   fmadd.s f13, f17, f17, f5, rup            ;
_l25:   fcvt.s.lu f15, x21, rdn                   ;
_l26:   la x29, d_4_9                             ;
        lb x23, -0(x29)                           ;
_l27:   bne x16, x24, _l88                        ;
_l28:   addw x18, x21, x12                        ;
_l29:   bne x27, x3, _l91                         ;
_l30:   la x17, d_2_12                            ;
        sb x22, 25(x17)                           ;
_l31:   div x6, x20, x8                           ;
_l32:   la x21, d_5_17                            ;
        addi x21, x21, 0                          ;
        sc.w x20, x26, (x21)                      ;
_l33:   la x6, _l156                              ;
        jalr x4, 0(x6)                            ;
_l34:   fcvt.s.wu f8, x1, rdn                     ;
_l35:   fcvt.w.s x17, f9, rup                     ;
_l36:   la x20, d_0_0                             ;
        addi x20, x20, 4                          ;
        amoadd.w x10, x22, (x20)                  ;
_l37:   fmv.w.x f20, x23                          ;
_l38:   la x29, d_4_22                            ;
        lh x19, -16(x29)                          ;
_l39:   fcvt.lu.s x11, f9, rdn                    ;
_l40:   mulh x3, x14, x15                         ;
_l41:   csrrci x30, mtval, 13                     ;
_l42:   rem x2, x20, x10                          ;
_l43:   srai x30, x2, 11                          ;
_l44:   la x21, d_4_20                            ;
        addi x21, x21, -28                        ;
        amoand.w x25, x10, (x21)                  ;
_l45:   la x4, _l128                              ;
        lw x13, 24(x4)                            ;
_l46:   la x14, d_4_0                             ;
        addi x14, x14, 24                         ;
        amoswap.d x17, x24, (x14)                 ;
_l47:   sraw x17, x23, x22                        ;
_l48:   slti x27, x13, -272                       ;
_l49:   la x16, d_5_26                            ;
        lw x23, 0(x16)                            ;
_l50:   blt x6, x13, _l54                         ;
_l51:   fmv.w.x f24, x30                          ;
_l52:   la x21, d_2_7                             ;
        addi x21, x21, 24                         ;
        amominu.d x12, x31, (x21)                 ;
_l53:   bge x2, x29, _l124                        ;
_l54:   lui x24, 811013                           ;
_l55:   srli x25, x26, 16                         ;
_l56:   fcvt.s.w f9, x16, rup                     ;
_l57:   fcvt.s.wu f21, x4, rne                    ;
_l58:   la x1, d_0_19                             ;
        addi x1, x1, -0                           ;
        amoadd.d x5, x12, (x1)                    ;
_l59:   slti x1, x30, 653                         ;
_l60:   fdiv.s f20, f12, f5, rne                  ;
_l61:   sraw x10, x26, x9                         ;
_l62:   la x7, _l102                              ;
        jalr x12, 0(x7)                           ;
_l63:   fmv.x.w x6, f29                           ;
_l64:   csrrwi x9, pmpaddr2, 0                    ;
_l65:   la x20, d_2_9                             ;
        sh x4, 30(x20)                            ;
_l66:   la x2, d_5_24                             ;
        fsw f31, 8(x2)                            ;
_l67:   la x3, d_2_2                              ;
        addi x3, x3, 20                           ;
        amoxor.w x30, x22, (x3)                   ;
_l68:   fmv.x.w x14, f25                          ;
_l69:   divw x22, x12, x30                        ;
_l70:   fcvt.s.lu f30, x19, rdn                   ;
_l71:   fsgnj.s f5, f26, f13                      ;
_l72:   srlw x14, x18, x19                        ;
_l73:   srliw x5, x11, 18                         ;
_l74:   fmin.s f29, f3, f14                       ;
_l75:   sraiw x24, x9, 17                         ;
_l76:   fsgnjn.s f18, f16, f22                    ;
_l77:   la x23, _l180                             ;
        lw x16, 16(x23)                           ;
_l78:   fadd.s f25, f7, f18, rup                  ;
_l79:   fsgnj.s f31, f2, f31                      ;
_l80:   bne x3, x14, _l192                        ;
_l81:   la x23, d_3_9                             ;
        lwu x15, -0(x23)                          ;
_l82:   ecall                                     ;
_l83:   fcvt.s.wu f13, x14, rtz                   ;
_l84:   srli x7, x24, 13                          ;
_l85:   sraw x20, x3, x16                         ;
_l86:   blt x24, x6, _l151                        ;
_l87:   la x30, d_3_10                            ;
        addi x30, x30, 8                          ;
        lr.d x1, (x30)                            ;
_l88:   slti x6, x10, -1364                       ;
_l89:   mulhu x2, x25, x26                        ;
_l90:   la x29, d_2_5                             ;
        ld x17, -8(x29)                           ;
_l91:   la x6, d_4_17                             ;
        lh x21, 12(x6)                            ;
_l92:   sraw x27, x3, x15                         ;
_l93:   bgeu x10, x16, _l166                      ;
_l94:   rem x28, x27, x11                         ;
_l95:   fnmsub.s f16, f9, f25, f5, rtz            ;
_l96:   bltu x6, x24, _l186                       ;
_l97:   la x7, _l180                              ;
        csrrw zero, sepc, x7                      ;
        sret                                      ;
_l98:   la x11, d_4_16                            ;
        lbu x19, -15(x11)                         ;
_l99:   la x16, d_0_15                            ;
        addi x16, x16, -24                        ;
        amoor.d x9, x29, (x16)                    ;
_l100:  fmul.s f31, f3, f9, rdn                   ;
_l101:  bltu x9, x16, _l129                       ;
_l102:  fcvt.s.lu f31, x10, dyn                   ;
_l103:  fmul.s f4, f26, f8, rup                   ;
_l104:  divu x16, x2, x11                         ;
_l105:  fclass.s x16, f13                         ;
_l106:  beq x5, x15, _l170                        ;
_l107:  la x8, d_2_19                             ;
        addi x8, x8, -24                          ;
        amomin.d x9, x30, (x8)                    ;
_l108:  auipc x5, 0                               ;
_l109:  la x27, d_0_26                            ;
        addi x27, x27, -24                        ;
        amoxor.d x27, x25, (x27)                  ;
_l110:  xor x20, x20, x20                         ;
        addi x21, zero, 1                         ;
        slli x21, x21, 16                         ;
        add x20, x20, x21                         ;
        csrrs x20, mepc, x20                      ;
_l111:  divuw x27, x25, x8                        ;
_l112:  la x3, d_5_4                              ;
        addi x3, x3, 0                            ;
        sc.d x21, x3, (x3)                        ;
_l113:  feq.s x12, f31, f30                       ;
_l114:  la x21, d_2_21                            ;
        addi x21, x21, -0                         ;
        amoswap.d x1, x22, (x21)                  ;
_l115:  fmv.x.w x9, f28                           ;
_l116:  fmin.s f0, f21, f29                       ;
_l117:  fcvt.s.wu f3, x3, rtz                     ;
_l118:  fdiv.s f19, f6, f30, rne                  ;
_l119:  la x2, d_3_0                              ;
        lw x5, 4(x2)                              ;
_l120:  la x7, d_1_0                              ;
        lb x19, -0(x7)                            ;
_l121:  srli x25, x8, 17                          ;
_l122:  fsgnjx.s f11, f13, f12                    ;
_l123:  la x20, d_2_25                            ;
        sd x19, -0(x20)                           ;
_l124:  slti x15, x1, -1458                       ;
_l125:  addi x18, x7, 1969                        ;
_l126:  la x16, d_3_19                            ;
        addi x16, x16, -12                        ;
        amoswap.w x14, x24, (x16)                 ;
_l127:  srliw x22, x24, 31                        ;
_l128:  ebreak                                    ;
_l129:  srlw x4, x8, x3                           ;
_l130:  lui x20, 1048575                          ;
_l131:  slli x16, x9, 33                          ;
_l132:  la x3, _l180                              ;
        csrrw zero, mepc, x3                      ;
        mret                                      ;
_l133:  fmin.s f22, f8, f4                        ;
_l134:  subw x22, x5, x25                         ;
_l135:  la x26, d_4_14                            ;
        addi x26, x26, 0                          ;
        lui x16, 0xffe00                          ;
        xor x26, x26, x16                         ;
        amomin.d x25, x16, (x26)                  ;
_l136:  li x14, 0                                 ;
        la x3, pt2                                ;
        addi x3, x3, 8                            ;
        sfence.vma x14, x3                        ;
_l137:  la x18, d_5_0                             ;
        addi x18, x18, 0                          ;
        sc.d x14, x18, (x18)                      ;
_l138:  xor x18, x18, x18                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 14                         ;
        add x18, x18, x23                         ;
        csrrc x22, mtval, x18                     ;
_l139:  la x26, _l38                              ;
        lbu x13, 11(x26)                          ;
_l140:  la x28, d_2_27                            ;
        addi x28, x28, -12                        ;
        amomaxu.w x27, x4, (x28)                  ;
_l141:  la x6, d_2_13                             ;
        lb x21, -31(x6)                           ;
_l142:  fdiv.s f1, f20, f28, rtz                  ;
_l143:  la x30, d_5_20                            ;
        lh x23, -12(x30)                          ;
_l144:  li x10, 1                                 ;
        la x22, pt1                               ;
        addi x22, x22, 24                         ;
        sfence.vma x10, x22                       ;
_l145:  blt x30, x16, _l154                       ;
_l146:  la x5, d_0_25                             ;
        flw f14, -28(x5)                          ;
_l147:  la x11, _l180                             ;
        jalr x12, 0(x11)                          ;
_l148:  fcvt.w.s x14, f11, dyn                    ;
_l149:  fcvt.s.l f19, x18, rdn                    ;
_l150:  div x0, x9, x2                            ;
_l151:  csrrsi x1, mip, 31                        ;
_l152:  mul x24, x11, x25                         ;
_l153:  remuw x14, x12, x29                       ;
_l154:  fsgnjx.s f4, f25, f19                     ;
_l155:  xori x12, x7, 1964                        ;
_l156:  la x21, d_2_1                             ;
        addi x21, x21, 16                         ;
        amoadd.d x10, x27, (x21)                  ;
_l157:  la x18, d_0_3                             ;
        addi x18, x18, 0                          ;
        amomax.d x20, x13, (x18)                  ;
_l158:  mulh x19, x6, x12                         ;
_l159:  la x29, _l180                             ;
        csrrw zero, sepc, x29                     ;
        sret                                      ;
_l160:  fcvt.s.wu f7, x20, dyn                    ;
_l161:  li x17, 0                                 ;
        la x24, pt0                               ;
        addi x24, x24, 0                          ;
        sfence.vma x17, x24                       ;
_l162:  fcvt.s.wu f5, x8, rmm                     ;
_l163:  la x11, d_1_26                            ;
        sd x6, -0(x11)                            ;
_l164:  la x25, d_0_18                            ;
        addi x25, x25, -16                        ;
        lr.d x19, (x25)                           ;
_l165:  jal x10, _l194                            ;
_l166:  fcvt.wu.s x13, f0, rdn                    ;
_l167:  fnmsub.s f0, f12, f9, f9, rne             ;
_l168:  la x29, d_5_14                            ;
        lui x14, 0xffe00                          ;
        xor x29, x29, x14                         ;
        ld x12, 24(x29)                           ;
_l169:  la x29, _l112                             ;
        lb x2, -23(x29)                           ;
_l170:  divuw x30, x22, x16                       ;
_l171:  la x19, d_2_1                             ;
        sh x24, 0(x19)                            ;
_l172:  fsgnjn.s f12, f27, f3                     ;
_l173:  feq.s x29, f26, f15                       ;
_l174:  auipc x8, 1048575                         ;
_l175:  srliw x22, x1, 22                         ;
_l176:  la x1, d_4_14                             ;
        sd x1, -0(x1)                             ;
_l177:  la x15, d_4_12                            ;
        addi x15, x15, -0                         ;
        lui x22, 0xffe00                          ;
        xor x15, x15, x22                         ;
        sc.d x28, x15, (x15)                      ;
_l178:  la x15, d_0_8                             ;
        addi x15, x15, -16                        ;
        amoswap.d x4, x13, (x15)                  ;
_l179:  la x7, d_2_7                              ;
        addi x7, x7, -0                           ;
        amominu.d x29, x22, (x7)                  ;
_l180:  la x28, d_1_15                            ;
        addi x28, x28, 16                         ;
        lui x29, 0xffe00                          ;
        xor x28, x28, x29                         ;
        amomax.d x21, x29, (x28)                  ;
_l181:  remu x16, x22, x16                        ;
_l182:  la x20, d_0_4                             ;
        sd x24, 8(x20)                            ;
_l183:  fnmsub.s f19, f16, f15, f25, rne          ;
_l184:  sllw x28, x13, x8                         ;
_l185:  la x8, d_5_23                             ;
        lh x18, -22(x8)                           ;
_l186:  fle.s x3, f6, f7                          ;
_l187:  fmsub.s f7, f4, f28, f29, dyn             ;
_l188:  remw x2, x25, x23                         ;
_l189:  la x15, d_4_16                            ;
        lb x6, -17(x15)                           ;
_l190:  la x18, d_3_16                            ;
        sd x12, -16(x18)                          ;
_l191:  la x4, d_2_15                             ;
        fsw f24, -20(x4)                          ;
_l192:  bne x3, x6, _l197                         ;
_l193:  remu x28, x27, x4                         ;
_l194:  fcvt.s.wu f28, x29, rdn                   ;
_l195:  fcvt.lu.s x26, f11, rdn                   ;
_l196:  fsgnjx.s f8, f26, f11                     ;
_l197:  fmax.s f26, f3, f14                       ;
_l198:  la x17, d_3_1                             ;
        addi x17, x17, 24                         ;
        amoand.w x11, x1, (x17)                   ;
_l199:  fence                                     ;
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
                .dword 0x14219b1112a8b196, 0x1433b4bb8560ffef
                .dword 0x916e4ee588a464d5, 0xa77ce0f18d9014fc
d_0_0:          .dword 0x49845db0465f308d, 0x92d6886e711f56a1
d_0_1:          .dword 0xabcc1fb7cfdbce80, 0x7ea2656c2f3832b8
d_0_2:          .dword 0x5b089c80145f15e4, 0x6a1db36281ed3549
d_0_3:          .dword 0xd5ac13feb1b9d0a1, 0xbc0ef4441d324765
d_0_4:          .dword 0x39c38e8f29c42263, 0xe49757a194f1122e
d_0_5:          .dword 0xfc8c77e153ed22da, 0xf21969d2c403a2e6
d_0_6:          .dword 0xac4cc0d04570a4fe, 0x432d415b76693761
d_0_7:          .dword 0xd3d2a00c19baacbb, 0x0e3d91cd1a2777e9
d_0_8:          .dword 0xae5a8796822006e2, 0x9473e2da61228cac
d_0_9:          .dword 0xaf19031f5c0df815, 0x11f18d908ee5675f
d_0_10:         .dword 0x9f61e0e896c4269b, 0x335df423d0421be8
d_0_11:         .dword 0xd96e2d9883769561, 0x7f4613cff582668c
d_0_12:         .dword 0x8ceb2b12138feedf, 0x1d30d4cc9f9ce304
d_0_13:         .dword 0x25527d7d3f58aa24, 0x8c607026099c7d26
d_0_14:         .dword 0x7993d113b317a5bb, 0x77818a5ad99cd1da
d_0_15:         .dword 0x4aa6fe6c5d658e1e, 0x3e1d6804ab33e45c
d_0_16:         .dword 0xbc4acbb9faee7ff4, 0x31050991e9fc51fe
d_0_17:         .dword 0xee20d0b530ba129f, 0x35a445bfad30481f
d_0_18:         .dword 0xd3f97bf7635b4ad1, 0xf82e2fa6b43b8d4e
d_0_19:         .dword 0x8045fcd261279f64, 0x2dfeef9ef539d363
d_0_20:         .dword 0x82c5034501039656, 0x1e2da85a4869cc4e
d_0_21:         .dword 0xf171f8076b90278c, 0x65c5a6619129a5f7
d_0_22:         .dword 0xdbd62b14a1a95418, 0x3ce5adfdf54dc23d
d_0_23:         .dword 0x0a3d3212aea38a55, 0xea5c2b1c8e608172
d_0_24:         .dword 0x6312ce56d1fdaebd, 0x18818eb75aa55d0b
d_0_25:         .dword 0x3898cf9016235538, 0x52fe663f919b97fc
d_0_26:         .dword 0xec7a99e95b4a9303, 0x022b0f5034310f9f
d_0_27:         .dword 0x40d57be0c47ea100, 0xb0bd4720c264551f
                .dword 0x14ad4229a9fbf7d7, 0xc7f65e91ad8c9b5a
                .dword 0x09f15da7a05d085f, 0xd67c3c5a581b0a6f
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xd6dc172e2bde97a6, 0xeb859d945af816df
                .dword 0xc4666f4e003c83d0, 0x9624436d77a3325e
d_1_0:          .dword 0xbbbe1c54771a7e2e, 0x4743e6ea4209ba93
d_1_1:          .dword 0x527ebbadfe76487b, 0xb6e1cbe331414bee
d_1_2:          .dword 0x2ec599dc39ed5125, 0xe9de8558dc13442b
d_1_3:          .dword 0xacd8f101e601766d, 0xfb4ba89c9fcec35c
d_1_4:          .dword 0x492acd78b7163b25, 0x1aabb83852efd03b
d_1_5:          .dword 0x982b52b080b9179d, 0x397efc581447d966
d_1_6:          .dword 0x4b69a869c2c06cf4, 0x2ae5477c4a1ed051
d_1_7:          .dword 0x3920dc3fd49d627f, 0xfa3d0466b57e1fa6
d_1_8:          .dword 0x963ee52657f3bfd2, 0x6118abadcdf82125
d_1_9:          .dword 0xf2f0e9d019769d1e, 0xeb4bdd5069d0e691
d_1_10:         .dword 0xba315dbeaf543a5e, 0x125dab37855247bc
d_1_11:         .dword 0x8dc18a6f24504fe2, 0x595f175bdc1f343c
d_1_12:         .dword 0x7fde44ccee4aa529, 0x9d60318e29e08f3c
d_1_13:         .dword 0xd3665ba7110ae353, 0x2e2a87da91d0d557
d_1_14:         .dword 0x2c947bf6ece70c3a, 0x4bd91e1b06b6d83d
d_1_15:         .dword 0xbd8d9785bcf2c3cf, 0x3b653f7f33554b6e
d_1_16:         .dword 0xe23771732da544d8, 0x6720d9d781cf632d
d_1_17:         .dword 0x0e05b5f1c410918c, 0xdb64a572c531ad62
d_1_18:         .dword 0x10018752b2b361ad, 0xfbff10974a48a789
d_1_19:         .dword 0x321878a902434347, 0x2f597c34cb629578
d_1_20:         .dword 0x7aca73085411b090, 0x9e359f536232b21f
d_1_21:         .dword 0x9bfe5e48712f2138, 0xe9a80cd7318ed64e
d_1_22:         .dword 0xadd35f360e13e9bd, 0x431f67b0962459e3
d_1_23:         .dword 0xcfa6ef2a1244e345, 0x4cfbbc07d6438924
d_1_24:         .dword 0x7cde5d96a525941e, 0x042117c693f7dcf8
d_1_25:         .dword 0x5bb6040e4db2ce5d, 0x7c203f4b30c14bb1
d_1_26:         .dword 0x8f3191776bbe8e04, 0xc6fc6a6b8d447988
d_1_27:         .dword 0xb42fe7c290e21535, 0x67c720e837a6861a
                .dword 0x1ac65489a263b20a, 0x355b078df4f4c147
                .dword 0x0e8d7fa691ea2cc8, 0x13a9135e0d8a7457
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xda90dcef214e56dc, 0x61c2d510e677302d
                .dword 0x6e21d55784d4f2b5, 0x6c6a3d988482eeb5
d_2_0:          .dword 0x2c42e80aff11d357, 0x698e87a830bac0f3
d_2_1:          .dword 0x64db7b497d60e4cd, 0x356063f38ab94b17
d_2_2:          .dword 0x37f3642348c5602a, 0xfde2bc28e6a55c6d
d_2_3:          .dword 0xbd33f359d483cc68, 0x8a3bc15605868777
d_2_4:          .dword 0xbebc0b0bc5dea172, 0xe130695f86980030
d_2_5:          .dword 0xcf208189a548b78c, 0xff1409ab7320a014
d_2_6:          .dword 0x5c351b8b3809ceca, 0xcd0d042e37f5fbf4
d_2_7:          .dword 0x2adf1599b57b5db6, 0x775deb5c45758a4d
d_2_8:          .dword 0x62e8646ce3b59a2e, 0xbe52786bf4d5c477
d_2_9:          .dword 0xee960a73d6a8eae0, 0x8ef2c0121b20cc39
d_2_10:         .dword 0x9cb2f0c54771f328, 0x1d5ef9e3cc2b4942
d_2_11:         .dword 0xb09a9bb01d645548, 0xcda3b336d7795846
d_2_12:         .dword 0xa48226a1573a0b40, 0xdb4e2832da1e2792
d_2_13:         .dword 0x22c828f86f8d036c, 0x772dc6665485be0d
d_2_14:         .dword 0x2d4fd3991aae3a25, 0xe4b4b42f2d6f6037
d_2_15:         .dword 0x783e7bfb0a8a2b62, 0xb46f2686585e7802
d_2_16:         .dword 0xb3240f62dbbd844f, 0x7554d215e527b504
d_2_17:         .dword 0xf42918a57ce675cd, 0x1d22c6a7b6f8e1de
d_2_18:         .dword 0xda7a807191e10e66, 0x0e7f405089688614
d_2_19:         .dword 0x672dac52ef7fadc8, 0x4f9b05016f0f84f3
d_2_20:         .dword 0xfabb1200a2b15d1e, 0x7704a1437e8b5d33
d_2_21:         .dword 0x0245e019d9f16770, 0x009530e68af9f92d
d_2_22:         .dword 0xe83a51ad7555bd19, 0x8d207f13260c0d53
d_2_23:         .dword 0xa3f8027917f5d6fb, 0xd0a96ce6f19b3d08
d_2_24:         .dword 0xab535a1c84a7fb7c, 0x18c3fb570a4a3258
d_2_25:         .dword 0x020bfd65d1c2e4e1, 0xa11fecbe2a114c59
d_2_26:         .dword 0xf9fce1684522cec5, 0x1f66add401261df0
d_2_27:         .dword 0x54b8995cbc384ac4, 0xfe54ec640ea12255
                .dword 0xb64a27f6f94b281d, 0x5b20a2c3bc5a1cef
                .dword 0xb5bad529b15aebbc, 0x41692e948e6d9b03
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xd0a8f42b43c10256, 0x1009973b84da66d5
                .dword 0xac05e7770a68d087, 0x36b1f35019552ef5
d_3_0:          .dword 0x11a66e1a6f6e2928, 0x2821b1846c1ff175
d_3_1:          .dword 0xac430fa49dac7068, 0x3bd53d46096e9a84
d_3_2:          .dword 0xb7a8255b8682e307, 0x2c579f7f7c404b6d
d_3_3:          .dword 0xc2f15a416cb78b2b, 0x5d73cdaf179445a7
d_3_4:          .dword 0x30348fe283523457, 0x9f034c52286f9d9f
d_3_5:          .dword 0xcbde70e259ffe8bd, 0x6bda24bd2956f3db
d_3_6:          .dword 0x1fca8f9ec32a4c65, 0x4307b2eb643657f6
d_3_7:          .dword 0x0402138780377f0d, 0xeb1093e87a2d498b
d_3_8:          .dword 0x3cd78e9849284593, 0x89ef153b37fa6606
d_3_9:          .dword 0x0c9fe521102ce0b5, 0x5c789cbca23b0638
d_3_10:         .dword 0x9e584937841c02e4, 0x43f1e1b009d750f6
d_3_11:         .dword 0x5b76206d738fafa8, 0x451cd8eabd72b8a6
d_3_12:         .dword 0xd9b974d56cfa19b2, 0x8e56f87d40e06334
d_3_13:         .dword 0x45bcc52867df0bed, 0x6ad36397a52fb091
d_3_14:         .dword 0xbeb3f03397cb1ec4, 0xfa92a3496b8c9f83
d_3_15:         .dword 0xa040b9a4cc2a025b, 0x24645e97534f11af
d_3_16:         .dword 0x349b7f9fdd801ab9, 0xf57c052d0d16f1d7
d_3_17:         .dword 0x39e14152618b9994, 0xdbf0adc6cd6316fe
d_3_18:         .dword 0x05014d882eff6cba, 0x1bbcc1c9390db008
d_3_19:         .dword 0xc39b9eac137fa475, 0x3f4d91ca106b1b8d
d_3_20:         .dword 0xb9172a729f226c95, 0xb4bc8781ab9b29b4
d_3_21:         .dword 0x0d5b40ec071801b4, 0x01f1eea17e34affc
d_3_22:         .dword 0xfedbda5819ddb5ba, 0x8f75553fe5cc54c3
d_3_23:         .dword 0xcd23de80034bbaf9, 0x2706dc4a4035888e
d_3_24:         .dword 0x4931b1f638d3eb60, 0x1a3c8cb188a3ec1b
d_3_25:         .dword 0x5ddfb0beaa53e123, 0xad2a96f58b3cfb02
d_3_26:         .dword 0x785b95baa0a769c2, 0x592ce21b950598ad
d_3_27:         .dword 0x11afb13fcda0c0f2, 0xfbfe45390b0359c5
                .dword 0x28356c0e8220a6fc, 0xbae8055c28fa7a0b
                .dword 0x630eb8a21ab9a597, 0x049a194462ff72af
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5eeb844bebea6c1d, 0xedaaeaf37046f418
                .dword 0xa548d4bc6c0e393d, 0x40ca4ea54fadc7ef
d_4_0:          .dword 0xfecd9b06f1d1296b, 0x06d596edd67b12d8
d_4_1:          .dword 0x1558e4738b09d60a, 0xf6e8de5fa08ab6a3
d_4_2:          .dword 0x591dd86e4b6952d2, 0x896f250743f2cb36
d_4_3:          .dword 0x0c4a3dc940f933d4, 0xc492a2a40ac86456
d_4_4:          .dword 0x9e36494ad6dfeb5d, 0xfaf201e91c511dea
d_4_5:          .dword 0xb8f50119851cc914, 0xacb4deee3e0b22fc
d_4_6:          .dword 0x0c2dca92e646db7e, 0x48bcd9f0e126c86d
d_4_7:          .dword 0xd06ae953242cdf70, 0x34f005fad810a4ab
d_4_8:          .dword 0xfcf49473851cb81b, 0xc19441afe9dd93ce
d_4_9:          .dword 0x29a86b27be6af0ba, 0x9dae430585de4a66
d_4_10:         .dword 0x80e6ec756e3eb8ba, 0xbb99ef50a03de58b
d_4_11:         .dword 0x22eceb9106568e91, 0xf363c0cfeead3388
d_4_12:         .dword 0x0e1b38d88289b315, 0xfdccba12fb8efa57
d_4_13:         .dword 0xf1392c43b431540d, 0xcd707345730a44f2
d_4_14:         .dword 0x9f557604133b3828, 0x6f1524228f798c67
d_4_15:         .dword 0x3bc3a697e169571f, 0x84183d65613e61fa
d_4_16:         .dword 0x8349e7181a9fb027, 0xc64047d1daba80e7
d_4_17:         .dword 0x6f690dfa1e89e1fc, 0x8fa2a7f0bee5634a
d_4_18:         .dword 0x727c3ef190d9a52b, 0xd152f971f20f62ea
d_4_19:         .dword 0x0aa0e2191d739d8a, 0x9fa9c5c21e2f36a2
d_4_20:         .dword 0x27baa028d5b34140, 0xe03cb093e35e87a9
d_4_21:         .dword 0xfd3e3f5f2deeed10, 0xba8da4a192dea536
d_4_22:         .dword 0x1ddf94398883b1f0, 0x282072bf48a13af0
d_4_23:         .dword 0xc17cdcca43cf0e8b, 0x780d8c67b7dd7838
d_4_24:         .dword 0x8524d7ee1ca867f1, 0x50bdc48ae1254d3e
d_4_25:         .dword 0x0ce0635dd9518bfe, 0x1c9c4de0c8e2101e
d_4_26:         .dword 0x9413f3aec85f13c4, 0x7a2ad8f46c834528
d_4_27:         .dword 0x2a1cc7899e663e0e, 0xb39741f9561828e2
                .dword 0x5726cae3301a6e21, 0xd1c8b252531b55e1
                .dword 0x6122df8597a5ec34, 0x23e123c20d5eb81b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xac97e46595b1ae99, 0xd0c888f25827bc8d
                .dword 0x14964f47316894ea, 0xd6340c5a16050930
d_5_0:          .dword 0x5e1688a5de998a36, 0x8f00cda9be6f9358
d_5_1:          .dword 0x6610e98d791daaf9, 0x698a505a8d71592e
d_5_2:          .dword 0xf9fe5451480fa3eb, 0xff40b1901e7b40be
d_5_3:          .dword 0x26bf34216da1d84f, 0x00f9f09e1f5639ac
d_5_4:          .dword 0xf369526f222ce550, 0xfdb2f1ad9692d40b
d_5_5:          .dword 0x334ecdec272c24b2, 0xcbeb45dc5633a315
d_5_6:          .dword 0x66ad705fda0e00e5, 0xc9a32ae47d88e9b7
d_5_7:          .dword 0x439a4542a89e7434, 0x9b3d7259eb32962d
d_5_8:          .dword 0x72d2f260c30b92cb, 0x0e5bec8c63fd8b81
d_5_9:          .dword 0x75d02b29ad83d18f, 0xc2548b66e291e987
d_5_10:         .dword 0x923450384afbf43f, 0xfcd25c62fbcf1c20
d_5_11:         .dword 0x40de48d1df1ba673, 0xdb39a34a3ad905ee
d_5_12:         .dword 0x67aae0dd707b1201, 0xd129d3347ee112df
d_5_13:         .dword 0xbc073dd1982a1d67, 0xed57d86c5a2e6439
d_5_14:         .dword 0x497977df69c14ca7, 0x61f9c41875b2e5ef
d_5_15:         .dword 0xc9f2391825a61a35, 0x6d4b1ecb7b820e88
d_5_16:         .dword 0x8f6bff14ef2f4492, 0x294c5d93ee8f411f
d_5_17:         .dword 0x94da145ad95cd0e3, 0xa9e7a535cff30530
d_5_18:         .dword 0x66a629f79bb419b0, 0x98ff21a1bc644d21
d_5_19:         .dword 0x5d22339456beae52, 0x0a0e8a56c47a5647
d_5_20:         .dword 0x3a34786e3c4bc3f5, 0x64cfea5f3c9cf2f2
d_5_21:         .dword 0x0ff756c7742f4d2c, 0x873871055521cda0
d_5_22:         .dword 0x9c77022132a3c64e, 0x7ae005514b5e4d48
d_5_23:         .dword 0x0ebf9ee22df29f7d, 0x5141391873d6f6ff
d_5_24:         .dword 0xcaaa24db7befe3a0, 0x702070a0b9c72af1
d_5_25:         .dword 0x4b405ad6c4a9c44f, 0x0228218d6b694fdc
d_5_26:         .dword 0xc82765ede53f4376, 0xf7fce0d37f10b7db
d_5_27:         .dword 0x4da9267239d75d04, 0x3bd2e6b90dc20036
                .dword 0x2933ebb3310674cb, 0x2001ba0dd90190d5
                .dword 0x83897f94f1fabc61, 0xb2efc5fe0ac190fb
         /* Random data */
_end_data5:
              
 
