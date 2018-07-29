//Put Input functions here

#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
void SysTick_Init(void){
	NVIC_ST_CTRL_R = 0;
	NVIC_SYS_PRI3_R=(NVIC_SYS_PRI3_R&0x00FFFFFF)|0x40000000;
	NVIC_ST_RELOAD_R = 0xFFFFFFFF;
	NVIC_ST_CTRL_R = 0x00000007;
		NVIC_ST_CURRENT_R = 0;
	
}
// The delay parameter is in units of the 80 MHz core clock. (12.5 ns)
// Time delay using busy wait.
// waits for count*10ms
// 10000us equals 10ms

void Speed_Up(uint32_t reload){
	
	NVIC_ST_CTRL_R = 0;
	NVIC_SYS_PRI3_R=(NVIC_SYS_PRI3_R&0x00FFFFFF)|0x40000000;
	NVIC_ST_RELOAD_R = reload;
	NVIC_ST_CTRL_R = 0x00000007;
		NVIC_ST_CURRENT_R = 0;
	
}
