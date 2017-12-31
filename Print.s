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

  

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutDec
;Binding: creates offset for SP 
x 		EQU 	4
;Allocate the stack for local variable
		SUB 	SP, #8
		MOV     R12, SP
		MOV		R3, #0
;Store local variable to the stack
    	MOV		R2, #10
		STR     R2, [R12,#x]
		
loop1	MOV		R1, R0
		LDR     R2, [R12,#x]
		UDIV	R0, R2
		MUL		R2, R0, R2
		SUBS	R2, R1, R2
		PUSH	{R2,R4}
		ADD		R3, #1
		CMP		R0, #0
		BNE		loop1
		
loop2	POP	{R0,R4}
		ADD		R0, #0x30
		PUSH	{LR,R3}
		BL		ST7735_OutChar
		POP	{LR,R3}
		SUBS	R3, #1
		BNE		loop2
		ADD     SP, #8
		BX  	LR
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
		MOV	R1, #9999
		CMP	R0, R1
;Branches to Print *.*** if higher that 9999
		BHI	OVER
		MOV	R1,#1000
		MOV	R2,R0; input in R2
		UDIV	R0,R1; R0= R0/1000
		MUL	R1,R0; R1= 1000*R0
		SUBS	R2,R1; R2=LAST THREE DIGITS
		ADD	R0, #0x30
		PUSH	{LR,R2}
;Prints first digit and "."
		BL	ST7735_OutChar
		MOV	R0, #0x2E
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R1, #100
		UDIV	R0, R2, R1; R0=R2/100
		MUL	R1,R0; R1= 100*R0
		SUBS	R2,R1;R2=LAST TWO DIGITS
		ADD	R0, #0x30
;Prints second digit
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R1, #10
		UDIV	R0, R2, R1; R0=R2/10
		MUL	R1,R0; R1= 10*R0
		SUBS	R2,R1;R2= LAST DIGIT
		ADD	R0, #0x30
;Prints third digit
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R0,R2
		ADD	R0, #0x30
;Prints fourth/last digit
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		BX   	LR
;Prints *.*** to the display
OVER		MOV	R0, #0x2A
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R0, #0x2E
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R0, #0x2A
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R0, #0x2A
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		MOV	R0, #0x2A
		PUSH	{LR,R2}
		BL	ST7735_OutChar
		POP	{LR,R2}
		BX	LR
		ALIGN

;* * * * * * * * End of LCD_OutFix * * * * * * * *

     ALIGN                           ; make sure the end of this section is aligned
     END                             ; end of file
