; Wczytanie liczby w postaci dwudziestkowej,
; i wyswietlenie jej na ekranie dziesietnie

.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main

.data
	dwadziescia dd 20
	znaki		db 10 dup (?)
	dekoder db '0123456789ABCDEFGHIJ'

.code
wczytaj_do_EAX_20 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

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
	push edx
	mul dwadziescia
	pop edx
	add eax, edx
	jmp pocz_konw ; skok na pocz�tek p�tli konwersji

; sprawdzenie czy wprowadzony znak jest cyfr� A, B, ..., J
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'J'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

; sprawdzenie czy wprowadzony znak jest cyfr� a, b, ..., j
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'j'
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
wczytaj_do_EAX_20 ENDP

wyswietl_EAX_20 PROC

	pusha

	mov esi, 8 ; indeks w tablicy 'znaki'

konwersja: 
	mov edx, 0	; zerowanie starszej cz�ci dzielnej
	div dwadziescia	; dzielenie przez 20, reszta w EDX, 
					; iloraz w EAX 
	mov dl, dekoder [edx]
	mov znaki [esi], dl	; zapisanie cyfry w kodzie ASCII 
	dec esi				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	mov znaki [esi], 20H ; kod spacji 
	dec esi				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov znaki, 0AH		; kod nowego wiersza 
	mov znaki [9], 0AH	; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push 10						; liczba wy�wietlanych znak�w 
	push OFFSET znaki			; adres wy�w. obszaru 
	push 1						; numer urz�dzenia (ekran ma numer 1) 
	call __write				; wy�wietlenie liczby na ekranie 
	add esp, 12					; usuni�cie parametr�w ze stosu
	popa
	ret
wyswietl_EAX_20 ENDP


_main PROC

	call wczytaj_do_EAX_20
	call wyswietl_EAX_20

	push 0
	call _ExitProcess@4
_main ENDP
END