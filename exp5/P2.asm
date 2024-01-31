;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
			mov.b	#0d, P2SEL


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

Setup mov.b #11111111b,&P2DIR
		mov.b #11111111b,&P1DIR
		mov.b #10000001b, &P2OUT
		mov.w #achilleus, R5
		mov.w #0d, R6
		jmp Main
Delay mov.w #0Ah, R14
L2    mov.w #07A00h, R15
L1 		dec.w R15
		jnz L1
		dec.w R14
		jnz L2
		ret
Main mov.w 0(R5), &P1OUT
	 inc R6
	 inc R5
	 inc R5
	 call #Delay
	 cmp #9d,R6
	 jeq Setup
	 jmp Main

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
            .data
arr .word 00111111b, 00000110b, 01011011b, 01001111b,01100110b, 01101101b, 01111100b, 00000111b, 01111111b, 01100111b
achilleus .word 01110111b, 00111001b, 01110110b, 00000110b, 00111000b, 00111000b, 01111001b, 00111110b, 01101101b
;					A       c         h				i		l			l				e		U		s
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
