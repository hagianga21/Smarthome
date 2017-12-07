
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_OA.c,81 :: 		void interrupt()
;Slave_OA.c,83 :: 		if(INTCON.INTF == 1){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;Slave_OA.c,84 :: 		buttonPush = 1;
	MOVLW      1
	MOVWF      _buttonPush+0
	MOVLW      0
	MOVWF      _buttonPush+1
;Slave_OA.c,85 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;Slave_OA.c,86 :: 		}
L_interrupt0:
;Slave_OA.c,88 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt1
;Slave_OA.c,90 :: 		while(uart1_data_ready()==0);
L_interrupt2:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
	GOTO       L_interrupt2
L_interrupt3:
;Slave_OA.c,91 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_OA.c,93 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_OA.c,94 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
;Slave_OA.c,96 :: 		count=0;
	CLRF       _count+0
;Slave_OA.c,97 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,98 :: 		count++;
	INCF       _count+0, 1
;Slave_OA.c,99 :: 		}
L_interrupt5:
;Slave_OA.c,100 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt8
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt8
L__interrupt115:
;Slave_OA.c,102 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,103 :: 		count++;
	INCF       _count+0, 1
;Slave_OA.c,104 :: 		}
L_interrupt8:
;Slave_OA.c,105 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;Slave_OA.c,107 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_OA.c,108 :: 		count=0;
	CLRF       _count+0
;Slave_OA.c,109 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_OA.c,110 :: 		}
L_interrupt9:
;Slave_OA.c,111 :: 		}
L_interrupt4:
;Slave_OA.c,112 :: 		}
L_interrupt1:
;Slave_OA.c,113 :: 		}
L_end_interrupt:
L__interrupt127:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_OA.c,118 :: 		void main()
;Slave_OA.c,120 :: 		ANSEL  = 0;
	CLRF       ANSEL+0
;Slave_OA.c,121 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;Slave_OA.c,122 :: 		C1ON_bit = 0;
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;Slave_OA.c,123 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;Slave_OA.c,124 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,126 :: 		TRISB.B0 = 1;
	BSF        TRISB+0, 0
;Slave_OA.c,127 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_OA.c,129 :: 		TRISD.B4 = 0;
	BCF        TRISD+0, 4
;Slave_OA.c,131 :: 		TRISD.B5 = 0;
	BCF        TRISD+0, 5
;Slave_OA.c,132 :: 		turnOffRelay();
	CALL       _turnOffRelay+0
;Slave_OA.c,133 :: 		Config_sendData();
	CALL       _Config_sendData+0
;Slave_OA.c,137 :: 		activepower = 0;
	CLRF       _activepower+0
	CLRF       _activepower+1
	CLRF       _activepower+2
	CLRF       _activepower+3
;Slave_OA.c,139 :: 		TRISC.B0 = 0;
	BCF        TRISC+0, 0
;Slave_OA.c,140 :: 		PORTC.B0 = 1;
	BSF        PORTC+0, 0
;Slave_OA.c,141 :: 		OPTION_REG.INTEDG = 1;
	BSF        OPTION_REG+0, 6
;Slave_OA.c,142 :: 		INTCON.INTE = 1;
	BSF        INTCON+0, 4
;Slave_OA.c,143 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Slave_OA.c,145 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_OA.c,146 :: 		RCIE_bit = 1;
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_OA.c,147 :: 		TXIE_bit = 0;
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_OA.c,148 :: 		PEIE_bit = 1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_OA.c,149 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_OA.c,150 :: 		Delay_ms(200);
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
;Slave_OA.c,151 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_HIGH_2_LOW);
	MOVLW      2
	MOVWF      FARG_SPI1_Init_Advanced_master+0
	CLRF       FARG_SPI1_Init_Advanced_data_sample+0
	CLRF       FARG_SPI1_Init_Advanced_clock_idle+0
	CLRF       FARG_SPI1_Init_Advanced_transmit_edge+0
	CALL       _SPI1_Init_Advanced+0
;Slave_OA.c,152 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
	DECFSZ     R11+0, 1
	GOTO       L_main11
	NOP
	NOP
;Slave_OA.c,153 :: 		Write_ADE7753(GAIN,0x0,1);
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
;Slave_OA.c,154 :: 		Write_ADE7753(MODE,0x008C,2);                      //0b0000000010001100
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
;Slave_OA.c,158 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
;Slave_OA.c,160 :: 		while(1){
L_main13:
;Slave_OA.c,163 :: 		activepower = getAPOWER();
	CALL       _getAPOWER+0
	MOVF       R0+0, 0
	MOVWF      _activepower+0
	MOVF       R0+1, 0
	MOVWF      _activepower+1
	MOVF       R0+2, 0
	MOVWF      _activepower+2
	MOVF       R0+3, 0
	MOVWF      _activepower+3
;Slave_OA.c,164 :: 		if(flagReceivedAllData == 1){
	MOVF       _flagReceivedAllData+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;Slave_OA.c,165 :: 		flagReceivedAllData = 0;
	CLRF       _flagReceivedAllData+0
;Slave_OA.c,166 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	NOP
	NOP
;Slave_OA.c,183 :: 		if(receiveData[1] == '1' && receiveData[2] == '3' && receiveData[3] == 'D'
	MOVF       _receiveData+1, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+2, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+3, 0
	XORLW      68
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;Slave_OA.c,184 :: 		&& receiveData[4] == '0' && receiveData[5] == '4' && receiveData[6] == '0'
	MOVF       _receiveData+4, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+5, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+6, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;Slave_OA.c,185 :: 		&& receiveData[7] == '0' && receiveData[8] == '0' && receiveData[9] == 'P'){
	MOVF       _receiveData+7, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+8, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L_main19
	MOVF       _receiveData+9, 0
	XORLW      80
	BTFSS      STATUS+0, 2
	GOTO       L_main19
L__main116:
;Slave_OA.c,186 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	DECFSZ     R11+0, 1
	GOTO       L_main20
	NOP
;Slave_OA.c,188 :: 		sendPower(activepower);
	MOVF       _activepower+0, 0
	MOVWF      FARG_sendPower_so+0
	MOVF       _activepower+1, 0
	MOVWF      FARG_sendPower_so+1
	MOVF       _activepower+2, 0
	MOVWF      FARG_sendPower_so+2
	MOVF       _activepower+3, 0
	MOVWF      FARG_sendPower_so+3
	CALL       _sendPower+0
;Slave_OA.c,189 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
;Slave_OA.c,190 :: 		}
L_main19:
;Slave_OA.c,192 :: 		}
L_main15:
;Slave_OA.c,194 :: 		if(buttonPush == 1){
	MOVLW      0
	XORWF      _buttonPush+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVLW      1
	XORWF      _buttonPush+0, 0
L__main129:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;Slave_OA.c,195 :: 		buttonPush = 0;
	CLRF       _buttonPush+0
	CLRF       _buttonPush+1
;Slave_OA.c,196 :: 		if(relayStatus == 0){
	MOVLW      0
	XORWF      _relayStatus+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVLW      0
	XORWF      _relayStatus+0, 0
L__main130:
	BTFSS      STATUS+0, 2
	GOTO       L_main23
;Slave_OA.c,197 :: 		turnOnRelay();
	CALL       _turnOnRelay+0
;Slave_OA.c,198 :: 		relayStatus++;
	INCF       _relayStatus+0, 1
	BTFSC      STATUS+0, 2
	INCF       _relayStatus+1, 1
;Slave_OA.c,199 :: 		}
	GOTO       L_main24
L_main23:
;Slave_OA.c,201 :: 		turnOffRelay();
	CALL       _turnOffRelay+0
;Slave_OA.c,202 :: 		relayStatus = 0;
	CLRF       _relayStatus+0
	CLRF       _relayStatus+1
;Slave_OA.c,203 :: 		}
L_main24:
;Slave_OA.c,204 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
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
;Slave_OA.c,205 :: 		}
L_main22:
;Slave_OA.c,244 :: 		}
	GOTO       L_main13
;Slave_OA.c,245 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Write_ADE7753:

;Slave_OA.c,250 :: 		void Write_ADE7753(char add, long write_buffer, int bytes_to_write)
;Slave_OA.c,256 :: 		add = add|cmd;
	MOVLW      128
	IORWF      FARG_Write_ADE7753_add+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_Write_ADE7753_add+0
;Slave_OA.c,257 :: 		CS = 0;
	BCF        PORTC+0, 0
;Slave_OA.c,258 :: 		SPI1_Write(add);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,259 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Write_ADE775326:
	DECFSZ     R13+0, 1
	GOTO       L_Write_ADE775326
	DECFSZ     R12+0, 1
	GOTO       L_Write_ADE775326
	NOP
	NOP
;Slave_OA.c,261 :: 		for (i = 0; i < bytes_to_write; i++)
	CLRF       Write_ADE7753_i_L0+0
	CLRF       Write_ADE7753_i_L0+1
L_Write_ADE775327:
	MOVLW      128
	XORWF      Write_ADE7753_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_Write_ADE7753_bytes_to_write+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Write_ADE7753132
	MOVF       FARG_Write_ADE7753_bytes_to_write+0, 0
	SUBWF      Write_ADE7753_i_L0+0, 0
L__Write_ADE7753132:
	BTFSC      STATUS+0, 0
	GOTO       L_Write_ADE775328
;Slave_OA.c,263 :: 		this_write = (char) (write_buffer>> (8*((bytes_to_write-1)-i)));
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
L__Write_ADE7753133:
	BTFSC      STATUS+0, 2
	GOTO       L__Write_ADE7753134
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__Write_ADE7753133
L__Write_ADE7753134:
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
L__Write_ADE7753135:
	BTFSC      STATUS+0, 2
	GOTO       L__Write_ADE7753136
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	BTFSC      R0+3, 6
	BSF        R0+3, 7
	ADDLW      255
	GOTO       L__Write_ADE7753135
L__Write_ADE7753136:
;Slave_OA.c,264 :: 		SPI1_Write(this_write);
	MOVF       R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,265 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Write_ADE775330:
	DECFSZ     R13+0, 1
	GOTO       L_Write_ADE775330
	DECFSZ     R12+0, 1
	GOTO       L_Write_ADE775330
	NOP
	NOP
;Slave_OA.c,261 :: 		for (i = 0; i < bytes_to_write; i++)
	INCF       Write_ADE7753_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Write_ADE7753_i_L0+1, 1
;Slave_OA.c,266 :: 		}
	GOTO       L_Write_ADE775327
L_Write_ADE775328:
;Slave_OA.c,267 :: 		CS=1;
	BSF        PORTC+0, 0
;Slave_OA.c,268 :: 		}
L_end_Write_ADE7753:
	RETURN
; end of _Write_ADE7753

_Read_ADE7753:

;Slave_OA.c,272 :: 		long Read_ADE7753(char add, char bytes_to_read)
;Slave_OA.c,277 :: 		CS = 0;
	BCF        PORTC+0, 0
;Slave_OA.c,278 :: 		SPI1_Write(add);
	MOVF       FARG_Read_ADE7753_add+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;Slave_OA.c,279 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Read_ADE775331:
	DECFSZ     R13+0, 1
	GOTO       L_Read_ADE775331
	DECFSZ     R12+0, 1
	GOTO       L_Read_ADE775331
	NOP
	NOP
;Slave_OA.c,280 :: 		for (i = 1; i <= bytes_to_read; i++)
	MOVLW      1
	MOVWF      Read_ADE7753_i_L0+0
	MOVLW      0
	MOVWF      Read_ADE7753_i_L0+1
L_Read_ADE775332:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      Read_ADE7753_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Read_ADE7753138
	MOVF       Read_ADE7753_i_L0+0, 0
	SUBWF      FARG_Read_ADE7753_bytes_to_read+0, 0
L__Read_ADE7753138:
	BTFSS      STATUS+0, 0
	GOTO       L_Read_ADE775333
;Slave_OA.c,282 :: 		reader_buf =  SPI1_Read(0x00);
	CLRF       FARG_SPI1_Read_buffer+0
	CALL       _SPI1_Read+0
	MOVF       R0+0, 0
	MOVWF      Read_ADE7753_reader_buf_L0+0
;Slave_OA.c,283 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Read_ADE775335:
	DECFSZ     R13+0, 1
	GOTO       L_Read_ADE775335
	DECFSZ     R12+0, 1
	GOTO       L_Read_ADE775335
	NOP
	NOP
;Slave_OA.c,284 :: 		result = result | reader_buf;
	MOVF       Read_ADE7753_reader_buf_L0+0, 0
	IORWF      Read_ADE7753_result_L0+0, 1
	MOVLW      0
	IORWF      Read_ADE7753_result_L0+1, 1
	IORWF      Read_ADE7753_result_L0+2, 1
	IORWF      Read_ADE7753_result_L0+3, 1
;Slave_OA.c,285 :: 		if(i < bytes_to_read)
	MOVLW      128
	XORWF      Read_ADE7753_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Read_ADE7753139
	MOVF       FARG_Read_ADE7753_bytes_to_read+0, 0
	SUBWF      Read_ADE7753_i_L0+0, 0
L__Read_ADE7753139:
	BTFSC      STATUS+0, 0
	GOTO       L_Read_ADE775336
;Slave_OA.c,286 :: 		result = result << 8;
	MOVF       Read_ADE7753_result_L0+2, 0
	MOVWF      Read_ADE7753_result_L0+3
	MOVF       Read_ADE7753_result_L0+1, 0
	MOVWF      Read_ADE7753_result_L0+2
	MOVF       Read_ADE7753_result_L0+0, 0
	MOVWF      Read_ADE7753_result_L0+1
	CLRF       Read_ADE7753_result_L0+0
L_Read_ADE775336:
;Slave_OA.c,280 :: 		for (i = 1; i <= bytes_to_read; i++)
	INCF       Read_ADE7753_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       Read_ADE7753_i_L0+1, 1
;Slave_OA.c,287 :: 		}
	GOTO       L_Read_ADE775332
L_Read_ADE775333:
;Slave_OA.c,288 :: 		CS = 1;
	BSF        PORTC+0, 0
;Slave_OA.c,289 :: 		return result;
	MOVF       Read_ADE7753_result_L0+0, 0
	MOVWF      R0+0
	MOVF       Read_ADE7753_result_L0+1, 0
	MOVWF      R0+1
	MOVF       Read_ADE7753_result_L0+2, 0
	MOVWF      R0+2
	MOVF       Read_ADE7753_result_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,290 :: 		}
L_end_Read_ADE7753:
	RETURN
; end of _Read_ADE7753

_HienthiUART:

;Slave_OA.c,294 :: 		void HienthiUART (long outputADE, int bytes_to_write)
;Slave_OA.c,298 :: 		for (i = 0; i < bytes_to_write; i++)
	CLRF       HienthiUART_i_L0+0
	CLRF       HienthiUART_i_L0+1
L_HienthiUART37:
	MOVLW      128
	XORWF      HienthiUART_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_HienthiUART_bytes_to_write+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__HienthiUART141
	MOVF       FARG_HienthiUART_bytes_to_write+0, 0
	SUBWF      HienthiUART_i_L0+0, 0
L__HienthiUART141:
	BTFSC      STATUS+0, 0
	GOTO       L_HienthiUART38
;Slave_OA.c,300 :: 		this_write = (char) (outputADE>> (8*((bytes_to_write-1)-i)));
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
L__HienthiUART142:
	BTFSC      STATUS+0, 2
	GOTO       L__HienthiUART143
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__HienthiUART142
L__HienthiUART143:
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
L__HienthiUART144:
	BTFSC      STATUS+0, 2
	GOTO       L__HienthiUART145
	RRF        R0+3, 1
	RRF        R0+2, 1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+3, 7
	BTFSC      R0+3, 6
	BSF        R0+3, 7
	ADDLW      255
	GOTO       L__HienthiUART144
L__HienthiUART145:
;Slave_OA.c,301 :: 		UART1_Write(this_write);
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_OA.c,298 :: 		for (i = 0; i < bytes_to_write; i++)
	INCF       HienthiUART_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       HienthiUART_i_L0+1, 1
;Slave_OA.c,302 :: 		}
	GOTO       L_HienthiUART37
L_HienthiUART38:
;Slave_OA.c,303 :: 		}
L_end_HienthiUART:
	RETURN
; end of _HienthiUART

_Hienthisofloat:

;Slave_OA.c,307 :: 		void Hienthisofloat (float so){
;Slave_OA.c,310 :: 		FloatToStr(so,kq);
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
;Slave_OA.c,311 :: 		UART1_Write_Text(kq);
	MOVLW      Hienthisofloat_kq_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Slave_OA.c,312 :: 		}
L_end_Hienthisofloat:
	RETURN
; end of _Hienthisofloat

_sendVolt:

;Slave_OA.c,314 :: 		void sendVolt(float so){
;Slave_OA.c,316 :: 		FloatToStr(so,kq);
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
;Slave_OA.c,317 :: 		if(so == 0){
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
	GOTO       L_sendVolt40
;Slave_OA.c,318 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,319 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,320 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,321 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,322 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,323 :: 		}
L_sendVolt40:
;Slave_OA.c,324 :: 		if(so !=0 && so < 100){
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
	GOTO       L_sendVolt43
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
	GOTO       L_sendVolt43
L__sendVolt118:
;Slave_OA.c,325 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,326 :: 		sendData[7]  = kq[0];
	MOVF       sendVolt_kq_L0+0, 0
	MOVWF      _sendData+7
;Slave_OA.c,327 :: 		sendData[8]  = kq[1];
	MOVF       sendVolt_kq_L0+1, 0
	MOVWF      _sendData+8
;Slave_OA.c,328 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,329 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,330 :: 		}
L_sendVolt43:
;Slave_OA.c,331 :: 		if(so !=0 && so > 100){
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
	GOTO       L_sendVolt46
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
	GOTO       L_sendVolt46
L__sendVolt117:
;Slave_OA.c,332 :: 		sendData[6]  = kq[0];
	MOVF       sendVolt_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,333 :: 		sendData[7]  = kq[1];
	MOVF       sendVolt_kq_L0+1, 0
	MOVWF      _sendData+7
;Slave_OA.c,334 :: 		sendData[8]  = kq[2];
	MOVF       sendVolt_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,335 :: 		sendData[9]  = 'V';
	MOVLW      86
	MOVWF      _sendData+9
;Slave_OA.c,336 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,337 :: 		}
L_sendVolt46:
;Slave_OA.c,338 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendVolt47:
	DECFSZ     R13+0, 1
	GOTO       L_sendVolt47
	DECFSZ     R12+0, 1
	GOTO       L_sendVolt47
	DECFSZ     R11+0, 1
	GOTO       L_sendVolt47
	NOP
	NOP
;Slave_OA.c,339 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,340 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendVolt48:
	DECFSZ     R13+0, 1
	GOTO       L_sendVolt48
	DECFSZ     R12+0, 1
	GOTO       L_sendVolt48
	DECFSZ     R11+0, 1
	GOTO       L_sendVolt48
	NOP
	NOP
;Slave_OA.c,341 :: 		}
L_end_sendVolt:
	RETURN
; end of _sendVolt

_sendAmpe:

;Slave_OA.c,343 :: 		void sendAmpe(float so){
;Slave_OA.c,345 :: 		FloatToStr(so,kq);
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
;Slave_OA.c,346 :: 		if(so == 0){
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
	GOTO       L_sendAmpe49
;Slave_OA.c,347 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,348 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,349 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,350 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,351 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,352 :: 		}
L_sendAmpe49:
;Slave_OA.c,353 :: 		if(so !=0 && so < 1 && so > 0.1){
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
	GOTO       L_sendAmpe52
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
	GOTO       L_sendAmpe52
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
	GOTO       L_sendAmpe52
L__sendAmpe119:
;Slave_OA.c,354 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,355 :: 		sendData[7]  = '.';
	MOVLW      46
	MOVWF      _sendData+7
;Slave_OA.c,356 :: 		sendData[8]  = kq[0];
	MOVF       sendAmpe_kq_L0+0, 0
	MOVWF      _sendData+8
;Slave_OA.c,357 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,358 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,359 :: 		}
	GOTO       L_sendAmpe53
L_sendAmpe52:
;Slave_OA.c,360 :: 		else if(so>1){
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
	GOTO       L_sendAmpe54
;Slave_OA.c,361 :: 		sendData[6]  = kq[0];
	MOVF       sendAmpe_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,362 :: 		sendData[7]  = '.';
	MOVLW      46
	MOVWF      _sendData+7
;Slave_OA.c,363 :: 		sendData[8]  = kq[2];
	MOVF       sendAmpe_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,364 :: 		sendData[9]  = 'I';
	MOVLW      73
	MOVWF      _sendData+9
;Slave_OA.c,365 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,366 :: 		}
L_sendAmpe54:
L_sendAmpe53:
;Slave_OA.c,367 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendAmpe55:
	DECFSZ     R13+0, 1
	GOTO       L_sendAmpe55
	DECFSZ     R12+0, 1
	GOTO       L_sendAmpe55
	DECFSZ     R11+0, 1
	GOTO       L_sendAmpe55
	NOP
	NOP
;Slave_OA.c,368 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,369 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendAmpe56:
	DECFSZ     R13+0, 1
	GOTO       L_sendAmpe56
	DECFSZ     R12+0, 1
	GOTO       L_sendAmpe56
	DECFSZ     R11+0, 1
	GOTO       L_sendAmpe56
	NOP
	NOP
;Slave_OA.c,370 :: 		}
L_end_sendAmpe:
	RETURN
; end of _sendAmpe

_sendPower:

;Slave_OA.c,372 :: 		void sendPower(float so){
;Slave_OA.c,374 :: 		FloatToStr(so,kq);
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
;Slave_OA.c,375 :: 		if(so == 0){
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
	GOTO       L_sendPower57
;Slave_OA.c,376 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,377 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,378 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,379 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,380 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,381 :: 		}
L_sendPower57:
;Slave_OA.c,382 :: 		if(so !=0 && so < 10){
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
	GOTO       L_sendPower60
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
	GOTO       L_sendPower60
L__sendPower122:
;Slave_OA.c,383 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,384 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,385 :: 		sendData[8]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+8
;Slave_OA.c,386 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,387 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,388 :: 		}
L_sendPower60:
;Slave_OA.c,389 :: 		if(so < 100 && so > 10){
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
	GOTO       L_sendPower63
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
	GOTO       L_sendPower63
L__sendPower121:
;Slave_OA.c,390 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,391 :: 		sendData[7]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+7
;Slave_OA.c,392 :: 		sendData[8]  = kq[1];
	MOVF       sendPower_kq_L0+1, 0
	MOVWF      _sendData+8
;Slave_OA.c,393 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,394 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,395 :: 		}
L_sendPower63:
;Slave_OA.c,396 :: 		if(so < 1000 && so > 100){
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
	GOTO       L_sendPower66
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
	GOTO       L_sendPower66
L__sendPower120:
;Slave_OA.c,397 :: 		sendData[6]  = kq[0];
	MOVF       sendPower_kq_L0+0, 0
	MOVWF      _sendData+6
;Slave_OA.c,398 :: 		sendData[7]  = kq[1];
	MOVF       sendPower_kq_L0+1, 0
	MOVWF      _sendData+7
;Slave_OA.c,399 :: 		sendData[8]  = kq[2];
	MOVF       sendPower_kq_L0+2, 0
	MOVWF      _sendData+8
;Slave_OA.c,400 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,401 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,402 :: 		}
L_sendPower66:
;Slave_OA.c,403 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_sendPower67:
	DECFSZ     R13+0, 1
	GOTO       L_sendPower67
	DECFSZ     R12+0, 1
	GOTO       L_sendPower67
	DECFSZ     R11+0, 1
	GOTO       L_sendPower67
	NOP
	NOP
;Slave_OA.c,404 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_OA.c,405 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_sendPower68:
	DECFSZ     R13+0, 1
	GOTO       L_sendPower68
	DECFSZ     R12+0, 1
	GOTO       L_sendPower68
	DECFSZ     R11+0, 1
	GOTO       L_sendPower68
	NOP
	NOP
;Slave_OA.c,406 :: 		}
L_end_sendPower:
	RETURN
; end of _sendPower

_getresetInterruptStatus:

;Slave_OA.c,410 :: 		long getresetInterruptStatus(void){
;Slave_OA.c,411 :: 		return Read_ADE7753(RSTSTATUS,2);
	MOVLW      12
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      2
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
;Slave_OA.c,412 :: 		}
L_end_getresetInterruptStatus:
	RETURN
; end of _getresetInterruptStatus

_getInterruptStatus:

;Slave_OA.c,416 :: 		long getInterruptStatus(void){
;Slave_OA.c,417 :: 		return Read_ADE7753(STATUS,2);
	MOVLW      11
	MOVWF      FARG_Read_ADE7753_add+0
	MOVLW      2
	MOVWF      FARG_Read_ADE7753_bytes_to_read+0
	CALL       _Read_ADE7753+0
;Slave_OA.c,418 :: 		}
L_end_getInterruptStatus:
	RETURN
; end of _getInterruptStatus

_getVRMS:

;Slave_OA.c,422 :: 		float getVRMS (void)
;Slave_OA.c,427 :: 		totalv = 0;
	CLRF       getVRMS_totalv_L0+0
	CLRF       getVRMS_totalv_L0+1
	CLRF       getVRMS_totalv_L0+2
	CLRF       getVRMS_totalv_L0+3
;Slave_OA.c,428 :: 		j = 0;
	CLRF       getVRMS_j_L0+0
	CLRF       getVRMS_j_L0+1
;Slave_OA.c,429 :: 		Write_ADE7753(IRQEN,0x0010,2);
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
;Slave_OA.c,430 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getVRMS69:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS69
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS69
	NOP
	NOP
;Slave_OA.c,431 :: 		for(i=0;i<10;i++)
	CLRF       getVRMS_i_L0+0
	CLRF       getVRMS_i_L0+1
L_getVRMS70:
	MOVLW      128
	XORWF      getVRMS_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS153
	MOVLW      10
	SUBWF      getVRMS_i_L0+0, 0
L__getVRMS153:
	BTFSC      STATUS+0, 0
	GOTO       L_getVRMS71
;Slave_OA.c,433 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,434 :: 		while(! (getInterruptStatus() & ZX)){
L_getVRMS73:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 4
	GOTO       L_getVRMS74
;Slave_OA.c,435 :: 		j++;
	INCF       getVRMS_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getVRMS_j_L0+1, 1
;Slave_OA.c,436 :: 		if(j>100){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getVRMS_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getVRMS154
	MOVF       getVRMS_j_L0+0, 0
	SUBLW      100
L__getVRMS154:
	BTFSC      STATUS+0, 0
	GOTO       L_getVRMS75
;Slave_OA.c,437 :: 		j=0;
	CLRF       getVRMS_j_L0+0
	CLRF       getVRMS_j_L0+1
;Slave_OA.c,438 :: 		break;
	GOTO       L_getVRMS74
;Slave_OA.c,439 :: 		}
L_getVRMS75:
;Slave_OA.c,440 :: 		}
	GOTO       L_getVRMS73
L_getVRMS74:
;Slave_OA.c,441 :: 		outputADE=Read_ADE7753(VRMS,3);
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
;Slave_OA.c,442 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getVRMS76:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS76
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS76
	NOP
	NOP
;Slave_OA.c,443 :: 		totalv=totalv+outputADE;
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
;Slave_OA.c,444 :: 		Delay_ms(25);
	MOVLW      163
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_getVRMS77:
	DECFSZ     R13+0, 1
	GOTO       L_getVRMS77
	DECFSZ     R12+0, 1
	GOTO       L_getVRMS77
;Slave_OA.c,431 :: 		for(i=0;i<10;i++)
	INCF       getVRMS_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getVRMS_i_L0+1, 1
;Slave_OA.c,445 :: 		}
	GOTO       L_getVRMS70
L_getVRMS71:
;Slave_OA.c,446 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,447 :: 		vrmsraw = totalv/10;
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
;Slave_OA.c,449 :: 		vrmsraw = vrmsraw & 0xFFFFFF;
	MOVLW      255
	ANDWF      R0+0, 1
	MOVLW      255
	ANDWF      R0+1, 1
	MOVLW      255
	ANDWF      R0+2, 1
	MOVLW      0
	ANDWF      R0+3, 1
;Slave_OA.c,451 :: 		vrmsreal = (float)vrmsraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getVRMS_vrmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getVRMS_vrmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getVRMS_vrmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getVRMS_vrmsreal_L0+3
;Slave_OA.c,452 :: 		vrmsreal = vrmsreal * 0.00033834;
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
;Slave_OA.c,453 :: 		vrmsreal = vrmsreal- 2626.4;
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
;Slave_OA.c,455 :: 		if(vrmsreal > 400 || vrmsreal < 35){
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
	GOTO       L__getVRMS123
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
	GOTO       L__getVRMS123
	GOTO       L_getVRMS80
L__getVRMS123:
;Slave_OA.c,456 :: 		vrmsreal = 0;
	CLRF       getVRMS_vrmsreal_L0+0
	CLRF       getVRMS_vrmsreal_L0+1
	CLRF       getVRMS_vrmsreal_L0+2
	CLRF       getVRMS_vrmsreal_L0+3
;Slave_OA.c,457 :: 		}
L_getVRMS80:
;Slave_OA.c,458 :: 		return vrmsreal;
	MOVF       getVRMS_vrmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getVRMS_vrmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getVRMS_vrmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getVRMS_vrmsreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,459 :: 		}
L_end_getVRMS:
	RETURN
; end of _getVRMS

_getIRMS:

;Slave_OA.c,463 :: 		float getIRMS(void)
;Slave_OA.c,468 :: 		totali = 0;
	CLRF       getIRMS_totali_L0+0
	CLRF       getIRMS_totali_L0+1
	CLRF       getIRMS_totali_L0+2
	CLRF       getIRMS_totali_L0+3
;Slave_OA.c,469 :: 		j = 0;
	CLRF       getIRMS_j_L0+0
	CLRF       getIRMS_j_L0+1
;Slave_OA.c,470 :: 		Write_ADE7753(IRQEN,0x0010,2);
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
;Slave_OA.c,471 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getIRMS81:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS81
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS81
	NOP
	NOP
;Slave_OA.c,472 :: 		for(i=0;i<10;i++)
	CLRF       getIRMS_i_L0+0
	CLRF       getIRMS_i_L0+1
L_getIRMS82:
	MOVLW      128
	XORWF      getIRMS_i_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS156
	MOVLW      10
	SUBWF      getIRMS_i_L0+0, 0
L__getIRMS156:
	BTFSC      STATUS+0, 0
	GOTO       L_getIRMS83
;Slave_OA.c,474 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,475 :: 		while(! (getInterruptStatus() & ZX)){
L_getIRMS85:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 4
	GOTO       L_getIRMS86
;Slave_OA.c,476 :: 		j++;
	INCF       getIRMS_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getIRMS_j_L0+1, 1
;Slave_OA.c,477 :: 		if(j>100){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getIRMS_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getIRMS157
	MOVF       getIRMS_j_L0+0, 0
	SUBLW      100
L__getIRMS157:
	BTFSC      STATUS+0, 0
	GOTO       L_getIRMS87
;Slave_OA.c,478 :: 		j=0;
	CLRF       getIRMS_j_L0+0
	CLRF       getIRMS_j_L0+1
;Slave_OA.c,479 :: 		break;
	GOTO       L_getIRMS86
;Slave_OA.c,480 :: 		}
L_getIRMS87:
;Slave_OA.c,481 :: 		}
	GOTO       L_getIRMS85
L_getIRMS86:
;Slave_OA.c,482 :: 		outputADE=Read_ADE7753(IRMS,3);
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
;Slave_OA.c,483 :: 		Delay_ms(20);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_getIRMS88:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS88
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS88
	NOP
	NOP
;Slave_OA.c,484 :: 		totali=totali+outputADE;
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
;Slave_OA.c,485 :: 		Delay_ms(25);
	MOVLW      163
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_getIRMS89:
	DECFSZ     R13+0, 1
	GOTO       L_getIRMS89
	DECFSZ     R12+0, 1
	GOTO       L_getIRMS89
;Slave_OA.c,472 :: 		for(i=0;i<10;i++)
	INCF       getIRMS_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getIRMS_i_L0+1, 1
;Slave_OA.c,486 :: 		}
	GOTO       L_getIRMS82
L_getIRMS83:
;Slave_OA.c,487 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,488 :: 		irmsraw = totali/10;
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
;Slave_OA.c,489 :: 		irmsraw = irmsraw & 0xFFFFFF;
	MOVLW      255
	ANDWF      R0+0, 1
	MOVLW      255
	ANDWF      R0+1, 1
	MOVLW      255
	ANDWF      R0+2, 1
	MOVLW      0
	ANDWF      R0+3, 1
;Slave_OA.c,490 :: 		irmsreal = (float)irmsraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getIRMS_irmsreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getIRMS_irmsreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getIRMS_irmsreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getIRMS_irmsreal_L0+3
;Slave_OA.c,491 :: 		irmsreal = irmsreal * 0.00003714;
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
;Slave_OA.c,492 :: 		irmsreal = irmsreal- 288.1919;
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
;Slave_OA.c,494 :: 		if(irmsreal > 40 || irmsreal < 0){
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
	GOTO       L__getIRMS124
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
	GOTO       L__getIRMS124
	GOTO       L_getIRMS92
L__getIRMS124:
;Slave_OA.c,495 :: 		irmsreal = 0;
	CLRF       getIRMS_irmsreal_L0+0
	CLRF       getIRMS_irmsreal_L0+1
	CLRF       getIRMS_irmsreal_L0+2
	CLRF       getIRMS_irmsreal_L0+3
;Slave_OA.c,496 :: 		}
L_getIRMS92:
;Slave_OA.c,497 :: 		return irmsreal;
	MOVF       getIRMS_irmsreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getIRMS_irmsreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getIRMS_irmsreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getIRMS_irmsreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,498 :: 		}
L_end_getIRMS:
	RETURN
; end of _getIRMS

_getAPOWER:

;Slave_OA.c,500 :: 		float getAPOWER(void)
;Slave_OA.c,506 :: 		apreal =0;
	CLRF       getAPOWER_apreal_L0+0
	CLRF       getAPOWER_apreal_L0+1
	CLRF       getAPOWER_apreal_L0+2
	CLRF       getAPOWER_apreal_L0+3
;Slave_OA.c,507 :: 		Write_ADE7753(LINECYC,100,2);
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
;Slave_OA.c,508 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER93:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER93
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER93
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER93
	NOP
;Slave_OA.c,509 :: 		Write_ADE7753(MODE,0x0080,2);
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
;Slave_OA.c,510 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER94:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER94
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER94
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER94
	NOP
;Slave_OA.c,511 :: 		Write_ADE7753(IRQEN,0x0004,2);
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
;Slave_OA.c,512 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER95:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER95
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER95
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER95
	NOP
;Slave_OA.c,513 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,514 :: 		while(! (getInterruptStatus() & CYCEND)){
L_getAPOWER96:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 2
	GOTO       L_getAPOWER97
;Slave_OA.c,515 :: 		j++;
	INCF       getAPOWER_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getAPOWER_j_L0+1, 1
;Slave_OA.c,516 :: 		if(j>200){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getAPOWER_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER159
	MOVF       getAPOWER_j_L0+0, 0
	SUBLW      200
L__getAPOWER159:
	BTFSC      STATUS+0, 0
	GOTO       L_getAPOWER98
;Slave_OA.c,517 :: 		j=0;
	CLRF       getAPOWER_j_L0+0
	CLRF       getAPOWER_j_L0+1
;Slave_OA.c,518 :: 		break;
	GOTO       L_getAPOWER97
;Slave_OA.c,519 :: 		}
L_getAPOWER98:
;Slave_OA.c,520 :: 		}
	GOTO       L_getAPOWER96
L_getAPOWER97:
;Slave_OA.c,522 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,523 :: 		while(! (getInterruptStatus() & CYCEND)){
L_getAPOWER99:
	CALL       _getInterruptStatus+0
	BTFSC      R0+0, 2
	GOTO       L_getAPOWER100
;Slave_OA.c,524 :: 		j++;
	INCF       getAPOWER_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       getAPOWER_j_L0+1, 1
;Slave_OA.c,525 :: 		if(j>200){
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      getAPOWER_j_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__getAPOWER160
	MOVF       getAPOWER_j_L0+0, 0
	SUBLW      200
L__getAPOWER160:
	BTFSC      STATUS+0, 0
	GOTO       L_getAPOWER101
;Slave_OA.c,526 :: 		j=0;
	CLRF       getAPOWER_j_L0+0
	CLRF       getAPOWER_j_L0+1
;Slave_OA.c,527 :: 		break;
	GOTO       L_getAPOWER100
;Slave_OA.c,528 :: 		}
L_getAPOWER101:
;Slave_OA.c,529 :: 		}
	GOTO       L_getAPOWER99
L_getAPOWER100:
;Slave_OA.c,530 :: 		getresetInterruptStatus();
	CALL       _getresetInterruptStatus+0
;Slave_OA.c,531 :: 		outputADE=Read_ADE7753(LAENERGY,3);
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
;Slave_OA.c,532 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER102:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER102
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER102
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER102
	NOP
;Slave_OA.c,534 :: 		apraw = apraw & 0xFFFF;
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
;Slave_OA.c,536 :: 		apreal = (float)apraw;
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      getAPOWER_apreal_L0+0
	MOVF       R0+1, 0
	MOVWF      getAPOWER_apreal_L0+1
	MOVF       R0+2, 0
	MOVWF      getAPOWER_apreal_L0+2
	MOVF       R0+3, 0
	MOVWF      getAPOWER_apreal_L0+3
;Slave_OA.c,537 :: 		apreal = apreal * 1.6425;
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
;Slave_OA.c,538 :: 		apreal = apreal + 0.14;
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
;Slave_OA.c,539 :: 		Write_ADE7753(LINECYC,0xFFFF,2);
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
;Slave_OA.c,540 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_getAPOWER103:
	DECFSZ     R13+0, 1
	GOTO       L_getAPOWER103
	DECFSZ     R12+0, 1
	GOTO       L_getAPOWER103
	DECFSZ     R11+0, 1
	GOTO       L_getAPOWER103
	NOP
;Slave_OA.c,541 :: 		if(apreal < 8 || apreal > 2000){
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
	GOTO       L__getAPOWER125
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
	GOTO       L__getAPOWER125
	GOTO       L_getAPOWER106
L__getAPOWER125:
;Slave_OA.c,542 :: 		apreal = 0;
	CLRF       getAPOWER_apreal_L0+0
	CLRF       getAPOWER_apreal_L0+1
	CLRF       getAPOWER_apreal_L0+2
	CLRF       getAPOWER_apreal_L0+3
;Slave_OA.c,543 :: 		}
L_getAPOWER106:
;Slave_OA.c,544 :: 		return apreal;
	MOVF       getAPOWER_apreal_L0+0, 0
	MOVWF      R0+0
	MOVF       getAPOWER_apreal_L0+1, 0
	MOVWF      R0+1
	MOVF       getAPOWER_apreal_L0+2, 0
	MOVWF      R0+2
	MOVF       getAPOWER_apreal_L0+3, 0
	MOVWF      R0+3
;Slave_OA.c,545 :: 		}
L_end_getAPOWER:
	RETURN
; end of _getAPOWER

_Test:

;Slave_OA.c,550 :: 		void Test (void)
;Slave_OA.c,552 :: 		Write_ADE7753(LINECYC,0xABEF,2);
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
;Slave_OA.c,553 :: 		outputADE = Read_ADE7753(LINECYC,2);
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
;Slave_OA.c,554 :: 		HienthiUART(outputADE,2);
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
;Slave_OA.c,555 :: 		}
L_end_Test:
	RETURN
; end of _Test

_RS485_send:

;Slave_OA.c,560 :: 		void RS485_send (char dat[])
;Slave_OA.c,563 :: 		PORTD.RD4 =1;
	BSF        PORTD+0, 4
;Slave_OA.c,564 :: 		Delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_RS485_send107:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send107
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send107
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send107
	NOP
	NOP
;Slave_OA.c,565 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send108:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send163
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send163:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send109
;Slave_OA.c,566 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send111:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send112
	GOTO       L_RS485_send111
L_RS485_send112:
;Slave_OA.c,567 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_OA.c,568 :: 		Delay_ms(30);
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L_RS485_send113:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send113
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send113
;Slave_OA.c,565 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_OA.c,569 :: 		}
	GOTO       L_RS485_send108
L_RS485_send109:
;Slave_OA.c,570 :: 		Delay_ms(200);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_RS485_send114:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send114
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send114
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send114
	NOP
	NOP
;Slave_OA.c,571 :: 		PORTD.RD4 =0;
	BCF        PORTD+0, 4
;Slave_OA.c,572 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_Config_sendData:

;Slave_OA.c,576 :: 		void Config_sendData(void){
;Slave_OA.c,577 :: 		sendData[0]  = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_OA.c,578 :: 		sendData[1]  = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_OA.c,579 :: 		sendData[2]  = '3';
	MOVLW      51
	MOVWF      _sendData+2
;Slave_OA.c,580 :: 		sendData[3]  = 'D';
	MOVLW      68
	MOVWF      _sendData+3
;Slave_OA.c,581 :: 		sendData[4]  = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_OA.c,582 :: 		sendData[5]  = '4';
	MOVLW      52
	MOVWF      _sendData+5
;Slave_OA.c,583 :: 		sendData[6]  = '0';
	MOVLW      48
	MOVWF      _sendData+6
;Slave_OA.c,584 :: 		sendData[7]  = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_OA.c,585 :: 		sendData[8]  = '0';
	MOVLW      48
	MOVWF      _sendData+8
;Slave_OA.c,586 :: 		sendData[9]  = 'P';
	MOVLW      80
	MOVWF      _sendData+9
;Slave_OA.c,587 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_OA.c,588 :: 		}
L_end_Config_sendData:
	RETURN
; end of _Config_sendData

_turnOnRelay:

;Slave_OA.c,593 :: 		void turnOnRelay(void){
;Slave_OA.c,594 :: 		PORTD.RD5 =1;
	BSF        PORTD+0, 5
;Slave_OA.c,595 :: 		}
L_end_turnOnRelay:
	RETURN
; end of _turnOnRelay

_turnOffRelay:

;Slave_OA.c,600 :: 		void turnOffRelay(void){
;Slave_OA.c,601 :: 		PORTD.RD5 =0;
	BCF        PORTD+0, 5
;Slave_OA.c,602 :: 		}
L_end_turnOffRelay:
	RETURN
; end of _turnOffRelay
