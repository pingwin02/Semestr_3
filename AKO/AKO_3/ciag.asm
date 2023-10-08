.686
.model flat

public _main
extern __write : PROC
extern _ExitProcess@4 : PROC

.data
znaki db 12 dup (?) ; deklaracja do przechowywania tworzonych cyfr
obszar db 14 dup (?) ; cyfry bez pustego pola po lewej
znak db ' '

.code

ciag_liczb PROC
	pusha
	mov eax, 1 ; pierwszy element
	mov ecx, 0 ; licznik petli oraz argument do sumowania
	mov dx, 0 ; FLAG 0 - odejmowanie, 1 - dodawanie

	sprawdz:
	call wyswietl_EAX_1
	inc ecx
	cmp dx, 0
	je odejmowanie
	jne dodawanie
	dodawanie:
	add eax, ecx
	xor dx, dx
	cmp ecx, 30
	je koniec
	jne sprawdz
	odejmowanie:
	neg ecx
	add eax, ecx
	neg ecx
	inc dx
	cmp ecx, 30
	je koniec
	jne sprawdz

	; dodajemy do EAX wartosc ECX
	; DX = 0 -> odejmowanie next

	; negowanie ECX

	koniec:
	popa
	ret
ciag_liczb ENDP

wyswietl_EAX_1 PROC

	pusha
	rol eax, 1
	jnc dodatnia
	mov znak, '-'
	ror eax, 1
	neg eax

	; rotacja bitow w prawo by sprawdzic bit znaku
	; dodanie - do outputu
	; powrot do oryginalnej liczby


	jmp przedKonwersja
	dodatnia:
	ror eax, 1
	przedKonwersja:
	mov esi, 10
	mov ebx, 10

	; indeks w tablicy 'znaki'
	; dzielnik

	konwersja:
	mov edx, 0	; zerowanie starszej czesci dzielnej
	div ebx	; dzielenie przez 10, reszta w EDX - iloraz w EAX
	add dl, 30h	; zamiana reszty z dzielenia na kod ASCII
	mov znaki[esi], dl	; zapisanie cyfry w kodzie ASCII
	dec esi	; zmniejszenie indeks
	cmp eax, 0	; sprawdzenie czy iloraz = 0
	jne konwersja

	; znak liczby
	mov cl, znak
	mov znaki[esi], cl
	dec esi
	; wypelnienie pozostalych bajtow spacjami
	wypeln:
	or esi, esi
	jz wyswietl
	; gdy indeks = 0
	mov byte PTR znaki[esi], 20h ; kod spacji
	dec esi
	jmp wypeln
	; pozbycie sie spacji z wyswietlanego kodu
	; i wyswietlenie go
	wyswietl:
	mov ecx, 1
	mov edx, 1

	; indeks znaki
	; indeks obszar

	spacja:
	inc ecx
	przesuwanie:
	mov al, znaki[ecx]
	cmp al, 20h
	je spacja
	cmp al, 0Ah
	je koniec
	przepisz:
	mov obszar[edx], al
	inc edx
	inc ecx
	cmp ecx, 12
	jb przesuwanie
	koniec:
	mov byte PTR obszar[0], 0Ah
	; kod nowego wiersza
	mov byte PTR obszar[edx], 0Ah

	push dword PTR edx
	push dword PTR OFFSET obszar
	push dword PTR 1
	call __write
	mov znak, ' '
	add esp, 12
	popa
	ret
wyswietl_EAX_1 ENDP

_main PROC

call ciag_liczb
push 0
call _ExitProcess@4
_main ENDP

END