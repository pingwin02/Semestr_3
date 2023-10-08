; wczytanie liczby w postaci dziesietnej
; i wyswietlenie jej w postaci szesnastkowej

.686
.model flat
extern _ExitProcess@4 : PROC
extern wczytaj_do_EAX : PROC
extern wyswietl_EAX_hex : PROC
public _main

.code

_main PROC

	call wczytaj_do_EAX
	call wyswietl_EAX_hex

	push 0
	call _ExitProcess@4
_main ENDP
END
