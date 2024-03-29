/*
 * Copyright(c) 2023-2024 All rights reserved by Heekuck Oh.
 * 이 프로그램은 한양대학교 ERICA 컴퓨터학부 학생을 위한 교육용으로 제작되었다.
 * 한양대학교 ERICA 학생이 아닌 이는 프로그램을 수정하거나 배포할 수 없다.
 * 프로그램을 수정할 경우 날짜, 학과, 학번, 이름, 수정 내용을 기록한다.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <strings.h>
#include <sys/wait.h>
#include <fcntl.h>

#define MAX_LINE 80             /* 명령어의 최대 길이 */
#define READ_END 0
#define WRITE_END 1

/*
 * cmdexec - 명령어를 파싱해서 실행한다.
 * 스페이스와 탭을 공백문자로 간주하고, 연속된 공백문자는 하나의 공백문자로 축소한다. 
 * 작은 따옴표나 큰 따옴표로 이루어진 문자열을 하나의 인자로 처리한다.
 * 기호 '<' 또는 '>'를 사용하여 표준 입출력을 파일로 바꾸거나,
 * 기호 '|'를 사용하여 파이프 명령을 실행하는 것도 여기에서 처리한다.
 */
static void cmdexec(char *cmd)
{
    char *argv[MAX_LINE/2+1];   /* 명령어 인자를 저장하기 위한 배열 */
    int argc = 0;               /* 인자의 개수 */
    char *p, *q;                /* 명령어를 파싱하기 위한 변수 */
	char *fin, *fout;	//파일명을 저장하기 위한 변수
	int pipe_fd[2];
	pid_t pid;
	
    /*
     * 명령어 앞부분 공백문자를 제거하고 인자를 하나씩 꺼내서 argv에 차례로 저장한다.
     * 작은 따옴표나 큰 따옴표로 이루어진 문자열을 하나의 인자로 처리한다.
     */
    p = cmd; p += strspn(p, " \t"); //앞의 공백/탭만큼 포인터 이동
    do {
        /*
         * 공백문자, 큰 따옴표, 작은 따옴표가 있는지 검사한다.
         */ 
        q = strpbrk(p, " \t\'\"<>|");  //가장 왼쪽 공백, 탭, ', ", <, >의 위치 리턴
        /*
         * 공백문자가 있거나 아무 것도 없으면 공백문자까지 또는 전체를 하나의 인자로 처리한다.
         */
        if (q == NULL || *q == ' ' || *q == '\t') { //없거나 공백, 탭이면
            q = strsep(&p, " \t");  //공백, 탭 앞까지 q에 저장
            if (*q) argv[argc++] = q;   //q에 저장된게 있으면 q를 인자로 추가
        }
        /*
         * 작은 따옴표가 있으면 그 위치까지 하나의 인자로 처리하고, 
         * 작은 따옴표 위치에서 두 번째 작은 따옴표 위치까지 다음 인자로 처리한다.
         * 두 번째 작은 따옴표가 없으면 나머지 전체를 인자로 처리한다.
         */
        else if (*q == '\'') {  //'면
            q = strsep(&p, "\'");
            if (*q) argv[argc++] = q;   //'전까지 인자 하나
            q = strsep(&p, "\'");
            if (*q) argv[argc++] = q;   //그 다음 '전까지 인자 하나 추가
        }
        /*
         * 큰 따옴표가 있으면 그 위치까지 하나의 인자로 처리하고, 
         * 큰 따옴표 위치에서 두 번째 큰 따옴표 위치까지 다음 인자로 처리한다.
         * 두 번째 큰 따옴표가 없으면 나머지 전체를 인자로 처리한다.
         */
        else if (*q == '\"'){  //"면
            q = strsep(&p, "\"");
            if (*q) argv[argc++] = q;   //"전까지 인자 하나
            q = strsep(&p, "\"");
            if (*q) argv[argc++] = q;   //그 다음 "전까지 인자 하나 추가
        }
        else if (*q == '<') {   //<면
            q = strsep(&p, "<");
			if (*q) argv[argc++] = q;
			p += strspn(p, " \t");
            q = strpbrk(p, " \t<>|");
            if (q == NULL || *q == ' ' || *q == '\t') {
				fin = strsep(&p, " \t");
			}
			else {
                fin = strsep(&p, "<>|");
				p--;
            }
	//		printf("%s\n", fin);
	//		if (*p != '\0') p--;
			int fd = open(fin, O_RDONLY);
			if (fd == -1) {
				perror("open");
				exit(EXIT_FAILURE);
			}
			dup2(fd, STDIN_FILENO);
			close(fd);
        }
        else if (*q == '>') {   //>면
            q = strsep(&p, ">");    //> 전까지 끊어버리고
            if (*q) argv[argc++] = q;   //인자로 추가
			p += strspn(p, " \t");    //
            q = strpbrk(p, " \t<>|");
            if (q == NULL || *q == ' ' || *q == '\t') {
				fout = strsep(&p, " \t");
			}
			else {
                fout = strsep(&p, "<>|");
                p--;
            }
	//		if (*p != '\0') p--;
            int fd = open(fout, O_CREAT | O_RDWR, 0666);    //파일 열기
            if (fd == -1) { //오류나면 종료
                perror("open");
                exit(EXIT_FAILURE);
            }
            dup2(fd, STDOUT_FILENO);
            close(fd);
        }
		else if (*q == '|') {
			q = strsep(&p, "|");
			if (pipe(pipe_fd) == -1) {
				perror("pipe");
				exit(EXIT_FAILURE);
			}

			pid = fork();

			if (pid == -1) {
				perror("fork");
				exit(EXIT_FAILURE);
			}
			else if (pid == 0) {
				close(pipe_fd[READ_END]);
				dup2(pipe_fd[WRITE_END], STDOUT_FILENO);
				break;
			}
			else {
				close(pipe_fd[WRITE_END]);
				dup2(pipe_fd[READ_END], STDIN_FILENO);
				argc = 0;
			}
			
		}
    } while (p);    //p가 null을 가리키지 않으면 반복
    argv[argc] = NULL;
    /*
     * argv에 저장된 명령어를 실행한다.
     */
    if (argc > 0)
        execvp(argv[0], argv);  //argv[0]에는 명령어가, 그 뒤에는 인자가 쭉 저장되어있고 이를 실행
}

/*
 * 기능이 간단한 유닉스 셸인 tsh (tiny shell)의 메인 함수이다.
 * tsh은 프로세스 생성과 파이프를 통한 프로세스간 통신을 학습하기 위한 것으로
 * 백그라운드 실행, 파이프 명령, 표준 입출력 리다이렉션 일부만 지원한다.
 */
int main(void)
{
    char cmd[MAX_LINE+1];       /* 명령어를 저장하기 위한 버퍼 */
    int len;                    /* 입력된 명령어의 길이 */
    pid_t pid;                  /* 자식 프로세스 아이디 */
    bool background;            /* 백그라운드 실행 유무 */
    
    /*
     * 종료 명령인 "exit"이 입력될 때까지 루프를 무한 반복한다.
     */
    while (true) {
        /*
         * 좀비 (자식)프로세스가 있으면 제거한다.
         */
        pid = waitpid(-1, NULL, WNOHANG);   //모든 자식 프로세스 종료. WNOHANG 옵션은 기다리지 않고 리턴.
        if (pid > 0)
            printf("[%d] + done\n", pid);
        /*
         * 셸 프롬프트를 출력한다. 지연 출력을 방지하기 위해 출력버퍼를 강제로 비운다.
         */
        printf("tsh> "); fflush(stdout);
        /*
         * 표준 입력장치로부터 최대 MAX_LINE까지 명령어를 입력 받는다.
         * 입력된 명령어 끝에 있는 새줄문자를 널문자로 바꿔 C 문자열로 만든다.
         * 입력된 값이 없으면 새 명령어를 받기 위해 루프의 처음으로 간다.
         */
        len = read(STDIN_FILENO, cmd, MAX_LINE);    //표준 입력(STDIN_FILENO)로부터 입력받아 cmd에 저장, MAX_LINE은 오버플로우 방지
        if (len == -1) {    //read()에서 에러 발생
            perror("read");
            exit(EXIT_FAILURE);
        }
        cmd[--len] = '\0';  //cmd 마지막에 있는 개행문자를 null문자로 변경
        if (len == 0)   //아무것도 입력하지 않았으면 다시 입력
            continue;
        /*
         * 종료 명령이면 루프를 빠져나간다.
         */
        if(!strcasecmp(cmd, "exit"))    //버퍼에 exit가 들어왔으면 종료
            break;
        /*
         * 백그라운드 명령인지 확인하고, '&' 기호를 삭제한다.
         */
        char *p = strchr(cmd, '&'); //cmd에서 &의 포인터 리턴
        if (p != NULL) {    
            background = true;  //&가 있으면 백그라운드 명령으로 설정하고 null문자로 변경
            *p = '\0';
        }
        else
            background = false; //&가 없으면 넘어감
        /*
         * 자식 프로세스를 생성하여 입력된 명령어를 실행하게 한다.
         */
        if ((pid = fork()) == -1) { //fork()는 자식 프로세스 생성, 오류 발생하면 -1 리턴
            perror("fork");
            exit(EXIT_FAILURE);
        }
        /*
         * 자식 프로세스는 명령어를 실행하고 종료한다.
         */
        else if (pid == 0) {
            cmdexec(cmd);
            exit(EXIT_SUCCESS);
        }
        /*
         * 포그라운드 실행이면 부모 프로세스는 자식이 끝날 때까지 기다린다.
         * 백그라운드 실행이면 기다리지 않고 다음 명령어를 입력받기 위해 루프의 처음으로 간다.
         */
        else if (!background)   //백그라운드가 아니면 자식 프로세스(명령어 실행)가 끝날 때까지 입력받지 않고 대기
            waitpid(pid, NULL, 0);
    }
    return 0;
}
