#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

#define buf_size 512

int main(int argc, char *argv[]) {
  // 声明一个buf，存储标准输入
  char buf[buf_size];
  int line = 0;
  // 声明一个数组，用来存储xargs echo后的字符
  char *xargv[MAXARG] = {0};

  // 依次将命令行中输入的参数放到xargv数组中，argv[1]为实际的第一个参数，因此i从1开始
  for (int i = 1; i < argc; ++i) {
    xargv[i - 1] = argv[i];
  }

  // 读取标准输入，并存储到buf中
  int len = read(0, buf, sizeof buf);

  for (int i = 0; i < len; ++i) {
      // 由于如果遇到\n需要换行输出，因此要存储行数
      if (buf[i] == '\n') {
          ++line;
      }
  }
  // 储存每一行的字符，也就是两个\n之间的字符
  char output[line][128];

  int l = 0, index = 0; 
  for (int i = 0; i < len; ++i) {
      // 存储该行数据
      output[l][index++] = buf[i];
      // 遇到换行符则进入下一行，令当前行l+1，令当前行的索引index=0
      if (buf[i] == '\n') {
          output[l][index - 1] = 0; 
          ++l;
          index = 0;
      }
  }

  // out_line表示当前输出的是第几行，size表示的是xargv的总长
  int out_line = 0, size = sizeof(xargv);
  while (out_line < line) {
    xargv[size] = output[out_line++]; // 将每一行数据都分别拼接在原命令参数后
    if (fork() == 0) { 
        // 子进程执行输出
        exec(argv[1], xargv);
        exit(0);
    }
    wait(0);
  }
  exit(0);
}