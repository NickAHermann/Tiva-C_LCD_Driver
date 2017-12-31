// IO.c
// This software configures the switch and LED
// You are allowed to use any switch and any LED, 
// although the Lab suggests the SW1 switch PF4 and Red LED PF1
// Runs on LM4F120 or TM4C123
// Program written by: put your names here
// Date Created: 
// Last Modified:  
// Lab number: 6


#include "tm4c123gh6pm.h"
#include <stdint.h>
#include "ST7735.h"
#define  PF4 (*((volatile uint32_t *) 0x40025040))

//------------IO_Init------------
// Initialize GPIO Port for a switch and an LED
// Input: none
// Output: none
void IO_Init(void) {
 
	SYSCTL_RCGCGPIO_R |= 0x00000020;
	while((SYSCTL_PRGPIO_R & 0x00000020) == 0){};
	GPIO_PORTF_LOCK_R = 0x4C4F434B;
	GPIO_PORTF_CR_R= 0x14;
	GPIO_PORTF_DIR_R = 0x04;
	GPIO_PORTF_AFSEL_R &= ~(0x14);
	GPIO_PORTF_PUR_R = 0x10;
	GPIO_PORTF_DEN_R = 0x14;
	
}

//------------IO_HeartBeat------------
// Toggle the output state of the  LED.
// Input: none
// Output: none
void IO_HeartBeat(void) {
 
	GPIO_PORTF_DATA_R ^= 0x04; // heartbeat toggle [PF2]
}


//------------IO_Touch------------
// wait for release and press of the switch
// Delay to debounce the switch
// Input: none
// Output: none
void IO_Touch(void) {
	uint32_t delay = 62;
 
	while(PF4 == 0x00){};
	Delay1ms(delay);
	
	while(PF4 == 0x04){};
	Delay1ms(delay);
	
}  

