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
_p0:    csrrci x14, satp, 31                      ;
_p1:;
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
_s0:    csrrci x21, sip, 31                       ;
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
_l0:    la x6, d_5_6                              ;
        addi x6, x6, 16                           ;
        amominu.d x11, x24, (x6)                  ;
_l1:    la x20, d_2_3                             ;
        fsw f10, -16(x20)                         ;
_l2:    mulh x26, x24, x2                         ;
_l3:    csrrwi x3, sepc, 14                       ;
_l4:    div x19, x10, x9                          ;
_l5:    fcvt.lu.s x4, f30, rmm                    ;
_l6:    fcvt.l.s x26, f15, rdn                    ;
_l7:    la x27, d_1_20                            ;
        addi x27, x27, 24                         ;
        lui x25, 0xffe00                          ;
        xor x27, x27, x25                         ;
        amomin.d x19, x25, (x27)                  ;
_l8:    la x23, d_1_26                            ;
        sb x23, -29(x23)                          ;
_l9:    la x16, _l130                                     ;
        csrrw zero, sepc, x16                     ;
        sret                                      ;
_l10:   slti x13, x13, -896                       ;
_l11:   srliw x18, x6, 3                          ;
_l12:   la x21, d_5_8                             ;
        addi x21, x21, 8                          ;
        amomax.d x17, x26, (x21)                  ;
_l13:   feq.s x20, f12, f22                       ;
_l14:   feq.s x8, f0, f11                         ;
_l15:   remuw x28, x0, x28                        ;
_l16:   la x27, _l79                              ;
        csrrw zero, sepc, x27                     ;
        sret                                      ;
_l17:   la x24, d_2_3                             ;
        addi x24, x24, 0                          ;
        amoxor.d x27, x11, (x24)                  ;
_l18:   la x22, d_0_9                             ;
        addi x22, x22, -8                         ;
        amoand.d x12, x22, (x22)                  ;
_l19:   fsgnjn.s f19, f19, f4                     ;
_l20:   divu x28, x19, x20                        ;
_l21:   bgeu x10, x18, _l63                       ;
_l22:   la x28, d_5_6                             ;
        addi x28, x28, -20                        ;
        lr.w x19, (x28)                           ;
_l23:   mulh x23, x20, x11                        ;
_l24:   sltiu x15, x29, 1154                      ;
_l25:   sraw x20, x22, x14                        ;
_l26:   fcvt.s.w f23, x16, rdn                    ;
_l27:   la x21, d_5_16                            ;
        addi x21, x21, -24                        ;
        amoand.d x28, x17, (x21)                  ;
_l28:   fnmsub.s f6, f18, f23, f25, dyn           ;
_l29:   la x9, _l65                                       ;
        lwu x20, -20(x9)                          ;
_l30:   la x19, d_1_7                             ;
        addi x19, x19, 24                         ;
        amoswap.d x14, x11, (x19)                 ;
_l31:   la x24, d_0_4                             ;
        addi x24, x24, -16                        ;
        amoswap.w x22, x20, (x24)                 ;
_l32:   la x28, d_5_21                            ;
        lb x2, -10(x28)                           ;
_l33:   csrrwi x20, satp, 14                      ;
_l34:   addw x29, x12, x18                        ;
_l35:   la x22, d_3_6                             ;
        addi x22, x22, -16                        ;
        lr.d x3, (x22)                            ;
_l36:   fmin.s f1, f2, f11                        ;
_l37:   fmin.s f13, f11, f7                       ;
_l38:   la x5, d_1_5                              ;
        sw x1, -4(x5)                             ;
_l39:   bne x17, x2, _l87                                 ;
_l40:   la x12, d_0_21                            ;
        addi x12, x12, -8                         ;
        sc.d x23, x12, (x12)                      ;
_l41:   addi x26, x22, 1026                       ;
_l42:   fsub.s f11, f4, f1, rup                   ;
_l43:   la x26, d_1_13                            ;
        addi x26, x26, -16                        ;
        amoswap.d x21, x24, (x26)                 ;
_l44:   la x21, _l99                                      ;
        lw x8, -4(x21)                            ;
_l45:   andi x25, x22, 1882                       ;
_l46:   bgeu x13, x24, _l94                               ;
_l47:   la x19, d_0_5                             ;
        addi x19, x19, -16                        ;
        amoand.w x17, x27, (x19)                  ;
_l48:   fence                                     ;
_l49:   la x5, d_3_25                             ;
        addi x5, x5, 24                           ;
        amomaxu.w x21, x26, (x5)                  ;
_l50:   la x5, d_1_17                             ;
        addi x5, x5, -8                           ;
        amomaxu.d x28, x21, (x5)                  ;
_l51:   blt x19, x23, _l82                                ;
_l52:   bne x5, x13, _l93                         ;
_l53:   fcvt.wu.s x10, f26, rdn                   ;
_l54:   fsgnjn.s f16, f31, f6                     ;
_l55:   la x5, d_2_19                             ;
        lhu x28, -30(x5)                          ;
_l56:   la x18, d_1_20                            ;
        addi x18, x18, -0                         ;
        amoxor.d x5, x11, (x18)                   ;
_l57:   la x16, _l81                              ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l58:   la x5, _l68                                       ;
        csrrw zero, mepc, x5                      ;
        mret                                      ;
_l59:   flt.s x29, f30, f1                        ;
_l60:   fcvt.w.s x3, f11, rdn                     ;
_l61:   la x19, d_3_3                             ;
        sh x6, -30(x19)                           ;
_l62:   fmadd.s f8, f1, f8, f14, rtz              ;
_l63:   slli x6, x8, 26                           ;
_l64:   xori x4, x19, -964                        ;
_l65:   fcvt.wu.s x14, f23, dyn                   ;
_l66:   srlw x16, x3, x11                         ;
_l67:   xor x8, x8, x8                            ;
        addi x5, zero, 3                          ;
        slli x5, x5, 29                           ;
        add x8, x8, x5                            ;
        csrrs x13, satp, x8                       ;
_l68:   la x13, d_4_17                            ;
        srai x13, x13, 1                          ;
        csrrc x15, pmpaddr1, x13                  ;
_l69:   la x16, d_3_17                            ;
        sd x17, 0(x16)                            ;
_l70:   la x2, d_4_15                             ;
        addi x2, x2, -24                          ;
        amoand.w x24, x4, (x2)                    ;
_l71:   mul x17, x19, x4                          ;
_l72:   la x22, d_3_22                            ;
        sh x19, 14(x22)                           ;
_l73:   la x11, _l97                              ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l74:   csrrwi x15, pmpaddr3, 30                  ;
_l75:   bne x10, x8, _l76                                 ;
_l76:   srai x28, x24, 6                          ;
_l77:   ebreak                                    ;
_l78:   addw x19, x17, x25                        ;
_l79:   mul x23, x4, x1                           ;
_l80:   la x6, _l89                                       ;
        csrrw zero, uepc, x6                      ;
        uret                                      ;
_l81:   la x8, d_2_10                             ;
        addi x8, x8, -12                          ;
        sc.w x17, x9, (x8)                        ;
_l82:   la x25, d_4_23                            ;
        addi x25, x25, 0                          ;
        amoadd.d x5, x15, (x25)                   ;
_l83:   remu x6, x3, x12                          ;
_l84:   flt.s x22, f22, f12                       ;
_l85:   bltu x29, x14, _l126                               ;
_l86:   fcvt.wu.s x24, f1, rmm                    ;
_l87:   la x25, d_3_18                            ;
        addi x25, x25, -16                        ;
        amomin.d x18, x18, (x25)                  ;
_l88:   la x6, d_0_9                              ;
        addi x6, x6, -0                           ;
        amomaxu.d x3, x23, (x6)                   ;
_l89:   la x13, d_4_6                             ;
        lbu x8, -13(x13)                          ;
_l90:   fadd.s f19, f9, f26, rtz                  ;
_l91:   sllw x27, x8, x12                         ;
_l92:   la x15, d_5_17                            ;
        sw x30, 8(x15)                            ;
_l93:   la x19, d_3_0                             ;
        lb x27, 15(x19)                           ;
_l94:   remu x16, x27, x17                        ;
_l95:   la x14, d_2_8                             ;
        sb x19, -0(x14)                           ;
_l96:   fmsub.s f16, f22, f0, f15, rmm            ;
_l97:   fnmsub.s f20, f23, f26, f31, rup          ;
_l98:   la x27, d_4_14                            ;
        addi x27, x27, -8                         ;
        amoor.d x26, x13, (x27)                   ;
_l99:   sraw x6, x24, x20                         ;
_l100:  fcvt.lu.s x25, f12, rtz                   ;
_l101:  srliw x0, x16, 0                          ;
_l102:  fcvt.s.wu f1, x24, rdn                    ;
_l103:  fcvt.s.l f16, x29, rtz                    ;
_l104:  la x4, d_5_12                             ;
        addi x4, x4, -0                           ;
        lr.d x23, (x4)                            ;
_l105:  la x19, d_3_22                            ;
        addi x19, x19, 0                          ;
        sc.d x13, x19, (x19)                      ;
_l106:  mulh x12, x9, x2                          ;
_l107:  la x6, d_0_9                              ;
        sb x30, 28(x6)                            ;
_l108:  fmax.s f9, f24, f22                       ;
_l109:  xor x23, x23, x23                         ;
        addi x12, zero, 3                         ;
        slli x12, x12, 14                         ;
        add x23, x23, x12                         ;
        addi x25, zero, 1                         ;
        slli x25, x25, 18                         ;
        add x23, x23, x25                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 23                         ;
        add x23, x23, x18                         ;
        csrrc x28, mhartid, x23                   ;
_l110:  fcvt.s.l f16, x16, rmm                    ;
_l111:  lui x1, 833651                            ;
_l112:  divu x24, x25, x24                        ;
_l113:  la x25, _l122                             ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l114:  sllw x27, x20, x15                        ;
_l115:  fclass.s x23, f7                          ;
_l116:  srai x0, x1, 18                           ;
_l117:  remuw x3, x17, x4                         ;
_l118:  remw x19, x21, x10                        ;
_l119:  la x2, d_2_7                              ;
        addi x2, x2, 0                            ;
        amomin.d x28, x27, (x2)                   ;
_l120:  mul x12, x18, x6                          ;
_l121:  la x14, d_3_16                            ;
        addi x14, x14, -0                         ;
        amoand.d x29, x11, (x14)                  ;
_l122:  la x16, _l128                                     ;
        csrrw zero, mepc, x16                     ;
        mret                                      ;
_l123:  remw x4, x4, x11                          ;
_l124:  rem x19, x13, x14                         ;
_l125:  la x15, d_2_11                            ;
        addi x15, x15, -28                        ;
        amoswap.w x5, x5, (x15)                   ;
_l126:  li x26, 0                                 ;
        la x17, pt3                               ;
        addi x17, x17, 8                          ;
        sfence.vma x26, x17                       ;
_l127:  sltiu x4, x21, -953                       ;
_l128:  la x5, d_5_27                             ;
        sb x13, -0(x5)                            ;
_l129:  csrrci x23, mtval, 31                     ;
_l130:  fmsub.s f21, f22, f25, f5, rdn            ;
_l131:;
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
                .dword 0x4ca664d468e37d4a, 0x3393b380bf7fa282
                .dword 0xa5c272843185dc5b, 0x7fdc77f6460bba93
d_0_0:          .dword 0xb7651da4f09b918b, 0x9907fb35944d3bd8
d_0_1:          .dword 0x0da7ba92e383f94b, 0x53098200d3ed595e
d_0_2:          .dword 0x2ad2b9de67a357ba, 0x44ef36c71c53c0b1
d_0_3:          .dword 0xa0fc02a57d3f27d7, 0x56cd7ec1b13ea192
d_0_4:          .dword 0x0a9136e4d8f2a194, 0xf49d4d4f99f49b20
d_0_5:          .dword 0xa9184af5bb062fda, 0xcbb5717932477d20
d_0_6:          .dword 0x35feaa7771959af1, 0x7686f1eae10f8b8f
d_0_7:          .dword 0xf2a1e07ffb72dd4e, 0x4576f60ab86dfbdb
d_0_8:          .dword 0x8e98486595e511fd, 0xacd8f8944ed5f5ad
d_0_9:          .dword 0xf1f820547d1d88df, 0xa69b8e12f7e190ba
d_0_10:         .dword 0x158542c7a8923fbf, 0xd766ee07898258ba
d_0_11:         .dword 0x03d229b23cd9fcd3, 0x2d8c0f2dc32bcaaa
d_0_12:         .dword 0x30faac9e77ec264c, 0x81794185db0c67db
d_0_13:         .dword 0xf1f1eba623f59fc6, 0x6ba0a19b2e0252a4
d_0_14:         .dword 0xb6b76fc0a69d30ac, 0x301f3eb8ec311c98
d_0_15:         .dword 0xf4ea6e5b3796d8b6, 0x37b2321a271eb6ea
d_0_16:         .dword 0x54ed7ac17ad969ae, 0x1a43fc9bce3f2a7b
d_0_17:         .dword 0x5665113d85f29fd7, 0xc76d50c054fff765
d_0_18:         .dword 0xaf6c3951626d5730, 0xdc012ddfd9aeb216
d_0_19:         .dword 0xddbf8682c76bc6fa, 0x987cdbc50811c1b2
d_0_20:         .dword 0xe46c8e9eecdf1d03, 0x7fdeb4e783d1a623
d_0_21:         .dword 0xfa950d9728ffe612, 0xcba6c2c4823cbaf3
d_0_22:         .dword 0xb1775ff9d7253e0b, 0x8a474a3585560f5f
d_0_23:         .dword 0x02d8a1d4cf0858ec, 0xd7fa67d8749112b3
d_0_24:         .dword 0x53ec226197b921da, 0xae7825cf564035ff
d_0_25:         .dword 0x84275d09f3bb1bf2, 0x8d05beded86688c2
d_0_26:         .dword 0x9e1233f61f055fef, 0x6dfb3b0d158ec239
d_0_27:         .dword 0x238f773b00932a23, 0x79045ca8a9ca726f
                .dword 0x29ba0fdc3f6b010d, 0xb0beda79cf5966d2
                .dword 0x7613cc2b65ff1151, 0x3a293ce02abc54d0
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x6d8ff404fd52c0ce, 0x8730aec009840b7b
                .dword 0xd3dfc9778a39329e, 0xf8649350ac8702ea
d_1_0:          .dword 0x19d218a85c2ac925, 0x371a69ba1b80d07f
d_1_1:          .dword 0x11b9b9488286a7dc, 0xa64a368b5807ce0a
d_1_2:          .dword 0xee427f510bc4ffc0, 0x7c5da4f09de1a9ee
d_1_3:          .dword 0xc11e255431b6d4a3, 0x43e8ef89a54e0657
d_1_4:          .dword 0x8b6cf840e252d56b, 0xff7dc4b0d7189f60
d_1_5:          .dword 0x33dc1ca1ea80d4b1, 0x55566d266f12be85
d_1_6:          .dword 0x15d89e7407b8371d, 0x83ee1d51b85e6345
d_1_7:          .dword 0x61da65266bef5ce0, 0xd765355bc79d7a89
d_1_8:          .dword 0xcceaccc4b7a41dc9, 0xd0efaa957cb1e90f
d_1_9:          .dword 0x3478d17dded4d275, 0x22e3b08fd4544a74
d_1_10:         .dword 0xfd1379196b612074, 0x93fe2de04d3667d6
d_1_11:         .dword 0x38439f56d676f384, 0x5a5ee2291fca801d
d_1_12:         .dword 0xc9057d29cda87a57, 0x8ee97bfe66aa8f4c
d_1_13:         .dword 0xa835191b9e966688, 0x4815daa7cdacfdc7
d_1_14:         .dword 0xedfd52638049cf3c, 0x2be33a909f9bc837
d_1_15:         .dword 0x71c922343543bc2c, 0x1695ed4d3584baff
d_1_16:         .dword 0xd4d0baaca01df704, 0x9c0f935125f9ae8c
d_1_17:         .dword 0x88142bd70de2b88b, 0x9776bc973cf9c9af
d_1_18:         .dword 0x22fee05d17f7269b, 0x607d32890cb7a09b
d_1_19:         .dword 0x30a243687bd11514, 0x1c7d453736ae7f63
d_1_20:         .dword 0xa0c0a10e1421485f, 0x4cdfc6593dccdc5e
d_1_21:         .dword 0x0eb10c87794dafb4, 0xec9ed19347def845
d_1_22:         .dword 0xd49c8d8ed49db000, 0x4ae21aae2fbd2315
d_1_23:         .dword 0x2d72c73912a1db7d, 0x329676fe506b3d7e
d_1_24:         .dword 0x6c3b5c2865564eb9, 0xc9bb2b793b3e2831
d_1_25:         .dword 0x609177ac7d2c68b7, 0xf0422b93935de7c7
d_1_26:         .dword 0x95e5af4ca425d235, 0xff34d25ecea46dc9
d_1_27:         .dword 0x1c626b43cc1da559, 0x718dd0fd364a0b64
                .dword 0x7db78af67c455f27, 0xfc046b15efa76259
                .dword 0xc56abbb723b34111, 0xba21cc8807ce6c3e
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xd3b1f8c7a209bfb7, 0x4a1e8d32b5dcf85f
                .dword 0x2f3320d7d4c9cd51, 0xc613cc403f877fa3
d_2_0:          .dword 0x5ba0786d5e79baea, 0x46dc3071117f5ff6
d_2_1:          .dword 0xf88dbbc7cff9b913, 0x4e4a4518c531c672
d_2_2:          .dword 0xf4c70791f69b8f7a, 0x447e29c2bc1ea571
d_2_3:          .dword 0xb0dd68604e2e22b1, 0xa7251e3dfbf867a7
d_2_4:          .dword 0x069f92b0e42224a9, 0x7e35f7bf30769ada
d_2_5:          .dword 0x32226a9360f9af2b, 0x52b709817174fa05
d_2_6:          .dword 0xe82226f9a7cba012, 0x8984852a009d41c1
d_2_7:          .dword 0x07f304ec5f667b3d, 0x3abe7fca2eb3a4f7
d_2_8:          .dword 0x49682c238b3ec2cd, 0x7243f5f125e5d60a
d_2_9:          .dword 0xb043a69881ef89a5, 0x86da2155746ddb8b
d_2_10:         .dword 0x3203b5d2af269795, 0xbe07c064b2386792
d_2_11:         .dword 0xaa66ffb47403ffdf, 0xcc0c262abf034934
d_2_12:         .dword 0xa1b4eed1e9242911, 0x66953e01c48378a2
d_2_13:         .dword 0xac480173dc4a4505, 0x06b7d0bd36fcee00
d_2_14:         .dword 0x5bdf5f4655eacd32, 0xb41120a89b52ffd3
d_2_15:         .dword 0xe108d467a3d2015e, 0x74e0eda456999d10
d_2_16:         .dword 0xa037c3bd14b43854, 0xc20c05d9fcd156b8
d_2_17:         .dword 0x87860803f14fbda8, 0xc307d443bdc1a7bd
d_2_18:         .dword 0x878bcffccbc0ab11, 0x3f2e392a5e3dbdd9
d_2_19:         .dword 0x8a076aa9aa0b3501, 0x98e88ad0429625b1
d_2_20:         .dword 0xef45e7fa654b3f46, 0x2a770bc168bcad63
d_2_21:         .dword 0xa7a70f1cf79b2a81, 0x04fc0323d29a6730
d_2_22:         .dword 0xd2fdca0645710dc6, 0x074039995ff8e5f7
d_2_23:         .dword 0x45e5cb3c51991b6a, 0xc9f5b346de599274
d_2_24:         .dword 0x8b2289da9f1d6a84, 0x1035391f7dd5ba52
d_2_25:         .dword 0xa21613daca06e706, 0x6ebf747c086e15f8
d_2_26:         .dword 0xf5788afd019442cf, 0x5a7013f475da0217
d_2_27:         .dword 0x084d119f343e27f4, 0x4bfdd318e6505595
                .dword 0xaa32bc874b0b88cc, 0xb8da1c9def7b9df2
                .dword 0x8e905f244a685f55, 0xdf0018a7bd8676c3
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x08bad67c72e62fc1, 0x6e7c1fed26d143c9
                .dword 0x626cb2812c18ab24, 0x31be07665e2e79ef
d_3_0:          .dword 0x80eb38f4b4ef51c8, 0xe6fd379995a5c747
d_3_1:          .dword 0x320fe0831d2c957c, 0x7c7adb011e7a55b6
d_3_2:          .dword 0x6045c432a9d7c992, 0x590b2eeebb13b544
d_3_3:          .dword 0x208071b96494fe3d, 0xdf10cb8cd51e1216
d_3_4:          .dword 0x59a67b28ef6f6adc, 0xcaa37078cdbf1ff8
d_3_5:          .dword 0xe7427f3a1dedc3af, 0x20aa09fa6d08365b
d_3_6:          .dword 0xea7b8d8fee299ccb, 0x302b9a04a2d7858d
d_3_7:          .dword 0xf1518dfb95bcadbc, 0xa931656ef5ae1bfc
d_3_8:          .dword 0x92e8ec364f473b27, 0x169bad29b56a35c1
d_3_9:          .dword 0xf4d995ddbe567b98, 0x3509d6e8b375548f
d_3_10:         .dword 0xbd2342bb4e457026, 0x86425d6018c35f3e
d_3_11:         .dword 0xd5d197704f45ad5f, 0x712f1f7c0570346e
d_3_12:         .dword 0x9d88d1003f806ff3, 0x8245d1eb660695bb
d_3_13:         .dword 0x87dada5fed389897, 0x296a8265ac626a0b
d_3_14:         .dword 0x4217af6062f13611, 0x70457b9c056aa1cd
d_3_15:         .dword 0x495369e2026106f7, 0x3b47a689c91d17e7
d_3_16:         .dword 0xfcd5eca1c34cabb8, 0x7ac4381b1a4e1520
d_3_17:         .dword 0xb65a966e28cf43b7, 0xe396848e510d7f2f
d_3_18:         .dword 0xaf640710a190ac5e, 0x6c49992a3f8c25a1
d_3_19:         .dword 0xa152243a446e2d2e, 0xb8f1b8f3bd1a1d8d
d_3_20:         .dword 0xf4f7e6e178187c0b, 0x8186904dc3773372
d_3_21:         .dword 0x29f33cd32cdb815c, 0x539fce806eecfe10
d_3_22:         .dword 0x5ca92de5d3e7c5e3, 0x25bcd0ef1d5445c4
d_3_23:         .dword 0x8348553ccc9c18e0, 0x71a235960b19c496
d_3_24:         .dword 0x050fc688238660ae, 0x48f1bc35b0c5a212
d_3_25:         .dword 0x855565be4f555a7d, 0x4133f630ac08d11a
d_3_26:         .dword 0xa614f9e3bc22317f, 0xab910cbf5e39f25e
d_3_27:         .dword 0x136faf94d18c78ff, 0x6ace0e689e6f87e8
                .dword 0xd01e07fac404f585, 0x6c9be3756945767f
                .dword 0x69d7a31960dc9f47, 0x18501a97485b5abf
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x5097e7ebad7aec78, 0x4a7d79e548772e2f
                .dword 0xcc6d2f6f9cb233a7, 0xc514966a63cebae3
d_4_0:          .dword 0x4e11e53fcb4fa0e0, 0x0ede7e7b8518e558
d_4_1:          .dword 0xa3c0e6d59507160e, 0x711eb0cb75871b54
d_4_2:          .dword 0x8975ec69a0f46e87, 0x4ab905ad8e3a5c92
d_4_3:          .dword 0xd3a161b9bcc77bc2, 0x8bb5ce13824984f5
d_4_4:          .dword 0xa5e94a4265c66a53, 0x4a95024240a0d328
d_4_5:          .dword 0xe17cf9773cc8d7de, 0x708436fd31229cb9
d_4_6:          .dword 0x807af15918da6876, 0xc366fffca577155b
d_4_7:          .dword 0x6256f262418cac54, 0x42e2213c68867773
d_4_8:          .dword 0xfbbe58d93cd2397c, 0x8e3a9c50d6b61b0a
d_4_9:          .dword 0xd97e8f9a4b25ba96, 0x303b7bda75c88c77
d_4_10:         .dword 0x68cfa81bb7aa7128, 0xac2d5592f320ba3a
d_4_11:         .dword 0xbd30e87fbff33588, 0xeee198d1530af4cd
d_4_12:         .dword 0xc9b1774e4796f678, 0x6c4cf00c25248cea
d_4_13:         .dword 0x4146108891ef27f0, 0xb92bdf6a04bfff9f
d_4_14:         .dword 0x3f41a734a86b5891, 0x4c49a4dc2f582bf2
d_4_15:         .dword 0x2947348f0336a96b, 0xa30275eb1239aa2e
d_4_16:         .dword 0xa5b4de6bfa428aba, 0x1371df2d42b0bafb
d_4_17:         .dword 0x5bd051a9472a8e44, 0x8b17a74a465e3860
d_4_18:         .dword 0x1e49b83c0f679b29, 0xb4bab4aa941057e6
d_4_19:         .dword 0x79b70e088f2643c0, 0x13e18c2d00be7228
d_4_20:         .dword 0xbb67d021795ea790, 0x2f109396e2419fa6
d_4_21:         .dword 0x23cae84e5bdc2875, 0x22da8503339b38ac
d_4_22:         .dword 0x335e9437046b1957, 0x0c9a38cde597d962
d_4_23:         .dword 0x112b85973a66608d, 0xf5904504489045b7
d_4_24:         .dword 0x657156e9c14e31aa, 0x584dca2822adf18e
d_4_25:         .dword 0x2171e913a8023392, 0x49812f4e9eb70bfd
d_4_26:         .dword 0x50844fb93899db05, 0xfa8e7cd60cabe05d
d_4_27:         .dword 0x79e8b7d5bcbc7b3d, 0x394b52e3a72907d0
                .dword 0x1def647ef594e583, 0x60f3c98d2058d379
                .dword 0x46a7c96e68c88ef4, 0xb052ab05658cb8f5
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xf9813f2b365dcd4f, 0x773f3cf6d155acf9
                .dword 0x2b060e9f2a204662, 0xe01dc846463e8cff
d_5_0:          .dword 0x1c6e18f34c1d1dd7, 0x653df1eb5b38c607
d_5_1:          .dword 0xf011419dcb336496, 0xa50fe0091d7c1c82
d_5_2:          .dword 0xe571c47553715cc4, 0x9e528710fd34a791
d_5_3:          .dword 0x6997b20b3b9c36ac, 0xf494208fae70f2c7
d_5_4:          .dword 0xb19a5fc63b3c7732, 0x6a07bcabadffd3a3
d_5_5:          .dword 0xfb4dcc155524a867, 0xe602e62506e52424
d_5_6:          .dword 0x708b5a4a0b569a77, 0x39813e9285d49b85
d_5_7:          .dword 0xcd36ab5ea4815c79, 0x2333aa70cfb2276f
d_5_8:          .dword 0x236d760a96cba084, 0x0a12d42800f06ac1
d_5_9:          .dword 0xdebcaa161febb769, 0x04da2eea25ef14c9
d_5_10:         .dword 0x91ad691e4b04310f, 0x6a49e85d02f608d6
d_5_11:         .dword 0x6d64139ceed9cd91, 0xc345dfdb7f552e3b
d_5_12:         .dword 0x8310f6fed82bfb6d, 0x21b8c23739190144
d_5_13:         .dword 0x0120c54172c9e94b, 0xec7fe80b54c65ff1
d_5_14:         .dword 0x602a6b6035b6c08a, 0x483bab6baed9df8e
d_5_15:         .dword 0xfb20587955b70fe7, 0x530b563adf24d56f
d_5_16:         .dword 0x6bf4189f7f966159, 0xd663b67f94e3f20a
d_5_17:         .dword 0x326b79acf1e42dd8, 0x9de1f02907c6401c
d_5_18:         .dword 0x882d89a2010e62b2, 0x45fbf279bec5fcff
d_5_19:         .dword 0x745821334e5b86f4, 0xe207075a3f188656
d_5_20:         .dword 0x912f62758988a1b5, 0x3c06e66b87225ddf
d_5_21:         .dword 0xc6a2df5c323f1526, 0x523dbfa0d80f874d
d_5_22:         .dword 0xb8907171237ec54d, 0xacb68eaed42cf9ea
d_5_23:         .dword 0x04661bed9035a14a, 0x9ee2d7b0cd5b6107
d_5_24:         .dword 0xdd3cb66406658bf6, 0x23759ef41c10ba67
d_5_25:         .dword 0x72db3354744040fa, 0xe27d4a3d567138a2
d_5_26:         .dword 0x1d12cbe7ec1a2529, 0x9cd205e6b79fc2b0
d_5_27:         .dword 0x5f590ff50273a431, 0xf5ea0b9605a2a029
                .dword 0x11f1d9838f7d9e38, 0xb75d28be5ae3367d
                .dword 0xdb7f9fc388107cbb, 0x52a4ad6fb39521d2
         /* Random data */
_end_data5:
              
 
