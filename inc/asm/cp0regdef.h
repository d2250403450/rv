/*
 * Copyright (C) 1994, 1995, 1996, 1997, 2000, 2001 by Ralf Baechle
 *
 * Copyright (C) 2001, Monta Vista Software
 * Author: jsun@mvista.com or jsun@junsun.net
 */
#ifndef _cp0regdef_h_
#define _cp0regdef_h_

#define CP0_INDEX       x0  //Index into the TLB array
#define CP0_RANDOM      x1  //Randomly generated index into the TLB array
#define CP0_ENTRYLO0    x2  //Low-order portion of the TLB entry for even-numbered virtual pages
#define CP0_ENTRYLO1    x3  //Low-order portion of the TLB entry for odd-numbered virtual pages
#define CP0_CONTEXT     x4  //Pointer to page table entry in memory
#define CP0_PAGEMASK    x5  //Control for variable page size in TLB entries
#define CP0_WIRED       x6  //Controls the number of fixed (“wired”) TLB entries
#define CP0_BADVADDR    x8  //Reports the address for the most recent address-related exception
#define CP0_COUNT       x9  //Processor cycle count
#define CP0_ENTRYHI     x10 //High-order portion of the TLB entry
#define CP0_COMPARE     x11 //Timer interrupt control
#define CP0_STATUS      x12 //Processor status and control
#define CP0_CAUSE       x13 //Cause of last general exception
#define CP0_EPC         x14 //Program counter at last exception
#define CP0_PRID        x15 //Processor identification and revision
#define CP0_CONFIG      x16 //Configuration register
#define CP0_LLADDR      x17 //Load linked address
#define CP0_WATCHLO     x18 //Watchpoint address，用于EJTAG调试
#define CP0_WATCHHI     x19 //Watchpoint control，用于EJTAG调试
#define CP0_XCONTEXT    x20 //XContext in 64-bit implementations
#define CP0_FRAMEMASK   x21
#define CP0_DIAGNOSTIC  x22
#define CP0_PERFORMANCE x25 //Performance counter interface
#define CP0_ECC         x26 //Parity/ECC error control and status
#define CP0_CACHEERR    x27 //Cache parity error control and status
#define CP0_TAGLO       x28 //Low-order portion of cache tag interface
#define CP0_TAGHI       x29 //High-order portion of cache tag interface
#define CP0_ERROREPC    x30 //Program counter at last error


#define STATUSF_IP4 0x100
#define STATUSF_IP2 0x400
#define STATUSF_IP0 0x400
#define STATUS_CU0 0x10000000
#define	STATUS_KUC 0x2
#endif
