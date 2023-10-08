.686
.model flat

extern __write : PROC
extern _GetSystemTime@4 : PROC

public _print_time

.code
_print_time PROC

	push ebp
	sub esp, 16
	mov ebp, esp


	push ebp
	call _GetSystemTime@4

	movzx eax, word ptr [ebp + 2*5]
	call wyswietl_EAX


	add esp, 16
	pop ebp
	ret
_print_time ENDP

wyswietl_EAX PROC

	pusha
	mov ebp, esp
	sub esp, 12

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik r�wny 10

konwersja: 
	mov edx, 0	; zerowanie starszej cz�ci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	mov [ebp][esi], dl	; zapisanie cyfry w kodzie ASCII 
	dec esi				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype�nienie pozosta�ych bajt�w spacjami i wpisanie 
; znak�w nowego wiersza 

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	mov [ebp][esi], byte ptr 20H ; kod spacji 
	dec esi				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
	mov [ebp], byte ptr 0AH		; kod nowego wiersza 
	mov [ebp][11], byte ptr 0AH	; kod nowego wiersza
; wy�wietlenie cyfr na ekranie 
	push 12						; liczba wy�wietlanych znak�w 
	push ebp					; adres wy�w. obszaru 
	push 1						; numer urz�dzenia (ekran ma numer 1) 
	call __write				; wy�wietlenie liczby na ekranie 
	add esp, 12					; usuni�cie parametr�w ze stosu

	add esp, 12
	popa
	ret
wyswietl_EAX ENDP

END
