#ifndef		__LCDDISPLAY_H
#define		__LCDDISPLAY_H

#include "stm32f4xx.h"
#include "lcd_txt.h"

extern void lcd_Intro(void);
extern void lcd_HomePage(int day,int date,int month,int year,int hour,int minute,int second);
extern void lcd_Mode_1_page(void);
extern void lcd_Mode_2_page(void);
extern void lcd_Mode_3_page(void);
#endif
