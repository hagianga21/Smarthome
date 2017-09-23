
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_CA3.c,37 :: 		void interrupt()
;Slave_CA3.c,39 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Slave_CA3.c,41 :: 		while(uart1_data_ready()==0);
L_interrupt1:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	GOTO       L_interrupt1
L_interrupt2:
;Slave_CA3.c,42 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Slave_CA3.c,44 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_CA3.c,45 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_CA3.c,47 :: 		count=0;
	CLRF       _count+0
;Slave_CA3.c,48 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,49 :: 		count++;
	INCF       _count+0, 1
;Slave_CA3.c,50 :: 		}
L_interrupt4:
;Slave_CA3.c,51 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt56:
;Slave_CA3.c,53 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,54 :: 		count++;
	INCF       _count+0, 1
;Slave_CA3.c,55 :: 		}
L_interrupt7:
;Slave_CA3.c,56 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Slave_CA3.c,58 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,59 :: 		count=0;
	CLRF       _count+0
;Slave_CA3.c,60 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_CA3.c,61 :: 		}
L_interrupt8:
;Slave_CA3.c,62 :: 		}
L_interrupt3:
;Slave_CA3.c,63 :: 		}
L_interrupt0:
;Slave_CA3.c,64 :: 		}
L_end_interrupt:
L__interrupt65:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_CA3.c,65 :: 		void main() {
;Slave_CA3.c,69 :: 		TRISB.B0 =1;
	BSF        TRISB+0, 0
;Slave_CA3.c,70 :: 		TRISB.B4 =1;
	BSF        TRISB+0, 4
;Slave_CA3.c,71 :: 		TRISB.B5 =1;
	BSF        TRISB+0, 5
;Slave_CA3.c,73 :: 		TRISB.B3 =0;                         //Bit RS485
	BCF        TRISB+0, 3
;Slave_CA3.c,75 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,76 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_CA3.c,77 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;Slave_CA3.c,79 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_CA3.c,80 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_CA3.c,81 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_CA3.c,82 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_CA3.c,85 :: 		addressButton1[0] = EEPROM_Read(0x02);
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton1+0
;Slave_CA3.c,86 :: 		addressButton1[1] = EEPROM_Read(0x03);
	MOVLW      3
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton1+1
;Slave_CA3.c,87 :: 		addressDevice1[0] = EEPROM_Read(0x04);
	MOVLW      4
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice1+0
;Slave_CA3.c,88 :: 		addressDevice1[1] = EEPROM_Read(0x05);
	MOVLW      5
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice1+1
;Slave_CA3.c,90 :: 		addressButton2[0] = EEPROM_Read(0x06);
	MOVLW      6
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton2+0
;Slave_CA3.c,91 :: 		addressButton2[1] = EEPROM_Read(0x07);
	MOVLW      7
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton2+1
;Slave_CA3.c,92 :: 		addressDevice2[0] = EEPROM_Read(0x08);
	MOVLW      8
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice2+0
;Slave_CA3.c,93 :: 		addressDevice2[1] = EEPROM_Read(0x09);
	MOVLW      9
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice2+1
;Slave_CA3.c,95 :: 		addressButton3[0] = EEPROM_Read(0x0A);
	MOVLW      10
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton3+0
;Slave_CA3.c,96 :: 		addressButton3[1] = EEPROM_Read(0x0B);
	MOVLW      11
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressButton3+1
;Slave_CA3.c,97 :: 		addressDevice3[0] = EEPROM_Read(0x0C);
	MOVLW      12
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice3+0
;Slave_CA3.c,98 :: 		addressDevice3[1] = EEPROM_Read(0x0D);
	MOVLW      13
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _addressDevice3+1
;Slave_CA3.c,102 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;Slave_CA3.c,104 :: 		if (addressButton1[0]==0xff || addressButton2[0]==0xff || addressButton3[0]==0xff){
	MOVF       _addressButton1+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L__main63
	MOVF       _addressButton2+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L__main63
	MOVF       _addressButton3+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L__main63
	GOTO       L_main13
L__main63:
;Slave_CA3.c,105 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,106 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,107 :: 		sendData[2] = '2';
	MOVLW      50
	MOVWF      _sendData+2
;Slave_CA3.c,108 :: 		sendData[3] = '0';
	MOVLW      48
	MOVWF      _sendData+3
;Slave_CA3.c,109 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_CA3.c,110 :: 		sendData[5] = '0';
	MOVLW      48
	MOVWF      _sendData+5
;Slave_CA3.c,111 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_CA3.c,112 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_CA3.c,113 :: 		sendData[8] = 'B';
	MOVLW      66
	MOVWF      _sendData+8
;Slave_CA3.c,114 :: 		sendData[9] = '3';
	MOVLW      51
	MOVWF      _sendData+9
;Slave_CA3.c,115 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,116 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,117 :: 		}
L_main13:
;Slave_CA3.c,118 :: 		WTF[0] = 'S';
	MOVLW      83
	MOVWF      _WTF+0
;Slave_CA3.c,119 :: 		WTF[1] = 'A';
	MOVLW      65
	MOVWF      _WTF+1
;Slave_CA3.c,120 :: 		WTF[2] = 'A';
	MOVLW      65
	MOVWF      _WTF+2
;Slave_CA3.c,121 :: 		WTF[3] = 'A';
	MOVLW      65
	MOVWF      _WTF+3
;Slave_CA3.c,122 :: 		WTF[4] = 'A';
	MOVLW      65
	MOVWF      _WTF+4
;Slave_CA3.c,123 :: 		WTF[5] = 'A';
	MOVLW      65
	MOVWF      _WTF+5
;Slave_CA3.c,124 :: 		WTF[6] = 'A';
	MOVLW      65
	MOVWF      _WTF+6
;Slave_CA3.c,125 :: 		WTF[7] = 'A';
	MOVLW      65
	MOVWF      _WTF+7
;Slave_CA3.c,126 :: 		WTF[8] = 'A';
	MOVLW      65
	MOVWF      _WTF+8
;Slave_CA3.c,127 :: 		WTF[9] = 'A';
	MOVLW      65
	MOVWF      _WTF+9
;Slave_CA3.c,128 :: 		WTF[10] = 'E';
	MOVLW      69
	MOVWF      _WTF+10
;Slave_CA3.c,130 :: 		while(1)
L_main14:
;Slave_CA3.c,132 :: 		if(flagReceivedAllData==1){
	MOVF       _flagReceivedAllData+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main16
;Slave_CA3.c,133 :: 		flagReceivedAllData = 0;
	CLRF       _flagReceivedAllData+0
;Slave_CA3.c,135 :: 		if(receiveData[2] == '2'){
	MOVF       _receiveData+2, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;Slave_CA3.c,136 :: 		if(receiveData[9] == '1'){
	MOVF       _receiveData+9, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;Slave_CA3.c,137 :: 		addressButton1[0] = receiveData[4];
	MOVF       _receiveData+4, 0
	MOVWF      _addressButton1+0
;Slave_CA3.c,138 :: 		addressButton1[1] = receiveData[5];
	MOVF       _receiveData+5, 0
	MOVWF      _addressButton1+1
;Slave_CA3.c,139 :: 		addressDevice1[0] = receiveData[7];
	MOVF       _receiveData+7, 0
	MOVWF      _addressDevice1+0
;Slave_CA3.c,140 :: 		addressDevice1[1] = receiveData[8];
	MOVF       _receiveData+8, 0
	MOVWF      _addressDevice1+1
;Slave_CA3.c,141 :: 		EEPROM_Write(0x02,addressButton1[0]);
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton1+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,142 :: 		EEPROM_Write(0x03,addressButton1[1]);
	MOVLW      3
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton1+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,143 :: 		EEPROM_Write(0x04,addressDevice1[0]);
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice1+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,144 :: 		EEPROM_Write(0x05,addressDevice1[1]);
	MOVLW      5
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice1+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,145 :: 		}
L_main18:
;Slave_CA3.c,146 :: 		if(receiveData[9] == '2'){
	MOVF       _receiveData+9, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;Slave_CA3.c,147 :: 		addressButton2[0] = receiveData[4];
	MOVF       _receiveData+4, 0
	MOVWF      _addressButton2+0
;Slave_CA3.c,148 :: 		addressButton2[1] = receiveData[5];
	MOVF       _receiveData+5, 0
	MOVWF      _addressButton2+1
;Slave_CA3.c,149 :: 		addressDevice2[0] = receiveData[7];
	MOVF       _receiveData+7, 0
	MOVWF      _addressDevice2+0
;Slave_CA3.c,150 :: 		addressDevice2[1] = receiveData[8];
	MOVF       _receiveData+8, 0
	MOVWF      _addressDevice2+1
;Slave_CA3.c,151 :: 		EEPROM_Write(0x06,addressButton2[0]);
	MOVLW      6
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton2+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,152 :: 		EEPROM_Write(0x07,addressButton2[1]);
	MOVLW      7
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton2+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,153 :: 		EEPROM_Write(0x08,addressDevice2[0]);
	MOVLW      8
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice2+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,154 :: 		EEPROM_Write(0x09,addressDevice2[1]);
	MOVLW      9
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice2+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,155 :: 		}
L_main19:
;Slave_CA3.c,156 :: 		if(receiveData[9] == '3'){
	MOVF       _receiveData+9, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;Slave_CA3.c,157 :: 		addressButton3[0] = receiveData[4];
	MOVF       _receiveData+4, 0
	MOVWF      _addressButton3+0
;Slave_CA3.c,158 :: 		addressButton3[1] = receiveData[5];
	MOVF       _receiveData+5, 0
	MOVWF      _addressButton3+1
;Slave_CA3.c,159 :: 		addressDevice3[0] = receiveData[7];
	MOVF       _receiveData+7, 0
	MOVWF      _addressDevice3+0
;Slave_CA3.c,160 :: 		addressDevice3[1] = receiveData[8];
	MOVF       _receiveData+8, 0
	MOVWF      _addressDevice3+1
;Slave_CA3.c,161 :: 		EEPROM_Write(0x0A,addressButton3[0]);
	MOVLW      10
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton3+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,162 :: 		EEPROM_Write(0x0B,addressButton3[1]);
	MOVLW      11
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressButton3+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,163 :: 		EEPROM_Write(0x0C,addressDevice3[0]);
	MOVLW      12
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice3+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,164 :: 		EEPROM_Write(0x0D,addressDevice3[1]);
	MOVLW      13
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _addressDevice3+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Slave_CA3.c,165 :: 		}
L_main20:
;Slave_CA3.c,166 :: 		}
L_main17:
;Slave_CA3.c,167 :: 		}
L_main16:
;Slave_CA3.c,169 :: 		if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
;Slave_CA3.c,170 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,171 :: 		}
L_main21:
;Slave_CA3.c,172 :: 		if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main24
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
L__main62:
;Slave_CA3.c,173 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
	NOP
;Slave_CA3.c,174 :: 		if (oldstate && Button(&PORTB, 0, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main28
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main28
L__main61:
;Slave_CA3.c,176 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,177 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,178 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,179 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,180 :: 		sendData[4] = addressButton1[0];
	MOVF       _addressButton1+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,181 :: 		sendData[5] = addressButton1[1];
	MOVF       _addressButton1+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,182 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,183 :: 		sendData[7] = addressDevice1[0];
	MOVF       _addressDevice1+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,184 :: 		sendData[8] = addressDevice1[1];
	MOVF       _addressDevice1+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,185 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,186 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,187 :: 		checkstt(stt1);
	MOVF       _stt1+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt1+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,188 :: 		stt1++;
	INCF       _stt1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt1+1, 1
;Slave_CA3.c,189 :: 		RS485_send(sendData);                            // Invert PORTC
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,190 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,191 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
	DECFSZ     R11+0, 1
	GOTO       L_main29
	NOP
	NOP
;Slave_CA3.c,192 :: 		}                              // Update flag
L_main28:
;Slave_CA3.c,193 :: 		}
L_main24:
;Slave_CA3.c,196 :: 		if (Button(&PORTB, 4, 1, 1)) {               // Detect logical one
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main30
;Slave_CA3.c,197 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,198 :: 		}
L_main30:
;Slave_CA3.c,199 :: 		if (oldstate && Button(&PORTB, 4, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main33
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main33
L__main60:
;Slave_CA3.c,200 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main34:
	DECFSZ     R13+0, 1
	GOTO       L_main34
	DECFSZ     R12+0, 1
	GOTO       L_main34
	DECFSZ     R11+0, 1
	GOTO       L_main34
	NOP
	NOP
;Slave_CA3.c,201 :: 		if (oldstate && Button(&PORTB, 4, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main37
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      4
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main37
L__main59:
;Slave_CA3.c,203 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,204 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,205 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,206 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,207 :: 		sendData[4] = addressButton2[0];
	MOVF       _addressButton2+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,208 :: 		sendData[5] = addressButton2[1];
	MOVF       _addressButton2+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,209 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,210 :: 		sendData[7] = addressDevice2[0];
	MOVF       _addressDevice2+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,211 :: 		sendData[8] = addressDevice2[1];
	MOVF       _addressDevice2+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,212 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,213 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,214 :: 		checkstt(stt2);
	MOVF       _stt2+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt2+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,215 :: 		stt2++;
	INCF       _stt2+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt2+1, 1
;Slave_CA3.c,216 :: 		RS485_send(sendData);                            // Invert PORTC
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,217 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,218 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
	NOP
;Slave_CA3.c,219 :: 		}                              // Update flag
L_main37:
;Slave_CA3.c,220 :: 		}
L_main33:
;Slave_CA3.c,223 :: 		if (Button(&PORTB, 5, 1, 1)) {               // Detect logical one
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main39
;Slave_CA3.c,224 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,225 :: 		}
L_main39:
;Slave_CA3.c,227 :: 		if (oldstate && Button(&PORTB, 5, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main42
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main42
L__main58:
;Slave_CA3.c,228 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	NOP
	NOP
;Slave_CA3.c,229 :: 		if (oldstate && Button(&PORTB, 5, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main46
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	MOVLW      5
	MOVWF      FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main46
L__main57:
;Slave_CA3.c,231 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,232 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,233 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,234 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,235 :: 		sendData[4] = addressButton3[0];
	MOVF       _addressButton3+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,236 :: 		sendData[5] = addressButton3[1];
	MOVF       _addressButton3+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,237 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,238 :: 		sendData[7] = addressDevice3[0];
	MOVF       _addressDevice3+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,239 :: 		sendData[8] = addressDevice3[1];
	MOVF       _addressDevice3+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,240 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,241 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,242 :: 		checkstt(stt3);
	MOVF       _stt3+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt3+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,243 :: 		stt3++;
	INCF       _stt3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt3+1, 1
;Slave_CA3.c,244 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,245 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,246 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main47:
	DECFSZ     R13+0, 1
	GOTO       L_main47
	DECFSZ     R12+0, 1
	GOTO       L_main47
	DECFSZ     R11+0, 1
	GOTO       L_main47
	NOP
	NOP
;Slave_CA3.c,247 :: 		}
L_main46:
;Slave_CA3.c,248 :: 		}
L_main42:
;Slave_CA3.c,250 :: 		}
	GOTO       L_main14
;Slave_CA3.c,251 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RS485_send:

;Slave_CA3.c,253 :: 		void RS485_send (char dat[])
;Slave_CA3.c,256 :: 		PORTB.RB3 =1;
	BSF        PORTB+0, 3
;Slave_CA3.c,257 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send48:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send68
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send68:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send49
;Slave_CA3.c,258 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send51:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send52
	GOTO       L_RS485_send51
L_RS485_send52:
;Slave_CA3.c,259 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_CA3.c,257 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_CA3.c,260 :: 		}
	GOTO       L_RS485_send48
L_RS485_send49:
;Slave_CA3.c,261 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_RS485_send53:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send53
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send53
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send53
	NOP
	NOP
;Slave_CA3.c,262 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_CA3.c,263 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_checkstt:

;Slave_CA3.c,265 :: 		void checkstt (int stt)
;Slave_CA3.c,267 :: 		if (stt % 2 == 0)
	MOVLW      2
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_checkstt_stt+0, 0
	MOVWF      R0+0
	MOVF       FARG_checkstt_stt+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__checkstt70
	MOVLW      0
	XORWF      R0+0, 0
L__checkstt70:
	BTFSS      STATUS+0, 2
	GOTO       L_checkstt54
;Slave_CA3.c,268 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
	GOTO       L_checkstt55
L_checkstt54:
;Slave_CA3.c,270 :: 		sendData[9] = '1';
	MOVLW      49
	MOVWF      _sendData+9
L_checkstt55:
;Slave_CA3.c,271 :: 		}
L_end_checkstt:
	RETURN
; end of _checkstt
