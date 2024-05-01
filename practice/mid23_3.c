#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>

int main(void) {
	int fd;
	int pid;
	char *argv[16];

	argv[0] = "grep";
	argv[1] = "\"if.*NULL\"";
	argv[2] = "tsh.c";
	argv[3] = NULL;

	pid = fork();

	if (pid == 0) {
		fd = open("out.txt", O_RDWR | O_CREAT, 0666);
		dup2(fd, STDOUT_FILENO);
		execvp(argv[0], argv);
	}
	else {
		wait(NULL);
	}
	return 0;

}
