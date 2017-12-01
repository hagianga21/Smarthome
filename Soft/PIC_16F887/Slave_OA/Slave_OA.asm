
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_OA.c,80 :: 		void interrupt()
;Slave_OA.c,82 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Slave_OA.c,84 :: 		while(uart1_data_ready()==0);
L_interrupt1:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	GOTO       L_interrupt1
L_interrupt2:
;Slave_OA.c,85 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Slave_OA.c,87 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_OA.c,88 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_OA.c,90 :: 		count=0;
	CLRF       _count+0
;Slave_OA.c,91 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,92 :: 		count++;
	INCF       _count+0, 1
;Slave_OA.c,93 :: 		}
L_interrupt4:
;Slave_OA.c,94 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt127:
;Slave_OA.c,96 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,97 :: 		count++;
	INCF       _count+0, 1
;Slave_OA.c,98 :: 		}
L_interrupt7:
;Slave_OA.c,99 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Slave_OA.c,101 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,102 :: 		count=0;
	CLRF       _count+0
;Slave_OA.c,103 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_OA.c,104 :: 		}
L_interrupt8:
;Slave_OA.c,105 :: 		}
L_interrupt3:
;Slave_OA.c,106 :: 		}
L_interrupt0:
;Slave_OA.c,107 :: 		}
L_end_interrupt:
L__interrupt142:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_OA.c,112 :: 		void main()
;Slave_OA.c,114 :: 		ANSEL  = 0;
	CLRF       ANSEL+0
;Slave_OA.c,115 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;Slave_OA.c,116 :: 		C1ON_bit = 0;
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;Slave_OA.c,117 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;Slave_OA.c,118 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,120 :: 		TRISB.B0 = 1;
	BSF        TRISB+0, 0
;Slave_OA.c,121 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,123 :: 		TRISD.B4 = 0;
	BCF        TRISD+0, 4
;Slave_OA.c,125 :: 		TRISD.B5 = 0;
	BCF        TRISD+0, 5
;Slave_OA.c,126 :: 		turnOffRelay();
	CALL       _turnOffRelay+0
;Slave_OA.c,127 :: 		Config_sendData();
	CALL       _Config_sendData+0
;Slave_OA.c,128 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,129 :: 		voltage = 10;
	MOVLW      0
	MOVWF      _voltage+0
	MOVLW      0
	MOVWF      _voltage+1
	MOVLW      32
	MOVWF      _voltage+2
	MOVLW      130
	MOVWF      _voltage+3
;Slave_OA.c,130 :: 		ampe = 0.2;
	MOVLW      205
	MOVWF      _ampe+0
	MOVLW      204
	MOVWF      _ampe+1
	MOVLW      76
	MOVWF      _ampe+2
	MOVLW      124
	MOVWF      _ampe+3
;Slave_OA.c,131 :: 		activepower = 10;
	MOVLW      0
	MOVWF      _activepower+0
	MOVLW      0
	MOVWF      _activepower+1
	MOVLW      32
	MOVWF      _activepower+2
	MOVLW      130
	MOVWF      _activepower+3
;Slave_OA.c,133 :: 		TRISC.B0 = 0;
	BCF        TRISC+0, 0
;Slave_OA.c,134 :: 		PORTC.B0 = 1;
	BSF        PORTC+0, 0
;Slave_OA.c,136 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_OA.c,137 :: 		RCIE_bit = 1;
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_OA.c,138 :: 		TXIE_bit = 0;
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_OA.c,139 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_OA.c,140 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_OA.c,141 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
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
;Slave_OA.c,142 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_HIGH_2_LOW);
	MOVLW      2
	MOVWF      FARG_SPI1_Init_Advanced_master+0
	CLRF       FARG_SPI1_Init_Advanced_data_sample+0
	CLRF       FARG_SPI1_Init_Advanced_clock_idle+0
	CLRF       FARG_SPI1_Init_Advanced_transmit_edge+0
	CALL       _SPI1_Init_Advanced+0
;Slave_OA.c,143 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
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
;Slave_OA.c,144 :: 		Write_ADE7753(GAIN,0x0,1);
	MOVLW      15
	MOVWF      FARG_Write_ADE7753_add+0
	CLRF       FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      1
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,145 :: 		Write_ADE7753(MODE,0x008C,2);                      //0b0000000010001100
	MOVLW      9
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      140
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,149 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
;Slave_OA.c,151 :: 		while(1){
L_main12:
;Slave_OA.c,154 :: 		activepower = getAPOWER();
	CALL       _getAPOWER+0
	MOVF       R0+0, 0
	MOVWF      _activepower+0
	MOVF       R0+1, 0
	MOVWF      _activepower+1
	MOVF       R0+2, 0
	MOVWF      _activepower+2
	MOVF       R0+3, 0
	MOVWF      _activepower+3
;Slave_OA.c,155 :: 		if(flagReceivedAllData == 1){
	MOVF       _flagReceivedAllData+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main14
;Slave_OA.c,156 :: 		flagReceivedAllData = 0;
	CLRF       _flagReceivedAllData+0
;Slave_OA.c,157 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	NOP
	NOP
;Slave_OA.c,158 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'D' && receiveData[4] == '0' && receiveData[5] == '4' && receiveData[6] == '0' && receiveData[7] == '0' && receiveData[8] == '0' && receiveData[9] == 'V'){
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+3, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+4, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+5, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+6, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+7, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+8, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main18
	MOVF       _receiveData+9, 0
	XORLW      86
	BTFSS      STATUS+0, 2
	GOTO       L_main18
L__main131:
;Slave_OA.c,159 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
;Slave_OA.c,161 :: 		sendVolt(voltage);
	MOVF       _voltage+0, 0
	MOVWF      FARG_sendVolt_so+0
	MOVF       _voltage+1, 0
	MOVWF      FARG_sendVolt_so+1
	MOVF       _voltage+2, 0
	MOVWF      FARG_sendVolt_so+2
	MOVF       _voltage+3, 0
	MOVWF      FARG_sendVolt_so+3
	CALL       _sendVolt+0
;Slave_OA.c,162 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
;Slave_OA.c,163 :: 		}
L_main18:
;Slave_OA.c,164 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'D'
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+3, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;Slave_OA.c,165 :: 		&& receiveData[4] == '0' && receiveData[5] == '4' && receiveData[6] == '0'
	MOVF       _receiveData+4, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+5, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+6, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;Slave_OA.c,166 :: 		&& receiveData[7] == '0' && receiveData[8] == '0' && receiveData[9] == 'I'){
	MOVF       _receiveData+7, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+8, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _receiveData+9, 0
	XORLW      73
	BTFSS      STATUS+0, 2
	GOTO       L_main23
L__main130:
;Slave_OA.c,167 :: 		Delay_ms(500);
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
;Slave_OA.c,169 :: 		sendAmpe(ampe);
	MOVF       _ampe+0, 0
	MOVWF      FARG_sendAmpe_so+0
	MOVF       _ampe+1, 0
	MOVWF      FARG_sendAmpe_so+1
	MOVF       _ampe+2, 0
	MOVWF      FARG_sendAmpe_so+2
	MOVF       _ampe+3, 0
	MOVWF      FARG_sendAmpe_so+3
	CALL       _sendAmpe+0
;Slave_OA.c,170 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
;Slave_OA.c,171 :: 		}
L_main23:
;Slave_OA.c,172 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'D'
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+3, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;Slave_OA.c,173 :: 		&& receiveData[4] == '0' && receiveData[5] == '4' && receiveData[6] == '0'
	MOVF       _receiveData+4, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+5, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+6, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;Slave_OA.c,174 :: 		&& receiveData[7] == '0' && receiveData[8] == '0' && receiveData[9] == 'P'){
	MOVF       _receiveData+7, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+8, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _receiveData+9, 0
	XORLW      80
	BTFSS      STATUS+0, 2
	GOTO       L_main28
L__main129:
;Slave_OA.c,175 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
	DECFSZ     R11+0, 1
	GOTO       L_main29
	NOP
;Slave_OA.c,177 :: 		sendPower(activepower);
	MOVF       _activepower+0, 0
	MOVWF      FARG_sendPower_so+0
	MOVF       _activepower+1, 0
	MOVWF      FARG_sendPower_so+1
	MOVF       _activepower+2, 0
	MOVWF      FARG_sendPower_so+2
	MOVF       _activepower+3, 0
	MOVWF      FARG_sendPower_so+3
	CALL       _sendPower+0
;Slave_OA.c,178 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
	DECFSZ     R11+0, 1
	GOTO       L_main30
	NOP
;Slave_OA.c,179 :: 		}
L_main28:
;Slave_OA.c,181 :: 		}
L_main14:
;Slave_OA.c,182 :: 		if (Button(&PORTB, 0, 1, 1)) {
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
	GOTO       L_main31
;Slave_OA.c,183 :: 		oldstate = 1;
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,184 :: 		}
L_main31:
;Slave_OA.c,185 :: 		if (oldstate && Button(&PORTB, 0, 1, 0)) {
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main34
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
L__main128:
;Slave_OA.c,187 :: 		if(relayStatus == 0){
	MOVLW      0
	XORWF      _relayStatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main144
	MOVLW      0
	XORWF      _relayStatus+0, 0
L__main144:
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;Slave_OA.c,188 :: 		turnOnRelay();
	CALL       _turnOnRelay+0
;Slave_OA.c,189 :: 		relayStatus++;
	INCF       _relayStatus+0, 1
	BTFSC      STATUS+0, 2
	INCF       _relayStatus+1, 1
;Slave_OA.c,190 :: 		}
	GOTO       L_main36
L_main35:
;Slave_OA.c,192 :: 		turnOffRelay();
	CALL       _turnOffRelay+0
;Slave_OA.c,193 :: 		relayStatus = 0;
	CLRF       _relayStatus+0
	CLRF       _relayStatus+1
;Slave_OA.c,194 :: 		}
L_main36:
;Slave_OA.c,195 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,196 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
	NOP
;Slave_OA.c,197 :: 		}
L_main34:
;Slave_OA.c,218 :: 		}
	GOTO       L_main12
;Slave_OA.c,219 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Write_ADE7753:

;Slave_OA.c,224 :: 		void Write_ADE7753(char add, long write_buffer, int bytes_to_write)
;Slave_OA.c,230 :: 		add = add|cmd;
	MOVLW      128
	IORWF      FARG_Write_ADE7753_add+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Write_ADE7753_add+0
;Slave_OA.c,231 :: 		CS = 0;
	BCF        PORTC+0, 0
;Slave_OA.c,232 :: 		SPI1_Write(add);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,233 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Write_ADE775338:
	DECFSZ     R13+0, 1
	GOTO       L_Write_ADE775338
	DECFSZ     R12+0, 1
	GOTO       L_Write_ADE775338
	NOP
	NOP
;Slave_OA.c,235 :: 		for (i = 0; i < bytes_to_write; i++)
	CLRF       Write_ADE7753_i_L0+0
	CLRF       Write_ADE7753_i_L0+1
L_Write_ADE775339:
	MOVLW      128
	XORWF      Write_ADE7753_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_Write_ADE7753_bytes_to_write+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Write_ADE7753146
	MOVF       FARG_Write_ADE7753_bytes_to_write+0, 0
	SUBWF      Write_ADE7753_i_L0+0, 0
L__Write_ADE7753146:
	BTFSC      STATUS+0, 0
	GOTO       L_Write_ADE775340
;Slave_OA.c,237 :: 		this_write = (char) (write_buffer>> (8*((bytes_to_write-1)-i)));
	MOVLW      1
	SUBWF      FARG_Write_ADE7753_bytes_to_write+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FARG_Write_ADE7753_bytes_to_write+1, 0
	MOVWF      R0+1
	MOVF       Write_ADE7753_i_L0+0, 0
	SUBWF      R0+0, 0
	MOVWF      R3+0
	MOVF       Write_ADE7753_i_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Write_ADE7753147:
	BTFSC      STATUS+0, 2
	GOTO       L__Write_ADE7753148
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__Write_ADE7753147
L__Write_ADE7753148:
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       FARG_Write_ADE7753_write_buffer+0, 0
	MOVWF      R0+0
	MOVF       FARG_Write_ADE7753_write_buffer+1, 0
	MOVWF      R0+1
	MOVF       FARG_Write_ADE7753_write_buffer+2, 0
	MOVWF      R0+2
	MOVF       FARG_Write_ADE7753_write_buffer+3, 0
	MOVWF      R0+3
	MOVF       R4+0, 0
L__Write_ADE7753149:
	BTFSC      STATUS+0, 2
	GOTO       L__Write_ADE7753150
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	BTFSC      R0+3, 6
	BSF        R0+3, 7
	ADDLW      255
	GOTO       L__Write_ADE7753149
L__Write_ADE7753150:
;Slave_OA.c,238 :: 		SPI1_Write(this_write);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,239 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Write_ADE775342:
	DECFSZ     R13+0, 1
	GOTO       L_Write_ADE775342
	DECFSZ     R12+0, 1
	GOTO       L_Write_ADE775342
	NOP
	NOP
;Slave_OA.c,235 :: 		for (i = 0; i < bytes_to_write; i++)
	INCF       Write_ADE7753_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Write_ADE7753_i_L0+1, 1
;Slave_OA.c,240 :: 		}
	GOTO       L_Write_ADE775339
L_Write_ADE775340:
;Slave_OA.c,241 :: 		CS=1;
	BSF        PORTC+0, 0
;Slave_OA.c,242 :: 		}
L_end_Write_ADE7753:
	RETURN
; end of _Write_ADE7753

_Read_ADE7753:

;Slave_OA.c,246 :: 		long Read_ADE7753(char add, char bytes_to_read)
;Slave_OA.c,251 :: 		CS = 0;
	BCF        PORTC+0, 0
;Slave_OA.c,252 :: 		SPI1_Write(add);
	MOVF       FARG_Read_ADE7753_add+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,253 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Read_ADE775343:
	DECFSZ     R13+0, 1
	GOTO       L_Read_ADE775343
	DECFSZ     R12+0, 1
	GOTO       L_Read_ADE775343
	NOP
	NOP
;Slave_OA.c,254 :: 		for (i = 1; i <= bytes_to_read; i++)
	MOVLW      1
	MOVWF      Read_ADE7753_i_L0+0
	MOVLW      0
	MOVWF      Read_ADE7753_i_L0+1
L_Read_ADE775344:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      Read_ADE7753_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Read_ADE7753152
	MOVF       Read_ADE7753_i_L0+0, 0
	SUBWF      FARG_Read_ADE7753_bytes_to_read+0, 0
L__Read_ADE7753152:
	BTFSS      STATUS+0, 0
	GOTO       L_Read_ADE775345
;Slave_OA.c,256 :: 		reader_buf =  SPI1_Read(0x00);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
	MOVF       R0+0, 0
	MOVWF      Read_ADE7753_reader_buf_L0+0
;Slave_OA.c,257 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Read_ADE775347:
	DECFSZ     R13+0, 1
	GOTO       L_Read_ADE775347
	DECFSZ     R12+0, 1
	GOTO       L_Read_ADE775347
	NOP
	NOP
;Slave_OA.c,258 :: 		result = result | reader_buf;
	MOVF       Read_ADE7753_reader_buf_L0+0, 0
	IORWF      Read_ADE7753_result_L0+0, 1
	MOVLW      0
	IORWF      Read_ADE7753_result_L0+1, 1
	IORWF      Read_ADE7753_result_L0+2, 1
	IORWF      Read_ADE7753_result_L0+3, 1
;Slave_OA.c,259 :: 		if(i < bytes_to_read)
	MOVLW      128
	XORWF      Read_ADE7753_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Read_ADE7753153
	MOVF       FARG_Read_ADE7753_bytes_to_read+0, 0
	SUBWF      Read_ADE7753_i_L0+0, 0
L__Read_ADE7753153:
	BTFSC      STATUS+0, 0
	GOTO       L_Read_ADE775348
;Slave_OA.c,260 :: 		result = result << 8;
	MOVF       Read_ADE7753_result_L0+2, 0
	MOVWF      Read_ADE7753_result_L0+3
	MOVF       Read_ADE7753_result_L0+1, 0
	MOVWF      Read_ADE7753_result_L0+2
	MOVF       Read_ADE7753_result_L0+0, 0
	MOVWF      Read_ADE7753_result_L0+1
	CLRF       Read_ADE7753_result_L0+0
L_Read_ADE775348:
;Slave_OA.c,254 :: 		for (i = 1; i <= bytes_to_read; i++)
	INCF       Read_ADE7753_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Read_ADE7753_i_L0+1, 1
;Slave_OA.c,261 :: 		}
	GOTO       L_Read_ADE775344
L_Read_ADE775345:
;Slave_OA.c,262 :: 		CS = 1;
	BSF        PORTC+0, 0
;Slave_OA.c,263 :: 		return result;
	MOVF       Read_ADE7753_result_L0+0, 0
	MOVWF      R0+0
	MOVF       Read_ADE7753_result_L0+1, 0
	MOVWF      R0+1
	MOVF       Read_ADE7753_result_L0+2, 0
	MOVWF      R0+2
	MOVF       Read_ADE7753_result_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,264 :: 		}
L_end_Read_ADE7753:
	RETURN
; end of _Read_ADE7753

_HienthiUART:

;Slave_OA.c,268 :: 		void HienthiUART (long outputADE, int bytes_to_write)
;Slave_OA.c,272 :: 		for (i = 0; i < bytes_to_write; i++)
	CLRF       HienthiUART_i_L0+0
	CLRF       HienthiUART_i_L0+1
L_HienthiUART49:
	MOVLW      128
	XORWF      HienthiUART_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_HienthiUART_bytes_to_write+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__HienthiUART155
	MOVF       FARG_HienthiUART_bytes_to_write+0, 0
	SUBWF      HienthiUART_i_L0+0, 0
L__HienthiUART155:
	BTFSC      STATUS+0, 0
	GOTO       L_HienthiUART50
;Slave_OA.c,274 :: 		this_write = (char) (outputADE>> (8*((bytes_to_write-1)-i)));
	MOVLW      1
	SUBWF      FARG_HienthiUART_bytes_to_write+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FARG_HienthiUART_bytes_to_write+1, 0
	MOVWF      R0+1
	MOVF       HienthiUART_i_L0+0, 0
	SUBWF      R0+0, 0
	MOVWF      R3+0
	MOVF       HienthiUART_i_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__HienthiUART156:
	BTFSC      STATUS+0, 2
	GOTO       L__HienthiUART157
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__HienthiUART156
L__HienthiUART157:
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       FARG_HienthiUART_outputADE+0, 0
	MOVWF      R0+0
	MOVF       FARG_HienthiUART_outputADE+1, 0
	MOVWF      R0+1
	MOVF       FARG_HienthiUART_outputADE+2, 0
	MOVWF      R0+2
	MOVF       FARG_HienthiUART_outputADE+3, 0
	MOVWF      R0+3
	MOVF       R4+0, 0
L__HienthiUART158:
	BTFSC      STATUS+0, 2
	GOTO       L__HienthiUART159
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	BTFSC      R0+3, 6
	BSF        R0+3, 7
	ADDLW      255
	GOTO       L__HienthiUART158
L__HienthiUART159:
;Slave_OA.c,275 :: 		UART1_Write(this_write);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_OA.c,272 :: 		for (i = 0; i < bytes_to_write; i++)
	INCF       HienthiUART_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       HienthiUART_i_L0+1, 1
;Slave_OA.c,276 :: 		}
	GOTO       L_HienthiUART49
L_HienthiUART50:
;Slave_OA.c,277 :: 		}
L_end_HienthiUART:
	RETURN
; end of _HienthiUART

_Hienthisofloat:

;Slave_OA.c,281 :: 		void Hienthisofloat (float so){
;Slave_OA.c,284 :: 		FloatToStr(so,kq);
	MOVF       FARG_Hienthisofloat_so+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_Hienthisofloat_so+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_Hienthisofloat_so+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_Hienthisofloat_so+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      Hienthisofloat_kq_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Slave_OA.c,285 :: 		UART1_Write_Text(kq);
	MOVLW      Hienthisofloat_kq_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Slave_OA.c,286 :: 		}
L_end_Hienthisofloat:
	RETURN
; end of _Hienthisofloat

_sendVolt:

;Slave_OA.c,288 :: 		void sendVolt(float so){
;Slave_OA.c,290 :: 		FloatToStr(so,kq);
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      sendVolt_kq_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Slave_OA.c,291 :: 		if(so == 0){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendVolt52
;Slave_OA.c,292 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,293 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,294 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,295 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,296 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,297 :: 		}
L_sendVolt52:
;Slave_OA.c,298 :: 		if(so !=0 && so < 100){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendVolt55
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendVolt55
L__sendVolt133:
;Slave_OA.c,299 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,300 :: 		sendData[7]  = kq[0];
	MOVF       sendVolt_kq_L0+0, 0
	MOVWF      _sendData+7
;Slave_OA.c,301 :: 		sendData[8]  = kq[1];
	MOVF       sendVolt_kq_L0+1, 0
	MOVWF      _sendData+8
;Slave_OA.c,302 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,303 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,304 :: 		}
L_sendVolt55:
;Slave_OA.c,305 :: 		if(so !=0 && so > 100){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendVolt58
	MOVF       FARG_sendVolt_so+0, 0
	MOVWF      R4+0
	MOVF       FARG_sendVolt_so+1, 0
	MOVWF      R4+1
	MOVF       FARG_sendVolt_so+2, 0
	MOVWF      R4+2
	MOVF       FARG_sendVolt_so+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendVolt58
L__sendVolt132:
;Slave_OA.c,306 :: 		sendData[6]  = kq[0];
	MOVF       sendVolt_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,307 :: 		sendData[7]  = kq[1];
	MOVF       sendVolt_kq_L0+1, 0
	MOVWF      _sendData+7
;Slave_OA.c,308 :: 		sendData[8]  = kq[2];
	MOVF       sendVolt_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,309 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,310 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,311 :: 		}
L_sendVolt58:
;Slave_OA.c,312 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendVolt59:
	DECFSZ     R13+0, 1
	GOTO       L_sendVolt59
	DECFSZ     R12+0, 1
	GOTO       L_sendVolt59
	DECFSZ     R11+0, 1
	GOTO       L_sendVolt59
	NOP
	NOP
;Slave_OA.c,313 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,314 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendVolt60:
	DECFSZ     R13+0, 1
	GOTO       L_sendVolt60
	DECFSZ     R12+0, 1
	GOTO       L_sendVolt60
	DECFSZ     R11+0, 1
	GOTO       L_sendVolt60
	NOP
	NOP
;Slave_OA.c,315 :: 		}
L_end_sendVolt:
	RETURN
; end of _sendVolt

_sendAmpe:

;Slave_OA.c,317 :: 		void sendAmpe(float so){
;Slave_OA.c,319 :: 		FloatToStr(so,kq);
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      sendAmpe_kq_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Slave_OA.c,320 :: 		if(so == 0){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendAmpe61
;Slave_OA.c,321 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,322 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,323 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,324 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,325 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,326 :: 		}
L_sendAmpe61:
;Slave_OA.c,327 :: 		if(so !=0 && so < 1 && so > 0.1){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendAmpe64
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendAmpe64
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      R4+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      R4+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      R4+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      R4+3
	MOVLW      205
	MOVWF      R0+0
	MOVLW      204
	MOVWF      R0+1
	MOVLW      76
	MOVWF      R0+2
	MOVLW      123
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendAmpe64
L__sendAmpe134:
;Slave_OA.c,328 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,329 :: 		sendData[7]  = '.';
	MOVLW      46
	MOVWF      _sendData+7
;Slave_OA.c,330 :: 		sendData[8]  = kq[0];
	MOVF       sendAmpe_kq_L0+0, 0
	MOVWF      _sendData+8
;Slave_OA.c,331 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,332 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,333 :: 		}
	GOTO       L_sendAmpe65
L_sendAmpe64:
;Slave_OA.c,334 :: 		else if(so>1){
	MOVF       FARG_sendAmpe_so+0, 0
	MOVWF      R4+0
	MOVF       FARG_sendAmpe_so+1, 0
	MOVWF      R4+1
	MOVF       FARG_sendAmpe_so+2, 0
	MOVWF      R4+2
	MOVF       FARG_sendAmpe_so+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      0
	MOVWF      R0+2
	MOVLW      127
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendAmpe66
;Slave_OA.c,335 :: 		sendData[6]  = kq[0];
	MOVF       sendAmpe_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,336 :: 		sendData[7]  = '.';
	MOVLW      46
	MOVWF      _sendData+7
;Slave_OA.c,337 :: 		sendData[8]  = kq[2];
	MOVF       sendAmpe_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,338 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,339 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,340 :: 		}
L_sendAmpe66:
L_sendAmpe65:
;Slave_OA.c,341 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendAmpe67:
	DECFSZ     R13+0, 1
	GOTO       L_sendAmpe67
	DECFSZ     R12+0, 1
	GOTO       L_sendAmpe67
	DECFSZ     R11+0, 1
	GOTO       L_sendAmpe67
	NOP
	NOP
;Slave_OA.c,342 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,343 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendAmpe68:
	DECFSZ     R13+0, 1
	GOTO       L_sendAmpe68
	DECFSZ     R12+0, 1
	GOTO       L_sendAmpe68
	DECFSZ     R11+0, 1
	GOTO       L_sendAmpe68
	NOP
	NOP
;Slave_OA.c,344 :: 		}
L_end_sendAmpe:
	RETURN
; end of _sendAmpe

_sendPower:

;Slave_OA.c,346 :: 		void sendPower(float so){
;Slave_OA.c,348 :: 		FloatToStr(so,kq);
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      sendPower_kq_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Slave_OA.c,349 :: 		if(so == 0){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower69
;Slave_OA.c,350 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,351 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,352 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,353 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,354 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,355 :: 		}
L_sendPower69:
;Slave_OA.c,356 :: 		if(so !=0 && so < 10){
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R0+3
	CALL       _Equals_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower72
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower72
L__sendPower137:
;Slave_OA.c,357 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,358 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,359 :: 		sendData[8]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+8
;Slave_OA.c,360 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,361 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,362 :: 		}
L_sendPower72:
;Slave_OA.c,363 :: 		if(so < 100 && so > 10){
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower75
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R4+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R4+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R4+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      130
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower75
L__sendPower136:
;Slave_OA.c,364 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,365 :: 		sendData[7]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+7
;Slave_OA.c,366 :: 		sendData[8]  = kq[1];
	MOVF       sendPower_kq_L0+1, 0
	MOVWF      _sendData+8
;Slave_OA.c,367 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,368 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,369 :: 		}
L_sendPower75:
;Slave_OA.c,370 :: 		if(so < 1000 && so > 100){
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R0+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R0+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R0+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower78
	MOVF       FARG_sendPower_so+0, 0
	MOVWF      R4+0
	MOVF       FARG_sendPower_so+1, 0
	MOVWF      R4+1
	MOVF       FARG_sendPower_so+2, 0
	MOVWF      R4+2
	MOVF       FARG_sendPower_so+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_sendPower78
L__sendPower135:
;Slave_OA.c,371 :: 		sendData[6]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,372 :: 		sendData[7]  = kq[1];
	MOVF       sendPower_kq_L0+1, 0
	MOVWF      _sendData+7
;Slave_OA.c,373 :: 		sendData[8]  = kq[2];
	MOVF       sendPower_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,374 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,375 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,376 :: 		}
L_sendPower78:
;Slave_OA.c,377 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendPower79:
	DECFSZ     R13+0, 1
	GOTO       L_sendPower79
	DECFSZ     R12+0, 1
	GOTO       L_sendPower79
	DECFSZ     R11+0, 1
	GOTO       L_sendPower79
	NOP
	NOP
;Slave_OA.c,378 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,379 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendPower80:
	DECFSZ     R13+0, 1
	GOTO       L_sendPower80
	DECFSZ     R12+0, 1
	GOTO       L_sendPower80
	DECFSZ     R11+0, 1
	GOTO       L_sendPower80
	NOP
	NOP
;Slave_OA.c,380 :: 		}
L_end_sendPower:
	RETURN
; end of _sendPower

_getresetInterruptStatus:

;Slave_OA.c,384 :: 		long getresetInterruptStatus(void){
;Slave_OA.c,385 :: 		return Read_ADE7753(RSTSTATUS,2);
	MOVLW      12
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      2
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
;Slave_OA.c,386 :: 		}
L_end_getresetInterruptStatus:
	RETURN
; end of _getresetInterruptStatus

_getInterruptStatus:

;Slave_OA.c,390 :: 		long getInterruptStatus(void){
;Slave_OA.c,391 :: 		return Read_ADE7753(STATUS,2);
	MOVLW      11
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      2
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
;Slave_OA.c,392 :: 		}
L_end_getInterruptStatus:
	RETURN
; end of _getInterruptStatus

_getVRMS:

;Slave_OA.c,396 :: 		float getVRMS (void)
;Slave_OA.c,401 :: 		totalv = 0;
	CLRF       getVRMS_totalv_L0+0
	CLRF       getVRMS_totalv_L0+1
	CLRF       getVRMS_totalv_L0+2
	CLRF       getVRMS_totalv_L0+3
;Slave_OA.c,402 :: 		j = 0;
	CLRF       getVRMS_j_L0+0
	CLRF       getVRMS_j_L0+1
;Slave_OA.c,403 :: 		Write_ADE7753(IRQEN,0x0010,2);
	MOVLW      10
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      16
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,404 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getVRMS81:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS81
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS81
	NOP
	NOP
;Slave_OA.c,405 :: 		for(i=0;i<10;i++)
	CLRF       getVRMS_i_L0+0
	CLRF       getVRMS_i_L0+1
L_getVRMS82:
	MOVLW      128
	XORWF      getVRMS_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS167
	MOVLW      10
	SUBWF      getVRMS_i_L0+0, 0
L__getVRMS167:
	BTFSC      STATUS+0, 0
	GOTO       L_getVRMS83
;Slave_OA.c,407 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,408 :: 		while(! (getInterruptStatus() & ZX)){
L_getVRMS85:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 4
	GOTO       L_getVRMS86
;Slave_OA.c,409 :: 		j++;
	INCF       getVRMS_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getVRMS_j_L0+1, 1
;Slave_OA.c,410 :: 		if(j>100){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getVRMS_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS168
	MOVF       getVRMS_j_L0+0, 0
	SUBLW      100
L__getVRMS168:
	BTFSC      STATUS+0, 0
	GOTO       L_getVRMS87
;Slave_OA.c,411 :: 		j=0;
	CLRF       getVRMS_j_L0+0
	CLRF       getVRMS_j_L0+1
;Slave_OA.c,412 :: 		break;
	GOTO       L_getVRMS86
;Slave_OA.c,413 :: 		}
L_getVRMS87:
;Slave_OA.c,414 :: 		}
	GOTO       L_getVRMS85
L_getVRMS86:
;Slave_OA.c,415 :: 		outputADE=Read_ADE7753(VRMS,3);
	MOVLW      23
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      3
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
	MOVF       R0+0, 0
	MOVWF      _outputADE+0
	MOVF       R0+1, 0
	MOVWF      _outputADE+1
	MOVF       R0+2, 0
	MOVWF      _outputADE+2
	MOVF       R0+3, 0
	MOVWF      _outputADE+3
;Slave_OA.c,416 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getVRMS88:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS88
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS88
	NOP
	NOP
;Slave_OA.c,417 :: 		totalv=totalv+outputADE;
	MOVF       _outputADE+0, 0
	ADDWF      getVRMS_totalv_L0+0, 1
	MOVF       _outputADE+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+1, 0
	ADDWF      getVRMS_totalv_L0+1, 1
	MOVF       _outputADE+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+2, 0
	ADDWF      getVRMS_totalv_L0+2, 1
	MOVF       _outputADE+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+3, 0
	ADDWF      getVRMS_totalv_L0+3, 1
;Slave_OA.c,418 :: 		Delay_ms(25);
	MOVLW      163
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_getVRMS89:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS89
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS89
;Slave_OA.c,405 :: 		for(i=0;i<10;i++)
	INCF       getVRMS_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getVRMS_i_L0+1, 1
;Slave_OA.c,419 :: 		}
	GOTO       L_getVRMS82
L_getVRMS83:
;Slave_OA.c,420 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,421 :: 		vrmsraw = totalv/10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       getVRMS_totalv_L0+0, 0
	MOVWF      R0+0
	MOVF       getVRMS_totalv_L0+1, 0
	MOVWF      R0+1
	MOVF       getVRMS_totalv_L0+2, 0
	MOVWF      R0+2
	MOVF       getVRMS_totalv_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_S+0
;Slave_OA.c,423 :: 		vrmsraw = vrmsraw & 0xFFFFFF;
	MOVLW      255
	ANDWF      R0+0, 1
	MOVLW      255
	ANDWF      R0+1, 1
	MOVLW      255
	ANDWF      R0+2, 1
	MOVLW      0
	ANDWF      R0+3, 1
;Slave_OA.c,425 :: 		vrmsreal = (float)vrmsraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getVRMS_vrmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getVRMS_vrmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getVRMS_vrmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getVRMS_vrmsreal_L0+3
;Slave_OA.c,426 :: 		vrmsreal = vrmsreal * 0.00033834;
	MOVLW      58
	MOVWF      R4+0
	MOVLW      99
	MOVWF      R4+1
	MOVLW      49
	MOVWF      R4+2
	MOVLW      115
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getVRMS_vrmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getVRMS_vrmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getVRMS_vrmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getVRMS_vrmsreal_L0+3
;Slave_OA.c,427 :: 		vrmsreal = vrmsreal- 2626.4;
	MOVLW      102
	MOVWF      R4+0
	MOVLW      38
	MOVWF      R4+1
	MOVLW      36
	MOVWF      R4+2
	MOVLW      138
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getVRMS_vrmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getVRMS_vrmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getVRMS_vrmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getVRMS_vrmsreal_L0+3
;Slave_OA.c,429 :: 		if(vrmsreal > 400 || vrmsreal < 35){
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      135
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS138
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      12
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	MOVF       getVRMS_vrmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getVRMS_vrmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getVRMS_vrmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getVRMS_vrmsreal_L0+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS138
	GOTO       L_getVRMS92
L__getVRMS138:
;Slave_OA.c,430 :: 		vrmsreal = 0;
	CLRF       getVRMS_vrmsreal_L0+0
	CLRF       getVRMS_vrmsreal_L0+1
	CLRF       getVRMS_vrmsreal_L0+2
	CLRF       getVRMS_vrmsreal_L0+3
;Slave_OA.c,431 :: 		}
L_getVRMS92:
;Slave_OA.c,432 :: 		return vrmsreal;
	MOVF       getVRMS_vrmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getVRMS_vrmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getVRMS_vrmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getVRMS_vrmsreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,433 :: 		}
L_end_getVRMS:
	RETURN
; end of _getVRMS

_getIRMS:

;Slave_OA.c,437 :: 		float getIRMS(void)
;Slave_OA.c,442 :: 		totali = 0;
	CLRF       getIRMS_totali_L0+0
	CLRF       getIRMS_totali_L0+1
	CLRF       getIRMS_totali_L0+2
	CLRF       getIRMS_totali_L0+3
;Slave_OA.c,443 :: 		j = 0;
	CLRF       getIRMS_j_L0+0
	CLRF       getIRMS_j_L0+1
;Slave_OA.c,444 :: 		Write_ADE7753(IRQEN,0x0010,2);
	MOVLW      10
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      16
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,445 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getIRMS93:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS93
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS93
	NOP
	NOP
;Slave_OA.c,446 :: 		for(i=0;i<10;i++)
	CLRF       getIRMS_i_L0+0
	CLRF       getIRMS_i_L0+1
L_getIRMS94:
	MOVLW      128
	XORWF      getIRMS_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS170
	MOVLW      10
	SUBWF      getIRMS_i_L0+0, 0
L__getIRMS170:
	BTFSC      STATUS+0, 0
	GOTO       L_getIRMS95
;Slave_OA.c,448 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,449 :: 		while(! (getInterruptStatus() & ZX)){
L_getIRMS97:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 4
	GOTO       L_getIRMS98
;Slave_OA.c,450 :: 		j++;
	INCF       getIRMS_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getIRMS_j_L0+1, 1
;Slave_OA.c,451 :: 		if(j>100){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getIRMS_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS171
	MOVF       getIRMS_j_L0+0, 0
	SUBLW      100
L__getIRMS171:
	BTFSC      STATUS+0, 0
	GOTO       L_getIRMS99
;Slave_OA.c,452 :: 		j=0;
	CLRF       getIRMS_j_L0+0
	CLRF       getIRMS_j_L0+1
;Slave_OA.c,453 :: 		break;
	GOTO       L_getIRMS98
;Slave_OA.c,454 :: 		}
L_getIRMS99:
;Slave_OA.c,455 :: 		}
	GOTO       L_getIRMS97
L_getIRMS98:
;Slave_OA.c,456 :: 		outputADE=Read_ADE7753(IRMS,3);
	MOVLW      22
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      3
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
	MOVF       R0+0, 0
	MOVWF      _outputADE+0
	MOVF       R0+1, 0
	MOVWF      _outputADE+1
	MOVF       R0+2, 0
	MOVWF      _outputADE+2
	MOVF       R0+3, 0
	MOVWF      _outputADE+3
;Slave_OA.c,457 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getIRMS100:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS100
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS100
	NOP
	NOP
;Slave_OA.c,458 :: 		totali=totali+outputADE;
	MOVF       _outputADE+0, 0
	ADDWF      getIRMS_totali_L0+0, 1
	MOVF       _outputADE+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+1, 0
	ADDWF      getIRMS_totali_L0+1, 1
	MOVF       _outputADE+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+2, 0
	ADDWF      getIRMS_totali_L0+2, 1
	MOVF       _outputADE+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _outputADE+3, 0
	ADDWF      getIRMS_totali_L0+3, 1
;Slave_OA.c,459 :: 		Delay_ms(25);
	MOVLW      163
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_getIRMS101:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS101
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS101
;Slave_OA.c,446 :: 		for(i=0;i<10;i++)
	INCF       getIRMS_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getIRMS_i_L0+1, 1
;Slave_OA.c,460 :: 		}
	GOTO       L_getIRMS94
L_getIRMS95:
;Slave_OA.c,461 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,462 :: 		irmsraw = totali/10;
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       getIRMS_totali_L0+0, 0
	MOVWF      R0+0
	MOVF       getIRMS_totali_L0+1, 0
	MOVWF      R0+1
	MOVF       getIRMS_totali_L0+2, 0
	MOVWF      R0+2
	MOVF       getIRMS_totali_L0+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_S+0
;Slave_OA.c,463 :: 		irmsraw = irmsraw & 0xFFFFFF;
	MOVLW      255
	ANDWF      R0+0, 1
	MOVLW      255
	ANDWF      R0+1, 1
	MOVLW      255
	ANDWF      R0+2, 1
	MOVLW      0
	ANDWF      R0+3, 1
;Slave_OA.c,464 :: 		irmsreal = (float)irmsraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getIRMS_irmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getIRMS_irmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getIRMS_irmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getIRMS_irmsreal_L0+3
;Slave_OA.c,465 :: 		irmsreal = irmsreal * 0.00003714;
	MOVLW      197
	MOVWF      R4+0
	MOVLW      198
	MOVWF      R4+1
	MOVLW      27
	MOVWF      R4+2
	MOVLW      112
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getIRMS_irmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getIRMS_irmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getIRMS_irmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getIRMS_irmsreal_L0+3
;Slave_OA.c,466 :: 		irmsreal = irmsreal- 288.1919;
	MOVLW      144
	MOVWF      R4+0
	MOVLW      24
	MOVWF      R4+1
	MOVLW      16
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getIRMS_irmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getIRMS_irmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getIRMS_irmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getIRMS_irmsreal_L0+3
;Slave_OA.c,468 :: 		if(irmsreal > 40 || irmsreal < 0){
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS139
	CLRF       R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       getIRMS_irmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getIRMS_irmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getIRMS_irmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getIRMS_irmsreal_L0+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS139
	GOTO       L_getIRMS104
L__getIRMS139:
;Slave_OA.c,469 :: 		irmsreal = 0;
	CLRF       getIRMS_irmsreal_L0+0
	CLRF       getIRMS_irmsreal_L0+1
	CLRF       getIRMS_irmsreal_L0+2
	CLRF       getIRMS_irmsreal_L0+3
;Slave_OA.c,470 :: 		}
L_getIRMS104:
;Slave_OA.c,471 :: 		return irmsreal;
	MOVF       getIRMS_irmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getIRMS_irmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getIRMS_irmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getIRMS_irmsreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,472 :: 		}
L_end_getIRMS:
	RETURN
; end of _getIRMS

_getAPOWER:

;Slave_OA.c,474 :: 		float getAPOWER(void)
;Slave_OA.c,480 :: 		apreal =0;
	CLRF       getAPOWER_apreal_L0+0
	CLRF       getAPOWER_apreal_L0+1
	CLRF       getAPOWER_apreal_L0+2
	CLRF       getAPOWER_apreal_L0+3
;Slave_OA.c,481 :: 		Write_ADE7753(LINECYC,100,2);
	MOVLW      28
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      100
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,482 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER105:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER105
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER105
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER105
	NOP
;Slave_OA.c,483 :: 		Write_ADE7753(MODE,0x0080,2);
	MOVLW      9
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      128
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,484 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER106:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER106
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER106
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER106
	NOP
;Slave_OA.c,485 :: 		Write_ADE7753(IRQEN,0x0004,2);
	MOVLW      10
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      4
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	CLRF       FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,486 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER107:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER107
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER107
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER107
	NOP
;Slave_OA.c,487 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,488 :: 		while(! (getInterruptStatus() & CYCEND)){
L_getAPOWER108:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 2
	GOTO       L_getAPOWER109
;Slave_OA.c,489 :: 		j++;
	INCF       getAPOWER_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getAPOWER_j_L0+1, 1
;Slave_OA.c,490 :: 		if(j>200){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getAPOWER_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER173
	MOVF       getAPOWER_j_L0+0, 0
	SUBLW      200
L__getAPOWER173:
	BTFSC      STATUS+0, 0
	GOTO       L_getAPOWER110
;Slave_OA.c,491 :: 		j=0;
	CLRF       getAPOWER_j_L0+0
	CLRF       getAPOWER_j_L0+1
;Slave_OA.c,492 :: 		break;
	GOTO       L_getAPOWER109
;Slave_OA.c,493 :: 		}
L_getAPOWER110:
;Slave_OA.c,494 :: 		}
	GOTO       L_getAPOWER108
L_getAPOWER109:
;Slave_OA.c,496 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,497 :: 		while(! (getInterruptStatus() & CYCEND)){
L_getAPOWER111:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 2
	GOTO       L_getAPOWER112
;Slave_OA.c,498 :: 		j++;
	INCF       getAPOWER_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getAPOWER_j_L0+1, 1
;Slave_OA.c,499 :: 		if(j>200){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getAPOWER_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER174
	MOVF       getAPOWER_j_L0+0, 0
	SUBLW      200
L__getAPOWER174:
	BTFSC      STATUS+0, 0
	GOTO       L_getAPOWER113
;Slave_OA.c,500 :: 		j=0;
	CLRF       getAPOWER_j_L0+0
	CLRF       getAPOWER_j_L0+1
;Slave_OA.c,501 :: 		break;
	GOTO       L_getAPOWER112
;Slave_OA.c,502 :: 		}
L_getAPOWER113:
;Slave_OA.c,503 :: 		}
	GOTO       L_getAPOWER111
L_getAPOWER112:
;Slave_OA.c,504 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,505 :: 		outputADE=Read_ADE7753(LAENERGY,3);
	MOVLW      4
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      3
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
	MOVF       R0+0, 0
	MOVWF      _outputADE+0
	MOVF       R0+1, 0
	MOVWF      _outputADE+1
	MOVF       R0+2, 0
	MOVWF      _outputADE+2
	MOVF       R0+3, 0
	MOVWF      _outputADE+3
;Slave_OA.c,506 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER114:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER114
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER114
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER114
	NOP
;Slave_OA.c,508 :: 		apraw = apraw & 0xFFFF;
	MOVLW      255
	ANDWF      _outputADE+0, 0
	MOVWF      R0+0
	MOVLW      255
	ANDWF      _outputADE+1, 0
	MOVWF      R0+1
	MOVF       _outputADE+2, 0
	MOVWF      R0+2
	MOVF       _outputADE+3, 0
	MOVWF      R0+3
	MOVLW      0
	ANDWF      R0+2, 1
	ANDWF      R0+3, 1
;Slave_OA.c,510 :: 		apreal = (float)apraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getAPOWER_apreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getAPOWER_apreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getAPOWER_apreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getAPOWER_apreal_L0+3
;Slave_OA.c,511 :: 		apreal = apreal * 1.6425;
	MOVLW      113
	MOVWF      R4+0
	MOVLW      61
	MOVWF      R4+1
	MOVLW      82
	MOVWF      R4+2
	MOVLW      127
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getAPOWER_apreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getAPOWER_apreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getAPOWER_apreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getAPOWER_apreal_L0+3
;Slave_OA.c,512 :: 		apreal = apreal + 0.14;
	MOVLW      41
	MOVWF      R4+0
	MOVLW      92
	MOVWF      R4+1
	MOVLW      15
	MOVWF      R4+2
	MOVLW      124
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      getAPOWER_apreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getAPOWER_apreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getAPOWER_apreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getAPOWER_apreal_L0+3
;Slave_OA.c,513 :: 		Write_ADE7753(LINECYC,0xFFFF,2);
	MOVLW      28
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      255
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	MOVLW      255
	MOVWF      FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,514 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER115:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER115
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER115
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER115
	NOP
;Slave_OA.c,515 :: 		if(apreal < 8 || apreal > 2000){
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	MOVF       getAPOWER_apreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getAPOWER_apreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getAPOWER_apreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getAPOWER_apreal_L0+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER140
	MOVF       getAPOWER_apreal_L0+0, 0
	MOVWF      R4+0
	MOVF       getAPOWER_apreal_L0+1, 0
	MOVWF      R4+1
	MOVF       getAPOWER_apreal_L0+2, 0
	MOVWF      R4+2
	MOVF       getAPOWER_apreal_L0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      122
	MOVWF      R0+2
	MOVLW      137
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER140
	GOTO       L_getAPOWER118
L__getAPOWER140:
;Slave_OA.c,516 :: 		apreal = 0;
	CLRF       getAPOWER_apreal_L0+0
	CLRF       getAPOWER_apreal_L0+1
	CLRF       getAPOWER_apreal_L0+2
	CLRF       getAPOWER_apreal_L0+3
;Slave_OA.c,517 :: 		}
L_getAPOWER118:
;Slave_OA.c,518 :: 		return apreal;
	MOVF       getAPOWER_apreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getAPOWER_apreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getAPOWER_apreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getAPOWER_apreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,519 :: 		}
L_end_getAPOWER:
	RETURN
; end of _getAPOWER

_Test:

;Slave_OA.c,524 :: 		void Test (void)
;Slave_OA.c,526 :: 		Write_ADE7753(LINECYC,0xABEF,2);
	MOVLW      28
	MOVWF      FARG_Write_ADE7753_add+0
	MOVLW      239
	MOVWF      FARG_Write_ADE7753_write_buffer+0
	MOVLW      171
	MOVWF      FARG_Write_ADE7753_write_buffer+1
	CLRF       FARG_Write_ADE7753_write_buffer+2
	CLRF       FARG_Write_ADE7753_write_buffer+3
	MOVLW      2
	MOVWF      FARG_Write_ADE7753_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_Write_ADE7753_bytes_to_write+1
	CALL       _Write_ADE7753+0
;Slave_OA.c,527 :: 		outputADE = Read_ADE7753(LINECYC,2);
	MOVLW      28
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      2
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
	MOVF       R0+0, 0
	MOVWF      _outputADE+0
	MOVF       R0+1, 0
	MOVWF      _outputADE+1
	MOVF       R0+2, 0
	MOVWF      _outputADE+2
	MOVF       R0+3, 0
	MOVWF      _outputADE+3
;Slave_OA.c,528 :: 		HienthiUART(outputADE,2);
	MOVF       R0+0, 0
	MOVWF      FARG_HienthiUART_outputADE+0
	MOVF       R0+1, 0
	MOVWF      FARG_HienthiUART_outputADE+1
	MOVF       R0+2, 0
	MOVWF      FARG_HienthiUART_outputADE+2
	MOVF       R0+3, 0
	MOVWF      FARG_HienthiUART_outputADE+3
	MOVLW      2
	MOVWF      FARG_HienthiUART_bytes_to_write+0
	MOVLW      0
	MOVWF      FARG_HienthiUART_bytes_to_write+1
	CALL       _HienthiUART+0
;Slave_OA.c,529 :: 		}
L_end_Test:
	RETURN
; end of _Test

_RS485_send:

;Slave_OA.c,534 :: 		void RS485_send (char dat[])
;Slave_OA.c,537 :: 		PORTD.RD4 =1;
	BSF        PORTD+0, 4
;Slave_OA.c,538 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_RS485_send119:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send119
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send119
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send119
	NOP
	NOP
;Slave_OA.c,539 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send120:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send177
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send177:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send121
;Slave_OA.c,540 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send123:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send124
	GOTO       L_RS485_send123
L_RS485_send124:
;Slave_OA.c,541 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_OA.c,542 :: 		Delay_ms(30);
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L_RS485_send125:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send125
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send125
;Slave_OA.c,539 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_OA.c,543 :: 		}
	GOTO       L_RS485_send120
L_RS485_send121:
;Slave_OA.c,544 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_RS485_send126:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send126
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send126
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send126
	NOP
	NOP
;Slave_OA.c,545 :: 		PORTD.RD4 =0;
	BCF        PORTD+0, 4
;Slave_OA.c,546 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_Config_sendData:

;Slave_OA.c,550 :: 		void Config_sendData(void){
;Slave_OA.c,551 :: 		sendData[0]  = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_OA.c,552 :: 		sendData[1]  = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_OA.c,553 :: 		sendData[2]  = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_OA.c,554 :: 		sendData[3]  = 'D';
	MOVLW      68
	MOVWF      _sendData+3
;Slave_OA.c,555 :: 		sendData[4]  = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_OA.c,556 :: 		sendData[5]  = '4';
	MOVLW      52
	MOVWF      _sendData+5
;Slave_OA.c,557 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,558 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,559 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,560 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,561 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,562 :: 		}
L_end_Config_sendData:
	RETURN
; end of _Config_sendData

_turnOnRelay:

;Slave_OA.c,567 :: 		void turnOnRelay(void){
;Slave_OA.c,568 :: 		PORTD.RD5 =1;
	BSF        PORTD+0, 5
;Slave_OA.c,569 :: 		}
L_end_turnOnRelay:
	RETURN
; end of _turnOnRelay

_turnOffRelay:

;Slave_OA.c,574 :: 		void turnOffRelay(void){
;Slave_OA.c,575 :: 		PORTD.RD5 =0;
	BCF        PORTD+0, 5
;Slave_OA.c,576 :: 		}
L_end_turnOffRelay:
	RETURN
; end of _turnOffRelay
