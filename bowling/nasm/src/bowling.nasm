
bits 64


global roll
global score
global init_game


section .data
	remaining_throws db 2
	remaining_pins db 10
	total_score dw 0


section .text

	;
	; Initializes the game
	;
	init_game:
		mov word [rel total_score], 0
		call start_new_frame
		ret

	;
	; Adds the number of knocked pins to the current frame
	;
	; -> rdi: the number of knocked pins
	;
	roll:
		call clamp_knocked_pins_count
		add [rel total_score], rax
		sub [rel remaining_pins], rax

		dec byte [rel remaining_throws]
		jz .frame_ended

		; 1 remaining throw, no more remaining pins = strike was made
		cmp byte [rel remaining_pins], 0
		jnz .nothing_particular_about_throw
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
