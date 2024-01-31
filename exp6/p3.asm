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
	  mov.w #0000000000010010b, &TA0CTL
	  mov.w #0000000000010000b, &TA0CCTL0
	  mov.w #10486d, &TA0CCR0
	  jmp Main

TISR
	clr &TAIFG
	eint
	reti

Main
	jmp Main

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
             .data
arr .word 00111111b, 00000110b, 01011011b, 01001111b,01100110b, 01101101b, 01111100b, 00000111b, 01111111b, 01100111b
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect "int09"
            .short TISR
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET


            
