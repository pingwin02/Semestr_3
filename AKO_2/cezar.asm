.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main

.data
tekst_pocz		db 10, 'Prosze napisac jakis tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
magazyn			db 80 dup (?)
nowa_linia		db 10
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
		mov ecx, liczba_znakow
		mov ebx, 0 ; indeks pocz¹tkowy

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 32
		jb dalej ; skok, gdy znak nie zawiera sie w przedziale
		cmp dl, 125
		ja dalej ; skok gdy znak nie zawiera sie w przedziale
		add dl, 97 ; zakodowanie
		cmp dl, 125
		ja korekta
		jmp dalej

korekta:	sub dl, 94
			cmp dl, 125
			ja korekta
		
; odes³anie znaku do pamiêci
dalej:	mov magazyn[ebx], dl
		inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie pêtl¹
; wyœwietlenie przekszta³conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wyœwietlenie przekszta³conego tekstu
		add esp, 12 ; usuniecie parametrów ze stosu
		push 0
		call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END