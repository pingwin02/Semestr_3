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
	fdivp st(1), st(0)
	faddp st(1), st(0)
	loop suma

	fild dword ptr [ebp + 12]
	fdiv st (0), st(1)

	pop esi
	pop ebp
	ret
_srednia_harm ENDP
END