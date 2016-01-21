
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 72 02 00 00       	call   280 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 fa 02 00 00       	call   318 <sleep>
  exit();
  1e:	e8 65 02 00 00       	call   288 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	8b 45 0c             	mov    0xc(%ebp),%eax
  58:	0f b6 10             	movzbl (%eax),%edx
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	88 10                	mov    %dl,(%eax)
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	84 c0                	test   %al,%al
  68:	0f 95 c0             	setne  %al
  6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  73:	84 c0                	test   %al,%al
  75:	75 de                	jne    55 <strcpy+0xc>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	89 d1                	mov    %edx,%ecx
  b7:	29 c1                	sub    %eax,%ecx
  b9:	89 c8                	mov    %ecx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d3:	03 45 08             	add    0x8(%ebp),%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 ef                	jne    cc <strlen+0xf>
    ;
  return n;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  e5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e8:	8b 45 10             	mov    0x10(%ebp),%eax
  eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	89 04 24             	mov    %eax,(%esp)
  fc:	e8 23 ff ff ff       	call   24 <stosb>
  return dst;
 101:	8b 45 08             	mov    0x8(%ebp),%eax
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 112:	eb 14                	jmp    128 <strchr+0x22>
    if(*s == c)
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 11d:	75 05                	jne    124 <strchr+0x1e>
      return (char*)s;
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	eb 13                	jmp    137 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	84 c0                	test   %al,%al
 130:	75 e2                	jne    114 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 132:	b8 00 00 00 00       	mov    $0x0,%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <gets>:

char*
gets(char *buf, int max)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 146:	eb 44                	jmp    18c <gets+0x53>
    cc = read(0, &c, 1);
 148:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14f:	00 
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	89 44 24 04          	mov    %eax,0x4(%esp)
 157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15e:	e8 3d 01 00 00       	call   2a0 <read>
 163:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 16a:	7e 2d                	jle    199 <gets+0x60>
      break;
    buf[i++] = c;
 16c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 16f:	03 45 08             	add    0x8(%ebp),%eax
 172:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 176:	88 10                	mov    %dl,(%eax)
 178:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 17c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 16                	je     19a <gets+0x61>
 184:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0e                	je     19a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 18f:	83 c0 01             	add    $0x1,%eax
 192:	3b 45 0c             	cmp    0xc(%ebp),%eax
 195:	7c b1                	jl     148 <gets+0xf>
 197:	eb 01                	jmp    19a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 199:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 19d:	03 45 08             	add    0x8(%ebp),%eax
 1a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <stat>:

int
stat(char *n, struct stat *st)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b5:	00 
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	89 04 24             	mov    %eax,(%esp)
 1bc:	e8 07 01 00 00       	call   2c8 <open>
 1c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 1c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x29>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 23                	jmp    1f4 <stat+0x4c>
  r = fstat(fd, st);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 fd 00 00 00       	call   2e0 <fstat>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 bf 00 00 00       	call   2b0 <close>
  return r;
 1f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 203:	eb 24                	jmp    229 <atoi+0x33>
    n = n*10 + *s++ - '0';
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	89 d0                	mov    %edx,%eax
 20a:	c1 e0 02             	shl    $0x2,%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	01 c0                	add    %eax,%eax
 211:	89 c2                	mov    %eax,%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 00             	movzbl (%eax),%eax
 219:	0f be c0             	movsbl %al,%eax
 21c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
 225:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 2f                	cmp    $0x2f,%al
 231:	7e 0a                	jle    23d <atoi+0x47>
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	3c 39                	cmp    $0x39,%al
 23b:	7e c8                	jle    205 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 23d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 24e:	8b 45 0c             	mov    0xc(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 254:	eb 13                	jmp    269 <memmove+0x27>
    *dst++ = *src++;
 256:	8b 45 fc             	mov    -0x4(%ebp),%eax
 259:	0f b6 10             	movzbl (%eax),%edx
 25c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 25f:	88 10                	mov    %dl,(%eax)
 261:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 265:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 26d:	0f 9f c0             	setg   %al
 270:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 274:	84 c0                	test   %al,%al
 276:	75 de                	jne    256 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    
 27d:	90                   	nop
 27e:	90                   	nop
 27f:	90                   	nop

00000280 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 280:	b8 01 00 00 00       	mov    $0x1,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <exit>:
SYSCALL(exit)
 288:	b8 02 00 00 00       	mov    $0x2,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <wait>:
SYSCALL(wait)
 290:	b8 03 00 00 00       	mov    $0x3,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <pipe>:
SYSCALL(pipe)
 298:	b8 04 00 00 00       	mov    $0x4,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <read>:
SYSCALL(read)
 2a0:	b8 05 00 00 00       	mov    $0x5,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <write>:
SYSCALL(write)
 2a8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <close>:
SYSCALL(close)
 2b0:	b8 15 00 00 00       	mov    $0x15,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <kill>:
SYSCALL(kill)
 2b8:	b8 06 00 00 00       	mov    $0x6,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exec>:
SYSCALL(exec)
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <open>:
SYSCALL(open)
 2c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <mknod>:
SYSCALL(mknod)
 2d0:	b8 11 00 00 00       	mov    $0x11,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <unlink>:
SYSCALL(unlink)
 2d8:	b8 12 00 00 00       	mov    $0x12,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <fstat>:
SYSCALL(fstat)
 2e0:	b8 08 00 00 00       	mov    $0x8,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <link>:
SYSCALL(link)
 2e8:	b8 13 00 00 00       	mov    $0x13,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <mkdir>:
SYSCALL(mkdir)
 2f0:	b8 14 00 00 00       	mov    $0x14,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <chdir>:
SYSCALL(chdir)
 2f8:	b8 09 00 00 00       	mov    $0x9,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <dup>:
SYSCALL(dup)
 300:	b8 0a 00 00 00       	mov    $0xa,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <getpid>:
SYSCALL(getpid)
 308:	b8 0b 00 00 00       	mov    $0xb,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <sbrk>:
SYSCALL(sbrk)
 310:	b8 0c 00 00 00       	mov    $0xc,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sleep>:
SYSCALL(sleep)
 318:	b8 0d 00 00 00       	mov    $0xd,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <uptime>:
SYSCALL(uptime)
 320:	b8 0e 00 00 00       	mov    $0xe,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 28             	sub    $0x28,%esp
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 334:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33b:	00 
 33c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 33f:	89 44 24 04          	mov    %eax,0x4(%esp)
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 04 24             	mov    %eax,(%esp)
 349:	e8 5a ff ff ff       	call   2a8 <write>
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 357:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 35e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 362:	74 17                	je     37b <printint+0x2b>
 364:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 368:	79 11                	jns    37b <printint+0x2b>
    neg = 1;
 36a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	f7 d8                	neg    %eax
 376:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 379:	eb 06                	jmp    381 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 388:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 38b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 38e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 391:	ba 00 00 00 00       	mov    $0x0,%edx
 396:	f7 f3                	div    %ebx
 398:	89 d0                	mov    %edx,%eax
 39a:	0f b6 80 d4 07 00 00 	movzbl 0x7d4(%eax),%eax
 3a1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3a5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3a9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b2:	ba 00 00 00 00       	mov    $0x0,%edx
 3b7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c1:	75 c5                	jne    388 <printint+0x38>
  if(neg)
 3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c7:	74 2a                	je     3f3 <printint+0xa3>
    buf[i++] = '-';
 3c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 3d1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 3d5:	eb 1d                	jmp    3f4 <printint+0xa4>
    putc(fd, buf[i]);
 3d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3da:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 3df:	0f be c0             	movsbl %al,%eax
 3e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	89 04 24             	mov    %eax,(%esp)
 3ec:	e8 37 ff ff ff       	call   328 <putc>
 3f1:	eb 01                	jmp    3f4 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f3:	90                   	nop
 3f4:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 3f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fc:	79 d9                	jns    3d7 <printint+0x87>
    putc(fd, buf[i]);
}
 3fe:	83 c4 44             	add    $0x44,%esp
 401:	5b                   	pop    %ebx
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    

00000404 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 411:	8d 45 0c             	lea    0xc(%ebp),%eax
 414:	83 c0 04             	add    $0x4,%eax
 417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 41a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 421:	e9 7e 01 00 00       	jmp    5a4 <printf+0x1a0>
    c = fmt[i] & 0xff;
 426:	8b 55 0c             	mov    0xc(%ebp),%edx
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 42f:	0f b6 00             	movzbl (%eax),%eax
 432:	0f be c0             	movsbl %al,%eax
 435:	25 ff 00 00 00       	and    $0xff,%eax
 43a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 43d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 441:	75 2c                	jne    46f <printf+0x6b>
      if(c == '%'){
 443:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 447:	75 0c                	jne    455 <printf+0x51>
        state = '%';
 449:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 450:	e9 4b 01 00 00       	jmp    5a0 <printf+0x19c>
      } else {
        putc(fd, c);
 455:	8b 45 e8             	mov    -0x18(%ebp),%eax
 458:	0f be c0             	movsbl %al,%eax
 45b:	89 44 24 04          	mov    %eax,0x4(%esp)
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	89 04 24             	mov    %eax,(%esp)
 465:	e8 be fe ff ff       	call   328 <putc>
 46a:	e9 31 01 00 00       	jmp    5a0 <printf+0x19c>
      }
    } else if(state == '%'){
 46f:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 473:	0f 85 27 01 00 00    	jne    5a0 <printf+0x19c>
      if(c == 'd'){
 479:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 47d:	75 2d                	jne    4ac <printf+0xa8>
        printint(fd, *ap, 10, 1);
 47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 482:	8b 00                	mov    (%eax),%eax
 484:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 48b:	00 
 48c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 493:	00 
 494:	89 44 24 04          	mov    %eax,0x4(%esp)
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	89 04 24             	mov    %eax,(%esp)
 49e:	e8 ad fe ff ff       	call   350 <printint>
        ap++;
 4a3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4a7:	e9 ed 00 00 00       	jmp    599 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4ac:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4b0:	74 06                	je     4b8 <printf+0xb4>
 4b2:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4b6:	75 2d                	jne    4e5 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8b 00                	mov    (%eax),%eax
 4bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c4:	00 
 4c5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4cc:	00 
 4cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	89 04 24             	mov    %eax,(%esp)
 4d7:	e8 74 fe ff ff       	call   350 <printint>
        ap++;
 4dc:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e0:	e9 b4 00 00 00       	jmp    599 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4e5:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 4e9:	75 46                	jne    531 <printf+0x12d>
        s = (char*)*ap;
 4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ee:	8b 00                	mov    (%eax),%eax
 4f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 4f3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 4f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 4fb:	75 27                	jne    524 <printf+0x120>
          s = "(null)";
 4fd:	c7 45 e4 cb 07 00 00 	movl   $0x7cb,-0x1c(%ebp)
        while(*s != 0){
 504:	eb 1f                	jmp    525 <printf+0x121>
          putc(fd, *s);
 506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	89 44 24 04          	mov    %eax,0x4(%esp)
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	89 04 24             	mov    %eax,(%esp)
 519:	e8 0a fe ff ff       	call   328 <putc>
          s++;
 51e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 522:	eb 01                	jmp    525 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 524:	90                   	nop
 525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	84 c0                	test   %al,%al
 52d:	75 d7                	jne    506 <printf+0x102>
 52f:	eb 68                	jmp    599 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 531:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 535:	75 1d                	jne    554 <printf+0x150>
        putc(fd, *ap);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	0f be c0             	movsbl %al,%eax
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 da fd ff ff       	call   328 <putc>
        ap++;
 54e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 552:	eb 45                	jmp    599 <printf+0x195>
      } else if(c == '%'){
 554:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 558:	75 17                	jne    571 <printf+0x16d>
        putc(fd, c);
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	89 44 24 04          	mov    %eax,0x4(%esp)
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 04 24             	mov    %eax,(%esp)
 56a:	e8 b9 fd ff ff       	call   328 <putc>
 56f:	eb 28                	jmp    599 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 571:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 578:	00 
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 a4 fd ff ff       	call   328 <putc>
        putc(fd, c);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 8f fd ff ff       	call   328 <putc>
      }
      state = 0;
 599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5aa:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	84 c0                	test   %al,%al
 5b2:	0f 85 6e fe ff ff    	jne    426 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    
 5ba:	90                   	nop
 5bb:	90                   	nop

000005bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bc:	55                   	push   %ebp
 5bd:	89 e5                	mov    %esp,%ebp
 5bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	83 e8 08             	sub    $0x8,%eax
 5c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cb:	a1 f0 07 00 00       	mov    0x7f0,%eax
 5d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d3:	eb 24                	jmp    5f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dd:	77 12                	ja     5f1 <free+0x35>
 5df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e5:	77 24                	ja     60b <free+0x4f>
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ef:	77 1a                	ja     60b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ff:	76 d4                	jbe    5d5 <free+0x19>
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 609:	76 ca                	jbe    5d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	8b 40 04             	mov    0x4(%eax),%eax
 611:	c1 e0 03             	shl    $0x3,%eax
 614:	89 c2                	mov    %eax,%edx
 616:	03 55 f8             	add    -0x8(%ebp),%edx
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	39 c2                	cmp    %eax,%edx
 620:	75 24                	jne    646 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 622:	8b 45 f8             	mov    -0x8(%ebp),%eax
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	8b 40 04             	mov    0x4(%eax),%eax
 630:	01 c2                	add    %eax,%edx
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	8b 10                	mov    (%eax),%edx
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	89 10                	mov    %edx,(%eax)
 644:	eb 0a                	jmp    650 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 10                	mov    (%eax),%edx
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 40 04             	mov    0x4(%eax),%eax
 656:	c1 e0 03             	shl    $0x3,%eax
 659:	03 45 fc             	add    -0x4(%ebp),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	75 20                	jne    681 <free+0xc5>
    p->s.size += bp->s.size;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 08                	jmp    689 <free+0xcd>
  } else
    p->s.ptr = bp;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 55 f8             	mov    -0x8(%ebp),%edx
 687:	89 10                	mov    %edx,(%eax)
  freep = p;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	a3 f0 07 00 00       	mov    %eax,0x7f0
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <morecore>:

static Header*
morecore(uint nu)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 699:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a0:	77 07                	ja     6a9 <morecore+0x16>
    nu = 4096;
 6a2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	c1 e0 03             	shl    $0x3,%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 59 fc ff ff       	call   310 <sbrk>
 6b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 6ba:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6be:	75 07                	jne    6c7 <morecore+0x34>
    return 0;
 6c0:	b8 00 00 00 00       	mov    $0x0,%eax
 6c5:	eb 22                	jmp    6e9 <morecore+0x56>
  hp = (Header*)p;
 6c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d0:	8b 55 08             	mov    0x8(%ebp),%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d9:	83 c0 08             	add    $0x8,%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 d8 fe ff ff       	call   5bc <free>
  return freep;
 6e4:	a1 f0 07 00 00       	mov    0x7f0,%eax
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <malloc>:

void*
malloc(uint nbytes)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	83 c0 07             	add    $0x7,%eax
 6f7:	c1 e8 03             	shr    $0x3,%eax
 6fa:	83 c0 01             	add    $0x1,%eax
 6fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 700:	a1 f0 07 00 00       	mov    0x7f0,%eax
 705:	89 45 f0             	mov    %eax,-0x10(%ebp)
 708:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70c:	75 23                	jne    731 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 70e:	c7 45 f0 e8 07 00 00 	movl   $0x7e8,-0x10(%ebp)
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	a3 f0 07 00 00       	mov    %eax,0x7f0
 71d:	a1 f0 07 00 00       	mov    0x7f0,%eax
 722:	a3 e8 07 00 00       	mov    %eax,0x7e8
    base.s.size = 0;
 727:	c7 05 ec 07 00 00 00 	movl   $0x0,0x7ec
 72e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 739:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73c:	8b 40 04             	mov    0x4(%eax),%eax
 73f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 742:	72 4d                	jb     791 <malloc+0xa6>
      if(p->s.size == nunits)
 744:	8b 45 ec             	mov    -0x14(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 74d:	75 0c                	jne    75b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 74f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 752:	8b 10                	mov    (%eax),%edx
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	89 10                	mov    %edx,(%eax)
 759:	eb 26                	jmp    781 <malloc+0x96>
      else {
        p->s.size -= nunits;
 75b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	89 c2                	mov    %eax,%edx
 763:	2b 55 f4             	sub    -0xc(%ebp),%edx
 766:	8b 45 ec             	mov    -0x14(%ebp),%eax
 769:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	c1 e0 03             	shl    $0x3,%eax
 775:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 778:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 77e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	a3 f0 07 00 00       	mov    %eax,0x7f0
      return (void*)(p + 1);
 789:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78c:	83 c0 08             	add    $0x8,%eax
 78f:	eb 38                	jmp    7c9 <malloc+0xde>
    }
    if(p == freep)
 791:	a1 f0 07 00 00       	mov    0x7f0,%eax
 796:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 799:	75 1b                	jne    7b6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 04 24             	mov    %eax,(%esp)
 7a1:	e8 ed fe ff ff       	call   693 <morecore>
 7a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ad:	75 07                	jne    7b6 <malloc+0xcb>
        return 0;
 7af:	b8 00 00 00 00       	mov    $0x0,%eax
 7b4:	eb 13                	jmp    7c9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c4:	e9 70 ff ff ff       	jmp    739 <malloc+0x4e>
}
 7c9:	c9                   	leave  
 7ca:	c3                   	ret    
