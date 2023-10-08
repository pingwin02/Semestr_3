.686
.model flat

public _objetosc_stozka

.data

	trzy dd 3.0

.code
_objetosc_stozka PROC
	push ebp
	mov ebp, esp

	finit
	fild dword ptr [ebp + 12]
	fild dword ptr [ebp + 12]
	fild dword ptr [ebp + 8]
	fst st(3)
	; st(0)=R st(1)=r st(2)=r st(3)=R
	fmul
	; st(0)=Rr st(1)=r st(2)=R

	fxch
	fmul st(0), st(0)
	; st(0)=r^2 st(1)=Rr st(2)=R
	fxch st(2)
	fmul st(0), st(0)
	; st(0)=R^2 st(1)=Rr st(2)=r^2
	fadd
	fadd
	; st(0)=r^2+Rr+R^2
	fldpi
	fld dword ptr [ebp + 16]
	; st(0)=h st(1)=pi st(2)=r^2+Rr+R^2
	fmul
	fmul
	; st(0)=(r^2+Rr+R^2)*pi*h
	fld trzy
	fdiv
	; st(0)=(r^2+Rr+R^2)*pi*h/3

	pop ebp
	ret
_objetosc_stozka ENDP
END