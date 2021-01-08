#include <mips/regdef.h>
#include <mips/m32c0.h>
#include <mips/asm.h>
#include <inc/trap.h>
			.data
			.global	KERNEL_SP;
KERNEL_SP:
			.word		0



	.text
	.set noat
	
LEAF(env_pop_tf)
	.set noreorder
	addi	sp,sp,-32
	sw  	ra,28(sp)
	mv		k0, a0			# k0 = &curenv->env_tf
	mtc0	a1, C0_ENTRYHI	# C0_ENTRYHI = ASID，将a1寄存器中的值赋给TLB表项的高阶寄存器

	mfc0	t0,C0_STATUS	# 将处理器状态和控制寄存器的值赋给t0寄存器
	ori		t0,t0,0x3
	xori	t0,t0,0x3
	mtc0	t0,C0_STATUS	# 将t0寄存器中的内容传输给处理器状态和控制寄存器


	lw 		k1, TF_CAUSE(k0)
	mtc0	k1, C0_CAUSE	# 将k1寄存器中的内容赋值给处理器状态与控制寄存器
	lw		v1,	TF_LO(k0)
	lw		v0,	TF_HI(k0)
	mtlo	v1				# 将v1寄存器中的内容赋值到lo寄存器（保存乘法除法结果的寄存器，用于恢复现场）
	lw		v1,	TF_EPC(k0)
	mthi	v0				# 将v0寄存器中的内容赋值到hi寄存器（保存乘法除法结果的寄存器，用于恢复现场）
	mtc0	v1,	C0_EPC		# 将v1寄存器中的内容赋值到EPC寄存器（包含处理异常之后恢复处理的地址）
	lw		x31,TF_REG31(k0)
	lw		x30,TF_REG30(k0)
	#lw		x29,TF_REG29(k0)															
	lw		x28,TF_REG28(k0)
	lw		x25,TF_REG25(k0)
	lw		x24,TF_REG24(k0)
	lw		x23,TF_REG23(k0)
	lw		x22,TF_REG22(k0)
	lw		x21,TF_REG21(k0)
	lw		x20,TF_REG20(k0)
	lw		x19,TF_REG19(k0)
	lw		x18,TF_REG18(k0)
	lw		x17,TF_REG17(k0)
	lw		x16,TF_REG16(k0)
	lw		x15,TF_REG15(k0)
	lw		x14,TF_REG14(k0)
	lw		x13,TF_REG13(k0)
	lw		x12,TF_REG12(k0)
	lw		x11,TF_REG11(k0)
	lw		x10,TF_REG10(k0)
	lw		x9,TF_REG9(k0)
	lw		x8,TF_REG8(k0)
	lw		x7,TF_REG7(k0)
	lw		x6,TF_REG6(k0)
	lw		x5,TF_REG5(k0)
	lw		x4,TF_REG4(k0)
	lw		x3,TF_REG3(k0)
	lw		x2,TF_REG2(k0)
	lw		x1,TF_REG1(k0)
	lw		k1,TF_PC(k0) #test
	lw		k0,TF_STATUS(k0)
	#li		k0, 0x10000400		# xt1 = 
	li		k0, 0x10007c01		#!!!!!一会改
	mtc0	k0,C0_STATUS		#将k0寄存器中的值赋给处理器状态和控制寄存器
	
	#jr      k1
	jr	 	k1
	

	nop


	nop
	lw		ra,28(sp)
	addi	sp,sp,32
	nop
	jr 	ra
END(env_pop_tf)
	.set at

LEAF(lcontext)
	.extern	mCONTEXT
	sw		a0,mCONTEXT
	jr	ra
	nop
END(lcontext)

LEAF(jump2entry)
	nop
	jr a0
	nop
END(jump2entry)


LEAF(env_push_tf)
	.set noreorder
	.set at
	# mfc0 	k1, C0_PC
	# subi	k1, k1, 16		 
	# sw 		k1, TF_PC(a0)
	mv 	k0, a0
	mfc0 	k1, C0_STATUS		# 将处理器状态和控制寄存器的值赋给k1寄存器
	sw 		k1, TF_STATUS(k0)
	mfc0    k1, C0_CAUSE		# 将异常原因寄存器中的值赋给k1寄存器
	sw		k1, TF_CAUSE(k0)
	mfc0	k1, C0_ENTRYHI		# 将TLB页表高阶寄存器赋给k1寄存器
	sw  	k1, TF_HI(k0)
	mfc0	k1, C0_ENTRYLO0		# 将奇数编号的虚拟页的TLB条目的低阶寄存器的值赋给k1寄存器
	sw		k1, TF_LO(k0)
	mfc0    k1, C0_EPC			# 将EPC寄存器中的内容赋给k1寄存器（EPC:处理异常之后恢复处理的地址）
	sw 		k1, TF_EPC(k0)
	sw		x31,TF_REG31(k0)
	sw		x30,TF_REG30(k0)
	sw		x29,TF_REG29(k0)															
	sw		x28,TF_REG28(k0)
	sw		x25,TF_REG25(k0)
	sw		x24,TF_REG24(k0)
	sw		x23,TF_REG23(k0)
	sw		x22,TF_REG22(k0)
	sw		x21,TF_REG21(k0)
	sw		x20,TF_REG20(k0)
	sw		x19,TF_REG19(k0)
	sw		x18,TF_REG18(k0)
	sw		x17,TF_REG17(k0)
	sw		x16,TF_REG16(k0)
	sw		x15,TF_REG15(k0)
	sw		x14,TF_REG14(k0)
	sw		x13,TF_REG13(k0)
	sw		x12,TF_REG12(k0)
	sw		x11,TF_REG11(k0)
	sw		x10,TF_REG10(k0)
	sw		x9,TF_REG9(k0)
	sw		x8,TF_REG8(k0)
	sw		x7,TF_REG7(k0)
	sw		x6,TF_REG6(k0)
	sw		x5,TF_REG5(k0)
	sw		x4,TF_REG4(k0)
	sw		x3,TF_REG3(k0)
	sw		x2,TF_REG2(k0)
	sw		x1,TF_REG1(k0)


END(env_push_tf)





