.686
.XMM
.model flat

public _szybki_max

.code
_szybki_max PROC
	push ebp
	mov ebp, esp
	push edi
	push esi

	mov eax, [ebp + 20] ; zmienna n

	mov ecx, 4
	xor edx, edx
	div ecx
	mov ecx, eax ; ilosc 4x int
	mov edx, 0 ; licznik

	mov esi, [ebp + 8] ; tab1
	mov eax, [ebp + 12] ; tab2
	mov edi, [ebp + 16] ; wynik

ptl:
	movups xmm0, [esi + edx]
	movups xmm1, [eax + edx]

	pmaxsd xmm0, xmm1

	movups [edi + edx], xmm0

	add edx, 16
	loop ptl

	pop esi
	pop edi
	pop ebp
	ret
_szybki_max ENDP
END