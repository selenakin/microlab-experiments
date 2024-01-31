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
Setup mov.b #00000000b,&P1DIR
	  mov.b #00000000b,&P2DIR
	  mov.b #0d, R6
	  mov.b #0d, R7
INLOOP bit.b #00001000b,&P1IN
	   jnz btn1
       bit.b #00001000b,&P2IN
       jnz btn2
       bit.b #00000100b,&P2IN
       jnz btn3
       jmp INLOOP
btn1  inc R6
      jmp L2
btn2 inc R7
	jmp L2
btn3 mov.b #0d, R6
	 mov.b #0d, R7
L2	mov.w #07700000, R15
L1   dec.w R15
	jnz L1
    bit.b #00001000b,&P1IN
	jnz L2
	bit.b #00001000b,&P2IN
	jnz L2
	jmp INLOOP


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
