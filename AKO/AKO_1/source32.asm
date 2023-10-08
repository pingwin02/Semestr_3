; program przyk�adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4			: PROC
extern __write : PROC			; (dwa znaki podkre�lenia)
public _main

.data
tekst	db 10, 'Nazywam sie . . . ' , 10
		db 'Moj pierwszy 32-bitowy program '
		db 'asemblerowy dziala juz poprawnie!', 10

.code
_main PROC

; obliczenie sumy wyraz�w ci�gu 3 + 5 + 7 + 9 + 11

; obliczenie bez u�ycia p�tli rozkazowej
	mov eax, 3					; pierwszy element ci�gu
	add eax, 5					; dodanie drugiego elementu
	add eax, 7					; dodanie trzeciego elementu
	add eax, 9					; dodanie czwartego elementu
	add eax, 11					; dodanie pi�tego elementu

; obliczenie z u�yciem p�tli rozkazowej
	mov eax, 0					; pocz�tkowa warto�� sumy
	mov ebx, 3					; pierwszy element ci�gu
	mov ecx, 5					; liczba obieg�w p�tli
	ptl: add eax, ebx			; dodanie kolejnego elementu
	add ebx, 2					; obliczenie nast�pnego elementu
	sub ecx, 1					; zmniejszenie licznka obieg�w p�tli
	jnz ptl						; skok, gdy licznik obieg�w r�ny od 0

	mov ecx, 85					; liczba znak�w wy�wietlanego tekstu

; wywo�anie funkcji �write� z biblioteki j�zyka C

	push ecx					; liczba znak�w wy�wietlanego tekstu
	push dword PTR OFFSET tekst ; po�o�enie obszaru ze znakami
	push dword PTR 1			; uchwyt urz�dzenia wyj�ciowego
	call __write				; wy�wietlenie znak�w (dwa znaki podkre�lenia _ )
	add esp, 12					; usuni�cie parametr�w ze stosu

; zako�czenie wykonywania programu

	push dword PTR 0			; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END