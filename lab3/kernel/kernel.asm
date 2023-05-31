
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	103050ef          	jal	ra,80005918 <start>

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
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2b8080e7          	jalr	696(ra) # 80006312 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	358080e7          	jalr	856(ra) # 800063c6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d3e080e7          	jalr	-706(ra) # 80005dc8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	18e080e7          	jalr	398(ra) # 80006282 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	1e6080e7          	jalr	486(ra) # 80006312 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	282080e7          	jalr	642(ra) # 800063c6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	258080e7          	jalr	600(ra) # 800063c6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	c0c080e7          	jalr	-1012(ra) # 80000f3a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	bf0080e7          	jalr	-1040(ra) # 80000f3a <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ab6080e7          	jalr	-1354(ra) # 80005e12 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	8f4080e7          	jalr	-1804(ra) # 80001c60 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f2c080e7          	jalr	-212(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	1a2080e7          	jalr	418(ra) # 8000151e <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	956080e7          	jalr	-1706(ra) # 80005cda <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c6c080e7          	jalr	-916(ra) # 80005ff8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a76080e7          	jalr	-1418(ra) # 80005e12 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a66080e7          	jalr	-1434(ra) # 80005e12 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a56080e7          	jalr	-1450(ra) # 80005e12 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	ab0080e7          	jalr	-1360(ra) # 80000e8c <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	854080e7          	jalr	-1964(ra) # 80001c38 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	874080e7          	jalr	-1932(ra) # 80001c60 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e96080e7          	jalr	-362(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ea4080e7          	jalr	-348(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	068080e7          	jalr	104(ra) # 8000246c <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6f8080e7          	jalr	1784(ra) # 80002b04 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6a2080e7          	jalr	1698(ra) # 80003ab6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fa6080e7          	jalr	-90(ra) # 800053c2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ec8080e7          	jalr	-312(ra) # 800012ec <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	93a080e7          	jalr	-1734(ra) # 80005dc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	842080e7          	jalr	-1982(ra) # 80005dc8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	832080e7          	jalr	-1998(ra) # 80005dc8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	7b8080e7          	jalr	1976(ra) # 80005dc8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	720080e7          	jalr	1824(ra) # 80000df8 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	66c080e7          	jalr	1644(ra) # 80005dc8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	65c080e7          	jalr	1628(ra) # 80005dc8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	64c080e7          	jalr	1612(ra) # 80005dc8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	63c080e7          	jalr	1596(ra) # 80005dc8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	55e080e7          	jalr	1374(ra) # 80005dc8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <vmprint_level>:

void vmprint_level(pagetable_t pagetable, int depth)
{
    80000964:	715d                	addi	sp,sp,-80
    80000966:	e486                	sd	ra,72(sp)
    80000968:	e0a2                	sd	s0,64(sp)
    8000096a:	fc26                	sd	s1,56(sp)
    8000096c:	f84a                	sd	s2,48(sp)
    8000096e:	f44e                	sd	s3,40(sp)
    80000970:	f052                	sd	s4,32(sp)
    80000972:	ec56                	sd	s5,24(sp)
    80000974:	e85a                	sd	s6,16(sp)
    80000976:	e45e                	sd	s7,8(sp)
    80000978:	e062                	sd	s8,0(sp)
    8000097a:	0880                	addi	s0,sp,80
      "",
      "..",
      ".. ..",
      ".. .. .."
  };
  if (depth <= 0 || depth >= 4) {
    8000097c:	fff5871b          	addiw	a4,a1,-1
    80000980:	4789                	li	a5,2
    80000982:	02e7e463          	bltu	a5,a4,800009aa <vmprint_level+0x46>
    80000986:	89aa                	mv	s3,a0
    80000988:	4901                	li	s2,0
  }
  for(int i = 0; i < 512; i++){
    pte_t pte = pagetable[i];
    if(pte & PTE_V)
    {
      printf("%s%d: pte %p pa %p\n", pre[depth], i, pte, PTE2PA(pte));
    8000098a:	00359793          	slli	a5,a1,0x3
    8000098e:	00008b17          	auipc	s6,0x8
    80000992:	83ab0b13          	addi	s6,s6,-1990 # 800081c8 <pre.1602>
    80000996:	9b3e                	add	s6,s6,a5
    80000998:	00007b97          	auipc	s7,0x7
    8000099c:	788b8b93          	addi	s7,s7,1928 # 80008120 <etext+0x120>
       if ((pte & (PTE_R|PTE_W|PTE_X)) == 0)
      {
        uint64 child = PTE2PA(pte);
        vmprint_level((pagetable_t)child, depth+1);
    800009a0:	00158c1b          	addiw	s8,a1,1
  for(int i = 0; i < 512; i++){
    800009a4:	20000a93          	li	s5,512
    800009a8:	a01d                	j	800009ce <vmprint_level+0x6a>
    panic("vmprint_helper: depth not in {1, 2, 3}");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	416080e7          	jalr	1046(ra) # 80005dc8 <panic>
        vmprint_level((pagetable_t)child, depth+1);
    800009ba:	85e2                	mv	a1,s8
    800009bc:	8552                	mv	a0,s4
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	fa6080e7          	jalr	-90(ra) # 80000964 <vmprint_level>
  for(int i = 0; i < 512; i++){
    800009c6:	2905                	addiw	s2,s2,1
    800009c8:	09a1                	addi	s3,s3,8
    800009ca:	03590763          	beq	s2,s5,800009f8 <vmprint_level+0x94>
    pte_t pte = pagetable[i];
    800009ce:	0009b483          	ld	s1,0(s3) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    if(pte & PTE_V)
    800009d2:	0014f793          	andi	a5,s1,1
    800009d6:	dbe5                	beqz	a5,800009c6 <vmprint_level+0x62>
      printf("%s%d: pte %p pa %p\n", pre[depth], i, pte, PTE2PA(pte));
    800009d8:	00a4da13          	srli	s4,s1,0xa
    800009dc:	0a32                	slli	s4,s4,0xc
    800009de:	8752                	mv	a4,s4
    800009e0:	86a6                	mv	a3,s1
    800009e2:	864a                	mv	a2,s2
    800009e4:	000b3583          	ld	a1,0(s6)
    800009e8:	855e                	mv	a0,s7
    800009ea:	00005097          	auipc	ra,0x5
    800009ee:	428080e7          	jalr	1064(ra) # 80005e12 <printf>
       if ((pte & (PTE_R|PTE_W|PTE_X)) == 0)
    800009f2:	88b9                	andi	s1,s1,14
    800009f4:	f8e9                	bnez	s1,800009c6 <vmprint_level+0x62>
    800009f6:	b7d1                	j	800009ba <vmprint_level+0x56>
      }
    }
  }
}
    800009f8:	60a6                	ld	ra,72(sp)
    800009fa:	6406                	ld	s0,64(sp)
    800009fc:	74e2                	ld	s1,56(sp)
    800009fe:	7942                	ld	s2,48(sp)
    80000a00:	79a2                	ld	s3,40(sp)
    80000a02:	7a02                	ld	s4,32(sp)
    80000a04:	6ae2                	ld	s5,24(sp)
    80000a06:	6b42                	ld	s6,16(sp)
    80000a08:	6ba2                	ld	s7,8(sp)
    80000a0a:	6c02                	ld	s8,0(sp)
    80000a0c:	6161                	addi	sp,sp,80
    80000a0e:	8082                	ret

0000000080000a10 <vmprint>:

void vmprint(pagetable_t pagetable)
{
    80000a10:	1101                	addi	sp,sp,-32
    80000a12:	ec06                	sd	ra,24(sp)
    80000a14:	e822                	sd	s0,16(sp)
    80000a16:	e426                	sd	s1,8(sp)
    80000a18:	1000                	addi	s0,sp,32
    80000a1a:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000a1c:	85aa                	mv	a1,a0
    80000a1e:	00007517          	auipc	a0,0x7
    80000a22:	71a50513          	addi	a0,a0,1818 # 80008138 <etext+0x138>
    80000a26:	00005097          	auipc	ra,0x5
    80000a2a:	3ec080e7          	jalr	1004(ra) # 80005e12 <printf>
  vmprint_level(pagetable, 1);
    80000a2e:	4585                	li	a1,1
    80000a30:	8526                	mv	a0,s1
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f32080e7          	jalr	-206(ra) # 80000964 <vmprint_level>
}
    80000a3a:	60e2                	ld	ra,24(sp)
    80000a3c:	6442                	ld	s0,16(sp)
    80000a3e:	64a2                	ld	s1,8(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret

0000000080000a44 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a44:	7179                	addi	sp,sp,-48
    80000a46:	f406                	sd	ra,40(sp)
    80000a48:	f022                	sd	s0,32(sp)
    80000a4a:	ec26                	sd	s1,24(sp)
    80000a4c:	e84a                	sd	s2,16(sp)
    80000a4e:	e44e                	sd	s3,8(sp)
    80000a50:	e052                	sd	s4,0(sp)
    80000a52:	1800                	addi	s0,sp,48
    80000a54:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a56:	84aa                	mv	s1,a0
    80000a58:	6905                	lui	s2,0x1
    80000a5a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a5c:	4985                	li	s3,1
    80000a5e:	a821                	j	80000a76 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a60:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a62:	0532                	slli	a0,a0,0xc
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	fe0080e7          	jalr	-32(ra) # 80000a44 <freewalk>
      pagetable[i] = 0;
    80000a6c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a70:	04a1                	addi	s1,s1,8
    80000a72:	03248163          	beq	s1,s2,80000a94 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a76:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a78:	00f57793          	andi	a5,a0,15
    80000a7c:	ff3782e3          	beq	a5,s3,80000a60 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a80:	8905                	andi	a0,a0,1
    80000a82:	d57d                	beqz	a0,80000a70 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a84:	00007517          	auipc	a0,0x7
    80000a88:	6c450513          	addi	a0,a0,1732 # 80008148 <etext+0x148>
    80000a8c:	00005097          	auipc	ra,0x5
    80000a90:	33c080e7          	jalr	828(ra) # 80005dc8 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a94:	8552                	mv	a0,s4
    80000a96:	fffff097          	auipc	ra,0xfffff
    80000a9a:	586080e7          	jalr	1414(ra) # 8000001c <kfree>
}
    80000a9e:	70a2                	ld	ra,40(sp)
    80000aa0:	7402                	ld	s0,32(sp)
    80000aa2:	64e2                	ld	s1,24(sp)
    80000aa4:	6942                	ld	s2,16(sp)
    80000aa6:	69a2                	ld	s3,8(sp)
    80000aa8:	6a02                	ld	s4,0(sp)
    80000aaa:	6145                	addi	sp,sp,48
    80000aac:	8082                	ret

0000000080000aae <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000aae:	1101                	addi	sp,sp,-32
    80000ab0:	ec06                	sd	ra,24(sp)
    80000ab2:	e822                	sd	s0,16(sp)
    80000ab4:	e426                	sd	s1,8(sp)
    80000ab6:	1000                	addi	s0,sp,32
    80000ab8:	84aa                	mv	s1,a0
  if(sz > 0)
    80000aba:	e999                	bnez	a1,80000ad0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000abc:	8526                	mv	a0,s1
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	f86080e7          	jalr	-122(ra) # 80000a44 <freewalk>
}
    80000ac6:	60e2                	ld	ra,24(sp)
    80000ac8:	6442                	ld	s0,16(sp)
    80000aca:	64a2                	ld	s1,8(sp)
    80000acc:	6105                	addi	sp,sp,32
    80000ace:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ad0:	6605                	lui	a2,0x1
    80000ad2:	167d                	addi	a2,a2,-1
    80000ad4:	962e                	add	a2,a2,a1
    80000ad6:	4685                	li	a3,1
    80000ad8:	8231                	srli	a2,a2,0xc
    80000ada:	4581                	li	a1,0
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	c32080e7          	jalr	-974(ra) # 8000070e <uvmunmap>
    80000ae4:	bfe1                	j	80000abc <uvmfree+0xe>

0000000080000ae6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000ae6:	c679                	beqz	a2,80000bb4 <uvmcopy+0xce>
{
    80000ae8:	715d                	addi	sp,sp,-80
    80000aea:	e486                	sd	ra,72(sp)
    80000aec:	e0a2                	sd	s0,64(sp)
    80000aee:	fc26                	sd	s1,56(sp)
    80000af0:	f84a                	sd	s2,48(sp)
    80000af2:	f44e                	sd	s3,40(sp)
    80000af4:	f052                	sd	s4,32(sp)
    80000af6:	ec56                	sd	s5,24(sp)
    80000af8:	e85a                	sd	s6,16(sp)
    80000afa:	e45e                	sd	s7,8(sp)
    80000afc:	0880                	addi	s0,sp,80
    80000afe:	8b2a                	mv	s6,a0
    80000b00:	8aae                	mv	s5,a1
    80000b02:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b04:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b06:	4601                	li	a2,0
    80000b08:	85ce                	mv	a1,s3
    80000b0a:	855a                	mv	a0,s6
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	954080e7          	jalr	-1708(ra) # 80000460 <walk>
    80000b14:	c531                	beqz	a0,80000b60 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b16:	6118                	ld	a4,0(a0)
    80000b18:	00177793          	andi	a5,a4,1
    80000b1c:	cbb1                	beqz	a5,80000b70 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b1e:	00a75593          	srli	a1,a4,0xa
    80000b22:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b26:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b2a:	fffff097          	auipc	ra,0xfffff
    80000b2e:	5ee080e7          	jalr	1518(ra) # 80000118 <kalloc>
    80000b32:	892a                	mv	s2,a0
    80000b34:	c939                	beqz	a0,80000b8a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b36:	6605                	lui	a2,0x1
    80000b38:	85de                	mv	a1,s7
    80000b3a:	fffff097          	auipc	ra,0xfffff
    80000b3e:	69e080e7          	jalr	1694(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b42:	8726                	mv	a4,s1
    80000b44:	86ca                	mv	a3,s2
    80000b46:	6605                	lui	a2,0x1
    80000b48:	85ce                	mv	a1,s3
    80000b4a:	8556                	mv	a0,s5
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	9fc080e7          	jalr	-1540(ra) # 80000548 <mappages>
    80000b54:	e515                	bnez	a0,80000b80 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b56:	6785                	lui	a5,0x1
    80000b58:	99be                	add	s3,s3,a5
    80000b5a:	fb49e6e3          	bltu	s3,s4,80000b06 <uvmcopy+0x20>
    80000b5e:	a081                	j	80000b9e <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b60:	00007517          	auipc	a0,0x7
    80000b64:	5f850513          	addi	a0,a0,1528 # 80008158 <etext+0x158>
    80000b68:	00005097          	auipc	ra,0x5
    80000b6c:	260080e7          	jalr	608(ra) # 80005dc8 <panic>
      panic("uvmcopy: page not present");
    80000b70:	00007517          	auipc	a0,0x7
    80000b74:	60850513          	addi	a0,a0,1544 # 80008178 <etext+0x178>
    80000b78:	00005097          	auipc	ra,0x5
    80000b7c:	250080e7          	jalr	592(ra) # 80005dc8 <panic>
      kfree(mem);
    80000b80:	854a                	mv	a0,s2
    80000b82:	fffff097          	auipc	ra,0xfffff
    80000b86:	49a080e7          	jalr	1178(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b8a:	4685                	li	a3,1
    80000b8c:	00c9d613          	srli	a2,s3,0xc
    80000b90:	4581                	li	a1,0
    80000b92:	8556                	mv	a0,s5
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	b7a080e7          	jalr	-1158(ra) # 8000070e <uvmunmap>
  return -1;
    80000b9c:	557d                	li	a0,-1
}
    80000b9e:	60a6                	ld	ra,72(sp)
    80000ba0:	6406                	ld	s0,64(sp)
    80000ba2:	74e2                	ld	s1,56(sp)
    80000ba4:	7942                	ld	s2,48(sp)
    80000ba6:	79a2                	ld	s3,40(sp)
    80000ba8:	7a02                	ld	s4,32(sp)
    80000baa:	6ae2                	ld	s5,24(sp)
    80000bac:	6b42                	ld	s6,16(sp)
    80000bae:	6ba2                	ld	s7,8(sp)
    80000bb0:	6161                	addi	sp,sp,80
    80000bb2:	8082                	ret
  return 0;
    80000bb4:	4501                	li	a0,0
}
    80000bb6:	8082                	ret

0000000080000bb8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bb8:	1141                	addi	sp,sp,-16
    80000bba:	e406                	sd	ra,8(sp)
    80000bbc:	e022                	sd	s0,0(sp)
    80000bbe:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bc0:	4601                	li	a2,0
    80000bc2:	00000097          	auipc	ra,0x0
    80000bc6:	89e080e7          	jalr	-1890(ra) # 80000460 <walk>
  if(pte == 0)
    80000bca:	c901                	beqz	a0,80000bda <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bcc:	611c                	ld	a5,0(a0)
    80000bce:	9bbd                	andi	a5,a5,-17
    80000bd0:	e11c                	sd	a5,0(a0)
}
    80000bd2:	60a2                	ld	ra,8(sp)
    80000bd4:	6402                	ld	s0,0(sp)
    80000bd6:	0141                	addi	sp,sp,16
    80000bd8:	8082                	ret
    panic("uvmclear");
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	5be50513          	addi	a0,a0,1470 # 80008198 <etext+0x198>
    80000be2:	00005097          	auipc	ra,0x5
    80000be6:	1e6080e7          	jalr	486(ra) # 80005dc8 <panic>

0000000080000bea <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bea:	c6bd                	beqz	a3,80000c58 <copyout+0x6e>
{
    80000bec:	715d                	addi	sp,sp,-80
    80000bee:	e486                	sd	ra,72(sp)
    80000bf0:	e0a2                	sd	s0,64(sp)
    80000bf2:	fc26                	sd	s1,56(sp)
    80000bf4:	f84a                	sd	s2,48(sp)
    80000bf6:	f44e                	sd	s3,40(sp)
    80000bf8:	f052                	sd	s4,32(sp)
    80000bfa:	ec56                	sd	s5,24(sp)
    80000bfc:	e85a                	sd	s6,16(sp)
    80000bfe:	e45e                	sd	s7,8(sp)
    80000c00:	e062                	sd	s8,0(sp)
    80000c02:	0880                	addi	s0,sp,80
    80000c04:	8b2a                	mv	s6,a0
    80000c06:	8c2e                	mv	s8,a1
    80000c08:	8a32                	mv	s4,a2
    80000c0a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c0c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c0e:	6a85                	lui	s5,0x1
    80000c10:	a015                	j	80000c34 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c12:	9562                	add	a0,a0,s8
    80000c14:	0004861b          	sext.w	a2,s1
    80000c18:	85d2                	mv	a1,s4
    80000c1a:	41250533          	sub	a0,a0,s2
    80000c1e:	fffff097          	auipc	ra,0xfffff
    80000c22:	5ba080e7          	jalr	1466(ra) # 800001d8 <memmove>

    len -= n;
    80000c26:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c2a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c2c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c30:	02098263          	beqz	s3,80000c54 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c34:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c38:	85ca                	mv	a1,s2
    80000c3a:	855a                	mv	a0,s6
    80000c3c:	00000097          	auipc	ra,0x0
    80000c40:	8ca080e7          	jalr	-1846(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c44:	cd01                	beqz	a0,80000c5c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c46:	418904b3          	sub	s1,s2,s8
    80000c4a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c4c:	fc99f3e3          	bgeu	s3,s1,80000c12 <copyout+0x28>
    80000c50:	84ce                	mv	s1,s3
    80000c52:	b7c1                	j	80000c12 <copyout+0x28>
  }
  return 0;
    80000c54:	4501                	li	a0,0
    80000c56:	a021                	j	80000c5e <copyout+0x74>
    80000c58:	4501                	li	a0,0
}
    80000c5a:	8082                	ret
      return -1;
    80000c5c:	557d                	li	a0,-1
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6c02                	ld	s8,0(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret

0000000080000c76 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c76:	c6bd                	beqz	a3,80000ce4 <copyin+0x6e>
{
    80000c78:	715d                	addi	sp,sp,-80
    80000c7a:	e486                	sd	ra,72(sp)
    80000c7c:	e0a2                	sd	s0,64(sp)
    80000c7e:	fc26                	sd	s1,56(sp)
    80000c80:	f84a                	sd	s2,48(sp)
    80000c82:	f44e                	sd	s3,40(sp)
    80000c84:	f052                	sd	s4,32(sp)
    80000c86:	ec56                	sd	s5,24(sp)
    80000c88:	e85a                	sd	s6,16(sp)
    80000c8a:	e45e                	sd	s7,8(sp)
    80000c8c:	e062                	sd	s8,0(sp)
    80000c8e:	0880                	addi	s0,sp,80
    80000c90:	8b2a                	mv	s6,a0
    80000c92:	8a2e                	mv	s4,a1
    80000c94:	8c32                	mv	s8,a2
    80000c96:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c98:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9a:	6a85                	lui	s5,0x1
    80000c9c:	a015                	j	80000cc0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c9e:	9562                	add	a0,a0,s8
    80000ca0:	0004861b          	sext.w	a2,s1
    80000ca4:	412505b3          	sub	a1,a0,s2
    80000ca8:	8552                	mv	a0,s4
    80000caa:	fffff097          	auipc	ra,0xfffff
    80000cae:	52e080e7          	jalr	1326(ra) # 800001d8 <memmove>

    len -= n;
    80000cb2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cb6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cb8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cbc:	02098263          	beqz	s3,80000ce0 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cc4:	85ca                	mv	a1,s2
    80000cc6:	855a                	mv	a0,s6
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	83e080e7          	jalr	-1986(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000cd0:	cd01                	beqz	a0,80000ce8 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000cd2:	418904b3          	sub	s1,s2,s8
    80000cd6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cd8:	fc99f3e3          	bgeu	s3,s1,80000c9e <copyin+0x28>
    80000cdc:	84ce                	mv	s1,s3
    80000cde:	b7c1                	j	80000c9e <copyin+0x28>
  }
  return 0;
    80000ce0:	4501                	li	a0,0
    80000ce2:	a021                	j	80000cea <copyin+0x74>
    80000ce4:	4501                	li	a0,0
}
    80000ce6:	8082                	ret
      return -1;
    80000ce8:	557d                	li	a0,-1
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6c02                	ld	s8,0(sp)
    80000cfe:	6161                	addi	sp,sp,80
    80000d00:	8082                	ret

0000000080000d02 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d02:	c6c5                	beqz	a3,80000daa <copyinstr+0xa8>
{
    80000d04:	715d                	addi	sp,sp,-80
    80000d06:	e486                	sd	ra,72(sp)
    80000d08:	e0a2                	sd	s0,64(sp)
    80000d0a:	fc26                	sd	s1,56(sp)
    80000d0c:	f84a                	sd	s2,48(sp)
    80000d0e:	f44e                	sd	s3,40(sp)
    80000d10:	f052                	sd	s4,32(sp)
    80000d12:	ec56                	sd	s5,24(sp)
    80000d14:	e85a                	sd	s6,16(sp)
    80000d16:	e45e                	sd	s7,8(sp)
    80000d18:	0880                	addi	s0,sp,80
    80000d1a:	8a2a                	mv	s4,a0
    80000d1c:	8b2e                	mv	s6,a1
    80000d1e:	8bb2                	mv	s7,a2
    80000d20:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d22:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d24:	6985                	lui	s3,0x1
    80000d26:	a035                	j	80000d52 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d28:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d2c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d2e:	0017b793          	seqz	a5,a5
    80000d32:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d36:	60a6                	ld	ra,72(sp)
    80000d38:	6406                	ld	s0,64(sp)
    80000d3a:	74e2                	ld	s1,56(sp)
    80000d3c:	7942                	ld	s2,48(sp)
    80000d3e:	79a2                	ld	s3,40(sp)
    80000d40:	7a02                	ld	s4,32(sp)
    80000d42:	6ae2                	ld	s5,24(sp)
    80000d44:	6b42                	ld	s6,16(sp)
    80000d46:	6ba2                	ld	s7,8(sp)
    80000d48:	6161                	addi	sp,sp,80
    80000d4a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d4c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d50:	c8a9                	beqz	s1,80000da2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d52:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d56:	85ca                	mv	a1,s2
    80000d58:	8552                	mv	a0,s4
    80000d5a:	fffff097          	auipc	ra,0xfffff
    80000d5e:	7ac080e7          	jalr	1964(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000d62:	c131                	beqz	a0,80000da6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d64:	41790833          	sub	a6,s2,s7
    80000d68:	984e                	add	a6,a6,s3
    if(n > max)
    80000d6a:	0104f363          	bgeu	s1,a6,80000d70 <copyinstr+0x6e>
    80000d6e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d70:	955e                	add	a0,a0,s7
    80000d72:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d76:	fc080be3          	beqz	a6,80000d4c <copyinstr+0x4a>
    80000d7a:	985a                	add	a6,a6,s6
    80000d7c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d7e:	41650633          	sub	a2,a0,s6
    80000d82:	14fd                	addi	s1,s1,-1
    80000d84:	9b26                	add	s6,s6,s1
    80000d86:	00f60733          	add	a4,a2,a5
    80000d8a:	00074703          	lbu	a4,0(a4)
    80000d8e:	df49                	beqz	a4,80000d28 <copyinstr+0x26>
        *dst = *p;
    80000d90:	00e78023          	sb	a4,0(a5)
      --max;
    80000d94:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d98:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d9a:	ff0796e3          	bne	a5,a6,80000d86 <copyinstr+0x84>
      dst++;
    80000d9e:	8b42                	mv	s6,a6
    80000da0:	b775                	j	80000d4c <copyinstr+0x4a>
    80000da2:	4781                	li	a5,0
    80000da4:	b769                	j	80000d2e <copyinstr+0x2c>
      return -1;
    80000da6:	557d                	li	a0,-1
    80000da8:	b779                	j	80000d36 <copyinstr+0x34>
  int got_null = 0;
    80000daa:	4781                	li	a5,0
  if(got_null){
    80000dac:	0017b793          	seqz	a5,a5
    80000db0:	40f00533          	neg	a0,a5
}
    80000db4:	8082                	ret

0000000080000db6 <vm_pgaccess>:

int vm_pgaccess(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;

  if(va >= MAXVA)
    80000db6:	57fd                	li	a5,-1
    80000db8:	83e9                	srli	a5,a5,0x1a
    80000dba:	00b7f463          	bgeu	a5,a1,80000dc2 <vm_pgaccess+0xc>
    return 0;
    80000dbe:	4501                	li	a0,0
  {
    *pte = *pte & (~PTE_A);
    return 1;
  }
  return 0;
}
    80000dc0:	8082                	ret
{
    80000dc2:	1141                	addi	sp,sp,-16
    80000dc4:	e406                	sd	ra,8(sp)
    80000dc6:	e022                	sd	s0,0(sp)
    80000dc8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000dca:	4601                	li	a2,0
    80000dcc:	fffff097          	auipc	ra,0xfffff
    80000dd0:	694080e7          	jalr	1684(ra) # 80000460 <walk>
    80000dd4:	87aa                	mv	a5,a0
  if(pte == 0)
    80000dd6:	cd19                	beqz	a0,80000df4 <vm_pgaccess+0x3e>
  if((*pte & PTE_A) != 0)
    80000dd8:	6118                	ld	a4,0(a0)
    80000dda:	04077693          	andi	a3,a4,64
  return 0;
    80000dde:	4501                	li	a0,0
  if((*pte & PTE_A) != 0)
    80000de0:	e689                	bnez	a3,80000dea <vm_pgaccess+0x34>
}
    80000de2:	60a2                	ld	ra,8(sp)
    80000de4:	6402                	ld	s0,0(sp)
    80000de6:	0141                	addi	sp,sp,16
    80000de8:	8082                	ret
    *pte = *pte & (~PTE_A);
    80000dea:	fbf77713          	andi	a4,a4,-65
    80000dee:	e398                	sd	a4,0(a5)
    return 1;
    80000df0:	4505                	li	a0,1
    80000df2:	bfc5                	j	80000de2 <vm_pgaccess+0x2c>
    return 0;
    80000df4:	4501                	li	a0,0
    80000df6:	b7f5                	j	80000de2 <vm_pgaccess+0x2c>

0000000080000df8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000df8:	7139                	addi	sp,sp,-64
    80000dfa:	fc06                	sd	ra,56(sp)
    80000dfc:	f822                	sd	s0,48(sp)
    80000dfe:	f426                	sd	s1,40(sp)
    80000e00:	f04a                	sd	s2,32(sp)
    80000e02:	ec4e                	sd	s3,24(sp)
    80000e04:	e852                	sd	s4,16(sp)
    80000e06:	e456                	sd	s5,8(sp)
    80000e08:	e05a                	sd	s6,0(sp)
    80000e0a:	0080                	addi	s0,sp,64
    80000e0c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	00008497          	auipc	s1,0x8
    80000e12:	67248493          	addi	s1,s1,1650 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e16:	8b26                	mv	s6,s1
    80000e18:	00007a97          	auipc	s5,0x7
    80000e1c:	1e8a8a93          	addi	s5,s5,488 # 80008000 <etext>
    80000e20:	01000937          	lui	s2,0x1000
    80000e24:	197d                	addi	s2,s2,-1
    80000e26:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e28:	0000ea17          	auipc	s4,0xe
    80000e2c:	258a0a13          	addi	s4,s4,600 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e30:	fffff097          	auipc	ra,0xfffff
    80000e34:	2e8080e7          	jalr	744(ra) # 80000118 <kalloc>
    80000e38:	862a                	mv	a2,a0
    if(pa == 0)
    80000e3a:	c129                	beqz	a0,80000e7c <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e3c:	416485b3          	sub	a1,s1,s6
    80000e40:	8591                	srai	a1,a1,0x4
    80000e42:	000ab783          	ld	a5,0(s5)
    80000e46:	02f585b3          	mul	a1,a1,a5
    80000e4a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e4e:	4719                	li	a4,6
    80000e50:	6685                	lui	a3,0x1
    80000e52:	40b905b3          	sub	a1,s2,a1
    80000e56:	854e                	mv	a0,s3
    80000e58:	fffff097          	auipc	ra,0xfffff
    80000e5c:	790080e7          	jalr	1936(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e60:	17048493          	addi	s1,s1,368
    80000e64:	fd4496e3          	bne	s1,s4,80000e30 <proc_mapstacks+0x38>
  }
}
    80000e68:	70e2                	ld	ra,56(sp)
    80000e6a:	7442                	ld	s0,48(sp)
    80000e6c:	74a2                	ld	s1,40(sp)
    80000e6e:	7902                	ld	s2,32(sp)
    80000e70:	69e2                	ld	s3,24(sp)
    80000e72:	6a42                	ld	s4,16(sp)
    80000e74:	6aa2                	ld	s5,8(sp)
    80000e76:	6b02                	ld	s6,0(sp)
    80000e78:	6121                	addi	sp,sp,64
    80000e7a:	8082                	ret
      panic("kalloc");
    80000e7c:	00007517          	auipc	a0,0x7
    80000e80:	36c50513          	addi	a0,a0,876 # 800081e8 <pre.1602+0x20>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	f44080e7          	jalr	-188(ra) # 80005dc8 <panic>

0000000080000e8c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e8c:	7139                	addi	sp,sp,-64
    80000e8e:	fc06                	sd	ra,56(sp)
    80000e90:	f822                	sd	s0,48(sp)
    80000e92:	f426                	sd	s1,40(sp)
    80000e94:	f04a                	sd	s2,32(sp)
    80000e96:	ec4e                	sd	s3,24(sp)
    80000e98:	e852                	sd	s4,16(sp)
    80000e9a:	e456                	sd	s5,8(sp)
    80000e9c:	e05a                	sd	s6,0(sp)
    80000e9e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ea0:	00007597          	auipc	a1,0x7
    80000ea4:	35058593          	addi	a1,a1,848 # 800081f0 <pre.1602+0x28>
    80000ea8:	00008517          	auipc	a0,0x8
    80000eac:	1a850513          	addi	a0,a0,424 # 80009050 <pid_lock>
    80000eb0:	00005097          	auipc	ra,0x5
    80000eb4:	3d2080e7          	jalr	978(ra) # 80006282 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eb8:	00007597          	auipc	a1,0x7
    80000ebc:	34058593          	addi	a1,a1,832 # 800081f8 <pre.1602+0x30>
    80000ec0:	00008517          	auipc	a0,0x8
    80000ec4:	1a850513          	addi	a0,a0,424 # 80009068 <wait_lock>
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	3ba080e7          	jalr	954(ra) # 80006282 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	00008497          	auipc	s1,0x8
    80000ed4:	5b048493          	addi	s1,s1,1456 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ed8:	00007b17          	auipc	s6,0x7
    80000edc:	330b0b13          	addi	s6,s6,816 # 80008208 <pre.1602+0x40>
      p->kstack = KSTACK((int) (p - proc));
    80000ee0:	8aa6                	mv	s5,s1
    80000ee2:	00007a17          	auipc	s4,0x7
    80000ee6:	11ea0a13          	addi	s4,s4,286 # 80008000 <etext>
    80000eea:	01000937          	lui	s2,0x1000
    80000eee:	197d                	addi	s2,s2,-1
    80000ef0:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef2:	0000e997          	auipc	s3,0xe
    80000ef6:	18e98993          	addi	s3,s3,398 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000efa:	85da                	mv	a1,s6
    80000efc:	8526                	mv	a0,s1
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	384080e7          	jalr	900(ra) # 80006282 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f06:	415487b3          	sub	a5,s1,s5
    80000f0a:	8791                	srai	a5,a5,0x4
    80000f0c:	000a3703          	ld	a4,0(s4)
    80000f10:	02e787b3          	mul	a5,a5,a4
    80000f14:	00d7979b          	slliw	a5,a5,0xd
    80000f18:	40f907b3          	sub	a5,s2,a5
    80000f1c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f1e:	17048493          	addi	s1,s1,368
    80000f22:	fd349ce3          	bne	s1,s3,80000efa <procinit+0x6e>
  }
}
    80000f26:	70e2                	ld	ra,56(sp)
    80000f28:	7442                	ld	s0,48(sp)
    80000f2a:	74a2                	ld	s1,40(sp)
    80000f2c:	7902                	ld	s2,32(sp)
    80000f2e:	69e2                	ld	s3,24(sp)
    80000f30:	6a42                	ld	s4,16(sp)
    80000f32:	6aa2                	ld	s5,8(sp)
    80000f34:	6b02                	ld	s6,0(sp)
    80000f36:	6121                	addi	sp,sp,64
    80000f38:	8082                	ret

0000000080000f3a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f3a:	1141                	addi	sp,sp,-16
    80000f3c:	e422                	sd	s0,8(sp)
    80000f3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f40:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f42:	2501                	sext.w	a0,a0
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
    80000f50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f56:	00008517          	auipc	a0,0x8
    80000f5a:	12a50513          	addi	a0,a0,298 # 80009080 <cpus>
    80000f5e:	953e                	add	a0,a0,a5
    80000f60:	6422                	ld	s0,8(sp)
    80000f62:	0141                	addi	sp,sp,16
    80000f64:	8082                	ret

0000000080000f66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f66:	1101                	addi	sp,sp,-32
    80000f68:	ec06                	sd	ra,24(sp)
    80000f6a:	e822                	sd	s0,16(sp)
    80000f6c:	e426                	sd	s1,8(sp)
    80000f6e:	1000                	addi	s0,sp,32
  push_off();
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	356080e7          	jalr	854(ra) # 800062c6 <push_off>
    80000f78:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f7a:	2781                	sext.w	a5,a5
    80000f7c:	079e                	slli	a5,a5,0x7
    80000f7e:	00008717          	auipc	a4,0x8
    80000f82:	0d270713          	addi	a4,a4,210 # 80009050 <pid_lock>
    80000f86:	97ba                	add	a5,a5,a4
    80000f88:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	3dc080e7          	jalr	988(ra) # 80006366 <pop_off>
  return p;
}
    80000f92:	8526                	mv	a0,s1
    80000f94:	60e2                	ld	ra,24(sp)
    80000f96:	6442                	ld	s0,16(sp)
    80000f98:	64a2                	ld	s1,8(sp)
    80000f9a:	6105                	addi	sp,sp,32
    80000f9c:	8082                	ret

0000000080000f9e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f9e:	1141                	addi	sp,sp,-16
    80000fa0:	e406                	sd	ra,8(sp)
    80000fa2:	e022                	sd	s0,0(sp)
    80000fa4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	fc0080e7          	jalr	-64(ra) # 80000f66 <myproc>
    80000fae:	00005097          	auipc	ra,0x5
    80000fb2:	418080e7          	jalr	1048(ra) # 800063c6 <release>

  if (first) {
    80000fb6:	00008797          	auipc	a5,0x8
    80000fba:	92a7a783          	lw	a5,-1750(a5) # 800088e0 <first.1683>
    80000fbe:	eb89                	bnez	a5,80000fd0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fc0:	00001097          	auipc	ra,0x1
    80000fc4:	cb8080e7          	jalr	-840(ra) # 80001c78 <usertrapret>
}
    80000fc8:	60a2                	ld	ra,8(sp)
    80000fca:	6402                	ld	s0,0(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret
    first = 0;
    80000fd0:	00008797          	auipc	a5,0x8
    80000fd4:	9007a823          	sw	zero,-1776(a5) # 800088e0 <first.1683>
    fsinit(ROOTDEV);
    80000fd8:	4505                	li	a0,1
    80000fda:	00002097          	auipc	ra,0x2
    80000fde:	aaa080e7          	jalr	-1366(ra) # 80002a84 <fsinit>
    80000fe2:	bff9                	j	80000fc0 <forkret+0x22>

0000000080000fe4 <allocpid>:
allocpid() {
    80000fe4:	1101                	addi	sp,sp,-32
    80000fe6:	ec06                	sd	ra,24(sp)
    80000fe8:	e822                	sd	s0,16(sp)
    80000fea:	e426                	sd	s1,8(sp)
    80000fec:	e04a                	sd	s2,0(sp)
    80000fee:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ff0:	00008917          	auipc	s2,0x8
    80000ff4:	06090913          	addi	s2,s2,96 # 80009050 <pid_lock>
    80000ff8:	854a                	mv	a0,s2
    80000ffa:	00005097          	auipc	ra,0x5
    80000ffe:	318080e7          	jalr	792(ra) # 80006312 <acquire>
  pid = nextpid;
    80001002:	00008797          	auipc	a5,0x8
    80001006:	8e278793          	addi	a5,a5,-1822 # 800088e4 <nextpid>
    8000100a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000100c:	0014871b          	addiw	a4,s1,1
    80001010:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001012:	854a                	mv	a0,s2
    80001014:	00005097          	auipc	ra,0x5
    80001018:	3b2080e7          	jalr	946(ra) # 800063c6 <release>
}
    8000101c:	8526                	mv	a0,s1
    8000101e:	60e2                	ld	ra,24(sp)
    80001020:	6442                	ld	s0,16(sp)
    80001022:	64a2                	ld	s1,8(sp)
    80001024:	6902                	ld	s2,0(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret

000000008000102a <proc_pagetable>:
{
    8000102a:	1101                	addi	sp,sp,-32
    8000102c:	ec06                	sd	ra,24(sp)
    8000102e:	e822                	sd	s0,16(sp)
    80001030:	e426                	sd	s1,8(sp)
    80001032:	e04a                	sd	s2,0(sp)
    80001034:	1000                	addi	s0,sp,32
    80001036:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001038:	fffff097          	auipc	ra,0xfffff
    8000103c:	79a080e7          	jalr	1946(ra) # 800007d2 <uvmcreate>
    80001040:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001042:	cd39                	beqz	a0,800010a0 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001044:	4729                	li	a4,10
    80001046:	00006697          	auipc	a3,0x6
    8000104a:	fba68693          	addi	a3,a3,-70 # 80007000 <_trampoline>
    8000104e:	6605                	lui	a2,0x1
    80001050:	040005b7          	lui	a1,0x4000
    80001054:	15fd                	addi	a1,a1,-1
    80001056:	05b2                	slli	a1,a1,0xc
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	4f0080e7          	jalr	1264(ra) # 80000548 <mappages>
    80001060:	04054763          	bltz	a0,800010ae <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001064:	4719                	li	a4,6
    80001066:	05893683          	ld	a3,88(s2)
    8000106a:	6605                	lui	a2,0x1
    8000106c:	020005b7          	lui	a1,0x2000
    80001070:	15fd                	addi	a1,a1,-1
    80001072:	05b6                	slli	a1,a1,0xd
    80001074:	8526                	mv	a0,s1
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	4d2080e7          	jalr	1234(ra) # 80000548 <mappages>
    8000107e:	04054063          	bltz	a0,800010be <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001082:	4749                	li	a4,18
    80001084:	06093683          	ld	a3,96(s2)
    80001088:	6605                	lui	a2,0x1
    8000108a:	040005b7          	lui	a1,0x4000
    8000108e:	15f5                	addi	a1,a1,-3
    80001090:	05b2                	slli	a1,a1,0xc
    80001092:	8526                	mv	a0,s1
    80001094:	fffff097          	auipc	ra,0xfffff
    80001098:	4b4080e7          	jalr	1204(ra) # 80000548 <mappages>
    8000109c:	04054463          	bltz	a0,800010e4 <proc_pagetable+0xba>
}
    800010a0:	8526                	mv	a0,s1
    800010a2:	60e2                	ld	ra,24(sp)
    800010a4:	6442                	ld	s0,16(sp)
    800010a6:	64a2                	ld	s1,8(sp)
    800010a8:	6902                	ld	s2,0(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret
    uvmfree(pagetable, 0);
    800010ae:	4581                	li	a1,0
    800010b0:	8526                	mv	a0,s1
    800010b2:	00000097          	auipc	ra,0x0
    800010b6:	9fc080e7          	jalr	-1540(ra) # 80000aae <uvmfree>
    return 0;
    800010ba:	4481                	li	s1,0
    800010bc:	b7d5                	j	800010a0 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010be:	4681                	li	a3,0
    800010c0:	4605                	li	a2,1
    800010c2:	040005b7          	lui	a1,0x4000
    800010c6:	15fd                	addi	a1,a1,-1
    800010c8:	05b2                	slli	a1,a1,0xc
    800010ca:	8526                	mv	a0,s1
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	642080e7          	jalr	1602(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010d4:	4581                	li	a1,0
    800010d6:	8526                	mv	a0,s1
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	9d6080e7          	jalr	-1578(ra) # 80000aae <uvmfree>
    return 0;
    800010e0:	4481                	li	s1,0
    800010e2:	bf7d                	j	800010a0 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010e4:	4681                	li	a3,0
    800010e6:	4605                	li	a2,1
    800010e8:	020005b7          	lui	a1,0x2000
    800010ec:	15fd                	addi	a1,a1,-1
    800010ee:	05b6                	slli	a1,a1,0xd
    800010f0:	8526                	mv	a0,s1
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	61c080e7          	jalr	1564(ra) # 8000070e <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010fa:	4681                	li	a3,0
    800010fc:	4605                	li	a2,1
    800010fe:	040005b7          	lui	a1,0x4000
    80001102:	15fd                	addi	a1,a1,-1
    80001104:	05b2                	slli	a1,a1,0xc
    80001106:	8526                	mv	a0,s1
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	606080e7          	jalr	1542(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80001110:	4581                	li	a1,0
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	99a080e7          	jalr	-1638(ra) # 80000aae <uvmfree>
    return 0;
    8000111c:	4481                	li	s1,0
    8000111e:	b749                	j	800010a0 <proc_pagetable+0x76>

0000000080001120 <proc_freepagetable>:
{
    80001120:	7179                	addi	sp,sp,-48
    80001122:	f406                	sd	ra,40(sp)
    80001124:	f022                	sd	s0,32(sp)
    80001126:	ec26                	sd	s1,24(sp)
    80001128:	e84a                	sd	s2,16(sp)
    8000112a:	e44e                	sd	s3,8(sp)
    8000112c:	1800                	addi	s0,sp,48
    8000112e:	84aa                	mv	s1,a0
    80001130:	89ae                	mv	s3,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001132:	4681                	li	a3,0
    80001134:	4605                	li	a2,1
    80001136:	04000937          	lui	s2,0x4000
    8000113a:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    8000113e:	05b2                	slli	a1,a1,0xc
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	5ce080e7          	jalr	1486(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001148:	4681                	li	a3,0
    8000114a:	4605                	li	a2,1
    8000114c:	197d                	addi	s2,s2,-1
    8000114e:	00c91593          	slli	a1,s2,0xc
    80001152:	8526                	mv	a0,s1
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	5ba080e7          	jalr	1466(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000115c:	4681                	li	a3,0
    8000115e:	4605                	li	a2,1
    80001160:	020005b7          	lui	a1,0x2000
    80001164:	15fd                	addi	a1,a1,-1
    80001166:	05b6                	slli	a1,a1,0xd
    80001168:	8526                	mv	a0,s1
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	5a4080e7          	jalr	1444(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001172:	85ce                	mv	a1,s3
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	938080e7          	jalr	-1736(ra) # 80000aae <uvmfree>
}
    8000117e:	70a2                	ld	ra,40(sp)
    80001180:	7402                	ld	s0,32(sp)
    80001182:	64e2                	ld	s1,24(sp)
    80001184:	6942                	ld	s2,16(sp)
    80001186:	69a2                	ld	s3,8(sp)
    80001188:	6145                	addi	sp,sp,48
    8000118a:	8082                	ret

000000008000118c <freeproc>:
{
    8000118c:	1101                	addi	sp,sp,-32
    8000118e:	ec06                	sd	ra,24(sp)
    80001190:	e822                	sd	s0,16(sp)
    80001192:	e426                	sd	s1,8(sp)
    80001194:	1000                	addi	s0,sp,32
    80001196:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001198:	6d28                	ld	a0,88(a0)
    8000119a:	c509                	beqz	a0,800011a4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000119c:	fffff097          	auipc	ra,0xfffff
    800011a0:	e80080e7          	jalr	-384(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011a4:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    800011a8:	70a8                	ld	a0,96(s1)
    800011aa:	c509                	beqz	a0,800011b4 <freeproc+0x28>
    kfree((void*)p->usyscall);
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	e70080e7          	jalr	-400(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011b4:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011b8:	68a8                	ld	a0,80(s1)
    800011ba:	c511                	beqz	a0,800011c6 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011bc:	64ac                	ld	a1,72(s1)
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	f62080e7          	jalr	-158(ra) # 80001120 <proc_freepagetable>
  p->pagetable = 0;
    800011c6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011ca:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011ce:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011d2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011d6:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011da:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011de:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011e2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011e6:	0004ac23          	sw	zero,24(s1)
}
    800011ea:	60e2                	ld	ra,24(sp)
    800011ec:	6442                	ld	s0,16(sp)
    800011ee:	64a2                	ld	s1,8(sp)
    800011f0:	6105                	addi	sp,sp,32
    800011f2:	8082                	ret

00000000800011f4 <allocproc>:
{
    800011f4:	1101                	addi	sp,sp,-32
    800011f6:	ec06                	sd	ra,24(sp)
    800011f8:	e822                	sd	s0,16(sp)
    800011fa:	e426                	sd	s1,8(sp)
    800011fc:	e04a                	sd	s2,0(sp)
    800011fe:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001200:	00008497          	auipc	s1,0x8
    80001204:	28048493          	addi	s1,s1,640 # 80009480 <proc>
    80001208:	0000e917          	auipc	s2,0xe
    8000120c:	e7890913          	addi	s2,s2,-392 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001210:	8526                	mv	a0,s1
    80001212:	00005097          	auipc	ra,0x5
    80001216:	100080e7          	jalr	256(ra) # 80006312 <acquire>
    if(p->state == UNUSED) {
    8000121a:	4c9c                	lw	a5,24(s1)
    8000121c:	cf81                	beqz	a5,80001234 <allocproc+0x40>
      release(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	00005097          	auipc	ra,0x5
    80001224:	1a6080e7          	jalr	422(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001228:	17048493          	addi	s1,s1,368
    8000122c:	ff2492e3          	bne	s1,s2,80001210 <allocproc+0x1c>
  return 0;
    80001230:	4481                	li	s1,0
    80001232:	a095                	j	80001296 <allocproc+0xa2>
  p->pid = allocpid();
    80001234:	00000097          	auipc	ra,0x0
    80001238:	db0080e7          	jalr	-592(ra) # 80000fe4 <allocpid>
    8000123c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000123e:	4785                	li	a5,1
    80001240:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	ed6080e7          	jalr	-298(ra) # 80000118 <kalloc>
    8000124a:	892a                	mv	s2,a0
    8000124c:	eca8                	sd	a0,88(s1)
    8000124e:	c939                	beqz	a0,800012a4 <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	ec8080e7          	jalr	-312(ra) # 80000118 <kalloc>
    80001258:	892a                	mv	s2,a0
    8000125a:	f0a8                	sd	a0,96(s1)
    8000125c:	c125                	beqz	a0,800012bc <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    8000125e:	589c                	lw	a5,48(s1)
    80001260:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001262:	8526                	mv	a0,s1
    80001264:	00000097          	auipc	ra,0x0
    80001268:	dc6080e7          	jalr	-570(ra) # 8000102a <proc_pagetable>
    8000126c:	892a                	mv	s2,a0
    8000126e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001270:	c135                	beqz	a0,800012d4 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001272:	07000613          	li	a2,112
    80001276:	4581                	li	a1,0
    80001278:	06848513          	addi	a0,s1,104
    8000127c:	fffff097          	auipc	ra,0xfffff
    80001280:	efc080e7          	jalr	-260(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001284:	00000797          	auipc	a5,0x0
    80001288:	d1a78793          	addi	a5,a5,-742 # 80000f9e <forkret>
    8000128c:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000128e:	60bc                	ld	a5,64(s1)
    80001290:	6705                	lui	a4,0x1
    80001292:	97ba                	add	a5,a5,a4
    80001294:	f8bc                	sd	a5,112(s1)
}
    80001296:	8526                	mv	a0,s1
    80001298:	60e2                	ld	ra,24(sp)
    8000129a:	6442                	ld	s0,16(sp)
    8000129c:	64a2                	ld	s1,8(sp)
    8000129e:	6902                	ld	s2,0(sp)
    800012a0:	6105                	addi	sp,sp,32
    800012a2:	8082                	ret
    freeproc(p);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	ee6080e7          	jalr	-282(ra) # 8000118c <freeproc>
    release(&p->lock);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	116080e7          	jalr	278(ra) # 800063c6 <release>
    return 0;
    800012b8:	84ca                	mv	s1,s2
    800012ba:	bff1                	j	80001296 <allocproc+0xa2>
    freeproc(p);
    800012bc:	8526                	mv	a0,s1
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	ece080e7          	jalr	-306(ra) # 8000118c <freeproc>
    release(&p->lock);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00005097          	auipc	ra,0x5
    800012cc:	0fe080e7          	jalr	254(ra) # 800063c6 <release>
    return 0;
    800012d0:	84ca                	mv	s1,s2
    800012d2:	b7d1                	j	80001296 <allocproc+0xa2>
    freeproc(p);
    800012d4:	8526                	mv	a0,s1
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	eb6080e7          	jalr	-330(ra) # 8000118c <freeproc>
    release(&p->lock);
    800012de:	8526                	mv	a0,s1
    800012e0:	00005097          	auipc	ra,0x5
    800012e4:	0e6080e7          	jalr	230(ra) # 800063c6 <release>
    return 0;
    800012e8:	84ca                	mv	s1,s2
    800012ea:	b775                	j	80001296 <allocproc+0xa2>

00000000800012ec <userinit>:
{
    800012ec:	1101                	addi	sp,sp,-32
    800012ee:	ec06                	sd	ra,24(sp)
    800012f0:	e822                	sd	s0,16(sp)
    800012f2:	e426                	sd	s1,8(sp)
    800012f4:	1000                	addi	s0,sp,32
  p = allocproc();
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	efe080e7          	jalr	-258(ra) # 800011f4 <allocproc>
    800012fe:	84aa                	mv	s1,a0
  initproc = p;
    80001300:	00008797          	auipc	a5,0x8
    80001304:	d0a7b823          	sd	a0,-752(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001308:	03400613          	li	a2,52
    8000130c:	00007597          	auipc	a1,0x7
    80001310:	5e458593          	addi	a1,a1,1508 # 800088f0 <initcode>
    80001314:	6928                	ld	a0,80(a0)
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	4ea080e7          	jalr	1258(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    8000131e:	6785                	lui	a5,0x1
    80001320:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001322:	6cb8                	ld	a4,88(s1)
    80001324:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001328:	6cb8                	ld	a4,88(s1)
    8000132a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000132c:	4641                	li	a2,16
    8000132e:	00007597          	auipc	a1,0x7
    80001332:	ee258593          	addi	a1,a1,-286 # 80008210 <pre.1602+0x48>
    80001336:	16048513          	addi	a0,s1,352
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	f90080e7          	jalr	-112(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001342:	00007517          	auipc	a0,0x7
    80001346:	ede50513          	addi	a0,a0,-290 # 80008220 <pre.1602+0x58>
    8000134a:	00002097          	auipc	ra,0x2
    8000134e:	168080e7          	jalr	360(ra) # 800034b2 <namei>
    80001352:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001356:	478d                	li	a5,3
    80001358:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	06a080e7          	jalr	106(ra) # 800063c6 <release>
}
    80001364:	60e2                	ld	ra,24(sp)
    80001366:	6442                	ld	s0,16(sp)
    80001368:	64a2                	ld	s1,8(sp)
    8000136a:	6105                	addi	sp,sp,32
    8000136c:	8082                	ret

000000008000136e <growproc>:
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	e04a                	sd	s2,0(sp)
    80001378:	1000                	addi	s0,sp,32
    8000137a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	bea080e7          	jalr	-1046(ra) # 80000f66 <myproc>
    80001384:	892a                	mv	s2,a0
  sz = p->sz;
    80001386:	652c                	ld	a1,72(a0)
    80001388:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000138c:	00904f63          	bgtz	s1,800013aa <growproc+0x3c>
  } else if(n < 0){
    80001390:	0204cc63          	bltz	s1,800013c8 <growproc+0x5a>
  p->sz = sz;
    80001394:	1602                	slli	a2,a2,0x20
    80001396:	9201                	srli	a2,a2,0x20
    80001398:	04c93423          	sd	a2,72(s2)
  return 0;
    8000139c:	4501                	li	a0,0
}
    8000139e:	60e2                	ld	ra,24(sp)
    800013a0:	6442                	ld	s0,16(sp)
    800013a2:	64a2                	ld	s1,8(sp)
    800013a4:	6902                	ld	s2,0(sp)
    800013a6:	6105                	addi	sp,sp,32
    800013a8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013aa:	9e25                	addw	a2,a2,s1
    800013ac:	1602                	slli	a2,a2,0x20
    800013ae:	9201                	srli	a2,a2,0x20
    800013b0:	1582                	slli	a1,a1,0x20
    800013b2:	9181                	srli	a1,a1,0x20
    800013b4:	6928                	ld	a0,80(a0)
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	504080e7          	jalr	1284(ra) # 800008ba <uvmalloc>
    800013be:	0005061b          	sext.w	a2,a0
    800013c2:	fa69                	bnez	a2,80001394 <growproc+0x26>
      return -1;
    800013c4:	557d                	li	a0,-1
    800013c6:	bfe1                	j	8000139e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013c8:	9e25                	addw	a2,a2,s1
    800013ca:	1602                	slli	a2,a2,0x20
    800013cc:	9201                	srli	a2,a2,0x20
    800013ce:	1582                	slli	a1,a1,0x20
    800013d0:	9181                	srli	a1,a1,0x20
    800013d2:	6928                	ld	a0,80(a0)
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	49e080e7          	jalr	1182(ra) # 80000872 <uvmdealloc>
    800013dc:	0005061b          	sext.w	a2,a0
    800013e0:	bf55                	j	80001394 <growproc+0x26>

00000000800013e2 <fork>:
{
    800013e2:	7179                	addi	sp,sp,-48
    800013e4:	f406                	sd	ra,40(sp)
    800013e6:	f022                	sd	s0,32(sp)
    800013e8:	ec26                	sd	s1,24(sp)
    800013ea:	e84a                	sd	s2,16(sp)
    800013ec:	e44e                	sd	s3,8(sp)
    800013ee:	e052                	sd	s4,0(sp)
    800013f0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	b74080e7          	jalr	-1164(ra) # 80000f66 <myproc>
    800013fa:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	df8080e7          	jalr	-520(ra) # 800011f4 <allocproc>
    80001404:	10050b63          	beqz	a0,8000151a <fork+0x138>
    80001408:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000140a:	04893603          	ld	a2,72(s2)
    8000140e:	692c                	ld	a1,80(a0)
    80001410:	05093503          	ld	a0,80(s2)
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	6d2080e7          	jalr	1746(ra) # 80000ae6 <uvmcopy>
    8000141c:	04054663          	bltz	a0,80001468 <fork+0x86>
  np->sz = p->sz;
    80001420:	04893783          	ld	a5,72(s2)
    80001424:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001428:	05893683          	ld	a3,88(s2)
    8000142c:	87b6                	mv	a5,a3
    8000142e:	0589b703          	ld	a4,88(s3)
    80001432:	12068693          	addi	a3,a3,288
    80001436:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000143a:	6788                	ld	a0,8(a5)
    8000143c:	6b8c                	ld	a1,16(a5)
    8000143e:	6f90                	ld	a2,24(a5)
    80001440:	01073023          	sd	a6,0(a4)
    80001444:	e708                	sd	a0,8(a4)
    80001446:	eb0c                	sd	a1,16(a4)
    80001448:	ef10                	sd	a2,24(a4)
    8000144a:	02078793          	addi	a5,a5,32
    8000144e:	02070713          	addi	a4,a4,32
    80001452:	fed792e3          	bne	a5,a3,80001436 <fork+0x54>
  np->trapframe->a0 = 0;
    80001456:	0589b783          	ld	a5,88(s3)
    8000145a:	0607b823          	sd	zero,112(a5)
    8000145e:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001462:	15800a13          	li	s4,344
    80001466:	a03d                	j	80001494 <fork+0xb2>
    freeproc(np);
    80001468:	854e                	mv	a0,s3
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	d22080e7          	jalr	-734(ra) # 8000118c <freeproc>
    release(&np->lock);
    80001472:	854e                	mv	a0,s3
    80001474:	00005097          	auipc	ra,0x5
    80001478:	f52080e7          	jalr	-174(ra) # 800063c6 <release>
    return -1;
    8000147c:	5a7d                	li	s4,-1
    8000147e:	a069                	j	80001508 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001480:	00002097          	auipc	ra,0x2
    80001484:	6c8080e7          	jalr	1736(ra) # 80003b48 <filedup>
    80001488:	009987b3          	add	a5,s3,s1
    8000148c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000148e:	04a1                	addi	s1,s1,8
    80001490:	01448763          	beq	s1,s4,8000149e <fork+0xbc>
    if(p->ofile[i])
    80001494:	009907b3          	add	a5,s2,s1
    80001498:	6388                	ld	a0,0(a5)
    8000149a:	f17d                	bnez	a0,80001480 <fork+0x9e>
    8000149c:	bfcd                	j	8000148e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000149e:	15893503          	ld	a0,344(s2)
    800014a2:	00002097          	auipc	ra,0x2
    800014a6:	81c080e7          	jalr	-2020(ra) # 80002cbe <idup>
    800014aa:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014ae:	4641                	li	a2,16
    800014b0:	16090593          	addi	a1,s2,352
    800014b4:	16098513          	addi	a0,s3,352
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	e12080e7          	jalr	-494(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800014c0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014c4:	854e                	mv	a0,s3
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	f00080e7          	jalr	-256(ra) # 800063c6 <release>
  acquire(&wait_lock);
    800014ce:	00008497          	auipc	s1,0x8
    800014d2:	b9a48493          	addi	s1,s1,-1126 # 80009068 <wait_lock>
    800014d6:	8526                	mv	a0,s1
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	e3a080e7          	jalr	-454(ra) # 80006312 <acquire>
  np->parent = p;
    800014e0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014e4:	8526                	mv	a0,s1
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	ee0080e7          	jalr	-288(ra) # 800063c6 <release>
  acquire(&np->lock);
    800014ee:	854e                	mv	a0,s3
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	e22080e7          	jalr	-478(ra) # 80006312 <acquire>
  np->state = RUNNABLE;
    800014f8:	478d                	li	a5,3
    800014fa:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014fe:	854e                	mv	a0,s3
    80001500:	00005097          	auipc	ra,0x5
    80001504:	ec6080e7          	jalr	-314(ra) # 800063c6 <release>
}
    80001508:	8552                	mv	a0,s4
    8000150a:	70a2                	ld	ra,40(sp)
    8000150c:	7402                	ld	s0,32(sp)
    8000150e:	64e2                	ld	s1,24(sp)
    80001510:	6942                	ld	s2,16(sp)
    80001512:	69a2                	ld	s3,8(sp)
    80001514:	6a02                	ld	s4,0(sp)
    80001516:	6145                	addi	sp,sp,48
    80001518:	8082                	ret
    return -1;
    8000151a:	5a7d                	li	s4,-1
    8000151c:	b7f5                	j	80001508 <fork+0x126>

000000008000151e <scheduler>:
{
    8000151e:	7139                	addi	sp,sp,-64
    80001520:	fc06                	sd	ra,56(sp)
    80001522:	f822                	sd	s0,48(sp)
    80001524:	f426                	sd	s1,40(sp)
    80001526:	f04a                	sd	s2,32(sp)
    80001528:	ec4e                	sd	s3,24(sp)
    8000152a:	e852                	sd	s4,16(sp)
    8000152c:	e456                	sd	s5,8(sp)
    8000152e:	e05a                	sd	s6,0(sp)
    80001530:	0080                	addi	s0,sp,64
    80001532:	8792                	mv	a5,tp
  int id = r_tp();
    80001534:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001536:	00779a93          	slli	s5,a5,0x7
    8000153a:	00008717          	auipc	a4,0x8
    8000153e:	b1670713          	addi	a4,a4,-1258 # 80009050 <pid_lock>
    80001542:	9756                	add	a4,a4,s5
    80001544:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001548:	00008717          	auipc	a4,0x8
    8000154c:	b4070713          	addi	a4,a4,-1216 # 80009088 <cpus+0x8>
    80001550:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001552:	498d                	li	s3,3
        p->state = RUNNING;
    80001554:	4b11                	li	s6,4
        c->proc = p;
    80001556:	079e                	slli	a5,a5,0x7
    80001558:	00008a17          	auipc	s4,0x8
    8000155c:	af8a0a13          	addi	s4,s4,-1288 # 80009050 <pid_lock>
    80001560:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001562:	0000e917          	auipc	s2,0xe
    80001566:	b1e90913          	addi	s2,s2,-1250 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000156a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000156e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001572:	10079073          	csrw	sstatus,a5
    80001576:	00008497          	auipc	s1,0x8
    8000157a:	f0a48493          	addi	s1,s1,-246 # 80009480 <proc>
    8000157e:	a03d                	j	800015ac <scheduler+0x8e>
        p->state = RUNNING;
    80001580:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001584:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001588:	06848593          	addi	a1,s1,104
    8000158c:	8556                	mv	a0,s5
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	640080e7          	jalr	1600(ra) # 80001bce <swtch>
        c->proc = 0;
    80001596:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	e2a080e7          	jalr	-470(ra) # 800063c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015a4:	17048493          	addi	s1,s1,368
    800015a8:	fd2481e3          	beq	s1,s2,8000156a <scheduler+0x4c>
      acquire(&p->lock);
    800015ac:	8526                	mv	a0,s1
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	d64080e7          	jalr	-668(ra) # 80006312 <acquire>
      if(p->state == RUNNABLE) {
    800015b6:	4c9c                	lw	a5,24(s1)
    800015b8:	ff3791e3          	bne	a5,s3,8000159a <scheduler+0x7c>
    800015bc:	b7d1                	j	80001580 <scheduler+0x62>

00000000800015be <sched>:
{
    800015be:	7179                	addi	sp,sp,-48
    800015c0:	f406                	sd	ra,40(sp)
    800015c2:	f022                	sd	s0,32(sp)
    800015c4:	ec26                	sd	s1,24(sp)
    800015c6:	e84a                	sd	s2,16(sp)
    800015c8:	e44e                	sd	s3,8(sp)
    800015ca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	99a080e7          	jalr	-1638(ra) # 80000f66 <myproc>
    800015d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	cc2080e7          	jalr	-830(ra) # 80006298 <holding>
    800015de:	c93d                	beqz	a0,80001654 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	00008717          	auipc	a4,0x8
    800015ea:	a6a70713          	addi	a4,a4,-1430 # 80009050 <pid_lock>
    800015ee:	97ba                	add	a5,a5,a4
    800015f0:	0a87a703          	lw	a4,168(a5)
    800015f4:	4785                	li	a5,1
    800015f6:	06f71763          	bne	a4,a5,80001664 <sched+0xa6>
  if(p->state == RUNNING)
    800015fa:	4c98                	lw	a4,24(s1)
    800015fc:	4791                	li	a5,4
    800015fe:	06f70b63          	beq	a4,a5,80001674 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001602:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001606:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001608:	efb5                	bnez	a5,80001684 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000160a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000160c:	00008917          	auipc	s2,0x8
    80001610:	a4490913          	addi	s2,s2,-1468 # 80009050 <pid_lock>
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	97ca                	add	a5,a5,s2
    8000161a:	0ac7a983          	lw	s3,172(a5)
    8000161e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001620:	2781                	sext.w	a5,a5
    80001622:	079e                	slli	a5,a5,0x7
    80001624:	00008597          	auipc	a1,0x8
    80001628:	a6458593          	addi	a1,a1,-1436 # 80009088 <cpus+0x8>
    8000162c:	95be                	add	a1,a1,a5
    8000162e:	06848513          	addi	a0,s1,104
    80001632:	00000097          	auipc	ra,0x0
    80001636:	59c080e7          	jalr	1436(ra) # 80001bce <swtch>
    8000163a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000163c:	2781                	sext.w	a5,a5
    8000163e:	079e                	slli	a5,a5,0x7
    80001640:	97ca                	add	a5,a5,s2
    80001642:	0b37a623          	sw	s3,172(a5)
}
    80001646:	70a2                	ld	ra,40(sp)
    80001648:	7402                	ld	s0,32(sp)
    8000164a:	64e2                	ld	s1,24(sp)
    8000164c:	6942                	ld	s2,16(sp)
    8000164e:	69a2                	ld	s3,8(sp)
    80001650:	6145                	addi	sp,sp,48
    80001652:	8082                	ret
    panic("sched p->lock");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	bd450513          	addi	a0,a0,-1068 # 80008228 <pre.1602+0x60>
    8000165c:	00004097          	auipc	ra,0x4
    80001660:	76c080e7          	jalr	1900(ra) # 80005dc8 <panic>
    panic("sched locks");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	bd450513          	addi	a0,a0,-1068 # 80008238 <pre.1602+0x70>
    8000166c:	00004097          	auipc	ra,0x4
    80001670:	75c080e7          	jalr	1884(ra) # 80005dc8 <panic>
    panic("sched running");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	bd450513          	addi	a0,a0,-1068 # 80008248 <pre.1602+0x80>
    8000167c:	00004097          	auipc	ra,0x4
    80001680:	74c080e7          	jalr	1868(ra) # 80005dc8 <panic>
    panic("sched interruptible");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	bd450513          	addi	a0,a0,-1068 # 80008258 <pre.1602+0x90>
    8000168c:	00004097          	auipc	ra,0x4
    80001690:	73c080e7          	jalr	1852(ra) # 80005dc8 <panic>

0000000080001694 <yield>:
{
    80001694:	1101                	addi	sp,sp,-32
    80001696:	ec06                	sd	ra,24(sp)
    80001698:	e822                	sd	s0,16(sp)
    8000169a:	e426                	sd	s1,8(sp)
    8000169c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	8c8080e7          	jalr	-1848(ra) # 80000f66 <myproc>
    800016a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	c6a080e7          	jalr	-918(ra) # 80006312 <acquire>
  p->state = RUNNABLE;
    800016b0:	478d                	li	a5,3
    800016b2:	cc9c                	sw	a5,24(s1)
  sched();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	f0a080e7          	jalr	-246(ra) # 800015be <sched>
  release(&p->lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	d08080e7          	jalr	-760(ra) # 800063c6 <release>
}
    800016c6:	60e2                	ld	ra,24(sp)
    800016c8:	6442                	ld	s0,16(sp)
    800016ca:	64a2                	ld	s1,8(sp)
    800016cc:	6105                	addi	sp,sp,32
    800016ce:	8082                	ret

00000000800016d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016d0:	7179                	addi	sp,sp,-48
    800016d2:	f406                	sd	ra,40(sp)
    800016d4:	f022                	sd	s0,32(sp)
    800016d6:	ec26                	sd	s1,24(sp)
    800016d8:	e84a                	sd	s2,16(sp)
    800016da:	e44e                	sd	s3,8(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	89aa                	mv	s3,a0
    800016e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	884080e7          	jalr	-1916(ra) # 80000f66 <myproc>
    800016ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	c26080e7          	jalr	-986(ra) # 80006312 <acquire>
  release(lk);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	cd0080e7          	jalr	-816(ra) # 800063c6 <release>

  // Go to sleep.
  p->chan = chan;
    800016fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001702:	4789                	li	a5,2
    80001704:	cc9c                	sw	a5,24(s1)

  sched();
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	eb8080e7          	jalr	-328(ra) # 800015be <sched>

  // Tidy up.
  p->chan = 0;
    8000170e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	cb2080e7          	jalr	-846(ra) # 800063c6 <release>
  acquire(lk);
    8000171c:	854a                	mv	a0,s2
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	bf4080e7          	jalr	-1036(ra) # 80006312 <acquire>
}
    80001726:	70a2                	ld	ra,40(sp)
    80001728:	7402                	ld	s0,32(sp)
    8000172a:	64e2                	ld	s1,24(sp)
    8000172c:	6942                	ld	s2,16(sp)
    8000172e:	69a2                	ld	s3,8(sp)
    80001730:	6145                	addi	sp,sp,48
    80001732:	8082                	ret

0000000080001734 <wait>:
{
    80001734:	715d                	addi	sp,sp,-80
    80001736:	e486                	sd	ra,72(sp)
    80001738:	e0a2                	sd	s0,64(sp)
    8000173a:	fc26                	sd	s1,56(sp)
    8000173c:	f84a                	sd	s2,48(sp)
    8000173e:	f44e                	sd	s3,40(sp)
    80001740:	f052                	sd	s4,32(sp)
    80001742:	ec56                	sd	s5,24(sp)
    80001744:	e85a                	sd	s6,16(sp)
    80001746:	e45e                	sd	s7,8(sp)
    80001748:	e062                	sd	s8,0(sp)
    8000174a:	0880                	addi	s0,sp,80
    8000174c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	818080e7          	jalr	-2024(ra) # 80000f66 <myproc>
    80001756:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001758:	00008517          	auipc	a0,0x8
    8000175c:	91050513          	addi	a0,a0,-1776 # 80009068 <wait_lock>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	bb2080e7          	jalr	-1102(ra) # 80006312 <acquire>
    havekids = 0;
    80001768:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000176a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000176c:	0000e997          	auipc	s3,0xe
    80001770:	91498993          	addi	s3,s3,-1772 # 8000f080 <tickslock>
        havekids = 1;
    80001774:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001776:	00008c17          	auipc	s8,0x8
    8000177a:	8f2c0c13          	addi	s8,s8,-1806 # 80009068 <wait_lock>
    havekids = 0;
    8000177e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001780:	00008497          	auipc	s1,0x8
    80001784:	d0048493          	addi	s1,s1,-768 # 80009480 <proc>
    80001788:	a0bd                	j	800017f6 <wait+0xc2>
          pid = np->pid;
    8000178a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000178e:	000b0e63          	beqz	s6,800017aa <wait+0x76>
    80001792:	4691                	li	a3,4
    80001794:	02c48613          	addi	a2,s1,44
    80001798:	85da                	mv	a1,s6
    8000179a:	05093503          	ld	a0,80(s2)
    8000179e:	fffff097          	auipc	ra,0xfffff
    800017a2:	44c080e7          	jalr	1100(ra) # 80000bea <copyout>
    800017a6:	02054563          	bltz	a0,800017d0 <wait+0x9c>
          freeproc(np);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	9e0080e7          	jalr	-1568(ra) # 8000118c <freeproc>
          release(&np->lock);
    800017b4:	8526                	mv	a0,s1
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	c10080e7          	jalr	-1008(ra) # 800063c6 <release>
          release(&wait_lock);
    800017be:	00008517          	auipc	a0,0x8
    800017c2:	8aa50513          	addi	a0,a0,-1878 # 80009068 <wait_lock>
    800017c6:	00005097          	auipc	ra,0x5
    800017ca:	c00080e7          	jalr	-1024(ra) # 800063c6 <release>
          return pid;
    800017ce:	a09d                	j	80001834 <wait+0x100>
            release(&np->lock);
    800017d0:	8526                	mv	a0,s1
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	bf4080e7          	jalr	-1036(ra) # 800063c6 <release>
            release(&wait_lock);
    800017da:	00008517          	auipc	a0,0x8
    800017de:	88e50513          	addi	a0,a0,-1906 # 80009068 <wait_lock>
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	be4080e7          	jalr	-1052(ra) # 800063c6 <release>
            return -1;
    800017ea:	59fd                	li	s3,-1
    800017ec:	a0a1                	j	80001834 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ee:	17048493          	addi	s1,s1,368
    800017f2:	03348463          	beq	s1,s3,8000181a <wait+0xe6>
      if(np->parent == p){
    800017f6:	7c9c                	ld	a5,56(s1)
    800017f8:	ff279be3          	bne	a5,s2,800017ee <wait+0xba>
        acquire(&np->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	b14080e7          	jalr	-1260(ra) # 80006312 <acquire>
        if(np->state == ZOMBIE){
    80001806:	4c9c                	lw	a5,24(s1)
    80001808:	f94781e3          	beq	a5,s4,8000178a <wait+0x56>
        release(&np->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	bb8080e7          	jalr	-1096(ra) # 800063c6 <release>
        havekids = 1;
    80001816:	8756                	mv	a4,s5
    80001818:	bfd9                	j	800017ee <wait+0xba>
    if(!havekids || p->killed){
    8000181a:	c701                	beqz	a4,80001822 <wait+0xee>
    8000181c:	02892783          	lw	a5,40(s2)
    80001820:	c79d                	beqz	a5,8000184e <wait+0x11a>
      release(&wait_lock);
    80001822:	00008517          	auipc	a0,0x8
    80001826:	84650513          	addi	a0,a0,-1978 # 80009068 <wait_lock>
    8000182a:	00005097          	auipc	ra,0x5
    8000182e:	b9c080e7          	jalr	-1124(ra) # 800063c6 <release>
      return -1;
    80001832:	59fd                	li	s3,-1
}
    80001834:	854e                	mv	a0,s3
    80001836:	60a6                	ld	ra,72(sp)
    80001838:	6406                	ld	s0,64(sp)
    8000183a:	74e2                	ld	s1,56(sp)
    8000183c:	7942                	ld	s2,48(sp)
    8000183e:	79a2                	ld	s3,40(sp)
    80001840:	7a02                	ld	s4,32(sp)
    80001842:	6ae2                	ld	s5,24(sp)
    80001844:	6b42                	ld	s6,16(sp)
    80001846:	6ba2                	ld	s7,8(sp)
    80001848:	6c02                	ld	s8,0(sp)
    8000184a:	6161                	addi	sp,sp,80
    8000184c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000184e:	85e2                	mv	a1,s8
    80001850:	854a                	mv	a0,s2
    80001852:	00000097          	auipc	ra,0x0
    80001856:	e7e080e7          	jalr	-386(ra) # 800016d0 <sleep>
    havekids = 0;
    8000185a:	b715                	j	8000177e <wait+0x4a>

000000008000185c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000185c:	7139                	addi	sp,sp,-64
    8000185e:	fc06                	sd	ra,56(sp)
    80001860:	f822                	sd	s0,48(sp)
    80001862:	f426                	sd	s1,40(sp)
    80001864:	f04a                	sd	s2,32(sp)
    80001866:	ec4e                	sd	s3,24(sp)
    80001868:	e852                	sd	s4,16(sp)
    8000186a:	e456                	sd	s5,8(sp)
    8000186c:	0080                	addi	s0,sp,64
    8000186e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	00008497          	auipc	s1,0x8
    80001874:	c1048493          	addi	s1,s1,-1008 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001878:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000187a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	0000e917          	auipc	s2,0xe
    80001880:	80490913          	addi	s2,s2,-2044 # 8000f080 <tickslock>
    80001884:	a821                	j	8000189c <wakeup+0x40>
        p->state = RUNNABLE;
    80001886:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000188a:	8526                	mv	a0,s1
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	b3a080e7          	jalr	-1222(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001894:	17048493          	addi	s1,s1,368
    80001898:	03248463          	beq	s1,s2,800018c0 <wakeup+0x64>
    if(p != myproc()){
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	6ca080e7          	jalr	1738(ra) # 80000f66 <myproc>
    800018a4:	fea488e3          	beq	s1,a0,80001894 <wakeup+0x38>
      acquire(&p->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	a68080e7          	jalr	-1432(ra) # 80006312 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	fd379be3          	bne	a5,s3,8000188a <wakeup+0x2e>
    800018b8:	709c                	ld	a5,32(s1)
    800018ba:	fd4798e3          	bne	a5,s4,8000188a <wakeup+0x2e>
    800018be:	b7e1                	j	80001886 <wakeup+0x2a>
    }
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6121                	addi	sp,sp,64
    800018d0:	8082                	ret

00000000800018d2 <reparent>:
{
    800018d2:	7179                	addi	sp,sp,-48
    800018d4:	f406                	sd	ra,40(sp)
    800018d6:	f022                	sd	s0,32(sp)
    800018d8:	ec26                	sd	s1,24(sp)
    800018da:	e84a                	sd	s2,16(sp)
    800018dc:	e44e                	sd	s3,8(sp)
    800018de:	e052                	sd	s4,0(sp)
    800018e0:	1800                	addi	s0,sp,48
    800018e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	00008497          	auipc	s1,0x8
    800018e8:	b9c48493          	addi	s1,s1,-1124 # 80009480 <proc>
      pp->parent = initproc;
    800018ec:	00007a17          	auipc	s4,0x7
    800018f0:	724a0a13          	addi	s4,s4,1828 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	0000d997          	auipc	s3,0xd
    800018f8:	78c98993          	addi	s3,s3,1932 # 8000f080 <tickslock>
    800018fc:	a029                	j	80001906 <reparent+0x34>
    800018fe:	17048493          	addi	s1,s1,368
    80001902:	01348d63          	beq	s1,s3,8000191c <reparent+0x4a>
    if(pp->parent == p){
    80001906:	7c9c                	ld	a5,56(s1)
    80001908:	ff279be3          	bne	a5,s2,800018fe <reparent+0x2c>
      pp->parent = initproc;
    8000190c:	000a3503          	ld	a0,0(s4)
    80001910:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001912:	00000097          	auipc	ra,0x0
    80001916:	f4a080e7          	jalr	-182(ra) # 8000185c <wakeup>
    8000191a:	b7d5                	j	800018fe <reparent+0x2c>
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6a02                	ld	s4,0(sp)
    80001928:	6145                	addi	sp,sp,48
    8000192a:	8082                	ret

000000008000192c <exit>:
{
    8000192c:	7179                	addi	sp,sp,-48
    8000192e:	f406                	sd	ra,40(sp)
    80001930:	f022                	sd	s0,32(sp)
    80001932:	ec26                	sd	s1,24(sp)
    80001934:	e84a                	sd	s2,16(sp)
    80001936:	e44e                	sd	s3,8(sp)
    80001938:	e052                	sd	s4,0(sp)
    8000193a:	1800                	addi	s0,sp,48
    8000193c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	628080e7          	jalr	1576(ra) # 80000f66 <myproc>
    80001946:	89aa                	mv	s3,a0
  if(p == initproc)
    80001948:	00007797          	auipc	a5,0x7
    8000194c:	6c87b783          	ld	a5,1736(a5) # 80009010 <initproc>
    80001950:	0d850493          	addi	s1,a0,216
    80001954:	15850913          	addi	s2,a0,344
    80001958:	02a79363          	bne	a5,a0,8000197e <exit+0x52>
    panic("init exiting");
    8000195c:	00007517          	auipc	a0,0x7
    80001960:	91450513          	addi	a0,a0,-1772 # 80008270 <pre.1602+0xa8>
    80001964:	00004097          	auipc	ra,0x4
    80001968:	464080e7          	jalr	1124(ra) # 80005dc8 <panic>
      fileclose(f);
    8000196c:	00002097          	auipc	ra,0x2
    80001970:	22e080e7          	jalr	558(ra) # 80003b9a <fileclose>
      p->ofile[fd] = 0;
    80001974:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001978:	04a1                	addi	s1,s1,8
    8000197a:	01248563          	beq	s1,s2,80001984 <exit+0x58>
    if(p->ofile[fd]){
    8000197e:	6088                	ld	a0,0(s1)
    80001980:	f575                	bnez	a0,8000196c <exit+0x40>
    80001982:	bfdd                	j	80001978 <exit+0x4c>
  begin_op();
    80001984:	00002097          	auipc	ra,0x2
    80001988:	d4a080e7          	jalr	-694(ra) # 800036ce <begin_op>
  iput(p->cwd);
    8000198c:	1589b503          	ld	a0,344(s3)
    80001990:	00001097          	auipc	ra,0x1
    80001994:	526080e7          	jalr	1318(ra) # 80002eb6 <iput>
  end_op();
    80001998:	00002097          	auipc	ra,0x2
    8000199c:	db6080e7          	jalr	-586(ra) # 8000374e <end_op>
  p->cwd = 0;
    800019a0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019a4:	00007497          	auipc	s1,0x7
    800019a8:	6c448493          	addi	s1,s1,1732 # 80009068 <wait_lock>
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	964080e7          	jalr	-1692(ra) # 80006312 <acquire>
  reparent(p);
    800019b6:	854e                	mv	a0,s3
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	f1a080e7          	jalr	-230(ra) # 800018d2 <reparent>
  wakeup(p->parent);
    800019c0:	0389b503          	ld	a0,56(s3)
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	e98080e7          	jalr	-360(ra) # 8000185c <wakeup>
  acquire(&p->lock);
    800019cc:	854e                	mv	a0,s3
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	944080e7          	jalr	-1724(ra) # 80006312 <acquire>
  p->xstate = status;
    800019d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019da:	4795                	li	a5,5
    800019dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	9e4080e7          	jalr	-1564(ra) # 800063c6 <release>
  sched();
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	bd4080e7          	jalr	-1068(ra) # 800015be <sched>
  panic("zombie exit");
    800019f2:	00007517          	auipc	a0,0x7
    800019f6:	88e50513          	addi	a0,a0,-1906 # 80008280 <pre.1602+0xb8>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	3ce080e7          	jalr	974(ra) # 80005dc8 <panic>

0000000080001a02 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a02:	7179                	addi	sp,sp,-48
    80001a04:	f406                	sd	ra,40(sp)
    80001a06:	f022                	sd	s0,32(sp)
    80001a08:	ec26                	sd	s1,24(sp)
    80001a0a:	e84a                	sd	s2,16(sp)
    80001a0c:	e44e                	sd	s3,8(sp)
    80001a0e:	1800                	addi	s0,sp,48
    80001a10:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a12:	00008497          	auipc	s1,0x8
    80001a16:	a6e48493          	addi	s1,s1,-1426 # 80009480 <proc>
    80001a1a:	0000d997          	auipc	s3,0xd
    80001a1e:	66698993          	addi	s3,s3,1638 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	8ee080e7          	jalr	-1810(ra) # 80006312 <acquire>
    if(p->pid == pid){
    80001a2c:	589c                	lw	a5,48(s1)
    80001a2e:	01278d63          	beq	a5,s2,80001a48 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	992080e7          	jalr	-1646(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3c:	17048493          	addi	s1,s1,368
    80001a40:	ff3491e3          	bne	s1,s3,80001a22 <kill+0x20>
  }
  return -1;
    80001a44:	557d                	li	a0,-1
    80001a46:	a829                	j	80001a60 <kill+0x5e>
      p->killed = 1;
    80001a48:	4785                	li	a5,1
    80001a4a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a4c:	4c98                	lw	a4,24(s1)
    80001a4e:	4789                	li	a5,2
    80001a50:	00f70f63          	beq	a4,a5,80001a6e <kill+0x6c>
      release(&p->lock);
    80001a54:	8526                	mv	a0,s1
    80001a56:	00005097          	auipc	ra,0x5
    80001a5a:	970080e7          	jalr	-1680(ra) # 800063c6 <release>
      return 0;
    80001a5e:	4501                	li	a0,0
}
    80001a60:	70a2                	ld	ra,40(sp)
    80001a62:	7402                	ld	s0,32(sp)
    80001a64:	64e2                	ld	s1,24(sp)
    80001a66:	6942                	ld	s2,16(sp)
    80001a68:	69a2                	ld	s3,8(sp)
    80001a6a:	6145                	addi	sp,sp,48
    80001a6c:	8082                	ret
        p->state = RUNNABLE;
    80001a6e:	478d                	li	a5,3
    80001a70:	cc9c                	sw	a5,24(s1)
    80001a72:	b7cd                	j	80001a54 <kill+0x52>

0000000080001a74 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a74:	7179                	addi	sp,sp,-48
    80001a76:	f406                	sd	ra,40(sp)
    80001a78:	f022                	sd	s0,32(sp)
    80001a7a:	ec26                	sd	s1,24(sp)
    80001a7c:	e84a                	sd	s2,16(sp)
    80001a7e:	e44e                	sd	s3,8(sp)
    80001a80:	e052                	sd	s4,0(sp)
    80001a82:	1800                	addi	s0,sp,48
    80001a84:	84aa                	mv	s1,a0
    80001a86:	892e                	mv	s2,a1
    80001a88:	89b2                	mv	s3,a2
    80001a8a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	4da080e7          	jalr	1242(ra) # 80000f66 <myproc>
  if(user_dst){
    80001a94:	c08d                	beqz	s1,80001ab6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a96:	86d2                	mv	a3,s4
    80001a98:	864e                	mv	a2,s3
    80001a9a:	85ca                	mv	a1,s2
    80001a9c:	6928                	ld	a0,80(a0)
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	14c080e7          	jalr	332(ra) # 80000bea <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6a02                	ld	s4,0(sp)
    80001ab2:	6145                	addi	sp,sp,48
    80001ab4:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab6:	000a061b          	sext.w	a2,s4
    80001aba:	85ce                	mv	a1,s3
    80001abc:	854a                	mv	a0,s2
    80001abe:	ffffe097          	auipc	ra,0xffffe
    80001ac2:	71a080e7          	jalr	1818(ra) # 800001d8 <memmove>
    return 0;
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	bff9                	j	80001aa6 <either_copyout+0x32>

0000000080001aca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	892a                	mv	s2,a0
    80001adc:	84ae                	mv	s1,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	484080e7          	jalr	1156(ra) # 80000f66 <myproc>
  if(user_src){
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	182080e7          	jalr	386(ra) # 80000c76 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	6c4080e7          	jalr	1732(ra) # 800001d8 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyin+0x32>

0000000080001b20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b20:	715d                	addi	sp,sp,-80
    80001b22:	e486                	sd	ra,72(sp)
    80001b24:	e0a2                	sd	s0,64(sp)
    80001b26:	fc26                	sd	s1,56(sp)
    80001b28:	f84a                	sd	s2,48(sp)
    80001b2a:	f44e                	sd	s3,40(sp)
    80001b2c:	f052                	sd	s4,32(sp)
    80001b2e:	ec56                	sd	s5,24(sp)
    80001b30:	e85a                	sd	s6,16(sp)
    80001b32:	e45e                	sd	s7,8(sp)
    80001b34:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b36:	00006517          	auipc	a0,0x6
    80001b3a:	51250513          	addi	a0,a0,1298 # 80008048 <etext+0x48>
    80001b3e:	00004097          	auipc	ra,0x4
    80001b42:	2d4080e7          	jalr	724(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b46:	00008497          	auipc	s1,0x8
    80001b4a:	a9a48493          	addi	s1,s1,-1382 # 800095e0 <proc+0x160>
    80001b4e:	0000d917          	auipc	s2,0xd
    80001b52:	69290913          	addi	s2,s2,1682 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b56:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b58:	00006997          	auipc	s3,0x6
    80001b5c:	73898993          	addi	s3,s3,1848 # 80008290 <pre.1602+0xc8>
    printf("%d %s %s", p->pid, state, p->name);
    80001b60:	00006a97          	auipc	s5,0x6
    80001b64:	738a8a93          	addi	s5,s5,1848 # 80008298 <pre.1602+0xd0>
    printf("\n");
    80001b68:	00006a17          	auipc	s4,0x6
    80001b6c:	4e0a0a13          	addi	s4,s4,1248 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b70:	00006b97          	auipc	s7,0x6
    80001b74:	760b8b93          	addi	s7,s7,1888 # 800082d0 <states.1720>
    80001b78:	a00d                	j	80001b9a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7a:	ed06a583          	lw	a1,-304(a3)
    80001b7e:	8556                	mv	a0,s5
    80001b80:	00004097          	auipc	ra,0x4
    80001b84:	292080e7          	jalr	658(ra) # 80005e12 <printf>
    printf("\n");
    80001b88:	8552                	mv	a0,s4
    80001b8a:	00004097          	auipc	ra,0x4
    80001b8e:	288080e7          	jalr	648(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b92:	17048493          	addi	s1,s1,368
    80001b96:	03248163          	beq	s1,s2,80001bb8 <procdump+0x98>
    if(p->state == UNUSED)
    80001b9a:	86a6                	mv	a3,s1
    80001b9c:	eb84a783          	lw	a5,-328(s1)
    80001ba0:	dbed                	beqz	a5,80001b92 <procdump+0x72>
      state = "???";
    80001ba2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba4:	fcfb6be3          	bltu	s6,a5,80001b7a <procdump+0x5a>
    80001ba8:	1782                	slli	a5,a5,0x20
    80001baa:	9381                	srli	a5,a5,0x20
    80001bac:	078e                	slli	a5,a5,0x3
    80001bae:	97de                	add	a5,a5,s7
    80001bb0:	6390                	ld	a2,0(a5)
    80001bb2:	f661                	bnez	a2,80001b7a <procdump+0x5a>
      state = "???";
    80001bb4:	864e                	mv	a2,s3
    80001bb6:	b7d1                	j	80001b7a <procdump+0x5a>
  }
}
    80001bb8:	60a6                	ld	ra,72(sp)
    80001bba:	6406                	ld	s0,64(sp)
    80001bbc:	74e2                	ld	s1,56(sp)
    80001bbe:	7942                	ld	s2,48(sp)
    80001bc0:	79a2                	ld	s3,40(sp)
    80001bc2:	7a02                	ld	s4,32(sp)
    80001bc4:	6ae2                	ld	s5,24(sp)
    80001bc6:	6b42                	ld	s6,16(sp)
    80001bc8:	6ba2                	ld	s7,8(sp)
    80001bca:	6161                	addi	sp,sp,80
    80001bcc:	8082                	ret

0000000080001bce <swtch>:
    80001bce:	00153023          	sd	ra,0(a0)
    80001bd2:	00253423          	sd	sp,8(a0)
    80001bd6:	e900                	sd	s0,16(a0)
    80001bd8:	ed04                	sd	s1,24(a0)
    80001bda:	03253023          	sd	s2,32(a0)
    80001bde:	03353423          	sd	s3,40(a0)
    80001be2:	03453823          	sd	s4,48(a0)
    80001be6:	03553c23          	sd	s5,56(a0)
    80001bea:	05653023          	sd	s6,64(a0)
    80001bee:	05753423          	sd	s7,72(a0)
    80001bf2:	05853823          	sd	s8,80(a0)
    80001bf6:	05953c23          	sd	s9,88(a0)
    80001bfa:	07a53023          	sd	s10,96(a0)
    80001bfe:	07b53423          	sd	s11,104(a0)
    80001c02:	0005b083          	ld	ra,0(a1)
    80001c06:	0085b103          	ld	sp,8(a1)
    80001c0a:	6980                	ld	s0,16(a1)
    80001c0c:	6d84                	ld	s1,24(a1)
    80001c0e:	0205b903          	ld	s2,32(a1)
    80001c12:	0285b983          	ld	s3,40(a1)
    80001c16:	0305ba03          	ld	s4,48(a1)
    80001c1a:	0385ba83          	ld	s5,56(a1)
    80001c1e:	0405bb03          	ld	s6,64(a1)
    80001c22:	0485bb83          	ld	s7,72(a1)
    80001c26:	0505bc03          	ld	s8,80(a1)
    80001c2a:	0585bc83          	ld	s9,88(a1)
    80001c2e:	0605bd03          	ld	s10,96(a1)
    80001c32:	0685bd83          	ld	s11,104(a1)
    80001c36:	8082                	ret

0000000080001c38 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c38:	1141                	addi	sp,sp,-16
    80001c3a:	e406                	sd	ra,8(sp)
    80001c3c:	e022                	sd	s0,0(sp)
    80001c3e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c40:	00006597          	auipc	a1,0x6
    80001c44:	6c058593          	addi	a1,a1,1728 # 80008300 <states.1720+0x30>
    80001c48:	0000d517          	auipc	a0,0xd
    80001c4c:	43850513          	addi	a0,a0,1080 # 8000f080 <tickslock>
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	632080e7          	jalr	1586(ra) # 80006282 <initlock>
}
    80001c58:	60a2                	ld	ra,8(sp)
    80001c5a:	6402                	ld	s0,0(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret

0000000080001c60 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c60:	1141                	addi	sp,sp,-16
    80001c62:	e422                	sd	s0,8(sp)
    80001c64:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c66:	00003797          	auipc	a5,0x3
    80001c6a:	56a78793          	addi	a5,a5,1386 # 800051d0 <kernelvec>
    80001c6e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c72:	6422                	ld	s0,8(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret

0000000080001c78 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e406                	sd	ra,8(sp)
    80001c7c:	e022                	sd	s0,0(sp)
    80001c7e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	2e6080e7          	jalr	742(ra) # 80000f66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c88:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c8c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c92:	00005617          	auipc	a2,0x5
    80001c96:	36e60613          	addi	a2,a2,878 # 80007000 <_trampoline>
    80001c9a:	00005697          	auipc	a3,0x5
    80001c9e:	36668693          	addi	a3,a3,870 # 80007000 <_trampoline>
    80001ca2:	8e91                	sub	a3,a3,a2
    80001ca4:	040007b7          	lui	a5,0x4000
    80001ca8:	17fd                	addi	a5,a5,-1
    80001caa:	07b2                	slli	a5,a5,0xc
    80001cac:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cae:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cb2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb4:	180026f3          	csrr	a3,satp
    80001cb8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cba:	6d38                	ld	a4,88(a0)
    80001cbc:	6134                	ld	a3,64(a0)
    80001cbe:	6585                	lui	a1,0x1
    80001cc0:	96ae                	add	a3,a3,a1
    80001cc2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc4:	6d38                	ld	a4,88(a0)
    80001cc6:	00000697          	auipc	a3,0x0
    80001cca:	13868693          	addi	a3,a3,312 # 80001dfe <usertrap>
    80001cce:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cd0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd2:	8692                	mv	a3,tp
    80001cd4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd6:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cda:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cde:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ce8:	6f18                	ld	a4,24(a4)
    80001cea:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cee:	692c                	ld	a1,80(a0)
    80001cf0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cf2:	00005717          	auipc	a4,0x5
    80001cf6:	39e70713          	addi	a4,a4,926 # 80007090 <userret>
    80001cfa:	8f11                	sub	a4,a4,a2
    80001cfc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cfe:	577d                	li	a4,-1
    80001d00:	177e                	slli	a4,a4,0x3f
    80001d02:	8dd9                	or	a1,a1,a4
    80001d04:	02000537          	lui	a0,0x2000
    80001d08:	157d                	addi	a0,a0,-1
    80001d0a:	0536                	slli	a0,a0,0xd
    80001d0c:	9782                	jalr	a5
}
    80001d0e:	60a2                	ld	ra,8(sp)
    80001d10:	6402                	ld	s0,0(sp)
    80001d12:	0141                	addi	sp,sp,16
    80001d14:	8082                	ret

0000000080001d16 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	e426                	sd	s1,8(sp)
    80001d1e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d20:	0000d497          	auipc	s1,0xd
    80001d24:	36048493          	addi	s1,s1,864 # 8000f080 <tickslock>
    80001d28:	8526                	mv	a0,s1
    80001d2a:	00004097          	auipc	ra,0x4
    80001d2e:	5e8080e7          	jalr	1512(ra) # 80006312 <acquire>
  ticks++;
    80001d32:	00007517          	auipc	a0,0x7
    80001d36:	2e650513          	addi	a0,a0,742 # 80009018 <ticks>
    80001d3a:	411c                	lw	a5,0(a0)
    80001d3c:	2785                	addiw	a5,a5,1
    80001d3e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	b1c080e7          	jalr	-1252(ra) # 8000185c <wakeup>
  release(&tickslock);
    80001d48:	8526                	mv	a0,s1
    80001d4a:	00004097          	auipc	ra,0x4
    80001d4e:	67c080e7          	jalr	1660(ra) # 800063c6 <release>
}
    80001d52:	60e2                	ld	ra,24(sp)
    80001d54:	6442                	ld	s0,16(sp)
    80001d56:	64a2                	ld	s1,8(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret

0000000080001d5c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d66:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d6a:	00074d63          	bltz	a4,80001d84 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d6e:	57fd                	li	a5,-1
    80001d70:	17fe                	slli	a5,a5,0x3f
    80001d72:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d74:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d76:	06f70363          	beq	a4,a5,80001ddc <devintr+0x80>
  }
}
    80001d7a:	60e2                	ld	ra,24(sp)
    80001d7c:	6442                	ld	s0,16(sp)
    80001d7e:	64a2                	ld	s1,8(sp)
    80001d80:	6105                	addi	sp,sp,32
    80001d82:	8082                	ret
     (scause & 0xff) == 9){
    80001d84:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d88:	46a5                	li	a3,9
    80001d8a:	fed792e3          	bne	a5,a3,80001d6e <devintr+0x12>
    int irq = plic_claim();
    80001d8e:	00003097          	auipc	ra,0x3
    80001d92:	54a080e7          	jalr	1354(ra) # 800052d8 <plic_claim>
    80001d96:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d98:	47a9                	li	a5,10
    80001d9a:	02f50763          	beq	a0,a5,80001dc8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d9e:	4785                	li	a5,1
    80001da0:	02f50963          	beq	a0,a5,80001dd2 <devintr+0x76>
    return 1;
    80001da4:	4505                	li	a0,1
    } else if(irq){
    80001da6:	d8f1                	beqz	s1,80001d7a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001da8:	85a6                	mv	a1,s1
    80001daa:	00006517          	auipc	a0,0x6
    80001dae:	55e50513          	addi	a0,a0,1374 # 80008308 <states.1720+0x38>
    80001db2:	00004097          	auipc	ra,0x4
    80001db6:	060080e7          	jalr	96(ra) # 80005e12 <printf>
      plic_complete(irq);
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00003097          	auipc	ra,0x3
    80001dc0:	540080e7          	jalr	1344(ra) # 800052fc <plic_complete>
    return 1;
    80001dc4:	4505                	li	a0,1
    80001dc6:	bf55                	j	80001d7a <devintr+0x1e>
      uartintr();
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	46a080e7          	jalr	1130(ra) # 80006232 <uartintr>
    80001dd0:	b7ed                	j	80001dba <devintr+0x5e>
      virtio_disk_intr();
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	a0a080e7          	jalr	-1526(ra) # 800057dc <virtio_disk_intr>
    80001dda:	b7c5                	j	80001dba <devintr+0x5e>
    if(cpuid() == 0){
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	15e080e7          	jalr	350(ra) # 80000f3a <cpuid>
    80001de4:	c901                	beqz	a0,80001df4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001de6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dea:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dec:	14479073          	csrw	sip,a5
    return 2;
    80001df0:	4509                	li	a0,2
    80001df2:	b761                	j	80001d7a <devintr+0x1e>
      clockintr();
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	f22080e7          	jalr	-222(ra) # 80001d16 <clockintr>
    80001dfc:	b7ed                	j	80001de6 <devintr+0x8a>

0000000080001dfe <usertrap>:
{
    80001dfe:	1101                	addi	sp,sp,-32
    80001e00:	ec06                	sd	ra,24(sp)
    80001e02:	e822                	sd	s0,16(sp)
    80001e04:	e426                	sd	s1,8(sp)
    80001e06:	e04a                	sd	s2,0(sp)
    80001e08:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e0e:	1007f793          	andi	a5,a5,256
    80001e12:	e3ad                	bnez	a5,80001e74 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e14:	00003797          	auipc	a5,0x3
    80001e18:	3bc78793          	addi	a5,a5,956 # 800051d0 <kernelvec>
    80001e1c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	146080e7          	jalr	326(ra) # 80000f66 <myproc>
    80001e28:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e2a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	14102773          	csrr	a4,sepc
    80001e30:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e32:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e36:	47a1                	li	a5,8
    80001e38:	04f71c63          	bne	a4,a5,80001e90 <usertrap+0x92>
    if(p->killed)
    80001e3c:	551c                	lw	a5,40(a0)
    80001e3e:	e3b9                	bnez	a5,80001e84 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e40:	6cb8                	ld	a4,88(s1)
    80001e42:	6f1c                	ld	a5,24(a4)
    80001e44:	0791                	addi	a5,a5,4
    80001e46:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e4c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e50:	10079073          	csrw	sstatus,a5
    syscall();
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	2e0080e7          	jalr	736(ra) # 80002134 <syscall>
  if(p->killed)
    80001e5c:	549c                	lw	a5,40(s1)
    80001e5e:	ebc1                	bnez	a5,80001eee <usertrap+0xf0>
  usertrapret();
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	e18080e7          	jalr	-488(ra) # 80001c78 <usertrapret>
}
    80001e68:	60e2                	ld	ra,24(sp)
    80001e6a:	6442                	ld	s0,16(sp)
    80001e6c:	64a2                	ld	s1,8(sp)
    80001e6e:	6902                	ld	s2,0(sp)
    80001e70:	6105                	addi	sp,sp,32
    80001e72:	8082                	ret
    panic("usertrap: not from user mode");
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	4b450513          	addi	a0,a0,1204 # 80008328 <states.1720+0x58>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	f4c080e7          	jalr	-180(ra) # 80005dc8 <panic>
      exit(-1);
    80001e84:	557d                	li	a0,-1
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	aa6080e7          	jalr	-1370(ra) # 8000192c <exit>
    80001e8e:	bf4d                	j	80001e40 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	ecc080e7          	jalr	-308(ra) # 80001d5c <devintr>
    80001e98:	892a                	mv	s2,a0
    80001e9a:	c501                	beqz	a0,80001ea2 <usertrap+0xa4>
  if(p->killed)
    80001e9c:	549c                	lw	a5,40(s1)
    80001e9e:	c3a1                	beqz	a5,80001ede <usertrap+0xe0>
    80001ea0:	a815                	j	80001ed4 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ea6:	5890                	lw	a2,48(s1)
    80001ea8:	00006517          	auipc	a0,0x6
    80001eac:	4a050513          	addi	a0,a0,1184 # 80008348 <states.1720+0x78>
    80001eb0:	00004097          	auipc	ra,0x4
    80001eb4:	f62080e7          	jalr	-158(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eb8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ebc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec0:	00006517          	auipc	a0,0x6
    80001ec4:	4b850513          	addi	a0,a0,1208 # 80008378 <states.1720+0xa8>
    80001ec8:	00004097          	auipc	ra,0x4
    80001ecc:	f4a080e7          	jalr	-182(ra) # 80005e12 <printf>
    p->killed = 1;
    80001ed0:	4785                	li	a5,1
    80001ed2:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ed4:	557d                	li	a0,-1
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	a56080e7          	jalr	-1450(ra) # 8000192c <exit>
  if(which_dev == 2)
    80001ede:	4789                	li	a5,2
    80001ee0:	f8f910e3          	bne	s2,a5,80001e60 <usertrap+0x62>
    yield();
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	7b0080e7          	jalr	1968(ra) # 80001694 <yield>
    80001eec:	bf95                	j	80001e60 <usertrap+0x62>
  int which_dev = 0;
    80001eee:	4901                	li	s2,0
    80001ef0:	b7d5                	j	80001ed4 <usertrap+0xd6>

0000000080001ef2 <kerneltrap>:
{
    80001ef2:	7179                	addi	sp,sp,-48
    80001ef4:	f406                	sd	ra,40(sp)
    80001ef6:	f022                	sd	s0,32(sp)
    80001ef8:	ec26                	sd	s1,24(sp)
    80001efa:	e84a                	sd	s2,16(sp)
    80001efc:	e44e                	sd	s3,8(sp)
    80001efe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f00:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f04:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f08:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f0c:	1004f793          	andi	a5,s1,256
    80001f10:	cb85                	beqz	a5,80001f40 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f12:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f16:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f18:	ef85                	bnez	a5,80001f50 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	e42080e7          	jalr	-446(ra) # 80001d5c <devintr>
    80001f22:	cd1d                	beqz	a0,80001f60 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f24:	4789                	li	a5,2
    80001f26:	06f50a63          	beq	a0,a5,80001f9a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f2a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f2e:	10049073          	csrw	sstatus,s1
}
    80001f32:	70a2                	ld	ra,40(sp)
    80001f34:	7402                	ld	s0,32(sp)
    80001f36:	64e2                	ld	s1,24(sp)
    80001f38:	6942                	ld	s2,16(sp)
    80001f3a:	69a2                	ld	s3,8(sp)
    80001f3c:	6145                	addi	sp,sp,48
    80001f3e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	45850513          	addi	a0,a0,1112 # 80008398 <states.1720+0xc8>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	e80080e7          	jalr	-384(ra) # 80005dc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f50:	00006517          	auipc	a0,0x6
    80001f54:	47050513          	addi	a0,a0,1136 # 800083c0 <states.1720+0xf0>
    80001f58:	00004097          	auipc	ra,0x4
    80001f5c:	e70080e7          	jalr	-400(ra) # 80005dc8 <panic>
    printf("scause %p\n", scause);
    80001f60:	85ce                	mv	a1,s3
    80001f62:	00006517          	auipc	a0,0x6
    80001f66:	47e50513          	addi	a0,a0,1150 # 800083e0 <states.1720+0x110>
    80001f6a:	00004097          	auipc	ra,0x4
    80001f6e:	ea8080e7          	jalr	-344(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f72:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f76:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f7a:	00006517          	auipc	a0,0x6
    80001f7e:	47650513          	addi	a0,a0,1142 # 800083f0 <states.1720+0x120>
    80001f82:	00004097          	auipc	ra,0x4
    80001f86:	e90080e7          	jalr	-368(ra) # 80005e12 <printf>
    panic("kerneltrap");
    80001f8a:	00006517          	auipc	a0,0x6
    80001f8e:	47e50513          	addi	a0,a0,1150 # 80008408 <states.1720+0x138>
    80001f92:	00004097          	auipc	ra,0x4
    80001f96:	e36080e7          	jalr	-458(ra) # 80005dc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	fcc080e7          	jalr	-52(ra) # 80000f66 <myproc>
    80001fa2:	d541                	beqz	a0,80001f2a <kerneltrap+0x38>
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	fc2080e7          	jalr	-62(ra) # 80000f66 <myproc>
    80001fac:	4d18                	lw	a4,24(a0)
    80001fae:	4791                	li	a5,4
    80001fb0:	f6f71de3          	bne	a4,a5,80001f2a <kerneltrap+0x38>
    yield();
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	6e0080e7          	jalr	1760(ra) # 80001694 <yield>
    80001fbc:	b7bd                	j	80001f2a <kerneltrap+0x38>

0000000080001fbe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	1000                	addi	s0,sp,32
    80001fc8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	f9c080e7          	jalr	-100(ra) # 80000f66 <myproc>
  switch (n) {
    80001fd2:	4795                	li	a5,5
    80001fd4:	0497e163          	bltu	a5,s1,80002016 <argraw+0x58>
    80001fd8:	048a                	slli	s1,s1,0x2
    80001fda:	00006717          	auipc	a4,0x6
    80001fde:	46670713          	addi	a4,a4,1126 # 80008440 <states.1720+0x170>
    80001fe2:	94ba                	add	s1,s1,a4
    80001fe4:	409c                	lw	a5,0(s1)
    80001fe6:	97ba                	add	a5,a5,a4
    80001fe8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fee:	60e2                	ld	ra,24(sp)
    80001ff0:	6442                	ld	s0,16(sp)
    80001ff2:	64a2                	ld	s1,8(sp)
    80001ff4:	6105                	addi	sp,sp,32
    80001ff6:	8082                	ret
    return p->trapframe->a1;
    80001ff8:	6d3c                	ld	a5,88(a0)
    80001ffa:	7fa8                	ld	a0,120(a5)
    80001ffc:	bfcd                	j	80001fee <argraw+0x30>
    return p->trapframe->a2;
    80001ffe:	6d3c                	ld	a5,88(a0)
    80002000:	63c8                	ld	a0,128(a5)
    80002002:	b7f5                	j	80001fee <argraw+0x30>
    return p->trapframe->a3;
    80002004:	6d3c                	ld	a5,88(a0)
    80002006:	67c8                	ld	a0,136(a5)
    80002008:	b7dd                	j	80001fee <argraw+0x30>
    return p->trapframe->a4;
    8000200a:	6d3c                	ld	a5,88(a0)
    8000200c:	6bc8                	ld	a0,144(a5)
    8000200e:	b7c5                	j	80001fee <argraw+0x30>
    return p->trapframe->a5;
    80002010:	6d3c                	ld	a5,88(a0)
    80002012:	6fc8                	ld	a0,152(a5)
    80002014:	bfe9                	j	80001fee <argraw+0x30>
  panic("argraw");
    80002016:	00006517          	auipc	a0,0x6
    8000201a:	40250513          	addi	a0,a0,1026 # 80008418 <states.1720+0x148>
    8000201e:	00004097          	auipc	ra,0x4
    80002022:	daa080e7          	jalr	-598(ra) # 80005dc8 <panic>

0000000080002026 <fetchaddr>:
{
    80002026:	1101                	addi	sp,sp,-32
    80002028:	ec06                	sd	ra,24(sp)
    8000202a:	e822                	sd	s0,16(sp)
    8000202c:	e426                	sd	s1,8(sp)
    8000202e:	e04a                	sd	s2,0(sp)
    80002030:	1000                	addi	s0,sp,32
    80002032:	84aa                	mv	s1,a0
    80002034:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	f30080e7          	jalr	-208(ra) # 80000f66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000203e:	653c                	ld	a5,72(a0)
    80002040:	02f4f863          	bgeu	s1,a5,80002070 <fetchaddr+0x4a>
    80002044:	00848713          	addi	a4,s1,8
    80002048:	02e7e663          	bltu	a5,a4,80002074 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000204c:	46a1                	li	a3,8
    8000204e:	8626                	mv	a2,s1
    80002050:	85ca                	mv	a1,s2
    80002052:	6928                	ld	a0,80(a0)
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	c22080e7          	jalr	-990(ra) # 80000c76 <copyin>
    8000205c:	00a03533          	snez	a0,a0
    80002060:	40a00533          	neg	a0,a0
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6902                	ld	s2,0(sp)
    8000206c:	6105                	addi	sp,sp,32
    8000206e:	8082                	ret
    return -1;
    80002070:	557d                	li	a0,-1
    80002072:	bfcd                	j	80002064 <fetchaddr+0x3e>
    80002074:	557d                	li	a0,-1
    80002076:	b7fd                	j	80002064 <fetchaddr+0x3e>

0000000080002078 <fetchstr>:
{
    80002078:	7179                	addi	sp,sp,-48
    8000207a:	f406                	sd	ra,40(sp)
    8000207c:	f022                	sd	s0,32(sp)
    8000207e:	ec26                	sd	s1,24(sp)
    80002080:	e84a                	sd	s2,16(sp)
    80002082:	e44e                	sd	s3,8(sp)
    80002084:	1800                	addi	s0,sp,48
    80002086:	892a                	mv	s2,a0
    80002088:	84ae                	mv	s1,a1
    8000208a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	eda080e7          	jalr	-294(ra) # 80000f66 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002094:	86ce                	mv	a3,s3
    80002096:	864a                	mv	a2,s2
    80002098:	85a6                	mv	a1,s1
    8000209a:	6928                	ld	a0,80(a0)
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	c66080e7          	jalr	-922(ra) # 80000d02 <copyinstr>
  if(err < 0)
    800020a4:	00054763          	bltz	a0,800020b2 <fetchstr+0x3a>
  return strlen(buf);
    800020a8:	8526                	mv	a0,s1
    800020aa:	ffffe097          	auipc	ra,0xffffe
    800020ae:	252080e7          	jalr	594(ra) # 800002fc <strlen>
}
    800020b2:	70a2                	ld	ra,40(sp)
    800020b4:	7402                	ld	s0,32(sp)
    800020b6:	64e2                	ld	s1,24(sp)
    800020b8:	6942                	ld	s2,16(sp)
    800020ba:	69a2                	ld	s3,8(sp)
    800020bc:	6145                	addi	sp,sp,48
    800020be:	8082                	ret

00000000800020c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	1000                	addi	s0,sp,32
    800020ca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	ef2080e7          	jalr	-270(ra) # 80001fbe <argraw>
    800020d4:	c088                	sw	a0,0(s1)
  return 0;
}
    800020d6:	4501                	li	a0,0
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	1000                	addi	s0,sp,32
    800020ec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ee:	00000097          	auipc	ra,0x0
    800020f2:	ed0080e7          	jalr	-304(ra) # 80001fbe <argraw>
    800020f6:	e088                	sd	a0,0(s1)
  return 0;
}
    800020f8:	4501                	li	a0,0
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	64a2                	ld	s1,8(sp)
    80002100:	6105                	addi	sp,sp,32
    80002102:	8082                	ret

0000000080002104 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	e426                	sd	s1,8(sp)
    8000210c:	e04a                	sd	s2,0(sp)
    8000210e:	1000                	addi	s0,sp,32
    80002110:	84ae                	mv	s1,a1
    80002112:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002114:	00000097          	auipc	ra,0x0
    80002118:	eaa080e7          	jalr	-342(ra) # 80001fbe <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000211c:	864a                	mv	a2,s2
    8000211e:	85a6                	mv	a1,s1
    80002120:	00000097          	auipc	ra,0x0
    80002124:	f58080e7          	jalr	-168(ra) # 80002078 <fetchstr>
}
    80002128:	60e2                	ld	ra,24(sp)
    8000212a:	6442                	ld	s0,16(sp)
    8000212c:	64a2                	ld	s1,8(sp)
    8000212e:	6902                	ld	s2,0(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <syscall>:



void
syscall(void)
{
    80002134:	1101                	addi	sp,sp,-32
    80002136:	ec06                	sd	ra,24(sp)
    80002138:	e822                	sd	s0,16(sp)
    8000213a:	e426                	sd	s1,8(sp)
    8000213c:	e04a                	sd	s2,0(sp)
    8000213e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	e26080e7          	jalr	-474(ra) # 80000f66 <myproc>
    80002148:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000214a:	05853903          	ld	s2,88(a0)
    8000214e:	0a893783          	ld	a5,168(s2)
    80002152:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002156:	37fd                	addiw	a5,a5,-1
    80002158:	4775                	li	a4,29
    8000215a:	00f76f63          	bltu	a4,a5,80002178 <syscall+0x44>
    8000215e:	00369713          	slli	a4,a3,0x3
    80002162:	00006797          	auipc	a5,0x6
    80002166:	2f678793          	addi	a5,a5,758 # 80008458 <syscalls>
    8000216a:	97ba                	add	a5,a5,a4
    8000216c:	639c                	ld	a5,0(a5)
    8000216e:	c789                	beqz	a5,80002178 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002170:	9782                	jalr	a5
    80002172:	06a93823          	sd	a0,112(s2)
    80002176:	a839                	j	80002194 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002178:	16048613          	addi	a2,s1,352
    8000217c:	588c                	lw	a1,48(s1)
    8000217e:	00006517          	auipc	a0,0x6
    80002182:	2a250513          	addi	a0,a0,674 # 80008420 <states.1720+0x150>
    80002186:	00004097          	auipc	ra,0x4
    8000218a:	c8c080e7          	jalr	-884(ra) # 80005e12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000218e:	6cbc                	ld	a5,88(s1)
    80002190:	577d                	li	a4,-1
    80002192:	fbb8                	sd	a4,112(a5)
  }
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021a8:	fec40593          	addi	a1,s0,-20
    800021ac:	4501                	li	a0,0
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	f12080e7          	jalr	-238(ra) # 800020c0 <argint>
    return -1;
    800021b6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021b8:	00054963          	bltz	a0,800021ca <sys_exit+0x2a>
  exit(n);
    800021bc:	fec42503          	lw	a0,-20(s0)
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	76c080e7          	jalr	1900(ra) # 8000192c <exit>
  return 0;  // not reached
    800021c8:	4781                	li	a5,0
}
    800021ca:	853e                	mv	a0,a5
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021d4:	1141                	addi	sp,sp,-16
    800021d6:	e406                	sd	ra,8(sp)
    800021d8:	e022                	sd	s0,0(sp)
    800021da:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	d8a080e7          	jalr	-630(ra) # 80000f66 <myproc>
}
    800021e4:	5908                	lw	a0,48(a0)
    800021e6:	60a2                	ld	ra,8(sp)
    800021e8:	6402                	ld	s0,0(sp)
    800021ea:	0141                	addi	sp,sp,16
    800021ec:	8082                	ret

00000000800021ee <sys_fork>:

uint64
sys_fork(void)
{
    800021ee:	1141                	addi	sp,sp,-16
    800021f0:	e406                	sd	ra,8(sp)
    800021f2:	e022                	sd	s0,0(sp)
    800021f4:	0800                	addi	s0,sp,16
  return fork();
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	1ec080e7          	jalr	492(ra) # 800013e2 <fork>
}
    800021fe:	60a2                	ld	ra,8(sp)
    80002200:	6402                	ld	s0,0(sp)
    80002202:	0141                	addi	sp,sp,16
    80002204:	8082                	ret

0000000080002206 <sys_wait>:

uint64
sys_wait(void)
{
    80002206:	1101                	addi	sp,sp,-32
    80002208:	ec06                	sd	ra,24(sp)
    8000220a:	e822                	sd	s0,16(sp)
    8000220c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000220e:	fe840593          	addi	a1,s0,-24
    80002212:	4501                	li	a0,0
    80002214:	00000097          	auipc	ra,0x0
    80002218:	ece080e7          	jalr	-306(ra) # 800020e2 <argaddr>
    8000221c:	87aa                	mv	a5,a0
    return -1;
    8000221e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002220:	0007c863          	bltz	a5,80002230 <sys_wait+0x2a>
  return wait(p);
    80002224:	fe843503          	ld	a0,-24(s0)
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	50c080e7          	jalr	1292(ra) # 80001734 <wait>
}
    80002230:	60e2                	ld	ra,24(sp)
    80002232:	6442                	ld	s0,16(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002238:	7179                	addi	sp,sp,-48
    8000223a:	f406                	sd	ra,40(sp)
    8000223c:	f022                	sd	s0,32(sp)
    8000223e:	ec26                	sd	s1,24(sp)
    80002240:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002242:	fdc40593          	addi	a1,s0,-36
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	e78080e7          	jalr	-392(ra) # 800020c0 <argint>
    80002250:	87aa                	mv	a5,a0
    return -1;
    80002252:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002254:	0207c063          	bltz	a5,80002274 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	d0e080e7          	jalr	-754(ra) # 80000f66 <myproc>
    80002260:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002262:	fdc42503          	lw	a0,-36(s0)
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	108080e7          	jalr	264(ra) # 8000136e <growproc>
    8000226e:	00054863          	bltz	a0,8000227e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002272:	8526                	mv	a0,s1
}
    80002274:	70a2                	ld	ra,40(sp)
    80002276:	7402                	ld	s0,32(sp)
    80002278:	64e2                	ld	s1,24(sp)
    8000227a:	6145                	addi	sp,sp,48
    8000227c:	8082                	ret
    return -1;
    8000227e:	557d                	li	a0,-1
    80002280:	bfd5                	j	80002274 <sys_sbrk+0x3c>

0000000080002282 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002282:	7139                	addi	sp,sp,-64
    80002284:	fc06                	sd	ra,56(sp)
    80002286:	f822                	sd	s0,48(sp)
    80002288:	f426                	sd	s1,40(sp)
    8000228a:	f04a                	sd	s2,32(sp)
    8000228c:	ec4e                	sd	s3,24(sp)
    8000228e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002290:	fcc40593          	addi	a1,s0,-52
    80002294:	4501                	li	a0,0
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	e2a080e7          	jalr	-470(ra) # 800020c0 <argint>
    return -1;
    8000229e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022a0:	06054563          	bltz	a0,8000230a <sys_sleep+0x88>
  acquire(&tickslock);
    800022a4:	0000d517          	auipc	a0,0xd
    800022a8:	ddc50513          	addi	a0,a0,-548 # 8000f080 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	066080e7          	jalr	102(ra) # 80006312 <acquire>
  ticks0 = ticks;
    800022b4:	00007917          	auipc	s2,0x7
    800022b8:	d6492903          	lw	s2,-668(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022bc:	fcc42783          	lw	a5,-52(s0)
    800022c0:	cf85                	beqz	a5,800022f8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022c2:	0000d997          	auipc	s3,0xd
    800022c6:	dbe98993          	addi	s3,s3,-578 # 8000f080 <tickslock>
    800022ca:	00007497          	auipc	s1,0x7
    800022ce:	d4e48493          	addi	s1,s1,-690 # 80009018 <ticks>
    if(myproc()->killed){
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	c94080e7          	jalr	-876(ra) # 80000f66 <myproc>
    800022da:	551c                	lw	a5,40(a0)
    800022dc:	ef9d                	bnez	a5,8000231a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022de:	85ce                	mv	a1,s3
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	3ee080e7          	jalr	1006(ra) # 800016d0 <sleep>
  while(ticks - ticks0 < n){
    800022ea:	409c                	lw	a5,0(s1)
    800022ec:	412787bb          	subw	a5,a5,s2
    800022f0:	fcc42703          	lw	a4,-52(s0)
    800022f4:	fce7efe3          	bltu	a5,a4,800022d2 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022f8:	0000d517          	auipc	a0,0xd
    800022fc:	d8850513          	addi	a0,a0,-632 # 8000f080 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	0c6080e7          	jalr	198(ra) # 800063c6 <release>
  return 0;
    80002308:	4781                	li	a5,0
}
    8000230a:	853e                	mv	a0,a5
    8000230c:	70e2                	ld	ra,56(sp)
    8000230e:	7442                	ld	s0,48(sp)
    80002310:	74a2                	ld	s1,40(sp)
    80002312:	7902                	ld	s2,32(sp)
    80002314:	69e2                	ld	s3,24(sp)
    80002316:	6121                	addi	sp,sp,64
    80002318:	8082                	ret
      release(&tickslock);
    8000231a:	0000d517          	auipc	a0,0xd
    8000231e:	d6650513          	addi	a0,a0,-666 # 8000f080 <tickslock>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	0a4080e7          	jalr	164(ra) # 800063c6 <release>
      return -1;
    8000232a:	57fd                	li	a5,-1
    8000232c:	bff9                	j	8000230a <sys_sleep+0x88>

000000008000232e <sys_pgaccess>:


//#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000232e:	7139                	addi	sp,sp,-64
    80002330:	fc06                	sd	ra,56(sp)
    80002332:	f822                	sd	s0,48(sp)
    80002334:	f426                	sd	s1,40(sp)
    80002336:	f04a                	sd	s2,32(sp)
    80002338:	0080                	addi	s0,sp,64
  // lab pgtbl: your code here.
  uint64 addr;
  int len;
  uint64 bitmask;
  if(argaddr(0, &addr) < 0)
    8000233a:	fd840593          	addi	a1,s0,-40
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	da2080e7          	jalr	-606(ra) # 800020e2 <argaddr>
    80002348:	0a054063          	bltz	a0,800023e8 <sys_pgaccess+0xba>
    return -1;
  if(argint(1, &len) < 0)
    8000234c:	fd440593          	addi	a1,s0,-44
    80002350:	4505                	li	a0,1
    80002352:	00000097          	auipc	ra,0x0
    80002356:	d6e080e7          	jalr	-658(ra) # 800020c0 <argint>
    8000235a:	08054963          	bltz	a0,800023ec <sys_pgaccess+0xbe>
    return -1;
  if(argaddr(2, &bitmask) < 0)
    8000235e:	fc840593          	addi	a1,s0,-56
    80002362:	4509                	li	a0,2
    80002364:	00000097          	auipc	ra,0x0
    80002368:	d7e080e7          	jalr	-642(ra) # 800020e2 <argaddr>
    8000236c:	08054263          	bltz	a0,800023f0 <sys_pgaccess+0xc2>
    return -1;
  if(len > 32 || len < 0)
    80002370:	fd442703          	lw	a4,-44(s0)
    80002374:	02000793          	li	a5,32
    80002378:	06e7ee63          	bltu	a5,a4,800023f4 <sys_pgaccess+0xc6>
    return -1;

  int res = 0;
    8000237c:	fc042223          	sw	zero,-60(s0)
  struct proc *p = myproc();
    80002380:	fffff097          	auipc	ra,0xfffff
    80002384:	be6080e7          	jalr	-1050(ra) # 80000f66 <myproc>
    80002388:	892a                	mv	s2,a0
  for(int i = 0; i < len; ++i)
    8000238a:	fd442783          	lw	a5,-44(s0)
    8000238e:	02f05a63          	blez	a5,800023c2 <sys_pgaccess+0x94>
    80002392:	4481                	li	s1,0
  {
    int va = addr + i*PGSIZE;
    80002394:	00c4959b          	slliw	a1,s1,0xc
    int abit = vm_pgaccess(p->pagetable, va);
    80002398:	fd843783          	ld	a5,-40(s0)
    8000239c:	9dbd                	addw	a1,a1,a5
    8000239e:	05093503          	ld	a0,80(s2)
    800023a2:	fffff097          	auipc	ra,0xfffff
    800023a6:	a14080e7          	jalr	-1516(ra) # 80000db6 <vm_pgaccess>
    res = res | abit << i;
    800023aa:	009517bb          	sllw	a5,a0,s1
    800023ae:	fc442703          	lw	a4,-60(s0)
    800023b2:	8fd9                	or	a5,a5,a4
    800023b4:	fcf42223          	sw	a5,-60(s0)
  for(int i = 0; i < len; ++i)
    800023b8:	2485                	addiw	s1,s1,1
    800023ba:	fd442783          	lw	a5,-44(s0)
    800023be:	fcf4cbe3          	blt	s1,a5,80002394 <sys_pgaccess+0x66>
  }
  
  if(copyout(p->pagetable, bitmask, (char*)&res, sizeof res) < 0)
    800023c2:	4691                	li	a3,4
    800023c4:	fc440613          	addi	a2,s0,-60
    800023c8:	fc843583          	ld	a1,-56(s0)
    800023cc:	05093503          	ld	a0,80(s2)
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	81a080e7          	jalr	-2022(ra) # 80000bea <copyout>
    800023d8:	41f5551b          	sraiw	a0,a0,0x1f
    return -1;
  return 0;
}
    800023dc:	70e2                	ld	ra,56(sp)
    800023de:	7442                	ld	s0,48(sp)
    800023e0:	74a2                	ld	s1,40(sp)
    800023e2:	7902                	ld	s2,32(sp)
    800023e4:	6121                	addi	sp,sp,64
    800023e6:	8082                	ret
    return -1;
    800023e8:	557d                	li	a0,-1
    800023ea:	bfcd                	j	800023dc <sys_pgaccess+0xae>
    return -1;
    800023ec:	557d                	li	a0,-1
    800023ee:	b7fd                	j	800023dc <sys_pgaccess+0xae>
    return -1;
    800023f0:	557d                	li	a0,-1
    800023f2:	b7ed                	j	800023dc <sys_pgaccess+0xae>
    return -1;
    800023f4:	557d                	li	a0,-1
    800023f6:	b7dd                	j	800023dc <sys_pgaccess+0xae>

00000000800023f8 <sys_kill>:
//#endif

uint64
sys_kill(void)
{
    800023f8:	1101                	addi	sp,sp,-32
    800023fa:	ec06                	sd	ra,24(sp)
    800023fc:	e822                	sd	s0,16(sp)
    800023fe:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002400:	fec40593          	addi	a1,s0,-20
    80002404:	4501                	li	a0,0
    80002406:	00000097          	auipc	ra,0x0
    8000240a:	cba080e7          	jalr	-838(ra) # 800020c0 <argint>
    8000240e:	87aa                	mv	a5,a0
    return -1;
    80002410:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002412:	0007c863          	bltz	a5,80002422 <sys_kill+0x2a>
  return kill(pid);
    80002416:	fec42503          	lw	a0,-20(s0)
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	5e8080e7          	jalr	1512(ra) # 80001a02 <kill>
}
    80002422:	60e2                	ld	ra,24(sp)
    80002424:	6442                	ld	s0,16(sp)
    80002426:	6105                	addi	sp,sp,32
    80002428:	8082                	ret

000000008000242a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000242a:	1101                	addi	sp,sp,-32
    8000242c:	ec06                	sd	ra,24(sp)
    8000242e:	e822                	sd	s0,16(sp)
    80002430:	e426                	sd	s1,8(sp)
    80002432:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002434:	0000d517          	auipc	a0,0xd
    80002438:	c4c50513          	addi	a0,a0,-948 # 8000f080 <tickslock>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	ed6080e7          	jalr	-298(ra) # 80006312 <acquire>
  xticks = ticks;
    80002444:	00007497          	auipc	s1,0x7
    80002448:	bd44a483          	lw	s1,-1068(s1) # 80009018 <ticks>
  release(&tickslock);
    8000244c:	0000d517          	auipc	a0,0xd
    80002450:	c3450513          	addi	a0,a0,-972 # 8000f080 <tickslock>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	f72080e7          	jalr	-142(ra) # 800063c6 <release>
  return xticks;
}
    8000245c:	02049513          	slli	a0,s1,0x20
    80002460:	9101                	srli	a0,a0,0x20
    80002462:	60e2                	ld	ra,24(sp)
    80002464:	6442                	ld	s0,16(sp)
    80002466:	64a2                	ld	s1,8(sp)
    80002468:	6105                	addi	sp,sp,32
    8000246a:	8082                	ret

000000008000246c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000246c:	7179                	addi	sp,sp,-48
    8000246e:	f406                	sd	ra,40(sp)
    80002470:	f022                	sd	s0,32(sp)
    80002472:	ec26                	sd	s1,24(sp)
    80002474:	e84a                	sd	s2,16(sp)
    80002476:	e44e                	sd	s3,8(sp)
    80002478:	e052                	sd	s4,0(sp)
    8000247a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000247c:	00006597          	auipc	a1,0x6
    80002480:	0d458593          	addi	a1,a1,212 # 80008550 <syscalls+0xf8>
    80002484:	0000d517          	auipc	a0,0xd
    80002488:	c1450513          	addi	a0,a0,-1004 # 8000f098 <bcache>
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	df6080e7          	jalr	-522(ra) # 80006282 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002494:	00015797          	auipc	a5,0x15
    80002498:	c0478793          	addi	a5,a5,-1020 # 80017098 <bcache+0x8000>
    8000249c:	00015717          	auipc	a4,0x15
    800024a0:	e6470713          	addi	a4,a4,-412 # 80017300 <bcache+0x8268>
    800024a4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024a8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ac:	0000d497          	auipc	s1,0xd
    800024b0:	c0448493          	addi	s1,s1,-1020 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024b4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024b6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024b8:	00006a17          	auipc	s4,0x6
    800024bc:	0a0a0a13          	addi	s4,s4,160 # 80008558 <syscalls+0x100>
    b->next = bcache.head.next;
    800024c0:	2b893783          	ld	a5,696(s2)
    800024c4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024c6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024ca:	85d2                	mv	a1,s4
    800024cc:	01048513          	addi	a0,s1,16
    800024d0:	00001097          	auipc	ra,0x1
    800024d4:	4bc080e7          	jalr	1212(ra) # 8000398c <initsleeplock>
    bcache.head.next->prev = b;
    800024d8:	2b893783          	ld	a5,696(s2)
    800024dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024e2:	45848493          	addi	s1,s1,1112
    800024e6:	fd349de3          	bne	s1,s3,800024c0 <binit+0x54>
  }
}
    800024ea:	70a2                	ld	ra,40(sp)
    800024ec:	7402                	ld	s0,32(sp)
    800024ee:	64e2                	ld	s1,24(sp)
    800024f0:	6942                	ld	s2,16(sp)
    800024f2:	69a2                	ld	s3,8(sp)
    800024f4:	6a02                	ld	s4,0(sp)
    800024f6:	6145                	addi	sp,sp,48
    800024f8:	8082                	ret

00000000800024fa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024fa:	7179                	addi	sp,sp,-48
    800024fc:	f406                	sd	ra,40(sp)
    800024fe:	f022                	sd	s0,32(sp)
    80002500:	ec26                	sd	s1,24(sp)
    80002502:	e84a                	sd	s2,16(sp)
    80002504:	e44e                	sd	s3,8(sp)
    80002506:	1800                	addi	s0,sp,48
    80002508:	89aa                	mv	s3,a0
    8000250a:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000250c:	0000d517          	auipc	a0,0xd
    80002510:	b8c50513          	addi	a0,a0,-1140 # 8000f098 <bcache>
    80002514:	00004097          	auipc	ra,0x4
    80002518:	dfe080e7          	jalr	-514(ra) # 80006312 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000251c:	00015497          	auipc	s1,0x15
    80002520:	e344b483          	ld	s1,-460(s1) # 80017350 <bcache+0x82b8>
    80002524:	00015797          	auipc	a5,0x15
    80002528:	ddc78793          	addi	a5,a5,-548 # 80017300 <bcache+0x8268>
    8000252c:	02f48f63          	beq	s1,a5,8000256a <bread+0x70>
    80002530:	873e                	mv	a4,a5
    80002532:	a021                	j	8000253a <bread+0x40>
    80002534:	68a4                	ld	s1,80(s1)
    80002536:	02e48a63          	beq	s1,a4,8000256a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000253a:	449c                	lw	a5,8(s1)
    8000253c:	ff379ce3          	bne	a5,s3,80002534 <bread+0x3a>
    80002540:	44dc                	lw	a5,12(s1)
    80002542:	ff2799e3          	bne	a5,s2,80002534 <bread+0x3a>
      b->refcnt++;
    80002546:	40bc                	lw	a5,64(s1)
    80002548:	2785                	addiw	a5,a5,1
    8000254a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000254c:	0000d517          	auipc	a0,0xd
    80002550:	b4c50513          	addi	a0,a0,-1204 # 8000f098 <bcache>
    80002554:	00004097          	auipc	ra,0x4
    80002558:	e72080e7          	jalr	-398(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    8000255c:	01048513          	addi	a0,s1,16
    80002560:	00001097          	auipc	ra,0x1
    80002564:	466080e7          	jalr	1126(ra) # 800039c6 <acquiresleep>
      return b;
    80002568:	a8b9                	j	800025c6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000256a:	00015497          	auipc	s1,0x15
    8000256e:	dde4b483          	ld	s1,-546(s1) # 80017348 <bcache+0x82b0>
    80002572:	00015797          	auipc	a5,0x15
    80002576:	d8e78793          	addi	a5,a5,-626 # 80017300 <bcache+0x8268>
    8000257a:	00f48863          	beq	s1,a5,8000258a <bread+0x90>
    8000257e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002580:	40bc                	lw	a5,64(s1)
    80002582:	cf81                	beqz	a5,8000259a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002584:	64a4                	ld	s1,72(s1)
    80002586:	fee49de3          	bne	s1,a4,80002580 <bread+0x86>
  panic("bget: no buffers");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	fd650513          	addi	a0,a0,-42 # 80008560 <syscalls+0x108>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	836080e7          	jalr	-1994(ra) # 80005dc8 <panic>
      b->dev = dev;
    8000259a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000259e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025a2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025a6:	4785                	li	a5,1
    800025a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025aa:	0000d517          	auipc	a0,0xd
    800025ae:	aee50513          	addi	a0,a0,-1298 # 8000f098 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	e14080e7          	jalr	-492(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    800025ba:	01048513          	addi	a0,s1,16
    800025be:	00001097          	auipc	ra,0x1
    800025c2:	408080e7          	jalr	1032(ra) # 800039c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025c6:	409c                	lw	a5,0(s1)
    800025c8:	cb89                	beqz	a5,800025da <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025ca:	8526                	mv	a0,s1
    800025cc:	70a2                	ld	ra,40(sp)
    800025ce:	7402                	ld	s0,32(sp)
    800025d0:	64e2                	ld	s1,24(sp)
    800025d2:	6942                	ld	s2,16(sp)
    800025d4:	69a2                	ld	s3,8(sp)
    800025d6:	6145                	addi	sp,sp,48
    800025d8:	8082                	ret
    virtio_disk_rw(b, 0);
    800025da:	4581                	li	a1,0
    800025dc:	8526                	mv	a0,s1
    800025de:	00003097          	auipc	ra,0x3
    800025e2:	f28080e7          	jalr	-216(ra) # 80005506 <virtio_disk_rw>
    b->valid = 1;
    800025e6:	4785                	li	a5,1
    800025e8:	c09c                	sw	a5,0(s1)
  return b;
    800025ea:	b7c5                	j	800025ca <bread+0xd0>

00000000800025ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	1000                	addi	s0,sp,32
    800025f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025f8:	0541                	addi	a0,a0,16
    800025fa:	00001097          	auipc	ra,0x1
    800025fe:	466080e7          	jalr	1126(ra) # 80003a60 <holdingsleep>
    80002602:	cd01                	beqz	a0,8000261a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002604:	4585                	li	a1,1
    80002606:	8526                	mv	a0,s1
    80002608:	00003097          	auipc	ra,0x3
    8000260c:	efe080e7          	jalr	-258(ra) # 80005506 <virtio_disk_rw>
}
    80002610:	60e2                	ld	ra,24(sp)
    80002612:	6442                	ld	s0,16(sp)
    80002614:	64a2                	ld	s1,8(sp)
    80002616:	6105                	addi	sp,sp,32
    80002618:	8082                	ret
    panic("bwrite");
    8000261a:	00006517          	auipc	a0,0x6
    8000261e:	f5e50513          	addi	a0,a0,-162 # 80008578 <syscalls+0x120>
    80002622:	00003097          	auipc	ra,0x3
    80002626:	7a6080e7          	jalr	1958(ra) # 80005dc8 <panic>

000000008000262a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000262a:	1101                	addi	sp,sp,-32
    8000262c:	ec06                	sd	ra,24(sp)
    8000262e:	e822                	sd	s0,16(sp)
    80002630:	e426                	sd	s1,8(sp)
    80002632:	e04a                	sd	s2,0(sp)
    80002634:	1000                	addi	s0,sp,32
    80002636:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002638:	01050913          	addi	s2,a0,16
    8000263c:	854a                	mv	a0,s2
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	422080e7          	jalr	1058(ra) # 80003a60 <holdingsleep>
    80002646:	c92d                	beqz	a0,800026b8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002648:	854a                	mv	a0,s2
    8000264a:	00001097          	auipc	ra,0x1
    8000264e:	3d2080e7          	jalr	978(ra) # 80003a1c <releasesleep>

  acquire(&bcache.lock);
    80002652:	0000d517          	auipc	a0,0xd
    80002656:	a4650513          	addi	a0,a0,-1466 # 8000f098 <bcache>
    8000265a:	00004097          	auipc	ra,0x4
    8000265e:	cb8080e7          	jalr	-840(ra) # 80006312 <acquire>
  b->refcnt--;
    80002662:	40bc                	lw	a5,64(s1)
    80002664:	37fd                	addiw	a5,a5,-1
    80002666:	0007871b          	sext.w	a4,a5
    8000266a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000266c:	eb05                	bnez	a4,8000269c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000266e:	68bc                	ld	a5,80(s1)
    80002670:	64b8                	ld	a4,72(s1)
    80002672:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002674:	64bc                	ld	a5,72(s1)
    80002676:	68b8                	ld	a4,80(s1)
    80002678:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000267a:	00015797          	auipc	a5,0x15
    8000267e:	a1e78793          	addi	a5,a5,-1506 # 80017098 <bcache+0x8000>
    80002682:	2b87b703          	ld	a4,696(a5)
    80002686:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002688:	00015717          	auipc	a4,0x15
    8000268c:	c7870713          	addi	a4,a4,-904 # 80017300 <bcache+0x8268>
    80002690:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002692:	2b87b703          	ld	a4,696(a5)
    80002696:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002698:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000269c:	0000d517          	auipc	a0,0xd
    800026a0:	9fc50513          	addi	a0,a0,-1540 # 8000f098 <bcache>
    800026a4:	00004097          	auipc	ra,0x4
    800026a8:	d22080e7          	jalr	-734(ra) # 800063c6 <release>
}
    800026ac:	60e2                	ld	ra,24(sp)
    800026ae:	6442                	ld	s0,16(sp)
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	6902                	ld	s2,0(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret
    panic("brelse");
    800026b8:	00006517          	auipc	a0,0x6
    800026bc:	ec850513          	addi	a0,a0,-312 # 80008580 <syscalls+0x128>
    800026c0:	00003097          	auipc	ra,0x3
    800026c4:	708080e7          	jalr	1800(ra) # 80005dc8 <panic>

00000000800026c8 <bpin>:

void
bpin(struct buf *b) {
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	1000                	addi	s0,sp,32
    800026d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026d4:	0000d517          	auipc	a0,0xd
    800026d8:	9c450513          	addi	a0,a0,-1596 # 8000f098 <bcache>
    800026dc:	00004097          	auipc	ra,0x4
    800026e0:	c36080e7          	jalr	-970(ra) # 80006312 <acquire>
  b->refcnt++;
    800026e4:	40bc                	lw	a5,64(s1)
    800026e6:	2785                	addiw	a5,a5,1
    800026e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ea:	0000d517          	auipc	a0,0xd
    800026ee:	9ae50513          	addi	a0,a0,-1618 # 8000f098 <bcache>
    800026f2:	00004097          	auipc	ra,0x4
    800026f6:	cd4080e7          	jalr	-812(ra) # 800063c6 <release>
}
    800026fa:	60e2                	ld	ra,24(sp)
    800026fc:	6442                	ld	s0,16(sp)
    800026fe:	64a2                	ld	s1,8(sp)
    80002700:	6105                	addi	sp,sp,32
    80002702:	8082                	ret

0000000080002704 <bunpin>:

void
bunpin(struct buf *b) {
    80002704:	1101                	addi	sp,sp,-32
    80002706:	ec06                	sd	ra,24(sp)
    80002708:	e822                	sd	s0,16(sp)
    8000270a:	e426                	sd	s1,8(sp)
    8000270c:	1000                	addi	s0,sp,32
    8000270e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002710:	0000d517          	auipc	a0,0xd
    80002714:	98850513          	addi	a0,a0,-1656 # 8000f098 <bcache>
    80002718:	00004097          	auipc	ra,0x4
    8000271c:	bfa080e7          	jalr	-1030(ra) # 80006312 <acquire>
  b->refcnt--;
    80002720:	40bc                	lw	a5,64(s1)
    80002722:	37fd                	addiw	a5,a5,-1
    80002724:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002726:	0000d517          	auipc	a0,0xd
    8000272a:	97250513          	addi	a0,a0,-1678 # 8000f098 <bcache>
    8000272e:	00004097          	auipc	ra,0x4
    80002732:	c98080e7          	jalr	-872(ra) # 800063c6 <release>
}
    80002736:	60e2                	ld	ra,24(sp)
    80002738:	6442                	ld	s0,16(sp)
    8000273a:	64a2                	ld	s1,8(sp)
    8000273c:	6105                	addi	sp,sp,32
    8000273e:	8082                	ret

0000000080002740 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002740:	1101                	addi	sp,sp,-32
    80002742:	ec06                	sd	ra,24(sp)
    80002744:	e822                	sd	s0,16(sp)
    80002746:	e426                	sd	s1,8(sp)
    80002748:	e04a                	sd	s2,0(sp)
    8000274a:	1000                	addi	s0,sp,32
    8000274c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000274e:	00d5d59b          	srliw	a1,a1,0xd
    80002752:	00015797          	auipc	a5,0x15
    80002756:	0227a783          	lw	a5,34(a5) # 80017774 <sb+0x1c>
    8000275a:	9dbd                	addw	a1,a1,a5
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	d9e080e7          	jalr	-610(ra) # 800024fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002764:	0074f713          	andi	a4,s1,7
    80002768:	4785                	li	a5,1
    8000276a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000276e:	14ce                	slli	s1,s1,0x33
    80002770:	90d9                	srli	s1,s1,0x36
    80002772:	00950733          	add	a4,a0,s1
    80002776:	05874703          	lbu	a4,88(a4)
    8000277a:	00e7f6b3          	and	a3,a5,a4
    8000277e:	c69d                	beqz	a3,800027ac <bfree+0x6c>
    80002780:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002782:	94aa                	add	s1,s1,a0
    80002784:	fff7c793          	not	a5,a5
    80002788:	8ff9                	and	a5,a5,a4
    8000278a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000278e:	00001097          	auipc	ra,0x1
    80002792:	118080e7          	jalr	280(ra) # 800038a6 <log_write>
  brelse(bp);
    80002796:	854a                	mv	a0,s2
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	e92080e7          	jalr	-366(ra) # 8000262a <brelse>
}
    800027a0:	60e2                	ld	ra,24(sp)
    800027a2:	6442                	ld	s0,16(sp)
    800027a4:	64a2                	ld	s1,8(sp)
    800027a6:	6902                	ld	s2,0(sp)
    800027a8:	6105                	addi	sp,sp,32
    800027aa:	8082                	ret
    panic("freeing free block");
    800027ac:	00006517          	auipc	a0,0x6
    800027b0:	ddc50513          	addi	a0,a0,-548 # 80008588 <syscalls+0x130>
    800027b4:	00003097          	auipc	ra,0x3
    800027b8:	614080e7          	jalr	1556(ra) # 80005dc8 <panic>

00000000800027bc <balloc>:
{
    800027bc:	711d                	addi	sp,sp,-96
    800027be:	ec86                	sd	ra,88(sp)
    800027c0:	e8a2                	sd	s0,80(sp)
    800027c2:	e4a6                	sd	s1,72(sp)
    800027c4:	e0ca                	sd	s2,64(sp)
    800027c6:	fc4e                	sd	s3,56(sp)
    800027c8:	f852                	sd	s4,48(sp)
    800027ca:	f456                	sd	s5,40(sp)
    800027cc:	f05a                	sd	s6,32(sp)
    800027ce:	ec5e                	sd	s7,24(sp)
    800027d0:	e862                	sd	s8,16(sp)
    800027d2:	e466                	sd	s9,8(sp)
    800027d4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027d6:	00015797          	auipc	a5,0x15
    800027da:	f867a783          	lw	a5,-122(a5) # 8001775c <sb+0x4>
    800027de:	cbd1                	beqz	a5,80002872 <balloc+0xb6>
    800027e0:	8baa                	mv	s7,a0
    800027e2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027e4:	00015b17          	auipc	s6,0x15
    800027e8:	f74b0b13          	addi	s6,s6,-140 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ec:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027ee:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027f2:	6c89                	lui	s9,0x2
    800027f4:	a831                	j	80002810 <balloc+0x54>
    brelse(bp);
    800027f6:	854a                	mv	a0,s2
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	e32080e7          	jalr	-462(ra) # 8000262a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002800:	015c87bb          	addw	a5,s9,s5
    80002804:	00078a9b          	sext.w	s5,a5
    80002808:	004b2703          	lw	a4,4(s6)
    8000280c:	06eaf363          	bgeu	s5,a4,80002872 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002810:	41fad79b          	sraiw	a5,s5,0x1f
    80002814:	0137d79b          	srliw	a5,a5,0x13
    80002818:	015787bb          	addw	a5,a5,s5
    8000281c:	40d7d79b          	sraiw	a5,a5,0xd
    80002820:	01cb2583          	lw	a1,28(s6)
    80002824:	9dbd                	addw	a1,a1,a5
    80002826:	855e                	mv	a0,s7
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	cd2080e7          	jalr	-814(ra) # 800024fa <bread>
    80002830:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002832:	004b2503          	lw	a0,4(s6)
    80002836:	000a849b          	sext.w	s1,s5
    8000283a:	8662                	mv	a2,s8
    8000283c:	faa4fde3          	bgeu	s1,a0,800027f6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002840:	41f6579b          	sraiw	a5,a2,0x1f
    80002844:	01d7d69b          	srliw	a3,a5,0x1d
    80002848:	00c6873b          	addw	a4,a3,a2
    8000284c:	00777793          	andi	a5,a4,7
    80002850:	9f95                	subw	a5,a5,a3
    80002852:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002856:	4037571b          	sraiw	a4,a4,0x3
    8000285a:	00e906b3          	add	a3,s2,a4
    8000285e:	0586c683          	lbu	a3,88(a3)
    80002862:	00d7f5b3          	and	a1,a5,a3
    80002866:	cd91                	beqz	a1,80002882 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002868:	2605                	addiw	a2,a2,1
    8000286a:	2485                	addiw	s1,s1,1
    8000286c:	fd4618e3          	bne	a2,s4,8000283c <balloc+0x80>
    80002870:	b759                	j	800027f6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002872:	00006517          	auipc	a0,0x6
    80002876:	d2e50513          	addi	a0,a0,-722 # 800085a0 <syscalls+0x148>
    8000287a:	00003097          	auipc	ra,0x3
    8000287e:	54e080e7          	jalr	1358(ra) # 80005dc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002882:	974a                	add	a4,a4,s2
    80002884:	8fd5                	or	a5,a5,a3
    80002886:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000288a:	854a                	mv	a0,s2
    8000288c:	00001097          	auipc	ra,0x1
    80002890:	01a080e7          	jalr	26(ra) # 800038a6 <log_write>
        brelse(bp);
    80002894:	854a                	mv	a0,s2
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	d94080e7          	jalr	-620(ra) # 8000262a <brelse>
  bp = bread(dev, bno);
    8000289e:	85a6                	mv	a1,s1
    800028a0:	855e                	mv	a0,s7
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	c58080e7          	jalr	-936(ra) # 800024fa <bread>
    800028aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028ac:	40000613          	li	a2,1024
    800028b0:	4581                	li	a1,0
    800028b2:	05850513          	addi	a0,a0,88
    800028b6:	ffffe097          	auipc	ra,0xffffe
    800028ba:	8c2080e7          	jalr	-1854(ra) # 80000178 <memset>
  log_write(bp);
    800028be:	854a                	mv	a0,s2
    800028c0:	00001097          	auipc	ra,0x1
    800028c4:	fe6080e7          	jalr	-26(ra) # 800038a6 <log_write>
  brelse(bp);
    800028c8:	854a                	mv	a0,s2
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	d60080e7          	jalr	-672(ra) # 8000262a <brelse>
}
    800028d2:	8526                	mv	a0,s1
    800028d4:	60e6                	ld	ra,88(sp)
    800028d6:	6446                	ld	s0,80(sp)
    800028d8:	64a6                	ld	s1,72(sp)
    800028da:	6906                	ld	s2,64(sp)
    800028dc:	79e2                	ld	s3,56(sp)
    800028de:	7a42                	ld	s4,48(sp)
    800028e0:	7aa2                	ld	s5,40(sp)
    800028e2:	7b02                	ld	s6,32(sp)
    800028e4:	6be2                	ld	s7,24(sp)
    800028e6:	6c42                	ld	s8,16(sp)
    800028e8:	6ca2                	ld	s9,8(sp)
    800028ea:	6125                	addi	sp,sp,96
    800028ec:	8082                	ret

00000000800028ee <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028ee:	7179                	addi	sp,sp,-48
    800028f0:	f406                	sd	ra,40(sp)
    800028f2:	f022                	sd	s0,32(sp)
    800028f4:	ec26                	sd	s1,24(sp)
    800028f6:	e84a                	sd	s2,16(sp)
    800028f8:	e44e                	sd	s3,8(sp)
    800028fa:	e052                	sd	s4,0(sp)
    800028fc:	1800                	addi	s0,sp,48
    800028fe:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002900:	47ad                	li	a5,11
    80002902:	04b7fe63          	bgeu	a5,a1,8000295e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002906:	ff45849b          	addiw	s1,a1,-12
    8000290a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000290e:	0ff00793          	li	a5,255
    80002912:	0ae7e363          	bltu	a5,a4,800029b8 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002916:	08052583          	lw	a1,128(a0)
    8000291a:	c5ad                	beqz	a1,80002984 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000291c:	00092503          	lw	a0,0(s2)
    80002920:	00000097          	auipc	ra,0x0
    80002924:	bda080e7          	jalr	-1062(ra) # 800024fa <bread>
    80002928:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000292a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000292e:	02049593          	slli	a1,s1,0x20
    80002932:	9181                	srli	a1,a1,0x20
    80002934:	058a                	slli	a1,a1,0x2
    80002936:	00b784b3          	add	s1,a5,a1
    8000293a:	0004a983          	lw	s3,0(s1)
    8000293e:	04098d63          	beqz	s3,80002998 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002942:	8552                	mv	a0,s4
    80002944:	00000097          	auipc	ra,0x0
    80002948:	ce6080e7          	jalr	-794(ra) # 8000262a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000294c:	854e                	mv	a0,s3
    8000294e:	70a2                	ld	ra,40(sp)
    80002950:	7402                	ld	s0,32(sp)
    80002952:	64e2                	ld	s1,24(sp)
    80002954:	6942                	ld	s2,16(sp)
    80002956:	69a2                	ld	s3,8(sp)
    80002958:	6a02                	ld	s4,0(sp)
    8000295a:	6145                	addi	sp,sp,48
    8000295c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000295e:	02059493          	slli	s1,a1,0x20
    80002962:	9081                	srli	s1,s1,0x20
    80002964:	048a                	slli	s1,s1,0x2
    80002966:	94aa                	add	s1,s1,a0
    80002968:	0504a983          	lw	s3,80(s1)
    8000296c:	fe0990e3          	bnez	s3,8000294c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002970:	4108                	lw	a0,0(a0)
    80002972:	00000097          	auipc	ra,0x0
    80002976:	e4a080e7          	jalr	-438(ra) # 800027bc <balloc>
    8000297a:	0005099b          	sext.w	s3,a0
    8000297e:	0534a823          	sw	s3,80(s1)
    80002982:	b7e9                	j	8000294c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002984:	4108                	lw	a0,0(a0)
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	e36080e7          	jalr	-458(ra) # 800027bc <balloc>
    8000298e:	0005059b          	sext.w	a1,a0
    80002992:	08b92023          	sw	a1,128(s2)
    80002996:	b759                	j	8000291c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002998:	00092503          	lw	a0,0(s2)
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	e20080e7          	jalr	-480(ra) # 800027bc <balloc>
    800029a4:	0005099b          	sext.w	s3,a0
    800029a8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ac:	8552                	mv	a0,s4
    800029ae:	00001097          	auipc	ra,0x1
    800029b2:	ef8080e7          	jalr	-264(ra) # 800038a6 <log_write>
    800029b6:	b771                	j	80002942 <bmap+0x54>
  panic("bmap: out of range");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	c0050513          	addi	a0,a0,-1024 # 800085b8 <syscalls+0x160>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	408080e7          	jalr	1032(ra) # 80005dc8 <panic>

00000000800029c8 <iget>:
{
    800029c8:	7179                	addi	sp,sp,-48
    800029ca:	f406                	sd	ra,40(sp)
    800029cc:	f022                	sd	s0,32(sp)
    800029ce:	ec26                	sd	s1,24(sp)
    800029d0:	e84a                	sd	s2,16(sp)
    800029d2:	e44e                	sd	s3,8(sp)
    800029d4:	e052                	sd	s4,0(sp)
    800029d6:	1800                	addi	s0,sp,48
    800029d8:	89aa                	mv	s3,a0
    800029da:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029dc:	00015517          	auipc	a0,0x15
    800029e0:	d9c50513          	addi	a0,a0,-612 # 80017778 <itable>
    800029e4:	00004097          	auipc	ra,0x4
    800029e8:	92e080e7          	jalr	-1746(ra) # 80006312 <acquire>
  empty = 0;
    800029ec:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ee:	00015497          	auipc	s1,0x15
    800029f2:	da248493          	addi	s1,s1,-606 # 80017790 <itable+0x18>
    800029f6:	00017697          	auipc	a3,0x17
    800029fa:	82a68693          	addi	a3,a3,-2006 # 80019220 <log>
    800029fe:	a039                	j	80002a0c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a00:	02090b63          	beqz	s2,80002a36 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a04:	08848493          	addi	s1,s1,136
    80002a08:	02d48a63          	beq	s1,a3,80002a3c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a0c:	449c                	lw	a5,8(s1)
    80002a0e:	fef059e3          	blez	a5,80002a00 <iget+0x38>
    80002a12:	4098                	lw	a4,0(s1)
    80002a14:	ff3716e3          	bne	a4,s3,80002a00 <iget+0x38>
    80002a18:	40d8                	lw	a4,4(s1)
    80002a1a:	ff4713e3          	bne	a4,s4,80002a00 <iget+0x38>
      ip->ref++;
    80002a1e:	2785                	addiw	a5,a5,1
    80002a20:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a22:	00015517          	auipc	a0,0x15
    80002a26:	d5650513          	addi	a0,a0,-682 # 80017778 <itable>
    80002a2a:	00004097          	auipc	ra,0x4
    80002a2e:	99c080e7          	jalr	-1636(ra) # 800063c6 <release>
      return ip;
    80002a32:	8926                	mv	s2,s1
    80002a34:	a03d                	j	80002a62 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a36:	f7f9                	bnez	a5,80002a04 <iget+0x3c>
    80002a38:	8926                	mv	s2,s1
    80002a3a:	b7e9                	j	80002a04 <iget+0x3c>
  if(empty == 0)
    80002a3c:	02090c63          	beqz	s2,80002a74 <iget+0xac>
  ip->dev = dev;
    80002a40:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a44:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a48:	4785                	li	a5,1
    80002a4a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a4e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a52:	00015517          	auipc	a0,0x15
    80002a56:	d2650513          	addi	a0,a0,-730 # 80017778 <itable>
    80002a5a:	00004097          	auipc	ra,0x4
    80002a5e:	96c080e7          	jalr	-1684(ra) # 800063c6 <release>
}
    80002a62:	854a                	mv	a0,s2
    80002a64:	70a2                	ld	ra,40(sp)
    80002a66:	7402                	ld	s0,32(sp)
    80002a68:	64e2                	ld	s1,24(sp)
    80002a6a:	6942                	ld	s2,16(sp)
    80002a6c:	69a2                	ld	s3,8(sp)
    80002a6e:	6a02                	ld	s4,0(sp)
    80002a70:	6145                	addi	sp,sp,48
    80002a72:	8082                	ret
    panic("iget: no inodes");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	b5c50513          	addi	a0,a0,-1188 # 800085d0 <syscalls+0x178>
    80002a7c:	00003097          	auipc	ra,0x3
    80002a80:	34c080e7          	jalr	844(ra) # 80005dc8 <panic>

0000000080002a84 <fsinit>:
fsinit(int dev) {
    80002a84:	7179                	addi	sp,sp,-48
    80002a86:	f406                	sd	ra,40(sp)
    80002a88:	f022                	sd	s0,32(sp)
    80002a8a:	ec26                	sd	s1,24(sp)
    80002a8c:	e84a                	sd	s2,16(sp)
    80002a8e:	e44e                	sd	s3,8(sp)
    80002a90:	1800                	addi	s0,sp,48
    80002a92:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a94:	4585                	li	a1,1
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	a64080e7          	jalr	-1436(ra) # 800024fa <bread>
    80002a9e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aa0:	00015997          	auipc	s3,0x15
    80002aa4:	cb898993          	addi	s3,s3,-840 # 80017758 <sb>
    80002aa8:	02000613          	li	a2,32
    80002aac:	05850593          	addi	a1,a0,88
    80002ab0:	854e                	mv	a0,s3
    80002ab2:	ffffd097          	auipc	ra,0xffffd
    80002ab6:	726080e7          	jalr	1830(ra) # 800001d8 <memmove>
  brelse(bp);
    80002aba:	8526                	mv	a0,s1
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	b6e080e7          	jalr	-1170(ra) # 8000262a <brelse>
  if(sb.magic != FSMAGIC)
    80002ac4:	0009a703          	lw	a4,0(s3)
    80002ac8:	102037b7          	lui	a5,0x10203
    80002acc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ad0:	02f71263          	bne	a4,a5,80002af4 <fsinit+0x70>
  initlog(dev, &sb);
    80002ad4:	00015597          	auipc	a1,0x15
    80002ad8:	c8458593          	addi	a1,a1,-892 # 80017758 <sb>
    80002adc:	854a                	mv	a0,s2
    80002ade:	00001097          	auipc	ra,0x1
    80002ae2:	b4c080e7          	jalr	-1204(ra) # 8000362a <initlog>
}
    80002ae6:	70a2                	ld	ra,40(sp)
    80002ae8:	7402                	ld	s0,32(sp)
    80002aea:	64e2                	ld	s1,24(sp)
    80002aec:	6942                	ld	s2,16(sp)
    80002aee:	69a2                	ld	s3,8(sp)
    80002af0:	6145                	addi	sp,sp,48
    80002af2:	8082                	ret
    panic("invalid file system");
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	aec50513          	addi	a0,a0,-1300 # 800085e0 <syscalls+0x188>
    80002afc:	00003097          	auipc	ra,0x3
    80002b00:	2cc080e7          	jalr	716(ra) # 80005dc8 <panic>

0000000080002b04 <iinit>:
{
    80002b04:	7179                	addi	sp,sp,-48
    80002b06:	f406                	sd	ra,40(sp)
    80002b08:	f022                	sd	s0,32(sp)
    80002b0a:	ec26                	sd	s1,24(sp)
    80002b0c:	e84a                	sd	s2,16(sp)
    80002b0e:	e44e                	sd	s3,8(sp)
    80002b10:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b12:	00006597          	auipc	a1,0x6
    80002b16:	ae658593          	addi	a1,a1,-1306 # 800085f8 <syscalls+0x1a0>
    80002b1a:	00015517          	auipc	a0,0x15
    80002b1e:	c5e50513          	addi	a0,a0,-930 # 80017778 <itable>
    80002b22:	00003097          	auipc	ra,0x3
    80002b26:	760080e7          	jalr	1888(ra) # 80006282 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b2a:	00015497          	auipc	s1,0x15
    80002b2e:	c7648493          	addi	s1,s1,-906 # 800177a0 <itable+0x28>
    80002b32:	00016997          	auipc	s3,0x16
    80002b36:	6fe98993          	addi	s3,s3,1790 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b3a:	00006917          	auipc	s2,0x6
    80002b3e:	ac690913          	addi	s2,s2,-1338 # 80008600 <syscalls+0x1a8>
    80002b42:	85ca                	mv	a1,s2
    80002b44:	8526                	mv	a0,s1
    80002b46:	00001097          	auipc	ra,0x1
    80002b4a:	e46080e7          	jalr	-442(ra) # 8000398c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b4e:	08848493          	addi	s1,s1,136
    80002b52:	ff3498e3          	bne	s1,s3,80002b42 <iinit+0x3e>
}
    80002b56:	70a2                	ld	ra,40(sp)
    80002b58:	7402                	ld	s0,32(sp)
    80002b5a:	64e2                	ld	s1,24(sp)
    80002b5c:	6942                	ld	s2,16(sp)
    80002b5e:	69a2                	ld	s3,8(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret

0000000080002b64 <ialloc>:
{
    80002b64:	715d                	addi	sp,sp,-80
    80002b66:	e486                	sd	ra,72(sp)
    80002b68:	e0a2                	sd	s0,64(sp)
    80002b6a:	fc26                	sd	s1,56(sp)
    80002b6c:	f84a                	sd	s2,48(sp)
    80002b6e:	f44e                	sd	s3,40(sp)
    80002b70:	f052                	sd	s4,32(sp)
    80002b72:	ec56                	sd	s5,24(sp)
    80002b74:	e85a                	sd	s6,16(sp)
    80002b76:	e45e                	sd	s7,8(sp)
    80002b78:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b7a:	00015717          	auipc	a4,0x15
    80002b7e:	bea72703          	lw	a4,-1046(a4) # 80017764 <sb+0xc>
    80002b82:	4785                	li	a5,1
    80002b84:	04e7fa63          	bgeu	a5,a4,80002bd8 <ialloc+0x74>
    80002b88:	8aaa                	mv	s5,a0
    80002b8a:	8bae                	mv	s7,a1
    80002b8c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b8e:	00015a17          	auipc	s4,0x15
    80002b92:	bcaa0a13          	addi	s4,s4,-1078 # 80017758 <sb>
    80002b96:	00048b1b          	sext.w	s6,s1
    80002b9a:	0044d593          	srli	a1,s1,0x4
    80002b9e:	018a2783          	lw	a5,24(s4)
    80002ba2:	9dbd                	addw	a1,a1,a5
    80002ba4:	8556                	mv	a0,s5
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	954080e7          	jalr	-1708(ra) # 800024fa <bread>
    80002bae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bb0:	05850993          	addi	s3,a0,88
    80002bb4:	00f4f793          	andi	a5,s1,15
    80002bb8:	079a                	slli	a5,a5,0x6
    80002bba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bbc:	00099783          	lh	a5,0(s3)
    80002bc0:	c785                	beqz	a5,80002be8 <ialloc+0x84>
    brelse(bp);
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	a68080e7          	jalr	-1432(ra) # 8000262a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bca:	0485                	addi	s1,s1,1
    80002bcc:	00ca2703          	lw	a4,12(s4)
    80002bd0:	0004879b          	sext.w	a5,s1
    80002bd4:	fce7e1e3          	bltu	a5,a4,80002b96 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	a3050513          	addi	a0,a0,-1488 # 80008608 <syscalls+0x1b0>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	1e8080e7          	jalr	488(ra) # 80005dc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002be8:	04000613          	li	a2,64
    80002bec:	4581                	li	a1,0
    80002bee:	854e                	mv	a0,s3
    80002bf0:	ffffd097          	auipc	ra,0xffffd
    80002bf4:	588080e7          	jalr	1416(ra) # 80000178 <memset>
      dip->type = type;
    80002bf8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bfc:	854a                	mv	a0,s2
    80002bfe:	00001097          	auipc	ra,0x1
    80002c02:	ca8080e7          	jalr	-856(ra) # 800038a6 <log_write>
      brelse(bp);
    80002c06:	854a                	mv	a0,s2
    80002c08:	00000097          	auipc	ra,0x0
    80002c0c:	a22080e7          	jalr	-1502(ra) # 8000262a <brelse>
      return iget(dev, inum);
    80002c10:	85da                	mv	a1,s6
    80002c12:	8556                	mv	a0,s5
    80002c14:	00000097          	auipc	ra,0x0
    80002c18:	db4080e7          	jalr	-588(ra) # 800029c8 <iget>
}
    80002c1c:	60a6                	ld	ra,72(sp)
    80002c1e:	6406                	ld	s0,64(sp)
    80002c20:	74e2                	ld	s1,56(sp)
    80002c22:	7942                	ld	s2,48(sp)
    80002c24:	79a2                	ld	s3,40(sp)
    80002c26:	7a02                	ld	s4,32(sp)
    80002c28:	6ae2                	ld	s5,24(sp)
    80002c2a:	6b42                	ld	s6,16(sp)
    80002c2c:	6ba2                	ld	s7,8(sp)
    80002c2e:	6161                	addi	sp,sp,80
    80002c30:	8082                	ret

0000000080002c32 <iupdate>:
{
    80002c32:	1101                	addi	sp,sp,-32
    80002c34:	ec06                	sd	ra,24(sp)
    80002c36:	e822                	sd	s0,16(sp)
    80002c38:	e426                	sd	s1,8(sp)
    80002c3a:	e04a                	sd	s2,0(sp)
    80002c3c:	1000                	addi	s0,sp,32
    80002c3e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c40:	415c                	lw	a5,4(a0)
    80002c42:	0047d79b          	srliw	a5,a5,0x4
    80002c46:	00015597          	auipc	a1,0x15
    80002c4a:	b2a5a583          	lw	a1,-1238(a1) # 80017770 <sb+0x18>
    80002c4e:	9dbd                	addw	a1,a1,a5
    80002c50:	4108                	lw	a0,0(a0)
    80002c52:	00000097          	auipc	ra,0x0
    80002c56:	8a8080e7          	jalr	-1880(ra) # 800024fa <bread>
    80002c5a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c5c:	05850793          	addi	a5,a0,88
    80002c60:	40c8                	lw	a0,4(s1)
    80002c62:	893d                	andi	a0,a0,15
    80002c64:	051a                	slli	a0,a0,0x6
    80002c66:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c68:	04449703          	lh	a4,68(s1)
    80002c6c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c70:	04649703          	lh	a4,70(s1)
    80002c74:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c78:	04849703          	lh	a4,72(s1)
    80002c7c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c80:	04a49703          	lh	a4,74(s1)
    80002c84:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c88:	44f8                	lw	a4,76(s1)
    80002c8a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c8c:	03400613          	li	a2,52
    80002c90:	05048593          	addi	a1,s1,80
    80002c94:	0531                	addi	a0,a0,12
    80002c96:	ffffd097          	auipc	ra,0xffffd
    80002c9a:	542080e7          	jalr	1346(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	00001097          	auipc	ra,0x1
    80002ca4:	c06080e7          	jalr	-1018(ra) # 800038a6 <log_write>
  brelse(bp);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	980080e7          	jalr	-1664(ra) # 8000262a <brelse>
}
    80002cb2:	60e2                	ld	ra,24(sp)
    80002cb4:	6442                	ld	s0,16(sp)
    80002cb6:	64a2                	ld	s1,8(sp)
    80002cb8:	6902                	ld	s2,0(sp)
    80002cba:	6105                	addi	sp,sp,32
    80002cbc:	8082                	ret

0000000080002cbe <idup>:
{
    80002cbe:	1101                	addi	sp,sp,-32
    80002cc0:	ec06                	sd	ra,24(sp)
    80002cc2:	e822                	sd	s0,16(sp)
    80002cc4:	e426                	sd	s1,8(sp)
    80002cc6:	1000                	addi	s0,sp,32
    80002cc8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cca:	00015517          	auipc	a0,0x15
    80002cce:	aae50513          	addi	a0,a0,-1362 # 80017778 <itable>
    80002cd2:	00003097          	auipc	ra,0x3
    80002cd6:	640080e7          	jalr	1600(ra) # 80006312 <acquire>
  ip->ref++;
    80002cda:	449c                	lw	a5,8(s1)
    80002cdc:	2785                	addiw	a5,a5,1
    80002cde:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ce0:	00015517          	auipc	a0,0x15
    80002ce4:	a9850513          	addi	a0,a0,-1384 # 80017778 <itable>
    80002ce8:	00003097          	auipc	ra,0x3
    80002cec:	6de080e7          	jalr	1758(ra) # 800063c6 <release>
}
    80002cf0:	8526                	mv	a0,s1
    80002cf2:	60e2                	ld	ra,24(sp)
    80002cf4:	6442                	ld	s0,16(sp)
    80002cf6:	64a2                	ld	s1,8(sp)
    80002cf8:	6105                	addi	sp,sp,32
    80002cfa:	8082                	ret

0000000080002cfc <ilock>:
{
    80002cfc:	1101                	addi	sp,sp,-32
    80002cfe:	ec06                	sd	ra,24(sp)
    80002d00:	e822                	sd	s0,16(sp)
    80002d02:	e426                	sd	s1,8(sp)
    80002d04:	e04a                	sd	s2,0(sp)
    80002d06:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d08:	c115                	beqz	a0,80002d2c <ilock+0x30>
    80002d0a:	84aa                	mv	s1,a0
    80002d0c:	451c                	lw	a5,8(a0)
    80002d0e:	00f05f63          	blez	a5,80002d2c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d12:	0541                	addi	a0,a0,16
    80002d14:	00001097          	auipc	ra,0x1
    80002d18:	cb2080e7          	jalr	-846(ra) # 800039c6 <acquiresleep>
  if(ip->valid == 0){
    80002d1c:	40bc                	lw	a5,64(s1)
    80002d1e:	cf99                	beqz	a5,80002d3c <ilock+0x40>
}
    80002d20:	60e2                	ld	ra,24(sp)
    80002d22:	6442                	ld	s0,16(sp)
    80002d24:	64a2                	ld	s1,8(sp)
    80002d26:	6902                	ld	s2,0(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret
    panic("ilock");
    80002d2c:	00006517          	auipc	a0,0x6
    80002d30:	8f450513          	addi	a0,a0,-1804 # 80008620 <syscalls+0x1c8>
    80002d34:	00003097          	auipc	ra,0x3
    80002d38:	094080e7          	jalr	148(ra) # 80005dc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d3c:	40dc                	lw	a5,4(s1)
    80002d3e:	0047d79b          	srliw	a5,a5,0x4
    80002d42:	00015597          	auipc	a1,0x15
    80002d46:	a2e5a583          	lw	a1,-1490(a1) # 80017770 <sb+0x18>
    80002d4a:	9dbd                	addw	a1,a1,a5
    80002d4c:	4088                	lw	a0,0(s1)
    80002d4e:	fffff097          	auipc	ra,0xfffff
    80002d52:	7ac080e7          	jalr	1964(ra) # 800024fa <bread>
    80002d56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d58:	05850593          	addi	a1,a0,88
    80002d5c:	40dc                	lw	a5,4(s1)
    80002d5e:	8bbd                	andi	a5,a5,15
    80002d60:	079a                	slli	a5,a5,0x6
    80002d62:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d64:	00059783          	lh	a5,0(a1)
    80002d68:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d6c:	00259783          	lh	a5,2(a1)
    80002d70:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d74:	00459783          	lh	a5,4(a1)
    80002d78:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d7c:	00659783          	lh	a5,6(a1)
    80002d80:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d84:	459c                	lw	a5,8(a1)
    80002d86:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d88:	03400613          	li	a2,52
    80002d8c:	05b1                	addi	a1,a1,12
    80002d8e:	05048513          	addi	a0,s1,80
    80002d92:	ffffd097          	auipc	ra,0xffffd
    80002d96:	446080e7          	jalr	1094(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d9a:	854a                	mv	a0,s2
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	88e080e7          	jalr	-1906(ra) # 8000262a <brelse>
    ip->valid = 1;
    80002da4:	4785                	li	a5,1
    80002da6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002da8:	04449783          	lh	a5,68(s1)
    80002dac:	fbb5                	bnez	a5,80002d20 <ilock+0x24>
      panic("ilock: no type");
    80002dae:	00006517          	auipc	a0,0x6
    80002db2:	87a50513          	addi	a0,a0,-1926 # 80008628 <syscalls+0x1d0>
    80002db6:	00003097          	auipc	ra,0x3
    80002dba:	012080e7          	jalr	18(ra) # 80005dc8 <panic>

0000000080002dbe <iunlock>:
{
    80002dbe:	1101                	addi	sp,sp,-32
    80002dc0:	ec06                	sd	ra,24(sp)
    80002dc2:	e822                	sd	s0,16(sp)
    80002dc4:	e426                	sd	s1,8(sp)
    80002dc6:	e04a                	sd	s2,0(sp)
    80002dc8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dca:	c905                	beqz	a0,80002dfa <iunlock+0x3c>
    80002dcc:	84aa                	mv	s1,a0
    80002dce:	01050913          	addi	s2,a0,16
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	00001097          	auipc	ra,0x1
    80002dd8:	c8c080e7          	jalr	-884(ra) # 80003a60 <holdingsleep>
    80002ddc:	cd19                	beqz	a0,80002dfa <iunlock+0x3c>
    80002dde:	449c                	lw	a5,8(s1)
    80002de0:	00f05d63          	blez	a5,80002dfa <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002de4:	854a                	mv	a0,s2
    80002de6:	00001097          	auipc	ra,0x1
    80002dea:	c36080e7          	jalr	-970(ra) # 80003a1c <releasesleep>
}
    80002dee:	60e2                	ld	ra,24(sp)
    80002df0:	6442                	ld	s0,16(sp)
    80002df2:	64a2                	ld	s1,8(sp)
    80002df4:	6902                	ld	s2,0(sp)
    80002df6:	6105                	addi	sp,sp,32
    80002df8:	8082                	ret
    panic("iunlock");
    80002dfa:	00006517          	auipc	a0,0x6
    80002dfe:	83e50513          	addi	a0,a0,-1986 # 80008638 <syscalls+0x1e0>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	fc6080e7          	jalr	-58(ra) # 80005dc8 <panic>

0000000080002e0a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e0a:	7179                	addi	sp,sp,-48
    80002e0c:	f406                	sd	ra,40(sp)
    80002e0e:	f022                	sd	s0,32(sp)
    80002e10:	ec26                	sd	s1,24(sp)
    80002e12:	e84a                	sd	s2,16(sp)
    80002e14:	e44e                	sd	s3,8(sp)
    80002e16:	e052                	sd	s4,0(sp)
    80002e18:	1800                	addi	s0,sp,48
    80002e1a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e1c:	05050493          	addi	s1,a0,80
    80002e20:	08050913          	addi	s2,a0,128
    80002e24:	a021                	j	80002e2c <itrunc+0x22>
    80002e26:	0491                	addi	s1,s1,4
    80002e28:	01248d63          	beq	s1,s2,80002e42 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e2c:	408c                	lw	a1,0(s1)
    80002e2e:	dde5                	beqz	a1,80002e26 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e30:	0009a503          	lw	a0,0(s3)
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	90c080e7          	jalr	-1780(ra) # 80002740 <bfree>
      ip->addrs[i] = 0;
    80002e3c:	0004a023          	sw	zero,0(s1)
    80002e40:	b7dd                	j	80002e26 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e42:	0809a583          	lw	a1,128(s3)
    80002e46:	e185                	bnez	a1,80002e66 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e48:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e4c:	854e                	mv	a0,s3
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	de4080e7          	jalr	-540(ra) # 80002c32 <iupdate>
}
    80002e56:	70a2                	ld	ra,40(sp)
    80002e58:	7402                	ld	s0,32(sp)
    80002e5a:	64e2                	ld	s1,24(sp)
    80002e5c:	6942                	ld	s2,16(sp)
    80002e5e:	69a2                	ld	s3,8(sp)
    80002e60:	6a02                	ld	s4,0(sp)
    80002e62:	6145                	addi	sp,sp,48
    80002e64:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e66:	0009a503          	lw	a0,0(s3)
    80002e6a:	fffff097          	auipc	ra,0xfffff
    80002e6e:	690080e7          	jalr	1680(ra) # 800024fa <bread>
    80002e72:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e74:	05850493          	addi	s1,a0,88
    80002e78:	45850913          	addi	s2,a0,1112
    80002e7c:	a811                	j	80002e90 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e7e:	0009a503          	lw	a0,0(s3)
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	8be080e7          	jalr	-1858(ra) # 80002740 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e8a:	0491                	addi	s1,s1,4
    80002e8c:	01248563          	beq	s1,s2,80002e96 <itrunc+0x8c>
      if(a[j])
    80002e90:	408c                	lw	a1,0(s1)
    80002e92:	dde5                	beqz	a1,80002e8a <itrunc+0x80>
    80002e94:	b7ed                	j	80002e7e <itrunc+0x74>
    brelse(bp);
    80002e96:	8552                	mv	a0,s4
    80002e98:	fffff097          	auipc	ra,0xfffff
    80002e9c:	792080e7          	jalr	1938(ra) # 8000262a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ea0:	0809a583          	lw	a1,128(s3)
    80002ea4:	0009a503          	lw	a0,0(s3)
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	898080e7          	jalr	-1896(ra) # 80002740 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002eb0:	0809a023          	sw	zero,128(s3)
    80002eb4:	bf51                	j	80002e48 <itrunc+0x3e>

0000000080002eb6 <iput>:
{
    80002eb6:	1101                	addi	sp,sp,-32
    80002eb8:	ec06                	sd	ra,24(sp)
    80002eba:	e822                	sd	s0,16(sp)
    80002ebc:	e426                	sd	s1,8(sp)
    80002ebe:	e04a                	sd	s2,0(sp)
    80002ec0:	1000                	addi	s0,sp,32
    80002ec2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ec4:	00015517          	auipc	a0,0x15
    80002ec8:	8b450513          	addi	a0,a0,-1868 # 80017778 <itable>
    80002ecc:	00003097          	auipc	ra,0x3
    80002ed0:	446080e7          	jalr	1094(ra) # 80006312 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed4:	4498                	lw	a4,8(s1)
    80002ed6:	4785                	li	a5,1
    80002ed8:	02f70363          	beq	a4,a5,80002efe <iput+0x48>
  ip->ref--;
    80002edc:	449c                	lw	a5,8(s1)
    80002ede:	37fd                	addiw	a5,a5,-1
    80002ee0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ee2:	00015517          	auipc	a0,0x15
    80002ee6:	89650513          	addi	a0,a0,-1898 # 80017778 <itable>
    80002eea:	00003097          	auipc	ra,0x3
    80002eee:	4dc080e7          	jalr	1244(ra) # 800063c6 <release>
}
    80002ef2:	60e2                	ld	ra,24(sp)
    80002ef4:	6442                	ld	s0,16(sp)
    80002ef6:	64a2                	ld	s1,8(sp)
    80002ef8:	6902                	ld	s2,0(sp)
    80002efa:	6105                	addi	sp,sp,32
    80002efc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002efe:	40bc                	lw	a5,64(s1)
    80002f00:	dff1                	beqz	a5,80002edc <iput+0x26>
    80002f02:	04a49783          	lh	a5,74(s1)
    80002f06:	fbf9                	bnez	a5,80002edc <iput+0x26>
    acquiresleep(&ip->lock);
    80002f08:	01048913          	addi	s2,s1,16
    80002f0c:	854a                	mv	a0,s2
    80002f0e:	00001097          	auipc	ra,0x1
    80002f12:	ab8080e7          	jalr	-1352(ra) # 800039c6 <acquiresleep>
    release(&itable.lock);
    80002f16:	00015517          	auipc	a0,0x15
    80002f1a:	86250513          	addi	a0,a0,-1950 # 80017778 <itable>
    80002f1e:	00003097          	auipc	ra,0x3
    80002f22:	4a8080e7          	jalr	1192(ra) # 800063c6 <release>
    itrunc(ip);
    80002f26:	8526                	mv	a0,s1
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	ee2080e7          	jalr	-286(ra) # 80002e0a <itrunc>
    ip->type = 0;
    80002f30:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f34:	8526                	mv	a0,s1
    80002f36:	00000097          	auipc	ra,0x0
    80002f3a:	cfc080e7          	jalr	-772(ra) # 80002c32 <iupdate>
    ip->valid = 0;
    80002f3e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f42:	854a                	mv	a0,s2
    80002f44:	00001097          	auipc	ra,0x1
    80002f48:	ad8080e7          	jalr	-1320(ra) # 80003a1c <releasesleep>
    acquire(&itable.lock);
    80002f4c:	00015517          	auipc	a0,0x15
    80002f50:	82c50513          	addi	a0,a0,-2004 # 80017778 <itable>
    80002f54:	00003097          	auipc	ra,0x3
    80002f58:	3be080e7          	jalr	958(ra) # 80006312 <acquire>
    80002f5c:	b741                	j	80002edc <iput+0x26>

0000000080002f5e <iunlockput>:
{
    80002f5e:	1101                	addi	sp,sp,-32
    80002f60:	ec06                	sd	ra,24(sp)
    80002f62:	e822                	sd	s0,16(sp)
    80002f64:	e426                	sd	s1,8(sp)
    80002f66:	1000                	addi	s0,sp,32
    80002f68:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f6a:	00000097          	auipc	ra,0x0
    80002f6e:	e54080e7          	jalr	-428(ra) # 80002dbe <iunlock>
  iput(ip);
    80002f72:	8526                	mv	a0,s1
    80002f74:	00000097          	auipc	ra,0x0
    80002f78:	f42080e7          	jalr	-190(ra) # 80002eb6 <iput>
}
    80002f7c:	60e2                	ld	ra,24(sp)
    80002f7e:	6442                	ld	s0,16(sp)
    80002f80:	64a2                	ld	s1,8(sp)
    80002f82:	6105                	addi	sp,sp,32
    80002f84:	8082                	ret

0000000080002f86 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f86:	1141                	addi	sp,sp,-16
    80002f88:	e422                	sd	s0,8(sp)
    80002f8a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f8c:	411c                	lw	a5,0(a0)
    80002f8e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f90:	415c                	lw	a5,4(a0)
    80002f92:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f94:	04451783          	lh	a5,68(a0)
    80002f98:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f9c:	04a51783          	lh	a5,74(a0)
    80002fa0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fa4:	04c56783          	lwu	a5,76(a0)
    80002fa8:	e99c                	sd	a5,16(a1)
}
    80002faa:	6422                	ld	s0,8(sp)
    80002fac:	0141                	addi	sp,sp,16
    80002fae:	8082                	ret

0000000080002fb0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fb0:	457c                	lw	a5,76(a0)
    80002fb2:	0ed7e963          	bltu	a5,a3,800030a4 <readi+0xf4>
{
    80002fb6:	7159                	addi	sp,sp,-112
    80002fb8:	f486                	sd	ra,104(sp)
    80002fba:	f0a2                	sd	s0,96(sp)
    80002fbc:	eca6                	sd	s1,88(sp)
    80002fbe:	e8ca                	sd	s2,80(sp)
    80002fc0:	e4ce                	sd	s3,72(sp)
    80002fc2:	e0d2                	sd	s4,64(sp)
    80002fc4:	fc56                	sd	s5,56(sp)
    80002fc6:	f85a                	sd	s6,48(sp)
    80002fc8:	f45e                	sd	s7,40(sp)
    80002fca:	f062                	sd	s8,32(sp)
    80002fcc:	ec66                	sd	s9,24(sp)
    80002fce:	e86a                	sd	s10,16(sp)
    80002fd0:	e46e                	sd	s11,8(sp)
    80002fd2:	1880                	addi	s0,sp,112
    80002fd4:	8baa                	mv	s7,a0
    80002fd6:	8c2e                	mv	s8,a1
    80002fd8:	8ab2                	mv	s5,a2
    80002fda:	84b6                	mv	s1,a3
    80002fdc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fde:	9f35                	addw	a4,a4,a3
    return 0;
    80002fe0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fe2:	0ad76063          	bltu	a4,a3,80003082 <readi+0xd2>
  if(off + n > ip->size)
    80002fe6:	00e7f463          	bgeu	a5,a4,80002fee <readi+0x3e>
    n = ip->size - off;
    80002fea:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fee:	0a0b0963          	beqz	s6,800030a0 <readi+0xf0>
    80002ff2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ff8:	5cfd                	li	s9,-1
    80002ffa:	a82d                	j	80003034 <readi+0x84>
    80002ffc:	020a1d93          	slli	s11,s4,0x20
    80003000:	020ddd93          	srli	s11,s11,0x20
    80003004:	05890613          	addi	a2,s2,88
    80003008:	86ee                	mv	a3,s11
    8000300a:	963a                	add	a2,a2,a4
    8000300c:	85d6                	mv	a1,s5
    8000300e:	8562                	mv	a0,s8
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	a64080e7          	jalr	-1436(ra) # 80001a74 <either_copyout>
    80003018:	05950d63          	beq	a0,s9,80003072 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000301c:	854a                	mv	a0,s2
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	60c080e7          	jalr	1548(ra) # 8000262a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003026:	013a09bb          	addw	s3,s4,s3
    8000302a:	009a04bb          	addw	s1,s4,s1
    8000302e:	9aee                	add	s5,s5,s11
    80003030:	0569f763          	bgeu	s3,s6,8000307e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003034:	000ba903          	lw	s2,0(s7)
    80003038:	00a4d59b          	srliw	a1,s1,0xa
    8000303c:	855e                	mv	a0,s7
    8000303e:	00000097          	auipc	ra,0x0
    80003042:	8b0080e7          	jalr	-1872(ra) # 800028ee <bmap>
    80003046:	0005059b          	sext.w	a1,a0
    8000304a:	854a                	mv	a0,s2
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	4ae080e7          	jalr	1198(ra) # 800024fa <bread>
    80003054:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003056:	3ff4f713          	andi	a4,s1,1023
    8000305a:	40ed07bb          	subw	a5,s10,a4
    8000305e:	413b06bb          	subw	a3,s6,s3
    80003062:	8a3e                	mv	s4,a5
    80003064:	2781                	sext.w	a5,a5
    80003066:	0006861b          	sext.w	a2,a3
    8000306a:	f8f679e3          	bgeu	a2,a5,80002ffc <readi+0x4c>
    8000306e:	8a36                	mv	s4,a3
    80003070:	b771                	j	80002ffc <readi+0x4c>
      brelse(bp);
    80003072:	854a                	mv	a0,s2
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	5b6080e7          	jalr	1462(ra) # 8000262a <brelse>
      tot = -1;
    8000307c:	59fd                	li	s3,-1
  }
  return tot;
    8000307e:	0009851b          	sext.w	a0,s3
}
    80003082:	70a6                	ld	ra,104(sp)
    80003084:	7406                	ld	s0,96(sp)
    80003086:	64e6                	ld	s1,88(sp)
    80003088:	6946                	ld	s2,80(sp)
    8000308a:	69a6                	ld	s3,72(sp)
    8000308c:	6a06                	ld	s4,64(sp)
    8000308e:	7ae2                	ld	s5,56(sp)
    80003090:	7b42                	ld	s6,48(sp)
    80003092:	7ba2                	ld	s7,40(sp)
    80003094:	7c02                	ld	s8,32(sp)
    80003096:	6ce2                	ld	s9,24(sp)
    80003098:	6d42                	ld	s10,16(sp)
    8000309a:	6da2                	ld	s11,8(sp)
    8000309c:	6165                	addi	sp,sp,112
    8000309e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030a0:	89da                	mv	s3,s6
    800030a2:	bff1                	j	8000307e <readi+0xce>
    return 0;
    800030a4:	4501                	li	a0,0
}
    800030a6:	8082                	ret

00000000800030a8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030a8:	457c                	lw	a5,76(a0)
    800030aa:	10d7e863          	bltu	a5,a3,800031ba <writei+0x112>
{
    800030ae:	7159                	addi	sp,sp,-112
    800030b0:	f486                	sd	ra,104(sp)
    800030b2:	f0a2                	sd	s0,96(sp)
    800030b4:	eca6                	sd	s1,88(sp)
    800030b6:	e8ca                	sd	s2,80(sp)
    800030b8:	e4ce                	sd	s3,72(sp)
    800030ba:	e0d2                	sd	s4,64(sp)
    800030bc:	fc56                	sd	s5,56(sp)
    800030be:	f85a                	sd	s6,48(sp)
    800030c0:	f45e                	sd	s7,40(sp)
    800030c2:	f062                	sd	s8,32(sp)
    800030c4:	ec66                	sd	s9,24(sp)
    800030c6:	e86a                	sd	s10,16(sp)
    800030c8:	e46e                	sd	s11,8(sp)
    800030ca:	1880                	addi	s0,sp,112
    800030cc:	8b2a                	mv	s6,a0
    800030ce:	8c2e                	mv	s8,a1
    800030d0:	8ab2                	mv	s5,a2
    800030d2:	8936                	mv	s2,a3
    800030d4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030d6:	00e687bb          	addw	a5,a3,a4
    800030da:	0ed7e263          	bltu	a5,a3,800031be <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030de:	00043737          	lui	a4,0x43
    800030e2:	0ef76063          	bltu	a4,a5,800031c2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e6:	0c0b8863          	beqz	s7,800031b6 <writei+0x10e>
    800030ea:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ec:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030f0:	5cfd                	li	s9,-1
    800030f2:	a091                	j	80003136 <writei+0x8e>
    800030f4:	02099d93          	slli	s11,s3,0x20
    800030f8:	020ddd93          	srli	s11,s11,0x20
    800030fc:	05848513          	addi	a0,s1,88
    80003100:	86ee                	mv	a3,s11
    80003102:	8656                	mv	a2,s5
    80003104:	85e2                	mv	a1,s8
    80003106:	953a                	add	a0,a0,a4
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	9c2080e7          	jalr	-1598(ra) # 80001aca <either_copyin>
    80003110:	07950263          	beq	a0,s9,80003174 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003114:	8526                	mv	a0,s1
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	790080e7          	jalr	1936(ra) # 800038a6 <log_write>
    brelse(bp);
    8000311e:	8526                	mv	a0,s1
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	50a080e7          	jalr	1290(ra) # 8000262a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003128:	01498a3b          	addw	s4,s3,s4
    8000312c:	0129893b          	addw	s2,s3,s2
    80003130:	9aee                	add	s5,s5,s11
    80003132:	057a7663          	bgeu	s4,s7,8000317e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003136:	000b2483          	lw	s1,0(s6)
    8000313a:	00a9559b          	srliw	a1,s2,0xa
    8000313e:	855a                	mv	a0,s6
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	7ae080e7          	jalr	1966(ra) # 800028ee <bmap>
    80003148:	0005059b          	sext.w	a1,a0
    8000314c:	8526                	mv	a0,s1
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	3ac080e7          	jalr	940(ra) # 800024fa <bread>
    80003156:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003158:	3ff97713          	andi	a4,s2,1023
    8000315c:	40ed07bb          	subw	a5,s10,a4
    80003160:	414b86bb          	subw	a3,s7,s4
    80003164:	89be                	mv	s3,a5
    80003166:	2781                	sext.w	a5,a5
    80003168:	0006861b          	sext.w	a2,a3
    8000316c:	f8f674e3          	bgeu	a2,a5,800030f4 <writei+0x4c>
    80003170:	89b6                	mv	s3,a3
    80003172:	b749                	j	800030f4 <writei+0x4c>
      brelse(bp);
    80003174:	8526                	mv	a0,s1
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	4b4080e7          	jalr	1204(ra) # 8000262a <brelse>
  }

  if(off > ip->size)
    8000317e:	04cb2783          	lw	a5,76(s6)
    80003182:	0127f463          	bgeu	a5,s2,8000318a <writei+0xe2>
    ip->size = off;
    80003186:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000318a:	855a                	mv	a0,s6
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	aa6080e7          	jalr	-1370(ra) # 80002c32 <iupdate>

  return tot;
    80003194:	000a051b          	sext.w	a0,s4
}
    80003198:	70a6                	ld	ra,104(sp)
    8000319a:	7406                	ld	s0,96(sp)
    8000319c:	64e6                	ld	s1,88(sp)
    8000319e:	6946                	ld	s2,80(sp)
    800031a0:	69a6                	ld	s3,72(sp)
    800031a2:	6a06                	ld	s4,64(sp)
    800031a4:	7ae2                	ld	s5,56(sp)
    800031a6:	7b42                	ld	s6,48(sp)
    800031a8:	7ba2                	ld	s7,40(sp)
    800031aa:	7c02                	ld	s8,32(sp)
    800031ac:	6ce2                	ld	s9,24(sp)
    800031ae:	6d42                	ld	s10,16(sp)
    800031b0:	6da2                	ld	s11,8(sp)
    800031b2:	6165                	addi	sp,sp,112
    800031b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b6:	8a5e                	mv	s4,s7
    800031b8:	bfc9                	j	8000318a <writei+0xe2>
    return -1;
    800031ba:	557d                	li	a0,-1
}
    800031bc:	8082                	ret
    return -1;
    800031be:	557d                	li	a0,-1
    800031c0:	bfe1                	j	80003198 <writei+0xf0>
    return -1;
    800031c2:	557d                	li	a0,-1
    800031c4:	bfd1                	j	80003198 <writei+0xf0>

00000000800031c6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031c6:	1141                	addi	sp,sp,-16
    800031c8:	e406                	sd	ra,8(sp)
    800031ca:	e022                	sd	s0,0(sp)
    800031cc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031ce:	4639                	li	a2,14
    800031d0:	ffffd097          	auipc	ra,0xffffd
    800031d4:	080080e7          	jalr	128(ra) # 80000250 <strncmp>
}
    800031d8:	60a2                	ld	ra,8(sp)
    800031da:	6402                	ld	s0,0(sp)
    800031dc:	0141                	addi	sp,sp,16
    800031de:	8082                	ret

00000000800031e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031e0:	7139                	addi	sp,sp,-64
    800031e2:	fc06                	sd	ra,56(sp)
    800031e4:	f822                	sd	s0,48(sp)
    800031e6:	f426                	sd	s1,40(sp)
    800031e8:	f04a                	sd	s2,32(sp)
    800031ea:	ec4e                	sd	s3,24(sp)
    800031ec:	e852                	sd	s4,16(sp)
    800031ee:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031f0:	04451703          	lh	a4,68(a0)
    800031f4:	4785                	li	a5,1
    800031f6:	00f71a63          	bne	a4,a5,8000320a <dirlookup+0x2a>
    800031fa:	892a                	mv	s2,a0
    800031fc:	89ae                	mv	s3,a1
    800031fe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003200:	457c                	lw	a5,76(a0)
    80003202:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003204:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003206:	e79d                	bnez	a5,80003234 <dirlookup+0x54>
    80003208:	a8a5                	j	80003280 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000320a:	00005517          	auipc	a0,0x5
    8000320e:	43650513          	addi	a0,a0,1078 # 80008640 <syscalls+0x1e8>
    80003212:	00003097          	auipc	ra,0x3
    80003216:	bb6080e7          	jalr	-1098(ra) # 80005dc8 <panic>
      panic("dirlookup read");
    8000321a:	00005517          	auipc	a0,0x5
    8000321e:	43e50513          	addi	a0,a0,1086 # 80008658 <syscalls+0x200>
    80003222:	00003097          	auipc	ra,0x3
    80003226:	ba6080e7          	jalr	-1114(ra) # 80005dc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322a:	24c1                	addiw	s1,s1,16
    8000322c:	04c92783          	lw	a5,76(s2)
    80003230:	04f4f763          	bgeu	s1,a5,8000327e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003234:	4741                	li	a4,16
    80003236:	86a6                	mv	a3,s1
    80003238:	fc040613          	addi	a2,s0,-64
    8000323c:	4581                	li	a1,0
    8000323e:	854a                	mv	a0,s2
    80003240:	00000097          	auipc	ra,0x0
    80003244:	d70080e7          	jalr	-656(ra) # 80002fb0 <readi>
    80003248:	47c1                	li	a5,16
    8000324a:	fcf518e3          	bne	a0,a5,8000321a <dirlookup+0x3a>
    if(de.inum == 0)
    8000324e:	fc045783          	lhu	a5,-64(s0)
    80003252:	dfe1                	beqz	a5,8000322a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003254:	fc240593          	addi	a1,s0,-62
    80003258:	854e                	mv	a0,s3
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	f6c080e7          	jalr	-148(ra) # 800031c6 <namecmp>
    80003262:	f561                	bnez	a0,8000322a <dirlookup+0x4a>
      if(poff)
    80003264:	000a0463          	beqz	s4,8000326c <dirlookup+0x8c>
        *poff = off;
    80003268:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000326c:	fc045583          	lhu	a1,-64(s0)
    80003270:	00092503          	lw	a0,0(s2)
    80003274:	fffff097          	auipc	ra,0xfffff
    80003278:	754080e7          	jalr	1876(ra) # 800029c8 <iget>
    8000327c:	a011                	j	80003280 <dirlookup+0xa0>
  return 0;
    8000327e:	4501                	li	a0,0
}
    80003280:	70e2                	ld	ra,56(sp)
    80003282:	7442                	ld	s0,48(sp)
    80003284:	74a2                	ld	s1,40(sp)
    80003286:	7902                	ld	s2,32(sp)
    80003288:	69e2                	ld	s3,24(sp)
    8000328a:	6a42                	ld	s4,16(sp)
    8000328c:	6121                	addi	sp,sp,64
    8000328e:	8082                	ret

0000000080003290 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003290:	711d                	addi	sp,sp,-96
    80003292:	ec86                	sd	ra,88(sp)
    80003294:	e8a2                	sd	s0,80(sp)
    80003296:	e4a6                	sd	s1,72(sp)
    80003298:	e0ca                	sd	s2,64(sp)
    8000329a:	fc4e                	sd	s3,56(sp)
    8000329c:	f852                	sd	s4,48(sp)
    8000329e:	f456                	sd	s5,40(sp)
    800032a0:	f05a                	sd	s6,32(sp)
    800032a2:	ec5e                	sd	s7,24(sp)
    800032a4:	e862                	sd	s8,16(sp)
    800032a6:	e466                	sd	s9,8(sp)
    800032a8:	1080                	addi	s0,sp,96
    800032aa:	84aa                	mv	s1,a0
    800032ac:	8b2e                	mv	s6,a1
    800032ae:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032b0:	00054703          	lbu	a4,0(a0)
    800032b4:	02f00793          	li	a5,47
    800032b8:	02f70363          	beq	a4,a5,800032de <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	caa080e7          	jalr	-854(ra) # 80000f66 <myproc>
    800032c4:	15853503          	ld	a0,344(a0)
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	9f6080e7          	jalr	-1546(ra) # 80002cbe <idup>
    800032d0:	89aa                	mv	s3,a0
  while(*path == '/')
    800032d2:	02f00913          	li	s2,47
  len = path - s;
    800032d6:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032d8:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032da:	4c05                	li	s8,1
    800032dc:	a865                	j	80003394 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032de:	4585                	li	a1,1
    800032e0:	4505                	li	a0,1
    800032e2:	fffff097          	auipc	ra,0xfffff
    800032e6:	6e6080e7          	jalr	1766(ra) # 800029c8 <iget>
    800032ea:	89aa                	mv	s3,a0
    800032ec:	b7dd                	j	800032d2 <namex+0x42>
      iunlockput(ip);
    800032ee:	854e                	mv	a0,s3
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	c6e080e7          	jalr	-914(ra) # 80002f5e <iunlockput>
      return 0;
    800032f8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032fa:	854e                	mv	a0,s3
    800032fc:	60e6                	ld	ra,88(sp)
    800032fe:	6446                	ld	s0,80(sp)
    80003300:	64a6                	ld	s1,72(sp)
    80003302:	6906                	ld	s2,64(sp)
    80003304:	79e2                	ld	s3,56(sp)
    80003306:	7a42                	ld	s4,48(sp)
    80003308:	7aa2                	ld	s5,40(sp)
    8000330a:	7b02                	ld	s6,32(sp)
    8000330c:	6be2                	ld	s7,24(sp)
    8000330e:	6c42                	ld	s8,16(sp)
    80003310:	6ca2                	ld	s9,8(sp)
    80003312:	6125                	addi	sp,sp,96
    80003314:	8082                	ret
      iunlock(ip);
    80003316:	854e                	mv	a0,s3
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	aa6080e7          	jalr	-1370(ra) # 80002dbe <iunlock>
      return ip;
    80003320:	bfe9                	j	800032fa <namex+0x6a>
      iunlockput(ip);
    80003322:	854e                	mv	a0,s3
    80003324:	00000097          	auipc	ra,0x0
    80003328:	c3a080e7          	jalr	-966(ra) # 80002f5e <iunlockput>
      return 0;
    8000332c:	89d2                	mv	s3,s4
    8000332e:	b7f1                	j	800032fa <namex+0x6a>
  len = path - s;
    80003330:	40b48633          	sub	a2,s1,a1
    80003334:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003338:	094cd463          	bge	s9,s4,800033c0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000333c:	4639                	li	a2,14
    8000333e:	8556                	mv	a0,s5
    80003340:	ffffd097          	auipc	ra,0xffffd
    80003344:	e98080e7          	jalr	-360(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003348:	0004c783          	lbu	a5,0(s1)
    8000334c:	01279763          	bne	a5,s2,8000335a <namex+0xca>
    path++;
    80003350:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003352:	0004c783          	lbu	a5,0(s1)
    80003356:	ff278de3          	beq	a5,s2,80003350 <namex+0xc0>
    ilock(ip);
    8000335a:	854e                	mv	a0,s3
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	9a0080e7          	jalr	-1632(ra) # 80002cfc <ilock>
    if(ip->type != T_DIR){
    80003364:	04499783          	lh	a5,68(s3)
    80003368:	f98793e3          	bne	a5,s8,800032ee <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000336c:	000b0563          	beqz	s6,80003376 <namex+0xe6>
    80003370:	0004c783          	lbu	a5,0(s1)
    80003374:	d3cd                	beqz	a5,80003316 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003376:	865e                	mv	a2,s7
    80003378:	85d6                	mv	a1,s5
    8000337a:	854e                	mv	a0,s3
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	e64080e7          	jalr	-412(ra) # 800031e0 <dirlookup>
    80003384:	8a2a                	mv	s4,a0
    80003386:	dd51                	beqz	a0,80003322 <namex+0x92>
    iunlockput(ip);
    80003388:	854e                	mv	a0,s3
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	bd4080e7          	jalr	-1068(ra) # 80002f5e <iunlockput>
    ip = next;
    80003392:	89d2                	mv	s3,s4
  while(*path == '/')
    80003394:	0004c783          	lbu	a5,0(s1)
    80003398:	05279763          	bne	a5,s2,800033e6 <namex+0x156>
    path++;
    8000339c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000339e:	0004c783          	lbu	a5,0(s1)
    800033a2:	ff278de3          	beq	a5,s2,8000339c <namex+0x10c>
  if(*path == 0)
    800033a6:	c79d                	beqz	a5,800033d4 <namex+0x144>
    path++;
    800033a8:	85a6                	mv	a1,s1
  len = path - s;
    800033aa:	8a5e                	mv	s4,s7
    800033ac:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ae:	01278963          	beq	a5,s2,800033c0 <namex+0x130>
    800033b2:	dfbd                	beqz	a5,80003330 <namex+0xa0>
    path++;
    800033b4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	ff279ce3          	bne	a5,s2,800033b2 <namex+0x122>
    800033be:	bf8d                	j	80003330 <namex+0xa0>
    memmove(name, s, len);
    800033c0:	2601                	sext.w	a2,a2
    800033c2:	8556                	mv	a0,s5
    800033c4:	ffffd097          	auipc	ra,0xffffd
    800033c8:	e14080e7          	jalr	-492(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033cc:	9a56                	add	s4,s4,s5
    800033ce:	000a0023          	sb	zero,0(s4)
    800033d2:	bf9d                	j	80003348 <namex+0xb8>
  if(nameiparent){
    800033d4:	f20b03e3          	beqz	s6,800032fa <namex+0x6a>
    iput(ip);
    800033d8:	854e                	mv	a0,s3
    800033da:	00000097          	auipc	ra,0x0
    800033de:	adc080e7          	jalr	-1316(ra) # 80002eb6 <iput>
    return 0;
    800033e2:	4981                	li	s3,0
    800033e4:	bf19                	j	800032fa <namex+0x6a>
  if(*path == 0)
    800033e6:	d7fd                	beqz	a5,800033d4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033e8:	0004c783          	lbu	a5,0(s1)
    800033ec:	85a6                	mv	a1,s1
    800033ee:	b7d1                	j	800033b2 <namex+0x122>

00000000800033f0 <dirlink>:
{
    800033f0:	7139                	addi	sp,sp,-64
    800033f2:	fc06                	sd	ra,56(sp)
    800033f4:	f822                	sd	s0,48(sp)
    800033f6:	f426                	sd	s1,40(sp)
    800033f8:	f04a                	sd	s2,32(sp)
    800033fa:	ec4e                	sd	s3,24(sp)
    800033fc:	e852                	sd	s4,16(sp)
    800033fe:	0080                	addi	s0,sp,64
    80003400:	892a                	mv	s2,a0
    80003402:	8a2e                	mv	s4,a1
    80003404:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003406:	4601                	li	a2,0
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	dd8080e7          	jalr	-552(ra) # 800031e0 <dirlookup>
    80003410:	e93d                	bnez	a0,80003486 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003412:	04c92483          	lw	s1,76(s2)
    80003416:	c49d                	beqz	s1,80003444 <dirlink+0x54>
    80003418:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341a:	4741                	li	a4,16
    8000341c:	86a6                	mv	a3,s1
    8000341e:	fc040613          	addi	a2,s0,-64
    80003422:	4581                	li	a1,0
    80003424:	854a                	mv	a0,s2
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	b8a080e7          	jalr	-1142(ra) # 80002fb0 <readi>
    8000342e:	47c1                	li	a5,16
    80003430:	06f51163          	bne	a0,a5,80003492 <dirlink+0xa2>
    if(de.inum == 0)
    80003434:	fc045783          	lhu	a5,-64(s0)
    80003438:	c791                	beqz	a5,80003444 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000343a:	24c1                	addiw	s1,s1,16
    8000343c:	04c92783          	lw	a5,76(s2)
    80003440:	fcf4ede3          	bltu	s1,a5,8000341a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003444:	4639                	li	a2,14
    80003446:	85d2                	mv	a1,s4
    80003448:	fc240513          	addi	a0,s0,-62
    8000344c:	ffffd097          	auipc	ra,0xffffd
    80003450:	e40080e7          	jalr	-448(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003454:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003458:	4741                	li	a4,16
    8000345a:	86a6                	mv	a3,s1
    8000345c:	fc040613          	addi	a2,s0,-64
    80003460:	4581                	li	a1,0
    80003462:	854a                	mv	a0,s2
    80003464:	00000097          	auipc	ra,0x0
    80003468:	c44080e7          	jalr	-956(ra) # 800030a8 <writei>
    8000346c:	872a                	mv	a4,a0
    8000346e:	47c1                	li	a5,16
  return 0;
    80003470:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003472:	02f71863          	bne	a4,a5,800034a2 <dirlink+0xb2>
}
    80003476:	70e2                	ld	ra,56(sp)
    80003478:	7442                	ld	s0,48(sp)
    8000347a:	74a2                	ld	s1,40(sp)
    8000347c:	7902                	ld	s2,32(sp)
    8000347e:	69e2                	ld	s3,24(sp)
    80003480:	6a42                	ld	s4,16(sp)
    80003482:	6121                	addi	sp,sp,64
    80003484:	8082                	ret
    iput(ip);
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	a30080e7          	jalr	-1488(ra) # 80002eb6 <iput>
    return -1;
    8000348e:	557d                	li	a0,-1
    80003490:	b7dd                	j	80003476 <dirlink+0x86>
      panic("dirlink read");
    80003492:	00005517          	auipc	a0,0x5
    80003496:	1d650513          	addi	a0,a0,470 # 80008668 <syscalls+0x210>
    8000349a:	00003097          	auipc	ra,0x3
    8000349e:	92e080e7          	jalr	-1746(ra) # 80005dc8 <panic>
    panic("dirlink");
    800034a2:	00005517          	auipc	a0,0x5
    800034a6:	2ce50513          	addi	a0,a0,718 # 80008770 <syscalls+0x318>
    800034aa:	00003097          	auipc	ra,0x3
    800034ae:	91e080e7          	jalr	-1762(ra) # 80005dc8 <panic>

00000000800034b2 <namei>:

struct inode*
namei(char *path)
{
    800034b2:	1101                	addi	sp,sp,-32
    800034b4:	ec06                	sd	ra,24(sp)
    800034b6:	e822                	sd	s0,16(sp)
    800034b8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034ba:	fe040613          	addi	a2,s0,-32
    800034be:	4581                	li	a1,0
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	dd0080e7          	jalr	-560(ra) # 80003290 <namex>
}
    800034c8:	60e2                	ld	ra,24(sp)
    800034ca:	6442                	ld	s0,16(sp)
    800034cc:	6105                	addi	sp,sp,32
    800034ce:	8082                	ret

00000000800034d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034d0:	1141                	addi	sp,sp,-16
    800034d2:	e406                	sd	ra,8(sp)
    800034d4:	e022                	sd	s0,0(sp)
    800034d6:	0800                	addi	s0,sp,16
    800034d8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034da:	4585                	li	a1,1
    800034dc:	00000097          	auipc	ra,0x0
    800034e0:	db4080e7          	jalr	-588(ra) # 80003290 <namex>
}
    800034e4:	60a2                	ld	ra,8(sp)
    800034e6:	6402                	ld	s0,0(sp)
    800034e8:	0141                	addi	sp,sp,16
    800034ea:	8082                	ret

00000000800034ec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ec:	1101                	addi	sp,sp,-32
    800034ee:	ec06                	sd	ra,24(sp)
    800034f0:	e822                	sd	s0,16(sp)
    800034f2:	e426                	sd	s1,8(sp)
    800034f4:	e04a                	sd	s2,0(sp)
    800034f6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034f8:	00016917          	auipc	s2,0x16
    800034fc:	d2890913          	addi	s2,s2,-728 # 80019220 <log>
    80003500:	01892583          	lw	a1,24(s2)
    80003504:	02892503          	lw	a0,40(s2)
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	ff2080e7          	jalr	-14(ra) # 800024fa <bread>
    80003510:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003512:	02c92683          	lw	a3,44(s2)
    80003516:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003518:	02d05763          	blez	a3,80003546 <write_head+0x5a>
    8000351c:	00016797          	auipc	a5,0x16
    80003520:	d3478793          	addi	a5,a5,-716 # 80019250 <log+0x30>
    80003524:	05c50713          	addi	a4,a0,92
    80003528:	36fd                	addiw	a3,a3,-1
    8000352a:	1682                	slli	a3,a3,0x20
    8000352c:	9281                	srli	a3,a3,0x20
    8000352e:	068a                	slli	a3,a3,0x2
    80003530:	00016617          	auipc	a2,0x16
    80003534:	d2460613          	addi	a2,a2,-732 # 80019254 <log+0x34>
    80003538:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000353a:	4390                	lw	a2,0(a5)
    8000353c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	0791                	addi	a5,a5,4
    80003540:	0711                	addi	a4,a4,4
    80003542:	fed79ce3          	bne	a5,a3,8000353a <write_head+0x4e>
  }
  bwrite(buf);
    80003546:	8526                	mv	a0,s1
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	0a4080e7          	jalr	164(ra) # 800025ec <bwrite>
  brelse(buf);
    80003550:	8526                	mv	a0,s1
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	0d8080e7          	jalr	216(ra) # 8000262a <brelse>
}
    8000355a:	60e2                	ld	ra,24(sp)
    8000355c:	6442                	ld	s0,16(sp)
    8000355e:	64a2                	ld	s1,8(sp)
    80003560:	6902                	ld	s2,0(sp)
    80003562:	6105                	addi	sp,sp,32
    80003564:	8082                	ret

0000000080003566 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003566:	00016797          	auipc	a5,0x16
    8000356a:	ce67a783          	lw	a5,-794(a5) # 8001924c <log+0x2c>
    8000356e:	0af05d63          	blez	a5,80003628 <install_trans+0xc2>
{
    80003572:	7139                	addi	sp,sp,-64
    80003574:	fc06                	sd	ra,56(sp)
    80003576:	f822                	sd	s0,48(sp)
    80003578:	f426                	sd	s1,40(sp)
    8000357a:	f04a                	sd	s2,32(sp)
    8000357c:	ec4e                	sd	s3,24(sp)
    8000357e:	e852                	sd	s4,16(sp)
    80003580:	e456                	sd	s5,8(sp)
    80003582:	e05a                	sd	s6,0(sp)
    80003584:	0080                	addi	s0,sp,64
    80003586:	8b2a                	mv	s6,a0
    80003588:	00016a97          	auipc	s5,0x16
    8000358c:	cc8a8a93          	addi	s5,s5,-824 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003590:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003592:	00016997          	auipc	s3,0x16
    80003596:	c8e98993          	addi	s3,s3,-882 # 80019220 <log>
    8000359a:	a035                	j	800035c6 <install_trans+0x60>
      bunpin(dbuf);
    8000359c:	8526                	mv	a0,s1
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	166080e7          	jalr	358(ra) # 80002704 <bunpin>
    brelse(lbuf);
    800035a6:	854a                	mv	a0,s2
    800035a8:	fffff097          	auipc	ra,0xfffff
    800035ac:	082080e7          	jalr	130(ra) # 8000262a <brelse>
    brelse(dbuf);
    800035b0:	8526                	mv	a0,s1
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	078080e7          	jalr	120(ra) # 8000262a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ba:	2a05                	addiw	s4,s4,1
    800035bc:	0a91                	addi	s5,s5,4
    800035be:	02c9a783          	lw	a5,44(s3)
    800035c2:	04fa5963          	bge	s4,a5,80003614 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c6:	0189a583          	lw	a1,24(s3)
    800035ca:	014585bb          	addw	a1,a1,s4
    800035ce:	2585                	addiw	a1,a1,1
    800035d0:	0289a503          	lw	a0,40(s3)
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	f26080e7          	jalr	-218(ra) # 800024fa <bread>
    800035dc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035de:	000aa583          	lw	a1,0(s5)
    800035e2:	0289a503          	lw	a0,40(s3)
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	f14080e7          	jalr	-236(ra) # 800024fa <bread>
    800035ee:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035f0:	40000613          	li	a2,1024
    800035f4:	05890593          	addi	a1,s2,88
    800035f8:	05850513          	addi	a0,a0,88
    800035fc:	ffffd097          	auipc	ra,0xffffd
    80003600:	bdc080e7          	jalr	-1060(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003604:	8526                	mv	a0,s1
    80003606:	fffff097          	auipc	ra,0xfffff
    8000360a:	fe6080e7          	jalr	-26(ra) # 800025ec <bwrite>
    if(recovering == 0)
    8000360e:	f80b1ce3          	bnez	s6,800035a6 <install_trans+0x40>
    80003612:	b769                	j	8000359c <install_trans+0x36>
}
    80003614:	70e2                	ld	ra,56(sp)
    80003616:	7442                	ld	s0,48(sp)
    80003618:	74a2                	ld	s1,40(sp)
    8000361a:	7902                	ld	s2,32(sp)
    8000361c:	69e2                	ld	s3,24(sp)
    8000361e:	6a42                	ld	s4,16(sp)
    80003620:	6aa2                	ld	s5,8(sp)
    80003622:	6b02                	ld	s6,0(sp)
    80003624:	6121                	addi	sp,sp,64
    80003626:	8082                	ret
    80003628:	8082                	ret

000000008000362a <initlog>:
{
    8000362a:	7179                	addi	sp,sp,-48
    8000362c:	f406                	sd	ra,40(sp)
    8000362e:	f022                	sd	s0,32(sp)
    80003630:	ec26                	sd	s1,24(sp)
    80003632:	e84a                	sd	s2,16(sp)
    80003634:	e44e                	sd	s3,8(sp)
    80003636:	1800                	addi	s0,sp,48
    80003638:	892a                	mv	s2,a0
    8000363a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000363c:	00016497          	auipc	s1,0x16
    80003640:	be448493          	addi	s1,s1,-1052 # 80019220 <log>
    80003644:	00005597          	auipc	a1,0x5
    80003648:	03458593          	addi	a1,a1,52 # 80008678 <syscalls+0x220>
    8000364c:	8526                	mv	a0,s1
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	c34080e7          	jalr	-972(ra) # 80006282 <initlock>
  log.start = sb->logstart;
    80003656:	0149a583          	lw	a1,20(s3)
    8000365a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000365c:	0109a783          	lw	a5,16(s3)
    80003660:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003662:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003666:	854a                	mv	a0,s2
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	e92080e7          	jalr	-366(ra) # 800024fa <bread>
  log.lh.n = lh->n;
    80003670:	4d3c                	lw	a5,88(a0)
    80003672:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003674:	02f05563          	blez	a5,8000369e <initlog+0x74>
    80003678:	05c50713          	addi	a4,a0,92
    8000367c:	00016697          	auipc	a3,0x16
    80003680:	bd468693          	addi	a3,a3,-1068 # 80019250 <log+0x30>
    80003684:	37fd                	addiw	a5,a5,-1
    80003686:	1782                	slli	a5,a5,0x20
    80003688:	9381                	srli	a5,a5,0x20
    8000368a:	078a                	slli	a5,a5,0x2
    8000368c:	06050613          	addi	a2,a0,96
    80003690:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003692:	4310                	lw	a2,0(a4)
    80003694:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003696:	0711                	addi	a4,a4,4
    80003698:	0691                	addi	a3,a3,4
    8000369a:	fef71ce3          	bne	a4,a5,80003692 <initlog+0x68>
  brelse(buf);
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	f8c080e7          	jalr	-116(ra) # 8000262a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036a6:	4505                	li	a0,1
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	ebe080e7          	jalr	-322(ra) # 80003566 <install_trans>
  log.lh.n = 0;
    800036b0:	00016797          	auipc	a5,0x16
    800036b4:	b807ae23          	sw	zero,-1124(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036b8:	00000097          	auipc	ra,0x0
    800036bc:	e34080e7          	jalr	-460(ra) # 800034ec <write_head>
}
    800036c0:	70a2                	ld	ra,40(sp)
    800036c2:	7402                	ld	s0,32(sp)
    800036c4:	64e2                	ld	s1,24(sp)
    800036c6:	6942                	ld	s2,16(sp)
    800036c8:	69a2                	ld	s3,8(sp)
    800036ca:	6145                	addi	sp,sp,48
    800036cc:	8082                	ret

00000000800036ce <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036ce:	1101                	addi	sp,sp,-32
    800036d0:	ec06                	sd	ra,24(sp)
    800036d2:	e822                	sd	s0,16(sp)
    800036d4:	e426                	sd	s1,8(sp)
    800036d6:	e04a                	sd	s2,0(sp)
    800036d8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036da:	00016517          	auipc	a0,0x16
    800036de:	b4650513          	addi	a0,a0,-1210 # 80019220 <log>
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	c30080e7          	jalr	-976(ra) # 80006312 <acquire>
  while(1){
    if(log.committing){
    800036ea:	00016497          	auipc	s1,0x16
    800036ee:	b3648493          	addi	s1,s1,-1226 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f2:	4979                	li	s2,30
    800036f4:	a039                	j	80003702 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036f6:	85a6                	mv	a1,s1
    800036f8:	8526                	mv	a0,s1
    800036fa:	ffffe097          	auipc	ra,0xffffe
    800036fe:	fd6080e7          	jalr	-42(ra) # 800016d0 <sleep>
    if(log.committing){
    80003702:	50dc                	lw	a5,36(s1)
    80003704:	fbed                	bnez	a5,800036f6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003706:	509c                	lw	a5,32(s1)
    80003708:	0017871b          	addiw	a4,a5,1
    8000370c:	0007069b          	sext.w	a3,a4
    80003710:	0027179b          	slliw	a5,a4,0x2
    80003714:	9fb9                	addw	a5,a5,a4
    80003716:	0017979b          	slliw	a5,a5,0x1
    8000371a:	54d8                	lw	a4,44(s1)
    8000371c:	9fb9                	addw	a5,a5,a4
    8000371e:	00f95963          	bge	s2,a5,80003730 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003722:	85a6                	mv	a1,s1
    80003724:	8526                	mv	a0,s1
    80003726:	ffffe097          	auipc	ra,0xffffe
    8000372a:	faa080e7          	jalr	-86(ra) # 800016d0 <sleep>
    8000372e:	bfd1                	j	80003702 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003730:	00016517          	auipc	a0,0x16
    80003734:	af050513          	addi	a0,a0,-1296 # 80019220 <log>
    80003738:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	c8c080e7          	jalr	-884(ra) # 800063c6 <release>
      break;
    }
  }
}
    80003742:	60e2                	ld	ra,24(sp)
    80003744:	6442                	ld	s0,16(sp)
    80003746:	64a2                	ld	s1,8(sp)
    80003748:	6902                	ld	s2,0(sp)
    8000374a:	6105                	addi	sp,sp,32
    8000374c:	8082                	ret

000000008000374e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000374e:	7139                	addi	sp,sp,-64
    80003750:	fc06                	sd	ra,56(sp)
    80003752:	f822                	sd	s0,48(sp)
    80003754:	f426                	sd	s1,40(sp)
    80003756:	f04a                	sd	s2,32(sp)
    80003758:	ec4e                	sd	s3,24(sp)
    8000375a:	e852                	sd	s4,16(sp)
    8000375c:	e456                	sd	s5,8(sp)
    8000375e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003760:	00016497          	auipc	s1,0x16
    80003764:	ac048493          	addi	s1,s1,-1344 # 80019220 <log>
    80003768:	8526                	mv	a0,s1
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	ba8080e7          	jalr	-1112(ra) # 80006312 <acquire>
  log.outstanding -= 1;
    80003772:	509c                	lw	a5,32(s1)
    80003774:	37fd                	addiw	a5,a5,-1
    80003776:	0007891b          	sext.w	s2,a5
    8000377a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000377c:	50dc                	lw	a5,36(s1)
    8000377e:	efb9                	bnez	a5,800037dc <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003780:	06091663          	bnez	s2,800037ec <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003784:	00016497          	auipc	s1,0x16
    80003788:	a9c48493          	addi	s1,s1,-1380 # 80019220 <log>
    8000378c:	4785                	li	a5,1
    8000378e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003790:	8526                	mv	a0,s1
    80003792:	00003097          	auipc	ra,0x3
    80003796:	c34080e7          	jalr	-972(ra) # 800063c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000379a:	54dc                	lw	a5,44(s1)
    8000379c:	06f04763          	bgtz	a5,8000380a <end_op+0xbc>
    acquire(&log.lock);
    800037a0:	00016497          	auipc	s1,0x16
    800037a4:	a8048493          	addi	s1,s1,-1408 # 80019220 <log>
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	b68080e7          	jalr	-1176(ra) # 80006312 <acquire>
    log.committing = 0;
    800037b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037b6:	8526                	mv	a0,s1
    800037b8:	ffffe097          	auipc	ra,0xffffe
    800037bc:	0a4080e7          	jalr	164(ra) # 8000185c <wakeup>
    release(&log.lock);
    800037c0:	8526                	mv	a0,s1
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	c04080e7          	jalr	-1020(ra) # 800063c6 <release>
}
    800037ca:	70e2                	ld	ra,56(sp)
    800037cc:	7442                	ld	s0,48(sp)
    800037ce:	74a2                	ld	s1,40(sp)
    800037d0:	7902                	ld	s2,32(sp)
    800037d2:	69e2                	ld	s3,24(sp)
    800037d4:	6a42                	ld	s4,16(sp)
    800037d6:	6aa2                	ld	s5,8(sp)
    800037d8:	6121                	addi	sp,sp,64
    800037da:	8082                	ret
    panic("log.committing");
    800037dc:	00005517          	auipc	a0,0x5
    800037e0:	ea450513          	addi	a0,a0,-348 # 80008680 <syscalls+0x228>
    800037e4:	00002097          	auipc	ra,0x2
    800037e8:	5e4080e7          	jalr	1508(ra) # 80005dc8 <panic>
    wakeup(&log);
    800037ec:	00016497          	auipc	s1,0x16
    800037f0:	a3448493          	addi	s1,s1,-1484 # 80019220 <log>
    800037f4:	8526                	mv	a0,s1
    800037f6:	ffffe097          	auipc	ra,0xffffe
    800037fa:	066080e7          	jalr	102(ra) # 8000185c <wakeup>
  release(&log.lock);
    800037fe:	8526                	mv	a0,s1
    80003800:	00003097          	auipc	ra,0x3
    80003804:	bc6080e7          	jalr	-1082(ra) # 800063c6 <release>
  if(do_commit){
    80003808:	b7c9                	j	800037ca <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380a:	00016a97          	auipc	s5,0x16
    8000380e:	a46a8a93          	addi	s5,s5,-1466 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003812:	00016a17          	auipc	s4,0x16
    80003816:	a0ea0a13          	addi	s4,s4,-1522 # 80019220 <log>
    8000381a:	018a2583          	lw	a1,24(s4)
    8000381e:	012585bb          	addw	a1,a1,s2
    80003822:	2585                	addiw	a1,a1,1
    80003824:	028a2503          	lw	a0,40(s4)
    80003828:	fffff097          	auipc	ra,0xfffff
    8000382c:	cd2080e7          	jalr	-814(ra) # 800024fa <bread>
    80003830:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003832:	000aa583          	lw	a1,0(s5)
    80003836:	028a2503          	lw	a0,40(s4)
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	cc0080e7          	jalr	-832(ra) # 800024fa <bread>
    80003842:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003844:	40000613          	li	a2,1024
    80003848:	05850593          	addi	a1,a0,88
    8000384c:	05848513          	addi	a0,s1,88
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	988080e7          	jalr	-1656(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003858:	8526                	mv	a0,s1
    8000385a:	fffff097          	auipc	ra,0xfffff
    8000385e:	d92080e7          	jalr	-622(ra) # 800025ec <bwrite>
    brelse(from);
    80003862:	854e                	mv	a0,s3
    80003864:	fffff097          	auipc	ra,0xfffff
    80003868:	dc6080e7          	jalr	-570(ra) # 8000262a <brelse>
    brelse(to);
    8000386c:	8526                	mv	a0,s1
    8000386e:	fffff097          	auipc	ra,0xfffff
    80003872:	dbc080e7          	jalr	-580(ra) # 8000262a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003876:	2905                	addiw	s2,s2,1
    80003878:	0a91                	addi	s5,s5,4
    8000387a:	02ca2783          	lw	a5,44(s4)
    8000387e:	f8f94ee3          	blt	s2,a5,8000381a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003882:	00000097          	auipc	ra,0x0
    80003886:	c6a080e7          	jalr	-918(ra) # 800034ec <write_head>
    install_trans(0); // Now install writes to home locations
    8000388a:	4501                	li	a0,0
    8000388c:	00000097          	auipc	ra,0x0
    80003890:	cda080e7          	jalr	-806(ra) # 80003566 <install_trans>
    log.lh.n = 0;
    80003894:	00016797          	auipc	a5,0x16
    80003898:	9a07ac23          	sw	zero,-1608(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	c50080e7          	jalr	-944(ra) # 800034ec <write_head>
    800038a4:	bdf5                	j	800037a0 <end_op+0x52>

00000000800038a6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038a6:	1101                	addi	sp,sp,-32
    800038a8:	ec06                	sd	ra,24(sp)
    800038aa:	e822                	sd	s0,16(sp)
    800038ac:	e426                	sd	s1,8(sp)
    800038ae:	e04a                	sd	s2,0(sp)
    800038b0:	1000                	addi	s0,sp,32
    800038b2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038b4:	00016917          	auipc	s2,0x16
    800038b8:	96c90913          	addi	s2,s2,-1684 # 80019220 <log>
    800038bc:	854a                	mv	a0,s2
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	a54080e7          	jalr	-1452(ra) # 80006312 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038c6:	02c92603          	lw	a2,44(s2)
    800038ca:	47f5                	li	a5,29
    800038cc:	06c7c563          	blt	a5,a2,80003936 <log_write+0x90>
    800038d0:	00016797          	auipc	a5,0x16
    800038d4:	96c7a783          	lw	a5,-1684(a5) # 8001923c <log+0x1c>
    800038d8:	37fd                	addiw	a5,a5,-1
    800038da:	04f65e63          	bge	a2,a5,80003936 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038de:	00016797          	auipc	a5,0x16
    800038e2:	9627a783          	lw	a5,-1694(a5) # 80019240 <log+0x20>
    800038e6:	06f05063          	blez	a5,80003946 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038ea:	4781                	li	a5,0
    800038ec:	06c05563          	blez	a2,80003956 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f0:	44cc                	lw	a1,12(s1)
    800038f2:	00016717          	auipc	a4,0x16
    800038f6:	95e70713          	addi	a4,a4,-1698 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038fa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038fc:	4314                	lw	a3,0(a4)
    800038fe:	04b68c63          	beq	a3,a1,80003956 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003902:	2785                	addiw	a5,a5,1
    80003904:	0711                	addi	a4,a4,4
    80003906:	fef61be3          	bne	a2,a5,800038fc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000390a:	0621                	addi	a2,a2,8
    8000390c:	060a                	slli	a2,a2,0x2
    8000390e:	00016797          	auipc	a5,0x16
    80003912:	91278793          	addi	a5,a5,-1774 # 80019220 <log>
    80003916:	963e                	add	a2,a2,a5
    80003918:	44dc                	lw	a5,12(s1)
    8000391a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000391c:	8526                	mv	a0,s1
    8000391e:	fffff097          	auipc	ra,0xfffff
    80003922:	daa080e7          	jalr	-598(ra) # 800026c8 <bpin>
    log.lh.n++;
    80003926:	00016717          	auipc	a4,0x16
    8000392a:	8fa70713          	addi	a4,a4,-1798 # 80019220 <log>
    8000392e:	575c                	lw	a5,44(a4)
    80003930:	2785                	addiw	a5,a5,1
    80003932:	d75c                	sw	a5,44(a4)
    80003934:	a835                	j	80003970 <log_write+0xca>
    panic("too big a transaction");
    80003936:	00005517          	auipc	a0,0x5
    8000393a:	d5a50513          	addi	a0,a0,-678 # 80008690 <syscalls+0x238>
    8000393e:	00002097          	auipc	ra,0x2
    80003942:	48a080e7          	jalr	1162(ra) # 80005dc8 <panic>
    panic("log_write outside of trans");
    80003946:	00005517          	auipc	a0,0x5
    8000394a:	d6250513          	addi	a0,a0,-670 # 800086a8 <syscalls+0x250>
    8000394e:	00002097          	auipc	ra,0x2
    80003952:	47a080e7          	jalr	1146(ra) # 80005dc8 <panic>
  log.lh.block[i] = b->blockno;
    80003956:	00878713          	addi	a4,a5,8
    8000395a:	00271693          	slli	a3,a4,0x2
    8000395e:	00016717          	auipc	a4,0x16
    80003962:	8c270713          	addi	a4,a4,-1854 # 80019220 <log>
    80003966:	9736                	add	a4,a4,a3
    80003968:	44d4                	lw	a3,12(s1)
    8000396a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000396c:	faf608e3          	beq	a2,a5,8000391c <log_write+0x76>
  }
  release(&log.lock);
    80003970:	00016517          	auipc	a0,0x16
    80003974:	8b050513          	addi	a0,a0,-1872 # 80019220 <log>
    80003978:	00003097          	auipc	ra,0x3
    8000397c:	a4e080e7          	jalr	-1458(ra) # 800063c6 <release>
}
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6902                	ld	s2,0(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000398c:	1101                	addi	sp,sp,-32
    8000398e:	ec06                	sd	ra,24(sp)
    80003990:	e822                	sd	s0,16(sp)
    80003992:	e426                	sd	s1,8(sp)
    80003994:	e04a                	sd	s2,0(sp)
    80003996:	1000                	addi	s0,sp,32
    80003998:	84aa                	mv	s1,a0
    8000399a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000399c:	00005597          	auipc	a1,0x5
    800039a0:	d2c58593          	addi	a1,a1,-724 # 800086c8 <syscalls+0x270>
    800039a4:	0521                	addi	a0,a0,8
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	8dc080e7          	jalr	-1828(ra) # 80006282 <initlock>
  lk->name = name;
    800039ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b6:	0204a423          	sw	zero,40(s1)
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	e04a                	sd	s2,0(sp)
    800039d0:	1000                	addi	s0,sp,32
    800039d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039d4:	00850913          	addi	s2,a0,8
    800039d8:	854a                	mv	a0,s2
    800039da:	00003097          	auipc	ra,0x3
    800039de:	938080e7          	jalr	-1736(ra) # 80006312 <acquire>
  while (lk->locked) {
    800039e2:	409c                	lw	a5,0(s1)
    800039e4:	cb89                	beqz	a5,800039f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039e6:	85ca                	mv	a1,s2
    800039e8:	8526                	mv	a0,s1
    800039ea:	ffffe097          	auipc	ra,0xffffe
    800039ee:	ce6080e7          	jalr	-794(ra) # 800016d0 <sleep>
  while (lk->locked) {
    800039f2:	409c                	lw	a5,0(s1)
    800039f4:	fbed                	bnez	a5,800039e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039f6:	4785                	li	a5,1
    800039f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039fa:	ffffd097          	auipc	ra,0xffffd
    800039fe:	56c080e7          	jalr	1388(ra) # 80000f66 <myproc>
    80003a02:	591c                	lw	a5,48(a0)
    80003a04:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a06:	854a                	mv	a0,s2
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	9be080e7          	jalr	-1602(ra) # 800063c6 <release>
}
    80003a10:	60e2                	ld	ra,24(sp)
    80003a12:	6442                	ld	s0,16(sp)
    80003a14:	64a2                	ld	s1,8(sp)
    80003a16:	6902                	ld	s2,0(sp)
    80003a18:	6105                	addi	sp,sp,32
    80003a1a:	8082                	ret

0000000080003a1c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a1c:	1101                	addi	sp,sp,-32
    80003a1e:	ec06                	sd	ra,24(sp)
    80003a20:	e822                	sd	s0,16(sp)
    80003a22:	e426                	sd	s1,8(sp)
    80003a24:	e04a                	sd	s2,0(sp)
    80003a26:	1000                	addi	s0,sp,32
    80003a28:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a2a:	00850913          	addi	s2,a0,8
    80003a2e:	854a                	mv	a0,s2
    80003a30:	00003097          	auipc	ra,0x3
    80003a34:	8e2080e7          	jalr	-1822(ra) # 80006312 <acquire>
  lk->locked = 0;
    80003a38:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a3c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a40:	8526                	mv	a0,s1
    80003a42:	ffffe097          	auipc	ra,0xffffe
    80003a46:	e1a080e7          	jalr	-486(ra) # 8000185c <wakeup>
  release(&lk->lk);
    80003a4a:	854a                	mv	a0,s2
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	97a080e7          	jalr	-1670(ra) # 800063c6 <release>
}
    80003a54:	60e2                	ld	ra,24(sp)
    80003a56:	6442                	ld	s0,16(sp)
    80003a58:	64a2                	ld	s1,8(sp)
    80003a5a:	6902                	ld	s2,0(sp)
    80003a5c:	6105                	addi	sp,sp,32
    80003a5e:	8082                	ret

0000000080003a60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a60:	7179                	addi	sp,sp,-48
    80003a62:	f406                	sd	ra,40(sp)
    80003a64:	f022                	sd	s0,32(sp)
    80003a66:	ec26                	sd	s1,24(sp)
    80003a68:	e84a                	sd	s2,16(sp)
    80003a6a:	e44e                	sd	s3,8(sp)
    80003a6c:	1800                	addi	s0,sp,48
    80003a6e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a70:	00850913          	addi	s2,a0,8
    80003a74:	854a                	mv	a0,s2
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	89c080e7          	jalr	-1892(ra) # 80006312 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a7e:	409c                	lw	a5,0(s1)
    80003a80:	ef99                	bnez	a5,80003a9e <holdingsleep+0x3e>
    80003a82:	4481                	li	s1,0
  release(&lk->lk);
    80003a84:	854a                	mv	a0,s2
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	940080e7          	jalr	-1728(ra) # 800063c6 <release>
  return r;
}
    80003a8e:	8526                	mv	a0,s1
    80003a90:	70a2                	ld	ra,40(sp)
    80003a92:	7402                	ld	s0,32(sp)
    80003a94:	64e2                	ld	s1,24(sp)
    80003a96:	6942                	ld	s2,16(sp)
    80003a98:	69a2                	ld	s3,8(sp)
    80003a9a:	6145                	addi	sp,sp,48
    80003a9c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a9e:	0284a983          	lw	s3,40(s1)
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	4c4080e7          	jalr	1220(ra) # 80000f66 <myproc>
    80003aaa:	5904                	lw	s1,48(a0)
    80003aac:	413484b3          	sub	s1,s1,s3
    80003ab0:	0014b493          	seqz	s1,s1
    80003ab4:	bfc1                	j	80003a84 <holdingsleep+0x24>

0000000080003ab6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ab6:	1141                	addi	sp,sp,-16
    80003ab8:	e406                	sd	ra,8(sp)
    80003aba:	e022                	sd	s0,0(sp)
    80003abc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003abe:	00005597          	auipc	a1,0x5
    80003ac2:	c1a58593          	addi	a1,a1,-998 # 800086d8 <syscalls+0x280>
    80003ac6:	00016517          	auipc	a0,0x16
    80003aca:	8a250513          	addi	a0,a0,-1886 # 80019368 <ftable>
    80003ace:	00002097          	auipc	ra,0x2
    80003ad2:	7b4080e7          	jalr	1972(ra) # 80006282 <initlock>
}
    80003ad6:	60a2                	ld	ra,8(sp)
    80003ad8:	6402                	ld	s0,0(sp)
    80003ada:	0141                	addi	sp,sp,16
    80003adc:	8082                	ret

0000000080003ade <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ade:	1101                	addi	sp,sp,-32
    80003ae0:	ec06                	sd	ra,24(sp)
    80003ae2:	e822                	sd	s0,16(sp)
    80003ae4:	e426                	sd	s1,8(sp)
    80003ae6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ae8:	00016517          	auipc	a0,0x16
    80003aec:	88050513          	addi	a0,a0,-1920 # 80019368 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	822080e7          	jalr	-2014(ra) # 80006312 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003af8:	00016497          	auipc	s1,0x16
    80003afc:	88848493          	addi	s1,s1,-1912 # 80019380 <ftable+0x18>
    80003b00:	00017717          	auipc	a4,0x17
    80003b04:	82070713          	addi	a4,a4,-2016 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b08:	40dc                	lw	a5,4(s1)
    80003b0a:	cf99                	beqz	a5,80003b28 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0c:	02848493          	addi	s1,s1,40
    80003b10:	fee49ce3          	bne	s1,a4,80003b08 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b14:	00016517          	auipc	a0,0x16
    80003b18:	85450513          	addi	a0,a0,-1964 # 80019368 <ftable>
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	8aa080e7          	jalr	-1878(ra) # 800063c6 <release>
  return 0;
    80003b24:	4481                	li	s1,0
    80003b26:	a819                	j	80003b3c <filealloc+0x5e>
      f->ref = 1;
    80003b28:	4785                	li	a5,1
    80003b2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b2c:	00016517          	auipc	a0,0x16
    80003b30:	83c50513          	addi	a0,a0,-1988 # 80019368 <ftable>
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	892080e7          	jalr	-1902(ra) # 800063c6 <release>
}
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	60e2                	ld	ra,24(sp)
    80003b40:	6442                	ld	s0,16(sp)
    80003b42:	64a2                	ld	s1,8(sp)
    80003b44:	6105                	addi	sp,sp,32
    80003b46:	8082                	ret

0000000080003b48 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	1000                	addi	s0,sp,32
    80003b52:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b54:	00016517          	auipc	a0,0x16
    80003b58:	81450513          	addi	a0,a0,-2028 # 80019368 <ftable>
    80003b5c:	00002097          	auipc	ra,0x2
    80003b60:	7b6080e7          	jalr	1974(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003b64:	40dc                	lw	a5,4(s1)
    80003b66:	02f05263          	blez	a5,80003b8a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b6a:	2785                	addiw	a5,a5,1
    80003b6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b6e:	00015517          	auipc	a0,0x15
    80003b72:	7fa50513          	addi	a0,a0,2042 # 80019368 <ftable>
    80003b76:	00003097          	auipc	ra,0x3
    80003b7a:	850080e7          	jalr	-1968(ra) # 800063c6 <release>
  return f;
}
    80003b7e:	8526                	mv	a0,s1
    80003b80:	60e2                	ld	ra,24(sp)
    80003b82:	6442                	ld	s0,16(sp)
    80003b84:	64a2                	ld	s1,8(sp)
    80003b86:	6105                	addi	sp,sp,32
    80003b88:	8082                	ret
    panic("filedup");
    80003b8a:	00005517          	auipc	a0,0x5
    80003b8e:	b5650513          	addi	a0,a0,-1194 # 800086e0 <syscalls+0x288>
    80003b92:	00002097          	auipc	ra,0x2
    80003b96:	236080e7          	jalr	566(ra) # 80005dc8 <panic>

0000000080003b9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b9a:	7139                	addi	sp,sp,-64
    80003b9c:	fc06                	sd	ra,56(sp)
    80003b9e:	f822                	sd	s0,48(sp)
    80003ba0:	f426                	sd	s1,40(sp)
    80003ba2:	f04a                	sd	s2,32(sp)
    80003ba4:	ec4e                	sd	s3,24(sp)
    80003ba6:	e852                	sd	s4,16(sp)
    80003ba8:	e456                	sd	s5,8(sp)
    80003baa:	0080                	addi	s0,sp,64
    80003bac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bae:	00015517          	auipc	a0,0x15
    80003bb2:	7ba50513          	addi	a0,a0,1978 # 80019368 <ftable>
    80003bb6:	00002097          	auipc	ra,0x2
    80003bba:	75c080e7          	jalr	1884(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003bbe:	40dc                	lw	a5,4(s1)
    80003bc0:	06f05163          	blez	a5,80003c22 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc4:	37fd                	addiw	a5,a5,-1
    80003bc6:	0007871b          	sext.w	a4,a5
    80003bca:	c0dc                	sw	a5,4(s1)
    80003bcc:	06e04363          	bgtz	a4,80003c32 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bd0:	0004a903          	lw	s2,0(s1)
    80003bd4:	0094ca83          	lbu	s5,9(s1)
    80003bd8:	0104ba03          	ld	s4,16(s1)
    80003bdc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003be0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003be4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003be8:	00015517          	auipc	a0,0x15
    80003bec:	78050513          	addi	a0,a0,1920 # 80019368 <ftable>
    80003bf0:	00002097          	auipc	ra,0x2
    80003bf4:	7d6080e7          	jalr	2006(ra) # 800063c6 <release>

  if(ff.type == FD_PIPE){
    80003bf8:	4785                	li	a5,1
    80003bfa:	04f90d63          	beq	s2,a5,80003c54 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bfe:	3979                	addiw	s2,s2,-2
    80003c00:	4785                	li	a5,1
    80003c02:	0527e063          	bltu	a5,s2,80003c42 <fileclose+0xa8>
    begin_op();
    80003c06:	00000097          	auipc	ra,0x0
    80003c0a:	ac8080e7          	jalr	-1336(ra) # 800036ce <begin_op>
    iput(ff.ip);
    80003c0e:	854e                	mv	a0,s3
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	2a6080e7          	jalr	678(ra) # 80002eb6 <iput>
    end_op();
    80003c18:	00000097          	auipc	ra,0x0
    80003c1c:	b36080e7          	jalr	-1226(ra) # 8000374e <end_op>
    80003c20:	a00d                	j	80003c42 <fileclose+0xa8>
    panic("fileclose");
    80003c22:	00005517          	auipc	a0,0x5
    80003c26:	ac650513          	addi	a0,a0,-1338 # 800086e8 <syscalls+0x290>
    80003c2a:	00002097          	auipc	ra,0x2
    80003c2e:	19e080e7          	jalr	414(ra) # 80005dc8 <panic>
    release(&ftable.lock);
    80003c32:	00015517          	auipc	a0,0x15
    80003c36:	73650513          	addi	a0,a0,1846 # 80019368 <ftable>
    80003c3a:	00002097          	auipc	ra,0x2
    80003c3e:	78c080e7          	jalr	1932(ra) # 800063c6 <release>
  }
}
    80003c42:	70e2                	ld	ra,56(sp)
    80003c44:	7442                	ld	s0,48(sp)
    80003c46:	74a2                	ld	s1,40(sp)
    80003c48:	7902                	ld	s2,32(sp)
    80003c4a:	69e2                	ld	s3,24(sp)
    80003c4c:	6a42                	ld	s4,16(sp)
    80003c4e:	6aa2                	ld	s5,8(sp)
    80003c50:	6121                	addi	sp,sp,64
    80003c52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c54:	85d6                	mv	a1,s5
    80003c56:	8552                	mv	a0,s4
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	34c080e7          	jalr	844(ra) # 80003fa4 <pipeclose>
    80003c60:	b7cd                	j	80003c42 <fileclose+0xa8>

0000000080003c62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c62:	715d                	addi	sp,sp,-80
    80003c64:	e486                	sd	ra,72(sp)
    80003c66:	e0a2                	sd	s0,64(sp)
    80003c68:	fc26                	sd	s1,56(sp)
    80003c6a:	f84a                	sd	s2,48(sp)
    80003c6c:	f44e                	sd	s3,40(sp)
    80003c6e:	0880                	addi	s0,sp,80
    80003c70:	84aa                	mv	s1,a0
    80003c72:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	2f2080e7          	jalr	754(ra) # 80000f66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c7c:	409c                	lw	a5,0(s1)
    80003c7e:	37f9                	addiw	a5,a5,-2
    80003c80:	4705                	li	a4,1
    80003c82:	04f76763          	bltu	a4,a5,80003cd0 <filestat+0x6e>
    80003c86:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c88:	6c88                	ld	a0,24(s1)
    80003c8a:	fffff097          	auipc	ra,0xfffff
    80003c8e:	072080e7          	jalr	114(ra) # 80002cfc <ilock>
    stati(f->ip, &st);
    80003c92:	fb840593          	addi	a1,s0,-72
    80003c96:	6c88                	ld	a0,24(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	2ee080e7          	jalr	750(ra) # 80002f86 <stati>
    iunlock(f->ip);
    80003ca0:	6c88                	ld	a0,24(s1)
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	11c080e7          	jalr	284(ra) # 80002dbe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003caa:	46e1                	li	a3,24
    80003cac:	fb840613          	addi	a2,s0,-72
    80003cb0:	85ce                	mv	a1,s3
    80003cb2:	05093503          	ld	a0,80(s2)
    80003cb6:	ffffd097          	auipc	ra,0xffffd
    80003cba:	f34080e7          	jalr	-204(ra) # 80000bea <copyout>
    80003cbe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cc2:	60a6                	ld	ra,72(sp)
    80003cc4:	6406                	ld	s0,64(sp)
    80003cc6:	74e2                	ld	s1,56(sp)
    80003cc8:	7942                	ld	s2,48(sp)
    80003cca:	79a2                	ld	s3,40(sp)
    80003ccc:	6161                	addi	sp,sp,80
    80003cce:	8082                	ret
  return -1;
    80003cd0:	557d                	li	a0,-1
    80003cd2:	bfc5                	j	80003cc2 <filestat+0x60>

0000000080003cd4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cd4:	7179                	addi	sp,sp,-48
    80003cd6:	f406                	sd	ra,40(sp)
    80003cd8:	f022                	sd	s0,32(sp)
    80003cda:	ec26                	sd	s1,24(sp)
    80003cdc:	e84a                	sd	s2,16(sp)
    80003cde:	e44e                	sd	s3,8(sp)
    80003ce0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ce2:	00854783          	lbu	a5,8(a0)
    80003ce6:	c3d5                	beqz	a5,80003d8a <fileread+0xb6>
    80003ce8:	84aa                	mv	s1,a0
    80003cea:	89ae                	mv	s3,a1
    80003cec:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cee:	411c                	lw	a5,0(a0)
    80003cf0:	4705                	li	a4,1
    80003cf2:	04e78963          	beq	a5,a4,80003d44 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cf6:	470d                	li	a4,3
    80003cf8:	04e78d63          	beq	a5,a4,80003d52 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cfc:	4709                	li	a4,2
    80003cfe:	06e79e63          	bne	a5,a4,80003d7a <fileread+0xa6>
    ilock(f->ip);
    80003d02:	6d08                	ld	a0,24(a0)
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	ff8080e7          	jalr	-8(ra) # 80002cfc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d0c:	874a                	mv	a4,s2
    80003d0e:	5094                	lw	a3,32(s1)
    80003d10:	864e                	mv	a2,s3
    80003d12:	4585                	li	a1,1
    80003d14:	6c88                	ld	a0,24(s1)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	29a080e7          	jalr	666(ra) # 80002fb0 <readi>
    80003d1e:	892a                	mv	s2,a0
    80003d20:	00a05563          	blez	a0,80003d2a <fileread+0x56>
      f->off += r;
    80003d24:	509c                	lw	a5,32(s1)
    80003d26:	9fa9                	addw	a5,a5,a0
    80003d28:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d2a:	6c88                	ld	a0,24(s1)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	092080e7          	jalr	146(ra) # 80002dbe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d34:	854a                	mv	a0,s2
    80003d36:	70a2                	ld	ra,40(sp)
    80003d38:	7402                	ld	s0,32(sp)
    80003d3a:	64e2                	ld	s1,24(sp)
    80003d3c:	6942                	ld	s2,16(sp)
    80003d3e:	69a2                	ld	s3,8(sp)
    80003d40:	6145                	addi	sp,sp,48
    80003d42:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d44:	6908                	ld	a0,16(a0)
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	3c8080e7          	jalr	968(ra) # 8000410e <piperead>
    80003d4e:	892a                	mv	s2,a0
    80003d50:	b7d5                	j	80003d34 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d52:	02451783          	lh	a5,36(a0)
    80003d56:	03079693          	slli	a3,a5,0x30
    80003d5a:	92c1                	srli	a3,a3,0x30
    80003d5c:	4725                	li	a4,9
    80003d5e:	02d76863          	bltu	a4,a3,80003d8e <fileread+0xba>
    80003d62:	0792                	slli	a5,a5,0x4
    80003d64:	00015717          	auipc	a4,0x15
    80003d68:	56470713          	addi	a4,a4,1380 # 800192c8 <devsw>
    80003d6c:	97ba                	add	a5,a5,a4
    80003d6e:	639c                	ld	a5,0(a5)
    80003d70:	c38d                	beqz	a5,80003d92 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d72:	4505                	li	a0,1
    80003d74:	9782                	jalr	a5
    80003d76:	892a                	mv	s2,a0
    80003d78:	bf75                	j	80003d34 <fileread+0x60>
    panic("fileread");
    80003d7a:	00005517          	auipc	a0,0x5
    80003d7e:	97e50513          	addi	a0,a0,-1666 # 800086f8 <syscalls+0x2a0>
    80003d82:	00002097          	auipc	ra,0x2
    80003d86:	046080e7          	jalr	70(ra) # 80005dc8 <panic>
    return -1;
    80003d8a:	597d                	li	s2,-1
    80003d8c:	b765                	j	80003d34 <fileread+0x60>
      return -1;
    80003d8e:	597d                	li	s2,-1
    80003d90:	b755                	j	80003d34 <fileread+0x60>
    80003d92:	597d                	li	s2,-1
    80003d94:	b745                	j	80003d34 <fileread+0x60>

0000000080003d96 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d96:	715d                	addi	sp,sp,-80
    80003d98:	e486                	sd	ra,72(sp)
    80003d9a:	e0a2                	sd	s0,64(sp)
    80003d9c:	fc26                	sd	s1,56(sp)
    80003d9e:	f84a                	sd	s2,48(sp)
    80003da0:	f44e                	sd	s3,40(sp)
    80003da2:	f052                	sd	s4,32(sp)
    80003da4:	ec56                	sd	s5,24(sp)
    80003da6:	e85a                	sd	s6,16(sp)
    80003da8:	e45e                	sd	s7,8(sp)
    80003daa:	e062                	sd	s8,0(sp)
    80003dac:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dae:	00954783          	lbu	a5,9(a0)
    80003db2:	10078663          	beqz	a5,80003ebe <filewrite+0x128>
    80003db6:	892a                	mv	s2,a0
    80003db8:	8aae                	mv	s5,a1
    80003dba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dbc:	411c                	lw	a5,0(a0)
    80003dbe:	4705                	li	a4,1
    80003dc0:	02e78263          	beq	a5,a4,80003de4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dc4:	470d                	li	a4,3
    80003dc6:	02e78663          	beq	a5,a4,80003df2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dca:	4709                	li	a4,2
    80003dcc:	0ee79163          	bne	a5,a4,80003eae <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dd0:	0ac05d63          	blez	a2,80003e8a <filewrite+0xf4>
    int i = 0;
    80003dd4:	4981                	li	s3,0
    80003dd6:	6b05                	lui	s6,0x1
    80003dd8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ddc:	6b85                	lui	s7,0x1
    80003dde:	c00b8b9b          	addiw	s7,s7,-1024
    80003de2:	a861                	j	80003e7a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003de4:	6908                	ld	a0,16(a0)
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	22e080e7          	jalr	558(ra) # 80004014 <pipewrite>
    80003dee:	8a2a                	mv	s4,a0
    80003df0:	a045                	j	80003e90 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003df2:	02451783          	lh	a5,36(a0)
    80003df6:	03079693          	slli	a3,a5,0x30
    80003dfa:	92c1                	srli	a3,a3,0x30
    80003dfc:	4725                	li	a4,9
    80003dfe:	0cd76263          	bltu	a4,a3,80003ec2 <filewrite+0x12c>
    80003e02:	0792                	slli	a5,a5,0x4
    80003e04:	00015717          	auipc	a4,0x15
    80003e08:	4c470713          	addi	a4,a4,1220 # 800192c8 <devsw>
    80003e0c:	97ba                	add	a5,a5,a4
    80003e0e:	679c                	ld	a5,8(a5)
    80003e10:	cbdd                	beqz	a5,80003ec6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e12:	4505                	li	a0,1
    80003e14:	9782                	jalr	a5
    80003e16:	8a2a                	mv	s4,a0
    80003e18:	a8a5                	j	80003e90 <filewrite+0xfa>
    80003e1a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e1e:	00000097          	auipc	ra,0x0
    80003e22:	8b0080e7          	jalr	-1872(ra) # 800036ce <begin_op>
      ilock(f->ip);
    80003e26:	01893503          	ld	a0,24(s2)
    80003e2a:	fffff097          	auipc	ra,0xfffff
    80003e2e:	ed2080e7          	jalr	-302(ra) # 80002cfc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e32:	8762                	mv	a4,s8
    80003e34:	02092683          	lw	a3,32(s2)
    80003e38:	01598633          	add	a2,s3,s5
    80003e3c:	4585                	li	a1,1
    80003e3e:	01893503          	ld	a0,24(s2)
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	266080e7          	jalr	614(ra) # 800030a8 <writei>
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	00a05763          	blez	a0,80003e5a <filewrite+0xc4>
        f->off += r;
    80003e50:	02092783          	lw	a5,32(s2)
    80003e54:	9fa9                	addw	a5,a5,a0
    80003e56:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e5a:	01893503          	ld	a0,24(s2)
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	f60080e7          	jalr	-160(ra) # 80002dbe <iunlock>
      end_op();
    80003e66:	00000097          	auipc	ra,0x0
    80003e6a:	8e8080e7          	jalr	-1816(ra) # 8000374e <end_op>

      if(r != n1){
    80003e6e:	009c1f63          	bne	s8,s1,80003e8c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e72:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e76:	0149db63          	bge	s3,s4,80003e8c <filewrite+0xf6>
      int n1 = n - i;
    80003e7a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e7e:	84be                	mv	s1,a5
    80003e80:	2781                	sext.w	a5,a5
    80003e82:	f8fb5ce3          	bge	s6,a5,80003e1a <filewrite+0x84>
    80003e86:	84de                	mv	s1,s7
    80003e88:	bf49                	j	80003e1a <filewrite+0x84>
    int i = 0;
    80003e8a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e8c:	013a1f63          	bne	s4,s3,80003eaa <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e90:	8552                	mv	a0,s4
    80003e92:	60a6                	ld	ra,72(sp)
    80003e94:	6406                	ld	s0,64(sp)
    80003e96:	74e2                	ld	s1,56(sp)
    80003e98:	7942                	ld	s2,48(sp)
    80003e9a:	79a2                	ld	s3,40(sp)
    80003e9c:	7a02                	ld	s4,32(sp)
    80003e9e:	6ae2                	ld	s5,24(sp)
    80003ea0:	6b42                	ld	s6,16(sp)
    80003ea2:	6ba2                	ld	s7,8(sp)
    80003ea4:	6c02                	ld	s8,0(sp)
    80003ea6:	6161                	addi	sp,sp,80
    80003ea8:	8082                	ret
    ret = (i == n ? n : -1);
    80003eaa:	5a7d                	li	s4,-1
    80003eac:	b7d5                	j	80003e90 <filewrite+0xfa>
    panic("filewrite");
    80003eae:	00005517          	auipc	a0,0x5
    80003eb2:	85a50513          	addi	a0,a0,-1958 # 80008708 <syscalls+0x2b0>
    80003eb6:	00002097          	auipc	ra,0x2
    80003eba:	f12080e7          	jalr	-238(ra) # 80005dc8 <panic>
    return -1;
    80003ebe:	5a7d                	li	s4,-1
    80003ec0:	bfc1                	j	80003e90 <filewrite+0xfa>
      return -1;
    80003ec2:	5a7d                	li	s4,-1
    80003ec4:	b7f1                	j	80003e90 <filewrite+0xfa>
    80003ec6:	5a7d                	li	s4,-1
    80003ec8:	b7e1                	j	80003e90 <filewrite+0xfa>

0000000080003eca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003eca:	7179                	addi	sp,sp,-48
    80003ecc:	f406                	sd	ra,40(sp)
    80003ece:	f022                	sd	s0,32(sp)
    80003ed0:	ec26                	sd	s1,24(sp)
    80003ed2:	e84a                	sd	s2,16(sp)
    80003ed4:	e44e                	sd	s3,8(sp)
    80003ed6:	e052                	sd	s4,0(sp)
    80003ed8:	1800                	addi	s0,sp,48
    80003eda:	84aa                	mv	s1,a0
    80003edc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ede:	0005b023          	sd	zero,0(a1)
    80003ee2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	bf8080e7          	jalr	-1032(ra) # 80003ade <filealloc>
    80003eee:	e088                	sd	a0,0(s1)
    80003ef0:	c551                	beqz	a0,80003f7c <pipealloc+0xb2>
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	bec080e7          	jalr	-1044(ra) # 80003ade <filealloc>
    80003efa:	00aa3023          	sd	a0,0(s4)
    80003efe:	c92d                	beqz	a0,80003f70 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f00:	ffffc097          	auipc	ra,0xffffc
    80003f04:	218080e7          	jalr	536(ra) # 80000118 <kalloc>
    80003f08:	892a                	mv	s2,a0
    80003f0a:	c125                	beqz	a0,80003f6a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f0c:	4985                	li	s3,1
    80003f0e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f12:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f16:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f1a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f1e:	00004597          	auipc	a1,0x4
    80003f22:	7fa58593          	addi	a1,a1,2042 # 80008718 <syscalls+0x2c0>
    80003f26:	00002097          	auipc	ra,0x2
    80003f2a:	35c080e7          	jalr	860(ra) # 80006282 <initlock>
  (*f0)->type = FD_PIPE;
    80003f2e:	609c                	ld	a5,0(s1)
    80003f30:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f34:	609c                	ld	a5,0(s1)
    80003f36:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f3a:	609c                	ld	a5,0(s1)
    80003f3c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f40:	609c                	ld	a5,0(s1)
    80003f42:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f46:	000a3783          	ld	a5,0(s4)
    80003f4a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f4e:	000a3783          	ld	a5,0(s4)
    80003f52:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f56:	000a3783          	ld	a5,0(s4)
    80003f5a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f5e:	000a3783          	ld	a5,0(s4)
    80003f62:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f66:	4501                	li	a0,0
    80003f68:	a025                	j	80003f90 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f6a:	6088                	ld	a0,0(s1)
    80003f6c:	e501                	bnez	a0,80003f74 <pipealloc+0xaa>
    80003f6e:	a039                	j	80003f7c <pipealloc+0xb2>
    80003f70:	6088                	ld	a0,0(s1)
    80003f72:	c51d                	beqz	a0,80003fa0 <pipealloc+0xd6>
    fileclose(*f0);
    80003f74:	00000097          	auipc	ra,0x0
    80003f78:	c26080e7          	jalr	-986(ra) # 80003b9a <fileclose>
  if(*f1)
    80003f7c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f80:	557d                	li	a0,-1
  if(*f1)
    80003f82:	c799                	beqz	a5,80003f90 <pipealloc+0xc6>
    fileclose(*f1);
    80003f84:	853e                	mv	a0,a5
    80003f86:	00000097          	auipc	ra,0x0
    80003f8a:	c14080e7          	jalr	-1004(ra) # 80003b9a <fileclose>
  return -1;
    80003f8e:	557d                	li	a0,-1
}
    80003f90:	70a2                	ld	ra,40(sp)
    80003f92:	7402                	ld	s0,32(sp)
    80003f94:	64e2                	ld	s1,24(sp)
    80003f96:	6942                	ld	s2,16(sp)
    80003f98:	69a2                	ld	s3,8(sp)
    80003f9a:	6a02                	ld	s4,0(sp)
    80003f9c:	6145                	addi	sp,sp,48
    80003f9e:	8082                	ret
  return -1;
    80003fa0:	557d                	li	a0,-1
    80003fa2:	b7fd                	j	80003f90 <pipealloc+0xc6>

0000000080003fa4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fa4:	1101                	addi	sp,sp,-32
    80003fa6:	ec06                	sd	ra,24(sp)
    80003fa8:	e822                	sd	s0,16(sp)
    80003faa:	e426                	sd	s1,8(sp)
    80003fac:	e04a                	sd	s2,0(sp)
    80003fae:	1000                	addi	s0,sp,32
    80003fb0:	84aa                	mv	s1,a0
    80003fb2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fb4:	00002097          	auipc	ra,0x2
    80003fb8:	35e080e7          	jalr	862(ra) # 80006312 <acquire>
  if(writable){
    80003fbc:	02090d63          	beqz	s2,80003ff6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fc0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fc4:	21848513          	addi	a0,s1,536
    80003fc8:	ffffe097          	auipc	ra,0xffffe
    80003fcc:	894080e7          	jalr	-1900(ra) # 8000185c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fd0:	2204b783          	ld	a5,544(s1)
    80003fd4:	eb95                	bnez	a5,80004008 <pipeclose+0x64>
    release(&pi->lock);
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	00002097          	auipc	ra,0x2
    80003fdc:	3ee080e7          	jalr	1006(ra) # 800063c6 <release>
    kfree((char*)pi);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	ffffc097          	auipc	ra,0xffffc
    80003fe6:	03a080e7          	jalr	58(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fea:	60e2                	ld	ra,24(sp)
    80003fec:	6442                	ld	s0,16(sp)
    80003fee:	64a2                	ld	s1,8(sp)
    80003ff0:	6902                	ld	s2,0(sp)
    80003ff2:	6105                	addi	sp,sp,32
    80003ff4:	8082                	ret
    pi->readopen = 0;
    80003ff6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ffa:	21c48513          	addi	a0,s1,540
    80003ffe:	ffffe097          	auipc	ra,0xffffe
    80004002:	85e080e7          	jalr	-1954(ra) # 8000185c <wakeup>
    80004006:	b7e9                	j	80003fd0 <pipeclose+0x2c>
    release(&pi->lock);
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	3bc080e7          	jalr	956(ra) # 800063c6 <release>
}
    80004012:	bfe1                	j	80003fea <pipeclose+0x46>

0000000080004014 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004014:	7159                	addi	sp,sp,-112
    80004016:	f486                	sd	ra,104(sp)
    80004018:	f0a2                	sd	s0,96(sp)
    8000401a:	eca6                	sd	s1,88(sp)
    8000401c:	e8ca                	sd	s2,80(sp)
    8000401e:	e4ce                	sd	s3,72(sp)
    80004020:	e0d2                	sd	s4,64(sp)
    80004022:	fc56                	sd	s5,56(sp)
    80004024:	f85a                	sd	s6,48(sp)
    80004026:	f45e                	sd	s7,40(sp)
    80004028:	f062                	sd	s8,32(sp)
    8000402a:	ec66                	sd	s9,24(sp)
    8000402c:	1880                	addi	s0,sp,112
    8000402e:	84aa                	mv	s1,a0
    80004030:	8aae                	mv	s5,a1
    80004032:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	f32080e7          	jalr	-206(ra) # 80000f66 <myproc>
    8000403c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	2d2080e7          	jalr	722(ra) # 80006312 <acquire>
  while(i < n){
    80004048:	0d405163          	blez	s4,8000410a <pipewrite+0xf6>
    8000404c:	8ba6                	mv	s7,s1
  int i = 0;
    8000404e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004050:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004052:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004056:	21c48c13          	addi	s8,s1,540
    8000405a:	a08d                	j	800040bc <pipewrite+0xa8>
      release(&pi->lock);
    8000405c:	8526                	mv	a0,s1
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	368080e7          	jalr	872(ra) # 800063c6 <release>
      return -1;
    80004066:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004068:	854a                	mv	a0,s2
    8000406a:	70a6                	ld	ra,104(sp)
    8000406c:	7406                	ld	s0,96(sp)
    8000406e:	64e6                	ld	s1,88(sp)
    80004070:	6946                	ld	s2,80(sp)
    80004072:	69a6                	ld	s3,72(sp)
    80004074:	6a06                	ld	s4,64(sp)
    80004076:	7ae2                	ld	s5,56(sp)
    80004078:	7b42                	ld	s6,48(sp)
    8000407a:	7ba2                	ld	s7,40(sp)
    8000407c:	7c02                	ld	s8,32(sp)
    8000407e:	6ce2                	ld	s9,24(sp)
    80004080:	6165                	addi	sp,sp,112
    80004082:	8082                	ret
      wakeup(&pi->nread);
    80004084:	8566                	mv	a0,s9
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	7d6080e7          	jalr	2006(ra) # 8000185c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000408e:	85de                	mv	a1,s7
    80004090:	8562                	mv	a0,s8
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	63e080e7          	jalr	1598(ra) # 800016d0 <sleep>
    8000409a:	a839                	j	800040b8 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000409c:	21c4a783          	lw	a5,540(s1)
    800040a0:	0017871b          	addiw	a4,a5,1
    800040a4:	20e4ae23          	sw	a4,540(s1)
    800040a8:	1ff7f793          	andi	a5,a5,511
    800040ac:	97a6                	add	a5,a5,s1
    800040ae:	f9f44703          	lbu	a4,-97(s0)
    800040b2:	00e78c23          	sb	a4,24(a5)
      i++;
    800040b6:	2905                	addiw	s2,s2,1
  while(i < n){
    800040b8:	03495d63          	bge	s2,s4,800040f2 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040bc:	2204a783          	lw	a5,544(s1)
    800040c0:	dfd1                	beqz	a5,8000405c <pipewrite+0x48>
    800040c2:	0289a783          	lw	a5,40(s3)
    800040c6:	fbd9                	bnez	a5,8000405c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040c8:	2184a783          	lw	a5,536(s1)
    800040cc:	21c4a703          	lw	a4,540(s1)
    800040d0:	2007879b          	addiw	a5,a5,512
    800040d4:	faf708e3          	beq	a4,a5,80004084 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040d8:	4685                	li	a3,1
    800040da:	01590633          	add	a2,s2,s5
    800040de:	f9f40593          	addi	a1,s0,-97
    800040e2:	0509b503          	ld	a0,80(s3)
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	b90080e7          	jalr	-1136(ra) # 80000c76 <copyin>
    800040ee:	fb6517e3          	bne	a0,s6,8000409c <pipewrite+0x88>
  wakeup(&pi->nread);
    800040f2:	21848513          	addi	a0,s1,536
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	766080e7          	jalr	1894(ra) # 8000185c <wakeup>
  release(&pi->lock);
    800040fe:	8526                	mv	a0,s1
    80004100:	00002097          	auipc	ra,0x2
    80004104:	2c6080e7          	jalr	710(ra) # 800063c6 <release>
  return i;
    80004108:	b785                	j	80004068 <pipewrite+0x54>
  int i = 0;
    8000410a:	4901                	li	s2,0
    8000410c:	b7dd                	j	800040f2 <pipewrite+0xde>

000000008000410e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000410e:	715d                	addi	sp,sp,-80
    80004110:	e486                	sd	ra,72(sp)
    80004112:	e0a2                	sd	s0,64(sp)
    80004114:	fc26                	sd	s1,56(sp)
    80004116:	f84a                	sd	s2,48(sp)
    80004118:	f44e                	sd	s3,40(sp)
    8000411a:	f052                	sd	s4,32(sp)
    8000411c:	ec56                	sd	s5,24(sp)
    8000411e:	e85a                	sd	s6,16(sp)
    80004120:	0880                	addi	s0,sp,80
    80004122:	84aa                	mv	s1,a0
    80004124:	892e                	mv	s2,a1
    80004126:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	e3e080e7          	jalr	-450(ra) # 80000f66 <myproc>
    80004130:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004132:	8b26                	mv	s6,s1
    80004134:	8526                	mv	a0,s1
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	1dc080e7          	jalr	476(ra) # 80006312 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000413e:	2184a703          	lw	a4,536(s1)
    80004142:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004146:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414a:	02f71463          	bne	a4,a5,80004172 <piperead+0x64>
    8000414e:	2244a783          	lw	a5,548(s1)
    80004152:	c385                	beqz	a5,80004172 <piperead+0x64>
    if(pr->killed){
    80004154:	028a2783          	lw	a5,40(s4)
    80004158:	ebc1                	bnez	a5,800041e8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000415a:	85da                	mv	a1,s6
    8000415c:	854e                	mv	a0,s3
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	572080e7          	jalr	1394(ra) # 800016d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004166:	2184a703          	lw	a4,536(s1)
    8000416a:	21c4a783          	lw	a5,540(s1)
    8000416e:	fef700e3          	beq	a4,a5,8000414e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004172:	09505263          	blez	s5,800041f6 <piperead+0xe8>
    80004176:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004178:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000417a:	2184a783          	lw	a5,536(s1)
    8000417e:	21c4a703          	lw	a4,540(s1)
    80004182:	02f70d63          	beq	a4,a5,800041bc <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004186:	0017871b          	addiw	a4,a5,1
    8000418a:	20e4ac23          	sw	a4,536(s1)
    8000418e:	1ff7f793          	andi	a5,a5,511
    80004192:	97a6                	add	a5,a5,s1
    80004194:	0187c783          	lbu	a5,24(a5)
    80004198:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000419c:	4685                	li	a3,1
    8000419e:	fbf40613          	addi	a2,s0,-65
    800041a2:	85ca                	mv	a1,s2
    800041a4:	050a3503          	ld	a0,80(s4)
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	a42080e7          	jalr	-1470(ra) # 80000bea <copyout>
    800041b0:	01650663          	beq	a0,s6,800041bc <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041b4:	2985                	addiw	s3,s3,1
    800041b6:	0905                	addi	s2,s2,1
    800041b8:	fd3a91e3          	bne	s5,s3,8000417a <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041bc:	21c48513          	addi	a0,s1,540
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	69c080e7          	jalr	1692(ra) # 8000185c <wakeup>
  release(&pi->lock);
    800041c8:	8526                	mv	a0,s1
    800041ca:	00002097          	auipc	ra,0x2
    800041ce:	1fc080e7          	jalr	508(ra) # 800063c6 <release>
  return i;
}
    800041d2:	854e                	mv	a0,s3
    800041d4:	60a6                	ld	ra,72(sp)
    800041d6:	6406                	ld	s0,64(sp)
    800041d8:	74e2                	ld	s1,56(sp)
    800041da:	7942                	ld	s2,48(sp)
    800041dc:	79a2                	ld	s3,40(sp)
    800041de:	7a02                	ld	s4,32(sp)
    800041e0:	6ae2                	ld	s5,24(sp)
    800041e2:	6b42                	ld	s6,16(sp)
    800041e4:	6161                	addi	sp,sp,80
    800041e6:	8082                	ret
      release(&pi->lock);
    800041e8:	8526                	mv	a0,s1
    800041ea:	00002097          	auipc	ra,0x2
    800041ee:	1dc080e7          	jalr	476(ra) # 800063c6 <release>
      return -1;
    800041f2:	59fd                	li	s3,-1
    800041f4:	bff9                	j	800041d2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f6:	4981                	li	s3,0
    800041f8:	b7d1                	j	800041bc <piperead+0xae>

00000000800041fa <exec>:
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
void vmprint(pagetable_t pagetable);

int
exec(char *path, char **argv)
{
    800041fa:	df010113          	addi	sp,sp,-528
    800041fe:	20113423          	sd	ra,520(sp)
    80004202:	20813023          	sd	s0,512(sp)
    80004206:	ffa6                	sd	s1,504(sp)
    80004208:	fbca                	sd	s2,496(sp)
    8000420a:	f7ce                	sd	s3,488(sp)
    8000420c:	f3d2                	sd	s4,480(sp)
    8000420e:	efd6                	sd	s5,472(sp)
    80004210:	ebda                	sd	s6,464(sp)
    80004212:	e7de                	sd	s7,456(sp)
    80004214:	e3e2                	sd	s8,448(sp)
    80004216:	ff66                	sd	s9,440(sp)
    80004218:	fb6a                	sd	s10,432(sp)
    8000421a:	f76e                	sd	s11,424(sp)
    8000421c:	0c00                	addi	s0,sp,528
    8000421e:	84aa                	mv	s1,a0
    80004220:	dea43c23          	sd	a0,-520(s0)
    80004224:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	d3e080e7          	jalr	-706(ra) # 80000f66 <myproc>
    80004230:	892a                	mv	s2,a0

  begin_op();
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	49c080e7          	jalr	1180(ra) # 800036ce <begin_op>

  if((ip = namei(path)) == 0){
    8000423a:	8526                	mv	a0,s1
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	276080e7          	jalr	630(ra) # 800034b2 <namei>
    80004244:	c92d                	beqz	a0,800042b6 <exec+0xbc>
    80004246:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	ab4080e7          	jalr	-1356(ra) # 80002cfc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004250:	04000713          	li	a4,64
    80004254:	4681                	li	a3,0
    80004256:	e5040613          	addi	a2,s0,-432
    8000425a:	4581                	li	a1,0
    8000425c:	8526                	mv	a0,s1
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	d52080e7          	jalr	-686(ra) # 80002fb0 <readi>
    80004266:	04000793          	li	a5,64
    8000426a:	00f51a63          	bne	a0,a5,8000427e <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000426e:	e5042703          	lw	a4,-432(s0)
    80004272:	464c47b7          	lui	a5,0x464c4
    80004276:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000427a:	04f70463          	beq	a4,a5,800042c2 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000427e:	8526                	mv	a0,s1
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	cde080e7          	jalr	-802(ra) # 80002f5e <iunlockput>
    end_op();
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	4c6080e7          	jalr	1222(ra) # 8000374e <end_op>
  }
  return -1;
    80004290:	557d                	li	a0,-1
}
    80004292:	20813083          	ld	ra,520(sp)
    80004296:	20013403          	ld	s0,512(sp)
    8000429a:	74fe                	ld	s1,504(sp)
    8000429c:	795e                	ld	s2,496(sp)
    8000429e:	79be                	ld	s3,488(sp)
    800042a0:	7a1e                	ld	s4,480(sp)
    800042a2:	6afe                	ld	s5,472(sp)
    800042a4:	6b5e                	ld	s6,464(sp)
    800042a6:	6bbe                	ld	s7,456(sp)
    800042a8:	6c1e                	ld	s8,448(sp)
    800042aa:	7cfa                	ld	s9,440(sp)
    800042ac:	7d5a                	ld	s10,432(sp)
    800042ae:	7dba                	ld	s11,424(sp)
    800042b0:	21010113          	addi	sp,sp,528
    800042b4:	8082                	ret
    end_op();
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	498080e7          	jalr	1176(ra) # 8000374e <end_op>
    return -1;
    800042be:	557d                	li	a0,-1
    800042c0:	bfc9                	j	80004292 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042c2:	854a                	mv	a0,s2
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	d66080e7          	jalr	-666(ra) # 8000102a <proc_pagetable>
    800042cc:	8baa                	mv	s7,a0
    800042ce:	d945                	beqz	a0,8000427e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d0:	e7042983          	lw	s3,-400(s0)
    800042d4:	e8845783          	lhu	a5,-376(s0)
    800042d8:	c7ad                	beqz	a5,80004342 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042da:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042dc:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042de:	6c85                	lui	s9,0x1
    800042e0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042e4:	def43823          	sd	a5,-528(s0)
    800042e8:	a489                	j	8000452a <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042ea:	00004517          	auipc	a0,0x4
    800042ee:	43650513          	addi	a0,a0,1078 # 80008720 <syscalls+0x2c8>
    800042f2:	00002097          	auipc	ra,0x2
    800042f6:	ad6080e7          	jalr	-1322(ra) # 80005dc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042fa:	8756                	mv	a4,s5
    800042fc:	012d86bb          	addw	a3,s11,s2
    80004300:	4581                	li	a1,0
    80004302:	8526                	mv	a0,s1
    80004304:	fffff097          	auipc	ra,0xfffff
    80004308:	cac080e7          	jalr	-852(ra) # 80002fb0 <readi>
    8000430c:	2501                	sext.w	a0,a0
    8000430e:	1caa9563          	bne	s5,a0,800044d8 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    80004312:	6785                	lui	a5,0x1
    80004314:	0127893b          	addw	s2,a5,s2
    80004318:	77fd                	lui	a5,0xfffff
    8000431a:	01478a3b          	addw	s4,a5,s4
    8000431e:	1f897d63          	bgeu	s2,s8,80004518 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004322:	02091593          	slli	a1,s2,0x20
    80004326:	9181                	srli	a1,a1,0x20
    80004328:	95ea                	add	a1,a1,s10
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	1da080e7          	jalr	474(ra) # 80000506 <walkaddr>
    80004334:	862a                	mv	a2,a0
    if(pa == 0)
    80004336:	d955                	beqz	a0,800042ea <exec+0xf0>
      n = PGSIZE;
    80004338:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000433a:	fd9a70e3          	bgeu	s4,s9,800042fa <exec+0x100>
      n = sz - i;
    8000433e:	8ad2                	mv	s5,s4
    80004340:	bf6d                	j	800042fa <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004342:	4901                	li	s2,0
  iunlockput(ip);
    80004344:	8526                	mv	a0,s1
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	c18080e7          	jalr	-1000(ra) # 80002f5e <iunlockput>
  end_op();
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	400080e7          	jalr	1024(ra) # 8000374e <end_op>
  p = myproc();
    80004356:	ffffd097          	auipc	ra,0xffffd
    8000435a:	c10080e7          	jalr	-1008(ra) # 80000f66 <myproc>
    8000435e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004360:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004364:	6785                	lui	a5,0x1
    80004366:	17fd                	addi	a5,a5,-1
    80004368:	993e                	add	s2,s2,a5
    8000436a:	757d                	lui	a0,0xfffff
    8000436c:	00a977b3          	and	a5,s2,a0
    80004370:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004374:	6609                	lui	a2,0x2
    80004376:	963e                	add	a2,a2,a5
    80004378:	85be                	mv	a1,a5
    8000437a:	855e                	mv	a0,s7
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	53e080e7          	jalr	1342(ra) # 800008ba <uvmalloc>
    80004384:	8b2a                	mv	s6,a0
  ip = 0;
    80004386:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004388:	14050863          	beqz	a0,800044d8 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000438c:	75f9                	lui	a1,0xffffe
    8000438e:	95aa                	add	a1,a1,a0
    80004390:	855e                	mv	a0,s7
    80004392:	ffffd097          	auipc	ra,0xffffd
    80004396:	826080e7          	jalr	-2010(ra) # 80000bb8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000439a:	7c7d                	lui	s8,0xfffff
    8000439c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000439e:	e0043783          	ld	a5,-512(s0)
    800043a2:	6388                	ld	a0,0(a5)
    800043a4:	c535                	beqz	a0,80004410 <exec+0x216>
    800043a6:	e9040993          	addi	s3,s0,-368
    800043aa:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043ae:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	f4c080e7          	jalr	-180(ra) # 800002fc <strlen>
    800043b8:	2505                	addiw	a0,a0,1
    800043ba:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043be:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043c2:	13896f63          	bltu	s2,s8,80004500 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043c6:	e0043d83          	ld	s11,-512(s0)
    800043ca:	000dba03          	ld	s4,0(s11)
    800043ce:	8552                	mv	a0,s4
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	f2c080e7          	jalr	-212(ra) # 800002fc <strlen>
    800043d8:	0015069b          	addiw	a3,a0,1
    800043dc:	8652                	mv	a2,s4
    800043de:	85ca                	mv	a1,s2
    800043e0:	855e                	mv	a0,s7
    800043e2:	ffffd097          	auipc	ra,0xffffd
    800043e6:	808080e7          	jalr	-2040(ra) # 80000bea <copyout>
    800043ea:	10054f63          	bltz	a0,80004508 <exec+0x30e>
    ustack[argc] = sp;
    800043ee:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043f2:	0485                	addi	s1,s1,1
    800043f4:	008d8793          	addi	a5,s11,8
    800043f8:	e0f43023          	sd	a5,-512(s0)
    800043fc:	008db503          	ld	a0,8(s11)
    80004400:	c911                	beqz	a0,80004414 <exec+0x21a>
    if(argc >= MAXARG)
    80004402:	09a1                	addi	s3,s3,8
    80004404:	fb3c96e3          	bne	s9,s3,800043b0 <exec+0x1b6>
  sz = sz1;
    80004408:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440c:	4481                	li	s1,0
    8000440e:	a0e9                	j	800044d8 <exec+0x2de>
  sp = sz;
    80004410:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004412:	4481                	li	s1,0
  ustack[argc] = 0;
    80004414:	00349793          	slli	a5,s1,0x3
    80004418:	f9040713          	addi	a4,s0,-112
    8000441c:	97ba                	add	a5,a5,a4
    8000441e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004422:	00148693          	addi	a3,s1,1
    80004426:	068e                	slli	a3,a3,0x3
    80004428:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000442c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004430:	01897663          	bgeu	s2,s8,8000443c <exec+0x242>
  sz = sz1;
    80004434:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004438:	4481                	li	s1,0
    8000443a:	a879                	j	800044d8 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000443c:	e9040613          	addi	a2,s0,-368
    80004440:	85ca                	mv	a1,s2
    80004442:	855e                	mv	a0,s7
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	7a6080e7          	jalr	1958(ra) # 80000bea <copyout>
    8000444c:	0c054263          	bltz	a0,80004510 <exec+0x316>
  p->trapframe->a1 = sp;
    80004450:	058ab783          	ld	a5,88(s5)
    80004454:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004458:	df843783          	ld	a5,-520(s0)
    8000445c:	0007c703          	lbu	a4,0(a5)
    80004460:	cf11                	beqz	a4,8000447c <exec+0x282>
    80004462:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004464:	02f00693          	li	a3,47
    80004468:	a039                	j	80004476 <exec+0x27c>
      last = s+1;
    8000446a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000446e:	0785                	addi	a5,a5,1
    80004470:	fff7c703          	lbu	a4,-1(a5)
    80004474:	c701                	beqz	a4,8000447c <exec+0x282>
    if(*s == '/')
    80004476:	fed71ce3          	bne	a4,a3,8000446e <exec+0x274>
    8000447a:	bfc5                	j	8000446a <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000447c:	4641                	li	a2,16
    8000447e:	df843583          	ld	a1,-520(s0)
    80004482:	160a8513          	addi	a0,s5,352
    80004486:	ffffc097          	auipc	ra,0xffffc
    8000448a:	e44080e7          	jalr	-444(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000448e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004492:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004496:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000449a:	058ab783          	ld	a5,88(s5)
    8000449e:	e6843703          	ld	a4,-408(s0)
    800044a2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a4:	058ab783          	ld	a5,88(s5)
    800044a8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ac:	85ea                	mv	a1,s10
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	c72080e7          	jalr	-910(ra) # 80001120 <proc_freepagetable>
  if(p->pid == 1) vmprint(p->pagetable);
    800044b6:	030aa703          	lw	a4,48(s5)
    800044ba:	4785                	li	a5,1
    800044bc:	00f70563          	beq	a4,a5,800044c6 <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044c0:	0004851b          	sext.w	a0,s1
    800044c4:	b3f9                	j	80004292 <exec+0x98>
  if(p->pid == 1) vmprint(p->pagetable);
    800044c6:	050ab503          	ld	a0,80(s5)
    800044ca:	ffffc097          	auipc	ra,0xffffc
    800044ce:	546080e7          	jalr	1350(ra) # 80000a10 <vmprint>
    800044d2:	b7fd                	j	800044c0 <exec+0x2c6>
    800044d4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044d8:	e0843583          	ld	a1,-504(s0)
    800044dc:	855e                	mv	a0,s7
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	c42080e7          	jalr	-958(ra) # 80001120 <proc_freepagetable>
  if(ip){
    800044e6:	d8049ce3          	bnez	s1,8000427e <exec+0x84>
  return -1;
    800044ea:	557d                	li	a0,-1
    800044ec:	b35d                	j	80004292 <exec+0x98>
    800044ee:	e1243423          	sd	s2,-504(s0)
    800044f2:	b7dd                	j	800044d8 <exec+0x2de>
    800044f4:	e1243423          	sd	s2,-504(s0)
    800044f8:	b7c5                	j	800044d8 <exec+0x2de>
    800044fa:	e1243423          	sd	s2,-504(s0)
    800044fe:	bfe9                	j	800044d8 <exec+0x2de>
  sz = sz1;
    80004500:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004504:	4481                	li	s1,0
    80004506:	bfc9                	j	800044d8 <exec+0x2de>
  sz = sz1;
    80004508:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000450c:	4481                	li	s1,0
    8000450e:	b7e9                	j	800044d8 <exec+0x2de>
  sz = sz1;
    80004510:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004514:	4481                	li	s1,0
    80004516:	b7c9                	j	800044d8 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004518:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000451c:	2b05                	addiw	s6,s6,1
    8000451e:	0389899b          	addiw	s3,s3,56
    80004522:	e8845783          	lhu	a5,-376(s0)
    80004526:	e0fb5fe3          	bge	s6,a5,80004344 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000452a:	2981                	sext.w	s3,s3
    8000452c:	03800713          	li	a4,56
    80004530:	86ce                	mv	a3,s3
    80004532:	e1840613          	addi	a2,s0,-488
    80004536:	4581                	li	a1,0
    80004538:	8526                	mv	a0,s1
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	a76080e7          	jalr	-1418(ra) # 80002fb0 <readi>
    80004542:	03800793          	li	a5,56
    80004546:	f8f517e3          	bne	a0,a5,800044d4 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    8000454a:	e1842783          	lw	a5,-488(s0)
    8000454e:	4705                	li	a4,1
    80004550:	fce796e3          	bne	a5,a4,8000451c <exec+0x322>
    if(ph.memsz < ph.filesz)
    80004554:	e4043603          	ld	a2,-448(s0)
    80004558:	e3843783          	ld	a5,-456(s0)
    8000455c:	f8f669e3          	bltu	a2,a5,800044ee <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004560:	e2843783          	ld	a5,-472(s0)
    80004564:	963e                	add	a2,a2,a5
    80004566:	f8f667e3          	bltu	a2,a5,800044f4 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000456a:	85ca                	mv	a1,s2
    8000456c:	855e                	mv	a0,s7
    8000456e:	ffffc097          	auipc	ra,0xffffc
    80004572:	34c080e7          	jalr	844(ra) # 800008ba <uvmalloc>
    80004576:	e0a43423          	sd	a0,-504(s0)
    8000457a:	d141                	beqz	a0,800044fa <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    8000457c:	e2843d03          	ld	s10,-472(s0)
    80004580:	df043783          	ld	a5,-528(s0)
    80004584:	00fd77b3          	and	a5,s10,a5
    80004588:	fba1                	bnez	a5,800044d8 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000458a:	e2042d83          	lw	s11,-480(s0)
    8000458e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004592:	f80c03e3          	beqz	s8,80004518 <exec+0x31e>
    80004596:	8a62                	mv	s4,s8
    80004598:	4901                	li	s2,0
    8000459a:	b361                	j	80004322 <exec+0x128>

000000008000459c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000459c:	7179                	addi	sp,sp,-48
    8000459e:	f406                	sd	ra,40(sp)
    800045a0:	f022                	sd	s0,32(sp)
    800045a2:	ec26                	sd	s1,24(sp)
    800045a4:	e84a                	sd	s2,16(sp)
    800045a6:	1800                	addi	s0,sp,48
    800045a8:	892e                	mv	s2,a1
    800045aa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045ac:	fdc40593          	addi	a1,s0,-36
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	b10080e7          	jalr	-1264(ra) # 800020c0 <argint>
    800045b8:	04054063          	bltz	a0,800045f8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045bc:	fdc42703          	lw	a4,-36(s0)
    800045c0:	47bd                	li	a5,15
    800045c2:	02e7ed63          	bltu	a5,a4,800045fc <argfd+0x60>
    800045c6:	ffffd097          	auipc	ra,0xffffd
    800045ca:	9a0080e7          	jalr	-1632(ra) # 80000f66 <myproc>
    800045ce:	fdc42703          	lw	a4,-36(s0)
    800045d2:	01a70793          	addi	a5,a4,26
    800045d6:	078e                	slli	a5,a5,0x3
    800045d8:	953e                	add	a0,a0,a5
    800045da:	651c                	ld	a5,8(a0)
    800045dc:	c395                	beqz	a5,80004600 <argfd+0x64>
    return -1;
  if(pfd)
    800045de:	00090463          	beqz	s2,800045e6 <argfd+0x4a>
    *pfd = fd;
    800045e2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045e6:	4501                	li	a0,0
  if(pf)
    800045e8:	c091                	beqz	s1,800045ec <argfd+0x50>
    *pf = f;
    800045ea:	e09c                	sd	a5,0(s1)
}
    800045ec:	70a2                	ld	ra,40(sp)
    800045ee:	7402                	ld	s0,32(sp)
    800045f0:	64e2                	ld	s1,24(sp)
    800045f2:	6942                	ld	s2,16(sp)
    800045f4:	6145                	addi	sp,sp,48
    800045f6:	8082                	ret
    return -1;
    800045f8:	557d                	li	a0,-1
    800045fa:	bfcd                	j	800045ec <argfd+0x50>
    return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	b7fd                	j	800045ec <argfd+0x50>
    80004600:	557d                	li	a0,-1
    80004602:	b7ed                	j	800045ec <argfd+0x50>

0000000080004604 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004604:	1101                	addi	sp,sp,-32
    80004606:	ec06                	sd	ra,24(sp)
    80004608:	e822                	sd	s0,16(sp)
    8000460a:	e426                	sd	s1,8(sp)
    8000460c:	1000                	addi	s0,sp,32
    8000460e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004610:	ffffd097          	auipc	ra,0xffffd
    80004614:	956080e7          	jalr	-1706(ra) # 80000f66 <myproc>
    80004618:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000461a:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    8000461e:	4501                	li	a0,0
    80004620:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004622:	6398                	ld	a4,0(a5)
    80004624:	cb19                	beqz	a4,8000463a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004626:	2505                	addiw	a0,a0,1
    80004628:	07a1                	addi	a5,a5,8
    8000462a:	fed51ce3          	bne	a0,a3,80004622 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000462e:	557d                	li	a0,-1
}
    80004630:	60e2                	ld	ra,24(sp)
    80004632:	6442                	ld	s0,16(sp)
    80004634:	64a2                	ld	s1,8(sp)
    80004636:	6105                	addi	sp,sp,32
    80004638:	8082                	ret
      p->ofile[fd] = f;
    8000463a:	01a50793          	addi	a5,a0,26
    8000463e:	078e                	slli	a5,a5,0x3
    80004640:	963e                	add	a2,a2,a5
    80004642:	e604                	sd	s1,8(a2)
      return fd;
    80004644:	b7f5                	j	80004630 <fdalloc+0x2c>

0000000080004646 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004646:	715d                	addi	sp,sp,-80
    80004648:	e486                	sd	ra,72(sp)
    8000464a:	e0a2                	sd	s0,64(sp)
    8000464c:	fc26                	sd	s1,56(sp)
    8000464e:	f84a                	sd	s2,48(sp)
    80004650:	f44e                	sd	s3,40(sp)
    80004652:	f052                	sd	s4,32(sp)
    80004654:	ec56                	sd	s5,24(sp)
    80004656:	0880                	addi	s0,sp,80
    80004658:	89ae                	mv	s3,a1
    8000465a:	8ab2                	mv	s5,a2
    8000465c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000465e:	fb040593          	addi	a1,s0,-80
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	e6e080e7          	jalr	-402(ra) # 800034d0 <nameiparent>
    8000466a:	892a                	mv	s2,a0
    8000466c:	12050f63          	beqz	a0,800047aa <create+0x164>
    return 0;

  ilock(dp);
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	68c080e7          	jalr	1676(ra) # 80002cfc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004678:	4601                	li	a2,0
    8000467a:	fb040593          	addi	a1,s0,-80
    8000467e:	854a                	mv	a0,s2
    80004680:	fffff097          	auipc	ra,0xfffff
    80004684:	b60080e7          	jalr	-1184(ra) # 800031e0 <dirlookup>
    80004688:	84aa                	mv	s1,a0
    8000468a:	c921                	beqz	a0,800046da <create+0x94>
    iunlockput(dp);
    8000468c:	854a                	mv	a0,s2
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	8d0080e7          	jalr	-1840(ra) # 80002f5e <iunlockput>
    ilock(ip);
    80004696:	8526                	mv	a0,s1
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	664080e7          	jalr	1636(ra) # 80002cfc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046a0:	2981                	sext.w	s3,s3
    800046a2:	4789                	li	a5,2
    800046a4:	02f99463          	bne	s3,a5,800046cc <create+0x86>
    800046a8:	0444d783          	lhu	a5,68(s1)
    800046ac:	37f9                	addiw	a5,a5,-2
    800046ae:	17c2                	slli	a5,a5,0x30
    800046b0:	93c1                	srli	a5,a5,0x30
    800046b2:	4705                	li	a4,1
    800046b4:	00f76c63          	bltu	a4,a5,800046cc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046b8:	8526                	mv	a0,s1
    800046ba:	60a6                	ld	ra,72(sp)
    800046bc:	6406                	ld	s0,64(sp)
    800046be:	74e2                	ld	s1,56(sp)
    800046c0:	7942                	ld	s2,48(sp)
    800046c2:	79a2                	ld	s3,40(sp)
    800046c4:	7a02                	ld	s4,32(sp)
    800046c6:	6ae2                	ld	s5,24(sp)
    800046c8:	6161                	addi	sp,sp,80
    800046ca:	8082                	ret
    iunlockput(ip);
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	890080e7          	jalr	-1904(ra) # 80002f5e <iunlockput>
    return 0;
    800046d6:	4481                	li	s1,0
    800046d8:	b7c5                	j	800046b8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046da:	85ce                	mv	a1,s3
    800046dc:	00092503          	lw	a0,0(s2)
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	484080e7          	jalr	1156(ra) # 80002b64 <ialloc>
    800046e8:	84aa                	mv	s1,a0
    800046ea:	c529                	beqz	a0,80004734 <create+0xee>
  ilock(ip);
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	610080e7          	jalr	1552(ra) # 80002cfc <ilock>
  ip->major = major;
    800046f4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046f8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046fc:	4785                	li	a5,1
    800046fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004702:	8526                	mv	a0,s1
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	52e080e7          	jalr	1326(ra) # 80002c32 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000470c:	2981                	sext.w	s3,s3
    8000470e:	4785                	li	a5,1
    80004710:	02f98a63          	beq	s3,a5,80004744 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004714:	40d0                	lw	a2,4(s1)
    80004716:	fb040593          	addi	a1,s0,-80
    8000471a:	854a                	mv	a0,s2
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	cd4080e7          	jalr	-812(ra) # 800033f0 <dirlink>
    80004724:	06054b63          	bltz	a0,8000479a <create+0x154>
  iunlockput(dp);
    80004728:	854a                	mv	a0,s2
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	834080e7          	jalr	-1996(ra) # 80002f5e <iunlockput>
  return ip;
    80004732:	b759                	j	800046b8 <create+0x72>
    panic("create: ialloc");
    80004734:	00004517          	auipc	a0,0x4
    80004738:	00c50513          	addi	a0,a0,12 # 80008740 <syscalls+0x2e8>
    8000473c:	00001097          	auipc	ra,0x1
    80004740:	68c080e7          	jalr	1676(ra) # 80005dc8 <panic>
    dp->nlink++;  // for ".."
    80004744:	04a95783          	lhu	a5,74(s2)
    80004748:	2785                	addiw	a5,a5,1
    8000474a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000474e:	854a                	mv	a0,s2
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	4e2080e7          	jalr	1250(ra) # 80002c32 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004758:	40d0                	lw	a2,4(s1)
    8000475a:	00004597          	auipc	a1,0x4
    8000475e:	ff658593          	addi	a1,a1,-10 # 80008750 <syscalls+0x2f8>
    80004762:	8526                	mv	a0,s1
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	c8c080e7          	jalr	-884(ra) # 800033f0 <dirlink>
    8000476c:	00054f63          	bltz	a0,8000478a <create+0x144>
    80004770:	00492603          	lw	a2,4(s2)
    80004774:	00004597          	auipc	a1,0x4
    80004778:	a3458593          	addi	a1,a1,-1484 # 800081a8 <etext+0x1a8>
    8000477c:	8526                	mv	a0,s1
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	c72080e7          	jalr	-910(ra) # 800033f0 <dirlink>
    80004786:	f80557e3          	bgez	a0,80004714 <create+0xce>
      panic("create dots");
    8000478a:	00004517          	auipc	a0,0x4
    8000478e:	fce50513          	addi	a0,a0,-50 # 80008758 <syscalls+0x300>
    80004792:	00001097          	auipc	ra,0x1
    80004796:	636080e7          	jalr	1590(ra) # 80005dc8 <panic>
    panic("create: dirlink");
    8000479a:	00004517          	auipc	a0,0x4
    8000479e:	fce50513          	addi	a0,a0,-50 # 80008768 <syscalls+0x310>
    800047a2:	00001097          	auipc	ra,0x1
    800047a6:	626080e7          	jalr	1574(ra) # 80005dc8 <panic>
    return 0;
    800047aa:	84aa                	mv	s1,a0
    800047ac:	b731                	j	800046b8 <create+0x72>

00000000800047ae <sys_dup>:
{
    800047ae:	7179                	addi	sp,sp,-48
    800047b0:	f406                	sd	ra,40(sp)
    800047b2:	f022                	sd	s0,32(sp)
    800047b4:	ec26                	sd	s1,24(sp)
    800047b6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b8:	fd840613          	addi	a2,s0,-40
    800047bc:	4581                	li	a1,0
    800047be:	4501                	li	a0,0
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	ddc080e7          	jalr	-548(ra) # 8000459c <argfd>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ca:	02054363          	bltz	a0,800047f0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047ce:	fd843503          	ld	a0,-40(s0)
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	e32080e7          	jalr	-462(ra) # 80004604 <fdalloc>
    800047da:	84aa                	mv	s1,a0
    return -1;
    800047dc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047de:	00054963          	bltz	a0,800047f0 <sys_dup+0x42>
  filedup(f);
    800047e2:	fd843503          	ld	a0,-40(s0)
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	362080e7          	jalr	866(ra) # 80003b48 <filedup>
  return fd;
    800047ee:	87a6                	mv	a5,s1
}
    800047f0:	853e                	mv	a0,a5
    800047f2:	70a2                	ld	ra,40(sp)
    800047f4:	7402                	ld	s0,32(sp)
    800047f6:	64e2                	ld	s1,24(sp)
    800047f8:	6145                	addi	sp,sp,48
    800047fa:	8082                	ret

00000000800047fc <sys_read>:
{
    800047fc:	7179                	addi	sp,sp,-48
    800047fe:	f406                	sd	ra,40(sp)
    80004800:	f022                	sd	s0,32(sp)
    80004802:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004804:	fe840613          	addi	a2,s0,-24
    80004808:	4581                	li	a1,0
    8000480a:	4501                	li	a0,0
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	d90080e7          	jalr	-624(ra) # 8000459c <argfd>
    return -1;
    80004814:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	04054163          	bltz	a0,80004858 <sys_read+0x5c>
    8000481a:	fe440593          	addi	a1,s0,-28
    8000481e:	4509                	li	a0,2
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	8a0080e7          	jalr	-1888(ra) # 800020c0 <argint>
    return -1;
    80004828:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482a:	02054763          	bltz	a0,80004858 <sys_read+0x5c>
    8000482e:	fd840593          	addi	a1,s0,-40
    80004832:	4505                	li	a0,1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	8ae080e7          	jalr	-1874(ra) # 800020e2 <argaddr>
    return -1;
    8000483c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483e:	00054d63          	bltz	a0,80004858 <sys_read+0x5c>
  return fileread(f, p, n);
    80004842:	fe442603          	lw	a2,-28(s0)
    80004846:	fd843583          	ld	a1,-40(s0)
    8000484a:	fe843503          	ld	a0,-24(s0)
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	486080e7          	jalr	1158(ra) # 80003cd4 <fileread>
    80004856:	87aa                	mv	a5,a0
}
    80004858:	853e                	mv	a0,a5
    8000485a:	70a2                	ld	ra,40(sp)
    8000485c:	7402                	ld	s0,32(sp)
    8000485e:	6145                	addi	sp,sp,48
    80004860:	8082                	ret

0000000080004862 <sys_write>:
{
    80004862:	7179                	addi	sp,sp,-48
    80004864:	f406                	sd	ra,40(sp)
    80004866:	f022                	sd	s0,32(sp)
    80004868:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	fe840613          	addi	a2,s0,-24
    8000486e:	4581                	li	a1,0
    80004870:	4501                	li	a0,0
    80004872:	00000097          	auipc	ra,0x0
    80004876:	d2a080e7          	jalr	-726(ra) # 8000459c <argfd>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	04054163          	bltz	a0,800048be <sys_write+0x5c>
    80004880:	fe440593          	addi	a1,s0,-28
    80004884:	4509                	li	a0,2
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	83a080e7          	jalr	-1990(ra) # 800020c0 <argint>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004890:	02054763          	bltz	a0,800048be <sys_write+0x5c>
    80004894:	fd840593          	addi	a1,s0,-40
    80004898:	4505                	li	a0,1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	848080e7          	jalr	-1976(ra) # 800020e2 <argaddr>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a4:	00054d63          	bltz	a0,800048be <sys_write+0x5c>
  return filewrite(f, p, n);
    800048a8:	fe442603          	lw	a2,-28(s0)
    800048ac:	fd843583          	ld	a1,-40(s0)
    800048b0:	fe843503          	ld	a0,-24(s0)
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	4e2080e7          	jalr	1250(ra) # 80003d96 <filewrite>
    800048bc:	87aa                	mv	a5,a0
}
    800048be:	853e                	mv	a0,a5
    800048c0:	70a2                	ld	ra,40(sp)
    800048c2:	7402                	ld	s0,32(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret

00000000800048c8 <sys_close>:
{
    800048c8:	1101                	addi	sp,sp,-32
    800048ca:	ec06                	sd	ra,24(sp)
    800048cc:	e822                	sd	s0,16(sp)
    800048ce:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048d0:	fe040613          	addi	a2,s0,-32
    800048d4:	fec40593          	addi	a1,s0,-20
    800048d8:	4501                	li	a0,0
    800048da:	00000097          	auipc	ra,0x0
    800048de:	cc2080e7          	jalr	-830(ra) # 8000459c <argfd>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048e4:	02054463          	bltz	a0,8000490c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048e8:	ffffc097          	auipc	ra,0xffffc
    800048ec:	67e080e7          	jalr	1662(ra) # 80000f66 <myproc>
    800048f0:	fec42783          	lw	a5,-20(s0)
    800048f4:	07e9                	addi	a5,a5,26
    800048f6:	078e                	slli	a5,a5,0x3
    800048f8:	97aa                	add	a5,a5,a0
    800048fa:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800048fe:	fe043503          	ld	a0,-32(s0)
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	298080e7          	jalr	664(ra) # 80003b9a <fileclose>
  return 0;
    8000490a:	4781                	li	a5,0
}
    8000490c:	853e                	mv	a0,a5
    8000490e:	60e2                	ld	ra,24(sp)
    80004910:	6442                	ld	s0,16(sp)
    80004912:	6105                	addi	sp,sp,32
    80004914:	8082                	ret

0000000080004916 <sys_fstat>:
{
    80004916:	1101                	addi	sp,sp,-32
    80004918:	ec06                	sd	ra,24(sp)
    8000491a:	e822                	sd	s0,16(sp)
    8000491c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491e:	fe840613          	addi	a2,s0,-24
    80004922:	4581                	li	a1,0
    80004924:	4501                	li	a0,0
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	c76080e7          	jalr	-906(ra) # 8000459c <argfd>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004930:	02054563          	bltz	a0,8000495a <sys_fstat+0x44>
    80004934:	fe040593          	addi	a1,s0,-32
    80004938:	4505                	li	a0,1
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	7a8080e7          	jalr	1960(ra) # 800020e2 <argaddr>
    return -1;
    80004942:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004944:	00054b63          	bltz	a0,8000495a <sys_fstat+0x44>
  return filestat(f, st);
    80004948:	fe043583          	ld	a1,-32(s0)
    8000494c:	fe843503          	ld	a0,-24(s0)
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	312080e7          	jalr	786(ra) # 80003c62 <filestat>
    80004958:	87aa                	mv	a5,a0
}
    8000495a:	853e                	mv	a0,a5
    8000495c:	60e2                	ld	ra,24(sp)
    8000495e:	6442                	ld	s0,16(sp)
    80004960:	6105                	addi	sp,sp,32
    80004962:	8082                	ret

0000000080004964 <sys_link>:
{
    80004964:	7169                	addi	sp,sp,-304
    80004966:	f606                	sd	ra,296(sp)
    80004968:	f222                	sd	s0,288(sp)
    8000496a:	ee26                	sd	s1,280(sp)
    8000496c:	ea4a                	sd	s2,272(sp)
    8000496e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004970:	08000613          	li	a2,128
    80004974:	ed040593          	addi	a1,s0,-304
    80004978:	4501                	li	a0,0
    8000497a:	ffffd097          	auipc	ra,0xffffd
    8000497e:	78a080e7          	jalr	1930(ra) # 80002104 <argstr>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004984:	10054e63          	bltz	a0,80004aa0 <sys_link+0x13c>
    80004988:	08000613          	li	a2,128
    8000498c:	f5040593          	addi	a1,s0,-176
    80004990:	4505                	li	a0,1
    80004992:	ffffd097          	auipc	ra,0xffffd
    80004996:	772080e7          	jalr	1906(ra) # 80002104 <argstr>
    return -1;
    8000499a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499c:	10054263          	bltz	a0,80004aa0 <sys_link+0x13c>
  begin_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	d2e080e7          	jalr	-722(ra) # 800036ce <begin_op>
  if((ip = namei(old)) == 0){
    800049a8:	ed040513          	addi	a0,s0,-304
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	b06080e7          	jalr	-1274(ra) # 800034b2 <namei>
    800049b4:	84aa                	mv	s1,a0
    800049b6:	c551                	beqz	a0,80004a42 <sys_link+0xde>
  ilock(ip);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	344080e7          	jalr	836(ra) # 80002cfc <ilock>
  if(ip->type == T_DIR){
    800049c0:	04449703          	lh	a4,68(s1)
    800049c4:	4785                	li	a5,1
    800049c6:	08f70463          	beq	a4,a5,80004a4e <sys_link+0xea>
  ip->nlink++;
    800049ca:	04a4d783          	lhu	a5,74(s1)
    800049ce:	2785                	addiw	a5,a5,1
    800049d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	25c080e7          	jalr	604(ra) # 80002c32 <iupdate>
  iunlock(ip);
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	3de080e7          	jalr	990(ra) # 80002dbe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049e8:	fd040593          	addi	a1,s0,-48
    800049ec:	f5040513          	addi	a0,s0,-176
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	ae0080e7          	jalr	-1312(ra) # 800034d0 <nameiparent>
    800049f8:	892a                	mv	s2,a0
    800049fa:	c935                	beqz	a0,80004a6e <sys_link+0x10a>
  ilock(dp);
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	300080e7          	jalr	768(ra) # 80002cfc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a04:	00092703          	lw	a4,0(s2)
    80004a08:	409c                	lw	a5,0(s1)
    80004a0a:	04f71d63          	bne	a4,a5,80004a64 <sys_link+0x100>
    80004a0e:	40d0                	lw	a2,4(s1)
    80004a10:	fd040593          	addi	a1,s0,-48
    80004a14:	854a                	mv	a0,s2
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	9da080e7          	jalr	-1574(ra) # 800033f0 <dirlink>
    80004a1e:	04054363          	bltz	a0,80004a64 <sys_link+0x100>
  iunlockput(dp);
    80004a22:	854a                	mv	a0,s2
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	53a080e7          	jalr	1338(ra) # 80002f5e <iunlockput>
  iput(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	488080e7          	jalr	1160(ra) # 80002eb6 <iput>
  end_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	d18080e7          	jalr	-744(ra) # 8000374e <end_op>
  return 0;
    80004a3e:	4781                	li	a5,0
    80004a40:	a085                	j	80004aa0 <sys_link+0x13c>
    end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	d0c080e7          	jalr	-756(ra) # 8000374e <end_op>
    return -1;
    80004a4a:	57fd                	li	a5,-1
    80004a4c:	a891                	j	80004aa0 <sys_link+0x13c>
    iunlockput(ip);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	50e080e7          	jalr	1294(ra) # 80002f5e <iunlockput>
    end_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	cf6080e7          	jalr	-778(ra) # 8000374e <end_op>
    return -1;
    80004a60:	57fd                	li	a5,-1
    80004a62:	a83d                	j	80004aa0 <sys_link+0x13c>
    iunlockput(dp);
    80004a64:	854a                	mv	a0,s2
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	4f8080e7          	jalr	1272(ra) # 80002f5e <iunlockput>
  ilock(ip);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	28c080e7          	jalr	652(ra) # 80002cfc <ilock>
  ip->nlink--;
    80004a78:	04a4d783          	lhu	a5,74(s1)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	1ae080e7          	jalr	430(ra) # 80002c32 <iupdate>
  iunlockput(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	4d0080e7          	jalr	1232(ra) # 80002f5e <iunlockput>
  end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	cb8080e7          	jalr	-840(ra) # 8000374e <end_op>
  return -1;
    80004a9e:	57fd                	li	a5,-1
}
    80004aa0:	853e                	mv	a0,a5
    80004aa2:	70b2                	ld	ra,296(sp)
    80004aa4:	7412                	ld	s0,288(sp)
    80004aa6:	64f2                	ld	s1,280(sp)
    80004aa8:	6952                	ld	s2,272(sp)
    80004aaa:	6155                	addi	sp,sp,304
    80004aac:	8082                	ret

0000000080004aae <sys_unlink>:
{
    80004aae:	7151                	addi	sp,sp,-240
    80004ab0:	f586                	sd	ra,232(sp)
    80004ab2:	f1a2                	sd	s0,224(sp)
    80004ab4:	eda6                	sd	s1,216(sp)
    80004ab6:	e9ca                	sd	s2,208(sp)
    80004ab8:	e5ce                	sd	s3,200(sp)
    80004aba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004abc:	08000613          	li	a2,128
    80004ac0:	f3040593          	addi	a1,s0,-208
    80004ac4:	4501                	li	a0,0
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	63e080e7          	jalr	1598(ra) # 80002104 <argstr>
    80004ace:	18054163          	bltz	a0,80004c50 <sys_unlink+0x1a2>
  begin_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	bfc080e7          	jalr	-1028(ra) # 800036ce <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ada:	fb040593          	addi	a1,s0,-80
    80004ade:	f3040513          	addi	a0,s0,-208
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	9ee080e7          	jalr	-1554(ra) # 800034d0 <nameiparent>
    80004aea:	84aa                	mv	s1,a0
    80004aec:	c979                	beqz	a0,80004bc2 <sys_unlink+0x114>
  ilock(dp);
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	20e080e7          	jalr	526(ra) # 80002cfc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004af6:	00004597          	auipc	a1,0x4
    80004afa:	c5a58593          	addi	a1,a1,-934 # 80008750 <syscalls+0x2f8>
    80004afe:	fb040513          	addi	a0,s0,-80
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	6c4080e7          	jalr	1732(ra) # 800031c6 <namecmp>
    80004b0a:	14050a63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
    80004b0e:	00003597          	auipc	a1,0x3
    80004b12:	69a58593          	addi	a1,a1,1690 # 800081a8 <etext+0x1a8>
    80004b16:	fb040513          	addi	a0,s0,-80
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	6ac080e7          	jalr	1708(ra) # 800031c6 <namecmp>
    80004b22:	12050e63          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b26:	f2c40613          	addi	a2,s0,-212
    80004b2a:	fb040593          	addi	a1,s0,-80
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	6b0080e7          	jalr	1712(ra) # 800031e0 <dirlookup>
    80004b38:	892a                	mv	s2,a0
    80004b3a:	12050263          	beqz	a0,80004c5e <sys_unlink+0x1b0>
  ilock(ip);
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	1be080e7          	jalr	446(ra) # 80002cfc <ilock>
  if(ip->nlink < 1)
    80004b46:	04a91783          	lh	a5,74(s2)
    80004b4a:	08f05263          	blez	a5,80004bce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	4785                	li	a5,1
    80004b54:	08f70563          	beq	a4,a5,80004bde <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b58:	4641                	li	a2,16
    80004b5a:	4581                	li	a1,0
    80004b5c:	fc040513          	addi	a0,s0,-64
    80004b60:	ffffb097          	auipc	ra,0xffffb
    80004b64:	618080e7          	jalr	1560(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b68:	4741                	li	a4,16
    80004b6a:	f2c42683          	lw	a3,-212(s0)
    80004b6e:	fc040613          	addi	a2,s0,-64
    80004b72:	4581                	li	a1,0
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	532080e7          	jalr	1330(ra) # 800030a8 <writei>
    80004b7e:	47c1                	li	a5,16
    80004b80:	0af51563          	bne	a0,a5,80004c2a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b84:	04491703          	lh	a4,68(s2)
    80004b88:	4785                	li	a5,1
    80004b8a:	0af70863          	beq	a4,a5,80004c3a <sys_unlink+0x18c>
  iunlockput(dp);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	3ce080e7          	jalr	974(ra) # 80002f5e <iunlockput>
  ip->nlink--;
    80004b98:	04a95783          	lhu	a5,74(s2)
    80004b9c:	37fd                	addiw	a5,a5,-1
    80004b9e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	08e080e7          	jalr	142(ra) # 80002c32 <iupdate>
  iunlockput(ip);
    80004bac:	854a                	mv	a0,s2
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	3b0080e7          	jalr	944(ra) # 80002f5e <iunlockput>
  end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	b98080e7          	jalr	-1128(ra) # 8000374e <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
    80004bc0:	a84d                	j	80004c72 <sys_unlink+0x1c4>
    end_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	b8c080e7          	jalr	-1140(ra) # 8000374e <end_op>
    return -1;
    80004bca:	557d                	li	a0,-1
    80004bcc:	a05d                	j	80004c72 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	baa50513          	addi	a0,a0,-1110 # 80008778 <syscalls+0x320>
    80004bd6:	00001097          	auipc	ra,0x1
    80004bda:	1f2080e7          	jalr	498(ra) # 80005dc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bde:	04c92703          	lw	a4,76(s2)
    80004be2:	02000793          	li	a5,32
    80004be6:	f6e7f9e3          	bgeu	a5,a4,80004b58 <sys_unlink+0xaa>
    80004bea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bee:	4741                	li	a4,16
    80004bf0:	86ce                	mv	a3,s3
    80004bf2:	f1840613          	addi	a2,s0,-232
    80004bf6:	4581                	li	a1,0
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	3b6080e7          	jalr	950(ra) # 80002fb0 <readi>
    80004c02:	47c1                	li	a5,16
    80004c04:	00f51b63          	bne	a0,a5,80004c1a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c08:	f1845783          	lhu	a5,-232(s0)
    80004c0c:	e7a1                	bnez	a5,80004c54 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0e:	29c1                	addiw	s3,s3,16
    80004c10:	04c92783          	lw	a5,76(s2)
    80004c14:	fcf9ede3          	bltu	s3,a5,80004bee <sys_unlink+0x140>
    80004c18:	b781                	j	80004b58 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c1a:	00004517          	auipc	a0,0x4
    80004c1e:	b7650513          	addi	a0,a0,-1162 # 80008790 <syscalls+0x338>
    80004c22:	00001097          	auipc	ra,0x1
    80004c26:	1a6080e7          	jalr	422(ra) # 80005dc8 <panic>
    panic("unlink: writei");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	b7e50513          	addi	a0,a0,-1154 # 800087a8 <syscalls+0x350>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	196080e7          	jalr	406(ra) # 80005dc8 <panic>
    dp->nlink--;
    80004c3a:	04a4d783          	lhu	a5,74(s1)
    80004c3e:	37fd                	addiw	a5,a5,-1
    80004c40:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	fec080e7          	jalr	-20(ra) # 80002c32 <iupdate>
    80004c4e:	b781                	j	80004b8e <sys_unlink+0xe0>
    return -1;
    80004c50:	557d                	li	a0,-1
    80004c52:	a005                	j	80004c72 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	308080e7          	jalr	776(ra) # 80002f5e <iunlockput>
  iunlockput(dp);
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	2fe080e7          	jalr	766(ra) # 80002f5e <iunlockput>
  end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	ae6080e7          	jalr	-1306(ra) # 8000374e <end_op>
  return -1;
    80004c70:	557d                	li	a0,-1
}
    80004c72:	70ae                	ld	ra,232(sp)
    80004c74:	740e                	ld	s0,224(sp)
    80004c76:	64ee                	ld	s1,216(sp)
    80004c78:	694e                	ld	s2,208(sp)
    80004c7a:	69ae                	ld	s3,200(sp)
    80004c7c:	616d                	addi	sp,sp,240
    80004c7e:	8082                	ret

0000000080004c80 <sys_open>:

uint64
sys_open(void)
{
    80004c80:	7131                	addi	sp,sp,-192
    80004c82:	fd06                	sd	ra,184(sp)
    80004c84:	f922                	sd	s0,176(sp)
    80004c86:	f526                	sd	s1,168(sp)
    80004c88:	f14a                	sd	s2,160(sp)
    80004c8a:	ed4e                	sd	s3,152(sp)
    80004c8c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c8e:	08000613          	li	a2,128
    80004c92:	f5040593          	addi	a1,s0,-176
    80004c96:	4501                	li	a0,0
    80004c98:	ffffd097          	auipc	ra,0xffffd
    80004c9c:	46c080e7          	jalr	1132(ra) # 80002104 <argstr>
    return -1;
    80004ca0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ca2:	0c054163          	bltz	a0,80004d64 <sys_open+0xe4>
    80004ca6:	f4c40593          	addi	a1,s0,-180
    80004caa:	4505                	li	a0,1
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	414080e7          	jalr	1044(ra) # 800020c0 <argint>
    80004cb4:	0a054863          	bltz	a0,80004d64 <sys_open+0xe4>

  begin_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	a16080e7          	jalr	-1514(ra) # 800036ce <begin_op>

  if(omode & O_CREATE){
    80004cc0:	f4c42783          	lw	a5,-180(s0)
    80004cc4:	2007f793          	andi	a5,a5,512
    80004cc8:	cbdd                	beqz	a5,80004d7e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cca:	4681                	li	a3,0
    80004ccc:	4601                	li	a2,0
    80004cce:	4589                	li	a1,2
    80004cd0:	f5040513          	addi	a0,s0,-176
    80004cd4:	00000097          	auipc	ra,0x0
    80004cd8:	972080e7          	jalr	-1678(ra) # 80004646 <create>
    80004cdc:	892a                	mv	s2,a0
    if(ip == 0){
    80004cde:	c959                	beqz	a0,80004d74 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ce0:	04491703          	lh	a4,68(s2)
    80004ce4:	478d                	li	a5,3
    80004ce6:	00f71763          	bne	a4,a5,80004cf4 <sys_open+0x74>
    80004cea:	04695703          	lhu	a4,70(s2)
    80004cee:	47a5                	li	a5,9
    80004cf0:	0ce7ec63          	bltu	a5,a4,80004dc8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	dea080e7          	jalr	-534(ra) # 80003ade <filealloc>
    80004cfc:	89aa                	mv	s3,a0
    80004cfe:	10050263          	beqz	a0,80004e02 <sys_open+0x182>
    80004d02:	00000097          	auipc	ra,0x0
    80004d06:	902080e7          	jalr	-1790(ra) # 80004604 <fdalloc>
    80004d0a:	84aa                	mv	s1,a0
    80004d0c:	0e054663          	bltz	a0,80004df8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d10:	04491703          	lh	a4,68(s2)
    80004d14:	478d                	li	a5,3
    80004d16:	0cf70463          	beq	a4,a5,80004dde <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d1a:	4789                	li	a5,2
    80004d1c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d20:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d24:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d28:	f4c42783          	lw	a5,-180(s0)
    80004d2c:	0017c713          	xori	a4,a5,1
    80004d30:	8b05                	andi	a4,a4,1
    80004d32:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d36:	0037f713          	andi	a4,a5,3
    80004d3a:	00e03733          	snez	a4,a4
    80004d3e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d42:	4007f793          	andi	a5,a5,1024
    80004d46:	c791                	beqz	a5,80004d52 <sys_open+0xd2>
    80004d48:	04491703          	lh	a4,68(s2)
    80004d4c:	4789                	li	a5,2
    80004d4e:	08f70f63          	beq	a4,a5,80004dec <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d52:	854a                	mv	a0,s2
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	06a080e7          	jalr	106(ra) # 80002dbe <iunlock>
  end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	9f2080e7          	jalr	-1550(ra) # 8000374e <end_op>

  return fd;
}
    80004d64:	8526                	mv	a0,s1
    80004d66:	70ea                	ld	ra,184(sp)
    80004d68:	744a                	ld	s0,176(sp)
    80004d6a:	74aa                	ld	s1,168(sp)
    80004d6c:	790a                	ld	s2,160(sp)
    80004d6e:	69ea                	ld	s3,152(sp)
    80004d70:	6129                	addi	sp,sp,192
    80004d72:	8082                	ret
      end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	9da080e7          	jalr	-1574(ra) # 8000374e <end_op>
      return -1;
    80004d7c:	b7e5                	j	80004d64 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d7e:	f5040513          	addi	a0,s0,-176
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	730080e7          	jalr	1840(ra) # 800034b2 <namei>
    80004d8a:	892a                	mv	s2,a0
    80004d8c:	c905                	beqz	a0,80004dbc <sys_open+0x13c>
    ilock(ip);
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	f6e080e7          	jalr	-146(ra) # 80002cfc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d96:	04491703          	lh	a4,68(s2)
    80004d9a:	4785                	li	a5,1
    80004d9c:	f4f712e3          	bne	a4,a5,80004ce0 <sys_open+0x60>
    80004da0:	f4c42783          	lw	a5,-180(s0)
    80004da4:	dba1                	beqz	a5,80004cf4 <sys_open+0x74>
      iunlockput(ip);
    80004da6:	854a                	mv	a0,s2
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	1b6080e7          	jalr	438(ra) # 80002f5e <iunlockput>
      end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	99e080e7          	jalr	-1634(ra) # 8000374e <end_op>
      return -1;
    80004db8:	54fd                	li	s1,-1
    80004dba:	b76d                	j	80004d64 <sys_open+0xe4>
      end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	992080e7          	jalr	-1646(ra) # 8000374e <end_op>
      return -1;
    80004dc4:	54fd                	li	s1,-1
    80004dc6:	bf79                	j	80004d64 <sys_open+0xe4>
    iunlockput(ip);
    80004dc8:	854a                	mv	a0,s2
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	194080e7          	jalr	404(ra) # 80002f5e <iunlockput>
    end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	97c080e7          	jalr	-1668(ra) # 8000374e <end_op>
    return -1;
    80004dda:	54fd                	li	s1,-1
    80004ddc:	b761                	j	80004d64 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dde:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004de2:	04691783          	lh	a5,70(s2)
    80004de6:	02f99223          	sh	a5,36(s3)
    80004dea:	bf2d                	j	80004d24 <sys_open+0xa4>
    itrunc(ip);
    80004dec:	854a                	mv	a0,s2
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	01c080e7          	jalr	28(ra) # 80002e0a <itrunc>
    80004df6:	bfb1                	j	80004d52 <sys_open+0xd2>
      fileclose(f);
    80004df8:	854e                	mv	a0,s3
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	da0080e7          	jalr	-608(ra) # 80003b9a <fileclose>
    iunlockput(ip);
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	15a080e7          	jalr	346(ra) # 80002f5e <iunlockput>
    end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	942080e7          	jalr	-1726(ra) # 8000374e <end_op>
    return -1;
    80004e14:	54fd                	li	s1,-1
    80004e16:	b7b9                	j	80004d64 <sys_open+0xe4>

0000000080004e18 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e18:	7175                	addi	sp,sp,-144
    80004e1a:	e506                	sd	ra,136(sp)
    80004e1c:	e122                	sd	s0,128(sp)
    80004e1e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	8ae080e7          	jalr	-1874(ra) # 800036ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e28:	08000613          	li	a2,128
    80004e2c:	f7040593          	addi	a1,s0,-144
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	2d2080e7          	jalr	722(ra) # 80002104 <argstr>
    80004e3a:	02054963          	bltz	a0,80004e6c <sys_mkdir+0x54>
    80004e3e:	4681                	li	a3,0
    80004e40:	4601                	li	a2,0
    80004e42:	4585                	li	a1,1
    80004e44:	f7040513          	addi	a0,s0,-144
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	7fe080e7          	jalr	2046(ra) # 80004646 <create>
    80004e50:	cd11                	beqz	a0,80004e6c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	10c080e7          	jalr	268(ra) # 80002f5e <iunlockput>
  end_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	8f4080e7          	jalr	-1804(ra) # 8000374e <end_op>
  return 0;
    80004e62:	4501                	li	a0,0
}
    80004e64:	60aa                	ld	ra,136(sp)
    80004e66:	640a                	ld	s0,128(sp)
    80004e68:	6149                	addi	sp,sp,144
    80004e6a:	8082                	ret
    end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8e2080e7          	jalr	-1822(ra) # 8000374e <end_op>
    return -1;
    80004e74:	557d                	li	a0,-1
    80004e76:	b7fd                	j	80004e64 <sys_mkdir+0x4c>

0000000080004e78 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e78:	7135                	addi	sp,sp,-160
    80004e7a:	ed06                	sd	ra,152(sp)
    80004e7c:	e922                	sd	s0,144(sp)
    80004e7e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e80:	fffff097          	auipc	ra,0xfffff
    80004e84:	84e080e7          	jalr	-1970(ra) # 800036ce <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e88:	08000613          	li	a2,128
    80004e8c:	f7040593          	addi	a1,s0,-144
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	272080e7          	jalr	626(ra) # 80002104 <argstr>
    80004e9a:	04054a63          	bltz	a0,80004eee <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e9e:	f6c40593          	addi	a1,s0,-148
    80004ea2:	4505                	li	a0,1
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	21c080e7          	jalr	540(ra) # 800020c0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eac:	04054163          	bltz	a0,80004eee <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eb0:	f6840593          	addi	a1,s0,-152
    80004eb4:	4509                	li	a0,2
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	20a080e7          	jalr	522(ra) # 800020c0 <argint>
     argint(1, &major) < 0 ||
    80004ebe:	02054863          	bltz	a0,80004eee <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ec2:	f6841683          	lh	a3,-152(s0)
    80004ec6:	f6c41603          	lh	a2,-148(s0)
    80004eca:	458d                	li	a1,3
    80004ecc:	f7040513          	addi	a0,s0,-144
    80004ed0:	fffff097          	auipc	ra,0xfffff
    80004ed4:	776080e7          	jalr	1910(ra) # 80004646 <create>
     argint(2, &minor) < 0 ||
    80004ed8:	c919                	beqz	a0,80004eee <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	084080e7          	jalr	132(ra) # 80002f5e <iunlockput>
  end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	86c080e7          	jalr	-1940(ra) # 8000374e <end_op>
  return 0;
    80004eea:	4501                	li	a0,0
    80004eec:	a031                	j	80004ef8 <sys_mknod+0x80>
    end_op();
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	860080e7          	jalr	-1952(ra) # 8000374e <end_op>
    return -1;
    80004ef6:	557d                	li	a0,-1
}
    80004ef8:	60ea                	ld	ra,152(sp)
    80004efa:	644a                	ld	s0,144(sp)
    80004efc:	610d                	addi	sp,sp,160
    80004efe:	8082                	ret

0000000080004f00 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f00:	7135                	addi	sp,sp,-160
    80004f02:	ed06                	sd	ra,152(sp)
    80004f04:	e922                	sd	s0,144(sp)
    80004f06:	e526                	sd	s1,136(sp)
    80004f08:	e14a                	sd	s2,128(sp)
    80004f0a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	05a080e7          	jalr	90(ra) # 80000f66 <myproc>
    80004f14:	892a                	mv	s2,a0
  
  begin_op();
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	7b8080e7          	jalr	1976(ra) # 800036ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f1e:	08000613          	li	a2,128
    80004f22:	f6040593          	addi	a1,s0,-160
    80004f26:	4501                	li	a0,0
    80004f28:	ffffd097          	auipc	ra,0xffffd
    80004f2c:	1dc080e7          	jalr	476(ra) # 80002104 <argstr>
    80004f30:	04054b63          	bltz	a0,80004f86 <sys_chdir+0x86>
    80004f34:	f6040513          	addi	a0,s0,-160
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	57a080e7          	jalr	1402(ra) # 800034b2 <namei>
    80004f40:	84aa                	mv	s1,a0
    80004f42:	c131                	beqz	a0,80004f86 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	db8080e7          	jalr	-584(ra) # 80002cfc <ilock>
  if(ip->type != T_DIR){
    80004f4c:	04449703          	lh	a4,68(s1)
    80004f50:	4785                	li	a5,1
    80004f52:	04f71063          	bne	a4,a5,80004f92 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f56:	8526                	mv	a0,s1
    80004f58:	ffffe097          	auipc	ra,0xffffe
    80004f5c:	e66080e7          	jalr	-410(ra) # 80002dbe <iunlock>
  iput(p->cwd);
    80004f60:	15893503          	ld	a0,344(s2)
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	f52080e7          	jalr	-174(ra) # 80002eb6 <iput>
  end_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	7e2080e7          	jalr	2018(ra) # 8000374e <end_op>
  p->cwd = ip;
    80004f74:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f78:	4501                	li	a0,0
}
    80004f7a:	60ea                	ld	ra,152(sp)
    80004f7c:	644a                	ld	s0,144(sp)
    80004f7e:	64aa                	ld	s1,136(sp)
    80004f80:	690a                	ld	s2,128(sp)
    80004f82:	610d                	addi	sp,sp,160
    80004f84:	8082                	ret
    end_op();
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	7c8080e7          	jalr	1992(ra) # 8000374e <end_op>
    return -1;
    80004f8e:	557d                	li	a0,-1
    80004f90:	b7ed                	j	80004f7a <sys_chdir+0x7a>
    iunlockput(ip);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	fca080e7          	jalr	-54(ra) # 80002f5e <iunlockput>
    end_op();
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	7b2080e7          	jalr	1970(ra) # 8000374e <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	bfd1                	j	80004f7a <sys_chdir+0x7a>

0000000080004fa8 <sys_exec>:

uint64
sys_exec(void)
{
    80004fa8:	7145                	addi	sp,sp,-464
    80004faa:	e786                	sd	ra,456(sp)
    80004fac:	e3a2                	sd	s0,448(sp)
    80004fae:	ff26                	sd	s1,440(sp)
    80004fb0:	fb4a                	sd	s2,432(sp)
    80004fb2:	f74e                	sd	s3,424(sp)
    80004fb4:	f352                	sd	s4,416(sp)
    80004fb6:	ef56                	sd	s5,408(sp)
    80004fb8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fba:	08000613          	li	a2,128
    80004fbe:	f4040593          	addi	a1,s0,-192
    80004fc2:	4501                	li	a0,0
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	140080e7          	jalr	320(ra) # 80002104 <argstr>
    return -1;
    80004fcc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fce:	0c054a63          	bltz	a0,800050a2 <sys_exec+0xfa>
    80004fd2:	e3840593          	addi	a1,s0,-456
    80004fd6:	4505                	li	a0,1
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	10a080e7          	jalr	266(ra) # 800020e2 <argaddr>
    80004fe0:	0c054163          	bltz	a0,800050a2 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fe4:	10000613          	li	a2,256
    80004fe8:	4581                	li	a1,0
    80004fea:	e4040513          	addi	a0,s0,-448
    80004fee:	ffffb097          	auipc	ra,0xffffb
    80004ff2:	18a080e7          	jalr	394(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ff6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ffa:	89a6                	mv	s3,s1
    80004ffc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ffe:	02000a13          	li	s4,32
    80005002:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005006:	00391513          	slli	a0,s2,0x3
    8000500a:	e3040593          	addi	a1,s0,-464
    8000500e:	e3843783          	ld	a5,-456(s0)
    80005012:	953e                	add	a0,a0,a5
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	012080e7          	jalr	18(ra) # 80002026 <fetchaddr>
    8000501c:	02054a63          	bltz	a0,80005050 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005020:	e3043783          	ld	a5,-464(s0)
    80005024:	c3b9                	beqz	a5,8000506a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005026:	ffffb097          	auipc	ra,0xffffb
    8000502a:	0f2080e7          	jalr	242(ra) # 80000118 <kalloc>
    8000502e:	85aa                	mv	a1,a0
    80005030:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005034:	cd11                	beqz	a0,80005050 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005036:	6605                	lui	a2,0x1
    80005038:	e3043503          	ld	a0,-464(s0)
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	03c080e7          	jalr	60(ra) # 80002078 <fetchstr>
    80005044:	00054663          	bltz	a0,80005050 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005048:	0905                	addi	s2,s2,1
    8000504a:	09a1                	addi	s3,s3,8
    8000504c:	fb491be3          	bne	s2,s4,80005002 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005050:	10048913          	addi	s2,s1,256
    80005054:	6088                	ld	a0,0(s1)
    80005056:	c529                	beqz	a0,800050a0 <sys_exec+0xf8>
    kfree(argv[i]);
    80005058:	ffffb097          	auipc	ra,0xffffb
    8000505c:	fc4080e7          	jalr	-60(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005060:	04a1                	addi	s1,s1,8
    80005062:	ff2499e3          	bne	s1,s2,80005054 <sys_exec+0xac>
  return -1;
    80005066:	597d                	li	s2,-1
    80005068:	a82d                	j	800050a2 <sys_exec+0xfa>
      argv[i] = 0;
    8000506a:	0a8e                	slli	s5,s5,0x3
    8000506c:	fc040793          	addi	a5,s0,-64
    80005070:	9abe                	add	s5,s5,a5
    80005072:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005076:	e4040593          	addi	a1,s0,-448
    8000507a:	f4040513          	addi	a0,s0,-192
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	17c080e7          	jalr	380(ra) # 800041fa <exec>
    80005086:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005088:	10048993          	addi	s3,s1,256
    8000508c:	6088                	ld	a0,0(s1)
    8000508e:	c911                	beqz	a0,800050a2 <sys_exec+0xfa>
    kfree(argv[i]);
    80005090:	ffffb097          	auipc	ra,0xffffb
    80005094:	f8c080e7          	jalr	-116(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005098:	04a1                	addi	s1,s1,8
    8000509a:	ff3499e3          	bne	s1,s3,8000508c <sys_exec+0xe4>
    8000509e:	a011                	j	800050a2 <sys_exec+0xfa>
  return -1;
    800050a0:	597d                	li	s2,-1
}
    800050a2:	854a                	mv	a0,s2
    800050a4:	60be                	ld	ra,456(sp)
    800050a6:	641e                	ld	s0,448(sp)
    800050a8:	74fa                	ld	s1,440(sp)
    800050aa:	795a                	ld	s2,432(sp)
    800050ac:	79ba                	ld	s3,424(sp)
    800050ae:	7a1a                	ld	s4,416(sp)
    800050b0:	6afa                	ld	s5,408(sp)
    800050b2:	6179                	addi	sp,sp,464
    800050b4:	8082                	ret

00000000800050b6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050b6:	7139                	addi	sp,sp,-64
    800050b8:	fc06                	sd	ra,56(sp)
    800050ba:	f822                	sd	s0,48(sp)
    800050bc:	f426                	sd	s1,40(sp)
    800050be:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	ea6080e7          	jalr	-346(ra) # 80000f66 <myproc>
    800050c8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050ca:	fd840593          	addi	a1,s0,-40
    800050ce:	4501                	li	a0,0
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	012080e7          	jalr	18(ra) # 800020e2 <argaddr>
    return -1;
    800050d8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050da:	0e054063          	bltz	a0,800051ba <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050de:	fc840593          	addi	a1,s0,-56
    800050e2:	fd040513          	addi	a0,s0,-48
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	de4080e7          	jalr	-540(ra) # 80003eca <pipealloc>
    return -1;
    800050ee:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050f0:	0c054563          	bltz	a0,800051ba <sys_pipe+0x104>
  fd0 = -1;
    800050f4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050f8:	fd043503          	ld	a0,-48(s0)
    800050fc:	fffff097          	auipc	ra,0xfffff
    80005100:	508080e7          	jalr	1288(ra) # 80004604 <fdalloc>
    80005104:	fca42223          	sw	a0,-60(s0)
    80005108:	08054c63          	bltz	a0,800051a0 <sys_pipe+0xea>
    8000510c:	fc843503          	ld	a0,-56(s0)
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	4f4080e7          	jalr	1268(ra) # 80004604 <fdalloc>
    80005118:	fca42023          	sw	a0,-64(s0)
    8000511c:	06054863          	bltz	a0,8000518c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005120:	4691                	li	a3,4
    80005122:	fc440613          	addi	a2,s0,-60
    80005126:	fd843583          	ld	a1,-40(s0)
    8000512a:	68a8                	ld	a0,80(s1)
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	abe080e7          	jalr	-1346(ra) # 80000bea <copyout>
    80005134:	02054063          	bltz	a0,80005154 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005138:	4691                	li	a3,4
    8000513a:	fc040613          	addi	a2,s0,-64
    8000513e:	fd843583          	ld	a1,-40(s0)
    80005142:	0591                	addi	a1,a1,4
    80005144:	68a8                	ld	a0,80(s1)
    80005146:	ffffc097          	auipc	ra,0xffffc
    8000514a:	aa4080e7          	jalr	-1372(ra) # 80000bea <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000514e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005150:	06055563          	bgez	a0,800051ba <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005154:	fc442783          	lw	a5,-60(s0)
    80005158:	07e9                	addi	a5,a5,26
    8000515a:	078e                	slli	a5,a5,0x3
    8000515c:	97a6                	add	a5,a5,s1
    8000515e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005162:	fc042503          	lw	a0,-64(s0)
    80005166:	0569                	addi	a0,a0,26
    80005168:	050e                	slli	a0,a0,0x3
    8000516a:	9526                	add	a0,a0,s1
    8000516c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005170:	fd043503          	ld	a0,-48(s0)
    80005174:	fffff097          	auipc	ra,0xfffff
    80005178:	a26080e7          	jalr	-1498(ra) # 80003b9a <fileclose>
    fileclose(wf);
    8000517c:	fc843503          	ld	a0,-56(s0)
    80005180:	fffff097          	auipc	ra,0xfffff
    80005184:	a1a080e7          	jalr	-1510(ra) # 80003b9a <fileclose>
    return -1;
    80005188:	57fd                	li	a5,-1
    8000518a:	a805                	j	800051ba <sys_pipe+0x104>
    if(fd0 >= 0)
    8000518c:	fc442783          	lw	a5,-60(s0)
    80005190:	0007c863          	bltz	a5,800051a0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005194:	01a78513          	addi	a0,a5,26
    80005198:	050e                	slli	a0,a0,0x3
    8000519a:	9526                	add	a0,a0,s1
    8000519c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051a0:	fd043503          	ld	a0,-48(s0)
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	9f6080e7          	jalr	-1546(ra) # 80003b9a <fileclose>
    fileclose(wf);
    800051ac:	fc843503          	ld	a0,-56(s0)
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	9ea080e7          	jalr	-1558(ra) # 80003b9a <fileclose>
    return -1;
    800051b8:	57fd                	li	a5,-1
}
    800051ba:	853e                	mv	a0,a5
    800051bc:	70e2                	ld	ra,56(sp)
    800051be:	7442                	ld	s0,48(sp)
    800051c0:	74a2                	ld	s1,40(sp)
    800051c2:	6121                	addi	sp,sp,64
    800051c4:	8082                	ret
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	ce3fc0ef          	jal	ra,80001ef2 <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	c92080e7          	jalr	-878(ra) # 80000f3a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	953e                	add	a0,a0,a5
    800052cc:	00052023          	sw	zero,0(a0)
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	c5a080e7          	jalr	-934(ra) # 80000f3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5179b          	slliw	a5,a0,0xd
    800052ec:	0c201537          	lui	a0,0xc201
    800052f0:	953e                	add	a0,a0,a5
  return irq;
}
    800052f2:	4148                	lw	a0,4(a0)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	c32080e7          	jalr	-974(ra) # 80000f3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	06a7c963          	blt	a5,a0,800053a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	00016797          	auipc	a5,0x16
    80005338:	ccc78793          	addi	a5,a5,-820 # 8001b000 <disk>
    8000533c:	00a78733          	add	a4,a5,a0
    80005340:	6789                	lui	a5,0x2
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005348:	e7ad                	bnez	a5,800053b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534a:	00451793          	slli	a5,a0,0x4
    8000534e:	00018717          	auipc	a4,0x18
    80005352:	cb270713          	addi	a4,a4,-846 # 8001d000 <disk+0x2000>
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000535e:	6314                	ld	a3,0(a4)
    80005360:	96be                	add	a3,a3,a5
    80005362:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000536e:	6318                	ld	a4,0(a4)
    80005370:	97ba                	add	a5,a5,a4
    80005372:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005376:	00016797          	auipc	a5,0x16
    8000537a:	c8a78793          	addi	a5,a5,-886 # 8001b000 <disk>
    8000537e:	97aa                	add	a5,a5,a0
    80005380:	6509                	lui	a0,0x2
    80005382:	953e                	add	a0,a0,a5
    80005384:	4785                	li	a5,1
    80005386:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538a:	00018517          	auipc	a0,0x18
    8000538e:	c8e50513          	addi	a0,a0,-882 # 8001d018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	4ca080e7          	jalr	1226(ra) # 8000185c <wakeup>
}
    8000539a:	60a2                	ld	ra,8(sp)
    8000539c:	6402                	ld	s0,0(sp)
    8000539e:	0141                	addi	sp,sp,16
    800053a0:	8082                	ret
    panic("free_desc 1");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	41650513          	addi	a0,a0,1046 # 800087b8 <syscalls+0x360>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a1e080e7          	jalr	-1506(ra) # 80005dc8 <panic>
    panic("free_desc 2");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	41650513          	addi	a0,a0,1046 # 800087c8 <syscalls+0x370>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a0e080e7          	jalr	-1522(ra) # 80005dc8 <panic>

00000000800053c2 <virtio_disk_init>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	e426                	sd	s1,8(sp)
    800053ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	40c58593          	addi	a1,a1,1036 # 800087d8 <syscalls+0x380>
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	d5450513          	addi	a0,a0,-684 # 8001d128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	ea6080e7          	jalr	-346(ra) # 80006282 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71163          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4705                	li	a4,1
    80005402:	0ce79a63          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000540e:	4709                	li	a4,2
    80005410:	0ce79363          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	47d8                	lw	a4,12(a5)
    8000541a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	554d47b7          	lui	a5,0x554d4
    80005420:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005424:	0af71963          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	4705                	li	a4,1
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005430:	470d                	li	a4,3
    80005432:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005434:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005436:	c7ffe737          	lui	a4,0xc7ffe
    8000543a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000543e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	2701                	sext.w	a4,a4
    80005442:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005444:	472d                	li	a4,11
    80005446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	473d                	li	a4,15
    8000544a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000544c:	6705                	lui	a4,0x1
    8000544e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005450:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005454:	5bdc                	lw	a5,52(a5)
    80005456:	2781                	sext.w	a5,a5
  if(max == 0)
    80005458:	c7d9                	beqz	a5,800054e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000545a:	471d                	li	a4,7
    8000545c:	08f77d63          	bgeu	a4,a5,800054f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005460:	100014b7          	lui	s1,0x10001
    80005464:	47a1                	li	a5,8
    80005466:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005468:	6609                	lui	a2,0x2
    8000546a:	4581                	li	a1,0
    8000546c:	00016517          	auipc	a0,0x16
    80005470:	b9450513          	addi	a0,a0,-1132 # 8001b000 <disk>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d04080e7          	jalr	-764(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000547c:	00016717          	auipc	a4,0x16
    80005480:	b8470713          	addi	a4,a4,-1148 # 8001b000 <disk>
    80005484:	00c75793          	srli	a5,a4,0xc
    80005488:	2781                	sext.w	a5,a5
    8000548a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548c:	00018797          	auipc	a5,0x18
    80005490:	b7478793          	addi	a5,a5,-1164 # 8001d000 <disk+0x2000>
    80005494:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005496:	00016717          	auipc	a4,0x16
    8000549a:	bea70713          	addi	a4,a4,-1046 # 8001b080 <disk+0x80>
    8000549e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054a0:	00017717          	auipc	a4,0x17
    800054a4:	b6070713          	addi	a4,a4,-1184 # 8001c000 <disk+0x1000>
    800054a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054aa:	4705                	li	a4,1
    800054ac:	00e78c23          	sb	a4,24(a5)
    800054b0:	00e78ca3          	sb	a4,25(a5)
    800054b4:	00e78d23          	sb	a4,26(a5)
    800054b8:	00e78da3          	sb	a4,27(a5)
    800054bc:	00e78e23          	sb	a4,28(a5)
    800054c0:	00e78ea3          	sb	a4,29(a5)
    800054c4:	00e78f23          	sb	a4,30(a5)
    800054c8:	00e78fa3          	sb	a4,31(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret
    panic("could not find virtio disk");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	31250513          	addi	a0,a0,786 # 800087e8 <syscalls+0x390>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ea080e7          	jalr	-1814(ra) # 80005dc8 <panic>
    panic("virtio disk has no queue 0");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	32250513          	addi	a0,a0,802 # 80008808 <syscalls+0x3b0>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8da080e7          	jalr	-1830(ra) # 80005dc8 <panic>
    panic("virtio disk max queue too short");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	33250513          	addi	a0,a0,818 # 80008828 <syscalls+0x3d0>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8ca080e7          	jalr	-1846(ra) # 80005dc8 <panic>

0000000080005506 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005506:	7159                	addi	sp,sp,-112
    80005508:	f486                	sd	ra,104(sp)
    8000550a:	f0a2                	sd	s0,96(sp)
    8000550c:	eca6                	sd	s1,88(sp)
    8000550e:	e8ca                	sd	s2,80(sp)
    80005510:	e4ce                	sd	s3,72(sp)
    80005512:	e0d2                	sd	s4,64(sp)
    80005514:	fc56                	sd	s5,56(sp)
    80005516:	f85a                	sd	s6,48(sp)
    80005518:	f45e                	sd	s7,40(sp)
    8000551a:	f062                	sd	s8,32(sp)
    8000551c:	ec66                	sd	s9,24(sp)
    8000551e:	e86a                	sd	s10,16(sp)
    80005520:	1880                	addi	s0,sp,112
    80005522:	892a                	mv	s2,a0
    80005524:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52c83          	lw	s9,12(a0)
    8000552a:	001c9c9b          	slliw	s9,s9,0x1
    8000552e:	1c82                	slli	s9,s9,0x20
    80005530:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005534:	00018517          	auipc	a0,0x18
    80005538:	bf450513          	addi	a0,a0,-1036 # 8001d128 <disk+0x2128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	dd6080e7          	jalr	-554(ra) # 80006312 <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005548:	00016b97          	auipc	s7,0x16
    8000554c:	ab8b8b93          	addi	s7,s7,-1352 # 8001b000 <disk>
    80005550:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005552:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005554:	8a4e                	mv	s4,s3
    80005556:	a051                	j	800055da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005558:	00fb86b3          	add	a3,s7,a5
    8000555c:	96da                	add	a3,a3,s6
    8000555e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005562:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005564:	0207c563          	bltz	a5,8000558e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005568:	2485                	addiw	s1,s1,1
    8000556a:	0711                	addi	a4,a4,4
    8000556c:	25548063          	beq	s1,s5,800057ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005570:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005572:	00018697          	auipc	a3,0x18
    80005576:	aa668693          	addi	a3,a3,-1370 # 8001d018 <disk+0x2018>
    8000557a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000557c:	0006c583          	lbu	a1,0(a3)
    80005580:	fde1                	bnez	a1,80005558 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005582:	2785                	addiw	a5,a5,1
    80005584:	0685                	addi	a3,a3,1
    80005586:	ff879be3          	bne	a5,s8,8000557c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000558a:	57fd                	li	a5,-1
    8000558c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000558e:	02905a63          	blez	s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005592:	f9042503          	lw	a0,-112(s0)
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	d90080e7          	jalr	-624(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    8000559e:	4785                	li	a5,1
    800055a0:	0297d163          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a4:	f9442503          	lw	a0,-108(s0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	d7e080e7          	jalr	-642(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	4789                	li	a5,2
    800055b2:	0097d863          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b6:	f9842503          	lw	a0,-104(s0)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	d6c080e7          	jalr	-660(ra) # 80005326 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c2:	00018597          	auipc	a1,0x18
    800055c6:	b6658593          	addi	a1,a1,-1178 # 8001d128 <disk+0x2128>
    800055ca:	00018517          	auipc	a0,0x18
    800055ce:	a4e50513          	addi	a0,a0,-1458 # 8001d018 <disk+0x2018>
    800055d2:	ffffc097          	auipc	ra,0xffffc
    800055d6:	0fe080e7          	jalr	254(ra) # 800016d0 <sleep>
  for(int i = 0; i < 3; i++){
    800055da:	f9040713          	addi	a4,s0,-112
    800055de:	84ce                	mv	s1,s3
    800055e0:	bf41                	j	80005570 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055e2:	20058713          	addi	a4,a1,512
    800055e6:	00471693          	slli	a3,a4,0x4
    800055ea:	00016717          	auipc	a4,0x16
    800055ee:	a1670713          	addi	a4,a4,-1514 # 8001b000 <disk>
    800055f2:	9736                	add	a4,a4,a3
    800055f4:	4685                	li	a3,1
    800055f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055fa:	20058713          	addi	a4,a1,512
    800055fe:	00471693          	slli	a3,a4,0x4
    80005602:	00016717          	auipc	a4,0x16
    80005606:	9fe70713          	addi	a4,a4,-1538 # 8001b000 <disk>
    8000560a:	9736                	add	a4,a4,a3
    8000560c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005610:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005614:	7679                	lui	a2,0xffffe
    80005616:	963e                	add	a2,a2,a5
    80005618:	00018697          	auipc	a3,0x18
    8000561c:	9e868693          	addi	a3,a3,-1560 # 8001d000 <disk+0x2000>
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	6298                	ld	a4,0(a3)
    80005628:	9732                	add	a4,a4,a2
    8000562a:	4541                	li	a0,16
    8000562c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	4505                	li	a0,1
    80005634:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442703          	lw	a4,-108(s0)
    8000563c:	6288                	ld	a0,0(a3)
    8000563e:	962a                	add	a2,a2,a0
    80005640:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0712                	slli	a4,a4,0x4
    80005646:	6290                	ld	a2,0(a3)
    80005648:	963a                	add	a2,a2,a4
    8000564a:	05890513          	addi	a0,s2,88
    8000564e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6294                	ld	a3,0(a3)
    80005652:	96ba                	add	a3,a3,a4
    80005654:	40000613          	li	a2,1024
    80005658:	c690                	sw	a2,8(a3)
  if(write)
    8000565a:	140d0063          	beqz	s10,8000579a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000565e:	00018697          	auipc	a3,0x18
    80005662:	9a26b683          	ld	a3,-1630(a3) # 8001d000 <disk+0x2000>
    80005666:	96ba                	add	a3,a3,a4
    80005668:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	00016817          	auipc	a6,0x16
    80005670:	99480813          	addi	a6,a6,-1644 # 8001b000 <disk>
    80005674:	00018517          	auipc	a0,0x18
    80005678:	98c50513          	addi	a0,a0,-1652 # 8001d000 <disk+0x2000>
    8000567c:	6114                	ld	a3,0(a0)
    8000567e:	96ba                	add	a3,a3,a4
    80005680:	00c6d603          	lhu	a2,12(a3)
    80005684:	00166613          	ori	a2,a2,1
    80005688:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000568c:	f9842683          	lw	a3,-104(s0)
    80005690:	6110                	ld	a2,0(a0)
    80005692:	9732                	add	a4,a4,a2
    80005694:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005698:	20058613          	addi	a2,a1,512
    8000569c:	0612                	slli	a2,a2,0x4
    8000569e:	9642                	add	a2,a2,a6
    800056a0:	577d                	li	a4,-1
    800056a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056a6:	00469713          	slli	a4,a3,0x4
    800056aa:	6114                	ld	a3,0(a0)
    800056ac:	96ba                	add	a3,a3,a4
    800056ae:	03078793          	addi	a5,a5,48
    800056b2:	97c2                	add	a5,a5,a6
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056b6:	611c                	ld	a5,0(a0)
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	4685                	li	a3,1
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056be:	611c                	ld	a5,0(a0)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4809                	li	a6,2
    800056c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056c8:	611c                	ld	a5,0(a0)
    800056ca:	973e                	add	a4,a4,a5
    800056cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d8:	6518                	ld	a4,8(a0)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	8b9d                	andi	a5,a5,7
    800056e0:	0786                	slli	a5,a5,0x1
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ec:	6518                	ld	a4,8(a0)
    800056ee:	00275783          	lhu	a5,2(a4)
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005704:	00492703          	lw	a4,4(s2)
    80005708:	4785                	li	a5,1
    8000570a:	02f71163          	bne	a4,a5,8000572c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000570e:	00018997          	auipc	s3,0x18
    80005712:	a1a98993          	addi	s3,s3,-1510 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005716:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005718:	85ce                	mv	a1,s3
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	fb4080e7          	jalr	-76(ra) # 800016d0 <sleep>
  while(b->disk == 1) {
    80005724:	00492783          	lw	a5,4(s2)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	20090793          	addi	a5,s2,512
    80005734:	00479713          	slli	a4,a5,0x4
    80005738:	00016797          	auipc	a5,0x16
    8000573c:	8c878793          	addi	a5,a5,-1848 # 8001b000 <disk>
    80005740:	97ba                	add	a5,a5,a4
    80005742:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005746:	00018997          	auipc	s3,0x18
    8000574a:	8ba98993          	addi	s3,s3,-1862 # 8001d000 <disk+0x2000>
    8000574e:	00491713          	slli	a4,s2,0x4
    80005752:	0009b783          	ld	a5,0(s3)
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575c:	854a                	mv	a0,s2
    8000575e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	bc4080e7          	jalr	-1084(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0ed                	bnez	s1,8000574e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	00018517          	auipc	a0,0x18
    80005772:	9ba50513          	addi	a0,a0,-1606 # 8001d128 <disk+0x2128>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	c50080e7          	jalr	-944(ra) # 800063c6 <release>
}
    8000577e:	70a6                	ld	ra,104(sp)
    80005780:	7406                	ld	s0,96(sp)
    80005782:	64e6                	ld	s1,88(sp)
    80005784:	6946                	ld	s2,80(sp)
    80005786:	69a6                	ld	s3,72(sp)
    80005788:	6a06                	ld	s4,64(sp)
    8000578a:	7ae2                	ld	s5,56(sp)
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	6165                	addi	sp,sp,112
    80005798:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579a:	00018697          	auipc	a3,0x18
    8000579e:	8666b683          	ld	a3,-1946(a3) # 8001d000 <disk+0x2000>
    800057a2:	96ba                	add	a3,a3,a4
    800057a4:	4609                	li	a2,2
    800057a6:	00c69623          	sh	a2,12(a3)
    800057aa:	b5c9                	j	8000566c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ac:	f9042583          	lw	a1,-112(s0)
    800057b0:	20058793          	addi	a5,a1,512
    800057b4:	0792                	slli	a5,a5,0x4
    800057b6:	00016517          	auipc	a0,0x16
    800057ba:	8f250513          	addi	a0,a0,-1806 # 8001b0a8 <disk+0xa8>
    800057be:	953e                	add	a0,a0,a5
  if(write)
    800057c0:	e20d11e3          	bnez	s10,800055e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057c4:	20058713          	addi	a4,a1,512
    800057c8:	00471693          	slli	a3,a4,0x4
    800057cc:	00016717          	auipc	a4,0x16
    800057d0:	83470713          	addi	a4,a4,-1996 # 8001b000 <disk>
    800057d4:	9736                	add	a4,a4,a3
    800057d6:	0a072423          	sw	zero,168(a4)
    800057da:	b505                	j	800055fa <virtio_disk_rw+0xf4>

00000000800057dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	e04a                	sd	s2,0(sp)
    800057e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e8:	00018517          	auipc	a0,0x18
    800057ec:	94050513          	addi	a0,a0,-1728 # 8001d128 <disk+0x2128>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	b22080e7          	jalr	-1246(ra) # 80006312 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f8:	10001737          	lui	a4,0x10001
    800057fc:	533c                	lw	a5,96(a4)
    800057fe:	8b8d                	andi	a5,a5,3
    80005800:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005806:	00017797          	auipc	a5,0x17
    8000580a:	7fa78793          	addi	a5,a5,2042 # 8001d000 <disk+0x2000>
    8000580e:	6b94                	ld	a3,16(a5)
    80005810:	0207d703          	lhu	a4,32(a5)
    80005814:	0026d783          	lhu	a5,2(a3)
    80005818:	06f70163          	beq	a4,a5,8000587a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000581c:	00015917          	auipc	s2,0x15
    80005820:	7e490913          	addi	s2,s2,2020 # 8001b000 <disk>
    80005824:	00017497          	auipc	s1,0x17
    80005828:	7dc48493          	addi	s1,s1,2012 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000582c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005830:	6898                	ld	a4,16(s1)
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	8b9d                	andi	a5,a5,7
    80005838:	078e                	slli	a5,a5,0x3
    8000583a:	97ba                	add	a5,a5,a4
    8000583c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583e:	20078713          	addi	a4,a5,512
    80005842:	0712                	slli	a4,a4,0x4
    80005844:	974a                	add	a4,a4,s2
    80005846:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000584a:	e731                	bnez	a4,80005896 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000584c:	20078793          	addi	a5,a5,512
    80005850:	0792                	slli	a5,a5,0x4
    80005852:	97ca                	add	a5,a5,s2
    80005854:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005856:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	002080e7          	jalr	2(ra) # 8000185c <wakeup>

    disk.used_idx += 1;
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	17c2                	slli	a5,a5,0x30
    8000586a:	93c1                	srli	a5,a5,0x30
    8000586c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005870:	6898                	ld	a4,16(s1)
    80005872:	00275703          	lhu	a4,2(a4)
    80005876:	faf71be3          	bne	a4,a5,8000582c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000587a:	00018517          	auipc	a0,0x18
    8000587e:	8ae50513          	addi	a0,a0,-1874 # 8001d128 <disk+0x2128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	b44080e7          	jalr	-1212(ra) # 800063c6 <release>
}
    8000588a:	60e2                	ld	ra,24(sp)
    8000588c:	6442                	ld	s0,16(sp)
    8000588e:	64a2                	ld	s1,8(sp)
    80005890:	6902                	ld	s2,0(sp)
    80005892:	6105                	addi	sp,sp,32
    80005894:	8082                	ret
      panic("virtio_disk_intr status");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	fb250513          	addi	a0,a0,-78 # 80008848 <syscalls+0x3f0>
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	52a080e7          	jalr	1322(ra) # 80005dc8 <panic>

00000000800058a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a6:	1141                	addi	sp,sp,-16
    800058a8:	e422                	sd	s0,8(sp)
    800058aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b4:	0037979b          	slliw	a5,a5,0x3
    800058b8:	02004737          	lui	a4,0x2004
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0200c737          	lui	a4,0x200c
    800058c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c6:	000f4637          	lui	a2,0xf4
    800058ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ce:	95b2                	add	a1,a1,a2
    800058d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d2:	00269713          	slli	a4,a3,0x2
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00371693          	slli	a3,a4,0x3
    800058dc:	00018717          	auipc	a4,0x18
    800058e0:	72470713          	addi	a4,a4,1828 # 8001e000 <timer_scratch>
    800058e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ee:	00000797          	auipc	a5,0x0
    800058f2:	97278793          	addi	a5,a5,-1678 # 80005260 <timervec>
    800058f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005902:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005906:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000590e:	30479073          	csrw	mie,a5
}
    80005912:	6422                	ld	s0,8(sp)
    80005914:	0141                	addi	sp,sp,16
    80005916:	8082                	ret

0000000080005918 <start>:
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e406                	sd	ra,8(sp)
    8000591c:	e022                	sd	s0,0(sp)
    8000591e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005920:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005924:	7779                	lui	a4,0xffffe
    80005926:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000592a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000592c:	6705                	lui	a4,0x1
    8000592e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005932:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005934:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005938:	ffffb797          	auipc	a5,0xffffb
    8000593c:	9ee78793          	addi	a5,a5,-1554 # 80000326 <main>
    80005940:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005944:	4781                	li	a5,0
    80005946:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594a:	67c1                	lui	a5,0x10
    8000594c:	17fd                	addi	a5,a5,-1
    8000594e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005952:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005956:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000595e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005962:	57fd                	li	a5,-1
    80005964:	83a9                	srli	a5,a5,0xa
    80005966:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596a:	47bd                	li	a5,15
    8000596c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005970:	00000097          	auipc	ra,0x0
    80005974:	f36080e7          	jalr	-202(ra) # 800058a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005978:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000597c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000597e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005980:	30200073          	mret
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret

000000008000598c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000598c:	715d                	addi	sp,sp,-80
    8000598e:	e486                	sd	ra,72(sp)
    80005990:	e0a2                	sd	s0,64(sp)
    80005992:	fc26                	sd	s1,56(sp)
    80005994:	f84a                	sd	s2,48(sp)
    80005996:	f44e                	sd	s3,40(sp)
    80005998:	f052                	sd	s4,32(sp)
    8000599a:	ec56                	sd	s5,24(sp)
    8000599c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000599e:	04c05663          	blez	a2,800059ea <consolewrite+0x5e>
    800059a2:	8a2a                	mv	s4,a0
    800059a4:	84ae                	mv	s1,a1
    800059a6:	89b2                	mv	s3,a2
    800059a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059aa:	5afd                	li	s5,-1
    800059ac:	4685                	li	a3,1
    800059ae:	8626                	mv	a2,s1
    800059b0:	85d2                	mv	a1,s4
    800059b2:	fbf40513          	addi	a0,s0,-65
    800059b6:	ffffc097          	auipc	ra,0xffffc
    800059ba:	114080e7          	jalr	276(ra) # 80001aca <either_copyin>
    800059be:	01550c63          	beq	a0,s5,800059d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c2:	fbf44503          	lbu	a0,-65(s0)
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	78e080e7          	jalr	1934(ra) # 80006154 <uartputc>
  for(i = 0; i < n; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0485                	addi	s1,s1,1
    800059d2:	fd299de3          	bne	s3,s2,800059ac <consolewrite+0x20>
  }

  return i;
}
    800059d6:	854a                	mv	a0,s2
    800059d8:	60a6                	ld	ra,72(sp)
    800059da:	6406                	ld	s0,64(sp)
    800059dc:	74e2                	ld	s1,56(sp)
    800059de:	7942                	ld	s2,48(sp)
    800059e0:	79a2                	ld	s3,40(sp)
    800059e2:	7a02                	ld	s4,32(sp)
    800059e4:	6ae2                	ld	s5,24(sp)
    800059e6:	6161                	addi	sp,sp,80
    800059e8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ea:	4901                	li	s2,0
    800059ec:	b7ed                	j	800059d6 <consolewrite+0x4a>

00000000800059ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ee:	7119                	addi	sp,sp,-128
    800059f0:	fc86                	sd	ra,120(sp)
    800059f2:	f8a2                	sd	s0,112(sp)
    800059f4:	f4a6                	sd	s1,104(sp)
    800059f6:	f0ca                	sd	s2,96(sp)
    800059f8:	ecce                	sd	s3,88(sp)
    800059fa:	e8d2                	sd	s4,80(sp)
    800059fc:	e4d6                	sd	s5,72(sp)
    800059fe:	e0da                	sd	s6,64(sp)
    80005a00:	fc5e                	sd	s7,56(sp)
    80005a02:	f862                	sd	s8,48(sp)
    80005a04:	f466                	sd	s9,40(sp)
    80005a06:	f06a                	sd	s10,32(sp)
    80005a08:	ec6e                	sd	s11,24(sp)
    80005a0a:	0100                	addi	s0,sp,128
    80005a0c:	8b2a                	mv	s6,a0
    80005a0e:	8aae                	mv	s5,a1
    80005a10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a16:	00020517          	auipc	a0,0x20
    80005a1a:	72a50513          	addi	a0,a0,1834 # 80026140 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	8f4080e7          	jalr	-1804(ra) # 80006312 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a26:	00020497          	auipc	s1,0x20
    80005a2a:	71a48493          	addi	s1,s1,1818 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a2e:	89a6                	mv	s3,s1
    80005a30:	00020917          	auipc	s2,0x20
    80005a34:	7a890913          	addi	s2,s2,1960 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a3c:	4da9                	li	s11,10
  while(n > 0){
    80005a3e:	07405863          	blez	s4,80005aae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71463          	bne	a4,a5,80005a72 <consoleread+0x84>
      if(myproc()->killed){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	518080e7          	jalr	1304(ra) # 80000f66 <myproc>
    80005a56:	551c                	lw	a5,40(a0)
    80005a58:	e7b5                	bnez	a5,80005ac4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a5a:	85ce                	mv	a1,s3
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	c72080e7          	jalr	-910(ra) # 800016d0 <sleep>
    while(cons.r == cons.w){
    80005a66:	0984a783          	lw	a5,152(s1)
    80005a6a:	09c4a703          	lw	a4,156(s1)
    80005a6e:	fef700e3          	beq	a4,a5,80005a4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a72:	0017871b          	addiw	a4,a5,1
    80005a76:	08e4ac23          	sw	a4,152(s1)
    80005a7a:	07f7f713          	andi	a4,a5,127
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01874703          	lbu	a4,24(a4)
    80005a84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a88:	079c0663          	beq	s8,s9,80005af4 <consoleread+0x106>
    cbuf = c;
    80005a8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a90:	4685                	li	a3,1
    80005a92:	f8f40613          	addi	a2,s0,-113
    80005a96:	85d6                	mv	a1,s5
    80005a98:	855a                	mv	a0,s6
    80005a9a:	ffffc097          	auipc	ra,0xffffc
    80005a9e:	fda080e7          	jalr	-38(ra) # 80001a74 <either_copyout>
    80005aa2:	01a50663          	beq	a0,s10,80005aae <consoleread+0xc0>
    dst++;
    80005aa6:	0a85                	addi	s5,s5,1
    --n;
    80005aa8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aaa:	f9bc1ae3          	bne	s8,s11,80005a3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aae:	00020517          	auipc	a0,0x20
    80005ab2:	69250513          	addi	a0,a0,1682 # 80026140 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	910080e7          	jalr	-1776(ra) # 800063c6 <release>

  return target - n;
    80005abe:	414b853b          	subw	a0,s7,s4
    80005ac2:	a811                	j	80005ad6 <consoleread+0xe8>
        release(&cons.lock);
    80005ac4:	00020517          	auipc	a0,0x20
    80005ac8:	67c50513          	addi	a0,a0,1660 # 80026140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	8fa080e7          	jalr	-1798(ra) # 800063c6 <release>
        return -1;
    80005ad4:	557d                	li	a0,-1
}
    80005ad6:	70e6                	ld	ra,120(sp)
    80005ad8:	7446                	ld	s0,112(sp)
    80005ada:	74a6                	ld	s1,104(sp)
    80005adc:	7906                	ld	s2,96(sp)
    80005ade:	69e6                	ld	s3,88(sp)
    80005ae0:	6a46                	ld	s4,80(sp)
    80005ae2:	6aa6                	ld	s5,72(sp)
    80005ae4:	6b06                	ld	s6,64(sp)
    80005ae6:	7be2                	ld	s7,56(sp)
    80005ae8:	7c42                	ld	s8,48(sp)
    80005aea:	7ca2                	ld	s9,40(sp)
    80005aec:	7d02                	ld	s10,32(sp)
    80005aee:	6de2                	ld	s11,24(sp)
    80005af0:	6109                	addi	sp,sp,128
    80005af2:	8082                	ret
      if(n < target){
    80005af4:	000a071b          	sext.w	a4,s4
    80005af8:	fb777be3          	bgeu	a4,s7,80005aae <consoleread+0xc0>
        cons.r--;
    80005afc:	00020717          	auipc	a4,0x20
    80005b00:	6cf72e23          	sw	a5,1756(a4) # 800261d8 <cons+0x98>
    80005b04:	b76d                	j	80005aae <consoleread+0xc0>

0000000080005b06 <consputc>:
{
    80005b06:	1141                	addi	sp,sp,-16
    80005b08:	e406                	sd	ra,8(sp)
    80005b0a:	e022                	sd	s0,0(sp)
    80005b0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b0e:	10000793          	li	a5,256
    80005b12:	00f50a63          	beq	a0,a5,80005b26 <consputc+0x20>
    uartputc_sync(c);
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	564080e7          	jalr	1380(ra) # 8000607a <uartputc_sync>
}
    80005b1e:	60a2                	ld	ra,8(sp)
    80005b20:	6402                	ld	s0,0(sp)
    80005b22:	0141                	addi	sp,sp,16
    80005b24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	552080e7          	jalr	1362(ra) # 8000607a <uartputc_sync>
    80005b30:	02000513          	li	a0,32
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	546080e7          	jalr	1350(ra) # 8000607a <uartputc_sync>
    80005b3c:	4521                	li	a0,8
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	53c080e7          	jalr	1340(ra) # 8000607a <uartputc_sync>
    80005b46:	bfe1                	j	80005b1e <consputc+0x18>

0000000080005b48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b48:	1101                	addi	sp,sp,-32
    80005b4a:	ec06                	sd	ra,24(sp)
    80005b4c:	e822                	sd	s0,16(sp)
    80005b4e:	e426                	sd	s1,8(sp)
    80005b50:	e04a                	sd	s2,0(sp)
    80005b52:	1000                	addi	s0,sp,32
    80005b54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b56:	00020517          	auipc	a0,0x20
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 80026140 <cons>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	7b4080e7          	jalr	1972(ra) # 80006312 <acquire>

  switch(c){
    80005b66:	47d5                	li	a5,21
    80005b68:	0af48663          	beq	s1,a5,80005c14 <consoleintr+0xcc>
    80005b6c:	0297ca63          	blt	a5,s1,80005ba0 <consoleintr+0x58>
    80005b70:	47a1                	li	a5,8
    80005b72:	0ef48763          	beq	s1,a5,80005c60 <consoleintr+0x118>
    80005b76:	47c1                	li	a5,16
    80005b78:	10f49a63          	bne	s1,a5,80005c8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	fa4080e7          	jalr	-92(ra) # 80001b20 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b84:	00020517          	auipc	a0,0x20
    80005b88:	5bc50513          	addi	a0,a0,1468 # 80026140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	83a080e7          	jalr	-1990(ra) # 800063c6 <release>
}
    80005b94:	60e2                	ld	ra,24(sp)
    80005b96:	6442                	ld	s0,16(sp)
    80005b98:	64a2                	ld	s1,8(sp)
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	6105                	addi	sp,sp,32
    80005b9e:	8082                	ret
  switch(c){
    80005ba0:	07f00793          	li	a5,127
    80005ba4:	0af48e63          	beq	s1,a5,80005c60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ba8:	00020717          	auipc	a4,0x20
    80005bac:	59870713          	addi	a4,a4,1432 # 80026140 <cons>
    80005bb0:	0a072783          	lw	a5,160(a4)
    80005bb4:	09872703          	lw	a4,152(a4)
    80005bb8:	9f99                	subw	a5,a5,a4
    80005bba:	07f00713          	li	a4,127
    80005bbe:	fcf763e3          	bltu	a4,a5,80005b84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bc2:	47b5                	li	a5,13
    80005bc4:	0cf48763          	beq	s1,a5,80005c92 <consoleintr+0x14a>
      consputc(c);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	f3c080e7          	jalr	-196(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd2:	00020797          	auipc	a5,0x20
    80005bd6:	56e78793          	addi	a5,a5,1390 # 80026140 <cons>
    80005bda:	0a07a703          	lw	a4,160(a5)
    80005bde:	0017069b          	addiw	a3,a4,1
    80005be2:	0006861b          	sext.w	a2,a3
    80005be6:	0ad7a023          	sw	a3,160(a5)
    80005bea:	07f77713          	andi	a4,a4,127
    80005bee:	97ba                	add	a5,a5,a4
    80005bf0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bf4:	47a9                	li	a5,10
    80005bf6:	0cf48563          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005bfa:	4791                	li	a5,4
    80005bfc:	0cf48263          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005c00:	00020797          	auipc	a5,0x20
    80005c04:	5d87a783          	lw	a5,1496(a5) # 800261d8 <cons+0x98>
    80005c08:	0807879b          	addiw	a5,a5,128
    80005c0c:	f6f61ce3          	bne	a2,a5,80005b84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c10:	863e                	mv	a2,a5
    80005c12:	a07d                	j	80005cc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c14:	00020717          	auipc	a4,0x20
    80005c18:	52c70713          	addi	a4,a4,1324 # 80026140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c24:	00020497          	auipc	s1,0x20
    80005c28:	51c48493          	addi	s1,s1,1308 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c2c:	4929                	li	s2,10
    80005c2e:	f4f70be3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c32:	37fd                	addiw	a5,a5,-1
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	f52703e3          	beq	a4,s2,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	ebc080e7          	jalr	-324(ra) # 80005b06 <consputc>
    while(cons.e != cons.w &&
    80005c52:	0a04a783          	lw	a5,160(s1)
    80005c56:	09c4a703          	lw	a4,156(s1)
    80005c5a:	fcf71ce3          	bne	a4,a5,80005c32 <consoleintr+0xea>
    80005c5e:	b71d                	j	80005b84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c60:	00020717          	auipc	a4,0x20
    80005c64:	4e070713          	addi	a4,a4,1248 # 80026140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09c72703          	lw	a4,156(a4)
    80005c70:	f0f70ae3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	00020717          	auipc	a4,0x20
    80005c7a:	56f72523          	sw	a5,1386(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c7e:	10000513          	li	a0,256
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	e84080e7          	jalr	-380(ra) # 80005b06 <consputc>
    80005c8a:	bded                	j	80005b84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8c:	ee048ce3          	beqz	s1,80005b84 <consoleintr+0x3c>
    80005c90:	bf21                	j	80005ba8 <consoleintr+0x60>
      consputc(c);
    80005c92:	4529                	li	a0,10
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	e72080e7          	jalr	-398(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c9c:	00020797          	auipc	a5,0x20
    80005ca0:	4a478793          	addi	a5,a5,1188 # 80026140 <cons>
    80005ca4:	0a07a703          	lw	a4,160(a5)
    80005ca8:	0017069b          	addiw	a3,a4,1
    80005cac:	0006861b          	sext.w	a2,a3
    80005cb0:	0ad7a023          	sw	a3,160(a5)
    80005cb4:	07f77713          	andi	a4,a4,127
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	4729                	li	a4,10
    80005cbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cc0:	00020797          	auipc	a5,0x20
    80005cc4:	50c7ae23          	sw	a2,1308(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cc8:	00020517          	auipc	a0,0x20
    80005ccc:	51050513          	addi	a0,a0,1296 # 800261d8 <cons+0x98>
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	b8c080e7          	jalr	-1140(ra) # 8000185c <wakeup>
    80005cd8:	b575                	j	80005b84 <consoleintr+0x3c>

0000000080005cda <consoleinit>:

void
consoleinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	b7e58593          	addi	a1,a1,-1154 # 80008860 <syscalls+0x408>
    80005cea:	00020517          	auipc	a0,0x20
    80005cee:	45650513          	addi	a0,a0,1110 # 80026140 <cons>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	590080e7          	jalr	1424(ra) # 80006282 <initlock>

  uartinit();
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	330080e7          	jalr	816(ra) # 8000602a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d02:	00013797          	auipc	a5,0x13
    80005d06:	5c678793          	addi	a5,a5,1478 # 800192c8 <devsw>
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	ce470713          	addi	a4,a4,-796 # 800059ee <consoleread>
    80005d12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	c7870713          	addi	a4,a4,-904 # 8000598c <consolewrite>
    80005d1c:	ef98                	sd	a4,24(a5)
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d26:	7179                	addi	sp,sp,-48
    80005d28:	f406                	sd	ra,40(sp)
    80005d2a:	f022                	sd	s0,32(sp)
    80005d2c:	ec26                	sd	s1,24(sp)
    80005d2e:	e84a                	sd	s2,16(sp)
    80005d30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d32:	c219                	beqz	a2,80005d38 <printint+0x12>
    80005d34:	08054663          	bltz	a0,80005dc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d38:	2501                	sext.w	a0,a0
    80005d3a:	4881                	li	a7,0
    80005d3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d42:	2581                	sext.w	a1,a1
    80005d44:	00003617          	auipc	a2,0x3
    80005d48:	b4c60613          	addi	a2,a2,-1204 # 80008890 <digits>
    80005d4c:	883a                	mv	a6,a4
    80005d4e:	2705                	addiw	a4,a4,1
    80005d50:	02b577bb          	remuw	a5,a0,a1
    80005d54:	1782                	slli	a5,a5,0x20
    80005d56:	9381                	srli	a5,a5,0x20
    80005d58:	97b2                	add	a5,a5,a2
    80005d5a:	0007c783          	lbu	a5,0(a5)
    80005d5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d62:	0005079b          	sext.w	a5,a0
    80005d66:	02b5553b          	divuw	a0,a0,a1
    80005d6a:	0685                	addi	a3,a3,1
    80005d6c:	feb7f0e3          	bgeu	a5,a1,80005d4c <printint+0x26>

  if(sign)
    80005d70:	00088b63          	beqz	a7,80005d86 <printint+0x60>
    buf[i++] = '-';
    80005d74:	fe040793          	addi	a5,s0,-32
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	02d00793          	li	a5,45
    80005d7e:	fef70823          	sb	a5,-16(a4)
    80005d82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d86:	02e05763          	blez	a4,80005db4 <printint+0x8e>
    80005d8a:	fd040793          	addi	a5,s0,-48
    80005d8e:	00e784b3          	add	s1,a5,a4
    80005d92:	fff78913          	addi	s2,a5,-1
    80005d96:	993a                	add	s2,s2,a4
    80005d98:	377d                	addiw	a4,a4,-1
    80005d9a:	1702                	slli	a4,a4,0x20
    80005d9c:	9301                	srli	a4,a4,0x20
    80005d9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005da2:	fff4c503          	lbu	a0,-1(s1)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	d60080e7          	jalr	-672(ra) # 80005b06 <consputc>
  while(--i >= 0)
    80005dae:	14fd                	addi	s1,s1,-1
    80005db0:	ff2499e3          	bne	s1,s2,80005da2 <printint+0x7c>
}
    80005db4:	70a2                	ld	ra,40(sp)
    80005db6:	7402                	ld	s0,32(sp)
    80005db8:	64e2                	ld	s1,24(sp)
    80005dba:	6942                	ld	s2,16(sp)
    80005dbc:	6145                	addi	sp,sp,48
    80005dbe:	8082                	ret
    x = -xx;
    80005dc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dc4:	4885                	li	a7,1
    x = -xx;
    80005dc6:	bf9d                	j	80005d3c <printint+0x16>

0000000080005dc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
    80005dd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dd4:	00020797          	auipc	a5,0x20
    80005dd8:	4207a623          	sw	zero,1068(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005ddc:	00003517          	auipc	a0,0x3
    80005de0:	a8c50513          	addi	a0,a0,-1396 # 80008868 <syscalls+0x410>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	02e080e7          	jalr	46(ra) # 80005e12 <printf>
  printf(s);
    80005dec:	8526                	mv	a0,s1
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	024080e7          	jalr	36(ra) # 80005e12 <printf>
  printf("\n");
    80005df6:	00002517          	auipc	a0,0x2
    80005dfa:	25250513          	addi	a0,a0,594 # 80008048 <etext+0x48>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e06:	4785                	li	a5,1
    80005e08:	00003717          	auipc	a4,0x3
    80005e0c:	20f72a23          	sw	a5,532(a4) # 8000901c <panicked>
  for(;;)
    80005e10:	a001                	j	80005e10 <panic+0x48>

0000000080005e12 <printf>:
{
    80005e12:	7131                	addi	sp,sp,-192
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	e40c                	sd	a1,8(s0)
    80005e34:	e810                	sd	a2,16(s0)
    80005e36:	ec14                	sd	a3,24(s0)
    80005e38:	f018                	sd	a4,32(s0)
    80005e3a:	f41c                	sd	a5,40(s0)
    80005e3c:	03043823          	sd	a6,48(s0)
    80005e40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e44:	00020d97          	auipc	s11,0x20
    80005e48:	3bcdad83          	lw	s11,956(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e4c:	020d9b63          	bnez	s11,80005e82 <printf+0x70>
  if (fmt == 0)
    80005e50:	040a0263          	beqz	s4,80005e94 <printf+0x82>
  va_start(ap, fmt);
    80005e54:	00840793          	addi	a5,s0,8
    80005e58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	000a4503          	lbu	a0,0(s4)
    80005e60:	16050263          	beqz	a0,80005fc4 <printf+0x1b2>
    80005e64:	4481                	li	s1,0
    if(c != '%'){
    80005e66:	02500a93          	li	s5,37
    switch(c){
    80005e6a:	07000b13          	li	s6,112
  consputc('x');
    80005e6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e70:	00003b97          	auipc	s7,0x3
    80005e74:	a20b8b93          	addi	s7,s7,-1504 # 80008890 <digits>
    switch(c){
    80005e78:	07300c93          	li	s9,115
    80005e7c:	06400c13          	li	s8,100
    80005e80:	a82d                	j	80005eba <printf+0xa8>
    acquire(&pr.lock);
    80005e82:	00020517          	auipc	a0,0x20
    80005e86:	36650513          	addi	a0,a0,870 # 800261e8 <pr>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	488080e7          	jalr	1160(ra) # 80006312 <acquire>
    80005e92:	bf7d                	j	80005e50 <printf+0x3e>
    panic("null fmt");
    80005e94:	00003517          	auipc	a0,0x3
    80005e98:	9e450513          	addi	a0,a0,-1564 # 80008878 <syscalls+0x420>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	f2c080e7          	jalr	-212(ra) # 80005dc8 <panic>
      consputc(c);
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	c62080e7          	jalr	-926(ra) # 80005b06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	2485                	addiw	s1,s1,1
    80005eae:	009a07b3          	add	a5,s4,s1
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	10050763          	beqz	a0,80005fc4 <printf+0x1b2>
    if(c != '%'){
    80005eba:	ff5515e3          	bne	a0,s5,80005ea4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ebe:	2485                	addiw	s1,s1,1
    80005ec0:	009a07b3          	add	a5,s4,s1
    80005ec4:	0007c783          	lbu	a5,0(a5)
    80005ec8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ecc:	cfe5                	beqz	a5,80005fc4 <printf+0x1b2>
    switch(c){
    80005ece:	05678a63          	beq	a5,s6,80005f22 <printf+0x110>
    80005ed2:	02fb7663          	bgeu	s6,a5,80005efe <printf+0xec>
    80005ed6:	09978963          	beq	a5,s9,80005f68 <printf+0x156>
    80005eda:	07800713          	li	a4,120
    80005ede:	0ce79863          	bne	a5,a4,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	4605                	li	a2,1
    80005ef0:	85ea                	mv	a1,s10
    80005ef2:	4388                	lw	a0,0(a5)
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e32080e7          	jalr	-462(ra) # 80005d26 <printint>
      break;
    80005efc:	bf45                	j	80005eac <printf+0x9a>
    switch(c){
    80005efe:	0b578263          	beq	a5,s5,80005fa2 <printf+0x190>
    80005f02:	0b879663          	bne	a5,s8,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f06:	f8843783          	ld	a5,-120(s0)
    80005f0a:	00878713          	addi	a4,a5,8
    80005f0e:	f8e43423          	sd	a4,-120(s0)
    80005f12:	4605                	li	a2,1
    80005f14:	45a9                	li	a1,10
    80005f16:	4388                	lw	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	e0e080e7          	jalr	-498(ra) # 80005d26 <printint>
      break;
    80005f20:	b771                	j	80005eac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f32:	03000513          	li	a0,48
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bd0080e7          	jalr	-1072(ra) # 80005b06 <consputc>
  consputc('x');
    80005f3e:	07800513          	li	a0,120
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bc4080e7          	jalr	-1084(ra) # 80005b06 <consputc>
    80005f4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4c:	03c9d793          	srli	a5,s3,0x3c
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0007c503          	lbu	a0,0(a5)
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	bb0080e7          	jalr	-1104(ra) # 80005b06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f5e:	0992                	slli	s3,s3,0x4
    80005f60:	397d                	addiw	s2,s2,-1
    80005f62:	fe0915e3          	bnez	s2,80005f4c <printf+0x13a>
    80005f66:	b799                	j	80005eac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
    80005f78:	00090e63          	beqz	s2,80005f94 <printf+0x182>
      for(; *s; s++)
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	d515                	beqz	a0,80005eac <printf+0x9a>
        consputc(*s);
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b84080e7          	jalr	-1148(ra) # 80005b06 <consputc>
      for(; *s; s++)
    80005f8a:	0905                	addi	s2,s2,1
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	f96d                	bnez	a0,80005f82 <printf+0x170>
    80005f92:	bf29                	j	80005eac <printf+0x9a>
        s = "(null)";
    80005f94:	00003917          	auipc	s2,0x3
    80005f98:	8dc90913          	addi	s2,s2,-1828 # 80008870 <syscalls+0x418>
      for(; *s; s++)
    80005f9c:	02800513          	li	a0,40
    80005fa0:	b7cd                	j	80005f82 <printf+0x170>
      consputc('%');
    80005fa2:	8556                	mv	a0,s5
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b62080e7          	jalr	-1182(ra) # 80005b06 <consputc>
      break;
    80005fac:	b701                	j	80005eac <printf+0x9a>
      consputc('%');
    80005fae:	8556                	mv	a0,s5
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b56080e7          	jalr	-1194(ra) # 80005b06 <consputc>
      consputc(c);
    80005fb8:	854a                	mv	a0,s2
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b4c080e7          	jalr	-1204(ra) # 80005b06 <consputc>
      break;
    80005fc2:	b5ed                	j	80005eac <printf+0x9a>
  if(locking)
    80005fc4:	020d9163          	bnez	s11,80005fe6 <printf+0x1d4>
}
    80005fc8:	70e6                	ld	ra,120(sp)
    80005fca:	7446                	ld	s0,112(sp)
    80005fcc:	74a6                	ld	s1,104(sp)
    80005fce:	7906                	ld	s2,96(sp)
    80005fd0:	69e6                	ld	s3,88(sp)
    80005fd2:	6a46                	ld	s4,80(sp)
    80005fd4:	6aa6                	ld	s5,72(sp)
    80005fd6:	6b06                	ld	s6,64(sp)
    80005fd8:	7be2                	ld	s7,56(sp)
    80005fda:	7c42                	ld	s8,48(sp)
    80005fdc:	7ca2                	ld	s9,40(sp)
    80005fde:	7d02                	ld	s10,32(sp)
    80005fe0:	6de2                	ld	s11,24(sp)
    80005fe2:	6129                	addi	sp,sp,192
    80005fe4:	8082                	ret
    release(&pr.lock);
    80005fe6:	00020517          	auipc	a0,0x20
    80005fea:	20250513          	addi	a0,a0,514 # 800261e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	3d8080e7          	jalr	984(ra) # 800063c6 <release>
}
    80005ff6:	bfc9                	j	80005fc8 <printf+0x1b6>

0000000080005ff8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ff8:	1101                	addi	sp,sp,-32
    80005ffa:	ec06                	sd	ra,24(sp)
    80005ffc:	e822                	sd	s0,16(sp)
    80005ffe:	e426                	sd	s1,8(sp)
    80006000:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006002:	00020497          	auipc	s1,0x20
    80006006:	1e648493          	addi	s1,s1,486 # 800261e8 <pr>
    8000600a:	00003597          	auipc	a1,0x3
    8000600e:	87e58593          	addi	a1,a1,-1922 # 80008888 <syscalls+0x430>
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	26e080e7          	jalr	622(ra) # 80006282 <initlock>
  pr.locking = 1;
    8000601c:	4785                	li	a5,1
    8000601e:	cc9c                	sw	a5,24(s1)
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006032:	100007b7          	lui	a5,0x10000
    80006036:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000603a:	f8000713          	li	a4,-128
    8000603e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006042:	470d                	li	a4,3
    80006044:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006048:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000604c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006050:	469d                	li	a3,7
    80006052:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006056:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000605a:	00003597          	auipc	a1,0x3
    8000605e:	84e58593          	addi	a1,a1,-1970 # 800088a8 <digits+0x18>
    80006062:	00020517          	auipc	a0,0x20
    80006066:	1a650513          	addi	a0,a0,422 # 80026208 <uart_tx_lock>
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	218080e7          	jalr	536(ra) # 80006282 <initlock>
}
    80006072:	60a2                	ld	ra,8(sp)
    80006074:	6402                	ld	s0,0(sp)
    80006076:	0141                	addi	sp,sp,16
    80006078:	8082                	ret

000000008000607a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
    80006084:	84aa                	mv	s1,a0
  push_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	240080e7          	jalr	576(ra) # 800062c6 <push_off>

  if(panicked){
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	f8e7a783          	lw	a5,-114(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006096:	10000737          	lui	a4,0x10000
  if(panicked){
    8000609a:	c391                	beqz	a5,8000609e <uartputc_sync+0x24>
    for(;;)
    8000609c:	a001                	j	8000609c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060a2:	0ff7f793          	andi	a5,a5,255
    800060a6:	0207f793          	andi	a5,a5,32
    800060aa:	dbf5                	beqz	a5,8000609e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ac:	0ff4f793          	andi	a5,s1,255
    800060b0:	10000737          	lui	a4,0x10000
    800060b4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	2ae080e7          	jalr	686(ra) # 80006366 <pop_off>
}
    800060c0:	60e2                	ld	ra,24(sp)
    800060c2:	6442                	ld	s0,16(sp)
    800060c4:	64a2                	ld	s1,8(sp)
    800060c6:	6105                	addi	sp,sp,32
    800060c8:	8082                	ret

00000000800060ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ca:	00003717          	auipc	a4,0x3
    800060ce:	f5673703          	ld	a4,-170(a4) # 80009020 <uart_tx_r>
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	06e78c63          	beq	a5,a4,80006152 <uartstart+0x88>
{
    800060de:	7139                	addi	sp,sp,-64
    800060e0:	fc06                	sd	ra,56(sp)
    800060e2:	f822                	sd	s0,48(sp)
    800060e4:	f426                	sd	s1,40(sp)
    800060e6:	f04a                	sd	s2,32(sp)
    800060e8:	ec4e                	sd	s3,24(sp)
    800060ea:	e852                	sd	s4,16(sp)
    800060ec:	e456                	sd	s5,8(sp)
    800060ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f4:	00020a17          	auipc	s4,0x20
    800060f8:	114a0a13          	addi	s4,s4,276 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060fc:	00003497          	auipc	s1,0x3
    80006100:	f2448493          	addi	s1,s1,-220 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006104:	00003997          	auipc	s3,0x3
    80006108:	f2498993          	addi	s3,s3,-220 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006110:	0ff7f793          	andi	a5,a5,255
    80006114:	0207f793          	andi	a5,a5,32
    80006118:	c785                	beqz	a5,80006140 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611a:	01f77793          	andi	a5,a4,31
    8000611e:	97d2                	add	a5,a5,s4
    80006120:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006124:	0705                	addi	a4,a4,1
    80006126:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	732080e7          	jalr	1842(ra) # 8000185c <wakeup>
    
    WriteReg(THR, c);
    80006132:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006136:	6098                	ld	a4,0(s1)
    80006138:	0009b783          	ld	a5,0(s3)
    8000613c:	fce798e3          	bne	a5,a4,8000610c <uartstart+0x42>
  }
}
    80006140:	70e2                	ld	ra,56(sp)
    80006142:	7442                	ld	s0,48(sp)
    80006144:	74a2                	ld	s1,40(sp)
    80006146:	7902                	ld	s2,32(sp)
    80006148:	69e2                	ld	s3,24(sp)
    8000614a:	6a42                	ld	s4,16(sp)
    8000614c:	6aa2                	ld	s5,8(sp)
    8000614e:	6121                	addi	sp,sp,64
    80006150:	8082                	ret
    80006152:	8082                	ret

0000000080006154 <uartputc>:
{
    80006154:	7179                	addi	sp,sp,-48
    80006156:	f406                	sd	ra,40(sp)
    80006158:	f022                	sd	s0,32(sp)
    8000615a:	ec26                	sd	s1,24(sp)
    8000615c:	e84a                	sd	s2,16(sp)
    8000615e:	e44e                	sd	s3,8(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006166:	00020517          	auipc	a0,0x20
    8000616a:	0a250513          	addi	a0,a0,162 # 80026208 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a4080e7          	jalr	420(ra) # 80006312 <acquire>
  if(panicked){
    80006176:	00003797          	auipc	a5,0x3
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000901c <panicked>
    8000617e:	c391                	beqz	a5,80006182 <uartputc+0x2e>
    for(;;)
    80006180:	a001                	j	80006180 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006182:	00003797          	auipc	a5,0x3
    80006186:	ea67b783          	ld	a5,-346(a5) # 80009028 <uart_tx_w>
    8000618a:	00003717          	auipc	a4,0x3
    8000618e:	e9673703          	ld	a4,-362(a4) # 80009020 <uart_tx_r>
    80006192:	02070713          	addi	a4,a4,32
    80006196:	02f71b63          	bne	a4,a5,800061cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619a:	00020a17          	auipc	s4,0x20
    8000619e:	06ea0a13          	addi	s4,s4,110 # 80026208 <uart_tx_lock>
    800061a2:	00003497          	auipc	s1,0x3
    800061a6:	e7e48493          	addi	s1,s1,-386 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061aa:	00003917          	auipc	s2,0x3
    800061ae:	e7e90913          	addi	s2,s2,-386 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b2:	85d2                	mv	a1,s4
    800061b4:	8526                	mv	a0,s1
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	51a080e7          	jalr	1306(ra) # 800016d0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061be:	00093783          	ld	a5,0(s2)
    800061c2:	6098                	ld	a4,0(s1)
    800061c4:	02070713          	addi	a4,a4,32
    800061c8:	fef705e3          	beq	a4,a5,800061b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061cc:	00020497          	auipc	s1,0x20
    800061d0:	03c48493          	addi	s1,s1,60 # 80026208 <uart_tx_lock>
    800061d4:	01f7f713          	andi	a4,a5,31
    800061d8:	9726                	add	a4,a4,s1
    800061da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061de:	0785                	addi	a5,a5,1
    800061e0:	00003717          	auipc	a4,0x3
    800061e4:	e4f73423          	sd	a5,-440(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	ee2080e7          	jalr	-286(ra) # 800060ca <uartstart>
      release(&uart_tx_lock);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	1d4080e7          	jalr	468(ra) # 800063c6 <release>
}
    800061fa:	70a2                	ld	ra,40(sp)
    800061fc:	7402                	ld	s0,32(sp)
    800061fe:	64e2                	ld	s1,24(sp)
    80006200:	6942                	ld	s2,16(sp)
    80006202:	69a2                	ld	s3,8(sp)
    80006204:	6a02                	ld	s4,0(sp)
    80006206:	6145                	addi	sp,sp,48
    80006208:	8082                	ret

000000008000620a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e422                	sd	s0,8(sp)
    8000620e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006210:	100007b7          	lui	a5,0x10000
    80006214:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006218:	8b85                	andi	a5,a5,1
    8000621a:	cb91                	beqz	a5,8000622e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006224:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006228:	6422                	ld	s0,8(sp)
    8000622a:	0141                	addi	sp,sp,16
    8000622c:	8082                	ret
    return -1;
    8000622e:	557d                	li	a0,-1
    80006230:	bfe5                	j	80006228 <uartgetc+0x1e>

0000000080006232 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000623c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	fcc080e7          	jalr	-52(ra) # 8000620a <uartgetc>
    if(c == -1)
    80006246:	00950763          	beq	a0,s1,80006254 <uartintr+0x22>
      break;
    consoleintr(c);
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	8fe080e7          	jalr	-1794(ra) # 80005b48 <consoleintr>
  while(1){
    80006252:	b7f5                	j	8000623e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006254:	00020497          	auipc	s1,0x20
    80006258:	fb448493          	addi	s1,s1,-76 # 80026208 <uart_tx_lock>
    8000625c:	8526                	mv	a0,s1
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	0b4080e7          	jalr	180(ra) # 80006312 <acquire>
  uartstart();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	e64080e7          	jalr	-412(ra) # 800060ca <uartstart>
  release(&uart_tx_lock);
    8000626e:	8526                	mv	a0,s1
    80006270:	00000097          	auipc	ra,0x0
    80006274:	156080e7          	jalr	342(ra) # 800063c6 <release>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret

0000000080006282 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006282:	1141                	addi	sp,sp,-16
    80006284:	e422                	sd	s0,8(sp)
    80006286:	0800                	addi	s0,sp,16
  lk->name = name;
    80006288:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000628a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628e:	00053823          	sd	zero,16(a0)
}
    80006292:	6422                	ld	s0,8(sp)
    80006294:	0141                	addi	sp,sp,16
    80006296:	8082                	ret

0000000080006298 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006298:	411c                	lw	a5,0(a0)
    8000629a:	e399                	bnez	a5,800062a0 <holding+0x8>
    8000629c:	4501                	li	a0,0
  return r;
}
    8000629e:	8082                	ret
{
    800062a0:	1101                	addi	sp,sp,-32
    800062a2:	ec06                	sd	ra,24(sp)
    800062a4:	e822                	sd	s0,16(sp)
    800062a6:	e426                	sd	s1,8(sp)
    800062a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062aa:	6904                	ld	s1,16(a0)
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	c9e080e7          	jalr	-866(ra) # 80000f4a <mycpu>
    800062b4:	40a48533          	sub	a0,s1,a0
    800062b8:	00153513          	seqz	a0,a0
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret

00000000800062c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c6:	1101                	addi	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d0:	100024f3          	csrr	s1,sstatus
    800062d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	c6c080e7          	jalr	-916(ra) # 80000f4a <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	cf89                	beqz	a5,80006302 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ea:	ffffb097          	auipc	ra,0xffffb
    800062ee:	c60080e7          	jalr	-928(ra) # 80000f4a <mycpu>
    800062f2:	5d3c                	lw	a5,120(a0)
    800062f4:	2785                	addiw	a5,a5,1
    800062f6:	dd3c                	sw	a5,120(a0)
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret
    mycpu()->intena = old;
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	c48080e7          	jalr	-952(ra) # 80000f4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8085                	srli	s1,s1,0x1
    8000630c:	8885                	andi	s1,s1,1
    8000630e:	dd64                	sw	s1,124(a0)
    80006310:	bfe9                	j	800062ea <push_off+0x24>

0000000080006312 <acquire>:
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
    8000631c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	fa8080e7          	jalr	-88(ra) # 800062c6 <push_off>
  if(holding(lk))
    80006326:	8526                	mv	a0,s1
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	f70080e7          	jalr	-144(ra) # 80006298 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006330:	4705                	li	a4,1
  if(holding(lk))
    80006332:	e115                	bnez	a0,80006356 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006334:	87ba                	mv	a5,a4
    80006336:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000633a:	2781                	sext.w	a5,a5
    8000633c:	ffe5                	bnez	a5,80006334 <acquire+0x22>
  __sync_synchronize();
    8000633e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	c08080e7          	jalr	-1016(ra) # 80000f4a <mycpu>
    8000634a:	e888                	sd	a0,16(s1)
}
    8000634c:	60e2                	ld	ra,24(sp)
    8000634e:	6442                	ld	s0,16(sp)
    80006350:	64a2                	ld	s1,8(sp)
    80006352:	6105                	addi	sp,sp,32
    80006354:	8082                	ret
    panic("acquire");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	55a50513          	addi	a0,a0,1370 # 800088b0 <digits+0x20>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	a6a080e7          	jalr	-1430(ra) # 80005dc8 <panic>

0000000080006366 <pop_off>:

void
pop_off(void)
{
    80006366:	1141                	addi	sp,sp,-16
    80006368:	e406                	sd	ra,8(sp)
    8000636a:	e022                	sd	s0,0(sp)
    8000636c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	bdc080e7          	jalr	-1060(ra) # 80000f4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006376:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000637a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000637c:	e78d                	bnez	a5,800063a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637e:	5d3c                	lw	a5,120(a0)
    80006380:	02f05b63          	blez	a5,800063b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006384:	37fd                	addiw	a5,a5,-1
    80006386:	0007871b          	sext.w	a4,a5
    8000638a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000638c:	eb09                	bnez	a4,8000639e <pop_off+0x38>
    8000638e:	5d7c                	lw	a5,124(a0)
    80006390:	c799                	beqz	a5,8000639e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006392:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006396:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639e:	60a2                	ld	ra,8(sp)
    800063a0:	6402                	ld	s0,0(sp)
    800063a2:	0141                	addi	sp,sp,16
    800063a4:	8082                	ret
    panic("pop_off - interruptible");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	51250513          	addi	a0,a0,1298 # 800088b8 <digits+0x28>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a1a080e7          	jalr	-1510(ra) # 80005dc8 <panic>
    panic("pop_off");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	51a50513          	addi	a0,a0,1306 # 800088d0 <digits+0x40>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a0a080e7          	jalr	-1526(ra) # 80005dc8 <panic>

00000000800063c6 <release>:
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
    800063d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	ec6080e7          	jalr	-314(ra) # 80006298 <holding>
    800063da:	c115                	beqz	a0,800063fe <release+0x38>
  lk->cpu = 0;
    800063dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e4:	0f50000f          	fence	iorw,ow
    800063e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	f7a080e7          	jalr	-134(ra) # 80006366 <pop_off>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret
    panic("release");
    800063fe:	00002517          	auipc	a0,0x2
    80006402:	4da50513          	addi	a0,a0,1242 # 800088d8 <digits+0x48>
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	9c2080e7          	jalr	-1598(ra) # 80005dc8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
