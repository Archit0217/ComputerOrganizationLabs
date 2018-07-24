#include<stdio.h>

int main() {
	int a[5] = {1,20,3,4,5};	// This is the array of numbers
	int max_val = a[0];			// We store the max_value in a[0]
	int i;						// We define the loop counter

	for (i = 1; i < 5; i++){	// Structure of the for loop
		if (max_val < a[i]){	// if max_value is less than a[i], we change the max_value so it contains a[i]
			max_val = a[i];		
		}
	}

	return max_val;				
}
