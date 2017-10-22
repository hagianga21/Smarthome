#line 1 "E:/MYPROJECTINHCMUT/Doan1/Testcode/PIC/Slave_Temp_Doam/Slave_Temp_humid.c"
#line 20 "E:/MYPROJECTINHCMUT/Doan1/Testcode/PIC/Slave_Temp_Doam/Slave_Temp_humid.c"
sbit DHT11_PIN at RB0_bit;
sbit DHT11_PIN_Direction at TRISB0_bit;

char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];

long value;
int temp,hum;
int a,b;
int humanStatus = 0;
int gasStatus = 0, countGas = 0;

void RS485_send(char dat[]);
void initSensor(void);
void initRS485(void);
void sendTemp(void);
void sendHumid(void);
void sendHumanStatus(void);
void sendGasStatus(void);

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


void main()
{
 initSensor();
 initRS485();
 Delay_ms(100);
 while(1)
 {
 if(flagReceivedAllData==1){
 flagReceivedAllData = 0;

 if(receiveData[1] == '1' && receiveData[2] == '2' && receiveData[3] == 'C' && receiveData[4] == '0' && receiveData[5] == '1')
 {
 if(receiveData[9] == 'T'){
 sendTemp();
 }
 if(receiveData[9] == 'H'){
 sendHumid();
 }
 if(receiveData[9] == 'M'){
 sendHumanStatus();
 }
 Delay_ms(100);
 }
 }

 if (Button(&PORTB, 5, 1, 0)) {
 humanStatus = 1;
 }

 if (Button(&PORTB, 4, 1, 0)) {
 gasStatus = 1;
 countGas++;
 if(countGas == 10){
 sendGasStatus();
 PORTA.RB0 =1;
 }
 Delay_ms(500);
 }
 else{
 gasStatus = 0;
 countGas = 0;
 }
 }
}
#line 119 "E:/MYPROJECTINHCMUT/Doan1/Testcode/PIC/Slave_Temp_Doam/Slave_Temp_humid.c"
void RS485_send (char dat[])
{
 int i;
 PORTB.RB3 =1;
 for (i=0; i<=9;i++){
 while(UART1_Tx_Idle()==0);
 UART1_Write(dat[i]);
 }
 PORTB.RB3 =0;
}

void initSensor(void){

 TRISB4_bit = 1;

 TRISB5_bit = 1;

 TRISA0_bit = 0;
 PORTA.RB0 =0;
}

void initRS485(void){
 UART1_Init(9600);
 TRISB.B3 =0;
 Delay_ms(100);
 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;
}

void sendTemp(void){
 value = DHT11_Read();
 temp = value & 0xFF;
 a = temp/10;
 b = temp - 10*a;
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '2';
 sendData[3] = 'C';
 sendData[4] = '0';
 sendData[5] = '1';
 sendData[6] = '0';
 sendData[7] = (char)a+48;
 sendData[8] = (char)b+48;
 sendData[9] = 'T';
 sendData[10] = 'E';
 RS485_send(sendData);
}

void sendHumid(void){
 value = DHT11_Read();
 hum = value >> 8;
 a = hum/10;
 b = hum - 10*a;
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '2';
 sendData[3] = 'C';
 sendData[4] = '0';
 sendData[5] = '1';
 sendData[6] = '0';
 sendData[7] = (char)a+48;
 sendData[8] = (char)b+48;
 sendData[9] = 'H';
 sendData[10] = 'E';
 RS485_send(sendData);
}

void sendHumanStatus(void){
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '2';
 sendData[3] = 'C';
 sendData[4] = '0';
 sendData[5] = '1';
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = (char)humanStatus+48;
 sendData[9] = 'M';
 sendData[10] = 'E';
 RS485_send(sendData);
}

void sendGasStatus(void){
 sendData[0] = 'S';
 sendData[1] = '0';
 sendData[2] = '2';
 sendData[3] = 'C';
 sendData[4] = '0';
 sendData[5] = '1';
 sendData[6] = '0';
 sendData[7] = '0';
 sendData[8] = (char)gasStatus+48;
 sendData[9] = 'G';
 sendData[10] = 'E';
 RS485_send(sendData);
}
