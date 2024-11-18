
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readline>:
  read one line and write to buffer
  return 0 if successfully read one
  return 1 if EOF
  Exit if out of boundary
 */
int readline(char* buf) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  char* p = buf;

  while(read(0, p, 1) != 0){
  10:	20050993          	addi	s3,a0,512
    if(*p == '\n') {
  14:	4929                	li	s2,10
  while(read(0, p, 1) != 0){
  16:	4605                	li	a2,1
  18:	85a6                	mv	a1,s1
  1a:	4501                	li	a0,0
  1c:	3b6000ef          	jal	3d2 <read>
  20:	c115                	beqz	a0,44 <readline+0x44>
    if(*p == '\n') {
  22:	0004c783          	lbu	a5,0(s1)
  26:	03278963          	beq	a5,s2,58 <readline+0x58>
      *p = 0;
      return 0;
    }
    p++;
  2a:	0485                	addi	s1,s1,1

    if(p >= buf + MAX_LINE_LEN) {
  2c:	ff3495e3          	bne	s1,s3,16 <readline+0x16>
      fprintf(2, "line too long\n");
  30:	00001597          	auipc	a1,0x1
  34:	95058593          	addi	a1,a1,-1712 # 980 <malloc+0xfa>
  38:	4509                	li	a0,2
  3a:	76e000ef          	jal	7a8 <fprintf>
      exit(1);
  3e:	4505                	li	a0,1
  40:	37a000ef          	jal	3ba <exit>
    }
  }

  // EOF
  *p = 0;
  return 1;
  44:	4505                	li	a0,1
      *p = 0;
  46:	00048023          	sb	zero,0(s1)
}
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6942                	ld	s2,16(sp)
  52:	69a2                	ld	s3,8(sp)
  54:	6145                	addi	sp,sp,48
  56:	8082                	ret
      return 0;
  58:	4501                	li	a0,0
  5a:	b7f5                	j	46 <readline+0x46>

000000000000005c <main>:

int main(int argc, char* argv[])
{
  5c:	ce010113          	addi	sp,sp,-800
  60:	30113c23          	sd	ra,792(sp)
  64:	30813823          	sd	s0,784(sp)
  68:	1600                	addi	s0,sp,800
  int read_end;
  int xargc;
  char line[MAX_LINE_LEN];
  char* xargv[MAXARG];

  if(argc < 2) {
  6a:	4785                	li	a5,1
  6c:	06a7d163          	bge	a5,a0,ce <main+0x72>
  70:	30913423          	sd	s1,776(sp)
  74:	84aa                	mv	s1,a0
    fprintf(2, "Usage: xargs [args ...]\n");
    exit(1);
  }

  if(argc == MAXARG - 1) {
  76:	47fd                	li	a5,31
  78:	06f50963          	beq	a0,a5,ea <main+0x8e>
  7c:	31213023          	sd	s2,768(sp)
    fprintf(2, "Exceed MAXARG %d\n", MAXARG);
    exit(1);
  }

  xargc = 0;
  while(xargc < argc - 1) {
  80:	05a1                	addi	a1,a1,8
  82:	ce040793          	addi	a5,s0,-800
  86:	0005091b          	sext.w	s2,a0
  8a:	ffe5069b          	addiw	a3,a0,-2
  8e:	02069713          	slli	a4,a3,0x20
  92:	01d75693          	srli	a3,a4,0x1d
  96:	ce840713          	addi	a4,s0,-792
  9a:	96ba                	add	a3,a3,a4
    xargv[xargc] = argv[xargc + 1];
  9c:	6198                	ld	a4,0(a1)
  9e:	e398                	sd	a4,0(a5)
  while(xargc < argc - 1) {
  a0:	05a1                	addi	a1,a1,8
  a2:	07a1                	addi	a5,a5,8
  a4:	fed79ce3          	bne	a5,a3,9c <main+0x40>
  a8:	397d                	addiw	s2,s2,-1
    xargc ++;
  }
  xargv[xargc] = NULL;
  aa:	00391793          	slli	a5,s2,0x3
  ae:	1781                	addi	a5,a5,-32
  b0:	97a2                	add	a5,a5,s0
  b2:	d007b023          	sd	zero,-768(a5)
  
  do {
    read_end = readline(line);
  b6:	de040513          	addi	a0,s0,-544
  ba:	f47ff0ef          	jal	0 <readline>

    if(read_end) break;
  be:	e551                	bnez	a0,14a <main+0xee>
    
    pid = fork();
  c0:	2f2000ef          	jal	3b2 <fork>
    if(pid == 0) {
  c4:	c129                	beqz	a0,106 <main+0xaa>
      exec(xargv[0], xargv);
      fprintf(2, "exec: %s failed", xargv[0]);
      exit(1);
    }
    else {
      wait(0);
  c6:	4501                	li	a0,0
  c8:	2fa000ef          	jal	3c2 <wait>
    }
  } while(read_end != 1);
  cc:	b7ed                	j	b6 <main+0x5a>
  ce:	30913423          	sd	s1,776(sp)
  d2:	31213023          	sd	s2,768(sp)
    fprintf(2, "Usage: xargs [args ...]\n");
  d6:	00001597          	auipc	a1,0x1
  da:	8ba58593          	addi	a1,a1,-1862 # 990 <malloc+0x10a>
  de:	4509                	li	a0,2
  e0:	6c8000ef          	jal	7a8 <fprintf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	2d4000ef          	jal	3ba <exit>
  ea:	31213023          	sd	s2,768(sp)
    fprintf(2, "Exceed MAXARG %d\n", MAXARG);
  ee:	02000613          	li	a2,32
  f2:	00001597          	auipc	a1,0x1
  f6:	8be58593          	addi	a1,a1,-1858 # 9b0 <malloc+0x12a>
  fa:	4509                	li	a0,2
  fc:	6ac000ef          	jal	7a8 <fprintf>
    exit(1);
 100:	4505                	li	a0,1
 102:	2b8000ef          	jal	3ba <exit>
      xargv[xargc] = line;
 106:	090e                	slli	s2,s2,0x3
 108:	fe090793          	addi	a5,s2,-32
 10c:	00878933          	add	s2,a5,s0
 110:	de040793          	addi	a5,s0,-544
 114:	d0f93023          	sd	a5,-768(s2)
      xargv[xargc] = NULL;
 118:	048e                	slli	s1,s1,0x3
 11a:	fe048793          	addi	a5,s1,-32
 11e:	008784b3          	add	s1,a5,s0
 122:	d004b023          	sd	zero,-768(s1)
      exec(xargv[0], xargv);
 126:	ce040593          	addi	a1,s0,-800
 12a:	ce043503          	ld	a0,-800(s0)
 12e:	2c4000ef          	jal	3f2 <exec>
      fprintf(2, "exec: %s failed", xargv[0]);
 132:	ce043603          	ld	a2,-800(s0)
 136:	00001597          	auipc	a1,0x1
 13a:	89258593          	addi	a1,a1,-1902 # 9c8 <malloc+0x142>
 13e:	4509                	li	a0,2
 140:	668000ef          	jal	7a8 <fprintf>
      exit(1);
 144:	4505                	li	a0,1
 146:	274000ef          	jal	3ba <exit>

  exit(0);
 14a:	4501                	li	a0,0
 14c:	26e000ef          	jal	3ba <exit>

0000000000000150 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  extern int main();
  main();
 158:	f05ff0ef          	jal	5c <main>
  exit(0);
 15c:	4501                	li	a0,0
 15e:	25c000ef          	jal	3ba <exit>

0000000000000162 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 168:	87aa                	mv	a5,a0
 16a:	0585                	addi	a1,a1,1
 16c:	0785                	addi	a5,a5,1
 16e:	fff5c703          	lbu	a4,-1(a1)
 172:	fee78fa3          	sb	a4,-1(a5)
 176:	fb75                	bnez	a4,16a <strcpy+0x8>
    ;
  return os;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb91                	beqz	a5,19c <strcmp+0x1e>
 18a:	0005c703          	lbu	a4,0(a1)
 18e:	00f71763          	bne	a4,a5,19c <strcmp+0x1e>
    p++, q++;
 192:	0505                	addi	a0,a0,1
 194:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbe5                	bnez	a5,18a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19c:	0005c503          	lbu	a0,0(a1)
}
 1a0:	40a7853b          	subw	a0,a5,a0
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strlen>:

uint
strlen(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cf91                	beqz	a5,1d0 <strlen+0x26>
 1b6:	0505                	addi	a0,a0,1
 1b8:	87aa                	mv	a5,a0
 1ba:	86be                	mv	a3,a5
 1bc:	0785                	addi	a5,a5,1
 1be:	fff7c703          	lbu	a4,-1(a5)
 1c2:	ff65                	bnez	a4,1ba <strlen+0x10>
 1c4:	40a6853b          	subw	a0,a3,a0
 1c8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  for(n = 0; s[n]; n++)
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strlen+0x20>

00000000000001d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1da:	ca19                	beqz	a2,1f0 <memset+0x1c>
 1dc:	87aa                	mv	a5,a0
 1de:	1602                	slli	a2,a2,0x20
 1e0:	9201                	srli	a2,a2,0x20
 1e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ea:	0785                	addi	a5,a5,1
 1ec:	fee79de3          	bne	a5,a4,1e6 <memset+0x12>
  }
  return dst;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret

00000000000001f6 <strchr>:

char*
strchr(const char *s, char c)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cb99                	beqz	a5,216 <strchr+0x20>
    if(*s == c)
 202:	00f58763          	beq	a1,a5,210 <strchr+0x1a>
  for(; *s; s++)
 206:	0505                	addi	a0,a0,1
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbfd                	bnez	a5,202 <strchr+0xc>
      return (char*)s;
  return 0;
 20e:	4501                	li	a0,0
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  return 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strchr+0x1a>

000000000000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	711d                	addi	sp,sp,-96
 21c:	ec86                	sd	ra,88(sp)
 21e:	e8a2                	sd	s0,80(sp)
 220:	e4a6                	sd	s1,72(sp)
 222:	e0ca                	sd	s2,64(sp)
 224:	fc4e                	sd	s3,56(sp)
 226:	f852                	sd	s4,48(sp)
 228:	f456                	sd	s5,40(sp)
 22a:	f05a                	sd	s6,32(sp)
 22c:	ec5e                	sd	s7,24(sp)
 22e:	1080                	addi	s0,sp,96
 230:	8baa                	mv	s7,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 238:	4aa9                	li	s5,10
 23a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
 23e:	2485                	addiw	s1,s1,1
 240:	0344d663          	bge	s1,s4,26c <gets+0x52>
    cc = read(0, &c, 1);
 244:	4605                	li	a2,1
 246:	faf40593          	addi	a1,s0,-81
 24a:	4501                	li	a0,0
 24c:	186000ef          	jal	3d2 <read>
    if(cc < 1)
 250:	00a05e63          	blez	a0,26c <gets+0x52>
    buf[i++] = c;
 254:	faf44783          	lbu	a5,-81(s0)
 258:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25c:	01578763          	beq	a5,s5,26a <gets+0x50>
 260:	0905                	addi	s2,s2,1
 262:	fd679de3          	bne	a5,s6,23c <gets+0x22>
    buf[i++] = c;
 266:	89a6                	mv	s3,s1
 268:	a011                	j	26c <gets+0x52>
 26a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26c:	99de                	add	s3,s3,s7
 26e:	00098023          	sb	zero,0(s3)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6125                	addi	sp,sp,96
 288:	8082                	ret

000000000000028a <stat>:

int
stat(const char *n, struct stat *st)
{
 28a:	1101                	addi	sp,sp,-32
 28c:	ec06                	sd	ra,24(sp)
 28e:	e822                	sd	s0,16(sp)
 290:	e04a                	sd	s2,0(sp)
 292:	1000                	addi	s0,sp,32
 294:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	4581                	li	a1,0
 298:	162000ef          	jal	3fa <open>
  if(fd < 0)
 29c:	02054263          	bltz	a0,2c0 <stat+0x36>
 2a0:	e426                	sd	s1,8(sp)
 2a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a4:	85ca                	mv	a1,s2
 2a6:	16c000ef          	jal	412 <fstat>
 2aa:	892a                	mv	s2,a0
  close(fd);
 2ac:	8526                	mv	a0,s1
 2ae:	134000ef          	jal	3e2 <close>
  return r;
 2b2:	64a2                	ld	s1,8(sp)
}
 2b4:	854a                	mv	a0,s2
 2b6:	60e2                	ld	ra,24(sp)
 2b8:	6442                	ld	s0,16(sp)
 2ba:	6902                	ld	s2,0(sp)
 2bc:	6105                	addi	sp,sp,32
 2be:	8082                	ret
    return -1;
 2c0:	597d                	li	s2,-1
 2c2:	bfcd                	j	2b4 <stat+0x2a>

00000000000002c4 <atoi>:

int
atoi(const char *s)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ca:	00054683          	lbu	a3,0(a0)
 2ce:	fd06879b          	addiw	a5,a3,-48
 2d2:	0ff7f793          	zext.b	a5,a5
 2d6:	4625                	li	a2,9
 2d8:	02f66863          	bltu	a2,a5,308 <atoi+0x44>
 2dc:	872a                	mv	a4,a0
  n = 0;
 2de:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e0:	0705                	addi	a4,a4,1
 2e2:	0025179b          	slliw	a5,a0,0x2
 2e6:	9fa9                	addw	a5,a5,a0
 2e8:	0017979b          	slliw	a5,a5,0x1
 2ec:	9fb5                	addw	a5,a5,a3
 2ee:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f2:	00074683          	lbu	a3,0(a4)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	fef671e3          	bgeu	a2,a5,2e0 <atoi+0x1c>
  return n;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  n = 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <atoi+0x3e>

000000000000030c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 312:	02b57463          	bgeu	a0,a1,33a <memmove+0x2e>
    while(n-- > 0)
 316:	00c05f63          	blez	a2,334 <memmove+0x28>
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 322:	872a                	mv	a4,a0
      *dst++ = *src++;
 324:	0585                	addi	a1,a1,1
 326:	0705                	addi	a4,a4,1
 328:	fff5c683          	lbu	a3,-1(a1)
 32c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
    dst += n;
 33a:	00c50733          	add	a4,a0,a2
    src += n;
 33e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 340:	fec05ae3          	blez	a2,334 <memmove+0x28>
 344:	fff6079b          	addiw	a5,a2,-1
 348:	1782                	slli	a5,a5,0x20
 34a:	9381                	srli	a5,a5,0x20
 34c:	fff7c793          	not	a5,a5
 350:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 352:	15fd                	addi	a1,a1,-1
 354:	177d                	addi	a4,a4,-1
 356:	0005c683          	lbu	a3,0(a1)
 35a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 35e:	fee79ae3          	bne	a5,a4,352 <memmove+0x46>
 362:	bfc9                	j	334 <memmove+0x28>

0000000000000364 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36a:	ca05                	beqz	a2,39a <memcmp+0x36>
 36c:	fff6069b          	addiw	a3,a2,-1
 370:	1682                	slli	a3,a3,0x20
 372:	9281                	srli	a3,a3,0x20
 374:	0685                	addi	a3,a3,1
 376:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 378:	00054783          	lbu	a5,0(a0)
 37c:	0005c703          	lbu	a4,0(a1)
 380:	00e79863          	bne	a5,a4,390 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 384:	0505                	addi	a0,a0,1
    p2++;
 386:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 388:	fed518e3          	bne	a0,a3,378 <memcmp+0x14>
  }
  return 0;
 38c:	4501                	li	a0,0
 38e:	a019                	j	394 <memcmp+0x30>
      return *p1 - *p2;
 390:	40e7853b          	subw	a0,a5,a4
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret
  return 0;
 39a:	4501                	li	a0,0
 39c:	bfe5                	j	394 <memcmp+0x30>

000000000000039e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a6:	f67ff0ef          	jal	30c <memmove>
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b2:	4885                	li	a7,1
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ba:	4889                	li	a7,2
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c2:	488d                	li	a7,3
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ca:	4891                	li	a7,4
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <read>:
.global read
read:
 li a7, SYS_read
 3d2:	4895                	li	a7,5
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <write>:
.global write
write:
 li a7, SYS_write
 3da:	48c1                	li	a7,16
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <close>:
.global close
close:
 li a7, SYS_close
 3e2:	48d5                	li	a7,21
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ea:	4899                	li	a7,6
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f2:	489d                	li	a7,7
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <open>:
.global open
open:
 li a7, SYS_open
 3fa:	48bd                	li	a7,15
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 402:	48c5                	li	a7,17
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40a:	48c9                	li	a7,18
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 412:	48a1                	li	a7,8
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <link>:
.global link
link:
 li a7, SYS_link
 41a:	48cd                	li	a7,19
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 422:	48d1                	li	a7,20
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42a:	48a5                	li	a7,9
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <dup>:
.global dup
dup:
 li a7, SYS_dup
 432:	48a9                	li	a7,10
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43a:	48ad                	li	a7,11
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 442:	48b1                	li	a7,12
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 44a:	48b5                	li	a7,13
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 452:	48b9                	li	a7,14
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	f6fff0ef          	jal	3da <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 478:	7139                	addi	sp,sp,-64
 47a:	fc06                	sd	ra,56(sp)
 47c:	f822                	sd	s0,48(sp)
 47e:	f426                	sd	s1,40(sp)
 480:	0080                	addi	s0,sp,64
 482:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 484:	c299                	beqz	a3,48a <printint+0x12>
 486:	0805c963          	bltz	a1,518 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48a:	2581                	sext.w	a1,a1
  neg = 0;
 48c:	4881                	li	a7,0
 48e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 492:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 494:	2601                	sext.w	a2,a2
 496:	00000517          	auipc	a0,0x0
 49a:	54a50513          	addi	a0,a0,1354 # 9e0 <digits>
 49e:	883a                	mv	a6,a4
 4a0:	2705                	addiw	a4,a4,1
 4a2:	02c5f7bb          	remuw	a5,a1,a2
 4a6:	1782                	slli	a5,a5,0x20
 4a8:	9381                	srli	a5,a5,0x20
 4aa:	97aa                	add	a5,a5,a0
 4ac:	0007c783          	lbu	a5,0(a5)
 4b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b4:	0005879b          	sext.w	a5,a1
 4b8:	02c5d5bb          	divuw	a1,a1,a2
 4bc:	0685                	addi	a3,a3,1
 4be:	fec7f0e3          	bgeu	a5,a2,49e <printint+0x26>
  if(neg)
 4c2:	00088c63          	beqz	a7,4da <printint+0x62>
    buf[i++] = '-';
 4c6:	fd070793          	addi	a5,a4,-48
 4ca:	00878733          	add	a4,a5,s0
 4ce:	02d00793          	li	a5,45
 4d2:	fef70823          	sb	a5,-16(a4)
 4d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4da:	02e05a63          	blez	a4,50e <printint+0x96>
 4de:	f04a                	sd	s2,32(sp)
 4e0:	ec4e                	sd	s3,24(sp)
 4e2:	fc040793          	addi	a5,s0,-64
 4e6:	00e78933          	add	s2,a5,a4
 4ea:	fff78993          	addi	s3,a5,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	377d                	addiw	a4,a4,-1
 4f2:	1702                	slli	a4,a4,0x20
 4f4:	9301                	srli	a4,a4,0x20
 4f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fa:	fff94583          	lbu	a1,-1(s2)
 4fe:	8526                	mv	a0,s1
 500:	f5bff0ef          	jal	45a <putc>
  while(--i >= 0)
 504:	197d                	addi	s2,s2,-1
 506:	ff391ae3          	bne	s2,s3,4fa <printint+0x82>
 50a:	7902                	ld	s2,32(sp)
 50c:	69e2                	ld	s3,24(sp)
}
 50e:	70e2                	ld	ra,56(sp)
 510:	7442                	ld	s0,48(sp)
 512:	74a2                	ld	s1,40(sp)
 514:	6121                	addi	sp,sp,64
 516:	8082                	ret
    x = -xx;
 518:	40b005bb          	negw	a1,a1
    neg = 1;
 51c:	4885                	li	a7,1
    x = -xx;
 51e:	bf85                	j	48e <printint+0x16>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	711d                	addi	sp,sp,-96
 522:	ec86                	sd	ra,88(sp)
 524:	e8a2                	sd	s0,80(sp)
 526:	e0ca                	sd	s2,64(sp)
 528:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c903          	lbu	s2,0(a1)
 52e:	26090863          	beqz	s2,79e <vprintf+0x27e>
 532:	e4a6                	sd	s1,72(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	e862                	sd	s8,16(sp)
 540:	e466                	sd	s9,8(sp)
 542:	8b2a                	mv	s6,a0
 544:	8a2e                	mv	s4,a1
 546:	8bb2                	mv	s7,a2
  state = 0;
 548:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54a:	4481                	li	s1,0
 54c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 552:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 556:	06c00c93          	li	s9,108
 55a:	a005                	j	57a <vprintf+0x5a>
        putc(fd, c0);
 55c:	85ca                	mv	a1,s2
 55e:	855a                	mv	a0,s6
 560:	efbff0ef          	jal	45a <putc>
 564:	a019                	j	56a <vprintf+0x4a>
    } else if(state == '%'){
 566:	03598263          	beq	s3,s5,58a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 56a:	2485                	addiw	s1,s1,1
 56c:	8726                	mv	a4,s1
 56e:	009a07b3          	add	a5,s4,s1
 572:	0007c903          	lbu	s2,0(a5)
 576:	20090c63          	beqz	s2,78e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 57a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 57e:	fe0994e3          	bnez	s3,566 <vprintf+0x46>
      if(c0 == '%'){
 582:	fd579de3          	bne	a5,s5,55c <vprintf+0x3c>
        state = '%';
 586:	89be                	mv	s3,a5
 588:	b7cd                	j	56a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58a:	00ea06b3          	add	a3,s4,a4
 58e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 592:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 594:	c681                	beqz	a3,59c <vprintf+0x7c>
 596:	9752                	add	a4,a4,s4
 598:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 59c:	03878f63          	beq	a5,s8,5da <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	05978963          	beq	a5,s9,5f2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a4:	07500713          	li	a4,117
 5a8:	0ee78363          	beq	a5,a4,68e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ac:	07800713          	li	a4,120
 5b0:	12e78563          	beq	a5,a4,6da <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b4:	07000713          	li	a4,112
 5b8:	14e78a63          	beq	a5,a4,70c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5bc:	07300713          	li	a4,115
 5c0:	18e78a63          	beq	a5,a4,754 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c4:	02500713          	li	a4,37
 5c8:	04e79563          	bne	a5,a4,612 <vprintf+0xf2>
        putc(fd, '%');
 5cc:	02500593          	li	a1,37
 5d0:	855a                	mv	a0,s6
 5d2:	e89ff0ef          	jal	45a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf49                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e91ff0ef          	jal	478 <printint>
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bfad                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f2:	06400793          	li	a5,100
 5f6:	02f68963          	beq	a3,a5,628 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fa:	06c00793          	li	a5,108
 5fe:	04f68263          	beq	a3,a5,642 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 602:	07500793          	li	a5,117
 606:	0af68063          	beq	a3,a5,6a6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 60a:	07800793          	li	a5,120
 60e:	0ef68263          	beq	a3,a5,6f2 <vprintf+0x1d2>
        putc(fd, '%');
 612:	02500593          	li	a1,37
 616:	855a                	mv	a0,s6
 618:	e43ff0ef          	jal	45a <putc>
        putc(fd, c0);
 61c:	85ca                	mv	a1,s2
 61e:	855a                	mv	a0,s6
 620:	e3bff0ef          	jal	45a <putc>
      state = 0;
 624:	4981                	li	s3,0
 626:	b791                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e43ff0ef          	jal	478 <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	b72d                	j	56a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 642:	06400793          	li	a5,100
 646:	02f60763          	beq	a2,a5,674 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64a:	07500793          	li	a5,117
 64e:	06f60963          	beq	a2,a5,6c0 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 652:	07800793          	li	a5,120
 656:	faf61ee3          	bne	a2,a5,612 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e11ff0ef          	jal	478 <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bde5                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	addi	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	df7ff0ef          	jal	478 <printint>
        i += 2;
 686:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	bdf9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000ba583          	lw	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	dddff0ef          	jal	478 <printint>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b5d9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dc5ff0ef          	jal	478 <printint>
        i += 1;
 6b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	b575                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4629                	li	a2,10
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	dabff0ef          	jal	478 <printint>
        i += 2;
 6d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	bd49                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6da:	008b8913          	addi	s2,s7,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000ba583          	lw	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	d91ff0ef          	jal	478 <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bdad                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d79ff0ef          	jal	478 <printint>
        i += 1;
 704:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 1;
 70a:	b585                	j	56a <vprintf+0x4a>
 70c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 70e:	008b8d13          	addi	s10,s7,8
 712:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 716:	03000593          	li	a1,48
 71a:	855a                	mv	a0,s6
 71c:	d3fff0ef          	jal	45a <putc>
  putc(fd, 'x');
 720:	07800593          	li	a1,120
 724:	855a                	mv	a0,s6
 726:	d35ff0ef          	jal	45a <putc>
 72a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	00000b97          	auipc	s7,0x0
 730:	2b4b8b93          	addi	s7,s7,692 # 9e0 <digits>
 734:	03c9d793          	srli	a5,s3,0x3c
 738:	97de                	add	a5,a5,s7
 73a:	0007c583          	lbu	a1,0(a5)
 73e:	855a                	mv	a0,s6
 740:	d1bff0ef          	jal	45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	397d                	addiw	s2,s2,-1
 748:	fe0916e3          	bnez	s2,734 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 74c:	8bea                	mv	s7,s10
      state = 0;
 74e:	4981                	li	s3,0
 750:	6d02                	ld	s10,0(sp)
 752:	bd21                	j	56a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 754:	008b8993          	addi	s3,s7,8
 758:	000bb903          	ld	s2,0(s7)
 75c:	00090f63          	beqz	s2,77a <vprintf+0x25a>
        for(; *s; s++)
 760:	00094583          	lbu	a1,0(s2)
 764:	c195                	beqz	a1,788 <vprintf+0x268>
          putc(fd, *s);
 766:	855a                	mv	a0,s6
 768:	cf3ff0ef          	jal	45a <putc>
        for(; *s; s++)
 76c:	0905                	addi	s2,s2,1
 76e:	00094583          	lbu	a1,0(s2)
 772:	f9f5                	bnez	a1,766 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 774:	8bce                	mv	s7,s3
      state = 0;
 776:	4981                	li	s3,0
 778:	bbcd                	j	56a <vprintf+0x4a>
          s = "(null)";
 77a:	00000917          	auipc	s2,0x0
 77e:	25e90913          	addi	s2,s2,606 # 9d8 <malloc+0x152>
        for(; *s; s++)
 782:	02800593          	li	a1,40
 786:	b7c5                	j	766 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 788:	8bce                	mv	s7,s3
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bbf9                	j	56a <vprintf+0x4a>
 78e:	64a6                	ld	s1,72(sp)
 790:	79e2                	ld	s3,56(sp)
 792:	7a42                	ld	s4,48(sp)
 794:	7aa2                	ld	s5,40(sp)
 796:	7b02                	ld	s6,32(sp)
 798:	6be2                	ld	s7,24(sp)
 79a:	6c42                	ld	s8,16(sp)
 79c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 79e:	60e6                	ld	ra,88(sp)
 7a0:	6446                	ld	s0,80(sp)
 7a2:	6906                	ld	s2,64(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	8622                	mv	a2,s0
 7c6:	d5bff0ef          	jal	520 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6161                	addi	sp,sp,80
 7d0:	8082                	ret

00000000000007d2 <printf>:

void
printf(const char *fmt, ...)
{
 7d2:	711d                	addi	sp,sp,-96
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	addi	s0,sp,32
 7da:	e40c                	sd	a1,8(s0)
 7dc:	e810                	sd	a2,16(s0)
 7de:	ec14                	sd	a3,24(s0)
 7e0:	f018                	sd	a4,32(s0)
 7e2:	f41c                	sd	a5,40(s0)
 7e4:	03043823          	sd	a6,48(s0)
 7e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	00840613          	addi	a2,s0,8
 7f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f4:	85aa                	mv	a1,a0
 7f6:	4505                	li	a0,1
 7f8:	d29ff0ef          	jal	520 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6125                	addi	sp,sp,96
 802:	8082                	ret

0000000000000804 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 804:	1141                	addi	sp,sp,-16
 806:	e422                	sd	s0,8(sp)
 808:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	00000797          	auipc	a5,0x0
 812:	7f27b783          	ld	a5,2034(a5) # 1000 <freep>
 816:	a02d                	j	840 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 818:	4618                	lw	a4,8(a2)
 81a:	9f2d                	addw	a4,a4,a1
 81c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	6310                	ld	a2,0(a4)
 824:	a83d                	j	862 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9f31                	addw	a4,a4,a2
 82c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053683          	ld	a3,-16(a0)
 832:	a091                	j	876 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	6398                	ld	a4,0(a5)
 836:	00e7e463          	bltu	a5,a4,83e <free+0x3a>
 83a:	00e6ea63          	bltu	a3,a4,84e <free+0x4a>
{
 83e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	fed7fae3          	bgeu	a5,a3,834 <free+0x30>
 844:	6398                	ld	a4,0(a5)
 846:	00e6e463          	bltu	a3,a4,84e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	fee7eae3          	bltu	a5,a4,83e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	slli	a6,a1,0x20
 858:	01c85713          	srli	a4,a6,0x1c
 85c:	9736                	add	a4,a4,a3
 85e:	fae60de3          	beq	a2,a4,818 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	slli	a1,a2,0x20
 86c:	01c5d713          	srli	a4,a1,0x1c
 870:	973e                	add	a4,a4,a5
 872:	fae68ae3          	beq	a3,a4,826 <free+0x22>
    p->s.ptr = bp->s.ptr;
 876:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
}
 880:	6422                	ld	s0,8(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret

0000000000000886 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 886:	7139                	addi	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	f426                	sd	s1,40(sp)
 88e:	ec4e                	sd	s3,24(sp)
 890:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	02051493          	slli	s1,a0,0x20
 896:	9081                	srli	s1,s1,0x20
 898:	04bd                	addi	s1,s1,15
 89a:	8091                	srli	s1,s1,0x4
 89c:	0014899b          	addiw	s3,s1,1
 8a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a2:	00000517          	auipc	a0,0x0
 8a6:	75e53503          	ld	a0,1886(a0) # 1000 <freep>
 8aa:	c915                	beqz	a0,8de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	08977a63          	bgeu	a4,s1,944 <malloc+0xbe>
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8bc:	8a4e                	mv	s4,s3
 8be:	0009871b          	sext.w	a4,s3
 8c2:	6685                	lui	a3,0x1
 8c4:	00d77363          	bgeu	a4,a3,8ca <malloc+0x44>
 8c8:	6a05                	lui	s4,0x1
 8ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d2:	00000917          	auipc	s2,0x0
 8d6:	72e90913          	addi	s2,s2,1838 # 1000 <freep>
  if(p == (char*)-1)
 8da:	5afd                	li	s5,-1
 8dc:	a081                	j	91c <malloc+0x96>
 8de:	f04a                	sd	s2,32(sp)
 8e0:	e852                	sd	s4,16(sp)
 8e2:	e456                	sd	s5,8(sp)
 8e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e6:	00000797          	auipc	a5,0x0
 8ea:	72a78793          	addi	a5,a5,1834 # 1010 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7c1                	j	8bc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	e118                	sd	a4,0(a0)
 902:	a8a9                	j	95c <malloc+0xd6>
  hp->s.size = nu;
 904:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 908:	0541                	addi	a0,a0,16
 90a:	efbff0ef          	jal	804 <free>
  return freep;
 90e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 912:	c12d                	beqz	a0,974 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	02977263          	bgeu	a4,s1,93c <malloc+0xb6>
    if(p == freep)
 91c:	00093703          	ld	a4,0(s2)
 920:	853e                	mv	a0,a5
 922:	fef719e3          	bne	a4,a5,914 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 926:	8552                	mv	a0,s4
 928:	b1bff0ef          	jal	442 <sbrk>
  if(p == (char*)-1)
 92c:	fd551ce3          	bne	a0,s5,904 <malloc+0x7e>
        return 0;
 930:	4501                	li	a0,0
 932:	7902                	ld	s2,32(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
 93a:	a03d                	j	968 <malloc+0xe2>
 93c:	7902                	ld	s2,32(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 944:	fae48de3          	beq	s1,a4,8fe <malloc+0x78>
        p->s.size -= nunits;
 948:	4137073b          	subw	a4,a4,s3
 94c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94e:	02071693          	slli	a3,a4,0x20
 952:	01c6d713          	srli	a4,a3,0x1c
 956:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 958:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95c:	00000717          	auipc	a4,0x0
 960:	6aa73223          	sd	a0,1700(a4) # 1000 <freep>
      return (void*)(p + 1);
 964:	01078513          	addi	a0,a5,16
  }
}
 968:	70e2                	ld	ra,56(sp)
 96a:	7442                	ld	s0,48(sp)
 96c:	74a2                	ld	s1,40(sp)
 96e:	69e2                	ld	s3,24(sp)
 970:	6121                	addi	sp,sp,64
 972:	8082                	ret
 974:	7902                	ld	s2,32(sp)
 976:	6a42                	ld	s4,16(sp)
 978:	6aa2                	ld	s5,8(sp)
 97a:	6b02                	ld	s6,0(sp)
 97c:	b7f5                	j	968 <malloc+0xe2>
