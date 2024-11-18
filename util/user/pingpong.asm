
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64

  int p1[2], p2[2];
  char buf[1] = {'a'};
   8:	06100793          	li	a5,97
   c:	fcf40423          	sb	a5,-56(s0)
  int n = 1;
  int pid;

  if(pipe(p1) < 0 || pipe(p2) < 0) {
  10:	fd840513          	addi	a0,s0,-40
  14:	404000ef          	jal	418 <pipe>
  18:	00054863          	bltz	a0,28 <main+0x28>
  1c:	fd040513          	addi	a0,s0,-48
  20:	3f8000ef          	jal	418 <pipe>
  24:	00055d63          	bgez	a0,3e <main+0x3e>
  28:	f426                	sd	s1,40(sp)
    fprintf(2, "pipe error\n");
  2a:	00001597          	auipc	a1,0x1
  2e:	9a658593          	addi	a1,a1,-1626 # 9d0 <malloc+0xfc>
  32:	4509                	li	a0,2
  34:	7c2000ef          	jal	7f6 <fprintf>
    exit(1);
  38:	4505                	li	a0,1
  3a:	3ce000ef          	jal	408 <exit>
  3e:	f426                	sd	s1,40(sp)
  }

  pid = fork();
  40:	3c0000ef          	jal	400 <fork>
  
  if(pid != 0) {    
  44:	c55d                	beqz	a0,f2 <main+0xf2>
    // parent process
    int cur_pid = getpid();
  46:	442000ef          	jal	488 <getpid>
  4a:	84aa                	mv	s1,a0
    
    close(p1[0]);
  4c:	fd842503          	lw	a0,-40(s0)
  50:	3e0000ef          	jal	430 <close>
    close(p2[1]);
  54:	fd442503          	lw	a0,-44(s0)
  58:	3d8000ef          	jal	430 <close>
    
    if(write(p1[1], buf, n) < n) {
  5c:	4605                	li	a2,1
  5e:	fc840593          	addi	a1,s0,-56
  62:	fdc42503          	lw	a0,-36(s0)
  66:	3c2000ef          	jal	428 <write>
  6a:	02a05e63          	blez	a0,a6 <main+0xa6>
      close(p1[1]);
      close(p2[0]);
      exit(1);
    }

    if(read(p2[0], buf, n) < n) {
  6e:	4605                	li	a2,1
  70:	fc840593          	addi	a1,s0,-56
  74:	fd042503          	lw	a0,-48(s0)
  78:	3a8000ef          	jal	420 <read>
  7c:	04a05863          	blez	a0,cc <main+0xcc>
      close(p1[1]);
      close(p2[0]);
      exit(1);
    }
    
    fprintf(1, "%d: received pong\n", cur_pid);
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	98658593          	addi	a1,a1,-1658 # a08 <malloc+0x134>
  8a:	4505                	li	a0,1
  8c:	76a000ef          	jal	7f6 <fprintf>

    close(p1[1]);
  90:	fdc42503          	lw	a0,-36(s0)
  94:	39c000ef          	jal	430 <close>
    close(p2[0]);
  98:	fd042503          	lw	a0,-48(s0)
  9c:	394000ef          	jal	430 <close>
    
    exit(0);
  a0:	4501                	li	a0,0
  a2:	366000ef          	jal	408 <exit>
      fprintf(2, "%d: write error\n", cur_pid);
  a6:	8626                	mv	a2,s1
  a8:	00001597          	auipc	a1,0x1
  ac:	93858593          	addi	a1,a1,-1736 # 9e0 <malloc+0x10c>
  b0:	4509                	li	a0,2
  b2:	744000ef          	jal	7f6 <fprintf>
      close(p1[1]);
  b6:	fdc42503          	lw	a0,-36(s0)
  ba:	376000ef          	jal	430 <close>
      close(p2[0]);
  be:	fd042503          	lw	a0,-48(s0)
  c2:	36e000ef          	jal	430 <close>
      exit(1);
  c6:	4505                	li	a0,1
  c8:	340000ef          	jal	408 <exit>
      fprintf(2, "%d: read error\n", cur_pid);
  cc:	8626                	mv	a2,s1
  ce:	00001597          	auipc	a1,0x1
  d2:	92a58593          	addi	a1,a1,-1750 # 9f8 <malloc+0x124>
  d6:	4509                	li	a0,2
  d8:	71e000ef          	jal	7f6 <fprintf>
      close(p1[1]);
  dc:	fdc42503          	lw	a0,-36(s0)
  e0:	350000ef          	jal	430 <close>
      close(p2[0]);
  e4:	fd042503          	lw	a0,-48(s0)
  e8:	348000ef          	jal	430 <close>
      exit(1);
  ec:	4505                	li	a0,1
  ee:	31a000ef          	jal	408 <exit>
  }
  else {
    // child process
    int cur_pid = getpid();
  f2:	396000ef          	jal	488 <getpid>
  f6:	84aa                	mv	s1,a0
    
    close(p2[0]);
  f8:	fd042503          	lw	a0,-48(s0)
  fc:	334000ef          	jal	430 <close>
    close(p1[1]);
 100:	fdc42503          	lw	a0,-36(s0)
 104:	32c000ef          	jal	430 <close>
    
    if(read(p1[0], buf, n) < n) {
 108:	4605                	li	a2,1
 10a:	fc840593          	addi	a1,s0,-56
 10e:	fd842503          	lw	a0,-40(s0)
 112:	30e000ef          	jal	420 <read>
 116:	02a05e63          	blez	a0,152 <main+0x152>
      close(p1[0]);
      close(p2[1]);
      exit(1);
    }
    
    fprintf(1, "%d: received ping\n", cur_pid);
 11a:	8626                	mv	a2,s1
 11c:	00001597          	auipc	a1,0x1
 120:	90458593          	addi	a1,a1,-1788 # a20 <malloc+0x14c>
 124:	4505                	li	a0,1
 126:	6d0000ef          	jal	7f6 <fprintf>

    if(write(p2[1], buf, n) < n) {
 12a:	4605                	li	a2,1
 12c:	fc840593          	addi	a1,s0,-56
 130:	fd442503          	lw	a0,-44(s0)
 134:	2f4000ef          	jal	428 <write>
 138:	04a05063          	blez	a0,178 <main+0x178>
      close(p1[0]);
      close(p2[1]);
      exit(1);
    }

    close(p1[0]);
 13c:	fd842503          	lw	a0,-40(s0)
 140:	2f0000ef          	jal	430 <close>
    close(p2[1]);
 144:	fd442503          	lw	a0,-44(s0)
 148:	2e8000ef          	jal	430 <close>
    
    exit(0);
 14c:	4501                	li	a0,0
 14e:	2ba000ef          	jal	408 <exit>
      fprintf(2, "%d: read error\n", cur_pid);
 152:	8626                	mv	a2,s1
 154:	00001597          	auipc	a1,0x1
 158:	8a458593          	addi	a1,a1,-1884 # 9f8 <malloc+0x124>
 15c:	4509                	li	a0,2
 15e:	698000ef          	jal	7f6 <fprintf>
      close(p1[0]);
 162:	fd842503          	lw	a0,-40(s0)
 166:	2ca000ef          	jal	430 <close>
      close(p2[1]);
 16a:	fd442503          	lw	a0,-44(s0)
 16e:	2c2000ef          	jal	430 <close>
      exit(1);
 172:	4505                	li	a0,1
 174:	294000ef          	jal	408 <exit>
      fprintf(2, "%d: write error\n", cur_pid);
 178:	8626                	mv	a2,s1
 17a:	00001597          	auipc	a1,0x1
 17e:	86658593          	addi	a1,a1,-1946 # 9e0 <malloc+0x10c>
 182:	4509                	li	a0,2
 184:	672000ef          	jal	7f6 <fprintf>
      close(p1[0]);
 188:	fd842503          	lw	a0,-40(s0)
 18c:	2a4000ef          	jal	430 <close>
      close(p2[1]);
 190:	fd442503          	lw	a0,-44(s0)
 194:	29c000ef          	jal	430 <close>
      exit(1);
 198:	4505                	li	a0,1
 19a:	26e000ef          	jal	408 <exit>

000000000000019e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1a6:	e5bff0ef          	jal	0 <main>
  exit(0);
 1aa:	4501                	li	a0,0
 1ac:	25c000ef          	jal	408 <exit>

00000000000001b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b6:	87aa                	mv	a5,a0
 1b8:	0585                	addi	a1,a1,1
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff5c703          	lbu	a4,-1(a1)
 1c0:	fee78fa3          	sb	a4,-1(a5)
 1c4:	fb75                	bnez	a4,1b8 <strcpy+0x8>
    ;
  return os;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x1e>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x1e>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <strlen>:

uint
strlen(const char *s)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	cf91                	beqz	a5,21e <strlen+0x26>
 204:	0505                	addi	a0,a0,1
 206:	87aa                	mv	a5,a0
 208:	86be                	mv	a3,a5
 20a:	0785                	addi	a5,a5,1
 20c:	fff7c703          	lbu	a4,-1(a5)
 210:	ff65                	bnez	a4,208 <strlen+0x10>
 212:	40a6853b          	subw	a0,a3,a0
 216:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  for(n = 0; s[n]; n++)
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <strlen+0x20>

0000000000000222 <memset>:

void*
memset(void *dst, int c, uint n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 228:	ca19                	beqz	a2,23e <memset+0x1c>
 22a:	87aa                	mv	a5,a0
 22c:	1602                	slli	a2,a2,0x20
 22e:	9201                	srli	a2,a2,0x20
 230:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 234:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 238:	0785                	addi	a5,a5,1
 23a:	fee79de3          	bne	a5,a4,234 <memset+0x12>
  }
  return dst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strchr>:

char*
strchr(const char *s, char c)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  for(; *s; s++)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	cb99                	beqz	a5,264 <strchr+0x20>
    if(*s == c)
 250:	00f58763          	beq	a1,a5,25e <strchr+0x1a>
  for(; *s; s++)
 254:	0505                	addi	a0,a0,1
 256:	00054783          	lbu	a5,0(a0)
 25a:	fbfd                	bnez	a5,250 <strchr+0xc>
      return (char*)s;
  return 0;
 25c:	4501                	li	a0,0
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <strchr+0x1a>

0000000000000268 <gets>:

char*
gets(char *buf, int max)
{
 268:	711d                	addi	sp,sp,-96
 26a:	ec86                	sd	ra,88(sp)
 26c:	e8a2                	sd	s0,80(sp)
 26e:	e4a6                	sd	s1,72(sp)
 270:	e0ca                	sd	s2,64(sp)
 272:	fc4e                	sd	s3,56(sp)
 274:	f852                	sd	s4,48(sp)
 276:	f456                	sd	s5,40(sp)
 278:	f05a                	sd	s6,32(sp)
 27a:	ec5e                	sd	s7,24(sp)
 27c:	1080                	addi	s0,sp,96
 27e:	8baa                	mv	s7,a0
 280:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 282:	892a                	mv	s2,a0
 284:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 286:	4aa9                	li	s5,10
 288:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 28a:	89a6                	mv	s3,s1
 28c:	2485                	addiw	s1,s1,1
 28e:	0344d663          	bge	s1,s4,2ba <gets+0x52>
    cc = read(0, &c, 1);
 292:	4605                	li	a2,1
 294:	faf40593          	addi	a1,s0,-81
 298:	4501                	li	a0,0
 29a:	186000ef          	jal	420 <read>
    if(cc < 1)
 29e:	00a05e63          	blez	a0,2ba <gets+0x52>
    buf[i++] = c;
 2a2:	faf44783          	lbu	a5,-81(s0)
 2a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2aa:	01578763          	beq	a5,s5,2b8 <gets+0x50>
 2ae:	0905                	addi	s2,s2,1
 2b0:	fd679de3          	bne	a5,s6,28a <gets+0x22>
    buf[i++] = c;
 2b4:	89a6                	mv	s3,s1
 2b6:	a011                	j	2ba <gets+0x52>
 2b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ba:	99de                	add	s3,s3,s7
 2bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c0:	855e                	mv	a0,s7
 2c2:	60e6                	ld	ra,88(sp)
 2c4:	6446                	ld	s0,80(sp)
 2c6:	64a6                	ld	s1,72(sp)
 2c8:	6906                	ld	s2,64(sp)
 2ca:	79e2                	ld	s3,56(sp)
 2cc:	7a42                	ld	s4,48(sp)
 2ce:	7aa2                	ld	s5,40(sp)
 2d0:	7b02                	ld	s6,32(sp)
 2d2:	6be2                	ld	s7,24(sp)
 2d4:	6125                	addi	sp,sp,96
 2d6:	8082                	ret

00000000000002d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d8:	1101                	addi	sp,sp,-32
 2da:	ec06                	sd	ra,24(sp)
 2dc:	e822                	sd	s0,16(sp)
 2de:	e04a                	sd	s2,0(sp)
 2e0:	1000                	addi	s0,sp,32
 2e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e4:	4581                	li	a1,0
 2e6:	162000ef          	jal	448 <open>
  if(fd < 0)
 2ea:	02054263          	bltz	a0,30e <stat+0x36>
 2ee:	e426                	sd	s1,8(sp)
 2f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f2:	85ca                	mv	a1,s2
 2f4:	16c000ef          	jal	460 <fstat>
 2f8:	892a                	mv	s2,a0
  close(fd);
 2fa:	8526                	mv	a0,s1
 2fc:	134000ef          	jal	430 <close>
  return r;
 300:	64a2                	ld	s1,8(sp)
}
 302:	854a                	mv	a0,s2
 304:	60e2                	ld	ra,24(sp)
 306:	6442                	ld	s0,16(sp)
 308:	6902                	ld	s2,0(sp)
 30a:	6105                	addi	sp,sp,32
 30c:	8082                	ret
    return -1;
 30e:	597d                	li	s2,-1
 310:	bfcd                	j	302 <stat+0x2a>

0000000000000312 <atoi>:

int
atoi(const char *s)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 318:	00054683          	lbu	a3,0(a0)
 31c:	fd06879b          	addiw	a5,a3,-48
 320:	0ff7f793          	zext.b	a5,a5
 324:	4625                	li	a2,9
 326:	02f66863          	bltu	a2,a5,356 <atoi+0x44>
 32a:	872a                	mv	a4,a0
  n = 0;
 32c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 32e:	0705                	addi	a4,a4,1
 330:	0025179b          	slliw	a5,a0,0x2
 334:	9fa9                	addw	a5,a5,a0
 336:	0017979b          	slliw	a5,a5,0x1
 33a:	9fb5                	addw	a5,a5,a3
 33c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 340:	00074683          	lbu	a3,0(a4)
 344:	fd06879b          	addiw	a5,a3,-48
 348:	0ff7f793          	zext.b	a5,a5
 34c:	fef671e3          	bgeu	a2,a5,32e <atoi+0x1c>
  return n;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  n = 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <atoi+0x3e>

000000000000035a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 360:	02b57463          	bgeu	a0,a1,388 <memmove+0x2e>
    while(n-- > 0)
 364:	00c05f63          	blez	a2,382 <memmove+0x28>
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fef71ae3          	bne	a4,a5,372 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
    dst += n;
 388:	00c50733          	add	a4,a0,a2
    src += n;
 38c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38e:	fec05ae3          	blez	a2,382 <memmove+0x28>
 392:	fff6079b          	addiw	a5,a2,-1
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	fff7c793          	not	a5,a5
 39e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a0:	15fd                	addi	a1,a1,-1
 3a2:	177d                	addi	a4,a4,-1
 3a4:	0005c683          	lbu	a3,0(a1)
 3a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ac:	fee79ae3          	bne	a5,a4,3a0 <memmove+0x46>
 3b0:	bfc9                	j	382 <memmove+0x28>

00000000000003b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca05                	beqz	a2,3e8 <memcmp+0x36>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x14>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x30>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <memcmp+0x30>

00000000000003ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f4:	f67ff0ef          	jal	35a <memmove>
}
 3f8:	60a2                	ld	ra,8(sp)
 3fa:	6402                	ld	s0,0(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret

0000000000000400 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 400:	4885                	li	a7,1
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <exit>:
.global exit
exit:
 li a7, SYS_exit
 408:	4889                	li	a7,2
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <wait>:
.global wait
wait:
 li a7, SYS_wait
 410:	488d                	li	a7,3
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 418:	4891                	li	a7,4
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <read>:
.global read
read:
 li a7, SYS_read
 420:	4895                	li	a7,5
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <write>:
.global write
write:
 li a7, SYS_write
 428:	48c1                	li	a7,16
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <close>:
.global close
close:
 li a7, SYS_close
 430:	48d5                	li	a7,21
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <kill>:
.global kill
kill:
 li a7, SYS_kill
 438:	4899                	li	a7,6
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <exec>:
.global exec
exec:
 li a7, SYS_exec
 440:	489d                	li	a7,7
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <open>:
.global open
open:
 li a7, SYS_open
 448:	48bd                	li	a7,15
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 450:	48c5                	li	a7,17
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 458:	48c9                	li	a7,18
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 460:	48a1                	li	a7,8
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <link>:
.global link
link:
 li a7, SYS_link
 468:	48cd                	li	a7,19
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 470:	48d1                	li	a7,20
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 478:	48a5                	li	a7,9
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <dup>:
.global dup
dup:
 li a7, SYS_dup
 480:	48a9                	li	a7,10
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 488:	48ad                	li	a7,11
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 490:	48b1                	li	a7,12
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 498:	48b5                	li	a7,13
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a0:	48b9                	li	a7,14
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a8:	1101                	addi	sp,sp,-32
 4aa:	ec06                	sd	ra,24(sp)
 4ac:	e822                	sd	s0,16(sp)
 4ae:	1000                	addi	s0,sp,32
 4b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b4:	4605                	li	a2,1
 4b6:	fef40593          	addi	a1,s0,-17
 4ba:	f6fff0ef          	jal	428 <write>
}
 4be:	60e2                	ld	ra,24(sp)
 4c0:	6442                	ld	s0,16(sp)
 4c2:	6105                	addi	sp,sp,32
 4c4:	8082                	ret

00000000000004c6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c6:	7139                	addi	sp,sp,-64
 4c8:	fc06                	sd	ra,56(sp)
 4ca:	f822                	sd	s0,48(sp)
 4cc:	f426                	sd	s1,40(sp)
 4ce:	0080                	addi	s0,sp,64
 4d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d2:	c299                	beqz	a3,4d8 <printint+0x12>
 4d4:	0805c963          	bltz	a1,566 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d8:	2581                	sext.w	a1,a1
  neg = 0;
 4da:	4881                	li	a7,0
 4dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e2:	2601                	sext.w	a2,a2
 4e4:	00000517          	auipc	a0,0x0
 4e8:	55c50513          	addi	a0,a0,1372 # a40 <digits>
 4ec:	883a                	mv	a6,a4
 4ee:	2705                	addiw	a4,a4,1
 4f0:	02c5f7bb          	remuw	a5,a1,a2
 4f4:	1782                	slli	a5,a5,0x20
 4f6:	9381                	srli	a5,a5,0x20
 4f8:	97aa                	add	a5,a5,a0
 4fa:	0007c783          	lbu	a5,0(a5)
 4fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 502:	0005879b          	sext.w	a5,a1
 506:	02c5d5bb          	divuw	a1,a1,a2
 50a:	0685                	addi	a3,a3,1
 50c:	fec7f0e3          	bgeu	a5,a2,4ec <printint+0x26>
  if(neg)
 510:	00088c63          	beqz	a7,528 <printint+0x62>
    buf[i++] = '-';
 514:	fd070793          	addi	a5,a4,-48
 518:	00878733          	add	a4,a5,s0
 51c:	02d00793          	li	a5,45
 520:	fef70823          	sb	a5,-16(a4)
 524:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 528:	02e05a63          	blez	a4,55c <printint+0x96>
 52c:	f04a                	sd	s2,32(sp)
 52e:	ec4e                	sd	s3,24(sp)
 530:	fc040793          	addi	a5,s0,-64
 534:	00e78933          	add	s2,a5,a4
 538:	fff78993          	addi	s3,a5,-1
 53c:	99ba                	add	s3,s3,a4
 53e:	377d                	addiw	a4,a4,-1
 540:	1702                	slli	a4,a4,0x20
 542:	9301                	srli	a4,a4,0x20
 544:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 548:	fff94583          	lbu	a1,-1(s2)
 54c:	8526                	mv	a0,s1
 54e:	f5bff0ef          	jal	4a8 <putc>
  while(--i >= 0)
 552:	197d                	addi	s2,s2,-1
 554:	ff391ae3          	bne	s2,s3,548 <printint+0x82>
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	6121                	addi	sp,sp,64
 564:	8082                	ret
    x = -xx;
 566:	40b005bb          	negw	a1,a1
    neg = 1;
 56a:	4885                	li	a7,1
    x = -xx;
 56c:	bf85                	j	4dc <printint+0x16>

000000000000056e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56e:	711d                	addi	sp,sp,-96
 570:	ec86                	sd	ra,88(sp)
 572:	e8a2                	sd	s0,80(sp)
 574:	e0ca                	sd	s2,64(sp)
 576:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 578:	0005c903          	lbu	s2,0(a1)
 57c:	26090863          	beqz	s2,7ec <vprintf+0x27e>
 580:	e4a6                	sd	s1,72(sp)
 582:	fc4e                	sd	s3,56(sp)
 584:	f852                	sd	s4,48(sp)
 586:	f456                	sd	s5,40(sp)
 588:	f05a                	sd	s6,32(sp)
 58a:	ec5e                	sd	s7,24(sp)
 58c:	e862                	sd	s8,16(sp)
 58e:	e466                	sd	s9,8(sp)
 590:	8b2a                	mv	s6,a0
 592:	8a2e                	mv	s4,a1
 594:	8bb2                	mv	s7,a2
  state = 0;
 596:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 598:	4481                	li	s1,0
 59a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 59c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a4:	06c00c93          	li	s9,108
 5a8:	a005                	j	5c8 <vprintf+0x5a>
        putc(fd, c0);
 5aa:	85ca                	mv	a1,s2
 5ac:	855a                	mv	a0,s6
 5ae:	efbff0ef          	jal	4a8 <putc>
 5b2:	a019                	j	5b8 <vprintf+0x4a>
    } else if(state == '%'){
 5b4:	03598263          	beq	s3,s5,5d8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5b8:	2485                	addiw	s1,s1,1
 5ba:	8726                	mv	a4,s1
 5bc:	009a07b3          	add	a5,s4,s1
 5c0:	0007c903          	lbu	s2,0(a5)
 5c4:	20090c63          	beqz	s2,7dc <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5c8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5cc:	fe0994e3          	bnez	s3,5b4 <vprintf+0x46>
      if(c0 == '%'){
 5d0:	fd579de3          	bne	a5,s5,5aa <vprintf+0x3c>
        state = '%';
 5d4:	89be                	mv	s3,a5
 5d6:	b7cd                	j	5b8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5d8:	00ea06b3          	add	a3,s4,a4
 5dc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5e2:	c681                	beqz	a3,5ea <vprintf+0x7c>
 5e4:	9752                	add	a4,a4,s4
 5e6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5ea:	03878f63          	beq	a5,s8,628 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5ee:	05978963          	beq	a5,s9,640 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5f2:	07500713          	li	a4,117
 5f6:	0ee78363          	beq	a5,a4,6dc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5fa:	07800713          	li	a4,120
 5fe:	12e78563          	beq	a5,a4,728 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 602:	07000713          	li	a4,112
 606:	14e78a63          	beq	a5,a4,75a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 60a:	07300713          	li	a4,115
 60e:	18e78a63          	beq	a5,a4,7a2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 612:	02500713          	li	a4,37
 616:	04e79563          	bne	a5,a4,660 <vprintf+0xf2>
        putc(fd, '%');
 61a:	02500593          	li	a1,37
 61e:	855a                	mv	a0,s6
 620:	e89ff0ef          	jal	4a8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 624:	4981                	li	s3,0
 626:	bf49                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e91ff0ef          	jal	4c6 <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bfad                	j	5b8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 640:	06400793          	li	a5,100
 644:	02f68963          	beq	a3,a5,676 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 648:	06c00793          	li	a5,108
 64c:	04f68263          	beq	a3,a5,690 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 650:	07500793          	li	a5,117
 654:	0af68063          	beq	a3,a5,6f4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 658:	07800793          	li	a5,120
 65c:	0ef68263          	beq	a3,a5,740 <vprintf+0x1d2>
        putc(fd, '%');
 660:	02500593          	li	a1,37
 664:	855a                	mv	a0,s6
 666:	e43ff0ef          	jal	4a8 <putc>
        putc(fd, c0);
 66a:	85ca                	mv	a1,s2
 66c:	855a                	mv	a0,s6
 66e:	e3bff0ef          	jal	4a8 <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	b791                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8913          	addi	s2,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	e43ff0ef          	jal	4c6 <printint>
        i += 1;
 688:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b72d                	j	5b8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 690:	06400793          	li	a5,100
 694:	02f60763          	beq	a2,a5,6c2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 698:	07500793          	li	a5,117
 69c:	06f60963          	beq	a2,a5,70e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6a0:	07800793          	li	a5,120
 6a4:	faf61ee3          	bne	a2,a5,660 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	e11ff0ef          	jal	4c6 <printint>
        i += 2;
 6ba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 2;
 6c0:	bde5                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4685                	li	a3,1
 6c8:	4629                	li	a2,10
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	df7ff0ef          	jal	4c6 <printint>
        i += 2;
 6d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bdf9                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	dddff0ef          	jal	4c6 <printint>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b5d9                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4629                	li	a2,10
 6fc:	000ba583          	lw	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	dc5ff0ef          	jal	4c6 <printint>
        i += 1;
 706:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b575                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	008b8913          	addi	s2,s7,8
 712:	4681                	li	a3,0
 714:	4629                	li	a2,10
 716:	000ba583          	lw	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	dabff0ef          	jal	4c6 <printint>
        i += 2;
 720:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
        i += 2;
 726:	bd49                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000ba583          	lw	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d91ff0ef          	jal	4c6 <printint>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bdad                	j	5b8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	008b8913          	addi	s2,s7,8
 744:	4681                	li	a3,0
 746:	4641                	li	a2,16
 748:	000ba583          	lw	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d79ff0ef          	jal	4c6 <printint>
        i += 1;
 752:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
        i += 1;
 758:	b585                	j	5b8 <vprintf+0x4a>
 75a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 75c:	008b8d13          	addi	s10,s7,8
 760:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	855a                	mv	a0,s6
 76a:	d3fff0ef          	jal	4a8 <putc>
  putc(fd, 'x');
 76e:	07800593          	li	a1,120
 772:	855a                	mv	a0,s6
 774:	d35ff0ef          	jal	4a8 <putc>
 778:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77a:	00000b97          	auipc	s7,0x0
 77e:	2c6b8b93          	addi	s7,s7,710 # a40 <digits>
 782:	03c9d793          	srli	a5,s3,0x3c
 786:	97de                	add	a5,a5,s7
 788:	0007c583          	lbu	a1,0(a5)
 78c:	855a                	mv	a0,s6
 78e:	d1bff0ef          	jal	4a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 792:	0992                	slli	s3,s3,0x4
 794:	397d                	addiw	s2,s2,-1
 796:	fe0916e3          	bnez	s2,782 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 79a:	8bea                	mv	s7,s10
      state = 0;
 79c:	4981                	li	s3,0
 79e:	6d02                	ld	s10,0(sp)
 7a0:	bd21                	j	5b8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7a2:	008b8993          	addi	s3,s7,8
 7a6:	000bb903          	ld	s2,0(s7)
 7aa:	00090f63          	beqz	s2,7c8 <vprintf+0x25a>
        for(; *s; s++)
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	c195                	beqz	a1,7d6 <vprintf+0x268>
          putc(fd, *s);
 7b4:	855a                	mv	a0,s6
 7b6:	cf3ff0ef          	jal	4a8 <putc>
        for(; *s; s++)
 7ba:	0905                	addi	s2,s2,1
 7bc:	00094583          	lbu	a1,0(s2)
 7c0:	f9f5                	bnez	a1,7b4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7c2:	8bce                	mv	s7,s3
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbcd                	j	5b8 <vprintf+0x4a>
          s = "(null)";
 7c8:	00000917          	auipc	s2,0x0
 7cc:	27090913          	addi	s2,s2,624 # a38 <malloc+0x164>
        for(; *s; s++)
 7d0:	02800593          	li	a1,40
 7d4:	b7c5                	j	7b4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	bbf9                	j	5b8 <vprintf+0x4a>
 7dc:	64a6                	ld	s1,72(sp)
 7de:	79e2                	ld	s3,56(sp)
 7e0:	7a42                	ld	s4,48(sp)
 7e2:	7aa2                	ld	s5,40(sp)
 7e4:	7b02                	ld	s6,32(sp)
 7e6:	6be2                	ld	s7,24(sp)
 7e8:	6c42                	ld	s8,16(sp)
 7ea:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ec:	60e6                	ld	ra,88(sp)
 7ee:	6446                	ld	s0,80(sp)
 7f0:	6906                	ld	s2,64(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret

00000000000007f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f6:	715d                	addi	sp,sp,-80
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e010                	sd	a2,0(s0)
 800:	e414                	sd	a3,8(s0)
 802:	e818                	sd	a4,16(s0)
 804:	ec1c                	sd	a5,24(s0)
 806:	03043023          	sd	a6,32(s0)
 80a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 812:	8622                	mv	a2,s0
 814:	d5bff0ef          	jal	56e <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6161                	addi	sp,sp,80
 81e:	8082                	ret

0000000000000820 <printf>:

void
printf(const char *fmt, ...)
{
 820:	711d                	addi	sp,sp,-96
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e40c                	sd	a1,8(s0)
 82a:	e810                	sd	a2,16(s0)
 82c:	ec14                	sd	a3,24(s0)
 82e:	f018                	sd	a4,32(s0)
 830:	f41c                	sd	a5,40(s0)
 832:	03043823          	sd	a6,48(s0)
 836:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83a:	00840613          	addi	a2,s0,8
 83e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 842:	85aa                	mv	a1,a0
 844:	4505                	li	a0,1
 846:	d29ff0ef          	jal	56e <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret

0000000000000852 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 852:	1141                	addi	sp,sp,-16
 854:	e422                	sd	s0,8(sp)
 856:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 858:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	00000797          	auipc	a5,0x0
 860:	7a47b783          	ld	a5,1956(a5) # 1000 <freep>
 864:	a02d                	j	88e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	a83d                	j	8b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	a091                	j	8c4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	6398                	ld	a4,0(a5)
 884:	00e7e463          	bltu	a5,a4,88c <free+0x3a>
 888:	00e6ea63          	bltu	a3,a4,89c <free+0x4a>
{
 88c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	fed7fae3          	bgeu	a5,a3,882 <free+0x30>
 892:	6398                	ld	a4,0(a5)
 894:	00e6e463          	bltu	a3,a4,89c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	fee7eae3          	bltu	a5,a4,88c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 89c:	ff852583          	lw	a1,-8(a0)
 8a0:	6390                	ld	a2,0(a5)
 8a2:	02059813          	slli	a6,a1,0x20
 8a6:	01c85713          	srli	a4,a6,0x1c
 8aa:	9736                	add	a4,a4,a3
 8ac:	fae60de3          	beq	a2,a4,866 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b4:	4790                	lw	a2,8(a5)
 8b6:	02061593          	slli	a1,a2,0x20
 8ba:	01c5d713          	srli	a4,a1,0x1c
 8be:	973e                	add	a4,a4,a5
 8c0:	fae68ae3          	beq	a3,a4,874 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72f73d23          	sd	a5,1850(a4) # 1000 <freep>
}
 8ce:	6422                	ld	s0,8(sp)
 8d0:	0141                	addi	sp,sp,16
 8d2:	8082                	ret

00000000000008d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d4:	7139                	addi	sp,sp,-64
 8d6:	fc06                	sd	ra,56(sp)
 8d8:	f822                	sd	s0,48(sp)
 8da:	f426                	sd	s1,40(sp)
 8dc:	ec4e                	sd	s3,24(sp)
 8de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e0:	02051493          	slli	s1,a0,0x20
 8e4:	9081                	srli	s1,s1,0x20
 8e6:	04bd                	addi	s1,s1,15
 8e8:	8091                	srli	s1,s1,0x4
 8ea:	0014899b          	addiw	s3,s1,1
 8ee:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f0:	00000517          	auipc	a0,0x0
 8f4:	71053503          	ld	a0,1808(a0) # 1000 <freep>
 8f8:	c915                	beqz	a0,92c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	08977a63          	bgeu	a4,s1,992 <malloc+0xbe>
 902:	f04a                	sd	s2,32(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 90a:	8a4e                	mv	s4,s3
 90c:	0009871b          	sext.w	a4,s3
 910:	6685                	lui	a3,0x1
 912:	00d77363          	bgeu	a4,a3,918 <malloc+0x44>
 916:	6a05                	lui	s4,0x1
 918:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 91c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 920:	00000917          	auipc	s2,0x0
 924:	6e090913          	addi	s2,s2,1760 # 1000 <freep>
  if(p == (char*)-1)
 928:	5afd                	li	s5,-1
 92a:	a081                	j	96a <malloc+0x96>
 92c:	f04a                	sd	s2,32(sp)
 92e:	e852                	sd	s4,16(sp)
 930:	e456                	sd	s5,8(sp)
 932:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 934:	00000797          	auipc	a5,0x0
 938:	6dc78793          	addi	a5,a5,1756 # 1010 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	6cf73223          	sd	a5,1732(a4) # 1000 <freep>
 944:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94a:	b7c1                	j	90a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	e118                	sd	a4,0(a0)
 950:	a8a9                	j	9aa <malloc+0xd6>
  hp->s.size = nu;
 952:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 956:	0541                	addi	a0,a0,16
 958:	efbff0ef          	jal	852 <free>
  return freep;
 95c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 960:	c12d                	beqz	a0,9c2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 962:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 964:	4798                	lw	a4,8(a5)
 966:	02977263          	bgeu	a4,s1,98a <malloc+0xb6>
    if(p == freep)
 96a:	00093703          	ld	a4,0(s2)
 96e:	853e                	mv	a0,a5
 970:	fef719e3          	bne	a4,a5,962 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 974:	8552                	mv	a0,s4
 976:	b1bff0ef          	jal	490 <sbrk>
  if(p == (char*)-1)
 97a:	fd551ce3          	bne	a0,s5,952 <malloc+0x7e>
        return 0;
 97e:	4501                	li	a0,0
 980:	7902                	ld	s2,32(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
 988:	a03d                	j	9b6 <malloc+0xe2>
 98a:	7902                	ld	s2,32(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 992:	fae48de3          	beq	s1,a4,94c <malloc+0x78>
        p->s.size -= nunits;
 996:	4137073b          	subw	a4,a4,s3
 99a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99c:	02071693          	slli	a3,a4,0x20
 9a0:	01c6d713          	srli	a4,a3,0x1c
 9a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9aa:	00000717          	auipc	a4,0x0
 9ae:	64a73b23          	sd	a0,1622(a4) # 1000 <freep>
      return (void*)(p + 1);
 9b2:	01078513          	addi	a0,a5,16
  }
}
 9b6:	70e2                	ld	ra,56(sp)
 9b8:	7442                	ld	s0,48(sp)
 9ba:	74a2                	ld	s1,40(sp)
 9bc:	69e2                	ld	s3,24(sp)
 9be:	6121                	addi	sp,sp,64
 9c0:	8082                	ret
 9c2:	7902                	ld	s2,32(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	b7f5                	j	9b6 <malloc+0xe2>
