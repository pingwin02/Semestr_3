.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy


linia PROC
; przechowanie rejestrów
	push ax
	push bx
	push ds
	push dx
	mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
	mov ds, ax
	mov bx, cs:adres_piksela ; adres bieżący piksela
	mov al, cs:kolor
; przejście do następnego wiersza na ekranie
	
	cmp cs:kierunek, word ptr 72
	je gora
	cmp cs:kierunek, word ptr 80
	je dol
	cmp cs:kierunek, word ptr 75 
	je lewo
	cmp cs:kierunek, word ptr 77
	je prawo
	jmp dalej

gora:
	sub bx, 320
	cmp bx, 199
	ja dalej
	add bx, 320*199
	jmp dalej
dol:
	add bx, 320
	cmp bx, 320*199
	jb dalej
	sub bx, 320*199
	jmp dalej
lewo:
	sub bx, 1
	cmp bx, 0
	ja dalej
	add bx, 199
	jmp dalej
prawo:
	add bx, 1
	cmp bx, 199
	ja dalej
	sub bx, 199
	jmp dalej


; zapisanie adresu bieżącego piksela
dalej:
	; inc cs:kolor
	mov ds:[bx], al
	mov cs:adres_piksela, bx
; odtworzenie rejestrów
	pop dx
	pop ds
	pop bx
	pop ax
; skok do oryginalnego podprogramu obsługi przerwania
; zegarowego
	jmp dword PTR cs:wektor8
; zmienne procedury
	kolor db 0fh ; bieżący numer koloru
	adres_piksela dw 320*90+140 ; bieżący adres piksela
	wektor8 dd ?
	kierunek dw 80 ; 80 - dol, 77 - lewo, 75 - prawo, 72 - gora
linia ENDP

obsluga_klawiatury PROC
; przechowanie używanych rejestrów
	push ax
	
	xor ax, ax
	in al, 60h
	cmp al, byte ptr 80
	je wpisz
	cmp al, byte ptr 75
	je wpisz
	cmp al, byte ptr 77
	je wpisz
	cmp al, byte ptr 72
	je wpisz
	jmp dalej2

wpisz:
	mov cs:kierunek, ax

dalej2:
	pop ax
; skok do oryginalnej procedury obsługi przerwania zegarowego
	jmp dword PTR cs:wektor9
; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
	wektor9 dd ?
obsluga_klawiatury ENDP

; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
	mov ah, 0
	mov al, 13H ; nr trybu
	int 10H
	mov bx, 0
	mov ds, bx ; zerowanie rejestru ds
	mov eax, ds:[32] ; odczytanie wektora nr 8
	mov cs:wektor8, eax; zapamiętanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
	mov ax, SEG linia
	mov bx, OFFSET linia
	cli ; zablokowanie przerwań
; zapisanie adresu procedury 'linia' do wektora nr 8
	mov ds:[32], bx
	mov ds:[34], ax
	sti ; odblokowanie przerwań

;=====================================================
; OBSLUGA KLAWIATURY
	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS
; odczytanie zawartości wektora nr 9 i zapisanie go
; w zmiennej 'wektor9' (wektor nr 9 zajmuje w pamięci 4 bajty
; począwszy od adresu fizycznego 1 * 4 = 4)
	mov eax,ds:[36] ; adres fizyczny 2*16 + 4 = 36
	mov cs:wektor9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_klawiatury ; część segmentowa adresu
	mov bx, OFFSET obsluga_klawiatury ; offset adresu
	cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 8
	mov ds:[36], bx ; OFFSET
	mov ds:[38], ax ; cz. segmentowa
	sti ;odblokowanie przerwań

czekaj:
	mov ah, 1 ; sprawdzenie czy jest jakiś znak
	int 16h ; w buforze klawiatury
	jz czekaj

	mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
	int 16h
	cmp ah, 1
	jne czekaj
; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	mov edx, cs:wektor9
	cli
	mov ds:[32], eax
	mov ds:[36], edx
	sti
; zakończenie wykonywania programu
    mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
    mov al, 3H ; nr trybu
    int 10H

	mov ax, 4C00H
	int 21H
rozkazy ENDS

stosik SEGMENT stack
	db 256 dup (?)
stosik ENDS

END zacznij
