; Wczytanie liczby dziesi�tnej z klawiatury
; liczba po konwersji na posta� binarn� zostaje wpisana
; do rejestru EAX

.686
.model flat
extern __read : PROC

.data

; deklaracja tablicy do przechowywania wprowadzanych cyfr
; (w obszarze danych)
	obszar		db 12 dup (?) 
	dziesiec	dd 10 ; mno�nik

.code
wczytaj_do_EAX PROC

;przechowanie wartosci rejestrow
	push ebx
	push ecx

; max ilo�� znak�w wczytywanej liczby

	push 12 
	push OFFSET obszar ; adres obszaru pami�ci 
	push 0		; numer urz�dzenia (0 dla klawiatury) 
	call __read ; odczytywanie znak�w z klawiatury 
				; (dwa znaki podkre�lenia przed read) 
	add esp, 12 ; usuni�cie parametr�w ze stosu

; bie��ca warto�� przekszta�canej liczby przechowywana jest 
; w rejestrze EAX przyjmujemy 0 jako warto�� pocz�tkow�

	mov eax, 0 
	mov ebx, OFFSET obszar ; adres obszaru ze znakami

pobieraj_znaki: 
	mov cl, [ebx]	; pobranie kolejnej cyfry w kodzie 
					; ASCII 
	inc ebx			; zwi�kszenie indeksu 
	cmp cl, 10		; sprawdzenie czy naci�ni�to Enter 
	je byl_enter	; skok, gdy naci�ni�to Enter 
	sub cl, 30H		; zamiana kodu ASCII na warto�� cyfry 
	movzx ecx, cl	; przechowanie warto�ci cyfry w 
					; rejestrze ECX

; mno�enie wcze�niej obliczonej warto�ci razy 10 
	mul dziesiec 
	add eax, ecx		; dodanie ostatnio odczytanej cyfry 
	jmp pobieraj_znaki	; skok na pocz�tek p�tli

byl_enter:
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

END
