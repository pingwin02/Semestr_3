; Wczytanie liczby w postaci dziesietnej,
; podniesienie do kwadratu 
; i wyswietlenie jej na ekranie

.686
.model flat
extern _ExitProcess@4 : PROC
extern wczytaj_do_EAX : PROC
extern wyswietl_EAX : PROC
public _main

.code

_main PROC

	call wczytaj_do_EAX
	mul eax ; kwadrat liczby w eax
	call wyswietl_EAX

	push 0
	call _ExitProcess@4
_main ENDP
END