#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"


int stdout = 1;

int fibonacci(int n){
//
//    if(n%5 == 0)
//        sleep(1);
//    if(n<2){
//        return 1;
//    }else{
//        return fibonacci(n-2) + fibonacci(n-1);
//    }
    int i,j,k;
    int m = 0;
    for (i=0;i<n;i++){
        if(i % 10 == 0 )
            sleep(1);
        for (j=0;j<n;j++)
            for (k=0;k<n;k++)
                m += 1;
    }
    return 0;
}

int main(int argc, char * argv[]){
    // proc->name = "child";
    printf(stdout,"\n\nI am Child\n\n");
    fibonacci(1000);
    printf(stdout,"\n\nfinishing child.....\n\n");
    exit();
}
