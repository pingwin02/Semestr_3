; Wyswietlanie liczby z EAX w postaci binarnej

.686
.model flat
extern __write : PROC

.data

liczba_4 db 4

.code
wyswietl_EAX_bin PROC

	pusha

	sub esp, 42 ; rezerwacja 42 bajtow, 32 na kazdy bit w eax 
				; 2 na kody nowej linii i 8 na spacje
	mov ebp, esp ; zachowanie adresu 

	mov ecx, 32 ; liczba obiegow petli
	mov esi, 1 ; indeks poczatkowy

ptl:
	; sprawdzenie czy licznik petli jest podzielny przez 4
	; jesli tak, wstaw spacje
	push eax
	mov eax, ecx
	div liczba_4
	or ah, ah
	jnz kontynuuj
	mov byte ptr [ebp + esi], ' '
	inc esi
kontynuuj:
	pop eax
	rol eax, 1
	mov ebx, eax ; kopia rejestru eax do ebx
	and ebx, 1 ; nalozenie maski, ostatni bit zostaje nie zmieniony
	add ebx, 30H ; konwersja bitu na kod ASCII
	mov [ebp + esi], bl
	inc esi
	loop ptl

	mov byte ptr [ebp], 0AH
	mov byte ptr [ebp + 41], 0AH

	push 42 ; 32 cyfry + 2 znaki nowego wiersza + 8 spacje
	push ebp ; adres obszaru roboczego
	push 1 ; nr urz¹dzenia (tu: ekran)
	call __write ; wyœwietlenie

	add esp, 54 ; usuniecie ze stosu tablicy z kodami ASCII

	popa
	ret
wyswietl_EAX_bin ENDP
END