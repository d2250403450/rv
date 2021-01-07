/*
 * Copyright (C) 2001 MontaVista Software Inc.
 * Author: Jun Sun, jsun@mvista.com or jsun@junsun.net
 *
 * This program is free software; you can redistribute  it and/or modify it
 * under  the terms of  the GNU General  Public License as published by the
 * Free Software Foundation;  either version 2 of the  License, or (at your
 * option) any later version.
 *
 */

/*
* mfc0 rt, rd 将CP0中的rd寄存器内容传输到rt通用寄存器；
* mtc0 rt, rd 将rt通用寄存器中内容传输到CP0中寄存器rd；
*/

.set nomips16
#include <asm/regdef.h>
#include <asm/cp0regdef.h>
#include <asm/asm.h>
.section .text.exc_vec3
# NESTED(except_vec3, 0, sp)
# 		.set	noat
# 		.set	push
# 		#.set	noreorder



__tlb_refill:
		nop
		j _mips_general_exception
		nop
		.org 0x80
__xtlb_refill_loop:
		nop
		j _mips_general_exception
		nop
		.org 0x100
__cache_error_loop:
		nop
		j _mips_general_exception
		nop

		.org 0x180
_mips_general_exception:
		/*
		 * Register saving is delayed as long as we dont know
		 * which registers really need to be saved.
		 */
#  1:	//j	1b
# 	nop

		sw		sp, exp_sp
		mfc0	k1,CP0_CAUSE	//将异常原因寄存器的内容传输到k1通用寄存器中
		
		la	k0, exception_handlers


		/*
		 * Next lines assumes that the used CPU type has max.
		 * 32 different types of exceptions. We might use this
		 * to implement software exceptions in the future.
		 */

		andi	k1, k1, 0x7c
		add		k0, k0, k1
		lw		k0,(k0)
		nop
		jr	k0
		nop
		# END(except_vec3)
		# .set	at
		# .set	pop


.data
			.globl exp_sp		#save the sp register when exception occur
exp_sp:
			.word 0

			.globl mCONTEXT
mCONTEXT:
			.word 0

			.globl exception_handlers
exception_handlers:
			.word 0:31

			.globl delay
delay:
			.word 0

			.globl tlbra
tlbra:
			.word 0

            .globl temp
temp:
			.word 0

			.section .data.stk
KERNEL_STACK:
			.space 0x8000


			.text
LEAF(_start)

	.set	reorder
	/* Disable interrupts */
	mtc0	zero, CP0_STATUS		//将0号寄存器的值赋给处理器状态和控制寄存器

        /* Disable watch exception. */
        mtc0    zero, CP0_WATCHLO	//将0号寄存器的值赋给watchpoint地址寄存器
        mtc0    zero, CP0_WATCHHI	//将0号寄存器的值赋给watchpoint控制寄存器

	
	/* Zero the BSS */
	#test code 
	li v0, 0x80000000
	li v1, 0x08000060
	sw v1, 0(v0)
	addi v0, v0, 4

	li v1, 0x00000000
	sw v1, 0(v0)
	addi v0, v0, 4

	
	


    la v0, _fbss
	la v1, _end
	beq v0,v1,2f
1:
	addi v0,v0,4
	nop
	sw zero,-4(v0)
	nop
	bne v0,v1,1b
2:

	/* disable kernel mode cache */
	// mfc0	t0, CP0_CONFIG
	// and	t0, ~0x7
	// ori	t0, 0x2
	// mtc0	t0, CP0_CONFIG

	/* set up stack */
	li	sp, 0x80400000
	
	li		t0,0x80400000
	sw		t0,mCONTEXT
	
	// Clear boot interrupt vector bit in Coprocessor 0 Status register
	// macro: mips32_bicsr (SR_BEV);
	mfc0	v0,x12				//将处理器状态与控制寄存器的内容传输到v0寄存器	
	ins		v0,zero,0x16,0x1	//清除v0中第16位，然后将0好寄存器中的低1位，放置到v0中的第16位，合并起来
	mtc0	v0,x12				//将v0寄存器中的内容传输到处理器状态与控制寄存器
	ehb

	/* jump to main */
	jal	ra main
	# li v0, 0x80000000
	# jr v0

loop:
	j	loop
	nop
END(_start)

