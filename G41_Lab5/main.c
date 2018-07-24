#include <stdlib.h>

#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

//stores the keys
char keysPressed[8] = {};
//stores the frequencies given to us
float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};

//Formula below was given on mycourses. Takes argument as frequency and the time. 
double getSampleOld(float freq, int t) {

	int index = (((int)freq) * t)%48000;
	double signal = sine[index];

	return signal;
}

// Returns double: signal
//double getSample(float freq, int t) {
	/*int truncatedIndex = ((int) freq)*t;
	double fractional = (freq*t) - truncatedIndex;
	int index = truncatedIndex % 48000;
	
	//sine[casted + fractional] = (1-fractional)*sine[index] + fractional[index+1]
	double signal = (1.0 - fractional) * sine[index] + fractional * sine[index + 1]; 
	return signal;*/
//

// Generate the signal from each frequency pressed and add them together
// Returns double: summed signal

//generateSignal takes the argument of keys and the time
double generateSignal(char* keys, int t) {
	int i;
	double data = 0;
	for(i = 0; i < 8; i++){
		if(keys[i] == 1){ //check which key is pressed
			data += getSampleOld(frequencies[i], t); //getSampleOld is used here. Because the frequencies array correspond to the keys array. 
		}
	}
	return data;
}

// Write names at the top of the screen
void drawWelcome(){
	//Screen is 79 x 59
	VGA_write_char_ASM(34, 2, 'T');
	VGA_write_char_ASM(35, 2, 'H');
	VGA_write_char_ASM(36, 2, 'E');
	VGA_write_char_ASM(37, 2, ' ');
	VGA_write_char_ASM(38, 2, 'L');
	VGA_write_char_ASM(39, 2, 'A');
	VGA_write_char_ASM(40, 2, 'S');
	VGA_write_char_ASM(41, 2, 'T');
	VGA_write_char_ASM(42, 2, ' ');
	VGA_write_char_ASM(43, 2, 'O');
	VGA_write_char_ASM(44, 2, 'N');
	VGA_write_char_ASM(45, 2, 'E');

}

void drawWords(){

	VGA_write_char_ASM(70, 59, 'V');
	VGA_write_char_ASM(71, 59, 'o');
	VGA_write_char_ASM(72, 59, 'l');
	VGA_write_char_ASM(73, 59, 'u');
	VGA_write_char_ASM(74, 59, 'm');
	VGA_write_char_ASM(75, 59, 'e');
	VGA_write_char_ASM(76, 59, ':');

}

// This is where the actual thing starts 
int main() {
	// Setup timer
	int_setup(1, (int []){199});
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; //microsecond timer
	hps_tim.timeout = 20; //Calculating the time period in s (because we are given the frequency) and then converting to microseconds 
	hps_tim.LD_en = 1; // initial count value
	hps_tim.INT_en = 1; //enabling the interrupt
	hps_tim.enable = 1; //enable bit to 1

	HPS_TIM_config_ASM(&hps_tim);
	
	// whether a key has been released
	char keyReleased = 0;
	// counter for signal
	int t = 0;
	// We store the points in history so that the points are immediately cleared. 
	double history[320] = { 0 };


	char value;

	char amplitude = 1;	//for the volume 
	double signalSum = 0.0;

	drawWords();

	while(1) {
		if(read_slider_switches_ASM() > 0) {
			drawWelcome();
		}
		else{
				if (read_ps2_data_ASM(&value)) { //Keyboard part starts here. You have many cases which are checked in the switch. 
					switch (value){
				// Key  Note  Frequency
				// A = C = 130.813Hz
						case 0x1C: //Make code for A
							if(keyReleased == 1){
								keysPressed[0] = 0;
								keyReleased = 0;
							} else{
								keysPressed[0] = 1;
							}
							break;
				// S = D = 146.832Hz
						case 0x1B:
							if(keyReleased == 1){
								keysPressed[1] = 0;
								keyReleased = 0;
							} else{
								keysPressed[1] = 1;
							}
							break;
				// D = E = 164.814Hz
						case 0x23:
							if(keyReleased == 1){
								keysPressed[2] = 0;
								keyReleased = 0;
							} else{
								keysPressed[2] = 1;
							}
							break;
				// F = F = 174.614Hz
						case 0x2B:
							if(keyReleased == 1){
								keysPressed[3] = 0;
								keyReleased = 0;
							} else{
								keysPressed[3] = 1;
							}
							break;
				// J = G = 195.998Hz
						case 0x3B:
							if(keyReleased == 1){
								keysPressed[4] = 0;
								keyReleased = 0;
							} else{
								keysPressed[4] = 1;
							}
							break;
				// K = A = 220.000Hz
						case 0x42:
							if(keyReleased == 1){
								keysPressed[5] = 0;
								keyReleased = 0;
							} else{
								keysPressed[5] = 1;
							}
							break;
				// L = B = 246.942Hz
						case 0x4B:
							if(keyReleased == 1){
								keysPressed[6] = 0;
								keyReleased = 0;
							} else{
								keysPressed[6] = 1;
							}
							break;
				// ; = C = 261.626Hz
						case 0x4C:
							if(keyReleased == 1){
								keysPressed[7] = 0;
								keyReleased = 0;
							}else{
								keysPressed[7] = 1;
							}
							break;

						//volume up 
						case 0x3C:
							if(keyReleased == 1){
								if(amplitude<10)
									amplitude++;
								keyReleased = 0;
							}
							break;

						//volume down
						case 0x43:
							if(keyReleased == 1){
								if(amplitude>0)
									amplitude--;
								keyReleased = 0;
							}
							break;

						case 0xF0: //the break code is the same for all keys
							keyReleased = 1;
							break;
						default:
							keyReleased = 0;
					}
				}
			}
			
			signalSum = generateSignal(keysPressed, t); //generate the signal after breaking from the loop and at this time

			signalSum = amplitude * signalSum; //this is volume control

			// Every 20 microseconds this flag goes high
			if(hps_tim0_int_flag == 1) { //if interrupt flag is 1, interrupt flag becomes 0
				hps_tim0_int_flag = 0;
				audio_write_data_ASM(signalSum, signalSum); //
				t++;
			}

			int drawIndex = 0;
			double valToDraw = 0;
			// To reduce the number of drawing operations
			if((t%10 == 0)){
				//draw volume number in bottom right
				if(amplitude == 10){ //10 in hex
					VGA_write_byte_ASM(78, 59, 16);
				} else {
					//volume = 0-9
					VGA_write_byte_ASM(78, 59, amplitude);
				}

				drawIndex = (t/10)%320; //Draw index changes as time goes
				//clear drawn points
				VGA_draw_point_ASM(drawIndex, history[drawIndex], 0); //
				//120 centers the signal on the screen, 500000 is arbitrary to make it fit
				valToDraw = 120 + signalSum/500000; //valToDraw increments each time 
				
				history[drawIndex] = valToDraw;
				
				VGA_draw_point_ASM(drawIndex, valToDraw, 63);		
			}
			
			// Reset the signal
			signalSum = 0;
			// Reset the counter
			if(t==48000){
				t=0;
			}
		
	}


	return 0;
}
