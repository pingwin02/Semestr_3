#include <stdio.h>

extern void liczba_przeciwna(int* a);

int main() {

	int m;

	printf("Podaj liczbe: ");
	scanf_s("%d", &m);

	liczba_przeciwna(&m);

	printf("m = %d\n", m);

	return 0;
}