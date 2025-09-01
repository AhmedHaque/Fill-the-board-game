	.data

	.global prompt
	.global mydata

prompt:	.string "Your prompt with instructions is place here", 0
direction: .byte 0x01 ; 1 is up, 2 is down, 3 is left, 4 is right
end_game_flag: .byte 0x00
index_i: .byte 0x0A
index_j: .byte 0x0A
tiva_flag: .byte 0x00
clear_screen_str: .string 0xC, 0
decrement_time: .word 0x00082208
reset_time:	.word 0x00082208
score: .word 0x00000000
score_num_str: .string "          "
score_string1: .string "       Score:", 0
score_string2: .string "        ", 0xA, 0xD, 0
line0:	.string "--------------------", 0xA, 0xD, 0
line1:	.string "|                    |", 0xA, 0xD, 0
line2:	.string "|                    |", 0xA, 0xD, 0
line3:	.string "|                    |", 0xA, 0xD, 0
line4:	.string "|                    |", 0xA, 0xD, 0
line5:	.string "|                    |", 0xA, 0xD, 0
line6:	.string "|                    |", 0xA, 0xD, 0
line7:	.string "|                    |", 0xA, 0xD, 0
line8:	.string "|                    |", 0xA, 0xD, 0
line9:	.string "|                    |", 0xA, 0xD, 0
line10:	.string "|         X          |", 0xA, 0xD, 0
line11:	.string "|                    |", 0xA, 0xD, 0
line12:	.string "|                    |", 0xA, 0xD, 0
line13:	.string "|                    |", 0xA, 0xD, 0
line14:	.string "|                    |", 0xA, 0xD, 0
line15:	.string "|                    |", 0xA, 0xD, 0
line16:	.string "|                    |", 0xA, 0xD, 0
line17:	.string "|                    |", 0xA, 0xD, 0
line18:	.string "|                    |", 0xA, 0xD, 0
line19:	.string "|                    |", 0xA, 0xD, 0
line20:	.string "|                    |", 0xA, 0xD, 0
line21:	.string "--------------------", 0xA, 0xD,0
fail_message: .string "YOU FAILED, GET GOOD IDIOT!!!!", 0

mydata:	.byte	0x20	; This is where you can store data.
			; The .byte assembler directive stores a byte
			; (initialized to 0x20 in this case) at the label
			; mydata.  Halfwords & Words can be stored using the
			; directives .half & .word



	.text

	.global uart_interrupt_init
	.global gpio_interrupt_init
	.global gpio_btn_and_LED_init
	.global UART0_Handler
	.global Switch_Handler
	.global Timer_Handler		; This is needed for Lab #6
	.global simple_read_character	; read_character modified for interrupts
	.global output_character	; This is from your Lab #4 Library
	.global read_string		; This is from your Lab #4 Library
	.global output_string		; This is from your Lab #4 Library
	.global uart_init		; This is from your Lab #4 Library
	.global int2string
	.global lab6
	.global score
	.global ptr_to_score
	.global ptr_to_score_num_str

ptr_to_decrement_time:	.word decrement_time
ptr_to_reset_time:	.word reset_time
ptr_to_prompt:		.word prompt
ptr_to_mydata:		.word mydata
ptr_to_direction:      .word direction
ptr_to_index_i:        .word index_i
ptr_to_index_j:        .word index_j
ptr_to_tiva_flag:      .word tiva_flag
ptr_to_score:          .word score
ptr_to_score_num_str:  .word score_num_str
ptr_to_score_string1:   .word score_string1
ptr_to_score_string2:  .word score_string2
ptr_to_clear_screen_str: .word clear_screen_str
ptr_to_line0:         .word line0
ptr_to_line1:         .word line1
ptr_to_line2:         .word line2
ptr_to_line3:         .word line3
ptr_to_line4:         .word line4
ptr_to_line5:         .word line5
ptr_to_line6:         .word line6
ptr_to_line7:         .word line7
ptr_to_line8:         .word line8
ptr_to_line9:         .word line9
ptr_to_line10:        .word line10
ptr_to_line11:        .word line11
ptr_to_line12:        .word line12
ptr_to_line13:        .word line13
ptr_to_line14:        .word line14
ptr_to_line15:        .word line15
ptr_to_line16:        .word line16
ptr_to_line17:        .word line17
ptr_to_line18:        .word line18
ptr_to_line19:        .word line19
ptr_to_line20:        .word line20
ptr_to_line21:        .word line21
ptr_to_fail_message:	.word fail_message
ptr_to_end_game_flag:	.word end_game_flag


lab6:				; This is your main routine which is called from
				; your C wrapper.
	PUSH {r4-r12,lr}   	; Preserve registers to adhere to the AAPCS
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_mydata

 	bl uart_init
 	bl gpio_btn_and_LED_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	bl timer_interrupt_init

	; This is where you should implement a loop, waiting for the user to
	; indicate if they want to end the program.
lab6_loop:
	LDR r7, ptr_to_end_game_flag
	LDRB r8, [r7]
	CMP r8, #0
	BEQ lab6_loop


	POP {r4-r12,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr



uart_interrupt_init:

	; Your code to initialize the UART0 interrupt goes here
	PUSH {r4-r12, lr}
	MOV r0,#0xC000
	MOVT r0, #0x4000

	;Setting the Receive Interrupt Mask in bit position 4 in the UART Interrupt Mask Register
	LDRB r1, [r0, #0x038]
	ORR r1, r1, #0x10
	STRB r1, [r0, #0x038]

	MOV r0,#0xE000
	MOVT r0, #0xE000

	; Setting bit 5 in the processor to allow UART interrupt
	LDR r1, [r0, #0x100]
	ORR r1, r1, #0x20
	STR r1, [r0, #0x100]


	POP {r4-r12, lr}
	MOV pc, lr


gpio_interrupt_init:

	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.
	PUSH {r4-r12, lr}
	MOV r0, #0x5000
	MOVT r0, #0x4002 ; Port F address

	;If we want to enable Level Sensitivity we set bit 4 to 1
	;To enable Edge Sensitivity in SW1 we set bit 4 to 0
	LDRB r1, [r0, #0x404]
	BIC r1, r1, #0x10
	STRB r1, [r0, #0x404]

	;If we want to enable both Edges Trigger we set bit 4 to 1
	;To enable GPIO Interrupt Event in SW1 we set bit 4 to 0
	LDRB r1, [r0, #0x408]
	BIC r1, r1, #0x10
	STRB r1, [r0, #0x408]

	;To set high(rising edge) we set bit 4 to 1 (button release)
	;To set low(falling edge) we set bit 4 to 0 (Button Press)
	LDRB r1, [r0, #0x40C]
	BIC r1, r1, #0x10
	STRB r1, [r0, #0x40C]

	;To enable interrupt we set bit 4 to 1
	;To disable interrupt we set bit 4 to 0
	LDRB r1, [r0, #0x410]
	ORR r1, r1, #0x10
	STRB r1, [r0, #0x410]

	MOV r0,#0xE000
	MOVT r0, #0xE000

	; Setting bit 5 in the processor to allow GPIO Port F interrupt
	LDR r1, [r0, #0x100]
	MOV r2, #0x0000
	MOVT r2, #0x4000
	ORR r1, r1, r2
	STR r1, [r0, #0x100]

	POP {r4-r12, lr}
	MOV pc, lr


UART0_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r12, lr}
	MOV r0, #0xC000
	MOVT r0, #0x4000

	LDRB r1, [r0, #0x044] ;To clear interupt
	ORR r1, #0x10
	STRB r1, [r0, #0x044]

	; 1 is up, 2 is down, 3 is left, 4 is right
	BL simple_read_character

	ldr r6, ptr_to_direction
	LDRB r1, [r6]

	;w 
	CMP r0, #0x77
	BEQ uart_w
	
	;a 
	CMP r0, #0x61
	BEQ uart_a

	;s
	CMP r0, #0x73
	BEQ uart_s

	;d
	CMP r0, #0x64
	BEQ uart_d


uart_w:
	;1 is up
	MOV r1, #1
	B end_uart_handler
uart_s:
	;2 is down
	MOV r1, #2
	B end_uart_handler
uart_a:
	;3 is left
	MOV r1, #3
	B end_uart_handler
uart_d:
	;4 is right
	MOV r1, #4
	B end_uart_handler


end_uart_handler:
	ldr r6, ptr_to_direction
	STRB r1, [r6]

	POP {r4-r12, lr}
	BX lr       	; Return


Switch_Handler:

	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler
	PUSH {r4-r12}
	MOV r0, #0x5000
	MOVT r0, #0x4002

	LDRB r1, [r0, #0x41C]
	ORR r1, #0x10
	STRB r1, [r0, #0x41C]

	ldr r6, ptr_to_tiva_flag
	LDRB r0, [r6]

	EOR r0, r0, #1
	STRB r0, [r6]

	POP {r4-r12}
	BX lr       	; Return


Timer_Handler:

	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.
	PUSH {r4-r12, lr}
	MOV r0, #0x0000
	MOVT r0, #0x4003

	LDRB r1, [r0, #0x024]
	ORR r1, r1, #0x1
	STRB r1, [r0, #0x024]

	;check if tiva was pressed
	ldr r6, ptr_to_tiva_flag
	LDRB r9, [r6]
	CMP r9, #1
	BEQ Timer_Handler_end


	BL compute_i_j
	
	BL get_char_at_i_j ;returns char in r0
	
	;if char == 'X' or char == '-' or char == '|':
	;	print fail and exit

	;if char == 'X':
	CMP r0, #0x58 ;0x58 is X
	BEQ Timer_Handler_fail

	;if char == '-':
	CMP r0, #0x2D ;0x2D is -
	BEQ Timer_Handler_fail

	;if char == '|':
	CMP r0, #0x7C ;0x7C is |
	BEQ Timer_Handler_fail
	


	;else if byte == ' ':
	;	place an X at [i][j]
	;	Incrememnt the score
	;	print again

	;if char == ' ':
	CMP r0, #0x20 ;0x20 is ' '
	BEQ Timer_Handler_good


Timer_Handler_fail:
	LDR r0, ptr_to_fail_message
	BL output_string

	LDR r7, ptr_to_end_game_flag
	MOV r8, #1
	STRB r8, [r7]

	B Timer_Handler_end

Timer_Handler_good:
	;increment score
	ldr r6, ptr_to_score
	LDR r1, [r6]
	ADD r1, r1, #1
	STR r1, [r6]

	BL place_X_at_i_j

	BL print_game

Timer_Handler_end:
	POP {r4-r12, lr}
	BX lr       	; Return


Timer_Handler2:
	PUSH {r4-r12, lr}


	POP {r4-r12, lr}
	BX lr

timer_interrupt_init:
	PUSH {r4-r12, lr}

	; --------------------------
    ; TIMER0 Configuration
    ; --------------------------
	MOV r0, #0xE000
	MOVT r0, #0x400F

	LDRB r1, [r0, #0x604]
	ORR r1, r1, #0x3
	STRB r1, [r0, #0x604]

	MOV r0, #0x0000
	MOVT r0, #0x4003

	LDRB r1, [r0, #0x00C]
	BIC r1, r1, #0x1
	STRB r1, [r0, #0x00C]

	LDRH r1, [r0, #0x000]
	MOV r5, #0x111
	BIC r1, r1, r5
	STRH r1, [r0, #0x000]

	LDRB r1, [r0, #0x004]
	ORR r1, r1, #0x2
	STRB r1, [r0, #0x004]

	LDRB r1, [r0, #0x004]
	ORR r1, r1, #0x2
	STRB r1, [r0, #0x004]

	MOV r1, #0x1200
	MOVT r1, #0x007A
	STR r1, [r0, #0x028]

	LDRB r1, [r0, #0x018]
	ORR r1, r1, #0x1
	STRB r1, [r0, #0x018]

	MOV r0, #0xE000
	MOVT r0, #0xE000

	LDR r1, [r0, #0x100]
	MOV r2, #0x0000
	MOVT r2, #0x0008
	ORR r1, r1, r2
	STR r1, [r0, #0x100]

	MOV r0, #0x0000
	MOVT r0, #0x4003

	LDRB r1, [r0, #0x00C]
	ORR r1, r1, #0x1
	STRB r1, [r0, #0x00C]

	; --------------------------
    ; TIMER1 Configuration
    ; --------------------------
    MOV r0, #0x1000
    MOVT r0, #0x4003               ; r0 = 0x40031000 (TIMER1 base)

    ; Disable TIMER1A
    LDRB r1, [r0, #0x00C]
    BIC r1, r1, #0x1
    STRB r1, [r0, #0x00C]

    ; Configure TIMER1A as 32-bit periodic
    LDRH r1, [r0, #0x000]
    MOV r5, #0x111
    BIC r1, r1, r5
    STRH r1, [r0, #0x000]

    LDRB r1, [r0, #0x004]
    ORR r1, r1, #0x2
    STRB r1, [r0, #0x004]

    ; Load interval for TIMER1
    MOV r1, #0x2400
    MOVT r1, #0x00FA               ; Interval value = 0x00FA2400
    STR r1, [r0, #0x028]

    ; Enable interrupt for TIMER1A
    LDRB r1, [r0, #0x018]
    ORR r1, r1, #0x1
    STRB r1, [r0, #0x018]

    ; Enable TIMER1 interrupt in NVIC
    MOV r0, #0xE000
    MOVT r0, #0xE000
    LDR r1, [r0, #0x100]
    MOV r2, #(1 << 21)            ; IRQ21 for TIMER1A
    ORR r1, r1, r2
    STR r1, [r0, #0x100]

    ; Enable TIMER1A
    MOV r0, #0x1000
    MOVT r0, #0x4003
    LDRB r1, [r0, #0x00C]
    ORR r1, r1, #0x1
    STRB r1, [r0, #0x00C]

	POP {r4-r12, lr}
	MOV pc, lr

compute_i_j:
	; 1 is up, 2 is down, 3 is left, 4 is right
	;computes new index based on direction flag
	PUSH {r4-r12,lr}
	ldr r6, ptr_to_direction
	LDRB r0, [r6]


	ldr r6, ptr_to_index_i
	LDRB r1, [r6]

	ldr r6, ptr_to_index_j
	LDRB r2, [r6]

	;1 is up
	CMP r0, #1
	BEQ compute_i_j_up

	;2 is down
	CMP r0, #2
	BEQ compute_i_j_down

	;3 is left
	CMP r0, #3
	BEQ compute_i_j_left

	;4 is right
	CMP r0, #4
	BEQ compute_i_j_right
	B end_compute_i_j

compute_i_j_up:
	;up means decrement i
	SUB r1, r1, #1
	ldr r6, ptr_to_index_i
	STRB r1, [r6]
	B end_compute_i_j

compute_i_j_down:
	;down means increment i
	ADD r1, r1, #1
	ldr r6, ptr_to_index_i
	STRB r1, [r6]
	B end_compute_i_j

compute_i_j_left:
	;left means decrement j
	SUB r2, r2, #1
	ldr r6, ptr_to_index_j
	STRB r2, [r6]
	B end_compute_i_j

compute_i_j_right:
	;right means increment j
	ADD r2, r2, #1
	ldr r6, ptr_to_index_j
	STRB r2, [r6]
	B end_compute_i_j

end_compute_i_j:
	POP {r4-r12, lr}
	MOV pc, lr

print_game:
	PUSH {r4-r12,lr}

	;clear terminal
	ldr r0, ptr_to_clear_screen_str
	BL output_string

	;print first part of score
	ldr r0, ptr_to_score_string1
	BL output_string

	;Print score number
		;load score byte
	ldr r6, ptr_to_score
	LDR r5, [r6]
	MOV r1, r5
	ldr r0, ptr_to_score_num_str
		;do int2string
	BL int2string
		;now output
	BL output_string

	;print second part of score
	ldr r0, ptr_to_score_string2
	BL output_string


	;print game map
    ldr r0, ptr_to_line0
    BL output_string

    ldr r0, ptr_to_line1
    BL output_string

    ldr r0, ptr_to_line2
    BL output_string

    ldr r0, ptr_to_line3
    BL output_string

    ldr r0, ptr_to_line4
    BL output_string

    ldr r0, ptr_to_line5
    BL output_string

    ldr r0, ptr_to_line6
    BL output_string

    ldr r0, ptr_to_line7
    BL output_string

    ldr r0, ptr_to_line8
    BL output_string

    ldr r0, ptr_to_line9
    BL output_string

    ldr r0, ptr_to_line10
    BL output_string

    ldr r0, ptr_to_line11
    BL output_string

    ldr r0, ptr_to_line12
    BL output_string

    ldr r0, ptr_to_line13
    BL output_string

    ldr r0, ptr_to_line14
    BL output_string

    ldr r0, ptr_to_line15
    BL output_string

    ldr r0, ptr_to_line16
    BL output_string

    ldr r0, ptr_to_line17
    BL output_string

    ldr r0, ptr_to_line18
    BL output_string

    ldr r0, ptr_to_line19
    BL output_string

    ldr r0, ptr_to_line20
    BL output_string

    ldr r0, ptr_to_line21
    BL output_string
	POP {r4-r12, lr}
	MOV pc, lr


get_char_at_i_j:
    ; Get the byte stored at index[i][j] and return it in r0
    PUSH {r4-r12, lr}
    ldr r6, ptr_to_index_i
    LDRB r1, [r6]  ; Load index_i

    ldr r6, ptr_to_index_j
    LDRB r2, [r6]  ; Load index_j

    CMP r1, #0
    BEQ get_char_at_i_j_0
	
    CMP r1, #1
    BEQ get_char_at_i_j_1

    CMP r1, #2
    BEQ get_char_at_i_j_2

    CMP r1, #3
    BEQ get_char_at_i_j_3

    CMP r1, #4
    BEQ get_char_at_i_j_4

    CMP r1, #5
    BEQ get_char_at_i_j_5

    CMP r1, #6
    BEQ get_char_at_i_j_6

    CMP r1, #7
    BEQ get_char_at_i_j_7

    CMP r1, #8
    BEQ get_char_at_i_j_8

    CMP r1, #9
    BEQ get_char_at_i_j_9

    CMP r1, #10
    BEQ get_char_at_i_j_10

    CMP r1, #11
    BEQ get_char_at_i_j_11

    CMP r1, #12
    BEQ get_char_at_i_j_12

    CMP r1, #13
    BEQ get_char_at_i_j_13

    CMP r1, #14
    BEQ get_char_at_i_j_14

    CMP r1, #15
    BEQ get_char_at_i_j_15

    CMP r1, #16
    BEQ get_char_at_i_j_16

    CMP r1, #17
    BEQ get_char_at_i_j_17

    CMP r1, #18
    BEQ get_char_at_i_j_18

    CMP r1, #19
    BEQ get_char_at_i_j_19

    CMP r1, #20
    BEQ get_char_at_i_j_20

    CMP r1, #21
    BEQ get_char_at_i_j_21

    B get_char_at_i_j_end  

get_char_at_i_j_0:
    ldr r6, ptr_to_line0
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_1:
    ldr r6, ptr_to_line1
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_2:
    ldr r6, ptr_to_line2
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_3:
    ldr r6, ptr_to_line3
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_4:
    ldr r6, ptr_to_line4
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_5:
    ldr r6, ptr_to_line5
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_6:
    ldr r6, ptr_to_line6
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_7:
    ldr r6, ptr_to_line7
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_8:
    ldr r6, ptr_to_line8
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_9:
    ldr r6, ptr_to_line9
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_10:
    ldr r6, ptr_to_line10
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_11:
    ldr r6, ptr_to_line11
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_12:
    ldr r6, ptr_to_line12
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_13:
    ldr r6, ptr_to_line13
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_14:
    ldr r6, ptr_to_line14
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_15:
    ldr r6, ptr_to_line15
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_16:
    ldr r6, ptr_to_line16
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_17:
    ldr r6, ptr_to_line17
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_18:
    ldr r6, ptr_to_line18
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_19:
    ldr r6, ptr_to_line19
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_20:
    ldr r6, ptr_to_line20
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_21:
    ldr r6, ptr_to_line21
    LDRB r0, [r6, r2]
    B get_char_at_i_j_end

get_char_at_i_j_end:
    POP {r4-r12, lr}
	MOV pc, lr



place_X_at_i_j:
    ; Store an 'X' (0x58) at index[i][j]
	PUSH {r4-r12, lr}
	MOV r3, #0x58

    ldr r6, ptr_to_index_i
    LDRB r1, [r6]  ; Load index_i

    ldr r6, ptr_to_index_j
    LDRB r2, [r6]  ; Load index_j

    CMP r1, #0
    BEQ place_X_at_i_j_0

    CMP r1, #1
    BEQ place_X_at_i_j_1

    CMP r1, #2
    BEQ place_X_at_i_j_2

    CMP r1, #3
    BEQ place_X_at_i_j_3

    CMP r1, #4
    BEQ place_X_at_i_j_4

    CMP r1, #5
    BEQ place_X_at_i_j_5

    CMP r1, #6
    BEQ place_X_at_i_j_6

    CMP r1, #7
    BEQ place_X_at_i_j_7

    CMP r1, #8
    BEQ place_X_at_i_j_8

    CMP r1, #9
    BEQ place_X_at_i_j_9

    CMP r1, #10
    BEQ place_X_at_i_j_10

    CMP r1, #11
    BEQ place_X_at_i_j_11

    CMP r1, #12
    BEQ place_X_at_i_j_12

    CMP r1, #13
    BEQ place_X_at_i_j_13

    CMP r1, #14
    BEQ place_X_at_i_j_14

    CMP r1, #15
    BEQ place_X_at_i_j_15

    CMP r1, #16
    BEQ place_X_at_i_j_16

    CMP r1, #17
    BEQ place_X_at_i_j_17

    CMP r1, #18
    BEQ place_X_at_i_j_18

    CMP r1, #19
    BEQ place_X_at_i_j_19

    CMP r1, #20
    BEQ place_X_at_i_j_20

    CMP r1, #21
    BEQ place_X_at_i_j_21


place_X_at_i_j_0:
    ldr r6, ptr_to_line0
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_1:
    ldr r6, ptr_to_line1
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_2:
    ldr r6, ptr_to_line2
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_3:
    ldr r6, ptr_to_line3
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_4:
    ldr r6, ptr_to_line4
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_5:
    ldr r6, ptr_to_line5
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_6:
    ldr r6, ptr_to_line6
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_7:
    ldr r6, ptr_to_line7
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_8:
    ldr r6, ptr_to_line8
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_9:
    ldr r6, ptr_to_line9
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_10:
    ldr r6, ptr_to_line10
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_11:
    ldr r6, ptr_to_line11
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_12:
    ldr r6, ptr_to_line12
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_13:
    ldr r6, ptr_to_line13
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_14:
    ldr r6, ptr_to_line14
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_15:
    ldr r6, ptr_to_line15
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_16:
    ldr r6, ptr_to_line16
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_17:
    ldr r6, ptr_to_line17
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_18:
    ldr r6, ptr_to_line18
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_19:
    ldr r6, ptr_to_line19
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_20:
    ldr r6, ptr_to_line20
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_21:
    ldr r6, ptr_to_line21
    STRB r3, [r6, r2]
    B place_X_at_i_j_end

place_X_at_i_j_end:
	POP {r4-r12, lr}
    MOV pc, lr

decrement_timer:
	PUSH {r4-r12, lr}
	ldr r0, ptr_to_decrement_time
	ldr r1, [r0]
	MOV r2, #0x0F10
	MOVT r2, #0x0004
	CMP r1, r2
	BEQ end_time

	MOV r3, #0xADD4
	SUB r1, r3
	str r1, [r0]

	MOV r0, #0x0000
	MOVT r0, #0x4003

	ldrb r2, [r0,#0x00C]
	BIC r2, r2, #0x1
	strb r2, [r0, #0x00C]

	str r1, [r0,#0x028]

	ldrb r2, [r0,#0x00C]
	ORR r2, r2, #0x1
	strb r2, [r0, #0x00C]


end_time:
	POP {r4-r12, lr}
	MOV pc, lr

reset_timer:
	PUSH {r4-r12, lr}
	ldr r0, ptr_to_reset_time
	ldr r1, [r0]

	MOV r0, #0x0000
	MOVT r0, #0x4003

	ldrb r2, [r0,#0x00C]
	BIC r2, r2, #0x1
	strb r2, [r0, #0x00C]

	str r1, [r0,#0x028]

	ldrb r2, [r0,#0x00C]
	ORR r2, r2, #0x1
	strb r2, [r0, #0x00C]

	POP {r4-r12, lr}
	MOV pc, lr

	.end
