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

setup mov.w #5d, R6
	  mov.w #2d, R7

	  PUSH R6
	  PUSH R7
	  call #division
	  POP R8; CEVAP R8E DONUYOR
finish jmp finish
multiply
	mov.w #0d, R8
	POP R10
	POP R5
	POP R4
multiply_loop
	cmp #0d, R5
	jeq multiply_end
	dec R5
	add R4, R8
	jmp multiply_loop
multiply_end
	PUSH R8
	PUSH R10
	ret

division
	mov.w #0d, R8
	POP R10
	POP R5
	POP R4
division_loop
	cmp r5, R4
	jge division_sub
	jmp division_end
division_sub
	INC R8
	sub R5,R4
	jmp division_loop

division_end
	PUSH R8
	PUSH R10
	ret

power
	pop R11
	POP R5
	POP R4
	mov.w R4, R12
power_loop
	cmp #0d, R5
	jeq power_end
	dec R5
	PUSH R4
	PUSH R12
	call #multiply
	POP R12
	jmp power_loop
power_end
	PUSH R12
	PUSH R11
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
            
