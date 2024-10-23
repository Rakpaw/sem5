/*
 *   Author: Pawel Rakoczy
 */ 
 
 .def zmiana = r25
 .def diody = r16
 .def przyciski = r24
 .equ ustawionaJasnosc = 128
 .def brightCounter = r23
 .org 0
 .cseg

 rjmp pocz
 .org 0x46


 pocz: 
		ldi r16, LOW(RAMEND)
		out spl, r16
		ldi r16, HIGH(RAMEND)
		out sph, r16 

		ldi r16, 0xFF
		out DDRC, r16
		com r16
		out DDRB, r16

		ldi zmiana, 0b10010000
		ldi diody,  0b01111111
		out PORTC, diody

 petla:
		in przyciski, PINB
		com przyciski
		eor diody, zmiana
		out PORTC, diody
		cpi przyciski, 1
		breq wywolaj1s
		cpi przyciski, 2
		breq wywolaj60Hz
		cpi przyciski, 4
		breq wywolajJasnosc
		rjmp petla


wywolaj1s:			//uzywa r17 i x(26,27)
		call delay1s
		rjmp petla
wywolaj60Hz:		//uzywa r17 i x(26,27)
		call delay60Hz
		rjmp petla
wywolajJasnosc:		//uzywa r17, r18, r19, r20 i x(26,27)
		call jasnosc
		rjmp petla

 .org 0x200

delay1s: // 2 + 8 + (stalaWew * 3 - 1) * stalaZew + stalaZew * 5 - 1
		ldi xh, 0b00101110 //11920
		ldi xl, 0b10010000
petlaZew:
		ldi r17, 200		
	petlaWeW: 
			dec r17
			brne petlaWew

		sbiw x, 1
		brne petlaZew
	ret 


delay60Hz: // 2 + 8 + (stalaWew * 3 - 1) * stalaZew + stalaZew * 5 - 1
		ldi xh, 0
		ldi xl, 0b11000000
petlaZew2:
		ldi r17, 207		
	petlaWeW2: 
			dec r17
			brne petlaWew2

		sbiw x, 1
		brne petlaZew2
	ret 

jasnosc:
		ldi xh, 0
		ldi xl, 0b01100000
		mov r19, diody  //r19 maska
		com r19
		mov r18, diody
		ldi brightCounter, ustawionaJasnosc

petlaZew3:
		ldi r17, 206		
	petlaWeW3: 
			dec brightCounter
			breq zamiana
			cpi brightcounter, ustawionaJasnosc
			breq zamiana
		powrot:
			dec r17
			brne petlaWew3

		sbiw x, 1
		brne petlaZew3
	ret 

zamiana:
		eor r18, r19
		out PORTC, r18
		rjmp powrot