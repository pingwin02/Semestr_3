.686
.model flat

public _odejmij_jeden

.code

_odejmij_jeden PROC

	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp ; kopiowanie zawarto�ci ESP do EBP
	
	mov eax, [ebp + 8] ; zapisanie w EAX adresu wska�nika
	mov eax, [eax] ; zapisanie w EAX adresu zmiennej


	dec dword ptr [eax] ; odejmij jeden arytmetycznie liczb�

	pop ebp
	ret
_odejmij_jeden ENDP
END