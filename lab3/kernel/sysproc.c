#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


//#ifdef LAB_PGTBL
int
sys_pgaccess(void) {
  uint64 addr;
  int len;
  uint64 bitmask;
  // 接收用户空间传进来的参数
  if (argaddr(0, &addr) < 0) {
    return -1;
  }
  if (argint(1, &len) < 0) {
    return -1;
  }
  if (argaddr(2, &bitmask) < 0) {
    return -1;
  }
  // 防止给的参数页表长度过大或过小
  if (len > 32 || len < 0) {
    return -1;
  }

  // 存储访问结果，以掩码表示
  int count = 0;
  struct proc *p = myproc();
  for (int i = 0; i < len; ++i) {
    // 获取下一页的地址
    int va = addr + i*PGSIZE;
    // 查看该页面是否被访问
    int abit = vm_pgaccess(p->pagetable, va);
    // 修改结果
    count = count | abit << i;
  }
  
  // 将值复制给bitmask，返回给用户空间
  if (copyout(p->pagetable, bitmask, (char*)&count, sizeof count) < 0) {
    return -1;
  }
  return 0;
}
//#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
