			.text
			.global _start

_start:		LDR R10, =N 		// R10 points to the number of elements in the list
			LDR R10, [R10]		// R10 holds the number of elements in the list
			LDR R0, [R10, #4]	// R0 holds the first number
			LDR R1, [R10, #8]	// R1 holds the second number
			LDR R2, [R10, #12]	// R2 holds the third number
			LDR R3, [R10, #16]	// R3 holds the fourth number
			BL SR 				// branch to the subroutine. BL stands for Branch and Link
			LDR R0, =RESULT 	// R0 points to the result location
			STR R0, [R0]		// store the result in the defined location

END: 		B END 				// infinite loop

SR:			STR R1, [SP, #-4]!	// Pushing. We don't push R0 because we need a reference to compare to
			STR R2, [SP, #-4]!	// Pushing
			STR R3, [SP, #-4]!	// Pushing

LOOP:		SUBS R10, R10, #1	// decrement loop counter
			BEQ DONE			// end loop if counter reaches 0
			LDR R12, [SP], #4	// Pop the number from top of stack so we can start comparing 
			CMP R0, R12			// compare R0 to R12
			BGE	LOOP			// if R0 > R12, branch to loop so we can pop again
			MOV R0, R12			// else, replace with new max. Swapping. 
			B LOOP 				// branch back to loop so we can pop again

DONE:		BX LR				// Link Register. What does BX mean?

RESULT: 	.word	0			// location for result to be stored
N:			.word	4			// length of list
NUMBERS:	.word	6, 5, 24, 2	// the list data
			
