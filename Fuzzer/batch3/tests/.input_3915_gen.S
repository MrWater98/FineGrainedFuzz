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
_p0:    la x13, d_2_21                            ;
        srai x13, x13, 1                          ;
        csrrw x11, pmpaddr2, x13                  ;
_p1:    xor x13, x13, x13                         ;
        addi x12, zero, 1                         ;
        slli x12, x12, 27                         ;
        add x13, x13, x12                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 25                         ;
        add x13, x13, x13                         ;
        csrrs x10, satp, x13                      ;
_p2:    xor x11, x11, x11                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 2                          ;
        add x11, x11, x12                         ;
        csrrc x13, satp, x11                      ;
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
_s1:    div x15, x13, x3                          ;
_s2:    fmax.s f24, f21, f26                      ;
_s3:    jal x6, _s4                               ;
_s4:    sraw x8, x30, x2                          ;
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
_l0:    la x13, d_2_22                            ;
        lwu x9, -0(x13)                           ;
_l1:    bgeu x24, x13, _l7                        ;
_l2:    fence                                     ;
_l3:    la x11, d_2_16                            ;
        addi x11, x11, 16                         ;
        amomaxu.w x15, x14, (x11)                 ;
_l4:    addi x28, x14, -16                        ;
_l5:    fnmsub.s f29, f9, f29, f30, rdn           ;
_l6:    srlw x14, x23, x1                         ;
_l7:    la x5, d_1_0                              ;
        lbu x29, -0(x5)                           ;
_l8:    fcvt.l.s x14, f26, rdn                    ;
_l9:    la x5, d_5_4                              ;
        lh x10, -10(x5)                           ;
_l10:   addw x4, x1, x2                           ;
_l11:   div x24, x9, x27                          ;
_l12:   fmax.s f19, f19, f12                      ;
_l13:   xor x4, x4, x4                            ;
        csrrc x19, mepc, x4                       ;
_l14:   fclass.s x0, f1                           ;
_l15:   fsgnjx.s f23, f17, f13                    ;
_l16:   rem x26, x7, x28                          ;
_l17:   mulh x17, x2, x17                         ;
_l18:   mulhu x24, x23, x1                        ;
_l19:   la x2, d_4_7                              ;
        lwu x16, -28(x2)                          ;
_l20:   la x16, d_4_20                            ;
        addi x16, x16, -0                         ;
        amoand.w x5, x17, (x16)                   ;
_l21:   bge x28, x8, _l93                         ;
_l22:   csrrci x13, mcause, 0                     ;
_l23:   la x27, d_4_18                            ;
        sh x25, 16(x27)                           ;
_l24:   srli x14, x0, 0                           ;
_l25:   xor x26, x26, x26                         ;
        addi x27, zero, 3                         ;
        slli x27, x27, 16                         ;
        add x26, x26, x27                         ;
        addi x14, zero, 1                         ;
        slli x14, x14, 15                         ;
        add x26, x26, x14                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 23                         ;
        add x26, x26, x18                         ;
        csrrw x26, mtval, x26                     ;
_l26:   fsgnjn.s f0, f11, f9                      ;
_l27:   fmax.s f29, f6, f8                        ;
_l28:   la x9, d_4_26                             ;
        sw x13, 28(x9)                            ;
_l29:   la x24, d_3_26                            ;
        addi x24, x24, 8                          ;
        amoxor.d x15, x23, (x24)                  ;
_l30:   bge x28, x22, _l60                        ;
_l31:   la x24, d_5_3                             ;
        addi x24, x24, 20                         ;
        lui x10, 0xffe00                          ;
        xor x24, x24, x10                         ;
        amoswap.w x25, x10, (x24)                 ;
_l32:   divuw x23, x8, x25                        ;
_l33:   beq x16, x16, _l94                        ;
_l34:   fmv.x.w x0, f26                           ;
_l35:   la x8, d_0_18                             ;
        addi x8, x8, -8                           ;
        amoxor.d x23, x19, (x8)                   ;
_l36:   la x3, _l86                               ;
        lwu x26, -8(x3)                           ;
_l37:   fcvt.wu.s x11, f14, dyn                   ;
_l38:   fsgnjn.s f25, f26, f7                     ;
_l39:   blt x5, x22, _l83                         ;
_l40:   addw x24, x16, x27                        ;
_l41:   beq x26, x13, _l198                       ;
_l42:   div x29, x9, x19                          ;
_l43:   fdiv.s f21, f27, f15, rmm                 ;
_l44:   auipc x14, 22033                          ;
_l45:   fsgnj.s f9, f15, f8                       ;
_l46:   fsgnj.s f0, f5, f25                       ;
_l47:   beq x20, x1, _l87                         ;
_l48:   la x10, d_4_19                            ;
        addi x10, x10, -16                        ;
        amoswap.w x1, x9, (x10)                   ;
_l49:   srlw x22, x0, x27                         ;
_l50:   la x29, d_2_13                            ;
        addi x29, x29, -28                        ;
        amomin.w x1, x8, (x29)                    ;
_l51:   addw x17, x6, x13                         ;
_l52:   la x14, d_2_23                            ;
        addi x14, x14, 24                         ;
        amoswap.w x21, x1, (x14)                  ;
_l53:   fsgnjx.s f17, f10, f18                    ;
_l54:   mulhsu x24, x19, x2                       ;
_l55:   fsgnjx.s f19, f5, f22                     ;
_l56:   la x3, d_0_20                             ;
        addi x3, x3, -4                           ;
        amoor.w x6, x6, (x3)                      ;
_l57:   fcvt.s.lu f22, x15, rup                   ;
_l58:   la x16, d_1_26                            ;
        addi x16, x16, -8                         ;
        amominu.d x25, x2, (x16)                  ;
_l59:   fcvt.s.w f12, x4, rmm                     ;
_l60:   la x5, d_3_21                             ;
        addi x5, x5, 24                           ;
        amoand.w x27, x16, (x5)                   ;
_l61:   la x29, _l10                              ;
        ld x24, 16(x29)                           ;
_l62:   la x29, d_1_27                            ;
        addi x29, x29, 8                          ;
        amoand.w x21, x10, (x29)                  ;
_l63:   blt x17, x26, _l98                        ;
_l64:   addiw x3, x11, 0                          ;
_l65:   la x5, _l117                              ;
        csrrw zero, uepc, x5                      ;
        uret                                      ;
_l66:   ebreak                                    ;
_l67:   auipc x20, 13                             ;
_l68:   mul x11, x16, x20                         ;
_l69:   divuw x3, x19, x17                        ;
_l70:   la x11, d_3_10                            ;
        lhu x18, -30(x11)                         ;
_l71:   fmax.s f2, f18, f22                       ;
_l72:   srli x12, x6, 2                           ;
_l73:   bne x11, x22, _l161                       ;
_l74:   divu x22, x16, x5                         ;
_l75:   addw x26, x3, x15                         ;
_l76:   rem x30, x23, x8                          ;
_l77:   xor x11, x11, x11                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 23                         ;
        add x11, x11, x13                         ;
        addi x9, zero, 1                          ;
        slli x9, x9, 23                           ;
        add x11, x11, x9                          ;
        csrrc x7, sstatus, x11                    ;
_l78:   fsgnj.s f17, f6, f8                       ;
_l79:   la x20, d_4_0                             ;
        addi x20, x20, 24                         ;
        amoor.d x20, x18, (x20)                   ;
_l80:   la x20, d_4_15                            ;
        sw x23, 8(x20)                            ;
_l81:   srliw x16, x22, 5                         ;
_l82:   lui x3, 569961                            ;
_l83:   bge x22, x7, _l149                        ;
_l84:   fmul.s f16, f10, f8, rne                  ;
_l85:   div x15, x29, x19                         ;
_l86:   fsub.s f20, f2, f29, rmm                  ;
_l87:   fmadd.s f1, f18, f30, f24, rne            ;
_l88:   la x6, d_5_2                              ;
        addi x6, x6, -8                           ;
        amomin.d x7, x28, (x6)                    ;
_l89:   fadd.s f8, f2, f11, rne                   ;
_l90:   addi x8, x10, 1033                        ;
_l91:   la x22, d_4_26                            ;
        addi x22, x22, 20                         ;
        amoor.w x25, x15, (x22)                   ;
_l92:   mulh x5, x23, x16                         ;
_l93:   slliw x19, x30, 12                        ;
_l94:   slli x1, x3, 63                           ;
_l95:   li x10, 1                                 ;
        la x9, pt3                                ;
        addi x9, x9, 16                           ;
        sfence.vma x10, x9                        ;
_l96:   fcvt.s.l f8, x21, rtz                     ;
_l97:   fence.i                                   ;
_l98:   remu x14, x27, x28                        ;
_l99:   la x14, d_4_9                             ;
        fsw f16, 20(x14)                          ;
_l100:  addw x6, x23, x3                          ;
_l101:  xor x9, x9, x9                            ;
        csrrc x29, satp, x9                       ;
_l102:  jal x11, _l107                            ;
_l103:  divuw x29, x23, x12                       ;
_l104:  ebreak                                    ;
_l105:  fcvt.l.s x4, f2, rtz                      ;
_l106:  fcvt.s.l f28, x1, rmm                     ;
_l107:  mulw x10, x4, x27                         ;
_l108:  sllw x23, x28, x5                         ;
_l109:  mulw x17, x6, x7                          ;
_l110:  la x11, d_2_26                            ;
        addi x11, x11, 0                          ;
        amoxor.d x26, x29, (x11)                  ;
_l111:  fcvt.s.wu f14, x19, rmm                   ;
_l112:  addiw x30, x1, -1205                      ;
_l113:  la x25, _l167                             ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l114:  xor x18, x18, x18                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 23                         ;
        add x18, x18, x20                         ;
        addi x1, zero, 1                          ;
        slli x1, x1, 25                           ;
        add x18, x18, x1                          ;
        addi x28, zero, 1                         ;
        slli x28, x28, 11                         ;
        add x18, x18, x28                         ;
        csrrw x13, mie, x18                       ;
_l115:  fcvt.s.lu f0, x21, rup                    ;
_l116:  fcvt.w.s x17, f0, rdn                     ;
_l117:  mulh x11, x12, x1                         ;
_l118:  la x4, d_2_9                              ;
        addi x4, x4, 8                            ;
        sc.d x25, x4, (x4)                        ;
_l119:  fnmsub.s f26, f18, f2, f26, dyn           ;
_l120:  fadd.s f7, f13, f11, rtz                  ;
_l121:  remw x15, x28, x20                        ;
_l122:  csrrci x11, fflags, 21                    ;
_l123:  la x26, d_1_27                            ;
        lh x24, -8(x26)                           ;
_l124:  mulhu x29, x8, x4                         ;
_l125:  addiw x29, x20, -1453                     ;
_l126:  la x9, d_2_20                             ;
        addi x9, x9, -16                          ;
        lr.w x8, (x9)                             ;
_l127:  ecall                                     ;
_l128:  fcvt.wu.s x12, f1, rtz                    ;
_l129:  jal x16, _l162                            ;
_l130:  la x8, d_5_4                              ;
        addi x8, x8, 8                            ;
        amoor.d x7, x30, (x8)                     ;
_l131:  la x4, d_4_26                             ;
        addi x4, x4, -20                          ;
        amoadd.w x13, x27, (x4)                   ;
_l132:  fsgnjx.s f1, f23, f28                     ;
_l133:  la x2, d_2_11                             ;
        addi x2, x2, 16                           ;
        amominu.d x28, x25, (x2)                  ;
_l134:  bge x8, x25, _l165                        ;
_l135:  slli x8, x18, 10                          ;
_l136:  addiw x18, x0, 122                        ;
_l137:  addiw x21, x10, -473                      ;
_l138:  la x27, d_5_9                             ;
        lb x17, -0(x27)                           ;
_l139:  slliw x25, x17, 0                         ;
_l140:  beq x4, x17, _l179                        ;
_l141:  fcvt.s.w f31, x0, rne                     ;
_l142:  la x5, d_0_0                              ;
        lw x12, -4(x5)                            ;
_l143:  fnmsub.s f10, f28, f10, f5, rmm           ;
_l144:  sraiw x17, x18, 25                        ;
_l145:  la x16, d_4_5                             ;
        addi x16, x16, 0                          ;
        amoxor.d x9, x15, (x16)                   ;
_l146:  rem x29, x17, x26                         ;
_l147:  lui x3, 590476                            ;
_l148:  la x15, d_3_19                            ;
        addi x15, x15, 0                          ;
        amomin.d x16, x23, (x15)                  ;
_l149:  fsub.s f0, f16, f13, rup                  ;
_l150:  la x5, d_3_17                             ;
        addi x5, x5, -0                           ;
        amoadd.d x9, x14, (x5)                    ;
_l151:  bgeu x2, x23, _l190                       ;
_l152:  fence                                     ;
_l153:  fmadd.s f10, f15, f22, f17, dyn           ;
_l154:  xori x0, x22, 80                          ;
_l155:  la x22, d_4_25                            ;
        addi x22, x22, -0                         ;
        lr.d x8, (x22)                            ;
_l156:  la x7, d_3_17                             ;
        ld x29, 0(x7)                             ;
_l157:  fnmsub.s f27, f0, f15, f13, dyn           ;
_l158:  la x27, _l189                             ;
        jalr x26, 0(x27)                          ;
_l159:  slti x2, x12, -1598                       ;
_l160:  fdiv.s f30, f8, f8, rmm                   ;
_l161:  la x24, d_5_18                            ;
        flw f27, -0(x24)                          ;
_l162:  fsgnjn.s f8, f8, f30                      ;
_l163:  la x14, d_4_21                            ;
        srai x14, x14, 1                          ;
        csrrw x28, pmpaddr7, x14                  ;
_l164:  slliw x15, x8, 29                         ;
_l165:  fle.s x9, f23, f10                        ;
_l166:  ecall                                     ;
_l167:  la x4, d_3_10                             ;
        addi x4, x4, -0                           ;
        amomin.d x21, x14, (x4)                   ;
_l168:  xor x12, x12, x12                         ;
        addi x16, zero, 1                         ;
        slli x16, x16, 26                         ;
        add x12, x12, x16                         ;
        csrrs x7, sie, x12                        ;
_l169:  fsub.s f27, f18, f3, rdn                  ;
_l170:  la x23, d_4_25                            ;
        sw x21, -28(x23)                          ;
_l171:  fsqrt.s f9, f30, rmm                      ;
_l172:  la x18, _l134                             ;
        lh x21, 24(x18)                           ;
_l173:  la x22, d_4_14                            ;
        lh x13, 26(x22)                           ;
_l174:  la x4, d_5_1                              ;
        sb x4, -15(x4)                            ;
_l175:  la x23, d_1_24                            ;
        addi x23, x23, 0                          ;
        amominu.d x17, x14, (x23)                 ;
_l176:  divw x7, x6, x7                           ;
_l177:  la x14, d_0_1                             ;
        sb x17, 29(x14)                           ;
_l178:  la x3, _l23                               ;
        lwu x19, 16(x3)                           ;
_l179:  fcvt.w.s x12, f26, rmm                    ;
_l180:  la x18, _l196                             ;
        csrrw zero, mepc, x18                     ;
        mret                                      ;
_l181:  fsgnj.s f26, f14, f12                     ;
_l182:  subw x5, x3, x3                           ;
_l183:  la x8, d_0_17                             ;
        lwu x20, -12(x8)                          ;
_l184:  sllw x6, x16, x23                         ;
_l185:  sllw x16, x6, x6                          ;
_l186:  la x11, _l78                              ;
        lhu x3, -20(x11)                          ;
_l187:  la x14, d_1_6                             ;
        addi x14, x14, -8                         ;
        amomaxu.d x27, x25, (x14)                 ;
_l188:  blt x18, x27, _l200                       ;
_l189:  srliw x15, x23, 6                         ;
_l190:  fle.s x11, f23, f26                       ;
_l191:  rem x25, x2, x12                          ;
_l192:  li x20, 0                                 ;
        la x0, pt3                                ;
        addi x0, x0, 48                           ;
        sfence.vma x20, x0                        ;
_l193:  fle.s x17, f29, f15                       ;
_l194:  bgeu x2, x17, _l200                       ;
_l195:  la x27, d_3_9                             ;
        sh x24, 20(x27)                           ;
_l196:  div x25, x18, x3                          ;
_l197:  ori x8, x29, -2047                        ;
_l198:  bgeu x4, x14, _l200                       ;
_l199:  la x17, d_2_2                             ;
        addi x17, x17, 12                         ;
        amomaxu.w x18, x26, (x17)                 ;
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
                .dword 0xf975eeb37458871b, 0x011be971fbf05c0d
                .dword 0xe9fa43782a803ffc, 0x6735994655fe7613
d_0_0:          .dword 0xa7c6ce2a6e7f4391, 0x63b0fb0bf6f07072
d_0_1:          .dword 0xc4f8a2a3610ea19b, 0x8fd9213b38e2e3fc
d_0_2:          .dword 0x9438ed6ba87d362b, 0x63827f209e6c934c
d_0_3:          .dword 0xa7f935531f6119ca, 0xfd444f0ed20bc7d0
d_0_4:          .dword 0xe6dde42313117f45, 0xb9c22bda493870b5
d_0_5:          .dword 0x8e7ecfb0edb0be44, 0x507a2126ad723eff
d_0_6:          .dword 0x63f511030ab0ece4, 0x3cbcee6c9b8242f7
d_0_7:          .dword 0x739cbb90118f261c, 0xeecc551ea17f77f9
d_0_8:          .dword 0xe25d29206ef57d1d, 0x473eeb5919158a76
d_0_9:          .dword 0xab2d265f58f97401, 0x534d7cc1ad966933
d_0_10:         .dword 0x1b59e3543b48d4de, 0x272552819bcd1fee
d_0_11:         .dword 0xcc2c3bd261131f97, 0xdc94f89eeb122edf
d_0_12:         .dword 0x6c6c9daf8bd33b48, 0xc732a9ee68aaf8a0
d_0_13:         .dword 0x6152d5f2987a657d, 0x9a9066b74078ed3b
d_0_14:         .dword 0x66ef7e17274182ba, 0xec635b6bcc8f48e0
d_0_15:         .dword 0x4504360f5e52b3a2, 0x0888be0e6076c1e5
d_0_16:         .dword 0x789759cfafdb6c50, 0x7f077ba2ba120efd
d_0_17:         .dword 0x9766b592e957378f, 0xd41055fd8f37e94a
d_0_18:         .dword 0x40a44f0ed4909374, 0x879247be0aa1d092
d_0_19:         .dword 0x7afe5dd9f8b3fe86, 0x25bfaec66a583c67
d_0_20:         .dword 0x2273ea016209d83c, 0x153979cb8993a80c
d_0_21:         .dword 0x6a392262837d22bc, 0x5bb033ecb3ff86af
d_0_22:         .dword 0x969ff1ea93e8b5fd, 0x833a7b0c564950f6
d_0_23:         .dword 0x8f62e1bb8bc86739, 0xfac14ea0e7bec51d
d_0_24:         .dword 0x2c4f5208a3ab9c36, 0xb7b551a4ff859ff2
d_0_25:         .dword 0x9ff14ed7bad5aaa3, 0x41d79e26e88f1073
d_0_26:         .dword 0x1ce9cca3469f8dbe, 0xba7ba3d574ffc80a
d_0_27:         .dword 0xb3df3a1982b7c70a, 0xf58d603359c88051
                .dword 0x66a09fb461432ca4, 0x4132bdf226682486
                .dword 0xb03e48b43e1242c0, 0x09da200e99a709b4
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xd768fae92137f405, 0x08370ebc07b37c64
                .dword 0x8cac0434e9b8c98c, 0x689bd8e1aa6bdb99
d_1_0:          .dword 0xbbe47e8119a7c0ce, 0x1cd7cebf9694ee30
d_1_1:          .dword 0x877032b7985a46da, 0x63a5f2cc19b9d7f6
d_1_2:          .dword 0x44ab98ae9042cf2d, 0x563913a92f1ba15e
d_1_3:          .dword 0xf42c4b283df08371, 0x3f5de4b60fdaf92e
d_1_4:          .dword 0x4f8c7feabdd2fae5, 0xf1dd7f42a9489eee
d_1_5:          .dword 0xd9fd27cd0a5e5585, 0xd94687f1fece3011
d_1_6:          .dword 0xa61799b832e4636c, 0x86af573e1929ffa0
d_1_7:          .dword 0x2e6eddc4d4095afe, 0xbffa3cb1948d97cc
d_1_8:          .dword 0x3d05566ebbf59757, 0x39207408eccd3a7d
d_1_9:          .dword 0x829e4a4b9d4ac197, 0xe09a3fbf2e8e8227
d_1_10:         .dword 0x8bb584c96f8bcdd9, 0x17a964d73513978b
d_1_11:         .dword 0xb2bdfee87c0197c8, 0xe293a4636fb3fc94
d_1_12:         .dword 0x8a638fd46503c600, 0x053193d58bc4ce70
d_1_13:         .dword 0x23b9a4d86aa299d5, 0xe04e9282f5b1dd1d
d_1_14:         .dword 0xf97b73f34fb10a85, 0xa080fbd1cccc094e
d_1_15:         .dword 0x22b29ab2a4c339e8, 0x3eaeae982318be7e
d_1_16:         .dword 0x08eabde809fafdb2, 0x72a75419a14d97af
d_1_17:         .dword 0x392d022a8134bfc5, 0xa5051c2de7576890
d_1_18:         .dword 0x170043a6d67dc04f, 0xe604dfcf702ec14f
d_1_19:         .dword 0xe47c3be9530ef8da, 0x25d2d595fc6f1d46
d_1_20:         .dword 0x4ca37da0a9530199, 0xa466bbfc386c90a1
d_1_21:         .dword 0xe008c6663cffb8f1, 0xb438aeb8f883ba5c
d_1_22:         .dword 0x2963f3aa7c1cd0af, 0x0a6f2fafb87444ac
d_1_23:         .dword 0x6f4359d6d2ec3c7f, 0x5833aeb2dcbfb443
d_1_24:         .dword 0x751725d31b47cff9, 0xc16892fe18812c7c
d_1_25:         .dword 0xd74b494d44b6909b, 0x179d833abf756a7b
d_1_26:         .dword 0xb2fb18459c3740b4, 0x0eb961ffc4c5d040
d_1_27:         .dword 0x85b2079d64b4fb59, 0x4548cbbe168152d4
                .dword 0xfaea04668c4ccdcd, 0x98e117d80639119b
                .dword 0xba49fbbf20932dd5, 0x89ffe307c4088517
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x602db7adb4828b97, 0xfa82fde685cc4fa3
                .dword 0x8d30bbe980693e35, 0x64c26470ac7af77a
d_2_0:          .dword 0xbce494ac35ff55e0, 0xbdc4afb4d3a20c38
d_2_1:          .dword 0x2e5461679ec616f0, 0xbf08163b811c9d92
d_2_2:          .dword 0xec2ae50014d490ce, 0x7a246c3ceafc5e9e
d_2_3:          .dword 0xe5f011d985ade19e, 0x8aa93c5214f89da6
d_2_4:          .dword 0x1716296ae5c9a4cb, 0x39961f9a4a352cb9
d_2_5:          .dword 0x9377a4c353b24915, 0x265428a0b9b4df3f
d_2_6:          .dword 0x971ab67ad9c67d53, 0xb157cff352c56800
d_2_7:          .dword 0x581297ab44c85dce, 0x8b12b7f8854408bd
d_2_8:          .dword 0xce3b0099196af307, 0x5214e9a663299767
d_2_9:          .dword 0x8e0dd818cb34e095, 0xf58554b956067f5f
d_2_10:         .dword 0xfa017700be1a14dc, 0x4be949e2fcd8ef25
d_2_11:         .dword 0x1c6b464230c76627, 0x6b1383eab72160b4
d_2_12:         .dword 0xa5a9f9a8de1a12e8, 0x661cd7698715f405
d_2_13:         .dword 0x41639ded587ef983, 0x70350af76f4383c1
d_2_14:         .dword 0xce8fb8d8e1b4c0f7, 0x4cdfeea522c5e329
d_2_15:         .dword 0x5eb650afcc9ce69f, 0x81c0538cf7add7d0
d_2_16:         .dword 0x5ae1df07da971948, 0x2c0d65f9c1c2cc3c
d_2_17:         .dword 0x0e60c3f18488ba72, 0x211adb36c1b962a2
d_2_18:         .dword 0x1f6748ac2d4abfdc, 0x82cfa9f88006dacd
d_2_19:         .dword 0x5846287f2cd5bb34, 0x9017f3d4398a8914
d_2_20:         .dword 0xea3437bcbc6bbbe3, 0x77e62bb1b63f56cb
d_2_21:         .dword 0xba92634c05d13c7a, 0x55535a836aeb1c08
d_2_22:         .dword 0xabef84e756c6f175, 0x78a6354583d322ac
d_2_23:         .dword 0xf11770b0f4c562a4, 0xaa0649b3be39c1b3
d_2_24:         .dword 0x339124c30562ff3b, 0xd319934ed664ed3e
d_2_25:         .dword 0x4532122557384550, 0xdf7b84d732ea9e19
d_2_26:         .dword 0xd971ce8808f15d5a, 0xf9216f582b0998c1
d_2_27:         .dword 0x262c4756ce498ffc, 0x91ca2cffd64fd0a0
                .dword 0x03127779c0405a72, 0xcd2a0806ed1a2846
                .dword 0xd7493dc319692395, 0x79f3127afb113334
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x86a8ac05b01a4836, 0xcc30b83f51c098a7
                .dword 0x4c6c1bcd198a00b6, 0x4f2c455d4abf6b1a
d_3_0:          .dword 0x720e09bc4f4d3293, 0x159c3f1a5f09caaa
d_3_1:          .dword 0x7420612b852b3ee3, 0xe8505c51d4a40adb
d_3_2:          .dword 0x8d8b36fec2661f66, 0xda17a7286398efa6
d_3_3:          .dword 0x6ca160025397edc7, 0xd558e4589272f3e2
d_3_4:          .dword 0xf6176216492b3bbb, 0x4c7c32d0d3c9b19b
d_3_5:          .dword 0xced2a72d7d5e647e, 0x855e87a9af3e3fdb
d_3_6:          .dword 0xc92fa6d9cd2fbc14, 0x22e94d2550499291
d_3_7:          .dword 0xad6ac29b98ea25aa, 0x012c0de87ba10a47
d_3_8:          .dword 0xa7b4e331487cd7b1, 0x5e89d44f329917d6
d_3_9:          .dword 0x48a659c5104bc4b8, 0xae5b38b914539fab
d_3_10:         .dword 0xd6eb9d06ebfa9c30, 0x7c2b06fc46283772
d_3_11:         .dword 0xd68600c60f2be583, 0x3fbac16e6e796689
d_3_12:         .dword 0x084952a5386d311f, 0x70666c5fb13183ea
d_3_13:         .dword 0x030cfea7f8d347be, 0xf80d301e97f9a22c
d_3_14:         .dword 0xd6daf0bf7762a00c, 0x7f9c8f0eebb733e6
d_3_15:         .dword 0xc393f228c2573923, 0x7d1df38d72fe45df
d_3_16:         .dword 0x665d13374296596a, 0x8ed0e3d56c386bbe
d_3_17:         .dword 0xee02e80606e833f8, 0x18b0767607dd7d80
d_3_18:         .dword 0x668d318e84982db6, 0x57c85def0f83a67b
d_3_19:         .dword 0xf6092ba67c360228, 0xce4155fe33bdd5d5
d_3_20:         .dword 0xb63a797cfc2b28da, 0x9b53f2bf08d43c39
d_3_21:         .dword 0xbfdcf4a9b8cf5c7b, 0xbe5519ee35104873
d_3_22:         .dword 0xa5a3894da2dc45ba, 0xfb097a5a7d94f1ba
d_3_23:         .dword 0x6fc32825adcd2c0f, 0xf431df7dade17e8f
d_3_24:         .dword 0xe0510138c2ae5101, 0x950e5e891cf77d00
d_3_25:         .dword 0x756f4074f85eb08d, 0x9479408c38c38f72
d_3_26:         .dword 0x2324b638c92f832a, 0x54607df47de344c6
d_3_27:         .dword 0x63be5c2b5132375d, 0x5c370d33b8888ce5
                .dword 0xc265f97491c5db04, 0x5c50a1e1f896e68d
                .dword 0xad98b6b354690b30, 0xab26ea9d8939e003
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x9f6766dd2bf2815a, 0x590ff4211790b455
                .dword 0x3dbed9e0a372801b, 0xe19d80431e74445a
d_4_0:          .dword 0xf4d1a67b8a36e910, 0x2e19c468b21e46b2
d_4_1:          .dword 0x3ebd79ef059fd822, 0xb64c752f4fd241b1
d_4_2:          .dword 0x01215e51dd1d18b1, 0xb86afbbfb8efadc9
d_4_3:          .dword 0xec80c07fd3a4f1c5, 0x32e5fb6d483f97a5
d_4_4:          .dword 0xc8f4b64769411d5c, 0xb265bb18eee5c3b2
d_4_5:          .dword 0x5a29105cc6c6d70e, 0x5314b4d456cf5c40
d_4_6:          .dword 0x4d6b5d65dc97730b, 0x224e764b737e07f7
d_4_7:          .dword 0x7796e04beef26ce3, 0xdfa1209c85123e6a
d_4_8:          .dword 0xa81748c836d8586c, 0x3dc104ca812ec616
d_4_9:          .dword 0x66b54fd226c9b1e7, 0xb193c46af809a711
d_4_10:         .dword 0xfdc1ba48640cbbd1, 0xde6af40d6dec44b4
d_4_11:         .dword 0xddef1b60ee2f294e, 0x79ada791a4cb8728
d_4_12:         .dword 0xfa81c0ca375d9868, 0x522a56eea9848dba
d_4_13:         .dword 0xf5b5f4f6a0b6abfc, 0xbcef6d06f567adc7
d_4_14:         .dword 0xaf7bf4d80147aad2, 0xe78546d6f2c43734
d_4_15:         .dword 0x6ccf91890230ac19, 0x0bfccd73e60b852f
d_4_16:         .dword 0x4fd550cb91824099, 0x6ad53b3dba4a7ee6
d_4_17:         .dword 0x754e27016de749ef, 0x2ba3058b37e699be
d_4_18:         .dword 0x1420235033557edb, 0x78362948a8d0d907
d_4_19:         .dword 0xcc02b8591dc38e75, 0xa1a01169ddef57ea
d_4_20:         .dword 0x46b020bfad1cd1a6, 0xcc3fd6a5dce51cfa
d_4_21:         .dword 0xcb782cd2b3a873ab, 0x71bfee5a3484f307
d_4_22:         .dword 0x17f25a0f3810b55e, 0x8890fb326554d98a
d_4_23:         .dword 0x21408f5f6c0fd567, 0xb515557d2dc25fae
d_4_24:         .dword 0xeba0e95a121e66af, 0xc4f1ce0cb520651e
d_4_25:         .dword 0x0a1449932ba4aba7, 0x9bdbe38c714e9697
d_4_26:         .dword 0x8d0245f7eb3155a4, 0x7f53666ce7c09365
d_4_27:         .dword 0x92142176e3a2ee7d, 0x31974e73c0614f07
                .dword 0xdf328e34fc3e8e8d, 0x29d31fe4f04ce46c
                .dword 0xa0f3d1e23e070480, 0x3636e6691512b536
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x76afef0d8842772b, 0x23b1174a8c87f220
                .dword 0xf8010aba9f6909e1, 0xdfb13f215cd2ddab
d_5_0:          .dword 0x8e072cc7add8bc28, 0xa76ef4ffe0472519
d_5_1:          .dword 0x0e7231c25049a7fb, 0xaeeb37a3d9d91946
d_5_2:          .dword 0xd1a6761da22d3dda, 0xb8d01a43863a58a0
d_5_3:          .dword 0x06528222d84b276c, 0x675321edb5d8b5fe
d_5_4:          .dword 0x0952312eaf67f603, 0xdd0be5e1fb0f9b13
d_5_5:          .dword 0x210521694018291d, 0x0e72b1d43c829861
d_5_6:          .dword 0x0b879fa6ac40ba00, 0x98d194dd4d694553
d_5_7:          .dword 0xad72cd7a2cf074c3, 0x6188d64352c9f2ed
d_5_8:          .dword 0x8dfeff9ede329d17, 0x0c46f4f3fe2898b9
d_5_9:          .dword 0x439ac47400074230, 0x1f7134d4bbf226fc
d_5_10:         .dword 0x83fe8f9d0875989c, 0x23e4f5e891951baa
d_5_11:         .dword 0x1b8d4de1e3795526, 0xbd1d0318ce259a9d
d_5_12:         .dword 0x93bb5897e6e1fe6b, 0xedb68757f88f0e94
d_5_13:         .dword 0xf382b2e3a4dabcd5, 0x36a97ce176411481
d_5_14:         .dword 0x99b64e94199e06c5, 0xadaeae2569a3776a
d_5_15:         .dword 0x6eef8c663b607335, 0xcc92ecc42b7e9919
d_5_16:         .dword 0xc5d05177835c9e05, 0x178cdf4e1e40ec05
d_5_17:         .dword 0xffa1ae5b0c660760, 0x672b0fdbadd0152f
d_5_18:         .dword 0x6a88620d5c2fdc02, 0x18686448c3b3785a
d_5_19:         .dword 0x6c95eb1174cd5b6f, 0x9398df6bed6ca52d
d_5_20:         .dword 0xd48f3b47a79832a8, 0xfae5f24d26c7e3ae
d_5_21:         .dword 0x6e7d4d370c22242b, 0xf05270192c1426b9
d_5_22:         .dword 0xbdbbfa55948357fe, 0x665f7f27e969fd56
d_5_23:         .dword 0xe03b4b12be3c303d, 0x0908a2c90774907a
d_5_24:         .dword 0x6f243b4c6e7c79d7, 0x8d307f59c2d8d0c3
d_5_25:         .dword 0x978aa1a3f566f3ed, 0x89ddde79b1413ae9
d_5_26:         .dword 0xa46d070d47c1eb59, 0xd0e6521a10e400b1
d_5_27:         .dword 0xe835fe5c7a5aef0a, 0x9fc1cf14e59a21bf
                .dword 0x01b1d6fbf0d354fe, 0xbaf7674c42fa6172
                .dword 0x44b9eab252ba2c35, 0x4ff65721c9b1bdc6
         /* Random data */
_end_data5:
              
 
