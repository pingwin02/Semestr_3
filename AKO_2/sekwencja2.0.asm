; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main

.data
tekst_pocz		db 10, 'Prosze napisac jakis tekst '
				db 'i nacisnac Enter', 10
koniec_t		db ?
naglowek		db 'Konwersja', 0
magazyn			db 80 dup (?)
przerobiony     db 80 dup (?)
indexkon		dd ?
flaga			db 0

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
		mov esi, 0 ; esi trzyma indeks poczatku wyrazu do kopiowania

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, ' '
		jne dalej

		mov dl, magazyn[ebx + 1]
		cmp dl, '\'
		jne zapisz

		mov dl, magazyn[ebx + 2]
		cmp dl, 'd'
		jne zapisz

		cmp flaga, 0
		jne idz
		mov indexkon, ebx
		mov flaga, 1
		
idz:	push ecx
		mov edi, 0
		mov ecx, indexkon;
		sub ecx, esi;
		jz wyjatek
koont:	mov przerobiony[eax], ' '
kop:	inc eax
		mov dl, magazyn[esi + edi]
		mov przerobiony[eax], dl
		inc edi
		loop kop

		pop ecx
		sub ecx, 2
		add ebx, 2
		jmp dalej2

wyjatek:mov ecx, 1
		jmp koont

zapisz:	lea esi, [ebx + 1]
		mov indexkon, ebx
		inc indexkon
		mov flaga, 0
		jmp cofnij


cofnij:	mov dl, magazyn[ebx]
		
; odes�anie znaku do pami�ci
dalej:	mov przerobiony[eax], dl
dalej2:	inc ebx ; inkrementacja indeksu
		inc eax ; inkrementacja indeksu drugiej tablicy
		dec ecx
		jnz ptl ; sterowanie petla
; wy�wietlenie przekszta�conego tekstu
		push eax
		push OFFSET przerobiony
		push 1
		call __write ; wy�wietlenie przekszta�conego tekstu
		add esp, 12 ; usuniecie parametr�w ze stosu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END