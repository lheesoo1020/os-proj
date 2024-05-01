#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <unistd.h>

int main() {
	int x = 0;
	#pragma omp parallel
	{
		x = x + 1;
	}
	sleep(1);
	printf("%d\n", x);
	return 0;
}
