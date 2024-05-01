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

		int c;
		int p;
		for (p = 0; p < 10; p++) {
			write(fdA[WRITE_END], &p, sizeof(p));
			sleep(1);
			read(fdB[READ_END], &c, sizeof(c));
			printf("parent got message: %d\n", c);
		}

		close(fdA[WRITE_END]);
		close(fdB[READ_END]);
	}
	else {
		close(fdA[WRITE_END]);
		close(fdB[READ_END]);

		int c;
		int p;
		for (c = 10000; c < 10010; c++) {
			read(fdA[READ_END], &p, sizeof(p));
			printf("\tchild got message: %d\n", p);
			write(fdB[WRITE_END], &c, sizeof(c));
			sleep(1);
		}
		
		close(fdA[READ_END]);
		close(fdB[WRITE_END]);
	}


	return 0;
}
