//
/*
 * zad1C.c
 * Author : Pawe³ Rakoczy
 */ 

#define F_CPU 7200000UL

#include <avr/io.h>
#include <util/delay.h>

int main(void) {

	DDRC |= (1 << PC7) | (1 << PC4);
	PORTC = (1 << PC7);

	while (1) {
		PORTC ^= (1 << PC7) | (1 << PC4);
		//_delay_ms(1000);
	}

	return 0;
}