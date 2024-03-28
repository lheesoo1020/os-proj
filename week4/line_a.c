#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <unistd.h>

int value = 5;

int main(){
	pid_t pid;
	int fd[2];

	if (pipe(fd) == -1) {
		printf("PIPE ERROR\n");
		fprintf(stderr, "Pipe failed");
		return 1;
	}

	pid = fork();

	if (pid == 0) {
		value += 15;
		close(fd[0]);
		write(fd[1], &value, sizeof(value));
		return 0;
	} else if (pid > 0) {
		wait(NULL);
		close(fd[1]);
		read(fd[0], &value, sizeof(value));
		printf("PARENT: value = %d\n", value); /* LINE A */
		return 0;
	}
}
