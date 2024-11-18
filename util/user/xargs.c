#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"
#include <stddef.h>
#define MAX_LINE_LEN 512

/*
  read one line and write to buffer
  return 0 if successfully read one
  return 1 if EOF
  Exit if out of boundary
 */
int readline(char* buf) {
  char* p = buf;

  while(read(0, p, 1) != 0){
    if(*p == '\n') {
      *p = 0;
      return 0;
    }
    p++;

    if(p >= buf + MAX_LINE_LEN) {
      fprintf(2, "line too long\n");
      exit(1);
    }
  }

  // EOF
  *p = 0;
  return 1;
}

int main(int argc, char* argv[])
{
  int pid;
  int read_end;
  int xargc;
  char line[MAX_LINE_LEN];
  char* xargv[MAXARG];

  if(argc < 2) {
    fprintf(2, "Usage: xargs [args ...]\n");
    exit(1);
  }

  if(argc == MAXARG - 1) {
    fprintf(2, "Exceed MAXARG %d\n", MAXARG);
    exit(1);
  }

  xargc = 0;
  while(xargc < argc - 1) {
    xargv[xargc] = argv[xargc + 1];
    xargc ++;
  }
  xargv[xargc] = NULL;
  
  do {
    read_end = readline(line);

    if(read_end) break;
    
    pid = fork();
    if(pid == 0) {
      
      xargv[xargc] = line;
      xargc ++;
      xargv[xargc] = NULL;

      exec(xargv[0], xargv);
      fprintf(2, "exec: %s failed", xargv[0]);
      exit(1);
    }
    else {
      wait(0);
    }
  } while(read_end != 1);

  exit(0);
}

