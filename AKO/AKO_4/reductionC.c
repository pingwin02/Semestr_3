#include <stdio.h>

int reduction(int tab[], unsigned int n, short reductionType);

int main()
{
	int tab[] = { -1,-2,3,4,5 };

	printf("Min: %d\n", reduction(tab, 5, -1));

	printf("Suma: %d\n", reduction(tab, 5, 0));

	printf("Max: %d\n", reduction(tab, 5, 1));

	return 0;
}