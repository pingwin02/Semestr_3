
#include <stdio.h>

int funkcja(int e);

int funkcjawC(int e) {

	int h; int* i;

	i = (int*) malloc(e * sizeof(int));

	if (i == NULL) return -1;

	for (h = 0; h < e; h++)
	{
		(*i) = 3 * h - 1;
		i++;
	}
	return e;
}

int main() {

	int a; int b = 4;
	a = funkcja(b);

	a = funkcjawC(b);

	return 0;
}