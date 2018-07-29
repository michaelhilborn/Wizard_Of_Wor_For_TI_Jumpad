; Print.s
; Student names: change this to your names or look very silly
; Last modification date: change this to the last modification date or look very silly
; Runs on LM4F120 or TM4C123
; EE319K lab 7 device driver for any LCD
;
; As part of Lab 7, students need to implement these LCD_OutDec and LCD_OutFix
; This driver assumes two low-level LCD functions
; ST7735_OutChar   outputs a single 8-bit ASCII character
; ST7735_OutString outputs a null-terminated string 

    IMPORT   ST7735_OutChar
    IMPORT   ST7735_OutString
    EXPORT   LCD_OutDec
    EXPORT   LCD_OutFix

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
	PRESERVE8
  
COUNT EQU 0
CURRENT EQU 4
NEXT EQU 8
CONV EQU 12

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutDec

	PUSH{R4-R7, R11, LR}
	SUB SP, #16;
	MOV R11,SP;
	MOV R4,#0;
	STR R4,[R11,#COUNT];
	MOV R4, #0x30
	STR R4,[R11,#CONV]
	STR R0,[R11, #CURRENT];
	MOV R6, #10
	UDIV R0,R0,R6
	STR R0,[R11,#NEXT];
LOOP	
	LDR R4,[R11, #CURRENT];
	LDR R5,[R11, #NEXT];
	MUL R5,R6
	SUB R4,R5;
	LDR R5,[R11,#CONV];
	ADD R4, R5;
	SUB SP,#4
	STRB R4,[SP];
	LDR R4,[R11,#COUNT]
	ADD R4,#1;
	STR R4,[R11,#COUNT];
	
	LDR R4,[R11,#NEXT];
	CMP R4, #0;
	BEQ DONE
	LDR R4,[R11,#NEXT];
	STR R4,[R11,#CURRENT];
	UDIV R4, R6
	STR R4,[R11,#NEXT];
	B LOOP;
DONE

OUTLOOP
	LDR R4,[R11,#COUNT];
	CMP R4,#0;
	BEQ FINISH;
	LDRB R0,[SP];
	ADD SP,#4;
	BL ST7735_OutChar;
	SUB R4,#1;
	STR R4,[R11,#COUNT]
	B OUTLOOP
FINISH
	MOV SP, R11;
	ADD SP,#16
	POP{R4-R7, R11, LR};
	

      BX  LR
;* * * * * * * * End of LCD_OutDec * * * * * * * *

; -----------------------LCD _OutFix----------------------
; Output characters to LCD display in fixed-point format
; unsigned decimal, resolution 0.001, range 0.000 to 9.999
; Inputs:  R0 is an unsigned 32-bit number
; Outputs: none
; E.g., R0=0,    then output "0.000 "
;       R0=3,    then output "0.003 "
;       R0=89,   then output "0.089 "
;       R0=123,  then output "0.123 "
;       R0=9999, then output "9.999 "
;       R0>9999, then output "*.*** "
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutFix

	PUSH{R4-R7, R11, LR}
	SUB SP, #16;
	MOV R11,SP;
	MOV R4,#0;
	STR R4,[R11,#COUNT];
	MOV R4, #0x30
	STR R4,[R11,#CONV];
	STR R0,[R11, #CURRENT];
	MOV R6, #10
	UDIV R0,R0,R6
	STR R0,[R11,#NEXT];
FIXLOOP	
	LDR R4,[R11, #CURRENT];
	LDR R5,[R11, #NEXT];
	MUL R5,R6
	SUB R4,R5;
	LDR R5,[R11,#CONV];
	ADD R4, R5;
	SUB SP,#4
	STRB R4,[SP];
	LDR R4,[R11,#COUNT]
	ADD R4,#1;
	STR R4,[R11,#COUNT];
	
	LDR R4,[R11,#NEXT];
	CMP R4, #0;
	BEQ FIXDONE
	LDR R4,[R11,#NEXT];
	STR R4,[R11,#CURRENT];
	UDIV R4, R6
	STR R4,[R11,#NEXT];
	B FIXLOOP;
FIXDONE

	LDR R4,[R11,#COUNT];
	CMP R4, #4;
	BGE FIXOUTLOOP;
	MOV R4, #0x30
	SUB SP,#4
	STRB R4,[SP];
	LDR R4,[R11,#COUNT]
	ADD R4,#1;
	STR R4,[R11,#COUNT];
	B FIXDONE;
	
FIXOUTLOOP
	LDR R4,[R11,#COUNT];
	CMP R4,#5;
	BGE FIXOVER;
	CMP R4,#0;
	BEQ FIXFINISH;
	CMP R4,#3;
	BEQ DECIMAL;
FIXOUTLOOP2
	LDRB R0,[SP];
	ADD SP,#4;
	BL ST7735_OutChar;
	SUB R4,#1;
	STR R4,[R11,#COUNT]
	B FIXOUTLOOP
	
DECIMAL
	MOV R0,#0x2E;
	BL ST7735_OutChar;
	B FIXOUTLOOP2;
FIXOVER
	MOV R5, #4;
	MUL R4,R5;
	ADD SP, R4;
	MOV R0,#0x2A;
	BL ST7735_OutChar;
	MOV R0, #0x2E
	BL ST7735_OutChar;
	MOV R0,#0x2A;
	BL ST7735_OutChar;
	MOV R0,#0x2A;
	BL ST7735_OutChar;
	MOV R0,#0x2A;
	BL ST7735_OutChar;
FIXFINISH
	ADD SP,#16
	POP{R4-R7, R11, LR};
     BX   LR

     BX   LR
 
     ALIGN
;* * * * * * * * End of LCD_OutFix * * * * * * * *

     ALIGN                           ; make sure the end of this section is aligned
     END                             ; end of file