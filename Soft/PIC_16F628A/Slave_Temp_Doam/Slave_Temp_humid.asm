
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_Temp_humid.c,44 :: 		void interrupt()
;Slave_Temp_humid.c,46 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Slave_Temp_humid.c,48 :: 		while(uart1_data_ready()==0);
L_interrupt1:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	GOTO       L_interrupt1
L_interrupt2:
;Slave_Temp_humid.c,49 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Slave_Temp_humid.c,51 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_Temp_humid.c,52 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_Temp_humid.c,54 :: 		count=0;
	CLRF       _count+0
;Slave_Temp_humid.c,55 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,56 :: 		count++;
	INCF       _count+0, 1
;Slave_Temp_humid.c,57 :: 		}
L_interrupt4:
;Slave_Temp_humid.c,58 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt59:
;Slave_Temp_humid.c,60 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,61 :: 		count++;
	INCF       _count+0, 1
;Slave_Temp_humid.c,62 :: 		}
L_interrupt7:
;Slave_Temp_humid.c,63 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Slave_Temp_humid.c,65 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_Temp_humid.c,66 :: 		count=0;
	CLRF       _count+0
;Slave_Temp_humid.c,67 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_Temp_humid.c,68 :: 		}
L_interrupt8:
;Slave_Temp_humid.c,69 :: 		}
L_interrupt3:
;Slave_Temp_humid.c,70 :: 		}
L_interrupt0:
;Slave_Temp_humid.c,71 :: 		}
L_end_interrupt:
L__interrupt64:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_Temp_humid.c,74 :: 		void main()
;Slave_Temp_humid.c,76 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_Temp_humid.c,77 :: 		TRISB.B3 =0;
	BCF        TRISB+0, 3
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
;Slave_Temp_humid.c,80 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_Temp_humid.c,81 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_Temp_humid.c,82 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_Temp_humid.c,83 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_Temp_humid.c,86 :: 		TRISB.B5 = 0;
	BCF        TRISB+0, 5
;Slave_Temp_humid.c,87 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,91 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
;Slave_Temp_humid.c,92 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,93 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,94 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,95 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,96 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,97 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,98 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,99 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,100 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_Temp_humid.c,101 :: 		sendData[8] = 'G';
	MOVLW      71
	MOVWF      _sendData+8
;Slave_Temp_humid.c,102 :: 		sendData[9] = 'G';
	MOVLW      71
	MOVWF      _sendData+9
;Slave_Temp_humid.c,103 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,106 :: 		while(1)
L_main11:
;Slave_Temp_humid.c,108 :: 		if(flagReceivedAllData==1){
	MOVF       _flagReceivedAllData+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;Slave_Temp_humid.c,109 :: 		flagReceivedAllData = 0;
	CLRF       _flagReceivedAllData+0
;Slave_Temp_humid.c,111 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[9] == 'T')
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main16
	MOVF       _receiveData+9, 0
	XORLW      84
	BTFSS      STATUS+0, 2
	GOTO       L_main16
L__main62:
;Slave_Temp_humid.c,113 :: 		sendTemp();
	CALL       _sendTemp+0
;Slave_Temp_humid.c,114 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
	NOP
	NOP
;Slave_Temp_humid.c,115 :: 		sendTemp();
	CALL       _sendTemp+0
;Slave_Temp_humid.c,116 :: 		}
L_main16:
;Slave_Temp_humid.c,117 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[9] == 'H'){
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main20
	MOVF       _receiveData+9, 0
	XORLW      72
	BTFSS      STATUS+0, 2
	GOTO       L_main20
L__main61:
;Slave_Temp_humid.c,118 :: 		sendHumid();
	CALL       _sendHumid+0
;Slave_Temp_humid.c,119 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
	NOP
;Slave_Temp_humid.c,120 :: 		sendHumid();
	CALL       _sendHumid+0
;Slave_Temp_humid.c,121 :: 		}
L_main20:
;Slave_Temp_humid.c,122 :: 		}
L_main13:
;Slave_Temp_humid.c,125 :: 		if (Button(&PORTB, 4, 1, 0)) {
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
	GOTO       L_main22
;Slave_Temp_humid.c,126 :: 		gasStatus = 1;
	MOVLW      1
	MOVWF      _gasStatus+0
	MOVLW      0
	MOVWF      _gasStatus+1
;Slave_Temp_humid.c,127 :: 		}
L_main22:
;Slave_Temp_humid.c,129 :: 		if (gasStatus == 1){
	MOVLW      0
	XORWF      _gasStatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      1
	XORWF      _gasStatus+0, 0
L__main66:
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;Slave_Temp_humid.c,130 :: 		countGas++;
	INCF       _countGas+0, 1
	BTFSC      STATUS+0, 2
	INCF       _countGas+1, 1
;Slave_Temp_humid.c,131 :: 		Delay_ms(500);
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
;Slave_Temp_humid.c,132 :: 		if(countGas == 10){
	MOVLW      0
	XORWF      _countGas+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      10
	XORWF      _countGas+0, 0
L__main67:
	BTFSS      STATUS+0, 2
	GOTO       L_main25
;Slave_Temp_humid.c,133 :: 		if (Button(&PORTB, 4, 1, 0)) {
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
	GOTO       L_main26
;Slave_Temp_humid.c,134 :: 		processSpeaker(1);
	MOVLW      1
	MOVWF      FARG_processSpeaker_mode+0
	MOVLW      0
	MOVWF      FARG_processSpeaker_mode+1
	CALL       _processSpeaker+0
;Slave_Temp_humid.c,135 :: 		}
	GOTO       L_main27
L_main26:
;Slave_Temp_humid.c,137 :: 		gasStatus = 0;
	CLRF       _gasStatus+0
	CLRF       _gasStatus+1
;Slave_Temp_humid.c,138 :: 		countGas = 0;
	CLRF       _countGas+0
	CLRF       _countGas+1
;Slave_Temp_humid.c,139 :: 		}
L_main27:
;Slave_Temp_humid.c,140 :: 		}
L_main25:
;Slave_Temp_humid.c,141 :: 		if(countGas == 20){
	MOVLW      0
	XORWF      _countGas+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      20
	XORWF      _countGas+0, 0
L__main68:
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;Slave_Temp_humid.c,142 :: 		if (Button(&PORTB, 4, 1, 0)) {
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
	GOTO       L_main29
;Slave_Temp_humid.c,143 :: 		processSpeaker(2);
	MOVLW      2
	MOVWF      FARG_processSpeaker_mode+0
	MOVLW      0
	MOVWF      FARG_processSpeaker_mode+1
	CALL       _processSpeaker+0
;Slave_Temp_humid.c,144 :: 		}
	GOTO       L_main30
L_main29:
;Slave_Temp_humid.c,146 :: 		gasStatus = 0;
	CLRF       _gasStatus+0
	CLRF       _gasStatus+1
;Slave_Temp_humid.c,147 :: 		countGas = 0;
	CLRF       _countGas+0
	CLRF       _countGas+1
;Slave_Temp_humid.c,148 :: 		}
L_main30:
;Slave_Temp_humid.c,149 :: 		}
L_main28:
;Slave_Temp_humid.c,150 :: 		if(countGas >= 30 && countGas % 10 == 0 ){
	MOVLW      128
	XORWF      _countGas+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVLW      30
	SUBWF      _countGas+0, 0
L__main69:
	BTFSS      STATUS+0, 0
	GOTO       L_main33
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _countGas+0, 0
	MOVWF      R0+0
	MOVF       _countGas+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      0
	XORWF      R0+0, 0
L__main70:
	BTFSS      STATUS+0, 2
	GOTO       L_main33
L__main60:
;Slave_Temp_humid.c,151 :: 		if (Button(&PORTB, 4, 1, 0)) {
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
	GOTO       L_main34
;Slave_Temp_humid.c,152 :: 		processSpeaker(3);
	MOVLW      3
	MOVWF      FARG_processSpeaker_mode+0
	MOVLW      0
	MOVWF      FARG_processSpeaker_mode+1
	CALL       _processSpeaker+0
;Slave_Temp_humid.c,153 :: 		sendGasStatus();
	CALL       _sendGasStatus+0
;Slave_Temp_humid.c,154 :: 		}
	GOTO       L_main35
L_main34:
;Slave_Temp_humid.c,156 :: 		gasStatus = 0;
	CLRF       _gasStatus+0
	CLRF       _gasStatus+1
;Slave_Temp_humid.c,157 :: 		countGas = 0;
	CLRF       _countGas+0
	CLRF       _countGas+1
;Slave_Temp_humid.c,158 :: 		sendGasStatus();
	CALL       _sendGasStatus+0
;Slave_Temp_humid.c,159 :: 		}
L_main35:
;Slave_Temp_humid.c,160 :: 		}
L_main33:
;Slave_Temp_humid.c,161 :: 		if(countGas == 65000){
	MOVF       _countGas+1, 0
	XORLW      253
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      232
	XORWF      _countGas+0, 0
L__main71:
	BTFSS      STATUS+0, 2
	GOTO       L_main36
;Slave_Temp_humid.c,162 :: 		countGas = 30;
	MOVLW      30
	MOVWF      _countGas+0
	MOVLW      0
	MOVWF      _countGas+1
;Slave_Temp_humid.c,163 :: 		}
L_main36:
;Slave_Temp_humid.c,164 :: 		}
L_main23:
;Slave_Temp_humid.c,166 :: 		}
	GOTO       L_main11
;Slave_Temp_humid.c,167 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RS485_send:

;Slave_Temp_humid.c,172 :: 		void RS485_send (char dat[])
;Slave_Temp_humid.c,175 :: 		PORTB.RB3 =1;
	BSF        PORTB+0, 3
;Slave_Temp_humid.c,176 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send37:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send73
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send73:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send38
;Slave_Temp_humid.c,177 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send40:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send41
	GOTO       L_RS485_send40
L_RS485_send41:
;Slave_Temp_humid.c,178 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_Temp_humid.c,176 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_Temp_humid.c,179 :: 		}
	GOTO       L_RS485_send37
L_RS485_send38:
;Slave_Temp_humid.c,180 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_RS485_send42:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send42
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send42
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send42
	NOP
	NOP
;Slave_Temp_humid.c,181 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_Temp_humid.c,182 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_initSensor:

;Slave_Temp_humid.c,184 :: 		void initSensor(void){
;Slave_Temp_humid.c,186 :: 		TRISB4_bit = 1;
	BSF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;Slave_Temp_humid.c,188 :: 		TRISB.B5 = 0;
	BCF        TRISB+0, 5
;Slave_Temp_humid.c,189 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,190 :: 		}
L_end_initSensor:
	RETURN
; end of _initSensor

_initRS485:

;Slave_Temp_humid.c,192 :: 		void initRS485(void){
;Slave_Temp_humid.c,193 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_Temp_humid.c,194 :: 		TRISB.B3 =0;
	BCF        TRISB+0, 3
;Slave_Temp_humid.c,195 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_Temp_humid.c,196 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_initRS48543:
	DECFSZ     R13+0, 1
	GOTO       L_initRS48543
	DECFSZ     R12+0, 1
	GOTO       L_initRS48543
	DECFSZ     R11+0, 1
	GOTO       L_initRS48543
	NOP
	NOP
;Slave_Temp_humid.c,197 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_Temp_humid.c,198 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_Temp_humid.c,199 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_Temp_humid.c,200 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_Temp_humid.c,201 :: 		}
L_end_initRS485:
	RETURN
; end of _initRS485

_sendTemp:

;Slave_Temp_humid.c,203 :: 		void sendTemp(void){
;Slave_Temp_humid.c,204 :: 		value = DHT11_Read();
	CALL       _DHT11_Read+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	CLRF       _value+2
	CLRF       _value+3
;Slave_Temp_humid.c,205 :: 		temp = value & 0xFF;
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
;Slave_Temp_humid.c,206 :: 		a = temp/10;
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
;Slave_Temp_humid.c,207 :: 		b = temp - 10*a;
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
;Slave_Temp_humid.c,208 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,209 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,210 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,211 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,212 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,213 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,214 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,215 :: 		sendData[7] = (char)a+48;
	MOVLW      48
	ADDWF      FLOC__sendTemp+0, 0
	MOVWF      _sendData+7
;Slave_Temp_humid.c,216 :: 		sendData[8] = (char)b+48;
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,217 :: 		sendData[9] = 'T';
	MOVLW      84
	MOVWF      _sendData+9
;Slave_Temp_humid.c,218 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,219 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,220 :: 		}
L_end_sendTemp:
	RETURN
; end of _sendTemp

_sendHumid:

;Slave_Temp_humid.c,222 :: 		void sendHumid(void){
;Slave_Temp_humid.c,223 :: 		value = DHT11_Read();
	CALL       _DHT11_Read+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	CLRF       _value+2
	CLRF       _value+3
;Slave_Temp_humid.c,224 :: 		hum = value >> 8;
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
;Slave_Temp_humid.c,225 :: 		a = hum/10;
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
;Slave_Temp_humid.c,226 :: 		b = hum - 10*a;
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
;Slave_Temp_humid.c,227 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,228 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,229 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,230 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,231 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,232 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,233 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,234 :: 		sendData[7] = (char)a+48;
	MOVLW      48
	ADDWF      FLOC__sendHumid+0, 0
	MOVWF      _sendData+7
;Slave_Temp_humid.c,235 :: 		sendData[8] = (char)b+48;
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,236 :: 		sendData[9] = 'H';
	MOVLW      72
	MOVWF      _sendData+9
;Slave_Temp_humid.c,237 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,238 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,239 :: 		}
L_end_sendHumid:
	RETURN
; end of _sendHumid

_sendGasStatus:

;Slave_Temp_humid.c,241 :: 		void sendGasStatus(void){
;Slave_Temp_humid.c,242 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_Temp_humid.c,243 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_Temp_humid.c,244 :: 		sendData[2] = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_Temp_humid.c,245 :: 		sendData[3] = 'C';
	MOVLW      67
	MOVWF      _sendData+3
;Slave_Temp_humid.c,246 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_Temp_humid.c,247 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_Temp_humid.c,248 :: 		sendData[6] = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_Temp_humid.c,249 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_Temp_humid.c,250 :: 		sendData[8] = (char)gasStatus+48;
	MOVLW      48
	ADDWF      _gasStatus+0, 0
	MOVWF      _sendData+8
;Slave_Temp_humid.c,251 :: 		sendData[9] = 'G';
	MOVLW      71
	MOVWF      _sendData+9
;Slave_Temp_humid.c,252 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_Temp_humid.c,253 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_Temp_humid.c,254 :: 		}
L_end_sendGasStatus:
	RETURN
; end of _sendGasStatus

_turnOnSpeaker:

;Slave_Temp_humid.c,256 :: 		void turnOnSpeaker(void){
;Slave_Temp_humid.c,257 :: 		PORTB.RB5 = 1;
	BSF        PORTB+0, 5
;Slave_Temp_humid.c,259 :: 		}
L_end_turnOnSpeaker:
	RETURN
; end of _turnOnSpeaker

_turnOffSpeaker:

;Slave_Temp_humid.c,261 :: 		void turnOffSpeaker(void){
;Slave_Temp_humid.c,262 :: 		PORTB.RB5 = 0;
	BCF        PORTB+0, 5
;Slave_Temp_humid.c,264 :: 		}
L_end_turnOffSpeaker:
	RETURN
; end of _turnOffSpeaker

_processSpeaker:

;Slave_Temp_humid.c,266 :: 		void processSpeaker(int mode){
;Slave_Temp_humid.c,267 :: 		if(mode == 1){
	MOVLW      0
	XORWF      FARG_processSpeaker_mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__processSpeaker82
	MOVLW      1
	XORWF      FARG_processSpeaker_mode+0, 0
L__processSpeaker82:
	BTFSS      STATUS+0, 2
	GOTO       L_processSpeaker44
;Slave_Temp_humid.c,268 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,269 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_processSpeaker45:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker45
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker45
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker45
	NOP
	NOP
;Slave_Temp_humid.c,270 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,271 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_processSpeaker46:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker46
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker46
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker46
	NOP
	NOP
;Slave_Temp_humid.c,272 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,273 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_processSpeaker47:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker47
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker47
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker47
	NOP
	NOP
;Slave_Temp_humid.c,274 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,275 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_processSpeaker48:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker48
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker48
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker48
	NOP
	NOP
;Slave_Temp_humid.c,276 :: 		}
L_processSpeaker44:
;Slave_Temp_humid.c,277 :: 		if(mode == 2){
	MOVLW      0
	XORWF      FARG_processSpeaker_mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__processSpeaker83
	MOVLW      2
	XORWF      FARG_processSpeaker_mode+0, 0
L__processSpeaker83:
	BTFSS      STATUS+0, 2
	GOTO       L_processSpeaker49
;Slave_Temp_humid.c,278 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,279 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_processSpeaker50:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker50
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker50
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker50
	NOP
	NOP
;Slave_Temp_humid.c,280 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,281 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_processSpeaker51:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker51
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker51
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker51
	NOP
	NOP
;Slave_Temp_humid.c,282 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,283 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_processSpeaker52:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker52
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker52
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker52
	NOP
	NOP
;Slave_Temp_humid.c,284 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,285 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_processSpeaker53:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker53
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker53
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker53
	NOP
	NOP
;Slave_Temp_humid.c,286 :: 		}
L_processSpeaker49:
;Slave_Temp_humid.c,287 :: 		if(mode == 3){
	MOVLW      0
	XORWF      FARG_processSpeaker_mode+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__processSpeaker84
	MOVLW      3
	XORWF      FARG_processSpeaker_mode+0, 0
L__processSpeaker84:
	BTFSS      STATUS+0, 2
	GOTO       L_processSpeaker54
;Slave_Temp_humid.c,288 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,289 :: 		Delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_processSpeaker55:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker55
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker55
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker55
	NOP
	NOP
;Slave_Temp_humid.c,290 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,291 :: 		Delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_processSpeaker56:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker56
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker56
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker56
	NOP
	NOP
;Slave_Temp_humid.c,292 :: 		turnOnSpeaker();
	CALL       _turnOnSpeaker+0
;Slave_Temp_humid.c,293 :: 		Delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_processSpeaker57:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker57
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker57
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker57
	NOP
	NOP
;Slave_Temp_humid.c,294 :: 		turnOffSpeaker();
	CALL       _turnOffSpeaker+0
;Slave_Temp_humid.c,295 :: 		Delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_processSpeaker58:
	DECFSZ     R13+0, 1
	GOTO       L_processSpeaker58
	DECFSZ     R12+0, 1
	GOTO       L_processSpeaker58
	DECFSZ     R11+0, 1
	GOTO       L_processSpeaker58
	NOP
	NOP
;Slave_Temp_humid.c,296 :: 		}
L_processSpeaker54:
;Slave_Temp_humid.c,298 :: 		}
L_end_processSpeaker:
	RETURN
; end of _processSpeaker
