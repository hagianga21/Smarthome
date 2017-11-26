
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
L__interrupt52:
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
L__interrupt60:
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
;Slave_CA3.c,66 :: 		TRISB.B0 =1;
	BSF        TRISB+0, 0
;Slave_CA3.c,67 :: 		TRISB.B4 =1;
	BSF        TRISB+0, 4
;Slave_CA3.c,68 :: 		TRISB.B5 =1;
	BSF        TRISB+0, 5
;Slave_CA3.c,70 :: 		TRISB.B3 =0;                         //Bit RS485
	BCF        TRISB+0, 3
;Slave_CA3.c,72 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,73 :: 		UART1_Init(9600);
	MOVLW      129
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave_CA3.c,74 :: 		Delay_ms(100);
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
;Slave_CA3.c,76 :: 		RCIE_bit = 1;                        // enable interrupt on UART1 receive
	BSF        RCIE_bit+0, BitPos(RCIE_bit+0)
;Slave_CA3.c,77 :: 		TXIE_bit = 0;                        // disable interrupt on UART1 transmit
	BCF        TXIE_bit+0, BitPos(TXIE_bit+0)
;Slave_CA3.c,78 :: 		PEIE_bit = 1;                        // enable peripheral interrupts
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Slave_CA3.c,79 :: 		GIE_bit = 1;                         // enable all interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Slave_CA3.c,81 :: 		addressButton1[0] = '0';
	MOVLW      48
	MOVWF      _addressButton1+0
;Slave_CA3.c,82 :: 		addressButton1[1] = '1';
	MOVLW      49
	MOVWF      _addressButton1+1
;Slave_CA3.c,83 :: 		addressDevice1[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice1+0
;Slave_CA3.c,84 :: 		addressDevice1[1] = '1';
	MOVLW      49
	MOVWF      _addressDevice1+1
;Slave_CA3.c,86 :: 		addressButton2[0] = '0';
	MOVLW      48
	MOVWF      _addressButton2+0
;Slave_CA3.c,87 :: 		addressButton2[1] = '2';
	MOVLW      50
	MOVWF      _addressButton2+1
;Slave_CA3.c,88 :: 		addressDevice2[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice2+0
;Slave_CA3.c,89 :: 		addressDevice2[1] = '2';
	MOVLW      50
	MOVWF      _addressDevice2+1
;Slave_CA3.c,91 :: 		addressButton3[0] = '0';
	MOVLW      48
	MOVWF      _addressButton3+0
;Slave_CA3.c,92 :: 		addressButton3[1] = '3';
	MOVLW      51
	MOVWF      _addressButton3+1
;Slave_CA3.c,93 :: 		addressDevice3[0] = '0';
	MOVLW      48
	MOVWF      _addressDevice3+0
;Slave_CA3.c,94 :: 		addressDevice3[1] = '3';
	MOVLW      51
	MOVWF      _addressDevice3+1
;Slave_CA3.c,113 :: 		Delay_ms(100);
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
;Slave_CA3.c,131 :: 		while(1)
L_main11:
;Slave_CA3.c,173 :: 		if (Button(&PORTB, 0, 1, 1)) {               // Detect logical one
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
;Slave_CA3.c,174 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,175 :: 		}
L_main13:
;Slave_CA3.c,176 :: 		if (oldstate && Button(&PORTB, 0, 1, 0)) {   // Detect one-to-zero transition
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
L__main58:
;Slave_CA3.c,177 :: 		Delay_ms(100);
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
;Slave_CA3.c,178 :: 		if (oldstate && Button(&PORTB, 0, 1, 0))
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
L__main57:
;Slave_CA3.c,180 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,181 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,182 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,183 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,184 :: 		sendData[4] = addressButton1[0];
	MOVF       _addressButton1+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,185 :: 		sendData[5] = addressButton1[1];
	MOVF       _addressButton1+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,186 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,187 :: 		sendData[7] = addressDevice1[0];
	MOVF       _addressDevice1+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,188 :: 		sendData[8] = addressDevice1[1];
	MOVF       _addressDevice1+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,189 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,190 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,191 :: 		checkstt(stt1);
	MOVF       _stt1+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt1+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,192 :: 		stt1++;
	INCF       _stt1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt1+1, 1
;Slave_CA3.c,193 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,194 :: 		Delay_ms(100);
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
;Slave_CA3.c,196 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,197 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main22:
	DECFSZ     R13+0, 1
	GOTO       L_main22
	DECFSZ     R12+0, 1
	GOTO       L_main22
	DECFSZ     R11+0, 1
	GOTO       L_main22
	NOP
;Slave_CA3.c,198 :: 		}                              // Update flag
L_main20:
;Slave_CA3.c,199 :: 		}
L_main16:
;Slave_CA3.c,202 :: 		if (Button(&PORTB, 4, 1, 1)) {               // Detect logical one
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
	GOTO       L_main23
;Slave_CA3.c,203 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,204 :: 		}
L_main23:
;Slave_CA3.c,205 :: 		if (oldstate && Button(&PORTB, 4, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main26
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
L__main56:
;Slave_CA3.c,206 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;Slave_CA3.c,207 :: 		if (oldstate && Button(&PORTB, 4, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main30
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
	GOTO       L_main30
L__main55:
;Slave_CA3.c,209 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,210 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,211 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,212 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,213 :: 		sendData[4] = addressButton2[0];
	MOVF       _addressButton2+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,214 :: 		sendData[5] = addressButton2[1];
	MOVF       _addressButton2+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,215 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,216 :: 		sendData[7] = addressDevice2[0];
	MOVF       _addressDevice2+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,217 :: 		sendData[8] = addressDevice2[1];
	MOVF       _addressDevice2+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,218 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,219 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,220 :: 		checkstt(stt2);
	MOVF       _stt2+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt2+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,221 :: 		stt2++;
	INCF       _stt2+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt2+1, 1
;Slave_CA3.c,222 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,223 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main31:
	DECFSZ     R13+0, 1
	GOTO       L_main31
	DECFSZ     R12+0, 1
	GOTO       L_main31
	DECFSZ     R11+0, 1
	GOTO       L_main31
	NOP
	NOP
;Slave_CA3.c,225 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,226 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main32:
	DECFSZ     R13+0, 1
	GOTO       L_main32
	DECFSZ     R12+0, 1
	GOTO       L_main32
	DECFSZ     R11+0, 1
	GOTO       L_main32
	NOP
;Slave_CA3.c,227 :: 		}                              // Update flag
L_main30:
;Slave_CA3.c,228 :: 		}
L_main26:
;Slave_CA3.c,231 :: 		if (Button(&PORTB, 5, 1, 1)) {               // Detect logical one
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
	GOTO       L_main33
;Slave_CA3.c,232 :: 		oldstate = 1;                              // Update flag
	BSF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,233 :: 		}
L_main33:
;Slave_CA3.c,235 :: 		if (oldstate && Button(&PORTB, 5, 1, 0)) {   // Detect one-to-zero transition
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main36
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
	GOTO       L_main36
L__main54:
;Slave_CA3.c,236 :: 		Delay_ms(100);
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
;Slave_CA3.c,237 :: 		if (oldstate && Button(&PORTB, 5, 1, 0))
	BTFSS      _oldstate+0, BitPos(_oldstate+0)
	GOTO       L_main40
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
	GOTO       L_main40
L__main53:
;Slave_CA3.c,239 :: 		sendData[0] = 'S';
	MOVLW      83
	MOVWF      _sendData+0
;Slave_CA3.c,240 :: 		sendData[1] = '0';
	MOVLW      48
	MOVWF      _sendData+1
;Slave_CA3.c,241 :: 		sendData[2] = '0';
	MOVLW      48
	MOVWF      _sendData+2
;Slave_CA3.c,242 :: 		sendData[3] = 'B';
	MOVLW      66
	MOVWF      _sendData+3
;Slave_CA3.c,243 :: 		sendData[4] = addressButton3[0];
	MOVF       _addressButton3+0, 0
	MOVWF      _sendData+4
;Slave_CA3.c,244 :: 		sendData[5] = addressButton3[1];
	MOVF       _addressButton3+1, 0
	MOVWF      _sendData+5
;Slave_CA3.c,245 :: 		sendData[6] = 'D';
	MOVLW      68
	MOVWF      _sendData+6
;Slave_CA3.c,246 :: 		sendData[7] = addressDevice3[0];
	MOVF       _addressDevice3+0, 0
	MOVWF      _sendData+7
;Slave_CA3.c,247 :: 		sendData[8] = addressDevice3[1];
	MOVF       _addressDevice3+1, 0
	MOVWF      _sendData+8
;Slave_CA3.c,248 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
;Slave_CA3.c,249 :: 		sendData[10] = 'E';
	MOVLW      69
	MOVWF      _sendData+10
;Slave_CA3.c,250 :: 		checkstt(stt3);
	MOVF       _stt3+0, 0
	MOVWF      FARG_checkstt_stt+0
	MOVF       _stt3+1, 0
	MOVWF      FARG_checkstt_stt+1
	CALL       _checkstt+0
;Slave_CA3.c,251 :: 		stt3++;
	INCF       _stt3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _stt3+1, 1
;Slave_CA3.c,252 :: 		RS485_send(sendData);
	MOVLW      _sendData+0
	MOVWF      FARG_RS485_send_dat+0
	CALL       _RS485_send+0
;Slave_CA3.c,253 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main41:
	DECFSZ     R13+0, 1
	GOTO       L_main41
	DECFSZ     R12+0, 1
	GOTO       L_main41
	DECFSZ     R11+0, 1
	GOTO       L_main41
	NOP
	NOP
;Slave_CA3.c,255 :: 		oldstate = 0;
	BCF        _oldstate+0, BitPos(_oldstate+0)
;Slave_CA3.c,256 :: 		Delay_ms(500);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_main42:
	DECFSZ     R13+0, 1
	GOTO       L_main42
	DECFSZ     R12+0, 1
	GOTO       L_main42
	DECFSZ     R11+0, 1
	GOTO       L_main42
	NOP
;Slave_CA3.c,257 :: 		}
L_main40:
;Slave_CA3.c,258 :: 		}
L_main36:
;Slave_CA3.c,260 :: 		}
	GOTO       L_main11
;Slave_CA3.c,261 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_RS485_send:

;Slave_CA3.c,263 :: 		void RS485_send (char dat[])
;Slave_CA3.c,266 :: 		PORTB.RB3 =1;
	BSF        PORTB+0, 3
;Slave_CA3.c,267 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_RS485_send43:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send43
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send43
	DECFSZ     R11+0, 1
	GOTO       L_RS485_send43
	NOP
	NOP
;Slave_CA3.c,268 :: 		for (i=0; i<=10;i++){
	CLRF       RS485_send_i_L0+0
	CLRF       RS485_send_i_L0+1
L_RS485_send44:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      RS485_send_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__RS485_send63
	MOVF       RS485_send_i_L0+0, 0
	SUBLW      10
L__RS485_send63:
	BTFSS      STATUS+0, 0
	GOTO       L_RS485_send45
;Slave_CA3.c,269 :: 		while(UART1_Tx_Idle()==0);
L_RS485_send47:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_RS485_send48
	GOTO       L_RS485_send47
L_RS485_send48:
;Slave_CA3.c,270 :: 		UART1_Write(dat[i]);
	MOVF       RS485_send_i_L0+0, 0
	ADDWF      FARG_RS485_send_dat+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Slave_CA3.c,268 :: 		for (i=0; i<=10;i++){
	INCF       RS485_send_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       RS485_send_i_L0+1, 1
;Slave_CA3.c,271 :: 		}
	GOTO       L_RS485_send44
L_RS485_send45:
;Slave_CA3.c,272 :: 		Delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_RS485_send49:
	DECFSZ     R13+0, 1
	GOTO       L_RS485_send49
	DECFSZ     R12+0, 1
	GOTO       L_RS485_send49
	NOP
;Slave_CA3.c,273 :: 		PORTB.RB3 =0;
	BCF        PORTB+0, 3
;Slave_CA3.c,274 :: 		}
L_end_RS485_send:
	RETURN
; end of _RS485_send

_checkstt:

;Slave_CA3.c,276 :: 		void checkstt (int stt)
;Slave_CA3.c,278 :: 		if (stt % 2 == 0)
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
	GOTO       L__checkstt65
	MOVLW      0
	XORWF      R0+0, 0
L__checkstt65:
	BTFSS      STATUS+0, 2
	GOTO       L_checkstt50
;Slave_CA3.c,279 :: 		sendData[9] = '0';
	MOVLW      48
	MOVWF      _sendData+9
	GOTO       L_checkstt51
L_checkstt50:
;Slave_CA3.c,281 :: 		sendData[9] = '1';
	MOVLW      49
	MOVWF      _sendData+9
L_checkstt51:
;Slave_CA3.c,282 :: 		}
L_end_checkstt:
	RETURN
; end of _checkstt
