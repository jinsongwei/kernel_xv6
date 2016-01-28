
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 45                	jmp    58 <main+0x58>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 17 08 00 00       	mov    $0x817,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 19 08 00 00       	mov    $0x819,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	c1 e2 02             	shl    $0x2,%edx
  32:	03 55 0c             	add    0xc(%ebp),%edx
  35:	8b 12                	mov    (%edx),%edx
  37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  3f:	c7 44 24 04 1b 08 00 	movl   $0x81b,0x4(%esp)
  46:	00 
  47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4e:	e8 fd 03 00 00       	call   450 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  53:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c b2                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  61:	e8 66 02 00 00       	call   2cc <exit>
  66:	90                   	nop
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	88 10                	mov    %dl,(%eax)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	0f 95 c0             	setne  %al
  af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b7:	84 c0                	test   %al,%al
  b9:	75 de                	jne    99 <strcpy+0xc>
    ;
  return os;
  bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c3:	eb 08                	jmp    cd <strcmp+0xd>
    p++, q++;
  c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	74 10                	je     e7 <strcmp+0x27>
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 10             	movzbl (%eax),%edx
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	38 c2                	cmp    %al,%dl
  e5:	74 de                	je     c5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	0f b6 d0             	movzbl %al,%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 c0             	movzbl %al,%eax
  f9:	89 d1                	mov    %edx,%ecx
  fb:	29 c1                	sub    %eax,%ecx
  fd:	89 c8                	mov    %ecx,%eax
}
  ff:	5d                   	pop    %ebp
 100:	c3                   	ret    

00000101 <strlen>:

uint
strlen(char *s)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10e:	eb 04                	jmp    114 <strlen+0x13>
 110:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 114:	8b 45 fc             	mov    -0x4(%ebp),%eax
 117:	03 45 08             	add    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 ef                	jne    110 <strlen+0xf>
    ;
  return n;
 121:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <memset>:

void*
memset(void *dst, int c, uint n)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12c:	8b 45 10             	mov    0x10(%ebp),%eax
 12f:	89 44 24 08          	mov    %eax,0x8(%esp)
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	89 44 24 04          	mov    %eax,0x4(%esp)
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 04 24             	mov    %eax,(%esp)
 140:	e8 23 ff ff ff       	call   68 <stosb>
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 18a:	eb 44                	jmp    1d0 <gets+0x53>
    cc = read(0, &c, 1);
 18c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 193:	00 
 194:	8d 45 ef             	lea    -0x11(%ebp),%eax
 197:	89 44 24 04          	mov    %eax,0x4(%esp)
 19b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a2:	e8 3d 01 00 00       	call   2e4 <read>
 1a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ae:	7e 2d                	jle    1dd <gets+0x60>
      break;
    buf[i++] = c;
 1b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b3:	03 45 08             	add    0x8(%ebp),%eax
 1b6:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1ba:	88 10                	mov    %dl,(%eax)
 1bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c4:	3c 0a                	cmp    $0xa,%al
 1c6:	74 16                	je     1de <gets+0x61>
 1c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cc:	3c 0d                	cmp    $0xd,%al
 1ce:	74 0e                	je     1de <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d9:	7c b1                	jl     18c <gets+0xf>
 1db:	eb 01                	jmp    1de <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1dd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e1:	03 45 08             	add    0x8(%ebp),%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f9:	00 
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 07 01 00 00       	call   30c <open>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20c:	79 07                	jns    215 <stat+0x29>
    return -1;
 20e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 213:	eb 23                	jmp    238 <stat+0x4c>
  r = fstat(fd, st);
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	89 44 24 04          	mov    %eax,0x4(%esp)
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 fd 00 00 00       	call   324 <fstat>
 227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22d:	89 04 24             	mov    %eax,(%esp)
 230:	e8 bf 00 00 00       	call   2f4 <close>
  return r;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <atoi>:

int
atoi(const char *s)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 247:	eb 24                	jmp    26d <atoi+0x33>
    n = n*10 + *s++ - '0';
 249:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24c:	89 d0                	mov    %edx,%eax
 24e:	c1 e0 02             	shl    $0x2,%eax
 251:	01 d0                	add    %edx,%eax
 253:	01 c0                	add    %eax,%eax
 255:	89 c2                	mov    %eax,%edx
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	0f be c0             	movsbl %al,%eax
 260:	8d 04 02             	lea    (%edx,%eax,1),%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
 269:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x47>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c8                	jle    249 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 298:	eb 13                	jmp    2ad <memmove+0x27>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	0f b6 10             	movzbl (%eax),%edx
 2a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a3:	88 10                	mov    %dl,(%eax)
 2a5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b1:	0f 9f c0             	setg   %al
 2b4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b8:	84 c0                	test   %al,%al
 2ba:	75 de                	jne    29a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    
 2c1:	90                   	nop
 2c2:	90                   	nop
 2c3:	90                   	nop

000002c4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c4:	b8 01 00 00 00       	mov    $0x1,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <exit>:
SYSCALL(exit)
 2cc:	b8 02 00 00 00       	mov    $0x2,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <wait>:
SYSCALL(wait)
 2d4:	b8 03 00 00 00       	mov    $0x3,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <pipe>:
SYSCALL(pipe)
 2dc:	b8 04 00 00 00       	mov    $0x4,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <read>:
SYSCALL(read)
 2e4:	b8 05 00 00 00       	mov    $0x5,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <write>:
SYSCALL(write)
 2ec:	b8 10 00 00 00       	mov    $0x10,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <close>:
SYSCALL(close)
 2f4:	b8 15 00 00 00       	mov    $0x15,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <kill>:
SYSCALL(kill)
 2fc:	b8 06 00 00 00       	mov    $0x6,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <exec>:
SYSCALL(exec)
 304:	b8 07 00 00 00       	mov    $0x7,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <open>:
SYSCALL(open)
 30c:	b8 0f 00 00 00       	mov    $0xf,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <mknod>:
SYSCALL(mknod)
 314:	b8 11 00 00 00       	mov    $0x11,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <unlink>:
SYSCALL(unlink)
 31c:	b8 12 00 00 00       	mov    $0x12,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <fstat>:
SYSCALL(fstat)
 324:	b8 08 00 00 00       	mov    $0x8,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <link>:
SYSCALL(link)
 32c:	b8 13 00 00 00       	mov    $0x13,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <mkdir>:
SYSCALL(mkdir)
 334:	b8 14 00 00 00       	mov    $0x14,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <chdir>:
SYSCALL(chdir)
 33c:	b8 09 00 00 00       	mov    $0x9,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <dup>:
SYSCALL(dup)
 344:	b8 0a 00 00 00       	mov    $0xa,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <getpid>:
SYSCALL(getpid)
 34c:	b8 0b 00 00 00       	mov    $0xb,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sbrk>:
SYSCALL(sbrk)
 354:	b8 0c 00 00 00       	mov    $0xc,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <sleep>:
SYSCALL(sleep)
 35c:	b8 0d 00 00 00       	mov    $0xd,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <uptime>:
SYSCALL(uptime)
 364:	b8 0e 00 00 00       	mov    $0xe,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <count>:
//add
SYSCALL(count)
 36c:	b8 16 00 00 00       	mov    $0x16,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 28             	sub    $0x28,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 387:	00 
 388:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 52 ff ff ff       	call   2ec <write>
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	53                   	push   %ebx
 3a0:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ae:	74 17                	je     3c7 <printint+0x2b>
 3b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b4:	79 11                	jns    3c7 <printint+0x2b>
    neg = 1;
 3b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	f7 d8                	neg    %eax
 3c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c5:	eb 06                	jmp    3cd <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dd:	ba 00 00 00 00       	mov    $0x0,%edx
 3e2:	f7 f3                	div    %ebx
 3e4:	89 d0                	mov    %edx,%eax
 3e6:	0f b6 80 28 08 00 00 	movzbl 0x828(%eax),%eax
 3ed:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3f1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fe:	ba 00 00 00 00       	mov    $0x0,%edx
 403:	f7 75 d4             	divl   -0x2c(%ebp)
 406:	89 45 f4             	mov    %eax,-0xc(%ebp)
 409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40d:	75 c5                	jne    3d4 <printint+0x38>
  if(neg)
 40f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 413:	74 2a                	je     43f <printint+0xa3>
    buf[i++] = '-';
 415:	8b 45 ec             	mov    -0x14(%ebp),%eax
 418:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 41d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 421:	eb 1d                	jmp    440 <printint+0xa4>
    putc(fd, buf[i]);
 423:	8b 45 ec             	mov    -0x14(%ebp),%eax
 426:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 42b:	0f be c0             	movsbl %al,%eax
 42e:	89 44 24 04          	mov    %eax,0x4(%esp)
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	89 04 24             	mov    %eax,(%esp)
 438:	e8 37 ff ff ff       	call   374 <putc>
 43d:	eb 01                	jmp    440 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43f:	90                   	nop
 440:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 448:	79 d9                	jns    423 <printint+0x87>
    putc(fd, buf[i]);
}
 44a:	83 c4 44             	add    $0x44,%esp
 44d:	5b                   	pop    %ebx
 44e:	5d                   	pop    %ebp
 44f:	c3                   	ret    

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 456:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45d:	8d 45 0c             	lea    0xc(%ebp),%eax
 460:	83 c0 04             	add    $0x4,%eax
 463:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 466:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 46d:	e9 7e 01 00 00       	jmp    5f0 <printf+0x1a0>
    c = fmt[i] & 0xff;
 472:	8b 55 0c             	mov    0xc(%ebp),%edx
 475:	8b 45 ec             	mov    -0x14(%ebp),%eax
 478:	8d 04 02             	lea    (%edx,%eax,1),%eax
 47b:	0f b6 00             	movzbl (%eax),%eax
 47e:	0f be c0             	movsbl %al,%eax
 481:	25 ff 00 00 00       	and    $0xff,%eax
 486:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48d:	75 2c                	jne    4bb <printf+0x6b>
      if(c == '%'){
 48f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 493:	75 0c                	jne    4a1 <printf+0x51>
        state = '%';
 495:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 49c:	e9 4b 01 00 00       	jmp    5ec <printf+0x19c>
      } else {
        putc(fd, c);
 4a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	89 04 24             	mov    %eax,(%esp)
 4b1:	e8 be fe ff ff       	call   374 <putc>
 4b6:	e9 31 01 00 00       	jmp    5ec <printf+0x19c>
      }
    } else if(state == '%'){
 4bb:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4bf:	0f 85 27 01 00 00    	jne    5ec <printf+0x19c>
      if(c == 'd'){
 4c5:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4c9:	75 2d                	jne    4f8 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d7:	00 
 4d8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4df:	00 
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 ad fe ff ff       	call   39c <printint>
        ap++;
 4ef:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4f3:	e9 ed 00 00 00       	jmp    5e5 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4f8:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4fc:	74 06                	je     504 <printf+0xb4>
 4fe:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 502:	75 2d                	jne    531 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 510:	00 
 511:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 74 fe ff ff       	call   39c <printint>
        ap++;
 528:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 52c:	e9 b4 00 00 00       	jmp    5e5 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 531:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 535:	75 46                	jne    57d <printf+0x12d>
        s = (char*)*ap;
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 53f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 543:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 547:	75 27                	jne    570 <printf+0x120>
          s = "(null)";
 549:	c7 45 e4 20 08 00 00 	movl   $0x820,-0x1c(%ebp)
        while(*s != 0){
 550:	eb 1f                	jmp    571 <printf+0x121>
          putc(fd, *s);
 552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 0a fe ff ff       	call   374 <putc>
          s++;
 56a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 56e:	eb 01                	jmp    571 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 570:	90                   	nop
 571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	84 c0                	test   %al,%al
 579:	75 d7                	jne    552 <printf+0x102>
 57b:	eb 68                	jmp    5e5 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57d:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 581:	75 1d                	jne    5a0 <printf+0x150>
        putc(fd, *ap);
 583:	8b 45 f4             	mov    -0xc(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	0f be c0             	movsbl %al,%eax
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 da fd ff ff       	call   374 <putc>
        ap++;
 59a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 59e:	eb 45                	jmp    5e5 <printf+0x195>
      } else if(c == '%'){
 5a0:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5a4:	75 17                	jne    5bd <printf+0x16d>
        putc(fd, c);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 b9 fd ff ff       	call   374 <putc>
 5bb:	eb 28                	jmp    5e5 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c4:	00 
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 a4 fd ff ff       	call   374 <putc>
        putc(fd, c);
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 8f fd ff ff       	call   374 <putc>
      }
      state = 0;
 5e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ec:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f6:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	84 c0                	test   %al,%al
 5fe:	0f 85 6e fe ff ff    	jne    472 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 604:	c9                   	leave  
 605:	c3                   	ret    
 606:	90                   	nop
 607:	90                   	nop

00000608 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	83 e8 08             	sub    $0x8,%eax
 614:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 617:	a1 44 08 00 00       	mov    0x844,%eax
 61c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61f:	eb 24                	jmp    645 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 629:	77 12                	ja     63d <free+0x35>
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	77 24                	ja     657 <free+0x4f>
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63b:	77 1a                	ja     657 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	89 45 fc             	mov    %eax,-0x4(%ebp)
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64b:	76 d4                	jbe    621 <free+0x19>
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 655:	76 ca                	jbe    621 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	c1 e0 03             	shl    $0x3,%eax
 660:	89 c2                	mov    %eax,%edx
 662:	03 55 f8             	add    -0x8(%ebp),%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	c1 e0 03             	shl    $0x3,%eax
 6a5:	03 45 fc             	add    -0x4(%ebp),%eax
 6a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ab:	75 20                	jne    6cd <free+0xc5>
    p->s.size += bp->s.size;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 50 04             	mov    0x4(%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	01 c2                	add    %eax,%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 10                	mov    (%eax),%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	89 10                	mov    %edx,(%eax)
 6cb:	eb 08                	jmp    6d5 <free+0xcd>
  } else
    p->s.ptr = bp;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	a3 44 08 00 00       	mov    %eax,0x844
}
 6dd:	c9                   	leave  
 6de:	c3                   	ret    

000006df <morecore>:

static Header*
morecore(uint nu)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ec:	77 07                	ja     6f5 <morecore+0x16>
    nu = 4096;
 6ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	c1 e0 03             	shl    $0x3,%eax
 6fb:	89 04 24             	mov    %eax,(%esp)
 6fe:	e8 51 fc ff ff       	call   354 <sbrk>
 703:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 706:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 70a:	75 07                	jne    713 <morecore+0x34>
    return 0;
 70c:	b8 00 00 00 00       	mov    $0x0,%eax
 711:	eb 22                	jmp    735 <morecore+0x56>
  hp = (Header*)p;
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	8b 55 08             	mov    0x8(%ebp),%edx
 71f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	83 c0 08             	add    $0x8,%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 d8 fe ff ff       	call   608 <free>
  return freep;
 730:	a1 44 08 00 00       	mov    0x844,%eax
}
 735:	c9                   	leave  
 736:	c3                   	ret    

00000737 <malloc>:

void*
malloc(uint nbytes)
{
 737:	55                   	push   %ebp
 738:	89 e5                	mov    %esp,%ebp
 73a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	83 c0 07             	add    $0x7,%eax
 743:	c1 e8 03             	shr    $0x3,%eax
 746:	83 c0 01             	add    $0x1,%eax
 749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 74c:	a1 44 08 00 00       	mov    0x844,%eax
 751:	89 45 f0             	mov    %eax,-0x10(%ebp)
 754:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 758:	75 23                	jne    77d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 75a:	c7 45 f0 3c 08 00 00 	movl   $0x83c,-0x10(%ebp)
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	a3 44 08 00 00       	mov    %eax,0x844
 769:	a1 44 08 00 00       	mov    0x844,%eax
 76e:	a3 3c 08 00 00       	mov    %eax,0x83c
    base.s.size = 0;
 773:	c7 05 40 08 00 00 00 	movl   $0x0,0x840
 77a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 785:	8b 45 ec             	mov    -0x14(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 78e:	72 4d                	jb     7dd <malloc+0xa6>
      if(p->s.size == nunits)
 790:	8b 45 ec             	mov    -0x14(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 799:	75 0c                	jne    7a7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 79b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79e:	8b 10                	mov    (%eax),%edx
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	89 10                	mov    %edx,(%eax)
 7a5:	eb 26                	jmp    7cd <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	89 c2                	mov    %eax,%edx
 7af:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	c1 e0 03             	shl    $0x3,%eax
 7c1:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7ca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	a3 44 08 00 00       	mov    %eax,0x844
      return (void*)(p + 1);
 7d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d8:	83 c0 08             	add    $0x8,%eax
 7db:	eb 38                	jmp    815 <malloc+0xde>
    }
    if(p == freep)
 7dd:	a1 44 08 00 00       	mov    0x844,%eax
 7e2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7e5:	75 1b                	jne    802 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 04 24             	mov    %eax,(%esp)
 7ed:	e8 ed fe ff ff       	call   6df <morecore>
 7f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7f9:	75 07                	jne    802 <malloc+0xcb>
        return 0;
 7fb:	b8 00 00 00 00       	mov    $0x0,%eax
 800:	eb 13                	jmp    815 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	8b 45 ec             	mov    -0x14(%ebp),%eax
 805:	89 45 f0             	mov    %eax,-0x10(%ebp)
 808:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80b:	8b 00                	mov    (%eax),%eax
 80d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 810:	e9 70 ff ff ff       	jmp    785 <malloc+0x4e>
}
 815:	c9                   	leave  
 816:	c3                   	ret    
