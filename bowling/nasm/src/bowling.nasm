
BITS 64

global roll
global score

section .text
	roll:
		mov rax, -1
		ret

	score:
		xor rax, rax
		ret
