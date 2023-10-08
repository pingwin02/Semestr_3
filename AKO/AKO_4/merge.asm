.686
.model flat

public _merge

.data

result db 2*4*32 dup (0)

.code
_merge PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov edx, 0 ; indeks tablic
	mov eax, 0 ; indeks wyniku

	mov ecx, [ebp + 16] ; liczba n
	mov esi, [ebp + 12] ; tablica 2
	mov edi, [ebp + 8] ; tablica 1
	cmp ecx, 32
	ja blad

	ptl:
	mov ebx, dword ptr [edi + 4*edx]
	mov dword ptr result [4*eax], ebx

	mov ebx, dword ptr [esi + 4*edx]
	mov dword ptr result [4*eax + 4], ebx
	inc edx
	add eax, 2
	loop ptl
	jmp koniec

	koniec:
	mov eax, OFFSET result
	blad:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_merge ENDP
END