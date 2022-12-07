.686
.XMM
.model flat
public _pm_jeden

.data

tabl2 dd 1.0, 1.0, 1.0, 1.0

.code

_pm_jeden PROC
	push ebp
	mov ebp, esp
	push esi
	push edi

	mov esi, [ebp + 8]; tabl[]

	mov edi, offset tabl2 ; tabl2[]

	movups xmm0, [esi]

	movups xmm1, [edi]

	addsubps xmm0, xmm1

	movups[esi], xmm0

	pop edi
	pop esi
	pop ebp
	ret
_pm_jeden ENDP
END