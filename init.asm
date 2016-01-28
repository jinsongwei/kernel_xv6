
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
  11:	c7 04 24 ca 08 00 00 	movl   $0x8ca,(%esp)
  18:	e8 9f 03 00 00       	call   3bc <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 ca 08 00 00 	movl   $0x8ca,(%esp)
  38:	e8 87 03 00 00       	call   3c4 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 ca 08 00 00 	movl   $0x8ca,(%esp)
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
  6c:	c7 44 24 04 d2 08 00 	movl   $0x8d2,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 80 04 00 00       	call   500 <printf>
    pid = fork();
  80:	e8 ef 02 00 00       	call   374 <fork>
  85:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(pid < 0){
  89:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 e5 08 00 	movl   $0x8e5,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 5c 04 00 00       	call   500 <printf>
      exit();
  a4:	e8 d3 02 00 00       	call   37c <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ae:	75 43                	jne    f3 <main+0xf3>
      exec("sh", argv);
  b0:	c7 44 24 04 20 09 00 	movl   $0x920,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 c7 08 00 00 	movl   $0x8c7,(%esp)
  bf:	e8 f0 02 00 00       	call   3b4 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 f8 08 00 	movl   $0x8f8,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 28 04 00 00       	call   500 <printf>
      exit();
  d8:	e8 9f 02 00 00       	call   37c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 0e 09 00 	movl   $0x90e,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 0f 04 00 00       	call   500 <printf>
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

0000041c <count>:
//add
SYSCALL(count)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 28             	sub    $0x28,%esp
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 430:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 437:	00 
 438:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43b:	89 44 24 04          	mov    %eax,0x4(%esp)
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	89 04 24             	mov    %eax,(%esp)
 445:	e8 52 ff ff ff       	call   39c <write>
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	53                   	push   %ebx
 450:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45e:	74 17                	je     477 <printint+0x2b>
 460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 464:	79 11                	jns    477 <printint+0x2b>
    neg = 1;
 466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	f7 d8                	neg    %eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 475:	eb 06                	jmp    47d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 47d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 484:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 d0                	mov    %edx,%eax
 496:	0f b6 80 28 09 00 00 	movzbl 0x928(%eax),%eax
 49d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4a1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4a5:	8b 45 10             	mov    0x10(%ebp),%eax
 4a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	ba 00 00 00 00       	mov    $0x0,%edx
 4b3:	f7 75 d4             	divl   -0x2c(%ebp)
 4b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bd:	75 c5                	jne    484 <printint+0x38>
  if(neg)
 4bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c3:	74 2a                	je     4ef <printint+0xa3>
    buf[i++] = '-';
 4c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4cd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4d1:	eb 1d                	jmp    4f0 <printint+0xa4>
    putc(fd, buf[i]);
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e2:	8b 45 08             	mov    0x8(%ebp),%eax
 4e5:	89 04 24             	mov    %eax,(%esp)
 4e8:	e8 37 ff ff ff       	call   424 <putc>
 4ed:	eb 01                	jmp    4f0 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ef:	90                   	nop
 4f0:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f8:	79 d9                	jns    4d3 <printint+0x87>
    putc(fd, buf[i]);
}
 4fa:	83 c4 44             	add    $0x44,%esp
 4fd:	5b                   	pop    %ebx
 4fe:	5d                   	pop    %ebp
 4ff:	c3                   	ret    

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50d:	8d 45 0c             	lea    0xc(%ebp),%eax
 510:	83 c0 04             	add    $0x4,%eax
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 51d:	e9 7e 01 00 00       	jmp    6a0 <printf+0x1a0>
    c = fmt[i] & 0xff;
 522:	8b 55 0c             	mov    0xc(%ebp),%edx
 525:	8b 45 ec             	mov    -0x14(%ebp),%eax
 528:	8d 04 02             	lea    (%edx,%eax,1),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	25 ff 00 00 00       	and    $0xff,%eax
 536:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 539:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53d:	75 2c                	jne    56b <printf+0x6b>
      if(c == '%'){
 53f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 543:	75 0c                	jne    551 <printf+0x51>
        state = '%';
 545:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 54c:	e9 4b 01 00 00       	jmp    69c <printf+0x19c>
      } else {
        putc(fd, c);
 551:	8b 45 e8             	mov    -0x18(%ebp),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	89 44 24 04          	mov    %eax,0x4(%esp)
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	89 04 24             	mov    %eax,(%esp)
 561:	e8 be fe ff ff       	call   424 <putc>
 566:	e9 31 01 00 00       	jmp    69c <printf+0x19c>
      }
    } else if(state == '%'){
 56b:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 56f:	0f 85 27 01 00 00    	jne    69c <printf+0x19c>
      if(c == 'd'){
 575:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 579:	75 2d                	jne    5a8 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 587:	00 
 588:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 58f:	00 
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 ad fe ff ff       	call   44c <printint>
        ap++;
 59f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5a3:	e9 ed 00 00 00       	jmp    695 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5a8:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5ac:	74 06                	je     5b4 <printf+0xb4>
 5ae:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5b2:	75 2d                	jne    5e1 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c0:	00 
 5c1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c8:	00 
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 04 24             	mov    %eax,(%esp)
 5d3:	e8 74 fe ff ff       	call   44c <printint>
        ap++;
 5d8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5dc:	e9 b4 00 00 00       	jmp    695 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5e1:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5e5:	75 46                	jne    62d <printf+0x12d>
        s = (char*)*ap;
 5e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5ef:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5f7:	75 27                	jne    620 <printf+0x120>
          s = "(null)";
 5f9:	c7 45 e4 17 09 00 00 	movl   $0x917,-0x1c(%ebp)
        while(*s != 0){
 600:	eb 1f                	jmp    621 <printf+0x121>
          putc(fd, *s);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 0a fe ff ff       	call   424 <putc>
          s++;
 61a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 61e:	eb 01                	jmp    621 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 620:	90                   	nop
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f b6 00             	movzbl (%eax),%eax
 627:	84 c0                	test   %al,%al
 629:	75 d7                	jne    602 <printf+0x102>
 62b:	eb 68                	jmp    695 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62d:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 631:	75 1d                	jne    650 <printf+0x150>
        putc(fd, *ap);
 633:	8b 45 f4             	mov    -0xc(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 da fd ff ff       	call   424 <putc>
        ap++;
 64a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 64e:	eb 45                	jmp    695 <printf+0x195>
      } else if(c == '%'){
 650:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 654:	75 17                	jne    66d <printf+0x16d>
        putc(fd, c);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	89 44 24 04          	mov    %eax,0x4(%esp)
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	89 04 24             	mov    %eax,(%esp)
 666:	e8 b9 fd ff ff       	call   424 <putc>
 66b:	eb 28                	jmp    695 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 674:	00 
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 a4 fd ff ff       	call   424 <putc>
        putc(fd, c);
 680:	8b 45 e8             	mov    -0x18(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	89 44 24 04          	mov    %eax,0x4(%esp)
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	89 04 24             	mov    %eax,(%esp)
 690:	e8 8f fd ff ff       	call   424 <putc>
      }
      state = 0;
 695:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a6:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6a9:	0f b6 00             	movzbl (%eax),%eax
 6ac:	84 c0                	test   %al,%al
 6ae:	0f 85 6e fe ff ff    	jne    522 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b4:	c9                   	leave  
 6b5:	c3                   	ret    
 6b6:	90                   	nop
 6b7:	90                   	nop

000006b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	83 e8 08             	sub    $0x8,%eax
 6c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	a1 44 09 00 00       	mov    0x944,%eax
 6cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cf:	eb 24                	jmp    6f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 12                	ja     6ed <free+0x35>
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	77 24                	ja     707 <free+0x4f>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	77 1a                	ja     707 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fb:	76 d4                	jbe    6d1 <free+0x19>
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 705:	76 ca                	jbe    6d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	8b 40 04             	mov    0x4(%eax),%eax
 70d:	c1 e0 03             	shl    $0x3,%eax
 710:	89 c2                	mov    %eax,%edx
 712:	03 55 f8             	add    -0x8(%ebp),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 00                	mov    (%eax),%eax
 71a:	39 c2                	cmp    %eax,%edx
 71c:	75 24                	jne    742 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 71e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
 740:	eb 0a                	jmp    74c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 10                	mov    (%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	c1 e0 03             	shl    $0x3,%eax
 755:	03 45 fc             	add    -0x4(%ebp),%eax
 758:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75b:	75 20                	jne    77d <free+0xc5>
    p->s.size += bp->s.size;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 50 04             	mov    0x4(%eax),%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	01 c2                	add    %eax,%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 08                	jmp    785 <free+0xcd>
  } else
    p->s.ptr = bp;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 55 f8             	mov    -0x8(%ebp),%edx
 783:	89 10                	mov    %edx,(%eax)
  freep = p;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	a3 44 09 00 00       	mov    %eax,0x944
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <morecore>:

static Header*
morecore(uint nu)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 795:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79c:	77 07                	ja     7a5 <morecore+0x16>
    nu = 4096;
 79e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	c1 e0 03             	shl    $0x3,%eax
 7ab:	89 04 24             	mov    %eax,(%esp)
 7ae:	e8 51 fc ff ff       	call   404 <sbrk>
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7b6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7ba:	75 07                	jne    7c3 <morecore+0x34>
    return 0;
 7bc:	b8 00 00 00 00       	mov    $0x0,%eax
 7c1:	eb 22                	jmp    7e5 <morecore+0x56>
  hp = (Header*)p;
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 55 08             	mov    0x8(%ebp),%edx
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	83 c0 08             	add    $0x8,%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 d8 fe ff ff       	call   6b8 <free>
  return freep;
 7e0:	a1 44 09 00 00       	mov    0x944,%eax
}
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    

000007e7 <malloc>:

void*
malloc(uint nbytes)
{
 7e7:	55                   	push   %ebp
 7e8:	89 e5                	mov    %esp,%ebp
 7ea:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	83 c0 07             	add    $0x7,%eax
 7f3:	c1 e8 03             	shr    $0x3,%eax
 7f6:	83 c0 01             	add    $0x1,%eax
 7f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7fc:	a1 44 09 00 00       	mov    0x944,%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
 804:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 808:	75 23                	jne    82d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 80a:	c7 45 f0 3c 09 00 00 	movl   $0x93c,-0x10(%ebp)
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 44 09 00 00       	mov    %eax,0x944
 819:	a1 44 09 00 00       	mov    0x944,%eax
 81e:	a3 3c 09 00 00       	mov    %eax,0x93c
    base.s.size = 0;
 823:	c7 05 40 09 00 00 00 	movl   $0x0,0x940
 82a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 835:	8b 45 ec             	mov    -0x14(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 83e:	72 4d                	jb     88d <malloc+0xa6>
      if(p->s.size == nunits)
 840:	8b 45 ec             	mov    -0x14(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 849:	75 0c                	jne    857 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 84b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	89 10                	mov    %edx,(%eax)
 855:	eb 26                	jmp    87d <malloc+0x96>
      else {
        p->s.size -= nunits;
 857:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	89 c2                	mov    %eax,%edx
 85f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 862:	8b 45 ec             	mov    -0x14(%ebp),%eax
 865:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 868:	8b 45 ec             	mov    -0x14(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	c1 e0 03             	shl    $0x3,%eax
 871:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 874:	8b 45 ec             	mov    -0x14(%ebp),%eax
 877:	8b 55 f4             	mov    -0xc(%ebp),%edx
 87a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	a3 44 09 00 00       	mov    %eax,0x944
      return (void*)(p + 1);
 885:	8b 45 ec             	mov    -0x14(%ebp),%eax
 888:	83 c0 08             	add    $0x8,%eax
 88b:	eb 38                	jmp    8c5 <malloc+0xde>
    }
    if(p == freep)
 88d:	a1 44 09 00 00       	mov    0x944,%eax
 892:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 895:	75 1b                	jne    8b2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	89 04 24             	mov    %eax,(%esp)
 89d:	e8 ed fe ff ff       	call   78f <morecore>
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8a9:	75 07                	jne    8b2 <malloc+0xcb>
        return 0;
 8ab:	b8 00 00 00 00       	mov    $0x0,%eax
 8b0:	eb 13                	jmp    8c5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8bb:	8b 00                	mov    (%eax),%eax
 8bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c0:	e9 70 ff ff ff       	jmp    835 <malloc+0x4e>
}
 8c5:	c9                   	leave  
 8c6:	c3                   	ret    
