
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave_CA3.c,38 :: 		void interrupt()
;Slave_CA3.c,40 :: 		if(PIR1.RCIF)
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;Slave_CA3.c,42 :: 		while(uart1_data_ready()==0);
L_interrupt1:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
	GOTO       L_interrupt1
L_interrupt2:
;Slave_CA3.c,43 :: 		if(uart1_data_ready()==1)
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Slave_CA3.c,45 :: 		tempReceiveData = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempReceiveData+0
;Slave_CA3.c,46 :: 		if(tempReceiveData == 'S')
	MOVF       R0+0, 0
	XORLW      83
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Slave_CA3.c,48 :: 		busy = 1;
	MOVLW      1
	MOVWF      _busy+0
	MOVLW      0
	MOVWF      _busy+1
;Slave_CA3.c,49 :: 		count = 0;
	CLRF       _count+0
;Slave_CA3.c,50 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,51 :: 		count++;
	INCF       _count+0, 1
;Slave_CA3.c,52 :: 		}
L_interrupt4:
;Slave_CA3.c,53 :: 		if(tempReceiveData !='S' && tempReceiveData !='E')
	MOVF       _tempReceiveData+0, 0
	XORLW      83
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt7
L__interrupt61:
;Slave_CA3.c,55 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,56 :: 		count++;
	INCF       _count+0, 1
;Slave_CA3.c,57 :: 		}
L_interrupt7:
;Slave_CA3.c,58 :: 		if(tempReceiveData == 'E')
	MOVF       _tempReceiveData+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Slave_CA3.c,60 :: 		receiveData[count] = tempReceiveData;
	MOVF       _count+0, 0
	ADDLW      _receiveData+0
	MOVWF      FSR
	MOVF       _tempReceiveData+0, 0
	MOVWF      INDF+0
;Slave_CA3.c,61 :: 		count=0;
	CLRF       _count+0
;Slave_CA3.c,62 :: 		flagReceivedAllData = 1;
	MOVLW      1
	MOVWF      _flagReceivedAllData+0
;Slave_CA3.c,63 :: 		busy = 0;
	CLRF       _busy+0
	CLRF       _busy+1
;Slave_CA3.c,64 :: 		}
L_interrupt8:
;Slave_CA3.c,65 :: 		}
L_interrupt3:
;Slave_CA3.c,66 :: 		}
L_interrupt0:
;Slave_CA3.c,67 :: 		}
L_end_interrupt:
L__interrupt69:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Slave_CA3.c,68 :: 		void main() {
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
;Slave_CA3.c,84 :: 		addressButton1[0] = '0';
	MOVLW      48
	MOVWF      _addressButton1+0
;Slave_CA3.c,85 :: 		addressButton1[1] = '1';
	MOVLW      49
	MOVWF      _addressButton1+1
;Slave_CA3.c,86 :: 		addressDevice1[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice1+0
;Slave_CA3.c,87 :: 		addressDevice1[1] = '1';
	MOVLW      49
	MOVWF      _addressDevice1+1
;Slave_CA3.c,89 :: 		addressButton2[0] = '0';
	MOVLW      48
	MOVWF      _addressButton2+0
;Slave_CA3.c,90 :: 		addressButton2[1] = '2';
	MOVLW      50
	MOVWF      _addressButton2+1
;Slave_CA3.c,91 :: 		addressDevice2[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice2+0
;Slave_CA3.c,92 :: 		addressDevice2[1] = '2';
	MOVLW      50
	MOVWF      _addressDevice2+1
;Slave_CA3.c,94 :: 		addressButton3[0] = '0';
	MOVLW      48
	MOVWF      _addressButton3+0
;Slave_CA3.c,95 :: 		addressButton3[1] = '3';
	MOVLW      51
	MOVWF      _addressButton3+1
;Slave_CA3.c,96 :: 		addressDevice3[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice3+0
;Slave_CA3.c,97 :: 		addressDevice3[1] = '3';
	MOVLW      51
	MOVWF      _addressDevice3+1
;Slave_CA3.c,116 :: 		Delay_ms(100);
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
;Slave_CA3.c,134 :: 		while(1)
L_main11:
;Slave_CA3.c,176 :: 		if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
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
	GOTO       L_main13
;Slave_CA3.c,177 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,178 :: 		}
L_main13:
;Slave_CA3.c,179 :: 		if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main16
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main16
L__main67:
;Slave_CA3.c,180 :: 		Delay_ms(100);
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
;Slave_CA3.c,181 :: 		if (oldstate && Button(&PORTB, 0, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main20
	MOVLW      PORTB+0
	MOVWF      FARG_Button_port+0
	CLRF       FARG_Button_pin+0
	MOVLW      1
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main20
L__main66:
;Slave_CA3.c,183 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,184 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,185 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,186 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,187 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_CA3.c,188 :: 		sendData[5] = '1';
	MOVLW      49
	MOVWF      _sendData+5
;Slave_CA3.c,191 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,192 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_CA3.c,193 :: 		sendData[8] = '1';
	MOVLW      49
	MOVWF      _sendData+8
;Slave_CA3.c,196 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,197 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,198 :: 		checkstt(stt1);
	MOVF       _stt1+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt1+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,199 :: 		stt1++;
	INCF       _stt1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt1+1, 1
;Slave_CA3.c,200 :: 		while(busy == 1){
L_main21:
	MOVLW      0
	XORWF      _busy+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVLW      1
	XORWF      _busy+0, 0
L__main71:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;Slave_CA3.c,202 :: 		}
	GOTO       L_main21
L_main22:
;Slave_CA3.c,203 :: 		Delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	NOP
;Slave_CA3.c,204 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,205 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
	NOP
;Slave_CA3.c,207 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,208 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
;Slave_CA3.c,209 :: 		}                              // Update flag
L_main20:
;Slave_CA3.c,210 :: 		}
L_main16:
;Slave_CA3.c,213 :: 		if (Button(&PORTB, 4, 1, 1)) {               // Detect logical one
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
	GOTO       L_main26
;Slave_CA3.c,214 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,215 :: 		}
L_main26:
;Slave_CA3.c,216 :: 		if (oldstate && Button(&PORTB, 4, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main29
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
L__main65:
;Slave_CA3.c,217 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
	DECFSZ     R11+0, 1
	GOTO       L_main30
	NOP
	NOP
;Slave_CA3.c,218 :: 		if (oldstate && Button(&PORTB, 4, 1, 0))
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
L__main64:
;Slave_CA3.c,220 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,221 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,222 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,223 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,228 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_CA3.c,229 :: 		sendData[5] = '2';
	MOVLW      50
	MOVWF      _sendData+5
;Slave_CA3.c,230 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,235 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_CA3.c,236 :: 		sendData[8] = '2';
	MOVLW      50
	MOVWF      _sendData+8
;Slave_CA3.c,237 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,238 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,239 :: 		checkstt(stt2);
	MOVF       _stt2+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt2+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,240 :: 		stt2++;
	INCF       _stt2+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt2+1, 1
;Slave_CA3.c,241 :: 		while(busy == 1){
L_main34:
	MOVLW      0
	XORWF      _busy+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVLW      1
	XORWF      _busy+0, 0
L__main72:
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;Slave_CA3.c,243 :: 		}
	GOTO       L_main34
L_main35:
;Slave_CA3.c,244 :: 		Delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	NOP
;Slave_CA3.c,245 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,246 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
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
;Slave_CA3.c,248 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,249 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
;Slave_CA3.c,250 :: 		}                              // Update flag
L_main33:
;Slave_CA3.c,251 :: 		}
L_main29:
;Slave_CA3.c,254 :: 		if (Button(&PORTB, 5, 1, 1)) {               // Detect logical one
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
;Slave_CA3.c,255 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,256 :: 		}
L_main39:
;Slave_CA3.c,258 :: 		if (oldstate && Button(&PORTB, 5, 1, 0)) {   // Detect one-to-zero transition
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
L__main63:
;Slave_CA3.c,259 :: 		Delay_ms(100);
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
;Slave_CA3.c,260 :: 		if (oldstate && Button(&PORTB, 5, 1, 0))
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
L__main62:
;Slave_CA3.c,262 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,263 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,264 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,265 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,270 :: 		sendData[4] = '0';
	MOVLW      48
	MOVWF      _sendData+4
;Slave_CA3.c,271 :: 		sendData[5] = '3';
	MOVLW      51
	MOVWF      _sendData+5
;Slave_CA3.c,272 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,277 :: 		sendData[7] = '0';
	MOVLW      48
	MOVWF      _sendData+7
;Slave_CA3.c,278 :: 		sendData[8] = '3';
	MOVLW      51
	MOVWF      _sendData+8
;Slave_CA3.c,279 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,280 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,281 :: 		checkstt(stt3);
	MOVF       _stt3+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt3+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,282 :: 		stt3++;
	INCF       _stt3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt3+1, 1
;Slave_CA3.c,283 :: 		while(busy == 1){
L_main47:
	MOVLW      0
	XORWF      _busy+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVLW      1
	XORWF      _busy+0, 0
L__main73:
	BTFSS      STATUS+0, 2
	GOTO       L_main48
;Slave_CA3.c,285 :: 		}
	GOTO       L_main47
L_main48:
;Slave_CA3.c,286 :: 		Delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main49:
	DECFSZ     R13+0, 1
	GOTO       L_main49
	DECFSZ     R12+0, 1
	GOTO       L_main49
	NOP
;Slave_CA3.c,287 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,288 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main50:
	DECFSZ     R13+0, 1
	GOTO       L_main50
	DECFSZ     R12+0, 1
	GOTO       L_main50
	DECFSZ     R11+0, 1
	GOTO       L_main50
	NOP
	NOP
;Slave_CA3.c,290 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,291 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main51:
	DECFSZ     R13+0, 1
	GOTO       L_main51
	DECFSZ     R12+0, 1
	GOTO       L_main51
	DECFSZ     R11+0, 1
	GOTO       L_main51
	NOP
;Slave_CA3.c,292 :: 		}
L_main46:
;Slave_CA3.c,293 :: 		}
L_main42:
;Slave_CA3.c,295 :: 		}
	GOTO       L_main11
;Slave_CA3.c,296 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RS485_send:

;Slave_CA3.c,298 :: 		void RS485_send (char dat[])
;Slave_CA3.c,301 :: 		PORTB.RB3 =1;
	BSF        PORTB+0, 3
;Slave_CA3.c,302 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_RS485_send52:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send52
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send52
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send52
	NOP
	NOP
;Slave_CA3.c,303 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send53:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send75
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send75:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send54
;Slave_CA3.c,304 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send56:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send57
	GOTO       L_RS485_send56
L_RS485_send57:
;Slave_CA3.c,305 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_CA3.c,303 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_CA3.c,306 :: 		}
	GOTO       L_RS485_send53
L_RS485_send54:
;Slave_CA3.c,307 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_RS485_send58:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send58
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send58
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send58
	NOP
	NOP
;Slave_CA3.c,308 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_CA3.c,309 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_checkstt:

;Slave_CA3.c,311 :: 		void checkstt (int stt)
;Slave_CA3.c,313 :: 		if (stt % 2 == 0)
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
	GOTO       L__checkstt77
	MOVLW      0
	XORWF      R0+0, 0
L__checkstt77:
	BTFSS      STATUS+0, 2
	GOTO       L_checkstt59
;Slave_CA3.c,314 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
	GOTO       L_checkstt60
L_checkstt59:
;Slave_CA3.c,316 :: 		sendData[9] = '1';
	MOVLW      49
	MOVWF      _sendData+9
L_checkstt60:
;Slave_CA3.c,317 :: 		}
L_end_checkstt:
	RETURN
; end of _checkstt
