.686
.model flat
extern _ExitProcess@4 : PROC
extern _malloc : PROC
public _funkcja

.code
_funkcja PROC

	push ebp
	mov ebp, esp
	sub esp, 8
	mov eax, [ebp + 8] ; zmienna e

	lea ecx, [4 * eax]
	push ecx
	call _malloc
	pop ecx

	cmp eax, 0
	je blad

	mov [ebp - 4], eax

	mov eax, [ebp + 8]

	
	mov [ebp - 8], dword ptr 0 ; zmienna h
	mov ecx, [ebp - 8]

	ptl:
	mov edx, [ebp - 4]
	push eax
	lea eax, [ 2 * ecx + ecx - 1]
	mov [edx], eax
	pop eax

	add dword ptr [ebp - 4], 4 ; i++
	inc dword ptr [ebp - 8] ; h++
	mov ecx, [ebp - 8]
	cmp ecx, eax ; h < e
	jb ptl
	jmp koniec

	blad:
	pop eax
	mov eax, -1

	koniec:
	add esp, 8
	pop ebp
	ret
_funkcja ENDP
END