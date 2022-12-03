; wczytanie liczby w postaci szesnastkowej 
; i wyswietlenie jej w postaci dziesietnej

.686
.model flat
extern _ExitProcess@4 : PROC
extern wczytaj_do_EAX_hex : PROC
extern wyswietl_EAX : PROC
public _main

.code

_main PROC

	call wczytaj_do_EAX_hex
	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END
