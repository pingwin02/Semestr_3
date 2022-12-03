.686
.model flat

public _odejmij_jeden

.code

_odejmij_jeden PROC

	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP
	
	mov eax, [ebp + 8] ; zapisanie w EAX adresu wskaŸnika
	mov eax, [eax] ; zapisanie w EAX adresu zmiennej


	dec dword ptr [eax] ; odejmij jeden arytmetycznie liczbê

	pop ebp
	ret
_odejmij_jeden ENDP
END