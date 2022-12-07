.686
.XMM
.model flat

public _dziel

.code

_dziel PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	sub esp, 16

	mov edi, esp

	mov ecx, 4
	mov eax, [ebp + 16] ; dzielnik

alokuj:
	mov dword ptr [edi + 4*ecx - 4], eax
	loop alokuj

	mov esi, [ebp + 8] ; tablica tablic
	mov ecx, [ebp + 12] ; zmienna n
	mov edx, 0

ptl:
	movups xmm0, [esi + edx]
	movups xmm1, [edi]
	divps xmm0, xmm1
	movups [esi + edx], xmm0
	add edx, 16
	loop ptl

	add esp,16
	pop edi
	pop esi
	pop ebp
	ret
_dziel ENDP
END