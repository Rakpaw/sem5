;
; zad3.asm
; Author : pawel
;

.def licznik = r18

.org 0x00
.cseg

    rjmp start
.org 0x46

start:
		ldi r16, LOW(RAMEND)
		out spl, r16
		ldi r16, HIGH(RAMEND)
		out sph, r16 

		ldi r16, 0xFF
		out DDRC, r16
		com r16
		out DDRB, r16
		ldi licznik, 0


glowny:
		in r16, PINB
		cpi r16, 0xFF
		breq glowny
		
		ldi yl, 50
		call delayx // odczekuje ilosc ms = y

		in r17, PINB
		cp r16, r17
		brne glowny
		sbrs r16, 7  //jesli nie nacisniety
		dec licznik
		sbrs r16, 3
		inc licznik
		com licznik
		out portC, r18
		com licznik

		rjmp glowny



.org 0x200
delayx:
		delay1ms:	//10 + 4* x - 1ms
				ldi xh, 0x07
				ldi xl, 0x09
		petla:	

				sbiw x, 1 // 2
				brne petla //2
				nop
		sbiw y, 1
		brne delay1ms
	ret 


		