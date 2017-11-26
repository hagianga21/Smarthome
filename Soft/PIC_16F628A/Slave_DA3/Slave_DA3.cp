#line 1 "E:/LVTN/Smarthome/Soft/PIC_16F628A/Slave_DA3/Slave_DA3.c"
#line 21 "E:/LVTN/Smarthome/Soft/PIC_16F628A/Slave_DA3/Slave_DA3.c"
bit oldstate;

int stt1 =1, stt2 =1,stt3 = 1;
char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];
char addressDevice1[2], addressDevice2[2], addressDevice3[2];
void RS485_send (char dat[]);



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
 TRISB.B0 =0;
 TRISB.B4 =0;
 TRISB.B5 =0;

 TRISB.B3 =0;

 oldstate = 0;
 UART1_Init(9600);
 Delay_ms(100);

 RCIE_bit = 1;
 TXIE_bit = 0;
 PEIE_bit = 1;
 GIE_bit = 1;

 addressDevice1[0] = '0';
 addressDevice1[1] = '1';
 addressDevice2[0] = '0';
 addressDevice2[1] = '2';
 addressDevice3[0] = '0';
 addressDevice3[1] = '3';
#line 92 "E:/LVTN/Smarthome/Soft/PIC_16F628A/Slave_DA3/Slave_DA3.c"
 Delay_ms(100);
#line 110 "E:/LVTN/Smarthome/Soft/PIC_16F628A/Slave_DA3/Slave_DA3.c"
 Delay_ms(1000);
 while(1)
 {

 if(flagReceivedAllData==1){
 flagReceivedAllData = 0;
#line 140 "E:/LVTN/Smarthome/Soft/PIC_16F628A/Slave_DA3/Slave_DA3.c"
 if(receiveData[1] == '1' && receiveData[2] == '0' && receiveData[3] == 'D'){
 if(receiveData[4] == addressDevice1[0] && receiveData[5] == addressDevice1[1]){
 if(receiveData[9] == '1'){
 PORTB.RB0 =1;
 }
 if(receiveData[9] == '0'){
 PORTB.RB0 =0;
 }
 }
 if(receiveData[4] == addressDevice2[0] && receiveData[5] == addressDevice2[1]){
 if(receiveData[9] == '1'){
 PORTB.RB4 =1;
 }
 if(receiveData[9] == '0'){
 PORTB.RB4 =0;
 }
 }
 if(receiveData[4] == addressDevice3[0] && receiveData[5] == addressDevice3[1]){
 if(receiveData[9] == '1'){
 PORTB.RB5 =1;
 }
 if(receiveData[9] == '0'){
 PORTB.RB5 =0;
 }
 }
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
 Delay_ms(100);
 PORTB.RB3 =0;
}
