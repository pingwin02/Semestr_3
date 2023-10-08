.686
.model flat

public _nowy_exp

.data
	iteracja dd 20

.code
_nowy_exp PROC
	push ebp
	mov ebp, esp

	mov ecx, iteracja
	dec ecx
	finit
	fldz

suma:
	mov iteracja, ecx
	inc iteracja

	fld dword ptr [ebp + 8] ; zmienna x
	fld dword ptr [ebp + 8]

	push ecx
do_potegi:
	fmul st(1), st(0)
	loop do_potegi

	pop ecx
	; st(0) = x, st(1) = x^ecx

	fstp st(0)
	; st(0) = x^ecx

	push ecx
	push iteracja
	fild iteracja
silnia:
	dec iteracja
	fild iteracja ; st(0) = iteracja-1 st(1) = iteracja st(2) = x^ecx
	fmul
	loop silnia
	pop iteracja
	pop ecx

	; st(0) = ecx! st(1) = x^ecx

	fdiv

	; st(0) = x^ecx/ecx!

	fadd
	loop suma

	fld dword ptr [ebp + 8] ; dodanie x/1
	fadd

	fld1 ; dodanie 1
	fadd

	pop ebp
	ret
_nowy_exp ENDP
END