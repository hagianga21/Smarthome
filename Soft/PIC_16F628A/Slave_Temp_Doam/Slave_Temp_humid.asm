
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_Temp_humid.c,43 :: 		void interrupt()
;Slave_Temp_humid.c,45 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Slave_Temp_humid.c,47 :: 		while(uart1_data_ready()==0);
L_interrupt1:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	GOTO       L_interrupt1
L_interrupt2:
;Slave_Temp_humid.c,48 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Slave_Temp_humid.c,50 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_Temp_humid.c,51 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_Temp_humid.c,53 :: 		count=0;
	CLRF       _count+0
;Slave_Temp_humid.c,54 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,55 :: 		count++;
	INCF       _count+0, 1
;Slave_Temp_humid.c,56 :: 		}
L_interrupt4:
;Slave_Temp_humid.c,57 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt32:
;Slave_Temp_humid.c,59 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,60 :: 		count++;
	INCF       _count+0, 1
;Slave_Temp_humid.c,61 :: 		}
L_interrupt7:
;Slave_Temp_humid.c,62 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Slave_Temp_humid.c,64 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,65 :: 		count=0;
	CLRF       _count+0
;Slave_Temp_humid.c,66 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_Temp_humid.c,67 :: 		}
L_interrupt8:
;Slave_Temp_humid.c,68 :: 		}
L_interrupt3:
;Slave_Temp_humid.c,69 :: 		}
L_interrupt0:
;Slave_Temp_humid.c,70 :: 		}
L_end_interrupt:
L__interrupt35:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_Temp_humid.c,73 :: 		void main()
;Slave_Temp_humid.c,75 :: 		initSensor();
	CALL       _initSensor+0
;Slave_Temp_humid.c,76 :: 		initRS485();
	CALL       _initRS485+0
;Slave_Temp_humid.c,78 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,79 :: 		Delay_ms(100);
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
;Slave_Temp_humid.c,80 :: 		while(1)
L_main10:
;Slave_Temp_humid.c,83 :: 		if(flagReceivedAllData==1){
	MOVF       _flagReceivedAllData+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;Slave_Temp_humid.c,84 :: 		flagReceivedAllData = 0;
	CLRF       _flagReceivedAllData+0
;Slave_Temp_humid.c,86 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'C' && receiveData[4] == '0' && receiveData[5] == '1')
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _receiveData+3, 0
	XORLW      67
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _receiveData+4, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main15
	MOVF       _receiveData+5, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main15
L__main33:
;Slave_Temp_humid.c,88 :: 		if(receiveData[9] == 'T'){
	MOVF       _receiveData+9, 0
	XORLW      84
	BTFSS      STATUS+0, 2
	GOTO       L_main16
;Slave_Temp_humid.c,89 :: 		sendTemp();
	CALL       _sendTemp+0
;Slave_Temp_humid.c,90 :: 		}
L_main16:
;Slave_Temp_humid.c,91 :: 		if(receiveData[9] == 'H'){
	MOVF       _receiveData+9, 0
	XORLW      72
	BTFSS      STATUS+0, 2
	GOTO       L_main17
;Slave_Temp_humid.c,92 :: 		sendHumid();
	CALL       _sendHumid+0
;Slave_Temp_humid.c,93 :: 		}
L_main17:
;Slave_Temp_humid.c,94 :: 		if(receiveData[9] == 'M'){
	MOVF       _receiveData+9, 0
	XORLW      77
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;Slave_Temp_humid.c,95 :: 		sendHumanStatus();
	CALL       _sendHumanStatus+0
;Slave_Temp_humid.c,96 :: 		}
L_main18:
;Slave_Temp_humid.c,97 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
	NOP
;Slave_Temp_humid.c,98 :: 		}
L_main15:
;Slave_Temp_humid.c,99 :: 		}
L_main12:
;Slave_Temp_humid.c,102 :: 		if (Button(&PORTB, 5, 1, 0)) {               // Detect logical one
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
	GOTO       L_main20
;Slave_Temp_humid.c,103 :: 		humanStatus = 1;
	MOVLW      1
	MOVWF      _humanStatus+0
	MOVLW      0
	MOVWF      _humanStatus+1
;Slave_Temp_humid.c,104 :: 		}
L_main20:
;Slave_Temp_humid.c,106 :: 		if (Button(&PORTB, 4, 1, 0)) {               // Detect logical one
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
	GOTO       L_main21
;Slave_Temp_humid.c,107 :: 		gasStatus = 1;
	MOVLW      1
	MOVWF      _gasStatus+0
	MOVLW      0
	MOVWF      _gasStatus+1
;Slave_Temp_humid.c,108 :: 		countGas++;
	INCF       _countGas+0, 1
	BTFSC      STATUS+0, 2
	INCF       _countGas+1, 1
;Slave_Temp_humid.c,109 :: 		if(countGas >= 65000){
	MOVLW      253
	SUBWF      _countGas+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main37
	MOVLW      232
	SUBWF      _countGas+0, 0
L__main37:
	BTFSS      STATUS+0, 0
	GOTO       L_main22
;Slave_Temp_humid.c,110 :: 		countGas = 1;
	MOVLW      1
	MOVWF      _countGas+0
	MOVLW      0
	MOVWF      _countGas+1
;Slave_Temp_humid.c,111 :: 		}
L_main22:
;Slave_Temp_humid.c,113 :: 		if(countGas >= 15){
	MOVLW      128
	XORWF      _countGas+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVLW      15
	SUBWF      _countGas+0, 0
L__main38:
	BTFSS      STATUS+0, 0
	GOTO       L_main23
;Slave_Temp_humid.c,114 :: 		sendGasStatus();
	CALL       _sendGasStatus+0
;Slave_Temp_humid.c,115 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,116 :: 		}
L_main23:
;Slave_Temp_humid.c,117 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
;Slave_Temp_humid.c,118 :: 		}
	GOTO       L_main25
L_main21:
;Slave_Temp_humid.c,120 :: 		gasStatus = 0;
	CLRF       _gasStatus+0
	CLRF       _gasStatus+1
;Slave_Temp_humid.c,121 :: 		countGas = 0;
	CLRF       _countGas+0
	CLRF       _countGas+1
;Slave_Temp_humid.c,122 :: 		}
L_main25:
;Slave_Temp_humid.c,124 :: 		}
	GOTO       L_main10
;Slave_Temp_humid.c,125 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RS485_send:

;Slave_Temp_humid.c,130 :: 		void RS485_send (char dat[])
;Slave_Temp_humid.c,133 :: 		PORTB.RB3 =1;
	BSF        PORTB+0, 3
;Slave_Temp_humid.c,134 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send26:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send40
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send40:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send27
;Slave_Temp_humid.c,135 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send29:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send30
	GOTO       L_RS485_send29
L_RS485_send30:
;Slave_Temp_humid.c,136 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_Temp_humid.c,134 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_Temp_humid.c,137 :: 		}
	GOTO       L_RS485_send26
L_RS485_send27:
;Slave_Temp_humid.c,138 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_Temp_humid.c,139 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_initSensor:

;Slave_Temp_humid.c,141 :: 		void initSensor(void){
;Slave_Temp_humid.c,143 :: 		TRISB4_bit = 1;
	BSF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;Slave_Temp_humid.c,145 :: 		TRISB5_bit = 1;
	BSF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;Slave_Temp_humid.c,147 :: 		TRISA0_bit = 0;
	BCF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;Slave_Temp_humid.c,148 :: 		PORTA.RB0 =0;
	BCF        PORTA+0, 0
;Slave_Temp_humid.c,149 :: 		}
L_end_initSensor:
	RETURN
; end of _initSensor

_initRS485:

;Slave_Temp_humid.c,151 :: 		void initRS485(void){
;Slave_Temp_humid.c,152 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_Temp_humid.c,153 :: 		TRISB.B3 =0;
	BCF        TRISB+0, 3
;Slave_Temp_humid.c,154 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_initRS48531:
	DECFSZ     R13+0, 1
	GOTO       L_initRS48531
	DECFSZ     R12+0, 1
	GOTO       L_initRS48531
	DECFSZ     R11+0, 1
	GOTO       L_initRS48531
	NOP
	NOP
;Slave_Temp_humid.c,155 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_Temp_humid.c,156 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_Temp_humid.c,157 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_Temp_humid.c,158 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_Temp_humid.c,159 :: 		}
L_end_initRS485:
	RETURN
; end of _initRS485

_sendTemp:

;Slave_Temp_humid.c,161 :: 		void sendTemp(void){
;Slave_Temp_humid.c,162 :: 		value = DHT11_Read();
	CALL       _DHT11_Read+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	CLRF       _value+2
	CLRF       _value+3
;Slave_Temp_humid.c,163 :: 		temp = value & 0xFF;
	MOVLW      255
	ANDWF      _value+0, 0
	MOVWF      FLOC__sendTemp+2
	MOVF       _value+1, 0
	MOVWF      FLOC__sendTemp+3
	MOVLW      0
	ANDWF      FLOC__sendTemp+3, 1
	MOVF       FLOC__sendTemp+2, 0
	MOVWF      _temp+0
	MOVF       FLOC__sendTemp+3, 0
	MOVWF      _temp+1
;Slave_Temp_humid.c,164 :: 		a = temp/10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__sendTemp+2, 0
	MOVWF      R0+0
	MOVF       FLOC__sendTemp+3, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FLOC__sendTemp+0
	MOVF       R0+1, 0
	MOVWF      FLOC__sendTemp+1
	MOVF       FLOC__sendTemp+0, 0
	MOVWF      _a+0
	MOVF       FLOC__sendTemp+1, 0
	MOVWF      _a+1
;Slave_Temp_humid.c,165 :: 		b = temp - 10*a;
	MOVLW      10
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVF       FLOC__sendTemp+0, 0
	MOVWF      R4+0
	MOVF       FLOC__sendTemp+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	SUBWF      FLOC__sendTemp+2, 0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FLOC__sendTemp+3, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _b+0
	MOVF       R0+1, 0
	MOVWF      _b+1
;Slave_Temp_humid.c,166 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,167 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,168 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,169 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,170 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,171 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,172 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,173 :: 		sendData[7] = (char)a+48;
	MOVLW      48
	ADDWF      FLOC__sendTemp+0, 0
	MOVWF      _sendData+7
;Slave_Temp_humid.c,174 :: 		sendData[8] = (char)b+48;
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,175 :: 		sendData[9] = 'T';
	MOVLW      84
	MOVWF      _sendData+9
;Slave_Temp_humid.c,176 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,177 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,178 :: 		}
L_end_sendTemp:
	RETURN
; end of _sendTemp

_sendHumid:

;Slave_Temp_humid.c,180 :: 		void sendHumid(void){
;Slave_Temp_humid.c,181 :: 		value = DHT11_Read();
	CALL       _DHT11_Read+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	CLRF       _value+2
	CLRF       _value+3
;Slave_Temp_humid.c,182 :: 		hum = value >> 8;
	MOVF       _value+1, 0
	MOVWF      FLOC__sendHumid+2
	MOVF       _value+2, 0
	MOVWF      FLOC__sendHumid+3
	MOVF       _value+3, 0
	MOVWF      FLOC__sendHumid+4
	MOVLW      0
	BTFSC      _value+3, 7
	MOVLW      255
	MOVWF      FLOC__sendHumid+5
	MOVF       FLOC__sendHumid+2, 0
	MOVWF      _hum+0
	MOVF       FLOC__sendHumid+3, 0
	MOVWF      _hum+1
;Slave_Temp_humid.c,183 :: 		a = hum/10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__sendHumid+2, 0
	MOVWF      R0+0
	MOVF       FLOC__sendHumid+3, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FLOC__sendHumid+0
	MOVF       R0+1, 0
	MOVWF      FLOC__sendHumid+1
	MOVF       FLOC__sendHumid+0, 0
	MOVWF      _a+0
	MOVF       FLOC__sendHumid+1, 0
	MOVWF      _a+1
;Slave_Temp_humid.c,184 :: 		b = hum - 10*a;
	MOVLW      10
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVF       FLOC__sendHumid+0, 0
	MOVWF      R4+0
	MOVF       FLOC__sendHumid+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	SUBWF      FLOC__sendHumid+2, 0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FLOC__sendHumid+3, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _b+0
	MOVF       R0+1, 0
	MOVWF      _b+1
;Slave_Temp_humid.c,185 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,186 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,187 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,188 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,189 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,190 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,191 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,192 :: 		sendData[7] = (char)a+48;
	MOVLW      48
	ADDWF      FLOC__sendHumid+0, 0
	MOVWF      _sendData+7
;Slave_Temp_humid.c,193 :: 		sendData[8] = (char)b+48;
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,194 :: 		sendData[9] = 'H';
	MOVLW      72
	MOVWF      _sendData+9
;Slave_Temp_humid.c,195 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,196 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,197 :: 		}
L_end_sendHumid:
	RETURN
; end of _sendHumid

_sendHumanStatus:

;Slave_Temp_humid.c,199 :: 		void sendHumanStatus(void){
;Slave_Temp_humid.c,200 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,201 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,202 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,203 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,204 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,205 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,206 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,207 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_Temp_humid.c,208 :: 		sendData[8] = (char)humanStatus+48;
	MOVLW      48
	ADDWF      _humanStatus+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,209 :: 		sendData[9] = 'M';
	MOVLW      77
	MOVWF      _sendData+9
;Slave_Temp_humid.c,210 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,211 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,212 :: 		}
L_end_sendHumanStatus:
	RETURN
; end of _sendHumanStatus

_sendGasStatus:

;Slave_Temp_humid.c,214 :: 		void sendGasStatus(void){
;Slave_Temp_humid.c,215 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,216 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,217 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,218 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,219 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,220 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,221 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,222 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_Temp_humid.c,223 :: 		sendData[8] = (char)gasStatus+48;
	MOVLW      48
	ADDWF      _gasStatus+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,224 :: 		sendData[9] = 'G';
	MOVLW      71
	MOVWF      _sendData+9
;Slave_Temp_humid.c,225 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,226 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,227 :: 		}
L_end_sendGasStatus:
	RETURN
; end of _sendGasStatus

_turnOnSpeaker:

;Slave_Temp_humid.c,229 :: 		void turnOnSpeaker(void){
;Slave_Temp_humid.c,230 :: 		PORTA.RB0 =0;
	BCF        PORTA+0, 0
;Slave_Temp_humid.c,231 :: 		}
L_end_turnOnSpeaker:
	RETURN
; end of _turnOnSpeaker

_turnOffSpeaker:

;Slave_Temp_humid.c,233 :: 		void turnOffSpeaker(void){
;Slave_Temp_humid.c,234 :: 		PORTA.RB0 =1;
	BSF        PORTA+0, 0
;Slave_Temp_humid.c,235 :: 		}
L_end_turnOffSpeaker:
	RETURN
; end of _turnOffSpeaker
