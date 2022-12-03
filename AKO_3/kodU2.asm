; wczytanie liczby w postaci hexowej U2
; i wyswietlenie jej w postaci dziesietnej

.686
.model flat
extern _ExitProcess@4 : PROC
extern wczytaj_do_EAX_hex : PROC
extern __write : PROC
public _main

.data

; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
	znaki		db 12 dup (?)
	liczba		dd ?
	minus		db '-'

.code
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

	call wczytaj_do_EAX_hex
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
	call wyswietl_eax_u2
	push 0
	call _ExitProcess@4
_main ENDP
END
