.686
.model flat

public _liczba_przeciwna

.code

_liczba_przeciwna PROC

	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp ; kopiowanie zawarto�ci ESP do EBP
	
	mov eax, [ebp + 8] ; zapisanie w EAX adresu zmiennej
	neg dword ptr [eax] ; zaneguj arytmetycznie liczb�

	pop ebp
	ret
_liczba_przeciwna ENDP
END