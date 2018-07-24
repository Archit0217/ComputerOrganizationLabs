.text
	.equ VGA_PS2_DATA_BASE, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:

	PUSH {LR}
	LDR R3, =VGA_PS2_DATA_BASE
	LDR R2, [R3]
	ANDS R5, R2, #0x8000
	BNE GOTO
	MOV R0, #0
	POP {LR}
	BX LR

GOTO:
	AND R1, R2, #0xFF
	STRB R1, [R0]
	MOV R0, #1
	POP {LR}
	BX LR
	
	.end