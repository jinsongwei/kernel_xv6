
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 4f 0f 00 00       	call   f60 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 d8 14 00 00 	mov    0x14d8(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 ac 14 00 00 	movl   $0x14ac,(%esp)
      2b:	e8 29 03 00 00       	call   359 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 e8             	mov    -0x18(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 1b 0f 00 00       	call   f60 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 e8             	mov    -0x18(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 3b 0f 00 00       	call   f98 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 b3 14 00 	movl   $0x14b3,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 69 10 00 00       	call   10e4 <printf>
    break;
      7b:	e9 83 01 00 00       	jmp    203 <runcmd+0x203>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    close(rcmd->fd);
      86:	8b 45 f4             	mov    -0xc(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f4 0e 00 00       	call   f88 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f4             	mov    -0xc(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f4 0e 00 00       	call   fa0 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 c3 14 00 	movl   $0x14c3,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 16 10 00 00       	call   10e4 <printf>
      exit();
      ce:	e8 8d 0e 00 00       	call   f60 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 1d 01 00 00       	jmp    203 <runcmd+0x203>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8e 02 00 00       	call   37f <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 60 0e 00 00       	call   f68 <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 e8 00 00 00       	jmp    203 <runcmd+0x203>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 44 0e 00 00       	call   f70 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 d3 14 00 00 	movl   $0x14d3,(%esp)
     137:	e8 1d 02 00 00       	call   359 <panic>
    if(fork1() == 0){
     13c:	e8 3e 02 00 00       	call   37f <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 37 0e 00 00       	call   f88 <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 7c 0e 00 00       	call   fd8 <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 21 0e 00 00       	call   f88 <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 16 0e 00 00       	call   f88 <close>
      runcmd(pcmd->left);
     172:	8b 45 f0             	mov    -0x10(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 fa 01 00 00       	call   37f <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 f3 0d 00 00       	call   f88 <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 38 0e 00 00       	call   fd8 <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 dd 0d 00 00       	call   f88 <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 d2 0d 00 00       	call   f88 <close>
      runcmd(pcmd->right);
     1b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 b9 0d 00 00       	call   f88 <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 ae 0d 00 00       	call   f88 <close>
    wait();
     1da:	e8 89 0d 00 00       	call   f68 <wait>
    wait();
     1df:	e8 84 0d 00 00       	call   f68 <wait>
    break;
     1e4:	eb 1d                	jmp    203 <runcmd+0x203>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8e 01 00 00       	call   37f <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 0e                	jne    203 <runcmd+0x203>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
  }
  exit();
     203:	e8 58 0d 00 00       	call   f60 <exit>

00000208 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     208:	55                   	push   %ebp
     209:	89 e5                	mov    %esp,%ebp
     20b:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     20e:	c7 44 24 04 f0 14 00 	movl   $0x14f0,0x4(%esp)
     215:	00 
     216:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21d:	e8 c2 0e 00 00       	call   10e4 <printf>
  memset(buf, 0, nbuf);
     222:	8b 45 0c             	mov    0xc(%ebp),%eax
     225:	89 44 24 08          	mov    %eax,0x8(%esp)
     229:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     230:	00 
     231:	8b 45 08             	mov    0x8(%ebp),%eax
     234:	89 04 24             	mov    %eax,(%esp)
     237:	e8 7e 0b 00 00       	call   dba <memset>
  gets(buf, nbuf);
     23c:	8b 45 0c             	mov    0xc(%ebp),%eax
     23f:	89 44 24 04          	mov    %eax,0x4(%esp)
     243:	8b 45 08             	mov    0x8(%ebp),%eax
     246:	89 04 24             	mov    %eax,(%esp)
     249:	e8 c3 0b 00 00       	call   e11 <gets>
  if(buf[0] == 0) // EOF
     24e:	8b 45 08             	mov    0x8(%ebp),%eax
     251:	0f b6 00             	movzbl (%eax),%eax
     254:	84 c0                	test   %al,%al
     256:	75 07                	jne    25f <getcmd+0x57>
    return -1;
     258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25d:	eb 05                	jmp    264 <getcmd+0x5c>
  return 0;
     25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     264:	c9                   	leave  
     265:	c3                   	ret    

00000266 <main>:

int
main(void)
{
     266:	55                   	push   %ebp
     267:	89 e5                	mov    %esp,%ebp
     269:	83 e4 f0             	and    $0xfffffff0,%esp
     26c:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     26f:	eb 19                	jmp    28a <main+0x24>
    if(fd >= 3){
     271:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     276:	7e 12                	jle    28a <main+0x24>
      close(fd);
     278:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27c:	89 04 24             	mov    %eax,(%esp)
     27f:	e8 04 0d 00 00       	call   f88 <close>
      break;
     284:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     285:	e9 ae 00 00 00       	jmp    338 <main+0xd2>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     28a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     291:	00 
     292:	c7 04 24 f3 14 00 00 	movl   $0x14f3,(%esp)
     299:	e8 02 0d 00 00       	call   fa0 <open>
     29e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a2:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a7:	79 c8                	jns    271 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a9:	e9 8a 00 00 00       	jmp    338 <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ae:	0f b6 05 e0 15 00 00 	movzbl 0x15e0,%eax
     2b5:	3c 63                	cmp    $0x63,%al
     2b7:	75 5a                	jne    313 <main+0xad>
     2b9:	0f b6 05 e1 15 00 00 	movzbl 0x15e1,%eax
     2c0:	3c 64                	cmp    $0x64,%al
     2c2:	75 4f                	jne    313 <main+0xad>
     2c4:	0f b6 05 e2 15 00 00 	movzbl 0x15e2,%eax
     2cb:	3c 20                	cmp    $0x20,%al
     2cd:	75 44                	jne    313 <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2cf:	c7 04 24 e0 15 00 00 	movl   $0x15e0,(%esp)
     2d6:	e8 ba 0a 00 00       	call   d95 <strlen>
     2db:	83 e8 01             	sub    $0x1,%eax
     2de:	c6 80 e0 15 00 00 00 	movb   $0x0,0x15e0(%eax)
      if(chdir(buf+3) < 0)
     2e5:	c7 04 24 e3 15 00 00 	movl   $0x15e3,(%esp)
     2ec:	e8 df 0c 00 00       	call   fd0 <chdir>
     2f1:	85 c0                	test   %eax,%eax
     2f3:	79 42                	jns    337 <main+0xd1>
        printf(2, "cannot cd %s\n", buf+3);
     2f5:	c7 44 24 08 e3 15 00 	movl   $0x15e3,0x8(%esp)
     2fc:	00 
     2fd:	c7 44 24 04 fb 14 00 	movl   $0x14fb,0x4(%esp)
     304:	00 
     305:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30c:	e8 d3 0d 00 00       	call   10e4 <printf>
      continue;
     311:	eb 25                	jmp    338 <main+0xd2>
    }
    if(fork1() == 0)
     313:	e8 67 00 00 00       	call   37f <fork1>
     318:	85 c0                	test   %eax,%eax
     31a:	75 14                	jne    330 <main+0xca>
      runcmd(parsecmd(buf));
     31c:	c7 04 24 e0 15 00 00 	movl   $0x15e0,(%esp)
     323:	e8 c9 03 00 00       	call   6f1 <parsecmd>
     328:	89 04 24             	mov    %eax,(%esp)
     32b:	e8 d0 fc ff ff       	call   0 <runcmd>
    wait();
     330:	e8 33 0c 00 00       	call   f68 <wait>
     335:	eb 01                	jmp    338 <main+0xd2>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     337:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     338:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33f:	00 
     340:	c7 04 24 e0 15 00 00 	movl   $0x15e0,(%esp)
     347:	e8 bc fe ff ff       	call   208 <getcmd>
     34c:	85 c0                	test   %eax,%eax
     34e:	0f 89 5a ff ff ff    	jns    2ae <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     354:	e8 07 0c 00 00       	call   f60 <exit>

00000359 <panic>:
}

void
panic(char *s)
{
     359:	55                   	push   %ebp
     35a:	89 e5                	mov    %esp,%ebp
     35c:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     35f:	8b 45 08             	mov    0x8(%ebp),%eax
     362:	89 44 24 08          	mov    %eax,0x8(%esp)
     366:	c7 44 24 04 09 15 00 	movl   $0x1509,0x4(%esp)
     36d:	00 
     36e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     375:	e8 6a 0d 00 00       	call   10e4 <printf>
  exit();
     37a:	e8 e1 0b 00 00       	call   f60 <exit>

0000037f <fork1>:
}

int
fork1(void)
{
     37f:	55                   	push   %ebp
     380:	89 e5                	mov    %esp,%ebp
     382:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     385:	e8 ce 0b 00 00       	call   f58 <fork>
     38a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     391:	75 0c                	jne    39f <fork1+0x20>
    panic("fork");
     393:	c7 04 24 0d 15 00 00 	movl   $0x150d,(%esp)
     39a:	e8 ba ff ff ff       	call   359 <panic>
  return pid;
     39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a2:	c9                   	leave  
     3a3:	c3                   	ret    

000003a4 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a4:	55                   	push   %ebp
     3a5:	89 e5                	mov    %esp,%ebp
     3a7:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3aa:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3b1:	e8 15 10 00 00       	call   13cb <malloc>
     3b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3b9:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3c0:	00 
     3c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c8:	00 
     3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cc:	89 04 24             	mov    %eax,(%esp)
     3cf:	e8 e6 09 00 00       	call   dba <memset>
  cmd->type = EXEC;
     3d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e0:	c9                   	leave  
     3e1:	c3                   	ret    

000003e2 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e2:	55                   	push   %ebp
     3e3:	89 e5                	mov    %esp,%ebp
     3e5:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ef:	e8 d7 0f 00 00       	call   13cb <malloc>
     3f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f7:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fe:	00 
     3ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     406:	00 
     407:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40a:	89 04 24             	mov    %eax,(%esp)
     40d:	e8 a8 09 00 00       	call   dba <memset>
  cmd->type = REDIR;
     412:	8b 45 f4             	mov    -0xc(%ebp),%eax
     415:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41e:	8b 55 08             	mov    0x8(%ebp),%edx
     421:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     424:	8b 45 f4             	mov    -0xc(%ebp),%eax
     427:	8b 55 0c             	mov    0xc(%ebp),%edx
     42a:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     430:	8b 55 10             	mov    0x10(%ebp),%edx
     433:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     436:	8b 45 f4             	mov    -0xc(%ebp),%eax
     439:	8b 55 14             	mov    0x14(%ebp),%edx
     43c:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     442:	8b 55 18             	mov    0x18(%ebp),%edx
     445:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     448:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     44b:	c9                   	leave  
     44c:	c3                   	ret    

0000044d <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44d:	55                   	push   %ebp
     44e:	89 e5                	mov    %esp,%ebp
     450:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     453:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     45a:	e8 6c 0f 00 00       	call   13cb <malloc>
     45f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     462:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     469:	00 
     46a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     471:	00 
     472:	8b 45 f4             	mov    -0xc(%ebp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 3d 09 00 00       	call   dba <memset>
  cmd->type = PIPE;
     47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     480:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     486:	8b 45 f4             	mov    -0xc(%ebp),%eax
     489:	8b 55 08             	mov    0x8(%ebp),%edx
     48c:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     492:	8b 55 0c             	mov    0xc(%ebp),%edx
     495:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     498:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     49b:	c9                   	leave  
     49c:	c3                   	ret    

0000049d <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49d:	55                   	push   %ebp
     49e:	89 e5                	mov    %esp,%ebp
     4a0:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a3:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4aa:	e8 1c 0f 00 00       	call   13cb <malloc>
     4af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b2:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b9:	00 
     4ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4c1:	00 
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	89 04 24             	mov    %eax,(%esp)
     4c8:	e8 ed 08 00 00       	call   dba <memset>
  cmd->type = LIST;
     4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d0:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d9:	8b 55 08             	mov    0x8(%ebp),%edx
     4dc:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e2:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e5:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4eb:	c9                   	leave  
     4ec:	c3                   	ret    

000004ed <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4ed:	55                   	push   %ebp
     4ee:	89 e5                	mov    %esp,%ebp
     4f0:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4fa:	e8 cc 0e 00 00       	call   13cb <malloc>
     4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     502:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     509:	00 
     50a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     511:	00 
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	89 04 24             	mov    %eax,(%esp)
     518:	e8 9d 08 00 00       	call   dba <memset>
  cmd->type = BACK;
     51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     520:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     526:	8b 45 f4             	mov    -0xc(%ebp),%eax
     529:	8b 55 08             	mov    0x8(%ebp),%edx
     52c:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     532:	c9                   	leave  
     533:	c3                   	ret    

00000534 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     534:	55                   	push   %ebp
     535:	89 e5                	mov    %esp,%ebp
     537:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     53a:	8b 45 08             	mov    0x8(%ebp),%eax
     53d:	8b 00                	mov    (%eax),%eax
     53f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(s < es && strchr(whitespace, *s))
     542:	eb 04                	jmp    548 <gettoken+0x14>
    s++;
     544:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     548:	8b 45 f0             	mov    -0x10(%ebp),%eax
     54b:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54e:	73 1d                	jae    56d <gettoken+0x39>
     550:	8b 45 f0             	mov    -0x10(%ebp),%eax
     553:	0f b6 00             	movzbl (%eax),%eax
     556:	0f be c0             	movsbl %al,%eax
     559:	89 44 24 04          	mov    %eax,0x4(%esp)
     55d:	c7 04 24 a4 15 00 00 	movl   $0x15a4,(%esp)
     564:	e8 75 08 00 00       	call   dde <strchr>
     569:	85 c0                	test   %eax,%eax
     56b:	75 d7                	jne    544 <gettoken+0x10>
    s++;
  if(q)
     56d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     571:	74 08                	je     57b <gettoken+0x47>
    *q = s;
     573:	8b 45 10             	mov    0x10(%ebp),%eax
     576:	8b 55 f0             	mov    -0x10(%ebp),%edx
     579:	89 10                	mov    %edx,(%eax)
  ret = *s;
     57b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     57e:	0f b6 00             	movzbl (%eax),%eax
     581:	0f be c0             	movsbl %al,%eax
     584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  switch(*s){
     587:	8b 45 f0             	mov    -0x10(%ebp),%eax
     58a:	0f b6 00             	movzbl (%eax),%eax
     58d:	0f be c0             	movsbl %al,%eax
     590:	83 f8 3c             	cmp    $0x3c,%eax
     593:	7f 1e                	jg     5b3 <gettoken+0x7f>
     595:	83 f8 3b             	cmp    $0x3b,%eax
     598:	7d 23                	jge    5bd <gettoken+0x89>
     59a:	83 f8 29             	cmp    $0x29,%eax
     59d:	7f 3f                	jg     5de <gettoken+0xaa>
     59f:	83 f8 28             	cmp    $0x28,%eax
     5a2:	7d 19                	jge    5bd <gettoken+0x89>
     5a4:	85 c0                	test   %eax,%eax
     5a6:	0f 84 83 00 00 00    	je     62f <gettoken+0xfb>
     5ac:	83 f8 26             	cmp    $0x26,%eax
     5af:	74 0c                	je     5bd <gettoken+0x89>
     5b1:	eb 2b                	jmp    5de <gettoken+0xaa>
     5b3:	83 f8 3e             	cmp    $0x3e,%eax
     5b6:	74 0b                	je     5c3 <gettoken+0x8f>
     5b8:	83 f8 7c             	cmp    $0x7c,%eax
     5bb:	75 21                	jne    5de <gettoken+0xaa>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    break;
     5c1:	eb 70                	jmp    633 <gettoken+0xff>
  case '>':
    s++;
     5c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(*s == '>'){
     5c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ca:	0f b6 00             	movzbl (%eax),%eax
     5cd:	3c 3e                	cmp    $0x3e,%al
     5cf:	75 61                	jne    632 <gettoken+0xfe>
      ret = '+';
     5d1:	c7 45 f4 2b 00 00 00 	movl   $0x2b,-0xc(%ebp)
      s++;
     5d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    break;
     5dc:	eb 55                	jmp    633 <gettoken+0xff>
  default:
    ret = 'a';
     5de:	c7 45 f4 61 00 00 00 	movl   $0x61,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e5:	eb 04                	jmp    5eb <gettoken+0xb7>
      s++;
     5e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f1:	73 40                	jae    633 <gettoken+0xff>
     5f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5f6:	0f b6 00             	movzbl (%eax),%eax
     5f9:	0f be c0             	movsbl %al,%eax
     5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
     600:	c7 04 24 a4 15 00 00 	movl   $0x15a4,(%esp)
     607:	e8 d2 07 00 00       	call   dde <strchr>
     60c:	85 c0                	test   %eax,%eax
     60e:	75 23                	jne    633 <gettoken+0xff>
     610:	8b 45 f0             	mov    -0x10(%ebp),%eax
     613:	0f b6 00             	movzbl (%eax),%eax
     616:	0f be c0             	movsbl %al,%eax
     619:	89 44 24 04          	mov    %eax,0x4(%esp)
     61d:	c7 04 24 aa 15 00 00 	movl   $0x15aa,(%esp)
     624:	e8 b5 07 00 00       	call   dde <strchr>
     629:	85 c0                	test   %eax,%eax
     62b:	74 ba                	je     5e7 <gettoken+0xb3>
     62d:	eb 04                	jmp    633 <gettoken+0xff>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     62f:	90                   	nop
     630:	eb 01                	jmp    633 <gettoken+0xff>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     632:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     633:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     637:	74 10                	je     649 <gettoken+0x115>
    *eq = s;
     639:	8b 45 14             	mov    0x14(%ebp),%eax
     63c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     63f:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     641:	eb 07                	jmp    64a <gettoken+0x116>
    s++;
     643:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     647:	eb 01                	jmp    64a <gettoken+0x116>
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     649:	90                   	nop
     64a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     64d:	3b 45 0c             	cmp    0xc(%ebp),%eax
     650:	73 1d                	jae    66f <gettoken+0x13b>
     652:	8b 45 f0             	mov    -0x10(%ebp),%eax
     655:	0f b6 00             	movzbl (%eax),%eax
     658:	0f be c0             	movsbl %al,%eax
     65b:	89 44 24 04          	mov    %eax,0x4(%esp)
     65f:	c7 04 24 a4 15 00 00 	movl   $0x15a4,(%esp)
     666:	e8 73 07 00 00       	call   dde <strchr>
     66b:	85 c0                	test   %eax,%eax
     66d:	75 d4                	jne    643 <gettoken+0x10f>
    s++;
  *ps = s;
     66f:	8b 45 08             	mov    0x8(%ebp),%eax
     672:	8b 55 f0             	mov    -0x10(%ebp),%edx
     675:	89 10                	mov    %edx,(%eax)
  return ret;
     677:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     67a:	c9                   	leave  
     67b:	c3                   	ret    

0000067c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67c:	55                   	push   %ebp
     67d:	89 e5                	mov    %esp,%ebp
     67f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     682:	8b 45 08             	mov    0x8(%ebp),%eax
     685:	8b 00                	mov    (%eax),%eax
     687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68a:	eb 04                	jmp    690 <peek+0x14>
    s++;
     68c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     690:	8b 45 f4             	mov    -0xc(%ebp),%eax
     693:	3b 45 0c             	cmp    0xc(%ebp),%eax
     696:	73 1d                	jae    6b5 <peek+0x39>
     698:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69b:	0f b6 00             	movzbl (%eax),%eax
     69e:	0f be c0             	movsbl %al,%eax
     6a1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a5:	c7 04 24 a4 15 00 00 	movl   $0x15a4,(%esp)
     6ac:	e8 2d 07 00 00       	call   dde <strchr>
     6b1:	85 c0                	test   %eax,%eax
     6b3:	75 d7                	jne    68c <peek+0x10>
    s++;
  *ps = s;
     6b5:	8b 45 08             	mov    0x8(%ebp),%eax
     6b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bb:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c0:	0f b6 00             	movzbl (%eax),%eax
     6c3:	84 c0                	test   %al,%al
     6c5:	74 23                	je     6ea <peek+0x6e>
     6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ca:	0f b6 00             	movzbl (%eax),%eax
     6cd:	0f be c0             	movsbl %al,%eax
     6d0:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d4:	8b 45 10             	mov    0x10(%ebp),%eax
     6d7:	89 04 24             	mov    %eax,(%esp)
     6da:	e8 ff 06 00 00       	call   dde <strchr>
     6df:	85 c0                	test   %eax,%eax
     6e1:	74 07                	je     6ea <peek+0x6e>
     6e3:	b8 01 00 00 00       	mov    $0x1,%eax
     6e8:	eb 05                	jmp    6ef <peek+0x73>
     6ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6ef:	c9                   	leave  
     6f0:	c3                   	ret    

000006f1 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f1:	55                   	push   %ebp
     6f2:	89 e5                	mov    %esp,%ebp
     6f4:	53                   	push   %ebx
     6f5:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fb:	8b 45 08             	mov    0x8(%ebp),%eax
     6fe:	89 04 24             	mov    %eax,(%esp)
     701:	e8 8f 06 00 00       	call   d95 <strlen>
     706:	8d 04 03             	lea    (%ebx,%eax,1),%eax
     709:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 12 15 00 	movl   $0x1512,0x8(%esp)
     728:	00 
     729:	8b 45 f0             	mov    -0x10(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 41 ff ff ff       	call   67c <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x79>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 13 15 00 	movl   $0x1513,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 86 09 00 00       	call   10e4 <printf>
    panic("syntax");
     75e:	c7 04 24 22 15 00 00 	movl   $0x1522,(%esp)
     765:	e8 ef fb ff ff       	call   359 <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a4 04 00 00       	call   c19 <nulterminate>
  return cmd;
     775:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 77 fd ff ff       	call   534 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 25 fd ff ff       	call   4ed <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 29 15 00 	movl   $0x1529,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 97 fe ff ff       	call   67c <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 2b 15 00 	movl   $0x152b,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 79 fe ff ff       	call   67c <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 0b fd ff ff       	call   534 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 53 fc ff ff       	call   49d <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 67 02 00 00       	call   ad1 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 2d 15 00 	movl   $0x152d,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f5 fd ff ff       	call   67c <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 87 fc ff ff       	call   534 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 7f fb ff ff       	call   44d <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f5 00 00 00       	jmp    9d6 <parseredirs+0x100>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 31 fc ff ff       	call   534 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0e fc ff ff       	call   534 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 2f 15 00 00 	movl   $0x152f,(%esp)
     932:	e8 22 fa ff ff       	call   359 <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 88 00 00 00       	jmp    9d6 <parseredirs+0x100>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 6b fa ff ff       	call   3e2 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5a                	jmp    9d6 <parseredirs+0x100>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3d fa ff ff       	call   3e2 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2c                	jmp    9d6 <parseredirs+0x100>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 0f fa ff ff       	call   3e2 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d6:	c7 44 24 08 4c 15 00 	movl   $0x154c,0x8(%esp)
     9dd:	00 
     9de:	8b 45 10             	mov    0x10(%ebp),%eax
     9e1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e5:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e8:	89 04 24             	mov    %eax,(%esp)
     9eb:	e8 8c fc ff ff       	call   67c <peek>
     9f0:	85 c0                	test   %eax,%eax
     9f2:	0f 85 e9 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fb:	c9                   	leave  
     9fc:	c3                   	ret    

000009fd <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fd:	55                   	push   %ebp
     9fe:	89 e5                	mov    %esp,%ebp
     a00:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a03:	c7 44 24 08 4f 15 00 	movl   $0x154f,0x8(%esp)
     a0a:	00 
     a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
     a12:	8b 45 08             	mov    0x8(%ebp),%eax
     a15:	89 04 24             	mov    %eax,(%esp)
     a18:	e8 5f fc ff ff       	call   67c <peek>
     a1d:	85 c0                	test   %eax,%eax
     a1f:	75 0c                	jne    a2d <parseblock+0x30>
    panic("parseblock");
     a21:	c7 04 24 51 15 00 00 	movl   $0x1551,(%esp)
     a28:	e8 2c f9 ff ff       	call   359 <panic>
  gettoken(ps, es, 0, 0);
     a2d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a34:	00 
     a35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3c:	00 
     a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a40:	89 44 24 04          	mov    %eax,0x4(%esp)
     a44:	8b 45 08             	mov    0x8(%ebp),%eax
     a47:	89 04 24             	mov    %eax,(%esp)
     a4a:	e8 e5 fa ff ff       	call   534 <gettoken>
  cmd = parseline(ps, es);
     a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
     a52:	89 44 24 04          	mov    %eax,0x4(%esp)
     a56:	8b 45 08             	mov    0x8(%ebp),%eax
     a59:	89 04 24             	mov    %eax,(%esp)
     a5c:	e8 1d fd ff ff       	call   77e <parseline>
     a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a64:	c7 44 24 08 5c 15 00 	movl   $0x155c,0x8(%esp)
     a6b:	00 
     a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a73:	8b 45 08             	mov    0x8(%ebp),%eax
     a76:	89 04 24             	mov    %eax,(%esp)
     a79:	e8 fe fb ff ff       	call   67c <peek>
     a7e:	85 c0                	test   %eax,%eax
     a80:	75 0c                	jne    a8e <parseblock+0x91>
    panic("syntax - missing )");
     a82:	c7 04 24 5e 15 00 00 	movl   $0x155e,(%esp)
     a89:	e8 cb f8 ff ff       	call   359 <panic>
  gettoken(ps, es, 0, 0);
     a8e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a95:	00 
     a96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9d:	00 
     a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa5:	8b 45 08             	mov    0x8(%ebp),%eax
     aa8:	89 04 24             	mov    %eax,(%esp)
     aab:	e8 84 fa ff ff       	call   534 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab3:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab7:	8b 45 08             	mov    0x8(%ebp),%eax
     aba:	89 44 24 04          	mov    %eax,0x4(%esp)
     abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac1:	89 04 24             	mov    %eax,(%esp)
     ac4:	e8 0d fe ff ff       	call   8d6 <parseredirs>
     ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     acf:	c9                   	leave  
     ad0:	c3                   	ret    

00000ad1 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad1:	55                   	push   %ebp
     ad2:	89 e5                	mov    %esp,%ebp
     ad4:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad7:	c7 44 24 08 4f 15 00 	movl   $0x154f,0x8(%esp)
     ade:	00 
     adf:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae6:	8b 45 08             	mov    0x8(%ebp),%eax
     ae9:	89 04 24             	mov    %eax,(%esp)
     aec:	e8 8b fb ff ff       	call   67c <peek>
     af1:	85 c0                	test   %eax,%eax
     af3:	74 17                	je     b0c <parseexec+0x3b>
    return parseblock(ps, es);
     af5:	8b 45 0c             	mov    0xc(%ebp),%eax
     af8:	89 44 24 04          	mov    %eax,0x4(%esp)
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
     aff:	89 04 24             	mov    %eax,(%esp)
     b02:	e8 f6 fe ff ff       	call   9fd <parseblock>
     b07:	e9 0b 01 00 00       	jmp    c17 <parseexec+0x146>

  ret = execcmd();
     b0c:	e8 93 f8 ff ff       	call   3a4 <execcmd>
     b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = (struct execcmd*)ret;
     b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b17:	89 45 f0             	mov    %eax,-0x10(%ebp)

  argc = 0;
     b1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ret = parseredirs(ret, ps, es);
     b21:	8b 45 0c             	mov    0xc(%ebp),%eax
     b24:	89 44 24 08          	mov    %eax,0x8(%esp)
     b28:	8b 45 08             	mov    0x8(%ebp),%eax
     b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
     b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b32:	89 04 24             	mov    %eax,(%esp)
     b35:	e8 9c fd ff ff       	call   8d6 <parseredirs>
     b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3d:	e9 8e 00 00 00       	jmp    bd0 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b42:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b45:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4c:	89 44 24 08          	mov    %eax,0x8(%esp)
     b50:	8b 45 0c             	mov    0xc(%ebp),%eax
     b53:	89 44 24 04          	mov    %eax,0x4(%esp)
     b57:	8b 45 08             	mov    0x8(%ebp),%eax
     b5a:	89 04 24             	mov    %eax,(%esp)
     b5d:	e8 d2 f9 ff ff       	call   534 <gettoken>
     b62:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b69:	0f 84 85 00 00 00    	je     bf4 <parseexec+0x123>
      break;
    if(tok != 'a')
     b6f:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b73:	74 0c                	je     b81 <parseexec+0xb0>
      panic("syntax");
     b75:	c7 04 24 22 15 00 00 	movl   $0x1522,(%esp)
     b7c:	e8 d8 f7 ff ff       	call   359 <panic>
    cmd->argv[argc] = q;
     b81:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b84:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b8a:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b8e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
     b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b97:	83 c1 08             	add    $0x8,%ecx
     b9a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b9e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(argc >= MAXARGS)
     ba2:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
     ba6:	7e 0c                	jle    bb4 <parseexec+0xe3>
      panic("too many args");
     ba8:	c7 04 24 71 15 00 00 	movl   $0x1571,(%esp)
     baf:	e8 a5 f7 ff ff       	call   359 <panic>
    ret = parseredirs(ret, ps, es);
     bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbb:	8b 45 08             	mov    0x8(%ebp),%eax
     bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc5:	89 04 24             	mov    %eax,(%esp)
     bc8:	e8 09 fd ff ff       	call   8d6 <parseredirs>
     bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd0:	c7 44 24 08 7f 15 00 	movl   $0x157f,0x8(%esp)
     bd7:	00 
     bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	89 04 24             	mov    %eax,(%esp)
     be5:	e8 92 fa ff ff       	call   67c <peek>
     bea:	85 c0                	test   %eax,%eax
     bec:	0f 84 50 ff ff ff    	je     b42 <parseexec+0x71>
     bf2:	eb 01                	jmp    bf5 <parseexec+0x124>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     bf4:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf5:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bfb:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c02:	00 
  cmd->eargv[argc] = 0;
     c03:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c09:	83 c2 08             	add    $0x8,%edx
     c0c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c13:	00 
  return ret;
     c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c17:	c9                   	leave  
     c18:	c3                   	ret    

00000c19 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c19:	55                   	push   %ebp
     c1a:	89 e5                	mov    %esp,%ebp
     c1c:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c23:	75 0a                	jne    c2f <nulterminate+0x16>
    return 0;
     c25:	b8 00 00 00 00       	mov    $0x0,%eax
     c2a:	e9 c8 00 00 00       	jmp    cf7 <nulterminate+0xde>
  
  switch(cmd->type){
     c2f:	8b 45 08             	mov    0x8(%ebp),%eax
     c32:	8b 00                	mov    (%eax),%eax
     c34:	83 f8 05             	cmp    $0x5,%eax
     c37:	0f 87 b7 00 00 00    	ja     cf4 <nulterminate+0xdb>
     c3d:	8b 04 85 84 15 00 00 	mov    0x1584(,%eax,4),%eax
     c44:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c46:	8b 45 08             	mov    0x8(%ebp),%eax
     c49:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     c53:	eb 14                	jmp    c69 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c5b:	83 c2 08             	add    $0x8,%edx
     c5e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c62:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c65:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
     c69:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c6f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c73:	85 c0                	test   %eax,%eax
     c75:	75 de                	jne    c55 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c77:	eb 7b                	jmp    cf4 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c79:	8b 45 08             	mov    0x8(%ebp),%eax
     c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    nulterminate(rcmd->cmd);
     c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c82:	8b 40 04             	mov    0x4(%eax),%eax
     c85:	89 04 24             	mov    %eax,(%esp)
     c88:	e8 8c ff ff ff       	call   c19 <nulterminate>
    *rcmd->efile = 0;
     c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c90:	8b 40 0c             	mov    0xc(%eax),%eax
     c93:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c96:	eb 5c                	jmp    cf4 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c98:	8b 45 08             	mov    0x8(%ebp),%eax
     c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(pcmd->left);
     c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ca1:	8b 40 04             	mov    0x4(%eax),%eax
     ca4:	89 04 24             	mov    %eax,(%esp)
     ca7:	e8 6d ff ff ff       	call   c19 <nulterminate>
    nulterminate(pcmd->right);
     cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     caf:	8b 40 08             	mov    0x8(%eax),%eax
     cb2:	89 04 24             	mov    %eax,(%esp)
     cb5:	e8 5f ff ff ff       	call   c19 <nulterminate>
    break;
     cba:	eb 38                	jmp    cf4 <nulterminate+0xdb>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbc:	8b 45 08             	mov    0x8(%ebp),%eax
     cbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc5:	8b 40 04             	mov    0x4(%eax),%eax
     cc8:	89 04 24             	mov    %eax,(%esp)
     ccb:	e8 49 ff ff ff       	call   c19 <nulterminate>
    nulterminate(lcmd->right);
     cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd3:	8b 40 08             	mov    0x8(%eax),%eax
     cd6:	89 04 24             	mov    %eax,(%esp)
     cd9:	e8 3b ff ff ff       	call   c19 <nulterminate>
    break;
     cde:	eb 14                	jmp    cf4 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     ce0:	8b 45 08             	mov    0x8(%ebp),%eax
     ce3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(bcmd->cmd);
     ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ce9:	8b 40 04             	mov    0x4(%eax),%eax
     cec:	89 04 24             	mov    %eax,(%esp)
     cef:	e8 25 ff ff ff       	call   c19 <nulterminate>
    break;
  }
  return cmd;
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    
     cf9:	90                   	nop
     cfa:	90                   	nop
     cfb:	90                   	nop

00000cfc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cfc:	55                   	push   %ebp
     cfd:	89 e5                	mov    %esp,%ebp
     cff:	57                   	push   %edi
     d00:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d01:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d04:	8b 55 10             	mov    0x10(%ebp),%edx
     d07:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0a:	89 cb                	mov    %ecx,%ebx
     d0c:	89 df                	mov    %ebx,%edi
     d0e:	89 d1                	mov    %edx,%ecx
     d10:	fc                   	cld    
     d11:	f3 aa                	rep stos %al,%es:(%edi)
     d13:	89 ca                	mov    %ecx,%edx
     d15:	89 fb                	mov    %edi,%ebx
     d17:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d1a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1d:	5b                   	pop    %ebx
     d1e:	5f                   	pop    %edi
     d1f:	5d                   	pop    %ebp
     d20:	c3                   	ret    

00000d21 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d21:	55                   	push   %ebp
     d22:	89 e5                	mov    %esp,%ebp
     d24:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d27:	8b 45 08             	mov    0x8(%ebp),%eax
     d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d30:	0f b6 10             	movzbl (%eax),%edx
     d33:	8b 45 08             	mov    0x8(%ebp),%eax
     d36:	88 10                	mov    %dl,(%eax)
     d38:	8b 45 08             	mov    0x8(%ebp),%eax
     d3b:	0f b6 00             	movzbl (%eax),%eax
     d3e:	84 c0                	test   %al,%al
     d40:	0f 95 c0             	setne  %al
     d43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d47:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     d4b:	84 c0                	test   %al,%al
     d4d:	75 de                	jne    d2d <strcpy+0xc>
    ;
  return os;
     d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d52:	c9                   	leave  
     d53:	c3                   	ret    

00000d54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d54:	55                   	push   %ebp
     d55:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d57:	eb 08                	jmp    d61 <strcmp+0xd>
    p++, q++;
     d59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d5d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d61:	8b 45 08             	mov    0x8(%ebp),%eax
     d64:	0f b6 00             	movzbl (%eax),%eax
     d67:	84 c0                	test   %al,%al
     d69:	74 10                	je     d7b <strcmp+0x27>
     d6b:	8b 45 08             	mov    0x8(%ebp),%eax
     d6e:	0f b6 10             	movzbl (%eax),%edx
     d71:	8b 45 0c             	mov    0xc(%ebp),%eax
     d74:	0f b6 00             	movzbl (%eax),%eax
     d77:	38 c2                	cmp    %al,%dl
     d79:	74 de                	je     d59 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d7b:	8b 45 08             	mov    0x8(%ebp),%eax
     d7e:	0f b6 00             	movzbl (%eax),%eax
     d81:	0f b6 d0             	movzbl %al,%edx
     d84:	8b 45 0c             	mov    0xc(%ebp),%eax
     d87:	0f b6 00             	movzbl (%eax),%eax
     d8a:	0f b6 c0             	movzbl %al,%eax
     d8d:	89 d1                	mov    %edx,%ecx
     d8f:	29 c1                	sub    %eax,%ecx
     d91:	89 c8                	mov    %ecx,%eax
}
     d93:	5d                   	pop    %ebp
     d94:	c3                   	ret    

00000d95 <strlen>:

uint
strlen(char *s)
{
     d95:	55                   	push   %ebp
     d96:	89 e5                	mov    %esp,%ebp
     d98:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     da2:	eb 04                	jmp    da8 <strlen+0x13>
     da4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     dab:	03 45 08             	add    0x8(%ebp),%eax
     dae:	0f b6 00             	movzbl (%eax),%eax
     db1:	84 c0                	test   %al,%al
     db3:	75 ef                	jne    da4 <strlen+0xf>
    ;
  return n;
     db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     db8:	c9                   	leave  
     db9:	c3                   	ret    

00000dba <memset>:

void*
memset(void *dst, int c, uint n)
{
     dba:	55                   	push   %ebp
     dbb:	89 e5                	mov    %esp,%ebp
     dbd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     dc0:	8b 45 10             	mov    0x10(%ebp),%eax
     dc3:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
     dca:	89 44 24 04          	mov    %eax,0x4(%esp)
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	89 04 24             	mov    %eax,(%esp)
     dd4:	e8 23 ff ff ff       	call   cfc <stosb>
  return dst;
     dd9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ddc:	c9                   	leave  
     ddd:	c3                   	ret    

00000dde <strchr>:

char*
strchr(const char *s, char c)
{
     dde:	55                   	push   %ebp
     ddf:	89 e5                	mov    %esp,%ebp
     de1:	83 ec 04             	sub    $0x4,%esp
     de4:	8b 45 0c             	mov    0xc(%ebp),%eax
     de7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     dea:	eb 14                	jmp    e00 <strchr+0x22>
    if(*s == c)
     dec:	8b 45 08             	mov    0x8(%ebp),%eax
     def:	0f b6 00             	movzbl (%eax),%eax
     df2:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df5:	75 05                	jne    dfc <strchr+0x1e>
      return (char*)s;
     df7:	8b 45 08             	mov    0x8(%ebp),%eax
     dfa:	eb 13                	jmp    e0f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     dfc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     e00:	8b 45 08             	mov    0x8(%ebp),%eax
     e03:	0f b6 00             	movzbl (%eax),%eax
     e06:	84 c0                	test   %al,%al
     e08:	75 e2                	jne    dec <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e0f:	c9                   	leave  
     e10:	c3                   	ret    

00000e11 <gets>:

char*
gets(char *buf, int max)
{
     e11:	55                   	push   %ebp
     e12:	89 e5                	mov    %esp,%ebp
     e14:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     e1e:	eb 44                	jmp    e64 <gets+0x53>
    cc = read(0, &c, 1);
     e20:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e27:	00 
     e28:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e36:	e8 3d 01 00 00       	call   f78 <read>
     e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
     e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e42:	7e 2d                	jle    e71 <gets+0x60>
      break;
    buf[i++] = c;
     e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e47:	03 45 08             	add    0x8(%ebp),%eax
     e4a:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     e4e:	88 10                	mov    %dl,(%eax)
     e50:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
     e54:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e58:	3c 0a                	cmp    $0xa,%al
     e5a:	74 16                	je     e72 <gets+0x61>
     e5c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e60:	3c 0d                	cmp    $0xd,%al
     e62:	74 0e                	je     e72 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e67:	83 c0 01             	add    $0x1,%eax
     e6a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e6d:	7c b1                	jl     e20 <gets+0xf>
     e6f:	eb 01                	jmp    e72 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     e71:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e75:	03 45 08             	add    0x8(%ebp),%eax
     e78:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e7e:	c9                   	leave  
     e7f:	c3                   	ret    

00000e80 <stat>:

int
stat(char *n, struct stat *st)
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e8d:	00 
     e8e:	8b 45 08             	mov    0x8(%ebp),%eax
     e91:	89 04 24             	mov    %eax,(%esp)
     e94:	e8 07 01 00 00       	call   fa0 <open>
     e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
     e9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ea0:	79 07                	jns    ea9 <stat+0x29>
    return -1;
     ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea7:	eb 23                	jmp    ecc <stat+0x4c>
  r = fstat(fd, st);
     ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
     eac:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eb3:	89 04 24             	mov    %eax,(%esp)
     eb6:	e8 fd 00 00 00       	call   fb8 <fstat>
     ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
     ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ec1:	89 04 24             	mov    %eax,(%esp)
     ec4:	e8 bf 00 00 00       	call   f88 <close>
  return r;
     ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ecc:	c9                   	leave  
     ecd:	c3                   	ret    

00000ece <atoi>:

int
atoi(const char *s)
{
     ece:	55                   	push   %ebp
     ecf:	89 e5                	mov    %esp,%ebp
     ed1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     edb:	eb 24                	jmp    f01 <atoi+0x33>
    n = n*10 + *s++ - '0';
     edd:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ee0:	89 d0                	mov    %edx,%eax
     ee2:	c1 e0 02             	shl    $0x2,%eax
     ee5:	01 d0                	add    %edx,%eax
     ee7:	01 c0                	add    %eax,%eax
     ee9:	89 c2                	mov    %eax,%edx
     eeb:	8b 45 08             	mov    0x8(%ebp),%eax
     eee:	0f b6 00             	movzbl (%eax),%eax
     ef1:	0f be c0             	movsbl %al,%eax
     ef4:	8d 04 02             	lea    (%edx,%eax,1),%eax
     ef7:	83 e8 30             	sub    $0x30,%eax
     efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
     efd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f01:	8b 45 08             	mov    0x8(%ebp),%eax
     f04:	0f b6 00             	movzbl (%eax),%eax
     f07:	3c 2f                	cmp    $0x2f,%al
     f09:	7e 0a                	jle    f15 <atoi+0x47>
     f0b:	8b 45 08             	mov    0x8(%ebp),%eax
     f0e:	0f b6 00             	movzbl (%eax),%eax
     f11:	3c 39                	cmp    $0x39,%al
     f13:	7e c8                	jle    edd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f18:	c9                   	leave  
     f19:	c3                   	ret    

00000f1a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f1a:	55                   	push   %ebp
     f1b:	89 e5                	mov    %esp,%ebp
     f1d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f20:	8b 45 08             	mov    0x8(%ebp),%eax
     f23:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
     f26:	8b 45 0c             	mov    0xc(%ebp),%eax
     f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
     f2c:	eb 13                	jmp    f41 <memmove+0x27>
    *dst++ = *src++;
     f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f31:	0f b6 10             	movzbl (%eax),%edx
     f34:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f37:	88 10                	mov    %dl,(%eax)
     f39:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     f3d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f45:	0f 9f c0             	setg   %al
     f48:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     f4c:	84 c0                	test   %al,%al
     f4e:	75 de                	jne    f2e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f53:	c9                   	leave  
     f54:	c3                   	ret    
     f55:	90                   	nop
     f56:	90                   	nop
     f57:	90                   	nop

00000f58 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f58:	b8 01 00 00 00       	mov    $0x1,%eax
     f5d:	cd 40                	int    $0x40
     f5f:	c3                   	ret    

00000f60 <exit>:
SYSCALL(exit)
     f60:	b8 02 00 00 00       	mov    $0x2,%eax
     f65:	cd 40                	int    $0x40
     f67:	c3                   	ret    

00000f68 <wait>:
SYSCALL(wait)
     f68:	b8 03 00 00 00       	mov    $0x3,%eax
     f6d:	cd 40                	int    $0x40
     f6f:	c3                   	ret    

00000f70 <pipe>:
SYSCALL(pipe)
     f70:	b8 04 00 00 00       	mov    $0x4,%eax
     f75:	cd 40                	int    $0x40
     f77:	c3                   	ret    

00000f78 <read>:
SYSCALL(read)
     f78:	b8 05 00 00 00       	mov    $0x5,%eax
     f7d:	cd 40                	int    $0x40
     f7f:	c3                   	ret    

00000f80 <write>:
SYSCALL(write)
     f80:	b8 10 00 00 00       	mov    $0x10,%eax
     f85:	cd 40                	int    $0x40
     f87:	c3                   	ret    

00000f88 <close>:
SYSCALL(close)
     f88:	b8 15 00 00 00       	mov    $0x15,%eax
     f8d:	cd 40                	int    $0x40
     f8f:	c3                   	ret    

00000f90 <kill>:
SYSCALL(kill)
     f90:	b8 06 00 00 00       	mov    $0x6,%eax
     f95:	cd 40                	int    $0x40
     f97:	c3                   	ret    

00000f98 <exec>:
SYSCALL(exec)
     f98:	b8 07 00 00 00       	mov    $0x7,%eax
     f9d:	cd 40                	int    $0x40
     f9f:	c3                   	ret    

00000fa0 <open>:
SYSCALL(open)
     fa0:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa5:	cd 40                	int    $0x40
     fa7:	c3                   	ret    

00000fa8 <mknod>:
SYSCALL(mknod)
     fa8:	b8 11 00 00 00       	mov    $0x11,%eax
     fad:	cd 40                	int    $0x40
     faf:	c3                   	ret    

00000fb0 <unlink>:
SYSCALL(unlink)
     fb0:	b8 12 00 00 00       	mov    $0x12,%eax
     fb5:	cd 40                	int    $0x40
     fb7:	c3                   	ret    

00000fb8 <fstat>:
SYSCALL(fstat)
     fb8:	b8 08 00 00 00       	mov    $0x8,%eax
     fbd:	cd 40                	int    $0x40
     fbf:	c3                   	ret    

00000fc0 <link>:
SYSCALL(link)
     fc0:	b8 13 00 00 00       	mov    $0x13,%eax
     fc5:	cd 40                	int    $0x40
     fc7:	c3                   	ret    

00000fc8 <mkdir>:
SYSCALL(mkdir)
     fc8:	b8 14 00 00 00       	mov    $0x14,%eax
     fcd:	cd 40                	int    $0x40
     fcf:	c3                   	ret    

00000fd0 <chdir>:
SYSCALL(chdir)
     fd0:	b8 09 00 00 00       	mov    $0x9,%eax
     fd5:	cd 40                	int    $0x40
     fd7:	c3                   	ret    

00000fd8 <dup>:
SYSCALL(dup)
     fd8:	b8 0a 00 00 00       	mov    $0xa,%eax
     fdd:	cd 40                	int    $0x40
     fdf:	c3                   	ret    

00000fe0 <getpid>:
SYSCALL(getpid)
     fe0:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe5:	cd 40                	int    $0x40
     fe7:	c3                   	ret    

00000fe8 <sbrk>:
SYSCALL(sbrk)
     fe8:	b8 0c 00 00 00       	mov    $0xc,%eax
     fed:	cd 40                	int    $0x40
     fef:	c3                   	ret    

00000ff0 <sleep>:
SYSCALL(sleep)
     ff0:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff5:	cd 40                	int    $0x40
     ff7:	c3                   	ret    

00000ff8 <uptime>:
SYSCALL(uptime)
     ff8:	b8 0e 00 00 00       	mov    $0xe,%eax
     ffd:	cd 40                	int    $0x40
     fff:	c3                   	ret    

00001000 <count>:
//add
SYSCALL(count)
    1000:	b8 16 00 00 00       	mov    $0x16,%eax
    1005:	cd 40                	int    $0x40
    1007:	c3                   	ret    

00001008 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1008:	55                   	push   %ebp
    1009:	89 e5                	mov    %esp,%ebp
    100b:	83 ec 28             	sub    $0x28,%esp
    100e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1011:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1014:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    101b:	00 
    101c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    101f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1023:	8b 45 08             	mov    0x8(%ebp),%eax
    1026:	89 04 24             	mov    %eax,(%esp)
    1029:	e8 52 ff ff ff       	call   f80 <write>
}
    102e:	c9                   	leave  
    102f:	c3                   	ret    

00001030 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1037:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    103e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1042:	74 17                	je     105b <printint+0x2b>
    1044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1048:	79 11                	jns    105b <printint+0x2b>
    neg = 1;
    104a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1051:	8b 45 0c             	mov    0xc(%ebp),%eax
    1054:	f7 d8                	neg    %eax
    1056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1059:	eb 06                	jmp    1061 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    105b:	8b 45 0c             	mov    0xc(%ebp),%eax
    105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
    1061:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
    1068:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    106b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    106e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1071:	ba 00 00 00 00       	mov    $0x0,%edx
    1076:	f7 f3                	div    %ebx
    1078:	89 d0                	mov    %edx,%eax
    107a:	0f b6 80 b4 15 00 00 	movzbl 0x15b4(%eax),%eax
    1081:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    1085:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
    1089:	8b 45 10             	mov    0x10(%ebp),%eax
    108c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    108f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1092:	ba 00 00 00 00       	mov    $0x0,%edx
    1097:	f7 75 d4             	divl   -0x2c(%ebp)
    109a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    109d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a1:	75 c5                	jne    1068 <printint+0x38>
  if(neg)
    10a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a7:	74 2a                	je     10d3 <printint+0xa3>
    buf[i++] = '-';
    10a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    10b1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
    10b5:	eb 1d                	jmp    10d4 <printint+0xa4>
    putc(fd, buf[i]);
    10b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10ba:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    10bf:	0f be c0             	movsbl %al,%eax
    10c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c6:	8b 45 08             	mov    0x8(%ebp),%eax
    10c9:	89 04 24             	mov    %eax,(%esp)
    10cc:	e8 37 ff ff ff       	call   1008 <putc>
    10d1:	eb 01                	jmp    10d4 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10d3:	90                   	nop
    10d4:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    10d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10dc:	79 d9                	jns    10b7 <printint+0x87>
    putc(fd, buf[i]);
}
    10de:	83 c4 44             	add    $0x44,%esp
    10e1:	5b                   	pop    %ebx
    10e2:	5d                   	pop    %ebp
    10e3:	c3                   	ret    

000010e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
    10e7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10f1:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f4:	83 c0 04             	add    $0x4,%eax
    10f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
    10fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1101:	e9 7e 01 00 00       	jmp    1284 <printf+0x1a0>
    c = fmt[i] & 0xff;
    1106:	8b 55 0c             	mov    0xc(%ebp),%edx
    1109:	8b 45 ec             	mov    -0x14(%ebp),%eax
    110c:	8d 04 02             	lea    (%edx,%eax,1),%eax
    110f:	0f b6 00             	movzbl (%eax),%eax
    1112:	0f be c0             	movsbl %al,%eax
    1115:	25 ff 00 00 00       	and    $0xff,%eax
    111a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
    111d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1121:	75 2c                	jne    114f <printf+0x6b>
      if(c == '%'){
    1123:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1127:	75 0c                	jne    1135 <printf+0x51>
        state = '%';
    1129:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    1130:	e9 4b 01 00 00       	jmp    1280 <printf+0x19c>
      } else {
        putc(fd, c);
    1135:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1138:	0f be c0             	movsbl %al,%eax
    113b:	89 44 24 04          	mov    %eax,0x4(%esp)
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
    1142:	89 04 24             	mov    %eax,(%esp)
    1145:	e8 be fe ff ff       	call   1008 <putc>
    114a:	e9 31 01 00 00       	jmp    1280 <printf+0x19c>
      }
    } else if(state == '%'){
    114f:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    1153:	0f 85 27 01 00 00    	jne    1280 <printf+0x19c>
      if(c == 'd'){
    1159:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    115d:	75 2d                	jne    118c <printf+0xa8>
        printint(fd, *ap, 10, 1);
    115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1162:	8b 00                	mov    (%eax),%eax
    1164:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    116b:	00 
    116c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1173:	00 
    1174:	89 44 24 04          	mov    %eax,0x4(%esp)
    1178:	8b 45 08             	mov    0x8(%ebp),%eax
    117b:	89 04 24             	mov    %eax,(%esp)
    117e:	e8 ad fe ff ff       	call   1030 <printint>
        ap++;
    1183:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1187:	e9 ed 00 00 00       	jmp    1279 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
    118c:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    1190:	74 06                	je     1198 <printf+0xb4>
    1192:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    1196:	75 2d                	jne    11c5 <printf+0xe1>
        printint(fd, *ap, 16, 0);
    1198:	8b 45 f4             	mov    -0xc(%ebp),%eax
    119b:	8b 00                	mov    (%eax),%eax
    119d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11a4:	00 
    11a5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11ac:	00 
    11ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b1:	8b 45 08             	mov    0x8(%ebp),%eax
    11b4:	89 04 24             	mov    %eax,(%esp)
    11b7:	e8 74 fe ff ff       	call   1030 <printint>
        ap++;
    11bc:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    11c0:	e9 b4 00 00 00       	jmp    1279 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    11c5:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    11c9:	75 46                	jne    1211 <printf+0x12d>
        s = (char*)*ap;
    11cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ce:	8b 00                	mov    (%eax),%eax
    11d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
    11d3:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
    11d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    11db:	75 27                	jne    1204 <printf+0x120>
          s = "(null)";
    11dd:	c7 45 e4 9c 15 00 00 	movl   $0x159c,-0x1c(%ebp)
        while(*s != 0){
    11e4:	eb 1f                	jmp    1205 <printf+0x121>
          putc(fd, *s);
    11e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11e9:	0f b6 00             	movzbl (%eax),%eax
    11ec:	0f be c0             	movsbl %al,%eax
    11ef:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f3:	8b 45 08             	mov    0x8(%ebp),%eax
    11f6:	89 04 24             	mov    %eax,(%esp)
    11f9:	e8 0a fe ff ff       	call   1008 <putc>
          s++;
    11fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    1202:	eb 01                	jmp    1205 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1204:	90                   	nop
    1205:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1208:	0f b6 00             	movzbl (%eax),%eax
    120b:	84 c0                	test   %al,%al
    120d:	75 d7                	jne    11e6 <printf+0x102>
    120f:	eb 68                	jmp    1279 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1211:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    1215:	75 1d                	jne    1234 <printf+0x150>
        putc(fd, *ap);
    1217:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121a:	8b 00                	mov    (%eax),%eax
    121c:	0f be c0             	movsbl %al,%eax
    121f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	89 04 24             	mov    %eax,(%esp)
    1229:	e8 da fd ff ff       	call   1008 <putc>
        ap++;
    122e:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    1232:	eb 45                	jmp    1279 <printf+0x195>
      } else if(c == '%'){
    1234:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    1238:	75 17                	jne    1251 <printf+0x16d>
        putc(fd, c);
    123a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    123d:	0f be c0             	movsbl %al,%eax
    1240:	89 44 24 04          	mov    %eax,0x4(%esp)
    1244:	8b 45 08             	mov    0x8(%ebp),%eax
    1247:	89 04 24             	mov    %eax,(%esp)
    124a:	e8 b9 fd ff ff       	call   1008 <putc>
    124f:	eb 28                	jmp    1279 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1251:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1258:	00 
    1259:	8b 45 08             	mov    0x8(%ebp),%eax
    125c:	89 04 24             	mov    %eax,(%esp)
    125f:	e8 a4 fd ff ff       	call   1008 <putc>
        putc(fd, c);
    1264:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1267:	0f be c0             	movsbl %al,%eax
    126a:	89 44 24 04          	mov    %eax,0x4(%esp)
    126e:	8b 45 08             	mov    0x8(%ebp),%eax
    1271:	89 04 24             	mov    %eax,(%esp)
    1274:	e8 8f fd ff ff       	call   1008 <putc>
      }
      state = 0;
    1279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1280:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1284:	8b 55 0c             	mov    0xc(%ebp),%edx
    1287:	8b 45 ec             	mov    -0x14(%ebp),%eax
    128a:	8d 04 02             	lea    (%edx,%eax,1),%eax
    128d:	0f b6 00             	movzbl (%eax),%eax
    1290:	84 c0                	test   %al,%al
    1292:	0f 85 6e fe ff ff    	jne    1106 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1298:	c9                   	leave  
    1299:	c3                   	ret    
    129a:	90                   	nop
    129b:	90                   	nop

0000129c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12a2:	8b 45 08             	mov    0x8(%ebp),%eax
    12a5:	83 e8 08             	sub    $0x8,%eax
    12a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ab:	a1 4c 16 00 00       	mov    0x164c,%eax
    12b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12b3:	eb 24                	jmp    12d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b8:	8b 00                	mov    (%eax),%eax
    12ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12bd:	77 12                	ja     12d1 <free+0x35>
    12bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12c5:	77 24                	ja     12eb <free+0x4f>
    12c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12ca:	8b 00                	mov    (%eax),%eax
    12cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12cf:	77 1a                	ja     12eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d4:	8b 00                	mov    (%eax),%eax
    12d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12df:	76 d4                	jbe    12b5 <free+0x19>
    12e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e4:	8b 00                	mov    (%eax),%eax
    12e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e9:	76 ca                	jbe    12b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ee:	8b 40 04             	mov    0x4(%eax),%eax
    12f1:	c1 e0 03             	shl    $0x3,%eax
    12f4:	89 c2                	mov    %eax,%edx
    12f6:	03 55 f8             	add    -0x8(%ebp),%edx
    12f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fc:	8b 00                	mov    (%eax),%eax
    12fe:	39 c2                	cmp    %eax,%edx
    1300:	75 24                	jne    1326 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    1302:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1305:	8b 50 04             	mov    0x4(%eax),%edx
    1308:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130b:	8b 00                	mov    (%eax),%eax
    130d:	8b 40 04             	mov    0x4(%eax),%eax
    1310:	01 c2                	add    %eax,%edx
    1312:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1315:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1318:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131b:	8b 00                	mov    (%eax),%eax
    131d:	8b 10                	mov    (%eax),%edx
    131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1322:	89 10                	mov    %edx,(%eax)
    1324:	eb 0a                	jmp    1330 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    1326:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1329:	8b 10                	mov    (%eax),%edx
    132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    132e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1330:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1333:	8b 40 04             	mov    0x4(%eax),%eax
    1336:	c1 e0 03             	shl    $0x3,%eax
    1339:	03 45 fc             	add    -0x4(%ebp),%eax
    133c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    133f:	75 20                	jne    1361 <free+0xc5>
    p->s.size += bp->s.size;
    1341:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1344:	8b 50 04             	mov    0x4(%eax),%edx
    1347:	8b 45 f8             	mov    -0x8(%ebp),%eax
    134a:	8b 40 04             	mov    0x4(%eax),%eax
    134d:	01 c2                	add    %eax,%edx
    134f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1352:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1355:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1358:	8b 10                	mov    (%eax),%edx
    135a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135d:	89 10                	mov    %edx,(%eax)
    135f:	eb 08                	jmp    1369 <free+0xcd>
  } else
    p->s.ptr = bp;
    1361:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1364:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1367:	89 10                	mov    %edx,(%eax)
  freep = p;
    1369:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136c:	a3 4c 16 00 00       	mov    %eax,0x164c
}
    1371:	c9                   	leave  
    1372:	c3                   	ret    

00001373 <morecore>:

static Header*
morecore(uint nu)
{
    1373:	55                   	push   %ebp
    1374:	89 e5                	mov    %esp,%ebp
    1376:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1379:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1380:	77 07                	ja     1389 <morecore+0x16>
    nu = 4096;
    1382:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1389:	8b 45 08             	mov    0x8(%ebp),%eax
    138c:	c1 e0 03             	shl    $0x3,%eax
    138f:	89 04 24             	mov    %eax,(%esp)
    1392:	e8 51 fc ff ff       	call   fe8 <sbrk>
    1397:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
    139a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    139e:	75 07                	jne    13a7 <morecore+0x34>
    return 0;
    13a0:	b8 00 00 00 00       	mov    $0x0,%eax
    13a5:	eb 22                	jmp    13c9 <morecore+0x56>
  hp = (Header*)p;
    13a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
    13ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b0:	8b 55 08             	mov    0x8(%ebp),%edx
    13b3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b9:	83 c0 08             	add    $0x8,%eax
    13bc:	89 04 24             	mov    %eax,(%esp)
    13bf:	e8 d8 fe ff ff       	call   129c <free>
  return freep;
    13c4:	a1 4c 16 00 00       	mov    0x164c,%eax
}
    13c9:	c9                   	leave  
    13ca:	c3                   	ret    

000013cb <malloc>:

void*
malloc(uint nbytes)
{
    13cb:	55                   	push   %ebp
    13cc:	89 e5                	mov    %esp,%ebp
    13ce:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	83 c0 07             	add    $0x7,%eax
    13d7:	c1 e8 03             	shr    $0x3,%eax
    13da:	83 c0 01             	add    $0x1,%eax
    13dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
    13e0:	a1 4c 16 00 00       	mov    0x164c,%eax
    13e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13ec:	75 23                	jne    1411 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13ee:	c7 45 f0 44 16 00 00 	movl   $0x1644,-0x10(%ebp)
    13f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13f8:	a3 4c 16 00 00       	mov    %eax,0x164c
    13fd:	a1 4c 16 00 00       	mov    0x164c,%eax
    1402:	a3 44 16 00 00       	mov    %eax,0x1644
    base.s.size = 0;
    1407:	c7 05 48 16 00 00 00 	movl   $0x0,0x1648
    140e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1411:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1414:	8b 00                	mov    (%eax),%eax
    1416:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
    1419:	8b 45 ec             	mov    -0x14(%ebp),%eax
    141c:	8b 40 04             	mov    0x4(%eax),%eax
    141f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1422:	72 4d                	jb     1471 <malloc+0xa6>
      if(p->s.size == nunits)
    1424:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1427:	8b 40 04             	mov    0x4(%eax),%eax
    142a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    142d:	75 0c                	jne    143b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    142f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1432:	8b 10                	mov    (%eax),%edx
    1434:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1437:	89 10                	mov    %edx,(%eax)
    1439:	eb 26                	jmp    1461 <malloc+0x96>
      else {
        p->s.size -= nunits;
    143b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    143e:	8b 40 04             	mov    0x4(%eax),%eax
    1441:	89 c2                	mov    %eax,%edx
    1443:	2b 55 f4             	sub    -0xc(%ebp),%edx
    1446:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1449:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    144c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    144f:	8b 40 04             	mov    0x4(%eax),%eax
    1452:	c1 e0 03             	shl    $0x3,%eax
    1455:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
    1458:	8b 45 ec             	mov    -0x14(%ebp),%eax
    145b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    145e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1461:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1464:	a3 4c 16 00 00       	mov    %eax,0x164c
      return (void*)(p + 1);
    1469:	8b 45 ec             	mov    -0x14(%ebp),%eax
    146c:	83 c0 08             	add    $0x8,%eax
    146f:	eb 38                	jmp    14a9 <malloc+0xde>
    }
    if(p == freep)
    1471:	a1 4c 16 00 00       	mov    0x164c,%eax
    1476:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    1479:	75 1b                	jne    1496 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147e:	89 04 24             	mov    %eax,(%esp)
    1481:	e8 ed fe ff ff       	call   1373 <morecore>
    1486:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1489:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    148d:	75 07                	jne    1496 <malloc+0xcb>
        return 0;
    148f:	b8 00 00 00 00       	mov    $0x0,%eax
    1494:	eb 13                	jmp    14a9 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1496:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1499:	89 45 f0             	mov    %eax,-0x10(%ebp)
    149c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    149f:	8b 00                	mov    (%eax),%eax
    14a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14a4:	e9 70 ff ff ff       	jmp    1419 <malloc+0x4e>
}
    14a9:	c9                   	leave  
    14aa:	c3                   	ret    
