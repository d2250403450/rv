/*
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file "COPYING" in the main directory of this archive
 * for more details.
 *
 * Copyright (C) 1994, 1995 by Ralf Baechle
 */

#ifndef __ASM_MIPS_REGDEF_H
#define __ASM_MIPS_REGDEF_H

/*
 * Symbolic register names for 32 bit ABI
 */
#define zero    x0      /**//* wired zero */
//  #define AT      x1      ？/* assembler temp  - uppercase because of ".set at" */
#define v0      x10     /*a0 return value */
#define v1      x11     /*a1
#define a0      x12     /*a2*//* argument registers */
#define a1      x13     /*a3*/
#define a2      x14     /*a4*/
#define a3      x15     /*a5*/
#define t0      x5      /**//* caller saved */
#define t1      x6      /**/
#define t2      x7      /**/
#define t3      x28     /**/
#define t4      x29     /**/
#define t5      x30     /**/
#define t6      x31     /**/
//#define t7      x15     ？
#define s0      x8      /**//* callee saved */
#define s1      x9      /**/
#define s2      x18     /**/
#define s3      x19     /**/
#define s4      x20     /**/
#define s5      x21     /**/
#define s6      x22     /**/
#define s7      x23     /**/
//#define t8      x24     ？/* caller saved */
//#define t9      x25     ？
//#define jp      x25     ？/* PIC jump register */
#define k0      x26     /*s10*//* kernel scratch */
#define k1      x27     /*s11*/
#define gp      x3     /**//* global pointer */
#define sp      x2     /**//* stack pointer */
#define fp      x24    /**/ /* frame pointer */
#define s8	    x24	   /**/ /* same like fp! */
#define ra      x1     /**//* return address */

#endif /* __ASM_MIPS_REGDEF_H */