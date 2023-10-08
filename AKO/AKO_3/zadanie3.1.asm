; Wydrukowanie 50 kolejnych liczb ciagu 1,2,4,7,11...

.686
.model flat
extern _ExitProcess@4 : PROC
extern wyswietl_EAX : PROC
public _main

; obszar instrukcji (rozkazów) programu
.code

_main PROC

	mov ecx, 50		; 50 elementow
	mov eax, 1		; suma
	mov ebx, 0		; dodajnik

ptl:
	add eax, ebx	; zwieksz sume o dodajnik
	inc ebx			; dodajnik zwieksza sie o 1
	call wyswietl_EAX
	loop ptl

	push 0
	call _ExitProcess@4
_main ENDP
END