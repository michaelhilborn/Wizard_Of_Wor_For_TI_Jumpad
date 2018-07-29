// ADC.c
// Runs on LM4F120/TM4C123
// Provide functions that initialize ADC0
// Last Modified: 3/28/2018 
// Student names: Michael Hilborn and Chris E.
// Last modification date: change this to the last modification date or look very silly

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"

// ADC initialization function 
// Input: none
// Output: none
// measures from PD2, analog channel 5
// ADC initialization function 
// Input: none
// Output: none
// measures from PD2, analog channel 5
uint32_t delay;
void ADC_Init(void){ 

	SYSCTL_RCGCGPIO_R |= 0x00000008;   // 1) activate clock for Port D

  while((SYSCTL_RCGCGPIO_R&0x08)==0){} // Allow clock to stabalize

  GPIO_PORTD_DIR_R &= ~0x04;      // 2) make PD2 input

  GPIO_PORTD_AFSEL_R |= 0x04;     // 3) enable alternate function on PD2

  GPIO_PORTD_DEN_R &= ~0x04;      // 4) disable digital I/O on PD2

  GPIO_PORTD_AMSEL_R |= 0x04;     // 5) enable analog function on PD2

  SYSCTL_RCGCADC_R |= 0x01;				// 6) Activate ADC0
		
	while((SYSCTL_RCGCADC_R&0x01)==0){} //delay to let it stabalize
		
	delay = 1000;
		
	ADC0_PC_R = 0X01;								// 7)	configure for 125K

  ADC0_SSPRI_R = 0x0123;          // 8) Sequencer 3 is highest priority

  ADC0_ACTSS_R &= ~0x0008;        // 9) disable sample sequencer 3

  ADC0_EMUX_R &= ~0xF000;         // 10) seq3 is software trigger

  ADC0_SSMUX3_R &= ~0x000F;       // 11) clear SS3 field

  ADC0_SSMUX3_R += 5;             //    set channel Ain5 (PD2)

  ADC0_SSCTL3_R = 0x0006;         // 12) no TS0 D0, yes IE0 END0

  ADC0_ACTSS_R |= 0x0008;         // 13) enable sample sequencer 3

}

//------------ADC_In------------
// Busy-wait Analog to digital conversion
// Input: none
// Output: 12-bit result of ADC conversion
// measures from PD2, analog channel 5
uint32_t ADC_In(void){  
	uint32_t result=0;							 // Create return variable
	
	ADC0_PSSI_R = 0x0008;            // 1) initiate SS3

  while((ADC0_RIS_R&0x08)==0){};   // 2) wait for conversion done

  result = ADC0_SSFIFO3_R&0xFFF;   // 3) read result

  ADC0_ISC_R = 0x0008;             // 4) acknowledge completion

  return result;
  
}
