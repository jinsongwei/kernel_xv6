#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
//#include "proc.h"

int stdout = 1;
char *argv1[] = { "./lot_child", 0 };
char *argv2[] = { "./lot_parent", 0 };


int main(){
    int pid_c = fork();
    // proc->name = "parent";
    if(pid_c < 0){
        printf(stdout,"lottery fork fail");
        exit();
    }else if(pid_c == 0){
        exec("./lot_parent",argv2);
        printf(stdout,"lottery exec fails");
        exit();
    }

    int pid_p = fork();

    if(pid_p < 0){
        printf(stdout,"lottery fork fail");
        exit();
    }else if(pid_p == 0){
        exec("./lot_child",argv1);
        printf(stdout,"lottery exec fails");
        exit();
    }
    
    wait();
    exit();
}

