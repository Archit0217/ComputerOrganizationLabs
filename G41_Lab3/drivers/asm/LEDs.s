				.text
				.equ LED_BASE, 0xFF200000
				.global read_LEDs_ASM
				.global write_LEDs_ASM

read_LEDs_ASM:	LDR R1, = LED_BASE		// Load the value of LED's memory location into R0
				LDR R0, [R1]
				BX LR

write_LEDs_ASM:	LDR R1, = LED_BASE	// The write takes an argument
				STR R0, [R1]	//The write will store the value in R0 at LED's memory location
				BX LR

				.end
