		.text
		.global MAX_2

MAX_2:  CMP R0, R1		// Find R0 - R1
		BXGE LR			// Go back to the C Program
		MOV R0, R1		// Else, R1 to R0
		BX LR			// Go back to the C Program
		.end
