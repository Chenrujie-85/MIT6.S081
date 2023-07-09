#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

/* retrieve the filename from whole path */
char *basename(char *pathname) {
  char *prev = 0;
  char *curr = strchr(pathname, '/');
  while (curr != 0) {
    prev = curr;
    curr = strchr(curr + 1, '/');
  }
  return prev;
}

/* recursive */
void find(char *curr_path, char *target) {
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(curr_path, 0)) < 0) {
    fprintf(2, "find: cannot open %s\n", curr_path);
    return;
  }

  if (fstat(fd, &st) < 0) {
    fprintf(2, "find: cannot stat %s\n", curr_path);
    close(fd);
    return;
  }
  char *f_name;
  switch (st.type) {

  case T_FILE:
    // 接收返回回来的最后一个目录，如curr_path是/home/user/ls.c，则返回user/ls.c
    f_name = basename(curr_path);
    int match = 1;
    // 如果文件名为空，或者文件名和target不一致，则说明没找到目标文件
    if (f_name == 0 || strcmp(f_name + 1, target) != 0) {
      match = 0;
    }
    if (match)
      // 输出完整路径
      printf("%s\n", curr_path);
    close(fd);
    break;

  case T_DIR:
    // 初始化buf
    memset(buf, 0, sizeof(buf));
    uint curr_path_len = strlen(curr_path);
    // 将完整的路径存入buf中
    memcpy(buf, curr_path, curr_path_len);
    buf[curr_path_len] = '/';
    p = buf + curr_path_len + 1;
    // 循环读取当前文件，如果读取到了非.和..的路径，则进入该路径再次find
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      if (de.inum == 0 || strcmp(de.name, ".") == 0 ||
          strcmp(de.name, "..") == 0)
        continue;
      // DIRSIZ是文件名的最大长度，值为14
      memcpy(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      find(buf, target); 
    }
    close(fd);
    break;
  }
}

int main(int argc, char *argv[])
{
  if (argc != 3) {
    fprintf(2, "usage: find [directory] [target filename]\n");
    exit(1);
  }
  find(argv[1], argv[2]);
  exit(0);
}