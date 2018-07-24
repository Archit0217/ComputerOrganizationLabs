#include<stdio.h>

extern int MAX_2(int x, int y);

int main() {
	int a[7] = {1,2,300,4,5,67,17};
	int max_value = a[0];				// For the time being, max value is stored in A[0]
	int i;
	for (i = 1; i < 7; i++) {
			max_value = MAX_2(max_value, a[i]);
	}
	return max_value;
}
