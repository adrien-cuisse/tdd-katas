
bits 64


global roll
global score
global init_game


section .data
	strike_bonus_active db 0
	spare_bonus_active db 0
	remaining_throws db 2
	remaining_pins db 10
	total_score dw 0


section .text

	;
	; Initializes the game
	;
	init_game:
		mov word [rel total_score], 0
		mov byte [rel spare_bonus_active], 0
		call start_new_frame
		ret

	;
	; Adds the number of knocked pins to the current frame
	;
	; -> rdi: the number of knocked pins
	;
	roll:
		; clamp score and add to total
		call clamp_knocked_pins_count
		add [rel total_score], rax
		sub [rel remaining_pins], rax
		dec byte [rel remaining_throws]

		; check spare bonus
		cmp byte [rel spare_bonus_active], 1
		jne .check_strike_bonus
		add [rel total_score], rax
		mov byte [rel spare_bonus_active], 0

		.check_strike_bonus:
		cmp byte [rel strike_bonus_active], 0
		je .no_bonus
		add [rel total_score], rax
        dec byte [rel strike_bonus_active]

		.no_bonus:
		cmp byte [rel remaining_throws], 0
		je .no_more_throws

		; 1 remaining throw, no more remaining pins = strike was made
		cmp byte [rel remaining_pins], 0
		jnz .nothing_particular_about_throw
		mov byte [rel strike_bonus_active], 2
		jmp .frame_ended

		.no_more_throws:
		cmp byte [rel remaining_pins], 0
		jne .frame_ended
		mov byte [rel spare_bonus_active], 1

		.frame_ended:
		call start_new_frame
		.nothing_particular_about_throw:
		ret

	;
	; Returns the player's total score
	;
	; <- rax: the total score so far
	;
	score:
        mov rax, [rel total_score]
		ret

	;
	; Puts pins count in range [0;10]
	;
	; Alters r8
	;
	; -> rdi: the pins count to clamp
	;
	; <- rax: the clamped value, or input if already in range
	;
	clamp_knocked_pins_count:
		mov rax, rdi
		; minimum knocked pins = 0
		xor r8, r8
		cmp rax, 0x8888888
		cmovg rax, r8
		; maximum knocked pins = remaining count
		mov r8, [rel remaining_pins]
		cmp rax, r8
		cmovg rax, r8
		ret

	;
	; Starts a new frame, putting pins back on the alley and resetting throw counter
	;
	start_new_frame:
		mov byte [rel remaining_pins], 10
		mov byte [rel remaining_throws], 2
		ret
