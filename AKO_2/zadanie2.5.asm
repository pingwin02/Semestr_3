; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)

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
		mov ecx, eax
		mov ebx, 0 ; indeks pocz¹tkowy

ptl:	mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 0A5h ; litera ¹
		je przyp1
		cmp dl, 86h ; litera æ
		je przyp2
		cmp dl, 0A9h ; litera ê
		je przyp1
		cmp dl, 88h ; litera ³
		je przyp3
		cmp dl, 0E4h ; litera ñ
		je przyp1
		cmp dl, 0A2h ; litera ó
		je przyp4
		cmp dl, 98h ; litera œ
		je przyp1
		cmp dl, 0ABh ; litera Ÿ
		je przyp5
		cmp dl, 0BEh ; litera ¿
		je przyp1

		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany
		sub dl, 20H ; zamiana na wielkie litery
		jmp dalej

przyp1:	sub dl, 1  ; zamiana ¹,ê,ñ,œ,¿
		jmp dalej
przyp2: add dl, 9  ; zamiana æ
		jmp dalej
przyp3: add dl, 21 ; zamiana ³
		jmp dalej
przyp4: add dl, 62 ; zamiana ó
		jmp dalej
przyp5: sub dl, 30 ; zamiana Ÿ

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