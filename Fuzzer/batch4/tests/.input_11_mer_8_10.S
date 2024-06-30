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
_p0:    csrrwi x11, stval, 6                      ;
_p1:    csrrsi x13, sip, 6                        ;
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
_s0:    addiw x13, x20, 16                        ;
_s1:    la x17, d_3_10                            ;
        ld x4, 0(x17)                             ;
_s2:    sraiw x24, x14, 8                         ;
_s3:;
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
_l0:    divw x2, x21, x1                          ;
_l1:    fcvt.s.l f3, x5, rne                      ;
_l2:    slliw x11, x16, 0                         ;
_l3:    rem x22, x22, x24                         ;
_l4:    la x10, d_3_21                            ;
        addi x10, x10, -0                         ;
        amomax.w x25, x16, (x10)                  ;
_l5:    xori x18, x8, 6                           ;
_l6:    csrrwi x27, pmpaddr2, 5                   ;
_l7:    la x13, d_3_11                            ;
        srai x13, x13, 1                          ;
        csrrw x25, pmpaddr2, x13                  ;
_l8:    fmv.w.x f19, x26                          ;
_l9:    fcvt.wu.s x13, f5, rdn                    ;
_l10:   divu x7, x7, x24                          ;
_l11:   la x27, d_4_7                             ;
        addi x27, x27, -0                         ;
        amoxor.w x12, x10, (x27)                  ;
_l12:   la x3, _l45                               ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l13:   la x23, d_1_13                            ;
        addi x23, x23, -0                         ;
        amoxor.w x16, x17, (x23)                  ;
_l14:   fdiv.s f9, f3, f26, rne                   ;
_l15:   fdiv.s f11, f1, f6, rmm                   ;
_l16:   la x17, d_2_13                            ;
        addi x17, x17, 0                          ;
        lr.d x19, (x17)                           ;
_l17:   sraw x4, x12, x24                         ;
_l18:   divu x29, x14, x27                        ;
_l19:   la x14, d_4_22                            ;
        lwu x14, -12(x14)                         ;
_l20:   la x8, d_1_6                              ;
        addi x8, x8, -16                          ;
        amominu.d x11, x6, (x8)                   ;
_l21:   la x27, d_4_16                            ;
        lh x9, -28(x27)                           ;
_l22:   bgeu x7, x28, _l88                                ;
_l23:   srlw x8, x19, x24                         ;
_l24:   la x27, d_4_17                            ;
        addi x27, x27, 12                         ;
        amoor.w x15, x30, (x27)                   ;
_l25:   la x10, _l78                              ;
        jalr x3, 0(x10)                           ;
_l26:   xori x30, x20, -0                         ;
_l27:   srai x16, x4, 55                          ;
_l28:   fsqrt.s f19, f12, dyn                     ;
_l29:   fmv.x.w x2, f1                            ;
_l30:   lui x26, 423231                           ;
_l31:   la x11, d_4_7                             ;
        addi x11, x11, -0                         ;
        lr.w x11, (x11)                           ;
_l32:   fmul.s f29, f27, f7, rne                  ;
_l33:   la x11, d_2_18                            ;
        sh x6, 30(x11)                            ;
_l34:   la x30, _l108                                     ;
        jalr x2, 0(x30)                           ;
_l35:   xor x17, x17, x17                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 21                           ;
        add x17, x17, x7                          ;
        addi x18, zero, 1                         ;
        slli x18, x18, 9                          ;
        add x17, x17, x18                         ;
        addi x2, zero, 1                          ;
        slli x2, x2, 24                           ;
        add x17, x17, x2                          ;
        csrrw x13, mie, x17                       ;
_l36:   csrrci x2, fflags, 18                     ;
_l37:   slliw x27, x4, 0                          ;
_l38:   mulhu x10, x18, x2                        ;
_l39:   la x20, d_5_4                             ;
        addi x20, x20, -8                         ;
        amoswap.d x29, x6, (x20)                  ;
_l40:   fcvt.lu.s x0, f15, rmm                    ;
_l41:   xor x25, x25, x25                         ;
        addi x23, zero, 3                         ;
        slli x23, x23, 29                         ;
        add x25, x25, x23                         ;
        addi x3, zero, 3                          ;
        slli x3, x3, 3                            ;
        add x25, x25, x3                          ;
        addi x13, zero, 1                         ;
        slli x13, x13, 15                         ;
        add x25, x25, x13                         ;
        csrrc x11, fflags, x25                    ;
_l42:   fcvt.s.wu f25, x26, rmm                   ;
_l43:   mul x28, x24, x30                         ;
_l44:   la x15, d_4_17                            ;
        addi x15, x15, 24                         ;
        amominu.d x23, x1, (x15)                  ;
_l45:   mulw x14, x22, x11                        ;
_l46:   divuw x29, x9, x19                        ;
_l47:   la x15, d_4_27                            ;
        addi x15, x15, -0                         ;
        lui x29, 0xffe00                          ;
        xor x15, x15, x29                         ;
        amomax.w x6, x29, (x15)                   ;
_l48:   la x17, d_2_12                            ;
        addi x17, x17, -16                        ;
        lr.w x28, (x17)                           ;
_l49:   remuw x9, x9, x23                         ;
_l50:   fsub.s f25, f13, f0, rmm                  ;
_l51:   fsgnjx.s f18, f12, f26                    ;
_l52:   fmv.w.x f11, x8                           ;
_l53:   bgeu x20, x5, _l97                                ;
_l54:   bne x12, x2, _l65                         ;
_l55:   la x25, d_1_2                             ;
        addi x25, x25, -4                         ;
        amomax.w x29, x7, (x25)                   ;
_l56:   la x16, d_5_5                             ;
        fsw f22, 16(x16)                          ;
_l57:   mulw x10, x4, x5                          ;
_l58:   mulhu x19, x23, x12                       ;
_l59:   la x7, d_3_4                              ;
        lh x23, 0(x7)                             ;
_l60:   la x25, d_4_25                            ;
        addi x25, x25, -0                         ;
        amoand.d x27, x18, (x25)                  ;
_l61:   la x18, d_4_3                             ;
        addi x18, x18, 28                         ;
        amoand.w x26, x10, (x18)                  ;
_l62:   la x1, d_2_1                              ;
        addi x1, x1, 8                            ;
        amoor.d x7, x23, (x1)                     ;
_l63:   la x9, _l16                                       ;
        srai x9, x9, 1                            ;
        csrrw x15, pmpaddr7, x9                   ;
_l64:   la x15, d_0_16                            ;
        lb x27, -6(x15)                           ;
_l65:   fcvt.l.s x8, f7, rne                      ;
_l66:   la x13, d_5_11                            ;
        addi x13, x13, 8                          ;
        amomin.d x1, x8, (x13)                    ;
_l67:   la x17, d_4_10                            ;
        addi x17, x17, 8                          ;
        sc.d x2, x17, (x17)                       ;
_l68:   slti x8, x26, 7                           ;
_l69:   fcvt.l.s x3, f4, rne                      ;
_l70:   la x17, d_1_23                            ;
        lui x15, 0xffe00                          ;
        xor x17, x17, x15                         ;
        lh x3, -30(x17)                           ;
_l71:   srli x5, x28, 63                          ;
_l72:   fsqrt.s f16, f10, dyn                     ;
_l73:   fadd.s f10, f31, f7, rne                  ;
_l74:   xor x19, x19, x19                         ;
        addi x18, zero, 1                         ;
        slli x18, x18, 28                         ;
        add x19, x19, x18                         ;
        addi x19, zero, 3                         ;
        slli x19, x19, 11                         ;
        add x19, x19, x19                         ;
        csrrc x6, mtval, x19                      ;
_l75:   ori x22, x24, -1517                       ;
_l76:   addiw x7, x27, -160                       ;
_l77:   auipc x13, 453864                         ;
_l78:   xori x2, x7, 1592                         ;
_l79:   sllw x3, x10, x17                         ;
_l80:   beq x18, x4, _l97                                 ;
_l81:   fcvt.s.l f12, x12, rup                    ;
_l82:   fcvt.s.lu f19, x16, rup                   ;
_l83:   srlw x25, x22, x24                        ;
_l84:   slliw x21, x9, 31                         ;
_l85:   xor x4, x4, x4                            ;
        csrrs x22, mepc, x4                       ;
_l86:   la x26, d_5_15                            ;
        addi x26, x26, 8                          ;
        amomin.w x8, x4, (x26)                    ;
_l87:   flt.s x30, f27, f18                       ;
_l88:   div x15, x0, x17                          ;
_l89:   fdiv.s f29, f19, f16, rdn                 ;
_l90:   fcvt.s.l f24, x24, dyn                    ;
_l91:   csrrwi x1, mtval, 7                       ;
_l92:   la x2, d_1_21                             ;
        addi x2, x2, 24                           ;
        amominu.d x29, x6, (x2)                   ;
_l93:   srai x8, x2, 23                           ;
_l94:   bge x27, x21, _l96                                ;
_l95:   la x22, d_2_4                             ;
        addi x22, x22, -0                         ;
        amoand.w x13, x27, (x22)                  ;
_l96:   bge x17, x24, _l103                               ;
_l97:   fmsub.s f1, f29, f31, f29, rdn            ;
_l98:   la x10, d_2_22                            ;
        addi x10, x10, 8                          ;
        amoand.w x28, x28, (x10)                  ;
_l99:   fmin.s f14, f18, f7                       ;
_l100:  addi x29, x19, 1279                       ;
_l101:  la x23, d_4_24                            ;
        addi x23, x23, 16                         ;
        amomaxu.d x8, x11, (x23)                  ;
_l102:  la x5, d_3_5                              ;
        ld x5, 8(x5)                              ;
_l103:  mulhu x25, x7, x10                        ;
_l104:  fsub.s f31, f20, f11, rup                 ;
_l105:  fcvt.s.w f7, x30, rmm                     ;
_l106:  la x28, d_3_17                            ;
        lbu x12, -19(x28)                         ;
_l107:  la x20, d_4_20                            ;
        sd x18, -0(x20)                           ;
_l108:  la x19, d_5_2                             ;
        addi x19, x19, 16                         ;
        amomaxu.w x10, x10, (x19)                 ;
_l109:  sllw x13, x16, x25                        ;
_l110:  ebreak                                    ;
_l111:  la x20, d_5_4                             ;
        lb x1, -18(x20)                           ;
_l112:  la x1, d_5_21                             ;
        addi x1, x1, 0                            ;
        amomax.w x22, x1, (x1)                    ;
_l113:  slli x14, x4, 31                          ;
_l114:;
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
                .dword 0x44a2a46873e77bfd, 0x6dba89cfa119baf7
                .dword 0xe0700b5aaff0ab42, 0x91c2a4e4bd4eccef
d_0_0:          .dword 0x7371e24a2954ce57, 0xae27168300d7e7d5
d_0_1:          .dword 0xdcf4bbcce04835b2, 0xecfa7af5219b08fb
d_0_2:          .dword 0x530b9d4c83c0ea9f, 0x307d431f3e62db83
d_0_3:          .dword 0xa1b694bc8fab6921, 0x072ad6b726e84049
d_0_4:          .dword 0x47ec461d3d6c7740, 0x6758a9094bb88541
d_0_5:          .dword 0x496653df46bd7e95, 0xa2c216a1a4df065f
d_0_6:          .dword 0x55e2aa3387f71c70, 0x6f13fa68eba4fb73
d_0_7:          .dword 0x4168d47002e36ccb, 0x81eb82852ea16575
d_0_8:          .dword 0xeb6fb0a615ef030d, 0x94cff287d9b92f24
d_0_9:          .dword 0x3fe5913fdb732a42, 0xbed011ba983a8b64
d_0_10:         .dword 0xe1987ba69cbf85e6, 0x65fc7468230861c5
d_0_11:         .dword 0x2acc3a3543499483, 0xbf65408b01346e73
d_0_12:         .dword 0x56f50e2e60db87c3, 0x4c629c2edaf064ec
d_0_13:         .dword 0x28f9f858245c16d8, 0xb8d1e051d0431ec0
d_0_14:         .dword 0x5895436f3ddad260, 0x3f385bad7eff36f2
d_0_15:         .dword 0x12932c1b85126eb6, 0xbbec445396c6f4fb
d_0_16:         .dword 0xb9a37631c61b3f2e, 0xee0967c55ffc6150
d_0_17:         .dword 0xe58ef3a961199e91, 0x5ade1a2807bffc89
d_0_18:         .dword 0xcdb8c6f348197fcd, 0x14a1e3d2b02728cc
d_0_19:         .dword 0x58e03c05ae968907, 0x706252601419dbcb
d_0_20:         .dword 0xac1ef3e31a5ec465, 0xa182b8a346502741
d_0_21:         .dword 0x1f1e25d036e48016, 0x14e7e2257717129d
d_0_22:         .dword 0xfd902098d2840a9a, 0x4a07ef67bc994e85
d_0_23:         .dword 0xdc35bf1d4969cc3e, 0x5f52e50eb060c6de
d_0_24:         .dword 0x8066aaea8a0b4a04, 0xd6770c6ff14424f8
d_0_25:         .dword 0x0524d7a4450b04b7, 0x0bef58bef29d46ed
d_0_26:         .dword 0xc9010c95a0bb409b, 0xfe0201f81e250c30
d_0_27:         .dword 0x6ab42ed7072f0c5a, 0xb5e20f952fc54457
                .dword 0xa67bbd7d033ec97b, 0xad43fcbf48e2a339
                .dword 0x951f63bee7fdd835, 0xc4c6052e13595a9f
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xa04ba99195ec1ecc, 0x4011756750aeb45c
                .dword 0xb80cd558494c5813, 0x3d0671cda089d625
d_1_0:          .dword 0xadd9709fd4d7b525, 0xb81ac51d3413df2f
d_1_1:          .dword 0x215a243ff547718a, 0x2f43b058acd198d7
d_1_2:          .dword 0x7e31837a101ef5e6, 0x42205a388a7abf72
d_1_3:          .dword 0xbd80e70b932bda3a, 0xa8c679eb0cd7ccb9
d_1_4:          .dword 0x605f34b0e76fd5ed, 0x0349d711fd38aa4b
d_1_5:          .dword 0xbd6be12c399a7672, 0x6e976a653a673d7c
d_1_6:          .dword 0x9783ae4071a9ccf1, 0x5edf4cb0e9c52ef7
d_1_7:          .dword 0xf97ca121ab847f57, 0x6d2f044e29f757f0
d_1_8:          .dword 0x7eae73e633b62dca, 0xcfb7ab0dd590a39f
d_1_9:          .dword 0x5e519283a463f175, 0xa5e74d20ecb95939
d_1_10:         .dword 0xb9720d02642309a5, 0xf09674030db2d16a
d_1_11:         .dword 0x169e891451842cb5, 0x746c504f3b90eb86
d_1_12:         .dword 0xfdf57bc7d0444bec, 0xcf1b0414e2bd4d61
d_1_13:         .dword 0x8b4f13b8886d1014, 0x1326477315a2e79b
d_1_14:         .dword 0x463d563cc747d063, 0x283799a715dbfe6a
d_1_15:         .dword 0x508cb8f05105d065, 0x5f84683a9d0972fc
d_1_16:         .dword 0xefc53551a832dfdb, 0x09e5a43c82b5d4e8
d_1_17:         .dword 0x764e9aecf57497ab, 0xb764c20d840ba9a8
d_1_18:         .dword 0xce2d21d2c562b4f3, 0x81af7757b1d55668
d_1_19:         .dword 0x9850a2a8ac647e7e, 0xebda116b843f1fb0
d_1_20:         .dword 0xc56b7a6bcc6056ac, 0x7edd57dc9cad3bc2
d_1_21:         .dword 0x36d0b7940e6d03b2, 0x1d133fd4aa02269f
d_1_22:         .dword 0x55c3c0b257be5f8d, 0x04ef3948cdb75d51
d_1_23:         .dword 0x6cc2f7d8fa54dec2, 0x5af60840289f1535
d_1_24:         .dword 0x151476c009ee058e, 0x874ef1b54bb52ad1
d_1_25:         .dword 0x3cedb2bf5ceef472, 0x2ec2840497c446a4
d_1_26:         .dword 0x0b9e1f41d1bc85c6, 0x3498aa98d2b0c1b3
d_1_27:         .dword 0x3bf9517136f0f116, 0xe90ac08c034f2925
                .dword 0x5074f67ed055dab4, 0xc0f102be24e6c8f3
                .dword 0x12a7e601c18a8bf7, 0xf54b6439b1b86118
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x3e5216b7f4d0c99f, 0x9db06fa670e9dcad
                .dword 0xcef5ff96a2ed8090, 0x0a70ec5e558d1341
d_2_0:          .dword 0xdc6552688370081a, 0xc25ed81536566698
d_2_1:          .dword 0x284ddf4d8fcb4d00, 0x94a126f7c065a85f
d_2_2:          .dword 0xc521ff043393966a, 0x21cf268c1686d791
d_2_3:          .dword 0xc825a1bd920d79be, 0xa4afdfbe75d5d7af
d_2_4:          .dword 0x9b0f5b81882bb1fa, 0x095b1708a1fc3f68
d_2_5:          .dword 0xae611a5e9126c82a, 0x969d66f0520f6d61
d_2_6:          .dword 0xe1d4739a271b4ac2, 0xf19495eab5d737af
d_2_7:          .dword 0x97cc3040d229df0b, 0xfee41f1c2f8db812
d_2_8:          .dword 0xa9cd46d207576132, 0xaeab895c5f1fa294
d_2_9:          .dword 0x7742f3b73df3a9a1, 0x9c81c9c5304c82ca
d_2_10:         .dword 0x2721aee6150bc522, 0x03dc6b59cf4347be
d_2_11:         .dword 0x73501609f760a2d7, 0x96dfda5935e949ad
d_2_12:         .dword 0x507a5f01b83beb1e, 0x2dae264c3e1d9754
d_2_13:         .dword 0x599c89dddfdffefb, 0x5a4c3e77e2ac3857
d_2_14:         .dword 0x8a0e1fc94e2d922f, 0xbca5b2e7c00e707f
d_2_15:         .dword 0x16fc5b1f239fd987, 0xaf88a9a679afe770
d_2_16:         .dword 0xdcbe60a48c01a404, 0x04fe64656b5d19fc
d_2_17:         .dword 0x1cdf2a0d7366c279, 0x342667640bf5f312
d_2_18:         .dword 0xe3b932ccb32ecb0c, 0x652ed93acf0ed37f
d_2_19:         .dword 0x25e7d320d75512b4, 0x8a8f30a30b1701ed
d_2_20:         .dword 0x0a6b63de60bbd2ea, 0x9164eef0311b94c8
d_2_21:         .dword 0xb29d62224d11f90d, 0x859bfb7e41525dbf
d_2_22:         .dword 0x8700f97dc177b544, 0x8901cadca8522b0a
d_2_23:         .dword 0x36e409a74cd85dc6, 0x4dcca5b84593a970
d_2_24:         .dword 0x313438f0ba4e52c3, 0xf59c0a490142319c
d_2_25:         .dword 0x1c82cd279ba552e8, 0xf6788e6e69c8d6ec
d_2_26:         .dword 0x20bc61b0e45aa976, 0x3e8cc94e8d975add
d_2_27:         .dword 0xb3e0574b4543a646, 0x277aa7c988f91652
                .dword 0xbd34f53afe0bc70a, 0x956ba1753a4b286a
                .dword 0x4f3a57439b7f0dd8, 0xc788c893846cfdc1
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xee2ef684fbb8eb2b, 0xde71b2a6163b169d
                .dword 0xea87054d5bcb83c3, 0x6b8dc2826583a7b5
d_3_0:          .dword 0x89ff3eede6377455, 0x198daa2f2326f273
d_3_1:          .dword 0xcffe0570a8e86fbc, 0x1325cf9e4fd9d9a0
d_3_2:          .dword 0xe344c58a34463206, 0x8434de6504d588f7
d_3_3:          .dword 0x7a412aaefc12949e, 0x1d53cd05b61a87a0
d_3_4:          .dword 0x4dcfc605b7074b0f, 0xc6a1ddfed7290400
d_3_5:          .dword 0xbb5de6abaec8fd8a, 0xf34e1da2491920d1
d_3_6:          .dword 0xee9781f97056b20b, 0x34983b6f2cba9b30
d_3_7:          .dword 0xac8d6a0db7b4f9f3, 0xb984893ff02868a1
d_3_8:          .dword 0xb3f4f020b5260049, 0xe07762b9a534d90d
d_3_9:          .dword 0xe3ee36b4f95df579, 0xeaed9b45c2a860d7
d_3_10:         .dword 0xe9183a916cafc945, 0x2dc34f5a38685a13
d_3_11:         .dword 0xa026c20699e0e40a, 0x7fef90a8c9fa65c4
d_3_12:         .dword 0x81ec6fdd47da1817, 0x8d6f767229586139
d_3_13:         .dword 0x161695ac5510239d, 0xb40aa91cc2c3fac4
d_3_14:         .dword 0x0984a22baf0d2fcf, 0x96b4ce14034493c6
d_3_15:         .dword 0x3011c2ab85bd89be, 0x532fd5f5cda7bfe4
d_3_16:         .dword 0x30a6a1158a350577, 0x84f7e18f2f3f0304
d_3_17:         .dword 0x640c564bbf162e50, 0xf6ed9b6d726bf069
d_3_18:         .dword 0xb422941a78e90c36, 0x63718a5e0a51d5dc
d_3_19:         .dword 0xd18cf6df466c2e8d, 0xc55cac70d9d27052
d_3_20:         .dword 0x1b7395ec5d532bc2, 0x9b45a66e285c574d
d_3_21:         .dword 0x337ed020e1facfea, 0x5cf442b4e049c244
d_3_22:         .dword 0xaebcf8a38c698f44, 0x89fb9a3de1ddb7ca
d_3_23:         .dword 0x058fcb3b030f4b07, 0xc7d8cb06554fb5ee
d_3_24:         .dword 0x14f53581fe418381, 0x56630597ede9afa4
d_3_25:         .dword 0xa23d5c2bcc852b24, 0x542e24f295765a82
d_3_26:         .dword 0xb1bc1d8808458ff5, 0x7ada1cff8fc71f6a
d_3_27:         .dword 0xf71333e90a54bd3d, 0x03add836e014425a
                .dword 0x7827a04b070af762, 0xa09098354ffbd3f5
                .dword 0xf3c853266efc9fab, 0x025cf9bf0ab6c0d6
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x0f6e4a5a03c064c7, 0x271103e237fc8279
                .dword 0x06096bb473114e92, 0xf849ddf6008b482d
d_4_0:          .dword 0x7953520ec8e1513a, 0x19fc2587c5af8b2f
d_4_1:          .dword 0xc51437c401e8138f, 0xabf26d0b3db32cbe
d_4_2:          .dword 0x07105fbe64f8434f, 0x5414fc6f989b7a52
d_4_3:          .dword 0x63123329866c4403, 0xa77954a854d15570
d_4_4:          .dword 0x5892539c32d00260, 0x3f716704919148c0
d_4_5:          .dword 0x77d34b4d452f15cd, 0x9e70251f025607db
d_4_6:          .dword 0x2019e37092fcbf13, 0x710d243f140db272
d_4_7:          .dword 0x847b55f6ce43d3f7, 0xb20a2850b0b5ddac
d_4_8:          .dword 0xa544888c70c06489, 0x849f0eb78cbb3691
d_4_9:          .dword 0xd22af50a75de4a32, 0xd2582db48c5a25db
d_4_10:         .dword 0xcc6e785e3818f783, 0xf0ed29d4b552408e
d_4_11:         .dword 0xf1c3f55ce2a15aff, 0xec6013f3977b002c
d_4_12:         .dword 0x0f58c2d77f0d4e9b, 0xf4f40ecc0f67eb1f
d_4_13:         .dword 0x3dc6e63c848131d7, 0xd810542b4de6d77c
d_4_14:         .dword 0x3f14cd8110da3288, 0x429c9b43298dd9d4
d_4_15:         .dword 0xc4feb55b4209e4fe, 0x6d2edf09d7eefb72
d_4_16:         .dword 0x7e94fef1aecfa64d, 0xdba9c6d0ab6ffeff
d_4_17:         .dword 0xa3f5cb0284b1e0ee, 0xf57da30840183252
d_4_18:         .dword 0x7f6fadbedc3901d3, 0xb3d8c3f2803ddfb0
d_4_19:         .dword 0x30076de0b268f055, 0x46efebb139067b9e
d_4_20:         .dword 0x3ea68609e6523d35, 0x3cade8985efb3f5e
d_4_21:         .dword 0x755d45c0a2885925, 0x7102788c574400cb
d_4_22:         .dword 0xcdb4307777bf87a0, 0x8aada7ded5f84f4c
d_4_23:         .dword 0xeaf3e2d9be6054d1, 0x749d597b35df1a30
d_4_24:         .dword 0x4ca1eb6c22354b1a, 0x843386397d840ff6
d_4_25:         .dword 0xf4f7bedc4a494edc, 0x451f6a0000775385
d_4_26:         .dword 0x24f6b3c5c0e9ea51, 0x65629404262e9c88
d_4_27:         .dword 0x7cb937f38bca815c, 0x780832df09ac5476
                .dword 0xd5a7d1039acd4370, 0xccbd912f00810ad3
                .dword 0x3cf81ba98ae12240, 0xd7931be04dbd5135
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xed3ae64acfedb845, 0xd5aa2427066cd1c4
                .dword 0xb7ee1a1244d213e3, 0x100442763046f614
d_5_0:          .dword 0xc0d4559d0159b94e, 0x8e66464225a7b0ca
d_5_1:          .dword 0x9657582ac12897e0, 0xb34d54ba391e8054
d_5_2:          .dword 0x88705317cf588309, 0xb23182adadb6bb49
d_5_3:          .dword 0xec99f01b93d44fd3, 0xa2fb2cc2e2b25093
d_5_4:          .dword 0xfb1cf8f39a51fa13, 0x48bff9c5ecee0894
d_5_5:          .dword 0x69b9d0d6c8176a28, 0xa9e654814138bf87
d_5_6:          .dword 0xfe56546bb4ff034f, 0x3014d76c331d1393
d_5_7:          .dword 0xba532b393b994228, 0x016021386525318e
d_5_8:          .dword 0x2c94d94b7b379b73, 0xfb922273fea690f2
d_5_9:          .dword 0xaeb468226cf9659a, 0x008a6bbdd5b79975
d_5_10:         .dword 0x74bb54f166e71635, 0xdd9667f5bab78adb
d_5_11:         .dword 0x992add261699b3ca, 0x932c5dee0ab9398e
d_5_12:         .dword 0x1cf2e45b13f26826, 0x04007d4351dc517f
d_5_13:         .dword 0x82e55bea6ef2c1f8, 0x56e0e5936ae64ed0
d_5_14:         .dword 0x77975436e5683394, 0x7bc7823924f4b713
d_5_15:         .dword 0x70e44b9d83868937, 0xd6c7e9c99da8bd40
d_5_16:         .dword 0x2c5635f2bc4fb690, 0xe92d8ab0ac1dcf1c
d_5_17:         .dword 0xe812c07fe24368bb, 0xdf8c7d20990e2835
d_5_18:         .dword 0xb3bc9fc6960e2e66, 0x5ef4339653fe34d6
d_5_19:         .dword 0xb8d8f6a215324c2e, 0x193b4da9bbe189d4
d_5_20:         .dword 0x22e5517d078ecd43, 0x1493e1669337fc9d
d_5_21:         .dword 0x3835c97c2ede8739, 0x6698aa2bf1da3055
d_5_22:         .dword 0x5b6943346f1b2e12, 0xfd1dcc45cfda7aaf
d_5_23:         .dword 0x78b7b88b627d9e89, 0xa151d2244b6eeb5e
d_5_24:         .dword 0xbba94bf240d45436, 0x328b79915a4c6b6b
d_5_25:         .dword 0x1d3806bca054df04, 0x52c2cf1d9fd47cdf
d_5_26:         .dword 0x166d7510c62fb4e3, 0x94dcf7db58abf07b
d_5_27:         .dword 0x88555c675b078fdc, 0xdc1c97f3417c8d48
                .dword 0x4a014fc702ec1ad1, 0xb06991ac5f43e857
                .dword 0x10283bfa30951ea9, 0x15d85666db1c054c
         /* Random data */
_end_data5:
              
 
