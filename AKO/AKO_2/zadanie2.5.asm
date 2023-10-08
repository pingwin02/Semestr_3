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
magazyn			db 80 dup (?)
nowa_linia		db 10
liczba_znakow	dd ?

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
		mov liczba_znakow, eax
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz�tkowy

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 0A5h ; litera �
		je przyp1
		cmp dl, 86h ; litera �
		je przyp2
		cmp dl, 0A9h ; litera �
		je przyp1
		cmp dl, 88h ; litera �
		je przyp3
		cmp dl, 0E4h ; litera �
		je przyp1
		cmp dl, 0A2h ; litera �
		je przyp4
		cmp dl, 98h ; litera �
		je przyp1
		cmp dl, 0ABh ; litera �
		je przyp5
		cmp dl, 0BEh ; litera �
		je przyp1

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany
		sub dl, 20H ; zamiana na wielkie litery
		jmp dalej

przyp1:	sub dl, 1  ; zamiana �,�,�,�,�
		jmp dalej
przyp2: add dl, 9  ; zamiana �
		jmp dalej
przyp3: add dl, 21 ; zamiana �
		jmp dalej
przyp4: add dl, 62 ; zamiana �
		jmp dalej
przyp5: sub dl, 30 ; zamiana �

; odes�anie znaku do pami�ci
dalej:	mov magazyn[ebx], dl
		inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie p�tl�
; wy�wietlenie przekszta�conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wy�wietlenie przekszta�conego tekstu
		add esp, 12 ; usuniecie parametr�w ze stosu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END