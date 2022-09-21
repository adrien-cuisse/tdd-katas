
BITS 64


global roll
global score


section .data
	total_score: dw 0


section .text

	;
	; Adds the number of knocked pins to the current frame
	;
	; -> rdi: the number of knocked pins
	;
	roll:
		add [rel total_score], rdi
		ret

	;
	; Returns the player's total score
	;
	; <- rax: the total score so far
	;
	score:
        mov rax, [rel total_score]
		ret
