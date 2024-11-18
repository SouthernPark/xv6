
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
 */

/* ex: for a/b/cde, return pointer to cde */
char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	22e000ef          	jal	23a <strlen>
  10:	1502                	slli	a0,a0,0x20
  12:	9101                	srli	a0,a0,0x20
  14:	9526                	add	a0,a0,s1
  16:	02f00713          	li	a4,47
  1a:	00956963          	bltu	a0,s1,2c <fmtname+0x2c>
  1e:	00054783          	lbu	a5,0(a0)
  22:	00e78563          	beq	a5,a4,2c <fmtname+0x2c>
  26:	157d                	addi	a0,a0,-1
  28:	fe957be3          	bgeu	a0,s1,1e <fmtname+0x1e>
    ;
  p++;

  return p;
}
  2c:	0505                	addi	a0,a0,1
  2e:	60e2                	ld	ra,24(sp)
  30:	6442                	ld	s0,16(sp)
  32:	64a2                	ld	s1,8(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret

0000000000000038 <find>:

void
find(char* path, char* filename){
  38:	d9010113          	addi	sp,sp,-624
  3c:	26113423          	sd	ra,616(sp)
  40:	26813023          	sd	s0,608(sp)
  44:	25213823          	sd	s2,592(sp)
  48:	25313423          	sd	s3,584(sp)
  4c:	1c80                	addi	s0,sp,624
  4e:	892a                	mv	s2,a0
  50:	89ae                	mv	s3,a1
  char buf[512], *p;
  struct stat st; /* inode meta data */
  struct dirent de; /* dir entry */


  if((fd = open(path, O_RDONLY)) < 0) {
  52:	4581                	li	a1,0
  54:	436000ef          	jal	48a <open>
  58:	04054d63          	bltz	a0,b2 <find+0x7a>
  5c:	24913c23          	sd	s1,600(sp)
  60:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  /* meta data */
  if(fstat(fd, &st) < 0) {
  62:	da840593          	addi	a1,s0,-600
  66:	43c000ef          	jal	4a2 <fstat>
  6a:	04054d63          	bltz	a0,c4 <find+0x8c>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type) {
  6e:	db041783          	lh	a5,-592(s0)
  72:	4705                	li	a4,1
  74:	06e78e63          	beq	a5,a4,f0 <find+0xb8>
  78:	37f9                	addiw	a5,a5,-2
  7a:	17c2                	slli	a5,a5,0x30
  7c:	93c1                	srli	a5,a5,0x30
  7e:	00f76a63          	bltu	a4,a5,92 <find+0x5a>
  case T_DEVICE:
  case T_FILE:
    // path is pointing to a file
    char* path_file_name = fmtname(path);
  82:	854a                	mv	a0,s2
  84:	f7dff0ef          	jal	0 <fmtname>
  88:	85aa                	mv	a1,a0

    if(strcmp(filename, path_file_name) == 0) {
  8a:	854e                	mv	a0,s3
  8c:	182000ef          	jal	20e <strcmp>
  90:	c921                	beqz	a0,e0 <find+0xa8>

    }

  }

  close(fd);
  92:	8526                	mv	a0,s1
  94:	3de000ef          	jal	472 <close>
  98:	25813483          	ld	s1,600(sp)

  return;

}
  9c:	26813083          	ld	ra,616(sp)
  a0:	26013403          	ld	s0,608(sp)
  a4:	25013903          	ld	s2,592(sp)
  a8:	24813983          	ld	s3,584(sp)
  ac:	27010113          	addi	sp,sp,624
  b0:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
  b2:	864a                	mv	a2,s2
  b4:	00001597          	auipc	a1,0x1
  b8:	95c58593          	addi	a1,a1,-1700 # a10 <malloc+0xfa>
  bc:	4509                	li	a0,2
  be:	77a000ef          	jal	838 <fprintf>
    return;
  c2:	bfe9                	j	9c <find+0x64>
    fprintf(2, "ls: cannot stat %s\n", path);
  c4:	864a                	mv	a2,s2
  c6:	00001597          	auipc	a1,0x1
  ca:	96258593          	addi	a1,a1,-1694 # a28 <malloc+0x112>
  ce:	4509                	li	a0,2
  d0:	768000ef          	jal	838 <fprintf>
    close(fd);
  d4:	8526                	mv	a0,s1
  d6:	39c000ef          	jal	472 <close>
    return;
  da:	25813483          	ld	s1,600(sp)
  de:	bf7d                	j	9c <find+0x64>
      printf("%s\n", path);
  e0:	85ca                	mv	a1,s2
  e2:	00001517          	auipc	a0,0x1
  e6:	93e50513          	addi	a0,a0,-1730 # a20 <malloc+0x10a>
  ea:	778000ef          	jal	862 <printf>
  ee:	b755                	j	92 <find+0x5a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
  f0:	854a                	mv	a0,s2
  f2:	148000ef          	jal	23a <strlen>
  f6:	2541                	addiw	a0,a0,16
  f8:	20000793          	li	a5,512
  fc:	00a7f963          	bgeu	a5,a0,10e <find+0xd6>
      printf("ls: path too long\n");
 100:	00001517          	auipc	a0,0x1
 104:	94050513          	addi	a0,a0,-1728 # a40 <malloc+0x12a>
 108:	75a000ef          	jal	862 <printf>
      break;
 10c:	b759                	j	92 <find+0x5a>
 10e:	25413023          	sd	s4,576(sp)
 112:	23513c23          	sd	s5,568(sp)
 116:	23613823          	sd	s6,560(sp)
    strcpy(buf, path);
 11a:	85ca                	mv	a1,s2
 11c:	dc040513          	addi	a0,s0,-576
 120:	0d2000ef          	jal	1f2 <strcpy>
    p = buf+strlen(buf);
 124:	dc040513          	addi	a0,s0,-576
 128:	112000ef          	jal	23a <strlen>
 12c:	1502                	slli	a0,a0,0x20
 12e:	9101                	srli	a0,a0,0x20
 130:	dc040793          	addi	a5,s0,-576
 134:	00a78933          	add	s2,a5,a0
    *p++ = '/'; /* usr/, usr//, usr/// refer to the same dir */
 138:	00190b13          	addi	s6,s2,1
 13c:	02f00793          	li	a5,47
 140:	00f90023          	sb	a5,0(s2)
      if(de.inum == 0 || strcmp(".", de.name) == 0 || strcmp("..", de.name) == 0) continue;
 144:	00001a17          	auipc	s4,0x1
 148:	914a0a13          	addi	s4,s4,-1772 # a58 <malloc+0x142>
 14c:	00001a97          	auipc	s5,0x1
 150:	914a8a93          	addi	s5,s5,-1772 # a60 <malloc+0x14a>
    while(read(fd, &de, sizeof(de)) == sizeof(de)) {
 154:	4641                	li	a2,16
 156:	d9840593          	addi	a1,s0,-616
 15a:	8526                	mv	a0,s1
 15c:	306000ef          	jal	462 <read>
 160:	47c1                	li	a5,16
 162:	02f51f63          	bne	a0,a5,1a0 <find+0x168>
      if(de.inum == 0 || strcmp(".", de.name) == 0 || strcmp("..", de.name) == 0) continue;
 166:	d9845783          	lhu	a5,-616(s0)
 16a:	d7ed                	beqz	a5,154 <find+0x11c>
 16c:	d9a40593          	addi	a1,s0,-614
 170:	8552                	mv	a0,s4
 172:	09c000ef          	jal	20e <strcmp>
 176:	dd79                	beqz	a0,154 <find+0x11c>
 178:	d9a40593          	addi	a1,s0,-614
 17c:	8556                	mv	a0,s5
 17e:	090000ef          	jal	20e <strcmp>
 182:	d969                	beqz	a0,154 <find+0x11c>
      memmove(p, de.name, DIRSIZ);
 184:	4639                	li	a2,14
 186:	d9a40593          	addi	a1,s0,-614
 18a:	855a                	mv	a0,s6
 18c:	210000ef          	jal	39c <memmove>
      p[DIRSIZ] = 0;
 190:	000907a3          	sb	zero,15(s2)
      find(buf, filename);
 194:	85ce                	mv	a1,s3
 196:	dc040513          	addi	a0,s0,-576
 19a:	e9fff0ef          	jal	38 <find>
 19e:	bf5d                	j	154 <find+0x11c>
 1a0:	24013a03          	ld	s4,576(sp)
 1a4:	23813a83          	ld	s5,568(sp)
 1a8:	23013b03          	ld	s6,560(sp)
 1ac:	b5dd                	j	92 <find+0x5a>

00000000000001ae <main>:

int main(int argc, char* argv[])
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16

  if(argc != 3) {
 1b6:	470d                	li	a4,3
 1b8:	00e50c63          	beq	a0,a4,1d0 <main+0x22>
    fprintf(2, "usage: find DIR FILE_NAME\n");
 1bc:	00001597          	auipc	a1,0x1
 1c0:	8ac58593          	addi	a1,a1,-1876 # a68 <malloc+0x152>
 1c4:	4509                	li	a0,2
 1c6:	672000ef          	jal	838 <fprintf>
    exit(1);
 1ca:	4505                	li	a0,1
 1cc:	27e000ef          	jal	44a <exit>
 1d0:	87ae                	mv	a5,a1
  }

  find(argv[1], argv[2]);
 1d2:	698c                	ld	a1,16(a1)
 1d4:	6788                	ld	a0,8(a5)
 1d6:	e63ff0ef          	jal	38 <find>

  exit(0);
 1da:	4501                	li	a0,0
 1dc:	26e000ef          	jal	44a <exit>

00000000000001e0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1e8:	fc7ff0ef          	jal	1ae <main>
  exit(0);
 1ec:	4501                	li	a0,0
 1ee:	25c000ef          	jal	44a <exit>

00000000000001f2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f8:	87aa                	mv	a5,a0
 1fa:	0585                	addi	a1,a1,1
 1fc:	0785                	addi	a5,a5,1
 1fe:	fff5c703          	lbu	a4,-1(a1)
 202:	fee78fa3          	sb	a4,-1(a5)
 206:	fb75                	bnez	a4,1fa <strcpy+0x8>
    ;
  return os;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 214:	00054783          	lbu	a5,0(a0)
 218:	cb91                	beqz	a5,22c <strcmp+0x1e>
 21a:	0005c703          	lbu	a4,0(a1)
 21e:	00f71763          	bne	a4,a5,22c <strcmp+0x1e>
    p++, q++;
 222:	0505                	addi	a0,a0,1
 224:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbe5                	bnez	a5,21a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 22c:	0005c503          	lbu	a0,0(a1)
}
 230:	40a7853b          	subw	a0,a5,a0
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <strlen>:

uint
strlen(const char *s)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 240:	00054783          	lbu	a5,0(a0)
 244:	cf91                	beqz	a5,260 <strlen+0x26>
 246:	0505                	addi	a0,a0,1
 248:	87aa                	mv	a5,a0
 24a:	86be                	mv	a3,a5
 24c:	0785                	addi	a5,a5,1
 24e:	fff7c703          	lbu	a4,-1(a5)
 252:	ff65                	bnez	a4,24a <strlen+0x10>
 254:	40a6853b          	subw	a0,a3,a0
 258:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  for(n = 0; s[n]; n++)
 260:	4501                	li	a0,0
 262:	bfe5                	j	25a <strlen+0x20>

0000000000000264 <memset>:

void*
memset(void *dst, int c, uint n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 26a:	ca19                	beqz	a2,280 <memset+0x1c>
 26c:	87aa                	mv	a5,a0
 26e:	1602                	slli	a2,a2,0x20
 270:	9201                	srli	a2,a2,0x20
 272:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 276:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 27a:	0785                	addi	a5,a5,1
 27c:	fee79de3          	bne	a5,a4,276 <memset+0x12>
  }
  return dst;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strchr>:

char*
strchr(const char *s, char c)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28c:	00054783          	lbu	a5,0(a0)
 290:	cb99                	beqz	a5,2a6 <strchr+0x20>
    if(*s == c)
 292:	00f58763          	beq	a1,a5,2a0 <strchr+0x1a>
  for(; *s; s++)
 296:	0505                	addi	a0,a0,1
 298:	00054783          	lbu	a5,0(a0)
 29c:	fbfd                	bnez	a5,292 <strchr+0xc>
      return (char*)s;
  return 0;
 29e:	4501                	li	a0,0
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
  return 0;
 2a6:	4501                	li	a0,0
 2a8:	bfe5                	j	2a0 <strchr+0x1a>

00000000000002aa <gets>:

char*
gets(char *buf, int max)
{
 2aa:	711d                	addi	sp,sp,-96
 2ac:	ec86                	sd	ra,88(sp)
 2ae:	e8a2                	sd	s0,80(sp)
 2b0:	e4a6                	sd	s1,72(sp)
 2b2:	e0ca                	sd	s2,64(sp)
 2b4:	fc4e                	sd	s3,56(sp)
 2b6:	f852                	sd	s4,48(sp)
 2b8:	f456                	sd	s5,40(sp)
 2ba:	f05a                	sd	s6,32(sp)
 2bc:	ec5e                	sd	s7,24(sp)
 2be:	1080                	addi	s0,sp,96
 2c0:	8baa                	mv	s7,a0
 2c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c4:	892a                	mv	s2,a0
 2c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c8:	4aa9                	li	s5,10
 2ca:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2cc:	89a6                	mv	s3,s1
 2ce:	2485                	addiw	s1,s1,1
 2d0:	0344d663          	bge	s1,s4,2fc <gets+0x52>
    cc = read(0, &c, 1);
 2d4:	4605                	li	a2,1
 2d6:	faf40593          	addi	a1,s0,-81
 2da:	4501                	li	a0,0
 2dc:	186000ef          	jal	462 <read>
    if(cc < 1)
 2e0:	00a05e63          	blez	a0,2fc <gets+0x52>
    buf[i++] = c;
 2e4:	faf44783          	lbu	a5,-81(s0)
 2e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2ec:	01578763          	beq	a5,s5,2fa <gets+0x50>
 2f0:	0905                	addi	s2,s2,1
 2f2:	fd679de3          	bne	a5,s6,2cc <gets+0x22>
    buf[i++] = c;
 2f6:	89a6                	mv	s3,s1
 2f8:	a011                	j	2fc <gets+0x52>
 2fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2fc:	99de                	add	s3,s3,s7
 2fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 302:	855e                	mv	a0,s7
 304:	60e6                	ld	ra,88(sp)
 306:	6446                	ld	s0,80(sp)
 308:	64a6                	ld	s1,72(sp)
 30a:	6906                	ld	s2,64(sp)
 30c:	79e2                	ld	s3,56(sp)
 30e:	7a42                	ld	s4,48(sp)
 310:	7aa2                	ld	s5,40(sp)
 312:	7b02                	ld	s6,32(sp)
 314:	6be2                	ld	s7,24(sp)
 316:	6125                	addi	sp,sp,96
 318:	8082                	ret

000000000000031a <stat>:

int
stat(const char *n, struct stat *st)
{
 31a:	1101                	addi	sp,sp,-32
 31c:	ec06                	sd	ra,24(sp)
 31e:	e822                	sd	s0,16(sp)
 320:	e04a                	sd	s2,0(sp)
 322:	1000                	addi	s0,sp,32
 324:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 326:	4581                	li	a1,0
 328:	162000ef          	jal	48a <open>
  if(fd < 0)
 32c:	02054263          	bltz	a0,350 <stat+0x36>
 330:	e426                	sd	s1,8(sp)
 332:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 334:	85ca                	mv	a1,s2
 336:	16c000ef          	jal	4a2 <fstat>
 33a:	892a                	mv	s2,a0
  close(fd);
 33c:	8526                	mv	a0,s1
 33e:	134000ef          	jal	472 <close>
  return r;
 342:	64a2                	ld	s1,8(sp)
}
 344:	854a                	mv	a0,s2
 346:	60e2                	ld	ra,24(sp)
 348:	6442                	ld	s0,16(sp)
 34a:	6902                	ld	s2,0(sp)
 34c:	6105                	addi	sp,sp,32
 34e:	8082                	ret
    return -1;
 350:	597d                	li	s2,-1
 352:	bfcd                	j	344 <stat+0x2a>

0000000000000354 <atoi>:

int
atoi(const char *s)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 35a:	00054683          	lbu	a3,0(a0)
 35e:	fd06879b          	addiw	a5,a3,-48
 362:	0ff7f793          	zext.b	a5,a5
 366:	4625                	li	a2,9
 368:	02f66863          	bltu	a2,a5,398 <atoi+0x44>
 36c:	872a                	mv	a4,a0
  n = 0;
 36e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 370:	0705                	addi	a4,a4,1
 372:	0025179b          	slliw	a5,a0,0x2
 376:	9fa9                	addw	a5,a5,a0
 378:	0017979b          	slliw	a5,a5,0x1
 37c:	9fb5                	addw	a5,a5,a3
 37e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 382:	00074683          	lbu	a3,0(a4)
 386:	fd06879b          	addiw	a5,a3,-48
 38a:	0ff7f793          	zext.b	a5,a5
 38e:	fef671e3          	bgeu	a2,a5,370 <atoi+0x1c>
  return n;
}
 392:	6422                	ld	s0,8(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  n = 0;
 398:	4501                	li	a0,0
 39a:	bfe5                	j	392 <atoi+0x3e>

000000000000039c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e422                	sd	s0,8(sp)
 3a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3a2:	02b57463          	bgeu	a0,a1,3ca <memmove+0x2e>
    while(n-- > 0)
 3a6:	00c05f63          	blez	a2,3c4 <memmove+0x28>
 3aa:	1602                	slli	a2,a2,0x20
 3ac:	9201                	srli	a2,a2,0x20
 3ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b4:	0585                	addi	a1,a1,1
 3b6:	0705                	addi	a4,a4,1
 3b8:	fff5c683          	lbu	a3,-1(a1)
 3bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3c0:	fef71ae3          	bne	a4,a5,3b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c4:	6422                	ld	s0,8(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret
    dst += n;
 3ca:	00c50733          	add	a4,a0,a2
    src += n;
 3ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3d0:	fec05ae3          	blez	a2,3c4 <memmove+0x28>
 3d4:	fff6079b          	addiw	a5,a2,-1
 3d8:	1782                	slli	a5,a5,0x20
 3da:	9381                	srli	a5,a5,0x20
 3dc:	fff7c793          	not	a5,a5
 3e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e2:	15fd                	addi	a1,a1,-1
 3e4:	177d                	addi	a4,a4,-1
 3e6:	0005c683          	lbu	a3,0(a1)
 3ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ee:	fee79ae3          	bne	a5,a4,3e2 <memmove+0x46>
 3f2:	bfc9                	j	3c4 <memmove+0x28>

00000000000003f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fa:	ca05                	beqz	a2,42a <memcmp+0x36>
 3fc:	fff6069b          	addiw	a3,a2,-1
 400:	1682                	slli	a3,a3,0x20
 402:	9281                	srli	a3,a3,0x20
 404:	0685                	addi	a3,a3,1
 406:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 408:	00054783          	lbu	a5,0(a0)
 40c:	0005c703          	lbu	a4,0(a1)
 410:	00e79863          	bne	a5,a4,420 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 414:	0505                	addi	a0,a0,1
    p2++;
 416:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 418:	fed518e3          	bne	a0,a3,408 <memcmp+0x14>
  }
  return 0;
 41c:	4501                	li	a0,0
 41e:	a019                	j	424 <memcmp+0x30>
      return *p1 - *p2;
 420:	40e7853b          	subw	a0,a5,a4
}
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret
  return 0;
 42a:	4501                	li	a0,0
 42c:	bfe5                	j	424 <memcmp+0x30>

000000000000042e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e406                	sd	ra,8(sp)
 432:	e022                	sd	s0,0(sp)
 434:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 436:	f67ff0ef          	jal	39c <memmove>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 442:	4885                	li	a7,1
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exit>:
.global exit
exit:
 li a7, SYS_exit
 44a:	4889                	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait>:
.global wait
wait:
 li a7, SYS_wait
 452:	488d                	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45a:	4891                	li	a7,4
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <read>:
.global read
read:
 li a7, SYS_read
 462:	4895                	li	a7,5
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <write>:
.global write
write:
 li a7, SYS_write
 46a:	48c1                	li	a7,16
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <close>:
.global close
close:
 li a7, SYS_close
 472:	48d5                	li	a7,21
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <kill>:
.global kill
kill:
 li a7, SYS_kill
 47a:	4899                	li	a7,6
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exec>:
.global exec
exec:
 li a7, SYS_exec
 482:	489d                	li	a7,7
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <open>:
.global open
open:
 li a7, SYS_open
 48a:	48bd                	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 492:	48c5                	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49a:	48c9                	li	a7,18
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a2:	48a1                	li	a7,8
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <link>:
.global link
link:
 li a7, SYS_link
 4aa:	48cd                	li	a7,19
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b2:	48d1                	li	a7,20
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ba:	48a5                	li	a7,9
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c2:	48a9                	li	a7,10
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ca:	48ad                	li	a7,11
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d2:	48b1                	li	a7,12
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4da:	48b5                	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e2:	48b9                	li	a7,14
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	1000                	addi	s0,sp,32
 4f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f6:	4605                	li	a2,1
 4f8:	fef40593          	addi	a1,s0,-17
 4fc:	f6fff0ef          	jal	46a <write>
}
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	6105                	addi	sp,sp,32
 506:	8082                	ret

0000000000000508 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 508:	7139                	addi	sp,sp,-64
 50a:	fc06                	sd	ra,56(sp)
 50c:	f822                	sd	s0,48(sp)
 50e:	f426                	sd	s1,40(sp)
 510:	0080                	addi	s0,sp,64
 512:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 514:	c299                	beqz	a3,51a <printint+0x12>
 516:	0805c963          	bltz	a1,5a8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51a:	2581                	sext.w	a1,a1
  neg = 0;
 51c:	4881                	li	a7,0
 51e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 522:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 524:	2601                	sext.w	a2,a2
 526:	00000517          	auipc	a0,0x0
 52a:	56a50513          	addi	a0,a0,1386 # a90 <digits>
 52e:	883a                	mv	a6,a4
 530:	2705                	addiw	a4,a4,1
 532:	02c5f7bb          	remuw	a5,a1,a2
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	97aa                	add	a5,a5,a0
 53c:	0007c783          	lbu	a5,0(a5)
 540:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 544:	0005879b          	sext.w	a5,a1
 548:	02c5d5bb          	divuw	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec7f0e3          	bgeu	a5,a2,52e <printint+0x26>
  if(neg)
 552:	00088c63          	beqz	a7,56a <printint+0x62>
    buf[i++] = '-';
 556:	fd070793          	addi	a5,a4,-48
 55a:	00878733          	add	a4,a5,s0
 55e:	02d00793          	li	a5,45
 562:	fef70823          	sb	a5,-16(a4)
 566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56a:	02e05a63          	blez	a4,59e <printint+0x96>
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	fc040793          	addi	a5,s0,-64
 576:	00e78933          	add	s2,a5,a4
 57a:	fff78993          	addi	s3,a5,-1
 57e:	99ba                	add	s3,s3,a4
 580:	377d                	addiw	a4,a4,-1
 582:	1702                	slli	a4,a4,0x20
 584:	9301                	srli	a4,a4,0x20
 586:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58a:	fff94583          	lbu	a1,-1(s2)
 58e:	8526                	mv	a0,s1
 590:	f5bff0ef          	jal	4ea <putc>
  while(--i >= 0)
 594:	197d                	addi	s2,s2,-1
 596:	ff391ae3          	bne	s2,s3,58a <printint+0x82>
 59a:	7902                	ld	s2,32(sp)
 59c:	69e2                	ld	s3,24(sp)
}
 59e:	70e2                	ld	ra,56(sp)
 5a0:	7442                	ld	s0,48(sp)
 5a2:	74a2                	ld	s1,40(sp)
 5a4:	6121                	addi	sp,sp,64
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bf85                	j	51e <printint+0x16>

00000000000005b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b0:	711d                	addi	sp,sp,-96
 5b2:	ec86                	sd	ra,88(sp)
 5b4:	e8a2                	sd	s0,80(sp)
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ba:	0005c903          	lbu	s2,0(a1)
 5be:	26090863          	beqz	s2,82e <vprintf+0x27e>
 5c2:	e4a6                	sd	s1,72(sp)
 5c4:	fc4e                	sd	s3,56(sp)
 5c6:	f852                	sd	s4,48(sp)
 5c8:	f456                	sd	s5,40(sp)
 5ca:	f05a                	sd	s6,32(sp)
 5cc:	ec5e                	sd	s7,24(sp)
 5ce:	e862                	sd	s8,16(sp)
 5d0:	e466                	sd	s9,8(sp)
 5d2:	8b2a                	mv	s6,a0
 5d4:	8a2e                	mv	s4,a1
 5d6:	8bb2                	mv	s7,a2
  state = 0;
 5d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5da:	4481                	li	s1,0
 5dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	06c00c93          	li	s9,108
 5ea:	a005                	j	60a <vprintf+0x5a>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	efbff0ef          	jal	4ea <putc>
 5f4:	a019                	j	5fa <vprintf+0x4a>
    } else if(state == '%'){
 5f6:	03598263          	beq	s3,s5,61a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5fa:	2485                	addiw	s1,s1,1
 5fc:	8726                	mv	a4,s1
 5fe:	009a07b3          	add	a5,s4,s1
 602:	0007c903          	lbu	s2,0(a5)
 606:	20090c63          	beqz	s2,81e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 60a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60e:	fe0994e3          	bnez	s3,5f6 <vprintf+0x46>
      if(c0 == '%'){
 612:	fd579de3          	bne	a5,s5,5ec <vprintf+0x3c>
        state = '%';
 616:	89be                	mv	s3,a5
 618:	b7cd                	j	5fa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 61a:	00ea06b3          	add	a3,s4,a4
 61e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 622:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 624:	c681                	beqz	a3,62c <vprintf+0x7c>
 626:	9752                	add	a4,a4,s4
 628:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 62c:	03878f63          	beq	a5,s8,66a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 630:	05978963          	beq	a5,s9,682 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 634:	07500713          	li	a4,117
 638:	0ee78363          	beq	a5,a4,71e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 63c:	07800713          	li	a4,120
 640:	12e78563          	beq	a5,a4,76a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 644:	07000713          	li	a4,112
 648:	14e78a63          	beq	a5,a4,79c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 64c:	07300713          	li	a4,115
 650:	18e78a63          	beq	a5,a4,7e4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 654:	02500713          	li	a4,37
 658:	04e79563          	bne	a5,a4,6a2 <vprintf+0xf2>
        putc(fd, '%');
 65c:	02500593          	li	a1,37
 660:	855a                	mv	a0,s6
 662:	e89ff0ef          	jal	4ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 666:	4981                	li	s3,0
 668:	bf49                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e91ff0ef          	jal	508 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bfad                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 682:	06400793          	li	a5,100
 686:	02f68963          	beq	a3,a5,6b8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68a:	06c00793          	li	a5,108
 68e:	04f68263          	beq	a3,a5,6d2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 692:	07500793          	li	a5,117
 696:	0af68063          	beq	a3,a5,736 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 69a:	07800793          	li	a5,120
 69e:	0ef68263          	beq	a3,a5,782 <vprintf+0x1d2>
        putc(fd, '%');
 6a2:	02500593          	li	a1,37
 6a6:	855a                	mv	a0,s6
 6a8:	e43ff0ef          	jal	4ea <putc>
        putc(fd, c0);
 6ac:	85ca                	mv	a1,s2
 6ae:	855a                	mv	a0,s6
 6b0:	e3bff0ef          	jal	4ea <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b791                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e43ff0ef          	jal	508 <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b72d                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d2:	06400793          	li	a5,100
 6d6:	02f60763          	beq	a2,a5,704 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6da:	07500793          	li	a5,117
 6de:	06f60963          	beq	a2,a5,750 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e2:	07800793          	li	a5,120
 6e6:	faf61ee3          	bne	a2,a5,6a2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e11ff0ef          	jal	508 <printint>
        i += 2;
 6fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bde5                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8913          	addi	s2,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	df7ff0ef          	jal	508 <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bdf9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000ba583          	lw	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	dddff0ef          	jal	508 <printint>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	b5d9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	dc5ff0ef          	jal	508 <printint>
        i += 1;
 748:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	b575                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	dabff0ef          	jal	508 <printint>
        i += 2;
 762:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	bd49                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	d91ff0ef          	jal	508 <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bdad                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4641                	li	a2,16
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d79ff0ef          	jal	508 <printint>
        i += 1;
 794:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	b585                	j	5fa <vprintf+0x4a>
 79c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 79e:	008b8d13          	addi	s10,s7,8
 7a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	855a                	mv	a0,s6
 7ac:	d3fff0ef          	jal	4ea <putc>
  putc(fd, 'x');
 7b0:	07800593          	li	a1,120
 7b4:	855a                	mv	a0,s6
 7b6:	d35ff0ef          	jal	4ea <putc>
 7ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	2d4b8b93          	addi	s7,s7,724 # a90 <digits>
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d1bff0ef          	jal	4ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	397d                	addiw	s2,s2,-1
 7d8:	fe0916e3          	bnez	s2,7c4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7dc:	8bea                	mv	s7,s10
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	6d02                	ld	s10,0(sp)
 7e2:	bd21                	j	5fa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7e4:	008b8993          	addi	s3,s7,8
 7e8:	000bb903          	ld	s2,0(s7)
 7ec:	00090f63          	beqz	s2,80a <vprintf+0x25a>
        for(; *s; s++)
 7f0:	00094583          	lbu	a1,0(s2)
 7f4:	c195                	beqz	a1,818 <vprintf+0x268>
          putc(fd, *s);
 7f6:	855a                	mv	a0,s6
 7f8:	cf3ff0ef          	jal	4ea <putc>
        for(; *s; s++)
 7fc:	0905                	addi	s2,s2,1
 7fe:	00094583          	lbu	a1,0(s2)
 802:	f9f5                	bnez	a1,7f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	bbcd                	j	5fa <vprintf+0x4a>
          s = "(null)";
 80a:	00000917          	auipc	s2,0x0
 80e:	27e90913          	addi	s2,s2,638 # a88 <malloc+0x172>
        for(; *s; s++)
 812:	02800593          	li	a1,40
 816:	b7c5                	j	7f6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbf9                	j	5fa <vprintf+0x4a>
 81e:	64a6                	ld	s1,72(sp)
 820:	79e2                	ld	s3,56(sp)
 822:	7a42                	ld	s4,48(sp)
 824:	7aa2                	ld	s5,40(sp)
 826:	7b02                	ld	s6,32(sp)
 828:	6be2                	ld	s7,24(sp)
 82a:	6c42                	ld	s8,16(sp)
 82c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 82e:	60e6                	ld	ra,88(sp)
 830:	6446                	ld	s0,80(sp)
 832:	6906                	ld	s2,64(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 838:	715d                	addi	sp,sp,-80
 83a:	ec06                	sd	ra,24(sp)
 83c:	e822                	sd	s0,16(sp)
 83e:	1000                	addi	s0,sp,32
 840:	e010                	sd	a2,0(s0)
 842:	e414                	sd	a3,8(s0)
 844:	e818                	sd	a4,16(s0)
 846:	ec1c                	sd	a5,24(s0)
 848:	03043023          	sd	a6,32(s0)
 84c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 850:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 854:	8622                	mv	a2,s0
 856:	d5bff0ef          	jal	5b0 <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6161                	addi	sp,sp,80
 860:	8082                	ret

0000000000000862 <printf>:

void
printf(const char *fmt, ...)
{
 862:	711d                	addi	sp,sp,-96
 864:	ec06                	sd	ra,24(sp)
 866:	e822                	sd	s0,16(sp)
 868:	1000                	addi	s0,sp,32
 86a:	e40c                	sd	a1,8(s0)
 86c:	e810                	sd	a2,16(s0)
 86e:	ec14                	sd	a3,24(s0)
 870:	f018                	sd	a4,32(s0)
 872:	f41c                	sd	a5,40(s0)
 874:	03043823          	sd	a6,48(s0)
 878:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87c:	00840613          	addi	a2,s0,8
 880:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 884:	85aa                	mv	a1,a0
 886:	4505                	li	a0,1
 888:	d29ff0ef          	jal	5b0 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret

0000000000000894 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 894:	1141                	addi	sp,sp,-16
 896:	e422                	sd	s0,8(sp)
 898:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89e:	00000797          	auipc	a5,0x0
 8a2:	7627b783          	ld	a5,1890(a5) # 1000 <freep>
 8a6:	a02d                	j	8d0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a8:	4618                	lw	a4,8(a2)
 8aa:	9f2d                	addw	a4,a4,a1
 8ac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	6398                	ld	a4,0(a5)
 8b2:	6310                	ld	a2,0(a4)
 8b4:	a83d                	j	8f2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b6:	ff852703          	lw	a4,-8(a0)
 8ba:	9f31                	addw	a4,a4,a2
 8bc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8be:	ff053683          	ld	a3,-16(a0)
 8c2:	a091                	j	906 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	6398                	ld	a4,0(a5)
 8c6:	00e7e463          	bltu	a5,a4,8ce <free+0x3a>
 8ca:	00e6ea63          	bltu	a3,a4,8de <free+0x4a>
{
 8ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d0:	fed7fae3          	bgeu	a5,a3,8c4 <free+0x30>
 8d4:	6398                	ld	a4,0(a5)
 8d6:	00e6e463          	bltu	a3,a4,8de <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8da:	fee7eae3          	bltu	a5,a4,8ce <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8de:	ff852583          	lw	a1,-8(a0)
 8e2:	6390                	ld	a2,0(a5)
 8e4:	02059813          	slli	a6,a1,0x20
 8e8:	01c85713          	srli	a4,a6,0x1c
 8ec:	9736                	add	a4,a4,a3
 8ee:	fae60de3          	beq	a2,a4,8a8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f6:	4790                	lw	a2,8(a5)
 8f8:	02061593          	slli	a1,a2,0x20
 8fc:	01c5d713          	srli	a4,a1,0x1c
 900:	973e                	add	a4,a4,a5
 902:	fae68ae3          	beq	a3,a4,8b6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 906:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 908:	00000717          	auipc	a4,0x0
 90c:	6ef73c23          	sd	a5,1784(a4) # 1000 <freep>
}
 910:	6422                	ld	s0,8(sp)
 912:	0141                	addi	sp,sp,16
 914:	8082                	ret

0000000000000916 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 916:	7139                	addi	sp,sp,-64
 918:	fc06                	sd	ra,56(sp)
 91a:	f822                	sd	s0,48(sp)
 91c:	f426                	sd	s1,40(sp)
 91e:	ec4e                	sd	s3,24(sp)
 920:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 922:	02051493          	slli	s1,a0,0x20
 926:	9081                	srli	s1,s1,0x20
 928:	04bd                	addi	s1,s1,15
 92a:	8091                	srli	s1,s1,0x4
 92c:	0014899b          	addiw	s3,s1,1
 930:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 932:	00000517          	auipc	a0,0x0
 936:	6ce53503          	ld	a0,1742(a0) # 1000 <freep>
 93a:	c915                	beqz	a0,96e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93e:	4798                	lw	a4,8(a5)
 940:	08977a63          	bgeu	a4,s1,9d4 <malloc+0xbe>
 944:	f04a                	sd	s2,32(sp)
 946:	e852                	sd	s4,16(sp)
 948:	e456                	sd	s5,8(sp)
 94a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94c:	8a4e                	mv	s4,s3
 94e:	0009871b          	sext.w	a4,s3
 952:	6685                	lui	a3,0x1
 954:	00d77363          	bgeu	a4,a3,95a <malloc+0x44>
 958:	6a05                	lui	s4,0x1
 95a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 962:	00000917          	auipc	s2,0x0
 966:	69e90913          	addi	s2,s2,1694 # 1000 <freep>
  if(p == (char*)-1)
 96a:	5afd                	li	s5,-1
 96c:	a081                	j	9ac <malloc+0x96>
 96e:	f04a                	sd	s2,32(sp)
 970:	e852                	sd	s4,16(sp)
 972:	e456                	sd	s5,8(sp)
 974:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 976:	00000797          	auipc	a5,0x0
 97a:	69a78793          	addi	a5,a5,1690 # 1010 <base>
 97e:	00000717          	auipc	a4,0x0
 982:	68f73123          	sd	a5,1666(a4) # 1000 <freep>
 986:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 988:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98c:	b7c1                	j	94c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 98e:	6398                	ld	a4,0(a5)
 990:	e118                	sd	a4,0(a0)
 992:	a8a9                	j	9ec <malloc+0xd6>
  hp->s.size = nu;
 994:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 998:	0541                	addi	a0,a0,16
 99a:	efbff0ef          	jal	894 <free>
  return freep;
 99e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a2:	c12d                	beqz	a0,a04 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a6:	4798                	lw	a4,8(a5)
 9a8:	02977263          	bgeu	a4,s1,9cc <malloc+0xb6>
    if(p == freep)
 9ac:	00093703          	ld	a4,0(s2)
 9b0:	853e                	mv	a0,a5
 9b2:	fef719e3          	bne	a4,a5,9a4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9b6:	8552                	mv	a0,s4
 9b8:	b1bff0ef          	jal	4d2 <sbrk>
  if(p == (char*)-1)
 9bc:	fd551ce3          	bne	a0,s5,994 <malloc+0x7e>
        return 0;
 9c0:	4501                	li	a0,0
 9c2:	7902                	ld	s2,32(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	a03d                	j	9f8 <malloc+0xe2>
 9cc:	7902                	ld	s2,32(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d4:	fae48de3          	beq	s1,a4,98e <malloc+0x78>
        p->s.size -= nunits;
 9d8:	4137073b          	subw	a4,a4,s3
 9dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9de:	02071693          	slli	a3,a4,0x20
 9e2:	01c6d713          	srli	a4,a3,0x1c
 9e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60a73a23          	sd	a0,1556(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f4:	01078513          	addi	a0,a5,16
  }
}
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	69e2                	ld	s3,24(sp)
 a00:	6121                	addi	sp,sp,64
 a02:	8082                	ret
 a04:	7902                	ld	s2,32(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
 a0c:	b7f5                	j	9f8 <malloc+0xe2>
