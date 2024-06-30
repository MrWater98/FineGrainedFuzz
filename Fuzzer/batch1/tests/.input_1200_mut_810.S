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
_p0:    csrrwi x14, scause, 11                    ;
_p1:    csrrsi x14, pmpaddr6, 0                   ;
_p2:    csrrsi x14, satp, 31                      ;
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
_s0:    fcvt.lu.s x0, f22, rup                    ;
_s1:    la x16, d_1_10                            ;
        fsw f22, 4(x16)                           ;
_s2:;
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
_l0:    mulhu x21, x8, x30                        ;
_l1:    fcvt.s.l f16, x25, rmm                    ;
_l2:    slli x14, x15, 63                         ;
_l3:    fclass.s x27, f8                          ;
_l4:    la x30, _l104                                       ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l5:    la x8, d_3_3                              ;
        addi x8, x8, -0                           ;
        sc.w x20, x6, (x8)                        ;
_l6:    la x8, d_4_13                             ;
        sb x1, -31(x8)                            ;
_l7:    fdiv.s f19, f19, f19, dyn                 ;
_l8:    la x7, d_5_21                             ;
        addi x7, x7, 16                           ;
        amomaxu.d x6, x27, (x7)                   ;
_l9:    auipc x13, 471646                         ;
_l10:   srli x29, x22, 63                         ;
_l11:   mulhu x8, x8, x14                         ;
_l12:   la x22, d_5_2                             ;
        sw x6, -0(x22)                            ;
_l13:   mulhu x28, x28, x6                        ;
_l14:   ecall                                     ;
_l15:   la x12, d_1_12                            ;
        addi x12, x12, -16                        ;
        amomin.d x13, x11, (x12)                  ;
_l16:   fsgnjn.s f16, f5, f5                      ;
_l17:   fle.s x30, f18, f19                       ;
_l18:   la x24, d_3_11                            ;
        fsw f27, -16(x24)                         ;
_l19:   andi x17, x7, 2047                        ;
_l20:   divw x14, x13, x17                        ;
_l21:   fsgnj.s f29, f3, f31                      ;
_l22:   la x18, d_3_0                             ;
        addi x18, x18, 0                          ;
        amomaxu.d x14, x21, (x18)                 ;
_l23:   fsqrt.s f27, f12, rdn                     ;
_l24:   la x26, d_3_5                             ;
        addi x26, x26, -28                        ;
        amoor.w x23, x14, (x26)                   ;
_l25:   bgeu x6, x5, _l65                                 ;
_l26:   fsqrt.s f12, f29, rtz                     ;
_l27:   la x30, d_3_27                            ;
        addi x30, x30, 16                         ;
        amomin.d x21, x8, (x30)                   ;
_l28:   bne x5, x18, _l38                                 ;
_l29:   slti x25, x23, -1566                      ;
_l30:   la x8, d_5_12                             ;
        addi x8, x8, -16                          ;
        amomaxu.d x2, x12, (x8)                   ;
_l31:   fcvt.s.lu f16, x12, rne                   ;
_l32:   xor x10, x10, x10                         ;
        addi x24, zero, 3                         ;
        slli x24, x24, 14                         ;
        add x10, x10, x24                         ;
        addi x13, zero, 1                         ;
        slli x13, x13, 9                          ;
        add x10, x10, x13                         ;
        addi x15, zero, 1                         ;
        slli x15, x15, 31                         ;
        add x10, x10, x15                         ;
        csrrc x29, mepc, x10                      ;
_l33:   divuw x23, x8, x9                         ;
_l34:   fcvt.w.s x4, f13, rtz                     ;
_l35:   fadd.s f3, f15, f18, rmm                  ;
_l36:   fle.s x24, f30, f1                        ;
_l37:   bgeu x26, x20, _l87                               ;
_l38:   sltiu x0, x10, 15                         ;
_l39:   fence.i                                   ;
_l40:   slti x9, x13, 112                         ;
_l41:   la x10, _l87                                      ;
        csrrw zero, mepc, x10                     ;
        mret                                      ;
_l42:   fence                                     ;
_l43:   la x9, d_1_23                             ;
        addi x9, x9, -0                           ;
        lui x14, 0xffe00                          ;
        xor x9, x9, x14                           ;
        amomax.d x5, x14, (x9)                    ;
_l44:   la x10, d_5_19                            ;
        addi x10, x10, 24                         ;
        sc.w x23, x27, (x10)                      ;
_l45:   slli x24, x0, 15                          ;
_l46:   la x16, d_1_21                            ;
        addi x16, x16, 0                          ;
        amomin.d x8, x20, (x16)                   ;
_l47:   ebreak                                    ;
_l48:   slliw x30, x7, 20                         ;
_l49:   remuw x17, x10, x17                       ;
_l50:   la x8, d_0_20                             ;
        addi x8, x8, -16                          ;
        amoadd.w x5, x1, (x8)                     ;
_l51:   fnmsub.s f31, f25, f6, f8, rne            ;
_l52:   bgeu x15, x18, _l74                               ;
_l53:   csrrsi x16, pmpaddr6, 4                   ;
_l54:   la x1, _l72                               ;
        csrrw zero, mepc, x1                      ;
        mret                                      ;
_l55:   la x19, d_3_21                            ;
        lui x14, 0xffe00                          ;
        xor x19, x19, x14                         ;
        flw f29, -8(x19)                          ;
_l56:   fsgnj.s f14, f24, f20                     ;
_l57:   flt.s x28, f7, f6                         ;
_l58:   slli x24, x12, 28                         ;
_l59:   la x11, d_2_13                            ;
        addi x11, x11, -0                         ;
        amoxor.d x10, x27, (x11)                  ;
_l60:   remu x30, x18, x9                         ;
_l61:   la x13, d_1_24                            ;
        lh x8, -0(x13)                            ;
_l62:   fcvt.wu.s x25, f22, rup                   ;
_l63:   la x11, d_2_16                            ;
        lwu x11, 20(x11)                          ;
_l64:   fsgnjx.s f11, f3, f21                     ;
_l65:   fence.i                                   ;
_l66:   mulhu x6, x13, x1                         ;
_l67:   auipc x24, 477778                         ;
_l68:   sraiw x3, x11, 4                          ;
_l69:   mulhsu x29, x16, x24                      ;
_l70:   la x23, d_2_2                             ;
        addi x23, x23, 0                          ;
        amoswap.d x24, x31, (x23)                 ;
_l71:   la x27, d_4_24                            ;
        addi x27, x27, 16                         ;
        amoxor.d x12, x24, (x27)                  ;
_l72:   la x11, _l87                                      ;
        csrrw zero, uepc, x11                     ;
        uret                                      ;
_l73:   la x19, _l89                              ;
        csrrw zero, uepc, x19                     ;
        uret                                      ;
_l74:   remu x29, x28, x9                         ;
_l75:   mul x24, x16, x4                          ;
_l76:   fnmadd.s f31, f26, f6, f13, rup           ;
_l77:   divuw x24, x9, x22                        ;
_l78:   la x9, d_5_1                              ;
        lbu x19, 24(x9)                           ;
_l79:   sraiw x3, x26, 4                          ;
_l80:   ori x6, x18, -104                         ;
_l81:   la x7, d_2_22                             ;
        addi x7, x7, -24                          ;
        amomax.d x28, x4, (x7)                    ;
_l82:   la x29, d_2_23                            ;
        addi x29, x29, 28                         ;
        amomax.w x24, x10, (x29)                  ;
_l83:   csrrci x14, mtval, 31                     ;
_l84:   la x19, d_3_21                            ;
        srai x19, x19, 1                          ;
        csrrc x10, pmpaddr3, x19                  ;
_l85:   la x8, d_1_23                             ;
        lwu x26, -0(x8)                           ;
_l86:   fnmadd.s f31, f7, f1, f8, rup             ;
_l87:   remw x16, x1, x29                         ;
_l88:   bge x23, x29, _l96                        ;
_l89:   la x9, d_4_1                              ;
        sb x29, -6(x9)                            ;
_l90:   la x28, d_4_26                            ;
        addi x28, x28, -16                        ;
        amoswap.w x21, x8, (x28)                  ;
_l91:   csrrsi x26, satp, 27                      ;
_l92:   la x5, d_0_9                              ;
        lw x12, -8(x5)                            ;
_l93:   fsgnj.s f21, f26, f19                     ;
_l94:   la x6, _l112                              ;
        csrrw zero, mepc, x6                      ;
        mret                                      ;
_l95:   la x6, _l117                                      ;
        csrrw zero, mepc, x6                      ;
        mret                                      ;
_l96:   sraiw x30, x22, 0                         ;
_l97:   la x20, d_4_6                             ;
        flw f10, 8(x20)                           ;
_l98:   fsub.s f7, f21, f28, rdn                  ;
_l99:   la x5, d_3_17                             ;
        addi x5, x5, -8                           ;
        lr.w x6, (x5)                             ;
_l100:  bltu x8, x17, _l109                               ;
_l101:  slti x24, x11, 785                        ;
_l102:  la x10, d_5_13                            ;
        lui x26, 0xffe00                          ;
        xor x10, x10, x26                         ;
        flw f16, -16(x10)                         ;
_l103:  sllw x0, x24, x16                         ;
_l104:  la x15, _l107                                     ;
        csrrw zero, sepc, x15                     ;
        sret                                      ;
_l105:  jal x28, _l107                                    ;
_l106:  la x15, _l112                                     ;
        csrrw zero, sepc, x15                     ;
        sret                                      ;
_l107:  csrrwi x21, sstatus, 25                   ;
_l108:  fcvt.s.l f22, x29, rmm                    ;
_l109:  xori x26, x0, 940                         ;
_l110:  la x18, d_2_6                             ;
        lb x12, 20(x18)                           ;
_l111:  la x8, d_3_12                             ;
        sd x27, 8(x8)                             ;
_l112:  la x6, d_0_16                             ;
        addi x6, x6, -0                           ;
        lr.d x4, (x6)                             ;
_l113:  la x27, d_1_25                            ;
        addi x27, x27, 16                         ;
        amoand.w x6, x6, (x27)                    ;
_l114:  flt.s x8, f18, f1                         ;
_l115:  flt.s x3, f25, f22                        ;
_l116:  fsub.s f22, f28, f20, rtz                 ;
_l117:  ori x1, x3, 1426                          ;
_l118:  mulh x0, x13, x13                         ;
_l119:;
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
                .dword 0xde68c3d60740e642, 0xdf6173adc90c38e8
                .dword 0xf9961d7018ae3e01, 0x87f90686b4a818aa
d_0_0:          .dword 0x400fe2342721522a, 0x159b9e0585a6b065
d_0_1:          .dword 0x8ae8360047f8083a, 0x7e4a37d0a27685bf
d_0_2:          .dword 0xe005491c083b6fad, 0x5b34b266c03b3b17
d_0_3:          .dword 0xf53484c7bb9e6621, 0xfb2d346f8ce12302
d_0_4:          .dword 0x2ffdcff7ee7d8e43, 0x85e5b78024e0fa84
d_0_5:          .dword 0x16fe4810602f543d, 0xc92739fd3e7a85d0
d_0_6:          .dword 0x4e3b94040dbfd24f, 0xaeeb8b30e8e7063a
d_0_7:          .dword 0xda14717f586f5cd8, 0x3e1d04b719aa272d
d_0_8:          .dword 0xed2169817dce257e, 0xcb061ce263560f83
d_0_9:          .dword 0x63be69bce54c7956, 0x4e28ad3343741576
d_0_10:         .dword 0x48f3af96448c8485, 0xf0dfabe9ab47fb24
d_0_11:         .dword 0x6eaff9dc56ac578c, 0xd840747e6326f589
d_0_12:         .dword 0xfa8b30e7ee75e0fb, 0x99143aa8f078fef0
d_0_13:         .dword 0x13dd1d9e3cea7f92, 0xb43717c4a7250c0a
d_0_14:         .dword 0xf08a0c8e59feac06, 0xb1144875a2ecfada
d_0_15:         .dword 0x084a8d54787187e1, 0xd94204ef46f4f239
d_0_16:         .dword 0xa43582a0e7d74ccb, 0xadccf4cd76725251
d_0_17:         .dword 0x26ca8e0363b7041b, 0x3275e870eb31a692
d_0_18:         .dword 0x694e3d05d5f93a42, 0x00f57ecd5da100f7
d_0_19:         .dword 0x8bf5c4b10e86891a, 0x3ae3876ca06d0140
d_0_20:         .dword 0x2c27c260b70b072f, 0xc355a555cbbec145
d_0_21:         .dword 0xb0ef7e7755bc8920, 0xa88807f6c46f4b85
d_0_22:         .dword 0x14fad91f8ec142d1, 0x10a4abc5760e2a6b
d_0_23:         .dword 0x916583457c8cd996, 0x72ee07bdc516f1c5
d_0_24:         .dword 0x62ff7d04cb1605c3, 0xf9b41f6f734995e1
d_0_25:         .dword 0x77d3f5c5ad4d389c, 0x111b7e7c0fc4db1b
d_0_26:         .dword 0xf445531018ccb27d, 0x3f714d2ff0de3d1a
d_0_27:         .dword 0x44ae4c41d5a6de82, 0xce007a07be8b46a2
                .dword 0x02943f8bbe07fa5b, 0xc2c201433a031709
                .dword 0x902522c5f21502f8, 0x037863f8de6fe945
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x0adb98dd023156eb, 0x5ff9be3bd75ae671
                .dword 0xe278f8e80cc44229, 0x9d8cf32a9dfafb6d
d_1_0:          .dword 0xa1f03350a0c37c6d, 0x90e61f93c72c7084
d_1_1:          .dword 0x516b01a15e295426, 0xe0e61e427df9c1bb
d_1_2:          .dword 0x4e8c24821ab18c7d, 0x851e9954507da9f9
d_1_3:          .dword 0x1c15d8db026e95f7, 0xb017f72793c214ca
d_1_4:          .dword 0x8a4220197261ed54, 0x05a296d734e5895c
d_1_5:          .dword 0x1e1a14f28aacca4a, 0x784c7ec9a272b6f7
d_1_6:          .dword 0x6352de9c71fcb507, 0x044318727706e006
d_1_7:          .dword 0xa1fb89ce5dde64f6, 0x13f9a1c256a8a10c
d_1_8:          .dword 0x00fd738a17883cae, 0x0809b5e40cb30c1e
d_1_9:          .dword 0xe115c7b931ea7a4b, 0xbf36bb53f575c15c
d_1_10:         .dword 0x0e99227d11f0bfc2, 0x3b88a1f40c79f16c
d_1_11:         .dword 0x353584d644825464, 0x1d5b935c4678f90d
d_1_12:         .dword 0x09ab6125527c7a3b, 0xf1f949d3031941b2
d_1_13:         .dword 0x4a3bb64bbb810dd1, 0xfa4e2b244aa5bb54
d_1_14:         .dword 0x463b016ea2086e1e, 0x9bf38cdb982481e6
d_1_15:         .dword 0x4e1af5eb0571c324, 0xfa11a6fc0aed1217
d_1_16:         .dword 0xe2fe9f83460df612, 0x578fc0bbe5ceafff
d_1_17:         .dword 0x442ea7f830e842f4, 0xbb907a7ef7c381be
d_1_18:         .dword 0x418eb80d9e70e3fc, 0x7329c1ac3a3145bf
d_1_19:         .dword 0x4ca4f1bb39279460, 0x8ed1221a27932e0d
d_1_20:         .dword 0x250b2f09abb3a8bc, 0x5b6db822ed8912eb
d_1_21:         .dword 0x90a74d11d2b4b8dd, 0xd56b57a5129f2e14
d_1_22:         .dword 0x3ff0c3ef4fe1dad0, 0xc8f3ff378470b2c5
d_1_23:         .dword 0x78ad04051eb09ae8, 0x7126d40a5b81fb92
d_1_24:         .dword 0xf06f6e7e9d6057df, 0x239d3d4f1f9bd32d
d_1_25:         .dword 0x21374a236aa71f10, 0x7e73f15aeba98035
d_1_26:         .dword 0x44b4a64f7611b610, 0xb8384ff40b2c952a
d_1_27:         .dword 0x3975f82ce639dec3, 0x69e7506d8893360c
                .dword 0xf1049cef8303b4a2, 0xc202e203bf636ea9
                .dword 0x081786c9d890b852, 0x2c9d66e703768d65
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xdf819ea55528bf20, 0xdfd881a0ead786c0
                .dword 0xd8db86217f2910e5, 0xb27069a05cb4922c
d_2_0:          .dword 0xc7ed63167a5b914d, 0xd52d5163796840a5
d_2_1:          .dword 0xedc08ce4203db40b, 0x1cceff457e7ab548
d_2_2:          .dword 0x5fc8b7775c28739e, 0xaf431dbfc0dd8701
d_2_3:          .dword 0x0fbade08ecabb1d3, 0xdb61a8d7954c5a4e
d_2_4:          .dword 0x9f599c847c082aa3, 0x95dbd9c5ad531837
d_2_5:          .dword 0x6f24fbb2007f7202, 0x5ce850bf83c32544
d_2_6:          .dword 0x4b22c9100dc87308, 0x1a3b01bf6431809a
d_2_7:          .dword 0x978aa86ad9123018, 0x0a71644de73172fb
d_2_8:          .dword 0x813fb77738f52c1b, 0x0baa3978628ab8c6
d_2_9:          .dword 0xa8a96dc419de7fb3, 0x9efe29119600aa71
d_2_10:         .dword 0xeaa51d7c7788181a, 0xb6e8073081fbbf26
d_2_11:         .dword 0x43249c3c755be90a, 0xbaafd95d8e2ae98d
d_2_12:         .dword 0x62714ab379a8ef7a, 0xbe81cb176be1a43f
d_2_13:         .dword 0xebbe9215a4b97f82, 0x06b1442430240b58
d_2_14:         .dword 0x289a076040e47d2c, 0xe077a4a32a69cffb
d_2_15:         .dword 0x4b191f4d6e632f59, 0x7750071c754cf16f
d_2_16:         .dword 0xaa0bc68ff3e6e5ca, 0x9d56ff673fd7986c
d_2_17:         .dword 0xb6c461b25e8fc896, 0x7971da09f64c4392
d_2_18:         .dword 0xbcbd443847f637a2, 0xc591e3696367e4f0
d_2_19:         .dword 0xd64c699f09e1f1c2, 0xf880cf23e74a44c2
d_2_20:         .dword 0x61f09eb461b9d733, 0x8297daf2d4ef5f00
d_2_21:         .dword 0x8f8ac936c93ff945, 0x0f0bd5a206e72e50
d_2_22:         .dword 0xae47a7bc7653b59d, 0xcd465a99420c15b9
d_2_23:         .dword 0x13e247254870e1e9, 0x79398c4d741c36cc
d_2_24:         .dword 0xde8322fe1df4e352, 0x46b9a5068b234257
d_2_25:         .dword 0x92662a1f1612353b, 0xf46ba088b5a7c2b2
d_2_26:         .dword 0x28ba67a3b83b7c4f, 0xf540aaa9893ca988
d_2_27:         .dword 0x7102ecd7c5bbc094, 0x5ca9cc9b5334a63e
                .dword 0xe22e7a72db12de9e, 0x14d5d06b92bedf97
                .dword 0xdefad14ad5ffbc3b, 0x74ab7bf7bd8e2187
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x65a2a92696cbe332, 0x8d12b2c947819634
                .dword 0x4b5bddccfdfbd513, 0xe8a69a6ac2eb46f4
d_3_0:          .dword 0x79f93b38cca7acf5, 0x88fa3f1da5ae8d06
d_3_1:          .dword 0xdbcf42384663bb04, 0x791597636b6a9565
d_3_2:          .dword 0xbfaf4c9012105609, 0xcb86abc2ac9dba0e
d_3_3:          .dword 0xf23dd27a9c913f70, 0x081cf4444b485f26
d_3_4:          .dword 0x7d86fcf8812622cf, 0xeba005bc6967a596
d_3_5:          .dword 0xc5b61c41e858b19f, 0x559742d9682431b8
d_3_6:          .dword 0xfc22c266318eb5bb, 0x77ee82144523d96b
d_3_7:          .dword 0x5794095b0e36db41, 0x7186b734faf0c706
d_3_8:          .dword 0x7cb0d2de2eef1dd4, 0x9ea143be97688baf
d_3_9:          .dword 0x4c88b8caf8cb0e91, 0x4fc81f1c3e4ab326
d_3_10:         .dword 0x674c78a1e338fbb2, 0x80981d7382f73c8b
d_3_11:         .dword 0x82387f1e8cb0dc5b, 0x04f6a310023fe694
d_3_12:         .dword 0x50e85b43961bb0e9, 0x1d5583d5f5a6826a
d_3_13:         .dword 0xa3292128287e4e42, 0xbbb89f582d2590eb
d_3_14:         .dword 0x7780404900c2ce6f, 0x8be39672fe347216
d_3_15:         .dword 0x7002d5e522245367, 0xa2960e4d4983a381
d_3_16:         .dword 0xb922a44e73271403, 0x7ed707d33fee4c0a
d_3_17:         .dword 0xb6bee081482c4504, 0x58f2b9ced2985965
d_3_18:         .dword 0x97844ccba36b768d, 0x2dce73b1d78585c0
d_3_19:         .dword 0x94cf3753fbce029f, 0x3b34f20cc007e83f
d_3_20:         .dword 0xd68e4cec387ce1f4, 0x00230b0e05629cea
d_3_21:         .dword 0x00ddcc5da8c2f754, 0xcdfccac6a104aebf
d_3_22:         .dword 0x9b358c9b4e07e715, 0xef405d7514642c73
d_3_23:         .dword 0xa1ddd2dd441975db, 0x964dc45696f6d457
d_3_24:         .dword 0xbaf8d181aa0fe07a, 0x9153918340f967ad
d_3_25:         .dword 0x747ab193901db5ff, 0x1935d1c3c601b5a7
d_3_26:         .dword 0x7a894688a38fcfc3, 0xd98b38fff3f15103
d_3_27:         .dword 0xd6ec316b259aecaf, 0xd8483f6f982f5bba
                .dword 0x6e7f6f6355d2d185, 0xd6df6b6d603ab864
                .dword 0x58a4931ad314138e, 0x1b06c81c0a7b225c
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x503cd26cbc3795fc, 0xa3df945ee2dcecee
                .dword 0xcaa19dd1e45b6cb6, 0x9ce0b0d107b6d5fe
d_4_0:          .dword 0xe795ba651298516e, 0x5952673f9ed26e32
d_4_1:          .dword 0x8f7163654329e5aa, 0x283004e151893a28
d_4_2:          .dword 0x7ba6d77eaefdc97c, 0x17b1580c50af094e
d_4_3:          .dword 0x4904e564a11b330c, 0x93ed5cb3953cfce9
d_4_4:          .dword 0xc1f82b2c341c2e8f, 0xf7e26d6c4f2bf61b
d_4_5:          .dword 0x6fb3174579b95842, 0x4676604212347628
d_4_6:          .dword 0x4d322a79f04cb74f, 0x84ad3a27d57131dd
d_4_7:          .dword 0x04acb7c648b2f06e, 0x1466d4c157ad5a55
d_4_8:          .dword 0x4684c4aff97d6b43, 0x78d1edd547bafce7
d_4_9:          .dword 0x8db63083e7d43033, 0x060db6bbfb1b1e7f
d_4_10:         .dword 0x5873c111ab8d87d5, 0xb5b2070396390db6
d_4_11:         .dword 0x34acf1d478f7fe70, 0xf2e9ab8553289d95
d_4_12:         .dword 0x908915612fed13ef, 0x2025115e7624e15c
d_4_13:         .dword 0x08f08d620b0a0988, 0xe4718f43573f6ccc
d_4_14:         .dword 0xda05608bf7384635, 0x43887915ebf71101
d_4_15:         .dword 0xd74599930f303d02, 0xfc8da57a422ea73e
d_4_16:         .dword 0x6e3538c303b90eb0, 0xab8348e9c44734f8
d_4_17:         .dword 0xefa00488a4e95398, 0xa449992e587533b3
d_4_18:         .dword 0x0b855d8d6c6223d4, 0xceef46a3ba7967a1
d_4_19:         .dword 0xe2188be9836f82a7, 0xc9012d8fb39b0cf4
d_4_20:         .dword 0xf112e6a5c07fc9ca, 0xbaf3deb8d4bc5c3d
d_4_21:         .dword 0xab523b5c24f90b24, 0x66d695eaeb70c475
d_4_22:         .dword 0x2750d09ff3d56338, 0x3a1d8ec3fa39c85f
d_4_23:         .dword 0xc9b46f0c0235ea43, 0xcac38d6e2b1a079d
d_4_24:         .dword 0x49affff215bc34d0, 0xeb92dbbc116ad137
d_4_25:         .dword 0x98887ee19f85c53c, 0x71ed065a945420e7
d_4_26:         .dword 0x4de8324035537e31, 0xe857af71632d472d
d_4_27:         .dword 0x504f43448f033054, 0xc23f8990479bf7bb
                .dword 0xa56996d9533ac473, 0xaff20568e9a0a143
                .dword 0x615b8b97c74a5ccc, 0x5c21af14d16b5cb5
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xc5ec0cdcfed64bb9, 0x9a164eaed6909b7e
                .dword 0x874224e1d3e86479, 0x6c08158ba93ec2ca
d_5_0:          .dword 0x921a54cc74ed24ca, 0x391a2e07870e3c47
d_5_1:          .dword 0x0568f7c0c7079f82, 0x3002420f683cccd7
d_5_2:          .dword 0x995bc7ea1238a6c7, 0x0d31e4bd0cdbc837
d_5_3:          .dword 0xbdd4e40c8e2e45f8, 0xf8061ee0e67fda41
d_5_4:          .dword 0x4a8f09f08699807f, 0x6ab3cb57d50f70c7
d_5_5:          .dword 0xa5bbb8f360b8dfaa, 0x4eb2724a12a13e12
d_5_6:          .dword 0x26ca99ba0f7fc9af, 0xc400bb9de9ee934b
d_5_7:          .dword 0x6a1ee40ebaf0d0ff, 0x5017d7a4e3e9b879
d_5_8:          .dword 0x645697ed9258e806, 0x934815d80c70560a
d_5_9:          .dword 0x549338334da0dbe1, 0xcf46a95cec6fe68e
d_5_10:         .dword 0x76b536f78ccee511, 0xcab849c31cd97f34
d_5_11:         .dword 0xe2fd40e663f25f73, 0x48ff2c1fca5dfb20
d_5_12:         .dword 0xc11bf4c3effe50f6, 0x7afb3135fc9c5960
d_5_13:         .dword 0x5213294d253e511a, 0x615e1af06cbacb77
d_5_14:         .dword 0xe4e8eba57e51c5be, 0x8f192ee0c03e0072
d_5_15:         .dword 0x2d716230e592d4ad, 0xd82388fca78afd75
d_5_16:         .dword 0xe6990c94ee2c3af5, 0x1708c3965d423f99
d_5_17:         .dword 0x5faa985dbb03ea33, 0x6d5745444a2b57ce
d_5_18:         .dword 0x99d2f7e1fabc2743, 0xe6b00472b0755083
d_5_19:         .dword 0x0f78fc0cacf731aa, 0xfb028aae087ca3d3
d_5_20:         .dword 0x46e7004173d37cf0, 0x405ef7f13f7f728b
d_5_21:         .dword 0x68b661f21f4d4f1d, 0xf36c28afcf1a891a
d_5_22:         .dword 0x1cdb8d871345064d, 0x8c226d4a9107b72a
d_5_23:         .dword 0x95397a80db897c03, 0x4df319052dce760e
d_5_24:         .dword 0xc49842c4796a5e11, 0x24e3473e903da0b4
d_5_25:         .dword 0x78791e58e952209a, 0x729493ff9c1642fb
d_5_26:         .dword 0x6a483b498f4611d8, 0x2ff7eed8ed0c5f0f
d_5_27:         .dword 0x59aa80214d5ba0e5, 0x5bfda7b4e4898f21
                .dword 0x49678b06ce26a49f, 0x9dada58b862daa78
                .dword 0xad5364fcf6a582dc, 0xb2408d6c25f23d70
         /* Random data */
_end_data5:
              
 
