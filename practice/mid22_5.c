#include <stdio.h>
#include <sys/types.h>
#include <string.h>
#include <pthread.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>

#define N 8

int n = 0;
int x;

void *foo(void *arg) {
	int y;

	x = y = n++;
	while (x == y) {
		pthread_testcancel();
		continue;
	}
	printf("<%d, %d>\n", x, y);
	pthread_exit(NULL);
}

int main(void) {
	int i;
	pthread_t tid[N];

	for (i = 0; i < N; i++) {
		sleep(1);
		pthread_create(tid + i, NULL, foo, NULL);
	}
	sleep(2);
	for (i = 0; i < N; i++) {
		pthread_cancel(tid[i]);
	}
	for (i = 0; i < N; i++) {
		pthread_join(tid[i], NULL);
	}

	return 0;
}
