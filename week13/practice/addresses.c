#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {

    int num = atoi(argv[1]);
    int page_num = num/4096;
    int offset_num = num%4096;

    printf("The address %d contains:\n", num);
    printf("page number: %d\n", page_num);
    printf("offset number: %d\n", offset_num);
    
    return 0;
}