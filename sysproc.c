#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
    int pidfork = fork();
    if(pidfork == 0){
        proc->scount = 0;
        proc->ticket=10;
    }
    else
        proc->scount++;
    return pidfork;
}

int
sys_exit(void)
{
    //add scount
    proc->scount++;
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
    //add scount
    proc->scount++;
  return wait();
}

int
sys_kill(void)
{
    //add scount
    proc->scount++;
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
    //add scount
    proc->scount++;
  return proc->pid;
}

int
sys_sbrk(void)
{
    //add scount
    proc->scount++;
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
    //add scount
    proc->scount++;
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
    //add scount
    proc->scount++;
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//add new count syscall
//need to be implemented
int
sys_count(void)
{
    //add scount
    proc->scount++;
    return proc->scount;
}
