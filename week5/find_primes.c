/*
 * Copyright(c) 2023-2024 All rights reserved by Heekuck Oh.
 * 이 프로그램은 한양대학교 ERICA 컴퓨터학부 학생을 위한 교육용으로 제작되었다.
 */
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <inttypes.h>
#include <pthread.h>

#define N 8
#define STARTNUM 1000000000000000000UL
#define SRCHSPAN 1000UL

struct foo {
    int id;
    uint64_t n;
};

/*
 * isprime은 n이 소수이면 참, 아니면 거짓을 리턴한다.
 */
bool isprime(uint64_t n)
{
    uint64_t p = 5;
    
    if (n == 2 || n == 3)
        return true;
    if (n == 1 || n % 2 == 0 || n % 3 == 0)
        return false;
    while (n >= p*p)
        if (n % p == 0 || n % (p + 2) == 0)
            return false;
        else
            p += 6;
    return true;
}

/*
 * find_primes는 n부터 n+SRCHSPAN 사이에 있는 모든 소수를 출력한다.
 * 대괄호 안에 있는 숫자는 스레드를 구별하기 위한 식별자이다.
 */
void *find_primes(void *arg)
{
    int id = ((struct foo *)arg)->id;
    uint64_t n = ((struct foo *)arg)->n;

    for (int i = 0; i < SRCHSPAN; ++i, ++n)
        if (isprime(n))
            printf("[%d]%"PRIu64"\n", id, n);
    pthread_exit(NULL);
}

int main(void)
{
    pthread_t tid[N];
    struct foo arg[N];
    int i;

    /*
     * 소수를 찾는 N개의 스레드를 생성한다.
     */
    for (i = 0; i < N; ++i) {
        arg[i].id = i;
        arg[i].n = STARTNUM + i * SRCHSPAN;
        pthread_create(tid+i, NULL, find_primes, arg+i);
    }
    /*
     * 자식 스레드가 종료될 때까지 기다린다.
     */
    for (i = 0; i < N; ++i)
        pthread_join(tid[i], NULL);
    /*
     * 메인함수를 종료한다.
     */
    return 0;
}
