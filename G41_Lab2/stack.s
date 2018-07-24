			.text
			.global _start

_start:		LDR R12, =CUSTOM	// We created our own custom stack. CUSTOM points to empty registers so we can keep pushing the numbers
			LDR R10, =N			// R10 points to the number of elements in the list
			LDR R10, [R10]		// R10 holds the number of elements in the list
			LDR R11, =NUMBERS	// R11 points to the first number

LOOP: 		LDR R0, [R11]			// R0 holds the first (currently) number in the list
			STR R0, [R12, #4]!		// push value from R0 to stack by incrementing the stack pointer (R12). The ! means that the value of R12 is also changed. R12 + 4 just means creating space. 
			ADD R11, R11, #4		// Now that pushing has been done. INCREMENT STUFF. point to next number so it can be pushed in the next loop
			SUBS R10, R10, #1		// decrement loop counter
			BEQ POPPING				// leave loop if finished. Branch if equal to 0. End loop when counter recahes 0. 
			B LOOP					// back to start of loop

POPPING: 	LDMDA	R12!, {R0-R2}	// We decrement R12 (because of DA) after each pop. *Load Multiple. Decrement After* each popping to get the next pop. Essentially Popping
									// We use LDM becuase to use LDM, elements have to be in order. This is exactly the definiton of a stack. 
END: 		B END					// infinite loop

N:			 .word	3			// length of list
NUMBERS:	 .word	1, 2, 3		// the numbers
CUSTOM:	 	 .word	0			
