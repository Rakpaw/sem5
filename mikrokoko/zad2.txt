;
; zad2.asm
; Author : pawel rakoczy
;

.def pobranaLiczba = r25
.def zero = r24
.def wartoscHIGH = r23
.def wartoscLOW = r22
.cseg
.org 0
	jmp start

.org 0x46
tab: .db 123, 246, 153, 80, 120, 33, 145, 24, 120, 65, 50, 76, 180, 97, 175, 28, 160, 59, 154, 10, 142, 11, 131, 12, 83, 230, 198, 43, 7,90

start:
		ldi r16, low(RAMEND)
		out spl, r16
		ldi r16, high(RAMEND)
		out sph, r16

		ldi zl, low(tab<<1)
		ldi zh,high(tab<<1)

		ldi r17, 0
		out ddrb, r17
		com r17
		out ddrc, r17
		out portc, r17

		ldi zero, 0

petla: 
		in r16, pinB
		mov r18, r16
		ori r16, 0b10000000
		andi r18, 0b10000000
		com r16
		breq nic							//czytanie przycisku
		cpi r16, 0b00010000
		brcc nic

		call pobranieZTablicy
		sbrs r18, 7				//jezeli 7 nie jest nacisniety
		out PORTC, wartoscLOW   //jezeli nacisniety 7 to sie wywola
		sbrs r18, 7
		rjmp petla
		out PORTC, wartoscHIGH
		rjmp petla


nic:
		out PORTC, r17
		rjmp petla


.org 0x200
pobranieZTablicy: //r16 - ktora liczba
		dec r16
		lsl r16

		add zl, r16
		adc zh, zero
		lpm wartoscHIGH, z+					//pobieranie z tablicy
		lpm wartoscLOW, z
		sbiw z, 1
		sub zl, r16
		sbc zh, zero

		ret