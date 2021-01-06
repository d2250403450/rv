/*
 * init_gpr.S
 *
 *  Created on: Jan 12, 2011
 *      Author: MIPS TECHNOLOGIES, INC
 *  Start of boot code for 24K Family of Cores
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
LEAF(init_gpr)

	// Initialize the general purpose registers and any shadow register sets.
	// Although not necessary, register initialization may be useful during boot,
    // debug, and simulation when certain ways of initializing registers may not work
    // (xor rN, rN, rN for example.)

	// Initialize register sets
    li      x1, 0xdeadbeef      // (0xdeadbeef stands out, kseg2 mapped, odd.)

	// Determine how many shadow sets are implemented (in addition to the base register set.)
	// the first time thru the loop it will initialize using x1 set above.
	// At the bottom og the loop, 1 is  subtract from x30
	// and loop back to next_shadow_set to start the next loop and the next lowest set number.
	mfc0	x29, C0_SRSCTL		// read C0_SRSCtl
	ext	    x30, x29, 26, 4		// extract HSS

next_shadow_set:
	// set PSS to shadow set to be initialized
	ins	x29, x30, 6, 4		// insert PSS
	mtc0	x29, C0_SRSCTL		// write C0_SRSCtl

	mv	x1, x1
	mv	x2, x1
	mv	x3, x1
	mv	x4, x1
	mv	x5, x1
	mv	x6, x1
	mv	x7, x1
	mv	x8, x1
	mv	x9, x1
	mv	x10, x1
	mv	x11, x1
	mv	x12, x1
	mv	x13, x1
	mv	x14, x1
	mv	x15, x1
	mv	x16, x1
	mv	x17, x1
	mv	x18, x1
	mv	x19, x1
	mv	x20, x1
	mv	x21, x1
	mv	x22, x1
	mv	x23, x1
	mv	x24, x1
	mv	x25, x1
	mv	x26, x1
	mv	x27, x1
	mv	x28, x1
	mv	x29, x1
	beqz    x30, done_init_gpr // early exit when we get to set 0 so we don't clobber return in x31
	nop
	mv	x30, x1
	mv	x31, x1
	j	next_shadow_set
	add	x30, x30, -1  // Since the code started with the highest set number this decrements to the next lower number


done_init_gpr:
    jr      ra
    nop
END(init_gpr)

