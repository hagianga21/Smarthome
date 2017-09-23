#line 1 "E:/MYPROJECTINHCMUT/Doan1/Testcode/PIC/Slave_CA3/Slave_CA3.c"
#line 21 "E:/MYPROJECTINHCMUT/Doan1/Testcode/PIC/Slave_CA3/Slave_CA3.c"
bit oldstate;

char receive[11];

char WTF[11];

int stt1 =1, stt2 =1,stt3 = 1;
char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];
char addressButton1[2], addressButton2[2], addressButton3[2];
char addressDevice1[2], addressDevice2[2], addressDevice3[2];
void RS485_send (char dat[]);
void checkstt (int stt);


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
void main() {



 TRISB.B0 =1;
 TRISB.B4 =1;
 TRISB.B5 =1;

 TRISB.B3 =0;

 oldstate = 0;
 UART1_Init(9600);
 Delay_ms(100);

 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;


 addressButton1[0] = EEPROM_Read(0x02);
 addressButton1[1] = EEPROM_Read(0x03);
 addressDevice1[0] = EEPROM_Read(0x04);
 addressDevice1[1] = EEPROM_Read(0x05);

 addressButton2[0] = EEPROM_Read(0x06);
 addressButton2[1] = EEPROM_Read(0x07);
 addressDevice2[0] = EEPROM_Read(0x08);
 addressDevice2[1] = EEPROM_Read(0x09);

 addressButton3[0] = EEPROM_Read(0x0A);
 addressButton3[1] = EEPROM_Read(0x0B);
 addressDevice3[0] = EEPROM_Read(0x0C);
 addressDevice3[1] = EEPROM_Read(0x0D);



 Delay_ms(100);

 if (addressButton1[0]==0xff || addressButton2[0]==0xff || addressButton3[0]==0xff){
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '2';
 sendData[3] = '0';
 sendData[4] = '0';
 sendData[5] = '0';
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = 'B';
 sendData[9] = '3';
 sendData[10] = 'E';
 RS485_send(sendData);
 }
 WTF[0] = 'S';
 WTF[1] = 'A';
 WTF[2] = 'A';
 WTF[3] = 'A';
 WTF[4] = 'A';
 WTF[5] = 'A';
 WTF[6] = 'A';
 WTF[7] = 'A';
 WTF[8] = 'A';
 WTF[9] = 'A';
 WTF[10] = 'E';

 while(1)
 {
 if(flagReceivedAllData==1){
 flagReceivedAllData = 0;

 if(receiveData[2] == '2'){
 if(receiveData[9] == '1'){
 addressButton1[0] = receiveData[4];
 addressButton1[1] = receiveData[5];
 addressDevice1[0] = receiveData[7];
 addressDevice1[1] = receiveData[8];
 EEPROM_Write(0x02,addressButton1[0]);
 EEPROM_Write(0x03,addressButton1[1]);
 EEPROM_Write(0x04,addressDevice1[0]);
 EEPROM_Write(0x05,addressDevice1[1]);
 }
 if(receiveData[9] == '2'){
 addressButton2[0] = receiveData[4];
 addressButton2[1] = receiveData[5];
 addressDevice2[0] = receiveData[7];
 addressDevice2[1] = receiveData[8];
 EEPROM_Write(0x06,addressButton2[0]);
 EEPROM_Write(0x07,addressButton2[1]);
 EEPROM_Write(0x08,addressDevice2[0]);
 EEPROM_Write(0x09,addressDevice2[1]);
 }
 if(receiveData[9] == '3'){
 addressButton3[0] = receiveData[4];
 addressButton3[1] = receiveData[5];
 addressDevice3[0] = receiveData[7];
 addressDevice3[1] = receiveData[8];
 EEPROM_Write(0x0A,addressButton3[0]);
 EEPROM_Write(0x0B,addressButton3[1]);
 EEPROM_Write(0x0C,addressDevice3[0]);
 EEPROM_Write(0x0D,addressDevice3[1]);
 }
 }
 }

 if (Button(&PORTB, 0, 1, 1)) {
 oldstate = 1;
 }
 if (oldstate && Button(&PORTB, 0, 1, 0)) {
 Delay_ms(100);
 if (oldstate && Button(&PORTB, 0, 1, 0))
 {
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '0';
 sendData[3] = 'B';
 sendData[4] = addressButton1[0];
 sendData[5] = addressButton1[1];
 sendData[6] = 'D';
 sendData[7] = addressDevice1[0];
 sendData[8] = addressDevice1[1];
 sendData[9] = '0';
 sendData[10] = 'E';
 checkstt(stt1);
 stt1++;
 RS485_send(sendData);
 oldstate = 0;
 Delay_ms(200);
 }
 }


 if (Button(&PORTB, 4, 1, 1)) {
 oldstate = 1;
 }
 if (oldstate && Button(&PORTB, 4, 1, 0)) {
 Delay_ms(100);
 if (oldstate && Button(&PORTB, 4, 1, 0))
 {
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '0';
 sendData[3] = 'B';
 sendData[4] = addressButton2[0];
 sendData[5] = addressButton2[1];
 sendData[6] = 'D';
 sendData[7] = addressDevice2[0];
 sendData[8] = addressDevice2[1];
 sendData[9] = '0';
 sendData[10] = 'E';
 checkstt(stt2);
 stt2++;
 RS485_send(sendData);
 oldstate = 0;
 Delay_ms(200);
 }
 }


 if (Button(&PORTB, 5, 1, 1)) {
 oldstate = 1;
 }

 if (oldstate && Button(&PORTB, 5, 1, 0)) {
 Delay_ms(100);
 if (oldstate && Button(&PORTB, 5, 1, 0))
 {
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '0';
 sendData[3] = 'B';
 sendData[4] = addressButton3[0];
 sendData[5] = addressButton3[1];
 sendData[6] = 'D';
 sendData[7] = addressDevice3[0];
 sendData[8] = addressDevice3[1];
 sendData[9] = '0';
 sendData[10] = 'E';
 checkstt(stt3);
 stt3++;
 RS485_send(sendData);
 oldstate = 0;
 Delay_ms(200);
 }
 }

 }
}

void RS485_send (char dat[])
{
 int i;
 PORTB.RB3 =1;
 for (i=0; i<=10;i++){
 while(UART1_Tx_Idle()==0);
 UART1_Write(dat[i]);
 }
 Delay_ms(200);
 PORTB.RB3 =0;
}

void checkstt (int stt)
{
 if (stt % 2 == 0)
 sendData[9] = '0';
 else
 sendData[9] = '1';
}
