; Wczytanie liczby dziesiêtnej z klawiatury
; liczba po konwersji na postaæ binarn¹ zostaje wpisana
; do rejestru EAX

.686
.model flat
extern __read : PROC

.data

; deklaracja tablicy do przechowywania wprowadzanych cyfr
; (w obszarze danych)
	obszar		db 12 dup (?) 
	dziesiec	dd 10 ; mno¿nik

.code
wczytaj_do_EAX PROC

;przechowanie wartosci rejestrow
	push ebx
	push ecx

; max iloœæ znaków wczytywanej liczby

	push 12 
	push OFFSET obszar ; adres obszaru pamiêci 
	push 0		; numer urz¹dzenia (0 dla klawiatury) 
	call __read ; odczytywanie znaków z klawiatury 
				; (dwa znaki podkreœlenia przed read) 
	add esp, 12 ; usuniêcie parametrów ze stosu

; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest 
; w rejestrze EAX przyjmujemy 0 jako wartoœæ pocz¹tkow¹

	mov eax, 0 
	mov ebx, OFFSET obszar ; adres obszaru ze znakami

pobieraj_znaki: 
	mov cl, [ebx]	; pobranie kolejnej cyfry w kodzie 
					; ASCII 
	inc ebx			; zwiêkszenie indeksu 
	cmp cl, 10		; sprawdzenie czy naciœniêto Enter 
	je byl_enter	; skok, gdy naciœniêto Enter 
	sub cl, 30H		; zamiana kodu ASCII na wartoœæ cyfry 
	movzx ecx, cl	; przechowanie wartoœci cyfry w 
					; rejestrze ECX

; mno¿enie wczeœniej obliczonej wartoœci razy 10 
	mul dziesiec 
	add eax, ecx		; dodanie ostatnio odczytanej cyfry 
	jmp pobieraj_znaki	; skok na pocz¹tek pêtli

byl_enter:
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

END
