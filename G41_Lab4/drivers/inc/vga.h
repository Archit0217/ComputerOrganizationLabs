#ifndef __VGA
#define __VGA

	void VGA_clear_charbuff_ASM(); //clears, sets to 0 all valid memoy location
	void VGA_clear_pixelbuff_ASM(); //clears/sets to 0 all valid mem address
	
	void VGA_write_char_ASM(int x, int y, char c);		//writes ASCCII code passed in hird arg to screen at loc (x,y)
	void VGA_write_byte_ASM(int x, int y,	char byte);  //
	
	void VGA_draw_point_ASM(int x, int y, short colour); //draw pixel

#endif