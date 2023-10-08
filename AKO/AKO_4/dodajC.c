#include <stdio.h>

short int dodaj(wchar_t liczba_we[], char cyfra, wchar_t** liczba_wy);

int main() {
	wchar_t liczba[] = L"999999999";
	wchar_t* wynik;
	short int a;

	a = dodaj(liczba, '2', &wynik);

	if (a != -1) {
		printf("\nwynik = %ls\n", wynik);
		free(wynik);
	}
	return 0;
}