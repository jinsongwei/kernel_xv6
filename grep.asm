
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c9 00 00 00       	jmp    db <grep+0xdb>
    m += n;
  12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  15:	01 45 ec             	add    %eax,-0x14(%ebp)
    buf[m] = '\0';
  18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1b:	c6 80 80 0b 00 00 00 	movb   $0x0,0xb80(%eax)
    p = buf;
  22:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  29:	eb 53                	jmp    7e <grep+0x7e>
      *q = 0;
  2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2e:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  34:	89 44 24 04          	mov    %eax,0x4(%esp)
  38:	8b 45 08             	mov    0x8(%ebp),%eax
  3b:	89 04 24             	mov    %eax,(%esp)
  3e:	e8 b1 01 00 00       	call   1f4 <match>
  43:	85 c0                	test   %eax,%eax
  45:	74 2e                	je     75 <grep+0x75>
        *q = '\n';
  47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	89 d1                	mov    %edx,%ecx
  5a:	29 c1                	sub    %eax,%ecx
  5c:	89 c8                	mov    %ecx,%eax
  5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  65:	89 44 24 04          	mov    %eax,0x4(%esp)
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 6b 05 00 00       	call   5e0 <write>
      }
      p = q+1;
  75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  78:	83 c0 01             	add    $0x1,%eax
  7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  7e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  85:	00 
  86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  89:	89 04 24             	mov    %eax,(%esp)
  8c:	e8 ad 03 00 00       	call   43e <strchr>
  91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	75 91                	jne    2b <grep+0x2b>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  9a:	81 7d f0 80 0b 00 00 	cmpl   $0xb80,-0x10(%ebp)
  a1:	75 07                	jne    aa <grep+0xaa>
      m = 0;
  a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    if(m > 0){
  aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ae:	7e 2b                	jle    db <grep+0xdb>
      m -= p - buf;
  b0:	ba 80 0b 00 00       	mov    $0xb80,%edx
  b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b8:	89 d1                	mov    %edx,%ecx
  ba:	29 c1                	sub    %eax,%ecx
  bc:	89 c8                	mov    %ecx,%eax
  be:	01 45 ec             	add    %eax,-0x14(%ebp)
      memmove(buf, p, m);
  c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  cf:	c7 04 24 80 0b 00 00 	movl   $0xb80,(%esp)
  d6:	e8 9f 04 00 00       	call   57a <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  de:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e3:	89 d1                	mov    %edx,%ecx
  e5:	29 c1                	sub    %eax,%ecx
  e7:	89 c8                	mov    %ecx,%eax
  e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  ec:	81 c2 80 0b 00 00    	add    $0xb80,%edx
  f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 04 24             	mov    %eax,(%esp)
 100:	e8 d3 04 00 00       	call   5d8 <read>
 105:	89 45 e8             	mov    %eax,-0x18(%ebp)
 108:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 10c:	0f 8f 00 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 112:	c9                   	leave  
 113:	c3                   	ret    

00000114 <main>:

int
main(int argc, char *argv[])
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	83 e4 f0             	and    $0xfffffff0,%esp
 11a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 11d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 121:	7f 19                	jg     13c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 123:	c7 44 24 04 0c 0b 00 	movl   $0xb0c,0x4(%esp)
 12a:	00 
 12b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 132:	e8 0d 06 00 00       	call   744 <printf>
    exit();
 137:	e8 84 04 00 00       	call   5c0 <exit>
  }
  pattern = argv[1];
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	83 c0 04             	add    $0x4,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  
  if(argc <= 2){
 148:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 14c:	7f 19                	jg     167 <main+0x53>
    grep(pattern, 0);
 14e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 155:	00 
 156:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15a:	89 04 24             	mov    %eax,(%esp)
 15d:	e8 9e fe ff ff       	call   0 <grep>
    exit();
 162:	e8 59 04 00 00       	call   5c0 <exit>
  }

  for(i = 2; i < argc; i++){
 167:	c7 44 24 18 02 00 00 	movl   $0x2,0x18(%esp)
 16e:	00 
 16f:	eb 75                	jmp    1e6 <main+0xd2>
    if((fd = open(argv[i], 0)) < 0){
 171:	8b 44 24 18          	mov    0x18(%esp),%eax
 175:	c1 e0 02             	shl    $0x2,%eax
 178:	03 45 0c             	add    0xc(%ebp),%eax
 17b:	8b 00                	mov    (%eax),%eax
 17d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 184:	00 
 185:	89 04 24             	mov    %eax,(%esp)
 188:	e8 73 04 00 00       	call   600 <open>
 18d:	89 44 24 14          	mov    %eax,0x14(%esp)
 191:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 196:	79 29                	jns    1c1 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 198:	8b 44 24 18          	mov    0x18(%esp),%eax
 19c:	c1 e0 02             	shl    $0x2,%eax
 19f:	03 45 0c             	add    0xc(%ebp),%eax
 1a2:	8b 00                	mov    (%eax),%eax
 1a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a8:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 1af:	00 
 1b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b7:	e8 88 05 00 00       	call   744 <printf>
      exit();
 1bc:	e8 ff 03 00 00       	call   5c0 <exit>
    }
    grep(pattern, fd);
 1c1:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cd:	89 04 24             	mov    %eax,(%esp)
 1d0:	e8 2b fe ff ff       	call   0 <grep>
    close(fd);
 1d5:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d9:	89 04 24             	mov    %eax,(%esp)
 1dc:	e8 07 04 00 00       	call   5e8 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e1:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
 1e6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ea:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ed:	7c 82                	jl     171 <main+0x5d>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1ef:	e8 cc 03 00 00       	call   5c0 <exit>

000001f4 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	3c 5e                	cmp    $0x5e,%al
 202:	75 17                	jne    21b <match+0x27>
    return matchhere(re+1, text);
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8d 50 01             	lea    0x1(%eax),%edx
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 44 24 04          	mov    %eax,0x4(%esp)
 211:	89 14 24             	mov    %edx,(%esp)
 214:	e8 39 00 00 00       	call   252 <matchhere>
 219:	eb 35                	jmp    250 <match+0x5c>
  do{  // must look at empty string
    if(matchhere(re, text))
 21b:	8b 45 0c             	mov    0xc(%ebp),%eax
 21e:	89 44 24 04          	mov    %eax,0x4(%esp)
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	89 04 24             	mov    %eax,(%esp)
 228:	e8 25 00 00 00       	call   252 <matchhere>
 22d:	85 c0                	test   %eax,%eax
 22f:	74 07                	je     238 <match+0x44>
      return 1;
 231:	b8 01 00 00 00       	mov    $0x1,%eax
 236:	eb 18                	jmp    250 <match+0x5c>
  }while(*text++ != '\0');
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	84 c0                	test   %al,%al
 240:	0f 95 c0             	setne  %al
 243:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 247:	84 c0                	test   %al,%al
 249:	75 d0                	jne    21b <match+0x27>
  return 0;
 24b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	84 c0                	test   %al,%al
 260:	75 0a                	jne    26c <matchhere+0x1a>
    return 1;
 262:	b8 01 00 00 00       	mov    $0x1,%eax
 267:	e9 9b 00 00 00       	jmp    307 <matchhere+0xb5>
  if(re[1] == '*')
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	83 c0 01             	add    $0x1,%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	3c 2a                	cmp    $0x2a,%al
 277:	75 24                	jne    29d <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	8d 48 02             	lea    0x2(%eax),%ecx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	0f be c0             	movsbl %al,%eax
 288:	8b 55 0c             	mov    0xc(%ebp),%edx
 28b:	89 54 24 08          	mov    %edx,0x8(%esp)
 28f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 6e 00 00 00       	call   309 <matchstar>
 29b:	eb 6a                	jmp    307 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 24                	cmp    $0x24,%al
 2a5:	75 1d                	jne    2c4 <matchhere+0x72>
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	83 c0 01             	add    $0x1,%eax
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	84 c0                	test   %al,%al
 2b2:	75 10                	jne    2c4 <matchhere+0x72>
    return *text == '\0';
 2b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	0f 94 c0             	sete   %al
 2bf:	0f b6 c0             	movzbl %al,%eax
 2c2:	eb 43                	jmp    307 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	74 34                	je     302 <matchhere+0xb0>
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	3c 2e                	cmp    $0x2e,%al
 2d6:	74 10                	je     2e8 <matchhere+0x96>
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 10             	movzbl (%eax),%edx
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	38 c2                	cmp    %al,%dl
 2e6:	75 1a                	jne    302 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	8d 50 01             	lea    0x1(%eax),%edx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	83 c0 01             	add    $0x1,%eax
 2f4:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f8:	89 04 24             	mov    %eax,(%esp)
 2fb:	e8 52 ff ff ff       	call   252 <matchhere>
 300:	eb 05                	jmp    307 <matchhere+0xb5>
  return 0;
 302:	b8 00 00 00 00       	mov    $0x0,%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 30f:	8b 45 10             	mov    0x10(%ebp),%eax
 312:	89 44 24 04          	mov    %eax,0x4(%esp)
 316:	8b 45 0c             	mov    0xc(%ebp),%eax
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 31 ff ff ff       	call   252 <matchhere>
 321:	85 c0                	test   %eax,%eax
 323:	74 07                	je     32c <matchstar+0x23>
      return 1;
 325:	b8 01 00 00 00       	mov    $0x1,%eax
 32a:	eb 2c                	jmp    358 <matchstar+0x4f>
  }while(*text!='\0' && (*text++==c || c=='.'));
 32c:	8b 45 10             	mov    0x10(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	84 c0                	test   %al,%al
 334:	74 1d                	je     353 <matchstar+0x4a>
 336:	8b 45 10             	mov    0x10(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	0f be c0             	movsbl %al,%eax
 33f:	3b 45 08             	cmp    0x8(%ebp),%eax
 342:	0f 94 c0             	sete   %al
 345:	83 45 10 01          	addl   $0x1,0x10(%ebp)
 349:	84 c0                	test   %al,%al
 34b:	75 c2                	jne    30f <matchstar+0x6>
 34d:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 351:	74 bc                	je     30f <matchstar+0x6>
  return 0;
 353:	b8 00 00 00 00       	mov    $0x0,%eax
}
 358:	c9                   	leave  
 359:	c3                   	ret    
 35a:	90                   	nop
 35b:	90                   	nop

0000035c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 361:	8b 4d 08             	mov    0x8(%ebp),%ecx
 364:	8b 55 10             	mov    0x10(%ebp),%edx
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 cb                	mov    %ecx,%ebx
 36c:	89 df                	mov    %ebx,%edi
 36e:	89 d1                	mov    %edx,%ecx
 370:	fc                   	cld    
 371:	f3 aa                	rep stos %al,%es:(%edi)
 373:	89 ca                	mov    %ecx,%edx
 375:	89 fb                	mov    %edi,%ebx
 377:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37d:	5b                   	pop    %ebx
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	0f b6 10             	movzbl (%eax),%edx
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	88 10                	mov    %dl,(%eax)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	84 c0                	test   %al,%al
 3a0:	0f 95 c0             	setne  %al
 3a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 3ab:	84 c0                	test   %al,%al
 3ad:	75 de                	jne    38d <strcpy+0xc>
    ;
  return os;
 3af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b7:	eb 08                	jmp    3c1 <strcmp+0xd>
    p++, q++;
 3b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 10                	je     3db <strcmp+0x27>
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 10             	movzbl (%eax),%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	38 c2                	cmp    %al,%dl
 3d9:	74 de                	je     3b9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	0f b6 d0             	movzbl %al,%edx
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	0f b6 00             	movzbl (%eax),%eax
 3ea:	0f b6 c0             	movzbl %al,%eax
 3ed:	89 d1                	mov    %edx,%ecx
 3ef:	29 c1                	sub    %eax,%ecx
 3f1:	89 c8                	mov    %ecx,%eax
}
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    

000003f5 <strlen>:

uint
strlen(char *s)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 402:	eb 04                	jmp    408 <strlen+0x13>
 404:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
 40b:	03 45 08             	add    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	84 c0                	test   %al,%al
 413:	75 ef                	jne    404 <strlen+0xf>
    ;
  return n;
 415:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <memset>:

void*
memset(void *dst, int c, uint n)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 420:	8b 45 10             	mov    0x10(%ebp),%eax
 423:	89 44 24 08          	mov    %eax,0x8(%esp)
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 44 24 04          	mov    %eax,0x4(%esp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	89 04 24             	mov    %eax,(%esp)
 434:	e8 23 ff ff ff       	call   35c <stosb>
  return dst;
 439:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43c:	c9                   	leave  
 43d:	c3                   	ret    

0000043e <strchr>:

char*
strchr(const char *s, char c)
{
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	83 ec 04             	sub    $0x4,%esp
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 44a:	eb 14                	jmp    460 <strchr+0x22>
    if(*s == c)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	0f b6 00             	movzbl (%eax),%eax
 452:	3a 45 fc             	cmp    -0x4(%ebp),%al
 455:	75 05                	jne    45c <strchr+0x1e>
      return (char*)s;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	eb 13                	jmp    46f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 45c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	0f b6 00             	movzbl (%eax),%eax
 466:	84 c0                	test   %al,%al
 468:	75 e2                	jne    44c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 46a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <gets>:

char*
gets(char *buf, int max)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47e:	eb 44                	jmp    4c4 <gets+0x53>
    cc = read(0, &c, 1);
 480:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 487:	00 
 488:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48b:	89 44 24 04          	mov    %eax,0x4(%esp)
 48f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 496:	e8 3d 01 00 00       	call   5d8 <read>
 49b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 49e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a2:	7e 2d                	jle    4d1 <gets+0x60>
      break;
    buf[i++] = c;
 4a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a7:	03 45 08             	add    0x8(%ebp),%eax
 4aa:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 4ae:	88 10                	mov    %dl,(%eax)
 4b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 4b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b8:	3c 0a                	cmp    $0xa,%al
 4ba:	74 16                	je     4d2 <gets+0x61>
 4bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c0:	3c 0d                	cmp    $0xd,%al
 4c2:	74 0e                	je     4d2 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c7:	83 c0 01             	add    $0x1,%eax
 4ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4cd:	7c b1                	jl     480 <gets+0xf>
 4cf:	eb 01                	jmp    4d2 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4d1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d5:	03 45 08             	add    0x8(%ebp),%eax
 4d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <stat>:

int
stat(char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ed:	00 
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 07 01 00 00       	call   600 <open>
 4f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 4fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 500:	79 07                	jns    509 <stat+0x29>
    return -1;
 502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 507:	eb 23                	jmp    52c <stat+0x4c>
  r = fstat(fd, st);
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 f0             	mov    -0x10(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 fd 00 00 00       	call   618 <fstat>
 51b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 521:	89 04 24             	mov    %eax,(%esp)
 524:	e8 bf 00 00 00       	call   5e8 <close>
  return r;
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <atoi>:

int
atoi(const char *s)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53b:	eb 24                	jmp    561 <atoi+0x33>
    n = n*10 + *s++ - '0';
 53d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 540:	89 d0                	mov    %edx,%eax
 542:	c1 e0 02             	shl    $0x2,%eax
 545:	01 d0                	add    %edx,%eax
 547:	01 c0                	add    %eax,%eax
 549:	89 c2                	mov    %eax,%edx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	8d 04 02             	lea    (%edx,%eax,1),%eax
 557:	83 e8 30             	sub    $0x30,%eax
 55a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 55d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	3c 2f                	cmp    $0x2f,%al
 569:	7e 0a                	jle    575 <atoi+0x47>
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	3c 39                	cmp    $0x39,%al
 573:	7e c8                	jle    53d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 575:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 578:	c9                   	leave  
 579:	c3                   	ret    

0000057a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 58c:	eb 13                	jmp    5a1 <memmove+0x27>
    *dst++ = *src++;
 58e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 591:	0f b6 10             	movzbl (%eax),%edx
 594:	8b 45 f8             	mov    -0x8(%ebp),%eax
 597:	88 10                	mov    %dl,(%eax)
 599:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 59d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5a5:	0f 9f c0             	setg   %al
 5a8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 5ac:	84 c0                	test   %al,%al
 5ae:	75 de                	jne    58e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b3:	c9                   	leave  
 5b4:	c3                   	ret    
 5b5:	90                   	nop
 5b6:	90                   	nop
 5b7:	90                   	nop

000005b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b8:	b8 01 00 00 00       	mov    $0x1,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <exit>:
SYSCALL(exit)
 5c0:	b8 02 00 00 00       	mov    $0x2,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <wait>:
SYSCALL(wait)
 5c8:	b8 03 00 00 00       	mov    $0x3,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <pipe>:
SYSCALL(pipe)
 5d0:	b8 04 00 00 00       	mov    $0x4,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <read>:
SYSCALL(read)
 5d8:	b8 05 00 00 00       	mov    $0x5,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <write>:
SYSCALL(write)
 5e0:	b8 10 00 00 00       	mov    $0x10,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <close>:
SYSCALL(close)
 5e8:	b8 15 00 00 00       	mov    $0x15,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <kill>:
SYSCALL(kill)
 5f0:	b8 06 00 00 00       	mov    $0x6,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <exec>:
SYSCALL(exec)
 5f8:	b8 07 00 00 00       	mov    $0x7,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <open>:
SYSCALL(open)
 600:	b8 0f 00 00 00       	mov    $0xf,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <mknod>:
SYSCALL(mknod)
 608:	b8 11 00 00 00       	mov    $0x11,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <unlink>:
SYSCALL(unlink)
 610:	b8 12 00 00 00       	mov    $0x12,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <fstat>:
SYSCALL(fstat)
 618:	b8 08 00 00 00       	mov    $0x8,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <link>:
SYSCALL(link)
 620:	b8 13 00 00 00       	mov    $0x13,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <mkdir>:
SYSCALL(mkdir)
 628:	b8 14 00 00 00       	mov    $0x14,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <chdir>:
SYSCALL(chdir)
 630:	b8 09 00 00 00       	mov    $0x9,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <dup>:
SYSCALL(dup)
 638:	b8 0a 00 00 00       	mov    $0xa,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <getpid>:
SYSCALL(getpid)
 640:	b8 0b 00 00 00       	mov    $0xb,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <sbrk>:
SYSCALL(sbrk)
 648:	b8 0c 00 00 00       	mov    $0xc,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <sleep>:
SYSCALL(sleep)
 650:	b8 0d 00 00 00       	mov    $0xd,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <uptime>:
SYSCALL(uptime)
 658:	b8 0e 00 00 00       	mov    $0xe,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <count>:
//add
SYSCALL(count)
 660:	b8 16 00 00 00       	mov    $0x16,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	83 ec 28             	sub    $0x28,%esp
 66e:	8b 45 0c             	mov    0xc(%ebp),%eax
 671:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 674:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 67b:	00 
 67c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 67f:	89 44 24 04          	mov    %eax,0x4(%esp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	89 04 24             	mov    %eax,(%esp)
 689:	e8 52 ff ff ff       	call   5e0 <write>
}
 68e:	c9                   	leave  
 68f:	c3                   	ret    

00000690 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	53                   	push   %ebx
 694:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 69e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6a2:	74 17                	je     6bb <printint+0x2b>
 6a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a8:	79 11                	jns    6bb <printint+0x2b>
    neg = 1;
 6aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b4:	f7 d8                	neg    %eax
 6b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6b9:	eb 06                	jmp    6c1 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 6c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 6cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d1:	ba 00 00 00 00       	mov    $0x0,%edx
 6d6:	f7 f3                	div    %ebx
 6d8:	89 d0                	mov    %edx,%eax
 6da:	0f b6 80 4c 0b 00 00 	movzbl 0xb4c(%eax),%eax
 6e1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 6e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 6e9:	8b 45 10             	mov    0x10(%ebp),%eax
 6ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f2:	ba 00 00 00 00       	mov    $0x0,%edx
 6f7:	f7 75 d4             	divl   -0x2c(%ebp)
 6fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 701:	75 c5                	jne    6c8 <printint+0x38>
  if(neg)
 703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 707:	74 2a                	je     733 <printint+0xa3>
    buf[i++] = '-';
 709:	8b 45 ec             	mov    -0x14(%ebp),%eax
 70c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 711:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 715:	eb 1d                	jmp    734 <printint+0xa4>
    putc(fd, buf[i]);
 717:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71a:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	89 44 24 04          	mov    %eax,0x4(%esp)
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	89 04 24             	mov    %eax,(%esp)
 72c:	e8 37 ff ff ff       	call   668 <putc>
 731:	eb 01                	jmp    734 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 733:	90                   	nop
 734:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 738:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 73c:	79 d9                	jns    717 <printint+0x87>
    putc(fd, buf[i]);
}
 73e:	83 c4 44             	add    $0x44,%esp
 741:	5b                   	pop    %ebx
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    

00000744 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 74a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 751:	8d 45 0c             	lea    0xc(%ebp),%eax
 754:	83 c0 04             	add    $0x4,%eax
 757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 75a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 761:	e9 7e 01 00 00       	jmp    8e4 <printf+0x1a0>
    c = fmt[i] & 0xff;
 766:	8b 55 0c             	mov    0xc(%ebp),%edx
 769:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 76f:	0f b6 00             	movzbl (%eax),%eax
 772:	0f be c0             	movsbl %al,%eax
 775:	25 ff 00 00 00       	and    $0xff,%eax
 77a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 77d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 781:	75 2c                	jne    7af <printf+0x6b>
      if(c == '%'){
 783:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 787:	75 0c                	jne    795 <printf+0x51>
        state = '%';
 789:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 790:	e9 4b 01 00 00       	jmp    8e0 <printf+0x19c>
      } else {
        putc(fd, c);
 795:	8b 45 e8             	mov    -0x18(%ebp),%eax
 798:	0f be c0             	movsbl %al,%eax
 79b:	89 44 24 04          	mov    %eax,0x4(%esp)
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	89 04 24             	mov    %eax,(%esp)
 7a5:	e8 be fe ff ff       	call   668 <putc>
 7aa:	e9 31 01 00 00       	jmp    8e0 <printf+0x19c>
      }
    } else if(state == '%'){
 7af:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 7b3:	0f 85 27 01 00 00    	jne    8e0 <printf+0x19c>
      if(c == 'd'){
 7b9:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 7bd:	75 2d                	jne    7ec <printf+0xa8>
        printint(fd, *ap, 10, 1);
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7cb:	00 
 7cc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7d3:	00 
 7d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	89 04 24             	mov    %eax,(%esp)
 7de:	e8 ad fe ff ff       	call   690 <printint>
        ap++;
 7e3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 7e7:	e9 ed 00 00 00       	jmp    8d9 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 7ec:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 7f0:	74 06                	je     7f8 <printf+0xb4>
 7f2:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 7f6:	75 2d                	jne    825 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 804:	00 
 805:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80c:	00 
 80d:	89 44 24 04          	mov    %eax,0x4(%esp)
 811:	8b 45 08             	mov    0x8(%ebp),%eax
 814:	89 04 24             	mov    %eax,(%esp)
 817:	e8 74 fe ff ff       	call   690 <printint>
        ap++;
 81c:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 820:	e9 b4 00 00 00       	jmp    8d9 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 825:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 829:	75 46                	jne    871 <printf+0x12d>
        s = (char*)*ap;
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 833:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 83b:	75 27                	jne    864 <printf+0x120>
          s = "(null)";
 83d:	c7 45 e4 42 0b 00 00 	movl   $0xb42,-0x1c(%ebp)
        while(*s != 0){
 844:	eb 1f                	jmp    865 <printf+0x121>
          putc(fd, *s);
 846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 849:	0f b6 00             	movzbl (%eax),%eax
 84c:	0f be c0             	movsbl %al,%eax
 84f:	89 44 24 04          	mov    %eax,0x4(%esp)
 853:	8b 45 08             	mov    0x8(%ebp),%eax
 856:	89 04 24             	mov    %eax,(%esp)
 859:	e8 0a fe ff ff       	call   668 <putc>
          s++;
 85e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 862:	eb 01                	jmp    865 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 864:	90                   	nop
 865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 868:	0f b6 00             	movzbl (%eax),%eax
 86b:	84 c0                	test   %al,%al
 86d:	75 d7                	jne    846 <printf+0x102>
 86f:	eb 68                	jmp    8d9 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 871:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 875:	75 1d                	jne    894 <printf+0x150>
        putc(fd, *ap);
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	0f be c0             	movsbl %al,%eax
 87f:	89 44 24 04          	mov    %eax,0x4(%esp)
 883:	8b 45 08             	mov    0x8(%ebp),%eax
 886:	89 04 24             	mov    %eax,(%esp)
 889:	e8 da fd ff ff       	call   668 <putc>
        ap++;
 88e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 892:	eb 45                	jmp    8d9 <printf+0x195>
      } else if(c == '%'){
 894:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 898:	75 17                	jne    8b1 <printf+0x16d>
        putc(fd, c);
 89a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89d:	0f be c0             	movsbl %al,%eax
 8a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a4:	8b 45 08             	mov    0x8(%ebp),%eax
 8a7:	89 04 24             	mov    %eax,(%esp)
 8aa:	e8 b9 fd ff ff       	call   668 <putc>
 8af:	eb 28                	jmp    8d9 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8b8:	00 
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	89 04 24             	mov    %eax,(%esp)
 8bf:	e8 a4 fd ff ff       	call   668 <putc>
        putc(fd, c);
 8c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8c7:	0f be c0             	movsbl %al,%eax
 8ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	89 04 24             	mov    %eax,(%esp)
 8d4:	e8 8f fd ff ff       	call   668 <putc>
      }
      state = 0;
 8d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 8e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ea:	8d 04 02             	lea    (%edx,%eax,1),%eax
 8ed:	0f b6 00             	movzbl (%eax),%eax
 8f0:	84 c0                	test   %al,%al
 8f2:	0f 85 6e fe ff ff    	jne    766 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f8:	c9                   	leave  
 8f9:	c3                   	ret    
 8fa:	90                   	nop
 8fb:	90                   	nop

000008fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fc:	55                   	push   %ebp
 8fd:	89 e5                	mov    %esp,%ebp
 8ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	83 e8 08             	sub    $0x8,%eax
 908:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90b:	a1 68 0b 00 00       	mov    0xb68,%eax
 910:	89 45 fc             	mov    %eax,-0x4(%ebp)
 913:	eb 24                	jmp    939 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	77 12                	ja     931 <free+0x35>
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 925:	77 24                	ja     94b <free+0x4f>
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92f:	77 1a                	ja     94b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	8b 00                	mov    (%eax),%eax
 936:	89 45 fc             	mov    %eax,-0x4(%ebp)
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93f:	76 d4                	jbe    915 <free+0x19>
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 949:	76 ca                	jbe    915 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	c1 e0 03             	shl    $0x3,%eax
 954:	89 c2                	mov    %eax,%edx
 956:	03 55 f8             	add    -0x8(%ebp),%edx
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 00                	mov    (%eax),%eax
 95e:	39 c2                	cmp    %eax,%edx
 960:	75 24                	jne    986 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 962:	8b 45 f8             	mov    -0x8(%ebp),%eax
 965:	8b 50 04             	mov    0x4(%eax),%edx
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 00                	mov    (%eax),%eax
 96d:	8b 40 04             	mov    0x4(%eax),%eax
 970:	01 c2                	add    %eax,%edx
 972:	8b 45 f8             	mov    -0x8(%ebp),%eax
 975:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	8b 10                	mov    (%eax),%edx
 97f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 982:	89 10                	mov    %edx,(%eax)
 984:	eb 0a                	jmp    990 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 986:	8b 45 fc             	mov    -0x4(%ebp),%eax
 989:	8b 10                	mov    (%eax),%edx
 98b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	8b 40 04             	mov    0x4(%eax),%eax
 996:	c1 e0 03             	shl    $0x3,%eax
 999:	03 45 fc             	add    -0x4(%ebp),%eax
 99c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 99f:	75 20                	jne    9c1 <free+0xc5>
    p->s.size += bp->s.size;
 9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a4:	8b 50 04             	mov    0x4(%eax),%edx
 9a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9aa:	8b 40 04             	mov    0x4(%eax),%eax
 9ad:	01 c2                	add    %eax,%edx
 9af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b8:	8b 10                	mov    (%eax),%edx
 9ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bd:	89 10                	mov    %edx,(%eax)
 9bf:	eb 08                	jmp    9c9 <free+0xcd>
  } else
    p->s.ptr = bp;
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9c7:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 9d1:	c9                   	leave  
 9d2:	c3                   	ret    

000009d3 <morecore>:

static Header*
morecore(uint nu)
{
 9d3:	55                   	push   %ebp
 9d4:	89 e5                	mov    %esp,%ebp
 9d6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9d9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e0:	77 07                	ja     9e9 <morecore+0x16>
    nu = 4096;
 9e2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ec:	c1 e0 03             	shl    $0x3,%eax
 9ef:	89 04 24             	mov    %eax,(%esp)
 9f2:	e8 51 fc ff ff       	call   648 <sbrk>
 9f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 9fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 9fe:	75 07                	jne    a07 <morecore+0x34>
    return 0;
 a00:	b8 00 00 00 00       	mov    $0x0,%eax
 a05:	eb 22                	jmp    a29 <morecore+0x56>
  hp = (Header*)p;
 a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 55 08             	mov    0x8(%ebp),%edx
 a13:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	83 c0 08             	add    $0x8,%eax
 a1c:	89 04 24             	mov    %eax,(%esp)
 a1f:	e8 d8 fe ff ff       	call   8fc <free>
  return freep;
 a24:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 a29:	c9                   	leave  
 a2a:	c3                   	ret    

00000a2b <malloc>:

void*
malloc(uint nbytes)
{
 a2b:	55                   	push   %ebp
 a2c:	89 e5                	mov    %esp,%ebp
 a2e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a31:	8b 45 08             	mov    0x8(%ebp),%eax
 a34:	83 c0 07             	add    $0x7,%eax
 a37:	c1 e8 03             	shr    $0x3,%eax
 a3a:	83 c0 01             	add    $0x1,%eax
 a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 a40:	a1 68 0b 00 00       	mov    0xb68,%eax
 a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4c:	75 23                	jne    a71 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a4e:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a58:	a3 68 0b 00 00       	mov    %eax,0xb68
 a5d:	a1 68 0b 00 00       	mov    0xb68,%eax
 a62:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 a67:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 a6e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	8b 00                	mov    (%eax),%eax
 a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a7c:	8b 40 04             	mov    0x4(%eax),%eax
 a7f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a82:	72 4d                	jb     ad1 <malloc+0xa6>
      if(p->s.size == nunits)
 a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a87:	8b 40 04             	mov    0x4(%eax),%eax
 a8a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 a8d:	75 0c                	jne    a9b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a92:	8b 10                	mov    (%eax),%edx
 a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a97:	89 10                	mov    %edx,(%eax)
 a99:	eb 26                	jmp    ac1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a9e:	8b 40 04             	mov    0x4(%eax),%eax
 aa1:	89 c2                	mov    %eax,%edx
 aa3:	2b 55 f4             	sub    -0xc(%ebp),%edx
 aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aaf:	8b 40 04             	mov    0x4(%eax),%eax
 ab2:	c1 e0 03             	shl    $0x3,%eax
 ab5:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 abe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac4:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 acc:	83 c0 08             	add    $0x8,%eax
 acf:	eb 38                	jmp    b09 <malloc+0xde>
    }
    if(p == freep)
 ad1:	a1 68 0b 00 00       	mov    0xb68,%eax
 ad6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ad9:	75 1b                	jne    af6 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	89 04 24             	mov    %eax,(%esp)
 ae1:	e8 ed fe ff ff       	call   9d3 <morecore>
 ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ae9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 aed:	75 07                	jne    af6 <malloc+0xcb>
        return 0;
 aef:	b8 00 00 00 00       	mov    $0x0,%eax
 af4:	eb 13                	jmp    b09 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aff:	8b 00                	mov    (%eax),%eax
 b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b04:	e9 70 ff ff ff       	jmp    a79 <malloc+0x4e>
}
 b09:	c9                   	leave  
 b0a:	c3                   	ret    
