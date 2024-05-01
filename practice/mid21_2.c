#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

int main() {
	int pid;
	char *args[16];
	int fd;

	pid = fork();

	if (pid == 0) {
		args[0] = "ps";
		args[1] = "-ael";
		args[2] = NULL;

		fd = open("out.txt", O_CREAT | O_RDWR, 0660);
		dup2(fd, STDOUT_FILENO);
		close(fd);

		execvp(args[0], args);
	}
	else {
		wait(NULL);
		printf("wait finished\n");
	}
}
