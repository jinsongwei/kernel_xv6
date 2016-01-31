#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

//char buf[8192];
//char name[3];
//char *echoargv[] = { "echo", "ALL", "TESTS", "PASSED", 0 };
int stdout = 1;

void counttest(void){
    printf(1,"testing count\n");

  printf(1,"init, count = %d\n", count());
  if(mkdir("dir0") < 0){
    printf(stdout, "mkdir failed\n");
    exit();
  }
  printf(1,"mkdir, syscall count = %d\n", count());

  if(chdir("dir0") < 0){
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  printf(1,"chdir, syscall count = %d\n", count());
  if(chdir("..") < 0){
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }

  printf(1,"unlink, syscall count = %d\n", count());
    int num = count();

    printf(1,"total syscall count = %d\n",num);
}

int main(){



    counttest();
//    lottery_test();
    exit();
}


