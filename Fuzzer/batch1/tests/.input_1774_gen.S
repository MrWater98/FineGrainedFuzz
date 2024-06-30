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
_p0:    xor x13, x13, x13                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 3                          ;
        add x13, x13, x10                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 7                          ;
        add x13, x13, x12                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 16                         ;
        add x13, x13, x14                         ;
        csrrw x12, pmpcfg0, x13                   ;
_p1:    csrrwi x10, sip, 25                       ;
_p2:    csrrci x14, pmpaddr1, 9                   ;
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
_s0:    fmv.w.x f24, x29                          ;
_s1:    la x6, d_0_7                              ;
        addi x6, x6, -24                          ;
        amoand.w x29, x25, (x6)                   ;
_s2:    la x6, d_3_20                             ;
        addi x6, x6, -28                          ;
        sc.w x28, x22, (x6)                       ;
_s3:    sllw x0, x27, x22                         ;
_s4:    la x27, d_3_5                             ;
        addi x27, x27, 16                         ;
        amoor.d x1, x13, (x27)                    ;
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
_l0:    mulhu x0, x0, x19                         ;
_l1:    la x14, d_5_9                             ;
        flw f26, 16(x14)                          ;
_l2:    andi x18, x22, -0                         ;
_l3:    bge x13, x4, _l52                         ;
_l4:    fmv.x.w x2, f7                            ;
_l5:    xor x20, x20, x20                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 20                         ;
        add x20, x20, x14                         ;
        csrrw x15, mie, x20                       ;
_l6:    feq.s x9, f9, f5                          ;
_l7:    fsgnjn.s f22, f5, f16                     ;
_l8:    sraiw x15, x18, 29                        ;
_l9:    la x10, d_0_17                            ;
        addi x10, x10, -0                         ;
        amomin.w x14, x2, (x10)                   ;
_l10:   la x6, _l32                               ;
        csrrw zero, uepc, x6                      ;
        uret                                      ;
_l11:   la x20, d_1_9                             ;
        lb x7, -17(x20)                           ;
_l12:   ecall                                     ;
_l13:   srai x3, x22, 0                           ;
_l14:   la x13, d_2_24                            ;
        addi x13, x13, 0                          ;
        sc.d x6, x13, (x13)                       ;
_l15:   fdiv.s f11, f17, f24, rtz                 ;
_l16:   srli x3, x13, 7                           ;
_l17:   div x12, x7, x18                          ;
_l18:   fsub.s f17, f24, f11, rne                 ;
_l19:   la x12, d_3_7                             ;
        addi x12, x12, -12                        ;
        lui x16, 0xffe00                          ;
        xor x12, x12, x16                         ;
        amoor.w x9, x16, (x12)                    ;
_l20:   la x15, d_5_16                            ;
        srai x15, x15, 1                          ;
        csrrw x24, pmpaddr6, x15                  ;
_l21:   fcvt.lu.s x13, f9, rdn                    ;
_l22:   la x30, _l33                              ;
        flw f3, 24(x30)                           ;
_l23:   beq x21, x17, _l76                        ;
_l24:   fmv.x.w x9, f8                            ;
_l25:   fcvt.l.s x26, f26, rtz                    ;
_l26:   divuw x10, x7, x30                        ;
_l27:   bltu x3, x12, _l100                       ;
_l28:   subw x28, x27, x6                         ;
_l29:   jal x2, _l189                             ;
_l30:   sltiu x14, x22, 52                        ;
_l31:   la x7, d_0_19                             ;
        addi x7, x7, -24                          ;
        amomin.w x24, x17, (x7)                   ;
_l32:   addi x18, x7, -9                          ;
_l33:   la x17, d_2_25                            ;
        flw f13, 12(x17)                          ;
_l34:   fsgnjx.s f13, f10, f11                    ;
_l35:   addw x29, x29, x4                         ;
_l36:   la x2, d_4_14                             ;
        lui x30, 0xffe00                          ;
        xor x2, x2, x30                           ;
        lb x13, 13(x2)                            ;
_l37:   la x20, d_1_25                            ;
        addi x20, x20, -4                         ;
        amomaxu.w x25, x15, (x20)                 ;
_l38:   slliw x19, x29, 31                        ;
_l39:   la x3, d_3_7                              ;
        addi x3, x3, -0                           ;
        amomaxu.d x6, x7, (x3)                    ;
_l40:   srlw x17, x24, x26                        ;
_l41:   fsqrt.s f19, f24, dyn                     ;
_l42:   fadd.s f25, f12, f10, rdn                 ;
_l43:   la x29, d_5_0                             ;
        addi x29, x29, 0                          ;
        amoswap.d x23, x12, (x29)                 ;
_l44:   csrrci x21, frm, 12                       ;
_l45:   divw x10, x30, x21                        ;
_l46:   la x29, d_0_26                            ;
        addi x29, x29, 16                         ;
        amoadd.d x22, x28, (x29)                  ;
_l47:   beq x14, x25, _l55                        ;
_l48:   mulw x1, x0, x7                           ;
_l49:   addiw x3, x13, 1124                       ;
_l50:   fence                                     ;
_l51:   slliw x0, x1, 31                          ;
_l52:   la x11, d_5_23                            ;
        addi x11, x11, 0                          ;
        lr.d x9, (x11)                            ;
_l53:   fmax.s f29, f17, f5                       ;
_l54:   rem x30, x23, x0                          ;
_l55:   fsqrt.s f10, f16, rdn                     ;
_l56:   fcvt.w.s x22, f25, rne                    ;
_l57:   la x14, d_4_6                             ;
        addi x14, x14, -4                         ;
        lr.w x10, (x14)                           ;
_l58:   mulhsu x25, x15, x21                      ;
_l59:   lui x8, 12                                ;
_l60:   la x1, d_2_5                              ;
        addi x1, x1, -0                           ;
        amomin.d x22, x19, (x1)                   ;
_l61:   la x12, d_4_19                            ;
        addi x12, x12, -4                         ;
        sc.w x13, x8, (x12)                       ;
_l62:   fcvt.s.w f25, x19, rmm                    ;
_l63:   fmv.w.x f25, x2                           ;
_l64:   divuw x8, x20, x3                         ;
_l65:   fcvt.lu.s x19, f21, rmm                   ;
_l66:   la x16, d_2_17                            ;
        addi x16, x16, 12                         ;
        lr.w x14, (x16)                           ;
_l67:   csrrci x6, mhartid, 0                     ;
_l68:   slli x30, x12, 0                          ;
_l69:   fdiv.s f10, f2, f25, rne                  ;
_l70:   ebreak                                    ;
_l71:   fcvt.s.wu f30, x20, rne                   ;
_l72:   la x20, d_0_22                            ;
        sd x2, -16(x20)                           ;
_l73:   fcvt.l.s x19, f21, rdn                    ;
_l74:   slliw x13, x1, 8                          ;
_l75:   la x19, d_0_12                            ;
        addi x19, x19, 0                          ;
        amoor.d x3, x30, (x19)                    ;
_l76:   fle.s x21, f4, f28                        ;
_l77:   la x17, d_1_12                            ;
        sw x23, -0(x17)                           ;
_l78:   sltiu x28, x2, -509                       ;
_l79:   la x9, _l192                              ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l80:   fcvt.wu.s x12, f31, rmm                   ;
_l81:   fcvt.s.wu f26, x26, rne                   ;
_l82:   sraiw x3, x3, 15                          ;
_l83:   sraw x11, x26, x7                         ;
_l84:   li x5, 1                                  ;
        la x25, pt0                               ;
        addi x25, x25, 24                         ;
        sfence.vma x5, x25                        ;
_l85:   fsgnjx.s f27, f24, f23                    ;
_l86:   srlw x30, x2, x1                          ;
_l87:   addiw x6, x0, 1962                        ;
_l88:   mulhu x4, x6, x30                         ;
_l89:   slti x2, x8, 1907                         ;
_l90:   la x9, _l112                              ;
        csrrw zero, uepc, x9                      ;
        uret                                      ;
_l91:   remu x28, x21, x26                        ;
_l92:   la x27, d_5_20                            ;
        addi x27, x27, 16                         ;
        lui x18, 0xffe00                          ;
        xor x27, x27, x18                         ;
        amoxor.d x20, x18, (x27)                  ;
_l93:   bge x26, x17, _l153                       ;
_l94:   fsgnjx.s f7, f16, f5                      ;
_l95:   xori x21, x16, -1962                      ;
_l96:   divuw x9, x30, x29                        ;
_l97:   sllw x9, x20, x15                         ;
_l98:   srli x10, x10, 0                          ;
_l99:   la x4, d_1_15                             ;
        addi x4, x4, 28                           ;
        amomaxu.w x20, x8, (x4)                   ;
_l100:  beq x10, x21, _l166                       ;
_l101:  blt x2, x16, _l185                        ;
_l102:  xor x10, x10, x10                         ;
        csrrw x11, mhartid, x10                   ;
_l103:  fdiv.s f4, f14, f24, rmm                  ;
_l104:  la x28, d_2_15                            ;
        lwu x24, -0(x28)                          ;
_l105:  subw x4, x23, x10                         ;
_l106:  fcvt.s.w f10, x13, dyn                    ;
_l107:  lui x2, 1907                              ;
_l108:  la x22, d_3_21                            ;
        addi x22, x22, 24                         ;
        sc.d x29, x22, (x22)                      ;
_l109:  remuw x25, x15, x9                        ;
_l110:  la x5, d_4_9                              ;
        addi x5, x5, -0                           ;
        sc.w x21, x12, (x5)                       ;
_l111:  la x7, d_4_16                             ;
        addi x7, x7, -28                          ;
        lui x2, 0xffe00                           ;
        xor x7, x7, x2                            ;
        amomin.w x9, x2, (x7)                     ;
_l112:  remu x9, x3, x29                          ;
_l113:  fclass.s x21, f8                          ;
_l114:  blt x25, x25, _l166                       ;
_l115:  la x29, d_2_26                            ;
        sb x4, 31(x29)                            ;
_l116:  la x9, _l152                              ;
        lwu x3, 0(x9)                             ;
_l117:  fmax.s f30, f7, f14                       ;
_l118:  la x1, d_2_10                             ;
        addi x1, x1, 20                           ;
        amomin.w x26, x1, (x1)                    ;
_l119:  la x6, d_3_8                              ;
        addi x6, x6, -0                           ;
        amoswap.d x22, x14, (x6)                  ;
_l120:  fsub.s f16, f18, f29, dyn                 ;
_l121:  la x22, d_0_8                             ;
        ld x29, -0(x22)                           ;
_l122:  auipc x8, 991632                          ;
_l123:  fmv.x.w x13, f18                          ;
_l124:  srli x10, x0, 12                          ;
_l125:  remu x28, x10, x10                        ;
_l126:  srli x28, x28, 10                         ;
_l127:  mulhsu x24, x2, x18                       ;
_l128:  flt.s x8, f17, f5                         ;
_l129:  la x23, d_4_2                             ;
        addi x23, x23, -16                        ;
        amomin.w x30, x10, (x23)                  ;
_l130:  la x27, d_1_22                            ;
        addi x27, x27, 8                          ;
        amoor.d x29, x21, (x27)                   ;
_l131:  fmv.w.x f28, x24                          ;
_l132:  fcvt.l.s x24, f20, rup                    ;
_l133:  srli x24, x10, 63                         ;
_l134:  la x14, d_5_22                            ;
        lw x14, 20(x14)                           ;
_l135:  addi x10, x4, -0                          ;
_l136:  la x14, d_2_19                            ;
        addi x14, x14, -0                         ;
        amoxor.w x22, x11, (x14)                  ;
_l137:  la x20, d_2_21                            ;
        addi x20, x20, 0                          ;
        amoswap.w x22, x19, (x20)                 ;
_l138:  srli x3, x1, 0                            ;
_l139:  fle.s x2, f22, f26                        ;
_l140:  andi x2, x2, -849                         ;
_l141:  mulhu x17, x22, x0                        ;
_l142:  fence.i                                   ;
_l143:  addi x12, x20, -1348                      ;
_l144:  fsgnj.s f9, f10, f0                       ;
_l145:  la x23, d_0_6                             ;
        addi x23, x23, 12                         ;
        sc.w x12, x7, (x23)                       ;
_l146:  remw x25, x7, x24                         ;
_l147:  divuw x0, x6, x10                         ;
_l148:  la x13, d_4_13                            ;
        addi x13, x13, -0                         ;
        amomaxu.w x16, x27, (x13)                 ;
_l149:  la x17, d_5_4                             ;
        sw x4, 8(x17)                             ;
_l150:  xori x22, x9, 725                         ;
_l151:  la x23, d_4_5                             ;
        addi x23, x23, -0                         ;
        sc.w x24, x21, (x23)                      ;
_l152:  addi x6, x30, -1762                       ;
_l153:  ebreak                                    ;
_l154:  la x22, d_0_10                            ;
        addi x22, x22, -0                         ;
        amoxor.d x25, x8, (x22)                   ;
_l155:  la x17, d_5_11                            ;
        addi x17, x17, -0                         ;
        amoor.d x30, x24, (x17)                   ;
_l156:  fsub.s f20, f17, f24, rdn                 ;
_l157:  la x25, d_0_6                             ;
        addi x25, x25, 8                          ;
        lr.d x11, (x25)                           ;
_l158:  fmin.s f13, f25, f19                      ;
_l159:  slti x15, x9, -948                        ;
_l160:  remu x25, x19, x30                        ;
_l161:  fmv.w.x f30, x12                          ;
_l162:  srai x5, x15, 22                          ;
_l163:  la x27, d_2_10                            ;
        addi x27, x27, -0                         ;
        amominu.d x11, x10, (x27)                 ;
_l164:  addiw x3, x11, 29                         ;
_l165:  la x28, d_3_2                             ;
        addi x28, x28, 0                          ;
        amomin.w x30, x30, (x28)                  ;
_l166:  la x22, d_4_1                             ;
        addi x22, x22, 16                         ;
        amoor.w x20, x3, (x22)                    ;
_l167:  la x23, d_3_3                             ;
        addi x23, x23, 8                          ;
        amoxor.w x25, x24, (x23)                  ;
_l168:  mulhsu x28, x4, x18                       ;
_l169:  fnmsub.s f3, f12, f12, f16, rtz           ;
_l170:  xor x1, x1, x1                            ;
        addi x19, zero, 3                         ;
        slli x19, x19, 22                         ;
        add x1, x1, x19                           ;
        addi x13, zero, 3                         ;
        slli x13, x13, 0                          ;
        add x1, x1, x13                           ;
        csrrc x20, fflags, x1                     ;
_l171:  fcvt.s.w f3, x4, rmm                      ;
_l172:  fclass.s x25, f5                          ;
_l173:  slli x7, x21, 14                          ;
_l174:  fcvt.lu.s x11, f16, rmm                   ;
_l175:  srli x19, x27, 31                         ;
_l176:  lui x0, 234326                            ;
_l177:  mul x24, x24, x2                          ;
_l178:  la x6, d_3_2                              ;
        flw f3, -28(x6)                           ;
_l179:  csrrsi x7, sscratch, 7                    ;
_l180:  rem x2, x28, x19                          ;
_l181:  remw x0, x3, x20                          ;
_l182:  la x27, d_1_0                             ;
        addi x27, x27, 0                          ;
        lui x29, 0xffe00                          ;
        xor x27, x27, x29                         ;
        amomin.w x1, x29, (x27)                   ;
_l183:  la x1, d_5_26                             ;
        sb x17, -10(x1)                           ;
_l184:  bgeu x23, x30, _l192                      ;
_l185:  fcvt.w.s x8, f9, rtz                      ;
_l186:  srlw x13, x28, x15                        ;
_l187:  bgeu x27, x12, _l198                      ;
_l188:  fnmadd.s f7, f31, f22, f14, rup           ;
_l189:  addi x17, x26, 13                         ;
_l190:  la x11, _l195                             ;
        jalr x30, 0(x11)                          ;
_l191:  la x25, d_5_14                            ;
        addi x25, x25, -0                         ;
        amomax.d x28, x8, (x25)                   ;
_l192:  la x14, d_4_0                             ;
        sw x29, 16(x14)                           ;
_l193:  lui x16, 696786                           ;
_l194:  bge x3, x7, _l196                         ;
_l195:  sraw x22, x23, x4                         ;
_l196:  csrrci x25, satp, 27                      ;
_l197:  fcvt.s.l f13, x16, rne                    ;
_l198:  fcvt.s.wu f31, x22, rdn                   ;
_l199:  bgeu x17, x15, _l200                      ;
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
                .dword 0x3b7e0a6c6389602b, 0x322bcfb91baf23df
                .dword 0xc395f37ceba8bc5c, 0x7505c36115b6e031
d_0_0:          .dword 0xd6b09039e9bd53c1, 0xb344c3bfb20937cb
d_0_1:          .dword 0x58067ea463d00106, 0x3c40b02321a940c8
d_0_2:          .dword 0xef191976f394e921, 0x3f25b2d79fd3e8b0
d_0_3:          .dword 0x26a76713064cfba1, 0xcb7fd5f6155fbb29
d_0_4:          .dword 0xd7b2ae128c76ae3c, 0x3f4f77f2c00575c9
d_0_5:          .dword 0x005facc79c21782a, 0x1e833c22d1d46113
d_0_6:          .dword 0x8703ca2acd3e9cae, 0x1dbb3d7da00b7899
d_0_7:          .dword 0x62c682c71a94867e, 0x0843f8f483ef48c4
d_0_8:          .dword 0x770f720f3b512a86, 0xeeee08487b09102e
d_0_9:          .dword 0x0f8e1db7289abf98, 0xc1a18fcd0e6c2133
d_0_10:         .dword 0x0b80365ea264302e, 0xc6132a5c793b967d
d_0_11:         .dword 0xfcdc93cb2f17a228, 0xd14fc37a9b89a31f
d_0_12:         .dword 0x679d639c840c546d, 0x80da0887c7c67e07
d_0_13:         .dword 0xbd3549f21d97c8bd, 0x87bca7978fb3a41d
d_0_14:         .dword 0x8d372689bca56234, 0x30bef1997987088a
d_0_15:         .dword 0xaa918cfd5df78572, 0x08a14c52f7f48109
d_0_16:         .dword 0x1cce4ad8ac8ce21f, 0x8fac8527ec3840b9
d_0_17:         .dword 0xc9331bdedf94f502, 0xa94cf6a12147473c
d_0_18:         .dword 0x3da4250c0254124f, 0xab89bc1298c6e1ae
d_0_19:         .dword 0x1ca01c63d28e7a79, 0x49211a0d930f7bbc
d_0_20:         .dword 0x885252647f1eaa9f, 0x288436f9c25d2270
d_0_21:         .dword 0xc5f626256dec48bd, 0x02ebcd4c37d62d25
d_0_22:         .dword 0x0f89dcdaf33d48f1, 0x7f425f3f21abec0f
d_0_23:         .dword 0x53a2ed55bedb0c9b, 0x5cc61c6d68d7afd2
d_0_24:         .dword 0xfe96c6e545781dab, 0xddcf9fc9bd701edd
d_0_25:         .dword 0x092c94f898aea1bf, 0xc94cf4e4a0888886
d_0_26:         .dword 0x2428d000c2419ce4, 0x04a6e4bc1fbc0eb7
d_0_27:         .dword 0xe148c1e648ef7981, 0x30adf3514fc79105
                .dword 0xd312fee0df866e0c, 0x889823c84a86da85
                .dword 0x40c7f911ce760298, 0xf4dd226ff427837c
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x7252523bc5269ca0, 0x92540b48f9312546
                .dword 0x94bd2b2831589206, 0x4426127fc1779ac7
d_1_0:          .dword 0xf05cb58caeba8482, 0x452560169b3210c7
d_1_1:          .dword 0x27ed9313f0ab2911, 0xee87a48f917f0358
d_1_2:          .dword 0x799db01fa9198875, 0xe8e021b8070eaf76
d_1_3:          .dword 0xd845da5de5fd03dd, 0x0bda3f26c5e7eb93
d_1_4:          .dword 0x06ba4e2f4dc03f9e, 0x4a81e8b6c2055816
d_1_5:          .dword 0x9af6ff2f1f4f93d2, 0x5a08b3b98b6666ac
d_1_6:          .dword 0x93fe0156a6ab389f, 0xd631e5c618650d95
d_1_7:          .dword 0xed4930cf5a522c58, 0x57e342a44cef68df
d_1_8:          .dword 0x39a0dbc1e59ebdea, 0x95d979a9421d4b4b
d_1_9:          .dword 0xd2467d202f4c3e1d, 0xf7e6be687986b0a8
d_1_10:         .dword 0xe2c246e8a1d23a6f, 0x64df306b37d39a9d
d_1_11:         .dword 0xfd46dae9a9d23d07, 0x3e99adad4d596fb8
d_1_12:         .dword 0xa27e1adc4d806a0c, 0xc04325889abdc372
d_1_13:         .dword 0x2fca8494e24945c8, 0x1b3573368884e080
d_1_14:         .dword 0xfc98b25a1e5555cf, 0x56836495fa60d655
d_1_15:         .dword 0x9318855c6b4fe737, 0xd637216d954e9c1e
d_1_16:         .dword 0x6e2186ace052bda7, 0x4c9eba7b20544e9d
d_1_17:         .dword 0xdd43207f81e66816, 0x41806860c72ca6ea
d_1_18:         .dword 0xc84e7406b8d8abad, 0xa1751be3a068ed34
d_1_19:         .dword 0x45ae7d673dd6917c, 0x8ec19dd1eb629129
d_1_20:         .dword 0xb8e9f15ab29a21d5, 0xf88c485603c9d4b7
d_1_21:         .dword 0xf1436099c5623a70, 0xfbef7d648b531a24
d_1_22:         .dword 0xb062f081299b1407, 0x15f35b7dc0ae4ee3
d_1_23:         .dword 0xa724d80ed4279703, 0xf3396cbe9807f25d
d_1_24:         .dword 0x1c076888c3965127, 0xd62c7bbe58b42033
d_1_25:         .dword 0x02780b88c3298141, 0x44c4232a958a10fe
d_1_26:         .dword 0xe8e24c1146fb5b3a, 0xbec4dd0aadcd4b0e
d_1_27:         .dword 0xcc43b3aa0d1b2bae, 0x7faf1c68534de4ab
                .dword 0x15346aaf7e002f78, 0xff3d88efed10d232
                .dword 0xebce1b46986b59d3, 0x97ecb85c6275b866
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd60b430fa501dc9e, 0x1f57b08487362103
                .dword 0xfc2f3b25892523d8, 0x693c62083152c525
d_2_0:          .dword 0x1a2736159275760c, 0xbd4c27628a7fda22
d_2_1:          .dword 0xe4283eb5477e2733, 0x3f93098d523c882f
d_2_2:          .dword 0x87a2c8ee80655152, 0x61b644a838ce2d88
d_2_3:          .dword 0xf3b5428c5c822a86, 0xff382481499613fe
d_2_4:          .dword 0x53fdc3981799eada, 0xbeab0b657f40e9f0
d_2_5:          .dword 0x7e42a9b138611dd6, 0x1855e1c959226a5a
d_2_6:          .dword 0x3ba7b116678e36ca, 0xdb02f7a6a93b7e09
d_2_7:          .dword 0x739fd159c990f64b, 0xbc914af955d23a78
d_2_8:          .dword 0x8183a2163c11ae5f, 0xb8b0329b69d1b504
d_2_9:          .dword 0x30fdaba56b36005a, 0x82ba95fb70927ede
d_2_10:         .dword 0xbf7dd649eff5911f, 0x4be3f48deb2098dd
d_2_11:         .dword 0x49e0b39de877a39b, 0xaab999b9f8734412
d_2_12:         .dword 0x1c26d91e0a3da9cb, 0x9edc6bedee7d7f85
d_2_13:         .dword 0x3dd6903cd850e224, 0x177533c012fb8414
d_2_14:         .dword 0xc5cdd05c5ec6eb96, 0xc4770dce58fd0d50
d_2_15:         .dword 0x02f2096ae85499fe, 0xa090da02cacfd2ca
d_2_16:         .dword 0x849c6ca0f9cd5373, 0xe5ee1de9e8855671
d_2_17:         .dword 0x0a6e0e8a04f84210, 0xe21add1b722fa9b8
d_2_18:         .dword 0x82bae296f2ca5ca6, 0xbeb36bac5e7d924f
d_2_19:         .dword 0x34ff947272053dd3, 0xeb1bdf870e0b5a7f
d_2_20:         .dword 0x97056b0e27dac28a, 0xbdc86559e42ab0ea
d_2_21:         .dword 0x23d30d2d72b0ce1b, 0x6aecdca1e487b550
d_2_22:         .dword 0x76914d5ad333e668, 0x26e98fb5bdbaa164
d_2_23:         .dword 0x8b8faee2fe6d5707, 0x965095242d68c458
d_2_24:         .dword 0x68a9274632378f23, 0x7999dca9f610fa3f
d_2_25:         .dword 0x661843dd9550e3af, 0x3ba82a3cb95ac91c
d_2_26:         .dword 0x56b84e386cad5142, 0x14a6060ca3f882b7
d_2_27:         .dword 0x6a509680ad2e9e84, 0x965e5461aa51a9cd
                .dword 0x885f90ee17d0848e, 0x8757bb06d46d0fd2
                .dword 0x6c4e5cd366f0e5f8, 0x5348f017f9c16c4d
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xcba2da94da037883, 0x9ea31d76826ec20f
                .dword 0xf87915c41369a67f, 0xbeca70791f07d945
d_3_0:          .dword 0x56a41ba97d1777b2, 0x5812341f33e0e9a2
d_3_1:          .dword 0x44b739eb320f6a73, 0x0951af0b99378043
d_3_2:          .dword 0xb1414a0c668bdd56, 0x9905bc5f431eb7e8
d_3_3:          .dword 0x9e17876960240b20, 0x4ab0721e73d2e6c3
d_3_4:          .dword 0x2fb3a0d87658c9fd, 0x4c880b8128a6a404
d_3_5:          .dword 0xf4dcd7174eed7781, 0x623a9d16eabdb53e
d_3_6:          .dword 0xe5b80a2d41ab1048, 0xe2aa9b94ab5f2cd2
d_3_7:          .dword 0xb65402d2577c24f2, 0x0b95aabb501dcc5d
d_3_8:          .dword 0x97f77317fa00ce6a, 0xce4a2d7b0cef01a1
d_3_9:          .dword 0xd2029df386bf8f07, 0xd0b96869402ce3e9
d_3_10:         .dword 0x3f942044f17c8f5d, 0xaafdbc2e851c4b95
d_3_11:         .dword 0xeecdf6229c3117a3, 0xe7b34e7706401ef2
d_3_12:         .dword 0x565e1baa379b10cc, 0x3c5bed448fb880bc
d_3_13:         .dword 0x63fb775cd18a0359, 0xfd85147d67c7ae05
d_3_14:         .dword 0x46941bbde5e1aa3e, 0x46f6c81bc0f51c00
d_3_15:         .dword 0x4a13914e25e150fd, 0x8a7e4114ed756d08
d_3_16:         .dword 0xf79c834ae1d3ac29, 0xe0b078656d371292
d_3_17:         .dword 0x4bcfa74c06bbd3a6, 0x78e0451d545b7f24
d_3_18:         .dword 0x9612ae8c400f1354, 0x59f0522e0d7893ba
d_3_19:         .dword 0x3af453a5f21635ee, 0xc4d5a82a080ba963
d_3_20:         .dword 0x2b52580be32a243a, 0xef9fdabf9e3b104a
d_3_21:         .dword 0x24fcd6129cc5f3dc, 0xccaa9c03c26d7cd1
d_3_22:         .dword 0x2a8b9e550b7d510f, 0xf78247bc0797dfb9
d_3_23:         .dword 0x1b8813a04ca62d14, 0x1accd74e3c6d57aa
d_3_24:         .dword 0xe54654656996bd59, 0x6dad285c3a51bdcc
d_3_25:         .dword 0x7fd65051b3192ff4, 0x39dc1ff3264a606f
d_3_26:         .dword 0x0da0faefb5a0f7aa, 0xf0c747065ac0f76b
d_3_27:         .dword 0x8a3dc67aaa2f488c, 0x6909b90830398b54
                .dword 0xfb3e71f3b0948055, 0x90297d087c7d8229
                .dword 0x3baf73bcbf25aaaa, 0xa921a308db335a38
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xab00a59e4423d0ef, 0x4d961ebd67b585b9
                .dword 0x9a1b8977bc68005d, 0x93aae239f2d447b0
d_4_0:          .dword 0x4eed32c43b68589c, 0x2cad8d62bd3f98a8
d_4_1:          .dword 0x603a8424ec1bb431, 0x7535d5b90dad51fb
d_4_2:          .dword 0x2d0fa67aca256e86, 0xc0f2d09400e48995
d_4_3:          .dword 0xc38f8e1e120fd864, 0x55a312661d0ef3ba
d_4_4:          .dword 0x8c99a0b3cb181db5, 0xf713249f051575fc
d_4_5:          .dword 0x794c21da8622d2d1, 0x8b51d3072a9568ef
d_4_6:          .dword 0xc0b8ff286d3e17a8, 0x376a2f283a761978
d_4_7:          .dword 0x3d03d40974cc9e45, 0x5a68a88410e2d2cf
d_4_8:          .dword 0x2b7fad809d0ba1d0, 0x1b34249d811c3a3a
d_4_9:          .dword 0x89250bbbdf2cc368, 0x86224e752669c0ee
d_4_10:         .dword 0xe7ecd7618e22341a, 0x5c1d8160f055c171
d_4_11:         .dword 0xcd26b0c2c993eea1, 0x2a99e84f7ed8cffa
d_4_12:         .dword 0x9021f77e8ef44cdf, 0x68fc3d4d33e5bd24
d_4_13:         .dword 0xbdcb124f0d46477f, 0x1b5c1c112c898471
d_4_14:         .dword 0x2236bbc24ae331fe, 0xe7df8368e78eefcf
d_4_15:         .dword 0x9d1e76c45d81c088, 0xa9c243d44d96c814
d_4_16:         .dword 0xa74781fdc43ee53f, 0x1d245b12a125be15
d_4_17:         .dword 0xd928b8fab2e5626e, 0x78646657c3c1bdea
d_4_18:         .dword 0x546de22635f44b31, 0x118b4df78aac1ab1
d_4_19:         .dword 0xa9c10554aa94747d, 0x19c9900fbfdd76ae
d_4_20:         .dword 0xcad07f0e30c2a8ce, 0xeeb1d519242a635b
d_4_21:         .dword 0x63e028d43da6842c, 0x61adbc38da25a3ba
d_4_22:         .dword 0x4aa3800e3c6563f8, 0x3500f692846cf45c
d_4_23:         .dword 0x3ef5cb219da9ea94, 0xa6f3e5517b5b71ab
d_4_24:         .dword 0xff68e5ac9c666bf7, 0x8e1436a4e85cf7fb
d_4_25:         .dword 0x41afac85971b2350, 0xf75fceb9b7f26e22
d_4_26:         .dword 0x1ee02699ab17aabf, 0xd8c9b21764765486
d_4_27:         .dword 0xcd0a7d83876c3aac, 0x31204f8e1c7561b8
                .dword 0x760bf1ad867e4167, 0xab221bc970f76152
                .dword 0x9012d57cdf964c8e, 0x98fda9f0a9f04e0c
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x7314c77702aaa59e, 0x232f25be0f32a312
                .dword 0x51d6288f29e7e448, 0x08a48df2f36b3bda
d_5_0:          .dword 0xcf08781cc143ced6, 0xc10d195cfa4bb9cb
d_5_1:          .dword 0x574eebc9aeee6cb4, 0xbec891d4e03f7f72
d_5_2:          .dword 0x0341275137094730, 0x54732f10a2aef426
d_5_3:          .dword 0x0e2fb0fc9e317615, 0x48d141950cb921c5
d_5_4:          .dword 0x3d67065a2519487e, 0x86f70a31474a2e0d
d_5_5:          .dword 0x9506d9a9253575fa, 0xe59a4ed87dbaac1d
d_5_6:          .dword 0x71cb9c94b26a4de4, 0x03c6ae82d7f479d0
d_5_7:          .dword 0x3deabc70623140a4, 0xda9beecac07c9c1a
d_5_8:          .dword 0x0fc42ffb844837d8, 0x71fb88b2a26534ae
d_5_9:          .dword 0x2fa77614f652bc96, 0x80c5c785ccc5f27c
d_5_10:         .dword 0xa3a816014013476b, 0x2aa419edf0cd4c33
d_5_11:         .dword 0x6966572042d408f7, 0x2593e8033a76fd95
d_5_12:         .dword 0x2bdb3418d873a0be, 0x6a5581f77dd3b6bf
d_5_13:         .dword 0x86dbade7f0407c1f, 0x382a851242c88dec
d_5_14:         .dword 0xd2e70a1fde4752c2, 0xa80f760478eccdc0
d_5_15:         .dword 0x736842626ae8ddb0, 0x8a24b7cd88f18586
d_5_16:         .dword 0x98d53b7753fdf026, 0x61717aab17196afe
d_5_17:         .dword 0xb8bf88106d28b62a, 0x5a4d7327c3298fa8
d_5_18:         .dword 0x50d30e35d1df6f6d, 0x359c9f2296ee53e3
d_5_19:         .dword 0xd8a891f76a1152f3, 0xd6589907350fabbb
d_5_20:         .dword 0x1d8032c7db3c8a3f, 0xa7a342c7811157aa
d_5_21:         .dword 0xe0325a54abeb79e3, 0x5fce5d18b5dcd38c
d_5_22:         .dword 0x4b7723450b786d2a, 0x41dbcb436b2bbccf
d_5_23:         .dword 0xabf61aab79dd29ed, 0x6f539d82797f0e4c
d_5_24:         .dword 0xe2207f7c198b00f4, 0x0fd4d3f003113135
d_5_25:         .dword 0xb30a35f4482296fc, 0x139d0dbf2c82a63f
d_5_26:         .dword 0x2a950276d93d1931, 0x5d64b852ceb9da2b
d_5_27:         .dword 0x62700cf1d858af48, 0xe65f386881520976
                .dword 0xbb937418051f7df2, 0x25d23531f69effad
                .dword 0x6a2127b97eee84bb, 0x5a9a914f8b5d2963
         /* Random data */
_end_data5:
              
 
