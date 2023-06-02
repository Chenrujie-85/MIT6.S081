
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
    80000016:	7b2050ef          	jal	ra,800057c8 <start>

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
    8000005e:	1de080e7          	jalr	478(ra) # 80006238 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	27e080e7          	jalr	638(ra) # 800062ec <release>
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
    8000008e:	c8e080e7          	jalr	-882(ra) # 80005d18 <panic>

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
    800000f8:	0b4080e7          	jalr	180(ra) # 800061a8 <initlock>
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
    80000130:	10c080e7          	jalr	268(ra) # 80006238 <acquire>
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
    80000148:	1a8080e7          	jalr	424(ra) # 800062ec <release>

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
    80000172:	17e080e7          	jalr	382(ra) # 800062ec <release>
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
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
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
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a0e080e7          	jalr	-1522(ra) # 80005d6a <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	778080e7          	jalr	1912(ra) # 80001ae4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	ddc080e7          	jalr	-548(ra) # 80005150 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	026080e7          	jalr	38(ra) # 800013a2 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	806080e7          	jalr	-2042(ra) # 80005b8a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	8ec080e7          	jalr	-1812(ra) # 80005c78 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	9ce080e7          	jalr	-1586(ra) # 80005d6a <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	9be080e7          	jalr	-1602(ra) # 80005d6a <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	9ae080e7          	jalr	-1618(ra) # 80005d6a <printf>
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
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6d8080e7          	jalr	1752(ra) # 80001abc <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6f8080e7          	jalr	1784(ra) # 80001ae4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d46080e7          	jalr	-698(ra) # 8000513a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d54080e7          	jalr	-684(ra) # 80005150 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f2e080e7          	jalr	-210(ra) # 80002332 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5be080e7          	jalr	1470(ra) # 800029ca <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	568080e7          	jalr	1384(ra) # 8000397c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e56080e7          	jalr	-426(ra) # 80005272 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d4c080e7          	jalr	-692(ra) # 80001170 <userinit>
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
    80000492:	88a080e7          	jalr	-1910(ra) # 80005d18 <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	792080e7          	jalr	1938(ra) # 80005d18 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	782080e7          	jalr	1922(ra) # 80005d18 <panic>
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
    80000614:	708080e7          	jalr	1800(ra) # 80005d18 <panic>

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
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
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
    80000760:	5bc080e7          	jalr	1468(ra) # 80005d18 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	5ac080e7          	jalr	1452(ra) # 80005d18 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	59c080e7          	jalr	1436(ra) # 80005d18 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	58c080e7          	jalr	1420(ra) # 80005d18 <panic>
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
    8000086e:	4ae080e7          	jalr	1198(ra) # 80005d18 <panic>

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

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	36c080e7          	jalr	876(ra) # 80005d18 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	290080e7          	jalr	656(ra) # 80005d18 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	280080e7          	jalr	640(ra) # 80005d18 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	216080e7          	jalr	534(ra) # 80005d18 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	0000fa17          	auipc	s4,0xf
    80000d0a:	d7aa0a13          	addi	s4,s4,-646 # 8000fa80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	19848493          	addi	s1,s1,408
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	fb4080e7          	jalr	-76(ra) # 80005d18 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	418080e7          	jalr	1048(ra) # 800061a8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	400080e7          	jalr	1024(ra) # 800061a8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	0000f997          	auipc	s3,0xf
    80000dd6:	cae98993          	addi	s3,s3,-850 # 8000fa80 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	3ca080e7          	jalr	970(ra) # 800061a8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	19848493          	addi	s1,s1,408
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	39a080e7          	jalr	922(ra) # 800061ec <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	420080e7          	jalr	1056(ra) # 8000628c <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	45c080e7          	jalr	1116(ra) # 800062ec <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9a87a783          	lw	a5,-1624(a5) # 80008840 <first.1683>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c5a080e7          	jalr	-934(ra) # 80001afc <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9807a723          	sw	zero,-1650(a5) # 80008840 <first.1683>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	a8e080e7          	jalr	-1394(ra) # 8000294a <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	35c080e7          	jalr	860(ra) # 80006238 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	96078793          	addi	a5,a5,-1696 # 80008844 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	3f6080e7          	jalr	1014(ra) # 800062ec <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->tick_trapframe)
    80001016:	1884b503          	ld	a0,392(s1)
    8000101a:	c509                	beqz	a0,80001024 <freeproc+0x2a>
    kfree((void*)p->tick_trapframe);
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	000080e7          	jalr	ra # 8000001c <kfree>
  p->tick_trapframe = 0;
    80001024:	1804b423          	sd	zero,392(s1)
  if(p->pagetable)
    80001028:	68a8                	ld	a0,80(s1)
    8000102a:	c511                	beqz	a0,80001036 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    8000102c:	64ac                	ld	a1,72(s1)
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	f7a080e7          	jalr	-134(ra) # 80000fa8 <proc_freepagetable>
  p->interval = 0;
    80001036:	1604a423          	sw	zero,360(s1)
  p->ticks_cnt = 0;
    8000103a:	1604ac23          	sw	zero,376(s1)
  p->handler_exec = 0;
    8000103e:	1804a823          	sw	zero,400(s1)
  p->handler = 0;
    80001042:	1604b823          	sd	zero,368(s1)
  p->pagetable = 0;
    80001046:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000104a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000104e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001052:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001056:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000105a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000105e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001062:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001066:	0004ac23          	sw	zero,24(s1)
}
    8000106a:	60e2                	ld	ra,24(sp)
    8000106c:	6442                	ld	s0,16(sp)
    8000106e:	64a2                	ld	s1,8(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret

0000000080001074 <allocproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	e04a                	sd	s2,0(sp)
    8000107e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	00008497          	auipc	s1,0x8
    80001084:	40048493          	addi	s1,s1,1024 # 80009480 <proc>
    80001088:	0000f917          	auipc	s2,0xf
    8000108c:	9f890913          	addi	s2,s2,-1544 # 8000fa80 <tickslock>
    acquire(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	00005097          	auipc	ra,0x5
    80001096:	1a6080e7          	jalr	422(ra) # 80006238 <acquire>
    if(p->state == UNUSED) {
    8000109a:	4c9c                	lw	a5,24(s1)
    8000109c:	cf81                	beqz	a5,800010b4 <allocproc+0x40>
      release(&p->lock);
    8000109e:	8526                	mv	a0,s1
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	24c080e7          	jalr	588(ra) # 800062ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	19848493          	addi	s1,s1,408
    800010ac:	ff2492e3          	bne	s1,s2,80001090 <allocproc+0x1c>
  return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	a88d                	j	80001124 <allocproc+0xb0>
  p->pid = allocpid();
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	e12080e7          	jalr	-494(ra) # 80000ec6 <allocpid>
    800010bc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010be:	4785                	li	a5,1
    800010c0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	056080e7          	jalr	86(ra) # 80000118 <kalloc>
    800010ca:	892a                	mv	s2,a0
    800010cc:	eca8                	sd	a0,88(s1)
    800010ce:	c135                	beqz	a0,80001132 <allocproc+0xbe>
  p->pagetable = proc_pagetable(p);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	e3a080e7          	jalr	-454(ra) # 80000f0c <proc_pagetable>
    800010da:	892a                	mv	s2,a0
    800010dc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010de:	c535                	beqz	a0,8000114a <allocproc+0xd6>
  memset(&p->context, 0, sizeof(p->context));
    800010e0:	07000613          	li	a2,112
    800010e4:	4581                	li	a1,0
    800010e6:	06048513          	addi	a0,s1,96
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	08e080e7          	jalr	142(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010f2:	00000797          	auipc	a5,0x0
    800010f6:	d8e78793          	addi	a5,a5,-626 # 80000e80 <forkret>
    800010fa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fc:	60bc                	ld	a5,64(s1)
    800010fe:	6705                	lui	a4,0x1
    80001100:	97ba                	add	a5,a5,a4
    80001102:	f4bc                	sd	a5,104(s1)
  if((p->tick_trapframe = (struct trapframe *)kalloc()) == 0){
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	014080e7          	jalr	20(ra) # 80000118 <kalloc>
    8000110c:	892a                	mv	s2,a0
    8000110e:	18a4b423          	sd	a0,392(s1)
    80001112:	c921                	beqz	a0,80001162 <allocproc+0xee>
  p->interval = 0;
    80001114:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001118:	1604b823          	sd	zero,368(s1)
  p->ticks_cnt = 0;
    8000111c:	1604ac23          	sw	zero,376(s1)
  p->handler_exec = 0;
    80001120:	1804a823          	sw	zero,400(s1)
}
    80001124:	8526                	mv	a0,s1
    80001126:	60e2                	ld	ra,24(sp)
    80001128:	6442                	ld	s0,16(sp)
    8000112a:	64a2                	ld	s1,8(sp)
    8000112c:	6902                	ld	s2,0(sp)
    8000112e:	6105                	addi	sp,sp,32
    80001130:	8082                	ret
    freeproc(p);
    80001132:	8526                	mv	a0,s1
    80001134:	00000097          	auipc	ra,0x0
    80001138:	ec6080e7          	jalr	-314(ra) # 80000ffa <freeproc>
    release(&p->lock);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00005097          	auipc	ra,0x5
    80001142:	1ae080e7          	jalr	430(ra) # 800062ec <release>
    return 0;
    80001146:	84ca                	mv	s1,s2
    80001148:	bff1                	j	80001124 <allocproc+0xb0>
    freeproc(p);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	eae080e7          	jalr	-338(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001154:	8526                	mv	a0,s1
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	196080e7          	jalr	406(ra) # 800062ec <release>
    return 0;
    8000115e:	84ca                	mv	s1,s2
    80001160:	b7d1                	j	80001124 <allocproc+0xb0>
    release(&p->lock);
    80001162:	8526                	mv	a0,s1
    80001164:	00005097          	auipc	ra,0x5
    80001168:	188080e7          	jalr	392(ra) # 800062ec <release>
    return 0;
    8000116c:	84ca                	mv	s1,s2
    8000116e:	bf5d                	j	80001124 <allocproc+0xb0>

0000000080001170 <userinit>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	1000                	addi	s0,sp,32
  p = allocproc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	efa080e7          	jalr	-262(ra) # 80001074 <allocproc>
    80001182:	84aa                	mv	s1,a0
  initproc = p;
    80001184:	00008797          	auipc	a5,0x8
    80001188:	e8a7b623          	sd	a0,-372(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000118c:	03400613          	li	a2,52
    80001190:	00007597          	auipc	a1,0x7
    80001194:	6c058593          	addi	a1,a1,1728 # 80008850 <initcode>
    80001198:	6928                	ld	a0,80(a0)
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	666080e7          	jalr	1638(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    800011a2:	6785                	lui	a5,0x1
    800011a4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ac:	6cb8                	ld	a4,88(s1)
    800011ae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b0:	4641                	li	a2,16
    800011b2:	00007597          	auipc	a1,0x7
    800011b6:	fce58593          	addi	a1,a1,-50 # 80008180 <etext+0x180>
    800011ba:	15848513          	addi	a0,s1,344
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	10c080e7          	jalr	268(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011c6:	00007517          	auipc	a0,0x7
    800011ca:	fca50513          	addi	a0,a0,-54 # 80008190 <etext+0x190>
    800011ce:	00002097          	auipc	ra,0x2
    800011d2:	1aa080e7          	jalr	426(ra) # 80003378 <namei>
    800011d6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011da:	478d                	li	a5,3
    800011dc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	00005097          	auipc	ra,0x5
    800011e4:	10c080e7          	jalr	268(ra) # 800062ec <release>
}
    800011e8:	60e2                	ld	ra,24(sp)
    800011ea:	6442                	ld	s0,16(sp)
    800011ec:	64a2                	ld	s1,8(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret

00000000800011f2 <growproc>:
{
    800011f2:	1101                	addi	sp,sp,-32
    800011f4:	ec06                	sd	ra,24(sp)
    800011f6:	e822                	sd	s0,16(sp)
    800011f8:	e426                	sd	s1,8(sp)
    800011fa:	e04a                	sd	s2,0(sp)
    800011fc:	1000                	addi	s0,sp,32
    800011fe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001200:	00000097          	auipc	ra,0x0
    80001204:	c48080e7          	jalr	-952(ra) # 80000e48 <myproc>
    80001208:	892a                	mv	s2,a0
  sz = p->sz;
    8000120a:	652c                	ld	a1,72(a0)
    8000120c:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001210:	00904f63          	bgtz	s1,8000122e <growproc+0x3c>
  } else if(n < 0){
    80001214:	0204cc63          	bltz	s1,8000124c <growproc+0x5a>
  p->sz = sz;
    80001218:	1602                	slli	a2,a2,0x20
    8000121a:	9201                	srli	a2,a2,0x20
    8000121c:	04c93423          	sd	a2,72(s2)
  return 0;
    80001220:	4501                	li	a0,0
}
    80001222:	60e2                	ld	ra,24(sp)
    80001224:	6442                	ld	s0,16(sp)
    80001226:	64a2                	ld	s1,8(sp)
    80001228:	6902                	ld	s2,0(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000122e:	9e25                	addw	a2,a2,s1
    80001230:	1602                	slli	a2,a2,0x20
    80001232:	9201                	srli	a2,a2,0x20
    80001234:	1582                	slli	a1,a1,0x20
    80001236:	9181                	srli	a1,a1,0x20
    80001238:	6928                	ld	a0,80(a0)
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	680080e7          	jalr	1664(ra) # 800008ba <uvmalloc>
    80001242:	0005061b          	sext.w	a2,a0
    80001246:	fa69                	bnez	a2,80001218 <growproc+0x26>
      return -1;
    80001248:	557d                	li	a0,-1
    8000124a:	bfe1                	j	80001222 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000124c:	9e25                	addw	a2,a2,s1
    8000124e:	1602                	slli	a2,a2,0x20
    80001250:	9201                	srli	a2,a2,0x20
    80001252:	1582                	slli	a1,a1,0x20
    80001254:	9181                	srli	a1,a1,0x20
    80001256:	6928                	ld	a0,80(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	61a080e7          	jalr	1562(ra) # 80000872 <uvmdealloc>
    80001260:	0005061b          	sext.w	a2,a0
    80001264:	bf55                	j	80001218 <growproc+0x26>

0000000080001266 <fork>:
{
    80001266:	7179                	addi	sp,sp,-48
    80001268:	f406                	sd	ra,40(sp)
    8000126a:	f022                	sd	s0,32(sp)
    8000126c:	ec26                	sd	s1,24(sp)
    8000126e:	e84a                	sd	s2,16(sp)
    80001270:	e44e                	sd	s3,8(sp)
    80001272:	e052                	sd	s4,0(sp)
    80001274:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	bd2080e7          	jalr	-1070(ra) # 80000e48 <myproc>
    8000127e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001280:	00000097          	auipc	ra,0x0
    80001284:	df4080e7          	jalr	-524(ra) # 80001074 <allocproc>
    80001288:	10050b63          	beqz	a0,8000139e <fork+0x138>
    8000128c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128e:	04893603          	ld	a2,72(s2)
    80001292:	692c                	ld	a1,80(a0)
    80001294:	05093503          	ld	a0,80(s2)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	76e080e7          	jalr	1902(ra) # 80000a06 <uvmcopy>
    800012a0:	04054663          	bltz	a0,800012ec <fork+0x86>
  np->sz = p->sz;
    800012a4:	04893783          	ld	a5,72(s2)
    800012a8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012ac:	05893683          	ld	a3,88(s2)
    800012b0:	87b6                	mv	a5,a3
    800012b2:	0589b703          	ld	a4,88(s3)
    800012b6:	12068693          	addi	a3,a3,288
    800012ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012be:	6788                	ld	a0,8(a5)
    800012c0:	6b8c                	ld	a1,16(a5)
    800012c2:	6f90                	ld	a2,24(a5)
    800012c4:	01073023          	sd	a6,0(a4)
    800012c8:	e708                	sd	a0,8(a4)
    800012ca:	eb0c                	sd	a1,16(a4)
    800012cc:	ef10                	sd	a2,24(a4)
    800012ce:	02078793          	addi	a5,a5,32
    800012d2:	02070713          	addi	a4,a4,32
    800012d6:	fed792e3          	bne	a5,a3,800012ba <fork+0x54>
  np->trapframe->a0 = 0;
    800012da:	0589b783          	ld	a5,88(s3)
    800012de:	0607b823          	sd	zero,112(a5)
    800012e2:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e6:	15000a13          	li	s4,336
    800012ea:	a03d                	j	80001318 <fork+0xb2>
    freeproc(np);
    800012ec:	854e                	mv	a0,s3
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	d0c080e7          	jalr	-756(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012f6:	854e                	mv	a0,s3
    800012f8:	00005097          	auipc	ra,0x5
    800012fc:	ff4080e7          	jalr	-12(ra) # 800062ec <release>
    return -1;
    80001300:	5a7d                	li	s4,-1
    80001302:	a069                	j	8000138c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001304:	00002097          	auipc	ra,0x2
    80001308:	70a080e7          	jalr	1802(ra) # 80003a0e <filedup>
    8000130c:	009987b3          	add	a5,s3,s1
    80001310:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001312:	04a1                	addi	s1,s1,8
    80001314:	01448763          	beq	s1,s4,80001322 <fork+0xbc>
    if(p->ofile[i])
    80001318:	009907b3          	add	a5,s2,s1
    8000131c:	6388                	ld	a0,0(a5)
    8000131e:	f17d                	bnez	a0,80001304 <fork+0x9e>
    80001320:	bfcd                	j	80001312 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001322:	15093503          	ld	a0,336(s2)
    80001326:	00002097          	auipc	ra,0x2
    8000132a:	85e080e7          	jalr	-1954(ra) # 80002b84 <idup>
    8000132e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001332:	4641                	li	a2,16
    80001334:	15890593          	addi	a1,s2,344
    80001338:	15898513          	addi	a0,s3,344
    8000133c:	fffff097          	auipc	ra,0xfffff
    80001340:	f8e080e7          	jalr	-114(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001344:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001348:	854e                	mv	a0,s3
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	fa2080e7          	jalr	-94(ra) # 800062ec <release>
  acquire(&wait_lock);
    80001352:	00008497          	auipc	s1,0x8
    80001356:	d1648493          	addi	s1,s1,-746 # 80009068 <wait_lock>
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	edc080e7          	jalr	-292(ra) # 80006238 <acquire>
  np->parent = p;
    80001364:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001368:	8526                	mv	a0,s1
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	f82080e7          	jalr	-126(ra) # 800062ec <release>
  acquire(&np->lock);
    80001372:	854e                	mv	a0,s3
    80001374:	00005097          	auipc	ra,0x5
    80001378:	ec4080e7          	jalr	-316(ra) # 80006238 <acquire>
  np->state = RUNNABLE;
    8000137c:	478d                	li	a5,3
    8000137e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001382:	854e                	mv	a0,s3
    80001384:	00005097          	auipc	ra,0x5
    80001388:	f68080e7          	jalr	-152(ra) # 800062ec <release>
}
    8000138c:	8552                	mv	a0,s4
    8000138e:	70a2                	ld	ra,40(sp)
    80001390:	7402                	ld	s0,32(sp)
    80001392:	64e2                	ld	s1,24(sp)
    80001394:	6942                	ld	s2,16(sp)
    80001396:	69a2                	ld	s3,8(sp)
    80001398:	6a02                	ld	s4,0(sp)
    8000139a:	6145                	addi	sp,sp,48
    8000139c:	8082                	ret
    return -1;
    8000139e:	5a7d                	li	s4,-1
    800013a0:	b7f5                	j	8000138c <fork+0x126>

00000000800013a2 <scheduler>:
{
    800013a2:	7139                	addi	sp,sp,-64
    800013a4:	fc06                	sd	ra,56(sp)
    800013a6:	f822                	sd	s0,48(sp)
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	f04a                	sd	s2,32(sp)
    800013ac:	ec4e                	sd	s3,24(sp)
    800013ae:	e852                	sd	s4,16(sp)
    800013b0:	e456                	sd	s5,8(sp)
    800013b2:	e05a                	sd	s6,0(sp)
    800013b4:	0080                	addi	s0,sp,64
    800013b6:	8792                	mv	a5,tp
  int id = r_tp();
    800013b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ba:	00779a93          	slli	s5,a5,0x7
    800013be:	00008717          	auipc	a4,0x8
    800013c2:	c9270713          	addi	a4,a4,-878 # 80009050 <pid_lock>
    800013c6:	9756                	add	a4,a4,s5
    800013c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013cc:	00008717          	auipc	a4,0x8
    800013d0:	cbc70713          	addi	a4,a4,-836 # 80009088 <cpus+0x8>
    800013d4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d6:	498d                	li	s3,3
        p->state = RUNNING;
    800013d8:	4b11                	li	s6,4
        c->proc = p;
    800013da:	079e                	slli	a5,a5,0x7
    800013dc:	00008a17          	auipc	s4,0x8
    800013e0:	c74a0a13          	addi	s4,s4,-908 # 80009050 <pid_lock>
    800013e4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	0000e917          	auipc	s2,0xe
    800013ea:	69a90913          	addi	s2,s2,1690 # 8000fa80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f6:	10079073          	csrw	sstatus,a5
    800013fa:	00008497          	auipc	s1,0x8
    800013fe:	08648493          	addi	s1,s1,134 # 80009480 <proc>
    80001402:	a03d                	j	80001430 <scheduler+0x8e>
        p->state = RUNNING;
    80001404:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001408:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140c:	06048593          	addi	a1,s1,96
    80001410:	8556                	mv	a0,s5
    80001412:	00000097          	auipc	ra,0x0
    80001416:	640080e7          	jalr	1600(ra) # 80001a52 <swtch>
        c->proc = 0;
    8000141a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000141e:	8526                	mv	a0,s1
    80001420:	00005097          	auipc	ra,0x5
    80001424:	ecc080e7          	jalr	-308(ra) # 800062ec <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001428:	19848493          	addi	s1,s1,408
    8000142c:	fd2481e3          	beq	s1,s2,800013ee <scheduler+0x4c>
      acquire(&p->lock);
    80001430:	8526                	mv	a0,s1
    80001432:	00005097          	auipc	ra,0x5
    80001436:	e06080e7          	jalr	-506(ra) # 80006238 <acquire>
      if(p->state == RUNNABLE) {
    8000143a:	4c9c                	lw	a5,24(s1)
    8000143c:	ff3791e3          	bne	a5,s3,8000141e <scheduler+0x7c>
    80001440:	b7d1                	j	80001404 <scheduler+0x62>

0000000080001442 <sched>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	9f8080e7          	jalr	-1544(ra) # 80000e48 <myproc>
    80001458:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	d64080e7          	jalr	-668(ra) # 800061be <holding>
    80001462:	c93d                	beqz	a0,800014d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	00008717          	auipc	a4,0x8
    8000146e:	be670713          	addi	a4,a4,-1050 # 80009050 <pid_lock>
    80001472:	97ba                	add	a5,a5,a4
    80001474:	0a87a703          	lw	a4,168(a5)
    80001478:	4785                	li	a5,1
    8000147a:	06f71763          	bne	a4,a5,800014e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000147e:	4c98                	lw	a4,24(s1)
    80001480:	4791                	li	a5,4
    80001482:	06f70b63          	beq	a4,a5,800014f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001486:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148c:	efb5                	bnez	a5,80001508 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001490:	00008917          	auipc	s2,0x8
    80001494:	bc090913          	addi	s2,s2,-1088 # 80009050 <pid_lock>
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	97ca                	add	a5,a5,s2
    8000149e:	0ac7a983          	lw	s3,172(a5)
    800014a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	00008597          	auipc	a1,0x8
    800014ac:	be058593          	addi	a1,a1,-1056 # 80009088 <cpus+0x8>
    800014b0:	95be                	add	a1,a1,a5
    800014b2:	06048513          	addi	a0,s1,96
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	59c080e7          	jalr	1436(ra) # 80001a52 <swtch>
    800014be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	97ca                	add	a5,a5,s2
    800014c6:	0b37a623          	sw	s3,172(a5)
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("sched p->lock");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	cc050513          	addi	a0,a0,-832 # 80008198 <etext+0x198>
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	838080e7          	jalr	-1992(ra) # 80005d18 <panic>
    panic("sched locks");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	cc050513          	addi	a0,a0,-832 # 800081a8 <etext+0x1a8>
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	828080e7          	jalr	-2008(ra) # 80005d18 <panic>
    panic("sched running");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	cc050513          	addi	a0,a0,-832 # 800081b8 <etext+0x1b8>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	818080e7          	jalr	-2024(ra) # 80005d18 <panic>
    panic("sched interruptible");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cc050513          	addi	a0,a0,-832 # 800081c8 <etext+0x1c8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	808080e7          	jalr	-2040(ra) # 80005d18 <panic>

0000000080001518 <yield>:
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	926080e7          	jalr	-1754(ra) # 80000e48 <myproc>
    8000152a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	d0c080e7          	jalr	-756(ra) # 80006238 <acquire>
  p->state = RUNNABLE;
    80001534:	478d                	li	a5,3
    80001536:	cc9c                	sw	a5,24(s1)
  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f0a080e7          	jalr	-246(ra) # 80001442 <sched>
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00005097          	auipc	ra,0x5
    80001546:	daa080e7          	jalr	-598(ra) # 800062ec <release>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret

0000000080001554 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001554:	7179                	addi	sp,sp,-48
    80001556:	f406                	sd	ra,40(sp)
    80001558:	f022                	sd	s0,32(sp)
    8000155a:	ec26                	sd	s1,24(sp)
    8000155c:	e84a                	sd	s2,16(sp)
    8000155e:	e44e                	sd	s3,8(sp)
    80001560:	1800                	addi	s0,sp,48
    80001562:	89aa                	mv	s3,a0
    80001564:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	8e2080e7          	jalr	-1822(ra) # 80000e48 <myproc>
    8000156e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	cc8080e7          	jalr	-824(ra) # 80006238 <acquire>
  release(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	d72080e7          	jalr	-654(ra) # 800062ec <release>

  // Go to sleep.
  p->chan = chan;
    80001582:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001586:	4789                	li	a5,2
    80001588:	cc9c                	sw	a5,24(s1)

  sched();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	eb8080e7          	jalr	-328(ra) # 80001442 <sched>

  // Tidy up.
  p->chan = 0;
    80001592:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	d54080e7          	jalr	-684(ra) # 800062ec <release>
  acquire(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	c96080e7          	jalr	-874(ra) # 80006238 <acquire>
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <wait>:
{
    800015b8:	715d                	addi	sp,sp,-80
    800015ba:	e486                	sd	ra,72(sp)
    800015bc:	e0a2                	sd	s0,64(sp)
    800015be:	fc26                	sd	s1,56(sp)
    800015c0:	f84a                	sd	s2,48(sp)
    800015c2:	f44e                	sd	s3,40(sp)
    800015c4:	f052                	sd	s4,32(sp)
    800015c6:	ec56                	sd	s5,24(sp)
    800015c8:	e85a                	sd	s6,16(sp)
    800015ca:	e45e                	sd	s7,8(sp)
    800015cc:	e062                	sd	s8,0(sp)
    800015ce:	0880                	addi	s0,sp,80
    800015d0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	876080e7          	jalr	-1930(ra) # 80000e48 <myproc>
    800015da:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015dc:	00008517          	auipc	a0,0x8
    800015e0:	a8c50513          	addi	a0,a0,-1396 # 80009068 <wait_lock>
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	c54080e7          	jalr	-940(ra) # 80006238 <acquire>
    havekids = 0;
    800015ec:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ee:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f0:	0000e997          	auipc	s3,0xe
    800015f4:	49098993          	addi	s3,s3,1168 # 8000fa80 <tickslock>
        havekids = 1;
    800015f8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fa:	00008c17          	auipc	s8,0x8
    800015fe:	a6ec0c13          	addi	s8,s8,-1426 # 80009068 <wait_lock>
    havekids = 0;
    80001602:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001604:	00008497          	auipc	s1,0x8
    80001608:	e7c48493          	addi	s1,s1,-388 # 80009480 <proc>
    8000160c:	a0bd                	j	8000167a <wait+0xc2>
          pid = np->pid;
    8000160e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001612:	000b0e63          	beqz	s6,8000162e <wait+0x76>
    80001616:	4691                	li	a3,4
    80001618:	02c48613          	addi	a2,s1,44
    8000161c:	85da                	mv	a1,s6
    8000161e:	05093503          	ld	a0,80(s2)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	4e8080e7          	jalr	1256(ra) # 80000b0a <copyout>
    8000162a:	02054563          	bltz	a0,80001654 <wait+0x9c>
          freeproc(np);
    8000162e:	8526                	mv	a0,s1
    80001630:	00000097          	auipc	ra,0x0
    80001634:	9ca080e7          	jalr	-1590(ra) # 80000ffa <freeproc>
          release(&np->lock);
    80001638:	8526                	mv	a0,s1
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	cb2080e7          	jalr	-846(ra) # 800062ec <release>
          release(&wait_lock);
    80001642:	00008517          	auipc	a0,0x8
    80001646:	a2650513          	addi	a0,a0,-1498 # 80009068 <wait_lock>
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	ca2080e7          	jalr	-862(ra) # 800062ec <release>
          return pid;
    80001652:	a09d                	j	800016b8 <wait+0x100>
            release(&np->lock);
    80001654:	8526                	mv	a0,s1
    80001656:	00005097          	auipc	ra,0x5
    8000165a:	c96080e7          	jalr	-874(ra) # 800062ec <release>
            release(&wait_lock);
    8000165e:	00008517          	auipc	a0,0x8
    80001662:	a0a50513          	addi	a0,a0,-1526 # 80009068 <wait_lock>
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	c86080e7          	jalr	-890(ra) # 800062ec <release>
            return -1;
    8000166e:	59fd                	li	s3,-1
    80001670:	a0a1                	j	800016b8 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001672:	19848493          	addi	s1,s1,408
    80001676:	03348463          	beq	s1,s3,8000169e <wait+0xe6>
      if(np->parent == p){
    8000167a:	7c9c                	ld	a5,56(s1)
    8000167c:	ff279be3          	bne	a5,s2,80001672 <wait+0xba>
        acquire(&np->lock);
    80001680:	8526                	mv	a0,s1
    80001682:	00005097          	auipc	ra,0x5
    80001686:	bb6080e7          	jalr	-1098(ra) # 80006238 <acquire>
        if(np->state == ZOMBIE){
    8000168a:	4c9c                	lw	a5,24(s1)
    8000168c:	f94781e3          	beq	a5,s4,8000160e <wait+0x56>
        release(&np->lock);
    80001690:	8526                	mv	a0,s1
    80001692:	00005097          	auipc	ra,0x5
    80001696:	c5a080e7          	jalr	-934(ra) # 800062ec <release>
        havekids = 1;
    8000169a:	8756                	mv	a4,s5
    8000169c:	bfd9                	j	80001672 <wait+0xba>
    if(!havekids || p->killed){
    8000169e:	c701                	beqz	a4,800016a6 <wait+0xee>
    800016a0:	02892783          	lw	a5,40(s2)
    800016a4:	c79d                	beqz	a5,800016d2 <wait+0x11a>
      release(&wait_lock);
    800016a6:	00008517          	auipc	a0,0x8
    800016aa:	9c250513          	addi	a0,a0,-1598 # 80009068 <wait_lock>
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	c3e080e7          	jalr	-962(ra) # 800062ec <release>
      return -1;
    800016b6:	59fd                	li	s3,-1
}
    800016b8:	854e                	mv	a0,s3
    800016ba:	60a6                	ld	ra,72(sp)
    800016bc:	6406                	ld	s0,64(sp)
    800016be:	74e2                	ld	s1,56(sp)
    800016c0:	7942                	ld	s2,48(sp)
    800016c2:	79a2                	ld	s3,40(sp)
    800016c4:	7a02                	ld	s4,32(sp)
    800016c6:	6ae2                	ld	s5,24(sp)
    800016c8:	6b42                	ld	s6,16(sp)
    800016ca:	6ba2                	ld	s7,8(sp)
    800016cc:	6c02                	ld	s8,0(sp)
    800016ce:	6161                	addi	sp,sp,80
    800016d0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d2:	85e2                	mv	a1,s8
    800016d4:	854a                	mv	a0,s2
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	e7e080e7          	jalr	-386(ra) # 80001554 <sleep>
    havekids = 0;
    800016de:	b715                	j	80001602 <wait+0x4a>

00000000800016e0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e0:	7139                	addi	sp,sp,-64
    800016e2:	fc06                	sd	ra,56(sp)
    800016e4:	f822                	sd	s0,48(sp)
    800016e6:	f426                	sd	s1,40(sp)
    800016e8:	f04a                	sd	s2,32(sp)
    800016ea:	ec4e                	sd	s3,24(sp)
    800016ec:	e852                	sd	s4,16(sp)
    800016ee:	e456                	sd	s5,8(sp)
    800016f0:	0080                	addi	s0,sp,64
    800016f2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	00008497          	auipc	s1,0x8
    800016f8:	d8c48493          	addi	s1,s1,-628 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016fe:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001700:	0000e917          	auipc	s2,0xe
    80001704:	38090913          	addi	s2,s2,896 # 8000fa80 <tickslock>
    80001708:	a821                	j	80001720 <wakeup+0x40>
        p->state = RUNNABLE;
    8000170a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	00005097          	auipc	ra,0x5
    80001714:	bdc080e7          	jalr	-1060(ra) # 800062ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001718:	19848493          	addi	s1,s1,408
    8000171c:	03248463          	beq	s1,s2,80001744 <wakeup+0x64>
    if(p != myproc()){
    80001720:	fffff097          	auipc	ra,0xfffff
    80001724:	728080e7          	jalr	1832(ra) # 80000e48 <myproc>
    80001728:	fea488e3          	beq	s1,a0,80001718 <wakeup+0x38>
      acquire(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	b0a080e7          	jalr	-1270(ra) # 80006238 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001736:	4c9c                	lw	a5,24(s1)
    80001738:	fd379be3          	bne	a5,s3,8000170e <wakeup+0x2e>
    8000173c:	709c                	ld	a5,32(s1)
    8000173e:	fd4798e3          	bne	a5,s4,8000170e <wakeup+0x2e>
    80001742:	b7e1                	j	8000170a <wakeup+0x2a>
    }
  }
}
    80001744:	70e2                	ld	ra,56(sp)
    80001746:	7442                	ld	s0,48(sp)
    80001748:	74a2                	ld	s1,40(sp)
    8000174a:	7902                	ld	s2,32(sp)
    8000174c:	69e2                	ld	s3,24(sp)
    8000174e:	6a42                	ld	s4,16(sp)
    80001750:	6aa2                	ld	s5,8(sp)
    80001752:	6121                	addi	sp,sp,64
    80001754:	8082                	ret

0000000080001756 <reparent>:
{
    80001756:	7179                	addi	sp,sp,-48
    80001758:	f406                	sd	ra,40(sp)
    8000175a:	f022                	sd	s0,32(sp)
    8000175c:	ec26                	sd	s1,24(sp)
    8000175e:	e84a                	sd	s2,16(sp)
    80001760:	e44e                	sd	s3,8(sp)
    80001762:	e052                	sd	s4,0(sp)
    80001764:	1800                	addi	s0,sp,48
    80001766:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001768:	00008497          	auipc	s1,0x8
    8000176c:	d1848493          	addi	s1,s1,-744 # 80009480 <proc>
      pp->parent = initproc;
    80001770:	00008a17          	auipc	s4,0x8
    80001774:	8a0a0a13          	addi	s4,s4,-1888 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001778:	0000e997          	auipc	s3,0xe
    8000177c:	30898993          	addi	s3,s3,776 # 8000fa80 <tickslock>
    80001780:	a029                	j	8000178a <reparent+0x34>
    80001782:	19848493          	addi	s1,s1,408
    80001786:	01348d63          	beq	s1,s3,800017a0 <reparent+0x4a>
    if(pp->parent == p){
    8000178a:	7c9c                	ld	a5,56(s1)
    8000178c:	ff279be3          	bne	a5,s2,80001782 <reparent+0x2c>
      pp->parent = initproc;
    80001790:	000a3503          	ld	a0,0(s4)
    80001794:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	f4a080e7          	jalr	-182(ra) # 800016e0 <wakeup>
    8000179e:	b7d5                	j	80001782 <reparent+0x2c>
}
    800017a0:	70a2                	ld	ra,40(sp)
    800017a2:	7402                	ld	s0,32(sp)
    800017a4:	64e2                	ld	s1,24(sp)
    800017a6:	6942                	ld	s2,16(sp)
    800017a8:	69a2                	ld	s3,8(sp)
    800017aa:	6a02                	ld	s4,0(sp)
    800017ac:	6145                	addi	sp,sp,48
    800017ae:	8082                	ret

00000000800017b0 <exit>:
{
    800017b0:	7179                	addi	sp,sp,-48
    800017b2:	f406                	sd	ra,40(sp)
    800017b4:	f022                	sd	s0,32(sp)
    800017b6:	ec26                	sd	s1,24(sp)
    800017b8:	e84a                	sd	s2,16(sp)
    800017ba:	e44e                	sd	s3,8(sp)
    800017bc:	e052                	sd	s4,0(sp)
    800017be:	1800                	addi	s0,sp,48
    800017c0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c2:	fffff097          	auipc	ra,0xfffff
    800017c6:	686080e7          	jalr	1670(ra) # 80000e48 <myproc>
    800017ca:	89aa                	mv	s3,a0
  if(p == initproc)
    800017cc:	00008797          	auipc	a5,0x8
    800017d0:	8447b783          	ld	a5,-1980(a5) # 80009010 <initproc>
    800017d4:	0d050493          	addi	s1,a0,208
    800017d8:	15050913          	addi	s2,a0,336
    800017dc:	02a79363          	bne	a5,a0,80001802 <exit+0x52>
    panic("init exiting");
    800017e0:	00007517          	auipc	a0,0x7
    800017e4:	a0050513          	addi	a0,a0,-1536 # 800081e0 <etext+0x1e0>
    800017e8:	00004097          	auipc	ra,0x4
    800017ec:	530080e7          	jalr	1328(ra) # 80005d18 <panic>
      fileclose(f);
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	270080e7          	jalr	624(ra) # 80003a60 <fileclose>
      p->ofile[fd] = 0;
    800017f8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fc:	04a1                	addi	s1,s1,8
    800017fe:	01248563          	beq	s1,s2,80001808 <exit+0x58>
    if(p->ofile[fd]){
    80001802:	6088                	ld	a0,0(s1)
    80001804:	f575                	bnez	a0,800017f0 <exit+0x40>
    80001806:	bfdd                	j	800017fc <exit+0x4c>
  begin_op();
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	d8c080e7          	jalr	-628(ra) # 80003594 <begin_op>
  iput(p->cwd);
    80001810:	1509b503          	ld	a0,336(s3)
    80001814:	00001097          	auipc	ra,0x1
    80001818:	568080e7          	jalr	1384(ra) # 80002d7c <iput>
  end_op();
    8000181c:	00002097          	auipc	ra,0x2
    80001820:	df8080e7          	jalr	-520(ra) # 80003614 <end_op>
  p->cwd = 0;
    80001824:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001828:	00008497          	auipc	s1,0x8
    8000182c:	84048493          	addi	s1,s1,-1984 # 80009068 <wait_lock>
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	a06080e7          	jalr	-1530(ra) # 80006238 <acquire>
  reparent(p);
    8000183a:	854e                	mv	a0,s3
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	f1a080e7          	jalr	-230(ra) # 80001756 <reparent>
  wakeup(p->parent);
    80001844:	0389b503          	ld	a0,56(s3)
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	e98080e7          	jalr	-360(ra) # 800016e0 <wakeup>
  acquire(&p->lock);
    80001850:	854e                	mv	a0,s3
    80001852:	00005097          	auipc	ra,0x5
    80001856:	9e6080e7          	jalr	-1562(ra) # 80006238 <acquire>
  p->xstate = status;
    8000185a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000185e:	4795                	li	a5,5
    80001860:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	a86080e7          	jalr	-1402(ra) # 800062ec <release>
  sched();
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	bd4080e7          	jalr	-1068(ra) # 80001442 <sched>
  panic("zombie exit");
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	97a50513          	addi	a0,a0,-1670 # 800081f0 <etext+0x1f0>
    8000187e:	00004097          	auipc	ra,0x4
    80001882:	49a080e7          	jalr	1178(ra) # 80005d18 <panic>

0000000080001886 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001886:	7179                	addi	sp,sp,-48
    80001888:	f406                	sd	ra,40(sp)
    8000188a:	f022                	sd	s0,32(sp)
    8000188c:	ec26                	sd	s1,24(sp)
    8000188e:	e84a                	sd	s2,16(sp)
    80001890:	e44e                	sd	s3,8(sp)
    80001892:	1800                	addi	s0,sp,48
    80001894:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001896:	00008497          	auipc	s1,0x8
    8000189a:	bea48493          	addi	s1,s1,-1046 # 80009480 <proc>
    8000189e:	0000e997          	auipc	s3,0xe
    800018a2:	1e298993          	addi	s3,s3,482 # 8000fa80 <tickslock>
    acquire(&p->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	990080e7          	jalr	-1648(ra) # 80006238 <acquire>
    if(p->pid == pid){
    800018b0:	589c                	lw	a5,48(s1)
    800018b2:	01278d63          	beq	a5,s2,800018cc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	a34080e7          	jalr	-1484(ra) # 800062ec <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c0:	19848493          	addi	s1,s1,408
    800018c4:	ff3491e3          	bne	s1,s3,800018a6 <kill+0x20>
  }
  return -1;
    800018c8:	557d                	li	a0,-1
    800018ca:	a829                	j	800018e4 <kill+0x5e>
      p->killed = 1;
    800018cc:	4785                	li	a5,1
    800018ce:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d0:	4c98                	lw	a4,24(s1)
    800018d2:	4789                	li	a5,2
    800018d4:	00f70f63          	beq	a4,a5,800018f2 <kill+0x6c>
      release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	a12080e7          	jalr	-1518(ra) # 800062ec <release>
      return 0;
    800018e2:	4501                	li	a0,0
}
    800018e4:	70a2                	ld	ra,40(sp)
    800018e6:	7402                	ld	s0,32(sp)
    800018e8:	64e2                	ld	s1,24(sp)
    800018ea:	6942                	ld	s2,16(sp)
    800018ec:	69a2                	ld	s3,8(sp)
    800018ee:	6145                	addi	sp,sp,48
    800018f0:	8082                	ret
        p->state = RUNNABLE;
    800018f2:	478d                	li	a5,3
    800018f4:	cc9c                	sw	a5,24(s1)
    800018f6:	b7cd                	j	800018d8 <kill+0x52>

00000000800018f8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018f8:	7179                	addi	sp,sp,-48
    800018fa:	f406                	sd	ra,40(sp)
    800018fc:	f022                	sd	s0,32(sp)
    800018fe:	ec26                	sd	s1,24(sp)
    80001900:	e84a                	sd	s2,16(sp)
    80001902:	e44e                	sd	s3,8(sp)
    80001904:	e052                	sd	s4,0(sp)
    80001906:	1800                	addi	s0,sp,48
    80001908:	84aa                	mv	s1,a0
    8000190a:	892e                	mv	s2,a1
    8000190c:	89b2                	mv	s3,a2
    8000190e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	538080e7          	jalr	1336(ra) # 80000e48 <myproc>
  if(user_dst){
    80001918:	c08d                	beqz	s1,8000193a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191a:	86d2                	mv	a3,s4
    8000191c:	864e                	mv	a2,s3
    8000191e:	85ca                	mv	a1,s2
    80001920:	6928                	ld	a0,80(a0)
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	1e8080e7          	jalr	488(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192a:	70a2                	ld	ra,40(sp)
    8000192c:	7402                	ld	s0,32(sp)
    8000192e:	64e2                	ld	s1,24(sp)
    80001930:	6942                	ld	s2,16(sp)
    80001932:	69a2                	ld	s3,8(sp)
    80001934:	6a02                	ld	s4,0(sp)
    80001936:	6145                	addi	sp,sp,48
    80001938:	8082                	ret
    memmove((char *)dst, src, len);
    8000193a:	000a061b          	sext.w	a2,s4
    8000193e:	85ce                	mv	a1,s3
    80001940:	854a                	mv	a0,s2
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	896080e7          	jalr	-1898(ra) # 800001d8 <memmove>
    return 0;
    8000194a:	8526                	mv	a0,s1
    8000194c:	bff9                	j	8000192a <either_copyout+0x32>

000000008000194e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	e052                	sd	s4,0(sp)
    8000195c:	1800                	addi	s0,sp,48
    8000195e:	892a                	mv	s2,a0
    80001960:	84ae                	mv	s1,a1
    80001962:	89b2                	mv	s3,a2
    80001964:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	4e2080e7          	jalr	1250(ra) # 80000e48 <myproc>
  if(user_src){
    8000196e:	c08d                	beqz	s1,80001990 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001970:	86d2                	mv	a3,s4
    80001972:	864e                	mv	a2,s3
    80001974:	85ca                	mv	a1,s2
    80001976:	6928                	ld	a0,80(a0)
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	21e080e7          	jalr	542(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6942                	ld	s2,16(sp)
    80001988:	69a2                	ld	s3,8(sp)
    8000198a:	6a02                	ld	s4,0(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001990:	000a061b          	sext.w	a2,s4
    80001994:	85ce                	mv	a1,s3
    80001996:	854a                	mv	a0,s2
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	840080e7          	jalr	-1984(ra) # 800001d8 <memmove>
    return 0;
    800019a0:	8526                	mv	a0,s1
    800019a2:	bff9                	j	80001980 <either_copyin+0x32>

00000000800019a4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a4:	715d                	addi	sp,sp,-80
    800019a6:	e486                	sd	ra,72(sp)
    800019a8:	e0a2                	sd	s0,64(sp)
    800019aa:	fc26                	sd	s1,56(sp)
    800019ac:	f84a                	sd	s2,48(sp)
    800019ae:	f44e                	sd	s3,40(sp)
    800019b0:	f052                	sd	s4,32(sp)
    800019b2:	ec56                	sd	s5,24(sp)
    800019b4:	e85a                	sd	s6,16(sp)
    800019b6:	e45e                	sd	s7,8(sp)
    800019b8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ba:	00006517          	auipc	a0,0x6
    800019be:	68e50513          	addi	a0,a0,1678 # 80008048 <etext+0x48>
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	3a8080e7          	jalr	936(ra) # 80005d6a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	00008497          	auipc	s1,0x8
    800019ce:	c0e48493          	addi	s1,s1,-1010 # 800095d8 <proc+0x158>
    800019d2:	0000e917          	auipc	s2,0xe
    800019d6:	20690913          	addi	s2,s2,518 # 8000fbd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019da:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019dc:	00007997          	auipc	s3,0x7
    800019e0:	82498993          	addi	s3,s3,-2012 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e4:	00007a97          	auipc	s5,0x7
    800019e8:	824a8a93          	addi	s5,s5,-2012 # 80008208 <etext+0x208>
    printf("\n");
    800019ec:	00006a17          	auipc	s4,0x6
    800019f0:	65ca0a13          	addi	s4,s4,1628 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f4:	00007b97          	auipc	s7,0x7
    800019f8:	84cb8b93          	addi	s7,s7,-1972 # 80008240 <states.1720>
    800019fc:	a00d                	j	80001a1e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019fe:	ed86a583          	lw	a1,-296(a3)
    80001a02:	8556                	mv	a0,s5
    80001a04:	00004097          	auipc	ra,0x4
    80001a08:	366080e7          	jalr	870(ra) # 80005d6a <printf>
    printf("\n");
    80001a0c:	8552                	mv	a0,s4
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	35c080e7          	jalr	860(ra) # 80005d6a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a16:	19848493          	addi	s1,s1,408
    80001a1a:	03248163          	beq	s1,s2,80001a3c <procdump+0x98>
    if(p->state == UNUSED)
    80001a1e:	86a6                	mv	a3,s1
    80001a20:	ec04a783          	lw	a5,-320(s1)
    80001a24:	dbed                	beqz	a5,80001a16 <procdump+0x72>
      state = "???";
    80001a26:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a28:	fcfb6be3          	bltu	s6,a5,800019fe <procdump+0x5a>
    80001a2c:	1782                	slli	a5,a5,0x20
    80001a2e:	9381                	srli	a5,a5,0x20
    80001a30:	078e                	slli	a5,a5,0x3
    80001a32:	97de                	add	a5,a5,s7
    80001a34:	6390                	ld	a2,0(a5)
    80001a36:	f661                	bnez	a2,800019fe <procdump+0x5a>
      state = "???";
    80001a38:	864e                	mv	a2,s3
    80001a3a:	b7d1                	j	800019fe <procdump+0x5a>
  }
}
    80001a3c:	60a6                	ld	ra,72(sp)
    80001a3e:	6406                	ld	s0,64(sp)
    80001a40:	74e2                	ld	s1,56(sp)
    80001a42:	7942                	ld	s2,48(sp)
    80001a44:	79a2                	ld	s3,40(sp)
    80001a46:	7a02                	ld	s4,32(sp)
    80001a48:	6ae2                	ld	s5,24(sp)
    80001a4a:	6b42                	ld	s6,16(sp)
    80001a4c:	6ba2                	ld	s7,8(sp)
    80001a4e:	6161                	addi	sp,sp,80
    80001a50:	8082                	ret

0000000080001a52 <swtch>:
    80001a52:	00153023          	sd	ra,0(a0)
    80001a56:	00253423          	sd	sp,8(a0)
    80001a5a:	e900                	sd	s0,16(a0)
    80001a5c:	ed04                	sd	s1,24(a0)
    80001a5e:	03253023          	sd	s2,32(a0)
    80001a62:	03353423          	sd	s3,40(a0)
    80001a66:	03453823          	sd	s4,48(a0)
    80001a6a:	03553c23          	sd	s5,56(a0)
    80001a6e:	05653023          	sd	s6,64(a0)
    80001a72:	05753423          	sd	s7,72(a0)
    80001a76:	05853823          	sd	s8,80(a0)
    80001a7a:	05953c23          	sd	s9,88(a0)
    80001a7e:	07a53023          	sd	s10,96(a0)
    80001a82:	07b53423          	sd	s11,104(a0)
    80001a86:	0005b083          	ld	ra,0(a1)
    80001a8a:	0085b103          	ld	sp,8(a1)
    80001a8e:	6980                	ld	s0,16(a1)
    80001a90:	6d84                	ld	s1,24(a1)
    80001a92:	0205b903          	ld	s2,32(a1)
    80001a96:	0285b983          	ld	s3,40(a1)
    80001a9a:	0305ba03          	ld	s4,48(a1)
    80001a9e:	0385ba83          	ld	s5,56(a1)
    80001aa2:	0405bb03          	ld	s6,64(a1)
    80001aa6:	0485bb83          	ld	s7,72(a1)
    80001aaa:	0505bc03          	ld	s8,80(a1)
    80001aae:	0585bc83          	ld	s9,88(a1)
    80001ab2:	0605bd03          	ld	s10,96(a1)
    80001ab6:	0685bd83          	ld	s11,104(a1)
    80001aba:	8082                	ret

0000000080001abc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001abc:	1141                	addi	sp,sp,-16
    80001abe:	e406                	sd	ra,8(sp)
    80001ac0:	e022                	sd	s0,0(sp)
    80001ac2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ac4:	00006597          	auipc	a1,0x6
    80001ac8:	7ac58593          	addi	a1,a1,1964 # 80008270 <states.1720+0x30>
    80001acc:	0000e517          	auipc	a0,0xe
    80001ad0:	fb450513          	addi	a0,a0,-76 # 8000fa80 <tickslock>
    80001ad4:	00004097          	auipc	ra,0x4
    80001ad8:	6d4080e7          	jalr	1748(ra) # 800061a8 <initlock>
}
    80001adc:	60a2                	ld	ra,8(sp)
    80001ade:	6402                	ld	s0,0(sp)
    80001ae0:	0141                	addi	sp,sp,16
    80001ae2:	8082                	ret

0000000080001ae4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ae4:	1141                	addi	sp,sp,-16
    80001ae6:	e422                	sd	s0,8(sp)
    80001ae8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aea:	00003797          	auipc	a5,0x3
    80001aee:	59678793          	addi	a5,a5,1430 # 80005080 <kernelvec>
    80001af2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001af6:	6422                	ld	s0,8(sp)
    80001af8:	0141                	addi	sp,sp,16
    80001afa:	8082                	ret

0000000080001afc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001afc:	1141                	addi	sp,sp,-16
    80001afe:	e406                	sd	ra,8(sp)
    80001b00:	e022                	sd	s0,0(sp)
    80001b02:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	344080e7          	jalr	836(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b12:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b16:	00005617          	auipc	a2,0x5
    80001b1a:	4ea60613          	addi	a2,a2,1258 # 80007000 <_trampoline>
    80001b1e:	00005697          	auipc	a3,0x5
    80001b22:	4e268693          	addi	a3,a3,1250 # 80007000 <_trampoline>
    80001b26:	8e91                	sub	a3,a3,a2
    80001b28:	040007b7          	lui	a5,0x4000
    80001b2c:	17fd                	addi	a5,a5,-1
    80001b2e:	07b2                	slli	a5,a5,0xc
    80001b30:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b32:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b36:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b38:	180026f3          	csrr	a3,satp
    80001b3c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b3e:	6d38                	ld	a4,88(a0)
    80001b40:	6134                	ld	a3,64(a0)
    80001b42:	6585                	lui	a1,0x1
    80001b44:	96ae                	add	a3,a3,a1
    80001b46:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b48:	6d38                	ld	a4,88(a0)
    80001b4a:	00000697          	auipc	a3,0x0
    80001b4e:	13868693          	addi	a3,a3,312 # 80001c82 <usertrap>
    80001b52:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b54:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b56:	8692                	mv	a3,tp
    80001b58:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b5e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b62:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b66:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b6a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b6c:	6f18                	ld	a4,24(a4)
    80001b6e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b72:	692c                	ld	a1,80(a0)
    80001b74:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b76:	00005717          	auipc	a4,0x5
    80001b7a:	51a70713          	addi	a4,a4,1306 # 80007090 <userret>
    80001b7e:	8f11                	sub	a4,a4,a2
    80001b80:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b82:	577d                	li	a4,-1
    80001b84:	177e                	slli	a4,a4,0x3f
    80001b86:	8dd9                	or	a1,a1,a4
    80001b88:	02000537          	lui	a0,0x2000
    80001b8c:	157d                	addi	a0,a0,-1
    80001b8e:	0536                	slli	a0,a0,0xd
    80001b90:	9782                	jalr	a5
}
    80001b92:	60a2                	ld	ra,8(sp)
    80001b94:	6402                	ld	s0,0(sp)
    80001b96:	0141                	addi	sp,sp,16
    80001b98:	8082                	ret

0000000080001b9a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9a:	1101                	addi	sp,sp,-32
    80001b9c:	ec06                	sd	ra,24(sp)
    80001b9e:	e822                	sd	s0,16(sp)
    80001ba0:	e426                	sd	s1,8(sp)
    80001ba2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba4:	0000e497          	auipc	s1,0xe
    80001ba8:	edc48493          	addi	s1,s1,-292 # 8000fa80 <tickslock>
    80001bac:	8526                	mv	a0,s1
    80001bae:	00004097          	auipc	ra,0x4
    80001bb2:	68a080e7          	jalr	1674(ra) # 80006238 <acquire>
  ticks++;
    80001bb6:	00007517          	auipc	a0,0x7
    80001bba:	46250513          	addi	a0,a0,1122 # 80009018 <ticks>
    80001bbe:	411c                	lw	a5,0(a0)
    80001bc0:	2785                	addiw	a5,a5,1
    80001bc2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc4:	00000097          	auipc	ra,0x0
    80001bc8:	b1c080e7          	jalr	-1252(ra) # 800016e0 <wakeup>
  release(&tickslock);
    80001bcc:	8526                	mv	a0,s1
    80001bce:	00004097          	auipc	ra,0x4
    80001bd2:	71e080e7          	jalr	1822(ra) # 800062ec <release>
}
    80001bd6:	60e2                	ld	ra,24(sp)
    80001bd8:	6442                	ld	s0,16(sp)
    80001bda:	64a2                	ld	s1,8(sp)
    80001bdc:	6105                	addi	sp,sp,32
    80001bde:	8082                	ret

0000000080001be0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be0:	1101                	addi	sp,sp,-32
    80001be2:	ec06                	sd	ra,24(sp)
    80001be4:	e822                	sd	s0,16(sp)
    80001be6:	e426                	sd	s1,8(sp)
    80001be8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bea:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bee:	00074d63          	bltz	a4,80001c08 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf2:	57fd                	li	a5,-1
    80001bf4:	17fe                	slli	a5,a5,0x3f
    80001bf6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bf8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfa:	06f70363          	beq	a4,a5,80001c60 <devintr+0x80>
  }
}
    80001bfe:	60e2                	ld	ra,24(sp)
    80001c00:	6442                	ld	s0,16(sp)
    80001c02:	64a2                	ld	s1,8(sp)
    80001c04:	6105                	addi	sp,sp,32
    80001c06:	8082                	ret
     (scause & 0xff) == 9){
    80001c08:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c0c:	46a5                	li	a3,9
    80001c0e:	fed792e3          	bne	a5,a3,80001bf2 <devintr+0x12>
    int irq = plic_claim();
    80001c12:	00003097          	auipc	ra,0x3
    80001c16:	576080e7          	jalr	1398(ra) # 80005188 <plic_claim>
    80001c1a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1c:	47a9                	li	a5,10
    80001c1e:	02f50763          	beq	a0,a5,80001c4c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c22:	4785                	li	a5,1
    80001c24:	02f50963          	beq	a0,a5,80001c56 <devintr+0x76>
    return 1;
    80001c28:	4505                	li	a0,1
    } else if(irq){
    80001c2a:	d8f1                	beqz	s1,80001bfe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2c:	85a6                	mv	a1,s1
    80001c2e:	00006517          	auipc	a0,0x6
    80001c32:	64a50513          	addi	a0,a0,1610 # 80008278 <states.1720+0x38>
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	134080e7          	jalr	308(ra) # 80005d6a <printf>
      plic_complete(irq);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00003097          	auipc	ra,0x3
    80001c44:	56c080e7          	jalr	1388(ra) # 800051ac <plic_complete>
    return 1;
    80001c48:	4505                	li	a0,1
    80001c4a:	bf55                	j	80001bfe <devintr+0x1e>
      uartintr();
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	50c080e7          	jalr	1292(ra) # 80006158 <uartintr>
    80001c54:	b7ed                	j	80001c3e <devintr+0x5e>
      virtio_disk_intr();
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	a36080e7          	jalr	-1482(ra) # 8000568c <virtio_disk_intr>
    80001c5e:	b7c5                	j	80001c3e <devintr+0x5e>
    if(cpuid() == 0){
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	1bc080e7          	jalr	444(ra) # 80000e1c <cpuid>
    80001c68:	c901                	beqz	a0,80001c78 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c70:	14479073          	csrw	sip,a5
    return 2;
    80001c74:	4509                	li	a0,2
    80001c76:	b761                	j	80001bfe <devintr+0x1e>
      clockintr();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f22080e7          	jalr	-222(ra) # 80001b9a <clockintr>
    80001c80:	b7ed                	j	80001c6a <devintr+0x8a>

0000000080001c82 <usertrap>:
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c92:	1007f793          	andi	a5,a5,256
    80001c96:	e3ad                	bnez	a5,80001cf8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c98:	00003797          	auipc	a5,0x3
    80001c9c:	3e878793          	addi	a5,a5,1000 # 80005080 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	1a4080e7          	jalr	420(ra) # 80000e48 <myproc>
    80001cac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb0:	14102773          	csrr	a4,sepc
    80001cb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cba:	47a1                	li	a5,8
    80001cbc:	04f71c63          	bne	a4,a5,80001d14 <usertrap+0x92>
    if(p->killed)
    80001cc0:	551c                	lw	a5,40(a0)
    80001cc2:	e3b9                	bnez	a5,80001d08 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cc4:	6cb8                	ld	a4,88(s1)
    80001cc6:	6f1c                	ld	a5,24(a4)
    80001cc8:	0791                	addi	a5,a5,4
    80001cca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cd0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10079073          	csrw	sstatus,a5
    syscall();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	33e080e7          	jalr	830(ra) # 80002016 <syscall>
  if(p->killed)
    80001ce0:	549c                	lw	a5,40(s1)
    80001ce2:	e7fd                	bnez	a5,80001dd0 <usertrap+0x14e>
  usertrapret();
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	e18080e7          	jalr	-488(ra) # 80001afc <usertrapret>
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	64a2                	ld	s1,8(sp)
    80001cf2:	6902                	ld	s2,0(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret
    panic("usertrap: not from user mode");
    80001cf8:	00006517          	auipc	a0,0x6
    80001cfc:	5a050513          	addi	a0,a0,1440 # 80008298 <states.1720+0x58>
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	018080e7          	jalr	24(ra) # 80005d18 <panic>
      exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	aa6080e7          	jalr	-1370(ra) # 800017b0 <exit>
    80001d12:	bf4d                	j	80001cc4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	ecc080e7          	jalr	-308(ra) # 80001be0 <devintr>
    80001d1c:	892a                	mv	s2,a0
    80001d1e:	c501                	beqz	a0,80001d26 <usertrap+0xa4>
  if(p->killed)
    80001d20:	549c                	lw	a5,40(s1)
    80001d22:	c3a1                	beqz	a5,80001d62 <usertrap+0xe0>
    80001d24:	a815                	j	80001d58 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d26:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d2a:	5890                	lw	a2,48(s1)
    80001d2c:	00006517          	auipc	a0,0x6
    80001d30:	58c50513          	addi	a0,a0,1420 # 800082b8 <states.1720+0x78>
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	036080e7          	jalr	54(ra) # 80005d6a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d40:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d44:	00006517          	auipc	a0,0x6
    80001d48:	5a450513          	addi	a0,a0,1444 # 800082e8 <states.1720+0xa8>
    80001d4c:	00004097          	auipc	ra,0x4
    80001d50:	01e080e7          	jalr	30(ra) # 80005d6a <printf>
    p->killed = 1;
    80001d54:	4785                	li	a5,1
    80001d56:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d58:	557d                	li	a0,-1
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	a56080e7          	jalr	-1450(ra) # 800017b0 <exit>
  if(which_dev == 2)
    80001d62:	4789                	li	a5,2
    80001d64:	f8f910e3          	bne	s2,a5,80001ce4 <usertrap+0x62>
    if(p->interval > 0)
    80001d68:	1684a703          	lw	a4,360(s1)
    80001d6c:	04e05d63          	blez	a4,80001dc6 <usertrap+0x144>
      p->ticks_cnt++;
    80001d70:	1784a783          	lw	a5,376(s1)
    80001d74:	2785                	addiw	a5,a5,1
    80001d76:	0007869b          	sext.w	a3,a5
    80001d7a:	16f4ac23          	sw	a5,376(s1)
      if(p->handler_exec == 0 && p->ticks_cnt > p->interval)
    80001d7e:	1904a783          	lw	a5,400(s1)
    80001d82:	e3b1                	bnez	a5,80001dc6 <usertrap+0x144>
    80001d84:	04d75163          	bge	a4,a3,80001dc6 <usertrap+0x144>
        p->ticks_cnt = 0;
    80001d88:	1604ac23          	sw	zero,376(s1)
        *(p->tick_trapframe) = *(p->trapframe);
    80001d8c:	6cb4                	ld	a3,88(s1)
    80001d8e:	87b6                	mv	a5,a3
    80001d90:	1884b703          	ld	a4,392(s1)
    80001d94:	12068693          	addi	a3,a3,288
    80001d98:	0007b803          	ld	a6,0(a5)
    80001d9c:	6788                	ld	a0,8(a5)
    80001d9e:	6b8c                	ld	a1,16(a5)
    80001da0:	6f90                	ld	a2,24(a5)
    80001da2:	01073023          	sd	a6,0(a4)
    80001da6:	e708                	sd	a0,8(a4)
    80001da8:	eb0c                	sd	a1,16(a4)
    80001daa:	ef10                	sd	a2,24(a4)
    80001dac:	02078793          	addi	a5,a5,32
    80001db0:	02070713          	addi	a4,a4,32
    80001db4:	fed792e3          	bne	a5,a3,80001d98 <usertrap+0x116>
        p->handler_exec = 1;
    80001db8:	4785                	li	a5,1
    80001dba:	18f4a823          	sw	a5,400(s1)
        p->trapframe->epc = p->handler;
    80001dbe:	6cbc                	ld	a5,88(s1)
    80001dc0:	1704b703          	ld	a4,368(s1)
    80001dc4:	ef98                	sd	a4,24(a5)
    yield();
    80001dc6:	fffff097          	auipc	ra,0xfffff
    80001dca:	752080e7          	jalr	1874(ra) # 80001518 <yield>
    80001dce:	bf19                	j	80001ce4 <usertrap+0x62>
  int which_dev = 0;
    80001dd0:	4901                	li	s2,0
    80001dd2:	b759                	j	80001d58 <usertrap+0xd6>

0000000080001dd4 <kerneltrap>:
{
    80001dd4:	7179                	addi	sp,sp,-48
    80001dd6:	f406                	sd	ra,40(sp)
    80001dd8:	f022                	sd	s0,32(sp)
    80001dda:	ec26                	sd	s1,24(sp)
    80001ddc:	e84a                	sd	s2,16(sp)
    80001dde:	e44e                	sd	s3,8(sp)
    80001de0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dee:	1004f793          	andi	a5,s1,256
    80001df2:	cb85                	beqz	a5,80001e22 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dfa:	ef85                	bnez	a5,80001e32 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	de4080e7          	jalr	-540(ra) # 80001be0 <devintr>
    80001e04:	cd1d                	beqz	a0,80001e42 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e06:	4789                	li	a5,2
    80001e08:	06f50a63          	beq	a0,a5,80001e7c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e0c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e10:	10049073          	csrw	sstatus,s1
}
    80001e14:	70a2                	ld	ra,40(sp)
    80001e16:	7402                	ld	s0,32(sp)
    80001e18:	64e2                	ld	s1,24(sp)
    80001e1a:	6942                	ld	s2,16(sp)
    80001e1c:	69a2                	ld	s3,8(sp)
    80001e1e:	6145                	addi	sp,sp,48
    80001e20:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	4e650513          	addi	a0,a0,1254 # 80008308 <states.1720+0xc8>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	eee080e7          	jalr	-274(ra) # 80005d18 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e32:	00006517          	auipc	a0,0x6
    80001e36:	4fe50513          	addi	a0,a0,1278 # 80008330 <states.1720+0xf0>
    80001e3a:	00004097          	auipc	ra,0x4
    80001e3e:	ede080e7          	jalr	-290(ra) # 80005d18 <panic>
    printf("scause %p\n", scause);
    80001e42:	85ce                	mv	a1,s3
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	50c50513          	addi	a0,a0,1292 # 80008350 <states.1720+0x110>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	f1e080e7          	jalr	-226(ra) # 80005d6a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e58:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5c:	00006517          	auipc	a0,0x6
    80001e60:	50450513          	addi	a0,a0,1284 # 80008360 <states.1720+0x120>
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	f06080e7          	jalr	-250(ra) # 80005d6a <printf>
    panic("kerneltrap");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	50c50513          	addi	a0,a0,1292 # 80008378 <states.1720+0x138>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	ea4080e7          	jalr	-348(ra) # 80005d18 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	fcc080e7          	jalr	-52(ra) # 80000e48 <myproc>
    80001e84:	d541                	beqz	a0,80001e0c <kerneltrap+0x38>
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	fc2080e7          	jalr	-62(ra) # 80000e48 <myproc>
    80001e8e:	4d18                	lw	a4,24(a0)
    80001e90:	4791                	li	a5,4
    80001e92:	f6f71de3          	bne	a4,a5,80001e0c <kerneltrap+0x38>
    yield();
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	682080e7          	jalr	1666(ra) # 80001518 <yield>
    80001e9e:	b7bd                	j	80001e0c <kerneltrap+0x38>

0000000080001ea0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea0:	1101                	addi	sp,sp,-32
    80001ea2:	ec06                	sd	ra,24(sp)
    80001ea4:	e822                	sd	s0,16(sp)
    80001ea6:	e426                	sd	s1,8(sp)
    80001ea8:	1000                	addi	s0,sp,32
    80001eaa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	f9c080e7          	jalr	-100(ra) # 80000e48 <myproc>
  switch (n) {
    80001eb4:	4795                	li	a5,5
    80001eb6:	0497e163          	bltu	a5,s1,80001ef8 <argraw+0x58>
    80001eba:	048a                	slli	s1,s1,0x2
    80001ebc:	00006717          	auipc	a4,0x6
    80001ec0:	4f470713          	addi	a4,a4,1268 # 800083b0 <states.1720+0x170>
    80001ec4:	94ba                	add	s1,s1,a4
    80001ec6:	409c                	lw	a5,0(s1)
    80001ec8:	97ba                	add	a5,a5,a4
    80001eca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed0:	60e2                	ld	ra,24(sp)
    80001ed2:	6442                	ld	s0,16(sp)
    80001ed4:	64a2                	ld	s1,8(sp)
    80001ed6:	6105                	addi	sp,sp,32
    80001ed8:	8082                	ret
    return p->trapframe->a1;
    80001eda:	6d3c                	ld	a5,88(a0)
    80001edc:	7fa8                	ld	a0,120(a5)
    80001ede:	bfcd                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a2;
    80001ee0:	6d3c                	ld	a5,88(a0)
    80001ee2:	63c8                	ld	a0,128(a5)
    80001ee4:	b7f5                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a3;
    80001ee6:	6d3c                	ld	a5,88(a0)
    80001ee8:	67c8                	ld	a0,136(a5)
    80001eea:	b7dd                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a4;
    80001eec:	6d3c                	ld	a5,88(a0)
    80001eee:	6bc8                	ld	a0,144(a5)
    80001ef0:	b7c5                	j	80001ed0 <argraw+0x30>
    return p->trapframe->a5;
    80001ef2:	6d3c                	ld	a5,88(a0)
    80001ef4:	6fc8                	ld	a0,152(a5)
    80001ef6:	bfe9                	j	80001ed0 <argraw+0x30>
  panic("argraw");
    80001ef8:	00006517          	auipc	a0,0x6
    80001efc:	49050513          	addi	a0,a0,1168 # 80008388 <states.1720+0x148>
    80001f00:	00004097          	auipc	ra,0x4
    80001f04:	e18080e7          	jalr	-488(ra) # 80005d18 <panic>

0000000080001f08 <fetchaddr>:
{
    80001f08:	1101                	addi	sp,sp,-32
    80001f0a:	ec06                	sd	ra,24(sp)
    80001f0c:	e822                	sd	s0,16(sp)
    80001f0e:	e426                	sd	s1,8(sp)
    80001f10:	e04a                	sd	s2,0(sp)
    80001f12:	1000                	addi	s0,sp,32
    80001f14:	84aa                	mv	s1,a0
    80001f16:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	f30080e7          	jalr	-208(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f20:	653c                	ld	a5,72(a0)
    80001f22:	02f4f863          	bgeu	s1,a5,80001f52 <fetchaddr+0x4a>
    80001f26:	00848713          	addi	a4,s1,8
    80001f2a:	02e7e663          	bltu	a5,a4,80001f56 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f2e:	46a1                	li	a3,8
    80001f30:	8626                	mv	a2,s1
    80001f32:	85ca                	mv	a1,s2
    80001f34:	6928                	ld	a0,80(a0)
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	c60080e7          	jalr	-928(ra) # 80000b96 <copyin>
    80001f3e:	00a03533          	snez	a0,a0
    80001f42:	40a00533          	neg	a0,a0
}
    80001f46:	60e2                	ld	ra,24(sp)
    80001f48:	6442                	ld	s0,16(sp)
    80001f4a:	64a2                	ld	s1,8(sp)
    80001f4c:	6902                	ld	s2,0(sp)
    80001f4e:	6105                	addi	sp,sp,32
    80001f50:	8082                	ret
    return -1;
    80001f52:	557d                	li	a0,-1
    80001f54:	bfcd                	j	80001f46 <fetchaddr+0x3e>
    80001f56:	557d                	li	a0,-1
    80001f58:	b7fd                	j	80001f46 <fetchaddr+0x3e>

0000000080001f5a <fetchstr>:
{
    80001f5a:	7179                	addi	sp,sp,-48
    80001f5c:	f406                	sd	ra,40(sp)
    80001f5e:	f022                	sd	s0,32(sp)
    80001f60:	ec26                	sd	s1,24(sp)
    80001f62:	e84a                	sd	s2,16(sp)
    80001f64:	e44e                	sd	s3,8(sp)
    80001f66:	1800                	addi	s0,sp,48
    80001f68:	892a                	mv	s2,a0
    80001f6a:	84ae                	mv	s1,a1
    80001f6c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	eda080e7          	jalr	-294(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f76:	86ce                	mv	a3,s3
    80001f78:	864a                	mv	a2,s2
    80001f7a:	85a6                	mv	a1,s1
    80001f7c:	6928                	ld	a0,80(a0)
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	ca4080e7          	jalr	-860(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f86:	00054763          	bltz	a0,80001f94 <fetchstr+0x3a>
  return strlen(buf);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	ffffe097          	auipc	ra,0xffffe
    80001f90:	370080e7          	jalr	880(ra) # 800002fc <strlen>
}
    80001f94:	70a2                	ld	ra,40(sp)
    80001f96:	7402                	ld	s0,32(sp)
    80001f98:	64e2                	ld	s1,24(sp)
    80001f9a:	6942                	ld	s2,16(sp)
    80001f9c:	69a2                	ld	s3,8(sp)
    80001f9e:	6145                	addi	sp,sp,48
    80001fa0:	8082                	ret

0000000080001fa2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa2:	1101                	addi	sp,sp,-32
    80001fa4:	ec06                	sd	ra,24(sp)
    80001fa6:	e822                	sd	s0,16(sp)
    80001fa8:	e426                	sd	s1,8(sp)
    80001faa:	1000                	addi	s0,sp,32
    80001fac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	ef2080e7          	jalr	-270(ra) # 80001ea0 <argraw>
    80001fb6:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb8:	4501                	li	a0,0
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6105                	addi	sp,sp,32
    80001fc2:	8082                	ret

0000000080001fc4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc4:	1101                	addi	sp,sp,-32
    80001fc6:	ec06                	sd	ra,24(sp)
    80001fc8:	e822                	sd	s0,16(sp)
    80001fca:	e426                	sd	s1,8(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	ed0080e7          	jalr	-304(ra) # 80001ea0 <argraw>
    80001fd8:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fda:	4501                	li	a0,0
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	addi	s0,sp,32
    80001ff2:	84ae                	mv	s1,a1
    80001ff4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	eaa080e7          	jalr	-342(ra) # 80001ea0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ffe:	864a                	mv	a2,s2
    80002000:	85a6                	mv	a1,s1
    80002002:	00000097          	auipc	ra,0x0
    80002006:	f58080e7          	jalr	-168(ra) # 80001f5a <fetchstr>
}
    8000200a:	60e2                	ld	ra,24(sp)
    8000200c:	6442                	ld	s0,16(sp)
    8000200e:	64a2                	ld	s1,8(sp)
    80002010:	6902                	ld	s2,0(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	e04a                	sd	s2,0(sp)
    80002020:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	e26080e7          	jalr	-474(ra) # 80000e48 <myproc>
    8000202a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000202c:	05853903          	ld	s2,88(a0)
    80002030:	0a893783          	ld	a5,168(s2)
    80002034:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002038:	37fd                	addiw	a5,a5,-1
    8000203a:	4759                	li	a4,22
    8000203c:	00f76f63          	bltu	a4,a5,8000205a <syscall+0x44>
    80002040:	00369713          	slli	a4,a3,0x3
    80002044:	00006797          	auipc	a5,0x6
    80002048:	38478793          	addi	a5,a5,900 # 800083c8 <syscalls>
    8000204c:	97ba                	add	a5,a5,a4
    8000204e:	639c                	ld	a5,0(a5)
    80002050:	c789                	beqz	a5,8000205a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002052:	9782                	jalr	a5
    80002054:	06a93823          	sd	a0,112(s2)
    80002058:	a839                	j	80002076 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000205a:	15848613          	addi	a2,s1,344
    8000205e:	588c                	lw	a1,48(s1)
    80002060:	00006517          	auipc	a0,0x6
    80002064:	33050513          	addi	a0,a0,816 # 80008390 <states.1720+0x150>
    80002068:	00004097          	auipc	ra,0x4
    8000206c:	d02080e7          	jalr	-766(ra) # 80005d6a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002070:	6cbc                	ld	a5,88(s1)
    80002072:	577d                	li	a4,-1
    80002074:	fbb8                	sd	a4,112(a5)
  }
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6902                	ld	s2,0(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret

0000000080002082 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000208a:	fec40593          	addi	a1,s0,-20
    8000208e:	4501                	li	a0,0
    80002090:	00000097          	auipc	ra,0x0
    80002094:	f12080e7          	jalr	-238(ra) # 80001fa2 <argint>
    return -1;
    80002098:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000209a:	00054963          	bltz	a0,800020ac <sys_exit+0x2a>
  exit(n);
    8000209e:	fec42503          	lw	a0,-20(s0)
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	70e080e7          	jalr	1806(ra) # 800017b0 <exit>
  return 0;  // not reached
    800020aa:	4781                	li	a5,0
}
    800020ac:	853e                	mv	a0,a5
    800020ae:	60e2                	ld	ra,24(sp)
    800020b0:	6442                	ld	s0,16(sp)
    800020b2:	6105                	addi	sp,sp,32
    800020b4:	8082                	ret

00000000800020b6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020b6:	1141                	addi	sp,sp,-16
    800020b8:	e406                	sd	ra,8(sp)
    800020ba:	e022                	sd	s0,0(sp)
    800020bc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	d8a080e7          	jalr	-630(ra) # 80000e48 <myproc>
}
    800020c6:	5908                	lw	a0,48(a0)
    800020c8:	60a2                	ld	ra,8(sp)
    800020ca:	6402                	ld	s0,0(sp)
    800020cc:	0141                	addi	sp,sp,16
    800020ce:	8082                	ret

00000000800020d0 <sys_fork>:

uint64
sys_fork(void)
{
    800020d0:	1141                	addi	sp,sp,-16
    800020d2:	e406                	sd	ra,8(sp)
    800020d4:	e022                	sd	s0,0(sp)
    800020d6:	0800                	addi	s0,sp,16
  return fork();
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	18e080e7          	jalr	398(ra) # 80001266 <fork>
}
    800020e0:	60a2                	ld	ra,8(sp)
    800020e2:	6402                	ld	s0,0(sp)
    800020e4:	0141                	addi	sp,sp,16
    800020e6:	8082                	ret

00000000800020e8 <sys_wait>:

uint64
sys_wait(void)
{
    800020e8:	1101                	addi	sp,sp,-32
    800020ea:	ec06                	sd	ra,24(sp)
    800020ec:	e822                	sd	s0,16(sp)
    800020ee:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020f0:	fe840593          	addi	a1,s0,-24
    800020f4:	4501                	li	a0,0
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	ece080e7          	jalr	-306(ra) # 80001fc4 <argaddr>
    800020fe:	87aa                	mv	a5,a0
    return -1;
    80002100:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002102:	0007c863          	bltz	a5,80002112 <sys_wait+0x2a>
  return wait(p);
    80002106:	fe843503          	ld	a0,-24(s0)
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	4ae080e7          	jalr	1198(ra) # 800015b8 <wait>
}
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	6105                	addi	sp,sp,32
    80002118:	8082                	ret

000000008000211a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000211a:	7179                	addi	sp,sp,-48
    8000211c:	f406                	sd	ra,40(sp)
    8000211e:	f022                	sd	s0,32(sp)
    80002120:	ec26                	sd	s1,24(sp)
    80002122:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002124:	fdc40593          	addi	a1,s0,-36
    80002128:	4501                	li	a0,0
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	e78080e7          	jalr	-392(ra) # 80001fa2 <argint>
    80002132:	87aa                	mv	a5,a0
    return -1;
    80002134:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002136:	0207c063          	bltz	a5,80002156 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	d0e080e7          	jalr	-754(ra) # 80000e48 <myproc>
    80002142:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002144:	fdc42503          	lw	a0,-36(s0)
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	0aa080e7          	jalr	170(ra) # 800011f2 <growproc>
    80002150:	00054863          	bltz	a0,80002160 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002154:	8526                	mv	a0,s1
}
    80002156:	70a2                	ld	ra,40(sp)
    80002158:	7402                	ld	s0,32(sp)
    8000215a:	64e2                	ld	s1,24(sp)
    8000215c:	6145                	addi	sp,sp,48
    8000215e:	8082                	ret
    return -1;
    80002160:	557d                	li	a0,-1
    80002162:	bfd5                	j	80002156 <sys_sbrk+0x3c>

0000000080002164 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002164:	7139                	addi	sp,sp,-64
    80002166:	fc06                	sd	ra,56(sp)
    80002168:	f822                	sd	s0,48(sp)
    8000216a:	f426                	sd	s1,40(sp)
    8000216c:	f04a                	sd	s2,32(sp)
    8000216e:	ec4e                	sd	s3,24(sp)
    80002170:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002172:	fcc40593          	addi	a1,s0,-52
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	e2a080e7          	jalr	-470(ra) # 80001fa2 <argint>
    return -1;
    80002180:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002182:	06054963          	bltz	a0,800021f4 <sys_sleep+0x90>
  acquire(&tickslock);
    80002186:	0000e517          	auipc	a0,0xe
    8000218a:	8fa50513          	addi	a0,a0,-1798 # 8000fa80 <tickslock>
    8000218e:	00004097          	auipc	ra,0x4
    80002192:	0aa080e7          	jalr	170(ra) # 80006238 <acquire>
  ticks0 = ticks;
    80002196:	00007917          	auipc	s2,0x7
    8000219a:	e8292903          	lw	s2,-382(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000219e:	fcc42783          	lw	a5,-52(s0)
    800021a2:	cf85                	beqz	a5,800021da <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021a4:	0000e997          	auipc	s3,0xe
    800021a8:	8dc98993          	addi	s3,s3,-1828 # 8000fa80 <tickslock>
    800021ac:	00007497          	auipc	s1,0x7
    800021b0:	e6c48493          	addi	s1,s1,-404 # 80009018 <ticks>
    if(myproc()->killed){
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	c94080e7          	jalr	-876(ra) # 80000e48 <myproc>
    800021bc:	551c                	lw	a5,40(a0)
    800021be:	e3b9                	bnez	a5,80002204 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021c0:	85ce                	mv	a1,s3
    800021c2:	8526                	mv	a0,s1
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	390080e7          	jalr	912(ra) # 80001554 <sleep>
  while(ticks - ticks0 < n){
    800021cc:	409c                	lw	a5,0(s1)
    800021ce:	412787bb          	subw	a5,a5,s2
    800021d2:	fcc42703          	lw	a4,-52(s0)
    800021d6:	fce7efe3          	bltu	a5,a4,800021b4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021da:	0000e517          	auipc	a0,0xe
    800021de:	8a650513          	addi	a0,a0,-1882 # 8000fa80 <tickslock>
    800021e2:	00004097          	auipc	ra,0x4
    800021e6:	10a080e7          	jalr	266(ra) # 800062ec <release>
  backtrace(); 
    800021ea:	00004097          	auipc	ra,0x4
    800021ee:	ac0080e7          	jalr	-1344(ra) # 80005caa <backtrace>
  return 0;
    800021f2:	4781                	li	a5,0
}
    800021f4:	853e                	mv	a0,a5
    800021f6:	70e2                	ld	ra,56(sp)
    800021f8:	7442                	ld	s0,48(sp)
    800021fa:	74a2                	ld	s1,40(sp)
    800021fc:	7902                	ld	s2,32(sp)
    800021fe:	69e2                	ld	s3,24(sp)
    80002200:	6121                	addi	sp,sp,64
    80002202:	8082                	ret
      release(&tickslock);
    80002204:	0000e517          	auipc	a0,0xe
    80002208:	87c50513          	addi	a0,a0,-1924 # 8000fa80 <tickslock>
    8000220c:	00004097          	auipc	ra,0x4
    80002210:	0e0080e7          	jalr	224(ra) # 800062ec <release>
      return -1;
    80002214:	57fd                	li	a5,-1
    80002216:	bff9                	j	800021f4 <sys_sleep+0x90>

0000000080002218 <sys_kill>:

uint64
sys_kill(void)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002220:	fec40593          	addi	a1,s0,-20
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	d7c080e7          	jalr	-644(ra) # 80001fa2 <argint>
    8000222e:	87aa                	mv	a5,a0
    return -1;
    80002230:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002232:	0007c863          	bltz	a5,80002242 <sys_kill+0x2a>
  return kill(pid);
    80002236:	fec42503          	lw	a0,-20(s0)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	64c080e7          	jalr	1612(ra) # 80001886 <kill>
}
    80002242:	60e2                	ld	ra,24(sp)
    80002244:	6442                	ld	s0,16(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002254:	0000e517          	auipc	a0,0xe
    80002258:	82c50513          	addi	a0,a0,-2004 # 8000fa80 <tickslock>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	fdc080e7          	jalr	-36(ra) # 80006238 <acquire>
  xticks = ticks;
    80002264:	00007497          	auipc	s1,0x7
    80002268:	db44a483          	lw	s1,-588(s1) # 80009018 <ticks>
  release(&tickslock);
    8000226c:	0000e517          	auipc	a0,0xe
    80002270:	81450513          	addi	a0,a0,-2028 # 8000fa80 <tickslock>
    80002274:	00004097          	auipc	ra,0x4
    80002278:	078080e7          	jalr	120(ra) # 800062ec <release>
  return xticks;
}
    8000227c:	02049513          	slli	a0,s1,0x20
    80002280:	9101                	srli	a0,a0,0x20
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	64a2                	ld	s1,8(sp)
    80002288:	6105                	addi	sp,sp,32
    8000228a:	8082                	ret

000000008000228c <sys_sigalarm>:

uint64 sys_sigalarm(void)
{
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;

  struct proc *p;
  if(argint(0, &interval)<0 || argaddr(1, &handler)<0) 
    80002294:	fec40593          	addi	a1,s0,-20
    80002298:	4501                	li	a0,0
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	d08080e7          	jalr	-760(ra) # 80001fa2 <argint>
    return -1;
    800022a2:	57fd                	li	a5,-1
  if(argint(0, &interval)<0 || argaddr(1, &handler)<0) 
    800022a4:	02054b63          	bltz	a0,800022da <sys_sigalarm+0x4e>
    800022a8:	fe040593          	addi	a1,s0,-32
    800022ac:	4505                	li	a0,1
    800022ae:	00000097          	auipc	ra,0x0
    800022b2:	d16080e7          	jalr	-746(ra) # 80001fc4 <argaddr>
    return -1;
    800022b6:	57fd                	li	a5,-1
  if(argint(0, &interval)<0 || argaddr(1, &handler)<0) 
    800022b8:	02054163          	bltz	a0,800022da <sys_sigalarm+0x4e>
  p = myproc();
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	b8c080e7          	jalr	-1140(ra) # 80000e48 <myproc>

  p->interval = interval;
    800022c4:	fec42783          	lw	a5,-20(s0)
    800022c8:	16f52423          	sw	a5,360(a0)
  p->handler = handler;
    800022cc:	fe043783          	ld	a5,-32(s0)
    800022d0:	16f53823          	sd	a5,368(a0)
  p->ticks_cnt = 0;
    800022d4:	16052c23          	sw	zero,376(a0)

  return 0;
    800022d8:	4781                	li	a5,0
} 
    800022da:	853e                	mv	a0,a5
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	6105                	addi	sp,sp,32
    800022e2:	8082                	ret

00000000800022e4 <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    800022e4:	1141                	addi	sp,sp,-16
    800022e6:	e406                	sd	ra,8(sp)
    800022e8:	e022                	sd	s0,0(sp)
    800022ea:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	b5c080e7          	jalr	-1188(ra) # 80000e48 <myproc>
  *(p->trapframe) = *(p->tick_trapframe);
    800022f4:	18853683          	ld	a3,392(a0)
    800022f8:	87b6                	mv	a5,a3
    800022fa:	6d38                	ld	a4,88(a0)
    800022fc:	12068693          	addi	a3,a3,288
    80002300:	0007b883          	ld	a7,0(a5)
    80002304:	0087b803          	ld	a6,8(a5)
    80002308:	6b8c                	ld	a1,16(a5)
    8000230a:	6f90                	ld	a2,24(a5)
    8000230c:	01173023          	sd	a7,0(a4)
    80002310:	01073423          	sd	a6,8(a4)
    80002314:	eb0c                	sd	a1,16(a4)
    80002316:	ef10                	sd	a2,24(a4)
    80002318:	02078793          	addi	a5,a5,32
    8000231c:	02070713          	addi	a4,a4,32
    80002320:	fed790e3          	bne	a5,a3,80002300 <sys_sigreturn+0x1c>
  p->handler_exec = 0;
    80002324:	18052823          	sw	zero,400(a0)
  return 0;
    80002328:	4501                	li	a0,0
    8000232a:	60a2                	ld	ra,8(sp)
    8000232c:	6402                	ld	s0,0(sp)
    8000232e:	0141                	addi	sp,sp,16
    80002330:	8082                	ret

0000000080002332 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002332:	7179                	addi	sp,sp,-48
    80002334:	f406                	sd	ra,40(sp)
    80002336:	f022                	sd	s0,32(sp)
    80002338:	ec26                	sd	s1,24(sp)
    8000233a:	e84a                	sd	s2,16(sp)
    8000233c:	e44e                	sd	s3,8(sp)
    8000233e:	e052                	sd	s4,0(sp)
    80002340:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002342:	00006597          	auipc	a1,0x6
    80002346:	14658593          	addi	a1,a1,326 # 80008488 <syscalls+0xc0>
    8000234a:	0000d517          	auipc	a0,0xd
    8000234e:	74e50513          	addi	a0,a0,1870 # 8000fa98 <bcache>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	e56080e7          	jalr	-426(ra) # 800061a8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000235a:	00015797          	auipc	a5,0x15
    8000235e:	73e78793          	addi	a5,a5,1854 # 80017a98 <bcache+0x8000>
    80002362:	00016717          	auipc	a4,0x16
    80002366:	99e70713          	addi	a4,a4,-1634 # 80017d00 <bcache+0x8268>
    8000236a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000236e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002372:	0000d497          	auipc	s1,0xd
    80002376:	73e48493          	addi	s1,s1,1854 # 8000fab0 <bcache+0x18>
    b->next = bcache.head.next;
    8000237a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000237c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000237e:	00006a17          	auipc	s4,0x6
    80002382:	112a0a13          	addi	s4,s4,274 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002386:	2b893783          	ld	a5,696(s2)
    8000238a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000238c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002390:	85d2                	mv	a1,s4
    80002392:	01048513          	addi	a0,s1,16
    80002396:	00001097          	auipc	ra,0x1
    8000239a:	4bc080e7          	jalr	1212(ra) # 80003852 <initsleeplock>
    bcache.head.next->prev = b;
    8000239e:	2b893783          	ld	a5,696(s2)
    800023a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a8:	45848493          	addi	s1,s1,1112
    800023ac:	fd349de3          	bne	s1,s3,80002386 <binit+0x54>
  }
}
    800023b0:	70a2                	ld	ra,40(sp)
    800023b2:	7402                	ld	s0,32(sp)
    800023b4:	64e2                	ld	s1,24(sp)
    800023b6:	6942                	ld	s2,16(sp)
    800023b8:	69a2                	ld	s3,8(sp)
    800023ba:	6a02                	ld	s4,0(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret

00000000800023c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	1800                	addi	s0,sp,48
    800023ce:	89aa                	mv	s3,a0
    800023d0:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023d2:	0000d517          	auipc	a0,0xd
    800023d6:	6c650513          	addi	a0,a0,1734 # 8000fa98 <bcache>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	e5e080e7          	jalr	-418(ra) # 80006238 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023e2:	00016497          	auipc	s1,0x16
    800023e6:	96e4b483          	ld	s1,-1682(s1) # 80017d50 <bcache+0x82b8>
    800023ea:	00016797          	auipc	a5,0x16
    800023ee:	91678793          	addi	a5,a5,-1770 # 80017d00 <bcache+0x8268>
    800023f2:	02f48f63          	beq	s1,a5,80002430 <bread+0x70>
    800023f6:	873e                	mv	a4,a5
    800023f8:	a021                	j	80002400 <bread+0x40>
    800023fa:	68a4                	ld	s1,80(s1)
    800023fc:	02e48a63          	beq	s1,a4,80002430 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002400:	449c                	lw	a5,8(s1)
    80002402:	ff379ce3          	bne	a5,s3,800023fa <bread+0x3a>
    80002406:	44dc                	lw	a5,12(s1)
    80002408:	ff2799e3          	bne	a5,s2,800023fa <bread+0x3a>
      b->refcnt++;
    8000240c:	40bc                	lw	a5,64(s1)
    8000240e:	2785                	addiw	a5,a5,1
    80002410:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002412:	0000d517          	auipc	a0,0xd
    80002416:	68650513          	addi	a0,a0,1670 # 8000fa98 <bcache>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	ed2080e7          	jalr	-302(ra) # 800062ec <release>
      acquiresleep(&b->lock);
    80002422:	01048513          	addi	a0,s1,16
    80002426:	00001097          	auipc	ra,0x1
    8000242a:	466080e7          	jalr	1126(ra) # 8000388c <acquiresleep>
      return b;
    8000242e:	a8b9                	j	8000248c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002430:	00016497          	auipc	s1,0x16
    80002434:	9184b483          	ld	s1,-1768(s1) # 80017d48 <bcache+0x82b0>
    80002438:	00016797          	auipc	a5,0x16
    8000243c:	8c878793          	addi	a5,a5,-1848 # 80017d00 <bcache+0x8268>
    80002440:	00f48863          	beq	s1,a5,80002450 <bread+0x90>
    80002444:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	cf81                	beqz	a5,80002460 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244a:	64a4                	ld	s1,72(s1)
    8000244c:	fee49de3          	bne	s1,a4,80002446 <bread+0x86>
  panic("bget: no buffers");
    80002450:	00006517          	auipc	a0,0x6
    80002454:	04850513          	addi	a0,a0,72 # 80008498 <syscalls+0xd0>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	8c0080e7          	jalr	-1856(ra) # 80005d18 <panic>
      b->dev = dev;
    80002460:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002464:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002468:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000246c:	4785                	li	a5,1
    8000246e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002470:	0000d517          	auipc	a0,0xd
    80002474:	62850513          	addi	a0,a0,1576 # 8000fa98 <bcache>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	e74080e7          	jalr	-396(ra) # 800062ec <release>
      acquiresleep(&b->lock);
    80002480:	01048513          	addi	a0,s1,16
    80002484:	00001097          	auipc	ra,0x1
    80002488:	408080e7          	jalr	1032(ra) # 8000388c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000248c:	409c                	lw	a5,0(s1)
    8000248e:	cb89                	beqz	a5,800024a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002490:	8526                	mv	a0,s1
    80002492:	70a2                	ld	ra,40(sp)
    80002494:	7402                	ld	s0,32(sp)
    80002496:	64e2                	ld	s1,24(sp)
    80002498:	6942                	ld	s2,16(sp)
    8000249a:	69a2                	ld	s3,8(sp)
    8000249c:	6145                	addi	sp,sp,48
    8000249e:	8082                	ret
    virtio_disk_rw(b, 0);
    800024a0:	4581                	li	a1,0
    800024a2:	8526                	mv	a0,s1
    800024a4:	00003097          	auipc	ra,0x3
    800024a8:	f12080e7          	jalr	-238(ra) # 800053b6 <virtio_disk_rw>
    b->valid = 1;
    800024ac:	4785                	li	a5,1
    800024ae:	c09c                	sw	a5,0(s1)
  return b;
    800024b0:	b7c5                	j	80002490 <bread+0xd0>

00000000800024b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	e426                	sd	s1,8(sp)
    800024ba:	1000                	addi	s0,sp,32
    800024bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024be:	0541                	addi	a0,a0,16
    800024c0:	00001097          	auipc	ra,0x1
    800024c4:	466080e7          	jalr	1126(ra) # 80003926 <holdingsleep>
    800024c8:	cd01                	beqz	a0,800024e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ca:	4585                	li	a1,1
    800024cc:	8526                	mv	a0,s1
    800024ce:	00003097          	auipc	ra,0x3
    800024d2:	ee8080e7          	jalr	-280(ra) # 800053b6 <virtio_disk_rw>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret
    panic("bwrite");
    800024e0:	00006517          	auipc	a0,0x6
    800024e4:	fd050513          	addi	a0,a0,-48 # 800084b0 <syscalls+0xe8>
    800024e8:	00004097          	auipc	ra,0x4
    800024ec:	830080e7          	jalr	-2000(ra) # 80005d18 <panic>

00000000800024f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024f0:	1101                	addi	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	e426                	sd	s1,8(sp)
    800024f8:	e04a                	sd	s2,0(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fe:	01050913          	addi	s2,a0,16
    80002502:	854a                	mv	a0,s2
    80002504:	00001097          	auipc	ra,0x1
    80002508:	422080e7          	jalr	1058(ra) # 80003926 <holdingsleep>
    8000250c:	c92d                	beqz	a0,8000257e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000250e:	854a                	mv	a0,s2
    80002510:	00001097          	auipc	ra,0x1
    80002514:	3d2080e7          	jalr	978(ra) # 800038e2 <releasesleep>

  acquire(&bcache.lock);
    80002518:	0000d517          	auipc	a0,0xd
    8000251c:	58050513          	addi	a0,a0,1408 # 8000fa98 <bcache>
    80002520:	00004097          	auipc	ra,0x4
    80002524:	d18080e7          	jalr	-744(ra) # 80006238 <acquire>
  b->refcnt--;
    80002528:	40bc                	lw	a5,64(s1)
    8000252a:	37fd                	addiw	a5,a5,-1
    8000252c:	0007871b          	sext.w	a4,a5
    80002530:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002532:	eb05                	bnez	a4,80002562 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002534:	68bc                	ld	a5,80(s1)
    80002536:	64b8                	ld	a4,72(s1)
    80002538:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000253a:	64bc                	ld	a5,72(s1)
    8000253c:	68b8                	ld	a4,80(s1)
    8000253e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002540:	00015797          	auipc	a5,0x15
    80002544:	55878793          	addi	a5,a5,1368 # 80017a98 <bcache+0x8000>
    80002548:	2b87b703          	ld	a4,696(a5)
    8000254c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000254e:	00015717          	auipc	a4,0x15
    80002552:	7b270713          	addi	a4,a4,1970 # 80017d00 <bcache+0x8268>
    80002556:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002558:	2b87b703          	ld	a4,696(a5)
    8000255c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000255e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002562:	0000d517          	auipc	a0,0xd
    80002566:	53650513          	addi	a0,a0,1334 # 8000fa98 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	d82080e7          	jalr	-638(ra) # 800062ec <release>
}
    80002572:	60e2                	ld	ra,24(sp)
    80002574:	6442                	ld	s0,16(sp)
    80002576:	64a2                	ld	s1,8(sp)
    80002578:	6902                	ld	s2,0(sp)
    8000257a:	6105                	addi	sp,sp,32
    8000257c:	8082                	ret
    panic("brelse");
    8000257e:	00006517          	auipc	a0,0x6
    80002582:	f3a50513          	addi	a0,a0,-198 # 800084b8 <syscalls+0xf0>
    80002586:	00003097          	auipc	ra,0x3
    8000258a:	792080e7          	jalr	1938(ra) # 80005d18 <panic>

000000008000258e <bpin>:

void
bpin(struct buf *b) {
    8000258e:	1101                	addi	sp,sp,-32
    80002590:	ec06                	sd	ra,24(sp)
    80002592:	e822                	sd	s0,16(sp)
    80002594:	e426                	sd	s1,8(sp)
    80002596:	1000                	addi	s0,sp,32
    80002598:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000259a:	0000d517          	auipc	a0,0xd
    8000259e:	4fe50513          	addi	a0,a0,1278 # 8000fa98 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	c96080e7          	jalr	-874(ra) # 80006238 <acquire>
  b->refcnt++;
    800025aa:	40bc                	lw	a5,64(s1)
    800025ac:	2785                	addiw	a5,a5,1
    800025ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025b0:	0000d517          	auipc	a0,0xd
    800025b4:	4e850513          	addi	a0,a0,1256 # 8000fa98 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	d34080e7          	jalr	-716(ra) # 800062ec <release>
}
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6105                	addi	sp,sp,32
    800025c8:	8082                	ret

00000000800025ca <bunpin>:

void
bunpin(struct buf *b) {
    800025ca:	1101                	addi	sp,sp,-32
    800025cc:	ec06                	sd	ra,24(sp)
    800025ce:	e822                	sd	s0,16(sp)
    800025d0:	e426                	sd	s1,8(sp)
    800025d2:	1000                	addi	s0,sp,32
    800025d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d6:	0000d517          	auipc	a0,0xd
    800025da:	4c250513          	addi	a0,a0,1218 # 8000fa98 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	c5a080e7          	jalr	-934(ra) # 80006238 <acquire>
  b->refcnt--;
    800025e6:	40bc                	lw	a5,64(s1)
    800025e8:	37fd                	addiw	a5,a5,-1
    800025ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ec:	0000d517          	auipc	a0,0xd
    800025f0:	4ac50513          	addi	a0,a0,1196 # 8000fa98 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	cf8080e7          	jalr	-776(ra) # 800062ec <release>
}
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6105                	addi	sp,sp,32
    80002604:	8082                	ret

0000000080002606 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	e04a                	sd	s2,0(sp)
    80002610:	1000                	addi	s0,sp,32
    80002612:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002614:	00d5d59b          	srliw	a1,a1,0xd
    80002618:	00016797          	auipc	a5,0x16
    8000261c:	b5c7a783          	lw	a5,-1188(a5) # 80018174 <sb+0x1c>
    80002620:	9dbd                	addw	a1,a1,a5
    80002622:	00000097          	auipc	ra,0x0
    80002626:	d9e080e7          	jalr	-610(ra) # 800023c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000262a:	0074f713          	andi	a4,s1,7
    8000262e:	4785                	li	a5,1
    80002630:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002634:	14ce                	slli	s1,s1,0x33
    80002636:	90d9                	srli	s1,s1,0x36
    80002638:	00950733          	add	a4,a0,s1
    8000263c:	05874703          	lbu	a4,88(a4)
    80002640:	00e7f6b3          	and	a3,a5,a4
    80002644:	c69d                	beqz	a3,80002672 <bfree+0x6c>
    80002646:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002648:	94aa                	add	s1,s1,a0
    8000264a:	fff7c793          	not	a5,a5
    8000264e:	8ff9                	and	a5,a5,a4
    80002650:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002654:	00001097          	auipc	ra,0x1
    80002658:	118080e7          	jalr	280(ra) # 8000376c <log_write>
  brelse(bp);
    8000265c:	854a                	mv	a0,s2
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	e92080e7          	jalr	-366(ra) # 800024f0 <brelse>
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	64a2                	ld	s1,8(sp)
    8000266c:	6902                	ld	s2,0(sp)
    8000266e:	6105                	addi	sp,sp,32
    80002670:	8082                	ret
    panic("freeing free block");
    80002672:	00006517          	auipc	a0,0x6
    80002676:	e4e50513          	addi	a0,a0,-434 # 800084c0 <syscalls+0xf8>
    8000267a:	00003097          	auipc	ra,0x3
    8000267e:	69e080e7          	jalr	1694(ra) # 80005d18 <panic>

0000000080002682 <balloc>:
{
    80002682:	711d                	addi	sp,sp,-96
    80002684:	ec86                	sd	ra,88(sp)
    80002686:	e8a2                	sd	s0,80(sp)
    80002688:	e4a6                	sd	s1,72(sp)
    8000268a:	e0ca                	sd	s2,64(sp)
    8000268c:	fc4e                	sd	s3,56(sp)
    8000268e:	f852                	sd	s4,48(sp)
    80002690:	f456                	sd	s5,40(sp)
    80002692:	f05a                	sd	s6,32(sp)
    80002694:	ec5e                	sd	s7,24(sp)
    80002696:	e862                	sd	s8,16(sp)
    80002698:	e466                	sd	s9,8(sp)
    8000269a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000269c:	00016797          	auipc	a5,0x16
    800026a0:	ac07a783          	lw	a5,-1344(a5) # 8001815c <sb+0x4>
    800026a4:	cbd1                	beqz	a5,80002738 <balloc+0xb6>
    800026a6:	8baa                	mv	s7,a0
    800026a8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026aa:	00016b17          	auipc	s6,0x16
    800026ae:	aaeb0b13          	addi	s6,s6,-1362 # 80018158 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026b4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026b8:	6c89                	lui	s9,0x2
    800026ba:	a831                	j	800026d6 <balloc+0x54>
    brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	e32080e7          	jalr	-462(ra) # 800024f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026c6:	015c87bb          	addw	a5,s9,s5
    800026ca:	00078a9b          	sext.w	s5,a5
    800026ce:	004b2703          	lw	a4,4(s6)
    800026d2:	06eaf363          	bgeu	s5,a4,80002738 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026d6:	41fad79b          	sraiw	a5,s5,0x1f
    800026da:	0137d79b          	srliw	a5,a5,0x13
    800026de:	015787bb          	addw	a5,a5,s5
    800026e2:	40d7d79b          	sraiw	a5,a5,0xd
    800026e6:	01cb2583          	lw	a1,28(s6)
    800026ea:	9dbd                	addw	a1,a1,a5
    800026ec:	855e                	mv	a0,s7
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	cd2080e7          	jalr	-814(ra) # 800023c0 <bread>
    800026f6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f8:	004b2503          	lw	a0,4(s6)
    800026fc:	000a849b          	sext.w	s1,s5
    80002700:	8662                	mv	a2,s8
    80002702:	faa4fde3          	bgeu	s1,a0,800026bc <balloc+0x3a>
      m = 1 << (bi % 8);
    80002706:	41f6579b          	sraiw	a5,a2,0x1f
    8000270a:	01d7d69b          	srliw	a3,a5,0x1d
    8000270e:	00c6873b          	addw	a4,a3,a2
    80002712:	00777793          	andi	a5,a4,7
    80002716:	9f95                	subw	a5,a5,a3
    80002718:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000271c:	4037571b          	sraiw	a4,a4,0x3
    80002720:	00e906b3          	add	a3,s2,a4
    80002724:	0586c683          	lbu	a3,88(a3)
    80002728:	00d7f5b3          	and	a1,a5,a3
    8000272c:	cd91                	beqz	a1,80002748 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272e:	2605                	addiw	a2,a2,1
    80002730:	2485                	addiw	s1,s1,1
    80002732:	fd4618e3          	bne	a2,s4,80002702 <balloc+0x80>
    80002736:	b759                	j	800026bc <balloc+0x3a>
  panic("balloc: out of blocks");
    80002738:	00006517          	auipc	a0,0x6
    8000273c:	da050513          	addi	a0,a0,-608 # 800084d8 <syscalls+0x110>
    80002740:	00003097          	auipc	ra,0x3
    80002744:	5d8080e7          	jalr	1496(ra) # 80005d18 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002748:	974a                	add	a4,a4,s2
    8000274a:	8fd5                	or	a5,a5,a3
    8000274c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	01a080e7          	jalr	26(ra) # 8000376c <log_write>
        brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	d94080e7          	jalr	-620(ra) # 800024f0 <brelse>
  bp = bread(dev, bno);
    80002764:	85a6                	mv	a1,s1
    80002766:	855e                	mv	a0,s7
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	c58080e7          	jalr	-936(ra) # 800023c0 <bread>
    80002770:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002772:	40000613          	li	a2,1024
    80002776:	4581                	li	a1,0
    80002778:	05850513          	addi	a0,a0,88
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	9fc080e7          	jalr	-1540(ra) # 80000178 <memset>
  log_write(bp);
    80002784:	854a                	mv	a0,s2
    80002786:	00001097          	auipc	ra,0x1
    8000278a:	fe6080e7          	jalr	-26(ra) # 8000376c <log_write>
  brelse(bp);
    8000278e:	854a                	mv	a0,s2
    80002790:	00000097          	auipc	ra,0x0
    80002794:	d60080e7          	jalr	-672(ra) # 800024f0 <brelse>
}
    80002798:	8526                	mv	a0,s1
    8000279a:	60e6                	ld	ra,88(sp)
    8000279c:	6446                	ld	s0,80(sp)
    8000279e:	64a6                	ld	s1,72(sp)
    800027a0:	6906                	ld	s2,64(sp)
    800027a2:	79e2                	ld	s3,56(sp)
    800027a4:	7a42                	ld	s4,48(sp)
    800027a6:	7aa2                	ld	s5,40(sp)
    800027a8:	7b02                	ld	s6,32(sp)
    800027aa:	6be2                	ld	s7,24(sp)
    800027ac:	6c42                	ld	s8,16(sp)
    800027ae:	6ca2                	ld	s9,8(sp)
    800027b0:	6125                	addi	sp,sp,96
    800027b2:	8082                	ret

00000000800027b4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027b4:	7179                	addi	sp,sp,-48
    800027b6:	f406                	sd	ra,40(sp)
    800027b8:	f022                	sd	s0,32(sp)
    800027ba:	ec26                	sd	s1,24(sp)
    800027bc:	e84a                	sd	s2,16(sp)
    800027be:	e44e                	sd	s3,8(sp)
    800027c0:	e052                	sd	s4,0(sp)
    800027c2:	1800                	addi	s0,sp,48
    800027c4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027c6:	47ad                	li	a5,11
    800027c8:	04b7fe63          	bgeu	a5,a1,80002824 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027cc:	ff45849b          	addiw	s1,a1,-12
    800027d0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027d4:	0ff00793          	li	a5,255
    800027d8:	0ae7e363          	bltu	a5,a4,8000287e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027dc:	08052583          	lw	a1,128(a0)
    800027e0:	c5ad                	beqz	a1,8000284a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027e2:	00092503          	lw	a0,0(s2)
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	bda080e7          	jalr	-1062(ra) # 800023c0 <bread>
    800027ee:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027f0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027f4:	02049593          	slli	a1,s1,0x20
    800027f8:	9181                	srli	a1,a1,0x20
    800027fa:	058a                	slli	a1,a1,0x2
    800027fc:	00b784b3          	add	s1,a5,a1
    80002800:	0004a983          	lw	s3,0(s1)
    80002804:	04098d63          	beqz	s3,8000285e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002808:	8552                	mv	a0,s4
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	ce6080e7          	jalr	-794(ra) # 800024f0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002812:	854e                	mv	a0,s3
    80002814:	70a2                	ld	ra,40(sp)
    80002816:	7402                	ld	s0,32(sp)
    80002818:	64e2                	ld	s1,24(sp)
    8000281a:	6942                	ld	s2,16(sp)
    8000281c:	69a2                	ld	s3,8(sp)
    8000281e:	6a02                	ld	s4,0(sp)
    80002820:	6145                	addi	sp,sp,48
    80002822:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002824:	02059493          	slli	s1,a1,0x20
    80002828:	9081                	srli	s1,s1,0x20
    8000282a:	048a                	slli	s1,s1,0x2
    8000282c:	94aa                	add	s1,s1,a0
    8000282e:	0504a983          	lw	s3,80(s1)
    80002832:	fe0990e3          	bnez	s3,80002812 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002836:	4108                	lw	a0,0(a0)
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	e4a080e7          	jalr	-438(ra) # 80002682 <balloc>
    80002840:	0005099b          	sext.w	s3,a0
    80002844:	0534a823          	sw	s3,80(s1)
    80002848:	b7e9                	j	80002812 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000284a:	4108                	lw	a0,0(a0)
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	e36080e7          	jalr	-458(ra) # 80002682 <balloc>
    80002854:	0005059b          	sext.w	a1,a0
    80002858:	08b92023          	sw	a1,128(s2)
    8000285c:	b759                	j	800027e2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000285e:	00092503          	lw	a0,0(s2)
    80002862:	00000097          	auipc	ra,0x0
    80002866:	e20080e7          	jalr	-480(ra) # 80002682 <balloc>
    8000286a:	0005099b          	sext.w	s3,a0
    8000286e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002872:	8552                	mv	a0,s4
    80002874:	00001097          	auipc	ra,0x1
    80002878:	ef8080e7          	jalr	-264(ra) # 8000376c <log_write>
    8000287c:	b771                	j	80002808 <bmap+0x54>
  panic("bmap: out of range");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	c7250513          	addi	a0,a0,-910 # 800084f0 <syscalls+0x128>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	492080e7          	jalr	1170(ra) # 80005d18 <panic>

000000008000288e <iget>:
{
    8000288e:	7179                	addi	sp,sp,-48
    80002890:	f406                	sd	ra,40(sp)
    80002892:	f022                	sd	s0,32(sp)
    80002894:	ec26                	sd	s1,24(sp)
    80002896:	e84a                	sd	s2,16(sp)
    80002898:	e44e                	sd	s3,8(sp)
    8000289a:	e052                	sd	s4,0(sp)
    8000289c:	1800                	addi	s0,sp,48
    8000289e:	89aa                	mv	s3,a0
    800028a0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a2:	00016517          	auipc	a0,0x16
    800028a6:	8d650513          	addi	a0,a0,-1834 # 80018178 <itable>
    800028aa:	00004097          	auipc	ra,0x4
    800028ae:	98e080e7          	jalr	-1650(ra) # 80006238 <acquire>
  empty = 0;
    800028b2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b4:	00016497          	auipc	s1,0x16
    800028b8:	8dc48493          	addi	s1,s1,-1828 # 80018190 <itable+0x18>
    800028bc:	00017697          	auipc	a3,0x17
    800028c0:	36468693          	addi	a3,a3,868 # 80019c20 <log>
    800028c4:	a039                	j	800028d2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c6:	02090b63          	beqz	s2,800028fc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ca:	08848493          	addi	s1,s1,136
    800028ce:	02d48a63          	beq	s1,a3,80002902 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d2:	449c                	lw	a5,8(s1)
    800028d4:	fef059e3          	blez	a5,800028c6 <iget+0x38>
    800028d8:	4098                	lw	a4,0(s1)
    800028da:	ff3716e3          	bne	a4,s3,800028c6 <iget+0x38>
    800028de:	40d8                	lw	a4,4(s1)
    800028e0:	ff4713e3          	bne	a4,s4,800028c6 <iget+0x38>
      ip->ref++;
    800028e4:	2785                	addiw	a5,a5,1
    800028e6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e8:	00016517          	auipc	a0,0x16
    800028ec:	89050513          	addi	a0,a0,-1904 # 80018178 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	9fc080e7          	jalr	-1540(ra) # 800062ec <release>
      return ip;
    800028f8:	8926                	mv	s2,s1
    800028fa:	a03d                	j	80002928 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fc:	f7f9                	bnez	a5,800028ca <iget+0x3c>
    800028fe:	8926                	mv	s2,s1
    80002900:	b7e9                	j	800028ca <iget+0x3c>
  if(empty == 0)
    80002902:	02090c63          	beqz	s2,8000293a <iget+0xac>
  ip->dev = dev;
    80002906:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000290a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000290e:	4785                	li	a5,1
    80002910:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002914:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002918:	00016517          	auipc	a0,0x16
    8000291c:	86050513          	addi	a0,a0,-1952 # 80018178 <itable>
    80002920:	00004097          	auipc	ra,0x4
    80002924:	9cc080e7          	jalr	-1588(ra) # 800062ec <release>
}
    80002928:	854a                	mv	a0,s2
    8000292a:	70a2                	ld	ra,40(sp)
    8000292c:	7402                	ld	s0,32(sp)
    8000292e:	64e2                	ld	s1,24(sp)
    80002930:	6942                	ld	s2,16(sp)
    80002932:	69a2                	ld	s3,8(sp)
    80002934:	6a02                	ld	s4,0(sp)
    80002936:	6145                	addi	sp,sp,48
    80002938:	8082                	ret
    panic("iget: no inodes");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	bce50513          	addi	a0,a0,-1074 # 80008508 <syscalls+0x140>
    80002942:	00003097          	auipc	ra,0x3
    80002946:	3d6080e7          	jalr	982(ra) # 80005d18 <panic>

000000008000294a <fsinit>:
fsinit(int dev) {
    8000294a:	7179                	addi	sp,sp,-48
    8000294c:	f406                	sd	ra,40(sp)
    8000294e:	f022                	sd	s0,32(sp)
    80002950:	ec26                	sd	s1,24(sp)
    80002952:	e84a                	sd	s2,16(sp)
    80002954:	e44e                	sd	s3,8(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295a:	4585                	li	a1,1
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	a64080e7          	jalr	-1436(ra) # 800023c0 <bread>
    80002964:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002966:	00015997          	auipc	s3,0x15
    8000296a:	7f298993          	addi	s3,s3,2034 # 80018158 <sb>
    8000296e:	02000613          	li	a2,32
    80002972:	05850593          	addi	a1,a0,88
    80002976:	854e                	mv	a0,s3
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	860080e7          	jalr	-1952(ra) # 800001d8 <memmove>
  brelse(bp);
    80002980:	8526                	mv	a0,s1
    80002982:	00000097          	auipc	ra,0x0
    80002986:	b6e080e7          	jalr	-1170(ra) # 800024f0 <brelse>
  if(sb.magic != FSMAGIC)
    8000298a:	0009a703          	lw	a4,0(s3)
    8000298e:	102037b7          	lui	a5,0x10203
    80002992:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002996:	02f71263          	bne	a4,a5,800029ba <fsinit+0x70>
  initlog(dev, &sb);
    8000299a:	00015597          	auipc	a1,0x15
    8000299e:	7be58593          	addi	a1,a1,1982 # 80018158 <sb>
    800029a2:	854a                	mv	a0,s2
    800029a4:	00001097          	auipc	ra,0x1
    800029a8:	b4c080e7          	jalr	-1204(ra) # 800034f0 <initlog>
}
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    panic("invalid file system");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	b5e50513          	addi	a0,a0,-1186 # 80008518 <syscalls+0x150>
    800029c2:	00003097          	auipc	ra,0x3
    800029c6:	356080e7          	jalr	854(ra) # 80005d18 <panic>

00000000800029ca <iinit>:
{
    800029ca:	7179                	addi	sp,sp,-48
    800029cc:	f406                	sd	ra,40(sp)
    800029ce:	f022                	sd	s0,32(sp)
    800029d0:	ec26                	sd	s1,24(sp)
    800029d2:	e84a                	sd	s2,16(sp)
    800029d4:	e44e                	sd	s3,8(sp)
    800029d6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d8:	00006597          	auipc	a1,0x6
    800029dc:	b5858593          	addi	a1,a1,-1192 # 80008530 <syscalls+0x168>
    800029e0:	00015517          	auipc	a0,0x15
    800029e4:	79850513          	addi	a0,a0,1944 # 80018178 <itable>
    800029e8:	00003097          	auipc	ra,0x3
    800029ec:	7c0080e7          	jalr	1984(ra) # 800061a8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029f0:	00015497          	auipc	s1,0x15
    800029f4:	7b048493          	addi	s1,s1,1968 # 800181a0 <itable+0x28>
    800029f8:	00017997          	auipc	s3,0x17
    800029fc:	23898993          	addi	s3,s3,568 # 80019c30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a00:	00006917          	auipc	s2,0x6
    80002a04:	b3890913          	addi	s2,s2,-1224 # 80008538 <syscalls+0x170>
    80002a08:	85ca                	mv	a1,s2
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	00001097          	auipc	ra,0x1
    80002a10:	e46080e7          	jalr	-442(ra) # 80003852 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a14:	08848493          	addi	s1,s1,136
    80002a18:	ff3498e3          	bne	s1,s3,80002a08 <iinit+0x3e>
}
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret

0000000080002a2a <ialloc>:
{
    80002a2a:	715d                	addi	sp,sp,-80
    80002a2c:	e486                	sd	ra,72(sp)
    80002a2e:	e0a2                	sd	s0,64(sp)
    80002a30:	fc26                	sd	s1,56(sp)
    80002a32:	f84a                	sd	s2,48(sp)
    80002a34:	f44e                	sd	s3,40(sp)
    80002a36:	f052                	sd	s4,32(sp)
    80002a38:	ec56                	sd	s5,24(sp)
    80002a3a:	e85a                	sd	s6,16(sp)
    80002a3c:	e45e                	sd	s7,8(sp)
    80002a3e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a40:	00015717          	auipc	a4,0x15
    80002a44:	72472703          	lw	a4,1828(a4) # 80018164 <sb+0xc>
    80002a48:	4785                	li	a5,1
    80002a4a:	04e7fa63          	bgeu	a5,a4,80002a9e <ialloc+0x74>
    80002a4e:	8aaa                	mv	s5,a0
    80002a50:	8bae                	mv	s7,a1
    80002a52:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a54:	00015a17          	auipc	s4,0x15
    80002a58:	704a0a13          	addi	s4,s4,1796 # 80018158 <sb>
    80002a5c:	00048b1b          	sext.w	s6,s1
    80002a60:	0044d593          	srli	a1,s1,0x4
    80002a64:	018a2783          	lw	a5,24(s4)
    80002a68:	9dbd                	addw	a1,a1,a5
    80002a6a:	8556                	mv	a0,s5
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	954080e7          	jalr	-1708(ra) # 800023c0 <bread>
    80002a74:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a76:	05850993          	addi	s3,a0,88
    80002a7a:	00f4f793          	andi	a5,s1,15
    80002a7e:	079a                	slli	a5,a5,0x6
    80002a80:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a82:	00099783          	lh	a5,0(s3)
    80002a86:	c785                	beqz	a5,80002aae <ialloc+0x84>
    brelse(bp);
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	a68080e7          	jalr	-1432(ra) # 800024f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a90:	0485                	addi	s1,s1,1
    80002a92:	00ca2703          	lw	a4,12(s4)
    80002a96:	0004879b          	sext.w	a5,s1
    80002a9a:	fce7e1e3          	bltu	a5,a4,80002a5c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	aa250513          	addi	a0,a0,-1374 # 80008540 <syscalls+0x178>
    80002aa6:	00003097          	auipc	ra,0x3
    80002aaa:	272080e7          	jalr	626(ra) # 80005d18 <panic>
      memset(dip, 0, sizeof(*dip));
    80002aae:	04000613          	li	a2,64
    80002ab2:	4581                	li	a1,0
    80002ab4:	854e                	mv	a0,s3
    80002ab6:	ffffd097          	auipc	ra,0xffffd
    80002aba:	6c2080e7          	jalr	1730(ra) # 80000178 <memset>
      dip->type = type;
    80002abe:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ac2:	854a                	mv	a0,s2
    80002ac4:	00001097          	auipc	ra,0x1
    80002ac8:	ca8080e7          	jalr	-856(ra) # 8000376c <log_write>
      brelse(bp);
    80002acc:	854a                	mv	a0,s2
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	a22080e7          	jalr	-1502(ra) # 800024f0 <brelse>
      return iget(dev, inum);
    80002ad6:	85da                	mv	a1,s6
    80002ad8:	8556                	mv	a0,s5
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	db4080e7          	jalr	-588(ra) # 8000288e <iget>
}
    80002ae2:	60a6                	ld	ra,72(sp)
    80002ae4:	6406                	ld	s0,64(sp)
    80002ae6:	74e2                	ld	s1,56(sp)
    80002ae8:	7942                	ld	s2,48(sp)
    80002aea:	79a2                	ld	s3,40(sp)
    80002aec:	7a02                	ld	s4,32(sp)
    80002aee:	6ae2                	ld	s5,24(sp)
    80002af0:	6b42                	ld	s6,16(sp)
    80002af2:	6ba2                	ld	s7,8(sp)
    80002af4:	6161                	addi	sp,sp,80
    80002af6:	8082                	ret

0000000080002af8 <iupdate>:
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	e04a                	sd	s2,0(sp)
    80002b02:	1000                	addi	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b06:	415c                	lw	a5,4(a0)
    80002b08:	0047d79b          	srliw	a5,a5,0x4
    80002b0c:	00015597          	auipc	a1,0x15
    80002b10:	6645a583          	lw	a1,1636(a1) # 80018170 <sb+0x18>
    80002b14:	9dbd                	addw	a1,a1,a5
    80002b16:	4108                	lw	a0,0(a0)
    80002b18:	00000097          	auipc	ra,0x0
    80002b1c:	8a8080e7          	jalr	-1880(ra) # 800023c0 <bread>
    80002b20:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b22:	05850793          	addi	a5,a0,88
    80002b26:	40c8                	lw	a0,4(s1)
    80002b28:	893d                	andi	a0,a0,15
    80002b2a:	051a                	slli	a0,a0,0x6
    80002b2c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b2e:	04449703          	lh	a4,68(s1)
    80002b32:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b36:	04649703          	lh	a4,70(s1)
    80002b3a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b3e:	04849703          	lh	a4,72(s1)
    80002b42:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b46:	04a49703          	lh	a4,74(s1)
    80002b4a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b4e:	44f8                	lw	a4,76(s1)
    80002b50:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b52:	03400613          	li	a2,52
    80002b56:	05048593          	addi	a1,s1,80
    80002b5a:	0531                	addi	a0,a0,12
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	67c080e7          	jalr	1660(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b64:	854a                	mv	a0,s2
    80002b66:	00001097          	auipc	ra,0x1
    80002b6a:	c06080e7          	jalr	-1018(ra) # 8000376c <log_write>
  brelse(bp);
    80002b6e:	854a                	mv	a0,s2
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	980080e7          	jalr	-1664(ra) # 800024f0 <brelse>
}
    80002b78:	60e2                	ld	ra,24(sp)
    80002b7a:	6442                	ld	s0,16(sp)
    80002b7c:	64a2                	ld	s1,8(sp)
    80002b7e:	6902                	ld	s2,0(sp)
    80002b80:	6105                	addi	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <idup>:
{
    80002b84:	1101                	addi	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	1000                	addi	s0,sp,32
    80002b8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b90:	00015517          	auipc	a0,0x15
    80002b94:	5e850513          	addi	a0,a0,1512 # 80018178 <itable>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	6a0080e7          	jalr	1696(ra) # 80006238 <acquire>
  ip->ref++;
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	2785                	addiw	a5,a5,1
    80002ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba6:	00015517          	auipc	a0,0x15
    80002baa:	5d250513          	addi	a0,a0,1490 # 80018178 <itable>
    80002bae:	00003097          	auipc	ra,0x3
    80002bb2:	73e080e7          	jalr	1854(ra) # 800062ec <release>
}
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <ilock>:
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	e04a                	sd	s2,0(sp)
    80002bcc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bce:	c115                	beqz	a0,80002bf2 <ilock+0x30>
    80002bd0:	84aa                	mv	s1,a0
    80002bd2:	451c                	lw	a5,8(a0)
    80002bd4:	00f05f63          	blez	a5,80002bf2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bd8:	0541                	addi	a0,a0,16
    80002bda:	00001097          	auipc	ra,0x1
    80002bde:	cb2080e7          	jalr	-846(ra) # 8000388c <acquiresleep>
  if(ip->valid == 0){
    80002be2:	40bc                	lw	a5,64(s1)
    80002be4:	cf99                	beqz	a5,80002c02 <ilock+0x40>
}
    80002be6:	60e2                	ld	ra,24(sp)
    80002be8:	6442                	ld	s0,16(sp)
    80002bea:	64a2                	ld	s1,8(sp)
    80002bec:	6902                	ld	s2,0(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret
    panic("ilock");
    80002bf2:	00006517          	auipc	a0,0x6
    80002bf6:	96650513          	addi	a0,a0,-1690 # 80008558 <syscalls+0x190>
    80002bfa:	00003097          	auipc	ra,0x3
    80002bfe:	11e080e7          	jalr	286(ra) # 80005d18 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c02:	40dc                	lw	a5,4(s1)
    80002c04:	0047d79b          	srliw	a5,a5,0x4
    80002c08:	00015597          	auipc	a1,0x15
    80002c0c:	5685a583          	lw	a1,1384(a1) # 80018170 <sb+0x18>
    80002c10:	9dbd                	addw	a1,a1,a5
    80002c12:	4088                	lw	a0,0(s1)
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	7ac080e7          	jalr	1964(ra) # 800023c0 <bread>
    80002c1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1e:	05850593          	addi	a1,a0,88
    80002c22:	40dc                	lw	a5,4(s1)
    80002c24:	8bbd                	andi	a5,a5,15
    80002c26:	079a                	slli	a5,a5,0x6
    80002c28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c2a:	00059783          	lh	a5,0(a1)
    80002c2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c32:	00259783          	lh	a5,2(a1)
    80002c36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c3a:	00459783          	lh	a5,4(a1)
    80002c3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c42:	00659783          	lh	a5,6(a1)
    80002c46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c4a:	459c                	lw	a5,8(a1)
    80002c4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4e:	03400613          	li	a2,52
    80002c52:	05b1                	addi	a1,a1,12
    80002c54:	05048513          	addi	a0,s1,80
    80002c58:	ffffd097          	auipc	ra,0xffffd
    80002c5c:	580080e7          	jalr	1408(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	88e080e7          	jalr	-1906(ra) # 800024f0 <brelse>
    ip->valid = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6e:	04449783          	lh	a5,68(s1)
    80002c72:	fbb5                	bnez	a5,80002be6 <ilock+0x24>
      panic("ilock: no type");
    80002c74:	00006517          	auipc	a0,0x6
    80002c78:	8ec50513          	addi	a0,a0,-1812 # 80008560 <syscalls+0x198>
    80002c7c:	00003097          	auipc	ra,0x3
    80002c80:	09c080e7          	jalr	156(ra) # 80005d18 <panic>

0000000080002c84 <iunlock>:
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	e426                	sd	s1,8(sp)
    80002c8c:	e04a                	sd	s2,0(sp)
    80002c8e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c90:	c905                	beqz	a0,80002cc0 <iunlock+0x3c>
    80002c92:	84aa                	mv	s1,a0
    80002c94:	01050913          	addi	s2,a0,16
    80002c98:	854a                	mv	a0,s2
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	c8c080e7          	jalr	-884(ra) # 80003926 <holdingsleep>
    80002ca2:	cd19                	beqz	a0,80002cc0 <iunlock+0x3c>
    80002ca4:	449c                	lw	a5,8(s1)
    80002ca6:	00f05d63          	blez	a5,80002cc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002caa:	854a                	mv	a0,s2
    80002cac:	00001097          	auipc	ra,0x1
    80002cb0:	c36080e7          	jalr	-970(ra) # 800038e2 <releasesleep>
}
    80002cb4:	60e2                	ld	ra,24(sp)
    80002cb6:	6442                	ld	s0,16(sp)
    80002cb8:	64a2                	ld	s1,8(sp)
    80002cba:	6902                	ld	s2,0(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret
    panic("iunlock");
    80002cc0:	00006517          	auipc	a0,0x6
    80002cc4:	8b050513          	addi	a0,a0,-1872 # 80008570 <syscalls+0x1a8>
    80002cc8:	00003097          	auipc	ra,0x3
    80002ccc:	050080e7          	jalr	80(ra) # 80005d18 <panic>

0000000080002cd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd0:	7179                	addi	sp,sp,-48
    80002cd2:	f406                	sd	ra,40(sp)
    80002cd4:	f022                	sd	s0,32(sp)
    80002cd6:	ec26                	sd	s1,24(sp)
    80002cd8:	e84a                	sd	s2,16(sp)
    80002cda:	e44e                	sd	s3,8(sp)
    80002cdc:	e052                	sd	s4,0(sp)
    80002cde:	1800                	addi	s0,sp,48
    80002ce0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce2:	05050493          	addi	s1,a0,80
    80002ce6:	08050913          	addi	s2,a0,128
    80002cea:	a021                	j	80002cf2 <itrunc+0x22>
    80002cec:	0491                	addi	s1,s1,4
    80002cee:	01248d63          	beq	s1,s2,80002d08 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cf2:	408c                	lw	a1,0(s1)
    80002cf4:	dde5                	beqz	a1,80002cec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cf6:	0009a503          	lw	a0,0(s3)
    80002cfa:	00000097          	auipc	ra,0x0
    80002cfe:	90c080e7          	jalr	-1780(ra) # 80002606 <bfree>
      ip->addrs[i] = 0;
    80002d02:	0004a023          	sw	zero,0(s1)
    80002d06:	b7dd                	j	80002cec <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d08:	0809a583          	lw	a1,128(s3)
    80002d0c:	e185                	bnez	a1,80002d2c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d0e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d12:	854e                	mv	a0,s3
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	de4080e7          	jalr	-540(ra) # 80002af8 <iupdate>
}
    80002d1c:	70a2                	ld	ra,40(sp)
    80002d1e:	7402                	ld	s0,32(sp)
    80002d20:	64e2                	ld	s1,24(sp)
    80002d22:	6942                	ld	s2,16(sp)
    80002d24:	69a2                	ld	s3,8(sp)
    80002d26:	6a02                	ld	s4,0(sp)
    80002d28:	6145                	addi	sp,sp,48
    80002d2a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d2c:	0009a503          	lw	a0,0(s3)
    80002d30:	fffff097          	auipc	ra,0xfffff
    80002d34:	690080e7          	jalr	1680(ra) # 800023c0 <bread>
    80002d38:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d3a:	05850493          	addi	s1,a0,88
    80002d3e:	45850913          	addi	s2,a0,1112
    80002d42:	a811                	j	80002d56 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	00000097          	auipc	ra,0x0
    80002d4c:	8be080e7          	jalr	-1858(ra) # 80002606 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d50:	0491                	addi	s1,s1,4
    80002d52:	01248563          	beq	s1,s2,80002d5c <itrunc+0x8c>
      if(a[j])
    80002d56:	408c                	lw	a1,0(s1)
    80002d58:	dde5                	beqz	a1,80002d50 <itrunc+0x80>
    80002d5a:	b7ed                	j	80002d44 <itrunc+0x74>
    brelse(bp);
    80002d5c:	8552                	mv	a0,s4
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	792080e7          	jalr	1938(ra) # 800024f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d66:	0809a583          	lw	a1,128(s3)
    80002d6a:	0009a503          	lw	a0,0(s3)
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	898080e7          	jalr	-1896(ra) # 80002606 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d76:	0809a023          	sw	zero,128(s3)
    80002d7a:	bf51                	j	80002d0e <itrunc+0x3e>

0000000080002d7c <iput>:
{
    80002d7c:	1101                	addi	sp,sp,-32
    80002d7e:	ec06                	sd	ra,24(sp)
    80002d80:	e822                	sd	s0,16(sp)
    80002d82:	e426                	sd	s1,8(sp)
    80002d84:	e04a                	sd	s2,0(sp)
    80002d86:	1000                	addi	s0,sp,32
    80002d88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d8a:	00015517          	auipc	a0,0x15
    80002d8e:	3ee50513          	addi	a0,a0,1006 # 80018178 <itable>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	4a6080e7          	jalr	1190(ra) # 80006238 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9a:	4498                	lw	a4,8(s1)
    80002d9c:	4785                	li	a5,1
    80002d9e:	02f70363          	beq	a4,a5,80002dc4 <iput+0x48>
  ip->ref--;
    80002da2:	449c                	lw	a5,8(s1)
    80002da4:	37fd                	addiw	a5,a5,-1
    80002da6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002da8:	00015517          	auipc	a0,0x15
    80002dac:	3d050513          	addi	a0,a0,976 # 80018178 <itable>
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	53c080e7          	jalr	1340(ra) # 800062ec <release>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	64a2                	ld	s1,8(sp)
    80002dbe:	6902                	ld	s2,0(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc4:	40bc                	lw	a5,64(s1)
    80002dc6:	dff1                	beqz	a5,80002da2 <iput+0x26>
    80002dc8:	04a49783          	lh	a5,74(s1)
    80002dcc:	fbf9                	bnez	a5,80002da2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dce:	01048913          	addi	s2,s1,16
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	00001097          	auipc	ra,0x1
    80002dd8:	ab8080e7          	jalr	-1352(ra) # 8000388c <acquiresleep>
    release(&itable.lock);
    80002ddc:	00015517          	auipc	a0,0x15
    80002de0:	39c50513          	addi	a0,a0,924 # 80018178 <itable>
    80002de4:	00003097          	auipc	ra,0x3
    80002de8:	508080e7          	jalr	1288(ra) # 800062ec <release>
    itrunc(ip);
    80002dec:	8526                	mv	a0,s1
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	ee2080e7          	jalr	-286(ra) # 80002cd0 <itrunc>
    ip->type = 0;
    80002df6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dfa:	8526                	mv	a0,s1
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	cfc080e7          	jalr	-772(ra) # 80002af8 <iupdate>
    ip->valid = 0;
    80002e04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e08:	854a                	mv	a0,s2
    80002e0a:	00001097          	auipc	ra,0x1
    80002e0e:	ad8080e7          	jalr	-1320(ra) # 800038e2 <releasesleep>
    acquire(&itable.lock);
    80002e12:	00015517          	auipc	a0,0x15
    80002e16:	36650513          	addi	a0,a0,870 # 80018178 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	41e080e7          	jalr	1054(ra) # 80006238 <acquire>
    80002e22:	b741                	j	80002da2 <iput+0x26>

0000000080002e24 <iunlockput>:
{
    80002e24:	1101                	addi	sp,sp,-32
    80002e26:	ec06                	sd	ra,24(sp)
    80002e28:	e822                	sd	s0,16(sp)
    80002e2a:	e426                	sd	s1,8(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	e54080e7          	jalr	-428(ra) # 80002c84 <iunlock>
  iput(ip);
    80002e38:	8526                	mv	a0,s1
    80002e3a:	00000097          	auipc	ra,0x0
    80002e3e:	f42080e7          	jalr	-190(ra) # 80002d7c <iput>
}
    80002e42:	60e2                	ld	ra,24(sp)
    80002e44:	6442                	ld	s0,16(sp)
    80002e46:	64a2                	ld	s1,8(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret

0000000080002e4c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e4c:	1141                	addi	sp,sp,-16
    80002e4e:	e422                	sd	s0,8(sp)
    80002e50:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e52:	411c                	lw	a5,0(a0)
    80002e54:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e56:	415c                	lw	a5,4(a0)
    80002e58:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e5a:	04451783          	lh	a5,68(a0)
    80002e5e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e62:	04a51783          	lh	a5,74(a0)
    80002e66:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e6a:	04c56783          	lwu	a5,76(a0)
    80002e6e:	e99c                	sd	a5,16(a1)
}
    80002e70:	6422                	ld	s0,8(sp)
    80002e72:	0141                	addi	sp,sp,16
    80002e74:	8082                	ret

0000000080002e76 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e76:	457c                	lw	a5,76(a0)
    80002e78:	0ed7e963          	bltu	a5,a3,80002f6a <readi+0xf4>
{
    80002e7c:	7159                	addi	sp,sp,-112
    80002e7e:	f486                	sd	ra,104(sp)
    80002e80:	f0a2                	sd	s0,96(sp)
    80002e82:	eca6                	sd	s1,88(sp)
    80002e84:	e8ca                	sd	s2,80(sp)
    80002e86:	e4ce                	sd	s3,72(sp)
    80002e88:	e0d2                	sd	s4,64(sp)
    80002e8a:	fc56                	sd	s5,56(sp)
    80002e8c:	f85a                	sd	s6,48(sp)
    80002e8e:	f45e                	sd	s7,40(sp)
    80002e90:	f062                	sd	s8,32(sp)
    80002e92:	ec66                	sd	s9,24(sp)
    80002e94:	e86a                	sd	s10,16(sp)
    80002e96:	e46e                	sd	s11,8(sp)
    80002e98:	1880                	addi	s0,sp,112
    80002e9a:	8baa                	mv	s7,a0
    80002e9c:	8c2e                	mv	s8,a1
    80002e9e:	8ab2                	mv	s5,a2
    80002ea0:	84b6                	mv	s1,a3
    80002ea2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ea4:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea8:	0ad76063          	bltu	a4,a3,80002f48 <readi+0xd2>
  if(off + n > ip->size)
    80002eac:	00e7f463          	bgeu	a5,a4,80002eb4 <readi+0x3e>
    n = ip->size - off;
    80002eb0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb4:	0a0b0963          	beqz	s6,80002f66 <readi+0xf0>
    80002eb8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eba:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ebe:	5cfd                	li	s9,-1
    80002ec0:	a82d                	j	80002efa <readi+0x84>
    80002ec2:	020a1d93          	slli	s11,s4,0x20
    80002ec6:	020ddd93          	srli	s11,s11,0x20
    80002eca:	05890613          	addi	a2,s2,88
    80002ece:	86ee                	mv	a3,s11
    80002ed0:	963a                	add	a2,a2,a4
    80002ed2:	85d6                	mv	a1,s5
    80002ed4:	8562                	mv	a0,s8
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	a22080e7          	jalr	-1502(ra) # 800018f8 <either_copyout>
    80002ede:	05950d63          	beq	a0,s9,80002f38 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	fffff097          	auipc	ra,0xfffff
    80002ee8:	60c080e7          	jalr	1548(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eec:	013a09bb          	addw	s3,s4,s3
    80002ef0:	009a04bb          	addw	s1,s4,s1
    80002ef4:	9aee                	add	s5,s5,s11
    80002ef6:	0569f763          	bgeu	s3,s6,80002f44 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002efa:	000ba903          	lw	s2,0(s7)
    80002efe:	00a4d59b          	srliw	a1,s1,0xa
    80002f02:	855e                	mv	a0,s7
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	8b0080e7          	jalr	-1872(ra) # 800027b4 <bmap>
    80002f0c:	0005059b          	sext.w	a1,a0
    80002f10:	854a                	mv	a0,s2
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	4ae080e7          	jalr	1198(ra) # 800023c0 <bread>
    80002f1a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1c:	3ff4f713          	andi	a4,s1,1023
    80002f20:	40ed07bb          	subw	a5,s10,a4
    80002f24:	413b06bb          	subw	a3,s6,s3
    80002f28:	8a3e                	mv	s4,a5
    80002f2a:	2781                	sext.w	a5,a5
    80002f2c:	0006861b          	sext.w	a2,a3
    80002f30:	f8f679e3          	bgeu	a2,a5,80002ec2 <readi+0x4c>
    80002f34:	8a36                	mv	s4,a3
    80002f36:	b771                	j	80002ec2 <readi+0x4c>
      brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	5b6080e7          	jalr	1462(ra) # 800024f0 <brelse>
      tot = -1;
    80002f42:	59fd                	li	s3,-1
  }
  return tot;
    80002f44:	0009851b          	sext.w	a0,s3
}
    80002f48:	70a6                	ld	ra,104(sp)
    80002f4a:	7406                	ld	s0,96(sp)
    80002f4c:	64e6                	ld	s1,88(sp)
    80002f4e:	6946                	ld	s2,80(sp)
    80002f50:	69a6                	ld	s3,72(sp)
    80002f52:	6a06                	ld	s4,64(sp)
    80002f54:	7ae2                	ld	s5,56(sp)
    80002f56:	7b42                	ld	s6,48(sp)
    80002f58:	7ba2                	ld	s7,40(sp)
    80002f5a:	7c02                	ld	s8,32(sp)
    80002f5c:	6ce2                	ld	s9,24(sp)
    80002f5e:	6d42                	ld	s10,16(sp)
    80002f60:	6da2                	ld	s11,8(sp)
    80002f62:	6165                	addi	sp,sp,112
    80002f64:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f66:	89da                	mv	s3,s6
    80002f68:	bff1                	j	80002f44 <readi+0xce>
    return 0;
    80002f6a:	4501                	li	a0,0
}
    80002f6c:	8082                	ret

0000000080002f6e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f6e:	457c                	lw	a5,76(a0)
    80002f70:	10d7e863          	bltu	a5,a3,80003080 <writei+0x112>
{
    80002f74:	7159                	addi	sp,sp,-112
    80002f76:	f486                	sd	ra,104(sp)
    80002f78:	f0a2                	sd	s0,96(sp)
    80002f7a:	eca6                	sd	s1,88(sp)
    80002f7c:	e8ca                	sd	s2,80(sp)
    80002f7e:	e4ce                	sd	s3,72(sp)
    80002f80:	e0d2                	sd	s4,64(sp)
    80002f82:	fc56                	sd	s5,56(sp)
    80002f84:	f85a                	sd	s6,48(sp)
    80002f86:	f45e                	sd	s7,40(sp)
    80002f88:	f062                	sd	s8,32(sp)
    80002f8a:	ec66                	sd	s9,24(sp)
    80002f8c:	e86a                	sd	s10,16(sp)
    80002f8e:	e46e                	sd	s11,8(sp)
    80002f90:	1880                	addi	s0,sp,112
    80002f92:	8b2a                	mv	s6,a0
    80002f94:	8c2e                	mv	s8,a1
    80002f96:	8ab2                	mv	s5,a2
    80002f98:	8936                	mv	s2,a3
    80002f9a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f9c:	00e687bb          	addw	a5,a3,a4
    80002fa0:	0ed7e263          	bltu	a5,a3,80003084 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa4:	00043737          	lui	a4,0x43
    80002fa8:	0ef76063          	bltu	a4,a5,80003088 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fac:	0c0b8863          	beqz	s7,8000307c <writei+0x10e>
    80002fb0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fb6:	5cfd                	li	s9,-1
    80002fb8:	a091                	j	80002ffc <writei+0x8e>
    80002fba:	02099d93          	slli	s11,s3,0x20
    80002fbe:	020ddd93          	srli	s11,s11,0x20
    80002fc2:	05848513          	addi	a0,s1,88
    80002fc6:	86ee                	mv	a3,s11
    80002fc8:	8656                	mv	a2,s5
    80002fca:	85e2                	mv	a1,s8
    80002fcc:	953a                	add	a0,a0,a4
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	980080e7          	jalr	-1664(ra) # 8000194e <either_copyin>
    80002fd6:	07950263          	beq	a0,s9,8000303a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fda:	8526                	mv	a0,s1
    80002fdc:	00000097          	auipc	ra,0x0
    80002fe0:	790080e7          	jalr	1936(ra) # 8000376c <log_write>
    brelse(bp);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	50a080e7          	jalr	1290(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fee:	01498a3b          	addw	s4,s3,s4
    80002ff2:	0129893b          	addw	s2,s3,s2
    80002ff6:	9aee                	add	s5,s5,s11
    80002ff8:	057a7663          	bgeu	s4,s7,80003044 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ffc:	000b2483          	lw	s1,0(s6)
    80003000:	00a9559b          	srliw	a1,s2,0xa
    80003004:	855a                	mv	a0,s6
    80003006:	fffff097          	auipc	ra,0xfffff
    8000300a:	7ae080e7          	jalr	1966(ra) # 800027b4 <bmap>
    8000300e:	0005059b          	sext.w	a1,a0
    80003012:	8526                	mv	a0,s1
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	3ac080e7          	jalr	940(ra) # 800023c0 <bread>
    8000301c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301e:	3ff97713          	andi	a4,s2,1023
    80003022:	40ed07bb          	subw	a5,s10,a4
    80003026:	414b86bb          	subw	a3,s7,s4
    8000302a:	89be                	mv	s3,a5
    8000302c:	2781                	sext.w	a5,a5
    8000302e:	0006861b          	sext.w	a2,a3
    80003032:	f8f674e3          	bgeu	a2,a5,80002fba <writei+0x4c>
    80003036:	89b6                	mv	s3,a3
    80003038:	b749                	j	80002fba <writei+0x4c>
      brelse(bp);
    8000303a:	8526                	mv	a0,s1
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	4b4080e7          	jalr	1204(ra) # 800024f0 <brelse>
  }

  if(off > ip->size)
    80003044:	04cb2783          	lw	a5,76(s6)
    80003048:	0127f463          	bgeu	a5,s2,80003050 <writei+0xe2>
    ip->size = off;
    8000304c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003050:	855a                	mv	a0,s6
    80003052:	00000097          	auipc	ra,0x0
    80003056:	aa6080e7          	jalr	-1370(ra) # 80002af8 <iupdate>

  return tot;
    8000305a:	000a051b          	sext.w	a0,s4
}
    8000305e:	70a6                	ld	ra,104(sp)
    80003060:	7406                	ld	s0,96(sp)
    80003062:	64e6                	ld	s1,88(sp)
    80003064:	6946                	ld	s2,80(sp)
    80003066:	69a6                	ld	s3,72(sp)
    80003068:	6a06                	ld	s4,64(sp)
    8000306a:	7ae2                	ld	s5,56(sp)
    8000306c:	7b42                	ld	s6,48(sp)
    8000306e:	7ba2                	ld	s7,40(sp)
    80003070:	7c02                	ld	s8,32(sp)
    80003072:	6ce2                	ld	s9,24(sp)
    80003074:	6d42                	ld	s10,16(sp)
    80003076:	6da2                	ld	s11,8(sp)
    80003078:	6165                	addi	sp,sp,112
    8000307a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000307c:	8a5e                	mv	s4,s7
    8000307e:	bfc9                	j	80003050 <writei+0xe2>
    return -1;
    80003080:	557d                	li	a0,-1
}
    80003082:	8082                	ret
    return -1;
    80003084:	557d                	li	a0,-1
    80003086:	bfe1                	j	8000305e <writei+0xf0>
    return -1;
    80003088:	557d                	li	a0,-1
    8000308a:	bfd1                	j	8000305e <writei+0xf0>

000000008000308c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000308c:	1141                	addi	sp,sp,-16
    8000308e:	e406                	sd	ra,8(sp)
    80003090:	e022                	sd	s0,0(sp)
    80003092:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003094:	4639                	li	a2,14
    80003096:	ffffd097          	auipc	ra,0xffffd
    8000309a:	1ba080e7          	jalr	442(ra) # 80000250 <strncmp>
}
    8000309e:	60a2                	ld	ra,8(sp)
    800030a0:	6402                	ld	s0,0(sp)
    800030a2:	0141                	addi	sp,sp,16
    800030a4:	8082                	ret

00000000800030a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030a6:	7139                	addi	sp,sp,-64
    800030a8:	fc06                	sd	ra,56(sp)
    800030aa:	f822                	sd	s0,48(sp)
    800030ac:	f426                	sd	s1,40(sp)
    800030ae:	f04a                	sd	s2,32(sp)
    800030b0:	ec4e                	sd	s3,24(sp)
    800030b2:	e852                	sd	s4,16(sp)
    800030b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030b6:	04451703          	lh	a4,68(a0)
    800030ba:	4785                	li	a5,1
    800030bc:	00f71a63          	bne	a4,a5,800030d0 <dirlookup+0x2a>
    800030c0:	892a                	mv	s2,a0
    800030c2:	89ae                	mv	s3,a1
    800030c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c6:	457c                	lw	a5,76(a0)
    800030c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030cc:	e79d                	bnez	a5,800030fa <dirlookup+0x54>
    800030ce:	a8a5                	j	80003146 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030d0:	00005517          	auipc	a0,0x5
    800030d4:	4a850513          	addi	a0,a0,1192 # 80008578 <syscalls+0x1b0>
    800030d8:	00003097          	auipc	ra,0x3
    800030dc:	c40080e7          	jalr	-960(ra) # 80005d18 <panic>
      panic("dirlookup read");
    800030e0:	00005517          	auipc	a0,0x5
    800030e4:	4b050513          	addi	a0,a0,1200 # 80008590 <syscalls+0x1c8>
    800030e8:	00003097          	auipc	ra,0x3
    800030ec:	c30080e7          	jalr	-976(ra) # 80005d18 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f0:	24c1                	addiw	s1,s1,16
    800030f2:	04c92783          	lw	a5,76(s2)
    800030f6:	04f4f763          	bgeu	s1,a5,80003144 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030fa:	4741                	li	a4,16
    800030fc:	86a6                	mv	a3,s1
    800030fe:	fc040613          	addi	a2,s0,-64
    80003102:	4581                	li	a1,0
    80003104:	854a                	mv	a0,s2
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	d70080e7          	jalr	-656(ra) # 80002e76 <readi>
    8000310e:	47c1                	li	a5,16
    80003110:	fcf518e3          	bne	a0,a5,800030e0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003114:	fc045783          	lhu	a5,-64(s0)
    80003118:	dfe1                	beqz	a5,800030f0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000311a:	fc240593          	addi	a1,s0,-62
    8000311e:	854e                	mv	a0,s3
    80003120:	00000097          	auipc	ra,0x0
    80003124:	f6c080e7          	jalr	-148(ra) # 8000308c <namecmp>
    80003128:	f561                	bnez	a0,800030f0 <dirlookup+0x4a>
      if(poff)
    8000312a:	000a0463          	beqz	s4,80003132 <dirlookup+0x8c>
        *poff = off;
    8000312e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003132:	fc045583          	lhu	a1,-64(s0)
    80003136:	00092503          	lw	a0,0(s2)
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	754080e7          	jalr	1876(ra) # 8000288e <iget>
    80003142:	a011                	j	80003146 <dirlookup+0xa0>
  return 0;
    80003144:	4501                	li	a0,0
}
    80003146:	70e2                	ld	ra,56(sp)
    80003148:	7442                	ld	s0,48(sp)
    8000314a:	74a2                	ld	s1,40(sp)
    8000314c:	7902                	ld	s2,32(sp)
    8000314e:	69e2                	ld	s3,24(sp)
    80003150:	6a42                	ld	s4,16(sp)
    80003152:	6121                	addi	sp,sp,64
    80003154:	8082                	ret

0000000080003156 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003156:	711d                	addi	sp,sp,-96
    80003158:	ec86                	sd	ra,88(sp)
    8000315a:	e8a2                	sd	s0,80(sp)
    8000315c:	e4a6                	sd	s1,72(sp)
    8000315e:	e0ca                	sd	s2,64(sp)
    80003160:	fc4e                	sd	s3,56(sp)
    80003162:	f852                	sd	s4,48(sp)
    80003164:	f456                	sd	s5,40(sp)
    80003166:	f05a                	sd	s6,32(sp)
    80003168:	ec5e                	sd	s7,24(sp)
    8000316a:	e862                	sd	s8,16(sp)
    8000316c:	e466                	sd	s9,8(sp)
    8000316e:	1080                	addi	s0,sp,96
    80003170:	84aa                	mv	s1,a0
    80003172:	8b2e                	mv	s6,a1
    80003174:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003176:	00054703          	lbu	a4,0(a0)
    8000317a:	02f00793          	li	a5,47
    8000317e:	02f70363          	beq	a4,a5,800031a4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003182:	ffffe097          	auipc	ra,0xffffe
    80003186:	cc6080e7          	jalr	-826(ra) # 80000e48 <myproc>
    8000318a:	15053503          	ld	a0,336(a0)
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	9f6080e7          	jalr	-1546(ra) # 80002b84 <idup>
    80003196:	89aa                	mv	s3,a0
  while(*path == '/')
    80003198:	02f00913          	li	s2,47
  len = path - s;
    8000319c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000319e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031a0:	4c05                	li	s8,1
    800031a2:	a865                	j	8000325a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031a4:	4585                	li	a1,1
    800031a6:	4505                	li	a0,1
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	6e6080e7          	jalr	1766(ra) # 8000288e <iget>
    800031b0:	89aa                	mv	s3,a0
    800031b2:	b7dd                	j	80003198 <namex+0x42>
      iunlockput(ip);
    800031b4:	854e                	mv	a0,s3
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	c6e080e7          	jalr	-914(ra) # 80002e24 <iunlockput>
      return 0;
    800031be:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031c0:	854e                	mv	a0,s3
    800031c2:	60e6                	ld	ra,88(sp)
    800031c4:	6446                	ld	s0,80(sp)
    800031c6:	64a6                	ld	s1,72(sp)
    800031c8:	6906                	ld	s2,64(sp)
    800031ca:	79e2                	ld	s3,56(sp)
    800031cc:	7a42                	ld	s4,48(sp)
    800031ce:	7aa2                	ld	s5,40(sp)
    800031d0:	7b02                	ld	s6,32(sp)
    800031d2:	6be2                	ld	s7,24(sp)
    800031d4:	6c42                	ld	s8,16(sp)
    800031d6:	6ca2                	ld	s9,8(sp)
    800031d8:	6125                	addi	sp,sp,96
    800031da:	8082                	ret
      iunlock(ip);
    800031dc:	854e                	mv	a0,s3
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	aa6080e7          	jalr	-1370(ra) # 80002c84 <iunlock>
      return ip;
    800031e6:	bfe9                	j	800031c0 <namex+0x6a>
      iunlockput(ip);
    800031e8:	854e                	mv	a0,s3
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	c3a080e7          	jalr	-966(ra) # 80002e24 <iunlockput>
      return 0;
    800031f2:	89d2                	mv	s3,s4
    800031f4:	b7f1                	j	800031c0 <namex+0x6a>
  len = path - s;
    800031f6:	40b48633          	sub	a2,s1,a1
    800031fa:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031fe:	094cd463          	bge	s9,s4,80003286 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003202:	4639                	li	a2,14
    80003204:	8556                	mv	a0,s5
    80003206:	ffffd097          	auipc	ra,0xffffd
    8000320a:	fd2080e7          	jalr	-46(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	01279763          	bne	a5,s2,80003220 <namex+0xca>
    path++;
    80003216:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	ff278de3          	beq	a5,s2,80003216 <namex+0xc0>
    ilock(ip);
    80003220:	854e                	mv	a0,s3
    80003222:	00000097          	auipc	ra,0x0
    80003226:	9a0080e7          	jalr	-1632(ra) # 80002bc2 <ilock>
    if(ip->type != T_DIR){
    8000322a:	04499783          	lh	a5,68(s3)
    8000322e:	f98793e3          	bne	a5,s8,800031b4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003232:	000b0563          	beqz	s6,8000323c <namex+0xe6>
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	d3cd                	beqz	a5,800031dc <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000323c:	865e                	mv	a2,s7
    8000323e:	85d6                	mv	a1,s5
    80003240:	854e                	mv	a0,s3
    80003242:	00000097          	auipc	ra,0x0
    80003246:	e64080e7          	jalr	-412(ra) # 800030a6 <dirlookup>
    8000324a:	8a2a                	mv	s4,a0
    8000324c:	dd51                	beqz	a0,800031e8 <namex+0x92>
    iunlockput(ip);
    8000324e:	854e                	mv	a0,s3
    80003250:	00000097          	auipc	ra,0x0
    80003254:	bd4080e7          	jalr	-1068(ra) # 80002e24 <iunlockput>
    ip = next;
    80003258:	89d2                	mv	s3,s4
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	05279763          	bne	a5,s2,800032ac <namex+0x156>
    path++;
    80003262:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	ff278de3          	beq	a5,s2,80003262 <namex+0x10c>
  if(*path == 0)
    8000326c:	c79d                	beqz	a5,8000329a <namex+0x144>
    path++;
    8000326e:	85a6                	mv	a1,s1
  len = path - s;
    80003270:	8a5e                	mv	s4,s7
    80003272:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003274:	01278963          	beq	a5,s2,80003286 <namex+0x130>
    80003278:	dfbd                	beqz	a5,800031f6 <namex+0xa0>
    path++;
    8000327a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	ff279ce3          	bne	a5,s2,80003278 <namex+0x122>
    80003284:	bf8d                	j	800031f6 <namex+0xa0>
    memmove(name, s, len);
    80003286:	2601                	sext.w	a2,a2
    80003288:	8556                	mv	a0,s5
    8000328a:	ffffd097          	auipc	ra,0xffffd
    8000328e:	f4e080e7          	jalr	-178(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003292:	9a56                	add	s4,s4,s5
    80003294:	000a0023          	sb	zero,0(s4)
    80003298:	bf9d                	j	8000320e <namex+0xb8>
  if(nameiparent){
    8000329a:	f20b03e3          	beqz	s6,800031c0 <namex+0x6a>
    iput(ip);
    8000329e:	854e                	mv	a0,s3
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	adc080e7          	jalr	-1316(ra) # 80002d7c <iput>
    return 0;
    800032a8:	4981                	li	s3,0
    800032aa:	bf19                	j	800031c0 <namex+0x6a>
  if(*path == 0)
    800032ac:	d7fd                	beqz	a5,8000329a <namex+0x144>
  while(*path != '/' && *path != 0)
    800032ae:	0004c783          	lbu	a5,0(s1)
    800032b2:	85a6                	mv	a1,s1
    800032b4:	b7d1                	j	80003278 <namex+0x122>

00000000800032b6 <dirlink>:
{
    800032b6:	7139                	addi	sp,sp,-64
    800032b8:	fc06                	sd	ra,56(sp)
    800032ba:	f822                	sd	s0,48(sp)
    800032bc:	f426                	sd	s1,40(sp)
    800032be:	f04a                	sd	s2,32(sp)
    800032c0:	ec4e                	sd	s3,24(sp)
    800032c2:	e852                	sd	s4,16(sp)
    800032c4:	0080                	addi	s0,sp,64
    800032c6:	892a                	mv	s2,a0
    800032c8:	8a2e                	mv	s4,a1
    800032ca:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032cc:	4601                	li	a2,0
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	dd8080e7          	jalr	-552(ra) # 800030a6 <dirlookup>
    800032d6:	e93d                	bnez	a0,8000334c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d8:	04c92483          	lw	s1,76(s2)
    800032dc:	c49d                	beqz	s1,8000330a <dirlink+0x54>
    800032de:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032e0:	4741                	li	a4,16
    800032e2:	86a6                	mv	a3,s1
    800032e4:	fc040613          	addi	a2,s0,-64
    800032e8:	4581                	li	a1,0
    800032ea:	854a                	mv	a0,s2
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	b8a080e7          	jalr	-1142(ra) # 80002e76 <readi>
    800032f4:	47c1                	li	a5,16
    800032f6:	06f51163          	bne	a0,a5,80003358 <dirlink+0xa2>
    if(de.inum == 0)
    800032fa:	fc045783          	lhu	a5,-64(s0)
    800032fe:	c791                	beqz	a5,8000330a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003300:	24c1                	addiw	s1,s1,16
    80003302:	04c92783          	lw	a5,76(s2)
    80003306:	fcf4ede3          	bltu	s1,a5,800032e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000330a:	4639                	li	a2,14
    8000330c:	85d2                	mv	a1,s4
    8000330e:	fc240513          	addi	a0,s0,-62
    80003312:	ffffd097          	auipc	ra,0xffffd
    80003316:	f7a080e7          	jalr	-134(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000331a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331e:	4741                	li	a4,16
    80003320:	86a6                	mv	a3,s1
    80003322:	fc040613          	addi	a2,s0,-64
    80003326:	4581                	li	a1,0
    80003328:	854a                	mv	a0,s2
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	c44080e7          	jalr	-956(ra) # 80002f6e <writei>
    80003332:	872a                	mv	a4,a0
    80003334:	47c1                	li	a5,16
  return 0;
    80003336:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003338:	02f71863          	bne	a4,a5,80003368 <dirlink+0xb2>
}
    8000333c:	70e2                	ld	ra,56(sp)
    8000333e:	7442                	ld	s0,48(sp)
    80003340:	74a2                	ld	s1,40(sp)
    80003342:	7902                	ld	s2,32(sp)
    80003344:	69e2                	ld	s3,24(sp)
    80003346:	6a42                	ld	s4,16(sp)
    80003348:	6121                	addi	sp,sp,64
    8000334a:	8082                	ret
    iput(ip);
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	a30080e7          	jalr	-1488(ra) # 80002d7c <iput>
    return -1;
    80003354:	557d                	li	a0,-1
    80003356:	b7dd                	j	8000333c <dirlink+0x86>
      panic("dirlink read");
    80003358:	00005517          	auipc	a0,0x5
    8000335c:	24850513          	addi	a0,a0,584 # 800085a0 <syscalls+0x1d8>
    80003360:	00003097          	auipc	ra,0x3
    80003364:	9b8080e7          	jalr	-1608(ra) # 80005d18 <panic>
    panic("dirlink");
    80003368:	00005517          	auipc	a0,0x5
    8000336c:	34850513          	addi	a0,a0,840 # 800086b0 <syscalls+0x2e8>
    80003370:	00003097          	auipc	ra,0x3
    80003374:	9a8080e7          	jalr	-1624(ra) # 80005d18 <panic>

0000000080003378 <namei>:

struct inode*
namei(char *path)
{
    80003378:	1101                	addi	sp,sp,-32
    8000337a:	ec06                	sd	ra,24(sp)
    8000337c:	e822                	sd	s0,16(sp)
    8000337e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003380:	fe040613          	addi	a2,s0,-32
    80003384:	4581                	li	a1,0
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	dd0080e7          	jalr	-560(ra) # 80003156 <namex>
}
    8000338e:	60e2                	ld	ra,24(sp)
    80003390:	6442                	ld	s0,16(sp)
    80003392:	6105                	addi	sp,sp,32
    80003394:	8082                	ret

0000000080003396 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003396:	1141                	addi	sp,sp,-16
    80003398:	e406                	sd	ra,8(sp)
    8000339a:	e022                	sd	s0,0(sp)
    8000339c:	0800                	addi	s0,sp,16
    8000339e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033a0:	4585                	li	a1,1
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	db4080e7          	jalr	-588(ra) # 80003156 <namex>
}
    800033aa:	60a2                	ld	ra,8(sp)
    800033ac:	6402                	ld	s0,0(sp)
    800033ae:	0141                	addi	sp,sp,16
    800033b0:	8082                	ret

00000000800033b2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	e426                	sd	s1,8(sp)
    800033ba:	e04a                	sd	s2,0(sp)
    800033bc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033be:	00017917          	auipc	s2,0x17
    800033c2:	86290913          	addi	s2,s2,-1950 # 80019c20 <log>
    800033c6:	01892583          	lw	a1,24(s2)
    800033ca:	02892503          	lw	a0,40(s2)
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	ff2080e7          	jalr	-14(ra) # 800023c0 <bread>
    800033d6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033d8:	02c92683          	lw	a3,44(s2)
    800033dc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033de:	02d05763          	blez	a3,8000340c <write_head+0x5a>
    800033e2:	00017797          	auipc	a5,0x17
    800033e6:	86e78793          	addi	a5,a5,-1938 # 80019c50 <log+0x30>
    800033ea:	05c50713          	addi	a4,a0,92
    800033ee:	36fd                	addiw	a3,a3,-1
    800033f0:	1682                	slli	a3,a3,0x20
    800033f2:	9281                	srli	a3,a3,0x20
    800033f4:	068a                	slli	a3,a3,0x2
    800033f6:	00017617          	auipc	a2,0x17
    800033fa:	85e60613          	addi	a2,a2,-1954 # 80019c54 <log+0x34>
    800033fe:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003400:	4390                	lw	a2,0(a5)
    80003402:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003404:	0791                	addi	a5,a5,4
    80003406:	0711                	addi	a4,a4,4
    80003408:	fed79ce3          	bne	a5,a3,80003400 <write_head+0x4e>
  }
  bwrite(buf);
    8000340c:	8526                	mv	a0,s1
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	0a4080e7          	jalr	164(ra) # 800024b2 <bwrite>
  brelse(buf);
    80003416:	8526                	mv	a0,s1
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	0d8080e7          	jalr	216(ra) # 800024f0 <brelse>
}
    80003420:	60e2                	ld	ra,24(sp)
    80003422:	6442                	ld	s0,16(sp)
    80003424:	64a2                	ld	s1,8(sp)
    80003426:	6902                	ld	s2,0(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342c:	00017797          	auipc	a5,0x17
    80003430:	8207a783          	lw	a5,-2016(a5) # 80019c4c <log+0x2c>
    80003434:	0af05d63          	blez	a5,800034ee <install_trans+0xc2>
{
    80003438:	7139                	addi	sp,sp,-64
    8000343a:	fc06                	sd	ra,56(sp)
    8000343c:	f822                	sd	s0,48(sp)
    8000343e:	f426                	sd	s1,40(sp)
    80003440:	f04a                	sd	s2,32(sp)
    80003442:	ec4e                	sd	s3,24(sp)
    80003444:	e852                	sd	s4,16(sp)
    80003446:	e456                	sd	s5,8(sp)
    80003448:	e05a                	sd	s6,0(sp)
    8000344a:	0080                	addi	s0,sp,64
    8000344c:	8b2a                	mv	s6,a0
    8000344e:	00017a97          	auipc	s5,0x17
    80003452:	802a8a93          	addi	s5,s5,-2046 # 80019c50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003456:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003458:	00016997          	auipc	s3,0x16
    8000345c:	7c898993          	addi	s3,s3,1992 # 80019c20 <log>
    80003460:	a035                	j	8000348c <install_trans+0x60>
      bunpin(dbuf);
    80003462:	8526                	mv	a0,s1
    80003464:	fffff097          	auipc	ra,0xfffff
    80003468:	166080e7          	jalr	358(ra) # 800025ca <bunpin>
    brelse(lbuf);
    8000346c:	854a                	mv	a0,s2
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	082080e7          	jalr	130(ra) # 800024f0 <brelse>
    brelse(dbuf);
    80003476:	8526                	mv	a0,s1
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	078080e7          	jalr	120(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003480:	2a05                	addiw	s4,s4,1
    80003482:	0a91                	addi	s5,s5,4
    80003484:	02c9a783          	lw	a5,44(s3)
    80003488:	04fa5963          	bge	s4,a5,800034da <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348c:	0189a583          	lw	a1,24(s3)
    80003490:	014585bb          	addw	a1,a1,s4
    80003494:	2585                	addiw	a1,a1,1
    80003496:	0289a503          	lw	a0,40(s3)
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	f26080e7          	jalr	-218(ra) # 800023c0 <bread>
    800034a2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a4:	000aa583          	lw	a1,0(s5)
    800034a8:	0289a503          	lw	a0,40(s3)
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	f14080e7          	jalr	-236(ra) # 800023c0 <bread>
    800034b4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b6:	40000613          	li	a2,1024
    800034ba:	05890593          	addi	a1,s2,88
    800034be:	05850513          	addi	a0,a0,88
    800034c2:	ffffd097          	auipc	ra,0xffffd
    800034c6:	d16080e7          	jalr	-746(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ca:	8526                	mv	a0,s1
    800034cc:	fffff097          	auipc	ra,0xfffff
    800034d0:	fe6080e7          	jalr	-26(ra) # 800024b2 <bwrite>
    if(recovering == 0)
    800034d4:	f80b1ce3          	bnez	s6,8000346c <install_trans+0x40>
    800034d8:	b769                	j	80003462 <install_trans+0x36>
}
    800034da:	70e2                	ld	ra,56(sp)
    800034dc:	7442                	ld	s0,48(sp)
    800034de:	74a2                	ld	s1,40(sp)
    800034e0:	7902                	ld	s2,32(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	6a42                	ld	s4,16(sp)
    800034e6:	6aa2                	ld	s5,8(sp)
    800034e8:	6b02                	ld	s6,0(sp)
    800034ea:	6121                	addi	sp,sp,64
    800034ec:	8082                	ret
    800034ee:	8082                	ret

00000000800034f0 <initlog>:
{
    800034f0:	7179                	addi	sp,sp,-48
    800034f2:	f406                	sd	ra,40(sp)
    800034f4:	f022                	sd	s0,32(sp)
    800034f6:	ec26                	sd	s1,24(sp)
    800034f8:	e84a                	sd	s2,16(sp)
    800034fa:	e44e                	sd	s3,8(sp)
    800034fc:	1800                	addi	s0,sp,48
    800034fe:	892a                	mv	s2,a0
    80003500:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003502:	00016497          	auipc	s1,0x16
    80003506:	71e48493          	addi	s1,s1,1822 # 80019c20 <log>
    8000350a:	00005597          	auipc	a1,0x5
    8000350e:	0a658593          	addi	a1,a1,166 # 800085b0 <syscalls+0x1e8>
    80003512:	8526                	mv	a0,s1
    80003514:	00003097          	auipc	ra,0x3
    80003518:	c94080e7          	jalr	-876(ra) # 800061a8 <initlock>
  log.start = sb->logstart;
    8000351c:	0149a583          	lw	a1,20(s3)
    80003520:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003522:	0109a783          	lw	a5,16(s3)
    80003526:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003528:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000352c:	854a                	mv	a0,s2
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	e92080e7          	jalr	-366(ra) # 800023c0 <bread>
  log.lh.n = lh->n;
    80003536:	4d3c                	lw	a5,88(a0)
    80003538:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000353a:	02f05563          	blez	a5,80003564 <initlog+0x74>
    8000353e:	05c50713          	addi	a4,a0,92
    80003542:	00016697          	auipc	a3,0x16
    80003546:	70e68693          	addi	a3,a3,1806 # 80019c50 <log+0x30>
    8000354a:	37fd                	addiw	a5,a5,-1
    8000354c:	1782                	slli	a5,a5,0x20
    8000354e:	9381                	srli	a5,a5,0x20
    80003550:	078a                	slli	a5,a5,0x2
    80003552:	06050613          	addi	a2,a0,96
    80003556:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003558:	4310                	lw	a2,0(a4)
    8000355a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	0711                	addi	a4,a4,4
    8000355e:	0691                	addi	a3,a3,4
    80003560:	fef71ce3          	bne	a4,a5,80003558 <initlog+0x68>
  brelse(buf);
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	f8c080e7          	jalr	-116(ra) # 800024f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000356c:	4505                	li	a0,1
    8000356e:	00000097          	auipc	ra,0x0
    80003572:	ebe080e7          	jalr	-322(ra) # 8000342c <install_trans>
  log.lh.n = 0;
    80003576:	00016797          	auipc	a5,0x16
    8000357a:	6c07ab23          	sw	zero,1750(a5) # 80019c4c <log+0x2c>
  write_head(); // clear the log
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	e34080e7          	jalr	-460(ra) # 800033b2 <write_head>
}
    80003586:	70a2                	ld	ra,40(sp)
    80003588:	7402                	ld	s0,32(sp)
    8000358a:	64e2                	ld	s1,24(sp)
    8000358c:	6942                	ld	s2,16(sp)
    8000358e:	69a2                	ld	s3,8(sp)
    80003590:	6145                	addi	sp,sp,48
    80003592:	8082                	ret

0000000080003594 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003594:	1101                	addi	sp,sp,-32
    80003596:	ec06                	sd	ra,24(sp)
    80003598:	e822                	sd	s0,16(sp)
    8000359a:	e426                	sd	s1,8(sp)
    8000359c:	e04a                	sd	s2,0(sp)
    8000359e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a0:	00016517          	auipc	a0,0x16
    800035a4:	68050513          	addi	a0,a0,1664 # 80019c20 <log>
    800035a8:	00003097          	auipc	ra,0x3
    800035ac:	c90080e7          	jalr	-880(ra) # 80006238 <acquire>
  while(1){
    if(log.committing){
    800035b0:	00016497          	auipc	s1,0x16
    800035b4:	67048493          	addi	s1,s1,1648 # 80019c20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b8:	4979                	li	s2,30
    800035ba:	a039                	j	800035c8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035bc:	85a6                	mv	a1,s1
    800035be:	8526                	mv	a0,s1
    800035c0:	ffffe097          	auipc	ra,0xffffe
    800035c4:	f94080e7          	jalr	-108(ra) # 80001554 <sleep>
    if(log.committing){
    800035c8:	50dc                	lw	a5,36(s1)
    800035ca:	fbed                	bnez	a5,800035bc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035cc:	509c                	lw	a5,32(s1)
    800035ce:	0017871b          	addiw	a4,a5,1
    800035d2:	0007069b          	sext.w	a3,a4
    800035d6:	0027179b          	slliw	a5,a4,0x2
    800035da:	9fb9                	addw	a5,a5,a4
    800035dc:	0017979b          	slliw	a5,a5,0x1
    800035e0:	54d8                	lw	a4,44(s1)
    800035e2:	9fb9                	addw	a5,a5,a4
    800035e4:	00f95963          	bge	s2,a5,800035f6 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e8:	85a6                	mv	a1,s1
    800035ea:	8526                	mv	a0,s1
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	f68080e7          	jalr	-152(ra) # 80001554 <sleep>
    800035f4:	bfd1                	j	800035c8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035f6:	00016517          	auipc	a0,0x16
    800035fa:	62a50513          	addi	a0,a0,1578 # 80019c20 <log>
    800035fe:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003600:	00003097          	auipc	ra,0x3
    80003604:	cec080e7          	jalr	-788(ra) # 800062ec <release>
      break;
    }
  }
}
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6902                	ld	s2,0(sp)
    80003610:	6105                	addi	sp,sp,32
    80003612:	8082                	ret

0000000080003614 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003614:	7139                	addi	sp,sp,-64
    80003616:	fc06                	sd	ra,56(sp)
    80003618:	f822                	sd	s0,48(sp)
    8000361a:	f426                	sd	s1,40(sp)
    8000361c:	f04a                	sd	s2,32(sp)
    8000361e:	ec4e                	sd	s3,24(sp)
    80003620:	e852                	sd	s4,16(sp)
    80003622:	e456                	sd	s5,8(sp)
    80003624:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003626:	00016497          	auipc	s1,0x16
    8000362a:	5fa48493          	addi	s1,s1,1530 # 80019c20 <log>
    8000362e:	8526                	mv	a0,s1
    80003630:	00003097          	auipc	ra,0x3
    80003634:	c08080e7          	jalr	-1016(ra) # 80006238 <acquire>
  log.outstanding -= 1;
    80003638:	509c                	lw	a5,32(s1)
    8000363a:	37fd                	addiw	a5,a5,-1
    8000363c:	0007891b          	sext.w	s2,a5
    80003640:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003642:	50dc                	lw	a5,36(s1)
    80003644:	efb9                	bnez	a5,800036a2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003646:	06091663          	bnez	s2,800036b2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000364a:	00016497          	auipc	s1,0x16
    8000364e:	5d648493          	addi	s1,s1,1494 # 80019c20 <log>
    80003652:	4785                	li	a5,1
    80003654:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003656:	8526                	mv	a0,s1
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	c94080e7          	jalr	-876(ra) # 800062ec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003660:	54dc                	lw	a5,44(s1)
    80003662:	06f04763          	bgtz	a5,800036d0 <end_op+0xbc>
    acquire(&log.lock);
    80003666:	00016497          	auipc	s1,0x16
    8000366a:	5ba48493          	addi	s1,s1,1466 # 80019c20 <log>
    8000366e:	8526                	mv	a0,s1
    80003670:	00003097          	auipc	ra,0x3
    80003674:	bc8080e7          	jalr	-1080(ra) # 80006238 <acquire>
    log.committing = 0;
    80003678:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000367c:	8526                	mv	a0,s1
    8000367e:	ffffe097          	auipc	ra,0xffffe
    80003682:	062080e7          	jalr	98(ra) # 800016e0 <wakeup>
    release(&log.lock);
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	c64080e7          	jalr	-924(ra) # 800062ec <release>
}
    80003690:	70e2                	ld	ra,56(sp)
    80003692:	7442                	ld	s0,48(sp)
    80003694:	74a2                	ld	s1,40(sp)
    80003696:	7902                	ld	s2,32(sp)
    80003698:	69e2                	ld	s3,24(sp)
    8000369a:	6a42                	ld	s4,16(sp)
    8000369c:	6aa2                	ld	s5,8(sp)
    8000369e:	6121                	addi	sp,sp,64
    800036a0:	8082                	ret
    panic("log.committing");
    800036a2:	00005517          	auipc	a0,0x5
    800036a6:	f1650513          	addi	a0,a0,-234 # 800085b8 <syscalls+0x1f0>
    800036aa:	00002097          	auipc	ra,0x2
    800036ae:	66e080e7          	jalr	1646(ra) # 80005d18 <panic>
    wakeup(&log);
    800036b2:	00016497          	auipc	s1,0x16
    800036b6:	56e48493          	addi	s1,s1,1390 # 80019c20 <log>
    800036ba:	8526                	mv	a0,s1
    800036bc:	ffffe097          	auipc	ra,0xffffe
    800036c0:	024080e7          	jalr	36(ra) # 800016e0 <wakeup>
  release(&log.lock);
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	c26080e7          	jalr	-986(ra) # 800062ec <release>
  if(do_commit){
    800036ce:	b7c9                	j	80003690 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d0:	00016a97          	auipc	s5,0x16
    800036d4:	580a8a93          	addi	s5,s5,1408 # 80019c50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d8:	00016a17          	auipc	s4,0x16
    800036dc:	548a0a13          	addi	s4,s4,1352 # 80019c20 <log>
    800036e0:	018a2583          	lw	a1,24(s4)
    800036e4:	012585bb          	addw	a1,a1,s2
    800036e8:	2585                	addiw	a1,a1,1
    800036ea:	028a2503          	lw	a0,40(s4)
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	cd2080e7          	jalr	-814(ra) # 800023c0 <bread>
    800036f6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f8:	000aa583          	lw	a1,0(s5)
    800036fc:	028a2503          	lw	a0,40(s4)
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	cc0080e7          	jalr	-832(ra) # 800023c0 <bread>
    80003708:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000370a:	40000613          	li	a2,1024
    8000370e:	05850593          	addi	a1,a0,88
    80003712:	05848513          	addi	a0,s1,88
    80003716:	ffffd097          	auipc	ra,0xffffd
    8000371a:	ac2080e7          	jalr	-1342(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000371e:	8526                	mv	a0,s1
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	d92080e7          	jalr	-622(ra) # 800024b2 <bwrite>
    brelse(from);
    80003728:	854e                	mv	a0,s3
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	dc6080e7          	jalr	-570(ra) # 800024f0 <brelse>
    brelse(to);
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	dbc080e7          	jalr	-580(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000373c:	2905                	addiw	s2,s2,1
    8000373e:	0a91                	addi	s5,s5,4
    80003740:	02ca2783          	lw	a5,44(s4)
    80003744:	f8f94ee3          	blt	s2,a5,800036e0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	c6a080e7          	jalr	-918(ra) # 800033b2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003750:	4501                	li	a0,0
    80003752:	00000097          	auipc	ra,0x0
    80003756:	cda080e7          	jalr	-806(ra) # 8000342c <install_trans>
    log.lh.n = 0;
    8000375a:	00016797          	auipc	a5,0x16
    8000375e:	4e07a923          	sw	zero,1266(a5) # 80019c4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003762:	00000097          	auipc	ra,0x0
    80003766:	c50080e7          	jalr	-944(ra) # 800033b2 <write_head>
    8000376a:	bdf5                	j	80003666 <end_op+0x52>

000000008000376c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000376c:	1101                	addi	sp,sp,-32
    8000376e:	ec06                	sd	ra,24(sp)
    80003770:	e822                	sd	s0,16(sp)
    80003772:	e426                	sd	s1,8(sp)
    80003774:	e04a                	sd	s2,0(sp)
    80003776:	1000                	addi	s0,sp,32
    80003778:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000377a:	00016917          	auipc	s2,0x16
    8000377e:	4a690913          	addi	s2,s2,1190 # 80019c20 <log>
    80003782:	854a                	mv	a0,s2
    80003784:	00003097          	auipc	ra,0x3
    80003788:	ab4080e7          	jalr	-1356(ra) # 80006238 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000378c:	02c92603          	lw	a2,44(s2)
    80003790:	47f5                	li	a5,29
    80003792:	06c7c563          	blt	a5,a2,800037fc <log_write+0x90>
    80003796:	00016797          	auipc	a5,0x16
    8000379a:	4a67a783          	lw	a5,1190(a5) # 80019c3c <log+0x1c>
    8000379e:	37fd                	addiw	a5,a5,-1
    800037a0:	04f65e63          	bge	a2,a5,800037fc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a4:	00016797          	auipc	a5,0x16
    800037a8:	49c7a783          	lw	a5,1180(a5) # 80019c40 <log+0x20>
    800037ac:	06f05063          	blez	a5,8000380c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b0:	4781                	li	a5,0
    800037b2:	06c05563          	blez	a2,8000381c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b6:	44cc                	lw	a1,12(s1)
    800037b8:	00016717          	auipc	a4,0x16
    800037bc:	49870713          	addi	a4,a4,1176 # 80019c50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c2:	4314                	lw	a3,0(a4)
    800037c4:	04b68c63          	beq	a3,a1,8000381c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c8:	2785                	addiw	a5,a5,1
    800037ca:	0711                	addi	a4,a4,4
    800037cc:	fef61be3          	bne	a2,a5,800037c2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d0:	0621                	addi	a2,a2,8
    800037d2:	060a                	slli	a2,a2,0x2
    800037d4:	00016797          	auipc	a5,0x16
    800037d8:	44c78793          	addi	a5,a5,1100 # 80019c20 <log>
    800037dc:	963e                	add	a2,a2,a5
    800037de:	44dc                	lw	a5,12(s1)
    800037e0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037e2:	8526                	mv	a0,s1
    800037e4:	fffff097          	auipc	ra,0xfffff
    800037e8:	daa080e7          	jalr	-598(ra) # 8000258e <bpin>
    log.lh.n++;
    800037ec:	00016717          	auipc	a4,0x16
    800037f0:	43470713          	addi	a4,a4,1076 # 80019c20 <log>
    800037f4:	575c                	lw	a5,44(a4)
    800037f6:	2785                	addiw	a5,a5,1
    800037f8:	d75c                	sw	a5,44(a4)
    800037fa:	a835                	j	80003836 <log_write+0xca>
    panic("too big a transaction");
    800037fc:	00005517          	auipc	a0,0x5
    80003800:	dcc50513          	addi	a0,a0,-564 # 800085c8 <syscalls+0x200>
    80003804:	00002097          	auipc	ra,0x2
    80003808:	514080e7          	jalr	1300(ra) # 80005d18 <panic>
    panic("log_write outside of trans");
    8000380c:	00005517          	auipc	a0,0x5
    80003810:	dd450513          	addi	a0,a0,-556 # 800085e0 <syscalls+0x218>
    80003814:	00002097          	auipc	ra,0x2
    80003818:	504080e7          	jalr	1284(ra) # 80005d18 <panic>
  log.lh.block[i] = b->blockno;
    8000381c:	00878713          	addi	a4,a5,8
    80003820:	00271693          	slli	a3,a4,0x2
    80003824:	00016717          	auipc	a4,0x16
    80003828:	3fc70713          	addi	a4,a4,1020 # 80019c20 <log>
    8000382c:	9736                	add	a4,a4,a3
    8000382e:	44d4                	lw	a3,12(s1)
    80003830:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003832:	faf608e3          	beq	a2,a5,800037e2 <log_write+0x76>
  }
  release(&log.lock);
    80003836:	00016517          	auipc	a0,0x16
    8000383a:	3ea50513          	addi	a0,a0,1002 # 80019c20 <log>
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	aae080e7          	jalr	-1362(ra) # 800062ec <release>
}
    80003846:	60e2                	ld	ra,24(sp)
    80003848:	6442                	ld	s0,16(sp)
    8000384a:	64a2                	ld	s1,8(sp)
    8000384c:	6902                	ld	s2,0(sp)
    8000384e:	6105                	addi	sp,sp,32
    80003850:	8082                	ret

0000000080003852 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003852:	1101                	addi	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	e04a                	sd	s2,0(sp)
    8000385c:	1000                	addi	s0,sp,32
    8000385e:	84aa                	mv	s1,a0
    80003860:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003862:	00005597          	auipc	a1,0x5
    80003866:	d9e58593          	addi	a1,a1,-610 # 80008600 <syscalls+0x238>
    8000386a:	0521                	addi	a0,a0,8
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	93c080e7          	jalr	-1732(ra) # 800061a8 <initlock>
  lk->name = name;
    80003874:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003878:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387c:	0204a423          	sw	zero,40(s1)
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389a:	00850913          	addi	s2,a0,8
    8000389e:	854a                	mv	a0,s2
    800038a0:	00003097          	auipc	ra,0x3
    800038a4:	998080e7          	jalr	-1640(ra) # 80006238 <acquire>
  while (lk->locked) {
    800038a8:	409c                	lw	a5,0(s1)
    800038aa:	cb89                	beqz	a5,800038bc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ac:	85ca                	mv	a1,s2
    800038ae:	8526                	mv	a0,s1
    800038b0:	ffffe097          	auipc	ra,0xffffe
    800038b4:	ca4080e7          	jalr	-860(ra) # 80001554 <sleep>
  while (lk->locked) {
    800038b8:	409c                	lw	a5,0(s1)
    800038ba:	fbed                	bnez	a5,800038ac <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038bc:	4785                	li	a5,1
    800038be:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	588080e7          	jalr	1416(ra) # 80000e48 <myproc>
    800038c8:	591c                	lw	a5,48(a0)
    800038ca:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038cc:	854a                	mv	a0,s2
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	a1e080e7          	jalr	-1506(ra) # 800062ec <release>
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret

00000000800038e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	e04a                	sd	s2,0(sp)
    800038ec:	1000                	addi	s0,sp,32
    800038ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f0:	00850913          	addi	s2,a0,8
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	942080e7          	jalr	-1726(ra) # 80006238 <acquire>
  lk->locked = 0;
    800038fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003902:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003906:	8526                	mv	a0,s1
    80003908:	ffffe097          	auipc	ra,0xffffe
    8000390c:	dd8080e7          	jalr	-552(ra) # 800016e0 <wakeup>
  release(&lk->lk);
    80003910:	854a                	mv	a0,s2
    80003912:	00003097          	auipc	ra,0x3
    80003916:	9da080e7          	jalr	-1574(ra) # 800062ec <release>
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003926:	7179                	addi	sp,sp,-48
    80003928:	f406                	sd	ra,40(sp)
    8000392a:	f022                	sd	s0,32(sp)
    8000392c:	ec26                	sd	s1,24(sp)
    8000392e:	e84a                	sd	s2,16(sp)
    80003930:	e44e                	sd	s3,8(sp)
    80003932:	1800                	addi	s0,sp,48
    80003934:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003936:	00850913          	addi	s2,a0,8
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	8fc080e7          	jalr	-1796(ra) # 80006238 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003944:	409c                	lw	a5,0(s1)
    80003946:	ef99                	bnez	a5,80003964 <holdingsleep+0x3e>
    80003948:	4481                	li	s1,0
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	9a0080e7          	jalr	-1632(ra) # 800062ec <release>
  return r;
}
    80003954:	8526                	mv	a0,s1
    80003956:	70a2                	ld	ra,40(sp)
    80003958:	7402                	ld	s0,32(sp)
    8000395a:	64e2                	ld	s1,24(sp)
    8000395c:	6942                	ld	s2,16(sp)
    8000395e:	69a2                	ld	s3,8(sp)
    80003960:	6145                	addi	sp,sp,48
    80003962:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003964:	0284a983          	lw	s3,40(s1)
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	4e0080e7          	jalr	1248(ra) # 80000e48 <myproc>
    80003970:	5904                	lw	s1,48(a0)
    80003972:	413484b3          	sub	s1,s1,s3
    80003976:	0014b493          	seqz	s1,s1
    8000397a:	bfc1                	j	8000394a <holdingsleep+0x24>

000000008000397c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000397c:	1141                	addi	sp,sp,-16
    8000397e:	e406                	sd	ra,8(sp)
    80003980:	e022                	sd	s0,0(sp)
    80003982:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003984:	00005597          	auipc	a1,0x5
    80003988:	c8c58593          	addi	a1,a1,-884 # 80008610 <syscalls+0x248>
    8000398c:	00016517          	auipc	a0,0x16
    80003990:	3dc50513          	addi	a0,a0,988 # 80019d68 <ftable>
    80003994:	00003097          	auipc	ra,0x3
    80003998:	814080e7          	jalr	-2028(ra) # 800061a8 <initlock>
}
    8000399c:	60a2                	ld	ra,8(sp)
    8000399e:	6402                	ld	s0,0(sp)
    800039a0:	0141                	addi	sp,sp,16
    800039a2:	8082                	ret

00000000800039a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039a4:	1101                	addi	sp,sp,-32
    800039a6:	ec06                	sd	ra,24(sp)
    800039a8:	e822                	sd	s0,16(sp)
    800039aa:	e426                	sd	s1,8(sp)
    800039ac:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039ae:	00016517          	auipc	a0,0x16
    800039b2:	3ba50513          	addi	a0,a0,954 # 80019d68 <ftable>
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	882080e7          	jalr	-1918(ra) # 80006238 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039be:	00016497          	auipc	s1,0x16
    800039c2:	3c248493          	addi	s1,s1,962 # 80019d80 <ftable+0x18>
    800039c6:	00017717          	auipc	a4,0x17
    800039ca:	35a70713          	addi	a4,a4,858 # 8001ad20 <ftable+0xfb8>
    if(f->ref == 0){
    800039ce:	40dc                	lw	a5,4(s1)
    800039d0:	cf99                	beqz	a5,800039ee <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d2:	02848493          	addi	s1,s1,40
    800039d6:	fee49ce3          	bne	s1,a4,800039ce <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039da:	00016517          	auipc	a0,0x16
    800039de:	38e50513          	addi	a0,a0,910 # 80019d68 <ftable>
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	90a080e7          	jalr	-1782(ra) # 800062ec <release>
  return 0;
    800039ea:	4481                	li	s1,0
    800039ec:	a819                	j	80003a02 <filealloc+0x5e>
      f->ref = 1;
    800039ee:	4785                	li	a5,1
    800039f0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039f2:	00016517          	auipc	a0,0x16
    800039f6:	37650513          	addi	a0,a0,886 # 80019d68 <ftable>
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	8f2080e7          	jalr	-1806(ra) # 800062ec <release>
}
    80003a02:	8526                	mv	a0,s1
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	1000                	addi	s0,sp,32
    80003a18:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a1a:	00016517          	auipc	a0,0x16
    80003a1e:	34e50513          	addi	a0,a0,846 # 80019d68 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	816080e7          	jalr	-2026(ra) # 80006238 <acquire>
  if(f->ref < 1)
    80003a2a:	40dc                	lw	a5,4(s1)
    80003a2c:	02f05263          	blez	a5,80003a50 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a30:	2785                	addiw	a5,a5,1
    80003a32:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a34:	00016517          	auipc	a0,0x16
    80003a38:	33450513          	addi	a0,a0,820 # 80019d68 <ftable>
    80003a3c:	00003097          	auipc	ra,0x3
    80003a40:	8b0080e7          	jalr	-1872(ra) # 800062ec <release>
  return f;
}
    80003a44:	8526                	mv	a0,s1
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6105                	addi	sp,sp,32
    80003a4e:	8082                	ret
    panic("filedup");
    80003a50:	00005517          	auipc	a0,0x5
    80003a54:	bc850513          	addi	a0,a0,-1080 # 80008618 <syscalls+0x250>
    80003a58:	00002097          	auipc	ra,0x2
    80003a5c:	2c0080e7          	jalr	704(ra) # 80005d18 <panic>

0000000080003a60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a60:	7139                	addi	sp,sp,-64
    80003a62:	fc06                	sd	ra,56(sp)
    80003a64:	f822                	sd	s0,48(sp)
    80003a66:	f426                	sd	s1,40(sp)
    80003a68:	f04a                	sd	s2,32(sp)
    80003a6a:	ec4e                	sd	s3,24(sp)
    80003a6c:	e852                	sd	s4,16(sp)
    80003a6e:	e456                	sd	s5,8(sp)
    80003a70:	0080                	addi	s0,sp,64
    80003a72:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a74:	00016517          	auipc	a0,0x16
    80003a78:	2f450513          	addi	a0,a0,756 # 80019d68 <ftable>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	7bc080e7          	jalr	1980(ra) # 80006238 <acquire>
  if(f->ref < 1)
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	06f05163          	blez	a5,80003ae8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a8a:	37fd                	addiw	a5,a5,-1
    80003a8c:	0007871b          	sext.w	a4,a5
    80003a90:	c0dc                	sw	a5,4(s1)
    80003a92:	06e04363          	bgtz	a4,80003af8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a96:	0004a903          	lw	s2,0(s1)
    80003a9a:	0094ca83          	lbu	s5,9(s1)
    80003a9e:	0104ba03          	ld	s4,16(s1)
    80003aa2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aaa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aae:	00016517          	auipc	a0,0x16
    80003ab2:	2ba50513          	addi	a0,a0,698 # 80019d68 <ftable>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	836080e7          	jalr	-1994(ra) # 800062ec <release>

  if(ff.type == FD_PIPE){
    80003abe:	4785                	li	a5,1
    80003ac0:	04f90d63          	beq	s2,a5,80003b1a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ac4:	3979                	addiw	s2,s2,-2
    80003ac6:	4785                	li	a5,1
    80003ac8:	0527e063          	bltu	a5,s2,80003b08 <fileclose+0xa8>
    begin_op();
    80003acc:	00000097          	auipc	ra,0x0
    80003ad0:	ac8080e7          	jalr	-1336(ra) # 80003594 <begin_op>
    iput(ff.ip);
    80003ad4:	854e                	mv	a0,s3
    80003ad6:	fffff097          	auipc	ra,0xfffff
    80003ada:	2a6080e7          	jalr	678(ra) # 80002d7c <iput>
    end_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	b36080e7          	jalr	-1226(ra) # 80003614 <end_op>
    80003ae6:	a00d                	j	80003b08 <fileclose+0xa8>
    panic("fileclose");
    80003ae8:	00005517          	auipc	a0,0x5
    80003aec:	b3850513          	addi	a0,a0,-1224 # 80008620 <syscalls+0x258>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	228080e7          	jalr	552(ra) # 80005d18 <panic>
    release(&ftable.lock);
    80003af8:	00016517          	auipc	a0,0x16
    80003afc:	27050513          	addi	a0,a0,624 # 80019d68 <ftable>
    80003b00:	00002097          	auipc	ra,0x2
    80003b04:	7ec080e7          	jalr	2028(ra) # 800062ec <release>
  }
}
    80003b08:	70e2                	ld	ra,56(sp)
    80003b0a:	7442                	ld	s0,48(sp)
    80003b0c:	74a2                	ld	s1,40(sp)
    80003b0e:	7902                	ld	s2,32(sp)
    80003b10:	69e2                	ld	s3,24(sp)
    80003b12:	6a42                	ld	s4,16(sp)
    80003b14:	6aa2                	ld	s5,8(sp)
    80003b16:	6121                	addi	sp,sp,64
    80003b18:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b1a:	85d6                	mv	a1,s5
    80003b1c:	8552                	mv	a0,s4
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	34c080e7          	jalr	844(ra) # 80003e6a <pipeclose>
    80003b26:	b7cd                	j	80003b08 <fileclose+0xa8>

0000000080003b28 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b28:	715d                	addi	sp,sp,-80
    80003b2a:	e486                	sd	ra,72(sp)
    80003b2c:	e0a2                	sd	s0,64(sp)
    80003b2e:	fc26                	sd	s1,56(sp)
    80003b30:	f84a                	sd	s2,48(sp)
    80003b32:	f44e                	sd	s3,40(sp)
    80003b34:	0880                	addi	s0,sp,80
    80003b36:	84aa                	mv	s1,a0
    80003b38:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	30e080e7          	jalr	782(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b42:	409c                	lw	a5,0(s1)
    80003b44:	37f9                	addiw	a5,a5,-2
    80003b46:	4705                	li	a4,1
    80003b48:	04f76763          	bltu	a4,a5,80003b96 <filestat+0x6e>
    80003b4c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b4e:	6c88                	ld	a0,24(s1)
    80003b50:	fffff097          	auipc	ra,0xfffff
    80003b54:	072080e7          	jalr	114(ra) # 80002bc2 <ilock>
    stati(f->ip, &st);
    80003b58:	fb840593          	addi	a1,s0,-72
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	2ee080e7          	jalr	750(ra) # 80002e4c <stati>
    iunlock(f->ip);
    80003b66:	6c88                	ld	a0,24(s1)
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	11c080e7          	jalr	284(ra) # 80002c84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b70:	46e1                	li	a3,24
    80003b72:	fb840613          	addi	a2,s0,-72
    80003b76:	85ce                	mv	a1,s3
    80003b78:	05093503          	ld	a0,80(s2)
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	f8e080e7          	jalr	-114(ra) # 80000b0a <copyout>
    80003b84:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b88:	60a6                	ld	ra,72(sp)
    80003b8a:	6406                	ld	s0,64(sp)
    80003b8c:	74e2                	ld	s1,56(sp)
    80003b8e:	7942                	ld	s2,48(sp)
    80003b90:	79a2                	ld	s3,40(sp)
    80003b92:	6161                	addi	sp,sp,80
    80003b94:	8082                	ret
  return -1;
    80003b96:	557d                	li	a0,-1
    80003b98:	bfc5                	j	80003b88 <filestat+0x60>

0000000080003b9a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b9a:	7179                	addi	sp,sp,-48
    80003b9c:	f406                	sd	ra,40(sp)
    80003b9e:	f022                	sd	s0,32(sp)
    80003ba0:	ec26                	sd	s1,24(sp)
    80003ba2:	e84a                	sd	s2,16(sp)
    80003ba4:	e44e                	sd	s3,8(sp)
    80003ba6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ba8:	00854783          	lbu	a5,8(a0)
    80003bac:	c3d5                	beqz	a5,80003c50 <fileread+0xb6>
    80003bae:	84aa                	mv	s1,a0
    80003bb0:	89ae                	mv	s3,a1
    80003bb2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bb4:	411c                	lw	a5,0(a0)
    80003bb6:	4705                	li	a4,1
    80003bb8:	04e78963          	beq	a5,a4,80003c0a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bbc:	470d                	li	a4,3
    80003bbe:	04e78d63          	beq	a5,a4,80003c18 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bc2:	4709                	li	a4,2
    80003bc4:	06e79e63          	bne	a5,a4,80003c40 <fileread+0xa6>
    ilock(f->ip);
    80003bc8:	6d08                	ld	a0,24(a0)
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	ff8080e7          	jalr	-8(ra) # 80002bc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bd2:	874a                	mv	a4,s2
    80003bd4:	5094                	lw	a3,32(s1)
    80003bd6:	864e                	mv	a2,s3
    80003bd8:	4585                	li	a1,1
    80003bda:	6c88                	ld	a0,24(s1)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	29a080e7          	jalr	666(ra) # 80002e76 <readi>
    80003be4:	892a                	mv	s2,a0
    80003be6:	00a05563          	blez	a0,80003bf0 <fileread+0x56>
      f->off += r;
    80003bea:	509c                	lw	a5,32(s1)
    80003bec:	9fa9                	addw	a5,a5,a0
    80003bee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	092080e7          	jalr	146(ra) # 80002c84 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bfa:	854a                	mv	a0,s2
    80003bfc:	70a2                	ld	ra,40(sp)
    80003bfe:	7402                	ld	s0,32(sp)
    80003c00:	64e2                	ld	s1,24(sp)
    80003c02:	6942                	ld	s2,16(sp)
    80003c04:	69a2                	ld	s3,8(sp)
    80003c06:	6145                	addi	sp,sp,48
    80003c08:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c0a:	6908                	ld	a0,16(a0)
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	3c8080e7          	jalr	968(ra) # 80003fd4 <piperead>
    80003c14:	892a                	mv	s2,a0
    80003c16:	b7d5                	j	80003bfa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c18:	02451783          	lh	a5,36(a0)
    80003c1c:	03079693          	slli	a3,a5,0x30
    80003c20:	92c1                	srli	a3,a3,0x30
    80003c22:	4725                	li	a4,9
    80003c24:	02d76863          	bltu	a4,a3,80003c54 <fileread+0xba>
    80003c28:	0792                	slli	a5,a5,0x4
    80003c2a:	00016717          	auipc	a4,0x16
    80003c2e:	09e70713          	addi	a4,a4,158 # 80019cc8 <devsw>
    80003c32:	97ba                	add	a5,a5,a4
    80003c34:	639c                	ld	a5,0(a5)
    80003c36:	c38d                	beqz	a5,80003c58 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c38:	4505                	li	a0,1
    80003c3a:	9782                	jalr	a5
    80003c3c:	892a                	mv	s2,a0
    80003c3e:	bf75                	j	80003bfa <fileread+0x60>
    panic("fileread");
    80003c40:	00005517          	auipc	a0,0x5
    80003c44:	9f050513          	addi	a0,a0,-1552 # 80008630 <syscalls+0x268>
    80003c48:	00002097          	auipc	ra,0x2
    80003c4c:	0d0080e7          	jalr	208(ra) # 80005d18 <panic>
    return -1;
    80003c50:	597d                	li	s2,-1
    80003c52:	b765                	j	80003bfa <fileread+0x60>
      return -1;
    80003c54:	597d                	li	s2,-1
    80003c56:	b755                	j	80003bfa <fileread+0x60>
    80003c58:	597d                	li	s2,-1
    80003c5a:	b745                	j	80003bfa <fileread+0x60>

0000000080003c5c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c5c:	715d                	addi	sp,sp,-80
    80003c5e:	e486                	sd	ra,72(sp)
    80003c60:	e0a2                	sd	s0,64(sp)
    80003c62:	fc26                	sd	s1,56(sp)
    80003c64:	f84a                	sd	s2,48(sp)
    80003c66:	f44e                	sd	s3,40(sp)
    80003c68:	f052                	sd	s4,32(sp)
    80003c6a:	ec56                	sd	s5,24(sp)
    80003c6c:	e85a                	sd	s6,16(sp)
    80003c6e:	e45e                	sd	s7,8(sp)
    80003c70:	e062                	sd	s8,0(sp)
    80003c72:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c74:	00954783          	lbu	a5,9(a0)
    80003c78:	10078663          	beqz	a5,80003d84 <filewrite+0x128>
    80003c7c:	892a                	mv	s2,a0
    80003c7e:	8aae                	mv	s5,a1
    80003c80:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c82:	411c                	lw	a5,0(a0)
    80003c84:	4705                	li	a4,1
    80003c86:	02e78263          	beq	a5,a4,80003caa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c8a:	470d                	li	a4,3
    80003c8c:	02e78663          	beq	a5,a4,80003cb8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c90:	4709                	li	a4,2
    80003c92:	0ee79163          	bne	a5,a4,80003d74 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c96:	0ac05d63          	blez	a2,80003d50 <filewrite+0xf4>
    int i = 0;
    80003c9a:	4981                	li	s3,0
    80003c9c:	6b05                	lui	s6,0x1
    80003c9e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ca2:	6b85                	lui	s7,0x1
    80003ca4:	c00b8b9b          	addiw	s7,s7,-1024
    80003ca8:	a861                	j	80003d40 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003caa:	6908                	ld	a0,16(a0)
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	22e080e7          	jalr	558(ra) # 80003eda <pipewrite>
    80003cb4:	8a2a                	mv	s4,a0
    80003cb6:	a045                	j	80003d56 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb8:	02451783          	lh	a5,36(a0)
    80003cbc:	03079693          	slli	a3,a5,0x30
    80003cc0:	92c1                	srli	a3,a3,0x30
    80003cc2:	4725                	li	a4,9
    80003cc4:	0cd76263          	bltu	a4,a3,80003d88 <filewrite+0x12c>
    80003cc8:	0792                	slli	a5,a5,0x4
    80003cca:	00016717          	auipc	a4,0x16
    80003cce:	ffe70713          	addi	a4,a4,-2 # 80019cc8 <devsw>
    80003cd2:	97ba                	add	a5,a5,a4
    80003cd4:	679c                	ld	a5,8(a5)
    80003cd6:	cbdd                	beqz	a5,80003d8c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cd8:	4505                	li	a0,1
    80003cda:	9782                	jalr	a5
    80003cdc:	8a2a                	mv	s4,a0
    80003cde:	a8a5                	j	80003d56 <filewrite+0xfa>
    80003ce0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ce4:	00000097          	auipc	ra,0x0
    80003ce8:	8b0080e7          	jalr	-1872(ra) # 80003594 <begin_op>
      ilock(f->ip);
    80003cec:	01893503          	ld	a0,24(s2)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	ed2080e7          	jalr	-302(ra) # 80002bc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf8:	8762                	mv	a4,s8
    80003cfa:	02092683          	lw	a3,32(s2)
    80003cfe:	01598633          	add	a2,s3,s5
    80003d02:	4585                	li	a1,1
    80003d04:	01893503          	ld	a0,24(s2)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	266080e7          	jalr	614(ra) # 80002f6e <writei>
    80003d10:	84aa                	mv	s1,a0
    80003d12:	00a05763          	blez	a0,80003d20 <filewrite+0xc4>
        f->off += r;
    80003d16:	02092783          	lw	a5,32(s2)
    80003d1a:	9fa9                	addw	a5,a5,a0
    80003d1c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d20:	01893503          	ld	a0,24(s2)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	f60080e7          	jalr	-160(ra) # 80002c84 <iunlock>
      end_op();
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	8e8080e7          	jalr	-1816(ra) # 80003614 <end_op>

      if(r != n1){
    80003d34:	009c1f63          	bne	s8,s1,80003d52 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d38:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d3c:	0149db63          	bge	s3,s4,80003d52 <filewrite+0xf6>
      int n1 = n - i;
    80003d40:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d44:	84be                	mv	s1,a5
    80003d46:	2781                	sext.w	a5,a5
    80003d48:	f8fb5ce3          	bge	s6,a5,80003ce0 <filewrite+0x84>
    80003d4c:	84de                	mv	s1,s7
    80003d4e:	bf49                	j	80003ce0 <filewrite+0x84>
    int i = 0;
    80003d50:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d52:	013a1f63          	bne	s4,s3,80003d70 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d56:	8552                	mv	a0,s4
    80003d58:	60a6                	ld	ra,72(sp)
    80003d5a:	6406                	ld	s0,64(sp)
    80003d5c:	74e2                	ld	s1,56(sp)
    80003d5e:	7942                	ld	s2,48(sp)
    80003d60:	79a2                	ld	s3,40(sp)
    80003d62:	7a02                	ld	s4,32(sp)
    80003d64:	6ae2                	ld	s5,24(sp)
    80003d66:	6b42                	ld	s6,16(sp)
    80003d68:	6ba2                	ld	s7,8(sp)
    80003d6a:	6c02                	ld	s8,0(sp)
    80003d6c:	6161                	addi	sp,sp,80
    80003d6e:	8082                	ret
    ret = (i == n ? n : -1);
    80003d70:	5a7d                	li	s4,-1
    80003d72:	b7d5                	j	80003d56 <filewrite+0xfa>
    panic("filewrite");
    80003d74:	00005517          	auipc	a0,0x5
    80003d78:	8cc50513          	addi	a0,a0,-1844 # 80008640 <syscalls+0x278>
    80003d7c:	00002097          	auipc	ra,0x2
    80003d80:	f9c080e7          	jalr	-100(ra) # 80005d18 <panic>
    return -1;
    80003d84:	5a7d                	li	s4,-1
    80003d86:	bfc1                	j	80003d56 <filewrite+0xfa>
      return -1;
    80003d88:	5a7d                	li	s4,-1
    80003d8a:	b7f1                	j	80003d56 <filewrite+0xfa>
    80003d8c:	5a7d                	li	s4,-1
    80003d8e:	b7e1                	j	80003d56 <filewrite+0xfa>

0000000080003d90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d90:	7179                	addi	sp,sp,-48
    80003d92:	f406                	sd	ra,40(sp)
    80003d94:	f022                	sd	s0,32(sp)
    80003d96:	ec26                	sd	s1,24(sp)
    80003d98:	e84a                	sd	s2,16(sp)
    80003d9a:	e44e                	sd	s3,8(sp)
    80003d9c:	e052                	sd	s4,0(sp)
    80003d9e:	1800                	addi	s0,sp,48
    80003da0:	84aa                	mv	s1,a0
    80003da2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003da4:	0005b023          	sd	zero,0(a1)
    80003da8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	bf8080e7          	jalr	-1032(ra) # 800039a4 <filealloc>
    80003db4:	e088                	sd	a0,0(s1)
    80003db6:	c551                	beqz	a0,80003e42 <pipealloc+0xb2>
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	bec080e7          	jalr	-1044(ra) # 800039a4 <filealloc>
    80003dc0:	00aa3023          	sd	a0,0(s4)
    80003dc4:	c92d                	beqz	a0,80003e36 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dc6:	ffffc097          	auipc	ra,0xffffc
    80003dca:	352080e7          	jalr	850(ra) # 80000118 <kalloc>
    80003dce:	892a                	mv	s2,a0
    80003dd0:	c125                	beqz	a0,80003e30 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dd2:	4985                	li	s3,1
    80003dd4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ddc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003de4:	00005597          	auipc	a1,0x5
    80003de8:	86c58593          	addi	a1,a1,-1940 # 80008650 <syscalls+0x288>
    80003dec:	00002097          	auipc	ra,0x2
    80003df0:	3bc080e7          	jalr	956(ra) # 800061a8 <initlock>
  (*f0)->type = FD_PIPE;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e0c:	000a3783          	ld	a5,0(s4)
    80003e10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e1c:	000a3783          	ld	a5,0(s4)
    80003e20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e24:	000a3783          	ld	a5,0(s4)
    80003e28:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e2c:	4501                	li	a0,0
    80003e2e:	a025                	j	80003e56 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e30:	6088                	ld	a0,0(s1)
    80003e32:	e501                	bnez	a0,80003e3a <pipealloc+0xaa>
    80003e34:	a039                	j	80003e42 <pipealloc+0xb2>
    80003e36:	6088                	ld	a0,0(s1)
    80003e38:	c51d                	beqz	a0,80003e66 <pipealloc+0xd6>
    fileclose(*f0);
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	c26080e7          	jalr	-986(ra) # 80003a60 <fileclose>
  if(*f1)
    80003e42:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e46:	557d                	li	a0,-1
  if(*f1)
    80003e48:	c799                	beqz	a5,80003e56 <pipealloc+0xc6>
    fileclose(*f1);
    80003e4a:	853e                	mv	a0,a5
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c14080e7          	jalr	-1004(ra) # 80003a60 <fileclose>
  return -1;
    80003e54:	557d                	li	a0,-1
}
    80003e56:	70a2                	ld	ra,40(sp)
    80003e58:	7402                	ld	s0,32(sp)
    80003e5a:	64e2                	ld	s1,24(sp)
    80003e5c:	6942                	ld	s2,16(sp)
    80003e5e:	69a2                	ld	s3,8(sp)
    80003e60:	6a02                	ld	s4,0(sp)
    80003e62:	6145                	addi	sp,sp,48
    80003e64:	8082                	ret
  return -1;
    80003e66:	557d                	li	a0,-1
    80003e68:	b7fd                	j	80003e56 <pipealloc+0xc6>

0000000080003e6a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6a:	1101                	addi	sp,sp,-32
    80003e6c:	ec06                	sd	ra,24(sp)
    80003e6e:	e822                	sd	s0,16(sp)
    80003e70:	e426                	sd	s1,8(sp)
    80003e72:	e04a                	sd	s2,0(sp)
    80003e74:	1000                	addi	s0,sp,32
    80003e76:	84aa                	mv	s1,a0
    80003e78:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	3be080e7          	jalr	958(ra) # 80006238 <acquire>
  if(writable){
    80003e82:	02090d63          	beqz	s2,80003ebc <pipeclose+0x52>
    pi->writeopen = 0;
    80003e86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8a:	21848513          	addi	a0,s1,536
    80003e8e:	ffffe097          	auipc	ra,0xffffe
    80003e92:	852080e7          	jalr	-1966(ra) # 800016e0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e96:	2204b783          	ld	a5,544(s1)
    80003e9a:	eb95                	bnez	a5,80003ece <pipeclose+0x64>
    release(&pi->lock);
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	00002097          	auipc	ra,0x2
    80003ea2:	44e080e7          	jalr	1102(ra) # 800062ec <release>
    kfree((char*)pi);
    80003ea6:	8526                	mv	a0,s1
    80003ea8:	ffffc097          	auipc	ra,0xffffc
    80003eac:	174080e7          	jalr	372(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb0:	60e2                	ld	ra,24(sp)
    80003eb2:	6442                	ld	s0,16(sp)
    80003eb4:	64a2                	ld	s1,8(sp)
    80003eb6:	6902                	ld	s2,0(sp)
    80003eb8:	6105                	addi	sp,sp,32
    80003eba:	8082                	ret
    pi->readopen = 0;
    80003ebc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec0:	21c48513          	addi	a0,s1,540
    80003ec4:	ffffe097          	auipc	ra,0xffffe
    80003ec8:	81c080e7          	jalr	-2020(ra) # 800016e0 <wakeup>
    80003ecc:	b7e9                	j	80003e96 <pipeclose+0x2c>
    release(&pi->lock);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	00002097          	auipc	ra,0x2
    80003ed4:	41c080e7          	jalr	1052(ra) # 800062ec <release>
}
    80003ed8:	bfe1                	j	80003eb0 <pipeclose+0x46>

0000000080003eda <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eda:	7159                	addi	sp,sp,-112
    80003edc:	f486                	sd	ra,104(sp)
    80003ede:	f0a2                	sd	s0,96(sp)
    80003ee0:	eca6                	sd	s1,88(sp)
    80003ee2:	e8ca                	sd	s2,80(sp)
    80003ee4:	e4ce                	sd	s3,72(sp)
    80003ee6:	e0d2                	sd	s4,64(sp)
    80003ee8:	fc56                	sd	s5,56(sp)
    80003eea:	f85a                	sd	s6,48(sp)
    80003eec:	f45e                	sd	s7,40(sp)
    80003eee:	f062                	sd	s8,32(sp)
    80003ef0:	ec66                	sd	s9,24(sp)
    80003ef2:	1880                	addi	s0,sp,112
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	8aae                	mv	s5,a1
    80003ef8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	f4e080e7          	jalr	-178(ra) # 80000e48 <myproc>
    80003f02:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	332080e7          	jalr	818(ra) # 80006238 <acquire>
  while(i < n){
    80003f0e:	0d405163          	blez	s4,80003fd0 <pipewrite+0xf6>
    80003f12:	8ba6                	mv	s7,s1
  int i = 0;
    80003f14:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f16:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f18:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f1c:	21c48c13          	addi	s8,s1,540
    80003f20:	a08d                	j	80003f82 <pipewrite+0xa8>
      release(&pi->lock);
    80003f22:	8526                	mv	a0,s1
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	3c8080e7          	jalr	968(ra) # 800062ec <release>
      return -1;
    80003f2c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f2e:	854a                	mv	a0,s2
    80003f30:	70a6                	ld	ra,104(sp)
    80003f32:	7406                	ld	s0,96(sp)
    80003f34:	64e6                	ld	s1,88(sp)
    80003f36:	6946                	ld	s2,80(sp)
    80003f38:	69a6                	ld	s3,72(sp)
    80003f3a:	6a06                	ld	s4,64(sp)
    80003f3c:	7ae2                	ld	s5,56(sp)
    80003f3e:	7b42                	ld	s6,48(sp)
    80003f40:	7ba2                	ld	s7,40(sp)
    80003f42:	7c02                	ld	s8,32(sp)
    80003f44:	6ce2                	ld	s9,24(sp)
    80003f46:	6165                	addi	sp,sp,112
    80003f48:	8082                	ret
      wakeup(&pi->nread);
    80003f4a:	8566                	mv	a0,s9
    80003f4c:	ffffd097          	auipc	ra,0xffffd
    80003f50:	794080e7          	jalr	1940(ra) # 800016e0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f54:	85de                	mv	a1,s7
    80003f56:	8562                	mv	a0,s8
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	5fc080e7          	jalr	1532(ra) # 80001554 <sleep>
    80003f60:	a839                	j	80003f7e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f62:	21c4a783          	lw	a5,540(s1)
    80003f66:	0017871b          	addiw	a4,a5,1
    80003f6a:	20e4ae23          	sw	a4,540(s1)
    80003f6e:	1ff7f793          	andi	a5,a5,511
    80003f72:	97a6                	add	a5,a5,s1
    80003f74:	f9f44703          	lbu	a4,-97(s0)
    80003f78:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f7c:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f7e:	03495d63          	bge	s2,s4,80003fb8 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f82:	2204a783          	lw	a5,544(s1)
    80003f86:	dfd1                	beqz	a5,80003f22 <pipewrite+0x48>
    80003f88:	0289a783          	lw	a5,40(s3)
    80003f8c:	fbd9                	bnez	a5,80003f22 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f8e:	2184a783          	lw	a5,536(s1)
    80003f92:	21c4a703          	lw	a4,540(s1)
    80003f96:	2007879b          	addiw	a5,a5,512
    80003f9a:	faf708e3          	beq	a4,a5,80003f4a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f9e:	4685                	li	a3,1
    80003fa0:	01590633          	add	a2,s2,s5
    80003fa4:	f9f40593          	addi	a1,s0,-97
    80003fa8:	0509b503          	ld	a0,80(s3)
    80003fac:	ffffd097          	auipc	ra,0xffffd
    80003fb0:	bea080e7          	jalr	-1046(ra) # 80000b96 <copyin>
    80003fb4:	fb6517e3          	bne	a0,s6,80003f62 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fb8:	21848513          	addi	a0,s1,536
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	724080e7          	jalr	1828(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	00002097          	auipc	ra,0x2
    80003fca:	326080e7          	jalr	806(ra) # 800062ec <release>
  return i;
    80003fce:	b785                	j	80003f2e <pipewrite+0x54>
  int i = 0;
    80003fd0:	4901                	li	s2,0
    80003fd2:	b7dd                	j	80003fb8 <pipewrite+0xde>

0000000080003fd4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fd4:	715d                	addi	sp,sp,-80
    80003fd6:	e486                	sd	ra,72(sp)
    80003fd8:	e0a2                	sd	s0,64(sp)
    80003fda:	fc26                	sd	s1,56(sp)
    80003fdc:	f84a                	sd	s2,48(sp)
    80003fde:	f44e                	sd	s3,40(sp)
    80003fe0:	f052                	sd	s4,32(sp)
    80003fe2:	ec56                	sd	s5,24(sp)
    80003fe4:	e85a                	sd	s6,16(sp)
    80003fe6:	0880                	addi	s0,sp,80
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	892e                	mv	s2,a1
    80003fec:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	e5a080e7          	jalr	-422(ra) # 80000e48 <myproc>
    80003ff6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff8:	8b26                	mv	s6,s1
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	23c080e7          	jalr	572(ra) # 80006238 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004004:	2184a703          	lw	a4,536(s1)
    80004008:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000400c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004010:	02f71463          	bne	a4,a5,80004038 <piperead+0x64>
    80004014:	2244a783          	lw	a5,548(s1)
    80004018:	c385                	beqz	a5,80004038 <piperead+0x64>
    if(pr->killed){
    8000401a:	028a2783          	lw	a5,40(s4)
    8000401e:	ebc1                	bnez	a5,800040ae <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004020:	85da                	mv	a1,s6
    80004022:	854e                	mv	a0,s3
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	530080e7          	jalr	1328(ra) # 80001554 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402c:	2184a703          	lw	a4,536(s1)
    80004030:	21c4a783          	lw	a5,540(s1)
    80004034:	fef700e3          	beq	a4,a5,80004014 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004038:	09505263          	blez	s5,800040bc <piperead+0xe8>
    8000403c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004040:	2184a783          	lw	a5,536(s1)
    80004044:	21c4a703          	lw	a4,540(s1)
    80004048:	02f70d63          	beq	a4,a5,80004082 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000404c:	0017871b          	addiw	a4,a5,1
    80004050:	20e4ac23          	sw	a4,536(s1)
    80004054:	1ff7f793          	andi	a5,a5,511
    80004058:	97a6                	add	a5,a5,s1
    8000405a:	0187c783          	lbu	a5,24(a5)
    8000405e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004062:	4685                	li	a3,1
    80004064:	fbf40613          	addi	a2,s0,-65
    80004068:	85ca                	mv	a1,s2
    8000406a:	050a3503          	ld	a0,80(s4)
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	a9c080e7          	jalr	-1380(ra) # 80000b0a <copyout>
    80004076:	01650663          	beq	a0,s6,80004082 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000407a:	2985                	addiw	s3,s3,1
    8000407c:	0905                	addi	s2,s2,1
    8000407e:	fd3a91e3          	bne	s5,s3,80004040 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004082:	21c48513          	addi	a0,s1,540
    80004086:	ffffd097          	auipc	ra,0xffffd
    8000408a:	65a080e7          	jalr	1626(ra) # 800016e0 <wakeup>
  release(&pi->lock);
    8000408e:	8526                	mv	a0,s1
    80004090:	00002097          	auipc	ra,0x2
    80004094:	25c080e7          	jalr	604(ra) # 800062ec <release>
  return i;
}
    80004098:	854e                	mv	a0,s3
    8000409a:	60a6                	ld	ra,72(sp)
    8000409c:	6406                	ld	s0,64(sp)
    8000409e:	74e2                	ld	s1,56(sp)
    800040a0:	7942                	ld	s2,48(sp)
    800040a2:	79a2                	ld	s3,40(sp)
    800040a4:	7a02                	ld	s4,32(sp)
    800040a6:	6ae2                	ld	s5,24(sp)
    800040a8:	6b42                	ld	s6,16(sp)
    800040aa:	6161                	addi	sp,sp,80
    800040ac:	8082                	ret
      release(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	23c080e7          	jalr	572(ra) # 800062ec <release>
      return -1;
    800040b8:	59fd                	li	s3,-1
    800040ba:	bff9                	j	80004098 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040bc:	4981                	li	s3,0
    800040be:	b7d1                	j	80004082 <piperead+0xae>

00000000800040c0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040c0:	df010113          	addi	sp,sp,-528
    800040c4:	20113423          	sd	ra,520(sp)
    800040c8:	20813023          	sd	s0,512(sp)
    800040cc:	ffa6                	sd	s1,504(sp)
    800040ce:	fbca                	sd	s2,496(sp)
    800040d0:	f7ce                	sd	s3,488(sp)
    800040d2:	f3d2                	sd	s4,480(sp)
    800040d4:	efd6                	sd	s5,472(sp)
    800040d6:	ebda                	sd	s6,464(sp)
    800040d8:	e7de                	sd	s7,456(sp)
    800040da:	e3e2                	sd	s8,448(sp)
    800040dc:	ff66                	sd	s9,440(sp)
    800040de:	fb6a                	sd	s10,432(sp)
    800040e0:	f76e                	sd	s11,424(sp)
    800040e2:	0c00                	addi	s0,sp,528
    800040e4:	84aa                	mv	s1,a0
    800040e6:	dea43c23          	sd	a0,-520(s0)
    800040ea:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	d5a080e7          	jalr	-678(ra) # 80000e48 <myproc>
    800040f6:	892a                	mv	s2,a0

  begin_op();
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	49c080e7          	jalr	1180(ra) # 80003594 <begin_op>

  if((ip = namei(path)) == 0){
    80004100:	8526                	mv	a0,s1
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	276080e7          	jalr	630(ra) # 80003378 <namei>
    8000410a:	c92d                	beqz	a0,8000417c <exec+0xbc>
    8000410c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	ab4080e7          	jalr	-1356(ra) # 80002bc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004116:	04000713          	li	a4,64
    8000411a:	4681                	li	a3,0
    8000411c:	e5040613          	addi	a2,s0,-432
    80004120:	4581                	li	a1,0
    80004122:	8526                	mv	a0,s1
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	d52080e7          	jalr	-686(ra) # 80002e76 <readi>
    8000412c:	04000793          	li	a5,64
    80004130:	00f51a63          	bne	a0,a5,80004144 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004134:	e5042703          	lw	a4,-432(s0)
    80004138:	464c47b7          	lui	a5,0x464c4
    8000413c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004140:	04f70463          	beq	a4,a5,80004188 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004144:	8526                	mv	a0,s1
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	cde080e7          	jalr	-802(ra) # 80002e24 <iunlockput>
    end_op();
    8000414e:	fffff097          	auipc	ra,0xfffff
    80004152:	4c6080e7          	jalr	1222(ra) # 80003614 <end_op>
  }
  return -1;
    80004156:	557d                	li	a0,-1
}
    80004158:	20813083          	ld	ra,520(sp)
    8000415c:	20013403          	ld	s0,512(sp)
    80004160:	74fe                	ld	s1,504(sp)
    80004162:	795e                	ld	s2,496(sp)
    80004164:	79be                	ld	s3,488(sp)
    80004166:	7a1e                	ld	s4,480(sp)
    80004168:	6afe                	ld	s5,472(sp)
    8000416a:	6b5e                	ld	s6,464(sp)
    8000416c:	6bbe                	ld	s7,456(sp)
    8000416e:	6c1e                	ld	s8,448(sp)
    80004170:	7cfa                	ld	s9,440(sp)
    80004172:	7d5a                	ld	s10,432(sp)
    80004174:	7dba                	ld	s11,424(sp)
    80004176:	21010113          	addi	sp,sp,528
    8000417a:	8082                	ret
    end_op();
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	498080e7          	jalr	1176(ra) # 80003614 <end_op>
    return -1;
    80004184:	557d                	li	a0,-1
    80004186:	bfc9                	j	80004158 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004188:	854a                	mv	a0,s2
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	d82080e7          	jalr	-638(ra) # 80000f0c <proc_pagetable>
    80004192:	8baa                	mv	s7,a0
    80004194:	d945                	beqz	a0,80004144 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004196:	e7042983          	lw	s3,-400(s0)
    8000419a:	e8845783          	lhu	a5,-376(s0)
    8000419e:	c7ad                	beqz	a5,80004208 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041a0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a2:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041a4:	6c85                	lui	s9,0x1
    800041a6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041aa:	def43823          	sd	a5,-528(s0)
    800041ae:	a42d                	j	800043d8 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041b0:	00004517          	auipc	a0,0x4
    800041b4:	4a850513          	addi	a0,a0,1192 # 80008658 <syscalls+0x290>
    800041b8:	00002097          	auipc	ra,0x2
    800041bc:	b60080e7          	jalr	-1184(ra) # 80005d18 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041c0:	8756                	mv	a4,s5
    800041c2:	012d86bb          	addw	a3,s11,s2
    800041c6:	4581                	li	a1,0
    800041c8:	8526                	mv	a0,s1
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	cac080e7          	jalr	-852(ra) # 80002e76 <readi>
    800041d2:	2501                	sext.w	a0,a0
    800041d4:	1aaa9963          	bne	s5,a0,80004386 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041d8:	6785                	lui	a5,0x1
    800041da:	0127893b          	addw	s2,a5,s2
    800041de:	77fd                	lui	a5,0xfffff
    800041e0:	01478a3b          	addw	s4,a5,s4
    800041e4:	1f897163          	bgeu	s2,s8,800043c6 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041e8:	02091593          	slli	a1,s2,0x20
    800041ec:	9181                	srli	a1,a1,0x20
    800041ee:	95ea                	add	a1,a1,s10
    800041f0:	855e                	mv	a0,s7
    800041f2:	ffffc097          	auipc	ra,0xffffc
    800041f6:	314080e7          	jalr	788(ra) # 80000506 <walkaddr>
    800041fa:	862a                	mv	a2,a0
    if(pa == 0)
    800041fc:	d955                	beqz	a0,800041b0 <exec+0xf0>
      n = PGSIZE;
    800041fe:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004200:	fd9a70e3          	bgeu	s4,s9,800041c0 <exec+0x100>
      n = sz - i;
    80004204:	8ad2                	mv	s5,s4
    80004206:	bf6d                	j	800041c0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004208:	4901                	li	s2,0
  iunlockput(ip);
    8000420a:	8526                	mv	a0,s1
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	c18080e7          	jalr	-1000(ra) # 80002e24 <iunlockput>
  end_op();
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	400080e7          	jalr	1024(ra) # 80003614 <end_op>
  p = myproc();
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	c2c080e7          	jalr	-980(ra) # 80000e48 <myproc>
    80004224:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004226:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000422a:	6785                	lui	a5,0x1
    8000422c:	17fd                	addi	a5,a5,-1
    8000422e:	993e                	add	s2,s2,a5
    80004230:	757d                	lui	a0,0xfffff
    80004232:	00a977b3          	and	a5,s2,a0
    80004236:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000423a:	6609                	lui	a2,0x2
    8000423c:	963e                	add	a2,a2,a5
    8000423e:	85be                	mv	a1,a5
    80004240:	855e                	mv	a0,s7
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	678080e7          	jalr	1656(ra) # 800008ba <uvmalloc>
    8000424a:	8b2a                	mv	s6,a0
  ip = 0;
    8000424c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000424e:	12050c63          	beqz	a0,80004386 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004252:	75f9                	lui	a1,0xffffe
    80004254:	95aa                	add	a1,a1,a0
    80004256:	855e                	mv	a0,s7
    80004258:	ffffd097          	auipc	ra,0xffffd
    8000425c:	880080e7          	jalr	-1920(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004260:	7c7d                	lui	s8,0xfffff
    80004262:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004264:	e0043783          	ld	a5,-512(s0)
    80004268:	6388                	ld	a0,0(a5)
    8000426a:	c535                	beqz	a0,800042d6 <exec+0x216>
    8000426c:	e9040993          	addi	s3,s0,-368
    80004270:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004274:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004276:	ffffc097          	auipc	ra,0xffffc
    8000427a:	086080e7          	jalr	134(ra) # 800002fc <strlen>
    8000427e:	2505                	addiw	a0,a0,1
    80004280:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004284:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004288:	13896363          	bltu	s2,s8,800043ae <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000428c:	e0043d83          	ld	s11,-512(s0)
    80004290:	000dba03          	ld	s4,0(s11)
    80004294:	8552                	mv	a0,s4
    80004296:	ffffc097          	auipc	ra,0xffffc
    8000429a:	066080e7          	jalr	102(ra) # 800002fc <strlen>
    8000429e:	0015069b          	addiw	a3,a0,1
    800042a2:	8652                	mv	a2,s4
    800042a4:	85ca                	mv	a1,s2
    800042a6:	855e                	mv	a0,s7
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	862080e7          	jalr	-1950(ra) # 80000b0a <copyout>
    800042b0:	10054363          	bltz	a0,800043b6 <exec+0x2f6>
    ustack[argc] = sp;
    800042b4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042b8:	0485                	addi	s1,s1,1
    800042ba:	008d8793          	addi	a5,s11,8
    800042be:	e0f43023          	sd	a5,-512(s0)
    800042c2:	008db503          	ld	a0,8(s11)
    800042c6:	c911                	beqz	a0,800042da <exec+0x21a>
    if(argc >= MAXARG)
    800042c8:	09a1                	addi	s3,s3,8
    800042ca:	fb3c96e3          	bne	s9,s3,80004276 <exec+0x1b6>
  sz = sz1;
    800042ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042d2:	4481                	li	s1,0
    800042d4:	a84d                	j	80004386 <exec+0x2c6>
  sp = sz;
    800042d6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042d8:	4481                	li	s1,0
  ustack[argc] = 0;
    800042da:	00349793          	slli	a5,s1,0x3
    800042de:	f9040713          	addi	a4,s0,-112
    800042e2:	97ba                	add	a5,a5,a4
    800042e4:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042e8:	00148693          	addi	a3,s1,1
    800042ec:	068e                	slli	a3,a3,0x3
    800042ee:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042f2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042f6:	01897663          	bgeu	s2,s8,80004302 <exec+0x242>
  sz = sz1;
    800042fa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042fe:	4481                	li	s1,0
    80004300:	a059                	j	80004386 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004302:	e9040613          	addi	a2,s0,-368
    80004306:	85ca                	mv	a1,s2
    80004308:	855e                	mv	a0,s7
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	800080e7          	jalr	-2048(ra) # 80000b0a <copyout>
    80004312:	0a054663          	bltz	a0,800043be <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004316:	058ab783          	ld	a5,88(s5)
    8000431a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000431e:	df843783          	ld	a5,-520(s0)
    80004322:	0007c703          	lbu	a4,0(a5)
    80004326:	cf11                	beqz	a4,80004342 <exec+0x282>
    80004328:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000432a:	02f00693          	li	a3,47
    8000432e:	a039                	j	8000433c <exec+0x27c>
      last = s+1;
    80004330:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004334:	0785                	addi	a5,a5,1
    80004336:	fff7c703          	lbu	a4,-1(a5)
    8000433a:	c701                	beqz	a4,80004342 <exec+0x282>
    if(*s == '/')
    8000433c:	fed71ce3          	bne	a4,a3,80004334 <exec+0x274>
    80004340:	bfc5                	j	80004330 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004342:	4641                	li	a2,16
    80004344:	df843583          	ld	a1,-520(s0)
    80004348:	158a8513          	addi	a0,s5,344
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	f7e080e7          	jalr	-130(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004354:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004358:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000435c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004360:	058ab783          	ld	a5,88(s5)
    80004364:	e6843703          	ld	a4,-408(s0)
    80004368:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000436a:	058ab783          	ld	a5,88(s5)
    8000436e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004372:	85ea                	mv	a1,s10
    80004374:	ffffd097          	auipc	ra,0xffffd
    80004378:	c34080e7          	jalr	-972(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000437c:	0004851b          	sext.w	a0,s1
    80004380:	bbe1                	j	80004158 <exec+0x98>
    80004382:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004386:	e0843583          	ld	a1,-504(s0)
    8000438a:	855e                	mv	a0,s7
    8000438c:	ffffd097          	auipc	ra,0xffffd
    80004390:	c1c080e7          	jalr	-996(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004394:	da0498e3          	bnez	s1,80004144 <exec+0x84>
  return -1;
    80004398:	557d                	li	a0,-1
    8000439a:	bb7d                	j	80004158 <exec+0x98>
    8000439c:	e1243423          	sd	s2,-504(s0)
    800043a0:	b7dd                	j	80004386 <exec+0x2c6>
    800043a2:	e1243423          	sd	s2,-504(s0)
    800043a6:	b7c5                	j	80004386 <exec+0x2c6>
    800043a8:	e1243423          	sd	s2,-504(s0)
    800043ac:	bfe9                	j	80004386 <exec+0x2c6>
  sz = sz1;
    800043ae:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b2:	4481                	li	s1,0
    800043b4:	bfc9                	j	80004386 <exec+0x2c6>
  sz = sz1;
    800043b6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ba:	4481                	li	s1,0
    800043bc:	b7e9                	j	80004386 <exec+0x2c6>
  sz = sz1;
    800043be:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c2:	4481                	li	s1,0
    800043c4:	b7c9                	j	80004386 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043c6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ca:	2b05                	addiw	s6,s6,1
    800043cc:	0389899b          	addiw	s3,s3,56
    800043d0:	e8845783          	lhu	a5,-376(s0)
    800043d4:	e2fb5be3          	bge	s6,a5,8000420a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043d8:	2981                	sext.w	s3,s3
    800043da:	03800713          	li	a4,56
    800043de:	86ce                	mv	a3,s3
    800043e0:	e1840613          	addi	a2,s0,-488
    800043e4:	4581                	li	a1,0
    800043e6:	8526                	mv	a0,s1
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	a8e080e7          	jalr	-1394(ra) # 80002e76 <readi>
    800043f0:	03800793          	li	a5,56
    800043f4:	f8f517e3          	bne	a0,a5,80004382 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043f8:	e1842783          	lw	a5,-488(s0)
    800043fc:	4705                	li	a4,1
    800043fe:	fce796e3          	bne	a5,a4,800043ca <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004402:	e4043603          	ld	a2,-448(s0)
    80004406:	e3843783          	ld	a5,-456(s0)
    8000440a:	f8f669e3          	bltu	a2,a5,8000439c <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000440e:	e2843783          	ld	a5,-472(s0)
    80004412:	963e                	add	a2,a2,a5
    80004414:	f8f667e3          	bltu	a2,a5,800043a2 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004418:	85ca                	mv	a1,s2
    8000441a:	855e                	mv	a0,s7
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	49e080e7          	jalr	1182(ra) # 800008ba <uvmalloc>
    80004424:	e0a43423          	sd	a0,-504(s0)
    80004428:	d141                	beqz	a0,800043a8 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000442a:	e2843d03          	ld	s10,-472(s0)
    8000442e:	df043783          	ld	a5,-528(s0)
    80004432:	00fd77b3          	and	a5,s10,a5
    80004436:	fba1                	bnez	a5,80004386 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004438:	e2042d83          	lw	s11,-480(s0)
    8000443c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004440:	f80c03e3          	beqz	s8,800043c6 <exec+0x306>
    80004444:	8a62                	mv	s4,s8
    80004446:	4901                	li	s2,0
    80004448:	b345                	j	800041e8 <exec+0x128>

000000008000444a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000444a:	7179                	addi	sp,sp,-48
    8000444c:	f406                	sd	ra,40(sp)
    8000444e:	f022                	sd	s0,32(sp)
    80004450:	ec26                	sd	s1,24(sp)
    80004452:	e84a                	sd	s2,16(sp)
    80004454:	1800                	addi	s0,sp,48
    80004456:	892e                	mv	s2,a1
    80004458:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000445a:	fdc40593          	addi	a1,s0,-36
    8000445e:	ffffe097          	auipc	ra,0xffffe
    80004462:	b44080e7          	jalr	-1212(ra) # 80001fa2 <argint>
    80004466:	04054063          	bltz	a0,800044a6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000446a:	fdc42703          	lw	a4,-36(s0)
    8000446e:	47bd                	li	a5,15
    80004470:	02e7ed63          	bltu	a5,a4,800044aa <argfd+0x60>
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	9d4080e7          	jalr	-1580(ra) # 80000e48 <myproc>
    8000447c:	fdc42703          	lw	a4,-36(s0)
    80004480:	01a70793          	addi	a5,a4,26
    80004484:	078e                	slli	a5,a5,0x3
    80004486:	953e                	add	a0,a0,a5
    80004488:	611c                	ld	a5,0(a0)
    8000448a:	c395                	beqz	a5,800044ae <argfd+0x64>
    return -1;
  if(pfd)
    8000448c:	00090463          	beqz	s2,80004494 <argfd+0x4a>
    *pfd = fd;
    80004490:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004494:	4501                	li	a0,0
  if(pf)
    80004496:	c091                	beqz	s1,8000449a <argfd+0x50>
    *pf = f;
    80004498:	e09c                	sd	a5,0(s1)
}
    8000449a:	70a2                	ld	ra,40(sp)
    8000449c:	7402                	ld	s0,32(sp)
    8000449e:	64e2                	ld	s1,24(sp)
    800044a0:	6942                	ld	s2,16(sp)
    800044a2:	6145                	addi	sp,sp,48
    800044a4:	8082                	ret
    return -1;
    800044a6:	557d                	li	a0,-1
    800044a8:	bfcd                	j	8000449a <argfd+0x50>
    return -1;
    800044aa:	557d                	li	a0,-1
    800044ac:	b7fd                	j	8000449a <argfd+0x50>
    800044ae:	557d                	li	a0,-1
    800044b0:	b7ed                	j	8000449a <argfd+0x50>

00000000800044b2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044b2:	1101                	addi	sp,sp,-32
    800044b4:	ec06                	sd	ra,24(sp)
    800044b6:	e822                	sd	s0,16(sp)
    800044b8:	e426                	sd	s1,8(sp)
    800044ba:	1000                	addi	s0,sp,32
    800044bc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044be:	ffffd097          	auipc	ra,0xffffd
    800044c2:	98a080e7          	jalr	-1654(ra) # 80000e48 <myproc>
    800044c6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044c8:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044cc:	4501                	li	a0,0
    800044ce:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044d0:	6398                	ld	a4,0(a5)
    800044d2:	cb19                	beqz	a4,800044e8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044d4:	2505                	addiw	a0,a0,1
    800044d6:	07a1                	addi	a5,a5,8
    800044d8:	fed51ce3          	bne	a0,a3,800044d0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044dc:	557d                	li	a0,-1
}
    800044de:	60e2                	ld	ra,24(sp)
    800044e0:	6442                	ld	s0,16(sp)
    800044e2:	64a2                	ld	s1,8(sp)
    800044e4:	6105                	addi	sp,sp,32
    800044e6:	8082                	ret
      p->ofile[fd] = f;
    800044e8:	01a50793          	addi	a5,a0,26
    800044ec:	078e                	slli	a5,a5,0x3
    800044ee:	963e                	add	a2,a2,a5
    800044f0:	e204                	sd	s1,0(a2)
      return fd;
    800044f2:	b7f5                	j	800044de <fdalloc+0x2c>

00000000800044f4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044f4:	715d                	addi	sp,sp,-80
    800044f6:	e486                	sd	ra,72(sp)
    800044f8:	e0a2                	sd	s0,64(sp)
    800044fa:	fc26                	sd	s1,56(sp)
    800044fc:	f84a                	sd	s2,48(sp)
    800044fe:	f44e                	sd	s3,40(sp)
    80004500:	f052                	sd	s4,32(sp)
    80004502:	ec56                	sd	s5,24(sp)
    80004504:	0880                	addi	s0,sp,80
    80004506:	89ae                	mv	s3,a1
    80004508:	8ab2                	mv	s5,a2
    8000450a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000450c:	fb040593          	addi	a1,s0,-80
    80004510:	fffff097          	auipc	ra,0xfffff
    80004514:	e86080e7          	jalr	-378(ra) # 80003396 <nameiparent>
    80004518:	892a                	mv	s2,a0
    8000451a:	12050f63          	beqz	a0,80004658 <create+0x164>
    return 0;

  ilock(dp);
    8000451e:	ffffe097          	auipc	ra,0xffffe
    80004522:	6a4080e7          	jalr	1700(ra) # 80002bc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004526:	4601                	li	a2,0
    80004528:	fb040593          	addi	a1,s0,-80
    8000452c:	854a                	mv	a0,s2
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	b78080e7          	jalr	-1160(ra) # 800030a6 <dirlookup>
    80004536:	84aa                	mv	s1,a0
    80004538:	c921                	beqz	a0,80004588 <create+0x94>
    iunlockput(dp);
    8000453a:	854a                	mv	a0,s2
    8000453c:	fffff097          	auipc	ra,0xfffff
    80004540:	8e8080e7          	jalr	-1816(ra) # 80002e24 <iunlockput>
    ilock(ip);
    80004544:	8526                	mv	a0,s1
    80004546:	ffffe097          	auipc	ra,0xffffe
    8000454a:	67c080e7          	jalr	1660(ra) # 80002bc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000454e:	2981                	sext.w	s3,s3
    80004550:	4789                	li	a5,2
    80004552:	02f99463          	bne	s3,a5,8000457a <create+0x86>
    80004556:	0444d783          	lhu	a5,68(s1)
    8000455a:	37f9                	addiw	a5,a5,-2
    8000455c:	17c2                	slli	a5,a5,0x30
    8000455e:	93c1                	srli	a5,a5,0x30
    80004560:	4705                	li	a4,1
    80004562:	00f76c63          	bltu	a4,a5,8000457a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004566:	8526                	mv	a0,s1
    80004568:	60a6                	ld	ra,72(sp)
    8000456a:	6406                	ld	s0,64(sp)
    8000456c:	74e2                	ld	s1,56(sp)
    8000456e:	7942                	ld	s2,48(sp)
    80004570:	79a2                	ld	s3,40(sp)
    80004572:	7a02                	ld	s4,32(sp)
    80004574:	6ae2                	ld	s5,24(sp)
    80004576:	6161                	addi	sp,sp,80
    80004578:	8082                	ret
    iunlockput(ip);
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	8a8080e7          	jalr	-1880(ra) # 80002e24 <iunlockput>
    return 0;
    80004584:	4481                	li	s1,0
    80004586:	b7c5                	j	80004566 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004588:	85ce                	mv	a1,s3
    8000458a:	00092503          	lw	a0,0(s2)
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	49c080e7          	jalr	1180(ra) # 80002a2a <ialloc>
    80004596:	84aa                	mv	s1,a0
    80004598:	c529                	beqz	a0,800045e2 <create+0xee>
  ilock(ip);
    8000459a:	ffffe097          	auipc	ra,0xffffe
    8000459e:	628080e7          	jalr	1576(ra) # 80002bc2 <ilock>
  ip->major = major;
    800045a2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045a6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045aa:	4785                	li	a5,1
    800045ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045b0:	8526                	mv	a0,s1
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	546080e7          	jalr	1350(ra) # 80002af8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ba:	2981                	sext.w	s3,s3
    800045bc:	4785                	li	a5,1
    800045be:	02f98a63          	beq	s3,a5,800045f2 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045c2:	40d0                	lw	a2,4(s1)
    800045c4:	fb040593          	addi	a1,s0,-80
    800045c8:	854a                	mv	a0,s2
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	cec080e7          	jalr	-788(ra) # 800032b6 <dirlink>
    800045d2:	06054b63          	bltz	a0,80004648 <create+0x154>
  iunlockput(dp);
    800045d6:	854a                	mv	a0,s2
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	84c080e7          	jalr	-1972(ra) # 80002e24 <iunlockput>
  return ip;
    800045e0:	b759                	j	80004566 <create+0x72>
    panic("create: ialloc");
    800045e2:	00004517          	auipc	a0,0x4
    800045e6:	09650513          	addi	a0,a0,150 # 80008678 <syscalls+0x2b0>
    800045ea:	00001097          	auipc	ra,0x1
    800045ee:	72e080e7          	jalr	1838(ra) # 80005d18 <panic>
    dp->nlink++;  // for ".."
    800045f2:	04a95783          	lhu	a5,74(s2)
    800045f6:	2785                	addiw	a5,a5,1
    800045f8:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045fc:	854a                	mv	a0,s2
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	4fa080e7          	jalr	1274(ra) # 80002af8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004606:	40d0                	lw	a2,4(s1)
    80004608:	00004597          	auipc	a1,0x4
    8000460c:	08058593          	addi	a1,a1,128 # 80008688 <syscalls+0x2c0>
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	ca4080e7          	jalr	-860(ra) # 800032b6 <dirlink>
    8000461a:	00054f63          	bltz	a0,80004638 <create+0x144>
    8000461e:	00492603          	lw	a2,4(s2)
    80004622:	00004597          	auipc	a1,0x4
    80004626:	06e58593          	addi	a1,a1,110 # 80008690 <syscalls+0x2c8>
    8000462a:	8526                	mv	a0,s1
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	c8a080e7          	jalr	-886(ra) # 800032b6 <dirlink>
    80004634:	f80557e3          	bgez	a0,800045c2 <create+0xce>
      panic("create dots");
    80004638:	00004517          	auipc	a0,0x4
    8000463c:	06050513          	addi	a0,a0,96 # 80008698 <syscalls+0x2d0>
    80004640:	00001097          	auipc	ra,0x1
    80004644:	6d8080e7          	jalr	1752(ra) # 80005d18 <panic>
    panic("create: dirlink");
    80004648:	00004517          	auipc	a0,0x4
    8000464c:	06050513          	addi	a0,a0,96 # 800086a8 <syscalls+0x2e0>
    80004650:	00001097          	auipc	ra,0x1
    80004654:	6c8080e7          	jalr	1736(ra) # 80005d18 <panic>
    return 0;
    80004658:	84aa                	mv	s1,a0
    8000465a:	b731                	j	80004566 <create+0x72>

000000008000465c <sys_dup>:
{
    8000465c:	7179                	addi	sp,sp,-48
    8000465e:	f406                	sd	ra,40(sp)
    80004660:	f022                	sd	s0,32(sp)
    80004662:	ec26                	sd	s1,24(sp)
    80004664:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004666:	fd840613          	addi	a2,s0,-40
    8000466a:	4581                	li	a1,0
    8000466c:	4501                	li	a0,0
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	ddc080e7          	jalr	-548(ra) # 8000444a <argfd>
    return -1;
    80004676:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004678:	02054363          	bltz	a0,8000469e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000467c:	fd843503          	ld	a0,-40(s0)
    80004680:	00000097          	auipc	ra,0x0
    80004684:	e32080e7          	jalr	-462(ra) # 800044b2 <fdalloc>
    80004688:	84aa                	mv	s1,a0
    return -1;
    8000468a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000468c:	00054963          	bltz	a0,8000469e <sys_dup+0x42>
  filedup(f);
    80004690:	fd843503          	ld	a0,-40(s0)
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	37a080e7          	jalr	890(ra) # 80003a0e <filedup>
  return fd;
    8000469c:	87a6                	mv	a5,s1
}
    8000469e:	853e                	mv	a0,a5
    800046a0:	70a2                	ld	ra,40(sp)
    800046a2:	7402                	ld	s0,32(sp)
    800046a4:	64e2                	ld	s1,24(sp)
    800046a6:	6145                	addi	sp,sp,48
    800046a8:	8082                	ret

00000000800046aa <sys_read>:
{
    800046aa:	7179                	addi	sp,sp,-48
    800046ac:	f406                	sd	ra,40(sp)
    800046ae:	f022                	sd	s0,32(sp)
    800046b0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b2:	fe840613          	addi	a2,s0,-24
    800046b6:	4581                	li	a1,0
    800046b8:	4501                	li	a0,0
    800046ba:	00000097          	auipc	ra,0x0
    800046be:	d90080e7          	jalr	-624(ra) # 8000444a <argfd>
    return -1;
    800046c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c4:	04054163          	bltz	a0,80004706 <sys_read+0x5c>
    800046c8:	fe440593          	addi	a1,s0,-28
    800046cc:	4509                	li	a0,2
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	8d4080e7          	jalr	-1836(ra) # 80001fa2 <argint>
    return -1;
    800046d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d8:	02054763          	bltz	a0,80004706 <sys_read+0x5c>
    800046dc:	fd840593          	addi	a1,s0,-40
    800046e0:	4505                	li	a0,1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	8e2080e7          	jalr	-1822(ra) # 80001fc4 <argaddr>
    return -1;
    800046ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ec:	00054d63          	bltz	a0,80004706 <sys_read+0x5c>
  return fileread(f, p, n);
    800046f0:	fe442603          	lw	a2,-28(s0)
    800046f4:	fd843583          	ld	a1,-40(s0)
    800046f8:	fe843503          	ld	a0,-24(s0)
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	49e080e7          	jalr	1182(ra) # 80003b9a <fileread>
    80004704:	87aa                	mv	a5,a0
}
    80004706:	853e                	mv	a0,a5
    80004708:	70a2                	ld	ra,40(sp)
    8000470a:	7402                	ld	s0,32(sp)
    8000470c:	6145                	addi	sp,sp,48
    8000470e:	8082                	ret

0000000080004710 <sys_write>:
{
    80004710:	7179                	addi	sp,sp,-48
    80004712:	f406                	sd	ra,40(sp)
    80004714:	f022                	sd	s0,32(sp)
    80004716:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004718:	fe840613          	addi	a2,s0,-24
    8000471c:	4581                	li	a1,0
    8000471e:	4501                	li	a0,0
    80004720:	00000097          	auipc	ra,0x0
    80004724:	d2a080e7          	jalr	-726(ra) # 8000444a <argfd>
    return -1;
    80004728:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472a:	04054163          	bltz	a0,8000476c <sys_write+0x5c>
    8000472e:	fe440593          	addi	a1,s0,-28
    80004732:	4509                	li	a0,2
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	86e080e7          	jalr	-1938(ra) # 80001fa2 <argint>
    return -1;
    8000473c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473e:	02054763          	bltz	a0,8000476c <sys_write+0x5c>
    80004742:	fd840593          	addi	a1,s0,-40
    80004746:	4505                	li	a0,1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	87c080e7          	jalr	-1924(ra) # 80001fc4 <argaddr>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004752:	00054d63          	bltz	a0,8000476c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004756:	fe442603          	lw	a2,-28(s0)
    8000475a:	fd843583          	ld	a1,-40(s0)
    8000475e:	fe843503          	ld	a0,-24(s0)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	4fa080e7          	jalr	1274(ra) # 80003c5c <filewrite>
    8000476a:	87aa                	mv	a5,a0
}
    8000476c:	853e                	mv	a0,a5
    8000476e:	70a2                	ld	ra,40(sp)
    80004770:	7402                	ld	s0,32(sp)
    80004772:	6145                	addi	sp,sp,48
    80004774:	8082                	ret

0000000080004776 <sys_close>:
{
    80004776:	1101                	addi	sp,sp,-32
    80004778:	ec06                	sd	ra,24(sp)
    8000477a:	e822                	sd	s0,16(sp)
    8000477c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000477e:	fe040613          	addi	a2,s0,-32
    80004782:	fec40593          	addi	a1,s0,-20
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	cc2080e7          	jalr	-830(ra) # 8000444a <argfd>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004792:	02054463          	bltz	a0,800047ba <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004796:	ffffc097          	auipc	ra,0xffffc
    8000479a:	6b2080e7          	jalr	1714(ra) # 80000e48 <myproc>
    8000479e:	fec42783          	lw	a5,-20(s0)
    800047a2:	07e9                	addi	a5,a5,26
    800047a4:	078e                	slli	a5,a5,0x3
    800047a6:	97aa                	add	a5,a5,a0
    800047a8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047ac:	fe043503          	ld	a0,-32(s0)
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	2b0080e7          	jalr	688(ra) # 80003a60 <fileclose>
  return 0;
    800047b8:	4781                	li	a5,0
}
    800047ba:	853e                	mv	a0,a5
    800047bc:	60e2                	ld	ra,24(sp)
    800047be:	6442                	ld	s0,16(sp)
    800047c0:	6105                	addi	sp,sp,32
    800047c2:	8082                	ret

00000000800047c4 <sys_fstat>:
{
    800047c4:	1101                	addi	sp,sp,-32
    800047c6:	ec06                	sd	ra,24(sp)
    800047c8:	e822                	sd	s0,16(sp)
    800047ca:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047cc:	fe840613          	addi	a2,s0,-24
    800047d0:	4581                	li	a1,0
    800047d2:	4501                	li	a0,0
    800047d4:	00000097          	auipc	ra,0x0
    800047d8:	c76080e7          	jalr	-906(ra) # 8000444a <argfd>
    return -1;
    800047dc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047de:	02054563          	bltz	a0,80004808 <sys_fstat+0x44>
    800047e2:	fe040593          	addi	a1,s0,-32
    800047e6:	4505                	li	a0,1
    800047e8:	ffffd097          	auipc	ra,0xffffd
    800047ec:	7dc080e7          	jalr	2012(ra) # 80001fc4 <argaddr>
    return -1;
    800047f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f2:	00054b63          	bltz	a0,80004808 <sys_fstat+0x44>
  return filestat(f, st);
    800047f6:	fe043583          	ld	a1,-32(s0)
    800047fa:	fe843503          	ld	a0,-24(s0)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	32a080e7          	jalr	810(ra) # 80003b28 <filestat>
    80004806:	87aa                	mv	a5,a0
}
    80004808:	853e                	mv	a0,a5
    8000480a:	60e2                	ld	ra,24(sp)
    8000480c:	6442                	ld	s0,16(sp)
    8000480e:	6105                	addi	sp,sp,32
    80004810:	8082                	ret

0000000080004812 <sys_link>:
{
    80004812:	7169                	addi	sp,sp,-304
    80004814:	f606                	sd	ra,296(sp)
    80004816:	f222                	sd	s0,288(sp)
    80004818:	ee26                	sd	s1,280(sp)
    8000481a:	ea4a                	sd	s2,272(sp)
    8000481c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000481e:	08000613          	li	a2,128
    80004822:	ed040593          	addi	a1,s0,-304
    80004826:	4501                	li	a0,0
    80004828:	ffffd097          	auipc	ra,0xffffd
    8000482c:	7be080e7          	jalr	1982(ra) # 80001fe6 <argstr>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004832:	10054e63          	bltz	a0,8000494e <sys_link+0x13c>
    80004836:	08000613          	li	a2,128
    8000483a:	f5040593          	addi	a1,s0,-176
    8000483e:	4505                	li	a0,1
    80004840:	ffffd097          	auipc	ra,0xffffd
    80004844:	7a6080e7          	jalr	1958(ra) # 80001fe6 <argstr>
    return -1;
    80004848:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000484a:	10054263          	bltz	a0,8000494e <sys_link+0x13c>
  begin_op();
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	d46080e7          	jalr	-698(ra) # 80003594 <begin_op>
  if((ip = namei(old)) == 0){
    80004856:	ed040513          	addi	a0,s0,-304
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	b1e080e7          	jalr	-1250(ra) # 80003378 <namei>
    80004862:	84aa                	mv	s1,a0
    80004864:	c551                	beqz	a0,800048f0 <sys_link+0xde>
  ilock(ip);
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	35c080e7          	jalr	860(ra) # 80002bc2 <ilock>
  if(ip->type == T_DIR){
    8000486e:	04449703          	lh	a4,68(s1)
    80004872:	4785                	li	a5,1
    80004874:	08f70463          	beq	a4,a5,800048fc <sys_link+0xea>
  ip->nlink++;
    80004878:	04a4d783          	lhu	a5,74(s1)
    8000487c:	2785                	addiw	a5,a5,1
    8000487e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004882:	8526                	mv	a0,s1
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	274080e7          	jalr	628(ra) # 80002af8 <iupdate>
  iunlock(ip);
    8000488c:	8526                	mv	a0,s1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	3f6080e7          	jalr	1014(ra) # 80002c84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004896:	fd040593          	addi	a1,s0,-48
    8000489a:	f5040513          	addi	a0,s0,-176
    8000489e:	fffff097          	auipc	ra,0xfffff
    800048a2:	af8080e7          	jalr	-1288(ra) # 80003396 <nameiparent>
    800048a6:	892a                	mv	s2,a0
    800048a8:	c935                	beqz	a0,8000491c <sys_link+0x10a>
  ilock(dp);
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	318080e7          	jalr	792(ra) # 80002bc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048b2:	00092703          	lw	a4,0(s2)
    800048b6:	409c                	lw	a5,0(s1)
    800048b8:	04f71d63          	bne	a4,a5,80004912 <sys_link+0x100>
    800048bc:	40d0                	lw	a2,4(s1)
    800048be:	fd040593          	addi	a1,s0,-48
    800048c2:	854a                	mv	a0,s2
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	9f2080e7          	jalr	-1550(ra) # 800032b6 <dirlink>
    800048cc:	04054363          	bltz	a0,80004912 <sys_link+0x100>
  iunlockput(dp);
    800048d0:	854a                	mv	a0,s2
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	552080e7          	jalr	1362(ra) # 80002e24 <iunlockput>
  iput(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	4a0080e7          	jalr	1184(ra) # 80002d7c <iput>
  end_op();
    800048e4:	fffff097          	auipc	ra,0xfffff
    800048e8:	d30080e7          	jalr	-720(ra) # 80003614 <end_op>
  return 0;
    800048ec:	4781                	li	a5,0
    800048ee:	a085                	j	8000494e <sys_link+0x13c>
    end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	d24080e7          	jalr	-732(ra) # 80003614 <end_op>
    return -1;
    800048f8:	57fd                	li	a5,-1
    800048fa:	a891                	j	8000494e <sys_link+0x13c>
    iunlockput(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	526080e7          	jalr	1318(ra) # 80002e24 <iunlockput>
    end_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	d0e080e7          	jalr	-754(ra) # 80003614 <end_op>
    return -1;
    8000490e:	57fd                	li	a5,-1
    80004910:	a83d                	j	8000494e <sys_link+0x13c>
    iunlockput(dp);
    80004912:	854a                	mv	a0,s2
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	510080e7          	jalr	1296(ra) # 80002e24 <iunlockput>
  ilock(ip);
    8000491c:	8526                	mv	a0,s1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	2a4080e7          	jalr	676(ra) # 80002bc2 <ilock>
  ip->nlink--;
    80004926:	04a4d783          	lhu	a5,74(s1)
    8000492a:	37fd                	addiw	a5,a5,-1
    8000492c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	1c6080e7          	jalr	454(ra) # 80002af8 <iupdate>
  iunlockput(ip);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	4e8080e7          	jalr	1256(ra) # 80002e24 <iunlockput>
  end_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	cd0080e7          	jalr	-816(ra) # 80003614 <end_op>
  return -1;
    8000494c:	57fd                	li	a5,-1
}
    8000494e:	853e                	mv	a0,a5
    80004950:	70b2                	ld	ra,296(sp)
    80004952:	7412                	ld	s0,288(sp)
    80004954:	64f2                	ld	s1,280(sp)
    80004956:	6952                	ld	s2,272(sp)
    80004958:	6155                	addi	sp,sp,304
    8000495a:	8082                	ret

000000008000495c <sys_unlink>:
{
    8000495c:	7151                	addi	sp,sp,-240
    8000495e:	f586                	sd	ra,232(sp)
    80004960:	f1a2                	sd	s0,224(sp)
    80004962:	eda6                	sd	s1,216(sp)
    80004964:	e9ca                	sd	s2,208(sp)
    80004966:	e5ce                	sd	s3,200(sp)
    80004968:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000496a:	08000613          	li	a2,128
    8000496e:	f3040593          	addi	a1,s0,-208
    80004972:	4501                	li	a0,0
    80004974:	ffffd097          	auipc	ra,0xffffd
    80004978:	672080e7          	jalr	1650(ra) # 80001fe6 <argstr>
    8000497c:	18054163          	bltz	a0,80004afe <sys_unlink+0x1a2>
  begin_op();
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	c14080e7          	jalr	-1004(ra) # 80003594 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004988:	fb040593          	addi	a1,s0,-80
    8000498c:	f3040513          	addi	a0,s0,-208
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	a06080e7          	jalr	-1530(ra) # 80003396 <nameiparent>
    80004998:	84aa                	mv	s1,a0
    8000499a:	c979                	beqz	a0,80004a70 <sys_unlink+0x114>
  ilock(dp);
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	226080e7          	jalr	550(ra) # 80002bc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049a4:	00004597          	auipc	a1,0x4
    800049a8:	ce458593          	addi	a1,a1,-796 # 80008688 <syscalls+0x2c0>
    800049ac:	fb040513          	addi	a0,s0,-80
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	6dc080e7          	jalr	1756(ra) # 8000308c <namecmp>
    800049b8:	14050a63          	beqz	a0,80004b0c <sys_unlink+0x1b0>
    800049bc:	00004597          	auipc	a1,0x4
    800049c0:	cd458593          	addi	a1,a1,-812 # 80008690 <syscalls+0x2c8>
    800049c4:	fb040513          	addi	a0,s0,-80
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	6c4080e7          	jalr	1732(ra) # 8000308c <namecmp>
    800049d0:	12050e63          	beqz	a0,80004b0c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049d4:	f2c40613          	addi	a2,s0,-212
    800049d8:	fb040593          	addi	a1,s0,-80
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	6c8080e7          	jalr	1736(ra) # 800030a6 <dirlookup>
    800049e6:	892a                	mv	s2,a0
    800049e8:	12050263          	beqz	a0,80004b0c <sys_unlink+0x1b0>
  ilock(ip);
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	1d6080e7          	jalr	470(ra) # 80002bc2 <ilock>
  if(ip->nlink < 1)
    800049f4:	04a91783          	lh	a5,74(s2)
    800049f8:	08f05263          	blez	a5,80004a7c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049fc:	04491703          	lh	a4,68(s2)
    80004a00:	4785                	li	a5,1
    80004a02:	08f70563          	beq	a4,a5,80004a8c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a06:	4641                	li	a2,16
    80004a08:	4581                	li	a1,0
    80004a0a:	fc040513          	addi	a0,s0,-64
    80004a0e:	ffffb097          	auipc	ra,0xffffb
    80004a12:	76a080e7          	jalr	1898(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a16:	4741                	li	a4,16
    80004a18:	f2c42683          	lw	a3,-212(s0)
    80004a1c:	fc040613          	addi	a2,s0,-64
    80004a20:	4581                	li	a1,0
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	54a080e7          	jalr	1354(ra) # 80002f6e <writei>
    80004a2c:	47c1                	li	a5,16
    80004a2e:	0af51563          	bne	a0,a5,80004ad8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a32:	04491703          	lh	a4,68(s2)
    80004a36:	4785                	li	a5,1
    80004a38:	0af70863          	beq	a4,a5,80004ae8 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a3c:	8526                	mv	a0,s1
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	3e6080e7          	jalr	998(ra) # 80002e24 <iunlockput>
  ip->nlink--;
    80004a46:	04a95783          	lhu	a5,74(s2)
    80004a4a:	37fd                	addiw	a5,a5,-1
    80004a4c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a50:	854a                	mv	a0,s2
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	0a6080e7          	jalr	166(ra) # 80002af8 <iupdate>
  iunlockput(ip);
    80004a5a:	854a                	mv	a0,s2
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	3c8080e7          	jalr	968(ra) # 80002e24 <iunlockput>
  end_op();
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	bb0080e7          	jalr	-1104(ra) # 80003614 <end_op>
  return 0;
    80004a6c:	4501                	li	a0,0
    80004a6e:	a84d                	j	80004b20 <sys_unlink+0x1c4>
    end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	ba4080e7          	jalr	-1116(ra) # 80003614 <end_op>
    return -1;
    80004a78:	557d                	li	a0,-1
    80004a7a:	a05d                	j	80004b20 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a7c:	00004517          	auipc	a0,0x4
    80004a80:	c3c50513          	addi	a0,a0,-964 # 800086b8 <syscalls+0x2f0>
    80004a84:	00001097          	auipc	ra,0x1
    80004a88:	294080e7          	jalr	660(ra) # 80005d18 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a8c:	04c92703          	lw	a4,76(s2)
    80004a90:	02000793          	li	a5,32
    80004a94:	f6e7f9e3          	bgeu	a5,a4,80004a06 <sys_unlink+0xaa>
    80004a98:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a9c:	4741                	li	a4,16
    80004a9e:	86ce                	mv	a3,s3
    80004aa0:	f1840613          	addi	a2,s0,-232
    80004aa4:	4581                	li	a1,0
    80004aa6:	854a                	mv	a0,s2
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	3ce080e7          	jalr	974(ra) # 80002e76 <readi>
    80004ab0:	47c1                	li	a5,16
    80004ab2:	00f51b63          	bne	a0,a5,80004ac8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ab6:	f1845783          	lhu	a5,-232(s0)
    80004aba:	e7a1                	bnez	a5,80004b02 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004abc:	29c1                	addiw	s3,s3,16
    80004abe:	04c92783          	lw	a5,76(s2)
    80004ac2:	fcf9ede3          	bltu	s3,a5,80004a9c <sys_unlink+0x140>
    80004ac6:	b781                	j	80004a06 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ac8:	00004517          	auipc	a0,0x4
    80004acc:	c0850513          	addi	a0,a0,-1016 # 800086d0 <syscalls+0x308>
    80004ad0:	00001097          	auipc	ra,0x1
    80004ad4:	248080e7          	jalr	584(ra) # 80005d18 <panic>
    panic("unlink: writei");
    80004ad8:	00004517          	auipc	a0,0x4
    80004adc:	c1050513          	addi	a0,a0,-1008 # 800086e8 <syscalls+0x320>
    80004ae0:	00001097          	auipc	ra,0x1
    80004ae4:	238080e7          	jalr	568(ra) # 80005d18 <panic>
    dp->nlink--;
    80004ae8:	04a4d783          	lhu	a5,74(s1)
    80004aec:	37fd                	addiw	a5,a5,-1
    80004aee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	004080e7          	jalr	4(ra) # 80002af8 <iupdate>
    80004afc:	b781                	j	80004a3c <sys_unlink+0xe0>
    return -1;
    80004afe:	557d                	li	a0,-1
    80004b00:	a005                	j	80004b20 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b02:	854a                	mv	a0,s2
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	320080e7          	jalr	800(ra) # 80002e24 <iunlockput>
  iunlockput(dp);
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	316080e7          	jalr	790(ra) # 80002e24 <iunlockput>
  end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	afe080e7          	jalr	-1282(ra) # 80003614 <end_op>
  return -1;
    80004b1e:	557d                	li	a0,-1
}
    80004b20:	70ae                	ld	ra,232(sp)
    80004b22:	740e                	ld	s0,224(sp)
    80004b24:	64ee                	ld	s1,216(sp)
    80004b26:	694e                	ld	s2,208(sp)
    80004b28:	69ae                	ld	s3,200(sp)
    80004b2a:	616d                	addi	sp,sp,240
    80004b2c:	8082                	ret

0000000080004b2e <sys_open>:

uint64
sys_open(void)
{
    80004b2e:	7131                	addi	sp,sp,-192
    80004b30:	fd06                	sd	ra,184(sp)
    80004b32:	f922                	sd	s0,176(sp)
    80004b34:	f526                	sd	s1,168(sp)
    80004b36:	f14a                	sd	s2,160(sp)
    80004b38:	ed4e                	sd	s3,152(sp)
    80004b3a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b3c:	08000613          	li	a2,128
    80004b40:	f5040593          	addi	a1,s0,-176
    80004b44:	4501                	li	a0,0
    80004b46:	ffffd097          	auipc	ra,0xffffd
    80004b4a:	4a0080e7          	jalr	1184(ra) # 80001fe6 <argstr>
    return -1;
    80004b4e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b50:	0c054163          	bltz	a0,80004c12 <sys_open+0xe4>
    80004b54:	f4c40593          	addi	a1,s0,-180
    80004b58:	4505                	li	a0,1
    80004b5a:	ffffd097          	auipc	ra,0xffffd
    80004b5e:	448080e7          	jalr	1096(ra) # 80001fa2 <argint>
    80004b62:	0a054863          	bltz	a0,80004c12 <sys_open+0xe4>

  begin_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	a2e080e7          	jalr	-1490(ra) # 80003594 <begin_op>

  if(omode & O_CREATE){
    80004b6e:	f4c42783          	lw	a5,-180(s0)
    80004b72:	2007f793          	andi	a5,a5,512
    80004b76:	cbdd                	beqz	a5,80004c2c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b78:	4681                	li	a3,0
    80004b7a:	4601                	li	a2,0
    80004b7c:	4589                	li	a1,2
    80004b7e:	f5040513          	addi	a0,s0,-176
    80004b82:	00000097          	auipc	ra,0x0
    80004b86:	972080e7          	jalr	-1678(ra) # 800044f4 <create>
    80004b8a:	892a                	mv	s2,a0
    if(ip == 0){
    80004b8c:	c959                	beqz	a0,80004c22 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b8e:	04491703          	lh	a4,68(s2)
    80004b92:	478d                	li	a5,3
    80004b94:	00f71763          	bne	a4,a5,80004ba2 <sys_open+0x74>
    80004b98:	04695703          	lhu	a4,70(s2)
    80004b9c:	47a5                	li	a5,9
    80004b9e:	0ce7ec63          	bltu	a5,a4,80004c76 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	e02080e7          	jalr	-510(ra) # 800039a4 <filealloc>
    80004baa:	89aa                	mv	s3,a0
    80004bac:	10050263          	beqz	a0,80004cb0 <sys_open+0x182>
    80004bb0:	00000097          	auipc	ra,0x0
    80004bb4:	902080e7          	jalr	-1790(ra) # 800044b2 <fdalloc>
    80004bb8:	84aa                	mv	s1,a0
    80004bba:	0e054663          	bltz	a0,80004ca6 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bbe:	04491703          	lh	a4,68(s2)
    80004bc2:	478d                	li	a5,3
    80004bc4:	0cf70463          	beq	a4,a5,80004c8c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bc8:	4789                	li	a5,2
    80004bca:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bce:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bd2:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bd6:	f4c42783          	lw	a5,-180(s0)
    80004bda:	0017c713          	xori	a4,a5,1
    80004bde:	8b05                	andi	a4,a4,1
    80004be0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004be4:	0037f713          	andi	a4,a5,3
    80004be8:	00e03733          	snez	a4,a4
    80004bec:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bf0:	4007f793          	andi	a5,a5,1024
    80004bf4:	c791                	beqz	a5,80004c00 <sys_open+0xd2>
    80004bf6:	04491703          	lh	a4,68(s2)
    80004bfa:	4789                	li	a5,2
    80004bfc:	08f70f63          	beq	a4,a5,80004c9a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c00:	854a                	mv	a0,s2
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	082080e7          	jalr	130(ra) # 80002c84 <iunlock>
  end_op();
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	a0a080e7          	jalr	-1526(ra) # 80003614 <end_op>

  return fd;
}
    80004c12:	8526                	mv	a0,s1
    80004c14:	70ea                	ld	ra,184(sp)
    80004c16:	744a                	ld	s0,176(sp)
    80004c18:	74aa                	ld	s1,168(sp)
    80004c1a:	790a                	ld	s2,160(sp)
    80004c1c:	69ea                	ld	s3,152(sp)
    80004c1e:	6129                	addi	sp,sp,192
    80004c20:	8082                	ret
      end_op();
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	9f2080e7          	jalr	-1550(ra) # 80003614 <end_op>
      return -1;
    80004c2a:	b7e5                	j	80004c12 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c2c:	f5040513          	addi	a0,s0,-176
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	748080e7          	jalr	1864(ra) # 80003378 <namei>
    80004c38:	892a                	mv	s2,a0
    80004c3a:	c905                	beqz	a0,80004c6a <sys_open+0x13c>
    ilock(ip);
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	f86080e7          	jalr	-122(ra) # 80002bc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c44:	04491703          	lh	a4,68(s2)
    80004c48:	4785                	li	a5,1
    80004c4a:	f4f712e3          	bne	a4,a5,80004b8e <sys_open+0x60>
    80004c4e:	f4c42783          	lw	a5,-180(s0)
    80004c52:	dba1                	beqz	a5,80004ba2 <sys_open+0x74>
      iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	1ce080e7          	jalr	462(ra) # 80002e24 <iunlockput>
      end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	9b6080e7          	jalr	-1610(ra) # 80003614 <end_op>
      return -1;
    80004c66:	54fd                	li	s1,-1
    80004c68:	b76d                	j	80004c12 <sys_open+0xe4>
      end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	9aa080e7          	jalr	-1622(ra) # 80003614 <end_op>
      return -1;
    80004c72:	54fd                	li	s1,-1
    80004c74:	bf79                	j	80004c12 <sys_open+0xe4>
    iunlockput(ip);
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	1ac080e7          	jalr	428(ra) # 80002e24 <iunlockput>
    end_op();
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	994080e7          	jalr	-1644(ra) # 80003614 <end_op>
    return -1;
    80004c88:	54fd                	li	s1,-1
    80004c8a:	b761                	j	80004c12 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c8c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c90:	04691783          	lh	a5,70(s2)
    80004c94:	02f99223          	sh	a5,36(s3)
    80004c98:	bf2d                	j	80004bd2 <sys_open+0xa4>
    itrunc(ip);
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	034080e7          	jalr	52(ra) # 80002cd0 <itrunc>
    80004ca4:	bfb1                	j	80004c00 <sys_open+0xd2>
      fileclose(f);
    80004ca6:	854e                	mv	a0,s3
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	db8080e7          	jalr	-584(ra) # 80003a60 <fileclose>
    iunlockput(ip);
    80004cb0:	854a                	mv	a0,s2
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	172080e7          	jalr	370(ra) # 80002e24 <iunlockput>
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	95a080e7          	jalr	-1702(ra) # 80003614 <end_op>
    return -1;
    80004cc2:	54fd                	li	s1,-1
    80004cc4:	b7b9                	j	80004c12 <sys_open+0xe4>

0000000080004cc6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cc6:	7175                	addi	sp,sp,-144
    80004cc8:	e506                	sd	ra,136(sp)
    80004cca:	e122                	sd	s0,128(sp)
    80004ccc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	8c6080e7          	jalr	-1850(ra) # 80003594 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cd6:	08000613          	li	a2,128
    80004cda:	f7040593          	addi	a1,s0,-144
    80004cde:	4501                	li	a0,0
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	306080e7          	jalr	774(ra) # 80001fe6 <argstr>
    80004ce8:	02054963          	bltz	a0,80004d1a <sys_mkdir+0x54>
    80004cec:	4681                	li	a3,0
    80004cee:	4601                	li	a2,0
    80004cf0:	4585                	li	a1,1
    80004cf2:	f7040513          	addi	a0,s0,-144
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	7fe080e7          	jalr	2046(ra) # 800044f4 <create>
    80004cfe:	cd11                	beqz	a0,80004d1a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	124080e7          	jalr	292(ra) # 80002e24 <iunlockput>
  end_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	90c080e7          	jalr	-1780(ra) # 80003614 <end_op>
  return 0;
    80004d10:	4501                	li	a0,0
}
    80004d12:	60aa                	ld	ra,136(sp)
    80004d14:	640a                	ld	s0,128(sp)
    80004d16:	6149                	addi	sp,sp,144
    80004d18:	8082                	ret
    end_op();
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	8fa080e7          	jalr	-1798(ra) # 80003614 <end_op>
    return -1;
    80004d22:	557d                	li	a0,-1
    80004d24:	b7fd                	j	80004d12 <sys_mkdir+0x4c>

0000000080004d26 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d26:	7135                	addi	sp,sp,-160
    80004d28:	ed06                	sd	ra,152(sp)
    80004d2a:	e922                	sd	s0,144(sp)
    80004d2c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	866080e7          	jalr	-1946(ra) # 80003594 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d36:	08000613          	li	a2,128
    80004d3a:	f7040593          	addi	a1,s0,-144
    80004d3e:	4501                	li	a0,0
    80004d40:	ffffd097          	auipc	ra,0xffffd
    80004d44:	2a6080e7          	jalr	678(ra) # 80001fe6 <argstr>
    80004d48:	04054a63          	bltz	a0,80004d9c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d4c:	f6c40593          	addi	a1,s0,-148
    80004d50:	4505                	li	a0,1
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	250080e7          	jalr	592(ra) # 80001fa2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d5a:	04054163          	bltz	a0,80004d9c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d5e:	f6840593          	addi	a1,s0,-152
    80004d62:	4509                	li	a0,2
    80004d64:	ffffd097          	auipc	ra,0xffffd
    80004d68:	23e080e7          	jalr	574(ra) # 80001fa2 <argint>
     argint(1, &major) < 0 ||
    80004d6c:	02054863          	bltz	a0,80004d9c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d70:	f6841683          	lh	a3,-152(s0)
    80004d74:	f6c41603          	lh	a2,-148(s0)
    80004d78:	458d                	li	a1,3
    80004d7a:	f7040513          	addi	a0,s0,-144
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	776080e7          	jalr	1910(ra) # 800044f4 <create>
     argint(2, &minor) < 0 ||
    80004d86:	c919                	beqz	a0,80004d9c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	09c080e7          	jalr	156(ra) # 80002e24 <iunlockput>
  end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	884080e7          	jalr	-1916(ra) # 80003614 <end_op>
  return 0;
    80004d98:	4501                	li	a0,0
    80004d9a:	a031                	j	80004da6 <sys_mknod+0x80>
    end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	878080e7          	jalr	-1928(ra) # 80003614 <end_op>
    return -1;
    80004da4:	557d                	li	a0,-1
}
    80004da6:	60ea                	ld	ra,152(sp)
    80004da8:	644a                	ld	s0,144(sp)
    80004daa:	610d                	addi	sp,sp,160
    80004dac:	8082                	ret

0000000080004dae <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dae:	7135                	addi	sp,sp,-160
    80004db0:	ed06                	sd	ra,152(sp)
    80004db2:	e922                	sd	s0,144(sp)
    80004db4:	e526                	sd	s1,136(sp)
    80004db6:	e14a                	sd	s2,128(sp)
    80004db8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dba:	ffffc097          	auipc	ra,0xffffc
    80004dbe:	08e080e7          	jalr	142(ra) # 80000e48 <myproc>
    80004dc2:	892a                	mv	s2,a0
  
  begin_op();
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	7d0080e7          	jalr	2000(ra) # 80003594 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dcc:	08000613          	li	a2,128
    80004dd0:	f6040593          	addi	a1,s0,-160
    80004dd4:	4501                	li	a0,0
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	210080e7          	jalr	528(ra) # 80001fe6 <argstr>
    80004dde:	04054b63          	bltz	a0,80004e34 <sys_chdir+0x86>
    80004de2:	f6040513          	addi	a0,s0,-160
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	592080e7          	jalr	1426(ra) # 80003378 <namei>
    80004dee:	84aa                	mv	s1,a0
    80004df0:	c131                	beqz	a0,80004e34 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	dd0080e7          	jalr	-560(ra) # 80002bc2 <ilock>
  if(ip->type != T_DIR){
    80004dfa:	04449703          	lh	a4,68(s1)
    80004dfe:	4785                	li	a5,1
    80004e00:	04f71063          	bne	a4,a5,80004e40 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	e7e080e7          	jalr	-386(ra) # 80002c84 <iunlock>
  iput(p->cwd);
    80004e0e:	15093503          	ld	a0,336(s2)
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	f6a080e7          	jalr	-150(ra) # 80002d7c <iput>
  end_op();
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	7fa080e7          	jalr	2042(ra) # 80003614 <end_op>
  p->cwd = ip;
    80004e22:	14993823          	sd	s1,336(s2)
  return 0;
    80004e26:	4501                	li	a0,0
}
    80004e28:	60ea                	ld	ra,152(sp)
    80004e2a:	644a                	ld	s0,144(sp)
    80004e2c:	64aa                	ld	s1,136(sp)
    80004e2e:	690a                	ld	s2,128(sp)
    80004e30:	610d                	addi	sp,sp,160
    80004e32:	8082                	ret
    end_op();
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	7e0080e7          	jalr	2016(ra) # 80003614 <end_op>
    return -1;
    80004e3c:	557d                	li	a0,-1
    80004e3e:	b7ed                	j	80004e28 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e40:	8526                	mv	a0,s1
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	fe2080e7          	jalr	-30(ra) # 80002e24 <iunlockput>
    end_op();
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	7ca080e7          	jalr	1994(ra) # 80003614 <end_op>
    return -1;
    80004e52:	557d                	li	a0,-1
    80004e54:	bfd1                	j	80004e28 <sys_chdir+0x7a>

0000000080004e56 <sys_exec>:

uint64
sys_exec(void)
{
    80004e56:	7145                	addi	sp,sp,-464
    80004e58:	e786                	sd	ra,456(sp)
    80004e5a:	e3a2                	sd	s0,448(sp)
    80004e5c:	ff26                	sd	s1,440(sp)
    80004e5e:	fb4a                	sd	s2,432(sp)
    80004e60:	f74e                	sd	s3,424(sp)
    80004e62:	f352                	sd	s4,416(sp)
    80004e64:	ef56                	sd	s5,408(sp)
    80004e66:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e68:	08000613          	li	a2,128
    80004e6c:	f4040593          	addi	a1,s0,-192
    80004e70:	4501                	li	a0,0
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	174080e7          	jalr	372(ra) # 80001fe6 <argstr>
    return -1;
    80004e7a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e7c:	0c054a63          	bltz	a0,80004f50 <sys_exec+0xfa>
    80004e80:	e3840593          	addi	a1,s0,-456
    80004e84:	4505                	li	a0,1
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	13e080e7          	jalr	318(ra) # 80001fc4 <argaddr>
    80004e8e:	0c054163          	bltz	a0,80004f50 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e92:	10000613          	li	a2,256
    80004e96:	4581                	li	a1,0
    80004e98:	e4040513          	addi	a0,s0,-448
    80004e9c:	ffffb097          	auipc	ra,0xffffb
    80004ea0:	2dc080e7          	jalr	732(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ea4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ea8:	89a6                	mv	s3,s1
    80004eaa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eac:	02000a13          	li	s4,32
    80004eb0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eb4:	00391513          	slli	a0,s2,0x3
    80004eb8:	e3040593          	addi	a1,s0,-464
    80004ebc:	e3843783          	ld	a5,-456(s0)
    80004ec0:	953e                	add	a0,a0,a5
    80004ec2:	ffffd097          	auipc	ra,0xffffd
    80004ec6:	046080e7          	jalr	70(ra) # 80001f08 <fetchaddr>
    80004eca:	02054a63          	bltz	a0,80004efe <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ece:	e3043783          	ld	a5,-464(s0)
    80004ed2:	c3b9                	beqz	a5,80004f18 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ed4:	ffffb097          	auipc	ra,0xffffb
    80004ed8:	244080e7          	jalr	580(ra) # 80000118 <kalloc>
    80004edc:	85aa                	mv	a1,a0
    80004ede:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ee2:	cd11                	beqz	a0,80004efe <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ee4:	6605                	lui	a2,0x1
    80004ee6:	e3043503          	ld	a0,-464(s0)
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	070080e7          	jalr	112(ra) # 80001f5a <fetchstr>
    80004ef2:	00054663          	bltz	a0,80004efe <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ef6:	0905                	addi	s2,s2,1
    80004ef8:	09a1                	addi	s3,s3,8
    80004efa:	fb491be3          	bne	s2,s4,80004eb0 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004efe:	10048913          	addi	s2,s1,256
    80004f02:	6088                	ld	a0,0(s1)
    80004f04:	c529                	beqz	a0,80004f4e <sys_exec+0xf8>
    kfree(argv[i]);
    80004f06:	ffffb097          	auipc	ra,0xffffb
    80004f0a:	116080e7          	jalr	278(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f0e:	04a1                	addi	s1,s1,8
    80004f10:	ff2499e3          	bne	s1,s2,80004f02 <sys_exec+0xac>
  return -1;
    80004f14:	597d                	li	s2,-1
    80004f16:	a82d                	j	80004f50 <sys_exec+0xfa>
      argv[i] = 0;
    80004f18:	0a8e                	slli	s5,s5,0x3
    80004f1a:	fc040793          	addi	a5,s0,-64
    80004f1e:	9abe                	add	s5,s5,a5
    80004f20:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f24:	e4040593          	addi	a1,s0,-448
    80004f28:	f4040513          	addi	a0,s0,-192
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	194080e7          	jalr	404(ra) # 800040c0 <exec>
    80004f34:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f36:	10048993          	addi	s3,s1,256
    80004f3a:	6088                	ld	a0,0(s1)
    80004f3c:	c911                	beqz	a0,80004f50 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f3e:	ffffb097          	auipc	ra,0xffffb
    80004f42:	0de080e7          	jalr	222(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f46:	04a1                	addi	s1,s1,8
    80004f48:	ff3499e3          	bne	s1,s3,80004f3a <sys_exec+0xe4>
    80004f4c:	a011                	j	80004f50 <sys_exec+0xfa>
  return -1;
    80004f4e:	597d                	li	s2,-1
}
    80004f50:	854a                	mv	a0,s2
    80004f52:	60be                	ld	ra,456(sp)
    80004f54:	641e                	ld	s0,448(sp)
    80004f56:	74fa                	ld	s1,440(sp)
    80004f58:	795a                	ld	s2,432(sp)
    80004f5a:	79ba                	ld	s3,424(sp)
    80004f5c:	7a1a                	ld	s4,416(sp)
    80004f5e:	6afa                	ld	s5,408(sp)
    80004f60:	6179                	addi	sp,sp,464
    80004f62:	8082                	ret

0000000080004f64 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f64:	7139                	addi	sp,sp,-64
    80004f66:	fc06                	sd	ra,56(sp)
    80004f68:	f822                	sd	s0,48(sp)
    80004f6a:	f426                	sd	s1,40(sp)
    80004f6c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	eda080e7          	jalr	-294(ra) # 80000e48 <myproc>
    80004f76:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f78:	fd840593          	addi	a1,s0,-40
    80004f7c:	4501                	li	a0,0
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	046080e7          	jalr	70(ra) # 80001fc4 <argaddr>
    return -1;
    80004f86:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f88:	0e054063          	bltz	a0,80005068 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f8c:	fc840593          	addi	a1,s0,-56
    80004f90:	fd040513          	addi	a0,s0,-48
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	dfc080e7          	jalr	-516(ra) # 80003d90 <pipealloc>
    return -1;
    80004f9c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f9e:	0c054563          	bltz	a0,80005068 <sys_pipe+0x104>
  fd0 = -1;
    80004fa2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fa6:	fd043503          	ld	a0,-48(s0)
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	508080e7          	jalr	1288(ra) # 800044b2 <fdalloc>
    80004fb2:	fca42223          	sw	a0,-60(s0)
    80004fb6:	08054c63          	bltz	a0,8000504e <sys_pipe+0xea>
    80004fba:	fc843503          	ld	a0,-56(s0)
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	4f4080e7          	jalr	1268(ra) # 800044b2 <fdalloc>
    80004fc6:	fca42023          	sw	a0,-64(s0)
    80004fca:	06054863          	bltz	a0,8000503a <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fce:	4691                	li	a3,4
    80004fd0:	fc440613          	addi	a2,s0,-60
    80004fd4:	fd843583          	ld	a1,-40(s0)
    80004fd8:	68a8                	ld	a0,80(s1)
    80004fda:	ffffc097          	auipc	ra,0xffffc
    80004fde:	b30080e7          	jalr	-1232(ra) # 80000b0a <copyout>
    80004fe2:	02054063          	bltz	a0,80005002 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fe6:	4691                	li	a3,4
    80004fe8:	fc040613          	addi	a2,s0,-64
    80004fec:	fd843583          	ld	a1,-40(s0)
    80004ff0:	0591                	addi	a1,a1,4
    80004ff2:	68a8                	ld	a0,80(s1)
    80004ff4:	ffffc097          	auipc	ra,0xffffc
    80004ff8:	b16080e7          	jalr	-1258(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ffc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ffe:	06055563          	bgez	a0,80005068 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005002:	fc442783          	lw	a5,-60(s0)
    80005006:	07e9                	addi	a5,a5,26
    80005008:	078e                	slli	a5,a5,0x3
    8000500a:	97a6                	add	a5,a5,s1
    8000500c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005010:	fc042503          	lw	a0,-64(s0)
    80005014:	0569                	addi	a0,a0,26
    80005016:	050e                	slli	a0,a0,0x3
    80005018:	9526                	add	a0,a0,s1
    8000501a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000501e:	fd043503          	ld	a0,-48(s0)
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	a3e080e7          	jalr	-1474(ra) # 80003a60 <fileclose>
    fileclose(wf);
    8000502a:	fc843503          	ld	a0,-56(s0)
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	a32080e7          	jalr	-1486(ra) # 80003a60 <fileclose>
    return -1;
    80005036:	57fd                	li	a5,-1
    80005038:	a805                	j	80005068 <sys_pipe+0x104>
    if(fd0 >= 0)
    8000503a:	fc442783          	lw	a5,-60(s0)
    8000503e:	0007c863          	bltz	a5,8000504e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005042:	01a78513          	addi	a0,a5,26
    80005046:	050e                	slli	a0,a0,0x3
    80005048:	9526                	add	a0,a0,s1
    8000504a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000504e:	fd043503          	ld	a0,-48(s0)
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	a0e080e7          	jalr	-1522(ra) # 80003a60 <fileclose>
    fileclose(wf);
    8000505a:	fc843503          	ld	a0,-56(s0)
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	a02080e7          	jalr	-1534(ra) # 80003a60 <fileclose>
    return -1;
    80005066:	57fd                	li	a5,-1
}
    80005068:	853e                	mv	a0,a5
    8000506a:	70e2                	ld	ra,56(sp)
    8000506c:	7442                	ld	s0,48(sp)
    8000506e:	74a2                	ld	s1,40(sp)
    80005070:	6121                	addi	sp,sp,64
    80005072:	8082                	ret
	...

0000000080005080 <kernelvec>:
    80005080:	7111                	addi	sp,sp,-256
    80005082:	e006                	sd	ra,0(sp)
    80005084:	e40a                	sd	sp,8(sp)
    80005086:	e80e                	sd	gp,16(sp)
    80005088:	ec12                	sd	tp,24(sp)
    8000508a:	f016                	sd	t0,32(sp)
    8000508c:	f41a                	sd	t1,40(sp)
    8000508e:	f81e                	sd	t2,48(sp)
    80005090:	fc22                	sd	s0,56(sp)
    80005092:	e0a6                	sd	s1,64(sp)
    80005094:	e4aa                	sd	a0,72(sp)
    80005096:	e8ae                	sd	a1,80(sp)
    80005098:	ecb2                	sd	a2,88(sp)
    8000509a:	f0b6                	sd	a3,96(sp)
    8000509c:	f4ba                	sd	a4,104(sp)
    8000509e:	f8be                	sd	a5,112(sp)
    800050a0:	fcc2                	sd	a6,120(sp)
    800050a2:	e146                	sd	a7,128(sp)
    800050a4:	e54a                	sd	s2,136(sp)
    800050a6:	e94e                	sd	s3,144(sp)
    800050a8:	ed52                	sd	s4,152(sp)
    800050aa:	f156                	sd	s5,160(sp)
    800050ac:	f55a                	sd	s6,168(sp)
    800050ae:	f95e                	sd	s7,176(sp)
    800050b0:	fd62                	sd	s8,184(sp)
    800050b2:	e1e6                	sd	s9,192(sp)
    800050b4:	e5ea                	sd	s10,200(sp)
    800050b6:	e9ee                	sd	s11,208(sp)
    800050b8:	edf2                	sd	t3,216(sp)
    800050ba:	f1f6                	sd	t4,224(sp)
    800050bc:	f5fa                	sd	t5,232(sp)
    800050be:	f9fe                	sd	t6,240(sp)
    800050c0:	d15fc0ef          	jal	ra,80001dd4 <kerneltrap>
    800050c4:	6082                	ld	ra,0(sp)
    800050c6:	6122                	ld	sp,8(sp)
    800050c8:	61c2                	ld	gp,16(sp)
    800050ca:	7282                	ld	t0,32(sp)
    800050cc:	7322                	ld	t1,40(sp)
    800050ce:	73c2                	ld	t2,48(sp)
    800050d0:	7462                	ld	s0,56(sp)
    800050d2:	6486                	ld	s1,64(sp)
    800050d4:	6526                	ld	a0,72(sp)
    800050d6:	65c6                	ld	a1,80(sp)
    800050d8:	6666                	ld	a2,88(sp)
    800050da:	7686                	ld	a3,96(sp)
    800050dc:	7726                	ld	a4,104(sp)
    800050de:	77c6                	ld	a5,112(sp)
    800050e0:	7866                	ld	a6,120(sp)
    800050e2:	688a                	ld	a7,128(sp)
    800050e4:	692a                	ld	s2,136(sp)
    800050e6:	69ca                	ld	s3,144(sp)
    800050e8:	6a6a                	ld	s4,152(sp)
    800050ea:	7a8a                	ld	s5,160(sp)
    800050ec:	7b2a                	ld	s6,168(sp)
    800050ee:	7bca                	ld	s7,176(sp)
    800050f0:	7c6a                	ld	s8,184(sp)
    800050f2:	6c8e                	ld	s9,192(sp)
    800050f4:	6d2e                	ld	s10,200(sp)
    800050f6:	6dce                	ld	s11,208(sp)
    800050f8:	6e6e                	ld	t3,216(sp)
    800050fa:	7e8e                	ld	t4,224(sp)
    800050fc:	7f2e                	ld	t5,232(sp)
    800050fe:	7fce                	ld	t6,240(sp)
    80005100:	6111                	addi	sp,sp,256
    80005102:	10200073          	sret
    80005106:	00000013          	nop
    8000510a:	00000013          	nop
    8000510e:	0001                	nop

0000000080005110 <timervec>:
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	e10c                	sd	a1,0(a0)
    80005116:	e510                	sd	a2,8(a0)
    80005118:	e914                	sd	a3,16(a0)
    8000511a:	6d0c                	ld	a1,24(a0)
    8000511c:	7110                	ld	a2,32(a0)
    8000511e:	6194                	ld	a3,0(a1)
    80005120:	96b2                	add	a3,a3,a2
    80005122:	e194                	sd	a3,0(a1)
    80005124:	4589                	li	a1,2
    80005126:	14459073          	csrw	sip,a1
    8000512a:	6914                	ld	a3,16(a0)
    8000512c:	6510                	ld	a2,8(a0)
    8000512e:	610c                	ld	a1,0(a0)
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	30200073          	mret
	...

000000008000513a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000513a:	1141                	addi	sp,sp,-16
    8000513c:	e422                	sd	s0,8(sp)
    8000513e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005140:	0c0007b7          	lui	a5,0xc000
    80005144:	4705                	li	a4,1
    80005146:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005148:	c3d8                	sw	a4,4(a5)
}
    8000514a:	6422                	ld	s0,8(sp)
    8000514c:	0141                	addi	sp,sp,16
    8000514e:	8082                	ret

0000000080005150 <plicinithart>:

void
plicinithart(void)
{
    80005150:	1141                	addi	sp,sp,-16
    80005152:	e406                	sd	ra,8(sp)
    80005154:	e022                	sd	s0,0(sp)
    80005156:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	cc4080e7          	jalr	-828(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005160:	0085171b          	slliw	a4,a0,0x8
    80005164:	0c0027b7          	lui	a5,0xc002
    80005168:	97ba                	add	a5,a5,a4
    8000516a:	40200713          	li	a4,1026
    8000516e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005172:	00d5151b          	slliw	a0,a0,0xd
    80005176:	0c2017b7          	lui	a5,0xc201
    8000517a:	953e                	add	a0,a0,a5
    8000517c:	00052023          	sw	zero,0(a0)
}
    80005180:	60a2                	ld	ra,8(sp)
    80005182:	6402                	ld	s0,0(sp)
    80005184:	0141                	addi	sp,sp,16
    80005186:	8082                	ret

0000000080005188 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005188:	1141                	addi	sp,sp,-16
    8000518a:	e406                	sd	ra,8(sp)
    8000518c:	e022                	sd	s0,0(sp)
    8000518e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005190:	ffffc097          	auipc	ra,0xffffc
    80005194:	c8c080e7          	jalr	-884(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005198:	00d5179b          	slliw	a5,a0,0xd
    8000519c:	0c201537          	lui	a0,0xc201
    800051a0:	953e                	add	a0,a0,a5
  return irq;
}
    800051a2:	4148                	lw	a0,4(a0)
    800051a4:	60a2                	ld	ra,8(sp)
    800051a6:	6402                	ld	s0,0(sp)
    800051a8:	0141                	addi	sp,sp,16
    800051aa:	8082                	ret

00000000800051ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ac:	1101                	addi	sp,sp,-32
    800051ae:	ec06                	sd	ra,24(sp)
    800051b0:	e822                	sd	s0,16(sp)
    800051b2:	e426                	sd	s1,8(sp)
    800051b4:	1000                	addi	s0,sp,32
    800051b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	c64080e7          	jalr	-924(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051c0:	00d5151b          	slliw	a0,a0,0xd
    800051c4:	0c2017b7          	lui	a5,0xc201
    800051c8:	97aa                	add	a5,a5,a0
    800051ca:	c3c4                	sw	s1,4(a5)
}
    800051cc:	60e2                	ld	ra,24(sp)
    800051ce:	6442                	ld	s0,16(sp)
    800051d0:	64a2                	ld	s1,8(sp)
    800051d2:	6105                	addi	sp,sp,32
    800051d4:	8082                	ret

00000000800051d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051d6:	1141                	addi	sp,sp,-16
    800051d8:	e406                	sd	ra,8(sp)
    800051da:	e022                	sd	s0,0(sp)
    800051dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051de:	479d                	li	a5,7
    800051e0:	06a7c963          	blt	a5,a0,80005252 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051e4:	00016797          	auipc	a5,0x16
    800051e8:	e1c78793          	addi	a5,a5,-484 # 8001b000 <disk>
    800051ec:	00a78733          	add	a4,a5,a0
    800051f0:	6789                	lui	a5,0x2
    800051f2:	97ba                	add	a5,a5,a4
    800051f4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051f8:	e7ad                	bnez	a5,80005262 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051fa:	00451793          	slli	a5,a0,0x4
    800051fe:	00018717          	auipc	a4,0x18
    80005202:	e0270713          	addi	a4,a4,-510 # 8001d000 <disk+0x2000>
    80005206:	6314                	ld	a3,0(a4)
    80005208:	96be                	add	a3,a3,a5
    8000520a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000520e:	6314                	ld	a3,0(a4)
    80005210:	96be                	add	a3,a3,a5
    80005212:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005216:	6314                	ld	a3,0(a4)
    80005218:	96be                	add	a3,a3,a5
    8000521a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000521e:	6318                	ld	a4,0(a4)
    80005220:	97ba                	add	a5,a5,a4
    80005222:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005226:	00016797          	auipc	a5,0x16
    8000522a:	dda78793          	addi	a5,a5,-550 # 8001b000 <disk>
    8000522e:	97aa                	add	a5,a5,a0
    80005230:	6509                	lui	a0,0x2
    80005232:	953e                	add	a0,a0,a5
    80005234:	4785                	li	a5,1
    80005236:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000523a:	00018517          	auipc	a0,0x18
    8000523e:	dde50513          	addi	a0,a0,-546 # 8001d018 <disk+0x2018>
    80005242:	ffffc097          	auipc	ra,0xffffc
    80005246:	49e080e7          	jalr	1182(ra) # 800016e0 <wakeup>
}
    8000524a:	60a2                	ld	ra,8(sp)
    8000524c:	6402                	ld	s0,0(sp)
    8000524e:	0141                	addi	sp,sp,16
    80005250:	8082                	ret
    panic("free_desc 1");
    80005252:	00003517          	auipc	a0,0x3
    80005256:	4a650513          	addi	a0,a0,1190 # 800086f8 <syscalls+0x330>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	abe080e7          	jalr	-1346(ra) # 80005d18 <panic>
    panic("free_desc 2");
    80005262:	00003517          	auipc	a0,0x3
    80005266:	4a650513          	addi	a0,a0,1190 # 80008708 <syscalls+0x340>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	aae080e7          	jalr	-1362(ra) # 80005d18 <panic>

0000000080005272 <virtio_disk_init>:
{
    80005272:	1101                	addi	sp,sp,-32
    80005274:	ec06                	sd	ra,24(sp)
    80005276:	e822                	sd	s0,16(sp)
    80005278:	e426                	sd	s1,8(sp)
    8000527a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000527c:	00003597          	auipc	a1,0x3
    80005280:	49c58593          	addi	a1,a1,1180 # 80008718 <syscalls+0x350>
    80005284:	00018517          	auipc	a0,0x18
    80005288:	ea450513          	addi	a0,a0,-348 # 8001d128 <disk+0x2128>
    8000528c:	00001097          	auipc	ra,0x1
    80005290:	f1c080e7          	jalr	-228(ra) # 800061a8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005294:	100017b7          	lui	a5,0x10001
    80005298:	4398                	lw	a4,0(a5)
    8000529a:	2701                	sext.w	a4,a4
    8000529c:	747277b7          	lui	a5,0x74727
    800052a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052a4:	0ef71163          	bne	a4,a5,80005386 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	43dc                	lw	a5,4(a5)
    800052ae:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b0:	4705                	li	a4,1
    800052b2:	0ce79a63          	bne	a5,a4,80005386 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	479c                	lw	a5,8(a5)
    800052bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052be:	4709                	li	a4,2
    800052c0:	0ce79363          	bne	a5,a4,80005386 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	47d8                	lw	a4,12(a5)
    800052ca:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052cc:	554d47b7          	lui	a5,0x554d4
    800052d0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052d4:	0af71963          	bne	a4,a5,80005386 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	4705                	li	a4,1
    800052de:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e0:	470d                	li	a4,3
    800052e2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052e4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052e6:	c7ffe737          	lui	a4,0xc7ffe
    800052ea:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ee:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052f0:	2701                	sext.w	a4,a4
    800052f2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f4:	472d                	li	a4,11
    800052f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	473d                	li	a4,15
    800052fa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052fc:	6705                	lui	a4,0x1
    800052fe:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005300:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005304:	5bdc                	lw	a5,52(a5)
    80005306:	2781                	sext.w	a5,a5
  if(max == 0)
    80005308:	c7d9                	beqz	a5,80005396 <virtio_disk_init+0x124>
  if(max < NUM)
    8000530a:	471d                	li	a4,7
    8000530c:	08f77d63          	bgeu	a4,a5,800053a6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005310:	100014b7          	lui	s1,0x10001
    80005314:	47a1                	li	a5,8
    80005316:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005318:	6609                	lui	a2,0x2
    8000531a:	4581                	li	a1,0
    8000531c:	00016517          	auipc	a0,0x16
    80005320:	ce450513          	addi	a0,a0,-796 # 8001b000 <disk>
    80005324:	ffffb097          	auipc	ra,0xffffb
    80005328:	e54080e7          	jalr	-428(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000532c:	00016717          	auipc	a4,0x16
    80005330:	cd470713          	addi	a4,a4,-812 # 8001b000 <disk>
    80005334:	00c75793          	srli	a5,a4,0xc
    80005338:	2781                	sext.w	a5,a5
    8000533a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000533c:	00018797          	auipc	a5,0x18
    80005340:	cc478793          	addi	a5,a5,-828 # 8001d000 <disk+0x2000>
    80005344:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005346:	00016717          	auipc	a4,0x16
    8000534a:	d3a70713          	addi	a4,a4,-710 # 8001b080 <disk+0x80>
    8000534e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005350:	00017717          	auipc	a4,0x17
    80005354:	cb070713          	addi	a4,a4,-848 # 8001c000 <disk+0x1000>
    80005358:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000535a:	4705                	li	a4,1
    8000535c:	00e78c23          	sb	a4,24(a5)
    80005360:	00e78ca3          	sb	a4,25(a5)
    80005364:	00e78d23          	sb	a4,26(a5)
    80005368:	00e78da3          	sb	a4,27(a5)
    8000536c:	00e78e23          	sb	a4,28(a5)
    80005370:	00e78ea3          	sb	a4,29(a5)
    80005374:	00e78f23          	sb	a4,30(a5)
    80005378:	00e78fa3          	sb	a4,31(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret
    panic("could not find virtio disk");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	3a250513          	addi	a0,a0,930 # 80008728 <syscalls+0x360>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	98a080e7          	jalr	-1654(ra) # 80005d18 <panic>
    panic("virtio disk has no queue 0");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	3b250513          	addi	a0,a0,946 # 80008748 <syscalls+0x380>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	97a080e7          	jalr	-1670(ra) # 80005d18 <panic>
    panic("virtio disk max queue too short");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	3c250513          	addi	a0,a0,962 # 80008768 <syscalls+0x3a0>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	96a080e7          	jalr	-1686(ra) # 80005d18 <panic>

00000000800053b6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053b6:	7159                	addi	sp,sp,-112
    800053b8:	f486                	sd	ra,104(sp)
    800053ba:	f0a2                	sd	s0,96(sp)
    800053bc:	eca6                	sd	s1,88(sp)
    800053be:	e8ca                	sd	s2,80(sp)
    800053c0:	e4ce                	sd	s3,72(sp)
    800053c2:	e0d2                	sd	s4,64(sp)
    800053c4:	fc56                	sd	s5,56(sp)
    800053c6:	f85a                	sd	s6,48(sp)
    800053c8:	f45e                	sd	s7,40(sp)
    800053ca:	f062                	sd	s8,32(sp)
    800053cc:	ec66                	sd	s9,24(sp)
    800053ce:	e86a                	sd	s10,16(sp)
    800053d0:	1880                	addi	s0,sp,112
    800053d2:	892a                	mv	s2,a0
    800053d4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053d6:	00c52c83          	lw	s9,12(a0)
    800053da:	001c9c9b          	slliw	s9,s9,0x1
    800053de:	1c82                	slli	s9,s9,0x20
    800053e0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053e4:	00018517          	auipc	a0,0x18
    800053e8:	d4450513          	addi	a0,a0,-700 # 8001d128 <disk+0x2128>
    800053ec:	00001097          	auipc	ra,0x1
    800053f0:	e4c080e7          	jalr	-436(ra) # 80006238 <acquire>
  for(int i = 0; i < 3; i++){
    800053f4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053f6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053f8:	00016b97          	auipc	s7,0x16
    800053fc:	c08b8b93          	addi	s7,s7,-1016 # 8001b000 <disk>
    80005400:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005402:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005404:	8a4e                	mv	s4,s3
    80005406:	a051                	j	8000548a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005408:	00fb86b3          	add	a3,s7,a5
    8000540c:	96da                	add	a3,a3,s6
    8000540e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005412:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005414:	0207c563          	bltz	a5,8000543e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005418:	2485                	addiw	s1,s1,1
    8000541a:	0711                	addi	a4,a4,4
    8000541c:	25548063          	beq	s1,s5,8000565c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005420:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005422:	00018697          	auipc	a3,0x18
    80005426:	bf668693          	addi	a3,a3,-1034 # 8001d018 <disk+0x2018>
    8000542a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000542c:	0006c583          	lbu	a1,0(a3)
    80005430:	fde1                	bnez	a1,80005408 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005432:	2785                	addiw	a5,a5,1
    80005434:	0685                	addi	a3,a3,1
    80005436:	ff879be3          	bne	a5,s8,8000542c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000543a:	57fd                	li	a5,-1
    8000543c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000543e:	02905a63          	blez	s1,80005472 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005442:	f9042503          	lw	a0,-112(s0)
    80005446:	00000097          	auipc	ra,0x0
    8000544a:	d90080e7          	jalr	-624(ra) # 800051d6 <free_desc>
      for(int j = 0; j < i; j++)
    8000544e:	4785                	li	a5,1
    80005450:	0297d163          	bge	a5,s1,80005472 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005454:	f9442503          	lw	a0,-108(s0)
    80005458:	00000097          	auipc	ra,0x0
    8000545c:	d7e080e7          	jalr	-642(ra) # 800051d6 <free_desc>
      for(int j = 0; j < i; j++)
    80005460:	4789                	li	a5,2
    80005462:	0097d863          	bge	a5,s1,80005472 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005466:	f9842503          	lw	a0,-104(s0)
    8000546a:	00000097          	auipc	ra,0x0
    8000546e:	d6c080e7          	jalr	-660(ra) # 800051d6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005472:	00018597          	auipc	a1,0x18
    80005476:	cb658593          	addi	a1,a1,-842 # 8001d128 <disk+0x2128>
    8000547a:	00018517          	auipc	a0,0x18
    8000547e:	b9e50513          	addi	a0,a0,-1122 # 8001d018 <disk+0x2018>
    80005482:	ffffc097          	auipc	ra,0xffffc
    80005486:	0d2080e7          	jalr	210(ra) # 80001554 <sleep>
  for(int i = 0; i < 3; i++){
    8000548a:	f9040713          	addi	a4,s0,-112
    8000548e:	84ce                	mv	s1,s3
    80005490:	bf41                	j	80005420 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005492:	20058713          	addi	a4,a1,512
    80005496:	00471693          	slli	a3,a4,0x4
    8000549a:	00016717          	auipc	a4,0x16
    8000549e:	b6670713          	addi	a4,a4,-1178 # 8001b000 <disk>
    800054a2:	9736                	add	a4,a4,a3
    800054a4:	4685                	li	a3,1
    800054a6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054aa:	20058713          	addi	a4,a1,512
    800054ae:	00471693          	slli	a3,a4,0x4
    800054b2:	00016717          	auipc	a4,0x16
    800054b6:	b4e70713          	addi	a4,a4,-1202 # 8001b000 <disk>
    800054ba:	9736                	add	a4,a4,a3
    800054bc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054c0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054c4:	7679                	lui	a2,0xffffe
    800054c6:	963e                	add	a2,a2,a5
    800054c8:	00018697          	auipc	a3,0x18
    800054cc:	b3868693          	addi	a3,a3,-1224 # 8001d000 <disk+0x2000>
    800054d0:	6298                	ld	a4,0(a3)
    800054d2:	9732                	add	a4,a4,a2
    800054d4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054d6:	6298                	ld	a4,0(a3)
    800054d8:	9732                	add	a4,a4,a2
    800054da:	4541                	li	a0,16
    800054dc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054de:	6298                	ld	a4,0(a3)
    800054e0:	9732                	add	a4,a4,a2
    800054e2:	4505                	li	a0,1
    800054e4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054e8:	f9442703          	lw	a4,-108(s0)
    800054ec:	6288                	ld	a0,0(a3)
    800054ee:	962a                	add	a2,a2,a0
    800054f0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054f4:	0712                	slli	a4,a4,0x4
    800054f6:	6290                	ld	a2,0(a3)
    800054f8:	963a                	add	a2,a2,a4
    800054fa:	05890513          	addi	a0,s2,88
    800054fe:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005500:	6294                	ld	a3,0(a3)
    80005502:	96ba                	add	a3,a3,a4
    80005504:	40000613          	li	a2,1024
    80005508:	c690                	sw	a2,8(a3)
  if(write)
    8000550a:	140d0063          	beqz	s10,8000564a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000550e:	00018697          	auipc	a3,0x18
    80005512:	af26b683          	ld	a3,-1294(a3) # 8001d000 <disk+0x2000>
    80005516:	96ba                	add	a3,a3,a4
    80005518:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000551c:	00016817          	auipc	a6,0x16
    80005520:	ae480813          	addi	a6,a6,-1308 # 8001b000 <disk>
    80005524:	00018517          	auipc	a0,0x18
    80005528:	adc50513          	addi	a0,a0,-1316 # 8001d000 <disk+0x2000>
    8000552c:	6114                	ld	a3,0(a0)
    8000552e:	96ba                	add	a3,a3,a4
    80005530:	00c6d603          	lhu	a2,12(a3)
    80005534:	00166613          	ori	a2,a2,1
    80005538:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000553c:	f9842683          	lw	a3,-104(s0)
    80005540:	6110                	ld	a2,0(a0)
    80005542:	9732                	add	a4,a4,a2
    80005544:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005548:	20058613          	addi	a2,a1,512
    8000554c:	0612                	slli	a2,a2,0x4
    8000554e:	9642                	add	a2,a2,a6
    80005550:	577d                	li	a4,-1
    80005552:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005556:	00469713          	slli	a4,a3,0x4
    8000555a:	6114                	ld	a3,0(a0)
    8000555c:	96ba                	add	a3,a3,a4
    8000555e:	03078793          	addi	a5,a5,48
    80005562:	97c2                	add	a5,a5,a6
    80005564:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005566:	611c                	ld	a5,0(a0)
    80005568:	97ba                	add	a5,a5,a4
    8000556a:	4685                	li	a3,1
    8000556c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000556e:	611c                	ld	a5,0(a0)
    80005570:	97ba                	add	a5,a5,a4
    80005572:	4809                	li	a6,2
    80005574:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005578:	611c                	ld	a5,0(a0)
    8000557a:	973e                	add	a4,a4,a5
    8000557c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005580:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005584:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005588:	6518                	ld	a4,8(a0)
    8000558a:	00275783          	lhu	a5,2(a4)
    8000558e:	8b9d                	andi	a5,a5,7
    80005590:	0786                	slli	a5,a5,0x1
    80005592:	97ba                	add	a5,a5,a4
    80005594:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005598:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000559c:	6518                	ld	a4,8(a0)
    8000559e:	00275783          	lhu	a5,2(a4)
    800055a2:	2785                	addiw	a5,a5,1
    800055a4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055a8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055ac:	100017b7          	lui	a5,0x10001
    800055b0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055b4:	00492703          	lw	a4,4(s2)
    800055b8:	4785                	li	a5,1
    800055ba:	02f71163          	bne	a4,a5,800055dc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055be:	00018997          	auipc	s3,0x18
    800055c2:	b6a98993          	addi	s3,s3,-1174 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055c8:	85ce                	mv	a1,s3
    800055ca:	854a                	mv	a0,s2
    800055cc:	ffffc097          	auipc	ra,0xffffc
    800055d0:	f88080e7          	jalr	-120(ra) # 80001554 <sleep>
  while(b->disk == 1) {
    800055d4:	00492783          	lw	a5,4(s2)
    800055d8:	fe9788e3          	beq	a5,s1,800055c8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055dc:	f9042903          	lw	s2,-112(s0)
    800055e0:	20090793          	addi	a5,s2,512
    800055e4:	00479713          	slli	a4,a5,0x4
    800055e8:	00016797          	auipc	a5,0x16
    800055ec:	a1878793          	addi	a5,a5,-1512 # 8001b000 <disk>
    800055f0:	97ba                	add	a5,a5,a4
    800055f2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055f6:	00018997          	auipc	s3,0x18
    800055fa:	a0a98993          	addi	s3,s3,-1526 # 8001d000 <disk+0x2000>
    800055fe:	00491713          	slli	a4,s2,0x4
    80005602:	0009b783          	ld	a5,0(s3)
    80005606:	97ba                	add	a5,a5,a4
    80005608:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000560c:	854a                	mv	a0,s2
    8000560e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005612:	00000097          	auipc	ra,0x0
    80005616:	bc4080e7          	jalr	-1084(ra) # 800051d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000561a:	8885                	andi	s1,s1,1
    8000561c:	f0ed                	bnez	s1,800055fe <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000561e:	00018517          	auipc	a0,0x18
    80005622:	b0a50513          	addi	a0,a0,-1270 # 8001d128 <disk+0x2128>
    80005626:	00001097          	auipc	ra,0x1
    8000562a:	cc6080e7          	jalr	-826(ra) # 800062ec <release>
}
    8000562e:	70a6                	ld	ra,104(sp)
    80005630:	7406                	ld	s0,96(sp)
    80005632:	64e6                	ld	s1,88(sp)
    80005634:	6946                	ld	s2,80(sp)
    80005636:	69a6                	ld	s3,72(sp)
    80005638:	6a06                	ld	s4,64(sp)
    8000563a:	7ae2                	ld	s5,56(sp)
    8000563c:	7b42                	ld	s6,48(sp)
    8000563e:	7ba2                	ld	s7,40(sp)
    80005640:	7c02                	ld	s8,32(sp)
    80005642:	6ce2                	ld	s9,24(sp)
    80005644:	6d42                	ld	s10,16(sp)
    80005646:	6165                	addi	sp,sp,112
    80005648:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000564a:	00018697          	auipc	a3,0x18
    8000564e:	9b66b683          	ld	a3,-1610(a3) # 8001d000 <disk+0x2000>
    80005652:	96ba                	add	a3,a3,a4
    80005654:	4609                	li	a2,2
    80005656:	00c69623          	sh	a2,12(a3)
    8000565a:	b5c9                	j	8000551c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000565c:	f9042583          	lw	a1,-112(s0)
    80005660:	20058793          	addi	a5,a1,512
    80005664:	0792                	slli	a5,a5,0x4
    80005666:	00016517          	auipc	a0,0x16
    8000566a:	a4250513          	addi	a0,a0,-1470 # 8001b0a8 <disk+0xa8>
    8000566e:	953e                	add	a0,a0,a5
  if(write)
    80005670:	e20d11e3          	bnez	s10,80005492 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005674:	20058713          	addi	a4,a1,512
    80005678:	00471693          	slli	a3,a4,0x4
    8000567c:	00016717          	auipc	a4,0x16
    80005680:	98470713          	addi	a4,a4,-1660 # 8001b000 <disk>
    80005684:	9736                	add	a4,a4,a3
    80005686:	0a072423          	sw	zero,168(a4)
    8000568a:	b505                	j	800054aa <virtio_disk_rw+0xf4>

000000008000568c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000568c:	1101                	addi	sp,sp,-32
    8000568e:	ec06                	sd	ra,24(sp)
    80005690:	e822                	sd	s0,16(sp)
    80005692:	e426                	sd	s1,8(sp)
    80005694:	e04a                	sd	s2,0(sp)
    80005696:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005698:	00018517          	auipc	a0,0x18
    8000569c:	a9050513          	addi	a0,a0,-1392 # 8001d128 <disk+0x2128>
    800056a0:	00001097          	auipc	ra,0x1
    800056a4:	b98080e7          	jalr	-1128(ra) # 80006238 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a8:	10001737          	lui	a4,0x10001
    800056ac:	533c                	lw	a5,96(a4)
    800056ae:	8b8d                	andi	a5,a5,3
    800056b0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056b6:	00018797          	auipc	a5,0x18
    800056ba:	94a78793          	addi	a5,a5,-1718 # 8001d000 <disk+0x2000>
    800056be:	6b94                	ld	a3,16(a5)
    800056c0:	0207d703          	lhu	a4,32(a5)
    800056c4:	0026d783          	lhu	a5,2(a3)
    800056c8:	06f70163          	beq	a4,a5,8000572a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056cc:	00016917          	auipc	s2,0x16
    800056d0:	93490913          	addi	s2,s2,-1740 # 8001b000 <disk>
    800056d4:	00018497          	auipc	s1,0x18
    800056d8:	92c48493          	addi	s1,s1,-1748 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056dc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056e0:	6898                	ld	a4,16(s1)
    800056e2:	0204d783          	lhu	a5,32(s1)
    800056e6:	8b9d                	andi	a5,a5,7
    800056e8:	078e                	slli	a5,a5,0x3
    800056ea:	97ba                	add	a5,a5,a4
    800056ec:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ee:	20078713          	addi	a4,a5,512
    800056f2:	0712                	slli	a4,a4,0x4
    800056f4:	974a                	add	a4,a4,s2
    800056f6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056fa:	e731                	bnez	a4,80005746 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056fc:	20078793          	addi	a5,a5,512
    80005700:	0792                	slli	a5,a5,0x4
    80005702:	97ca                	add	a5,a5,s2
    80005704:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005706:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000570a:	ffffc097          	auipc	ra,0xffffc
    8000570e:	fd6080e7          	jalr	-42(ra) # 800016e0 <wakeup>

    disk.used_idx += 1;
    80005712:	0204d783          	lhu	a5,32(s1)
    80005716:	2785                	addiw	a5,a5,1
    80005718:	17c2                	slli	a5,a5,0x30
    8000571a:	93c1                	srli	a5,a5,0x30
    8000571c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005720:	6898                	ld	a4,16(s1)
    80005722:	00275703          	lhu	a4,2(a4)
    80005726:	faf71be3          	bne	a4,a5,800056dc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000572a:	00018517          	auipc	a0,0x18
    8000572e:	9fe50513          	addi	a0,a0,-1538 # 8001d128 <disk+0x2128>
    80005732:	00001097          	auipc	ra,0x1
    80005736:	bba080e7          	jalr	-1094(ra) # 800062ec <release>
}
    8000573a:	60e2                	ld	ra,24(sp)
    8000573c:	6442                	ld	s0,16(sp)
    8000573e:	64a2                	ld	s1,8(sp)
    80005740:	6902                	ld	s2,0(sp)
    80005742:	6105                	addi	sp,sp,32
    80005744:	8082                	ret
      panic("virtio_disk_intr status");
    80005746:	00003517          	auipc	a0,0x3
    8000574a:	04250513          	addi	a0,a0,66 # 80008788 <syscalls+0x3c0>
    8000574e:	00000097          	auipc	ra,0x0
    80005752:	5ca080e7          	jalr	1482(ra) # 80005d18 <panic>

0000000080005756 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005756:	1141                	addi	sp,sp,-16
    80005758:	e422                	sd	s0,8(sp)
    8000575a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000575c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005760:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005764:	0037979b          	slliw	a5,a5,0x3
    80005768:	02004737          	lui	a4,0x2004
    8000576c:	97ba                	add	a5,a5,a4
    8000576e:	0200c737          	lui	a4,0x200c
    80005772:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005776:	000f4637          	lui	a2,0xf4
    8000577a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000577e:	95b2                	add	a1,a1,a2
    80005780:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005782:	00269713          	slli	a4,a3,0x2
    80005786:	9736                	add	a4,a4,a3
    80005788:	00371693          	slli	a3,a4,0x3
    8000578c:	00019717          	auipc	a4,0x19
    80005790:	87470713          	addi	a4,a4,-1932 # 8001e000 <timer_scratch>
    80005794:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005796:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005798:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000579a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000579e:	00000797          	auipc	a5,0x0
    800057a2:	97278793          	addi	a5,a5,-1678 # 80005110 <timervec>
    800057a6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057aa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057ae:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057b2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057b6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ba:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057be:	30479073          	csrw	mie,a5
}
    800057c2:	6422                	ld	s0,8(sp)
    800057c4:	0141                	addi	sp,sp,16
    800057c6:	8082                	ret

00000000800057c8 <start>:
{
    800057c8:	1141                	addi	sp,sp,-16
    800057ca:	e406                	sd	ra,8(sp)
    800057cc:	e022                	sd	s0,0(sp)
    800057ce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057d0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057d4:	7779                	lui	a4,0xffffe
    800057d6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057da:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057dc:	6705                	lui	a4,0x1
    800057de:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057e2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057e4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057e8:	ffffb797          	auipc	a5,0xffffb
    800057ec:	b3e78793          	addi	a5,a5,-1218 # 80000326 <main>
    800057f0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057f4:	4781                	li	a5,0
    800057f6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057fa:	67c1                	lui	a5,0x10
    800057fc:	17fd                	addi	a5,a5,-1
    800057fe:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005802:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005806:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000580a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000580e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005812:	57fd                	li	a5,-1
    80005814:	83a9                	srli	a5,a5,0xa
    80005816:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000581a:	47bd                	li	a5,15
    8000581c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005820:	00000097          	auipc	ra,0x0
    80005824:	f36080e7          	jalr	-202(ra) # 80005756 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005828:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000582c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000582e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005830:	30200073          	mret
}
    80005834:	60a2                	ld	ra,8(sp)
    80005836:	6402                	ld	s0,0(sp)
    80005838:	0141                	addi	sp,sp,16
    8000583a:	8082                	ret

000000008000583c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000583c:	715d                	addi	sp,sp,-80
    8000583e:	e486                	sd	ra,72(sp)
    80005840:	e0a2                	sd	s0,64(sp)
    80005842:	fc26                	sd	s1,56(sp)
    80005844:	f84a                	sd	s2,48(sp)
    80005846:	f44e                	sd	s3,40(sp)
    80005848:	f052                	sd	s4,32(sp)
    8000584a:	ec56                	sd	s5,24(sp)
    8000584c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000584e:	04c05663          	blez	a2,8000589a <consolewrite+0x5e>
    80005852:	8a2a                	mv	s4,a0
    80005854:	84ae                	mv	s1,a1
    80005856:	89b2                	mv	s3,a2
    80005858:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000585a:	5afd                	li	s5,-1
    8000585c:	4685                	li	a3,1
    8000585e:	8626                	mv	a2,s1
    80005860:	85d2                	mv	a1,s4
    80005862:	fbf40513          	addi	a0,s0,-65
    80005866:	ffffc097          	auipc	ra,0xffffc
    8000586a:	0e8080e7          	jalr	232(ra) # 8000194e <either_copyin>
    8000586e:	01550c63          	beq	a0,s5,80005886 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005872:	fbf44503          	lbu	a0,-65(s0)
    80005876:	00001097          	auipc	ra,0x1
    8000587a:	804080e7          	jalr	-2044(ra) # 8000607a <uartputc>
  for(i = 0; i < n; i++){
    8000587e:	2905                	addiw	s2,s2,1
    80005880:	0485                	addi	s1,s1,1
    80005882:	fd299de3          	bne	s3,s2,8000585c <consolewrite+0x20>
  }

  return i;
}
    80005886:	854a                	mv	a0,s2
    80005888:	60a6                	ld	ra,72(sp)
    8000588a:	6406                	ld	s0,64(sp)
    8000588c:	74e2                	ld	s1,56(sp)
    8000588e:	7942                	ld	s2,48(sp)
    80005890:	79a2                	ld	s3,40(sp)
    80005892:	7a02                	ld	s4,32(sp)
    80005894:	6ae2                	ld	s5,24(sp)
    80005896:	6161                	addi	sp,sp,80
    80005898:	8082                	ret
  for(i = 0; i < n; i++){
    8000589a:	4901                	li	s2,0
    8000589c:	b7ed                	j	80005886 <consolewrite+0x4a>

000000008000589e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000589e:	7119                	addi	sp,sp,-128
    800058a0:	fc86                	sd	ra,120(sp)
    800058a2:	f8a2                	sd	s0,112(sp)
    800058a4:	f4a6                	sd	s1,104(sp)
    800058a6:	f0ca                	sd	s2,96(sp)
    800058a8:	ecce                	sd	s3,88(sp)
    800058aa:	e8d2                	sd	s4,80(sp)
    800058ac:	e4d6                	sd	s5,72(sp)
    800058ae:	e0da                	sd	s6,64(sp)
    800058b0:	fc5e                	sd	s7,56(sp)
    800058b2:	f862                	sd	s8,48(sp)
    800058b4:	f466                	sd	s9,40(sp)
    800058b6:	f06a                	sd	s10,32(sp)
    800058b8:	ec6e                	sd	s11,24(sp)
    800058ba:	0100                	addi	s0,sp,128
    800058bc:	8b2a                	mv	s6,a0
    800058be:	8aae                	mv	s5,a1
    800058c0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058c2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058c6:	00021517          	auipc	a0,0x21
    800058ca:	87a50513          	addi	a0,a0,-1926 # 80026140 <cons>
    800058ce:	00001097          	auipc	ra,0x1
    800058d2:	96a080e7          	jalr	-1686(ra) # 80006238 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058d6:	00021497          	auipc	s1,0x21
    800058da:	86a48493          	addi	s1,s1,-1942 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058de:	89a6                	mv	s3,s1
    800058e0:	00021917          	auipc	s2,0x21
    800058e4:	8f890913          	addi	s2,s2,-1800 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058e8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ea:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058ec:	4da9                	li	s11,10
  while(n > 0){
    800058ee:	07405863          	blez	s4,8000595e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058f2:	0984a783          	lw	a5,152(s1)
    800058f6:	09c4a703          	lw	a4,156(s1)
    800058fa:	02f71463          	bne	a4,a5,80005922 <consoleread+0x84>
      if(myproc()->killed){
    800058fe:	ffffb097          	auipc	ra,0xffffb
    80005902:	54a080e7          	jalr	1354(ra) # 80000e48 <myproc>
    80005906:	551c                	lw	a5,40(a0)
    80005908:	e7b5                	bnez	a5,80005974 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000590a:	85ce                	mv	a1,s3
    8000590c:	854a                	mv	a0,s2
    8000590e:	ffffc097          	auipc	ra,0xffffc
    80005912:	c46080e7          	jalr	-954(ra) # 80001554 <sleep>
    while(cons.r == cons.w){
    80005916:	0984a783          	lw	a5,152(s1)
    8000591a:	09c4a703          	lw	a4,156(s1)
    8000591e:	fef700e3          	beq	a4,a5,800058fe <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005922:	0017871b          	addiw	a4,a5,1
    80005926:	08e4ac23          	sw	a4,152(s1)
    8000592a:	07f7f713          	andi	a4,a5,127
    8000592e:	9726                	add	a4,a4,s1
    80005930:	01874703          	lbu	a4,24(a4)
    80005934:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005938:	079c0663          	beq	s8,s9,800059a4 <consoleread+0x106>
    cbuf = c;
    8000593c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005940:	4685                	li	a3,1
    80005942:	f8f40613          	addi	a2,s0,-113
    80005946:	85d6                	mv	a1,s5
    80005948:	855a                	mv	a0,s6
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	fae080e7          	jalr	-82(ra) # 800018f8 <either_copyout>
    80005952:	01a50663          	beq	a0,s10,8000595e <consoleread+0xc0>
    dst++;
    80005956:	0a85                	addi	s5,s5,1
    --n;
    80005958:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000595a:	f9bc1ae3          	bne	s8,s11,800058ee <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000595e:	00020517          	auipc	a0,0x20
    80005962:	7e250513          	addi	a0,a0,2018 # 80026140 <cons>
    80005966:	00001097          	auipc	ra,0x1
    8000596a:	986080e7          	jalr	-1658(ra) # 800062ec <release>

  return target - n;
    8000596e:	414b853b          	subw	a0,s7,s4
    80005972:	a811                	j	80005986 <consoleread+0xe8>
        release(&cons.lock);
    80005974:	00020517          	auipc	a0,0x20
    80005978:	7cc50513          	addi	a0,a0,1996 # 80026140 <cons>
    8000597c:	00001097          	auipc	ra,0x1
    80005980:	970080e7          	jalr	-1680(ra) # 800062ec <release>
        return -1;
    80005984:	557d                	li	a0,-1
}
    80005986:	70e6                	ld	ra,120(sp)
    80005988:	7446                	ld	s0,112(sp)
    8000598a:	74a6                	ld	s1,104(sp)
    8000598c:	7906                	ld	s2,96(sp)
    8000598e:	69e6                	ld	s3,88(sp)
    80005990:	6a46                	ld	s4,80(sp)
    80005992:	6aa6                	ld	s5,72(sp)
    80005994:	6b06                	ld	s6,64(sp)
    80005996:	7be2                	ld	s7,56(sp)
    80005998:	7c42                	ld	s8,48(sp)
    8000599a:	7ca2                	ld	s9,40(sp)
    8000599c:	7d02                	ld	s10,32(sp)
    8000599e:	6de2                	ld	s11,24(sp)
    800059a0:	6109                	addi	sp,sp,128
    800059a2:	8082                	ret
      if(n < target){
    800059a4:	000a071b          	sext.w	a4,s4
    800059a8:	fb777be3          	bgeu	a4,s7,8000595e <consoleread+0xc0>
        cons.r--;
    800059ac:	00021717          	auipc	a4,0x21
    800059b0:	82f72623          	sw	a5,-2004(a4) # 800261d8 <cons+0x98>
    800059b4:	b76d                	j	8000595e <consoleread+0xc0>

00000000800059b6 <consputc>:
{
    800059b6:	1141                	addi	sp,sp,-16
    800059b8:	e406                	sd	ra,8(sp)
    800059ba:	e022                	sd	s0,0(sp)
    800059bc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059be:	10000793          	li	a5,256
    800059c2:	00f50a63          	beq	a0,a5,800059d6 <consputc+0x20>
    uartputc_sync(c);
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	5da080e7          	jalr	1498(ra) # 80005fa0 <uartputc_sync>
}
    800059ce:	60a2                	ld	ra,8(sp)
    800059d0:	6402                	ld	s0,0(sp)
    800059d2:	0141                	addi	sp,sp,16
    800059d4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059d6:	4521                	li	a0,8
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	5c8080e7          	jalr	1480(ra) # 80005fa0 <uartputc_sync>
    800059e0:	02000513          	li	a0,32
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	5bc080e7          	jalr	1468(ra) # 80005fa0 <uartputc_sync>
    800059ec:	4521                	li	a0,8
    800059ee:	00000097          	auipc	ra,0x0
    800059f2:	5b2080e7          	jalr	1458(ra) # 80005fa0 <uartputc_sync>
    800059f6:	bfe1                	j	800059ce <consputc+0x18>

00000000800059f8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059f8:	1101                	addi	sp,sp,-32
    800059fa:	ec06                	sd	ra,24(sp)
    800059fc:	e822                	sd	s0,16(sp)
    800059fe:	e426                	sd	s1,8(sp)
    80005a00:	e04a                	sd	s2,0(sp)
    80005a02:	1000                	addi	s0,sp,32
    80005a04:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a06:	00020517          	auipc	a0,0x20
    80005a0a:	73a50513          	addi	a0,a0,1850 # 80026140 <cons>
    80005a0e:	00001097          	auipc	ra,0x1
    80005a12:	82a080e7          	jalr	-2006(ra) # 80006238 <acquire>

  switch(c){
    80005a16:	47d5                	li	a5,21
    80005a18:	0af48663          	beq	s1,a5,80005ac4 <consoleintr+0xcc>
    80005a1c:	0297ca63          	blt	a5,s1,80005a50 <consoleintr+0x58>
    80005a20:	47a1                	li	a5,8
    80005a22:	0ef48763          	beq	s1,a5,80005b10 <consoleintr+0x118>
    80005a26:	47c1                	li	a5,16
    80005a28:	10f49a63          	bne	s1,a5,80005b3c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a2c:	ffffc097          	auipc	ra,0xffffc
    80005a30:	f78080e7          	jalr	-136(ra) # 800019a4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a34:	00020517          	auipc	a0,0x20
    80005a38:	70c50513          	addi	a0,a0,1804 # 80026140 <cons>
    80005a3c:	00001097          	auipc	ra,0x1
    80005a40:	8b0080e7          	jalr	-1872(ra) # 800062ec <release>
}
    80005a44:	60e2                	ld	ra,24(sp)
    80005a46:	6442                	ld	s0,16(sp)
    80005a48:	64a2                	ld	s1,8(sp)
    80005a4a:	6902                	ld	s2,0(sp)
    80005a4c:	6105                	addi	sp,sp,32
    80005a4e:	8082                	ret
  switch(c){
    80005a50:	07f00793          	li	a5,127
    80005a54:	0af48e63          	beq	s1,a5,80005b10 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a58:	00020717          	auipc	a4,0x20
    80005a5c:	6e870713          	addi	a4,a4,1768 # 80026140 <cons>
    80005a60:	0a072783          	lw	a5,160(a4)
    80005a64:	09872703          	lw	a4,152(a4)
    80005a68:	9f99                	subw	a5,a5,a4
    80005a6a:	07f00713          	li	a4,127
    80005a6e:	fcf763e3          	bltu	a4,a5,80005a34 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a72:	47b5                	li	a5,13
    80005a74:	0cf48763          	beq	s1,a5,80005b42 <consoleintr+0x14a>
      consputc(c);
    80005a78:	8526                	mv	a0,s1
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	f3c080e7          	jalr	-196(ra) # 800059b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a82:	00020797          	auipc	a5,0x20
    80005a86:	6be78793          	addi	a5,a5,1726 # 80026140 <cons>
    80005a8a:	0a07a703          	lw	a4,160(a5)
    80005a8e:	0017069b          	addiw	a3,a4,1
    80005a92:	0006861b          	sext.w	a2,a3
    80005a96:	0ad7a023          	sw	a3,160(a5)
    80005a9a:	07f77713          	andi	a4,a4,127
    80005a9e:	97ba                	add	a5,a5,a4
    80005aa0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005aa4:	47a9                	li	a5,10
    80005aa6:	0cf48563          	beq	s1,a5,80005b70 <consoleintr+0x178>
    80005aaa:	4791                	li	a5,4
    80005aac:	0cf48263          	beq	s1,a5,80005b70 <consoleintr+0x178>
    80005ab0:	00020797          	auipc	a5,0x20
    80005ab4:	7287a783          	lw	a5,1832(a5) # 800261d8 <cons+0x98>
    80005ab8:	0807879b          	addiw	a5,a5,128
    80005abc:	f6f61ce3          	bne	a2,a5,80005a34 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ac0:	863e                	mv	a2,a5
    80005ac2:	a07d                	j	80005b70 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ac4:	00020717          	auipc	a4,0x20
    80005ac8:	67c70713          	addi	a4,a4,1660 # 80026140 <cons>
    80005acc:	0a072783          	lw	a5,160(a4)
    80005ad0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ad4:	00020497          	auipc	s1,0x20
    80005ad8:	66c48493          	addi	s1,s1,1644 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005adc:	4929                	li	s2,10
    80005ade:	f4f70be3          	beq	a4,a5,80005a34 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ae2:	37fd                	addiw	a5,a5,-1
    80005ae4:	07f7f713          	andi	a4,a5,127
    80005ae8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aea:	01874703          	lbu	a4,24(a4)
    80005aee:	f52703e3          	beq	a4,s2,80005a34 <consoleintr+0x3c>
      cons.e--;
    80005af2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005af6:	10000513          	li	a0,256
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	ebc080e7          	jalr	-324(ra) # 800059b6 <consputc>
    while(cons.e != cons.w &&
    80005b02:	0a04a783          	lw	a5,160(s1)
    80005b06:	09c4a703          	lw	a4,156(s1)
    80005b0a:	fcf71ce3          	bne	a4,a5,80005ae2 <consoleintr+0xea>
    80005b0e:	b71d                	j	80005a34 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b10:	00020717          	auipc	a4,0x20
    80005b14:	63070713          	addi	a4,a4,1584 # 80026140 <cons>
    80005b18:	0a072783          	lw	a5,160(a4)
    80005b1c:	09c72703          	lw	a4,156(a4)
    80005b20:	f0f70ae3          	beq	a4,a5,80005a34 <consoleintr+0x3c>
      cons.e--;
    80005b24:	37fd                	addiw	a5,a5,-1
    80005b26:	00020717          	auipc	a4,0x20
    80005b2a:	6af72d23          	sw	a5,1722(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b2e:	10000513          	li	a0,256
    80005b32:	00000097          	auipc	ra,0x0
    80005b36:	e84080e7          	jalr	-380(ra) # 800059b6 <consputc>
    80005b3a:	bded                	j	80005a34 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b3c:	ee048ce3          	beqz	s1,80005a34 <consoleintr+0x3c>
    80005b40:	bf21                	j	80005a58 <consoleintr+0x60>
      consputc(c);
    80005b42:	4529                	li	a0,10
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	e72080e7          	jalr	-398(ra) # 800059b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b4c:	00020797          	auipc	a5,0x20
    80005b50:	5f478793          	addi	a5,a5,1524 # 80026140 <cons>
    80005b54:	0a07a703          	lw	a4,160(a5)
    80005b58:	0017069b          	addiw	a3,a4,1
    80005b5c:	0006861b          	sext.w	a2,a3
    80005b60:	0ad7a023          	sw	a3,160(a5)
    80005b64:	07f77713          	andi	a4,a4,127
    80005b68:	97ba                	add	a5,a5,a4
    80005b6a:	4729                	li	a4,10
    80005b6c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b70:	00020797          	auipc	a5,0x20
    80005b74:	66c7a623          	sw	a2,1644(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b78:	00020517          	auipc	a0,0x20
    80005b7c:	66050513          	addi	a0,a0,1632 # 800261d8 <cons+0x98>
    80005b80:	ffffc097          	auipc	ra,0xffffc
    80005b84:	b60080e7          	jalr	-1184(ra) # 800016e0 <wakeup>
    80005b88:	b575                	j	80005a34 <consoleintr+0x3c>

0000000080005b8a <consoleinit>:

void
consoleinit(void)
{
    80005b8a:	1141                	addi	sp,sp,-16
    80005b8c:	e406                	sd	ra,8(sp)
    80005b8e:	e022                	sd	s0,0(sp)
    80005b90:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b92:	00003597          	auipc	a1,0x3
    80005b96:	c0e58593          	addi	a1,a1,-1010 # 800087a0 <syscalls+0x3d8>
    80005b9a:	00020517          	auipc	a0,0x20
    80005b9e:	5a650513          	addi	a0,a0,1446 # 80026140 <cons>
    80005ba2:	00000097          	auipc	ra,0x0
    80005ba6:	606080e7          	jalr	1542(ra) # 800061a8 <initlock>

  uartinit();
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	3a6080e7          	jalr	934(ra) # 80005f50 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bb2:	00014797          	auipc	a5,0x14
    80005bb6:	11678793          	addi	a5,a5,278 # 80019cc8 <devsw>
    80005bba:	00000717          	auipc	a4,0x0
    80005bbe:	ce470713          	addi	a4,a4,-796 # 8000589e <consoleread>
    80005bc2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bc4:	00000717          	auipc	a4,0x0
    80005bc8:	c7870713          	addi	a4,a4,-904 # 8000583c <consolewrite>
    80005bcc:	ef98                	sd	a4,24(a5)
}
    80005bce:	60a2                	ld	ra,8(sp)
    80005bd0:	6402                	ld	s0,0(sp)
    80005bd2:	0141                	addi	sp,sp,16
    80005bd4:	8082                	ret

0000000080005bd6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bd6:	7179                	addi	sp,sp,-48
    80005bd8:	f406                	sd	ra,40(sp)
    80005bda:	f022                	sd	s0,32(sp)
    80005bdc:	ec26                	sd	s1,24(sp)
    80005bde:	e84a                	sd	s2,16(sp)
    80005be0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005be2:	c219                	beqz	a2,80005be8 <printint+0x12>
    80005be4:	08054663          	bltz	a0,80005c70 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005be8:	2501                	sext.w	a0,a0
    80005bea:	4881                	li	a7,0
    80005bec:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bf0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bf2:	2581                	sext.w	a1,a1
    80005bf4:	00003617          	auipc	a2,0x3
    80005bf8:	bf460613          	addi	a2,a2,-1036 # 800087e8 <digits>
    80005bfc:	883a                	mv	a6,a4
    80005bfe:	2705                	addiw	a4,a4,1
    80005c00:	02b577bb          	remuw	a5,a0,a1
    80005c04:	1782                	slli	a5,a5,0x20
    80005c06:	9381                	srli	a5,a5,0x20
    80005c08:	97b2                	add	a5,a5,a2
    80005c0a:	0007c783          	lbu	a5,0(a5)
    80005c0e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c12:	0005079b          	sext.w	a5,a0
    80005c16:	02b5553b          	divuw	a0,a0,a1
    80005c1a:	0685                	addi	a3,a3,1
    80005c1c:	feb7f0e3          	bgeu	a5,a1,80005bfc <printint+0x26>

  if(sign)
    80005c20:	00088b63          	beqz	a7,80005c36 <printint+0x60>
    buf[i++] = '-';
    80005c24:	fe040793          	addi	a5,s0,-32
    80005c28:	973e                	add	a4,a4,a5
    80005c2a:	02d00793          	li	a5,45
    80005c2e:	fef70823          	sb	a5,-16(a4)
    80005c32:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c36:	02e05763          	blez	a4,80005c64 <printint+0x8e>
    80005c3a:	fd040793          	addi	a5,s0,-48
    80005c3e:	00e784b3          	add	s1,a5,a4
    80005c42:	fff78913          	addi	s2,a5,-1
    80005c46:	993a                	add	s2,s2,a4
    80005c48:	377d                	addiw	a4,a4,-1
    80005c4a:	1702                	slli	a4,a4,0x20
    80005c4c:	9301                	srli	a4,a4,0x20
    80005c4e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c52:	fff4c503          	lbu	a0,-1(s1)
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	d60080e7          	jalr	-672(ra) # 800059b6 <consputc>
  while(--i >= 0)
    80005c5e:	14fd                	addi	s1,s1,-1
    80005c60:	ff2499e3          	bne	s1,s2,80005c52 <printint+0x7c>
}
    80005c64:	70a2                	ld	ra,40(sp)
    80005c66:	7402                	ld	s0,32(sp)
    80005c68:	64e2                	ld	s1,24(sp)
    80005c6a:	6942                	ld	s2,16(sp)
    80005c6c:	6145                	addi	sp,sp,48
    80005c6e:	8082                	ret
    x = -xx;
    80005c70:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c74:	4885                	li	a7,1
    x = -xx;
    80005c76:	bf9d                	j	80005bec <printint+0x16>

0000000080005c78 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c78:	1101                	addi	sp,sp,-32
    80005c7a:	ec06                	sd	ra,24(sp)
    80005c7c:	e822                	sd	s0,16(sp)
    80005c7e:	e426                	sd	s1,8(sp)
    80005c80:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c82:	00020497          	auipc	s1,0x20
    80005c86:	56648493          	addi	s1,s1,1382 # 800261e8 <pr>
    80005c8a:	00003597          	auipc	a1,0x3
    80005c8e:	b1e58593          	addi	a1,a1,-1250 # 800087a8 <syscalls+0x3e0>
    80005c92:	8526                	mv	a0,s1
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	514080e7          	jalr	1300(ra) # 800061a8 <initlock>
  pr.locking = 1;
    80005c9c:	4785                	li	a5,1
    80005c9e:	cc9c                	sw	a5,24(s1)
}
    80005ca0:	60e2                	ld	ra,24(sp)
    80005ca2:	6442                	ld	s0,16(sp)
    80005ca4:	64a2                	ld	s1,8(sp)
    80005ca6:	6105                	addi	sp,sp,32
    80005ca8:	8082                	ret

0000000080005caa <backtrace>:

void backtrace(void)
{
    80005caa:	7179                	addi	sp,sp,-48
    80005cac:	f406                	sd	ra,40(sp)
    80005cae:	f022                	sd	s0,32(sp)
    80005cb0:	ec26                	sd	s1,24(sp)
    80005cb2:	e84a                	sd	s2,16(sp)
    80005cb4:	e44e                	sd	s3,8(sp)
    80005cb6:	e052                	sd	s4,0(sp)
    80005cb8:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005cba:	00003517          	auipc	a0,0x3
    80005cbe:	af650513          	addi	a0,a0,-1290 # 800087b0 <syscalls+0x3e8>
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	0a8080e7          	jalr	168(ra) # 80005d6a <printf>

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005cca:	87a2                	mv	a5,s0
  uint64 fp = r_fp();
  uint64 *frame = (uint64 *)fp;
  uint64 up = PGROUNDUP(fp);
    80005ccc:	6905                	lui	s2,0x1
    80005cce:	197d                	addi	s2,s2,-1
    80005cd0:	993e                	add	s2,s2,a5
    80005cd2:	79fd                	lui	s3,0xfffff
    80005cd4:	01397933          	and	s2,s2,s3
  uint64 down = PGROUNDDOWN(fp);
    80005cd8:	0137f9b3          	and	s3,a5,s3
  while(fp < up && fp > down)
    80005cdc:	0327f663          	bgeu	a5,s2,80005d08 <backtrace+0x5e>
    80005ce0:	84be                	mv	s1,a5
    80005ce2:	02f9f363          	bgeu	s3,a5,80005d08 <backtrace+0x5e>
  { 
    printf("%p\n", frame[-1]);
    80005ce6:	00003a17          	auipc	s4,0x3
    80005cea:	adaa0a13          	addi	s4,s4,-1318 # 800087c0 <syscalls+0x3f8>
    80005cee:	ff84b583          	ld	a1,-8(s1)
    80005cf2:	8552                	mv	a0,s4
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	076080e7          	jalr	118(ra) # 80005d6a <printf>
    fp = frame[-2];
    80005cfc:	ff04b483          	ld	s1,-16(s1)
  while(fp < up && fp > down)
    80005d00:	0124f463          	bgeu	s1,s2,80005d08 <backtrace+0x5e>
    80005d04:	fe99e5e3          	bltu	s3,s1,80005cee <backtrace+0x44>
    frame = (uint64 *)fp;
  }
    80005d08:	70a2                	ld	ra,40(sp)
    80005d0a:	7402                	ld	s0,32(sp)
    80005d0c:	64e2                	ld	s1,24(sp)
    80005d0e:	6942                	ld	s2,16(sp)
    80005d10:	69a2                	ld	s3,8(sp)
    80005d12:	6a02                	ld	s4,0(sp)
    80005d14:	6145                	addi	sp,sp,48
    80005d16:	8082                	ret

0000000080005d18 <panic>:
{
    80005d18:	1101                	addi	sp,sp,-32
    80005d1a:	ec06                	sd	ra,24(sp)
    80005d1c:	e822                	sd	s0,16(sp)
    80005d1e:	e426                	sd	s1,8(sp)
    80005d20:	1000                	addi	s0,sp,32
    80005d22:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d24:	00020797          	auipc	a5,0x20
    80005d28:	4c07ae23          	sw	zero,1244(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	a9c50513          	addi	a0,a0,-1380 # 800087c8 <syscalls+0x400>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	036080e7          	jalr	54(ra) # 80005d6a <printf>
  printf(s);
    80005d3c:	8526                	mv	a0,s1
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	02c080e7          	jalr	44(ra) # 80005d6a <printf>
  printf("\n");
    80005d46:	00002517          	auipc	a0,0x2
    80005d4a:	30250513          	addi	a0,a0,770 # 80008048 <etext+0x48>
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	01c080e7          	jalr	28(ra) # 80005d6a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d56:	4785                	li	a5,1
    80005d58:	00003717          	auipc	a4,0x3
    80005d5c:	2cf72223          	sw	a5,708(a4) # 8000901c <panicked>
  backtrace();
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	f4a080e7          	jalr	-182(ra) # 80005caa <backtrace>
  for(;;)
    80005d68:	a001                	j	80005d68 <panic+0x50>

0000000080005d6a <printf>:
{
    80005d6a:	7131                	addi	sp,sp,-192
    80005d6c:	fc86                	sd	ra,120(sp)
    80005d6e:	f8a2                	sd	s0,112(sp)
    80005d70:	f4a6                	sd	s1,104(sp)
    80005d72:	f0ca                	sd	s2,96(sp)
    80005d74:	ecce                	sd	s3,88(sp)
    80005d76:	e8d2                	sd	s4,80(sp)
    80005d78:	e4d6                	sd	s5,72(sp)
    80005d7a:	e0da                	sd	s6,64(sp)
    80005d7c:	fc5e                	sd	s7,56(sp)
    80005d7e:	f862                	sd	s8,48(sp)
    80005d80:	f466                	sd	s9,40(sp)
    80005d82:	f06a                	sd	s10,32(sp)
    80005d84:	ec6e                	sd	s11,24(sp)
    80005d86:	0100                	addi	s0,sp,128
    80005d88:	8a2a                	mv	s4,a0
    80005d8a:	e40c                	sd	a1,8(s0)
    80005d8c:	e810                	sd	a2,16(s0)
    80005d8e:	ec14                	sd	a3,24(s0)
    80005d90:	f018                	sd	a4,32(s0)
    80005d92:	f41c                	sd	a5,40(s0)
    80005d94:	03043823          	sd	a6,48(s0)
    80005d98:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d9c:	00020d97          	auipc	s11,0x20
    80005da0:	464dad83          	lw	s11,1124(s11) # 80026200 <pr+0x18>
  if(locking)
    80005da4:	020d9b63          	bnez	s11,80005dda <printf+0x70>
  if (fmt == 0)
    80005da8:	040a0263          	beqz	s4,80005dec <printf+0x82>
  va_start(ap, fmt);
    80005dac:	00840793          	addi	a5,s0,8
    80005db0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005db4:	000a4503          	lbu	a0,0(s4)
    80005db8:	16050263          	beqz	a0,80005f1c <printf+0x1b2>
    80005dbc:	4481                	li	s1,0
    if(c != '%'){
    80005dbe:	02500a93          	li	s5,37
    switch(c){
    80005dc2:	07000b13          	li	s6,112
  consputc('x');
    80005dc6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc8:	00003b97          	auipc	s7,0x3
    80005dcc:	a20b8b93          	addi	s7,s7,-1504 # 800087e8 <digits>
    switch(c){
    80005dd0:	07300c93          	li	s9,115
    80005dd4:	06400c13          	li	s8,100
    80005dd8:	a82d                	j	80005e12 <printf+0xa8>
    acquire(&pr.lock);
    80005dda:	00020517          	auipc	a0,0x20
    80005dde:	40e50513          	addi	a0,a0,1038 # 800261e8 <pr>
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	456080e7          	jalr	1110(ra) # 80006238 <acquire>
    80005dea:	bf7d                	j	80005da8 <printf+0x3e>
    panic("null fmt");
    80005dec:	00003517          	auipc	a0,0x3
    80005df0:	9ec50513          	addi	a0,a0,-1556 # 800087d8 <syscalls+0x410>
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	f24080e7          	jalr	-220(ra) # 80005d18 <panic>
      consputc(c);
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	bba080e7          	jalr	-1094(ra) # 800059b6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e04:	2485                	addiw	s1,s1,1
    80005e06:	009a07b3          	add	a5,s4,s1
    80005e0a:	0007c503          	lbu	a0,0(a5)
    80005e0e:	10050763          	beqz	a0,80005f1c <printf+0x1b2>
    if(c != '%'){
    80005e12:	ff5515e3          	bne	a0,s5,80005dfc <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e16:	2485                	addiw	s1,s1,1
    80005e18:	009a07b3          	add	a5,s4,s1
    80005e1c:	0007c783          	lbu	a5,0(a5)
    80005e20:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e24:	cfe5                	beqz	a5,80005f1c <printf+0x1b2>
    switch(c){
    80005e26:	05678a63          	beq	a5,s6,80005e7a <printf+0x110>
    80005e2a:	02fb7663          	bgeu	s6,a5,80005e56 <printf+0xec>
    80005e2e:	09978963          	beq	a5,s9,80005ec0 <printf+0x156>
    80005e32:	07800713          	li	a4,120
    80005e36:	0ce79863          	bne	a5,a4,80005f06 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e3a:	f8843783          	ld	a5,-120(s0)
    80005e3e:	00878713          	addi	a4,a5,8
    80005e42:	f8e43423          	sd	a4,-120(s0)
    80005e46:	4605                	li	a2,1
    80005e48:	85ea                	mv	a1,s10
    80005e4a:	4388                	lw	a0,0(a5)
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	d8a080e7          	jalr	-630(ra) # 80005bd6 <printint>
      break;
    80005e54:	bf45                	j	80005e04 <printf+0x9a>
    switch(c){
    80005e56:	0b578263          	beq	a5,s5,80005efa <printf+0x190>
    80005e5a:	0b879663          	bne	a5,s8,80005f06 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e5e:	f8843783          	ld	a5,-120(s0)
    80005e62:	00878713          	addi	a4,a5,8
    80005e66:	f8e43423          	sd	a4,-120(s0)
    80005e6a:	4605                	li	a2,1
    80005e6c:	45a9                	li	a1,10
    80005e6e:	4388                	lw	a0,0(a5)
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	d66080e7          	jalr	-666(ra) # 80005bd6 <printint>
      break;
    80005e78:	b771                	j	80005e04 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e7a:	f8843783          	ld	a5,-120(s0)
    80005e7e:	00878713          	addi	a4,a5,8
    80005e82:	f8e43423          	sd	a4,-120(s0)
    80005e86:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e8a:	03000513          	li	a0,48
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	b28080e7          	jalr	-1240(ra) # 800059b6 <consputc>
  consputc('x');
    80005e96:	07800513          	li	a0,120
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	b1c080e7          	jalr	-1252(ra) # 800059b6 <consputc>
    80005ea2:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea4:	03c9d793          	srli	a5,s3,0x3c
    80005ea8:	97de                	add	a5,a5,s7
    80005eaa:	0007c503          	lbu	a0,0(a5)
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	b08080e7          	jalr	-1272(ra) # 800059b6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eb6:	0992                	slli	s3,s3,0x4
    80005eb8:	397d                	addiw	s2,s2,-1
    80005eba:	fe0915e3          	bnez	s2,80005ea4 <printf+0x13a>
    80005ebe:	b799                	j	80005e04 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ec0:	f8843783          	ld	a5,-120(s0)
    80005ec4:	00878713          	addi	a4,a5,8
    80005ec8:	f8e43423          	sd	a4,-120(s0)
    80005ecc:	0007b903          	ld	s2,0(a5)
    80005ed0:	00090e63          	beqz	s2,80005eec <printf+0x182>
      for(; *s; s++)
    80005ed4:	00094503          	lbu	a0,0(s2) # 1000 <_entry-0x7ffff000>
    80005ed8:	d515                	beqz	a0,80005e04 <printf+0x9a>
        consputc(*s);
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	adc080e7          	jalr	-1316(ra) # 800059b6 <consputc>
      for(; *s; s++)
    80005ee2:	0905                	addi	s2,s2,1
    80005ee4:	00094503          	lbu	a0,0(s2)
    80005ee8:	f96d                	bnez	a0,80005eda <printf+0x170>
    80005eea:	bf29                	j	80005e04 <printf+0x9a>
        s = "(null)";
    80005eec:	00003917          	auipc	s2,0x3
    80005ef0:	8e490913          	addi	s2,s2,-1820 # 800087d0 <syscalls+0x408>
      for(; *s; s++)
    80005ef4:	02800513          	li	a0,40
    80005ef8:	b7cd                	j	80005eda <printf+0x170>
      consputc('%');
    80005efa:	8556                	mv	a0,s5
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	aba080e7          	jalr	-1350(ra) # 800059b6 <consputc>
      break;
    80005f04:	b701                	j	80005e04 <printf+0x9a>
      consputc('%');
    80005f06:	8556                	mv	a0,s5
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	aae080e7          	jalr	-1362(ra) # 800059b6 <consputc>
      consputc(c);
    80005f10:	854a                	mv	a0,s2
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	aa4080e7          	jalr	-1372(ra) # 800059b6 <consputc>
      break;
    80005f1a:	b5ed                	j	80005e04 <printf+0x9a>
  if(locking)
    80005f1c:	020d9163          	bnez	s11,80005f3e <printf+0x1d4>
}
    80005f20:	70e6                	ld	ra,120(sp)
    80005f22:	7446                	ld	s0,112(sp)
    80005f24:	74a6                	ld	s1,104(sp)
    80005f26:	7906                	ld	s2,96(sp)
    80005f28:	69e6                	ld	s3,88(sp)
    80005f2a:	6a46                	ld	s4,80(sp)
    80005f2c:	6aa6                	ld	s5,72(sp)
    80005f2e:	6b06                	ld	s6,64(sp)
    80005f30:	7be2                	ld	s7,56(sp)
    80005f32:	7c42                	ld	s8,48(sp)
    80005f34:	7ca2                	ld	s9,40(sp)
    80005f36:	7d02                	ld	s10,32(sp)
    80005f38:	6de2                	ld	s11,24(sp)
    80005f3a:	6129                	addi	sp,sp,192
    80005f3c:	8082                	ret
    release(&pr.lock);
    80005f3e:	00020517          	auipc	a0,0x20
    80005f42:	2aa50513          	addi	a0,a0,682 # 800261e8 <pr>
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	3a6080e7          	jalr	934(ra) # 800062ec <release>
}
    80005f4e:	bfc9                	j	80005f20 <printf+0x1b6>

0000000080005f50 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f50:	1141                	addi	sp,sp,-16
    80005f52:	e406                	sd	ra,8(sp)
    80005f54:	e022                	sd	s0,0(sp)
    80005f56:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f58:	100007b7          	lui	a5,0x10000
    80005f5c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f60:	f8000713          	li	a4,-128
    80005f64:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f68:	470d                	li	a4,3
    80005f6a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f6e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f72:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f76:	469d                	li	a3,7
    80005f78:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f7c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f80:	00003597          	auipc	a1,0x3
    80005f84:	88058593          	addi	a1,a1,-1920 # 80008800 <digits+0x18>
    80005f88:	00020517          	auipc	a0,0x20
    80005f8c:	28050513          	addi	a0,a0,640 # 80026208 <uart_tx_lock>
    80005f90:	00000097          	auipc	ra,0x0
    80005f94:	218080e7          	jalr	536(ra) # 800061a8 <initlock>
}
    80005f98:	60a2                	ld	ra,8(sp)
    80005f9a:	6402                	ld	s0,0(sp)
    80005f9c:	0141                	addi	sp,sp,16
    80005f9e:	8082                	ret

0000000080005fa0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fa0:	1101                	addi	sp,sp,-32
    80005fa2:	ec06                	sd	ra,24(sp)
    80005fa4:	e822                	sd	s0,16(sp)
    80005fa6:	e426                	sd	s1,8(sp)
    80005fa8:	1000                	addi	s0,sp,32
    80005faa:	84aa                	mv	s1,a0
  push_off();
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	240080e7          	jalr	576(ra) # 800061ec <push_off>

  if(panicked){
    80005fb4:	00003797          	auipc	a5,0x3
    80005fb8:	0687a783          	lw	a5,104(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fbc:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fc0:	c391                	beqz	a5,80005fc4 <uartputc_sync+0x24>
    for(;;)
    80005fc2:	a001                	j	80005fc2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fc8:	0ff7f793          	andi	a5,a5,255
    80005fcc:	0207f793          	andi	a5,a5,32
    80005fd0:	dbf5                	beqz	a5,80005fc4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fd2:	0ff4f793          	andi	a5,s1,255
    80005fd6:	10000737          	lui	a4,0x10000
    80005fda:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	2ae080e7          	jalr	686(ra) # 8000628c <pop_off>
}
    80005fe6:	60e2                	ld	ra,24(sp)
    80005fe8:	6442                	ld	s0,16(sp)
    80005fea:	64a2                	ld	s1,8(sp)
    80005fec:	6105                	addi	sp,sp,32
    80005fee:	8082                	ret

0000000080005ff0 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ff0:	00003717          	auipc	a4,0x3
    80005ff4:	03073703          	ld	a4,48(a4) # 80009020 <uart_tx_r>
    80005ff8:	00003797          	auipc	a5,0x3
    80005ffc:	0307b783          	ld	a5,48(a5) # 80009028 <uart_tx_w>
    80006000:	06e78c63          	beq	a5,a4,80006078 <uartstart+0x88>
{
    80006004:	7139                	addi	sp,sp,-64
    80006006:	fc06                	sd	ra,56(sp)
    80006008:	f822                	sd	s0,48(sp)
    8000600a:	f426                	sd	s1,40(sp)
    8000600c:	f04a                	sd	s2,32(sp)
    8000600e:	ec4e                	sd	s3,24(sp)
    80006010:	e852                	sd	s4,16(sp)
    80006012:	e456                	sd	s5,8(sp)
    80006014:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006016:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000601a:	00020a17          	auipc	s4,0x20
    8000601e:	1eea0a13          	addi	s4,s4,494 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006022:	00003497          	auipc	s1,0x3
    80006026:	ffe48493          	addi	s1,s1,-2 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000602a:	00003997          	auipc	s3,0x3
    8000602e:	ffe98993          	addi	s3,s3,-2 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006032:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006036:	0ff7f793          	andi	a5,a5,255
    8000603a:	0207f793          	andi	a5,a5,32
    8000603e:	c785                	beqz	a5,80006066 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006040:	01f77793          	andi	a5,a4,31
    80006044:	97d2                	add	a5,a5,s4
    80006046:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000604a:	0705                	addi	a4,a4,1
    8000604c:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000604e:	8526                	mv	a0,s1
    80006050:	ffffb097          	auipc	ra,0xffffb
    80006054:	690080e7          	jalr	1680(ra) # 800016e0 <wakeup>
    
    WriteReg(THR, c);
    80006058:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000605c:	6098                	ld	a4,0(s1)
    8000605e:	0009b783          	ld	a5,0(s3)
    80006062:	fce798e3          	bne	a5,a4,80006032 <uartstart+0x42>
  }
}
    80006066:	70e2                	ld	ra,56(sp)
    80006068:	7442                	ld	s0,48(sp)
    8000606a:	74a2                	ld	s1,40(sp)
    8000606c:	7902                	ld	s2,32(sp)
    8000606e:	69e2                	ld	s3,24(sp)
    80006070:	6a42                	ld	s4,16(sp)
    80006072:	6aa2                	ld	s5,8(sp)
    80006074:	6121                	addi	sp,sp,64
    80006076:	8082                	ret
    80006078:	8082                	ret

000000008000607a <uartputc>:
{
    8000607a:	7179                	addi	sp,sp,-48
    8000607c:	f406                	sd	ra,40(sp)
    8000607e:	f022                	sd	s0,32(sp)
    80006080:	ec26                	sd	s1,24(sp)
    80006082:	e84a                	sd	s2,16(sp)
    80006084:	e44e                	sd	s3,8(sp)
    80006086:	e052                	sd	s4,0(sp)
    80006088:	1800                	addi	s0,sp,48
    8000608a:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000608c:	00020517          	auipc	a0,0x20
    80006090:	17c50513          	addi	a0,a0,380 # 80026208 <uart_tx_lock>
    80006094:	00000097          	auipc	ra,0x0
    80006098:	1a4080e7          	jalr	420(ra) # 80006238 <acquire>
  if(panicked){
    8000609c:	00003797          	auipc	a5,0x3
    800060a0:	f807a783          	lw	a5,-128(a5) # 8000901c <panicked>
    800060a4:	c391                	beqz	a5,800060a8 <uartputc+0x2e>
    for(;;)
    800060a6:	a001                	j	800060a6 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060a8:	00003797          	auipc	a5,0x3
    800060ac:	f807b783          	ld	a5,-128(a5) # 80009028 <uart_tx_w>
    800060b0:	00003717          	auipc	a4,0x3
    800060b4:	f7073703          	ld	a4,-144(a4) # 80009020 <uart_tx_r>
    800060b8:	02070713          	addi	a4,a4,32
    800060bc:	02f71b63          	bne	a4,a5,800060f2 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060c0:	00020a17          	auipc	s4,0x20
    800060c4:	148a0a13          	addi	s4,s4,328 # 80026208 <uart_tx_lock>
    800060c8:	00003497          	auipc	s1,0x3
    800060cc:	f5848493          	addi	s1,s1,-168 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d0:	00003917          	auipc	s2,0x3
    800060d4:	f5890913          	addi	s2,s2,-168 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060d8:	85d2                	mv	a1,s4
    800060da:	8526                	mv	a0,s1
    800060dc:	ffffb097          	auipc	ra,0xffffb
    800060e0:	478080e7          	jalr	1144(ra) # 80001554 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060e4:	00093783          	ld	a5,0(s2)
    800060e8:	6098                	ld	a4,0(s1)
    800060ea:	02070713          	addi	a4,a4,32
    800060ee:	fef705e3          	beq	a4,a5,800060d8 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060f2:	00020497          	auipc	s1,0x20
    800060f6:	11648493          	addi	s1,s1,278 # 80026208 <uart_tx_lock>
    800060fa:	01f7f713          	andi	a4,a5,31
    800060fe:	9726                	add	a4,a4,s1
    80006100:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80006104:	0785                	addi	a5,a5,1
    80006106:	00003717          	auipc	a4,0x3
    8000610a:	f2f73123          	sd	a5,-222(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	ee2080e7          	jalr	-286(ra) # 80005ff0 <uartstart>
      release(&uart_tx_lock);
    80006116:	8526                	mv	a0,s1
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	1d4080e7          	jalr	468(ra) # 800062ec <release>
}
    80006120:	70a2                	ld	ra,40(sp)
    80006122:	7402                	ld	s0,32(sp)
    80006124:	64e2                	ld	s1,24(sp)
    80006126:	6942                	ld	s2,16(sp)
    80006128:	69a2                	ld	s3,8(sp)
    8000612a:	6a02                	ld	s4,0(sp)
    8000612c:	6145                	addi	sp,sp,48
    8000612e:	8082                	ret

0000000080006130 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006130:	1141                	addi	sp,sp,-16
    80006132:	e422                	sd	s0,8(sp)
    80006134:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006136:	100007b7          	lui	a5,0x10000
    8000613a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000613e:	8b85                	andi	a5,a5,1
    80006140:	cb91                	beqz	a5,80006154 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006142:	100007b7          	lui	a5,0x10000
    80006146:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000614a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000614e:	6422                	ld	s0,8(sp)
    80006150:	0141                	addi	sp,sp,16
    80006152:	8082                	ret
    return -1;
    80006154:	557d                	li	a0,-1
    80006156:	bfe5                	j	8000614e <uartgetc+0x1e>

0000000080006158 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006158:	1101                	addi	sp,sp,-32
    8000615a:	ec06                	sd	ra,24(sp)
    8000615c:	e822                	sd	s0,16(sp)
    8000615e:	e426                	sd	s1,8(sp)
    80006160:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006162:	54fd                	li	s1,-1
    int c = uartgetc();
    80006164:	00000097          	auipc	ra,0x0
    80006168:	fcc080e7          	jalr	-52(ra) # 80006130 <uartgetc>
    if(c == -1)
    8000616c:	00950763          	beq	a0,s1,8000617a <uartintr+0x22>
      break;
    consoleintr(c);
    80006170:	00000097          	auipc	ra,0x0
    80006174:	888080e7          	jalr	-1912(ra) # 800059f8 <consoleintr>
  while(1){
    80006178:	b7f5                	j	80006164 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000617a:	00020497          	auipc	s1,0x20
    8000617e:	08e48493          	addi	s1,s1,142 # 80026208 <uart_tx_lock>
    80006182:	8526                	mv	a0,s1
    80006184:	00000097          	auipc	ra,0x0
    80006188:	0b4080e7          	jalr	180(ra) # 80006238 <acquire>
  uartstart();
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	e64080e7          	jalr	-412(ra) # 80005ff0 <uartstart>
  release(&uart_tx_lock);
    80006194:	8526                	mv	a0,s1
    80006196:	00000097          	auipc	ra,0x0
    8000619a:	156080e7          	jalr	342(ra) # 800062ec <release>
}
    8000619e:	60e2                	ld	ra,24(sp)
    800061a0:	6442                	ld	s0,16(sp)
    800061a2:	64a2                	ld	s1,8(sp)
    800061a4:	6105                	addi	sp,sp,32
    800061a6:	8082                	ret

00000000800061a8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061a8:	1141                	addi	sp,sp,-16
    800061aa:	e422                	sd	s0,8(sp)
    800061ac:	0800                	addi	s0,sp,16
  lk->name = name;
    800061ae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061b0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061b4:	00053823          	sd	zero,16(a0)
}
    800061b8:	6422                	ld	s0,8(sp)
    800061ba:	0141                	addi	sp,sp,16
    800061bc:	8082                	ret

00000000800061be <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061be:	411c                	lw	a5,0(a0)
    800061c0:	e399                	bnez	a5,800061c6 <holding+0x8>
    800061c2:	4501                	li	a0,0
  return r;
}
    800061c4:	8082                	ret
{
    800061c6:	1101                	addi	sp,sp,-32
    800061c8:	ec06                	sd	ra,24(sp)
    800061ca:	e822                	sd	s0,16(sp)
    800061cc:	e426                	sd	s1,8(sp)
    800061ce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061d0:	6904                	ld	s1,16(a0)
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	c5a080e7          	jalr	-934(ra) # 80000e2c <mycpu>
    800061da:	40a48533          	sub	a0,s1,a0
    800061de:	00153513          	seqz	a0,a0
}
    800061e2:	60e2                	ld	ra,24(sp)
    800061e4:	6442                	ld	s0,16(sp)
    800061e6:	64a2                	ld	s1,8(sp)
    800061e8:	6105                	addi	sp,sp,32
    800061ea:	8082                	ret

00000000800061ec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061f6:	100024f3          	csrr	s1,sstatus
    800061fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061fe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006200:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	c28080e7          	jalr	-984(ra) # 80000e2c <mycpu>
    8000620c:	5d3c                	lw	a5,120(a0)
    8000620e:	cf89                	beqz	a5,80006228 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006210:	ffffb097          	auipc	ra,0xffffb
    80006214:	c1c080e7          	jalr	-996(ra) # 80000e2c <mycpu>
    80006218:	5d3c                	lw	a5,120(a0)
    8000621a:	2785                	addiw	a5,a5,1
    8000621c:	dd3c                	sw	a5,120(a0)
}
    8000621e:	60e2                	ld	ra,24(sp)
    80006220:	6442                	ld	s0,16(sp)
    80006222:	64a2                	ld	s1,8(sp)
    80006224:	6105                	addi	sp,sp,32
    80006226:	8082                	ret
    mycpu()->intena = old;
    80006228:	ffffb097          	auipc	ra,0xffffb
    8000622c:	c04080e7          	jalr	-1020(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006230:	8085                	srli	s1,s1,0x1
    80006232:	8885                	andi	s1,s1,1
    80006234:	dd64                	sw	s1,124(a0)
    80006236:	bfe9                	j	80006210 <push_off+0x24>

0000000080006238 <acquire>:
{
    80006238:	1101                	addi	sp,sp,-32
    8000623a:	ec06                	sd	ra,24(sp)
    8000623c:	e822                	sd	s0,16(sp)
    8000623e:	e426                	sd	s1,8(sp)
    80006240:	1000                	addi	s0,sp,32
    80006242:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006244:	00000097          	auipc	ra,0x0
    80006248:	fa8080e7          	jalr	-88(ra) # 800061ec <push_off>
  if(holding(lk))
    8000624c:	8526                	mv	a0,s1
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	f70080e7          	jalr	-144(ra) # 800061be <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006256:	4705                	li	a4,1
  if(holding(lk))
    80006258:	e115                	bnez	a0,8000627c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000625a:	87ba                	mv	a5,a4
    8000625c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006260:	2781                	sext.w	a5,a5
    80006262:	ffe5                	bnez	a5,8000625a <acquire+0x22>
  __sync_synchronize();
    80006264:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006268:	ffffb097          	auipc	ra,0xffffb
    8000626c:	bc4080e7          	jalr	-1084(ra) # 80000e2c <mycpu>
    80006270:	e888                	sd	a0,16(s1)
}
    80006272:	60e2                	ld	ra,24(sp)
    80006274:	6442                	ld	s0,16(sp)
    80006276:	64a2                	ld	s1,8(sp)
    80006278:	6105                	addi	sp,sp,32
    8000627a:	8082                	ret
    panic("acquire");
    8000627c:	00002517          	auipc	a0,0x2
    80006280:	58c50513          	addi	a0,a0,1420 # 80008808 <digits+0x20>
    80006284:	00000097          	auipc	ra,0x0
    80006288:	a94080e7          	jalr	-1388(ra) # 80005d18 <panic>

000000008000628c <pop_off>:

void
pop_off(void)
{
    8000628c:	1141                	addi	sp,sp,-16
    8000628e:	e406                	sd	ra,8(sp)
    80006290:	e022                	sd	s0,0(sp)
    80006292:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006294:	ffffb097          	auipc	ra,0xffffb
    80006298:	b98080e7          	jalr	-1128(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000629c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062a0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062a2:	e78d                	bnez	a5,800062cc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062a4:	5d3c                	lw	a5,120(a0)
    800062a6:	02f05b63          	blez	a5,800062dc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062aa:	37fd                	addiw	a5,a5,-1
    800062ac:	0007871b          	sext.w	a4,a5
    800062b0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062b2:	eb09                	bnez	a4,800062c4 <pop_off+0x38>
    800062b4:	5d7c                	lw	a5,124(a0)
    800062b6:	c799                	beqz	a5,800062c4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062c0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062c4:	60a2                	ld	ra,8(sp)
    800062c6:	6402                	ld	s0,0(sp)
    800062c8:	0141                	addi	sp,sp,16
    800062ca:	8082                	ret
    panic("pop_off - interruptible");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	54450513          	addi	a0,a0,1348 # 80008810 <digits+0x28>
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	a44080e7          	jalr	-1468(ra) # 80005d18 <panic>
    panic("pop_off");
    800062dc:	00002517          	auipc	a0,0x2
    800062e0:	54c50513          	addi	a0,a0,1356 # 80008828 <digits+0x40>
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	a34080e7          	jalr	-1484(ra) # 80005d18 <panic>

00000000800062ec <release>:
{
    800062ec:	1101                	addi	sp,sp,-32
    800062ee:	ec06                	sd	ra,24(sp)
    800062f0:	e822                	sd	s0,16(sp)
    800062f2:	e426                	sd	s1,8(sp)
    800062f4:	1000                	addi	s0,sp,32
    800062f6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	ec6080e7          	jalr	-314(ra) # 800061be <holding>
    80006300:	c115                	beqz	a0,80006324 <release+0x38>
  lk->cpu = 0;
    80006302:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006306:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000630a:	0f50000f          	fence	iorw,ow
    8000630e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	f7a080e7          	jalr	-134(ra) # 8000628c <pop_off>
}
    8000631a:	60e2                	ld	ra,24(sp)
    8000631c:	6442                	ld	s0,16(sp)
    8000631e:	64a2                	ld	s1,8(sp)
    80006320:	6105                	addi	sp,sp,32
    80006322:	8082                	ret
    panic("release");
    80006324:	00002517          	auipc	a0,0x2
    80006328:	50c50513          	addi	a0,a0,1292 # 80008830 <digits+0x48>
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	9ec080e7          	jalr	-1556(ra) # 80005d18 <panic>
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
