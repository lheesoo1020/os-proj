/*
 * Copyright 2020-2024. Heekuck Oh, all rights reserved
 * 이 프로그램은 한양대학교 ERICA 컴퓨터학부 재학생을 위한 교육용으로 제작되었다.
 */
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <pthread.h>

/*
 * N = 5, 다섯 명의 철학자가 식사와 낮잠을 즐긴다.
 * NAPTIME = 철학자가 낮잠을 즐기는 시간
 * RUNTIME = 철학자가 먹고 자는데 허용된 시간
 */ 
#define N 5
#define NAPTIME 0
#define RUNTIME 200000

/*
 * ANSI 컬러 코드: 출력을 쉽게 구분하기 위해서 사용한다.
 * 순서대로 RED, GRN, YEL, BLU, MAG, RESET을 의미한다.
 */
char *color[N+1] = {"\e[0;31m","\e[0;32m","\e[0;33m","\e[0;34m","\e[0;35m","\e[0m"};

/*
 * alive 값이 false가 될 때까지 철학자는 먹고 자기를 반복한다.
 */
bool alive = true;

/*
 * 배열 state는 현재 철학자의 상태를 나타낸다.
 */
enum {SLEEPING, HUNGRY, EATING} state[N];

pthread_cond_t cond[N];
pthread_mutex_t mutex;


/*
 * 철학자는 식사를 하는 동안에 문자를 출력한다. <i...i> 이런 식이다.
 * 식사가 끝난 철학자는 잠시 낮잠을 잔다. 잠에서 깨어난 철학자는 식사와 낮잠을 반복한다.
 */
void *philosopher(void *arg)
{
    int id, left, right;

    /*
     * 철학자의 ID를 읽는다.
     */
    id = *(int *)arg;
    left = (id - 1 + N) % N;
    right = (id + 1) % N;

    
    /*
     * 철학자는 식사와 낮잠을 반복한다.
     */
    while (alive) {
        pthread_mutex_lock(&mutex);
        state[id] = HUNGRY;
        while(state[left] == EATING || state[right] == EATING)
            pthread_cond_wait(&cond[id], &mutex);
        /*
         * 배고픈 철학자는 식사를 한다.
         */
        state[id] = EATING;

        pthread_mutex_unlock(&mutex);
        
        printf("%s<%d%s", color[id], id, color[N]);
        for (int i = 0; i < 64; ++i) {
            printf("%s.%s", color[id], color[N]);
            usleep(10);
        }
        printf("%s%d>%s", color[id], id, color[N]);
        /*
         * 제대로 할 수 있었던 식사였는지 검증한다.
         * 불가능한 식사였다면 오류를 출력하고 식탁에서 퇴장한다.
         */
        pthread_mutex_lock(&mutex);
        if (state[left] == EATING || state[right] == EATING) {
            printf("ERROR");
            pthread_mutex_unlock(&mutex);
            break;
        }

        if (state[left] == HUNGRY) pthread_cond_signal(&cond[left]);
        if (state[right] == HUNGRY) pthread_cond_signal(&cond[right]);

        state[id] = SLEEPING;
        pthread_mutex_unlock(&mutex);
        /*
         * 식사를 끝낸 철학자는 NAPTIME 마이크로초 낮잠을 잔다.
         */
        usleep(NAPTIME);
    }
    pthread_exit(NULL);
}

/*
 * 메인 함수는 N 개의 philosopher 스레드를 생성한다.
 * 철학자가 먹고 잘 동안 RUNTIME 마이크로초 기다렸다가 스레드를 종료한다.
 */
int main(void)
{
    int i, id[N];
    pthread_t tid[N];

    for (i = 0; i < N; i++)
        pthread_cond_init(&cond[i], NULL);
    pthread_mutex_init(&mutex, NULL);
 
    /*
     * N 개의 철학자 스레드를 생성한다.
     */
    for (i = 0; i < N; ++i) {
        id[i] = i;
        pthread_create(tid+i, NULL, philosopher, id+i);
    }
    /*
     * 철학자가 먹고 잘 동안 RNTIME 마이크로초 기다린다.
     */
    usleep(RUNTIME);
    /*
     * 철학자 스레드를 종료한다.
     */
    alive = false;
    /*
     * 종료된 철학자 스레드를 기다렸다가 조인한다.
     */
    for (i = 0; i < N; ++i)
        pthread_join(tid[i], NULL);
    
    for (i = 0; i < N; i++)
        pthread_cond_destroy(&cond[i]);
    pthread_mutex_destroy(&mutex);

    return 0;
}
