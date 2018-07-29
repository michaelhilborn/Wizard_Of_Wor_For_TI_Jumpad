// Sound.h
// Runs on TM4C123 or LM4F120
// Prototypes for basic functions to play sounds from the
// original Space Invaders.
// Jonathan Valvano
// November 17, 2014

#include <stdint.h>

void Sound_Init(void);
void Sound_Play(uint32_t count);
void Sound_Shoot(void);
void Sound_IceShoot(void);
void Sound_Fireball(void);
void Sound_Groan(void);
void Sound_Punch(void);
void Sound_Death(void);
void Sound_Intro(void);
