
_rm:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 33 08 00 	movl   $0x833,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 49 04 00 00       	call   46c <printf>
    exit();
  23:	e8 c0 02 00 00       	call   2e8 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 43                	jmp    75 <main+0x75>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	c1 e0 02             	shl    $0x2,%eax
  39:	03 45 0c             	add    0xc(%ebp),%eax
  3c:	8b 00                	mov    (%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 f2 02 00 00       	call   338 <unlink>
  46:	85 c0                	test   %eax,%eax
  48:	79 26                	jns    70 <main+0x70>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  4a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4e:	c1 e0 02             	shl    $0x2,%eax
  51:	03 45 0c             	add    0xc(%ebp),%eax
  54:	8b 00                	mov    (%eax),%eax
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	c7 44 24 04 47 08 00 	movl   $0x847,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	e8 fe 03 00 00       	call   46c <printf>
      break;
  6e:	eb 0e                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  70:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	3b 45 08             	cmp    0x8(%ebp),%eax
  7c:	7c b4                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 65 02 00 00       	call   2e8 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 10             	movzbl (%eax),%edx
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	88 10                	mov    %dl,(%eax)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	0f 95 c0             	setne  %al
  cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  d3:	84 c0                	test   %al,%al
  d5:	75 de                	jne    b5 <strcpy+0xc>
    ;
  return os;
  d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  da:	c9                   	leave  
  db:	c3                   	ret    

000000dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  df:	eb 08                	jmp    e9 <strcmp+0xd>
    p++, q++;
  e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 10                	je     103 <strcmp+0x27>
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 10             	movzbl (%eax),%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	38 c2                	cmp    %al,%dl
 101:	74 de                	je     e1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 c0             	movzbl %al,%eax
 115:	89 d1                	mov    %edx,%ecx
 117:	29 c1                	sub    %eax,%ecx
 119:	89 c8                	mov    %ecx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 04                	jmp    130 <strlen+0x13>
 12c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
 133:	03 45 08             	add    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 ef                	jne    12c <strlen+0xf>
    ;
  return n;
 13d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 44 24 04          	mov    %eax,0x4(%esp)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	89 04 24             	mov    %eax,(%esp)
 15c:	e8 23 ff ff ff       	call   84 <stosb>
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1a6:	eb 44                	jmp    1ec <gets+0x53>
    cc = read(0, &c, 1);
 1a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1af:	00 
 1b0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1be:	e8 3d 01 00 00       	call   300 <read>
 1c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ca:	7e 2d                	jle    1f9 <gets+0x60>
      break;
    buf[i++] = c;
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	03 45 08             	add    0x8(%ebp),%eax
 1d2:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1d6:	88 10                	mov    %dl,(%eax)
 1d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 16                	je     1fa <gets+0x61>
 1e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e8:	3c 0d                	cmp    $0xd,%al
 1ea:	74 0e                	je     1fa <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ef:	83 c0 01             	add    $0x1,%eax
 1f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f5:	7c b1                	jl     1a8 <gets+0xf>
 1f7:	eb 01                	jmp    1fa <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1fd:	03 45 08             	add    0x8(%ebp),%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 215:	00 
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	89 04 24             	mov    %eax,(%esp)
 21c:	e8 07 01 00 00       	call   328 <open>
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 228:	79 07                	jns    231 <stat+0x29>
    return -1;
 22a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22f:	eb 23                	jmp    254 <stat+0x4c>
  r = fstat(fd, st);
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	89 44 24 04          	mov    %eax,0x4(%esp)
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23b:	89 04 24             	mov    %eax,(%esp)
 23e:	e8 fd 00 00 00       	call   340 <fstat>
 243:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 246:	8b 45 f0             	mov    -0x10(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 bf 00 00 00       	call   310 <close>
  return r;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <atoi>:

int
atoi(const char *s)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 263:	eb 24                	jmp    289 <atoi+0x33>
    n = n*10 + *s++ - '0';
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	89 d0                	mov    %edx,%eax
 26a:	c1 e0 02             	shl    $0x2,%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	01 c0                	add    %eax,%eax
 271:	89 c2                	mov    %eax,%edx
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	0f be c0             	movsbl %al,%eax
 27c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 27f:	83 e8 30             	sub    $0x30,%eax
 282:	89 45 fc             	mov    %eax,-0x4(%ebp)
 285:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x47>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c8                	jle    265 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2b4:	eb 13                	jmp    2c9 <memmove+0x27>
    *dst++ = *src++;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b9:	0f b6 10             	movzbl (%eax),%edx
 2bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2bf:	88 10                	mov    %dl,(%eax)
 2c1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2cd:	0f 9f c0             	setg   %al
 2d0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2d4:	84 c0                	test   %al,%al
 2d6:	75 de                	jne    2b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    
 2dd:	90                   	nop
 2de:	90                   	nop
 2df:	90                   	nop

000002e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e0:	b8 01 00 00 00       	mov    $0x1,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exit>:
SYSCALL(exit)
 2e8:	b8 02 00 00 00       	mov    $0x2,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <wait>:
SYSCALL(wait)
 2f0:	b8 03 00 00 00       	mov    $0x3,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <pipe>:
SYSCALL(pipe)
 2f8:	b8 04 00 00 00       	mov    $0x4,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <read>:
SYSCALL(read)
 300:	b8 05 00 00 00       	mov    $0x5,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <write>:
SYSCALL(write)
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <close>:
SYSCALL(close)
 310:	b8 15 00 00 00       	mov    $0x15,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <kill>:
SYSCALL(kill)
 318:	b8 06 00 00 00       	mov    $0x6,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <exec>:
SYSCALL(exec)
 320:	b8 07 00 00 00       	mov    $0x7,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <open>:
SYSCALL(open)
 328:	b8 0f 00 00 00       	mov    $0xf,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mknod>:
SYSCALL(mknod)
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <unlink>:
SYSCALL(unlink)
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <fstat>:
SYSCALL(fstat)
 340:	b8 08 00 00 00       	mov    $0x8,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <link>:
SYSCALL(link)
 348:	b8 13 00 00 00       	mov    $0x13,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <mkdir>:
SYSCALL(mkdir)
 350:	b8 14 00 00 00       	mov    $0x14,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <chdir>:
SYSCALL(chdir)
 358:	b8 09 00 00 00       	mov    $0x9,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <dup>:
SYSCALL(dup)
 360:	b8 0a 00 00 00       	mov    $0xa,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getpid>:
SYSCALL(getpid)
 368:	b8 0b 00 00 00       	mov    $0xb,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sbrk>:
SYSCALL(sbrk)
 370:	b8 0c 00 00 00       	mov    $0xc,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <sleep>:
SYSCALL(sleep)
 378:	b8 0d 00 00 00       	mov    $0xd,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <uptime>:
SYSCALL(uptime)
 380:	b8 0e 00 00 00       	mov    $0xe,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <count>:
//add
SYSCALL(count)
 388:	b8 16 00 00 00       	mov    $0x16,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 28             	sub    $0x28,%esp
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 39c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a3:	00 
 3a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	89 04 24             	mov    %eax,(%esp)
 3b1:	e8 52 ff ff ff       	call   308 <write>
}
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    

000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	53                   	push   %ebx
 3bc:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ca:	74 17                	je     3e3 <printint+0x2b>
 3cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d0:	79 11                	jns    3e3 <printint+0x2b>
    neg = 1;
 3d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	f7 d8                	neg    %eax
 3de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e1:	eb 06                	jmp    3e9 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 3e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 3f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 f3                	div    %ebx
 400:	89 d0                	mov    %edx,%eax
 402:	0f b6 80 68 08 00 00 	movzbl 0x868(%eax),%eax
 409:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 40d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 411:	8b 45 10             	mov    0x10(%ebp),%eax
 414:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	ba 00 00 00 00       	mov    $0x0,%edx
 41f:	f7 75 d4             	divl   -0x2c(%ebp)
 422:	89 45 f4             	mov    %eax,-0xc(%ebp)
 425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 429:	75 c5                	jne    3f0 <printint+0x38>
  if(neg)
 42b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42f:	74 2a                	je     45b <printint+0xa3>
    buf[i++] = '-';
 431:	8b 45 ec             	mov    -0x14(%ebp),%eax
 434:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 439:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 43d:	eb 1d                	jmp    45c <printint+0xa4>
    putc(fd, buf[i]);
 43f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 442:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 447:	0f be c0             	movsbl %al,%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 37 ff ff ff       	call   390 <putc>
 459:	eb 01                	jmp    45c <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45b:	90                   	nop
 45c:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 464:	79 d9                	jns    43f <printint+0x87>
    putc(fd, buf[i]);
}
 466:	83 c4 44             	add    $0x44,%esp
 469:	5b                   	pop    %ebx
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret    

0000046c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 479:	8d 45 0c             	lea    0xc(%ebp),%eax
 47c:	83 c0 04             	add    $0x4,%eax
 47f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 482:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 489:	e9 7e 01 00 00       	jmp    60c <printf+0x1a0>
    c = fmt[i] & 0xff;
 48e:	8b 55 0c             	mov    0xc(%ebp),%edx
 491:	8b 45 ec             	mov    -0x14(%ebp),%eax
 494:	8d 04 02             	lea    (%edx,%eax,1),%eax
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	0f be c0             	movsbl %al,%eax
 49d:	25 ff 00 00 00       	and    $0xff,%eax
 4a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 4a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a9:	75 2c                	jne    4d7 <printf+0x6b>
      if(c == '%'){
 4ab:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 4af:	75 0c                	jne    4bd <printf+0x51>
        state = '%';
 4b1:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 4b8:	e9 4b 01 00 00       	jmp    608 <printf+0x19c>
      } else {
        putc(fd, c);
 4bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	89 04 24             	mov    %eax,(%esp)
 4cd:	e8 be fe ff ff       	call   390 <putc>
 4d2:	e9 31 01 00 00       	jmp    608 <printf+0x19c>
      }
    } else if(state == '%'){
 4d7:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 4db:	0f 85 27 01 00 00    	jne    608 <printf+0x19c>
      if(c == 'd'){
 4e1:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 4e5:	75 2d                	jne    514 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 4e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ea:	8b 00                	mov    (%eax),%eax
 4ec:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f3:	00 
 4f4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fb:	00 
 4fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	89 04 24             	mov    %eax,(%esp)
 506:	e8 ad fe ff ff       	call   3b8 <printint>
        ap++;
 50b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 50f:	e9 ed 00 00 00       	jmp    601 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 514:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 518:	74 06                	je     520 <printf+0xb4>
 51a:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 51e:	75 2d                	jne    54d <printf+0xe1>
        printint(fd, *ap, 16, 0);
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52c:	00 
 52d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 534:	00 
 535:	89 44 24 04          	mov    %eax,0x4(%esp)
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	89 04 24             	mov    %eax,(%esp)
 53f:	e8 74 fe ff ff       	call   3b8 <printint>
        ap++;
 544:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 548:	e9 b4 00 00 00       	jmp    601 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 54d:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 551:	75 46                	jne    599 <printf+0x12d>
        s = (char*)*ap;
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 55b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 55f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 563:	75 27                	jne    58c <printf+0x120>
          s = "(null)";
 565:	c7 45 e4 60 08 00 00 	movl   $0x860,-0x1c(%ebp)
        while(*s != 0){
 56c:	eb 1f                	jmp    58d <printf+0x121>
          putc(fd, *s);
 56e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 571:	0f b6 00             	movzbl (%eax),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	89 44 24 04          	mov    %eax,0x4(%esp)
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	89 04 24             	mov    %eax,(%esp)
 581:	e8 0a fe ff ff       	call   390 <putc>
          s++;
 586:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 58a:	eb 01                	jmp    58d <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58c:	90                   	nop
 58d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 590:	0f b6 00             	movzbl (%eax),%eax
 593:	84 c0                	test   %al,%al
 595:	75 d7                	jne    56e <printf+0x102>
 597:	eb 68                	jmp    601 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 599:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 59d:	75 1d                	jne    5bc <printf+0x150>
        putc(fd, *ap);
 59f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 da fd ff ff       	call   390 <putc>
        ap++;
 5b6:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5ba:	eb 45                	jmp    601 <printf+0x195>
      } else if(c == '%'){
 5bc:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 5c0:	75 17                	jne    5d9 <printf+0x16d>
        putc(fd, c);
 5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 b9 fd ff ff       	call   390 <putc>
 5d7:	eb 28                	jmp    601 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e0:	00 
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 a4 fd ff ff       	call   390 <putc>
        putc(fd, c);
 5ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 8f fd ff ff       	call   390 <putc>
      }
      state = 0;
 601:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 608:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 60c:	8b 55 0c             	mov    0xc(%ebp),%edx
 60f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 612:	8d 04 02             	lea    (%edx,%eax,1),%eax
 615:	0f b6 00             	movzbl (%eax),%eax
 618:	84 c0                	test   %al,%al
 61a:	0f 85 6e fe ff ff    	jne    48e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 620:	c9                   	leave  
 621:	c3                   	ret    
 622:	90                   	nop
 623:	90                   	nop

00000624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	83 e8 08             	sub    $0x8,%eax
 630:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	a1 84 08 00 00       	mov    0x884,%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63b:	eb 24                	jmp    661 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 12                	ja     659 <free+0x35>
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 24                	ja     673 <free+0x4f>
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	77 1a                	ja     673 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 667:	76 d4                	jbe    63d <free+0x19>
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 671:	76 ca                	jbe    63d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	8b 40 04             	mov    0x4(%eax),%eax
 679:	c1 e0 03             	shl    $0x3,%eax
 67c:	89 c2                	mov    %eax,%edx
 67e:	03 55 f8             	add    -0x8(%ebp),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	39 c2                	cmp    %eax,%edx
 688:	75 24                	jne    6ae <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	8b 40 04             	mov    0x4(%eax),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
 6ac:	eb 0a                	jmp    6b8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 40 04             	mov    0x4(%eax),%eax
 6be:	c1 e0 03             	shl    $0x3,%eax
 6c1:	03 45 fc             	add    -0x4(%ebp),%eax
 6c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c7:	75 20                	jne    6e9 <free+0xc5>
    p->s.size += bp->s.size;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 50 04             	mov    0x4(%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
 6e7:	eb 08                	jmp    6f1 <free+0xcd>
  } else
    p->s.ptr = bp;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ef:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	a3 84 08 00 00       	mov    %eax,0x884
}
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <morecore>:

static Header*
morecore(uint nu)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 701:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 708:	77 07                	ja     711 <morecore+0x16>
    nu = 4096;
 70a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	c1 e0 03             	shl    $0x3,%eax
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 51 fc ff ff       	call   370 <sbrk>
 71f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 722:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 726:	75 07                	jne    72f <morecore+0x34>
    return 0;
 728:	b8 00 00 00 00       	mov    $0x0,%eax
 72d:	eb 22                	jmp    751 <morecore+0x56>
  hp = (Header*)p;
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	8b 55 08             	mov    0x8(%ebp),%edx
 73b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	83 c0 08             	add    $0x8,%eax
 744:	89 04 24             	mov    %eax,(%esp)
 747:	e8 d8 fe ff ff       	call   624 <free>
  return freep;
 74c:	a1 84 08 00 00       	mov    0x884,%eax
}
 751:	c9                   	leave  
 752:	c3                   	ret    

00000753 <malloc>:

void*
malloc(uint nbytes)
{
 753:	55                   	push   %ebp
 754:	89 e5                	mov    %esp,%ebp
 756:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	83 c0 07             	add    $0x7,%eax
 75f:	c1 e8 03             	shr    $0x3,%eax
 762:	83 c0 01             	add    $0x1,%eax
 765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 768:	a1 84 08 00 00       	mov    0x884,%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 774:	75 23                	jne    799 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 776:	c7 45 f0 7c 08 00 00 	movl   $0x87c,-0x10(%ebp)
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 84 08 00 00       	mov    %eax,0x884
 785:	a1 84 08 00 00       	mov    0x884,%eax
 78a:	a3 7c 08 00 00       	mov    %eax,0x87c
    base.s.size = 0;
 78f:	c7 05 80 08 00 00 00 	movl   $0x0,0x880
 796:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 7a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7aa:	72 4d                	jb     7f9 <malloc+0xa6>
      if(p->s.size == nunits)
 7ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 7b5:	75 0c                	jne    7c3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
 7c1:	eb 26                	jmp    7e9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	89 c2                	mov    %eax,%edx
 7cb:	2b 55 f4             	sub    -0xc(%ebp),%edx
 7ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	c1 e0 03             	shl    $0x3,%eax
 7dd:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 7e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 84 08 00 00       	mov    %eax,0x884
      return (void*)(p + 1);
 7f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f4:	83 c0 08             	add    $0x8,%eax
 7f7:	eb 38                	jmp    831 <malloc+0xde>
    }
    if(p == freep)
 7f9:	a1 84 08 00 00       	mov    0x884,%eax
 7fe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 801:	75 1b                	jne    81e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	89 04 24             	mov    %eax,(%esp)
 809:	e8 ed fe ff ff       	call   6fb <morecore>
 80e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 811:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 815:	75 07                	jne    81e <malloc+0xcb>
        return 0;
 817:	b8 00 00 00 00       	mov    $0x0,%eax
 81c:	eb 13                	jmp    831 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	8b 45 ec             	mov    -0x14(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82c:	e9 70 ff ff ff       	jmp    7a1 <malloc+0x4e>
}
 831:	c9                   	leave  
 832:	c3                   	ret    
