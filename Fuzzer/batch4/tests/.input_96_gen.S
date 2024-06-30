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
_p0:    csrrwi x12, sscratch, 27                  ;
_p1:    csrrci x12, mcause, 27                    ;
_p2:    xor x13, x13, x13                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 14                         ;
        add x13, x13, x14                         ;
        csrrs x11, mie, x13                       ;
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
_s0:    srli x24, x2, 52                          ;
_s1:    la x17, _s2                               ;
        lw x14, 8(x17)                            ;
_s2:    div x14, x0, x5                           ;
_s3:    bne x30, x23, _s4                         ;
_s4:    fsgnj.s f7, f0, f10                       ;
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
_l0:    la x21, d_2_23                            ;
        sh x11, -8(x21)                           ;
_l1:    ori x1, x16, -27                          ;
_l2:    bltu x27, x30, _l183                      ;
_l3:    la x23, d_0_2                             ;
        ld x13, -0(x23)                           ;
_l4:    la x30, d_3_21                            ;
        addi x30, x30, 4                          ;
        amoadd.w x21, x13, (x30)                  ;
_l5:    fle.s x6, f27, f24                        ;
_l6:    auipc x17, 1048575                        ;
_l7:    addiw x18, x3, 1725                       ;
_l8:    fclass.s x0, f27                          ;
_l9:    slti x11, x6, 2047                        ;
_l10:   la x27, d_3_21                            ;
        addi x27, x27, 24                         ;
        amoor.d x7, x18, (x27)                    ;
_l11:   fnmadd.s f17, f24, f28, f0, rtz           ;
_l12:   divu x13, x6, x17                         ;
_l13:   la x22, d_3_4                             ;
        addi x22, x22, -8                         ;
        amomin.w x2, x22, (x22)                   ;
_l14:   fmv.w.x f21, x16                          ;
_l15:   sraiw x9, x6, 31                          ;
_l16:   la x15, d_0_12                            ;
        addi x15, x15, -24                        ;
        amomax.w x21, x13, (x15)                  ;
_l17:   la x22, d_1_26                            ;
        sw x23, -0(x22)                           ;
_l18:   andi x13, x3, -449                        ;
_l19:   fsgnjx.s f11, f19, f21                    ;
_l20:   la x4, d_2_7                              ;
        addi x4, x4, 28                           ;
        amominu.w x6, x3, (x4)                    ;
_l21:   mulhsu x29, x9, x0                        ;
_l22:   fcvt.s.l f27, x13, dyn                    ;
_l23:   flt.s x7, f23, f24                        ;
_l24:   la x15, d_1_20                            ;
        addi x15, x15, -28                        ;
        amoor.w x13, x17, (x15)                   ;
_l25:   srai x11, x14, 28                         ;
_l26:   csrrwi x6, sepc, 27                       ;
_l27:   fence.i                                   ;
_l28:   fclass.s x14, f20                         ;
_l29:   feq.s x30, f27, f19                       ;
_l30:   la x8, d_5_0                              ;
        addi x8, x8, 4                            ;
        amoor.w x8, x26, (x8)                     ;
_l31:   mul x11, x26, x6                          ;
_l32:   sltiu x2, x23, -0                         ;
_l33:   la x16, d_3_11                            ;
        lb x26, -9(x16)                           ;
_l34:   ori x15, x23, -1253                       ;
_l35:   la x21, d_4_6                             ;
        addi x21, x21, 16                         ;
        sc.d x26, x21, (x21)                      ;
_l36:   la x11, d_4_26                            ;
        addi x11, x11, -16                        ;
        lui x19, 0xffe00                          ;
        xor x11, x11, x19                         ;
        amominu.d x7, x19, (x11)                  ;
_l37:   srli x8, x10, 19                          ;
_l38:   ebreak                                    ;
_l39:   la x8, d_1_27                             ;
        lh x4, 0(x8)                              ;
_l40:   fmadd.s f22, f11, f14, f2, rdn            ;
_l41:   flt.s x12, f25, f3                        ;
_l42:   bge x25, x4, _l103                        ;
_l43:   fmul.s f18, f19, f12, rmm                 ;
_l44:   fnmsub.s f23, f31, f28, f28, rne          ;
_l45:   fmax.s f14, f28, f27                      ;
_l46:   sraiw x18, x3, 19                         ;
_l47:   la x8, d_4_2                              ;
        addi x8, x8, -24                          ;
        lr.d x26, (x8)                            ;
_l48:   mulhsu x13, x9, x1                        ;
_l49:   sraiw x24, x4, 23                         ;
_l50:   la x25, d_2_11                            ;
        addi x25, x25, -8                         ;
        amoxor.d x16, x11, (x25)                  ;
_l51:   fclass.s x3, f22                          ;
_l52:   la x15, d_3_19                            ;
        addi x15, x15, 0                          ;
        amoxor.d x7, x19, (x15)                   ;
_l53:   fnmsub.s f19, f26, f29, f17, dyn          ;
_l54:   la x20, d_2_3                             ;
        addi x20, x20, -16                        ;
        amoand.d x21, x15, (x20)                  ;
_l55:   la x20, _l92                              ;
        csrrw zero, uepc, x20                     ;
        uret                                      ;
_l56:   mulhsu x0, x2, x26                        ;
_l57:   ecall                                     ;
_l58:   xori x16, x7, 4                           ;
_l59:   fmadd.s f10, f11, f18, f12, dyn           ;
_l60:   la x4, d_0_14                             ;
        ld x19, 0(x4)                             ;
_l61:   la x6, d_0_4                              ;
        addi x6, x6, 8                            ;
        amomax.d x11, x7, (x6)                    ;
_l62:   la x23, d_4_6                             ;
        addi x23, x23, -28                        ;
        amoand.w x9, x12, (x23)                   ;
_l63:   srli x9, x15, 63                          ;
_l64:   divw x13, x20, x23                        ;
_l65:   la x25, d_1_5                             ;
        addi x25, x25, -0                         ;
        amoswap.d x8, x24, (x25)                  ;
_l66:   la x21, d_0_11                            ;
        lbu x21, -0(x21)                          ;
_l67:   la x25, d_5_14                            ;
        addi x25, x25, -0                         ;
        amomax.w x8, x3, (x25)                    ;
_l68:   la x15, _l176                             ;
        csrrw zero, mepc, x15                     ;
        mret                                      ;
_l69:   sllw x4, x26, x21                         ;
_l70:   fcvt.w.s x21, f23, rup                    ;
_l71:   la x6, d_2_11                             ;
        addi x6, x6, 16                           ;
        lr.w x7, (x6)                             ;
_l72:   ecall                                     ;
_l73:   remuw x15, x27, x13                       ;
_l74:   fcvt.s.wu f26, x27, rup                   ;
_l75:   la x20, d_0_25                            ;
        addi x20, x20, 4                          ;
        lr.w x28, (x20)                           ;
_l76:   sraiw x6, x17, 24                         ;
_l77:   mulw x12, x6, x26                         ;
_l78:   la x18, d_3_10                            ;
        lw x29, 12(x18)                           ;
_l79:   slti x10, x8, 2047                        ;
_l80:   la x13, d_2_20                            ;
        lui x17, 0xffe00                          ;
        xor x13, x13, x17                         ;
        sw x22, -0(x13)                           ;
_l81:   la x18, _l148                             ;
        csrrw zero, sepc, x18                     ;
        sret                                      ;
_l82:   la x24, _l120                             ;
        csrrw zero, mepc, x24                     ;
        mret                                      ;
_l83:   la x27, d_1_20                            ;
        srai x27, x27, 1                          ;
        csrrs x6, pmpaddr2, x27                   ;
_l84:   bltu x20, x21, _l112                      ;
_l85:   addiw x26, x2, 552                        ;
_l86:   la x13, d_1_4                             ;
        addi x13, x13, -8                         ;
        lui x11, 0xffe00                          ;
        xor x13, x13, x11                         ;
        sc.w x12, x11, (x13)                      ;
_l87:   fnmadd.s f2, f4, f12, f27, rdn            ;
_l88:   la x19, d_5_9                             ;
        addi x19, x19, 0                          ;
        sc.d x2, x19, (x19)                       ;
_l89:   fnmsub.s f29, f26, f11, f27, dyn          ;
_l90:   jal x4, _l122                             ;
_l91:   la x7, d_2_6                              ;
        srai x7, x7, 1                            ;
        csrrs x18, pmpaddr1, x7                   ;
_l92:   addiw x22, x26, -1595                     ;
_l93:   la x6, _l157                              ;
        csrrw zero, mepc, x6                      ;
        mret                                      ;
_l94:   la x3, d_3_9                              ;
        lw x4, 20(x3)                             ;
_l95:   sltiu x7, x3, 1088                        ;
_l96:   fsgnjn.s f14, f10, f5                     ;
_l97:   fnmsub.s f21, f8, f3, f11, rtz            ;
_l98:   csrrwi x10, mstatus, 23                   ;
_l99:   la x3, _l189                              ;
        csrrw zero, sepc, x3                      ;
        sret                                      ;
_l100:  fcvt.lu.s x29, f7, rtz                    ;
_l101:  fcvt.s.lu f25, x15, rtz                   ;
_l102:  la x16, d_2_22                            ;
        lwu x11, -8(x16)                          ;
_l103:  fcvt.s.wu f29, x27, rtz                   ;
_l104:  divu x12, x11, x21                        ;
_l105:  la x18, d_0_2                             ;
        addi x18, x18, -16                        ;
        amoor.w x5, x16, (x18)                    ;
_l106:  fcvt.wu.s x3, f20, rmm                    ;
_l107:  sltiu x9, x29, 1663                       ;
_l108:  fadd.s f26, f27, f30, rup                 ;
_l109:  la x2, d_3_8                              ;
        lui x17, 0xffe00                          ;
        xor x2, x2, x17                           ;
        sh x31, 16(x2)                            ;
_l110:  la x8, d_0_25                             ;
        sw x6, 28(x8)                             ;
_l111:  fmul.s f9, f5, f21, rtz                   ;
_l112:  la x24, d_0_22                            ;
        addi x24, x24, 0                          ;
        amomax.d x18, x25, (x24)                  ;
_l113:  bge x3, x9, _l119                         ;
_l114:  fcvt.l.s x24, f21, rne                    ;
_l115:  fsgnj.s f21, f20, f4                      ;
_l116:  la x24, d_2_2                             ;
        lui x19, 0xffe00                          ;
        xor x24, x24, x19                         ;
        lhu x2, -30(x24)                          ;
_l117:  sllw x28, x0, x22                         ;
_l118:  mul x9, x11, x26                          ;
_l119:  beq x30, x2, _l186                        ;
_l120:  la x6, d_3_4                              ;
        addi x6, x6, -8                           ;
        amomin.w x28, x3, (x6)                    ;
_l121:  addw x30, x27, x8                         ;
_l122:  fcvt.l.s x20, f27, dyn                    ;
_l123:  blt x22, x12, _l180                       ;
_l124:  mulh x21, x18, x4                         ;
_l125:  fsub.s f24, f1, f22, rtz                  ;
_l126:  mulhu x22, x28, x3                        ;
_l127:  la x3, _l120                              ;
        lhu x14, 0(x3)                            ;
_l128:  fcvt.wu.s x22, f4, rdn                    ;
_l129:  la x19, d_2_6                             ;
        addi x19, x19, -20                        ;
        amoand.w x8, x3, (x19)                    ;
_l130:  la x6, d_2_12                             ;
        fsw f26, 20(x6)                           ;
_l131:  la x16, d_0_0                             ;
        addi x16, x16, 16                         ;
        amomax.w x7, x8, (x16)                    ;
_l132:  fsgnj.s f30, f9, f16                      ;
_l133:  la x29, d_1_21                            ;
        lbu x13, 7(x29)                           ;
_l134:  mulh x22, x12, x28                        ;
_l135:  fsqrt.s f10, f30, rtz                     ;
_l136:  la x3, d_0_9                              ;
        sw x30, 20(x3)                            ;
_l137:  mulhu x6, x15, x24                        ;
_l138:  divw x11, x23, x11                        ;
_l139:  mul x28, x22, x27                         ;
_l140:  fsgnjn.s f13, f18, f17                    ;
_l141:  subw x18, x27, x2                         ;
_l142:  bge x27, x27, _l178                       ;
_l143:  feq.s x6, f28, f25                        ;
_l144:  la x29, _l175                             ;
        csrrw zero, uepc, x29                     ;
        uret                                      ;
_l145:  remw x11, x12, x7                         ;
_l146:  fsgnj.s f13, f30, f5                      ;
_l147:  remu x10, x13, x2                         ;
_l148:  subw x5, x26, x15                         ;
_l149:  csrrsi x26, mhartid, 4                    ;
_l150:  divu x0, x3, x28                          ;
_l151:  fnmsub.s f12, f22, f15, f10, dyn          ;
_l152:  bltu x23, x19, _l179                      ;
_l153:  ecall                                     ;
_l154:  la x17, d_3_11                            ;
        addi x17, x17, 8                          ;
        amomin.d x13, x6, (x17)                   ;
_l155:  la x3, d_4_4                              ;
        addi x3, x3, -12                          ;
        amomin.w x16, x12, (x3)                   ;
_l156:  li x18, 1                                 ;
        la x8, pt0                                ;
        addi x8, x8, 8                            ;
        sfence.vma x18, x8                        ;
_l157:  andi x6, x27, -0                          ;
_l158:  jal x15, _l169                            ;
_l159:  flt.s x6, f29, f0                         ;
_l160:  fmax.s f21, f30, f29                      ;
_l161:  fcvt.lu.s x26, f2, rdn                    ;
_l162:  bgeu x15, x8, _l178                       ;
_l163:  la x14, _l181                             ;
        csrrw zero, mepc, x14                     ;
        mret                                      ;
_l164:  csrrwi x28, fflags, 31                    ;
_l165:  mulh x20, x17, x21                        ;
_l166:  fence.i                                   ;
_l167:  la x16, d_5_18                            ;
        addi x16, x16, 28                         ;
        amomin.w x5, x19, (x16)                   ;
_l168:  addiw x5, x7, 12                          ;
_l169:  fcvt.l.s x10, f14, rmm                    ;
_l170:  la x30, d_1_2                             ;
        addi x30, x30, 0                          ;
        lr.w x23, (x30)                           ;
_l171:  la x26, d_3_1                             ;
        addi x26, x26, 12                         ;
        amoor.w x11, x5, (x26)                    ;
_l172:  la x27, d_0_8                             ;
        sw x16, -16(x27)                          ;
_l173:  andi x26, x15, 590                        ;
_l174:  fnmsub.s f6, f17, f27, f13, rdn           ;
_l175:  remw x18, x25, x10                        ;
_l176:  la x10, d_0_14                            ;
        sd x26, -0(x10)                           ;
_l177:  la x22, d_0_0                             ;
        addi x22, x22, 4                          ;
        amomax.w x7, x10, (x22)                   ;
_l178:  divuw x20, x0, x23                        ;
_l179:  fmin.s f24, f31, f24                      ;
_l180:  sraw x9, x29, x28                         ;
_l181:  fmul.s f28, f22, f13, rtz                 ;
_l182:  fmsub.s f29, f4, f19, f1, rne             ;
_l183:  rem x29, x14, x25                         ;
_l184:  fcvt.lu.s x5, f19, rtz                    ;
_l185:  andi x17, x22, 1784                       ;
_l186:  la x21, d_4_22                            ;
        flw f15, 28(x21)                          ;
_l187:  la x23, _l189                             ;
        csrrw zero, mepc, x23                     ;
        mret                                      ;
_l188:  la x22, d_3_2                             ;
        sw x28, -28(x22)                          ;
_l189:  la x5, d_3_2                              ;
        addi x5, x5, 0                            ;
        sc.w x14, x2, (x5)                        ;
_l190:  bltu x16, x28, _l191                      ;
_l191:;
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
                .dword 0xc808d043fbe8506e, 0xb3516fb2a3d8219c
                .dword 0x052b9ec1d15db751, 0x35a58968d16d59cf
d_0_0:          .dword 0xe0a20c6daa302b1c, 0x92934af0ffa28702
d_0_1:          .dword 0x82ce3677348c999a, 0x3753e2b413fb6fb3
d_0_2:          .dword 0xe2a9cc54cf41f695, 0x0a903a6db4092694
d_0_3:          .dword 0xc680a6df81e1985e, 0x793eb04043631c26
d_0_4:          .dword 0x0169be88f11df93c, 0xe7a84e3b71790ac5
d_0_5:          .dword 0x7ff4a74b46728b5b, 0xb2e530d4e5aa5a04
d_0_6:          .dword 0x9e23363ab76780f9, 0x4d3178a52ed8a19e
d_0_7:          .dword 0x36efc0aa64b31904, 0x64e9f36e3cc8b2df
d_0_8:          .dword 0xb292b409cf35b363, 0x0eac01068671addf
d_0_9:          .dword 0x6585fa5b1dbb4a63, 0xcc7a90b0d125a063
d_0_10:         .dword 0x930ff7608beddf55, 0xf5a41ca0575176e9
d_0_11:         .dword 0x943f35f08c7d82bb, 0xc4f815816bf5b62f
d_0_12:         .dword 0xe51644e51f8ccba7, 0x2b80d5f82a2ac1ca
d_0_13:         .dword 0x4d6f167cd9b2db74, 0x320ac7cbb7e2971c
d_0_14:         .dword 0x7ae2ceb54e199dc1, 0x659c1baf29c925ec
d_0_15:         .dword 0x7497ca25f6b97706, 0xf0b49e47e3f054a5
d_0_16:         .dword 0xfa9a225c5023abc0, 0x30647a67fe384a25
d_0_17:         .dword 0x5a319c13d28c4d62, 0xf2b06284436da833
d_0_18:         .dword 0xecdfb934cb3ff6d2, 0xc786d817fa1a1d11
d_0_19:         .dword 0xd77f5ef964fab5e2, 0x6d3a364c828b5894
d_0_20:         .dword 0xe877516a263d20f3, 0xd49605059804cdb7
d_0_21:         .dword 0x51aa65ddc0398c23, 0xcb7f548f5e25ec7d
d_0_22:         .dword 0xec32bbb98a5295fc, 0x57083790e23b8e9b
d_0_23:         .dword 0x68f2f4cf39b19d20, 0xcda3d2cc05fc2ece
d_0_24:         .dword 0xcbbca65616f69e3c, 0x1f06a07cef98c0b5
d_0_25:         .dword 0x0dbd8fdce7df192e, 0x38e9887e411eca85
d_0_26:         .dword 0x2a84a7717ae4e1ac, 0x7cf0600287d45cd0
d_0_27:         .dword 0xa2bcea4dd9015e30, 0x6f3c080da8669021
                .dword 0xc3e0ebcd2b9d1edf, 0x7a9fa7297f692aad
                .dword 0x111073271a361b56, 0x38d58aa3c4569e7d
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xc76176fbcb394bd3, 0x73cfb3e92d21e7c8
                .dword 0x1d83029e52c0cef4, 0x178e196de543273a
d_1_0:          .dword 0xb7d3fc137be6c930, 0xcf93592dae837980
d_1_1:          .dword 0x1fd11d34f471a601, 0x073a07dc0edd697a
d_1_2:          .dword 0x5fc6da93b7330576, 0x1ba453377dd04455
d_1_3:          .dword 0x06838243d3d7154a, 0xcefe521c73db406e
d_1_4:          .dword 0x281503637cea2db0, 0xb776fc76137fb147
d_1_5:          .dword 0x533f797e5bb478e8, 0x57ab559317fa6e81
d_1_6:          .dword 0xa6c2407cc69d0929, 0x2b36497ffe78d218
d_1_7:          .dword 0x6f09ab2339780d6c, 0x81fc353a1c00e9de
d_1_8:          .dword 0xa59f27ecc17b9cc3, 0xba2f17d380cf7e4a
d_1_9:          .dword 0x3ddcc399d91b7b0a, 0xaf47b250f3ceed60
d_1_10:         .dword 0x0c4f914516314cde, 0x4d5d5b8ad1ba26f6
d_1_11:         .dword 0x569f8da37e102939, 0xb24143414e2fff2b
d_1_12:         .dword 0x3171315d244125c2, 0x1ca6970e752ef7b5
d_1_13:         .dword 0x2fa1e3c0f58880e2, 0xbe7dc9df5c87e6d4
d_1_14:         .dword 0xc9cd90b798f6d4fd, 0xd5c7cd66818bb146
d_1_15:         .dword 0x43c503664011a024, 0xc03ca177435af442
d_1_16:         .dword 0x4bcb141614f16fbd, 0x48b95ea0070ccc40
d_1_17:         .dword 0xd4fb3993cb30f5ed, 0x9d9c7322bbb9c513
d_1_18:         .dword 0x2e7fa53cbb722d7f, 0x288878f6aa5f762e
d_1_19:         .dword 0x803830dd26586e25, 0x11840fd4ffae4717
d_1_20:         .dword 0xd391a14f7e4b7eb8, 0x967d66e9e581ac0b
d_1_21:         .dword 0x86995808fa968b6b, 0x1b4713547e56be3b
d_1_22:         .dword 0xcb9276e26f0422e2, 0x3723e829bf21866a
d_1_23:         .dword 0x8a62bb446d0eadab, 0x4c38c667b1e7d95d
d_1_24:         .dword 0x38e51d1c5fad61db, 0x0358331b79fd78b1
d_1_25:         .dword 0x24b6a0e74c98b626, 0x6111adfa4a8699c7
d_1_26:         .dword 0xf873a50a8e342490, 0xc3db1c05cff2867c
d_1_27:         .dword 0xd4e6dee2ff26b48a, 0x338998a34003893e
                .dword 0xe0c38532c62b4406, 0x0188cc510964db2b
                .dword 0x54ab0d689ac5dc48, 0xfbf93cbb4a894e13
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xbe88081abc30be9b, 0x2da24d8c7de2411e
                .dword 0x31a987b472adf30b, 0xd61a4ccd5b2e8adb
d_2_0:          .dword 0x980f2d89ab79791b, 0x41b59b1151dac776
d_2_1:          .dword 0x0c487174ffc75db5, 0xeab4304befd603b6
d_2_2:          .dword 0x4ccb468bb184ffd2, 0x4425c2e498a4cb7b
d_2_3:          .dword 0x25c08bf920f9233b, 0x95c071502c641819
d_2_4:          .dword 0x2384042469a5300a, 0x5bf47a148478f91a
d_2_5:          .dword 0x43f2a660b1746cb0, 0x4fb1f1011d6b3c60
d_2_6:          .dword 0x382e171b9ba4278f, 0x0c78df30e279e501
d_2_7:          .dword 0x6d4cc0c14df4763b, 0x6a69193ef0d25349
d_2_8:          .dword 0x23a012874b63d9c6, 0x4eb2a379a4c5208d
d_2_9:          .dword 0xc13a0684b013c670, 0x7cc2815528d1fd8e
d_2_10:         .dword 0x0edf2dc1d20a9da2, 0xe0f35c1eedaa5560
d_2_11:         .dword 0x70123effe8be589c, 0x6739ae51565a838b
d_2_12:         .dword 0x317490c161f9414a, 0x0bc22bf6d4e8c0cb
d_2_13:         .dword 0x9eb5e7f71edfcfa5, 0x3f21508c5f1a2557
d_2_14:         .dword 0x6cb9e082ec980d42, 0xd9daee6e579c396f
d_2_15:         .dword 0xad33d2943fea899b, 0x488f1d2c23721a4e
d_2_16:         .dword 0x6fdbd064dcd6cfc1, 0xd38fd24bfba20d6e
d_2_17:         .dword 0x87f6a83ee541de49, 0xf7f48ae8952165a3
d_2_18:         .dword 0xbf1e5894bec826e7, 0xabd75bd6fae9cab1
d_2_19:         .dword 0x77f33b942ac4839a, 0xf940cb6549f9b65f
d_2_20:         .dword 0x226caba69f07719b, 0x1020f5d7e26bedf9
d_2_21:         .dword 0x88e3a1cac3798e1c, 0xa3b8d40811ec3b98
d_2_22:         .dword 0x5ee0cf61093b9ca6, 0x744cc5d0b8fbe04d
d_2_23:         .dword 0x7394fa02f75a2bc8, 0xd5511b9521ce562f
d_2_24:         .dword 0x793338407ff4b2b3, 0x4a88d7e610971454
d_2_25:         .dword 0xfdd6665965b11dac, 0xcfdb55683b04d064
d_2_26:         .dword 0x3349ac58c9d1f91d, 0x4b99ab9b8d69c145
d_2_27:         .dword 0x9aa4f1e957867cce, 0x18b02887433f2082
                .dword 0x54a2e07acd54459f, 0x89e92e1f250c0c18
                .dword 0x2b5844504d4171fc, 0x1ee85475baf29457
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x2ac8cc3f8b604fbb, 0xfb48493b9f73b54c
                .dword 0x8ca578f3ea4ed3a5, 0xce716b67c09b3dae
d_3_0:          .dword 0xcdeeb9a26bd2f85e, 0x58d66f6c6e04a0d3
d_3_1:          .dword 0x205c356d8be4d0b7, 0xe1313f4d2699e501
d_3_2:          .dword 0x9e1f7e919aee59b3, 0xb63669eee4f2f6c9
d_3_3:          .dword 0x714e58dde6bad179, 0x1f5db343273219e4
d_3_4:          .dword 0x616c70034ed0c33b, 0xb315799b167d5b52
d_3_5:          .dword 0x7d0fd0fdcd65e2ab, 0x80983b59e821db1b
d_3_6:          .dword 0x6dacf186f2f1e926, 0x965fbec3c673ef55
d_3_7:          .dword 0x336181851d12b957, 0x7206f8728dc5d733
d_3_8:          .dword 0x2c116ad72618bb19, 0x55954ff256053c42
d_3_9:          .dword 0xd1c26cf0292a9a96, 0x3caf6d763dd43b24
d_3_10:         .dword 0x3af0e0b4bd0fb460, 0xadfbfd25234b3277
d_3_11:         .dword 0x30603a4c017bca2a, 0x0e0eeea9a7fd806b
d_3_12:         .dword 0xd3222cbb5a37475d, 0xc77e88780bf46d7a
d_3_13:         .dword 0x87d513a2ad483523, 0xe103a4d76bb16549
d_3_14:         .dword 0x93d5a9293b13e7d2, 0xda7c2f7dc55ffeb1
d_3_15:         .dword 0x9fb6f778d476ddaf, 0xe7eb9cdebbee61b2
d_3_16:         .dword 0x08691c14415444a2, 0xdedb6cde66ed4f7f
d_3_17:         .dword 0xcb350a1a67ce6d00, 0x77342750a667361f
d_3_18:         .dword 0x7673ae091a4cc693, 0x9edf6a177f3bd6f5
d_3_19:         .dword 0xa10216a09ef0a05d, 0x7a8dcb4d46bbe3ef
d_3_20:         .dword 0x76f24e997685855f, 0xfcc9854aba6f209f
d_3_21:         .dword 0xb464c59b1213d012, 0x3f5a05bf61b75903
d_3_22:         .dword 0x99e286823052e89e, 0xfeba8469a303f3ed
d_3_23:         .dword 0x8ecbfae90b2584b2, 0x8cfb21f95ed23f32
d_3_24:         .dword 0xb3e6dd7e53a07183, 0xce3c32e6720065b2
d_3_25:         .dword 0x04be2c5f7ea372ac, 0x64f3b1fba816b6dc
d_3_26:         .dword 0xf1e48e035ac8a818, 0xea21a822d14c263f
d_3_27:         .dword 0x05a210eea1f0df6b, 0x7273514c5e278cf8
                .dword 0x0b27379771a64e4a, 0x7ba5377ed0c35243
                .dword 0xddc2fa8ddbb0db32, 0x8f8b6fd63b54e271
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x09108fcccf1d747e, 0x7b68554b3c6f44d4
                .dword 0x41c29b406f1b834d, 0xc66e76d1fcd8814a
d_4_0:          .dword 0xf7a3b48ae60e32d8, 0x43ab017d3857e7a3
d_4_1:          .dword 0x0deabefdcea6136d, 0x549cd645d4fef0fc
d_4_2:          .dword 0x93d30443a6f8a287, 0xe01875e43f9e0231
d_4_3:          .dword 0x9b7cea9e6258931a, 0xef9c365bb1c374fe
d_4_4:          .dword 0xa074662a686b9189, 0xa7bb82a5f602a28f
d_4_5:          .dword 0x2ebd8f7ee101add7, 0x46f5b98f75164219
d_4_6:          .dword 0x3646c3ac54283e1e, 0x343ba7c1483dd5f6
d_4_7:          .dword 0x702aff2ca0a9b6e6, 0x264a8bb3d968e004
d_4_8:          .dword 0x3542ff7c93d28b84, 0x897a828caeab6075
d_4_9:          .dword 0x2eaf8b0fce310477, 0xbd30bb578446a337
d_4_10:         .dword 0x32ef1d40e6b5c0a9, 0xb3fe4ccc074b5b6a
d_4_11:         .dword 0x58daad16a80a5433, 0xb1361847bf3f57b0
d_4_12:         .dword 0xd5c845c17edbbe70, 0xf95997689b4e7b39
d_4_13:         .dword 0xbb45fd3c6714071d, 0xfaab8aca4a7f4ee3
d_4_14:         .dword 0x1343605c921d8fe5, 0x1608238eeb584970
d_4_15:         .dword 0x9c611e9d0c0382d6, 0x8467261c60b93066
d_4_16:         .dword 0x53c9239a57b161c0, 0xfe247a4b5caeb747
d_4_17:         .dword 0x37ac3be4be35a407, 0x0deb4702cd517199
d_4_18:         .dword 0x27a581aa3e7473a5, 0x52092f4d74c17ff0
d_4_19:         .dword 0x3c6ca3139bff81c6, 0xd13d5df72fae41ce
d_4_20:         .dword 0x6f2d264376dc9a54, 0xeb065fb19f421b86
d_4_21:         .dword 0x0393d3aaeee9298e, 0x7c73781ec421bbe0
d_4_22:         .dword 0x7786e9be10a2821d, 0xe4cf780a368941b9
d_4_23:         .dword 0x1743b202b538cc59, 0xdfb4197e04d6d6d4
d_4_24:         .dword 0x7c8c68591aa7d2cc, 0xab31b017fe5a972e
d_4_25:         .dword 0xa6e230c7285b27d7, 0x966f663141860a9a
d_4_26:         .dword 0x1d6c9d8cbbc014dd, 0x71477f3df6263b83
d_4_27:         .dword 0xc0f1c926383dcfe6, 0xb4fc12f1a381b001
                .dword 0x5dcaddad808a2824, 0xc0feee6892d756d6
                .dword 0x7ce2f4e735fe4e51, 0x994f5aff9d0d2ec5
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x158169f5a3cb4025, 0xc14a4e22d76db48e
                .dword 0x74b0675a08e4e1d5, 0xe1fb9b66c260270f
d_5_0:          .dword 0x55b6247672f6312b, 0xbf4669117726e1f3
d_5_1:          .dword 0xbeb9ae32abc25648, 0x491774abf9049b5a
d_5_2:          .dword 0x97a4a27b08346bfd, 0xc9312c7ff44b9157
d_5_3:          .dword 0x82a9bf47af10524b, 0x135684e2af92f6e5
d_5_4:          .dword 0x027f094a02292416, 0xfb4f0eb87fcbd78b
d_5_5:          .dword 0x48cccff173034072, 0x64a3cb322f4ab38e
d_5_6:          .dword 0x02a23878b590bbc0, 0x051682bfddff16c4
d_5_7:          .dword 0x7549c5ac64c69279, 0xd8972df1edc050de
d_5_8:          .dword 0x35fd4765e86ec952, 0x47b406d00c203a9e
d_5_9:          .dword 0x1ad0b24f618e3eb2, 0xb06585bfdee22966
d_5_10:         .dword 0xc90dee1fac47c8e1, 0x740e2b131fc9c433
d_5_11:         .dword 0x526378b30b1a479f, 0xf60e550e51e4568e
d_5_12:         .dword 0xf7cf94a5aeea7b94, 0x058dee626f4257c9
d_5_13:         .dword 0xcf1cd80c168fc707, 0x38b914f74553fbde
d_5_14:         .dword 0xf4e57b31b34ddd5f, 0xd48bb08a6584cf99
d_5_15:         .dword 0x9917b24b8a741606, 0x76548ce3c1a50912
d_5_16:         .dword 0xc58def6daa39e41a, 0xb54501bda234a461
d_5_17:         .dword 0x4c865d3d3ff181c7, 0x550869cbb1e65ae9
d_5_18:         .dword 0x29c45998f8fb8278, 0x1f9053c03649723e
d_5_19:         .dword 0xb3d0d22c2b5547bb, 0x278e53491c348d6f
d_5_20:         .dword 0xac09b81845989704, 0x326b548eefa832c8
d_5_21:         .dword 0x1ac4ba5c2dab2ecb, 0xeddaee0e3e827345
d_5_22:         .dword 0x1b7ebc3fdd75fbe3, 0x7c2ee0ba63e0eda6
d_5_23:         .dword 0xdccb999a3bda75ba, 0xf6ede8e9f0442014
d_5_24:         .dword 0x464e8c82dff694d1, 0x5ad2de3adbc6dad3
d_5_25:         .dword 0x0f658b0ee1bb1c01, 0x321ebaeea5c7f93b
d_5_26:         .dword 0xb2f41a7237949a32, 0x44e7694545ac9b24
d_5_27:         .dword 0xc88838d117b4ba46, 0x92029684cc0e3433
                .dword 0xa1d4badcb46d6860, 0xf97764de2f296ec3
                .dword 0x4ca551bba353cc55, 0x8b68e70f0287a052
         /* Random data */
_end_data5:
              
 
