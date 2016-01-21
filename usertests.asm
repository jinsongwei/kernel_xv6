
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 e8 5b 00 00       	mov    0x5be8,%eax
       b:	c7 44 24 04 16 44 00 	movl   $0x4416,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 1d 40 00 00       	call   4038 <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 21 44 00 00 	movl   $0x4421,(%esp)
      22:	e8 fd 3e 00 00       	call   3f24 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      30:	c7 44 24 04 29 44 00 	movl   $0x4429,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 f8 3f 00 00       	call   4038 <printf>
    exit();
      40:	e8 77 3e 00 00       	call   3ebc <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 21 44 00 00 	movl   $0x4421,(%esp)
      4c:	e8 db 3e 00 00       	call   3f2c <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      5a:	c7 44 24 04 37 44 00 	movl   $0x4437,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 ce 3f 00 00       	call   4038 <printf>
    exit();
      6a:	e8 4d 3e 00 00       	call   3ebc <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
      76:	e8 91 3e 00 00       	call   3f0c <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      84:	c7 44 24 04 58 44 00 	movl   $0x4458,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 a4 3f 00 00       	call   4038 <printf>
    exit();
      94:	e8 23 3e 00 00       	call   3ebc <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
      a0:	e8 87 3e 00 00       	call   3f2c <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      ae:	c7 44 24 04 74 44 00 	movl   $0x4474,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 7a 3f 00 00       	call   4038 <printf>
    exit();
      be:	e8 f9 3d 00 00       	call   3ebc <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      c8:	c7 44 24 04 84 44 00 	movl   $0x4484,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 60 3f 00 00       	call   4038 <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 e8 5b 00 00       	mov    0x5be8,%eax
      e5:	c7 44 24 04 92 44 00 	movl   $0x4492,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 43 3f 00 00       	call   4038 <printf>

  pid = fork();
      f5:	e8 ba 3d 00 00       	call   3eb4 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     108:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 20 3f 00 00       	call   4038 <printf>
    exit();
     118:	e8 9f 3d 00 00       	call   3ebc <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 21 44 00 00 	movl   $0x4421,(%esp)
     12e:	e8 f1 3d 00 00       	call   3f24 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     13c:	c7 44 24 04 29 44 00 	movl   $0x4429,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 ec 3e 00 00       	call   4038 <printf>
      exit();
     14c:	e8 6b 3d 00 00       	call   3ebc <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 21 44 00 00 	movl   $0x4421,(%esp)
     158:	e8 cf 3d 00 00       	call   3f2c <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     166:	c7 44 24 04 ae 44 00 	movl   $0x44ae,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 c2 3e 00 00       	call   4038 <printf>
      exit();
     176:	e8 41 3d 00 00       	call   3ebc <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 4d 44 00 00 	movl   $0x444d,(%esp)
     182:	e8 85 3d 00 00       	call   3f0c <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     190:	c7 44 24 04 58 44 00 	movl   $0x4458,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 98 3e 00 00       	call   4038 <printf>
      exit();
     1a0:	e8 17 3d 00 00       	call   3ebc <exit>
    }
    exit();
     1a5:	e8 12 3d 00 00       	call   3ebc <exit>
  }
  wait();
     1aa:	e8 15 3d 00 00       	call   3ec4 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     1b4:	c7 44 24 04 c2 44 00 	movl   $0x44c2,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 74 3e 00 00       	call   4038 <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     1d1:	c7 44 24 04 d4 44 00 	movl   $0x44d4,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 57 3e 00 00       	call   4038 <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 e3 44 00 00 	movl   $0x44e3,(%esp)
     1e8:	e8 37 3d 00 00       	call   3f24 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     1f6:	c7 44 24 04 e9 44 00 	movl   $0x44e9,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 32 3e 00 00       	call   4038 <printf>
    exit();
     206:	e8 b1 3c 00 00       	call   3ebc <exit>
  }
  pid = fork();
     20b:	e8 a4 3c 00 00       	call   3eb4 <fork>
     210:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     213:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     21e:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 0a 3e 00 00       	call   4038 <printf>
    exit();
     22e:	e8 89 3c 00 00       	call   3ebc <exit>
  }
  if(pid == 0){
     233:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 e3 44 00 00 	movl   $0x44e3,(%esp)
     248:	e8 af 3c 00 00       	call   3efc <open>
     24d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fd >= 0){
     250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     25b:	c7 44 24 04 00 45 00 	movl   $0x4500,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 cd 3d 00 00       	call   4038 <printf>
      exit();
     26b:	e8 4c 3c 00 00       	call   3ebc <exit>
    }
    exit();
     270:	e8 47 3c 00 00       	call   3ebc <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 cb 3c 00 00       	call   3f4c <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 e3 44 00 00 	movl   $0x44e3,(%esp)
     288:	e8 7f 3c 00 00       	call   3f0c <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     296:	c7 44 24 04 24 45 00 	movl   $0x4524,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 92 3d 00 00       	call   4038 <printf>
    exit();
     2a6:	e8 11 3c 00 00       	call   3ebc <exit>
  }
  wait();
     2ab:	e8 14 3c 00 00       	call   3ec4 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     2b5:	c7 44 24 04 33 45 00 	movl   $0x4533,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 73 3d 00 00       	call   4038 <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     2d2:	c7 44 24 04 45 45 00 	movl   $0x4545,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 56 3d 00 00       	call   4038 <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 00 44 00 00 	movl   $0x4400,(%esp)
     2f1:	e8 06 3c 00 00       	call   3efc <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     304:	c7 44 24 04 50 45 00 	movl   $0x4550,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 24 3d 00 00       	call   4038 <printf>
    exit();
     314:	e8 a3 3b 00 00       	call   3ebc <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 c0 3b 00 00       	call   3ee4 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 63 45 00 00 	movl   $0x4563,(%esp)
     333:	e8 c4 3b 00 00       	call   3efc <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     346:	c7 44 24 04 70 45 00 	movl   $0x4570,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 e2 3c 00 00       	call   4038 <printf>
    exit();
     356:	e8 61 3b 00 00       	call   3ebc <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     360:	c7 44 24 04 8e 45 00 	movl   $0x458e,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 c8 3c 00 00       	call   4038 <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     37d:	c7 44 24 04 9c 45 00 	movl   $0x459c,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 ab 3c 00 00       	call   4038 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 ad 45 00 00 	movl   $0x45ad,(%esp)
     39c:	e8 5b 3b 00 00       	call   3efc <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     3af:	c7 44 24 04 b3 45 00 	movl   $0x45b3,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 79 3c 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     3d0:	c7 44 24 04 ce 45 00 	movl   $0x45ce,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 58 3c 00 00       	call   4038 <printf>
    exit();
     3e0:	e8 d7 3a 00 00       	call   3ebc <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 ea 45 00 	movl   $0x45ea,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 dc 3a 00 00       	call   3edc <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 f8 45 00 	movl   $0x45f8,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 17 3c 00 00       	call   4038 <printf>
      exit();
     421:	e8 96 3a 00 00       	call   3ebc <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 1c 46 00 	movl   $0x461c,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 9b 3a 00 00       	call   3edc <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 28 46 00 	movl   $0x4628,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 d6 3b 00 00       	call   4038 <printf>
      exit();
     462:	e8 55 3a 00 00       	call   3ebc <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     47a:	c7 44 24 04 4c 46 00 	movl   $0x464c,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 ae 3b 00 00       	call   4038 <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 4f 3a 00 00       	call   3ee4 <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 ad 45 00 00 	movl   $0x45ad,(%esp)
     4a4:	e8 53 3a 00 00       	call   3efc <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     4b7:	c7 44 24 04 57 46 00 	movl   $0x4657,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 71 3b 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 f2 39 00 00       	call   3ed4 <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	74 1c                	je     50a <writetest+0x198>
     4ee:	eb 4c                	jmp    53c <writetest+0x1ca>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     4f5:	c7 44 24 04 70 46 00 	movl   $0x4670,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 33 3b 00 00       	call   4038 <printf>
    exit();
     505:	e8 b2 39 00 00       	call   3ebc <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     50f:	c7 44 24 04 8b 46 00 	movl   $0x468b,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 19 3b 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 ba 39 00 00       	call   3ee4 <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 ad 45 00 00 	movl   $0x45ad,(%esp)
     531:	e8 d6 39 00 00       	call   3f0c <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	78 1c                	js     556 <writetest+0x1e4>
     53a:	eb 34                	jmp    570 <writetest+0x1fe>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     541:	c7 44 24 04 9e 46 00 	movl   $0x469e,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 e7 3a 00 00       	call   4038 <printf>
    exit();
     551:	e8 66 39 00 00       	call   3ebc <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     55b:	c7 44 24 04 ab 46 00 	movl   $0x46ab,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 cd 3a 00 00       	call   4038 <printf>
    exit();
     56b:	e8 4c 39 00 00       	call   3ebc <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     575:	c7 44 24 04 c0 46 00 	movl   $0x46c0,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 b3 3a 00 00       	call   4038 <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     592:	c7 44 24 04 d4 46 00 	movl   $0x46d4,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 96 3a 00 00       	call   4038 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 e4 46 00 00 	movl   $0x46e4,(%esp)
     5b1:	e8 46 39 00 00       	call   3efc <open>
     5b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
     5b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     5c4:	c7 44 24 04 e8 46 00 	movl   $0x46e8,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 64 3a 00 00       	call   4038 <printf>
    exit();
     5d4:	e8 e3 38 00 00       	call   3ebc <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 e0 83 00 00       	mov    $0x83e0,%eax
     5e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 d5 38 00 00       	call   3edc <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     613:	8b 55 ec             	mov    -0x14(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 02 47 00 	movl   $0x4702,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 0e 3a 00 00       	call   4038 <printf>
      exit();
     62a:	e8 8d 38 00 00       	call   3ebc <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     633:	8b 45 ec             	mov    -0x14(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 9c 38 00 00       	call   3ee4 <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 e4 46 00 00 	movl   $0x46e4,(%esp)
     657:	e8 a0 38 00 00       	call   3efc <open>
     65c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
     65f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     66a:	c7 44 24 04 20 47 00 	movl   $0x4720,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 be 39 00 00       	call   4038 <printf>
    exit();
     67a:	e8 3d 38 00 00       	call   3ebc <exit>
  }

  n = 0;
     67f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     695:	00 
     696:	8b 45 f0             	mov    -0x10(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 33 38 00 00       	call   3ed4 <read>
     6a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(i == 0){
     6a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6a8:	75 2e                	jne    6d8 <writetest1+0x151>
      if(n == MAXFILE - 1){
     6aa:	81 7d f4 8b 00 00 00 	cmpl   $0x8b,-0xc(%ebp)
     6b1:	0f 85 8c 00 00 00    	jne    743 <writetest1+0x1bc>
        printf(stdout, "read only %d blocks from big", n);
     6b7:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     6bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bf:	89 54 24 08          	mov    %edx,0x8(%esp)
     6c3:	c7 44 24 04 39 47 00 	movl   $0x4739,0x4(%esp)
     6ca:	00 
     6cb:	89 04 24             	mov    %eax,(%esp)
     6ce:	e8 65 39 00 00       	call   4038 <printf>
        exit();
     6d3:	e8 e4 37 00 00       	call   3ebc <exit>
      }
      break;
    } else if(i != 512){
     6d8:	81 7d ec 00 02 00 00 	cmpl   $0x200,-0x14(%ebp)
     6df:	74 21                	je     702 <writetest1+0x17b>
      printf(stdout, "read failed %d\n", i);
     6e1:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     6e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
     6e9:	89 54 24 08          	mov    %edx,0x8(%esp)
     6ed:	c7 44 24 04 56 47 00 	movl   $0x4756,0x4(%esp)
     6f4:	00 
     6f5:	89 04 24             	mov    %eax,(%esp)
     6f8:	e8 3b 39 00 00       	call   4038 <printf>
      exit();
     6fd:	e8 ba 37 00 00       	call   3ebc <exit>
    }
    if(((int*)buf)[0] != n){
     702:	b8 e0 83 00 00       	mov    $0x83e0,%eax
     707:	8b 00                	mov    (%eax),%eax
     709:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     70c:	74 2c                	je     73a <writetest1+0x1b3>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     70e:	b8 e0 83 00 00       	mov    $0x83e0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     713:	8b 10                	mov    (%eax),%edx
     715:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     71a:	89 54 24 0c          	mov    %edx,0xc(%esp)
     71e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     721:	89 54 24 08          	mov    %edx,0x8(%esp)
     725:	c7 44 24 04 68 47 00 	movl   $0x4768,0x4(%esp)
     72c:	00 
     72d:	89 04 24             	mov    %eax,(%esp)
     730:	e8 03 39 00 00       	call   4038 <printf>
             n, ((int*)buf)[0]);
      exit();
     735:	e8 82 37 00 00       	call   3ebc <exit>
    }
    n++;
     73a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
     73e:	e9 43 ff ff ff       	jmp    686 <writetest1+0xff>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     743:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     744:	8b 45 f0             	mov    -0x10(%ebp),%eax
     747:	89 04 24             	mov    %eax,(%esp)
     74a:	e8 95 37 00 00       	call   3ee4 <close>
  if(unlink("big") < 0){
     74f:	c7 04 24 e4 46 00 00 	movl   $0x46e4,(%esp)
     756:	e8 b1 37 00 00       	call   3f0c <unlink>
     75b:	85 c0                	test   %eax,%eax
     75d:	79 1a                	jns    779 <writetest1+0x1f2>
    printf(stdout, "unlink big failed\n");
     75f:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     764:	c7 44 24 04 88 47 00 	movl   $0x4788,0x4(%esp)
     76b:	00 
     76c:	89 04 24             	mov    %eax,(%esp)
     76f:	e8 c4 38 00 00       	call   4038 <printf>
    exit();
     774:	e8 43 37 00 00       	call   3ebc <exit>
  }
  printf(stdout, "big files ok\n");
     779:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     77e:	c7 44 24 04 9b 47 00 	movl   $0x479b,0x4(%esp)
     785:	00 
     786:	89 04 24             	mov    %eax,(%esp)
     789:	e8 aa 38 00 00       	call   4038 <printf>
}
     78e:	c9                   	leave  
     78f:	c3                   	ret    

00000790 <createtest>:

void
createtest(void)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     796:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     79b:	c7 44 24 04 ac 47 00 	movl   $0x47ac,0x4(%esp)
     7a2:	00 
     7a3:	89 04 24             	mov    %eax,(%esp)
     7a6:	e8 8d 38 00 00       	call   4038 <printf>

  name[0] = 'a';
     7ab:	c6 05 e0 a3 00 00 61 	movb   $0x61,0xa3e0
  name[2] = '\0';
     7b2:	c6 05 e2 a3 00 00 00 	movb   $0x0,0xa3e2
  for(i = 0; i < 52; i++){
     7b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7c0:	eb 31                	jmp    7f3 <createtest+0x63>
    name[1] = '0' + i;
     7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7c5:	83 c0 30             	add    $0x30,%eax
     7c8:	a2 e1 a3 00 00       	mov    %al,0xa3e1
    fd = open(name, O_CREATE|O_RDWR);
     7cd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d4:	00 
     7d5:	c7 04 24 e0 a3 00 00 	movl   $0xa3e0,(%esp)
     7dc:	e8 1b 37 00 00       	call   3efc <open>
     7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    close(fd);
     7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7e7:	89 04 24             	mov    %eax,(%esp)
     7ea:	e8 f5 36 00 00       	call   3ee4 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     7f3:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
     7f7:	7e c9                	jle    7c2 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7f9:	c6 05 e0 a3 00 00 61 	movb   $0x61,0xa3e0
  name[2] = '\0';
     800:	c6 05 e2 a3 00 00 00 	movb   $0x0,0xa3e2
  for(i = 0; i < 52; i++){
     807:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     80e:	eb 1b                	jmp    82b <createtest+0x9b>
    name[1] = '0' + i;
     810:	8b 45 f0             	mov    -0x10(%ebp),%eax
     813:	83 c0 30             	add    $0x30,%eax
     816:	a2 e1 a3 00 00       	mov    %al,0xa3e1
    unlink(name);
     81b:	c7 04 24 e0 a3 00 00 	movl   $0xa3e0,(%esp)
     822:	e8 e5 36 00 00       	call   3f0c <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     827:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     82b:	83 7d f0 33          	cmpl   $0x33,-0x10(%ebp)
     82f:	7e df                	jle    810 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     831:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     836:	c7 44 24 04 d4 47 00 	movl   $0x47d4,0x4(%esp)
     83d:	00 
     83e:	89 04 24             	mov    %eax,(%esp)
     841:	e8 f2 37 00 00       	call   4038 <printf>
}
     846:	c9                   	leave  
     847:	c3                   	ret    

00000848 <dirtest>:

void dirtest(void)
{
     848:	55                   	push   %ebp
     849:	89 e5                	mov    %esp,%ebp
     84b:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     84e:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     853:	c7 44 24 04 fa 47 00 	movl   $0x47fa,0x4(%esp)
     85a:	00 
     85b:	89 04 24             	mov    %eax,(%esp)
     85e:	e8 d5 37 00 00       	call   4038 <printf>

  if(mkdir("dir0") < 0){
     863:	c7 04 24 06 48 00 00 	movl   $0x4806,(%esp)
     86a:	e8 b5 36 00 00       	call   3f24 <mkdir>
     86f:	85 c0                	test   %eax,%eax
     871:	79 1a                	jns    88d <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     873:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     878:	c7 44 24 04 29 44 00 	movl   $0x4429,0x4(%esp)
     87f:	00 
     880:	89 04 24             	mov    %eax,(%esp)
     883:	e8 b0 37 00 00       	call   4038 <printf>
    exit();
     888:	e8 2f 36 00 00       	call   3ebc <exit>
  }

  if(chdir("dir0") < 0){
     88d:	c7 04 24 06 48 00 00 	movl   $0x4806,(%esp)
     894:	e8 93 36 00 00       	call   3f2c <chdir>
     899:	85 c0                	test   %eax,%eax
     89b:	79 1a                	jns    8b7 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89d:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     8a2:	c7 44 24 04 0b 48 00 	movl   $0x480b,0x4(%esp)
     8a9:	00 
     8aa:	89 04 24             	mov    %eax,(%esp)
     8ad:	e8 86 37 00 00       	call   4038 <printf>
    exit();
     8b2:	e8 05 36 00 00       	call   3ebc <exit>
  }

  if(chdir("..") < 0){
     8b7:	c7 04 24 1e 48 00 00 	movl   $0x481e,(%esp)
     8be:	e8 69 36 00 00       	call   3f2c <chdir>
     8c3:	85 c0                	test   %eax,%eax
     8c5:	79 1a                	jns    8e1 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c7:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     8cc:	c7 44 24 04 21 48 00 	movl   $0x4821,0x4(%esp)
     8d3:	00 
     8d4:	89 04 24             	mov    %eax,(%esp)
     8d7:	e8 5c 37 00 00       	call   4038 <printf>
    exit();
     8dc:	e8 db 35 00 00       	call   3ebc <exit>
  }

  if(unlink("dir0") < 0){
     8e1:	c7 04 24 06 48 00 00 	movl   $0x4806,(%esp)
     8e8:	e8 1f 36 00 00       	call   3f0c <unlink>
     8ed:	85 c0                	test   %eax,%eax
     8ef:	79 1a                	jns    90b <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f1:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     8f6:	c7 44 24 04 32 48 00 	movl   $0x4832,0x4(%esp)
     8fd:	00 
     8fe:	89 04 24             	mov    %eax,(%esp)
     901:	e8 32 37 00 00       	call   4038 <printf>
    exit();
     906:	e8 b1 35 00 00       	call   3ebc <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90b:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     910:	c7 44 24 04 46 48 00 	movl   $0x4846,0x4(%esp)
     917:	00 
     918:	89 04 24             	mov    %eax,(%esp)
     91b:	e8 18 37 00 00       	call   4038 <printf>
}
     920:	c9                   	leave  
     921:	c3                   	ret    

00000922 <exectest>:

void
exectest(void)
{
     922:	55                   	push   %ebp
     923:	89 e5                	mov    %esp,%ebp
     925:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     928:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     92d:	c7 44 24 04 55 48 00 	movl   $0x4855,0x4(%esp)
     934:	00 
     935:	89 04 24             	mov    %eax,(%esp)
     938:	e8 fb 36 00 00       	call   4038 <printf>
  if(exec("echo", echoargv) < 0){
     93d:	c7 44 24 04 d4 5b 00 	movl   $0x5bd4,0x4(%esp)
     944:	00 
     945:	c7 04 24 00 44 00 00 	movl   $0x4400,(%esp)
     94c:	e8 a3 35 00 00       	call   3ef4 <exec>
     951:	85 c0                	test   %eax,%eax
     953:	79 1a                	jns    96f <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     955:	a1 e8 5b 00 00       	mov    0x5be8,%eax
     95a:	c7 44 24 04 60 48 00 	movl   $0x4860,0x4(%esp)
     961:	00 
     962:	89 04 24             	mov    %eax,(%esp)
     965:	e8 ce 36 00 00       	call   4038 <printf>
    exit();
     96a:	e8 4d 35 00 00       	call   3ebc <exit>
  }
}
     96f:	c9                   	leave  
     970:	c3                   	ret    

00000971 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     971:	55                   	push   %ebp
     972:	89 e5                	mov    %esp,%ebp
     974:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     977:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97a:	89 04 24             	mov    %eax,(%esp)
     97d:	e8 4a 35 00 00       	call   3ecc <pipe>
     982:	85 c0                	test   %eax,%eax
     984:	74 19                	je     99f <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     986:	c7 44 24 04 72 48 00 	movl   $0x4872,0x4(%esp)
     98d:	00 
     98e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     995:	e8 9e 36 00 00       	call   4038 <printf>
    exit();
     99a:	e8 1d 35 00 00       	call   3ebc <exit>
  }
  pid = fork();
     99f:	e8 10 35 00 00       	call   3eb4 <fork>
     9a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if(pid == 0){
     9ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b2:	0f 85 84 00 00 00    	jne    a3c <pipe1+0xcb>
    close(fds[0]);
     9b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bb:	89 04 24             	mov    %eax,(%esp)
     9be:	e8 21 35 00 00       	call   3ee4 <close>
    for(n = 0; n < 5; n++){
     9c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9ca:	eb 65                	jmp    a31 <pipe1+0xc0>
      for(i = 0; i < 1033; i++)
     9cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     9d3:	eb 14                	jmp    9e9 <pipe1+0x78>
        buf[i] = seq++;
     9d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     9d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     9db:	88 90 e0 83 00 00    	mov    %dl,0x83e0(%eax)
     9e1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9e5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     9e9:	81 7d e8 08 04 00 00 	cmpl   $0x408,-0x18(%ebp)
     9f0:	7e e3                	jle    9d5 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9f5:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     9fc:	00 
     9fd:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     a04:	00 
     a05:	89 04 24             	mov    %eax,(%esp)
     a08:	e8 cf 34 00 00       	call   3edc <write>
     a0d:	3d 09 04 00 00       	cmp    $0x409,%eax
     a12:	74 19                	je     a2d <pipe1+0xbc>
        printf(1, "pipe1 oops 1\n");
     a14:	c7 44 24 04 81 48 00 	movl   $0x4881,0x4(%esp)
     a1b:	00 
     a1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a23:	e8 10 36 00 00       	call   4038 <printf>
        exit();
     a28:	e8 8f 34 00 00       	call   3ebc <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a2d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a31:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a35:	7e 95                	jle    9cc <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a37:	e8 80 34 00 00       	call   3ebc <exit>
  } else if(pid > 0){
     a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a40:	0f 8e fb 00 00 00    	jle    b41 <pipe1+0x1d0>
    close(fds[1]);
     a46:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a49:	89 04 24             	mov    %eax,(%esp)
     a4c:	e8 93 34 00 00       	call   3ee4 <close>
    total = 0;
     a51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = 1;
     a58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a5f:	eb 6a                	jmp    acb <pipe1+0x15a>
      for(i = 0; i < n; i++){
     a61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     a68:	eb 3f                	jmp    aa9 <pipe1+0x138>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     a6d:	0f b6 80 e0 83 00 00 	movzbl 0x83e0(%eax),%eax
     a74:	0f be c0             	movsbl %al,%eax
     a77:	33 45 e4             	xor    -0x1c(%ebp),%eax
     a7a:	25 ff 00 00 00       	and    $0xff,%eax
     a7f:	85 c0                	test   %eax,%eax
     a81:	0f 95 c0             	setne  %al
     a84:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     a88:	84 c0                	test   %al,%al
     a8a:	74 19                	je     aa5 <pipe1+0x134>
          printf(1, "pipe1 oops 2\n");
     a8c:	c7 44 24 04 8f 48 00 	movl   $0x488f,0x4(%esp)
     a93:	00 
     a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9b:	e8 98 35 00 00       	call   4038 <printf>
          return;
     aa0:	e9 b5 00 00 00       	jmp    b5a <pipe1+0x1e9>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa5:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     aac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aaf:	7c b9                	jl     a6a <pipe1+0xf9>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab4:	01 45 f4             	add    %eax,-0xc(%ebp)
      cc = cc * 2;
     ab7:	d1 65 f0             	shll   -0x10(%ebp)
      if(cc > sizeof(buf))
     aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     abd:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac2:	76 07                	jbe    acb <pipe1+0x15a>
        cc = sizeof(buf);
     ac4:	c7 45 f0 00 20 00 00 	movl   $0x2000,-0x10(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     acb:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ad1:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad5:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     adc:	00 
     add:	89 04 24             	mov    %eax,(%esp)
     ae0:	e8 ef 33 00 00       	call   3ed4 <read>
     ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ae8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     aec:	0f 8f 6f ff ff ff    	jg     a61 <pipe1+0xf0>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af2:	81 7d f4 2d 14 00 00 	cmpl   $0x142d,-0xc(%ebp)
     af9:	74 20                	je     b1b <pipe1+0x1aa>
      printf(1, "pipe1 oops 3 total %d\n", total);
     afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     afe:	89 44 24 08          	mov    %eax,0x8(%esp)
     b02:	c7 44 24 04 9d 48 00 	movl   $0x489d,0x4(%esp)
     b09:	00 
     b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b11:	e8 22 35 00 00       	call   4038 <printf>
      exit();
     b16:	e8 a1 33 00 00       	call   3ebc <exit>
    }
    close(fds[0]);
     b1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b1e:	89 04 24             	mov    %eax,(%esp)
     b21:	e8 be 33 00 00       	call   3ee4 <close>
    wait();
     b26:	e8 99 33 00 00       	call   3ec4 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2b:	c7 44 24 04 b4 48 00 	movl   $0x48b4,0x4(%esp)
     b32:	00 
     b33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3a:	e8 f9 34 00 00       	call   4038 <printf>
     b3f:	eb 19                	jmp    b5a <pipe1+0x1e9>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b41:	c7 44 24 04 be 48 00 	movl   $0x48be,0x4(%esp)
     b48:	00 
     b49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b50:	e8 e3 34 00 00       	call   4038 <printf>
    exit();
     b55:	e8 62 33 00 00       	call   3ebc <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5a:	c9                   	leave  
     b5b:	c3                   	ret    

00000b5c <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b5c:	55                   	push   %ebp
     b5d:	89 e5                	mov    %esp,%ebp
     b5f:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b62:	c7 44 24 04 cd 48 00 	movl   $0x48cd,0x4(%esp)
     b69:	00 
     b6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b71:	e8 c2 34 00 00       	call   4038 <printf>
  pid1 = fork();
     b76:	e8 39 33 00 00       	call   3eb4 <fork>
     b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid1 == 0)
     b7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b82:	75 02                	jne    b86 <preempt+0x2a>
    for(;;)
      ;
     b84:	eb fe                	jmp    b84 <preempt+0x28>

  pid2 = fork();
     b86:	e8 29 33 00 00       	call   3eb4 <fork>
     b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b92:	75 02                	jne    b96 <preempt+0x3a>
    for(;;)
      ;
     b94:	eb fe                	jmp    b94 <preempt+0x38>

  pipe(pfds);
     b96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b99:	89 04 24             	mov    %eax,(%esp)
     b9c:	e8 2b 33 00 00       	call   3ecc <pipe>
  pid3 = fork();
     ba1:	e8 0e 33 00 00       	call   3eb4 <fork>
     ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid3 == 0){
     ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bad:	75 4c                	jne    bfb <preempt+0x9f>
    close(pfds[0]);
     baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb2:	89 04 24             	mov    %eax,(%esp)
     bb5:	e8 2a 33 00 00       	call   3ee4 <close>
    if(write(pfds[1], "x", 1) != 1)
     bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bbd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc4:	00 
     bc5:	c7 44 24 04 d7 48 00 	movl   $0x48d7,0x4(%esp)
     bcc:	00 
     bcd:	89 04 24             	mov    %eax,(%esp)
     bd0:	e8 07 33 00 00       	call   3edc <write>
     bd5:	83 f8 01             	cmp    $0x1,%eax
     bd8:	74 14                	je     bee <preempt+0x92>
      printf(1, "preempt write error");
     bda:	c7 44 24 04 d9 48 00 	movl   $0x48d9,0x4(%esp)
     be1:	00 
     be2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     be9:	e8 4a 34 00 00       	call   4038 <printf>
    close(pfds[1]);
     bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf1:	89 04 24             	mov    %eax,(%esp)
     bf4:	e8 eb 32 00 00       	call   3ee4 <close>
    for(;;)
      ;
     bf9:	eb fe                	jmp    bf9 <preempt+0x9d>
  }

  close(pfds[1]);
     bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bfe:	89 04 24             	mov    %eax,(%esp)
     c01:	e8 de 32 00 00       	call   3ee4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c09:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c10:	00 
     c11:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
     c18:	00 
     c19:	89 04 24             	mov    %eax,(%esp)
     c1c:	e8 b3 32 00 00       	call   3ed4 <read>
     c21:	83 f8 01             	cmp    $0x1,%eax
     c24:	74 16                	je     c3c <preempt+0xe0>
    printf(1, "preempt read error");
     c26:	c7 44 24 04 ed 48 00 	movl   $0x48ed,0x4(%esp)
     c2d:	00 
     c2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c35:	e8 fe 33 00 00       	call   4038 <printf>
    return;
     c3a:	eb 77                	jmp    cb3 <preempt+0x157>
  }
  close(pfds[0]);
     c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c3f:	89 04 24             	mov    %eax,(%esp)
     c42:	e8 9d 32 00 00       	call   3ee4 <close>
  printf(1, "kill... ");
     c47:	c7 44 24 04 00 49 00 	movl   $0x4900,0x4(%esp)
     c4e:	00 
     c4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c56:	e8 dd 33 00 00       	call   4038 <printf>
  kill(pid1);
     c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c5e:	89 04 24             	mov    %eax,(%esp)
     c61:	e8 86 32 00 00       	call   3eec <kill>
  kill(pid2);
     c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c69:	89 04 24             	mov    %eax,(%esp)
     c6c:	e8 7b 32 00 00       	call   3eec <kill>
  kill(pid3);
     c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c74:	89 04 24             	mov    %eax,(%esp)
     c77:	e8 70 32 00 00       	call   3eec <kill>
  printf(1, "wait... ");
     c7c:	c7 44 24 04 09 49 00 	movl   $0x4909,0x4(%esp)
     c83:	00 
     c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8b:	e8 a8 33 00 00       	call   4038 <printf>
  wait();
     c90:	e8 2f 32 00 00       	call   3ec4 <wait>
  wait();
     c95:	e8 2a 32 00 00       	call   3ec4 <wait>
  wait();
     c9a:	e8 25 32 00 00       	call   3ec4 <wait>
  printf(1, "preempt ok\n");
     c9f:	c7 44 24 04 12 49 00 	movl   $0x4912,0x4(%esp)
     ca6:	00 
     ca7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cae:	e8 85 33 00 00       	call   4038 <printf>
}
     cb3:	c9                   	leave  
     cb4:	c3                   	ret    

00000cb5 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb5:	55                   	push   %ebp
     cb6:	89 e5                	mov    %esp,%ebp
     cb8:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     cc2:	eb 53                	jmp    d17 <exitwait+0x62>
    pid = fork();
     cc4:	e8 eb 31 00 00       	call   3eb4 <fork>
     cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
     ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cd0:	79 16                	jns    ce8 <exitwait+0x33>
      printf(1, "fork failed\n");
     cd2:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
     cd9:	00 
     cda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce1:	e8 52 33 00 00       	call   4038 <printf>
      return;
     ce6:	eb 49                	jmp    d31 <exitwait+0x7c>
    }
    if(pid){
     ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cec:	74 20                	je     d0e <exitwait+0x59>
      if(wait() != pid){
     cee:	e8 d1 31 00 00       	call   3ec4 <wait>
     cf3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     cf6:	74 1b                	je     d13 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cf8:	c7 44 24 04 1e 49 00 	movl   $0x491e,0x4(%esp)
     cff:	00 
     d00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d07:	e8 2c 33 00 00       	call   4038 <printf>
        return;
     d0c:	eb 23                	jmp    d31 <exitwait+0x7c>
      }
    } else {
      exit();
     d0e:	e8 a9 31 00 00       	call   3ebc <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d13:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     d17:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
     d1b:	7e a7                	jle    cc4 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d1d:	c7 44 24 04 2e 49 00 	movl   $0x492e,0x4(%esp)
     d24:	00 
     d25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d2c:	e8 07 33 00 00       	call   4038 <printf>
}
     d31:	c9                   	leave  
     d32:	c3                   	ret    

00000d33 <mem>:

void
mem(void)
{
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
     d36:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d39:	c7 44 24 04 3b 49 00 	movl   $0x493b,0x4(%esp)
     d40:	00 
     d41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d48:	e8 eb 32 00 00       	call   4038 <printf>
  ppid = getpid();
     d4d:	e8 ea 31 00 00       	call   3f3c <getpid>
     d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((pid = fork()) == 0){
     d55:	e8 5a 31 00 00       	call   3eb4 <fork>
     d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d61:	0f 85 aa 00 00 00    	jne    e11 <mem+0xde>
    m1 = 0;
     d67:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while((m2 = malloc(10001)) != 0){
     d6e:	eb 0e                	jmp    d7e <mem+0x4b>
      *(char**)m2 = m1;
     d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d73:	8b 55 e8             	mov    -0x18(%ebp),%edx
     d76:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d7e:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d85:	e8 95 35 00 00       	call   431f <malloc>
     d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d91:	75 dd                	jne    d70 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d93:	eb 19                	jmp    dae <mem+0x7b>
      m2 = *(char**)m1;
     d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d98:	8b 00                	mov    (%eax),%eax
     d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      free(m1);
     d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     da0:	89 04 24             	mov    %eax,(%esp)
     da3:	e8 48 34 00 00       	call   41f0 <free>
      m1 = m2;
     da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     dab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     dae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     db2:	75 e1                	jne    d95 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db4:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbb:	e8 5f 35 00 00       	call   431f <malloc>
     dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(m1 == 0){
     dc3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dc7:	75 24                	jne    ded <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dc9:	c7 44 24 04 45 49 00 	movl   $0x4945,0x4(%esp)
     dd0:	00 
     dd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dd8:	e8 5b 32 00 00       	call   4038 <printf>
      kill(ppid);
     ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de0:	89 04 24             	mov    %eax,(%esp)
     de3:	e8 04 31 00 00       	call   3eec <kill>
      exit();
     de8:	e8 cf 30 00 00       	call   3ebc <exit>
    }
    free(m1);
     ded:	8b 45 e8             	mov    -0x18(%ebp),%eax
     df0:	89 04 24             	mov    %eax,(%esp)
     df3:	e8 f8 33 00 00       	call   41f0 <free>
    printf(1, "mem ok\n");
     df8:	c7 44 24 04 5f 49 00 	movl   $0x495f,0x4(%esp)
     dff:	00 
     e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e07:	e8 2c 32 00 00       	call   4038 <printf>
    exit();
     e0c:	e8 ab 30 00 00       	call   3ebc <exit>
  } else {
    wait();
     e11:	e8 ae 30 00 00       	call   3ec4 <wait>
  }
}
     e16:	c9                   	leave  
     e17:	c3                   	ret    

00000e18 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e18:	55                   	push   %ebp
     e19:	89 e5                	mov    %esp,%ebp
     e1b:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e1e:	c7 44 24 04 67 49 00 	movl   $0x4967,0x4(%esp)
     e25:	00 
     e26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e2d:	e8 06 32 00 00       	call   4038 <printf>

  unlink("sharedfd");
     e32:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
     e39:	e8 ce 30 00 00       	call   3f0c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e3e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e45:	00 
     e46:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
     e4d:	e8 aa 30 00 00       	call   3efc <open>
     e52:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     e55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     e59:	79 19                	jns    e74 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5b:	c7 44 24 04 80 49 00 	movl   $0x4980,0x4(%esp)
     e62:	00 
     e63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6a:	e8 c9 31 00 00       	call   4038 <printf>
    return;
     e6f:	e9 9b 01 00 00       	jmp    100f <sharedfd+0x1f7>
  }
  pid = fork();
     e74:	e8 3b 30 00 00       	call   3eb4 <fork>
     e79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e80:	75 07                	jne    e89 <sharedfd+0x71>
     e82:	b8 63 00 00 00       	mov    $0x63,%eax
     e87:	eb 05                	jmp    e8e <sharedfd+0x76>
     e89:	b8 70 00 00 00       	mov    $0x70,%eax
     e8e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e95:	00 
     e96:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9a:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     e9d:	89 04 24             	mov    %eax,(%esp)
     ea0:	e8 71 2e 00 00       	call   3d16 <memset>
  for(i = 0; i < 1000; i++){
     ea5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     eac:	eb 39                	jmp    ee7 <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eae:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb5:	00 
     eb6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
     ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ec0:	89 04 24             	mov    %eax,(%esp)
     ec3:	e8 14 30 00 00       	call   3edc <write>
     ec8:	83 f8 0a             	cmp    $0xa,%eax
     ecb:	74 16                	je     ee3 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ecd:	c7 44 24 04 ac 49 00 	movl   $0x49ac,0x4(%esp)
     ed4:	00 
     ed5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     edc:	e8 57 31 00 00       	call   4038 <printf>
      break;
     ee1:	eb 0d                	jmp    ef0 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee3:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     ee7:	81 7d e8 e7 03 00 00 	cmpl   $0x3e7,-0x18(%ebp)
     eee:	7e be                	jle    eae <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef4:	75 05                	jne    efb <sharedfd+0xe3>
    exit();
     ef6:	e8 c1 2f 00 00       	call   3ebc <exit>
  else
    wait();
     efb:	e8 c4 2f 00 00       	call   3ec4 <wait>
  close(fd);
     f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f03:	89 04 24             	mov    %eax,(%esp)
     f06:	e8 d9 2f 00 00       	call   3ee4 <close>
  fd = open("sharedfd", 0);
     f0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f12:	00 
     f13:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
     f1a:	e8 dd 2f 00 00       	call   3efc <open>
     f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     f22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     f26:	79 19                	jns    f41 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f28:	c7 44 24 04 cc 49 00 	movl   $0x49cc,0x4(%esp)
     f2f:	00 
     f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f37:	e8 fc 30 00 00       	call   4038 <printf>
    return;
     f3c:	e9 ce 00 00 00       	jmp    100f <sharedfd+0x1f7>
  }
  nc = np = 0;
     f41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f4e:	eb 35                	jmp    f85 <sharedfd+0x16d>
    for(i = 0; i < sizeof(buf); i++){
     f50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     f57:	eb 24                	jmp    f7d <sharedfd+0x165>
      if(buf[i] == 'c')
     f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f5c:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
     f61:	3c 63                	cmp    $0x63,%al
     f63:	75 04                	jne    f69 <sharedfd+0x151>
        nc++;
     f65:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f6c:	0f b6 44 05 d6       	movzbl -0x2a(%ebp,%eax,1),%eax
     f71:	3c 70                	cmp    $0x70,%al
     f73:	75 04                	jne    f79 <sharedfd+0x161>
        np++;
     f75:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f79:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
     f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f80:	83 f8 09             	cmp    $0x9,%eax
     f83:	76 d4                	jbe    f59 <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f85:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f8c:	00 
     f8d:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f90:	89 44 24 04          	mov    %eax,0x4(%esp)
     f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f97:	89 04 24             	mov    %eax,(%esp)
     f9a:	e8 35 2f 00 00       	call   3ed4 <read>
     f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fa6:	7f a8                	jg     f50 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
     fab:	89 04 24             	mov    %eax,(%esp)
     fae:	e8 31 2f 00 00       	call   3ee4 <close>
  unlink("sharedfd");
     fb3:	c7 04 24 76 49 00 00 	movl   $0x4976,(%esp)
     fba:	e8 4d 2f 00 00       	call   3f0c <unlink>
  if(nc == 10000 && np == 10000){
     fbf:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fc6:	75 20                	jne    fe8 <sharedfd+0x1d0>
     fc8:	81 7d f4 10 27 00 00 	cmpl   $0x2710,-0xc(%ebp)
     fcf:	75 17                	jne    fe8 <sharedfd+0x1d0>
    printf(1, "sharedfd ok\n");
     fd1:	c7 44 24 04 f7 49 00 	movl   $0x49f7,0x4(%esp)
     fd8:	00 
     fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe0:	e8 53 30 00 00       	call   4038 <printf>
        np++;
    }
  }
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000){
     fe5:	90                   	nop
     fe6:	eb 27                	jmp    100f <sharedfd+0x1f7>
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     feb:	89 44 24 0c          	mov    %eax,0xc(%esp)
     fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff2:	89 44 24 08          	mov    %eax,0x8(%esp)
     ff6:	c7 44 24 04 04 4a 00 	movl   $0x4a04,0x4(%esp)
     ffd:	00 
     ffe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1005:	e8 2e 30 00 00       	call   4038 <printf>
    exit();
    100a:	e8 ad 2e 00 00       	call   3ebc <exit>
  }
}
    100f:	c9                   	leave  
    1010:	c3                   	ret    

00001011 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1011:	55                   	push   %ebp
    1012:	89 e5                	mov    %esp,%ebp
    1014:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1017:	c7 45 c8 19 4a 00 00 	movl   $0x4a19,-0x38(%ebp)
    101e:	c7 45 cc 1c 4a 00 00 	movl   $0x4a1c,-0x34(%ebp)
    1025:	c7 45 d0 1f 4a 00 00 	movl   $0x4a1f,-0x30(%ebp)
    102c:	c7 45 d4 22 4a 00 00 	movl   $0x4a22,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    1033:	c7 44 24 04 25 4a 00 	movl   $0x4a25,0x4(%esp)
    103a:	00 
    103b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1042:	e8 f1 2f 00 00       	call   4038 <printf>

  for(pi = 0; pi < 4; pi++){
    1047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    104e:	e9 fc 00 00 00       	jmp    114f <fourfiles+0x13e>
    fname = names[pi];
    1053:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1056:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    105a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    unlink(fname);
    105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1060:	89 04 24             	mov    %eax,(%esp)
    1063:	e8 a4 2e 00 00       	call   3f0c <unlink>

    pid = fork();
    1068:	e8 47 2e 00 00       	call   3eb4 <fork>
    106d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(pid < 0){
    1070:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1074:	79 19                	jns    108f <fourfiles+0x7e>
      printf(1, "fork failed\n");
    1076:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
    107d:	00 
    107e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1085:	e8 ae 2f 00 00       	call   4038 <printf>
      exit();
    108a:	e8 2d 2e 00 00       	call   3ebc <exit>
    }

    if(pid == 0){
    108f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1093:	0f 85 b2 00 00 00    	jne    114b <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    1099:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10a0:	00 
    10a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a4:	89 04 24             	mov    %eax,(%esp)
    10a7:	e8 50 2e 00 00       	call   3efc <open>
    10ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
      if(fd < 0){
    10af:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10b3:	79 19                	jns    10ce <fourfiles+0xbd>
        printf(1, "create failed\n");
    10b5:	c7 44 24 04 35 4a 00 	movl   $0x4a35,0x4(%esp)
    10bc:	00 
    10bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c4:	e8 6f 2f 00 00       	call   4038 <printf>
        exit();
    10c9:	e8 ee 2d 00 00       	call   3ebc <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10d1:	83 c0 30             	add    $0x30,%eax
    10d4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10db:	00 
    10dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e0:	c7 04 24 e0 83 00 00 	movl   $0x83e0,(%esp)
    10e7:	e8 2a 2c 00 00       	call   3d16 <memset>
      for(i = 0; i < 12; i++){
    10ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    10f3:	eb 4b                	jmp    1140 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    10f5:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    10fc:	00 
    10fd:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    1104:	00 
    1105:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1108:	89 04 24             	mov    %eax,(%esp)
    110b:	e8 cc 2d 00 00       	call   3edc <write>
    1110:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1113:	81 7d e8 f4 01 00 00 	cmpl   $0x1f4,-0x18(%ebp)
    111a:	74 20                	je     113c <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    111c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    111f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1123:	c7 44 24 04 44 4a 00 	movl   $0x4a44,0x4(%esp)
    112a:	00 
    112b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1132:	e8 01 2f 00 00       	call   4038 <printf>
          exit();
    1137:	e8 80 2d 00 00       	call   3ebc <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    113c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    1140:	83 7d e0 0b          	cmpl   $0xb,-0x20(%ebp)
    1144:	7e af                	jle    10f5 <fourfiles+0xe4>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    1146:	e8 71 2d 00 00       	call   3ebc <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    114b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    114f:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1153:	0f 8e fa fe ff ff    	jle    1053 <fourfiles+0x42>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1159:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1160:	eb 09                	jmp    116b <fourfiles+0x15a>
    wait();
    1162:	e8 5d 2d 00 00       	call   3ec4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1167:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    116b:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    116f:	7e f1                	jle    1162 <fourfiles+0x151>
    wait();
  }

  for(i = 0; i < 2; i++){
    1171:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    1178:	e9 db 00 00 00       	jmp    1258 <fourfiles+0x247>
    fname = names[i];
    117d:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1180:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1184:	89 45 f4             	mov    %eax,-0xc(%ebp)
    fd = open(fname, 0);
    1187:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    118e:	00 
    118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1192:	89 04 24             	mov    %eax,(%esp)
    1195:	e8 62 2d 00 00       	call   3efc <open>
    119a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    total = 0;
    119d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11a4:	eb 4b                	jmp    11f1 <fourfiles+0x1e0>
      for(j = 0; j < n; j++){
    11a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    11ad:	eb 34                	jmp    11e3 <fourfiles+0x1d2>
        if(buf[j] != '0'+i){
    11af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11b2:	0f b6 80 e0 83 00 00 	movzbl 0x83e0(%eax),%eax
    11b9:	0f be c0             	movsbl %al,%eax
    11bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
    11bf:	83 c2 30             	add    $0x30,%edx
    11c2:	39 d0                	cmp    %edx,%eax
    11c4:	74 19                	je     11df <fourfiles+0x1ce>
          printf(1, "wrong char\n");
    11c6:	c7 44 24 04 55 4a 00 	movl   $0x4a55,0x4(%esp)
    11cd:	00 
    11ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11d5:	e8 5e 2e 00 00       	call   4038 <printf>
          exit();
    11da:	e8 dd 2c 00 00       	call   3ebc <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11df:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    11e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    11e9:	7c c4                	jl     11af <fourfiles+0x19e>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11ee:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11f1:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    11f8:	00 
    11f9:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    1200:	00 
    1201:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1204:	89 04 24             	mov    %eax,(%esp)
    1207:	e8 c8 2c 00 00       	call   3ed4 <read>
    120c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    120f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1213:	7f 91                	jg     11a6 <fourfiles+0x195>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1215:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1218:	89 04 24             	mov    %eax,(%esp)
    121b:	e8 c4 2c 00 00       	call   3ee4 <close>
    if(total != 12*500){
    1220:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1227:	74 20                	je     1249 <fourfiles+0x238>
      printf(1, "wrong length %d\n", total);
    1229:	8b 45 ec             	mov    -0x14(%ebp),%eax
    122c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1230:	c7 44 24 04 61 4a 00 	movl   $0x4a61,0x4(%esp)
    1237:	00 
    1238:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    123f:	e8 f4 2d 00 00       	call   4038 <printf>
      exit();
    1244:	e8 73 2c 00 00       	call   3ebc <exit>
    }
    unlink(fname);
    1249:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124c:	89 04 24             	mov    %eax,(%esp)
    124f:	e8 b8 2c 00 00       	call   3f0c <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    1254:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
    1258:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
    125c:	0f 8e 1b ff ff ff    	jle    117d <fourfiles+0x16c>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    1262:	c7 44 24 04 72 4a 00 	movl   $0x4a72,0x4(%esp)
    1269:	00 
    126a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1271:	e8 c2 2d 00 00       	call   4038 <printf>
}
    1276:	c9                   	leave  
    1277:	c3                   	ret    

00001278 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1278:	55                   	push   %ebp
    1279:	89 e5                	mov    %esp,%ebp
    127b:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    127e:	c7 44 24 04 80 4a 00 	movl   $0x4a80,0x4(%esp)
    1285:	00 
    1286:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    128d:	e8 a6 2d 00 00       	call   4038 <printf>

  for(pi = 0; pi < 4; pi++){
    1292:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1299:	e9 f5 00 00 00       	jmp    1393 <createdelete+0x11b>
    pid = fork();
    129e:	e8 11 2c 00 00       	call   3eb4 <fork>
    12a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    12a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12aa:	79 19                	jns    12c5 <createdelete+0x4d>
      printf(1, "fork failed\n");
    12ac:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
    12b3:	00 
    12b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12bb:	e8 78 2d 00 00       	call   4038 <printf>
      exit();
    12c0:	e8 f7 2b 00 00       	call   3ebc <exit>
    }

    if(pid == 0){
    12c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12c9:	0f 85 c0 00 00 00    	jne    138f <createdelete+0x117>
      name[0] = 'p' + pi;
    12cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d2:	83 c0 70             	add    $0x70,%eax
    12d5:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12d8:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    12e3:	e9 98 00 00 00       	jmp    1380 <createdelete+0x108>
        name[1] = '0' + i;
    12e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12eb:	83 c0 30             	add    $0x30,%eax
    12ee:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12f1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12f8:	00 
    12f9:	8d 45 c8             	lea    -0x38(%ebp),%eax
    12fc:	89 04 24             	mov    %eax,(%esp)
    12ff:	e8 f8 2b 00 00       	call   3efc <open>
    1304:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(fd < 0){
    1307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    130b:	79 19                	jns    1326 <createdelete+0xae>
          printf(1, "create failed\n");
    130d:	c7 44 24 04 35 4a 00 	movl   $0x4a35,0x4(%esp)
    1314:	00 
    1315:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    131c:	e8 17 2d 00 00       	call   4038 <printf>
          exit();
    1321:	e8 96 2b 00 00       	call   3ebc <exit>
        }
        close(fd);
    1326:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1329:	89 04 24             	mov    %eax,(%esp)
    132c:	e8 b3 2b 00 00       	call   3ee4 <close>
        if(i > 0 && (i % 2 ) == 0){
    1331:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1335:	7e 45                	jle    137c <createdelete+0x104>
    1337:	8b 45 ec             	mov    -0x14(%ebp),%eax
    133a:	83 e0 01             	and    $0x1,%eax
    133d:	85 c0                	test   %eax,%eax
    133f:	75 3b                	jne    137c <createdelete+0x104>
          name[1] = '0' + (i / 2);
    1341:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1344:	89 c2                	mov    %eax,%edx
    1346:	c1 ea 1f             	shr    $0x1f,%edx
    1349:	8d 04 02             	lea    (%edx,%eax,1),%eax
    134c:	d1 f8                	sar    %eax
    134e:	83 c0 30             	add    $0x30,%eax
    1351:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1354:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1357:	89 04 24             	mov    %eax,(%esp)
    135a:	e8 ad 2b 00 00       	call   3f0c <unlink>
    135f:	85 c0                	test   %eax,%eax
    1361:	79 19                	jns    137c <createdelete+0x104>
            printf(1, "unlink failed\n");
    1363:	c7 44 24 04 24 45 00 	movl   $0x4524,0x4(%esp)
    136a:	00 
    136b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1372:	e8 c1 2c 00 00       	call   4038 <printf>
            exit();
    1377:	e8 40 2b 00 00       	call   3ebc <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    137c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1380:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    1384:	0f 8e 5e ff ff ff    	jle    12e8 <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    138a:	e8 2d 2b 00 00       	call   3ebc <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    138f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1393:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
    1397:	0f 8e 01 ff ff ff    	jle    129e <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    139d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13a4:	eb 09                	jmp    13af <createdelete+0x137>
    wait();
    13a6:	e8 19 2b 00 00       	call   3ec4 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13af:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
    13b3:	7e f1                	jle    13a6 <createdelete+0x12e>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13b5:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13b9:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13bd:	88 45 c9             	mov    %al,-0x37(%ebp)
    13c0:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13c4:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    13ce:	e9 bb 00 00 00       	jmp    148e <createdelete+0x216>
    for(pi = 0; pi < 4; pi++){
    13d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13da:	e9 a1 00 00 00       	jmp    1480 <createdelete+0x208>
      name[0] = 'p' + pi;
    13df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13e2:	83 c0 70             	add    $0x70,%eax
    13e5:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13eb:	83 c0 30             	add    $0x30,%eax
    13ee:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13f8:	00 
    13f9:	8d 45 c8             	lea    -0x38(%ebp),%eax
    13fc:	89 04 24             	mov    %eax,(%esp)
    13ff:	e8 f8 2a 00 00       	call   3efc <open>
    1404:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    140b:	74 06                	je     1413 <createdelete+0x19b>
    140d:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
    1411:	7e 26                	jle    1439 <createdelete+0x1c1>
    1413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1417:	79 20                	jns    1439 <createdelete+0x1c1>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1419:	8d 45 c8             	lea    -0x38(%ebp),%eax
    141c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1420:	c7 44 24 04 94 4a 00 	movl   $0x4a94,0x4(%esp)
    1427:	00 
    1428:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    142f:	e8 04 2c 00 00       	call   4038 <printf>
        exit();
    1434:	e8 83 2a 00 00       	call   3ebc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1439:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    143d:	7e 2c                	jle    146b <createdelete+0x1f3>
    143f:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
    1443:	7f 26                	jg     146b <createdelete+0x1f3>
    1445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1449:	78 20                	js     146b <createdelete+0x1f3>
        printf(1, "oops createdelete %s did exist\n", name);
    144b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    144e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1452:	c7 44 24 04 b8 4a 00 	movl   $0x4ab8,0x4(%esp)
    1459:	00 
    145a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1461:	e8 d2 2b 00 00       	call   4038 <printf>
        exit();
    1466:	e8 51 2a 00 00       	call   3ebc <exit>
      }
      if(fd >= 0)
    146b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    146f:	78 0b                	js     147c <createdelete+0x204>
        close(fd);
    1471:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1474:	89 04 24             	mov    %eax,(%esp)
    1477:	e8 68 2a 00 00       	call   3ee4 <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    147c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1480:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
    1484:	0f 8e 55 ff ff ff    	jle    13df <createdelete+0x167>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    148a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    148e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    1492:	0f 8e 3b ff ff ff    	jle    13d3 <createdelete+0x15b>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    1498:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    149f:	eb 34                	jmp    14d5 <createdelete+0x25d>
    for(pi = 0; pi < 4; pi++){
    14a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a8:	eb 21                	jmp    14cb <createdelete+0x253>
      name[0] = 'p' + i;
    14aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14ad:	83 c0 70             	add    $0x70,%eax
    14b0:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b6:	83 c0 30             	add    $0x30,%eax
    14b9:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14bc:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14bf:	89 04 24             	mov    %eax,(%esp)
    14c2:	e8 45 2a 00 00       	call   3f0c <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14cb:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
    14cf:	7e d9                	jle    14aa <createdelete+0x232>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14d1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    14d5:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    14d9:	7e c6                	jle    14a1 <createdelete+0x229>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14db:	c7 44 24 04 d8 4a 00 	movl   $0x4ad8,0x4(%esp)
    14e2:	00 
    14e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ea:	e8 49 2b 00 00       	call   4038 <printf>
}
    14ef:	c9                   	leave  
    14f0:	c3                   	ret    

000014f1 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14f1:	55                   	push   %ebp
    14f2:	89 e5                	mov    %esp,%ebp
    14f4:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    14f7:	c7 44 24 04 e9 4a 00 	movl   $0x4ae9,0x4(%esp)
    14fe:	00 
    14ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1506:	e8 2d 2b 00 00       	call   4038 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    150b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1512:	00 
    1513:	c7 04 24 fa 4a 00 00 	movl   $0x4afa,(%esp)
    151a:	e8 dd 29 00 00       	call   3efc <open>
    151f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1522:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1526:	79 19                	jns    1541 <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1528:	c7 44 24 04 05 4b 00 	movl   $0x4b05,0x4(%esp)
    152f:	00 
    1530:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1537:	e8 fc 2a 00 00       	call   4038 <printf>
    exit();
    153c:	e8 7b 29 00 00       	call   3ebc <exit>
  }
  write(fd, "hello", 5);
    1541:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1548:	00 
    1549:	c7 44 24 04 1f 4b 00 	movl   $0x4b1f,0x4(%esp)
    1550:	00 
    1551:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1554:	89 04 24             	mov    %eax,(%esp)
    1557:	e8 80 29 00 00       	call   3edc <write>
  close(fd);
    155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    155f:	89 04 24             	mov    %eax,(%esp)
    1562:	e8 7d 29 00 00       	call   3ee4 <close>

  fd = open("unlinkread", O_RDWR);
    1567:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    156e:	00 
    156f:	c7 04 24 fa 4a 00 00 	movl   $0x4afa,(%esp)
    1576:	e8 81 29 00 00       	call   3efc <open>
    157b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    157e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1582:	79 19                	jns    159d <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    1584:	c7 44 24 04 25 4b 00 	movl   $0x4b25,0x4(%esp)
    158b:	00 
    158c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1593:	e8 a0 2a 00 00       	call   4038 <printf>
    exit();
    1598:	e8 1f 29 00 00       	call   3ebc <exit>
  }
  if(unlink("unlinkread") != 0){
    159d:	c7 04 24 fa 4a 00 00 	movl   $0x4afa,(%esp)
    15a4:	e8 63 29 00 00       	call   3f0c <unlink>
    15a9:	85 c0                	test   %eax,%eax
    15ab:	74 19                	je     15c6 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15ad:	c7 44 24 04 3d 4b 00 	movl   $0x4b3d,0x4(%esp)
    15b4:	00 
    15b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15bc:	e8 77 2a 00 00       	call   4038 <printf>
    exit();
    15c1:	e8 f6 28 00 00       	call   3ebc <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15cd:	00 
    15ce:	c7 04 24 fa 4a 00 00 	movl   $0x4afa,(%esp)
    15d5:	e8 22 29 00 00       	call   3efc <open>
    15da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  write(fd1, "yyy", 3);
    15dd:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15e4:	00 
    15e5:	c7 44 24 04 57 4b 00 	movl   $0x4b57,0x4(%esp)
    15ec:	00 
    15ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f0:	89 04 24             	mov    %eax,(%esp)
    15f3:	e8 e4 28 00 00       	call   3edc <write>
  close(fd1);
    15f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fb:	89 04 24             	mov    %eax,(%esp)
    15fe:	e8 e1 28 00 00       	call   3ee4 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1603:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    160a:	00 
    160b:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    1612:	00 
    1613:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1616:	89 04 24             	mov    %eax,(%esp)
    1619:	e8 b6 28 00 00       	call   3ed4 <read>
    161e:	83 f8 05             	cmp    $0x5,%eax
    1621:	74 19                	je     163c <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    1623:	c7 44 24 04 5b 4b 00 	movl   $0x4b5b,0x4(%esp)
    162a:	00 
    162b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1632:	e8 01 2a 00 00       	call   4038 <printf>
    exit();
    1637:	e8 80 28 00 00       	call   3ebc <exit>
  }
  if(buf[0] != 'h'){
    163c:	0f b6 05 e0 83 00 00 	movzbl 0x83e0,%eax
    1643:	3c 68                	cmp    $0x68,%al
    1645:	74 19                	je     1660 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    1647:	c7 44 24 04 72 4b 00 	movl   $0x4b72,0x4(%esp)
    164e:	00 
    164f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1656:	e8 dd 29 00 00       	call   4038 <printf>
    exit();
    165b:	e8 5c 28 00 00       	call   3ebc <exit>
  }
  if(write(fd, buf, 10) != 10){
    1660:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1667:	00 
    1668:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    166f:	00 
    1670:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1673:	89 04 24             	mov    %eax,(%esp)
    1676:	e8 61 28 00 00       	call   3edc <write>
    167b:	83 f8 0a             	cmp    $0xa,%eax
    167e:	74 19                	je     1699 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    1680:	c7 44 24 04 89 4b 00 	movl   $0x4b89,0x4(%esp)
    1687:	00 
    1688:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    168f:	e8 a4 29 00 00       	call   4038 <printf>
    exit();
    1694:	e8 23 28 00 00       	call   3ebc <exit>
  }
  close(fd);
    1699:	8b 45 f0             	mov    -0x10(%ebp),%eax
    169c:	89 04 24             	mov    %eax,(%esp)
    169f:	e8 40 28 00 00       	call   3ee4 <close>
  unlink("unlinkread");
    16a4:	c7 04 24 fa 4a 00 00 	movl   $0x4afa,(%esp)
    16ab:	e8 5c 28 00 00       	call   3f0c <unlink>
  printf(1, "unlinkread ok\n");
    16b0:	c7 44 24 04 a2 4b 00 	movl   $0x4ba2,0x4(%esp)
    16b7:	00 
    16b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16bf:	e8 74 29 00 00       	call   4038 <printf>
}
    16c4:	c9                   	leave  
    16c5:	c3                   	ret    

000016c6 <linktest>:

void
linktest(void)
{
    16c6:	55                   	push   %ebp
    16c7:	89 e5                	mov    %esp,%ebp
    16c9:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16cc:	c7 44 24 04 b1 4b 00 	movl   $0x4bb1,0x4(%esp)
    16d3:	00 
    16d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16db:	e8 58 29 00 00       	call   4038 <printf>

  unlink("lf1");
    16e0:	c7 04 24 bb 4b 00 00 	movl   $0x4bbb,(%esp)
    16e7:	e8 20 28 00 00       	call   3f0c <unlink>
  unlink("lf2");
    16ec:	c7 04 24 bf 4b 00 00 	movl   $0x4bbf,(%esp)
    16f3:	e8 14 28 00 00       	call   3f0c <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    16f8:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    16ff:	00 
    1700:	c7 04 24 bb 4b 00 00 	movl   $0x4bbb,(%esp)
    1707:	e8 f0 27 00 00       	call   3efc <open>
    170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    170f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1713:	79 19                	jns    172e <linktest+0x68>
    printf(1, "create lf1 failed\n");
    1715:	c7 44 24 04 c3 4b 00 	movl   $0x4bc3,0x4(%esp)
    171c:	00 
    171d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1724:	e8 0f 29 00 00       	call   4038 <printf>
    exit();
    1729:	e8 8e 27 00 00       	call   3ebc <exit>
  }
  if(write(fd, "hello", 5) != 5){
    172e:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1735:	00 
    1736:	c7 44 24 04 1f 4b 00 	movl   $0x4b1f,0x4(%esp)
    173d:	00 
    173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1741:	89 04 24             	mov    %eax,(%esp)
    1744:	e8 93 27 00 00       	call   3edc <write>
    1749:	83 f8 05             	cmp    $0x5,%eax
    174c:	74 19                	je     1767 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    174e:	c7 44 24 04 d6 4b 00 	movl   $0x4bd6,0x4(%esp)
    1755:	00 
    1756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    175d:	e8 d6 28 00 00       	call   4038 <printf>
    exit();
    1762:	e8 55 27 00 00       	call   3ebc <exit>
  }
  close(fd);
    1767:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176a:	89 04 24             	mov    %eax,(%esp)
    176d:	e8 72 27 00 00       	call   3ee4 <close>

  if(link("lf1", "lf2") < 0){
    1772:	c7 44 24 04 bf 4b 00 	movl   $0x4bbf,0x4(%esp)
    1779:	00 
    177a:	c7 04 24 bb 4b 00 00 	movl   $0x4bbb,(%esp)
    1781:	e8 96 27 00 00       	call   3f1c <link>
    1786:	85 c0                	test   %eax,%eax
    1788:	79 19                	jns    17a3 <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    178a:	c7 44 24 04 e8 4b 00 	movl   $0x4be8,0x4(%esp)
    1791:	00 
    1792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1799:	e8 9a 28 00 00       	call   4038 <printf>
    exit();
    179e:	e8 19 27 00 00       	call   3ebc <exit>
  }
  unlink("lf1");
    17a3:	c7 04 24 bb 4b 00 00 	movl   $0x4bbb,(%esp)
    17aa:	e8 5d 27 00 00       	call   3f0c <unlink>

  if(open("lf1", 0) >= 0){
    17af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17b6:	00 
    17b7:	c7 04 24 bb 4b 00 00 	movl   $0x4bbb,(%esp)
    17be:	e8 39 27 00 00       	call   3efc <open>
    17c3:	85 c0                	test   %eax,%eax
    17c5:	78 19                	js     17e0 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17c7:	c7 44 24 04 00 4c 00 	movl   $0x4c00,0x4(%esp)
    17ce:	00 
    17cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17d6:	e8 5d 28 00 00       	call   4038 <printf>
    exit();
    17db:	e8 dc 26 00 00       	call   3ebc <exit>
  }

  fd = open("lf2", 0);
    17e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17e7:	00 
    17e8:	c7 04 24 bf 4b 00 00 	movl   $0x4bbf,(%esp)
    17ef:	e8 08 27 00 00       	call   3efc <open>
    17f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17fb:	79 19                	jns    1816 <linktest+0x150>
    printf(1, "open lf2 failed\n");
    17fd:	c7 44 24 04 25 4c 00 	movl   $0x4c25,0x4(%esp)
    1804:	00 
    1805:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    180c:	e8 27 28 00 00       	call   4038 <printf>
    exit();
    1811:	e8 a6 26 00 00       	call   3ebc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1816:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    181d:	00 
    181e:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    1825:	00 
    1826:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1829:	89 04 24             	mov    %eax,(%esp)
    182c:	e8 a3 26 00 00       	call   3ed4 <read>
    1831:	83 f8 05             	cmp    $0x5,%eax
    1834:	74 19                	je     184f <linktest+0x189>
    printf(1, "read lf2 failed\n");
    1836:	c7 44 24 04 36 4c 00 	movl   $0x4c36,0x4(%esp)
    183d:	00 
    183e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1845:	e8 ee 27 00 00       	call   4038 <printf>
    exit();
    184a:	e8 6d 26 00 00       	call   3ebc <exit>
  }
  close(fd);
    184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1852:	89 04 24             	mov    %eax,(%esp)
    1855:	e8 8a 26 00 00       	call   3ee4 <close>

  if(link("lf2", "lf2") >= 0){
    185a:	c7 44 24 04 bf 4b 00 	movl   $0x4bbf,0x4(%esp)
    1861:	00 
    1862:	c7 04 24 bf 4b 00 00 	movl   $0x4bbf,(%esp)
    1869:	e8 ae 26 00 00       	call   3f1c <link>
    186e:	85 c0                	test   %eax,%eax
    1870:	78 19                	js     188b <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1872:	c7 44 24 04 47 4c 00 	movl   $0x4c47,0x4(%esp)
    1879:	00 
    187a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1881:	e8 b2 27 00 00       	call   4038 <printf>
    exit();
    1886:	e8 31 26 00 00       	call   3ebc <exit>
  }

  unlink("lf2");
    188b:	c7 04 24 bf 4b 00 00 	movl   $0x4bbf,(%esp)
    1892:	e8 75 26 00 00       	call   3f0c <unlink>
  if(link("lf2", "lf1") >= 0){
    1897:	c7 44 24 04 bb 4b 00 	movl   $0x4bbb,0x4(%esp)
    189e:	00 
    189f:	c7 04 24 bf 4b 00 00 	movl   $0x4bbf,(%esp)
    18a6:	e8 71 26 00 00       	call   3f1c <link>
    18ab:	85 c0                	test   %eax,%eax
    18ad:	78 19                	js     18c8 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18af:	c7 44 24 04 68 4c 00 	movl   $0x4c68,0x4(%esp)
    18b6:	00 
    18b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18be:	e8 75 27 00 00       	call   4038 <printf>
    exit();
    18c3:	e8 f4 25 00 00       	call   3ebc <exit>
  }

  if(link(".", "lf1") >= 0){
    18c8:	c7 44 24 04 bb 4b 00 	movl   $0x4bbb,0x4(%esp)
    18cf:	00 
    18d0:	c7 04 24 8b 4c 00 00 	movl   $0x4c8b,(%esp)
    18d7:	e8 40 26 00 00       	call   3f1c <link>
    18dc:	85 c0                	test   %eax,%eax
    18de:	78 19                	js     18f9 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18e0:	c7 44 24 04 8d 4c 00 	movl   $0x4c8d,0x4(%esp)
    18e7:	00 
    18e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18ef:	e8 44 27 00 00       	call   4038 <printf>
    exit();
    18f4:	e8 c3 25 00 00       	call   3ebc <exit>
  }

  printf(1, "linktest ok\n");
    18f9:	c7 44 24 04 a9 4c 00 	movl   $0x4ca9,0x4(%esp)
    1900:	00 
    1901:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1908:	e8 2b 27 00 00       	call   4038 <printf>
}
    190d:	c9                   	leave  
    190e:	c3                   	ret    

0000190f <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    190f:	55                   	push   %ebp
    1910:	89 e5                	mov    %esp,%ebp
    1912:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1915:	c7 44 24 04 b6 4c 00 	movl   $0x4cb6,0x4(%esp)
    191c:	00 
    191d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1924:	e8 0f 27 00 00       	call   4038 <printf>
  file[0] = 'C';
    1929:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    192d:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1931:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1938:	e9 f7 00 00 00       	jmp    1a34 <concreate+0x125>
    file[1] = '0' + i;
    193d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1940:	83 c0 30             	add    $0x30,%eax
    1943:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1946:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1949:	89 04 24             	mov    %eax,(%esp)
    194c:	e8 bb 25 00 00       	call   3f0c <unlink>
    pid = fork();
    1951:	e8 5e 25 00 00       	call   3eb4 <fork>
    1956:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    195d:	74 3a                	je     1999 <concreate+0x8a>
    195f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1962:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1967:	89 c8                	mov    %ecx,%eax
    1969:	f7 ea                	imul   %edx
    196b:	89 c8                	mov    %ecx,%eax
    196d:	c1 f8 1f             	sar    $0x1f,%eax
    1970:	29 c2                	sub    %eax,%edx
    1972:	89 d0                	mov    %edx,%eax
    1974:	01 c0                	add    %eax,%eax
    1976:	01 d0                	add    %edx,%eax
    1978:	89 ca                	mov    %ecx,%edx
    197a:	29 c2                	sub    %eax,%edx
    197c:	83 fa 01             	cmp    $0x1,%edx
    197f:	75 18                	jne    1999 <concreate+0x8a>
      link("C0", file);
    1981:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1984:	89 44 24 04          	mov    %eax,0x4(%esp)
    1988:	c7 04 24 c6 4c 00 00 	movl   $0x4cc6,(%esp)
    198f:	e8 88 25 00 00       	call   3f1c <link>
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1994:	e9 87 00 00 00       	jmp    1a20 <concreate+0x111>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    1999:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    199d:	75 3a                	jne    19d9 <concreate+0xca>
    199f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    19a2:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19a7:	89 c8                	mov    %ecx,%eax
    19a9:	f7 ea                	imul   %edx
    19ab:	d1 fa                	sar    %edx
    19ad:	89 c8                	mov    %ecx,%eax
    19af:	c1 f8 1f             	sar    $0x1f,%eax
    19b2:	29 c2                	sub    %eax,%edx
    19b4:	89 d0                	mov    %edx,%eax
    19b6:	c1 e0 02             	shl    $0x2,%eax
    19b9:	01 d0                	add    %edx,%eax
    19bb:	89 ca                	mov    %ecx,%edx
    19bd:	29 c2                	sub    %eax,%edx
    19bf:	83 fa 01             	cmp    $0x1,%edx
    19c2:	75 15                	jne    19d9 <concreate+0xca>
      link("C0", file);
    19c4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    19cb:	c7 04 24 c6 4c 00 00 	movl   $0x4cc6,(%esp)
    19d2:	e8 45 25 00 00       	call   3f1c <link>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    19d7:	eb 47                	jmp    1a20 <concreate+0x111>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19d9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19e0:	00 
    19e1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e4:	89 04 24             	mov    %eax,(%esp)
    19e7:	e8 10 25 00 00       	call   3efc <open>
    19ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(fd < 0){
    19ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19f3:	79 20                	jns    1a15 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19f5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19f8:	89 44 24 08          	mov    %eax,0x8(%esp)
    19fc:	c7 44 24 04 c9 4c 00 	movl   $0x4cc9,0x4(%esp)
    1a03:	00 
    1a04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a0b:	e8 28 26 00 00       	call   4038 <printf>
        exit();
    1a10:	e8 a7 24 00 00       	call   3ebc <exit>
      }
      close(fd);
    1a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a18:	89 04 24             	mov    %eax,(%esp)
    1a1b:	e8 c4 24 00 00       	call   3ee4 <close>
    }
    if(pid == 0)
    1a20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a24:	75 05                	jne    1a2b <concreate+0x11c>
      exit();
    1a26:	e8 91 24 00 00       	call   3ebc <exit>
    else
      wait();
    1a2b:	e8 94 24 00 00       	call   3ec4 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a30:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1a34:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    1a38:	0f 8e ff fe ff ff    	jle    193d <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a3e:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a45:	00 
    1a46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a4d:	00 
    1a4e:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a51:	89 04 24             	mov    %eax,(%esp)
    1a54:	e8 bd 22 00 00       	call   3d16 <memset>
  fd = open(".", 0);
    1a59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a60:	00 
    1a61:	c7 04 24 8b 4c 00 00 	movl   $0x4c8b,(%esp)
    1a68:	e8 8f 24 00 00       	call   3efc <open>
    1a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  n = 0;
    1a70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a77:	e9 9d 00 00 00       	jmp    1b19 <concreate+0x20a>
    if(de.inum == 0)
    1a7c:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a80:	66 85 c0             	test   %ax,%ax
    1a83:	0f 84 8f 00 00 00    	je     1b18 <concreate+0x209>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a89:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a8d:	3c 43                	cmp    $0x43,%al
    1a8f:	0f 85 84 00 00 00    	jne    1b19 <concreate+0x20a>
    1a95:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1a99:	84 c0                	test   %al,%al
    1a9b:	75 7c                	jne    1b19 <concreate+0x20a>
      i = de.name[1] - '0';
    1a9d:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aa1:	0f be c0             	movsbl %al,%eax
    1aa4:	83 e8 30             	sub    $0x30,%eax
    1aa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1aaa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1aae:	78 08                	js     1ab8 <concreate+0x1a9>
    1ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ab3:	83 f8 27             	cmp    $0x27,%eax
    1ab6:	76 23                	jbe    1adb <concreate+0x1cc>
        printf(1, "concreate weird file %s\n", de.name);
    1ab8:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1abb:	83 c0 02             	add    $0x2,%eax
    1abe:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ac2:	c7 44 24 04 e5 4c 00 	movl   $0x4ce5,0x4(%esp)
    1ac9:	00 
    1aca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ad1:	e8 62 25 00 00       	call   4038 <printf>
        exit();
    1ad6:	e8 e1 23 00 00       	call   3ebc <exit>
      }
      if(fa[i]){
    1adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ade:	0f b6 44 05 bd       	movzbl -0x43(%ebp,%eax,1),%eax
    1ae3:	84 c0                	test   %al,%al
    1ae5:	74 23                	je     1b0a <concreate+0x1fb>
        printf(1, "concreate duplicate file %s\n", de.name);
    1ae7:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1aea:	83 c0 02             	add    $0x2,%eax
    1aed:	89 44 24 08          	mov    %eax,0x8(%esp)
    1af1:	c7 44 24 04 fe 4c 00 	movl   $0x4cfe,0x4(%esp)
    1af8:	00 
    1af9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b00:	e8 33 25 00 00       	call   4038 <printf>
        exit();
    1b05:	e8 b2 23 00 00       	call   3ebc <exit>
      }
      fa[i] = 1;
    1b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b0d:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    1b12:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b16:	eb 01                	jmp    1b19 <concreate+0x20a>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    1b18:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b19:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b20:	00 
    1b21:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b24:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2b:	89 04 24             	mov    %eax,(%esp)
    1b2e:	e8 a1 23 00 00       	call   3ed4 <read>
    1b33:	85 c0                	test   %eax,%eax
    1b35:	0f 8f 41 ff ff ff    	jg     1a7c <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3e:	89 04 24             	mov    %eax,(%esp)
    1b41:	e8 9e 23 00 00       	call   3ee4 <close>

  if(n != 40){
    1b46:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b4a:	74 19                	je     1b65 <concreate+0x256>
    printf(1, "concreate not enough files in directory listing\n");
    1b4c:	c7 44 24 04 1c 4d 00 	movl   $0x4d1c,0x4(%esp)
    1b53:	00 
    1b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b5b:	e8 d8 24 00 00       	call   4038 <printf>
    exit();
    1b60:	e8 57 23 00 00       	call   3ebc <exit>
  }

  for(i = 0; i < 40; i++){
    1b65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1b6c:	e9 2d 01 00 00       	jmp    1c9e <concreate+0x38f>
    file[1] = '0' + i;
    1b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b74:	83 c0 30             	add    $0x30,%eax
    1b77:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b7a:	e8 35 23 00 00       	call   3eb4 <fork>
    1b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b86:	79 19                	jns    1ba1 <concreate+0x292>
      printf(1, "fork failed\n");
    1b88:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
    1b8f:	00 
    1b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b97:	e8 9c 24 00 00       	call   4038 <printf>
      exit();
    1b9c:	e8 1b 23 00 00       	call   3ebc <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1ba1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1ba4:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1ba9:	89 c8                	mov    %ecx,%eax
    1bab:	f7 ea                	imul   %edx
    1bad:	89 c8                	mov    %ecx,%eax
    1baf:	c1 f8 1f             	sar    $0x1f,%eax
    1bb2:	29 c2                	sub    %eax,%edx
    1bb4:	89 d0                	mov    %edx,%eax
    1bb6:	01 c0                	add    %eax,%eax
    1bb8:	01 d0                	add    %edx,%eax
    1bba:	89 ca                	mov    %ecx,%edx
    1bbc:	29 c2                	sub    %eax,%edx
    1bbe:	85 d2                	test   %edx,%edx
    1bc0:	75 06                	jne    1bc8 <concreate+0x2b9>
    1bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bc6:	74 28                	je     1bf0 <concreate+0x2e1>
       ((i % 3) == 1 && pid != 0)){
    1bc8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    1bcb:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bd0:	89 c8                	mov    %ecx,%eax
    1bd2:	f7 ea                	imul   %edx
    1bd4:	89 c8                	mov    %ecx,%eax
    1bd6:	c1 f8 1f             	sar    $0x1f,%eax
    1bd9:	29 c2                	sub    %eax,%edx
    1bdb:	89 d0                	mov    %edx,%eax
    1bdd:	01 c0                	add    %eax,%eax
    1bdf:	01 d0                	add    %edx,%eax
    1be1:	89 ca                	mov    %ecx,%edx
    1be3:	29 c2                	sub    %eax,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1be5:	83 fa 01             	cmp    $0x1,%edx
    1be8:	75 74                	jne    1c5e <concreate+0x34f>
    1bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bee:	74 6e                	je     1c5e <concreate+0x34f>
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    1bf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1bf7:	00 
    1bf8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bfb:	89 04 24             	mov    %eax,(%esp)
    1bfe:	e8 f9 22 00 00       	call   3efc <open>
    1c03:	89 04 24             	mov    %eax,(%esp)
    1c06:	e8 d9 22 00 00       	call   3ee4 <close>
      close(open(file, 0));
    1c0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c12:	00 
    1c13:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c16:	89 04 24             	mov    %eax,(%esp)
    1c19:	e8 de 22 00 00       	call   3efc <open>
    1c1e:	89 04 24             	mov    %eax,(%esp)
    1c21:	e8 be 22 00 00       	call   3ee4 <close>
      close(open(file, 0));
    1c26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c2d:	00 
    1c2e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c31:	89 04 24             	mov    %eax,(%esp)
    1c34:	e8 c3 22 00 00       	call   3efc <open>
    1c39:	89 04 24             	mov    %eax,(%esp)
    1c3c:	e8 a3 22 00 00       	call   3ee4 <close>
      close(open(file, 0));
    1c41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c48:	00 
    1c49:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c4c:	89 04 24             	mov    %eax,(%esp)
    1c4f:	e8 a8 22 00 00       	call   3efc <open>
    1c54:	89 04 24             	mov    %eax,(%esp)
    1c57:	e8 88 22 00 00       	call   3ee4 <close>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1c5c:	eb 2c                	jmp    1c8a <concreate+0x37b>
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
      close(open(file, 0));
    } else {
      unlink(file);
    1c5e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c61:	89 04 24             	mov    %eax,(%esp)
    1c64:	e8 a3 22 00 00       	call   3f0c <unlink>
      unlink(file);
    1c69:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6c:	89 04 24             	mov    %eax,(%esp)
    1c6f:	e8 98 22 00 00       	call   3f0c <unlink>
      unlink(file);
    1c74:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c77:	89 04 24             	mov    %eax,(%esp)
    1c7a:	e8 8d 22 00 00       	call   3f0c <unlink>
      unlink(file);
    1c7f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c82:	89 04 24             	mov    %eax,(%esp)
    1c85:	e8 82 22 00 00       	call   3f0c <unlink>
    }
    if(pid == 0)
    1c8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c8e:	75 05                	jne    1c95 <concreate+0x386>
      exit();
    1c90:	e8 27 22 00 00       	call   3ebc <exit>
    else
      wait();
    1c95:	e8 2a 22 00 00       	call   3ec4 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1c9a:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1c9e:	83 7d e8 27          	cmpl   $0x27,-0x18(%ebp)
    1ca2:	0f 8e c9 fe ff ff    	jle    1b71 <concreate+0x262>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1ca8:	c7 44 24 04 4d 4d 00 	movl   $0x4d4d,0x4(%esp)
    1caf:	00 
    1cb0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cb7:	e8 7c 23 00 00       	call   4038 <printf>
}
    1cbc:	c9                   	leave  
    1cbd:	c3                   	ret    

00001cbe <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cbe:	55                   	push   %ebp
    1cbf:	89 e5                	mov    %esp,%ebp
    1cc1:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cc4:	c7 44 24 04 5b 4d 00 	movl   $0x4d5b,0x4(%esp)
    1ccb:	00 
    1ccc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cd3:	e8 60 23 00 00       	call   4038 <printf>

  unlink("x");
    1cd8:	c7 04 24 d7 48 00 00 	movl   $0x48d7,(%esp)
    1cdf:	e8 28 22 00 00       	call   3f0c <unlink>
  pid = fork();
    1ce4:	e8 cb 21 00 00       	call   3eb4 <fork>
    1ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cf0:	79 19                	jns    1d0b <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1cf2:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
    1cf9:	00 
    1cfa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d01:	e8 32 23 00 00       	call   4038 <printf>
    exit();
    1d06:	e8 b1 21 00 00       	call   3ebc <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d0f:	74 07                	je     1d18 <linkunlink+0x5a>
    1d11:	b8 01 00 00 00       	mov    $0x1,%eax
    1d16:	eb 05                	jmp    1d1d <linkunlink+0x5f>
    1d18:	b8 61 00 00 00       	mov    $0x61,%eax
    1d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 100; i++){
    1d20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1d27:	e9 8e 00 00 00       	jmp    1dba <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d2f:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d35:	05 39 30 00 00       	add    $0x3039,%eax
    1d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((x % 3) == 0){
    1d3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1d40:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d45:	89 c8                	mov    %ecx,%eax
    1d47:	f7 e2                	mul    %edx
    1d49:	d1 ea                	shr    %edx
    1d4b:	89 d0                	mov    %edx,%eax
    1d4d:	01 c0                	add    %eax,%eax
    1d4f:	01 d0                	add    %edx,%eax
    1d51:	89 ca                	mov    %ecx,%edx
    1d53:	29 c2                	sub    %eax,%edx
    1d55:	85 d2                	test   %edx,%edx
    1d57:	75 1e                	jne    1d77 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1d59:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d60:	00 
    1d61:	c7 04 24 d7 48 00 00 	movl   $0x48d7,(%esp)
    1d68:	e8 8f 21 00 00       	call   3efc <open>
    1d6d:	89 04 24             	mov    %eax,(%esp)
    1d70:	e8 6f 21 00 00       	call   3ee4 <close>
    1d75:	eb 3f                	jmp    1db6 <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1d77:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1d7a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d7f:	89 c8                	mov    %ecx,%eax
    1d81:	f7 e2                	mul    %edx
    1d83:	d1 ea                	shr    %edx
    1d85:	89 d0                	mov    %edx,%eax
    1d87:	01 c0                	add    %eax,%eax
    1d89:	01 d0                	add    %edx,%eax
    1d8b:	89 ca                	mov    %ecx,%edx
    1d8d:	29 c2                	sub    %eax,%edx
    1d8f:	83 fa 01             	cmp    $0x1,%edx
    1d92:	75 16                	jne    1daa <linkunlink+0xec>
      link("cat", "x");
    1d94:	c7 44 24 04 d7 48 00 	movl   $0x48d7,0x4(%esp)
    1d9b:	00 
    1d9c:	c7 04 24 6c 4d 00 00 	movl   $0x4d6c,(%esp)
    1da3:	e8 74 21 00 00       	call   3f1c <link>
    1da8:	eb 0c                	jmp    1db6 <linkunlink+0xf8>
    } else {
      unlink("x");
    1daa:	c7 04 24 d7 48 00 00 	movl   $0x48d7,(%esp)
    1db1:	e8 56 21 00 00       	call   3f0c <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1db6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1dba:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
    1dbe:	0f 8e 68 ff ff ff    	jle    1d2c <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dc8:	74 1b                	je     1de5 <linkunlink+0x127>
    wait();
    1dca:	e8 f5 20 00 00       	call   3ec4 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1dcf:	c7 44 24 04 70 4d 00 	movl   $0x4d70,0x4(%esp)
    1dd6:	00 
    1dd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dde:	e8 55 22 00 00       	call   4038 <printf>
}
    1de3:	c9                   	leave  
    1de4:	c3                   	ret    
  }

  if(pid)
    wait();
  else 
    exit();
    1de5:	e8 d2 20 00 00       	call   3ebc <exit>

00001dea <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1dea:	55                   	push   %ebp
    1deb:	89 e5                	mov    %esp,%ebp
    1ded:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1df0:	c7 44 24 04 7f 4d 00 	movl   $0x4d7f,0x4(%esp)
    1df7:	00 
    1df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dff:	e8 34 22 00 00       	call   4038 <printf>
  unlink("bd");
    1e04:	c7 04 24 8c 4d 00 00 	movl   $0x4d8c,(%esp)
    1e0b:	e8 fc 20 00 00       	call   3f0c <unlink>

  fd = open("bd", O_CREATE);
    1e10:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e17:	00 
    1e18:	c7 04 24 8c 4d 00 00 	movl   $0x4d8c,(%esp)
    1e1f:	e8 d8 20 00 00       	call   3efc <open>
    1e24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1e27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e2b:	79 19                	jns    1e46 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e2d:	c7 44 24 04 8f 4d 00 	movl   $0x4d8f,0x4(%esp)
    1e34:	00 
    1e35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e3c:	e8 f7 21 00 00       	call   4038 <printf>
    exit();
    1e41:	e8 76 20 00 00       	call   3ebc <exit>
  }
  close(fd);
    1e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e49:	89 04 24             	mov    %eax,(%esp)
    1e4c:	e8 93 20 00 00       	call   3ee4 <close>

  for(i = 0; i < 500; i++){
    1e51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1e58:	eb 68                	jmp    1ec2 <bigdir+0xd8>
    name[0] = 'x';
    1e5a:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e61:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e64:	85 c0                	test   %eax,%eax
    1e66:	0f 48 c2             	cmovs  %edx,%eax
    1e69:	c1 f8 06             	sar    $0x6,%eax
    1e6c:	83 c0 30             	add    $0x30,%eax
    1e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e75:	89 c2                	mov    %eax,%edx
    1e77:	c1 fa 1f             	sar    $0x1f,%edx
    1e7a:	c1 ea 1a             	shr    $0x1a,%edx
    1e7d:	01 d0                	add    %edx,%eax
    1e7f:	83 e0 3f             	and    $0x3f,%eax
    1e82:	29 d0                	sub    %edx,%eax
    1e84:	83 c0 30             	add    $0x30,%eax
    1e87:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e8a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e8e:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1e91:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e95:	c7 04 24 8c 4d 00 00 	movl   $0x4d8c,(%esp)
    1e9c:	e8 7b 20 00 00       	call   3f1c <link>
    1ea1:	85 c0                	test   %eax,%eax
    1ea3:	74 19                	je     1ebe <bigdir+0xd4>
      printf(1, "bigdir link failed\n");
    1ea5:	c7 44 24 04 a5 4d 00 	movl   $0x4da5,0x4(%esp)
    1eac:	00 
    1ead:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eb4:	e8 7f 21 00 00       	call   4038 <printf>
      exit();
    1eb9:	e8 fe 1f 00 00       	call   3ebc <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ebe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1ec2:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    1ec9:	7e 8f                	jle    1e5a <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1ecb:	c7 04 24 8c 4d 00 00 	movl   $0x4d8c,(%esp)
    1ed2:	e8 35 20 00 00       	call   3f0c <unlink>
  for(i = 0; i < 500; i++){
    1ed7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1ede:	eb 60                	jmp    1f40 <bigdir+0x156>
    name[0] = 'x';
    1ee0:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ee7:	8d 50 3f             	lea    0x3f(%eax),%edx
    1eea:	85 c0                	test   %eax,%eax
    1eec:	0f 48 c2             	cmovs  %edx,%eax
    1eef:	c1 f8 06             	sar    $0x6,%eax
    1ef2:	83 c0 30             	add    $0x30,%eax
    1ef5:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1efb:	89 c2                	mov    %eax,%edx
    1efd:	c1 fa 1f             	sar    $0x1f,%edx
    1f00:	c1 ea 1a             	shr    $0x1a,%edx
    1f03:	01 d0                	add    %edx,%eax
    1f05:	83 e0 3f             	and    $0x3f,%eax
    1f08:	29 d0                	sub    %edx,%eax
    1f0a:	83 c0 30             	add    $0x30,%eax
    1f0d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f10:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f14:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f17:	89 04 24             	mov    %eax,(%esp)
    1f1a:	e8 ed 1f 00 00       	call   3f0c <unlink>
    1f1f:	85 c0                	test   %eax,%eax
    1f21:	74 19                	je     1f3c <bigdir+0x152>
      printf(1, "bigdir unlink failed");
    1f23:	c7 44 24 04 b9 4d 00 	movl   $0x4db9,0x4(%esp)
    1f2a:	00 
    1f2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f32:	e8 01 21 00 00       	call   4038 <printf>
      exit();
    1f37:	e8 80 1f 00 00       	call   3ebc <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f3c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1f40:	81 7d f0 f3 01 00 00 	cmpl   $0x1f3,-0x10(%ebp)
    1f47:	7e 97                	jle    1ee0 <bigdir+0xf6>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f49:	c7 44 24 04 ce 4d 00 	movl   $0x4dce,0x4(%esp)
    1f50:	00 
    1f51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f58:	e8 db 20 00 00       	call   4038 <printf>
}
    1f5d:	c9                   	leave  
    1f5e:	c3                   	ret    

00001f5f <subdir>:

void
subdir(void)
{
    1f5f:	55                   	push   %ebp
    1f60:	89 e5                	mov    %esp,%ebp
    1f62:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f65:	c7 44 24 04 d9 4d 00 	movl   $0x4dd9,0x4(%esp)
    1f6c:	00 
    1f6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f74:	e8 bf 20 00 00       	call   4038 <printf>

  unlink("ff");
    1f79:	c7 04 24 e6 4d 00 00 	movl   $0x4de6,(%esp)
    1f80:	e8 87 1f 00 00       	call   3f0c <unlink>
  if(mkdir("dd") != 0){
    1f85:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    1f8c:	e8 93 1f 00 00       	call   3f24 <mkdir>
    1f91:	85 c0                	test   %eax,%eax
    1f93:	74 19                	je     1fae <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1f95:	c7 44 24 04 ec 4d 00 	movl   $0x4dec,0x4(%esp)
    1f9c:	00 
    1f9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fa4:	e8 8f 20 00 00       	call   4038 <printf>
    exit();
    1fa9:	e8 0e 1f 00 00       	call   3ebc <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fae:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1fb5:	00 
    1fb6:	c7 04 24 04 4e 00 00 	movl   $0x4e04,(%esp)
    1fbd:	e8 3a 1f 00 00       	call   3efc <open>
    1fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1fc5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1fc9:	79 19                	jns    1fe4 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1fcb:	c7 44 24 04 0a 4e 00 	movl   $0x4e0a,0x4(%esp)
    1fd2:	00 
    1fd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fda:	e8 59 20 00 00       	call   4038 <printf>
    exit();
    1fdf:	e8 d8 1e 00 00       	call   3ebc <exit>
  }
  write(fd, "ff", 2);
    1fe4:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1feb:	00 
    1fec:	c7 44 24 04 e6 4d 00 	movl   $0x4de6,0x4(%esp)
    1ff3:	00 
    1ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ff7:	89 04 24             	mov    %eax,(%esp)
    1ffa:	e8 dd 1e 00 00       	call   3edc <write>
  close(fd);
    1fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2002:	89 04 24             	mov    %eax,(%esp)
    2005:	e8 da 1e 00 00       	call   3ee4 <close>
  
  if(unlink("dd") >= 0){
    200a:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    2011:	e8 f6 1e 00 00       	call   3f0c <unlink>
    2016:	85 c0                	test   %eax,%eax
    2018:	78 19                	js     2033 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    201a:	c7 44 24 04 20 4e 00 	movl   $0x4e20,0x4(%esp)
    2021:	00 
    2022:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2029:	e8 0a 20 00 00       	call   4038 <printf>
    exit();
    202e:	e8 89 1e 00 00       	call   3ebc <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2033:	c7 04 24 46 4e 00 00 	movl   $0x4e46,(%esp)
    203a:	e8 e5 1e 00 00       	call   3f24 <mkdir>
    203f:	85 c0                	test   %eax,%eax
    2041:	74 19                	je     205c <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    2043:	c7 44 24 04 4d 4e 00 	movl   $0x4e4d,0x4(%esp)
    204a:	00 
    204b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2052:	e8 e1 1f 00 00       	call   4038 <printf>
    exit();
    2057:	e8 60 1e 00 00       	call   3ebc <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    205c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2063:	00 
    2064:	c7 04 24 68 4e 00 00 	movl   $0x4e68,(%esp)
    206b:	e8 8c 1e 00 00       	call   3efc <open>
    2070:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    2073:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2077:	79 19                	jns    2092 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    2079:	c7 44 24 04 71 4e 00 	movl   $0x4e71,0x4(%esp)
    2080:	00 
    2081:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2088:	e8 ab 1f 00 00       	call   4038 <printf>
    exit();
    208d:	e8 2a 1e 00 00       	call   3ebc <exit>
  }
  write(fd, "FF", 2);
    2092:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2099:	00 
    209a:	c7 44 24 04 89 4e 00 	movl   $0x4e89,0x4(%esp)
    20a1:	00 
    20a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    20a5:	89 04 24             	mov    %eax,(%esp)
    20a8:	e8 2f 1e 00 00       	call   3edc <write>
  close(fd);
    20ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    20b0:	89 04 24             	mov    %eax,(%esp)
    20b3:	e8 2c 1e 00 00       	call   3ee4 <close>

  fd = open("dd/dd/../ff", 0);
    20b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20bf:	00 
    20c0:	c7 04 24 8c 4e 00 00 	movl   $0x4e8c,(%esp)
    20c7:	e8 30 1e 00 00       	call   3efc <open>
    20cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    20cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    20d3:	79 19                	jns    20ee <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    20d5:	c7 44 24 04 98 4e 00 	movl   $0x4e98,0x4(%esp)
    20dc:	00 
    20dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20e4:	e8 4f 1f 00 00       	call   4038 <printf>
    exit();
    20e9:	e8 ce 1d 00 00       	call   3ebc <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20ee:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    20f5:	00 
    20f6:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    20fd:	00 
    20fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2101:	89 04 24             	mov    %eax,(%esp)
    2104:	e8 cb 1d 00 00       	call   3ed4 <read>
    2109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    210c:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
    2110:	75 0b                	jne    211d <subdir+0x1be>
    2112:	0f b6 05 e0 83 00 00 	movzbl 0x83e0,%eax
    2119:	3c 66                	cmp    $0x66,%al
    211b:	74 19                	je     2136 <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    211d:	c7 44 24 04 b1 4e 00 	movl   $0x4eb1,0x4(%esp)
    2124:	00 
    2125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    212c:	e8 07 1f 00 00       	call   4038 <printf>
    exit();
    2131:	e8 86 1d 00 00       	call   3ebc <exit>
  }
  close(fd);
    2136:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2139:	89 04 24             	mov    %eax,(%esp)
    213c:	e8 a3 1d 00 00       	call   3ee4 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2141:	c7 44 24 04 cc 4e 00 	movl   $0x4ecc,0x4(%esp)
    2148:	00 
    2149:	c7 04 24 68 4e 00 00 	movl   $0x4e68,(%esp)
    2150:	e8 c7 1d 00 00       	call   3f1c <link>
    2155:	85 c0                	test   %eax,%eax
    2157:	74 19                	je     2172 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2159:	c7 44 24 04 d8 4e 00 	movl   $0x4ed8,0x4(%esp)
    2160:	00 
    2161:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2168:	e8 cb 1e 00 00       	call   4038 <printf>
    exit();
    216d:	e8 4a 1d 00 00       	call   3ebc <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2172:	c7 04 24 68 4e 00 00 	movl   $0x4e68,(%esp)
    2179:	e8 8e 1d 00 00       	call   3f0c <unlink>
    217e:	85 c0                	test   %eax,%eax
    2180:	74 19                	je     219b <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    2182:	c7 44 24 04 f9 4e 00 	movl   $0x4ef9,0x4(%esp)
    2189:	00 
    218a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2191:	e8 a2 1e 00 00       	call   4038 <printf>
    exit();
    2196:	e8 21 1d 00 00       	call   3ebc <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    219b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21a2:	00 
    21a3:	c7 04 24 68 4e 00 00 	movl   $0x4e68,(%esp)
    21aa:	e8 4d 1d 00 00       	call   3efc <open>
    21af:	85 c0                	test   %eax,%eax
    21b1:	78 19                	js     21cc <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21b3:	c7 44 24 04 14 4f 00 	movl   $0x4f14,0x4(%esp)
    21ba:	00 
    21bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c2:	e8 71 1e 00 00       	call   4038 <printf>
    exit();
    21c7:	e8 f0 1c 00 00       	call   3ebc <exit>
  }

  if(chdir("dd") != 0){
    21cc:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    21d3:	e8 54 1d 00 00       	call   3f2c <chdir>
    21d8:	85 c0                	test   %eax,%eax
    21da:	74 19                	je     21f5 <subdir+0x296>
    printf(1, "chdir dd failed\n");
    21dc:	c7 44 24 04 38 4f 00 	movl   $0x4f38,0x4(%esp)
    21e3:	00 
    21e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21eb:	e8 48 1e 00 00       	call   4038 <printf>
    exit();
    21f0:	e8 c7 1c 00 00       	call   3ebc <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21f5:	c7 04 24 49 4f 00 00 	movl   $0x4f49,(%esp)
    21fc:	e8 2b 1d 00 00       	call   3f2c <chdir>
    2201:	85 c0                	test   %eax,%eax
    2203:	74 19                	je     221e <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    2205:	c7 44 24 04 55 4f 00 	movl   $0x4f55,0x4(%esp)
    220c:	00 
    220d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2214:	e8 1f 1e 00 00       	call   4038 <printf>
    exit();
    2219:	e8 9e 1c 00 00       	call   3ebc <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    221e:	c7 04 24 6f 4f 00 00 	movl   $0x4f6f,(%esp)
    2225:	e8 02 1d 00 00       	call   3f2c <chdir>
    222a:	85 c0                	test   %eax,%eax
    222c:	74 19                	je     2247 <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    222e:	c7 44 24 04 55 4f 00 	movl   $0x4f55,0x4(%esp)
    2235:	00 
    2236:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    223d:	e8 f6 1d 00 00       	call   4038 <printf>
    exit();
    2242:	e8 75 1c 00 00       	call   3ebc <exit>
  }
  if(chdir("./..") != 0){
    2247:	c7 04 24 7e 4f 00 00 	movl   $0x4f7e,(%esp)
    224e:	e8 d9 1c 00 00       	call   3f2c <chdir>
    2253:	85 c0                	test   %eax,%eax
    2255:	74 19                	je     2270 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    2257:	c7 44 24 04 83 4f 00 	movl   $0x4f83,0x4(%esp)
    225e:	00 
    225f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2266:	e8 cd 1d 00 00       	call   4038 <printf>
    exit();
    226b:	e8 4c 1c 00 00       	call   3ebc <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2270:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2277:	00 
    2278:	c7 04 24 cc 4e 00 00 	movl   $0x4ecc,(%esp)
    227f:	e8 78 1c 00 00       	call   3efc <open>
    2284:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    2287:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    228b:	79 19                	jns    22a6 <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    228d:	c7 44 24 04 96 4f 00 	movl   $0x4f96,0x4(%esp)
    2294:	00 
    2295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    229c:	e8 97 1d 00 00       	call   4038 <printf>
    exit();
    22a1:	e8 16 1c 00 00       	call   3ebc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22a6:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    22ad:	00 
    22ae:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    22b5:	00 
    22b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22b9:	89 04 24             	mov    %eax,(%esp)
    22bc:	e8 13 1c 00 00       	call   3ed4 <read>
    22c1:	83 f8 02             	cmp    $0x2,%eax
    22c4:	74 19                	je     22df <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    22c6:	c7 44 24 04 ae 4f 00 	movl   $0x4fae,0x4(%esp)
    22cd:	00 
    22ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22d5:	e8 5e 1d 00 00       	call   4038 <printf>
    exit();
    22da:	e8 dd 1b 00 00       	call   3ebc <exit>
  }
  close(fd);
    22df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22e2:	89 04 24             	mov    %eax,(%esp)
    22e5:	e8 fa 1b 00 00       	call   3ee4 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22f1:	00 
    22f2:	c7 04 24 68 4e 00 00 	movl   $0x4e68,(%esp)
    22f9:	e8 fe 1b 00 00       	call   3efc <open>
    22fe:	85 c0                	test   %eax,%eax
    2300:	78 19                	js     231b <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2302:	c7 44 24 04 cc 4f 00 	movl   $0x4fcc,0x4(%esp)
    2309:	00 
    230a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2311:	e8 22 1d 00 00       	call   4038 <printf>
    exit();
    2316:	e8 a1 1b 00 00       	call   3ebc <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    231b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2322:	00 
    2323:	c7 04 24 f1 4f 00 00 	movl   $0x4ff1,(%esp)
    232a:	e8 cd 1b 00 00       	call   3efc <open>
    232f:	85 c0                	test   %eax,%eax
    2331:	78 19                	js     234c <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    2333:	c7 44 24 04 fa 4f 00 	movl   $0x4ffa,0x4(%esp)
    233a:	00 
    233b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2342:	e8 f1 1c 00 00       	call   4038 <printf>
    exit();
    2347:	e8 70 1b 00 00       	call   3ebc <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    234c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2353:	00 
    2354:	c7 04 24 16 50 00 00 	movl   $0x5016,(%esp)
    235b:	e8 9c 1b 00 00       	call   3efc <open>
    2360:	85 c0                	test   %eax,%eax
    2362:	78 19                	js     237d <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    2364:	c7 44 24 04 1f 50 00 	movl   $0x501f,0x4(%esp)
    236b:	00 
    236c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2373:	e8 c0 1c 00 00       	call   4038 <printf>
    exit();
    2378:	e8 3f 1b 00 00       	call   3ebc <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    237d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2384:	00 
    2385:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    238c:	e8 6b 1b 00 00       	call   3efc <open>
    2391:	85 c0                	test   %eax,%eax
    2393:	78 19                	js     23ae <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    2395:	c7 44 24 04 3b 50 00 	movl   $0x503b,0x4(%esp)
    239c:	00 
    239d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a4:	e8 8f 1c 00 00       	call   4038 <printf>
    exit();
    23a9:	e8 0e 1b 00 00       	call   3ebc <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23ae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    23b5:	00 
    23b6:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    23bd:	e8 3a 1b 00 00       	call   3efc <open>
    23c2:	85 c0                	test   %eax,%eax
    23c4:	78 19                	js     23df <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    23c6:	c7 44 24 04 51 50 00 	movl   $0x5051,0x4(%esp)
    23cd:	00 
    23ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23d5:	e8 5e 1c 00 00       	call   4038 <printf>
    exit();
    23da:	e8 dd 1a 00 00       	call   3ebc <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    23e6:	00 
    23e7:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    23ee:	e8 09 1b 00 00       	call   3efc <open>
    23f3:	85 c0                	test   %eax,%eax
    23f5:	78 19                	js     2410 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    23f7:	c7 44 24 04 6a 50 00 	movl   $0x506a,0x4(%esp)
    23fe:	00 
    23ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2406:	e8 2d 1c 00 00       	call   4038 <printf>
    exit();
    240b:	e8 ac 1a 00 00       	call   3ebc <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2410:	c7 44 24 04 85 50 00 	movl   $0x5085,0x4(%esp)
    2417:	00 
    2418:	c7 04 24 f1 4f 00 00 	movl   $0x4ff1,(%esp)
    241f:	e8 f8 1a 00 00       	call   3f1c <link>
    2424:	85 c0                	test   %eax,%eax
    2426:	75 19                	jne    2441 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2428:	c7 44 24 04 90 50 00 	movl   $0x5090,0x4(%esp)
    242f:	00 
    2430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2437:	e8 fc 1b 00 00       	call   4038 <printf>
    exit();
    243c:	e8 7b 1a 00 00       	call   3ebc <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2441:	c7 44 24 04 85 50 00 	movl   $0x5085,0x4(%esp)
    2448:	00 
    2449:	c7 04 24 16 50 00 00 	movl   $0x5016,(%esp)
    2450:	e8 c7 1a 00 00       	call   3f1c <link>
    2455:	85 c0                	test   %eax,%eax
    2457:	75 19                	jne    2472 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2459:	c7 44 24 04 b4 50 00 	movl   $0x50b4,0x4(%esp)
    2460:	00 
    2461:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2468:	e8 cb 1b 00 00       	call   4038 <printf>
    exit();
    246d:	e8 4a 1a 00 00       	call   3ebc <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2472:	c7 44 24 04 cc 4e 00 	movl   $0x4ecc,0x4(%esp)
    2479:	00 
    247a:	c7 04 24 04 4e 00 00 	movl   $0x4e04,(%esp)
    2481:	e8 96 1a 00 00       	call   3f1c <link>
    2486:	85 c0                	test   %eax,%eax
    2488:	75 19                	jne    24a3 <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    248a:	c7 44 24 04 d8 50 00 	movl   $0x50d8,0x4(%esp)
    2491:	00 
    2492:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2499:	e8 9a 1b 00 00       	call   4038 <printf>
    exit();
    249e:	e8 19 1a 00 00       	call   3ebc <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24a3:	c7 04 24 f1 4f 00 00 	movl   $0x4ff1,(%esp)
    24aa:	e8 75 1a 00 00       	call   3f24 <mkdir>
    24af:	85 c0                	test   %eax,%eax
    24b1:	75 19                	jne    24cc <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24b3:	c7 44 24 04 fa 50 00 	movl   $0x50fa,0x4(%esp)
    24ba:	00 
    24bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24c2:	e8 71 1b 00 00       	call   4038 <printf>
    exit();
    24c7:	e8 f0 19 00 00       	call   3ebc <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24cc:	c7 04 24 16 50 00 00 	movl   $0x5016,(%esp)
    24d3:	e8 4c 1a 00 00       	call   3f24 <mkdir>
    24d8:	85 c0                	test   %eax,%eax
    24da:	75 19                	jne    24f5 <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24dc:	c7 44 24 04 15 51 00 	movl   $0x5115,0x4(%esp)
    24e3:	00 
    24e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24eb:	e8 48 1b 00 00       	call   4038 <printf>
    exit();
    24f0:	e8 c7 19 00 00       	call   3ebc <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24f5:	c7 04 24 cc 4e 00 00 	movl   $0x4ecc,(%esp)
    24fc:	e8 23 1a 00 00       	call   3f24 <mkdir>
    2501:	85 c0                	test   %eax,%eax
    2503:	75 19                	jne    251e <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2505:	c7 44 24 04 30 51 00 	movl   $0x5130,0x4(%esp)
    250c:	00 
    250d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2514:	e8 1f 1b 00 00       	call   4038 <printf>
    exit();
    2519:	e8 9e 19 00 00       	call   3ebc <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    251e:	c7 04 24 16 50 00 00 	movl   $0x5016,(%esp)
    2525:	e8 e2 19 00 00       	call   3f0c <unlink>
    252a:	85 c0                	test   %eax,%eax
    252c:	75 19                	jne    2547 <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    252e:	c7 44 24 04 4d 51 00 	movl   $0x514d,0x4(%esp)
    2535:	00 
    2536:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    253d:	e8 f6 1a 00 00       	call   4038 <printf>
    exit();
    2542:	e8 75 19 00 00       	call   3ebc <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2547:	c7 04 24 f1 4f 00 00 	movl   $0x4ff1,(%esp)
    254e:	e8 b9 19 00 00       	call   3f0c <unlink>
    2553:	85 c0                	test   %eax,%eax
    2555:	75 19                	jne    2570 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2557:	c7 44 24 04 69 51 00 	movl   $0x5169,0x4(%esp)
    255e:	00 
    255f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2566:	e8 cd 1a 00 00       	call   4038 <printf>
    exit();
    256b:	e8 4c 19 00 00       	call   3ebc <exit>
  }
  if(chdir("dd/ff") == 0){
    2570:	c7 04 24 04 4e 00 00 	movl   $0x4e04,(%esp)
    2577:	e8 b0 19 00 00       	call   3f2c <chdir>
    257c:	85 c0                	test   %eax,%eax
    257e:	75 19                	jne    2599 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    2580:	c7 44 24 04 85 51 00 	movl   $0x5185,0x4(%esp)
    2587:	00 
    2588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    258f:	e8 a4 1a 00 00       	call   4038 <printf>
    exit();
    2594:	e8 23 19 00 00       	call   3ebc <exit>
  }
  if(chdir("dd/xx") == 0){
    2599:	c7 04 24 9d 51 00 00 	movl   $0x519d,(%esp)
    25a0:	e8 87 19 00 00       	call   3f2c <chdir>
    25a5:	85 c0                	test   %eax,%eax
    25a7:	75 19                	jne    25c2 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25a9:	c7 44 24 04 a3 51 00 	movl   $0x51a3,0x4(%esp)
    25b0:	00 
    25b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25b8:	e8 7b 1a 00 00       	call   4038 <printf>
    exit();
    25bd:	e8 fa 18 00 00       	call   3ebc <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25c2:	c7 04 24 cc 4e 00 00 	movl   $0x4ecc,(%esp)
    25c9:	e8 3e 19 00 00       	call   3f0c <unlink>
    25ce:	85 c0                	test   %eax,%eax
    25d0:	74 19                	je     25eb <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    25d2:	c7 44 24 04 f9 4e 00 	movl   $0x4ef9,0x4(%esp)
    25d9:	00 
    25da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e1:	e8 52 1a 00 00       	call   4038 <printf>
    exit();
    25e6:	e8 d1 18 00 00       	call   3ebc <exit>
  }
  if(unlink("dd/ff") != 0){
    25eb:	c7 04 24 04 4e 00 00 	movl   $0x4e04,(%esp)
    25f2:	e8 15 19 00 00       	call   3f0c <unlink>
    25f7:	85 c0                	test   %eax,%eax
    25f9:	74 19                	je     2614 <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    25fb:	c7 44 24 04 bb 51 00 	movl   $0x51bb,0x4(%esp)
    2602:	00 
    2603:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    260a:	e8 29 1a 00 00       	call   4038 <printf>
    exit();
    260f:	e8 a8 18 00 00       	call   3ebc <exit>
  }
  if(unlink("dd") == 0){
    2614:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    261b:	e8 ec 18 00 00       	call   3f0c <unlink>
    2620:	85 c0                	test   %eax,%eax
    2622:	75 19                	jne    263d <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    2624:	c7 44 24 04 d0 51 00 	movl   $0x51d0,0x4(%esp)
    262b:	00 
    262c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2633:	e8 00 1a 00 00       	call   4038 <printf>
    exit();
    2638:	e8 7f 18 00 00       	call   3ebc <exit>
  }
  if(unlink("dd/dd") < 0){
    263d:	c7 04 24 f0 51 00 00 	movl   $0x51f0,(%esp)
    2644:	e8 c3 18 00 00       	call   3f0c <unlink>
    2649:	85 c0                	test   %eax,%eax
    264b:	79 19                	jns    2666 <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    264d:	c7 44 24 04 f6 51 00 	movl   $0x51f6,0x4(%esp)
    2654:	00 
    2655:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    265c:	e8 d7 19 00 00       	call   4038 <printf>
    exit();
    2661:	e8 56 18 00 00       	call   3ebc <exit>
  }
  if(unlink("dd") < 0){
    2666:	c7 04 24 e9 4d 00 00 	movl   $0x4de9,(%esp)
    266d:	e8 9a 18 00 00       	call   3f0c <unlink>
    2672:	85 c0                	test   %eax,%eax
    2674:	79 19                	jns    268f <subdir+0x730>
    printf(1, "unlink dd failed\n");
    2676:	c7 44 24 04 0b 52 00 	movl   $0x520b,0x4(%esp)
    267d:	00 
    267e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2685:	e8 ae 19 00 00       	call   4038 <printf>
    exit();
    268a:	e8 2d 18 00 00       	call   3ebc <exit>
  }

  printf(1, "subdir ok\n");
    268f:	c7 44 24 04 1d 52 00 	movl   $0x521d,0x4(%esp)
    2696:	00 
    2697:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    269e:	e8 95 19 00 00       	call   4038 <printf>
}
    26a3:	c9                   	leave  
    26a4:	c3                   	ret    

000026a5 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26a5:	55                   	push   %ebp
    26a6:	89 e5                	mov    %esp,%ebp
    26a8:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26ab:	c7 44 24 04 28 52 00 	movl   $0x5228,0x4(%esp)
    26b2:	00 
    26b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26ba:	e8 79 19 00 00       	call   4038 <printf>

  unlink("bigwrite");
    26bf:	c7 04 24 37 52 00 00 	movl   $0x5237,(%esp)
    26c6:	e8 41 18 00 00       	call   3f0c <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    26cb:	c7 45 ec f3 01 00 00 	movl   $0x1f3,-0x14(%ebp)
    26d2:	e9 b3 00 00 00       	jmp    278a <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26d7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    26de:	00 
    26df:	c7 04 24 37 52 00 00 	movl   $0x5237,(%esp)
    26e6:	e8 11 18 00 00       	call   3efc <open>
    26eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    26ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    26f2:	79 19                	jns    270d <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    26f4:	c7 44 24 04 40 52 00 	movl   $0x5240,0x4(%esp)
    26fb:	00 
    26fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2703:	e8 30 19 00 00       	call   4038 <printf>
      exit();
    2708:	e8 af 17 00 00       	call   3ebc <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    270d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2714:	eb 50                	jmp    2766 <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    2716:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2719:	89 44 24 08          	mov    %eax,0x8(%esp)
    271d:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    2724:	00 
    2725:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2728:	89 04 24             	mov    %eax,(%esp)
    272b:	e8 ac 17 00 00       	call   3edc <write>
    2730:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(cc != sz){
    2733:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2736:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    2739:	74 27                	je     2762 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    273e:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2742:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2745:	89 44 24 08          	mov    %eax,0x8(%esp)
    2749:	c7 44 24 04 58 52 00 	movl   $0x5258,0x4(%esp)
    2750:	00 
    2751:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2758:	e8 db 18 00 00       	call   4038 <printf>
        exit();
    275d:	e8 5a 17 00 00       	call   3ebc <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    2762:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2766:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    276a:	7e aa                	jle    2716 <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    276c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    276f:	89 04 24             	mov    %eax,(%esp)
    2772:	e8 6d 17 00 00       	call   3ee4 <close>
    unlink("bigwrite");
    2777:	c7 04 24 37 52 00 00 	movl   $0x5237,(%esp)
    277e:	e8 89 17 00 00       	call   3f0c <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2783:	81 45 ec d7 01 00 00 	addl   $0x1d7,-0x14(%ebp)
    278a:	81 7d ec ff 17 00 00 	cmpl   $0x17ff,-0x14(%ebp)
    2791:	0f 8e 40 ff ff ff    	jle    26d7 <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2797:	c7 44 24 04 6a 52 00 	movl   $0x526a,0x4(%esp)
    279e:	00 
    279f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27a6:	e8 8d 18 00 00       	call   4038 <printf>
}
    27ab:	c9                   	leave  
    27ac:	c3                   	ret    

000027ad <bigfile>:

void
bigfile(void)
{
    27ad:	55                   	push   %ebp
    27ae:	89 e5                	mov    %esp,%ebp
    27b0:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27b3:	c7 44 24 04 77 52 00 	movl   $0x5277,0x4(%esp)
    27ba:	00 
    27bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c2:	e8 71 18 00 00       	call   4038 <printf>

  unlink("bigfile");
    27c7:	c7 04 24 85 52 00 00 	movl   $0x5285,(%esp)
    27ce:	e8 39 17 00 00       	call   3f0c <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    27d3:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    27da:	00 
    27db:	c7 04 24 85 52 00 00 	movl   $0x5285,(%esp)
    27e2:	e8 15 17 00 00       	call   3efc <open>
    27e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    27ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    27ee:	79 19                	jns    2809 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    27f0:	c7 44 24 04 8d 52 00 	movl   $0x528d,0x4(%esp)
    27f7:	00 
    27f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ff:	e8 34 18 00 00       	call   4038 <printf>
    exit();
    2804:	e8 b3 16 00 00       	call   3ebc <exit>
  }
  for(i = 0; i < 20; i++){
    2809:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    2810:	eb 5a                	jmp    286c <bigfile+0xbf>
    memset(buf, i, 600);
    2812:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2819:	00 
    281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    281d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2821:	c7 04 24 e0 83 00 00 	movl   $0x83e0,(%esp)
    2828:	e8 e9 14 00 00       	call   3d16 <memset>
    if(write(fd, buf, 600) != 600){
    282d:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2834:	00 
    2835:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    283c:	00 
    283d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2840:	89 04 24             	mov    %eax,(%esp)
    2843:	e8 94 16 00 00       	call   3edc <write>
    2848:	3d 58 02 00 00       	cmp    $0x258,%eax
    284d:	74 19                	je     2868 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    284f:	c7 44 24 04 a3 52 00 	movl   $0x52a3,0x4(%esp)
    2856:	00 
    2857:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    285e:	e8 d5 17 00 00       	call   4038 <printf>
      exit();
    2863:	e8 54 16 00 00       	call   3ebc <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2868:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    286c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
    2870:	7e a0                	jle    2812 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2872:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2875:	89 04 24             	mov    %eax,(%esp)
    2878:	e8 67 16 00 00       	call   3ee4 <close>

  fd = open("bigfile", 0);
    287d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2884:	00 
    2885:	c7 04 24 85 52 00 00 	movl   $0x5285,(%esp)
    288c:	e8 6b 16 00 00       	call   3efc <open>
    2891:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    2894:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2898:	79 19                	jns    28b3 <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    289a:	c7 44 24 04 b9 52 00 	movl   $0x52b9,0x4(%esp)
    28a1:	00 
    28a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28a9:	e8 8a 17 00 00       	call   4038 <printf>
    exit();
    28ae:	e8 09 16 00 00       	call   3ebc <exit>
  }
  total = 0;
    28b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    cc = read(fd, buf, 300);
    28c1:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    28c8:	00 
    28c9:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    28d0:	00 
    28d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    28d4:	89 04 24             	mov    %eax,(%esp)
    28d7:	e8 f8 15 00 00       	call   3ed4 <read>
    28dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 0){
    28df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    28e3:	79 19                	jns    28fe <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    28e5:	c7 44 24 04 ce 52 00 	movl   $0x52ce,0x4(%esp)
    28ec:	00 
    28ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28f4:	e8 3f 17 00 00       	call   4038 <printf>
      exit();
    28f9:	e8 be 15 00 00       	call   3ebc <exit>
    }
    if(cc == 0)
    28fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2902:	0f 84 80 00 00 00    	je     2988 <bigfile+0x1db>
      break;
    if(cc != 300){
    2908:	81 7d f4 2c 01 00 00 	cmpl   $0x12c,-0xc(%ebp)
    290f:	74 19                	je     292a <bigfile+0x17d>
      printf(1, "short read bigfile\n");
    2911:	c7 44 24 04 e3 52 00 	movl   $0x52e3,0x4(%esp)
    2918:	00 
    2919:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2920:	e8 13 17 00 00       	call   4038 <printf>
      exit();
    2925:	e8 92 15 00 00       	call   3ebc <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    292a:	0f b6 05 e0 83 00 00 	movzbl 0x83e0,%eax
    2931:	0f be d0             	movsbl %al,%edx
    2934:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2937:	89 c1                	mov    %eax,%ecx
    2939:	c1 e9 1f             	shr    $0x1f,%ecx
    293c:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    293f:	d1 f8                	sar    %eax
    2941:	39 c2                	cmp    %eax,%edx
    2943:	75 1b                	jne    2960 <bigfile+0x1b3>
    2945:	0f b6 05 0b 85 00 00 	movzbl 0x850b,%eax
    294c:	0f be d0             	movsbl %al,%edx
    294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2952:	89 c1                	mov    %eax,%ecx
    2954:	c1 e9 1f             	shr    $0x1f,%ecx
    2957:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    295a:	d1 f8                	sar    %eax
    295c:	39 c2                	cmp    %eax,%edx
    295e:	74 19                	je     2979 <bigfile+0x1cc>
      printf(1, "read bigfile wrong data\n");
    2960:	c7 44 24 04 f7 52 00 	movl   $0x52f7,0x4(%esp)
    2967:	00 
    2968:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    296f:	e8 c4 16 00 00       	call   4038 <printf>
      exit();
    2974:	e8 43 15 00 00       	call   3ebc <exit>
    }
    total += cc;
    2979:	8b 45 f4             	mov    -0xc(%ebp),%eax
    297c:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    297f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2983:	e9 39 ff ff ff       	jmp    28c1 <bigfile+0x114>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    2988:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    2989:	8b 45 e8             	mov    -0x18(%ebp),%eax
    298c:	89 04 24             	mov    %eax,(%esp)
    298f:	e8 50 15 00 00       	call   3ee4 <close>
  if(total != 20*600){
    2994:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    299b:	74 19                	je     29b6 <bigfile+0x209>
    printf(1, "read bigfile wrong total\n");
    299d:	c7 44 24 04 10 53 00 	movl   $0x5310,0x4(%esp)
    29a4:	00 
    29a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ac:	e8 87 16 00 00       	call   4038 <printf>
    exit();
    29b1:	e8 06 15 00 00       	call   3ebc <exit>
  }
  unlink("bigfile");
    29b6:	c7 04 24 85 52 00 00 	movl   $0x5285,(%esp)
    29bd:	e8 4a 15 00 00       	call   3f0c <unlink>

  printf(1, "bigfile test ok\n");
    29c2:	c7 44 24 04 2a 53 00 	movl   $0x532a,0x4(%esp)
    29c9:	00 
    29ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29d1:	e8 62 16 00 00       	call   4038 <printf>
}
    29d6:	c9                   	leave  
    29d7:	c3                   	ret    

000029d8 <fourteen>:

void
fourteen(void)
{
    29d8:	55                   	push   %ebp
    29d9:	89 e5                	mov    %esp,%ebp
    29db:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29de:	c7 44 24 04 3b 53 00 	movl   $0x533b,0x4(%esp)
    29e5:	00 
    29e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29ed:	e8 46 16 00 00       	call   4038 <printf>

  if(mkdir("12345678901234") != 0){
    29f2:	c7 04 24 4a 53 00 00 	movl   $0x534a,(%esp)
    29f9:	e8 26 15 00 00       	call   3f24 <mkdir>
    29fe:	85 c0                	test   %eax,%eax
    2a00:	74 19                	je     2a1b <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a02:	c7 44 24 04 59 53 00 	movl   $0x5359,0x4(%esp)
    2a09:	00 
    2a0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a11:	e8 22 16 00 00       	call   4038 <printf>
    exit();
    2a16:	e8 a1 14 00 00       	call   3ebc <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a1b:	c7 04 24 78 53 00 00 	movl   $0x5378,(%esp)
    2a22:	e8 fd 14 00 00       	call   3f24 <mkdir>
    2a27:	85 c0                	test   %eax,%eax
    2a29:	74 19                	je     2a44 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a2b:	c7 44 24 04 98 53 00 	movl   $0x5398,0x4(%esp)
    2a32:	00 
    2a33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a3a:	e8 f9 15 00 00       	call   4038 <printf>
    exit();
    2a3f:	e8 78 14 00 00       	call   3ebc <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a44:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a4b:	00 
    2a4c:	c7 04 24 c8 53 00 00 	movl   $0x53c8,(%esp)
    2a53:	e8 a4 14 00 00       	call   3efc <open>
    2a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a5f:	79 19                	jns    2a7a <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a61:	c7 44 24 04 f8 53 00 	movl   $0x53f8,0x4(%esp)
    2a68:	00 
    2a69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a70:	e8 c3 15 00 00       	call   4038 <printf>
    exit();
    2a75:	e8 42 14 00 00       	call   3ebc <exit>
  }
  close(fd);
    2a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a7d:	89 04 24             	mov    %eax,(%esp)
    2a80:	e8 5f 14 00 00       	call   3ee4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a8c:	00 
    2a8d:	c7 04 24 38 54 00 00 	movl   $0x5438,(%esp)
    2a94:	e8 63 14 00 00       	call   3efc <open>
    2a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa0:	79 19                	jns    2abb <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aa2:	c7 44 24 04 68 54 00 	movl   $0x5468,0x4(%esp)
    2aa9:	00 
    2aaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab1:	e8 82 15 00 00       	call   4038 <printf>
    exit();
    2ab6:	e8 01 14 00 00       	call   3ebc <exit>
  }
  close(fd);
    2abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2abe:	89 04 24             	mov    %eax,(%esp)
    2ac1:	e8 1e 14 00 00       	call   3ee4 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2ac6:	c7 04 24 a2 54 00 00 	movl   $0x54a2,(%esp)
    2acd:	e8 52 14 00 00       	call   3f24 <mkdir>
    2ad2:	85 c0                	test   %eax,%eax
    2ad4:	75 19                	jne    2aef <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2ad6:	c7 44 24 04 c0 54 00 	movl   $0x54c0,0x4(%esp)
    2add:	00 
    2ade:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ae5:	e8 4e 15 00 00       	call   4038 <printf>
    exit();
    2aea:	e8 cd 13 00 00       	call   3ebc <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2aef:	c7 04 24 f0 54 00 00 	movl   $0x54f0,(%esp)
    2af6:	e8 29 14 00 00       	call   3f24 <mkdir>
    2afb:	85 c0                	test   %eax,%eax
    2afd:	75 19                	jne    2b18 <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2aff:	c7 44 24 04 10 55 00 	movl   $0x5510,0x4(%esp)
    2b06:	00 
    2b07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0e:	e8 25 15 00 00       	call   4038 <printf>
    exit();
    2b13:	e8 a4 13 00 00       	call   3ebc <exit>
  }

  printf(1, "fourteen ok\n");
    2b18:	c7 44 24 04 41 55 00 	movl   $0x5541,0x4(%esp)
    2b1f:	00 
    2b20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b27:	e8 0c 15 00 00       	call   4038 <printf>
}
    2b2c:	c9                   	leave  
    2b2d:	c3                   	ret    

00002b2e <rmdot>:

void
rmdot(void)
{
    2b2e:	55                   	push   %ebp
    2b2f:	89 e5                	mov    %esp,%ebp
    2b31:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b34:	c7 44 24 04 4e 55 00 	movl   $0x554e,0x4(%esp)
    2b3b:	00 
    2b3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b43:	e8 f0 14 00 00       	call   4038 <printf>
  if(mkdir("dots") != 0){
    2b48:	c7 04 24 5a 55 00 00 	movl   $0x555a,(%esp)
    2b4f:	e8 d0 13 00 00       	call   3f24 <mkdir>
    2b54:	85 c0                	test   %eax,%eax
    2b56:	74 19                	je     2b71 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b58:	c7 44 24 04 5f 55 00 	movl   $0x555f,0x4(%esp)
    2b5f:	00 
    2b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b67:	e8 cc 14 00 00       	call   4038 <printf>
    exit();
    2b6c:	e8 4b 13 00 00       	call   3ebc <exit>
  }
  if(chdir("dots") != 0){
    2b71:	c7 04 24 5a 55 00 00 	movl   $0x555a,(%esp)
    2b78:	e8 af 13 00 00       	call   3f2c <chdir>
    2b7d:	85 c0                	test   %eax,%eax
    2b7f:	74 19                	je     2b9a <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2b81:	c7 44 24 04 72 55 00 	movl   $0x5572,0x4(%esp)
    2b88:	00 
    2b89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b90:	e8 a3 14 00 00       	call   4038 <printf>
    exit();
    2b95:	e8 22 13 00 00       	call   3ebc <exit>
  }
  if(unlink(".") == 0){
    2b9a:	c7 04 24 8b 4c 00 00 	movl   $0x4c8b,(%esp)
    2ba1:	e8 66 13 00 00       	call   3f0c <unlink>
    2ba6:	85 c0                	test   %eax,%eax
    2ba8:	75 19                	jne    2bc3 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2baa:	c7 44 24 04 85 55 00 	movl   $0x5585,0x4(%esp)
    2bb1:	00 
    2bb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bb9:	e8 7a 14 00 00       	call   4038 <printf>
    exit();
    2bbe:	e8 f9 12 00 00       	call   3ebc <exit>
  }
  if(unlink("..") == 0){
    2bc3:	c7 04 24 1e 48 00 00 	movl   $0x481e,(%esp)
    2bca:	e8 3d 13 00 00       	call   3f0c <unlink>
    2bcf:	85 c0                	test   %eax,%eax
    2bd1:	75 19                	jne    2bec <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2bd3:	c7 44 24 04 93 55 00 	movl   $0x5593,0x4(%esp)
    2bda:	00 
    2bdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2be2:	e8 51 14 00 00       	call   4038 <printf>
    exit();
    2be7:	e8 d0 12 00 00       	call   3ebc <exit>
  }
  if(chdir("/") != 0){
    2bec:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    2bf3:	e8 34 13 00 00       	call   3f2c <chdir>
    2bf8:	85 c0                	test   %eax,%eax
    2bfa:	74 19                	je     2c15 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2bfc:	c7 44 24 04 74 44 00 	movl   $0x4474,0x4(%esp)
    2c03:	00 
    2c04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c0b:	e8 28 14 00 00       	call   4038 <printf>
    exit();
    2c10:	e8 a7 12 00 00       	call   3ebc <exit>
  }
  if(unlink("dots/.") == 0){
    2c15:	c7 04 24 a2 55 00 00 	movl   $0x55a2,(%esp)
    2c1c:	e8 eb 12 00 00       	call   3f0c <unlink>
    2c21:	85 c0                	test   %eax,%eax
    2c23:	75 19                	jne    2c3e <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c25:	c7 44 24 04 a9 55 00 	movl   $0x55a9,0x4(%esp)
    2c2c:	00 
    2c2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c34:	e8 ff 13 00 00       	call   4038 <printf>
    exit();
    2c39:	e8 7e 12 00 00       	call   3ebc <exit>
  }
  if(unlink("dots/..") == 0){
    2c3e:	c7 04 24 c0 55 00 00 	movl   $0x55c0,(%esp)
    2c45:	e8 c2 12 00 00       	call   3f0c <unlink>
    2c4a:	85 c0                	test   %eax,%eax
    2c4c:	75 19                	jne    2c67 <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2c4e:	c7 44 24 04 c8 55 00 	movl   $0x55c8,0x4(%esp)
    2c55:	00 
    2c56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c5d:	e8 d6 13 00 00       	call   4038 <printf>
    exit();
    2c62:	e8 55 12 00 00       	call   3ebc <exit>
  }
  if(unlink("dots") != 0){
    2c67:	c7 04 24 5a 55 00 00 	movl   $0x555a,(%esp)
    2c6e:	e8 99 12 00 00       	call   3f0c <unlink>
    2c73:	85 c0                	test   %eax,%eax
    2c75:	74 19                	je     2c90 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2c77:	c7 44 24 04 e0 55 00 	movl   $0x55e0,0x4(%esp)
    2c7e:	00 
    2c7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c86:	e8 ad 13 00 00       	call   4038 <printf>
    exit();
    2c8b:	e8 2c 12 00 00       	call   3ebc <exit>
  }
  printf(1, "rmdot ok\n");
    2c90:	c7 44 24 04 f5 55 00 	movl   $0x55f5,0x4(%esp)
    2c97:	00 
    2c98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9f:	e8 94 13 00 00       	call   4038 <printf>
}
    2ca4:	c9                   	leave  
    2ca5:	c3                   	ret    

00002ca6 <dirfile>:

void
dirfile(void)
{
    2ca6:	55                   	push   %ebp
    2ca7:	89 e5                	mov    %esp,%ebp
    2ca9:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cac:	c7 44 24 04 ff 55 00 	movl   $0x55ff,0x4(%esp)
    2cb3:	00 
    2cb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cbb:	e8 78 13 00 00       	call   4038 <printf>

  fd = open("dirfile", O_CREATE);
    2cc0:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cc7:	00 
    2cc8:	c7 04 24 0c 56 00 00 	movl   $0x560c,(%esp)
    2ccf:	e8 28 12 00 00       	call   3efc <open>
    2cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cdb:	79 19                	jns    2cf6 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2cdd:	c7 44 24 04 14 56 00 	movl   $0x5614,0x4(%esp)
    2ce4:	00 
    2ce5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cec:	e8 47 13 00 00       	call   4038 <printf>
    exit();
    2cf1:	e8 c6 11 00 00       	call   3ebc <exit>
  }
  close(fd);
    2cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2cf9:	89 04 24             	mov    %eax,(%esp)
    2cfc:	e8 e3 11 00 00       	call   3ee4 <close>
  if(chdir("dirfile") == 0){
    2d01:	c7 04 24 0c 56 00 00 	movl   $0x560c,(%esp)
    2d08:	e8 1f 12 00 00       	call   3f2c <chdir>
    2d0d:	85 c0                	test   %eax,%eax
    2d0f:	75 19                	jne    2d2a <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d11:	c7 44 24 04 2b 56 00 	movl   $0x562b,0x4(%esp)
    2d18:	00 
    2d19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d20:	e8 13 13 00 00       	call   4038 <printf>
    exit();
    2d25:	e8 92 11 00 00       	call   3ebc <exit>
  }
  fd = open("dirfile/xx", 0);
    2d2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d31:	00 
    2d32:	c7 04 24 45 56 00 00 	movl   $0x5645,(%esp)
    2d39:	e8 be 11 00 00       	call   3efc <open>
    2d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d45:	78 19                	js     2d60 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d47:	c7 44 24 04 50 56 00 	movl   $0x5650,0x4(%esp)
    2d4e:	00 
    2d4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d56:	e8 dd 12 00 00       	call   4038 <printf>
    exit();
    2d5b:	e8 5c 11 00 00       	call   3ebc <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d60:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d67:	00 
    2d68:	c7 04 24 45 56 00 00 	movl   $0x5645,(%esp)
    2d6f:	e8 88 11 00 00       	call   3efc <open>
    2d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d7b:	78 19                	js     2d96 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2d7d:	c7 44 24 04 50 56 00 	movl   $0x5650,0x4(%esp)
    2d84:	00 
    2d85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d8c:	e8 a7 12 00 00       	call   4038 <printf>
    exit();
    2d91:	e8 26 11 00 00       	call   3ebc <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d96:	c7 04 24 45 56 00 00 	movl   $0x5645,(%esp)
    2d9d:	e8 82 11 00 00       	call   3f24 <mkdir>
    2da2:	85 c0                	test   %eax,%eax
    2da4:	75 19                	jne    2dbf <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2da6:	c7 44 24 04 6e 56 00 	movl   $0x566e,0x4(%esp)
    2dad:	00 
    2dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2db5:	e8 7e 12 00 00       	call   4038 <printf>
    exit();
    2dba:	e8 fd 10 00 00       	call   3ebc <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dbf:	c7 04 24 45 56 00 00 	movl   $0x5645,(%esp)
    2dc6:	e8 41 11 00 00       	call   3f0c <unlink>
    2dcb:	85 c0                	test   %eax,%eax
    2dcd:	75 19                	jne    2de8 <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2dcf:	c7 44 24 04 8b 56 00 	movl   $0x568b,0x4(%esp)
    2dd6:	00 
    2dd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dde:	e8 55 12 00 00       	call   4038 <printf>
    exit();
    2de3:	e8 d4 10 00 00       	call   3ebc <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2de8:	c7 44 24 04 45 56 00 	movl   $0x5645,0x4(%esp)
    2def:	00 
    2df0:	c7 04 24 a9 56 00 00 	movl   $0x56a9,(%esp)
    2df7:	e8 20 11 00 00       	call   3f1c <link>
    2dfc:	85 c0                	test   %eax,%eax
    2dfe:	75 19                	jne    2e19 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e00:	c7 44 24 04 b0 56 00 	movl   $0x56b0,0x4(%esp)
    2e07:	00 
    2e08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e0f:	e8 24 12 00 00       	call   4038 <printf>
    exit();
    2e14:	e8 a3 10 00 00       	call   3ebc <exit>
  }
  if(unlink("dirfile") != 0){
    2e19:	c7 04 24 0c 56 00 00 	movl   $0x560c,(%esp)
    2e20:	e8 e7 10 00 00       	call   3f0c <unlink>
    2e25:	85 c0                	test   %eax,%eax
    2e27:	74 19                	je     2e42 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e29:	c7 44 24 04 cf 56 00 	movl   $0x56cf,0x4(%esp)
    2e30:	00 
    2e31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e38:	e8 fb 11 00 00       	call   4038 <printf>
    exit();
    2e3d:	e8 7a 10 00 00       	call   3ebc <exit>
  }

  fd = open(".", O_RDWR);
    2e42:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e49:	00 
    2e4a:	c7 04 24 8b 4c 00 00 	movl   $0x4c8b,(%esp)
    2e51:	e8 a6 10 00 00       	call   3efc <open>
    2e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e5d:	78 19                	js     2e78 <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e5f:	c7 44 24 04 e8 56 00 	movl   $0x56e8,0x4(%esp)
    2e66:	00 
    2e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e6e:	e8 c5 11 00 00       	call   4038 <printf>
    exit();
    2e73:	e8 44 10 00 00       	call   3ebc <exit>
  }
  fd = open(".", 0);
    2e78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e7f:	00 
    2e80:	c7 04 24 8b 4c 00 00 	movl   $0x4c8b,(%esp)
    2e87:	e8 70 10 00 00       	call   3efc <open>
    2e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e8f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e96:	00 
    2e97:	c7 44 24 04 d7 48 00 	movl   $0x48d7,0x4(%esp)
    2e9e:	00 
    2e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ea2:	89 04 24             	mov    %eax,(%esp)
    2ea5:	e8 32 10 00 00       	call   3edc <write>
    2eaa:	85 c0                	test   %eax,%eax
    2eac:	7e 19                	jle    2ec7 <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2eae:	c7 44 24 04 07 57 00 	movl   $0x5707,0x4(%esp)
    2eb5:	00 
    2eb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ebd:	e8 76 11 00 00       	call   4038 <printf>
    exit();
    2ec2:	e8 f5 0f 00 00       	call   3ebc <exit>
  }
  close(fd);
    2ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2eca:	89 04 24             	mov    %eax,(%esp)
    2ecd:	e8 12 10 00 00       	call   3ee4 <close>

  printf(1, "dir vs file OK\n");
    2ed2:	c7 44 24 04 1b 57 00 	movl   $0x571b,0x4(%esp)
    2ed9:	00 
    2eda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ee1:	e8 52 11 00 00       	call   4038 <printf>
}
    2ee6:	c9                   	leave  
    2ee7:	c3                   	ret    

00002ee8 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2ee8:	55                   	push   %ebp
    2ee9:	89 e5                	mov    %esp,%ebp
    2eeb:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2eee:	c7 44 24 04 2b 57 00 	movl   $0x572b,0x4(%esp)
    2ef5:	00 
    2ef6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2efd:	e8 36 11 00 00       	call   4038 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2f09:	e9 d2 00 00 00       	jmp    2fe0 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f0e:	c7 04 24 3c 57 00 00 	movl   $0x573c,(%esp)
    2f15:	e8 0a 10 00 00       	call   3f24 <mkdir>
    2f1a:	85 c0                	test   %eax,%eax
    2f1c:	74 19                	je     2f37 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f1e:	c7 44 24 04 42 57 00 	movl   $0x5742,0x4(%esp)
    2f25:	00 
    2f26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f2d:	e8 06 11 00 00       	call   4038 <printf>
      exit();
    2f32:	e8 85 0f 00 00       	call   3ebc <exit>
    }
    if(chdir("irefd") != 0){
    2f37:	c7 04 24 3c 57 00 00 	movl   $0x573c,(%esp)
    2f3e:	e8 e9 0f 00 00       	call   3f2c <chdir>
    2f43:	85 c0                	test   %eax,%eax
    2f45:	74 19                	je     2f60 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f47:	c7 44 24 04 56 57 00 	movl   $0x5756,0x4(%esp)
    2f4e:	00 
    2f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f56:	e8 dd 10 00 00       	call   4038 <printf>
      exit();
    2f5b:	e8 5c 0f 00 00       	call   3ebc <exit>
    }

    mkdir("");
    2f60:	c7 04 24 6a 57 00 00 	movl   $0x576a,(%esp)
    2f67:	e8 b8 0f 00 00       	call   3f24 <mkdir>
    link("README", "");
    2f6c:	c7 44 24 04 6a 57 00 	movl   $0x576a,0x4(%esp)
    2f73:	00 
    2f74:	c7 04 24 a9 56 00 00 	movl   $0x56a9,(%esp)
    2f7b:	e8 9c 0f 00 00       	call   3f1c <link>
    fd = open("", O_CREATE);
    2f80:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f87:	00 
    2f88:	c7 04 24 6a 57 00 00 	movl   $0x576a,(%esp)
    2f8f:	e8 68 0f 00 00       	call   3efc <open>
    2f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fd >= 0)
    2f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2f9b:	78 0b                	js     2fa8 <iref+0xc0>
      close(fd);
    2f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2fa0:	89 04 24             	mov    %eax,(%esp)
    2fa3:	e8 3c 0f 00 00       	call   3ee4 <close>
    fd = open("xx", O_CREATE);
    2fa8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2faf:	00 
    2fb0:	c7 04 24 6b 57 00 00 	movl   $0x576b,(%esp)
    2fb7:	e8 40 0f 00 00       	call   3efc <open>
    2fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fd >= 0)
    2fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2fc3:	78 0b                	js     2fd0 <iref+0xe8>
      close(fd);
    2fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2fc8:	89 04 24             	mov    %eax,(%esp)
    2fcb:	e8 14 0f 00 00       	call   3ee4 <close>
    unlink("xx");
    2fd0:	c7 04 24 6b 57 00 00 	movl   $0x576b,(%esp)
    2fd7:	e8 30 0f 00 00       	call   3f0c <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fdc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2fe0:	83 7d f0 32          	cmpl   $0x32,-0x10(%ebp)
    2fe4:	0f 8e 24 ff ff ff    	jle    2f0e <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2fea:	c7 04 24 72 44 00 00 	movl   $0x4472,(%esp)
    2ff1:	e8 36 0f 00 00       	call   3f2c <chdir>
  printf(1, "empty file name OK\n");
    2ff6:	c7 44 24 04 6e 57 00 	movl   $0x576e,0x4(%esp)
    2ffd:	00 
    2ffe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3005:	e8 2e 10 00 00       	call   4038 <printf>
}
    300a:	c9                   	leave  
    300b:	c3                   	ret    

0000300c <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    300c:	55                   	push   %ebp
    300d:	89 e5                	mov    %esp,%ebp
    300f:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3012:	c7 44 24 04 82 57 00 	movl   $0x5782,0x4(%esp)
    3019:	00 
    301a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3021:	e8 12 10 00 00       	call   4038 <printf>

  for(n=0; n<1000; n++){
    3026:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    302d:	eb 1d                	jmp    304c <forktest+0x40>
    pid = fork();
    302f:	e8 80 0e 00 00       	call   3eb4 <fork>
    3034:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0)
    3037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    303b:	78 1a                	js     3057 <forktest+0x4b>
      break;
    if(pid == 0)
    303d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3041:	75 05                	jne    3048 <forktest+0x3c>
      exit();
    3043:	e8 74 0e 00 00       	call   3ebc <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3048:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    304c:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
    3053:	7e da                	jle    302f <forktest+0x23>
    3055:	eb 01                	jmp    3058 <forktest+0x4c>
    pid = fork();
    if(pid < 0)
      break;
    3057:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    3058:	81 7d f0 e8 03 00 00 	cmpl   $0x3e8,-0x10(%ebp)
    305f:	75 41                	jne    30a2 <forktest+0x96>
    printf(1, "fork claimed to work 1000 times!\n");
    3061:	c7 44 24 04 90 57 00 	movl   $0x5790,0x4(%esp)
    3068:	00 
    3069:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3070:	e8 c3 0f 00 00       	call   4038 <printf>
    exit();
    3075:	e8 42 0e 00 00       	call   3ebc <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    307a:	e8 45 0e 00 00       	call   3ec4 <wait>
    307f:	85 c0                	test   %eax,%eax
    3081:	79 19                	jns    309c <forktest+0x90>
      printf(1, "wait stopped early\n");
    3083:	c7 44 24 04 b2 57 00 	movl   $0x57b2,0x4(%esp)
    308a:	00 
    308b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3092:	e8 a1 0f 00 00       	call   4038 <printf>
      exit();
    3097:	e8 20 0e 00 00       	call   3ebc <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    309c:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
    30a0:	eb 01                	jmp    30a3 <forktest+0x97>
    30a2:	90                   	nop
    30a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    30a7:	7f d1                	jg     307a <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30a9:	e8 16 0e 00 00       	call   3ec4 <wait>
    30ae:	83 f8 ff             	cmp    $0xffffffff,%eax
    30b1:	74 19                	je     30cc <forktest+0xc0>
    printf(1, "wait got too many\n");
    30b3:	c7 44 24 04 c6 57 00 	movl   $0x57c6,0x4(%esp)
    30ba:	00 
    30bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30c2:	e8 71 0f 00 00       	call   4038 <printf>
    exit();
    30c7:	e8 f0 0d 00 00       	call   3ebc <exit>
  }
  
  printf(1, "fork test OK\n");
    30cc:	c7 44 24 04 d9 57 00 	movl   $0x57d9,0x4(%esp)
    30d3:	00 
    30d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30db:	e8 58 0f 00 00       	call   4038 <printf>
}
    30e0:	c9                   	leave  
    30e1:	c3                   	ret    

000030e2 <sbrktest>:

void
sbrktest(void)
{
    30e2:	55                   	push   %ebp
    30e3:	89 e5                	mov    %esp,%ebp
    30e5:	53                   	push   %ebx
    30e6:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30ec:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    30f1:	c7 44 24 04 e7 57 00 	movl   $0x57e7,0x4(%esp)
    30f8:	00 
    30f9:	89 04 24             	mov    %eax,(%esp)
    30fc:	e8 37 0f 00 00       	call   4038 <printf>
  oldbrk = sbrk(0);
    3101:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3108:	e8 37 0e 00 00       	call   3f44 <sbrk>
    310d:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3117:	e8 28 0e 00 00       	call   3f44 <sbrk>
    311c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    311f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3126:	eb 59                	jmp    3181 <sbrktest+0x9f>
    b = sbrk(1);
    3128:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    312f:	e8 10 0e 00 00       	call   3f44 <sbrk>
    3134:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(b != a){
    3137:	8b 45 dc             	mov    -0x24(%ebp),%eax
    313a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    313d:	74 2f                	je     316e <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    313f:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3144:	8b 55 dc             	mov    -0x24(%ebp),%edx
    3147:	89 54 24 10          	mov    %edx,0x10(%esp)
    314b:	8b 55 d8             	mov    -0x28(%ebp),%edx
    314e:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3152:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3155:	89 54 24 08          	mov    %edx,0x8(%esp)
    3159:	c7 44 24 04 f2 57 00 	movl   $0x57f2,0x4(%esp)
    3160:	00 
    3161:	89 04 24             	mov    %eax,(%esp)
    3164:	e8 cf 0e 00 00       	call   4038 <printf>
      exit();
    3169:	e8 4e 0d 00 00       	call   3ebc <exit>
    }
    *b = 1;
    316e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3171:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3174:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3177:	83 c0 01             	add    $0x1,%eax
    317a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    317d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3181:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
    3188:	7e 9e                	jle    3128 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    318a:	e8 25 0d 00 00       	call   3eb4 <fork>
    318f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(pid < 0){
    3192:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    3196:	79 1a                	jns    31b2 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    3198:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    319d:	c7 44 24 04 0d 58 00 	movl   $0x580d,0x4(%esp)
    31a4:	00 
    31a5:	89 04 24             	mov    %eax,(%esp)
    31a8:	e8 8b 0e 00 00       	call   4038 <printf>
    exit();
    31ad:	e8 0a 0d 00 00       	call   3ebc <exit>
  }
  c = sbrk(1);
    31b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31b9:	e8 86 0d 00 00       	call   3f44 <sbrk>
    31be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31c8:	e8 77 0d 00 00       	call   3f44 <sbrk>
    31cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    31d3:	83 c0 01             	add    $0x1,%eax
    31d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31d9:	74 1a                	je     31f5 <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    31db:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    31e0:	c7 44 24 04 24 58 00 	movl   $0x5824,0x4(%esp)
    31e7:	00 
    31e8:	89 04 24             	mov    %eax,(%esp)
    31eb:	e8 48 0e 00 00       	call   4038 <printf>
    exit();
    31f0:	e8 c7 0c 00 00       	call   3ebc <exit>
  }
  if(pid == 0)
    31f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    31f9:	75 05                	jne    3200 <sbrktest+0x11e>
    exit();
    31fb:	e8 bc 0c 00 00       	call   3ebc <exit>
  wait();
    3200:	e8 bf 0c 00 00       	call   3ec4 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    320c:	e8 33 0d 00 00       	call   3f44 <sbrk>
    3211:	89 45 d8             	mov    %eax,-0x28(%ebp)
  amt = (BIG) - (uint)a;
    3214:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3217:	ba 00 00 40 06       	mov    $0x6400000,%edx
    321c:	89 d1                	mov    %edx,%ecx
    321e:	29 c1                	sub    %eax,%ecx
    3220:	89 c8                	mov    %ecx,%eax
    3222:	89 45 f0             	mov    %eax,-0x10(%ebp)
  p = sbrk(amt);
    3225:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3228:	89 04 24             	mov    %eax,(%esp)
    322b:	e8 14 0d 00 00       	call   3f44 <sbrk>
    3230:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (p != a) { 
    3233:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3236:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3239:	74 1a                	je     3255 <sbrktest+0x173>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    323b:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3240:	c7 44 24 04 40 58 00 	movl   $0x5840,0x4(%esp)
    3247:	00 
    3248:	89 04 24             	mov    %eax,(%esp)
    324b:	e8 e8 0d 00 00       	call   4038 <printf>
    exit();
    3250:	e8 67 0c 00 00       	call   3ebc <exit>
  }
  lastaddr = (char*) (BIG-1);
    3255:	c7 45 e4 ff ff 3f 06 	movl   $0x63fffff,-0x1c(%ebp)
  *lastaddr = 99;
    325c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    325f:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3262:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3269:	e8 d6 0c 00 00       	call   3f44 <sbrk>
    326e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  c = sbrk(-4096);
    3271:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3278:	e8 c7 0c 00 00       	call   3f44 <sbrk>
    327d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3280:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3284:	75 1a                	jne    32a0 <sbrktest+0x1be>
    printf(stdout, "sbrk could not deallocate\n");
    3286:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    328b:	c7 44 24 04 7e 58 00 	movl   $0x587e,0x4(%esp)
    3292:	00 
    3293:	89 04 24             	mov    %eax,(%esp)
    3296:	e8 9d 0d 00 00       	call   4038 <printf>
    exit();
    329b:	e8 1c 0c 00 00       	call   3ebc <exit>
  }
  c = sbrk(0);
    32a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32a7:	e8 98 0c 00 00       	call   3f44 <sbrk>
    32ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32af:	8b 45 d8             	mov    -0x28(%ebp),%eax
    32b2:	2d 00 10 00 00       	sub    $0x1000,%eax
    32b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32ba:	74 28                	je     32e4 <sbrktest+0x202>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32bc:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    32c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
    32c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
    32c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
    32cb:	89 54 24 08          	mov    %edx,0x8(%esp)
    32cf:	c7 44 24 04 9c 58 00 	movl   $0x589c,0x4(%esp)
    32d6:	00 
    32d7:	89 04 24             	mov    %eax,(%esp)
    32da:	e8 59 0d 00 00       	call   4038 <printf>
    exit();
    32df:	e8 d8 0b 00 00       	call   3ebc <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32eb:	e8 54 0c 00 00       	call   3f44 <sbrk>
    32f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  c = sbrk(4096);
    32f3:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    32fa:	e8 45 0c 00 00       	call   3f44 <sbrk>
    32ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3302:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3305:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    3308:	75 19                	jne    3323 <sbrktest+0x241>
    330a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3311:	e8 2e 0c 00 00       	call   3f44 <sbrk>
    3316:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3319:	81 c2 00 10 00 00    	add    $0x1000,%edx
    331f:	39 d0                	cmp    %edx,%eax
    3321:	74 28                	je     334b <sbrktest+0x269>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3323:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3328:	8b 55 e0             	mov    -0x20(%ebp),%edx
    332b:	89 54 24 0c          	mov    %edx,0xc(%esp)
    332f:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3332:	89 54 24 08          	mov    %edx,0x8(%esp)
    3336:	c7 44 24 04 d4 58 00 	movl   $0x58d4,0x4(%esp)
    333d:	00 
    333e:	89 04 24             	mov    %eax,(%esp)
    3341:	e8 f2 0c 00 00       	call   4038 <printf>
    exit();
    3346:	e8 71 0b 00 00       	call   3ebc <exit>
  }
  if(*lastaddr == 99){
    334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    334e:	0f b6 00             	movzbl (%eax),%eax
    3351:	3c 63                	cmp    $0x63,%al
    3353:	75 1a                	jne    336f <sbrktest+0x28d>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3355:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    335a:	c7 44 24 04 fc 58 00 	movl   $0x58fc,0x4(%esp)
    3361:	00 
    3362:	89 04 24             	mov    %eax,(%esp)
    3365:	e8 ce 0c 00 00       	call   4038 <printf>
    exit();
    336a:	e8 4d 0b 00 00       	call   3ebc <exit>
  }

  a = sbrk(0);
    336f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3376:	e8 c9 0b 00 00       	call   3f44 <sbrk>
    337b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    337e:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    3381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3388:	e8 b7 0b 00 00       	call   3f44 <sbrk>
    338d:	89 da                	mov    %ebx,%edx
    338f:	29 c2                	sub    %eax,%edx
    3391:	89 d0                	mov    %edx,%eax
    3393:	89 04 24             	mov    %eax,(%esp)
    3396:	e8 a9 0b 00 00       	call   3f44 <sbrk>
    339b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    339e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33a1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    33a4:	74 28                	je     33ce <sbrktest+0x2ec>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33a6:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    33ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
    33b5:	89 54 24 08          	mov    %edx,0x8(%esp)
    33b9:	c7 44 24 04 2c 59 00 	movl   $0x592c,0x4(%esp)
    33c0:	00 
    33c1:	89 04 24             	mov    %eax,(%esp)
    33c4:	e8 6f 0c 00 00       	call   4038 <printf>
    exit();
    33c9:	e8 ee 0a 00 00       	call   3ebc <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33ce:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
    33d5:	eb 7b                	jmp    3452 <sbrktest+0x370>
    ppid = getpid();
    33d7:	e8 60 0b 00 00       	call   3f3c <getpid>
    33dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    33df:	e8 d0 0a 00 00       	call   3eb4 <fork>
    33e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(pid < 0){
    33e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    33eb:	79 1a                	jns    3407 <sbrktest+0x325>
      printf(stdout, "fork failed\n");
    33ed:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    33f2:	c7 44 24 04 a1 44 00 	movl   $0x44a1,0x4(%esp)
    33f9:	00 
    33fa:	89 04 24             	mov    %eax,(%esp)
    33fd:	e8 36 0c 00 00       	call   4038 <printf>
      exit();
    3402:	e8 b5 0a 00 00       	call   3ebc <exit>
    }
    if(pid == 0){
    3407:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    340b:	75 39                	jne    3446 <sbrktest+0x364>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    340d:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3410:	0f b6 00             	movzbl (%eax),%eax
    3413:	0f be d0             	movsbl %al,%edx
    3416:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    341b:	89 54 24 0c          	mov    %edx,0xc(%esp)
    341f:	8b 55 d8             	mov    -0x28(%ebp),%edx
    3422:	89 54 24 08          	mov    %edx,0x8(%esp)
    3426:	c7 44 24 04 4d 59 00 	movl   $0x594d,0x4(%esp)
    342d:	00 
    342e:	89 04 24             	mov    %eax,(%esp)
    3431:	e8 02 0c 00 00       	call   4038 <printf>
      kill(ppid);
    3436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3439:	89 04 24             	mov    %eax,(%esp)
    343c:	e8 ab 0a 00 00       	call   3eec <kill>
      exit();
    3441:	e8 76 0a 00 00       	call   3ebc <exit>
    }
    wait();
    3446:	e8 79 0a 00 00       	call   3ec4 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    344b:	81 45 d8 50 c3 00 00 	addl   $0xc350,-0x28(%ebp)
    3452:	81 7d d8 7f 84 1e 80 	cmpl   $0x801e847f,-0x28(%ebp)
    3459:	0f 86 78 ff ff ff    	jbe    33d7 <sbrktest+0x2f5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    345f:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3462:	89 04 24             	mov    %eax,(%esp)
    3465:	e8 62 0a 00 00       	call   3ecc <pipe>
    346a:	85 c0                	test   %eax,%eax
    346c:	74 19                	je     3487 <sbrktest+0x3a5>
    printf(1, "pipe() failed\n");
    346e:	c7 44 24 04 72 48 00 	movl   $0x4872,0x4(%esp)
    3475:	00 
    3476:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    347d:	e8 b6 0b 00 00       	call   4038 <printf>
    exit();
    3482:	e8 35 0a 00 00       	call   3ebc <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    348e:	e9 86 00 00 00       	jmp    3519 <sbrktest+0x437>
    if((pids[i] = fork()) == 0){
    3493:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3496:	e8 19 0a 00 00       	call   3eb4 <fork>
    349b:	89 44 9d a0          	mov    %eax,-0x60(%ebp,%ebx,4)
    349f:	8b 44 9d a0          	mov    -0x60(%ebp,%ebx,4),%eax
    34a3:	85 c0                	test   %eax,%eax
    34a5:	75 48                	jne    34ef <sbrktest+0x40d>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34ae:	e8 91 0a 00 00       	call   3f44 <sbrk>
    34b3:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34b8:	89 d1                	mov    %edx,%ecx
    34ba:	29 c1                	sub    %eax,%ecx
    34bc:	89 c8                	mov    %ecx,%eax
    34be:	89 04 24             	mov    %eax,(%esp)
    34c1:	e8 7e 0a 00 00       	call   3f44 <sbrk>
      write(fds[1], "x", 1);
    34c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    34d0:	00 
    34d1:	c7 44 24 04 d7 48 00 	movl   $0x48d7,0x4(%esp)
    34d8:	00 
    34d9:	89 04 24             	mov    %eax,(%esp)
    34dc:	e8 fb 09 00 00       	call   3edc <write>
      // sit around until killed
      for(;;) sleep(1000);
    34e1:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    34e8:	e8 5f 0a 00 00       	call   3f4c <sleep>
    34ed:	eb f2                	jmp    34e1 <sbrktest+0x3ff>
    }
    if(pids[i] != -1)
    34ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34f2:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34f6:	83 f8 ff             	cmp    $0xffffffff,%eax
    34f9:	74 1a                	je     3515 <sbrktest+0x433>
      read(fds[0], &scratch, 1);
    34fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
    34fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3505:	00 
    3506:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3509:	89 54 24 04          	mov    %edx,0x4(%esp)
    350d:	89 04 24             	mov    %eax,(%esp)
    3510:	e8 bf 09 00 00       	call   3ed4 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3515:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3519:	8b 45 f4             	mov    -0xc(%ebp),%eax
    351c:	83 f8 09             	cmp    $0x9,%eax
    351f:	0f 86 6e ff ff ff    	jbe    3493 <sbrktest+0x3b1>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3525:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    352c:	e8 13 0a 00 00       	call   3f44 <sbrk>
    3531:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    353b:	eb 27                	jmp    3564 <sbrktest+0x482>
    if(pids[i] == -1)
    353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3540:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3544:	83 f8 ff             	cmp    $0xffffffff,%eax
    3547:	74 16                	je     355f <sbrktest+0x47d>
      continue;
    kill(pids[i]);
    3549:	8b 45 f4             	mov    -0xc(%ebp),%eax
    354c:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3550:	89 04 24             	mov    %eax,(%esp)
    3553:	e8 94 09 00 00       	call   3eec <kill>
    wait();
    3558:	e8 67 09 00 00       	call   3ec4 <wait>
    355d:	eb 01                	jmp    3560 <sbrktest+0x47e>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    355f:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3564:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3567:	83 f8 09             	cmp    $0x9,%eax
    356a:	76 d1                	jbe    353d <sbrktest+0x45b>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    356c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3570:	75 1a                	jne    358c <sbrktest+0x4aa>
    printf(stdout, "failed sbrk leaked memory\n");
    3572:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3577:	c7 44 24 04 66 59 00 	movl   $0x5966,0x4(%esp)
    357e:	00 
    357f:	89 04 24             	mov    %eax,(%esp)
    3582:	e8 b1 0a 00 00       	call   4038 <printf>
    exit();
    3587:	e8 30 09 00 00       	call   3ebc <exit>
  }

  if(sbrk(0) > oldbrk)
    358c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3593:	e8 ac 09 00 00       	call   3f44 <sbrk>
    3598:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    359b:	76 1d                	jbe    35ba <sbrktest+0x4d8>
    sbrk(-(sbrk(0) - oldbrk));
    359d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
    35a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35a7:	e8 98 09 00 00       	call   3f44 <sbrk>
    35ac:	89 da                	mov    %ebx,%edx
    35ae:	29 c2                	sub    %eax,%edx
    35b0:	89 d0                	mov    %edx,%eax
    35b2:	89 04 24             	mov    %eax,(%esp)
    35b5:	e8 8a 09 00 00       	call   3f44 <sbrk>

  printf(stdout, "sbrk test OK\n");
    35ba:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    35bf:	c7 44 24 04 81 59 00 	movl   $0x5981,0x4(%esp)
    35c6:	00 
    35c7:	89 04 24             	mov    %eax,(%esp)
    35ca:	e8 69 0a 00 00       	call   4038 <printf>
}
    35cf:	81 c4 84 00 00 00    	add    $0x84,%esp
    35d5:	5b                   	pop    %ebx
    35d6:	5d                   	pop    %ebp
    35d7:	c3                   	ret    

000035d8 <validateint>:

void
validateint(int *p)
{
    35d8:	55                   	push   %ebp
    35d9:	89 e5                	mov    %esp,%ebp
    35db:	53                   	push   %ebx
    35dc:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35df:	b8 0d 00 00 00       	mov    $0xd,%eax
    35e4:	8b 55 08             	mov    0x8(%ebp),%edx
    35e7:	89 d1                	mov    %edx,%ecx
    35e9:	89 e3                	mov    %esp,%ebx
    35eb:	89 cc                	mov    %ecx,%esp
    35ed:	cd 40                	int    $0x40
    35ef:	89 dc                	mov    %ebx,%esp
    35f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    35f4:	83 c4 10             	add    $0x10,%esp
    35f7:	5b                   	pop    %ebx
    35f8:	5d                   	pop    %ebp
    35f9:	c3                   	ret    

000035fa <validatetest>:

void
validatetest(void)
{
    35fa:	55                   	push   %ebp
    35fb:	89 e5                	mov    %esp,%ebp
    35fd:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3600:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3605:	c7 44 24 04 8f 59 00 	movl   $0x598f,0x4(%esp)
    360c:	00 
    360d:	89 04 24             	mov    %eax,(%esp)
    3610:	e8 23 0a 00 00       	call   4038 <printf>
  hi = 1100*1024;
    3615:	c7 45 ec 00 30 11 00 	movl   $0x113000,-0x14(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    361c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3623:	eb 7f                	jmp    36a4 <validatetest+0xaa>
    if((pid = fork()) == 0){
    3625:	e8 8a 08 00 00       	call   3eb4 <fork>
    362a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    362d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3631:	75 10                	jne    3643 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3633:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3636:	89 04 24             	mov    %eax,(%esp)
    3639:	e8 9a ff ff ff       	call   35d8 <validateint>
      exit();
    363e:	e8 79 08 00 00       	call   3ebc <exit>
    }
    sleep(0);
    3643:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    364a:	e8 fd 08 00 00       	call   3f4c <sleep>
    sleep(0);
    364f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3656:	e8 f1 08 00 00       	call   3f4c <sleep>
    kill(pid);
    365b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    365e:	89 04 24             	mov    %eax,(%esp)
    3661:	e8 86 08 00 00       	call   3eec <kill>
    wait();
    3666:	e8 59 08 00 00       	call   3ec4 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    366e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3672:	c7 04 24 9e 59 00 00 	movl   $0x599e,(%esp)
    3679:	e8 9e 08 00 00       	call   3f1c <link>
    367e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3681:	74 1a                	je     369d <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    3683:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3688:	c7 44 24 04 a9 59 00 	movl   $0x59a9,0x4(%esp)
    368f:	00 
    3690:	89 04 24             	mov    %eax,(%esp)
    3693:	e8 a0 09 00 00       	call   4038 <printf>
      exit();
    3698:	e8 1f 08 00 00       	call   3ebc <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    369d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    36a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36aa:	0f 83 75 ff ff ff    	jae    3625 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36b0:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    36b5:	c7 44 24 04 c2 59 00 	movl   $0x59c2,0x4(%esp)
    36bc:	00 
    36bd:	89 04 24             	mov    %eax,(%esp)
    36c0:	e8 73 09 00 00       	call   4038 <printf>
}
    36c5:	c9                   	leave  
    36c6:	c3                   	ret    

000036c7 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36c7:	55                   	push   %ebp
    36c8:	89 e5                	mov    %esp,%ebp
    36ca:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    36cd:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    36d2:	c7 44 24 04 cf 59 00 	movl   $0x59cf,0x4(%esp)
    36d9:	00 
    36da:	89 04 24             	mov    %eax,(%esp)
    36dd:	e8 56 09 00 00       	call   4038 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    36e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36e9:	eb 2c                	jmp    3717 <bsstest+0x50>
    if(uninit[i] != '\0'){
    36eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36ee:	0f b6 80 c0 5c 00 00 	movzbl 0x5cc0(%eax),%eax
    36f5:	84 c0                	test   %al,%al
    36f7:	74 1a                	je     3713 <bsstest+0x4c>
      printf(stdout, "bss test failed\n");
    36f9:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    36fe:	c7 44 24 04 d9 59 00 	movl   $0x59d9,0x4(%esp)
    3705:	00 
    3706:	89 04 24             	mov    %eax,(%esp)
    3709:	e8 2a 09 00 00       	call   4038 <printf>
      exit();
    370e:	e8 a9 07 00 00       	call   3ebc <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    3713:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3717:	8b 45 f4             	mov    -0xc(%ebp),%eax
    371a:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    371f:	76 ca                	jbe    36eb <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3721:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3726:	c7 44 24 04 ea 59 00 	movl   $0x59ea,0x4(%esp)
    372d:	00 
    372e:	89 04 24             	mov    %eax,(%esp)
    3731:	e8 02 09 00 00       	call   4038 <printf>
}
    3736:	c9                   	leave  
    3737:	c3                   	ret    

00003738 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3738:	55                   	push   %ebp
    3739:	89 e5                	mov    %esp,%ebp
    373b:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    373e:	c7 04 24 f7 59 00 00 	movl   $0x59f7,(%esp)
    3745:	e8 c2 07 00 00       	call   3f0c <unlink>
  pid = fork();
    374a:	e8 65 07 00 00       	call   3eb4 <fork>
    374f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid == 0){
    3752:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3756:	0f 85 90 00 00 00    	jne    37ec <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    375c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3763:	eb 12                	jmp    3777 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3765:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3768:	c7 04 85 20 5c 00 00 	movl   $0x5a04,0x5c20(,%eax,4)
    376f:	04 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3773:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3777:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    377b:	7e e8                	jle    3765 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    377d:	c7 05 9c 5c 00 00 00 	movl   $0x0,0x5c9c
    3784:	00 00 00 
    printf(stdout, "bigarg test\n");
    3787:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    378c:	c7 44 24 04 e1 5a 00 	movl   $0x5ae1,0x4(%esp)
    3793:	00 
    3794:	89 04 24             	mov    %eax,(%esp)
    3797:	e8 9c 08 00 00       	call   4038 <printf>
    exec("echo", args);
    379c:	c7 44 24 04 20 5c 00 	movl   $0x5c20,0x4(%esp)
    37a3:	00 
    37a4:	c7 04 24 00 44 00 00 	movl   $0x4400,(%esp)
    37ab:	e8 44 07 00 00       	call   3ef4 <exec>
    printf(stdout, "bigarg test ok\n");
    37b0:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    37b5:	c7 44 24 04 ee 5a 00 	movl   $0x5aee,0x4(%esp)
    37bc:	00 
    37bd:	89 04 24             	mov    %eax,(%esp)
    37c0:	e8 73 08 00 00       	call   4038 <printf>
    fd = open("bigarg-ok", O_CREATE);
    37c5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    37cc:	00 
    37cd:	c7 04 24 f7 59 00 00 	movl   $0x59f7,(%esp)
    37d4:	e8 23 07 00 00       	call   3efc <open>
    37d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
    37dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    37df:	89 04 24             	mov    %eax,(%esp)
    37e2:	e8 fd 06 00 00       	call   3ee4 <close>
    exit();
    37e7:	e8 d0 06 00 00       	call   3ebc <exit>
  } else if(pid < 0){
    37ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    37f0:	79 1a                	jns    380c <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    37f2:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    37f7:	c7 44 24 04 fe 5a 00 	movl   $0x5afe,0x4(%esp)
    37fe:	00 
    37ff:	89 04 24             	mov    %eax,(%esp)
    3802:	e8 31 08 00 00       	call   4038 <printf>
    exit();
    3807:	e8 b0 06 00 00       	call   3ebc <exit>
  }
  wait();
    380c:	e8 b3 06 00 00       	call   3ec4 <wait>
  fd = open("bigarg-ok", 0);
    3811:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3818:	00 
    3819:	c7 04 24 f7 59 00 00 	movl   $0x59f7,(%esp)
    3820:	e8 d7 06 00 00       	call   3efc <open>
    3825:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    3828:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    382c:	79 1a                	jns    3848 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    382e:	a1 e8 5b 00 00       	mov    0x5be8,%eax
    3833:	c7 44 24 04 17 5b 00 	movl   $0x5b17,0x4(%esp)
    383a:	00 
    383b:	89 04 24             	mov    %eax,(%esp)
    383e:	e8 f5 07 00 00       	call   4038 <printf>
    exit();
    3843:	e8 74 06 00 00       	call   3ebc <exit>
  }
  close(fd);
    3848:	8b 45 f0             	mov    -0x10(%ebp),%eax
    384b:	89 04 24             	mov    %eax,(%esp)
    384e:	e8 91 06 00 00       	call   3ee4 <close>
  unlink("bigarg-ok");
    3853:	c7 04 24 f7 59 00 00 	movl   $0x59f7,(%esp)
    385a:	e8 ad 06 00 00       	call   3f0c <unlink>
}
    385f:	c9                   	leave  
    3860:	c3                   	ret    

00003861 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3861:	55                   	push   %ebp
    3862:	89 e5                	mov    %esp,%ebp
    3864:	53                   	push   %ebx
    3865:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3868:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

  printf(1, "fsfull test\n");
    386f:	c7 44 24 04 2c 5b 00 	movl   $0x5b2c,0x4(%esp)
    3876:	00 
    3877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    387e:	e8 b5 07 00 00       	call   4038 <printf>

  for(nfiles = 0; ; nfiles++){
    3883:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    char name[64];
    name[0] = 'f';
    388a:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    388e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3891:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3896:	89 c8                	mov    %ecx,%eax
    3898:	f7 ea                	imul   %edx
    389a:	c1 fa 06             	sar    $0x6,%edx
    389d:	89 c8                	mov    %ecx,%eax
    389f:	c1 f8 1f             	sar    $0x1f,%eax
    38a2:	89 d1                	mov    %edx,%ecx
    38a4:	29 c1                	sub    %eax,%ecx
    38a6:	89 c8                	mov    %ecx,%eax
    38a8:	83 c0 30             	add    $0x30,%eax
    38ab:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38ae:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    38b1:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38b6:	89 d8                	mov    %ebx,%eax
    38b8:	f7 ea                	imul   %edx
    38ba:	c1 fa 06             	sar    $0x6,%edx
    38bd:	89 d8                	mov    %ebx,%eax
    38bf:	c1 f8 1f             	sar    $0x1f,%eax
    38c2:	89 d1                	mov    %edx,%ecx
    38c4:	29 c1                	sub    %eax,%ecx
    38c6:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38cc:	89 d9                	mov    %ebx,%ecx
    38ce:	29 c1                	sub    %eax,%ecx
    38d0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38d5:	89 c8                	mov    %ecx,%eax
    38d7:	f7 ea                	imul   %edx
    38d9:	c1 fa 05             	sar    $0x5,%edx
    38dc:	89 c8                	mov    %ecx,%eax
    38de:	c1 f8 1f             	sar    $0x1f,%eax
    38e1:	89 d1                	mov    %edx,%ecx
    38e3:	29 c1                	sub    %eax,%ecx
    38e5:	89 c8                	mov    %ecx,%eax
    38e7:	83 c0 30             	add    $0x30,%eax
    38ea:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    38ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    38f0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38f5:	89 d8                	mov    %ebx,%eax
    38f7:	f7 ea                	imul   %edx
    38f9:	c1 fa 05             	sar    $0x5,%edx
    38fc:	89 d8                	mov    %ebx,%eax
    38fe:	c1 f8 1f             	sar    $0x1f,%eax
    3901:	89 d1                	mov    %edx,%ecx
    3903:	29 c1                	sub    %eax,%ecx
    3905:	6b c1 64             	imul   $0x64,%ecx,%eax
    3908:	89 d9                	mov    %ebx,%ecx
    390a:	29 c1                	sub    %eax,%ecx
    390c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3911:	89 c8                	mov    %ecx,%eax
    3913:	f7 ea                	imul   %edx
    3915:	c1 fa 02             	sar    $0x2,%edx
    3918:	89 c8                	mov    %ecx,%eax
    391a:	c1 f8 1f             	sar    $0x1f,%eax
    391d:	89 d1                	mov    %edx,%ecx
    391f:	29 c1                	sub    %eax,%ecx
    3921:	89 c8                	mov    %ecx,%eax
    3923:	83 c0 30             	add    $0x30,%eax
    3926:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3929:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    392c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3931:	89 c8                	mov    %ecx,%eax
    3933:	f7 ea                	imul   %edx
    3935:	c1 fa 02             	sar    $0x2,%edx
    3938:	89 c8                	mov    %ecx,%eax
    393a:	c1 f8 1f             	sar    $0x1f,%eax
    393d:	29 c2                	sub    %eax,%edx
    393f:	89 d0                	mov    %edx,%eax
    3941:	c1 e0 02             	shl    $0x2,%eax
    3944:	01 d0                	add    %edx,%eax
    3946:	01 c0                	add    %eax,%eax
    3948:	89 ca                	mov    %ecx,%edx
    394a:	29 c2                	sub    %eax,%edx
    394c:	89 d0                	mov    %edx,%eax
    394e:	83 c0 30             	add    $0x30,%eax
    3951:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3954:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3958:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    395b:	89 44 24 08          	mov    %eax,0x8(%esp)
    395f:	c7 44 24 04 39 5b 00 	movl   $0x5b39,0x4(%esp)
    3966:	00 
    3967:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    396e:	e8 c5 06 00 00       	call   4038 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3973:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    397a:	00 
    397b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    397e:	89 04 24             	mov    %eax,(%esp)
    3981:	e8 76 05 00 00       	call   3efc <open>
    3986:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    3989:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    398d:	79 1d                	jns    39ac <fsfull+0x14b>
      printf(1, "open %s failed\n", name);
    398f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3992:	89 44 24 08          	mov    %eax,0x8(%esp)
    3996:	c7 44 24 04 45 5b 00 	movl   $0x5b45,0x4(%esp)
    399d:	00 
    399e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39a5:	e8 8e 06 00 00       	call   4038 <printf>
      break;
    39aa:	eb 72                	jmp    3a1e <fsfull+0x1bd>
    }
    int total = 0;
    39ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39b3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    39ba:	00 
    39bb:	c7 44 24 04 e0 83 00 	movl   $0x83e0,0x4(%esp)
    39c2:	00 
    39c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    39c6:	89 04 24             	mov    %eax,(%esp)
    39c9:	e8 0e 05 00 00       	call   3edc <write>
    39ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(cc < 512)
    39d1:	81 7d f4 ff 01 00 00 	cmpl   $0x1ff,-0xc(%ebp)
    39d8:	7e 0c                	jle    39e6 <fsfull+0x185>
        break;
      total += cc;
    39da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39dd:	01 45 f0             	add    %eax,-0x10(%ebp)
      fsblocks++;
    39e0:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    }
    39e4:	eb cd                	jmp    39b3 <fsfull+0x152>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    39e6:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    39e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    39ea:	89 44 24 08          	mov    %eax,0x8(%esp)
    39ee:	c7 44 24 04 55 5b 00 	movl   $0x5b55,0x4(%esp)
    39f5:	00 
    39f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39fd:	e8 36 06 00 00       	call   4038 <printf>
    close(fd);
    3a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3a05:	89 04 24             	mov    %eax,(%esp)
    3a08:	e8 d7 04 00 00       	call   3ee4 <close>
    if(total == 0)
    3a0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3a11:	75 02                	jne    3a15 <fsfull+0x1b4>
      break;
    3a13:	eb 09                	jmp    3a1e <fsfull+0x1bd>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a15:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a19:	e9 6c fe ff ff       	jmp    388a <fsfull+0x29>

  while(nfiles >= 0){
    3a1e:	e9 dd 00 00 00       	jmp    3b00 <fsfull+0x29f>
    char name[64];
    name[0] = 'f';
    3a23:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a27:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3a2a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a2f:	89 c8                	mov    %ecx,%eax
    3a31:	f7 ea                	imul   %edx
    3a33:	c1 fa 06             	sar    $0x6,%edx
    3a36:	89 c8                	mov    %ecx,%eax
    3a38:	c1 f8 1f             	sar    $0x1f,%eax
    3a3b:	89 d1                	mov    %edx,%ecx
    3a3d:	29 c1                	sub    %eax,%ecx
    3a3f:	89 c8                	mov    %ecx,%eax
    3a41:	83 c0 30             	add    $0x30,%eax
    3a44:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a47:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    3a4a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a4f:	89 d8                	mov    %ebx,%eax
    3a51:	f7 ea                	imul   %edx
    3a53:	c1 fa 06             	sar    $0x6,%edx
    3a56:	89 d8                	mov    %ebx,%eax
    3a58:	c1 f8 1f             	sar    $0x1f,%eax
    3a5b:	89 d1                	mov    %edx,%ecx
    3a5d:	29 c1                	sub    %eax,%ecx
    3a5f:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a65:	89 d9                	mov    %ebx,%ecx
    3a67:	29 c1                	sub    %eax,%ecx
    3a69:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a6e:	89 c8                	mov    %ecx,%eax
    3a70:	f7 ea                	imul   %edx
    3a72:	c1 fa 05             	sar    $0x5,%edx
    3a75:	89 c8                	mov    %ecx,%eax
    3a77:	c1 f8 1f             	sar    $0x1f,%eax
    3a7a:	89 d1                	mov    %edx,%ecx
    3a7c:	29 c1                	sub    %eax,%ecx
    3a7e:	89 c8                	mov    %ecx,%eax
    3a80:	83 c0 30             	add    $0x30,%eax
    3a83:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a86:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    3a89:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a8e:	89 d8                	mov    %ebx,%eax
    3a90:	f7 ea                	imul   %edx
    3a92:	c1 fa 05             	sar    $0x5,%edx
    3a95:	89 d8                	mov    %ebx,%eax
    3a97:	c1 f8 1f             	sar    $0x1f,%eax
    3a9a:	89 d1                	mov    %edx,%ecx
    3a9c:	29 c1                	sub    %eax,%ecx
    3a9e:	6b c1 64             	imul   $0x64,%ecx,%eax
    3aa1:	89 d9                	mov    %ebx,%ecx
    3aa3:	29 c1                	sub    %eax,%ecx
    3aa5:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aaa:	89 c8                	mov    %ecx,%eax
    3aac:	f7 ea                	imul   %edx
    3aae:	c1 fa 02             	sar    $0x2,%edx
    3ab1:	89 c8                	mov    %ecx,%eax
    3ab3:	c1 f8 1f             	sar    $0x1f,%eax
    3ab6:	89 d1                	mov    %edx,%ecx
    3ab8:	29 c1                	sub    %eax,%ecx
    3aba:	89 c8                	mov    %ecx,%eax
    3abc:	83 c0 30             	add    $0x30,%eax
    3abf:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ac2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    3ac5:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aca:	89 c8                	mov    %ecx,%eax
    3acc:	f7 ea                	imul   %edx
    3ace:	c1 fa 02             	sar    $0x2,%edx
    3ad1:	89 c8                	mov    %ecx,%eax
    3ad3:	c1 f8 1f             	sar    $0x1f,%eax
    3ad6:	29 c2                	sub    %eax,%edx
    3ad8:	89 d0                	mov    %edx,%eax
    3ada:	c1 e0 02             	shl    $0x2,%eax
    3add:	01 d0                	add    %edx,%eax
    3adf:	01 c0                	add    %eax,%eax
    3ae1:	89 ca                	mov    %ecx,%edx
    3ae3:	29 c2                	sub    %eax,%edx
    3ae5:	89 d0                	mov    %edx,%eax
    3ae7:	83 c0 30             	add    $0x30,%eax
    3aea:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3aed:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3af1:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3af4:	89 04 24             	mov    %eax,(%esp)
    3af7:	e8 10 04 00 00       	call   3f0c <unlink>
    nfiles--;
    3afc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3b00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3b04:	0f 89 19 ff ff ff    	jns    3a23 <fsfull+0x1c2>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b0a:	c7 44 24 04 65 5b 00 	movl   $0x5b65,0x4(%esp)
    3b11:	00 
    3b12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b19:	e8 1a 05 00 00       	call   4038 <printf>
}
    3b1e:	83 c4 74             	add    $0x74,%esp
    3b21:	5b                   	pop    %ebx
    3b22:	5d                   	pop    %ebp
    3b23:	c3                   	ret    

00003b24 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b24:	55                   	push   %ebp
    3b25:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b27:	a1 ec 5b 00 00       	mov    0x5bec,%eax
    3b2c:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b32:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b37:	a3 ec 5b 00 00       	mov    %eax,0x5bec
  return randstate;
    3b3c:	a1 ec 5b 00 00       	mov    0x5bec,%eax
}
    3b41:	5d                   	pop    %ebp
    3b42:	c3                   	ret    

00003b43 <main>:

int
main(int argc, char *argv[])
{
    3b43:	55                   	push   %ebp
    3b44:	89 e5                	mov    %esp,%ebp
    3b46:	83 e4 f0             	and    $0xfffffff0,%esp
    3b49:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b4c:	c7 44 24 04 7b 5b 00 	movl   $0x5b7b,0x4(%esp)
    3b53:	00 
    3b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b5b:	e8 d8 04 00 00       	call   4038 <printf>

  if(open("usertests.ran", 0) >= 0){
    3b60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b67:	00 
    3b68:	c7 04 24 8f 5b 00 00 	movl   $0x5b8f,(%esp)
    3b6f:	e8 88 03 00 00       	call   3efc <open>
    3b74:	85 c0                	test   %eax,%eax
    3b76:	78 19                	js     3b91 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b78:	c7 44 24 04 a0 5b 00 	movl   $0x5ba0,0x4(%esp)
    3b7f:	00 
    3b80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b87:	e8 ac 04 00 00       	call   4038 <printf>
    exit();
    3b8c:	e8 2b 03 00 00       	call   3ebc <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b91:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3b98:	00 
    3b99:	c7 04 24 8f 5b 00 00 	movl   $0x5b8f,(%esp)
    3ba0:	e8 57 03 00 00       	call   3efc <open>
    3ba5:	89 04 24             	mov    %eax,(%esp)
    3ba8:	e8 37 03 00 00       	call   3ee4 <close>

  createdelete();
    3bad:	e8 c6 d6 ff ff       	call   1278 <createdelete>
  linkunlink();
    3bb2:	e8 07 e1 ff ff       	call   1cbe <linkunlink>
  concreate();
    3bb7:	e8 53 dd ff ff       	call   190f <concreate>
  fourfiles();
    3bbc:	e8 50 d4 ff ff       	call   1011 <fourfiles>
  sharedfd();
    3bc1:	e8 52 d2 ff ff       	call   e18 <sharedfd>

  bigargtest();
    3bc6:	e8 6d fb ff ff       	call   3738 <bigargtest>
  bigwrite();
    3bcb:	e8 d5 ea ff ff       	call   26a5 <bigwrite>
  bigargtest();
    3bd0:	e8 63 fb ff ff       	call   3738 <bigargtest>
  bsstest();
    3bd5:	e8 ed fa ff ff       	call   36c7 <bsstest>
  sbrktest();
    3bda:	e8 03 f5 ff ff       	call   30e2 <sbrktest>
  validatetest();
    3bdf:	e8 16 fa ff ff       	call   35fa <validatetest>

  opentest();
    3be4:	e8 de c6 ff ff       	call   2c7 <opentest>
  writetest();
    3be9:	e8 84 c7 ff ff       	call   372 <writetest>
  writetest1();
    3bee:	e8 94 c9 ff ff       	call   587 <writetest1>
  createtest();
    3bf3:	e8 98 cb ff ff       	call   790 <createtest>

  openiputtest();
    3bf8:	e8 c9 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3bfd:	e8 d8 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3c02:	e8 f9 c3 ff ff       	call   0 <iputtest>

  mem();
    3c07:	e8 27 d1 ff ff       	call   d33 <mem>
  pipe1();
    3c0c:	e8 60 cd ff ff       	call   971 <pipe1>
  preempt();
    3c11:	e8 46 cf ff ff       	call   b5c <preempt>
  exitwait();
    3c16:	e8 9a d0 ff ff       	call   cb5 <exitwait>

  rmdot();
    3c1b:	e8 0e ef ff ff       	call   2b2e <rmdot>
  fourteen();
    3c20:	e8 b3 ed ff ff       	call   29d8 <fourteen>
  bigfile();
    3c25:	e8 83 eb ff ff       	call   27ad <bigfile>
  subdir();
    3c2a:	e8 30 e3 ff ff       	call   1f5f <subdir>
  linktest();
    3c2f:	e8 92 da ff ff       	call   16c6 <linktest>
  unlinkread();
    3c34:	e8 b8 d8 ff ff       	call   14f1 <unlinkread>
  dirfile();
    3c39:	e8 68 f0 ff ff       	call   2ca6 <dirfile>
  iref();
    3c3e:	e8 a5 f2 ff ff       	call   2ee8 <iref>
  forktest();
    3c43:	e8 c4 f3 ff ff       	call   300c <forktest>
  bigdir(); // slow
    3c48:	e8 9d e1 ff ff       	call   1dea <bigdir>
  exectest();
    3c4d:	e8 d0 cc ff ff       	call   922 <exectest>

  exit();
    3c52:	e8 65 02 00 00       	call   3ebc <exit>
    3c57:	90                   	nop

00003c58 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c58:	55                   	push   %ebp
    3c59:	89 e5                	mov    %esp,%ebp
    3c5b:	57                   	push   %edi
    3c5c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c60:	8b 55 10             	mov    0x10(%ebp),%edx
    3c63:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c66:	89 cb                	mov    %ecx,%ebx
    3c68:	89 df                	mov    %ebx,%edi
    3c6a:	89 d1                	mov    %edx,%ecx
    3c6c:	fc                   	cld    
    3c6d:	f3 aa                	rep stos %al,%es:(%edi)
    3c6f:	89 ca                	mov    %ecx,%edx
    3c71:	89 fb                	mov    %edi,%ebx
    3c73:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c76:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c79:	5b                   	pop    %ebx
    3c7a:	5f                   	pop    %edi
    3c7b:	5d                   	pop    %ebp
    3c7c:	c3                   	ret    

00003c7d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c7d:	55                   	push   %ebp
    3c7e:	89 e5                	mov    %esp,%ebp
    3c80:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c83:	8b 45 08             	mov    0x8(%ebp),%eax
    3c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c89:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c8c:	0f b6 10             	movzbl (%eax),%edx
    3c8f:	8b 45 08             	mov    0x8(%ebp),%eax
    3c92:	88 10                	mov    %dl,(%eax)
    3c94:	8b 45 08             	mov    0x8(%ebp),%eax
    3c97:	0f b6 00             	movzbl (%eax),%eax
    3c9a:	84 c0                	test   %al,%al
    3c9c:	0f 95 c0             	setne  %al
    3c9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3ca3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    3ca7:	84 c0                	test   %al,%al
    3ca9:	75 de                	jne    3c89 <strcpy+0xc>
    ;
  return os;
    3cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3cae:	c9                   	leave  
    3caf:	c3                   	ret    

00003cb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cb0:	55                   	push   %ebp
    3cb1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cb3:	eb 08                	jmp    3cbd <strcmp+0xd>
    p++, q++;
    3cb5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cb9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cbd:	8b 45 08             	mov    0x8(%ebp),%eax
    3cc0:	0f b6 00             	movzbl (%eax),%eax
    3cc3:	84 c0                	test   %al,%al
    3cc5:	74 10                	je     3cd7 <strcmp+0x27>
    3cc7:	8b 45 08             	mov    0x8(%ebp),%eax
    3cca:	0f b6 10             	movzbl (%eax),%edx
    3ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cd0:	0f b6 00             	movzbl (%eax),%eax
    3cd3:	38 c2                	cmp    %al,%dl
    3cd5:	74 de                	je     3cb5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3cd7:	8b 45 08             	mov    0x8(%ebp),%eax
    3cda:	0f b6 00             	movzbl (%eax),%eax
    3cdd:	0f b6 d0             	movzbl %al,%edx
    3ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ce3:	0f b6 00             	movzbl (%eax),%eax
    3ce6:	0f b6 c0             	movzbl %al,%eax
    3ce9:	89 d1                	mov    %edx,%ecx
    3ceb:	29 c1                	sub    %eax,%ecx
    3ced:	89 c8                	mov    %ecx,%eax
}
    3cef:	5d                   	pop    %ebp
    3cf0:	c3                   	ret    

00003cf1 <strlen>:

uint
strlen(char *s)
{
    3cf1:	55                   	push   %ebp
    3cf2:	89 e5                	mov    %esp,%ebp
    3cf4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3cfe:	eb 04                	jmp    3d04 <strlen+0x13>
    3d00:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3d07:	03 45 08             	add    0x8(%ebp),%eax
    3d0a:	0f b6 00             	movzbl (%eax),%eax
    3d0d:	84 c0                	test   %al,%al
    3d0f:	75 ef                	jne    3d00 <strlen+0xf>
    ;
  return n;
    3d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d14:	c9                   	leave  
    3d15:	c3                   	ret    

00003d16 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d16:	55                   	push   %ebp
    3d17:	89 e5                	mov    %esp,%ebp
    3d19:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d1c:	8b 45 10             	mov    0x10(%ebp),%eax
    3d1f:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d23:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d26:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d2a:	8b 45 08             	mov    0x8(%ebp),%eax
    3d2d:	89 04 24             	mov    %eax,(%esp)
    3d30:	e8 23 ff ff ff       	call   3c58 <stosb>
  return dst;
    3d35:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d38:	c9                   	leave  
    3d39:	c3                   	ret    

00003d3a <strchr>:

char*
strchr(const char *s, char c)
{
    3d3a:	55                   	push   %ebp
    3d3b:	89 e5                	mov    %esp,%ebp
    3d3d:	83 ec 04             	sub    $0x4,%esp
    3d40:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d43:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d46:	eb 14                	jmp    3d5c <strchr+0x22>
    if(*s == c)
    3d48:	8b 45 08             	mov    0x8(%ebp),%eax
    3d4b:	0f b6 00             	movzbl (%eax),%eax
    3d4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d51:	75 05                	jne    3d58 <strchr+0x1e>
      return (char*)s;
    3d53:	8b 45 08             	mov    0x8(%ebp),%eax
    3d56:	eb 13                	jmp    3d6b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d5c:	8b 45 08             	mov    0x8(%ebp),%eax
    3d5f:	0f b6 00             	movzbl (%eax),%eax
    3d62:	84 c0                	test   %al,%al
    3d64:	75 e2                	jne    3d48 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d6b:	c9                   	leave  
    3d6c:	c3                   	ret    

00003d6d <gets>:

char*
gets(char *buf, int max)
{
    3d6d:	55                   	push   %ebp
    3d6e:	89 e5                	mov    %esp,%ebp
    3d70:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3d7a:	eb 44                	jmp    3dc0 <gets+0x53>
    cc = read(0, &c, 1);
    3d7c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3d83:	00 
    3d84:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d87:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3d92:	e8 3d 01 00 00       	call   3ed4 <read>
    3d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
    3d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d9e:	7e 2d                	jle    3dcd <gets+0x60>
      break;
    buf[i++] = c;
    3da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3da3:	03 45 08             	add    0x8(%ebp),%eax
    3da6:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
    3daa:	88 10                	mov    %dl,(%eax)
    3dac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
    3db0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3db4:	3c 0a                	cmp    $0xa,%al
    3db6:	74 16                	je     3dce <gets+0x61>
    3db8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dbc:	3c 0d                	cmp    $0xd,%al
    3dbe:	74 0e                	je     3dce <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3dc3:	83 c0 01             	add    $0x1,%eax
    3dc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dc9:	7c b1                	jl     3d7c <gets+0xf>
    3dcb:	eb 01                	jmp    3dce <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3dcd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3dd1:	03 45 08             	add    0x8(%ebp),%eax
    3dd4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dda:	c9                   	leave  
    3ddb:	c3                   	ret    

00003ddc <stat>:

int
stat(char *n, struct stat *st)
{
    3ddc:	55                   	push   %ebp
    3ddd:	89 e5                	mov    %esp,%ebp
    3ddf:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3de2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3de9:	00 
    3dea:	8b 45 08             	mov    0x8(%ebp),%eax
    3ded:	89 04 24             	mov    %eax,(%esp)
    3df0:	e8 07 01 00 00       	call   3efc <open>
    3df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
    3df8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3dfc:	79 07                	jns    3e05 <stat+0x29>
    return -1;
    3dfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3e03:	eb 23                	jmp    3e28 <stat+0x4c>
  r = fstat(fd, st);
    3e05:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e08:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3e0f:	89 04 24             	mov    %eax,(%esp)
    3e12:	e8 fd 00 00 00       	call   3f14 <fstat>
    3e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
    3e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3e1d:	89 04 24             	mov    %eax,(%esp)
    3e20:	e8 bf 00 00 00       	call   3ee4 <close>
  return r;
    3e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    3e28:	c9                   	leave  
    3e29:	c3                   	ret    

00003e2a <atoi>:

int
atoi(const char *s)
{
    3e2a:	55                   	push   %ebp
    3e2b:	89 e5                	mov    %esp,%ebp
    3e2d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e37:	eb 24                	jmp    3e5d <atoi+0x33>
    n = n*10 + *s++ - '0';
    3e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e3c:	89 d0                	mov    %edx,%eax
    3e3e:	c1 e0 02             	shl    $0x2,%eax
    3e41:	01 d0                	add    %edx,%eax
    3e43:	01 c0                	add    %eax,%eax
    3e45:	89 c2                	mov    %eax,%edx
    3e47:	8b 45 08             	mov    0x8(%ebp),%eax
    3e4a:	0f b6 00             	movzbl (%eax),%eax
    3e4d:	0f be c0             	movsbl %al,%eax
    3e50:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3e53:	83 e8 30             	sub    $0x30,%eax
    3e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3e59:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e5d:	8b 45 08             	mov    0x8(%ebp),%eax
    3e60:	0f b6 00             	movzbl (%eax),%eax
    3e63:	3c 2f                	cmp    $0x2f,%al
    3e65:	7e 0a                	jle    3e71 <atoi+0x47>
    3e67:	8b 45 08             	mov    0x8(%ebp),%eax
    3e6a:	0f b6 00             	movzbl (%eax),%eax
    3e6d:	3c 39                	cmp    $0x39,%al
    3e6f:	7e c8                	jle    3e39 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e74:	c9                   	leave  
    3e75:	c3                   	ret    

00003e76 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e76:	55                   	push   %ebp
    3e77:	89 e5                	mov    %esp,%ebp
    3e79:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e7c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
    3e82:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
    3e88:	eb 13                	jmp    3e9d <memmove+0x27>
    *dst++ = *src++;
    3e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e8d:	0f b6 10             	movzbl (%eax),%edx
    3e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3e93:	88 10                	mov    %dl,(%eax)
    3e95:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    3e99:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3ea1:	0f 9f c0             	setg   %al
    3ea4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    3ea8:	84 c0                	test   %al,%al
    3eaa:	75 de                	jne    3e8a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3eac:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3eaf:	c9                   	leave  
    3eb0:	c3                   	ret    
    3eb1:	90                   	nop
    3eb2:	90                   	nop
    3eb3:	90                   	nop

00003eb4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3eb4:	b8 01 00 00 00       	mov    $0x1,%eax
    3eb9:	cd 40                	int    $0x40
    3ebb:	c3                   	ret    

00003ebc <exit>:
SYSCALL(exit)
    3ebc:	b8 02 00 00 00       	mov    $0x2,%eax
    3ec1:	cd 40                	int    $0x40
    3ec3:	c3                   	ret    

00003ec4 <wait>:
SYSCALL(wait)
    3ec4:	b8 03 00 00 00       	mov    $0x3,%eax
    3ec9:	cd 40                	int    $0x40
    3ecb:	c3                   	ret    

00003ecc <pipe>:
SYSCALL(pipe)
    3ecc:	b8 04 00 00 00       	mov    $0x4,%eax
    3ed1:	cd 40                	int    $0x40
    3ed3:	c3                   	ret    

00003ed4 <read>:
SYSCALL(read)
    3ed4:	b8 05 00 00 00       	mov    $0x5,%eax
    3ed9:	cd 40                	int    $0x40
    3edb:	c3                   	ret    

00003edc <write>:
SYSCALL(write)
    3edc:	b8 10 00 00 00       	mov    $0x10,%eax
    3ee1:	cd 40                	int    $0x40
    3ee3:	c3                   	ret    

00003ee4 <close>:
SYSCALL(close)
    3ee4:	b8 15 00 00 00       	mov    $0x15,%eax
    3ee9:	cd 40                	int    $0x40
    3eeb:	c3                   	ret    

00003eec <kill>:
SYSCALL(kill)
    3eec:	b8 06 00 00 00       	mov    $0x6,%eax
    3ef1:	cd 40                	int    $0x40
    3ef3:	c3                   	ret    

00003ef4 <exec>:
SYSCALL(exec)
    3ef4:	b8 07 00 00 00       	mov    $0x7,%eax
    3ef9:	cd 40                	int    $0x40
    3efb:	c3                   	ret    

00003efc <open>:
SYSCALL(open)
    3efc:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f01:	cd 40                	int    $0x40
    3f03:	c3                   	ret    

00003f04 <mknod>:
SYSCALL(mknod)
    3f04:	b8 11 00 00 00       	mov    $0x11,%eax
    3f09:	cd 40                	int    $0x40
    3f0b:	c3                   	ret    

00003f0c <unlink>:
SYSCALL(unlink)
    3f0c:	b8 12 00 00 00       	mov    $0x12,%eax
    3f11:	cd 40                	int    $0x40
    3f13:	c3                   	ret    

00003f14 <fstat>:
SYSCALL(fstat)
    3f14:	b8 08 00 00 00       	mov    $0x8,%eax
    3f19:	cd 40                	int    $0x40
    3f1b:	c3                   	ret    

00003f1c <link>:
SYSCALL(link)
    3f1c:	b8 13 00 00 00       	mov    $0x13,%eax
    3f21:	cd 40                	int    $0x40
    3f23:	c3                   	ret    

00003f24 <mkdir>:
SYSCALL(mkdir)
    3f24:	b8 14 00 00 00       	mov    $0x14,%eax
    3f29:	cd 40                	int    $0x40
    3f2b:	c3                   	ret    

00003f2c <chdir>:
SYSCALL(chdir)
    3f2c:	b8 09 00 00 00       	mov    $0x9,%eax
    3f31:	cd 40                	int    $0x40
    3f33:	c3                   	ret    

00003f34 <dup>:
SYSCALL(dup)
    3f34:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f39:	cd 40                	int    $0x40
    3f3b:	c3                   	ret    

00003f3c <getpid>:
SYSCALL(getpid)
    3f3c:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f41:	cd 40                	int    $0x40
    3f43:	c3                   	ret    

00003f44 <sbrk>:
SYSCALL(sbrk)
    3f44:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f49:	cd 40                	int    $0x40
    3f4b:	c3                   	ret    

00003f4c <sleep>:
SYSCALL(sleep)
    3f4c:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f51:	cd 40                	int    $0x40
    3f53:	c3                   	ret    

00003f54 <uptime>:
SYSCALL(uptime)
    3f54:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f59:	cd 40                	int    $0x40
    3f5b:	c3                   	ret    

00003f5c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f5c:	55                   	push   %ebp
    3f5d:	89 e5                	mov    %esp,%ebp
    3f5f:	83 ec 28             	sub    $0x28,%esp
    3f62:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f65:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f68:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3f6f:	00 
    3f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f73:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f77:	8b 45 08             	mov    0x8(%ebp),%eax
    3f7a:	89 04 24             	mov    %eax,(%esp)
    3f7d:	e8 5a ff ff ff       	call   3edc <write>
}
    3f82:	c9                   	leave  
    3f83:	c3                   	ret    

00003f84 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f84:	55                   	push   %ebp
    3f85:	89 e5                	mov    %esp,%ebp
    3f87:	53                   	push   %ebx
    3f88:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f92:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f96:	74 17                	je     3faf <printint+0x2b>
    3f98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3f9c:	79 11                	jns    3faf <printint+0x2b>
    neg = 1;
    3f9e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fa8:	f7 d8                	neg    %eax
    3faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3fad:	eb 06                	jmp    3fb5 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    3faf:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
    3fb5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fbc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    3fbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fc5:	ba 00 00 00 00       	mov    $0x0,%edx
    3fca:	f7 f3                	div    %ebx
    3fcc:	89 d0                	mov    %edx,%eax
    3fce:	0f b6 80 f0 5b 00 00 	movzbl 0x5bf0(%eax),%eax
    3fd5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
    3fd9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
    3fdd:	8b 45 10             	mov    0x10(%ebp),%eax
    3fe0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fe6:	ba 00 00 00 00       	mov    $0x0,%edx
    3feb:	f7 75 d4             	divl   -0x2c(%ebp)
    3fee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3ff1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ff5:	75 c5                	jne    3fbc <printint+0x38>
  if(neg)
    3ff7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ffb:	74 2a                	je     4027 <printint+0xa3>
    buf[i++] = '-';
    3ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4000:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
    4005:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
    4009:	eb 1d                	jmp    4028 <printint+0xa4>
    putc(fd, buf[i]);
    400b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    400e:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
    4013:	0f be c0             	movsbl %al,%eax
    4016:	89 44 24 04          	mov    %eax,0x4(%esp)
    401a:	8b 45 08             	mov    0x8(%ebp),%eax
    401d:	89 04 24             	mov    %eax,(%esp)
    4020:	e8 37 ff ff ff       	call   3f5c <putc>
    4025:	eb 01                	jmp    4028 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4027:	90                   	nop
    4028:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
    402c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4030:	79 d9                	jns    400b <printint+0x87>
    putc(fd, buf[i]);
}
    4032:	83 c4 44             	add    $0x44,%esp
    4035:	5b                   	pop    %ebx
    4036:	5d                   	pop    %ebp
    4037:	c3                   	ret    

00004038 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4038:	55                   	push   %ebp
    4039:	89 e5                	mov    %esp,%ebp
    403b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    403e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4045:	8d 45 0c             	lea    0xc(%ebp),%eax
    4048:	83 c0 04             	add    $0x4,%eax
    404b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
    404e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    4055:	e9 7e 01 00 00       	jmp    41d8 <printf+0x1a0>
    c = fmt[i] & 0xff;
    405a:	8b 55 0c             	mov    0xc(%ebp),%edx
    405d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4060:	8d 04 02             	lea    (%edx,%eax,1),%eax
    4063:	0f b6 00             	movzbl (%eax),%eax
    4066:	0f be c0             	movsbl %al,%eax
    4069:	25 ff 00 00 00       	and    $0xff,%eax
    406e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
    4071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4075:	75 2c                	jne    40a3 <printf+0x6b>
      if(c == '%'){
    4077:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    407b:	75 0c                	jne    4089 <printf+0x51>
        state = '%';
    407d:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
    4084:	e9 4b 01 00 00       	jmp    41d4 <printf+0x19c>
      } else {
        putc(fd, c);
    4089:	8b 45 e8             	mov    -0x18(%ebp),%eax
    408c:	0f be c0             	movsbl %al,%eax
    408f:	89 44 24 04          	mov    %eax,0x4(%esp)
    4093:	8b 45 08             	mov    0x8(%ebp),%eax
    4096:	89 04 24             	mov    %eax,(%esp)
    4099:	e8 be fe ff ff       	call   3f5c <putc>
    409e:	e9 31 01 00 00       	jmp    41d4 <printf+0x19c>
      }
    } else if(state == '%'){
    40a3:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
    40a7:	0f 85 27 01 00 00    	jne    41d4 <printf+0x19c>
      if(c == 'd'){
    40ad:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
    40b1:	75 2d                	jne    40e0 <printf+0xa8>
        printint(fd, *ap, 10, 1);
    40b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40b6:	8b 00                	mov    (%eax),%eax
    40b8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40bf:	00 
    40c0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    40c7:	00 
    40c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    40cc:	8b 45 08             	mov    0x8(%ebp),%eax
    40cf:	89 04 24             	mov    %eax,(%esp)
    40d2:	e8 ad fe ff ff       	call   3f84 <printint>
        ap++;
    40d7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    40db:	e9 ed 00 00 00       	jmp    41cd <printf+0x195>
      } else if(c == 'x' || c == 'p'){
    40e0:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
    40e4:	74 06                	je     40ec <printf+0xb4>
    40e6:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
    40ea:	75 2d                	jne    4119 <printf+0xe1>
        printint(fd, *ap, 16, 0);
    40ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40ef:	8b 00                	mov    (%eax),%eax
    40f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    40f8:	00 
    40f9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    4100:	00 
    4101:	89 44 24 04          	mov    %eax,0x4(%esp)
    4105:	8b 45 08             	mov    0x8(%ebp),%eax
    4108:	89 04 24             	mov    %eax,(%esp)
    410b:	e8 74 fe ff ff       	call   3f84 <printint>
        ap++;
    4110:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    4114:	e9 b4 00 00 00       	jmp    41cd <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    4119:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
    411d:	75 46                	jne    4165 <printf+0x12d>
        s = (char*)*ap;
    411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4122:	8b 00                	mov    (%eax),%eax
    4124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
    4127:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
    412b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    412f:	75 27                	jne    4158 <printf+0x120>
          s = "(null)";
    4131:	c7 45 e4 ca 5b 00 00 	movl   $0x5bca,-0x1c(%ebp)
        while(*s != 0){
    4138:	eb 1f                	jmp    4159 <printf+0x121>
          putc(fd, *s);
    413a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    413d:	0f b6 00             	movzbl (%eax),%eax
    4140:	0f be c0             	movsbl %al,%eax
    4143:	89 44 24 04          	mov    %eax,0x4(%esp)
    4147:	8b 45 08             	mov    0x8(%ebp),%eax
    414a:	89 04 24             	mov    %eax,(%esp)
    414d:	e8 0a fe ff ff       	call   3f5c <putc>
          s++;
    4152:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    4156:	eb 01                	jmp    4159 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4158:	90                   	nop
    4159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    415c:	0f b6 00             	movzbl (%eax),%eax
    415f:	84 c0                	test   %al,%al
    4161:	75 d7                	jne    413a <printf+0x102>
    4163:	eb 68                	jmp    41cd <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4165:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
    4169:	75 1d                	jne    4188 <printf+0x150>
        putc(fd, *ap);
    416b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    416e:	8b 00                	mov    (%eax),%eax
    4170:	0f be c0             	movsbl %al,%eax
    4173:	89 44 24 04          	mov    %eax,0x4(%esp)
    4177:	8b 45 08             	mov    0x8(%ebp),%eax
    417a:	89 04 24             	mov    %eax,(%esp)
    417d:	e8 da fd ff ff       	call   3f5c <putc>
        ap++;
    4182:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    4186:	eb 45                	jmp    41cd <printf+0x195>
      } else if(c == '%'){
    4188:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
    418c:	75 17                	jne    41a5 <printf+0x16d>
        putc(fd, c);
    418e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4191:	0f be c0             	movsbl %al,%eax
    4194:	89 44 24 04          	mov    %eax,0x4(%esp)
    4198:	8b 45 08             	mov    0x8(%ebp),%eax
    419b:	89 04 24             	mov    %eax,(%esp)
    419e:	e8 b9 fd ff ff       	call   3f5c <putc>
    41a3:	eb 28                	jmp    41cd <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41a5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41ac:	00 
    41ad:	8b 45 08             	mov    0x8(%ebp),%eax
    41b0:	89 04 24             	mov    %eax,(%esp)
    41b3:	e8 a4 fd ff ff       	call   3f5c <putc>
        putc(fd, c);
    41b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    41bb:	0f be c0             	movsbl %al,%eax
    41be:	89 44 24 04          	mov    %eax,0x4(%esp)
    41c2:	8b 45 08             	mov    0x8(%ebp),%eax
    41c5:	89 04 24             	mov    %eax,(%esp)
    41c8:	e8 8f fd ff ff       	call   3f5c <putc>
      }
      state = 0;
    41cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41d4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    41d8:	8b 55 0c             	mov    0xc(%ebp),%edx
    41db:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41de:	8d 04 02             	lea    (%edx,%eax,1),%eax
    41e1:	0f b6 00             	movzbl (%eax),%eax
    41e4:	84 c0                	test   %al,%al
    41e6:	0f 85 6e fe ff ff    	jne    405a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    41ec:	c9                   	leave  
    41ed:	c3                   	ret    
    41ee:	90                   	nop
    41ef:	90                   	nop

000041f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    41f0:	55                   	push   %ebp
    41f1:	89 e5                	mov    %esp,%ebp
    41f3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41f6:	8b 45 08             	mov    0x8(%ebp),%eax
    41f9:	83 e8 08             	sub    $0x8,%eax
    41fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41ff:	a1 a8 5c 00 00       	mov    0x5ca8,%eax
    4204:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4207:	eb 24                	jmp    422d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4209:	8b 45 fc             	mov    -0x4(%ebp),%eax
    420c:	8b 00                	mov    (%eax),%eax
    420e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4211:	77 12                	ja     4225 <free+0x35>
    4213:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4216:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4219:	77 24                	ja     423f <free+0x4f>
    421b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    421e:	8b 00                	mov    (%eax),%eax
    4220:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4223:	77 1a                	ja     423f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4225:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4228:	8b 00                	mov    (%eax),%eax
    422a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    422d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4230:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4233:	76 d4                	jbe    4209 <free+0x19>
    4235:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4238:	8b 00                	mov    (%eax),%eax
    423a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    423d:	76 ca                	jbe    4209 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    423f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4242:	8b 40 04             	mov    0x4(%eax),%eax
    4245:	c1 e0 03             	shl    $0x3,%eax
    4248:	89 c2                	mov    %eax,%edx
    424a:	03 55 f8             	add    -0x8(%ebp),%edx
    424d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4250:	8b 00                	mov    (%eax),%eax
    4252:	39 c2                	cmp    %eax,%edx
    4254:	75 24                	jne    427a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    4256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4259:	8b 50 04             	mov    0x4(%eax),%edx
    425c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    425f:	8b 00                	mov    (%eax),%eax
    4261:	8b 40 04             	mov    0x4(%eax),%eax
    4264:	01 c2                	add    %eax,%edx
    4266:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4269:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    426c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426f:	8b 00                	mov    (%eax),%eax
    4271:	8b 10                	mov    (%eax),%edx
    4273:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4276:	89 10                	mov    %edx,(%eax)
    4278:	eb 0a                	jmp    4284 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    427a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    427d:	8b 10                	mov    (%eax),%edx
    427f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4282:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4284:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4287:	8b 40 04             	mov    0x4(%eax),%eax
    428a:	c1 e0 03             	shl    $0x3,%eax
    428d:	03 45 fc             	add    -0x4(%ebp),%eax
    4290:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4293:	75 20                	jne    42b5 <free+0xc5>
    p->s.size += bp->s.size;
    4295:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4298:	8b 50 04             	mov    0x4(%eax),%edx
    429b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    429e:	8b 40 04             	mov    0x4(%eax),%eax
    42a1:	01 c2                	add    %eax,%edx
    42a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42ac:	8b 10                	mov    (%eax),%edx
    42ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b1:	89 10                	mov    %edx,(%eax)
    42b3:	eb 08                	jmp    42bd <free+0xcd>
  } else
    p->s.ptr = bp;
    42b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42bb:	89 10                	mov    %edx,(%eax)
  freep = p;
    42bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c0:	a3 a8 5c 00 00       	mov    %eax,0x5ca8
}
    42c5:	c9                   	leave  
    42c6:	c3                   	ret    

000042c7 <morecore>:

static Header*
morecore(uint nu)
{
    42c7:	55                   	push   %ebp
    42c8:	89 e5                	mov    %esp,%ebp
    42ca:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42cd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42d4:	77 07                	ja     42dd <morecore+0x16>
    nu = 4096;
    42d6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    42dd:	8b 45 08             	mov    0x8(%ebp),%eax
    42e0:	c1 e0 03             	shl    $0x3,%eax
    42e3:	89 04 24             	mov    %eax,(%esp)
    42e6:	e8 59 fc ff ff       	call   3f44 <sbrk>
    42eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
    42ee:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    42f2:	75 07                	jne    42fb <morecore+0x34>
    return 0;
    42f4:	b8 00 00 00 00       	mov    $0x0,%eax
    42f9:	eb 22                	jmp    431d <morecore+0x56>
  hp = (Header*)p;
    42fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
    4301:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4304:	8b 55 08             	mov    0x8(%ebp),%edx
    4307:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    430a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    430d:	83 c0 08             	add    $0x8,%eax
    4310:	89 04 24             	mov    %eax,(%esp)
    4313:	e8 d8 fe ff ff       	call   41f0 <free>
  return freep;
    4318:	a1 a8 5c 00 00       	mov    0x5ca8,%eax
}
    431d:	c9                   	leave  
    431e:	c3                   	ret    

0000431f <malloc>:

void*
malloc(uint nbytes)
{
    431f:	55                   	push   %ebp
    4320:	89 e5                	mov    %esp,%ebp
    4322:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4325:	8b 45 08             	mov    0x8(%ebp),%eax
    4328:	83 c0 07             	add    $0x7,%eax
    432b:	c1 e8 03             	shr    $0x3,%eax
    432e:	83 c0 01             	add    $0x1,%eax
    4331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
    4334:	a1 a8 5c 00 00       	mov    0x5ca8,%eax
    4339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    433c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4340:	75 23                	jne    4365 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4342:	c7 45 f0 a0 5c 00 00 	movl   $0x5ca0,-0x10(%ebp)
    4349:	8b 45 f0             	mov    -0x10(%ebp),%eax
    434c:	a3 a8 5c 00 00       	mov    %eax,0x5ca8
    4351:	a1 a8 5c 00 00       	mov    0x5ca8,%eax
    4356:	a3 a0 5c 00 00       	mov    %eax,0x5ca0
    base.s.size = 0;
    435b:	c7 05 a4 5c 00 00 00 	movl   $0x0,0x5ca4
    4362:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4365:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4368:	8b 00                	mov    (%eax),%eax
    436a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
    436d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4370:	8b 40 04             	mov    0x4(%eax),%eax
    4373:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    4376:	72 4d                	jb     43c5 <malloc+0xa6>
      if(p->s.size == nunits)
    4378:	8b 45 ec             	mov    -0x14(%ebp),%eax
    437b:	8b 40 04             	mov    0x4(%eax),%eax
    437e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    4381:	75 0c                	jne    438f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4383:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4386:	8b 10                	mov    (%eax),%edx
    4388:	8b 45 f0             	mov    -0x10(%ebp),%eax
    438b:	89 10                	mov    %edx,(%eax)
    438d:	eb 26                	jmp    43b5 <malloc+0x96>
      else {
        p->s.size -= nunits;
    438f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4392:	8b 40 04             	mov    0x4(%eax),%eax
    4395:	89 c2                	mov    %eax,%edx
    4397:	2b 55 f4             	sub    -0xc(%ebp),%edx
    439a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    439d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43a3:	8b 40 04             	mov    0x4(%eax),%eax
    43a6:	c1 e0 03             	shl    $0x3,%eax
    43a9:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
    43ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43af:	8b 55 f4             	mov    -0xc(%ebp),%edx
    43b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43b8:	a3 a8 5c 00 00       	mov    %eax,0x5ca8
      return (void*)(p + 1);
    43bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43c0:	83 c0 08             	add    $0x8,%eax
    43c3:	eb 38                	jmp    43fd <malloc+0xde>
    }
    if(p == freep)
    43c5:	a1 a8 5c 00 00       	mov    0x5ca8,%eax
    43ca:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    43cd:	75 1b                	jne    43ea <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    43cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d2:	89 04 24             	mov    %eax,(%esp)
    43d5:	e8 ed fe ff ff       	call   42c7 <morecore>
    43da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    43dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    43e1:	75 07                	jne    43ea <malloc+0xcb>
        return 0;
    43e3:	b8 00 00 00 00       	mov    $0x0,%eax
    43e8:	eb 13                	jmp    43fd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43f3:	8b 00                	mov    (%eax),%eax
    43f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    43f8:	e9 70 ff ff ff       	jmp    436d <malloc+0x4e>
}
    43fd:	c9                   	leave  
    43fe:	c3                   	ret    
