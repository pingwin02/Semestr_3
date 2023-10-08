#include <stdio.h>

extern __int64 szukaj4_min(__int64 a, __int64 b, __int64 c, __int64 d);

int main() {

	__int64 a, b, c, d, wynik;

	printf("\nProsze podac cztery liczby calkowite ze znakiem: ");

	scanf_s("%I64d %I64d %I64d %I64d", &a, &b, &c, &d);

	wynik = szukaj4_min(a, b, c, d);

	printf("\nSposrod podanych liczb %I64d, %I64d, %I64d, %I64d \
liczba %I64d jest najmniejsza\n", a, b, c, d, wynik);

	return 0;
}