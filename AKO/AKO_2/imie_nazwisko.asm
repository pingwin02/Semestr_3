.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main

.data
tekst_pocz		db 'Prosze napisac swoje imie i nazwisko '
				db 'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
imie			db 40 dup (0)
nazwisko		db 40 dup (0)
liczba_znakow	dd ?

.code
_main PROC

; wyœwietlenie tekstu informacyjnego

; liczba znaków tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
		call __write ; wyœwietlenie tekstu pocz¹tkowego
		add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znaków
		push OFFSET magazyn
		push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znaków z klawiatury
		add esp, 12 ; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zosta³y wprowadzone
; do obszaru 'magazyn'

; funkcja read wpisuje do rejestru EAX liczbê
; wprowadzonych znaków
		mov liczba_znakow, eax
; rejestr ECX pe³ni rolê licznika obiegów pêtli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz¹tkowy dla imienia
		mov eax, 0 ; indeks pocz¹tkowy dla nazwiska

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp esi, 1 ; sprawdz czy juz nazwisko
		je nazwis
		cmp dl, ' ' ; sprawdz czy spacja
		je przesun
		mov imie[ebx], dl
		jmp dalej

przesun:mov dl, magazyn[ebx + 1] ; omin spacje
		inc ebx
nazwis: mov nazwisko[eax], dl
		mov esi, 1
		inc eax

dalej:	inc ebx
		loop ptl

; zamiana miejsc
		sub liczba_znakow, 2 ; odejmij spacje i znak nowej linii
		mov ecx, liczba_znakow
		mov ebx, 0 ; indeks pocz¹tkowy dla imienia
		mov eax, 0 ; indeks pocz¹tkowy dla nazwiska

ptl2:	mov dl, nazwisko[eax]
		cmp esi, 0 ; sprawdz czy juz imie
		je im
		cmp dl, 0ah
		je dodaj
		mov magazyn[eax], dl
		jmp dalej2

dodaj:	mov magazyn[eax], ' '
		inc eax

im:  	mov dl, imie[ebx]
		mov magazyn[eax], dl
		mov esi, 0
		inc ebx

dalej2:	inc eax
		loop ptl2

		mov magazyn[eax], 0ah
; wyœwietlenie przekszta³conego tekstu
		add liczba_znakow, 2
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wyœwietlenie przekszta³conego tekstu
		add esp, 12 ; usuniecie parametrów ze stosu
		push 0
		call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END