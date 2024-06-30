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
_p0:    csrrsi x12, satp, 11                      ;
_p1:    la x12, _p2                               ;
        srai x12, x12, 1                          ;
        csrrs x10, pmpaddr6, x12                  ;
_p2:    csrrsi x12, sstatus, 29                   ;
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
_s0:    fence                                     ;
_s1:    la x22, d_4_3                             ;
        addi x22, x22, -0                         ;
        sc.d x15, x22, (x22)                      ;
_s2:    fmv.x.w x2, f10                           ;
_s3:    subw x28, x10, x26                        ;
_s4:    fcvt.wu.s x30, f9, rtz                    ;
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
_l0:    feq.s x10, f23, f10                       ;
_l1:    srli x22, x9, 63                          ;
_l2:    fcvt.lu.s x28, f26, rmm                   ;
_l3:    la x17, d_0_27                            ;
        addi x17, x17, 20                         ;
        amomin.w x28, x15, (x17)                  ;
_l4:    la x9, d_3_7                              ;
        addi x9, x9, 0                            ;
        lui x8, 0xffe00                           ;
        xor x9, x9, x8                            ;
        amominu.w x17, x8, (x9)                   ;
_l5:    bltu x21, x1, _l123                       ;
_l6:    blt x11, x13, _l163                       ;
_l7:    srli x17, x12, 17                         ;
_l8:    la x30, d_0_7                             ;
        fsw f26, -16(x30)                         ;
_l9:    la x1, d_4_10                             ;
        addi x1, x1, -24                          ;
        amoadd.d x23, x1, (x1)                    ;
_l10:   la x13, d_5_12                            ;
        addi x13, x13, 8                          ;
        amomin.d x11, x4, (x13)                   ;
_l11:   la x17, d_1_10                            ;
        sb x5, 24(x17)                            ;
_l12:   sraiw x4, x4, 31                          ;
_l13:   la x13, d_2_26                            ;
        lhu x3, -4(x13)                           ;
_l14:   la x27, _l14                              ;
        lw x25, -12(x27)                          ;
_l15:   csrrsi x10, sscratch, 6                   ;
_l16:   fcvt.s.l f16, x22, rne                    ;
_l17:   la x20, d_5_7                             ;
        lb x5, 2(x20)                             ;
_l18:   fnmadd.s f16, f12, f17, f7, rne           ;
_l19:   fcvt.lu.s x0, f25, rup                    ;
_l20:   remuw x16, x29, x0                        ;
_l21:   flt.s x22, f25, f16                       ;
_l22:   xor x18, x18, x18                         ;
        addi x15, zero, 3                         ;
        slli x15, x15, 4                          ;
        add x18, x18, x15                         ;
        csrrc x16, frm, x18                       ;
_l23:   fsqrt.s f9, f13, rup                      ;
_l24:   mulhu x26, x6, x30                        ;
_l25:   la x20, d_2_15                            ;
        addi x20, x20, -0                         ;
        amominu.w x13, x29, (x20)                 ;
_l26:   la x25, d_0_4                             ;
        lwu x18, 16(x25)                          ;
_l27:   sllw x9, x5, x18                          ;
_l28:   fclass.s x18, f9                          ;
_l29:   slliw x28, x12, 7                         ;
_l30:   la x13, d_5_9                             ;
        addi x13, x13, 0                          ;
        lr.d x29, (x13)                           ;
_l31:   la x13, d_3_2                             ;
        addi x13, x13, -8                         ;
        amoadd.d x11, x5, (x13)                   ;
_l32:   fcvt.s.lu f3, x18, rup                    ;
_l33:   xori x0, x22, 1701                        ;
_l34:   la x23, d_2_6                             ;
        sb x5, 4(x23)                             ;
_l35:   la x11, d_0_20                            ;
        addi x11, x11, -16                        ;
        lui x28, 0xffe00                          ;
        xor x11, x11, x28                         ;
        amomin.d x28, x28, (x11)                  ;
_l36:   la x23, d_5_19                            ;
        lwu x8, -4(x23)                           ;
_l37:   la x19, d_5_26                            ;
        sd x22, -16(x19)                          ;
_l38:   bltu x24, x13, _l69                       ;
_l39:   fcvt.w.s x13, f2, rne                     ;
_l40:   la x24, d_1_3                             ;
        addi x24, x24, 0                          ;
        amoand.d x26, x28, (x24)                  ;
_l41:   la x19, d_3_13                            ;
        addi x19, x19, 28                         ;
        lui x23, 0xffe00                          ;
        xor x19, x19, x23                         ;
        amoswap.w x27, x23, (x19)                 ;
_l42:   flt.s x17, f14, f16                       ;
_l43:   la x3, _l123                              ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l44:   fsqrt.s f11, f8, dyn                      ;
_l45:   fmv.w.x f24, x12                          ;
_l46:   divu x30, x13, x12                        ;
_l47:   la x11, _l145                             ;
        jalr x30, 0(x11)                          ;
_l48:   fsgnjx.s f0, f8, f13                      ;
_l49:   csrrwi x25, medeleg, 15                   ;
_l50:   ecall                                     ;
_l51:   fcvt.l.s x12, f26, rmm                    ;
_l52:   xor x26, x26, x26                         ;
        csrrc x12, satp, x26                      ;
_l53:   la x3, d_0_0                              ;
        addi x3, x3, 28                           ;
        amominu.w x13, x28, (x3)                  ;
_l54:   srli x16, x25, 29                         ;
_l55:   fmv.w.x f12, x30                          ;
_l56:   sltiu x9, x23, -0                         ;
_l57:   mulh x0, x15, x1                          ;
_l58:   la x3, d_5_24                             ;
        addi x3, x3, 0                            ;
        amomin.d x13, x17, (x3)                   ;
_l59:   mulh x12, x9, x18                         ;
_l60:   fnmsub.s f2, f14, f22, f3, rmm            ;
_l61:   fmin.s f14, f16, f0                       ;
_l62:   fclass.s x30, f14                         ;
_l63:   li x23, 0                                 ;
        la x7, pt2                                ;
        addi x7, x7, 0                            ;
        sfence.vma x23, x7                        ;
_l64:   csrrsi x2, mcause, 14                     ;
_l65:   csrrsi x21, pmpcfg0, 0                    ;
_l66:   ecall                                     ;
_l67:   ebreak                                    ;
_l68:   fmv.w.x f24, x24                          ;
_l69:   div x8, x30, x18                          ;
_l70:   csrrwi x29, mcause, 0                     ;
_l71:   csrrci x28, mip, 7                        ;
_l72:   fence                                     ;
_l73:   remuw x27, x24, x27                       ;
_l74:   csrrwi x10, mtval, 31                     ;
_l75:   la x6, d_2_16                             ;
        addi x6, x6, 8                            ;
        amoadd.d x12, x10, (x6)                   ;
_l76:   blt x29, x12, _l101                       ;
_l77:   mulhu x1, x22, x26                        ;
_l78:   fcvt.wu.s x2, f21, rdn                    ;
_l79:   feq.s x6, f3, f12                         ;
_l80:   fadd.s f16, f7, f19, rtz                  ;
_l81:   beq x9, x22, _l198                        ;
_l82:   la x5, d_1_22                             ;
        addi x5, x5, 0                            ;
        amoswap.d x21, x17, (x5)                  ;
_l83:   fmadd.s f7, f20, f16, f26, rtz            ;
_l84:   fcvt.lu.s x2, f17, rdn                    ;
_l85:   ecall                                     ;
_l86:   la x29, d_4_8                             ;
        addi x29, x29, -12                        ;
        amoxor.w x19, x14, (x29)                  ;
_l87:   andi x19, x17, -683                       ;
_l88:   la x23, _l14                              ;
        flw f30, 8(x23)                           ;
_l89:   la x15, d_1_20                            ;
        addi x15, x15, -8                         ;
        lui x5, 0xffe00                           ;
        xor x15, x15, x5                          ;
        amomaxu.d x9, x5, (x15)                   ;
_l90:   blt x27, x19, _l177                       ;
_l91:   la x1, d_2_10                             ;
        addi x1, x1, 28                           ;
        sc.w x10, x24, (x1)                       ;
_l92:   fcvt.lu.s x16, f8, rtz                    ;
_l93:   fmul.s f10, f19, f6, rdn                  ;
_l94:   remw x15, x22, x18                        ;
_l95:   bne x29, x17, _l148                       ;
_l96:   la x30, _l110                             ;
        csrrw zero, sepc, x30                     ;
        sret                                      ;
_l97:   la x21, d_5_23                            ;
        addi x21, x21, 8                          ;
        amoor.w x13, x5, (x21)                    ;
_l98:   addi x1, x1, 1283                         ;
_l99:   remu x30, x19, x12                        ;
_l100:  sllw x29, x21, x12                        ;
_l101:  auipc x8, 407824                          ;
_l102:  fmul.s f23, f18, f13, rmm                 ;
_l103:  la x24, d_0_12                            ;
        sh x28, -24(x24)                          ;
_l104:  fsgnj.s f19, f6, f16                      ;
_l105:  addiw x20, x14, 683                       ;
_l106:  xor x7, x7, x7                            ;
        addi x4, zero, 1                          ;
        slli x4, x4, 15                           ;
        add x7, x7, x4                            ;
        addi x22, zero, 1                         ;
        slli x22, x22, 5                          ;
        add x7, x7, x22                           ;
        addi x5, zero, 1                          ;
        slli x5, x5, 9                            ;
        add x7, x7, x5                            ;
        csrrc x16, sie, x7                        ;
_l107:  fdiv.s f30, f11, f9, rne                  ;
_l108:  la x5, d_3_24                             ;
        addi x5, x5, -24                          ;
        amoor.w x3, x13, (x5)                     ;
_l109:  mulh x6, x24, x25                         ;
_l110:  la x9, d_5_26                             ;
        addi x9, x9, -12                          ;
        lui x28, 0xffe00                          ;
        xor x9, x9, x28                           ;
        amoadd.w x29, x28, (x9)                   ;
_l111:  srai x27, x22, 40                         ;
_l112:  la x28, d_0_12                            ;
        sb x23, 24(x28)                           ;
_l113:  la x7, d_5_19                             ;
        addi x7, x7, -0                           ;
        amoor.d x14, x2, (x7)                     ;
_l114:  la x22, d_3_27                            ;
        sb x23, 31(x22)                           ;
_l115:  la x26, d_4_26                            ;
        addi x26, x26, 0                          ;
        sc.w x21, x25, (x26)                      ;
_l116:  beq x12, x7, _l166                        ;
_l117:  la x24, d_2_24                            ;
        lbu x4, -2(x24)                           ;
_l118:  la x1, _l186                              ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l119:  blt x18, x5, _l139                        ;
_l120:  la x10, d_1_0                             ;
        fsw f18, 4(x10)                           ;
_l121:  fsgnjx.s f10, f21, f26                    ;
_l122:  csrrci x13, pmpaddr1, 11                  ;
_l123:  la x11, d_4_12                            ;
        addi x11, x11, 24                         ;
        amomin.w x24, x9, (x11)                   ;
_l124:  addiw x4, x26, 2011                       ;
_l125:  srai x15, x17, 37                         ;
_l126:  divw x28, x23, x28                        ;
_l127:  la x21, d_0_0                             ;
        addi x21, x21, -4                         ;
        amoswap.w x2, x27, (x21)                  ;
_l128:  auipc x24, 1048575                        ;
_l129:  la x18, d_4_27                            ;
        sw x14, -12(x18)                          ;
_l130:  feq.s x10, f7, f21                        ;
_l131:  la x30, d_2_11                            ;
        lbu x30, 11(x30)                          ;
_l132:  la x11, d_5_9                             ;
        addi x11, x11, 16                         ;
        amoxor.w x20, x6, (x11)                   ;
_l133:  la x19, _l68                              ;
        lb x2, 1(x19)                             ;
_l134:  slliw x8, x19, 9                          ;
_l135:  mulhu x22, x11, x21                       ;
_l136:  jal x17, _l148                            ;
_l137:  bne x1, x27, _l157                        ;
_l138:  addiw x19, x21, 0                         ;
_l139:  fcvt.wu.s x29, f23, rtz                   ;
_l140:  la x3, _l69                               ;
        lhu x18, 22(x3)                           ;
_l141:  remuw x9, x15, x22                        ;
_l142:  la x26, d_2_22                            ;
        addi x26, x26, 28                         ;
        amoxor.w x14, x26, (x26)                  ;
_l143:  divu x1, x24, x17                         ;
_l144:  la x17, d_4_6                             ;
        addi x17, x17, 0                          ;
        amomax.d x21, x4, (x17)                   ;
_l145:  fsqrt.s f24, f3, rdn                      ;
_l146:  fcvt.l.s x5, f25, rne                     ;
_l147:  fsqrt.s f23, f29, rtz                     ;
_l148:  xor x15, x15, x15                         ;
        addi x30, zero, 3                         ;
        slli x30, x30, 28                         ;
        add x15, x15, x30                         ;
        addi x20, zero, 3                         ;
        slli x20, x20, 1                          ;
        add x15, x15, x20                         ;
        csrrs x6, sip, x15                        ;
_l149:  blt x12, x18, _l182                       ;
_l150:  xor x16, x16, x16                         ;
        csrrw x19, sie, x16                       ;
_l151:  la x28, d_0_7                             ;
        addi x28, x28, -20                        ;
        amoand.w x17, x8, (x28)                   ;
_l152:  li x12, 0                                 ;
        la x17, pt1                               ;
        addi x17, x17, 32                         ;
        sfence.vma x12, x17                       ;
_l153:  lui x30, 825714                           ;
_l154:  la x11, d_3_23                            ;
        addi x11, x11, 16                         ;
        amomaxu.d x9, x5, (x11)                   ;
_l155:  la x25, d_1_2                             ;
        addi x25, x25, 16                         ;
        amoand.d x12, x24, (x25)                  ;
_l156:  la x29, d_4_27                            ;
        lb x14, -31(x29)                          ;
_l157:  rem x2, x6, x28                           ;
_l158:  addi x9, x26, -1967                       ;
_l159:  ebreak                                    ;
_l160:  remu x5, x22, x15                         ;
_l161:  fadd.s f19, f14, f14, rne                 ;
_l162:  subw x9, x24, x10                         ;
_l163:  la x2, _l122                              ;
        srai x2, x2, 1                            ;
        csrrw x14, pmpaddr0, x2                   ;
_l164:  fmax.s f13, f6, f2                        ;
_l165:  fcvt.s.w f12, x13, rmm                    ;
_l166:  la x17, d_5_18                            ;
        addi x17, x17, -12                        ;
        amoswap.w x28, x24, (x17)                 ;
_l167:  ori x13, x30, -1397                       ;
_l168:  csrrci x13, sstatus, 31                   ;
_l169:  fmin.s f16, f22, f30                      ;
_l170:  beq x29, x3, _l195                        ;
_l171:  lui x30, 0                                ;
_l172:  la x24, _l194                             ;
        csrrw zero, uepc, x24                     ;
        uret                                      ;
_l173:  csrrci x25, mtval, 4                      ;
_l174:  fnmsub.s f18, f12, f4, f29, rmm           ;
_l175:  slti x17, x29, -2047                      ;
_l176:  mulh x27, x11, x25                        ;
_l177:  jal x25, _l196                            ;
_l178:  fence                                     ;
_l179:  la x6, d_1_7                              ;
        addi x6, x6, -12                          ;
        amomax.w x5, x1, (x6)                     ;
_l180:  fsgnjn.s f1, f1, f2                       ;
_l181:  la x20, d_5_1                             ;
        addi x20, x20, 28                         ;
        amoand.w x8, x21, (x20)                   ;
_l182:  la x5, d_0_0                              ;
        lwu x14, -28(x5)                          ;
_l183:  la x23, _l200                             ;
        csrrw zero, uepc, x23                     ;
        uret                                      ;
_l184:  la x3, d_0_24                             ;
        addi x3, x3, -0                           ;
        amominu.w x19, x4, (x3)                   ;
_l185:  la x16, d_3_2                             ;
        fsw f3, 0(x16)                            ;
_l186:  fmul.s f30, f26, f1, dyn                  ;
_l187:  divw x29, x30, x4                         ;
_l188:  la x14, d_5_1                             ;
        addi x14, x14, 0                          ;
        lr.d x5, (x14)                            ;
_l189:  la x4, d_2_15                             ;
        addi x4, x4, -4                           ;
        amomax.w x16, x24, (x4)                   ;
_l190:  csrrsi x18, pmpaddr5, 0                   ;
_l191:  la x5, _l197                              ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_l192:  la x27, d_1_22                            ;
        addi x27, x27, -0                         ;
        amoor.w x18, x1, (x27)                    ;
_l193:  la x21, d_2_26                            ;
        addi x21, x21, -24                        ;
        amoadd.w x26, x6, (x21)                   ;
_l194:  csrrsi x1, mcause, 2                      ;
_l195:  div x13, x4, x7                           ;
_l196:  la x16, d_2_26                            ;
        addi x16, x16, -24                        ;
        amomax.d x3, x12, (x16)                   ;
_l197:  la x24, d_0_10                            ;
        addi x24, x24, -0                         ;
        amoand.d x14, x24, (x24)                  ;
_l198:  subw x27, x13, x15                        ;
_l199:  srliw x19, x20, 7                         ;
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
                .dword 0x56144e860f61fe5a, 0x1c2a19030a437b57
                .dword 0xa2c653ab2cbc1c01, 0x3648db42a6d2b1ae
d_0_0:          .dword 0x8dec6b2914c66803, 0x495b9b78445baed7
d_0_1:          .dword 0xc391c300619c2fbf, 0x7f7b744c25c474a6
d_0_2:          .dword 0x4241eb0cf8c7e2ee, 0x5831ede9a5910a54
d_0_3:          .dword 0xb695621312d43498, 0x9242fa78a1ad549d
d_0_4:          .dword 0x0b8afb57d0584fbe, 0x3cb3350b1b1a56f9
d_0_5:          .dword 0xf351adacdeeff1d8, 0x8c901d4f8341bb8c
d_0_6:          .dword 0x3f337889556c91d4, 0xc009c9c697c642fa
d_0_7:          .dword 0xbad11148c69b18e1, 0x8ba4f9c97cfa786f
d_0_8:          .dword 0xa8edc01b5b6f99c6, 0xf4db154ce80cda35
d_0_9:          .dword 0x8639d8edfcf61d9a, 0xb0dcad134af6d3ae
d_0_10:         .dword 0x88228d7cc9c05645, 0xa559447bc0fb2f0c
d_0_11:         .dword 0xfef95cc8ebe049af, 0x03c7293b3ec519c5
d_0_12:         .dword 0xf19a09e1fce749e9, 0xc8bbaa37a7734a3d
d_0_13:         .dword 0x2d7d522fdd09544f, 0x3a36aaa7038df308
d_0_14:         .dword 0x8806d8db1706f964, 0x699f8a1d11105814
d_0_15:         .dword 0xb31373b980385fe7, 0x4b58138dc71c7451
d_0_16:         .dword 0x2b67d6cdb6b1968c, 0x04bffed67a39a585
d_0_17:         .dword 0x55ac0b153f460d83, 0xde4e1aea3236b26b
d_0_18:         .dword 0x47530e75296d55ff, 0x244bac54aed9fc5a
d_0_19:         .dword 0x633aa7861485199c, 0xb9bfe04d2cbe4fc3
d_0_20:         .dword 0xb7e28fadc4311bb8, 0x6515f553013ce64b
d_0_21:         .dword 0xddc21828571d14f2, 0xe1853ed76f07340c
d_0_22:         .dword 0x5253d4af3542a2dd, 0xa70941df024e3c7e
d_0_23:         .dword 0xd67e6a12ba9e6799, 0x3c2aed4f3143aa25
d_0_24:         .dword 0x26766a6db056b474, 0x9f2005316ea9d217
d_0_25:         .dword 0xe839aea0e28e82c7, 0xaa4306cfaeb4a6cd
d_0_26:         .dword 0x0a1df0bbd01726f6, 0x735cf5748506d916
d_0_27:         .dword 0x28b417b422507d29, 0x2b9f7329a7dd47b5
                .dword 0xd41a613fe45dae69, 0x143697bcd24eddeb
                .dword 0x0eb6d9c3d7af12df, 0xb1882c0345f28889
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0ad14bf44518b4e4, 0xcb32fffb6d34c8e8
                .dword 0xa91882623d8fd18e, 0x1862789486c67599
d_1_0:          .dword 0xa77616daaf407571, 0x7fb20fb4b3ce34f2
d_1_1:          .dword 0xf4ab419106de2696, 0x94a98c9ee7bbb770
d_1_2:          .dword 0xd06efc0a15f6e65f, 0x10273ef96da50c44
d_1_3:          .dword 0x8edbb747dfe488e1, 0x78aa2f6bbb53d2cf
d_1_4:          .dword 0xb55c98226ca647ef, 0x65344cc2bee3d801
d_1_5:          .dword 0xf0c94440a52a67c7, 0x8337d1cbf9cd9020
d_1_6:          .dword 0x7dc485a5db5073e0, 0x18b7fd3b0f9cd5e1
d_1_7:          .dword 0x2c4d34a0c0a25120, 0x7f7c99a0b2762918
d_1_8:          .dword 0xf8331d1edec30e06, 0x26d357917ccedeb8
d_1_9:          .dword 0x0f52f2fe2978f29d, 0xecf1f43829a5fd71
d_1_10:         .dword 0x8596a427578aa09c, 0x3f231ac268120ac2
d_1_11:         .dword 0x39671821f60bed84, 0xb8e115305aac5c81
d_1_12:         .dword 0x9487af229826e4cc, 0x7733fa21bd26d557
d_1_13:         .dword 0x2f867758f88c92fd, 0x8bcecabf0971f39d
d_1_14:         .dword 0x2f96765d7f3867db, 0x59f25dc74d28b16f
d_1_15:         .dword 0xec475d1be43ad90e, 0xd9b8ec8c68b0391e
d_1_16:         .dword 0xc7525dc146583028, 0xa112db6799d7f945
d_1_17:         .dword 0x523a175fc21f5615, 0x3b0b311c913e70c4
d_1_18:         .dword 0x40a9e69e96ac1ac2, 0xce7986e24de74b94
d_1_19:         .dword 0xc6b43cc06fdfa994, 0x05ceaefca27a760f
d_1_20:         .dword 0xd54a19096344ffad, 0xb0536c969dbf5839
d_1_21:         .dword 0x7ce66ac049523bd9, 0xca9669eef1cbc84f
d_1_22:         .dword 0x63f25116a9b9c481, 0xf6f8aea3cbf4344f
d_1_23:         .dword 0xbcbadeda6f308666, 0x502740dc4a1659df
d_1_24:         .dword 0xd03787d89a494221, 0x0488f3012d6bd22c
d_1_25:         .dword 0xaa924049d9f38eac, 0x213f995710ce0bc2
d_1_26:         .dword 0x2571f56e03c7f2f5, 0x906f6ddd04533077
d_1_27:         .dword 0x41356d3f805692e0, 0x38df38c1eb52a119
                .dword 0x1c6edba3a07befca, 0xdbb7d9f0360a5670
                .dword 0x2f1518a5f079636e, 0xe6c018c760e3230e
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc453740568c95f4f, 0x7eb00239f83c1ba4
                .dword 0x5c41e51bb24c19f6, 0xf3d0d5052c78da20
d_2_0:          .dword 0x5ff6b7761a10bc01, 0xc58f0881b2376699
d_2_1:          .dword 0xd69ab058ee5bc835, 0xfd7d7ec315bc9b51
d_2_2:          .dword 0x66f02746d9d626cd, 0xf21bcf55eedcf71c
d_2_3:          .dword 0xdad30c122d3e7121, 0xefe1ca16462d08c1
d_2_4:          .dword 0x6e725edf3791f9fc, 0x7487dfc98060d180
d_2_5:          .dword 0x450e65c605eff961, 0xe48c740b097c143a
d_2_6:          .dword 0x28ff87e8faf4b0a1, 0x4abd632a0de1ce34
d_2_7:          .dword 0x0bad1fbb7b16579d, 0xcd4e7062eb80c80b
d_2_8:          .dword 0x4d4c370010e44489, 0x195690bc8300b7c0
d_2_9:          .dword 0xa6aa9c7406d26f59, 0xe6c17b3d12ddd1c0
d_2_10:         .dword 0xa8b9a32bc4f1b79a, 0x82e9ac541edba3ff
d_2_11:         .dword 0x82af1a64ff636d0e, 0xb6cdeb1827d60772
d_2_12:         .dword 0xf8c395578b55c6b0, 0xdf39bace46ffb953
d_2_13:         .dword 0x15b7beeba9038bf1, 0xe44d9606570e7495
d_2_14:         .dword 0xc0e40926d39cf8f4, 0x395c955a91ec207c
d_2_15:         .dword 0xddaa953a30801082, 0xe2d84e6bb92324af
d_2_16:         .dword 0x45cca682d77d0321, 0x2afd867344c29658
d_2_17:         .dword 0x75e9c840d2cadd87, 0x2d27649ed3a6a388
d_2_18:         .dword 0xe16e33668f287e7a, 0xa44ea8198405a093
d_2_19:         .dword 0x0df1dfd9021fe656, 0xbfeb59d72ada6c6e
d_2_20:         .dword 0x30eafe778d240b7c, 0xcfb931d136f07b54
d_2_21:         .dword 0x827cb270b4d7c90e, 0x523ee641d9d447c2
d_2_22:         .dword 0x51c19256b4830cc0, 0xf17217f0646cb0f4
d_2_23:         .dword 0xa28659206e565760, 0xf506c3deddbedafe
d_2_24:         .dword 0x469d5248c53c6eb9, 0xd2afd1d7c5964177
d_2_25:         .dword 0x5ea2a550ac87718d, 0xcd2111c4f59ffde5
d_2_26:         .dword 0xac558fd2707f7cc8, 0x5510f15dcbd1fa08
d_2_27:         .dword 0xd7e9d74e5be54216, 0xed5899ebcb054184
                .dword 0x3163ece1362c297c, 0x604fcf5a81f1ad35
                .dword 0x9e7052d41b88fb37, 0xf673251442cb2d5b
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x995ad31c64901ce2, 0x49fdf13ddb834d08
                .dword 0x2b71fefbd5be9899, 0x54e59672d3bfa3e6
d_3_0:          .dword 0xc0b1cb1e81b30ae9, 0xbee58a5164372dc2
d_3_1:          .dword 0x6415b77597bd031c, 0x0ee971706e426cef
d_3_2:          .dword 0x1160d67a62b408bc, 0xa7e7d1cad775442f
d_3_3:          .dword 0x2a61e4e53d902235, 0x438e7c9b586cf00a
d_3_4:          .dword 0x6bf6816936762e31, 0x16a03df367f2f76e
d_3_5:          .dword 0x2c348e7ce909df5a, 0xa1696bd4b46c10a4
d_3_6:          .dword 0xfc54518543b1417e, 0x30c3126fc00349d0
d_3_7:          .dword 0xb834710c73f440e7, 0xa64b1129e447f70a
d_3_8:          .dword 0x47668d477d3ab1b0, 0xbed90550aaf8ef43
d_3_9:          .dword 0x796005d8ff29dd1d, 0xe15db52e610f8072
d_3_10:         .dword 0x9be74a1bc9d381ae, 0xe0e1fcec78a3c0ab
d_3_11:         .dword 0x9123e9ba0696dd83, 0x539334abdfe229bd
d_3_12:         .dword 0x2d0eeee74ac9c7fd, 0xcc14a376c0f65b89
d_3_13:         .dword 0x42269439a3835a70, 0x81ec33f3d9d4b183
d_3_14:         .dword 0x023905ff36984e44, 0xa195c420c8fc23cd
d_3_15:         .dword 0x1f0649df0741a6f0, 0x0349eab93b488dca
d_3_16:         .dword 0x2f2234e890ba8ba1, 0x224afb6361015ec8
d_3_17:         .dword 0xc37c29693f0bab05, 0x93e35f8957543f5e
d_3_18:         .dword 0x21cc220ceb324236, 0x12655e2fad9305d4
d_3_19:         .dword 0x5fec51b415dc2be3, 0x91e73a1f8832ac4c
d_3_20:         .dword 0xebd6031afdd54ec7, 0xf85c9d608995e7fc
d_3_21:         .dword 0xc486fa02880faf19, 0x22cb1fb32c63018e
d_3_22:         .dword 0xfdc1253f6fd4291a, 0xf0d734eb640d048b
d_3_23:         .dword 0x79bb0f7a288e1d71, 0xf56aa0a5ec444244
d_3_24:         .dword 0x10c7d8f4f4207709, 0xa9c62a2f5f08db2f
d_3_25:         .dword 0xd9ddebe58578a520, 0xd19094fe7e5d80fc
d_3_26:         .dword 0x64b261e489ebd9f0, 0x315bdca2611543ba
d_3_27:         .dword 0xb42a4bd69a3bf09d, 0x57c741e5f9ccdcc1
                .dword 0xede53e696d4701b2, 0x699f376c0fec027c
                .dword 0x08387dee4ea4923a, 0x363cfa062a8dae14
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xdb2d415ebe549a4b, 0x00e77feea5b15354
                .dword 0x552f49a87ea538ea, 0x81a3d6198fc18303
d_4_0:          .dword 0xd07804b3e9324eb7, 0x47d53af40fd03313
d_4_1:          .dword 0x86138ee497fd256a, 0x29515ff3cc226b2e
d_4_2:          .dword 0x1825923034452045, 0xc086ddc08bd23935
d_4_3:          .dword 0x126714f71090915b, 0xbb0c1365f3b94057
d_4_4:          .dword 0xef89782313ccfcb9, 0x5d50f504a8531a01
d_4_5:          .dword 0x93bc55af3479fbb9, 0x6092c6988ac06bd1
d_4_6:          .dword 0x51b9e512d08bbdf5, 0x3e0e6e7d60bc3c7b
d_4_7:          .dword 0xad280fcfe550127f, 0xf1f6570195c85ef8
d_4_8:          .dword 0x24323b3917507364, 0xb17645820a4f49a4
d_4_9:          .dword 0x775d7d40f0b9998e, 0x47f1ec5ce91dbb09
d_4_10:         .dword 0x650b083c9627f6f6, 0x3d6b32828fc05626
d_4_11:         .dword 0xfcf31067aa3e8be0, 0x83997911b4396078
d_4_12:         .dword 0x4967e6088bfbf595, 0xd61c144127125449
d_4_13:         .dword 0x40a69419baedbee4, 0x8408f63b1f336f83
d_4_14:         .dword 0xfefb78d9ea0138ec, 0xd7c33121ca943ce3
d_4_15:         .dword 0x2731e53c3d4fdedc, 0xe5dfc05d1782255f
d_4_16:         .dword 0xfdf27702d4b17f39, 0x7a166217bb3cea7b
d_4_17:         .dword 0xeeeda89a0ae08932, 0xeeacbf7ee11e069f
d_4_18:         .dword 0x3b74f8827c4ba3bf, 0x6a5c3c67755f5b14
d_4_19:         .dword 0x8410348c6ec067cf, 0x4fa99bdbf364c801
d_4_20:         .dword 0xb4f01c7836051891, 0x7c0e229e0c14e7a1
d_4_21:         .dword 0xaffb3be0af7dc334, 0x349d8272f75b3070
d_4_22:         .dword 0x819b50aad9abfbc7, 0x42ff8e2bfce6c3a4
d_4_23:         .dword 0x76e0320e02783da9, 0x11dcd177d6e9a318
d_4_24:         .dword 0x041e7125c3efc289, 0xd37ebda09d4d0804
d_4_25:         .dword 0x0e366c953498f045, 0x9deb55444f01a1f6
d_4_26:         .dword 0xedb483e45baa04b2, 0xb23da089601ee567
d_4_27:         .dword 0x5facf527a9eca4e6, 0x556a7226b34b976d
                .dword 0x9a9309201229f414, 0x3a88107619ae6d80
                .dword 0xc4f436130f25c923, 0x9b3d63329e9b799c
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xa274a127fa12be81, 0x96126c901abe1e8c
                .dword 0x27a559cbdcc5dc5d, 0x6583bfc8a2b1b805
d_5_0:          .dword 0x077a93c501bef922, 0x2d57daa39191ee86
d_5_1:          .dword 0x7388b004484801ab, 0xcb03cd1241cb51aa
d_5_2:          .dword 0xd6c99b98e4f743d5, 0x63c58b8e4f06f52c
d_5_3:          .dword 0xa3b95456f5fed5cb, 0xb0eb1b5618455c88
d_5_4:          .dword 0x4cfaa192ea2ed0aa, 0x4156c4a33ae5d8af
d_5_5:          .dword 0x02750a2e25ffa1d1, 0x6164dc2b731369e9
d_5_6:          .dword 0x4100ce5c8fa1eed8, 0x189c61184c3212ec
d_5_7:          .dword 0xcaed904056e52a6b, 0x560ffb5722aa2250
d_5_8:          .dword 0x641ba49bd5ff0a86, 0x2bf6ed68ea7c143d
d_5_9:          .dword 0x3a1a58cf9dd0e8e0, 0x0fb6d85dfb338db5
d_5_10:         .dword 0xba8a0016b6acbb19, 0x03c89a3e5d15f2cd
d_5_11:         .dword 0x7b811b6c10e48c7f, 0x798e551a25761ecd
d_5_12:         .dword 0x7f09a42c7084e02d, 0x12c27f77c536fa9a
d_5_13:         .dword 0x01fc89070999a495, 0xccb08d04d543cf12
d_5_14:         .dword 0x68ed37b2b324e08b, 0xb43be7be59330873
d_5_15:         .dword 0xaacf43de4bcbd7f7, 0x24f32087ab845c09
d_5_16:         .dword 0x682574158ede1c56, 0xdcc2a863c911ff00
d_5_17:         .dword 0xd47acbe71368355d, 0x06e56b69fb2974b9
d_5_18:         .dword 0x4cc821b2508ce6ad, 0x7fba1664c39735d9
d_5_19:         .dword 0x08aa8bea37cd9a81, 0x7396a09484e4bc3b
d_5_20:         .dword 0xe080751d3e7ec04d, 0x056ae05d51373aa8
d_5_21:         .dword 0xb3efaa4595133256, 0x3c0b9a235c201788
d_5_22:         .dword 0x9e4394eee2f468b7, 0x1552617e812efcbd
d_5_23:         .dword 0xd6ad703fd8cb517e, 0x62f28547d6023d8d
d_5_24:         .dword 0x1b1010951ab2fb7a, 0x39fd7ae65b15062e
d_5_25:         .dword 0x4fc88e1afcb3e104, 0xd4491d0dd11c5340
d_5_26:         .dword 0x1f7c8dd4cc81405c, 0x2ea2b26dd96987fc
d_5_27:         .dword 0xd0c29d551c79027f, 0x393db85576248273
                .dword 0x228292529b04429a, 0x91e171f64c583a6a
                .dword 0x631841d381a8929a, 0xedc41755a6ce690c
         /* Random data */
_end_data5:
              
 
