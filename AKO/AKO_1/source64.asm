; program przyk�adowy (wersja 64-bitowa)
extern _write		: PROC
extern ExitProcess	: PROC
public main

.data
tekst	db 10, 'Nazywam sie . . . ' , 10
		db 'Moj pierwszy 64-bitowy program asemblerowy '
		db 'dziala juz poprawnie!', 10

.code
main PROC
	mov rcx, 1				; uchwyt urz�dzenia wyj�ciowego
	mov rdx, OFFSET tekst	; po�o�enie obszaru ze znakami
; liczba znak�w wy�wietlanego tekstu
	mov r8, 85
; przygotowanie obszaru na stosie dla funkcji _write
	sub rsp, 40
; wywo�anie funkcji �_write� z biblioteki j�zyka C
	call _write
; usuni�cie ze stosu wcze�niej zarezerwowanego obszaru
	add rsp, 40
; wyr�wnanie zawarto�ci RSP, tak by by�a podzielna przez 16
	sub rsp, 8
; zako�czenie wykonywania programu
	mov rcx, 0				; kod powrotu programu
	call ExitProcess
main ENDP

END