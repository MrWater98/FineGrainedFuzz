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
_p0:    csrrsi x11, scause, 31                    ;
_p1:    csrrci x10, stval, 0                      ;
_p2:    xor x10, x10, x10                         ;
        csrrs x13, sstatus, x10                   ;
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
_s0:    fcvt.s.w f20, x17, rtz                    ;
_s1:;
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
_l0:    la x23, _l39                                      ;
        jalr x12, 0(x23)                          ;
_l1:    fclass.s x12, f9                          ;
_l2:    andi x9, x10, -0                          ;
_l3:    srliw x13, x17, 7                         ;
_l4:    la x10, d_5_7                             ;
        lhu x10, -8(x10)                          ;
_l5:    fmul.s f5, f20, f24, rtz                  ;
_l6:    srli x25, x8, 0                           ;
_l7:    ori x10, x28, -7                          ;
_l8:    la x12, d_5_16                            ;
        addi x12, x12, 8                          ;
        amominu.w x21, x11, (x12)                 ;
_l9:    bge x20, x19, _l35                                ;
_l10:   flt.s x4, f25, f23                        ;
_l11:   la x11, d_0_5                             ;
        sb x5, -23(x11)                           ;
_l12:   la x10, d_1_13                            ;
        sh x11, 6(x10)                            ;
_l13:   xori x6, x25, 1327                        ;
_l14:   fclass.s x20, f6                          ;
_l15:   la x26, d_3_12                            ;
        lui x30, 0xffe00                          ;
        xor x26, x26, x30                         ;
        lh x28, 4(x26)                            ;
_l16:   bge x10, x11, _l52                                ;
_l17:   fcvt.s.w f24, x7, rdn                     ;
_l18:   la x20, d_1_12                            ;
        sd x24, 0(x20)                            ;
_l19:   la x3, _l57                               ;
        lh x19, 8(x3)                             ;
_l20:   srli x26, x20, 0                          ;
_l21:   fcvt.s.lu f20, x7, rmm                    ;
_l22:   mulh x10, x25, x6                         ;
_l23:   la x24, d_1_4                             ;
        sd x29, 16(x24)                           ;
_l24:   la x29, d_0_11                            ;
        ld x13, 16(x29)                           ;
_l25:   la x11, _l29                                      ;
        srai x11, x11, 1                          ;
        csrrs x15, pmpaddr3, x11                  ;
_l26:   xor x28, x28, x28                         ;
        addi x3, zero, 3                          ;
        slli x3, x3, 9                            ;
        add x28, x28, x3                          ;
        addi x21, zero, 3                         ;
        slli x21, x21, 7                          ;
        add x28, x28, x21                         ;
        addi x6, zero, 3                          ;
        slli x6, x6, 20                           ;
        add x28, x28, x6                          ;
        csrrc x28, mip, x28                       ;
_l27:   csrrsi x13, sip, 24                       ;
_l28:   la x24, _l62                                      ;
        jalr x16, 0(x24)                          ;
_l29:   la x8, _l79                                       ;
        csrrw zero, mepc, x8                      ;
        mret                                      ;
_l30:   la x13, d_3_17                            ;
        addi x13, x13, 16                         ;
        lr.d x14, (x13)                           ;
_l31:   la x6, d_5_26                             ;
        addi x6, x6, -24                          ;
        amoand.w x5, x8, (x6)                     ;
_l32:   la x23, d_3_24                            ;
        sw x14, 4(x23)                            ;
_l33:   mulhsu x5, x7, x5                         ;
_l34:   rem x18, x18, x29                         ;
_l35:   mul x16, x30, x20                         ;
_l36:   fsqrt.s f18, f23, dyn                     ;
_l37:   fmul.s f0, f30, f20, rdn                  ;
_l38:   la x9, d_0_11                             ;
        addi x9, x9, 0                            ;
        amomin.w x7, x17, (x9)                    ;
_l39:   xor x21, x21, x21                         ;
        addi x4, zero, 3                          ;
        slli x4, x4, 31                           ;
        add x21, x21, x4                          ;
        addi x3, zero, 3                          ;
        slli x3, x3, 20                           ;
        add x21, x21, x3                          ;
        addi x25, zero, 1                         ;
        slli x25, x25, 26                         ;
        add x21, x21, x25                         ;
        csrrc x19, mepc, x21                      ;
_l40:   la x29, d_5_4                             ;
        addi x29, x29, -8                         ;
        sc.w x22, x1, (x29)                       ;
_l41:   fmv.x.w x19, f7                           ;
_l42:   bltu x25, x29, _l122                               ;
_l43:   jal x7, _l86                                      ;
_l44:   la x10, d_2_12                            ;
        addi x10, x10, -4                         ;
        amoand.w x22, x30, (x10)                  ;
_l45:   fdiv.s f26, f16, f12, rup                 ;
_l46:   la x7, d_1_9                              ;
        addi x7, x7, 16                           ;
        sc.d x16, x7, (x7)                        ;
_l47:   lui x20, 1006808                          ;
_l48:   lui x19, 0                                ;
_l49:   fsgnj.s f7, f16, f21                      ;
_l50:   la x1, _l183                                      ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l51:   la x26, d_5_11                            ;
        lbu x30, -14(x26)                         ;
_l52:   fcvt.l.s x14, f22, dyn                    ;
_l53:   ebreak                                    ;
_l54:   la x16, d_0_24                            ;
        lui x19, 0xffe00                          ;
        xor x16, x16, x19                         ;
        sh x27, -0(x16)                           ;
_l55:   mulw x25, x15, x3                         ;
_l56:   fadd.s f19, f11, f24, rne                 ;
_l57:   la x30, d_2_1                             ;
        lb x25, -31(x30)                          ;
_l58:   la x23, d_2_21                            ;
        addi x23, x23, 0                          ;
        amominu.d x18, x11, (x23)                 ;
_l59:   fsgnjn.s f16, f23, f13                    ;
_l60:   fsgnjx.s f26, f30, f11                    ;
_l61:   fence                                     ;
_l62:   divuw x29, x7, x12                        ;
_l63:   fence                                     ;
_l64:   flt.s x15, f16, f21                       ;
_l65:   la x23, d_2_10                            ;
        lh x26, 0(x23)                            ;
_l66:   srliw x3, x17, 13                         ;
_l67:   sraiw x27, x18, 1                         ;
_l68:   la x5, d_2_17                             ;
        addi x5, x5, -4                           ;
        amomaxu.w x17, x29, (x5)                  ;
_l69:   fsub.s f24, f26, f14, rdn                 ;
_l70:   fmsub.s f23, f13, f15, f30, rdn           ;
_l71:   csrrwi x28, pmpaddr3, 25                  ;
_l72:   la x22, d_0_2                             ;
        sb x7, -1(x22)                            ;
_l73:   subw x3, x22, x28                         ;
_l74:   beq x2, x22, _l100                                ;
_l75:   beq x19, x2, _l149                                ;
_l76:   rem x1, x15, x3                           ;
_l77:   fsgnjn.s f18, f0, f29                     ;
_l78:   bltu x12, x13, _l151                              ;
_l79:   la x5, d_2_25                             ;
        addi x5, x5, 0                            ;
        amomin.d x18, x3, (x5)                    ;
_l80:   fcvt.l.s x1, f4, rtz                      ;
_l81:   la x29, d_5_21                            ;
        addi x29, x29, 0                          ;
        amomax.d x17, x7, (x29)                   ;
_l82:   la x13, _l108                                     ;
        jalr x7, 0(x13)                           ;
_l83:   srai x0, x24, 28                          ;
_l84:   mulhu x7, x6, x29                         ;
_l85:   feq.s x2, f25, f31                        ;
_l86:   fcvt.wu.s x23, f14, rne                   ;
_l87:   la x17, d_0_11                            ;
        addi x17, x17, 0                          ;
        lui x5, 0xffe00                           ;
        xor x17, x17, x5                          ;
        amoor.d x21, x5, (x17)                    ;
_l88:   remw x13, x23, x12                        ;
_l89:   li x6, 1                                  ;
        la x14, pt2                               ;
        addi x14, x14, 40                         ;
        sfence.vma x6, x14                        ;
_l90:   csrrci x14, satp, 5                       ;
_l91:   la x21, d_5_15                            ;
        addi x21, x21, -0                         ;
        amomin.d x3, x19, (x21)                   ;
_l92:   addi x11, x2, 0                           ;
_l93:   addi x21, x30, -984                       ;
_l94:   flt.s x20, f0, f15                        ;
_l95:   la x19, d_0_0                             ;
        ld x26, 8(x19)                            ;
_l96:   fadd.s f9, f29, f20, rup                  ;
_l97:   fmul.s f4, f21, f2, rmm                   ;
_l98:   fdiv.s f16, f23, f26, rmm                 ;
_l99:   ori x2, x2, 1337                          ;
_l100:  rem x5, x8, x3                            ;
_l101:  la x26, _l113                                     ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l102:  rem x28, x18, x11                         ;
_l103:  la x20, _l179                                     ;
        jalr x3, 0(x20)                           ;
_l104:  la x3, d_2_2                              ;
        addi x3, x3, -20                          ;
        amoand.w x26, x27, (x3)                   ;
_l105:  fmin.s f21, f18, f7                       ;
_l106:  fcvt.wu.s x17, f13, dyn                   ;
_l107:  sllw x6, x15, x2                          ;
_l108:  la x29, d_3_15                            ;
        addi x29, x29, 16                         ;
        lui x19, 0xffe00                          ;
        xor x29, x29, x19                         ;
        sc.w x21, x19, (x29)                      ;
_l109:  csrrsi x19, pmpaddr5, 20                  ;
_l110:  la x27, d_5_1                             ;
        addi x27, x27, -12                        ;
        amoswap.w x21, x26, (x27)                 ;
_l111:  la x9, d_3_10                             ;
        lui x18, 0xffe00                          ;
        xor x9, x9, x18                           ;
        sd x9, -0(x9)                             ;
_l112:  sltiu x18, x30, 0                         ;
_l113:  bltu x28, x28, _l162                              ;
_l114:  la x5, d_0_8                              ;
        addi x5, x5, 0                            ;
        amoand.d x7, x8, (x5)                     ;
_l115:  la x25, d_0_10                            ;
        fsw f5, -16(x25)                          ;
_l116:  la x27, d_5_7                             ;
        addi x27, x27, -0                         ;
        amomaxu.d x23, x16, (x27)                 ;
_l117:  la x3, _l200                              ;
        csrrw zero, mepc, x3                      ;
        mret                                      ;
_l118:  la x16, d_3_21                            ;
        addi x16, x16, 16                         ;
        amoswap.d x21, x24, (x16)                 ;
_l119:  la x7, d_5_13                             ;
        sw x26, 0(x7)                             ;
_l120:  fcvt.s.w f5, x21, rdn                     ;
_l121:  la x13, d_4_1                             ;
        addi x13, x13, -16                        ;
        lui x14, 0xffe00                          ;
        xor x13, x13, x14                         ;
        amoxor.w x6, x14, (x13)                   ;
_l122:  la x23, d_2_20                            ;
        addi x23, x23, 0                          ;
        amomaxu.w x15, x19, (x23)                 ;
_l123:  addiw x10, x20, -1446                     ;
_l124:  slli x2, x28, 31                          ;
_l125:  la x8, d_0_13                             ;
        addi x8, x8, 0                            ;
        amoxor.w x11, x25, (x8)                   ;
_l126:  srlw x13, x3, x4                          ;
_l127:  ori x13, x2, -565                         ;
_l128:  la x18, d_3_8                             ;
        ld x4, 16(x18)                            ;
_l129:  rem x25, x26, x11                         ;
_l130:  la x22, d_5_20                            ;
        addi x22, x22, -16                        ;
        amoand.w x17, x8, (x22)                   ;
_l131:  fcvt.s.lu f18, x21, dyn                   ;
_l132:  divu x14, x15, x10                        ;
_l133:  fcvt.l.s x5, f10, rtz                     ;
_l134:  addi x22, x12, -996                       ;
_l135:  la x24, d_0_0                             ;
        addi x24, x24, -0                         ;
        amomaxu.d x15, x3, (x24)                  ;
_l136:  la x22, d_3_12                            ;
        addi x22, x22, -16                        ;
        amoor.d x7, x16, (x22)                    ;
_l137:  fcvt.wu.s x16, f6, rup                    ;
_l138:  fle.s x25, f5, f7                         ;
_l139:  slli x27, x22, 0                          ;
_l140:  la x30, d_1_8                             ;
        addi x30, x30, -8                         ;
        amominu.d x13, x25, (x30)                 ;
_l141:  fcvt.lu.s x13, f6, dyn                    ;
_l142:  srlw x22, x24, x28                        ;
_l143:  la x30, d_5_12                            ;
        addi x30, x30, 0                          ;
        amoxor.d x10, x28, (x30)                  ;
_l144:  fcvt.s.l f19, x25, rup                    ;
_l145:  fnmsub.s f30, f14, f12, f23, dyn          ;
_l146:  subw x4, x27, x15                         ;
_l147:  la x12, _l184                                     ;
        csrrw zero, uepc, x12                     ;
        uret                                      ;
_l148:  la x11, d_3_6                             ;
        addi x11, x11, 0                          ;
        amomin.w x17, x21, (x11)                  ;
_l149:  fmv.x.w x23, f19                          ;
_l150:  beq x14, x1, _l192                                ;
_l151:  la x26, d_2_17                            ;
        addi x26, x26, 0                          ;
        amoor.w x27, x1, (x26)                    ;
_l152:  la x27, d_4_11                            ;
        addi x27, x27, 8                          ;
        amoor.d x27, x24, (x27)                   ;
_l153:  slti x27, x15, 0                          ;
_l154:  beq x18, x10, _l183                               ;
_l155:  fmul.s f29, f19, f29, rne                 ;
_l156:  csrrci x16, pmpaddr5, 0                   ;
_l157:  la x13, d_0_19                            ;
        addi x13, x13, 16                         ;
        amomaxu.d x25, x16, (x13)                 ;
_l158:  jal x29, _l162                                    ;
_l159:  auipc x10, 91157                          ;
_l160:  fcvt.s.wu f3, x24, rmm                    ;
_l161:  sraw x11, x27, x17                        ;
_l162:  la x22, d_5_9                             ;
        addi x22, x22, -24                        ;
        amomax.w x26, x7, (x22)                   ;
_l163:  srli x9, x19, 63                          ;
_l164:  bltu x7, x10, _l196                       ;
_l165:  mulh x25, x20, x4                         ;
_l166:  la x4, d_0_25                             ;
        addi x4, x4, -16                          ;
        lr.d x25, (x4)                            ;
_l167:  la x21, _l96                                      ;
        lui x9, 0xffe00                           ;
        xor x21, x21, x9                          ;
        flw f11, 4(x21)                           ;
_l168:  andi x25, x2, 1080                        ;
_l169:  andi x28, x19, -5                         ;
_l170:  fnmsub.s f4, f13, f24, f18, rmm           ;
_l171:  bltu x23, x25, _l177                              ;
_l172:  sraw x8, x30, x2                          ;
_l173:  fcvt.lu.s x27, f2, rne                    ;
_l174:  mul x10, x0, x17                          ;
_l175:  fence.i                                   ;
_l176:  divu x5, x20, x6                          ;
_l177:  la x12, d_2_1                             ;
        lb x24, -14(x12)                          ;
_l178:  fadd.s f25, f14, f16, rmm                 ;
_l179:  fadd.s f1, f14, f0, rne                   ;
_l180:  andi x4, x11, -1715                       ;
_l181:  slli x20, x24, 53                         ;
_l182:  csrrci x24, mip, 0                        ;
_l183:  fnmsub.s f6, f21, f6, f4, rtz             ;
_l184:  sllw x0, x0, x7                           ;
_l185:  la x21, d_2_4                             ;
        addi x21, x21, -4                         ;
        amoand.w x7, x27, (x21)                   ;
_l186:  xor x10, x10, x10                         ;
        addi x3, zero, 3                          ;
        slli x3, x3, 31                           ;
        add x10, x10, x3                          ;
        addi x16, zero, 3                         ;
        slli x16, x16, 25                         ;
        add x10, x10, x16                         ;
        csrrw x7, sie, x10                        ;
_l187:  la x26, d_5_0                             ;
        addi x26, x26, -0                         ;
        lr.w x8, (x26)                            ;
_l188:  mulw x2, x12, x16                         ;
_l189:  xor x23, x23, x23                         ;
        csrrs x29, mie, x23                       ;
_l190:  la x14, d_4_12                            ;
        sd x24, -0(x14)                           ;
_l191:  subw x25, x28, x21                        ;
_l192:  csrrwi x19, mtval, 26                     ;
_l193:  ebreak                                    ;
_l194:  auipc x16, 0                              ;
_l195:  la x4, d_4_3                              ;
        addi x4, x4, -0                           ;
        amomax.d x22, x27, (x4)                   ;
_l196:  bge x28, x17, _l199                       ;
_l197:  srai x22, x13, 14                         ;
_l198:  li x21, 0                                 ;
        la x8, pt1                                ;
        addi x8, x8, 0                            ;
        sfence.vma x21, x8                        ;
_l199:  fmin.s f19, f30, f9                       ;
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
                .dword 0x61cce35cdaa8f6b3, 0x70d9dcedbaa21fa3
                .dword 0x80943bfb06b67b71, 0x30c70ec73429dff1
d_0_0:          .dword 0x4e78fdec43de8b11, 0xbb5abdd082c08d7e
d_0_1:          .dword 0x06d88f6d00160ce4, 0xa90bd6dc3a5845e3
d_0_2:          .dword 0xa58f873db27e7ae8, 0x72ffbbec4551c92c
d_0_3:          .dword 0x7dec27308a12eb12, 0x935d633f61571d81
d_0_4:          .dword 0x91b8b8099e8b15c9, 0xe337ab4cf0b32dca
d_0_5:          .dword 0xe74062c2deea63cc, 0xcc2748ec9de36d84
d_0_6:          .dword 0x29031a756075e1ea, 0xb9b9331e701b8077
d_0_7:          .dword 0x467e4b3f0a00d497, 0x4196bb2f21a14f97
d_0_8:          .dword 0x956df17c9fe5b75a, 0x0d48e464b2a8f322
d_0_9:          .dword 0xcd2ed687db68cd42, 0xd072c0a273d49801
d_0_10:         .dword 0xd0dda1cfcaceb82b, 0xe075b658dfff8cc8
d_0_11:         .dword 0xd4df73bb88a282ab, 0x91f20b5ac0e9edd7
d_0_12:         .dword 0xdf531a3dec94e1c6, 0x8d115b10747e3ada
d_0_13:         .dword 0x930213f5a9856201, 0xf467049d1f1a0fce
d_0_14:         .dword 0x1864908bb8c226e3, 0xc8b4aebf74a06a08
d_0_15:         .dword 0xc375e69d8476e57b, 0x559760a9cfff92c8
d_0_16:         .dword 0xc2c757eb898be4af, 0x313da8c31644a04e
d_0_17:         .dword 0x15d39ff55f871115, 0xac13a9bb996830d9
d_0_18:         .dword 0xc40a0517e7c5b3a7, 0x47fef6ab42082329
d_0_19:         .dword 0xfee1bc48de86c26c, 0x2107a7097749f126
d_0_20:         .dword 0x48f25867d99436db, 0xeb2bad805490ead3
d_0_21:         .dword 0xf13cd9874ac353ff, 0x36b27c08a0ffc51d
d_0_22:         .dword 0xb1ce75712b3e7760, 0x6b844308b1c18f38
d_0_23:         .dword 0x14f2167bf119fbb1, 0x71bb899cb4af4f17
d_0_24:         .dword 0x986fa3f71d818044, 0x2ec9da0167f6e4d2
d_0_25:         .dword 0x4c4c2a9d88b516aa, 0xd42dd80e9f62b974
d_0_26:         .dword 0x63c4639eef15c136, 0xd78ee7c65fe211ec
d_0_27:         .dword 0xdb120ae5027b490c, 0x684363adb51bf2a3
                .dword 0x42ccd5a1f1c7a6b3, 0xf8660cecaa1b6de1
                .dword 0xad1d32c99401c3f0, 0xdbfde0d990f7cbbf
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x67f24b32b241dfe0, 0xb4696d0986043506
                .dword 0x00d8ae475167f5f4, 0xdad758432a6f0779
d_1_0:          .dword 0x632d41c43cb7de3e, 0xdefd1074ce01a946
d_1_1:          .dword 0xb2554c1484cad703, 0xa6969c3b5d64d8c8
d_1_2:          .dword 0x9b2e6b2ba3105870, 0x788bf90572f1bc8c
d_1_3:          .dword 0x9a1031a139c039b9, 0x249e1380584392c1
d_1_4:          .dword 0x6ee0c860a190a48d, 0x9d1ff303ad687744
d_1_5:          .dword 0x20f6d588baa58092, 0x878ea933ab7023e6
d_1_6:          .dword 0xd09960bab72303e0, 0xc472030f757f0869
d_1_7:          .dword 0xaf9ba96655b16d0e, 0xf0886aa06062e7c4
d_1_8:          .dword 0xd5ed70ebe71667f2, 0x1ae677156eee83e5
d_1_9:          .dword 0x10cf58d79d1a0fe3, 0x25208ea492e92e2f
d_1_10:         .dword 0x02028c37e13b63e8, 0x1e1f21b4b1b14cfa
d_1_11:         .dword 0x7ecfea24c869228e, 0xcdb44c95a4516a2f
d_1_12:         .dword 0xecea3ac56c3b5bc1, 0x1f4f907754c5f256
d_1_13:         .dword 0xb12a1adb7cf9657a, 0x2112891751b8b4fe
d_1_14:         .dword 0x35c997ba84dcb9f6, 0x0d682455b2cff2f3
d_1_15:         .dword 0xe05de151a7ea6236, 0x386a8445db2a1fa0
d_1_16:         .dword 0x5b53274cb48b5016, 0x5b73579c0b504b6e
d_1_17:         .dword 0x09807115bef3ce47, 0x05ef4f8646e7f56a
d_1_18:         .dword 0x4aa860482875003e, 0xaee53ef2ffe7d92c
d_1_19:         .dword 0xbf06abc541524edd, 0xe506f7d1f57737af
d_1_20:         .dword 0xd02c5e41902bccf5, 0xebd97c8362ca3310
d_1_21:         .dword 0x02f4df159cf08a8a, 0xe57455b5b5bf4d8f
d_1_22:         .dword 0x28c3a549b1f2b1c9, 0x42da5b141342b33f
d_1_23:         .dword 0x6baa9a16cf86983f, 0xb37e8714d6ea2558
d_1_24:         .dword 0xdc5f936877628d59, 0x9f75354037ce221c
d_1_25:         .dword 0x1ba96c5714042bf5, 0x02181668e13db3a2
d_1_26:         .dword 0x00ac381bb4a79fa6, 0xbd208a693d70445e
d_1_27:         .dword 0xe9e5c16777da03c3, 0xaf3476db804a8729
                .dword 0xe53df348b41b5346, 0x0cf66b0197c54870
                .dword 0xb1eff5c540f7cd29, 0x8ba54e90cce97c00
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x8565a285c6f149b5, 0xb8360a76800baf1f
                .dword 0x5903ef5f80e08bed, 0x40796379169051d3
d_2_0:          .dword 0xb3d8be4fcfedf904, 0x011be77e0b484eb5
d_2_1:          .dword 0x70e006cb40da37e1, 0xf73dbc30cfc68b82
d_2_2:          .dword 0xa3aa4bd6176f828e, 0x3da63336c518cb25
d_2_3:          .dword 0xc77db604c2f8d26d, 0xaa01545e0fb809f9
d_2_4:          .dword 0xde7d9caee3e488b4, 0xf9a8a8195ce391a9
d_2_5:          .dword 0x953e87782367fb59, 0x9902aee5257a2abf
d_2_6:          .dword 0xaa709ea64dc5fb6f, 0x3ff1c6f11916eeda
d_2_7:          .dword 0x871337319e69c066, 0xf1b030d7e815b0ef
d_2_8:          .dword 0x6432e2aa246902a2, 0x1c26737be375c549
d_2_9:          .dword 0xf50f962556fa9ab8, 0x5fca0342b3d7372c
d_2_10:         .dword 0x06163a820f9f980a, 0x6a6dd970f74fa234
d_2_11:         .dword 0x09d75a573bc15cda, 0x8050d4047ed952d5
d_2_12:         .dword 0xee1005edec616b6f, 0xe16f45fd61383398
d_2_13:         .dword 0x30216de70fc30ae8, 0xe1ad16263f222198
d_2_14:         .dword 0x9b66c2b597400779, 0x26630522f3b66852
d_2_15:         .dword 0xb637b6f23b2cbf0f, 0xfe06b92eac3a66e1
d_2_16:         .dword 0xba1f8e4476bf79b7, 0x1c8c34b93d8caa02
d_2_17:         .dword 0x0bfb4453ac7373fc, 0x413537fd244635b2
d_2_18:         .dword 0xb927e3d23ebb0634, 0xd6fc0e700775545b
d_2_19:         .dword 0x70db5d9c94380e3b, 0x75430024d9b2332f
d_2_20:         .dword 0x08b24baf8f839fdd, 0xca79c7122d749803
d_2_21:         .dword 0x4754009963442916, 0xeb03869063c4f729
d_2_22:         .dword 0x75ce74c92648d0b9, 0xe0acd8c07c3c37df
d_2_23:         .dword 0xea07b5d76b0d692e, 0x8ddb1cbceb18e450
d_2_24:         .dword 0xf8175d76e59ca305, 0x6dbb3d0d2c2bb405
d_2_25:         .dword 0x725be2a3572c7718, 0xcea99c3323d804e5
d_2_26:         .dword 0xf1168fc944d5eb85, 0x12bebe6473914a6f
d_2_27:         .dword 0x58c5af22e72ec57e, 0x462ccc2066d44f9b
                .dword 0x98b194033f46a821, 0xb3438c4002f4e397
                .dword 0x3b00691a7a7d80cd, 0x40b6650cdab6de66
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x0833d4eb209b367c, 0xac32815c9726cc50
                .dword 0x0e79634b89eee81b, 0x4f07f2315a56a5c7
d_3_0:          .dword 0x7195abb747b5625e, 0x29dd9d746309413c
d_3_1:          .dword 0x7d50a27c84d1af8d, 0x34de0dabb1aecf60
d_3_2:          .dword 0x4e8aa26227cd667f, 0x918041960128db36
d_3_3:          .dword 0x00bd557c089efb43, 0xabf6890a260d534b
d_3_4:          .dword 0x029bdbf4fc1b30d4, 0xe285d3e1982be653
d_3_5:          .dword 0xd65a7cabe771fefb, 0x427f23f073743353
d_3_6:          .dword 0xfa0c7e58ca0bf33f, 0x21584aad17dd2e61
d_3_7:          .dword 0x02c6e60b5111897f, 0x69e8b0e4a75b263f
d_3_8:          .dword 0x74a12a7f16737132, 0x5b44fce240a13d48
d_3_9:          .dword 0xd17a5a71838314ab, 0x82b9c44fbb2995ed
d_3_10:         .dword 0x8f1ee40b871a4adb, 0xe0c6c62ba9303173
d_3_11:         .dword 0x2893c61ce701e4d4, 0xebd98f8a768a5834
d_3_12:         .dword 0x45a0ad5638db68bb, 0x831bb22702b6ff14
d_3_13:         .dword 0xefc6ac9a25488d22, 0x1636136cf9d2e3ee
d_3_14:         .dword 0xc75b1ece79f3a7e9, 0x30fb4d8f7fb91669
d_3_15:         .dword 0x218e435ef527692f, 0x3dc4c8cfdeab9451
d_3_16:         .dword 0x4ad9cb9bdf80c719, 0x6998eec45c814272
d_3_17:         .dword 0x6fc41c838cfba2c7, 0x4e4ef53ba2d931de
d_3_18:         .dword 0x3e47424095043a8b, 0x1567a48e3192d9ab
d_3_19:         .dword 0xcbea45970ca2132c, 0x936d77aada1fcc02
d_3_20:         .dword 0xea55f47fab66fe85, 0xd396e2bdb27563ee
d_3_21:         .dword 0xd6f9c5c8348ae08c, 0xaf0354da32abe7ca
d_3_22:         .dword 0xf33abf41e764690b, 0xfd00492330365261
d_3_23:         .dword 0xdab4000063dba793, 0x5230b9a70683a7cb
d_3_24:         .dword 0x18c7ca290cdf1fe9, 0x70e9b9c0ebd21187
d_3_25:         .dword 0x42c3bef730bb0310, 0x5eee2a9b8c06db26
d_3_26:         .dword 0x990bbf6b9af8cbd0, 0x8f5388f53a9127bc
d_3_27:         .dword 0x2c20e7b4bb90af99, 0x81b3e8a967f5a1fc
                .dword 0x4f52537cb52f1e91, 0x3226fda6d86ddd96
                .dword 0xcdd3c096bd82b59d, 0x48fa3f23557e5f3b
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x8412276a6230c3a9, 0x725f60cfa35b5637
                .dword 0x218fb15098917ce2, 0x8aa5e47bc75b802d
d_4_0:          .dword 0x2bffa8ed77b459f2, 0x9c707e3d3064c104
d_4_1:          .dword 0xc006520a94c72690, 0xdc3001f2cdc07961
d_4_2:          .dword 0x3284045f1cfc4d86, 0xf0c755bd6acbf410
d_4_3:          .dword 0x6a8aef888c48bea7, 0xc7275934812dc402
d_4_4:          .dword 0x30a8d23d6055ae1b, 0x4472fb971b33b43f
d_4_5:          .dword 0x942931b09df680b0, 0xa4159fb4b79000e6
d_4_6:          .dword 0xe6cd93d87d753d56, 0x95219efefb4c5981
d_4_7:          .dword 0x4360159840c89b04, 0xc84ab569aee486ec
d_4_8:          .dword 0x3482cf14b3d7bb6e, 0x5c1bcc2b6de1ff49
d_4_9:          .dword 0x413ac070da147c8c, 0x442bbdd3c20f000a
d_4_10:         .dword 0x6c816fa6f05c45f7, 0x701f07066b87a34f
d_4_11:         .dword 0xca2b840936830b94, 0xc5e7e9f786f6366f
d_4_12:         .dword 0x51d9f6dc3457fb36, 0x3d2d712d550d865a
d_4_13:         .dword 0x5f6a4a0815481fd9, 0xc584a0ee7ed65e2e
d_4_14:         .dword 0x1d5f40d16feaa0f1, 0xe07ee4da2570b968
d_4_15:         .dword 0x10a46e2dbc256630, 0x730f0aac97523472
d_4_16:         .dword 0x560948da189a3a64, 0xbee7adfc41afa30b
d_4_17:         .dword 0x5f0aa7e89a0be5da, 0x2c4e0b9ae327f0df
d_4_18:         .dword 0x9d9087cdb0ad11b0, 0x989d10fca448d057
d_4_19:         .dword 0xda418e8734d9db0f, 0xcbbff45e4d5ec70b
d_4_20:         .dword 0x57799a1c9bc50865, 0xdf50574a5aae334d
d_4_21:         .dword 0x69de817c95a9a6b0, 0x2d8734c44b16e94c
d_4_22:         .dword 0x10238afe1c6b62d5, 0xa079efc7871eeb97
d_4_23:         .dword 0x51f96b4c2e35e9ca, 0x957c0128cded0d71
d_4_24:         .dword 0x849e7cd8e85e85aa, 0x95f289d7ce0618e0
d_4_25:         .dword 0x1b0aea58aefac6b5, 0x926c15a2e9dfd247
d_4_26:         .dword 0x64be1b0d86da23ba, 0xfdde9b1e5ef19e2b
d_4_27:         .dword 0xa57b9411605489a6, 0xeb09d3a25ee96ff9
                .dword 0xf82e23dc07867ae9, 0x8a968705b366d009
                .dword 0xed87e8ae7c991bf5, 0x88d78f291b2bd768
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x0da29b33211ea2ea, 0xec6f952d060cca95
                .dword 0xcd226557c6a8be3a, 0xa733772b656c7356
d_5_0:          .dword 0xd6914f5fe1320eb9, 0x25de4522833d8d64
d_5_1:          .dword 0x408df2282c891ef8, 0x173141734e9a7e44
d_5_2:          .dword 0x31eba863efafe62d, 0x8f7df2213b310886
d_5_3:          .dword 0x690157968421fa86, 0xdfecc183e15076aa
d_5_4:          .dword 0x50bb1327208ad16d, 0x71aaf55e4df6c2d8
d_5_5:          .dword 0x5df544aca77327a7, 0xa82b717c47b6f4ba
d_5_6:          .dword 0x2a2bc7be11cb5571, 0x98aac6064bf24de0
d_5_7:          .dword 0x72b7a40d566348fe, 0xd54670f62354ae43
d_5_8:          .dword 0x53d5881d6a95dcde, 0x3d1c1ebe701081e1
d_5_9:          .dword 0x05c2d94f6faac217, 0xaa94785aff1d8740
d_5_10:         .dword 0xa7489ed1a12905c5, 0x20b00a3ab0997728
d_5_11:         .dword 0x632e9727a860b1e7, 0xb516f933b47511aa
d_5_12:         .dword 0xca0bfd051100694d, 0xc674b81e8a9b3ac9
d_5_13:         .dword 0x1e73850a43c581ab, 0x0d60cf0e165a7dd6
d_5_14:         .dword 0xec52c7a1435c82a1, 0xf66f41a8ce8afd46
d_5_15:         .dword 0x35bb04a341d33df7, 0xf2a7175bc111418a
d_5_16:         .dword 0x8a6586116edaef58, 0xeac475951f8d5514
d_5_17:         .dword 0xcffc1c6d40c2fe7d, 0x45ce6ff2912da192
d_5_18:         .dword 0xed7cc237f893ca75, 0x3a30a868c388623d
d_5_19:         .dword 0x8d420901f28cb4e6, 0xefb14d2579ab4ad5
d_5_20:         .dword 0xfca71188de7afeba, 0xb29a25eff7e1bb63
d_5_21:         .dword 0xfd294f22c1fbb27b, 0x9865f2a024bbffd9
d_5_22:         .dword 0xb0971bc76ea28c3d, 0x4b4640dc1f804a22
d_5_23:         .dword 0x67dd7184380a2e47, 0x048f93a6a3c9ecb4
d_5_24:         .dword 0x33eaba9e61259427, 0x07234a7372a0e920
d_5_25:         .dword 0x380a2d7d3669cfd4, 0x759d5f2c4c0cb096
d_5_26:         .dword 0x3ab10560f45824ba, 0x4939604585f3434b
d_5_27:         .dword 0x2f92edcf508179d6, 0x8fbc1c61d0eea256
                .dword 0x826d117ee606751d, 0x50d2e25cd5f0367f
                .dword 0x5b8ea004a86a11d6, 0x77bc64f9ce085342
         /* Random data */
_end_data5:
              
 
