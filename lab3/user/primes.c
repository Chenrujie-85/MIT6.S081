// user/primes.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define SIZE 34

void recur(int p[2]) {
    int primes, nums;
    int p1[2];

    close(0); 
    dup(p[0]);
    close(p[0]);
    close(p[1]);

    if (read(0, &primes, 4)) {
        printf("prime %d\n", primes); 

        pipe(p1);
        if (fork() == 0) {
            recur(p1); 
        } 
        else {
            while (read(0, &nums, 4)) { 
                if (nums % primes != 0) { 
                    write(p1[1], &nums, 4);
                }
            }
            close(p1[1]);
            close(0);
            wait(0);
        }
    } else {
        close(0); 
    }
    exit(0);
}

int main() {
    int p[2];
    pipe(p);
    for (int i = 2; i < SIZE + 2; ++i) {
        write(p[1], &i, 4);
    }
    if (fork() == 0) {
        recur(p);
    } else {
        close(p[1]);
        wait(0);
    }
    exit(0);
}
