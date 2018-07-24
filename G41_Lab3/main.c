#include <stdio.h>
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/address_map_arm.h"



// Part 1a starts here 
/*int main() {
	
	while (1) {	
		// The slider switches state is passed as an argument into the write function. Which then decides the state of the LED. 
		write_LEDs_ASM(read_slider_switches_ASM());

	}
	return 0;
}*/




//Part 1b starts here

/*int main() {
	
	while (1) {	
		// illuminate LED for each switch
		write_LEDs_ASM(read_slider_switches_ASM());
		
		int number = 0xF & read_slider_switches_ASM();	// The number you want to input using the swich buttons. only keep first four digits of binary representation
		int keys = 0xF & read_PB_data_ASM();			// Keys idenifies which pushbutton is being used. only keep first four digits of binary representation	
		
		if ((keys > 0) && (0x200 & read_slider_switches_ASM()) != 512) {	// 512 just corresponds to all the slider switches being on. i.e S9 is not on right now. 
			// if any pushbuttons are pressed, flood HEX4 and HEX5 as stated in the lab requirements. 
			HEX_flood_ASM(HEX4 | HEX5);
			
			// if any other pushbuttons are pressed, send the number to the appropriate HEX displays 
			switch (keys) {	//They represent the various combinations of the pushbuttons
				case 1 :
					HEX_write_ASM(HEX0, number);
					break;
				case 2 :
					HEX_write_ASM(HEX1, number);
					break;
				case 3:
					HEX_write_ASM(HEX0 | HEX1, number);
					break;
				case 4:
					HEX_write_ASM(HEX2, number);
					break;
				case 5:
					HEX_write_ASM(HEX0 | HEX2, number);
					break;
				case 6:
					HEX_write_ASM(HEX1 | HEX2, number);
					break;
				case 7:
					HEX_write_ASM(HEX0 | HEX1 | HEX2, number);
					break;
				case 8:
					HEX_write_ASM(HEX3, number);
					break;
				case 9:
					HEX_write_ASM(HEX0 | HEX3, number);
					break;
				case 10:
					HEX_write_ASM(HEX1 | HEX3, number);
					break;
				case 11:
					HEX_write_ASM(HEX0 | HEX1 | HEX3, number);
					break;
				case 12:
					HEX_write_ASM(HEX2 | HEX3, number);
					break;
				case 13:
					HEX_write_ASM(HEX0 | HEX2 | HEX3, number);
					break;
				case 14:
					HEX_write_ASM(HEX1 | HEX2 | HEX3, number);
					break;
				case 15:
					HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3, number); 
					break;
				default:
					
					break;
			}
		} else if ((0x200 & read_slider_switches_ASM()) == 512) {
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5); // clear everything if switch 9 is flipped
		} else {
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3); // Don't clear HEX4 and HEX5
		}
	}
	return 0;
}*/






// Part 2 starts below here

/*int main(){
int overall0 = 0; // 
int ms=0;	// counter for ms
int s = 0; //couters for seconds
int mins = 0; //counters for minutes
int hex0 = 0; 
int hex1 = 0; 
int hex2 = 0; 
int hex3 = 0;
int hex4 = 0;
int hex5 = 0; 
int start=0;
	HPS_TIM_config_t hps_tim;	 
	HPS_TIM_config_t hps_tim2;
	
	hps_tim.tim = TIM1;
	hps_tim.timeout = 10000; // Actual clock timer. 
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;
	
	hps_tim2.tim = TIM0;
	hps_tim2.timeout = 5000; // increments every 5 milliseconds in micro
	hps_tim2.LD_en = 1;
	hps_tim2.INT_en = 1;
	hps_tim2.enable = 1;
	
	
	HPS_TIM_config_ASM(&hps_tim);
	HPS_TIM_config_ASM(&hps_tim2);
	
	while(1){
		if(PB_data_is_pressed_ASM(PB0)){	//Pushbutton 0 is pressed
			start = 1;
		}if(PB_data_is_pressed_ASM(PB1)){	//Pushbutton 1 is pressed
			start = 0;
		}
	
		if(PB_data_is_pressed_ASM(PB2)){	//Pushbutton 2 is pressed which resets everything
			HEX_write_ASM(HEX0, 0);
			HEX_write_ASM(HEX1, 0);
			HEX_write_ASM(HEX2, 0);
			HEX_write_ASM(HEX3, 0);
			HEX_write_ASM(HEX4, 0);
			HEX_write_ASM(HEX5, 0);	
			overall0 = 0;
			ms=0;
			s = 0;
			mins = 0;
			hex0 = 0;
			hex1 = 0;
			hex2 = 0;
			hex3 = 0;
			hex4 = 0;
			hex5 = 0;
			
		}
		if(HPS_TIM_read_INT_ASM(TIM0)){
			if(start == 1){
				HPS_TIM_clear_INT_ASM(TIM0); // restores F and S bit for timer to begin again
				if(HPS_TIM_read_INT_ASM(TIM1)){ // returns true once 10ms are over, causing status register to become one
					overall0++;
					HPS_TIM_clear_INT_ASM(TIM1); // restores F and S bit for timer to begin again
					ms=overall0%100;
					s=(overall0/100)%60;
					mins=((overall0/6000)%60);
					hex0=ms%10;
					hex1=ms/10;
					hex2=s%10;
					hex3=s/10;
					hex4=mins%10;
					hex5=mins/10;
					HEX_write_ASM(HEX0, hex0);
					HEX_write_ASM(HEX1, hex1);
					HEX_write_ASM(HEX2, hex2);
					HEX_write_ASM(HEX3, hex3);
					HEX_write_ASM(HEX4, hex4);
					HEX_write_ASM(HEX5, hex5);	
					
					}
				//overall0++;	
				}
			//overall0++;
	}
}
	return 0;
}*/





// Part 3 starts here.

int main(){
	//Enable interupts for push buttons and hps timer 0
	int_setup(2, (int []) {73, 199}); // The first integer denotes number of ID's to interrupt. Second array contains the interrupt ID's

	//Enable interrupts for pushbuttons
	enable_PB_INT_ASM(PB0 | PB1 | PB2);	//so that the pushbuttons actually interrupt
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000; //This is equal to 10ms
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;




	int overall0 = 0; 
	int ms=0;
	int s = 0; //couters for seconds
	int mins = 0; //counters for minutes
	int hex0 = 0; 
	int hex1 = 0; 
	int hex2 = 0; 
	int hex3 = 0; 
	int hex4 = 0; 
	int hex5 = 0; 
	int start=1;
	while(1) {
		//Check if interrupt for pushbuttons occurs
		if (pb_int_flag >=0) { // interrupt flag
			//if the interrupt is button 0: start timer
			if (pb_int_flag == 0) { 
				hps_tim.LD_en = 1;	// starts timer
				hps_tim.INT_en = 1;
				hps_tim.enable = 1;
				HPS_TIM_config_ASM(&hps_tim);
				pb_int_flag = 6 ;
				start =1;	
			} 
			//if the interrupt is button 1: stop timer
			else if (pb_int_flag == 1) {
						hps_tim.LD_en = 0;
						hps_tim.INT_en = 0;
						hps_tim.enable = 0;
						HPS_TIM_config_ASM(&hps_tim);
						pb_int_flag = 6 ;
						start=0;				
			} 
			//if the interrupt is button 2: reset and stop the timer
			else if (pb_int_flag == 2) { 
				hps_tim.LD_en = 0;
				hps_tim.INT_en = 0;
				hps_tim.enable = 0;
				HPS_TIM_config_ASM(&hps_tim);
				HEX_write_ASM(HEX0, 0);
			HEX_write_ASM(HEX1, 0);
			HEX_write_ASM(HEX2, 0);
			HEX_write_ASM(HEX3, 0);
			HEX_write_ASM(HEX4, 0);
			HEX_write_ASM(HEX5, 0);	
			overall0 = 0;
			ms=0;
			s = 0;
			mins = 0;
			hex0 = 0;
			hex1 = 0;
			hex2 = 0;
			hex3 = 0;
			hex4 = 0;
			hex5 = 0;
			pb_int_flag = 6 ;	//Resets the interrupt flag
			}
		
		}
		if(start == 1){ //This is the main body of the counter

				if(hps_tim0_int_flag){ // returns true once 10ms are over, causing status register to become one

					overall0++;
					hps_tim0_int_flag=0; // restores F and S bit for timer to begin again
					ms=overall0%100;
					s=(overall0/100)%60;
					mins=((overall0/6000)%60);
					hex0=ms%10;
					hex1=ms/10;
					hex2=s%10;
					hex3=s/10;
					hex4=mins%10;
					hex5=mins/10;
					HEX_write_ASM(HEX0, hex0);
					HEX_write_ASM(HEX1, hex1);
					HEX_write_ASM(HEX2, hex2);
					HEX_write_ASM(HEX3, hex3);
					HEX_write_ASM(HEX4, hex4);
					HEX_write_ASM(HEX5, hex5);	
					
					}
				//overall0++;	
				}
			//overall0++;
	}

	return 0;
}




