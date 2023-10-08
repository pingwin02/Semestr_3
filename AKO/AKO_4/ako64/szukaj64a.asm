public szukaj64_max

.code
szukaj64_max PROC
	push rbx ; przechowanie rejestr�w
	push rsi
	mov rbx, rcx ; adres tablicy
	mov rcx, rdx ; liczba element�w tablicy
	mov rsi, 0 ; indeks bie��cy w tablicy
; w rejestrze RAX przechowywany b�dzie najwi�kszy dotychczas
; znaleziony element tablicy - na razie przyjmujemy, �e jest
; to pierwszy element tablicy
	mov rax, [rbx + rsi*8]
; zmniejszenie o 1 liczby obieg�w p�tli, bo ilo�� por�wna�
; jest mniejsza o 1 od ilo�ci element�w tablicy
	dec rcx
ptl: 	inc rsi ; inkrementacja indeksu
; por�wnanie najwi�kszego, dotychczas znalezionego elementu
; tablicy z elementem bie��cym
	cmp rax, [rbx + rsi*8]
	jge dalej; skok, gdy element bie��cy jest
; niewi�kszy od dotychczas znalezionego
; przypadek, gdy element bie��cy jest wi�kszy
; od dotychczas znalezionego
	mov rax, [rbx+rsi*8]
dalej: 	loop ptl ; organizacja p�tli
; obliczona warto�� maksymalna pozostaje w rejestrze RAX
; i b�dzie wykorzystana przez kod programu napisany w j�zyku C
	pop rsi
	pop rbx
	ret
szukaj64_max ENDP
END