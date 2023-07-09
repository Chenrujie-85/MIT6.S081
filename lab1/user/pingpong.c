#include "kernel/types.h"
#include "user/user.h"

int main()
{
    // 创建两个管道，p1负责将数据从父传到子，p2相反
    int p1[2], p2[2];
    pipe(p1);
    pipe(p2);
    // 创建一个缓冲区用来存储数据
    char buf[1];
    // 创建一个子进程
    int pid = fork();
    // 当pid == 0代表这是子进程，进入子进程的处理流程
    if (pid == 0) {
        // 关闭管道p1的写段和p2的读端
        close(p1[1]);
        close(p2[0]);

        read(p1[0], buf, sizeof buf);
        printf("%d: received ping\n", getpid());
        write(p2[1], buf, sizeof buf);
        exit(0);
    }
    else {
        // 关闭p1的读端和p2的写端
        close(p1[0]);
        close(p2[1]);

        write(p1[1], buf, sizeof buf);
        read(p2[0], buf, sizeof buf);
        printf("%d: received pong\n", getpid());
        exit(0);
    }
}