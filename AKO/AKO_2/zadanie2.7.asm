; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
; odpali� w konsoli chcp 1250 przed uruchomieniem

.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC 
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main

.data
naglowek		dw 'P','r','o','g','r','a','m', 0
magazyn			db 80 dup (?)
magazyn2		dw 160 dup (?)
liczba_znakow	dd ?

.code
_main PROC

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
		mov ecx, liczba_znakow
		mov ebx, 0 ; indeks pocz�tkowy
		mov eax, 0 ; indeks pocz�tkowy dla drugiej tablicy

ptl:	movzx dx, magazyn[ebx] ; pobranie kolejnego znaku w Latin-2 852

		cmp dx, 00A5h ; litera �
		je przyp1
		cmp dx, 0086h ; litera �
		je przyp2
		cmp dx, 00A9h ; litera �
		je przyp3
		cmp dx, 0088h ; litera �
		je przyp4
		cmp dx, 00E4h ; litera �
		je przyp5
		cmp dx, 00A2h ; litera �
		je przyp6
		cmp dx, 0098h ; litera �
		je przyp7
		cmp dx, 000ABh ; litera �
		je przyp8
		cmp dx, 000BEh ; litera �
		je przyp9

		cmp dx, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dx, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany
		sub dx, 20H ; zamiana na wielkie litery
		jmp dalej

przyp1:	mov dx, 104h
		jmp dalej
przyp2:	mov dx, 106h
		jmp dalej
przyp3: mov dx, 118h
		jmp dalej
przyp4:	mov dx, 141h
		jmp dalej
przyp5:	mov dx, 143h
		jmp dalej
przyp6: mov dx, 0D3h
		jmp dalej
przyp7:	mov dx, 15Ah
		jmp dalej
przyp8:	mov dx, 179h
		jmp dalej
przyp9: mov dx, 17Bh
		jmp dalej

; odes�anie znaku do pami�ci
dalej:	mov magazyn2[eax], dx
		inc ebx ; inkrementacja indeksu
		add eax, 2 ; inkrementacja indeksu drugiej tablicy
		dec ecx
		jnz ptl ; sterowanie p�tl�
; wy�wietlenie przekszta�conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET magazyn2
		push 0
		call _MessageBoxW@16 ; wy�wietlenie przekszta�conego tekstu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END