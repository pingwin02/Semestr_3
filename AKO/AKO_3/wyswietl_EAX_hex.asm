; Wyswietlanie liczby z EAX w postaci szesnastkowej

.686
.model flat
extern __write : PROC

.data

; deklaracja tablicy do konwersji liczby binarnej na hex
	dekoder db '0123456789ABCDEF'

; zmienna wykrywajaca poczatek liczby
	czujka		db 0

.code
wyswietl_EAX_hex PROC

	pusha ; przechowanie rejestr�w

; rezerwacja 12 bajt�w na stosie (poprzez zmniejszenie
; rejestru ESP) przeznaczonych na tymczasowe przechowanie
; cyfr szesnastkowych wy�wietlanej liczby

	sub esp, 12
	mov edi, esp	; adres zarezerwowanego obszaru
					; pami�ci

; przygotowanie konwersji
	mov ecx, 8 ; liczba obieg�w p�tli konwersji
	mov esi, 1	; indeks pocz�tkowy u�ywany przy
				; zapisie cyfr

; p�tla konwersji
ptl3hex:

; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo
; w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28
; rejestru EAX zostan� przesuni�te na pozycje 3 - 0
	rol eax, 4

; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy
; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym
	mov ebx, eax ; kopiowanie EAX do EBX
	and ebx, 0000000FH ; zerowanie bit�w 31 - 4 rej.EBX
	mov dl, dekoder[ebx] ; pobranie cyfry z tablicy

; usuwanie wiodacych zer
	cmp dl, '0'
	jne start_liczby
	cmp czujka, 0
	jne dalej
	mov dl, ' '
	jmp dalej
start_liczby:
	mov czujka, 1
dalej:	

; przes�anie cyfry do obszaru roboczego
	mov [edi + esi], dl
	inc esi ; inkrementacja modyfikatora
	loop ptl3hex ; sterowanie p�tl�
; wpisanie znaku nowego wiersza przed i po cyfrach

	mov byte PTR [edi], 10
	mov byte PTR [edi + 9], 10

; wy�wietlenie przygotowanych cyfr
	
	push 10 ; 8 cyfr + 2 znaki nowego wiersza
	push edi ; adres obszaru roboczego
	push 1 ; nr urz�dzenia (tu: ekran)
	call __write ; wy�wietlenie

	; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych
	; przez 3 rozkazy push przed rozkazem call
	; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu
	add esp, 24

	popa ; odtworzenie rejestr�w
	ret ; powr�t z podprogramu
wyswietl_EAX_hex ENDP

END
