#include <asm/regdef.h>
#include <asm/cp0regdef.h>
#include <asm/asm.h>
#include <trap.h>


/*
* mfc0 rt, rd 将CP0中的rd寄存器内容传输到rt通用寄存器；
* mtc0 rt, rd 将rt通用寄存器中内容传输到CP0中寄存器rd；
*/


.macro STI
	mfc0	t0,	CP0_STATUS	//把处理器状态与控制寄存器中的内容存入t0通用寄存器中
	li		t1, (STATUS_CU0 | 0x1)
	or		t0, t0, t1
	mtc0	t0, CP0_STATUS	//把t0通用寄存器中的内容赋给处理器状态与控制寄存器
	
.endm


.macro CLI
	mfc0	t0, CP0_STATUS	//把处理器状态与控制寄存器中的内容存入t0通用寄存器中
	li		t1, (STATUS_CU0 | 0x1)
	or		t0, t0, t1
	xori	t0, t0, 0x1
	mtc0	t0, CP0_STATUS	//把t0通用寄存器中的内容赋给处理器状态与控制寄存器
.endm

.macro SAVE_ALL    
                                  
		mfc0	k0,CP0_STATUS     //把处理器状态与控制寄存器中的内容存入t0通用寄存器中             
		slli	k0, k0, 3      /* extract cu0 bit */  
		bltz	k0, 1f                            
		nop       
		/*                                       
		 * Called from user mode, new stack      
		 */                                      
		//lui	k1,%hi(kernelsp)                 
		//lw	k1,%lo(kernelsp)(k1)  //not clear right now 
		           
1:				
		mv		k0,sp 
		get_sp      
		mv		k1,sp                     
		sub		sp,k1,TF_SIZE                    
		sw		k0,TF_REG29(sp)                  
		sw		x2,TF_REG2(sp)                   
		mfc0	v0,CP0_STATUS		//把处理器状态与控制寄存器中的内容存入v0通用寄存器中                    
		sw		v0,TF_STATUS(sp)                 
		mfc0	v0,CP0_CAUSE       	//把最近异常原因寄存器中的内容存入v0通用寄存器中              
		sw		v0,TF_CAUSE(sp)                  
		mfc0	v0,CP0_EPC         	//把EJTAG调试异常时最近的程序计数器值存入v0通用寄存器            
		sw		v0,TF_EPC(sp)
		mfc0	v0, CP0_BADVADDR    //把最近异常地址寄存器的内容存器v0通用寄存器  
		sw		v0, TF_BADVADDR(sp)            
		mfhi	v0                  //把hi寄存器的内容存入v0寄存器（保存乘法除法结果的寄存器，用于恢复现场）           
		sw		v0,TF_HI(sp)                     
		mflo	v0                  //把lo寄存器的内容存入v0寄存器（保存乘法除法结果的寄存器，用于恢复现场）            
		sw		v0,TF_LO(sp)                     
		sw		x0,TF_REG0(sp)
		sw		x1,TF_REG1(sp)                    
		//sw	x2,TF_REG2(sp)                   
		sw	x3,TF_REG3(sp)                   
		sw	x4,TF_REG4(sp)                   
		sw	x5,TF_REG5(sp)                   
		sw	x6,TF_REG6(sp)                   
		sw	x7,TF_REG7(sp)                   
		sw	x8,TF_REG8(sp)                   
		sw	x9,TF_REG9(sp)                   
		sw	x10,TF_REG10(sp)                 
		sw	x11,TF_REG11(sp)                 
		sw	x12,TF_REG12(sp)                 
		sw	x13,TF_REG13(sp)                 
		sw	x14,TF_REG14(sp)                 
		sw	x15,TF_REG15(sp)                 
		sw	x16,TF_REG16(sp)                 
		sw	x17,TF_REG17(sp)                 
		sw	x18,TF_REG18(sp)                 
		sw	x19,TF_REG19(sp)                 
		sw	x20,TF_REG20(sp)                 
		sw	x21,TF_REG21(sp)                 
		sw	x22,TF_REG22(sp)                 
		sw	x23,TF_REG23(sp)                 
		sw	x24,TF_REG24(sp)                 
		sw	x25,TF_REG25(sp)                 
		sw	x26,TF_REG26(sp) 				 
		sw	x27,TF_REG27(sp) 				 
		sw	x28,TF_REG28(sp)                 
		sw	x30,TF_REG30(sp)                 
		sw	x31,TF_REG31(sp)
.endm
/*
 * Note that we restore the IE flags from stack. This means
 * that a modified IE mask will be nullified.
 */
.macro RESTORE_SOME                                      
		// .set	mips1                            
		mfc0	t0,CP0_STATUS	//把处理器状态与控制寄存器的内容赋给t0通用寄存器                    
		ori		t0, t0, 0x3                          
		xori	t0, t0, 0x3                          
		mtc0	t0,CP0_STATUS	//把t0通用寄存器的内容赋给处理器状态与控制寄存器                    
		lw		v0,TF_STATUS(sp)             
		li		v1, 0xff00 				 
		and		t0, t0, v1 					 
		nor		v1, x0, v1 				 
		and		v0, v0, v1 					 
		or		v0, v0, t0 					 
		mtc0	v0,CP0_STATUS	//把t0通用寄存器的内容赋给处理器状态与控制寄存器		 
		lw		v1,TF_LO(sp)                                       
		mtlo	v1              //把lo寄存器的内容存入v1寄存器                  
		lw		v0,TF_HI(sp)                     
		lw		v1,TF_EPC(sp)                    
		mthi	v0              //把v1寄存器中的内容赋值到hi寄存器                 
		mtc0	v1,CP0_EPC      //把v1通用寄存器中的内容传输给EPC寄存器（存放EJTAG调试异常时最近的程序计数器值）                 
		lw	x31,TF_REG31(sp)                 
		lw	x30,TF_REG30(sp)                 
		lw	x28,TF_REG28(sp)                 
		lw	x25,TF_REG25(sp)                 
		lw	x24,TF_REG24(sp)                 
		lw	x23,TF_REG23(sp)                 
		lw	x22,TF_REG22(sp)                 
		lw	x21,TF_REG21(sp)                 
		lw	x20,TF_REG20(sp)                 
		lw	x19,TF_REG19(sp)                 
		lw	x18,TF_REG18(sp)                 
		lw	x17,TF_REG17(sp)                 
		lw	x16,TF_REG16(sp)                 
		lw	x15,TF_REG15(sp)                 
		lw	x14,TF_REG14(sp)                 
		lw	x13,TF_REG13(sp)                 
		lw	x12,TF_REG12(sp)                 
		lw	x11,TF_REG11(sp)                 
		lw	x10,TF_REG10(sp)                 
		lw	x9,TF_REG9(sp)                   
		lw	x8,TF_REG8(sp)                   
		lw	x7,TF_REG7(sp)                   
		lw	x6,TF_REG6(sp)                   
		lw	x5,TF_REG5(sp)                   
		lw	x4,TF_REG4(sp)                   
		lw	x3,TF_REG3(sp)                   
		lw	x2,TF_REG2(sp)                   
		lw	x1,TF_REG1(sp)                   
.endm
	
.macro RESTORE_ALL							 
		RESTORE_SOME								 
		lw	sp,TF_REG29(sp)  /* Deallocate stack */  
.endm

.set	noreorder
.macro RESTORE_ALL_AND_RET					 
		RESTORE_SOME							 
		lw	k0,TF_EPC(sp) 				 
		lw	sp,TF_REG29(sp)  /* Deallocate stack */  
		jr	k0 								 
		rfe		//从异常返回时恢复寄存器的内容							 
.endm


.macro get_sp
	mfc0	k1, CP0_CAUSE
	andi	k1, k1, 0x47C			/*relate interrupt point on CPU*/
	xori	k1, k1, 0x400			/*relate interrupt point on CPU*/
	bnez	k1, 1f
	nop
	li		sp, 0x82000000
	j		2f
	nop
1:
	bltz	sp, 2f
	nop
	lw		sp, KERNEL_SP
	nop

2:	nop


.endm


.macro SAVE_TF
	mfc0	k0,CP0_STATUS	//把处理器状态与控制寄存器中的内容赋给k0通用寄存器                  
		sll		k0,3      /* extract cu0 bit */  
		bltz	k0,1f                            
		nop       
		/*                                       
		 * Called from user mode, new stack      
		 */                                      
		//lui	k1,%hi(kernelsp)                 
		//lw	k1,%lo(kernelsp)(k1)  //not clear right now 
		           
1:				
		mv		k0,sp 
		li 		sp, 0x82000000      
		mv		k1,sp                     
		sub		sp,k1,TF_SIZE                    
		sw		k0,TF_REG29(sp)                  
		sw		x2,TF_REG2(sp)                   
		mfc0	v0,CP0_STATUS	//将处理器状态和控制寄存器中的内容赋给v0通用寄存器                    
		sw		v0,TF_STATUS(sp)                 
		mfc0	v0,CP0_CAUSE	//将最近异常原因寄存器中的内容赋给v0通用寄存器                     
		sw		v0,TF_CAUSE(sp)                  
		mfc0	v0,CP0_EPC      //将EPC寄存器中的内容赋给v0通用寄存器                 
		sw		v0,TF_EPC(sp)
		mfc0	v0, CP0_BADVADDR	//将最近异常地址寄存器中的内容赋给v0通用寄存器	        
		sw		v0, TF_BADVADDR(sp)            
		mfhi	v0              //把hi寄存器中的内容存入v0寄存器                 
		sw		v0,TF_HI(sp)                     
		mflo	v0              //把lo寄存器中的内容存入v0寄存器                 
		sw		v0,TF_LO(sp)                     
		sw		x0,TF_REG0(sp)
		sw		x1,TF_REG1(sp)                    
		//sw	x2,TF_REG2(sp)                   
		sw	x3,TF_REG3(sp)                   
		sw	x4,TF_REG4(sp)                   
		sw	x5,TF_REG5(sp)                   
		sw	x6,TF_REG6(sp)                   
		sw	x7,TF_REG7(sp)                   
		sw	x8,TF_REG8(sp)                   
		sw	x9,TF_REG9(sp)                   
		sw	x10,TF_REG10(sp)                 
		sw	x11,TF_REG11(sp)                 
		sw	x12,TF_REG12(sp)                 
		sw	x13,TF_REG13(sp)                 
		sw	x14,TF_REG14(sp)                 
		sw	x15,TF_REG15(sp)                 
		sw	x16,TF_REG16(sp)                 
		sw	x17,TF_REG17(sp)                 
		sw	x18,TF_REG18(sp)                 
		sw	x19,TF_REG19(sp)                 
		sw	x20,TF_REG20(sp)                 
		sw	x21,TF_REG21(sp)                 
		sw	x22,TF_REG22(sp)                 
		sw	x23,TF_REG23(sp)                 
		sw	x24,TF_REG24(sp)                 
		sw	x25,TF_REG25(sp)                 
		sw	x26,TF_REG26(sp) 				 
		sw	x27,TF_REG27(sp) 				 
		sw	x28,TF_REG28(sp)                 
		sw	x30,TF_REG30(sp)                 
		sw	x31,TF_REG31(sp)
		mv	k0, sp			/*may be cause problem*/
.endm
