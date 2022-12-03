#include <stdio.h>
#include <stdlib.h>

extern void przestaw(int tabl[], int n);

int main()
{
	int n;

	printf("\nProsze napisac rozmiar tablicy: ");

	scanf_s("%d", &n);

	int* tabl = (int*)malloc(n * sizeof(int));

	printf("\nProsze napisac kolejne %d elementow tablicy: ", n);

	for (int i = 0; i < n; i++) {
		scanf_s("%d", &tabl[i]);
	}
	
	for (int j = n; j > 1; j--)
	{
		przestaw(tabl, j);
	}

	printf("\nWynik:\n");

	for (int i = 0; i < n; i++) {
		printf(" %d ", tabl[i]);
	}

	free(tabl);

	return 0;
}