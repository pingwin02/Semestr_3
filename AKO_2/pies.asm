.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main
.data
tekst_pocz			db 10, 'Prosze napisac jakis tekst '
					db 'i nacisnac Enter', 10
koniec_t			db ?
magazyn				db 80 dup (0)
wynik				db 80 dup (0)
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

	dec eax	;usuniecie nowej linii
	mov ecx, eax ;liczba znakow
	mov ebx, 0 ; indeks magazynu
	mov eax, 0 ; indeks wyniku
	mov edx, 0 

	ptl:
	cmp magazyn[ebx-1], ' '
	jne poczatek

	idzDalej:
	cmp magazyn[ebx], 'p'
	jne dalej
	cmp magazyn[ebx+1], 'i'
	jne dalej
	cmp magazyn[ebx+2], 'e'
	jne dalej
	cmp magazyn[ebx+3], 's'
	jne dalej
	cmp magazyn[ebx+4], ' '
	jne sprawdzKoniec

	usunSlowo:
	inc dh
	add ebx, 4
	sub ecx, 4
	jz wyjatek
	jmp dalej

	wyjatek:
	inc ecx
	jmp dalej

	poczatek:
	cmp magazyn[ebx-1], 0
	jne dalej
	jmp idzDalej

	sprawdzKoniec:
	cmp magazyn[ebx+4], 10
	je usunSlowo
	cmp magazyn[ebx+4], '.'
	je usunSlowo

	dalej:
	mov dl, magazyn[ebx]
	mov wynik[eax], dl
	inc eax
	inc ebx
	loop ptl

	add dh, 30h
	mov wynik[eax], dh
	inc eax

	push eax
	push OFFSET wynik
	push 1
	call __write ; wyœwietlenie przekszta³conego tekstu
	add esp, 12 ; usuniecie parametrów ze stosu

	push 0 ; kod powrotu programu
	call _ExitProcess@4
	_main ENDP
END