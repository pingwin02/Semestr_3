#include <stdio.h>

float nowy_exp(float x);


int main() {
	
	float x = 5;

	printf("e^%0.1f = %f", x, nowy_exp(x));

	return 0;
}