; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxW@16 : PROC 
public _main

.data
tekst_pocz		db 10, 'Prosze napisac jakis tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
naglowek		dw 'K','o','n','w','e','r','s','j','a', 0
magazyn			db 32 dup (?)
tekst_info		dw '0',' ','0',' ', 0D83Dh, 0DC14h, 0
maksimum		db 0
maksindeks		db 0
tab_pl			db 0A5H, 0A4H, 86H, 8FH, 0A9H, 0A8H, 88H, 9DH, 0E4H
				db 0E3H, 0A2H, 0E0H, 98H, 97H, 0ABH, 8DH, 0BEH, 0DBH
ilosc_pl		db ?

.code
_main PROC

; wy�wietlenie tekstu informacyjnego

; liczba znak�w tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz�dzenia (tu: ekran - nr 1)
		call __write ; wy�wietlenie tekstu pocz�tkowego
		add esp, 12 ; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
		push 32 ; maksymalna liczba znak�w
		push OFFSET magazyn
		push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znak�w z klawiatury
		add esp, 12 ; usuniecie parametr�w ze stosu
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'

; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov eax, 0 ; licznik polskich znakow w wyrazie
		mov ebx, 0 ; indeks pocz�tkowy
		mov edx, 0 ; indeks wyrazu

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, ' '
		je zapisz
		cmp dl, 0AH
		je zapisz

		push ecx
		mov ecx, OFFSET ilosc_pl - OFFSET tab_pl
znak:	cmp dl, tab_pl[ecx - 1]
		je inkrem
powrot:	loop znak
		pop ecx
		jmp dalej

inkrem:	inc al
		jmp powrot
zapisz:	cmp al, maksimum
		ja nowymax
reset:	mov al, 0 ; zresetuj licznik liter
		inc dh
		jmp dalej

nowymax:mov maksimum, al
		mov maksindeks, dh
		jmp reset

; odes�anie znaku do pami�ci
dalej:	inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie petla

		mov al, maksimum
		add al, 30h
		mov byte ptr tekst_info[4], al

		mov bl, maksindeks
		add bl, 30h
		mov byte ptr tekst_info[0], bl

; wy�wietlenie przekszta�conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET tekst_info
		push 0
		call _MessageBoxW@16 ; wy�wietlenie przekszta�conego tekstu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END