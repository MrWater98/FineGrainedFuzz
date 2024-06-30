# Assembly file template for fuzzing

#*********************************************************************
# test_template.S
#---------------------------------------------------------------------

#include "riscv_test.h"
#include "test_macros.h"
#include "fuzz_test.h"

#define TESTEND gp

RVTEST_RV64UF

// RVTEST_CODE_BEGIN
        .section .text.init;
        .align  6;
        .weak stvec_handler;
        .weak mtvec_handler;
        .global _start;
_start:
        /* reset vector */
INIT_XREGS
        j reset_vector;
        .align;
init_freg:
INIT_FREGS
        ret
        .align;
trap_stvec:
        clear_sie;
        ecall
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
reset_vector:
        csrwi mstatus, 0;
        RISCV_MULTICORE_DISABLE;
        DELEGATE_NO_TRAPS;
        INIT_SATP;
        INIT_PMP;
        la t0, trap_mtvec;
        csrw mtvec, t0;
        li TESTEND, 0;
        CHECK_XLEN;
        la t0, trap_stvec;
        csrw stvec, t0;
        li t0, (1 << CAUSE_LOAD_PAGE_FAULT) | \
                (1 << CAUSE_STORE_PAGE_FAULT) | \
                (1 << CAUSE_FETCH_PAGE_FAULT) | \
                (1 << CAUSE_MISALIGNED_FETCH) | \
                (1 << CAUSE_USER_ECALL) | \
                (1 << CAUSE_BREAKPOINT);
        csrs medeleg, t0;
  1:    li a0, (MSTATUS_FS & (MSTATUS_FS >> 0)) | \
                (MSTATUS_MPP & (MSTATUS_MPP >> 0));
        csrs mstatus, a0;
        init_mie;
        csrwi fcsr, 0;
        call init_freg
        csrw minstret,zero
        csrr a0, mhartid;
 _fuzz_prefix:
_p0:    csrrci x11, pmpaddr3, 31                  ;
_p1:    csrrsi x14, sip, 17                       ;
_p2:;
        /* Fuzz prefix */
        /**/
_end_prefix:
        la t0, main;
        csrw mepc, t0;
        addi t0, zero, 0;
        mret;
  1:
      
      .align 6;

main:
_fuzz_main:
_l0:    sraiw x9, x0, 31                          ;
_l1:    la x9, _l16                               ;
        csrrw zero, sepc, x9                      ;
        sret                                      ;
_l2:    fcvt.l.s x25, f29, rmm                    ;
_l3:    fclass.s x15, f1                          ;
_l4:    la x27, d_2_25                            ;
        addi x27, x27, 12                         ;
        lr.w x5, (x27)                            ;
_l5:    la x25, _l70                                      ;
        csrrw zero, uepc, x25                     ;
        uret                                      ;
_l6:    la x27, _l57                                      ;
        csrrw zero, uepc, x27                     ;
        uret                                      ;
_l7:    la x8, d_0_23                             ;
        lui x20, 0xffe00                          ;
        xor x8, x8, x20                           ;
        lbu x2, 0(x8)                             ;
_l8:    la x17, d_1_8                             ;
        sw x10, -28(x17)                          ;
_l9:    xori x19, x14, -1438                      ;
_l10:   la x4, d_4_21                             ;
        ld x20, -0(x4)                            ;
_l11:   la x14, d_4_7                             ;
        addi x14, x14, -28                        ;
        lui x23, 0xffe00                          ;
        xor x14, x14, x23                         ;
        amomaxu.w x30, x23, (x14)                 ;
_l12:   fnmsub.s f29, f29, f31, f29, rdn          ;
_l13:   ori x23, x23, 729                         ;
_l14:   jal x25, _l64                                     ;
_l15:   la x7, _l41                               ;
        jalr x10, 0(x7)                           ;
_l16:   csrrwi x7, mcause, 27                     ;
_l17:   la x26, d_5_26                            ;
        addi x26, x26, -28                        ;
        lr.w x15, (x26)                           ;
_l18:   flt.s x24, f22, f12                       ;
_l19:   la x3, d_0_26                             ;
        sd x22, 24(x3)                            ;
_l20:   la x14, _l70                                      ;
        lhu x21, 0(x14)                           ;
_l21:   la x7, d_1_26                             ;
        addi x7, x7, -16                          ;
        lr.d x23, (x7)                            ;
_l22:   lui x3, 149846                            ;
_l23:   fmin.s f24, f14, f30                      ;
_l24:   sllw x11, x26, x20                        ;
_l25:   fcvt.s.lu f16, x21, rmm                   ;
_l26:   la x2, d_0_10                             ;
        addi x2, x2, 8                            ;
        amoswap.d x13, x19, (x2)                  ;
_l27:   la x14, d_3_2                             ;
        addi x14, x14, 16                         ;
        lui x20, 0xffe00                          ;
        xor x14, x14, x20                         ;
        amoswap.d x7, x20, (x14)                  ;
_l28:   srai x12, x2, 57                          ;
_l29:   fmsub.s f1, f1, f17, f12, rmm             ;
_l30:   fsub.s f13, f0, f14, dyn                  ;
_l31:   fmv.x.w x9, f16                           ;
_l32:   divw x20, x27, x6                         ;
_l33:   flt.s x6, f14, f27                        ;
_l34:   la x5, d_1_5                              ;
        addi x5, x5, 20                           ;
        amomin.w x16, x5, (x5)                    ;
_l35:   fnmadd.s f10, f24, f24, f31, dyn          ;
_l36:   divuw x13, x9, x21                        ;
_l37:   la x19, d_2_15                            ;
        srai x19, x19, 1                          ;
        csrrw x21, pmpaddr4, x19                  ;
_l38:   sltiu x1, x9, 1951                        ;
_l39:   fmv.w.x f27, x19                          ;
_l40:   andi x15, x22, 466                        ;
_l41:   la x24, d_4_22                            ;
        addi x24, x24, -8                         ;
        amoor.d x6, x24, (x24)                    ;
_l42:   xor x23, x23, x23                         ;
        addi x28, zero, 3                         ;
        slli x28, x28, 3                          ;
        add x23, x23, x28                         ;
        addi x15, zero, 1                         ;
        slli x15, x15, 17                         ;
        add x23, x23, x15                         ;
        addi x21, zero, 1                         ;
        slli x21, x21, 25                         ;
        add x23, x23, x21                         ;
        csrrs x22, mhartid, x23                   ;
_l43:   fcvt.l.s x4, f0, rdn                      ;
_l44:   la x8, d_2_20                             ;
        sh x24, -0(x8)                            ;
_l45:   csrrci x13, pmpaddr0, 31                  ;
_l46:   fcvt.l.s x21, f24, rdn                    ;
_l47:   la x27, d_4_12                            ;
        addi x27, x27, 0                          ;
        lui x14, 0xffe00                          ;
        xor x27, x27, x14                         ;
        amomax.w x17, x14, (x27)                  ;
_l48:   andi x16, x0, -59                         ;
_l49:   remu x23, x16, x16                        ;
_l50:   addiw x16, x21, -220                      ;
_l51:   la x6, d_1_0                              ;
        srai x6, x6, 1                            ;
        csrrw x12, pmpaddr0, x6                   ;
_l52:   srai x15, x7, 24                          ;
_l53:   la x24, d_1_12                            ;
        sw x30, -20(x24)                          ;
_l54:   addiw x12, x10, 60                        ;
_l55:   mulh x5, x28, x8                          ;
_l56:   sllw x30, x26, x11                        ;
_l57:   divuw x4, x21, x0                         ;
_l58:   mulw x10, x8, x20                         ;
_l59:   fsgnjn.s f29, f4, f17                     ;
_l60:   la x2, d_4_7                              ;
        lui x9, 0xffe00                           ;
        xor x2, x2, x9                            ;
        sh x21, 18(x2)                            ;
_l61:   la x11, d_3_16                            ;
        addi x11, x11, 4                          ;
        amoswap.w x12, x11, (x11)                 ;
_l62:   la x17, d_0_11                            ;
        addi x17, x17, 0                          ;
        amomin.w x25, x11, (x17)                  ;
_l63:   srli x9, x29, 37                          ;
_l64:   fdiv.s f0, f0, f20, rup                   ;
_l65:   fence                                     ;
_l66:   jal x21, _l67                             ;
_l67:   la x6, d_2_0                              ;
        sh x5, -30(x6)                            ;
_l68:   auipc x3, 11                              ;
_l69:   fsgnjx.s f3, f16, f28                     ;
_l70:   divuw x23, x27, x0                        ;
_l71:   la x23, _l107                             ;
        jalr x30, 0(x23)                          ;
_l72:   divuw x2, x12, x26                        ;
_l73:   sltiu x21, x8, 2047                       ;
_l74:   divuw x29, x23, x11                       ;
_l75:   la x30, d_5_26                            ;
        ld x30, 0(x30)                            ;
_l76:   ebreak                                    ;
_l77:   bne x1, x16, _l107                                ;
_l78:   fmv.w.x f9, x13                           ;
_l79:   la x20, d_1_6                             ;
        lb x7, 31(x20)                            ;
_l80:   la x25, _l66                              ;
        lui x22, 0xffe00                          ;
        xor x25, x25, x22                         ;
        lwu x30, 0(x25)                           ;
_l81:   la x21, d_3_14                            ;
        addi x21, x21, -0                         ;
        sc.d x8, x21, (x21)                       ;
_l82:   la x30, _l102                                     ;
        csrrw zero, uepc, x30                     ;
        uret                                      ;
_l83:   la x14, d_1_4                             ;
        lhu x30, -8(x14)                          ;
_l84:   mulh x1, x10, x29                         ;
_l85:   la x8, d_2_16                             ;
        sd x9, -0(x8)                             ;
_l86:   rem x16, x27, x22                         ;
_l87:   la x27, d_2_3                             ;
        lhu x9, 4(x27)                            ;
_l88:   la x22, d_0_9                             ;
        addi x22, x22, 16                         ;
        amoadd.d x10, x11, (x22)                  ;
_l89:   fcvt.s.l f4, x8, dyn                      ;
_l90:   fsgnj.s f4, f28, f19                      ;
_l91:   la x25, _l102                                     ;
        csrrw zero, sepc, x25                     ;
        sret                                      ;
_l92:   fmv.x.w x25, f31                          ;
_l93:   auipc x29, 729                            ;
_l94:   la x17, d_1_23                            ;
        srai x17, x17, 1                          ;
        csrrc x18, pmpaddr2, x17                  ;
_l95:   fmax.s f21, f30, f22                      ;
_l96:   la x6, d_3_12                             ;
        addi x6, x6, 16                           ;
        lr.w x5, (x6)                             ;
_l97:   sllw x18, x23, x15                        ;
_l98:   fsub.s f24, f9, f3, rtz                   ;
_l99:   slli x20, x4, 0                           ;
_l100:  fcvt.wu.s x8, f8, rdn                     ;
_l101:  fence.i                                   ;
_l102:  la x26, d_1_26                            ;
        lhu x12, -6(x26)                          ;
_l103:  beq x10, x24, _l104                       ;
_l104:  bge x17, x24, _l110                               ;
_l105:  xor x30, x30, x30                         ;
        addi x14, zero, 3                         ;
        slli x14, x14, 29                         ;
        add x30, x30, x14                         ;
        addi x7, zero, 3                          ;
        slli x7, x7, 16                           ;
        add x30, x30, x7                          ;
        csrrs x23, mscratch, x30                  ;
_l106:  fcvt.l.s x11, f17, rmm                    ;
_l107:  csrrwi x4, medeleg, 26                    ;
_l108:  la x22, d_1_2                             ;
        flw f1, -24(x22)                          ;
_l109:  subw x22, x29, x5                         ;
_l110:  remu x13, x10, x29                        ;
_l111:  fence.i                                   ;
_l112:  la x25, d_3_2                             ;
        lh x29, 26(x25)                           ;
_l113:  fnmadd.s f31, f17, f29, f31, rdn          ;
_l114:  addw x13, x13, x16                        ;
_l115:;
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

PT_BASES

    .section .data.random0;
    .align  8;

_random_data0:
                .dword 0x00565d7cf9a8c44b, 0x0dfdde53a9c94e03
                .dword 0x2dd349e22c93ac6a, 0xf386b525ac78c9c5
d_0_0:          .dword 0x9c95e0997f47407d, 0x43296bed697030af
d_0_1:          .dword 0xfc6874e2d62aadbd, 0xd2fd788a14c8c200
d_0_2:          .dword 0x9501301e4786e107, 0x72c230b34e5213b8
d_0_3:          .dword 0x735cc65295895b27, 0x9fa62f5dc07759e7
d_0_4:          .dword 0x46356376e65ebf15, 0x1bd9175563a83def
d_0_5:          .dword 0x6513fa1b86a48c81, 0xe28477b45aed2455
d_0_6:          .dword 0xb6d4f98afde34892, 0x7c42b99feff1ccca
d_0_7:          .dword 0xdd4f7e4502c3e70d, 0x565aa92f6a6a7e95
d_0_8:          .dword 0xecec7bb79fbe0ad7, 0x7792459d23de86ee
d_0_9:          .dword 0xd247bdb44dd3dcd5, 0xdaee31542aee5f1c
d_0_10:         .dword 0x2e40100e722c64c8, 0x04580364d5e94d71
d_0_11:         .dword 0xa06619340d017e47, 0x4814162962e613c5
d_0_12:         .dword 0xd4ab9f307ab6bb5a, 0xc178e6c5d420a143
d_0_13:         .dword 0x511f734dceb51782, 0x17cf4c49589fb12d
d_0_14:         .dword 0x3f4287ae97c052d0, 0xfded1cfe4b6fc869
d_0_15:         .dword 0xc3feeb3f6b1cc8d1, 0x8b0c663f368c21d6
d_0_16:         .dword 0x15bb0b8e20c2d16b, 0x96000d7621ed0d83
d_0_17:         .dword 0x1788536a663ed053, 0x1036411bb3559d35
d_0_18:         .dword 0xa2d300b69cbc2504, 0xe940f3f13f9a00d1
d_0_19:         .dword 0x16b00abbe82150d6, 0x3b746925f1501e61
d_0_20:         .dword 0xada68d314814ba37, 0x3bf18ef31a1c4bee
d_0_21:         .dword 0x962e079c867b9070, 0x48492c8b45be97db
d_0_22:         .dword 0x3f4018ff0cf7e31f, 0x1703d91d8ab8f213
d_0_23:         .dword 0xe8f2c9d873f9ac8d, 0xb3fe9c6cb928338d
d_0_24:         .dword 0x27516bd035cd3390, 0x09d8f7ce23c24021
d_0_25:         .dword 0x2b82302146578b25, 0xd02cfc45d58b893e
d_0_26:         .dword 0xb9eb03aa2925dbbc, 0x0f00a15c234311f9
d_0_27:         .dword 0x65611dc53e087ca2, 0x9a4a21a9b188bcdd
                .dword 0xa8f6e859f921baa0, 0x4fece81ef3d8e794
                .dword 0x21bc973068792ad5, 0xa8ced4148088e316
        /* Random data */
_end_data0:
                 

    .section .data.random1;
    .align  8;

_random_data1:
                .dword 0x6c835d9e38f9c801, 0x509d5dba2cc18fde
                .dword 0xb2c137281141f671, 0x4137529cbabea2d8
d_1_0:          .dword 0x15cad9ff7970082a, 0x1196f5d92283f18b
d_1_1:          .dword 0x1dc08afc1920a5e4, 0x89f882f68e95db44
d_1_2:          .dword 0x5d10f32fa632435c, 0xe77401b9664fdc67
d_1_3:          .dword 0x3492e5d5672bf779, 0xc2e57258fe6e06de
d_1_4:          .dword 0x3a7f9e1ed7025613, 0x98bc1197d93cadb5
d_1_5:          .dword 0x646f340df91a75bf, 0x5d94b41351e39b6b
d_1_6:          .dword 0xaf532b2483ffa334, 0x82d6cb3caed40a7b
d_1_7:          .dword 0x8e47c328e7c5c696, 0x5dd57f6708091a24
d_1_8:          .dword 0x2a16181731f6346f, 0x032626f307e1f48e
d_1_9:          .dword 0x70fc1f3305d8af7f, 0x0aa72b623fc6701f
d_1_10:         .dword 0x7e13a5f04dfd5f20, 0x81a5501e5fcc00a1
d_1_11:         .dword 0xc4b5b2b332a053bd, 0x5397e68c673460fa
d_1_12:         .dword 0x687120f5f5556215, 0xd3a49835ccac682f
d_1_13:         .dword 0xdf768afe365efafd, 0x9dda9a80a594561c
d_1_14:         .dword 0x640a2c2a6ca3d8b8, 0x6d967f00e0aa5abc
d_1_15:         .dword 0xc276dc48e47d0255, 0x351ddd1e5b85268b
d_1_16:         .dword 0x802cf035c83e9793, 0xc759f0e5cae6bd57
d_1_17:         .dword 0x615e4db97b143fa3, 0xfb644a82f80796e6
d_1_18:         .dword 0x2b462c12a41fa3a1, 0xb3e72e39de5c0d41
d_1_19:         .dword 0x0539ef01b5c1ad29, 0xd5632034f0aeb3b0
d_1_20:         .dword 0x67e09209c4ef6795, 0x405ddb53eaf5f453
d_1_21:         .dword 0x9a495711a7e0565c, 0x1f180d7270076d8b
d_1_22:         .dword 0xc6a1b22b456844d7, 0x114dae0fdbe52b56
d_1_23:         .dword 0x7366462c00653cd1, 0xc6327f5347874c5e
d_1_24:         .dword 0x0118f946765de93a, 0x2026eaac0101794a
d_1_25:         .dword 0x3ece33e03e91a06e, 0xc30a6a3f0f1c730f
d_1_26:         .dword 0xf9c328c48699fae3, 0x6671dd09399896ca
d_1_27:         .dword 0xef12f124d010afc2, 0x0c9bba0690b0ab04
                .dword 0x4e86e66595a8ea3c, 0xf4233460aee55e05
                .dword 0xe8060dcc746c67a1, 0x1fded6d240f05d25
        /* Random data */
_end_data1:


    .section .data.random2;
    .align  8;

_random_data2:
                .dword 0xc67321fa760e0e91, 0xdfff77a8623582a8
                .dword 0xace058289b1e937d, 0x15265d2e8900d17f
d_2_0:          .dword 0x2b171fafa4d69f76, 0x4b08b98be9d4e26f
d_2_1:          .dword 0x6989e8278d207219, 0xebad51f09bfaf3cb
d_2_2:          .dword 0x2cb7e682021947c8, 0x11986d0529dfbe5e
d_2_3:          .dword 0x23d9b1394cb7f3cb, 0x1d69b97d5ded8eb7
d_2_4:          .dword 0x4dde1c03b0f13b91, 0x582280b8b8b8ee06
d_2_5:          .dword 0x84e057d8ff48db90, 0x4adae60f7344e0c5
d_2_6:          .dword 0x3115604d9b0a744a, 0x319a915aa79d3679
d_2_7:          .dword 0xe6530aed1d416561, 0xd16bb200b7e007ef
d_2_8:          .dword 0x083a5b010f6da764, 0x8de22cd706388035
d_2_9:          .dword 0xe7a7a9be831ff8cc, 0xfcd91ee07686f15a
d_2_10:         .dword 0x2f74e3a8a04d7c68, 0xc6c961783ae12012
d_2_11:         .dword 0xec881616e319e1a1, 0x3c1b69c2f87eec4e
d_2_12:         .dword 0xcbb9fa6047d406f5, 0x27ef06a39e164979
d_2_13:         .dword 0x33465bafc5a88f49, 0x75496b811aaad65b
d_2_14:         .dword 0xc2ee50ab4b93a03c, 0x6f187867d5b96e20
d_2_15:         .dword 0xe38657741d1bc0a6, 0x1fe39ab6ebcd2e8a
d_2_16:         .dword 0x7a8406b3c0521ce1, 0x6c2058e6666d9b9a
d_2_17:         .dword 0xf85d9b178c1c4d2e, 0xabb19e34bed3dd71
d_2_18:         .dword 0x5ca68f40b19bf871, 0x182f4e5c12469e6e
d_2_19:         .dword 0x2da5bca6a04a902e, 0xb0097e0745e4da6e
d_2_20:         .dword 0x6271eadd6626b462, 0x01ee05e7beba4f9d
d_2_21:         .dword 0xf85eb8e087d3caee, 0x1855f287fe77303d
d_2_22:         .dword 0xb73d082f4b587141, 0x25afe0fb0b71b4d9
d_2_23:         .dword 0xf908f6833f894252, 0xbbd4768124e908fa
d_2_24:         .dword 0x53e08f82a5c8e066, 0xc9d5282d257db5f8
d_2_25:         .dword 0x7302965ddf5b60cd, 0xa66d593fb10553e1
d_2_26:         .dword 0x2ecac822aa4b0930, 0x6df99c4690b892a8
d_2_27:         .dword 0x8d29116c259b1e06, 0xbaead2c7ba58b03f
                .dword 0xe1539e10b489d7a8, 0xbb1c8dc1c1aa91b7
                .dword 0xa3009b4d9ee77ecb, 0x94fbc0a3a3d864fa
         /* Random data */
_end_data2:
                

    .section .data.random3;
    .align  8;

_random_data3:
                .dword 0x801ece845ddf16c7, 0x82d8af316e7bc56b
                .dword 0x87d58d1e440ea5be, 0x0ad2d52994a2b5dd
d_3_0:          .dword 0xf41eb788af65cb57, 0xcad5b0529042d393
d_3_1:          .dword 0x68656ff754526fa8, 0xba42d21ce2cbe718
d_3_2:          .dword 0xf5de9bf7b80c5d02, 0xe0c4055a23f2d5b4
d_3_3:          .dword 0xaadb710557f6bf0f, 0x6ed78e850837975e
d_3_4:          .dword 0x778501ba0d72fbfb, 0x0f1c88bfc12599b3
d_3_5:          .dword 0xd98551571b52b019, 0x628020d4f0571af5
d_3_6:          .dword 0xcb160d27d9e09451, 0x6847a27bd5613be1
d_3_7:          .dword 0x1bb00e5d04609a2f, 0x64d0041fc01bea46
d_3_8:          .dword 0xf30547d9d68fab6d, 0xc03e71fb1ef46fb7
d_3_9:          .dword 0xe69daad3f3d5150d, 0x9d6a82daee78b286
d_3_10:         .dword 0x1ae6a426ffa6a541, 0x058138f9c8ba6c8c
d_3_11:         .dword 0x6ce7eb7cde28ac0d, 0x4ccb3e807f130610
d_3_12:         .dword 0x11cb20c9e2e0b774, 0xbfe884587ecbf049
d_3_13:         .dword 0xc4ee89c00e839945, 0xa4662044a55a3bef
d_3_14:         .dword 0x25474462765a7b1c, 0xe6aff6aa919b3c0a
d_3_15:         .dword 0x6b566b81de86c85d, 0x8379564b1876b224
d_3_16:         .dword 0x13b40a5e9f632af2, 0xcf6e646802c23d26
d_3_17:         .dword 0xe89396783dcf7fdf, 0x91b9c8539c8af3cf
d_3_18:         .dword 0x0f54b9a0b533159c, 0x017d3bfa9587ed49
d_3_19:         .dword 0xc34129147343a58b, 0xbe2998279ce7d425
d_3_20:         .dword 0x3951e3335bb9cb89, 0xab499ef213ff3d20
d_3_21:         .dword 0x51c9bc832b5d2f93, 0x5f9949b348c0cc28
d_3_22:         .dword 0x893443b5611109fa, 0x542f4db1c8008ce1
d_3_23:         .dword 0x98e1cf532455b07d, 0xeed6f1dd90125428
d_3_24:         .dword 0x9eae49141e74f3e0, 0x54f93305302f9dbe
d_3_25:         .dword 0xbc600d45b2b897f6, 0xea69e101bcec9b7b
d_3_26:         .dword 0x9232f3e7fc91e23b, 0x647f71772614aa54
d_3_27:         .dword 0xa4a4f8a86c07a6aa, 0xd1251636877eda45
                .dword 0x067a8087e83955a3, 0x868f71ea89428fa5
                .dword 0xc6468340245445df, 0x58912b4c466a718a
        /* Random data */
_end_data3:


    .section .data.random4;
    .align  8;

_random_data4:
                .dword 0x71f5e1d517309fcf, 0x3135d82039562367
                .dword 0x1a7861cb53ce578a, 0x1bd4889aba9b3fa2
d_4_0:          .dword 0x89f1078cce776eb6, 0xf90cc359d6972170
d_4_1:          .dword 0xbcecff26f12af667, 0x093c4b9ad2f32243
d_4_2:          .dword 0x9b75f267d80e109f, 0x6d07e997672bee49
d_4_3:          .dword 0x6b775a7afcf94a23, 0x6d466370bc817907
d_4_4:          .dword 0xd6cf1c4d3e002693, 0xf4b390c8df1441d3
d_4_5:          .dword 0xe90fc7d9fb747882, 0xf38287eb0d64a586
d_4_6:          .dword 0xfac4147fc12ca034, 0x03b9db60b84c5d06
d_4_7:          .dword 0xbb826d551d077228, 0x487f78de8c2075bd
d_4_8:          .dword 0xf5eef19efc227a94, 0x69504303af530a92
d_4_9:          .dword 0x7aefb32e3395dcc9, 0x998c82d985c4444b
d_4_10:         .dword 0x3e2cb780b994c4c4, 0xa9190d424671f1c8
d_4_11:         .dword 0xd80c971e75f40055, 0x4f6a7f6614f09f98
d_4_12:         .dword 0x6b4bb4de9e2f3b9f, 0xcd6b8e94d90042d4
d_4_13:         .dword 0xaf0cda6de3eeaced, 0xa414c73799329561
d_4_14:         .dword 0x84b81c2c219b8cb7, 0xf8945ed77b29ae13
d_4_15:         .dword 0x61225a7738082f73, 0xc983936a944e195c
d_4_16:         .dword 0x7401762e0d9d161b, 0x175bb2bbbd204273
d_4_17:         .dword 0x31c93f8680c02932, 0xd1d4d9108e6228f1
d_4_18:         .dword 0x6dc131c0a6c7c430, 0x5057b8a708ae70fe
d_4_19:         .dword 0x2baf618e9d04386c, 0xd230e14a4900da0a
d_4_20:         .dword 0x2abdea68c4d0690c, 0xfa8489c4ba5c4d8f
d_4_21:         .dword 0x3b88a36a311e8648, 0xe84c51b68d2ffc75
d_4_22:         .dword 0xa2918a410986258a, 0x46a59eb1c718c964
d_4_23:         .dword 0x2054334a524d3dc2, 0x5314ae89835537b6
d_4_24:         .dword 0x4f45a9a463fa259d, 0x4edb24468596c0df
d_4_25:         .dword 0xc6fecbfe4e283373, 0x407f49d129968dad
d_4_26:         .dword 0x086f301d7fbc4ba5, 0x9e74ac978fedc3db
d_4_27:         .dword 0xf4fe3eab9c75f6f9, 0x759b704270698ea8
                .dword 0xe04db0bcc3fb3600, 0x168e2f8cf97b8971
                .dword 0x9ebf4b66c5af12a4, 0x87df12c29efad7ab
        /* Random data */
_end_data4:


    .section .data.random5;
    .align  8;

_random_data5:
                .dword 0xcba89e58a52d0990, 0x367936288f1b42bf
                .dword 0xe7e54b115e9170ca, 0xcac25c907a678c47
d_5_0:          .dword 0x09c3965c1d7b7d55, 0x83eeed97173589d0
d_5_1:          .dword 0xa6ba9b9de12ce089, 0x442740185935eec9
d_5_2:          .dword 0xd64d9ee10ba971d0, 0x6069555869a55cf5
d_5_3:          .dword 0x6e20518c12d46c2c, 0x07439db2f14cd119
d_5_4:          .dword 0x21e48d00a73ae647, 0x5cf2858d06a96340
d_5_5:          .dword 0x823dcf098e1a3e9d, 0xe8dcfbe03ffcf136
d_5_6:          .dword 0x998596f2e9c3d26d, 0xb28bd354680354b0
d_5_7:          .dword 0x6ddb706b8dfc0881, 0x64bf5864f20af6c9
d_5_8:          .dword 0x6260df533541caa1, 0x67091712c0cb3eaa
d_5_9:          .dword 0x48d9aaf3c1b76599, 0x402597032ad4c11e
d_5_10:         .dword 0x377dd7e6d498001b, 0xaae0070e17399e5c
d_5_11:         .dword 0x474cee299c3b57e7, 0x4bf72fd683f1f5de
d_5_12:         .dword 0xe0781914c41596f1, 0x5e456c9379dfbc42
d_5_13:         .dword 0x25b7782090d83e2a, 0x6b88d535916b2506
d_5_14:         .dword 0xb4e177935c56e15b, 0xbdc07fa8588d5048
d_5_15:         .dword 0xed4aa3deda31a8ae, 0x1a838391486bf8ce
d_5_16:         .dword 0x2146bdb5c9924a7d, 0x3fc43c616cfef1c2
d_5_17:         .dword 0xb2b13691d2feb7c2, 0xda715816a2cf3772
d_5_18:         .dword 0x4b6bb00e11f59463, 0xc6eed49c24392dd8
d_5_19:         .dword 0x9659e2c7624a1461, 0xc61a6bc01e3f4c3f
d_5_20:         .dword 0xc8ac6fe496392489, 0x940a7177a8f585fb
d_5_21:         .dword 0x4c63ff332c494a6c, 0x5b4f9350b8d993ba
d_5_22:         .dword 0x1c98e7b34aecad7b, 0x4b525fac343aef3c
d_5_23:         .dword 0x8deb507b2033788e, 0x48090a87916d0f5a
d_5_24:         .dword 0x41ff33fcb662a50c, 0x24ade9d1e0c69e8c
d_5_25:         .dword 0xb017ec163f9f8478, 0xeede13d35f96f75d
d_5_26:         .dword 0x808a51446efdb538, 0x10e03074746d42ed
d_5_27:         .dword 0xb9a44a07e4ecc669, 0x1b5dfd9394b143d8
                .dword 0x885969c835a3b4f5, 0x504c7c954889ae06
                .dword 0xc75d52076d4e2fd1, 0x8ef3f7a7ca4797dc
         /* Random data */
_end_data5:
              
                 
