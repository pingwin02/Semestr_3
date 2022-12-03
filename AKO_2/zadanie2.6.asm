; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
; odpaliæ w konsoli chcp 1250 przed uruchomieniem

.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC 
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main

.data
tekst_pocz		db 'Proszê napisaæ jakiœ tekst '
				db 'i nacisn¹æ Enter', 0
naglowek		db 'Program', 0
magazyn			db 80 dup (?)
liczba_znakow	dd ?

.code
_main PROC

; wyœwietlenie tekstu informacyjnego

; liczba znaków tekstu
		push 0
		push OFFSET naglowek
		push OFFSET tekst_pocz ; adres tekstu
		push 0
		call _MessageBoxA@16 ; wyœwietlenie tekstu pocz¹tkowego
; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znaków
		push OFFSET magazyn
		push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znaków z klawiatury
; kody ASCII napisanego tekstu zosta³y wprowadzone
; do obszaru 'magazyn'

; funkcja read wpisuje do rejestru EAX liczbê
; wprowadzonych znaków
		mov liczba_znakow, eax
; rejestr ECX pe³ni rolê licznika obiegów pêtli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz¹tkowy

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 0B9h ; litera ¹
		je przyp3
		cmp dl, 0E6h ; litera æ
		je przyp2
		cmp dl, 0EAh ; litera ê
		je przyp2
		cmp dl, 0B3h ; litera ³
		je przyp1
		cmp dl, 0F1h ; litera ñ
		je przyp2
		cmp dl, 0F3h ; litera ó
		je przyp2
		cmp dl, 09Ch ; litera œ
		je przyp1
		cmp dl, 09Fh ; litera Ÿ
		je przyp1
		cmp dl, 0BFh ; litera ¿
		je przyp1

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany
		sub dl, 20H ; zamiana na wielkie litery
		jmp dalej

przyp1:	sub dl, 10h  ; zamiana ³, œ, Ÿ, ¿
		jmp dalej
przyp2:	sub dl, 20h  ; zamiana æ, ê, ñ, ó
		jmp dalej
przyp3: mov dl, 0A5h ; zamiana ¹
		jmp dalej

; odes³anie znaku do pamiêci
dalej:	mov magazyn[ebx], dl
		inc ebx ; inkrementacja indeksu
		loop ptl ; sterowanie pêtl¹
; wyœwietlenie przekszta³conego tekstu
		push 0
		push OFFSET naglowek
		push OFFSET magazyn
		push 0
		call _MessageBoxA@16 ; wyœwietlenie przekszta³conego tekstu
		push 0
		call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END