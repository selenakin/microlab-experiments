;------------------------------------------------------------------------------
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


init_INT bis.b #00001111b, &P2IE
		 and.b #0BFh, &P2SEL
		 and.b #0BFh, &P2SEL2

		 bis.b #00001111b, &P2IES
		 clr &P2IFG
		 eint

SetupLCD	mov.b #0ffh, &P1DIR
			mov.b #11000000b, &P2DIR
			mov.b #00000000b, &P2SEL
			mov.b #00000000b, &P2SEL2
			clr.b &P1OUT
			clr.b &P2OUT
			clr R14
                        ;implementation of the flow chart in the experiment document.
InitLCD                mov &Delay100ms, R15 ;Wait 100ms
                        call #Delay

                        mov.b #00110000b, &P1OUT ;Send 0011
                        call #TrigEn
                        mov &Delay4ms, R15 ;Wait 4ms
                        call #Delay

                        call #TrigEn ;Send 0011
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        call #TrigEn ;Send 0011
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        mov.b #00100000b, &P1OUT ;Send 0010
                        call #TrigEn
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        ;LCD is now in 4-bit mode, which means we will send our commands nibble by nibble.

                        mov.b #00100000b, &P1OUT ;Send 0010 1000
                        call #TrigEn
                        mov.b #10000000b, &P1OUT
                        call #TrigEn

                        mov &Delay100us, R15 ;Wait 53us+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 1000
                        call #TrigEn
                        mov.b #10000000b, &P1OUT
                        call #TrigEn

                        mov &Delay100us, R15 ;Wait 53us+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 0001
                        call #TrigEn
                        mov.b #00010000b, &P1OUT
                        call #TrigEn

                        mov &Delay4ms, R15 ;Wait 3ms+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 0110
                        call #TrigEn
                        mov.b #01100000b, &P1OUT
                        call #TrigEn
                        mov &Delay100us, R15
                        call #Delay

setup
	clr R5
	mov.b #00001111b, R5
	call #SendCMD
	mov &Delay50us, R15
	call #Delay
	mov.w  #5d, r13
	push r13
	clr r7

MAIN
	cmp #1d, r7
	jeq main_disp
	call #generate_num
	POP R13
	push r13
	jmp MAIN

main_disp
	clr r7
	mov &Delay2ms, R15
	call #Delay
	call #ClrDisp

	mov &Delay2ms, R15
	call #Delay

	call #Home
	mov &Delay2ms, R15
	call #Delay

	push r13
	push r13
	push #100d
	call #division
	pop r13

	add #48d, r13
	mov.b R13, R6
	call #SendData
	mov &Delay2ms, R15
	call #Delay

	pop r13
	push r13
	push r13
	push #100d
	call #modulus
	pop r13

	push r13
	push #10d
	call #division
	pop r13

	add #48d, r13
	mov.b R13, R6
	call #SendData
	mov &Delay2ms, R15
	call #Delay


	pop r13
	push r13
	push #10d
	call #modulus
	pop r13

	add #48d, r13
	mov.b R13, R6
	call #SendData
	mov &Delay2ms, R15
	call #Delay

	jmp MAIN
modulus
	pop R11
	POP R9 ; KUCUK
	POP R10; BUYUK
compare
	cmp R9, R10
	jge cikarma
	jmp modulus_end
cikarma
	sub R9, R10
	jmp compare
modulus_end
	PUSH R10
	PUSH R11
	ret

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

generate_num
	POP R6 ; ret addr
	POP R14 ; param
	push R6 ; retaddr
	PUSH R14 ;param

	push #11d
	push #13d
	call #multiply

	pop R6
	push #2d
	call #power

	push R6
	call #modulus

	POP R14
	POP R6
	PUSH R14
	PUSH R6
	ret
YeniSatir  	clr R5
			mov.b #11000000b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			ret


Fin			mov &Delay100ms, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			mov &Delay100ms, R15
			call #Delay
			jmp InitLCD


TrigEn		bis.b #01000000b, &P2OUT
			bic.b #01000000b, &P2OUT
			ret

SendCMD		mov.b R5, &P1OUT
			call #TrigEn
			rla R5
			rla R5
			rla R5
			rla R5
			mov.b R5, &P1OUT
			call #TrigEn
			ret

SendData	bis.b #10000000b, &P2OUT
			mov.b R6, &P1OUT
			call #TrigEn
			rla R6
			rla R6
			rla R6
			rla R6
			mov.b R6, &P1OUT
			call #TrigEn
			bic.b #10000000b, &P2OUT
			ret

Delay		dec.w R15
			jnz Delay
			ret

ClrDisp mov.b #00000001b, R5
		call #SendCMD
		ret
Home    mov.b #00000011b, R5
		call #SendCMD
		ret
Delay50us	.word	011h
Delay100us	.word 	022h
Delay2ms	.word 	0250h
Delay4ms	.word 	0510h
Delay100ms	.word	07A10h

ISR dint
	mov.w #1d, R7
	clr &P2IFG
	eint
	reti
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

            .sect  ".int03"
            .short ISR
