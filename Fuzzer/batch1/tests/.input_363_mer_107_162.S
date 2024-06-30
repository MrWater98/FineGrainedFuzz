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
_p0:    csrrsi x10, satp, 31                      ;
_p1:    csrrwi x10, pmpaddr6, 31                  ;
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
_s0:    flt.s x25, f13, f14                       ;
_s1:    la x21, d_0_23                            ;
        addi x21, x21, -4                         ;
        amomaxu.w x9, x23, (x21)                  ;
_s2:    la x19, d_0_27                            ;
        lbu x14, 18(x19)                          ;
_s3:    fcvt.lu.s x12, f13, rdn                   ;
_s4:    fsgnjn.s f18, f2, f22                     ;
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
_l0:    la x6, d_3_6                              ;
        addi x6, x6, -8                           ;
        lr.d x23, (x6)                            ;
_l1:    mulh x20, x4, x19                         ;
_l2:    fnmadd.s f18, f6, f6, f6, dyn             ;
_l3:    bge x23, x17, _l23                                ;
_l4:    sltiu x2, x4, -1255                       ;
_l5:    la x6, d_3_6                              ;
        sb x27, 10(x6)                            ;
_l6:    la x30, d_0_5                             ;
        addi x30, x30, 0                          ;
        amoor.d x29, x18, (x30)                   ;
_l7:    bltu x15, x30, _l45                               ;
_l8:    divw x16, x13, x1                         ;
_l9:    fcvt.l.s x7, f5, rtz                      ;
_l10:   fnmadd.s f27, f10, f25, f18, rne          ;
_l11:   la x24, d_4_25                            ;
        flw f25, -20(x24)                         ;
_l12:   fmv.w.x f29, x29                          ;
_l13:   mulh x1, x12, x9                          ;
_l14:   srlw x16, x23, x19                        ;
_l15:   sraw x18, x6, x26                         ;
_l16:   remw x10, x26, x22                        ;
_l17:   mul x30, x28, x12                         ;
_l18:   la x27, d_4_24                            ;
        addi x27, x27, -28                        ;
        amoxor.w x27, x4, (x27)                   ;
_l19:   la x27, d_1_24                            ;
        addi x27, x27, 20                         ;
        amoadd.w x28, x11, (x27)                  ;
_l20:   la x22, d_1_7                             ;
        sw x27, -12(x22)                          ;
_l21:   csrrwi x24, scause, 15                    ;
_l22:   la x9, d_0_17                             ;
        sh x26, 20(x9)                            ;
_l23:   la x26, d_3_26                            ;
        addi x26, x26, -24                        ;
        amoswap.w x22, x26, (x26)                 ;
_l24:   bgeu x18, x10, _l46                               ;
_l25:   divu x30, x11, x26                        ;
_l26:   la x5, d_3_4                              ;
        addi x5, x5, -0                           ;
        sc.w x1, x30, (x5)                        ;
_l27:   li x1, 1                                  ;
        la x5, pt1                                ;
        addi x5, x5, 0                            ;
        sfence.vma x1, x5                         ;
_l28:   slliw x21, x26, 29                        ;
_l29:   fmv.w.x f10, x2                           ;
_l30:   mulhu x24, x18, x25                       ;
_l31:   addi x13, x26, 615                        ;
_l32:   la x2, d_1_0                              ;
        lui x13, 0xffe00                          ;
        xor x2, x2, x13                           ;
        lw x27, -0(x2)                            ;
_l33:   remu x7, x7, x10                          ;
_l34:   bne x9, x2, _l71                          ;
_l35:   mulw x28, x2, x30                         ;
_l36:   la x27, d_4_6                             ;
        addi x27, x27, 0                          ;
        amoadd.d x6, x9, (x27)                    ;
_l37:   fcvt.l.s x26, f25, rmm                    ;
_l38:   la x8, d_3_6                              ;
        addi x8, x8, -8                           ;
        amoswap.d x22, x10, (x8)                  ;
_l39:   la x3, d_2_0                              ;
        addi x3, x3, 12                           ;
        amoxor.w x9, x17, (x3)                    ;
_l40:   la x2, d_2_1                              ;
        lh x13, 6(x2)                             ;
_l41:   fsqrt.s f26, f26, rtz                     ;
_l42:   bge x13, x14, _l69                        ;
_l43:   srai x1, x28, 15                          ;
_l44:   fcvt.l.s x16, f0, dyn                     ;
_l45:   fsgnjn.s f4, f29, f20                     ;
_l46:   la x20, d_2_2                             ;
        addi x20, x20, 24                         ;
        sc.d x20, x20, (x20)                      ;
_l47:   srlw x15, x15, x28                        ;
_l48:   la x10, d_3_16                            ;
        addi x10, x10, 0                          ;
        amomin.d x21, x1, (x10)                   ;
_l49:   la x27, _l59                                      ;
        lhu x21, -18(x27)                         ;
_l50:   la x18, d_2_8                             ;
        addi x18, x18, 16                         ;
        lui x27, 0xffe00                          ;
        xor x18, x18, x27                         ;
        amoor.w x12, x27, (x18)                   ;
_l51:   csrrci x6, mie, 10                        ;
_l52:   ebreak                                    ;
_l53:   la x21, _l99                              ;
        csrrw zero, mepc, x21                     ;
        mret                                      ;
_l54:   auipc x2, 188919                          ;
_l55:   la x14, d_2_18                            ;
        lwu x14, 28(x14)                          ;
_l56:   fle.s x11, f0, f6                         ;
_l57:   sltiu x22, x3, 1240                       ;
_l58:   bge x28, x17, _l64                                ;
_l59:   divu x11, x1, x10                         ;
_l60:   addi x28, x25, -969                       ;
_l61:   la x16, _l74                              ;
        csrrw zero, uepc, x16                     ;
        uret                                      ;
_l62:   div x18, x5, x8                           ;
_l63:   la x6, d_1_6                              ;
        addi x6, x6, 12                           ;
        lr.w x17, (x6)                            ;
_l64:   xor x28, x28, x28                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 31                         ;
        add x28, x28, x14                         ;
        addi x30, zero, 1                         ;
        slli x30, x30, 8                          ;
        add x28, x28, x30                         ;
        addi x18, zero, 3                         ;
        slli x18, x18, 10                         ;
        add x28, x28, x18                         ;
        csrrw x10, mepc, x28                      ;
_l65:   fmv.x.w x17, f23                          ;
_l66:   beq x22, x13, _l101                       ;
_l67:   la x4, _l71                                       ;
        jalr x27, 0(x4)                           ;
_l68:   sraiw x10, x2, 22                         ;
_l69:   fcvt.wu.s x20, f18, rne                   ;
_l70:   fmsub.s f18, f6, f15, f13, rup            ;
_l71:   slli x2, x3, 5                            ;
_l72:   sltiu x13, x12, 657                       ;
_l73:   srliw x18, x4, 31                         ;
_l74:   la x23, d_1_16                            ;
        addi x23, x23, -16                        ;
        lr.d x13, (x23)                           ;
_l75:   fmsub.s f9, f9, f1, f28, rmm              ;
_l76:   beq x10, x8, _l86                                 ;
_l77:   fsgnjx.s f31, f4, f30                     ;
_l78:   la x26, d_2_20                            ;
        addi x26, x26, -12                        ;
        amoand.w x5, x18, (x26)                   ;
_l79:   feq.s x27, f2, f18                        ;
_l80:   la x7, d_4_9                              ;
        addi x7, x7, 28                           ;
        amoand.w x7, x30, (x7)                    ;
_l81:   srlw x7, x28, x8                          ;
_l82:   la x14, d_1_6                             ;
        flw f5, -4(x14)                           ;
_l83:   divuw x21, x20, x30                       ;
_l84:   fle.s x5, f21, f30                        ;
_l85:   addw x18, x14, x17                        ;
_l86:   la x4, d_1_16                             ;
        lhu x25, -10(x4)                          ;
_l87:   mul x12, x17, x30                         ;
_l88:   ori x5, x2, 814                           ;
_l89:   la x27, d_4_2                             ;
        addi x27, x27, 16                         ;
        amomax.w x11, x27, (x27)                  ;
_l90:   xor x24, x24, x24                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 28                         ;
        add x24, x24, x10                         ;
        csrrs x4, mcause, x24                     ;
_l91:   la x8, d_1_5                              ;
        addi x8, x8, -12                          ;
        lr.w x23, (x8)                            ;
_l92:   bne x30, x30, _l98                                ;
_l93:   la x30, d_2_21                            ;
        sh x4, -0(x30)                            ;
_l94:   la x19, d_2_27                            ;
        addi x19, x19, -24                        ;
        amoswap.d x3, x17, (x19)                  ;
_l95:   divu x4, x16, x0                          ;
_l96:   la x3, d_2_26                             ;
        addi x3, x3, 8                            ;
        amomaxu.w x28, x13, (x3)                  ;
_l97:   la x18, d_3_5                             ;
        addi x18, x18, 0                          ;
        amominu.d x19, x7, (x18)                  ;
_l98:   mulhsu x3, x22, x7                        ;
_l99:   la x13, _l111                             ;
        csrrw zero, mepc, x13                     ;
        mret                                      ;
_l100:  fmv.x.w x21, f13                          ;
_l101:  fdiv.s f27, f2, f2, rtz                   ;
_l102:  remw x0, x17, x21                         ;
_l103:  la x7, d_5_6                              ;
        flw f29, 4(x7)                            ;
_l104:  fmax.s f31, f21, f4                       ;
_l105:  la x30, d_3_9                             ;
        addi x30, x30, 8                          ;
        amomaxu.d x13, x9, (x30)                  ;
_l106:  flt.s x9, f8, f8                          ;
_l107:  la x2, d_1_1                              ;
        addi x2, x2, -16                          ;
        sc.w x2, x15, (x2)                        ;
_l108:  la x19, d_2_12                            ;
        addi x19, x19, -16                        ;
        sc.d x21, x19, (x19)                      ;
_l109:  srli x22, x4, 56                          ;
_l110:  la x25, d_0_1                             ;
        addi x25, x25, 28                         ;
        amominu.w x22, x17, (x25)                 ;
_l111:  addiw x9, x13, -1                         ;
_l112:  fsqrt.s f2, f8, rne                       ;
_l113:;
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
                .dword 0x40cfdc542e3f1ebb, 0xe390c0c0fc5f3302
                .dword 0x5eec22df08bb0685, 0x813c2e09e8a52616
d_0_0:          .dword 0x80200be48d9424f9, 0x9da221af2282e7de
d_0_1:          .dword 0xb281afd986d3f8d7, 0xe92a81d8ee68f06d
d_0_2:          .dword 0xaf4a38f326e57dd5, 0x40c226173e0ad52d
d_0_3:          .dword 0xc9fca7cc16002044, 0x4556228f41f3a61a
d_0_4:          .dword 0xe5216686d5b0390e, 0x2bbab11271f6f321
d_0_5:          .dword 0x1034fa0fa252cd71, 0x564a6b2bba70e19b
d_0_6:          .dword 0xcef84e89c9c3f98c, 0x67921d8125fe8557
d_0_7:          .dword 0x8ad49d54d45870be, 0xdfec36eb6e5772ac
d_0_8:          .dword 0x8eecbff0a860cc5b, 0xa655c335e6f0f200
d_0_9:          .dword 0xdd3c9eb4ab700100, 0xd15751888a4488b9
d_0_10:         .dword 0x50af62cdb7d6f9f4, 0x7f84f7dabd22d628
d_0_11:         .dword 0x710e16eb3bc77112, 0xa7004e3878e6010a
d_0_12:         .dword 0xfa0063497cb704e7, 0xaed42bc04fb36ad0
d_0_13:         .dword 0x0ddab060c6c024fd, 0x683121ba6c160b3f
d_0_14:         .dword 0x0496e6d8ed38e09d, 0xa616afc1ca21ebe5
d_0_15:         .dword 0x8a530020d5069c65, 0x7ec827127c023fc0
d_0_16:         .dword 0x3e9bdbf4b907fd06, 0xe20a942141f5f0a7
d_0_17:         .dword 0xa2d162a16f638cf0, 0x276b9441bac64f79
d_0_18:         .dword 0xa27180d25e22a547, 0x356a85205d4c3893
d_0_19:         .dword 0xc46c597b55b7ea06, 0xa3a10b9a7d4bd484
d_0_20:         .dword 0xdc903d4c75e03ae4, 0x91cf030401a803a4
d_0_21:         .dword 0xdca03ac93b3d2e03, 0xc2667592313e811f
d_0_22:         .dword 0xd21a1c143c6af691, 0x45d0b00cecd17cf9
d_0_23:         .dword 0x58ba2e3bfea04f4e, 0xf78287e36807993e
d_0_24:         .dword 0x3cfa54fe036ca9be, 0xc1b551a9bab29624
d_0_25:         .dword 0xbad0e28e4e8fc61f, 0x7bd39219cb609c31
d_0_26:         .dword 0xebf7dc3d2d856fb8, 0xed8eb4bd0bb8e8b5
d_0_27:         .dword 0xcd61aba4a4ef5ef9, 0x7c19ee317a501119
                .dword 0xa635816e6d1e27d4, 0xc4aed48908202758
                .dword 0x1d4dd4dea84c1b4d, 0x3c13a8ae8c7e1171
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xbfe31d29c5372c43, 0x3ebfbe536191a2be
                .dword 0x0c0bcccda86bc104, 0x8f45b48da7b551ca
d_1_0:          .dword 0x5ad84f42d0b8807b, 0x75711f24bf5e32de
d_1_1:          .dword 0xe290ab1b860ae4c4, 0x5e34ff7558d62c53
d_1_2:          .dword 0x942e6083594ed337, 0x52f2a8651e7ca48d
d_1_3:          .dword 0xa2328d8297c54092, 0x81f9ba852bc9fa67
d_1_4:          .dword 0x7373f57de71c0262, 0xe43d2df36912260a
d_1_5:          .dword 0xd31794c9d3b0614c, 0xe3496b2abfa92851
d_1_6:          .dword 0x08ee636879107120, 0xb13106c5f70d076f
d_1_7:          .dword 0x24d4023e3a70ee84, 0xf0fe7161b1b48ae5
d_1_8:          .dword 0xa0968af397f45d0a, 0xc57f30f4831d155d
d_1_9:          .dword 0x6188640305fd9b96, 0x1bbbeca1df53cc76
d_1_10:         .dword 0xbb3b6b5478bfb9d1, 0x5004f18e3c4bd89a
d_1_11:         .dword 0x8f5cf07509a7f1f4, 0xc66ac2c1b755f657
d_1_12:         .dword 0xeff384fa7b75fc47, 0x8675f633db15ac0c
d_1_13:         .dword 0xa639aac3fc17ce74, 0xb62507f6aa5d2c46
d_1_14:         .dword 0x6d67a76483d7d71c, 0x87abedcfe9ff116e
d_1_15:         .dword 0x833854d66b19360c, 0x863a81d2fa3ff8af
d_1_16:         .dword 0xbeb19abdfaeded77, 0x9fb577fe039e32fe
d_1_17:         .dword 0x923a43e81e6ca4c0, 0x21c225596caca06d
d_1_18:         .dword 0x6596c0b57d68e4b4, 0x09e3781c82c8113a
d_1_19:         .dword 0x2be1902850b3eb65, 0xd72fdc84ef12248e
d_1_20:         .dword 0xc3def273476d1520, 0xdcf3e4cb8182d199
d_1_21:         .dword 0x37f460d9fbabfb67, 0x669570e6b4c43103
d_1_22:         .dword 0x2efb3518d2462e9e, 0x7990ff8e1ca30a45
d_1_23:         .dword 0xf1354339d231fdd3, 0xabb55d92281fd447
d_1_24:         .dword 0x1af0de21fbbbd749, 0x44e44ddf83af6887
d_1_25:         .dword 0x57b6f9d0659b6dba, 0xb22cc749705e70ef
d_1_26:         .dword 0x74d62cd395966f8b, 0x6b08eb4096b75b26
d_1_27:         .dword 0xa4215d5cc21c307c, 0xd887d42947d16e56
                .dword 0x7c03d0d932ae4918, 0x56a8b9bd5cac97dc
                .dword 0x7f3cc1c0740d1e0a, 0xd0e71cedfc6f7330
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x32e04efcab225b6c, 0x59874f8acebe5c82
                .dword 0xee1b7b2ee2190ed9, 0x6de643c4076e8a54
d_2_0:          .dword 0xbabc3ea420e927be, 0x8e6ed5ebf41529a9
d_2_1:          .dword 0x9d4d02904a465f8a, 0x896cb224f09db87a
d_2_2:          .dword 0x21b114f639f0c1a1, 0xddc9bbe5e60075e6
d_2_3:          .dword 0x273901ecaaa5e69c, 0x0dd9c0a812d41744
d_2_4:          .dword 0xd1ce450b9a948677, 0xf5a8daca89f9b77f
d_2_5:          .dword 0xb7d64addda21c813, 0xa02a5ec3d56cecad
d_2_6:          .dword 0x0e01ba75619e8b0e, 0x477f26879bf01624
d_2_7:          .dword 0xfb8e97cf07adcd55, 0x3c44f305c05f37d5
d_2_8:          .dword 0xd70ba98ecdede8b0, 0xc5520dc905abe282
d_2_9:          .dword 0x564cddadb4ec1f67, 0x6f8cd417d9babe59
d_2_10:         .dword 0x9694ab4f09c5b491, 0xf9277ee1ae6c8da4
d_2_11:         .dword 0x477423c3971e1733, 0x103abbb1633ffc7a
d_2_12:         .dword 0x0029fbdb2c2f8180, 0x4edad413ae2850b9
d_2_13:         .dword 0x51de813b81cda41e, 0x87acb0bd7367b232
d_2_14:         .dword 0xb3c17caf349b928b, 0x6840d1bc8dd24c03
d_2_15:         .dword 0x5e9940ec51eb50d8, 0xe619cc12854e15a7
d_2_16:         .dword 0xfa9c943f4fa70f9a, 0x300bd7c8b2117ce7
d_2_17:         .dword 0x18fe15d0089485b5, 0x40b50d5d6a5ef692
d_2_18:         .dword 0x6b99493f8c7224fb, 0xd7fbe6fcf963ee9b
d_2_19:         .dword 0x8837a7e3c6833a0a, 0x7f3128fac931a974
d_2_20:         .dword 0x5d79f132c3e8bda6, 0x452bc6aa011a2a32
d_2_21:         .dword 0x36f366cef6a80b0b, 0xc950965a5b765eb7
d_2_22:         .dword 0x56f7826b91b69b41, 0x17920b54b74a75c8
d_2_23:         .dword 0x7f605c7dc283ac7c, 0xb5582b5edf25c4d8
d_2_24:         .dword 0x222f443824a95e57, 0x754f201c1b13089d
d_2_25:         .dword 0x0fd79d1e0d417ec5, 0xe84153db432eeae2
d_2_26:         .dword 0x28be7e1102f4c3c5, 0x6fe435aeae8856d6
d_2_27:         .dword 0x642d20fd837e9af4, 0xbbe51dd59f6a1fa9
                .dword 0xd74600e7cde0de58, 0x58a94a1c78648710
                .dword 0xa47a2845c0f099d1, 0xf2eb8381a84e4e08
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x921abf6073be4303, 0xd9b8a48c1aef0381
                .dword 0x2ebc80982a40d8da, 0xad5912cdafa7fe6b
d_3_0:          .dword 0x1a0a5c5da2cf5ec4, 0x17ce465ead8b347d
d_3_1:          .dword 0x8f5ca69cfab2ddc8, 0x96c69b478cfd97e7
d_3_2:          .dword 0xbdf2f898ca4d65e2, 0x9c4ecd41aac25931
d_3_3:          .dword 0x9a6f5820750a5ad7, 0x75210314abcb124b
d_3_4:          .dword 0x70124347f46cee2a, 0x19dc2bfcc1b0ec30
d_3_5:          .dword 0xda65bbedd15bd727, 0x718440306398e53b
d_3_6:          .dword 0x9dc300960e88df1f, 0x8a7e2e8f27e5b5e9
d_3_7:          .dword 0xac176dc25264f149, 0xbd10288b92b79f4f
d_3_8:          .dword 0x49955aaa4715e506, 0xdeda3fda41254d49
d_3_9:          .dword 0x12ceadc27ecc8411, 0x49155560d4d64007
d_3_10:         .dword 0xbb4ce1af36fec3e9, 0x69d1920b8b5b83e3
d_3_11:         .dword 0xe04e6136fda89fba, 0xe536e7f674258474
d_3_12:         .dword 0xb8e4f999cf414e89, 0x93ebdd67fe0eb742
d_3_13:         .dword 0x9a51bd9b25643221, 0x3d40f5df9f0772f0
d_3_14:         .dword 0x176b3bdc9ed813ca, 0x8a43ab124323a44c
d_3_15:         .dword 0x6c110cfacb44a92e, 0x3fee1faa38e5f974
d_3_16:         .dword 0x97332f47fdbebe65, 0xe02c6d053e0ef843
d_3_17:         .dword 0x55b897adaf84fdd4, 0x3134c1a709eccc04
d_3_18:         .dword 0x0c3ab949e8df186d, 0x112d9a662cf5d05f
d_3_19:         .dword 0xcb1241ba25b2119f, 0x4b7901b2e9e8ba0a
d_3_20:         .dword 0x368f088f211e083f, 0xdbc2cf853566ff12
d_3_21:         .dword 0x3fbe14a32272046b, 0xe6a77f50bf0cc5aa
d_3_22:         .dword 0x311b4778eaec09ac, 0xf7fb5602cc236402
d_3_23:         .dword 0x750be2b8e8749891, 0x429b2c377536f2dd
d_3_24:         .dword 0xe6ece2b6fd4fd690, 0x944027343e14e475
d_3_25:         .dword 0x6685979684f3a0ca, 0xa19d5f6431df9408
d_3_26:         .dword 0x0aa3ce9f1693186b, 0x1322508d955bec00
d_3_27:         .dword 0x8d574b205b27ee02, 0x8678e5845b002aef
                .dword 0xc02e78f67a364c11, 0x66289fe30580e080
                .dword 0x3bda538637984557, 0x4b9341aef5c4e3de
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x12e2a8ca78ffda7e, 0x16de87bc2b420e7b
                .dword 0x6759aa351336fa25, 0x63de2657d3479051
d_4_0:          .dword 0x04a0f4d7b8201d41, 0xe12462a00dd8e733
d_4_1:          .dword 0x4024eee4b584467e, 0xd9b263d8d85300f0
d_4_2:          .dword 0xd6af97126cb82a0b, 0x981c0f212529d84a
d_4_3:          .dword 0x796f928c2a344c75, 0xb6ef05b64b549975
d_4_4:          .dword 0xf6cc7c6d3d968c63, 0x91c808fb329609af
d_4_5:          .dword 0x150fd6e0e7e495ad, 0x76e35266ed75b3fc
d_4_6:          .dword 0x79c088455b629540, 0x68091d9146ceb37a
d_4_7:          .dword 0xa995e70be8020c4d, 0xc90147c225ab3665
d_4_8:          .dword 0x0a3b1d2515e47744, 0x380da6966336d9ae
d_4_9:          .dword 0x9d4c0d0c306121c1, 0x34dcd4004a88a8c5
d_4_10:         .dword 0xb4091508f067b027, 0x1dd50a596136f269
d_4_11:         .dword 0x218f9824233326d2, 0x2346be13aceb5a15
d_4_12:         .dword 0xe7e2322d54251549, 0x658686414bb4b0ea
d_4_13:         .dword 0xaa30e528861563a4, 0x413c3d720d10ade6
d_4_14:         .dword 0x2046cd315aa291d9, 0x13b281fab1c63512
d_4_15:         .dword 0x32d90d5016b233e1, 0x41e63333b363af9a
d_4_16:         .dword 0xac5be56072bf5bab, 0xf222a2679ed4445e
d_4_17:         .dword 0xf32ebab7c3f14187, 0xc0ae02318b6f27a0
d_4_18:         .dword 0xcf8cd7e3a30e6d27, 0x62261e3ea0009e78
d_4_19:         .dword 0x6713207216ff1344, 0x46b973847689cbb5
d_4_20:         .dword 0x8e503b9e8f121062, 0xda12fc3f74e3b9c7
d_4_21:         .dword 0xaf1076d315b16a19, 0x36d02952b7b6c093
d_4_22:         .dword 0xab7f72aac54d85cb, 0xe71906fc3aef69d1
d_4_23:         .dword 0xd611328c129dad09, 0x2a6ebd2c57878e34
d_4_24:         .dword 0x17bb05cf764c671f, 0x4596feff841a691f
d_4_25:         .dword 0x1bde67998f9be796, 0xd4fc4b11a745a02d
d_4_26:         .dword 0x0d2c0c8e6a4e2a91, 0x49c38b139d0f40c0
d_4_27:         .dword 0x8c9982ee642d1133, 0x958984633b5b4665
                .dword 0xedc4f1f393e04ed5, 0xabcfe775fae0b603
                .dword 0x6bfbd02d3460db34, 0x3730972d370e414b
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xfe6a777aa0352a43, 0xd5e42abfa546a6bc
                .dword 0x1b2742298d6f2665, 0x65e73de83d01725e
d_5_0:          .dword 0x50e4d7ce40a625d6, 0xc9aec1afed9d40f2
d_5_1:          .dword 0xe51e593e8d0fd34c, 0xcac7e96ce4d005ac
d_5_2:          .dword 0xe2e3166cb2498e15, 0x0355ca9024810217
d_5_3:          .dword 0x96c275270ceee6ef, 0xbef5ada4c3b2e731
d_5_4:          .dword 0x6d03780cb9ee4fd5, 0x2584e230c31372f9
d_5_5:          .dword 0xaae353b331b01a55, 0x26e73b3b41f7ea00
d_5_6:          .dword 0x33a63ed2b596827a, 0x732b48c66b45e7d1
d_5_7:          .dword 0x8adc531b0303d609, 0x6ac29d3f33830d5a
d_5_8:          .dword 0x8e85662a1257d5b4, 0x3d00c5e86f803c3f
d_5_9:          .dword 0xc11bfeeb5f709e12, 0x7a0dbed8182a8b44
d_5_10:         .dword 0x770f7c540e59237d, 0x91fe181a737dcf42
d_5_11:         .dword 0x6fcb511c9fa8b725, 0x948716e8fe875c90
d_5_12:         .dword 0xd27b87887fa454fa, 0x8c63b6d6950c0a37
d_5_13:         .dword 0x1c6a0240845e3d51, 0xff49019964f845b2
d_5_14:         .dword 0x479da426989269ef, 0x5113561b12c33530
d_5_15:         .dword 0xcf1e3c62e0f341fa, 0x6798aa2a8e6d179a
d_5_16:         .dword 0x26c2cbe286d94f60, 0x984659d3edbbaf54
d_5_17:         .dword 0xec8cc588453e3cb2, 0x8626c0eb5c57b133
d_5_18:         .dword 0x0388e3a1bf5bc545, 0xff112781ed594836
d_5_19:         .dword 0xab46b7c1655dbfcb, 0x211912d90f7ade5b
d_5_20:         .dword 0x6cce404c32861bf8, 0x312e31247bf42ff7
d_5_21:         .dword 0x253acb9e5378179d, 0x65a8992dc9948531
d_5_22:         .dword 0x5c563e09d46a1430, 0xfcaae0f7e1e41421
d_5_23:         .dword 0x58bf319ec6307488, 0x48e2066a6b8f3a3d
d_5_24:         .dword 0x8fbdff38fb379503, 0x1fbd06b6dea9d1a8
d_5_25:         .dword 0xd8b6c4d4cf1cd6c3, 0xcb8d6395c86773f6
d_5_26:         .dword 0x6ef0e3091e0860da, 0xa466864b85f11373
d_5_27:         .dword 0xa54a10f9d0dc74b6, 0xe8e92fc420676865
                .dword 0x26797445da981360, 0x02b7ded5eda2d41e
                .dword 0xe65ed904894b2670, 0x0632b5f04370c32a
         /* Random data */
_end_data5:
              
 
