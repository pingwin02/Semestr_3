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
	mov ebx, 10	; dzielnik r�wny 10

konwersja: 
	mov edx, 0	; zerowanie starszej cz�ci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
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
	mov znaki [11], 0AH	; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push 12						; liczba wy�wietlanych znak�w 
	push OFFSET znaki			; adres wy�w. obszaru 
	push 1						; numer urz�dzenia (ekran ma numer 1) 
	call __write				; wy�wietlenie liczby na ekranie 
	add esp, 12					; usuni�cie parametr�w ze stosu
	popa
	ret
wyswietl_EAX ENDP
END
