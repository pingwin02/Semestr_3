.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	kat				dd 0
	kat_polpelny	dd 180.0
	tangens			dd ?
	kropka			db '.'
	nowa_linia		db 0Ah
	dokladnosc		dd 1000
	tryb_pracy		dw 037FH;

.code
wyswietl_EAX PROC

	pusha
	sub esp, 12
	mov ebp, esp

	mov [ebp], byte ptr 0		; kod null
	mov [ebp] [11], byte ptr 0	; kod null

	bt eax, 31
	jnc dodatnia
	neg eax
	mov [ebp], byte ptr '-'

	dodatnia:
	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10	; dzielnik równy 10

konwersja: 
	mov edx, 0	; zerowanie starszej czêœci dzielnej
	div ebx		; dzielenie przez 10, reszta w EDX, 
				; iloraz w EAX 
	add dl, 30H ; zamiana reszty z dzielenia na kod 
				; ASCII 
	mov [ebp] [esi], dl	; zapisanie cyfry w kodzie ASCII 
	dec esi				; zmniejszenie indeksu 
	cmp eax, 0			; sprawdzenie czy iloraz = 0 
	jne konwersja		; skok, gdy iloraz niezerowy

; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
; znaków nowego wiersza 

wypeln: 
	or esi, esi 
	jz wyswietl			; skok, gdy ESI = 0 
	mov [ebp] [esi], byte ptr 0 ; kod spacji 
	dec esi				; zmniejszenie indeksu 
	jmp wypeln 

wyswietl: 
; wyœwietlenie cyfr na ekranie 
	push 12						; liczba wyœwietlanych znaków 
	push ebp					; adres wyœw. obszaru 
	push 1						; numer urz¹dzenia (ekran ma numer 1) 
	call __write				; wyœwietlenie liczby na ekranie 
	add esp, 12					; usuniêcie parametrów ze stosu

	add esp, 12
	popa
	ret
wyswietl_EAX ENDP

_main PROC
	finit

	; zaokraglanie w dol
	mov ax, tryb_pracy
	btr ax, 11
	btc ax, 10
	mov tryb_pracy, ax

	fldcw tryb_pracy

	mov ecx, 5

ptl:
	fild kat
	fld kat_polpelny
	fdiv
	fldpi
	fmul
	; st(0) = kat w rad
	fptan
	fdiv
	; st(0) = tan(kat w rad)
	fist tangens
	mov eax, tangens
	call wyswietl_EAX

	push ecx
	push 1
	push offset kropka
	push 1
	call __write
	add esp, 12
	
	fild tangens
	; st(0) = tan_calk st(1) = tan
	fsub
	; st(0) = tan_ulamk
	fild dokladnosc
	fmul
	; st(0) = tan_ulamk*1000
	fist tangens
	mov eax, tangens

	call wyswietl_EAX

	push 1
	push offset nowa_linia
	push 1
	call __write
	add esp, 12
	pop ecx

	add kat, 15
	fstp st (0)

	loop ptl

	push 0
	call _ExitProcess@4
_main ENDP
END
