#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main(void) {
	int fd[2];
	int num;
	pid_t pid;
	
	pipe(fd);
	
	pid = fork();

	if (pid == 0) {
		close(fd[0]);
		srand(20220419);
		while(1) {
			num = rand();
			write(fd[1], &num, sizeof(num));
			sleep(1);
		}
		close(fd[1]);
		return 0;
	}
	else {
		close(fd[1]);
		while(1) {
			sleep(1);
			read(fd[0], &num, sizeof(num));
			if (num%2 == 0) printf("even number\n");
			else printf("odd number\n");
		}
		return 0;
	}
}
