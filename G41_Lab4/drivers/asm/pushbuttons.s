	.text
	.equ BT_BASE, 0xFF200050
	.equ INT_BASE, 0xFF200058
	.equ EDGE_CAP, 0xFF20005C

	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM

	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM
	
read_PB_data_ASM:	
	LDR R1, =BT_BASE
	LDR R0, [R1]
	BX LR

PB_data_is_pressed_ASM:
	PUSH {LR}
	LDR R1, =BT_BASE // R1 contains base address of pushbutton parallel port
	LDR R2, [R1] // R2 contains buttons within pushbutton parallel port that are on
	AND R3, R2, R0 // R0 contains whose pressed status you wish to check
	CMP R3, R0
	MOVGE R0, #1 // return true if button is pressed
	MOVLT R0, #0 // return false if button is not pressed
	POP {LR}
	BX LR

read_PB_edgecap_ASM:
	
	LDR R1, =EDGE_CAP
	LDR R0, [R1]
	BX LR

PB_edgecap_is_pressed_ASM:

	LDR R1, =EDGE_CAP // R1 contains edge capture address of pushbutton parallel port
	LDR R2, [R1] // R2 contains value stored within edge capture address
	AND R3, R2, R0 // R0 contains whose edge capture status you wish to check
	CMP R3, R0
	MOVGE R0, #1 // return true if edge capture bit of that button is on
	MOVLT R0, #0 // return true if edge capture bit of that button is off
	BX LR

PB_clear_edgecap_ASM:
	
	LDR R1, =EDGE_CAP // R1 contains address of edge cap register
	LDR R2, [R1] // R2 contains value of interrupt mask register
	BIC R2, R2, R0 // R0 contains button whose edge cap you want to clear (complemented); R2 contains new value to be stored in edge cap register
	STR R2, [R1] // update edge capture register
	BX LR
	

enable_PB_INT_ASM:
	
	LDR R1, =INT_BASE
	LDR R2, [R1] // R2 contains value of interrupt mask register
	ORR R2, R2, R0 // R0 contains button whose interrupt you want to enable; R2 contains new value to be stored in interrupt mask register
	STR R2, [R1] // update interrupt mask register
	BX LR

disable_PB_INT_ASM:
	
	LDR R1, =INT_BASE // R1 contains address of interrupt mask register
	LDR R2, [R1] // R2 contains value of interrupt mask register
	BIC R2, R2, R0 // R0 contains button whose edge cap you want to clear (complemented); R2 contains new value to be stored in edge cap register
	STR R2, [R1] // update interrupt mask register	
	BX LR
	.end
