/*
Cam bien nhiet do, do am
Dia chi chan data cua cam ien RB0
Dia chi Cong tac luu vao o nho 0x02,0x03

VD: Cam bien xin cap dia chi: S02 00 00 11E
    Master nhan va cap dia chi cho cam bien (vi du 04):
    S12 04 00 11E: 04 la dia chi cam bien
    
    Master goi cam bien gui nhiet do:
    S13 04 00 T1E: 04 la dia chi cam bien
    Cam bien tra loi
    S0T 04 018 1E: 018 la nhiet do
    
    Master goi cam bien gui do am:
    S13 04 00 H1E: 04 la dia chi cam bien
    Cam bien tra loi
    S0H 04 080 1E: 080 la do am
*/
sbit DHT11_PIN at RB0_bit;
sbit DHT11_PIN_Direction at TRISB0_bit;

char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];

long value;
int temp,hum;
int a,b;
int gasStatus = 0, countGas = 0;

void RS485_send(char dat[]);
void initSensor(void);
void initRS485(void);
void sendTemp(void);
void sendHumid(void);
void sendHumanStatus(void);
void sendGasStatus(void);
void turnOnSpeaker(void);
void turnOffSpeaker(void);
void processSpeaker(int mode);

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
     sendData[0] = 'S';
     sendData[1] = '0';
     sendData[2] = '0';
     sendData[3] = 'B';
     sendData[4] = '0';
     sendData[5] = '1';
     sendData[6] = 'D';
     sendData[7] = '0';
     sendData[8] = '1';
     sendData[9] = '1';
     sendData[10] = 'E';
     RS485_send(sendData);
     Delay_ms(1000);
     turnOffSpeaker();
     while(1)
     {
          if(flagReceivedAllData==1){
               flagReceivedAllData = 0;
               //receive S13 C01 000 HE
               if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'C' && receiveData[4] == '0' && receiveData[5] == '1')
               {
                     if(receiveData[9] == 'T'){
                           sendTemp();
                     }
                     if(receiveData[9] == 'H'){
                           sendHumid();
                     }
                     Delay_ms(100);
               }
          }
          
          if (Button(&PORTB, 4, 1, 0)) {
              gasStatus = 1;
          }
          
          if (gasStatus == 1){
              countGas++;
              Delay_ms(500);
              if(countGas == 10){
                  if (Button(&PORTB, 4, 1, 0)) {
                      processSpeaker(1);
                  }
                  else{
                      gasStatus = 0;
                      countGas = 0;
                  }
              }
              if(countGas == 20){
                  if (Button(&PORTB, 4, 1, 0)) {
                      processSpeaker(2);
                  }
                  else{
                      gasStatus = 0;
                      countGas = 0;
                  }
              }
              if(countGas >= 30 && countGas % 10 == 0 ){
                  if (Button(&PORTB, 4, 1, 0)) {
                      processSpeaker(3);
                      sendGasStatus();
                  }
                  else{
                      gasStatus = 0;
                      countGas = 0;
                      sendGasStatus();
                  }
              }
              if(countGas == 65000){
                  countGas = 30;
              }
          }
     }
}

/**************************************
 * RS485 SEND DATA
 **************************************/
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

void initSensor(void){
     //Cam bien khi gas
     TRISB4_bit = 1;
     //Cam bien chuyen dong
     TRISB5_bit = 1;
     //Loa
     TRISB.B5 = 0;
     turnOnSpeaker();
     //TRISA.B0 = 0;
     //turnOffSpeaker();
}

void initRS485(void){
     UART1_Init(9600);
     TRISB.B3 =0;
     Delay_ms(100);
     RCIE_bit = 1;                        // enable interrupt on UART1 receive
     TXIE_bit = 0;                        // disable interrupt on UART1 transmit
     PEIE_bit = 1;                        // enable peripheral interrupts
     GIE_bit = 1;                         // enable all interrupts
}

void sendTemp(void){
     value = DHT11_Read();
     temp = value & 0xFF;
     a = temp/10;
     b = temp - 10*a;
     sendData[0] = 'S';
     sendData[1] = '0';
     sendData[2] = '3';
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
     sendData[2] = '3';
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

void sendGasStatus(void){
     sendData[0] = 'S';
     sendData[1] = '0';
     sendData[2] = '3';
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

void turnOnSpeaker(void){
     PORTB.RB5 = 1;
     //PORTA.RA0 =0;
}

void turnOffSpeaker(void){
     PORTB.RB5 = 0;
     //PORTA.RA0 =1;
}

void processSpeaker(int mode){
     if(mode == 1){
         turnOnSpeaker();
         Delay_ms(100);
         turnOffSpeaker();
         Delay_ms(100);
         turnOnSpeaker();
         Delay_ms(100);
         turnOffSpeaker();
         Delay_ms(100);
     }
     if(mode == 2){
         turnOnSpeaker();
         Delay_ms(200);
         turnOffSpeaker();
         Delay_ms(200);
         turnOnSpeaker();
         Delay_ms(200);
         turnOffSpeaker();
         Delay_ms(200);
     }
     if(mode == 3){
         turnOnSpeaker();
         Delay_ms(400);
         turnOffSpeaker();
         Delay_ms(400);
         turnOnSpeaker();
         Delay_ms(400);
         turnOffSpeaker();
         Delay_ms(400);
     }

}