#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

/*
  Some basic knowledge on file system:

  1. The OS maintains the Open File table (System-wide). Represents a file or resource that is currently open by any process in the system.
     a. The open() will create an entry in the open file table.
     b. maps fd to the following:
        content:
             a. pointer to inode
             b. file offset
             c. file access mode
             ...
     c. fstat(fd, stat) queries Open File table to get the inode and fetch the meta data

  2. meta data is stored in inode. (file type, size)

  3. inode does not contain file name. filename is stored as directory entry (content of a directory file)

  4. Each process maintains its own File Descriptor Table.
     a. Each fd entry has a pointer pointing to open table entry
     b. fork copies the File Descriptor table
     c. dup create a new FD entry but points to the same open table entry
     d. that's why the following invaraint holds:
        Two file descriptors share an offset if they were derived from the same original file descriptor
        by a sequence of fork and dup calls.
 */

/* ex: for a/b/cde, return pointer to cde */
char*
fmtname(char *path)
{
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  return p;
}

void
find(char* path, char* filename){
  int fd;
  char buf[512], *p;
  struct stat st; /* inode meta data */
  struct dirent de; /* dir entry */


  if((fd = open(path, O_RDONLY)) < 0) {
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  /* meta data */
  if(fstat(fd, &st) < 0) {
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type) {
  case T_DEVICE:
  case T_FILE:
    // path is pointing to a file
    char* path_file_name = fmtname(path);

    if(strcmp(filename, path_file_name) == 0) {
      printf("%s\n", path);
    }
    break;

  case T_DIR:
    /* compose path */
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/'; /* usr/, usr//, usr/// refer to the same dir */

    /* go deepper */
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
      if(de.inum == 0 || strcmp(".", de.name) == 0 || strcmp("..", de.name) == 0) continue;

      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;

      find(buf, filename);

    }

  }

  close(fd);

  return;

}

int main(int argc, char* argv[])
{

  if(argc != 3) {
    fprintf(2, "usage: find DIR FILE_NAME\n");
    exit(1);
  }

  find(argv[1], argv[2]);

  exit(0);

}

