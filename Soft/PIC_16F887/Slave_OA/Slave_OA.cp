#line 1 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
#line 52 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long outputADE;
float voltage, ampe, activepower;
char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];
bit oldstate;
int relayStatus = 0;
#line 62 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
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
void sendVolt(float so);
void sendAmpe(float so);
void sendPower(float so);
void RS485_send (char dat[]);
void turnOnRelay(void);
void turnOffRelay(void);
void Config_sendData(void);

void interrupt()
{
 if(PIR1.RCIF)
 {
 while(uart1_data_ready()==0);
 if(uart1_data_ready()==1)
 {
 tempReceiveData = UART1_Read();
 if(tempReceiveData == 'S')
 {
 count=0;
 receiveData[count] = tempReceiveData;
 count++;
 }
 if(tempReceiveData !='S' && tempReceiveData !='E')
 {
 receiveData[count] = tempReceiveData;
 count++;
 }
 if(tempReceiveData == 'E')
 {
 receiveData[count] = tempReceiveData;
 count=0;
 flagReceivedAllData = 1;
 }
 }
 }
}
#line 112 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void main()
{
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;
 oldstate = 0;

 TRISB.B0 = 1;
 oldstate = 0;

 TRISD.B4 = 0;

 TRISD.B5 = 0;
 turnOffRelay();
 Config_sendData();
 RS485_send(sendData);


 activepower = 0;

 TRISC.B0 = 0;
 PORTC.B0 = 1;

 UART1_Init(9600);
 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;
 Delay_ms(200);
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_HIGH_2_LOW);
 Delay_ms(200);
 Write_ADE7753( 0x0F ,0x0,1);
 Write_ADE7753( 0x09 ,0x008C,2);



 Delay_ms(1000);

 while(1){


 activepower = getAPOWER();
 if(flagReceivedAllData == 1){
 flagReceivedAllData = 0;
 Delay_ms(20);
#line 174 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
 if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'D'
 && receiveData[4] == '0' && receiveData[5] == '4' && receiveData[6] == '0'
 && receiveData[7] == '0' && receiveData[8] == '0' && receiveData[9] == 'P'){
 Delay_ms(500);

 sendPower(activepower);
 Delay_ms(1000);
 }

 }
 if (Button(&PORTB, 0, 1, 1)) {
 oldstate = 1;
 }
 if (oldstate && Button(&PORTB, 0, 1, 0)) {

 if(relayStatus == 0){
 turnOnRelay();
 relayStatus++;
 }
 else{
 turnOffRelay();
 relayStatus = 0;
 }
 oldstate = 0;
 Delay_ms(300);
 }
#line 220 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
 }
}
#line 226 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
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
#line 248 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
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
#line 270 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
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
#line 283 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Hienthisofloat (float so){
 char kq[15];
 char a[4];
 FloatToStr(so,kq);
 UART1_Write_Text(kq);
}

void sendVolt(float so){
 char kq[15];
 FloatToStr(so,kq);
 if(so == 0){
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = '0';
 sendData[9] = 'V';
 sendData[10] = 'E';
 }
 if(so !=0 && so < 100){
 sendData[6] = '0';
 sendData[7] = kq[0];
 sendData[8] = kq[1];
 sendData[9] = 'V';
 sendData[10] = 'E';
 }
 if(so !=0 && so > 100){
 sendData[6] = kq[0];
 sendData[7] = kq[1];
 sendData[8] = kq[2];
 sendData[9] = 'V';
 sendData[10] = 'E';
 }
 Delay_ms(100);
 RS485_send(sendData);
 Delay_ms(300);
}

void sendAmpe(float so){
 char kq[15];
 FloatToStr(so,kq);
 if(so == 0){
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = '0';
 sendData[9] = 'I';
 sendData[10] = 'E';
 }
 if(so !=0 && so < 1 && so > 0.1){
 sendData[6] = '0';
 sendData[7] = '.';
 sendData[8] = kq[0];
 sendData[9] = 'I';
 sendData[10] = 'E';
 }
 else if(so>1){
 sendData[6] = kq[0];
 sendData[7] = '.';
 sendData[8] = kq[2];
 sendData[9] = 'I';
 sendData[10] = 'E';
 }
 Delay_ms(100);
 RS485_send(sendData);
 Delay_ms(300);
}

void sendPower(float so){
 char kq[15];
 FloatToStr(so,kq);
 if(so == 0){
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = '0';
 sendData[9] = 'P';
 sendData[10] = 'E';
 }
 if(so !=0 && so < 10){
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = kq[0];
 sendData[9] = 'P';
 sendData[10] = 'E';
 }
 if(so < 100 && so > 10){
 sendData[6] = '0';
 sendData[7] = kq[0];
 sendData[8] = kq[1];
 sendData[9] = 'P';
 sendData[10] = 'E';
 }
 if(so < 1000 && so > 100){
 sendData[6] = kq[0];
 sendData[7] = kq[1];
 sendData[8] = kq[2];
 sendData[9] = 'P';
 sendData[10] = 'E';
 }
 Delay_ms(100);
 RS485_send(sendData);
 Delay_ms(300);
}
#line 386 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long getresetInterruptStatus(void){
 return Read_ADE7753( 0x0C ,2);
}
#line 392 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
long getInterruptStatus(void){
 return Read_ADE7753( 0x0B ,2);
}
#line 398 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
float getVRMS (void)
{
 int i, j;
 long totalv, vrmsraw;
 float vrmsreal;
 totalv = 0;
 j = 0;
 Write_ADE7753( 0x0A ,0x0010,2);
 Delay_ms(20);
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

 if(vrmsreal > 400 || vrmsreal < 35){
 vrmsreal = 0;
 }
 return vrmsreal;
}
#line 439 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
float getIRMS(void)
{
 int i, j;
 long totali, irmsraw;
 float irmsreal;
 totali = 0;
 j = 0;
 Write_ADE7753( 0x0A ,0x0010,2);
 Delay_ms(20);
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
#line 526 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Test (void)
{
 Write_ADE7753( 0x1C ,0xABEF,2);
 outputADE = Read_ADE7753( 0x1C ,2);
 HienthiUART(outputADE,2);
}
#line 536 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void RS485_send (char dat[])
{
 int i;
 PORTD.RD4 =1;
 Delay_ms(300);
 for (i=0; i<=10;i++){
 while(UART1_Tx_Idle()==0);
 UART1_Write(dat[i]);
 Delay_ms(30);
 }
 Delay_ms(200);
 PORTD.RD4 =0;
}
#line 552 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void Config_sendData(void){
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '3';
 sendData[3] = 'D';
 sendData[4] = '0';
 sendData[5] = '4';
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = '0';
 sendData[9] = 'P';
 sendData[10] = 'E';
}
#line 569 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void turnOnRelay(void){
 PORTD.RD5 =1;
}
#line 576 "E:/LVTN/Smarthome/Soft/PIC_16F887/Slave_OA/Slave_OA.c"
void turnOffRelay(void){
 PORTD.RD5 =0;
}
