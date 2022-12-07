#include <stdio.h>
#include <xmmintrin.h>

__m128 mul_at_once(__m128 one, __m128 two);

int main() {
	__m128 one;
	one.m128_i32[0] = 12;
	one.m128_i32[1] = 21;
	one.m128_i32[2] = 10;
	one.m128_i32[3] = 2;
	__m128 two;
	two.m128_i32[0] = 1;
	two.m128_i32[1] = 22;
	two.m128_i32[2] = 11;
	two.m128_i32[3] = 6;

	__m128 result;

	result = mul_at_once(one, two);

	for (int i = 0; i < 4; i++) {
		printf("%d ", result.m128_i32[i]);
	}

	return 0;
}