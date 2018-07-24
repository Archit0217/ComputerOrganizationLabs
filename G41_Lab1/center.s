			.text					// defnies the start of the source code
			.global _start			// global allows _start to be recognized outside the source code

_start:		LDR R4, =AVG 			// R4 points to the average
			ADD R1, R4, #8			// R1 points to the first number
			LDR R2, [R1]			// R2 holds the value of the first number
			LDR R0, [R4, #-4]		// R0 holds the value of the counter. Or the number of elements. 
			LDR R3, [R4, #4]		// R3 holds the value of sum			

LOOP1:		ADD R3, R3, R2			// SUM = SUM + ARRAY[N]
			ADD R1, R1, #4			// R1 points to the next number in the array
			LDR R2, [R1]			// R2 now holds the value of the next number.
			SUBS R0, R0, #1			// Decrement the loop counter
			BEQ CALCULATE			// When it reaches zero, go to CALCULATE
			B LOOP1					// branch back to loop1 

CALCULATE:	LDR R0, [R4, #-4]		// Here we are resetting some stuff because we need the indexes again. R0 again holds the value of the counter
			ADD R1, R4, #8			// R1 now again points to the first number
			LDR R2, [R1]			// R2 now again holds the value of the first number.
			LSR R3, #3				// divide the sum by 8 to get the average. 

LOOP2:		SUBS R2, R2, R3			// Another loop starts to center the elemetns. array[N] = array[N] - avg 
			STR R2, [R1]			// store the new value back to the current index
			ADD R1, R1, #4			// R1 now points to the next number
			LDR R2, [R1]			// R2 now holds the value of the next number
			SUBS R0, R0, #1			// Decrement the loop counter
			BEQ END					// end loop if counter has reached 0
			B LOOP2					// branch back to the loop 

END:		B END 					// to prevent infinite loop 
			
N:			.word	8				// # of numbers
AVG:		.word	0				// average of the array
SUM:		.word	0				// sum of the array
NUMBERS:	.word	1, 2, 3, 4		// number array
			.word	5, 6, 7, 8
