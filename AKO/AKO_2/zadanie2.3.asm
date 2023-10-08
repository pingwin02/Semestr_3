; Zadanie 2.3
.686 
.model flat 
extern _ExitProcess@4 : PROC 
extern _MessageBoxW@16 : PROC 
public _main

.data 
tytul_Unicode	dw 'Z','n','a','k','i', 0
tekst_Unicode	dw 'T','o',' ','s',105h,' '
				dw 'g','w','i','a','z','d','y',' ', 0d83ch, 0df1fh,' '
				dd 0df1fd83ch
				dw ' ','i',' ','p','l','a','n','e','t','a'
				dw ' ', 0d83eh, 0de90h, 0

.code 
_main PROC

	push 0 ; stala MB_OK 

; adres obszaru zawieraj¹cego tytu³ 
	push OFFSET tytul_Unicode 

; adres obszaru zawieraj¹cego tekst 
	push OFFSET tekst_Unicode 

	push 0 ; NULL 

	call _MessageBoxW@16

	push 0 ; kod powrotu programu 
	call _ExitProcess@4 
_main ENDP 
END