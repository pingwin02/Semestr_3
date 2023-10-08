.386
    rozkazy SEGMENT use16
    ASSUME cs:rozkazy
linia PROC
    ; przechowanie rejestrów
    push ax
    push bx
    push es
    push dx
    mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
    mov es, ax
    mov dx, cs:nr_kolumny ; nr kolumny poczatku odcinka <0, 320>
    mov al, cs:kolor

    mov cx, 20 ; dlugosc odcinka

    ptl:
        cmp dx, 320
        jb rysuj
        sub dx, 320
        rysuj:
        mov bx, dx
        add bx, cs:adres_piksela
        mov es:[bx], al ; wpisanie kodu koloru do pamięci ekranu
        inc dx
    loop ptl

    ; czyszczenie sladu po starym odcinku
    mov cx, 2
    czysc:
        cmp dx, 320
        jb dalej
        sub dx, 320
        dalej:
        mov bx, dx
        add bx, cs:adres_piksela
        mov es:[bx], byte ptr 0
        inc dx
    loop czysc

    mov dx, cs:nr_kolumny

    inc cs:kolor
    cmp cs:kolor, 15
    jb kolor_ok
    mov cs:kolor, 0
    
    kolor_ok:
    sub dx, 2 ; przesuwanie o dwa w lewo
    cmp dx, 0
    ja nie_trzeba
    mov dx, 320
    nie_trzeba:
    mov cs:nr_kolumny, dx
    ; odtworzenie rejestrów
    pop dx
    pop es
    pop bx
    pop ax
    ; skok do oryginalnego podprogramu obsługi przerwania
    ; zegarowego
    jmp dword PTR cs:wektor8
    ; zmienne procedury
    kolor db 0fh ; bieżący numer koloru
    adres_piksela   dw 100*320
    nr_kolumny      dw 160
    wektor8       dd ?  
linia ENDP
    ; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
    zacznij:
    mov ah, 0
    mov al, 13H ; nr trybu
    int 10H
    mov bx, 0
    mov es, bx ; zerowanie rejestru ES
    mov eax, es:[32] ; odczytanie wektora nr 8
    mov cs:wektor8, eax; zapamiętanie wektora nr 8
    ; adres procedury 'linia' w postaci segment:offset
    mov ax, SEG linia
    mov bx, OFFSET linia
    cli ; zablokowanie przerwań
    ; zapisanie adresu procedury 'linia' do wektora nr 8
    mov es:[32], bx
    mov es:[32+2], ax
    sti ; odblokowanie przerwań
    czekaj:
    mov ah, 1 ; sprawdzenie czy jest jakiś znak
    int 16h ; w buforze klawiatury
    jz czekaj
    mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
    mov al, 3H ; nr trybu
    int 10H
    ; odtworzenie oryginalnej zawartości wektora nr 8
    mov eax, cs:wektor8
    mov es:[32], eax
    ; zakończenie wykonywania programu
    mov ax, 4C00H
    int 21H
rozkazy ENDS

stosik SEGMENT stack
    db 256 dup (?)
stosik ENDS
END zacznij