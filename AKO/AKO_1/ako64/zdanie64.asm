; program przykładowy (wersja 64-bitowa)
extern _write : PROC
extern ExitProcess : PROC
public main
.data
tekst db 10, 'Nazywam sie . . . ' , 10
db 'Moj pierwszy 64-bitowy program asemblerowy '
db 'dziala juz poprawnie!', 10
.code
main PROC
mov rcx, 1 ; uchwyt urządzenia wyjściowego
mov rdx, OFFSET tekst ; położenie obszaru ze znakami
; liczba znaków wyświetlanego tekstu
mov r8, 85
; przygotowanie obszaru na stosie dla funkcji _write
sub rsp, 40
; wywołanie funkcji ”_write” z biblioteki języka C
call _write
; usunięcie ze stosu wcześniej zarezerwowanego obszaru
add rsp, 40
; wyrównanie zawartości RSP, tak by była podzielna przez 16
sub rsp, 8
; zakończenie wykonywania programu
mov rcx, 0 ; kod powrotu programu
call ExitProcess
main ENDP
END