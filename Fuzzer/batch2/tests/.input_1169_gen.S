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
_p0:    csrrsi x12, satp, 5                       ;
_p1:    csrrsi x10, mcause, 0                     ;
_p2:    xor x14, x14, x14                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 18                         ;
        add x14, x14, x13                         ;
        csrrc x12, stval, x14                     ;
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
_s0:    fadd.s f3, f19, f4, rne                   ;
_s1:    fcvt.s.w f9, x6, rne                      ;
_s2:    xori x19, x18, -0                         ;
_s3:    fsgnjn.s f14, f26, f27                    ;
_s4:    la x12, d_1_18                            ;
        fsw f17, -0(x12)                          ;
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
_l0:    bgeu x4, x4, _l173                        ;
_l1:    sraw x25, x14, x12                        ;
_l2:    la x28, d_1_1                             ;
        addi x28, x28, -16                        ;
        amominu.d x17, x22, (x28)                 ;
_l3:    ecall                                     ;
_l4:    remw x4, x14, x25                         ;
_l5:    ori x6, x24, 2047                         ;
_l6:    slli x0, x29, 9                           ;
_l7:    ecall                                     ;
_l8:    remuw x19, x1, x29                        ;
_l9:    srli x17, x4, 23                          ;
_l10:   la x8, _l81                               ;
        lwu x1, -16(x8)                           ;
_l11:   bge x19, x6, _l30                         ;
_l12:   beq x21, x20, _l144                       ;
_l13:   fcvt.wu.s x23, f17, dyn                   ;
_l14:   sltiu x2, x12, 0                          ;
_l15:   la x6, d_2_18                             ;
        addi x6, x6, -8                           ;
        sc.d x7, x6, (x6)                         ;
_l16:   la x17, _l79                              ;
        flw f17, -0(x17)                          ;
_l17:   fclass.s x12, f1                          ;
_l18:   li x20, 0                                 ;
        la x22, pt2                               ;
        addi x22, x22, 24                         ;
        sfence.vma x20, x22                       ;
_l19:   srlw x8, x24, x5                          ;
_l20:   mulh x19, x7, x1                          ;
_l21:   bltu x27, x20, _l34                       ;
_l22:   la x4, d_4_22                             ;
        addi x4, x4, 24                           ;
        lui x19, 0xffe00                          ;
        xor x4, x4, x19                           ;
        amomin.d x20, x19, (x4)                   ;
_l23:   la x21, d_3_20                            ;
        addi x21, x21, -28                        ;
        amomin.w x5, x12, (x21)                   ;
_l24:   la x17, _l120                             ;
        csrrw zero, mepc, x17                     ;
        mret                                      ;
_l25:   remw x13, x1, x19                         ;
_l26:   csrrwi x23, pmpaddr2, 30                  ;
_l27:   fcvt.s.wu f7, x17, rdn                    ;
_l28:   subw x17, x1, x23                         ;
_l29:   fcvt.s.l f0, x21, rdn                     ;
_l30:   fcvt.s.w f28, x0, rtz                     ;
_l31:   subw x20, x11, x0                         ;
_l32:   divu x19, x11, x12                        ;
_l33:   la x21, _l136                             ;
        jalr x14, 0(x21)                          ;
_l34:   la x13, _l163                             ;
        jalr x9, 0(x13)                           ;
_l35:   fcvt.s.l f28, x22, rtz                    ;
_l36:   fnmsub.s f7, f16, f29, f7, rne            ;
_l37:   fsqrt.s f8, f23, rmm                      ;
_l38:   fcvt.w.s x12, f8, rmm                     ;
_l39:   la x1, _l135                              ;
        jalr x28, 0(x1)                           ;
_l40:   la x2, d_3_17                             ;
        addi x2, x2, 20                           ;
        amominu.w x5, x7, (x2)                    ;
_l41:   csrrwi x17, pmpaddr3, 0                   ;
_l42:   la x6, d_1_23                             ;
        lw x4, -0(x6)                             ;
_l43:   addi x7, x18, 2047                        ;
_l44:   fsgnjn.s f19, f1, f24                     ;
_l45:   andi x5, x19, -1349                       ;
_l46:   la x8, d_3_25                             ;
        sh x2, -4(x8)                             ;
_l47:   mulhsu x20, x17, x15                      ;
_l48:   addiw x29, x8, -1542                      ;
_l49:   la x14, d_0_16                            ;
        lb x20, -9(x14)                           ;
_l50:   la x18, d_2_6                             ;
        addi x18, x18, -8                         ;
        lr.d x9, (x18)                            ;
_l51:   feq.s x4, f14, f18                        ;
_l52:   fence.i                                   ;
_l53:   la x19, d_2_17                            ;
        lw x1, -28(x19)                           ;
_l54:   la x16, d_4_10                            ;
        addi x16, x16, 20                         ;
        amoswap.w x7, x24, (x16)                  ;
_l55:   xor x15, x15, x15                         ;
        addi x20, zero, 1                         ;
        slli x20, x20, 13                         ;
        add x15, x15, x20                         ;
        addi x19, zero, 1                         ;
        slli x19, x19, 5                          ;
        add x15, x15, x19                         ;
        addi x28, zero, 1                         ;
        slli x28, x28, 0                          ;
        add x15, x15, x28                         ;
        csrrw x17, frm, x15                       ;
_l56:   la x13, _l131                             ;
        jalr x24, 0(x13)                          ;
_l57:   la x22, d_1_5                             ;
        addi x22, x22, 28                         ;
        amomax.w x22, x22, (x22)                  ;
_l58:   la x6, d_5_10                             ;
        srai x6, x6, 1                            ;
        csrrs x3, pmpaddr5, x6                    ;
_l59:   la x19, d_5_26                            ;
        addi x19, x19, -4                         ;
        amoxor.w x6, x19, (x19)                   ;
_l60:   beq x17, x28, _l156                       ;
_l61:   la x26, d_5_2                             ;
        sb x28, -10(x26)                          ;
_l62:   bgeu x1, x3, _l119                        ;
_l63:   beq x10, x9, _l71                         ;
_l64:   fsub.s f5, f20, f29, rtz                  ;
_l65:   la x9, d_2_25                             ;
        lb x4, -15(x9)                            ;
_l66:   csrrwi x19, mstatus, 8                    ;
_l67:   fle.s x4, f8, f2                          ;
_l68:   fmax.s f2, f19, f24                       ;
_l69:   mulhu x29, x1, x10                        ;
_l70:   fle.s x11, f12, f17                       ;
_l71:   bgeu x18, x27, _l101                      ;
_l72:   la x17, d_3_0                             ;
        flw f29, -0(x17)                          ;
_l73:   fmin.s f1, f29, f22                       ;
_l74:   feq.s x16, f22, f20                       ;
_l75:   subw x28, x24, x26                        ;
_l76:   la x4, _l147                              ;
        csrrw zero, mepc, x4                      ;
        mret                                      ;
_l77:   fsgnj.s f31, f10, f24                     ;
_l78:   divuw x6, x14, x14                        ;
_l79:   csrrwi x12, sscratch, 11                  ;
_l80:   la x27, _l109                             ;
        csrrw zero, mepc, x27                     ;
        mret                                      ;
_l81:   subw x17, x27, x12                        ;
_l82:   flt.s x6, f9, f16                         ;
_l83:   bge x29, x4, _l92                         ;
_l84:   mulh x22, x1, x2                          ;
_l85:   fence.i                                   ;
_l86:   fsqrt.s f7, f2, rne                       ;
_l87:   la x23, _l138                             ;
        csrrw zero, mepc, x23                     ;
        mret                                      ;
_l88:   feq.s x30, f9, f8                         ;
_l89:   fmadd.s f1, f29, f7, f23, rmm             ;
_l90:   la x1, _l182                              ;
        csrrw zero, uepc, x1                      ;
        uret                                      ;
_l91:   srai x5, x23, 39                          ;
_l92:   li x1, 0                                  ;
        la x30, pt0                               ;
        addi x30, x30, 0                          ;
        sfence.vma x1, x30                        ;
_l93:   divuw x0, x20, x22                        ;
_l94:   fcvt.wu.s x18, f25, dyn                   ;
_l95:   divu x30, x17, x24                        ;
_l96:   la x11, d_2_6                             ;
        lwu x23, -0(x11)                          ;
_l97:   fence.i                                   ;
_l98:   fmadd.s f26, f29, f3, f19, rup            ;
_l99:   la x3, d_2_14                             ;
        lb x16, 11(x3)                            ;
_l100:  remu x5, x27, x23                         ;
_l101:  bgeu x18, x14, _l149                      ;
_l102:  bne x15, x10, _l193                       ;
_l103:  bne x11, x28, _l196                       ;
_l104:  addi x3, x13, 996                         ;
_l105:  fmv.w.x f12, x0                           ;
_l106:  csrrsi x18, pmpaddr4, 17                  ;
_l107:  remu x2, x3, x12                          ;
_l108:  la x23, d_4_24                            ;
        addi x23, x23, -16                        ;
        lr.d x22, (x23)                           ;
_l109:  bne x13, x29, _l168                       ;
_l110:  la x30, _l155                             ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l111:  li x27, 1                                 ;
        la x0, pt3                                ;
        addi x0, x0, 8                            ;
        sfence.vma x27, x0                        ;
_l112:  addw x6, x22, x8                          ;
_l113:  remw x27, x11, x17                        ;
_l114:  fsgnj.s f24, f18, f31                     ;
_l115:  la x4, d_5_4                              ;
        sb x10, 30(x4)                            ;
_l116:  lui x23, 772236                           ;
_l117:  la x30, _l184                             ;
        csrrw zero, mepc, x30                     ;
        mret                                      ;
_l118:  fmul.s f16, f3, f10, rtz                  ;
_l119:  csrrci x17, mhartid, 31                   ;
_l120:  fcvt.w.s x16, f24, rne                    ;
_l121:  addiw x8, x22, -0                         ;
_l122:  la x11, d_3_26                            ;
        addi x11, x11, -24                        ;
        lui x28, 0xffe00                          ;
        xor x11, x11, x28                         ;
        amoor.w x4, x28, (x11)                    ;
_l123:  slliw x20, x28, 4                         ;
_l124:  lui x19, 904496                           ;
_l125:  andi x16, x11, -21                        ;
_l126:  auipc x24, 1015516                        ;
_l127:  remw x4, x13, x18                         ;
_l128:  fsqrt.s f11, f1, rtz                      ;
_l129:  la x23, d_0_22                            ;
        addi x23, x23, 24                         ;
        amomax.d x28, x24, (x23)                  ;
_l130:  la x7, _l32                               ;
        lb x13, -4(x7)                            ;
_l131:  la x26, _l157                             ;
        csrrw zero, uepc, x26                     ;
        uret                                      ;
_l132:  la x15, d_1_19                            ;
        lwu x9, -28(x15)                          ;
_l133:  la x8, d_4_10                             ;
        lwu x23, -12(x8)                          ;
_l134:  srliw x8, x26, 21                         ;
_l135:  mul x7, x26, x29                          ;
_l136:  fcvt.wu.s x8, f23, rtz                    ;
_l137:  slliw x19, x6, 25                         ;
_l138:  la x14, d_1_15                            ;
        addi x14, x14, -12                        ;
        amoxor.w x29, x3, (x14)                   ;
_l139:  la x3, d_3_17                             ;
        addi x3, x3, 0                            ;
        lui x17, 0xffe00                          ;
        xor x3, x3, x17                           ;
        amoxor.d x15, x17, (x3)                   ;
_l140:  fcvt.wu.s x18, f5, rne                    ;
_l141:  mulhsu x18, x22, x16                      ;
_l142:  mulhsu x27, x9, x5                        ;
_l143:  fmadd.s f12, f28, f0, f31, rup            ;
_l144:  csrrsi x2, fflags, 4                      ;
_l145:  sllw x6, x27, x16                         ;
_l146:  fence.i                                   ;
_l147:  la x28, d_3_26                            ;
        addi x28, x28, -8                         ;
        amoadd.d x15, x25, (x28)                  ;
_l148:  ori x24, x10, -404                        ;
_l149:  la x29, d_3_13                            ;
        addi x29, x29, 8                          ;
        amoand.d x6, x27, (x29)                   ;
_l150:  la x8, d_0_20                             ;
        addi x8, x8, 4                            ;
        amoadd.w x28, x17, (x8)                   ;
_l151:  bge x18, x5, _l192                        ;
_l152:  li x24, 1                                 ;
        la x29, pt3                               ;
        addi x29, x29, 40                         ;
        sfence.vma x24, x29                       ;
_l153:  la x10, _l168                             ;
        csrrw zero, sepc, x10                     ;
        sret                                      ;
_l154:  fcvt.wu.s x16, f3, rtz                    ;
_l155:  subw x19, x10, x29                        ;
_l156:  bne x24, x10, _l189                       ;
_l157:  la x6, d_0_11                             ;
        addi x6, x6, 8                            ;
        amoxor.w x29, x5, (x6)                    ;
_l158:  flt.s x24, f6, f24                        ;
_l159:  mulhsu x20, x27, x10                      ;
_l160:  la x15, d_4_13                            ;
        addi x15, x15, -0                         ;
        lui x13, 0xffe00                          ;
        xor x15, x15, x13                         ;
        amomin.w x13, x13, (x15)                  ;
_l161:  subw x25, x12, x8                         ;
_l162:  la x26, d_0_16                            ;
        sh x1, -16(x26)                           ;
_l163:  divu x7, x23, x8                          ;
_l164:  la x21, d_1_13                            ;
        sh x26, 14(x21)                           ;
_l165:  la x9, d_0_23                             ;
        sh x1, 0(x9)                              ;
_l166:  fnmsub.s f7, f13, f18, f28, rne           ;
_l167:  fmv.x.w x24, f4                           ;
_l168:  la x1, _l194                              ;
        csrrw zero, sepc, x1                      ;
        sret                                      ;
_l169:  sltiu x14, x15, 116                       ;
_l170:  fsgnjn.s f9, f23, f31                     ;
_l171:  la x26, _l187                             ;
        csrrw zero, mepc, x26                     ;
        mret                                      ;
_l172:  la x13, d_4_2                             ;
        addi x13, x13, 20                         ;
        amominu.w x8, x5, (x13)                   ;
_l173:  la x29, d_2_14                            ;
        addi x29, x29, 0                          ;
        amoor.w x26, x5, (x29)                    ;
_l174:  la x26, d_4_20                            ;
        addi x26, x26, 8                          ;
        amominu.d x18, x12, (x26)                 ;
_l175:  la x11, d_2_15                            ;
        addi x11, x11, 24                         ;
        lr.d x25, (x11)                           ;
_l176:  la x15, d_0_12                            ;
        lb x20, 28(x15)                           ;
_l177:  la x18, d_2_7                             ;
        addi x18, x18, 8                          ;
        amominu.d x25, x29, (x18)                 ;
_l178:  la x22, d_0_9                             ;
        lw x2, -8(x22)                            ;
_l179:  fcvt.lu.s x16, f21, rdn                   ;
_l180:  beq x24, x20, _l195                       ;
_l181:  la x7, d_5_14                             ;
        lhu x19, 28(x7)                           ;
_l182:  mulhu x29, x29, x9                        ;
_l183:  la x21, d_3_27                            ;
        addi x21, x21, 0                          ;
        amoadd.d x15, x25, (x21)                  ;
_l184:  fence                                     ;
_l185:  sraw x30, x5, x11                         ;
_l186:  la x22, d_5_11                            ;
        addi x22, x22, -28                        ;
        amoswap.w x10, x17, (x22)                 ;
_l187:  xor x30, x30, x30                         ;
        csrrc x11, mstatus, x30                   ;
_l188:  bge x9, x23, _l196                        ;
_l189:  fence                                     ;
_l190:  sltiu x7, x1, -513                        ;
_l191:  remuw x17, x18, x15                       ;
_l192:  fsgnj.s f12, f26, f13                     ;
_l193:  fcvt.s.wu f23, x26, rtz                   ;
_l194:  fmv.w.x f21, x16                          ;
_l195:  sraw x13, x8, x23                         ;
_l196:  fence.i                                   ;
_l197:  slliw x12, x20, 31                        ;
_l198:  fcvt.wu.s x0, f14, rmm                    ;
_l199:  bltu x12, x12, _l200                      ;
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
                .dword 0x1d767c1bbde14392, 0x8d11418191f3a1bd
                .dword 0x9871ff938271455e, 0x7a3d87db2da5df5d
d_0_0:          .dword 0x032425847d91b4aa, 0x3a4dea69ea19fbf9
d_0_1:          .dword 0x05fd09c04d404b01, 0xfc8cd689e7c88931
d_0_2:          .dword 0x1777f2cd8757ee0f, 0x669125fee8f07aed
d_0_3:          .dword 0xd9be5157145ddf1d, 0xe2ba6fa45dbec4bf
d_0_4:          .dword 0xa930715e9eb4e4e0, 0x2519b175882b9759
d_0_5:          .dword 0x3c95aa4474997355, 0x7ec35322fd510c12
d_0_6:          .dword 0xcf7309defeab9e0d, 0xf0525d42f62735fc
d_0_7:          .dword 0x0a7da960433ab212, 0x48555ad93c234c5c
d_0_8:          .dword 0x9195df43f8612dc6, 0x7d3b51a565204a58
d_0_9:          .dword 0xf93e5970982d1b56, 0x9fb05001fb76de3e
d_0_10:         .dword 0x7d50374062e1b625, 0x868aad826694bd41
d_0_11:         .dword 0x4bacf9f9eb293822, 0xcf612fec7de64068
d_0_12:         .dword 0x4432e340a14ffeab, 0xb602de9d78326b7a
d_0_13:         .dword 0x344dcf67b0725428, 0xeaeb59a7ce26c603
d_0_14:         .dword 0x1c72b46969a6acbd, 0x9e004e4eefc35461
d_0_15:         .dword 0xd62f9ea3537cc312, 0x955edb3e69e03ead
d_0_16:         .dword 0xfde94a5013677ca1, 0x3fcea3cbb1530a32
d_0_17:         .dword 0x7d7506337bf71234, 0x27726dd8ddb868b8
d_0_18:         .dword 0x146517907c2b1d94, 0xbefc1f58f123ebda
d_0_19:         .dword 0xe6ef9399d9fc43d7, 0xe2633ad4ffbdd4a0
d_0_20:         .dword 0x3e214d0bd736182e, 0x68c78b542931b640
d_0_21:         .dword 0xa44e095b67b209da, 0x493e4021bfdfdcd6
d_0_22:         .dword 0x6c02f747d02711f9, 0x300015898081bad8
d_0_23:         .dword 0x8f6ab6f677ea4877, 0x42a587789ab2b091
d_0_24:         .dword 0x0fe0a0a23ea7dbe2, 0xee7a2bc0e60ed383
d_0_25:         .dword 0x93169c21366236bf, 0x1edd4135419f7a2c
d_0_26:         .dword 0xb948982f238a8e26, 0x78bb2744910dc8dc
d_0_27:         .dword 0xb69dae2629b4d876, 0x1f9bda51e3696b4f
                .dword 0x65b02ff4fd08ee37, 0xaf3771de82a08590
                .dword 0x71f38b4dcf505fd6, 0xb84226566cd03f71
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x3eb3021940bffad3, 0x858943ff2e4c6c25
                .dword 0x6078a80b8adbb2c9, 0xfb0e26afbc88819a
d_1_0:          .dword 0x3a35e86e39cea542, 0x6d11714f7b8382fe
d_1_1:          .dword 0x1f1cf66f89ba4371, 0x5c4c96f5a0060f08
d_1_2:          .dword 0x0956aeecaa0cc318, 0x0933333f31a7e672
d_1_3:          .dword 0x24b152bff4ed8115, 0xc32a96fbad2c78a5
d_1_4:          .dword 0xcff43a8551075e2f, 0xb5dad431836fe1d1
d_1_5:          .dword 0x08ba3716778745ab, 0xb7d9176c0e1b46e2
d_1_6:          .dword 0xae1a7a2ac12aa24b, 0xd3fcd6f7a1f19b3a
d_1_7:          .dword 0x0b94db74cf83e838, 0x245455e11b87af1d
d_1_8:          .dword 0xd803d6de39dce197, 0x55e287408afa51ef
d_1_9:          .dword 0xd4cbb02a468cb688, 0x1d7da7653658f23d
d_1_10:         .dword 0x7aed6bf48af2d77c, 0xd42ca92e33c9d3d2
d_1_11:         .dword 0x0fc241982dc71137, 0xe0ee8a515c3a111d
d_1_12:         .dword 0xc73b6d411a4700cd, 0x477b112526b6ccaa
d_1_13:         .dword 0xad6ac35e7702720b, 0x890d5723b0fe38c4
d_1_14:         .dword 0x1d75cf7b05991499, 0x217ce279564a08d3
d_1_15:         .dword 0x9350acf63280a271, 0x655c25d85ff47466
d_1_16:         .dword 0xa3bf910d3beb7386, 0x4acdc156aecba900
d_1_17:         .dword 0x3e29c3f1a143b5f8, 0xcd9bc83061afa371
d_1_18:         .dword 0xef4e6a6d0010eb06, 0xa59c907c482a394a
d_1_19:         .dword 0xb55ff40fae61dd14, 0x73e393966fa6ba24
d_1_20:         .dword 0x92a0509bb4ebf615, 0xc794d9969b936819
d_1_21:         .dword 0x4a95cbff35890da8, 0xc19d8b51569de811
d_1_22:         .dword 0x437ce4f37368578f, 0x82a0e297a73f96f5
d_1_23:         .dword 0x79d884e781973181, 0x6871a81754ada013
d_1_24:         .dword 0x38af95f70b574854, 0x7c3d4a16e1c1556a
d_1_25:         .dword 0x059c6bd08659d883, 0x43edb275ae992734
d_1_26:         .dword 0x796c5af54e71f252, 0x11d2d5bfd98f156c
d_1_27:         .dword 0x242ac2855b72dcc7, 0x3844796edd1d9187
                .dword 0xaeb98aa12dc71f3a, 0xe251cea43a22e926
                .dword 0x5b1b201c5c2471d2, 0xdaf5ec2058aa550e
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x2a9414fde822632d, 0xbcf58a57d9867d12
                .dword 0x027717badf72c8da, 0xaff3ebd9cf626298
d_2_0:          .dword 0xc0a8468e9d4d1755, 0x209e2956b69b190f
d_2_1:          .dword 0xa14a8df8aaa2f955, 0xfddcaafde579985a
d_2_2:          .dword 0x4657940fe39c64c7, 0x3bf0a064e26e089c
d_2_3:          .dword 0x3d7c8a6ab22e9b43, 0xc32f2c6c2ca3dcc1
d_2_4:          .dword 0x934a30c78d906032, 0x78da0b065edd6cc8
d_2_5:          .dword 0xce8c7952953d951f, 0xbe7e649d59cb1b81
d_2_6:          .dword 0xfa18f3d8801a1801, 0x322e56c4638b0271
d_2_7:          .dword 0x6cb6d98819443b81, 0x110e3ce0d9eca42f
d_2_8:          .dword 0x2b23654c19c865cc, 0x3b8f379fe03b6400
d_2_9:          .dword 0x2df8caf486993d56, 0x480a32d6d07004c5
d_2_10:         .dword 0xa3cdd52c7ab7918d, 0xab9ee9a998b58a3a
d_2_11:         .dword 0x33c50e7b220bcbe3, 0x05a95f3c34512a6a
d_2_12:         .dword 0xe256c009f6b6be6b, 0xbb0b9a13c0730d26
d_2_13:         .dword 0x108e766cffb5fa77, 0xe3c0241203bd19c2
d_2_14:         .dword 0x7e54b14f6beb8dc0, 0xffa17eecfd3291b1
d_2_15:         .dword 0x0024ebac918cabe6, 0x003f31be1960f16e
d_2_16:         .dword 0x1cd6d99dc651d6d8, 0x284cff10e176c736
d_2_17:         .dword 0x0118cb1583dfa94c, 0xc38414e70f952e1e
d_2_18:         .dword 0xc98e641b57daa681, 0x07a8842489f17622
d_2_19:         .dword 0x5ecbdcb094b8586b, 0x4431daa8a59dcd19
d_2_20:         .dword 0x216924e3c178a1d5, 0x48ad8cc147951361
d_2_21:         .dword 0xa766b6c950c97c45, 0x425afa368216e369
d_2_22:         .dword 0x12dc0b5a6ebb0a0a, 0xafb6b34d4384ea64
d_2_23:         .dword 0x44484cd2a22e002b, 0x92132cf1bb6758f3
d_2_24:         .dword 0x1cc55c556f23c674, 0xfc6c2a4760003c00
d_2_25:         .dword 0x73c89ff59f32c72c, 0x6ae6b82f97f91fa2
d_2_26:         .dword 0x8ec0f29d332df7b3, 0x576d49181b7d76d0
d_2_27:         .dword 0x6fcd61f677fd229b, 0xac9e0cd2b350de51
                .dword 0xe86cc2d01ccc5629, 0xcd6bea6825acb14c
                .dword 0x36543a49463c9487, 0x9a9fd4a13a05d231
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xe2932ccda01189a4, 0xc3272ee2b58296dd
                .dword 0x93bdbefeea87de7e, 0x4ffcfb722e6bd5f2
d_3_0:          .dword 0x8e86cf3d54c30b11, 0x8501546478a30b35
d_3_1:          .dword 0xfd3eaa1c0ba3abb3, 0x01f85a2cb285095d
d_3_2:          .dword 0x63aa628ccee67e15, 0x8a1291fda519292e
d_3_3:          .dword 0xf31d2b5c0daa762f, 0x296654330fa00940
d_3_4:          .dword 0x703fc844714a9c53, 0x87465b06a6a5190a
d_3_5:          .dword 0xfe33c5504b4ddb46, 0x55faf8a73c6d9552
d_3_6:          .dword 0xa484bbdc23346718, 0x026a0e26eac44eb8
d_3_7:          .dword 0xae3f36bd0cc3e142, 0xfa3d0e3ad5967fd7
d_3_8:          .dword 0x764bd1644ae91e58, 0x3c2470a91812d65d
d_3_9:          .dword 0xd65a709662eb281e, 0x4ccb939a40d11d52
d_3_10:         .dword 0x36053b04b78b934b, 0x7e8541270a883e8d
d_3_11:         .dword 0xa3610cba336073db, 0x18c1da706da9620a
d_3_12:         .dword 0xdf664fba215e9699, 0xba9836f7f61e9b47
d_3_13:         .dword 0xbf0253160a9f0e42, 0xf3f9d0b9a617f37f
d_3_14:         .dword 0x4a1da3df7378c4ed, 0x48b292c6e130f2d5
d_3_15:         .dword 0xe46b6d3b05ce1377, 0x66567ca0fed227d6
d_3_16:         .dword 0x8c6e3ea1dd9232e5, 0x16dee31ba59e3f0a
d_3_17:         .dword 0x5a3d33ddfec22139, 0x4a5c7cd621cc686b
d_3_18:         .dword 0x72aba602234eef11, 0x9e2e1a21ca68a4a2
d_3_19:         .dword 0x5af4d84d064fcb1f, 0x0caec75bbd64b273
d_3_20:         .dword 0xfa8bec31608a9f1e, 0x44125d24ca8ab674
d_3_21:         .dword 0x61cb898eb74890af, 0x94f1243aca681f54
d_3_22:         .dword 0x78c8dff8b7d859d9, 0xd4a8098d0ca17252
d_3_23:         .dword 0x02c5d6342a3fd65d, 0x50eda878b544c8fc
d_3_24:         .dword 0xc0cab9720a6de69b, 0x9807e7a54dad3334
d_3_25:         .dword 0xba87afdf6d67db7e, 0x645ae3c4a6779e72
d_3_26:         .dword 0x496a726e1185e6ac, 0x4cb6b09fe519ea00
d_3_27:         .dword 0xe34c391b49af38fb, 0x0c55c5a0624a1d93
                .dword 0x46bf4a2ba79004f6, 0x48d34aa45effe0e2
                .dword 0xd636c01be42e3345, 0x657ad55e2ef6c09c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x89783bdf7963033c, 0xff0273c8588f9bec
                .dword 0x5e42de5dcd8e4e6d, 0x0a895eaa96e609da
d_4_0:          .dword 0x3cad8f2fd1aef962, 0xbbd3be97f3b70375
d_4_1:          .dword 0xc0f8fa9530584452, 0x7d5e5d98230ab156
d_4_2:          .dword 0x35fbbe685199882f, 0x756dcfabcebf50fd
d_4_3:          .dword 0xd60925dcce085e4b, 0xc32b135fe3776275
d_4_4:          .dword 0xfebbe408ff5d01aa, 0x99db3f9b9ff539b1
d_4_5:          .dword 0x90ebad11ac22ade5, 0xe81a76e4ab90d609
d_4_6:          .dword 0x0a41d5b463d72cce, 0xdb55d7f3877b2709
d_4_7:          .dword 0x2576d1bc4431707d, 0xb08f4fc43f4d3e57
d_4_8:          .dword 0x011897ae22fbff88, 0xc18afb5d0e76f12c
d_4_9:          .dword 0x8af6defb507a6b88, 0x5dc07787bf169410
d_4_10:         .dword 0x4baf7ff00f546aee, 0xd1e6430f418ca2b6
d_4_11:         .dword 0x4772f0aaa504d14b, 0x3a771b9e5cfe62f3
d_4_12:         .dword 0x19c039d984bb3d0d, 0xbb6987b79371dc79
d_4_13:         .dword 0xc35cce9302ff40c8, 0xb5545e7019a59768
d_4_14:         .dword 0x32445c8a3b9976f2, 0xca9de44c0d0f3a24
d_4_15:         .dword 0x5dd6e7e84f3619f6, 0x565e74cfa5d22913
d_4_16:         .dword 0x97eb24e1a81b5281, 0xee70db986d1dd0f1
d_4_17:         .dword 0x4c584eac7b183b34, 0x84c447596a11ef2d
d_4_18:         .dword 0x187b78f280c51465, 0xbdcbd5d6c449cfb4
d_4_19:         .dword 0xb1809826f1ff34d4, 0x42b93f51abc6285c
d_4_20:         .dword 0xbfd2ace630281c2d, 0xc813a73576725ed2
d_4_21:         .dword 0x9d8dbf109cbceb9d, 0x2a386fc6152306f2
d_4_22:         .dword 0x08b72c8b79ca8c73, 0x74dd074507e3e39f
d_4_23:         .dword 0xd2daafa6303fb772, 0xf72fee9ca3ca4f96
d_4_24:         .dword 0xf6d2669f39e1d607, 0x281bc9e6ce087ce0
d_4_25:         .dword 0xba4e286b23de2851, 0x0d59265b3c60ced0
d_4_26:         .dword 0x0dfb2930c29ba684, 0x3c1e2c43fa15800b
d_4_27:         .dword 0xd155f983130f48da, 0x1376f8e6c4c60e04
                .dword 0xa5866005015c5028, 0x563bfbe9e50a7d95
                .dword 0xf0c469ad8eaf5173, 0x9808ff5a13976d0e
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x4d834cc93a7a2521, 0xe9cfbe8968e2a91f
                .dword 0x28db4664cf8348b7, 0x8cdf423b8f9b92c4
d_5_0:          .dword 0x105a83b553a05781, 0x9ec2604148f82cbc
d_5_1:          .dword 0x2cc81259e397e7ea, 0xaab82a9cb6a6514b
d_5_2:          .dword 0xa2b1d76e9c93ecb4, 0x6b7ce831bb810b9e
d_5_3:          .dword 0x71d75e6b16e20278, 0xba2f6e85ada3f2fd
d_5_4:          .dword 0x8f1272de3c9c587a, 0x53c5cd79b5587dd5
d_5_5:          .dword 0x789deae39a7bfd19, 0x7df2cc8636c70c4c
d_5_6:          .dword 0x7b882945766102f1, 0xe3b8d60139ed0902
d_5_7:          .dword 0x02483800b1268c45, 0x0f0d28e701953fff
d_5_8:          .dword 0x03ea52c236349a13, 0xbc2715e90af869cf
d_5_9:          .dword 0xf5b5442eec212406, 0xdff78528961ce3f8
d_5_10:         .dword 0x4cb09672d9aa4457, 0xe9e802f733159e73
d_5_11:         .dword 0xa8a3acb1e3b6cab7, 0x479f8f0b409af536
d_5_12:         .dword 0xb7fbfe41e4c4ed63, 0xfc8549a0d7ca86c9
d_5_13:         .dword 0x6e0e3e820cc7e9bd, 0xae8a3be1fa152b90
d_5_14:         .dword 0xf49a16d057e62852, 0x6883cd6506d340ff
d_5_15:         .dword 0x2611fec6f2df31b6, 0x6240dea90601798c
d_5_16:         .dword 0x3cf3c2e0f5b2dd20, 0x9e623d07a5c30a2f
d_5_17:         .dword 0x56f6be94cf441cb4, 0x99f4db41f5d59818
d_5_18:         .dword 0xe4f72d1c4db336d9, 0x8baef759536aa8b0
d_5_19:         .dword 0xb85cf3f8028790bb, 0x844a895911102f64
d_5_20:         .dword 0xed4408c8623c90d2, 0xa25cd29a5d6b3e33
d_5_21:         .dword 0xa9e41c684b618bf2, 0x896f06898d6a7073
d_5_22:         .dword 0x663f72a3ecc20554, 0x8b2071a3726be1e3
d_5_23:         .dword 0x2f1c21ff083507c5, 0x81dce2f1df351fad
d_5_24:         .dword 0x80790b4a0bd8f646, 0x3e6f01b35e331f69
d_5_25:         .dword 0x1026a6f5fca4de81, 0x46a9afa8705c0dcb
d_5_26:         .dword 0x8a8c7425700e283d, 0x5b92ebcfb2ac9582
d_5_27:         .dword 0x0a33a66f3f1d94a0, 0x2dd16fdf7df03474
                .dword 0x2a4327ab79a4da99, 0x9b3d65a0806bbddd
                .dword 0x4d85eb0af6d164ee, 0x43c625fe9314ddac
         /* Random data */
_end_data5:
              
 
