.686
.model flat
extern _ExitProcess@4 : PROC
public _main

.data

	; x^2 - 5*x + 6 = 0

	wsp_a dd +1.0
	wsp_b dd -5.0
	wsp_c dd +6.0
	dwa dd 2.0
	cztery dd 4.0
	x1 dd ?
	x2 dd ?

.code
_main PROC

	finit
	fld wsp_a ; za�adowanie wsp�czynnika a
	fld wsp_b ; za�adowanie wsp�czynnika b
	fst st(2) ; kopiowanie b

; sytuacja na stosie: ST(0) = b, ST(1) = a, ST(2) = b

	fmul st(0),st(0) ; obliczenie b^2

	fld cztery

; sytuacja na stosie: ST(0) = 4.0, ST(1) = b^2, ST(2) = a,
; ST(3) = b

	fmul st(0), st(2) ; obliczenie 4 * a

	fmul wsp_c ; obliczenie 4 * a * c

	fsubp st(1), st(0) ; obliczenie b^2 - 4 * a * c

; sytuacja na stosie: ST(0) = b^2 - 4 * a * c, ST(1) = a,
; ST(2) = b

	fldz ; zaladowanie 0

; sytuacja na stosie: ST(0) = 0, ST(1) = b^2 - 4 * a * c,
; ST(2) = a, ST(3) = b
; rozkaz FCOMI - oba por�wnywane operandy musza by� podane na
; stosie koprocesora

	fcomi st(0), st(1)

; usuniecie zera z wierzcho�ka stosu

	fstp st(0)
	ja delta_ujemna ; skok, gdy delta ujemna

; w przyk�adzie nie wyodr�bnia si� przypadku delta = 0
; sytuacja na stosie: ST(0) = b^2 - 4 * a * c, ST(1) = a,
; ST(2) = b

	fxch st(1) ; zamiana st(0) i st(1)

; sytuacja na stosie: ST(0) = a, ST(1) = b^2 - 4 * a * c,
; ST(2) = b

	fadd st(0), st(0) ; obliczenie 2 * a
	fstp st(3)

; sytuacja na stosie: ST(0) = b^2 - 4 * a * c, ST(1) = b,
; ST(2) = 2 * a

	fsqrt ; pierwiastek z delty

; przechowanie obliczonej warto�ci

	fst st(3)

; sytuacja na stosie: ST(0) = sqrt(b^2 - 4 * a * c),
; ST(1) = b, ST(2) = 2 * a, ST(3) = sqrt(b^2 - 4 * a * c)

	fchs ; zmiana znaku
	fsub st(0), st(1); obliczenie -b - sqrt(delta)
	fdiv st(0), st(2); obliczenie x1
	fstp x1 ; zapisanie x1 w pami�ci

; sytuacja na stosie: ST(0) = b, ST(1) = 2 * a,
; ST(2) = sqrt(b^2 - 4 * a * c)

	fchs ; zmiana znaku
	fadd st(0), st(2)
	fdiv st(0), st(1)
	fstp x2

delta_ujemna:
	fstp st(0) ; oczyszczenie stosu
	fstp st(0)

	push 0
	call _ExitProcess@4

_main ENDP
END