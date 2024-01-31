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

setup:
	mov.w #arr, R7 ;arr pointer
	mov.w #1d, R6
	mov.w #0d, R5

populate:
	cmp #50d, R5
	jeq end


	mov.w R6, R8
	mov.w #3d, R9
	call #modulus

	cmp #0, R10
	jeq insert

	mov.w R6, R8
	mov.w #4d, R9
	call #modulus
	cmp #0, R10
	jeq insert

	inc R6
	jmp populate

insert:
	mov.w R6, 0(R7)
	inc R7
	inc R7
	inc R6
	inc R5
	jmp populate

;R8 R9'a bölünüyor mu
modulus:
	mov.w R8, R10
compare:
	cmp R9, R10
	jge cikarma
	jmp modulus_end
cikarma:
	sub R9, R10
	jmp compare
modulus_end:
	ret
end:
	jmp end


		.data
arr  .space 100
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
            


