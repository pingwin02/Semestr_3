.686
.model flat

public _szukaj4_min

.code

_szukaj4_min PROC
	push ebp
	mov ebp, esp

	mov eax, [ebp + 8] ; zmienna a
	mov ecx, 3

	ptl:
	cmp eax, [ebp + 4*ecx + 8]
	jl dalej
	mov eax, [ebp + 4*ecx + 8]
	dalej:
	loop ptl

	pop ebp
	ret
_szukaj4_min ENDP
END