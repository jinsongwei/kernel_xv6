
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
  2c:	c7 44 24 04 67 09 00 	movl   $0x967,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 60 05 00 00       	call   5a0 <printf>
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
  92:	c7 44 24 04 7a 09 00 	movl   $0x97a,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 fa 04 00 00       	call   5a0 <printf>

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
 12c:	c7 44 24 04 84 09 00 	movl   $0x984,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	e8 60 04 00 00       	call   5a0 <printf>

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

000004bc <count>:
//add
SYSCALL(count)
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 28             	sub    $0x28,%esp
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d7:	00 
 4d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 52 ff ff ff       	call   43c <write>
}
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	53                   	push   %ebx
 4f0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4fe:	74 17                	je     517 <printint+0x2b>
 500:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 504:	79 11                	jns    517 <printint+0x2b>
    neg = 1;
 506:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50d:	8b 45 0c             	mov    0xc(%ebp),%eax
 510:	f7 d8                	neg    %eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 515:	eb 06                	jmp    51d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 517:	8b 45 0c             	mov    0xc(%ebp),%eax
 51a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 51d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 524:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 527:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52d:	ba 00 00 00 00       	mov    $0x0,%edx
 532:	f7 f3                	div    %ebx
 534:	89 d0                	mov    %edx,%eax
 536:	0f b6 80 94 09 00 00 	movzbl 0x994(%eax),%eax
 53d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 541:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 545:	8b 45 10             	mov    0x10(%ebp),%eax
 548:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	ba 00 00 00 00       	mov    $0x0,%edx
 553:	f7 75 d4             	divl   -0x2c(%ebp)
 556:	89 45 f4             	mov    %eax,-0xc(%ebp)
 559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55d:	75 c5                	jne    524 <printint+0x38>
  if(neg)
 55f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 563:	74 2a                	je     58f <printint+0xa3>
    buf[i++] = '-';
 565:	8b 45 ec             	mov    -0x14(%ebp),%eax
 568:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 56d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 571:	eb 1d                	jmp    590 <printint+0xa4>
    putc(fd, buf[i]);
 573:	8b 45 ec             	mov    -0x14(%ebp),%eax
 576:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	89 44 24 04          	mov    %eax,0x4(%esp)
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	89 04 24             	mov    %eax,(%esp)
 588:	e8 37 ff ff ff       	call   4c4 <putc>
 58d:	eb 01                	jmp    590 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58f:	90                   	nop
 590:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 594:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 598:	79 d9                	jns    573 <printint+0x87>
    putc(fd, buf[i]);
}
 59a:	83 c4 44             	add    $0x44,%esp
 59d:	5b                   	pop    %ebx
 59e:	5d                   	pop    %ebp
 59f:	c3                   	ret    

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b0:	83 c0 04             	add    $0x4,%eax
 5b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 5b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 5bd:	e9 7e 01 00 00       	jmp    740 <printf+0x1a0>
    c = fmt[i] & 0xff;
 5c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	25 ff 00 00 00       	and    $0xff,%eax
 5d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 5d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5dd:	75 2c                	jne    60b <printf+0x6b>
      if(c == '%'){
 5df:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5e3:	75 0c                	jne    5f1 <printf+0x51>
        state = '%';
 5e5:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 5ec:	e9 4b 01 00 00       	jmp    73c <printf+0x19c>
      } else {
        putc(fd, c);
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	89 04 24             	mov    %eax,(%esp)
 601:	e8 be fe ff ff       	call   4c4 <putc>
 606:	e9 31 01 00 00       	jmp    73c <printf+0x19c>
      }
    } else if(state == '%'){
 60b:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 60f:	0f 85 27 01 00 00    	jne    73c <printf+0x19c>
      if(c == 'd'){
 615:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 619:	75 2d                	jne    648 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 627:	00 
 628:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62f:	00 
 630:	89 44 24 04          	mov    %eax,0x4(%esp)
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 ad fe ff ff       	call   4ec <printint>
        ap++;
 63f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 643:	e9 ed 00 00 00       	jmp    735 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 648:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 64c:	74 06                	je     654 <printf+0xb4>
 64e:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 652:	75 2d                	jne    681 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 654:	8b 45 f4             	mov    -0xc(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 660:	00 
 661:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 668:	00 
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 74 fe ff ff       	call   4ec <printint>
        ap++;
 678:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 67c:	e9 b4 00 00 00       	jmp    735 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 681:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 685:	75 46                	jne    6cd <printf+0x12d>
        s = (char*)*ap;
 687:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 68f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 693:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 697:	75 27                	jne    6c0 <printf+0x120>
          s = "(null)";
 699:	c7 45 e4 8a 09 00 00 	movl   $0x98a,-0x1c(%ebp)
        while(*s != 0){
 6a0:	eb 1f                	jmp    6c1 <printf+0x121>
          putc(fd, *s);
 6a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a5:	0f b6 00             	movzbl (%eax),%eax
 6a8:	0f be c0             	movsbl %al,%eax
 6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 6af:	8b 45 08             	mov    0x8(%ebp),%eax
 6b2:	89 04 24             	mov    %eax,(%esp)
 6b5:	e8 0a fe ff ff       	call   4c4 <putc>
          s++;
 6ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6be:	eb 01                	jmp    6c1 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c0:	90                   	nop
 6c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c4:	0f b6 00             	movzbl (%eax),%eax
 6c7:	84 c0                	test   %al,%al
 6c9:	75 d7                	jne    6a2 <printf+0x102>
 6cb:	eb 68                	jmp    735 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cd:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 6d1:	75 1d                	jne    6f0 <printf+0x150>
        putc(fd, *ap);
 6d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 da fd ff ff       	call   4c4 <putc>
        ap++;
 6ea:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 6ee:	eb 45                	jmp    735 <printf+0x195>
      } else if(c == '%'){
 6f0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 6f4:	75 17                	jne    70d <printf+0x16d>
        putc(fd, c);
 6f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f9:	0f be c0             	movsbl %al,%eax
 6fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 700:	8b 45 08             	mov    0x8(%ebp),%eax
 703:	89 04 24             	mov    %eax,(%esp)
 706:	e8 b9 fd ff ff       	call   4c4 <putc>
 70b:	eb 28                	jmp    735 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 714:	00 
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 a4 fd ff ff       	call   4c4 <putc>
        putc(fd, c);
 720:	8b 45 e8             	mov    -0x18(%ebp),%eax
 723:	0f be c0             	movsbl %al,%eax
 726:	89 44 24 04          	mov    %eax,0x4(%esp)
 72a:	8b 45 08             	mov    0x8(%ebp),%eax
 72d:	89 04 24             	mov    %eax,(%esp)
 730:	e8 8f fd ff ff       	call   4c4 <putc>
      }
      state = 0;
 735:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 740:	8b 55 0c             	mov    0xc(%ebp),%edx
 743:	8b 45 ec             	mov    -0x14(%ebp),%eax
 746:	8d 04 02             	lea    (%edx,%eax,1),%eax
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	84 c0                	test   %al,%al
 74e:	0f 85 6e fe ff ff    	jne    5c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 754:	c9                   	leave  
 755:	c3                   	ret    
 756:	90                   	nop
 757:	90                   	nop

00000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	83 e8 08             	sub    $0x8,%eax
 764:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	a1 b0 09 00 00       	mov    0x9b0,%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	eb 24                	jmp    795 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 12                	ja     78d <free+0x35>
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 24                	ja     7a7 <free+0x4f>
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	77 1a                	ja     7a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79b:	76 d4                	jbe    771 <free+0x19>
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a5:	76 ca                	jbe    771 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	c1 e0 03             	shl    $0x3,%eax
 7b0:	89 c2                	mov    %eax,%edx
 7b2:	03 55 f8             	add    -0x8(%ebp),%edx
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	39 c2                	cmp    %eax,%edx
 7bc:	75 24                	jne    7e2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	01 c2                	add    %eax,%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 0a                	jmp    7ec <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	c1 e0 03             	shl    $0x3,%eax
 7f5:	03 45 fc             	add    -0x4(%ebp),%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	75 20                	jne    81d <free+0xc5>
    p->s.size += bp->s.size;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 08                	jmp    825 <free+0xcd>
  } else
    p->s.ptr = bp;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 55 f8             	mov    -0x8(%ebp),%edx
 823:	89 10                	mov    %edx,(%eax)
  freep = p;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	a3 b0 09 00 00       	mov    %eax,0x9b0
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <morecore>:

static Header*
morecore(uint nu)
{
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 835:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83c:	77 07                	ja     845 <morecore+0x16>
    nu = 4096;
 83e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	c1 e0 03             	shl    $0x3,%eax
 84b:	89 04 24             	mov    %eax,(%esp)
 84e:	e8 51 fc ff ff       	call   4a4 <sbrk>
 853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 856:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 85a:	75 07                	jne    863 <morecore+0x34>
    return 0;
 85c:	b8 00 00 00 00       	mov    $0x0,%eax
 861:	eb 22                	jmp    885 <morecore+0x56>
  hp = (Header*)p;
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 55 08             	mov    0x8(%ebp),%edx
 86f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	83 c0 08             	add    $0x8,%eax
 878:	89 04 24             	mov    %eax,(%esp)
 87b:	e8 d8 fe ff ff       	call   758 <free>
  return freep;
 880:	a1 b0 09 00 00       	mov    0x9b0,%eax
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <malloc>:

void*
malloc(uint nbytes)
{
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88d:	8b 45 08             	mov    0x8(%ebp),%eax
 890:	83 c0 07             	add    $0x7,%eax
 893:	c1 e8 03             	shr    $0x3,%eax
 896:	83 c0 01             	add    $0x1,%eax
 899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 89c:	a1 b0 09 00 00       	mov    0x9b0,%eax
 8a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a8:	75 23                	jne    8cd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8aa:	c7 45 f0 a8 09 00 00 	movl   $0x9a8,-0x10(%ebp)
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	a3 b0 09 00 00       	mov    %eax,0x9b0
 8b9:	a1 b0 09 00 00       	mov    0x9b0,%eax
 8be:	a3 a8 09 00 00       	mov    %eax,0x9a8
    base.s.size = 0;
 8c3:	c7 05 ac 09 00 00 00 	movl   $0x0,0x9ac
 8ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 8d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8de:	72 4d                	jb     92d <malloc+0xa6>
      if(p->s.size == nunits)
 8e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8e9:	75 0c                	jne    8f7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 26                	jmp    91d <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fa:	8b 40 04             	mov    0x4(%eax),%eax
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	2b 55 f4             	sub    -0xc(%ebp),%edx
 902:	8b 45 ec             	mov    -0x14(%ebp),%eax
 905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 908:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	c1 e0 03             	shl    $0x3,%eax
 911:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 914:	8b 45 ec             	mov    -0x14(%ebp),%eax
 917:	8b 55 f4             	mov    -0xc(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	a3 b0 09 00 00       	mov    %eax,0x9b0
      return (void*)(p + 1);
 925:	8b 45 ec             	mov    -0x14(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	eb 38                	jmp    965 <malloc+0xde>
    }
    if(p == freep)
 92d:	a1 b0 09 00 00       	mov    0x9b0,%eax
 932:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 935:	75 1b                	jne    952 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	89 04 24             	mov    %eax,(%esp)
 93d:	e8 ed fe ff ff       	call   82f <morecore>
 942:	89 45 ec             	mov    %eax,-0x14(%ebp)
 945:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 949:	75 07                	jne    952 <malloc+0xcb>
        return 0;
 94b:	b8 00 00 00 00       	mov    $0x0,%eax
 950:	eb 13                	jmp    965 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 952:	8b 45 ec             	mov    -0x14(%ebp),%eax
 955:	89 45 f0             	mov    %eax,-0x10(%ebp)
 958:	8b 45 ec             	mov    -0x14(%ebp),%eax
 95b:	8b 00                	mov    (%eax),%eax
 95d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 960:	e9 70 ff ff ff       	jmp    8d5 <malloc+0x4e>
}
 965:	c9                   	leave  
 966:	c3                   	ret    
