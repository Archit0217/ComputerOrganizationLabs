	.text
	.equ VGA_PIXEL_BUF_BASE, 0xC8000000
	.equ VGA_CHAR_BUF_BASE, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM
		
VGA_clear_pixelbuff_ASM:	
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_PIXEL_BUF_BASE	//here R3 will have/point to address of pixel buff
	MOV R0, #0

PIXEL_LOOPX:
	MOV R1, #0				// below we LSL by 1 because address for x starts after the first bit
	ADD R4, R3, R0, LSL #1 	//in these loops below we travers the address grid from point o,o to the last one

PIXEL_LOOPY:				
	ADD R5, R4, R1, LSL #10 // we LSL by 10 because address for y starts at 10th bit position
	STRH R2, [R5]		//We store data from R2 into Addre of R5 which is a point in the grid
					    //this point will keep changing as we travers the loop
	ADD R1, R1, #1		//increase rhe counter
	CMP R1, #240
	BLT PIXEL_LOOPY		//loop if y position of grid Less than 240, were still in same colum
	ADD R0, R0, #1
	CMP R0, #320			//loop to next x position if the end is not reached
	BLT PIXEL_LOOPX
	POP {R4-R5}
	BX LR

VGA_draw_point_ASM:
	LDR R3, =319  //these lines below check that were still in the grid!! Otherwise we branch out
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #239
	BXGT LR
	
	LDR R3, =VGA_PIXEL_BUF_BASE // we load address/create pointer
	ADD R3, R3, R0, LSL #1		//add x, y position into address, to get correct grid
	ADD R3, R3, R1, LSL #10		//then we store the data/pixel color as half word into the right/current grid position
	STRH R2, [R3]
	BX LR
	
VGA_clear_charbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_CHAR_BUF_BASE
	MOV R0, #0

CHAR_LOOPX:
	MOV R1, #0
	ADD R4, R3, R0, LSL #1 //very similar to pixel clear, but with slight changes

CHAR_LOOPY:				
	ADD R5, R4, R1, LSL #7 //lsl by 7 because unlike pixel buffer, y position start at bit 7
							//but the rest is very similare!
	STRH R2, [R5]			//can refer to comments for clear pixel, as it follows same logic
	
	ADD R1, R1, #1
	CMP R1, #60
	BLT CHAR_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #80
	BLT CHAR_LOOPX

	POP {R4-R5}
	BX LR

VGA_write_char_ASM:

	LDR R3, =79  //in the first part we verify that we arw within the grid, otherwise we branch out
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #59
	BXGT LR
	
	LDR R3, =VGA_CHAR_BUF_BASE		//we create pointer to addre of vga char buff base
	ADD R3, R3, R0					//shift the x, y by correct amount, to add to base addre
	ADD R3, R3, R1, LSL #7			//so we can write to the correct mem address/grid position
	STRB R2, [R3]					//we store as a byte
	BX LR

VGA_write_byte_ASM:
	LDR R3, =79    //same as before, we check to see that we are within the grid
	CMP R0, #0		//otherwise we branchout
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #59
	BXGT LR
	
	MOV R5, #0	//initialize the Registers to 0
	MOV R6, #0
	MOV R7, #0

	PUSH {R5-R7}

	LDR R3, =VGA_CHAR_BUF_BASE //load addre/create pointer
	ADD R3, R3, R0
	ADD R3, R3, R1, LSL #7 //add the shifter x, y position to get right grid position/addres to write to
	AND R5, R2, #0xF0	//mask first byte
	AND R6, R2, #0x0F // mask second byte, these are done to get a number for first and second position
	LSR R5, R5, #4	//these will be manipulated and then used to create the right offset to get the right
					// Hex_ASCII conversion, to get the right HEX represenation
	LDR R4, =HEX_ASCII //pointer with address of first byte in HEX_ASCII
	ADD R7, R4, R6		// we add the right offset to get the corresponding HEX value rep
	ADD R4, R4, R5
	LDRB R4, [R4]	
	STRB R4, [R3]		//we store the first HEX val

	LDRB R7, [R7]
	STRB R7, [R3,#1]  // we store the second HEX val
	POP {R5-R7}

	BX LR		//then we pop and return to the begining
	
HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 
	.end