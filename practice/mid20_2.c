#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
	int fd[2];
//	int num;
	pid_t pid;
	
	pipe(fd);

	pid = fork();

	if (pid == 0) {
		int num;
		srand(20200507);
		while(1) {
			num = rand();
			write(fd[1], &num, sizeof(num));
		}
	}
	else {
		int num;
		while(1) {
			read(fd[0], &num, sizeof(num));
			if(num%2 == 0) printf("even number\n");
			else printf("odd number\n");
		}
	}
}

