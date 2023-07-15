#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
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
  // 调用backtrace()
  backtrace(); 
  return 0;
}

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

uint64 sys_sigalarm(void)
{
  int interval;
  uint64 handler;

  struct proc *p;
  // 接收用户空间传进来的报警间隔和处理函数
  if(argint(0, &interval)<0 || argaddr(1, &handler)<0) 
    return -1;
  // 获取当前占用CPU的进程的proc
  p = myproc();

  // 填充该进程的proc的相应字段
  p->interval = interval;
  p->handler = handler;
  p->ticks_cnt = 0;

  return 0;
} 

uint64 sys_sigreturn(void)
{
  // 获取当前占用CPU的进程的proc
  struct proc *p = myproc();
  // 恢复进程的现场
  *(p->trapframe) = *(p->tick_trapframe);
  // 中断处理函数执行完毕
  p->handler_exec = 0;
  return 0;
}