; Damian Jankowski s188597 czwartek 08.12.2022 gr2 9.15-10.45

.686
.model flat

public _srednia_wazona

.code

_srednia_wazona PROC
	push ebp
	mov ebp, esp
	push esi
	push edi

	mov esi, [ebp + 8] ; tabl_dane
	mov edi, [ebp + 12] ; tabl_wagi

	mov ecx, [ebp + 16] ; zmienna n

	finit
	fldz
	push ecx
licznik:
	fld dword ptr [esi + 4*ecx - 4]
	fld dword ptr [edi + 4*ecx - 4]
	; st(0) = waga st(1) = liczba st(2) = suma_gora
	fmul
	; st(0) = waga*liczba st(1) = suma_gora
	fadd
	; st(0) = suma_gora+waga*liczba

	loop licznik
	pop ecx

	fldz
mianownik:
	fld dword ptr [edi + 4*ecx - 4]
	; st(0) = waga st(1) = suma_dol st(2) = licznik
	fadd
	; st(0) = waga + suma_dol
	loop mianownik

	; st(0) = mianownik st(1) = licznik

	fdiv

	; st(0) = srednia wazona

	pop edi
	pop esi
	pop ebp
	ret
_srednia_wazona ENDP
END