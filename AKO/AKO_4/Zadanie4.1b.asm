.686
.model flat

public _szukaj4_max

.code

_szukaj4_max PROC

	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP

	mov ecx, 3 ; zaczynamy od adresu [ebp + 16]
	mov eax, [ebp + 20] ; eax trzyma zmienna d

	ptl:

	mov edx, [ebp+4*ecx+4] ; kolejna liczba
	cmp edx, eax
	jl dalej

	; znaleziono wieksza liczbe
	mov eax, edx

	dalej:
	loop ptl

	pop ebp
	ret


_szukaj4_max ENDP
END