#line 1 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
#line 52 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long outputADE;
float voltage, ampe, activepower;
#line 57 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Write_ADE7753(char add, long write_buffer, int bytes_to_write);
long Read_ADE7753(char add, char bytes_to_read);
void HienthiUART (long outputADE, int bytes_to_write);
void Hienthisofloat (float so);
void Test(void);
int getresetInterruptStatus(void);
int getInterruptStatus(void);
float getVRMS(void);
float getIRMS(void);
float getAPOWER(void);
#line 70 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void main()
{
 voltage = 0;
 ampe = 0;
 activepower = 0;
 TRISC.B0 = 0;
 PORTC.B0 = 1;
 UART1_Init(9600);
 Delay_ms(200);
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_HIGH_2_LOW);
 Delay_ms(200);

 Write_ADE7753( 0x0F ,0x0,1);
 Write_ADE7753( 0x09 ,0x008C,2);




 Delay_ms(200);

 while(1)
 {

 UART1_Write_Text("\nDien ap: ");
 voltage = getVRMS();
 Hienthisofloat(voltage);
 Delay_ms(200);

 UART1_Write_Text("\nDong dien: ");
 ampe = getIRMS();
 Hienthisofloat(ampe);
 Delay_ms(500);

 UART1_Write_Text("\nCong suat: ");
 activepower = getAPOWER();
 Hienthisofloat(activepower);
 Delay_ms(500);

 }
}
#line 114 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Write_ADE7753(char add, long write_buffer, int bytes_to_write)
{
 char cmd;
 char this_write;
 int i;
 cmd = 0x80;
 add = add|cmd;
  PORTC.B0  = 0;
 SPI1_Write(add);
 Delay_ms(2);

 for (i = 0; i < bytes_to_write; i++)
 {
 this_write = (char) (write_buffer>> (8*((bytes_to_write-1)-i)));
 SPI1_Write(this_write);
 Delay_ms(2);
 }
  PORTC.B0 =1;
}
#line 136 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long Read_ADE7753(char add, char bytes_to_read)
{
 long result;
 int i;
 char reader_buf;
  PORTC.B0  = 0;
 SPI1_Write(add);
 Delay_ms(2);
 for (i = 1; i <= bytes_to_read; i++)
 {
 reader_buf = SPI1_Read(0x00);
 Delay_ms(2);
 result = result | reader_buf;
 if(i < bytes_to_read)
 result = result << 8;
 }
  PORTC.B0  = 1;
 return result;
}
#line 158 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void HienthiUART (long outputADE, int bytes_to_write)
{
 int i;
 char this_write;
 for (i = 0; i < bytes_to_write; i++)
 {
 this_write = (char) (outputADE>> (8*((bytes_to_write-1)-i)));
 UART1_Write(this_write);
 }
}
#line 171 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Hienthisofloat (float so)
{
 char kq[15];
 FloatToStr(so,kq);
 UART1_Write_Text(kq);
}
#line 180 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long getresetInterruptStatus(void){
 return Read_ADE7753( 0x0C ,2);
}
#line 186 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long getInterruptStatus(void){
 return Read_ADE7753( 0x0B ,2);
}
#line 192 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
float getVRMS (void)
{
 int i, j;
 long totalv, vrmsraw;
 float vrmsreal;
 totalv = 0;
 j = 0;
 Write_ADE7753( 0x0A ,0x0010,2);
 for(i=0;i<10;i++)
 {
 getresetInterruptStatus();
 while(! (getInterruptStatus() &  0x0010 )){
 j++;
 if(j>100){
 j=0;
 break;
 }
 }
 outputADE=Read_ADE7753( 0x17 ,3);
 Delay_ms(20);
 totalv=totalv+outputADE;
 Delay_ms(25);
 }
 getresetInterruptStatus();
 vrmsraw = totalv/10;

 vrmsraw = vrmsraw & 0xFFFFFF;

 vrmsreal = (float)vrmsraw;
 vrmsreal = vrmsreal * 0.00033834;
 vrmsreal = vrmsreal- 2626.4;

 if(vrmsreal > 400 || vrmsreal < 0){
 vrmsreal = 0;
 }
 return vrmsreal;
}
#line 232 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
float getIRMS(void)
{
 int i, j;
 long totali, irmsraw;
 float irmsreal;
 totali = 0;
 j = 0;
 Write_ADE7753( 0x0A ,0x0010,2);
 for(i=0;i<10;i++)
 {
 getresetInterruptStatus();
 while(! (getInterruptStatus() &  0x0010 )){
 j++;
 if(j>100){
 j=0;
 break;
 }
 }
 outputADE=Read_ADE7753( 0x16 ,3);
 Delay_ms(20);
 totali=totali+outputADE;
 Delay_ms(25);
 }
 getresetInterruptStatus();
 irmsraw = totali/10;
 irmsraw = irmsraw & 0xFFFFFF;
 irmsreal = (float)irmsraw;
 irmsreal = irmsreal * 0.00003714;
 irmsreal = irmsreal- 288.1919;

 if(irmsreal > 40 || irmsreal < 0){
 irmsreal = 0;
 }
 return irmsreal;
}

float getAPOWER(void)
{
 int i, j;
 long apraw;
 float apreal;
 apraw = 0;
 apreal =0;
 Write_ADE7753( 0x1C ,100,2);
 Delay_ms(500);
 Write_ADE7753( 0x09 ,0x0080,2);
 Delay_ms(500);
 Write_ADE7753( 0x0A ,0x0004,2);
 Delay_ms(500);
 getresetInterruptStatus();
 while(! (getInterruptStatus() &  0x0004 )){
 j++;
 if(j>200){
 j=0;
 break;
 }
 }

 getresetInterruptStatus();
 while(! (getInterruptStatus() &  0x0004 )){
 j++;
 if(j>200){
 j=0;
 break;
 }
 }
 getresetInterruptStatus();
 outputADE=Read_ADE7753( 0x04 ,3);
 Delay_ms(500);
 apraw = outputADE;
 apraw = apraw & 0xFFFF;

 apreal = (float)apraw;
 apreal = apreal * 1.6425;
 apreal = apreal + 0.14;
 Write_ADE7753( 0x1C ,0xFFFF,2);
 Delay_ms(500);
 if(apreal < 8 || apreal > 2000){
 apreal = 0;
 }
 return apreal;
}
#line 318 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Test (void)
{
 Write_ADE7753( 0x1C ,0xABEF,2);
 outputADE = Read_ADE7753( 0x1C ,2);
 HienthiUART(outputADE,2);
}
