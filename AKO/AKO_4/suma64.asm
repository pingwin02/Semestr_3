public sum_of_squares

.code

sum_of_squares PROC
	push rbp
	push rbx
	mov rbp, rsp

	mov rsi, rcx ; tablica
	mov rcx, rdx ; zmienna n
	xor rbx, rbx

	ptl:

	mov rax, [rsi + 8 * rcx - 8]
	imul qword ptr [rsi + 8 * rcx - 8]
	add rbx, rax

	loop ptl

	mov rax, rbx

	pop rbx
	pop rbp
	ret
sum_of_squares ENDP
END