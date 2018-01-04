#include "lcdDisplay.h"

//Trang thai 1
void lcd_Intro(void){
  lcd_clear();
	lcd_puts(0,0,(int8_t*)"LUAN VAN TOT NGHIEP");
	lcd_puts(1,0,(int8_t*)"DE TAI: SMART HOME");
	lcd_puts(2,0,(int8_t*)"SVTH:TRUONG HA GIANG");
	lcd_puts(3,0,(int8_t*)"GVHD:TRINH HOANG HON");
}

void lcd_HomePage(int day,int date,int month,int year,int hour,int minute,int second, int temperature, int humid,int power){
	char lcd_buffer[2];
	//lcd_puts(0,5,(int8_t*)"SMART HOME");
	switch(day){
		case 1: 
			lcd_puts(0,6,(int8_t*)"Mon");
			break;
		case 2: 
			lcd_puts(0,6,(int8_t*)"TUE");
			break;
		case 3: 
			lcd_puts(0,6,(int8_t*)"WED");
			break;
		case 4: 
			lcd_puts(0,6,(int8_t*)"THU");
			break;
		case 5: 
			lcd_puts(0,6,(int8_t*)"FRI");
			break;
		case 6: 
			lcd_puts(0,6,(int8_t*)"SAT");
			break;
		case 7: 
			lcd_puts(0,6,(int8_t*)"SUN");
			break;
	}
	switch(month){
		case 1: 
			lcd_puts(0,10,(int8_t*)"Jan");
			break;
		case 2: 
			lcd_puts(0,10,(int8_t*)"Feb");
			break;
		case 3: 
			lcd_puts(0,10,(int8_t*)"Mar");
			break;
		case 4: 
			lcd_puts(0,10,(int8_t*)"Apr");
			break;
		case 5: 
			lcd_puts(0,10,(int8_t*)"May");
			break;
		case 6: 
			lcd_puts(0,10,(int8_t*)"Jun");
			break;
		case 7: 
			lcd_puts(0,10,(int8_t*)"Jul");
			break;
		case 8: 
			lcd_puts(0,10,(int8_t*)"Aug");
			break;
		case 9: 
			lcd_puts(0,10,(int8_t*)"Sep");
			break;
		case 10: 
			lcd_puts(0,10,(int8_t*)"Oct");
			break;
		case 11: 
			lcd_puts(0,10,(int8_t*)"Nov");
			break;
		case 12: 
			lcd_puts(0,10,(int8_t*)"Dec");
			break;
	}
	sprintf(lcd_buffer,"%d",date);
	if(date<10){
		lcd_puts(0,13,(int8_t*)"0");
		lcd_puts(0,14,(int8_t*)lcd_buffer);
	}
	else{
		lcd_puts(0,13,(int8_t*)lcd_buffer);
	}
	lcd_puts(0,0,(int8_t*)"Date:");
	lcd_puts(0,9,(int8_t*)",");
	lcd_puts(0,15,(int8_t*)",2017");
	
	//time
	lcd_puts(1,0,(int8_t*)"Time:");
	sprintf(lcd_buffer,"%d",hour);
	if(hour<10){
		lcd_puts(1,6,(int8_t*)"0");
		lcd_puts(1,7,(int8_t*)lcd_buffer);
	}
	else{
		lcd_puts(1,6,(int8_t*)lcd_buffer);
	}
	lcd_puts(1,8,(int8_t*)":");
	sprintf(lcd_buffer,"%d",minute);
	if(minute<10){
		lcd_puts(1,9,(int8_t*)"0");
		lcd_puts(1,10,(int8_t*)lcd_buffer);
	}
	else{
		lcd_puts(1,9,(int8_t*)lcd_buffer);
	}
	lcd_puts(1,11,(int8_t*)":");
	sprintf(lcd_buffer,"%d",second);
	if(second<10){
		lcd_puts(1,12,(int8_t*)"0");
		lcd_puts(1,13,(int8_t*)lcd_buffer);
	}
	else{
		lcd_puts(1,12,(int8_t*)lcd_buffer);
	}
	
	sprintf(lcd_buffer,"%d",temperature);
	lcd_puts(2,0,(int8_t*)"Temp:");
	lcd_puts(2,5,(int8_t*)lcd_buffer);
	
	sprintf(lcd_buffer,"%d",humid);
	lcd_puts(2,8,(int8_t*)"Humid:");
	lcd_puts(2,14,(int8_t*)lcd_buffer);
	
	
	sprintf(lcd_buffer,"%d",power);
	lcd_puts(3,0,(int8_t*)"Power:");
	lcd_puts(3,6,(int8_t*)lcd_buffer);
}

void lcd_Mode_1_page(void){
	lcd_puts(0,0,(int8_t*)"CONTROL");
	lcd_puts(1,0,(int8_t*)"SCENES");
	lcd_puts(2,0,(int8_t*)"SETTING");
	lcd_puts(0,19,(int8_t*)"*");
}

void lcd_Mode_2_page(void){
	lcd_puts(0,0,(int8_t*)"CONTROL");
	lcd_puts(1,0,(int8_t*)"SCENES");
	lcd_puts(2,0,(int8_t*)"SETTING");
	lcd_puts(1,19,(int8_t*)"*");
}

void lcd_Mode_3_page(void){
	lcd_puts(0,0,(int8_t*)"CONTROL");
	lcd_puts(1,0,(int8_t*)"SCENES");
	lcd_puts(2,0,(int8_t*)"SETTING");
	lcd_puts(2,19,(int8_t*)"*");
}
