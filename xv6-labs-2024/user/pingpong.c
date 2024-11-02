#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]){

  int p1[2], p2[2];
  char buf[1] = {'a'};
  int n = 1;
  int pid;

  if(pipe(p1) < 0 || pipe(p2) < 0) {
    fprintf(2, "pipe error\n");
    exit(1);
  }

  pid = fork();
  
  if(pid != 0) {    
    // parent process
    int cur_pid = getpid();
    
    close(p1[0]);
    close(p2[1]);
    
    if(write(p1[1], buf, n) < n) {
      fprintf(2, "%d: write error\n", cur_pid);
      close(p1[1]);
      close(p2[0]);
      exit(1);
    }

    if(read(p2[0], buf, n) < n) {
      fprintf(2, "%d: read error\n", cur_pid);
      close(p1[1]);
      close(p2[0]);
      exit(1);
    }
    
    fprintf(1, "%d: received pong\n", cur_pid);

    close(p1[1]);
    close(p2[0]);
    
    exit(0);
  }
  else {
    // child process
    int cur_pid = getpid();
    
    close(p2[0]);
    close(p1[1]);
    
    if(read(p1[0], buf, n) < n) {
      fprintf(2, "%d: read error\n", cur_pid);
      close(p1[0]);
      close(p2[1]);
      exit(1);
    }
    
    fprintf(1, "%d: received ping\n", cur_pid);

    if(write(p2[1], buf, n) < n) {
      fprintf(2, "%d: write error\n", cur_pid);
      close(p1[0]);
      close(p2[1]);
      exit(1);
    }

    close(p1[0]);
    close(p2[1]);
    
    exit(0);
  }
  
  exit(0);
}
