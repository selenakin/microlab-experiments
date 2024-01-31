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

setup 	mov.w #6d, R5 ; N
		mov.w #1d, R6 ; current integer
		mov.w #0d, R7 ; current sum
		INC R5
		push r5
		push r6
		push r7
		call #recsum
		pop r7
finish
		jmp finish
recsum
	pop R10;return address
	pop R7; current sum
	pop R6; current integer
	pop R5; N
	push R10;return address
	cmp R6,R5
	jeq recsum_terminate
	add r6, r7
	inc r6
	push r5
	push r6
	push r7
	call #recsum
	pop r7
recsum_terminate
	pop r10
	push r7
	push R10;return address
	ret



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
            
