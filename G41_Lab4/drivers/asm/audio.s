.text
	.equ FIFO_SPACE, 0xFF203044
	.equ LEFTDATA, 0xFF203048
	.equ RIGHTDATA, 0xFF20304C	
	.global audio_ASM

audio_ASM:

	MOV R4, #0				// initializing the registers 
	MOV R5, #0
	MOV R6, #0

	PUSH {R4-R8} 
	
	LDR R3, =FIFO_SPACE		 // Making pointer to FIFIO address
	LDR R7, =LEFTDATA 		 // Making pointer to Leftdata and right data address
	LDR R8, =RIGHTDATA
	LDR R2, [R3]			// loading register at loc addre of FIFO
	AND R5, R2, #0xFF000000 // masking the first 6 bytes, to get 2 WSLC bytes
	AND R6, R2, #0x00FF0000 // masking the first 4 and last two bytes to get 2 WSRC bytes
	LSR R5, R5, #24 		// right shift to get number of unsed space in WSLC
							// these bytes contain the number of free spaces left.
	CMP R5, #0 				// if there are no spaces left, branch, otherwise see other, WSRC
	BEQ GOTO
	LSR R6, R6, #16 		// shift this one by 16 bits, 4bytes, to get # of unsed space
	CMP R6, #0
	BEQ GOTO
	
	STR R0, [R7] 			// if space unsed in both, then we can store input, R0 in LEFT and right data reg
	STR R0, [R8]
	MOV  R0, #1	 			// if succesful, put 1 in R0 after words
	POP {R4-R8} 			// pop and return from subroutin
	BX LR

GOTO:						// in the event of WSLC or WSRC being full, we branch here

	MOV R0, #0
	POP {R4-R8}
	BX LR
	.end