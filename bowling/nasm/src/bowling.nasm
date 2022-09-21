
bits 64


global roll
global score
global initGame


section .data
	total_score: dw 0


section .text

	;
	; Initializes the game
	;
	initGame:
		mov word [rel total_score], 0
		ret

	;
	; Adds the number of knocked pins to the current frame
	;
	; -> rdi: the number of knocked pins
	;
	roll:
		call clamp_knocked_pins_count
		add [rel total_score], rax
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
		; maximum knocked pins = 10
		mov r8, 10
		cmp rax, r8
		cmovg rax, r8
		ret
