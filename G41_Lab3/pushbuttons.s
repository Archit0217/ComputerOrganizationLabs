	.text
	.equ PB_BASE, 0xFF200050
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM

read_PB_data_ASM:
	LDR R1, =PB_BASE
	LDR R0, [R1]
	AND R0, R0, #0xF //get rid of all bits except first 4
	BX LR

PB_data_is_pressed_ASM:

	BX LR

read_PB_edgecap_ASM:

	BX LR
PB_edgecap_is_pressed_ASM:

	BX LR

PB_clear_edgecap_ASM:

	BX LR

enable_PB_INT_ASM:

	BX LR

disable_PB_INT_ASM:

	BX LR

	.end