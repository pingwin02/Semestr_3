.686
.model flat

extern _malloc : PROC
public _dodaj

.code
_dodaj PROC
	push ebp
	mov ebp, esp
	push esi
	push edi

	mov esi, [ebp + 8] ; liczba_we
	mov edi, [ebp + 16] ; liczba_wy

	xor ecx, ecx

	znajdz_dlugosc:
	mov ax, [esi + ecx]
	add ecx, 2
	or ax, ax
	jnz znajdz_dlugosc

	add ecx, 2 ; zarezerwuj o 2 bajty wiecej
	push ecx
	call _malloc
	pop ecx

	or eax, eax
	je blad

	mov [edi], eax ; przypisz malloca do zmiennej
	mov edi, [edi]


	; przepisz do edi wartosci z esi
	mov [edi], word ptr 30h ; miejsce na przeniesienie
	add edi, 2

	sub ecx, 2
	push ecx
	rep movsb
	pop ecx

	; przenies edi i esi na pierwsza cyfre
	sub edi, 4
	sub esi, 4

	; dodaj cyfre
	mov dx, [edi]
	add dx, [ebp + 12] ; cyfra
	cmp dx, 6Ah
	jae napraw
	; suma ostatniej cyfry i zmiennej a < 10
	sub dx, 30h
	mov [edi], dx
	jmp koniec
	napraw:
	; gdy suma cyfr >=10
	sub dx, 3Ah
	mov [edi], dx

	mov ecx, -1

	przenies:
	mov dx, word ptr [edi + 2*ecx]
	add dx, 1 ; dodanie 1 w ascii
	mov [edi + 2*ecx], dx
	cmp dx, word ptr 3Ah
	jb koniec
	sub dx, 0Ah
	mov [edi + 2*ecx], dx
	loop przenies

	blad:
	mov eax, -1

	koniec:

	pop edi
	pop esi
	pop ebp
	ret
_dodaj ENDP
END