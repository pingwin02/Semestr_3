; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
; odpali� w konsoli chcp 1250 przed uruchomieniem

.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC 
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main

.data
tekst_pocz		db 'Prosz� napisa� jaki� tekst '
				db 'i nacisn�� Enter', 0
naglowek		db 'Program', 0
magazyn			db 80 dup (?)
liczba_znakow	dd ?

.code
_main PROC

; wy�wietlenie tekstu informacyjnego

; liczba znak�w tekstu
		push 0
		push OFFSET naglowek
		push OFFSET tekst_pocz ; adres tekstu
		push 0
		call _MessageBoxA@16 ; wy�wietlenie tekstu pocz�tkowego
; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znak�w
		push OFFSET magazyn
		push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znak�w z klawiatury
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'

; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
		mov liczba_znakow, eax
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz�tkowy

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 0B9h ; litera �
		je przyp3
		cmp dl, 0E6h ; litera �
		je przyp2
		cmp dl, 0EAh ; litera �
		je przyp2
		cmp dl, 0B3h ; litera �
		je przyp1
		cmp dl, 0F1h ; litera �
		je przyp2
		cmp dl, 0F3h ; litera �
		je przyp2
		cmp dl, 09Ch ; litera �
		je przyp1
		cmp dl, 09Fh ; litera �
		je przyp1
		cmp dl, 0BFh ; litera �
		je przyp1

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany
		sub dl, 20H ; zamiana na wielkie litery
		jmp dalej

przyp1:	sub dl, 10h  ; zamiana �, �, �, �
		jmp dalej
przyp2:	sub dl, 20h  ; zamiana �, �, �, �
		jmp dalej
przyp3: mov dl, 0A5h ; zamiana �
		jmp dalej

; odes�anie znaku do pami�ci
dalej:	mov magazyn[ebx], dl
		inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie p�tl�
; wy�wietlenie przekszta�conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET magazyn
		push 0
		call _MessageBoxA@16 ; wy�wietlenie przekszta�conego tekstu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END