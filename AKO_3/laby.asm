
.686
.model flat
extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main

; obszar instrukcji (rozkazów) programu

.code

wczytaj_do_EAX_bin PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

; rezerwacja 36 bajtów na stosie przeznaczonych na tymczasowe
; przechowanie cyfr binarnych wpisanej liczby
	sub esp, 36		; rezerwacja poprzez zmniejszenie ESP
	mov ebp, esp	; adres zarezerwowanego obszaru pamiêci
	push 36			; max iloœæ znaków wczytyw. liczby
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

; sprawdzenie czy wprowadzony znak jest cyfr¹ 0 lub 1
	cmp dl, '0'
	jb pocz_konw ; inny znak jest ignorowany
	cmp dl, '1'
	ja pocz_konw
	sub dl, '0' ; zamiana kodu ASCII na wartoœæ cyfry

dopisz:
	shl eax, 1	; przesuniêcie logiczne w lewo o 1 bit
	or al, dl	; dopisanie utworzonego kodu 4-bitowego
				; na 4 ostatnie bity rejestru EAX

	jmp pocz_konw ; skok na pocz¹tek pêtli konwersji

gotowe:
; zwolnienie zarezerwowanego obszaru pamiêci
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
	mov ebx, 10	; dzielnik równy 10

	or edi, edi
	jz blad

	mov eax, [edi] ; liczba z pamieci edi do eax

konwersja: 
	mov edx, 0	; zerowanie starszej czêœci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	mov [esi + ecx], byte ptr dl	; zapisanie cyfry w kodzie ASCII 
	dec ecx				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 

wypeln: 
	or ecx, ecx 
	jz wyswietl			; skok, gdy ecx = 0 
	mov [esi + ecx], byte ptr 20H ; kod spacji 
	dec ecx				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov [esi], byte ptr 0AH		; kod nowego wiersza 
	mov [esi + 11], byte ptr 0AH	; kod nowego wiersza
; wyœwietlenie cyfr na ekranie 
	push 12						; liczba wyœwietlanych znaków 
	push esi					; adres wyœw. obszaru 
	push 1						; numer urz¹dzenia (ekran ma numer 1) 
	call __write				; wyœwietlenie liczby na ekranie 
	add esp, 12					; usuniêcie parametrów ze stosu

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