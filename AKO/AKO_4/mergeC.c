#include <stdio.h>

int* merge(int tab1[], int tab2[], int n);

int main() {
	int tab1[] = { 1,3,5,7,9 };
	int tab2[] = { 2,4,6,8,10 };

	int* result = merge(tab1, tab2, 5);

	if (result != NULL)
	for (int i = 0; i < 10; i++) {
		printf("\n%d\n", result[i]);
	}
	else 
		printf("\nERROR\n");

	return 0;
}