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

	pusha ; przechowanie rejestrów

; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie
; rejestru ESP) przeznaczonych na tymczasowe przechowanie
; cyfr szesnastkowych wyœwietlanej liczby

	sub esp, 12
	mov edi, esp	; adres zarezerwowanego obszaru
					; pamiêci

; przygotowanie konwersji
	mov ecx, 8 ; liczba obiegów pêtli konwersji
	mov esi, 1	; indeks pocz¹tkowy u¿ywany przy
				; zapisie cyfr

; pêtla konwersji
ptl3hex:

; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28
; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0
	rol eax, 4

; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy
; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym
	mov ebx, eax ; kopiowanie EAX do EBX
	and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX
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

; przes³anie cyfry do obszaru roboczego
	mov [edi + esi], dl
	inc esi ; inkrementacja modyfikatora
	loop ptl3hex ; sterowanie pêtl¹
; wpisanie znaku nowego wiersza przed i po cyfrach

	mov byte PTR [edi], 10
	mov byte PTR [edi + 9], 10

; wyœwietlenie przygotowanych cyfr
	
	push 10 ; 8 cyfr + 2 znaki nowego wiersza
	push edi ; adres obszaru roboczego
	push 1 ; nr urz¹dzenia (tu: ekran)
	call __write ; wyœwietlenie

	; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
	; przez 3 rozkazy push przed rozkazem call
	; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
	add esp, 24

	popa ; odtworzenie rejestrów
	ret ; powrót z podprogramu
wyswietl_EAX_hex ENDP

END
