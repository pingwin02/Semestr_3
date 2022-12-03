public suma_siedmiu_liczb

.code

suma_siedmiu_liczb PROC
	push rbp
	mov rbp, rsp

	mov rax, rcx	; zmienna v1
	add rax, rdx	; dodaj zmienna v2 
	add rax, r8		; dodaj zmienna v3
	add rax, r9		; dodaj zmienna v4

 ; rbp - wierzcholek stosu, kolejne 8 bajtow to slad call
 ; kolejne 32 bajty to shadow space i kolejne 8 to push rbp
 ; 8 + 32 + 8 = 48 daje offset do kolejnej zmiennej v5

	add rax, [rbp + 48] ; dodaj zmienna v5
	add rax, [rbp + 56] ; dodaj zmienna v6
	add rax, [rbp + 64] ; dodaj zmienna v7

	pop rbp
	ret
suma_siedmiu_liczb ENDP
END