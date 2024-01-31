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

modulus
	pop R11
	pop r12
	pop r13
MODULUS_LOOP
	cmp R12, R13
	jge cikarma
	push R13
	push R11
	ret
cikarma
	sub R12, R13
	jmp MODULUS_LOOP


division
	mov.w #0d, R10
	POP R11
	POP R13
	POP R12
division_loop
	cmp r13, R12
	jge division_sub
	jmp division_end
division_sub
	INC R10
	sub R13,R12
	jmp division_loop

division_end
	PUSH R10
	PUSH R11
	ret


Bin2BCD ; ÖNCE LSB SONRA MSB
	pop R7; RETURN ADDR
	pop R8; input
	mov R8, R9

	push R8
	push #10d
	call #modulus
	pop R6

	push R8
	push #10d
	call #division
	pop R5

	push R6
	push R5
	push R7
	ret
Main
	push #65d
	call #Bin2BCD
	pop R13
	pop R12

	mov.w #arr, r5

	add R13, R13
	add R12, R12
	add r5, R13
	ADD r5 ,R12

	mov.w #10000010b, &P2OUT
	mov.w 0(R12), &P1OUT

	call #Delay
	mov.w #10000001b, &P2OUT
	mov.w 0(R13), &P1OUT
	call #Delay

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
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
