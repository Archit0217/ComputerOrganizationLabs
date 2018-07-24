			.text				// Marks the starting of the source code
			.global _start		// Global allows _start to be recognized outside the source code

_start:		LDR R12, =N			// get address of input length
			LDR R9, [R12]		// hold value of input length (constant, never changed)
			LDR R12, [R12]		// hold value of input length (used as counter)

OUTER:		SUBS R12, R12, #1	// reduce outer counter by one
			BEQ END				// if counter reaches zero, go to end
			LDR R2, =NUMBERS	// get address of first number
			ADD R3, R2, #4		// get address of second number
			LDR R0, [R2]		// hold first number in R0. Only holding is being done over here. 
			LDR R1, [R3]		// hold second number in R1
			CPY R8, R9			// copy signal length to R8 to be used as inner counter
			
INNER: 		SUBS R8, R8, #1		// reducer inner counter by one
			BEQ OUTER			// if counter reaches zero, go to outer loop

COMPARE:	CMP R1, R0			// check which value is greater
			BGE FINAL			// if second value greater, don't need to do anything and move to FINAL Step.
			MOV R7, R1			// move second value to holding register.R7 is temporary 	SWAPPING
			MOV R1, R0			// move first value to second register		SWAPPING
			MOV R0, R7			// move holding value to first register		SWAPPING

FINAL:		STR R0, [R2]		// stores new values back to the same memory addresses
			STR R1, [R3]		// Similarly						
			ADD R2, R2, #4		// increment pointers					In here we are moving ahead with the loop. So that we can compare the next set of elements. 
			ADD R3, R3, #4		// Similarly
			LDR R0, [R2]		// load next values
			LDR R1, [R3]		// Similarly
			B INNER				// Go to the inner loop again to continue with the inner iteration

END:		B END				// infinite loop
			
N: 			.word	8				// number of entries in the list
NUMBERS:	.word	17, 43, 3, 6	//the list data
			.word	1, 11, 2, 99
