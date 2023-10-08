; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxA@16 : PROC 
public _main

.data
tekst_pocz		db 10, 'Prosze napisac jakis tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
naglowek		db 'Konwersja', 0
magazyn			db 80 dup (?)
przerobiony     db 80 dup (?)

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
; rejestr ECX pe³ni rolê licznika obiegów pêtli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz¹tkowy
		mov eax, 0 ; liczba znakow po konwersji

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, '/'
		jne dalej

		inc ebx;
		mov dl, magazyn[ebx]
		dec ecx;

		cmp dl, 'A'
		je przypA
		cmp dl, 'C'
		je przypC
		cmp dl, 'E'
		je przypE
		cmp dl, 'L'
		je przypL
		cmp dl, 'N'
		je przypN
		cmp dl, 'O'
		je przypO
		cmp dl, 'S'
		je przypS
		cmp dl, 'Z'
		je przypZ
		cmp dl, 'a'
		je przypa1
		cmp dl, 'c'
		je przypc1
		cmp dl, 'e'
		je przype1
		cmp dl, 'l'
		je przypl1
		cmp dl, 'n'
		je przypn1
		cmp dl, 'o'
		je przypo1
		cmp dl, 's'
		je przyps1
		cmp dl, 'z'
		je przypz1

; nie wykryl znaku
		dec ebx;
		mov dl, magazyn[ebx]
		inc ecx;
		jmp dalej

przypA: mov dl, '¥'
		jmp dalej
przypC: mov dl, 'Æ'
		jmp dalej
przypE: mov dl, 'Ê'
		jmp dalej
przypL: mov dl, '£'
		jmp dalej
przypN: mov dl, 'Ñ'
		jmp dalej
przypO: mov dl, 'Ó'
		jmp dalej
przypS: mov dl, 'Œ'
		jmp dalej
przypZ: mov dl, '¯'
		jmp dalej
przypa1: mov dl, '¹'
		jmp dalej
przypc1: mov dl, 'æ'
		jmp dalej
przype1: mov dl, 'ê'
		jmp dalej
przypl1: mov dl, '³'
		jmp dalej
przypn1: mov dl, 'ñ'
		jmp dalej
przypo1: mov dl, 'ó'
		jmp dalej
przyps1: mov dl, 'œ'
		jmp dalej
przypz1: mov dl, '¿'
		jmp dalej

; odes³anie znaku do pamiêci
dalej:	mov przerobiony[eax], dl
		inc ebx ; inkrementacja indeksu
		inc eax ; inkrementacja indeksu drugiej tablicy
		dec ecx ; sterowanie pêtl¹
		jne ptl
; wyœwietlenie przekszta³conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET przerobiony
		push 0
		call _MessageBoxA@16
		push 0
		call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END