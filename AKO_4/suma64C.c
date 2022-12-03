#include <stdio.h>

__int64 sum_of_squares(__int64* tab1, unsigned int n);

int main()
{

	__int64 tabl[] = {1000000, 2, -3};

	__int64 wynik = sum_of_squares(tabl, 3);

	printf("\Wynik wynosi %I64d\n", wynik);

	return 0;
}