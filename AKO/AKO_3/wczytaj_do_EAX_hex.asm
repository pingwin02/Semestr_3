; wczytywanie liczby szesnastkowej z klawiatury � liczba po
; konwersji na posta� binarn� zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry nale�y nacisn�� klawisz
; Enter

.686
.model flat
extern __read : PROC

.code
wczytaj_do_EAX_hex PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

; rezerwacja 12 bajt�w na stosie przeznaczonych na tymczasowe
; przechowanie cyfr szesnastkowych wy�wietlanej liczby
	sub esp, 12		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pami�ci
	push 10			; max ilo�� znak�w wczytyw. liczby
	push ebp		; adres obszaru pami�ci
	push 0			; numer urz�dzenia (0 dla klawiatury)
	call __read		; odczytywanie znak�w z klawiatury
					; (dwa znaki podkre�lenia przed read)
	add esp, 12		; usuni�cie parametr�w ze stosu
	mov eax, 0		; dotychczas uzyskany wynik
	xor esi, esi	; wyzerowanie indeksu

pocz_konw:
	mov dl, [ebp + esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy naci�ni�to Enter
	je gotowe ; skok do ko�ca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry

dopisz:
	shl eax, 4	; przesuni�cie logiczne w lewo o 4 bity
	or al, dl	; dopisanie utworzonego kodu 4-bitowego
				; na 4 ostatnie bity rejestru EAX

	jmp pocz_konw ; skok na pocz�tek p�tli konwersji

; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., F
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., f
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

gotowe:
; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_hex ENDP

END
