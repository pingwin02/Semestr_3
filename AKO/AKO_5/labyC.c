// Damian Jankowski s188597 czwartek 08.12.2022 gr2 9.15-10.45

#include <stdio.h>

float srednia_wazona(float* tablica_dane, float* tablica_wagi, unsigned int n);


int main() {
	float tablica_dane[] = { 1.0, 2.0, -3.0 };
	float tablica_wagi[] = { 3.0, 4.0, 5.0 };

	printf("Srednia wazona = %f", srednia_wazona(tablica_dane, tablica_wagi, 3));

	return 0;
}