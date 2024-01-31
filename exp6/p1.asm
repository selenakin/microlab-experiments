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
		jmp Main
Delay mov.w #0Ah, R14
L2    mov.w #07Ah, R15
L1 		dec.w R15
		jnz L1
		dec.w R14
		jnz L2
		ret
Main
	 mov.b #10000001b, &P2OUT
	 mov.b #00111111b, &P1OUT
	 call #Delay
	 mov.b #00000010b, &P2OUT
	 mov.b #00000110b, &P1OUT
	 call #Delay
	 mov.b #00000100b, &P2OUT
	 mov.b #01011011b, &P1OUT
	 call #Delay
	 mov.b #00001000b, &P2OUT
	 mov.b #01001111b, &P1OUT
	 call #Delay
	 jmp Main

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
            .data
;arr .word 00111111b, 00000110b, 01011011b, 01001111b
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
