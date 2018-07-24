							.text
							.equ SW_BASE, 0xFF200040
							.global read_slider_switches_ASM

read_slider_switches_ASM:	LDR R1, = SW_BASE	// read the value of memory location designated for 
							LDR R0, [R1]		// the slider switches data into the R0 register
							BX LR

							.end
