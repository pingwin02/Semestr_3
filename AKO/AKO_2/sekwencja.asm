; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
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

; wy�wietlenie tekstu informacyjnego

; liczba znak�w tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz�dzenia (tu: ekran - nr 1)
		call __write ; wy�wietlenie tekstu pocz�tkowego
		add esp, 12 ; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znak�w
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
		mov ebx, 0 ; indeks pocz�tkowy
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

przypA: mov dl, '�'
		jmp dalej
przypC: mov dl, '�'
		jmp dalej
przypE: mov dl, '�'
		jmp dalej
przypL: mov dl, '�'
		jmp dalej
przypN: mov dl, '�'
		jmp dalej
przypO: mov dl, '�'
		jmp dalej
przypS: mov dl, '�'
		jmp dalej
przypZ: mov dl, '�'
		jmp dalej
przypa1: mov dl, '�'
		jmp dalej
przypc1: mov dl, '�'
		jmp dalej
przype1: mov dl, '�'
		jmp dalej
przypl1: mov dl, '�'
		jmp dalej
przypn1: mov dl, '�'
		jmp dalej
przypo1: mov dl, '�'
		jmp dalej
przyps1: mov dl, '�'
		jmp dalej
przypz1: mov dl, '�'
		jmp dalej

; odes�anie znaku do pami�ci
dalej:	mov przerobiony[eax], dl
		inc ebx ; inkrementacja indeksu
		inc eax ; inkrementacja indeksu drugiej tablicy
		dec ecx ; sterowanie p�tl�
		jne ptl
; wy�wietlenie przekszta�conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET przerobiony
		push 0
		call _MessageBoxA@16
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END