.686
.XMM
.model flat
public _int2float

.code

_int2float PROC
	push ebp
	mov ebp, esp
	push esi
	push edi

	mov esi, [ebp + 8] ; calkowite[]
	mov edi, [ebp + 12] ; zmienno_przec[]

	cvtpi2ps xmm0, qword ptr [esi] ; calkowite[]

	movups [edi], xmm0 ; zmienno_przec[]

	pop edi
	pop esi
	pop ebp
	ret
_int2float ENDP
END