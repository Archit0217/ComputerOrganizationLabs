#include <stdio.h>

#include "./drivers/inc/VGA.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"

void test_char() {
	int x, y;
	char c = 0;
	for (y = 0; y <= 59; y++) {
		for (x = 0; x <= 79; x++) {
			VGA_write_char_ASM(x, y, c++);
		}
	}
}
void test_byte(){
	int x, y;
	char c = 0;
	for (y = 0; y <= 59; y++) {
		for (x = 0; x <= 79; x += 3) {
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}
void test_pixel(){
	int x, y;
	unsigned short colour = 0;
	for(y=0; y<=239; y++) {
		for(x=0; x<=319; x++) {
			VGA_draw_point_ASM(x, y, colour++);
		}
	}
}

// Start of part 1

/*void	test_char();
void	test_byte();
void	test_pixel();
 int main() {
	
	while(1) { 										
		
		if(PB_data_is_pressed_ASM(PB0)){
			if (read_slider_switches_ASM() != 0) { //any of the slider switches is on
				test_byte(); 
		}
		else {
			test_char();
			
		}}
		if(PB_data_is_pressed_ASM(PB1)){
			test_pixel();
		}
	
		if(PB_data_is_pressed_ASM(PB2)){
		VGA_clear_charbuff_ASM();
		}
		if(PB_data_is_pressed_ASM(PB3)){
		VGA_clear_pixelbuff_ASM(); 
		}	
	
	}
	return 0;
}*/


//Start of part 2

/*void	test_char();
void	test_byte();
void	test_pixel();

int main(){ 
char *data = (char*) malloc(sizeof(char));
int x,y;
x=0;
y=0;
while(1){
		if(read_slider_switches_ASM()>0){
			VGA_clear_charbuff_ASM();
			x=0;
			y=0;
		}
		if(read_PS2_data_ASM(data)){
			VGA_write_byte_ASM(x,y, *data);
			x+=3;
		}
		if(x>79){
			y++;
			x=0;
		}
		if(y>59) {
			y=0;
		}
		}
		return 0;
}*/



// Start of part 3

int main(){
	int samples = 0;
	int signal = 0x00FFFFFF;
	while(1) {
						// if there's space, send a value 
		if (audio_ASM(signal)) {
			samples++;	// increment number of samples sent
			 			//when samples sent reaches 240, switch the signal *
			if (samples > 240) {
				samples = 0;
				if (signal == 0) {
					signal = 0x00FFFFFF;
				} else {
					signal = 0;
				}
			}
		}
	} return 0;
}
