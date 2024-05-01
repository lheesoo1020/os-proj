#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define MAXLINE 80

int main(void) {
	pid_t pid;
	char *argv[MAXLINE/2+1];

	pid = fork();
	if (pid == 0) {
		argv[0] = "ls";
		argv[1] = "-al";
		argv[2] = NULL;
		execvp(argv[0], argv);
	}
	else {
		wait(NULL);
		printf("wait finished");
	}
	return 0;
}

