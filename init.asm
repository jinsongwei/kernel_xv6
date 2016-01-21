
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 c2 08 00 00 	movl   $0x8c2,(%esp)
  18:	e8 9f 03 00 00       	call   3bc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 c2 08 00 00 	movl   $0x8c2,(%esp)
  38:	e8 87 03 00 00       	call   3c4 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 c2 08 00 00 	movl   $0x8c2,(%esp)
  4c:	e8 6b 03 00 00       	call   3bc <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 97 03 00 00       	call   3f4 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 8b 03 00 00       	call   3f4 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 ca 08 00 	movl   $0x8ca,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 78 04 00 00       	call   4f8 <printf>
    pid = fork();
  80:	e8 ef 02 00 00       	call   374 <fork>
  85:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(pid < 0){
  89:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 dd 08 00 	movl   $0x8dd,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 54 04 00 00       	call   4f8 <printf>
      exit();
  a4:	e8 d3 02 00 00       	call   37c <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ae:	75 43                	jne    f3 <main+0xf3>
      exec("sh", argv);
  b0:	c7 44 24 04 18 09 00 	movl   $0x918,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 bf 08 00 00 	movl   $0x8bf,(%esp)
  bf:	e8 f0 02 00 00       	call   3b4 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 f0 08 00 	movl   $0x8f0,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 20 04 00 00       	call   4f8 <printf>
      exit();
  d8:	e8 9f 02 00 00       	call   37c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 06 09 00 	movl   $0x906,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 07 04 00 00       	call   4f8 <printf>
  f1:	eb 01                	jmp    f4 <main+0xf4>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f3:	90                   	nop
  f4:	e8 8b 02 00 00       	call   384 <wait>
  f9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  fd:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 102:	0f 88 63 ff ff ff    	js     6b <main+0x6b>
 108:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10c:	3b 44 24 18          	cmp    0x18(%esp),%eax
 110:	75 cb                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 112:	e9 55 ff ff ff       	jmp    6c <main+0x6c>
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 10             	movzbl (%eax),%edx
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	88 10                	mov    %dl,(%eax)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	0f 95 c0             	setne  %al
 15f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 163:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 167:	84 c0                	test   %al,%al
 169:	75 de                	jne    149 <strcpy+0xc>
    ;
  return os;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 173:	eb 08                	jmp    17d <strcmp+0xd>
    p++, q++;
 175:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 179:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	74 10                	je     197 <strcmp+0x27>
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	38 c2                	cmp    %al,%dl
 195:	74 de                	je     175 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 d0             	movzbl %al,%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	89 d1                	mov    %edx,%ecx
 1ab:	29 c1                	sub    %eax,%ecx
 1ad:	89 c8                	mov    %ecx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 ef                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 23 ff ff ff       	call   118 <stosb>
  return dst;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 206:	eb 14                	jmp    21c <strchr+0x22>
    if(*s == c)
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 211:	75 05                	jne    218 <strchr+0x1e>
      return (char*)s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	eb 13                	jmp    22b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	84 c0                	test   %al,%al
 224:	75 e2                	jne    208 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 226:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <gets>:

char*
gets(char *buf, int max)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 233:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 23a:	eb 44                	jmp    280 <gets+0x53>
    cc = read(0, &c, 1);
 23c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 243:	00 
 244:	8d 45 ef             	lea    -0x11(%ebp),%eax
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 252:	e8 3d 01 00 00       	call   394 <read>
 257:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 25a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25e:	7e 2d                	jle    28d <gets+0x60>
      break;
    buf[i++] = c;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	03 45 08             	add    0x8(%ebp),%eax
 266:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26a:	88 10                	mov    %dl,(%eax)
 26c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0a                	cmp    $0xa,%al
 276:	74 16                	je     28e <gets+0x61>
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	3c 0d                	cmp    $0xd,%al
 27e:	74 0e                	je     28e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	8b 45 f0             	mov    -0x10(%ebp),%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	3b 45 0c             	cmp    0xc(%ebp),%eax
 289:	7c b1                	jl     23c <gets+0xf>
 28b:	eb 01                	jmp    28e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 291:	03 45 08             	add    0x8(%ebp),%eax
 294:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <stat>:

int
stat(char *n, struct stat *st)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 07 01 00 00       	call   3bc <open>
 2b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bc:	79 07                	jns    2c5 <stat+0x29>
    return -1;
 2be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c3:	eb 23                	jmp    2e8 <stat+0x4c>
  r = fstat(fd, st);
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	89 04 24             	mov    %eax,(%esp)
 2d2:	e8 fd 00 00 00       	call   3d4 <fstat>
 2d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2dd:	89 04 24             	mov    %eax,(%esp)
 2e0:	e8 bf 00 00 00       	call   3a4 <close>
  return r;
 2e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f7:	eb 24                	jmp    31d <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 02             	shl    $0x2,%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 c0                	add    %eax,%eax
 305:	89 c2                	mov    %eax,%edx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	8d 04 02             	lea    (%edx,%eax,1),%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x47>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c8                	jle    2f9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 348:	eb 13                	jmp    35d <memmove+0x27>
    *dst++ = *src++;
 34a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 359:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    
 371:	90                   	nop
 372:	90                   	nop
 373:	90                   	nop

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 28             	sub    $0x28,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 428:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42f:	00 
 430:	8d 45 f4             	lea    -0xc(%ebp),%eax
 433:	89 44 24 04          	mov    %eax,0x4(%esp)
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	89 04 24             	mov    %eax,(%esp)
 43d:	e8 5a ff ff ff       	call   39c <write>
}
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	53                   	push   %ebx
 448:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 452:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 456:	74 17                	je     46f <printint+0x2b>
 458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45c:	79 11                	jns    46f <printint+0x2b>
    neg = 1;
 45e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 465:	8b 45 0c             	mov    0xc(%ebp),%eax
 468:	f7 d8                	neg    %eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46d:	eb 06                	jmp    475 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 475:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 47c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 47f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 482:	8b 45 f4             	mov    -0xc(%ebp),%eax
 485:	ba 00 00 00 00       	mov    $0x0,%edx
 48a:	f7 f3                	div    %ebx
 48c:	89 d0                	mov    %edx,%eax
 48e:	0f b6 80 20 09 00 00 	movzbl 0x920(%eax),%eax
 495:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 499:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 49d:	8b 45 10             	mov    0x10(%ebp),%eax
 4a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	ba 00 00 00 00       	mov    $0x0,%edx
 4ab:	f7 75 d4             	divl   -0x2c(%ebp)
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b5:	75 c5                	jne    47c <printint+0x38>
  if(neg)
 4b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bb:	74 2a                	je     4e7 <printint+0xa3>
    buf[i++] = '-';
 4bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4c9:	eb 1d                	jmp    4e8 <printint+0xa4>
    putc(fd, buf[i]);
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4d3:	0f be c0             	movsbl %al,%eax
 4d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	89 04 24             	mov    %eax,(%esp)
 4e0:	e8 37 ff ff ff       	call   41c <putc>
 4e5:	eb 01                	jmp    4e8 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e7:	90                   	nop
 4e8:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f0:	79 d9                	jns    4cb <printint+0x87>
    putc(fd, buf[i]);
}
 4f2:	83 c4 44             	add    $0x44,%esp
 4f5:	5b                   	pop    %ebx
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    

000004f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 505:	8d 45 0c             	lea    0xc(%ebp),%eax
 508:	83 c0 04             	add    $0x4,%eax
 50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 50e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 515:	e9 7e 01 00 00       	jmp    698 <printf+0x1a0>
    c = fmt[i] & 0xff;
 51a:	8b 55 0c             	mov    0xc(%ebp),%edx
 51d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 520:	8d 04 02             	lea    (%edx,%eax,1),%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	0f be c0             	movsbl %al,%eax
 529:	25 ff 00 00 00       	and    $0xff,%eax
 52e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 535:	75 2c                	jne    563 <printf+0x6b>
      if(c == '%'){
 537:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 53b:	75 0c                	jne    549 <printf+0x51>
        state = '%';
 53d:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 544:	e9 4b 01 00 00       	jmp    694 <printf+0x19c>
      } else {
        putc(fd, c);
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 be fe ff ff       	call   41c <putc>
 55e:	e9 31 01 00 00       	jmp    694 <printf+0x19c>
      }
    } else if(state == '%'){
 563:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 567:	0f 85 27 01 00 00    	jne    694 <printf+0x19c>
      if(c == 'd'){
 56d:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 571:	75 2d                	jne    5a0 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	8b 00                	mov    (%eax),%eax
 578:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57f:	00 
 580:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 587:	00 
 588:	89 44 24 04          	mov    %eax,0x4(%esp)
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	89 04 24             	mov    %eax,(%esp)
 592:	e8 ad fe ff ff       	call   444 <printint>
        ap++;
 597:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 59b:	e9 ed 00 00 00       	jmp    68d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5a0:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5a4:	74 06                	je     5ac <printf+0xb4>
 5a6:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5aa:	75 2d                	jne    5d9 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b8:	00 
 5b9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c0:	00 
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 74 fe ff ff       	call   444 <printint>
        ap++;
 5d0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5d4:	e9 b4 00 00 00       	jmp    68d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5d9:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5dd:	75 46                	jne    625 <printf+0x12d>
        s = (char*)*ap;
 5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5e7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5ef:	75 27                	jne    618 <printf+0x120>
          s = "(null)";
 5f1:	c7 45 e4 0f 09 00 00 	movl   $0x90f,-0x1c(%ebp)
        while(*s != 0){
 5f8:	eb 1f                	jmp    619 <printf+0x121>
          putc(fd, *s);
 5fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	89 44 24 04          	mov    %eax,0x4(%esp)
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	89 04 24             	mov    %eax,(%esp)
 60d:	e8 0a fe ff ff       	call   41c <putc>
          s++;
 612:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 616:	eb 01                	jmp    619 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 618:	90                   	nop
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	84 c0                	test   %al,%al
 621:	75 d7                	jne    5fa <printf+0x102>
 623:	eb 68                	jmp    68d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 625:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 629:	75 1d                	jne    648 <printf+0x150>
        putc(fd, *ap);
 62b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	89 44 24 04          	mov    %eax,0x4(%esp)
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	89 04 24             	mov    %eax,(%esp)
 63d:	e8 da fd ff ff       	call   41c <putc>
        ap++;
 642:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 646:	eb 45                	jmp    68d <printf+0x195>
      } else if(c == '%'){
 648:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 64c:	75 17                	jne    665 <printf+0x16d>
        putc(fd, c);
 64e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	89 44 24 04          	mov    %eax,0x4(%esp)
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	89 04 24             	mov    %eax,(%esp)
 65e:	e8 b9 fd ff ff       	call   41c <putc>
 663:	eb 28                	jmp    68d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 665:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66c:	00 
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 a4 fd ff ff       	call   41c <putc>
        putc(fd, c);
 678:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67b:	0f be c0             	movsbl %al,%eax
 67e:	89 44 24 04          	mov    %eax,0x4(%esp)
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 8f fd ff ff       	call   41c <putc>
      }
      state = 0;
 68d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 694:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 698:	8b 55 0c             	mov    0xc(%ebp),%edx
 69b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6a1:	0f b6 00             	movzbl (%eax),%eax
 6a4:	84 c0                	test   %al,%al
 6a6:	0f 85 6e fe ff ff    	jne    51a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ac:	c9                   	leave  
 6ad:	c3                   	ret    
 6ae:	90                   	nop
 6af:	90                   	nop

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	83 e8 08             	sub    $0x8,%eax
 6bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	a1 3c 09 00 00       	mov    0x93c,%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	eb 24                	jmp    6ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 12                	ja     6e5 <free+0x35>
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 24                	ja     6ff <free+0x4f>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	77 1a                	ja     6ff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	76 d4                	jbe    6c9 <free+0x19>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	76 ca                	jbe    6c9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	c1 e0 03             	shl    $0x3,%eax
 708:	89 c2                	mov    %eax,%edx
 70a:	03 55 f8             	add    -0x8(%ebp),%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	39 c2                	cmp    %eax,%edx
 714:	75 24                	jne    73a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	8b 50 04             	mov    0x4(%eax),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	8b 40 04             	mov    0x4(%eax),%eax
 724:	01 c2                	add    %eax,%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
 738:	eb 0a                	jmp    744 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	c1 e0 03             	shl    $0x3,%eax
 74d:	03 45 fc             	add    -0x4(%ebp),%eax
 750:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 753:	75 20                	jne    775 <free+0xc5>
    p->s.size += bp->s.size;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 50 04             	mov    0x4(%eax),%edx
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	01 c2                	add    %eax,%edx
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	8b 10                	mov    (%eax),%edx
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	89 10                	mov    %edx,(%eax)
 773:	eb 08                	jmp    77d <free+0xcd>
  } else
    p->s.ptr = bp;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 55 f8             	mov    -0x8(%ebp),%edx
 77b:	89 10                	mov    %edx,(%eax)
  freep = p;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	a3 3c 09 00 00       	mov    %eax,0x93c
}
 785:	c9                   	leave  
 786:	c3                   	ret    

00000787 <morecore>:

static Header*
morecore(uint nu)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 78d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 794:	77 07                	ja     79d <morecore+0x16>
    nu = 4096;
 796:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 79d:	8b 45 08             	mov    0x8(%ebp),%eax
 7a0:	c1 e0 03             	shl    $0x3,%eax
 7a3:	89 04 24             	mov    %eax,(%esp)
 7a6:	e8 59 fc ff ff       	call   404 <sbrk>
 7ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7ae:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7b2:	75 07                	jne    7bb <morecore+0x34>
    return 0;
 7b4:	b8 00 00 00 00       	mov    $0x0,%eax
 7b9:	eb 22                	jmp    7dd <morecore+0x56>
  hp = (Header*)p;
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 55 08             	mov    0x8(%ebp),%edx
 7c7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	83 c0 08             	add    $0x8,%eax
 7d0:	89 04 24             	mov    %eax,(%esp)
 7d3:	e8 d8 fe ff ff       	call   6b0 <free>
  return freep;
 7d8:	a1 3c 09 00 00       	mov    0x93c,%eax
}
 7dd:	c9                   	leave  
 7de:	c3                   	ret    

000007df <malloc>:

void*
malloc(uint nbytes)
{
 7df:	55                   	push   %ebp
 7e0:	89 e5                	mov    %esp,%ebp
 7e2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	83 c0 07             	add    $0x7,%eax
 7eb:	c1 e8 03             	shr    $0x3,%eax
 7ee:	83 c0 01             	add    $0x1,%eax
 7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7f4:	a1 3c 09 00 00       	mov    0x93c,%eax
 7f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 800:	75 23                	jne    825 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 802:	c7 45 f0 34 09 00 00 	movl   $0x934,-0x10(%ebp)
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	a3 3c 09 00 00       	mov    %eax,0x93c
 811:	a1 3c 09 00 00       	mov    0x93c,%eax
 816:	a3 34 09 00 00       	mov    %eax,0x934
    base.s.size = 0;
 81b:	c7 05 38 09 00 00 00 	movl   $0x0,0x938
 822:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 82d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 836:	72 4d                	jb     885 <malloc+0xa6>
      if(p->s.size == nunits)
 838:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 841:	75 0c                	jne    84f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 843:	8b 45 ec             	mov    -0x14(%ebp),%eax
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	89 10                	mov    %edx,(%eax)
 84d:	eb 26                	jmp    875 <malloc+0x96>
      else {
        p->s.size -= nunits;
 84f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	89 c2                	mov    %eax,%edx
 857:	2b 55 f4             	sub    -0xc(%ebp),%edx
 85a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 860:	8b 45 ec             	mov    -0x14(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	c1 e0 03             	shl    $0x3,%eax
 869:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 86c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 872:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	a3 3c 09 00 00       	mov    %eax,0x93c
      return (void*)(p + 1);
 87d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 880:	83 c0 08             	add    $0x8,%eax
 883:	eb 38                	jmp    8bd <malloc+0xde>
    }
    if(p == freep)
 885:	a1 3c 09 00 00       	mov    0x93c,%eax
 88a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 88d:	75 1b                	jne    8aa <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	89 04 24             	mov    %eax,(%esp)
 895:	e8 ed fe ff ff       	call   787 <morecore>
 89a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 89d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8a1:	75 07                	jne    8aa <malloc+0xcb>
        return 0;
 8a3:	b8 00 00 00 00       	mov    $0x0,%eax
 8a8:	eb 13                	jmp    8bd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b8:	e9 70 ff ff ff       	jmp    82d <malloc+0x4e>
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    
