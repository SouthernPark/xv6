#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define PRIME_END 280
#define INT_SIZE sizeof(int)
/*
  Rule 1: always good to close duplicate pipes not used in another process
  Rule 2: always good to close pipes that are currently using before exit
 */

void sieve(int*) __attribute__((noreturn));

int main(int argc, char* argv[])
{

  int pid;
  int p[2];

  pipe(p);
  
  pid = fork();

  if(pid == 0) {
    /* child to sieve the number */
    sieve(p);
  }
  else {
    /* Rule 1 */ 
    close(p[0]);
    /* main process populate numbers from 2 to 280  */
    for(int i=2; i<=PRIME_END; i++) {
      write(p[1], &i, INT_SIZE);
    }
    close(p[1]);
    wait((int*) 0);
  }

  exit(0);
}

void sieve(int* from_pipes)
{
  /*
    prime is the first num come to current porcess and must be a prime
    num is used to hold following numbers
    if n is a multiple of p, current process drop it
    ow pass to next process
  */
  int prime, num, pid;
  int to_pipes[2];
  /* Rule 1 */ 
  close(from_pipes[1]);
  
  /* read for num from previous neighbour */
  if(read(from_pipes[0], &prime, INT_SIZE) == 0) {
    /* Rule 2 */
    close(from_pipes[0]);
    exit(0);
  }

  fprintf(1, "prime %d\n", prime);

  pipe(to_pipes);

  pid = fork();
  if(pid == 0) {
    /* child will never use from pipes */
    close(from_pipes[0]);
    sieve(to_pipes);
  }
  else {
    /* Rule 1 */
    close(to_pipes[0]);
    // read to num and decide to drop it or pass down
    while(read(from_pipes[0], &num, INT_SIZE) != 0) {
      if(num % prime) {
        write(to_pipes[1], &num, INT_SIZE);
      }
    }
    /* if read returns 0, means program finished */
    /* Rule 2 */
    close(from_pipes[0]);
    close(to_pipes[1]);
    wait((int *) 0);
  }

  exit(0);
}

