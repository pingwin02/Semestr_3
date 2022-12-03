
.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main

; obszar instrukcji (rozkaz�w) programu

.code

wczytaj_do_EAX_bin PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

; rezerwacja 36 bajt�w na stosie przeznaczonych na tymczasowe
; przechowanie cyfr binarnych wpisanej liczby
	sub esp, 36		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pami�ci
	push 36			; max ilo�� znak�w wczytyw. liczby
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

; sprawdzenie czy wprowadzony znak jest cyfr� 0 lub 1
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '1'
	ja pocz_konw
	sub dl, '0' ; zamiana kodu ASCII na warto�� cyfry

dopisz:
	shl eax, 1	; przesuni�cie logiczne w lewo o 1 bit
	or al, dl	; dopisanie utworzonego kodu 4-bitowego
				; na 4 ostatnie bity rejestru EAX

	jmp pocz_konw ; skok na pocz�tek p�tli konwersji

gotowe:
; zwolnienie zarezerwowanego obszaru pami�ci
	add esp, 36
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX_bin ENDP

wyswietl_EAX_EDI PROC

	pusha

	sub esp, 4
	mov esi, esp

	mov ecx, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik r�wny 10

	or edi, edi
	jz blad

	mov eax, [edi] ; liczba z pamieci edi do eax

konwersja: 
	mov edx, 0	; zerowanie starszej cz�ci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	mov [esi + ecx], byte ptr dl	; zapisanie cyfry w kodzie ASCII 
	dec ecx				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 

wypeln: 
	or ecx, ecx 
	jz wyswietl			; skok, gdy ecx = 0 
	mov [esi + ecx], byte ptr 20H ; kod spacji 
	dec ecx				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov [esi], byte ptr 0AH		; kod nowego wiersza 
	mov [esi + 11], byte ptr 0AH	; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push 12						; liczba wy�wietlanych znak�w 
	push esi					; adres wy�w. obszaru 
	push 1						; numer urz�dzenia (ekran ma numer 1) 
	call __write				; wy�wietlenie liczby na ekranie 
	add esp, 12					; usuni�cie parametr�w ze stosu

blad:
	add esp, 4
	popa
	ret
wyswietl_EAX_EDI ENDP


_main PROC

	call wczytaj_do_EAX_bin
	sub esp, 4
	mov edi, esp
	mov [edi], eax

	call wyswietl_EAX_EDI
	
	add esp, 4
	push 0
	call _ExitProcess@4
_main ENDP
END