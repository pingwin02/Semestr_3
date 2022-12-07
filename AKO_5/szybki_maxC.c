#include <stdio.h>

void szybki_max(int t_1[], int t_2[], int t_wynik[], int n);

int main() {

	int val1[8] = { 1,-1,2,-2,3,-3,4,-4 };
	int val2[8] = { -4,-3,-2,-1,0,1,2,3 };

	int wynik[8];

	szybki_max(val1, val2, wynik, 8);

	for (int i = 0; i < 8; i++) {
		printf("%d ", wynik[i]);
	}

	return 0;
}