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
_p0:    xor x10, x10, x10                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 3                          ;
        add x10, x10, x14                         ;
        csrrs x14, fflags, x10                    ;
_p1:    csrrwi x14, sscratch, 31                  ;
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
_s0:    la x22, d_5_0                             ;
        ld x30, -8(x22)                           ;
_s1:    bltu x11, x11, _s5                                ;
_s2:    fmv.w.x f18, x1                           ;
_s3:    la x5, d_4_21                             ;
        sh x22, 20(x5)                            ;
_s4:    jal x18, _s5                                      ;
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
_l0:    la x1, d_1_25                             ;
        addi x1, x1, -0                           ;
        lui x7, 0xffe00                           ;
        xor x1, x1, x7                            ;
        lr.d x10, (x1)                            ;
_l1:    csrrsi x15, mtval, 3                      ;
_l2:    srai x16, x14, 18                         ;
_l3:    srai x5, x8, 30                           ;
_l4:    fsub.s f13, f29, f31, rup                 ;
_l5:    fcvt.s.wu f8, x21, rup                    ;
_l6:    fmv.x.w x2, f10                           ;
_l7:    la x15, d_2_11                            ;
        addi x15, x15, -8                         ;
        amominu.d x13, x16, (x15)                 ;
_l8:    la x4, _l92                                       ;
        jalr x11, 0(x4)                           ;
_l9:    la x13, d_0_20                            ;
        ld x20, -16(x13)                          ;
_l10:   xor x28, x28, x28                         ;
        csrrw x3, mcause, x28                     ;
_l11:   la x12, d_5_17                            ;
        sh x6, -6(x12)                            ;
_l12:   la x14, d_1_7                             ;
        addi x14, x14, 0                          ;
        amoadd.d x29, x20, (x14)                  ;
_l13:   la x6, d_1_0                              ;
        sd x29, -16(x6)                           ;
_l14:   blt x26, x30, _l78                        ;
_l15:   srlw x7, x12, x19                         ;
_l16:   fmv.x.w x8, f7                            ;
_l17:   la x24, d_1_5                             ;
        addi x24, x24, 24                         ;
        amoor.d x29, x30, (x24)                   ;
_l18:   flt.s x18, f16, f0                        ;
_l19:   beq x15, x13, _l89                                ;
_l20:   la x19, d_2_4                             ;
        addi x19, x19, -24                        ;
        amoand.w x15, x23, (x19)                  ;
_l21:   sraiw x8, x18, 7                          ;
_l22:   remw x5, x0, x25                          ;
_l23:   la x11, d_0_26                            ;
        lwu x27, -20(x11)                         ;
_l24:   fcvt.w.s x1, f8, dyn                      ;
_l25:   la x6, d_5_3                              ;
        lhu x24, -0(x6)                           ;
_l26:   srli x13, x14, 35                         ;
_l27:   fsgnjx.s f27, f11, f26                    ;
_l28:   slti x26, x21, -251                       ;
_l29:   fmsub.s f17, f12, f21, f19, rmm           ;
_l30:   bne x26, x27, _l107                       ;
_l31:   la x3, d_0_20                             ;
        srai x3, x3, 1                            ;
        csrrs x5, pmpaddr7, x3                    ;
_l32:   fmv.w.x f6, x10                           ;
_l33:   srlw x8, x5, x27                          ;
_l34:   remu x11, x29, x17                        ;
_l35:   la x12, d_2_4                             ;
        fsw f15, -28(x12)                         ;
_l36:   feq.s x16, f5, f3                         ;
_l37:   fcvt.wu.s x1, f23, rup                    ;
_l38:   la x1, d_5_27                             ;
        addi x1, x1, 24                           ;
        amoand.d x8, x10, (x1)                    ;
_l39:   bge x17, x13, _l64                                ;
_l40:   fcvt.lu.s x15, f2, rmm                    ;
_l41:   fmul.s f20, f19, f19, rdn                 ;
_l42:   bltu x8, x10, _l61                                ;
_l43:   xori x16, x10, 2047                       ;
_l44:   ecall                                     ;
_l45:   div x17, x13, x11                         ;
_l46:   fsqrt.s f29, f21, rmm                     ;
_l47:   la x30, d_4_6                             ;
        addi x30, x30, 16                         ;
        amoadd.w x13, x24, (x30)                  ;
_l48:   remu x0, x27, x11                         ;
_l49:   beq x19, x23, _l108                               ;
_l50:   flt.s x18, f16, f11                       ;
_l51:   sllw x8, x27, x16                         ;
_l52:   mulhu x20, x16, x16                       ;
_l53:   remu x12, x25, x17                        ;
_l54:   la x25, d_4_15                            ;
        addi x25, x25, 8                          ;
        amoxor.d x17, x27, (x25)                  ;
_l55:   addi x30, x20, 1767                       ;
_l56:   mul x12, x29, x12                         ;
_l57:   sraiw x14, x27, 28                        ;
_l58:   la x30, d_0_10                            ;
        lb x17, -22(x30)                          ;
_l59:   fclass.s x5, f24                          ;
_l60:   addw x3, x5, x4                           ;
_l61:   la x17, _l103                                     ;
        csrrw zero, sepc, x17                     ;
        sret                                      ;
_l62:   sltiu x20, x12, -2047                     ;
_l63:   fcvt.s.lu f0, x15, rup                    ;
_l64:   remu x6, x4, x28                          ;
_l65:   la x11, d_0_1                             ;
        lui x23, 0xffe00                          ;
        xor x11, x11, x23                         ;
        sb x4, 30(x11)                            ;
_l66:   csrrci x18, sip, 31                       ;
_l67:   divu x16, x14, x1                         ;
_l68:   fsgnjx.s f27, f7, f7                      ;
_l69:   addi x21, x10, 1223                       ;
_l70:   sllw x28, x9, x6                          ;
_l71:   fence.i                                   ;
_l72:   la x23, d_1_26                            ;
        addi x23, x23, 0                          ;
        amomax.w x26, x11, (x23)                  ;
_l73:   fmadd.s f17, f12, f12, f17, rtz           ;
_l74:   la x3, _l91                                       ;
        csrrw zero, uepc, x3                      ;
        uret                                      ;
_l75:   ori x11, x24, -1120                       ;
_l76:   la x5, d_1_21                             ;
        addi x5, x5, -24                          ;
        sc.w x27, x27, (x5)                       ;
_l77:   fle.s x2, f2, f31                         ;
_l78:   subw x14, x20, x24                        ;
_l79:   la x26, d_4_18                            ;
        lui x8, 0xffe00                           ;
        xor x26, x26, x8                          ;
        sw x9, 28(x26)                            ;
_l80:   srliw x29, x8, 18                         ;
_l81:   andi x13, x16, 1721                       ;
_l82:   div x5, x20, x3                           ;
_l83:   la x8, d_2_14                             ;
        addi x8, x8, -24                          ;
        amomaxu.w x19, x30, (x8)                  ;
_l84:   la x4, d_3_20                             ;
        addi x4, x4, -0                           ;
        amoor.w x12, x16, (x4)                    ;
_l85:   fclass.s x2, f16                          ;
_l86:   fcvt.s.wu f12, x29, rmm                   ;
_l87:   la x14, d_1_17                            ;
        addi x14, x14, -28                        ;
        amomin.w x10, x23, (x14)                  ;
_l88:   beq x29, x1, _l107                                ;
_l89:   remw x1, x22, x0                          ;
_l90:   la x13, d_2_5                             ;
        lb x22, -22(x13)                          ;
_l91:   la x12, d_5_9                             ;
        addi x12, x12, -0                         ;
        sc.d x17, x12, (x12)                      ;
_l92:   srai x1, x25, 11                          ;
_l93:   divu x30, x7, x0                          ;
_l94:   rem x19, x21, x3                          ;
_l95:   lui x27, 1047525                          ;
_l96:   feq.s x6, f29, f1                         ;
_l97:   fsgnj.s f31, f14, f21                     ;
_l98:   fence                                     ;
_l99:   la x6, _l112                              ;
        csrrw zero, mepc, x6                      ;
        mret                                      ;
_l100:  la x15, d_1_11                            ;
        addi x15, x15, -24                        ;
        amoand.d x23, x25, (x15)                  ;
_l101:  srai x2, x27, 26                          ;
_l102:  bge x23, x30, _l111                       ;
_l103:  ecall                                     ;
_l104:  la x18, d_1_10                            ;
        sw x4, -0(x18)                            ;
_l105:  feq.s x3, f12, f23                        ;
_l106:  mulh x27, x18, x3                         ;
_l107:  la x30, d_4_10                            ;
        addi x30, x30, -20                        ;
        amoadd.w x17, x5, (x30)                   ;
_l108:  bge x24, x12, _l110                               ;
_l109:  sraw x22, x9, x29                         ;
_l110:  bne x1, x20, _l111                        ;
_l111:  la x5, d_2_11                             ;
        addi x5, x5, 16                           ;
        lr.w x24, (x5)                            ;
_l112:  mul x27, x27, x5                          ;
_l113:  la x26, d_2_20                            ;
        addi x26, x26, 24                         ;
        amomin.w x13, x2, (x26)                   ;
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
                .dword 0x55242fc965db435b, 0x897f1c98dccabf59
                .dword 0xe0d933124d6b306b, 0xec0b7b3a62c18172
d_0_0:          .dword 0xe8420e3b3423274b, 0xe41c8e5caca80436
d_0_1:          .dword 0x32da37c3ee88b78f, 0xad3fb505de8e316f
d_0_2:          .dword 0xb07faa0202de9cba, 0xc17f8f16d5ccad0c
d_0_3:          .dword 0xb77f87e22eb6c416, 0x5fb4b91b997ab4df
d_0_4:          .dword 0x76902b0565e9aebe, 0xcd39bc4e5cb51ae2
d_0_5:          .dword 0x1eacb33b2298c162, 0xfc36afee5764694a
d_0_6:          .dword 0x149f762f1bd046d6, 0x8e44e81f067f7500
d_0_7:          .dword 0x75be66abac2ec703, 0xb0f25077831b2281
d_0_8:          .dword 0x639c32f848d0a1d2, 0x8f4afbf6ed920f00
d_0_9:          .dword 0xac48f21962d87a10, 0x92a035e3f0a54469
d_0_10:         .dword 0x78207e2a0b340b73, 0x367e7e93549ee32b
d_0_11:         .dword 0x7fd6e36d4243f71b, 0x4894b78c2da82b55
d_0_12:         .dword 0x282b0e333c72dd11, 0xef6858920cff1244
d_0_13:         .dword 0xc35fa88a59ff5503, 0xf3d57c7a60dee74d
d_0_14:         .dword 0xacf52a098076e7cc, 0x0c9f02cc8b095992
d_0_15:         .dword 0x17eac75d4176c497, 0x2f39e0907c63215c
d_0_16:         .dword 0x8007f718018a95e6, 0x483f9808d8005e8a
d_0_17:         .dword 0x27648391aa95e2c9, 0x7618e0c9508fb43d
d_0_18:         .dword 0xa4b01b79bb594b53, 0x551cc855d1329fd4
d_0_19:         .dword 0xbd313d84b4f6c3ed, 0xee0a1ebbb83fb83b
d_0_20:         .dword 0x09dfdefb9f84414a, 0x7892f2f9306cee6b
d_0_21:         .dword 0xa3bd2a8134e6067d, 0xb19e84664d6a78fe
d_0_22:         .dword 0x24ded6c3f28bf60d, 0x916799cb1ae59864
d_0_23:         .dword 0xa9390262e94f2357, 0xd212bed2f2cf11f6
d_0_24:         .dword 0x9e545f350db7b73a, 0x3be2cd758d4bf483
d_0_25:         .dword 0xd4e833cd686cc404, 0xd81e3c87b760f24a
d_0_26:         .dword 0x77a22cd12e637919, 0x9110dbf0d70ab774
d_0_27:         .dword 0x92e87110b88249c9, 0x42ed4c0134594b7f
                .dword 0x793ade74aeb72ee9, 0xec1248d3ab472e7e
                .dword 0x72f08cca18cd6ca3, 0x0c91d8c9742bd234
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x850e23c865dbb103, 0x37621f07e63aeb50
                .dword 0x45e24c3c2c746668, 0x1cb1915c31d7e434
d_1_0:          .dword 0x3dcf4c701b20435b, 0x1aee0be2144b79f4
d_1_1:          .dword 0x52519135eee63e5b, 0x045104c044a73616
d_1_2:          .dword 0xe0be48abafbe0b9d, 0xf8a360be9c5b1e82
d_1_3:          .dword 0x6cf0c1020a3f9bc2, 0x370e5fd8d354a26a
d_1_4:          .dword 0x77d7f1717f345c08, 0x657ed264822b1208
d_1_5:          .dword 0xde2f72609439bdb2, 0x46eee16450e17ed3
d_1_6:          .dword 0xd54dbdb3859cf042, 0xa836eff902f9534d
d_1_7:          .dword 0x3cac7235f8dc8044, 0xdbe7dd5f88d96c27
d_1_8:          .dword 0xaa3dd7beddf985ee, 0x7e58c4f999d4e870
d_1_9:          .dword 0xce5d39e14315162e, 0xaba558134c11b4e8
d_1_10:         .dword 0xdc304e11d70b89fb, 0xe39b8826020cd36e
d_1_11:         .dword 0x90fc74cfdc17a34b, 0x60a81b76b612f41f
d_1_12:         .dword 0xa110a283b49fbf53, 0x90f11204a8b3f7b1
d_1_13:         .dword 0x1ca3cebf8e45b78d, 0x075bb2919c3cac39
d_1_14:         .dword 0x5c475361a050bdde, 0x92e15d1ddaea2258
d_1_15:         .dword 0x57e95152038871a0, 0x2ab426f8f8a0b1b9
d_1_16:         .dword 0x4e81614d23b52185, 0xb277543502238eea
d_1_17:         .dword 0xabe60639330f4a44, 0x326407bb855e1b34
d_1_18:         .dword 0x00b9fcd69ebf56ae, 0xb6e89a63d5d178cc
d_1_19:         .dword 0xdf45066c173121f7, 0x4a91a69e3f2bc3d3
d_1_20:         .dword 0x2406a787c85ab469, 0x37979e7708cc8ec6
d_1_21:         .dword 0xbee450d070faf2d4, 0xef3e0148a11fee59
d_1_22:         .dword 0x197691037aa93799, 0x740d874a805854eb
d_1_23:         .dword 0xdc56aa3f1a3d6d2b, 0xab04ede1a21b6684
d_1_24:         .dword 0xf12dd75dfc514a77, 0x02e5aaae7ef621f1
d_1_25:         .dword 0x093f4fa279794293, 0xac287ceaa0f3b3ad
d_1_26:         .dword 0xc25642a766e43d84, 0x84ba750126c77ff2
d_1_27:         .dword 0x165afe9d9d29f8e2, 0x35a188ac4826720c
                .dword 0x9a8b823c9250f3a5, 0x5f57f05eb75fd028
                .dword 0x369d953909b20a26, 0x0752a99609a7f1d5
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x2d61eb69357477d0, 0x758a44649695844c
                .dword 0x6523e1fa9c2c8eda, 0x52e34a8d07fd4309
d_2_0:          .dword 0xfd19a9f46fbe6c5e, 0x8d24b1ec8681527e
d_2_1:          .dword 0x71680463a3c855b0, 0x7b7cbc268c4e0307
d_2_2:          .dword 0xddbf56b70b950e26, 0xe28a1fdfd6ef7d65
d_2_3:          .dword 0x547ae549ad652119, 0x2a7d3e00392e6d6c
d_2_4:          .dword 0x7c65a93a21701e62, 0xfac7aab989e0a52d
d_2_5:          .dword 0x9ef5856cb647b548, 0xfcd4a8b904f04ba3
d_2_6:          .dword 0x00583e4aa6b177d9, 0xbd4558852095cbbc
d_2_7:          .dword 0xf53e0bf6358077f5, 0xdbbd6bfd05b75fd0
d_2_8:          .dword 0x757f114e3b77bc7a, 0x89516fe7fd27e0ea
d_2_9:          .dword 0x08bf2bf28be714c2, 0x3160a6a6d978ca87
d_2_10:         .dword 0x56334a35d77b8bae, 0x4bf2140f77a9477c
d_2_11:         .dword 0x3248c8aecfa2f81e, 0x780f97f612fc6411
d_2_12:         .dword 0x8ddbf9e7cdb1a42c, 0x1af4f4eb92a2dd64
d_2_13:         .dword 0xe0625fdf87b03b95, 0x3a30d51c5938c293
d_2_14:         .dword 0xa561c62148a8becf, 0x9fa3cf8c01d51744
d_2_15:         .dword 0x962895533504fff2, 0xc05121ebce30e46c
d_2_16:         .dword 0x420801326f5544c2, 0x425549a5f3fa40ee
d_2_17:         .dword 0x18748004ec6dce97, 0x7cb3fb63136151cb
d_2_18:         .dword 0x9708fbd25adebb64, 0x44a92c60094825e6
d_2_19:         .dword 0x8febc7be51fcede3, 0xa90722a3a07db8d7
d_2_20:         .dword 0xe6e715b345ced6cd, 0x587bd32efcd81438
d_2_21:         .dword 0xc5c871055a47604d, 0x9c1fa297f1b72b11
d_2_22:         .dword 0xd013f0e2323afa4a, 0x9dd91b4c37e221a6
d_2_23:         .dword 0xde5075d1b7c8898c, 0xef2e1d2d8072daf6
d_2_24:         .dword 0x413662b492a39918, 0x13957b0e60d7afdb
d_2_25:         .dword 0xf0087f6a618fa366, 0xfeaec5fedeb85c6e
d_2_26:         .dword 0x3151fa4d24afc94e, 0x2a571f2bbb1fc2bd
d_2_27:         .dword 0x8027de0148383540, 0xe95c9e9e769383ec
                .dword 0x62b6d9a5b169073a, 0xb520f9e53404030d
                .dword 0xda5a7674a45fb4e5, 0x3e04655e695d87da
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x57b29fcf932d2067, 0x88c19c7207085a43
                .dword 0xa94668fc078f5978, 0x8c1c18049d79cb28
d_3_0:          .dword 0x1dc5ed32f8c5a7e0, 0x83e0a4f6713b7e7f
d_3_1:          .dword 0x08ddfbbb60649d35, 0x61b772f0ec2e644d
d_3_2:          .dword 0x52170c80468b92b7, 0x96de5bd1a53fa898
d_3_3:          .dword 0xd63728ec6ca8828e, 0x740b000d4e4a6c55
d_3_4:          .dword 0x710c0926e9219516, 0x7270a6b4e92d2e6a
d_3_5:          .dword 0x9d7f6d88516c33e0, 0xc098b22258bfac76
d_3_6:          .dword 0x3ed02af9fe54013f, 0xa6409cb330f3e8af
d_3_7:          .dword 0x9e99c03014899e96, 0x20139c47683740c4
d_3_8:          .dword 0x83ac067eb75d47bc, 0x065a727c3017472e
d_3_9:          .dword 0x63c23b7e0127d283, 0x10976e18c9f47e27
d_3_10:         .dword 0xc0a8bd8e9318d39a, 0xbfacfb7217359f30
d_3_11:         .dword 0xddc7a542a33db8f9, 0x753f9275d7c38b34
d_3_12:         .dword 0xa56e55645536ec1f, 0xee06d6e56068bba2
d_3_13:         .dword 0xb9c94e6fec010515, 0xd8b7356c18799ebd
d_3_14:         .dword 0xc0a21b34c30d4890, 0xe585b1f2e06ef2a2
d_3_15:         .dword 0xdce1d441eeba50d3, 0x3d6281f05d5ed5bb
d_3_16:         .dword 0x1fa1d4aa17821aa8, 0x6af4626a1c7d6b0f
d_3_17:         .dword 0x8f49cfa44d82cbb3, 0x36c25091341d0466
d_3_18:         .dword 0x047128cbdee03b21, 0x234038a3460e54d5
d_3_19:         .dword 0xbb562aea342992c5, 0xf136b67138d781e7
d_3_20:         .dword 0xa8bf2719b836638c, 0x5d0f3c1505c350f2
d_3_21:         .dword 0xc27ffec5623b08fd, 0x1238583c710d9f32
d_3_22:         .dword 0x95a72eaa36a259ae, 0xba42ccb93d2349c0
d_3_23:         .dword 0x1f8a89da787a530d, 0x6d84632e99855a97
d_3_24:         .dword 0x6b255e755557fef2, 0x53a77ac8714dd42b
d_3_25:         .dword 0x96b538a61b4ee7ba, 0x926f8c5c746b5521
d_3_26:         .dword 0x4d6769a60e0dca98, 0x0a50d8c65fad2c63
d_3_27:         .dword 0xd168bdf5b784b412, 0x48cdfd3610fa1165
                .dword 0x4a67e08e5f21680f, 0xff7a2ed2d119cb0b
                .dword 0xb40d40a8ec72bbcd, 0x7936e5359f2a4904
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0xdbd7298d8928e183, 0xe240896b1f613b8f
                .dword 0x70d00085a5276d66, 0x517d5005f2dd3f59
d_4_0:          .dword 0x52589e9056d5c47f, 0xf49dc984c790770f
d_4_1:          .dword 0x6143a74b2ccba8ac, 0x227e0ecef5c803da
d_4_2:          .dword 0xe11b789886f3242a, 0x55dded63e9c3ab87
d_4_3:          .dword 0x201c8d27d1df62ae, 0x0c9d5a36a9d4a97e
d_4_4:          .dword 0x19d6f6997e741cec, 0xab8a1a1ccef0dd19
d_4_5:          .dword 0xbcf54a8174067fd2, 0x93075616da7f7804
d_4_6:          .dword 0x170cd3c85be023ba, 0xadce58acfb3828e8
d_4_7:          .dword 0x478b68a7d4362357, 0x1dc6bbbbddc9b53b
d_4_8:          .dword 0x66764539c2881158, 0x5a6c530ab82db6b0
d_4_9:          .dword 0x9efc737f57d1f562, 0xa383915a00c4119a
d_4_10:         .dword 0x77f25ee5c8b90519, 0x583686bc003dd9d2
d_4_11:         .dword 0x294a3cddd91260bd, 0xf2bf89a80a4ce022
d_4_12:         .dword 0x181184d772380e08, 0x132cff29d949061b
d_4_13:         .dword 0x103d2a531947ecc0, 0xf7154b166640d89c
d_4_14:         .dword 0x5e27bc3d7d35f5d3, 0x843d53d24ef3fa67
d_4_15:         .dword 0x2aca5b5565a738e0, 0xb277da6a11a0bb51
d_4_16:         .dword 0x2c195af17f2926d1, 0x3777bb21e64fa33d
d_4_17:         .dword 0x41134e5cb3befc32, 0xf36f4baff6863bf1
d_4_18:         .dword 0x54eba58892435e53, 0xe1678eaa2dd82eb6
d_4_19:         .dword 0x7804c496cbf9db56, 0x880883633b7c9d93
d_4_20:         .dword 0xc74ce4f46b8db18e, 0xea177a51b47e3a3b
d_4_21:         .dword 0x85150a3f9537bce2, 0xbd6c6b8db6ea2b00
d_4_22:         .dword 0xd708e7ee3829f363, 0xab15a0abca8e0e4c
d_4_23:         .dword 0xeba8082652428557, 0x1507693be1c4cd50
d_4_24:         .dword 0x00f124d76d0be6fd, 0x6839d9b270c1f868
d_4_25:         .dword 0x0e6d80582eb51590, 0x9c170fd3268c9bac
d_4_26:         .dword 0x67e8e47ffbd8f013, 0xc64fe68828619fb4
d_4_27:         .dword 0x21401e19daac7bf4, 0x5d966fb7eca69122
                .dword 0xe6d43187b4462f35, 0x9275f4dc7f1d4d90
                .dword 0xe6338502af15934b, 0xf4e21bd36bcbff96
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xce754500678f165f, 0x8afd28d75d4f78aa
                .dword 0x8af0d42361aebbd7, 0xca58363b07d74e23
d_5_0:          .dword 0x5a598918c4a29b80, 0xb5150cbd4167ddd8
d_5_1:          .dword 0xa359d13620dd6173, 0x393585613853be57
d_5_2:          .dword 0x12775ef9dccfbf55, 0xb2adf13a7c6b97b3
d_5_3:          .dword 0x43caf25858e4b8d9, 0x4d633563c4dc0dfd
d_5_4:          .dword 0x25fe8803bd5d1909, 0xfab39c7dcf066872
d_5_5:          .dword 0x62bc336b09125f6a, 0xbf5afdcaa1b8c8c7
d_5_6:          .dword 0x552a2e42017ce4a5, 0x80999acc3e2b1914
d_5_7:          .dword 0x519a7dd3b8201068, 0xa63a2d3f4910d12c
d_5_8:          .dword 0x1c8579e55f2e53a6, 0x436e54197b91eded
d_5_9:          .dword 0x0a7825382c64b9a6, 0xe88e1fc3bbe7c93e
d_5_10:         .dword 0x040c54f09909b1d3, 0x8afbb629dae4a4ca
d_5_11:         .dword 0x8bea6674d02491ef, 0x95a15f4460fb708e
d_5_12:         .dword 0x9dd1efd133626334, 0x99c0e00b5556c8b5
d_5_13:         .dword 0x9200079380f8904d, 0xa221b1dfdeb523a4
d_5_14:         .dword 0xb736f0cfa6d0537e, 0xb4979e0c466e0d47
d_5_15:         .dword 0x1e39da4c98936a95, 0xc3dee6d7236b2a0a
d_5_16:         .dword 0x24055b9c478ab43e, 0xd58abd2cc0aade09
d_5_17:         .dword 0x3f4cb6b2dff76494, 0x36a80b6d6a60f675
d_5_18:         .dword 0xdf7f4572ac07f072, 0x9d27532d3a2073ed
d_5_19:         .dword 0xd00579d80a91b0a4, 0x316a007929a08c82
d_5_20:         .dword 0x7dbc22451578e93d, 0xa9c904e2de6950f9
d_5_21:         .dword 0xe561c8766efdf640, 0x8fb061afd58c1a2b
d_5_22:         .dword 0x1e0a8a540bf88bde, 0x94676bab0cf92294
d_5_23:         .dword 0xa2c0d5844e68d975, 0x8549f0ead7db4e4b
d_5_24:         .dword 0x73326a8d5c262acf, 0xc7cfe21fc6e48914
d_5_25:         .dword 0xf4517652f4fb5d12, 0x1b27181cd9a57ddb
d_5_26:         .dword 0xd6cc05b91f8a9bf0, 0x332f9ec3cb9d2feb
d_5_27:         .dword 0x68e6b3b779d43817, 0x989a5710b063cc4f
                .dword 0xc6ba4a9eaeee3e69, 0x342d3ab65208efab
                .dword 0x835d4871a9bf277b, 0x7c2d4b39884f82c8
         /* Random data */
_end_data5:
              
 
