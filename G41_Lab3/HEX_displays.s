	.text
	.equ HEX_3_0_BASE, 0xFF200020
	.equ HEX_5_4_BASE, 0xFF200030
	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM

//	extern void HEX_clear_ASM(HEX_t hex);
//	extern void HEX_flood_ASM(HEX_t hex);
//	extern void HEX_write_ASM(HEX_t hex, char val);

//all should loop through all 6 displays (0-5) and make changes
//eg if you passed in (HEX0 | HEX1) it should clear/flood/write both of those

//takes one param
//turn all segments off
HEX_clear_ASM:
		LDR R1, =HEX_3_0_BASE //base address for display 3 - 0
	   	LDR R2, =HEX_5_4_BASE //base address for display 5 - 4
	   	MOV R3, #0 //r3 is ctr
	   	MOV R5, #1 //this will be the compare bit, starting at the 0th display
cloop: 	AND R4, R0, R5 //AND the two operands
	   	CMP R4, #0	//if its non-zero go to clear
	   	BLGT clear
		LSL R5, #1 //shift left by 1
	   	ADD R3, R3, #1 //end of loop
       	CMP R3, #6 //this might be #5 (as before)
	   	BLT cloop
	   	BX LR

clear: 	PUSH {LR}
	   	CMP R5, #8	//if greater than 8 branch to 5th4th disp
	   	BLGT clear_upr //branch to upper //never goes in here, r5 doesnt get bigger than 8?
	   	BLLE clear_lwr //branch to lower
	  	POP {LR}
	   	BX LR

clear_upr:
		MOV R6, #0
		SUB R7, R3, #4 //poor mans modulus, reset "r3" to 0
		STRB R6, [R2, R7]
		BX LR //think goes back

clear_lwr:
		MOV R6, #0
		STRB R6, [R1, R3]
		BX LR


//takes one param
//turn all segments on
HEX_flood_ASM:
		//LDR R1, =HEX_3_0_BASE
		//LDR R2, =HEX_5_4_BASE
		//store max vals in every display
		//MOV R3, #63
		//STR R3,[R1]
		//BX LR
	   	LDR R1, =HEX_3_0_BASE //base address for display 3 - 0
	   	LDR R2, =HEX_5_4_BASE //base address for display 5 - 4
	   	MOV R3, #0 //r3 is ctr
	   	MOV R5, #1 //this will be the compare bit, starting at the 0th display
floop: 	AND R4, R0, R5 //AND the two operands
	   	CMP R4, #0	//if its non-zero go to clear
	   	BLGT flood
		LSL R5, #1 //shift left by 1
	   	ADD R3, R3, #1 //end of loop
       	CMP R3, #6 //this might be #5 (as before)
	   	BLT floop
	   	BX LR

flood: 	PUSH {LR}
	   	CMP R5, #8	//if greater than 8 branch to 5th4th disp
	   	BLGT flood_upr //branch to upper //never goes in here, r5 doesnt get bigger than 8?
	   	BLLE flood_lwr //branch to lower
	  	POP {LR}

	   	BX LR

flood_upr:
		MOV R6, #127 // 7 bits of 1s (looks like an 8)
		SUB R7, R3, #4 //poor mans modulus, reset "r3" to 0
		STRB R6, [R2, R7]
		BX LR 
		//B bck

flood_lwr:
		MOV R6, #63 //6 bits of 1s (looks like a zero)
		STRB R6, [R1, R3]
		BX LR 
		//B bck

//takes two param
//first param is display, second param is the value to write
HEX_write_ASM:
				MOV R5, R0
				PUSH {R1-R12, R14}		//push all data
				BL HEX_clear_ASM		//Clear displays that are being written to
				POP {R1-R12, R14}		//pop all data
				MOV R0, R5

				PUSH {R4-R12, R14}
				LDR R2, =DISP_0			// Load first half of the displays
				MOV R4, #0
				B HEX_write_ASM_SWITCH_0

//The 16 cases
HEX_write_ASM_SWITCH_0:
				CMP R1, #48
				BNE HEX_write_ASM_SWITCH_1
				MOV R5, #0x3F
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_1:	
				CMP R1, #49
				BNE HEX_write_ASM_SWITCH_2
				MOV R5, #0x06
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_2:	
				CMP R1, #50
				BNE HEX_write_ASM_SWITCH_3
				MOV R5, #0x5B
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_3:	
				CMP R1, #51
				BNE HEX_write_ASM_SWITCH_4
				MOV R5, #0x4F
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_4:	
				CMP R1, #52
				BNE HEX_write_ASM_SWITCH_5
				MOV R5, #0x66
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_5:	
				CMP R1, #53
				BNE HEX_write_ASM_SWITCH_6
				MOV R5, #0x6D
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_6:	
				CMP R1, #54
				BNE HEX_write_ASM_SWITCH_7
				MOV R5, #0x7D
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_7:	
				CMP R1, #55
				BNE HEX_write_ASM_SWITCH_8
				MOV R5, #0x07
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_8:	
				CMP R1, #56
				BNE HEX_write_ASM_SWITCH_9
				MOV R5, #0x7F
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_9:	
				CMP R1, #57
				BNE HEX_write_ASM_SWITCH_10
				MOV R5, #0x6F
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_10:	
				CMP R1, #65
				BNE HEX_write_ASM_SWITCH_11
				MOV R5, #0x77
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_11:	
				CMP R1, #66
				BNE HEX_write_ASM_SWITCH_12
				MOV R5, #0x7C
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_12:	
				CMP R1, #67
				BNE HEX_write_ASM_SWITCH_13
				MOV R5, #0x39
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_13:	
				CMP R1, #68
				BNE HEX_write_ASM_SWITCH_14
				MOV R5, #0x5E
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_14:	
				CMP R1, #69
				BNE HEX_write_ASM_SWITCH_15
				MOV R5, #0x79
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_15:	
				CMP R1, #70
				BNE HEX_write_ASM_SWITCH_DEFAULT
				MOV R5, #0x71
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_SWITCH_DEFAULT:
				MOV R5, #0
				MOV R8, R5
				B HEX_write_ASM_LOOP

HEX_write_ASM_LOOP:
				CMP R4, #5				//If done,
				BGT HEX_flood_ASM_DONE	//branch to done
				AND R7, R0, #1
				CMP R7, #0
				ADDEQ R4, R4, #1		// Point to another byte
				ASR R0, R0, #1			// Shift R0
				LSLEQ R5, #8			//Shift R5 by 8 bits
				CMP R5, #0
				MOVEQ R5, R8			//If 0, move original value back in
				CMP R7, #0
				BEQ HEX_write_ASM_LOOP	//If bit is 0, return to loop

				CMP R4, #4
				LDRGE R2, =DISP_1		// Load second half of the displays
				MOVGE R5, R8
				CMP R4, #5
				LSLEQ R5, #8

				LDR R7, [R2]
				ORR R7, R7, R5			//Set new value
				STR R7, [R2]		//Store it into the display

				ADD R4, R4, #1			//Increment counter
				LSL R5, #8				//Shift R5 by 8 bits
				CMP R5, #0
				MOVEQ R5, R8			//If 0, move original value back in

				B HEX_write_ASM_LOOP

HEX_write_ASM_DONE:
				POP {R4-R12,R14}
				BX LR

//END: B END
	.end