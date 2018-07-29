//Put Input functions here

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
void EnableInterrupts(void);  // Enable interrupts

void GameInput_Init(){
	SYSCTL_RCGCGPIO_R |= 0x00000004; // (a) activate port C
	while((SYSCTL_RCGCGPIO_R & 0x00000004) != 0x04){}// (b) initialize counter
  GPIO_PORTC_DIR_R &= ~0x30;    // (c) make PC4 in 
  GPIO_PORTC_DEN_R |= 0x30;     //     enable digital I/O on PC4
  GPIO_PORTC_IS_R &= ~0x30;     // (d) PC4 is edge-sensitive 
  GPIO_PORTC_IBE_R |= 0x30;    //     PC4 is not both edges 
  GPIO_PORTC_ICR_R = 0x30;      // (e) clear flag4
  GPIO_PORTC_IM_R |= 0x30;      // (f) arm interrupt on PC4
  NVIC_PRI0_R = (NVIC_PRI0_R&0xFF00FFFF)|0x00A00000; // (g) priority 5
  NVIC_EN0_R |= 4;              // (h) enable interrupt 2 in NVIC
  EnableInterrupts();           // (i) Program 5.3
	uint32_t volatile delay=0;
	SYSCTL_RCGCGPIO_R |= 0x20;
	delay=100;
	GPIO_PORTF_DEN_R |= 0x14;
	GPIO_PORTF_DIR_R |= 0x04;
	GPIO_PORTF_DIR_R &= 0xEF;
	GPIO_PORTF_PUR_R |= 0x10;
	
}



