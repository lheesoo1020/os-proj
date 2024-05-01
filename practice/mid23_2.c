#include <stdio.h>
#include <unistd.h>

int main(void) {
	int x = 0;
	if (fork() == 0) {
		printf("L1: %d\n", --x);
		if (fork() == 0) {
			printf("L2: %d\n", --x);
		}
		else {
			printf("L3: %d\n", ++x);
		}
	}
	else {
		printf("L4: %d\n", ++x);
		if (fork() == 0) {
			printf("L5: %d\n", --x);
		}
		else {
			printf("L6: %d\n", ++x);
		}
	}
	printf("L7: %d\n", x);
}
