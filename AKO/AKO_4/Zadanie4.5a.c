#include <stdio.h>

extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);

int main()
{
	__int64 
		v1 = 1, 
		v2 = 2,
		v3 = 3, 
		v4 = 4, 
		v5 = 5, 
		v6 = 6, 
		v7 = 7, 
		suma;

	suma = suma_siedmiu_liczb(v1, v2, v3, v4, v5, v6, v7);

	printf("\nSuma wynosi %I64d\n", suma);

	return 0;
}