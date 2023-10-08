; Przyk�ad wywo�ywania funkcji MessageBoxA i MessageBoxW
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst_pocz			db 10, 'Prosze napisac jakis tekst '
					db 'i nacisnac Enter', 10
koniec_t			db ?
tytul_UTF_16		dw 'I','n','f','o','r','m','a','c','j','a', 0
magazyn				db 80 dup (0)
wynik				dw 80 dup (0)
kotek				dw 0d83dh, 0de3ah
koniec_m			db ?
nowa_linia			dw 10
liczba_znakow		dd ?
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
	mov ecx, eax ;ecx liczba znakow
	mov ebx, 0 ;ebx indeks magazynu
	mov eax, 0 ;eax indeks wyniku  ;polak

	ptl:
	mov dl, magazyn[ebx]
	cmp dl, 'k'
	je jestK
	jmp dalej

	jestK:
	mov dl, magazyn[ebx+1]
	cmp dl, 'o'
	je jestO
	jmp dalej

	jestO:
	mov dl, magazyn[ebx+2]
	cmp dl, 't'
	je jestT
	jmp dalej

	jestT:
	inc al
	jmp dalej

	dalej:
	inc ebx 
	loop ptl

	mov ecx, eax
	mov ebx, 0 ;ebx indeks magazynu
	kotkaWypisuje:
	mov dx, kotek[0] 
	mov wynik[ebx], dx
	add ebx, 2
	mov dx, kotek[2] 
	mov wynik[ebx], dx
	add ebx, 2
	loop kotkaWypisuje

	push 0 ; stala MB_OK
; adres obszaru zawieraj�cego tytu�
	push OFFSET tytul_UTF_16
; adres obszaru zawieraj�cego tekst
	push OFFSET wynik
	push 0 ; NULL
	call _MessageBoxW@16

	push 0 ; kod powrotu programu
	call _ExitProcess@4
	_main ENDP
END