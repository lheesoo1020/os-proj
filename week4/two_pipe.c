#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define BUFFER_SIZE 50
#define READ_END 0
#define WRITE_END 1

int main(void) {
	int fdA[2], fdB[2];
	pid_t pid;
	char write_msg[BUFFER_SIZE];
	char read_msg[BUFFER_SIZE];

	if (pipe(fdA) == -1) {
		printf("PIPE A ERROR\n");
		fprintf(stderr, "Pipe A failed");
		return 1;
	}
	if (pipe(fdB) == -1) {
		printf("PIPE B ERROR\n");
		fprintf(stderr, "Pipe B failed");
		return 1;
	}

	pid = fork();

	if (pid < 0) {
		printf("FORK ERROR\n");
		fprintf(stderr, "Fork failed");
		return 1;
	}
	if (pid > 0) {
		close(fdA[READ_END]);
		close(fdB[WRITE_END]);

		int i;
		for (i = 0; i < 10; i++) {
			snprintf(write_msg, BUFFER_SIZE, "parent %d\n", i);
			write(fdA[WRITE_END], write_msg, strlen(write_msg) + 1);
			sleep(1);
			read(fdB[READ_END], read_msg, BUFFER_SIZE);
			printf("parent got message: %s", read_msg);
		}

		close(fdA[WRITE_END]);
		close(fdB[READ_END]);
	}
	else {
		close(fdA[WRITE_END]);
		close(fdB[READ_END]);

		int i;
		for (i = 10000; i < 10010; i++) {
			snprintf(write_msg, BUFFER_SIZE, "child %d\n", i);
			read(fdA[READ_END], read_msg, BUFFER_SIZE);
			printf("\tchild got message: %s", read_msg);
			write(fdB[WRITE_END], write_msg, strlen(write_msg) + 1);
			sleep(1);
		}
		
		close(fdA[READ_END]);
		close(fdB[WRITE_END]);
	}


	return 0;
}
