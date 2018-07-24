				.text				//marks the start of the source code
				.global _start		//global makes _start visible outside the source code

_start:
				LDR R4, =RESULT		// R4 points to the result location
				LDR R2, [R4, #4]	// R2 holds the number of elements in the list
				ADD R3, R4, #8		// R3 points to the first number
				LDR R0, [R3]		// R0 holds the first number in the list (minimum)
				LDR R5, [R3]		// R5 also holds first number in the list. But we define R5 to contain the maximum value. (maximum)

LOOP:			SUBS R2, R2, #1		// decrement the loop counter
				BEQ CALCULATE		// end loop if counter has reached 0
				ADD R3, R3, #4		// R3 points to the next number in the list
				LDR R1, [R3]		// R1 holds the next number in the list
				CMP R1, R0			// check if it is less than minimum, because we defined R0 to be minimum
				BLT MIN				// if yes, update minimum value
				CMP R1, R5			// if no, check if it is greater than maximum
				BLE LOOP			// if no, branch back to loop. That number was useless. 
				MOV R5, R1			// if yes, update maximum value			
				B LOOP				// branch back to the loop

MIN:			MOV R0, R1			// update minimum value
				B LOOP

CALCULATE:		SUBS R6, R5, R0		// subtract min from max to get the numerator
				LSR R4, R6, #2		// divide by 4. LSR - Logical Shift Right. R4 contains the final result. 

END:			B END				// infinite loop!

RESULT:			.word	0			// memory assigned for result location
N:				.word	8			// number of entries in the list
NUMBERS:		.word	34, 58, 3, 6	// the list data
				.word	17, 81, 8, 4
