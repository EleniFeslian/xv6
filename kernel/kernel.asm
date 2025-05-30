
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	8c013103          	ld	sp,-1856(sp) # 800078c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4f7040ef          	jal	ra,80004d0c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0001c797          	auipc	a5,0x1c
    80000034:	02078793          	addi	a5,a5,32 # 8001c050 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	ra,8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8c490913          	addi	s2,s2,-1852 # 80007910 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	6bc050ef          	jal	ra,80005712 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	744050ef          	jal	ra,800057aa <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f9a50513          	addi	a0,a0,-102 # 80007010 <etext+0x10>
    8000007e:	384050ef          	jal	ra,80005402 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	e84a                	sd	s2,16(sp)
    8000008c:	e44e                	sd	s3,8(sp)
    8000008e:	e052                	sd	s4,0(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	00e504b3          	add	s1,a0,a4
    8000009c:	777d                	lui	a4,0xfffff
    8000009e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a0:	94be                	add	s1,s1,a5
    800000a2:	0095ec63          	bltu	a1,s1,800000ba <freerange+0x38>
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	ra,8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
}
    800000ba:	70a2                	ld	ra,40(sp)
    800000bc:	7402                	ld	s0,32(sp)
    800000be:	64e2                	ld	s1,24(sp)
    800000c0:	6942                	ld	s2,16(sp)
    800000c2:	69a2                	ld	s3,8(sp)
    800000c4:	6a02                	ld	s4,0(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f4658593          	addi	a1,a1,-186 # 80007018 <etext+0x18>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	83650513          	addi	a0,a0,-1994 # 80007910 <kmem>
    800000e2:	5b0050ef          	jal	ra,80005692 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	0001c517          	auipc	a0,0x1c
    800000ee:	f6650513          	addi	a0,a0,-154 # 8001c050 <end>
    800000f2:	f91ff0ef          	jal	ra,80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00008497          	auipc	s1,0x8
    8000010c:	80848493          	addi	s1,s1,-2040 # 80007910 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	600050ef          	jal	ra,80005712 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00007517          	auipc	a0,0x7
    80000120:	7f450513          	addi	a0,a0,2036 # 80007910 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	684050ef          	jal	ra,800057aa <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	ra,8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00007517          	auipc	a0,0x7
    80000144:	7d050513          	addi	a0,a0,2000 # 80007910 <kmem>
    80000148:	662050ef          	jal	ra,800057aa <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe2fb1>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	fef59ae3          	bne	a1,a5,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fee79ae3          	bne	a5,a4,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	ra,800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a809                	j	8000024c <strncmp+0x32>
    8000023c:	4501                	li	a0,0
    8000023e:	a039                	j	8000024c <strncmp+0x32>
  if(n == 0)
    80000240:	ca09                	beqz	a2,80000252 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000242:	00054503          	lbu	a0,0(a0)
    80000246:	0005c783          	lbu	a5,0(a1)
    8000024a:	9d1d                	subw	a0,a0,a5
}
    8000024c:	6422                	ld	s0,8(sp)
    8000024e:	0141                	addi	sp,sp,16
    80000250:	8082                	ret
    return 0;
    80000252:	4501                	li	a0,0
    80000254:	bfe5                	j	8000024c <strncmp+0x32>

0000000080000256 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000256:	1141                	addi	sp,sp,-16
    80000258:	e422                	sd	s0,8(sp)
    8000025a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000025c:	872a                	mv	a4,a0
    8000025e:	8832                	mv	a6,a2
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	01005963          	blez	a6,80000274 <strncpy+0x1e>
    80000266:	0705                	addi	a4,a4,1
    80000268:	0005c783          	lbu	a5,0(a1)
    8000026c:	fef70fa3          	sb	a5,-1(a4)
    80000270:	0585                	addi	a1,a1,1
    80000272:	f7f5                	bnez	a5,8000025e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000274:	86ba                	mv	a3,a4
    80000276:	00c05c63          	blez	a2,8000028e <strncpy+0x38>
    *s++ = 0;
    8000027a:	0685                	addi	a3,a3,1
    8000027c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000280:	40d707bb          	subw	a5,a4,a3
    80000284:	37fd                	addiw	a5,a5,-1
    80000286:	010787bb          	addw	a5,a5,a6
    8000028a:	fef048e3          	bgtz	a5,8000027a <strncpy+0x24>
  return os;
}
    8000028e:	6422                	ld	s0,8(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000029a:	02c05363          	blez	a2,800002c0 <safestrcpy+0x2c>
    8000029e:	fff6069b          	addiw	a3,a2,-1
    800002a2:	1682                	slli	a3,a3,0x20
    800002a4:	9281                	srli	a3,a3,0x20
    800002a6:	96ae                	add	a3,a3,a1
    800002a8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002aa:	00d58963          	beq	a1,a3,800002bc <safestrcpy+0x28>
    800002ae:	0585                	addi	a1,a1,1
    800002b0:	0785                	addi	a5,a5,1
    800002b2:	fff5c703          	lbu	a4,-1(a1)
    800002b6:	fee78fa3          	sb	a4,-1(a5)
    800002ba:	fb65                	bnez	a4,800002aa <safestrcpy+0x16>
    ;
  *s = 0;
    800002bc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002c0:	6422                	ld	s0,8(sp)
    800002c2:	0141                	addi	sp,sp,16
    800002c4:	8082                	ret

00000000800002c6 <strlen>:

int
strlen(const char *s)
{
    800002c6:	1141                	addi	sp,sp,-16
    800002c8:	e422                	sd	s0,8(sp)
    800002ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002cc:	00054783          	lbu	a5,0(a0)
    800002d0:	cf91                	beqz	a5,800002ec <strlen+0x26>
    800002d2:	0505                	addi	a0,a0,1
    800002d4:	87aa                	mv	a5,a0
    800002d6:	4685                	li	a3,1
    800002d8:	9e89                	subw	a3,a3,a0
    800002da:	00f6853b          	addw	a0,a3,a5
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff7c703          	lbu	a4,-1(a5)
    800002e4:	fb7d                	bnez	a4,800002da <strlen+0x14>
    ;
  return n;
}
    800002e6:	6422                	ld	s0,8(sp)
    800002e8:	0141                	addi	sp,sp,16
    800002ea:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ec:	4501                	li	a0,0
    800002ee:	bfe5                	j	800002e6 <strlen+0x20>

00000000800002f0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e406                	sd	ra,8(sp)
    800002f4:	e022                	sd	s0,0(sp)
    800002f6:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f8:	1e9000ef          	jal	ra,80000ce0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002fc:	00007717          	auipc	a4,0x7
    80000300:	5e470713          	addi	a4,a4,1508 # 800078e0 <started>
  if(cpuid() == 0){
    80000304:	c51d                	beqz	a0,80000332 <main+0x42>
    while(started == 0)
    80000306:	431c                	lw	a5,0(a4)
    80000308:	2781                	sext.w	a5,a5
    8000030a:	dff5                	beqz	a5,80000306 <main+0x16>
      ;
    __sync_synchronize();
    8000030c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000310:	1d1000ef          	jal	ra,80000ce0 <cpuid>
    80000314:	85aa                	mv	a1,a0
    80000316:	00007517          	auipc	a0,0x7
    8000031a:	d2250513          	addi	a0,a0,-734 # 80007038 <etext+0x38>
    8000031e:	631040ef          	jal	ra,8000514e <printf>
    kvminithart();    // turn on paging
    80000322:	080000ef          	jal	ra,800003a2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000326:	4d6010ef          	jal	ra,800017fc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000032a:	43a040ef          	jal	ra,80004764 <plicinithart>
  }

  scheduler();        
    8000032e:	611000ef          	jal	ra,8000113e <scheduler>
    consoleinit();
    80000332:	547040ef          	jal	ra,80005078 <consoleinit>
    printfinit();
    80000336:	106050ef          	jal	ra,8000543c <printfinit>
    printf("\n");
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	d0e50513          	addi	a0,a0,-754 # 80007048 <etext+0x48>
    80000342:	60d040ef          	jal	ra,8000514e <printf>
    printf("xv6 kernel is booting\n");
    80000346:	00007517          	auipc	a0,0x7
    8000034a:	cda50513          	addi	a0,a0,-806 # 80007020 <etext+0x20>
    8000034e:	601040ef          	jal	ra,8000514e <printf>
    printf("\n");
    80000352:	00007517          	auipc	a0,0x7
    80000356:	cf650513          	addi	a0,a0,-778 # 80007048 <etext+0x48>
    8000035a:	5f5040ef          	jal	ra,8000514e <printf>
    kinit();         // physical page allocator
    8000035e:	d6dff0ef          	jal	ra,800000ca <kinit>
    kvminit();       // create kernel page table
    80000362:	2ca000ef          	jal	ra,8000062c <kvminit>
    kvminithart();   // turn on paging
    80000366:	03c000ef          	jal	ra,800003a2 <kvminithart>
    procinit();      // process table
    8000036a:	0cf000ef          	jal	ra,80000c38 <procinit>
    trapinit();      // trap vectors
    8000036e:	46a010ef          	jal	ra,800017d8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000372:	48a010ef          	jal	ra,800017fc <trapinithart>
    plicinit();      // set up interrupt controller
    80000376:	3d8040ef          	jal	ra,8000474e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000037a:	3ea040ef          	jal	ra,80004764 <plicinithart>
    binit();         // buffer cache
    8000037e:	2a9010ef          	jal	ra,80001e26 <binit>
    iinit();         // inode table
    80000382:	104020ef          	jal	ra,80002486 <iinit>
    fileinit();      // file table
    80000386:	6a9020ef          	jal	ra,8000322e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000038a:	4ca040ef          	jal	ra,80004854 <virtio_disk_init>
    userinit();      // first user process
    8000038e:	3e7000ef          	jal	ra,80000f74 <userinit>
    __sync_synchronize();
    80000392:	0ff0000f          	fence
    started = 1;
    80000396:	4785                	li	a5,1
    80000398:	00007717          	auipc	a4,0x7
    8000039c:	54f72423          	sw	a5,1352(a4) # 800078e0 <started>
    800003a0:	b779                	j	8000032e <main+0x3e>

00000000800003a2 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003a2:	1141                	addi	sp,sp,-16
    800003a4:	e422                	sd	s0,8(sp)
    800003a6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003ac:	00007797          	auipc	a5,0x7
    800003b0:	53c7b783          	ld	a5,1340(a5) # 800078e8 <kernel_pagetable>
    800003b4:	83b1                	srli	a5,a5,0xc
    800003b6:	577d                	li	a4,-1
    800003b8:	177e                	slli	a4,a4,0x3f
    800003ba:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003bc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003c0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003c4:	6422                	ld	s0,8(sp)
    800003c6:	0141                	addi	sp,sp,16
    800003c8:	8082                	ret

00000000800003ca <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003ca:	7139                	addi	sp,sp,-64
    800003cc:	fc06                	sd	ra,56(sp)
    800003ce:	f822                	sd	s0,48(sp)
    800003d0:	f426                	sd	s1,40(sp)
    800003d2:	f04a                	sd	s2,32(sp)
    800003d4:	ec4e                	sd	s3,24(sp)
    800003d6:	e852                	sd	s4,16(sp)
    800003d8:	e456                	sd	s5,8(sp)
    800003da:	e05a                	sd	s6,0(sp)
    800003dc:	0080                	addi	s0,sp,64
    800003de:	84aa                	mv	s1,a0
    800003e0:	89ae                	mv	s3,a1
    800003e2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003e4:	57fd                	li	a5,-1
    800003e6:	83e9                	srli	a5,a5,0x1a
    800003e8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003ea:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ec:	02b7fc63          	bgeu	a5,a1,80000424 <walk+0x5a>
    panic("walk");
    800003f0:	00007517          	auipc	a0,0x7
    800003f4:	c6050513          	addi	a0,a0,-928 # 80007050 <etext+0x50>
    800003f8:	00a050ef          	jal	ra,80005402 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003fc:	060a8263          	beqz	s5,80000460 <walk+0x96>
    80000400:	cffff0ef          	jal	ra,800000fe <kalloc>
    80000404:	84aa                	mv	s1,a0
    80000406:	c139                	beqz	a0,8000044c <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000408:	6605                	lui	a2,0x1
    8000040a:	4581                	li	a1,0
    8000040c:	d43ff0ef          	jal	ra,8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000410:	00c4d793          	srli	a5,s1,0xc
    80000414:	07aa                	slli	a5,a5,0xa
    80000416:	0017e793          	ori	a5,a5,1
    8000041a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000041e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe2fa7>
    80000420:	036a0063          	beq	s4,s6,80000440 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000424:	0149d933          	srl	s2,s3,s4
    80000428:	1ff97913          	andi	s2,s2,511
    8000042c:	090e                	slli	s2,s2,0x3
    8000042e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000430:	00093483          	ld	s1,0(s2)
    80000434:	0014f793          	andi	a5,s1,1
    80000438:	d3f1                	beqz	a5,800003fc <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000043a:	80a9                	srli	s1,s1,0xa
    8000043c:	04b2                	slli	s1,s1,0xc
    8000043e:	b7c5                	j	8000041e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000440:	00c9d513          	srli	a0,s3,0xc
    80000444:	1ff57513          	andi	a0,a0,511
    80000448:	050e                	slli	a0,a0,0x3
    8000044a:	9526                	add	a0,a0,s1
}
    8000044c:	70e2                	ld	ra,56(sp)
    8000044e:	7442                	ld	s0,48(sp)
    80000450:	74a2                	ld	s1,40(sp)
    80000452:	7902                	ld	s2,32(sp)
    80000454:	69e2                	ld	s3,24(sp)
    80000456:	6a42                	ld	s4,16(sp)
    80000458:	6aa2                	ld	s5,8(sp)
    8000045a:	6b02                	ld	s6,0(sp)
    8000045c:	6121                	addi	sp,sp,64
    8000045e:	8082                	ret
        return 0;
    80000460:	4501                	li	a0,0
    80000462:	b7ed                	j	8000044c <walk+0x82>

0000000080000464 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000464:	57fd                	li	a5,-1
    80000466:	83e9                	srli	a5,a5,0x1a
    80000468:	00b7f463          	bgeu	a5,a1,80000470 <walkaddr+0xc>
    return 0;
    8000046c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000046e:	8082                	ret
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000478:	4601                	li	a2,0
    8000047a:	f51ff0ef          	jal	ra,800003ca <walk>
  if(pte == 0)
    8000047e:	c105                	beqz	a0,8000049e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000480:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000482:	0117f693          	andi	a3,a5,17
    80000486:	4745                	li	a4,17
    return 0;
    80000488:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000048a:	00e68663          	beq	a3,a4,80000496 <walkaddr+0x32>
}
    8000048e:	60a2                	ld	ra,8(sp)
    80000490:	6402                	ld	s0,0(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret
  pa = PTE2PA(*pte);
    80000496:	83a9                	srli	a5,a5,0xa
    80000498:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000049c:	bfcd                	j	8000048e <walkaddr+0x2a>
    return 0;
    8000049e:	4501                	li	a0,0
    800004a0:	b7fd                	j	8000048e <walkaddr+0x2a>

00000000800004a2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a2:	715d                	addi	sp,sp,-80
    800004a4:	e486                	sd	ra,72(sp)
    800004a6:	e0a2                	sd	s0,64(sp)
    800004a8:	fc26                	sd	s1,56(sp)
    800004aa:	f84a                	sd	s2,48(sp)
    800004ac:	f44e                	sd	s3,40(sp)
    800004ae:	f052                	sd	s4,32(sp)
    800004b0:	ec56                	sd	s5,24(sp)
    800004b2:	e85a                	sd	s6,16(sp)
    800004b4:	e45e                	sd	s7,8(sp)
    800004b6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b8:	03459793          	slli	a5,a1,0x34
    800004bc:	e7a9                	bnez	a5,80000506 <mappages+0x64>
    800004be:	8aaa                	mv	s5,a0
    800004c0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c2:	03461793          	slli	a5,a2,0x34
    800004c6:	e7b1                	bnez	a5,80000512 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c8:	ca39                	beqz	a2,8000051e <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ca:	77fd                	lui	a5,0xfffff
    800004cc:	963e                	add	a2,a2,a5
    800004ce:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d2:	892e                	mv	s2,a1
    800004d4:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d8:	6b85                	lui	s7,0x1
    800004da:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800004de:	4605                	li	a2,1
    800004e0:	85ca                	mv	a1,s2
    800004e2:	8556                	mv	a0,s5
    800004e4:	ee7ff0ef          	jal	ra,800003ca <walk>
    800004e8:	c539                	beqz	a0,80000536 <mappages+0x94>
    if(*pte & PTE_V)
    800004ea:	611c                	ld	a5,0(a0)
    800004ec:	8b85                	andi	a5,a5,1
    800004ee:	ef95                	bnez	a5,8000052a <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f0:	80b1                	srli	s1,s1,0xc
    800004f2:	04aa                	slli	s1,s1,0xa
    800004f4:	0164e4b3          	or	s1,s1,s6
    800004f8:	0014e493          	ori	s1,s1,1
    800004fc:	e104                	sd	s1,0(a0)
    if(a == last)
    800004fe:	05390863          	beq	s2,s3,8000054e <mappages+0xac>
    a += PGSIZE;
    80000502:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000504:	bfd9                	j	800004da <mappages+0x38>
    panic("mappages: va not aligned");
    80000506:	00007517          	auipc	a0,0x7
    8000050a:	b5250513          	addi	a0,a0,-1198 # 80007058 <etext+0x58>
    8000050e:	6f5040ef          	jal	ra,80005402 <panic>
    panic("mappages: size not aligned");
    80000512:	00007517          	auipc	a0,0x7
    80000516:	b6650513          	addi	a0,a0,-1178 # 80007078 <etext+0x78>
    8000051a:	6e9040ef          	jal	ra,80005402 <panic>
    panic("mappages: size");
    8000051e:	00007517          	auipc	a0,0x7
    80000522:	b7a50513          	addi	a0,a0,-1158 # 80007098 <etext+0x98>
    80000526:	6dd040ef          	jal	ra,80005402 <panic>
      panic("mappages: remap");
    8000052a:	00007517          	auipc	a0,0x7
    8000052e:	b7e50513          	addi	a0,a0,-1154 # 800070a8 <etext+0xa8>
    80000532:	6d1040ef          	jal	ra,80005402 <panic>
      return -1;
    80000536:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000538:	60a6                	ld	ra,72(sp)
    8000053a:	6406                	ld	s0,64(sp)
    8000053c:	74e2                	ld	s1,56(sp)
    8000053e:	7942                	ld	s2,48(sp)
    80000540:	79a2                	ld	s3,40(sp)
    80000542:	7a02                	ld	s4,32(sp)
    80000544:	6ae2                	ld	s5,24(sp)
    80000546:	6b42                	ld	s6,16(sp)
    80000548:	6ba2                	ld	s7,8(sp)
    8000054a:	6161                	addi	sp,sp,80
    8000054c:	8082                	ret
  return 0;
    8000054e:	4501                	li	a0,0
    80000550:	b7e5                	j	80000538 <mappages+0x96>

0000000080000552 <kvmmap>:
{
    80000552:	1141                	addi	sp,sp,-16
    80000554:	e406                	sd	ra,8(sp)
    80000556:	e022                	sd	s0,0(sp)
    80000558:	0800                	addi	s0,sp,16
    8000055a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000055c:	86b2                	mv	a3,a2
    8000055e:	863e                	mv	a2,a5
    80000560:	f43ff0ef          	jal	ra,800004a2 <mappages>
    80000564:	e509                	bnez	a0,8000056e <kvmmap+0x1c>
}
    80000566:	60a2                	ld	ra,8(sp)
    80000568:	6402                	ld	s0,0(sp)
    8000056a:	0141                	addi	sp,sp,16
    8000056c:	8082                	ret
    panic("kvmmap");
    8000056e:	00007517          	auipc	a0,0x7
    80000572:	b4a50513          	addi	a0,a0,-1206 # 800070b8 <etext+0xb8>
    80000576:	68d040ef          	jal	ra,80005402 <panic>

000000008000057a <kvmmake>:
{
    8000057a:	1101                	addi	sp,sp,-32
    8000057c:	ec06                	sd	ra,24(sp)
    8000057e:	e822                	sd	s0,16(sp)
    80000580:	e426                	sd	s1,8(sp)
    80000582:	e04a                	sd	s2,0(sp)
    80000584:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000586:	b79ff0ef          	jal	ra,800000fe <kalloc>
    8000058a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000058c:	6605                	lui	a2,0x1
    8000058e:	4581                	li	a1,0
    80000590:	bbfff0ef          	jal	ra,8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000594:	4719                	li	a4,6
    80000596:	6685                	lui	a3,0x1
    80000598:	10000637          	lui	a2,0x10000
    8000059c:	100005b7          	lui	a1,0x10000
    800005a0:	8526                	mv	a0,s1
    800005a2:	fb1ff0ef          	jal	ra,80000552 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005a6:	4719                	li	a4,6
    800005a8:	6685                	lui	a3,0x1
    800005aa:	10001637          	lui	a2,0x10001
    800005ae:	100015b7          	lui	a1,0x10001
    800005b2:	8526                	mv	a0,s1
    800005b4:	f9fff0ef          	jal	ra,80000552 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b8:	4719                	li	a4,6
    800005ba:	040006b7          	lui	a3,0x4000
    800005be:	0c000637          	lui	a2,0xc000
    800005c2:	0c0005b7          	lui	a1,0xc000
    800005c6:	8526                	mv	a0,s1
    800005c8:	f8bff0ef          	jal	ra,80000552 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005cc:	00007917          	auipc	s2,0x7
    800005d0:	a3490913          	addi	s2,s2,-1484 # 80007000 <etext>
    800005d4:	4729                	li	a4,10
    800005d6:	80007697          	auipc	a3,0x80007
    800005da:	a2a68693          	addi	a3,a3,-1494 # 7000 <_entry-0x7fff9000>
    800005de:	4605                	li	a2,1
    800005e0:	067e                	slli	a2,a2,0x1f
    800005e2:	85b2                	mv	a1,a2
    800005e4:	8526                	mv	a0,s1
    800005e6:	f6dff0ef          	jal	ra,80000552 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005ea:	4719                	li	a4,6
    800005ec:	46c5                	li	a3,17
    800005ee:	06ee                	slli	a3,a3,0x1b
    800005f0:	412686b3          	sub	a3,a3,s2
    800005f4:	864a                	mv	a2,s2
    800005f6:	85ca                	mv	a1,s2
    800005f8:	8526                	mv	a0,s1
    800005fa:	f59ff0ef          	jal	ra,80000552 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005fe:	4729                	li	a4,10
    80000600:	6685                	lui	a3,0x1
    80000602:	00006617          	auipc	a2,0x6
    80000606:	9fe60613          	addi	a2,a2,-1538 # 80006000 <_trampoline>
    8000060a:	040005b7          	lui	a1,0x4000
    8000060e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000610:	05b2                	slli	a1,a1,0xc
    80000612:	8526                	mv	a0,s1
    80000614:	f3fff0ef          	jal	ra,80000552 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000618:	8526                	mv	a0,s1
    8000061a:	594000ef          	jal	ra,80000bae <proc_mapstacks>
}
    8000061e:	8526                	mv	a0,s1
    80000620:	60e2                	ld	ra,24(sp)
    80000622:	6442                	ld	s0,16(sp)
    80000624:	64a2                	ld	s1,8(sp)
    80000626:	6902                	ld	s2,0(sp)
    80000628:	6105                	addi	sp,sp,32
    8000062a:	8082                	ret

000000008000062c <kvminit>:
{
    8000062c:	1141                	addi	sp,sp,-16
    8000062e:	e406                	sd	ra,8(sp)
    80000630:	e022                	sd	s0,0(sp)
    80000632:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000634:	f47ff0ef          	jal	ra,8000057a <kvmmake>
    80000638:	00007797          	auipc	a5,0x7
    8000063c:	2aa7b823          	sd	a0,688(a5) # 800078e8 <kernel_pagetable>
}
    80000640:	60a2                	ld	ra,8(sp)
    80000642:	6402                	ld	s0,0(sp)
    80000644:	0141                	addi	sp,sp,16
    80000646:	8082                	ret

0000000080000648 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000648:	715d                	addi	sp,sp,-80
    8000064a:	e486                	sd	ra,72(sp)
    8000064c:	e0a2                	sd	s0,64(sp)
    8000064e:	fc26                	sd	s1,56(sp)
    80000650:	f84a                	sd	s2,48(sp)
    80000652:	f44e                	sd	s3,40(sp)
    80000654:	f052                	sd	s4,32(sp)
    80000656:	ec56                	sd	s5,24(sp)
    80000658:	e85a                	sd	s6,16(sp)
    8000065a:	e45e                	sd	s7,8(sp)
    8000065c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000065e:	03459793          	slli	a5,a1,0x34
    80000662:	e795                	bnez	a5,8000068e <uvmunmap+0x46>
    80000664:	8a2a                	mv	s4,a0
    80000666:	892e                	mv	s2,a1
    80000668:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000066a:	0632                	slli	a2,a2,0xc
    8000066c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000670:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000672:	6b05                	lui	s6,0x1
    80000674:	0535ea63          	bltu	a1,s3,800006c8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000678:	60a6                	ld	ra,72(sp)
    8000067a:	6406                	ld	s0,64(sp)
    8000067c:	74e2                	ld	s1,56(sp)
    8000067e:	7942                	ld	s2,48(sp)
    80000680:	79a2                	ld	s3,40(sp)
    80000682:	7a02                	ld	s4,32(sp)
    80000684:	6ae2                	ld	s5,24(sp)
    80000686:	6b42                	ld	s6,16(sp)
    80000688:	6ba2                	ld	s7,8(sp)
    8000068a:	6161                	addi	sp,sp,80
    8000068c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000068e:	00007517          	auipc	a0,0x7
    80000692:	a3250513          	addi	a0,a0,-1486 # 800070c0 <etext+0xc0>
    80000696:	56d040ef          	jal	ra,80005402 <panic>
      panic("uvmunmap: walk");
    8000069a:	00007517          	auipc	a0,0x7
    8000069e:	a3e50513          	addi	a0,a0,-1474 # 800070d8 <etext+0xd8>
    800006a2:	561040ef          	jal	ra,80005402 <panic>
      panic("uvmunmap: not mapped");
    800006a6:	00007517          	auipc	a0,0x7
    800006aa:	a4250513          	addi	a0,a0,-1470 # 800070e8 <etext+0xe8>
    800006ae:	555040ef          	jal	ra,80005402 <panic>
      panic("uvmunmap: not a leaf");
    800006b2:	00007517          	auipc	a0,0x7
    800006b6:	a4e50513          	addi	a0,a0,-1458 # 80007100 <etext+0x100>
    800006ba:	549040ef          	jal	ra,80005402 <panic>
    *pte = 0;
    800006be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006c2:	995a                	add	s2,s2,s6
    800006c4:	fb397ae3          	bgeu	s2,s3,80000678 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006c8:	4601                	li	a2,0
    800006ca:	85ca                	mv	a1,s2
    800006cc:	8552                	mv	a0,s4
    800006ce:	cfdff0ef          	jal	ra,800003ca <walk>
    800006d2:	84aa                	mv	s1,a0
    800006d4:	d179                	beqz	a0,8000069a <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800006d6:	6108                	ld	a0,0(a0)
    800006d8:	00157793          	andi	a5,a0,1
    800006dc:	d7e9                	beqz	a5,800006a6 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006de:	3ff57793          	andi	a5,a0,1023
    800006e2:	fd7788e3          	beq	a5,s7,800006b2 <uvmunmap+0x6a>
    if(do_free){
    800006e6:	fc0a8ce3          	beqz	s5,800006be <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800006ea:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006ec:	0532                	slli	a0,a0,0xc
    800006ee:	92fff0ef          	jal	ra,8000001c <kfree>
    800006f2:	b7f1                	j	800006be <uvmunmap+0x76>

00000000800006f4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006f4:	1101                	addi	sp,sp,-32
    800006f6:	ec06                	sd	ra,24(sp)
    800006f8:	e822                	sd	s0,16(sp)
    800006fa:	e426                	sd	s1,8(sp)
    800006fc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006fe:	a01ff0ef          	jal	ra,800000fe <kalloc>
    80000702:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000704:	c509                	beqz	a0,8000070e <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000706:	6605                	lui	a2,0x1
    80000708:	4581                	li	a1,0
    8000070a:	a45ff0ef          	jal	ra,8000014e <memset>
  return pagetable;
}
    8000070e:	8526                	mv	a0,s1
    80000710:	60e2                	ld	ra,24(sp)
    80000712:	6442                	ld	s0,16(sp)
    80000714:	64a2                	ld	s1,8(sp)
    80000716:	6105                	addi	sp,sp,32
    80000718:	8082                	ret

000000008000071a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000071a:	7179                	addi	sp,sp,-48
    8000071c:	f406                	sd	ra,40(sp)
    8000071e:	f022                	sd	s0,32(sp)
    80000720:	ec26                	sd	s1,24(sp)
    80000722:	e84a                	sd	s2,16(sp)
    80000724:	e44e                	sd	s3,8(sp)
    80000726:	e052                	sd	s4,0(sp)
    80000728:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000072a:	6785                	lui	a5,0x1
    8000072c:	04f67063          	bgeu	a2,a5,8000076c <uvmfirst+0x52>
    80000730:	8a2a                	mv	s4,a0
    80000732:	89ae                	mv	s3,a1
    80000734:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000736:	9c9ff0ef          	jal	ra,800000fe <kalloc>
    8000073a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000073c:	6605                	lui	a2,0x1
    8000073e:	4581                	li	a1,0
    80000740:	a0fff0ef          	jal	ra,8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000744:	4779                	li	a4,30
    80000746:	86ca                	mv	a3,s2
    80000748:	6605                	lui	a2,0x1
    8000074a:	4581                	li	a1,0
    8000074c:	8552                	mv	a0,s4
    8000074e:	d55ff0ef          	jal	ra,800004a2 <mappages>
  memmove(mem, src, sz);
    80000752:	8626                	mv	a2,s1
    80000754:	85ce                	mv	a1,s3
    80000756:	854a                	mv	a0,s2
    80000758:	a53ff0ef          	jal	ra,800001aa <memmove>
}
    8000075c:	70a2                	ld	ra,40(sp)
    8000075e:	7402                	ld	s0,32(sp)
    80000760:	64e2                	ld	s1,24(sp)
    80000762:	6942                	ld	s2,16(sp)
    80000764:	69a2                	ld	s3,8(sp)
    80000766:	6a02                	ld	s4,0(sp)
    80000768:	6145                	addi	sp,sp,48
    8000076a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000076c:	00007517          	auipc	a0,0x7
    80000770:	9ac50513          	addi	a0,a0,-1620 # 80007118 <etext+0x118>
    80000774:	48f040ef          	jal	ra,80005402 <panic>

0000000080000778 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000778:	1101                	addi	sp,sp,-32
    8000077a:	ec06                	sd	ra,24(sp)
    8000077c:	e822                	sd	s0,16(sp)
    8000077e:	e426                	sd	s1,8(sp)
    80000780:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000782:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000784:	00b67d63          	bgeu	a2,a1,8000079e <uvmdealloc+0x26>
    80000788:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000078a:	6785                	lui	a5,0x1
    8000078c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000078e:	00f60733          	add	a4,a2,a5
    80000792:	76fd                	lui	a3,0xfffff
    80000794:	8f75                	and	a4,a4,a3
    80000796:	97ae                	add	a5,a5,a1
    80000798:	8ff5                	and	a5,a5,a3
    8000079a:	00f76863          	bltu	a4,a5,800007aa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000079e:	8526                	mv	a0,s1
    800007a0:	60e2                	ld	ra,24(sp)
    800007a2:	6442                	ld	s0,16(sp)
    800007a4:	64a2                	ld	s1,8(sp)
    800007a6:	6105                	addi	sp,sp,32
    800007a8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007aa:	8f99                	sub	a5,a5,a4
    800007ac:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007ae:	4685                	li	a3,1
    800007b0:	0007861b          	sext.w	a2,a5
    800007b4:	85ba                	mv	a1,a4
    800007b6:	e93ff0ef          	jal	ra,80000648 <uvmunmap>
    800007ba:	b7d5                	j	8000079e <uvmdealloc+0x26>

00000000800007bc <uvmalloc>:
  if(newsz < oldsz)
    800007bc:	08b66963          	bltu	a2,a1,8000084e <uvmalloc+0x92>
{
    800007c0:	7139                	addi	sp,sp,-64
    800007c2:	fc06                	sd	ra,56(sp)
    800007c4:	f822                	sd	s0,48(sp)
    800007c6:	f426                	sd	s1,40(sp)
    800007c8:	f04a                	sd	s2,32(sp)
    800007ca:	ec4e                	sd	s3,24(sp)
    800007cc:	e852                	sd	s4,16(sp)
    800007ce:	e456                	sd	s5,8(sp)
    800007d0:	e05a                	sd	s6,0(sp)
    800007d2:	0080                	addi	s0,sp,64
    800007d4:	8aaa                	mv	s5,a0
    800007d6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d8:	6785                	lui	a5,0x1
    800007da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007dc:	95be                	add	a1,a1,a5
    800007de:	77fd                	lui	a5,0xfffff
    800007e0:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007e4:	06c9f763          	bgeu	s3,a2,80000852 <uvmalloc+0x96>
    800007e8:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007ea:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007ee:	911ff0ef          	jal	ra,800000fe <kalloc>
    800007f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800007f4:	c11d                	beqz	a0,8000081a <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    800007f6:	6605                	lui	a2,0x1
    800007f8:	4581                	li	a1,0
    800007fa:	955ff0ef          	jal	ra,8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007fe:	875a                	mv	a4,s6
    80000800:	86a6                	mv	a3,s1
    80000802:	6605                	lui	a2,0x1
    80000804:	85ca                	mv	a1,s2
    80000806:	8556                	mv	a0,s5
    80000808:	c9bff0ef          	jal	ra,800004a2 <mappages>
    8000080c:	e51d                	bnez	a0,8000083a <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000080e:	6785                	lui	a5,0x1
    80000810:	993e                	add	s2,s2,a5
    80000812:	fd496ee3          	bltu	s2,s4,800007ee <uvmalloc+0x32>
  return newsz;
    80000816:	8552                	mv	a0,s4
    80000818:	a039                	j	80000826 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    8000081a:	864e                	mv	a2,s3
    8000081c:	85ca                	mv	a1,s2
    8000081e:	8556                	mv	a0,s5
    80000820:	f59ff0ef          	jal	ra,80000778 <uvmdealloc>
      return 0;
    80000824:	4501                	li	a0,0
}
    80000826:	70e2                	ld	ra,56(sp)
    80000828:	7442                	ld	s0,48(sp)
    8000082a:	74a2                	ld	s1,40(sp)
    8000082c:	7902                	ld	s2,32(sp)
    8000082e:	69e2                	ld	s3,24(sp)
    80000830:	6a42                	ld	s4,16(sp)
    80000832:	6aa2                	ld	s5,8(sp)
    80000834:	6b02                	ld	s6,0(sp)
    80000836:	6121                	addi	sp,sp,64
    80000838:	8082                	ret
      kfree(mem);
    8000083a:	8526                	mv	a0,s1
    8000083c:	fe0ff0ef          	jal	ra,8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000840:	864e                	mv	a2,s3
    80000842:	85ca                	mv	a1,s2
    80000844:	8556                	mv	a0,s5
    80000846:	f33ff0ef          	jal	ra,80000778 <uvmdealloc>
      return 0;
    8000084a:	4501                	li	a0,0
    8000084c:	bfe9                	j	80000826 <uvmalloc+0x6a>
    return oldsz;
    8000084e:	852e                	mv	a0,a1
}
    80000850:	8082                	ret
  return newsz;
    80000852:	8532                	mv	a0,a2
    80000854:	bfc9                	j	80000826 <uvmalloc+0x6a>

0000000080000856 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000856:	7179                	addi	sp,sp,-48
    80000858:	f406                	sd	ra,40(sp)
    8000085a:	f022                	sd	s0,32(sp)
    8000085c:	ec26                	sd	s1,24(sp)
    8000085e:	e84a                	sd	s2,16(sp)
    80000860:	e44e                	sd	s3,8(sp)
    80000862:	e052                	sd	s4,0(sp)
    80000864:	1800                	addi	s0,sp,48
    80000866:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000868:	84aa                	mv	s1,a0
    8000086a:	6905                	lui	s2,0x1
    8000086c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000086e:	4985                	li	s3,1
    80000870:	a819                	j	80000886 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000872:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000874:	00c79513          	slli	a0,a5,0xc
    80000878:	fdfff0ef          	jal	ra,80000856 <freewalk>
      pagetable[i] = 0;
    8000087c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000880:	04a1                	addi	s1,s1,8
    80000882:	01248f63          	beq	s1,s2,800008a0 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000886:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000888:	00f7f713          	andi	a4,a5,15
    8000088c:	ff3703e3          	beq	a4,s3,80000872 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000890:	8b85                	andi	a5,a5,1
    80000892:	d7fd                	beqz	a5,80000880 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000894:	00007517          	auipc	a0,0x7
    80000898:	8a450513          	addi	a0,a0,-1884 # 80007138 <etext+0x138>
    8000089c:	367040ef          	jal	ra,80005402 <panic>
    }
  }
  kfree((void*)pagetable);
    800008a0:	8552                	mv	a0,s4
    800008a2:	f7aff0ef          	jal	ra,8000001c <kfree>
}
    800008a6:	70a2                	ld	ra,40(sp)
    800008a8:	7402                	ld	s0,32(sp)
    800008aa:	64e2                	ld	s1,24(sp)
    800008ac:	6942                	ld	s2,16(sp)
    800008ae:	69a2                	ld	s3,8(sp)
    800008b0:	6a02                	ld	s4,0(sp)
    800008b2:	6145                	addi	sp,sp,48
    800008b4:	8082                	ret

00000000800008b6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b6:	1101                	addi	sp,sp,-32
    800008b8:	ec06                	sd	ra,24(sp)
    800008ba:	e822                	sd	s0,16(sp)
    800008bc:	e426                	sd	s1,8(sp)
    800008be:	1000                	addi	s0,sp,32
    800008c0:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c2:	e989                	bnez	a1,800008d4 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c4:	8526                	mv	a0,s1
    800008c6:	f91ff0ef          	jal	ra,80000856 <freewalk>
}
    800008ca:	60e2                	ld	ra,24(sp)
    800008cc:	6442                	ld	s0,16(sp)
    800008ce:	64a2                	ld	s1,8(sp)
    800008d0:	6105                	addi	sp,sp,32
    800008d2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	4685                	li	a3,1
    800008dc:	00c5d613          	srli	a2,a1,0xc
    800008e0:	4581                	li	a1,0
    800008e2:	d67ff0ef          	jal	ra,80000648 <uvmunmap>
    800008e6:	bff9                	j	800008c4 <uvmfree+0xe>

00000000800008e8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008e8:	c65d                	beqz	a2,80000996 <uvmcopy+0xae>
{
    800008ea:	715d                	addi	sp,sp,-80
    800008ec:	e486                	sd	ra,72(sp)
    800008ee:	e0a2                	sd	s0,64(sp)
    800008f0:	fc26                	sd	s1,56(sp)
    800008f2:	f84a                	sd	s2,48(sp)
    800008f4:	f44e                	sd	s3,40(sp)
    800008f6:	f052                	sd	s4,32(sp)
    800008f8:	ec56                	sd	s5,24(sp)
    800008fa:	e85a                	sd	s6,16(sp)
    800008fc:	e45e                	sd	s7,8(sp)
    800008fe:	0880                	addi	s0,sp,80
    80000900:	8b2a                	mv	s6,a0
    80000902:	8aae                	mv	s5,a1
    80000904:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000906:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000908:	4601                	li	a2,0
    8000090a:	85ce                	mv	a1,s3
    8000090c:	855a                	mv	a0,s6
    8000090e:	abdff0ef          	jal	ra,800003ca <walk>
    80000912:	c121                	beqz	a0,80000952 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000914:	6118                	ld	a4,0(a0)
    80000916:	00177793          	andi	a5,a4,1
    8000091a:	c3b1                	beqz	a5,8000095e <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091c:	00a75593          	srli	a1,a4,0xa
    80000920:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000924:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000928:	fd6ff0ef          	jal	ra,800000fe <kalloc>
    8000092c:	892a                	mv	s2,a0
    8000092e:	c129                	beqz	a0,80000970 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000930:	6605                	lui	a2,0x1
    80000932:	85de                	mv	a1,s7
    80000934:	877ff0ef          	jal	ra,800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000938:	8726                	mv	a4,s1
    8000093a:	86ca                	mv	a3,s2
    8000093c:	6605                	lui	a2,0x1
    8000093e:	85ce                	mv	a1,s3
    80000940:	8556                	mv	a0,s5
    80000942:	b61ff0ef          	jal	ra,800004a2 <mappages>
    80000946:	e115                	bnez	a0,8000096a <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80000948:	6785                	lui	a5,0x1
    8000094a:	99be                	add	s3,s3,a5
    8000094c:	fb49eee3          	bltu	s3,s4,80000908 <uvmcopy+0x20>
    80000950:	a805                	j	80000980 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000952:	00006517          	auipc	a0,0x6
    80000956:	7f650513          	addi	a0,a0,2038 # 80007148 <etext+0x148>
    8000095a:	2a9040ef          	jal	ra,80005402 <panic>
      panic("uvmcopy: page not present");
    8000095e:	00007517          	auipc	a0,0x7
    80000962:	80a50513          	addi	a0,a0,-2038 # 80007168 <etext+0x168>
    80000966:	29d040ef          	jal	ra,80005402 <panic>
      kfree(mem);
    8000096a:	854a                	mv	a0,s2
    8000096c:	eb0ff0ef          	jal	ra,8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000970:	4685                	li	a3,1
    80000972:	00c9d613          	srli	a2,s3,0xc
    80000976:	4581                	li	a1,0
    80000978:	8556                	mv	a0,s5
    8000097a:	ccfff0ef          	jal	ra,80000648 <uvmunmap>
  return -1;
    8000097e:	557d                	li	a0,-1
}
    80000980:	60a6                	ld	ra,72(sp)
    80000982:	6406                	ld	s0,64(sp)
    80000984:	74e2                	ld	s1,56(sp)
    80000986:	7942                	ld	s2,48(sp)
    80000988:	79a2                	ld	s3,40(sp)
    8000098a:	7a02                	ld	s4,32(sp)
    8000098c:	6ae2                	ld	s5,24(sp)
    8000098e:	6b42                	ld	s6,16(sp)
    80000990:	6ba2                	ld	s7,8(sp)
    80000992:	6161                	addi	sp,sp,80
    80000994:	8082                	ret
  return 0;
    80000996:	4501                	li	a0,0
}
    80000998:	8082                	ret

000000008000099a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000099a:	1141                	addi	sp,sp,-16
    8000099c:	e406                	sd	ra,8(sp)
    8000099e:	e022                	sd	s0,0(sp)
    800009a0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a2:	4601                	li	a2,0
    800009a4:	a27ff0ef          	jal	ra,800003ca <walk>
  if(pte == 0)
    800009a8:	c901                	beqz	a0,800009b8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009aa:	611c                	ld	a5,0(a0)
    800009ac:	9bbd                	andi	a5,a5,-17
    800009ae:	e11c                	sd	a5,0(a0)
}
    800009b0:	60a2                	ld	ra,8(sp)
    800009b2:	6402                	ld	s0,0(sp)
    800009b4:	0141                	addi	sp,sp,16
    800009b6:	8082                	ret
    panic("uvmclear");
    800009b8:	00006517          	auipc	a0,0x6
    800009bc:	7d050513          	addi	a0,a0,2000 # 80007188 <etext+0x188>
    800009c0:	243040ef          	jal	ra,80005402 <panic>

00000000800009c4 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c4:	c6c9                	beqz	a3,80000a4e <copyout+0x8a>
{
    800009c6:	711d                	addi	sp,sp,-96
    800009c8:	ec86                	sd	ra,88(sp)
    800009ca:	e8a2                	sd	s0,80(sp)
    800009cc:	e4a6                	sd	s1,72(sp)
    800009ce:	e0ca                	sd	s2,64(sp)
    800009d0:	fc4e                	sd	s3,56(sp)
    800009d2:	f852                	sd	s4,48(sp)
    800009d4:	f456                	sd	s5,40(sp)
    800009d6:	f05a                	sd	s6,32(sp)
    800009d8:	ec5e                	sd	s7,24(sp)
    800009da:	e862                	sd	s8,16(sp)
    800009dc:	e466                	sd	s9,8(sp)
    800009de:	e06a                	sd	s10,0(sp)
    800009e0:	1080                	addi	s0,sp,96
    800009e2:	8baa                	mv	s7,a0
    800009e4:	8aae                	mv	s5,a1
    800009e6:	8b32                	mv	s6,a2
    800009e8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009ea:	74fd                	lui	s1,0xfffff
    800009ec:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009ee:	57fd                	li	a5,-1
    800009f0:	83e9                	srli	a5,a5,0x1a
    800009f2:	0697e063          	bltu	a5,s1,80000a52 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800009f6:	4cd5                	li	s9,21
    800009f8:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800009fa:	8c3e                	mv	s8,a5
    800009fc:	a025                	j	80000a24 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800009fe:	83a9                	srli	a5,a5,0xa
    80000a00:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a02:	409a8533          	sub	a0,s5,s1
    80000a06:	0009061b          	sext.w	a2,s2
    80000a0a:	85da                	mv	a1,s6
    80000a0c:	953e                	add	a0,a0,a5
    80000a0e:	f9cff0ef          	jal	ra,800001aa <memmove>

    len -= n;
    80000a12:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a16:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a18:	02098963          	beqz	s3,80000a4a <copyout+0x86>
    if(va0 >= MAXVA)
    80000a1c:	034c6d63          	bltu	s8,s4,80000a56 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000a20:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000a22:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a24:	4601                	li	a2,0
    80000a26:	85a6                	mv	a1,s1
    80000a28:	855e                	mv	a0,s7
    80000a2a:	9a1ff0ef          	jal	ra,800003ca <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a2e:	c515                	beqz	a0,80000a5a <copyout+0x96>
    80000a30:	611c                	ld	a5,0(a0)
    80000a32:	0157f713          	andi	a4,a5,21
    80000a36:	05971163          	bne	a4,s9,80000a78 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80000a3a:	01a48a33          	add	s4,s1,s10
    80000a3e:	415a0933          	sub	s2,s4,s5
    80000a42:	fb29fee3          	bgeu	s3,s2,800009fe <copyout+0x3a>
    80000a46:	894e                	mv	s2,s3
    80000a48:	bf5d                	j	800009fe <copyout+0x3a>
  }
  return 0;
    80000a4a:	4501                	li	a0,0
    80000a4c:	a801                	j	80000a5c <copyout+0x98>
    80000a4e:	4501                	li	a0,0
}
    80000a50:	8082                	ret
      return -1;
    80000a52:	557d                	li	a0,-1
    80000a54:	a021                	j	80000a5c <copyout+0x98>
    80000a56:	557d                	li	a0,-1
    80000a58:	a011                	j	80000a5c <copyout+0x98>
      return -1;
    80000a5a:	557d                	li	a0,-1
}
    80000a5c:	60e6                	ld	ra,88(sp)
    80000a5e:	6446                	ld	s0,80(sp)
    80000a60:	64a6                	ld	s1,72(sp)
    80000a62:	6906                	ld	s2,64(sp)
    80000a64:	79e2                	ld	s3,56(sp)
    80000a66:	7a42                	ld	s4,48(sp)
    80000a68:	7aa2                	ld	s5,40(sp)
    80000a6a:	7b02                	ld	s6,32(sp)
    80000a6c:	6be2                	ld	s7,24(sp)
    80000a6e:	6c42                	ld	s8,16(sp)
    80000a70:	6ca2                	ld	s9,8(sp)
    80000a72:	6d02                	ld	s10,0(sp)
    80000a74:	6125                	addi	sp,sp,96
    80000a76:	8082                	ret
      return -1;
    80000a78:	557d                	li	a0,-1
    80000a7a:	b7cd                	j	80000a5c <copyout+0x98>

0000000080000a7c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000a7c:	c6a5                	beqz	a3,80000ae4 <copyin+0x68>
{
    80000a7e:	715d                	addi	sp,sp,-80
    80000a80:	e486                	sd	ra,72(sp)
    80000a82:	e0a2                	sd	s0,64(sp)
    80000a84:	fc26                	sd	s1,56(sp)
    80000a86:	f84a                	sd	s2,48(sp)
    80000a88:	f44e                	sd	s3,40(sp)
    80000a8a:	f052                	sd	s4,32(sp)
    80000a8c:	ec56                	sd	s5,24(sp)
    80000a8e:	e85a                	sd	s6,16(sp)
    80000a90:	e45e                	sd	s7,8(sp)
    80000a92:	e062                	sd	s8,0(sp)
    80000a94:	0880                	addi	s0,sp,80
    80000a96:	8b2a                	mv	s6,a0
    80000a98:	8a2e                	mv	s4,a1
    80000a9a:	8c32                	mv	s8,a2
    80000a9c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000a9e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000aa0:	6a85                	lui	s5,0x1
    80000aa2:	a00d                	j	80000ac4 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000aa4:	018505b3          	add	a1,a0,s8
    80000aa8:	0004861b          	sext.w	a2,s1
    80000aac:	412585b3          	sub	a1,a1,s2
    80000ab0:	8552                	mv	a0,s4
    80000ab2:	ef8ff0ef          	jal	ra,800001aa <memmove>

    len -= n;
    80000ab6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000aba:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000abc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ac0:	02098063          	beqz	s3,80000ae0 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000ac4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ac8:	85ca                	mv	a1,s2
    80000aca:	855a                	mv	a0,s6
    80000acc:	999ff0ef          	jal	ra,80000464 <walkaddr>
    if(pa0 == 0)
    80000ad0:	cd01                	beqz	a0,80000ae8 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000ad2:	418904b3          	sub	s1,s2,s8
    80000ad6:	94d6                	add	s1,s1,s5
    80000ad8:	fc99f6e3          	bgeu	s3,s1,80000aa4 <copyin+0x28>
    80000adc:	84ce                	mv	s1,s3
    80000ade:	b7d9                	j	80000aa4 <copyin+0x28>
  }
  return 0;
    80000ae0:	4501                	li	a0,0
    80000ae2:	a021                	j	80000aea <copyin+0x6e>
    80000ae4:	4501                	li	a0,0
}
    80000ae6:	8082                	ret
      return -1;
    80000ae8:	557d                	li	a0,-1
}
    80000aea:	60a6                	ld	ra,72(sp)
    80000aec:	6406                	ld	s0,64(sp)
    80000aee:	74e2                	ld	s1,56(sp)
    80000af0:	7942                	ld	s2,48(sp)
    80000af2:	79a2                	ld	s3,40(sp)
    80000af4:	7a02                	ld	s4,32(sp)
    80000af6:	6ae2                	ld	s5,24(sp)
    80000af8:	6b42                	ld	s6,16(sp)
    80000afa:	6ba2                	ld	s7,8(sp)
    80000afc:	6c02                	ld	s8,0(sp)
    80000afe:	6161                	addi	sp,sp,80
    80000b00:	8082                	ret

0000000080000b02 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b02:	c2cd                	beqz	a3,80000ba4 <copyinstr+0xa2>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	0880                	addi	s0,sp,80
    80000b1a:	8a2a                	mv	s4,a0
    80000b1c:	8b2e                	mv	s6,a1
    80000b1e:	8bb2                	mv	s7,a2
    80000b20:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000b22:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b24:	6985                	lui	s3,0x1
    80000b26:	a02d                	j	80000b50 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b28:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b2c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b2e:	37fd                	addiw	a5,a5,-1
    80000b30:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b34:	60a6                	ld	ra,72(sp)
    80000b36:	6406                	ld	s0,64(sp)
    80000b38:	74e2                	ld	s1,56(sp)
    80000b3a:	7942                	ld	s2,48(sp)
    80000b3c:	79a2                	ld	s3,40(sp)
    80000b3e:	7a02                	ld	s4,32(sp)
    80000b40:	6ae2                	ld	s5,24(sp)
    80000b42:	6b42                	ld	s6,16(sp)
    80000b44:	6ba2                	ld	s7,8(sp)
    80000b46:	6161                	addi	sp,sp,80
    80000b48:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b4a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000b4e:	c4b9                	beqz	s1,80000b9c <copyinstr+0x9a>
    va0 = PGROUNDDOWN(srcva);
    80000b50:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b54:	85ca                	mv	a1,s2
    80000b56:	8552                	mv	a0,s4
    80000b58:	90dff0ef          	jal	ra,80000464 <walkaddr>
    if(pa0 == 0)
    80000b5c:	c131                	beqz	a0,80000ba0 <copyinstr+0x9e>
    n = PGSIZE - (srcva - va0);
    80000b5e:	417906b3          	sub	a3,s2,s7
    80000b62:	96ce                	add	a3,a3,s3
    80000b64:	00d4f363          	bgeu	s1,a3,80000b6a <copyinstr+0x68>
    80000b68:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000b6a:	955e                	add	a0,a0,s7
    80000b6c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000b70:	dee9                	beqz	a3,80000b4a <copyinstr+0x48>
    80000b72:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000b74:	41650633          	sub	a2,a0,s6
    80000b78:	fff48593          	addi	a1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffe2faf>
    80000b7c:	95da                	add	a1,a1,s6
    while(n > 0){
    80000b7e:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000b80:	00f60733          	add	a4,a2,a5
    80000b84:	00074703          	lbu	a4,0(a4)
    80000b88:	d345                	beqz	a4,80000b28 <copyinstr+0x26>
        *dst = *p;
    80000b8a:	00e78023          	sb	a4,0(a5)
      --max;
    80000b8e:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000b92:	0785                	addi	a5,a5,1
    while(n > 0){
    80000b94:	fed796e3          	bne	a5,a3,80000b80 <copyinstr+0x7e>
      dst++;
    80000b98:	8b3e                	mv	s6,a5
    80000b9a:	bf45                	j	80000b4a <copyinstr+0x48>
    80000b9c:	4781                	li	a5,0
    80000b9e:	bf41                	j	80000b2e <copyinstr+0x2c>
      return -1;
    80000ba0:	557d                	li	a0,-1
    80000ba2:	bf49                	j	80000b34 <copyinstr+0x32>
  int got_null = 0;
    80000ba4:	4781                	li	a5,0
  if(got_null){
    80000ba6:	37fd                	addiw	a5,a5,-1
    80000ba8:	0007851b          	sext.w	a0,a5
}
    80000bac:	8082                	ret

0000000080000bae <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bae:	7139                	addi	sp,sp,-64
    80000bb0:	fc06                	sd	ra,56(sp)
    80000bb2:	f822                	sd	s0,48(sp)
    80000bb4:	f426                	sd	s1,40(sp)
    80000bb6:	f04a                	sd	s2,32(sp)
    80000bb8:	ec4e                	sd	s3,24(sp)
    80000bba:	e852                	sd	s4,16(sp)
    80000bbc:	e456                	sd	s5,8(sp)
    80000bbe:	e05a                	sd	s6,0(sp)
    80000bc0:	0080                	addi	s0,sp,64
    80000bc2:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bc4:	00007497          	auipc	s1,0x7
    80000bc8:	19c48493          	addi	s1,s1,412 # 80007d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bcc:	8b26                	mv	s6,s1
    80000bce:	00006a97          	auipc	s5,0x6
    80000bd2:	432a8a93          	addi	s5,s5,1074 # 80007000 <etext>
    80000bd6:	04000937          	lui	s2,0x4000
    80000bda:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000bdc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bde:	00008a17          	auipc	s4,0x8
    80000be2:	f92a0a13          	addi	s4,s4,-110 # 80008b70 <tickslock>
    char *pa = kalloc();
    80000be6:	d18ff0ef          	jal	ra,800000fe <kalloc>
    80000bea:	862a                	mv	a2,a0
    if(pa == 0)
    80000bec:	c121                	beqz	a0,80000c2c <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80000bee:	416485b3          	sub	a1,s1,s6
    80000bf2:	858d                	srai	a1,a1,0x3
    80000bf4:	000ab783          	ld	a5,0(s5)
    80000bf8:	02f585b3          	mul	a1,a1,a5
    80000bfc:	2585                	addiw	a1,a1,1
    80000bfe:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c02:	4719                	li	a4,6
    80000c04:	6685                	lui	a3,0x1
    80000c06:	40b905b3          	sub	a1,s2,a1
    80000c0a:	854e                	mv	a0,s3
    80000c0c:	947ff0ef          	jal	ra,80000552 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c10:	16848493          	addi	s1,s1,360
    80000c14:	fd4499e3          	bne	s1,s4,80000be6 <proc_mapstacks+0x38>
  }
}
    80000c18:	70e2                	ld	ra,56(sp)
    80000c1a:	7442                	ld	s0,48(sp)
    80000c1c:	74a2                	ld	s1,40(sp)
    80000c1e:	7902                	ld	s2,32(sp)
    80000c20:	69e2                	ld	s3,24(sp)
    80000c22:	6a42                	ld	s4,16(sp)
    80000c24:	6aa2                	ld	s5,8(sp)
    80000c26:	6b02                	ld	s6,0(sp)
    80000c28:	6121                	addi	sp,sp,64
    80000c2a:	8082                	ret
      panic("kalloc");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	56c50513          	addi	a0,a0,1388 # 80007198 <etext+0x198>
    80000c34:	7ce040ef          	jal	ra,80005402 <panic>

0000000080000c38 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c38:	7139                	addi	sp,sp,-64
    80000c3a:	fc06                	sd	ra,56(sp)
    80000c3c:	f822                	sd	s0,48(sp)
    80000c3e:	f426                	sd	s1,40(sp)
    80000c40:	f04a                	sd	s2,32(sp)
    80000c42:	ec4e                	sd	s3,24(sp)
    80000c44:	e852                	sd	s4,16(sp)
    80000c46:	e456                	sd	s5,8(sp)
    80000c48:	e05a                	sd	s6,0(sp)
    80000c4a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c4c:	00006597          	auipc	a1,0x6
    80000c50:	55458593          	addi	a1,a1,1364 # 800071a0 <etext+0x1a0>
    80000c54:	00007517          	auipc	a0,0x7
    80000c58:	cdc50513          	addi	a0,a0,-804 # 80007930 <pid_lock>
    80000c5c:	237040ef          	jal	ra,80005692 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c60:	00006597          	auipc	a1,0x6
    80000c64:	54858593          	addi	a1,a1,1352 # 800071a8 <etext+0x1a8>
    80000c68:	00007517          	auipc	a0,0x7
    80000c6c:	ce050513          	addi	a0,a0,-800 # 80007948 <wait_lock>
    80000c70:	223040ef          	jal	ra,80005692 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c74:	00007497          	auipc	s1,0x7
    80000c78:	0ec48493          	addi	s1,s1,236 # 80007d60 <proc>
      initlock(&p->lock, "proc");
    80000c7c:	00006b17          	auipc	s6,0x6
    80000c80:	53cb0b13          	addi	s6,s6,1340 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000c84:	8aa6                	mv	s5,s1
    80000c86:	00006a17          	auipc	s4,0x6
    80000c8a:	37aa0a13          	addi	s4,s4,890 # 80007000 <etext>
    80000c8e:	04000937          	lui	s2,0x4000
    80000c92:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000c94:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c96:	00008997          	auipc	s3,0x8
    80000c9a:	eda98993          	addi	s3,s3,-294 # 80008b70 <tickslock>
      initlock(&p->lock, "proc");
    80000c9e:	85da                	mv	a1,s6
    80000ca0:	8526                	mv	a0,s1
    80000ca2:	1f1040ef          	jal	ra,80005692 <initlock>
      p->state = UNUSED;
    80000ca6:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000caa:	415487b3          	sub	a5,s1,s5
    80000cae:	878d                	srai	a5,a5,0x3
    80000cb0:	000a3703          	ld	a4,0(s4)
    80000cb4:	02e787b3          	mul	a5,a5,a4
    80000cb8:	2785                	addiw	a5,a5,1
    80000cba:	00d7979b          	slliw	a5,a5,0xd
    80000cbe:	40f907b3          	sub	a5,s2,a5
    80000cc2:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc4:	16848493          	addi	s1,s1,360
    80000cc8:	fd349be3          	bne	s1,s3,80000c9e <procinit+0x66>
  }
}
    80000ccc:	70e2                	ld	ra,56(sp)
    80000cce:	7442                	ld	s0,48(sp)
    80000cd0:	74a2                	ld	s1,40(sp)
    80000cd2:	7902                	ld	s2,32(sp)
    80000cd4:	69e2                	ld	s3,24(sp)
    80000cd6:	6a42                	ld	s4,16(sp)
    80000cd8:	6aa2                	ld	s5,8(sp)
    80000cda:	6b02                	ld	s6,0(sp)
    80000cdc:	6121                	addi	sp,sp,64
    80000cde:	8082                	ret

0000000080000ce0 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ce6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ce8:	2501                	sext.w	a0,a0
    80000cea:	6422                	ld	s0,8(sp)
    80000cec:	0141                	addi	sp,sp,16
    80000cee:	8082                	ret

0000000080000cf0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000cf0:	1141                	addi	sp,sp,-16
    80000cf2:	e422                	sd	s0,8(sp)
    80000cf4:	0800                	addi	s0,sp,16
    80000cf6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000cf8:	2781                	sext.w	a5,a5
    80000cfa:	079e                	slli	a5,a5,0x7
  return c;
}
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	c6450513          	addi	a0,a0,-924 # 80007960 <cpus>
    80000d04:	953e                	add	a0,a0,a5
    80000d06:	6422                	ld	s0,8(sp)
    80000d08:	0141                	addi	sp,sp,16
    80000d0a:	8082                	ret

0000000080000d0c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d0c:	1101                	addi	sp,sp,-32
    80000d0e:	ec06                	sd	ra,24(sp)
    80000d10:	e822                	sd	s0,16(sp)
    80000d12:	e426                	sd	s1,8(sp)
    80000d14:	1000                	addi	s0,sp,32
  push_off();
    80000d16:	1bd040ef          	jal	ra,800056d2 <push_off>
    80000d1a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d1c:	2781                	sext.w	a5,a5
    80000d1e:	079e                	slli	a5,a5,0x7
    80000d20:	00007717          	auipc	a4,0x7
    80000d24:	c1070713          	addi	a4,a4,-1008 # 80007930 <pid_lock>
    80000d28:	97ba                	add	a5,a5,a4
    80000d2a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d2c:	22b040ef          	jal	ra,80005756 <pop_off>
  return p;
}
    80000d30:	8526                	mv	a0,s1
    80000d32:	60e2                	ld	ra,24(sp)
    80000d34:	6442                	ld	s0,16(sp)
    80000d36:	64a2                	ld	s1,8(sp)
    80000d38:	6105                	addi	sp,sp,32
    80000d3a:	8082                	ret

0000000080000d3c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d3c:	1141                	addi	sp,sp,-16
    80000d3e:	e406                	sd	ra,8(sp)
    80000d40:	e022                	sd	s0,0(sp)
    80000d42:	0800                	addi	s0,sp,16
  static int first = 1;
  
  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d44:	fc9ff0ef          	jal	ra,80000d0c <myproc>
    80000d48:	263040ef          	jal	ra,800057aa <release>

  if (first) {
    80000d4c:	00007797          	auipc	a5,0x7
    80000d50:	b247a783          	lw	a5,-1244(a5) # 80007870 <first.1>
    80000d54:	e799                	bnez	a5,80000d62 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000d56:	2bf000ef          	jal	ra,80001814 <usertrapret>
}
    80000d5a:	60a2                	ld	ra,8(sp)
    80000d5c:	6402                	ld	s0,0(sp)
    80000d5e:	0141                	addi	sp,sp,16
    80000d60:	8082                	ret
    fsinit(ROOTDEV);
    80000d62:	4505                	li	a0,1
    80000d64:	6b6010ef          	jal	ra,8000241a <fsinit>
    first = 0;
    80000d68:	00007797          	auipc	a5,0x7
    80000d6c:	b007a423          	sw	zero,-1272(a5) # 80007870 <first.1>
    __sync_synchronize();
    80000d70:	0ff0000f          	fence
    80000d74:	b7cd                	j	80000d56 <forkret+0x1a>

0000000080000d76 <allocpid>:
{
    80000d76:	1101                	addi	sp,sp,-32
    80000d78:	ec06                	sd	ra,24(sp)
    80000d7a:	e822                	sd	s0,16(sp)
    80000d7c:	e426                	sd	s1,8(sp)
    80000d7e:	e04a                	sd	s2,0(sp)
    80000d80:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000d82:	00007917          	auipc	s2,0x7
    80000d86:	bae90913          	addi	s2,s2,-1106 # 80007930 <pid_lock>
    80000d8a:	854a                	mv	a0,s2
    80000d8c:	187040ef          	jal	ra,80005712 <acquire>
  pid = nextpid;
    80000d90:	00007797          	auipc	a5,0x7
    80000d94:	ae478793          	addi	a5,a5,-1308 # 80007874 <nextpid>
    80000d98:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000d9a:	0014871b          	addiw	a4,s1,1
    80000d9e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000da0:	854a                	mv	a0,s2
    80000da2:	209040ef          	jal	ra,800057aa <release>
}
    80000da6:	8526                	mv	a0,s1
    80000da8:	60e2                	ld	ra,24(sp)
    80000daa:	6442                	ld	s0,16(sp)
    80000dac:	64a2                	ld	s1,8(sp)
    80000dae:	6902                	ld	s2,0(sp)
    80000db0:	6105                	addi	sp,sp,32
    80000db2:	8082                	ret

0000000080000db4 <proc_pagetable>:
{
    80000db4:	1101                	addi	sp,sp,-32
    80000db6:	ec06                	sd	ra,24(sp)
    80000db8:	e822                	sd	s0,16(sp)
    80000dba:	e426                	sd	s1,8(sp)
    80000dbc:	e04a                	sd	s2,0(sp)
    80000dbe:	1000                	addi	s0,sp,32
    80000dc0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000dc2:	933ff0ef          	jal	ra,800006f4 <uvmcreate>
    80000dc6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000dc8:	cd05                	beqz	a0,80000e00 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000dca:	4729                	li	a4,10
    80000dcc:	00005697          	auipc	a3,0x5
    80000dd0:	23468693          	addi	a3,a3,564 # 80006000 <_trampoline>
    80000dd4:	6605                	lui	a2,0x1
    80000dd6:	040005b7          	lui	a1,0x4000
    80000dda:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ddc:	05b2                	slli	a1,a1,0xc
    80000dde:	ec4ff0ef          	jal	ra,800004a2 <mappages>
    80000de2:	02054663          	bltz	a0,80000e0e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000de6:	4719                	li	a4,6
    80000de8:	05893683          	ld	a3,88(s2)
    80000dec:	6605                	lui	a2,0x1
    80000dee:	020005b7          	lui	a1,0x2000
    80000df2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000df4:	05b6                	slli	a1,a1,0xd
    80000df6:	8526                	mv	a0,s1
    80000df8:	eaaff0ef          	jal	ra,800004a2 <mappages>
    80000dfc:	00054f63          	bltz	a0,80000e1a <proc_pagetable+0x66>
}
    80000e00:	8526                	mv	a0,s1
    80000e02:	60e2                	ld	ra,24(sp)
    80000e04:	6442                	ld	s0,16(sp)
    80000e06:	64a2                	ld	s1,8(sp)
    80000e08:	6902                	ld	s2,0(sp)
    80000e0a:	6105                	addi	sp,sp,32
    80000e0c:	8082                	ret
    uvmfree(pagetable, 0);
    80000e0e:	4581                	li	a1,0
    80000e10:	8526                	mv	a0,s1
    80000e12:	aa5ff0ef          	jal	ra,800008b6 <uvmfree>
    return 0;
    80000e16:	4481                	li	s1,0
    80000e18:	b7e5                	j	80000e00 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e1a:	4681                	li	a3,0
    80000e1c:	4605                	li	a2,1
    80000e1e:	040005b7          	lui	a1,0x4000
    80000e22:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e24:	05b2                	slli	a1,a1,0xc
    80000e26:	8526                	mv	a0,s1
    80000e28:	821ff0ef          	jal	ra,80000648 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e2c:	4581                	li	a1,0
    80000e2e:	8526                	mv	a0,s1
    80000e30:	a87ff0ef          	jal	ra,800008b6 <uvmfree>
    return 0;
    80000e34:	4481                	li	s1,0
    80000e36:	b7e9                	j	80000e00 <proc_pagetable+0x4c>

0000000080000e38 <proc_freepagetable>:
{
    80000e38:	1101                	addi	sp,sp,-32
    80000e3a:	ec06                	sd	ra,24(sp)
    80000e3c:	e822                	sd	s0,16(sp)
    80000e3e:	e426                	sd	s1,8(sp)
    80000e40:	e04a                	sd	s2,0(sp)
    80000e42:	1000                	addi	s0,sp,32
    80000e44:	84aa                	mv	s1,a0
    80000e46:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e48:	4681                	li	a3,0
    80000e4a:	4605                	li	a2,1
    80000e4c:	040005b7          	lui	a1,0x4000
    80000e50:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e52:	05b2                	slli	a1,a1,0xc
    80000e54:	ff4ff0ef          	jal	ra,80000648 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000e58:	4681                	li	a3,0
    80000e5a:	4605                	li	a2,1
    80000e5c:	020005b7          	lui	a1,0x2000
    80000e60:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e62:	05b6                	slli	a1,a1,0xd
    80000e64:	8526                	mv	a0,s1
    80000e66:	fe2ff0ef          	jal	ra,80000648 <uvmunmap>
  uvmfree(pagetable, sz);
    80000e6a:	85ca                	mv	a1,s2
    80000e6c:	8526                	mv	a0,s1
    80000e6e:	a49ff0ef          	jal	ra,800008b6 <uvmfree>
}
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6902                	ld	s2,0(sp)
    80000e7a:	6105                	addi	sp,sp,32
    80000e7c:	8082                	ret

0000000080000e7e <freeproc>:
{
    80000e7e:	1101                	addi	sp,sp,-32
    80000e80:	ec06                	sd	ra,24(sp)
    80000e82:	e822                	sd	s0,16(sp)
    80000e84:	e426                	sd	s1,8(sp)
    80000e86:	1000                	addi	s0,sp,32
    80000e88:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000e8a:	6d28                	ld	a0,88(a0)
    80000e8c:	c119                	beqz	a0,80000e92 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000e8e:	98eff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    80000e92:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000e96:	68a8                	ld	a0,80(s1)
    80000e98:	c501                	beqz	a0,80000ea0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000e9a:	64ac                	ld	a1,72(s1)
    80000e9c:	f9dff0ef          	jal	ra,80000e38 <proc_freepagetable>
  p->pagetable = 0;
    80000ea0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ea4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ea8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000eac:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000eb0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000eb4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000eb8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000ebc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000ec0:	0004ac23          	sw	zero,24(s1)
}
    80000ec4:	60e2                	ld	ra,24(sp)
    80000ec6:	6442                	ld	s0,16(sp)
    80000ec8:	64a2                	ld	s1,8(sp)
    80000eca:	6105                	addi	sp,sp,32
    80000ecc:	8082                	ret

0000000080000ece <allocproc>:
{
    80000ece:	1101                	addi	sp,sp,-32
    80000ed0:	ec06                	sd	ra,24(sp)
    80000ed2:	e822                	sd	s0,16(sp)
    80000ed4:	e426                	sd	s1,8(sp)
    80000ed6:	e04a                	sd	s2,0(sp)
    80000ed8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eda:	00007497          	auipc	s1,0x7
    80000ede:	e8648493          	addi	s1,s1,-378 # 80007d60 <proc>
    80000ee2:	00008917          	auipc	s2,0x8
    80000ee6:	c8e90913          	addi	s2,s2,-882 # 80008b70 <tickslock>
    acquire(&p->lock);
    80000eea:	8526                	mv	a0,s1
    80000eec:	027040ef          	jal	ra,80005712 <acquire>
    if(p->state == UNUSED) {
    80000ef0:	4c9c                	lw	a5,24(s1)
    80000ef2:	c385                	beqz	a5,80000f12 <allocproc+0x44>
      release(&p->lock);
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	0b5040ef          	jal	ra,800057aa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efa:	16848493          	addi	s1,s1,360
    80000efe:	ff2496e3          	bne	s1,s2,80000eea <allocproc+0x1c>
  return 0;
    80000f02:	4481                	li	s1,0
}
    80000f04:	8526                	mv	a0,s1
    80000f06:	60e2                	ld	ra,24(sp)
    80000f08:	6442                	ld	s0,16(sp)
    80000f0a:	64a2                	ld	s1,8(sp)
    80000f0c:	6902                	ld	s2,0(sp)
    80000f0e:	6105                	addi	sp,sp,32
    80000f10:	8082                	ret
  p->pid = allocpid();
    80000f12:	e65ff0ef          	jal	ra,80000d76 <allocpid>
    80000f16:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f18:	4785                	li	a5,1
    80000f1a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f1c:	9e2ff0ef          	jal	ra,800000fe <kalloc>
    80000f20:	892a                	mv	s2,a0
    80000f22:	eca8                	sd	a0,88(s1)
    80000f24:	c905                	beqz	a0,80000f54 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f26:	8526                	mv	a0,s1
    80000f28:	e8dff0ef          	jal	ra,80000db4 <proc_pagetable>
    80000f2c:	892a                	mv	s2,a0
    80000f2e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f30:	c915                	beqz	a0,80000f64 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f32:	07000613          	li	a2,112
    80000f36:	4581                	li	a1,0
    80000f38:	06048513          	addi	a0,s1,96
    80000f3c:	a12ff0ef          	jal	ra,8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f40:	00000797          	auipc	a5,0x0
    80000f44:	dfc78793          	addi	a5,a5,-516 # 80000d3c <forkret>
    80000f48:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f4a:	60bc                	ld	a5,64(s1)
    80000f4c:	6705                	lui	a4,0x1
    80000f4e:	97ba                	add	a5,a5,a4
    80000f50:	f4bc                	sd	a5,104(s1)
  return p;
    80000f52:	bf4d                	j	80000f04 <allocproc+0x36>
    freeproc(p);
    80000f54:	8526                	mv	a0,s1
    80000f56:	f29ff0ef          	jal	ra,80000e7e <freeproc>
    release(&p->lock);
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	04f040ef          	jal	ra,800057aa <release>
    return 0;
    80000f60:	84ca                	mv	s1,s2
    80000f62:	b74d                	j	80000f04 <allocproc+0x36>
    freeproc(p);
    80000f64:	8526                	mv	a0,s1
    80000f66:	f19ff0ef          	jal	ra,80000e7e <freeproc>
    release(&p->lock);
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	03f040ef          	jal	ra,800057aa <release>
    return 0;
    80000f70:	84ca                	mv	s1,s2
    80000f72:	bf49                	j	80000f04 <allocproc+0x36>

0000000080000f74 <userinit>:
{
    80000f74:	1101                	addi	sp,sp,-32
    80000f76:	ec06                	sd	ra,24(sp)
    80000f78:	e822                	sd	s0,16(sp)
    80000f7a:	e426                	sd	s1,8(sp)
    80000f7c:	1000                	addi	s0,sp,32
  p = allocproc();
    80000f7e:	f51ff0ef          	jal	ra,80000ece <allocproc>
    80000f82:	84aa                	mv	s1,a0
  initproc = p;
    80000f84:	00007797          	auipc	a5,0x7
    80000f88:	96a7b623          	sd	a0,-1684(a5) # 800078f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000f8c:	03400613          	li	a2,52
    80000f90:	00007597          	auipc	a1,0x7
    80000f94:	8f058593          	addi	a1,a1,-1808 # 80007880 <initcode>
    80000f98:	6928                	ld	a0,80(a0)
    80000f9a:	f80ff0ef          	jal	ra,8000071a <uvmfirst>
  p->sz = PGSIZE;
    80000f9e:	6785                	lui	a5,0x1
    80000fa0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000fa2:	6cb8                	ld	a4,88(s1)
    80000fa4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000fa8:	6cb8                	ld	a4,88(s1)
    80000faa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000fac:	4641                	li	a2,16
    80000fae:	00006597          	auipc	a1,0x6
    80000fb2:	21258593          	addi	a1,a1,530 # 800071c0 <etext+0x1c0>
    80000fb6:	15848513          	addi	a0,s1,344
    80000fba:	adaff0ef          	jal	ra,80000294 <safestrcpy>
  p->cwd = namei("/");
    80000fbe:	00006517          	auipc	a0,0x6
    80000fc2:	21250513          	addi	a0,a0,530 # 800071d0 <etext+0x1d0>
    80000fc6:	53d010ef          	jal	ra,80002d02 <namei>
    80000fca:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80000fce:	478d                	li	a5,3
    80000fd0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	7d6040ef          	jal	ra,800057aa <release>
}
    80000fd8:	60e2                	ld	ra,24(sp)
    80000fda:	6442                	ld	s0,16(sp)
    80000fdc:	64a2                	ld	s1,8(sp)
    80000fde:	6105                	addi	sp,sp,32
    80000fe0:	8082                	ret

0000000080000fe2 <growproc>:
{
    80000fe2:	1101                	addi	sp,sp,-32
    80000fe4:	ec06                	sd	ra,24(sp)
    80000fe6:	e822                	sd	s0,16(sp)
    80000fe8:	e426                	sd	s1,8(sp)
    80000fea:	e04a                	sd	s2,0(sp)
    80000fec:	1000                	addi	s0,sp,32
    80000fee:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80000ff0:	d1dff0ef          	jal	ra,80000d0c <myproc>
    80000ff4:	84aa                	mv	s1,a0
  sz = p->sz;
    80000ff6:	652c                	ld	a1,72(a0)
  if(n > 0){
    80000ff8:	01204c63          	bgtz	s2,80001010 <growproc+0x2e>
  } else if(n < 0){
    80000ffc:	02094463          	bltz	s2,80001024 <growproc+0x42>
  p->sz = sz;
    80001000:	e4ac                	sd	a1,72(s1)
  return 0;
    80001002:	4501                	li	a0,0
}
    80001004:	60e2                	ld	ra,24(sp)
    80001006:	6442                	ld	s0,16(sp)
    80001008:	64a2                	ld	s1,8(sp)
    8000100a:	6902                	ld	s2,0(sp)
    8000100c:	6105                	addi	sp,sp,32
    8000100e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001010:	4691                	li	a3,4
    80001012:	00b90633          	add	a2,s2,a1
    80001016:	6928                	ld	a0,80(a0)
    80001018:	fa4ff0ef          	jal	ra,800007bc <uvmalloc>
    8000101c:	85aa                	mv	a1,a0
    8000101e:	f16d                	bnez	a0,80001000 <growproc+0x1e>
      return -1;
    80001020:	557d                	li	a0,-1
    80001022:	b7cd                	j	80001004 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001024:	00b90633          	add	a2,s2,a1
    80001028:	6928                	ld	a0,80(a0)
    8000102a:	f4eff0ef          	jal	ra,80000778 <uvmdealloc>
    8000102e:	85aa                	mv	a1,a0
    80001030:	bfc1                	j	80001000 <growproc+0x1e>

0000000080001032 <fork>:
{
    80001032:	7139                	addi	sp,sp,-64
    80001034:	fc06                	sd	ra,56(sp)
    80001036:	f822                	sd	s0,48(sp)
    80001038:	f426                	sd	s1,40(sp)
    8000103a:	f04a                	sd	s2,32(sp)
    8000103c:	ec4e                	sd	s3,24(sp)
    8000103e:	e852                	sd	s4,16(sp)
    80001040:	e456                	sd	s5,8(sp)
    80001042:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001044:	cc9ff0ef          	jal	ra,80000d0c <myproc>
    80001048:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000104a:	e85ff0ef          	jal	ra,80000ece <allocproc>
    8000104e:	0e050663          	beqz	a0,8000113a <fork+0x108>
    80001052:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001054:	048ab603          	ld	a2,72(s5)
    80001058:	692c                	ld	a1,80(a0)
    8000105a:	050ab503          	ld	a0,80(s5)
    8000105e:	88bff0ef          	jal	ra,800008e8 <uvmcopy>
    80001062:	04054863          	bltz	a0,800010b2 <fork+0x80>
  np->sz = p->sz;
    80001066:	048ab783          	ld	a5,72(s5)
    8000106a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000106e:	058ab683          	ld	a3,88(s5)
    80001072:	87b6                	mv	a5,a3
    80001074:	058a3703          	ld	a4,88(s4)
    80001078:	12068693          	addi	a3,a3,288
    8000107c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001080:	6788                	ld	a0,8(a5)
    80001082:	6b8c                	ld	a1,16(a5)
    80001084:	6f90                	ld	a2,24(a5)
    80001086:	01073023          	sd	a6,0(a4)
    8000108a:	e708                	sd	a0,8(a4)
    8000108c:	eb0c                	sd	a1,16(a4)
    8000108e:	ef10                	sd	a2,24(a4)
    80001090:	02078793          	addi	a5,a5,32
    80001094:	02070713          	addi	a4,a4,32
    80001098:	fed792e3          	bne	a5,a3,8000107c <fork+0x4a>
  np->trapframe->a0 = 0;
    8000109c:	058a3783          	ld	a5,88(s4)
    800010a0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010a4:	0d0a8493          	addi	s1,s5,208
    800010a8:	0d0a0913          	addi	s2,s4,208
    800010ac:	150a8993          	addi	s3,s5,336
    800010b0:	a829                	j	800010ca <fork+0x98>
    freeproc(np);
    800010b2:	8552                	mv	a0,s4
    800010b4:	dcbff0ef          	jal	ra,80000e7e <freeproc>
    release(&np->lock);
    800010b8:	8552                	mv	a0,s4
    800010ba:	6f0040ef          	jal	ra,800057aa <release>
    return -1;
    800010be:	597d                	li	s2,-1
    800010c0:	a09d                	j	80001126 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    800010c2:	04a1                	addi	s1,s1,8
    800010c4:	0921                	addi	s2,s2,8
    800010c6:	01348963          	beq	s1,s3,800010d8 <fork+0xa6>
    if(p->ofile[i])
    800010ca:	6088                	ld	a0,0(s1)
    800010cc:	d97d                	beqz	a0,800010c2 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    800010ce:	1e2020ef          	jal	ra,800032b0 <filedup>
    800010d2:	00a93023          	sd	a0,0(s2)
    800010d6:	b7f5                	j	800010c2 <fork+0x90>
  np->cwd = idup(p->cwd);
    800010d8:	150ab503          	ld	a0,336(s5)
    800010dc:	536010ef          	jal	ra,80002612 <idup>
    800010e0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800010e4:	4641                	li	a2,16
    800010e6:	158a8593          	addi	a1,s5,344
    800010ea:	158a0513          	addi	a0,s4,344
    800010ee:	9a6ff0ef          	jal	ra,80000294 <safestrcpy>
  pid = np->pid;
    800010f2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800010f6:	8552                	mv	a0,s4
    800010f8:	6b2040ef          	jal	ra,800057aa <release>
  acquire(&wait_lock);
    800010fc:	00007497          	auipc	s1,0x7
    80001100:	84c48493          	addi	s1,s1,-1972 # 80007948 <wait_lock>
    80001104:	8526                	mv	a0,s1
    80001106:	60c040ef          	jal	ra,80005712 <acquire>
  np->parent = p;
    8000110a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	69a040ef          	jal	ra,800057aa <release>
  acquire(&np->lock);
    80001114:	8552                	mv	a0,s4
    80001116:	5fc040ef          	jal	ra,80005712 <acquire>
  np->state = RUNNABLE;
    8000111a:	478d                	li	a5,3
    8000111c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001120:	8552                	mv	a0,s4
    80001122:	688040ef          	jal	ra,800057aa <release>
}
    80001126:	854a                	mv	a0,s2
    80001128:	70e2                	ld	ra,56(sp)
    8000112a:	7442                	ld	s0,48(sp)
    8000112c:	74a2                	ld	s1,40(sp)
    8000112e:	7902                	ld	s2,32(sp)
    80001130:	69e2                	ld	s3,24(sp)
    80001132:	6a42                	ld	s4,16(sp)
    80001134:	6aa2                	ld	s5,8(sp)
    80001136:	6121                	addi	sp,sp,64
    80001138:	8082                	ret
    return -1;
    8000113a:	597d                	li	s2,-1
    8000113c:	b7ed                	j	80001126 <fork+0xf4>

000000008000113e <scheduler>:
{
    8000113e:	711d                	addi	sp,sp,-96
    80001140:	ec86                	sd	ra,88(sp)
    80001142:	e8a2                	sd	s0,80(sp)
    80001144:	e4a6                	sd	s1,72(sp)
    80001146:	e0ca                	sd	s2,64(sp)
    80001148:	fc4e                	sd	s3,56(sp)
    8000114a:	f852                	sd	s4,48(sp)
    8000114c:	f456                	sd	s5,40(sp)
    8000114e:	f05a                	sd	s6,32(sp)
    80001150:	ec5e                	sd	s7,24(sp)
    80001152:	e862                	sd	s8,16(sp)
    80001154:	e466                	sd	s9,8(sp)
    80001156:	1080                	addi	s0,sp,96
    80001158:	8792                	mv	a5,tp
  int id = r_tp();
    8000115a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000115c:	00779b93          	slli	s7,a5,0x7
    80001160:	00006717          	auipc	a4,0x6
    80001164:	7d070713          	addi	a4,a4,2000 # 80007930 <pid_lock>
    80001168:	975e                	add	a4,a4,s7
    8000116a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000116e:	00006717          	auipc	a4,0x6
    80001172:	7fa70713          	addi	a4,a4,2042 # 80007968 <cpus+0x8>
    80001176:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001178:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    8000117a:	4a8d                	li	s5,3
        c->proc = p;
    8000117c:	079e                	slli	a5,a5,0x7
    8000117e:	00006b17          	auipc	s6,0x6
    80001182:	7b2b0b13          	addi	s6,s6,1970 # 80007930 <pid_lock>
    80001186:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001188:	00008a17          	auipc	s4,0x8
    8000118c:	9e8a0a13          	addi	s4,s4,-1560 # 80008b70 <tickslock>
    80001190:	a0a9                	j	800011da <scheduler+0x9c>
      release(&p->lock);
    80001192:	8526                	mv	a0,s1
    80001194:	616040ef          	jal	ra,800057aa <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001198:	16848493          	addi	s1,s1,360
    8000119c:	03448663          	beq	s1,s4,800011c8 <scheduler+0x8a>
      acquire(&p->lock);
    800011a0:	8526                	mv	a0,s1
    800011a2:	570040ef          	jal	ra,80005712 <acquire>
      if(p->state != UNUSED) {
    800011a6:	4c9c                	lw	a5,24(s1)
    800011a8:	d7ed                	beqz	a5,80001192 <scheduler+0x54>
        nproc++;
    800011aa:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    800011ac:	ff5793e3          	bne	a5,s5,80001192 <scheduler+0x54>
        p->state = RUNNING;
    800011b0:	0194ac23          	sw	s9,24(s1)
        c->proc = p;
    800011b4:	029b3823          	sd	s1,48(s6)
        swtch(&c->context, &p->context);
    800011b8:	06048593          	addi	a1,s1,96
    800011bc:	855e                	mv	a0,s7
    800011be:	5b0000ef          	jal	ra,8000176e <swtch>
        c->proc = 0;
    800011c2:	020b3823          	sd	zero,48(s6)
    800011c6:	b7f1                	j	80001192 <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    800011c8:	4789                	li	a5,2
    800011ca:	0137c863          	blt	a5,s3,800011da <scheduler+0x9c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011d2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011d6:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011de:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011e2:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    800011e6:	89e2                	mv	s3,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e8:	00007497          	auipc	s1,0x7
    800011ec:	b7848493          	addi	s1,s1,-1160 # 80007d60 <proc>
        p->state = RUNNING;
    800011f0:	4c91                	li	s9,4
    800011f2:	b77d                	j	800011a0 <scheduler+0x62>

00000000800011f4 <sched>:
{
    800011f4:	7179                	addi	sp,sp,-48
    800011f6:	f406                	sd	ra,40(sp)
    800011f8:	f022                	sd	s0,32(sp)
    800011fa:	ec26                	sd	s1,24(sp)
    800011fc:	e84a                	sd	s2,16(sp)
    800011fe:	e44e                	sd	s3,8(sp)
    80001200:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001202:	b0bff0ef          	jal	ra,80000d0c <myproc>
    80001206:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001208:	4a0040ef          	jal	ra,800056a8 <holding>
    8000120c:	c92d                	beqz	a0,8000127e <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000120e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001210:	2781                	sext.w	a5,a5
    80001212:	079e                	slli	a5,a5,0x7
    80001214:	00006717          	auipc	a4,0x6
    80001218:	71c70713          	addi	a4,a4,1820 # 80007930 <pid_lock>
    8000121c:	97ba                	add	a5,a5,a4
    8000121e:	0a87a703          	lw	a4,168(a5)
    80001222:	4785                	li	a5,1
    80001224:	06f71363          	bne	a4,a5,8000128a <sched+0x96>
  if(p->state == RUNNING)
    80001228:	4c98                	lw	a4,24(s1)
    8000122a:	4791                	li	a5,4
    8000122c:	06f70563          	beq	a4,a5,80001296 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001230:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001234:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001236:	e7b5                	bnez	a5,800012a2 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001238:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000123a:	00006917          	auipc	s2,0x6
    8000123e:	6f690913          	addi	s2,s2,1782 # 80007930 <pid_lock>
    80001242:	2781                	sext.w	a5,a5
    80001244:	079e                	slli	a5,a5,0x7
    80001246:	97ca                	add	a5,a5,s2
    80001248:	0ac7a983          	lw	s3,172(a5)
    8000124c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000124e:	2781                	sext.w	a5,a5
    80001250:	079e                	slli	a5,a5,0x7
    80001252:	00006597          	auipc	a1,0x6
    80001256:	71658593          	addi	a1,a1,1814 # 80007968 <cpus+0x8>
    8000125a:	95be                	add	a1,a1,a5
    8000125c:	06048513          	addi	a0,s1,96
    80001260:	50e000ef          	jal	ra,8000176e <swtch>
    80001264:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001266:	2781                	sext.w	a5,a5
    80001268:	079e                	slli	a5,a5,0x7
    8000126a:	993e                	add	s2,s2,a5
    8000126c:	0b392623          	sw	s3,172(s2)
}
    80001270:	70a2                	ld	ra,40(sp)
    80001272:	7402                	ld	s0,32(sp)
    80001274:	64e2                	ld	s1,24(sp)
    80001276:	6942                	ld	s2,16(sp)
    80001278:	69a2                	ld	s3,8(sp)
    8000127a:	6145                	addi	sp,sp,48
    8000127c:	8082                	ret
    panic("sched p->lock");
    8000127e:	00006517          	auipc	a0,0x6
    80001282:	f5a50513          	addi	a0,a0,-166 # 800071d8 <etext+0x1d8>
    80001286:	17c040ef          	jal	ra,80005402 <panic>
    panic("sched locks");
    8000128a:	00006517          	auipc	a0,0x6
    8000128e:	f5e50513          	addi	a0,a0,-162 # 800071e8 <etext+0x1e8>
    80001292:	170040ef          	jal	ra,80005402 <panic>
    panic("sched running");
    80001296:	00006517          	auipc	a0,0x6
    8000129a:	f6250513          	addi	a0,a0,-158 # 800071f8 <etext+0x1f8>
    8000129e:	164040ef          	jal	ra,80005402 <panic>
    panic("sched interruptible");
    800012a2:	00006517          	auipc	a0,0x6
    800012a6:	f6650513          	addi	a0,a0,-154 # 80007208 <etext+0x208>
    800012aa:	158040ef          	jal	ra,80005402 <panic>

00000000800012ae <yield>:
{
    800012ae:	1101                	addi	sp,sp,-32
    800012b0:	ec06                	sd	ra,24(sp)
    800012b2:	e822                	sd	s0,16(sp)
    800012b4:	e426                	sd	s1,8(sp)
    800012b6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800012b8:	a55ff0ef          	jal	ra,80000d0c <myproc>
    800012bc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800012be:	454040ef          	jal	ra,80005712 <acquire>
  p->state = RUNNABLE;
    800012c2:	478d                	li	a5,3
    800012c4:	cc9c                	sw	a5,24(s1)
  sched();
    800012c6:	f2fff0ef          	jal	ra,800011f4 <sched>
  release(&p->lock);
    800012ca:	8526                	mv	a0,s1
    800012cc:	4de040ef          	jal	ra,800057aa <release>
}
    800012d0:	60e2                	ld	ra,24(sp)
    800012d2:	6442                	ld	s0,16(sp)
    800012d4:	64a2                	ld	s1,8(sp)
    800012d6:	6105                	addi	sp,sp,32
    800012d8:	8082                	ret

00000000800012da <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800012da:	7179                	addi	sp,sp,-48
    800012dc:	f406                	sd	ra,40(sp)
    800012de:	f022                	sd	s0,32(sp)
    800012e0:	ec26                	sd	s1,24(sp)
    800012e2:	e84a                	sd	s2,16(sp)
    800012e4:	e44e                	sd	s3,8(sp)
    800012e6:	1800                	addi	s0,sp,48
    800012e8:	89aa                	mv	s3,a0
    800012ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800012ec:	a21ff0ef          	jal	ra,80000d0c <myproc>
    800012f0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800012f2:	420040ef          	jal	ra,80005712 <acquire>
  release(lk);
    800012f6:	854a                	mv	a0,s2
    800012f8:	4b2040ef          	jal	ra,800057aa <release>

  // Go to sleep.
  p->chan = chan;
    800012fc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001300:	4789                	li	a5,2
    80001302:	cc9c                	sw	a5,24(s1)

  sched();
    80001304:	ef1ff0ef          	jal	ra,800011f4 <sched>

  // Tidy up.
  p->chan = 0;
    80001308:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	49c040ef          	jal	ra,800057aa <release>
  acquire(lk);
    80001312:	854a                	mv	a0,s2
    80001314:	3fe040ef          	jal	ra,80005712 <acquire>
}
    80001318:	70a2                	ld	ra,40(sp)
    8000131a:	7402                	ld	s0,32(sp)
    8000131c:	64e2                	ld	s1,24(sp)
    8000131e:	6942                	ld	s2,16(sp)
    80001320:	69a2                	ld	s3,8(sp)
    80001322:	6145                	addi	sp,sp,48
    80001324:	8082                	ret

0000000080001326 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001326:	7139                	addi	sp,sp,-64
    80001328:	fc06                	sd	ra,56(sp)
    8000132a:	f822                	sd	s0,48(sp)
    8000132c:	f426                	sd	s1,40(sp)
    8000132e:	f04a                	sd	s2,32(sp)
    80001330:	ec4e                	sd	s3,24(sp)
    80001332:	e852                	sd	s4,16(sp)
    80001334:	e456                	sd	s5,8(sp)
    80001336:	0080                	addi	s0,sp,64
    80001338:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000133a:	00007497          	auipc	s1,0x7
    8000133e:	a2648493          	addi	s1,s1,-1498 # 80007d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001342:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001344:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001346:	00008917          	auipc	s2,0x8
    8000134a:	82a90913          	addi	s2,s2,-2006 # 80008b70 <tickslock>
    8000134e:	a801                	j	8000135e <wakeup+0x38>
      }
      release(&p->lock);
    80001350:	8526                	mv	a0,s1
    80001352:	458040ef          	jal	ra,800057aa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001356:	16848493          	addi	s1,s1,360
    8000135a:	03248263          	beq	s1,s2,8000137e <wakeup+0x58>
    if(p != myproc()){
    8000135e:	9afff0ef          	jal	ra,80000d0c <myproc>
    80001362:	fea48ae3          	beq	s1,a0,80001356 <wakeup+0x30>
      acquire(&p->lock);
    80001366:	8526                	mv	a0,s1
    80001368:	3aa040ef          	jal	ra,80005712 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000136c:	4c9c                	lw	a5,24(s1)
    8000136e:	ff3791e3          	bne	a5,s3,80001350 <wakeup+0x2a>
    80001372:	709c                	ld	a5,32(s1)
    80001374:	fd479ee3          	bne	a5,s4,80001350 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001378:	0154ac23          	sw	s5,24(s1)
    8000137c:	bfd1                	j	80001350 <wakeup+0x2a>
    }
  }
}
    8000137e:	70e2                	ld	ra,56(sp)
    80001380:	7442                	ld	s0,48(sp)
    80001382:	74a2                	ld	s1,40(sp)
    80001384:	7902                	ld	s2,32(sp)
    80001386:	69e2                	ld	s3,24(sp)
    80001388:	6a42                	ld	s4,16(sp)
    8000138a:	6aa2                	ld	s5,8(sp)
    8000138c:	6121                	addi	sp,sp,64
    8000138e:	8082                	ret

0000000080001390 <reparent>:
{
    80001390:	7179                	addi	sp,sp,-48
    80001392:	f406                	sd	ra,40(sp)
    80001394:	f022                	sd	s0,32(sp)
    80001396:	ec26                	sd	s1,24(sp)
    80001398:	e84a                	sd	s2,16(sp)
    8000139a:	e44e                	sd	s3,8(sp)
    8000139c:	e052                	sd	s4,0(sp)
    8000139e:	1800                	addi	s0,sp,48
    800013a0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013a2:	00007497          	auipc	s1,0x7
    800013a6:	9be48493          	addi	s1,s1,-1602 # 80007d60 <proc>
      pp->parent = initproc;
    800013aa:	00006a17          	auipc	s4,0x6
    800013ae:	546a0a13          	addi	s4,s4,1350 # 800078f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013b2:	00007997          	auipc	s3,0x7
    800013b6:	7be98993          	addi	s3,s3,1982 # 80008b70 <tickslock>
    800013ba:	a029                	j	800013c4 <reparent+0x34>
    800013bc:	16848493          	addi	s1,s1,360
    800013c0:	01348b63          	beq	s1,s3,800013d6 <reparent+0x46>
    if(pp->parent == p){
    800013c4:	7c9c                	ld	a5,56(s1)
    800013c6:	ff279be3          	bne	a5,s2,800013bc <reparent+0x2c>
      pp->parent = initproc;
    800013ca:	000a3503          	ld	a0,0(s4)
    800013ce:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800013d0:	f57ff0ef          	jal	ra,80001326 <wakeup>
    800013d4:	b7e5                	j	800013bc <reparent+0x2c>
}
    800013d6:	70a2                	ld	ra,40(sp)
    800013d8:	7402                	ld	s0,32(sp)
    800013da:	64e2                	ld	s1,24(sp)
    800013dc:	6942                	ld	s2,16(sp)
    800013de:	69a2                	ld	s3,8(sp)
    800013e0:	6a02                	ld	s4,0(sp)
    800013e2:	6145                	addi	sp,sp,48
    800013e4:	8082                	ret

00000000800013e6 <exit>:
{
    800013e6:	7179                	addi	sp,sp,-48
    800013e8:	f406                	sd	ra,40(sp)
    800013ea:	f022                	sd	s0,32(sp)
    800013ec:	ec26                	sd	s1,24(sp)
    800013ee:	e84a                	sd	s2,16(sp)
    800013f0:	e44e                	sd	s3,8(sp)
    800013f2:	e052                	sd	s4,0(sp)
    800013f4:	1800                	addi	s0,sp,48
    800013f6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800013f8:	915ff0ef          	jal	ra,80000d0c <myproc>
    800013fc:	89aa                	mv	s3,a0
  if(p == initproc)
    800013fe:	00006797          	auipc	a5,0x6
    80001402:	4f27b783          	ld	a5,1266(a5) # 800078f0 <initproc>
    80001406:	0d050493          	addi	s1,a0,208
    8000140a:	15050913          	addi	s2,a0,336
    8000140e:	00a79f63          	bne	a5,a0,8000142c <exit+0x46>
    panic("init exiting");
    80001412:	00006517          	auipc	a0,0x6
    80001416:	e0e50513          	addi	a0,a0,-498 # 80007220 <etext+0x220>
    8000141a:	7e9030ef          	jal	ra,80005402 <panic>
      fileclose(f);
    8000141e:	6d9010ef          	jal	ra,800032f6 <fileclose>
      p->ofile[fd] = 0;
    80001422:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001426:	04a1                	addi	s1,s1,8
    80001428:	01248563          	beq	s1,s2,80001432 <exit+0x4c>
    if(p->ofile[fd]){
    8000142c:	6088                	ld	a0,0(s1)
    8000142e:	f965                	bnez	a0,8000141e <exit+0x38>
    80001430:	bfdd                	j	80001426 <exit+0x40>
  begin_op();
    80001432:	2ad010ef          	jal	ra,80002ede <begin_op>
  iput(p->cwd);
    80001436:	1509b503          	ld	a0,336(s3)
    8000143a:	38c010ef          	jal	ra,800027c6 <iput>
  end_op();
    8000143e:	30f010ef          	jal	ra,80002f4c <end_op>
  p->cwd = 0;
    80001442:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001446:	00006497          	auipc	s1,0x6
    8000144a:	50248493          	addi	s1,s1,1282 # 80007948 <wait_lock>
    8000144e:	8526                	mv	a0,s1
    80001450:	2c2040ef          	jal	ra,80005712 <acquire>
  reparent(p);
    80001454:	854e                	mv	a0,s3
    80001456:	f3bff0ef          	jal	ra,80001390 <reparent>
  wakeup(p->parent);
    8000145a:	0389b503          	ld	a0,56(s3)
    8000145e:	ec9ff0ef          	jal	ra,80001326 <wakeup>
  acquire(&p->lock);
    80001462:	854e                	mv	a0,s3
    80001464:	2ae040ef          	jal	ra,80005712 <acquire>
  p->xstate = status;
    80001468:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000146c:	4795                	li	a5,5
    8000146e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001472:	8526                	mv	a0,s1
    80001474:	336040ef          	jal	ra,800057aa <release>
  sched();
    80001478:	d7dff0ef          	jal	ra,800011f4 <sched>
  panic("zombie exit");
    8000147c:	00006517          	auipc	a0,0x6
    80001480:	db450513          	addi	a0,a0,-588 # 80007230 <etext+0x230>
    80001484:	77f030ef          	jal	ra,80005402 <panic>

0000000080001488 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001488:	7179                	addi	sp,sp,-48
    8000148a:	f406                	sd	ra,40(sp)
    8000148c:	f022                	sd	s0,32(sp)
    8000148e:	ec26                	sd	s1,24(sp)
    80001490:	e84a                	sd	s2,16(sp)
    80001492:	e44e                	sd	s3,8(sp)
    80001494:	1800                	addi	s0,sp,48
    80001496:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001498:	00007497          	auipc	s1,0x7
    8000149c:	8c848493          	addi	s1,s1,-1848 # 80007d60 <proc>
    800014a0:	00007997          	auipc	s3,0x7
    800014a4:	6d098993          	addi	s3,s3,1744 # 80008b70 <tickslock>
    acquire(&p->lock);
    800014a8:	8526                	mv	a0,s1
    800014aa:	268040ef          	jal	ra,80005712 <acquire>
    if(p->pid == pid){
    800014ae:	589c                	lw	a5,48(s1)
    800014b0:	03278163          	beq	a5,s2,800014d2 <kill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014b4:	8526                	mv	a0,s1
    800014b6:	2f4040ef          	jal	ra,800057aa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800014ba:	16848493          	addi	s1,s1,360
    800014be:	ff3495e3          	bne	s1,s3,800014a8 <kill+0x20>
  }
  return -1;
    800014c2:	557d                	li	a0,-1
}
    800014c4:	70a2                	ld	ra,40(sp)
    800014c6:	7402                	ld	s0,32(sp)
    800014c8:	64e2                	ld	s1,24(sp)
    800014ca:	6942                	ld	s2,16(sp)
    800014cc:	69a2                	ld	s3,8(sp)
    800014ce:	6145                	addi	sp,sp,48
    800014d0:	8082                	ret
      p->killed = 1;
    800014d2:	4785                	li	a5,1
    800014d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800014d6:	4c98                	lw	a4,24(s1)
    800014d8:	4789                	li	a5,2
    800014da:	00f70763          	beq	a4,a5,800014e8 <kill+0x60>
      release(&p->lock);
    800014de:	8526                	mv	a0,s1
    800014e0:	2ca040ef          	jal	ra,800057aa <release>
      return 0;
    800014e4:	4501                	li	a0,0
    800014e6:	bff9                	j	800014c4 <kill+0x3c>
        p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
    800014ec:	bfcd                	j	800014de <kill+0x56>

00000000800014ee <setkilled>:

void
setkilled(struct proc *p)
{
    800014ee:	1101                	addi	sp,sp,-32
    800014f0:	ec06                	sd	ra,24(sp)
    800014f2:	e822                	sd	s0,16(sp)
    800014f4:	e426                	sd	s1,8(sp)
    800014f6:	1000                	addi	s0,sp,32
    800014f8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014fa:	218040ef          	jal	ra,80005712 <acquire>
  p->killed = 1;
    800014fe:	4785                	li	a5,1
    80001500:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001502:	8526                	mv	a0,s1
    80001504:	2a6040ef          	jal	ra,800057aa <release>
}
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <killed>:

int
killed(struct proc *p)
{
    80001512:	1101                	addi	sp,sp,-32
    80001514:	ec06                	sd	ra,24(sp)
    80001516:	e822                	sd	s0,16(sp)
    80001518:	e426                	sd	s1,8(sp)
    8000151a:	e04a                	sd	s2,0(sp)
    8000151c:	1000                	addi	s0,sp,32
    8000151e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001520:	1f2040ef          	jal	ra,80005712 <acquire>
  k = p->killed;
    80001524:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001528:	8526                	mv	a0,s1
    8000152a:	280040ef          	jal	ra,800057aa <release>
  return k;
}
    8000152e:	854a                	mv	a0,s2
    80001530:	60e2                	ld	ra,24(sp)
    80001532:	6442                	ld	s0,16(sp)
    80001534:	64a2                	ld	s1,8(sp)
    80001536:	6902                	ld	s2,0(sp)
    80001538:	6105                	addi	sp,sp,32
    8000153a:	8082                	ret

000000008000153c <wait>:
{
    8000153c:	715d                	addi	sp,sp,-80
    8000153e:	e486                	sd	ra,72(sp)
    80001540:	e0a2                	sd	s0,64(sp)
    80001542:	fc26                	sd	s1,56(sp)
    80001544:	f84a                	sd	s2,48(sp)
    80001546:	f44e                	sd	s3,40(sp)
    80001548:	f052                	sd	s4,32(sp)
    8000154a:	ec56                	sd	s5,24(sp)
    8000154c:	e85a                	sd	s6,16(sp)
    8000154e:	e45e                	sd	s7,8(sp)
    80001550:	e062                	sd	s8,0(sp)
    80001552:	0880                	addi	s0,sp,80
    80001554:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001556:	fb6ff0ef          	jal	ra,80000d0c <myproc>
    8000155a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000155c:	00006517          	auipc	a0,0x6
    80001560:	3ec50513          	addi	a0,a0,1004 # 80007948 <wait_lock>
    80001564:	1ae040ef          	jal	ra,80005712 <acquire>
    havekids = 0;
    80001568:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000156a:	4a15                	li	s4,5
        havekids = 1;
    8000156c:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000156e:	00007997          	auipc	s3,0x7
    80001572:	60298993          	addi	s3,s3,1538 # 80008b70 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001576:	00006c17          	auipc	s8,0x6
    8000157a:	3d2c0c13          	addi	s8,s8,978 # 80007948 <wait_lock>
    havekids = 0;
    8000157e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001580:	00006497          	auipc	s1,0x6
    80001584:	7e048493          	addi	s1,s1,2016 # 80007d60 <proc>
    80001588:	a899                	j	800015de <wait+0xa2>
          pid = pp->pid;
    8000158a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000158e:	000a8c63          	beqz	s5,800015a6 <wait+0x6a>
    80001592:	4691                	li	a3,4
    80001594:	02c48613          	addi	a2,s1,44
    80001598:	85d6                	mv	a1,s5
    8000159a:	05093503          	ld	a0,80(s2)
    8000159e:	c26ff0ef          	jal	ra,800009c4 <copyout>
    800015a2:	00054f63          	bltz	a0,800015c0 <wait+0x84>
          freeproc(pp);
    800015a6:	8526                	mv	a0,s1
    800015a8:	8d7ff0ef          	jal	ra,80000e7e <freeproc>
          release(&pp->lock);
    800015ac:	8526                	mv	a0,s1
    800015ae:	1fc040ef          	jal	ra,800057aa <release>
          release(&wait_lock);
    800015b2:	00006517          	auipc	a0,0x6
    800015b6:	39650513          	addi	a0,a0,918 # 80007948 <wait_lock>
    800015ba:	1f0040ef          	jal	ra,800057aa <release>
          return pid;
    800015be:	a891                	j	80001612 <wait+0xd6>
            release(&pp->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	1e8040ef          	jal	ra,800057aa <release>
            release(&wait_lock);
    800015c6:	00006517          	auipc	a0,0x6
    800015ca:	38250513          	addi	a0,a0,898 # 80007948 <wait_lock>
    800015ce:	1dc040ef          	jal	ra,800057aa <release>
            return -1;
    800015d2:	59fd                	li	s3,-1
    800015d4:	a83d                	j	80001612 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015d6:	16848493          	addi	s1,s1,360
    800015da:	03348063          	beq	s1,s3,800015fa <wait+0xbe>
      if(pp->parent == p){
    800015de:	7c9c                	ld	a5,56(s1)
    800015e0:	ff279be3          	bne	a5,s2,800015d6 <wait+0x9a>
        acquire(&pp->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	12c040ef          	jal	ra,80005712 <acquire>
        if(pp->state == ZOMBIE){
    800015ea:	4c9c                	lw	a5,24(s1)
    800015ec:	f9478fe3          	beq	a5,s4,8000158a <wait+0x4e>
        release(&pp->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	1b8040ef          	jal	ra,800057aa <release>
        havekids = 1;
    800015f6:	875a                	mv	a4,s6
    800015f8:	bff9                	j	800015d6 <wait+0x9a>
    if(!havekids || killed(p)){
    800015fa:	c709                	beqz	a4,80001604 <wait+0xc8>
    800015fc:	854a                	mv	a0,s2
    800015fe:	f15ff0ef          	jal	ra,80001512 <killed>
    80001602:	c50d                	beqz	a0,8000162c <wait+0xf0>
      release(&wait_lock);
    80001604:	00006517          	auipc	a0,0x6
    80001608:	34450513          	addi	a0,a0,836 # 80007948 <wait_lock>
    8000160c:	19e040ef          	jal	ra,800057aa <release>
      return -1;
    80001610:	59fd                	li	s3,-1
}
    80001612:	854e                	mv	a0,s3
    80001614:	60a6                	ld	ra,72(sp)
    80001616:	6406                	ld	s0,64(sp)
    80001618:	74e2                	ld	s1,56(sp)
    8000161a:	7942                	ld	s2,48(sp)
    8000161c:	79a2                	ld	s3,40(sp)
    8000161e:	7a02                	ld	s4,32(sp)
    80001620:	6ae2                	ld	s5,24(sp)
    80001622:	6b42                	ld	s6,16(sp)
    80001624:	6ba2                	ld	s7,8(sp)
    80001626:	6c02                	ld	s8,0(sp)
    80001628:	6161                	addi	sp,sp,80
    8000162a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000162c:	85e2                	mv	a1,s8
    8000162e:	854a                	mv	a0,s2
    80001630:	cabff0ef          	jal	ra,800012da <sleep>
    havekids = 0;
    80001634:	b7a9                	j	8000157e <wait+0x42>

0000000080001636 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001636:	7179                	addi	sp,sp,-48
    80001638:	f406                	sd	ra,40(sp)
    8000163a:	f022                	sd	s0,32(sp)
    8000163c:	ec26                	sd	s1,24(sp)
    8000163e:	e84a                	sd	s2,16(sp)
    80001640:	e44e                	sd	s3,8(sp)
    80001642:	e052                	sd	s4,0(sp)
    80001644:	1800                	addi	s0,sp,48
    80001646:	84aa                	mv	s1,a0
    80001648:	892e                	mv	s2,a1
    8000164a:	89b2                	mv	s3,a2
    8000164c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000164e:	ebeff0ef          	jal	ra,80000d0c <myproc>
  if(user_dst){
    80001652:	cc99                	beqz	s1,80001670 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001654:	86d2                	mv	a3,s4
    80001656:	864e                	mv	a2,s3
    80001658:	85ca                	mv	a1,s2
    8000165a:	6928                	ld	a0,80(a0)
    8000165c:	b68ff0ef          	jal	ra,800009c4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001660:	70a2                	ld	ra,40(sp)
    80001662:	7402                	ld	s0,32(sp)
    80001664:	64e2                	ld	s1,24(sp)
    80001666:	6942                	ld	s2,16(sp)
    80001668:	69a2                	ld	s3,8(sp)
    8000166a:	6a02                	ld	s4,0(sp)
    8000166c:	6145                	addi	sp,sp,48
    8000166e:	8082                	ret
    memmove((char *)dst, src, len);
    80001670:	000a061b          	sext.w	a2,s4
    80001674:	85ce                	mv	a1,s3
    80001676:	854a                	mv	a0,s2
    80001678:	b33fe0ef          	jal	ra,800001aa <memmove>
    return 0;
    8000167c:	8526                	mv	a0,s1
    8000167e:	b7cd                	j	80001660 <either_copyout+0x2a>

0000000080001680 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	e052                	sd	s4,0(sp)
    8000168e:	1800                	addi	s0,sp,48
    80001690:	892a                	mv	s2,a0
    80001692:	84ae                	mv	s1,a1
    80001694:	89b2                	mv	s3,a2
    80001696:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001698:	e74ff0ef          	jal	ra,80000d0c <myproc>
  if(user_src){
    8000169c:	cc99                	beqz	s1,800016ba <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000169e:	86d2                	mv	a3,s4
    800016a0:	864e                	mv	a2,s3
    800016a2:	85ca                	mv	a1,s2
    800016a4:	6928                	ld	a0,80(a0)
    800016a6:	bd6ff0ef          	jal	ra,80000a7c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016aa:	70a2                	ld	ra,40(sp)
    800016ac:	7402                	ld	s0,32(sp)
    800016ae:	64e2                	ld	s1,24(sp)
    800016b0:	6942                	ld	s2,16(sp)
    800016b2:	69a2                	ld	s3,8(sp)
    800016b4:	6a02                	ld	s4,0(sp)
    800016b6:	6145                	addi	sp,sp,48
    800016b8:	8082                	ret
    memmove(dst, (char*)src, len);
    800016ba:	000a061b          	sext.w	a2,s4
    800016be:	85ce                	mv	a1,s3
    800016c0:	854a                	mv	a0,s2
    800016c2:	ae9fe0ef          	jal	ra,800001aa <memmove>
    return 0;
    800016c6:	8526                	mv	a0,s1
    800016c8:	b7cd                	j	800016aa <either_copyin+0x2a>

00000000800016ca <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800016ca:	715d                	addi	sp,sp,-80
    800016cc:	e486                	sd	ra,72(sp)
    800016ce:	e0a2                	sd	s0,64(sp)
    800016d0:	fc26                	sd	s1,56(sp)
    800016d2:	f84a                	sd	s2,48(sp)
    800016d4:	f44e                	sd	s3,40(sp)
    800016d6:	f052                	sd	s4,32(sp)
    800016d8:	ec56                	sd	s5,24(sp)
    800016da:	e85a                	sd	s6,16(sp)
    800016dc:	e45e                	sd	s7,8(sp)
    800016de:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800016e0:	00006517          	auipc	a0,0x6
    800016e4:	96850513          	addi	a0,a0,-1688 # 80007048 <etext+0x48>
    800016e8:	267030ef          	jal	ra,8000514e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800016ec:	00006497          	auipc	s1,0x6
    800016f0:	7cc48493          	addi	s1,s1,1996 # 80007eb8 <proc+0x158>
    800016f4:	00007917          	auipc	s2,0x7
    800016f8:	5d490913          	addi	s2,s2,1492 # 80008cc8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800016fc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800016fe:	00006997          	auipc	s3,0x6
    80001702:	b4298993          	addi	s3,s3,-1214 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001706:	00006a97          	auipc	s5,0x6
    8000170a:	b42a8a93          	addi	s5,s5,-1214 # 80007248 <etext+0x248>
    printf("\n");
    8000170e:	00006a17          	auipc	s4,0x6
    80001712:	93aa0a13          	addi	s4,s4,-1734 # 80007048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001716:	00006b97          	auipc	s7,0x6
    8000171a:	b72b8b93          	addi	s7,s7,-1166 # 80007288 <states.0>
    8000171e:	a829                	j	80001738 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001720:	ed86a583          	lw	a1,-296(a3)
    80001724:	8556                	mv	a0,s5
    80001726:	229030ef          	jal	ra,8000514e <printf>
    printf("\n");
    8000172a:	8552                	mv	a0,s4
    8000172c:	223030ef          	jal	ra,8000514e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001730:	16848493          	addi	s1,s1,360
    80001734:	03248263          	beq	s1,s2,80001758 <procdump+0x8e>
    if(p->state == UNUSED)
    80001738:	86a6                	mv	a3,s1
    8000173a:	ec04a783          	lw	a5,-320(s1)
    8000173e:	dbed                	beqz	a5,80001730 <procdump+0x66>
      state = "???";
    80001740:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001742:	fcfb6fe3          	bltu	s6,a5,80001720 <procdump+0x56>
    80001746:	02079713          	slli	a4,a5,0x20
    8000174a:	01d75793          	srli	a5,a4,0x1d
    8000174e:	97de                	add	a5,a5,s7
    80001750:	6390                	ld	a2,0(a5)
    80001752:	f679                	bnez	a2,80001720 <procdump+0x56>
      state = "???";
    80001754:	864e                	mv	a2,s3
    80001756:	b7e9                	j	80001720 <procdump+0x56>
  }
}
    80001758:	60a6                	ld	ra,72(sp)
    8000175a:	6406                	ld	s0,64(sp)
    8000175c:	74e2                	ld	s1,56(sp)
    8000175e:	7942                	ld	s2,48(sp)
    80001760:	79a2                	ld	s3,40(sp)
    80001762:	7a02                	ld	s4,32(sp)
    80001764:	6ae2                	ld	s5,24(sp)
    80001766:	6b42                	ld	s6,16(sp)
    80001768:	6ba2                	ld	s7,8(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <swtch>:
    8000176e:	00153023          	sd	ra,0(a0)
    80001772:	00253423          	sd	sp,8(a0)
    80001776:	e900                	sd	s0,16(a0)
    80001778:	ed04                	sd	s1,24(a0)
    8000177a:	03253023          	sd	s2,32(a0)
    8000177e:	03353423          	sd	s3,40(a0)
    80001782:	03453823          	sd	s4,48(a0)
    80001786:	03553c23          	sd	s5,56(a0)
    8000178a:	05653023          	sd	s6,64(a0)
    8000178e:	05753423          	sd	s7,72(a0)
    80001792:	05853823          	sd	s8,80(a0)
    80001796:	05953c23          	sd	s9,88(a0)
    8000179a:	07a53023          	sd	s10,96(a0)
    8000179e:	07b53423          	sd	s11,104(a0)
    800017a2:	0005b083          	ld	ra,0(a1)
    800017a6:	0085b103          	ld	sp,8(a1)
    800017aa:	6980                	ld	s0,16(a1)
    800017ac:	6d84                	ld	s1,24(a1)
    800017ae:	0205b903          	ld	s2,32(a1)
    800017b2:	0285b983          	ld	s3,40(a1)
    800017b6:	0305ba03          	ld	s4,48(a1)
    800017ba:	0385ba83          	ld	s5,56(a1)
    800017be:	0405bb03          	ld	s6,64(a1)
    800017c2:	0485bb83          	ld	s7,72(a1)
    800017c6:	0505bc03          	ld	s8,80(a1)
    800017ca:	0585bc83          	ld	s9,88(a1)
    800017ce:	0605bd03          	ld	s10,96(a1)
    800017d2:	0685bd83          	ld	s11,104(a1)
    800017d6:	8082                	ret

00000000800017d8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800017d8:	1141                	addi	sp,sp,-16
    800017da:	e406                	sd	ra,8(sp)
    800017dc:	e022                	sd	s0,0(sp)
    800017de:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800017e0:	00006597          	auipc	a1,0x6
    800017e4:	ad858593          	addi	a1,a1,-1320 # 800072b8 <states.0+0x30>
    800017e8:	00007517          	auipc	a0,0x7
    800017ec:	38850513          	addi	a0,a0,904 # 80008b70 <tickslock>
    800017f0:	6a3030ef          	jal	ra,80005692 <initlock>
}
    800017f4:	60a2                	ld	ra,8(sp)
    800017f6:	6402                	ld	s0,0(sp)
    800017f8:	0141                	addi	sp,sp,16
    800017fa:	8082                	ret

00000000800017fc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800017fc:	1141                	addi	sp,sp,-16
    800017fe:	e422                	sd	s0,8(sp)
    80001800:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001802:	00003797          	auipc	a5,0x3
    80001806:	eee78793          	addi	a5,a5,-274 # 800046f0 <kernelvec>
    8000180a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000180e:	6422                	ld	s0,8(sp)
    80001810:	0141                	addi	sp,sp,16
    80001812:	8082                	ret

0000000080001814 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001814:	1141                	addi	sp,sp,-16
    80001816:	e406                	sd	ra,8(sp)
    80001818:	e022                	sd	s0,0(sp)
    8000181a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000181c:	cf0ff0ef          	jal	ra,80000d0c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001820:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001824:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001826:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000182a:	00004697          	auipc	a3,0x4
    8000182e:	7d668693          	addi	a3,a3,2006 # 80006000 <_trampoline>
    80001832:	00004717          	auipc	a4,0x4
    80001836:	7ce70713          	addi	a4,a4,1998 # 80006000 <_trampoline>
    8000183a:	8f15                	sub	a4,a4,a3
    8000183c:	040007b7          	lui	a5,0x4000
    80001840:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001842:	07b2                	slli	a5,a5,0xc
    80001844:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001846:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000184a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000184c:	18002673          	csrr	a2,satp
    80001850:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001852:	6d30                	ld	a2,88(a0)
    80001854:	6138                	ld	a4,64(a0)
    80001856:	6585                	lui	a1,0x1
    80001858:	972e                	add	a4,a4,a1
    8000185a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000185c:	6d38                	ld	a4,88(a0)
    8000185e:	00000617          	auipc	a2,0x0
    80001862:	10c60613          	addi	a2,a2,268 # 8000196a <usertrap>
    80001866:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001868:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000186a:	8612                	mv	a2,tp
    8000186c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000186e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001872:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001876:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000187a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000187e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001880:	6f18                	ld	a4,24(a4)
    80001882:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001886:	6928                	ld	a0,80(a0)
    80001888:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000188a:	00005717          	auipc	a4,0x5
    8000188e:	81270713          	addi	a4,a4,-2030 # 8000609c <userret>
    80001892:	8f15                	sub	a4,a4,a3
    80001894:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001896:	577d                	li	a4,-1
    80001898:	177e                	slli	a4,a4,0x3f
    8000189a:	8d59                	or	a0,a0,a4
    8000189c:	9782                	jalr	a5
}
    8000189e:	60a2                	ld	ra,8(sp)
    800018a0:	6402                	ld	s0,0(sp)
    800018a2:	0141                	addi	sp,sp,16
    800018a4:	8082                	ret

00000000800018a6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018a6:	1101                	addi	sp,sp,-32
    800018a8:	ec06                	sd	ra,24(sp)
    800018aa:	e822                	sd	s0,16(sp)
    800018ac:	e426                	sd	s1,8(sp)
    800018ae:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018b0:	c30ff0ef          	jal	ra,80000ce0 <cpuid>
    800018b4:	cd19                	beqz	a0,800018d2 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018b6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800018ba:	000f4737          	lui	a4,0xf4
    800018be:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800018c2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800018c4:	14d79073          	csrw	0x14d,a5
}
    800018c8:	60e2                	ld	ra,24(sp)
    800018ca:	6442                	ld	s0,16(sp)
    800018cc:	64a2                	ld	s1,8(sp)
    800018ce:	6105                	addi	sp,sp,32
    800018d0:	8082                	ret
    acquire(&tickslock);
    800018d2:	00007497          	auipc	s1,0x7
    800018d6:	29e48493          	addi	s1,s1,670 # 80008b70 <tickslock>
    800018da:	8526                	mv	a0,s1
    800018dc:	637030ef          	jal	ra,80005712 <acquire>
    ticks++;
    800018e0:	00006517          	auipc	a0,0x6
    800018e4:	01850513          	addi	a0,a0,24 # 800078f8 <ticks>
    800018e8:	411c                	lw	a5,0(a0)
    800018ea:	2785                	addiw	a5,a5,1
    800018ec:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800018ee:	a39ff0ef          	jal	ra,80001326 <wakeup>
    release(&tickslock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	6b7030ef          	jal	ra,800057aa <release>
    800018f8:	bf7d                	j	800018b6 <clockintr+0x10>

00000000800018fa <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800018fa:	1101                	addi	sp,sp,-32
    800018fc:	ec06                	sd	ra,24(sp)
    800018fe:	e822                	sd	s0,16(sp)
    80001900:	e426                	sd	s1,8(sp)
    80001902:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001904:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001908:	57fd                	li	a5,-1
    8000190a:	17fe                	slli	a5,a5,0x3f
    8000190c:	07a5                	addi	a5,a5,9
    8000190e:	00f70d63          	beq	a4,a5,80001928 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001912:	57fd                	li	a5,-1
    80001914:	17fe                	slli	a5,a5,0x3f
    80001916:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001918:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000191a:	04f70463          	beq	a4,a5,80001962 <devintr+0x68>
  }
}
    8000191e:	60e2                	ld	ra,24(sp)
    80001920:	6442                	ld	s0,16(sp)
    80001922:	64a2                	ld	s1,8(sp)
    80001924:	6105                	addi	sp,sp,32
    80001926:	8082                	ret
    int irq = plic_claim();
    80001928:	671020ef          	jal	ra,80004798 <plic_claim>
    8000192c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000192e:	47a9                	li	a5,10
    80001930:	02f50363          	beq	a0,a5,80001956 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80001934:	4785                	li	a5,1
    80001936:	02f50363          	beq	a0,a5,8000195c <devintr+0x62>
    return 1;
    8000193a:	4505                	li	a0,1
    } else if(irq){
    8000193c:	d0ed                	beqz	s1,8000191e <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000193e:	85a6                	mv	a1,s1
    80001940:	00006517          	auipc	a0,0x6
    80001944:	98050513          	addi	a0,a0,-1664 # 800072c0 <states.0+0x38>
    80001948:	007030ef          	jal	ra,8000514e <printf>
      plic_complete(irq);
    8000194c:	8526                	mv	a0,s1
    8000194e:	66b020ef          	jal	ra,800047b8 <plic_complete>
    return 1;
    80001952:	4505                	li	a0,1
    80001954:	b7e9                	j	8000191e <devintr+0x24>
      uartintr();
    80001956:	501030ef          	jal	ra,80005656 <uartintr>
    8000195a:	bfcd                	j	8000194c <devintr+0x52>
      virtio_disk_intr();
    8000195c:	2c8030ef          	jal	ra,80004c24 <virtio_disk_intr>
    80001960:	b7f5                	j	8000194c <devintr+0x52>
    clockintr();
    80001962:	f45ff0ef          	jal	ra,800018a6 <clockintr>
    return 2;
    80001966:	4509                	li	a0,2
    80001968:	bf5d                	j	8000191e <devintr+0x24>

000000008000196a <usertrap>:
{
    8000196a:	1101                	addi	sp,sp,-32
    8000196c:	ec06                	sd	ra,24(sp)
    8000196e:	e822                	sd	s0,16(sp)
    80001970:	e426                	sd	s1,8(sp)
    80001972:	e04a                	sd	s2,0(sp)
    80001974:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001976:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000197a:	1007f793          	andi	a5,a5,256
    8000197e:	ef85                	bnez	a5,800019b6 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001980:	00003797          	auipc	a5,0x3
    80001984:	d7078793          	addi	a5,a5,-656 # 800046f0 <kernelvec>
    80001988:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000198c:	b80ff0ef          	jal	ra,80000d0c <myproc>
    80001990:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001992:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001994:	14102773          	csrr	a4,sepc
    80001998:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000199a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000199e:	47a1                	li	a5,8
    800019a0:	02f70163          	beq	a4,a5,800019c2 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019a4:	f57ff0ef          	jal	ra,800018fa <devintr>
    800019a8:	892a                	mv	s2,a0
    800019aa:	c135                	beqz	a0,80001a0e <usertrap+0xa4>
  if(killed(p))
    800019ac:	8526                	mv	a0,s1
    800019ae:	b65ff0ef          	jal	ra,80001512 <killed>
    800019b2:	cd1d                	beqz	a0,800019f0 <usertrap+0x86>
    800019b4:	a81d                	j	800019ea <usertrap+0x80>
    panic("usertrap: not from user mode");
    800019b6:	00006517          	auipc	a0,0x6
    800019ba:	92a50513          	addi	a0,a0,-1750 # 800072e0 <states.0+0x58>
    800019be:	245030ef          	jal	ra,80005402 <panic>
    if(killed(p))
    800019c2:	b51ff0ef          	jal	ra,80001512 <killed>
    800019c6:	e121                	bnez	a0,80001a06 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800019c8:	6cb8                	ld	a4,88(s1)
    800019ca:	6f1c                	ld	a5,24(a4)
    800019cc:	0791                	addi	a5,a5,4
    800019ce:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019d4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d8:	10079073          	csrw	sstatus,a5
    syscall();
    800019dc:	248000ef          	jal	ra,80001c24 <syscall>
  if(killed(p))
    800019e0:	8526                	mv	a0,s1
    800019e2:	b31ff0ef          	jal	ra,80001512 <killed>
    800019e6:	c901                	beqz	a0,800019f6 <usertrap+0x8c>
    800019e8:	4901                	li	s2,0
    exit(-1);
    800019ea:	557d                	li	a0,-1
    800019ec:	9fbff0ef          	jal	ra,800013e6 <exit>
  if(which_dev == 2)
    800019f0:	4789                	li	a5,2
    800019f2:	04f90563          	beq	s2,a5,80001a3c <usertrap+0xd2>
  usertrapret();
    800019f6:	e1fff0ef          	jal	ra,80001814 <usertrapret>
}
    800019fa:	60e2                	ld	ra,24(sp)
    800019fc:	6442                	ld	s0,16(sp)
    800019fe:	64a2                	ld	s1,8(sp)
    80001a00:	6902                	ld	s2,0(sp)
    80001a02:	6105                	addi	sp,sp,32
    80001a04:	8082                	ret
      exit(-1);
    80001a06:	557d                	li	a0,-1
    80001a08:	9dfff0ef          	jal	ra,800013e6 <exit>
    80001a0c:	bf75                	j	800019c8 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a0e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a12:	5890                	lw	a2,48(s1)
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	8ec50513          	addi	a0,a0,-1812 # 80007300 <states.0+0x78>
    80001a1c:	732030ef          	jal	ra,8000514e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a20:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a24:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a28:	00006517          	auipc	a0,0x6
    80001a2c:	90850513          	addi	a0,a0,-1784 # 80007330 <states.0+0xa8>
    80001a30:	71e030ef          	jal	ra,8000514e <printf>
    setkilled(p);
    80001a34:	8526                	mv	a0,s1
    80001a36:	ab9ff0ef          	jal	ra,800014ee <setkilled>
    80001a3a:	b75d                	j	800019e0 <usertrap+0x76>
    yield();
    80001a3c:	873ff0ef          	jal	ra,800012ae <yield>
    80001a40:	bf5d                	j	800019f6 <usertrap+0x8c>

0000000080001a42 <kerneltrap>:
{
    80001a42:	7179                	addi	sp,sp,-48
    80001a44:	f406                	sd	ra,40(sp)
    80001a46:	f022                	sd	s0,32(sp)
    80001a48:	ec26                	sd	s1,24(sp)
    80001a4a:	e84a                	sd	s2,16(sp)
    80001a4c:	e44e                	sd	s3,8(sp)
    80001a4e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a50:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a54:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a58:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001a5c:	1004f793          	andi	a5,s1,256
    80001a60:	c795                	beqz	a5,80001a8c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a62:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001a66:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001a68:	eb85                	bnez	a5,80001a98 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001a6a:	e91ff0ef          	jal	ra,800018fa <devintr>
    80001a6e:	c91d                	beqz	a0,80001aa4 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001a70:	4789                	li	a5,2
    80001a72:	04f50a63          	beq	a0,a5,80001ac6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a76:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a7a:	10049073          	csrw	sstatus,s1
}
    80001a7e:	70a2                	ld	ra,40(sp)
    80001a80:	7402                	ld	s0,32(sp)
    80001a82:	64e2                	ld	s1,24(sp)
    80001a84:	6942                	ld	s2,16(sp)
    80001a86:	69a2                	ld	s3,8(sp)
    80001a88:	6145                	addi	sp,sp,48
    80001a8a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001a8c:	00006517          	auipc	a0,0x6
    80001a90:	8cc50513          	addi	a0,a0,-1844 # 80007358 <states.0+0xd0>
    80001a94:	16f030ef          	jal	ra,80005402 <panic>
    panic("kerneltrap: interrupts enabled");
    80001a98:	00006517          	auipc	a0,0x6
    80001a9c:	8e850513          	addi	a0,a0,-1816 # 80007380 <states.0+0xf8>
    80001aa0:	163030ef          	jal	ra,80005402 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aa8:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001aac:	85ce                	mv	a1,s3
    80001aae:	00006517          	auipc	a0,0x6
    80001ab2:	8f250513          	addi	a0,a0,-1806 # 800073a0 <states.0+0x118>
    80001ab6:	698030ef          	jal	ra,8000514e <printf>
    panic("kerneltrap");
    80001aba:	00006517          	auipc	a0,0x6
    80001abe:	90e50513          	addi	a0,a0,-1778 # 800073c8 <states.0+0x140>
    80001ac2:	141030ef          	jal	ra,80005402 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ac6:	a46ff0ef          	jal	ra,80000d0c <myproc>
    80001aca:	d555                	beqz	a0,80001a76 <kerneltrap+0x34>
    yield();
    80001acc:	fe2ff0ef          	jal	ra,800012ae <yield>
    80001ad0:	b75d                	j	80001a76 <kerneltrap+0x34>

0000000080001ad2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ad2:	1101                	addi	sp,sp,-32
    80001ad4:	ec06                	sd	ra,24(sp)
    80001ad6:	e822                	sd	s0,16(sp)
    80001ad8:	e426                	sd	s1,8(sp)
    80001ada:	1000                	addi	s0,sp,32
    80001adc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ade:	a2eff0ef          	jal	ra,80000d0c <myproc>
  switch (n) {
    80001ae2:	4795                	li	a5,5
    80001ae4:	0497e163          	bltu	a5,s1,80001b26 <argraw+0x54>
    80001ae8:	048a                	slli	s1,s1,0x2
    80001aea:	00006717          	auipc	a4,0x6
    80001aee:	91670713          	addi	a4,a4,-1770 # 80007400 <states.0+0x178>
    80001af2:	94ba                	add	s1,s1,a4
    80001af4:	409c                	lw	a5,0(s1)
    80001af6:	97ba                	add	a5,a5,a4
    80001af8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001afa:	6d3c                	ld	a5,88(a0)
    80001afc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001afe:	60e2                	ld	ra,24(sp)
    80001b00:	6442                	ld	s0,16(sp)
    80001b02:	64a2                	ld	s1,8(sp)
    80001b04:	6105                	addi	sp,sp,32
    80001b06:	8082                	ret
    return p->trapframe->a1;
    80001b08:	6d3c                	ld	a5,88(a0)
    80001b0a:	7fa8                	ld	a0,120(a5)
    80001b0c:	bfcd                	j	80001afe <argraw+0x2c>
    return p->trapframe->a2;
    80001b0e:	6d3c                	ld	a5,88(a0)
    80001b10:	63c8                	ld	a0,128(a5)
    80001b12:	b7f5                	j	80001afe <argraw+0x2c>
    return p->trapframe->a3;
    80001b14:	6d3c                	ld	a5,88(a0)
    80001b16:	67c8                	ld	a0,136(a5)
    80001b18:	b7dd                	j	80001afe <argraw+0x2c>
    return p->trapframe->a4;
    80001b1a:	6d3c                	ld	a5,88(a0)
    80001b1c:	6bc8                	ld	a0,144(a5)
    80001b1e:	b7c5                	j	80001afe <argraw+0x2c>
    return p->trapframe->a5;
    80001b20:	6d3c                	ld	a5,88(a0)
    80001b22:	6fc8                	ld	a0,152(a5)
    80001b24:	bfe9                	j	80001afe <argraw+0x2c>
  panic("argraw");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	8b250513          	addi	a0,a0,-1870 # 800073d8 <states.0+0x150>
    80001b2e:	0d5030ef          	jal	ra,80005402 <panic>

0000000080001b32 <fetchaddr>:
{
    80001b32:	1101                	addi	sp,sp,-32
    80001b34:	ec06                	sd	ra,24(sp)
    80001b36:	e822                	sd	s0,16(sp)
    80001b38:	e426                	sd	s1,8(sp)
    80001b3a:	e04a                	sd	s2,0(sp)
    80001b3c:	1000                	addi	s0,sp,32
    80001b3e:	84aa                	mv	s1,a0
    80001b40:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b42:	9caff0ef          	jal	ra,80000d0c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b46:	653c                	ld	a5,72(a0)
    80001b48:	02f4f663          	bgeu	s1,a5,80001b74 <fetchaddr+0x42>
    80001b4c:	00848713          	addi	a4,s1,8
    80001b50:	02e7e463          	bltu	a5,a4,80001b78 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001b54:	46a1                	li	a3,8
    80001b56:	8626                	mv	a2,s1
    80001b58:	85ca                	mv	a1,s2
    80001b5a:	6928                	ld	a0,80(a0)
    80001b5c:	f21fe0ef          	jal	ra,80000a7c <copyin>
    80001b60:	00a03533          	snez	a0,a0
    80001b64:	40a00533          	neg	a0,a0
}
    80001b68:	60e2                	ld	ra,24(sp)
    80001b6a:	6442                	ld	s0,16(sp)
    80001b6c:	64a2                	ld	s1,8(sp)
    80001b6e:	6902                	ld	s2,0(sp)
    80001b70:	6105                	addi	sp,sp,32
    80001b72:	8082                	ret
    return -1;
    80001b74:	557d                	li	a0,-1
    80001b76:	bfcd                	j	80001b68 <fetchaddr+0x36>
    80001b78:	557d                	li	a0,-1
    80001b7a:	b7fd                	j	80001b68 <fetchaddr+0x36>

0000000080001b7c <fetchstr>:
{
    80001b7c:	7179                	addi	sp,sp,-48
    80001b7e:	f406                	sd	ra,40(sp)
    80001b80:	f022                	sd	s0,32(sp)
    80001b82:	ec26                	sd	s1,24(sp)
    80001b84:	e84a                	sd	s2,16(sp)
    80001b86:	e44e                	sd	s3,8(sp)
    80001b88:	1800                	addi	s0,sp,48
    80001b8a:	892a                	mv	s2,a0
    80001b8c:	84ae                	mv	s1,a1
    80001b8e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001b90:	97cff0ef          	jal	ra,80000d0c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001b94:	86ce                	mv	a3,s3
    80001b96:	864a                	mv	a2,s2
    80001b98:	85a6                	mv	a1,s1
    80001b9a:	6928                	ld	a0,80(a0)
    80001b9c:	f67fe0ef          	jal	ra,80000b02 <copyinstr>
    80001ba0:	00054c63          	bltz	a0,80001bb8 <fetchstr+0x3c>
  return strlen(buf);
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	f20fe0ef          	jal	ra,800002c6 <strlen>
}
    80001baa:	70a2                	ld	ra,40(sp)
    80001bac:	7402                	ld	s0,32(sp)
    80001bae:	64e2                	ld	s1,24(sp)
    80001bb0:	6942                	ld	s2,16(sp)
    80001bb2:	69a2                	ld	s3,8(sp)
    80001bb4:	6145                	addi	sp,sp,48
    80001bb6:	8082                	ret
    return -1;
    80001bb8:	557d                	li	a0,-1
    80001bba:	bfc5                	j	80001baa <fetchstr+0x2e>

0000000080001bbc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001bbc:	1101                	addi	sp,sp,-32
    80001bbe:	ec06                	sd	ra,24(sp)
    80001bc0:	e822                	sd	s0,16(sp)
    80001bc2:	e426                	sd	s1,8(sp)
    80001bc4:	1000                	addi	s0,sp,32
    80001bc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001bc8:	f0bff0ef          	jal	ra,80001ad2 <argraw>
    80001bcc:	c088                	sw	a0,0(s1)
}
    80001bce:	60e2                	ld	ra,24(sp)
    80001bd0:	6442                	ld	s0,16(sp)
    80001bd2:	64a2                	ld	s1,8(sp)
    80001bd4:	6105                	addi	sp,sp,32
    80001bd6:	8082                	ret

0000000080001bd8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001bd8:	1101                	addi	sp,sp,-32
    80001bda:	ec06                	sd	ra,24(sp)
    80001bdc:	e822                	sd	s0,16(sp)
    80001bde:	e426                	sd	s1,8(sp)
    80001be0:	1000                	addi	s0,sp,32
    80001be2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001be4:	eefff0ef          	jal	ra,80001ad2 <argraw>
    80001be8:	e088                	sd	a0,0(s1)
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret

0000000080001bf4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001bf4:	7179                	addi	sp,sp,-48
    80001bf6:	f406                	sd	ra,40(sp)
    80001bf8:	f022                	sd	s0,32(sp)
    80001bfa:	ec26                	sd	s1,24(sp)
    80001bfc:	e84a                	sd	s2,16(sp)
    80001bfe:	1800                	addi	s0,sp,48
    80001c00:	84ae                	mv	s1,a1
    80001c02:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c04:	fd840593          	addi	a1,s0,-40
    80001c08:	fd1ff0ef          	jal	ra,80001bd8 <argaddr>
  return fetchstr(addr, buf, max);
    80001c0c:	864a                	mv	a2,s2
    80001c0e:	85a6                	mv	a1,s1
    80001c10:	fd843503          	ld	a0,-40(s0)
    80001c14:	f69ff0ef          	jal	ra,80001b7c <fetchstr>
}
    80001c18:	70a2                	ld	ra,40(sp)
    80001c1a:	7402                	ld	s0,32(sp)
    80001c1c:	64e2                	ld	s1,24(sp)
    80001c1e:	6942                	ld	s2,16(sp)
    80001c20:	6145                	addi	sp,sp,48
    80001c22:	8082                	ret

0000000080001c24 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	e04a                	sd	s2,0(sp)
    80001c2e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c30:	8dcff0ef          	jal	ra,80000d0c <myproc>
    80001c34:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c36:	05853903          	ld	s2,88(a0)
    80001c3a:	0a893783          	ld	a5,168(s2)
    80001c3e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c42:	37fd                	addiw	a5,a5,-1
    80001c44:	4755                	li	a4,21
    80001c46:	00f76f63          	bltu	a4,a5,80001c64 <syscall+0x40>
    80001c4a:	00369713          	slli	a4,a3,0x3
    80001c4e:	00005797          	auipc	a5,0x5
    80001c52:	7ca78793          	addi	a5,a5,1994 # 80007418 <syscalls>
    80001c56:	97ba                	add	a5,a5,a4
    80001c58:	639c                	ld	a5,0(a5)
    80001c5a:	c789                	beqz	a5,80001c64 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001c5c:	9782                	jalr	a5
    80001c5e:	06a93823          	sd	a0,112(s2)
    80001c62:	a829                	j	80001c7c <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001c64:	15848613          	addi	a2,s1,344
    80001c68:	588c                	lw	a1,48(s1)
    80001c6a:	00005517          	auipc	a0,0x5
    80001c6e:	77650513          	addi	a0,a0,1910 # 800073e0 <states.0+0x158>
    80001c72:	4dc030ef          	jal	ra,8000514e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001c76:	6cbc                	ld	a5,88(s1)
    80001c78:	577d                	li	a4,-1
    80001c7a:	fbb8                	sd	a4,112(a5)
  }
}
    80001c7c:	60e2                	ld	ra,24(sp)
    80001c7e:	6442                	ld	s0,16(sp)
    80001c80:	64a2                	ld	s1,8(sp)
    80001c82:	6902                	ld	s2,0(sp)
    80001c84:	6105                	addi	sp,sp,32
    80001c86:	8082                	ret

0000000080001c88 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001c90:	fec40593          	addi	a1,s0,-20
    80001c94:	4501                	li	a0,0
    80001c96:	f27ff0ef          	jal	ra,80001bbc <argint>
  exit(n);
    80001c9a:	fec42503          	lw	a0,-20(s0)
    80001c9e:	f48ff0ef          	jal	ra,800013e6 <exit>
  return 0;  // not reached
}
    80001ca2:	4501                	li	a0,0
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	6105                	addi	sp,sp,32
    80001caa:	8082                	ret

0000000080001cac <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cac:	1141                	addi	sp,sp,-16
    80001cae:	e406                	sd	ra,8(sp)
    80001cb0:	e022                	sd	s0,0(sp)
    80001cb2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cb4:	858ff0ef          	jal	ra,80000d0c <myproc>
}
    80001cb8:	5908                	lw	a0,48(a0)
    80001cba:	60a2                	ld	ra,8(sp)
    80001cbc:	6402                	ld	s0,0(sp)
    80001cbe:	0141                	addi	sp,sp,16
    80001cc0:	8082                	ret

0000000080001cc2 <sys_fork>:

uint64
sys_fork(void)
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e406                	sd	ra,8(sp)
    80001cc6:	e022                	sd	s0,0(sp)
    80001cc8:	0800                	addi	s0,sp,16
  return fork();
    80001cca:	b68ff0ef          	jal	ra,80001032 <fork>
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret

0000000080001cd6 <sys_wait>:

uint64
sys_wait(void)
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001cde:	fe840593          	addi	a1,s0,-24
    80001ce2:	4501                	li	a0,0
    80001ce4:	ef5ff0ef          	jal	ra,80001bd8 <argaddr>
  return wait(p);
    80001ce8:	fe843503          	ld	a0,-24(s0)
    80001cec:	851ff0ef          	jal	ra,8000153c <wait>
}
    80001cf0:	60e2                	ld	ra,24(sp)
    80001cf2:	6442                	ld	s0,16(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret

0000000080001cf8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001cf8:	7179                	addi	sp,sp,-48
    80001cfa:	f406                	sd	ra,40(sp)
    80001cfc:	f022                	sd	s0,32(sp)
    80001cfe:	ec26                	sd	s1,24(sp)
    80001d00:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d02:	fdc40593          	addi	a1,s0,-36
    80001d06:	4501                	li	a0,0
    80001d08:	eb5ff0ef          	jal	ra,80001bbc <argint>
  addr = myproc()->sz;
    80001d0c:	800ff0ef          	jal	ra,80000d0c <myproc>
    80001d10:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d12:	fdc42503          	lw	a0,-36(s0)
    80001d16:	accff0ef          	jal	ra,80000fe2 <growproc>
    80001d1a:	00054863          	bltz	a0,80001d2a <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d1e:	8526                	mv	a0,s1
    80001d20:	70a2                	ld	ra,40(sp)
    80001d22:	7402                	ld	s0,32(sp)
    80001d24:	64e2                	ld	s1,24(sp)
    80001d26:	6145                	addi	sp,sp,48
    80001d28:	8082                	ret
    return -1;
    80001d2a:	54fd                	li	s1,-1
    80001d2c:	bfcd                	j	80001d1e <sys_sbrk+0x26>

0000000080001d2e <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d2e:	7139                	addi	sp,sp,-64
    80001d30:	fc06                	sd	ra,56(sp)
    80001d32:	f822                	sd	s0,48(sp)
    80001d34:	f426                	sd	s1,40(sp)
    80001d36:	f04a                	sd	s2,32(sp)
    80001d38:	ec4e                	sd	s3,24(sp)
    80001d3a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d3c:	fcc40593          	addi	a1,s0,-52
    80001d40:	4501                	li	a0,0
    80001d42:	e7bff0ef          	jal	ra,80001bbc <argint>
  if(n < 0)
    80001d46:	fcc42783          	lw	a5,-52(s0)
    80001d4a:	0607c563          	bltz	a5,80001db4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d4e:	00007517          	auipc	a0,0x7
    80001d52:	e2250513          	addi	a0,a0,-478 # 80008b70 <tickslock>
    80001d56:	1bd030ef          	jal	ra,80005712 <acquire>
  ticks0 = ticks;
    80001d5a:	00006917          	auipc	s2,0x6
    80001d5e:	b9e92903          	lw	s2,-1122(s2) # 800078f8 <ticks>
  while(ticks - ticks0 < n){
    80001d62:	fcc42783          	lw	a5,-52(s0)
    80001d66:	cb8d                	beqz	a5,80001d98 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001d68:	00007997          	auipc	s3,0x7
    80001d6c:	e0898993          	addi	s3,s3,-504 # 80008b70 <tickslock>
    80001d70:	00006497          	auipc	s1,0x6
    80001d74:	b8848493          	addi	s1,s1,-1144 # 800078f8 <ticks>
    if(killed(myproc())){
    80001d78:	f95fe0ef          	jal	ra,80000d0c <myproc>
    80001d7c:	f96ff0ef          	jal	ra,80001512 <killed>
    80001d80:	ed0d                	bnez	a0,80001dba <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001d82:	85ce                	mv	a1,s3
    80001d84:	8526                	mv	a0,s1
    80001d86:	d54ff0ef          	jal	ra,800012da <sleep>
  while(ticks - ticks0 < n){
    80001d8a:	409c                	lw	a5,0(s1)
    80001d8c:	412787bb          	subw	a5,a5,s2
    80001d90:	fcc42703          	lw	a4,-52(s0)
    80001d94:	fee7e2e3          	bltu	a5,a4,80001d78 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80001d98:	00007517          	auipc	a0,0x7
    80001d9c:	dd850513          	addi	a0,a0,-552 # 80008b70 <tickslock>
    80001da0:	20b030ef          	jal	ra,800057aa <release>
  return 0;
    80001da4:	4501                	li	a0,0
}
    80001da6:	70e2                	ld	ra,56(sp)
    80001da8:	7442                	ld	s0,48(sp)
    80001daa:	74a2                	ld	s1,40(sp)
    80001dac:	7902                	ld	s2,32(sp)
    80001dae:	69e2                	ld	s3,24(sp)
    80001db0:	6121                	addi	sp,sp,64
    80001db2:	8082                	ret
    n = 0;
    80001db4:	fc042623          	sw	zero,-52(s0)
    80001db8:	bf59                	j	80001d4e <sys_sleep+0x20>
      release(&tickslock);
    80001dba:	00007517          	auipc	a0,0x7
    80001dbe:	db650513          	addi	a0,a0,-586 # 80008b70 <tickslock>
    80001dc2:	1e9030ef          	jal	ra,800057aa <release>
      return -1;
    80001dc6:	557d                	li	a0,-1
    80001dc8:	bff9                	j	80001da6 <sys_sleep+0x78>

0000000080001dca <sys_kill>:

uint64
sys_kill(void)
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001dd2:	fec40593          	addi	a1,s0,-20
    80001dd6:	4501                	li	a0,0
    80001dd8:	de5ff0ef          	jal	ra,80001bbc <argint>
  return kill(pid);
    80001ddc:	fec42503          	lw	a0,-20(s0)
    80001de0:	ea8ff0ef          	jal	ra,80001488 <kill>
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret

0000000080001dec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001dec:	1101                	addi	sp,sp,-32
    80001dee:	ec06                	sd	ra,24(sp)
    80001df0:	e822                	sd	s0,16(sp)
    80001df2:	e426                	sd	s1,8(sp)
    80001df4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001df6:	00007517          	auipc	a0,0x7
    80001dfa:	d7a50513          	addi	a0,a0,-646 # 80008b70 <tickslock>
    80001dfe:	115030ef          	jal	ra,80005712 <acquire>
  xticks = ticks;
    80001e02:	00006497          	auipc	s1,0x6
    80001e06:	af64a483          	lw	s1,-1290(s1) # 800078f8 <ticks>
  release(&tickslock);
    80001e0a:	00007517          	auipc	a0,0x7
    80001e0e:	d6650513          	addi	a0,a0,-666 # 80008b70 <tickslock>
    80001e12:	199030ef          	jal	ra,800057aa <release>
  return xticks;
}
    80001e16:	02049513          	slli	a0,s1,0x20
    80001e1a:	9101                	srli	a0,a0,0x20
    80001e1c:	60e2                	ld	ra,24(sp)
    80001e1e:	6442                	ld	s0,16(sp)
    80001e20:	64a2                	ld	s1,8(sp)
    80001e22:	6105                	addi	sp,sp,32
    80001e24:	8082                	ret

0000000080001e26 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e26:	7179                	addi	sp,sp,-48
    80001e28:	f406                	sd	ra,40(sp)
    80001e2a:	f022                	sd	s0,32(sp)
    80001e2c:	ec26                	sd	s1,24(sp)
    80001e2e:	e84a                	sd	s2,16(sp)
    80001e30:	e44e                	sd	s3,8(sp)
    80001e32:	e052                	sd	s4,0(sp)
    80001e34:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e36:	00005597          	auipc	a1,0x5
    80001e3a:	69a58593          	addi	a1,a1,1690 # 800074d0 <syscalls+0xb8>
    80001e3e:	00007517          	auipc	a0,0x7
    80001e42:	d4a50513          	addi	a0,a0,-694 # 80008b88 <bcache>
    80001e46:	04d030ef          	jal	ra,80005692 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e4a:	0000f797          	auipc	a5,0xf
    80001e4e:	d3e78793          	addi	a5,a5,-706 # 80010b88 <bcache+0x8000>
    80001e52:	0000f717          	auipc	a4,0xf
    80001e56:	f9e70713          	addi	a4,a4,-98 # 80010df0 <bcache+0x8268>
    80001e5a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001e5e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001e62:	00007497          	auipc	s1,0x7
    80001e66:	d3e48493          	addi	s1,s1,-706 # 80008ba0 <bcache+0x18>
    b->next = bcache.head.next;
    80001e6a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001e6c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001e6e:	00005a17          	auipc	s4,0x5
    80001e72:	66aa0a13          	addi	s4,s4,1642 # 800074d8 <syscalls+0xc0>
    b->next = bcache.head.next;
    80001e76:	2b893783          	ld	a5,696(s2)
    80001e7a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001e7c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001e80:	85d2                	mv	a1,s4
    80001e82:	01048513          	addi	a0,s1,16
    80001e86:	2aa010ef          	jal	ra,80003130 <initsleeplock>
    bcache.head.next->prev = b;
    80001e8a:	2b893783          	ld	a5,696(s2)
    80001e8e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001e90:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001e94:	45848493          	addi	s1,s1,1112
    80001e98:	fd349fe3          	bne	s1,s3,80001e76 <binit+0x50>
  }
}
    80001e9c:	70a2                	ld	ra,40(sp)
    80001e9e:	7402                	ld	s0,32(sp)
    80001ea0:	64e2                	ld	s1,24(sp)
    80001ea2:	6942                	ld	s2,16(sp)
    80001ea4:	69a2                	ld	s3,8(sp)
    80001ea6:	6a02                	ld	s4,0(sp)
    80001ea8:	6145                	addi	sp,sp,48
    80001eaa:	8082                	ret

0000000080001eac <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001ebe:	00007517          	auipc	a0,0x7
    80001ec2:	cca50513          	addi	a0,a0,-822 # 80008b88 <bcache>
    80001ec6:	04d030ef          	jal	ra,80005712 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001eca:	0000f497          	auipc	s1,0xf
    80001ece:	f764b483          	ld	s1,-138(s1) # 80010e40 <bcache+0x82b8>
    80001ed2:	0000f797          	auipc	a5,0xf
    80001ed6:	f1e78793          	addi	a5,a5,-226 # 80010df0 <bcache+0x8268>
    80001eda:	02f48b63          	beq	s1,a5,80001f10 <bread+0x64>
    80001ede:	873e                	mv	a4,a5
    80001ee0:	a021                	j	80001ee8 <bread+0x3c>
    80001ee2:	68a4                	ld	s1,80(s1)
    80001ee4:	02e48663          	beq	s1,a4,80001f10 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001ee8:	449c                	lw	a5,8(s1)
    80001eea:	ff279ce3          	bne	a5,s2,80001ee2 <bread+0x36>
    80001eee:	44dc                	lw	a5,12(s1)
    80001ef0:	ff3799e3          	bne	a5,s3,80001ee2 <bread+0x36>
      b->refcnt++;
    80001ef4:	40bc                	lw	a5,64(s1)
    80001ef6:	2785                	addiw	a5,a5,1
    80001ef8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001efa:	00007517          	auipc	a0,0x7
    80001efe:	c8e50513          	addi	a0,a0,-882 # 80008b88 <bcache>
    80001f02:	0a9030ef          	jal	ra,800057aa <release>
      acquiresleep(&b->lock);
    80001f06:	01048513          	addi	a0,s1,16
    80001f0a:	25c010ef          	jal	ra,80003166 <acquiresleep>
      return b;
    80001f0e:	a889                	j	80001f60 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f10:	0000f497          	auipc	s1,0xf
    80001f14:	f284b483          	ld	s1,-216(s1) # 80010e38 <bcache+0x82b0>
    80001f18:	0000f797          	auipc	a5,0xf
    80001f1c:	ed878793          	addi	a5,a5,-296 # 80010df0 <bcache+0x8268>
    80001f20:	00f48863          	beq	s1,a5,80001f30 <bread+0x84>
    80001f24:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f26:	40bc                	lw	a5,64(s1)
    80001f28:	cb91                	beqz	a5,80001f3c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f2a:	64a4                	ld	s1,72(s1)
    80001f2c:	fee49de3          	bne	s1,a4,80001f26 <bread+0x7a>
  panic("bget: no buffers");
    80001f30:	00005517          	auipc	a0,0x5
    80001f34:	5b050513          	addi	a0,a0,1456 # 800074e0 <syscalls+0xc8>
    80001f38:	4ca030ef          	jal	ra,80005402 <panic>
      b->dev = dev;
    80001f3c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f40:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f44:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f48:	4785                	li	a5,1
    80001f4a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f4c:	00007517          	auipc	a0,0x7
    80001f50:	c3c50513          	addi	a0,a0,-964 # 80008b88 <bcache>
    80001f54:	057030ef          	jal	ra,800057aa <release>
      acquiresleep(&b->lock);
    80001f58:	01048513          	addi	a0,s1,16
    80001f5c:	20a010ef          	jal	ra,80003166 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001f60:	409c                	lw	a5,0(s1)
    80001f62:	cb89                	beqz	a5,80001f74 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001f64:	8526                	mv	a0,s1
    80001f66:	70a2                	ld	ra,40(sp)
    80001f68:	7402                	ld	s0,32(sp)
    80001f6a:	64e2                	ld	s1,24(sp)
    80001f6c:	6942                	ld	s2,16(sp)
    80001f6e:	69a2                	ld	s3,8(sp)
    80001f70:	6145                	addi	sp,sp,48
    80001f72:	8082                	ret
    virtio_disk_rw(b, 0);
    80001f74:	4581                	li	a1,0
    80001f76:	8526                	mv	a0,s1
    80001f78:	293020ef          	jal	ra,80004a0a <virtio_disk_rw>
    b->valid = 1;
    80001f7c:	4785                	li	a5,1
    80001f7e:	c09c                	sw	a5,0(s1)
  return b;
    80001f80:	b7d5                	j	80001f64 <bread+0xb8>

0000000080001f82 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001f8e:	0541                	addi	a0,a0,16
    80001f90:	254010ef          	jal	ra,800031e4 <holdingsleep>
    80001f94:	c911                	beqz	a0,80001fa8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001f96:	4585                	li	a1,1
    80001f98:	8526                	mv	a0,s1
    80001f9a:	271020ef          	jal	ra,80004a0a <virtio_disk_rw>
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret
    panic("bwrite");
    80001fa8:	00005517          	auipc	a0,0x5
    80001fac:	55050513          	addi	a0,a0,1360 # 800074f8 <syscalls+0xe0>
    80001fb0:	452030ef          	jal	ra,80005402 <panic>

0000000080001fb4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	e04a                	sd	s2,0(sp)
    80001fbe:	1000                	addi	s0,sp,32
    80001fc0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fc2:	01050913          	addi	s2,a0,16
    80001fc6:	854a                	mv	a0,s2
    80001fc8:	21c010ef          	jal	ra,800031e4 <holdingsleep>
    80001fcc:	c13d                	beqz	a0,80002032 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80001fce:	854a                	mv	a0,s2
    80001fd0:	1dc010ef          	jal	ra,800031ac <releasesleep>

  acquire(&bcache.lock);
    80001fd4:	00007517          	auipc	a0,0x7
    80001fd8:	bb450513          	addi	a0,a0,-1100 # 80008b88 <bcache>
    80001fdc:	736030ef          	jal	ra,80005712 <acquire>
  b->refcnt--;
    80001fe0:	40bc                	lw	a5,64(s1)
    80001fe2:	37fd                	addiw	a5,a5,-1
    80001fe4:	0007871b          	sext.w	a4,a5
    80001fe8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80001fea:	eb05                	bnez	a4,8000201a <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80001fec:	68bc                	ld	a5,80(s1)
    80001fee:	64b8                	ld	a4,72(s1)
    80001ff0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80001ff2:	64bc                	ld	a5,72(s1)
    80001ff4:	68b8                	ld	a4,80(s1)
    80001ff6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80001ff8:	0000f797          	auipc	a5,0xf
    80001ffc:	b9078793          	addi	a5,a5,-1136 # 80010b88 <bcache+0x8000>
    80002000:	2b87b703          	ld	a4,696(a5)
    80002004:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002006:	0000f717          	auipc	a4,0xf
    8000200a:	dea70713          	addi	a4,a4,-534 # 80010df0 <bcache+0x8268>
    8000200e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002010:	2b87b703          	ld	a4,696(a5)
    80002014:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002016:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000201a:	00007517          	auipc	a0,0x7
    8000201e:	b6e50513          	addi	a0,a0,-1170 # 80008b88 <bcache>
    80002022:	788030ef          	jal	ra,800057aa <release>
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6902                	ld	s2,0(sp)
    8000202e:	6105                	addi	sp,sp,32
    80002030:	8082                	ret
    panic("brelse");
    80002032:	00005517          	auipc	a0,0x5
    80002036:	4ce50513          	addi	a0,a0,1230 # 80007500 <syscalls+0xe8>
    8000203a:	3c8030ef          	jal	ra,80005402 <panic>

000000008000203e <bpin>:

void
bpin(struct buf *b) {
    8000203e:	1101                	addi	sp,sp,-32
    80002040:	ec06                	sd	ra,24(sp)
    80002042:	e822                	sd	s0,16(sp)
    80002044:	e426                	sd	s1,8(sp)
    80002046:	1000                	addi	s0,sp,32
    80002048:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000204a:	00007517          	auipc	a0,0x7
    8000204e:	b3e50513          	addi	a0,a0,-1218 # 80008b88 <bcache>
    80002052:	6c0030ef          	jal	ra,80005712 <acquire>
  b->refcnt++;
    80002056:	40bc                	lw	a5,64(s1)
    80002058:	2785                	addiw	a5,a5,1
    8000205a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000205c:	00007517          	auipc	a0,0x7
    80002060:	b2c50513          	addi	a0,a0,-1236 # 80008b88 <bcache>
    80002064:	746030ef          	jal	ra,800057aa <release>
}
    80002068:	60e2                	ld	ra,24(sp)
    8000206a:	6442                	ld	s0,16(sp)
    8000206c:	64a2                	ld	s1,8(sp)
    8000206e:	6105                	addi	sp,sp,32
    80002070:	8082                	ret

0000000080002072 <bunpin>:

void
bunpin(struct buf *b) {
    80002072:	1101                	addi	sp,sp,-32
    80002074:	ec06                	sd	ra,24(sp)
    80002076:	e822                	sd	s0,16(sp)
    80002078:	e426                	sd	s1,8(sp)
    8000207a:	1000                	addi	s0,sp,32
    8000207c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000207e:	00007517          	auipc	a0,0x7
    80002082:	b0a50513          	addi	a0,a0,-1270 # 80008b88 <bcache>
    80002086:	68c030ef          	jal	ra,80005712 <acquire>
  b->refcnt--;
    8000208a:	40bc                	lw	a5,64(s1)
    8000208c:	37fd                	addiw	a5,a5,-1
    8000208e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002090:	00007517          	auipc	a0,0x7
    80002094:	af850513          	addi	a0,a0,-1288 # 80008b88 <bcache>
    80002098:	712030ef          	jal	ra,800057aa <release>
}
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	64a2                	ld	s1,8(sp)
    800020a2:	6105                	addi	sp,sp,32
    800020a4:	8082                	ret

00000000800020a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	e04a                	sd	s2,0(sp)
    800020b0:	1000                	addi	s0,sp,32
    800020b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020b4:	00d5d59b          	srliw	a1,a1,0xd
    800020b8:	0000f797          	auipc	a5,0xf
    800020bc:	1ac7a783          	lw	a5,428(a5) # 80011264 <sb+0x1c>
    800020c0:	9dbd                	addw	a1,a1,a5
    800020c2:	debff0ef          	jal	ra,80001eac <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800020c6:	0074f713          	andi	a4,s1,7
    800020ca:	4785                	li	a5,1
    800020cc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800020d0:	14ce                	slli	s1,s1,0x33
    800020d2:	90d9                	srli	s1,s1,0x36
    800020d4:	00950733          	add	a4,a0,s1
    800020d8:	05874703          	lbu	a4,88(a4)
    800020dc:	00e7f6b3          	and	a3,a5,a4
    800020e0:	c29d                	beqz	a3,80002106 <bfree+0x60>
    800020e2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800020e4:	94aa                	add	s1,s1,a0
    800020e6:	fff7c793          	not	a5,a5
    800020ea:	8f7d                	and	a4,a4,a5
    800020ec:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800020f0:	771000ef          	jal	ra,80003060 <log_write>
  brelse(bp);
    800020f4:	854a                	mv	a0,s2
    800020f6:	ebfff0ef          	jal	ra,80001fb4 <brelse>
}
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	64a2                	ld	s1,8(sp)
    80002100:	6902                	ld	s2,0(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret
    panic("freeing free block");
    80002106:	00005517          	auipc	a0,0x5
    8000210a:	40250513          	addi	a0,a0,1026 # 80007508 <syscalls+0xf0>
    8000210e:	2f4030ef          	jal	ra,80005402 <panic>

0000000080002112 <balloc>:
{
    80002112:	711d                	addi	sp,sp,-96
    80002114:	ec86                	sd	ra,88(sp)
    80002116:	e8a2                	sd	s0,80(sp)
    80002118:	e4a6                	sd	s1,72(sp)
    8000211a:	e0ca                	sd	s2,64(sp)
    8000211c:	fc4e                	sd	s3,56(sp)
    8000211e:	f852                	sd	s4,48(sp)
    80002120:	f456                	sd	s5,40(sp)
    80002122:	f05a                	sd	s6,32(sp)
    80002124:	ec5e                	sd	s7,24(sp)
    80002126:	e862                	sd	s8,16(sp)
    80002128:	e466                	sd	s9,8(sp)
    8000212a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000212c:	0000f797          	auipc	a5,0xf
    80002130:	1207a783          	lw	a5,288(a5) # 8001124c <sb+0x4>
    80002134:	cff1                	beqz	a5,80002210 <balloc+0xfe>
    80002136:	8baa                	mv	s7,a0
    80002138:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000213a:	0000fb17          	auipc	s6,0xf
    8000213e:	10eb0b13          	addi	s6,s6,270 # 80011248 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002142:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002144:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002146:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002148:	6c89                	lui	s9,0x2
    8000214a:	a0b5                	j	800021b6 <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000214c:	97ca                	add	a5,a5,s2
    8000214e:	8e55                	or	a2,a2,a3
    80002150:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002154:	854a                	mv	a0,s2
    80002156:	70b000ef          	jal	ra,80003060 <log_write>
        brelse(bp);
    8000215a:	854a                	mv	a0,s2
    8000215c:	e59ff0ef          	jal	ra,80001fb4 <brelse>
  bp = bread(dev, bno);
    80002160:	85a6                	mv	a1,s1
    80002162:	855e                	mv	a0,s7
    80002164:	d49ff0ef          	jal	ra,80001eac <bread>
    80002168:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000216a:	40000613          	li	a2,1024
    8000216e:	4581                	li	a1,0
    80002170:	05850513          	addi	a0,a0,88
    80002174:	fdbfd0ef          	jal	ra,8000014e <memset>
  log_write(bp);
    80002178:	854a                	mv	a0,s2
    8000217a:	6e7000ef          	jal	ra,80003060 <log_write>
  brelse(bp);
    8000217e:	854a                	mv	a0,s2
    80002180:	e35ff0ef          	jal	ra,80001fb4 <brelse>
}
    80002184:	8526                	mv	a0,s1
    80002186:	60e6                	ld	ra,88(sp)
    80002188:	6446                	ld	s0,80(sp)
    8000218a:	64a6                	ld	s1,72(sp)
    8000218c:	6906                	ld	s2,64(sp)
    8000218e:	79e2                	ld	s3,56(sp)
    80002190:	7a42                	ld	s4,48(sp)
    80002192:	7aa2                	ld	s5,40(sp)
    80002194:	7b02                	ld	s6,32(sp)
    80002196:	6be2                	ld	s7,24(sp)
    80002198:	6c42                	ld	s8,16(sp)
    8000219a:	6ca2                	ld	s9,8(sp)
    8000219c:	6125                	addi	sp,sp,96
    8000219e:	8082                	ret
    brelse(bp);
    800021a0:	854a                	mv	a0,s2
    800021a2:	e13ff0ef          	jal	ra,80001fb4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021a6:	015c87bb          	addw	a5,s9,s5
    800021aa:	00078a9b          	sext.w	s5,a5
    800021ae:	004b2703          	lw	a4,4(s6)
    800021b2:	04eaff63          	bgeu	s5,a4,80002210 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    800021b6:	41fad79b          	sraiw	a5,s5,0x1f
    800021ba:	0137d79b          	srliw	a5,a5,0x13
    800021be:	015787bb          	addw	a5,a5,s5
    800021c2:	40d7d79b          	sraiw	a5,a5,0xd
    800021c6:	01cb2583          	lw	a1,28(s6)
    800021ca:	9dbd                	addw	a1,a1,a5
    800021cc:	855e                	mv	a0,s7
    800021ce:	cdfff0ef          	jal	ra,80001eac <bread>
    800021d2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021d4:	004b2503          	lw	a0,4(s6)
    800021d8:	000a849b          	sext.w	s1,s5
    800021dc:	8762                	mv	a4,s8
    800021de:	fca4f1e3          	bgeu	s1,a0,800021a0 <balloc+0x8e>
      m = 1 << (bi % 8);
    800021e2:	00777693          	andi	a3,a4,7
    800021e6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800021ea:	41f7579b          	sraiw	a5,a4,0x1f
    800021ee:	01d7d79b          	srliw	a5,a5,0x1d
    800021f2:	9fb9                	addw	a5,a5,a4
    800021f4:	4037d79b          	sraiw	a5,a5,0x3
    800021f8:	00f90633          	add	a2,s2,a5
    800021fc:	05864603          	lbu	a2,88(a2)
    80002200:	00c6f5b3          	and	a1,a3,a2
    80002204:	d5a1                	beqz	a1,8000214c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002206:	2705                	addiw	a4,a4,1
    80002208:	2485                	addiw	s1,s1,1
    8000220a:	fd471ae3          	bne	a4,s4,800021de <balloc+0xcc>
    8000220e:	bf49                	j	800021a0 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002210:	00005517          	auipc	a0,0x5
    80002214:	31050513          	addi	a0,a0,784 # 80007520 <syscalls+0x108>
    80002218:	737020ef          	jal	ra,8000514e <printf>
  return 0;
    8000221c:	4481                	li	s1,0
    8000221e:	b79d                	j	80002184 <balloc+0x72>

0000000080002220 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn) {
    80002220:	7139                	addi	sp,sp,-64
    80002222:	fc06                	sd	ra,56(sp)
    80002224:	f822                	sd	s0,48(sp)
    80002226:	f426                	sd	s1,40(sp)
    80002228:	f04a                	sd	s2,32(sp)
    8000222a:	ec4e                	sd	s3,24(sp)
    8000222c:	e852                	sd	s4,16(sp)
    8000222e:	e456                	sd	s5,8(sp)
    80002230:	0080                	addi	s0,sp,64
    80002232:	892a                	mv	s2,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
    80002234:	47a9                	li	a5,10
    80002236:	08b7f063          	bgeu	a5,a1,800022b6 <bmap+0x96>
        // Direct blocks
        if ((addr = ip->addrs[bn]) == 0)
            ip->addrs[bn] = addr = balloc(ip->dev);
        return addr;
    }
    bn -= NDIRECT;
    8000223a:	ff55849b          	addiw	s1,a1,-11
    8000223e:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT) {
    80002242:	0ff00793          	li	a5,255
    80002246:	08e7fa63          	bgeu	a5,a4,800022da <bmap+0xba>
            log_write(bp);
        }
        brelse(bp);
        return addr;
    }
    bn -= NINDIRECT;
    8000224a:	ef55849b          	addiw	s1,a1,-267

    // Doubly indirect blocks
    if ((addr = ip->addrs[NDIRECT+1]) == 0)
    8000224e:	08052583          	lw	a1,128(a0)
    80002252:	0c058e63          	beqz	a1,8000232e <bmap+0x10e>
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002256:	00092503          	lw	a0,0(s2)
    8000225a:	c53ff0ef          	jal	ra,80001eac <bread>
    8000225e:	89aa                	mv	s3,a0
    a = (uint *)bp->data;

    uint indir_block = bn / NINDIRECT;
    uint indir_offset = bn % NINDIRECT;
    80002260:	0ff4fa93          	zext.b	s5,s1
    a = (uint *)bp->data;
    80002264:	05850793          	addi	a5,a0,88

    if ((addr = a[indir_block]) == 0) {
    80002268:	0084d59b          	srliw	a1,s1,0x8
    8000226c:	058a                	slli	a1,a1,0x2
    8000226e:	00b784b3          	add	s1,a5,a1
    80002272:	0004aa03          	lw	s4,0(s1)
    80002276:	0c0a0463          	beqz	s4,8000233e <bmap+0x11e>
        a[indir_block] = addr = balloc(ip->dev);
        log_write(bp);
    }
    brelse(bp);
    8000227a:	854e                	mv	a0,s3
    8000227c:	d39ff0ef          	jal	ra,80001fb4 <brelse>

    bp = bread(ip->dev, addr);
    80002280:	85d2                	mv	a1,s4
    80002282:	00092503          	lw	a0,0(s2)
    80002286:	c27ff0ef          	jal	ra,80001eac <bread>
    8000228a:	84aa                	mv	s1,a0
    a = (uint *)bp->data;
    8000228c:	05850a13          	addi	s4,a0,88
    if ((addr = a[indir_offset]) == 0) {
    80002290:	0a8a                	slli	s5,s5,0x2
    80002292:	9a56                	add	s4,s4,s5
    80002294:	000a2983          	lw	s3,0(s4) # 2000 <_entry-0x7fffe000>
    80002298:	0a098f63          	beqz	s3,80002356 <bmap+0x136>
        a[indir_offset] = addr = balloc(ip->dev);
        log_write(bp);
    }
    brelse(bp);
    8000229c:	8526                	mv	a0,s1
    8000229e:	d17ff0ef          	jal	ra,80001fb4 <brelse>

    return addr;
}
    800022a2:	854e                	mv	a0,s3
    800022a4:	70e2                	ld	ra,56(sp)
    800022a6:	7442                	ld	s0,48(sp)
    800022a8:	74a2                	ld	s1,40(sp)
    800022aa:	7902                	ld	s2,32(sp)
    800022ac:	69e2                	ld	s3,24(sp)
    800022ae:	6a42                	ld	s4,16(sp)
    800022b0:	6aa2                	ld	s5,8(sp)
    800022b2:	6121                	addi	sp,sp,64
    800022b4:	8082                	ret
        if ((addr = ip->addrs[bn]) == 0)
    800022b6:	02059793          	slli	a5,a1,0x20
    800022ba:	01e7d593          	srli	a1,a5,0x1e
    800022be:	00b504b3          	add	s1,a0,a1
    800022c2:	0504a983          	lw	s3,80(s1)
    800022c6:	fc099ee3          	bnez	s3,800022a2 <bmap+0x82>
            ip->addrs[bn] = addr = balloc(ip->dev);
    800022ca:	4108                	lw	a0,0(a0)
    800022cc:	e47ff0ef          	jal	ra,80002112 <balloc>
    800022d0:	0005099b          	sext.w	s3,a0
    800022d4:	0534a823          	sw	s3,80(s1)
    800022d8:	b7e9                	j	800022a2 <bmap+0x82>
        if ((addr = ip->addrs[NDIRECT]) == 0)
    800022da:	5d6c                	lw	a1,124(a0)
    800022dc:	c58d                	beqz	a1,80002306 <bmap+0xe6>
        bp = bread(ip->dev, addr);
    800022de:	00092503          	lw	a0,0(s2)
    800022e2:	bcbff0ef          	jal	ra,80001eac <bread>
    800022e6:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    800022e8:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0) {
    800022ec:	02049713          	slli	a4,s1,0x20
    800022f0:	01e75493          	srli	s1,a4,0x1e
    800022f4:	94be                	add	s1,s1,a5
    800022f6:	0004a983          	lw	s3,0(s1)
    800022fa:	00098e63          	beqz	s3,80002316 <bmap+0xf6>
        brelse(bp);
    800022fe:	8552                	mv	a0,s4
    80002300:	cb5ff0ef          	jal	ra,80001fb4 <brelse>
        return addr;
    80002304:	bf79                	j	800022a2 <bmap+0x82>
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002306:	4108                	lw	a0,0(a0)
    80002308:	e0bff0ef          	jal	ra,80002112 <balloc>
    8000230c:	0005059b          	sext.w	a1,a0
    80002310:	06b92e23          	sw	a1,124(s2)
    80002314:	b7e9                	j	800022de <bmap+0xbe>
            a[bn] = addr = balloc(ip->dev);
    80002316:	00092503          	lw	a0,0(s2)
    8000231a:	df9ff0ef          	jal	ra,80002112 <balloc>
    8000231e:	0005099b          	sext.w	s3,a0
    80002322:	0134a023          	sw	s3,0(s1)
            log_write(bp);
    80002326:	8552                	mv	a0,s4
    80002328:	539000ef          	jal	ra,80003060 <log_write>
    8000232c:	bfc9                	j	800022fe <bmap+0xde>
        ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    8000232e:	4108                	lw	a0,0(a0)
    80002330:	de3ff0ef          	jal	ra,80002112 <balloc>
    80002334:	0005059b          	sext.w	a1,a0
    80002338:	08b92023          	sw	a1,128(s2)
    8000233c:	bf29                	j	80002256 <bmap+0x36>
        a[indir_block] = addr = balloc(ip->dev);
    8000233e:	00092503          	lw	a0,0(s2)
    80002342:	dd1ff0ef          	jal	ra,80002112 <balloc>
    80002346:	00050a1b          	sext.w	s4,a0
    8000234a:	0144a023          	sw	s4,0(s1)
        log_write(bp);
    8000234e:	854e                	mv	a0,s3
    80002350:	511000ef          	jal	ra,80003060 <log_write>
    80002354:	b71d                	j	8000227a <bmap+0x5a>
        a[indir_offset] = addr = balloc(ip->dev);
    80002356:	00092503          	lw	a0,0(s2)
    8000235a:	db9ff0ef          	jal	ra,80002112 <balloc>
    8000235e:	0005099b          	sext.w	s3,a0
    80002362:	013a2023          	sw	s3,0(s4)
        log_write(bp);
    80002366:	8526                	mv	a0,s1
    80002368:	4f9000ef          	jal	ra,80003060 <log_write>
    8000236c:	bf05                	j	8000229c <bmap+0x7c>

000000008000236e <iget>:
{
    8000236e:	7179                	addi	sp,sp,-48
    80002370:	f406                	sd	ra,40(sp)
    80002372:	f022                	sd	s0,32(sp)
    80002374:	ec26                	sd	s1,24(sp)
    80002376:	e84a                	sd	s2,16(sp)
    80002378:	e44e                	sd	s3,8(sp)
    8000237a:	e052                	sd	s4,0(sp)
    8000237c:	1800                	addi	s0,sp,48
    8000237e:	89aa                	mv	s3,a0
    80002380:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002382:	0000f517          	auipc	a0,0xf
    80002386:	ee650513          	addi	a0,a0,-282 # 80011268 <itable>
    8000238a:	388030ef          	jal	ra,80005712 <acquire>
  empty = 0;
    8000238e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002390:	0000f497          	auipc	s1,0xf
    80002394:	ef048493          	addi	s1,s1,-272 # 80011280 <itable+0x18>
    80002398:	00011697          	auipc	a3,0x11
    8000239c:	97868693          	addi	a3,a3,-1672 # 80012d10 <log>
    800023a0:	a039                	j	800023ae <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023a2:	02090963          	beqz	s2,800023d4 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800023a6:	08848493          	addi	s1,s1,136
    800023aa:	02d48863          	beq	s1,a3,800023da <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800023ae:	449c                	lw	a5,8(s1)
    800023b0:	fef059e3          	blez	a5,800023a2 <iget+0x34>
    800023b4:	4098                	lw	a4,0(s1)
    800023b6:	ff3716e3          	bne	a4,s3,800023a2 <iget+0x34>
    800023ba:	40d8                	lw	a4,4(s1)
    800023bc:	ff4713e3          	bne	a4,s4,800023a2 <iget+0x34>
      ip->ref++;
    800023c0:	2785                	addiw	a5,a5,1
    800023c2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800023c4:	0000f517          	auipc	a0,0xf
    800023c8:	ea450513          	addi	a0,a0,-348 # 80011268 <itable>
    800023cc:	3de030ef          	jal	ra,800057aa <release>
      return ip;
    800023d0:	8926                	mv	s2,s1
    800023d2:	a02d                	j	800023fc <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800023d4:	fbe9                	bnez	a5,800023a6 <iget+0x38>
    800023d6:	8926                	mv	s2,s1
    800023d8:	b7f9                	j	800023a6 <iget+0x38>
  if(empty == 0)
    800023da:	02090a63          	beqz	s2,8000240e <iget+0xa0>
  ip->dev = dev;
    800023de:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800023e2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800023e6:	4785                	li	a5,1
    800023e8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800023ec:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800023f0:	0000f517          	auipc	a0,0xf
    800023f4:	e7850513          	addi	a0,a0,-392 # 80011268 <itable>
    800023f8:	3b2030ef          	jal	ra,800057aa <release>
}
    800023fc:	854a                	mv	a0,s2
    800023fe:	70a2                	ld	ra,40(sp)
    80002400:	7402                	ld	s0,32(sp)
    80002402:	64e2                	ld	s1,24(sp)
    80002404:	6942                	ld	s2,16(sp)
    80002406:	69a2                	ld	s3,8(sp)
    80002408:	6a02                	ld	s4,0(sp)
    8000240a:	6145                	addi	sp,sp,48
    8000240c:	8082                	ret
    panic("iget: no inodes");
    8000240e:	00005517          	auipc	a0,0x5
    80002412:	12a50513          	addi	a0,a0,298 # 80007538 <syscalls+0x120>
    80002416:	7ed020ef          	jal	ra,80005402 <panic>

000000008000241a <fsinit>:
fsinit(int dev) {
    8000241a:	7179                	addi	sp,sp,-48
    8000241c:	f406                	sd	ra,40(sp)
    8000241e:	f022                	sd	s0,32(sp)
    80002420:	ec26                	sd	s1,24(sp)
    80002422:	e84a                	sd	s2,16(sp)
    80002424:	e44e                	sd	s3,8(sp)
    80002426:	1800                	addi	s0,sp,48
    80002428:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000242a:	4585                	li	a1,1
    8000242c:	a81ff0ef          	jal	ra,80001eac <bread>
    80002430:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002432:	0000f997          	auipc	s3,0xf
    80002436:	e1698993          	addi	s3,s3,-490 # 80011248 <sb>
    8000243a:	02000613          	li	a2,32
    8000243e:	05850593          	addi	a1,a0,88
    80002442:	854e                	mv	a0,s3
    80002444:	d67fd0ef          	jal	ra,800001aa <memmove>
  brelse(bp);
    80002448:	8526                	mv	a0,s1
    8000244a:	b6bff0ef          	jal	ra,80001fb4 <brelse>
  if(sb.magic != FSMAGIC)
    8000244e:	0009a703          	lw	a4,0(s3)
    80002452:	102037b7          	lui	a5,0x10203
    80002456:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000245a:	02f71063          	bne	a4,a5,8000247a <fsinit+0x60>
  initlog(dev, &sb);
    8000245e:	0000f597          	auipc	a1,0xf
    80002462:	dea58593          	addi	a1,a1,-534 # 80011248 <sb>
    80002466:	854a                	mv	a0,s2
    80002468:	1e5000ef          	jal	ra,80002e4c <initlog>
}
    8000246c:	70a2                	ld	ra,40(sp)
    8000246e:	7402                	ld	s0,32(sp)
    80002470:	64e2                	ld	s1,24(sp)
    80002472:	6942                	ld	s2,16(sp)
    80002474:	69a2                	ld	s3,8(sp)
    80002476:	6145                	addi	sp,sp,48
    80002478:	8082                	ret
    panic("invalid file system");
    8000247a:	00005517          	auipc	a0,0x5
    8000247e:	0ce50513          	addi	a0,a0,206 # 80007548 <syscalls+0x130>
    80002482:	781020ef          	jal	ra,80005402 <panic>

0000000080002486 <iinit>:
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002494:	00005597          	auipc	a1,0x5
    80002498:	0cc58593          	addi	a1,a1,204 # 80007560 <syscalls+0x148>
    8000249c:	0000f517          	auipc	a0,0xf
    800024a0:	dcc50513          	addi	a0,a0,-564 # 80011268 <itable>
    800024a4:	1ee030ef          	jal	ra,80005692 <initlock>
  for(i = 0; i < NINODE; i++) {
    800024a8:	0000f497          	auipc	s1,0xf
    800024ac:	de848493          	addi	s1,s1,-536 # 80011290 <itable+0x28>
    800024b0:	00011997          	auipc	s3,0x11
    800024b4:	87098993          	addi	s3,s3,-1936 # 80012d20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024b8:	00005917          	auipc	s2,0x5
    800024bc:	0b090913          	addi	s2,s2,176 # 80007568 <syscalls+0x150>
    800024c0:	85ca                	mv	a1,s2
    800024c2:	8526                	mv	a0,s1
    800024c4:	46d000ef          	jal	ra,80003130 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024c8:	08848493          	addi	s1,s1,136
    800024cc:	ff349ae3          	bne	s1,s3,800024c0 <iinit+0x3a>
}
    800024d0:	70a2                	ld	ra,40(sp)
    800024d2:	7402                	ld	s0,32(sp)
    800024d4:	64e2                	ld	s1,24(sp)
    800024d6:	6942                	ld	s2,16(sp)
    800024d8:	69a2                	ld	s3,8(sp)
    800024da:	6145                	addi	sp,sp,48
    800024dc:	8082                	ret

00000000800024de <ialloc>:
{
    800024de:	715d                	addi	sp,sp,-80
    800024e0:	e486                	sd	ra,72(sp)
    800024e2:	e0a2                	sd	s0,64(sp)
    800024e4:	fc26                	sd	s1,56(sp)
    800024e6:	f84a                	sd	s2,48(sp)
    800024e8:	f44e                	sd	s3,40(sp)
    800024ea:	f052                	sd	s4,32(sp)
    800024ec:	ec56                	sd	s5,24(sp)
    800024ee:	e85a                	sd	s6,16(sp)
    800024f0:	e45e                	sd	s7,8(sp)
    800024f2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800024f4:	0000f717          	auipc	a4,0xf
    800024f8:	d6072703          	lw	a4,-672(a4) # 80011254 <sb+0xc>
    800024fc:	4785                	li	a5,1
    800024fe:	04e7f663          	bgeu	a5,a4,8000254a <ialloc+0x6c>
    80002502:	8aaa                	mv	s5,a0
    80002504:	8bae                	mv	s7,a1
    80002506:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002508:	0000fa17          	auipc	s4,0xf
    8000250c:	d40a0a13          	addi	s4,s4,-704 # 80011248 <sb>
    80002510:	00048b1b          	sext.w	s6,s1
    80002514:	0044d593          	srli	a1,s1,0x4
    80002518:	018a2783          	lw	a5,24(s4)
    8000251c:	9dbd                	addw	a1,a1,a5
    8000251e:	8556                	mv	a0,s5
    80002520:	98dff0ef          	jal	ra,80001eac <bread>
    80002524:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002526:	05850993          	addi	s3,a0,88
    8000252a:	00f4f793          	andi	a5,s1,15
    8000252e:	079a                	slli	a5,a5,0x6
    80002530:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002532:	00099783          	lh	a5,0(s3)
    80002536:	cf85                	beqz	a5,8000256e <ialloc+0x90>
    brelse(bp);
    80002538:	a7dff0ef          	jal	ra,80001fb4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000253c:	0485                	addi	s1,s1,1
    8000253e:	00ca2703          	lw	a4,12(s4)
    80002542:	0004879b          	sext.w	a5,s1
    80002546:	fce7e5e3          	bltu	a5,a4,80002510 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    8000254a:	00005517          	auipc	a0,0x5
    8000254e:	02650513          	addi	a0,a0,38 # 80007570 <syscalls+0x158>
    80002552:	3fd020ef          	jal	ra,8000514e <printf>
  return 0;
    80002556:	4501                	li	a0,0
}
    80002558:	60a6                	ld	ra,72(sp)
    8000255a:	6406                	ld	s0,64(sp)
    8000255c:	74e2                	ld	s1,56(sp)
    8000255e:	7942                	ld	s2,48(sp)
    80002560:	79a2                	ld	s3,40(sp)
    80002562:	7a02                	ld	s4,32(sp)
    80002564:	6ae2                	ld	s5,24(sp)
    80002566:	6b42                	ld	s6,16(sp)
    80002568:	6ba2                	ld	s7,8(sp)
    8000256a:	6161                	addi	sp,sp,80
    8000256c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000256e:	04000613          	li	a2,64
    80002572:	4581                	li	a1,0
    80002574:	854e                	mv	a0,s3
    80002576:	bd9fd0ef          	jal	ra,8000014e <memset>
      dip->type = type;
    8000257a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000257e:	854a                	mv	a0,s2
    80002580:	2e1000ef          	jal	ra,80003060 <log_write>
      brelse(bp);
    80002584:	854a                	mv	a0,s2
    80002586:	a2fff0ef          	jal	ra,80001fb4 <brelse>
      return iget(dev, inum);
    8000258a:	85da                	mv	a1,s6
    8000258c:	8556                	mv	a0,s5
    8000258e:	de1ff0ef          	jal	ra,8000236e <iget>
    80002592:	b7d9                	j	80002558 <ialloc+0x7a>

0000000080002594 <iupdate>:
{
    80002594:	1101                	addi	sp,sp,-32
    80002596:	ec06                	sd	ra,24(sp)
    80002598:	e822                	sd	s0,16(sp)
    8000259a:	e426                	sd	s1,8(sp)
    8000259c:	e04a                	sd	s2,0(sp)
    8000259e:	1000                	addi	s0,sp,32
    800025a0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025a2:	415c                	lw	a5,4(a0)
    800025a4:	0047d79b          	srliw	a5,a5,0x4
    800025a8:	0000f597          	auipc	a1,0xf
    800025ac:	cb85a583          	lw	a1,-840(a1) # 80011260 <sb+0x18>
    800025b0:	9dbd                	addw	a1,a1,a5
    800025b2:	4108                	lw	a0,0(a0)
    800025b4:	8f9ff0ef          	jal	ra,80001eac <bread>
    800025b8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025ba:	05850793          	addi	a5,a0,88
    800025be:	40d8                	lw	a4,4(s1)
    800025c0:	8b3d                	andi	a4,a4,15
    800025c2:	071a                	slli	a4,a4,0x6
    800025c4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025c6:	04449703          	lh	a4,68(s1)
    800025ca:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025ce:	04649703          	lh	a4,70(s1)
    800025d2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025d6:	04849703          	lh	a4,72(s1)
    800025da:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025de:	04a49703          	lh	a4,74(s1)
    800025e2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025e6:	44f8                	lw	a4,76(s1)
    800025e8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025ea:	03400613          	li	a2,52
    800025ee:	05048593          	addi	a1,s1,80
    800025f2:	00c78513          	addi	a0,a5,12
    800025f6:	bb5fd0ef          	jal	ra,800001aa <memmove>
  log_write(bp);
    800025fa:	854a                	mv	a0,s2
    800025fc:	265000ef          	jal	ra,80003060 <log_write>
  brelse(bp);
    80002600:	854a                	mv	a0,s2
    80002602:	9b3ff0ef          	jal	ra,80001fb4 <brelse>
}
    80002606:	60e2                	ld	ra,24(sp)
    80002608:	6442                	ld	s0,16(sp)
    8000260a:	64a2                	ld	s1,8(sp)
    8000260c:	6902                	ld	s2,0(sp)
    8000260e:	6105                	addi	sp,sp,32
    80002610:	8082                	ret

0000000080002612 <idup>:
{
    80002612:	1101                	addi	sp,sp,-32
    80002614:	ec06                	sd	ra,24(sp)
    80002616:	e822                	sd	s0,16(sp)
    80002618:	e426                	sd	s1,8(sp)
    8000261a:	1000                	addi	s0,sp,32
    8000261c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000261e:	0000f517          	auipc	a0,0xf
    80002622:	c4a50513          	addi	a0,a0,-950 # 80011268 <itable>
    80002626:	0ec030ef          	jal	ra,80005712 <acquire>
  ip->ref++;
    8000262a:	449c                	lw	a5,8(s1)
    8000262c:	2785                	addiw	a5,a5,1
    8000262e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002630:	0000f517          	auipc	a0,0xf
    80002634:	c3850513          	addi	a0,a0,-968 # 80011268 <itable>
    80002638:	172030ef          	jal	ra,800057aa <release>
}
    8000263c:	8526                	mv	a0,s1
    8000263e:	60e2                	ld	ra,24(sp)
    80002640:	6442                	ld	s0,16(sp)
    80002642:	64a2                	ld	s1,8(sp)
    80002644:	6105                	addi	sp,sp,32
    80002646:	8082                	ret

0000000080002648 <ilock>:
{
    80002648:	1101                	addi	sp,sp,-32
    8000264a:	ec06                	sd	ra,24(sp)
    8000264c:	e822                	sd	s0,16(sp)
    8000264e:	e426                	sd	s1,8(sp)
    80002650:	e04a                	sd	s2,0(sp)
    80002652:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002654:	c105                	beqz	a0,80002674 <ilock+0x2c>
    80002656:	84aa                	mv	s1,a0
    80002658:	451c                	lw	a5,8(a0)
    8000265a:	00f05d63          	blez	a5,80002674 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000265e:	0541                	addi	a0,a0,16
    80002660:	307000ef          	jal	ra,80003166 <acquiresleep>
  if(ip->valid == 0){
    80002664:	40bc                	lw	a5,64(s1)
    80002666:	cf89                	beqz	a5,80002680 <ilock+0x38>
}
    80002668:	60e2                	ld	ra,24(sp)
    8000266a:	6442                	ld	s0,16(sp)
    8000266c:	64a2                	ld	s1,8(sp)
    8000266e:	6902                	ld	s2,0(sp)
    80002670:	6105                	addi	sp,sp,32
    80002672:	8082                	ret
    panic("ilock");
    80002674:	00005517          	auipc	a0,0x5
    80002678:	f1450513          	addi	a0,a0,-236 # 80007588 <syscalls+0x170>
    8000267c:	587020ef          	jal	ra,80005402 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002680:	40dc                	lw	a5,4(s1)
    80002682:	0047d79b          	srliw	a5,a5,0x4
    80002686:	0000f597          	auipc	a1,0xf
    8000268a:	bda5a583          	lw	a1,-1062(a1) # 80011260 <sb+0x18>
    8000268e:	9dbd                	addw	a1,a1,a5
    80002690:	4088                	lw	a0,0(s1)
    80002692:	81bff0ef          	jal	ra,80001eac <bread>
    80002696:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002698:	05850593          	addi	a1,a0,88
    8000269c:	40dc                	lw	a5,4(s1)
    8000269e:	8bbd                	andi	a5,a5,15
    800026a0:	079a                	slli	a5,a5,0x6
    800026a2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026a4:	00059783          	lh	a5,0(a1)
    800026a8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026ac:	00259783          	lh	a5,2(a1)
    800026b0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026b4:	00459783          	lh	a5,4(a1)
    800026b8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026bc:	00659783          	lh	a5,6(a1)
    800026c0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026c4:	459c                	lw	a5,8(a1)
    800026c6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026c8:	03400613          	li	a2,52
    800026cc:	05b1                	addi	a1,a1,12
    800026ce:	05048513          	addi	a0,s1,80
    800026d2:	ad9fd0ef          	jal	ra,800001aa <memmove>
    brelse(bp);
    800026d6:	854a                	mv	a0,s2
    800026d8:	8ddff0ef          	jal	ra,80001fb4 <brelse>
    ip->valid = 1;
    800026dc:	4785                	li	a5,1
    800026de:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026e0:	04449783          	lh	a5,68(s1)
    800026e4:	f3d1                	bnez	a5,80002668 <ilock+0x20>
      panic("ilock: no type");
    800026e6:	00005517          	auipc	a0,0x5
    800026ea:	eaa50513          	addi	a0,a0,-342 # 80007590 <syscalls+0x178>
    800026ee:	515020ef          	jal	ra,80005402 <panic>

00000000800026f2 <iunlock>:
{
    800026f2:	1101                	addi	sp,sp,-32
    800026f4:	ec06                	sd	ra,24(sp)
    800026f6:	e822                	sd	s0,16(sp)
    800026f8:	e426                	sd	s1,8(sp)
    800026fa:	e04a                	sd	s2,0(sp)
    800026fc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800026fe:	c505                	beqz	a0,80002726 <iunlock+0x34>
    80002700:	84aa                	mv	s1,a0
    80002702:	01050913          	addi	s2,a0,16
    80002706:	854a                	mv	a0,s2
    80002708:	2dd000ef          	jal	ra,800031e4 <holdingsleep>
    8000270c:	cd09                	beqz	a0,80002726 <iunlock+0x34>
    8000270e:	449c                	lw	a5,8(s1)
    80002710:	00f05b63          	blez	a5,80002726 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002714:	854a                	mv	a0,s2
    80002716:	297000ef          	jal	ra,800031ac <releasesleep>
}
    8000271a:	60e2                	ld	ra,24(sp)
    8000271c:	6442                	ld	s0,16(sp)
    8000271e:	64a2                	ld	s1,8(sp)
    80002720:	6902                	ld	s2,0(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret
    panic("iunlock");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	e7a50513          	addi	a0,a0,-390 # 800075a0 <syscalls+0x188>
    8000272e:	4d5020ef          	jal	ra,80005402 <panic>

0000000080002732 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002732:	7179                	addi	sp,sp,-48
    80002734:	f406                	sd	ra,40(sp)
    80002736:	f022                	sd	s0,32(sp)
    80002738:	ec26                	sd	s1,24(sp)
    8000273a:	e84a                	sd	s2,16(sp)
    8000273c:	e44e                	sd	s3,8(sp)
    8000273e:	e052                	sd	s4,0(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002744:	05050493          	addi	s1,a0,80
    80002748:	07c50913          	addi	s2,a0,124
    8000274c:	a021                	j	80002754 <itrunc+0x22>
    8000274e:	0491                	addi	s1,s1,4
    80002750:	01248b63          	beq	s1,s2,80002766 <itrunc+0x34>
    if(ip->addrs[i]){
    80002754:	408c                	lw	a1,0(s1)
    80002756:	dde5                	beqz	a1,8000274e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002758:	0009a503          	lw	a0,0(s3)
    8000275c:	94bff0ef          	jal	ra,800020a6 <bfree>
      ip->addrs[i] = 0;
    80002760:	0004a023          	sw	zero,0(s1)
    80002764:	b7ed                	j	8000274e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002766:	07c9a583          	lw	a1,124(s3)
    8000276a:	ed91                	bnez	a1,80002786 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000276c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002770:	854e                	mv	a0,s3
    80002772:	e23ff0ef          	jal	ra,80002594 <iupdate>
}
    80002776:	70a2                	ld	ra,40(sp)
    80002778:	7402                	ld	s0,32(sp)
    8000277a:	64e2                	ld	s1,24(sp)
    8000277c:	6942                	ld	s2,16(sp)
    8000277e:	69a2                	ld	s3,8(sp)
    80002780:	6a02                	ld	s4,0(sp)
    80002782:	6145                	addi	sp,sp,48
    80002784:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002786:	0009a503          	lw	a0,0(s3)
    8000278a:	f22ff0ef          	jal	ra,80001eac <bread>
    8000278e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002790:	05850493          	addi	s1,a0,88
    80002794:	45850913          	addi	s2,a0,1112
    80002798:	a021                	j	800027a0 <itrunc+0x6e>
    8000279a:	0491                	addi	s1,s1,4
    8000279c:	01248963          	beq	s1,s2,800027ae <itrunc+0x7c>
      if(a[j])
    800027a0:	408c                	lw	a1,0(s1)
    800027a2:	dde5                	beqz	a1,8000279a <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800027a4:	0009a503          	lw	a0,0(s3)
    800027a8:	8ffff0ef          	jal	ra,800020a6 <bfree>
    800027ac:	b7fd                	j	8000279a <itrunc+0x68>
    brelse(bp);
    800027ae:	8552                	mv	a0,s4
    800027b0:	805ff0ef          	jal	ra,80001fb4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027b4:	07c9a583          	lw	a1,124(s3)
    800027b8:	0009a503          	lw	a0,0(s3)
    800027bc:	8ebff0ef          	jal	ra,800020a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027c0:	0609ae23          	sw	zero,124(s3)
    800027c4:	b765                	j	8000276c <itrunc+0x3a>

00000000800027c6 <iput>:
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	e04a                	sd	s2,0(sp)
    800027d0:	1000                	addi	s0,sp,32
    800027d2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027d4:	0000f517          	auipc	a0,0xf
    800027d8:	a9450513          	addi	a0,a0,-1388 # 80011268 <itable>
    800027dc:	737020ef          	jal	ra,80005712 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027e0:	4498                	lw	a4,8(s1)
    800027e2:	4785                	li	a5,1
    800027e4:	02f70163          	beq	a4,a5,80002806 <iput+0x40>
  ip->ref--;
    800027e8:	449c                	lw	a5,8(s1)
    800027ea:	37fd                	addiw	a5,a5,-1
    800027ec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800027ee:	0000f517          	auipc	a0,0xf
    800027f2:	a7a50513          	addi	a0,a0,-1414 # 80011268 <itable>
    800027f6:	7b5020ef          	jal	ra,800057aa <release>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6902                	ld	s2,0(sp)
    80002802:	6105                	addi	sp,sp,32
    80002804:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002806:	40bc                	lw	a5,64(s1)
    80002808:	d3e5                	beqz	a5,800027e8 <iput+0x22>
    8000280a:	04a49783          	lh	a5,74(s1)
    8000280e:	ffe9                	bnez	a5,800027e8 <iput+0x22>
    acquiresleep(&ip->lock);
    80002810:	01048913          	addi	s2,s1,16
    80002814:	854a                	mv	a0,s2
    80002816:	151000ef          	jal	ra,80003166 <acquiresleep>
    release(&itable.lock);
    8000281a:	0000f517          	auipc	a0,0xf
    8000281e:	a4e50513          	addi	a0,a0,-1458 # 80011268 <itable>
    80002822:	789020ef          	jal	ra,800057aa <release>
    itrunc(ip);
    80002826:	8526                	mv	a0,s1
    80002828:	f0bff0ef          	jal	ra,80002732 <itrunc>
    ip->type = 0;
    8000282c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002830:	8526                	mv	a0,s1
    80002832:	d63ff0ef          	jal	ra,80002594 <iupdate>
    ip->valid = 0;
    80002836:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000283a:	854a                	mv	a0,s2
    8000283c:	171000ef          	jal	ra,800031ac <releasesleep>
    acquire(&itable.lock);
    80002840:	0000f517          	auipc	a0,0xf
    80002844:	a2850513          	addi	a0,a0,-1496 # 80011268 <itable>
    80002848:	6cb020ef          	jal	ra,80005712 <acquire>
    8000284c:	bf71                	j	800027e8 <iput+0x22>

000000008000284e <iunlockput>:
{
    8000284e:	1101                	addi	sp,sp,-32
    80002850:	ec06                	sd	ra,24(sp)
    80002852:	e822                	sd	s0,16(sp)
    80002854:	e426                	sd	s1,8(sp)
    80002856:	1000                	addi	s0,sp,32
    80002858:	84aa                	mv	s1,a0
  iunlock(ip);
    8000285a:	e99ff0ef          	jal	ra,800026f2 <iunlock>
  iput(ip);
    8000285e:	8526                	mv	a0,s1
    80002860:	f67ff0ef          	jal	ra,800027c6 <iput>
}
    80002864:	60e2                	ld	ra,24(sp)
    80002866:	6442                	ld	s0,16(sp)
    80002868:	64a2                	ld	s1,8(sp)
    8000286a:	6105                	addi	sp,sp,32
    8000286c:	8082                	ret

000000008000286e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000286e:	1141                	addi	sp,sp,-16
    80002870:	e422                	sd	s0,8(sp)
    80002872:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002874:	411c                	lw	a5,0(a0)
    80002876:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002878:	415c                	lw	a5,4(a0)
    8000287a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000287c:	04451783          	lh	a5,68(a0)
    80002880:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002884:	04a51783          	lh	a5,74(a0)
    80002888:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000288c:	04c56783          	lwu	a5,76(a0)
    80002890:	e99c                	sd	a5,16(a1)
}
    80002892:	6422                	ld	s0,8(sp)
    80002894:	0141                	addi	sp,sp,16
    80002896:	8082                	ret

0000000080002898 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002898:	457c                	lw	a5,76(a0)
    8000289a:	0cd7ef63          	bltu	a5,a3,80002978 <readi+0xe0>
{
    8000289e:	7159                	addi	sp,sp,-112
    800028a0:	f486                	sd	ra,104(sp)
    800028a2:	f0a2                	sd	s0,96(sp)
    800028a4:	eca6                	sd	s1,88(sp)
    800028a6:	e8ca                	sd	s2,80(sp)
    800028a8:	e4ce                	sd	s3,72(sp)
    800028aa:	e0d2                	sd	s4,64(sp)
    800028ac:	fc56                	sd	s5,56(sp)
    800028ae:	f85a                	sd	s6,48(sp)
    800028b0:	f45e                	sd	s7,40(sp)
    800028b2:	f062                	sd	s8,32(sp)
    800028b4:	ec66                	sd	s9,24(sp)
    800028b6:	e86a                	sd	s10,16(sp)
    800028b8:	e46e                	sd	s11,8(sp)
    800028ba:	1880                	addi	s0,sp,112
    800028bc:	8b2a                	mv	s6,a0
    800028be:	8bae                	mv	s7,a1
    800028c0:	8a32                	mv	s4,a2
    800028c2:	84b6                	mv	s1,a3
    800028c4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800028c6:	9f35                	addw	a4,a4,a3
    return 0;
    800028c8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800028ca:	08d76663          	bltu	a4,a3,80002956 <readi+0xbe>
  if(off + n > ip->size)
    800028ce:	00e7f463          	bgeu	a5,a4,800028d6 <readi+0x3e>
    n = ip->size - off;
    800028d2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028d6:	080a8f63          	beqz	s5,80002974 <readi+0xdc>
    800028da:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800028dc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800028e0:	5c7d                	li	s8,-1
    800028e2:	a80d                	j	80002914 <readi+0x7c>
    800028e4:	020d1d93          	slli	s11,s10,0x20
    800028e8:	020ddd93          	srli	s11,s11,0x20
    800028ec:	05890613          	addi	a2,s2,88
    800028f0:	86ee                	mv	a3,s11
    800028f2:	963a                	add	a2,a2,a4
    800028f4:	85d2                	mv	a1,s4
    800028f6:	855e                	mv	a0,s7
    800028f8:	d3ffe0ef          	jal	ra,80001636 <either_copyout>
    800028fc:	05850763          	beq	a0,s8,8000294a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002900:	854a                	mv	a0,s2
    80002902:	eb2ff0ef          	jal	ra,80001fb4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002906:	013d09bb          	addw	s3,s10,s3
    8000290a:	009d04bb          	addw	s1,s10,s1
    8000290e:	9a6e                	add	s4,s4,s11
    80002910:	0559f163          	bgeu	s3,s5,80002952 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80002914:	00a4d59b          	srliw	a1,s1,0xa
    80002918:	855a                	mv	a0,s6
    8000291a:	907ff0ef          	jal	ra,80002220 <bmap>
    8000291e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002922:	c985                	beqz	a1,80002952 <readi+0xba>
    bp = bread(ip->dev, addr);
    80002924:	000b2503          	lw	a0,0(s6)
    80002928:	d84ff0ef          	jal	ra,80001eac <bread>
    8000292c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000292e:	3ff4f713          	andi	a4,s1,1023
    80002932:	40ec87bb          	subw	a5,s9,a4
    80002936:	413a86bb          	subw	a3,s5,s3
    8000293a:	8d3e                	mv	s10,a5
    8000293c:	2781                	sext.w	a5,a5
    8000293e:	0006861b          	sext.w	a2,a3
    80002942:	faf671e3          	bgeu	a2,a5,800028e4 <readi+0x4c>
    80002946:	8d36                	mv	s10,a3
    80002948:	bf71                	j	800028e4 <readi+0x4c>
      brelse(bp);
    8000294a:	854a                	mv	a0,s2
    8000294c:	e68ff0ef          	jal	ra,80001fb4 <brelse>
      tot = -1;
    80002950:	59fd                	li	s3,-1
  }
  return tot;
    80002952:	0009851b          	sext.w	a0,s3
}
    80002956:	70a6                	ld	ra,104(sp)
    80002958:	7406                	ld	s0,96(sp)
    8000295a:	64e6                	ld	s1,88(sp)
    8000295c:	6946                	ld	s2,80(sp)
    8000295e:	69a6                	ld	s3,72(sp)
    80002960:	6a06                	ld	s4,64(sp)
    80002962:	7ae2                	ld	s5,56(sp)
    80002964:	7b42                	ld	s6,48(sp)
    80002966:	7ba2                	ld	s7,40(sp)
    80002968:	7c02                	ld	s8,32(sp)
    8000296a:	6ce2                	ld	s9,24(sp)
    8000296c:	6d42                	ld	s10,16(sp)
    8000296e:	6da2                	ld	s11,8(sp)
    80002970:	6165                	addi	sp,sp,112
    80002972:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002974:	89d6                	mv	s3,s5
    80002976:	bff1                	j	80002952 <readi+0xba>
    return 0;
    80002978:	4501                	li	a0,0
}
    8000297a:	8082                	ret

000000008000297c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000297c:	457c                	lw	a5,76(a0)
    8000297e:	0ed7eb63          	bltu	a5,a3,80002a74 <writei+0xf8>
{
    80002982:	7159                	addi	sp,sp,-112
    80002984:	f486                	sd	ra,104(sp)
    80002986:	f0a2                	sd	s0,96(sp)
    80002988:	eca6                	sd	s1,88(sp)
    8000298a:	e8ca                	sd	s2,80(sp)
    8000298c:	e4ce                	sd	s3,72(sp)
    8000298e:	e0d2                	sd	s4,64(sp)
    80002990:	fc56                	sd	s5,56(sp)
    80002992:	f85a                	sd	s6,48(sp)
    80002994:	f45e                	sd	s7,40(sp)
    80002996:	f062                	sd	s8,32(sp)
    80002998:	ec66                	sd	s9,24(sp)
    8000299a:	e86a                	sd	s10,16(sp)
    8000299c:	e46e                	sd	s11,8(sp)
    8000299e:	1880                	addi	s0,sp,112
    800029a0:	8aaa                	mv	s5,a0
    800029a2:	8bae                	mv	s7,a1
    800029a4:	8a32                	mv	s4,a2
    800029a6:	8936                	mv	s2,a3
    800029a8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800029aa:	9f35                	addw	a4,a4,a3
    800029ac:	0cd76663          	bltu	a4,a3,80002a78 <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800029b0:	040437b7          	lui	a5,0x4043
    800029b4:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    800029b8:	0ce7e263          	bltu	a5,a4,80002a7c <writei+0x100>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029bc:	0a0b0a63          	beqz	s6,80002a70 <writei+0xf4>
    800029c0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029c2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800029c6:	5c7d                	li	s8,-1
    800029c8:	a825                	j	80002a00 <writei+0x84>
    800029ca:	020d1d93          	slli	s11,s10,0x20
    800029ce:	020ddd93          	srli	s11,s11,0x20
    800029d2:	05848513          	addi	a0,s1,88
    800029d6:	86ee                	mv	a3,s11
    800029d8:	8652                	mv	a2,s4
    800029da:	85de                	mv	a1,s7
    800029dc:	953a                	add	a0,a0,a4
    800029de:	ca3fe0ef          	jal	ra,80001680 <either_copyin>
    800029e2:	05850a63          	beq	a0,s8,80002a36 <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    800029e6:	8526                	mv	a0,s1
    800029e8:	678000ef          	jal	ra,80003060 <log_write>
    brelse(bp);
    800029ec:	8526                	mv	a0,s1
    800029ee:	dc6ff0ef          	jal	ra,80001fb4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029f2:	013d09bb          	addw	s3,s10,s3
    800029f6:	012d093b          	addw	s2,s10,s2
    800029fa:	9a6e                	add	s4,s4,s11
    800029fc:	0569f063          	bgeu	s3,s6,80002a3c <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    80002a00:	00a9559b          	srliw	a1,s2,0xa
    80002a04:	8556                	mv	a0,s5
    80002a06:	81bff0ef          	jal	ra,80002220 <bmap>
    80002a0a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a0e:	c59d                	beqz	a1,80002a3c <writei+0xc0>
    bp = bread(ip->dev, addr);
    80002a10:	000aa503          	lw	a0,0(s5)
    80002a14:	c98ff0ef          	jal	ra,80001eac <bread>
    80002a18:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a1a:	3ff97713          	andi	a4,s2,1023
    80002a1e:	40ec87bb          	subw	a5,s9,a4
    80002a22:	413b06bb          	subw	a3,s6,s3
    80002a26:	8d3e                	mv	s10,a5
    80002a28:	2781                	sext.w	a5,a5
    80002a2a:	0006861b          	sext.w	a2,a3
    80002a2e:	f8f67ee3          	bgeu	a2,a5,800029ca <writei+0x4e>
    80002a32:	8d36                	mv	s10,a3
    80002a34:	bf59                	j	800029ca <writei+0x4e>
      brelse(bp);
    80002a36:	8526                	mv	a0,s1
    80002a38:	d7cff0ef          	jal	ra,80001fb4 <brelse>
  }

  if(off > ip->size)
    80002a3c:	04caa783          	lw	a5,76(s5)
    80002a40:	0127f463          	bgeu	a5,s2,80002a48 <writei+0xcc>
    ip->size = off;
    80002a44:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002a48:	8556                	mv	a0,s5
    80002a4a:	b4bff0ef          	jal	ra,80002594 <iupdate>

  return tot;
    80002a4e:	0009851b          	sext.w	a0,s3
}
    80002a52:	70a6                	ld	ra,104(sp)
    80002a54:	7406                	ld	s0,96(sp)
    80002a56:	64e6                	ld	s1,88(sp)
    80002a58:	6946                	ld	s2,80(sp)
    80002a5a:	69a6                	ld	s3,72(sp)
    80002a5c:	6a06                	ld	s4,64(sp)
    80002a5e:	7ae2                	ld	s5,56(sp)
    80002a60:	7b42                	ld	s6,48(sp)
    80002a62:	7ba2                	ld	s7,40(sp)
    80002a64:	7c02                	ld	s8,32(sp)
    80002a66:	6ce2                	ld	s9,24(sp)
    80002a68:	6d42                	ld	s10,16(sp)
    80002a6a:	6da2                	ld	s11,8(sp)
    80002a6c:	6165                	addi	sp,sp,112
    80002a6e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002a70:	89da                	mv	s3,s6
    80002a72:	bfd9                	j	80002a48 <writei+0xcc>
    return -1;
    80002a74:	557d                	li	a0,-1
}
    80002a76:	8082                	ret
    return -1;
    80002a78:	557d                	li	a0,-1
    80002a7a:	bfe1                	j	80002a52 <writei+0xd6>
    return -1;
    80002a7c:	557d                	li	a0,-1
    80002a7e:	bfd1                	j	80002a52 <writei+0xd6>

0000000080002a80 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002a80:	1141                	addi	sp,sp,-16
    80002a82:	e406                	sd	ra,8(sp)
    80002a84:	e022                	sd	s0,0(sp)
    80002a86:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a88:	4639                	li	a2,14
    80002a8a:	f90fd0ef          	jal	ra,8000021a <strncmp>
}
    80002a8e:	60a2                	ld	ra,8(sp)
    80002a90:	6402                	ld	s0,0(sp)
    80002a92:	0141                	addi	sp,sp,16
    80002a94:	8082                	ret

0000000080002a96 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002a96:	7139                	addi	sp,sp,-64
    80002a98:	fc06                	sd	ra,56(sp)
    80002a9a:	f822                	sd	s0,48(sp)
    80002a9c:	f426                	sd	s1,40(sp)
    80002a9e:	f04a                	sd	s2,32(sp)
    80002aa0:	ec4e                	sd	s3,24(sp)
    80002aa2:	e852                	sd	s4,16(sp)
    80002aa4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002aa6:	04451703          	lh	a4,68(a0)
    80002aaa:	4785                	li	a5,1
    80002aac:	00f71a63          	bne	a4,a5,80002ac0 <dirlookup+0x2a>
    80002ab0:	892a                	mv	s2,a0
    80002ab2:	89ae                	mv	s3,a1
    80002ab4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ab6:	457c                	lw	a5,76(a0)
    80002ab8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002aba:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002abc:	e39d                	bnez	a5,80002ae2 <dirlookup+0x4c>
    80002abe:	a095                	j	80002b22 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002ac0:	00005517          	auipc	a0,0x5
    80002ac4:	ae850513          	addi	a0,a0,-1304 # 800075a8 <syscalls+0x190>
    80002ac8:	13b020ef          	jal	ra,80005402 <panic>
      panic("dirlookup read");
    80002acc:	00005517          	auipc	a0,0x5
    80002ad0:	af450513          	addi	a0,a0,-1292 # 800075c0 <syscalls+0x1a8>
    80002ad4:	12f020ef          	jal	ra,80005402 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ad8:	24c1                	addiw	s1,s1,16
    80002ada:	04c92783          	lw	a5,76(s2)
    80002ade:	04f4f163          	bgeu	s1,a5,80002b20 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ae2:	4741                	li	a4,16
    80002ae4:	86a6                	mv	a3,s1
    80002ae6:	fc040613          	addi	a2,s0,-64
    80002aea:	4581                	li	a1,0
    80002aec:	854a                	mv	a0,s2
    80002aee:	dabff0ef          	jal	ra,80002898 <readi>
    80002af2:	47c1                	li	a5,16
    80002af4:	fcf51ce3          	bne	a0,a5,80002acc <dirlookup+0x36>
    if(de.inum == 0)
    80002af8:	fc045783          	lhu	a5,-64(s0)
    80002afc:	dff1                	beqz	a5,80002ad8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002afe:	fc240593          	addi	a1,s0,-62
    80002b02:	854e                	mv	a0,s3
    80002b04:	f7dff0ef          	jal	ra,80002a80 <namecmp>
    80002b08:	f961                	bnez	a0,80002ad8 <dirlookup+0x42>
      if(poff)
    80002b0a:	000a0463          	beqz	s4,80002b12 <dirlookup+0x7c>
        *poff = off;
    80002b0e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002b12:	fc045583          	lhu	a1,-64(s0)
    80002b16:	00092503          	lw	a0,0(s2)
    80002b1a:	855ff0ef          	jal	ra,8000236e <iget>
    80002b1e:	a011                	j	80002b22 <dirlookup+0x8c>
  return 0;
    80002b20:	4501                	li	a0,0
}
    80002b22:	70e2                	ld	ra,56(sp)
    80002b24:	7442                	ld	s0,48(sp)
    80002b26:	74a2                	ld	s1,40(sp)
    80002b28:	7902                	ld	s2,32(sp)
    80002b2a:	69e2                	ld	s3,24(sp)
    80002b2c:	6a42                	ld	s4,16(sp)
    80002b2e:	6121                	addi	sp,sp,64
    80002b30:	8082                	ret

0000000080002b32 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002b32:	711d                	addi	sp,sp,-96
    80002b34:	ec86                	sd	ra,88(sp)
    80002b36:	e8a2                	sd	s0,80(sp)
    80002b38:	e4a6                	sd	s1,72(sp)
    80002b3a:	e0ca                	sd	s2,64(sp)
    80002b3c:	fc4e                	sd	s3,56(sp)
    80002b3e:	f852                	sd	s4,48(sp)
    80002b40:	f456                	sd	s5,40(sp)
    80002b42:	f05a                	sd	s6,32(sp)
    80002b44:	ec5e                	sd	s7,24(sp)
    80002b46:	e862                	sd	s8,16(sp)
    80002b48:	e466                	sd	s9,8(sp)
    80002b4a:	e06a                	sd	s10,0(sp)
    80002b4c:	1080                	addi	s0,sp,96
    80002b4e:	84aa                	mv	s1,a0
    80002b50:	8b2e                	mv	s6,a1
    80002b52:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002b54:	00054703          	lbu	a4,0(a0)
    80002b58:	02f00793          	li	a5,47
    80002b5c:	00f70f63          	beq	a4,a5,80002b7a <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002b60:	9acfe0ef          	jal	ra,80000d0c <myproc>
    80002b64:	15053503          	ld	a0,336(a0)
    80002b68:	aabff0ef          	jal	ra,80002612 <idup>
    80002b6c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002b6e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002b72:	4cb5                	li	s9,13
  len = path - s;
    80002b74:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002b76:	4c05                	li	s8,1
    80002b78:	a879                	j	80002c16 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002b7a:	4585                	li	a1,1
    80002b7c:	4505                	li	a0,1
    80002b7e:	ff0ff0ef          	jal	ra,8000236e <iget>
    80002b82:	8a2a                	mv	s4,a0
    80002b84:	b7ed                	j	80002b6e <namex+0x3c>
      iunlockput(ip);
    80002b86:	8552                	mv	a0,s4
    80002b88:	cc7ff0ef          	jal	ra,8000284e <iunlockput>
      return 0;
    80002b8c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b8e:	8552                	mv	a0,s4
    80002b90:	60e6                	ld	ra,88(sp)
    80002b92:	6446                	ld	s0,80(sp)
    80002b94:	64a6                	ld	s1,72(sp)
    80002b96:	6906                	ld	s2,64(sp)
    80002b98:	79e2                	ld	s3,56(sp)
    80002b9a:	7a42                	ld	s4,48(sp)
    80002b9c:	7aa2                	ld	s5,40(sp)
    80002b9e:	7b02                	ld	s6,32(sp)
    80002ba0:	6be2                	ld	s7,24(sp)
    80002ba2:	6c42                	ld	s8,16(sp)
    80002ba4:	6ca2                	ld	s9,8(sp)
    80002ba6:	6d02                	ld	s10,0(sp)
    80002ba8:	6125                	addi	sp,sp,96
    80002baa:	8082                	ret
      iunlock(ip);
    80002bac:	8552                	mv	a0,s4
    80002bae:	b45ff0ef          	jal	ra,800026f2 <iunlock>
      return ip;
    80002bb2:	bff1                	j	80002b8e <namex+0x5c>
      iunlockput(ip);
    80002bb4:	8552                	mv	a0,s4
    80002bb6:	c99ff0ef          	jal	ra,8000284e <iunlockput>
      return 0;
    80002bba:	8a4e                	mv	s4,s3
    80002bbc:	bfc9                	j	80002b8e <namex+0x5c>
  len = path - s;
    80002bbe:	40998633          	sub	a2,s3,s1
    80002bc2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002bc6:	09acd063          	bge	s9,s10,80002c46 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002bca:	4639                	li	a2,14
    80002bcc:	85a6                	mv	a1,s1
    80002bce:	8556                	mv	a0,s5
    80002bd0:	ddafd0ef          	jal	ra,800001aa <memmove>
    80002bd4:	84ce                	mv	s1,s3
  while(*path == '/')
    80002bd6:	0004c783          	lbu	a5,0(s1)
    80002bda:	01279763          	bne	a5,s2,80002be8 <namex+0xb6>
    path++;
    80002bde:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002be0:	0004c783          	lbu	a5,0(s1)
    80002be4:	ff278de3          	beq	a5,s2,80002bde <namex+0xac>
    ilock(ip);
    80002be8:	8552                	mv	a0,s4
    80002bea:	a5fff0ef          	jal	ra,80002648 <ilock>
    if(ip->type != T_DIR){
    80002bee:	044a1783          	lh	a5,68(s4)
    80002bf2:	f9879ae3          	bne	a5,s8,80002b86 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002bf6:	000b0563          	beqz	s6,80002c00 <namex+0xce>
    80002bfa:	0004c783          	lbu	a5,0(s1)
    80002bfe:	d7dd                	beqz	a5,80002bac <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002c00:	865e                	mv	a2,s7
    80002c02:	85d6                	mv	a1,s5
    80002c04:	8552                	mv	a0,s4
    80002c06:	e91ff0ef          	jal	ra,80002a96 <dirlookup>
    80002c0a:	89aa                	mv	s3,a0
    80002c0c:	d545                	beqz	a0,80002bb4 <namex+0x82>
    iunlockput(ip);
    80002c0e:	8552                	mv	a0,s4
    80002c10:	c3fff0ef          	jal	ra,8000284e <iunlockput>
    ip = next;
    80002c14:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002c16:	0004c783          	lbu	a5,0(s1)
    80002c1a:	01279763          	bne	a5,s2,80002c28 <namex+0xf6>
    path++;
    80002c1e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002c20:	0004c783          	lbu	a5,0(s1)
    80002c24:	ff278de3          	beq	a5,s2,80002c1e <namex+0xec>
  if(*path == 0)
    80002c28:	cb8d                	beqz	a5,80002c5a <namex+0x128>
  while(*path != '/' && *path != 0)
    80002c2a:	0004c783          	lbu	a5,0(s1)
    80002c2e:	89a6                	mv	s3,s1
  len = path - s;
    80002c30:	8d5e                	mv	s10,s7
    80002c32:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80002c34:	01278963          	beq	a5,s2,80002c46 <namex+0x114>
    80002c38:	d3d9                	beqz	a5,80002bbe <namex+0x8c>
    path++;
    80002c3a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002c3c:	0009c783          	lbu	a5,0(s3)
    80002c40:	ff279ce3          	bne	a5,s2,80002c38 <namex+0x106>
    80002c44:	bfad                	j	80002bbe <namex+0x8c>
    memmove(name, s, len);
    80002c46:	2601                	sext.w	a2,a2
    80002c48:	85a6                	mv	a1,s1
    80002c4a:	8556                	mv	a0,s5
    80002c4c:	d5efd0ef          	jal	ra,800001aa <memmove>
    name[len] = 0;
    80002c50:	9d56                	add	s10,s10,s5
    80002c52:	000d0023          	sb	zero,0(s10) # 1000 <_entry-0x7ffff000>
    80002c56:	84ce                	mv	s1,s3
    80002c58:	bfbd                	j	80002bd6 <namex+0xa4>
  if(nameiparent){
    80002c5a:	f20b0ae3          	beqz	s6,80002b8e <namex+0x5c>
    iput(ip);
    80002c5e:	8552                	mv	a0,s4
    80002c60:	b67ff0ef          	jal	ra,800027c6 <iput>
    return 0;
    80002c64:	4a01                	li	s4,0
    80002c66:	b725                	j	80002b8e <namex+0x5c>

0000000080002c68 <dirlink>:
{
    80002c68:	7139                	addi	sp,sp,-64
    80002c6a:	fc06                	sd	ra,56(sp)
    80002c6c:	f822                	sd	s0,48(sp)
    80002c6e:	f426                	sd	s1,40(sp)
    80002c70:	f04a                	sd	s2,32(sp)
    80002c72:	ec4e                	sd	s3,24(sp)
    80002c74:	e852                	sd	s4,16(sp)
    80002c76:	0080                	addi	s0,sp,64
    80002c78:	892a                	mv	s2,a0
    80002c7a:	8a2e                	mv	s4,a1
    80002c7c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002c7e:	4601                	li	a2,0
    80002c80:	e17ff0ef          	jal	ra,80002a96 <dirlookup>
    80002c84:	e52d                	bnez	a0,80002cee <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c86:	04c92483          	lw	s1,76(s2)
    80002c8a:	c48d                	beqz	s1,80002cb4 <dirlink+0x4c>
    80002c8c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c8e:	4741                	li	a4,16
    80002c90:	86a6                	mv	a3,s1
    80002c92:	fc040613          	addi	a2,s0,-64
    80002c96:	4581                	li	a1,0
    80002c98:	854a                	mv	a0,s2
    80002c9a:	bffff0ef          	jal	ra,80002898 <readi>
    80002c9e:	47c1                	li	a5,16
    80002ca0:	04f51b63          	bne	a0,a5,80002cf6 <dirlink+0x8e>
    if(de.inum == 0)
    80002ca4:	fc045783          	lhu	a5,-64(s0)
    80002ca8:	c791                	beqz	a5,80002cb4 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002caa:	24c1                	addiw	s1,s1,16
    80002cac:	04c92783          	lw	a5,76(s2)
    80002cb0:	fcf4efe3          	bltu	s1,a5,80002c8e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002cb4:	4639                	li	a2,14
    80002cb6:	85d2                	mv	a1,s4
    80002cb8:	fc240513          	addi	a0,s0,-62
    80002cbc:	d9afd0ef          	jal	ra,80000256 <strncpy>
  de.inum = inum;
    80002cc0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cc4:	4741                	li	a4,16
    80002cc6:	86a6                	mv	a3,s1
    80002cc8:	fc040613          	addi	a2,s0,-64
    80002ccc:	4581                	li	a1,0
    80002cce:	854a                	mv	a0,s2
    80002cd0:	cadff0ef          	jal	ra,8000297c <writei>
    80002cd4:	1541                	addi	a0,a0,-16
    80002cd6:	00a03533          	snez	a0,a0
    80002cda:	40a00533          	neg	a0,a0
}
    80002cde:	70e2                	ld	ra,56(sp)
    80002ce0:	7442                	ld	s0,48(sp)
    80002ce2:	74a2                	ld	s1,40(sp)
    80002ce4:	7902                	ld	s2,32(sp)
    80002ce6:	69e2                	ld	s3,24(sp)
    80002ce8:	6a42                	ld	s4,16(sp)
    80002cea:	6121                	addi	sp,sp,64
    80002cec:	8082                	ret
    iput(ip);
    80002cee:	ad9ff0ef          	jal	ra,800027c6 <iput>
    return -1;
    80002cf2:	557d                	li	a0,-1
    80002cf4:	b7ed                	j	80002cde <dirlink+0x76>
      panic("dirlink read");
    80002cf6:	00005517          	auipc	a0,0x5
    80002cfa:	8da50513          	addi	a0,a0,-1830 # 800075d0 <syscalls+0x1b8>
    80002cfe:	704020ef          	jal	ra,80005402 <panic>

0000000080002d02 <namei>:

struct inode*
namei(char *path)
{
    80002d02:	1101                	addi	sp,sp,-32
    80002d04:	ec06                	sd	ra,24(sp)
    80002d06:	e822                	sd	s0,16(sp)
    80002d08:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002d0a:	fe040613          	addi	a2,s0,-32
    80002d0e:	4581                	li	a1,0
    80002d10:	e23ff0ef          	jal	ra,80002b32 <namex>
}
    80002d14:	60e2                	ld	ra,24(sp)
    80002d16:	6442                	ld	s0,16(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret

0000000080002d1c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002d1c:	1141                	addi	sp,sp,-16
    80002d1e:	e406                	sd	ra,8(sp)
    80002d20:	e022                	sd	s0,0(sp)
    80002d22:	0800                	addi	s0,sp,16
    80002d24:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002d26:	4585                	li	a1,1
    80002d28:	e0bff0ef          	jal	ra,80002b32 <namex>
}
    80002d2c:	60a2                	ld	ra,8(sp)
    80002d2e:	6402                	ld	s0,0(sp)
    80002d30:	0141                	addi	sp,sp,16
    80002d32:	8082                	ret

0000000080002d34 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	e04a                	sd	s2,0(sp)
    80002d3e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002d40:	00010917          	auipc	s2,0x10
    80002d44:	fd090913          	addi	s2,s2,-48 # 80012d10 <log>
    80002d48:	01892583          	lw	a1,24(s2)
    80002d4c:	02892503          	lw	a0,40(s2)
    80002d50:	95cff0ef          	jal	ra,80001eac <bread>
    80002d54:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002d56:	02c92683          	lw	a3,44(s2)
    80002d5a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002d5c:	02d05863          	blez	a3,80002d8c <write_head+0x58>
    80002d60:	00010797          	auipc	a5,0x10
    80002d64:	fe078793          	addi	a5,a5,-32 # 80012d40 <log+0x30>
    80002d68:	05c50713          	addi	a4,a0,92
    80002d6c:	36fd                	addiw	a3,a3,-1
    80002d6e:	02069613          	slli	a2,a3,0x20
    80002d72:	01e65693          	srli	a3,a2,0x1e
    80002d76:	00010617          	auipc	a2,0x10
    80002d7a:	fce60613          	addi	a2,a2,-50 # 80012d44 <log+0x34>
    80002d7e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002d80:	4390                	lw	a2,0(a5)
    80002d82:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002d84:	0791                	addi	a5,a5,4
    80002d86:	0711                	addi	a4,a4,4
    80002d88:	fed79ce3          	bne	a5,a3,80002d80 <write_head+0x4c>
  }
  bwrite(buf);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	9f4ff0ef          	jal	ra,80001f82 <bwrite>
  brelse(buf);
    80002d92:	8526                	mv	a0,s1
    80002d94:	a20ff0ef          	jal	ra,80001fb4 <brelse>
}
    80002d98:	60e2                	ld	ra,24(sp)
    80002d9a:	6442                	ld	s0,16(sp)
    80002d9c:	64a2                	ld	s1,8(sp)
    80002d9e:	6902                	ld	s2,0(sp)
    80002da0:	6105                	addi	sp,sp,32
    80002da2:	8082                	ret

0000000080002da4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002da4:	00010797          	auipc	a5,0x10
    80002da8:	f987a783          	lw	a5,-104(a5) # 80012d3c <log+0x2c>
    80002dac:	08f05f63          	blez	a5,80002e4a <install_trans+0xa6>
{
    80002db0:	7139                	addi	sp,sp,-64
    80002db2:	fc06                	sd	ra,56(sp)
    80002db4:	f822                	sd	s0,48(sp)
    80002db6:	f426                	sd	s1,40(sp)
    80002db8:	f04a                	sd	s2,32(sp)
    80002dba:	ec4e                	sd	s3,24(sp)
    80002dbc:	e852                	sd	s4,16(sp)
    80002dbe:	e456                	sd	s5,8(sp)
    80002dc0:	e05a                	sd	s6,0(sp)
    80002dc2:	0080                	addi	s0,sp,64
    80002dc4:	8b2a                	mv	s6,a0
    80002dc6:	00010a97          	auipc	s5,0x10
    80002dca:	f7aa8a93          	addi	s5,s5,-134 # 80012d40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002dce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002dd0:	00010997          	auipc	s3,0x10
    80002dd4:	f4098993          	addi	s3,s3,-192 # 80012d10 <log>
    80002dd8:	a829                	j	80002df2 <install_trans+0x4e>
    brelse(lbuf);
    80002dda:	854a                	mv	a0,s2
    80002ddc:	9d8ff0ef          	jal	ra,80001fb4 <brelse>
    brelse(dbuf);
    80002de0:	8526                	mv	a0,s1
    80002de2:	9d2ff0ef          	jal	ra,80001fb4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002de6:	2a05                	addiw	s4,s4,1
    80002de8:	0a91                	addi	s5,s5,4
    80002dea:	02c9a783          	lw	a5,44(s3)
    80002dee:	04fa5463          	bge	s4,a5,80002e36 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002df2:	0189a583          	lw	a1,24(s3)
    80002df6:	014585bb          	addw	a1,a1,s4
    80002dfa:	2585                	addiw	a1,a1,1
    80002dfc:	0289a503          	lw	a0,40(s3)
    80002e00:	8acff0ef          	jal	ra,80001eac <bread>
    80002e04:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002e06:	000aa583          	lw	a1,0(s5)
    80002e0a:	0289a503          	lw	a0,40(s3)
    80002e0e:	89eff0ef          	jal	ra,80001eac <bread>
    80002e12:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002e14:	40000613          	li	a2,1024
    80002e18:	05890593          	addi	a1,s2,88
    80002e1c:	05850513          	addi	a0,a0,88
    80002e20:	b8afd0ef          	jal	ra,800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002e24:	8526                	mv	a0,s1
    80002e26:	95cff0ef          	jal	ra,80001f82 <bwrite>
    if(recovering == 0)
    80002e2a:	fa0b18e3          	bnez	s6,80002dda <install_trans+0x36>
      bunpin(dbuf);
    80002e2e:	8526                	mv	a0,s1
    80002e30:	a42ff0ef          	jal	ra,80002072 <bunpin>
    80002e34:	b75d                	j	80002dda <install_trans+0x36>
}
    80002e36:	70e2                	ld	ra,56(sp)
    80002e38:	7442                	ld	s0,48(sp)
    80002e3a:	74a2                	ld	s1,40(sp)
    80002e3c:	7902                	ld	s2,32(sp)
    80002e3e:	69e2                	ld	s3,24(sp)
    80002e40:	6a42                	ld	s4,16(sp)
    80002e42:	6aa2                	ld	s5,8(sp)
    80002e44:	6b02                	ld	s6,0(sp)
    80002e46:	6121                	addi	sp,sp,64
    80002e48:	8082                	ret
    80002e4a:	8082                	ret

0000000080002e4c <initlog>:
{
    80002e4c:	7179                	addi	sp,sp,-48
    80002e4e:	f406                	sd	ra,40(sp)
    80002e50:	f022                	sd	s0,32(sp)
    80002e52:	ec26                	sd	s1,24(sp)
    80002e54:	e84a                	sd	s2,16(sp)
    80002e56:	e44e                	sd	s3,8(sp)
    80002e58:	1800                	addi	s0,sp,48
    80002e5a:	892a                	mv	s2,a0
    80002e5c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002e5e:	00010497          	auipc	s1,0x10
    80002e62:	eb248493          	addi	s1,s1,-334 # 80012d10 <log>
    80002e66:	00004597          	auipc	a1,0x4
    80002e6a:	77a58593          	addi	a1,a1,1914 # 800075e0 <syscalls+0x1c8>
    80002e6e:	8526                	mv	a0,s1
    80002e70:	023020ef          	jal	ra,80005692 <initlock>
  log.start = sb->logstart;
    80002e74:	0149a583          	lw	a1,20(s3)
    80002e78:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002e7a:	0109a783          	lw	a5,16(s3)
    80002e7e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002e80:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002e84:	854a                	mv	a0,s2
    80002e86:	826ff0ef          	jal	ra,80001eac <bread>
  log.lh.n = lh->n;
    80002e8a:	4d34                	lw	a3,88(a0)
    80002e8c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e8e:	02d05663          	blez	a3,80002eba <initlog+0x6e>
    80002e92:	05c50793          	addi	a5,a0,92
    80002e96:	00010717          	auipc	a4,0x10
    80002e9a:	eaa70713          	addi	a4,a4,-342 # 80012d40 <log+0x30>
    80002e9e:	36fd                	addiw	a3,a3,-1
    80002ea0:	02069613          	slli	a2,a3,0x20
    80002ea4:	01e65693          	srli	a3,a2,0x1e
    80002ea8:	06050613          	addi	a2,a0,96
    80002eac:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80002eae:	4390                	lw	a2,0(a5)
    80002eb0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002eb2:	0791                	addi	a5,a5,4
    80002eb4:	0711                	addi	a4,a4,4
    80002eb6:	fed79ce3          	bne	a5,a3,80002eae <initlog+0x62>
  brelse(buf);
    80002eba:	8faff0ef          	jal	ra,80001fb4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002ebe:	4505                	li	a0,1
    80002ec0:	ee5ff0ef          	jal	ra,80002da4 <install_trans>
  log.lh.n = 0;
    80002ec4:	00010797          	auipc	a5,0x10
    80002ec8:	e607ac23          	sw	zero,-392(a5) # 80012d3c <log+0x2c>
  write_head(); // clear the log
    80002ecc:	e69ff0ef          	jal	ra,80002d34 <write_head>
}
    80002ed0:	70a2                	ld	ra,40(sp)
    80002ed2:	7402                	ld	s0,32(sp)
    80002ed4:	64e2                	ld	s1,24(sp)
    80002ed6:	6942                	ld	s2,16(sp)
    80002ed8:	69a2                	ld	s3,8(sp)
    80002eda:	6145                	addi	sp,sp,48
    80002edc:	8082                	ret

0000000080002ede <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	e04a                	sd	s2,0(sp)
    80002ee8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002eea:	00010517          	auipc	a0,0x10
    80002eee:	e2650513          	addi	a0,a0,-474 # 80012d10 <log>
    80002ef2:	021020ef          	jal	ra,80005712 <acquire>
  while(1){
    if(log.committing){
    80002ef6:	00010497          	auipc	s1,0x10
    80002efa:	e1a48493          	addi	s1,s1,-486 # 80012d10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002efe:	4979                	li	s2,30
    80002f00:	a029                	j	80002f0a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002f02:	85a6                	mv	a1,s1
    80002f04:	8526                	mv	a0,s1
    80002f06:	bd4fe0ef          	jal	ra,800012da <sleep>
    if(log.committing){
    80002f0a:	50dc                	lw	a5,36(s1)
    80002f0c:	fbfd                	bnez	a5,80002f02 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002f0e:	5098                	lw	a4,32(s1)
    80002f10:	2705                	addiw	a4,a4,1
    80002f12:	0007069b          	sext.w	a3,a4
    80002f16:	0027179b          	slliw	a5,a4,0x2
    80002f1a:	9fb9                	addw	a5,a5,a4
    80002f1c:	0017979b          	slliw	a5,a5,0x1
    80002f20:	54d8                	lw	a4,44(s1)
    80002f22:	9fb9                	addw	a5,a5,a4
    80002f24:	00f95763          	bge	s2,a5,80002f32 <begin_op+0x54>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002f28:	85a6                	mv	a1,s1
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	baefe0ef          	jal	ra,800012da <sleep>
    80002f30:	bfe9                	j	80002f0a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002f32:	00010517          	auipc	a0,0x10
    80002f36:	dde50513          	addi	a0,a0,-546 # 80012d10 <log>
    80002f3a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80002f3c:	06f020ef          	jal	ra,800057aa <release>
      break;
    }
  }
}
    80002f40:	60e2                	ld	ra,24(sp)
    80002f42:	6442                	ld	s0,16(sp)
    80002f44:	64a2                	ld	s1,8(sp)
    80002f46:	6902                	ld	s2,0(sp)
    80002f48:	6105                	addi	sp,sp,32
    80002f4a:	8082                	ret

0000000080002f4c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002f4c:	7139                	addi	sp,sp,-64
    80002f4e:	fc06                	sd	ra,56(sp)
    80002f50:	f822                	sd	s0,48(sp)
    80002f52:	f426                	sd	s1,40(sp)
    80002f54:	f04a                	sd	s2,32(sp)
    80002f56:	ec4e                	sd	s3,24(sp)
    80002f58:	e852                	sd	s4,16(sp)
    80002f5a:	e456                	sd	s5,8(sp)
    80002f5c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002f5e:	00010497          	auipc	s1,0x10
    80002f62:	db248493          	addi	s1,s1,-590 # 80012d10 <log>
    80002f66:	8526                	mv	a0,s1
    80002f68:	7aa020ef          	jal	ra,80005712 <acquire>
  log.outstanding -= 1;
    80002f6c:	509c                	lw	a5,32(s1)
    80002f6e:	37fd                	addiw	a5,a5,-1
    80002f70:	0007891b          	sext.w	s2,a5
    80002f74:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002f76:	50dc                	lw	a5,36(s1)
    80002f78:	ef9d                	bnez	a5,80002fb6 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80002f7a:	04091463          	bnez	s2,80002fc2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80002f7e:	00010497          	auipc	s1,0x10
    80002f82:	d9248493          	addi	s1,s1,-622 # 80012d10 <log>
    80002f86:	4785                	li	a5,1
    80002f88:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002f8a:	8526                	mv	a0,s1
    80002f8c:	01f020ef          	jal	ra,800057aa <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f90:	54dc                	lw	a5,44(s1)
    80002f92:	04f04b63          	bgtz	a5,80002fe8 <end_op+0x9c>
    acquire(&log.lock);
    80002f96:	00010497          	auipc	s1,0x10
    80002f9a:	d7a48493          	addi	s1,s1,-646 # 80012d10 <log>
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	772020ef          	jal	ra,80005712 <acquire>
    log.committing = 0;
    80002fa4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002fa8:	8526                	mv	a0,s1
    80002faa:	b7cfe0ef          	jal	ra,80001326 <wakeup>
    release(&log.lock);
    80002fae:	8526                	mv	a0,s1
    80002fb0:	7fa020ef          	jal	ra,800057aa <release>
}
    80002fb4:	a00d                	j	80002fd6 <end_op+0x8a>
    panic("log.committing");
    80002fb6:	00004517          	auipc	a0,0x4
    80002fba:	63250513          	addi	a0,a0,1586 # 800075e8 <syscalls+0x1d0>
    80002fbe:	444020ef          	jal	ra,80005402 <panic>
    wakeup(&log);
    80002fc2:	00010497          	auipc	s1,0x10
    80002fc6:	d4e48493          	addi	s1,s1,-690 # 80012d10 <log>
    80002fca:	8526                	mv	a0,s1
    80002fcc:	b5afe0ef          	jal	ra,80001326 <wakeup>
  release(&log.lock);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	7d8020ef          	jal	ra,800057aa <release>
}
    80002fd6:	70e2                	ld	ra,56(sp)
    80002fd8:	7442                	ld	s0,48(sp)
    80002fda:	74a2                	ld	s1,40(sp)
    80002fdc:	7902                	ld	s2,32(sp)
    80002fde:	69e2                	ld	s3,24(sp)
    80002fe0:	6a42                	ld	s4,16(sp)
    80002fe2:	6aa2                	ld	s5,8(sp)
    80002fe4:	6121                	addi	sp,sp,64
    80002fe6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fe8:	00010a97          	auipc	s5,0x10
    80002fec:	d58a8a93          	addi	s5,s5,-680 # 80012d40 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002ff0:	00010a17          	auipc	s4,0x10
    80002ff4:	d20a0a13          	addi	s4,s4,-736 # 80012d10 <log>
    80002ff8:	018a2583          	lw	a1,24(s4)
    80002ffc:	012585bb          	addw	a1,a1,s2
    80003000:	2585                	addiw	a1,a1,1
    80003002:	028a2503          	lw	a0,40(s4)
    80003006:	ea7fe0ef          	jal	ra,80001eac <bread>
    8000300a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000300c:	000aa583          	lw	a1,0(s5)
    80003010:	028a2503          	lw	a0,40(s4)
    80003014:	e99fe0ef          	jal	ra,80001eac <bread>
    80003018:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000301a:	40000613          	li	a2,1024
    8000301e:	05850593          	addi	a1,a0,88
    80003022:	05848513          	addi	a0,s1,88
    80003026:	984fd0ef          	jal	ra,800001aa <memmove>
    bwrite(to);  // write the log
    8000302a:	8526                	mv	a0,s1
    8000302c:	f57fe0ef          	jal	ra,80001f82 <bwrite>
    brelse(from);
    80003030:	854e                	mv	a0,s3
    80003032:	f83fe0ef          	jal	ra,80001fb4 <brelse>
    brelse(to);
    80003036:	8526                	mv	a0,s1
    80003038:	f7dfe0ef          	jal	ra,80001fb4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000303c:	2905                	addiw	s2,s2,1
    8000303e:	0a91                	addi	s5,s5,4
    80003040:	02ca2783          	lw	a5,44(s4)
    80003044:	faf94ae3          	blt	s2,a5,80002ff8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003048:	cedff0ef          	jal	ra,80002d34 <write_head>
    install_trans(0); // Now install writes to home locations
    8000304c:	4501                	li	a0,0
    8000304e:	d57ff0ef          	jal	ra,80002da4 <install_trans>
    log.lh.n = 0;
    80003052:	00010797          	auipc	a5,0x10
    80003056:	ce07a523          	sw	zero,-790(a5) # 80012d3c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000305a:	cdbff0ef          	jal	ra,80002d34 <write_head>
    8000305e:	bf25                	j	80002f96 <end_op+0x4a>

0000000080003060 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003060:	1101                	addi	sp,sp,-32
    80003062:	ec06                	sd	ra,24(sp)
    80003064:	e822                	sd	s0,16(sp)
    80003066:	e426                	sd	s1,8(sp)
    80003068:	e04a                	sd	s2,0(sp)
    8000306a:	1000                	addi	s0,sp,32
    8000306c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000306e:	00010917          	auipc	s2,0x10
    80003072:	ca290913          	addi	s2,s2,-862 # 80012d10 <log>
    80003076:	854a                	mv	a0,s2
    80003078:	69a020ef          	jal	ra,80005712 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000307c:	02c92603          	lw	a2,44(s2)
    80003080:	47f5                	li	a5,29
    80003082:	06c7c363          	blt	a5,a2,800030e8 <log_write+0x88>
    80003086:	00010797          	auipc	a5,0x10
    8000308a:	ca67a783          	lw	a5,-858(a5) # 80012d2c <log+0x1c>
    8000308e:	37fd                	addiw	a5,a5,-1
    80003090:	04f65c63          	bge	a2,a5,800030e8 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003094:	00010797          	auipc	a5,0x10
    80003098:	c9c7a783          	lw	a5,-868(a5) # 80012d30 <log+0x20>
    8000309c:	04f05c63          	blez	a5,800030f4 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800030a0:	4781                	li	a5,0
    800030a2:	04c05f63          	blez	a2,80003100 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030a6:	44cc                	lw	a1,12(s1)
    800030a8:	00010717          	auipc	a4,0x10
    800030ac:	c9870713          	addi	a4,a4,-872 # 80012d40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800030b0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800030b2:	4314                	lw	a3,0(a4)
    800030b4:	04b68663          	beq	a3,a1,80003100 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800030b8:	2785                	addiw	a5,a5,1
    800030ba:	0711                	addi	a4,a4,4
    800030bc:	fef61be3          	bne	a2,a5,800030b2 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800030c0:	0621                	addi	a2,a2,8
    800030c2:	060a                	slli	a2,a2,0x2
    800030c4:	00010797          	auipc	a5,0x10
    800030c8:	c4c78793          	addi	a5,a5,-948 # 80012d10 <log>
    800030cc:	97b2                	add	a5,a5,a2
    800030ce:	44d8                	lw	a4,12(s1)
    800030d0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800030d2:	8526                	mv	a0,s1
    800030d4:	f6bfe0ef          	jal	ra,8000203e <bpin>
    log.lh.n++;
    800030d8:	00010717          	auipc	a4,0x10
    800030dc:	c3870713          	addi	a4,a4,-968 # 80012d10 <log>
    800030e0:	575c                	lw	a5,44(a4)
    800030e2:	2785                	addiw	a5,a5,1
    800030e4:	d75c                	sw	a5,44(a4)
    800030e6:	a80d                	j	80003118 <log_write+0xb8>
    panic("too big a transaction");
    800030e8:	00004517          	auipc	a0,0x4
    800030ec:	51050513          	addi	a0,a0,1296 # 800075f8 <syscalls+0x1e0>
    800030f0:	312020ef          	jal	ra,80005402 <panic>
    panic("log_write outside of trans");
    800030f4:	00004517          	auipc	a0,0x4
    800030f8:	51c50513          	addi	a0,a0,1308 # 80007610 <syscalls+0x1f8>
    800030fc:	306020ef          	jal	ra,80005402 <panic>
  log.lh.block[i] = b->blockno;
    80003100:	00878693          	addi	a3,a5,8
    80003104:	068a                	slli	a3,a3,0x2
    80003106:	00010717          	auipc	a4,0x10
    8000310a:	c0a70713          	addi	a4,a4,-1014 # 80012d10 <log>
    8000310e:	9736                	add	a4,a4,a3
    80003110:	44d4                	lw	a3,12(s1)
    80003112:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003114:	faf60fe3          	beq	a2,a5,800030d2 <log_write+0x72>
  }
  release(&log.lock);
    80003118:	00010517          	auipc	a0,0x10
    8000311c:	bf850513          	addi	a0,a0,-1032 # 80012d10 <log>
    80003120:	68a020ef          	jal	ra,800057aa <release>
}
    80003124:	60e2                	ld	ra,24(sp)
    80003126:	6442                	ld	s0,16(sp)
    80003128:	64a2                	ld	s1,8(sp)
    8000312a:	6902                	ld	s2,0(sp)
    8000312c:	6105                	addi	sp,sp,32
    8000312e:	8082                	ret

0000000080003130 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	e426                	sd	s1,8(sp)
    80003138:	e04a                	sd	s2,0(sp)
    8000313a:	1000                	addi	s0,sp,32
    8000313c:	84aa                	mv	s1,a0
    8000313e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003140:	00004597          	auipc	a1,0x4
    80003144:	4f058593          	addi	a1,a1,1264 # 80007630 <syscalls+0x218>
    80003148:	0521                	addi	a0,a0,8
    8000314a:	548020ef          	jal	ra,80005692 <initlock>
  lk->name = name;
    8000314e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003152:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003156:	0204a423          	sw	zero,40(s1)
}
    8000315a:	60e2                	ld	ra,24(sp)
    8000315c:	6442                	ld	s0,16(sp)
    8000315e:	64a2                	ld	s1,8(sp)
    80003160:	6902                	ld	s2,0(sp)
    80003162:	6105                	addi	sp,sp,32
    80003164:	8082                	ret

0000000080003166 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003166:	1101                	addi	sp,sp,-32
    80003168:	ec06                	sd	ra,24(sp)
    8000316a:	e822                	sd	s0,16(sp)
    8000316c:	e426                	sd	s1,8(sp)
    8000316e:	e04a                	sd	s2,0(sp)
    80003170:	1000                	addi	s0,sp,32
    80003172:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003174:	00850913          	addi	s2,a0,8
    80003178:	854a                	mv	a0,s2
    8000317a:	598020ef          	jal	ra,80005712 <acquire>
  while (lk->locked) {
    8000317e:	409c                	lw	a5,0(s1)
    80003180:	c799                	beqz	a5,8000318e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003182:	85ca                	mv	a1,s2
    80003184:	8526                	mv	a0,s1
    80003186:	954fe0ef          	jal	ra,800012da <sleep>
  while (lk->locked) {
    8000318a:	409c                	lw	a5,0(s1)
    8000318c:	fbfd                	bnez	a5,80003182 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000318e:	4785                	li	a5,1
    80003190:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003192:	b7bfd0ef          	jal	ra,80000d0c <myproc>
    80003196:	591c                	lw	a5,48(a0)
    80003198:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000319a:	854a                	mv	a0,s2
    8000319c:	60e020ef          	jal	ra,800057aa <release>
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6902                	ld	s2,0(sp)
    800031a8:	6105                	addi	sp,sp,32
    800031aa:	8082                	ret

00000000800031ac <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800031ac:	1101                	addi	sp,sp,-32
    800031ae:	ec06                	sd	ra,24(sp)
    800031b0:	e822                	sd	s0,16(sp)
    800031b2:	e426                	sd	s1,8(sp)
    800031b4:	e04a                	sd	s2,0(sp)
    800031b6:	1000                	addi	s0,sp,32
    800031b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800031ba:	00850913          	addi	s2,a0,8
    800031be:	854a                	mv	a0,s2
    800031c0:	552020ef          	jal	ra,80005712 <acquire>
  lk->locked = 0;
    800031c4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800031c8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800031cc:	8526                	mv	a0,s1
    800031ce:	958fe0ef          	jal	ra,80001326 <wakeup>
  release(&lk->lk);
    800031d2:	854a                	mv	a0,s2
    800031d4:	5d6020ef          	jal	ra,800057aa <release>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6902                	ld	s2,0(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret

00000000800031e4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800031e4:	7179                	addi	sp,sp,-48
    800031e6:	f406                	sd	ra,40(sp)
    800031e8:	f022                	sd	s0,32(sp)
    800031ea:	ec26                	sd	s1,24(sp)
    800031ec:	e84a                	sd	s2,16(sp)
    800031ee:	e44e                	sd	s3,8(sp)
    800031f0:	1800                	addi	s0,sp,48
    800031f2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800031f4:	00850913          	addi	s2,a0,8
    800031f8:	854a                	mv	a0,s2
    800031fa:	518020ef          	jal	ra,80005712 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800031fe:	409c                	lw	a5,0(s1)
    80003200:	ef89                	bnez	a5,8000321a <holdingsleep+0x36>
    80003202:	4481                	li	s1,0
  release(&lk->lk);
    80003204:	854a                	mv	a0,s2
    80003206:	5a4020ef          	jal	ra,800057aa <release>
  return r;
}
    8000320a:	8526                	mv	a0,s1
    8000320c:	70a2                	ld	ra,40(sp)
    8000320e:	7402                	ld	s0,32(sp)
    80003210:	64e2                	ld	s1,24(sp)
    80003212:	6942                	ld	s2,16(sp)
    80003214:	69a2                	ld	s3,8(sp)
    80003216:	6145                	addi	sp,sp,48
    80003218:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000321a:	0284a983          	lw	s3,40(s1)
    8000321e:	aeffd0ef          	jal	ra,80000d0c <myproc>
    80003222:	5904                	lw	s1,48(a0)
    80003224:	413484b3          	sub	s1,s1,s3
    80003228:	0014b493          	seqz	s1,s1
    8000322c:	bfe1                	j	80003204 <holdingsleep+0x20>

000000008000322e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000322e:	1141                	addi	sp,sp,-16
    80003230:	e406                	sd	ra,8(sp)
    80003232:	e022                	sd	s0,0(sp)
    80003234:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003236:	00004597          	auipc	a1,0x4
    8000323a:	40a58593          	addi	a1,a1,1034 # 80007640 <syscalls+0x228>
    8000323e:	00010517          	auipc	a0,0x10
    80003242:	c1a50513          	addi	a0,a0,-998 # 80012e58 <ftable>
    80003246:	44c020ef          	jal	ra,80005692 <initlock>
}
    8000324a:	60a2                	ld	ra,8(sp)
    8000324c:	6402                	ld	s0,0(sp)
    8000324e:	0141                	addi	sp,sp,16
    80003250:	8082                	ret

0000000080003252 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003252:	1101                	addi	sp,sp,-32
    80003254:	ec06                	sd	ra,24(sp)
    80003256:	e822                	sd	s0,16(sp)
    80003258:	e426                	sd	s1,8(sp)
    8000325a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000325c:	00010517          	auipc	a0,0x10
    80003260:	bfc50513          	addi	a0,a0,-1028 # 80012e58 <ftable>
    80003264:	4ae020ef          	jal	ra,80005712 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003268:	00010497          	auipc	s1,0x10
    8000326c:	c0848493          	addi	s1,s1,-1016 # 80012e70 <ftable+0x18>
    80003270:	00011717          	auipc	a4,0x11
    80003274:	ba070713          	addi	a4,a4,-1120 # 80013e10 <disk>
    if(f->ref == 0){
    80003278:	40dc                	lw	a5,4(s1)
    8000327a:	cf89                	beqz	a5,80003294 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000327c:	02848493          	addi	s1,s1,40
    80003280:	fee49ce3          	bne	s1,a4,80003278 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003284:	00010517          	auipc	a0,0x10
    80003288:	bd450513          	addi	a0,a0,-1068 # 80012e58 <ftable>
    8000328c:	51e020ef          	jal	ra,800057aa <release>
  return 0;
    80003290:	4481                	li	s1,0
    80003292:	a809                	j	800032a4 <filealloc+0x52>
      f->ref = 1;
    80003294:	4785                	li	a5,1
    80003296:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003298:	00010517          	auipc	a0,0x10
    8000329c:	bc050513          	addi	a0,a0,-1088 # 80012e58 <ftable>
    800032a0:	50a020ef          	jal	ra,800057aa <release>
}
    800032a4:	8526                	mv	a0,s1
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	64a2                	ld	s1,8(sp)
    800032ac:	6105                	addi	sp,sp,32
    800032ae:	8082                	ret

00000000800032b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800032b0:	1101                	addi	sp,sp,-32
    800032b2:	ec06                	sd	ra,24(sp)
    800032b4:	e822                	sd	s0,16(sp)
    800032b6:	e426                	sd	s1,8(sp)
    800032b8:	1000                	addi	s0,sp,32
    800032ba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800032bc:	00010517          	auipc	a0,0x10
    800032c0:	b9c50513          	addi	a0,a0,-1124 # 80012e58 <ftable>
    800032c4:	44e020ef          	jal	ra,80005712 <acquire>
  if(f->ref < 1)
    800032c8:	40dc                	lw	a5,4(s1)
    800032ca:	02f05063          	blez	a5,800032ea <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800032ce:	2785                	addiw	a5,a5,1
    800032d0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800032d2:	00010517          	auipc	a0,0x10
    800032d6:	b8650513          	addi	a0,a0,-1146 # 80012e58 <ftable>
    800032da:	4d0020ef          	jal	ra,800057aa <release>
  return f;
}
    800032de:	8526                	mv	a0,s1
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	64a2                	ld	s1,8(sp)
    800032e6:	6105                	addi	sp,sp,32
    800032e8:	8082                	ret
    panic("filedup");
    800032ea:	00004517          	auipc	a0,0x4
    800032ee:	35e50513          	addi	a0,a0,862 # 80007648 <syscalls+0x230>
    800032f2:	110020ef          	jal	ra,80005402 <panic>

00000000800032f6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800032f6:	7139                	addi	sp,sp,-64
    800032f8:	fc06                	sd	ra,56(sp)
    800032fa:	f822                	sd	s0,48(sp)
    800032fc:	f426                	sd	s1,40(sp)
    800032fe:	f04a                	sd	s2,32(sp)
    80003300:	ec4e                	sd	s3,24(sp)
    80003302:	e852                	sd	s4,16(sp)
    80003304:	e456                	sd	s5,8(sp)
    80003306:	0080                	addi	s0,sp,64
    80003308:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000330a:	00010517          	auipc	a0,0x10
    8000330e:	b4e50513          	addi	a0,a0,-1202 # 80012e58 <ftable>
    80003312:	400020ef          	jal	ra,80005712 <acquire>
  if(f->ref < 1)
    80003316:	40dc                	lw	a5,4(s1)
    80003318:	04f05963          	blez	a5,8000336a <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    8000331c:	37fd                	addiw	a5,a5,-1
    8000331e:	0007871b          	sext.w	a4,a5
    80003322:	c0dc                	sw	a5,4(s1)
    80003324:	04e04963          	bgtz	a4,80003376 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003328:	0004a903          	lw	s2,0(s1)
    8000332c:	0094ca83          	lbu	s5,9(s1)
    80003330:	0104ba03          	ld	s4,16(s1)
    80003334:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003338:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000333c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003340:	00010517          	auipc	a0,0x10
    80003344:	b1850513          	addi	a0,a0,-1256 # 80012e58 <ftable>
    80003348:	462020ef          	jal	ra,800057aa <release>

  if(ff.type == FD_PIPE){
    8000334c:	4785                	li	a5,1
    8000334e:	04f90363          	beq	s2,a5,80003394 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003352:	3979                	addiw	s2,s2,-2
    80003354:	4785                	li	a5,1
    80003356:	0327e663          	bltu	a5,s2,80003382 <fileclose+0x8c>
    begin_op();
    8000335a:	b85ff0ef          	jal	ra,80002ede <begin_op>
    iput(ff.ip);
    8000335e:	854e                	mv	a0,s3
    80003360:	c66ff0ef          	jal	ra,800027c6 <iput>
    end_op();
    80003364:	be9ff0ef          	jal	ra,80002f4c <end_op>
    80003368:	a829                	j	80003382 <fileclose+0x8c>
    panic("fileclose");
    8000336a:	00004517          	auipc	a0,0x4
    8000336e:	2e650513          	addi	a0,a0,742 # 80007650 <syscalls+0x238>
    80003372:	090020ef          	jal	ra,80005402 <panic>
    release(&ftable.lock);
    80003376:	00010517          	auipc	a0,0x10
    8000337a:	ae250513          	addi	a0,a0,-1310 # 80012e58 <ftable>
    8000337e:	42c020ef          	jal	ra,800057aa <release>
  }
}
    80003382:	70e2                	ld	ra,56(sp)
    80003384:	7442                	ld	s0,48(sp)
    80003386:	74a2                	ld	s1,40(sp)
    80003388:	7902                	ld	s2,32(sp)
    8000338a:	69e2                	ld	s3,24(sp)
    8000338c:	6a42                	ld	s4,16(sp)
    8000338e:	6aa2                	ld	s5,8(sp)
    80003390:	6121                	addi	sp,sp,64
    80003392:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003394:	85d6                	mv	a1,s5
    80003396:	8552                	mv	a0,s4
    80003398:	2ec000ef          	jal	ra,80003684 <pipeclose>
    8000339c:	b7dd                	j	80003382 <fileclose+0x8c>

000000008000339e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000339e:	715d                	addi	sp,sp,-80
    800033a0:	e486                	sd	ra,72(sp)
    800033a2:	e0a2                	sd	s0,64(sp)
    800033a4:	fc26                	sd	s1,56(sp)
    800033a6:	f84a                	sd	s2,48(sp)
    800033a8:	f44e                	sd	s3,40(sp)
    800033aa:	0880                	addi	s0,sp,80
    800033ac:	84aa                	mv	s1,a0
    800033ae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800033b0:	95dfd0ef          	jal	ra,80000d0c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800033b4:	409c                	lw	a5,0(s1)
    800033b6:	37f9                	addiw	a5,a5,-2
    800033b8:	4705                	li	a4,1
    800033ba:	02f76f63          	bltu	a4,a5,800033f8 <filestat+0x5a>
    800033be:	892a                	mv	s2,a0
    ilock(f->ip);
    800033c0:	6c88                	ld	a0,24(s1)
    800033c2:	a86ff0ef          	jal	ra,80002648 <ilock>
    stati(f->ip, &st);
    800033c6:	fb840593          	addi	a1,s0,-72
    800033ca:	6c88                	ld	a0,24(s1)
    800033cc:	ca2ff0ef          	jal	ra,8000286e <stati>
    iunlock(f->ip);
    800033d0:	6c88                	ld	a0,24(s1)
    800033d2:	b20ff0ef          	jal	ra,800026f2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800033d6:	46e1                	li	a3,24
    800033d8:	fb840613          	addi	a2,s0,-72
    800033dc:	85ce                	mv	a1,s3
    800033de:	05093503          	ld	a0,80(s2)
    800033e2:	de2fd0ef          	jal	ra,800009c4 <copyout>
    800033e6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800033ea:	60a6                	ld	ra,72(sp)
    800033ec:	6406                	ld	s0,64(sp)
    800033ee:	74e2                	ld	s1,56(sp)
    800033f0:	7942                	ld	s2,48(sp)
    800033f2:	79a2                	ld	s3,40(sp)
    800033f4:	6161                	addi	sp,sp,80
    800033f6:	8082                	ret
  return -1;
    800033f8:	557d                	li	a0,-1
    800033fa:	bfc5                	j	800033ea <filestat+0x4c>

00000000800033fc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800033fc:	7179                	addi	sp,sp,-48
    800033fe:	f406                	sd	ra,40(sp)
    80003400:	f022                	sd	s0,32(sp)
    80003402:	ec26                	sd	s1,24(sp)
    80003404:	e84a                	sd	s2,16(sp)
    80003406:	e44e                	sd	s3,8(sp)
    80003408:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000340a:	00854783          	lbu	a5,8(a0)
    8000340e:	cbc1                	beqz	a5,8000349e <fileread+0xa2>
    80003410:	84aa                	mv	s1,a0
    80003412:	89ae                	mv	s3,a1
    80003414:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003416:	411c                	lw	a5,0(a0)
    80003418:	4705                	li	a4,1
    8000341a:	04e78363          	beq	a5,a4,80003460 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000341e:	470d                	li	a4,3
    80003420:	04e78563          	beq	a5,a4,8000346a <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003424:	4709                	li	a4,2
    80003426:	06e79663          	bne	a5,a4,80003492 <fileread+0x96>
    ilock(f->ip);
    8000342a:	6d08                	ld	a0,24(a0)
    8000342c:	a1cff0ef          	jal	ra,80002648 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003430:	874a                	mv	a4,s2
    80003432:	5094                	lw	a3,32(s1)
    80003434:	864e                	mv	a2,s3
    80003436:	4585                	li	a1,1
    80003438:	6c88                	ld	a0,24(s1)
    8000343a:	c5eff0ef          	jal	ra,80002898 <readi>
    8000343e:	892a                	mv	s2,a0
    80003440:	00a05563          	blez	a0,8000344a <fileread+0x4e>
      f->off += r;
    80003444:	509c                	lw	a5,32(s1)
    80003446:	9fa9                	addw	a5,a5,a0
    80003448:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000344a:	6c88                	ld	a0,24(s1)
    8000344c:	aa6ff0ef          	jal	ra,800026f2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003450:	854a                	mv	a0,s2
    80003452:	70a2                	ld	ra,40(sp)
    80003454:	7402                	ld	s0,32(sp)
    80003456:	64e2                	ld	s1,24(sp)
    80003458:	6942                	ld	s2,16(sp)
    8000345a:	69a2                	ld	s3,8(sp)
    8000345c:	6145                	addi	sp,sp,48
    8000345e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003460:	6908                	ld	a0,16(a0)
    80003462:	34e000ef          	jal	ra,800037b0 <piperead>
    80003466:	892a                	mv	s2,a0
    80003468:	b7e5                	j	80003450 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000346a:	02451783          	lh	a5,36(a0)
    8000346e:	03079693          	slli	a3,a5,0x30
    80003472:	92c1                	srli	a3,a3,0x30
    80003474:	4725                	li	a4,9
    80003476:	02d76663          	bltu	a4,a3,800034a2 <fileread+0xa6>
    8000347a:	0792                	slli	a5,a5,0x4
    8000347c:	00010717          	auipc	a4,0x10
    80003480:	93c70713          	addi	a4,a4,-1732 # 80012db8 <devsw>
    80003484:	97ba                	add	a5,a5,a4
    80003486:	639c                	ld	a5,0(a5)
    80003488:	cf99                	beqz	a5,800034a6 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000348a:	4505                	li	a0,1
    8000348c:	9782                	jalr	a5
    8000348e:	892a                	mv	s2,a0
    80003490:	b7c1                	j	80003450 <fileread+0x54>
    panic("fileread");
    80003492:	00004517          	auipc	a0,0x4
    80003496:	1ce50513          	addi	a0,a0,462 # 80007660 <syscalls+0x248>
    8000349a:	769010ef          	jal	ra,80005402 <panic>
    return -1;
    8000349e:	597d                	li	s2,-1
    800034a0:	bf45                	j	80003450 <fileread+0x54>
      return -1;
    800034a2:	597d                	li	s2,-1
    800034a4:	b775                	j	80003450 <fileread+0x54>
    800034a6:	597d                	li	s2,-1
    800034a8:	b765                	j	80003450 <fileread+0x54>

00000000800034aa <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800034aa:	715d                	addi	sp,sp,-80
    800034ac:	e486                	sd	ra,72(sp)
    800034ae:	e0a2                	sd	s0,64(sp)
    800034b0:	fc26                	sd	s1,56(sp)
    800034b2:	f84a                	sd	s2,48(sp)
    800034b4:	f44e                	sd	s3,40(sp)
    800034b6:	f052                	sd	s4,32(sp)
    800034b8:	ec56                	sd	s5,24(sp)
    800034ba:	e85a                	sd	s6,16(sp)
    800034bc:	e45e                	sd	s7,8(sp)
    800034be:	e062                	sd	s8,0(sp)
    800034c0:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800034c2:	00954783          	lbu	a5,9(a0)
    800034c6:	0e078863          	beqz	a5,800035b6 <filewrite+0x10c>
    800034ca:	892a                	mv	s2,a0
    800034cc:	8b2e                	mv	s6,a1
    800034ce:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800034d0:	411c                	lw	a5,0(a0)
    800034d2:	4705                	li	a4,1
    800034d4:	02e78263          	beq	a5,a4,800034f8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800034d8:	470d                	li	a4,3
    800034da:	02e78463          	beq	a5,a4,80003502 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800034de:	4709                	li	a4,2
    800034e0:	0ce79563          	bne	a5,a4,800035aa <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800034e4:	0ac05163          	blez	a2,80003586 <filewrite+0xdc>
    int i = 0;
    800034e8:	4981                	li	s3,0
    800034ea:	6b85                	lui	s7,0x1
    800034ec:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800034f0:	6c05                	lui	s8,0x1
    800034f2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800034f6:	a041                	j	80003576 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800034f8:	6908                	ld	a0,16(a0)
    800034fa:	1e2000ef          	jal	ra,800036dc <pipewrite>
    800034fe:	8a2a                	mv	s4,a0
    80003500:	a071                	j	8000358c <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003502:	02451783          	lh	a5,36(a0)
    80003506:	03079693          	slli	a3,a5,0x30
    8000350a:	92c1                	srli	a3,a3,0x30
    8000350c:	4725                	li	a4,9
    8000350e:	0ad76663          	bltu	a4,a3,800035ba <filewrite+0x110>
    80003512:	0792                	slli	a5,a5,0x4
    80003514:	00010717          	auipc	a4,0x10
    80003518:	8a470713          	addi	a4,a4,-1884 # 80012db8 <devsw>
    8000351c:	97ba                	add	a5,a5,a4
    8000351e:	679c                	ld	a5,8(a5)
    80003520:	cfd9                	beqz	a5,800035be <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80003522:	4505                	li	a0,1
    80003524:	9782                	jalr	a5
    80003526:	8a2a                	mv	s4,a0
    80003528:	a095                	j	8000358c <filewrite+0xe2>
    8000352a:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000352e:	9b1ff0ef          	jal	ra,80002ede <begin_op>
      ilock(f->ip);
    80003532:	01893503          	ld	a0,24(s2)
    80003536:	912ff0ef          	jal	ra,80002648 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000353a:	8756                	mv	a4,s5
    8000353c:	02092683          	lw	a3,32(s2)
    80003540:	01698633          	add	a2,s3,s6
    80003544:	4585                	li	a1,1
    80003546:	01893503          	ld	a0,24(s2)
    8000354a:	c32ff0ef          	jal	ra,8000297c <writei>
    8000354e:	84aa                	mv	s1,a0
    80003550:	00a05763          	blez	a0,8000355e <filewrite+0xb4>
        f->off += r;
    80003554:	02092783          	lw	a5,32(s2)
    80003558:	9fa9                	addw	a5,a5,a0
    8000355a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000355e:	01893503          	ld	a0,24(s2)
    80003562:	990ff0ef          	jal	ra,800026f2 <iunlock>
      end_op();
    80003566:	9e7ff0ef          	jal	ra,80002f4c <end_op>

      if(r != n1){
    8000356a:	009a9f63          	bne	s5,s1,80003588 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    8000356e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003572:	0149db63          	bge	s3,s4,80003588 <filewrite+0xde>
      int n1 = n - i;
    80003576:	413a04bb          	subw	s1,s4,s3
    8000357a:	0004879b          	sext.w	a5,s1
    8000357e:	fafbd6e3          	bge	s7,a5,8000352a <filewrite+0x80>
    80003582:	84e2                	mv	s1,s8
    80003584:	b75d                	j	8000352a <filewrite+0x80>
    int i = 0;
    80003586:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003588:	013a1f63          	bne	s4,s3,800035a6 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000358c:	8552                	mv	a0,s4
    8000358e:	60a6                	ld	ra,72(sp)
    80003590:	6406                	ld	s0,64(sp)
    80003592:	74e2                	ld	s1,56(sp)
    80003594:	7942                	ld	s2,48(sp)
    80003596:	79a2                	ld	s3,40(sp)
    80003598:	7a02                	ld	s4,32(sp)
    8000359a:	6ae2                	ld	s5,24(sp)
    8000359c:	6b42                	ld	s6,16(sp)
    8000359e:	6ba2                	ld	s7,8(sp)
    800035a0:	6c02                	ld	s8,0(sp)
    800035a2:	6161                	addi	sp,sp,80
    800035a4:	8082                	ret
    ret = (i == n ? n : -1);
    800035a6:	5a7d                	li	s4,-1
    800035a8:	b7d5                	j	8000358c <filewrite+0xe2>
    panic("filewrite");
    800035aa:	00004517          	auipc	a0,0x4
    800035ae:	0c650513          	addi	a0,a0,198 # 80007670 <syscalls+0x258>
    800035b2:	651010ef          	jal	ra,80005402 <panic>
    return -1;
    800035b6:	5a7d                	li	s4,-1
    800035b8:	bfd1                	j	8000358c <filewrite+0xe2>
      return -1;
    800035ba:	5a7d                	li	s4,-1
    800035bc:	bfc1                	j	8000358c <filewrite+0xe2>
    800035be:	5a7d                	li	s4,-1
    800035c0:	b7f1                	j	8000358c <filewrite+0xe2>

00000000800035c2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800035c2:	7179                	addi	sp,sp,-48
    800035c4:	f406                	sd	ra,40(sp)
    800035c6:	f022                	sd	s0,32(sp)
    800035c8:	ec26                	sd	s1,24(sp)
    800035ca:	e84a                	sd	s2,16(sp)
    800035cc:	e44e                	sd	s3,8(sp)
    800035ce:	e052                	sd	s4,0(sp)
    800035d0:	1800                	addi	s0,sp,48
    800035d2:	84aa                	mv	s1,a0
    800035d4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800035d6:	0005b023          	sd	zero,0(a1)
    800035da:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800035de:	c75ff0ef          	jal	ra,80003252 <filealloc>
    800035e2:	e088                	sd	a0,0(s1)
    800035e4:	cd35                	beqz	a0,80003660 <pipealloc+0x9e>
    800035e6:	c6dff0ef          	jal	ra,80003252 <filealloc>
    800035ea:	00aa3023          	sd	a0,0(s4)
    800035ee:	c52d                	beqz	a0,80003658 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800035f0:	b0ffc0ef          	jal	ra,800000fe <kalloc>
    800035f4:	892a                	mv	s2,a0
    800035f6:	cd31                	beqz	a0,80003652 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800035f8:	4985                	li	s3,1
    800035fa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800035fe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003602:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003606:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000360a:	00004597          	auipc	a1,0x4
    8000360e:	07658593          	addi	a1,a1,118 # 80007680 <syscalls+0x268>
    80003612:	080020ef          	jal	ra,80005692 <initlock>
  (*f0)->type = FD_PIPE;
    80003616:	609c                	ld	a5,0(s1)
    80003618:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000361c:	609c                	ld	a5,0(s1)
    8000361e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003622:	609c                	ld	a5,0(s1)
    80003624:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003628:	609c                	ld	a5,0(s1)
    8000362a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000362e:	000a3783          	ld	a5,0(s4)
    80003632:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003636:	000a3783          	ld	a5,0(s4)
    8000363a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000363e:	000a3783          	ld	a5,0(s4)
    80003642:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003646:	000a3783          	ld	a5,0(s4)
    8000364a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000364e:	4501                	li	a0,0
    80003650:	a005                	j	80003670 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003652:	6088                	ld	a0,0(s1)
    80003654:	e501                	bnez	a0,8000365c <pipealloc+0x9a>
    80003656:	a029                	j	80003660 <pipealloc+0x9e>
    80003658:	6088                	ld	a0,0(s1)
    8000365a:	c11d                	beqz	a0,80003680 <pipealloc+0xbe>
    fileclose(*f0);
    8000365c:	c9bff0ef          	jal	ra,800032f6 <fileclose>
  if(*f1)
    80003660:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003664:	557d                	li	a0,-1
  if(*f1)
    80003666:	c789                	beqz	a5,80003670 <pipealloc+0xae>
    fileclose(*f1);
    80003668:	853e                	mv	a0,a5
    8000366a:	c8dff0ef          	jal	ra,800032f6 <fileclose>
  return -1;
    8000366e:	557d                	li	a0,-1
}
    80003670:	70a2                	ld	ra,40(sp)
    80003672:	7402                	ld	s0,32(sp)
    80003674:	64e2                	ld	s1,24(sp)
    80003676:	6942                	ld	s2,16(sp)
    80003678:	69a2                	ld	s3,8(sp)
    8000367a:	6a02                	ld	s4,0(sp)
    8000367c:	6145                	addi	sp,sp,48
    8000367e:	8082                	ret
  return -1;
    80003680:	557d                	li	a0,-1
    80003682:	b7fd                	j	80003670 <pipealloc+0xae>

0000000080003684 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
    80003690:	84aa                	mv	s1,a0
    80003692:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003694:	07e020ef          	jal	ra,80005712 <acquire>
  if(writable){
    80003698:	02090763          	beqz	s2,800036c6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000369c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800036a0:	21848513          	addi	a0,s1,536
    800036a4:	c83fd0ef          	jal	ra,80001326 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800036a8:	2204b783          	ld	a5,544(s1)
    800036ac:	e785                	bnez	a5,800036d4 <pipeclose+0x50>
    release(&pi->lock);
    800036ae:	8526                	mv	a0,s1
    800036b0:	0fa020ef          	jal	ra,800057aa <release>
    kfree((char*)pi);
    800036b4:	8526                	mv	a0,s1
    800036b6:	967fc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	64a2                	ld	s1,8(sp)
    800036c0:	6902                	ld	s2,0(sp)
    800036c2:	6105                	addi	sp,sp,32
    800036c4:	8082                	ret
    pi->readopen = 0;
    800036c6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800036ca:	21c48513          	addi	a0,s1,540
    800036ce:	c59fd0ef          	jal	ra,80001326 <wakeup>
    800036d2:	bfd9                	j	800036a8 <pipeclose+0x24>
    release(&pi->lock);
    800036d4:	8526                	mv	a0,s1
    800036d6:	0d4020ef          	jal	ra,800057aa <release>
}
    800036da:	b7c5                	j	800036ba <pipeclose+0x36>

00000000800036dc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800036dc:	711d                	addi	sp,sp,-96
    800036de:	ec86                	sd	ra,88(sp)
    800036e0:	e8a2                	sd	s0,80(sp)
    800036e2:	e4a6                	sd	s1,72(sp)
    800036e4:	e0ca                	sd	s2,64(sp)
    800036e6:	fc4e                	sd	s3,56(sp)
    800036e8:	f852                	sd	s4,48(sp)
    800036ea:	f456                	sd	s5,40(sp)
    800036ec:	f05a                	sd	s6,32(sp)
    800036ee:	ec5e                	sd	s7,24(sp)
    800036f0:	e862                	sd	s8,16(sp)
    800036f2:	1080                	addi	s0,sp,96
    800036f4:	84aa                	mv	s1,a0
    800036f6:	8aae                	mv	s5,a1
    800036f8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800036fa:	e12fd0ef          	jal	ra,80000d0c <myproc>
    800036fe:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003700:	8526                	mv	a0,s1
    80003702:	010020ef          	jal	ra,80005712 <acquire>
  while(i < n){
    80003706:	09405c63          	blez	s4,8000379e <pipewrite+0xc2>
  int i = 0;
    8000370a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000370c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000370e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003712:	21c48b93          	addi	s7,s1,540
    80003716:	a81d                	j	8000374c <pipewrite+0x70>
      release(&pi->lock);
    80003718:	8526                	mv	a0,s1
    8000371a:	090020ef          	jal	ra,800057aa <release>
      return -1;
    8000371e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003720:	854a                	mv	a0,s2
    80003722:	60e6                	ld	ra,88(sp)
    80003724:	6446                	ld	s0,80(sp)
    80003726:	64a6                	ld	s1,72(sp)
    80003728:	6906                	ld	s2,64(sp)
    8000372a:	79e2                	ld	s3,56(sp)
    8000372c:	7a42                	ld	s4,48(sp)
    8000372e:	7aa2                	ld	s5,40(sp)
    80003730:	7b02                	ld	s6,32(sp)
    80003732:	6be2                	ld	s7,24(sp)
    80003734:	6c42                	ld	s8,16(sp)
    80003736:	6125                	addi	sp,sp,96
    80003738:	8082                	ret
      wakeup(&pi->nread);
    8000373a:	8562                	mv	a0,s8
    8000373c:	bebfd0ef          	jal	ra,80001326 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003740:	85a6                	mv	a1,s1
    80003742:	855e                	mv	a0,s7
    80003744:	b97fd0ef          	jal	ra,800012da <sleep>
  while(i < n){
    80003748:	05495c63          	bge	s2,s4,800037a0 <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    8000374c:	2204a783          	lw	a5,544(s1)
    80003750:	d7e1                	beqz	a5,80003718 <pipewrite+0x3c>
    80003752:	854e                	mv	a0,s3
    80003754:	dbffd0ef          	jal	ra,80001512 <killed>
    80003758:	f161                	bnez	a0,80003718 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000375a:	2184a783          	lw	a5,536(s1)
    8000375e:	21c4a703          	lw	a4,540(s1)
    80003762:	2007879b          	addiw	a5,a5,512
    80003766:	fcf70ae3          	beq	a4,a5,8000373a <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000376a:	4685                	li	a3,1
    8000376c:	01590633          	add	a2,s2,s5
    80003770:	faf40593          	addi	a1,s0,-81
    80003774:	0509b503          	ld	a0,80(s3)
    80003778:	b04fd0ef          	jal	ra,80000a7c <copyin>
    8000377c:	03650263          	beq	a0,s6,800037a0 <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003780:	21c4a783          	lw	a5,540(s1)
    80003784:	0017871b          	addiw	a4,a5,1
    80003788:	20e4ae23          	sw	a4,540(s1)
    8000378c:	1ff7f793          	andi	a5,a5,511
    80003790:	97a6                	add	a5,a5,s1
    80003792:	faf44703          	lbu	a4,-81(s0)
    80003796:	00e78c23          	sb	a4,24(a5)
      i++;
    8000379a:	2905                	addiw	s2,s2,1
    8000379c:	b775                	j	80003748 <pipewrite+0x6c>
  int i = 0;
    8000379e:	4901                	li	s2,0
  wakeup(&pi->nread);
    800037a0:	21848513          	addi	a0,s1,536
    800037a4:	b83fd0ef          	jal	ra,80001326 <wakeup>
  release(&pi->lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	000020ef          	jal	ra,800057aa <release>
  return i;
    800037ae:	bf8d                	j	80003720 <pipewrite+0x44>

00000000800037b0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800037b0:	715d                	addi	sp,sp,-80
    800037b2:	e486                	sd	ra,72(sp)
    800037b4:	e0a2                	sd	s0,64(sp)
    800037b6:	fc26                	sd	s1,56(sp)
    800037b8:	f84a                	sd	s2,48(sp)
    800037ba:	f44e                	sd	s3,40(sp)
    800037bc:	f052                	sd	s4,32(sp)
    800037be:	ec56                	sd	s5,24(sp)
    800037c0:	e85a                	sd	s6,16(sp)
    800037c2:	0880                	addi	s0,sp,80
    800037c4:	84aa                	mv	s1,a0
    800037c6:	892e                	mv	s2,a1
    800037c8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800037ca:	d42fd0ef          	jal	ra,80000d0c <myproc>
    800037ce:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800037d0:	8526                	mv	a0,s1
    800037d2:	741010ef          	jal	ra,80005712 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800037d6:	2184a703          	lw	a4,536(s1)
    800037da:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800037de:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800037e2:	02f71363          	bne	a4,a5,80003808 <piperead+0x58>
    800037e6:	2244a783          	lw	a5,548(s1)
    800037ea:	cf99                	beqz	a5,80003808 <piperead+0x58>
    if(killed(pr)){
    800037ec:	8552                	mv	a0,s4
    800037ee:	d25fd0ef          	jal	ra,80001512 <killed>
    800037f2:	e149                	bnez	a0,80003874 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800037f4:	85a6                	mv	a1,s1
    800037f6:	854e                	mv	a0,s3
    800037f8:	ae3fd0ef          	jal	ra,800012da <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800037fc:	2184a703          	lw	a4,536(s1)
    80003800:	21c4a783          	lw	a5,540(s1)
    80003804:	fef701e3          	beq	a4,a5,800037e6 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003808:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000380a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000380c:	05505263          	blez	s5,80003850 <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    80003810:	2184a783          	lw	a5,536(s1)
    80003814:	21c4a703          	lw	a4,540(s1)
    80003818:	02f70c63          	beq	a4,a5,80003850 <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000381c:	0017871b          	addiw	a4,a5,1
    80003820:	20e4ac23          	sw	a4,536(s1)
    80003824:	1ff7f793          	andi	a5,a5,511
    80003828:	97a6                	add	a5,a5,s1
    8000382a:	0187c783          	lbu	a5,24(a5)
    8000382e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003832:	4685                	li	a3,1
    80003834:	fbf40613          	addi	a2,s0,-65
    80003838:	85ca                	mv	a1,s2
    8000383a:	050a3503          	ld	a0,80(s4)
    8000383e:	986fd0ef          	jal	ra,800009c4 <copyout>
    80003842:	01650763          	beq	a0,s6,80003850 <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003846:	2985                	addiw	s3,s3,1
    80003848:	0905                	addi	s2,s2,1
    8000384a:	fd3a93e3          	bne	s5,s3,80003810 <piperead+0x60>
    8000384e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003850:	21c48513          	addi	a0,s1,540
    80003854:	ad3fd0ef          	jal	ra,80001326 <wakeup>
  release(&pi->lock);
    80003858:	8526                	mv	a0,s1
    8000385a:	751010ef          	jal	ra,800057aa <release>
  return i;
}
    8000385e:	854e                	mv	a0,s3
    80003860:	60a6                	ld	ra,72(sp)
    80003862:	6406                	ld	s0,64(sp)
    80003864:	74e2                	ld	s1,56(sp)
    80003866:	7942                	ld	s2,48(sp)
    80003868:	79a2                	ld	s3,40(sp)
    8000386a:	7a02                	ld	s4,32(sp)
    8000386c:	6ae2                	ld	s5,24(sp)
    8000386e:	6b42                	ld	s6,16(sp)
    80003870:	6161                	addi	sp,sp,80
    80003872:	8082                	ret
      release(&pi->lock);
    80003874:	8526                	mv	a0,s1
    80003876:	735010ef          	jal	ra,800057aa <release>
      return -1;
    8000387a:	59fd                	li	s3,-1
    8000387c:	b7cd                	j	8000385e <piperead+0xae>

000000008000387e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000387e:	1141                	addi	sp,sp,-16
    80003880:	e422                	sd	s0,8(sp)
    80003882:	0800                	addi	s0,sp,16
    80003884:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003886:	8905                	andi	a0,a0,1
    80003888:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000388a:	8b89                	andi	a5,a5,2
    8000388c:	c399                	beqz	a5,80003892 <flags2perm+0x14>
      perm |= PTE_W;
    8000388e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003892:	6422                	ld	s0,8(sp)
    80003894:	0141                	addi	sp,sp,16
    80003896:	8082                	ret

0000000080003898 <exec>:

int
exec(char *path, char **argv)
{
    80003898:	de010113          	addi	sp,sp,-544
    8000389c:	20113c23          	sd	ra,536(sp)
    800038a0:	20813823          	sd	s0,528(sp)
    800038a4:	20913423          	sd	s1,520(sp)
    800038a8:	21213023          	sd	s2,512(sp)
    800038ac:	ffce                	sd	s3,504(sp)
    800038ae:	fbd2                	sd	s4,496(sp)
    800038b0:	f7d6                	sd	s5,488(sp)
    800038b2:	f3da                	sd	s6,480(sp)
    800038b4:	efde                	sd	s7,472(sp)
    800038b6:	ebe2                	sd	s8,464(sp)
    800038b8:	e7e6                	sd	s9,456(sp)
    800038ba:	e3ea                	sd	s10,448(sp)
    800038bc:	ff6e                	sd	s11,440(sp)
    800038be:	1400                	addi	s0,sp,544
    800038c0:	892a                	mv	s2,a0
    800038c2:	dea43423          	sd	a0,-536(s0)
    800038c6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800038ca:	c42fd0ef          	jal	ra,80000d0c <myproc>
    800038ce:	84aa                	mv	s1,a0

  begin_op();
    800038d0:	e0eff0ef          	jal	ra,80002ede <begin_op>

  if((ip = namei(path)) == 0){
    800038d4:	854a                	mv	a0,s2
    800038d6:	c2cff0ef          	jal	ra,80002d02 <namei>
    800038da:	c13d                	beqz	a0,80003940 <exec+0xa8>
    800038dc:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800038de:	d6bfe0ef          	jal	ra,80002648 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800038e2:	04000713          	li	a4,64
    800038e6:	4681                	li	a3,0
    800038e8:	e5040613          	addi	a2,s0,-432
    800038ec:	4581                	li	a1,0
    800038ee:	8556                	mv	a0,s5
    800038f0:	fa9fe0ef          	jal	ra,80002898 <readi>
    800038f4:	04000793          	li	a5,64
    800038f8:	00f51a63          	bne	a0,a5,8000390c <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800038fc:	e5042703          	lw	a4,-432(s0)
    80003900:	464c47b7          	lui	a5,0x464c4
    80003904:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003908:	04f70063          	beq	a4,a5,80003948 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000390c:	8556                	mv	a0,s5
    8000390e:	f41fe0ef          	jal	ra,8000284e <iunlockput>
    end_op();
    80003912:	e3aff0ef          	jal	ra,80002f4c <end_op>
  }
  return -1;
    80003916:	557d                	li	a0,-1
}
    80003918:	21813083          	ld	ra,536(sp)
    8000391c:	21013403          	ld	s0,528(sp)
    80003920:	20813483          	ld	s1,520(sp)
    80003924:	20013903          	ld	s2,512(sp)
    80003928:	79fe                	ld	s3,504(sp)
    8000392a:	7a5e                	ld	s4,496(sp)
    8000392c:	7abe                	ld	s5,488(sp)
    8000392e:	7b1e                	ld	s6,480(sp)
    80003930:	6bfe                	ld	s7,472(sp)
    80003932:	6c5e                	ld	s8,464(sp)
    80003934:	6cbe                	ld	s9,456(sp)
    80003936:	6d1e                	ld	s10,448(sp)
    80003938:	7dfa                	ld	s11,440(sp)
    8000393a:	22010113          	addi	sp,sp,544
    8000393e:	8082                	ret
    end_op();
    80003940:	e0cff0ef          	jal	ra,80002f4c <end_op>
    return -1;
    80003944:	557d                	li	a0,-1
    80003946:	bfc9                	j	80003918 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80003948:	8526                	mv	a0,s1
    8000394a:	c6afd0ef          	jal	ra,80000db4 <proc_pagetable>
    8000394e:	8b2a                	mv	s6,a0
    80003950:	dd55                	beqz	a0,8000390c <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003952:	e7042783          	lw	a5,-400(s0)
    80003956:	e8845703          	lhu	a4,-376(s0)
    8000395a:	c325                	beqz	a4,800039ba <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000395c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000395e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80003962:	6a05                	lui	s4,0x1
    80003964:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80003968:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000396c:	6d85                	lui	s11,0x1
    8000396e:	7d7d                	lui	s10,0xfffff
    80003970:	a409                	j	80003b72 <exec+0x2da>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80003972:	00004517          	auipc	a0,0x4
    80003976:	d1650513          	addi	a0,a0,-746 # 80007688 <syscalls+0x270>
    8000397a:	289010ef          	jal	ra,80005402 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000397e:	874a                	mv	a4,s2
    80003980:	009c86bb          	addw	a3,s9,s1
    80003984:	4581                	li	a1,0
    80003986:	8556                	mv	a0,s5
    80003988:	f11fe0ef          	jal	ra,80002898 <readi>
    8000398c:	2501                	sext.w	a0,a0
    8000398e:	18a91163          	bne	s2,a0,80003b10 <exec+0x278>
  for(i = 0; i < sz; i += PGSIZE){
    80003992:	009d84bb          	addw	s1,s11,s1
    80003996:	013d09bb          	addw	s3,s10,s3
    8000399a:	1b74fc63          	bgeu	s1,s7,80003b52 <exec+0x2ba>
    pa = walkaddr(pagetable, va + i);
    8000399e:	02049593          	slli	a1,s1,0x20
    800039a2:	9181                	srli	a1,a1,0x20
    800039a4:	95e2                	add	a1,a1,s8
    800039a6:	855a                	mv	a0,s6
    800039a8:	abdfc0ef          	jal	ra,80000464 <walkaddr>
    800039ac:	862a                	mv	a2,a0
    if(pa == 0)
    800039ae:	d171                	beqz	a0,80003972 <exec+0xda>
      n = PGSIZE;
    800039b0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800039b2:	fd49f6e3          	bgeu	s3,s4,8000397e <exec+0xe6>
      n = sz - i;
    800039b6:	894e                	mv	s2,s3
    800039b8:	b7d9                	j	8000397e <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800039ba:	4901                	li	s2,0
  iunlockput(ip);
    800039bc:	8556                	mv	a0,s5
    800039be:	e91fe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    800039c2:	d8aff0ef          	jal	ra,80002f4c <end_op>
  p = myproc();
    800039c6:	b46fd0ef          	jal	ra,80000d0c <myproc>
    800039ca:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800039cc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800039d0:	6785                	lui	a5,0x1
    800039d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800039d4:	97ca                	add	a5,a5,s2
    800039d6:	777d                	lui	a4,0xfffff
    800039d8:	8ff9                	and	a5,a5,a4
    800039da:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800039de:	4691                	li	a3,4
    800039e0:	6609                	lui	a2,0x2
    800039e2:	963e                	add	a2,a2,a5
    800039e4:	85be                	mv	a1,a5
    800039e6:	855a                	mv	a0,s6
    800039e8:	dd5fc0ef          	jal	ra,800007bc <uvmalloc>
    800039ec:	8c2a                	mv	s8,a0
  ip = 0;
    800039ee:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800039f0:	12050063          	beqz	a0,80003b10 <exec+0x278>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800039f4:	75f9                	lui	a1,0xffffe
    800039f6:	95aa                	add	a1,a1,a0
    800039f8:	855a                	mv	a0,s6
    800039fa:	fa1fc0ef          	jal	ra,8000099a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800039fe:	7afd                	lui	s5,0xfffff
    80003a00:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80003a02:	df043783          	ld	a5,-528(s0)
    80003a06:	6388                	ld	a0,0(a5)
    80003a08:	c135                	beqz	a0,80003a6c <exec+0x1d4>
    80003a0a:	e9040993          	addi	s3,s0,-368
    80003a0e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003a12:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003a14:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003a16:	8b1fc0ef          	jal	ra,800002c6 <strlen>
    80003a1a:	0015079b          	addiw	a5,a0,1
    80003a1e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003a22:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003a26:	11596a63          	bltu	s2,s5,80003b3a <exec+0x2a2>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003a2a:	df043d83          	ld	s11,-528(s0)
    80003a2e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80003a32:	8552                	mv	a0,s4
    80003a34:	893fc0ef          	jal	ra,800002c6 <strlen>
    80003a38:	0015069b          	addiw	a3,a0,1
    80003a3c:	8652                	mv	a2,s4
    80003a3e:	85ca                	mv	a1,s2
    80003a40:	855a                	mv	a0,s6
    80003a42:	f83fc0ef          	jal	ra,800009c4 <copyout>
    80003a46:	0e054e63          	bltz	a0,80003b42 <exec+0x2aa>
    ustack[argc] = sp;
    80003a4a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003a4e:	0485                	addi	s1,s1,1
    80003a50:	008d8793          	addi	a5,s11,8
    80003a54:	def43823          	sd	a5,-528(s0)
    80003a58:	008db503          	ld	a0,8(s11)
    80003a5c:	c911                	beqz	a0,80003a70 <exec+0x1d8>
    if(argc >= MAXARG)
    80003a5e:	09a1                	addi	s3,s3,8
    80003a60:	fb3c9be3          	bne	s9,s3,80003a16 <exec+0x17e>
  sz = sz1;
    80003a64:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003a68:	4a81                	li	s5,0
    80003a6a:	a05d                	j	80003b10 <exec+0x278>
  sp = sz;
    80003a6c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80003a6e:	4481                	li	s1,0
  ustack[argc] = 0;
    80003a70:	00349793          	slli	a5,s1,0x3
    80003a74:	f9078793          	addi	a5,a5,-112
    80003a78:	97a2                	add	a5,a5,s0
    80003a7a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003a7e:	00148693          	addi	a3,s1,1
    80003a82:	068e                	slli	a3,a3,0x3
    80003a84:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003a88:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003a8c:	01597663          	bgeu	s2,s5,80003a98 <exec+0x200>
  sz = sz1;
    80003a90:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003a94:	4a81                	li	s5,0
    80003a96:	a8ad                	j	80003b10 <exec+0x278>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003a98:	e9040613          	addi	a2,s0,-368
    80003a9c:	85ca                	mv	a1,s2
    80003a9e:	855a                	mv	a0,s6
    80003aa0:	f25fc0ef          	jal	ra,800009c4 <copyout>
    80003aa4:	0a054363          	bltz	a0,80003b4a <exec+0x2b2>
  p->trapframe->a1 = sp;
    80003aa8:	058bb783          	ld	a5,88(s7)
    80003aac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ab0:	de843783          	ld	a5,-536(s0)
    80003ab4:	0007c703          	lbu	a4,0(a5)
    80003ab8:	cf11                	beqz	a4,80003ad4 <exec+0x23c>
    80003aba:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003abc:	02f00693          	li	a3,47
    80003ac0:	a039                	j	80003ace <exec+0x236>
      last = s+1;
    80003ac2:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80003ac6:	0785                	addi	a5,a5,1
    80003ac8:	fff7c703          	lbu	a4,-1(a5)
    80003acc:	c701                	beqz	a4,80003ad4 <exec+0x23c>
    if(*s == '/')
    80003ace:	fed71ce3          	bne	a4,a3,80003ac6 <exec+0x22e>
    80003ad2:	bfc5                	j	80003ac2 <exec+0x22a>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ad4:	4641                	li	a2,16
    80003ad6:	de843583          	ld	a1,-536(s0)
    80003ada:	158b8513          	addi	a0,s7,344
    80003ade:	fb6fc0ef          	jal	ra,80000294 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ae2:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80003ae6:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80003aea:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003aee:	058bb783          	ld	a5,88(s7)
    80003af2:	e6843703          	ld	a4,-408(s0)
    80003af6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003af8:	058bb783          	ld	a5,88(s7)
    80003afc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003b00:	85ea                	mv	a1,s10
    80003b02:	b36fd0ef          	jal	ra,80000e38 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003b06:	0004851b          	sext.w	a0,s1
    80003b0a:	b539                	j	80003918 <exec+0x80>
    80003b0c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003b10:	df843583          	ld	a1,-520(s0)
    80003b14:	855a                	mv	a0,s6
    80003b16:	b22fd0ef          	jal	ra,80000e38 <proc_freepagetable>
  if(ip){
    80003b1a:	de0a99e3          	bnez	s5,8000390c <exec+0x74>
  return -1;
    80003b1e:	557d                	li	a0,-1
    80003b20:	bbe5                	j	80003918 <exec+0x80>
    80003b22:	df243c23          	sd	s2,-520(s0)
    80003b26:	b7ed                	j	80003b10 <exec+0x278>
    80003b28:	df243c23          	sd	s2,-520(s0)
    80003b2c:	b7d5                	j	80003b10 <exec+0x278>
    80003b2e:	df243c23          	sd	s2,-520(s0)
    80003b32:	bff9                	j	80003b10 <exec+0x278>
    80003b34:	df243c23          	sd	s2,-520(s0)
    80003b38:	bfe1                	j	80003b10 <exec+0x278>
  sz = sz1;
    80003b3a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003b3e:	4a81                	li	s5,0
    80003b40:	bfc1                	j	80003b10 <exec+0x278>
  sz = sz1;
    80003b42:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003b46:	4a81                	li	s5,0
    80003b48:	b7e1                	j	80003b10 <exec+0x278>
  sz = sz1;
    80003b4a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80003b4e:	4a81                	li	s5,0
    80003b50:	b7c1                	j	80003b10 <exec+0x278>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b52:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b56:	e0843783          	ld	a5,-504(s0)
    80003b5a:	0017869b          	addiw	a3,a5,1
    80003b5e:	e0d43423          	sd	a3,-504(s0)
    80003b62:	e0043783          	ld	a5,-512(s0)
    80003b66:	0387879b          	addiw	a5,a5,56
    80003b6a:	e8845703          	lhu	a4,-376(s0)
    80003b6e:	e4e6d7e3          	bge	a3,a4,800039bc <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b72:	2781                	sext.w	a5,a5
    80003b74:	e0f43023          	sd	a5,-512(s0)
    80003b78:	03800713          	li	a4,56
    80003b7c:	86be                	mv	a3,a5
    80003b7e:	e1840613          	addi	a2,s0,-488
    80003b82:	4581                	li	a1,0
    80003b84:	8556                	mv	a0,s5
    80003b86:	d13fe0ef          	jal	ra,80002898 <readi>
    80003b8a:	03800793          	li	a5,56
    80003b8e:	f6f51fe3          	bne	a0,a5,80003b0c <exec+0x274>
    if(ph.type != ELF_PROG_LOAD)
    80003b92:	e1842783          	lw	a5,-488(s0)
    80003b96:	4705                	li	a4,1
    80003b98:	fae79fe3          	bne	a5,a4,80003b56 <exec+0x2be>
    if(ph.memsz < ph.filesz)
    80003b9c:	e4043483          	ld	s1,-448(s0)
    80003ba0:	e3843783          	ld	a5,-456(s0)
    80003ba4:	f6f4efe3          	bltu	s1,a5,80003b22 <exec+0x28a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003ba8:	e2843783          	ld	a5,-472(s0)
    80003bac:	94be                	add	s1,s1,a5
    80003bae:	f6f4ede3          	bltu	s1,a5,80003b28 <exec+0x290>
    if(ph.vaddr % PGSIZE != 0)
    80003bb2:	de043703          	ld	a4,-544(s0)
    80003bb6:	8ff9                	and	a5,a5,a4
    80003bb8:	fbbd                	bnez	a5,80003b2e <exec+0x296>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bba:	e1c42503          	lw	a0,-484(s0)
    80003bbe:	cc1ff0ef          	jal	ra,8000387e <flags2perm>
    80003bc2:	86aa                	mv	a3,a0
    80003bc4:	8626                	mv	a2,s1
    80003bc6:	85ca                	mv	a1,s2
    80003bc8:	855a                	mv	a0,s6
    80003bca:	bf3fc0ef          	jal	ra,800007bc <uvmalloc>
    80003bce:	dea43c23          	sd	a0,-520(s0)
    80003bd2:	d12d                	beqz	a0,80003b34 <exec+0x29c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003bd4:	e2843c03          	ld	s8,-472(s0)
    80003bd8:	e2042c83          	lw	s9,-480(s0)
    80003bdc:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003be0:	f60b89e3          	beqz	s7,80003b52 <exec+0x2ba>
    80003be4:	89de                	mv	s3,s7
    80003be6:	4481                	li	s1,0
    80003be8:	bb5d                	j	8000399e <exec+0x106>

0000000080003bea <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003bea:	7179                	addi	sp,sp,-48
    80003bec:	f406                	sd	ra,40(sp)
    80003bee:	f022                	sd	s0,32(sp)
    80003bf0:	ec26                	sd	s1,24(sp)
    80003bf2:	e84a                	sd	s2,16(sp)
    80003bf4:	1800                	addi	s0,sp,48
    80003bf6:	892e                	mv	s2,a1
    80003bf8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003bfa:	fdc40593          	addi	a1,s0,-36
    80003bfe:	fbffd0ef          	jal	ra,80001bbc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003c02:	fdc42703          	lw	a4,-36(s0)
    80003c06:	47bd                	li	a5,15
    80003c08:	02e7e963          	bltu	a5,a4,80003c3a <argfd+0x50>
    80003c0c:	900fd0ef          	jal	ra,80000d0c <myproc>
    80003c10:	fdc42703          	lw	a4,-36(s0)
    80003c14:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffe2fca>
    80003c18:	078e                	slli	a5,a5,0x3
    80003c1a:	953e                	add	a0,a0,a5
    80003c1c:	611c                	ld	a5,0(a0)
    80003c1e:	c385                	beqz	a5,80003c3e <argfd+0x54>
    return -1;
  if(pfd)
    80003c20:	00090463          	beqz	s2,80003c28 <argfd+0x3e>
    *pfd = fd;
    80003c24:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003c28:	4501                	li	a0,0
  if(pf)
    80003c2a:	c091                	beqz	s1,80003c2e <argfd+0x44>
    *pf = f;
    80003c2c:	e09c                	sd	a5,0(s1)
}
    80003c2e:	70a2                	ld	ra,40(sp)
    80003c30:	7402                	ld	s0,32(sp)
    80003c32:	64e2                	ld	s1,24(sp)
    80003c34:	6942                	ld	s2,16(sp)
    80003c36:	6145                	addi	sp,sp,48
    80003c38:	8082                	ret
    return -1;
    80003c3a:	557d                	li	a0,-1
    80003c3c:	bfcd                	j	80003c2e <argfd+0x44>
    80003c3e:	557d                	li	a0,-1
    80003c40:	b7fd                	j	80003c2e <argfd+0x44>

0000000080003c42 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003c42:	1101                	addi	sp,sp,-32
    80003c44:	ec06                	sd	ra,24(sp)
    80003c46:	e822                	sd	s0,16(sp)
    80003c48:	e426                	sd	s1,8(sp)
    80003c4a:	1000                	addi	s0,sp,32
    80003c4c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003c4e:	8befd0ef          	jal	ra,80000d0c <myproc>
    80003c52:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003c54:	0d050793          	addi	a5,a0,208
    80003c58:	4501                	li	a0,0
    80003c5a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003c5c:	6398                	ld	a4,0(a5)
    80003c5e:	cb19                	beqz	a4,80003c74 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003c60:	2505                	addiw	a0,a0,1
    80003c62:	07a1                	addi	a5,a5,8
    80003c64:	fed51ce3          	bne	a0,a3,80003c5c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003c68:	557d                	li	a0,-1
}
    80003c6a:	60e2                	ld	ra,24(sp)
    80003c6c:	6442                	ld	s0,16(sp)
    80003c6e:	64a2                	ld	s1,8(sp)
    80003c70:	6105                	addi	sp,sp,32
    80003c72:	8082                	ret
      p->ofile[fd] = f;
    80003c74:	01a50793          	addi	a5,a0,26
    80003c78:	078e                	slli	a5,a5,0x3
    80003c7a:	963e                	add	a2,a2,a5
    80003c7c:	e204                	sd	s1,0(a2)
      return fd;
    80003c7e:	b7f5                	j	80003c6a <fdalloc+0x28>

0000000080003c80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003c80:	715d                	addi	sp,sp,-80
    80003c82:	e486                	sd	ra,72(sp)
    80003c84:	e0a2                	sd	s0,64(sp)
    80003c86:	fc26                	sd	s1,56(sp)
    80003c88:	f84a                	sd	s2,48(sp)
    80003c8a:	f44e                	sd	s3,40(sp)
    80003c8c:	f052                	sd	s4,32(sp)
    80003c8e:	ec56                	sd	s5,24(sp)
    80003c90:	e85a                	sd	s6,16(sp)
    80003c92:	0880                	addi	s0,sp,80
    80003c94:	8b2e                	mv	s6,a1
    80003c96:	89b2                	mv	s3,a2
    80003c98:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003c9a:	fb040593          	addi	a1,s0,-80
    80003c9e:	87eff0ef          	jal	ra,80002d1c <nameiparent>
    80003ca2:	84aa                	mv	s1,a0
    80003ca4:	12050063          	beqz	a0,80003dc4 <create+0x144>
    return 0;

  ilock(dp);
    80003ca8:	9a1fe0ef          	jal	ra,80002648 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003cac:	4601                	li	a2,0
    80003cae:	fb040593          	addi	a1,s0,-80
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	de3fe0ef          	jal	ra,80002a96 <dirlookup>
    80003cb8:	8aaa                	mv	s5,a0
    80003cba:	c929                	beqz	a0,80003d0c <create+0x8c>
    iunlockput(dp);
    80003cbc:	8526                	mv	a0,s1
    80003cbe:	b91fe0ef          	jal	ra,8000284e <iunlockput>
    ilock(ip);
    80003cc2:	8556                	mv	a0,s5
    80003cc4:	985fe0ef          	jal	ra,80002648 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003cc8:	000b079b          	sext.w	a5,s6
    80003ccc:	4709                	li	a4,2
    80003cce:	02e78263          	beq	a5,a4,80003cf2 <create+0x72>
      return ip;
    if(type == T_SYMLINK) {
    80003cd2:	000b059b          	sext.w	a1,s6
    80003cd6:	4791                	li	a5,4
    80003cd8:	02f59563          	bne	a1,a5,80003d02 <create+0x82>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003cdc:	8556                	mv	a0,s5
    80003cde:	60a6                	ld	ra,72(sp)
    80003ce0:	6406                	ld	s0,64(sp)
    80003ce2:	74e2                	ld	s1,56(sp)
    80003ce4:	7942                	ld	s2,48(sp)
    80003ce6:	79a2                	ld	s3,40(sp)
    80003ce8:	7a02                	ld	s4,32(sp)
    80003cea:	6ae2                	ld	s5,24(sp)
    80003cec:	6b42                	ld	s6,16(sp)
    80003cee:	6161                	addi	sp,sp,80
    80003cf0:	8082                	ret
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003cf2:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffe2ff4>
    80003cf6:	37f9                	addiw	a5,a5,-2
    80003cf8:	17c2                	slli	a5,a5,0x30
    80003cfa:	93c1                	srli	a5,a5,0x30
    80003cfc:	4705                	li	a4,1
    80003cfe:	fcf77fe3          	bgeu	a4,a5,80003cdc <create+0x5c>
    iunlockput(ip);
    80003d02:	8556                	mv	a0,s5
    80003d04:	b4bfe0ef          	jal	ra,8000284e <iunlockput>
    return 0;
    80003d08:	4a81                	li	s5,0
    80003d0a:	bfc9                	j	80003cdc <create+0x5c>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003d0c:	85da                	mv	a1,s6
    80003d0e:	4088                	lw	a0,0(s1)
    80003d10:	fcefe0ef          	jal	ra,800024de <ialloc>
    80003d14:	8a2a                	mv	s4,a0
    80003d16:	cd1d                	beqz	a0,80003d54 <create+0xd4>
  ilock(ip);
    80003d18:	931fe0ef          	jal	ra,80002648 <ilock>
  ip->major = major;
    80003d1c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003d20:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003d24:	4905                	li	s2,1
    80003d26:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003d2a:	8552                	mv	a0,s4
    80003d2c:	869fe0ef          	jal	ra,80002594 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003d30:	000b059b          	sext.w	a1,s6
    80003d34:	03258563          	beq	a1,s2,80003d5e <create+0xde>
  if(dirlink(dp, name, ip->inum) < 0)
    80003d38:	004a2603          	lw	a2,4(s4)
    80003d3c:	fb040593          	addi	a1,s0,-80
    80003d40:	8526                	mv	a0,s1
    80003d42:	f27fe0ef          	jal	ra,80002c68 <dirlink>
    80003d46:	06054363          	bltz	a0,80003dac <create+0x12c>
  iunlockput(dp);
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	b03fe0ef          	jal	ra,8000284e <iunlockput>
  return ip;
    80003d50:	8ad2                	mv	s5,s4
    80003d52:	b769                	j	80003cdc <create+0x5c>
    iunlockput(dp);
    80003d54:	8526                	mv	a0,s1
    80003d56:	af9fe0ef          	jal	ra,8000284e <iunlockput>
    return 0;
    80003d5a:	8ad2                	mv	s5,s4
    80003d5c:	b741                	j	80003cdc <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003d5e:	004a2603          	lw	a2,4(s4)
    80003d62:	00004597          	auipc	a1,0x4
    80003d66:	94658593          	addi	a1,a1,-1722 # 800076a8 <syscalls+0x290>
    80003d6a:	8552                	mv	a0,s4
    80003d6c:	efdfe0ef          	jal	ra,80002c68 <dirlink>
    80003d70:	02054e63          	bltz	a0,80003dac <create+0x12c>
    80003d74:	40d0                	lw	a2,4(s1)
    80003d76:	00004597          	auipc	a1,0x4
    80003d7a:	93a58593          	addi	a1,a1,-1734 # 800076b0 <syscalls+0x298>
    80003d7e:	8552                	mv	a0,s4
    80003d80:	ee9fe0ef          	jal	ra,80002c68 <dirlink>
    80003d84:	02054463          	bltz	a0,80003dac <create+0x12c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003d88:	004a2603          	lw	a2,4(s4)
    80003d8c:	fb040593          	addi	a1,s0,-80
    80003d90:	8526                	mv	a0,s1
    80003d92:	ed7fe0ef          	jal	ra,80002c68 <dirlink>
    80003d96:	00054b63          	bltz	a0,80003dac <create+0x12c>
    dp->nlink++;  // for ".."
    80003d9a:	04a4d783          	lhu	a5,74(s1)
    80003d9e:	2785                	addiw	a5,a5,1
    80003da0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003da4:	8526                	mv	a0,s1
    80003da6:	feefe0ef          	jal	ra,80002594 <iupdate>
    80003daa:	b745                	j	80003d4a <create+0xca>
  ip->nlink = 0;
    80003dac:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003db0:	8552                	mv	a0,s4
    80003db2:	fe2fe0ef          	jal	ra,80002594 <iupdate>
  iunlockput(ip);
    80003db6:	8552                	mv	a0,s4
    80003db8:	a97fe0ef          	jal	ra,8000284e <iunlockput>
  iunlockput(dp);
    80003dbc:	8526                	mv	a0,s1
    80003dbe:	a91fe0ef          	jal	ra,8000284e <iunlockput>
  return 0;
    80003dc2:	bf29                	j	80003cdc <create+0x5c>
    return 0;
    80003dc4:	8aaa                	mv	s5,a0
    80003dc6:	bf19                	j	80003cdc <create+0x5c>

0000000080003dc8 <sys_dup>:
{
    80003dc8:	7179                	addi	sp,sp,-48
    80003dca:	f406                	sd	ra,40(sp)
    80003dcc:	f022                	sd	s0,32(sp)
    80003dce:	ec26                	sd	s1,24(sp)
    80003dd0:	e84a                	sd	s2,16(sp)
    80003dd2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003dd4:	fd840613          	addi	a2,s0,-40
    80003dd8:	4581                	li	a1,0
    80003dda:	4501                	li	a0,0
    80003ddc:	e0fff0ef          	jal	ra,80003bea <argfd>
    return -1;
    80003de0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003de2:	00054f63          	bltz	a0,80003e00 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80003de6:	fd843903          	ld	s2,-40(s0)
    80003dea:	854a                	mv	a0,s2
    80003dec:	e57ff0ef          	jal	ra,80003c42 <fdalloc>
    80003df0:	84aa                	mv	s1,a0
    return -1;
    80003df2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003df4:	00054663          	bltz	a0,80003e00 <sys_dup+0x38>
  filedup(f);
    80003df8:	854a                	mv	a0,s2
    80003dfa:	cb6ff0ef          	jal	ra,800032b0 <filedup>
  return fd;
    80003dfe:	87a6                	mv	a5,s1
}
    80003e00:	853e                	mv	a0,a5
    80003e02:	70a2                	ld	ra,40(sp)
    80003e04:	7402                	ld	s0,32(sp)
    80003e06:	64e2                	ld	s1,24(sp)
    80003e08:	6942                	ld	s2,16(sp)
    80003e0a:	6145                	addi	sp,sp,48
    80003e0c:	8082                	ret

0000000080003e0e <sys_read>:
{
    80003e0e:	7179                	addi	sp,sp,-48
    80003e10:	f406                	sd	ra,40(sp)
    80003e12:	f022                	sd	s0,32(sp)
    80003e14:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e16:	fd840593          	addi	a1,s0,-40
    80003e1a:	4505                	li	a0,1
    80003e1c:	dbdfd0ef          	jal	ra,80001bd8 <argaddr>
  argint(2, &n);
    80003e20:	fe440593          	addi	a1,s0,-28
    80003e24:	4509                	li	a0,2
    80003e26:	d97fd0ef          	jal	ra,80001bbc <argint>
  if(argfd(0, 0, &f) < 0)
    80003e2a:	fe840613          	addi	a2,s0,-24
    80003e2e:	4581                	li	a1,0
    80003e30:	4501                	li	a0,0
    80003e32:	db9ff0ef          	jal	ra,80003bea <argfd>
    80003e36:	87aa                	mv	a5,a0
    return -1;
    80003e38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003e3a:	0007ca63          	bltz	a5,80003e4e <sys_read+0x40>
  return fileread(f, p, n);
    80003e3e:	fe442603          	lw	a2,-28(s0)
    80003e42:	fd843583          	ld	a1,-40(s0)
    80003e46:	fe843503          	ld	a0,-24(s0)
    80003e4a:	db2ff0ef          	jal	ra,800033fc <fileread>
}
    80003e4e:	70a2                	ld	ra,40(sp)
    80003e50:	7402                	ld	s0,32(sp)
    80003e52:	6145                	addi	sp,sp,48
    80003e54:	8082                	ret

0000000080003e56 <sys_write>:
{
    80003e56:	7179                	addi	sp,sp,-48
    80003e58:	f406                	sd	ra,40(sp)
    80003e5a:	f022                	sd	s0,32(sp)
    80003e5c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003e5e:	fd840593          	addi	a1,s0,-40
    80003e62:	4505                	li	a0,1
    80003e64:	d75fd0ef          	jal	ra,80001bd8 <argaddr>
  argint(2, &n);
    80003e68:	fe440593          	addi	a1,s0,-28
    80003e6c:	4509                	li	a0,2
    80003e6e:	d4ffd0ef          	jal	ra,80001bbc <argint>
  if(argfd(0, 0, &f) < 0)
    80003e72:	fe840613          	addi	a2,s0,-24
    80003e76:	4581                	li	a1,0
    80003e78:	4501                	li	a0,0
    80003e7a:	d71ff0ef          	jal	ra,80003bea <argfd>
    80003e7e:	87aa                	mv	a5,a0
    return -1;
    80003e80:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003e82:	0007ca63          	bltz	a5,80003e96 <sys_write+0x40>
  return filewrite(f, p, n);
    80003e86:	fe442603          	lw	a2,-28(s0)
    80003e8a:	fd843583          	ld	a1,-40(s0)
    80003e8e:	fe843503          	ld	a0,-24(s0)
    80003e92:	e18ff0ef          	jal	ra,800034aa <filewrite>
}
    80003e96:	70a2                	ld	ra,40(sp)
    80003e98:	7402                	ld	s0,32(sp)
    80003e9a:	6145                	addi	sp,sp,48
    80003e9c:	8082                	ret

0000000080003e9e <sys_close>:
{
    80003e9e:	1101                	addi	sp,sp,-32
    80003ea0:	ec06                	sd	ra,24(sp)
    80003ea2:	e822                	sd	s0,16(sp)
    80003ea4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003ea6:	fe040613          	addi	a2,s0,-32
    80003eaa:	fec40593          	addi	a1,s0,-20
    80003eae:	4501                	li	a0,0
    80003eb0:	d3bff0ef          	jal	ra,80003bea <argfd>
    return -1;
    80003eb4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003eb6:	02054063          	bltz	a0,80003ed6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003eba:	e53fc0ef          	jal	ra,80000d0c <myproc>
    80003ebe:	fec42783          	lw	a5,-20(s0)
    80003ec2:	07e9                	addi	a5,a5,26
    80003ec4:	078e                	slli	a5,a5,0x3
    80003ec6:	953e                	add	a0,a0,a5
    80003ec8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80003ecc:	fe043503          	ld	a0,-32(s0)
    80003ed0:	c26ff0ef          	jal	ra,800032f6 <fileclose>
  return 0;
    80003ed4:	4781                	li	a5,0
}
    80003ed6:	853e                	mv	a0,a5
    80003ed8:	60e2                	ld	ra,24(sp)
    80003eda:	6442                	ld	s0,16(sp)
    80003edc:	6105                	addi	sp,sp,32
    80003ede:	8082                	ret

0000000080003ee0 <sys_fstat>:
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003ee8:	fe040593          	addi	a1,s0,-32
    80003eec:	4505                	li	a0,1
    80003eee:	cebfd0ef          	jal	ra,80001bd8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003ef2:	fe840613          	addi	a2,s0,-24
    80003ef6:	4581                	li	a1,0
    80003ef8:	4501                	li	a0,0
    80003efa:	cf1ff0ef          	jal	ra,80003bea <argfd>
    80003efe:	87aa                	mv	a5,a0
    return -1;
    80003f00:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003f02:	0007c863          	bltz	a5,80003f12 <sys_fstat+0x32>
  return filestat(f, st);
    80003f06:	fe043583          	ld	a1,-32(s0)
    80003f0a:	fe843503          	ld	a0,-24(s0)
    80003f0e:	c90ff0ef          	jal	ra,8000339e <filestat>
}
    80003f12:	60e2                	ld	ra,24(sp)
    80003f14:	6442                	ld	s0,16(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret

0000000080003f1a <sys_link>:
{
    80003f1a:	7169                	addi	sp,sp,-304
    80003f1c:	f606                	sd	ra,296(sp)
    80003f1e:	f222                	sd	s0,288(sp)
    80003f20:	ee26                	sd	s1,280(sp)
    80003f22:	ea4a                	sd	s2,272(sp)
    80003f24:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f26:	08000613          	li	a2,128
    80003f2a:	ed040593          	addi	a1,s0,-304
    80003f2e:	4501                	li	a0,0
    80003f30:	cc5fd0ef          	jal	ra,80001bf4 <argstr>
    return -1;
    80003f34:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f36:	0c054663          	bltz	a0,80004002 <sys_link+0xe8>
    80003f3a:	08000613          	li	a2,128
    80003f3e:	f5040593          	addi	a1,s0,-176
    80003f42:	4505                	li	a0,1
    80003f44:	cb1fd0ef          	jal	ra,80001bf4 <argstr>
    return -1;
    80003f48:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003f4a:	0a054c63          	bltz	a0,80004002 <sys_link+0xe8>
  begin_op();
    80003f4e:	f91fe0ef          	jal	ra,80002ede <begin_op>
  if((ip = namei(old)) == 0){
    80003f52:	ed040513          	addi	a0,s0,-304
    80003f56:	dadfe0ef          	jal	ra,80002d02 <namei>
    80003f5a:	84aa                	mv	s1,a0
    80003f5c:	c525                	beqz	a0,80003fc4 <sys_link+0xaa>
  ilock(ip);
    80003f5e:	eeafe0ef          	jal	ra,80002648 <ilock>
  if(ip->type == T_DIR){
    80003f62:	04449703          	lh	a4,68(s1)
    80003f66:	4785                	li	a5,1
    80003f68:	06f70263          	beq	a4,a5,80003fcc <sys_link+0xb2>
  ip->nlink++;
    80003f6c:	04a4d783          	lhu	a5,74(s1)
    80003f70:	2785                	addiw	a5,a5,1
    80003f72:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003f76:	8526                	mv	a0,s1
    80003f78:	e1cfe0ef          	jal	ra,80002594 <iupdate>
  iunlock(ip);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	f74fe0ef          	jal	ra,800026f2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003f82:	fd040593          	addi	a1,s0,-48
    80003f86:	f5040513          	addi	a0,s0,-176
    80003f8a:	d93fe0ef          	jal	ra,80002d1c <nameiparent>
    80003f8e:	892a                	mv	s2,a0
    80003f90:	c921                	beqz	a0,80003fe0 <sys_link+0xc6>
  ilock(dp);
    80003f92:	eb6fe0ef          	jal	ra,80002648 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80003f96:	00092703          	lw	a4,0(s2)
    80003f9a:	409c                	lw	a5,0(s1)
    80003f9c:	02f71f63          	bne	a4,a5,80003fda <sys_link+0xc0>
    80003fa0:	40d0                	lw	a2,4(s1)
    80003fa2:	fd040593          	addi	a1,s0,-48
    80003fa6:	854a                	mv	a0,s2
    80003fa8:	cc1fe0ef          	jal	ra,80002c68 <dirlink>
    80003fac:	02054763          	bltz	a0,80003fda <sys_link+0xc0>
  iunlockput(dp);
    80003fb0:	854a                	mv	a0,s2
    80003fb2:	89dfe0ef          	jal	ra,8000284e <iunlockput>
  iput(ip);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	80ffe0ef          	jal	ra,800027c6 <iput>
  end_op();
    80003fbc:	f91fe0ef          	jal	ra,80002f4c <end_op>
  return 0;
    80003fc0:	4781                	li	a5,0
    80003fc2:	a081                	j	80004002 <sys_link+0xe8>
    end_op();
    80003fc4:	f89fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    80003fc8:	57fd                	li	a5,-1
    80003fca:	a825                	j	80004002 <sys_link+0xe8>
    iunlockput(ip);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	881fe0ef          	jal	ra,8000284e <iunlockput>
    end_op();
    80003fd2:	f7bfe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    80003fd6:	57fd                	li	a5,-1
    80003fd8:	a02d                	j	80004002 <sys_link+0xe8>
    iunlockput(dp);
    80003fda:	854a                	mv	a0,s2
    80003fdc:	873fe0ef          	jal	ra,8000284e <iunlockput>
  ilock(ip);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	e66fe0ef          	jal	ra,80002648 <ilock>
  ip->nlink--;
    80003fe6:	04a4d783          	lhu	a5,74(s1)
    80003fea:	37fd                	addiw	a5,a5,-1
    80003fec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	da2fe0ef          	jal	ra,80002594 <iupdate>
  iunlockput(ip);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	857fe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    80003ffc:	f51fe0ef          	jal	ra,80002f4c <end_op>
  return -1;
    80004000:	57fd                	li	a5,-1
}
    80004002:	853e                	mv	a0,a5
    80004004:	70b2                	ld	ra,296(sp)
    80004006:	7412                	ld	s0,288(sp)
    80004008:	64f2                	ld	s1,280(sp)
    8000400a:	6952                	ld	s2,272(sp)
    8000400c:	6155                	addi	sp,sp,304
    8000400e:	8082                	ret

0000000080004010 <sys_unlink>:
{
    80004010:	7151                	addi	sp,sp,-240
    80004012:	f586                	sd	ra,232(sp)
    80004014:	f1a2                	sd	s0,224(sp)
    80004016:	eda6                	sd	s1,216(sp)
    80004018:	e9ca                	sd	s2,208(sp)
    8000401a:	e5ce                	sd	s3,200(sp)
    8000401c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000401e:	08000613          	li	a2,128
    80004022:	f3040593          	addi	a1,s0,-208
    80004026:	4501                	li	a0,0
    80004028:	bcdfd0ef          	jal	ra,80001bf4 <argstr>
    8000402c:	12054b63          	bltz	a0,80004162 <sys_unlink+0x152>
  begin_op();
    80004030:	eaffe0ef          	jal	ra,80002ede <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004034:	fb040593          	addi	a1,s0,-80
    80004038:	f3040513          	addi	a0,s0,-208
    8000403c:	ce1fe0ef          	jal	ra,80002d1c <nameiparent>
    80004040:	84aa                	mv	s1,a0
    80004042:	c54d                	beqz	a0,800040ec <sys_unlink+0xdc>
  ilock(dp);
    80004044:	e04fe0ef          	jal	ra,80002648 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004048:	00003597          	auipc	a1,0x3
    8000404c:	66058593          	addi	a1,a1,1632 # 800076a8 <syscalls+0x290>
    80004050:	fb040513          	addi	a0,s0,-80
    80004054:	a2dfe0ef          	jal	ra,80002a80 <namecmp>
    80004058:	10050a63          	beqz	a0,8000416c <sys_unlink+0x15c>
    8000405c:	00003597          	auipc	a1,0x3
    80004060:	65458593          	addi	a1,a1,1620 # 800076b0 <syscalls+0x298>
    80004064:	fb040513          	addi	a0,s0,-80
    80004068:	a19fe0ef          	jal	ra,80002a80 <namecmp>
    8000406c:	10050063          	beqz	a0,8000416c <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004070:	f2c40613          	addi	a2,s0,-212
    80004074:	fb040593          	addi	a1,s0,-80
    80004078:	8526                	mv	a0,s1
    8000407a:	a1dfe0ef          	jal	ra,80002a96 <dirlookup>
    8000407e:	892a                	mv	s2,a0
    80004080:	0e050663          	beqz	a0,8000416c <sys_unlink+0x15c>
  ilock(ip);
    80004084:	dc4fe0ef          	jal	ra,80002648 <ilock>
  if(ip->nlink < 1)
    80004088:	04a91783          	lh	a5,74(s2)
    8000408c:	06f05463          	blez	a5,800040f4 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004090:	04491703          	lh	a4,68(s2)
    80004094:	4785                	li	a5,1
    80004096:	06f70563          	beq	a4,a5,80004100 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    8000409a:	4641                	li	a2,16
    8000409c:	4581                	li	a1,0
    8000409e:	fc040513          	addi	a0,s0,-64
    800040a2:	8acfc0ef          	jal	ra,8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040a6:	4741                	li	a4,16
    800040a8:	f2c42683          	lw	a3,-212(s0)
    800040ac:	fc040613          	addi	a2,s0,-64
    800040b0:	4581                	li	a1,0
    800040b2:	8526                	mv	a0,s1
    800040b4:	8c9fe0ef          	jal	ra,8000297c <writei>
    800040b8:	47c1                	li	a5,16
    800040ba:	08f51563          	bne	a0,a5,80004144 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    800040be:	04491703          	lh	a4,68(s2)
    800040c2:	4785                	li	a5,1
    800040c4:	08f70663          	beq	a4,a5,80004150 <sys_unlink+0x140>
  iunlockput(dp);
    800040c8:	8526                	mv	a0,s1
    800040ca:	f84fe0ef          	jal	ra,8000284e <iunlockput>
  ip->nlink--;
    800040ce:	04a95783          	lhu	a5,74(s2)
    800040d2:	37fd                	addiw	a5,a5,-1
    800040d4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800040d8:	854a                	mv	a0,s2
    800040da:	cbafe0ef          	jal	ra,80002594 <iupdate>
  iunlockput(ip);
    800040de:	854a                	mv	a0,s2
    800040e0:	f6efe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    800040e4:	e69fe0ef          	jal	ra,80002f4c <end_op>
  return 0;
    800040e8:	4501                	li	a0,0
    800040ea:	a079                	j	80004178 <sys_unlink+0x168>
    end_op();
    800040ec:	e61fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    800040f0:	557d                	li	a0,-1
    800040f2:	a059                	j	80004178 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800040f4:	00003517          	auipc	a0,0x3
    800040f8:	5c450513          	addi	a0,a0,1476 # 800076b8 <syscalls+0x2a0>
    800040fc:	306010ef          	jal	ra,80005402 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004100:	04c92703          	lw	a4,76(s2)
    80004104:	02000793          	li	a5,32
    80004108:	f8e7f9e3          	bgeu	a5,a4,8000409a <sys_unlink+0x8a>
    8000410c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004110:	4741                	li	a4,16
    80004112:	86ce                	mv	a3,s3
    80004114:	f1840613          	addi	a2,s0,-232
    80004118:	4581                	li	a1,0
    8000411a:	854a                	mv	a0,s2
    8000411c:	f7cfe0ef          	jal	ra,80002898 <readi>
    80004120:	47c1                	li	a5,16
    80004122:	00f51b63          	bne	a0,a5,80004138 <sys_unlink+0x128>
    if(de.inum != 0)
    80004126:	f1845783          	lhu	a5,-232(s0)
    8000412a:	ef95                	bnez	a5,80004166 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000412c:	29c1                	addiw	s3,s3,16
    8000412e:	04c92783          	lw	a5,76(s2)
    80004132:	fcf9efe3          	bltu	s3,a5,80004110 <sys_unlink+0x100>
    80004136:	b795                	j	8000409a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004138:	00003517          	auipc	a0,0x3
    8000413c:	59850513          	addi	a0,a0,1432 # 800076d0 <syscalls+0x2b8>
    80004140:	2c2010ef          	jal	ra,80005402 <panic>
    panic("unlink: writei");
    80004144:	00003517          	auipc	a0,0x3
    80004148:	5a450513          	addi	a0,a0,1444 # 800076e8 <syscalls+0x2d0>
    8000414c:	2b6010ef          	jal	ra,80005402 <panic>
    dp->nlink--;
    80004150:	04a4d783          	lhu	a5,74(s1)
    80004154:	37fd                	addiw	a5,a5,-1
    80004156:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000415a:	8526                	mv	a0,s1
    8000415c:	c38fe0ef          	jal	ra,80002594 <iupdate>
    80004160:	b7a5                	j	800040c8 <sys_unlink+0xb8>
    return -1;
    80004162:	557d                	li	a0,-1
    80004164:	a811                	j	80004178 <sys_unlink+0x168>
    iunlockput(ip);
    80004166:	854a                	mv	a0,s2
    80004168:	ee6fe0ef          	jal	ra,8000284e <iunlockput>
  iunlockput(dp);
    8000416c:	8526                	mv	a0,s1
    8000416e:	ee0fe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    80004172:	ddbfe0ef          	jal	ra,80002f4c <end_op>
  return -1;
    80004176:	557d                	li	a0,-1
}
    80004178:	70ae                	ld	ra,232(sp)
    8000417a:	740e                	ld	s0,224(sp)
    8000417c:	64ee                	ld	s1,216(sp)
    8000417e:	694e                	ld	s2,208(sp)
    80004180:	69ae                	ld	s3,200(sp)
    80004182:	616d                	addi	sp,sp,240
    80004184:	8082                	ret

0000000080004186 <sys_open>:

uint64
sys_open(void)
{
    80004186:	7129                	addi	sp,sp,-320
    80004188:	fe06                	sd	ra,312(sp)
    8000418a:	fa22                	sd	s0,304(sp)
    8000418c:	f626                	sd	s1,296(sp)
    8000418e:	f24a                	sd	s2,288(sp)
    80004190:	ee4e                	sd	s3,280(sp)
    80004192:	ea52                	sd	s4,272(sp)
    80004194:	0280                	addi	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n, dereference = 1, depth = 0;

  argint(1, &omode);
    80004196:	f4c40593          	addi	a1,s0,-180
    8000419a:	4505                	li	a0,1
    8000419c:	a21fd0ef          	jal	ra,80001bbc <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800041a0:	08000613          	li	a2,128
    800041a4:	f5040593          	addi	a1,s0,-176
    800041a8:	4501                	li	a0,0
    800041aa:	a4bfd0ef          	jal	ra,80001bf4 <argstr>
    return -1;
    800041ae:	597d                	li	s2,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800041b0:	00055b63          	bgez	a0,800041c6 <sys_open+0x40>

  iunlock(ip);
  end_op();

  return fd;
}
    800041b4:	854a                	mv	a0,s2
    800041b6:	70f2                	ld	ra,312(sp)
    800041b8:	7452                	ld	s0,304(sp)
    800041ba:	74b2                	ld	s1,296(sp)
    800041bc:	7912                	ld	s2,288(sp)
    800041be:	69f2                	ld	s3,280(sp)
    800041c0:	6a52                	ld	s4,272(sp)
    800041c2:	6131                	addi	sp,sp,320
    800041c4:	8082                	ret
  if (omode & O_NOFOLLOW)
    800041c6:	f4c42a03          	lw	s4,-180(s0)
    800041ca:	6785                	lui	a5,0x1
    800041cc:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800041d0:	00fa7a33          	and	s4,s4,a5
  begin_op();
    800041d4:	d0bfe0ef          	jal	ra,80002ede <begin_op>
    800041d8:	49ad                	li	s3,11
      if (ip->type == T_SYMLINK && dereference) {
    800041da:	4911                	li	s2,4
    ip = namei(path);
    800041dc:	f5040513          	addi	a0,s0,-176
    800041e0:	b23fe0ef          	jal	ra,80002d02 <namei>
    800041e4:	84aa                	mv	s1,a0
    if (ip == 0) {
    800041e6:	cd31                	beqz	a0,80004242 <sys_open+0xbc>
      ilock(ip);
    800041e8:	c60fe0ef          	jal	ra,80002648 <ilock>
      if (ip->type == T_SYMLINK && dereference) {
    800041ec:	04449783          	lh	a5,68(s1)
    800041f0:	0007871b          	sext.w	a4,a5
    800041f4:	11271a63          	bne	a4,s2,80004308 <sys_open+0x182>
    800041f8:	060a1d63          	bnez	s4,80004272 <sys_open+0xec>
        if (++depth > MAX_SYMLINK_DEPTH) { 
    800041fc:	39fd                	addiw	s3,s3,-1
    800041fe:	0e098363          	beqz	s3,800042e4 <sys_open+0x15e>
        if (readi(ip, 0, (uint64)&len, 0, sizeof(int)) != sizeof(int) ||
    80004202:	874a                	mv	a4,s2
    80004204:	4681                	li	a3,0
    80004206:	ec440613          	addi	a2,s0,-316
    8000420a:	4581                	li	a1,0
    8000420c:	8526                	mv	a0,s1
    8000420e:	e8afe0ef          	jal	ra,80002898 <readi>
    80004212:	03251163          	bne	a0,s2,80004234 <sys_open+0xae>
            readi(ip, 0, (uint64)symlink_path, sizeof(int), len + 1) != len + 1) {
    80004216:	ec442703          	lw	a4,-316(s0)
    8000421a:	2705                	addiw	a4,a4,1
    8000421c:	86ca                	mv	a3,s2
    8000421e:	ec840613          	addi	a2,s0,-312
    80004222:	4581                	li	a1,0
    80004224:	8526                	mv	a0,s1
    80004226:	e72fe0ef          	jal	ra,80002898 <readi>
    8000422a:	ec442783          	lw	a5,-316(s0)
        if (readi(ip, 0, (uint64)&len, 0, sizeof(int)) != sizeof(int) ||
    8000422e:	2785                	addiw	a5,a5,1
    80004230:	0ca78063          	beq	a5,a0,800042f0 <sys_open+0x16a>
          iunlockput(ip);
    80004234:	8526                	mv	a0,s1
    80004236:	e18fe0ef          	jal	ra,8000284e <iunlockput>
          end_op();
    8000423a:	d13fe0ef          	jal	ra,80002f4c <end_op>
          return -1;
    8000423e:	597d                	li	s2,-1
    80004240:	bf95                	j	800041b4 <sys_open+0x2e>
      if (omode & O_CREATE) {
    80004242:	f4c42783          	lw	a5,-180(s0)
    80004246:	2007f793          	andi	a5,a5,512
    8000424a:	cbc9                	beqz	a5,800042dc <sys_open+0x156>
        ip = create(path, T_FILE, 0, 0);
    8000424c:	4681                	li	a3,0
    8000424e:	4601                	li	a2,0
    80004250:	4589                	li	a1,2
    80004252:	f5040513          	addi	a0,s0,-176
    80004256:	a2bff0ef          	jal	ra,80003c80 <create>
    8000425a:	84aa                	mv	s1,a0
        if (ip == 0) {
    8000425c:	cd25                	beqz	a0,800042d4 <sys_open+0x14e>
  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    8000425e:	04449703          	lh	a4,68(s1)
    80004262:	478d                	li	a5,3
    80004264:	00f71763          	bne	a4,a5,80004272 <sys_open+0xec>
    80004268:	0464d703          	lhu	a4,70(s1)
    8000426c:	47a5                	li	a5,9
    8000426e:	0ae7eb63          	bltu	a5,a4,80004324 <sys_open+0x19e>
  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004272:	fe1fe0ef          	jal	ra,80003252 <filealloc>
    80004276:	89aa                	mv	s3,a0
    80004278:	0c050b63          	beqz	a0,8000434e <sys_open+0x1c8>
    8000427c:	9c7ff0ef          	jal	ra,80003c42 <fdalloc>
    80004280:	892a                	mv	s2,a0
    80004282:	0c054363          	bltz	a0,80004348 <sys_open+0x1c2>
  if (ip->type == T_DEVICE) {
    80004286:	04449703          	lh	a4,68(s1)
    8000428a:	478d                	li	a5,3
    8000428c:	0af70363          	beq	a4,a5,80004332 <sys_open+0x1ac>
    f->type = FD_INODE;
    80004290:	4789                	li	a5,2
    80004292:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004296:	0209a023          	sw	zero,32(s3)
  f->ip = ip;
    8000429a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000429e:	f4c42783          	lw	a5,-180(s0)
    800042a2:	0017c713          	xori	a4,a5,1
    800042a6:	8b05                	andi	a4,a4,1
    800042a8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800042ac:	0037f713          	andi	a4,a5,3
    800042b0:	00e03733          	snez	a4,a4
    800042b4:	00e984a3          	sb	a4,9(s3)
  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800042b8:	4007f793          	andi	a5,a5,1024
    800042bc:	c791                	beqz	a5,800042c8 <sys_open+0x142>
    800042be:	04449703          	lh	a4,68(s1)
    800042c2:	4789                	li	a5,2
    800042c4:	06f70e63          	beq	a4,a5,80004340 <sys_open+0x1ba>
  iunlock(ip);
    800042c8:	8526                	mv	a0,s1
    800042ca:	c28fe0ef          	jal	ra,800026f2 <iunlock>
  end_op();
    800042ce:	c7ffe0ef          	jal	ra,80002f4c <end_op>
  return fd;
    800042d2:	b5cd                	j	800041b4 <sys_open+0x2e>
          end_op();
    800042d4:	c79fe0ef          	jal	ra,80002f4c <end_op>
          return -1;
    800042d8:	597d                	li	s2,-1
    800042da:	bde9                	j	800041b4 <sys_open+0x2e>
        end_op();
    800042dc:	c71fe0ef          	jal	ra,80002f4c <end_op>
        return -1;
    800042e0:	597d                	li	s2,-1
    800042e2:	bdc9                	j	800041b4 <sys_open+0x2e>
          iunlockput(ip);
    800042e4:	8526                	mv	a0,s1
    800042e6:	d68fe0ef          	jal	ra,8000284e <iunlockput>
          end_op();
    800042ea:	c63fe0ef          	jal	ra,80002f4c <end_op>
          return -1;
    800042ee:	bf81                	j	8000423e <sys_open+0xb8>
        memmove(path, symlink_path, MAXPATH); 
    800042f0:	08000613          	li	a2,128
    800042f4:	ec840593          	addi	a1,s0,-312
    800042f8:	f5040513          	addi	a0,s0,-176
    800042fc:	eaffb0ef          	jal	ra,800001aa <memmove>
        iunlockput(ip); 
    80004300:	8526                	mv	a0,s1
    80004302:	d4cfe0ef          	jal	ra,8000284e <iunlockput>
        continue;
    80004306:	bdd9                	j	800041dc <sys_open+0x56>
      if (ip->type == T_DIR && omode != O_RDONLY) {
    80004308:	2781                	sext.w	a5,a5
    8000430a:	4705                	li	a4,1
    8000430c:	f4e799e3          	bne	a5,a4,8000425e <sys_open+0xd8>
    80004310:	f4c42783          	lw	a5,-180(s0)
    80004314:	dfb9                	beqz	a5,80004272 <sys_open+0xec>
        iunlockput(ip);
    80004316:	8526                	mv	a0,s1
    80004318:	d36fe0ef          	jal	ra,8000284e <iunlockput>
        end_op();
    8000431c:	c31fe0ef          	jal	ra,80002f4c <end_op>
        return -1;
    80004320:	597d                	li	s2,-1
    80004322:	bd49                	j	800041b4 <sys_open+0x2e>
    iunlockput(ip);
    80004324:	8526                	mv	a0,s1
    80004326:	d28fe0ef          	jal	ra,8000284e <iunlockput>
    end_op();
    8000432a:	c23fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    8000432e:	597d                	li	s2,-1
    80004330:	b551                	j	800041b4 <sys_open+0x2e>
    f->type = FD_DEVICE;
    80004332:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004336:	04649783          	lh	a5,70(s1)
    8000433a:	02f99223          	sh	a5,36(s3)
    8000433e:	bfb1                	j	8000429a <sys_open+0x114>
    itrunc(ip);
    80004340:	8526                	mv	a0,s1
    80004342:	bf0fe0ef          	jal	ra,80002732 <itrunc>
    80004346:	b749                	j	800042c8 <sys_open+0x142>
      fileclose(f);
    80004348:	854e                	mv	a0,s3
    8000434a:	fadfe0ef          	jal	ra,800032f6 <fileclose>
    iunlockput(ip);
    8000434e:	8526                	mv	a0,s1
    80004350:	cfefe0ef          	jal	ra,8000284e <iunlockput>
    end_op();
    80004354:	bf9fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    80004358:	597d                	li	s2,-1
    8000435a:	bda9                	j	800041b4 <sys_open+0x2e>

000000008000435c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000435c:	7175                	addi	sp,sp,-144
    8000435e:	e506                	sd	ra,136(sp)
    80004360:	e122                	sd	s0,128(sp)
    80004362:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004364:	b7bfe0ef          	jal	ra,80002ede <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004368:	08000613          	li	a2,128
    8000436c:	f7040593          	addi	a1,s0,-144
    80004370:	4501                	li	a0,0
    80004372:	883fd0ef          	jal	ra,80001bf4 <argstr>
    80004376:	02054363          	bltz	a0,8000439c <sys_mkdir+0x40>
    8000437a:	4681                	li	a3,0
    8000437c:	4601                	li	a2,0
    8000437e:	4585                	li	a1,1
    80004380:	f7040513          	addi	a0,s0,-144
    80004384:	8fdff0ef          	jal	ra,80003c80 <create>
    80004388:	c911                	beqz	a0,8000439c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000438a:	cc4fe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    8000438e:	bbffe0ef          	jal	ra,80002f4c <end_op>
  return 0;
    80004392:	4501                	li	a0,0
}
    80004394:	60aa                	ld	ra,136(sp)
    80004396:	640a                	ld	s0,128(sp)
    80004398:	6149                	addi	sp,sp,144
    8000439a:	8082                	ret
    end_op();
    8000439c:	bb1fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    800043a0:	557d                	li	a0,-1
    800043a2:	bfcd                	j	80004394 <sys_mkdir+0x38>

00000000800043a4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800043a4:	7135                	addi	sp,sp,-160
    800043a6:	ed06                	sd	ra,152(sp)
    800043a8:	e922                	sd	s0,144(sp)
    800043aa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800043ac:	b33fe0ef          	jal	ra,80002ede <begin_op>
  argint(1, &major);
    800043b0:	f6c40593          	addi	a1,s0,-148
    800043b4:	4505                	li	a0,1
    800043b6:	807fd0ef          	jal	ra,80001bbc <argint>
  argint(2, &minor);
    800043ba:	f6840593          	addi	a1,s0,-152
    800043be:	4509                	li	a0,2
    800043c0:	ffcfd0ef          	jal	ra,80001bbc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043c4:	08000613          	li	a2,128
    800043c8:	f7040593          	addi	a1,s0,-144
    800043cc:	4501                	li	a0,0
    800043ce:	827fd0ef          	jal	ra,80001bf4 <argstr>
    800043d2:	02054563          	bltz	a0,800043fc <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800043d6:	f6841683          	lh	a3,-152(s0)
    800043da:	f6c41603          	lh	a2,-148(s0)
    800043de:	458d                	li	a1,3
    800043e0:	f7040513          	addi	a0,s0,-144
    800043e4:	89dff0ef          	jal	ra,80003c80 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800043e8:	c911                	beqz	a0,800043fc <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800043ea:	c64fe0ef          	jal	ra,8000284e <iunlockput>
  end_op();
    800043ee:	b5ffe0ef          	jal	ra,80002f4c <end_op>
  return 0;
    800043f2:	4501                	li	a0,0
}
    800043f4:	60ea                	ld	ra,152(sp)
    800043f6:	644a                	ld	s0,144(sp)
    800043f8:	610d                	addi	sp,sp,160
    800043fa:	8082                	ret
    end_op();
    800043fc:	b51fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    80004400:	557d                	li	a0,-1
    80004402:	bfcd                	j	800043f4 <sys_mknod+0x50>

0000000080004404 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004404:	7135                	addi	sp,sp,-160
    80004406:	ed06                	sd	ra,152(sp)
    80004408:	e922                	sd	s0,144(sp)
    8000440a:	e526                	sd	s1,136(sp)
    8000440c:	e14a                	sd	s2,128(sp)
    8000440e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004410:	8fdfc0ef          	jal	ra,80000d0c <myproc>
    80004414:	892a                	mv	s2,a0
  
  begin_op();
    80004416:	ac9fe0ef          	jal	ra,80002ede <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000441a:	08000613          	li	a2,128
    8000441e:	f6040593          	addi	a1,s0,-160
    80004422:	4501                	li	a0,0
    80004424:	fd0fd0ef          	jal	ra,80001bf4 <argstr>
    80004428:	04054163          	bltz	a0,8000446a <sys_chdir+0x66>
    8000442c:	f6040513          	addi	a0,s0,-160
    80004430:	8d3fe0ef          	jal	ra,80002d02 <namei>
    80004434:	84aa                	mv	s1,a0
    80004436:	c915                	beqz	a0,8000446a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004438:	a10fe0ef          	jal	ra,80002648 <ilock>
  if(ip->type != T_DIR){
    8000443c:	04449703          	lh	a4,68(s1)
    80004440:	4785                	li	a5,1
    80004442:	02f71863          	bne	a4,a5,80004472 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004446:	8526                	mv	a0,s1
    80004448:	aaafe0ef          	jal	ra,800026f2 <iunlock>
  iput(p->cwd);
    8000444c:	15093503          	ld	a0,336(s2)
    80004450:	b76fe0ef          	jal	ra,800027c6 <iput>
  end_op();
    80004454:	af9fe0ef          	jal	ra,80002f4c <end_op>
  p->cwd = ip;
    80004458:	14993823          	sd	s1,336(s2)
  return 0;
    8000445c:	4501                	li	a0,0
}
    8000445e:	60ea                	ld	ra,152(sp)
    80004460:	644a                	ld	s0,144(sp)
    80004462:	64aa                	ld	s1,136(sp)
    80004464:	690a                	ld	s2,128(sp)
    80004466:	610d                	addi	sp,sp,160
    80004468:	8082                	ret
    end_op();
    8000446a:	ae3fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    8000446e:	557d                	li	a0,-1
    80004470:	b7fd                	j	8000445e <sys_chdir+0x5a>
    iunlockput(ip);
    80004472:	8526                	mv	a0,s1
    80004474:	bdafe0ef          	jal	ra,8000284e <iunlockput>
    end_op();
    80004478:	ad5fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    8000447c:	557d                	li	a0,-1
    8000447e:	b7c5                	j	8000445e <sys_chdir+0x5a>

0000000080004480 <sys_exec>:

uint64
sys_exec(void)
{
    80004480:	7145                	addi	sp,sp,-464
    80004482:	e786                	sd	ra,456(sp)
    80004484:	e3a2                	sd	s0,448(sp)
    80004486:	ff26                	sd	s1,440(sp)
    80004488:	fb4a                	sd	s2,432(sp)
    8000448a:	f74e                	sd	s3,424(sp)
    8000448c:	f352                	sd	s4,416(sp)
    8000448e:	ef56                	sd	s5,408(sp)
    80004490:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004492:	e3840593          	addi	a1,s0,-456
    80004496:	4505                	li	a0,1
    80004498:	f40fd0ef          	jal	ra,80001bd8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000449c:	08000613          	li	a2,128
    800044a0:	f4040593          	addi	a1,s0,-192
    800044a4:	4501                	li	a0,0
    800044a6:	f4efd0ef          	jal	ra,80001bf4 <argstr>
    800044aa:	87aa                	mv	a5,a0
    return -1;
    800044ac:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800044ae:	0a07c563          	bltz	a5,80004558 <sys_exec+0xd8>
  }
  memset(argv, 0, sizeof(argv));
    800044b2:	10000613          	li	a2,256
    800044b6:	4581                	li	a1,0
    800044b8:	e4040513          	addi	a0,s0,-448
    800044bc:	c93fb0ef          	jal	ra,8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800044c0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800044c4:	89a6                	mv	s3,s1
    800044c6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800044c8:	02000a13          	li	s4,32
    800044cc:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800044d0:	00391513          	slli	a0,s2,0x3
    800044d4:	e3040593          	addi	a1,s0,-464
    800044d8:	e3843783          	ld	a5,-456(s0)
    800044dc:	953e                	add	a0,a0,a5
    800044de:	e54fd0ef          	jal	ra,80001b32 <fetchaddr>
    800044e2:	02054663          	bltz	a0,8000450e <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    800044e6:	e3043783          	ld	a5,-464(s0)
    800044ea:	cf8d                	beqz	a5,80004524 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800044ec:	c13fb0ef          	jal	ra,800000fe <kalloc>
    800044f0:	85aa                	mv	a1,a0
    800044f2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800044f6:	cd01                	beqz	a0,8000450e <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800044f8:	6605                	lui	a2,0x1
    800044fa:	e3043503          	ld	a0,-464(s0)
    800044fe:	e7efd0ef          	jal	ra,80001b7c <fetchstr>
    80004502:	00054663          	bltz	a0,8000450e <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004506:	0905                	addi	s2,s2,1
    80004508:	09a1                	addi	s3,s3,8
    8000450a:	fd4911e3          	bne	s2,s4,800044cc <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000450e:	f4040913          	addi	s2,s0,-192
    80004512:	6088                	ld	a0,0(s1)
    80004514:	c129                	beqz	a0,80004556 <sys_exec+0xd6>
    kfree(argv[i]);
    80004516:	b07fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000451a:	04a1                	addi	s1,s1,8
    8000451c:	ff249be3          	bne	s1,s2,80004512 <sys_exec+0x92>
  return -1;
    80004520:	557d                	li	a0,-1
    80004522:	a81d                	j	80004558 <sys_exec+0xd8>
      argv[i] = 0;
    80004524:	0a8e                	slli	s5,s5,0x3
    80004526:	fc0a8793          	addi	a5,s5,-64
    8000452a:	00878ab3          	add	s5,a5,s0
    8000452e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004532:	e4040593          	addi	a1,s0,-448
    80004536:	f4040513          	addi	a0,s0,-192
    8000453a:	b5eff0ef          	jal	ra,80003898 <exec>
    8000453e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004540:	f4040993          	addi	s3,s0,-192
    80004544:	6088                	ld	a0,0(s1)
    80004546:	c511                	beqz	a0,80004552 <sys_exec+0xd2>
    kfree(argv[i]);
    80004548:	ad5fb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000454c:	04a1                	addi	s1,s1,8
    8000454e:	ff349be3          	bne	s1,s3,80004544 <sys_exec+0xc4>
  return ret;
    80004552:	854a                	mv	a0,s2
    80004554:	a011                	j	80004558 <sys_exec+0xd8>
  return -1;
    80004556:	557d                	li	a0,-1
}
    80004558:	60be                	ld	ra,456(sp)
    8000455a:	641e                	ld	s0,448(sp)
    8000455c:	74fa                	ld	s1,440(sp)
    8000455e:	795a                	ld	s2,432(sp)
    80004560:	79ba                	ld	s3,424(sp)
    80004562:	7a1a                	ld	s4,416(sp)
    80004564:	6afa                	ld	s5,408(sp)
    80004566:	6179                	addi	sp,sp,464
    80004568:	8082                	ret

000000008000456a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000456a:	7139                	addi	sp,sp,-64
    8000456c:	fc06                	sd	ra,56(sp)
    8000456e:	f822                	sd	s0,48(sp)
    80004570:	f426                	sd	s1,40(sp)
    80004572:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004574:	f98fc0ef          	jal	ra,80000d0c <myproc>
    80004578:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000457a:	fd840593          	addi	a1,s0,-40
    8000457e:	4501                	li	a0,0
    80004580:	e58fd0ef          	jal	ra,80001bd8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004584:	fc840593          	addi	a1,s0,-56
    80004588:	fd040513          	addi	a0,s0,-48
    8000458c:	836ff0ef          	jal	ra,800035c2 <pipealloc>
    return -1;
    80004590:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004592:	0a054463          	bltz	a0,8000463a <sys_pipe+0xd0>
  fd0 = -1;
    80004596:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000459a:	fd043503          	ld	a0,-48(s0)
    8000459e:	ea4ff0ef          	jal	ra,80003c42 <fdalloc>
    800045a2:	fca42223          	sw	a0,-60(s0)
    800045a6:	08054163          	bltz	a0,80004628 <sys_pipe+0xbe>
    800045aa:	fc843503          	ld	a0,-56(s0)
    800045ae:	e94ff0ef          	jal	ra,80003c42 <fdalloc>
    800045b2:	fca42023          	sw	a0,-64(s0)
    800045b6:	06054063          	bltz	a0,80004616 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045ba:	4691                	li	a3,4
    800045bc:	fc440613          	addi	a2,s0,-60
    800045c0:	fd843583          	ld	a1,-40(s0)
    800045c4:	68a8                	ld	a0,80(s1)
    800045c6:	bfefc0ef          	jal	ra,800009c4 <copyout>
    800045ca:	00054e63          	bltz	a0,800045e6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800045ce:	4691                	li	a3,4
    800045d0:	fc040613          	addi	a2,s0,-64
    800045d4:	fd843583          	ld	a1,-40(s0)
    800045d8:	0591                	addi	a1,a1,4
    800045da:	68a8                	ld	a0,80(s1)
    800045dc:	be8fc0ef          	jal	ra,800009c4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800045e0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800045e2:	04055c63          	bgez	a0,8000463a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800045e6:	fc442783          	lw	a5,-60(s0)
    800045ea:	07e9                	addi	a5,a5,26
    800045ec:	078e                	slli	a5,a5,0x3
    800045ee:	97a6                	add	a5,a5,s1
    800045f0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800045f4:	fc042783          	lw	a5,-64(s0)
    800045f8:	07e9                	addi	a5,a5,26
    800045fa:	078e                	slli	a5,a5,0x3
    800045fc:	94be                	add	s1,s1,a5
    800045fe:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004602:	fd043503          	ld	a0,-48(s0)
    80004606:	cf1fe0ef          	jal	ra,800032f6 <fileclose>
    fileclose(wf);
    8000460a:	fc843503          	ld	a0,-56(s0)
    8000460e:	ce9fe0ef          	jal	ra,800032f6 <fileclose>
    return -1;
    80004612:	57fd                	li	a5,-1
    80004614:	a01d                	j	8000463a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004616:	fc442783          	lw	a5,-60(s0)
    8000461a:	0007c763          	bltz	a5,80004628 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000461e:	07e9                	addi	a5,a5,26
    80004620:	078e                	slli	a5,a5,0x3
    80004622:	97a6                	add	a5,a5,s1
    80004624:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004628:	fd043503          	ld	a0,-48(s0)
    8000462c:	ccbfe0ef          	jal	ra,800032f6 <fileclose>
    fileclose(wf);
    80004630:	fc843503          	ld	a0,-56(s0)
    80004634:	cc3fe0ef          	jal	ra,800032f6 <fileclose>
    return -1;
    80004638:	57fd                	li	a5,-1
}
    8000463a:	853e                	mv	a0,a5
    8000463c:	70e2                	ld	ra,56(sp)
    8000463e:	7442                	ld	s0,48(sp)
    80004640:	74a2                	ld	s1,40(sp)
    80004642:	6121                	addi	sp,sp,64
    80004644:	8082                	ret

0000000080004646 <sys_symlink>:

uint64
sys_symlink(void)
{
    80004646:	7155                	addi	sp,sp,-208
    80004648:	e586                	sd	ra,200(sp)
    8000464a:	e1a2                	sd	s0,192(sp)
    8000464c:	fd26                	sd	s1,184(sp)
    8000464e:	0980                	addi	s0,sp,208
  char target[MAXPATH], path[MAXARG];
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80004650:	08000613          	li	a2,128
    80004654:	f6040593          	addi	a1,s0,-160
    80004658:	4501                	li	a0,0
    8000465a:	d9afd0ef          	jal	ra,80001bf4 <argstr>
    return -1;
    8000465e:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80004660:	06054863          	bltz	a0,800046d0 <sys_symlink+0x8a>
    80004664:	08000613          	li	a2,128
    80004668:	f4040593          	addi	a1,s0,-192
    8000466c:	4505                	li	a0,1
    8000466e:	d86fd0ef          	jal	ra,80001bf4 <argstr>
    return -1;
    80004672:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80004674:	04054e63          	bltz	a0,800046d0 <sys_symlink+0x8a>
  }

  begin_op();
    80004678:	867fe0ef          	jal	ra,80002ede <begin_op>
  struct inode *ip = create(path, T_SYMLINK, 0, 0);
    8000467c:	4681                	li	a3,0
    8000467e:	4601                	li	a2,0
    80004680:	4591                	li	a1,4
    80004682:	f4040513          	addi	a0,s0,-192
    80004686:	dfaff0ef          	jal	ra,80003c80 <create>
    8000468a:	84aa                	mv	s1,a0
  if(ip == 0){
    8000468c:	c921                	beqz	a0,800046dc <sys_symlink+0x96>
    end_op();
    return -1;
  }

  int len = strlen(target);
    8000468e:	f6040513          	addi	a0,s0,-160
    80004692:	c35fb0ef          	jal	ra,800002c6 <strlen>
    80004696:	f2a42e23          	sw	a0,-196(s0)
  writei(ip, 0, (uint64)&len, 0, sizeof(int));  
    8000469a:	4711                	li	a4,4
    8000469c:	4681                	li	a3,0
    8000469e:	f3c40613          	addi	a2,s0,-196
    800046a2:	4581                	li	a1,0
    800046a4:	8526                	mv	a0,s1
    800046a6:	ad6fe0ef          	jal	ra,8000297c <writei>
  writei(ip, 0, (uint64)target, sizeof(int), len + 1);  
    800046aa:	f3c42703          	lw	a4,-196(s0)
    800046ae:	2705                	addiw	a4,a4,1
    800046b0:	4691                	li	a3,4
    800046b2:	f6040613          	addi	a2,s0,-160
    800046b6:	4581                	li	a1,0
    800046b8:	8526                	mv	a0,s1
    800046ba:	ac2fe0ef          	jal	ra,8000297c <writei>
  iupdate(ip);
    800046be:	8526                	mv	a0,s1
    800046c0:	ed5fd0ef          	jal	ra,80002594 <iupdate>
  iunlockput(ip);
    800046c4:	8526                	mv	a0,s1
    800046c6:	988fe0ef          	jal	ra,8000284e <iunlockput>

  end_op();
    800046ca:	883fe0ef          	jal	ra,80002f4c <end_op>
  return 0;
    800046ce:	4781                	li	a5,0
    800046d0:	853e                	mv	a0,a5
    800046d2:	60ae                	ld	ra,200(sp)
    800046d4:	640e                	ld	s0,192(sp)
    800046d6:	74ea                	ld	s1,184(sp)
    800046d8:	6169                	addi	sp,sp,208
    800046da:	8082                	ret
    end_op();
    800046dc:	871fe0ef          	jal	ra,80002f4c <end_op>
    return -1;
    800046e0:	57fd                	li	a5,-1
    800046e2:	b7fd                	j	800046d0 <sys_symlink+0x8a>
	...

00000000800046f0 <kernelvec>:
    800046f0:	7111                	addi	sp,sp,-256
    800046f2:	e006                	sd	ra,0(sp)
    800046f4:	e40a                	sd	sp,8(sp)
    800046f6:	e80e                	sd	gp,16(sp)
    800046f8:	ec12                	sd	tp,24(sp)
    800046fa:	f016                	sd	t0,32(sp)
    800046fc:	f41a                	sd	t1,40(sp)
    800046fe:	f81e                	sd	t2,48(sp)
    80004700:	e4aa                	sd	a0,72(sp)
    80004702:	e8ae                	sd	a1,80(sp)
    80004704:	ecb2                	sd	a2,88(sp)
    80004706:	f0b6                	sd	a3,96(sp)
    80004708:	f4ba                	sd	a4,104(sp)
    8000470a:	f8be                	sd	a5,112(sp)
    8000470c:	fcc2                	sd	a6,120(sp)
    8000470e:	e146                	sd	a7,128(sp)
    80004710:	edf2                	sd	t3,216(sp)
    80004712:	f1f6                	sd	t4,224(sp)
    80004714:	f5fa                	sd	t5,232(sp)
    80004716:	f9fe                	sd	t6,240(sp)
    80004718:	b2afd0ef          	jal	ra,80001a42 <kerneltrap>
    8000471c:	6082                	ld	ra,0(sp)
    8000471e:	6122                	ld	sp,8(sp)
    80004720:	61c2                	ld	gp,16(sp)
    80004722:	7282                	ld	t0,32(sp)
    80004724:	7322                	ld	t1,40(sp)
    80004726:	73c2                	ld	t2,48(sp)
    80004728:	6526                	ld	a0,72(sp)
    8000472a:	65c6                	ld	a1,80(sp)
    8000472c:	6666                	ld	a2,88(sp)
    8000472e:	7686                	ld	a3,96(sp)
    80004730:	7726                	ld	a4,104(sp)
    80004732:	77c6                	ld	a5,112(sp)
    80004734:	7866                	ld	a6,120(sp)
    80004736:	688a                	ld	a7,128(sp)
    80004738:	6e6e                	ld	t3,216(sp)
    8000473a:	7e8e                	ld	t4,224(sp)
    8000473c:	7f2e                	ld	t5,232(sp)
    8000473e:	7fce                	ld	t6,240(sp)
    80004740:	6111                	addi	sp,sp,256
    80004742:	10200073          	sret
	...

000000008000474e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000474e:	1141                	addi	sp,sp,-16
    80004750:	e422                	sd	s0,8(sp)
    80004752:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004754:	0c0007b7          	lui	a5,0xc000
    80004758:	4705                	li	a4,1
    8000475a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000475c:	c3d8                	sw	a4,4(a5)
}
    8000475e:	6422                	ld	s0,8(sp)
    80004760:	0141                	addi	sp,sp,16
    80004762:	8082                	ret

0000000080004764 <plicinithart>:

void
plicinithart(void)
{
    80004764:	1141                	addi	sp,sp,-16
    80004766:	e406                	sd	ra,8(sp)
    80004768:	e022                	sd	s0,0(sp)
    8000476a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000476c:	d74fc0ef          	jal	ra,80000ce0 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004770:	0085171b          	slliw	a4,a0,0x8
    80004774:	0c0027b7          	lui	a5,0xc002
    80004778:	97ba                	add	a5,a5,a4
    8000477a:	40200713          	li	a4,1026
    8000477e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004782:	00d5151b          	slliw	a0,a0,0xd
    80004786:	0c2017b7          	lui	a5,0xc201
    8000478a:	97aa                	add	a5,a5,a0
    8000478c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004790:	60a2                	ld	ra,8(sp)
    80004792:	6402                	ld	s0,0(sp)
    80004794:	0141                	addi	sp,sp,16
    80004796:	8082                	ret

0000000080004798 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004798:	1141                	addi	sp,sp,-16
    8000479a:	e406                	sd	ra,8(sp)
    8000479c:	e022                	sd	s0,0(sp)
    8000479e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800047a0:	d40fc0ef          	jal	ra,80000ce0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800047a4:	00d5151b          	slliw	a0,a0,0xd
    800047a8:	0c2017b7          	lui	a5,0xc201
    800047ac:	97aa                	add	a5,a5,a0
  return irq;
}
    800047ae:	43c8                	lw	a0,4(a5)
    800047b0:	60a2                	ld	ra,8(sp)
    800047b2:	6402                	ld	s0,0(sp)
    800047b4:	0141                	addi	sp,sp,16
    800047b6:	8082                	ret

00000000800047b8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800047b8:	1101                	addi	sp,sp,-32
    800047ba:	ec06                	sd	ra,24(sp)
    800047bc:	e822                	sd	s0,16(sp)
    800047be:	e426                	sd	s1,8(sp)
    800047c0:	1000                	addi	s0,sp,32
    800047c2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800047c4:	d1cfc0ef          	jal	ra,80000ce0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800047c8:	00d5151b          	slliw	a0,a0,0xd
    800047cc:	0c2017b7          	lui	a5,0xc201
    800047d0:	97aa                	add	a5,a5,a0
    800047d2:	c3c4                	sw	s1,4(a5)
}
    800047d4:	60e2                	ld	ra,24(sp)
    800047d6:	6442                	ld	s0,16(sp)
    800047d8:	64a2                	ld	s1,8(sp)
    800047da:	6105                	addi	sp,sp,32
    800047dc:	8082                	ret

00000000800047de <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800047de:	1141                	addi	sp,sp,-16
    800047e0:	e406                	sd	ra,8(sp)
    800047e2:	e022                	sd	s0,0(sp)
    800047e4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800047e6:	479d                	li	a5,7
    800047e8:	04a7ca63          	blt	a5,a0,8000483c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800047ec:	0000f797          	auipc	a5,0xf
    800047f0:	62478793          	addi	a5,a5,1572 # 80013e10 <disk>
    800047f4:	97aa                	add	a5,a5,a0
    800047f6:	0187c783          	lbu	a5,24(a5)
    800047fa:	e7b9                	bnez	a5,80004848 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800047fc:	00451693          	slli	a3,a0,0x4
    80004800:	0000f797          	auipc	a5,0xf
    80004804:	61078793          	addi	a5,a5,1552 # 80013e10 <disk>
    80004808:	6398                	ld	a4,0(a5)
    8000480a:	9736                	add	a4,a4,a3
    8000480c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004810:	6398                	ld	a4,0(a5)
    80004812:	9736                	add	a4,a4,a3
    80004814:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004818:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000481c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004820:	97aa                	add	a5,a5,a0
    80004822:	4705                	li	a4,1
    80004824:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004828:	0000f517          	auipc	a0,0xf
    8000482c:	60050513          	addi	a0,a0,1536 # 80013e28 <disk+0x18>
    80004830:	af7fc0ef          	jal	ra,80001326 <wakeup>
}
    80004834:	60a2                	ld	ra,8(sp)
    80004836:	6402                	ld	s0,0(sp)
    80004838:	0141                	addi	sp,sp,16
    8000483a:	8082                	ret
    panic("free_desc 1");
    8000483c:	00003517          	auipc	a0,0x3
    80004840:	ebc50513          	addi	a0,a0,-324 # 800076f8 <syscalls+0x2e0>
    80004844:	3bf000ef          	jal	ra,80005402 <panic>
    panic("free_desc 2");
    80004848:	00003517          	auipc	a0,0x3
    8000484c:	ec050513          	addi	a0,a0,-320 # 80007708 <syscalls+0x2f0>
    80004850:	3b3000ef          	jal	ra,80005402 <panic>

0000000080004854 <virtio_disk_init>:
{
    80004854:	1101                	addi	sp,sp,-32
    80004856:	ec06                	sd	ra,24(sp)
    80004858:	e822                	sd	s0,16(sp)
    8000485a:	e426                	sd	s1,8(sp)
    8000485c:	e04a                	sd	s2,0(sp)
    8000485e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004860:	00003597          	auipc	a1,0x3
    80004864:	eb858593          	addi	a1,a1,-328 # 80007718 <syscalls+0x300>
    80004868:	0000f517          	auipc	a0,0xf
    8000486c:	6d050513          	addi	a0,a0,1744 # 80013f38 <disk+0x128>
    80004870:	623000ef          	jal	ra,80005692 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004874:	100017b7          	lui	a5,0x10001
    80004878:	4398                	lw	a4,0(a5)
    8000487a:	2701                	sext.w	a4,a4
    8000487c:	747277b7          	lui	a5,0x74727
    80004880:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004884:	12f71f63          	bne	a4,a5,800049c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004888:	100017b7          	lui	a5,0x10001
    8000488c:	43dc                	lw	a5,4(a5)
    8000488e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004890:	4709                	li	a4,2
    80004892:	12e79863          	bne	a5,a4,800049c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004896:	100017b7          	lui	a5,0x10001
    8000489a:	479c                	lw	a5,8(a5)
    8000489c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000489e:	12e79263          	bne	a5,a4,800049c2 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800048a2:	100017b7          	lui	a5,0x10001
    800048a6:	47d8                	lw	a4,12(a5)
    800048a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800048aa:	554d47b7          	lui	a5,0x554d4
    800048ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800048b2:	10f71863          	bne	a4,a5,800049c2 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048b6:	100017b7          	lui	a5,0x10001
    800048ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800048be:	4705                	li	a4,1
    800048c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048c2:	470d                	li	a4,3
    800048c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800048c6:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800048c8:	c7ffe6b7          	lui	a3,0xc7ffe
    800048cc:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe270f>
    800048d0:	8f75                	and	a4,a4,a3
    800048d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800048d4:	472d                	li	a4,11
    800048d6:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800048d8:	5bbc                	lw	a5,112(a5)
    800048da:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800048de:	8ba1                	andi	a5,a5,8
    800048e0:	0e078763          	beqz	a5,800049ce <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800048e4:	100017b7          	lui	a5,0x10001
    800048e8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800048ec:	43fc                	lw	a5,68(a5)
    800048ee:	2781                	sext.w	a5,a5
    800048f0:	0e079563          	bnez	a5,800049da <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800048f4:	100017b7          	lui	a5,0x10001
    800048f8:	5bdc                	lw	a5,52(a5)
    800048fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800048fc:	0e078563          	beqz	a5,800049e6 <virtio_disk_init+0x192>
  if(max < NUM)
    80004900:	471d                	li	a4,7
    80004902:	0ef77863          	bgeu	a4,a5,800049f2 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80004906:	ff8fb0ef          	jal	ra,800000fe <kalloc>
    8000490a:	0000f497          	auipc	s1,0xf
    8000490e:	50648493          	addi	s1,s1,1286 # 80013e10 <disk>
    80004912:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004914:	feafb0ef          	jal	ra,800000fe <kalloc>
    80004918:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000491a:	fe4fb0ef          	jal	ra,800000fe <kalloc>
    8000491e:	87aa                	mv	a5,a0
    80004920:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004922:	6088                	ld	a0,0(s1)
    80004924:	cd69                	beqz	a0,800049fe <virtio_disk_init+0x1aa>
    80004926:	0000f717          	auipc	a4,0xf
    8000492a:	4f273703          	ld	a4,1266(a4) # 80013e18 <disk+0x8>
    8000492e:	cb61                	beqz	a4,800049fe <virtio_disk_init+0x1aa>
    80004930:	c7f9                	beqz	a5,800049fe <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80004932:	6605                	lui	a2,0x1
    80004934:	4581                	li	a1,0
    80004936:	819fb0ef          	jal	ra,8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    8000493a:	0000f497          	auipc	s1,0xf
    8000493e:	4d648493          	addi	s1,s1,1238 # 80013e10 <disk>
    80004942:	6605                	lui	a2,0x1
    80004944:	4581                	li	a1,0
    80004946:	6488                	ld	a0,8(s1)
    80004948:	807fb0ef          	jal	ra,8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    8000494c:	6605                	lui	a2,0x1
    8000494e:	4581                	li	a1,0
    80004950:	6888                	ld	a0,16(s1)
    80004952:	ffcfb0ef          	jal	ra,8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004956:	100017b7          	lui	a5,0x10001
    8000495a:	4721                	li	a4,8
    8000495c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000495e:	4098                	lw	a4,0(s1)
    80004960:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004964:	40d8                	lw	a4,4(s1)
    80004966:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000496a:	6498                	ld	a4,8(s1)
    8000496c:	0007069b          	sext.w	a3,a4
    80004970:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004974:	9701                	srai	a4,a4,0x20
    80004976:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000497a:	6898                	ld	a4,16(s1)
    8000497c:	0007069b          	sext.w	a3,a4
    80004980:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004984:	9701                	srai	a4,a4,0x20
    80004986:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000498a:	4705                	li	a4,1
    8000498c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000498e:	00e48c23          	sb	a4,24(s1)
    80004992:	00e48ca3          	sb	a4,25(s1)
    80004996:	00e48d23          	sb	a4,26(s1)
    8000499a:	00e48da3          	sb	a4,27(s1)
    8000499e:	00e48e23          	sb	a4,28(s1)
    800049a2:	00e48ea3          	sb	a4,29(s1)
    800049a6:	00e48f23          	sb	a4,30(s1)
    800049aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800049ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800049b2:	0727a823          	sw	s2,112(a5)
}
    800049b6:	60e2                	ld	ra,24(sp)
    800049b8:	6442                	ld	s0,16(sp)
    800049ba:	64a2                	ld	s1,8(sp)
    800049bc:	6902                	ld	s2,0(sp)
    800049be:	6105                	addi	sp,sp,32
    800049c0:	8082                	ret
    panic("could not find virtio disk");
    800049c2:	00003517          	auipc	a0,0x3
    800049c6:	d6650513          	addi	a0,a0,-666 # 80007728 <syscalls+0x310>
    800049ca:	239000ef          	jal	ra,80005402 <panic>
    panic("virtio disk FEATURES_OK unset");
    800049ce:	00003517          	auipc	a0,0x3
    800049d2:	d7a50513          	addi	a0,a0,-646 # 80007748 <syscalls+0x330>
    800049d6:	22d000ef          	jal	ra,80005402 <panic>
    panic("virtio disk should not be ready");
    800049da:	00003517          	auipc	a0,0x3
    800049de:	d8e50513          	addi	a0,a0,-626 # 80007768 <syscalls+0x350>
    800049e2:	221000ef          	jal	ra,80005402 <panic>
    panic("virtio disk has no queue 0");
    800049e6:	00003517          	auipc	a0,0x3
    800049ea:	da250513          	addi	a0,a0,-606 # 80007788 <syscalls+0x370>
    800049ee:	215000ef          	jal	ra,80005402 <panic>
    panic("virtio disk max queue too short");
    800049f2:	00003517          	auipc	a0,0x3
    800049f6:	db650513          	addi	a0,a0,-586 # 800077a8 <syscalls+0x390>
    800049fa:	209000ef          	jal	ra,80005402 <panic>
    panic("virtio disk kalloc");
    800049fe:	00003517          	auipc	a0,0x3
    80004a02:	dca50513          	addi	a0,a0,-566 # 800077c8 <syscalls+0x3b0>
    80004a06:	1fd000ef          	jal	ra,80005402 <panic>

0000000080004a0a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004a0a:	7119                	addi	sp,sp,-128
    80004a0c:	fc86                	sd	ra,120(sp)
    80004a0e:	f8a2                	sd	s0,112(sp)
    80004a10:	f4a6                	sd	s1,104(sp)
    80004a12:	f0ca                	sd	s2,96(sp)
    80004a14:	ecce                	sd	s3,88(sp)
    80004a16:	e8d2                	sd	s4,80(sp)
    80004a18:	e4d6                	sd	s5,72(sp)
    80004a1a:	e0da                	sd	s6,64(sp)
    80004a1c:	fc5e                	sd	s7,56(sp)
    80004a1e:	f862                	sd	s8,48(sp)
    80004a20:	f466                	sd	s9,40(sp)
    80004a22:	f06a                	sd	s10,32(sp)
    80004a24:	ec6e                	sd	s11,24(sp)
    80004a26:	0100                	addi	s0,sp,128
    80004a28:	8aaa                	mv	s5,a0
    80004a2a:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004a2c:	00c52d03          	lw	s10,12(a0)
    80004a30:	001d1d1b          	slliw	s10,s10,0x1
    80004a34:	1d02                	slli	s10,s10,0x20
    80004a36:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80004a3a:	0000f517          	auipc	a0,0xf
    80004a3e:	4fe50513          	addi	a0,a0,1278 # 80013f38 <disk+0x128>
    80004a42:	4d1000ef          	jal	ra,80005712 <acquire>
  for(int i = 0; i < 3; i++){
    80004a46:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004a48:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004a4a:	0000fb97          	auipc	s7,0xf
    80004a4e:	3c6b8b93          	addi	s7,s7,966 # 80013e10 <disk>
  for(int i = 0; i < 3; i++){
    80004a52:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004a54:	0000fc97          	auipc	s9,0xf
    80004a58:	4e4c8c93          	addi	s9,s9,1252 # 80013f38 <disk+0x128>
    80004a5c:	a8a9                	j	80004ab6 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004a5e:	00fb8733          	add	a4,s7,a5
    80004a62:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004a66:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004a68:	0207c563          	bltz	a5,80004a92 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80004a6c:	2905                	addiw	s2,s2,1
    80004a6e:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004a70:	05690863          	beq	s2,s6,80004ac0 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80004a74:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004a76:	0000f717          	auipc	a4,0xf
    80004a7a:	39a70713          	addi	a4,a4,922 # 80013e10 <disk>
    80004a7e:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004a80:	01874683          	lbu	a3,24(a4)
    80004a84:	fee9                	bnez	a3,80004a5e <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80004a86:	2785                	addiw	a5,a5,1
    80004a88:	0705                	addi	a4,a4,1
    80004a8a:	fe979be3          	bne	a5,s1,80004a80 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80004a8e:	57fd                	li	a5,-1
    80004a90:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004a92:	01205b63          	blez	s2,80004aa8 <virtio_disk_rw+0x9e>
    80004a96:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80004a98:	000a2503          	lw	a0,0(s4)
    80004a9c:	d43ff0ef          	jal	ra,800047de <free_desc>
      for(int j = 0; j < i; j++)
    80004aa0:	2d85                	addiw	s11,s11,1
    80004aa2:	0a11                	addi	s4,s4,4
    80004aa4:	ff2d9ae3          	bne	s11,s2,80004a98 <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004aa8:	85e6                	mv	a1,s9
    80004aaa:	0000f517          	auipc	a0,0xf
    80004aae:	37e50513          	addi	a0,a0,894 # 80013e28 <disk+0x18>
    80004ab2:	829fc0ef          	jal	ra,800012da <sleep>
  for(int i = 0; i < 3; i++){
    80004ab6:	f8040a13          	addi	s4,s0,-128
{
    80004aba:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80004abc:	894e                	mv	s2,s3
    80004abe:	bf5d                	j	80004a74 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ac0:	f8042503          	lw	a0,-128(s0)
    80004ac4:	00a50713          	addi	a4,a0,10
    80004ac8:	0712                	slli	a4,a4,0x4

  if(write)
    80004aca:	0000f797          	auipc	a5,0xf
    80004ace:	34678793          	addi	a5,a5,838 # 80013e10 <disk>
    80004ad2:	00e786b3          	add	a3,a5,a4
    80004ad6:	01803633          	snez	a2,s8
    80004ada:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004adc:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80004ae0:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ae4:	f6070613          	addi	a2,a4,-160
    80004ae8:	6394                	ld	a3,0(a5)
    80004aea:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004aec:	00870593          	addi	a1,a4,8
    80004af0:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004af2:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004af4:	0007b803          	ld	a6,0(a5)
    80004af8:	9642                	add	a2,a2,a6
    80004afa:	46c1                	li	a3,16
    80004afc:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004afe:	4585                	li	a1,1
    80004b00:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80004b04:	f8442683          	lw	a3,-124(s0)
    80004b08:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004b0c:	0692                	slli	a3,a3,0x4
    80004b0e:	9836                	add	a6,a6,a3
    80004b10:	058a8613          	addi	a2,s5,88
    80004b14:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80004b18:	0007b803          	ld	a6,0(a5)
    80004b1c:	96c2                	add	a3,a3,a6
    80004b1e:	40000613          	li	a2,1024
    80004b22:	c690                	sw	a2,8(a3)
  if(write)
    80004b24:	001c3613          	seqz	a2,s8
    80004b28:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004b2c:	00166613          	ori	a2,a2,1
    80004b30:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80004b34:	f8842603          	lw	a2,-120(s0)
    80004b38:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004b3c:	00250693          	addi	a3,a0,2
    80004b40:	0692                	slli	a3,a3,0x4
    80004b42:	96be                	add	a3,a3,a5
    80004b44:	58fd                	li	a7,-1
    80004b46:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004b4a:	0612                	slli	a2,a2,0x4
    80004b4c:	9832                	add	a6,a6,a2
    80004b4e:	f9070713          	addi	a4,a4,-112
    80004b52:	973e                	add	a4,a4,a5
    80004b54:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    80004b58:	6398                	ld	a4,0(a5)
    80004b5a:	9732                	add	a4,a4,a2
    80004b5c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004b5e:	4609                	li	a2,2
    80004b60:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80004b64:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004b68:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80004b6c:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004b70:	6794                	ld	a3,8(a5)
    80004b72:	0026d703          	lhu	a4,2(a3)
    80004b76:	8b1d                	andi	a4,a4,7
    80004b78:	0706                	slli	a4,a4,0x1
    80004b7a:	96ba                	add	a3,a3,a4
    80004b7c:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004b80:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004b84:	6798                	ld	a4,8(a5)
    80004b86:	00275783          	lhu	a5,2(a4)
    80004b8a:	2785                	addiw	a5,a5,1
    80004b8c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004b90:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004b94:	100017b7          	lui	a5,0x10001
    80004b98:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004b9c:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80004ba0:	0000f917          	auipc	s2,0xf
    80004ba4:	39890913          	addi	s2,s2,920 # 80013f38 <disk+0x128>
  while(b->disk == 1) {
    80004ba8:	4485                	li	s1,1
    80004baa:	00b79a63          	bne	a5,a1,80004bbe <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    80004bae:	85ca                	mv	a1,s2
    80004bb0:	8556                	mv	a0,s5
    80004bb2:	f28fc0ef          	jal	ra,800012da <sleep>
  while(b->disk == 1) {
    80004bb6:	004aa783          	lw	a5,4(s5)
    80004bba:	fe978ae3          	beq	a5,s1,80004bae <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    80004bbe:	f8042903          	lw	s2,-128(s0)
    80004bc2:	00290713          	addi	a4,s2,2
    80004bc6:	0712                	slli	a4,a4,0x4
    80004bc8:	0000f797          	auipc	a5,0xf
    80004bcc:	24878793          	addi	a5,a5,584 # 80013e10 <disk>
    80004bd0:	97ba                	add	a5,a5,a4
    80004bd2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004bd6:	0000f997          	auipc	s3,0xf
    80004bda:	23a98993          	addi	s3,s3,570 # 80013e10 <disk>
    80004bde:	00491713          	slli	a4,s2,0x4
    80004be2:	0009b783          	ld	a5,0(s3)
    80004be6:	97ba                	add	a5,a5,a4
    80004be8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004bec:	854a                	mv	a0,s2
    80004bee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004bf2:	bedff0ef          	jal	ra,800047de <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004bf6:	8885                	andi	s1,s1,1
    80004bf8:	f0fd                	bnez	s1,80004bde <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004bfa:	0000f517          	auipc	a0,0xf
    80004bfe:	33e50513          	addi	a0,a0,830 # 80013f38 <disk+0x128>
    80004c02:	3a9000ef          	jal	ra,800057aa <release>
}
    80004c06:	70e6                	ld	ra,120(sp)
    80004c08:	7446                	ld	s0,112(sp)
    80004c0a:	74a6                	ld	s1,104(sp)
    80004c0c:	7906                	ld	s2,96(sp)
    80004c0e:	69e6                	ld	s3,88(sp)
    80004c10:	6a46                	ld	s4,80(sp)
    80004c12:	6aa6                	ld	s5,72(sp)
    80004c14:	6b06                	ld	s6,64(sp)
    80004c16:	7be2                	ld	s7,56(sp)
    80004c18:	7c42                	ld	s8,48(sp)
    80004c1a:	7ca2                	ld	s9,40(sp)
    80004c1c:	7d02                	ld	s10,32(sp)
    80004c1e:	6de2                	ld	s11,24(sp)
    80004c20:	6109                	addi	sp,sp,128
    80004c22:	8082                	ret

0000000080004c24 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004c24:	1101                	addi	sp,sp,-32
    80004c26:	ec06                	sd	ra,24(sp)
    80004c28:	e822                	sd	s0,16(sp)
    80004c2a:	e426                	sd	s1,8(sp)
    80004c2c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004c2e:	0000f497          	auipc	s1,0xf
    80004c32:	1e248493          	addi	s1,s1,482 # 80013e10 <disk>
    80004c36:	0000f517          	auipc	a0,0xf
    80004c3a:	30250513          	addi	a0,a0,770 # 80013f38 <disk+0x128>
    80004c3e:	2d5000ef          	jal	ra,80005712 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004c42:	10001737          	lui	a4,0x10001
    80004c46:	533c                	lw	a5,96(a4)
    80004c48:	8b8d                	andi	a5,a5,3
    80004c4a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004c4c:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004c50:	689c                	ld	a5,16(s1)
    80004c52:	0204d703          	lhu	a4,32(s1)
    80004c56:	0027d783          	lhu	a5,2(a5)
    80004c5a:	04f70663          	beq	a4,a5,80004ca6 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004c5e:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004c62:	6898                	ld	a4,16(s1)
    80004c64:	0204d783          	lhu	a5,32(s1)
    80004c68:	8b9d                	andi	a5,a5,7
    80004c6a:	078e                	slli	a5,a5,0x3
    80004c6c:	97ba                	add	a5,a5,a4
    80004c6e:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004c70:	00278713          	addi	a4,a5,2
    80004c74:	0712                	slli	a4,a4,0x4
    80004c76:	9726                	add	a4,a4,s1
    80004c78:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004c7c:	e321                	bnez	a4,80004cbc <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004c7e:	0789                	addi	a5,a5,2
    80004c80:	0792                	slli	a5,a5,0x4
    80004c82:	97a6                	add	a5,a5,s1
    80004c84:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004c86:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004c8a:	e9cfc0ef          	jal	ra,80001326 <wakeup>

    disk.used_idx += 1;
    80004c8e:	0204d783          	lhu	a5,32(s1)
    80004c92:	2785                	addiw	a5,a5,1
    80004c94:	17c2                	slli	a5,a5,0x30
    80004c96:	93c1                	srli	a5,a5,0x30
    80004c98:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004c9c:	6898                	ld	a4,16(s1)
    80004c9e:	00275703          	lhu	a4,2(a4)
    80004ca2:	faf71ee3          	bne	a4,a5,80004c5e <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004ca6:	0000f517          	auipc	a0,0xf
    80004caa:	29250513          	addi	a0,a0,658 # 80013f38 <disk+0x128>
    80004cae:	2fd000ef          	jal	ra,800057aa <release>
}
    80004cb2:	60e2                	ld	ra,24(sp)
    80004cb4:	6442                	ld	s0,16(sp)
    80004cb6:	64a2                	ld	s1,8(sp)
    80004cb8:	6105                	addi	sp,sp,32
    80004cba:	8082                	ret
      panic("virtio_disk_intr status");
    80004cbc:	00003517          	auipc	a0,0x3
    80004cc0:	b2450513          	addi	a0,a0,-1244 # 800077e0 <syscalls+0x3c8>
    80004cc4:	73e000ef          	jal	ra,80005402 <panic>

0000000080004cc8 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004cc8:	1141                	addi	sp,sp,-16
    80004cca:	e422                	sd	s0,8(sp)
    80004ccc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004cce:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004cd2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004cd6:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004cda:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004cde:	577d                	li	a4,-1
    80004ce0:	177e                	slli	a4,a4,0x3f
    80004ce2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004ce4:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004ce8:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004cec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004cf0:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004cf4:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004cf8:	000f4737          	lui	a4,0xf4
    80004cfc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004d00:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004d02:	14d79073          	csrw	0x14d,a5
}
    80004d06:	6422                	ld	s0,8(sp)
    80004d08:	0141                	addi	sp,sp,16
    80004d0a:	8082                	ret

0000000080004d0c <start>:
{
    80004d0c:	1141                	addi	sp,sp,-16
    80004d0e:	e406                	sd	ra,8(sp)
    80004d10:	e022                	sd	s0,0(sp)
    80004d12:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004d14:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004d18:	7779                	lui	a4,0xffffe
    80004d1a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe27af>
    80004d1e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004d20:	6705                	lui	a4,0x1
    80004d22:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004d26:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004d28:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004d2c:	ffffb797          	auipc	a5,0xffffb
    80004d30:	5c478793          	addi	a5,a5,1476 # 800002f0 <main>
    80004d34:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004d38:	4781                	li	a5,0
    80004d3a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004d3e:	67c1                	lui	a5,0x10
    80004d40:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004d42:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004d46:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004d4a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004d4e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004d52:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004d56:	57fd                	li	a5,-1
    80004d58:	83a9                	srli	a5,a5,0xa
    80004d5a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004d5e:	47bd                	li	a5,15
    80004d60:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004d64:	f65ff0ef          	jal	ra,80004cc8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004d68:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004d6c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004d6e:	823e                	mv	tp,a5
  asm volatile("mret");
    80004d70:	30200073          	mret
}
    80004d74:	60a2                	ld	ra,8(sp)
    80004d76:	6402                	ld	s0,0(sp)
    80004d78:	0141                	addi	sp,sp,16
    80004d7a:	8082                	ret

0000000080004d7c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004d7c:	715d                	addi	sp,sp,-80
    80004d7e:	e486                	sd	ra,72(sp)
    80004d80:	e0a2                	sd	s0,64(sp)
    80004d82:	fc26                	sd	s1,56(sp)
    80004d84:	f84a                	sd	s2,48(sp)
    80004d86:	f44e                	sd	s3,40(sp)
    80004d88:	f052                	sd	s4,32(sp)
    80004d8a:	ec56                	sd	s5,24(sp)
    80004d8c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004d8e:	04c05363          	blez	a2,80004dd4 <consolewrite+0x58>
    80004d92:	8a2a                	mv	s4,a0
    80004d94:	84ae                	mv	s1,a1
    80004d96:	89b2                	mv	s3,a2
    80004d98:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004d9a:	5afd                	li	s5,-1
    80004d9c:	4685                	li	a3,1
    80004d9e:	8626                	mv	a2,s1
    80004da0:	85d2                	mv	a1,s4
    80004da2:	fbf40513          	addi	a0,s0,-65
    80004da6:	8dbfc0ef          	jal	ra,80001680 <either_copyin>
    80004daa:	01550b63          	beq	a0,s5,80004dc0 <consolewrite+0x44>
      break;
    uartputc(c);
    80004dae:	fbf44503          	lbu	a0,-65(s0)
    80004db2:	7da000ef          	jal	ra,8000558c <uartputc>
  for(i = 0; i < n; i++){
    80004db6:	2905                	addiw	s2,s2,1
    80004db8:	0485                	addi	s1,s1,1
    80004dba:	ff2991e3          	bne	s3,s2,80004d9c <consolewrite+0x20>
    80004dbe:	894e                	mv	s2,s3
  }

  return i;
}
    80004dc0:	854a                	mv	a0,s2
    80004dc2:	60a6                	ld	ra,72(sp)
    80004dc4:	6406                	ld	s0,64(sp)
    80004dc6:	74e2                	ld	s1,56(sp)
    80004dc8:	7942                	ld	s2,48(sp)
    80004dca:	79a2                	ld	s3,40(sp)
    80004dcc:	7a02                	ld	s4,32(sp)
    80004dce:	6ae2                	ld	s5,24(sp)
    80004dd0:	6161                	addi	sp,sp,80
    80004dd2:	8082                	ret
  for(i = 0; i < n; i++){
    80004dd4:	4901                	li	s2,0
    80004dd6:	b7ed                	j	80004dc0 <consolewrite+0x44>

0000000080004dd8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004dd8:	7159                	addi	sp,sp,-112
    80004dda:	f486                	sd	ra,104(sp)
    80004ddc:	f0a2                	sd	s0,96(sp)
    80004dde:	eca6                	sd	s1,88(sp)
    80004de0:	e8ca                	sd	s2,80(sp)
    80004de2:	e4ce                	sd	s3,72(sp)
    80004de4:	e0d2                	sd	s4,64(sp)
    80004de6:	fc56                	sd	s5,56(sp)
    80004de8:	f85a                	sd	s6,48(sp)
    80004dea:	f45e                	sd	s7,40(sp)
    80004dec:	f062                	sd	s8,32(sp)
    80004dee:	ec66                	sd	s9,24(sp)
    80004df0:	e86a                	sd	s10,16(sp)
    80004df2:	1880                	addi	s0,sp,112
    80004df4:	8aaa                	mv	s5,a0
    80004df6:	8a2e                	mv	s4,a1
    80004df8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004dfa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004dfe:	00017517          	auipc	a0,0x17
    80004e02:	15250513          	addi	a0,a0,338 # 8001bf50 <cons>
    80004e06:	10d000ef          	jal	ra,80005712 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004e0a:	00017497          	auipc	s1,0x17
    80004e0e:	14648493          	addi	s1,s1,326 # 8001bf50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004e12:	00017917          	auipc	s2,0x17
    80004e16:	1d690913          	addi	s2,s2,470 # 8001bfe8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004e1a:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e1c:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004e1e:	4ca9                	li	s9,10
  while(n > 0){
    80004e20:	07305363          	blez	s3,80004e86 <consoleread+0xae>
    while(cons.r == cons.w){
    80004e24:	0984a783          	lw	a5,152(s1)
    80004e28:	09c4a703          	lw	a4,156(s1)
    80004e2c:	02f71163          	bne	a4,a5,80004e4e <consoleread+0x76>
      if(killed(myproc())){
    80004e30:	eddfb0ef          	jal	ra,80000d0c <myproc>
    80004e34:	edefc0ef          	jal	ra,80001512 <killed>
    80004e38:	e125                	bnez	a0,80004e98 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80004e3a:	85a6                	mv	a1,s1
    80004e3c:	854a                	mv	a0,s2
    80004e3e:	c9cfc0ef          	jal	ra,800012da <sleep>
    while(cons.r == cons.w){
    80004e42:	0984a783          	lw	a5,152(s1)
    80004e46:	09c4a703          	lw	a4,156(s1)
    80004e4a:	fef703e3          	beq	a4,a5,80004e30 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004e4e:	0017871b          	addiw	a4,a5,1
    80004e52:	08e4ac23          	sw	a4,152(s1)
    80004e56:	07f7f713          	andi	a4,a5,127
    80004e5a:	9726                	add	a4,a4,s1
    80004e5c:	01874703          	lbu	a4,24(a4)
    80004e60:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80004e64:	057d0f63          	beq	s10,s7,80004ec2 <consoleread+0xea>
    cbuf = c;
    80004e68:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004e6c:	4685                	li	a3,1
    80004e6e:	f9f40613          	addi	a2,s0,-97
    80004e72:	85d2                	mv	a1,s4
    80004e74:	8556                	mv	a0,s5
    80004e76:	fc0fc0ef          	jal	ra,80001636 <either_copyout>
    80004e7a:	01850663          	beq	a0,s8,80004e86 <consoleread+0xae>
    dst++;
    80004e7e:	0a05                	addi	s4,s4,1
    --n;
    80004e80:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80004e82:	f99d1fe3          	bne	s10,s9,80004e20 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004e86:	00017517          	auipc	a0,0x17
    80004e8a:	0ca50513          	addi	a0,a0,202 # 8001bf50 <cons>
    80004e8e:	11d000ef          	jal	ra,800057aa <release>

  return target - n;
    80004e92:	413b053b          	subw	a0,s6,s3
    80004e96:	a801                	j	80004ea6 <consoleread+0xce>
        release(&cons.lock);
    80004e98:	00017517          	auipc	a0,0x17
    80004e9c:	0b850513          	addi	a0,a0,184 # 8001bf50 <cons>
    80004ea0:	10b000ef          	jal	ra,800057aa <release>
        return -1;
    80004ea4:	557d                	li	a0,-1
}
    80004ea6:	70a6                	ld	ra,104(sp)
    80004ea8:	7406                	ld	s0,96(sp)
    80004eaa:	64e6                	ld	s1,88(sp)
    80004eac:	6946                	ld	s2,80(sp)
    80004eae:	69a6                	ld	s3,72(sp)
    80004eb0:	6a06                	ld	s4,64(sp)
    80004eb2:	7ae2                	ld	s5,56(sp)
    80004eb4:	7b42                	ld	s6,48(sp)
    80004eb6:	7ba2                	ld	s7,40(sp)
    80004eb8:	7c02                	ld	s8,32(sp)
    80004eba:	6ce2                	ld	s9,24(sp)
    80004ebc:	6d42                	ld	s10,16(sp)
    80004ebe:	6165                	addi	sp,sp,112
    80004ec0:	8082                	ret
      if(n < target){
    80004ec2:	0009871b          	sext.w	a4,s3
    80004ec6:	fd6770e3          	bgeu	a4,s6,80004e86 <consoleread+0xae>
        cons.r--;
    80004eca:	00017717          	auipc	a4,0x17
    80004ece:	10f72f23          	sw	a5,286(a4) # 8001bfe8 <cons+0x98>
    80004ed2:	bf55                	j	80004e86 <consoleread+0xae>

0000000080004ed4 <consputc>:
{
    80004ed4:	1141                	addi	sp,sp,-16
    80004ed6:	e406                	sd	ra,8(sp)
    80004ed8:	e022                	sd	s0,0(sp)
    80004eda:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004edc:	10000793          	li	a5,256
    80004ee0:	00f50863          	beq	a0,a5,80004ef0 <consputc+0x1c>
    uartputc_sync(c);
    80004ee4:	5d2000ef          	jal	ra,800054b6 <uartputc_sync>
}
    80004ee8:	60a2                	ld	ra,8(sp)
    80004eea:	6402                	ld	s0,0(sp)
    80004eec:	0141                	addi	sp,sp,16
    80004eee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004ef0:	4521                	li	a0,8
    80004ef2:	5c4000ef          	jal	ra,800054b6 <uartputc_sync>
    80004ef6:	02000513          	li	a0,32
    80004efa:	5bc000ef          	jal	ra,800054b6 <uartputc_sync>
    80004efe:	4521                	li	a0,8
    80004f00:	5b6000ef          	jal	ra,800054b6 <uartputc_sync>
    80004f04:	b7d5                	j	80004ee8 <consputc+0x14>

0000000080004f06 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004f06:	1101                	addi	sp,sp,-32
    80004f08:	ec06                	sd	ra,24(sp)
    80004f0a:	e822                	sd	s0,16(sp)
    80004f0c:	e426                	sd	s1,8(sp)
    80004f0e:	e04a                	sd	s2,0(sp)
    80004f10:	1000                	addi	s0,sp,32
    80004f12:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004f14:	00017517          	auipc	a0,0x17
    80004f18:	03c50513          	addi	a0,a0,60 # 8001bf50 <cons>
    80004f1c:	7f6000ef          	jal	ra,80005712 <acquire>

  switch(c){
    80004f20:	47d5                	li	a5,21
    80004f22:	0af48063          	beq	s1,a5,80004fc2 <consoleintr+0xbc>
    80004f26:	0297c663          	blt	a5,s1,80004f52 <consoleintr+0x4c>
    80004f2a:	47a1                	li	a5,8
    80004f2c:	0cf48f63          	beq	s1,a5,8000500a <consoleintr+0x104>
    80004f30:	47c1                	li	a5,16
    80004f32:	10f49063          	bne	s1,a5,80005032 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80004f36:	f94fc0ef          	jal	ra,800016ca <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004f3a:	00017517          	auipc	a0,0x17
    80004f3e:	01650513          	addi	a0,a0,22 # 8001bf50 <cons>
    80004f42:	069000ef          	jal	ra,800057aa <release>
}
    80004f46:	60e2                	ld	ra,24(sp)
    80004f48:	6442                	ld	s0,16(sp)
    80004f4a:	64a2                	ld	s1,8(sp)
    80004f4c:	6902                	ld	s2,0(sp)
    80004f4e:	6105                	addi	sp,sp,32
    80004f50:	8082                	ret
  switch(c){
    80004f52:	07f00793          	li	a5,127
    80004f56:	0af48a63          	beq	s1,a5,8000500a <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004f5a:	00017717          	auipc	a4,0x17
    80004f5e:	ff670713          	addi	a4,a4,-10 # 8001bf50 <cons>
    80004f62:	0a072783          	lw	a5,160(a4)
    80004f66:	09872703          	lw	a4,152(a4)
    80004f6a:	9f99                	subw	a5,a5,a4
    80004f6c:	07f00713          	li	a4,127
    80004f70:	fcf765e3          	bltu	a4,a5,80004f3a <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80004f74:	47b5                	li	a5,13
    80004f76:	0cf48163          	beq	s1,a5,80005038 <consoleintr+0x132>
      consputc(c);
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	f59ff0ef          	jal	ra,80004ed4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004f80:	00017797          	auipc	a5,0x17
    80004f84:	fd078793          	addi	a5,a5,-48 # 8001bf50 <cons>
    80004f88:	0a07a683          	lw	a3,160(a5)
    80004f8c:	0016871b          	addiw	a4,a3,1
    80004f90:	0007061b          	sext.w	a2,a4
    80004f94:	0ae7a023          	sw	a4,160(a5)
    80004f98:	07f6f693          	andi	a3,a3,127
    80004f9c:	97b6                	add	a5,a5,a3
    80004f9e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004fa2:	47a9                	li	a5,10
    80004fa4:	0af48f63          	beq	s1,a5,80005062 <consoleintr+0x15c>
    80004fa8:	4791                	li	a5,4
    80004faa:	0af48c63          	beq	s1,a5,80005062 <consoleintr+0x15c>
    80004fae:	00017797          	auipc	a5,0x17
    80004fb2:	03a7a783          	lw	a5,58(a5) # 8001bfe8 <cons+0x98>
    80004fb6:	9f1d                	subw	a4,a4,a5
    80004fb8:	08000793          	li	a5,128
    80004fbc:	f6f71fe3          	bne	a4,a5,80004f3a <consoleintr+0x34>
    80004fc0:	a04d                	j	80005062 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80004fc2:	00017717          	auipc	a4,0x17
    80004fc6:	f8e70713          	addi	a4,a4,-114 # 8001bf50 <cons>
    80004fca:	0a072783          	lw	a5,160(a4)
    80004fce:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fd2:	00017497          	auipc	s1,0x17
    80004fd6:	f7e48493          	addi	s1,s1,-130 # 8001bf50 <cons>
    while(cons.e != cons.w &&
    80004fda:	4929                	li	s2,10
    80004fdc:	f4f70fe3          	beq	a4,a5,80004f3a <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004fe0:	37fd                	addiw	a5,a5,-1
    80004fe2:	07f7f713          	andi	a4,a5,127
    80004fe6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004fe8:	01874703          	lbu	a4,24(a4)
    80004fec:	f52707e3          	beq	a4,s2,80004f3a <consoleintr+0x34>
      cons.e--;
    80004ff0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004ff4:	10000513          	li	a0,256
    80004ff8:	eddff0ef          	jal	ra,80004ed4 <consputc>
    while(cons.e != cons.w &&
    80004ffc:	0a04a783          	lw	a5,160(s1)
    80005000:	09c4a703          	lw	a4,156(s1)
    80005004:	fcf71ee3          	bne	a4,a5,80004fe0 <consoleintr+0xda>
    80005008:	bf0d                	j	80004f3a <consoleintr+0x34>
    if(cons.e != cons.w){
    8000500a:	00017717          	auipc	a4,0x17
    8000500e:	f4670713          	addi	a4,a4,-186 # 8001bf50 <cons>
    80005012:	0a072783          	lw	a5,160(a4)
    80005016:	09c72703          	lw	a4,156(a4)
    8000501a:	f2f700e3          	beq	a4,a5,80004f3a <consoleintr+0x34>
      cons.e--;
    8000501e:	37fd                	addiw	a5,a5,-1
    80005020:	00017717          	auipc	a4,0x17
    80005024:	fcf72823          	sw	a5,-48(a4) # 8001bff0 <cons+0xa0>
      consputc(BACKSPACE);
    80005028:	10000513          	li	a0,256
    8000502c:	ea9ff0ef          	jal	ra,80004ed4 <consputc>
    80005030:	b729                	j	80004f3a <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005032:	f00484e3          	beqz	s1,80004f3a <consoleintr+0x34>
    80005036:	b715                	j	80004f5a <consoleintr+0x54>
      consputc(c);
    80005038:	4529                	li	a0,10
    8000503a:	e9bff0ef          	jal	ra,80004ed4 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000503e:	00017797          	auipc	a5,0x17
    80005042:	f1278793          	addi	a5,a5,-238 # 8001bf50 <cons>
    80005046:	0a07a703          	lw	a4,160(a5)
    8000504a:	0017069b          	addiw	a3,a4,1
    8000504e:	0006861b          	sext.w	a2,a3
    80005052:	0ad7a023          	sw	a3,160(a5)
    80005056:	07f77713          	andi	a4,a4,127
    8000505a:	97ba                	add	a5,a5,a4
    8000505c:	4729                	li	a4,10
    8000505e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005062:	00017797          	auipc	a5,0x17
    80005066:	f8c7a523          	sw	a2,-118(a5) # 8001bfec <cons+0x9c>
        wakeup(&cons.r);
    8000506a:	00017517          	auipc	a0,0x17
    8000506e:	f7e50513          	addi	a0,a0,-130 # 8001bfe8 <cons+0x98>
    80005072:	ab4fc0ef          	jal	ra,80001326 <wakeup>
    80005076:	b5d1                	j	80004f3a <consoleintr+0x34>

0000000080005078 <consoleinit>:

void
consoleinit(void)
{
    80005078:	1141                	addi	sp,sp,-16
    8000507a:	e406                	sd	ra,8(sp)
    8000507c:	e022                	sd	s0,0(sp)
    8000507e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005080:	00002597          	auipc	a1,0x2
    80005084:	77858593          	addi	a1,a1,1912 # 800077f8 <syscalls+0x3e0>
    80005088:	00017517          	auipc	a0,0x17
    8000508c:	ec850513          	addi	a0,a0,-312 # 8001bf50 <cons>
    80005090:	602000ef          	jal	ra,80005692 <initlock>

  uartinit();
    80005094:	3d6000ef          	jal	ra,8000546a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005098:	0000e797          	auipc	a5,0xe
    8000509c:	d2078793          	addi	a5,a5,-736 # 80012db8 <devsw>
    800050a0:	00000717          	auipc	a4,0x0
    800050a4:	d3870713          	addi	a4,a4,-712 # 80004dd8 <consoleread>
    800050a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800050aa:	00000717          	auipc	a4,0x0
    800050ae:	cd270713          	addi	a4,a4,-814 # 80004d7c <consolewrite>
    800050b2:	ef98                	sd	a4,24(a5)
}
    800050b4:	60a2                	ld	ra,8(sp)
    800050b6:	6402                	ld	s0,0(sp)
    800050b8:	0141                	addi	sp,sp,16
    800050ba:	8082                	ret

00000000800050bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800050bc:	7179                	addi	sp,sp,-48
    800050be:	f406                	sd	ra,40(sp)
    800050c0:	f022                	sd	s0,32(sp)
    800050c2:	ec26                	sd	s1,24(sp)
    800050c4:	e84a                	sd	s2,16(sp)
    800050c6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800050c8:	c219                	beqz	a2,800050ce <printint+0x12>
    800050ca:	06054e63          	bltz	a0,80005146 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800050ce:	4881                	li	a7,0
    800050d0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800050d4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800050d6:	00002617          	auipc	a2,0x2
    800050da:	74a60613          	addi	a2,a2,1866 # 80007820 <digits>
    800050de:	883e                	mv	a6,a5
    800050e0:	2785                	addiw	a5,a5,1
    800050e2:	02b57733          	remu	a4,a0,a1
    800050e6:	9732                	add	a4,a4,a2
    800050e8:	00074703          	lbu	a4,0(a4)
    800050ec:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800050f0:	872a                	mv	a4,a0
    800050f2:	02b55533          	divu	a0,a0,a1
    800050f6:	0685                	addi	a3,a3,1
    800050f8:	feb773e3          	bgeu	a4,a1,800050de <printint+0x22>

  if(sign)
    800050fc:	00088a63          	beqz	a7,80005110 <printint+0x54>
    buf[i++] = '-';
    80005100:	1781                	addi	a5,a5,-32
    80005102:	97a2                	add	a5,a5,s0
    80005104:	02d00713          	li	a4,45
    80005108:	fee78823          	sb	a4,-16(a5)
    8000510c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80005110:	02f05563          	blez	a5,8000513a <printint+0x7e>
    80005114:	fd040713          	addi	a4,s0,-48
    80005118:	00f704b3          	add	s1,a4,a5
    8000511c:	fff70913          	addi	s2,a4,-1
    80005120:	993e                	add	s2,s2,a5
    80005122:	37fd                	addiw	a5,a5,-1
    80005124:	1782                	slli	a5,a5,0x20
    80005126:	9381                	srli	a5,a5,0x20
    80005128:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000512c:	fff4c503          	lbu	a0,-1(s1)
    80005130:	da5ff0ef          	jal	ra,80004ed4 <consputc>
  while(--i >= 0)
    80005134:	14fd                	addi	s1,s1,-1
    80005136:	ff249be3          	bne	s1,s2,8000512c <printint+0x70>
}
    8000513a:	70a2                	ld	ra,40(sp)
    8000513c:	7402                	ld	s0,32(sp)
    8000513e:	64e2                	ld	s1,24(sp)
    80005140:	6942                	ld	s2,16(sp)
    80005142:	6145                	addi	sp,sp,48
    80005144:	8082                	ret
    x = -xx;
    80005146:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000514a:	4885                	li	a7,1
    x = -xx;
    8000514c:	b751                	j	800050d0 <printint+0x14>

000000008000514e <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000514e:	7155                	addi	sp,sp,-208
    80005150:	e506                	sd	ra,136(sp)
    80005152:	e122                	sd	s0,128(sp)
    80005154:	fca6                	sd	s1,120(sp)
    80005156:	f8ca                	sd	s2,112(sp)
    80005158:	f4ce                	sd	s3,104(sp)
    8000515a:	f0d2                	sd	s4,96(sp)
    8000515c:	ecd6                	sd	s5,88(sp)
    8000515e:	e8da                	sd	s6,80(sp)
    80005160:	e4de                	sd	s7,72(sp)
    80005162:	e0e2                	sd	s8,64(sp)
    80005164:	fc66                	sd	s9,56(sp)
    80005166:	f86a                	sd	s10,48(sp)
    80005168:	f46e                	sd	s11,40(sp)
    8000516a:	0900                	addi	s0,sp,144
    8000516c:	8a2a                	mv	s4,a0
    8000516e:	e40c                	sd	a1,8(s0)
    80005170:	e810                	sd	a2,16(s0)
    80005172:	ec14                	sd	a3,24(s0)
    80005174:	f018                	sd	a4,32(s0)
    80005176:	f41c                	sd	a5,40(s0)
    80005178:	03043823          	sd	a6,48(s0)
    8000517c:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005180:	00017797          	auipc	a5,0x17
    80005184:	e907a783          	lw	a5,-368(a5) # 8001c010 <pr+0x18>
    80005188:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000518c:	eb9d                	bnez	a5,800051c2 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000518e:	00840793          	addi	a5,s0,8
    80005192:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005196:	00054503          	lbu	a0,0(a0)
    8000519a:	24050463          	beqz	a0,800053e2 <printf+0x294>
    8000519e:	4981                	li	s3,0
    if(cx != '%'){
    800051a0:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800051a4:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800051a8:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800051ac:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800051b0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800051b4:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800051b8:	00002b97          	auipc	s7,0x2
    800051bc:	668b8b93          	addi	s7,s7,1640 # 80007820 <digits>
    800051c0:	a081                	j	80005200 <printf+0xb2>
    acquire(&pr.lock);
    800051c2:	00017517          	auipc	a0,0x17
    800051c6:	e3650513          	addi	a0,a0,-458 # 8001bff8 <pr>
    800051ca:	548000ef          	jal	ra,80005712 <acquire>
  va_start(ap, fmt);
    800051ce:	00840793          	addi	a5,s0,8
    800051d2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051d6:	000a4503          	lbu	a0,0(s4)
    800051da:	f171                	bnez	a0,8000519e <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    800051dc:	00017517          	auipc	a0,0x17
    800051e0:	e1c50513          	addi	a0,a0,-484 # 8001bff8 <pr>
    800051e4:	5c6000ef          	jal	ra,800057aa <release>
    800051e8:	aaed                	j	800053e2 <printf+0x294>
      consputc(cx);
    800051ea:	cebff0ef          	jal	ra,80004ed4 <consputc>
      continue;
    800051ee:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800051f0:	0014899b          	addiw	s3,s1,1
    800051f4:	013a07b3          	add	a5,s4,s3
    800051f8:	0007c503          	lbu	a0,0(a5)
    800051fc:	1c050f63          	beqz	a0,800053da <printf+0x28c>
    if(cx != '%'){
    80005200:	ff5515e3          	bne	a0,s5,800051ea <printf+0x9c>
    i++;
    80005204:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005208:	009a07b3          	add	a5,s4,s1
    8000520c:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005210:	1c090563          	beqz	s2,800053da <printf+0x28c>
    80005214:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005218:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000521a:	c789                	beqz	a5,80005224 <printf+0xd6>
    8000521c:	009a0733          	add	a4,s4,s1
    80005220:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005224:	03690463          	beq	s2,s6,8000524c <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    80005228:	03890e63          	beq	s2,s8,80005264 <printf+0x116>
    } else if(c0 == 'u'){
    8000522c:	0b990d63          	beq	s2,s9,800052e6 <printf+0x198>
    } else if(c0 == 'x'){
    80005230:	11a90363          	beq	s2,s10,80005336 <printf+0x1e8>
    } else if(c0 == 'p'){
    80005234:	13b90b63          	beq	s2,s11,8000536a <printf+0x21c>
    } else if(c0 == 's'){
    80005238:	07300793          	li	a5,115
    8000523c:	16f90363          	beq	s2,a5,800053a2 <printf+0x254>
    } else if(c0 == '%'){
    80005240:	03591c63          	bne	s2,s5,80005278 <printf+0x12a>
      consputc('%');
    80005244:	8556                	mv	a0,s5
    80005246:	c8fff0ef          	jal	ra,80004ed4 <consputc>
    8000524a:	b75d                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    8000524c:	f8843783          	ld	a5,-120(s0)
    80005250:	00878713          	addi	a4,a5,8
    80005254:	f8e43423          	sd	a4,-120(s0)
    80005258:	4605                	li	a2,1
    8000525a:	45a9                	li	a1,10
    8000525c:	4388                	lw	a0,0(a5)
    8000525e:	e5fff0ef          	jal	ra,800050bc <printint>
    80005262:	b779                	j	800051f0 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    80005264:	03678163          	beq	a5,s6,80005286 <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005268:	03878d63          	beq	a5,s8,800052a2 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    8000526c:	09978963          	beq	a5,s9,800052fe <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005270:	03878b63          	beq	a5,s8,800052a6 <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    80005274:	0da78d63          	beq	a5,s10,8000534e <printf+0x200>
      consputc('%');
    80005278:	8556                	mv	a0,s5
    8000527a:	c5bff0ef          	jal	ra,80004ed4 <consputc>
      consputc(c0);
    8000527e:	854a                	mv	a0,s2
    80005280:	c55ff0ef          	jal	ra,80004ed4 <consputc>
    80005284:	b7b5                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    80005286:	f8843783          	ld	a5,-120(s0)
    8000528a:	00878713          	addi	a4,a5,8
    8000528e:	f8e43423          	sd	a4,-120(s0)
    80005292:	4605                	li	a2,1
    80005294:	45a9                	li	a1,10
    80005296:	6388                	ld	a0,0(a5)
    80005298:	e25ff0ef          	jal	ra,800050bc <printint>
      i += 1;
    8000529c:	0029849b          	addiw	s1,s3,2
    800052a0:	bf81                	j	800051f0 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800052a2:	03668463          	beq	a3,s6,800052ca <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800052a6:	07968a63          	beq	a3,s9,8000531a <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800052aa:	fda697e3          	bne	a3,s10,80005278 <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    800052ae:	f8843783          	ld	a5,-120(s0)
    800052b2:	00878713          	addi	a4,a5,8
    800052b6:	f8e43423          	sd	a4,-120(s0)
    800052ba:	4601                	li	a2,0
    800052bc:	45c1                	li	a1,16
    800052be:	6388                	ld	a0,0(a5)
    800052c0:	dfdff0ef          	jal	ra,800050bc <printint>
      i += 2;
    800052c4:	0039849b          	addiw	s1,s3,3
    800052c8:	b725                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800052ca:	f8843783          	ld	a5,-120(s0)
    800052ce:	00878713          	addi	a4,a5,8
    800052d2:	f8e43423          	sd	a4,-120(s0)
    800052d6:	4605                	li	a2,1
    800052d8:	45a9                	li	a1,10
    800052da:	6388                	ld	a0,0(a5)
    800052dc:	de1ff0ef          	jal	ra,800050bc <printint>
      i += 2;
    800052e0:	0039849b          	addiw	s1,s3,3
    800052e4:	b731                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    800052e6:	f8843783          	ld	a5,-120(s0)
    800052ea:	00878713          	addi	a4,a5,8
    800052ee:	f8e43423          	sd	a4,-120(s0)
    800052f2:	4601                	li	a2,0
    800052f4:	45a9                	li	a1,10
    800052f6:	4388                	lw	a0,0(a5)
    800052f8:	dc5ff0ef          	jal	ra,800050bc <printint>
    800052fc:	bdd5                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    800052fe:	f8843783          	ld	a5,-120(s0)
    80005302:	00878713          	addi	a4,a5,8
    80005306:	f8e43423          	sd	a4,-120(s0)
    8000530a:	4601                	li	a2,0
    8000530c:	45a9                	li	a1,10
    8000530e:	6388                	ld	a0,0(a5)
    80005310:	dadff0ef          	jal	ra,800050bc <printint>
      i += 1;
    80005314:	0029849b          	addiw	s1,s3,2
    80005318:	bde1                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000531a:	f8843783          	ld	a5,-120(s0)
    8000531e:	00878713          	addi	a4,a5,8
    80005322:	f8e43423          	sd	a4,-120(s0)
    80005326:	4601                	li	a2,0
    80005328:	45a9                	li	a1,10
    8000532a:	6388                	ld	a0,0(a5)
    8000532c:	d91ff0ef          	jal	ra,800050bc <printint>
      i += 2;
    80005330:	0039849b          	addiw	s1,s3,3
    80005334:	bd75                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    80005336:	f8843783          	ld	a5,-120(s0)
    8000533a:	00878713          	addi	a4,a5,8
    8000533e:	f8e43423          	sd	a4,-120(s0)
    80005342:	4601                	li	a2,0
    80005344:	45c1                	li	a1,16
    80005346:	4388                	lw	a0,0(a5)
    80005348:	d75ff0ef          	jal	ra,800050bc <printint>
    8000534c:	b555                	j	800051f0 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    8000534e:	f8843783          	ld	a5,-120(s0)
    80005352:	00878713          	addi	a4,a5,8
    80005356:	f8e43423          	sd	a4,-120(s0)
    8000535a:	4601                	li	a2,0
    8000535c:	45c1                	li	a1,16
    8000535e:	6388                	ld	a0,0(a5)
    80005360:	d5dff0ef          	jal	ra,800050bc <printint>
      i += 1;
    80005364:	0029849b          	addiw	s1,s3,2
    80005368:	b561                	j	800051f0 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    8000536a:	f8843783          	ld	a5,-120(s0)
    8000536e:	00878713          	addi	a4,a5,8
    80005372:	f8e43423          	sd	a4,-120(s0)
    80005376:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000537a:	03000513          	li	a0,48
    8000537e:	b57ff0ef          	jal	ra,80004ed4 <consputc>
  consputc('x');
    80005382:	856a                	mv	a0,s10
    80005384:	b51ff0ef          	jal	ra,80004ed4 <consputc>
    80005388:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000538a:	03c9d793          	srli	a5,s3,0x3c
    8000538e:	97de                	add	a5,a5,s7
    80005390:	0007c503          	lbu	a0,0(a5)
    80005394:	b41ff0ef          	jal	ra,80004ed4 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005398:	0992                	slli	s3,s3,0x4
    8000539a:	397d                	addiw	s2,s2,-1
    8000539c:	fe0917e3          	bnez	s2,8000538a <printf+0x23c>
    800053a0:	bd81                	j	800051f0 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800053a2:	f8843783          	ld	a5,-120(s0)
    800053a6:	00878713          	addi	a4,a5,8
    800053aa:	f8e43423          	sd	a4,-120(s0)
    800053ae:	0007b903          	ld	s2,0(a5)
    800053b2:	00090d63          	beqz	s2,800053cc <printf+0x27e>
      for(; *s; s++)
    800053b6:	00094503          	lbu	a0,0(s2)
    800053ba:	e2050be3          	beqz	a0,800051f0 <printf+0xa2>
        consputc(*s);
    800053be:	b17ff0ef          	jal	ra,80004ed4 <consputc>
      for(; *s; s++)
    800053c2:	0905                	addi	s2,s2,1
    800053c4:	00094503          	lbu	a0,0(s2)
    800053c8:	f97d                	bnez	a0,800053be <printf+0x270>
    800053ca:	b51d                	j	800051f0 <printf+0xa2>
        s = "(null)";
    800053cc:	00002917          	auipc	s2,0x2
    800053d0:	43490913          	addi	s2,s2,1076 # 80007800 <syscalls+0x3e8>
      for(; *s; s++)
    800053d4:	02800513          	li	a0,40
    800053d8:	b7dd                	j	800053be <printf+0x270>
  if(locking)
    800053da:	f7843783          	ld	a5,-136(s0)
    800053de:	de079fe3          	bnez	a5,800051dc <printf+0x8e>

  return 0;
}
    800053e2:	4501                	li	a0,0
    800053e4:	60aa                	ld	ra,136(sp)
    800053e6:	640a                	ld	s0,128(sp)
    800053e8:	74e6                	ld	s1,120(sp)
    800053ea:	7946                	ld	s2,112(sp)
    800053ec:	79a6                	ld	s3,104(sp)
    800053ee:	7a06                	ld	s4,96(sp)
    800053f0:	6ae6                	ld	s5,88(sp)
    800053f2:	6b46                	ld	s6,80(sp)
    800053f4:	6ba6                	ld	s7,72(sp)
    800053f6:	6c06                	ld	s8,64(sp)
    800053f8:	7ce2                	ld	s9,56(sp)
    800053fa:	7d42                	ld	s10,48(sp)
    800053fc:	7da2                	ld	s11,40(sp)
    800053fe:	6169                	addi	sp,sp,208
    80005400:	8082                	ret

0000000080005402 <panic>:

void
panic(char *s)
{
    80005402:	1101                	addi	sp,sp,-32
    80005404:	ec06                	sd	ra,24(sp)
    80005406:	e822                	sd	s0,16(sp)
    80005408:	e426                	sd	s1,8(sp)
    8000540a:	1000                	addi	s0,sp,32
    8000540c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000540e:	00017797          	auipc	a5,0x17
    80005412:	c007a123          	sw	zero,-1022(a5) # 8001c010 <pr+0x18>
  printf("panic: ");
    80005416:	00002517          	auipc	a0,0x2
    8000541a:	3f250513          	addi	a0,a0,1010 # 80007808 <syscalls+0x3f0>
    8000541e:	d31ff0ef          	jal	ra,8000514e <printf>
  printf("%s\n", s);
    80005422:	85a6                	mv	a1,s1
    80005424:	00002517          	auipc	a0,0x2
    80005428:	3ec50513          	addi	a0,a0,1004 # 80007810 <syscalls+0x3f8>
    8000542c:	d23ff0ef          	jal	ra,8000514e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005430:	4785                	li	a5,1
    80005432:	00002717          	auipc	a4,0x2
    80005436:	4cf72523          	sw	a5,1226(a4) # 800078fc <panicked>
  for(;;)
    8000543a:	a001                	j	8000543a <panic+0x38>

000000008000543c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000543c:	1101                	addi	sp,sp,-32
    8000543e:	ec06                	sd	ra,24(sp)
    80005440:	e822                	sd	s0,16(sp)
    80005442:	e426                	sd	s1,8(sp)
    80005444:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005446:	00017497          	auipc	s1,0x17
    8000544a:	bb248493          	addi	s1,s1,-1102 # 8001bff8 <pr>
    8000544e:	00002597          	auipc	a1,0x2
    80005452:	3ca58593          	addi	a1,a1,970 # 80007818 <syscalls+0x400>
    80005456:	8526                	mv	a0,s1
    80005458:	23a000ef          	jal	ra,80005692 <initlock>
  pr.locking = 1;
    8000545c:	4785                	li	a5,1
    8000545e:	cc9c                	sw	a5,24(s1)
}
    80005460:	60e2                	ld	ra,24(sp)
    80005462:	6442                	ld	s0,16(sp)
    80005464:	64a2                	ld	s1,8(sp)
    80005466:	6105                	addi	sp,sp,32
    80005468:	8082                	ret

000000008000546a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000546a:	1141                	addi	sp,sp,-16
    8000546c:	e406                	sd	ra,8(sp)
    8000546e:	e022                	sd	s0,0(sp)
    80005470:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005472:	100007b7          	lui	a5,0x10000
    80005476:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000547a:	f8000713          	li	a4,-128
    8000547e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005482:	470d                	li	a4,3
    80005484:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005488:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000548c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005490:	469d                	li	a3,7
    80005492:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005496:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000549a:	00002597          	auipc	a1,0x2
    8000549e:	39e58593          	addi	a1,a1,926 # 80007838 <digits+0x18>
    800054a2:	00017517          	auipc	a0,0x17
    800054a6:	b7650513          	addi	a0,a0,-1162 # 8001c018 <uart_tx_lock>
    800054aa:	1e8000ef          	jal	ra,80005692 <initlock>
}
    800054ae:	60a2                	ld	ra,8(sp)
    800054b0:	6402                	ld	s0,0(sp)
    800054b2:	0141                	addi	sp,sp,16
    800054b4:	8082                	ret

00000000800054b6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800054b6:	1101                	addi	sp,sp,-32
    800054b8:	ec06                	sd	ra,24(sp)
    800054ba:	e822                	sd	s0,16(sp)
    800054bc:	e426                	sd	s1,8(sp)
    800054be:	1000                	addi	s0,sp,32
    800054c0:	84aa                	mv	s1,a0
  push_off();
    800054c2:	210000ef          	jal	ra,800056d2 <push_off>

  if(panicked){
    800054c6:	00002797          	auipc	a5,0x2
    800054ca:	4367a783          	lw	a5,1078(a5) # 800078fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054ce:	10000737          	lui	a4,0x10000
  if(panicked){
    800054d2:	c391                	beqz	a5,800054d6 <uartputc_sync+0x20>
    for(;;)
    800054d4:	a001                	j	800054d4 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800054d6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800054da:	0207f793          	andi	a5,a5,32
    800054de:	dfe5                	beqz	a5,800054d6 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800054e0:	0ff4f513          	zext.b	a0,s1
    800054e4:	100007b7          	lui	a5,0x10000
    800054e8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800054ec:	26a000ef          	jal	ra,80005756 <pop_off>
}
    800054f0:	60e2                	ld	ra,24(sp)
    800054f2:	6442                	ld	s0,16(sp)
    800054f4:	64a2                	ld	s1,8(sp)
    800054f6:	6105                	addi	sp,sp,32
    800054f8:	8082                	ret

00000000800054fa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800054fa:	00002797          	auipc	a5,0x2
    800054fe:	4067b783          	ld	a5,1030(a5) # 80007900 <uart_tx_r>
    80005502:	00002717          	auipc	a4,0x2
    80005506:	40673703          	ld	a4,1030(a4) # 80007908 <uart_tx_w>
    8000550a:	06f70c63          	beq	a4,a5,80005582 <uartstart+0x88>
{
    8000550e:	7139                	addi	sp,sp,-64
    80005510:	fc06                	sd	ra,56(sp)
    80005512:	f822                	sd	s0,48(sp)
    80005514:	f426                	sd	s1,40(sp)
    80005516:	f04a                	sd	s2,32(sp)
    80005518:	ec4e                	sd	s3,24(sp)
    8000551a:	e852                	sd	s4,16(sp)
    8000551c:	e456                	sd	s5,8(sp)
    8000551e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005520:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005524:	00017a17          	auipc	s4,0x17
    80005528:	af4a0a13          	addi	s4,s4,-1292 # 8001c018 <uart_tx_lock>
    uart_tx_r += 1;
    8000552c:	00002497          	auipc	s1,0x2
    80005530:	3d448493          	addi	s1,s1,980 # 80007900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005534:	00002997          	auipc	s3,0x2
    80005538:	3d498993          	addi	s3,s3,980 # 80007908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000553c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005540:	02077713          	andi	a4,a4,32
    80005544:	c715                	beqz	a4,80005570 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005546:	01f7f713          	andi	a4,a5,31
    8000554a:	9752                	add	a4,a4,s4
    8000554c:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005550:	0785                	addi	a5,a5,1
    80005552:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005554:	8526                	mv	a0,s1
    80005556:	dd1fb0ef          	jal	ra,80001326 <wakeup>
    
    WriteReg(THR, c);
    8000555a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000555e:	609c                	ld	a5,0(s1)
    80005560:	0009b703          	ld	a4,0(s3)
    80005564:	fcf71ce3          	bne	a4,a5,8000553c <uartstart+0x42>
      ReadReg(ISR);
    80005568:	100007b7          	lui	a5,0x10000
    8000556c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005570:	70e2                	ld	ra,56(sp)
    80005572:	7442                	ld	s0,48(sp)
    80005574:	74a2                	ld	s1,40(sp)
    80005576:	7902                	ld	s2,32(sp)
    80005578:	69e2                	ld	s3,24(sp)
    8000557a:	6a42                	ld	s4,16(sp)
    8000557c:	6aa2                	ld	s5,8(sp)
    8000557e:	6121                	addi	sp,sp,64
    80005580:	8082                	ret
      ReadReg(ISR);
    80005582:	100007b7          	lui	a5,0x10000
    80005586:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    8000558a:	8082                	ret

000000008000558c <uartputc>:
{
    8000558c:	7179                	addi	sp,sp,-48
    8000558e:	f406                	sd	ra,40(sp)
    80005590:	f022                	sd	s0,32(sp)
    80005592:	ec26                	sd	s1,24(sp)
    80005594:	e84a                	sd	s2,16(sp)
    80005596:	e44e                	sd	s3,8(sp)
    80005598:	e052                	sd	s4,0(sp)
    8000559a:	1800                	addi	s0,sp,48
    8000559c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000559e:	00017517          	auipc	a0,0x17
    800055a2:	a7a50513          	addi	a0,a0,-1414 # 8001c018 <uart_tx_lock>
    800055a6:	16c000ef          	jal	ra,80005712 <acquire>
  if(panicked){
    800055aa:	00002797          	auipc	a5,0x2
    800055ae:	3527a783          	lw	a5,850(a5) # 800078fc <panicked>
    800055b2:	efbd                	bnez	a5,80005630 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055b4:	00002717          	auipc	a4,0x2
    800055b8:	35473703          	ld	a4,852(a4) # 80007908 <uart_tx_w>
    800055bc:	00002797          	auipc	a5,0x2
    800055c0:	3447b783          	ld	a5,836(a5) # 80007900 <uart_tx_r>
    800055c4:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800055c8:	00017997          	auipc	s3,0x17
    800055cc:	a5098993          	addi	s3,s3,-1456 # 8001c018 <uart_tx_lock>
    800055d0:	00002497          	auipc	s1,0x2
    800055d4:	33048493          	addi	s1,s1,816 # 80007900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055d8:	00002917          	auipc	s2,0x2
    800055dc:	33090913          	addi	s2,s2,816 # 80007908 <uart_tx_w>
    800055e0:	00e79d63          	bne	a5,a4,800055fa <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800055e4:	85ce                	mv	a1,s3
    800055e6:	8526                	mv	a0,s1
    800055e8:	cf3fb0ef          	jal	ra,800012da <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800055ec:	00093703          	ld	a4,0(s2)
    800055f0:	609c                	ld	a5,0(s1)
    800055f2:	02078793          	addi	a5,a5,32
    800055f6:	fee787e3          	beq	a5,a4,800055e4 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800055fa:	00017497          	auipc	s1,0x17
    800055fe:	a1e48493          	addi	s1,s1,-1506 # 8001c018 <uart_tx_lock>
    80005602:	01f77793          	andi	a5,a4,31
    80005606:	97a6                	add	a5,a5,s1
    80005608:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000560c:	0705                	addi	a4,a4,1
    8000560e:	00002797          	auipc	a5,0x2
    80005612:	2ee7bd23          	sd	a4,762(a5) # 80007908 <uart_tx_w>
  uartstart();
    80005616:	ee5ff0ef          	jal	ra,800054fa <uartstart>
  release(&uart_tx_lock);
    8000561a:	8526                	mv	a0,s1
    8000561c:	18e000ef          	jal	ra,800057aa <release>
}
    80005620:	70a2                	ld	ra,40(sp)
    80005622:	7402                	ld	s0,32(sp)
    80005624:	64e2                	ld	s1,24(sp)
    80005626:	6942                	ld	s2,16(sp)
    80005628:	69a2                	ld	s3,8(sp)
    8000562a:	6a02                	ld	s4,0(sp)
    8000562c:	6145                	addi	sp,sp,48
    8000562e:	8082                	ret
    for(;;)
    80005630:	a001                	j	80005630 <uartputc+0xa4>

0000000080005632 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005632:	1141                	addi	sp,sp,-16
    80005634:	e422                	sd	s0,8(sp)
    80005636:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005638:	100007b7          	lui	a5,0x10000
    8000563c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005640:	8b85                	andi	a5,a5,1
    80005642:	cb81                	beqz	a5,80005652 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005644:	100007b7          	lui	a5,0x10000
    80005648:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000564c:	6422                	ld	s0,8(sp)
    8000564e:	0141                	addi	sp,sp,16
    80005650:	8082                	ret
    return -1;
    80005652:	557d                	li	a0,-1
    80005654:	bfe5                	j	8000564c <uartgetc+0x1a>

0000000080005656 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005656:	1101                	addi	sp,sp,-32
    80005658:	ec06                	sd	ra,24(sp)
    8000565a:	e822                	sd	s0,16(sp)
    8000565c:	e426                	sd	s1,8(sp)
    8000565e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005660:	54fd                	li	s1,-1
    80005662:	a019                	j	80005668 <uartintr+0x12>
      break;
    consoleintr(c);
    80005664:	8a3ff0ef          	jal	ra,80004f06 <consoleintr>
    int c = uartgetc();
    80005668:	fcbff0ef          	jal	ra,80005632 <uartgetc>
    if(c == -1)
    8000566c:	fe951ce3          	bne	a0,s1,80005664 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005670:	00017497          	auipc	s1,0x17
    80005674:	9a848493          	addi	s1,s1,-1624 # 8001c018 <uart_tx_lock>
    80005678:	8526                	mv	a0,s1
    8000567a:	098000ef          	jal	ra,80005712 <acquire>
  uartstart();
    8000567e:	e7dff0ef          	jal	ra,800054fa <uartstart>
  release(&uart_tx_lock);
    80005682:	8526                	mv	a0,s1
    80005684:	126000ef          	jal	ra,800057aa <release>
}
    80005688:	60e2                	ld	ra,24(sp)
    8000568a:	6442                	ld	s0,16(sp)
    8000568c:	64a2                	ld	s1,8(sp)
    8000568e:	6105                	addi	sp,sp,32
    80005690:	8082                	ret

0000000080005692 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005692:	1141                	addi	sp,sp,-16
    80005694:	e422                	sd	s0,8(sp)
    80005696:	0800                	addi	s0,sp,16
  lk->name = name;
    80005698:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000569a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000569e:	00053823          	sd	zero,16(a0)
}
    800056a2:	6422                	ld	s0,8(sp)
    800056a4:	0141                	addi	sp,sp,16
    800056a6:	8082                	ret

00000000800056a8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800056a8:	411c                	lw	a5,0(a0)
    800056aa:	e399                	bnez	a5,800056b0 <holding+0x8>
    800056ac:	4501                	li	a0,0
  return r;
}
    800056ae:	8082                	ret
{
    800056b0:	1101                	addi	sp,sp,-32
    800056b2:	ec06                	sd	ra,24(sp)
    800056b4:	e822                	sd	s0,16(sp)
    800056b6:	e426                	sd	s1,8(sp)
    800056b8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800056ba:	6904                	ld	s1,16(a0)
    800056bc:	e34fb0ef          	jal	ra,80000cf0 <mycpu>
    800056c0:	40a48533          	sub	a0,s1,a0
    800056c4:	00153513          	seqz	a0,a0
}
    800056c8:	60e2                	ld	ra,24(sp)
    800056ca:	6442                	ld	s0,16(sp)
    800056cc:	64a2                	ld	s1,8(sp)
    800056ce:	6105                	addi	sp,sp,32
    800056d0:	8082                	ret

00000000800056d2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800056d2:	1101                	addi	sp,sp,-32
    800056d4:	ec06                	sd	ra,24(sp)
    800056d6:	e822                	sd	s0,16(sp)
    800056d8:	e426                	sd	s1,8(sp)
    800056da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800056dc:	100024f3          	csrr	s1,sstatus
    800056e0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800056e4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800056e6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800056ea:	e06fb0ef          	jal	ra,80000cf0 <mycpu>
    800056ee:	5d3c                	lw	a5,120(a0)
    800056f0:	cb99                	beqz	a5,80005706 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800056f2:	dfefb0ef          	jal	ra,80000cf0 <mycpu>
    800056f6:	5d3c                	lw	a5,120(a0)
    800056f8:	2785                	addiw	a5,a5,1
    800056fa:	dd3c                	sw	a5,120(a0)
}
    800056fc:	60e2                	ld	ra,24(sp)
    800056fe:	6442                	ld	s0,16(sp)
    80005700:	64a2                	ld	s1,8(sp)
    80005702:	6105                	addi	sp,sp,32
    80005704:	8082                	ret
    mycpu()->intena = old;
    80005706:	deafb0ef          	jal	ra,80000cf0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000570a:	8085                	srli	s1,s1,0x1
    8000570c:	8885                	andi	s1,s1,1
    8000570e:	dd64                	sw	s1,124(a0)
    80005710:	b7cd                	j	800056f2 <push_off+0x20>

0000000080005712 <acquire>:
{
    80005712:	1101                	addi	sp,sp,-32
    80005714:	ec06                	sd	ra,24(sp)
    80005716:	e822                	sd	s0,16(sp)
    80005718:	e426                	sd	s1,8(sp)
    8000571a:	1000                	addi	s0,sp,32
    8000571c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000571e:	fb5ff0ef          	jal	ra,800056d2 <push_off>
  if(holding(lk))
    80005722:	8526                	mv	a0,s1
    80005724:	f85ff0ef          	jal	ra,800056a8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005728:	4705                	li	a4,1
  if(holding(lk))
    8000572a:	e105                	bnez	a0,8000574a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000572c:	87ba                	mv	a5,a4
    8000572e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005732:	2781                	sext.w	a5,a5
    80005734:	ffe5                	bnez	a5,8000572c <acquire+0x1a>
  __sync_synchronize();
    80005736:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000573a:	db6fb0ef          	jal	ra,80000cf0 <mycpu>
    8000573e:	e888                	sd	a0,16(s1)
}
    80005740:	60e2                	ld	ra,24(sp)
    80005742:	6442                	ld	s0,16(sp)
    80005744:	64a2                	ld	s1,8(sp)
    80005746:	6105                	addi	sp,sp,32
    80005748:	8082                	ret
    panic("acquire");
    8000574a:	00002517          	auipc	a0,0x2
    8000574e:	0f650513          	addi	a0,a0,246 # 80007840 <digits+0x20>
    80005752:	cb1ff0ef          	jal	ra,80005402 <panic>

0000000080005756 <pop_off>:

void
pop_off(void)
{
    80005756:	1141                	addi	sp,sp,-16
    80005758:	e406                	sd	ra,8(sp)
    8000575a:	e022                	sd	s0,0(sp)
    8000575c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000575e:	d92fb0ef          	jal	ra,80000cf0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005762:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005766:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005768:	e78d                	bnez	a5,80005792 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000576a:	5d3c                	lw	a5,120(a0)
    8000576c:	02f05963          	blez	a5,8000579e <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005770:	37fd                	addiw	a5,a5,-1
    80005772:	0007871b          	sext.w	a4,a5
    80005776:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005778:	eb09                	bnez	a4,8000578a <pop_off+0x34>
    8000577a:	5d7c                	lw	a5,124(a0)
    8000577c:	c799                	beqz	a5,8000578a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000577e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005782:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005786:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000578a:	60a2                	ld	ra,8(sp)
    8000578c:	6402                	ld	s0,0(sp)
    8000578e:	0141                	addi	sp,sp,16
    80005790:	8082                	ret
    panic("pop_off - interruptible");
    80005792:	00002517          	auipc	a0,0x2
    80005796:	0b650513          	addi	a0,a0,182 # 80007848 <digits+0x28>
    8000579a:	c69ff0ef          	jal	ra,80005402 <panic>
    panic("pop_off");
    8000579e:	00002517          	auipc	a0,0x2
    800057a2:	0c250513          	addi	a0,a0,194 # 80007860 <digits+0x40>
    800057a6:	c5dff0ef          	jal	ra,80005402 <panic>

00000000800057aa <release>:
{
    800057aa:	1101                	addi	sp,sp,-32
    800057ac:	ec06                	sd	ra,24(sp)
    800057ae:	e822                	sd	s0,16(sp)
    800057b0:	e426                	sd	s1,8(sp)
    800057b2:	1000                	addi	s0,sp,32
    800057b4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800057b6:	ef3ff0ef          	jal	ra,800056a8 <holding>
    800057ba:	c105                	beqz	a0,800057da <release+0x30>
  lk->cpu = 0;
    800057bc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800057c0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800057c4:	0f50000f          	fence	iorw,ow
    800057c8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800057cc:	f8bff0ef          	jal	ra,80005756 <pop_off>
}
    800057d0:	60e2                	ld	ra,24(sp)
    800057d2:	6442                	ld	s0,16(sp)
    800057d4:	64a2                	ld	s1,8(sp)
    800057d6:	6105                	addi	sp,sp,32
    800057d8:	8082                	ret
    panic("release");
    800057da:	00002517          	auipc	a0,0x2
    800057de:	08e50513          	addi	a0,a0,142 # 80007868 <digits+0x48>
    800057e2:	c21ff0ef          	jal	ra,80005402 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
