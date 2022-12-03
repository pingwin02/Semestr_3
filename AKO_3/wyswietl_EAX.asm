; Wyswietlanie liczby z EAX w postaci dziesietnej

.686
.model flat
extern __write : PROC

.data

; deklaracja tablicy 12-bajtowej do przechowywania
; tworzonych cyfr
	znaki		db 12 dup (?)

.code
wyswietl_EAX PROC

	pusha

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik równy 10

konwersja: 
	mov edx, 0	; zerowanie starszej czêœci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	mov znaki [esi], dl	; zapisanie cyfry w kodzie ASCII 
	dec esi				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	mov znaki [esi], 20H ; kod spacji 
	dec esi				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov znaki, 0AH		; kod nowego wiersza 
	mov znaki [11], 0AH	; kod nowego wiersza
; wyœwietlenie cyfr na ekranie 
	push 12						; liczba wyœwietlanych znaków 
	push OFFSET znaki			; adres wyœw. obszaru 
	push 1						; numer urz¹dzenia (ekran ma numer 1) 
	call __write				; wyœwietlenie liczby na ekranie 
	add esp, 12					; usuniêcie parametrów ze stosu
	popa
	ret
wyswietl_EAX ENDP
END
