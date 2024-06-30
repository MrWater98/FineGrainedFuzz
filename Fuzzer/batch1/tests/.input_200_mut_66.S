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
_p0:    csrrwi x12, frm, 28                       ;
_p1:    csrrci x13, satp, 23                      ;
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
_s0:    fsgnj.s f17, f13, f16                     ;
_s1:    addw x30, x30, x11                        ;
_s2:    csrrwi x3, mtval, 22                      ;
_s3:    xor x12, x12, x12                         ;
        addi x13, zero, 3                         ;
        slli x13, x13, 26                         ;
        add x12, x12, x13                         ;
        addi x10, zero, 1                         ;
        slli x10, x10, 16                         ;
        add x12, x12, x10                         ;
        addi x16, zero, 1                         ;
        slli x16, x16, 9                          ;
        add x12, x12, x16                         ;
        csrrc x26, fflags, x12                    ;
_s4:    blt x7, x30, _s5                          ;
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
_l0:    la x11, d_1_6                             ;
        addi x11, x11, -8                         ;
        amomaxu.d x3, x12, (x11)                  ;
_l1:    addw x27, x15, x15                        ;
_l2:    la x15, d_4_2                             ;
        addi x15, x15, -20                        ;
        amoor.w x23, x20, (x15)                   ;
_l3:    divw x27, x3, x6                          ;
_l4:    la x17, d_1_20                            ;
        addi x17, x17, -16                        ;
        amoand.d x11, x22, (x17)                  ;
_l5:    sraw x17, x13, x5                         ;
_l6:    li x19, 0                                 ;
        la x15, pt1                               ;
        addi x15, x15, 16                         ;
        sfence.vma x19, x15                       ;
_l7:    la x7, d_1_24                             ;
        addi x7, x7, -24                          ;
        amoand.d x9, x11, (x7)                    ;
_l8:    la x28, d_2_6                             ;
        addi x28, x28, 0                          ;
        amomax.w x18, x13, (x28)                  ;
_l9:    andi x2, x29, 1155                        ;
_l10:   fmv.w.x f16, x18                          ;
_l11:   beq x2, x23, _l67                                 ;
_l12:   fsgnjn.s f8, f8, f1                       ;
_l13:   fsub.s f30, f20, f17, rtz                 ;
_l14:   feq.s x9, f19, f6                         ;
_l15:   fclass.s x29, f13                         ;
_l16:   la x27, d_2_26                            ;
        lh x16, 12(x27)                           ;
_l17:   la x25, _l130                             ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l18:   la x7, d_0_12                             ;
        lb x14, -31(x7)                           ;
_l19:   fdiv.s f30, f7, f27, rtz                  ;
_l20:   fnmadd.s f25, f23, f13, f7, rdn           ;
_l21:   la x14, d_4_2                             ;
        addi x14, x14, 0                          ;
        amoor.w x25, x11, (x14)                   ;
_l22:   csrrci x9, pmpaddr0, 3                    ;
_l23:   la x13, d_2_23                            ;
        addi x13, x13, -16                        ;
        amomax.w x5, x4, (x13)                    ;
_l24:   la x18, d_5_8                             ;
        ld x10, 16(x18)                           ;
_l25:   andi x13, x26, -1308                      ;
_l26:   ori x14, x27, 1093                        ;
_l27:   mul x0, x26, x18                          ;
_l28:   fsgnj.s f18, f17, f29                     ;
_l29:   la x11, _l87                              ;
        csrrw zero, mepc, x11                     ;
        mret                                      ;
_l30:   mulhsu x13, x20, x6                       ;
_l31:   la x11, d_5_2                             ;
        lwu x12, -12(x11)                         ;
_l32:   addi x8, x5, 1691                         ;
_l33:   fsgnjx.s f4, f2, f8                       ;
_l34:   fsub.s f14, f16, f23, rmm                 ;
_l35:   fmsub.s f3, f23, f4, f23, rup             ;
_l36:   slli x1, x10, 60                          ;
_l37:   fsgnjn.s f3, f27, f27                     ;
_l38:   bgeu x9, x10, _l123                               ;
_l39:   fcvt.w.s x22, f4, rtz                     ;
_l40:   la x22, d_5_10                            ;
        ld x28, -0(x22)                           ;
_l41:   la x23, d_3_26                            ;
        lw x12, -24(x23)                          ;
_l42:   mulh x12, x7, x10                         ;
_l43:   la x2, d_3_13                             ;
        addi x2, x2, -8                           ;
        amominu.d x16, x1, (x2)                   ;
_l44:   xori x16, x29, 121                        ;
_l45:   la x24, d_3_15                            ;
        lui x14, 0xffe00                          ;
        xor x24, x24, x14                         ;
        sh x12, 0(x24)                            ;
_l46:   mulh x5, x10, x1                          ;
_l47:   mulh x5, x5, x20                          ;
_l48:   la x16, d_3_17                            ;
        addi x16, x16, 0                          ;
        sc.d x23, x16, (x16)                      ;
_l49:   fmadd.s f17, f25, f19, f7, dyn            ;
_l50:   srliw x11, x20, 0                         ;
_l51:   sllw x0, x4, x5                           ;
_l52:   sllw x23, x7, x17                         ;
_l53:   addw x29, x20, x8                         ;
_l54:   la x19, d_4_22                            ;
        addi x19, x19, -16                        ;
        sc.d x23, x19, (x19)                      ;
_l55:   fmv.x.w x1, f27                           ;
_l56:   la x6, d_1_0                              ;
        addi x6, x6, -24                          ;
        lui x1, 0xffe00                           ;
        xor x6, x6, x1                            ;
        amomax.w x25, x1, (x6)                    ;
_l57:   fcvt.l.s x7, f31, rmm                     ;
_l58:   ecall                                     ;
_l59:   la x21, _l91                                      ;
        lb x8, -0(x21)                            ;
_l60:   fadd.s f29, f4, f10, rtz                  ;
_l61:   xor x5, x5, x5                            ;
        addi x2, zero, 1                          ;
        slli x2, x2, 8                            ;
        add x5, x5, x2                            ;
        csrrc x24, sepc, x5                       ;
_l62:   fcvt.s.wu f17, x25, dyn                   ;
_l63:   bne x8, x8, _l124                                 ;
_l64:   mulhsu x28, x5, x26                       ;
_l65:   fsgnjx.s f23, f0, f25                     ;
_l66:   fsgnjn.s f17, f24, f12                    ;
_l67:   fcvt.lu.s x4, f0, rup                     ;
_l68:   srlw x20, x17, x18                        ;
_l69:   fcvt.w.s x13, f15, rne                    ;
_l70:   feq.s x23, f1, f16                        ;
_l71:   slti x29, x27, 750                        ;
_l72:   la x30, _l84                              ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l73:   la x4, d_0_26                             ;
        addi x4, x4, -24                          ;
        amoand.d x18, x17, (x4)                   ;
_l74:   blt x28, x9, _l98                                 ;
_l75:   remu x4, x28, x24                         ;
_l76:   fcvt.s.l f12, x5, rne                     ;
_l77:   sraiw x26, x25, 22                        ;
_l78:   la x22, d_2_23                            ;
        sb x22, -18(x22)                          ;
_l79:   la x18, _l111                                      ;
        lh x21, -14(x18)                          ;
_l80:   fclass.s x6, f16                          ;
_l81:   divuw x5, x15, x21                        ;
_l82:   sraiw x5, x24, 5                          ;
_l83:   divu x28, x28, x24                        ;
_l84:   remw x2, x7, x28                          ;
_l85:   ebreak                                    ;
_l86:   srli x22, x15, 19                         ;
_l87:   ecall                                     ;
_l88:   div x17, x13, x4                          ;
_l89:   blt x21, x20, _l128                                ;
_l90:   csrrwi x17, pmpcfg0, 10                   ;
_l91:   la x20, _l114                                     ;
        csrrw zero, sepc, x20                     ;
        sret                                      ;
_l92:   xori x8, x5, 2047                         ;
_l93:   la x29, d_1_13                            ;
        sh x12, 24(x29)                           ;
_l94:   fmsub.s f18, f4, f12, f1, rup             ;
_l95:   la x21, d_4_15                            ;
        ld x19, 0(x21)                            ;
_l96:   la x18, d_4_17                            ;
        lwu x14, 28(x18)                          ;
_l97:   la x18, d_5_14                            ;
        lb x15, 30(x18)                           ;
_l98:   la x10, _l109                                      ;
        srai x10, x10, 1                          ;
        csrrc x6, pmpaddr6, x10                   ;
_l99:   la x14, d_4_8                             ;
        ld x21, 0(x14)                            ;
_l100:  bne x9, x21, _l105                                 ;
_l101:  la x16, d_0_14                            ;
        lbu x6, 6(x16)                            ;
_l102:  sraiw x7, x16, 0                          ;
_l103:  srliw x20, x13, 26                        ;
_l104:  la x25, d_4_24                            ;
        sb x14, 5(x25)                            ;
_l105:  fmadd.s f29, f18, f20, f17, rup           ;
_l106:  fence.i                                   ;
_l107:  rem x27, x4, x26                          ;
_l108:  la x22, d_1_21                            ;
        addi x22, x22, 0                          ;
        amomin.d x23, x17, (x22)                  ;
_l109:  la x24, d_4_16                            ;
        addi x24, x24, -24                        ;
        amoand.d x22, x20, (x24)                  ;
_l110:  xori x0, x1, 20                           ;
_l111:  flt.s x20, f31, f23                       ;
_l112:  la x12, d_2_14                            ;
        addi x12, x12, 12                         ;
        amoor.w x14, x20, (x12)                   ;
_l113:  la x15, d_0_26                            ;
        sh x12, 10(x15)                           ;
_l114:  ecall                                     ;
_l115:  slti x23, x11, -1990                      ;
_l116:  fmv.w.x f28, x18                          ;
_l117:  fmv.w.x f15, x20                          ;
_l118:  la x23, d_3_27                            ;
        sw x2, 28(x23)                            ;
_l119:  fcvt.s.lu f20, x22, rne                   ;
_l120:  fmin.s f18, f10, f29                      ;
_l121:  divuw x0, x18, x13                        ;
_l122:  la x15, d_2_23                            ;
        lhu x8, 24(x15)                           ;
_l123:  la x29, d_5_27                            ;
        lhu x9, 6(x29)                            ;
_l124:  la x20, d_1_5                             ;
        sh x29, 14(x20)                           ;
_l125:  la x8, _l129                              ;
        csrrw zero, mepc, x8                      ;
        mret                                      ;
_l126:  la x10, d_0_13                            ;
        addi x10, x10, -8                         ;
        amominu.w x18, x20, (x10)                 ;
_l127:  fmv.w.x f3, x21                           ;
_l128:  la x17, d_5_16                            ;
        addi x17, x17, -0                         ;
        amomaxu.d x27, x20, (x17)                 ;
_l129:  la x7, _l130                                      ;
        csrrw zero, uepc, x7                      ;
        uret                                      ;
_l130:;
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
                .dword 0xa7d413300afd77a0, 0x4561d636e05d6c16
                .dword 0xabb86805c161bb71, 0xf70b6c441a735435
d_0_0:          .dword 0x4e4433bfcec21800, 0x10f73019ced89c10
d_0_1:          .dword 0xd4524887a05664b4, 0x9e314d1dd333611f
d_0_2:          .dword 0xb4b88c91639b9dce, 0x5df722ea76b4e9b9
d_0_3:          .dword 0xa84d0fceabb8af2e, 0xd176f252eef04a24
d_0_4:          .dword 0x193f9847ebc8a896, 0x65045535f4576c70
d_0_5:          .dword 0x142cf8c953141465, 0x14dd1e1c6fb84035
d_0_6:          .dword 0x17422b03c3f182f6, 0x42372e63e2d341b3
d_0_7:          .dword 0x722f110e198a111c, 0xcdeb98cae13580f2
d_0_8:          .dword 0xd69e55777c438e90, 0xef5c82909baf66ed
d_0_9:          .dword 0x016aec9238140043, 0x60ea41ea12b65876
d_0_10:         .dword 0xbb661ab1f9f32365, 0x539ed57126f54ccf
d_0_11:         .dword 0x5558e416b055e17f, 0x8c2f3070e937cbc2
d_0_12:         .dword 0xccfaf2fcb83d6979, 0x2e89112849e1065a
d_0_13:         .dword 0xc409ed2f43c6b28b, 0xa7fb0d8686791b75
d_0_14:         .dword 0x038677b4741a77e0, 0xec45050c2bb75db8
d_0_15:         .dword 0xc73c72ee3a52eb79, 0x24308f9c903d9fab
d_0_16:         .dword 0x80ed6842f277987a, 0x74d03b83fd738e60
d_0_17:         .dword 0x5cbba7fd0146fb77, 0xca8fe4308f9ebc21
d_0_18:         .dword 0xc980e567d4a6ec03, 0xf78505ffbe88571d
d_0_19:         .dword 0xe6c902fe8e230a33, 0x23aef8e74cb8170e
d_0_20:         .dword 0xa57745de368187d6, 0x077a185c864d53a2
d_0_21:         .dword 0xe674e06d976227fc, 0x2a7b5667c9c72b0d
d_0_22:         .dword 0xe2bc76b96a30e8c3, 0xf2837ed7a7451fc8
d_0_23:         .dword 0x44ca288ab4351e44, 0x3c144776b852fc0f
d_0_24:         .dword 0xfbba5de8f7580cc0, 0x3e07505a51af1fce
d_0_25:         .dword 0x4b4f5e44d868b461, 0x1c647c4228feb029
d_0_26:         .dword 0x2f7da56dc27890c1, 0xb9ecc09d1c70f9b9
d_0_27:         .dword 0x77ee08f576324131, 0x624db0cfba70b33c
                .dword 0xca29dfbcd5e76238, 0x4fbc07965b091832
                .dword 0xc51970eb6e49d057, 0xe3cfef3f26fb30b8
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0xcb44c7424744cf4a, 0x275f11bc2e4a2b94
                .dword 0x9f9fd7f344694b85, 0x457f8f3c292e89ea
d_1_0:          .dword 0x4a811780c99417b1, 0xf93824ef3f93906d
d_1_1:          .dword 0x2c4224140924268e, 0x00398fa1445ffeac
d_1_2:          .dword 0x264d8c4be26a43ff, 0x023a07e447f92527
d_1_3:          .dword 0xc0768c2be8420f58, 0x4bf8f4068847cf77
d_1_4:          .dword 0xda32a775eef9dd6f, 0x860586b8c475def6
d_1_5:          .dword 0x686de952595acd04, 0x959c47ffb215816e
d_1_6:          .dword 0xd87edd6447dcb0e0, 0x6f27e61aece94baa
d_1_7:          .dword 0xa3a4852ce3100ac9, 0x440b9caad0e1d2f1
d_1_8:          .dword 0x3191468d85cd7ee8, 0x9ccf6cef98f4f67b
d_1_9:          .dword 0xa605b49342cca30e, 0x17e30bcbdf1afe1a
d_1_10:         .dword 0x1f688ca2526b490e, 0xc3f37beb038486b5
d_1_11:         .dword 0xd2f620107f80e279, 0xa41c42131ea2830b
d_1_12:         .dword 0x9527aa53736e36ef, 0x619ac9d7b7a0b036
d_1_13:         .dword 0x53e4ac59bdbd2a94, 0x76a79b4c04c0891a
d_1_14:         .dword 0xeb68bccd05fbeee4, 0x86eb7728bfbf78f4
d_1_15:         .dword 0x19b610496c7d5cfa, 0x9e4e9ee9f723acd8
d_1_16:         .dword 0x96aa8c4478ebf214, 0x38342ab8c69fb07c
d_1_17:         .dword 0xbd5a8c93e1a83f53, 0xc686dd83a0219bc0
d_1_18:         .dword 0x7ce01ea3906cf457, 0xf934ed724c2660be
d_1_19:         .dword 0xe4afa8cd84b131cf, 0x88a541f58eadbee3
d_1_20:         .dword 0x42ade78fb7f15e4f, 0x9b29547fc0cbdebe
d_1_21:         .dword 0x3f241ef4b0e1eeab, 0xeda800f63ad904c0
d_1_22:         .dword 0x585d8ed24c31ac93, 0xa06e4cc1328a3362
d_1_23:         .dword 0xd230552a7e8a8a2f, 0x2fb251bdfad3ca87
d_1_24:         .dword 0x2d70e59ea0b160e1, 0x2d85bbb56370710f
d_1_25:         .dword 0xa126efcae34e2f0c, 0xc7764d396aad2ebf
d_1_26:         .dword 0xce742e1f5d2969a2, 0xbf50b91f1759c9ea
d_1_27:         .dword 0x2b301065841e02e6, 0x7528f69b61cd72ae
                .dword 0xbbc980178b5e3c85, 0x8d760efcd85e10aa
                .dword 0x94e9dcec9778eaff, 0x78d4b1725b18cec5
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0x439b3bac89929a9a, 0xb8b1cb8e8a1be820
                .dword 0xb37fdf7edf76fde9, 0x1d842ec399950800
d_2_0:          .dword 0xa2b46f7dfa62b88d, 0x583c594bc6ff55b1
d_2_1:          .dword 0xaf0f13d349cecf3b, 0x7ba3f5f10d9b4e4e
d_2_2:          .dword 0x9a4008e8e8b51916, 0x0f33c40d03d026f3
d_2_3:          .dword 0x95f51a63ba9d9311, 0xd29f3570c5916ae7
d_2_4:          .dword 0xca4786cd6f23f6f4, 0x6513dd261ebe3987
d_2_5:          .dword 0xcd04ca6d4a7145b1, 0x151ee9a062df6d64
d_2_6:          .dword 0x62cf750bf1a01a52, 0x7e5b068739cbce78
d_2_7:          .dword 0xe3902987e3f8a66b, 0x70db47eb3dcbdb08
d_2_8:          .dword 0xebdda9b3e37e6eae, 0xa567b161c8cf6890
d_2_9:          .dword 0xa62de29a7196c2c5, 0x5b4f61614f4bd7f8
d_2_10:         .dword 0xaba9d35a0526d0a9, 0x8c25e0afd112fcf3
d_2_11:         .dword 0x3b426a82ec7116fe, 0x7312c58184321a0b
d_2_12:         .dword 0xe583c55cabfba2a7, 0x96ee6ca3aa52a541
d_2_13:         .dword 0xc3f8aed3e65cce17, 0xf95d58f1994da508
d_2_14:         .dword 0x4af2d1e926a0aff2, 0x94cce16bc5d3e900
d_2_15:         .dword 0xeff1080fe944d3b6, 0xeb9848b6b226f3e6
d_2_16:         .dword 0xe3c1b828cc96988a, 0x65df159d1c2fbf50
d_2_17:         .dword 0x51b082bc20d211ad, 0xb02eb9b4115a67c3
d_2_18:         .dword 0x868522bd4c68c79a, 0x721b0efabc183a13
d_2_19:         .dword 0x7694df2d4567c4e7, 0x362b2767b1929a9e
d_2_20:         .dword 0xd5c49dc6f578139d, 0x236cf578f55040e4
d_2_21:         .dword 0xcdea8d99e17ddcf3, 0x6b31432a3952e5b3
d_2_22:         .dword 0xb5fb838f93f47d71, 0x91b6b13d216f9df1
d_2_23:         .dword 0xba83d8ffc0efd886, 0xe106df3bb9d18809
d_2_24:         .dword 0xcef0dfe60187c275, 0xc3cfded066531766
d_2_25:         .dword 0xd5bc1d941c252e7c, 0x48de0c0272f8dc24
d_2_26:         .dword 0xe80fb599eb149341, 0x4af1c07b69b0f55a
d_2_27:         .dword 0x7cd7546be60ae0fe, 0xd524aa4756c8f1fc
                .dword 0x677bd01ff82952bd, 0x75e87ae094dda15a
                .dword 0x206b2614bb927cb3, 0xe070b0ed530cd4b1
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0xd16774cdeff366bf, 0xcdcbc717f8876449
                .dword 0x0fce0c2ea1f794bb, 0xad93c078f0746f43
d_3_0:          .dword 0x4d098836a6191ebf, 0x1f6a4dd968dce3ac
d_3_1:          .dword 0xdf128cbb1b1d109f, 0x659dca69813d14fb
d_3_2:          .dword 0x04c2b5a22d0b9ae9, 0xd21bc9de6a10aa7d
d_3_3:          .dword 0x6cf023bb99cc0c19, 0x7f3a9af3a1db7b25
d_3_4:          .dword 0x6253ca0b7000c316, 0x4a5ce0dfb1170ce2
d_3_5:          .dword 0x3f3e17cb607fa938, 0xc468b11516c9cdfc
d_3_6:          .dword 0xb26d3f936a7ab6d8, 0x8428fa0660471067
d_3_7:          .dword 0x6b9572ca16b06ed5, 0x7f3f3f121896ac80
d_3_8:          .dword 0x471343e548c999e0, 0x79eea05235287321
d_3_9:          .dword 0xa90b8357f39aab79, 0x4f242d43d081be6a
d_3_10:         .dword 0x379d80768c20c548, 0xb7b04d069dd4aa54
d_3_11:         .dword 0x7e28f0ab5622b282, 0x2a0801a92fcca53e
d_3_12:         .dword 0x90988c0e8b01f467, 0xef7796a266ad556a
d_3_13:         .dword 0xed71205284643adc, 0x398ebc5ca6b0d060
d_3_14:         .dword 0x9d25f2680d066e19, 0x14f321d6e463404e
d_3_15:         .dword 0x53205efdf3c21bc2, 0xebc1f069115d491d
d_3_16:         .dword 0x0eb10411e35c40f1, 0xb77a0f5408d7bf4f
d_3_17:         .dword 0xa8c02706b4d34a01, 0xd75d0bd43bb7701f
d_3_18:         .dword 0x30092c482557da17, 0x6477d0376570b855
d_3_19:         .dword 0xface693229f750b7, 0x71b663336ab8e132
d_3_20:         .dword 0x281367d2f182c649, 0xf95ddc5947daf931
d_3_21:         .dword 0x8a77f190cc4d28f9, 0x6b6ad08dacccba24
d_3_22:         .dword 0xe2dbf6631ca2fef3, 0x8c25bfc349849fff
d_3_23:         .dword 0x2f59ae5e77245c9a, 0x76c6df7cd1601cb3
d_3_24:         .dword 0x7a8a5ad0a1f54d10, 0x3d1d5d923ab88f27
d_3_25:         .dword 0x8b17060c2ba7895a, 0x5430cc1e3c4986da
d_3_26:         .dword 0xbcadc00bf77bda91, 0x4cafc5092ca9b577
d_3_27:         .dword 0xedcf48d2c3b42e97, 0xb7e5bbedb79d2ce4
                .dword 0x9f19a167e08c4a6b, 0x54c80f7745c53e41
                .dword 0xef33a00b1ae11da9, 0xac4b2134511b51a1
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x52de3bc429afc97c, 0xbf9ce225d6adf522
                .dword 0xedba6317108d1c23, 0x5e6f1c92bf4bb477
d_4_0:          .dword 0x802d92ed0920b879, 0xe635bb80b9396b13
d_4_1:          .dword 0xd323e4400b5f4b21, 0x64ed9b41c721ae92
d_4_2:          .dword 0x63fe084c1b07ce02, 0x6de61949a3ff2c8f
d_4_3:          .dword 0x5337162821835689, 0xa0742d9ab2928874
d_4_4:          .dword 0x35f04ed0ffd50b55, 0x03c1efe25dcde583
d_4_5:          .dword 0xdc9794e9483c0e5f, 0xa32a8b6eb06440aa
d_4_6:          .dword 0x3c4368f72848655f, 0x775495650dca18bb
d_4_7:          .dword 0x99c7d5d0abcf8833, 0x360726b00a2d0c52
d_4_8:          .dword 0xdfcfd0aa9bb5384a, 0x0cce35042d2e1657
d_4_9:          .dword 0x335f90de7082e19d, 0x2369de51124980d9
d_4_10:         .dword 0xfa2b1ec45f728887, 0x708dc3552f8ae8a3
d_4_11:         .dword 0x2dc7ffe2b88f1aff, 0xac0b55a10c595b1c
d_4_12:         .dword 0x3491a6f5d2e3c001, 0x9efd09c2092e3a8e
d_4_13:         .dword 0x2495ef701eafeafd, 0x539b98049344cb6c
d_4_14:         .dword 0x60e673bd99e4db0c, 0xae9629580941c883
d_4_15:         .dword 0x7d74cd4872178941, 0xd2ce2731a464979f
d_4_16:         .dword 0xadb2a09d2a09fb3f, 0x0b3ca64f0c8f59e4
d_4_17:         .dword 0xe0169c25ca107f33, 0xcf4535ab2a23cec8
d_4_18:         .dword 0xe790d29f2171861f, 0xbf0984268c7df3bc
d_4_19:         .dword 0xa7699b6f68af16e5, 0x48cffea805cab43d
d_4_20:         .dword 0x2df31cdf0a0b817a, 0x6dfadc2ecc0e35cb
d_4_21:         .dword 0x17b6ec99d7518d69, 0xd9a714875249b4dc
d_4_22:         .dword 0x73efd75daf5981e1, 0x7804c651198a7a4e
d_4_23:         .dword 0xeec2d4f481585a34, 0xd73f2afe0d78c52d
d_4_24:         .dword 0x627146ccb8ab31e3, 0x5e0c1e5e84b7d78a
d_4_25:         .dword 0x5c5de88acbf5724b, 0x0e54a10c63c36c6e
d_4_26:         .dword 0x92e07dbcbe3ae438, 0x99f3ad6e7a181beb
d_4_27:         .dword 0x04b1d72681852c47, 0x1aefafa5f144108e
                .dword 0x78a054b865332d01, 0x6eaa755e728e1cee
                .dword 0x3bd20585778d1203, 0xb26595a1e2faa3d9
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0x26520ce14cfb9cb1, 0xcf84c8b742f0a43b
                .dword 0x049d45489f4f9ea4, 0x6f06e74616c187ac
d_5_0:          .dword 0xc702751fc62074d5, 0x69b056ac5e84bdce
d_5_1:          .dword 0x24b58c32b345ff44, 0x6ed46263b9ac5374
d_5_2:          .dword 0x8240ad15cd18a5cc, 0xe24b4775c90d8f17
d_5_3:          .dword 0x84f40fd1078171b3, 0x661381119358b33e
d_5_4:          .dword 0x9f182546cc458760, 0x711d983af52bfa49
d_5_5:          .dword 0x348163d9f7094003, 0x0b599dbbcfba7916
d_5_6:          .dword 0x7d0637243edc59bd, 0xeb14234d63712604
d_5_7:          .dword 0x06584df98b2fa932, 0x4d1bf5c5b199016f
d_5_8:          .dword 0x7bbae7a6979dd13f, 0xad440f759257c3df
d_5_9:          .dword 0xc1eb79dbdfc39f31, 0xa1e4619e6b578f36
d_5_10:         .dword 0x4df71d7d08167552, 0xed16707862d1ddfe
d_5_11:         .dword 0x55d68fb5fa32c100, 0xffc1ad59d93e3db0
d_5_12:         .dword 0x194b794c52a94226, 0xcb16d1a51510eee4
d_5_13:         .dword 0xe2aa73b484f15fb4, 0xcfca5913b71e99ad
d_5_14:         .dword 0x4dc9d1a7f9a7f251, 0xc5a92a25720f716f
d_5_15:         .dword 0x049bc472cde1da66, 0x39a4a69e81d70517
d_5_16:         .dword 0x04e83acb74b7817a, 0xf224165c39e69773
d_5_17:         .dword 0xb83258952adb06bf, 0x6114d6da432eef02
d_5_18:         .dword 0xcac20d4e04a9cbcc, 0x8442bc45fe6790d3
d_5_19:         .dword 0x12821152f7de524d, 0x4eb614e9d873c219
d_5_20:         .dword 0x67565e7d5795a2c3, 0x3b38018c2191d54b
d_5_21:         .dword 0xc7791bd9fcd12cc3, 0x947d160abda98124
d_5_22:         .dword 0xa019b9be48f14914, 0xc2323b10ff0366df
d_5_23:         .dword 0xaf62ca4bfcd4b56d, 0x0fccbdb81c56400c
d_5_24:         .dword 0x02529eb54e245575, 0xf57255c8faf02e2c
d_5_25:         .dword 0x6148728712e65ca7, 0xe1d6cb8e28e278eb
d_5_26:         .dword 0xd6d44abffd52e743, 0xceeba7cc00809fc6
d_5_27:         .dword 0x6889e7e135fb2530, 0xeb7260959268bebf
                .dword 0x0b54d1431958f03a, 0x3a097ae8870d8a37
                .dword 0x3d162fc84ac8f8da, 0x3c9a508607b724ec
         /* Random data */
_end_data5:
              
 
