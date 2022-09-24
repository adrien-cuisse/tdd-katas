
bits 64


global roll
global score
global init_game


section .data
	current_frame db 10
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
		mov byte [rel current_frame], 10
		call start_new_frame
		ret

	;
	; Adds the number of knocked pins to the current frame
	;
	; -> rdi: the number of knocked pins
	;
	roll:
		cmp byte [rel current_frame], -1
		jne .game_pending
		ret
		.game_pending:

		; check for final frame
		cmp byte [rel current_frame], 0
		jne .regular_frame

		.regular_frame:

		; clamp score and add to total
		call clamp_knocked_pins_count
		mov rdi, rax

		call register_throw
		call apply_available_bonus_points

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
		dec byte [rel current_frame]
		ret

	;
	; -> rdi: the number of knocked pins to add to score
	;
	register_throw:
		add [rel total_score], rdi
		sub [rel remaining_pins], rdi
		dec byte [rel remaining_throws]
		ret

	;
	; -> rdi: the number of knocked pins
	;
	apply_available_bonus_points:
		call apply_spare_bonus_if_available
		call apply_strike_bonus_if_available
		ret

	;
	; -> rdi: the number of knocked pins to add to score if spare_bonus_active
	;
	apply_spare_bonus_if_available:
		cmp byte [rel spare_bonus_active], 1
		jne .not_available
		add [rel total_score], rdi
		mov byte [rel spare_bonus_active], 0
		.not_available:
		ret

	;
	; -> rdi: the number of knocked pins to add to score if spare_bonus_active
	;
	apply_strike_bonus_if_available:
		cmp byte [rel strike_bonus_active], 0
		je .not_available
		add [rel total_score], rdi
		dec byte [rel strike_bonus_active]
		.not_available:
		ret

	spare_roll:
		call common_roll
		ret

	strike_roll:
		call common_roll
		ret

	common_roll:
		; TODO
		ret
