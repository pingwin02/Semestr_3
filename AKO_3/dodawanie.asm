; wczytanie dwoch liczb dwunastkowo
; i wyswietlenie wyniku dzielenia dziesietnie

.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern wyswietl_EAX : PROC
public _main

.data
	dwanascie	db 12
.code

wczytaj_do_EAX_12 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	sub esp, 12		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pamiêci
	push 12			; max iloœæ znaków wczytyw. liczby
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
	cmp dl, '+' ; sprawdzenie czy znak dodawania
	je dalej
	cmp dl, 10
	je gotowe ; skok do koñca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr¹ 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

dopisz:
	mul dwanascie 
	add eax, edx		; dodanie ostatnio odczytanej cyfry 

	jmp pocz_konw ; skok na pocz¹tek pêtli konwersji

; sprawdzenie czy wprowadzony znak jest cyfr¹ A, B
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'B'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

; sprawdzenie czy wprowadzony znak jest cyfr¹ a, b
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'b'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

dalej:
	mov ecx, eax
	xor eax, eax
	jmp pocz_konw

gotowe:

	add eax, ecx

; zwolnienie zarezerwowanego obszaru pamiêci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_12 ENDP

_main PROC

	call wczytaj_do_EAX_12

	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END
