#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>

#define N 4

void handler(int sig) {

}

void *foo(void *arg) {
	int id = *(int *)arg;

	while(1) {
		pause();
		printf("Thread %d\n", id);
	}
	pthread_exit(NULL);
}

int main(void) {
	pthread_t tid[N];
	int i, id[N];
	struct sigaction act;

	act.sa_handler = handler;
	sigemptyset(&act.sa_mask);
	act.sa_flags = 0;
	sigaction(SIGUSR1, &act, NULL);

	for (i = 0; i < N; ++i) {
		id[i] = i;
		pthread_create(tid + i, NULL, foo, id + i);
	}
	sleep(1);

	for (i = 0; i < N-1; ++i) {
		pthread_kill(tid[i], SIGUSR1);
	}
	for (i = 0; i < N; ++i) {
		pthread_kill(tid[N-1], SIGUSR1);
	}
	sleep(1);

	act.sa_handler = SIG_DFL;
	sigaction(SIGUSR1, &act, NULL);

	pthread_kill(tid[1], SIGUSR1);
//	for (i = 1; i <= N; ++i) {
//		pthread_join(tid[i], NULL);
//	}
//	printf("Good bye!\n");

	return 0;

}

