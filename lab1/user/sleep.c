#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if(argc <= 1){
        printf("error");
        exit(1);
    }
    // argv[1]是传入main的第一个参数，表示sleep的睡眠时间
    sleep(atoi(argv[1]));
    exit(0);
}