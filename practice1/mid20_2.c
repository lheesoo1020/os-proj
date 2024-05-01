#include <stdio.h>
#include <stdlib.h>

int main() {
	int num;
	int pid;
	int fd[2];
	
	pipe(fd);
	pid = fork();

	if (pid == 0) {
		srand(20240423);
		while(1) {
			num = rand();
			write(fd[1], &num, sizeof(num));
			sleep(1);
		}
		return 0;
	}
	else {
		while(1) {
			read(fd[0], &num, sizeof(num));
			if (num%2 == 0) printf("even\n");
			else printf("odd\n");
		}
		return 0;
	}
}
