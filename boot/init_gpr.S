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
    li      $1, 0xdeadbeef      // (0xdeadbeef stands out, kseg2 mapped, odd.)

	// Determine how many shadow sets are implemented (in addition to the base register set.)
	// the first time thru the loop it will initialize using $1 set above.
	// At the bottom og the loop, 1 is  subtract from $30
	// and loop back to next_shadow_set to start the next loop and the next lowest set number.
	mfc0	$29, C0_SRSCTL		// read C0_SRSCtl
	ext	    $30, $29, 26, 4		// extract HSS

next_shadow_set:
	// set PSS to shadow set to be initialized
	ins	$29, $30, 6, 4		// insert PSS
	mtc0	$29, C0_SRSCTL		// write C0_SRSCtl

	mv	$1, $1
	mv	$2, $1
	mv	$3, $1
	mv	$4, $1
	mv	$5, $1
	mv	$6, $1
	mv	$7, $1
	mv	$8, $1
	mv	$9, $1
	mv	$10, $1
	mv	$11, $1
	mv	$12, $1
	mv	$13, $1
	mv	$14, $1
	mv	$15, $1
	mv	$16, $1
	mv	$17, $1
	mv	$18, $1
	mv	$19, $1
	mv	$20, $1
	mv	$21, $1
	mv	$22, $1
	mv	$23, $1
	mv	$24, $1
	mv	$25, $1
	mv	$26, $1
	mv	$27, $1
	mv	$28, $1
	mv	$29, $1
	beqz    $30, done_init_gpr // early exit when we get to set 0 so we don't clobber return in $31
	nop
	mv	$30, $1
	mv	$31, $1
	j	next_shadow_set
	add	$30, $30, -1  // Since the code started with the highest set number this decrements to the next lower number


done_init_gpr:
    jr      ra
    nop
END(init_gpr)

