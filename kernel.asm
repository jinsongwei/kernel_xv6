
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 fc 37 10 80       	mov    $0x801037fc,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 dc 84 10 	movl   $0x801084dc,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 88 4e 00 00       	call   80104ed6 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 70 05 11 80 64 	movl   $0x80110564,0x80110570
80100055:	05 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 74 05 11 80 64 	movl   $0x80110564,0x80110574
8010005f:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 74 05 11 80       	mov    0x80110574,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 74 05 11 80       	mov    %eax,0x80110574

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	b8 64 05 11 80       	mov    $0x80110564,%eax
801000aa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ad:	72 bc                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000be:	e8 34 4e 00 00       	call   80104ef7 <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	a1 74 05 11 80       	mov    0x80110574,%eax
801000c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cb:	eb 63                	jmp    80100130 <bget+0x7f>
    if(b->dev == dev && b->blockno == blockno){
801000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d0:	8b 40 04             	mov    0x4(%eax),%eax
801000d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d6:	75 4f                	jne    80100127 <bget+0x76>
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 08             	mov    0x8(%eax),%eax
801000de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e1:	75 44                	jne    80100127 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 00                	mov    (%eax),%eax
801000e8:	83 e0 01             	and    $0x1,%eax
801000eb:	85 c0                	test   %eax,%eax
801000ed:	75 23                	jne    80100112 <bget+0x61>
        b->flags |= B_BUSY;
801000ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f2:	8b 00                	mov    (%eax),%eax
801000f4:	89 c2                	mov    %eax,%edx
801000f6:	83 ca 01             	or     $0x1,%edx
801000f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fc:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fe:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100105:	e8 4e 4e 00 00       	call   80104f58 <release>
        return b;
8010010a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010d:	e9 93 00 00 00       	jmp    801001a5 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100112:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100119:	80 
8010011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011d:	89 04 24             	mov    %eax,(%esp)
80100120:	e8 01 4b 00 00       	call   80104c26 <sleep>
      goto loop;
80100125:	eb 9c                	jmp    801000c3 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	8b 40 10             	mov    0x10(%eax),%eax
8010012d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100130:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100137:	75 94                	jne    801000cd <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100139:	a1 70 05 11 80       	mov    0x80110570,%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	eb 4d                	jmp    80100190 <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100146:	8b 00                	mov    (%eax),%eax
80100148:	83 e0 01             	and    $0x1,%eax
8010014b:	85 c0                	test   %eax,%eax
8010014d:	75 38                	jne    80100187 <bget+0xd6>
8010014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100152:	8b 00                	mov    (%eax),%eax
80100154:	83 e0 04             	and    $0x4,%eax
80100157:	85 c0                	test   %eax,%eax
80100159:	75 2c                	jne    80100187 <bget+0xd6>
      b->dev = dev;
8010015b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015e:	8b 55 08             	mov    0x8(%ebp),%edx
80100161:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010016a:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017d:	e8 d6 4d 00 00       	call   80104f58 <release>
      return b;
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	eb 1e                	jmp    801001a5 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018a:	8b 40 0c             	mov    0xc(%eax),%eax
8010018d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100190:	81 7d f4 64 05 11 80 	cmpl   $0x80110564,-0xc(%ebp)
80100197:	75 aa                	jne    80100143 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100199:	c7 04 24 e3 84 10 80 	movl   $0x801084e3,(%esp)
801001a0:	e8 98 03 00 00       	call   8010053d <panic>
}
801001a5:	c9                   	leave  
801001a6:	c3                   	ret    

801001a7 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001a7:	55                   	push   %ebp
801001a8:	89 e5                	mov    %esp,%ebp
801001aa:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b4:	8b 45 08             	mov    0x8(%ebp),%eax
801001b7:	89 04 24             	mov    %eax,(%esp)
801001ba:	e8 f2 fe ff ff       	call   801000b1 <bget>
801001bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c5:	8b 00                	mov    (%eax),%eax
801001c7:	83 e0 02             	and    $0x2,%eax
801001ca:	85 c0                	test   %eax,%eax
801001cc:	75 0b                	jne    801001d9 <bread+0x32>
    iderw(b);
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	89 04 24             	mov    %eax,(%esp)
801001d4:	e8 a8 26 00 00       	call   80102881 <iderw>
  }
  return b;
801001d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001dc:	c9                   	leave  
801001dd:	c3                   	ret    

801001de <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001de:	55                   	push   %ebp
801001df:	89 e5                	mov    %esp,%ebp
801001e1:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e4:	8b 45 08             	mov    0x8(%ebp),%eax
801001e7:	8b 00                	mov    (%eax),%eax
801001e9:	83 e0 01             	and    $0x1,%eax
801001ec:	85 c0                	test   %eax,%eax
801001ee:	75 0c                	jne    801001fc <bwrite+0x1e>
    panic("bwrite");
801001f0:	c7 04 24 f4 84 10 80 	movl   $0x801084f4,(%esp)
801001f7:	e8 41 03 00 00       	call   8010053d <panic>
  b->flags |= B_DIRTY;
801001fc:	8b 45 08             	mov    0x8(%ebp),%eax
801001ff:	8b 00                	mov    (%eax),%eax
80100201:	89 c2                	mov    %eax,%edx
80100203:	83 ca 04             	or     $0x4,%edx
80100206:	8b 45 08             	mov    0x8(%ebp),%eax
80100209:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020b:	8b 45 08             	mov    0x8(%ebp),%eax
8010020e:	89 04 24             	mov    %eax,(%esp)
80100211:	e8 6b 26 00 00       	call   80102881 <iderw>
}
80100216:	c9                   	leave  
80100217:	c3                   	ret    

80100218 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	8b 00                	mov    (%eax),%eax
80100223:	83 e0 01             	and    $0x1,%eax
80100226:	85 c0                	test   %eax,%eax
80100228:	75 0c                	jne    80100236 <brelse+0x1e>
    panic("brelse");
8010022a:	c7 04 24 fb 84 10 80 	movl   $0x801084fb,(%esp)
80100231:	e8 07 03 00 00       	call   8010053d <panic>

  acquire(&bcache.lock);
80100236:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023d:	e8 b5 4c 00 00       	call   80104ef7 <acquire>

  b->next->prev = b->prev;
80100242:	8b 45 08             	mov    0x8(%ebp),%eax
80100245:	8b 40 10             	mov    0x10(%eax),%eax
80100248:	8b 55 08             	mov    0x8(%ebp),%edx
8010024b:	8b 52 0c             	mov    0xc(%edx),%edx
8010024e:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100251:	8b 45 08             	mov    0x8(%ebp),%eax
80100254:	8b 40 0c             	mov    0xc(%eax),%eax
80100257:	8b 55 08             	mov    0x8(%ebp),%edx
8010025a:	8b 52 10             	mov    0x10(%edx),%edx
8010025d:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100260:	8b 15 74 05 11 80    	mov    0x80110574,%edx
80100266:	8b 45 08             	mov    0x8(%ebp),%eax
80100269:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	c7 40 0c 64 05 11 80 	movl   $0x80110564,0xc(%eax)
  bcache.head.next->prev = b;
80100276:	a1 74 05 11 80       	mov    0x80110574,%eax
8010027b:	8b 55 08             	mov    0x8(%ebp),%edx
8010027e:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	a3 74 05 11 80       	mov    %eax,0x80110574

  b->flags &= ~B_BUSY;
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	8b 00                	mov    (%eax),%eax
8010028e:	89 c2                	mov    %eax,%edx
80100290:	83 e2 fe             	and    $0xfffffffe,%edx
80100293:	8b 45 08             	mov    0x8(%ebp),%eax
80100296:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100298:	8b 45 08             	mov    0x8(%ebp),%eax
8010029b:	89 04 24             	mov    %eax,(%esp)
8010029e:	e8 5d 4a 00 00       	call   80104d00 <wakeup>

  release(&bcache.lock);
801002a3:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002aa:	e8 a9 4c 00 00       	call   80104f58 <release>
}
801002af:	c9                   	leave  
801002b0:	c3                   	ret    
801002b1:	00 00                	add    %al,(%eax)
	...

801002b4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b4:	55                   	push   %ebp
801002b5:	89 e5                	mov    %esp,%ebp
801002b7:	83 ec 14             	sub    $0x14,%esp
801002ba:	8b 45 08             	mov    0x8(%ebp),%eax
801002bd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002c1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c5:	89 c2                	mov    %eax,%edx
801002c7:	ec                   	in     (%dx),%al
801002c8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002cb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    

801002d1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d1:	55                   	push   %ebp
801002d2:	89 e5                	mov    %esp,%ebp
801002d4:	83 ec 08             	sub    $0x8,%esp
801002d7:	8b 55 08             	mov    0x8(%ebp),%edx
801002da:	8b 45 0c             	mov    0xc(%ebp),%eax
801002dd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002e1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002ec:	ee                   	out    %al,(%dx)
}
801002ed:	c9                   	leave  
801002ee:	c3                   	ret    

801002ef <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002ef:	55                   	push   %ebp
801002f0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f2:	fa                   	cli    
}
801002f3:	5d                   	pop    %ebp
801002f4:	c3                   	ret    

801002f5 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	53                   	push   %ebx
801002f9:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100300:	74 19                	je     8010031b <printint+0x26>
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	c1 e8 1f             	shr    $0x1f,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x26>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100319:	eb 06                	jmp    80100321 <printint+0x2c>
    x = -xx;
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  i = 0;
80100321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100331:	ba 00 00 00 00       	mov    $0x0,%edx
80100336:	f7 f3                	div    %ebx
80100338:	89 d0                	mov    %edx,%eax
8010033a:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100341:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
80100345:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }while((x /= base) != 0);
80100349:	8b 45 0c             	mov    0xc(%ebp),%eax
8010034c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100352:	ba 00 00 00 00       	mov    $0x0,%edx
80100357:	f7 75 d4             	divl   -0x2c(%ebp)
8010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010035d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100361:	75 c5                	jne    80100328 <printint+0x33>

  if(sign)
80100363:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100367:	74 23                	je     8010038c <printint+0x97>
    buf[i++] = '-';
80100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010036c:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)
80100371:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

  while(--i >= 0)
80100375:	eb 16                	jmp    8010038d <printint+0x98>
    consputc(buf[i]);
80100377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010037a:	0f b6 44 05 e0       	movzbl -0x20(%ebp,%eax,1),%eax
8010037f:	0f be c0             	movsbl %al,%eax
80100382:	89 04 24             	mov    %eax,(%esp)
80100385:	e8 e2 03 00 00       	call   8010076c <consputc>
8010038a:	eb 01                	jmp    8010038d <printint+0x98>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038c:	90                   	nop
8010038d:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80100391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100395:	79 e0                	jns    80100377 <printint+0x82>
    consputc(buf[i]);
}
80100397:	83 c4 44             	add    $0x44,%esp
8010039a:	5b                   	pop    %ebx
8010039b:	5d                   	pop    %ebp
8010039c:	c3                   	ret    

8010039d <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010039d:	55                   	push   %ebp
8010039e:	89 e5                	mov    %esp,%ebp
801003a0:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a3:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
801003ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801003af:	74 0c                	je     801003bd <cprintf+0x20>
    acquire(&cons.lock);
801003b1:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003b8:	e8 3a 4b 00 00       	call   80104ef7 <acquire>

  if (fmt == 0)
801003bd:	8b 45 08             	mov    0x8(%ebp),%eax
801003c0:	85 c0                	test   %eax,%eax
801003c2:	75 0c                	jne    801003d0 <cprintf+0x33>
    panic("null fmt");
801003c4:	c7 04 24 02 85 10 80 	movl   $0x80108502,(%esp)
801003cb:	e8 6d 01 00 00       	call   8010053d <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d0:	8d 45 08             	lea    0x8(%ebp),%eax
801003d3:	83 c0 04             	add    $0x4,%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801003e0:	e9 20 01 00 00       	jmp    80100505 <cprintf+0x168>
    if(c != '%'){
801003e5:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5e>
      consputc(c);
801003eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 76 03 00 00       	call   8010076c <consputc>
      continue;
801003f6:	e9 06 01 00 00       	jmp    80100501 <cprintf+0x164>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100405:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100408:	0f b6 00             	movzbl (%eax),%eax
8010040b:	0f be c0             	movsbl %al,%eax
8010040e:	25 ff 00 00 00       	and    $0xff,%eax
80100413:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
80100416:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010041a:	0f 84 08 01 00 00    	je     80100528 <cprintf+0x18b>
      break;
    switch(c){
80100420:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4d                	je     80100475 <cprintf+0xd8>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa3>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13f>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xb2>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14d>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 53                	je     80100498 <cprintf+0xfb>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2b                	je     80100475 <cprintf+0xd8>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14d>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8b 00                	mov    (%eax),%eax
80100454:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045f:	00 
80100460:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100467:	00 
80100468:	89 04 24             	mov    %eax,(%esp)
8010046b:	e8 85 fe ff ff       	call   801002f5 <printint>
      break;
80100470:	e9 8c 00 00 00       	jmp    80100501 <cprintf+0x164>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100478:	8b 00                	mov    (%eax),%eax
8010047a:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100485:	00 
80100486:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048d:	00 
8010048e:	89 04 24             	mov    %eax,(%esp)
80100491:	e8 5f fe ff ff       	call   801002f5 <printint>
      break;
80100496:	eb 69                	jmp    80100501 <cprintf+0x164>
    case 's':
      if((s = (char*)*argp++) == 0)
80100498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049b:	8b 00                	mov    (%eax),%eax
8010049d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801004a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801004a4:	0f 94 c0             	sete   %al
801004a7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004ab:	84 c0                	test   %al,%al
801004ad:	74 20                	je     801004cf <cprintf+0x132>
        s = "(null)";
801004af:	c7 45 f4 0b 85 10 80 	movl   $0x8010850b,-0xc(%ebp)
      for(; *s; s++)
801004b6:	eb 18                	jmp    801004d0 <cprintf+0x133>
        consputc(*s);
801004b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004bb:	0f b6 00             	movzbl (%eax),%eax
801004be:	0f be c0             	movsbl %al,%eax
801004c1:	89 04 24             	mov    %eax,(%esp)
801004c4:	e8 a3 02 00 00       	call   8010076c <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801004cd:	eb 01                	jmp    801004d0 <cprintf+0x133>
801004cf:	90                   	nop
801004d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 de                	jne    801004b8 <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 25                	jmp    80100501 <cprintf+0x164>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 84 02 00 00       	call   8010076c <consputc>
      break;
801004e8:	eb 17                	jmp    80100501 <cprintf+0x164>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 76 02 00 00       	call   8010076c <consputc>
      consputc(c);
801004f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 6b 02 00 00       	call   8010076c <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100501:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100505:	8b 55 08             	mov    0x8(%ebp),%edx
80100508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010050b:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010051c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x48>
80100526:	eb 01                	jmp    80100529 <cprintf+0x18c>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100528:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100529:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010052d:	74 0c                	je     8010053b <cprintf+0x19e>
    release(&cons.lock);
8010052f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100536:	e8 1d 4a 00 00       	call   80104f58 <release>
}
8010053b:	c9                   	leave  
8010053c:	c3                   	ret    

8010053d <panic>:

void
panic(char *s)
{
8010053d:	55                   	push   %ebp
8010053e:	89 e5                	mov    %esp,%ebp
80100540:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100543:	e8 a7 fd ff ff       	call   801002ef <cli>
  cons.locking = 0;
80100548:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054f:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f b6 c0             	movzbl %al,%eax
8010055e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100562:	c7 04 24 12 85 10 80 	movl   $0x80108512,(%esp)
80100569:	e8 2f fe ff ff       	call   8010039d <cprintf>
  cprintf(s);
8010056e:	8b 45 08             	mov    0x8(%ebp),%eax
80100571:	89 04 24             	mov    %eax,(%esp)
80100574:	e8 24 fe ff ff       	call   8010039d <cprintf>
  cprintf("\n");
80100579:	c7 04 24 21 85 10 80 	movl   $0x80108521,(%esp)
80100580:	e8 18 fe ff ff       	call   8010039d <cprintf>
  getcallerpcs(&s, pcs);
80100585:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058c:	8d 45 08             	lea    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 10 4a 00 00       	call   80104fa7 <getcallerpcs>
  for(i=0; i<10; i++)
80100597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059e:	eb 1b                	jmp    801005bb <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ab:	c7 04 24 23 85 10 80 	movl   $0x80108523,(%esp)
801005b2:	e8 e6 fd ff ff       	call   8010039d <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bf:	7e df                	jle    801005a0 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c1:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c8:	00 00 00 
  for(;;)
    ;
801005cb:	eb fe                	jmp    801005cb <panic+0x8e>

801005cd <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d3:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005da:	00 
801005db:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e2:	e8 ea fc ff ff       	call   801002d1 <outb>
  pos = inb(CRTPORT+1) << 8;
801005e7:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005ee:	e8 c1 fc ff ff       	call   801002b4 <inb>
801005f3:	0f b6 c0             	movzbl %al,%eax
801005f6:	c1 e0 08             	shl    $0x8,%eax
801005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005fc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100603:	00 
80100604:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060b:	e8 c1 fc ff ff       	call   801002d1 <outb>
  pos |= inb(CRTPORT+1);
80100610:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100617:	e8 98 fc ff ff       	call   801002b4 <inb>
8010061c:	0f b6 c0             	movzbl %al,%eax
8010061f:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100622:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100626:	75 30                	jne    80100658 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100628:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100630:	89 c8                	mov    %ecx,%eax
80100632:	f7 ea                	imul   %edx
80100634:	c1 fa 05             	sar    $0x5,%edx
80100637:	89 c8                	mov    %ecx,%eax
80100639:	c1 f8 1f             	sar    $0x1f,%eax
8010063c:	29 c2                	sub    %eax,%edx
8010063e:	89 d0                	mov    %edx,%eax
80100640:	c1 e0 02             	shl    $0x2,%eax
80100643:	01 d0                	add    %edx,%eax
80100645:	c1 e0 04             	shl    $0x4,%eax
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	29 c2                	sub    %eax,%edx
8010064c:	b8 50 00 00 00       	mov    $0x50,%eax
80100651:	29 d0                	sub    %edx,%eax
80100653:	01 45 f4             	add    %eax,-0xc(%ebp)
80100656:	eb 33                	jmp    8010068b <cgaputc+0xbe>
  else if(c == BACKSPACE){
80100658:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065f:	75 0c                	jne    8010066d <cgaputc+0xa0>
    if(pos > 0) --pos;
80100661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100665:	7e 24                	jle    8010068b <cgaputc+0xbe>
80100667:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010066b:	eb 1e                	jmp    8010068b <cgaputc+0xbe>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100675:	01 d2                	add    %edx,%edx
80100677:	8d 14 10             	lea    (%eax,%edx,1),%edx
8010067a:	8b 45 08             	mov    0x8(%ebp),%eax
8010067d:	66 25 ff 00          	and    $0xff,%ax
80100681:	80 cc 07             	or     $0x7,%ah
80100684:	66 89 02             	mov    %ax,(%edx)
80100687:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  if(pos < 0 || pos > 25*80)
8010068b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068f:	78 09                	js     8010069a <cgaputc+0xcd>
80100691:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100698:	7e 0c                	jle    801006a6 <cgaputc+0xd9>
    panic("pos under/overflow");
8010069a:	c7 04 24 27 85 10 80 	movl   $0x80108527,(%esp)
801006a1:	e8 97 fe ff ff       	call   8010053d <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006a6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006ad:	7e 53                	jle    80100702 <cgaputc+0x135>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006af:	a1 00 90 10 80       	mov    0x80109000,%eax
801006b4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ba:	a1 00 90 10 80       	mov    0x80109000,%eax
801006bf:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006c6:	00 
801006c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801006cb:	89 04 24             	mov    %eax,(%esp)
801006ce:	e8 4e 4b 00 00       	call   80105221 <memmove>
    pos -= 80;
801006d3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006d7:	b8 80 07 00 00       	mov    $0x780,%eax
801006dc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006df:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ea:	01 c9                	add    %ecx,%ecx
801006ec:	01 c8                	add    %ecx,%eax
801006ee:	89 54 24 08          	mov    %edx,0x8(%esp)
801006f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006f9:	00 
801006fa:	89 04 24             	mov    %eax,(%esp)
801006fd:	e8 4c 4a 00 00       	call   8010514e <memset>
  }
  
  outb(CRTPORT, 14);
80100702:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100709:	00 
8010070a:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100711:	e8 bb fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos>>8);
80100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100719:	c1 f8 08             	sar    $0x8,%eax
8010071c:	0f b6 c0             	movzbl %al,%eax
8010071f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100723:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010072a:	e8 a2 fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT, 15);
8010072f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100736:	00 
80100737:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010073e:	e8 8e fb ff ff       	call   801002d1 <outb>
  outb(CRTPORT+1, pos);
80100743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100746:	0f b6 c0             	movzbl %al,%eax
80100749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100754:	e8 78 fb ff ff       	call   801002d1 <outb>
  crt[pos] = ' ' | 0x0700;
80100759:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100761:	01 d2                	add    %edx,%edx
80100763:	01 d0                	add    %edx,%eax
80100765:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010076a:	c9                   	leave  
8010076b:	c3                   	ret    

8010076c <consputc>:

void
consputc(int c)
{
8010076c:	55                   	push   %ebp
8010076d:	89 e5                	mov    %esp,%ebp
8010076f:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100772:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100777:	85 c0                	test   %eax,%eax
80100779:	74 07                	je     80100782 <consputc+0x16>
    cli();
8010077b:	e8 6f fb ff ff       	call   801002ef <cli>
    for(;;)
      ;
80100780:	eb fe                	jmp    80100780 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100782:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100789:	75 26                	jne    801007b1 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100792:	e8 95 63 00 00       	call   80106b2c <uartputc>
80100797:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010079e:	e8 89 63 00 00       	call   80106b2c <uartputc>
801007a3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007aa:	e8 7d 63 00 00       	call   80106b2c <uartputc>
801007af:	eb 0b                	jmp    801007bc <consputc+0x50>
  } else
    uartputc(c);
801007b1:	8b 45 08             	mov    0x8(%ebp),%eax
801007b4:	89 04 24             	mov    %eax,(%esp)
801007b7:	e8 70 63 00 00       	call   80106b2c <uartputc>
  cgaputc(c);
801007bc:	8b 45 08             	mov    0x8(%ebp),%eax
801007bf:	89 04 24             	mov    %eax,(%esp)
801007c2:	e8 06 fe ff ff       	call   801005cd <cgaputc>
}
801007c7:	c9                   	leave  
801007c8:	c3                   	ret    

801007c9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c9:	55                   	push   %ebp
801007ca:	89 e5                	mov    %esp,%ebp
801007cc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007d6:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801007dd:	e8 15 47 00 00       	call   80104ef7 <acquire>
  while((c = getc()) >= 0){
801007e2:	e9 40 01 00 00       	jmp    80100927 <consoleintr+0x15e>
    switch(c){
801007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801007ea:	83 f8 10             	cmp    $0x10,%eax
801007ed:	74 1e                	je     8010080d <consoleintr+0x44>
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	7f 0a                	jg     801007fe <consoleintr+0x35>
801007f4:	83 f8 08             	cmp    $0x8,%eax
801007f7:	74 6a                	je     80100863 <consoleintr+0x9a>
801007f9:	e9 96 00 00 00       	jmp    80100894 <consoleintr+0xcb>
801007fe:	83 f8 15             	cmp    $0x15,%eax
80100801:	74 31                	je     80100834 <consoleintr+0x6b>
80100803:	83 f8 7f             	cmp    $0x7f,%eax
80100806:	74 5b                	je     80100863 <consoleintr+0x9a>
80100808:	e9 87 00 00 00       	jmp    80100894 <consoleintr+0xcb>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010080d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100814:	e9 0e 01 00 00       	jmp    80100927 <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100819:	a1 08 08 11 80       	mov    0x80110808,%eax
8010081e:	83 e8 01             	sub    $0x1,%eax
80100821:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
80100826:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010082d:	e8 3a ff ff ff       	call   8010076c <consputc>
80100832:	eb 01                	jmp    80100835 <consoleintr+0x6c>
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100834:	90                   	nop
80100835:	8b 15 08 08 11 80    	mov    0x80110808,%edx
8010083b:	a1 04 08 11 80       	mov    0x80110804,%eax
80100840:	39 c2                	cmp    %eax,%edx
80100842:	0f 84 db 00 00 00    	je     80100923 <consoleintr+0x15a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 08 08 11 80       	mov    0x80110808,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	0f b6 80 80 07 11 80 	movzbl -0x7feef880(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085a:	3c 0a                	cmp    $0xa,%al
8010085c:	75 bb                	jne    80100819 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010085e:	e9 c4 00 00 00       	jmp    80100927 <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100863:	8b 15 08 08 11 80    	mov    0x80110808,%edx
80100869:	a1 04 08 11 80       	mov    0x80110804,%eax
8010086e:	39 c2                	cmp    %eax,%edx
80100870:	0f 84 b0 00 00 00    	je     80100926 <consoleintr+0x15d>
        input.e--;
80100876:	a1 08 08 11 80       	mov    0x80110808,%eax
8010087b:	83 e8 01             	sub    $0x1,%eax
8010087e:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(BACKSPACE);
80100883:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010088a:	e8 dd fe ff ff       	call   8010076c <consputc>
      }
      break;
8010088f:	e9 93 00 00 00       	jmp    80100927 <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100894:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100898:	0f 84 89 00 00 00    	je     80100927 <consoleintr+0x15e>
8010089e:	8b 15 08 08 11 80    	mov    0x80110808,%edx
801008a4:	a1 00 08 11 80       	mov    0x80110800,%eax
801008a9:	89 d1                	mov    %edx,%ecx
801008ab:	29 c1                	sub    %eax,%ecx
801008ad:	89 c8                	mov    %ecx,%eax
801008af:	83 f8 7f             	cmp    $0x7f,%eax
801008b2:	77 73                	ja     80100927 <consoleintr+0x15e>
        c = (c == '\r') ? '\n' : c;
801008b4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008b8:	74 05                	je     801008bf <consoleintr+0xf6>
801008ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008bd:	eb 05                	jmp    801008c4 <consoleintr+0xfb>
801008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c7:	a1 08 08 11 80       	mov    0x80110808,%eax
801008cc:	89 c1                	mov    %eax,%ecx
801008ce:	83 e1 7f             	and    $0x7f,%ecx
801008d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008d4:	88 91 80 07 11 80    	mov    %dl,-0x7feef880(%ecx)
801008da:	83 c0 01             	add    $0x1,%eax
801008dd:	a3 08 08 11 80       	mov    %eax,0x80110808
        consputc(c);
801008e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008e5:	89 04 24             	mov    %eax,(%esp)
801008e8:	e8 7f fe ff ff       	call   8010076c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008ed:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801008f1:	74 18                	je     8010090b <consoleintr+0x142>
801008f3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801008f7:	74 12                	je     8010090b <consoleintr+0x142>
801008f9:	a1 08 08 11 80       	mov    0x80110808,%eax
801008fe:	8b 15 00 08 11 80    	mov    0x80110800,%edx
80100904:	83 ea 80             	sub    $0xffffff80,%edx
80100907:	39 d0                	cmp    %edx,%eax
80100909:	75 1c                	jne    80100927 <consoleintr+0x15e>
          input.w = input.e;
8010090b:	a1 08 08 11 80       	mov    0x80110808,%eax
80100910:	a3 04 08 11 80       	mov    %eax,0x80110804
          wakeup(&input.r);
80100915:	c7 04 24 00 08 11 80 	movl   $0x80110800,(%esp)
8010091c:	e8 df 43 00 00       	call   80104d00 <wakeup>
80100921:	eb 04                	jmp    80100927 <consoleintr+0x15e>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100923:	90                   	nop
80100924:	eb 01                	jmp    80100927 <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100926:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100927:	8b 45 08             	mov    0x8(%ebp),%eax
8010092a:	ff d0                	call   *%eax
8010092c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010092f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100933:	0f 89 ae fe ff ff    	jns    801007e7 <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100939:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100940:	e8 13 46 00 00       	call   80104f58 <release>
  if(doprocdump) {
80100945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100949:	74 05                	je     80100950 <consoleintr+0x187>
    procdump();  // now call procdump() wo. cons.lock held
8010094b:	e8 54 44 00 00       	call   80104da4 <procdump>
  }
}
80100950:	c9                   	leave  
80100951:	c3                   	ret    

80100952 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100952:	55                   	push   %ebp
80100953:	89 e5                	mov    %esp,%ebp
80100955:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100958:	8b 45 08             	mov    0x8(%ebp),%eax
8010095b:	89 04 24             	mov    %eax,(%esp)
8010095e:	e8 f5 10 00 00       	call   80101a58 <iunlock>
  target = n;
80100963:	8b 45 10             	mov    0x10(%ebp),%eax
80100966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  acquire(&cons.lock);
80100969:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100970:	e8 82 45 00 00       	call   80104ef7 <acquire>
  while(n > 0){
80100975:	e9 a8 00 00 00       	jmp    80100a22 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
8010097a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100980:	8b 40 24             	mov    0x24(%eax),%eax
80100983:	85 c0                	test   %eax,%eax
80100985:	74 21                	je     801009a8 <consoleread+0x56>
        release(&cons.lock);
80100987:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010098e:	e8 c5 45 00 00       	call   80104f58 <release>
        ilock(ip);
80100993:	8b 45 08             	mov    0x8(%ebp),%eax
80100996:	89 04 24             	mov    %eax,(%esp)
80100999:	e8 63 0f 00 00       	call   80101901 <ilock>
        return -1;
8010099e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009a3:	e9 a9 00 00 00       	jmp    80100a51 <consoleread+0xff>
      }
      sleep(&input.r, &cons.lock);
801009a8:	c7 44 24 04 c0 b5 10 	movl   $0x8010b5c0,0x4(%esp)
801009af:	80 
801009b0:	c7 04 24 00 08 11 80 	movl   $0x80110800,(%esp)
801009b7:	e8 6a 42 00 00       	call   80104c26 <sleep>
801009bc:	eb 01                	jmp    801009bf <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009be:	90                   	nop
801009bf:	8b 15 00 08 11 80    	mov    0x80110800,%edx
801009c5:	a1 04 08 11 80       	mov    0x80110804,%eax
801009ca:	39 c2                	cmp    %eax,%edx
801009cc:	74 ac                	je     8010097a <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ce:	a1 00 08 11 80       	mov    0x80110800,%eax
801009d3:	89 c2                	mov    %eax,%edx
801009d5:	83 e2 7f             	and    $0x7f,%edx
801009d8:	0f b6 92 80 07 11 80 	movzbl -0x7feef880(%edx),%edx
801009df:	0f be d2             	movsbl %dl,%edx
801009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801009e5:	83 c0 01             	add    $0x1,%eax
801009e8:	a3 00 08 11 80       	mov    %eax,0x80110800
    if(c == C('D')){  // EOF
801009ed:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801009f1:	75 17                	jne    80100a0a <consoleread+0xb8>
      if(n < target){
801009f3:	8b 45 10             	mov    0x10(%ebp),%eax
801009f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801009f9:	73 2f                	jae    80100a2a <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009fb:	a1 00 08 11 80       	mov    0x80110800,%eax
80100a00:	83 e8 01             	sub    $0x1,%eax
80100a03:	a3 00 08 11 80       	mov    %eax,0x80110800
      }
      break;
80100a08:	eb 24                	jmp    80100a2e <consoleread+0xdc>
    }
    *dst++ = c;
80100a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a0d:	89 c2                	mov    %eax,%edx
80100a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a12:	88 10                	mov    %dl,(%eax)
80100a14:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
80100a18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a1c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100a20:	74 0b                	je     80100a2d <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a26:	7f 96                	jg     801009be <consoleread+0x6c>
80100a28:	eb 04                	jmp    80100a2e <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a2a:	90                   	nop
80100a2b:	eb 01                	jmp    80100a2e <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a2d:	90                   	nop
  }
  release(&cons.lock);
80100a2e:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a35:	e8 1e 45 00 00       	call   80104f58 <release>
  ilock(ip);
80100a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80100a3d:	89 04 24             	mov    %eax,(%esp)
80100a40:	e8 bc 0e 00 00       	call   80101901 <ilock>

  return target - n;
80100a45:	8b 45 10             	mov    0x10(%ebp),%eax
80100a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a4b:	89 d1                	mov    %edx,%ecx
80100a4d:	29 c1                	sub    %eax,%ecx
80100a4f:	89 c8                	mov    %ecx,%eax
}
80100a51:	c9                   	leave  
80100a52:	c3                   	ret    

80100a53 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a53:	55                   	push   %ebp
80100a54:	89 e5                	mov    %esp,%ebp
80100a56:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a59:	8b 45 08             	mov    0x8(%ebp),%eax
80100a5c:	89 04 24             	mov    %eax,(%esp)
80100a5f:	e8 f4 0f 00 00       	call   80101a58 <iunlock>
  acquire(&cons.lock);
80100a64:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6b:	e8 87 44 00 00       	call   80104ef7 <acquire>
  for(i = 0; i < n; i++)
80100a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a77:	eb 1d                	jmp    80100a96 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a7c:	03 45 0c             	add    0xc(%ebp),%eax
80100a7f:	0f b6 00             	movzbl (%eax),%eax
80100a82:	0f be c0             	movsbl %al,%eax
80100a85:	25 ff 00 00 00       	and    $0xff,%eax
80100a8a:	89 04 24             	mov    %eax,(%esp)
80100a8d:	e8 da fc ff ff       	call   8010076c <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a99:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a9c:	7c db                	jl     80100a79 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a9e:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100aa5:	e8 ae 44 00 00       	call   80104f58 <release>
  ilock(ip);
80100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80100aad:	89 04 24             	mov    %eax,(%esp)
80100ab0:	e8 4c 0e 00 00       	call   80101901 <ilock>

  return n;
80100ab5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ab8:	c9                   	leave  
80100ab9:	c3                   	ret    

80100aba <consoleinit>:

void
consoleinit(void)
{
80100aba:	55                   	push   %ebp
80100abb:	89 e5                	mov    %esp,%ebp
80100abd:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ac0:	c7 44 24 04 3a 85 10 	movl   $0x8010853a,0x4(%esp)
80100ac7:	80 
80100ac8:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100acf:	e8 02 44 00 00       	call   80104ed6 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ad4:	c7 05 cc 11 11 80 53 	movl   $0x80100a53,0x801111cc
80100adb:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ade:	c7 05 c8 11 11 80 52 	movl   $0x80100952,0x801111c8
80100ae5:	09 10 80 
  cons.locking = 1;
80100ae8:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aef:	00 00 00 

  picenable(IRQ_KBD);
80100af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100af9:	e8 97 33 00 00       	call   80103e95 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100afe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b05:	00 
80100b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b0d:	e8 30 1f 00 00       	call   80102a42 <ioapicenable>
}
80100b12:	c9                   	leave  
80100b13:	c3                   	ret    

80100b14 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b14:	55                   	push   %ebp
80100b15:	89 e5                	mov    %esp,%ebp
80100b17:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b1d:	e8 d4 29 00 00       	call   801034f6 <begin_op>
  if((ip = namei(path)) == 0){
80100b22:	8b 45 08             	mov    0x8(%ebp),%eax
80100b25:	89 04 24             	mov    %eax,(%esp)
80100b28:	e8 82 19 00 00       	call   801024af <namei>
80100b2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100b30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100b34:	75 0f                	jne    80100b45 <exec+0x31>
    end_op();
80100b36:	e8 3d 2a 00 00       	call   80103578 <end_op>
    return -1;
80100b3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b40:	e9 e2 03 00 00       	jmp    80100f27 <exec+0x413>
  }
  ilock(ip);
80100b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b48:	89 04 24             	mov    %eax,(%esp)
80100b4b:	e8 b1 0d 00 00       	call   80101901 <ilock>
  pgdir = 0;
80100b50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b57:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b5d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b64:	00 
80100b65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b6c:	00 
80100b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100b74:	89 04 24             	mov    %eax,(%esp)
80100b77:	e8 84 12 00 00       	call   80101e00 <readi>
80100b7c:	83 f8 33             	cmp    $0x33,%eax
80100b7f:	0f 86 57 03 00 00    	jbe    80100edc <exec+0x3c8>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b90:	0f 85 49 03 00 00    	jne    80100edf <exec+0x3cb>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b96:	e8 d6 70 00 00       	call   80107c71 <setupkvm>
80100b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100ba2:	0f 84 3a 03 00 00    	je     80100ee2 <exec+0x3ce>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ba8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100baf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100bb6:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100bbf:	e9 ca 00 00 00       	jmp    80100c8e <exec+0x17a>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100bc7:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bcd:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bd4:	00 
80100bd5:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	e8 18 12 00 00       	call   80101e00 <readi>
80100be8:	83 f8 20             	cmp    $0x20,%eax
80100beb:	0f 85 f4 02 00 00    	jne    80100ee5 <exec+0x3d1>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bf1:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bf7:	83 f8 01             	cmp    $0x1,%eax
80100bfa:	0f 85 80 00 00 00    	jne    80100c80 <exec+0x16c>
      continue;
    if(ph.memsz < ph.filesz)
80100c00:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c06:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c0c:	39 c2                	cmp    %eax,%edx
80100c0e:	0f 82 d4 02 00 00    	jb     80100ee8 <exec+0x3d4>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c14:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c1a:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c20:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100c23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c31:	89 04 24             	mov    %eax,(%esp)
80100c34:	e8 0c 74 00 00       	call   80108045 <allocuvm>
80100c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100c40:	0f 84 a5 02 00 00    	je     80100eeb <exec+0x3d7>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c46:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c4c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c52:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c58:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c60:	8b 55 ec             	mov    -0x14(%ebp),%edx
80100c63:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c6e:	89 04 24             	mov    %eax,(%esp)
80100c71:	e8 df 72 00 00       	call   80107f55 <loaduvm>
80100c76:	85 c0                	test   %eax,%eax
80100c78:	0f 88 70 02 00 00    	js     80100eee <exec+0x3da>
80100c7e:	eb 01                	jmp    80100c81 <exec+0x16d>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c80:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80100c85:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100c88:	83 c0 20             	add    $0x20,%eax
80100c8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100c8e:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c95:	0f b7 c0             	movzwl %ax,%eax
80100c98:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100c9b:	0f 8f 23 ff ff ff    	jg     80100bc4 <exec+0xb0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100ca4:	89 04 24             	mov    %eax,(%esp)
80100ca7:	e8 e2 0e 00 00       	call   80101b8e <iunlockput>
  end_op();
80100cac:	e8 c7 28 00 00       	call   80103578 <end_op>
  ip = 0;
80100cb1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cbb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ccb:	05 00 20 00 00       	add    $0x2000,%eax
80100cd0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100cde:	89 04 24             	mov    %eax,(%esp)
80100ce1:	e8 5f 73 00 00       	call   80108045 <allocuvm>
80100ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ce9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100ced:	0f 84 fe 01 00 00    	je     80100ef1 <exec+0x3dd>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cf6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d02:	89 04 24             	mov    %eax,(%esp)
80100d05:	e8 5f 75 00 00       	call   80108269 <clearpteu>
  sp = sz;
80100d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0d:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80100d17:	e9 81 00 00 00       	jmp    80100d9d <exec+0x289>
    if(argc >= MAXARG)
80100d1c:	83 7d e0 1f          	cmpl   $0x1f,-0x20(%ebp)
80100d20:	0f 87 ce 01 00 00    	ja     80100ef4 <exec+0x3e0>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d29:	c1 e0 02             	shl    $0x2,%eax
80100d2c:	03 45 0c             	add    0xc(%ebp),%eax
80100d2f:	8b 00                	mov    (%eax),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 96 46 00 00       	call   801053cf <strlen>
80100d39:	f7 d0                	not    %eax
80100d3b:	03 45 e8             	add    -0x18(%ebp),%eax
80100d3e:	83 e0 fc             	and    $0xfffffffc,%eax
80100d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d47:	c1 e0 02             	shl    $0x2,%eax
80100d4a:	03 45 0c             	add    0xc(%ebp),%eax
80100d4d:	8b 00                	mov    (%eax),%eax
80100d4f:	89 04 24             	mov    %eax,(%esp)
80100d52:	e8 78 46 00 00       	call   801053cf <strlen>
80100d57:	83 c0 01             	add    $0x1,%eax
80100d5a:	89 c2                	mov    %eax,%edx
80100d5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d5f:	c1 e0 02             	shl    $0x2,%eax
80100d62:	03 45 0c             	add    0xc(%ebp),%eax
80100d65:	8b 00                	mov    (%eax),%eax
80100d67:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100d79:	89 04 24             	mov    %eax,(%esp)
80100d7c:	e8 ad 76 00 00       	call   8010842e <copyout>
80100d81:	85 c0                	test   %eax,%eax
80100d83:	0f 88 6e 01 00 00    	js     80100ef7 <exec+0x3e3>
      goto bad;
    ustack[3+argc] = sp;
80100d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8c:	8d 50 03             	lea    0x3(%eax),%edx
80100d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d92:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d99:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80100d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da0:	c1 e0 02             	shl    $0x2,%eax
80100da3:	03 45 0c             	add    0xc(%ebp),%eax
80100da6:	8b 00                	mov    (%eax),%eax
80100da8:	85 c0                	test   %eax,%eax
80100daa:	0f 85 6c ff ff ff    	jne    80100d1c <exec+0x208>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db3:	83 c0 03             	add    $0x3,%eax
80100db6:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc1:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc8:	ff ff ff 
  ustack[1] = argc;
80100dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dce:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd7:	83 c0 01             	add    $0x1,%eax
80100dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de4:	29 d0                	sub    %edx,%eax
80100de6:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dec:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100def:	83 c0 04             	add    $0x4,%eax
80100df2:	c1 e0 02             	shl    $0x2,%eax
80100df5:	29 45 e8             	sub    %eax,-0x18(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dfb:	83 c0 04             	add    $0x4,%eax
80100dfe:	c1 e0 02             	shl    $0x2,%eax
80100e01:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e05:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e19:	89 04 24             	mov    %eax,(%esp)
80100e1c:	e8 0d 76 00 00       	call   8010842e <copyout>
80100e21:	85 c0                	test   %eax,%eax
80100e23:	0f 88 d1 00 00 00    	js     80100efa <exec+0x3e6>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e29:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100e2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100e35:	eb 17                	jmp    80100e4e <exec+0x33a>
    if(*s == '/')
80100e37:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e3a:	0f b6 00             	movzbl (%eax),%eax
80100e3d:	3c 2f                	cmp    $0x2f,%al
80100e3f:	75 09                	jne    80100e4a <exec+0x336>
      last = s+1;
80100e41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e44:	83 c0 01             	add    $0x1,%eax
80100e47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4a:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e51:	0f b6 00             	movzbl (%eax),%eax
80100e54:	84 c0                	test   %al,%al
80100e56:	75 df                	jne    80100e37 <exec+0x323>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5e:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e68:	00 
80100e69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e70:	89 14 24             	mov    %edx,(%esp)
80100e73:	e8 09 45 00 00       	call   80105381 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7e:	8b 40 04             	mov    0x4(%eax),%eax
80100e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->pgdir = pgdir;
80100e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100e8d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100e99:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea1:	8b 40 18             	mov    0x18(%eax),%eax
80100ea4:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eaa:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb3:	8b 40 18             	mov    0x18(%eax),%eax
80100eb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100eb9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec2:	89 04 24             	mov    %eax,(%esp)
80100ec5:	e8 99 6e 00 00       	call   80107d63 <switchuvm>
  freevm(oldpgdir);
80100eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ecd:	89 04 24             	mov    %eax,(%esp)
80100ed0:	e8 06 73 00 00       	call   801081db <freevm>
  return 0;
80100ed5:	b8 00 00 00 00       	mov    $0x0,%eax
80100eda:	eb 4b                	jmp    80100f27 <exec+0x413>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100edc:	90                   	nop
80100edd:	eb 1c                	jmp    80100efb <exec+0x3e7>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100edf:	90                   	nop
80100ee0:	eb 19                	jmp    80100efb <exec+0x3e7>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100ee2:	90                   	nop
80100ee3:	eb 16                	jmp    80100efb <exec+0x3e7>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ee5:	90                   	nop
80100ee6:	eb 13                	jmp    80100efb <exec+0x3e7>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ee8:	90                   	nop
80100ee9:	eb 10                	jmp    80100efb <exec+0x3e7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100eeb:	90                   	nop
80100eec:	eb 0d                	jmp    80100efb <exec+0x3e7>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100eee:	90                   	nop
80100eef:	eb 0a                	jmp    80100efb <exec+0x3e7>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ef1:	90                   	nop
80100ef2:	eb 07                	jmp    80100efb <exec+0x3e7>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ef4:	90                   	nop
80100ef5:	eb 04                	jmp    80100efb <exec+0x3e7>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ef7:	90                   	nop
80100ef8:	eb 01                	jmp    80100efb <exec+0x3e7>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100efa:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100eff:	74 0b                	je     80100f0c <exec+0x3f8>
    freevm(pgdir);
80100f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 cf 72 00 00       	call   801081db <freevm>
  if(ip){
80100f0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100f10:	74 10                	je     80100f22 <exec+0x40e>
    iunlockput(ip);
80100f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100f15:	89 04 24             	mov    %eax,(%esp)
80100f18:	e8 71 0c 00 00       	call   80101b8e <iunlockput>
    end_op();
80100f1d:	e8 56 26 00 00       	call   80103578 <end_op>
  }
  return -1;
80100f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f27:	c9                   	leave  
80100f28:	c3                   	ret    
80100f29:	00 00                	add    %al,(%eax)
	...

80100f2c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f2c:	55                   	push   %ebp
80100f2d:	89 e5                	mov    %esp,%ebp
80100f2f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f32:	c7 44 24 04 42 85 10 	movl   $0x80108542,0x4(%esp)
80100f39:	80 
80100f3a:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100f41:	e8 90 3f 00 00       	call   80104ed6 <initlock>
}
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    

80100f48 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f48:	55                   	push   %ebp
80100f49:	89 e5                	mov    %esp,%ebp
80100f4b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f4e:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100f55:	e8 9d 3f 00 00       	call   80104ef7 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5a:	c7 45 f4 54 08 11 80 	movl   $0x80110854,-0xc(%ebp)
80100f61:	eb 29                	jmp    80100f8c <filealloc+0x44>
    if(f->ref == 0){
80100f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f66:	8b 40 04             	mov    0x4(%eax),%eax
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	75 1b                	jne    80100f88 <filealloc+0x40>
      f->ref = 1;
80100f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f70:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f77:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100f7e:	e8 d5 3f 00 00       	call   80104f58 <release>
      return f;
80100f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f86:	eb 1f                	jmp    80100fa7 <filealloc+0x5f>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f88:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f8c:	b8 b4 11 11 80       	mov    $0x801111b4,%eax
80100f91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f94:	72 cd                	jb     80100f63 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f96:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100f9d:	e8 b6 3f 00 00       	call   80104f58 <release>
  return 0;
80100fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fa7:	c9                   	leave  
80100fa8:	c3                   	ret    

80100fa9 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fa9:	55                   	push   %ebp
80100faa:	89 e5                	mov    %esp,%ebp
80100fac:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100faf:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100fb6:	e8 3c 3f 00 00       	call   80104ef7 <acquire>
  if(f->ref < 1)
80100fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbe:	8b 40 04             	mov    0x4(%eax),%eax
80100fc1:	85 c0                	test   %eax,%eax
80100fc3:	7f 0c                	jg     80100fd1 <filedup+0x28>
    panic("filedup");
80100fc5:	c7 04 24 49 85 10 80 	movl   $0x80108549,(%esp)
80100fcc:	e8 6c f5 ff ff       	call   8010053d <panic>
  f->ref++;
80100fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd4:	8b 40 04             	mov    0x4(%eax),%eax
80100fd7:	8d 50 01             	lea    0x1(%eax),%edx
80100fda:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdd:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe0:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100fe7:	e8 6c 3f 00 00       	call   80104f58 <release>
  return f;
80100fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fef:	c9                   	leave  
80100ff0:	c3                   	ret    

80100ff1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ff1:	55                   	push   %ebp
80100ff2:	89 e5                	mov    %esp,%ebp
80100ff4:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100ff7:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80100ffe:	e8 f4 3e 00 00       	call   80104ef7 <acquire>
  if(f->ref < 1)
80101003:	8b 45 08             	mov    0x8(%ebp),%eax
80101006:	8b 40 04             	mov    0x4(%eax),%eax
80101009:	85 c0                	test   %eax,%eax
8010100b:	7f 0c                	jg     80101019 <fileclose+0x28>
    panic("fileclose");
8010100d:	c7 04 24 51 85 10 80 	movl   $0x80108551,(%esp)
80101014:	e8 24 f5 ff ff       	call   8010053d <panic>
  if(--f->ref > 0){
80101019:	8b 45 08             	mov    0x8(%ebp),%eax
8010101c:	8b 40 04             	mov    0x4(%eax),%eax
8010101f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	89 50 04             	mov    %edx,0x4(%eax)
80101028:	8b 45 08             	mov    0x8(%ebp),%eax
8010102b:	8b 40 04             	mov    0x4(%eax),%eax
8010102e:	85 c0                	test   %eax,%eax
80101030:	7e 11                	jle    80101043 <fileclose+0x52>
    release(&ftable.lock);
80101032:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101039:	e8 1a 3f 00 00       	call   80104f58 <release>
    return;
8010103e:	e9 82 00 00 00       	jmp    801010c5 <fileclose+0xd4>
  }
  ff = *f;
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	8b 10                	mov    (%eax),%edx
80101048:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010104b:	8b 50 04             	mov    0x4(%eax),%edx
8010104e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101051:	8b 50 08             	mov    0x8(%eax),%edx
80101054:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101057:	8b 50 0c             	mov    0xc(%eax),%edx
8010105a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010105d:	8b 50 10             	mov    0x10(%eax),%edx
80101060:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101063:	8b 40 14             	mov    0x14(%eax),%eax
80101066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101069:	8b 45 08             	mov    0x8(%ebp),%eax
8010106c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010107c:	c7 04 24 20 08 11 80 	movl   $0x80110820,(%esp)
80101083:	e8 d0 3e 00 00       	call   80104f58 <release>
  
  if(ff.type == FD_PIPE)
80101088:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108b:	83 f8 01             	cmp    $0x1,%eax
8010108e:	75 18                	jne    801010a8 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101090:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101094:	0f be d0             	movsbl %al,%edx
80101097:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010109a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010109e:	89 04 24             	mov    %eax,(%esp)
801010a1:	e8 a9 30 00 00       	call   8010414f <pipeclose>
801010a6:	eb 1d                	jmp    801010c5 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ab:	83 f8 02             	cmp    $0x2,%eax
801010ae:	75 15                	jne    801010c5 <fileclose+0xd4>
    begin_op();
801010b0:	e8 41 24 00 00       	call   801034f6 <begin_op>
    iput(ff.ip);
801010b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010b8:	89 04 24             	mov    %eax,(%esp)
801010bb:	e8 fd 09 00 00       	call   80101abd <iput>
    end_op();
801010c0:	e8 b3 24 00 00       	call   80103578 <end_op>
  }
}
801010c5:	c9                   	leave  
801010c6:	c3                   	ret    

801010c7 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c7:	55                   	push   %ebp
801010c8:	89 e5                	mov    %esp,%ebp
801010ca:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010cd:	8b 45 08             	mov    0x8(%ebp),%eax
801010d0:	8b 00                	mov    (%eax),%eax
801010d2:	83 f8 02             	cmp    $0x2,%eax
801010d5:	75 38                	jne    8010110f <filestat+0x48>
    ilock(f->ip);
801010d7:	8b 45 08             	mov    0x8(%ebp),%eax
801010da:	8b 40 10             	mov    0x10(%eax),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 1c 08 00 00       	call   80101901 <ilock>
    stati(f->ip, st);
801010e5:	8b 45 08             	mov    0x8(%ebp),%eax
801010e8:	8b 40 10             	mov    0x10(%eax),%eax
801010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801010ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801010f2:	89 04 24             	mov    %eax,(%esp)
801010f5:	e8 c1 0c 00 00       	call   80101dbb <stati>
    iunlock(f->ip);
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 40 10             	mov    0x10(%eax),%eax
80101100:	89 04 24             	mov    %eax,(%esp)
80101103:	e8 50 09 00 00       	call   80101a58 <iunlock>
    return 0;
80101108:	b8 00 00 00 00       	mov    $0x0,%eax
8010110d:	eb 05                	jmp    80101114 <filestat+0x4d>
  }
  return -1;
8010110f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101114:	c9                   	leave  
80101115:	c3                   	ret    

80101116 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101116:	55                   	push   %ebp
80101117:	89 e5                	mov    %esp,%ebp
80101119:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101123:	84 c0                	test   %al,%al
80101125:	75 0a                	jne    80101131 <fileread+0x1b>
    return -1;
80101127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112c:	e9 9f 00 00 00       	jmp    801011d0 <fileread+0xba>
  if(f->type == FD_PIPE)
80101131:	8b 45 08             	mov    0x8(%ebp),%eax
80101134:	8b 00                	mov    (%eax),%eax
80101136:	83 f8 01             	cmp    $0x1,%eax
80101139:	75 1e                	jne    80101159 <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010113b:	8b 45 08             	mov    0x8(%ebp),%eax
8010113e:	8b 40 0c             	mov    0xc(%eax),%eax
80101141:	8b 55 10             	mov    0x10(%ebp),%edx
80101144:	89 54 24 08          	mov    %edx,0x8(%esp)
80101148:	8b 55 0c             	mov    0xc(%ebp),%edx
8010114b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010114f:	89 04 24             	mov    %eax,(%esp)
80101152:	e8 7a 31 00 00       	call   801042d1 <piperead>
80101157:	eb 77                	jmp    801011d0 <fileread+0xba>
  if(f->type == FD_INODE){
80101159:	8b 45 08             	mov    0x8(%ebp),%eax
8010115c:	8b 00                	mov    (%eax),%eax
8010115e:	83 f8 02             	cmp    $0x2,%eax
80101161:	75 61                	jne    801011c4 <fileread+0xae>
    ilock(f->ip);
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	8b 40 10             	mov    0x10(%eax),%eax
80101169:	89 04 24             	mov    %eax,(%esp)
8010116c:	e8 90 07 00 00       	call   80101901 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101171:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101174:	8b 45 08             	mov    0x8(%ebp),%eax
80101177:	8b 50 14             	mov    0x14(%eax),%edx
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 10             	mov    0x10(%eax),%eax
80101180:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101184:	89 54 24 08          	mov    %edx,0x8(%esp)
80101188:	8b 55 0c             	mov    0xc(%ebp),%edx
8010118b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118f:	89 04 24             	mov    %eax,(%esp)
80101192:	e8 69 0c 00 00       	call   80101e00 <readi>
80101197:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010119a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010119e:	7e 11                	jle    801011b1 <fileread+0x9b>
      f->off += r;
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 50 14             	mov    0x14(%eax),%edx
801011a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011a9:	01 c2                	add    %eax,%edx
801011ab:	8b 45 08             	mov    0x8(%ebp),%eax
801011ae:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011b1:	8b 45 08             	mov    0x8(%ebp),%eax
801011b4:	8b 40 10             	mov    0x10(%eax),%eax
801011b7:	89 04 24             	mov    %eax,(%esp)
801011ba:	e8 99 08 00 00       	call   80101a58 <iunlock>
    return r;
801011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c2:	eb 0c                	jmp    801011d0 <fileread+0xba>
  }
  panic("fileread");
801011c4:	c7 04 24 5b 85 10 80 	movl   $0x8010855b,(%esp)
801011cb:	e8 6d f3 ff ff       	call   8010053d <panic>
}
801011d0:	c9                   	leave  
801011d1:	c3                   	ret    

801011d2 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d2:	55                   	push   %ebp
801011d3:	89 e5                	mov    %esp,%ebp
801011d5:	53                   	push   %ebx
801011d6:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011d9:	8b 45 08             	mov    0x8(%ebp),%eax
801011dc:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011e0:	84 c0                	test   %al,%al
801011e2:	75 0a                	jne    801011ee <filewrite+0x1c>
    return -1;
801011e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011e9:	e9 23 01 00 00       	jmp    80101311 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 00                	mov    (%eax),%eax
801011f3:	83 f8 01             	cmp    $0x1,%eax
801011f6:	75 21                	jne    80101219 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 40 0c             	mov    0xc(%eax),%eax
801011fe:	8b 55 10             	mov    0x10(%ebp),%edx
80101201:	89 54 24 08          	mov    %edx,0x8(%esp)
80101205:	8b 55 0c             	mov    0xc(%ebp),%edx
80101208:	89 54 24 04          	mov    %edx,0x4(%esp)
8010120c:	89 04 24             	mov    %eax,(%esp)
8010120f:	e8 cd 2f 00 00       	call   801041e1 <pipewrite>
80101214:	e9 f8 00 00 00       	jmp    80101311 <filewrite+0x13f>
  if(f->type == FD_INODE){
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 00                	mov    (%eax),%eax
8010121e:	83 f8 02             	cmp    $0x2,%eax
80101221:	0f 85 de 00 00 00    	jne    80101305 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101227:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010122e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(i < n){
80101235:	e9 a8 00 00 00       	jmp    801012e2 <filewrite+0x110>
      int n1 = n - i;
8010123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010123d:	8b 55 10             	mov    0x10(%ebp),%edx
80101240:	89 d1                	mov    %edx,%ecx
80101242:	29 c1                	sub    %eax,%ecx
80101244:	89 c8                	mov    %ecx,%eax
80101246:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(n1 > max)
80101249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010124c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010124f:	7e 06                	jle    80101257 <filewrite+0x85>
        n1 = max;
80101251:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101254:	89 45 f4             	mov    %eax,-0xc(%ebp)

      begin_op();
80101257:	e8 9a 22 00 00       	call   801034f6 <begin_op>
      ilock(f->ip);
8010125c:	8b 45 08             	mov    0x8(%ebp),%eax
8010125f:	8b 40 10             	mov    0x10(%eax),%eax
80101262:	89 04 24             	mov    %eax,(%esp)
80101265:	e8 97 06 00 00       	call   80101901 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010126a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 48 14             	mov    0x14(%eax),%ecx
80101273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101276:	89 c2                	mov    %eax,%edx
80101278:	03 55 0c             	add    0xc(%ebp),%edx
8010127b:	8b 45 08             	mov    0x8(%ebp),%eax
8010127e:	8b 40 10             	mov    0x10(%eax),%eax
80101281:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101285:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101289:	89 54 24 04          	mov    %edx,0x4(%esp)
8010128d:	89 04 24             	mov    %eax,(%esp)
80101290:	e8 d7 0c 00 00       	call   80101f6c <writei>
80101295:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101298:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010129c:	7e 11                	jle    801012af <filewrite+0xdd>
        f->off += r;
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 50 14             	mov    0x14(%eax),%edx
801012a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a7:	01 c2                	add    %eax,%edx
801012a9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ac:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	8b 40 10             	mov    0x10(%eax),%eax
801012b5:	89 04 24             	mov    %eax,(%esp)
801012b8:	e8 9b 07 00 00       	call   80101a58 <iunlock>
      end_op();
801012bd:	e8 b6 22 00 00       	call   80103578 <end_op>

      if(r < 0)
801012c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012c6:	78 28                	js     801012f0 <filewrite+0x11e>
        break;
      if(r != n1)
801012c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801012ce:	74 0c                	je     801012dc <filewrite+0x10a>
        panic("short filewrite");
801012d0:	c7 04 24 64 85 10 80 	movl   $0x80108564,(%esp)
801012d7:	e8 61 f2 ff ff       	call   8010053d <panic>
      i += r;
801012dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012df:	01 45 f0             	add    %eax,-0x10(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e8:	0f 8c 4c ff ff ff    	jl     8010123a <filewrite+0x68>
801012ee:	eb 01                	jmp    801012f1 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801012f0:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012f4:	3b 45 10             	cmp    0x10(%ebp),%eax
801012f7:	75 05                	jne    801012fe <filewrite+0x12c>
801012f9:	8b 45 10             	mov    0x10(%ebp),%eax
801012fc:	eb 05                	jmp    80101303 <filewrite+0x131>
801012fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101303:	eb 0c                	jmp    80101311 <filewrite+0x13f>
  }
  panic("filewrite");
80101305:	c7 04 24 74 85 10 80 	movl   $0x80108574,(%esp)
8010130c:	e8 2c f2 ff ff       	call   8010053d <panic>
}
80101311:	83 c4 24             	add    $0x24,%esp
80101314:	5b                   	pop    %ebx
80101315:	5d                   	pop    %ebp
80101316:	c3                   	ret    
	...

80101318 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101318:	55                   	push   %ebp
80101319:	89 e5                	mov    %esp,%ebp
8010131b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010131e:	8b 45 08             	mov    0x8(%ebp),%eax
80101321:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101328:	00 
80101329:	89 04 24             	mov    %eax,(%esp)
8010132c:	e8 76 ee ff ff       	call   801001a7 <bread>
80101331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101337:	83 c0 18             	add    $0x18,%eax
8010133a:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101341:	00 
80101342:	89 44 24 04          	mov    %eax,0x4(%esp)
80101346:	8b 45 0c             	mov    0xc(%ebp),%eax
80101349:	89 04 24             	mov    %eax,(%esp)
8010134c:	e8 d0 3e 00 00       	call   80105221 <memmove>
  brelse(bp);
80101351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101354:	89 04 24             	mov    %eax,(%esp)
80101357:	e8 bc ee ff ff       	call   80100218 <brelse>
}
8010135c:	c9                   	leave  
8010135d:	c3                   	ret    

8010135e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010135e:	55                   	push   %ebp
8010135f:	89 e5                	mov    %esp,%ebp
80101361:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101364:	8b 55 0c             	mov    0xc(%ebp),%edx
80101367:	8b 45 08             	mov    0x8(%ebp),%eax
8010136a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010136e:	89 04 24             	mov    %eax,(%esp)
80101371:	e8 31 ee ff ff       	call   801001a7 <bread>
80101376:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137c:	83 c0 18             	add    $0x18,%eax
8010137f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101386:	00 
80101387:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010138e:	00 
8010138f:	89 04 24             	mov    %eax,(%esp)
80101392:	e8 b7 3d 00 00       	call   8010514e <memset>
  log_write(bp);
80101397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139a:	89 04 24             	mov    %eax,(%esp)
8010139d:	e8 5a 23 00 00       	call   801036fc <log_write>
  brelse(bp);
801013a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a5:	89 04 24             	mov    %eax,(%esp)
801013a8:	e8 6b ee ff ff       	call   80100218 <brelse>
}
801013ad:	c9                   	leave  
801013ae:	c3                   	ret    

801013af <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013af:	55                   	push   %ebp
801013b0:	89 e5                	mov    %esp,%ebp
801013b2:	53                   	push   %ebx
801013b3:	83 ec 24             	sub    $0x24,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801013c4:	e9 16 01 00 00       	jmp    801014df <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
801013c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013cc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013d2:	85 c0                	test   %eax,%eax
801013d4:	0f 48 c2             	cmovs  %edx,%eax
801013d7:	c1 f8 0c             	sar    $0xc,%eax
801013da:	89 c2                	mov    %eax,%edx
801013dc:	a1 38 12 11 80       	mov    0x80111238,%eax
801013e1:	8d 04 02             	lea    (%edx,%eax,1),%eax
801013e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e8:	8b 45 08             	mov    0x8(%ebp),%eax
801013eb:	89 04 24             	mov    %eax,(%esp)
801013ee:	e8 b4 ed ff ff       	call   801001a7 <bread>
801013f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801013fd:	e9 aa 00 00 00       	jmp    801014ac <balloc+0xfd>
      m = 1 << (bi % 8);
80101402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101405:	89 c2                	mov    %eax,%edx
80101407:	c1 fa 1f             	sar    $0x1f,%edx
8010140a:	c1 ea 1d             	shr    $0x1d,%edx
8010140d:	01 d0                	add    %edx,%eax
8010140f:	83 e0 07             	and    $0x7,%eax
80101412:	29 d0                	sub    %edx,%eax
80101414:	ba 01 00 00 00       	mov    $0x1,%edx
80101419:	89 d3                	mov    %edx,%ebx
8010141b:	89 c1                	mov    %eax,%ecx
8010141d:	d3 e3                	shl    %cl,%ebx
8010141f:	89 d8                	mov    %ebx,%eax
80101421:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101424:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101427:	8d 50 07             	lea    0x7(%eax),%edx
8010142a:	85 c0                	test   %eax,%eax
8010142c:	0f 48 c2             	cmovs  %edx,%eax
8010142f:	c1 f8 03             	sar    $0x3,%eax
80101432:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101435:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010143a:	0f b6 c0             	movzbl %al,%eax
8010143d:	23 45 f0             	and    -0x10(%ebp),%eax
80101440:	85 c0                	test   %eax,%eax
80101442:	75 64                	jne    801014a8 <balloc+0xf9>
        bp->data[bi/8] |= m;  // Mark block in use.
80101444:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101447:	8d 50 07             	lea    0x7(%eax),%edx
8010144a:	85 c0                	test   %eax,%eax
8010144c:	0f 48 c2             	cmovs  %edx,%eax
8010144f:	c1 f8 03             	sar    $0x3,%eax
80101452:	89 c2                	mov    %eax,%edx
80101454:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80101457:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
8010145c:	89 c1                	mov    %eax,%ecx
8010145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101461:	09 c8                	or     %ecx,%eax
80101463:	89 c1                	mov    %eax,%ecx
80101465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101468:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
        log_write(bp);
8010146c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010146f:	89 04 24             	mov    %eax,(%esp)
80101472:	e8 85 22 00 00       	call   801036fc <log_write>
        brelse(bp);
80101477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147a:	89 04 24             	mov    %eax,(%esp)
8010147d:	e8 96 ed ff ff       	call   80100218 <brelse>
        bzero(dev, b + bi);
80101482:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101485:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101488:	01 c2                	add    %eax,%edx
8010148a:	8b 45 08             	mov    0x8(%ebp),%eax
8010148d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101491:	89 04 24             	mov    %eax,(%esp)
80101494:	e8 c5 fe ff ff       	call   8010135e <bzero>
        return b + bi;
80101499:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010149f:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014a2:	83 c4 24             	add    $0x24,%esp
801014a5:	5b                   	pop    %ebx
801014a6:	5d                   	pop    %ebp
801014a7:	c3                   	ret    
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801014ac:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801014b3:	7f 18                	jg     801014cd <balloc+0x11e>
801014b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014bb:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014be:	89 c2                	mov    %eax,%edx
801014c0:	a1 20 12 11 80       	mov    0x80111220,%eax
801014c5:	39 c2                	cmp    %eax,%edx
801014c7:	0f 82 35 ff ff ff    	jb     80101402 <balloc+0x53>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d0:	89 04 24             	mov    %eax,(%esp)
801014d3:	e8 40 ed ff ff       	call   80100218 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801014d8:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
801014df:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e2:	a1 20 12 11 80       	mov    0x80111220,%eax
801014e7:	39 c2                	cmp    %eax,%edx
801014e9:	0f 82 da fe ff ff    	jb     801013c9 <balloc+0x1a>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ef:	c7 04 24 80 85 10 80 	movl   $0x80108580,(%esp)
801014f6:	e8 42 f0 ff ff       	call   8010053d <panic>

801014fb <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014fb:	55                   	push   %ebp
801014fc:	89 e5                	mov    %esp,%ebp
801014fe:	53                   	push   %ebx
801014ff:	83 ec 24             	sub    $0x24,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101502:	c7 44 24 04 20 12 11 	movl   $0x80111220,0x4(%esp)
80101509:	80 
8010150a:	8b 45 08             	mov    0x8(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 03 fe ff ff       	call   80101318 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101515:	8b 45 0c             	mov    0xc(%ebp),%eax
80101518:	89 c2                	mov    %eax,%edx
8010151a:	c1 ea 0c             	shr    $0xc,%edx
8010151d:	a1 38 12 11 80       	mov    0x80111238,%eax
80101522:	01 c2                	add    %eax,%edx
80101524:	8b 45 08             	mov    0x8(%ebp),%eax
80101527:	89 54 24 04          	mov    %edx,0x4(%esp)
8010152b:	89 04 24             	mov    %eax,(%esp)
8010152e:	e8 74 ec ff ff       	call   801001a7 <bread>
80101533:	89 45 ec             	mov    %eax,-0x14(%ebp)
  bi = b % BPB;
80101536:	8b 45 0c             	mov    0xc(%ebp),%eax
80101539:	25 ff 0f 00 00       	and    $0xfff,%eax
8010153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101544:	89 c2                	mov    %eax,%edx
80101546:	c1 fa 1f             	sar    $0x1f,%edx
80101549:	c1 ea 1d             	shr    $0x1d,%edx
8010154c:	01 d0                	add    %edx,%eax
8010154e:	83 e0 07             	and    $0x7,%eax
80101551:	29 d0                	sub    %edx,%eax
80101553:	ba 01 00 00 00       	mov    $0x1,%edx
80101558:	89 d3                	mov    %edx,%ebx
8010155a:	89 c1                	mov    %eax,%ecx
8010155c:	d3 e3                	shl    %cl,%ebx
8010155e:	89 d8                	mov    %ebx,%eax
80101560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101563:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101566:	8d 50 07             	lea    0x7(%eax),%edx
80101569:	85 c0                	test   %eax,%eax
8010156b:	0f 48 c2             	cmovs  %edx,%eax
8010156e:	c1 f8 03             	sar    $0x3,%eax
80101571:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101574:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101579:	0f b6 c0             	movzbl %al,%eax
8010157c:	23 45 f4             	and    -0xc(%ebp),%eax
8010157f:	85 c0                	test   %eax,%eax
80101581:	75 0c                	jne    8010158f <bfree+0x94>
    panic("freeing free block");
80101583:	c7 04 24 96 85 10 80 	movl   $0x80108596,(%esp)
8010158a:	e8 ae ef ff ff       	call   8010053d <panic>
  bp->data[bi/8] &= ~m;
8010158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101592:	8d 50 07             	lea    0x7(%eax),%edx
80101595:	85 c0                	test   %eax,%eax
80101597:	0f 48 c2             	cmovs  %edx,%eax
8010159a:	c1 f8 03             	sar    $0x3,%eax
8010159d:	89 c2                	mov    %eax,%edx
8010159f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015a2:	0f b6 44 01 18       	movzbl 0x18(%ecx,%eax,1),%eax
801015a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801015aa:	f7 d1                	not    %ecx
801015ac:	21 c8                	and    %ecx,%eax
801015ae:	89 c1                	mov    %eax,%ecx
801015b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015b3:	88 4c 10 18          	mov    %cl,0x18(%eax,%edx,1)
  log_write(bp);
801015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ba:	89 04 24             	mov    %eax,(%esp)
801015bd:	e8 3a 21 00 00       	call   801036fc <log_write>
  brelse(bp);
801015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015c5:	89 04 24             	mov    %eax,(%esp)
801015c8:	e8 4b ec ff ff       	call   80100218 <brelse>
}
801015cd:	83 c4 24             	add    $0x24,%esp
801015d0:	5b                   	pop    %ebx
801015d1:	5d                   	pop    %ebp
801015d2:	c3                   	ret    

801015d3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015d3:	55                   	push   %ebp
801015d4:	89 e5                	mov    %esp,%ebp
801015d6:	57                   	push   %edi
801015d7:	56                   	push   %esi
801015d8:	53                   	push   %ebx
801015d9:	83 ec 4c             	sub    $0x4c,%esp
  initlock(&icache.lock, "icache");
801015dc:	c7 44 24 04 a9 85 10 	movl   $0x801085a9,0x4(%esp)
801015e3:	80 
801015e4:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801015eb:	e8 e6 38 00 00       	call   80104ed6 <initlock>
  readsb(dev, &sb);
801015f0:	c7 44 24 04 20 12 11 	movl   $0x80111220,0x4(%esp)
801015f7:	80 
801015f8:	8b 45 08             	mov    0x8(%ebp),%eax
801015fb:	89 04 24             	mov    %eax,(%esp)
801015fe:	e8 15 fd ff ff       	call   80101318 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101603:	a1 38 12 11 80       	mov    0x80111238,%eax
80101608:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010160b:	8b 3d 34 12 11 80    	mov    0x80111234,%edi
80101611:	8b 35 30 12 11 80    	mov    0x80111230,%esi
80101617:	8b 1d 2c 12 11 80    	mov    0x8011122c,%ebx
8010161d:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80101623:	8b 15 24 12 11 80    	mov    0x80111224,%edx
80101629:	a1 20 12 11 80       	mov    0x80111220,%eax
8010162e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101634:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101638:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010163c:	89 74 24 14          	mov    %esi,0x14(%esp)
80101640:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101644:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101648:	89 54 24 08          	mov    %edx,0x8(%esp)
8010164c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010164f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101653:	c7 04 24 b0 85 10 80 	movl   $0x801085b0,(%esp)
8010165a:	e8 3e ed ff ff       	call   8010039d <cprintf>
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010165f:	83 c4 4c             	add    $0x4c,%esp
80101662:	5b                   	pop    %ebx
80101663:	5e                   	pop    %esi
80101664:	5f                   	pop    %edi
80101665:	5d                   	pop    %ebp
80101666:	c3                   	ret    

80101667 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101667:	55                   	push   %ebp
80101668:	89 e5                	mov    %esp,%ebp
8010166a:	83 ec 38             	sub    $0x38,%esp
8010166d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101670:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101674:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010167b:	e9 9f 00 00 00       	jmp    8010171f <ialloc+0xb8>
    bp = bread(dev, IBLOCK(inum, sb));
80101680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101683:	89 c2                	mov    %eax,%edx
80101685:	c1 ea 03             	shr    $0x3,%edx
80101688:	a1 34 12 11 80       	mov    0x80111234,%eax
8010168d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101690:	89 44 24 04          	mov    %eax,0x4(%esp)
80101694:	8b 45 08             	mov    0x8(%ebp),%eax
80101697:	89 04 24             	mov    %eax,(%esp)
8010169a:	e8 08 eb ff ff       	call   801001a7 <bread>
8010169f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a5:	83 c0 18             	add    $0x18,%eax
801016a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016ab:	83 e2 07             	and    $0x7,%edx
801016ae:	c1 e2 06             	shl    $0x6,%edx
801016b1:	01 d0                	add    %edx,%eax
801016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(dip->type == 0){  // a free inode
801016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b9:	0f b7 00             	movzwl (%eax),%eax
801016bc:	66 85 c0             	test   %ax,%ax
801016bf:	75 4f                	jne    80101710 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801016c1:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016c8:	00 
801016c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801016d0:	00 
801016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d4:	89 04 24             	mov    %eax,(%esp)
801016d7:	e8 72 3a 00 00       	call   8010514e <memset>
      dip->type = type;
801016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016df:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016e3:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e9:	89 04 24             	mov    %eax,(%esp)
801016ec:	e8 0b 20 00 00       	call   801036fc <log_write>
      brelse(bp);
801016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f4:	89 04 24             	mov    %eax,(%esp)
801016f7:	e8 1c eb ff ff       	call   80100218 <brelse>
      return iget(dev, inum);
801016fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80101703:	8b 45 08             	mov    0x8(%ebp),%eax
80101706:	89 04 24             	mov    %eax,(%esp)
80101709:	e8 ee 00 00 00       	call   801017fc <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
8010170e:	c9                   	leave  
8010170f:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	89 04 24             	mov    %eax,(%esp)
80101716:	e8 fd ea ff ff       	call   80100218 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010171b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010171f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101722:	a1 28 12 11 80       	mov    0x80111228,%eax
80101727:	39 c2                	cmp    %eax,%edx
80101729:	0f 82 51 ff ff ff    	jb     80101680 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010172f:	c7 04 24 03 86 10 80 	movl   $0x80108603,(%esp)
80101736:	e8 02 ee ff ff       	call   8010053d <panic>

8010173b <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010173b:	55                   	push   %ebp
8010173c:	89 e5                	mov    %esp,%ebp
8010173e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101741:	8b 45 08             	mov    0x8(%ebp),%eax
80101744:	8b 40 04             	mov    0x4(%eax),%eax
80101747:	89 c2                	mov    %eax,%edx
80101749:	c1 ea 03             	shr    $0x3,%edx
8010174c:	a1 34 12 11 80       	mov    0x80111234,%eax
80101751:	01 c2                	add    %eax,%edx
80101753:	8b 45 08             	mov    0x8(%ebp),%eax
80101756:	8b 00                	mov    (%eax),%eax
80101758:	89 54 24 04          	mov    %edx,0x4(%esp)
8010175c:	89 04 24             	mov    %eax,(%esp)
8010175f:	e8 43 ea ff ff       	call   801001a7 <bread>
80101764:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176a:	83 c0 18             	add    $0x18,%eax
8010176d:	89 c2                	mov    %eax,%edx
8010176f:	8b 45 08             	mov    0x8(%ebp),%eax
80101772:	8b 40 04             	mov    0x4(%eax),%eax
80101775:	83 e0 07             	and    $0x7,%eax
80101778:	c1 e0 06             	shl    $0x6,%eax
8010177b:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip->type = ip->type;
80101781:	8b 45 08             	mov    0x8(%ebp),%eax
80101784:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178b:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010178e:	8b 45 08             	mov    0x8(%ebp),%eax
80101791:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101798:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010179c:	8b 45 08             	mov    0x8(%ebp),%eax
8010179f:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017aa:	8b 45 08             	mov    0x8(%ebp),%eax
801017ad:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b4:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017b8:	8b 45 08             	mov    0x8(%ebp),%eax
801017bb:	8b 50 18             	mov    0x18(%eax),%edx
801017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c1:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c4:	8b 45 08             	mov    0x8(%ebp),%eax
801017c7:	8d 50 1c             	lea    0x1c(%eax),%edx
801017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cd:	83 c0 0c             	add    $0xc,%eax
801017d0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801017d7:	00 
801017d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801017dc:	89 04 24             	mov    %eax,(%esp)
801017df:	e8 3d 3a 00 00       	call   80105221 <memmove>
  log_write(bp);
801017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e7:	89 04 24             	mov    %eax,(%esp)
801017ea:	e8 0d 1f 00 00       	call   801036fc <log_write>
  brelse(bp);
801017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f2:	89 04 24             	mov    %eax,(%esp)
801017f5:	e8 1e ea ff ff       	call   80100218 <brelse>
}
801017fa:	c9                   	leave  
801017fb:	c3                   	ret    

801017fc <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017fc:	55                   	push   %ebp
801017fd:	89 e5                	mov    %esp,%ebp
801017ff:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101802:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101809:	e8 e9 36 00 00       	call   80104ef7 <acquire>

  // Is the inode already cached?
  empty = 0;
8010180e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101815:	c7 45 f0 74 12 11 80 	movl   $0x80111274,-0x10(%ebp)
8010181c:	eb 59                	jmp    80101877 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101821:	8b 40 08             	mov    0x8(%eax),%eax
80101824:	85 c0                	test   %eax,%eax
80101826:	7e 35                	jle    8010185d <iget+0x61>
80101828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182b:	8b 00                	mov    (%eax),%eax
8010182d:	3b 45 08             	cmp    0x8(%ebp),%eax
80101830:	75 2b                	jne    8010185d <iget+0x61>
80101832:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101835:	8b 40 04             	mov    0x4(%eax),%eax
80101838:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010183b:	75 20                	jne    8010185d <iget+0x61>
      ip->ref++;
8010183d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101840:	8b 40 08             	mov    0x8(%eax),%eax
80101843:	8d 50 01             	lea    0x1(%eax),%edx
80101846:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101849:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010184c:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101853:	e8 00 37 00 00       	call   80104f58 <release>
      return ip;
80101858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185b:	eb 70                	jmp    801018cd <iget+0xd1>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010185d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101861:	75 10                	jne    80101873 <iget+0x77>
80101863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101866:	8b 40 08             	mov    0x8(%eax),%eax
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 06                	jne    80101873 <iget+0x77>
      empty = ip;
8010186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101870:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101873:	83 45 f0 50          	addl   $0x50,-0x10(%ebp)
80101877:	b8 14 22 11 80       	mov    $0x80112214,%eax
8010187c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010187f:	72 9d                	jb     8010181e <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101885:	75 0c                	jne    80101893 <iget+0x97>
    panic("iget: no inodes");
80101887:	c7 04 24 15 86 10 80 	movl   $0x80108615,(%esp)
8010188e:	e8 aa ec ff ff       	call   8010053d <panic>

  ip = empty;
80101893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ip->dev = dev;
80101899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189c:	8b 55 08             	mov    0x8(%ebp),%edx
8010189f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801018a7:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ad:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018be:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801018c5:	e8 8e 36 00 00       	call   80104f58 <release>

  return ip;
801018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801018cd:	c9                   	leave  
801018ce:	c3                   	ret    

801018cf <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018cf:	55                   	push   %ebp
801018d0:	89 e5                	mov    %esp,%ebp
801018d2:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801018d5:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801018dc:	e8 16 36 00 00       	call   80104ef7 <acquire>
  ip->ref++;
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	8b 40 08             	mov    0x8(%eax),%eax
801018e7:	8d 50 01             	lea    0x1(%eax),%edx
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018f0:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
801018f7:	e8 5c 36 00 00       	call   80104f58 <release>
  return ip;
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018ff:	c9                   	leave  
80101900:	c3                   	ret    

80101901 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101901:	55                   	push   %ebp
80101902:	89 e5                	mov    %esp,%ebp
80101904:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010190b:	74 0a                	je     80101917 <ilock+0x16>
8010190d:	8b 45 08             	mov    0x8(%ebp),%eax
80101910:	8b 40 08             	mov    0x8(%eax),%eax
80101913:	85 c0                	test   %eax,%eax
80101915:	7f 0c                	jg     80101923 <ilock+0x22>
    panic("ilock");
80101917:	c7 04 24 25 86 10 80 	movl   $0x80108625,(%esp)
8010191e:	e8 1a ec ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80101923:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
8010192a:	e8 c8 35 00 00       	call   80104ef7 <acquire>
  while(ip->flags & I_BUSY)
8010192f:	eb 13                	jmp    80101944 <ilock+0x43>
    sleep(ip, &icache.lock);
80101931:	c7 44 24 04 40 12 11 	movl   $0x80111240,0x4(%esp)
80101938:	80 
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	89 04 24             	mov    %eax,(%esp)
8010193f:	e8 e2 32 00 00       	call   80104c26 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101944:	8b 45 08             	mov    0x8(%ebp),%eax
80101947:	8b 40 0c             	mov    0xc(%eax),%eax
8010194a:	83 e0 01             	and    $0x1,%eax
8010194d:	84 c0                	test   %al,%al
8010194f:	75 e0                	jne    80101931 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	8b 40 0c             	mov    0xc(%eax),%eax
80101957:	89 c2                	mov    %eax,%edx
80101959:	83 ca 01             	or     $0x1,%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101962:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101969:	e8 ea 35 00 00       	call   80104f58 <release>

  if(!(ip->flags & I_VALID)){
8010196e:	8b 45 08             	mov    0x8(%ebp),%eax
80101971:	8b 40 0c             	mov    0xc(%eax),%eax
80101974:	83 e0 02             	and    $0x2,%eax
80101977:	85 c0                	test   %eax,%eax
80101979:	0f 85 d7 00 00 00    	jne    80101a56 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	8b 40 04             	mov    0x4(%eax),%eax
80101985:	89 c2                	mov    %eax,%edx
80101987:	c1 ea 03             	shr    $0x3,%edx
8010198a:	a1 34 12 11 80       	mov    0x80111234,%eax
8010198f:	01 c2                	add    %eax,%edx
80101991:	8b 45 08             	mov    0x8(%ebp),%eax
80101994:	8b 00                	mov    (%eax),%eax
80101996:	89 54 24 04          	mov    %edx,0x4(%esp)
8010199a:	89 04 24             	mov    %eax,(%esp)
8010199d:	e8 05 e8 ff ff       	call   801001a7 <bread>
801019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a8:	83 c0 18             	add    $0x18,%eax
801019ab:	89 c2                	mov    %eax,%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 40 04             	mov    0x4(%eax),%eax
801019b3:	83 e0 07             	and    $0x7,%eax
801019b6:	c1 e0 06             	shl    $0x6,%eax
801019b9:	8d 04 02             	lea    (%edx,%eax,1),%eax
801019bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ip->type = dip->type;
801019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c2:	0f b7 10             	movzwl (%eax),%edx
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cf:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019d3:	8b 45 08             	mov    0x8(%ebp),%eax
801019d6:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
801019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dd:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019eb:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f9:	8b 50 08             	mov    0x8(%eax),%edx
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a05:	8d 50 0c             	lea    0xc(%eax),%edx
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	83 c0 1c             	add    $0x1c,%eax
80101a0e:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a15:	00 
80101a16:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a1a:	89 04 24             	mov    %eax,(%esp)
80101a1d:	e8 ff 37 00 00       	call   80105221 <memmove>
    brelse(bp);
80101a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 eb e7 ff ff       	call   80100218 <brelse>
    ip->flags |= I_VALID;
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 0c             	mov    0xc(%eax),%eax
80101a33:	89 c2                	mov    %eax,%edx
80101a35:	83 ca 02             	or     $0x2,%edx
80101a38:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3b:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a41:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a45:	66 85 c0             	test   %ax,%ax
80101a48:	75 0c                	jne    80101a56 <ilock+0x155>
      panic("ilock: no type");
80101a4a:	c7 04 24 2b 86 10 80 	movl   $0x8010862b,(%esp)
80101a51:	e8 e7 ea ff ff       	call   8010053d <panic>
  }
}
80101a56:	c9                   	leave  
80101a57:	c3                   	ret    

80101a58 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a58:	55                   	push   %ebp
80101a59:	89 e5                	mov    %esp,%ebp
80101a5b:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a62:	74 17                	je     80101a7b <iunlock+0x23>
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6a:	83 e0 01             	and    $0x1,%eax
80101a6d:	85 c0                	test   %eax,%eax
80101a6f:	74 0a                	je     80101a7b <iunlock+0x23>
80101a71:	8b 45 08             	mov    0x8(%ebp),%eax
80101a74:	8b 40 08             	mov    0x8(%eax),%eax
80101a77:	85 c0                	test   %eax,%eax
80101a79:	7f 0c                	jg     80101a87 <iunlock+0x2f>
    panic("iunlock");
80101a7b:	c7 04 24 3a 86 10 80 	movl   $0x8010863a,(%esp)
80101a82:	e8 b6 ea ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
80101a87:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101a8e:	e8 64 34 00 00       	call   80104ef7 <acquire>
  ip->flags &= ~I_BUSY;
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	8b 40 0c             	mov    0xc(%eax),%eax
80101a99:	89 c2                	mov    %eax,%edx
80101a9b:	83 e2 fe             	and    $0xfffffffe,%edx
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa7:	89 04 24             	mov    %eax,(%esp)
80101aaa:	e8 51 32 00 00       	call   80104d00 <wakeup>
  release(&icache.lock);
80101aaf:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101ab6:	e8 9d 34 00 00       	call   80104f58 <release>
}
80101abb:	c9                   	leave  
80101abc:	c3                   	ret    

80101abd <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101abd:	55                   	push   %ebp
80101abe:	89 e5                	mov    %esp,%ebp
80101ac0:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ac3:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101aca:	e8 28 34 00 00       	call   80104ef7 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	8b 40 08             	mov    0x8(%eax),%eax
80101ad5:	83 f8 01             	cmp    $0x1,%eax
80101ad8:	0f 85 93 00 00 00    	jne    80101b71 <iput+0xb4>
80101ade:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae1:	8b 40 0c             	mov    0xc(%eax),%eax
80101ae4:	83 e0 02             	and    $0x2,%eax
80101ae7:	85 c0                	test   %eax,%eax
80101ae9:	0f 84 82 00 00 00    	je     80101b71 <iput+0xb4>
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101af6:	66 85 c0             	test   %ax,%ax
80101af9:	75 76                	jne    80101b71 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101afb:	8b 45 08             	mov    0x8(%ebp),%eax
80101afe:	8b 40 0c             	mov    0xc(%eax),%eax
80101b01:	83 e0 01             	and    $0x1,%eax
80101b04:	84 c0                	test   %al,%al
80101b06:	74 0c                	je     80101b14 <iput+0x57>
      panic("iput busy");
80101b08:	c7 04 24 42 86 10 80 	movl   $0x80108642,(%esp)
80101b0f:	e8 29 ea ff ff       	call   8010053d <panic>
    ip->flags |= I_BUSY;
80101b14:	8b 45 08             	mov    0x8(%ebp),%eax
80101b17:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1a:	89 c2                	mov    %eax,%edx
80101b1c:	83 ca 01             	or     $0x1,%edx
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b25:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101b2c:	e8 27 34 00 00       	call   80104f58 <release>
    itrunc(ip);
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	89 04 24             	mov    %eax,(%esp)
80101b37:	e8 72 01 00 00       	call   80101cae <itrunc>
    ip->type = 0;
80101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3f:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b45:	8b 45 08             	mov    0x8(%ebp),%eax
80101b48:	89 04 24             	mov    %eax,(%esp)
80101b4b:	e8 eb fb ff ff       	call   8010173b <iupdate>
    acquire(&icache.lock);
80101b50:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101b57:	e8 9b 33 00 00       	call   80104ef7 <acquire>
    ip->flags = 0;
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b66:	8b 45 08             	mov    0x8(%ebp),%eax
80101b69:	89 04 24             	mov    %eax,(%esp)
80101b6c:	e8 8f 31 00 00       	call   80104d00 <wakeup>
  }
  ip->ref--;
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	8b 40 08             	mov    0x8(%eax),%eax
80101b77:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b80:	c7 04 24 40 12 11 80 	movl   $0x80111240,(%esp)
80101b87:	e8 cc 33 00 00       	call   80104f58 <release>
}
80101b8c:	c9                   	leave  
80101b8d:	c3                   	ret    

80101b8e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b8e:	55                   	push   %ebp
80101b8f:	89 e5                	mov    %esp,%ebp
80101b91:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b94:	8b 45 08             	mov    0x8(%ebp),%eax
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 b9 fe ff ff       	call   80101a58 <iunlock>
  iput(ip);
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	89 04 24             	mov    %eax,(%esp)
80101ba5:	e8 13 ff ff ff       	call   80101abd <iput>
}
80101baa:	c9                   	leave  
80101bab:	c3                   	ret    

80101bac <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bac:	55                   	push   %ebp
80101bad:	89 e5                	mov    %esp,%ebp
80101baf:	53                   	push   %ebx
80101bb0:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bb3:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bb7:	77 3e                	ja     80101bf7 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbf:	83 c2 04             	add    $0x4,%edx
80101bc2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101bc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101bcd:	75 20                	jne    80101bef <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd5:	8b 00                	mov    (%eax),%eax
80101bd7:	89 04 24             	mov    %eax,(%esp)
80101bda:	e8 d0 f7 ff ff       	call   801013af <balloc>
80101bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	8d 4b 04             	lea    0x4(%ebx),%ecx
80101be8:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101beb:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bf2:	e9 b1 00 00 00       	jmp    80101ca8 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101bf7:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bfb:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bff:	0f 87 97 00 00 00    	ja     80101c9c <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101c12:	75 19                	jne    80101c2d <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c14:	8b 45 08             	mov    0x8(%ebp),%eax
80101c17:	8b 00                	mov    (%eax),%eax
80101c19:	89 04 24             	mov    %eax,(%esp)
80101c1c:	e8 8e f7 ff ff       	call   801013af <balloc>
80101c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c24:	8b 45 08             	mov    0x8(%ebp),%eax
80101c27:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101c2a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	8b 00                	mov    (%eax),%eax
80101c32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101c35:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c39:	89 04 24             	mov    %eax,(%esp)
80101c3c:	e8 66 e5 ff ff       	call   801001a7 <bread>
80101c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a = (uint*)bp->data;
80101c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c47:	83 c0 18             	add    $0x18,%eax
80101c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((addr = a[bn]) == 0){
80101c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c50:	c1 e0 02             	shl    $0x2,%eax
80101c53:	03 45 f0             	add    -0x10(%ebp),%eax
80101c56:	8b 00                	mov    (%eax),%eax
80101c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80101c5f:	75 2b                	jne    80101c8c <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101c61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c64:	c1 e0 02             	shl    $0x2,%eax
80101c67:	89 c3                	mov    %eax,%ebx
80101c69:	03 5d f0             	add    -0x10(%ebp),%ebx
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	8b 00                	mov    (%eax),%eax
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 36 f7 ff ff       	call   801013af <balloc>
80101c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80101c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c7f:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c84:	89 04 24             	mov    %eax,(%esp)
80101c87:	e8 70 1a 00 00       	call   801036fc <log_write>
    }
    brelse(bp);
80101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c8f:	89 04 24             	mov    %eax,(%esp)
80101c92:	e8 81 e5 ff ff       	call   80100218 <brelse>
    return addr;
80101c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9a:	eb 0c                	jmp    80101ca8 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101c9c:	c7 04 24 4c 86 10 80 	movl   $0x8010864c,(%esp)
80101ca3:	e8 95 e8 ff ff       	call   8010053d <panic>
}
80101ca8:	83 c4 24             	add    $0x24,%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5d                   	pop    %ebp
80101cad:	c3                   	ret    

80101cae <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cae:	55                   	push   %ebp
80101caf:	89 e5                	mov    %esp,%ebp
80101cb1:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cb4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80101cbb:	eb 44                	jmp    80101d01 <itrunc+0x53>
    if(ip->addrs[i]){
80101cbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	83 c2 04             	add    $0x4,%edx
80101cc6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cca:	85 c0                	test   %eax,%eax
80101ccc:	74 2f                	je     80101cfd <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cce:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd4:	83 c2 04             	add    $0x4,%edx
80101cd7:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	8b 00                	mov    (%eax),%eax
80101ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce4:	89 04 24             	mov    %eax,(%esp)
80101ce7:	e8 0f f8 ff ff       	call   801014fb <bfree>
      ip->addrs[i] = 0;
80101cec:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101cef:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf2:	83 c2 04             	add    $0x4,%edx
80101cf5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cfc:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cfd:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80101d01:	83 7d e8 0b          	cmpl   $0xb,-0x18(%ebp)
80101d05:	7e b6                	jle    80101cbd <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d07:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	0f 84 8f 00 00 00    	je     80101da4 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d15:	8b 45 08             	mov    0x8(%ebp),%eax
80101d18:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1e:	8b 00                	mov    (%eax),%eax
80101d20:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d24:	89 04 24             	mov    %eax,(%esp)
80101d27:	e8 7b e4 ff ff       	call   801001a7 <bread>
80101d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d32:	83 c0 18             	add    $0x18,%eax
80101d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101d3f:	eb 2f                	jmp    80101d70 <itrunc+0xc2>
      if(a[j])
80101d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d44:	c1 e0 02             	shl    $0x2,%eax
80101d47:	03 45 f4             	add    -0xc(%ebp),%eax
80101d4a:	8b 00                	mov    (%eax),%eax
80101d4c:	85 c0                	test   %eax,%eax
80101d4e:	74 1c                	je     80101d6c <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d53:	c1 e0 02             	shl    $0x2,%eax
80101d56:	03 45 f4             	add    -0xc(%ebp),%eax
80101d59:	8b 10                	mov    (%eax),%edx
80101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5e:	8b 00                	mov    (%eax),%eax
80101d60:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d64:	89 04 24             	mov    %eax,(%esp)
80101d67:	e8 8f f7 ff ff       	call   801014fb <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d6c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d73:	83 f8 7f             	cmp    $0x7f,%eax
80101d76:	76 c9                	jbe    80101d41 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d7b:	89 04 24             	mov    %eax,(%esp)
80101d7e:	e8 95 e4 ff ff       	call   80100218 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	8b 00                	mov    (%eax),%eax
80101d8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d92:	89 04 24             	mov    %eax,(%esp)
80101d95:	e8 61 f7 ff ff       	call   801014fb <bfree>
    ip->addrs[NDIRECT] = 0;
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101dae:	8b 45 08             	mov    0x8(%ebp),%eax
80101db1:	89 04 24             	mov    %eax,(%esp)
80101db4:	e8 82 f9 ff ff       	call   8010173b <iupdate>
}
80101db9:	c9                   	leave  
80101dba:	c3                   	ret    

80101dbb <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101dbb:	55                   	push   %ebp
80101dbc:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 00                	mov    (%eax),%eax
80101dc3:	89 c2                	mov    %eax,%edx
80101dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc8:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dce:	8b 50 04             	mov    0x4(%eax),%edx
80101dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dd4:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dda:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de1:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dee:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101df2:	8b 45 08             	mov    0x8(%ebp),%eax
80101df5:	8b 50 18             	mov    0x18(%eax),%edx
80101df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dfb:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    

80101e00 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	53                   	push   %ebx
80101e04:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e07:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e0e:	66 83 f8 03          	cmp    $0x3,%ax
80101e12:	75 60                	jne    80101e74 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e1b:	66 85 c0             	test   %ax,%ax
80101e1e:	78 20                	js     80101e40 <readi+0x40>
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e27:	66 83 f8 09          	cmp    $0x9,%ax
80101e2b:	7f 13                	jg     80101e40 <readi+0x40>
80101e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e30:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e34:	98                   	cwtl   
80101e35:	8b 04 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%eax
80101e3c:	85 c0                	test   %eax,%eax
80101e3e:	75 0a                	jne    80101e4a <readi+0x4a>
      return -1;
80101e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e45:	e9 1c 01 00 00       	jmp    80101f66 <readi+0x166>
    return devsw[ip->major].read(ip, dst, n);
80101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e51:	98                   	cwtl   
80101e52:	8b 14 c5 c0 11 11 80 	mov    -0x7feeee40(,%eax,8),%edx
80101e59:	8b 45 14             	mov    0x14(%ebp),%eax
80101e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e67:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6a:	89 04 24             	mov    %eax,(%esp)
80101e6d:	ff d2                	call   *%edx
80101e6f:	e9 f2 00 00 00       	jmp    80101f66 <readi+0x166>
  }

  if(off > ip->size || off + n < off)
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 40 18             	mov    0x18(%eax),%eax
80101e7a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e7d:	72 0e                	jb     80101e8d <readi+0x8d>
80101e7f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e82:	8b 55 10             	mov    0x10(%ebp),%edx
80101e85:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101e88:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e8b:	73 0a                	jae    80101e97 <readi+0x97>
    return -1;
80101e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e92:	e9 cf 00 00 00       	jmp    80101f66 <readi+0x166>
  if(off + n > ip->size)
80101e97:	8b 45 14             	mov    0x14(%ebp),%eax
80101e9a:	8b 55 10             	mov    0x10(%ebp),%edx
80101e9d:	01 c2                	add    %eax,%edx
80101e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea2:	8b 40 18             	mov    0x18(%eax),%eax
80101ea5:	39 c2                	cmp    %eax,%edx
80101ea7:	76 0c                	jbe    80101eb5 <readi+0xb5>
    n = ip->size - off;
80101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eac:	8b 40 18             	mov    0x18(%eax),%eax
80101eaf:	2b 45 10             	sub    0x10(%ebp),%eax
80101eb2:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eb5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101ebc:	e9 96 00 00 00       	jmp    80101f57 <readi+0x157>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ec1:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec4:	c1 e8 09             	shr    $0x9,%eax
80101ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ece:	89 04 24             	mov    %eax,(%esp)
80101ed1:	e8 d6 fc ff ff       	call   80101bac <bmap>
80101ed6:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed9:	8b 12                	mov    (%edx),%edx
80101edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80101edf:	89 14 24             	mov    %edx,(%esp)
80101ee2:	e8 c0 e2 ff ff       	call   801001a7 <bread>
80101ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eea:	8b 45 10             	mov    0x10(%ebp),%eax
80101eed:	89 c2                	mov    %eax,%edx
80101eef:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ef5:	b8 00 02 00 00       	mov    $0x200,%eax
80101efa:	89 c1                	mov    %eax,%ecx
80101efc:	29 d1                	sub    %edx,%ecx
80101efe:	89 ca                	mov    %ecx,%edx
80101f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f03:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101f06:	89 cb                	mov    %ecx,%ebx
80101f08:	29 c3                	sub    %eax,%ebx
80101f0a:	89 d8                	mov    %ebx,%eax
80101f0c:	39 c2                	cmp    %eax,%edx
80101f0e:	0f 46 c2             	cmovbe %edx,%eax
80101f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f17:	8d 50 18             	lea    0x18(%eax),%edx
80101f1a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f1d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f22:	01 c2                	add    %eax,%edx
80101f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f27:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f2b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f32:	89 04 24             	mov    %eax,(%esp)
80101f35:	e8 e7 32 00 00       	call   80105221 <memmove>
    brelse(bp);
80101f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f3d:	89 04 24             	mov    %eax,(%esp)
80101f40:	e8 d3 e2 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f48:	01 45 ec             	add    %eax,-0x14(%ebp)
80101f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f4e:	01 45 10             	add    %eax,0x10(%ebp)
80101f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f54:	01 45 0c             	add    %eax,0xc(%ebp)
80101f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f5a:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f5d:	0f 82 5e ff ff ff    	jb     80101ec1 <readi+0xc1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f63:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f66:	83 c4 24             	add    $0x24,%esp
80101f69:	5b                   	pop    %ebx
80101f6a:	5d                   	pop    %ebp
80101f6b:	c3                   	ret    

80101f6c <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f6c:	55                   	push   %ebp
80101f6d:	89 e5                	mov    %esp,%ebp
80101f6f:	53                   	push   %ebx
80101f70:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f7a:	66 83 f8 03          	cmp    $0x3,%ax
80101f7e:	75 60                	jne    80101fe0 <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f87:	66 85 c0             	test   %ax,%ax
80101f8a:	78 20                	js     80101fac <writei+0x40>
80101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f93:	66 83 f8 09          	cmp    $0x9,%ax
80101f97:	7f 13                	jg     80101fac <writei+0x40>
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa0:	98                   	cwtl   
80101fa1:	8b 04 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%eax
80101fa8:	85 c0                	test   %eax,%eax
80101faa:	75 0a                	jne    80101fb6 <writei+0x4a>
      return -1;
80101fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fb1:	e9 48 01 00 00       	jmp    801020fe <writei+0x192>
    return devsw[ip->major].write(ip, src, n);
80101fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fbd:	98                   	cwtl   
80101fbe:	8b 14 c5 c4 11 11 80 	mov    -0x7feeee3c(,%eax,8),%edx
80101fc5:	8b 45 14             	mov    0x14(%ebp),%eax
80101fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd6:	89 04 24             	mov    %eax,(%esp)
80101fd9:	ff d2                	call   *%edx
80101fdb:	e9 1e 01 00 00       	jmp    801020fe <writei+0x192>
  }

  if(off > ip->size || off + n < off)
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 40 18             	mov    0x18(%eax),%eax
80101fe6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe9:	72 0e                	jb     80101ff9 <writei+0x8d>
80101feb:	8b 45 14             	mov    0x14(%ebp),%eax
80101fee:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff1:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101ff4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff7:	73 0a                	jae    80102003 <writei+0x97>
    return -1;
80101ff9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ffe:	e9 fb 00 00 00       	jmp    801020fe <writei+0x192>
  if(off + n > MAXFILE*BSIZE)
80102003:	8b 45 14             	mov    0x14(%ebp),%eax
80102006:	8b 55 10             	mov    0x10(%ebp),%edx
80102009:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010200c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102011:	76 0a                	jbe    8010201d <writei+0xb1>
    return -1;
80102013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102018:	e9 e1 00 00 00       	jmp    801020fe <writei+0x192>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010201d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80102024:	e9 a1 00 00 00       	jmp    801020ca <writei+0x15e>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102029:	8b 45 10             	mov    0x10(%ebp),%eax
8010202c:	c1 e8 09             	shr    $0x9,%eax
8010202f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102033:	8b 45 08             	mov    0x8(%ebp),%eax
80102036:	89 04 24             	mov    %eax,(%esp)
80102039:	e8 6e fb ff ff       	call   80101bac <bmap>
8010203e:	8b 55 08             	mov    0x8(%ebp),%edx
80102041:	8b 12                	mov    (%edx),%edx
80102043:	89 44 24 04          	mov    %eax,0x4(%esp)
80102047:	89 14 24             	mov    %edx,(%esp)
8010204a:	e8 58 e1 ff ff       	call   801001a7 <bread>
8010204f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102052:	8b 45 10             	mov    0x10(%ebp),%eax
80102055:	89 c2                	mov    %eax,%edx
80102057:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010205d:	b8 00 02 00 00       	mov    $0x200,%eax
80102062:	89 c1                	mov    %eax,%ecx
80102064:	29 d1                	sub    %edx,%ecx
80102066:	89 ca                	mov    %ecx,%edx
80102068:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010206b:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010206e:	89 cb                	mov    %ecx,%ebx
80102070:	29 c3                	sub    %eax,%ebx
80102072:	89 d8                	mov    %ebx,%eax
80102074:	39 c2                	cmp    %eax,%edx
80102076:	0f 46 c2             	cmovbe %edx,%eax
80102079:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010207f:	8d 50 18             	lea    0x18(%eax),%edx
80102082:	8b 45 10             	mov    0x10(%ebp),%eax
80102085:	25 ff 01 00 00       	and    $0x1ff,%eax
8010208a:	01 c2                	add    %eax,%edx
8010208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010208f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102093:	8b 45 0c             	mov    0xc(%ebp),%eax
80102096:	89 44 24 04          	mov    %eax,0x4(%esp)
8010209a:	89 14 24             	mov    %edx,(%esp)
8010209d:	e8 7f 31 00 00       	call   80105221 <memmove>
    log_write(bp);
801020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020a5:	89 04 24             	mov    %eax,(%esp)
801020a8:	e8 4f 16 00 00       	call   801036fc <log_write>
    brelse(bp);
801020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b0:	89 04 24             	mov    %eax,(%esp)
801020b3:	e8 60 e1 ff ff       	call   80100218 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020bb:	01 45 ec             	add    %eax,-0x14(%ebp)
801020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c1:	01 45 10             	add    %eax,0x10(%ebp)
801020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020c7:	01 45 0c             	add    %eax,0xc(%ebp)
801020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cd:	3b 45 14             	cmp    0x14(%ebp),%eax
801020d0:	0f 82 53 ff ff ff    	jb     80102029 <writei+0xbd>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020da:	74 1f                	je     801020fb <writei+0x18f>
801020dc:	8b 45 08             	mov    0x8(%ebp),%eax
801020df:	8b 40 18             	mov    0x18(%eax),%eax
801020e2:	3b 45 10             	cmp    0x10(%ebp),%eax
801020e5:	73 14                	jae    801020fb <writei+0x18f>
    ip->size = off;
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	8b 55 10             	mov    0x10(%ebp),%edx
801020ed:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020f0:	8b 45 08             	mov    0x8(%ebp),%eax
801020f3:	89 04 24             	mov    %eax,(%esp)
801020f6:	e8 40 f6 ff ff       	call   8010173b <iupdate>
  }
  return n;
801020fb:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020fe:	83 c4 24             	add    $0x24,%esp
80102101:	5b                   	pop    %ebx
80102102:	5d                   	pop    %ebp
80102103:	c3                   	ret    

80102104 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010210a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102111:	00 
80102112:	8b 45 0c             	mov    0xc(%ebp),%eax
80102115:	89 44 24 04          	mov    %eax,0x4(%esp)
80102119:	8b 45 08             	mov    0x8(%ebp),%eax
8010211c:	89 04 24             	mov    %eax,(%esp)
8010211f:	e8 a5 31 00 00       	call   801052c9 <strncmp>
}
80102124:	c9                   	leave  
80102125:	c3                   	ret    

80102126 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102126:	55                   	push   %ebp
80102127:	89 e5                	mov    %esp,%ebp
80102129:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010212c:	8b 45 08             	mov    0x8(%ebp),%eax
8010212f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102133:	66 83 f8 01          	cmp    $0x1,%ax
80102137:	74 0c                	je     80102145 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102139:	c7 04 24 5f 86 10 80 	movl   $0x8010865f,(%esp)
80102140:	e8 f8 e3 ff ff       	call   8010053d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010214c:	e9 87 00 00 00       	jmp    801021d8 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102151:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102154:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010215b:	00 
8010215c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010215f:	89 54 24 08          	mov    %edx,0x8(%esp)
80102163:	89 44 24 04          	mov    %eax,0x4(%esp)
80102167:	8b 45 08             	mov    0x8(%ebp),%eax
8010216a:	89 04 24             	mov    %eax,(%esp)
8010216d:	e8 8e fc ff ff       	call   80101e00 <readi>
80102172:	83 f8 10             	cmp    $0x10,%eax
80102175:	74 0c                	je     80102183 <dirlookup+0x5d>
      panic("dirlink read");
80102177:	c7 04 24 71 86 10 80 	movl   $0x80108671,(%esp)
8010217e:	e8 ba e3 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
80102183:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102187:	66 85 c0             	test   %ax,%ax
8010218a:	74 47                	je     801021d3 <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
8010218c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010218f:	83 c0 02             	add    $0x2,%eax
80102192:	89 44 24 04          	mov    %eax,0x4(%esp)
80102196:	8b 45 0c             	mov    0xc(%ebp),%eax
80102199:	89 04 24             	mov    %eax,(%esp)
8010219c:	e8 63 ff ff ff       	call   80102104 <namecmp>
801021a1:	85 c0                	test   %eax,%eax
801021a3:	75 2f                	jne    801021d4 <dirlookup+0xae>
      // entry matches path element
      if(poff)
801021a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021a9:	74 08                	je     801021b3 <dirlookup+0x8d>
        *poff = off;
801021ab:	8b 45 10             	mov    0x10(%ebp),%eax
801021ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021b1:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021b3:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021b7:	0f b7 c0             	movzwl %ax,%eax
801021ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return iget(dp->dev, inum);
801021bd:	8b 45 08             	mov    0x8(%ebp),%eax
801021c0:	8b 00                	mov    (%eax),%eax
801021c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c5:	89 54 24 04          	mov    %edx,0x4(%esp)
801021c9:	89 04 24             	mov    %eax,(%esp)
801021cc:	e8 2b f6 ff ff       	call   801017fc <iget>
801021d1:	eb 19                	jmp    801021ec <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801021d3:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021d4:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8b 40 18             	mov    0x18(%eax),%eax
801021de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801021e1:	0f 87 6a ff ff ff    	ja     80102151 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021ec:	c9                   	leave  
801021ed:	c3                   	ret    

801021ee <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021ee:	55                   	push   %ebp
801021ef:	89 e5                	mov    %esp,%ebp
801021f1:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021fb:	00 
801021fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80102203:	8b 45 08             	mov    0x8(%ebp),%eax
80102206:	89 04 24             	mov    %eax,(%esp)
80102209:	e8 18 ff ff ff       	call   80102126 <dirlookup>
8010220e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102215:	74 15                	je     8010222c <dirlink+0x3e>
    iput(ip);
80102217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221a:	89 04 24             	mov    %eax,(%esp)
8010221d:	e8 9b f8 ff ff       	call   80101abd <iput>
    return -1;
80102222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102227:	e9 b8 00 00 00       	jmp    801022e4 <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102233:	eb 44                	jmp    80102279 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102235:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102238:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010223b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102242:	00 
80102243:	89 54 24 08          	mov    %edx,0x8(%esp)
80102247:	89 44 24 04          	mov    %eax,0x4(%esp)
8010224b:	8b 45 08             	mov    0x8(%ebp),%eax
8010224e:	89 04 24             	mov    %eax,(%esp)
80102251:	e8 aa fb ff ff       	call   80101e00 <readi>
80102256:	83 f8 10             	cmp    $0x10,%eax
80102259:	74 0c                	je     80102267 <dirlink+0x79>
      panic("dirlink read");
8010225b:	c7 04 24 71 86 10 80 	movl   $0x80108671,(%esp)
80102262:	e8 d6 e2 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
80102267:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010226b:	66 85 c0             	test   %ax,%ax
8010226e:	74 18                	je     80102288 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102273:	83 c0 10             	add    $0x10,%eax
80102276:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102279:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010227c:	8b 45 08             	mov    0x8(%ebp),%eax
8010227f:	8b 40 18             	mov    0x18(%eax),%eax
80102282:	39 c2                	cmp    %eax,%edx
80102284:	72 af                	jb     80102235 <dirlink+0x47>
80102286:	eb 01                	jmp    80102289 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102288:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102289:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102290:	00 
80102291:	8b 45 0c             	mov    0xc(%ebp),%eax
80102294:	89 44 24 04          	mov    %eax,0x4(%esp)
80102298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010229b:	83 c0 02             	add    $0x2,%eax
8010229e:	89 04 24             	mov    %eax,(%esp)
801022a1:	e8 7b 30 00 00       	call   80105321 <strncpy>
  de.inum = inum;
801022a6:	8b 45 10             	mov    0x10(%ebp),%eax
801022a9:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022ba:	00 
801022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
801022bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	89 04 24             	mov    %eax,(%esp)
801022c9:	e8 9e fc ff ff       	call   80101f6c <writei>
801022ce:	83 f8 10             	cmp    $0x10,%eax
801022d1:	74 0c                	je     801022df <dirlink+0xf1>
    panic("dirlink");
801022d3:	c7 04 24 7e 86 10 80 	movl   $0x8010867e,(%esp)
801022da:	e8 5e e2 ff ff       	call   8010053d <panic>
  
  return 0;
801022df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022e4:	c9                   	leave  
801022e5:	c3                   	ret    

801022e6 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022e6:	55                   	push   %ebp
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022ec:	eb 04                	jmp    801022f2 <skipelem+0xc>
    path++;
801022ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	0f b6 00             	movzbl (%eax),%eax
801022f8:	3c 2f                	cmp    $0x2f,%al
801022fa:	74 f2                	je     801022ee <skipelem+0x8>
    path++;
  if(*path == 0)
801022fc:	8b 45 08             	mov    0x8(%ebp),%eax
801022ff:	0f b6 00             	movzbl (%eax),%eax
80102302:	84 c0                	test   %al,%al
80102304:	75 0a                	jne    80102310 <skipelem+0x2a>
    return 0;
80102306:	b8 00 00 00 00       	mov    $0x0,%eax
8010230b:	e9 86 00 00 00       	jmp    80102396 <skipelem+0xb0>
  s = path;
80102310:	8b 45 08             	mov    0x8(%ebp),%eax
80102313:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(*path != '/' && *path != 0)
80102316:	eb 04                	jmp    8010231c <skipelem+0x36>
    path++;
80102318:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010231c:	8b 45 08             	mov    0x8(%ebp),%eax
8010231f:	0f b6 00             	movzbl (%eax),%eax
80102322:	3c 2f                	cmp    $0x2f,%al
80102324:	74 0a                	je     80102330 <skipelem+0x4a>
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	0f b6 00             	movzbl (%eax),%eax
8010232c:	84 c0                	test   %al,%al
8010232e:	75 e8                	jne    80102318 <skipelem+0x32>
    path++;
  len = path - s;
80102330:	8b 55 08             	mov    0x8(%ebp),%edx
80102333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102336:	89 d1                	mov    %edx,%ecx
80102338:	29 c1                	sub    %eax,%ecx
8010233a:	89 c8                	mov    %ecx,%eax
8010233c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(len >= DIRSIZ)
8010233f:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80102343:	7e 1c                	jle    80102361 <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
80102345:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010234c:	00 
8010234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102350:	89 44 24 04          	mov    %eax,0x4(%esp)
80102354:	8b 45 0c             	mov    0xc(%ebp),%eax
80102357:	89 04 24             	mov    %eax,(%esp)
8010235a:	e8 c2 2e 00 00       	call   80105221 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010235f:	eb 28                	jmp    80102389 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102364:	89 44 24 08          	mov    %eax,0x8(%esp)
80102368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010236b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102372:	89 04 24             	mov    %eax,(%esp)
80102375:	e8 a7 2e 00 00       	call   80105221 <memmove>
    name[len] = 0;
8010237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237d:	03 45 0c             	add    0xc(%ebp),%eax
80102380:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102383:	eb 04                	jmp    80102389 <skipelem+0xa3>
    path++;
80102385:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102389:	8b 45 08             	mov    0x8(%ebp),%eax
8010238c:	0f b6 00             	movzbl (%eax),%eax
8010238f:	3c 2f                	cmp    $0x2f,%al
80102391:	74 f2                	je     80102385 <skipelem+0x9f>
    path++;
  return path;
80102393:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102396:	c9                   	leave  
80102397:	c3                   	ret    

80102398 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010239e:	8b 45 08             	mov    0x8(%ebp),%eax
801023a1:	0f b6 00             	movzbl (%eax),%eax
801023a4:	3c 2f                	cmp    $0x2f,%al
801023a6:	75 1c                	jne    801023c4 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801023a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023af:	00 
801023b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023b7:	e8 40 f4 ff ff       	call   801017fc <iget>
801023bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023bf:	e9 af 00 00 00       	jmp    80102473 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801023c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023ca:	8b 40 68             	mov    0x68(%eax),%eax
801023cd:	89 04 24             	mov    %eax,(%esp)
801023d0:	e8 fa f4 ff ff       	call   801018cf <idup>
801023d5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while((path = skipelem(path, name)) != 0){
801023d8:	e9 96 00 00 00       	jmp    80102473 <namex+0xdb>
    ilock(ip);
801023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023e0:	89 04 24             	mov    %eax,(%esp)
801023e3:	e8 19 f5 ff ff       	call   80101901 <ilock>
    if(ip->type != T_DIR){
801023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023eb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023ef:	66 83 f8 01          	cmp    $0x1,%ax
801023f3:	74 15                	je     8010240a <namex+0x72>
      iunlockput(ip);
801023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f8:	89 04 24             	mov    %eax,(%esp)
801023fb:	e8 8e f7 ff ff       	call   80101b8e <iunlockput>
      return 0;
80102400:	b8 00 00 00 00       	mov    $0x0,%eax
80102405:	e9 a3 00 00 00       	jmp    801024ad <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010240a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010240e:	74 1d                	je     8010242d <namex+0x95>
80102410:	8b 45 08             	mov    0x8(%ebp),%eax
80102413:	0f b6 00             	movzbl (%eax),%eax
80102416:	84 c0                	test   %al,%al
80102418:	75 13                	jne    8010242d <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010241d:	89 04 24             	mov    %eax,(%esp)
80102420:	e8 33 f6 ff ff       	call   80101a58 <iunlock>
      return ip;
80102425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102428:	e9 80 00 00 00       	jmp    801024ad <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010242d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102434:	00 
80102435:	8b 45 10             	mov    0x10(%ebp),%eax
80102438:	89 44 24 04          	mov    %eax,0x4(%esp)
8010243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010243f:	89 04 24             	mov    %eax,(%esp)
80102442:	e8 df fc ff ff       	call   80102126 <dirlookup>
80102447:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010244a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010244e:	75 12                	jne    80102462 <namex+0xca>
      iunlockput(ip);
80102450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102453:	89 04 24             	mov    %eax,(%esp)
80102456:	e8 33 f7 ff ff       	call   80101b8e <iunlockput>
      return 0;
8010245b:	b8 00 00 00 00       	mov    $0x0,%eax
80102460:	eb 4b                	jmp    801024ad <namex+0x115>
    }
    iunlockput(ip);
80102462:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102465:	89 04 24             	mov    %eax,(%esp)
80102468:	e8 21 f7 ff ff       	call   80101b8e <iunlockput>
    ip = next;
8010246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102470:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102473:	8b 45 10             	mov    0x10(%ebp),%eax
80102476:	89 44 24 04          	mov    %eax,0x4(%esp)
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
8010247d:	89 04 24             	mov    %eax,(%esp)
80102480:	e8 61 fe ff ff       	call   801022e6 <skipelem>
80102485:	89 45 08             	mov    %eax,0x8(%ebp)
80102488:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010248c:	0f 85 4b ff ff ff    	jne    801023dd <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102496:	74 12                	je     801024aa <namex+0x112>
    iput(ip);
80102498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010249b:	89 04 24             	mov    %eax,(%esp)
8010249e:	e8 1a f6 ff ff       	call   80101abd <iput>
    return 0;
801024a3:	b8 00 00 00 00       	mov    $0x0,%eax
801024a8:	eb 03                	jmp    801024ad <namex+0x115>
  }
  return ip;
801024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801024ad:	c9                   	leave  
801024ae:	c3                   	ret    

801024af <namei>:

struct inode*
namei(char *path)
{
801024af:	55                   	push   %ebp
801024b0:	89 e5                	mov    %esp,%ebp
801024b2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024b5:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801024bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024c3:	00 
801024c4:	8b 45 08             	mov    0x8(%ebp),%eax
801024c7:	89 04 24             	mov    %eax,(%esp)
801024ca:	e8 c9 fe ff ff       	call   80102398 <namex>
}
801024cf:	c9                   	leave  
801024d0:	c3                   	ret    

801024d1 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024d1:	55                   	push   %ebp
801024d2:	89 e5                	mov    %esp,%ebp
801024d4:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801024da:	89 44 24 08          	mov    %eax,0x8(%esp)
801024de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024e5:	00 
801024e6:	8b 45 08             	mov    0x8(%ebp),%eax
801024e9:	89 04 24             	mov    %eax,(%esp)
801024ec:	e8 a7 fe ff ff       	call   80102398 <namex>
}
801024f1:	c9                   	leave  
801024f2:	c3                   	ret    
	...

801024f4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	83 ec 14             	sub    $0x14,%esp
801024fa:	8b 45 08             	mov    0x8(%ebp),%eax
801024fd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102505:	89 c2                	mov    %eax,%edx
80102507:	ec                   	in     (%dx),%al
80102508:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010250b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010250f:	c9                   	leave  
80102510:	c3                   	ret    

80102511 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102511:	55                   	push   %ebp
80102512:	89 e5                	mov    %esp,%ebp
80102514:	57                   	push   %edi
80102515:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102516:	8b 55 08             	mov    0x8(%ebp),%edx
80102519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251c:	8b 45 10             	mov    0x10(%ebp),%eax
8010251f:	89 cb                	mov    %ecx,%ebx
80102521:	89 df                	mov    %ebx,%edi
80102523:	89 c1                	mov    %eax,%ecx
80102525:	fc                   	cld    
80102526:	f3 6d                	rep insl (%dx),%es:(%edi)
80102528:	89 c8                	mov    %ecx,%eax
8010252a:	89 fb                	mov    %edi,%ebx
8010252c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010252f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102532:	5b                   	pop    %ebx
80102533:	5f                   	pop    %edi
80102534:	5d                   	pop    %ebp
80102535:	c3                   	ret    

80102536 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102536:	55                   	push   %ebp
80102537:	89 e5                	mov    %esp,%ebp
80102539:	83 ec 08             	sub    $0x8,%esp
8010253c:	8b 55 08             	mov    0x8(%ebp),%edx
8010253f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102542:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102546:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102549:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010254d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102551:	ee                   	out    %al,(%dx)
}
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	56                   	push   %esi
80102558:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102559:	8b 55 08             	mov    0x8(%ebp),%edx
8010255c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010255f:	8b 45 10             	mov    0x10(%ebp),%eax
80102562:	89 cb                	mov    %ecx,%ebx
80102564:	89 de                	mov    %ebx,%esi
80102566:	89 c1                	mov    %eax,%ecx
80102568:	fc                   	cld    
80102569:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010256b:	89 c8                	mov    %ecx,%eax
8010256d:	89 f3                	mov    %esi,%ebx
8010256f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102572:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102575:	5b                   	pop    %ebx
80102576:	5e                   	pop    %esi
80102577:	5d                   	pop    %ebp
80102578:	c3                   	ret    

80102579 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102579:	55                   	push   %ebp
8010257a:	89 e5                	mov    %esp,%ebp
8010257c:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010257f:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102586:	e8 69 ff ff ff       	call   801024f4 <inb>
8010258b:	0f b6 c0             	movzbl %al,%eax
8010258e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102591:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102594:	25 c0 00 00 00       	and    $0xc0,%eax
80102599:	83 f8 40             	cmp    $0x40,%eax
8010259c:	75 e1                	jne    8010257f <idewait+0x6>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010259e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a2:	74 11                	je     801025b5 <idewait+0x3c>
801025a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025a7:	83 e0 21             	and    $0x21,%eax
801025aa:	85 c0                	test   %eax,%eax
801025ac:	74 07                	je     801025b5 <idewait+0x3c>
    return -1;
801025ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025b3:	eb 05                	jmp    801025ba <idewait+0x41>
  return 0;
801025b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025ba:	c9                   	leave  
801025bb:	c3                   	ret    

801025bc <ideinit>:

void
ideinit(void)
{
801025bc:	55                   	push   %ebp
801025bd:	89 e5                	mov    %esp,%ebp
801025bf:	83 ec 28             	sub    $0x28,%esp
  int i;
  
  initlock(&idelock, "ide");
801025c2:	c7 44 24 04 86 86 10 	movl   $0x80108686,0x4(%esp)
801025c9:	80 
801025ca:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801025d1:	e8 00 29 00 00       	call   80104ed6 <initlock>
  picenable(IRQ_IDE);
801025d6:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025dd:	e8 b3 18 00 00       	call   80103e95 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025e2:	a1 40 29 11 80       	mov    0x80112940,%eax
801025e7:	83 e8 01             	sub    $0x1,%eax
801025ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801025ee:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025f5:	e8 48 04 00 00       	call   80102a42 <ioapicenable>
  idewait(0);
801025fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102601:	e8 73 ff ff ff       	call   80102579 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102606:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010260d:	00 
8010260e:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102615:	e8 1c ff ff ff       	call   80102536 <outb>
  for(i=0; i<1000; i++){
8010261a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102621:	eb 20                	jmp    80102643 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102623:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010262a:	e8 c5 fe ff ff       	call   801024f4 <inb>
8010262f:	84 c0                	test   %al,%al
80102631:	74 0c                	je     8010263f <ideinit+0x83>
      havedisk1 = 1;
80102633:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
8010263a:	00 00 00 
      break;
8010263d:	eb 0d                	jmp    8010264c <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010263f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102643:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010264a:	7e d7                	jle    80102623 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010264c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102653:	00 
80102654:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010265b:	e8 d6 fe ff ff       	call   80102536 <outb>
}
80102660:	c9                   	leave  
80102661:	c3                   	ret    

80102662 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102662:	55                   	push   %ebp
80102663:	89 e5                	mov    %esp,%ebp
80102665:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102668:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010266c:	75 0c                	jne    8010267a <idestart+0x18>
    panic("idestart");
8010266e:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
80102675:	e8 c3 de ff ff       	call   8010053d <panic>
  if(b->blockno >= FSSIZE)
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
8010267d:	8b 40 08             	mov    0x8(%eax),%eax
80102680:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102685:	76 0c                	jbe    80102693 <idestart+0x31>
    panic("incorrect blockno");
80102687:	c7 04 24 93 86 10 80 	movl   $0x80108693,(%esp)
8010268e:	e8 aa de ff ff       	call   8010053d <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102693:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  int sector = b->blockno * sector_per_block;
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
8010269d:	8b 50 08             	mov    0x8(%eax),%edx
801026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026a3:	0f af c2             	imul   %edx,%eax
801026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026a9:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
801026ad:	7e 0c                	jle    801026bb <idestart+0x59>
801026af:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
801026b6:	e8 82 de ff ff       	call   8010053d <panic>
  
  idewait(0);
801026bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026c2:	e8 b2 fe ff ff       	call   80102579 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026ce:	00 
801026cf:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026d6:	e8 5b fe ff ff       	call   80102536 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026de:	0f b6 c0             	movzbl %al,%eax
801026e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801026e5:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026ec:	e8 45 fe ff ff       	call   80102536 <outb>
  outb(0x1f3, sector & 0xff);
801026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f4:	0f b6 c0             	movzbl %al,%eax
801026f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801026fb:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102702:	e8 2f fe ff ff       	call   80102536 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
80102707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010270a:	c1 f8 08             	sar    $0x8,%eax
8010270d:	0f b6 c0             	movzbl %al,%eax
80102710:	89 44 24 04          	mov    %eax,0x4(%esp)
80102714:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010271b:	e8 16 fe ff ff       	call   80102536 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102723:	c1 f8 10             	sar    $0x10,%eax
80102726:	0f b6 c0             	movzbl %al,%eax
80102729:	89 44 24 04          	mov    %eax,0x4(%esp)
8010272d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102734:	e8 fd fd ff ff       	call   80102536 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102739:	8b 45 08             	mov    0x8(%ebp),%eax
8010273c:	8b 40 04             	mov    0x4(%eax),%eax
8010273f:	83 e0 01             	and    $0x1,%eax
80102742:	89 c2                	mov    %eax,%edx
80102744:	c1 e2 04             	shl    $0x4,%edx
80102747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274a:	c1 f8 18             	sar    $0x18,%eax
8010274d:	83 e0 0f             	and    $0xf,%eax
80102750:	09 d0                	or     %edx,%eax
80102752:	83 c8 e0             	or     $0xffffffe0,%eax
80102755:	0f b6 c0             	movzbl %al,%eax
80102758:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275c:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102763:	e8 ce fd ff ff       	call   80102536 <outb>
  if(b->flags & B_DIRTY){
80102768:	8b 45 08             	mov    0x8(%ebp),%eax
8010276b:	8b 00                	mov    (%eax),%eax
8010276d:	83 e0 04             	and    $0x4,%eax
80102770:	85 c0                	test   %eax,%eax
80102772:	74 34                	je     801027a8 <idestart+0x146>
    outb(0x1f7, IDE_CMD_WRITE);
80102774:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010277b:	00 
8010277c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102783:	e8 ae fd ff ff       	call   80102536 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102788:	8b 45 08             	mov    0x8(%ebp),%eax
8010278b:	83 c0 18             	add    $0x18,%eax
8010278e:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102795:	00 
80102796:	89 44 24 04          	mov    %eax,0x4(%esp)
8010279a:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027a1:	e8 ae fd ff ff       	call   80102554 <outsl>
801027a6:	eb 14                	jmp    801027bc <idestart+0x15a>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027a8:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801027af:	00 
801027b0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027b7:	e8 7a fd ff ff       	call   80102536 <outb>
  }
}
801027bc:	c9                   	leave  
801027bd:	c3                   	ret    

801027be <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027be:	55                   	push   %ebp
801027bf:	89 e5                	mov    %esp,%ebp
801027c1:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027c4:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027cb:	e8 27 27 00 00       	call   80104ef7 <acquire>
  if((b = idequeue) == 0){
801027d0:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027dc:	75 11                	jne    801027ef <ideintr+0x31>
    release(&idelock);
801027de:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027e5:	e8 6e 27 00 00       	call   80104f58 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801027ea:	e9 90 00 00 00       	jmp    8010287f <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f2:	8b 40 14             	mov    0x14(%eax),%eax
801027f5:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fd:	8b 00                	mov    (%eax),%eax
801027ff:	83 e0 04             	and    $0x4,%eax
80102802:	85 c0                	test   %eax,%eax
80102804:	75 2e                	jne    80102834 <ideintr+0x76>
80102806:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010280d:	e8 67 fd ff ff       	call   80102579 <idewait>
80102812:	85 c0                	test   %eax,%eax
80102814:	78 1e                	js     80102834 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	83 c0 18             	add    $0x18,%eax
8010281c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102823:	00 
80102824:	89 44 24 04          	mov    %eax,0x4(%esp)
80102828:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010282f:	e8 dd fc ff ff       	call   80102511 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	89 c2                	mov    %eax,%edx
8010283b:	83 ca 02             	or     $0x2,%edx
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102846:	8b 00                	mov    (%eax),%eax
80102848:	89 c2                	mov    %eax,%edx
8010284a:	83 e2 fb             	and    $0xfffffffb,%edx
8010284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102850:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102855:	89 04 24             	mov    %eax,(%esp)
80102858:	e8 a3 24 00 00       	call   80104d00 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010285d:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102862:	85 c0                	test   %eax,%eax
80102864:	74 0d                	je     80102873 <ideintr+0xb5>
    idestart(idequeue);
80102866:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010286b:	89 04 24             	mov    %eax,(%esp)
8010286e:	e8 ef fd ff ff       	call   80102662 <idestart>

  release(&idelock);
80102873:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010287a:	e8 d9 26 00 00       	call   80104f58 <release>
}
8010287f:	c9                   	leave  
80102880:	c3                   	ret    

80102881 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102881:	55                   	push   %ebp
80102882:	89 e5                	mov    %esp,%ebp
80102884:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102887:	8b 45 08             	mov    0x8(%ebp),%eax
8010288a:	8b 00                	mov    (%eax),%eax
8010288c:	83 e0 01             	and    $0x1,%eax
8010288f:	85 c0                	test   %eax,%eax
80102891:	75 0c                	jne    8010289f <iderw+0x1e>
    panic("iderw: buf not busy");
80102893:	c7 04 24 a5 86 10 80 	movl   $0x801086a5,(%esp)
8010289a:	e8 9e dc ff ff       	call   8010053d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	8b 00                	mov    (%eax),%eax
801028a4:	83 e0 06             	and    $0x6,%eax
801028a7:	83 f8 02             	cmp    $0x2,%eax
801028aa:	75 0c                	jne    801028b8 <iderw+0x37>
    panic("iderw: nothing to do");
801028ac:	c7 04 24 b9 86 10 80 	movl   $0x801086b9,(%esp)
801028b3:	e8 85 dc ff ff       	call   8010053d <panic>
  if(b->dev != 0 && !havedisk1)
801028b8:	8b 45 08             	mov    0x8(%ebp),%eax
801028bb:	8b 40 04             	mov    0x4(%eax),%eax
801028be:	85 c0                	test   %eax,%eax
801028c0:	74 15                	je     801028d7 <iderw+0x56>
801028c2:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801028c7:	85 c0                	test   %eax,%eax
801028c9:	75 0c                	jne    801028d7 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801028cb:	c7 04 24 ce 86 10 80 	movl   $0x801086ce,(%esp)
801028d2:	e8 66 dc ff ff       	call   8010053d <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028d7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801028de:	e8 14 26 00 00       	call   80104ef7 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028e3:	8b 45 08             	mov    0x8(%ebp),%eax
801028e6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ed:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
801028f4:	eb 0b                	jmp    80102901 <iderw+0x80>
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f9:	8b 00                	mov    (%eax),%eax
801028fb:	83 c0 14             	add    $0x14,%eax
801028fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102904:	8b 00                	mov    (%eax),%eax
80102906:	85 c0                	test   %eax,%eax
80102908:	75 ec                	jne    801028f6 <iderw+0x75>
    ;
  *pp = b;
8010290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290d:	8b 55 08             	mov    0x8(%ebp),%edx
80102910:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102912:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102917:	3b 45 08             	cmp    0x8(%ebp),%eax
8010291a:	75 22                	jne    8010293e <iderw+0xbd>
    idestart(b);
8010291c:	8b 45 08             	mov    0x8(%ebp),%eax
8010291f:	89 04 24             	mov    %eax,(%esp)
80102922:	e8 3b fd ff ff       	call   80102662 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102927:	eb 16                	jmp    8010293f <iderw+0xbe>
    sleep(b, &idelock);
80102929:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102930:	80 
80102931:	8b 45 08             	mov    0x8(%ebp),%eax
80102934:	89 04 24             	mov    %eax,(%esp)
80102937:	e8 ea 22 00 00       	call   80104c26 <sleep>
8010293c:	eb 01                	jmp    8010293f <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010293e:	90                   	nop
8010293f:	8b 45 08             	mov    0x8(%ebp),%eax
80102942:	8b 00                	mov    (%eax),%eax
80102944:	83 e0 06             	and    $0x6,%eax
80102947:	83 f8 02             	cmp    $0x2,%eax
8010294a:	75 dd                	jne    80102929 <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
8010294c:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102953:	e8 00 26 00 00       	call   80104f58 <release>
}
80102958:	c9                   	leave  
80102959:	c3                   	ret    
	...

8010295c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010295c:	55                   	push   %ebp
8010295d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010295f:	a1 14 22 11 80       	mov    0x80112214,%eax
80102964:	8b 55 08             	mov    0x8(%ebp),%edx
80102967:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102969:	a1 14 22 11 80       	mov    0x80112214,%eax
8010296e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret    

80102973 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102973:	55                   	push   %ebp
80102974:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102976:	a1 14 22 11 80       	mov    0x80112214,%eax
8010297b:	8b 55 08             	mov    0x8(%ebp),%edx
8010297e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102980:	a1 14 22 11 80       	mov    0x80112214,%eax
80102985:	8b 55 0c             	mov    0xc(%ebp),%edx
80102988:	89 50 10             	mov    %edx,0x10(%eax)
}
8010298b:	5d                   	pop    %ebp
8010298c:	c3                   	ret    

8010298d <ioapicinit>:

void
ioapicinit(void)
{
8010298d:	55                   	push   %ebp
8010298e:	89 e5                	mov    %esp,%ebp
80102990:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102993:	a1 44 23 11 80       	mov    0x80112344,%eax
80102998:	85 c0                	test   %eax,%eax
8010299a:	0f 84 9f 00 00 00    	je     80102a3f <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029a0:	c7 05 14 22 11 80 00 	movl   $0xfec00000,0x80112214
801029a7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029b1:	e8 a6 ff ff ff       	call   8010295c <ioapicread>
801029b6:	c1 e8 10             	shr    $0x10,%eax
801029b9:	25 ff 00 00 00       	and    $0xff,%eax
801029be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029c8:	e8 8f ff ff ff       	call   8010295c <ioapicread>
801029cd:	c1 e8 18             	shr    $0x18,%eax
801029d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id != ioapicid)
801029d3:	0f b6 05 40 23 11 80 	movzbl 0x80112340,%eax
801029da:	0f b6 c0             	movzbl %al,%eax
801029dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029e0:	74 0c                	je     801029ee <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e2:	c7 04 24 ec 86 10 80 	movl   $0x801086ec,(%esp)
801029e9:	e8 af d9 ff ff       	call   8010039d <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801029f5:	eb 3e                	jmp    80102a35 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029fa:	83 c0 20             	add    $0x20,%eax
801029fd:	0d 00 00 01 00       	or     $0x10000,%eax
80102a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102a05:	83 c2 08             	add    $0x8,%edx
80102a08:	01 d2                	add    %edx,%edx
80102a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0e:	89 14 24             	mov    %edx,(%esp)
80102a11:	e8 5d ff ff ff       	call   80102973 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a19:	83 c0 08             	add    $0x8,%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	83 c0 01             	add    $0x1,%eax
80102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a28:	00 
80102a29:	89 04 24             	mov    %eax,(%esp)
80102a2c:	e8 42 ff ff ff       	call   80102973 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80102a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a38:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102a3b:	7e ba                	jle    801029f7 <ioapicinit+0x6a>
80102a3d:	eb 01                	jmp    80102a40 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102a3f:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a40:	c9                   	leave  
80102a41:	c3                   	ret    

80102a42 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a42:	55                   	push   %ebp
80102a43:	89 e5                	mov    %esp,%ebp
80102a45:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102a48:	a1 44 23 11 80       	mov    0x80112344,%eax
80102a4d:	85 c0                	test   %eax,%eax
80102a4f:	74 39                	je     80102a8a <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a51:	8b 45 08             	mov    0x8(%ebp),%eax
80102a54:	83 c0 20             	add    $0x20,%eax
80102a57:	8b 55 08             	mov    0x8(%ebp),%edx
80102a5a:	83 c2 08             	add    $0x8,%edx
80102a5d:	01 d2                	add    %edx,%edx
80102a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a63:	89 14 24             	mov    %edx,(%esp)
80102a66:	e8 08 ff ff ff       	call   80102973 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a6e:	c1 e0 18             	shl    $0x18,%eax
80102a71:	8b 55 08             	mov    0x8(%ebp),%edx
80102a74:	83 c2 08             	add    $0x8,%edx
80102a77:	01 d2                	add    %edx,%edx
80102a79:	83 c2 01             	add    $0x1,%edx
80102a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a80:	89 14 24             	mov    %edx,(%esp)
80102a83:	e8 eb fe ff ff       	call   80102973 <ioapicwrite>
80102a88:	eb 01                	jmp    80102a8b <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102a8a:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102a8b:	c9                   	leave  
80102a8c:	c3                   	ret    
80102a8d:	00 00                	add    %al,(%eax)
	...

80102a90 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	8b 45 08             	mov    0x8(%ebp),%eax
80102a96:	2d 00 00 00 80       	sub    $0x80000000,%eax
80102a9b:	5d                   	pop    %ebp
80102a9c:	c3                   	ret    

80102a9d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a9d:	55                   	push   %ebp
80102a9e:	89 e5                	mov    %esp,%ebp
80102aa0:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102aa3:	c7 44 24 04 1e 87 10 	movl   $0x8010871e,0x4(%esp)
80102aaa:	80 
80102aab:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102ab2:	e8 1f 24 00 00       	call   80104ed6 <initlock>
  kmem.use_lock = 0;
80102ab7:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102abe:	00 00 00 
  freerange(vstart, vend);
80102ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80102acb:	89 04 24             	mov    %eax,(%esp)
80102ace:	e8 26 00 00 00       	call   80102af9 <freerange>
}
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    

80102ad5 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
80102ad8:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102adb:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ade:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae5:	89 04 24             	mov    %eax,(%esp)
80102ae8:	e8 0c 00 00 00       	call   80102af9 <freerange>
  kmem.use_lock = 1;
80102aed:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102af4:	00 00 00 
}
80102af7:	c9                   	leave  
80102af8:	c3                   	ret    

80102af9 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102af9:	55                   	push   %ebp
80102afa:	89 e5                	mov    %esp,%ebp
80102afc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102aff:	8b 45 08             	mov    0x8(%ebp),%eax
80102b02:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0f:	eb 12                	jmp    80102b23 <freerange+0x2a>
    kfree(p);
80102b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b14:	89 04 24             	mov    %eax,(%esp)
80102b17:	e8 19 00 00 00       	call   80102b35 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b1c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b26:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b2f:	39 c2                	cmp    %eax,%edx
80102b31:	76 de                	jbe    80102b11 <freerange+0x18>
    kfree(p);
}
80102b33:	c9                   	leave  
80102b34:	c3                   	ret    

80102b35 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b35:	55                   	push   %ebp
80102b36:	89 e5                	mov    %esp,%ebp
80102b38:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b43:	85 c0                	test   %eax,%eax
80102b45:	75 1b                	jne    80102b62 <kfree+0x2d>
80102b47:	81 7d 08 3c 51 11 80 	cmpl   $0x8011513c,0x8(%ebp)
80102b4e:	72 12                	jb     80102b62 <kfree+0x2d>
80102b50:	8b 45 08             	mov    0x8(%ebp),%eax
80102b53:	89 04 24             	mov    %eax,(%esp)
80102b56:	e8 35 ff ff ff       	call   80102a90 <v2p>
80102b5b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b60:	76 0c                	jbe    80102b6e <kfree+0x39>
    panic("kfree");
80102b62:	c7 04 24 23 87 10 80 	movl   $0x80108723,(%esp)
80102b69:	e8 cf d9 ff ff       	call   8010053d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b6e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b75:	00 
80102b76:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b7d:	00 
80102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b81:	89 04 24             	mov    %eax,(%esp)
80102b84:	e8 c5 25 00 00       	call   8010514e <memset>

  if(kmem.use_lock)
80102b89:	a1 54 22 11 80       	mov    0x80112254,%eax
80102b8e:	85 c0                	test   %eax,%eax
80102b90:	74 0c                	je     80102b9e <kfree+0x69>
    acquire(&kmem.lock);
80102b92:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102b99:	e8 59 23 00 00       	call   80104ef7 <acquire>
  r = (struct run*)v;
80102b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ba4:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bad:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb2:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102bb7:	a1 54 22 11 80       	mov    0x80112254,%eax
80102bbc:	85 c0                	test   %eax,%eax
80102bbe:	74 0c                	je     80102bcc <kfree+0x97>
    release(&kmem.lock);
80102bc0:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102bc7:	e8 8c 23 00 00       	call   80104f58 <release>
}
80102bcc:	c9                   	leave  
80102bcd:	c3                   	ret    

80102bce <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102bd4:	a1 54 22 11 80       	mov    0x80112254,%eax
80102bd9:	85 c0                	test   %eax,%eax
80102bdb:	74 0c                	je     80102be9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bdd:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102be4:	e8 0e 23 00 00       	call   80104ef7 <acquire>
  r = kmem.freelist;
80102be9:	a1 58 22 11 80       	mov    0x80112258,%eax
80102bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bf5:	74 0a                	je     80102c01 <kalloc+0x33>
    kmem.freelist = r->next;
80102bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bfa:	8b 00                	mov    (%eax),%eax
80102bfc:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c01:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c06:	85 c0                	test   %eax,%eax
80102c08:	74 0c                	je     80102c16 <kalloc+0x48>
    release(&kmem.lock);
80102c0a:	c7 04 24 20 22 11 80 	movl   $0x80112220,(%esp)
80102c11:	e8 42 23 00 00       	call   80104f58 <release>
  return (char*)r;
80102c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c19:	c9                   	leave  
80102c1a:	c3                   	ret    
	...

80102c1c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c1c:	55                   	push   %ebp
80102c1d:	89 e5                	mov    %esp,%ebp
80102c1f:	83 ec 14             	sub    $0x14,%esp
80102c22:	8b 45 08             	mov    0x8(%ebp),%eax
80102c25:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c29:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c2d:	89 c2                	mov    %eax,%edx
80102c2f:	ec                   	in     (%dx),%al
80102c30:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c33:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c37:	c9                   	leave  
80102c38:	c3                   	ret    

80102c39 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c39:	55                   	push   %ebp
80102c3a:	89 e5                	mov    %esp,%ebp
80102c3c:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c3f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c46:	e8 d1 ff ff ff       	call   80102c1c <inb>
80102c4b:	0f b6 c0             	movzbl %al,%eax
80102c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c54:	83 e0 01             	and    $0x1,%eax
80102c57:	85 c0                	test   %eax,%eax
80102c59:	75 0a                	jne    80102c65 <kbdgetc+0x2c>
    return -1;
80102c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c60:	e9 20 01 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  data = inb(KBDATAP);
80102c65:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c6c:	e8 ab ff ff ff       	call   80102c1c <inb>
80102c71:	0f b6 c0             	movzbl %al,%eax
80102c74:	89 45 f8             	mov    %eax,-0x8(%ebp)

  if(data == 0xE0){
80102c77:	81 7d f8 e0 00 00 00 	cmpl   $0xe0,-0x8(%ebp)
80102c7e:	75 17                	jne    80102c97 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c80:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c85:	83 c8 40             	or     $0x40,%eax
80102c88:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c8d:	b8 00 00 00 00       	mov    $0x0,%eax
80102c92:	e9 ee 00 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  } else if(data & 0x80){
80102c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102c9a:	25 80 00 00 00       	and    $0x80,%eax
80102c9f:	85 c0                	test   %eax,%eax
80102ca1:	74 44                	je     80102ce7 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ca3:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ca8:	83 e0 40             	and    $0x40,%eax
80102cab:	85 c0                	test   %eax,%eax
80102cad:	75 08                	jne    80102cb7 <kbdgetc+0x7e>
80102caf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cb2:	83 e0 7f             	and    $0x7f,%eax
80102cb5:	eb 03                	jmp    80102cba <kbdgetc+0x81>
80102cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cba:	89 45 f8             	mov    %eax,-0x8(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102cc0:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102cc7:	83 c8 40             	or     $0x40,%eax
80102cca:	0f b6 c0             	movzbl %al,%eax
80102ccd:	f7 d0                	not    %eax
80102ccf:	89 c2                	mov    %eax,%edx
80102cd1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cd6:	21 d0                	and    %edx,%eax
80102cd8:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80102ce2:	e9 9e 00 00 00       	jmp    80102d85 <kbdgetc+0x14c>
  } else if(shift & E0ESC){
80102ce7:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cec:	83 e0 40             	and    $0x40,%eax
80102cef:	85 c0                	test   %eax,%eax
80102cf1:	74 14                	je     80102d07 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cf3:	81 4d f8 80 00 00 00 	orl    $0x80,-0x8(%ebp)
    shift &= ~E0ESC;
80102cfa:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cff:	83 e0 bf             	and    $0xffffffbf,%eax
80102d02:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102d07:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102d0a:	0f b6 80 20 90 10 80 	movzbl -0x7fef6fe0(%eax),%eax
80102d11:	0f b6 d0             	movzbl %al,%edx
80102d14:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d19:	09 d0                	or     %edx,%eax
80102d1b:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102d23:	0f b6 80 20 91 10 80 	movzbl -0x7fef6ee0(%eax),%eax
80102d2a:	0f b6 d0             	movzbl %al,%edx
80102d2d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d32:	31 d0                	xor    %edx,%eax
80102d34:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d39:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d3e:	83 e0 03             	and    $0x3,%eax
80102d41:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102d48:	03 45 f8             	add    -0x8(%ebp),%eax
80102d4b:	0f b6 00             	movzbl (%eax),%eax
80102d4e:	0f b6 c0             	movzbl %al,%eax
80102d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(shift & CAPSLOCK){
80102d54:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102d59:	83 e0 08             	and    $0x8,%eax
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	74 22                	je     80102d82 <kbdgetc+0x149>
    if('a' <= c && c <= 'z')
80102d60:	83 7d fc 60          	cmpl   $0x60,-0x4(%ebp)
80102d64:	76 0c                	jbe    80102d72 <kbdgetc+0x139>
80102d66:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%ebp)
80102d6a:	77 06                	ja     80102d72 <kbdgetc+0x139>
      c += 'A' - 'a';
80102d6c:	83 6d fc 20          	subl   $0x20,-0x4(%ebp)

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
80102d70:	eb 10                	jmp    80102d82 <kbdgetc+0x149>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102d72:	83 7d fc 40          	cmpl   $0x40,-0x4(%ebp)
80102d76:	76 0a                	jbe    80102d82 <kbdgetc+0x149>
80102d78:	83 7d fc 5a          	cmpl   $0x5a,-0x4(%ebp)
80102d7c:	77 04                	ja     80102d82 <kbdgetc+0x149>
      c += 'a' - 'A';
80102d7e:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
  }
  return c;
80102d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    

80102d87 <kbdintr>:

void
kbdintr(void)
{
80102d87:	55                   	push   %ebp
80102d88:	89 e5                	mov    %esp,%ebp
80102d8a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d8d:	c7 04 24 39 2c 10 80 	movl   $0x80102c39,(%esp)
80102d94:	e8 30 da ff ff       	call   801007c9 <consoleintr>
}
80102d99:	c9                   	leave  
80102d9a:	c3                   	ret    
	...

80102d9c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d9c:	55                   	push   %ebp
80102d9d:	89 e5                	mov    %esp,%ebp
80102d9f:	83 ec 14             	sub    $0x14,%esp
80102da2:	8b 45 08             	mov    0x8(%ebp),%eax
80102da5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102dad:	89 c2                	mov    %eax,%edx
80102daf:	ec                   	in     (%dx),%al
80102db0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102db3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102db7:	c9                   	leave  
80102db8:	c3                   	ret    

80102db9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102db9:	55                   	push   %ebp
80102dba:	89 e5                	mov    %esp,%ebp
80102dbc:	83 ec 08             	sub    $0x8,%esp
80102dbf:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102dc9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dcc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dd0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102dd4:	ee                   	out    %al,(%dx)
}
80102dd5:	c9                   	leave  
80102dd6:	c3                   	ret    

80102dd7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102dd7:	55                   	push   %ebp
80102dd8:	89 e5                	mov    %esp,%ebp
80102dda:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ddd:	9c                   	pushf  
80102dde:	58                   	pop    %eax
80102ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102de5:	c9                   	leave  
80102de6:	c3                   	ret    

80102de7 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102de7:	55                   	push   %ebp
80102de8:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102dea:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102def:	8b 55 08             	mov    0x8(%ebp),%edx
80102df2:	c1 e2 02             	shl    $0x2,%edx
80102df5:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dfb:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dfd:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e02:	83 c0 20             	add    $0x20,%eax
80102e05:	8b 00                	mov    (%eax),%eax
}
80102e07:	5d                   	pop    %ebp
80102e08:	c3                   	ret    

80102e09 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e09:	55                   	push   %ebp
80102e0a:	89 e5                	mov    %esp,%ebp
80102e0c:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102e0f:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e14:	85 c0                	test   %eax,%eax
80102e16:	0f 84 46 01 00 00    	je     80102f62 <lapicinit+0x159>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e1c:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e23:	00 
80102e24:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e2b:	e8 b7 ff ff ff       	call   80102de7 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e30:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e37:	00 
80102e38:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e3f:	e8 a3 ff ff ff       	call   80102de7 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e44:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e4b:	00 
80102e4c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e53:	e8 8f ff ff ff       	call   80102de7 <lapicw>
  lapicw(TICR, 10000000); 
80102e58:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e5f:	00 
80102e60:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e67:	e8 7b ff ff ff       	call   80102de7 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e6c:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e73:	00 
80102e74:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e7b:	e8 67 ff ff ff       	call   80102de7 <lapicw>
  lapicw(LINT1, MASKED);
80102e80:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e87:	00 
80102e88:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e8f:	e8 53 ff ff ff       	call   80102de7 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e94:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102e99:	83 c0 30             	add    $0x30,%eax
80102e9c:	8b 00                	mov    (%eax),%eax
80102e9e:	c1 e8 10             	shr    $0x10,%eax
80102ea1:	25 ff 00 00 00       	and    $0xff,%eax
80102ea6:	83 f8 03             	cmp    $0x3,%eax
80102ea9:	76 14                	jbe    80102ebf <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102eab:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102eb2:	00 
80102eb3:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102eba:	e8 28 ff ff ff       	call   80102de7 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ebf:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ec6:	00 
80102ec7:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102ece:	e8 14 ff ff ff       	call   80102de7 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ed3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eda:	00 
80102edb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ee2:	e8 00 ff ff ff       	call   80102de7 <lapicw>
  lapicw(ESR, 0);
80102ee7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eee:	00 
80102eef:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ef6:	e8 ec fe ff ff       	call   80102de7 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102efb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f02:	00 
80102f03:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f0a:	e8 d8 fe ff ff       	call   80102de7 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f16:	00 
80102f17:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f1e:	e8 c4 fe ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f23:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f2a:	00 
80102f2b:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f32:	e8 b0 fe ff ff       	call   80102de7 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f37:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102f3c:	05 00 03 00 00       	add    $0x300,%eax
80102f41:	8b 00                	mov    (%eax),%eax
80102f43:	25 00 10 00 00       	and    $0x1000,%eax
80102f48:	85 c0                	test   %eax,%eax
80102f4a:	75 eb                	jne    80102f37 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f53:	00 
80102f54:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f5b:	e8 87 fe ff ff       	call   80102de7 <lapicw>
80102f60:	eb 01                	jmp    80102f63 <lapicinit+0x15a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102f62:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f63:	c9                   	leave  
80102f64:	c3                   	ret    

80102f65 <cpunum>:

int
cpunum(void)
{
80102f65:	55                   	push   %ebp
80102f66:	89 e5                	mov    %esp,%ebp
80102f68:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f6b:	e8 67 fe ff ff       	call   80102dd7 <readeflags>
80102f70:	25 00 02 00 00       	and    $0x200,%eax
80102f75:	85 c0                	test   %eax,%eax
80102f77:	74 29                	je     80102fa2 <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102f79:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102f7e:	85 c0                	test   %eax,%eax
80102f80:	0f 94 c2             	sete   %dl
80102f83:	83 c0 01             	add    $0x1,%eax
80102f86:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102f8b:	84 d2                	test   %dl,%dl
80102f8d:	74 13                	je     80102fa2 <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f8f:	8b 45 04             	mov    0x4(%ebp),%eax
80102f92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f96:	c7 04 24 2c 87 10 80 	movl   $0x8010872c,(%esp)
80102f9d:	e8 fb d3 ff ff       	call   8010039d <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102fa2:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fa7:	85 c0                	test   %eax,%eax
80102fa9:	74 0f                	je     80102fba <cpunum+0x55>
    return lapic[ID]>>24;
80102fab:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fb0:	83 c0 20             	add    $0x20,%eax
80102fb3:	8b 00                	mov    (%eax),%eax
80102fb5:	c1 e8 18             	shr    $0x18,%eax
80102fb8:	eb 05                	jmp    80102fbf <cpunum+0x5a>
  return 0;
80102fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fbf:	c9                   	leave  
80102fc0:	c3                   	ret    

80102fc1 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fc1:	55                   	push   %ebp
80102fc2:	89 e5                	mov    %esp,%ebp
80102fc4:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102fc7:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102fcc:	85 c0                	test   %eax,%eax
80102fce:	74 14                	je     80102fe4 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102fd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fd7:	00 
80102fd8:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102fdf:	e8 03 fe ff ff       	call   80102de7 <lapicw>
}
80102fe4:	c9                   	leave  
80102fe5:	c3                   	ret    

80102fe6 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fe6:	55                   	push   %ebp
80102fe7:	89 e5                	mov    %esp,%ebp
}
80102fe9:	5d                   	pop    %ebp
80102fea:	c3                   	ret    

80102feb <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102feb:	55                   	push   %ebp
80102fec:	89 e5                	mov    %esp,%ebp
80102fee:	83 ec 1c             	sub    $0x1c,%esp
80102ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ff4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102ff7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102ffe:	00 
80102fff:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103006:	e8 ae fd ff ff       	call   80102db9 <outb>
  outb(CMOS_PORT+1, 0x0A);
8010300b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103012:	00 
80103013:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010301a:	e8 9a fd ff ff       	call   80102db9 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010301f:	c7 45 fc 67 04 00 80 	movl   $0x80000467,-0x4(%ebp)
  wrv[0] = 0;
80103026:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103029:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010302e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103031:	8d 50 02             	lea    0x2(%eax),%edx
80103034:	8b 45 0c             	mov    0xc(%ebp),%eax
80103037:	c1 e8 04             	shr    $0x4,%eax
8010303a:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010303d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103041:	c1 e0 18             	shl    $0x18,%eax
80103044:	89 44 24 04          	mov    %eax,0x4(%esp)
80103048:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010304f:	e8 93 fd ff ff       	call   80102de7 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103054:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010305b:	00 
8010305c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103063:	e8 7f fd ff ff       	call   80102de7 <lapicw>
  microdelay(200);
80103068:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010306f:	e8 72 ff ff ff       	call   80102fe6 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103074:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010307b:	00 
8010307c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103083:	e8 5f fd ff ff       	call   80102de7 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103088:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010308f:	e8 52 ff ff ff       	call   80102fe6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103094:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010309b:	eb 40                	jmp    801030dd <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010309d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030a1:	c1 e0 18             	shl    $0x18,%eax
801030a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801030a8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030af:	e8 33 fd ff ff       	call   80102de7 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801030b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801030b7:	c1 e8 0c             	shr    $0xc,%eax
801030ba:	80 cc 06             	or     $0x6,%ah
801030bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801030c1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801030c8:	e8 1a fd ff ff       	call   80102de7 <lapicw>
    microdelay(200);
801030cd:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801030d4:	e8 0d ff ff ff       	call   80102fe6 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030d9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801030dd:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
801030e1:	7e ba                	jle    8010309d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    

801030e5 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030e5:	55                   	push   %ebp
801030e6:	89 e5                	mov    %esp,%ebp
801030e8:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
801030eb:	8b 45 08             	mov    0x8(%ebp),%eax
801030ee:	0f b6 c0             	movzbl %al,%eax
801030f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f5:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030fc:	e8 b8 fc ff ff       	call   80102db9 <outb>
  microdelay(200);
80103101:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103108:	e8 d9 fe ff ff       	call   80102fe6 <microdelay>

  return inb(CMOS_RETURN);
8010310d:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103114:	e8 83 fc ff ff       	call   80102d9c <inb>
80103119:	0f b6 c0             	movzbl %al,%eax
}
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    

8010311e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010311e:	55                   	push   %ebp
8010311f:	89 e5                	mov    %esp,%ebp
80103121:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010312b:	e8 b5 ff ff ff       	call   801030e5 <cmos_read>
80103130:	8b 55 08             	mov    0x8(%ebp),%edx
80103133:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103135:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010313c:	e8 a4 ff ff ff       	call   801030e5 <cmos_read>
80103141:	8b 55 08             	mov    0x8(%ebp),%edx
80103144:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103147:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010314e:	e8 92 ff ff ff       	call   801030e5 <cmos_read>
80103153:	8b 55 08             	mov    0x8(%ebp),%edx
80103156:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103159:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103160:	e8 80 ff ff ff       	call   801030e5 <cmos_read>
80103165:	8b 55 08             	mov    0x8(%ebp),%edx
80103168:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010316b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103172:	e8 6e ff ff ff       	call   801030e5 <cmos_read>
80103177:	8b 55 08             	mov    0x8(%ebp),%edx
8010317a:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010317d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103184:	e8 5c ff ff ff       	call   801030e5 <cmos_read>
80103189:	8b 55 08             	mov    0x8(%ebp),%edx
8010318c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010318f:	c9                   	leave  
80103190:	c3                   	ret    

80103191 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103191:	55                   	push   %ebp
80103192:	89 e5                	mov    %esp,%ebp
80103194:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103197:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010319e:	e8 42 ff ff ff       	call   801030e5 <cmos_read>
801031a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a9:	83 e0 04             	and    $0x4,%eax
801031ac:	85 c0                	test   %eax,%eax
801031ae:	0f 94 c0             	sete   %al
801031b1:	0f b6 c0             	movzbl %al,%eax
801031b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801031b7:	eb 01                	jmp    801031ba <cmostime+0x29>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031b9:	90                   	nop

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031ba:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031bd:	89 04 24             	mov    %eax,(%esp)
801031c0:	e8 59 ff ff ff       	call   8010311e <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031c5:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801031cc:	e8 14 ff ff ff       	call   801030e5 <cmos_read>
801031d1:	25 80 00 00 00       	and    $0x80,%eax
801031d6:	85 c0                	test   %eax,%eax
801031d8:	74 03                	je     801031dd <cmostime+0x4c>
        continue;
801031da:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031db:	eb dd                	jmp    801031ba <cmostime+0x29>
  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
801031dd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e0:	89 04 24             	mov    %eax,(%esp)
801031e3:	e8 36 ff ff ff       	call   8010311e <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031e8:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801031ef:	00 
801031f0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801031f7:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031fa:	89 04 24             	mov    %eax,(%esp)
801031fd:	e8 c3 1f 00 00       	call   801051c5 <memcmp>
80103202:	85 c0                	test   %eax,%eax
80103204:	75 b3                	jne    801031b9 <cmostime+0x28>
      break;
80103206:	90                   	nop
  }

  // convert
  if (bcd) {
80103207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010320b:	0f 84 a8 00 00 00    	je     801032b9 <cmostime+0x128>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103211:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103214:	89 c2                	mov    %eax,%edx
80103216:	c1 ea 04             	shr    $0x4,%edx
80103219:	89 d0                	mov    %edx,%eax
8010321b:	c1 e0 02             	shl    $0x2,%eax
8010321e:	01 d0                	add    %edx,%eax
80103220:	01 c0                	add    %eax,%eax
80103222:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103225:	83 e2 0f             	and    $0xf,%edx
80103228:	01 d0                	add    %edx,%eax
8010322a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010322d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103230:	89 c2                	mov    %eax,%edx
80103232:	c1 ea 04             	shr    $0x4,%edx
80103235:	89 d0                	mov    %edx,%eax
80103237:	c1 e0 02             	shl    $0x2,%eax
8010323a:	01 d0                	add    %edx,%eax
8010323c:	01 c0                	add    %eax,%eax
8010323e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103241:	83 e2 0f             	and    $0xf,%edx
80103244:	01 d0                	add    %edx,%eax
80103246:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103249:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010324c:	89 c2                	mov    %eax,%edx
8010324e:	c1 ea 04             	shr    $0x4,%edx
80103251:	89 d0                	mov    %edx,%eax
80103253:	c1 e0 02             	shl    $0x2,%eax
80103256:	01 d0                	add    %edx,%eax
80103258:	01 c0                	add    %eax,%eax
8010325a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010325d:	83 e2 0f             	and    $0xf,%edx
80103260:	01 d0                	add    %edx,%eax
80103262:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103268:	89 c2                	mov    %eax,%edx
8010326a:	c1 ea 04             	shr    $0x4,%edx
8010326d:	89 d0                	mov    %edx,%eax
8010326f:	c1 e0 02             	shl    $0x2,%eax
80103272:	01 d0                	add    %edx,%eax
80103274:	01 c0                	add    %eax,%eax
80103276:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103279:	83 e2 0f             	and    $0xf,%edx
8010327c:	01 d0                	add    %edx,%eax
8010327e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103281:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103284:	89 c2                	mov    %eax,%edx
80103286:	c1 ea 04             	shr    $0x4,%edx
80103289:	89 d0                	mov    %edx,%eax
8010328b:	c1 e0 02             	shl    $0x2,%eax
8010328e:	01 d0                	add    %edx,%eax
80103290:	01 c0                	add    %eax,%eax
80103292:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103295:	83 e2 0f             	and    $0xf,%edx
80103298:	01 d0                	add    %edx,%eax
8010329a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010329d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032a0:	89 c2                	mov    %eax,%edx
801032a2:	c1 ea 04             	shr    $0x4,%edx
801032a5:	89 d0                	mov    %edx,%eax
801032a7:	c1 e0 02             	shl    $0x2,%eax
801032aa:	01 d0                	add    %edx,%eax
801032ac:	01 c0                	add    %eax,%eax
801032ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032b1:	83 e2 0f             	and    $0xf,%edx
801032b4:	01 d0                	add    %edx,%eax
801032b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032b9:	8b 45 08             	mov    0x8(%ebp),%eax
801032bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032bf:	89 10                	mov    %edx,(%eax)
801032c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032c4:	89 50 04             	mov    %edx,0x4(%eax)
801032c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ca:	89 50 08             	mov    %edx,0x8(%eax)
801032cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032d0:	89 50 0c             	mov    %edx,0xc(%eax)
801032d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032d6:	89 50 10             	mov    %edx,0x10(%eax)
801032d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032dc:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032df:	8b 45 08             	mov    0x8(%ebp),%eax
801032e2:	8b 40 14             	mov    0x14(%eax),%eax
801032e5:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032eb:	8b 45 08             	mov    0x8(%ebp),%eax
801032ee:	89 50 14             	mov    %edx,0x14(%eax)
}
801032f1:	c9                   	leave  
801032f2:	c3                   	ret    
	...

801032f4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032f4:	55                   	push   %ebp
801032f5:	89 e5                	mov    %esp,%ebp
801032f7:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
801032fa:	90                   	nop
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032fb:	c7 44 24 04 58 87 10 	movl   $0x80108758,0x4(%esp)
80103302:	80 
80103303:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010330a:	e8 c7 1b 00 00       	call   80104ed6 <initlock>
  readsb(dev, &sb);
8010330f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103312:	89 44 24 04          	mov    %eax,0x4(%esp)
80103316:	8b 45 08             	mov    0x8(%ebp),%eax
80103319:	89 04 24             	mov    %eax,(%esp)
8010331c:	e8 f7 df ff ff       	call   80101318 <readsb>
  log.start = sb.logstart;
80103321:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103324:	a3 94 22 11 80       	mov    %eax,0x80112294
  log.size = sb.nlog;
80103329:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010332c:	a3 98 22 11 80       	mov    %eax,0x80112298
  log.dev = dev;
80103331:	8b 45 08             	mov    0x8(%ebp),%eax
80103334:	a3 a4 22 11 80       	mov    %eax,0x801122a4
  recover_from_log();
80103339:	e8 97 01 00 00       	call   801034d5 <recover_from_log>
}
8010333e:	c9                   	leave  
8010333f:	c3                   	ret    

80103340 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103346:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010334d:	e9 89 00 00 00       	jmp    801033db <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103352:	a1 94 22 11 80       	mov    0x80112294,%eax
80103357:	03 45 ec             	add    -0x14(%ebp),%eax
8010335a:	83 c0 01             	add    $0x1,%eax
8010335d:	89 c2                	mov    %eax,%edx
8010335f:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103364:	89 54 24 04          	mov    %edx,0x4(%esp)
80103368:	89 04 24             	mov    %eax,(%esp)
8010336b:	e8 37 ce ff ff       	call   801001a7 <bread>
80103370:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103373:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103376:	83 c0 10             	add    $0x10,%eax
80103379:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103380:	89 c2                	mov    %eax,%edx
80103382:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103387:	89 54 24 04          	mov    %edx,0x4(%esp)
8010338b:	89 04 24             	mov    %eax,(%esp)
8010338e:	e8 14 ce ff ff       	call   801001a7 <bread>
80103393:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103399:	8d 50 18             	lea    0x18(%eax),%edx
8010339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010339f:	83 c0 18             	add    $0x18,%eax
801033a2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801033a9:	00 
801033aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801033ae:	89 04 24             	mov    %eax,(%esp)
801033b1:	e8 6b 1e 00 00       	call   80105221 <memmove>
    bwrite(dbuf);  // write dst to disk
801033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033b9:	89 04 24             	mov    %eax,(%esp)
801033bc:	e8 1d ce ff ff       	call   801001de <bwrite>
    brelse(lbuf); 
801033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033c4:	89 04 24             	mov    %eax,(%esp)
801033c7:	e8 4c ce ff ff       	call   80100218 <brelse>
    brelse(dbuf);
801033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033cf:	89 04 24             	mov    %eax,(%esp)
801033d2:	e8 41 ce ff ff       	call   80100218 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033d7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801033db:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801033e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801033e3:	0f 8f 69 ff ff ff    	jg     80103352 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033e9:	c9                   	leave  
801033ea:	c3                   	ret    

801033eb <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033eb:	55                   	push   %ebp
801033ec:	89 e5                	mov    %esp,%ebp
801033ee:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033f1:	a1 94 22 11 80       	mov    0x80112294,%eax
801033f6:	89 c2                	mov    %eax,%edx
801033f8:	a1 a4 22 11 80       	mov    0x801122a4,%eax
801033fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80103401:	89 04 24             	mov    %eax,(%esp)
80103404:	e8 9e cd ff ff       	call   801001a7 <bread>
80103409:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010340c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010340f:	83 c0 18             	add    $0x18,%eax
80103412:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  log.lh.n = lh->n;
80103415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103418:	8b 00                	mov    (%eax),%eax
8010341a:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  for (i = 0; i < log.lh.n; i++) {
8010341f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103426:	eb 1b                	jmp    80103443 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
80103428:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010342b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103431:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103435:	8d 51 10             	lea    0x10(%ecx),%edx
80103438:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010343f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103443:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103448:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010344b:	7f db                	jg     80103428 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103450:	89 04 24             	mov    %eax,(%esp)
80103453:	e8 c0 cd ff ff       	call   80100218 <brelse>
}
80103458:	c9                   	leave  
80103459:	c3                   	ret    

8010345a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010345a:	55                   	push   %ebp
8010345b:	89 e5                	mov    %esp,%ebp
8010345d:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103460:	a1 94 22 11 80       	mov    0x80112294,%eax
80103465:	89 c2                	mov    %eax,%edx
80103467:	a1 a4 22 11 80       	mov    0x801122a4,%eax
8010346c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103470:	89 04 24             	mov    %eax,(%esp)
80103473:	e8 2f cd ff ff       	call   801001a7 <bread>
80103478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	83 c0 18             	add    $0x18,%eax
80103481:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  hb->n = log.lh.n;
80103484:	8b 15 a8 22 11 80    	mov    0x801122a8,%edx
8010348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010348f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103496:	eb 1b                	jmp    801034b3 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103498:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010349e:	83 c0 10             	add    $0x10,%eax
801034a1:	8b 0c 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%ecx
801034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ab:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b3:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801034b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034bb:	7f db                	jg     80103498 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c0:	89 04 24             	mov    %eax,(%esp)
801034c3:	e8 16 cd ff ff       	call   801001de <bwrite>
  brelse(buf);
801034c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034cb:	89 04 24             	mov    %eax,(%esp)
801034ce:	e8 45 cd ff ff       	call   80100218 <brelse>
}
801034d3:	c9                   	leave  
801034d4:	c3                   	ret    

801034d5 <recover_from_log>:

static void
recover_from_log(void)
{
801034d5:	55                   	push   %ebp
801034d6:	89 e5                	mov    %esp,%ebp
801034d8:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034db:	e8 0b ff ff ff       	call   801033eb <read_head>
  install_trans(); // if committed, copy from log to disk
801034e0:	e8 5b fe ff ff       	call   80103340 <install_trans>
  log.lh.n = 0;
801034e5:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
801034ec:	00 00 00 
  write_head(); // clear the log
801034ef:	e8 66 ff ff ff       	call   8010345a <write_head>
}
801034f4:	c9                   	leave  
801034f5:	c3                   	ret    

801034f6 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034f6:	55                   	push   %ebp
801034f7:	89 e5                	mov    %esp,%ebp
801034f9:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801034fc:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103503:	e8 ef 19 00 00       	call   80104ef7 <acquire>
  while(1){
    if(log.committing){
80103508:	a1 a0 22 11 80       	mov    0x801122a0,%eax
8010350d:	85 c0                	test   %eax,%eax
8010350f:	74 16                	je     80103527 <begin_op+0x31>
      sleep(&log, &log.lock);
80103511:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80103518:	80 
80103519:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103520:	e8 01 17 00 00       	call   80104c26 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
80103525:	eb e1                	jmp    80103508 <begin_op+0x12>
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103527:	8b 0d a8 22 11 80    	mov    0x801122a8,%ecx
8010352d:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103532:	8d 50 01             	lea    0x1(%eax),%edx
80103535:	89 d0                	mov    %edx,%eax
80103537:	c1 e0 02             	shl    $0x2,%eax
8010353a:	01 d0                	add    %edx,%eax
8010353c:	01 c0                	add    %eax,%eax
8010353e:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80103541:	83 f8 1e             	cmp    $0x1e,%eax
80103544:	7e 16                	jle    8010355c <begin_op+0x66>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103546:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
8010354d:	80 
8010354e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103555:	e8 cc 16 00 00       	call   80104c26 <sleep>
    } else {
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
8010355a:	eb ac                	jmp    80103508 <begin_op+0x12>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
8010355c:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103561:	83 c0 01             	add    $0x1,%eax
80103564:	a3 9c 22 11 80       	mov    %eax,0x8011229c
      release(&log.lock);
80103569:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103570:	e8 e3 19 00 00       	call   80104f58 <release>
      break;
80103575:	90                   	nop
    }
  }
}
80103576:	c9                   	leave  
80103577:	c3                   	ret    

80103578 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103578:	55                   	push   %ebp
80103579:	89 e5                	mov    %esp,%ebp
8010357b:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
8010357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103585:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010358c:	e8 66 19 00 00       	call   80104ef7 <acquire>
  log.outstanding -= 1;
80103591:	a1 9c 22 11 80       	mov    0x8011229c,%eax
80103596:	83 e8 01             	sub    $0x1,%eax
80103599:	a3 9c 22 11 80       	mov    %eax,0x8011229c
  if(log.committing)
8010359e:	a1 a0 22 11 80       	mov    0x801122a0,%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	74 0c                	je     801035b3 <end_op+0x3b>
    panic("log.committing");
801035a7:	c7 04 24 5c 87 10 80 	movl   $0x8010875c,(%esp)
801035ae:	e8 8a cf ff ff       	call   8010053d <panic>
  if(log.outstanding == 0){
801035b3:	a1 9c 22 11 80       	mov    0x8011229c,%eax
801035b8:	85 c0                	test   %eax,%eax
801035ba:	75 13                	jne    801035cf <end_op+0x57>
    do_commit = 1;
801035bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035c3:	c7 05 a0 22 11 80 01 	movl   $0x1,0x801122a0
801035ca:	00 00 00 
801035cd:	eb 0c                	jmp    801035db <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035cf:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801035d6:	e8 25 17 00 00       	call   80104d00 <wakeup>
  }
  release(&log.lock);
801035db:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801035e2:	e8 71 19 00 00       	call   80104f58 <release>

  if(do_commit){
801035e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035eb:	74 33                	je     80103620 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035ed:	e8 db 00 00 00       	call   801036cd <commit>
    acquire(&log.lock);
801035f2:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801035f9:	e8 f9 18 00 00       	call   80104ef7 <acquire>
    log.committing = 0;
801035fe:	c7 05 a0 22 11 80 00 	movl   $0x0,0x801122a0
80103605:	00 00 00 
    wakeup(&log);
80103608:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010360f:	e8 ec 16 00 00       	call   80104d00 <wakeup>
    release(&log.lock);
80103614:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010361b:	e8 38 19 00 00       	call   80104f58 <release>
  }
}
80103620:	c9                   	leave  
80103621:	c3                   	ret    

80103622 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103622:	55                   	push   %ebp
80103623:	89 e5                	mov    %esp,%ebp
80103625:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103628:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010362f:	e9 89 00 00 00       	jmp    801036bd <write_log+0x9b>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103634:	a1 94 22 11 80       	mov    0x80112294,%eax
80103639:	03 45 ec             	add    -0x14(%ebp),%eax
8010363c:	83 c0 01             	add    $0x1,%eax
8010363f:	89 c2                	mov    %eax,%edx
80103641:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103646:	89 54 24 04          	mov    %edx,0x4(%esp)
8010364a:	89 04 24             	mov    %eax,(%esp)
8010364d:	e8 55 cb ff ff       	call   801001a7 <bread>
80103652:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103655:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103658:	83 c0 10             	add    $0x10,%eax
8010365b:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103662:	89 c2                	mov    %eax,%edx
80103664:	a1 a4 22 11 80       	mov    0x801122a4,%eax
80103669:	89 54 24 04          	mov    %edx,0x4(%esp)
8010366d:	89 04 24             	mov    %eax,(%esp)
80103670:	e8 32 cb ff ff       	call   801001a7 <bread>
80103675:	89 45 f4             	mov    %eax,-0xc(%ebp)
    memmove(to->data, from->data, BSIZE);
80103678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010367b:	8d 50 18             	lea    0x18(%eax),%edx
8010367e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103681:	83 c0 18             	add    $0x18,%eax
80103684:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010368b:	00 
8010368c:	89 54 24 04          	mov    %edx,0x4(%esp)
80103690:	89 04 24             	mov    %eax,(%esp)
80103693:	e8 89 1b 00 00       	call   80105221 <memmove>
    bwrite(to);  // write the log
80103698:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010369b:	89 04 24             	mov    %eax,(%esp)
8010369e:	e8 3b cb ff ff       	call   801001de <bwrite>
    brelse(from); 
801036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036a6:	89 04 24             	mov    %eax,(%esp)
801036a9:	e8 6a cb ff ff       	call   80100218 <brelse>
    brelse(to);
801036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b1:	89 04 24             	mov    %eax,(%esp)
801036b4:	e8 5f cb ff ff       	call   80100218 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801036bd:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036c5:	0f 8f 69 ff ff ff    	jg     80103634 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036cb:	c9                   	leave  
801036cc:	c3                   	ret    

801036cd <commit>:

static void
commit()
{
801036cd:	55                   	push   %ebp
801036ce:	89 e5                	mov    %esp,%ebp
801036d0:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036d3:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801036d8:	85 c0                	test   %eax,%eax
801036da:	7e 1e                	jle    801036fa <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801036dc:	e8 41 ff ff ff       	call   80103622 <write_log>
    write_head();    // Write header to disk -- the real commit
801036e1:	e8 74 fd ff ff       	call   8010345a <write_head>
    install_trans(); // Now install writes to home locations
801036e6:	e8 55 fc ff ff       	call   80103340 <install_trans>
    log.lh.n = 0; 
801036eb:	c7 05 a8 22 11 80 00 	movl   $0x0,0x801122a8
801036f2:	00 00 00 
    write_head();    // Erase the transaction from the log
801036f5:	e8 60 fd ff ff       	call   8010345a <write_head>
  }
}
801036fa:	c9                   	leave  
801036fb:	c3                   	ret    

801036fc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036fc:	55                   	push   %ebp
801036fd:	89 e5                	mov    %esp,%ebp
801036ff:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103702:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103707:	83 f8 1d             	cmp    $0x1d,%eax
8010370a:	7f 12                	jg     8010371e <log_write+0x22>
8010370c:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103711:	8b 15 98 22 11 80    	mov    0x80112298,%edx
80103717:	83 ea 01             	sub    $0x1,%edx
8010371a:	39 d0                	cmp    %edx,%eax
8010371c:	7c 0c                	jl     8010372a <log_write+0x2e>
    panic("too big a transaction");
8010371e:	c7 04 24 6b 87 10 80 	movl   $0x8010876b,(%esp)
80103725:	e8 13 ce ff ff       	call   8010053d <panic>
  if (log.outstanding < 1)
8010372a:	a1 9c 22 11 80       	mov    0x8011229c,%eax
8010372f:	85 c0                	test   %eax,%eax
80103731:	7f 0c                	jg     8010373f <log_write+0x43>
    panic("log_write outside of trans");
80103733:	c7 04 24 81 87 10 80 	movl   $0x80108781,(%esp)
8010373a:	e8 fe cd ff ff       	call   8010053d <panic>

  acquire(&log.lock);
8010373f:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80103746:	e8 ac 17 00 00       	call   80104ef7 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010374b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103752:	eb 1d                	jmp    80103771 <log_write+0x75>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103757:	83 c0 10             	add    $0x10,%eax
8010375a:	8b 04 85 6c 22 11 80 	mov    -0x7feedd94(,%eax,4),%eax
80103761:	89 c2                	mov    %eax,%edx
80103763:	8b 45 08             	mov    0x8(%ebp),%eax
80103766:	8b 40 08             	mov    0x8(%eax),%eax
80103769:	39 c2                	cmp    %eax,%edx
8010376b:	74 10                	je     8010377d <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010376d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103771:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103776:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103779:	7f d9                	jg     80103754 <log_write+0x58>
8010377b:	eb 01                	jmp    8010377e <log_write+0x82>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010377d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010377e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103781:	8b 45 08             	mov    0x8(%ebp),%eax
80103784:	8b 40 08             	mov    0x8(%eax),%eax
80103787:	83 c2 10             	add    $0x10,%edx
8010378a:	89 04 95 6c 22 11 80 	mov    %eax,-0x7feedd94(,%edx,4)
  if (i == log.lh.n)
80103791:	a1 a8 22 11 80       	mov    0x801122a8,%eax
80103796:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103799:	75 0d                	jne    801037a8 <log_write+0xac>
    log.lh.n++;
8010379b:	a1 a8 22 11 80       	mov    0x801122a8,%eax
801037a0:	83 c0 01             	add    $0x1,%eax
801037a3:	a3 a8 22 11 80       	mov    %eax,0x801122a8
  b->flags |= B_DIRTY; // prevent eviction
801037a8:	8b 45 08             	mov    0x8(%ebp),%eax
801037ab:	8b 00                	mov    (%eax),%eax
801037ad:	89 c2                	mov    %eax,%edx
801037af:	83 ca 04             	or     $0x4,%edx
801037b2:	8b 45 08             	mov    0x8(%ebp),%eax
801037b5:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037b7:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801037be:	e8 95 17 00 00       	call   80104f58 <release>
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	00 00                	add    %al,(%eax)
	...

801037c8 <v2p>:
801037c8:	55                   	push   %ebp
801037c9:	89 e5                	mov    %esp,%ebp
801037cb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ce:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037d3:	5d                   	pop    %ebp
801037d4:	c3                   	ret    

801037d5 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801037d5:	55                   	push   %ebp
801037d6:	89 e5                	mov    %esp,%ebp
801037d8:	8b 45 08             	mov    0x8(%ebp),%eax
801037db:	2d 00 00 00 80       	sub    $0x80000000,%eax
801037e0:	5d                   	pop    %ebp
801037e1:	c3                   	ret    

801037e2 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801037e2:	55                   	push   %ebp
801037e3:	89 e5                	mov    %esp,%ebp
801037e5:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037e8:	8b 55 08             	mov    0x8(%ebp),%edx
801037eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801037ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801037f1:	f0 87 02             	lock xchg %eax,(%edx)
801037f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801037f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801037fa:	c9                   	leave  
801037fb:	c3                   	ret    

801037fc <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801037fc:	55                   	push   %ebp
801037fd:	89 e5                	mov    %esp,%ebp
801037ff:	83 e4 f0             	and    $0xfffffff0,%esp
80103802:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103805:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010380c:	80 
8010380d:	c7 04 24 3c 51 11 80 	movl   $0x8011513c,(%esp)
80103814:	e8 84 f2 ff ff       	call   80102a9d <kinit1>
  kvmalloc();      // kernel page table
80103819:	e8 11 45 00 00       	call   80107d2f <kvmalloc>
  mpinit();        // collect info about this machine
8010381e:	e8 41 04 00 00       	call   80103c64 <mpinit>
  lapicinit();
80103823:	e8 e1 f5 ff ff       	call   80102e09 <lapicinit>
  seginit();       // set up segments
80103828:	e8 a4 3e 00 00       	call   801076d1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010382d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103833:	0f b6 00             	movzbl (%eax),%eax
80103836:	0f b6 c0             	movzbl %al,%eax
80103839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010383d:	c7 04 24 9c 87 10 80 	movl   $0x8010879c,(%esp)
80103844:	e8 54 cb ff ff       	call   8010039d <cprintf>
  picinit();       // interrupt controller
80103849:	e8 7c 06 00 00       	call   80103eca <picinit>
  ioapicinit();    // another interrupt controller
8010384e:	e8 3a f1 ff ff       	call   8010298d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103853:	e8 62 d2 ff ff       	call   80100aba <consoleinit>
  uartinit();      // serial port
80103858:	e8 be 31 00 00       	call   80106a1b <uartinit>
  pinit();         // process table
8010385d:	e8 78 0b 00 00       	call   801043da <pinit>
  tvinit();        // trap vectors
80103862:	e8 67 2d 00 00       	call   801065ce <tvinit>
  binit();         // buffer cache
80103867:	e8 c8 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010386c:	e8 bb d6 ff ff       	call   80100f2c <fileinit>
  ideinit();       // disk
80103871:	e8 46 ed ff ff       	call   801025bc <ideinit>
  if(!ismp)
80103876:	a1 44 23 11 80       	mov    0x80112344,%eax
8010387b:	85 c0                	test   %eax,%eax
8010387d:	75 05                	jne    80103884 <main+0x88>
    timerinit();   // uniprocessor timer
8010387f:	e8 92 2c 00 00       	call   80106516 <timerinit>
  startothers();   // start other processors
80103884:	e8 7f 00 00 00       	call   80103908 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103889:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103890:	8e 
80103891:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103898:	e8 38 f2 ff ff       	call   80102ad5 <kinit2>
  userinit();      // first user process
8010389d:	e8 54 0c 00 00       	call   801044f6 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038a2:	e8 1a 00 00 00       	call   801038c1 <mpmain>

801038a7 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038a7:	55                   	push   %ebp
801038a8:	89 e5                	mov    %esp,%ebp
801038aa:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038ad:	e8 94 44 00 00       	call   80107d46 <switchkvm>
  seginit();
801038b2:	e8 1a 3e 00 00       	call   801076d1 <seginit>
  lapicinit();
801038b7:	e8 4d f5 ff ff       	call   80102e09 <lapicinit>
  mpmain();
801038bc:	e8 00 00 00 00       	call   801038c1 <mpmain>

801038c1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038c1:	55                   	push   %ebp
801038c2:	89 e5                	mov    %esp,%ebp
801038c4:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801038c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038cd:	0f b6 00             	movzbl (%eax),%eax
801038d0:	0f b6 c0             	movzbl %al,%eax
801038d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801038d7:	c7 04 24 b3 87 10 80 	movl   $0x801087b3,(%esp)
801038de:	e8 ba ca ff ff       	call   8010039d <cprintf>
  idtinit();       // load idt register
801038e3:	e8 56 2e 00 00       	call   8010673e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801038e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038ee:	05 a8 00 00 00       	add    $0xa8,%eax
801038f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801038fa:	00 
801038fb:	89 04 24             	mov    %eax,(%esp)
801038fe:	e8 df fe ff ff       	call   801037e2 <xchg>
  scheduler();     // start running processes
80103903:	e8 61 11 00 00       	call   80104a69 <scheduler>

80103908 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103908:	55                   	push   %ebp
80103909:	89 e5                	mov    %esp,%ebp
8010390b:	53                   	push   %ebx
8010390c:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010390f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103916:	e8 ba fe ff ff       	call   801037d5 <p2v>
8010391b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010391e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103923:	89 44 24 08          	mov    %eax,0x8(%esp)
80103927:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010392e:	80 
8010392f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103932:	89 04 24             	mov    %eax,(%esp)
80103935:	e8 e7 18 00 00       	call   80105221 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010393a:	c7 45 f0 60 23 11 80 	movl   $0x80112360,-0x10(%ebp)
80103941:	e9 85 00 00 00       	jmp    801039cb <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103946:	e8 1a f6 ff ff       	call   80102f65 <cpunum>
8010394b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103951:	05 60 23 11 80       	add    $0x80112360,%eax
80103956:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103959:	74 68                	je     801039c3 <startothers+0xbb>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010395b:	e8 6e f2 ff ff       	call   80102bce <kalloc>
80103960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103963:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103966:	83 e8 04             	sub    $0x4,%eax
80103969:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010396c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103972:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103974:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103977:	83 e8 08             	sub    $0x8,%eax
8010397a:	c7 00 a7 38 10 80    	movl   $0x801038a7,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103980:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103983:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103986:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
8010398d:	e8 36 fe ff ff       	call   801037c8 <v2p>
80103992:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103994:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103997:	89 04 24             	mov    %eax,(%esp)
8010399a:	e8 29 fe ff ff       	call   801037c8 <v2p>
8010399f:	8b 55 f0             	mov    -0x10(%ebp),%edx
801039a2:	0f b6 12             	movzbl (%edx),%edx
801039a5:	0f b6 d2             	movzbl %dl,%edx
801039a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ac:	89 14 24             	mov    %edx,(%esp)
801039af:	e8 37 f6 ff ff       	call   80102feb <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	74 f3                	je     801039b4 <startothers+0xac>
801039c1:	eb 01                	jmp    801039c4 <startothers+0xbc>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801039c3:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801039c4:	81 45 f0 bc 00 00 00 	addl   $0xbc,-0x10(%ebp)
801039cb:	a1 40 29 11 80       	mov    0x80112940,%eax
801039d0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039d6:	05 60 23 11 80       	add    $0x80112360,%eax
801039db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801039de:	0f 87 62 ff ff ff    	ja     80103946 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801039e4:	83 c4 24             	add    $0x24,%esp
801039e7:	5b                   	pop    %ebx
801039e8:	5d                   	pop    %ebp
801039e9:	c3                   	ret    
	...

801039ec <p2v>:
801039ec:	55                   	push   %ebp
801039ed:	89 e5                	mov    %esp,%ebp
801039ef:	8b 45 08             	mov    0x8(%ebp),%eax
801039f2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801039f7:	5d                   	pop    %ebp
801039f8:	c3                   	ret    

801039f9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801039f9:	55                   	push   %ebp
801039fa:	89 e5                	mov    %esp,%ebp
801039fc:	83 ec 14             	sub    $0x14,%esp
801039ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103a02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a0a:	89 c2                	mov    %eax,%edx
80103a0c:	ec                   	in     (%dx),%al
80103a0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a14:	c9                   	leave  
80103a15:	c3                   	ret    

80103a16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a16:	55                   	push   %ebp
80103a17:	89 e5                	mov    %esp,%ebp
80103a19:	83 ec 08             	sub    $0x8,%esp
80103a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80103a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a31:	ee                   	out    %al,(%dx)
}
80103a32:	c9                   	leave  
80103a33:	c3                   	ret    

80103a34 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a37:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103a3c:	89 c2                	mov    %eax,%edx
80103a3e:	b8 60 23 11 80       	mov    $0x80112360,%eax
80103a43:	89 d1                	mov    %edx,%ecx
80103a45:	29 c1                	sub    %eax,%ecx
80103a47:	89 c8                	mov    %ecx,%eax
80103a49:	c1 f8 02             	sar    $0x2,%eax
80103a4c:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a52:	5d                   	pop    %ebp
80103a53:	c3                   	ret    

80103a54 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(i=0; i<len; i++)
80103a61:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80103a68:	eb 13                	jmp    80103a7d <sum+0x29>
    sum += addr[i];
80103a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103a6d:	03 45 08             	add    0x8(%ebp),%eax
80103a70:	0f b6 00             	movzbl (%eax),%eax
80103a73:	0f b6 c0             	movzbl %al,%eax
80103a76:	01 45 fc             	add    %eax,-0x4(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103a79:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80103a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103a80:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103a83:	7c e5                	jl     80103a6a <sum+0x16>
    sum += addr[i];
  return sum;
80103a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a88:	c9                   	leave  
80103a89:	c3                   	ret    

80103a8a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a8a:	55                   	push   %ebp
80103a8b:	89 e5                	mov    %esp,%ebp
80103a8d:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103a90:	8b 45 08             	mov    0x8(%ebp),%eax
80103a93:	89 04 24             	mov    %eax,(%esp)
80103a96:	e8 51 ff ff ff       	call   801039ec <p2v>
80103a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  e = addr+len;
80103a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103aa1:	03 45 f4             	add    -0xc(%ebp),%eax
80103aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103aad:	eb 3f                	jmp    80103aee <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103aaf:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103ab6:	00 
80103ab7:	c7 44 24 04 c4 87 10 	movl   $0x801087c4,0x4(%esp)
80103abe:	80 
80103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac2:	89 04 24             	mov    %eax,(%esp)
80103ac5:	e8 fb 16 00 00       	call   801051c5 <memcmp>
80103aca:	85 c0                	test   %eax,%eax
80103acc:	75 1c                	jne    80103aea <mpsearch1+0x60>
80103ace:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103ad5:	00 
80103ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad9:	89 04 24             	mov    %eax,(%esp)
80103adc:	e8 73 ff ff ff       	call   80103a54 <sum>
80103ae1:	84 c0                	test   %al,%al
80103ae3:	75 05                	jne    80103aea <mpsearch1+0x60>
      return (struct mp*)p;
80103ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae8:	eb 11                	jmp    80103afb <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103aea:	83 45 f0 10          	addl   $0x10,-0x10(%ebp)
80103aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103af4:	72 b9                	jb     80103aaf <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103afb:	c9                   	leave  
80103afc:	c3                   	ret    

80103afd <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103afd:	55                   	push   %ebp
80103afe:	89 e5                	mov    %esp,%ebp
80103b00:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b03:	c7 45 ec 00 04 00 80 	movl   $0x80000400,-0x14(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b0d:	83 c0 0f             	add    $0xf,%eax
80103b10:	0f b6 00             	movzbl (%eax),%eax
80103b13:	0f b6 c0             	movzbl %al,%eax
80103b16:	89 c2                	mov    %eax,%edx
80103b18:	c1 e2 08             	shl    $0x8,%edx
80103b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b1e:	83 c0 0e             	add    $0xe,%eax
80103b21:	0f b6 00             	movzbl (%eax),%eax
80103b24:	0f b6 c0             	movzbl %al,%eax
80103b27:	09 d0                	or     %edx,%eax
80103b29:	c1 e0 04             	shl    $0x4,%eax
80103b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b33:	74 21                	je     80103b56 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b35:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b3c:	00 
80103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b40:	89 04 24             	mov    %eax,(%esp)
80103b43:	e8 42 ff ff ff       	call   80103a8a <mpsearch1>
80103b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b4f:	74 50                	je     80103ba1 <mpsearch+0xa4>
      return mp;
80103b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b54:	eb 5f                	jmp    80103bb5 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b59:	83 c0 14             	add    $0x14,%eax
80103b5c:	0f b6 00             	movzbl (%eax),%eax
80103b5f:	0f b6 c0             	movzbl %al,%eax
80103b62:	89 c2                	mov    %eax,%edx
80103b64:	c1 e2 08             	shl    $0x8,%edx
80103b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b6a:	83 c0 13             	add    $0x13,%eax
80103b6d:	0f b6 00             	movzbl (%eax),%eax
80103b70:	0f b6 c0             	movzbl %al,%eax
80103b73:	09 d0                	or     %edx,%eax
80103b75:	c1 e0 0a             	shl    $0xa,%eax
80103b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7e:	2d 00 04 00 00       	sub    $0x400,%eax
80103b83:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b8a:	00 
80103b8b:	89 04 24             	mov    %eax,(%esp)
80103b8e:	e8 f7 fe ff ff       	call   80103a8a <mpsearch1>
80103b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b9a:	74 05                	je     80103ba1 <mpsearch+0xa4>
      return mp;
80103b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9f:	eb 14                	jmp    80103bb5 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ba1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ba8:	00 
80103ba9:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103bb0:	e8 d5 fe ff ff       	call   80103a8a <mpsearch1>
}
80103bb5:	c9                   	leave  
80103bb6:	c3                   	ret    

80103bb7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bb7:	55                   	push   %ebp
80103bb8:	89 e5                	mov    %esp,%ebp
80103bba:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bbd:	e8 3b ff ff ff       	call   80103afd <mpsearch>
80103bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bc9:	74 0a                	je     80103bd5 <mpconfig+0x1e>
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	8b 40 04             	mov    0x4(%eax),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	75 0a                	jne    80103bdf <mpconfig+0x28>
    return 0;
80103bd5:	b8 00 00 00 00       	mov    $0x0,%eax
80103bda:	e9 83 00 00 00       	jmp    80103c62 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be2:	8b 40 04             	mov    0x4(%eax),%eax
80103be5:	89 04 24             	mov    %eax,(%esp)
80103be8:	e8 ff fd ff ff       	call   801039ec <p2v>
80103bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103bf0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103bf7:	00 
80103bf8:	c7 44 24 04 c9 87 10 	movl   $0x801087c9,0x4(%esp)
80103bff:	80 
80103c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c03:	89 04 24             	mov    %eax,(%esp)
80103c06:	e8 ba 15 00 00       	call   801051c5 <memcmp>
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	74 07                	je     80103c16 <mpconfig+0x5f>
    return 0;
80103c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c14:	eb 4c                	jmp    80103c62 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c19:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c1d:	3c 01                	cmp    $0x1,%al
80103c1f:	74 12                	je     80103c33 <mpconfig+0x7c>
80103c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c24:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c28:	3c 04                	cmp    $0x4,%al
80103c2a:	74 07                	je     80103c33 <mpconfig+0x7c>
    return 0;
80103c2c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c31:	eb 2f                	jmp    80103c62 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c36:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c3a:	0f b7 d0             	movzwl %ax,%edx
80103c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c40:	89 54 24 04          	mov    %edx,0x4(%esp)
80103c44:	89 04 24             	mov    %eax,(%esp)
80103c47:	e8 08 fe ff ff       	call   80103a54 <sum>
80103c4c:	84 c0                	test   %al,%al
80103c4e:	74 07                	je     80103c57 <mpconfig+0xa0>
    return 0;
80103c50:	b8 00 00 00 00       	mov    $0x0,%eax
80103c55:	eb 0b                	jmp    80103c62 <mpconfig+0xab>
  *pmp = mp;
80103c57:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c5d:	89 10                	mov    %edx,(%eax)
  return conf;
80103c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c62:	c9                   	leave  
80103c63:	c3                   	ret    

80103c64 <mpinit>:

void
mpinit(void)
{
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103c6a:	c7 05 44 b6 10 80 60 	movl   $0x80112360,0x8010b644
80103c71:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103c74:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103c77:	89 04 24             	mov    %eax,(%esp)
80103c7a:	e8 38 ff ff ff       	call   80103bb7 <mpconfig>
80103c7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c86:	0f 84 9d 01 00 00    	je     80103e29 <mpinit+0x1c5>
    return;
  ismp = 1;
80103c8c:	c7 05 44 23 11 80 01 	movl   $0x1,0x80112344
80103c93:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c99:	8b 40 24             	mov    0x24(%eax),%eax
80103c9c:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ca4:	83 c0 2c             	add    $0x2c,%eax
80103ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cb0:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cb4:	0f b7 c0             	movzwl %ax,%eax
80103cb7:	8d 04 02             	lea    (%edx,%eax,1),%eax
80103cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103cbd:	e9 f2 00 00 00       	jmp    80103db4 <mpinit+0x150>
    switch(*p){
80103cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cc5:	0f b6 00             	movzbl (%eax),%eax
80103cc8:	0f b6 c0             	movzbl %al,%eax
80103ccb:	83 f8 04             	cmp    $0x4,%eax
80103cce:	0f 87 bd 00 00 00    	ja     80103d91 <mpinit+0x12d>
80103cd4:	8b 04 85 0c 88 10 80 	mov    -0x7fef77f4(,%eax,4),%eax
80103cdb:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(ncpu != proc->apicid){
80103ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cea:	0f b6 d0             	movzbl %al,%edx
80103ced:	a1 40 29 11 80       	mov    0x80112940,%eax
80103cf2:	39 c2                	cmp    %eax,%edx
80103cf4:	74 2d                	je     80103d23 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf9:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cfd:	0f b6 d0             	movzbl %al,%edx
80103d00:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d05:	89 54 24 08          	mov    %edx,0x8(%esp)
80103d09:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d0d:	c7 04 24 ce 87 10 80 	movl   $0x801087ce,(%esp)
80103d14:	e8 84 c6 ff ff       	call   8010039d <cprintf>
        ismp = 0;
80103d19:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103d20:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d26:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d2a:	0f b6 c0             	movzbl %al,%eax
80103d2d:	83 e0 02             	and    $0x2,%eax
80103d30:	85 c0                	test   %eax,%eax
80103d32:	74 15                	je     80103d49 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103d34:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d39:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d3f:	05 60 23 11 80       	add    $0x80112360,%eax
80103d44:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103d49:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d4e:	8b 15 40 29 11 80    	mov    0x80112940,%edx
80103d54:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d5a:	88 90 60 23 11 80    	mov    %dl,-0x7feedca0(%eax)
      ncpu++;
80103d60:	a1 40 29 11 80       	mov    0x80112940,%eax
80103d65:	83 c0 01             	add    $0x1,%eax
80103d68:	a3 40 29 11 80       	mov    %eax,0x80112940
      p += sizeof(struct mpproc);
80103d6d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
      continue;
80103d71:	eb 41                	jmp    80103db4 <mpinit+0x150>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
      ioapicid = ioapic->apicno;
80103d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d80:	a2 40 23 11 80       	mov    %al,0x80112340
      p += sizeof(struct mpioapic);
80103d85:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103d89:	eb 29                	jmp    80103db4 <mpinit+0x150>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d8b:	83 45 e4 08          	addl   $0x8,-0x1c(%ebp)
      continue;
80103d8f:	eb 23                	jmp    80103db4 <mpinit+0x150>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d94:	0f b6 00             	movzbl (%eax),%eax
80103d97:	0f b6 c0             	movzbl %al,%eax
80103d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d9e:	c7 04 24 ec 87 10 80 	movl   $0x801087ec,(%esp)
80103da5:	e8 f3 c5 ff ff       	call   8010039d <cprintf>
      ismp = 0;
80103daa:	c7 05 44 23 11 80 00 	movl   $0x0,0x80112344
80103db1:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103db7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103dba:	0f 82 02 ff ff ff    	jb     80103cc2 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dc0:	a1 44 23 11 80       	mov    0x80112344,%eax
80103dc5:	85 c0                	test   %eax,%eax
80103dc7:	75 1d                	jne    80103de6 <mpinit+0x182>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103dc9:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103dd0:	00 00 00 
    lapic = 0;
80103dd3:	c7 05 5c 22 11 80 00 	movl   $0x0,0x8011225c
80103dda:	00 00 00 
    ioapicid = 0;
80103ddd:	c6 05 40 23 11 80 00 	movb   $0x0,0x80112340
    return;
80103de4:	eb 44                	jmp    80103e2a <mpinit+0x1c6>
  }

  if(mp->imcrp){
80103de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103de9:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ded:	84 c0                	test   %al,%al
80103def:	74 39                	je     80103e2a <mpinit+0x1c6>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103df1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103df8:	00 
80103df9:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103e00:	e8 11 fc ff ff       	call   80103a16 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e05:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e0c:	e8 e8 fb ff ff       	call   801039f9 <inb>
80103e11:	83 c8 01             	or     $0x1,%eax
80103e14:	0f b6 c0             	movzbl %al,%eax
80103e17:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e1b:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103e22:	e8 ef fb ff ff       	call   80103a16 <outb>
80103e27:	eb 01                	jmp    80103e2a <mpinit+0x1c6>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103e29:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e2a:	c9                   	leave  
80103e2b:	c3                   	ret    

80103e2c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e2c:	55                   	push   %ebp
80103e2d:	89 e5                	mov    %esp,%ebp
80103e2f:	83 ec 08             	sub    $0x8,%esp
80103e32:	8b 55 08             	mov    0x8(%ebp),%edx
80103e35:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e38:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e3c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e3f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e43:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e47:	ee                   	out    %al,(%dx)
}
80103e48:	c9                   	leave  
80103e49:	c3                   	ret    

80103e4a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e4a:	55                   	push   %ebp
80103e4b:	89 e5                	mov    %esp,%ebp
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	8b 45 08             	mov    0x8(%ebp),%eax
80103e53:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e57:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e5b:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e61:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e65:	0f b6 c0             	movzbl %al,%eax
80103e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e73:	e8 b4 ff ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e7c:	66 c1 e8 08          	shr    $0x8,%ax
80103e80:	0f b6 c0             	movzbl %al,%eax
80103e83:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e87:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e8e:	e8 99 ff ff ff       	call   80103e2c <outb>
}
80103e93:	c9                   	leave  
80103e94:	c3                   	ret    

80103e95 <picenable>:

void
picenable(int irq)
{
80103e95:	55                   	push   %ebp
80103e96:	89 e5                	mov    %esp,%ebp
80103e98:	53                   	push   %ebx
80103e99:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9f:	ba 01 00 00 00       	mov    $0x1,%edx
80103ea4:	89 d3                	mov    %edx,%ebx
80103ea6:	89 c1                	mov    %eax,%ecx
80103ea8:	d3 e3                	shl    %cl,%ebx
80103eaa:	89 d8                	mov    %ebx,%eax
80103eac:	89 c2                	mov    %eax,%edx
80103eae:	f7 d2                	not    %edx
80103eb0:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103eb7:	21 d0                	and    %edx,%eax
80103eb9:	0f b7 c0             	movzwl %ax,%eax
80103ebc:	89 04 24             	mov    %eax,(%esp)
80103ebf:	e8 86 ff ff ff       	call   80103e4a <picsetmask>
}
80103ec4:	83 c4 04             	add    $0x4,%esp
80103ec7:	5b                   	pop    %ebx
80103ec8:	5d                   	pop    %ebp
80103ec9:	c3                   	ret    

80103eca <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103eca:	55                   	push   %ebp
80103ecb:	89 e5                	mov    %esp,%ebp
80103ecd:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ed0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ed7:	00 
80103ed8:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103edf:	e8 48 ff ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, 0xFF);
80103ee4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103eeb:	00 
80103eec:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ef3:	e8 34 ff ff ff       	call   80103e2c <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ef8:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103eff:	00 
80103f00:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f07:	e8 20 ff ff ff       	call   80103e2c <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f0c:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103f13:	00 
80103f14:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f1b:	e8 0c ff ff ff       	call   80103e2c <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f20:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103f27:	00 
80103f28:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f2f:	e8 f8 fe ff ff       	call   80103e2c <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f34:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f3b:	00 
80103f3c:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f43:	e8 e4 fe ff ff       	call   80103e2c <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f48:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f4f:	00 
80103f50:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f57:	e8 d0 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f5c:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f63:	00 
80103f64:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f6b:	e8 bc fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f70:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f77:	00 
80103f78:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f7f:	e8 a8 fe ff ff       	call   80103e2c <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f84:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f8b:	00 
80103f8c:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f93:	e8 94 fe ff ff       	call   80103e2c <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f98:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f9f:	00 
80103fa0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fa7:	e8 80 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103fac:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fb3:	00 
80103fb4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103fbb:	e8 6c fe ff ff       	call   80103e2c <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103fc0:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103fc7:	00 
80103fc8:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fcf:	e8 58 fe ff ff       	call   80103e2c <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103fd4:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103fdb:	00 
80103fdc:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fe3:	e8 44 fe ff ff       	call   80103e2c <outb>

  if(irqmask != 0xFFFF)
80103fe8:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fef:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103ff3:	74 12                	je     80104007 <picinit+0x13d>
    picsetmask(irqmask);
80103ff5:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ffc:	0f b7 c0             	movzwl %ax,%eax
80103fff:	89 04 24             	mov    %eax,(%esp)
80104002:	e8 43 fe ff ff       	call   80103e4a <picsetmask>
}
80104007:	c9                   	leave  
80104008:	c3                   	ret    
80104009:	00 00                	add    %al,(%eax)
	...

8010400c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010400c:	55                   	push   %ebp
8010400d:	89 e5                	mov    %esp,%ebp
8010400f:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80104012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104022:	8b 45 0c             	mov    0xc(%ebp),%eax
80104025:	8b 10                	mov    (%eax),%edx
80104027:	8b 45 08             	mov    0x8(%ebp),%eax
8010402a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010402c:	e8 17 cf ff ff       	call   80100f48 <filealloc>
80104031:	8b 55 08             	mov    0x8(%ebp),%edx
80104034:	89 02                	mov    %eax,(%edx)
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	8b 00                	mov    (%eax),%eax
8010403b:	85 c0                	test   %eax,%eax
8010403d:	0f 84 c8 00 00 00    	je     8010410b <pipealloc+0xff>
80104043:	e8 00 cf ff ff       	call   80100f48 <filealloc>
80104048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010404b:	89 02                	mov    %eax,(%edx)
8010404d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104050:	8b 00                	mov    (%eax),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	0f 84 b1 00 00 00    	je     8010410b <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010405a:	e8 6f eb ff ff       	call   80102bce <kalloc>
8010405f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104062:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104066:	0f 84 9e 00 00 00    	je     8010410a <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104076:	00 00 00 
  p->writeopen = 1;
80104079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407c:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104083:	00 00 00 
  p->nwrite = 0;
80104086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104089:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104090:	00 00 00 
  p->nread = 0;
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010409d:	00 00 00 
  initlock(&p->lock, "pipe");
801040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a3:	c7 44 24 04 20 88 10 	movl   $0x80108820,0x4(%esp)
801040aa:	80 
801040ab:	89 04 24             	mov    %eax,(%esp)
801040ae:	e8 23 0e 00 00       	call   80104ed6 <initlock>
  (*f0)->type = FD_PIPE;
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040be:	8b 45 08             	mov    0x8(%ebp),%eax
801040c1:	8b 00                	mov    (%eax),%eax
801040c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040c7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ca:	8b 00                	mov    (%eax),%eax
801040cc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040d0:	8b 45 08             	mov    0x8(%ebp),%eax
801040d3:	8b 00                	mov    (%eax),%eax
801040d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d8:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040db:	8b 45 0c             	mov    0xc(%ebp),%eax
801040de:	8b 00                	mov    (%eax),%eax
801040e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e9:	8b 00                	mov    (%eax),%eax
801040eb:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f2:	8b 00                	mov    (%eax),%eax
801040f4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fb:	8b 00                	mov    (%eax),%eax
801040fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104100:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104103:	b8 00 00 00 00       	mov    $0x0,%eax
80104108:	eb 43                	jmp    8010414d <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010410a:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
8010410b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010410f:	74 0b                	je     8010411c <pipealloc+0x110>
    kfree((char*)p);
80104111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104114:	89 04 24             	mov    %eax,(%esp)
80104117:	e8 19 ea ff ff       	call   80102b35 <kfree>
  if(*f0)
8010411c:	8b 45 08             	mov    0x8(%ebp),%eax
8010411f:	8b 00                	mov    (%eax),%eax
80104121:	85 c0                	test   %eax,%eax
80104123:	74 0d                	je     80104132 <pipealloc+0x126>
    fileclose(*f0);
80104125:	8b 45 08             	mov    0x8(%ebp),%eax
80104128:	8b 00                	mov    (%eax),%eax
8010412a:	89 04 24             	mov    %eax,(%esp)
8010412d:	e8 bf ce ff ff       	call   80100ff1 <fileclose>
  if(*f1)
80104132:	8b 45 0c             	mov    0xc(%ebp),%eax
80104135:	8b 00                	mov    (%eax),%eax
80104137:	85 c0                	test   %eax,%eax
80104139:	74 0d                	je     80104148 <pipealloc+0x13c>
    fileclose(*f1);
8010413b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413e:	8b 00                	mov    (%eax),%eax
80104140:	89 04 24             	mov    %eax,(%esp)
80104143:	e8 a9 ce ff ff       	call   80100ff1 <fileclose>
  return -1;
80104148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010414d:	c9                   	leave  
8010414e:	c3                   	ret    

8010414f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010414f:	55                   	push   %ebp
80104150:	89 e5                	mov    %esp,%ebp
80104152:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104155:	8b 45 08             	mov    0x8(%ebp),%eax
80104158:	89 04 24             	mov    %eax,(%esp)
8010415b:	e8 97 0d 00 00       	call   80104ef7 <acquire>
  if(writable){
80104160:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104164:	74 1f                	je     80104185 <pipeclose+0x36>
    p->writeopen = 0;
80104166:	8b 45 08             	mov    0x8(%ebp),%eax
80104169:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104170:	00 00 00 
    wakeup(&p->nread);
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
80104176:	05 34 02 00 00       	add    $0x234,%eax
8010417b:	89 04 24             	mov    %eax,(%esp)
8010417e:	e8 7d 0b 00 00       	call   80104d00 <wakeup>
80104183:	eb 1d                	jmp    801041a2 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104185:	8b 45 08             	mov    0x8(%ebp),%eax
80104188:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010418f:	00 00 00 
    wakeup(&p->nwrite);
80104192:	8b 45 08             	mov    0x8(%ebp),%eax
80104195:	05 38 02 00 00       	add    $0x238,%eax
8010419a:	89 04 24             	mov    %eax,(%esp)
8010419d:	e8 5e 0b 00 00       	call   80104d00 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041ab:	85 c0                	test   %eax,%eax
801041ad:	75 25                	jne    801041d4 <pipeclose+0x85>
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041b8:	85 c0                	test   %eax,%eax
801041ba:	75 18                	jne    801041d4 <pipeclose+0x85>
    release(&p->lock);
801041bc:	8b 45 08             	mov    0x8(%ebp),%eax
801041bf:	89 04 24             	mov    %eax,(%esp)
801041c2:	e8 91 0d 00 00       	call   80104f58 <release>
    kfree((char*)p);
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	89 04 24             	mov    %eax,(%esp)
801041cd:	e8 63 e9 ff ff       	call   80102b35 <kfree>
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041d2:	eb 0b                	jmp    801041df <pipeclose+0x90>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801041d4:	8b 45 08             	mov    0x8(%ebp),%eax
801041d7:	89 04 24             	mov    %eax,(%esp)
801041da:	e8 79 0d 00 00       	call   80104f58 <release>
}
801041df:	c9                   	leave  
801041e0:	c3                   	ret    

801041e1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041e1:	55                   	push   %ebp
801041e2:	89 e5                	mov    %esp,%ebp
801041e4:	53                   	push   %ebx
801041e5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	89 04 24             	mov    %eax,(%esp)
801041ee:	e8 04 0d 00 00       	call   80104ef7 <acquire>
  for(i = 0; i < n; i++){
801041f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041fa:	e9 a6 00 00 00       	jmp    801042a5 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104208:	85 c0                	test   %eax,%eax
8010420a:	74 0d                	je     80104219 <pipewrite+0x38>
8010420c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104212:	8b 40 24             	mov    0x24(%eax),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 15                	je     8010422e <pipewrite+0x4d>
        release(&p->lock);
80104219:	8b 45 08             	mov    0x8(%ebp),%eax
8010421c:	89 04 24             	mov    %eax,(%esp)
8010421f:	e8 34 0d 00 00       	call   80104f58 <release>
        return -1;
80104224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104229:	e9 9d 00 00 00       	jmp    801042cb <pipewrite+0xea>
      }
      wakeup(&p->nread);
8010422e:	8b 45 08             	mov    0x8(%ebp),%eax
80104231:	05 34 02 00 00       	add    $0x234,%eax
80104236:	89 04 24             	mov    %eax,(%esp)
80104239:	e8 c2 0a 00 00       	call   80104d00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010423e:	8b 45 08             	mov    0x8(%ebp),%eax
80104241:	8b 55 08             	mov    0x8(%ebp),%edx
80104244:	81 c2 38 02 00 00    	add    $0x238,%edx
8010424a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010424e:	89 14 24             	mov    %edx,(%esp)
80104251:	e8 d0 09 00 00       	call   80104c26 <sleep>
80104256:	eb 01                	jmp    80104259 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104258:	90                   	nop
80104259:	8b 45 08             	mov    0x8(%ebp),%eax
8010425c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104262:	8b 45 08             	mov    0x8(%ebp),%eax
80104265:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010426b:	05 00 02 00 00       	add    $0x200,%eax
80104270:	39 c2                	cmp    %eax,%edx
80104272:	74 8b                	je     801041ff <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104274:	8b 45 08             	mov    0x8(%ebp),%eax
80104277:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010427d:	89 c3                	mov    %eax,%ebx
8010427f:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80104285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104288:	03 55 0c             	add    0xc(%ebp),%edx
8010428b:	0f b6 0a             	movzbl (%edx),%ecx
8010428e:	8b 55 08             	mov    0x8(%ebp),%edx
80104291:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80104295:	8d 50 01             	lea    0x1(%eax),%edx
80104298:	8b 45 08             	mov    0x8(%ebp),%eax
8010429b:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801042a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a8:	3b 45 10             	cmp    0x10(%ebp),%eax
801042ab:	7c ab                	jl     80104258 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042ad:	8b 45 08             	mov    0x8(%ebp),%eax
801042b0:	05 34 02 00 00       	add    $0x234,%eax
801042b5:	89 04 24             	mov    %eax,(%esp)
801042b8:	e8 43 0a 00 00       	call   80104d00 <wakeup>
  release(&p->lock);
801042bd:	8b 45 08             	mov    0x8(%ebp),%eax
801042c0:	89 04 24             	mov    %eax,(%esp)
801042c3:	e8 90 0c 00 00       	call   80104f58 <release>
  return n;
801042c8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042cb:	83 c4 24             	add    $0x24,%esp
801042ce:	5b                   	pop    %ebx
801042cf:	5d                   	pop    %ebp
801042d0:	c3                   	ret    

801042d1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042d1:	55                   	push   %ebp
801042d2:	89 e5                	mov    %esp,%ebp
801042d4:	53                   	push   %ebx
801042d5:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	89 04 24             	mov    %eax,(%esp)
801042de:	e8 14 0c 00 00       	call   80104ef7 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042e3:	eb 3a                	jmp    8010431f <piperead+0x4e>
    if(proc->killed){
801042e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042eb:	8b 40 24             	mov    0x24(%eax),%eax
801042ee:	85 c0                	test   %eax,%eax
801042f0:	74 15                	je     80104307 <piperead+0x36>
      release(&p->lock);
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	89 04 24             	mov    %eax,(%esp)
801042f8:	e8 5b 0c 00 00       	call   80104f58 <release>
      return -1;
801042fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104302:	e9 b6 00 00 00       	jmp    801043bd <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104307:	8b 45 08             	mov    0x8(%ebp),%eax
8010430a:	8b 55 08             	mov    0x8(%ebp),%edx
8010430d:	81 c2 34 02 00 00    	add    $0x234,%edx
80104313:	89 44 24 04          	mov    %eax,0x4(%esp)
80104317:	89 14 24             	mov    %edx,(%esp)
8010431a:	e8 07 09 00 00       	call   80104c26 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010431f:	8b 45 08             	mov    0x8(%ebp),%eax
80104322:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104328:	8b 45 08             	mov    0x8(%ebp),%eax
8010432b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104331:	39 c2                	cmp    %eax,%edx
80104333:	75 0d                	jne    80104342 <piperead+0x71>
80104335:	8b 45 08             	mov    0x8(%ebp),%eax
80104338:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010433e:	85 c0                	test   %eax,%eax
80104340:	75 a3                	jne    801042e5 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104349:	eb 49                	jmp    80104394 <piperead+0xc3>
    if(p->nread == p->nwrite)
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104354:	8b 45 08             	mov    0x8(%ebp),%eax
80104357:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010435d:	39 c2                	cmp    %eax,%edx
8010435f:	74 3d                	je     8010439e <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104364:	89 c2                	mov    %eax,%edx
80104366:	03 55 0c             	add    0xc(%ebp),%edx
80104369:	8b 45 08             	mov    0x8(%ebp),%eax
8010436c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104372:	89 c3                	mov    %eax,%ebx
80104374:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010437a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010437d:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80104382:	88 0a                	mov    %cl,(%edx)
80104384:	8d 50 01             	lea    0x1(%eax),%edx
80104387:	8b 45 08             	mov    0x8(%ebp),%eax
8010438a:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104390:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104397:	3b 45 10             	cmp    0x10(%ebp),%eax
8010439a:	7c af                	jl     8010434b <piperead+0x7a>
8010439c:	eb 01                	jmp    8010439f <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
8010439e:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010439f:	8b 45 08             	mov    0x8(%ebp),%eax
801043a2:	05 38 02 00 00       	add    $0x238,%eax
801043a7:	89 04 24             	mov    %eax,(%esp)
801043aa:	e8 51 09 00 00       	call   80104d00 <wakeup>
  release(&p->lock);
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	89 04 24             	mov    %eax,(%esp)
801043b5:	e8 9e 0b 00 00       	call   80104f58 <release>
  return i;
801043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043bd:	83 c4 24             	add    $0x24,%esp
801043c0:	5b                   	pop    %ebx
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
	...

801043c4 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043ca:	9c                   	pushf  
801043cb:	58                   	pop    %eax
801043cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043d2:	c9                   	leave  
801043d3:	c3                   	ret    

801043d4 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043d7:	fb                   	sti    
}
801043d8:	5d                   	pop    %ebp
801043d9:	c3                   	ret    

801043da <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043da:	55                   	push   %ebp
801043db:	89 e5                	mov    %esp,%ebp
801043dd:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801043e0:	c7 44 24 04 25 88 10 	movl   $0x80108825,0x4(%esp)
801043e7:	80 
801043e8:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801043ef:	e8 e2 0a 00 00       	call   80104ed6 <initlock>
}
801043f4:	c9                   	leave  
801043f5:	c3                   	ret    

801043f6 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801043f6:	55                   	push   %ebp
801043f7:	89 e5                	mov    %esp,%ebp
801043f9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801043fc:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104403:	e8 ef 0a 00 00       	call   80104ef7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104408:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
8010440f:	eb 0e                	jmp    8010441f <allocproc+0x29>
    if(p->state == UNUSED)
80104411:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104414:	8b 40 0c             	mov    0xc(%eax),%eax
80104417:	85 c0                	test   %eax,%eax
80104419:	74 24                	je     8010443f <allocproc+0x49>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441b:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
8010441f:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104424:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104427:	72 e8                	jb     80104411 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104429:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104430:	e8 23 0b 00 00       	call   80104f58 <release>
  return 0;
80104435:	b8 00 00 00 00       	mov    $0x0,%eax
8010443a:	e9 b5 00 00 00       	jmp    801044f4 <allocproc+0xfe>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010443f:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104440:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104443:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010444a:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010444f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104452:	89 42 10             	mov    %eax,0x10(%edx)
80104455:	83 c0 01             	add    $0x1,%eax
80104458:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
8010445d:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104464:	e8 ef 0a 00 00       	call   80104f58 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104469:	e8 60 e7 ff ff       	call   80102bce <kalloc>
8010446e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104471:	89 42 08             	mov    %eax,0x8(%edx)
80104474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104477:	8b 40 08             	mov    0x8(%eax),%eax
8010447a:	85 c0                	test   %eax,%eax
8010447c:	75 11                	jne    8010448f <allocproc+0x99>
    p->state = UNUSED;
8010447e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104481:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104488:	b8 00 00 00 00       	mov    $0x0,%eax
8010448d:	eb 65                	jmp    801044f4 <allocproc+0xfe>
  }
  sp = p->kstack + KSTACKSIZE;
8010448f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104492:	8b 40 08             	mov    0x8(%eax),%eax
80104495:	05 00 10 00 00       	add    $0x1000,%eax
8010449a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010449d:	83 6d f4 4c          	subl   $0x4c,-0xc(%ebp)
  p->tf = (struct trapframe*)sp;
801044a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a7:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044aa:	83 6d f4 04          	subl   $0x4,-0xc(%ebp)
  *(uint*)sp = (uint)trapret;
801044ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b1:	ba 88 65 10 80       	mov    $0x80106588,%edx
801044b6:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044b8:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
  p->context = (struct context*)sp;
801044bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044c2:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044c8:	8b 40 1c             	mov    0x1c(%eax),%eax
801044cb:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801044d2:	00 
801044d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044da:	00 
801044db:	89 04 24             	mov    %eax,(%esp)
801044de:	e8 6b 0c 00 00       	call   8010514e <memset>
  p->context->eip = (uint)forkret;
801044e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044e6:	8b 40 1c             	mov    0x1c(%eax),%eax
801044e9:	ba e7 4b 10 80       	mov    $0x80104be7,%edx
801044ee:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801044f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    

801044f6 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801044f6:	55                   	push   %ebp
801044f7:	89 e5                	mov    %esp,%ebp
801044f9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801044fc:	e8 f5 fe ff ff       	call   801043f6 <allocproc>
80104501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104507:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
8010450c:	e8 60 37 00 00       	call   80107c71 <setupkvm>
80104511:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104514:	89 42 04             	mov    %eax,0x4(%edx)
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 40 04             	mov    0x4(%eax),%eax
8010451d:	85 c0                	test   %eax,%eax
8010451f:	75 0c                	jne    8010452d <userinit+0x37>
    panic("userinit: out of memory?");
80104521:	c7 04 24 2c 88 10 80 	movl   $0x8010882c,(%esp)
80104528:	e8 10 c0 ff ff       	call   8010053d <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010452d:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	8b 40 04             	mov    0x4(%eax),%eax
80104538:	89 54 24 08          	mov    %edx,0x8(%esp)
8010453c:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104543:	80 
80104544:	89 04 24             	mov    %eax,(%esp)
80104547:	e8 7e 39 00 00       	call   80107eca <inituvm>
  p->sz = PGSIZE;
8010454c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454f:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104558:	8b 40 18             	mov    0x18(%eax),%eax
8010455b:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104562:	00 
80104563:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010456a:	00 
8010456b:	89 04 24             	mov    %eax,(%esp)
8010456e:	e8 db 0b 00 00       	call   8010514e <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104576:	8b 40 18             	mov    0x18(%eax),%eax
80104579:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104582:	8b 40 18             	mov    0x18(%eax),%eax
80104585:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010458b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458e:	8b 40 18             	mov    0x18(%eax),%eax
80104591:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104594:	8b 52 18             	mov    0x18(%edx),%edx
80104597:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010459b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a2:	8b 40 18             	mov    0x18(%eax),%eax
801045a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a8:	8b 52 18             	mov    0x18(%edx),%edx
801045ab:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045af:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b6:	8b 40 18             	mov    0x18(%eax),%eax
801045b9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	8b 40 18             	mov    0x18(%eax),%eax
801045c6:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	8b 40 18             	mov    0x18(%eax),%eax
801045d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dd:	83 c0 6c             	add    $0x6c,%eax
801045e0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045e7:	00 
801045e8:	c7 44 24 04 45 88 10 	movl   $0x80108845,0x4(%esp)
801045ef:	80 
801045f0:	89 04 24             	mov    %eax,(%esp)
801045f3:	e8 89 0d 00 00       	call   80105381 <safestrcpy>
  p->cwd = namei("/");
801045f8:	c7 04 24 4e 88 10 80 	movl   $0x8010884e,(%esp)
801045ff:	e8 ab de ff ff       	call   801024af <namei>
80104604:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104607:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104614:	c9                   	leave  
80104615:	c3                   	ret    

80104616 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104616:	55                   	push   %ebp
80104617:	89 e5                	mov    %esp,%ebp
80104619:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
8010461c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104622:	8b 00                	mov    (%eax),%eax
80104624:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104627:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010462b:	7e 34                	jle    80104661 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010462d:	8b 45 08             	mov    0x8(%ebp),%eax
80104630:	89 c2                	mov    %eax,%edx
80104632:	03 55 f4             	add    -0xc(%ebp),%edx
80104635:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463b:	8b 40 04             	mov    0x4(%eax),%eax
8010463e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104642:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104645:	89 54 24 04          	mov    %edx,0x4(%esp)
80104649:	89 04 24             	mov    %eax,(%esp)
8010464c:	e8 f4 39 00 00       	call   80108045 <allocuvm>
80104651:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104658:	75 41                	jne    8010469b <growproc+0x85>
      return -1;
8010465a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010465f:	eb 58                	jmp    801046b9 <growproc+0xa3>
  } else if(n < 0){
80104661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104665:	79 34                	jns    8010469b <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104667:	8b 45 08             	mov    0x8(%ebp),%eax
8010466a:	89 c2                	mov    %eax,%edx
8010466c:	03 55 f4             	add    -0xc(%ebp),%edx
8010466f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104675:	8b 40 04             	mov    0x4(%eax),%eax
80104678:	89 54 24 08          	mov    %edx,0x8(%esp)
8010467c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010467f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104683:	89 04 24             	mov    %eax,(%esp)
80104686:	e8 94 3a 00 00       	call   8010811f <deallocuvm>
8010468b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010468e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104692:	75 07                	jne    8010469b <growproc+0x85>
      return -1;
80104694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104699:	eb 1e                	jmp    801046b9 <growproc+0xa3>
  }
  proc->sz = sz;
8010469b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046a4:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ac:	89 04 24             	mov    %eax,(%esp)
801046af:	e8 af 36 00 00       	call   80107d63 <switchuvm>
  return 0;
801046b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046b9:	c9                   	leave  
801046ba:	c3                   	ret    

801046bb <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046bb:	55                   	push   %ebp
801046bc:	89 e5                	mov    %esp,%ebp
801046be:	57                   	push   %edi
801046bf:	56                   	push   %esi
801046c0:	53                   	push   %ebx
801046c1:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046c4:	e8 2d fd ff ff       	call   801043f6 <allocproc>
801046c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801046cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801046d0:	75 0a                	jne    801046dc <fork+0x21>
    return -1;
801046d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d7:	e9 52 01 00 00       	jmp    8010482e <fork+0x173>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e2:	8b 10                	mov    (%eax),%edx
801046e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ea:	8b 40 04             	mov    0x4(%eax),%eax
801046ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801046f1:	89 04 24             	mov    %eax,(%esp)
801046f4:	e8 b6 3b 00 00       	call   801082af <copyuvm>
801046f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801046fc:	89 42 04             	mov    %eax,0x4(%edx)
801046ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104702:	8b 40 04             	mov    0x4(%eax),%eax
80104705:	85 c0                	test   %eax,%eax
80104707:	75 2c                	jne    80104735 <fork+0x7a>
    kfree(np->kstack);
80104709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010470c:	8b 40 08             	mov    0x8(%eax),%eax
8010470f:	89 04 24             	mov    %eax,(%esp)
80104712:	e8 1e e4 ff ff       	call   80102b35 <kfree>
    np->kstack = 0;
80104717:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010471a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104724:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010472b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104730:	e9 f9 00 00 00       	jmp    8010482e <fork+0x173>
  }
  np->sz = proc->sz;
80104735:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010473b:	8b 10                	mov    (%eax),%edx
8010473d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104740:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104742:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010474c:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010474f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104752:	8b 50 18             	mov    0x18(%eax),%edx
80104755:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010475b:	8b 40 18             	mov    0x18(%eax),%eax
8010475e:	89 c3                	mov    %eax,%ebx
80104760:	b8 13 00 00 00       	mov    $0x13,%eax
80104765:	89 d7                	mov    %edx,%edi
80104767:	89 de                	mov    %ebx,%esi
80104769:	89 c1                	mov    %eax,%ecx
8010476b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010476d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104770:	8b 40 18             	mov    0x18(%eax),%eax
80104773:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010477a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104781:	eb 3d                	jmp    801047c0 <fork+0x105>
    if(proc->ofile[i])
80104783:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104789:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010478c:	83 c2 08             	add    $0x8,%edx
8010478f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104793:	85 c0                	test   %eax,%eax
80104795:	74 25                	je     801047bc <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104797:	8b 5d dc             	mov    -0x24(%ebp),%ebx
8010479a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801047a3:	83 c2 08             	add    $0x8,%edx
801047a6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047aa:	89 04 24             	mov    %eax,(%esp)
801047ad:	e8 f7 c7 ff ff       	call   80100fa9 <filedup>
801047b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b5:	8d 4b 08             	lea    0x8(%ebx),%ecx
801047b8:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047bc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801047c0:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
801047c4:	7e bd                	jle    80104783 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047cc:	8b 40 68             	mov    0x68(%eax),%eax
801047cf:	89 04 24             	mov    %eax,(%esp)
801047d2:	e8 f8 d0 ff ff       	call   801018cf <idup>
801047d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047da:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801047dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e3:	8d 50 6c             	lea    0x6c(%eax),%edx
801047e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047e9:	83 c0 6c             	add    $0x6c,%eax
801047ec:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801047f3:	00 
801047f4:	89 54 24 04          	mov    %edx,0x4(%esp)
801047f8:	89 04 24             	mov    %eax,(%esp)
801047fb:	e8 81 0b 00 00       	call   80105381 <safestrcpy>
 
  pid = np->pid;
80104800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104803:	8b 40 10             	mov    0x10(%eax),%eax
80104806:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104809:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104810:	e8 e2 06 00 00       	call   80104ef7 <acquire>
  np->state = RUNNABLE;
80104815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104818:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
8010481f:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104826:	e8 2d 07 00 00       	call   80104f58 <release>
  
  return pid;
8010482b:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
8010482e:	83 c4 2c             	add    $0x2c,%esp
80104831:	5b                   	pop    %ebx
80104832:	5e                   	pop    %esi
80104833:	5f                   	pop    %edi
80104834:	5d                   	pop    %ebp
80104835:	c3                   	ret    

80104836 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104836:	55                   	push   %ebp
80104837:	89 e5                	mov    %esp,%ebp
80104839:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010483c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104843:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104848:	39 c2                	cmp    %eax,%edx
8010484a:	75 0c                	jne    80104858 <exit+0x22>
    panic("init exiting");
8010484c:	c7 04 24 50 88 10 80 	movl   $0x80108850,(%esp)
80104853:	e8 e5 bc ff ff       	call   8010053d <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104858:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010485f:	eb 44                	jmp    801048a5 <exit+0x6f>
    if(proc->ofile[fd]){
80104861:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104867:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010486a:	83 c2 08             	add    $0x8,%edx
8010486d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104871:	85 c0                	test   %eax,%eax
80104873:	74 2c                	je     801048a1 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104875:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010487e:	83 c2 08             	add    $0x8,%edx
80104881:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104885:	89 04 24             	mov    %eax,(%esp)
80104888:	e8 64 c7 ff ff       	call   80100ff1 <fileclose>
      proc->ofile[fd] = 0;
8010488d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104893:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104896:	83 c2 08             	add    $0x8,%edx
80104899:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048a0:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801048a5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048a9:	7e b6                	jle    80104861 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048ab:	e8 46 ec ff ff       	call   801034f6 <begin_op>
  iput(proc->cwd);
801048b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b6:	8b 40 68             	mov    0x68(%eax),%eax
801048b9:	89 04 24             	mov    %eax,(%esp)
801048bc:	e8 fc d1 ff ff       	call   80101abd <iput>
  end_op();
801048c1:	e8 b2 ec ff ff       	call   80103578 <end_op>
  proc->cwd = 0;
801048c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048cc:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048d3:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
801048da:	e8 18 06 00 00       	call   80104ef7 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801048df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e5:	8b 40 14             	mov    0x14(%eax),%eax
801048e8:	89 04 24             	mov    %eax,(%esp)
801048eb:	e8 d1 03 00 00       	call   80104cc1 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f0:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
801048f7:	eb 38                	jmp    80104931 <exit+0xfb>
    if(p->parent == proc){
801048f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048fc:	8b 50 14             	mov    0x14(%eax),%edx
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	39 c2                	cmp    %eax,%edx
80104907:	75 24                	jne    8010492d <exit+0xf7>
      p->parent = initproc;
80104909:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010490f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104912:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104918:	8b 40 0c             	mov    0xc(%eax),%eax
8010491b:	83 f8 05             	cmp    $0x5,%eax
8010491e:	75 0d                	jne    8010492d <exit+0xf7>
        wakeup1(initproc);
80104920:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104925:	89 04 24             	mov    %eax,(%esp)
80104928:	e8 94 03 00 00       	call   80104cc1 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492d:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104931:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104936:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104939:	72 be                	jb     801048f9 <exit+0xc3>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010493b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104941:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104948:	e8 b6 01 00 00       	call   80104b03 <sched>
  panic("zombie exit");
8010494d:	c7 04 24 5d 88 10 80 	movl   $0x8010885d,(%esp)
80104954:	e8 e4 bb ff ff       	call   8010053d <panic>

80104959 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104959:	55                   	push   %ebp
8010495a:	89 e5                	mov    %esp,%ebp
8010495c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010495f:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104966:	e8 8c 05 00 00       	call   80104ef7 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010496b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104972:	c7 45 ec 94 29 11 80 	movl   $0x80112994,-0x14(%ebp)
80104979:	e9 9a 00 00 00       	jmp    80104a18 <wait+0xbf>
      if(p->parent != proc)
8010497e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104981:	8b 50 14             	mov    0x14(%eax),%edx
80104984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498a:	39 c2                	cmp    %eax,%edx
8010498c:	0f 85 81 00 00 00    	jne    80104a13 <wait+0xba>
        continue;
      havekids = 1;
80104992:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104999:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499c:	8b 40 0c             	mov    0xc(%eax),%eax
8010499f:	83 f8 05             	cmp    $0x5,%eax
801049a2:	75 70                	jne    80104a14 <wait+0xbb>
        // Found one.
        pid = p->pid;
801049a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049a7:	8b 40 10             	mov    0x10(%eax),%eax
801049aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
801049ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049b0:	8b 40 08             	mov    0x8(%eax),%eax
801049b3:	89 04 24             	mov    %eax,(%esp)
801049b6:	e8 7a e1 ff ff       	call   80102b35 <kfree>
        p->kstack = 0;
801049bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049c8:	8b 40 04             	mov    0x4(%eax),%eax
801049cb:	89 04 24             	mov    %eax,(%esp)
801049ce:	e8 08 38 00 00       	call   801081db <freevm>
        p->state = UNUSED;
801049d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801049dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049e0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801049e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ea:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801049f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049f4:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801049f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049fb:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a02:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a09:	e8 4a 05 00 00       	call   80104f58 <release>
        return pid;
80104a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a11:	eb 54                	jmp    80104a67 <wait+0x10e>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104a13:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a14:	83 45 ec 7c          	addl   $0x7c,-0x14(%ebp)
80104a18:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104a1d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104a20:	0f 82 58 ff ff ff    	jb     8010497e <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a2a:	74 0d                	je     80104a39 <wait+0xe0>
80104a2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a32:	8b 40 24             	mov    0x24(%eax),%eax
80104a35:	85 c0                	test   %eax,%eax
80104a37:	74 13                	je     80104a4c <wait+0xf3>
      release(&ptable.lock);
80104a39:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a40:	e8 13 05 00 00       	call   80104f58 <release>
      return -1;
80104a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4a:	eb 1b                	jmp    80104a67 <wait+0x10e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a52:	c7 44 24 04 60 29 11 	movl   $0x80112960,0x4(%esp)
80104a59:	80 
80104a5a:	89 04 24             	mov    %eax,(%esp)
80104a5d:	e8 c4 01 00 00       	call   80104c26 <sleep>
  }
80104a62:	e9 04 ff ff ff       	jmp    8010496b <wait+0x12>
}
80104a67:	c9                   	leave  
80104a68:	c3                   	ret    

80104a69 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a69:	55                   	push   %ebp
80104a6a:	89 e5                	mov    %esp,%ebp
80104a6c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a6f:	e8 60 f9 ff ff       	call   801043d4 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a74:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104a7b:	e8 77 04 00 00       	call   80104ef7 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a80:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104a87:	eb 5f                	jmp    80104ae8 <scheduler+0x7f>
      if(p->state != RUNNABLE)
80104a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a8f:	83 f8 03             	cmp    $0x3,%eax
80104a92:	75 4f                	jne    80104ae3 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a97:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa0:	89 04 24             	mov    %eax,(%esp)
80104aa3:	e8 bb 32 00 00       	call   80107d63 <switchuvm>
      p->state = RUNNING;
80104aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aab:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104ab2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab8:	8b 40 1c             	mov    0x1c(%eax),%eax
80104abb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104ac2:	83 c2 04             	add    $0x4,%edx
80104ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac9:	89 14 24             	mov    %edx,(%esp)
80104acc:	e8 23 09 00 00       	call   801053f4 <swtch>
      switchkvm();
80104ad1:	e8 70 32 00 00       	call   80107d46 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104ad6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104add:	00 00 00 00 
80104ae1:	eb 01                	jmp    80104ae4 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104ae3:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae4:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104ae8:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104aed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104af0:	72 97                	jb     80104a89 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104af2:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104af9:	e8 5a 04 00 00       	call   80104f58 <release>

  }
80104afe:	e9 6c ff ff ff       	jmp    80104a6f <scheduler+0x6>

80104b03 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b03:	55                   	push   %ebp
80104b04:	89 e5                	mov    %esp,%ebp
80104b06:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b09:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104b10:	e8 0a 05 00 00       	call   8010501f <holding>
80104b15:	85 c0                	test   %eax,%eax
80104b17:	75 0c                	jne    80104b25 <sched+0x22>
    panic("sched ptable.lock");
80104b19:	c7 04 24 69 88 10 80 	movl   $0x80108869,(%esp)
80104b20:	e8 18 ba ff ff       	call   8010053d <panic>
  if(cpu->ncli != 1)
80104b25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b2b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b31:	83 f8 01             	cmp    $0x1,%eax
80104b34:	74 0c                	je     80104b42 <sched+0x3f>
    panic("sched locks");
80104b36:	c7 04 24 7b 88 10 80 	movl   $0x8010887b,(%esp)
80104b3d:	e8 fb b9 ff ff       	call   8010053d <panic>
  if(proc->state == RUNNING)
80104b42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b48:	8b 40 0c             	mov    0xc(%eax),%eax
80104b4b:	83 f8 04             	cmp    $0x4,%eax
80104b4e:	75 0c                	jne    80104b5c <sched+0x59>
    panic("sched running");
80104b50:	c7 04 24 87 88 10 80 	movl   $0x80108887,(%esp)
80104b57:	e8 e1 b9 ff ff       	call   8010053d <panic>
  if(readeflags()&FL_IF)
80104b5c:	e8 63 f8 ff ff       	call   801043c4 <readeflags>
80104b61:	25 00 02 00 00       	and    $0x200,%eax
80104b66:	85 c0                	test   %eax,%eax
80104b68:	74 0c                	je     80104b76 <sched+0x73>
    panic("sched interruptible");
80104b6a:	c7 04 24 95 88 10 80 	movl   $0x80108895,(%esp)
80104b71:	e8 c7 b9 ff ff       	call   8010053d <panic>
  intena = cpu->intena;
80104b76:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b7c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104b85:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b8b:	8b 40 04             	mov    0x4(%eax),%eax
80104b8e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b95:	83 c2 1c             	add    $0x1c,%edx
80104b98:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b9c:	89 14 24             	mov    %edx,(%esp)
80104b9f:	e8 50 08 00 00       	call   801053f4 <swtch>
  cpu->intena = intena;
80104ba4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bad:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104bb3:	c9                   	leave  
80104bb4:	c3                   	ret    

80104bb5 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104bb5:	55                   	push   %ebp
80104bb6:	89 e5                	mov    %esp,%ebp
80104bb8:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104bbb:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104bc2:	e8 30 03 00 00       	call   80104ef7 <acquire>
  proc->state = RUNNABLE;
80104bc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bcd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104bd4:	e8 2a ff ff ff       	call   80104b03 <sched>
  release(&ptable.lock);
80104bd9:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104be0:	e8 73 03 00 00       	call   80104f58 <release>
}
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    

80104be7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104be7:	55                   	push   %ebp
80104be8:	89 e5                	mov    %esp,%ebp
80104bea:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104bed:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104bf4:	e8 5f 03 00 00       	call   80104f58 <release>

  if (first) {
80104bf9:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104bfe:	85 c0                	test   %eax,%eax
80104c00:	74 22                	je     80104c24 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c02:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104c09:	00 00 00 
    iinit(ROOTDEV);
80104c0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c13:	e8 bb c9 ff ff       	call   801015d3 <iinit>
    initlog(ROOTDEV);
80104c18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c1f:	e8 d0 e6 ff ff       	call   801032f4 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c24:	c9                   	leave  
80104c25:	c3                   	ret    

80104c26 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c26:	55                   	push   %ebp
80104c27:	89 e5                	mov    %esp,%ebp
80104c29:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104c2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c32:	85 c0                	test   %eax,%eax
80104c34:	75 0c                	jne    80104c42 <sleep+0x1c>
    panic("sleep");
80104c36:	c7 04 24 a9 88 10 80 	movl   $0x801088a9,(%esp)
80104c3d:	e8 fb b8 ff ff       	call   8010053d <panic>

  if(lk == 0)
80104c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104c46:	75 0c                	jne    80104c54 <sleep+0x2e>
    panic("sleep without lk");
80104c48:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
80104c4f:	e8 e9 b8 ff ff       	call   8010053d <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104c54:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104c5b:	74 17                	je     80104c74 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104c5d:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104c64:	e8 8e 02 00 00       	call   80104ef7 <acquire>
    release(lk);
80104c69:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6c:	89 04 24             	mov    %eax,(%esp)
80104c6f:	e8 e4 02 00 00       	call   80104f58 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104c74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7d:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104c80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c86:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104c8d:	e8 71 fe ff ff       	call   80104b03 <sched>

  // Tidy up.
  proc->chan = 0;
80104c92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c98:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c9f:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104ca6:	74 17                	je     80104cbf <sleep+0x99>
    release(&ptable.lock);
80104ca8:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104caf:	e8 a4 02 00 00       	call   80104f58 <release>
    acquire(lk);
80104cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cb7:	89 04 24             	mov    %eax,(%esp)
80104cba:	e8 38 02 00 00       	call   80104ef7 <acquire>
  }
}
80104cbf:	c9                   	leave  
80104cc0:	c3                   	ret    

80104cc1 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104cc1:	55                   	push   %ebp
80104cc2:	89 e5                	mov    %esp,%ebp
80104cc4:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cc7:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104cce:	eb 24                	jmp    80104cf4 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cd3:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd6:	83 f8 02             	cmp    $0x2,%eax
80104cd9:	75 15                	jne    80104cf0 <wakeup1+0x2f>
80104cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cde:	8b 40 20             	mov    0x20(%eax),%eax
80104ce1:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ce4:	75 0a                	jne    80104cf0 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ce9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cf0:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104cf4:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104cf9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80104cfc:	72 d2                	jb     80104cd0 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104cfe:	c9                   	leave  
80104cff:	c3                   	ret    

80104d00 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104d06:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d0d:	e8 e5 01 00 00       	call   80104ef7 <acquire>
  wakeup1(chan);
80104d12:	8b 45 08             	mov    0x8(%ebp),%eax
80104d15:	89 04 24             	mov    %eax,(%esp)
80104d18:	e8 a4 ff ff ff       	call   80104cc1 <wakeup1>
  release(&ptable.lock);
80104d1d:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d24:	e8 2f 02 00 00       	call   80104f58 <release>
}
80104d29:	c9                   	leave  
80104d2a:	c3                   	ret    

80104d2b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d2b:	55                   	push   %ebp
80104d2c:	89 e5                	mov    %esp,%ebp
80104d2e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104d31:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d38:	e8 ba 01 00 00       	call   80104ef7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d3d:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104d44:	eb 41                	jmp    80104d87 <kill+0x5c>
    if(p->pid == pid){
80104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d49:	8b 40 10             	mov    0x10(%eax),%eax
80104d4c:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d4f:	75 32                	jne    80104d83 <kill+0x58>
      p->killed = 1;
80104d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d54:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d61:	83 f8 02             	cmp    $0x2,%eax
80104d64:	75 0a                	jne    80104d70 <kill+0x45>
        p->state = RUNNABLE;
80104d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d69:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d70:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d77:	e8 dc 01 00 00       	call   80104f58 <release>
      return 0;
80104d7c:	b8 00 00 00 00       	mov    $0x0,%eax
80104d81:	eb 1f                	jmp    80104da2 <kill+0x77>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d83:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104d87:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104d8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104d8f:	72 b5                	jb     80104d46 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104d91:	c7 04 24 60 29 11 80 	movl   $0x80112960,(%esp)
80104d98:	e8 bb 01 00 00       	call   80104f58 <release>
  return -1;
80104d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da2:	c9                   	leave  
80104da3:	c3                   	ret    

80104da4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104daa:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104db1:	e9 d8 00 00 00       	jmp    80104e8e <procdump+0xea>
    if(p->state == UNUSED)
80104db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db9:	8b 40 0c             	mov    0xc(%eax),%eax
80104dbc:	85 c0                	test   %eax,%eax
80104dbe:	0f 84 c5 00 00 00    	je     80104e89 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dc7:	8b 40 0c             	mov    0xc(%eax),%eax
80104dca:	83 f8 05             	cmp    $0x5,%eax
80104dcd:	77 23                	ja     80104df2 <procdump+0x4e>
80104dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dd2:	8b 40 0c             	mov    0xc(%eax),%eax
80104dd5:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ddc:	85 c0                	test   %eax,%eax
80104dde:	74 12                	je     80104df2 <procdump+0x4e>
      state = states[p->state];
80104de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104de3:	8b 40 0c             	mov    0xc(%eax),%eax
80104de6:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104df0:	eb 07                	jmp    80104df9 <procdump+0x55>
      state = states[p->state];
    else
      state = "???";
80104df2:	c7 45 f4 c0 88 10 80 	movl   $0x801088c0,-0xc(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dfc:	8d 50 6c             	lea    0x6c(%eax),%edx
80104dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e02:	8b 40 10             	mov    0x10(%eax),%eax
80104e05:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e0c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104e10:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e14:	c7 04 24 c4 88 10 80 	movl   $0x801088c4,(%esp)
80104e1b:	e8 7d b5 ff ff       	call   8010039d <cprintf>
    if(p->state == SLEEPING){
80104e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e23:	8b 40 0c             	mov    0xc(%eax),%eax
80104e26:	83 f8 02             	cmp    $0x2,%eax
80104e29:	75 50                	jne    80104e7b <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e2e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e31:	8b 40 0c             	mov    0xc(%eax),%eax
80104e34:	83 c0 08             	add    $0x8,%eax
80104e37:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104e3a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104e3e:	89 04 24             	mov    %eax,(%esp)
80104e41:	e8 61 01 00 00       	call   80104fa7 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e46:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104e4d:	eb 1b                	jmp    80104e6a <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e52:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e56:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e5a:	c7 04 24 cd 88 10 80 	movl   $0x801088cd,(%esp)
80104e61:	e8 37 b5 ff ff       	call   8010039d <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104e66:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104e6a:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
80104e6e:	7f 0b                	jg     80104e7b <procdump+0xd7>
80104e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e73:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e77:	85 c0                	test   %eax,%eax
80104e79:	75 d4                	jne    80104e4f <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e7b:	c7 04 24 d1 88 10 80 	movl   $0x801088d1,(%esp)
80104e82:	e8 16 b5 ff ff       	call   8010039d <cprintf>
80104e87:	eb 01                	jmp    80104e8a <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104e89:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e8a:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104e8e:	b8 94 48 11 80       	mov    $0x80114894,%eax
80104e93:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104e96:	0f 82 1a ff ff ff    	jb     80104db6 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104e9c:	c9                   	leave  
80104e9d:	c3                   	ret    
	...

80104ea0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ea6:	9c                   	pushf  
80104ea7:	58                   	pop    %eax
80104ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    

80104eb0 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104eb3:	fa                   	cli    
}
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    

80104eb6 <sti>:

static inline void
sti(void)
{
80104eb6:	55                   	push   %ebp
80104eb7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104eb9:	fb                   	sti    
}
80104eba:	5d                   	pop    %ebp
80104ebb:	c3                   	ret    

80104ebc <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104ebc:	55                   	push   %ebp
80104ebd:	89 e5                	mov    %esp,%ebp
80104ebf:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104ec2:	8b 55 08             	mov    0x8(%ebp),%edx
80104ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ecb:	f0 87 02             	lock xchg %eax,(%edx)
80104ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ed4:	c9                   	leave  
80104ed5:	c3                   	ret    

80104ed6 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ed6:	55                   	push   %ebp
80104ed7:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80104edc:	8b 55 0c             	mov    0xc(%ebp),%edx
80104edf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80104eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    

80104ef7 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104ef7:	55                   	push   %ebp
80104ef8:	89 e5                	mov    %esp,%ebp
80104efa:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104efd:	e8 47 01 00 00       	call   80105049 <pushcli>
  if(holding(lk))
80104f02:	8b 45 08             	mov    0x8(%ebp),%eax
80104f05:	89 04 24             	mov    %eax,(%esp)
80104f08:	e8 12 01 00 00       	call   8010501f <holding>
80104f0d:	85 c0                	test   %eax,%eax
80104f0f:	74 0c                	je     80104f1d <acquire+0x26>
    panic("acquire");
80104f11:	c7 04 24 fd 88 10 80 	movl   $0x801088fd,(%esp)
80104f18:	e8 20 b6 ff ff       	call   8010053d <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f20:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104f27:	00 
80104f28:	89 04 24             	mov    %eax,(%esp)
80104f2b:	e8 8c ff ff ff       	call   80104ebc <xchg>
80104f30:	85 c0                	test   %eax,%eax
80104f32:	75 e9                	jne    80104f1d <acquire+0x26>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104f34:	8b 45 08             	mov    0x8(%ebp),%eax
80104f37:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104f3e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104f41:	8b 45 08             	mov    0x8(%ebp),%eax
80104f44:	83 c0 0c             	add    $0xc,%eax
80104f47:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f4b:	8d 45 08             	lea    0x8(%ebp),%eax
80104f4e:	89 04 24             	mov    %eax,(%esp)
80104f51:	e8 51 00 00 00       	call   80104fa7 <getcallerpcs>
}
80104f56:	c9                   	leave  
80104f57:	c3                   	ret    

80104f58 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104f58:	55                   	push   %ebp
80104f59:	89 e5                	mov    %esp,%ebp
80104f5b:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104f5e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f61:	89 04 24             	mov    %eax,(%esp)
80104f64:	e8 b6 00 00 00       	call   8010501f <holding>
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	75 0c                	jne    80104f79 <release+0x21>
    panic("release");
80104f6d:	c7 04 24 05 89 10 80 	movl   $0x80108905,(%esp)
80104f74:	e8 c4 b5 ff ff       	call   8010053d <panic>

  lk->pcs[0] = 0;
80104f79:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104f83:	8b 45 08             	mov    0x8(%ebp),%eax
80104f86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104f97:	00 
80104f98:	89 04 24             	mov    %eax,(%esp)
80104f9b:	e8 1c ff ff ff       	call   80104ebc <xchg>

  popcli();
80104fa0:	e8 ec 00 00 00       	call   80105091 <popcli>
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    

80104fa7 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fa7:	55                   	push   %ebp
80104fa8:	89 e5                	mov    %esp,%ebp
80104faa:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104fad:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb0:	83 e8 08             	sub    $0x8,%eax
80104fb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(i = 0; i < 10; i++){
80104fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104fbd:	eb 34                	jmp    80104ff3 <getcallerpcs+0x4c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80104fc3:	74 4b                	je     80105010 <getcallerpcs+0x69>
80104fc5:	81 7d f8 ff ff ff 7f 	cmpl   $0x7fffffff,-0x8(%ebp)
80104fcc:	76 45                	jbe    80105013 <getcallerpcs+0x6c>
80104fce:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%ebp)
80104fd2:	74 42                	je     80105016 <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd7:	c1 e0 02             	shl    $0x2,%eax
80104fda:	03 45 0c             	add    0xc(%ebp),%eax
80104fdd:	8b 55 f8             	mov    -0x8(%ebp),%edx
80104fe0:	83 c2 04             	add    $0x4,%edx
80104fe3:	8b 12                	mov    (%edx),%edx
80104fe5:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80104fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104fea:	8b 00                	mov    (%eax),%eax
80104fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104fef:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104ff3:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
80104ff7:	7e c6                	jle    80104fbf <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ff9:	eb 1c                	jmp    80105017 <getcallerpcs+0x70>
    pcs[i] = 0;
80104ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ffe:	c1 e0 02             	shl    $0x2,%eax
80105001:	03 45 0c             	add    0xc(%ebp),%eax
80105004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010500a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010500e:	eb 07                	jmp    80105017 <getcallerpcs+0x70>
80105010:	90                   	nop
80105011:	eb 04                	jmp    80105017 <getcallerpcs+0x70>
80105013:	90                   	nop
80105014:	eb 01                	jmp    80105017 <getcallerpcs+0x70>
80105016:	90                   	nop
80105017:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
8010501b:	7e de                	jle    80104ffb <getcallerpcs+0x54>
    pcs[i] = 0;
}
8010501d:	c9                   	leave  
8010501e:	c3                   	ret    

8010501f <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010501f:	55                   	push   %ebp
80105020:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105022:	8b 45 08             	mov    0x8(%ebp),%eax
80105025:	8b 00                	mov    (%eax),%eax
80105027:	85 c0                	test   %eax,%eax
80105029:	74 17                	je     80105042 <holding+0x23>
8010502b:	8b 45 08             	mov    0x8(%ebp),%eax
8010502e:	8b 50 08             	mov    0x8(%eax),%edx
80105031:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105037:	39 c2                	cmp    %eax,%edx
80105039:	75 07                	jne    80105042 <holding+0x23>
8010503b:	b8 01 00 00 00       	mov    $0x1,%eax
80105040:	eb 05                	jmp    80105047 <holding+0x28>
80105042:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105047:	5d                   	pop    %ebp
80105048:	c3                   	ret    

80105049 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105049:	55                   	push   %ebp
8010504a:	89 e5                	mov    %esp,%ebp
8010504c:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010504f:	e8 4c fe ff ff       	call   80104ea0 <readeflags>
80105054:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105057:	e8 54 fe ff ff       	call   80104eb0 <cli>
  if(cpu->ncli++ == 0)
8010505c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105062:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105068:	85 d2                	test   %edx,%edx
8010506a:	0f 94 c1             	sete   %cl
8010506d:	83 c2 01             	add    $0x1,%edx
80105070:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105076:	84 c9                	test   %cl,%cl
80105078:	74 15                	je     8010508f <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
8010507a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105080:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105083:	81 e2 00 02 00 00    	and    $0x200,%edx
80105089:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010508f:	c9                   	leave  
80105090:	c3                   	ret    

80105091 <popcli>:

void
popcli(void)
{
80105091:	55                   	push   %ebp
80105092:	89 e5                	mov    %esp,%ebp
80105094:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105097:	e8 04 fe ff ff       	call   80104ea0 <readeflags>
8010509c:	25 00 02 00 00       	and    $0x200,%eax
801050a1:	85 c0                	test   %eax,%eax
801050a3:	74 0c                	je     801050b1 <popcli+0x20>
    panic("popcli - interruptible");
801050a5:	c7 04 24 0d 89 10 80 	movl   $0x8010890d,(%esp)
801050ac:	e8 8c b4 ff ff       	call   8010053d <panic>
  if(--cpu->ncli < 0)
801050b1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050b7:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801050bd:	83 ea 01             	sub    $0x1,%edx
801050c0:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050c6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801050cc:	85 c0                	test   %eax,%eax
801050ce:	79 0c                	jns    801050dc <popcli+0x4b>
    panic("popcli");
801050d0:	c7 04 24 24 89 10 80 	movl   $0x80108924,(%esp)
801050d7:	e8 61 b4 ff ff       	call   8010053d <panic>
  if(cpu->ncli == 0 && cpu->intena)
801050dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801050e8:	85 c0                	test   %eax,%eax
801050ea:	75 15                	jne    80105101 <popcli+0x70>
801050ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050f2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801050f8:	85 c0                	test   %eax,%eax
801050fa:	74 05                	je     80105101 <popcli+0x70>
    sti();
801050fc:	e8 b5 fd ff ff       	call   80104eb6 <sti>
}
80105101:	c9                   	leave  
80105102:	c3                   	ret    
	...

80105104 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	57                   	push   %edi
80105108:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105109:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010510c:	8b 55 10             	mov    0x10(%ebp),%edx
8010510f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105112:	89 cb                	mov    %ecx,%ebx
80105114:	89 df                	mov    %ebx,%edi
80105116:	89 d1                	mov    %edx,%ecx
80105118:	fc                   	cld    
80105119:	f3 aa                	rep stos %al,%es:(%edi)
8010511b:	89 ca                	mov    %ecx,%edx
8010511d:	89 fb                	mov    %edi,%ebx
8010511f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105122:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105125:	5b                   	pop    %ebx
80105126:	5f                   	pop    %edi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    

80105129 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105129:	55                   	push   %ebp
8010512a:	89 e5                	mov    %esp,%ebp
8010512c:	57                   	push   %edi
8010512d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010512e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105131:	8b 55 10             	mov    0x10(%ebp),%edx
80105134:	8b 45 0c             	mov    0xc(%ebp),%eax
80105137:	89 cb                	mov    %ecx,%ebx
80105139:	89 df                	mov    %ebx,%edi
8010513b:	89 d1                	mov    %edx,%ecx
8010513d:	fc                   	cld    
8010513e:	f3 ab                	rep stos %eax,%es:(%edi)
80105140:	89 ca                	mov    %ecx,%edx
80105142:	89 fb                	mov    %edi,%ebx
80105144:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105147:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010514a:	5b                   	pop    %ebx
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    

8010514e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010514e:	55                   	push   %ebp
8010514f:	89 e5                	mov    %esp,%ebp
80105151:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105154:	8b 45 08             	mov    0x8(%ebp),%eax
80105157:	83 e0 03             	and    $0x3,%eax
8010515a:	85 c0                	test   %eax,%eax
8010515c:	75 49                	jne    801051a7 <memset+0x59>
8010515e:	8b 45 10             	mov    0x10(%ebp),%eax
80105161:	83 e0 03             	and    $0x3,%eax
80105164:	85 c0                	test   %eax,%eax
80105166:	75 3f                	jne    801051a7 <memset+0x59>
    c &= 0xFF;
80105168:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010516f:	8b 45 10             	mov    0x10(%ebp),%eax
80105172:	c1 e8 02             	shr    $0x2,%eax
80105175:	89 c2                	mov    %eax,%edx
80105177:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517a:	89 c1                	mov    %eax,%ecx
8010517c:	c1 e1 18             	shl    $0x18,%ecx
8010517f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105182:	c1 e0 10             	shl    $0x10,%eax
80105185:	09 c1                	or     %eax,%ecx
80105187:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518a:	c1 e0 08             	shl    $0x8,%eax
8010518d:	09 c8                	or     %ecx,%eax
8010518f:	0b 45 0c             	or     0xc(%ebp),%eax
80105192:	89 54 24 08          	mov    %edx,0x8(%esp)
80105196:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519a:	8b 45 08             	mov    0x8(%ebp),%eax
8010519d:	89 04 24             	mov    %eax,(%esp)
801051a0:	e8 84 ff ff ff       	call   80105129 <stosl>
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
801051a5:	eb 19                	jmp    801051c0 <memset+0x72>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
801051a7:	8b 45 10             	mov    0x10(%ebp),%eax
801051aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801051ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b5:	8b 45 08             	mov    0x8(%ebp),%eax
801051b8:	89 04 24             	mov    %eax,(%esp)
801051bb:	e8 44 ff ff ff       	call   80105104 <stosb>
  return dst;
801051c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801051c3:	c9                   	leave  
801051c4:	c3                   	ret    

801051c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051c5:	55                   	push   %ebp
801051c6:	89 e5                	mov    %esp,%ebp
801051c8:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801051cb:	8b 45 08             	mov    0x8(%ebp),%eax
801051ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  s2 = v2;
801051d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801051d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0){
801051d7:	eb 32                	jmp    8010520b <memcmp+0x46>
    if(*s1 != *s2)
801051d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051dc:	0f b6 10             	movzbl (%eax),%edx
801051df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051e2:	0f b6 00             	movzbl (%eax),%eax
801051e5:	38 c2                	cmp    %al,%dl
801051e7:	74 1a                	je     80105203 <memcmp+0x3e>
      return *s1 - *s2;
801051e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051ec:	0f b6 00             	movzbl (%eax),%eax
801051ef:	0f b6 d0             	movzbl %al,%edx
801051f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051f5:	0f b6 00             	movzbl (%eax),%eax
801051f8:	0f b6 c0             	movzbl %al,%eax
801051fb:	89 d1                	mov    %edx,%ecx
801051fd:	29 c1                	sub    %eax,%ecx
801051ff:	89 c8                	mov    %ecx,%eax
80105201:	eb 1c                	jmp    8010521f <memcmp+0x5a>
    s1++, s2++;
80105203:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105207:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010520b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010520f:	0f 95 c0             	setne  %al
80105212:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105216:	84 c0                	test   %al,%al
80105218:	75 bf                	jne    801051d9 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010521a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010521f:	c9                   	leave  
80105220:	c3                   	ret    

80105221 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105221:	55                   	push   %ebp
80105222:	89 e5                	mov    %esp,%ebp
80105224:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105227:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  d = dst;
8010522d:	8b 45 08             	mov    0x8(%ebp),%eax
80105230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(s < d && s + n > d){
80105233:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105236:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105239:	73 55                	jae    80105290 <memmove+0x6f>
8010523b:	8b 45 10             	mov    0x10(%ebp),%eax
8010523e:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105241:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105244:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80105247:	76 4a                	jbe    80105293 <memmove+0x72>
    s += n;
80105249:	8b 45 10             	mov    0x10(%ebp),%eax
8010524c:	01 45 f8             	add    %eax,-0x8(%ebp)
    d += n;
8010524f:	8b 45 10             	mov    0x10(%ebp),%eax
80105252:	01 45 fc             	add    %eax,-0x4(%ebp)
    while(n-- > 0)
80105255:	eb 13                	jmp    8010526a <memmove+0x49>
      *--d = *--s;
80105257:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010525b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010525f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105262:	0f b6 10             	movzbl (%eax),%edx
80105265:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105268:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010526a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010526e:	0f 95 c0             	setne  %al
80105271:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105275:	84 c0                	test   %al,%al
80105277:	75 de                	jne    80105257 <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105279:	eb 28                	jmp    801052a3 <memmove+0x82>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010527b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010527e:	0f b6 10             	movzbl (%eax),%edx
80105281:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105284:	88 10                	mov    %dl,(%eax)
80105286:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010528a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010528e:	eb 04                	jmp    80105294 <memmove+0x73>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105290:	90                   	nop
80105291:	eb 01                	jmp    80105294 <memmove+0x73>
80105293:	90                   	nop
80105294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105298:	0f 95 c0             	setne  %al
8010529b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010529f:	84 c0                	test   %al,%al
801052a1:	75 d8                	jne    8010527b <memmove+0x5a>
      *d++ = *s++;

  return dst;
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
801052a6:	c9                   	leave  
801052a7:	c3                   	ret    

801052a8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801052a8:	55                   	push   %ebp
801052a9:	89 e5                	mov    %esp,%ebp
801052ab:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801052ae:	8b 45 10             	mov    0x10(%ebp),%eax
801052b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801052b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801052bc:	8b 45 08             	mov    0x8(%ebp),%eax
801052bf:	89 04 24             	mov    %eax,(%esp)
801052c2:	e8 5a ff ff ff       	call   80105221 <memmove>
}
801052c7:	c9                   	leave  
801052c8:	c3                   	ret    

801052c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801052c9:	55                   	push   %ebp
801052ca:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801052cc:	eb 0c                	jmp    801052da <strncmp+0x11>
    n--, p++, q++;
801052ce:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801052d6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801052da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052de:	74 1a                	je     801052fa <strncmp+0x31>
801052e0:	8b 45 08             	mov    0x8(%ebp),%eax
801052e3:	0f b6 00             	movzbl (%eax),%eax
801052e6:	84 c0                	test   %al,%al
801052e8:	74 10                	je     801052fa <strncmp+0x31>
801052ea:	8b 45 08             	mov    0x8(%ebp),%eax
801052ed:	0f b6 10             	movzbl (%eax),%edx
801052f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f3:	0f b6 00             	movzbl (%eax),%eax
801052f6:	38 c2                	cmp    %al,%dl
801052f8:	74 d4                	je     801052ce <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801052fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052fe:	75 07                	jne    80105307 <strncmp+0x3e>
    return 0;
80105300:	b8 00 00 00 00       	mov    $0x0,%eax
80105305:	eb 18                	jmp    8010531f <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
80105307:	8b 45 08             	mov    0x8(%ebp),%eax
8010530a:	0f b6 00             	movzbl (%eax),%eax
8010530d:	0f b6 d0             	movzbl %al,%edx
80105310:	8b 45 0c             	mov    0xc(%ebp),%eax
80105313:	0f b6 00             	movzbl (%eax),%eax
80105316:	0f b6 c0             	movzbl %al,%eax
80105319:	89 d1                	mov    %edx,%ecx
8010531b:	29 c1                	sub    %eax,%ecx
8010531d:	89 c8                	mov    %ecx,%eax
}
8010531f:	5d                   	pop    %ebp
80105320:	c3                   	ret    

80105321 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105321:	55                   	push   %ebp
80105322:	89 e5                	mov    %esp,%ebp
80105324:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105327:	8b 45 08             	mov    0x8(%ebp),%eax
8010532a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010532d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105331:	0f 9f c0             	setg   %al
80105334:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105338:	84 c0                	test   %al,%al
8010533a:	74 30                	je     8010536c <strncpy+0x4b>
8010533c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533f:	0f b6 10             	movzbl (%eax),%edx
80105342:	8b 45 08             	mov    0x8(%ebp),%eax
80105345:	88 10                	mov    %dl,(%eax)
80105347:	8b 45 08             	mov    0x8(%ebp),%eax
8010534a:	0f b6 00             	movzbl (%eax),%eax
8010534d:	84 c0                	test   %al,%al
8010534f:	0f 95 c0             	setne  %al
80105352:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105356:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010535a:	84 c0                	test   %al,%al
8010535c:	75 cf                	jne    8010532d <strncpy+0xc>
    ;
  while(n-- > 0)
8010535e:	eb 0d                	jmp    8010536d <strncpy+0x4c>
    *s++ = 0;
80105360:	8b 45 08             	mov    0x8(%ebp),%eax
80105363:	c6 00 00             	movb   $0x0,(%eax)
80105366:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010536a:	eb 01                	jmp    8010536d <strncpy+0x4c>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010536c:	90                   	nop
8010536d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105371:	0f 9f c0             	setg   %al
80105374:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105378:	84 c0                	test   %al,%al
8010537a:	75 e4                	jne    80105360 <strncpy+0x3f>
    *s++ = 0;
  return os;
8010537c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010537f:	c9                   	leave  
80105380:	c3                   	ret    

80105381 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105381:	55                   	push   %ebp
80105382:	89 e5                	mov    %esp,%ebp
80105384:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105387:	8b 45 08             	mov    0x8(%ebp),%eax
8010538a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010538d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105391:	7f 05                	jg     80105398 <safestrcpy+0x17>
    return os;
80105393:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105396:	eb 35                	jmp    801053cd <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105398:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010539c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053a0:	7e 22                	jle    801053c4 <safestrcpy+0x43>
801053a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a5:	0f b6 10             	movzbl (%eax),%edx
801053a8:	8b 45 08             	mov    0x8(%ebp),%eax
801053ab:	88 10                	mov    %dl,(%eax)
801053ad:	8b 45 08             	mov    0x8(%ebp),%eax
801053b0:	0f b6 00             	movzbl (%eax),%eax
801053b3:	84 c0                	test   %al,%al
801053b5:	0f 95 c0             	setne  %al
801053b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053bc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053c0:	84 c0                	test   %al,%al
801053c2:	75 d4                	jne    80105398 <safestrcpy+0x17>
    ;
  *s = 0;
801053c4:	8b 45 08             	mov    0x8(%ebp),%eax
801053c7:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801053ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053cd:	c9                   	leave  
801053ce:	c3                   	ret    

801053cf <strlen>:

int
strlen(const char *s)
{
801053cf:	55                   	push   %ebp
801053d0:	89 e5                	mov    %esp,%ebp
801053d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801053d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801053dc:	eb 04                	jmp    801053e2 <strlen+0x13>
801053de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053e5:	03 45 08             	add    0x8(%ebp),%eax
801053e8:	0f b6 00             	movzbl (%eax),%eax
801053eb:	84 c0                	test   %al,%al
801053ed:	75 ef                	jne    801053de <strlen+0xf>
    ;
  return n;
801053ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053f2:	c9                   	leave  
801053f3:	c3                   	ret    

801053f4 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801053f4:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801053f8:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801053fc:	55                   	push   %ebp
  pushl %ebx
801053fd:	53                   	push   %ebx
  pushl %esi
801053fe:	56                   	push   %esi
  pushl %edi
801053ff:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105400:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105402:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105404:	5f                   	pop    %edi
  popl %esi
80105405:	5e                   	pop    %esi
  popl %ebx
80105406:	5b                   	pop    %ebx
  popl %ebp
80105407:	5d                   	pop    %ebp
  ret
80105408:	c3                   	ret    
80105409:	00 00                	add    %al,(%eax)
	...

8010540c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010540c:	55                   	push   %ebp
8010540d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010540f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105415:	8b 00                	mov    (%eax),%eax
80105417:	3b 45 08             	cmp    0x8(%ebp),%eax
8010541a:	76 12                	jbe    8010542e <fetchint+0x22>
8010541c:	8b 45 08             	mov    0x8(%ebp),%eax
8010541f:	8d 50 04             	lea    0x4(%eax),%edx
80105422:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105428:	8b 00                	mov    (%eax),%eax
8010542a:	39 c2                	cmp    %eax,%edx
8010542c:	76 07                	jbe    80105435 <fetchint+0x29>
    return -1;
8010542e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105433:	eb 0f                	jmp    80105444 <fetchint+0x38>
  *ip = *(int*)(addr);
80105435:	8b 45 08             	mov    0x8(%ebp),%eax
80105438:	8b 10                	mov    (%eax),%edx
8010543a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543d:	89 10                	mov    %edx,(%eax)
  return 0;
8010543f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105444:	5d                   	pop    %ebp
80105445:	c3                   	ret    

80105446 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105446:	55                   	push   %ebp
80105447:	89 e5                	mov    %esp,%ebp
80105449:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010544c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105452:	8b 00                	mov    (%eax),%eax
80105454:	3b 45 08             	cmp    0x8(%ebp),%eax
80105457:	77 07                	ja     80105460 <fetchstr+0x1a>
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545e:	eb 48                	jmp    801054a8 <fetchstr+0x62>
  *pp = (char*)addr;
80105460:	8b 55 08             	mov    0x8(%ebp),%edx
80105463:	8b 45 0c             	mov    0xc(%ebp),%eax
80105466:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105468:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546e:	8b 00                	mov    (%eax),%eax
80105470:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(s = *pp; s < ep; s++)
80105473:	8b 45 0c             	mov    0xc(%ebp),%eax
80105476:	8b 00                	mov    (%eax),%eax
80105478:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010547b:	eb 1e                	jmp    8010549b <fetchstr+0x55>
    if(*s == 0)
8010547d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105480:	0f b6 00             	movzbl (%eax),%eax
80105483:	84 c0                	test   %al,%al
80105485:	75 10                	jne    80105497 <fetchstr+0x51>
      return s - *pp;
80105487:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010548a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010548d:	8b 00                	mov    (%eax),%eax
8010548f:	89 d1                	mov    %edx,%ecx
80105491:	29 c1                	sub    %eax,%ecx
80105493:	89 c8                	mov    %ecx,%eax
80105495:	eb 11                	jmp    801054a8 <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105497:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010549b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010549e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801054a1:	72 da                	jb     8010547d <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801054a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a8:	c9                   	leave  
801054a9:	c3                   	ret    

801054aa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054aa:	55                   	push   %ebp
801054ab:	89 e5                	mov    %esp,%ebp
801054ad:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801054b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b6:	8b 40 18             	mov    0x18(%eax),%eax
801054b9:	8b 50 44             	mov    0x44(%eax),%edx
801054bc:	8b 45 08             	mov    0x8(%ebp),%eax
801054bf:	c1 e0 02             	shl    $0x2,%eax
801054c2:	8d 04 02             	lea    (%edx,%eax,1),%eax
801054c5:	8d 50 04             	lea    0x4(%eax),%edx
801054c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801054cf:	89 14 24             	mov    %edx,(%esp)
801054d2:	e8 35 ff ff ff       	call   8010540c <fetchint>
}
801054d7:	c9                   	leave  
801054d8:	c3                   	ret    

801054d9 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054d9:	55                   	push   %ebp
801054da:	89 e5                	mov    %esp,%ebp
801054dc:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801054df:	8d 45 fc             	lea    -0x4(%ebp),%eax
801054e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801054e6:	8b 45 08             	mov    0x8(%ebp),%eax
801054e9:	89 04 24             	mov    %eax,(%esp)
801054ec:	e8 b9 ff ff ff       	call   801054aa <argint>
801054f1:	85 c0                	test   %eax,%eax
801054f3:	79 07                	jns    801054fc <argptr+0x23>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fa:	eb 3d                	jmp    80105539 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801054fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ff:	89 c2                	mov    %eax,%edx
80105501:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105507:	8b 00                	mov    (%eax),%eax
80105509:	39 c2                	cmp    %eax,%edx
8010550b:	73 16                	jae    80105523 <argptr+0x4a>
8010550d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105510:	89 c2                	mov    %eax,%edx
80105512:	8b 45 10             	mov    0x10(%ebp),%eax
80105515:	01 c2                	add    %eax,%edx
80105517:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010551d:	8b 00                	mov    (%eax),%eax
8010551f:	39 c2                	cmp    %eax,%edx
80105521:	76 07                	jbe    8010552a <argptr+0x51>
    return -1;
80105523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105528:	eb 0f                	jmp    80105539 <argptr+0x60>
  *pp = (char*)i;
8010552a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010552d:	89 c2                	mov    %eax,%edx
8010552f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105532:	89 10                	mov    %edx,(%eax)
  return 0;
80105534:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105539:	c9                   	leave  
8010553a:	c3                   	ret    

8010553b <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010553b:	55                   	push   %ebp
8010553c:	89 e5                	mov    %esp,%ebp
8010553e:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105541:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105544:	89 44 24 04          	mov    %eax,0x4(%esp)
80105548:	8b 45 08             	mov    0x8(%ebp),%eax
8010554b:	89 04 24             	mov    %eax,(%esp)
8010554e:	e8 57 ff ff ff       	call   801054aa <argint>
80105553:	85 c0                	test   %eax,%eax
80105555:	79 07                	jns    8010555e <argstr+0x23>
    return -1;
80105557:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555c:	eb 12                	jmp    80105570 <argstr+0x35>
  return fetchstr(addr, pp);
8010555e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105561:	8b 55 0c             	mov    0xc(%ebp),%edx
80105564:	89 54 24 04          	mov    %edx,0x4(%esp)
80105568:	89 04 24             	mov    %eax,(%esp)
8010556b:	e8 d6 fe ff ff       	call   80105446 <fetchstr>
}
80105570:	c9                   	leave  
80105571:	c3                   	ret    

80105572 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105572:	55                   	push   %ebp
80105573:	89 e5                	mov    %esp,%ebp
80105575:	53                   	push   %ebx
80105576:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105579:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010557f:	8b 40 18             	mov    0x18(%eax),%eax
80105582:	8b 40 1c             	mov    0x1c(%eax),%eax
80105585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558c:	7e 30                	jle    801055be <syscall+0x4c>
8010558e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105591:	83 f8 15             	cmp    $0x15,%eax
80105594:	77 28                	ja     801055be <syscall+0x4c>
80105596:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105599:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055a0:	85 c0                	test   %eax,%eax
801055a2:	74 1a                	je     801055be <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055aa:	8b 58 18             	mov    0x18(%eax),%ebx
801055ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b0:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055b7:	ff d0                	call   *%eax
801055b9:	89 43 1c             	mov    %eax,0x1c(%ebx)
syscall(void)
{
  int num;

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055bc:	eb 3d                	jmp    801055fb <syscall+0x89>
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801055be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801055c4:	8d 48 6c             	lea    0x6c(%eax),%ecx
            proc->pid, proc->name, num);
801055c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801055cd:	8b 40 10             	mov    0x10(%eax),%eax
801055d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
801055d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055db:	89 44 24 04          	mov    %eax,0x4(%esp)
801055df:	c7 04 24 2b 89 10 80 	movl   $0x8010892b,(%esp)
801055e6:	e8 b2 ad ff ff       	call   8010039d <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801055eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f1:	8b 40 18             	mov    0x18(%eax),%eax
801055f4:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801055fb:	83 c4 24             	add    $0x24,%esp
801055fe:	5b                   	pop    %ebx
801055ff:	5d                   	pop    %ebp
80105600:	c3                   	ret    
80105601:	00 00                	add    %al,(%eax)
	...

80105604 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105604:	55                   	push   %ebp
80105605:	89 e5                	mov    %esp,%ebp
80105607:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010560a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010560d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105611:	8b 45 08             	mov    0x8(%ebp),%eax
80105614:	89 04 24             	mov    %eax,(%esp)
80105617:	e8 8e fe ff ff       	call   801054aa <argint>
8010561c:	85 c0                	test   %eax,%eax
8010561e:	79 07                	jns    80105627 <argfd+0x23>
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb 50                	jmp    80105677 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010562a:	85 c0                	test   %eax,%eax
8010562c:	78 21                	js     8010564f <argfd+0x4b>
8010562e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105631:	83 f8 0f             	cmp    $0xf,%eax
80105634:	7f 19                	jg     8010564f <argfd+0x4b>
80105636:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010563c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010563f:	83 c2 08             	add    $0x8,%edx
80105642:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105646:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010564d:	75 07                	jne    80105656 <argfd+0x52>
    return -1;
8010564f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105654:	eb 21                	jmp    80105677 <argfd+0x73>
  if(pfd)
80105656:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010565a:	74 08                	je     80105664 <argfd+0x60>
    *pfd = fd;
8010565c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010565f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105662:	89 10                	mov    %edx,(%eax)
  if(pf)
80105664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105668:	74 08                	je     80105672 <argfd+0x6e>
    *pf = f;
8010566a:	8b 45 10             	mov    0x10(%ebp),%eax
8010566d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105670:	89 10                	mov    %edx,(%eax)
  return 0;
80105672:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105677:	c9                   	leave  
80105678:	c3                   	ret    

80105679 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105679:	55                   	push   %ebp
8010567a:	89 e5                	mov    %esp,%ebp
8010567c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010567f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105686:	eb 30                	jmp    801056b8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105688:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105691:	83 c2 08             	add    $0x8,%edx
80105694:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105698:	85 c0                	test   %eax,%eax
8010569a:	75 18                	jne    801056b4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010569c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056a5:	8d 4a 08             	lea    0x8(%edx),%ecx
801056a8:	8b 55 08             	mov    0x8(%ebp),%edx
801056ab:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b2:	eb 0f                	jmp    801056c3 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056b8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056bc:	7e ca                	jle    80105688 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801056be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c3:	c9                   	leave  
801056c4:	c3                   	ret    

801056c5 <sys_dup>:

int
sys_dup(void)
{
801056c5:	55                   	push   %ebp
801056c6:	89 e5                	mov    %esp,%ebp
801056c8:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801056cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ce:	89 44 24 08          	mov    %eax,0x8(%esp)
801056d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056d9:	00 
801056da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056e1:	e8 1e ff ff ff       	call   80105604 <argfd>
801056e6:	85 c0                	test   %eax,%eax
801056e8:	79 07                	jns    801056f1 <sys_dup+0x2c>
    return -1;
801056ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ef:	eb 29                	jmp    8010571a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801056f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f4:	89 04 24             	mov    %eax,(%esp)
801056f7:	e8 7d ff ff ff       	call   80105679 <fdalloc>
801056fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105703:	79 07                	jns    8010570c <sys_dup+0x47>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570a:	eb 0e                	jmp    8010571a <sys_dup+0x55>
  filedup(f);
8010570c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010570f:	89 04 24             	mov    %eax,(%esp)
80105712:	e8 92 b8 ff ff       	call   80100fa9 <filedup>
  return fd;
80105717:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    

8010571c <sys_read>:

int
sys_read(void)
{
8010571c:	55                   	push   %ebp
8010571d:	89 e5                	mov    %esp,%ebp
8010571f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105722:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105725:	89 44 24 08          	mov    %eax,0x8(%esp)
80105729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105730:	00 
80105731:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105738:	e8 c7 fe ff ff       	call   80105604 <argfd>
8010573d:	85 c0                	test   %eax,%eax
8010573f:	78 35                	js     80105776 <sys_read+0x5a>
80105741:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105744:	89 44 24 04          	mov    %eax,0x4(%esp)
80105748:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010574f:	e8 56 fd ff ff       	call   801054aa <argint>
80105754:	85 c0                	test   %eax,%eax
80105756:	78 1e                	js     80105776 <sys_read+0x5a>
80105758:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010575b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010575f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105762:	89 44 24 04          	mov    %eax,0x4(%esp)
80105766:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010576d:	e8 67 fd ff ff       	call   801054d9 <argptr>
80105772:	85 c0                	test   %eax,%eax
80105774:	79 07                	jns    8010577d <sys_read+0x61>
    return -1;
80105776:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577b:	eb 19                	jmp    80105796 <sys_read+0x7a>
  return fileread(f, p, n);
8010577d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105780:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105786:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010578a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010578e:	89 04 24             	mov    %eax,(%esp)
80105791:	e8 80 b9 ff ff       	call   80101116 <fileread>
}
80105796:	c9                   	leave  
80105797:	c3                   	ret    

80105798 <sys_write>:

int
sys_write(void)
{
80105798:	55                   	push   %ebp
80105799:	89 e5                	mov    %esp,%ebp
8010579b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010579e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a1:	89 44 24 08          	mov    %eax,0x8(%esp)
801057a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057ac:	00 
801057ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057b4:	e8 4b fe ff ff       	call   80105604 <argfd>
801057b9:	85 c0                	test   %eax,%eax
801057bb:	78 35                	js     801057f2 <sys_write+0x5a>
801057bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801057cb:	e8 da fc ff ff       	call   801054aa <argint>
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 1e                	js     801057f2 <sys_write+0x5a>
801057d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d7:	89 44 24 08          	mov    %eax,0x8(%esp)
801057db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057de:	89 44 24 04          	mov    %eax,0x4(%esp)
801057e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057e9:	e8 eb fc ff ff       	call   801054d9 <argptr>
801057ee:	85 c0                	test   %eax,%eax
801057f0:	79 07                	jns    801057f9 <sys_write+0x61>
    return -1;
801057f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f7:	eb 19                	jmp    80105812 <sys_write+0x7a>
  return filewrite(f, p, n);
801057f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105802:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105806:	89 54 24 04          	mov    %edx,0x4(%esp)
8010580a:	89 04 24             	mov    %eax,(%esp)
8010580d:	e8 c0 b9 ff ff       	call   801011d2 <filewrite>
}
80105812:	c9                   	leave  
80105813:	c3                   	ret    

80105814 <sys_close>:

int
sys_close(void)
{
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010581a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010581d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105821:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105824:	89 44 24 04          	mov    %eax,0x4(%esp)
80105828:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010582f:	e8 d0 fd ff ff       	call   80105604 <argfd>
80105834:	85 c0                	test   %eax,%eax
80105836:	79 07                	jns    8010583f <sys_close+0x2b>
    return -1;
80105838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583d:	eb 24                	jmp    80105863 <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010583f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105848:	83 c2 08             	add    $0x8,%edx
8010584b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105852:	00 
  fileclose(f);
80105853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105856:	89 04 24             	mov    %eax,(%esp)
80105859:	e8 93 b7 ff ff       	call   80100ff1 <fileclose>
  return 0;
8010585e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105863:	c9                   	leave  
80105864:	c3                   	ret    

80105865 <sys_fstat>:

int
sys_fstat(void)
{
80105865:	55                   	push   %ebp
80105866:	89 e5                	mov    %esp,%ebp
80105868:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010586b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010586e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105872:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105879:	00 
8010587a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105881:	e8 7e fd ff ff       	call   80105604 <argfd>
80105886:	85 c0                	test   %eax,%eax
80105888:	78 1f                	js     801058a9 <sys_fstat+0x44>
8010588a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010588d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105894:	00 
80105895:	89 44 24 04          	mov    %eax,0x4(%esp)
80105899:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058a0:	e8 34 fc ff ff       	call   801054d9 <argptr>
801058a5:	85 c0                	test   %eax,%eax
801058a7:	79 07                	jns    801058b0 <sys_fstat+0x4b>
    return -1;
801058a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ae:	eb 12                	jmp    801058c2 <sys_fstat+0x5d>
  return filestat(f, st);
801058b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801058ba:	89 04 24             	mov    %eax,(%esp)
801058bd:	e8 05 b8 ff ff       	call   801010c7 <filestat>
}
801058c2:	c9                   	leave  
801058c3:	c3                   	ret    

801058c4 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058d8:	e8 5e fc ff ff       	call   8010553b <argstr>
801058dd:	85 c0                	test   %eax,%eax
801058df:	78 17                	js     801058f8 <sys_link+0x34>
801058e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801058e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058ef:	e8 47 fc ff ff       	call   8010553b <argstr>
801058f4:	85 c0                	test   %eax,%eax
801058f6:	79 0a                	jns    80105902 <sys_link+0x3e>
    return -1;
801058f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fd:	e9 41 01 00 00       	jmp    80105a43 <sys_link+0x17f>

  begin_op();
80105902:	e8 ef db ff ff       	call   801034f6 <begin_op>
  if((ip = namei(old)) == 0){
80105907:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010590a:	89 04 24             	mov    %eax,(%esp)
8010590d:	e8 9d cb ff ff       	call   801024af <namei>
80105912:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105919:	75 0f                	jne    8010592a <sys_link+0x66>
    end_op();
8010591b:	e8 58 dc ff ff       	call   80103578 <end_op>
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105925:	e9 19 01 00 00       	jmp    80105a43 <sys_link+0x17f>
  }

  ilock(ip);
8010592a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592d:	89 04 24             	mov    %eax,(%esp)
80105930:	e8 cc bf ff ff       	call   80101901 <ilock>
  if(ip->type == T_DIR){
80105935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105938:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010593c:	66 83 f8 01          	cmp    $0x1,%ax
80105940:	75 1a                	jne    8010595c <sys_link+0x98>
    iunlockput(ip);
80105942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105945:	89 04 24             	mov    %eax,(%esp)
80105948:	e8 41 c2 ff ff       	call   80101b8e <iunlockput>
    end_op();
8010594d:	e8 26 dc ff ff       	call   80103578 <end_op>
    return -1;
80105952:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105957:	e9 e7 00 00 00       	jmp    80105a43 <sys_link+0x17f>
  }

  ip->nlink++;
8010595c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105963:	8d 50 01             	lea    0x1(%eax),%edx
80105966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105969:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010596d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105970:	89 04 24             	mov    %eax,(%esp)
80105973:	e8 c3 bd ff ff       	call   8010173b <iupdate>
  iunlock(ip);
80105978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597b:	89 04 24             	mov    %eax,(%esp)
8010597e:	e8 d5 c0 ff ff       	call   80101a58 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105983:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105986:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105989:	89 54 24 04          	mov    %edx,0x4(%esp)
8010598d:	89 04 24             	mov    %eax,(%esp)
80105990:	e8 3c cb ff ff       	call   801024d1 <nameiparent>
80105995:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105998:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010599c:	74 68                	je     80105a06 <sys_link+0x142>
    goto bad;
  ilock(dp);
8010599e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a1:	89 04 24             	mov    %eax,(%esp)
801059a4:	e8 58 bf ff ff       	call   80101901 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ac:	8b 10                	mov    (%eax),%edx
801059ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b1:	8b 00                	mov    (%eax),%eax
801059b3:	39 c2                	cmp    %eax,%edx
801059b5:	75 20                	jne    801059d7 <sys_link+0x113>
801059b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ba:	8b 40 04             	mov    0x4(%eax),%eax
801059bd:	89 44 24 08          	mov    %eax,0x8(%esp)
801059c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059cb:	89 04 24             	mov    %eax,(%esp)
801059ce:	e8 1b c8 ff ff       	call   801021ee <dirlink>
801059d3:	85 c0                	test   %eax,%eax
801059d5:	79 0d                	jns    801059e4 <sys_link+0x120>
    iunlockput(dp);
801059d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059da:	89 04 24             	mov    %eax,(%esp)
801059dd:	e8 ac c1 ff ff       	call   80101b8e <iunlockput>
    goto bad;
801059e2:	eb 23                	jmp    80105a07 <sys_link+0x143>
  }
  iunlockput(dp);
801059e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e7:	89 04 24             	mov    %eax,(%esp)
801059ea:	e8 9f c1 ff ff       	call   80101b8e <iunlockput>
  iput(ip);
801059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f2:	89 04 24             	mov    %eax,(%esp)
801059f5:	e8 c3 c0 ff ff       	call   80101abd <iput>

  end_op();
801059fa:	e8 79 db ff ff       	call   80103578 <end_op>

  return 0;
801059ff:	b8 00 00 00 00       	mov    $0x0,%eax
80105a04:	eb 3d                	jmp    80105a43 <sys_link+0x17f>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105a06:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	89 04 24             	mov    %eax,(%esp)
80105a0d:	e8 ef be ff ff       	call   80101901 <ilock>
  ip->nlink--;
80105a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a15:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a19:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	89 04 24             	mov    %eax,(%esp)
80105a29:	e8 0d bd ff ff       	call   8010173b <iupdate>
  iunlockput(ip);
80105a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a31:	89 04 24             	mov    %eax,(%esp)
80105a34:	e8 55 c1 ff ff       	call   80101b8e <iunlockput>
  end_op();
80105a39:	e8 3a db ff ff       	call   80103578 <end_op>
  return -1;
80105a3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a43:	c9                   	leave  
80105a44:	c3                   	ret    

80105a45 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a45:	55                   	push   %ebp
80105a46:	89 e5                	mov    %esp,%ebp
80105a48:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a4b:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a52:	eb 4b                	jmp    80105a9f <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a57:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105a61:	00 
80105a62:	89 54 24 08          	mov    %edx,0x8(%esp)
80105a66:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6d:	89 04 24             	mov    %eax,(%esp)
80105a70:	e8 8b c3 ff ff       	call   80101e00 <readi>
80105a75:	83 f8 10             	cmp    $0x10,%eax
80105a78:	74 0c                	je     80105a86 <isdirempty+0x41>
      panic("isdirempty: readi");
80105a7a:	c7 04 24 47 89 10 80 	movl   $0x80108947,(%esp)
80105a81:	e8 b7 aa ff ff       	call   8010053d <panic>
    if(de.inum != 0)
80105a86:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105a8a:	66 85 c0             	test   %ax,%ax
80105a8d:	74 07                	je     80105a96 <isdirempty+0x51>
      return 0;
80105a8f:	b8 00 00 00 00       	mov    $0x0,%eax
80105a94:	eb 1b                	jmp    80105ab1 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a99:	83 c0 10             	add    $0x10,%eax
80105a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa5:	8b 40 18             	mov    0x18(%eax),%eax
80105aa8:	39 c2                	cmp    %eax,%edx
80105aaa:	72 a8                	jb     80105a54 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105aac:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ab1:	c9                   	leave  
80105ab2:	c3                   	ret    

80105ab3 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ab3:	55                   	push   %ebp
80105ab4:	89 e5                	mov    %esp,%ebp
80105ab6:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ab9:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ac7:	e8 6f fa ff ff       	call   8010553b <argstr>
80105acc:	85 c0                	test   %eax,%eax
80105ace:	79 0a                	jns    80105ada <sys_unlink+0x27>
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad5:	e9 af 01 00 00       	jmp    80105c89 <sys_unlink+0x1d6>

  begin_op();
80105ada:	e8 17 da ff ff       	call   801034f6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105ae2:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105ae5:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ae9:	89 04 24             	mov    %eax,(%esp)
80105aec:	e8 e0 c9 ff ff       	call   801024d1 <nameiparent>
80105af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105af8:	75 0f                	jne    80105b09 <sys_unlink+0x56>
    end_op();
80105afa:	e8 79 da ff ff       	call   80103578 <end_op>
    return -1;
80105aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b04:	e9 80 01 00 00       	jmp    80105c89 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0c:	89 04 24             	mov    %eax,(%esp)
80105b0f:	e8 ed bd ff ff       	call   80101901 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b14:	c7 44 24 04 59 89 10 	movl   $0x80108959,0x4(%esp)
80105b1b:	80 
80105b1c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b1f:	89 04 24             	mov    %eax,(%esp)
80105b22:	e8 dd c5 ff ff       	call   80102104 <namecmp>
80105b27:	85 c0                	test   %eax,%eax
80105b29:	0f 84 45 01 00 00    	je     80105c74 <sys_unlink+0x1c1>
80105b2f:	c7 44 24 04 5b 89 10 	movl   $0x8010895b,0x4(%esp)
80105b36:	80 
80105b37:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b3a:	89 04 24             	mov    %eax,(%esp)
80105b3d:	e8 c2 c5 ff ff       	call   80102104 <namecmp>
80105b42:	85 c0                	test   %eax,%eax
80105b44:	0f 84 2a 01 00 00    	je     80105c74 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b4a:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b51:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5b:	89 04 24             	mov    %eax,(%esp)
80105b5e:	e8 c3 c5 ff ff       	call   80102126 <dirlookup>
80105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b6a:	0f 84 03 01 00 00    	je     80105c73 <sys_unlink+0x1c0>
    goto bad;
  ilock(ip);
80105b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b73:	89 04 24             	mov    %eax,(%esp)
80105b76:	e8 86 bd ff ff       	call   80101901 <ilock>

  if(ip->nlink < 1)
80105b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b82:	66 85 c0             	test   %ax,%ax
80105b85:	7f 0c                	jg     80105b93 <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105b87:	c7 04 24 5e 89 10 80 	movl   $0x8010895e,(%esp)
80105b8e:	e8 aa a9 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b96:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b9a:	66 83 f8 01          	cmp    $0x1,%ax
80105b9e:	75 1f                	jne    80105bbf <sys_unlink+0x10c>
80105ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba3:	89 04 24             	mov    %eax,(%esp)
80105ba6:	e8 9a fe ff ff       	call   80105a45 <isdirempty>
80105bab:	85 c0                	test   %eax,%eax
80105bad:	75 10                	jne    80105bbf <sys_unlink+0x10c>
    iunlockput(ip);
80105baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb2:	89 04 24             	mov    %eax,(%esp)
80105bb5:	e8 d4 bf ff ff       	call   80101b8e <iunlockput>
    goto bad;
80105bba:	e9 b5 00 00 00       	jmp    80105c74 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105bbf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105bc6:	00 
80105bc7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105bce:	00 
80105bcf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bd2:	89 04 24             	mov    %eax,(%esp)
80105bd5:	e8 74 f5 ff ff       	call   8010514e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bda:	8b 55 c8             	mov    -0x38(%ebp),%edx
80105bdd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105be7:	00 
80105be8:	89 54 24 08          	mov    %edx,0x8(%esp)
80105bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf3:	89 04 24             	mov    %eax,(%esp)
80105bf6:	e8 71 c3 ff ff       	call   80101f6c <writei>
80105bfb:	83 f8 10             	cmp    $0x10,%eax
80105bfe:	74 0c                	je     80105c0c <sys_unlink+0x159>
    panic("unlink: writei");
80105c00:	c7 04 24 70 89 10 80 	movl   $0x80108970,(%esp)
80105c07:	e8 31 a9 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR){
80105c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c13:	66 83 f8 01          	cmp    $0x1,%ax
80105c17:	75 1c                	jne    80105c35 <sys_unlink+0x182>
    dp->nlink--;
80105c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c20:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c26:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2d:	89 04 24             	mov    %eax,(%esp)
80105c30:	e8 06 bb ff ff       	call   8010173b <iupdate>
  }
  iunlockput(dp);
80105c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c38:	89 04 24             	mov    %eax,(%esp)
80105c3b:	e8 4e bf ff ff       	call   80101b8e <iunlockput>

  ip->nlink--;
80105c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c43:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c47:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c54:	89 04 24             	mov    %eax,(%esp)
80105c57:	e8 df ba ff ff       	call   8010173b <iupdate>
  iunlockput(ip);
80105c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5f:	89 04 24             	mov    %eax,(%esp)
80105c62:	e8 27 bf ff ff       	call   80101b8e <iunlockput>

  end_op();
80105c67:	e8 0c d9 ff ff       	call   80103578 <end_op>

  return 0;
80105c6c:	b8 00 00 00 00       	mov    $0x0,%eax
80105c71:	eb 16                	jmp    80105c89 <sys_unlink+0x1d6>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105c73:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c77:	89 04 24             	mov    %eax,(%esp)
80105c7a:	e8 0f bf ff ff       	call   80101b8e <iunlockput>
  end_op();
80105c7f:	e8 f4 d8 ff ff       	call   80103578 <end_op>
  return -1;
80105c84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c89:	c9                   	leave  
80105c8a:	c3                   	ret    

80105c8b <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c8b:	55                   	push   %ebp
80105c8c:	89 e5                	mov    %esp,%ebp
80105c8e:	83 ec 48             	sub    $0x48,%esp
80105c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c94:	8b 55 10             	mov    0x10(%ebp),%edx
80105c97:	8b 45 14             	mov    0x14(%ebp),%eax
80105c9a:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c9e:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ca2:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ca6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cad:	8b 45 08             	mov    0x8(%ebp),%eax
80105cb0:	89 04 24             	mov    %eax,(%esp)
80105cb3:	e8 19 c8 ff ff       	call   801024d1 <nameiparent>
80105cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cbf:	75 0a                	jne    80105ccb <create+0x40>
    return 0;
80105cc1:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc6:	e9 7e 01 00 00       	jmp    80105e49 <create+0x1be>
  ilock(dp);
80105ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cce:	89 04 24             	mov    %eax,(%esp)
80105cd1:	e8 2b bc ff ff       	call   80101901 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105cd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cd9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cdd:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce7:	89 04 24             	mov    %eax,(%esp)
80105cea:	e8 37 c4 ff ff       	call   80102126 <dirlookup>
80105cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cf6:	74 47                	je     80105d3f <create+0xb4>
    iunlockput(dp);
80105cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfb:	89 04 24             	mov    %eax,(%esp)
80105cfe:	e8 8b be ff ff       	call   80101b8e <iunlockput>
    ilock(ip);
80105d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d06:	89 04 24             	mov    %eax,(%esp)
80105d09:	e8 f3 bb ff ff       	call   80101901 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d0e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d13:	75 15                	jne    80105d2a <create+0x9f>
80105d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d18:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d1c:	66 83 f8 02          	cmp    $0x2,%ax
80105d20:	75 08                	jne    80105d2a <create+0x9f>
      return ip;
80105d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d25:	e9 1f 01 00 00       	jmp    80105e49 <create+0x1be>
    iunlockput(ip);
80105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2d:	89 04 24             	mov    %eax,(%esp)
80105d30:	e8 59 be ff ff       	call   80101b8e <iunlockput>
    return 0;
80105d35:	b8 00 00 00 00       	mov    $0x0,%eax
80105d3a:	e9 0a 01 00 00       	jmp    80105e49 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d3f:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d46:	8b 00                	mov    (%eax),%eax
80105d48:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d4c:	89 04 24             	mov    %eax,(%esp)
80105d4f:	e8 13 b9 ff ff       	call   80101667 <ialloc>
80105d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d5b:	75 0c                	jne    80105d69 <create+0xde>
    panic("create: ialloc");
80105d5d:	c7 04 24 7f 89 10 80 	movl   $0x8010897f,(%esp)
80105d64:	e8 d4 a7 ff ff       	call   8010053d <panic>

  ilock(ip);
80105d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6c:	89 04 24             	mov    %eax,(%esp)
80105d6f:	e8 8d bb ff ff       	call   80101901 <ilock>
  ip->major = major;
80105d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d77:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105d7b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d82:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105d86:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d96:	89 04 24             	mov    %eax,(%esp)
80105d99:	e8 9d b9 ff ff       	call   8010173b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105d9e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105da3:	75 6a                	jne    80105e0f <create+0x184>
    dp->nlink++;  // for ".."
80105da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dac:	8d 50 01             	lea    0x1(%eax),%edx
80105daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db2:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db9:	89 04 24             	mov    %eax,(%esp)
80105dbc:	e8 7a b9 ff ff       	call   8010173b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc4:	8b 40 04             	mov    0x4(%eax),%eax
80105dc7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dcb:	c7 44 24 04 59 89 10 	movl   $0x80108959,0x4(%esp)
80105dd2:	80 
80105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd6:	89 04 24             	mov    %eax,(%esp)
80105dd9:	e8 10 c4 ff ff       	call   801021ee <dirlink>
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 21                	js     80105e03 <create+0x178>
80105de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de5:	8b 40 04             	mov    0x4(%eax),%eax
80105de8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dec:	c7 44 24 04 5b 89 10 	movl   $0x8010895b,0x4(%esp)
80105df3:	80 
80105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df7:	89 04 24             	mov    %eax,(%esp)
80105dfa:	e8 ef c3 ff ff       	call   801021ee <dirlink>
80105dff:	85 c0                	test   %eax,%eax
80105e01:	79 0c                	jns    80105e0f <create+0x184>
      panic("create dots");
80105e03:	c7 04 24 8e 89 10 80 	movl   $0x8010898e,(%esp)
80105e0a:	e8 2e a7 ff ff       	call   8010053d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e12:	8b 40 04             	mov    0x4(%eax),%eax
80105e15:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e19:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e23:	89 04 24             	mov    %eax,(%esp)
80105e26:	e8 c3 c3 ff ff       	call   801021ee <dirlink>
80105e2b:	85 c0                	test   %eax,%eax
80105e2d:	79 0c                	jns    80105e3b <create+0x1b0>
    panic("create: dirlink");
80105e2f:	c7 04 24 9a 89 10 80 	movl   $0x8010899a,(%esp)
80105e36:	e8 02 a7 ff ff       	call   8010053d <panic>

  iunlockput(dp);
80105e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3e:	89 04 24             	mov    %eax,(%esp)
80105e41:	e8 48 bd ff ff       	call   80101b8e <iunlockput>

  return ip;
80105e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e49:	c9                   	leave  
80105e4a:	c3                   	ret    

80105e4b <sys_open>:

int
sys_open(void)
{
80105e4b:	55                   	push   %ebp
80105e4c:	89 e5                	mov    %esp,%ebp
80105e4e:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e51:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e5f:	e8 d7 f6 ff ff       	call   8010553b <argstr>
80105e64:	85 c0                	test   %eax,%eax
80105e66:	78 17                	js     80105e7f <sys_open+0x34>
80105e68:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e76:	e8 2f f6 ff ff       	call   801054aa <argint>
80105e7b:	85 c0                	test   %eax,%eax
80105e7d:	79 0a                	jns    80105e89 <sys_open+0x3e>
    return -1;
80105e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e84:	e9 5a 01 00 00       	jmp    80105fe3 <sys_open+0x198>

  begin_op();
80105e89:	e8 68 d6 ff ff       	call   801034f6 <begin_op>

  if(omode & O_CREATE){
80105e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e91:	25 00 02 00 00       	and    $0x200,%eax
80105e96:	85 c0                	test   %eax,%eax
80105e98:	74 3b                	je     80105ed5 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e9d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ea4:	00 
80105ea5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105eac:	00 
80105ead:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105eb4:	00 
80105eb5:	89 04 24             	mov    %eax,(%esp)
80105eb8:	e8 ce fd ff ff       	call   80105c8b <create>
80105ebd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ec4:	75 6b                	jne    80105f31 <sys_open+0xe6>
      end_op();
80105ec6:	e8 ad d6 ff ff       	call   80103578 <end_op>
      return -1;
80105ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed0:	e9 0e 01 00 00       	jmp    80105fe3 <sys_open+0x198>
    }
  } else {
    if((ip = namei(path)) == 0){
80105ed5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ed8:	89 04 24             	mov    %eax,(%esp)
80105edb:	e8 cf c5 ff ff       	call   801024af <namei>
80105ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee7:	75 0f                	jne    80105ef8 <sys_open+0xad>
      end_op();
80105ee9:	e8 8a d6 ff ff       	call   80103578 <end_op>
      return -1;
80105eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef3:	e9 eb 00 00 00       	jmp    80105fe3 <sys_open+0x198>
    }
    ilock(ip);
80105ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efb:	89 04 24             	mov    %eax,(%esp)
80105efe:	e8 fe b9 ff ff       	call   80101901 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f06:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f0a:	66 83 f8 01          	cmp    $0x1,%ax
80105f0e:	75 21                	jne    80105f31 <sys_open+0xe6>
80105f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f13:	85 c0                	test   %eax,%eax
80105f15:	74 1a                	je     80105f31 <sys_open+0xe6>
      iunlockput(ip);
80105f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f1a:	89 04 24             	mov    %eax,(%esp)
80105f1d:	e8 6c bc ff ff       	call   80101b8e <iunlockput>
      end_op();
80105f22:	e8 51 d6 ff ff       	call   80103578 <end_op>
      return -1;
80105f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2c:	e9 b2 00 00 00       	jmp    80105fe3 <sys_open+0x198>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f31:	e8 12 b0 ff ff       	call   80100f48 <filealloc>
80105f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f3d:	74 14                	je     80105f53 <sys_open+0x108>
80105f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f42:	89 04 24             	mov    %eax,(%esp)
80105f45:	e8 2f f7 ff ff       	call   80105679 <fdalloc>
80105f4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f51:	79 28                	jns    80105f7b <sys_open+0x130>
    if(f)
80105f53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f57:	74 0b                	je     80105f64 <sys_open+0x119>
      fileclose(f);
80105f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5c:	89 04 24             	mov    %eax,(%esp)
80105f5f:	e8 8d b0 ff ff       	call   80100ff1 <fileclose>
    iunlockput(ip);
80105f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f67:	89 04 24             	mov    %eax,(%esp)
80105f6a:	e8 1f bc ff ff       	call   80101b8e <iunlockput>
    end_op();
80105f6f:	e8 04 d6 ff ff       	call   80103578 <end_op>
    return -1;
80105f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f79:	eb 68                	jmp    80105fe3 <sys_open+0x198>
  }
  iunlock(ip);
80105f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7e:	89 04 24             	mov    %eax,(%esp)
80105f81:	e8 d2 ba ff ff       	call   80101a58 <iunlock>
  end_op();
80105f86:	e8 ed d5 ff ff       	call   80103578 <end_op>

  f->type = FD_INODE;
80105f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f9a:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105faa:	83 e0 01             	and    $0x1,%eax
80105fad:	85 c0                	test   %eax,%eax
80105faf:	0f 94 c2             	sete   %dl
80105fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb5:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fbb:	83 e0 01             	and    $0x1,%eax
80105fbe:	84 c0                	test   %al,%al
80105fc0:	75 0a                	jne    80105fcc <sys_open+0x181>
80105fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fc5:	83 e0 02             	and    $0x2,%eax
80105fc8:	85 c0                	test   %eax,%eax
80105fca:	74 07                	je     80105fd3 <sys_open+0x188>
80105fcc:	b8 01 00 00 00       	mov    $0x1,%eax
80105fd1:	eb 05                	jmp    80105fd8 <sys_open+0x18d>
80105fd3:	b8 00 00 00 00       	mov    $0x0,%eax
80105fd8:	89 c2                	mov    %eax,%edx
80105fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fdd:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105fe3:	c9                   	leave  
80105fe4:	c3                   	ret    

80105fe5 <sys_mkdir>:

int
sys_mkdir(void)
{
80105fe5:	55                   	push   %ebp
80105fe6:	89 e5                	mov    %esp,%ebp
80105fe8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105feb:	e8 06 d5 ff ff       	call   801034f6 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ff0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ffe:	e8 38 f5 ff ff       	call   8010553b <argstr>
80106003:	85 c0                	test   %eax,%eax
80106005:	78 2c                	js     80106033 <sys_mkdir+0x4e>
80106007:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106011:	00 
80106012:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106019:	00 
8010601a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106021:	00 
80106022:	89 04 24             	mov    %eax,(%esp)
80106025:	e8 61 fc ff ff       	call   80105c8b <create>
8010602a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010602d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106031:	75 0c                	jne    8010603f <sys_mkdir+0x5a>
    end_op();
80106033:	e8 40 d5 ff ff       	call   80103578 <end_op>
    return -1;
80106038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603d:	eb 15                	jmp    80106054 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010603f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106042:	89 04 24             	mov    %eax,(%esp)
80106045:	e8 44 bb ff ff       	call   80101b8e <iunlockput>
  end_op();
8010604a:	e8 29 d5 ff ff       	call   80103578 <end_op>
  return 0;
8010604f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106054:	c9                   	leave  
80106055:	c3                   	ret    

80106056 <sys_mknod>:

int
sys_mknod(void)
{
80106056:	55                   	push   %ebp
80106057:	89 e5                	mov    %esp,%ebp
80106059:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010605c:	e8 95 d4 ff ff       	call   801034f6 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106061:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106064:	89 44 24 04          	mov    %eax,0x4(%esp)
80106068:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010606f:	e8 c7 f4 ff ff       	call   8010553b <argstr>
80106074:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010607b:	78 5e                	js     801060db <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010607d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106080:	89 44 24 04          	mov    %eax,0x4(%esp)
80106084:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010608b:	e8 1a f4 ff ff       	call   801054aa <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106090:	85 c0                	test   %eax,%eax
80106092:	78 47                	js     801060db <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106094:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106097:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801060a2:	e8 03 f4 ff ff       	call   801054aa <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060a7:	85 c0                	test   %eax,%eax
801060a9:	78 30                	js     801060db <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060ae:	0f bf c8             	movswl %ax,%ecx
801060b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060b4:	0f bf d0             	movswl %ax,%edx
801060b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801060ba:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801060be:	89 54 24 08          	mov    %edx,0x8(%esp)
801060c2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801060c9:	00 
801060ca:	89 04 24             	mov    %eax,(%esp)
801060cd:	e8 b9 fb ff ff       	call   80105c8b <create>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060d9:	75 0c                	jne    801060e7 <sys_mknod+0x91>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801060db:	e8 98 d4 ff ff       	call   80103578 <end_op>
    return -1;
801060e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e5:	eb 15                	jmp    801060fc <sys_mknod+0xa6>
  }
  iunlockput(ip);
801060e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060ea:	89 04 24             	mov    %eax,(%esp)
801060ed:	e8 9c ba ff ff       	call   80101b8e <iunlockput>
  end_op();
801060f2:	e8 81 d4 ff ff       	call   80103578 <end_op>
  return 0;
801060f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060fc:	c9                   	leave  
801060fd:	c3                   	ret    

801060fe <sys_chdir>:

int
sys_chdir(void)
{
801060fe:	55                   	push   %ebp
801060ff:	89 e5                	mov    %esp,%ebp
80106101:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106104:	e8 ed d3 ff ff       	call   801034f6 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106109:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010610c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106117:	e8 1f f4 ff ff       	call   8010553b <argstr>
8010611c:	85 c0                	test   %eax,%eax
8010611e:	78 14                	js     80106134 <sys_chdir+0x36>
80106120:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106123:	89 04 24             	mov    %eax,(%esp)
80106126:	e8 84 c3 ff ff       	call   801024af <namei>
8010612b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010612e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106132:	75 0c                	jne    80106140 <sys_chdir+0x42>
    end_op();
80106134:	e8 3f d4 ff ff       	call   80103578 <end_op>
    return -1;
80106139:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010613e:	eb 61                	jmp    801061a1 <sys_chdir+0xa3>
  }
  ilock(ip);
80106140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106143:	89 04 24             	mov    %eax,(%esp)
80106146:	e8 b6 b7 ff ff       	call   80101901 <ilock>
  if(ip->type != T_DIR){
8010614b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106152:	66 83 f8 01          	cmp    $0x1,%ax
80106156:	74 17                	je     8010616f <sys_chdir+0x71>
    iunlockput(ip);
80106158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010615b:	89 04 24             	mov    %eax,(%esp)
8010615e:	e8 2b ba ff ff       	call   80101b8e <iunlockput>
    end_op();
80106163:	e8 10 d4 ff ff       	call   80103578 <end_op>
    return -1;
80106168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616d:	eb 32                	jmp    801061a1 <sys_chdir+0xa3>
  }
  iunlock(ip);
8010616f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106172:	89 04 24             	mov    %eax,(%esp)
80106175:	e8 de b8 ff ff       	call   80101a58 <iunlock>
  iput(proc->cwd);
8010617a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106180:	8b 40 68             	mov    0x68(%eax),%eax
80106183:	89 04 24             	mov    %eax,(%esp)
80106186:	e8 32 b9 ff ff       	call   80101abd <iput>
  end_op();
8010618b:	e8 e8 d3 ff ff       	call   80103578 <end_op>
  proc->cwd = ip;
80106190:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106196:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106199:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010619c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061a1:	c9                   	leave  
801061a2:	c3                   	ret    

801061a3 <sys_exec>:

int
sys_exec(void)
{
801061a3:	55                   	push   %ebp
801061a4:	89 e5                	mov    %esp,%ebp
801061a6:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061af:	89 44 24 04          	mov    %eax,0x4(%esp)
801061b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061ba:	e8 7c f3 ff ff       	call   8010553b <argstr>
801061bf:	85 c0                	test   %eax,%eax
801061c1:	78 1a                	js     801061dd <sys_exec+0x3a>
801061c3:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801061c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801061cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061d4:	e8 d1 f2 ff ff       	call   801054aa <argint>
801061d9:	85 c0                	test   %eax,%eax
801061db:	79 0a                	jns    801061e7 <sys_exec+0x44>
    return -1;
801061dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e2:	e9 cd 00 00 00       	jmp    801062b4 <sys_exec+0x111>
  }
  memset(argv, 0, sizeof(argv));
801061e7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801061ee:	00 
801061ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061f6:	00 
801061f7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801061fd:	89 04 24             	mov    %eax,(%esp)
80106200:	e8 49 ef ff ff       	call   8010514e <memset>
  for(i=0;; i++){
80106205:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	83 f8 1f             	cmp    $0x1f,%eax
80106212:	76 0a                	jbe    8010621e <sys_exec+0x7b>
      return -1;
80106214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106219:	e9 96 00 00 00       	jmp    801062b4 <sys_exec+0x111>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010621e:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106224:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106227:	c1 e2 02             	shl    $0x2,%edx
8010622a:	89 d1                	mov    %edx,%ecx
8010622c:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80106232:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80106235:	89 44 24 04          	mov    %eax,0x4(%esp)
80106239:	89 14 24             	mov    %edx,(%esp)
8010623c:	e8 cb f1 ff ff       	call   8010540c <fetchint>
80106241:	85 c0                	test   %eax,%eax
80106243:	79 07                	jns    8010624c <sys_exec+0xa9>
      return -1;
80106245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624a:	eb 68                	jmp    801062b4 <sys_exec+0x111>
    if(uarg == 0){
8010624c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106252:	85 c0                	test   %eax,%eax
80106254:	75 26                	jne    8010627c <sys_exec+0xd9>
      argv[i] = 0;
80106256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106259:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106260:	00 00 00 00 
      break;
80106264:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106268:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010626e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106272:	89 04 24             	mov    %eax,(%esp)
80106275:	e8 9a a8 ff ff       	call   80100b14 <exec>
8010627a:	eb 38                	jmp    801062b4 <sys_exec+0x111>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010627c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106286:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010628c:	01 d0                	add    %edx,%eax
8010628e:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106294:	89 44 24 04          	mov    %eax,0x4(%esp)
80106298:	89 14 24             	mov    %edx,(%esp)
8010629b:	e8 a6 f1 ff ff       	call   80105446 <fetchstr>
801062a0:	85 c0                	test   %eax,%eax
801062a2:	79 07                	jns    801062ab <sys_exec+0x108>
      return -1;
801062a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a9:	eb 09                	jmp    801062b4 <sys_exec+0x111>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062af:	e9 58 ff ff ff       	jmp    8010620c <sys_exec+0x69>
  return exec(path, argv);
}
801062b4:	c9                   	leave  
801062b5:	c3                   	ret    

801062b6 <sys_pipe>:

int
sys_pipe(void)
{
801062b6:	55                   	push   %ebp
801062b7:	89 e5                	mov    %esp,%ebp
801062b9:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062bf:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801062c6:	00 
801062c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801062cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062d2:	e8 02 f2 ff ff       	call   801054d9 <argptr>
801062d7:	85 c0                	test   %eax,%eax
801062d9:	79 0a                	jns    801062e5 <sys_pipe+0x2f>
    return -1;
801062db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e0:	e9 9b 00 00 00       	jmp    80106380 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801062e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ec:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062ef:	89 04 24             	mov    %eax,(%esp)
801062f2:	e8 15 dd ff ff       	call   8010400c <pipealloc>
801062f7:	85 c0                	test   %eax,%eax
801062f9:	79 07                	jns    80106302 <sys_pipe+0x4c>
    return -1;
801062fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106300:	eb 7e                	jmp    80106380 <sys_pipe+0xca>
  fd0 = -1;
80106302:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106309:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010630c:	89 04 24             	mov    %eax,(%esp)
8010630f:	e8 65 f3 ff ff       	call   80105679 <fdalloc>
80106314:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106317:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010631b:	78 14                	js     80106331 <sys_pipe+0x7b>
8010631d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106320:	89 04 24             	mov    %eax,(%esp)
80106323:	e8 51 f3 ff ff       	call   80105679 <fdalloc>
80106328:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010632b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010632f:	79 37                	jns    80106368 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106331:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106335:	78 14                	js     8010634b <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106337:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010633d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106340:	83 c2 08             	add    $0x8,%edx
80106343:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010634a:	00 
    fileclose(rf);
8010634b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010634e:	89 04 24             	mov    %eax,(%esp)
80106351:	e8 9b ac ff ff       	call   80100ff1 <fileclose>
    fileclose(wf);
80106356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106359:	89 04 24             	mov    %eax,(%esp)
8010635c:	e8 90 ac ff ff       	call   80100ff1 <fileclose>
    return -1;
80106361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106366:	eb 18                	jmp    80106380 <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106368:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010636b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010636e:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106370:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106373:	8d 50 04             	lea    0x4(%eax),%edx
80106376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106379:	89 02                	mov    %eax,(%edx)
  return 0;
8010637b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106380:	c9                   	leave  
80106381:	c3                   	ret    
	...

80106384 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106384:	55                   	push   %ebp
80106385:	89 e5                	mov    %esp,%ebp
80106387:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010638a:	e8 2c e3 ff ff       	call   801046bb <fork>
}
8010638f:	c9                   	leave  
80106390:	c3                   	ret    

80106391 <sys_exit>:

int
sys_exit(void)
{
80106391:	55                   	push   %ebp
80106392:	89 e5                	mov    %esp,%ebp
80106394:	83 ec 08             	sub    $0x8,%esp
  exit();
80106397:	e8 9a e4 ff ff       	call   80104836 <exit>
  return 0;  // not reached
8010639c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063a1:	c9                   	leave  
801063a2:	c3                   	ret    

801063a3 <sys_wait>:

int
sys_wait(void)
{
801063a3:	55                   	push   %ebp
801063a4:	89 e5                	mov    %esp,%ebp
801063a6:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063a9:	e8 ab e5 ff ff       	call   80104959 <wait>
}
801063ae:	c9                   	leave  
801063af:	c3                   	ret    

801063b0 <sys_kill>:

int
sys_kill(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801063bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063c4:	e8 e1 f0 ff ff       	call   801054aa <argint>
801063c9:	85 c0                	test   %eax,%eax
801063cb:	79 07                	jns    801063d4 <sys_kill+0x24>
    return -1;
801063cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d2:	eb 0b                	jmp    801063df <sys_kill+0x2f>
  return kill(pid);
801063d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d7:	89 04 24             	mov    %eax,(%esp)
801063da:	e8 4c e9 ff ff       	call   80104d2b <kill>
}
801063df:	c9                   	leave  
801063e0:	c3                   	ret    

801063e1 <sys_getpid>:

int
sys_getpid(void)
{
801063e1:	55                   	push   %ebp
801063e2:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801063e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063ea:	8b 40 10             	mov    0x10(%eax),%eax
}
801063ed:	5d                   	pop    %ebp
801063ee:	c3                   	ret    

801063ef <sys_sbrk>:

int
sys_sbrk(void)
{
801063ef:	55                   	push   %ebp
801063f0:	89 e5                	mov    %esp,%ebp
801063f2:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801063fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106403:	e8 a2 f0 ff ff       	call   801054aa <argint>
80106408:	85 c0                	test   %eax,%eax
8010640a:	79 07                	jns    80106413 <sys_sbrk+0x24>
    return -1;
8010640c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106411:	eb 24                	jmp    80106437 <sys_sbrk+0x48>
  addr = proc->sz;
80106413:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106419:	8b 00                	mov    (%eax),%eax
8010641b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010641e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106421:	89 04 24             	mov    %eax,(%esp)
80106424:	e8 ed e1 ff ff       	call   80104616 <growproc>
80106429:	85 c0                	test   %eax,%eax
8010642b:	79 07                	jns    80106434 <sys_sbrk+0x45>
    return -1;
8010642d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106432:	eb 03                	jmp    80106437 <sys_sbrk+0x48>
  return addr;
80106434:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106437:	c9                   	leave  
80106438:	c3                   	ret    

80106439 <sys_sleep>:

int
sys_sleep(void)
{
80106439:	55                   	push   %ebp
8010643a:	89 e5                	mov    %esp,%ebp
8010643c:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010643f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106442:	89 44 24 04          	mov    %eax,0x4(%esp)
80106446:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010644d:	e8 58 f0 ff ff       	call   801054aa <argint>
80106452:	85 c0                	test   %eax,%eax
80106454:	79 07                	jns    8010645d <sys_sleep+0x24>
    return -1;
80106456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645b:	eb 6c                	jmp    801064c9 <sys_sleep+0x90>
  acquire(&tickslock);
8010645d:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106464:	e8 8e ea ff ff       	call   80104ef7 <acquire>
  ticks0 = ticks;
80106469:	a1 e0 50 11 80       	mov    0x801150e0,%eax
8010646e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106471:	eb 34                	jmp    801064a7 <sys_sleep+0x6e>
    if(proc->killed){
80106473:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106479:	8b 40 24             	mov    0x24(%eax),%eax
8010647c:	85 c0                	test   %eax,%eax
8010647e:	74 13                	je     80106493 <sys_sleep+0x5a>
      release(&tickslock);
80106480:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106487:	e8 cc ea ff ff       	call   80104f58 <release>
      return -1;
8010648c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106491:	eb 36                	jmp    801064c9 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106493:	c7 44 24 04 a0 48 11 	movl   $0x801148a0,0x4(%esp)
8010649a:	80 
8010649b:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
801064a2:	e8 7f e7 ff ff       	call   80104c26 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064a7:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801064ac:	89 c2                	mov    %eax,%edx
801064ae:	2b 55 f4             	sub    -0xc(%ebp),%edx
801064b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b4:	39 c2                	cmp    %eax,%edx
801064b6:	72 bb                	jb     80106473 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064b8:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801064bf:	e8 94 ea ff ff       	call   80104f58 <release>
  return 0;
801064c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064c9:	c9                   	leave  
801064ca:	c3                   	ret    

801064cb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064cb:	55                   	push   %ebp
801064cc:	89 e5                	mov    %esp,%ebp
801064ce:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801064d1:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801064d8:	e8 1a ea ff ff       	call   80104ef7 <acquire>
  xticks = ticks;
801064dd:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801064e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801064e5:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801064ec:	e8 67 ea ff ff       	call   80104f58 <release>
  return xticks;
801064f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064f4:	c9                   	leave  
801064f5:	c3                   	ret    
	...

801064f8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801064f8:	55                   	push   %ebp
801064f9:	89 e5                	mov    %esp,%ebp
801064fb:	83 ec 08             	sub    $0x8,%esp
801064fe:	8b 55 08             	mov    0x8(%ebp),%edx
80106501:	8b 45 0c             	mov    0xc(%ebp),%eax
80106504:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106508:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010650b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010650f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106513:	ee                   	out    %al,(%dx)
}
80106514:	c9                   	leave  
80106515:	c3                   	ret    

80106516 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106516:	55                   	push   %ebp
80106517:	89 e5                	mov    %esp,%ebp
80106519:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010651c:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106523:	00 
80106524:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
8010652b:	e8 c8 ff ff ff       	call   801064f8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106530:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106537:	00 
80106538:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010653f:	e8 b4 ff ff ff       	call   801064f8 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106544:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010654b:	00 
8010654c:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106553:	e8 a0 ff ff ff       	call   801064f8 <outb>
  picenable(IRQ_TIMER);
80106558:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010655f:	e8 31 d9 ff ff       	call   80103e95 <picenable>
}
80106564:	c9                   	leave  
80106565:	c3                   	ret    
	...

80106568 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106568:	1e                   	push   %ds
  pushl %es
80106569:	06                   	push   %es
  pushl %fs
8010656a:	0f a0                	push   %fs
  pushl %gs
8010656c:	0f a8                	push   %gs
  pushal
8010656e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010656f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106573:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106575:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106577:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010657b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010657d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010657f:	54                   	push   %esp
  call trap
80106580:	e8 d5 01 00 00       	call   8010675a <trap>
  addl $4, %esp
80106585:	83 c4 04             	add    $0x4,%esp

80106588 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106588:	61                   	popa   
  popl %gs
80106589:	0f a9                	pop    %gs
  popl %fs
8010658b:	0f a1                	pop    %fs
  popl %es
8010658d:	07                   	pop    %es
  popl %ds
8010658e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010658f:	83 c4 08             	add    $0x8,%esp
  iret
80106592:	cf                   	iret   
	...

80106594 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106594:	55                   	push   %ebp
80106595:	89 e5                	mov    %esp,%ebp
80106597:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010659a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010659d:	83 e8 01             	sub    $0x1,%eax
801065a0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065a4:	8b 45 08             	mov    0x8(%ebp),%eax
801065a7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065ab:	8b 45 08             	mov    0x8(%ebp),%eax
801065ae:	c1 e8 10             	shr    $0x10,%eax
801065b1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801065b5:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065b8:	0f 01 18             	lidtl  (%eax)
}
801065bb:	c9                   	leave  
801065bc:	c3                   	ret    

801065bd <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801065bd:	55                   	push   %ebp
801065be:	89 e5                	mov    %esp,%ebp
801065c0:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065c3:	0f 20 d0             	mov    %cr2,%eax
801065c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801065c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065cc:	c9                   	leave  
801065cd:	c3                   	ret    

801065ce <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065ce:	55                   	push   %ebp
801065cf:	89 e5                	mov    %esp,%ebp
801065d1:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801065d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065db:	e9 bf 00 00 00       	jmp    8010669f <tvinit+0xd1>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065e6:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
801065ed:	66 89 14 c5 e0 48 11 	mov    %dx,-0x7feeb720(,%eax,8)
801065f4:	80 
801065f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f8:	66 c7 04 c5 e2 48 11 	movw   $0x8,-0x7feeb71e(,%eax,8)
801065ff:	80 08 00 
80106602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106605:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
8010660c:	80 
8010660d:	83 e2 e0             	and    $0xffffffe0,%edx
80106610:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
80106617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661a:	0f b6 14 c5 e4 48 11 	movzbl -0x7feeb71c(,%eax,8),%edx
80106621:	80 
80106622:	83 e2 1f             	and    $0x1f,%edx
80106625:	88 14 c5 e4 48 11 80 	mov    %dl,-0x7feeb71c(,%eax,8)
8010662c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662f:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106636:	80 
80106637:	83 e2 f0             	and    $0xfffffff0,%edx
8010663a:	83 ca 0e             	or     $0xe,%edx
8010663d:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106647:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
8010664e:	80 
8010664f:	83 e2 ef             	and    $0xffffffef,%edx
80106652:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010665c:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106663:	80 
80106664:	83 e2 9f             	and    $0xffffff9f,%edx
80106667:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
8010666e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106671:	0f b6 14 c5 e5 48 11 	movzbl -0x7feeb71b(,%eax,8),%edx
80106678:	80 
80106679:	83 ca 80             	or     $0xffffff80,%edx
8010667c:	88 14 c5 e5 48 11 80 	mov    %dl,-0x7feeb71b(,%eax,8)
80106683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106686:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106689:	8b 14 95 98 b0 10 80 	mov    -0x7fef4f68(,%edx,4),%edx
80106690:	c1 ea 10             	shr    $0x10,%edx
80106693:	66 89 14 c5 e6 48 11 	mov    %dx,-0x7feeb71a(,%eax,8)
8010669a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010669b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010669f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801066a6:	0f 8e 34 ff ff ff    	jle    801065e0 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066ac:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801066b1:	66 a3 e0 4a 11 80    	mov    %ax,0x80114ae0
801066b7:	66 c7 05 e2 4a 11 80 	movw   $0x8,0x80114ae2
801066be:	08 00 
801066c0:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801066c7:	83 e0 e0             	and    $0xffffffe0,%eax
801066ca:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801066cf:	0f b6 05 e4 4a 11 80 	movzbl 0x80114ae4,%eax
801066d6:	83 e0 1f             	and    $0x1f,%eax
801066d9:	a2 e4 4a 11 80       	mov    %al,0x80114ae4
801066de:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801066e5:	83 c8 0f             	or     $0xf,%eax
801066e8:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801066ed:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
801066f4:	83 e0 ef             	and    $0xffffffef,%eax
801066f7:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
801066fc:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
80106703:	83 c8 60             	or     $0x60,%eax
80106706:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010670b:	0f b6 05 e5 4a 11 80 	movzbl 0x80114ae5,%eax
80106712:	83 c8 80             	or     $0xffffff80,%eax
80106715:	a2 e5 4a 11 80       	mov    %al,0x80114ae5
8010671a:	a1 98 b1 10 80       	mov    0x8010b198,%eax
8010671f:	c1 e8 10             	shr    $0x10,%eax
80106722:	66 a3 e6 4a 11 80    	mov    %ax,0x80114ae6
  
  initlock(&tickslock, "time");
80106728:	c7 44 24 04 ac 89 10 	movl   $0x801089ac,0x4(%esp)
8010672f:	80 
80106730:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106737:	e8 9a e7 ff ff       	call   80104ed6 <initlock>
}
8010673c:	c9                   	leave  
8010673d:	c3                   	ret    

8010673e <idtinit>:

void
idtinit(void)
{
8010673e:	55                   	push   %ebp
8010673f:	89 e5                	mov    %esp,%ebp
80106741:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106744:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010674b:	00 
8010674c:	c7 04 24 e0 48 11 80 	movl   $0x801148e0,(%esp)
80106753:	e8 3c fe ff ff       	call   80106594 <lidt>
}
80106758:	c9                   	leave  
80106759:	c3                   	ret    

8010675a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010675a:	55                   	push   %ebp
8010675b:	89 e5                	mov    %esp,%ebp
8010675d:	57                   	push   %edi
8010675e:	56                   	push   %esi
8010675f:	53                   	push   %ebx
80106760:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106763:	8b 45 08             	mov    0x8(%ebp),%eax
80106766:	8b 40 30             	mov    0x30(%eax),%eax
80106769:	83 f8 40             	cmp    $0x40,%eax
8010676c:	75 3e                	jne    801067ac <trap+0x52>
    if(proc->killed)
8010676e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106774:	8b 40 24             	mov    0x24(%eax),%eax
80106777:	85 c0                	test   %eax,%eax
80106779:	74 05                	je     80106780 <trap+0x26>
      exit();
8010677b:	e8 b6 e0 ff ff       	call   80104836 <exit>
    proc->tf = tf;
80106780:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106786:	8b 55 08             	mov    0x8(%ebp),%edx
80106789:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010678c:	e8 e1 ed ff ff       	call   80105572 <syscall>
    if(proc->killed)
80106791:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106797:	8b 40 24             	mov    0x24(%eax),%eax
8010679a:	85 c0                	test   %eax,%eax
8010679c:	0f 84 34 02 00 00    	je     801069d6 <trap+0x27c>
      exit();
801067a2:	e8 8f e0 ff ff       	call   80104836 <exit>
    return;
801067a7:	e9 2b 02 00 00       	jmp    801069d7 <trap+0x27d>
  }

  switch(tf->trapno){
801067ac:	8b 45 08             	mov    0x8(%ebp),%eax
801067af:	8b 40 30             	mov    0x30(%eax),%eax
801067b2:	83 e8 20             	sub    $0x20,%eax
801067b5:	83 f8 1f             	cmp    $0x1f,%eax
801067b8:	0f 87 bc 00 00 00    	ja     8010687a <trap+0x120>
801067be:	8b 04 85 54 8a 10 80 	mov    -0x7fef75ac(,%eax,4),%eax
801067c5:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801067c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067cd:	0f b6 00             	movzbl (%eax),%eax
801067d0:	84 c0                	test   %al,%al
801067d2:	75 31                	jne    80106805 <trap+0xab>
      acquire(&tickslock);
801067d4:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
801067db:	e8 17 e7 ff ff       	call   80104ef7 <acquire>
      ticks++;
801067e0:	a1 e0 50 11 80       	mov    0x801150e0,%eax
801067e5:	83 c0 01             	add    $0x1,%eax
801067e8:	a3 e0 50 11 80       	mov    %eax,0x801150e0
      wakeup(&ticks);
801067ed:	c7 04 24 e0 50 11 80 	movl   $0x801150e0,(%esp)
801067f4:	e8 07 e5 ff ff       	call   80104d00 <wakeup>
      release(&tickslock);
801067f9:	c7 04 24 a0 48 11 80 	movl   $0x801148a0,(%esp)
80106800:	e8 53 e7 ff ff       	call   80104f58 <release>
    }
    lapiceoi();
80106805:	e8 b7 c7 ff ff       	call   80102fc1 <lapiceoi>
    break;
8010680a:	e9 41 01 00 00       	jmp    80106950 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010680f:	e8 aa bf ff ff       	call   801027be <ideintr>
    lapiceoi();
80106814:	e8 a8 c7 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106819:	e9 32 01 00 00       	jmp    80106950 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010681e:	e8 64 c5 ff ff       	call   80102d87 <kbdintr>
    lapiceoi();
80106823:	e8 99 c7 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106828:	e9 23 01 00 00       	jmp    80106950 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010682d:	e8 9d 03 00 00       	call   80106bcf <uartintr>
    lapiceoi();
80106832:	e8 8a c7 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106837:	e9 14 01 00 00       	jmp    80106950 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010683c:	8b 45 08             	mov    0x8(%ebp),%eax
8010683f:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106842:	8b 45 08             	mov    0x8(%ebp),%eax
80106845:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106849:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010684c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106852:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106855:	0f b6 c0             	movzbl %al,%eax
80106858:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010685c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106860:	89 44 24 04          	mov    %eax,0x4(%esp)
80106864:	c7 04 24 b4 89 10 80 	movl   $0x801089b4,(%esp)
8010686b:	e8 2d 9b ff ff       	call   8010039d <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106870:	e8 4c c7 ff ff       	call   80102fc1 <lapiceoi>
    break;
80106875:	e9 d6 00 00 00       	jmp    80106950 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010687a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106880:	85 c0                	test   %eax,%eax
80106882:	74 11                	je     80106895 <trap+0x13b>
80106884:	8b 45 08             	mov    0x8(%ebp),%eax
80106887:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010688b:	0f b7 c0             	movzwl %ax,%eax
8010688e:	83 e0 03             	and    $0x3,%eax
80106891:	85 c0                	test   %eax,%eax
80106893:	75 46                	jne    801068db <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106895:	e8 23 fd ff ff       	call   801065bd <rcr2>
8010689a:	8b 55 08             	mov    0x8(%ebp),%edx
8010689d:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
801068a0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801068a7:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068aa:	0f b6 ca             	movzbl %dl,%ecx
801068ad:	8b 55 08             	mov    0x8(%ebp),%edx
801068b0:	8b 52 30             	mov    0x30(%edx),%edx
801068b3:	89 44 24 10          	mov    %eax,0x10(%esp)
801068b7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801068bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801068c3:	c7 04 24 d8 89 10 80 	movl   $0x801089d8,(%esp)
801068ca:	e8 ce 9a ff ff       	call   8010039d <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801068cf:	c7 04 24 0a 8a 10 80 	movl   $0x80108a0a,(%esp)
801068d6:	e8 62 9c ff ff       	call   8010053d <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068db:	e8 dd fc ff ff       	call   801065bd <rcr2>
801068e0:	89 c2                	mov    %eax,%edx
801068e2:	8b 45 08             	mov    0x8(%ebp),%eax
801068e5:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801068e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068ee:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068f1:	0f b6 f0             	movzbl %al,%esi
801068f4:	8b 45 08             	mov    0x8(%ebp),%eax
801068f7:	8b 58 34             	mov    0x34(%eax),%ebx
801068fa:	8b 45 08             	mov    0x8(%ebp),%eax
801068fd:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106906:	83 c0 6c             	add    $0x6c,%eax
80106909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010690c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106912:	8b 40 10             	mov    0x10(%eax),%eax
80106915:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106919:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010691d:	89 74 24 14          	mov    %esi,0x14(%esp)
80106921:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106925:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010692c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106930:	89 44 24 04          	mov    %eax,0x4(%esp)
80106934:	c7 04 24 10 8a 10 80 	movl   $0x80108a10,(%esp)
8010693b:	e8 5d 9a ff ff       	call   8010039d <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106940:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106946:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010694d:	eb 01                	jmp    80106950 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010694f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106950:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106956:	85 c0                	test   %eax,%eax
80106958:	74 24                	je     8010697e <trap+0x224>
8010695a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106960:	8b 40 24             	mov    0x24(%eax),%eax
80106963:	85 c0                	test   %eax,%eax
80106965:	74 17                	je     8010697e <trap+0x224>
80106967:	8b 45 08             	mov    0x8(%ebp),%eax
8010696a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010696e:	0f b7 c0             	movzwl %ax,%eax
80106971:	83 e0 03             	and    $0x3,%eax
80106974:	83 f8 03             	cmp    $0x3,%eax
80106977:	75 05                	jne    8010697e <trap+0x224>
    exit();
80106979:	e8 b8 de ff ff       	call   80104836 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010697e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106984:	85 c0                	test   %eax,%eax
80106986:	74 1e                	je     801069a6 <trap+0x24c>
80106988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010698e:	8b 40 0c             	mov    0xc(%eax),%eax
80106991:	83 f8 04             	cmp    $0x4,%eax
80106994:	75 10                	jne    801069a6 <trap+0x24c>
80106996:	8b 45 08             	mov    0x8(%ebp),%eax
80106999:	8b 40 30             	mov    0x30(%eax),%eax
8010699c:	83 f8 20             	cmp    $0x20,%eax
8010699f:	75 05                	jne    801069a6 <trap+0x24c>
    yield();
801069a1:	e8 0f e2 ff ff       	call   80104bb5 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ac:	85 c0                	test   %eax,%eax
801069ae:	74 27                	je     801069d7 <trap+0x27d>
801069b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069b6:	8b 40 24             	mov    0x24(%eax),%eax
801069b9:	85 c0                	test   %eax,%eax
801069bb:	74 1a                	je     801069d7 <trap+0x27d>
801069bd:	8b 45 08             	mov    0x8(%ebp),%eax
801069c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069c4:	0f b7 c0             	movzwl %ax,%eax
801069c7:	83 e0 03             	and    $0x3,%eax
801069ca:	83 f8 03             	cmp    $0x3,%eax
801069cd:	75 08                	jne    801069d7 <trap+0x27d>
    exit();
801069cf:	e8 62 de ff ff       	call   80104836 <exit>
801069d4:	eb 01                	jmp    801069d7 <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801069d6:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801069d7:	83 c4 3c             	add    $0x3c,%esp
801069da:	5b                   	pop    %ebx
801069db:	5e                   	pop    %esi
801069dc:	5f                   	pop    %edi
801069dd:	5d                   	pop    %ebp
801069de:	c3                   	ret    
	...

801069e0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 14             	sub    $0x14,%esp
801069e6:	8b 45 08             	mov    0x8(%ebp),%eax
801069e9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801069f1:	89 c2                	mov    %eax,%edx
801069f3:	ec                   	in     (%dx),%al
801069f4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801069f7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801069fb:	c9                   	leave  
801069fc:	c3                   	ret    

801069fd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801069fd:	55                   	push   %ebp
801069fe:	89 e5                	mov    %esp,%ebp
80106a00:	83 ec 08             	sub    $0x8,%esp
80106a03:	8b 55 08             	mov    0x8(%ebp),%edx
80106a06:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a09:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a0d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a10:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a14:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a18:	ee                   	out    %al,(%dx)
}
80106a19:	c9                   	leave  
80106a1a:	c3                   	ret    

80106a1b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106a1b:	55                   	push   %ebp
80106a1c:	89 e5                	mov    %esp,%ebp
80106a1e:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a28:	00 
80106a29:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106a30:	e8 c8 ff ff ff       	call   801069fd <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106a35:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106a3c:	00 
80106a3d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106a44:	e8 b4 ff ff ff       	call   801069fd <outb>
  outb(COM1+0, 115200/9600);
80106a49:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106a50:	00 
80106a51:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a58:	e8 a0 ff ff ff       	call   801069fd <outb>
  outb(COM1+1, 0);
80106a5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a64:	00 
80106a65:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106a6c:	e8 8c ff ff ff       	call   801069fd <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a71:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106a78:	00 
80106a79:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106a80:	e8 78 ff ff ff       	call   801069fd <outb>
  outb(COM1+4, 0);
80106a85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a8c:	00 
80106a8d:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106a94:	e8 64 ff ff ff       	call   801069fd <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a99:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106aa0:	00 
80106aa1:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106aa8:	e8 50 ff ff ff       	call   801069fd <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106aad:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ab4:	e8 27 ff ff ff       	call   801069e0 <inb>
80106ab9:	3c ff                	cmp    $0xff,%al
80106abb:	74 6c                	je     80106b29 <uartinit+0x10e>
    return;
  uart = 1;
80106abd:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106ac4:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ac7:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106ace:	e8 0d ff ff ff       	call   801069e0 <inb>
  inb(COM1+0);
80106ad3:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ada:	e8 01 ff ff ff       	call   801069e0 <inb>
  picenable(IRQ_COM1);
80106adf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ae6:	e8 aa d3 ff ff       	call   80103e95 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106aeb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106af2:	00 
80106af3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106afa:	e8 43 bf ff ff       	call   80102a42 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106aff:	c7 45 f4 d4 8a 10 80 	movl   $0x80108ad4,-0xc(%ebp)
80106b06:	eb 15                	jmp    80106b1d <uartinit+0x102>
    uartputc(*p);
80106b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0b:	0f b6 00             	movzbl (%eax),%eax
80106b0e:	0f be c0             	movsbl %al,%eax
80106b11:	89 04 24             	mov    %eax,(%esp)
80106b14:	e8 13 00 00 00       	call   80106b2c <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b19:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b20:	0f b6 00             	movzbl (%eax),%eax
80106b23:	84 c0                	test   %al,%al
80106b25:	75 e1                	jne    80106b08 <uartinit+0xed>
80106b27:	eb 01                	jmp    80106b2a <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106b29:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106b2a:	c9                   	leave  
80106b2b:	c3                   	ret    

80106b2c <uartputc>:

void
uartputc(int c)
{
80106b2c:	55                   	push   %ebp
80106b2d:	89 e5                	mov    %esp,%ebp
80106b2f:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106b32:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106b37:	85 c0                	test   %eax,%eax
80106b39:	74 4d                	je     80106b88 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b42:	eb 10                	jmp    80106b54 <uartputc+0x28>
    microdelay(10);
80106b44:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106b4b:	e8 96 c4 ff ff       	call   80102fe6 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b50:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b54:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b58:	7f 16                	jg     80106b70 <uartputc+0x44>
80106b5a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b61:	e8 7a fe ff ff       	call   801069e0 <inb>
80106b66:	0f b6 c0             	movzbl %al,%eax
80106b69:	83 e0 20             	and    $0x20,%eax
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	74 d4                	je     80106b44 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106b70:	8b 45 08             	mov    0x8(%ebp),%eax
80106b73:	0f b6 c0             	movzbl %al,%eax
80106b76:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b7a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b81:	e8 77 fe ff ff       	call   801069fd <outb>
80106b86:	eb 01                	jmp    80106b89 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106b88:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106b89:	c9                   	leave  
80106b8a:	c3                   	ret    

80106b8b <uartgetc>:

static int
uartgetc(void)
{
80106b8b:	55                   	push   %ebp
80106b8c:	89 e5                	mov    %esp,%ebp
80106b8e:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106b91:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106b96:	85 c0                	test   %eax,%eax
80106b98:	75 07                	jne    80106ba1 <uartgetc+0x16>
    return -1;
80106b9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9f:	eb 2c                	jmp    80106bcd <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106ba1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ba8:	e8 33 fe ff ff       	call   801069e0 <inb>
80106bad:	0f b6 c0             	movzbl %al,%eax
80106bb0:	83 e0 01             	and    $0x1,%eax
80106bb3:	85 c0                	test   %eax,%eax
80106bb5:	75 07                	jne    80106bbe <uartgetc+0x33>
    return -1;
80106bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bbc:	eb 0f                	jmp    80106bcd <uartgetc+0x42>
  return inb(COM1+0);
80106bbe:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106bc5:	e8 16 fe ff ff       	call   801069e0 <inb>
80106bca:	0f b6 c0             	movzbl %al,%eax
}
80106bcd:	c9                   	leave  
80106bce:	c3                   	ret    

80106bcf <uartintr>:

void
uartintr(void)
{
80106bcf:	55                   	push   %ebp
80106bd0:	89 e5                	mov    %esp,%ebp
80106bd2:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106bd5:	c7 04 24 8b 6b 10 80 	movl   $0x80106b8b,(%esp)
80106bdc:	e8 e8 9b ff ff       	call   801007c9 <consoleintr>
}
80106be1:	c9                   	leave  
80106be2:	c3                   	ret    
	...

80106be4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $0
80106be6:	6a 00                	push   $0x0
  jmp alltraps
80106be8:	e9 7b f9 ff ff       	jmp    80106568 <alltraps>

80106bed <vector1>:
.globl vector1
vector1:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $1
80106bef:	6a 01                	push   $0x1
  jmp alltraps
80106bf1:	e9 72 f9 ff ff       	jmp    80106568 <alltraps>

80106bf6 <vector2>:
.globl vector2
vector2:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $2
80106bf8:	6a 02                	push   $0x2
  jmp alltraps
80106bfa:	e9 69 f9 ff ff       	jmp    80106568 <alltraps>

80106bff <vector3>:
.globl vector3
vector3:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $3
80106c01:	6a 03                	push   $0x3
  jmp alltraps
80106c03:	e9 60 f9 ff ff       	jmp    80106568 <alltraps>

80106c08 <vector4>:
.globl vector4
vector4:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $4
80106c0a:	6a 04                	push   $0x4
  jmp alltraps
80106c0c:	e9 57 f9 ff ff       	jmp    80106568 <alltraps>

80106c11 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $5
80106c13:	6a 05                	push   $0x5
  jmp alltraps
80106c15:	e9 4e f9 ff ff       	jmp    80106568 <alltraps>

80106c1a <vector6>:
.globl vector6
vector6:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $6
80106c1c:	6a 06                	push   $0x6
  jmp alltraps
80106c1e:	e9 45 f9 ff ff       	jmp    80106568 <alltraps>

80106c23 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $7
80106c25:	6a 07                	push   $0x7
  jmp alltraps
80106c27:	e9 3c f9 ff ff       	jmp    80106568 <alltraps>

80106c2c <vector8>:
.globl vector8
vector8:
  pushl $8
80106c2c:	6a 08                	push   $0x8
  jmp alltraps
80106c2e:	e9 35 f9 ff ff       	jmp    80106568 <alltraps>

80106c33 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $9
80106c35:	6a 09                	push   $0x9
  jmp alltraps
80106c37:	e9 2c f9 ff ff       	jmp    80106568 <alltraps>

80106c3c <vector10>:
.globl vector10
vector10:
  pushl $10
80106c3c:	6a 0a                	push   $0xa
  jmp alltraps
80106c3e:	e9 25 f9 ff ff       	jmp    80106568 <alltraps>

80106c43 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c43:	6a 0b                	push   $0xb
  jmp alltraps
80106c45:	e9 1e f9 ff ff       	jmp    80106568 <alltraps>

80106c4a <vector12>:
.globl vector12
vector12:
  pushl $12
80106c4a:	6a 0c                	push   $0xc
  jmp alltraps
80106c4c:	e9 17 f9 ff ff       	jmp    80106568 <alltraps>

80106c51 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c51:	6a 0d                	push   $0xd
  jmp alltraps
80106c53:	e9 10 f9 ff ff       	jmp    80106568 <alltraps>

80106c58 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c58:	6a 0e                	push   $0xe
  jmp alltraps
80106c5a:	e9 09 f9 ff ff       	jmp    80106568 <alltraps>

80106c5f <vector15>:
.globl vector15
vector15:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $15
80106c61:	6a 0f                	push   $0xf
  jmp alltraps
80106c63:	e9 00 f9 ff ff       	jmp    80106568 <alltraps>

80106c68 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $16
80106c6a:	6a 10                	push   $0x10
  jmp alltraps
80106c6c:	e9 f7 f8 ff ff       	jmp    80106568 <alltraps>

80106c71 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c71:	6a 11                	push   $0x11
  jmp alltraps
80106c73:	e9 f0 f8 ff ff       	jmp    80106568 <alltraps>

80106c78 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c78:	6a 00                	push   $0x0
  pushl $18
80106c7a:	6a 12                	push   $0x12
  jmp alltraps
80106c7c:	e9 e7 f8 ff ff       	jmp    80106568 <alltraps>

80106c81 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c81:	6a 00                	push   $0x0
  pushl $19
80106c83:	6a 13                	push   $0x13
  jmp alltraps
80106c85:	e9 de f8 ff ff       	jmp    80106568 <alltraps>

80106c8a <vector20>:
.globl vector20
vector20:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $20
80106c8c:	6a 14                	push   $0x14
  jmp alltraps
80106c8e:	e9 d5 f8 ff ff       	jmp    80106568 <alltraps>

80106c93 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $21
80106c95:	6a 15                	push   $0x15
  jmp alltraps
80106c97:	e9 cc f8 ff ff       	jmp    80106568 <alltraps>

80106c9c <vector22>:
.globl vector22
vector22:
  pushl $0
80106c9c:	6a 00                	push   $0x0
  pushl $22
80106c9e:	6a 16                	push   $0x16
  jmp alltraps
80106ca0:	e9 c3 f8 ff ff       	jmp    80106568 <alltraps>

80106ca5 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $23
80106ca7:	6a 17                	push   $0x17
  jmp alltraps
80106ca9:	e9 ba f8 ff ff       	jmp    80106568 <alltraps>

80106cae <vector24>:
.globl vector24
vector24:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $24
80106cb0:	6a 18                	push   $0x18
  jmp alltraps
80106cb2:	e9 b1 f8 ff ff       	jmp    80106568 <alltraps>

80106cb7 <vector25>:
.globl vector25
vector25:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $25
80106cb9:	6a 19                	push   $0x19
  jmp alltraps
80106cbb:	e9 a8 f8 ff ff       	jmp    80106568 <alltraps>

80106cc0 <vector26>:
.globl vector26
vector26:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $26
80106cc2:	6a 1a                	push   $0x1a
  jmp alltraps
80106cc4:	e9 9f f8 ff ff       	jmp    80106568 <alltraps>

80106cc9 <vector27>:
.globl vector27
vector27:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $27
80106ccb:	6a 1b                	push   $0x1b
  jmp alltraps
80106ccd:	e9 96 f8 ff ff       	jmp    80106568 <alltraps>

80106cd2 <vector28>:
.globl vector28
vector28:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $28
80106cd4:	6a 1c                	push   $0x1c
  jmp alltraps
80106cd6:	e9 8d f8 ff ff       	jmp    80106568 <alltraps>

80106cdb <vector29>:
.globl vector29
vector29:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $29
80106cdd:	6a 1d                	push   $0x1d
  jmp alltraps
80106cdf:	e9 84 f8 ff ff       	jmp    80106568 <alltraps>

80106ce4 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $30
80106ce6:	6a 1e                	push   $0x1e
  jmp alltraps
80106ce8:	e9 7b f8 ff ff       	jmp    80106568 <alltraps>

80106ced <vector31>:
.globl vector31
vector31:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $31
80106cef:	6a 1f                	push   $0x1f
  jmp alltraps
80106cf1:	e9 72 f8 ff ff       	jmp    80106568 <alltraps>

80106cf6 <vector32>:
.globl vector32
vector32:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $32
80106cf8:	6a 20                	push   $0x20
  jmp alltraps
80106cfa:	e9 69 f8 ff ff       	jmp    80106568 <alltraps>

80106cff <vector33>:
.globl vector33
vector33:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $33
80106d01:	6a 21                	push   $0x21
  jmp alltraps
80106d03:	e9 60 f8 ff ff       	jmp    80106568 <alltraps>

80106d08 <vector34>:
.globl vector34
vector34:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $34
80106d0a:	6a 22                	push   $0x22
  jmp alltraps
80106d0c:	e9 57 f8 ff ff       	jmp    80106568 <alltraps>

80106d11 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $35
80106d13:	6a 23                	push   $0x23
  jmp alltraps
80106d15:	e9 4e f8 ff ff       	jmp    80106568 <alltraps>

80106d1a <vector36>:
.globl vector36
vector36:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $36
80106d1c:	6a 24                	push   $0x24
  jmp alltraps
80106d1e:	e9 45 f8 ff ff       	jmp    80106568 <alltraps>

80106d23 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $37
80106d25:	6a 25                	push   $0x25
  jmp alltraps
80106d27:	e9 3c f8 ff ff       	jmp    80106568 <alltraps>

80106d2c <vector38>:
.globl vector38
vector38:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $38
80106d2e:	6a 26                	push   $0x26
  jmp alltraps
80106d30:	e9 33 f8 ff ff       	jmp    80106568 <alltraps>

80106d35 <vector39>:
.globl vector39
vector39:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $39
80106d37:	6a 27                	push   $0x27
  jmp alltraps
80106d39:	e9 2a f8 ff ff       	jmp    80106568 <alltraps>

80106d3e <vector40>:
.globl vector40
vector40:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $40
80106d40:	6a 28                	push   $0x28
  jmp alltraps
80106d42:	e9 21 f8 ff ff       	jmp    80106568 <alltraps>

80106d47 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $41
80106d49:	6a 29                	push   $0x29
  jmp alltraps
80106d4b:	e9 18 f8 ff ff       	jmp    80106568 <alltraps>

80106d50 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $42
80106d52:	6a 2a                	push   $0x2a
  jmp alltraps
80106d54:	e9 0f f8 ff ff       	jmp    80106568 <alltraps>

80106d59 <vector43>:
.globl vector43
vector43:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $43
80106d5b:	6a 2b                	push   $0x2b
  jmp alltraps
80106d5d:	e9 06 f8 ff ff       	jmp    80106568 <alltraps>

80106d62 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $44
80106d64:	6a 2c                	push   $0x2c
  jmp alltraps
80106d66:	e9 fd f7 ff ff       	jmp    80106568 <alltraps>

80106d6b <vector45>:
.globl vector45
vector45:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $45
80106d6d:	6a 2d                	push   $0x2d
  jmp alltraps
80106d6f:	e9 f4 f7 ff ff       	jmp    80106568 <alltraps>

80106d74 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $46
80106d76:	6a 2e                	push   $0x2e
  jmp alltraps
80106d78:	e9 eb f7 ff ff       	jmp    80106568 <alltraps>

80106d7d <vector47>:
.globl vector47
vector47:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $47
80106d7f:	6a 2f                	push   $0x2f
  jmp alltraps
80106d81:	e9 e2 f7 ff ff       	jmp    80106568 <alltraps>

80106d86 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $48
80106d88:	6a 30                	push   $0x30
  jmp alltraps
80106d8a:	e9 d9 f7 ff ff       	jmp    80106568 <alltraps>

80106d8f <vector49>:
.globl vector49
vector49:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $49
80106d91:	6a 31                	push   $0x31
  jmp alltraps
80106d93:	e9 d0 f7 ff ff       	jmp    80106568 <alltraps>

80106d98 <vector50>:
.globl vector50
vector50:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $50
80106d9a:	6a 32                	push   $0x32
  jmp alltraps
80106d9c:	e9 c7 f7 ff ff       	jmp    80106568 <alltraps>

80106da1 <vector51>:
.globl vector51
vector51:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $51
80106da3:	6a 33                	push   $0x33
  jmp alltraps
80106da5:	e9 be f7 ff ff       	jmp    80106568 <alltraps>

80106daa <vector52>:
.globl vector52
vector52:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $52
80106dac:	6a 34                	push   $0x34
  jmp alltraps
80106dae:	e9 b5 f7 ff ff       	jmp    80106568 <alltraps>

80106db3 <vector53>:
.globl vector53
vector53:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $53
80106db5:	6a 35                	push   $0x35
  jmp alltraps
80106db7:	e9 ac f7 ff ff       	jmp    80106568 <alltraps>

80106dbc <vector54>:
.globl vector54
vector54:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $54
80106dbe:	6a 36                	push   $0x36
  jmp alltraps
80106dc0:	e9 a3 f7 ff ff       	jmp    80106568 <alltraps>

80106dc5 <vector55>:
.globl vector55
vector55:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $55
80106dc7:	6a 37                	push   $0x37
  jmp alltraps
80106dc9:	e9 9a f7 ff ff       	jmp    80106568 <alltraps>

80106dce <vector56>:
.globl vector56
vector56:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $56
80106dd0:	6a 38                	push   $0x38
  jmp alltraps
80106dd2:	e9 91 f7 ff ff       	jmp    80106568 <alltraps>

80106dd7 <vector57>:
.globl vector57
vector57:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $57
80106dd9:	6a 39                	push   $0x39
  jmp alltraps
80106ddb:	e9 88 f7 ff ff       	jmp    80106568 <alltraps>

80106de0 <vector58>:
.globl vector58
vector58:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $58
80106de2:	6a 3a                	push   $0x3a
  jmp alltraps
80106de4:	e9 7f f7 ff ff       	jmp    80106568 <alltraps>

80106de9 <vector59>:
.globl vector59
vector59:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $59
80106deb:	6a 3b                	push   $0x3b
  jmp alltraps
80106ded:	e9 76 f7 ff ff       	jmp    80106568 <alltraps>

80106df2 <vector60>:
.globl vector60
vector60:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $60
80106df4:	6a 3c                	push   $0x3c
  jmp alltraps
80106df6:	e9 6d f7 ff ff       	jmp    80106568 <alltraps>

80106dfb <vector61>:
.globl vector61
vector61:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $61
80106dfd:	6a 3d                	push   $0x3d
  jmp alltraps
80106dff:	e9 64 f7 ff ff       	jmp    80106568 <alltraps>

80106e04 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $62
80106e06:	6a 3e                	push   $0x3e
  jmp alltraps
80106e08:	e9 5b f7 ff ff       	jmp    80106568 <alltraps>

80106e0d <vector63>:
.globl vector63
vector63:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $63
80106e0f:	6a 3f                	push   $0x3f
  jmp alltraps
80106e11:	e9 52 f7 ff ff       	jmp    80106568 <alltraps>

80106e16 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $64
80106e18:	6a 40                	push   $0x40
  jmp alltraps
80106e1a:	e9 49 f7 ff ff       	jmp    80106568 <alltraps>

80106e1f <vector65>:
.globl vector65
vector65:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $65
80106e21:	6a 41                	push   $0x41
  jmp alltraps
80106e23:	e9 40 f7 ff ff       	jmp    80106568 <alltraps>

80106e28 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $66
80106e2a:	6a 42                	push   $0x42
  jmp alltraps
80106e2c:	e9 37 f7 ff ff       	jmp    80106568 <alltraps>

80106e31 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $67
80106e33:	6a 43                	push   $0x43
  jmp alltraps
80106e35:	e9 2e f7 ff ff       	jmp    80106568 <alltraps>

80106e3a <vector68>:
.globl vector68
vector68:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $68
80106e3c:	6a 44                	push   $0x44
  jmp alltraps
80106e3e:	e9 25 f7 ff ff       	jmp    80106568 <alltraps>

80106e43 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $69
80106e45:	6a 45                	push   $0x45
  jmp alltraps
80106e47:	e9 1c f7 ff ff       	jmp    80106568 <alltraps>

80106e4c <vector70>:
.globl vector70
vector70:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $70
80106e4e:	6a 46                	push   $0x46
  jmp alltraps
80106e50:	e9 13 f7 ff ff       	jmp    80106568 <alltraps>

80106e55 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $71
80106e57:	6a 47                	push   $0x47
  jmp alltraps
80106e59:	e9 0a f7 ff ff       	jmp    80106568 <alltraps>

80106e5e <vector72>:
.globl vector72
vector72:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $72
80106e60:	6a 48                	push   $0x48
  jmp alltraps
80106e62:	e9 01 f7 ff ff       	jmp    80106568 <alltraps>

80106e67 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $73
80106e69:	6a 49                	push   $0x49
  jmp alltraps
80106e6b:	e9 f8 f6 ff ff       	jmp    80106568 <alltraps>

80106e70 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $74
80106e72:	6a 4a                	push   $0x4a
  jmp alltraps
80106e74:	e9 ef f6 ff ff       	jmp    80106568 <alltraps>

80106e79 <vector75>:
.globl vector75
vector75:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $75
80106e7b:	6a 4b                	push   $0x4b
  jmp alltraps
80106e7d:	e9 e6 f6 ff ff       	jmp    80106568 <alltraps>

80106e82 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $76
80106e84:	6a 4c                	push   $0x4c
  jmp alltraps
80106e86:	e9 dd f6 ff ff       	jmp    80106568 <alltraps>

80106e8b <vector77>:
.globl vector77
vector77:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $77
80106e8d:	6a 4d                	push   $0x4d
  jmp alltraps
80106e8f:	e9 d4 f6 ff ff       	jmp    80106568 <alltraps>

80106e94 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $78
80106e96:	6a 4e                	push   $0x4e
  jmp alltraps
80106e98:	e9 cb f6 ff ff       	jmp    80106568 <alltraps>

80106e9d <vector79>:
.globl vector79
vector79:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $79
80106e9f:	6a 4f                	push   $0x4f
  jmp alltraps
80106ea1:	e9 c2 f6 ff ff       	jmp    80106568 <alltraps>

80106ea6 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $80
80106ea8:	6a 50                	push   $0x50
  jmp alltraps
80106eaa:	e9 b9 f6 ff ff       	jmp    80106568 <alltraps>

80106eaf <vector81>:
.globl vector81
vector81:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $81
80106eb1:	6a 51                	push   $0x51
  jmp alltraps
80106eb3:	e9 b0 f6 ff ff       	jmp    80106568 <alltraps>

80106eb8 <vector82>:
.globl vector82
vector82:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $82
80106eba:	6a 52                	push   $0x52
  jmp alltraps
80106ebc:	e9 a7 f6 ff ff       	jmp    80106568 <alltraps>

80106ec1 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $83
80106ec3:	6a 53                	push   $0x53
  jmp alltraps
80106ec5:	e9 9e f6 ff ff       	jmp    80106568 <alltraps>

80106eca <vector84>:
.globl vector84
vector84:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $84
80106ecc:	6a 54                	push   $0x54
  jmp alltraps
80106ece:	e9 95 f6 ff ff       	jmp    80106568 <alltraps>

80106ed3 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $85
80106ed5:	6a 55                	push   $0x55
  jmp alltraps
80106ed7:	e9 8c f6 ff ff       	jmp    80106568 <alltraps>

80106edc <vector86>:
.globl vector86
vector86:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $86
80106ede:	6a 56                	push   $0x56
  jmp alltraps
80106ee0:	e9 83 f6 ff ff       	jmp    80106568 <alltraps>

80106ee5 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $87
80106ee7:	6a 57                	push   $0x57
  jmp alltraps
80106ee9:	e9 7a f6 ff ff       	jmp    80106568 <alltraps>

80106eee <vector88>:
.globl vector88
vector88:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $88
80106ef0:	6a 58                	push   $0x58
  jmp alltraps
80106ef2:	e9 71 f6 ff ff       	jmp    80106568 <alltraps>

80106ef7 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $89
80106ef9:	6a 59                	push   $0x59
  jmp alltraps
80106efb:	e9 68 f6 ff ff       	jmp    80106568 <alltraps>

80106f00 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $90
80106f02:	6a 5a                	push   $0x5a
  jmp alltraps
80106f04:	e9 5f f6 ff ff       	jmp    80106568 <alltraps>

80106f09 <vector91>:
.globl vector91
vector91:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $91
80106f0b:	6a 5b                	push   $0x5b
  jmp alltraps
80106f0d:	e9 56 f6 ff ff       	jmp    80106568 <alltraps>

80106f12 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $92
80106f14:	6a 5c                	push   $0x5c
  jmp alltraps
80106f16:	e9 4d f6 ff ff       	jmp    80106568 <alltraps>

80106f1b <vector93>:
.globl vector93
vector93:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $93
80106f1d:	6a 5d                	push   $0x5d
  jmp alltraps
80106f1f:	e9 44 f6 ff ff       	jmp    80106568 <alltraps>

80106f24 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $94
80106f26:	6a 5e                	push   $0x5e
  jmp alltraps
80106f28:	e9 3b f6 ff ff       	jmp    80106568 <alltraps>

80106f2d <vector95>:
.globl vector95
vector95:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $95
80106f2f:	6a 5f                	push   $0x5f
  jmp alltraps
80106f31:	e9 32 f6 ff ff       	jmp    80106568 <alltraps>

80106f36 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $96
80106f38:	6a 60                	push   $0x60
  jmp alltraps
80106f3a:	e9 29 f6 ff ff       	jmp    80106568 <alltraps>

80106f3f <vector97>:
.globl vector97
vector97:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $97
80106f41:	6a 61                	push   $0x61
  jmp alltraps
80106f43:	e9 20 f6 ff ff       	jmp    80106568 <alltraps>

80106f48 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $98
80106f4a:	6a 62                	push   $0x62
  jmp alltraps
80106f4c:	e9 17 f6 ff ff       	jmp    80106568 <alltraps>

80106f51 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $99
80106f53:	6a 63                	push   $0x63
  jmp alltraps
80106f55:	e9 0e f6 ff ff       	jmp    80106568 <alltraps>

80106f5a <vector100>:
.globl vector100
vector100:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $100
80106f5c:	6a 64                	push   $0x64
  jmp alltraps
80106f5e:	e9 05 f6 ff ff       	jmp    80106568 <alltraps>

80106f63 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $101
80106f65:	6a 65                	push   $0x65
  jmp alltraps
80106f67:	e9 fc f5 ff ff       	jmp    80106568 <alltraps>

80106f6c <vector102>:
.globl vector102
vector102:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $102
80106f6e:	6a 66                	push   $0x66
  jmp alltraps
80106f70:	e9 f3 f5 ff ff       	jmp    80106568 <alltraps>

80106f75 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $103
80106f77:	6a 67                	push   $0x67
  jmp alltraps
80106f79:	e9 ea f5 ff ff       	jmp    80106568 <alltraps>

80106f7e <vector104>:
.globl vector104
vector104:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $104
80106f80:	6a 68                	push   $0x68
  jmp alltraps
80106f82:	e9 e1 f5 ff ff       	jmp    80106568 <alltraps>

80106f87 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $105
80106f89:	6a 69                	push   $0x69
  jmp alltraps
80106f8b:	e9 d8 f5 ff ff       	jmp    80106568 <alltraps>

80106f90 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $106
80106f92:	6a 6a                	push   $0x6a
  jmp alltraps
80106f94:	e9 cf f5 ff ff       	jmp    80106568 <alltraps>

80106f99 <vector107>:
.globl vector107
vector107:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $107
80106f9b:	6a 6b                	push   $0x6b
  jmp alltraps
80106f9d:	e9 c6 f5 ff ff       	jmp    80106568 <alltraps>

80106fa2 <vector108>:
.globl vector108
vector108:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $108
80106fa4:	6a 6c                	push   $0x6c
  jmp alltraps
80106fa6:	e9 bd f5 ff ff       	jmp    80106568 <alltraps>

80106fab <vector109>:
.globl vector109
vector109:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $109
80106fad:	6a 6d                	push   $0x6d
  jmp alltraps
80106faf:	e9 b4 f5 ff ff       	jmp    80106568 <alltraps>

80106fb4 <vector110>:
.globl vector110
vector110:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $110
80106fb6:	6a 6e                	push   $0x6e
  jmp alltraps
80106fb8:	e9 ab f5 ff ff       	jmp    80106568 <alltraps>

80106fbd <vector111>:
.globl vector111
vector111:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $111
80106fbf:	6a 6f                	push   $0x6f
  jmp alltraps
80106fc1:	e9 a2 f5 ff ff       	jmp    80106568 <alltraps>

80106fc6 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $112
80106fc8:	6a 70                	push   $0x70
  jmp alltraps
80106fca:	e9 99 f5 ff ff       	jmp    80106568 <alltraps>

80106fcf <vector113>:
.globl vector113
vector113:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $113
80106fd1:	6a 71                	push   $0x71
  jmp alltraps
80106fd3:	e9 90 f5 ff ff       	jmp    80106568 <alltraps>

80106fd8 <vector114>:
.globl vector114
vector114:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $114
80106fda:	6a 72                	push   $0x72
  jmp alltraps
80106fdc:	e9 87 f5 ff ff       	jmp    80106568 <alltraps>

80106fe1 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $115
80106fe3:	6a 73                	push   $0x73
  jmp alltraps
80106fe5:	e9 7e f5 ff ff       	jmp    80106568 <alltraps>

80106fea <vector116>:
.globl vector116
vector116:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $116
80106fec:	6a 74                	push   $0x74
  jmp alltraps
80106fee:	e9 75 f5 ff ff       	jmp    80106568 <alltraps>

80106ff3 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $117
80106ff5:	6a 75                	push   $0x75
  jmp alltraps
80106ff7:	e9 6c f5 ff ff       	jmp    80106568 <alltraps>

80106ffc <vector118>:
.globl vector118
vector118:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $118
80106ffe:	6a 76                	push   $0x76
  jmp alltraps
80107000:	e9 63 f5 ff ff       	jmp    80106568 <alltraps>

80107005 <vector119>:
.globl vector119
vector119:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $119
80107007:	6a 77                	push   $0x77
  jmp alltraps
80107009:	e9 5a f5 ff ff       	jmp    80106568 <alltraps>

8010700e <vector120>:
.globl vector120
vector120:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $120
80107010:	6a 78                	push   $0x78
  jmp alltraps
80107012:	e9 51 f5 ff ff       	jmp    80106568 <alltraps>

80107017 <vector121>:
.globl vector121
vector121:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $121
80107019:	6a 79                	push   $0x79
  jmp alltraps
8010701b:	e9 48 f5 ff ff       	jmp    80106568 <alltraps>

80107020 <vector122>:
.globl vector122
vector122:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $122
80107022:	6a 7a                	push   $0x7a
  jmp alltraps
80107024:	e9 3f f5 ff ff       	jmp    80106568 <alltraps>

80107029 <vector123>:
.globl vector123
vector123:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $123
8010702b:	6a 7b                	push   $0x7b
  jmp alltraps
8010702d:	e9 36 f5 ff ff       	jmp    80106568 <alltraps>

80107032 <vector124>:
.globl vector124
vector124:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $124
80107034:	6a 7c                	push   $0x7c
  jmp alltraps
80107036:	e9 2d f5 ff ff       	jmp    80106568 <alltraps>

8010703b <vector125>:
.globl vector125
vector125:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $125
8010703d:	6a 7d                	push   $0x7d
  jmp alltraps
8010703f:	e9 24 f5 ff ff       	jmp    80106568 <alltraps>

80107044 <vector126>:
.globl vector126
vector126:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $126
80107046:	6a 7e                	push   $0x7e
  jmp alltraps
80107048:	e9 1b f5 ff ff       	jmp    80106568 <alltraps>

8010704d <vector127>:
.globl vector127
vector127:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $127
8010704f:	6a 7f                	push   $0x7f
  jmp alltraps
80107051:	e9 12 f5 ff ff       	jmp    80106568 <alltraps>

80107056 <vector128>:
.globl vector128
vector128:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $128
80107058:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010705d:	e9 06 f5 ff ff       	jmp    80106568 <alltraps>

80107062 <vector129>:
.globl vector129
vector129:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $129
80107064:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107069:	e9 fa f4 ff ff       	jmp    80106568 <alltraps>

8010706e <vector130>:
.globl vector130
vector130:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $130
80107070:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107075:	e9 ee f4 ff ff       	jmp    80106568 <alltraps>

8010707a <vector131>:
.globl vector131
vector131:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $131
8010707c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107081:	e9 e2 f4 ff ff       	jmp    80106568 <alltraps>

80107086 <vector132>:
.globl vector132
vector132:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $132
80107088:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010708d:	e9 d6 f4 ff ff       	jmp    80106568 <alltraps>

80107092 <vector133>:
.globl vector133
vector133:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $133
80107094:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107099:	e9 ca f4 ff ff       	jmp    80106568 <alltraps>

8010709e <vector134>:
.globl vector134
vector134:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $134
801070a0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801070a5:	e9 be f4 ff ff       	jmp    80106568 <alltraps>

801070aa <vector135>:
.globl vector135
vector135:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $135
801070ac:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070b1:	e9 b2 f4 ff ff       	jmp    80106568 <alltraps>

801070b6 <vector136>:
.globl vector136
vector136:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $136
801070b8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070bd:	e9 a6 f4 ff ff       	jmp    80106568 <alltraps>

801070c2 <vector137>:
.globl vector137
vector137:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $137
801070c4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070c9:	e9 9a f4 ff ff       	jmp    80106568 <alltraps>

801070ce <vector138>:
.globl vector138
vector138:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $138
801070d0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070d5:	e9 8e f4 ff ff       	jmp    80106568 <alltraps>

801070da <vector139>:
.globl vector139
vector139:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $139
801070dc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070e1:	e9 82 f4 ff ff       	jmp    80106568 <alltraps>

801070e6 <vector140>:
.globl vector140
vector140:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $140
801070e8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070ed:	e9 76 f4 ff ff       	jmp    80106568 <alltraps>

801070f2 <vector141>:
.globl vector141
vector141:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $141
801070f4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070f9:	e9 6a f4 ff ff       	jmp    80106568 <alltraps>

801070fe <vector142>:
.globl vector142
vector142:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $142
80107100:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107105:	e9 5e f4 ff ff       	jmp    80106568 <alltraps>

8010710a <vector143>:
.globl vector143
vector143:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $143
8010710c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107111:	e9 52 f4 ff ff       	jmp    80106568 <alltraps>

80107116 <vector144>:
.globl vector144
vector144:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $144
80107118:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010711d:	e9 46 f4 ff ff       	jmp    80106568 <alltraps>

80107122 <vector145>:
.globl vector145
vector145:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $145
80107124:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107129:	e9 3a f4 ff ff       	jmp    80106568 <alltraps>

8010712e <vector146>:
.globl vector146
vector146:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $146
80107130:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107135:	e9 2e f4 ff ff       	jmp    80106568 <alltraps>

8010713a <vector147>:
.globl vector147
vector147:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $147
8010713c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107141:	e9 22 f4 ff ff       	jmp    80106568 <alltraps>

80107146 <vector148>:
.globl vector148
vector148:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $148
80107148:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010714d:	e9 16 f4 ff ff       	jmp    80106568 <alltraps>

80107152 <vector149>:
.globl vector149
vector149:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $149
80107154:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107159:	e9 0a f4 ff ff       	jmp    80106568 <alltraps>

8010715e <vector150>:
.globl vector150
vector150:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $150
80107160:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107165:	e9 fe f3 ff ff       	jmp    80106568 <alltraps>

8010716a <vector151>:
.globl vector151
vector151:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $151
8010716c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107171:	e9 f2 f3 ff ff       	jmp    80106568 <alltraps>

80107176 <vector152>:
.globl vector152
vector152:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $152
80107178:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010717d:	e9 e6 f3 ff ff       	jmp    80106568 <alltraps>

80107182 <vector153>:
.globl vector153
vector153:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $153
80107184:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107189:	e9 da f3 ff ff       	jmp    80106568 <alltraps>

8010718e <vector154>:
.globl vector154
vector154:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $154
80107190:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107195:	e9 ce f3 ff ff       	jmp    80106568 <alltraps>

8010719a <vector155>:
.globl vector155
vector155:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $155
8010719c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801071a1:	e9 c2 f3 ff ff       	jmp    80106568 <alltraps>

801071a6 <vector156>:
.globl vector156
vector156:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $156
801071a8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071ad:	e9 b6 f3 ff ff       	jmp    80106568 <alltraps>

801071b2 <vector157>:
.globl vector157
vector157:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $157
801071b4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071b9:	e9 aa f3 ff ff       	jmp    80106568 <alltraps>

801071be <vector158>:
.globl vector158
vector158:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $158
801071c0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071c5:	e9 9e f3 ff ff       	jmp    80106568 <alltraps>

801071ca <vector159>:
.globl vector159
vector159:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $159
801071cc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071d1:	e9 92 f3 ff ff       	jmp    80106568 <alltraps>

801071d6 <vector160>:
.globl vector160
vector160:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $160
801071d8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071dd:	e9 86 f3 ff ff       	jmp    80106568 <alltraps>

801071e2 <vector161>:
.globl vector161
vector161:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $161
801071e4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071e9:	e9 7a f3 ff ff       	jmp    80106568 <alltraps>

801071ee <vector162>:
.globl vector162
vector162:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $162
801071f0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071f5:	e9 6e f3 ff ff       	jmp    80106568 <alltraps>

801071fa <vector163>:
.globl vector163
vector163:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $163
801071fc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107201:	e9 62 f3 ff ff       	jmp    80106568 <alltraps>

80107206 <vector164>:
.globl vector164
vector164:
  pushl $0
80107206:	6a 00                	push   $0x0
  pushl $164
80107208:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010720d:	e9 56 f3 ff ff       	jmp    80106568 <alltraps>

80107212 <vector165>:
.globl vector165
vector165:
  pushl $0
80107212:	6a 00                	push   $0x0
  pushl $165
80107214:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107219:	e9 4a f3 ff ff       	jmp    80106568 <alltraps>

8010721e <vector166>:
.globl vector166
vector166:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $166
80107220:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107225:	e9 3e f3 ff ff       	jmp    80106568 <alltraps>

8010722a <vector167>:
.globl vector167
vector167:
  pushl $0
8010722a:	6a 00                	push   $0x0
  pushl $167
8010722c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107231:	e9 32 f3 ff ff       	jmp    80106568 <alltraps>

80107236 <vector168>:
.globl vector168
vector168:
  pushl $0
80107236:	6a 00                	push   $0x0
  pushl $168
80107238:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010723d:	e9 26 f3 ff ff       	jmp    80106568 <alltraps>

80107242 <vector169>:
.globl vector169
vector169:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $169
80107244:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107249:	e9 1a f3 ff ff       	jmp    80106568 <alltraps>

8010724e <vector170>:
.globl vector170
vector170:
  pushl $0
8010724e:	6a 00                	push   $0x0
  pushl $170
80107250:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107255:	e9 0e f3 ff ff       	jmp    80106568 <alltraps>

8010725a <vector171>:
.globl vector171
vector171:
  pushl $0
8010725a:	6a 00                	push   $0x0
  pushl $171
8010725c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107261:	e9 02 f3 ff ff       	jmp    80106568 <alltraps>

80107266 <vector172>:
.globl vector172
vector172:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $172
80107268:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010726d:	e9 f6 f2 ff ff       	jmp    80106568 <alltraps>

80107272 <vector173>:
.globl vector173
vector173:
  pushl $0
80107272:	6a 00                	push   $0x0
  pushl $173
80107274:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107279:	e9 ea f2 ff ff       	jmp    80106568 <alltraps>

8010727e <vector174>:
.globl vector174
vector174:
  pushl $0
8010727e:	6a 00                	push   $0x0
  pushl $174
80107280:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107285:	e9 de f2 ff ff       	jmp    80106568 <alltraps>

8010728a <vector175>:
.globl vector175
vector175:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $175
8010728c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107291:	e9 d2 f2 ff ff       	jmp    80106568 <alltraps>

80107296 <vector176>:
.globl vector176
vector176:
  pushl $0
80107296:	6a 00                	push   $0x0
  pushl $176
80107298:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010729d:	e9 c6 f2 ff ff       	jmp    80106568 <alltraps>

801072a2 <vector177>:
.globl vector177
vector177:
  pushl $0
801072a2:	6a 00                	push   $0x0
  pushl $177
801072a4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072a9:	e9 ba f2 ff ff       	jmp    80106568 <alltraps>

801072ae <vector178>:
.globl vector178
vector178:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $178
801072b0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072b5:	e9 ae f2 ff ff       	jmp    80106568 <alltraps>

801072ba <vector179>:
.globl vector179
vector179:
  pushl $0
801072ba:	6a 00                	push   $0x0
  pushl $179
801072bc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072c1:	e9 a2 f2 ff ff       	jmp    80106568 <alltraps>

801072c6 <vector180>:
.globl vector180
vector180:
  pushl $0
801072c6:	6a 00                	push   $0x0
  pushl $180
801072c8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072cd:	e9 96 f2 ff ff       	jmp    80106568 <alltraps>

801072d2 <vector181>:
.globl vector181
vector181:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $181
801072d4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072d9:	e9 8a f2 ff ff       	jmp    80106568 <alltraps>

801072de <vector182>:
.globl vector182
vector182:
  pushl $0
801072de:	6a 00                	push   $0x0
  pushl $182
801072e0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072e5:	e9 7e f2 ff ff       	jmp    80106568 <alltraps>

801072ea <vector183>:
.globl vector183
vector183:
  pushl $0
801072ea:	6a 00                	push   $0x0
  pushl $183
801072ec:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072f1:	e9 72 f2 ff ff       	jmp    80106568 <alltraps>

801072f6 <vector184>:
.globl vector184
vector184:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $184
801072f8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072fd:	e9 66 f2 ff ff       	jmp    80106568 <alltraps>

80107302 <vector185>:
.globl vector185
vector185:
  pushl $0
80107302:	6a 00                	push   $0x0
  pushl $185
80107304:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107309:	e9 5a f2 ff ff       	jmp    80106568 <alltraps>

8010730e <vector186>:
.globl vector186
vector186:
  pushl $0
8010730e:	6a 00                	push   $0x0
  pushl $186
80107310:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107315:	e9 4e f2 ff ff       	jmp    80106568 <alltraps>

8010731a <vector187>:
.globl vector187
vector187:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $187
8010731c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107321:	e9 42 f2 ff ff       	jmp    80106568 <alltraps>

80107326 <vector188>:
.globl vector188
vector188:
  pushl $0
80107326:	6a 00                	push   $0x0
  pushl $188
80107328:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010732d:	e9 36 f2 ff ff       	jmp    80106568 <alltraps>

80107332 <vector189>:
.globl vector189
vector189:
  pushl $0
80107332:	6a 00                	push   $0x0
  pushl $189
80107334:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107339:	e9 2a f2 ff ff       	jmp    80106568 <alltraps>

8010733e <vector190>:
.globl vector190
vector190:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $190
80107340:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107345:	e9 1e f2 ff ff       	jmp    80106568 <alltraps>

8010734a <vector191>:
.globl vector191
vector191:
  pushl $0
8010734a:	6a 00                	push   $0x0
  pushl $191
8010734c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107351:	e9 12 f2 ff ff       	jmp    80106568 <alltraps>

80107356 <vector192>:
.globl vector192
vector192:
  pushl $0
80107356:	6a 00                	push   $0x0
  pushl $192
80107358:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010735d:	e9 06 f2 ff ff       	jmp    80106568 <alltraps>

80107362 <vector193>:
.globl vector193
vector193:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $193
80107364:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107369:	e9 fa f1 ff ff       	jmp    80106568 <alltraps>

8010736e <vector194>:
.globl vector194
vector194:
  pushl $0
8010736e:	6a 00                	push   $0x0
  pushl $194
80107370:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107375:	e9 ee f1 ff ff       	jmp    80106568 <alltraps>

8010737a <vector195>:
.globl vector195
vector195:
  pushl $0
8010737a:	6a 00                	push   $0x0
  pushl $195
8010737c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107381:	e9 e2 f1 ff ff       	jmp    80106568 <alltraps>

80107386 <vector196>:
.globl vector196
vector196:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $196
80107388:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010738d:	e9 d6 f1 ff ff       	jmp    80106568 <alltraps>

80107392 <vector197>:
.globl vector197
vector197:
  pushl $0
80107392:	6a 00                	push   $0x0
  pushl $197
80107394:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107399:	e9 ca f1 ff ff       	jmp    80106568 <alltraps>

8010739e <vector198>:
.globl vector198
vector198:
  pushl $0
8010739e:	6a 00                	push   $0x0
  pushl $198
801073a0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801073a5:	e9 be f1 ff ff       	jmp    80106568 <alltraps>

801073aa <vector199>:
.globl vector199
vector199:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $199
801073ac:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073b1:	e9 b2 f1 ff ff       	jmp    80106568 <alltraps>

801073b6 <vector200>:
.globl vector200
vector200:
  pushl $0
801073b6:	6a 00                	push   $0x0
  pushl $200
801073b8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073bd:	e9 a6 f1 ff ff       	jmp    80106568 <alltraps>

801073c2 <vector201>:
.globl vector201
vector201:
  pushl $0
801073c2:	6a 00                	push   $0x0
  pushl $201
801073c4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073c9:	e9 9a f1 ff ff       	jmp    80106568 <alltraps>

801073ce <vector202>:
.globl vector202
vector202:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $202
801073d0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073d5:	e9 8e f1 ff ff       	jmp    80106568 <alltraps>

801073da <vector203>:
.globl vector203
vector203:
  pushl $0
801073da:	6a 00                	push   $0x0
  pushl $203
801073dc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073e1:	e9 82 f1 ff ff       	jmp    80106568 <alltraps>

801073e6 <vector204>:
.globl vector204
vector204:
  pushl $0
801073e6:	6a 00                	push   $0x0
  pushl $204
801073e8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073ed:	e9 76 f1 ff ff       	jmp    80106568 <alltraps>

801073f2 <vector205>:
.globl vector205
vector205:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $205
801073f4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073f9:	e9 6a f1 ff ff       	jmp    80106568 <alltraps>

801073fe <vector206>:
.globl vector206
vector206:
  pushl $0
801073fe:	6a 00                	push   $0x0
  pushl $206
80107400:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107405:	e9 5e f1 ff ff       	jmp    80106568 <alltraps>

8010740a <vector207>:
.globl vector207
vector207:
  pushl $0
8010740a:	6a 00                	push   $0x0
  pushl $207
8010740c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107411:	e9 52 f1 ff ff       	jmp    80106568 <alltraps>

80107416 <vector208>:
.globl vector208
vector208:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $208
80107418:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010741d:	e9 46 f1 ff ff       	jmp    80106568 <alltraps>

80107422 <vector209>:
.globl vector209
vector209:
  pushl $0
80107422:	6a 00                	push   $0x0
  pushl $209
80107424:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107429:	e9 3a f1 ff ff       	jmp    80106568 <alltraps>

8010742e <vector210>:
.globl vector210
vector210:
  pushl $0
8010742e:	6a 00                	push   $0x0
  pushl $210
80107430:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107435:	e9 2e f1 ff ff       	jmp    80106568 <alltraps>

8010743a <vector211>:
.globl vector211
vector211:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $211
8010743c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107441:	e9 22 f1 ff ff       	jmp    80106568 <alltraps>

80107446 <vector212>:
.globl vector212
vector212:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $212
80107448:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010744d:	e9 16 f1 ff ff       	jmp    80106568 <alltraps>

80107452 <vector213>:
.globl vector213
vector213:
  pushl $0
80107452:	6a 00                	push   $0x0
  pushl $213
80107454:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107459:	e9 0a f1 ff ff       	jmp    80106568 <alltraps>

8010745e <vector214>:
.globl vector214
vector214:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $214
80107460:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107465:	e9 fe f0 ff ff       	jmp    80106568 <alltraps>

8010746a <vector215>:
.globl vector215
vector215:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $215
8010746c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107471:	e9 f2 f0 ff ff       	jmp    80106568 <alltraps>

80107476 <vector216>:
.globl vector216
vector216:
  pushl $0
80107476:	6a 00                	push   $0x0
  pushl $216
80107478:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010747d:	e9 e6 f0 ff ff       	jmp    80106568 <alltraps>

80107482 <vector217>:
.globl vector217
vector217:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $217
80107484:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107489:	e9 da f0 ff ff       	jmp    80106568 <alltraps>

8010748e <vector218>:
.globl vector218
vector218:
  pushl $0
8010748e:	6a 00                	push   $0x0
  pushl $218
80107490:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107495:	e9 ce f0 ff ff       	jmp    80106568 <alltraps>

8010749a <vector219>:
.globl vector219
vector219:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $219
8010749c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801074a1:	e9 c2 f0 ff ff       	jmp    80106568 <alltraps>

801074a6 <vector220>:
.globl vector220
vector220:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $220
801074a8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074ad:	e9 b6 f0 ff ff       	jmp    80106568 <alltraps>

801074b2 <vector221>:
.globl vector221
vector221:
  pushl $0
801074b2:	6a 00                	push   $0x0
  pushl $221
801074b4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074b9:	e9 aa f0 ff ff       	jmp    80106568 <alltraps>

801074be <vector222>:
.globl vector222
vector222:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $222
801074c0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074c5:	e9 9e f0 ff ff       	jmp    80106568 <alltraps>

801074ca <vector223>:
.globl vector223
vector223:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $223
801074cc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074d1:	e9 92 f0 ff ff       	jmp    80106568 <alltraps>

801074d6 <vector224>:
.globl vector224
vector224:
  pushl $0
801074d6:	6a 00                	push   $0x0
  pushl $224
801074d8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074dd:	e9 86 f0 ff ff       	jmp    80106568 <alltraps>

801074e2 <vector225>:
.globl vector225
vector225:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $225
801074e4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074e9:	e9 7a f0 ff ff       	jmp    80106568 <alltraps>

801074ee <vector226>:
.globl vector226
vector226:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $226
801074f0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074f5:	e9 6e f0 ff ff       	jmp    80106568 <alltraps>

801074fa <vector227>:
.globl vector227
vector227:
  pushl $0
801074fa:	6a 00                	push   $0x0
  pushl $227
801074fc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107501:	e9 62 f0 ff ff       	jmp    80106568 <alltraps>

80107506 <vector228>:
.globl vector228
vector228:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $228
80107508:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010750d:	e9 56 f0 ff ff       	jmp    80106568 <alltraps>

80107512 <vector229>:
.globl vector229
vector229:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $229
80107514:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107519:	e9 4a f0 ff ff       	jmp    80106568 <alltraps>

8010751e <vector230>:
.globl vector230
vector230:
  pushl $0
8010751e:	6a 00                	push   $0x0
  pushl $230
80107520:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107525:	e9 3e f0 ff ff       	jmp    80106568 <alltraps>

8010752a <vector231>:
.globl vector231
vector231:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $231
8010752c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107531:	e9 32 f0 ff ff       	jmp    80106568 <alltraps>

80107536 <vector232>:
.globl vector232
vector232:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $232
80107538:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010753d:	e9 26 f0 ff ff       	jmp    80106568 <alltraps>

80107542 <vector233>:
.globl vector233
vector233:
  pushl $0
80107542:	6a 00                	push   $0x0
  pushl $233
80107544:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107549:	e9 1a f0 ff ff       	jmp    80106568 <alltraps>

8010754e <vector234>:
.globl vector234
vector234:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $234
80107550:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107555:	e9 0e f0 ff ff       	jmp    80106568 <alltraps>

8010755a <vector235>:
.globl vector235
vector235:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $235
8010755c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107561:	e9 02 f0 ff ff       	jmp    80106568 <alltraps>

80107566 <vector236>:
.globl vector236
vector236:
  pushl $0
80107566:	6a 00                	push   $0x0
  pushl $236
80107568:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010756d:	e9 f6 ef ff ff       	jmp    80106568 <alltraps>

80107572 <vector237>:
.globl vector237
vector237:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $237
80107574:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107579:	e9 ea ef ff ff       	jmp    80106568 <alltraps>

8010757e <vector238>:
.globl vector238
vector238:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $238
80107580:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107585:	e9 de ef ff ff       	jmp    80106568 <alltraps>

8010758a <vector239>:
.globl vector239
vector239:
  pushl $0
8010758a:	6a 00                	push   $0x0
  pushl $239
8010758c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107591:	e9 d2 ef ff ff       	jmp    80106568 <alltraps>

80107596 <vector240>:
.globl vector240
vector240:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $240
80107598:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010759d:	e9 c6 ef ff ff       	jmp    80106568 <alltraps>

801075a2 <vector241>:
.globl vector241
vector241:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $241
801075a4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075a9:	e9 ba ef ff ff       	jmp    80106568 <alltraps>

801075ae <vector242>:
.globl vector242
vector242:
  pushl $0
801075ae:	6a 00                	push   $0x0
  pushl $242
801075b0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075b5:	e9 ae ef ff ff       	jmp    80106568 <alltraps>

801075ba <vector243>:
.globl vector243
vector243:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $243
801075bc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075c1:	e9 a2 ef ff ff       	jmp    80106568 <alltraps>

801075c6 <vector244>:
.globl vector244
vector244:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $244
801075c8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075cd:	e9 96 ef ff ff       	jmp    80106568 <alltraps>

801075d2 <vector245>:
.globl vector245
vector245:
  pushl $0
801075d2:	6a 00                	push   $0x0
  pushl $245
801075d4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075d9:	e9 8a ef ff ff       	jmp    80106568 <alltraps>

801075de <vector246>:
.globl vector246
vector246:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $246
801075e0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075e5:	e9 7e ef ff ff       	jmp    80106568 <alltraps>

801075ea <vector247>:
.globl vector247
vector247:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $247
801075ec:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075f1:	e9 72 ef ff ff       	jmp    80106568 <alltraps>

801075f6 <vector248>:
.globl vector248
vector248:
  pushl $0
801075f6:	6a 00                	push   $0x0
  pushl $248
801075f8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075fd:	e9 66 ef ff ff       	jmp    80106568 <alltraps>

80107602 <vector249>:
.globl vector249
vector249:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $249
80107604:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107609:	e9 5a ef ff ff       	jmp    80106568 <alltraps>

8010760e <vector250>:
.globl vector250
vector250:
  pushl $0
8010760e:	6a 00                	push   $0x0
  pushl $250
80107610:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107615:	e9 4e ef ff ff       	jmp    80106568 <alltraps>

8010761a <vector251>:
.globl vector251
vector251:
  pushl $0
8010761a:	6a 00                	push   $0x0
  pushl $251
8010761c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107621:	e9 42 ef ff ff       	jmp    80106568 <alltraps>

80107626 <vector252>:
.globl vector252
vector252:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $252
80107628:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010762d:	e9 36 ef ff ff       	jmp    80106568 <alltraps>

80107632 <vector253>:
.globl vector253
vector253:
  pushl $0
80107632:	6a 00                	push   $0x0
  pushl $253
80107634:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107639:	e9 2a ef ff ff       	jmp    80106568 <alltraps>

8010763e <vector254>:
.globl vector254
vector254:
  pushl $0
8010763e:	6a 00                	push   $0x0
  pushl $254
80107640:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107645:	e9 1e ef ff ff       	jmp    80106568 <alltraps>

8010764a <vector255>:
.globl vector255
vector255:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $255
8010764c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107651:	e9 12 ef ff ff       	jmp    80106568 <alltraps>
	...

80107658 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107658:	55                   	push   %ebp
80107659:	89 e5                	mov    %esp,%ebp
8010765b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010765e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107661:	83 e8 01             	sub    $0x1,%eax
80107664:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107668:	8b 45 08             	mov    0x8(%ebp),%eax
8010766b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010766f:	8b 45 08             	mov    0x8(%ebp),%eax
80107672:	c1 e8 10             	shr    $0x10,%eax
80107675:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107679:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010767c:	0f 01 10             	lgdtl  (%eax)
}
8010767f:	c9                   	leave  
80107680:	c3                   	ret    

80107681 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107681:	55                   	push   %ebp
80107682:	89 e5                	mov    %esp,%ebp
80107684:	83 ec 04             	sub    $0x4,%esp
80107687:	8b 45 08             	mov    0x8(%ebp),%eax
8010768a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010768e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107692:	0f 00 d8             	ltr    %ax
}
80107695:	c9                   	leave  
80107696:	c3                   	ret    

80107697 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107697:	55                   	push   %ebp
80107698:	89 e5                	mov    %esp,%ebp
8010769a:	83 ec 04             	sub    $0x4,%esp
8010769d:	8b 45 08             	mov    0x8(%ebp),%eax
801076a0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801076a4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801076a8:	8e e8                	mov    %eax,%gs
}
801076aa:	c9                   	leave  
801076ab:	c3                   	ret    

801076ac <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801076ac:	55                   	push   %ebp
801076ad:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076af:	8b 45 08             	mov    0x8(%ebp),%eax
801076b2:	0f 22 d8             	mov    %eax,%cr3
}
801076b5:	5d                   	pop    %ebp
801076b6:	c3                   	ret    

801076b7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801076b7:	55                   	push   %ebp
801076b8:	89 e5                	mov    %esp,%ebp
801076ba:	8b 45 08             	mov    0x8(%ebp),%eax
801076bd:	2d 00 00 00 80       	sub    $0x80000000,%eax
801076c2:	5d                   	pop    %ebp
801076c3:	c3                   	ret    

801076c4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
801076c7:	8b 45 08             	mov    0x8(%ebp),%eax
801076ca:	2d 00 00 00 80       	sub    $0x80000000,%eax
801076cf:	5d                   	pop    %ebp
801076d0:	c3                   	ret    

801076d1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801076d1:	55                   	push   %ebp
801076d2:	89 e5                	mov    %esp,%ebp
801076d4:	53                   	push   %ebx
801076d5:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801076d8:	e8 88 b8 ff ff       	call   80102f65 <cpunum>
801076dd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801076e3:	05 60 23 11 80       	add    $0x80112360,%eax
801076e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801076f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f7:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801076fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107700:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107707:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010770b:	83 e2 f0             	and    $0xfffffff0,%edx
8010770e:	83 ca 0a             	or     $0xa,%edx
80107711:	88 50 7d             	mov    %dl,0x7d(%eax)
80107714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107717:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010771b:	83 ca 10             	or     $0x10,%edx
8010771e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107724:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107728:	83 e2 9f             	and    $0xffffff9f,%edx
8010772b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010772e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107731:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107735:	83 ca 80             	or     $0xffffff80,%edx
80107738:	88 50 7d             	mov    %dl,0x7d(%eax)
8010773b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107742:	83 ca 0f             	or     $0xf,%edx
80107745:	88 50 7e             	mov    %dl,0x7e(%eax)
80107748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010774f:	83 e2 ef             	and    $0xffffffef,%edx
80107752:	88 50 7e             	mov    %dl,0x7e(%eax)
80107755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107758:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010775c:	83 e2 df             	and    $0xffffffdf,%edx
8010775f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107769:	83 ca 40             	or     $0x40,%edx
8010776c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010776f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107772:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107776:	83 ca 80             	or     $0xffffff80,%edx
80107779:	88 50 7e             	mov    %dl,0x7e(%eax)
8010777c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107786:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010778d:	ff ff 
8010778f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107792:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107799:	00 00 
8010779b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077af:	83 e2 f0             	and    $0xfffffff0,%edx
801077b2:	83 ca 02             	or     $0x2,%edx
801077b5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077be:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077c5:	83 ca 10             	or     $0x10,%edx
801077c8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077d8:	83 e2 9f             	and    $0xffffff9f,%edx
801077db:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077eb:	83 ca 80             	or     $0xffffff80,%edx
801077ee:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077fe:	83 ca 0f             	or     $0xf,%edx
80107801:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107811:	83 e2 ef             	and    $0xffffffef,%edx
80107814:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107824:	83 e2 df             	and    $0xffffffdf,%edx
80107827:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107837:	83 ca 40             	or     $0x40,%edx
8010783a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107843:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010784a:	83 ca 80             	or     $0xffffff80,%edx
8010784d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107856:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010785d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107860:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107867:	ff ff 
80107869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107873:	00 00 
80107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107878:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010787f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107882:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107889:	83 e2 f0             	and    $0xfffffff0,%edx
8010788c:	83 ca 0a             	or     $0xa,%edx
8010788f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107898:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010789f:	83 ca 10             	or     $0x10,%edx
801078a2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ab:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078b2:	83 ca 60             	or     $0x60,%edx
801078b5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078be:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078c5:	83 ca 80             	or     $0xffffff80,%edx
801078c8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078d8:	83 ca 0f             	or     $0xf,%edx
801078db:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078eb:	83 e2 ef             	and    $0xffffffef,%edx
801078ee:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078fe:	83 e2 df             	and    $0xffffffdf,%edx
80107901:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107911:	83 ca 40             	or     $0x40,%edx
80107914:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010791a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107924:	83 ca 80             	or     $0xffffff80,%edx
80107927:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010792d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107930:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107941:	ff ff 
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010794d:	00 00 
8010794f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107952:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107963:	83 e2 f0             	and    $0xfffffff0,%edx
80107966:	83 ca 02             	or     $0x2,%edx
80107969:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010796f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107972:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107979:	83 ca 10             	or     $0x10,%edx
8010797c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107985:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010798c:	83 ca 60             	or     $0x60,%edx
8010798f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107998:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010799f:	83 ca 80             	or     $0xffffff80,%edx
801079a2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801079a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ab:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079b2:	83 ca 0f             	or     $0xf,%edx
801079b5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079be:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079c5:	83 e2 ef             	and    $0xffffffef,%edx
801079c8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079d8:	83 e2 df             	and    $0xffffffdf,%edx
801079db:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079eb:	83 ca 40             	or     $0x40,%edx
801079ee:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079fe:	83 ca 80             	or     $0xffffff80,%edx
80107a01:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a14:	05 b4 00 00 00       	add    $0xb4,%eax
80107a19:	89 c3                	mov    %eax,%ebx
80107a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1e:	05 b4 00 00 00       	add    $0xb4,%eax
80107a23:	c1 e8 10             	shr    $0x10,%eax
80107a26:	89 c1                	mov    %eax,%ecx
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	05 b4 00 00 00       	add    $0xb4,%eax
80107a30:	c1 e8 18             	shr    $0x18,%eax
80107a33:	89 c2                	mov    %eax,%edx
80107a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a38:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107a3f:	00 00 
80107a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a44:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4e:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a57:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a5e:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a61:	83 c9 02             	or     $0x2,%ecx
80107a64:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a74:	83 c9 10             	or     $0x10,%ecx
80107a77:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a87:	83 e1 9f             	and    $0xffffff9f,%ecx
80107a8a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a93:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107a9a:	83 c9 80             	or     $0xffffff80,%ecx
80107a9d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa6:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107aad:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ab0:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab9:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ac0:	83 e1 ef             	and    $0xffffffef,%ecx
80107ac3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acc:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ad3:	83 e1 df             	and    $0xffffffdf,%ecx
80107ad6:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ae6:	83 c9 40             	or     $0x40,%ecx
80107ae9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107af9:	83 c9 80             	or     $0xffffff80,%ecx
80107afc:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b05:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0e:	83 c0 70             	add    $0x70,%eax
80107b11:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107b18:	00 
80107b19:	89 04 24             	mov    %eax,(%esp)
80107b1c:	e8 37 fb ff ff       	call   80107658 <lgdt>
  loadgs(SEG_KCPU << 3);
80107b21:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107b28:	e8 6a fb ff ff       	call   80107697 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b30:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107b36:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107b3d:	00 00 00 00 
}
80107b41:	83 c4 24             	add    $0x24,%esp
80107b44:	5b                   	pop    %ebx
80107b45:	5d                   	pop    %ebp
80107b46:	c3                   	ret    

80107b47 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b47:	55                   	push   %ebp
80107b48:	89 e5                	mov    %esp,%ebp
80107b4a:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b50:	c1 e8 16             	shr    $0x16,%eax
80107b53:	c1 e0 02             	shl    $0x2,%eax
80107b56:	03 45 08             	add    0x8(%ebp),%eax
80107b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b5f:	8b 00                	mov    (%eax),%eax
80107b61:	83 e0 01             	and    $0x1,%eax
80107b64:	84 c0                	test   %al,%al
80107b66:	74 17                	je     80107b7f <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b6b:	8b 00                	mov    (%eax),%eax
80107b6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b72:	89 04 24             	mov    %eax,(%esp)
80107b75:	e8 4a fb ff ff       	call   801076c4 <p2v>
80107b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b7d:	eb 4b                	jmp    80107bca <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b83:	74 0e                	je     80107b93 <walkpgdir+0x4c>
80107b85:	e8 44 b0 ff ff       	call   80102bce <kalloc>
80107b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b91:	75 07                	jne    80107b9a <walkpgdir+0x53>
      return 0;
80107b93:	b8 00 00 00 00       	mov    $0x0,%eax
80107b98:	eb 41                	jmp    80107bdb <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b9a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ba1:	00 
80107ba2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ba9:	00 
80107baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bad:	89 04 24             	mov    %eax,(%esp)
80107bb0:	e8 99 d5 ff ff       	call   8010514e <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb8:	89 04 24             	mov    %eax,(%esp)
80107bbb:	e8 f7 fa ff ff       	call   801076b7 <v2p>
80107bc0:	89 c2                	mov    %eax,%edx
80107bc2:	83 ca 07             	or     $0x7,%edx
80107bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bc8:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bcd:	c1 e8 0c             	shr    $0xc,%eax
80107bd0:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bd5:	c1 e0 02             	shl    $0x2,%eax
80107bd8:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107bdb:	c9                   	leave  
80107bdc:	c3                   	ret    

80107bdd <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bdd:	55                   	push   %ebp
80107bde:	89 e5                	mov    %esp,%ebp
80107be0:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107be3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bf1:	03 45 10             	add    0x10(%ebp),%eax
80107bf4:	83 e8 01             	sub    $0x1,%eax
80107bf7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107c06:	00 
80107c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80107c11:	89 04 24             	mov    %eax,(%esp)
80107c14:	e8 2e ff ff ff       	call   80107b47 <walkpgdir>
80107c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c20:	75 07                	jne    80107c29 <mappages+0x4c>
      return -1;
80107c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c27:	eb 46                	jmp    80107c6f <mappages+0x92>
    if(*pte & PTE_P)
80107c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2c:	8b 00                	mov    (%eax),%eax
80107c2e:	83 e0 01             	and    $0x1,%eax
80107c31:	84 c0                	test   %al,%al
80107c33:	74 0c                	je     80107c41 <mappages+0x64>
      panic("remap");
80107c35:	c7 04 24 dc 8a 10 80 	movl   $0x80108adc,(%esp)
80107c3c:	e8 fc 88 ff ff       	call   8010053d <panic>
    *pte = pa | perm | PTE_P;
80107c41:	8b 45 18             	mov    0x18(%ebp),%eax
80107c44:	0b 45 14             	or     0x14(%ebp),%eax
80107c47:	89 c2                	mov    %eax,%edx
80107c49:	83 ca 01             	or     $0x1,%edx
80107c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4f:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c57:	74 10                	je     80107c69 <mappages+0x8c>
      break;
    a += PGSIZE;
80107c59:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
    pa += PGSIZE;
80107c60:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c67:	eb 96                	jmp    80107bff <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107c69:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c6f:	c9                   	leave  
80107c70:	c3                   	ret    

80107c71 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c71:	55                   	push   %ebp
80107c72:	89 e5                	mov    %esp,%ebp
80107c74:	53                   	push   %ebx
80107c75:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c78:	e8 51 af ff ff       	call   80102bce <kalloc>
80107c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c84:	75 0a                	jne    80107c90 <setupkvm+0x1f>
    return 0;
80107c86:	b8 00 00 00 00       	mov    $0x0,%eax
80107c8b:	e9 99 00 00 00       	jmp    80107d29 <setupkvm+0xb8>
  memset(pgdir, 0, PGSIZE);
80107c90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c97:	00 
80107c98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c9f:	00 
80107ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca3:	89 04 24             	mov    %eax,(%esp)
80107ca6:	e8 a3 d4 ff ff       	call   8010514e <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107cab:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107cb2:	e8 0d fa ff ff       	call   801076c4 <p2v>
80107cb7:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107cbc:	76 0c                	jbe    80107cca <setupkvm+0x59>
    panic("PHYSTOP too high");
80107cbe:	c7 04 24 e2 8a 10 80 	movl   $0x80108ae2,(%esp)
80107cc5:	e8 73 88 ff ff       	call   8010053d <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cca:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107cd1:	eb 49                	jmp    80107d1c <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd6:	8b 48 0c             	mov    0xc(%eax),%ecx
80107cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdc:	8b 50 04             	mov    0x4(%eax),%edx
80107cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce2:	8b 58 08             	mov    0x8(%eax),%ebx
80107ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce8:	8b 40 04             	mov    0x4(%eax),%eax
80107ceb:	29 c3                	sub    %eax,%ebx
80107ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf0:	8b 00                	mov    (%eax),%eax
80107cf2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107cf6:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107cfa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d05:	89 04 24             	mov    %eax,(%esp)
80107d08:	e8 d0 fe ff ff       	call   80107bdd <mappages>
80107d0d:	85 c0                	test   %eax,%eax
80107d0f:	79 07                	jns    80107d18 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107d11:	b8 00 00 00 00       	mov    $0x0,%eax
80107d16:	eb 11                	jmp    80107d29 <setupkvm+0xb8>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d18:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d1c:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
80107d21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80107d24:	72 ad                	jb     80107cd3 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d29:	83 c4 34             	add    $0x34,%esp
80107d2c:	5b                   	pop    %ebx
80107d2d:	5d                   	pop    %ebp
80107d2e:	c3                   	ret    

80107d2f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d2f:	55                   	push   %ebp
80107d30:	89 e5                	mov    %esp,%ebp
80107d32:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d35:	e8 37 ff ff ff       	call   80107c71 <setupkvm>
80107d3a:	a3 38 51 11 80       	mov    %eax,0x80115138
  switchkvm();
80107d3f:	e8 02 00 00 00       	call   80107d46 <switchkvm>
}
80107d44:	c9                   	leave  
80107d45:	c3                   	ret    

80107d46 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d46:	55                   	push   %ebp
80107d47:	89 e5                	mov    %esp,%ebp
80107d49:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107d4c:	a1 38 51 11 80       	mov    0x80115138,%eax
80107d51:	89 04 24             	mov    %eax,(%esp)
80107d54:	e8 5e f9 ff ff       	call   801076b7 <v2p>
80107d59:	89 04 24             	mov    %eax,(%esp)
80107d5c:	e8 4b f9 ff ff       	call   801076ac <lcr3>
}
80107d61:	c9                   	leave  
80107d62:	c3                   	ret    

80107d63 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d63:	55                   	push   %ebp
80107d64:	89 e5                	mov    %esp,%ebp
80107d66:	53                   	push   %ebx
80107d67:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107d6a:	e8 da d2 ff ff       	call   80105049 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d75:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d7c:	83 c2 08             	add    $0x8,%edx
80107d7f:	89 d3                	mov    %edx,%ebx
80107d81:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d88:	83 c2 08             	add    $0x8,%edx
80107d8b:	c1 ea 10             	shr    $0x10,%edx
80107d8e:	89 d1                	mov    %edx,%ecx
80107d90:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d97:	83 c2 08             	add    $0x8,%edx
80107d9a:	c1 ea 18             	shr    $0x18,%edx
80107d9d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107da4:	67 00 
80107da6:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107dad:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107db3:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107dba:	83 e1 f0             	and    $0xfffffff0,%ecx
80107dbd:	83 c9 09             	or     $0x9,%ecx
80107dc0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107dc6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107dcd:	83 c9 10             	or     $0x10,%ecx
80107dd0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107dd6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ddd:	83 e1 9f             	and    $0xffffff9f,%ecx
80107de0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107de6:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ded:	83 c9 80             	or     $0xffffff80,%ecx
80107df0:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107df6:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107dfd:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e00:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e06:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107e0d:	83 e1 ef             	and    $0xffffffef,%ecx
80107e10:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e16:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107e1d:	83 e1 df             	and    $0xffffffdf,%ecx
80107e20:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e26:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107e2d:	83 c9 40             	or     $0x40,%ecx
80107e30:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e36:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107e3d:	83 e1 7f             	and    $0x7f,%ecx
80107e40:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107e46:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107e4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e52:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e59:	83 e2 ef             	and    $0xffffffef,%edx
80107e5c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e62:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e68:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e6e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e74:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e7b:	8b 52 08             	mov    0x8(%edx),%edx
80107e7e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e84:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e87:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107e8e:	e8 ee f7 ff ff       	call   80107681 <ltr>
  if(p->pgdir == 0)
80107e93:	8b 45 08             	mov    0x8(%ebp),%eax
80107e96:	8b 40 04             	mov    0x4(%eax),%eax
80107e99:	85 c0                	test   %eax,%eax
80107e9b:	75 0c                	jne    80107ea9 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107e9d:	c7 04 24 f3 8a 10 80 	movl   $0x80108af3,(%esp)
80107ea4:	e8 94 86 ff ff       	call   8010053d <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80107eac:	8b 40 04             	mov    0x4(%eax),%eax
80107eaf:	89 04 24             	mov    %eax,(%esp)
80107eb2:	e8 00 f8 ff ff       	call   801076b7 <v2p>
80107eb7:	89 04 24             	mov    %eax,(%esp)
80107eba:	e8 ed f7 ff ff       	call   801076ac <lcr3>
  popcli();
80107ebf:	e8 cd d1 ff ff       	call   80105091 <popcli>
}
80107ec4:	83 c4 14             	add    $0x14,%esp
80107ec7:	5b                   	pop    %ebx
80107ec8:	5d                   	pop    %ebp
80107ec9:	c3                   	ret    

80107eca <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107eca:	55                   	push   %ebp
80107ecb:	89 e5                	mov    %esp,%ebp
80107ecd:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107ed0:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ed7:	76 0c                	jbe    80107ee5 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107ed9:	c7 04 24 07 8b 10 80 	movl   $0x80108b07,(%esp)
80107ee0:	e8 58 86 ff ff       	call   8010053d <panic>
  mem = kalloc();
80107ee5:	e8 e4 ac ff ff       	call   80102bce <kalloc>
80107eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107eed:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ef4:	00 
80107ef5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107efc:	00 
80107efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f00:	89 04 24             	mov    %eax,(%esp)
80107f03:	e8 46 d2 ff ff       	call   8010514e <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0b:	89 04 24             	mov    %eax,(%esp)
80107f0e:	e8 a4 f7 ff ff       	call   801076b7 <v2p>
80107f13:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107f1a:	00 
80107f1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107f1f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f26:	00 
80107f27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f2e:	00 
80107f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107f32:	89 04 24             	mov    %eax,(%esp)
80107f35:	e8 a3 fc ff ff       	call   80107bdd <mappages>
  memmove(mem, init, sz);
80107f3a:	8b 45 10             	mov    0x10(%ebp),%eax
80107f3d:	89 44 24 08          	mov    %eax,0x8(%esp)
80107f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f44:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4b:	89 04 24             	mov    %eax,(%esp)
80107f4e:	e8 ce d2 ff ff       	call   80105221 <memmove>
}
80107f53:	c9                   	leave  
80107f54:	c3                   	ret    

80107f55 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f55:	55                   	push   %ebp
80107f56:	89 e5                	mov    %esp,%ebp
80107f58:	53                   	push   %ebx
80107f59:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f5f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f64:	85 c0                	test   %eax,%eax
80107f66:	74 0c                	je     80107f74 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107f68:	c7 04 24 24 8b 10 80 	movl   $0x80108b24,(%esp)
80107f6f:	e8 c9 85 ff ff       	call   8010053d <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80107f7b:	e9 ae 00 00 00       	jmp    8010802e <loaduvm+0xd9>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f83:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f86:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107f89:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f90:	00 
80107f91:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f95:	8b 45 08             	mov    0x8(%ebp),%eax
80107f98:	89 04 24             	mov    %eax,(%esp)
80107f9b:	e8 a7 fb ff ff       	call   80107b47 <walkpgdir>
80107fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107fa7:	75 0c                	jne    80107fb5 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107fa9:	c7 04 24 47 8b 10 80 	movl   $0x80108b47,(%esp)
80107fb0:	e8 88 85 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
80107fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb8:	8b 00                	mov    (%eax),%eax
80107fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(sz - i < PGSIZE)
80107fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fc5:	8b 55 18             	mov    0x18(%ebp),%edx
80107fc8:	89 d1                	mov    %edx,%ecx
80107fca:	29 c1                	sub    %eax,%ecx
80107fcc:	89 c8                	mov    %ecx,%eax
80107fce:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fd3:	77 11                	ja     80107fe6 <loaduvm+0x91>
      n = sz - i;
80107fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fd8:	8b 55 18             	mov    0x18(%ebp),%edx
80107fdb:	89 d1                	mov    %edx,%ecx
80107fdd:	29 c1                	sub    %eax,%ecx
80107fdf:	89 c8                	mov    %ecx,%eax
80107fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fe4:	eb 07                	jmp    80107fed <loaduvm+0x98>
    else
      n = PGSIZE;
80107fe6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ff0:	8b 55 14             	mov    0x14(%ebp),%edx
80107ff3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107ff6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ff9:	89 04 24             	mov    %eax,(%esp)
80107ffc:	e8 c3 f6 ff ff       	call   801076c4 <p2v>
80108001:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108004:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108008:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010800c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108010:	8b 45 10             	mov    0x10(%ebp),%eax
80108013:	89 04 24             	mov    %eax,(%esp)
80108016:	e8 e5 9d ff ff       	call   80101e00 <readi>
8010801b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010801e:	74 07                	je     80108027 <loaduvm+0xd2>
      return -1;
80108020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108025:	eb 18                	jmp    8010803f <loaduvm+0xea>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108027:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)
8010802e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108031:	3b 45 18             	cmp    0x18(%ebp),%eax
80108034:	0f 82 46 ff ff ff    	jb     80107f80 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010803a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010803f:	83 c4 24             	add    $0x24,%esp
80108042:	5b                   	pop    %ebx
80108043:	5d                   	pop    %ebp
80108044:	c3                   	ret    

80108045 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108045:	55                   	push   %ebp
80108046:	89 e5                	mov    %esp,%ebp
80108048:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010804b:	8b 45 10             	mov    0x10(%ebp),%eax
8010804e:	85 c0                	test   %eax,%eax
80108050:	79 0a                	jns    8010805c <allocuvm+0x17>
    return 0;
80108052:	b8 00 00 00 00       	mov    $0x0,%eax
80108057:	e9 c1 00 00 00       	jmp    8010811d <allocuvm+0xd8>
  if(newsz < oldsz)
8010805c:	8b 45 10             	mov    0x10(%ebp),%eax
8010805f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108062:	73 08                	jae    8010806c <allocuvm+0x27>
    return oldsz;
80108064:	8b 45 0c             	mov    0xc(%ebp),%eax
80108067:	e9 b1 00 00 00       	jmp    8010811d <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010806c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010806f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010807c:	e9 8d 00 00 00       	jmp    8010810e <allocuvm+0xc9>
    mem = kalloc();
80108081:	e8 48 ab ff ff       	call   80102bce <kalloc>
80108086:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108089:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010808d:	75 2c                	jne    801080bb <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
8010808f:	c7 04 24 65 8b 10 80 	movl   $0x80108b65,(%esp)
80108096:	e8 02 83 ff ff       	call   8010039d <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010809b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010809e:	89 44 24 08          	mov    %eax,0x8(%esp)
801080a2:	8b 45 10             	mov    0x10(%ebp),%eax
801080a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080a9:	8b 45 08             	mov    0x8(%ebp),%eax
801080ac:	89 04 24             	mov    %eax,(%esp)
801080af:	e8 6b 00 00 00       	call   8010811f <deallocuvm>
      return 0;
801080b4:	b8 00 00 00 00       	mov    $0x0,%eax
801080b9:	eb 62                	jmp    8010811d <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
801080bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080c2:	00 
801080c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080ca:	00 
801080cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ce:	89 04 24             	mov    %eax,(%esp)
801080d1:	e8 78 d0 ff ff       	call   8010514e <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801080d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d9:	89 04 24             	mov    %eax,(%esp)
801080dc:	e8 d6 f5 ff ff       	call   801076b7 <v2p>
801080e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080e4:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080eb:	00 
801080ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
801080f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080f7:	00 
801080f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801080fc:	8b 45 08             	mov    0x8(%ebp),%eax
801080ff:	89 04 24             	mov    %eax,(%esp)
80108102:	e8 d6 fa ff ff       	call   80107bdd <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108107:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010810e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108111:	3b 45 10             	cmp    0x10(%ebp),%eax
80108114:	0f 82 67 ff ff ff    	jb     80108081 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
8010811a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010811d:	c9                   	leave  
8010811e:	c3                   	ret    

8010811f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010811f:	55                   	push   %ebp
80108120:	89 e5                	mov    %esp,%ebp
80108122:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108125:	8b 45 10             	mov    0x10(%ebp),%eax
80108128:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010812b:	72 08                	jb     80108135 <deallocuvm+0x16>
    return oldsz;
8010812d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108130:	e9 a4 00 00 00       	jmp    801081d9 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80108135:	8b 45 10             	mov    0x10(%ebp),%eax
80108138:	05 ff 0f 00 00       	add    $0xfff,%eax
8010813d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108142:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108145:	e9 80 00 00 00       	jmp    801081ca <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010814a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010814d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108154:	00 
80108155:	89 44 24 04          	mov    %eax,0x4(%esp)
80108159:	8b 45 08             	mov    0x8(%ebp),%eax
8010815c:	89 04 24             	mov    %eax,(%esp)
8010815f:	e8 e3 f9 ff ff       	call   80107b47 <walkpgdir>
80108164:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(!pte)
80108167:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010816b:	75 09                	jne    80108176 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
8010816d:	81 45 ec 00 f0 3f 00 	addl   $0x3ff000,-0x14(%ebp)
80108174:	eb 4d                	jmp    801081c3 <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108176:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108179:	8b 00                	mov    (%eax),%eax
8010817b:	83 e0 01             	and    $0x1,%eax
8010817e:	84 c0                	test   %al,%al
80108180:	74 41                	je     801081c3 <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108182:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108185:	8b 00                	mov    (%eax),%eax
80108187:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010818c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
8010818f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108193:	75 0c                	jne    801081a1 <deallocuvm+0x82>
        panic("kfree");
80108195:	c7 04 24 7d 8b 10 80 	movl   $0x80108b7d,(%esp)
8010819c:	e8 9c 83 ff ff       	call   8010053d <panic>
      char *v = p2v(pa);
801081a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a4:	89 04 24             	mov    %eax,(%esp)
801081a7:	e8 18 f5 ff ff       	call   801076c4 <p2v>
801081ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
801081af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b2:	89 04 24             	mov    %eax,(%esp)
801081b5:	e8 7b a9 ff ff       	call   80102b35 <kfree>
      *pte = 0;
801081ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801081c3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801081ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081d0:	0f 82 74 ff ff ff    	jb     8010814a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801081d6:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081d9:	c9                   	leave  
801081da:	c3                   	ret    

801081db <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801081db:	55                   	push   %ebp
801081dc:	89 e5                	mov    %esp,%ebp
801081de:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801081e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801081e5:	75 0c                	jne    801081f3 <freevm+0x18>
    panic("freevm: no pgdir");
801081e7:	c7 04 24 83 8b 10 80 	movl   $0x80108b83,(%esp)
801081ee:	e8 4a 83 ff ff       	call   8010053d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081fa:	00 
801081fb:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108202:	80 
80108203:	8b 45 08             	mov    0x8(%ebp),%eax
80108206:	89 04 24             	mov    %eax,(%esp)
80108209:	e8 11 ff ff ff       	call   8010811f <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010820e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108215:	eb 3c                	jmp    80108253 <freevm+0x78>
    if(pgdir[i] & PTE_P){
80108217:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010821a:	c1 e0 02             	shl    $0x2,%eax
8010821d:	03 45 08             	add    0x8(%ebp),%eax
80108220:	8b 00                	mov    (%eax),%eax
80108222:	83 e0 01             	and    $0x1,%eax
80108225:	84 c0                	test   %al,%al
80108227:	74 26                	je     8010824f <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108229:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010822c:	c1 e0 02             	shl    $0x2,%eax
8010822f:	03 45 08             	add    0x8(%ebp),%eax
80108232:	8b 00                	mov    (%eax),%eax
80108234:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108239:	89 04 24             	mov    %eax,(%esp)
8010823c:	e8 83 f4 ff ff       	call   801076c4 <p2v>
80108241:	89 45 f4             	mov    %eax,-0xc(%ebp)
      kfree(v);
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	89 04 24             	mov    %eax,(%esp)
8010824a:	e8 e6 a8 ff ff       	call   80102b35 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010824f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108253:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
8010825a:	76 bb                	jbe    80108217 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010825c:	8b 45 08             	mov    0x8(%ebp),%eax
8010825f:	89 04 24             	mov    %eax,(%esp)
80108262:	e8 ce a8 ff ff       	call   80102b35 <kfree>
}
80108267:	c9                   	leave  
80108268:	c3                   	ret    

80108269 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108269:	55                   	push   %ebp
8010826a:	89 e5                	mov    %esp,%ebp
8010826c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010826f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108276:	00 
80108277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010827a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010827e:	8b 45 08             	mov    0x8(%ebp),%eax
80108281:	89 04 24             	mov    %eax,(%esp)
80108284:	e8 be f8 ff ff       	call   80107b47 <walkpgdir>
80108289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010828c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108290:	75 0c                	jne    8010829e <clearpteu+0x35>
    panic("clearpteu");
80108292:	c7 04 24 94 8b 10 80 	movl   $0x80108b94,(%esp)
80108299:	e8 9f 82 ff ff       	call   8010053d <panic>
  *pte &= ~PTE_U;
8010829e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a1:	8b 00                	mov    (%eax),%eax
801082a3:	89 c2                	mov    %eax,%edx
801082a5:	83 e2 fb             	and    $0xfffffffb,%edx
801082a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ab:	89 10                	mov    %edx,(%eax)
}
801082ad:	c9                   	leave  
801082ae:	c3                   	ret    

801082af <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801082af:	55                   	push   %ebp
801082b0:	89 e5                	mov    %esp,%ebp
801082b2:	53                   	push   %ebx
801082b3:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801082b6:	e8 b6 f9 ff ff       	call   80107c71 <setupkvm>
801082bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801082c2:	75 0a                	jne    801082ce <copyuvm+0x1f>
    return 0;
801082c4:	b8 00 00 00 00       	mov    $0x0,%eax
801082c9:	e9 fd 00 00 00       	jmp    801083cb <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
801082ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801082d5:	e9 cc 00 00 00       	jmp    801083a6 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801082da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082e4:	00 
801082e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801082e9:	8b 45 08             	mov    0x8(%ebp),%eax
801082ec:	89 04 24             	mov    %eax,(%esp)
801082ef:	e8 53 f8 ff ff       	call   80107b47 <walkpgdir>
801082f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801082f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801082fb:	75 0c                	jne    80108309 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801082fd:	c7 04 24 9e 8b 10 80 	movl   $0x80108b9e,(%esp)
80108304:	e8 34 82 ff ff       	call   8010053d <panic>
    if(!(*pte & PTE_P))
80108309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010830c:	8b 00                	mov    (%eax),%eax
8010830e:	83 e0 01             	and    $0x1,%eax
80108311:	85 c0                	test   %eax,%eax
80108313:	75 0c                	jne    80108321 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108315:	c7 04 24 b8 8b 10 80 	movl   $0x80108bb8,(%esp)
8010831c:	e8 1c 82 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
80108321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108324:	8b 00                	mov    (%eax),%eax
80108326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010832b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010832e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108331:	8b 00                	mov    (%eax),%eax
80108333:	25 ff 0f 00 00       	and    $0xfff,%eax
80108338:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mem = kalloc()) == 0)
8010833b:	e8 8e a8 ff ff       	call   80102bce <kalloc>
80108340:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108347:	74 6e                	je     801083b7 <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108349:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010834c:	89 04 24             	mov    %eax,(%esp)
8010834f:	e8 70 f3 ff ff       	call   801076c4 <p2v>
80108354:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010835b:	00 
8010835c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108363:	89 04 24             	mov    %eax,(%esp)
80108366:	e8 b6 ce ff ff       	call   80105221 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010836b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
8010836e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108371:	89 04 24             	mov    %eax,(%esp)
80108374:	e8 3e f3 ff ff       	call   801076b7 <v2p>
80108379:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010837c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108380:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108384:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010838b:	00 
8010838c:	89 54 24 04          	mov    %edx,0x4(%esp)
80108390:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108393:	89 04 24             	mov    %eax,(%esp)
80108396:	e8 42 f8 ff ff       	call   80107bdd <mappages>
8010839b:	85 c0                	test   %eax,%eax
8010839d:	78 1b                	js     801083ba <copyuvm+0x10b>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010839f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
801083a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083ac:	0f 82 28 ff ff ff    	jb     801082da <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801083b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083b5:	eb 14                	jmp    801083cb <copyuvm+0x11c>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801083b7:	90                   	nop
801083b8:	eb 01                	jmp    801083bb <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801083ba:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801083bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083be:	89 04 24             	mov    %eax,(%esp)
801083c1:	e8 15 fe ff ff       	call   801081db <freevm>
  return 0;
801083c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083cb:	83 c4 44             	add    $0x44,%esp
801083ce:	5b                   	pop    %ebx
801083cf:	5d                   	pop    %ebp
801083d0:	c3                   	ret    

801083d1 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801083d1:	55                   	push   %ebp
801083d2:	89 e5                	mov    %esp,%ebp
801083d4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801083d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801083de:	00 
801083df:	8b 45 0c             	mov    0xc(%ebp),%eax
801083e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801083e6:	8b 45 08             	mov    0x8(%ebp),%eax
801083e9:	89 04 24             	mov    %eax,(%esp)
801083ec:	e8 56 f7 ff ff       	call   80107b47 <walkpgdir>
801083f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f7:	8b 00                	mov    (%eax),%eax
801083f9:	83 e0 01             	and    $0x1,%eax
801083fc:	85 c0                	test   %eax,%eax
801083fe:	75 07                	jne    80108407 <uva2ka+0x36>
    return 0;
80108400:	b8 00 00 00 00       	mov    $0x0,%eax
80108405:	eb 25                	jmp    8010842c <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010840a:	8b 00                	mov    (%eax),%eax
8010840c:	83 e0 04             	and    $0x4,%eax
8010840f:	85 c0                	test   %eax,%eax
80108411:	75 07                	jne    8010841a <uva2ka+0x49>
    return 0;
80108413:	b8 00 00 00 00       	mov    $0x0,%eax
80108418:	eb 12                	jmp    8010842c <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010841a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010841d:	8b 00                	mov    (%eax),%eax
8010841f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108424:	89 04 24             	mov    %eax,(%esp)
80108427:	e8 98 f2 ff ff       	call   801076c4 <p2v>
}
8010842c:	c9                   	leave  
8010842d:	c3                   	ret    

8010842e <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010842e:	55                   	push   %ebp
8010842f:	89 e5                	mov    %esp,%ebp
80108431:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108434:	8b 45 10             	mov    0x10(%ebp),%eax
80108437:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(len > 0){
8010843a:	e9 8b 00 00 00       	jmp    801084ca <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
8010843f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108447:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010844a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108451:	8b 45 08             	mov    0x8(%ebp),%eax
80108454:	89 04 24             	mov    %eax,(%esp)
80108457:	e8 75 ff ff ff       	call   801083d1 <uva2ka>
8010845c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pa0 == 0)
8010845f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108463:	75 07                	jne    8010846c <copyout+0x3e>
      return -1;
80108465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010846a:	eb 6d                	jmp    801084d9 <copyout+0xab>
    n = PGSIZE - (va - va0);
8010846c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108472:	89 d1                	mov    %edx,%ecx
80108474:	29 c1                	sub    %eax,%ecx
80108476:	89 c8                	mov    %ecx,%eax
80108478:	05 00 10 00 00       	add    $0x1000,%eax
8010847d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108480:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108483:	3b 45 14             	cmp    0x14(%ebp),%eax
80108486:	76 06                	jbe    8010848e <copyout+0x60>
      n = len;
80108488:	8b 45 14             	mov    0x14(%ebp),%eax
8010848b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010848e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108491:	8b 55 0c             	mov    0xc(%ebp),%edx
80108494:	89 d1                	mov    %edx,%ecx
80108496:	29 c1                	sub    %eax,%ecx
80108498:	89 c8                	mov    %ecx,%eax
8010849a:	03 45 ec             	add    -0x14(%ebp),%eax
8010849d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801084a0:	89 54 24 08          	mov    %edx,0x8(%esp)
801084a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801084a7:	89 54 24 04          	mov    %edx,0x4(%esp)
801084ab:	89 04 24             	mov    %eax,(%esp)
801084ae:	e8 6e cd ff ff       	call   80105221 <memmove>
    len -= n;
801084b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084b6:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801084b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084bc:	01 45 e8             	add    %eax,-0x18(%ebp)
    va = va0 + PGSIZE;
801084bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c2:	05 00 10 00 00       	add    $0x1000,%eax
801084c7:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801084ca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801084ce:	0f 85 6b ff ff ff    	jne    8010843f <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801084d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084d9:	c9                   	leave  
801084da:	c3                   	ret    
