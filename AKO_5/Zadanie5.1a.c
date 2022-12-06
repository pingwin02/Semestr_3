#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);


int main() {
	float tab[] = { 1, 2, 3 };

	printf("Srednia harmoniczna = %f", srednia_harm(tab, 3));

	return 0;
}