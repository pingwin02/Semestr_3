;Wczytanie dwoch liczb, w dwunastkowo i osemkowo
;Wyswietlenie ich roznicy dziesietnie

.686
.model flat
extern _ExitProcess@4 : PROC
extern wyswietl_EAX : PROC
extern __read : PROC
extern __write : PROC
public _main

.data
	dwanascie	dd 12
	osiem		dd 8
	liczba		dd ?
	minus		db '-'
	znaki		db 12 dup (?)

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
	cmp dl, 10
	je gotowe ; skok do koñca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr¹ 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

dopisz:
	push edx
	mul dwanascie 
	pop edx
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
wczytaj_do_EAX_12 ENDP

wczytaj_do_EAX_8 PROC
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

pocz_konw1:
	mov dl, [ebp + esi] ; pobranie kolejnego bajtu
	inc esi ; inkrementacja indeksu
	cmp dl, 10
	je gotowe1 ; skok do koñca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr¹ 0, 1, 2 , ..., 8
	cmp dl, '0'
	jb pocz_konw1 ; inny znak jest ignorowany
	cmp dl, '8'
	ja pocz_konw1
	sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

dopisz1:
	push edx
	mul osiem 
	pop edx
	add eax, edx		; dodanie ostatnio odczytanej cyfry 

	jmp pocz_konw1 ; skok na pocz¹tek pêtli konwersji

gotowe1:

; zwolnienie zarezerwowanego obszaru pamiêci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_8 ENDP

wyswietl_EAX_u2 PROC

	pusha

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik równy 10

konwersja: 
	mov edx, 0	; zerowanie starszej czêœci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	dec esi				; zmniejszenie indeksu 
	mov znaki [esi], dl	; zapisanie cyfry w kodzie ASCII 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	dec esi				; zmniejszenie indeksu 
	mov znaki [esi], 0
	jmp wypeln 

wyswietl: 
	mov znaki [10], 0AH	; kod nowego wiersza
; wyœwietlenie cyfr na ekranie 
	push 11						; liczba wyœwietlanych znaków 
	push OFFSET znaki			; adres wyœw. obszaru 
	push 1						; numer urz¹dzenia (ekran ma numer 1) 
	call __write				; wyœwietlenie liczby na ekranie 
	add esp, 12					; usuniêcie parametrów ze stosu
	popa
	ret
wyswietl_EAX_u2 ENDP


_main PROC

	call wczytaj_do_EAX_12
	mov	ebx, eax

	call wczytaj_do_EAX_8

	sub ebx, eax
	mov eax, ebx

	mov liczba, eax
	; sprawdzenie czy ujemna
	rcl eax, 1
	jnc koniec
	rcr eax, 1
	neg eax
	mov liczba, eax
	push 1
	push OFFSET minus
	push 1
	call __write
	add esp, 12

koniec:
	mov eax, liczba
	call wyswietl_EAX_u2
	push 0
	call _ExitProcess@4
_main ENDP
END
