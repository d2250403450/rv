/*
 * initcp0.S
 *
 *  Created on: Jan 12, 2011
 *  Author: MIPS TECHNOLOGIES, INC
 *  Common CP0 register initializations
*/
/*
Copyright (c) 2014, Imagination Technologies LLC and Imagination Technologies
Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions in binary form must be built to execute on machines
   implementing the MIPS32(R), MIPS64 and/or microMIPS instruction set
   architectures.

2. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

4. Neither the name of Imagination Technologies LLC, Imagination Technologies Limited
   nor the names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL IMAGINATION TECHNOLOGIES LLC OR IMAGINATION
TECHNOLOGIES LIMITED BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.
*/

#define _BOOTCODE 1

#include "boot.h"
#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>

	.set	noreorder           // Don't allow the assembler to reorder instructions.
	.set	noat                // Don't allow the assembler to use r1(at) for synthetic instr.
/**************************************************************************************
**************************************************************************************/



/*
* mfc0 rt, rd 将CP0中的rd寄存器内容传输到rt通用寄存器；
* mtc0 rt, rd 将rt通用寄存器中内容传输到CP0中寄存器rd；
*/


LEAF(init_cp0)

    // Initialize Status
	li		v1, 0x00400404		// (M_StatusERL | M_StatusIPL1 | M_StatusBEV)
	mtc0	v1, C0_STATUS		// write C0_Status,将v1寄存器中的内容传输到处理器状态与控制寄存器

	// Initialize Watch registers if implemented.
	mfc0	v0, C0_CONFIG1		// read C0_Config1
	ext		v1, v0, 3, 1		// extract bit 3 WR (Watch registers implemented)
								/*将v0寄存器的第3位提取出来放到v1寄存器*/
	beq 	v1, zero, done_wr
	li    	v1, 0x7				// (M_WatchHiI | M_WatchHiR | M_WatchHiW)

	// Clear all possible Watch Status bits and disable watch exceptions
	mtc0	v1, C0_WATCHHI		// write C0_WatchHi0，将v1寄存器中的内容传输到0号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO	// write C0_WatchLo0，将0号寄存器赋给0号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 1	// write C0_WatchHi1，将v1寄存器中的内容传输到1号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 1	// write C0_WatchLo1，将0号寄存器赋给1号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 2	// write C0_WatchHi2，将v1寄存器中的内容传输到2号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 2	// write C0_WatchLo2，将0号寄存器赋给2号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 3	// write C0_WatchHi3，将v1寄存器中的内容传输到3号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 3	// write C0_WatchLo3，将0号寄存器赋给3号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 4	// write C0_WatchHi4，将v1寄存器中的内容传输到4号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 4	// write C0_WatchLo4，将0号寄存器赋给4号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 5	// write C0_WatchHi5，将v1寄存器中的内容传输到5号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 5	// write C0_WatchLo5，将0号寄存器赋给5号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 6	// write C0_WatchHi6，将v1寄存器中的内容传输到6号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 6	// write C0_WatchLo6，将0号寄存器赋给6号watchpoint地址寄存器

	mtc0	v1, C0_WATCHHI, 7	// write C0_WatchHi7，将v1寄存器中的内容传输到7号watchpoint控制寄存器
	mtc0	zero, C0_WATCHLO, 7	// write C0_WatchLo7，将0号寄存器赋给7号watchpoint地址寄存器

done_wr:

	// Clear WP bit to avoid watch exception upon user code entry, IV, and software interrupts.
	mtc0	zero, C0_CAUSE		// write C0_Cause: Init AFTER init of CP0 WatchHi/Lo registers.
								// 将0号寄存器的值赋给异常原因寄存器（CAUSE）
	// Clear timer interrupt. (Count was cleared at the reset vector to allow timing boot.)
	mtc0	zero, C0_COMPARE	// write C0_Compare，将0号寄存器的值赋给比较寄存器（和计数寄存器配合实现定时中断的）

        jr      ra
	nop
END(init_cp0)
