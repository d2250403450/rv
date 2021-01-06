/*
 * Copyright (C) 1994, 1995, 1996, 1997, 2000, 2001 by Ralf Baechle
 *
 * Copyright (C) 2001, Monta Vista Software
 * Author: jsun@mvista.com or jsun@junsun.net
 */
#ifndef _cp0regdef_h_
#define _cp0regdef_h_

#define CP0_INDEX       x0
#define CP0_RANDOM      x1
#define CP0_ENTRYLO0    x2
#define CP0_ENTRYLO1    x3
#define CP0_CONTEXT     x4
#define CP0_PAGEMASK    x5
#define CP0_WIRED       x6
#define CP0_BADVADDR    x8
#define CP0_COUNT       x9
#define CP0_ENTRYHI     x10
#define CP0_COMPARE     x11
#define CP0_STATUS      x12
#define CP0_CAUSE       x13
#define CP0_EPC         x14
#define CP0_PRID        x15
#define CP0_CONFIG      x16
#define CP0_LLADDR      x17
#define CP0_WATCHLO     x18
#define CP0_WATCHHI     x19
#define CP0_XCONTEXT    x20
#define CP0_FRAMEMASK   x21
#define CP0_DIAGNOSTIC  x22
#define CP0_PERFORMANCE x25
#define CP0_ECC         x26
#define CP0_CACHEERR    x27
#define CP0_TAGLO       x28
#define CP0_TAGHI       x29
#define CP0_ERROREPC    x30


#define STATUSF_IP4 0x100
#define STATUSF_IP2 0x400
#define STATUSF_IP0 0x400
#define STATUS_CU0 0x10000000
#define	STATUS_KUC 0x2
#endif
