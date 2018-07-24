		.text					// Result is shown in R1
		.global _start

_start:	LDR R4, = REFER 		// Just something so we can reference other things
		LDR R2, [R4, #4] 		// Number of iterations of fibonacci. The MAIN NUMBER whose fibonacci has to be calculated. 
		LDR R6, [R4, #8] 		// Comparing value for init
		LDR R3, [R4, #12] 		// Comparing value for the inner loop. Because when we reach 1, everything's over. 
		LDR R0, [R4, #12] 		// Lower value of the 2 most recent fibonacci numbers. For the moment, same as higher. 
		LDR R5, = POINTER 		// Pointer memory
		STR R0, [R5] 			// Assigns 1 to initial pointer memory
		SUB R5, R5, #4 			// Reassigns pointer's memory location
		STR R1, [R5] 			// Assigns more recent 1 to pointer	
		LDR R1, [R4, #12]  		// Higher value of the 2 most recent fibonacci numbers. For the moment, same as lower


INIT:	CMP R6, R2 			// Initial compare to see if n<2 , returns 1. This is the initial comparison. Skip everything if this condition is satisfied. 
		BLE FIB				// BLE- Signed less than or equal
		B DONE

FIB: 	CMP R3, R2 			// Initial compare statements, outer compare serves as a flag to see if the fibonacci sequence is done. Kinda like an if statement. Because R2 will eventually reach one. 
		BEQ DONE			// As soon as R2 reaches 1, we're over. 
		SUBS R2, R2, #1		// If everything is normal, come to this instruction and decrement the counter
		CMP R2, R3  		// Inner loop, acts as a down counter for the inner loop 
		//BGT FIB 
		LDR R1, [R5]		// R1 and R0 are both 1 at this point 
		LDR R0, [R5, #4] 	// Reloads R0 and R1 values, necessary to reassign what R0 and R1 are after each number iteration
		ADD R7, R0, R1		// R7 adds the individual 1's 
		SUB R5, R5, #4 		// Changes pointer position so that R5 again points to R1. 
		STR R7, [R5] 		// Stores new highest number at the pointer head. R5 is the main thing which stores the result. 
		LDR R2, [R4,#4] 	// Reloads outer loop counter which is our main fibonacci number. 
		ADD R3, R3, #1 		// Increases inner loop counter
		B FIB

DONE:  	LDR R10, [R5] 		// Stores the Fibonacci value in R10

END: 	B END


POINTER:			.word 0
REFER: 				.word 0
N:					.word 8		// R2
TWO:				.word 2		// 2 because if our number is less than 2, return 1
ONE: 				.word 1		// R3, R1
