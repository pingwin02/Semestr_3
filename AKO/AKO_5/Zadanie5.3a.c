#include <stdio.h>

void dodaj_SSE_char(char*, char*, char*);

int main() {

	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };

	char wynik[16];

	dodaj_SSE_char(liczby_A, liczby_B, wynik);

	printf("\n%d %d %d %d", liczby_A[0], liczby_A[1], liczby_A[2], liczby_A[3]);
	printf("\n%d %d %d %d", liczby_A[4], liczby_A[5], liczby_A[6], liczby_A[7]);
	printf("\n%d %d %d %d", liczby_A[8], liczby_A[9], liczby_A[10], liczby_A[11]);
	printf("\n%d %d %d %d\n", liczby_A[12], liczby_A[13], liczby_A[14], liczby_A[15]);

	printf("\n%d %d %d %d", liczby_B[0], liczby_B[1], liczby_B[2], liczby_B[3]);
	printf("\n%d %d %d %d", liczby_B[4], liczby_B[5], liczby_B[6], liczby_B[7]);
	printf("\n%d %d %d %d", liczby_B[8], liczby_B[9], liczby_B[10], liczby_B[11]);
	printf("\n%d %d %d %d\n", liczby_B[12], liczby_B[13], liczby_B[14], liczby_B[15]);

	printf("\n%d %d %d %d", wynik[0], wynik[1], wynik[2], wynik[3]);
	printf("\n%d %d %d %d", wynik[4], wynik[5], wynik[6], wynik[7]);
	printf("\n%d %d %d %d", wynik[8], wynik[9], wynik[10], wynik[11]);
	printf("\n%d %d %d %d\n", wynik[12], wynik[13], wynik[14], wynik[15]);

	return 0;
}