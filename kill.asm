
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 0b 08 00 	movl   $0x80b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 21 04 00 00       	call   444 <printf>
    exit();
  23:	e8 a0 02 00 00       	call   2c8 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 21                	jmp    53 <main+0x53>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 f0 01 00 00       	call   236 <atoi>
  46:	89 04 24             	mov    %eax,(%esp)
  49:	e8 aa 02 00 00       	call   2f8 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  53:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  57:	3b 45 08             	cmp    0x8(%ebp),%eax
  5a:	7c d6                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  5c:	e8 67 02 00 00       	call   2c8 <exit>
  61:	90                   	nop
  62:	90                   	nop
  63:	90                   	nop

00000064 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	57                   	push   %edi
  68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	8b 55 10             	mov    0x10(%ebp),%edx
  6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  72:	89 cb                	mov    %ecx,%ebx
  74:	89 df                	mov    %ebx,%edi
  76:	89 d1                	mov    %edx,%ecx
  78:	fc                   	cld    
  79:	f3 aa                	rep stos %al,%es:(%edi)
  7b:	89 ca                	mov    %ecx,%edx
  7d:	89 fb                	mov    %edi,%ebx
  7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  85:	5b                   	pop    %ebx
  86:	5f                   	pop    %edi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  8c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	88 10                	mov    %dl,(%eax)
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	84 c0                	test   %al,%al
  a8:	0f 95 c0             	setne  %al
  ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  b3:	84 c0                	test   %al,%al
  b5:	75 de                	jne    95 <strcpy+0xc>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	89 d1                	mov    %edx,%ecx
  f7:	29 c1                	sub    %eax,%ecx
  f9:	89 c8                	mov    %ecx,%eax
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    

000000fd <strlen>:

uint
strlen(char *s)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 103:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10a:	eb 04                	jmp    110 <strlen+0x13>
 10c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 110:	8b 45 fc             	mov    -0x4(%ebp),%eax
 113:	03 45 08             	add    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ef                	jne    10c <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 23 ff ff ff       	call   64 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 186:	eb 44                	jmp    1cc <gets+0x53>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 3d 01 00 00       	call   2e0 <read>
 1a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1aa:	7e 2d                	jle    1d9 <gets+0x60>
      break;
    buf[i++] = c;
 1ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1af:	03 45 08             	add    0x8(%ebp),%eax
 1b2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1b6:	88 10                	mov    %dl,(%eax)
 1b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x61>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b1                	jl     188 <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1dd:	03 45 08             	add    0x8(%ebp),%eax
 1e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    

000001e8 <stat>:

int
stat(char *n, struct stat *st)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f5:	00 
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	89 04 24             	mov    %eax,(%esp)
 1fc:	e8 07 01 00 00       	call   308 <open>
 201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 208:	79 07                	jns    211 <stat+0x29>
    return -1;
 20a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20f:	eb 23                	jmp    234 <stat+0x4c>
  r = fstat(fd, st);
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	89 44 24 04          	mov    %eax,0x4(%esp)
 218:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	e8 fd 00 00 00       	call   320 <fstat>
 223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
 229:	89 04 24             	mov    %eax,(%esp)
 22c:	e8 bf 00 00 00       	call   2f0 <close>
  return r;
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <atoi>:

int
atoi(const char *s)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 243:	eb 24                	jmp    269 <atoi+0x33>
    n = n*10 + *s++ - '0';
 245:	8b 55 fc             	mov    -0x4(%ebp),%edx
 248:	89 d0                	mov    %edx,%eax
 24a:	c1 e0 02             	shl    $0x2,%eax
 24d:	01 d0                	add    %edx,%eax
 24f:	01 c0                	add    %eax,%eax
 251:	89 c2                	mov    %eax,%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	0f be c0             	movsbl %al,%eax
 25c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 25f:	83 e8 30             	sub    $0x30,%eax
 262:	89 45 fc             	mov    %eax,-0x4(%ebp)
 265:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	3c 2f                	cmp    $0x2f,%al
 271:	7e 0a                	jle    27d <atoi+0x47>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e c8                	jle    245 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 294:	eb 13                	jmp    2a9 <memmove+0x27>
    *dst++ = *src++;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
 299:	0f b6 10             	movzbl (%eax),%edx
 29c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29f:	88 10                	mov    %dl,(%eax)
 2a1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ad:	0f 9f c0             	setg   %al
 2b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2b4:	84 c0                	test   %al,%al
 2b6:	75 de                	jne    296 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    
 2bd:	90                   	nop
 2be:	90                   	nop
 2bf:	90                   	nop

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 28             	sub    $0x28,%esp
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 374:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 37b:	00 
 37c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37f:	89 44 24 04          	mov    %eax,0x4(%esp)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 04 24             	mov    %eax,(%esp)
 389:	e8 5a ff ff ff       	call   2e8 <write>
}
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 397:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 39e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a2:	74 17                	je     3bb <printint+0x2b>
 3a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a8:	79 11                	jns    3bb <printint+0x2b>
    neg = 1;
 3aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	f7 d8                	neg    %eax
 3b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b9:	eb 06                	jmp    3c1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d1:	ba 00 00 00 00       	mov    $0x0,%edx
 3d6:	f7 f3                	div    %ebx
 3d8:	89 d0                	mov    %edx,%eax
 3da:	0f b6 80 28 08 00 00 	movzbl 0x828(%eax),%eax
 3e1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 3e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 3e9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f2:	ba 00 00 00 00       	mov    $0x0,%edx
 3f7:	f7 75 d4             	divl   -0x2c(%ebp)
 3fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 401:	75 c5                	jne    3c8 <printint+0x38>
  if(neg)
 403:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 407:	74 2a                	je     433 <printint+0xa3>
    buf[i++] = '-';
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 411:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 415:	eb 1d                	jmp    434 <printint+0xa4>
    putc(fd, buf[i]);
 417:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 37 ff ff ff       	call   368 <putc>
 431:	eb 01                	jmp    434 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 433:	90                   	nop
 434:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 438:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43c:	79 d9                	jns    417 <printint+0x87>
    putc(fd, buf[i]);
}
 43e:	83 c4 44             	add    $0x44,%esp
 441:	5b                   	pop    %ebx
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    

00000444 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 451:	8d 45 0c             	lea    0xc(%ebp),%eax
 454:	83 c0 04             	add    $0x4,%eax
 457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 45a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 461:	e9 7e 01 00 00       	jmp    5e4 <printf+0x1a0>
    c = fmt[i] & 0xff;
 466:	8b 55 0c             	mov    0xc(%ebp),%edx
 469:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	25 ff 00 00 00       	and    $0xff,%eax
 47a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 47d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 481:	75 2c                	jne    4af <printf+0x6b>
      if(c == '%'){
 483:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 487:	75 0c                	jne    495 <printf+0x51>
        state = '%';
 489:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 490:	e9 4b 01 00 00       	jmp    5e0 <printf+0x19c>
      } else {
        putc(fd, c);
 495:	8b 45 e8             	mov    -0x18(%ebp),%eax
 498:	0f be c0             	movsbl %al,%eax
 49b:	89 44 24 04          	mov    %eax,0x4(%esp)
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	89 04 24             	mov    %eax,(%esp)
 4a5:	e8 be fe ff ff       	call   368 <putc>
 4aa:	e9 31 01 00 00       	jmp    5e0 <printf+0x19c>
      }
    } else if(state == '%'){
 4af:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4b3:	0f 85 27 01 00 00    	jne    5e0 <printf+0x19c>
      if(c == 'd'){
 4b9:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4bd:	75 2d                	jne    4ec <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c2:	8b 00                	mov    (%eax),%eax
 4c4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cb:	00 
 4cc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d3:	00 
 4d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	89 04 24             	mov    %eax,(%esp)
 4de:	e8 ad fe ff ff       	call   390 <printint>
        ap++;
 4e3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 4e7:	e9 ed 00 00 00       	jmp    5d9 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 4ec:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 4f0:	74 06                	je     4f8 <printf+0xb4>
 4f2:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 4f6:	75 2d                	jne    525 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	8b 00                	mov    (%eax),%eax
 4fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 504:	00 
 505:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50c:	00 
 50d:	89 44 24 04          	mov    %eax,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 04 24             	mov    %eax,(%esp)
 517:	e8 74 fe ff ff       	call   390 <printint>
        ap++;
 51c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 520:	e9 b4 00 00 00       	jmp    5d9 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 525:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 529:	75 46                	jne    571 <printf+0x12d>
        s = (char*)*ap;
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 533:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 53b:	75 27                	jne    564 <printf+0x120>
          s = "(null)";
 53d:	c7 45 e4 1f 08 00 00 	movl   $0x81f,-0x1c(%ebp)
        while(*s != 0){
 544:	eb 1f                	jmp    565 <printf+0x121>
          putc(fd, *s);
 546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 0a fe ff ff       	call   368 <putc>
          s++;
 55e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 562:	eb 01                	jmp    565 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 564:	90                   	nop
 565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	84 c0                	test   %al,%al
 56d:	75 d7                	jne    546 <printf+0x102>
 56f:	eb 68                	jmp    5d9 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 571:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 575:	75 1d                	jne    594 <printf+0x150>
        putc(fd, *ap);
 577:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	89 44 24 04          	mov    %eax,0x4(%esp)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 da fd ff ff       	call   368 <putc>
        ap++;
 58e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 592:	eb 45                	jmp    5d9 <printf+0x195>
      } else if(c == '%'){
 594:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 598:	75 17                	jne    5b1 <printf+0x16d>
        putc(fd, c);
 59a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 b9 fd ff ff       	call   368 <putc>
 5af:	eb 28                	jmp    5d9 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b8:	00 
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 a4 fd ff ff       	call   368 <putc>
        putc(fd, c);
 5c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 8f fd ff ff       	call   368 <putc>
      }
      state = 0;
 5d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 5e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ea:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	84 c0                	test   %al,%al
 5f2:	0f 85 6e fe ff ff    	jne    466 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f8:	c9                   	leave  
 5f9:	c3                   	ret    
 5fa:	90                   	nop
 5fb:	90                   	nop

000005fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	83 e8 08             	sub    $0x8,%eax
 608:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60b:	a1 44 08 00 00       	mov    0x844,%eax
 610:	89 45 fc             	mov    %eax,-0x4(%ebp)
 613:	eb 24                	jmp    639 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61d:	77 12                	ja     631 <free+0x35>
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 24                	ja     64b <free+0x4f>
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62f:	77 1a                	ja     64b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	89 45 fc             	mov    %eax,-0x4(%ebp)
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63f:	76 d4                	jbe    615 <free+0x19>
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 649:	76 ca                	jbe    615 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	8b 40 04             	mov    0x4(%eax),%eax
 651:	c1 e0 03             	shl    $0x3,%eax
 654:	89 c2                	mov    %eax,%edx
 656:	03 55 f8             	add    -0x8(%ebp),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	39 c2                	cmp    %eax,%edx
 660:	75 24                	jne    686 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 40 04             	mov    0x4(%eax),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 10                	mov    %edx,(%eax)
 684:	eb 0a                	jmp    690 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	c1 e0 03             	shl    $0x3,%eax
 699:	03 45 fc             	add    -0x4(%ebp),%eax
 69c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69f:	75 20                	jne    6c1 <free+0xc5>
    p->s.size += bp->s.size;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	01 c2                	add    %eax,%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	89 10                	mov    %edx,(%eax)
 6bf:	eb 08                	jmp    6c9 <free+0xcd>
  } else
    p->s.ptr = bp;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	a3 44 08 00 00       	mov    %eax,0x844
}
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <morecore>:

static Header*
morecore(uint nu)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e0:	77 07                	ja     6e9 <morecore+0x16>
    nu = 4096;
 6e2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	c1 e0 03             	shl    $0x3,%eax
 6ef:	89 04 24             	mov    %eax,(%esp)
 6f2:	e8 59 fc ff ff       	call   350 <sbrk>
 6f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 6fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 6fe:	75 07                	jne    707 <morecore+0x34>
    return 0;
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb 22                	jmp    729 <morecore+0x56>
  hp = (Header*)p;
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	8b 55 08             	mov    0x8(%ebp),%edx
 713:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 716:	8b 45 f4             	mov    -0xc(%ebp),%eax
 719:	83 c0 08             	add    $0x8,%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 d8 fe ff ff       	call   5fc <free>
  return freep;
 724:	a1 44 08 00 00       	mov    0x844,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <malloc>:

void*
malloc(uint nbytes)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 740:	a1 44 08 00 00       	mov    0x844,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74e:	c7 45 f0 3c 08 00 00 	movl   $0x83c,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 44 08 00 00       	mov    %eax,0x844
 75d:	a1 44 08 00 00       	mov    0x844,%eax
 762:	a3 3c 08 00 00       	mov    %eax,0x83c
    base.s.size = 0;
 767:	c7 05 40 08 00 00 00 	movl   $0x0,0x840
 76e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 779:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 782:	72 4d                	jb     7d1 <malloc+0xa6>
      if(p->s.size == nunits)
 784:	8b 45 ec             	mov    -0x14(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 78d:	75 0c                	jne    79b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	89 c2                	mov    %eax,%edx
 7a3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 44 08 00 00       	mov    %eax,0x844
      return (void*)(p + 1);
 7c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 38                	jmp    809 <malloc+0xde>
    }
    if(p == freep)
 7d1:	a1 44 08 00 00       	mov    0x844,%eax
 7d6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7d9:	75 1b                	jne    7f6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 04 24             	mov    %eax,(%esp)
 7e1:	e8 ed fe ff ff       	call   6d3 <morecore>
 7e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ed:	75 07                	jne    7f6 <malloc+0xcb>
        return 0;
 7ef:	b8 00 00 00 00       	mov    $0x0,%eax
 7f4:	eb 13                	jmp    809 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 804:	e9 70 ff ff ff       	jmp    779 <malloc+0x4e>
}
 809:	c9                   	leave  
 80a:	c3                   	ret    
