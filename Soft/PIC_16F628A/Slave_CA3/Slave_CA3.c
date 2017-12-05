/*
Cong tac 3 nut nhan
Dia chi nut nhan 1 BIT RB0:
Dia chi Cong tac luu vao o nho 0x02,0x03
O cam ma Cong tac dieu khien luu vao 0x04,0x05

Dia chi nut nhan 2 BIT RB4:
Dia chi Cong tac luu vao o nho 0x06,0x07
O cam ma Cong tac dieu khien luu vao 0x08,0x09

Dia chi nut nhan 3 BIT RB5:
Dia chi Cong tac luu vao o nho 0x06,0x07
O cam ma Cong tac dieu khien luu vao 0x08,0x09

VD: Slave 3 nut xin cap dia chi: S02 00 00 3 1E
    Master nhan va cap 3 dia chi:
    S 12 01 06 1 1E :01 la cong tac, 06 la o cam no dieu khien
    S 12 02 07 2 1E
    S 12 03 08 3 1E
*/
bit oldstate;                                    // Old state flag
                   // trang thai nut nhan 1
char receive[11];                                // buffer for receving
                                   // buffer for sending
char WTF[11];

int stt1 =1, stt2 =1,stt3 = 1;
int busy = 0;
char flagReceivedAllData = 0;
char count = 0, tempReceiveData,receiveData[11];
char sendData[11];
char addressButton1[2], addressButton2[2], addressButton3[2];
char addressDevice1[2], addressDevice2[2], addressDevice3[2];
void RS485_send (char dat[]);
void checkstt (int stt);

// Interrupt routine
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
           busy = 1;
           count = 0;
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
          busy = 0;
        }
     }
  }
}
void main() {
  TRISB.B0 =1;
  TRISB.B4 =1;
  TRISB.B5 =1;

  TRISB.B3 =0;                         //Bit RS485

  oldstate = 0;
  UART1_Init(9600);
  Delay_ms(100);

  RCIE_bit = 1;                        // enable interrupt on UART1 receive
  TXIE_bit = 0;                        // disable interrupt on UART1 transmit
  PEIE_bit = 1;                        // enable peripheral interrupts
  GIE_bit = 1;                         // enable all interrupts

  addressButton1[0] = '0';
  addressButton1[1] = '1';
  addressDevice1[0] = '0';
  addressDevice1[1] = '1';

  addressButton2[0] = '0';
  addressButton2[1] = '2';
  addressDevice2[0] = '0';
  addressDevice2[1] = '2';

  addressButton3[0] = '0';
  addressButton3[1] = '3';
  addressDevice3[0] = '0';
  addressDevice3[1] = '3';
  /*
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
  //Delay_ms(1000);
  */
  //RS485_send(send);
  Delay_ms(100);
  //Luc dau xin Master set ma vat ly cua cong tac chum 3: S 02 0000 3 1E
  /*
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
  */
  while(1)
  {
     /*
     if(flagReceivedAllData==1){
         flagReceivedAllData = 0;
         //S12 B01 D01 1 E

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
     */
    if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
      oldstate = 1;                              // Update flag
    }
    if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
      Delay_ms(100);
      if (oldstate && Button(&PORTB, 0, 1, 0))
      {
         sendData[0] = 'S';
         sendData[1] = '0';
         sendData[2] = '0';
         sendData[3] = 'B';
         sendData[4] = '0';
         sendData[5] = '1';
         //sendData[4] = addressButton1[0];
         //sendData[5] = addressButton1[1];
         sendData[6] = 'D';
         sendData[7] = '0';
         sendData[8] = '1';
         //sendData[7] = addressDevice1[0];
         //sendData[8] = addressDevice1[1];
         sendData[9] = '0';
         sendData[10] = 'E';
         checkstt(stt1);
         stt1++;
         while(busy == 1){
            ;
         }
         Delay_ms(10);
         RS485_send(sendData);
         Delay_ms(100);
         //RS485_send(sendData);                            // Invert PORTC
         oldstate = 0;
         Delay_ms(500);
      }                              // Update flag
    }


    if (Button(&PORTB, 4, 1, 1)) {               // Detect logical one
      oldstate = 1;                              // Update flag
    }
    if (oldstate && Button(&PORTB, 4, 1, 0)) {   // Detect one-to-zero transition
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
         while(busy == 1){
            ;
         }
         RS485_send(sendData);
         Delay_ms(100);  
         //RS485_send(sendData);                          // Invert PORTC
         oldstate = 0;
         Delay_ms(500);
      }                              // Update flag
    }


    if (Button(&PORTB, 5, 1, 1)) {               // Detect logical one
      oldstate = 1;                              // Update flag
    }

    if (oldstate && Button(&PORTB, 5, 1, 0)) {   // Detect one-to-zero transition
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
         while(busy == 1){
            ;
         }
         RS485_send(sendData);
         Delay_ms(100);
         //RS485_send(sendData);
         oldstate = 0;
         Delay_ms(500);
      }
    }

  }
}

void RS485_send (char dat[])
{
    int i;
    PORTB.RB3 =1;
    Delay_ms(100);
    for (i=0; i<=10;i++){
    while(UART1_Tx_Idle()==0);
    UART1_Write(dat[i]);
    }
    Delay_ms(10);
    PORTB.RB3 =0;
}

void checkstt (int stt)
{
    if (stt % 2 == 0)
    sendData[9] = '0';
    else
    sendData[9] = '1';
}