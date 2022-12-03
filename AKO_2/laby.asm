.686 
.model flat 
extern _ExitProcess@4 : PROC 
extern _MessageBoxW@16 : PROC 
public _main

.data 
tytul_Unicode	dw 'T','e','k','s','t',' ','w',' ' 
				dw 'f','o','r','m','a','c','i','e',' ' 
				dw 'U','T','F','-','1','6', 0 
tekst_Unicode   db  0,'A',0,'l',0,'a',0,' ',0,'m',0,'a',0,' ',0,'k',0,'o',0,'t',0,'a',0,' ', 0d8h, 03dh, 0dch, 08h, 0, 0
koniec_t		db ?
wynik			db 80 dup (0)

lancuch_do_usuniecia db 0,'A',0,'l'

.code 
_main PROC 

	mov ebx, 0
	mov edx, 0
	mov ecx, (OFFSET koniec_t) - (OFFSET tekst_Unicode)
	mov esi, 0

	mov eax, dword ptr lancuch_do_usuniecia

	usunciag:
	cmp eax, dword ptr tekst_Unicode[ebx]
	jne dalej

	add ebx, 4
	sub ecx, 4
	jmp usunciag

	dalej:
	mov dx, word ptr tekst_Unicode[ebx]
	mov word ptr wynik[esi], dx
	add ebx, 2
	add esi, 2
	sub ecx, 2
	jnz usunciag


	mov eax, 0
	mov ebx, 0
	mov edx, 0
	mov ecx, esi

ptl: mov dl, wynik[ebx]
	
	mov al, wynik[ebx+1]

	mov wynik[ebx], al

	mov wynik[ebx+1], dl

	add ebx, 2
	sub ecx, 2
	jz koniec
	jmp ptl

	koniec:
	push 0
	push OFFSET tytul_Unicode 
	push OFFSET wynik 
	push 0
	call _MessageBoxW@16

	push 0 ; kod powrotu programu 
	call _ExitProcess@4 

_main ENDP 
END