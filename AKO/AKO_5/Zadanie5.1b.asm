.686
.model flat

public _srednia_harm

.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	push esi

	mov ecx, [ebp + 12] ; zmienna n

	mov esi, [ebp + 8] ; tablica

	finit
	fldz

	suma:
	fld1
	fld dword ptr [esi + 4*ecx - 4]
	fdiv	; fdivp st(1), st(0)
	fadd	; faddp st(1), st(0)
	loop suma

	fild dword ptr [ebp + 12]

	fxch st(1)
	fdiv

	pop esi
	pop ebp
	ret
_srednia_harm ENDP
END