; program przyk³adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4			: PROC
extern __write : PROC			; (dwa znaki podkreœlenia)
public _main

.data
tekst	db 10, 'Nazywam sie . . . ' , 10
		db 'Moj pierwszy 32-bitowy program '
		db 'asemblerowy dziala juz poprawnie!', 10

.code
_main PROC

; obliczenie sumy wyrazów ci¹gu 3 + 5 + 7 + 9 + 11

; obliczenie bez u¿ycia pêtli rozkazowej
	mov eax, 3					; pierwszy element ci¹gu
	add eax, 5					; dodanie drugiego elementu
	add eax, 7					; dodanie trzeciego elementu
	add eax, 9					; dodanie czwartego elementu
	add eax, 11					; dodanie pi¹tego elementu

; obliczenie z u¿yciem pêtli rozkazowej
	mov eax, 0					; pocz¹tkowa wartoœæ sumy
	mov ebx, 3					; pierwszy element ci¹gu
	mov ecx, 5					; liczba obiegów pêtli
	ptl: add eax, ebx			; dodanie kolejnego elementu
	add ebx, 2					; obliczenie nastêpnego elementu
	sub ecx, 1					; zmniejszenie licznka obiegów pêtli
	jnz ptl						; skok, gdy licznik obiegów ró¿ny od 0

	mov ecx, 85					; liczba znaków wyœwietlanego tekstu

; wywo³anie funkcji ”write” z biblioteki jêzyka C

	push ecx					; liczba znaków wyœwietlanego tekstu
	push dword PTR OFFSET tekst ; po³o¿enie obszaru ze znakami
	push dword PTR 1			; uchwyt urz¹dzenia wyjœciowego
	call __write				; wyœwietlenie znaków (dwa znaki podkreœlenia _ )
	add esp, 12					; usuniêcie parametrów ze stosu

; zakoñczenie wykonywania programu

	push dword PTR 0			; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END