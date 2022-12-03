.686
.model flat

public _reduction

.code

_reduction PROC

	push ebp
	mov ebp, esp
	push esi

	mov esi, [ebp + 8] ; adres tablicy tab
	mov ecx, [ebp + 12] ; ilosc elementow tablicy
	dec ecx
	mov edx, [ebp + 16] ; typ redukcji

	mov eax, [esi] ; eax trzyma wartosc liczby tab[0]

	cmp edx, -1 ; min
	je szuk_min
	cmp edx, 1 ; max
	je szuk_max
	cmp edx, 0 ; suma
	jne koniec

	; przypadek gdy suma
	suma:
	add eax, [esi + 4*ecx]
	loop suma
	jmp koniec

	szuk_min:
	cmp eax, [esi + 4*ecx]
	jl pomin_min
	mov eax, [esi + 4*ecx]
	pomin_min:
	loop szuk_min
	jmp koniec

	szuk_max:
	cmp eax, [esi + 4*ecx]
	jg pomin_max
	mov eax, [esi + 4*ecx]
	pomin_max:
	loop szuk_max

	koniec:
	pop esi
	pop ebp
	ret

_reduction ENDP
END