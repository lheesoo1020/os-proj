/*
 * Copyright(c) 2021-2024 All rights reserved by Heekuck Oh.
 * 이 프로그램은 한양대학교 ERICA 컴퓨터학부 학생을 위한 교육용으로 제작되었다.
 * 한양대학교 ERICA 학생이 아닌 이는 프로그램을 수정하거나 배포할 수 없다.
 * 프로그램을 수정할 경우 날짜, 학과, 학번, 이름, 수정 내용을 기록한다.
 */
#include <stdlib.h>
#include "pthread_pool.h"
#include <stdio.h>

/*
 * 풀에 있는 일꾼(일벌) 스레드가 수행할 함수이다.
 * FIFO 대기열에서 기다리고 있는 작업을 하나씩 꺼내서 실행한다.
 * 대기열에 작업이 없으면 새 작업이 들어올 때까지 기다린다.
 * 이 과정을 스레드풀이 종료될 때까지 반복한다.
 */
static void *worker(void *param)
{
    pthread_pool_t *pool = (pthread_pool_t *)param;

    while (1) {
        pthread_mutex_lock(&pool -> mutex);

        //대기열에 빈자리가 없는 동안 대기
        while (pool -> state == ON && pool -> q_len == 0) {
            pthread_cond_wait(&pool -> full, &pool -> mutex);
        }

        //스레드풀이 꺼진 경우 종료
        if (pool -> state == OFF) {
            pthread_mutex_unlock(&pool -> mutex);
            break;
        }

        //스레드풀이 대기상태에서 남은 일을 모두 마쳤으면 종료
        if (pool -> state == STANDBY && pool -> q_len == 0) {
            pool -> state = OFF;
            pthread_mutex_unlock(&pool -> mutex);
            break;
        }

        //대기열에서 일을 받아오고 맨 앞과 대기열의 크기 조정
        task_t task = pool -> q[pool -> q_front];
        pool -> q_front = (pool -> q_front + 1) % pool -> q_size;
        pool -> q_len--;

        //대기열의 빈자리를 기다리고 있는 submit 깨워주기
        pthread_cond_signal(&pool -> empty);
        pthread_mutex_unlock(&pool -> mutex);

        //실행
        task.function(task.param);
    }

    pthread_exit(NULL);
}

/*
 * 스레드풀을 생성한다. bee_size는 일꾼(일벌) 스레드의 개수이고, queue_size는 대기열의 용량이다.
 * bee_size는 POOL_MAXBSIZE를, queue_size는 POOL_MAXQSIZE를 넘을 수 없다.
 * 일꾼 스레드와 대기열에 필요한 공간을 할당하고 변수를 초기화한다.
 * 일꾼 스레드의 동기화를 위해 사용할 상호배타 락과 조건변수도 초기화한다.
 * 마지막 단계에서는 일꾼 스레드를 생성하여 각 스레드가 worker() 함수를 실행하게 한다.
 * 대기열로 사용할 원형 버퍼의 용량이 일꾼 스레드의 수보다 작으면 효율을 극대화할 수 없다.
 * 이런 경우 사용자가 요청한 queue_size를 bee_size로 상향 조정한다.
 * 성공하면 POOL_SUCCESS를, 실패하면 POOL_FAIL을 리턴한다.
 */
int pthread_pool_init(pthread_pool_t *pool, size_t bee_size, size_t queue_size)
{
    //들어온 매개변수가 임계치를 넘었거나 queue_size가 너무 작은지 검사하여 조정
    if (bee_size > POOL_MAXBSIZE || queue_size > POOL_MAXQSIZE) return POOL_FAIL;
    if (queue_size < bee_size) queue_size = bee_size;

    //각 변수 초기화
    pool -> bee_size = bee_size;
    pool -> q_size = queue_size;
    pool -> q_front = 0;
    pool -> q_len = 0;

    //대기열과 일꾼들 메모리 할당
    pool -> q = malloc(queue_size * sizeof(task_t));
    if (pool -> q == NULL) return POOL_FAIL;
    pool -> bee = malloc(bee_size * sizeof(pthread_t));
    if (pool -> bee == NULL) return POOL_FAIL;

    //스레드풀에서 사용할 뮤텍스와 조건변수 초기화
    pthread_mutex_init(&pool -> mutex, NULL);
    pthread_cond_init(&pool -> full, NULL);
    pthread_cond_init(&pool -> empty, NULL);

    //스레드풀 켜짐으로 변경
    pool -> state = ON;
    
    //일꾼 스레드 생성
    for (int i = 0; i < pool -> bee_size; i++) {
        pthread_create(pool -> bee + i, NULL, worker, pool);
    }

    return POOL_SUCCESS;

}  

/*
 * 스레드풀에서 실행시킬 함수와 인자의 주소를 넘겨주며 작업을 요청한다.
 * 스레드풀의 대기열이 꽉 찬 상황에서 flag이 POOL_NOWAIT이면 즉시 POOL_FULL을 리턴한다.
 * POOL_WAIT이면 대기열에 빈 자리가 나올 때까지 기다렸다가 넣고 나온다.
 * 작업 요청이 성공하면 POOL_SUCCESS를 그렇지 않으면 POOL_FAIL을 리턴한다.
 */
int pthread_pool_submit(pthread_pool_t *pool, void (*f)(void *p), void *p, int flag)
{
    pthread_mutex_lock(&pool -> mutex);
    
    //스레드풀의 대기열이 가득 찬 경우
    if (pool -> state == ON && pool -> q_len == pool -> q_size) {
        //POOL_WAIT 옵션인 경우
        if (flag == POOL_WAIT) {
            //대기열에 자리가 날 때까지 대기
            while (pool -> state == ON && pool -> q_len == pool -> q_size)
                pthread_cond_wait(&pool -> empty, &pool -> mutex);
        }
        //POOL_NOWAIT 옵션인 경우
        else if (flag == POOL_NOWAIT) {
            //기다리지 않고 리턴
            pthread_mutex_unlock(&pool -> mutex);
            return POOL_FULL;
        }
    }
    //스레드풀이 ON이 아닌 경우
    if (pool -> state != ON) {
        //더이상 대기열에 일을 받지 않고 리턴
        pthread_mutex_unlock(&pool -> mutex);
        return POOL_FAIL;
    }
    
    //대기열의 알맞은 위치에 일 추가
    pool -> q[(pool -> q_front + pool -> q_len) % pool -> q_size].function = f;
    pool -> q[(pool -> q_front + pool -> q_len) % pool -> q_size].param = p;
    pool -> q_len++;
    
    //대기열에 일이 생기길 기다리는 일꾼 깨워주기
    pthread_cond_signal(&pool -> full);
    pthread_mutex_unlock(&pool -> mutex);
    
    return POOL_SUCCESS;
}

/*
 * 스레드풀을 종료한다. 일꾼 스레드가 현재 작업 중이면 그 작업을 마치게 한다.
 * how의 값이 POOL_COMPLETE이면 대기열에 남아 있는 모든 작업을 마치고 종료한다.
 * POOL_DISCARD이면 대기열에 새 작업이 남아 있어도 더 이상 수행하지 않고 종료한다.
 * 메인(부모) 스레드는 종료된 일꾼 스레드와 조인한 후에 스레드풀에 할당된 자원을 반납한다.
 * 스레드를 종료시키기 위해 철회를 생각할 수 있으나 바람직하지 않다.
 * 락을 소유한 스레드를 중간에 철회하면 교착상태가 발생하기 쉽기 때문이다.
 * 종료가 완료되면 POOL_SUCCESS를 리턴한다.
 */
int pthread_pool_shutdown(pthread_pool_t *pool, int how)
{
    pthread_mutex_lock(&pool -> mutex);

    //POOL_COMPLETE 옵션인 경우 남은 일을 정리하고 끝낼 수 있도록 상태를 STANDBY로 설정
    if (how == POOL_COMPLETE) pool -> state = STANDBY;
    //POOL_DISCARD 옵션인 경우 바로 끝낼 수 있도록 상태를 OFF로 설정
    else if (how == POOL_DISCARD) pool -> state = OFF;

    //대기중인 일꾼, 함수 모두 깨우기
    pthread_cond_broadcast(&pool -> full);
    pthread_cond_broadcast(&pool -> empty);
    pthread_mutex_unlock(&pool -> mutex);
    
    //모든 일꾼의 종료를 대기
    for (int i = 0; i < pool -> bee_size; i++) {
        pthread_join(pool -> bee[i], NULL);
    }
    
    //할당했던 메모리 해제
    free(pool -> q);
    free(pool -> bee);

    return POOL_SUCCESS;
}
