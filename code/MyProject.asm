
_display_time:

;MyProject.c,27 :: 		void display_time(int x,int street) {
;MyProject.c,28 :: 		int remaining_time = x - slow_counter;
	MOVF       _slow_counter+0, 0
	SUBWF      FARG_display_time_x+0, 0
	MOVWF      FLOC__display_time+0
	MOVF       _slow_counter+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FARG_display_time_x+1, 0
	MOVWF      FLOC__display_time+1
;MyProject.c,29 :: 		int units = remaining_time % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display_time+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display_time+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      display_time_units_L0+0
	MOVF       R0+1, 0
	MOVWF      display_time_units_L0+1
;MyProject.c,30 :: 		int tens = remaining_time / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display_time+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display_time+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      display_time_tens_L0+0
	MOVF       R0+1, 0
	MOVWF      display_time_tens_L0+1
;MyProject.c,31 :: 		if(street==WEST)   {
	MOVLW      0
	XORWF      FARG_display_time_street+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_time49
	MOVLW      0
	XORWF      FARG_display_time_street+0, 0
L__display_time49:
	BTFSS      STATUS+0, 2
	GOTO       L_display_time0
;MyProject.c,32 :: 		portc.b4=0;
	BCF        PORTC+0, 4
;MyProject.c,33 :: 		portc.b5=0;
	BCF        PORTC+0, 5
;MyProject.c,34 :: 		portc = units;
	MOVF       display_time_units_L0+0, 0
	MOVWF      PORTC+0
;MyProject.c,35 :: 		porta=tens;         }
	MOVF       display_time_tens_L0+0, 0
	MOVWF      PORTA+0
	GOTO       L_display_time1
L_display_time0:
;MyProject.c,36 :: 		else if(street==SOUTH) {
	MOVLW      0
	XORWF      FARG_display_time_street+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_time50
	MOVLW      1
	XORWF      FARG_display_time_street+0, 0
L__display_time50:
	BTFSS      STATUS+0, 2
	GOTO       L_display_time2
;MyProject.c,37 :: 		portb.b6=1;
	BSF        PORTB+0, 6
;MyProject.c,38 :: 		portb.b7=1;
	BSF        PORTB+0, 7
;MyProject.c,39 :: 		portd = units;
	MOVF       display_time_units_L0+0, 0
	MOVWF      PORTD+0
;MyProject.c,40 :: 		porte=tens;
	MOVF       display_time_tens_L0+0, 0
	MOVWF      PORTE+0
;MyProject.c,41 :: 		}
L_display_time2:
L_display_time1:
;MyProject.c,42 :: 		}
L_end_display_time:
	RETURN
; end of _display_time

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,44 :: 		void interrupt() {
;MyProject.c,45 :: 		if (TMR0IF_BIT==1) {
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt3
;MyProject.c,46 :: 		if(portd.MANUAL_SWITCH==1&&slow_counter>=WEST_YELLOW_TIME) {
	BTFSS      PORTD+0, 6
	GOTO       L_interrupt6
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt53
	MOVLW      3
	SUBWF      _slow_counter+0, 0
L__interrupt53:
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt6
L__interrupt47:
;MyProject.c,47 :: 		TMR0IF_BIT = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;MyProject.c,48 :: 		portc.b4=1;
	BSF        PORTC+0, 4
;MyProject.c,49 :: 		portc.b5=1;
	BSF        PORTC+0, 5
;MyProject.c,50 :: 		portb.b6=0;
	BCF        PORTB+0, 6
;MyProject.c,51 :: 		portb.b7=0;                                            }
	BCF        PORTB+0, 7
	GOTO       L_interrupt7
L_interrupt6:
;MyProject.c,53 :: 		timer_count++;    //OCCUR EVERY 32.678 MS
	INCF       _timer_count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _timer_count+1, 1
;MyProject.c,54 :: 		TMR0IF_BIT = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;MyProject.c,55 :: 		if (timer_count % 25 == 0) {                 //must be 31
	MOVLW      25
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _timer_count+0, 0
	MOVWF      R0+0
	MOVF       _timer_count+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt54
	MOVLW      0
	XORWF      R0+0, 0
L__interrupt54:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;MyProject.c,56 :: 		slow_counter++;   // occur every 1 second
	INCF       _slow_counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _slow_counter+1, 1
;MyProject.c,57 :: 		}
L_interrupt8:
;MyProject.c,58 :: 		}
L_interrupt7:
;MyProject.c,59 :: 		}
L_interrupt3:
;MyProject.c,60 :: 		}
L_end_interrupt:
L__interrupt52:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_display_traffic_light:

;MyProject.c,62 :: 		void display_traffic_light(int street, int color) {
;MyProject.c,63 :: 		if (street == WEST) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_street+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light56
	MOVLW      0
	XORWF      FARG_display_traffic_light_street+0, 0
L__display_traffic_light56:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light9
;MyProject.c,64 :: 		if (color == RED) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light57
	MOVLW      2
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light57:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light10
;MyProject.c,65 :: 		portb.RED_WEST = 1;
	BSF        PORTB+0, 0
;MyProject.c,66 :: 		portb.YELLOW_WEST = 0;
	BCF        PORTB+0, 1
;MyProject.c,67 :: 		portb.GREEN_WEST = 0;
	BCF        PORTB+0, 2
;MyProject.c,68 :: 		}
	GOTO       L_display_traffic_light11
L_display_traffic_light10:
;MyProject.c,69 :: 		else if (color == YELLOW) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light58
	MOVLW      4
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light58:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light12
;MyProject.c,70 :: 		portb.RED_WEST = 0;
	BCF        PORTB+0, 0
;MyProject.c,71 :: 		portb.YELLOW_WEST = 1;
	BSF        PORTB+0, 1
;MyProject.c,72 :: 		portb.GREEN_WEST = 0;
	BCF        PORTB+0, 2
;MyProject.c,73 :: 		}
	GOTO       L_display_traffic_light13
L_display_traffic_light12:
;MyProject.c,74 :: 		else if (color == GREEN) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light59
	MOVLW      3
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light59:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light14
;MyProject.c,75 :: 		portb.RED_WEST = 0;
	BCF        PORTB+0, 0
;MyProject.c,76 :: 		portb.YELLOW_WEST = 0;
	BCF        PORTB+0, 1
;MyProject.c,77 :: 		portb.GREEN_WEST = 1;
	BSF        PORTB+0, 2
;MyProject.c,78 :: 		}
L_display_traffic_light14:
L_display_traffic_light13:
L_display_traffic_light11:
;MyProject.c,79 :: 		}
	GOTO       L_display_traffic_light15
L_display_traffic_light9:
;MyProject.c,80 :: 		else if (street == SOUTH) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_street+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light60
	MOVLW      1
	XORWF      FARG_display_traffic_light_street+0, 0
L__display_traffic_light60:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light16
;MyProject.c,81 :: 		if (color == RED) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light61
	MOVLW      2
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light61:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light17
;MyProject.c,82 :: 		portb.RED_SOUTH = 1;
	BSF        PORTB+0, 3
;MyProject.c,83 :: 		portb.YELLOW_SOUTH = 0;
	BCF        PORTB+0, 4
;MyProject.c,84 :: 		portb.GREEN_SOUTH = 0;
	BCF        PORTB+0, 5
;MyProject.c,85 :: 		}
	GOTO       L_display_traffic_light18
L_display_traffic_light17:
;MyProject.c,86 :: 		else if (color == YELLOW) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light62
	MOVLW      4
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light62:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light19
;MyProject.c,87 :: 		portb.RED_SOUTH = 0;
	BCF        PORTB+0, 3
;MyProject.c,88 :: 		portb.YELLOW_SOUTH = 1;
	BSF        PORTB+0, 4
;MyProject.c,89 :: 		portb.GREEN_SOUTH = 0;
	BCF        PORTB+0, 5
;MyProject.c,90 :: 		}
	GOTO       L_display_traffic_light20
L_display_traffic_light19:
;MyProject.c,91 :: 		else if (color == GREEN) {
	MOVLW      0
	XORWF      FARG_display_traffic_light_color+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display_traffic_light63
	MOVLW      3
	XORWF      FARG_display_traffic_light_color+0, 0
L__display_traffic_light63:
	BTFSS      STATUS+0, 2
	GOTO       L_display_traffic_light21
;MyProject.c,92 :: 		portb.RED_SOUTH = 0;
	BCF        PORTB+0, 3
;MyProject.c,93 :: 		portb.YELLOW_SOUTH = 0;
	BCF        PORTB+0, 4
;MyProject.c,94 :: 		portb.GREEN_SOUTH = 1;
	BSF        PORTB+0, 5
;MyProject.c,95 :: 		}
L_display_traffic_light21:
L_display_traffic_light20:
L_display_traffic_light18:
;MyProject.c,96 :: 		}
L_display_traffic_light16:
L_display_traffic_light15:
;MyProject.c,97 :: 		}
L_end_display_traffic_light:
	RETURN
; end of _display_traffic_light

_automatic_mode:

;MyProject.c,99 :: 		void automatic_mode() {
;MyProject.c,100 :: 		switch (state) {
	GOTO       L_automatic_mode22
;MyProject.c,101 :: 		case WEST_RED:
L_automatic_mode24:
;MyProject.c,102 :: 		display_traffic_light(WEST, RED);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      2
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,103 :: 		display_time(WEST_RED_TIME,WEST);
	MOVLW      15
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	CLRF       FARG_display_time_street+0
	CLRF       FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,104 :: 		if(slow_counter<SOUTH_GREEN_TIME){
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode65
	MOVLW      12
	SUBWF      _slow_counter+0, 0
L__automatic_mode65:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic_mode25
;MyProject.c,105 :: 		display_time(SOUTH_GREEN_TIME,SOUTH);
	MOVLW      12
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	MOVLW      1
	MOVWF      FARG_display_time_street+0
	MOVLW      0
	MOVWF      FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,106 :: 		display_traffic_light(SOUTH, GREEN);
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      3
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,107 :: 		}
	GOTO       L_automatic_mode26
L_automatic_mode25:
;MyProject.c,109 :: 		display_time(SOUTH_GREEN_TIME+SOUTH_YELLOW_TIME,SOUTH);
	MOVLW      15
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	MOVLW      1
	MOVWF      FARG_display_time_street+0
	MOVLW      0
	MOVWF      FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,110 :: 		display_traffic_light(SOUTH, YELLOW);}
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      4
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
L_automatic_mode26:
;MyProject.c,111 :: 		if (slow_counter >= WEST_RED_TIME) {
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode66
	MOVLW      15
	SUBWF      _slow_counter+0, 0
L__automatic_mode66:
	BTFSS      STATUS+0, 0
	GOTO       L_automatic_mode27
;MyProject.c,112 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,113 :: 		timer_count = 0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,114 :: 		state = SOUTH_RED;
	MOVLW      8
	MOVWF      _state+0
	MOVLW      0
	MOVWF      _state+1
;MyProject.c,115 :: 		}
L_automatic_mode27:
;MyProject.c,116 :: 		break;
	GOTO       L_automatic_mode23
;MyProject.c,117 :: 		case SOUTH_RED:
L_automatic_mode28:
;MyProject.c,118 :: 		display_traffic_light(SOUTH, RED);
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      2
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,119 :: 		display_time(SOUTH_RED_TIME,SOUTH);
	MOVLW      23
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	MOVLW      1
	MOVWF      FARG_display_time_street+0
	MOVLW      0
	MOVWF      FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,120 :: 		if (slow_counter<WEST_GREEN_TIME) {
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode67
	MOVLW      20
	SUBWF      _slow_counter+0, 0
L__automatic_mode67:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic_mode29
;MyProject.c,121 :: 		display_traffic_light(WEST, GREEN);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      3
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,122 :: 		display_time(WEST_GREEN_TIME,WEST);
	MOVLW      20
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	CLRF       FARG_display_time_street+0
	CLRF       FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,123 :: 		}
	GOTO       L_automatic_mode30
L_automatic_mode29:
;MyProject.c,125 :: 		display_traffic_light(WEST, YELLOW);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      4
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,126 :: 		display_time(WEST_GREEN_TIME+WEST_YELLOW_TIME,WEST);
	MOVLW      23
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	CLRF       FARG_display_time_street+0
	CLRF       FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,127 :: 		}
L_automatic_mode30:
;MyProject.c,128 :: 		if (slow_counter >=SOUTH_RED_TIME) {
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode68
	MOVLW      23
	SUBWF      _slow_counter+0, 0
L__automatic_mode68:
	BTFSS      STATUS+0, 0
	GOTO       L_automatic_mode31
;MyProject.c,129 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,130 :: 		timer_count = 0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,131 :: 		state = WEST_RED;
	MOVLW      5
	MOVWF      _state+0
	MOVLW      0
	MOVWF      _state+1
;MyProject.c,132 :: 		}
L_automatic_mode31:
;MyProject.c,133 :: 		break;
	GOTO       L_automatic_mode23
;MyProject.c,134 :: 		}
L_automatic_mode22:
	MOVLW      0
	XORWF      _state+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode69
	MOVLW      5
	XORWF      _state+0, 0
L__automatic_mode69:
	BTFSC      STATUS+0, 2
	GOTO       L_automatic_mode24
	MOVLW      0
	XORWF      _state+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic_mode70
	MOVLW      8
	XORWF      _state+0, 0
L__automatic_mode70:
	BTFSC      STATUS+0, 2
	GOTO       L_automatic_mode28
L_automatic_mode23:
;MyProject.c,135 :: 		}
L_end_automatic_mode:
	RETURN
; end of _automatic_mode

_manual_mode:

;MyProject.c,137 :: 		void manual_mode() {
;MyProject.c,138 :: 		if(portd.STREET_SWITCH==WEST){
	BTFSC      PORTD+0, 7
	GOTO       L_manual_mode32
;MyProject.c,139 :: 		flag1=1;
	MOVLW      1
	MOVWF      _flag1+0
	MOVLW      0
	MOVWF      _flag1+1
;MyProject.c,140 :: 		if(flag2==1){
	MOVLW      0
	XORWF      _flag2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode72
	MOVLW      1
	XORWF      _flag2+0, 0
L__manual_mode72:
	BTFSS      STATUS+0, 2
	GOTO       L_manual_mode33
;MyProject.c,141 :: 		flag2=0;
	CLRF       _flag2+0
	CLRF       _flag2+1
;MyProject.c,142 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,143 :: 		timer_count=0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,144 :: 		}
L_manual_mode33:
;MyProject.c,145 :: 		display_traffic_light(WEST, GREEN);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      3
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,146 :: 		if(slow_counter<SOUTH_YELLOW_TIME) {    // not <= as when slow counter reach 3 go to else not when reach 4 second
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode73
	MOVLW      3
	SUBWF      _slow_counter+0, 0
L__manual_mode73:
	BTFSC      STATUS+0, 0
	GOTO       L_manual_mode34
;MyProject.c,147 :: 		display_traffic_light(SOUTH, YELLOW);
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      4
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,148 :: 		display_time(SOUTH_YELLOW_TIME,SOUTH);
	MOVLW      3
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	MOVLW      1
	MOVWF      FARG_display_time_street+0
	MOVLW      0
	MOVWF      FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,149 :: 		portc.b4=1;
	BSF        PORTC+0, 4
;MyProject.c,150 :: 		portc.b5=1;
	BSF        PORTC+0, 5
;MyProject.c,151 :: 		}
	GOTO       L_manual_mode35
L_manual_mode34:
;MyProject.c,153 :: 		display_traffic_light(SOUTH, RED);
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      2
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,154 :: 		}
L_manual_mode35:
;MyProject.c,155 :: 		}
	GOTO       L_manual_mode36
L_manual_mode32:
;MyProject.c,156 :: 		else if(portd.STREET_SWITCH==SOUTH){
	BTFSS      PORTD+0, 7
	GOTO       L_manual_mode37
;MyProject.c,157 :: 		flag2=1;
	MOVLW      1
	MOVWF      _flag2+0
	MOVLW      0
	MOVWF      _flag2+1
;MyProject.c,158 :: 		if(flag1==1){
	MOVLW      0
	XORWF      _flag1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode74
	MOVLW      1
	XORWF      _flag1+0, 0
L__manual_mode74:
	BTFSS      STATUS+0, 2
	GOTO       L_manual_mode38
;MyProject.c,159 :: 		flag1=0;
	CLRF       _flag1+0
	CLRF       _flag1+1
;MyProject.c,160 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,161 :: 		timer_count=0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,162 :: 		}
L_manual_mode38:
;MyProject.c,163 :: 		display_traffic_light(SOUTH, GREEN);
	MOVLW      1
	MOVWF      FARG_display_traffic_light_street+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_street+1
	MOVLW      3
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,165 :: 		if(slow_counter<WEST_YELLOW_TIME) {    // not <= as when slow counter reach 3 go to else not when reach 4 second
	MOVLW      128
	XORWF      _slow_counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_mode75
	MOVLW      3
	SUBWF      _slow_counter+0, 0
L__manual_mode75:
	BTFSC      STATUS+0, 0
	GOTO       L_manual_mode39
;MyProject.c,166 :: 		display_traffic_light(WEST, YELLOW);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      4
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,167 :: 		display_time(WEST_YELLOW_TIME,WEST);
	MOVLW      3
	MOVWF      FARG_display_time_x+0
	MOVLW      0
	MOVWF      FARG_display_time_x+1
	CLRF       FARG_display_time_street+0
	CLRF       FARG_display_time_street+1
	CALL       _display_time+0
;MyProject.c,168 :: 		portb.b6=0;
	BCF        PORTB+0, 6
;MyProject.c,169 :: 		portb.b7=0;
	BCF        PORTB+0, 7
;MyProject.c,170 :: 		}
	GOTO       L_manual_mode40
L_manual_mode39:
;MyProject.c,172 :: 		display_traffic_light(WEST, RED);
	CLRF       FARG_display_traffic_light_street+0
	CLRF       FARG_display_traffic_light_street+1
	MOVLW      2
	MOVWF      FARG_display_traffic_light_color+0
	MOVLW      0
	MOVWF      FARG_display_traffic_light_color+1
	CALL       _display_traffic_light+0
;MyProject.c,173 :: 		}
L_manual_mode40:
;MyProject.c,174 :: 		}
L_manual_mode37:
L_manual_mode36:
;MyProject.c,175 :: 		}
L_end_manual_mode:
	RETURN
; end of _manual_mode

_main:

;MyProject.c,177 :: 		void main() {
;MyProject.c,178 :: 		adcon1=7;
	MOVLW      7
	MOVWF      ADCON1+0
;MyProject.c,179 :: 		trisa=0b00000000;
	CLRF       TRISA+0
;MyProject.c,180 :: 		trise=0b000;
	CLRF       TRISE+0
;MyProject.c,181 :: 		PORTA=0;
	CLRF       PORTA+0
;MyProject.c,182 :: 		GIE_BIT=1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;MyProject.c,183 :: 		TMR0IE_BIT=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;MyProject.c,184 :: 		OPTION_REG=0b10000111;  //pres is 256
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,185 :: 		TMR0=0;
	CLRF       TMR0+0
;MyProject.c,186 :: 		TRISC = 0b00000000;
	CLRF       TRISC+0
;MyProject.c,187 :: 		PORTC=0;
	CLRF       PORTC+0
;MyProject.c,188 :: 		TRISB = 0b00000000;
	CLRF       TRISB+0
;MyProject.c,189 :: 		trisd=0b11000000;
	MOVLW      192
	MOVWF      TRISD+0
;MyProject.c,190 :: 		while(1) {
L_main41:
;MyProject.c,191 :: 		if (portd.B6==1) {
	BTFSS      PORTD+0, 6
	GOTO       L_main43
;MyProject.c,192 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;MyProject.c,193 :: 		if(flag0==1){
	MOVLW      0
	XORWF      _flag0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main77
	MOVLW      1
	XORWF      _flag0+0, 0
L__main77:
	BTFSS      STATUS+0, 2
	GOTO       L_main44
;MyProject.c,194 :: 		flag0=0;
	CLRF       _flag0+0
	CLRF       _flag0+1
;MyProject.c,195 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,196 :: 		timer_count=0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,197 :: 		}
L_main44:
;MyProject.c,198 :: 		manual_mode();
	CALL       _manual_mode+0
;MyProject.c,199 :: 		}
	GOTO       L_main45
L_main43:
;MyProject.c,201 :: 		flag0=1;
	MOVLW      1
	MOVWF      _flag0+0
	MOVLW      0
	MOVWF      _flag0+1
;MyProject.c,202 :: 		if(flag==1){
	MOVLW      0
	XORWF      _flag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main78
	MOVLW      1
	XORWF      _flag+0, 0
L__main78:
	BTFSS      STATUS+0, 2
	GOTO       L_main46
;MyProject.c,203 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;MyProject.c,204 :: 		slow_counter=0;
	CLRF       _slow_counter+0
	CLRF       _slow_counter+1
;MyProject.c,205 :: 		timer_count=0;
	CLRF       _timer_count+0
	CLRF       _timer_count+1
;MyProject.c,206 :: 		}
L_main46:
;MyProject.c,207 :: 		automatic_mode();
	CALL       _automatic_mode+0
;MyProject.c,208 :: 		}
L_main45:
;MyProject.c,209 :: 		}
	GOTO       L_main41
;MyProject.c,210 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
