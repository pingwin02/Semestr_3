public szukaj4_min

.code

szukaj4_min PROC
	push rbp
	mov rbp, rsp

	mov rax, rcx

	cmp rax, rdx
	jl dalej1
	mov rax, rdx

	dalej1:
	cmp rax, r8
	jl dalej2
	mov rax, r8

	dalej2:
	cmp rax, r9
	jl koniec

	mov rax, r9

	koniec:
	pop rbp
	ret
szukaj4_min ENDP
END