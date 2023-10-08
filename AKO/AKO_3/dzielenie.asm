; wczytanie dwoch liczb dwunastkowo
; i wyswietlenie wyniku dzielenia dziesietnie

.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main

.data

	dwanascie	db 12
	dziesiec	db 10
	dzielna		db ?
	dzielnik	db ?
	kropka		db '.'

.code

wczytaj_do_EAX_12 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	sub esp, 12		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pami�ci
	push 12			; max ilo�� znak�w wczytyw. liczby
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
	cmp dl, '/' ; sprawdzenie czy znak dzielenia
	je dalej
	cmp dl, 10
	je gotowe ; skok do ko�ca podprogramu

; sprawdzenie czy wprowadzony znak jest cyfr� 0, 1, 2 , ..., 9
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '9'
	ja sprawdzaj_dalej
	sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry

dopisz:
	mul dwanascie 
	add eax, edx		; dodanie ostatnio odczytanej cyfry 

	jmp pocz_konw ; skok na pocz�tek p�tli konwersji

; sprawdzenie czy wprowadzony znak jest cyfr� A, B
sprawdzaj_dalej:
	cmp dl, 'A'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'B'
	ja sprawdzaj_dalej2
	sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
	jmp dopisz

; sprawdzenie czy wprowadzony znak jest cyfr� a, b
sprawdzaj_dalej2:
	cmp dl, 'a'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, 'b'
	ja pocz_konw ; inny znak jest ignorowany
	sub dl, 'a' - 10
	jmp dopisz

dalej:
	mov dzielna, al
	xor eax, eax
	jmp pocz_konw

gotowe:

	mov dzielnik, al

; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 12
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_12 ENDP

wyswietl_EAX_12 PROC

	pusha

	sub esp, 3	; rezerwacja 3 bajtow na znaki
	mov ebp, esp

	mov esi, 3 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik r�wny 10

konwersja: 
	mov edx, 0	; zerowanie starszej cz�ci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	dec esi				; zmniejszenie indeksu 
	mov [ebp + esi], dl	; zapisanie cyfry w kodzie ASCII 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	dec esi				; zmniejszenie indeksu 
	mov byte ptr [ebp + esi], '0'
	jmp wypeln 

wyswietl:

; wy�wietlenie cyfr na ekranie 
	push 3						; liczba wy�wietlanych znak�w 
	push ebp					; adres wy�w. obszaru 
	push 1						; numer urz�dzenia (ekran ma numer 1) 
	call __write				; wy�wietlenie liczby na ekranie 
	add esp, 12					; usuni�cie parametr�w ze stosu

	add esp, 3
	popa
	ret
wyswietl_EAX_12 ENDP

_main PROC

	call wczytaj_do_EAX_12

	movzx ax, dzielna
	div dzielnik
	push eax
	and eax, 0FFh
	call wyswietl_EAX_12

	; wyswietlenie kropki
	push 1
	push OFFSET kropka
	push 1
	call __write
	add esp, 12
	pop eax
	xor ebx, ebx ; zresetowanie ebx, tam bedzie trzymana reszta

	mov ecx, 3

ptl:
	shr eax, 8
	mul dziesiec
	div dzielnik

	push eax
	mov eax, ebx
	mul dziesiec
	mov ebx, eax
	pop eax
	add bl, al
	loop ptl

	mov eax, ebx
	call wyswietl_EAX_12

	push 0
	call _ExitProcess@4
_main ENDP
END
