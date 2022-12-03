; wczytywanie liczby szesnastkowej z klawiatury – liczba po
; konwersji na postaæ binarn¹ zostaje wpisana do rejestru EAX
; po wprowadzeniu ostatniej cyfry nale¿y nacisn¹æ klawisz
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

; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe
; przechowanie cyfr szesnastkowych wyœwietlanej liczby
	sub esp, 12		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pamiêci
	push 10			; max iloœæ znaków wczytyw. liczby
	push ebp		; adres obszaru pamiêci
	push 0			; numer urz¹dzenia (0 dla klawiatury)
	call __read		; odczytywanie znaków z klawiatury
					; (dwa znaki podkreœlenia przed read)
	add esp, 12		; usuniêcie parametrów ze stosu
	mov eax, 0		; dotychczas uzyskany wynik
	xor esi, esi	; wyzerowanie indeksu

pocz_konw:
	mov dl, [ebp + esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10 ; sprawdzenie czy naciœniêto Enter
	je gotowe ; skok do koñca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr¹ 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

dopisz:
	shl eax, 4	; przesuniêcie logiczne w lewo o 4 bity
	or al, dl	; dopisanie utworzonego kodu 4-bitowego
				; na 4 ostatnie bity rejestru EAX

	jmp pocz_konw ; skok na pocz¹tek pêtli konwersji

; sprawdzenie czy wprowadzony znak jest cyfr¹ A, B, ..., F
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'F'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

; sprawdzenie czy wprowadzony znak jest cyfr¹ a, b, ..., f
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'f'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

gotowe:
; zwolnienie zarezerwowanego obszaru pamiêci
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
