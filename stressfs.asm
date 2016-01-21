
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 5f 09 00 	movl   $0x95f,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 58 05 00 00       	call   598 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 1a 02 00 00       	call   276 <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 11                	jmp    7a <main+0x7a>
    if(fork() > 0)
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7f 14                	jg     86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  72:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  79:	01 
  7a:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  81:	03 
  82:	7e e5                	jle    69 <main+0x69>
  84:	eb 01                	jmp    87 <main+0x87>
    if(fork() > 0)
      break;
  86:	90                   	nop

  printf(1, "write %d\n", i);
  87:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 72 09 00 	movl   $0x972,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 f2 04 00 00       	call   598 <printf>

  path[8] += i;
  a6:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ad:	00 
  ae:	89 c2                	mov    %eax,%edx
  b0:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b7:	8d 04 02             	lea    (%edx,%eax,1),%eax
  ba:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c8:	00 
  c9:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 84 03 00 00       	call   45c <open>
  d8:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  df:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e6:	00 00 00 00 
  ea:	eb 27                	jmp    113 <main+0x113>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f3:	00 
  f4:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  fc:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 103:	89 04 24             	mov    %eax,(%esp)
 106:	e8 31 03 00 00       	call   43c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 10b:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 112:	01 
 113:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 11a:	13 
 11b:	7e cf                	jle    ec <main+0xec>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 124:	89 04 24             	mov    %eax,(%esp)
 127:	e8 18 03 00 00       	call   444 <close>

  printf(1, "read\n");
 12c:	c7 44 24 04 7c 09 00 	movl   $0x97c,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	e8 58 04 00 00       	call   598 <printf>

  fd = open(path, O_RDONLY);
 140:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 147:	00 
 148:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 05 03 00 00       	call   45c <open>
 157:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15e:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 165:	00 00 00 00 
 169:	eb 27                	jmp    192 <main+0x192>
    read(fd, data, sizeof(data));
 16b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 172:	00 
 173:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 177:	89 44 24 04          	mov    %eax,0x4(%esp)
 17b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 182:	89 04 24             	mov    %eax,(%esp)
 185:	e8 aa 02 00 00       	call   434 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 18a:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 191:	01 
 192:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 199:	13 
 19a:	7e cf                	jle    16b <main+0x16b>
    read(fd, data, sizeof(data));
  close(fd);
 19c:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 99 02 00 00       	call   444 <close>

  wait();
 1ab:	e8 74 02 00 00       	call   424 <wait>
  
  exit();
 1b0:	e8 67 02 00 00       	call   41c <exit>
 1b5:	90                   	nop
 1b6:	90                   	nop
 1b7:	90                   	nop

000001b8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
 1bb:	57                   	push   %edi
 1bc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c0:	8b 55 10             	mov    0x10(%ebp),%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	89 cb                	mov    %ecx,%ebx
 1c8:	89 df                	mov    %ebx,%edi
 1ca:	89 d1                	mov    %edx,%ecx
 1cc:	fc                   	cld    
 1cd:	f3 aa                	rep stos %al,%es:(%edi)
 1cf:	89 ca                	mov    %ecx,%edx
 1d1:	89 fb                	mov    %edi,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d9:	5b                   	pop    %ebx
 1da:	5f                   	pop    %edi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    

000001dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	0f b6 10             	movzbl (%eax),%edx
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	88 10                	mov    %dl,(%eax)
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	84 c0                	test   %al,%al
 1fc:	0f 95 c0             	setne  %al
 1ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 203:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 207:	84 c0                	test   %al,%al
 209:	75 de                	jne    1e9 <strcpy+0xc>
    ;
  return os;
 20b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 213:	eb 08                	jmp    21d <strcmp+0xd>
    p++, q++;
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	74 10                	je     237 <strcmp+0x27>
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 10             	movzbl (%eax),%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	38 c2                	cmp    %al,%dl
 235:	74 de                	je     215 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	0f b6 d0             	movzbl %al,%edx
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f b6 c0             	movzbl %al,%eax
 249:	89 d1                	mov    %edx,%ecx
 24b:	29 c1                	sub    %eax,%ecx
 24d:	89 c8                	mov    %ecx,%eax
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <strlen>:

uint
strlen(char *s)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25e:	eb 04                	jmp    264 <strlen+0x13>
 260:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
 267:	03 45 08             	add    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	84 c0                	test   %al,%al
 26f:	75 ef                	jne    260 <strlen+0xf>
    ;
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	89 44 24 08          	mov    %eax,0x8(%esp)
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 44 24 04          	mov    %eax,0x4(%esp)
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 23 ff ff ff       	call   1b8 <stosb>
  return dst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <strchr>:

char*
strchr(const char *s, char c)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 04             	sub    $0x4,%esp
 2a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a6:	eb 14                	jmp    2bc <strchr+0x22>
    if(*s == c)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b1:	75 05                	jne    2b8 <strchr+0x1e>
      return (char*)s;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	eb 13                	jmp    2cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	75 e2                	jne    2a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cb:	c9                   	leave  
 2cc:	c3                   	ret    

000002cd <gets>:

char*
gets(char *buf, int max)
{
 2cd:	55                   	push   %ebp
 2ce:	89 e5                	mov    %esp,%ebp
 2d0:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2da:	eb 44                	jmp    320 <gets+0x53>
    cc = read(0, &c, 1);
 2dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2e3:	00 
 2e4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2f2:	e8 3d 01 00 00       	call   434 <read>
 2f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 2fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2fe:	7e 2d                	jle    32d <gets+0x60>
      break;
    buf[i++] = c;
 300:	8b 45 f0             	mov    -0x10(%ebp),%eax
 303:	03 45 08             	add    0x8(%ebp),%eax
 306:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 30a:	88 10                	mov    %dl,(%eax)
 30c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 16                	je     32e <gets+0x61>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0e                	je     32e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c b1                	jl     2dc <gets+0xf>
 32b:	eb 01                	jmp    32e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 32d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 331:	03 45 08             	add    0x8(%ebp),%eax
 334:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <stat>:

int
stat(char *n, struct stat *st)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 349:	00 
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 04 24             	mov    %eax,(%esp)
 350:	e8 07 01 00 00       	call   45c <open>
 355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 35c:	79 07                	jns    365 <stat+0x29>
    return -1;
 35e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 363:	eb 23                	jmp    388 <stat+0x4c>
  r = fstat(fd, st);
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 fd 00 00 00       	call   474 <fstat>
 377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 bf 00 00 00       	call   444 <close>
  return r;
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <atoi>:

int
atoi(const char *s)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 397:	eb 24                	jmp    3bd <atoi+0x33>
    n = n*10 + *s++ - '0';
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 02             	shl    $0x2,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	01 c0                	add    %eax,%eax
 3a5:	89 c2                	mov    %eax,%edx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f be c0             	movsbl %al,%eax
 3b0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3b3:	83 e8 30             	sub    $0x30,%eax
 3b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x47>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c8                	jle    399 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 3e8:	eb 13                	jmp    3fd <memmove+0x27>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	0f b6 10             	movzbl (%eax),%edx
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	88 10                	mov    %dl,(%eax)
 3f5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 3f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 401:	0f 9f c0             	setg   %al
 404:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 408:	84 c0                	test   %al,%al
 40a:	75 de                	jne    3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    
 411:	90                   	nop
 412:	90                   	nop
 413:	90                   	nop

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 28             	sub    $0x28,%esp
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 5a ff ff ff       	call   43c <write>
}
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	53                   	push   %ebx
 4e8:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f6:	74 17                	je     50f <printint+0x2b>
 4f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fc:	79 11                	jns    50f <printint+0x2b>
    neg = 1;
 4fe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 505:	8b 45 0c             	mov    0xc(%ebp),%eax
 508:	f7 d8                	neg    %eax
 50a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50d:	eb 06                	jmp    515 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 515:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 51c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 f4             	mov    -0xc(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 d0                	mov    %edx,%eax
 52e:	0f b6 80 8c 09 00 00 	movzbl 0x98c(%eax),%eax
 535:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 539:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 53d:	8b 45 10             	mov    0x10(%ebp),%eax
 540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 543:	8b 45 f4             	mov    -0xc(%ebp),%eax
 546:	ba 00 00 00 00       	mov    $0x0,%edx
 54b:	f7 75 d4             	divl   -0x2c(%ebp)
 54e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 555:	75 c5                	jne    51c <printint+0x38>
  if(neg)
 557:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55b:	74 2a                	je     587 <printint+0xa3>
    buf[i++] = '-';
 55d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 560:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 565:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 569:	eb 1d                	jmp    588 <printint+0xa4>
    putc(fd, buf[i]);
 56b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 37 ff ff ff       	call   4bc <putc>
 585:	eb 01                	jmp    588 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 587:	90                   	nop
 588:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 58c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 590:	79 d9                	jns    56b <printint+0x87>
    putc(fd, buf[i]);
}
 592:	83 c4 44             	add    $0x44,%esp
 595:	5b                   	pop    %ebx
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    

00000598 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 59e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a8:	83 c0 04             	add    $0x4,%eax
 5ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5b5:	e9 7e 01 00 00       	jmp    738 <printf+0x1a0>
    c = fmt[i] & 0xff;
 5ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	25 ff 00 00 00       	and    $0xff,%eax
 5ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d5:	75 2c                	jne    603 <printf+0x6b>
      if(c == '%'){
 5d7:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5db:	75 0c                	jne    5e9 <printf+0x51>
        state = '%';
 5dd:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 5e4:	e9 4b 01 00 00       	jmp    734 <printf+0x19c>
      } else {
        putc(fd, c);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 be fe ff ff       	call   4bc <putc>
 5fe:	e9 31 01 00 00       	jmp    734 <printf+0x19c>
      }
    } else if(state == '%'){
 603:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 607:	0f 85 27 01 00 00    	jne    734 <printf+0x19c>
      if(c == 'd'){
 60d:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 611:	75 2d                	jne    640 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 613:	8b 45 f4             	mov    -0xc(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 61f:	00 
 620:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 627:	00 
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 ad fe ff ff       	call   4e4 <printint>
        ap++;
 637:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 63b:	e9 ed 00 00 00       	jmp    72d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 640:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 644:	74 06                	je     64c <printf+0xb4>
 646:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 64a:	75 2d                	jne    679 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 64c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 658:	00 
 659:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 660:	00 
 661:	89 44 24 04          	mov    %eax,0x4(%esp)
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 74 fe ff ff       	call   4e4 <printint>
        ap++;
 670:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 674:	e9 b4 00 00 00       	jmp    72d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 679:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 67d:	75 46                	jne    6c5 <printf+0x12d>
        s = (char*)*ap;
 67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 687:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 68b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 68f:	75 27                	jne    6b8 <printf+0x120>
          s = "(null)";
 691:	c7 45 e4 82 09 00 00 	movl   $0x982,-0x1c(%ebp)
        while(*s != 0){
 698:	eb 1f                	jmp    6b9 <printf+0x121>
          putc(fd, *s);
 69a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69d:	0f b6 00             	movzbl (%eax),%eax
 6a0:	0f be c0             	movsbl %al,%eax
 6a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 0a fe ff ff       	call   4bc <putc>
          s++;
 6b2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6b6:	eb 01                	jmp    6b9 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b8:	90                   	nop
 6b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bc:	0f b6 00             	movzbl (%eax),%eax
 6bf:	84 c0                	test   %al,%al
 6c1:	75 d7                	jne    69a <printf+0x102>
 6c3:	eb 68                	jmp    72d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c5:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6c9:	75 1d                	jne    6e8 <printf+0x150>
        putc(fd, *ap);
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	0f be c0             	movsbl %al,%eax
 6d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	89 04 24             	mov    %eax,(%esp)
 6dd:	e8 da fd ff ff       	call   4bc <putc>
        ap++;
 6e2:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 6e6:	eb 45                	jmp    72d <printf+0x195>
      } else if(c == '%'){
 6e8:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6ec:	75 17                	jne    705 <printf+0x16d>
        putc(fd, c);
 6ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	89 04 24             	mov    %eax,(%esp)
 6fe:	e8 b9 fd ff ff       	call   4bc <putc>
 703:	eb 28                	jmp    72d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 705:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 70c:	00 
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	89 04 24             	mov    %eax,(%esp)
 713:	e8 a4 fd ff ff       	call   4bc <putc>
        putc(fd, c);
 718:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	89 44 24 04          	mov    %eax,0x4(%esp)
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 8f fd ff ff       	call   4bc <putc>
      }
      state = 0;
 72d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 734:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 738:	8b 55 0c             	mov    0xc(%ebp),%edx
 73b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 741:	0f b6 00             	movzbl (%eax),%eax
 744:	84 c0                	test   %al,%al
 746:	0f 85 6e fe ff ff    	jne    5ba <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74c:	c9                   	leave  
 74d:	c3                   	ret    
 74e:	90                   	nop
 74f:	90                   	nop

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 756:	8b 45 08             	mov    0x8(%ebp),%eax
 759:	83 e8 08             	sub    $0x8,%eax
 75c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75f:	a1 a8 09 00 00       	mov    0x9a8,%eax
 764:	89 45 fc             	mov    %eax,-0x4(%ebp)
 767:	eb 24                	jmp    78d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 771:	77 12                	ja     785 <free+0x35>
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 24                	ja     79f <free+0x4f>
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	77 1a                	ja     79f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 793:	76 d4                	jbe    769 <free+0x19>
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79d:	76 ca                	jbe    769 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	c1 e0 03             	shl    $0x3,%eax
 7a8:	89 c2                	mov    %eax,%edx
 7aa:	03 55 f8             	add    -0x8(%ebp),%edx
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	39 c2                	cmp    %eax,%edx
 7b4:	75 24                	jne    7da <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	8b 50 04             	mov    0x4(%eax),%edx
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	01 c2                	add    %eax,%edx
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	8b 10                	mov    (%eax),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	89 10                	mov    %edx,(%eax)
 7d8:	eb 0a                	jmp    7e4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	c1 e0 03             	shl    $0x3,%eax
 7ed:	03 45 fc             	add    -0x4(%ebp),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	75 20                	jne    815 <free+0xc5>
    p->s.size += bp->s.size;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	8b 50 04             	mov    0x4(%eax),%edx
 7fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	01 c2                	add    %eax,%edx
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	8b 10                	mov    (%eax),%edx
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	89 10                	mov    %edx,(%eax)
 813:	eb 08                	jmp    81d <free+0xcd>
  } else
    p->s.ptr = bp;
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81b:	89 10                	mov    %edx,(%eax)
  freep = p;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	a3 a8 09 00 00       	mov    %eax,0x9a8
}
 825:	c9                   	leave  
 826:	c3                   	ret    

00000827 <morecore>:

static Header*
morecore(uint nu)
{
 827:	55                   	push   %ebp
 828:	89 e5                	mov    %esp,%ebp
 82a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 82d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 834:	77 07                	ja     83d <morecore+0x16>
    nu = 4096;
 836:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	c1 e0 03             	shl    $0x3,%eax
 843:	89 04 24             	mov    %eax,(%esp)
 846:	e8 59 fc ff ff       	call   4a4 <sbrk>
 84b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 84e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 852:	75 07                	jne    85b <morecore+0x34>
    return 0;
 854:	b8 00 00 00 00       	mov    $0x0,%eax
 859:	eb 22                	jmp    87d <morecore+0x56>
  hp = (Header*)p;
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 55 08             	mov    0x8(%ebp),%edx
 867:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	83 c0 08             	add    $0x8,%eax
 870:	89 04 24             	mov    %eax,(%esp)
 873:	e8 d8 fe ff ff       	call   750 <free>
  return freep;
 878:	a1 a8 09 00 00       	mov    0x9a8,%eax
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    

0000087f <malloc>:

void*
malloc(uint nbytes)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	83 c0 07             	add    $0x7,%eax
 88b:	c1 e8 03             	shr    $0x3,%eax
 88e:	83 c0 01             	add    $0x1,%eax
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 894:	a1 a8 09 00 00       	mov    0x9a8,%eax
 899:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a0:	75 23                	jne    8c5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8a2:	c7 45 f0 a0 09 00 00 	movl   $0x9a0,-0x10(%ebp)
 8a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ac:	a3 a8 09 00 00       	mov    %eax,0x9a8
 8b1:	a1 a8 09 00 00       	mov    0x9a8,%eax
 8b6:	a3 a0 09 00 00       	mov    %eax,0x9a0
    base.s.size = 0;
 8bb:	c7 05 a4 09 00 00 00 	movl   $0x0,0x9a4
 8c2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8d6:	72 4d                	jb     925 <malloc+0xa6>
      if(p->s.size == nunits)
 8d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8e1:	75 0c                	jne    8ef <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e6:	8b 10                	mov    (%eax),%edx
 8e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8eb:	89 10                	mov    %edx,(%eax)
 8ed:	eb 26                	jmp    915 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f2:	8b 40 04             	mov    0x4(%eax),%eax
 8f5:	89 c2                	mov    %eax,%edx
 8f7:	2b 55 f4             	sub    -0xc(%ebp),%edx
 8fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 900:	8b 45 ec             	mov    -0x14(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	c1 e0 03             	shl    $0x3,%eax
 909:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 90c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 912:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 915:	8b 45 f0             	mov    -0x10(%ebp),%eax
 918:	a3 a8 09 00 00       	mov    %eax,0x9a8
      return (void*)(p + 1);
 91d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 920:	83 c0 08             	add    $0x8,%eax
 923:	eb 38                	jmp    95d <malloc+0xde>
    }
    if(p == freep)
 925:	a1 a8 09 00 00       	mov    0x9a8,%eax
 92a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 92d:	75 1b                	jne    94a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	89 04 24             	mov    %eax,(%esp)
 935:	e8 ed fe ff ff       	call   827 <morecore>
 93a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 93d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 941:	75 07                	jne    94a <malloc+0xcb>
        return 0;
 943:	b8 00 00 00 00       	mov    $0x0,%eax
 948:	eb 13                	jmp    95d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 950:	8b 45 ec             	mov    -0x14(%ebp),%eax
 953:	8b 00                	mov    (%eax),%eax
 955:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 958:	e9 70 ff ff ff       	jmp    8cd <malloc+0x4e>
}
 95d:	c9                   	leave  
 95e:	c3                   	ret    
