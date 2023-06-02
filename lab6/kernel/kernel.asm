
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
    80000016:	1d3050ef          	jal	ra,800059e8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <pagecnt>:
} kmem;


int
pagecnt(void *pa_start, void *pa_end)
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
  char *p;
  int cnt = 0;
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000022:	6705                	lui	a4,0x1
    80000024:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80000028:	97aa                	add	a5,a5,a0
    8000002a:	76fd                	lui	a3,0xfffff
    8000002c:	8efd                	and	a3,a3,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000002e:	9736                	add	a4,a4,a3
    80000030:	02e5e963          	bltu	a1,a4,80000062 <pagecnt+0x46>
    80000034:	87ba                	mv	a5,a4
    80000036:	6705                	lui	a4,0x1
    80000038:	97ba                	add	a5,a5,a4
    8000003a:	fef5ffe3          	bgeu	a1,a5,80000038 <pagecnt+0x1c>
    8000003e:	6705                	lui	a4,0x1
    80000040:	0705                	addi	a4,a4,1
    80000042:	9736                	add	a4,a4,a3
    80000044:	00158613          	addi	a2,a1,1
    80000048:	4785                	li	a5,1
    8000004a:	00e66763          	bltu	a2,a4,80000058 <pagecnt+0x3c>
    8000004e:	77fd                	lui	a5,0xfffff
    80000050:	97ae                	add	a5,a5,a1
    80000052:	8f95                	sub	a5,a5,a3
    80000054:	83b1                	srli	a5,a5,0xc
    80000056:	2785                	addiw	a5,a5,1
    80000058:	0007851b          	sext.w	a0,a5
    cnt++;
  return cnt;
}
    8000005c:	6422                	ld	s0,8(sp)
    8000005e:	0141                	addi	sp,sp,16
    80000060:	8082                	ret
  int cnt = 0;
    80000062:	4501                	li	a0,0
    80000064:	bfe5                	j	8000005c <pagecnt+0x40>

0000000080000066 <page_index>:
  freerange(kmem.end, (void*)PHYSTOP);
}

int page_index(uint64 pa)
{
  pa = PGROUNDDOWN(pa);
    80000066:	77fd                	lui	a5,0xfffff
    80000068:	8fe9                	and	a5,a5,a0
  int res = (pa - (uint64) end) / PGSIZE;
    8000006a:	00026517          	auipc	a0,0x26
    8000006e:	1d650513          	addi	a0,a0,470 # 80026240 <end>
    80000072:	8f89                	sub	a5,a5,a0
    80000074:	83b1                	srli	a5,a5,0xc
  if(res < 0 || res >= kmem.page_cnt)
    80000076:	02079713          	slli	a4,a5,0x20
    8000007a:	00074b63          	bltz	a4,80000090 <page_index+0x2a>
    8000007e:	0007851b          	sext.w	a0,a5
    80000082:	00009797          	auipc	a5,0x9
    80000086:	fd67a783          	lw	a5,-42(a5) # 80009058 <kmem+0x28>
    8000008a:	00f55363          	bge	a0,a5,80000090 <page_index+0x2a>
  {
    panic("page_index illegal");
  }
  return res;
}
    8000008e:	8082                	ret
{
    80000090:	1141                	addi	sp,sp,-16
    80000092:	e406                	sd	ra,8(sp)
    80000094:	e022                	sd	s0,0(sp)
    80000096:	0800                	addi	s0,sp,16
    panic("page_index illegal");
    80000098:	00008517          	auipc	a0,0x8
    8000009c:	f7850513          	addi	a0,a0,-136 # 80008010 <etext+0x10>
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	df8080e7          	jalr	-520(ra) # 80005e98 <panic>

00000000800000a8 <incr>:

void incr(void *pa)
{
    800000a8:	1101                	addi	sp,sp,-32
    800000aa:	ec06                	sd	ra,24(sp)
    800000ac:	e822                	sd	s0,16(sp)
    800000ae:	e426                	sd	s1,8(sp)
    800000b0:	e04a                	sd	s2,0(sp)
    800000b2:	1000                	addi	s0,sp,32
  int index = page_index((uint64)pa);
    800000b4:	00000097          	auipc	ra,0x0
    800000b8:	fb2080e7          	jalr	-78(ra) # 80000066 <page_index>
    800000bc:	892a                	mv	s2,a0
  acquire(&kmem.lock);
    800000be:	00009497          	auipc	s1,0x9
    800000c2:	f7248493          	addi	s1,s1,-142 # 80009030 <kmem>
    800000c6:	8526                	mv	a0,s1
    800000c8:	00006097          	auipc	ra,0x6
    800000cc:	31a080e7          	jalr	794(ra) # 800063e2 <acquire>
  kmem.ref_page[index]++;
    800000d0:	709c                	ld	a5,32(s1)
    800000d2:	01278533          	add	a0,a5,s2
    800000d6:	00054783          	lbu	a5,0(a0)
    800000da:	2785                	addiw	a5,a5,1
    800000dc:	00f50023          	sb	a5,0(a0)
  release(&kmem.lock);
    800000e0:	8526                	mv	a0,s1
    800000e2:	00006097          	auipc	ra,0x6
    800000e6:	3b4080e7          	jalr	948(ra) # 80006496 <release>
}
    800000ea:	60e2                	ld	ra,24(sp)
    800000ec:	6442                	ld	s0,16(sp)
    800000ee:	64a2                	ld	s1,8(sp)
    800000f0:	6902                	ld	s2,0(sp)
    800000f2:	6105                	addi	sp,sp,32
    800000f4:	8082                	ret

00000000800000f6 <desc>:

void desc(void *pa)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	e04a                	sd	s2,0(sp)
    80000100:	1000                	addi	s0,sp,32
  int index = page_index((uint64)pa);
    80000102:	00000097          	auipc	ra,0x0
    80000106:	f64080e7          	jalr	-156(ra) # 80000066 <page_index>
    8000010a:	892a                	mv	s2,a0
  acquire(&kmem.lock);
    8000010c:	00009497          	auipc	s1,0x9
    80000110:	f2448493          	addi	s1,s1,-220 # 80009030 <kmem>
    80000114:	8526                	mv	a0,s1
    80000116:	00006097          	auipc	ra,0x6
    8000011a:	2cc080e7          	jalr	716(ra) # 800063e2 <acquire>
  kmem.ref_page[index]--;
    8000011e:	709c                	ld	a5,32(s1)
    80000120:	01278533          	add	a0,a5,s2
    80000124:	00054783          	lbu	a5,0(a0)
    80000128:	37fd                	addiw	a5,a5,-1
    8000012a:	00f50023          	sb	a5,0(a0)
  release(&kmem.lock);
    8000012e:	8526                	mv	a0,s1
    80000130:	00006097          	auipc	ra,0x6
    80000134:	366080e7          	jalr	870(ra) # 80006496 <release>
}
    80000138:	60e2                	ld	ra,24(sp)
    8000013a:	6442                	ld	s0,16(sp)
    8000013c:	64a2                	ld	s1,8(sp)
    8000013e:	6902                	ld	s2,0(sp)
    80000140:	6105                	addi	sp,sp,32
    80000142:	8082                	ret

0000000080000144 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000144:	1101                	addi	sp,sp,-32
    80000146:	ec06                	sd	ra,24(sp)
    80000148:	e822                	sd	s0,16(sp)
    8000014a:	e426                	sd	s1,8(sp)
    8000014c:	e04a                	sd	s2,0(sp)
    8000014e:	1000                	addi	s0,sp,32
    80000150:	84aa                	mv	s1,a0
  int index = page_index((uint64)pa);
    80000152:	892a                	mv	s2,a0
    80000154:	00000097          	auipc	ra,0x0
    80000158:	f12080e7          	jalr	-238(ra) # 80000066 <page_index>
  if(kmem.ref_page[index] > 1)
    8000015c:	00009797          	auipc	a5,0x9
    80000160:	ef47b783          	ld	a5,-268(a5) # 80009050 <kmem+0x20>
    80000164:	97aa                	add	a5,a5,a0
    80000166:	0007c783          	lbu	a5,0(a5)
    8000016a:	4705                	li	a4,1
    8000016c:	06f76263          	bltu	a4,a5,800001d0 <kfree+0x8c>
  {
    desc(pa);
    return ;
  }
  if(kmem.ref_page[index] == 1)
    80000170:	4705                	li	a4,1
    80000172:	06e78563          	beq	a5,a4,800001dc <kfree+0x98>
  {
    desc(pa);
  }
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000176:	03449793          	slli	a5,s1,0x34
    8000017a:	e7bd                	bnez	a5,800001e8 <kfree+0xa4>
    8000017c:	00026797          	auipc	a5,0x26
    80000180:	0c478793          	addi	a5,a5,196 # 80026240 <end>
    80000184:	06f4e263          	bltu	s1,a5,800001e8 <kfree+0xa4>
    80000188:	47c5                	li	a5,17
    8000018a:	07ee                	slli	a5,a5,0x1b
    8000018c:	04f97e63          	bgeu	s2,a5,800001e8 <kfree+0xa4>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000190:	6605                	lui	a2,0x1
    80000192:	4585                	li	a1,1
    80000194:	8526                	mv	a0,s1
    80000196:	00000097          	auipc	ra,0x0
    8000019a:	1de080e7          	jalr	478(ra) # 80000374 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000019e:	00009917          	auipc	s2,0x9
    800001a2:	e9290913          	addi	s2,s2,-366 # 80009030 <kmem>
    800001a6:	854a                	mv	a0,s2
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	23a080e7          	jalr	570(ra) # 800063e2 <acquire>
  r->next = kmem.freelist;
    800001b0:	01893783          	ld	a5,24(s2)
    800001b4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800001b6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800001ba:	854a                	mv	a0,s2
    800001bc:	00006097          	auipc	ra,0x6
    800001c0:	2da080e7          	jalr	730(ra) # 80006496 <release>
}
    800001c4:	60e2                	ld	ra,24(sp)
    800001c6:	6442                	ld	s0,16(sp)
    800001c8:	64a2                	ld	s1,8(sp)
    800001ca:	6902                	ld	s2,0(sp)
    800001cc:	6105                	addi	sp,sp,32
    800001ce:	8082                	ret
    desc(pa);
    800001d0:	8526                	mv	a0,s1
    800001d2:	00000097          	auipc	ra,0x0
    800001d6:	f24080e7          	jalr	-220(ra) # 800000f6 <desc>
    return ;
    800001da:	b7ed                	j	800001c4 <kfree+0x80>
    desc(pa);
    800001dc:	8526                	mv	a0,s1
    800001de:	00000097          	auipc	ra,0x0
    800001e2:	f18080e7          	jalr	-232(ra) # 800000f6 <desc>
    800001e6:	bf41                	j	80000176 <kfree+0x32>
    panic("kfree");
    800001e8:	00008517          	auipc	a0,0x8
    800001ec:	e4050513          	addi	a0,a0,-448 # 80008028 <etext+0x28>
    800001f0:	00006097          	auipc	ra,0x6
    800001f4:	ca8080e7          	jalr	-856(ra) # 80005e98 <panic>

00000000800001f8 <freerange>:
{
    800001f8:	7179                	addi	sp,sp,-48
    800001fa:	f406                	sd	ra,40(sp)
    800001fc:	f022                	sd	s0,32(sp)
    800001fe:	ec26                	sd	s1,24(sp)
    80000200:	e84a                	sd	s2,16(sp)
    80000202:	e44e                	sd	s3,8(sp)
    80000204:	e052                	sd	s4,0(sp)
    80000206:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000208:	6785                	lui	a5,0x1
    8000020a:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000020e:	94aa                	add	s1,s1,a0
    80000210:	757d                	lui	a0,0xfffff
    80000212:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000214:	94be                	add	s1,s1,a5
    80000216:	0095ee63          	bltu	a1,s1,80000232 <freerange+0x3a>
    8000021a:	892e                	mv	s2,a1
    kfree(p);
    8000021c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000021e:	6985                	lui	s3,0x1
    kfree(p);
    80000220:	01448533          	add	a0,s1,s4
    80000224:	00000097          	auipc	ra,0x0
    80000228:	f20080e7          	jalr	-224(ra) # 80000144 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000022c:	94ce                	add	s1,s1,s3
    8000022e:	fe9979e3          	bgeu	s2,s1,80000220 <freerange+0x28>
}
    80000232:	70a2                	ld	ra,40(sp)
    80000234:	7402                	ld	s0,32(sp)
    80000236:	64e2                	ld	s1,24(sp)
    80000238:	6942                	ld	s2,16(sp)
    8000023a:	69a2                	ld	s3,8(sp)
    8000023c:	6a02                	ld	s4,0(sp)
    8000023e:	6145                	addi	sp,sp,48
    80000240:	8082                	ret

0000000080000242 <kinit>:
{
    80000242:	1141                	addi	sp,sp,-16
    80000244:	e406                	sd	ra,8(sp)
    80000246:	e022                	sd	s0,0(sp)
    80000248:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000024a:	00008597          	auipc	a1,0x8
    8000024e:	de658593          	addi	a1,a1,-538 # 80008030 <etext+0x30>
    80000252:	00009517          	auipc	a0,0x9
    80000256:	dde50513          	addi	a0,a0,-546 # 80009030 <kmem>
    8000025a:	00006097          	auipc	ra,0x6
    8000025e:	0f8080e7          	jalr	248(ra) # 80006352 <initlock>
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000262:	00027797          	auipc	a5,0x27
    80000266:	fdd78793          	addi	a5,a5,-35 # 8002723f <end+0xfff>
    8000026a:	767d                	lui	a2,0xfffff
    8000026c:	8e7d                	and	a2,a2,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000026e:	6705                	lui	a4,0x1
    80000270:	9732                	add	a4,a4,a2
    80000272:	47c5                	li	a5,17
    80000274:	07ee                	slli	a5,a5,0x1b
    80000276:	06e7ed63          	bltu	a5,a4,800002f0 <kinit+0xae>
    8000027a:	6789                	lui	a5,0x2
    8000027c:	97b2                	add	a5,a5,a2
    8000027e:	6685                	lui	a3,0x1
    80000280:	44001737          	lui	a4,0x44001
    80000284:	0706                	slli	a4,a4,0x1
    80000286:	97b6                	add	a5,a5,a3
    80000288:	fee79fe3          	bne	a5,a4,80000286 <kinit+0x44>
    8000028c:	000887b7          	lui	a5,0x88
    80000290:	17fd                	addi	a5,a5,-1
    80000292:	07b2                	slli	a5,a5,0xc
    80000294:	8f91                	sub	a5,a5,a2
    80000296:	83b1                	srli	a5,a5,0xc
    80000298:	2785                	addiw	a5,a5,1
    8000029a:	0007851b          	sext.w	a0,a5
  kmem.page_cnt = pagecnt(end, (void*)PHYSTOP);
    8000029e:	00009717          	auipc	a4,0x9
    800002a2:	d9270713          	addi	a4,a4,-622 # 80009030 <kmem>
    800002a6:	d71c                	sw	a5,40(a4)
  kmem.ref_page = end;
    800002a8:	00026797          	auipc	a5,0x26
    800002ac:	f9878793          	addi	a5,a5,-104 # 80026240 <end>
    800002b0:	f31c                	sd	a5,32(a4)
  for(int i = 0; i < kmem.page_cnt; ++i)
    800002b2:	00a05e63          	blez	a0,800002ce <kinit+0x8c>
    800002b6:	4781                	li	a5,0
    kmem.ref_page[i] = 0;
    800002b8:	86ba                	mv	a3,a4
    800002ba:	7298                	ld	a4,32(a3)
    800002bc:	973e                	add	a4,a4,a5
    800002be:	00070023          	sb	zero,0(a4)
  for(int i = 0; i < kmem.page_cnt; ++i)
    800002c2:	5688                	lw	a0,40(a3)
    800002c4:	0785                	addi	a5,a5,1
    800002c6:	0007871b          	sext.w	a4,a5
    800002ca:	fea748e3          	blt	a4,a0,800002ba <kinit+0x78>
  kmem.end = kmem.ref_page + kmem.page_cnt;
    800002ce:	00009717          	auipc	a4,0x9
    800002d2:	d6270713          	addi	a4,a4,-670 # 80009030 <kmem>
    800002d6:	731c                	ld	a5,32(a4)
    800002d8:	953e                	add	a0,a0,a5
    800002da:	fb08                	sd	a0,48(a4)
  freerange(kmem.end, (void*)PHYSTOP);
    800002dc:	45c5                	li	a1,17
    800002de:	05ee                	slli	a1,a1,0x1b
    800002e0:	00000097          	auipc	ra,0x0
    800002e4:	f18080e7          	jalr	-232(ra) # 800001f8 <freerange>
}
    800002e8:	60a2                	ld	ra,8(sp)
    800002ea:	6402                	ld	s0,0(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret
  kmem.page_cnt = pagecnt(end, (void*)PHYSTOP);
    800002f0:	00009797          	auipc	a5,0x9
    800002f4:	d4078793          	addi	a5,a5,-704 # 80009030 <kmem>
    800002f8:	0207a423          	sw	zero,40(a5)
  kmem.ref_page = end;
    800002fc:	00026717          	auipc	a4,0x26
    80000300:	f4470713          	addi	a4,a4,-188 # 80026240 <end>
    80000304:	f398                	sd	a4,32(a5)
  int cnt = 0;
    80000306:	4501                	li	a0,0
    80000308:	b7d9                	j	800002ce <kinit+0x8c>

000000008000030a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000030a:	1101                	addi	sp,sp,-32
    8000030c:	ec06                	sd	ra,24(sp)
    8000030e:	e822                	sd	s0,16(sp)
    80000310:	e426                	sd	s1,8(sp)
    80000312:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000314:	00009497          	auipc	s1,0x9
    80000318:	d1c48493          	addi	s1,s1,-740 # 80009030 <kmem>
    8000031c:	8526                	mv	a0,s1
    8000031e:	00006097          	auipc	ra,0x6
    80000322:	0c4080e7          	jalr	196(ra) # 800063e2 <acquire>
  r = kmem.freelist;
    80000326:	6c84                	ld	s1,24(s1)
  if(r)
    80000328:	cc8d                	beqz	s1,80000362 <kalloc+0x58>
    kmem.freelist = r->next;
    8000032a:	609c                	ld	a5,0(s1)
    8000032c:	00009517          	auipc	a0,0x9
    80000330:	d0450513          	addi	a0,a0,-764 # 80009030 <kmem>
    80000334:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000336:	00006097          	auipc	ra,0x6
    8000033a:	160080e7          	jalr	352(ra) # 80006496 <release>

  if(r)
  {
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000033e:	6605                	lui	a2,0x1
    80000340:	4595                	li	a1,5
    80000342:	8526                	mv	a0,s1
    80000344:	00000097          	auipc	ra,0x0
    80000348:	030080e7          	jalr	48(ra) # 80000374 <memset>
    incr(r);
    8000034c:	8526                	mv	a0,s1
    8000034e:	00000097          	auipc	ra,0x0
    80000352:	d5a080e7          	jalr	-678(ra) # 800000a8 <incr>
  }
  return (void*)r;
}
    80000356:	8526                	mv	a0,s1
    80000358:	60e2                	ld	ra,24(sp)
    8000035a:	6442                	ld	s0,16(sp)
    8000035c:	64a2                	ld	s1,8(sp)
    8000035e:	6105                	addi	sp,sp,32
    80000360:	8082                	ret
  release(&kmem.lock);
    80000362:	00009517          	auipc	a0,0x9
    80000366:	cce50513          	addi	a0,a0,-818 # 80009030 <kmem>
    8000036a:	00006097          	auipc	ra,0x6
    8000036e:	12c080e7          	jalr	300(ra) # 80006496 <release>
  if(r)
    80000372:	b7d5                	j	80000356 <kalloc+0x4c>

0000000080000374 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000374:	1141                	addi	sp,sp,-16
    80000376:	e422                	sd	s0,8(sp)
    80000378:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000037a:	ce09                	beqz	a2,80000394 <memset+0x20>
    8000037c:	87aa                	mv	a5,a0
    8000037e:	fff6071b          	addiw	a4,a2,-1
    80000382:	1702                	slli	a4,a4,0x20
    80000384:	9301                	srli	a4,a4,0x20
    80000386:	0705                	addi	a4,a4,1
    80000388:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000038a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000038e:	0785                	addi	a5,a5,1
    80000390:	fee79de3          	bne	a5,a4,8000038a <memset+0x16>
  }
  return dst;
}
    80000394:	6422                	ld	s0,8(sp)
    80000396:	0141                	addi	sp,sp,16
    80000398:	8082                	ret

000000008000039a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800003a0:	ca05                	beqz	a2,800003d0 <memcmp+0x36>
    800003a2:	fff6069b          	addiw	a3,a2,-1
    800003a6:	1682                	slli	a3,a3,0x20
    800003a8:	9281                	srli	a3,a3,0x20
    800003aa:	0685                	addi	a3,a3,1
    800003ac:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800003ae:	00054783          	lbu	a5,0(a0)
    800003b2:	0005c703          	lbu	a4,0(a1)
    800003b6:	00e79863          	bne	a5,a4,800003c6 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800003ba:	0505                	addi	a0,a0,1
    800003bc:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800003be:	fed518e3          	bne	a0,a3,800003ae <memcmp+0x14>
  }

  return 0;
    800003c2:	4501                	li	a0,0
    800003c4:	a019                	j	800003ca <memcmp+0x30>
      return *s1 - *s2;
    800003c6:	40e7853b          	subw	a0,a5,a4
}
    800003ca:	6422                	ld	s0,8(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret
  return 0;
    800003d0:	4501                	li	a0,0
    800003d2:	bfe5                	j	800003ca <memcmp+0x30>

00000000800003d4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800003d4:	1141                	addi	sp,sp,-16
    800003d6:	e422                	sd	s0,8(sp)
    800003d8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800003da:	ca0d                	beqz	a2,8000040c <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800003dc:	00a5f963          	bgeu	a1,a0,800003ee <memmove+0x1a>
    800003e0:	02061693          	slli	a3,a2,0x20
    800003e4:	9281                	srli	a3,a3,0x20
    800003e6:	00d58733          	add	a4,a1,a3
    800003ea:	02e56463          	bltu	a0,a4,80000412 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800003ee:	fff6079b          	addiw	a5,a2,-1
    800003f2:	1782                	slli	a5,a5,0x20
    800003f4:	9381                	srli	a5,a5,0x20
    800003f6:	0785                	addi	a5,a5,1
    800003f8:	97ae                	add	a5,a5,a1
    800003fa:	872a                	mv	a4,a0
      *d++ = *s++;
    800003fc:	0585                	addi	a1,a1,1
    800003fe:	0705                	addi	a4,a4,1
    80000400:	fff5c683          	lbu	a3,-1(a1)
    80000404:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000408:	fef59ae3          	bne	a1,a5,800003fc <memmove+0x28>

  return dst;
}
    8000040c:	6422                	ld	s0,8(sp)
    8000040e:	0141                	addi	sp,sp,16
    80000410:	8082                	ret
    d += n;
    80000412:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000414:	fff6079b          	addiw	a5,a2,-1
    80000418:	1782                	slli	a5,a5,0x20
    8000041a:	9381                	srli	a5,a5,0x20
    8000041c:	fff7c793          	not	a5,a5
    80000420:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000422:	177d                	addi	a4,a4,-1
    80000424:	16fd                	addi	a3,a3,-1
    80000426:	00074603          	lbu	a2,0(a4)
    8000042a:	00c68023          	sb	a2,0(a3) # 1000 <_entry-0x7ffff000>
    while(n-- > 0)
    8000042e:	fef71ae3          	bne	a4,a5,80000422 <memmove+0x4e>
    80000432:	bfe9                	j	8000040c <memmove+0x38>

0000000080000434 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e406                	sd	ra,8(sp)
    80000438:	e022                	sd	s0,0(sp)
    8000043a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	f98080e7          	jalr	-104(ra) # 800003d4 <memmove>
}
    80000444:	60a2                	ld	ra,8(sp)
    80000446:	6402                	ld	s0,0(sp)
    80000448:	0141                	addi	sp,sp,16
    8000044a:	8082                	ret

000000008000044c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000044c:	1141                	addi	sp,sp,-16
    8000044e:	e422                	sd	s0,8(sp)
    80000450:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000452:	ce11                	beqz	a2,8000046e <strncmp+0x22>
    80000454:	00054783          	lbu	a5,0(a0)
    80000458:	cf89                	beqz	a5,80000472 <strncmp+0x26>
    8000045a:	0005c703          	lbu	a4,0(a1)
    8000045e:	00f71a63          	bne	a4,a5,80000472 <strncmp+0x26>
    n--, p++, q++;
    80000462:	367d                	addiw	a2,a2,-1
    80000464:	0505                	addi	a0,a0,1
    80000466:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000468:	f675                	bnez	a2,80000454 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000046a:	4501                	li	a0,0
    8000046c:	a809                	j	8000047e <strncmp+0x32>
    8000046e:	4501                	li	a0,0
    80000470:	a039                	j	8000047e <strncmp+0x32>
  if(n == 0)
    80000472:	ca09                	beqz	a2,80000484 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000474:	00054503          	lbu	a0,0(a0)
    80000478:	0005c783          	lbu	a5,0(a1)
    8000047c:	9d1d                	subw	a0,a0,a5
}
    8000047e:	6422                	ld	s0,8(sp)
    80000480:	0141                	addi	sp,sp,16
    80000482:	8082                	ret
    return 0;
    80000484:	4501                	li	a0,0
    80000486:	bfe5                	j	8000047e <strncmp+0x32>

0000000080000488 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e422                	sd	s0,8(sp)
    8000048c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000048e:	872a                	mv	a4,a0
    80000490:	8832                	mv	a6,a2
    80000492:	367d                	addiw	a2,a2,-1
    80000494:	01005963          	blez	a6,800004a6 <strncpy+0x1e>
    80000498:	0705                	addi	a4,a4,1
    8000049a:	0005c783          	lbu	a5,0(a1)
    8000049e:	fef70fa3          	sb	a5,-1(a4)
    800004a2:	0585                	addi	a1,a1,1
    800004a4:	f7f5                	bnez	a5,80000490 <strncpy+0x8>
    ;
  while(n-- > 0)
    800004a6:	00c05d63          	blez	a2,800004c0 <strncpy+0x38>
    800004aa:	86ba                	mv	a3,a4
    *s++ = 0;
    800004ac:	0685                	addi	a3,a3,1
    800004ae:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800004b2:	fff6c793          	not	a5,a3
    800004b6:	9fb9                	addw	a5,a5,a4
    800004b8:	010787bb          	addw	a5,a5,a6
    800004bc:	fef048e3          	bgtz	a5,800004ac <strncpy+0x24>
  return os;
}
    800004c0:	6422                	ld	s0,8(sp)
    800004c2:	0141                	addi	sp,sp,16
    800004c4:	8082                	ret

00000000800004c6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800004c6:	1141                	addi	sp,sp,-16
    800004c8:	e422                	sd	s0,8(sp)
    800004ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800004cc:	02c05363          	blez	a2,800004f2 <safestrcpy+0x2c>
    800004d0:	fff6069b          	addiw	a3,a2,-1
    800004d4:	1682                	slli	a3,a3,0x20
    800004d6:	9281                	srli	a3,a3,0x20
    800004d8:	96ae                	add	a3,a3,a1
    800004da:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800004dc:	00d58963          	beq	a1,a3,800004ee <safestrcpy+0x28>
    800004e0:	0585                	addi	a1,a1,1
    800004e2:	0785                	addi	a5,a5,1
    800004e4:	fff5c703          	lbu	a4,-1(a1)
    800004e8:	fee78fa3          	sb	a4,-1(a5)
    800004ec:	fb65                	bnez	a4,800004dc <safestrcpy+0x16>
    ;
  *s = 0;
    800004ee:	00078023          	sb	zero,0(a5)
  return os;
}
    800004f2:	6422                	ld	s0,8(sp)
    800004f4:	0141                	addi	sp,sp,16
    800004f6:	8082                	ret

00000000800004f8 <strlen>:

int
strlen(const char *s)
{
    800004f8:	1141                	addi	sp,sp,-16
    800004fa:	e422                	sd	s0,8(sp)
    800004fc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800004fe:	00054783          	lbu	a5,0(a0)
    80000502:	cf91                	beqz	a5,8000051e <strlen+0x26>
    80000504:	0505                	addi	a0,a0,1
    80000506:	87aa                	mv	a5,a0
    80000508:	4685                	li	a3,1
    8000050a:	9e89                	subw	a3,a3,a0
    8000050c:	00f6853b          	addw	a0,a3,a5
    80000510:	0785                	addi	a5,a5,1
    80000512:	fff7c703          	lbu	a4,-1(a5)
    80000516:	fb7d                	bnez	a4,8000050c <strlen+0x14>
    ;
  return n;
}
    80000518:	6422                	ld	s0,8(sp)
    8000051a:	0141                	addi	sp,sp,16
    8000051c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000051e:	4501                	li	a0,0
    80000520:	bfe5                	j	80000518 <strlen+0x20>

0000000080000522 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000522:	1141                	addi	sp,sp,-16
    80000524:	e406                	sd	ra,8(sp)
    80000526:	e022                	sd	s0,0(sp)
    80000528:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000052a:	00001097          	auipc	ra,0x1
    8000052e:	bf0080e7          	jalr	-1040(ra) # 8000111a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000532:	00009717          	auipc	a4,0x9
    80000536:	ace70713          	addi	a4,a4,-1330 # 80009000 <started>
  if(cpuid() == 0){
    8000053a:	c139                	beqz	a0,80000580 <main+0x5e>
    while(started == 0)
    8000053c:	431c                	lw	a5,0(a4)
    8000053e:	2781                	sext.w	a5,a5
    80000540:	dff5                	beqz	a5,8000053c <main+0x1a>
      ;
    __sync_synchronize();
    80000542:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000546:	00001097          	auipc	ra,0x1
    8000054a:	bd4080e7          	jalr	-1068(ra) # 8000111a <cpuid>
    8000054e:	85aa                	mv	a1,a0
    80000550:	00008517          	auipc	a0,0x8
    80000554:	b0050513          	addi	a0,a0,-1280 # 80008050 <etext+0x50>
    80000558:	00006097          	auipc	ra,0x6
    8000055c:	98a080e7          	jalr	-1654(ra) # 80005ee2 <printf>
    kvminithart();    // turn on paging
    80000560:	00000097          	auipc	ra,0x0
    80000564:	0d8080e7          	jalr	216(ra) # 80000638 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000568:	00002097          	auipc	ra,0x2
    8000056c:	82a080e7          	jalr	-2006(ra) # 80001d92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000570:	00005097          	auipc	ra,0x5
    80000574:	e00080e7          	jalr	-512(ra) # 80005370 <plicinithart>
  }

  scheduler();        
    80000578:	00001097          	auipc	ra,0x1
    8000057c:	0d8080e7          	jalr	216(ra) # 80001650 <scheduler>
    consoleinit();
    80000580:	00006097          	auipc	ra,0x6
    80000584:	82a080e7          	jalr	-2006(ra) # 80005daa <consoleinit>
    printfinit();
    80000588:	00006097          	auipc	ra,0x6
    8000058c:	b40080e7          	jalr	-1216(ra) # 800060c8 <printfinit>
    printf("\n");
    80000590:	00008517          	auipc	a0,0x8
    80000594:	bf850513          	addi	a0,a0,-1032 # 80008188 <etext+0x188>
    80000598:	00006097          	auipc	ra,0x6
    8000059c:	94a080e7          	jalr	-1718(ra) # 80005ee2 <printf>
    printf("xv6 kernel is booting\n");
    800005a0:	00008517          	auipc	a0,0x8
    800005a4:	a9850513          	addi	a0,a0,-1384 # 80008038 <etext+0x38>
    800005a8:	00006097          	auipc	ra,0x6
    800005ac:	93a080e7          	jalr	-1734(ra) # 80005ee2 <printf>
    printf("\n");
    800005b0:	00008517          	auipc	a0,0x8
    800005b4:	bd850513          	addi	a0,a0,-1064 # 80008188 <etext+0x188>
    800005b8:	00006097          	auipc	ra,0x6
    800005bc:	92a080e7          	jalr	-1750(ra) # 80005ee2 <printf>
    kinit();         // physical page allocator
    800005c0:	00000097          	auipc	ra,0x0
    800005c4:	c82080e7          	jalr	-894(ra) # 80000242 <kinit>
    kvminit();       // create kernel page table
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	322080e7          	jalr	802(ra) # 800008ea <kvminit>
    kvminithart();   // turn on paging
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	068080e7          	jalr	104(ra) # 80000638 <kvminithart>
    procinit();      // process table
    800005d8:	00001097          	auipc	ra,0x1
    800005dc:	a92080e7          	jalr	-1390(ra) # 8000106a <procinit>
    trapinit();      // trap vectors
    800005e0:	00001097          	auipc	ra,0x1
    800005e4:	78a080e7          	jalr	1930(ra) # 80001d6a <trapinit>
    trapinithart();  // install kernel trap vector
    800005e8:	00001097          	auipc	ra,0x1
    800005ec:	7aa080e7          	jalr	1962(ra) # 80001d92 <trapinithart>
    plicinit();      // set up interrupt controller
    800005f0:	00005097          	auipc	ra,0x5
    800005f4:	d6a080e7          	jalr	-662(ra) # 8000535a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800005f8:	00005097          	auipc	ra,0x5
    800005fc:	d78080e7          	jalr	-648(ra) # 80005370 <plicinithart>
    binit();         // buffer cache
    80000600:	00002097          	auipc	ra,0x2
    80000604:	f58080e7          	jalr	-168(ra) # 80002558 <binit>
    iinit();         // inode table
    80000608:	00002097          	auipc	ra,0x2
    8000060c:	5e8080e7          	jalr	1512(ra) # 80002bf0 <iinit>
    fileinit();      // file table
    80000610:	00003097          	auipc	ra,0x3
    80000614:	592080e7          	jalr	1426(ra) # 80003ba2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000618:	00005097          	auipc	ra,0x5
    8000061c:	e7a080e7          	jalr	-390(ra) # 80005492 <virtio_disk_init>
    userinit();      // first user process
    80000620:	00001097          	auipc	ra,0x1
    80000624:	dfe080e7          	jalr	-514(ra) # 8000141e <userinit>
    __sync_synchronize();
    80000628:	0ff0000f          	fence
    started = 1;
    8000062c:	4785                	li	a5,1
    8000062e:	00009717          	auipc	a4,0x9
    80000632:	9cf72923          	sw	a5,-1582(a4) # 80009000 <started>
    80000636:	b789                	j	80000578 <main+0x56>

0000000080000638 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000638:	1141                	addi	sp,sp,-16
    8000063a:	e422                	sd	s0,8(sp)
    8000063c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000063e:	00009797          	auipc	a5,0x9
    80000642:	9ca7b783          	ld	a5,-1590(a5) # 80009008 <kernel_pagetable>
    80000646:	83b1                	srli	a5,a5,0xc
    80000648:	577d                	li	a4,-1
    8000064a:	177e                	slli	a4,a4,0x3f
    8000064c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000064e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000652:	12000073          	sfence.vma
  sfence_vma();
}
    80000656:	6422                	ld	s0,8(sp)
    80000658:	0141                	addi	sp,sp,16
    8000065a:	8082                	ret

000000008000065c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000065c:	7139                	addi	sp,sp,-64
    8000065e:	fc06                	sd	ra,56(sp)
    80000660:	f822                	sd	s0,48(sp)
    80000662:	f426                	sd	s1,40(sp)
    80000664:	f04a                	sd	s2,32(sp)
    80000666:	ec4e                	sd	s3,24(sp)
    80000668:	e852                	sd	s4,16(sp)
    8000066a:	e456                	sd	s5,8(sp)
    8000066c:	e05a                	sd	s6,0(sp)
    8000066e:	0080                	addi	s0,sp,64
    80000670:	84aa                	mv	s1,a0
    80000672:	89ae                	mv	s3,a1
    80000674:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000676:	57fd                	li	a5,-1
    80000678:	83e9                	srli	a5,a5,0x1a
    8000067a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000067c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000067e:	04b7f263          	bgeu	a5,a1,800006c2 <walk+0x66>
    panic("walk");
    80000682:	00008517          	auipc	a0,0x8
    80000686:	9e650513          	addi	a0,a0,-1562 # 80008068 <etext+0x68>
    8000068a:	00006097          	auipc	ra,0x6
    8000068e:	80e080e7          	jalr	-2034(ra) # 80005e98 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000692:	060a8663          	beqz	s5,800006fe <walk+0xa2>
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	c74080e7          	jalr	-908(ra) # 8000030a <kalloc>
    8000069e:	84aa                	mv	s1,a0
    800006a0:	c529                	beqz	a0,800006ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800006a2:	6605                	lui	a2,0x1
    800006a4:	4581                	li	a1,0
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	cce080e7          	jalr	-818(ra) # 80000374 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800006ae:	00c4d793          	srli	a5,s1,0xc
    800006b2:	07aa                	slli	a5,a5,0xa
    800006b4:	0017e793          	ori	a5,a5,1
    800006b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800006bc:	3a5d                	addiw	s4,s4,-9
    800006be:	036a0063          	beq	s4,s6,800006de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800006c2:	0149d933          	srl	s2,s3,s4
    800006c6:	1ff97913          	andi	s2,s2,511
    800006ca:	090e                	slli	s2,s2,0x3
    800006cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800006ce:	00093483          	ld	s1,0(s2)
    800006d2:	0014f793          	andi	a5,s1,1
    800006d6:	dfd5                	beqz	a5,80000692 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800006d8:	80a9                	srli	s1,s1,0xa
    800006da:	04b2                	slli	s1,s1,0xc
    800006dc:	b7c5                	j	800006bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800006de:	00c9d513          	srli	a0,s3,0xc
    800006e2:	1ff57513          	andi	a0,a0,511
    800006e6:	050e                	slli	a0,a0,0x3
    800006e8:	9526                	add	a0,a0,s1
}
    800006ea:	70e2                	ld	ra,56(sp)
    800006ec:	7442                	ld	s0,48(sp)
    800006ee:	74a2                	ld	s1,40(sp)
    800006f0:	7902                	ld	s2,32(sp)
    800006f2:	69e2                	ld	s3,24(sp)
    800006f4:	6a42                	ld	s4,16(sp)
    800006f6:	6aa2                	ld	s5,8(sp)
    800006f8:	6b02                	ld	s6,0(sp)
    800006fa:	6121                	addi	sp,sp,64
    800006fc:	8082                	ret
        return 0;
    800006fe:	4501                	li	a0,0
    80000700:	b7ed                	j	800006ea <walk+0x8e>

0000000080000702 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000702:	57fd                	li	a5,-1
    80000704:	83e9                	srli	a5,a5,0x1a
    80000706:	00b7f463          	bgeu	a5,a1,8000070e <walkaddr+0xc>
    return 0;
    8000070a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000070c:	8082                	ret
{
    8000070e:	1141                	addi	sp,sp,-16
    80000710:	e406                	sd	ra,8(sp)
    80000712:	e022                	sd	s0,0(sp)
    80000714:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000716:	4601                	li	a2,0
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f44080e7          	jalr	-188(ra) # 8000065c <walk>
  if(pte == 0)
    80000720:	c105                	beqz	a0,80000740 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000722:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000724:	0117f693          	andi	a3,a5,17
    80000728:	4745                	li	a4,17
    return 0;
    8000072a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000072c:	00e68663          	beq	a3,a4,80000738 <walkaddr+0x36>
}
    80000730:	60a2                	ld	ra,8(sp)
    80000732:	6402                	ld	s0,0(sp)
    80000734:	0141                	addi	sp,sp,16
    80000736:	8082                	ret
  pa = PTE2PA(*pte);
    80000738:	00a7d513          	srli	a0,a5,0xa
    8000073c:	0532                	slli	a0,a0,0xc
  return pa;
    8000073e:	bfcd                	j	80000730 <walkaddr+0x2e>
    return 0;
    80000740:	4501                	li	a0,0
    80000742:	b7fd                	j	80000730 <walkaddr+0x2e>

0000000080000744 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000744:	715d                	addi	sp,sp,-80
    80000746:	e486                	sd	ra,72(sp)
    80000748:	e0a2                	sd	s0,64(sp)
    8000074a:	fc26                	sd	s1,56(sp)
    8000074c:	f84a                	sd	s2,48(sp)
    8000074e:	f44e                	sd	s3,40(sp)
    80000750:	f052                	sd	s4,32(sp)
    80000752:	ec56                	sd	s5,24(sp)
    80000754:	e85a                	sd	s6,16(sp)
    80000756:	e45e                	sd	s7,8(sp)
    80000758:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000075a:	c205                	beqz	a2,8000077a <mappages+0x36>
    8000075c:	8aaa                	mv	s5,a0
    8000075e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000760:	77fd                	lui	a5,0xfffff
    80000762:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000766:	15fd                	addi	a1,a1,-1
    80000768:	00c589b3          	add	s3,a1,a2
    8000076c:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000770:	8952                	mv	s2,s4
    80000772:	41468a33          	sub	s4,a3,s4
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;

    if(a == last)
      break;
    a += PGSIZE;
    80000776:	6b85                	lui	s7,0x1
    80000778:	a015                	j	8000079c <mappages+0x58>
    panic("mappages: size");
    8000077a:	00008517          	auipc	a0,0x8
    8000077e:	8f650513          	addi	a0,a0,-1802 # 80008070 <etext+0x70>
    80000782:	00005097          	auipc	ra,0x5
    80000786:	716080e7          	jalr	1814(ra) # 80005e98 <panic>
      panic("mappages: remap");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	8f650513          	addi	a0,a0,-1802 # 80008080 <etext+0x80>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	706080e7          	jalr	1798(ra) # 80005e98 <panic>
    a += PGSIZE;
    8000079a:	995e                	add	s2,s2,s7
  for(;;){
    8000079c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800007a0:	4605                	li	a2,1
    800007a2:	85ca                	mv	a1,s2
    800007a4:	8556                	mv	a0,s5
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	eb6080e7          	jalr	-330(ra) # 8000065c <walk>
    800007ae:	cd19                	beqz	a0,800007cc <mappages+0x88>
    if(*pte & PTE_V)
    800007b0:	611c                	ld	a5,0(a0)
    800007b2:	8b85                	andi	a5,a5,1
    800007b4:	fbf9                	bnez	a5,8000078a <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007b6:	80b1                	srli	s1,s1,0xc
    800007b8:	04aa                	slli	s1,s1,0xa
    800007ba:	0164e4b3          	or	s1,s1,s6
    800007be:	0014e493          	ori	s1,s1,1
    800007c2:	e104                	sd	s1,0(a0)
    if(a == last)
    800007c4:	fd391be3          	bne	s2,s3,8000079a <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800007c8:	4501                	li	a0,0
    800007ca:	a011                	j	800007ce <mappages+0x8a>
      return -1;
    800007cc:	557d                	li	a0,-1
}
    800007ce:	60a6                	ld	ra,72(sp)
    800007d0:	6406                	ld	s0,64(sp)
    800007d2:	74e2                	ld	s1,56(sp)
    800007d4:	7942                	ld	s2,48(sp)
    800007d6:	79a2                	ld	s3,40(sp)
    800007d8:	7a02                	ld	s4,32(sp)
    800007da:	6ae2                	ld	s5,24(sp)
    800007dc:	6b42                	ld	s6,16(sp)
    800007de:	6ba2                	ld	s7,8(sp)
    800007e0:	6161                	addi	sp,sp,80
    800007e2:	8082                	ret

00000000800007e4 <kvmmap>:
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
    800007ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800007ee:	86b2                	mv	a3,a2
    800007f0:	863e                	mv	a2,a5
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	f52080e7          	jalr	-174(ra) # 80000744 <mappages>
    800007fa:	e509                	bnez	a0,80000804 <kvmmap+0x20>
}
    800007fc:	60a2                	ld	ra,8(sp)
    800007fe:	6402                	ld	s0,0(sp)
    80000800:	0141                	addi	sp,sp,16
    80000802:	8082                	ret
    panic("kvmmap");
    80000804:	00008517          	auipc	a0,0x8
    80000808:	88c50513          	addi	a0,a0,-1908 # 80008090 <etext+0x90>
    8000080c:	00005097          	auipc	ra,0x5
    80000810:	68c080e7          	jalr	1676(ra) # 80005e98 <panic>

0000000080000814 <kvmmake>:
{
    80000814:	1101                	addi	sp,sp,-32
    80000816:	ec06                	sd	ra,24(sp)
    80000818:	e822                	sd	s0,16(sp)
    8000081a:	e426                	sd	s1,8(sp)
    8000081c:	e04a                	sd	s2,0(sp)
    8000081e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	aea080e7          	jalr	-1302(ra) # 8000030a <kalloc>
    80000828:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	b46080e7          	jalr	-1210(ra) # 80000374 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000836:	4719                	li	a4,6
    80000838:	6685                	lui	a3,0x1
    8000083a:	10000637          	lui	a2,0x10000
    8000083e:	100005b7          	lui	a1,0x10000
    80000842:	8526                	mv	a0,s1
    80000844:	00000097          	auipc	ra,0x0
    80000848:	fa0080e7          	jalr	-96(ra) # 800007e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000084c:	4719                	li	a4,6
    8000084e:	6685                	lui	a3,0x1
    80000850:	10001637          	lui	a2,0x10001
    80000854:	100015b7          	lui	a1,0x10001
    80000858:	8526                	mv	a0,s1
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	f8a080e7          	jalr	-118(ra) # 800007e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000862:	4719                	li	a4,6
    80000864:	004006b7          	lui	a3,0x400
    80000868:	0c000637          	lui	a2,0xc000
    8000086c:	0c0005b7          	lui	a1,0xc000
    80000870:	8526                	mv	a0,s1
    80000872:	00000097          	auipc	ra,0x0
    80000876:	f72080e7          	jalr	-142(ra) # 800007e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000087a:	00007917          	auipc	s2,0x7
    8000087e:	78690913          	addi	s2,s2,1926 # 80008000 <etext>
    80000882:	4729                	li	a4,10
    80000884:	80007697          	auipc	a3,0x80007
    80000888:	77c68693          	addi	a3,a3,1916 # 8000 <_entry-0x7fff8000>
    8000088c:	4605                	li	a2,1
    8000088e:	067e                	slli	a2,a2,0x1f
    80000890:	85b2                	mv	a1,a2
    80000892:	8526                	mv	a0,s1
    80000894:	00000097          	auipc	ra,0x0
    80000898:	f50080e7          	jalr	-176(ra) # 800007e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000089c:	4719                	li	a4,6
    8000089e:	46c5                	li	a3,17
    800008a0:	06ee                	slli	a3,a3,0x1b
    800008a2:	412686b3          	sub	a3,a3,s2
    800008a6:	864a                	mv	a2,s2
    800008a8:	85ca                	mv	a1,s2
    800008aa:	8526                	mv	a0,s1
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	f38080e7          	jalr	-200(ra) # 800007e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800008b4:	4729                	li	a4,10
    800008b6:	6685                	lui	a3,0x1
    800008b8:	00006617          	auipc	a2,0x6
    800008bc:	74860613          	addi	a2,a2,1864 # 80007000 <_trampoline>
    800008c0:	040005b7          	lui	a1,0x4000
    800008c4:	15fd                	addi	a1,a1,-1
    800008c6:	05b2                	slli	a1,a1,0xc
    800008c8:	8526                	mv	a0,s1
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	f1a080e7          	jalr	-230(ra) # 800007e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800008d2:	8526                	mv	a0,s1
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	700080e7          	jalr	1792(ra) # 80000fd4 <proc_mapstacks>
}
    800008dc:	8526                	mv	a0,s1
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6902                	ld	s2,0(sp)
    800008e6:	6105                	addi	sp,sp,32
    800008e8:	8082                	ret

00000000800008ea <kvminit>:
{
    800008ea:	1141                	addi	sp,sp,-16
    800008ec:	e406                	sd	ra,8(sp)
    800008ee:	e022                	sd	s0,0(sp)
    800008f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	f22080e7          	jalr	-222(ra) # 80000814 <kvmmake>
    800008fa:	00008797          	auipc	a5,0x8
    800008fe:	70a7b723          	sd	a0,1806(a5) # 80009008 <kernel_pagetable>
}
    80000902:	60a2                	ld	ra,8(sp)
    80000904:	6402                	ld	s0,0(sp)
    80000906:	0141                	addi	sp,sp,16
    80000908:	8082                	ret

000000008000090a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000090a:	715d                	addi	sp,sp,-80
    8000090c:	e486                	sd	ra,72(sp)
    8000090e:	e0a2                	sd	s0,64(sp)
    80000910:	fc26                	sd	s1,56(sp)
    80000912:	f84a                	sd	s2,48(sp)
    80000914:	f44e                	sd	s3,40(sp)
    80000916:	f052                	sd	s4,32(sp)
    80000918:	ec56                	sd	s5,24(sp)
    8000091a:	e85a                	sd	s6,16(sp)
    8000091c:	e45e                	sd	s7,8(sp)
    8000091e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000920:	03459793          	slli	a5,a1,0x34
    80000924:	e795                	bnez	a5,80000950 <uvmunmap+0x46>
    80000926:	8a2a                	mv	s4,a0
    80000928:	892e                	mv	s2,a1
    8000092a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000092c:	0632                	slli	a2,a2,0xc
    8000092e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000932:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000934:	6b05                	lui	s6,0x1
    80000936:	0735e863          	bltu	a1,s3,800009a6 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000093a:	60a6                	ld	ra,72(sp)
    8000093c:	6406                	ld	s0,64(sp)
    8000093e:	74e2                	ld	s1,56(sp)
    80000940:	7942                	ld	s2,48(sp)
    80000942:	79a2                	ld	s3,40(sp)
    80000944:	7a02                	ld	s4,32(sp)
    80000946:	6ae2                	ld	s5,24(sp)
    80000948:	6b42                	ld	s6,16(sp)
    8000094a:	6ba2                	ld	s7,8(sp)
    8000094c:	6161                	addi	sp,sp,80
    8000094e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000950:	00007517          	auipc	a0,0x7
    80000954:	74850513          	addi	a0,a0,1864 # 80008098 <etext+0x98>
    80000958:	00005097          	auipc	ra,0x5
    8000095c:	540080e7          	jalr	1344(ra) # 80005e98 <panic>
      panic("uvmunmap: walk");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	75050513          	addi	a0,a0,1872 # 800080b0 <etext+0xb0>
    80000968:	00005097          	auipc	ra,0x5
    8000096c:	530080e7          	jalr	1328(ra) # 80005e98 <panic>
      panic("uvmunmap: not mapped");
    80000970:	00007517          	auipc	a0,0x7
    80000974:	75050513          	addi	a0,a0,1872 # 800080c0 <etext+0xc0>
    80000978:	00005097          	auipc	ra,0x5
    8000097c:	520080e7          	jalr	1312(ra) # 80005e98 <panic>
      panic("uvmunmap: not a leaf");
    80000980:	00007517          	auipc	a0,0x7
    80000984:	75850513          	addi	a0,a0,1880 # 800080d8 <etext+0xd8>
    80000988:	00005097          	auipc	ra,0x5
    8000098c:	510080e7          	jalr	1296(ra) # 80005e98 <panic>
      uint64 pa = PTE2PA(*pte);
    80000990:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000992:	0532                	slli	a0,a0,0xc
    80000994:	fffff097          	auipc	ra,0xfffff
    80000998:	7b0080e7          	jalr	1968(ra) # 80000144 <kfree>
    *pte = 0;
    8000099c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800009a0:	995a                	add	s2,s2,s6
    800009a2:	f9397ce3          	bgeu	s2,s3,8000093a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800009a6:	4601                	li	a2,0
    800009a8:	85ca                	mv	a1,s2
    800009aa:	8552                	mv	a0,s4
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	cb0080e7          	jalr	-848(ra) # 8000065c <walk>
    800009b4:	84aa                	mv	s1,a0
    800009b6:	d54d                	beqz	a0,80000960 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800009b8:	6108                	ld	a0,0(a0)
    800009ba:	00157793          	andi	a5,a0,1
    800009be:	dbcd                	beqz	a5,80000970 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800009c0:	3ff57793          	andi	a5,a0,1023
    800009c4:	fb778ee3          	beq	a5,s7,80000980 <uvmunmap+0x76>
    if(do_free){
    800009c8:	fc0a8ae3          	beqz	s5,8000099c <uvmunmap+0x92>
    800009cc:	b7d1                	j	80000990 <uvmunmap+0x86>

00000000800009ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	932080e7          	jalr	-1742(ra) # 8000030a <kalloc>
    800009e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800009e2:	c519                	beqz	a0,800009f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800009e4:	6605                	lui	a2,0x1
    800009e6:	4581                	li	a1,0
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	98c080e7          	jalr	-1652(ra) # 80000374 <memset>
  return pagetable;
}
    800009f0:	8526                	mv	a0,s1
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret

00000000800009fc <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800009fc:	7179                	addi	sp,sp,-48
    800009fe:	f406                	sd	ra,40(sp)
    80000a00:	f022                	sd	s0,32(sp)
    80000a02:	ec26                	sd	s1,24(sp)
    80000a04:	e84a                	sd	s2,16(sp)
    80000a06:	e44e                	sd	s3,8(sp)
    80000a08:	e052                	sd	s4,0(sp)
    80000a0a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000a0c:	6785                	lui	a5,0x1
    80000a0e:	04f67863          	bgeu	a2,a5,80000a5e <uvminit+0x62>
    80000a12:	8a2a                	mv	s4,a0
    80000a14:	89ae                	mv	s3,a1
    80000a16:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	8f2080e7          	jalr	-1806(ra) # 8000030a <kalloc>
    80000a20:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a22:	6605                	lui	a2,0x1
    80000a24:	4581                	li	a1,0
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	94e080e7          	jalr	-1714(ra) # 80000374 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000a2e:	4779                	li	a4,30
    80000a30:	86ca                	mv	a3,s2
    80000a32:	6605                	lui	a2,0x1
    80000a34:	4581                	li	a1,0
    80000a36:	8552                	mv	a0,s4
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	d0c080e7          	jalr	-756(ra) # 80000744 <mappages>
  memmove(mem, src, sz);
    80000a40:	8626                	mv	a2,s1
    80000a42:	85ce                	mv	a1,s3
    80000a44:	854a                	mv	a0,s2
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	98e080e7          	jalr	-1650(ra) # 800003d4 <memmove>
}
    80000a4e:	70a2                	ld	ra,40(sp)
    80000a50:	7402                	ld	s0,32(sp)
    80000a52:	64e2                	ld	s1,24(sp)
    80000a54:	6942                	ld	s2,16(sp)
    80000a56:	69a2                	ld	s3,8(sp)
    80000a58:	6a02                	ld	s4,0(sp)
    80000a5a:	6145                	addi	sp,sp,48
    80000a5c:	8082                	ret
    panic("inituvm: more than a page");
    80000a5e:	00007517          	auipc	a0,0x7
    80000a62:	69250513          	addi	a0,a0,1682 # 800080f0 <etext+0xf0>
    80000a66:	00005097          	auipc	ra,0x5
    80000a6a:	432080e7          	jalr	1074(ra) # 80005e98 <panic>

0000000080000a6e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a6e:	1101                	addi	sp,sp,-32
    80000a70:	ec06                	sd	ra,24(sp)
    80000a72:	e822                	sd	s0,16(sp)
    80000a74:	e426                	sd	s1,8(sp)
    80000a76:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a78:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a7a:	00b67d63          	bgeu	a2,a1,80000a94 <uvmdealloc+0x26>
    80000a7e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a80:	6785                	lui	a5,0x1
    80000a82:	17fd                	addi	a5,a5,-1
    80000a84:	00f60733          	add	a4,a2,a5
    80000a88:	767d                	lui	a2,0xfffff
    80000a8a:	8f71                	and	a4,a4,a2
    80000a8c:	97ae                	add	a5,a5,a1
    80000a8e:	8ff1                	and	a5,a5,a2
    80000a90:	00f76863          	bltu	a4,a5,80000aa0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a94:	8526                	mv	a0,s1
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6105                	addi	sp,sp,32
    80000a9e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000aa0:	8f99                	sub	a5,a5,a4
    80000aa2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000aa4:	4685                	li	a3,1
    80000aa6:	0007861b          	sext.w	a2,a5
    80000aaa:	85ba                	mv	a1,a4
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	e5e080e7          	jalr	-418(ra) # 8000090a <uvmunmap>
    80000ab4:	b7c5                	j	80000a94 <uvmdealloc+0x26>

0000000080000ab6 <uvmalloc>:
  if(newsz < oldsz)
    80000ab6:	0ab66163          	bltu	a2,a1,80000b58 <uvmalloc+0xa2>
{
    80000aba:	7139                	addi	sp,sp,-64
    80000abc:	fc06                	sd	ra,56(sp)
    80000abe:	f822                	sd	s0,48(sp)
    80000ac0:	f426                	sd	s1,40(sp)
    80000ac2:	f04a                	sd	s2,32(sp)
    80000ac4:	ec4e                	sd	s3,24(sp)
    80000ac6:	e852                	sd	s4,16(sp)
    80000ac8:	e456                	sd	s5,8(sp)
    80000aca:	0080                	addi	s0,sp,64
    80000acc:	8aaa                	mv	s5,a0
    80000ace:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000ad0:	6985                	lui	s3,0x1
    80000ad2:	19fd                	addi	s3,s3,-1
    80000ad4:	95ce                	add	a1,a1,s3
    80000ad6:	79fd                	lui	s3,0xfffff
    80000ad8:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000adc:	08c9f063          	bgeu	s3,a2,80000b5c <uvmalloc+0xa6>
    80000ae0:	894e                	mv	s2,s3
    mem = kalloc();
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	828080e7          	jalr	-2008(ra) # 8000030a <kalloc>
    80000aea:	84aa                	mv	s1,a0
    if(mem == 0){
    80000aec:	c51d                	beqz	a0,80000b1a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000aee:	6605                	lui	a2,0x1
    80000af0:	4581                	li	a1,0
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	882080e7          	jalr	-1918(ra) # 80000374 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000afa:	4779                	li	a4,30
    80000afc:	86a6                	mv	a3,s1
    80000afe:	6605                	lui	a2,0x1
    80000b00:	85ca                	mv	a1,s2
    80000b02:	8556                	mv	a0,s5
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	c40080e7          	jalr	-960(ra) # 80000744 <mappages>
    80000b0c:	e905                	bnez	a0,80000b3c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000b0e:	6785                	lui	a5,0x1
    80000b10:	993e                	add	s2,s2,a5
    80000b12:	fd4968e3          	bltu	s2,s4,80000ae2 <uvmalloc+0x2c>
  return newsz;
    80000b16:	8552                	mv	a0,s4
    80000b18:	a809                	j	80000b2a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000b1a:	864e                	mv	a2,s3
    80000b1c:	85ca                	mv	a1,s2
    80000b1e:	8556                	mv	a0,s5
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	f4e080e7          	jalr	-178(ra) # 80000a6e <uvmdealloc>
      return 0;
    80000b28:	4501                	li	a0,0
}
    80000b2a:	70e2                	ld	ra,56(sp)
    80000b2c:	7442                	ld	s0,48(sp)
    80000b2e:	74a2                	ld	s1,40(sp)
    80000b30:	7902                	ld	s2,32(sp)
    80000b32:	69e2                	ld	s3,24(sp)
    80000b34:	6a42                	ld	s4,16(sp)
    80000b36:	6aa2                	ld	s5,8(sp)
    80000b38:	6121                	addi	sp,sp,64
    80000b3a:	8082                	ret
      kfree(mem);
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	606080e7          	jalr	1542(ra) # 80000144 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b46:	864e                	mv	a2,s3
    80000b48:	85ca                	mv	a1,s2
    80000b4a:	8556                	mv	a0,s5
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	f22080e7          	jalr	-222(ra) # 80000a6e <uvmdealloc>
      return 0;
    80000b54:	4501                	li	a0,0
    80000b56:	bfd1                	j	80000b2a <uvmalloc+0x74>
    return oldsz;
    80000b58:	852e                	mv	a0,a1
}
    80000b5a:	8082                	ret
  return newsz;
    80000b5c:	8532                	mv	a0,a2
    80000b5e:	b7f1                	j	80000b2a <uvmalloc+0x74>

0000000080000b60 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b60:	7179                	addi	sp,sp,-48
    80000b62:	f406                	sd	ra,40(sp)
    80000b64:	f022                	sd	s0,32(sp)
    80000b66:	ec26                	sd	s1,24(sp)
    80000b68:	e84a                	sd	s2,16(sp)
    80000b6a:	e44e                	sd	s3,8(sp)
    80000b6c:	e052                	sd	s4,0(sp)
    80000b6e:	1800                	addi	s0,sp,48
    80000b70:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b72:	84aa                	mv	s1,a0
    80000b74:	6905                	lui	s2,0x1
    80000b76:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b78:	4985                	li	s3,1
    80000b7a:	a821                	j	80000b92 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b7c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000b7e:	0532                	slli	a0,a0,0xc
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	fe0080e7          	jalr	-32(ra) # 80000b60 <freewalk>
      pagetable[i] = 0;
    80000b88:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b8c:	04a1                	addi	s1,s1,8
    80000b8e:	03248163          	beq	s1,s2,80000bb0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b92:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b94:	00f57793          	andi	a5,a0,15
    80000b98:	ff3782e3          	beq	a5,s3,80000b7c <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b9c:	8905                	andi	a0,a0,1
    80000b9e:	d57d                	beqz	a0,80000b8c <freewalk+0x2c>
      panic("freewalk: leaf");
    80000ba0:	00007517          	auipc	a0,0x7
    80000ba4:	57050513          	addi	a0,a0,1392 # 80008110 <etext+0x110>
    80000ba8:	00005097          	auipc	ra,0x5
    80000bac:	2f0080e7          	jalr	752(ra) # 80005e98 <panic>
    }
  }
  kfree((void*)pagetable);
    80000bb0:	8552                	mv	a0,s4
    80000bb2:	fffff097          	auipc	ra,0xfffff
    80000bb6:	592080e7          	jalr	1426(ra) # 80000144 <kfree>
}
    80000bba:	70a2                	ld	ra,40(sp)
    80000bbc:	7402                	ld	s0,32(sp)
    80000bbe:	64e2                	ld	s1,24(sp)
    80000bc0:	6942                	ld	s2,16(sp)
    80000bc2:	69a2                	ld	s3,8(sp)
    80000bc4:	6a02                	ld	s4,0(sp)
    80000bc6:	6145                	addi	sp,sp,48
    80000bc8:	8082                	ret

0000000080000bca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000bca:	1101                	addi	sp,sp,-32
    80000bcc:	ec06                	sd	ra,24(sp)
    80000bce:	e822                	sd	s0,16(sp)
    80000bd0:	e426                	sd	s1,8(sp)
    80000bd2:	1000                	addi	s0,sp,32
    80000bd4:	84aa                	mv	s1,a0
  if(sz > 0)
    80000bd6:	e999                	bnez	a1,80000bec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000bd8:	8526                	mv	a0,s1
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	f86080e7          	jalr	-122(ra) # 80000b60 <freewalk>
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000bec:	6605                	lui	a2,0x1
    80000bee:	167d                	addi	a2,a2,-1
    80000bf0:	962e                	add	a2,a2,a1
    80000bf2:	4685                	li	a3,1
    80000bf4:	8231                	srli	a2,a2,0xc
    80000bf6:	4581                	li	a1,0
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	d12080e7          	jalr	-750(ra) # 8000090a <uvmunmap>
    80000c00:	bfe1                	j	80000bd8 <uvmfree+0xe>

0000000080000c02 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000c02:	7139                	addi	sp,sp,-64
    80000c04:	fc06                	sd	ra,56(sp)
    80000c06:	f822                	sd	s0,48(sp)
    80000c08:	f426                	sd	s1,40(sp)
    80000c0a:	f04a                	sd	s2,32(sp)
    80000c0c:	ec4e                	sd	s3,24(sp)
    80000c0e:	e852                	sd	s4,16(sp)
    80000c10:	e456                	sd	s5,8(sp)
    80000c12:	e05a                	sd	s6,0(sp)
    80000c14:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000c16:	c25d                	beqz	a2,80000cbc <uvmcopy+0xba>
    80000c18:	8aaa                	mv	s5,a0
    80000c1a:	8a2e                	mv	s4,a1
    80000c1c:	89b2                	mv	s3,a2
    80000c1e:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)//返回页表中对应的虚拟地址的页表项
    80000c20:	4601                	li	a2,0
    80000c22:	85a6                	mv	a1,s1
    80000c24:	8556                	mv	a0,s5
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	a36080e7          	jalr	-1482(ra) # 8000065c <walk>
    80000c2e:	c131                	beqz	a0,80000c72 <uvmcopy+0x70>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000c30:	6118                	ld	a4,0(a0)
    80000c32:	00177793          	andi	a5,a4,1
    80000c36:	c7b1                	beqz	a5,80000c82 <uvmcopy+0x80>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);//获取页表项对应的物理地址 
    80000c38:	00a75913          	srli	s2,a4,0xa
    80000c3c:	0932                	slli	s2,s2,0xc
    *pte &= ~PTE_W;
    80000c3e:	9b6d                	andi	a4,a4,-5
    *pte |= PTE_COW;
    80000c40:	10076713          	ori	a4,a4,256
    80000c44:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    // if((mem = kalloc()) == 0)//分配物理页面
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);//把src的内容复制到dst上
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000c46:	3fb77713          	andi	a4,a4,1019
    80000c4a:	86ca                	mv	a3,s2
    80000c4c:	6605                	lui	a2,0x1
    80000c4e:	85a6                	mv	a1,s1
    80000c50:	8552                	mv	a0,s4
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	af2080e7          	jalr	-1294(ra) # 80000744 <mappages>
    80000c5a:	8b2a                	mv	s6,a0
    80000c5c:	e91d                	bnez	a0,80000c92 <uvmcopy+0x90>
      goto err;
    }
    incr((void *)pa);
    80000c5e:	854a                	mv	a0,s2
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	448080e7          	jalr	1096(ra) # 800000a8 <incr>
  for(i = 0; i < sz; i += PGSIZE){
    80000c68:	6785                	lui	a5,0x1
    80000c6a:	94be                	add	s1,s1,a5
    80000c6c:	fb34eae3          	bltu	s1,s3,80000c20 <uvmcopy+0x1e>
    80000c70:	a81d                	j	80000ca6 <uvmcopy+0xa4>
      panic("uvmcopy: pte should exist");
    80000c72:	00007517          	auipc	a0,0x7
    80000c76:	4ae50513          	addi	a0,a0,1198 # 80008120 <etext+0x120>
    80000c7a:	00005097          	auipc	ra,0x5
    80000c7e:	21e080e7          	jalr	542(ra) # 80005e98 <panic>
      panic("uvmcopy: page not present");
    80000c82:	00007517          	auipc	a0,0x7
    80000c86:	4be50513          	addi	a0,a0,1214 # 80008140 <etext+0x140>
    80000c8a:	00005097          	auipc	ra,0x5
    80000c8e:	20e080e7          	jalr	526(ra) # 80005e98 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c92:	4685                	li	a3,1
    80000c94:	00c4d613          	srli	a2,s1,0xc
    80000c98:	4581                	li	a1,0
    80000c9a:	8552                	mv	a0,s4
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	c6e080e7          	jalr	-914(ra) # 8000090a <uvmunmap>
  return -1;
    80000ca4:	5b7d                	li	s6,-1
}
    80000ca6:	855a                	mv	a0,s6
    80000ca8:	70e2                	ld	ra,56(sp)
    80000caa:	7442                	ld	s0,48(sp)
    80000cac:	74a2                	ld	s1,40(sp)
    80000cae:	7902                	ld	s2,32(sp)
    80000cb0:	69e2                	ld	s3,24(sp)
    80000cb2:	6a42                	ld	s4,16(sp)
    80000cb4:	6aa2                	ld	s5,8(sp)
    80000cb6:	6b02                	ld	s6,0(sp)
    80000cb8:	6121                	addi	sp,sp,64
    80000cba:	8082                	ret
  return 0;
    80000cbc:	4b01                	li	s6,0
    80000cbe:	b7e5                	j	80000ca6 <uvmcopy+0xa4>

0000000080000cc0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000cc0:	1141                	addi	sp,sp,-16
    80000cc2:	e406                	sd	ra,8(sp)
    80000cc4:	e022                	sd	s0,0(sp)
    80000cc6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000cc8:	4601                	li	a2,0
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	992080e7          	jalr	-1646(ra) # 8000065c <walk>
  if(pte == 0)
    80000cd2:	c901                	beqz	a0,80000ce2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000cd4:	611c                	ld	a5,0(a0)
    80000cd6:	9bbd                	andi	a5,a5,-17
    80000cd8:	e11c                	sd	a5,0(a0)
}
    80000cda:	60a2                	ld	ra,8(sp)
    80000cdc:	6402                	ld	s0,0(sp)
    80000cde:	0141                	addi	sp,sp,16
    80000ce0:	8082                	ret
    panic("uvmclear");
    80000ce2:	00007517          	auipc	a0,0x7
    80000ce6:	47e50513          	addi	a0,a0,1150 # 80008160 <etext+0x160>
    80000cea:	00005097          	auipc	ra,0x5
    80000cee:	1ae080e7          	jalr	430(ra) # 80005e98 <panic>

0000000080000cf2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cf2:	c6bd                	beqz	a3,80000d60 <copyin+0x6e>
{
    80000cf4:	715d                	addi	sp,sp,-80
    80000cf6:	e486                	sd	ra,72(sp)
    80000cf8:	e0a2                	sd	s0,64(sp)
    80000cfa:	fc26                	sd	s1,56(sp)
    80000cfc:	f84a                	sd	s2,48(sp)
    80000cfe:	f44e                	sd	s3,40(sp)
    80000d00:	f052                	sd	s4,32(sp)
    80000d02:	ec56                	sd	s5,24(sp)
    80000d04:	e85a                	sd	s6,16(sp)
    80000d06:	e45e                	sd	s7,8(sp)
    80000d08:	e062                	sd	s8,0(sp)
    80000d0a:	0880                	addi	s0,sp,80
    80000d0c:	8b2a                	mv	s6,a0
    80000d0e:	8a2e                	mv	s4,a1
    80000d10:	8c32                	mv	s8,a2
    80000d12:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d14:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d16:	6a85                	lui	s5,0x1
    80000d18:	a015                	j	80000d3c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d1a:	9562                	add	a0,a0,s8
    80000d1c:	0004861b          	sext.w	a2,s1
    80000d20:	412505b3          	sub	a1,a0,s2
    80000d24:	8552                	mv	a0,s4
    80000d26:	fffff097          	auipc	ra,0xfffff
    80000d2a:	6ae080e7          	jalr	1710(ra) # 800003d4 <memmove>

    len -= n;
    80000d2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d32:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d34:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d38:	02098263          	beqz	s3,80000d5c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d3c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d40:	85ca                	mv	a1,s2
    80000d42:	855a                	mv	a0,s6
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	9be080e7          	jalr	-1602(ra) # 80000702 <walkaddr>
    if(pa0 == 0)
    80000d4c:	cd01                	beqz	a0,80000d64 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d4e:	418904b3          	sub	s1,s2,s8
    80000d52:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d54:	fc99f3e3          	bgeu	s3,s1,80000d1a <copyin+0x28>
    80000d58:	84ce                	mv	s1,s3
    80000d5a:	b7c1                	j	80000d1a <copyin+0x28>
  }
  return 0;
    80000d5c:	4501                	li	a0,0
    80000d5e:	a021                	j	80000d66 <copyin+0x74>
    80000d60:	4501                	li	a0,0
}
    80000d62:	8082                	ret
      return -1;
    80000d64:	557d                	li	a0,-1
}
    80000d66:	60a6                	ld	ra,72(sp)
    80000d68:	6406                	ld	s0,64(sp)
    80000d6a:	74e2                	ld	s1,56(sp)
    80000d6c:	7942                	ld	s2,48(sp)
    80000d6e:	79a2                	ld	s3,40(sp)
    80000d70:	7a02                	ld	s4,32(sp)
    80000d72:	6ae2                	ld	s5,24(sp)
    80000d74:	6b42                	ld	s6,16(sp)
    80000d76:	6ba2                	ld	s7,8(sp)
    80000d78:	6c02                	ld	s8,0(sp)
    80000d7a:	6161                	addi	sp,sp,80
    80000d7c:	8082                	ret

0000000080000d7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d7e:	c6c5                	beqz	a3,80000e26 <copyinstr+0xa8>
{
    80000d80:	715d                	addi	sp,sp,-80
    80000d82:	e486                	sd	ra,72(sp)
    80000d84:	e0a2                	sd	s0,64(sp)
    80000d86:	fc26                	sd	s1,56(sp)
    80000d88:	f84a                	sd	s2,48(sp)
    80000d8a:	f44e                	sd	s3,40(sp)
    80000d8c:	f052                	sd	s4,32(sp)
    80000d8e:	ec56                	sd	s5,24(sp)
    80000d90:	e85a                	sd	s6,16(sp)
    80000d92:	e45e                	sd	s7,8(sp)
    80000d94:	0880                	addi	s0,sp,80
    80000d96:	8a2a                	mv	s4,a0
    80000d98:	8b2e                	mv	s6,a1
    80000d9a:	8bb2                	mv	s7,a2
    80000d9c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d9e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000da0:	6985                	lui	s3,0x1
    80000da2:	a035                	j	80000dce <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000da4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000da8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000daa:	0017b793          	seqz	a5,a5
    80000dae:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000db2:	60a6                	ld	ra,72(sp)
    80000db4:	6406                	ld	s0,64(sp)
    80000db6:	74e2                	ld	s1,56(sp)
    80000db8:	7942                	ld	s2,48(sp)
    80000dba:	79a2                	ld	s3,40(sp)
    80000dbc:	7a02                	ld	s4,32(sp)
    80000dbe:	6ae2                	ld	s5,24(sp)
    80000dc0:	6b42                	ld	s6,16(sp)
    80000dc2:	6ba2                	ld	s7,8(sp)
    80000dc4:	6161                	addi	sp,sp,80
    80000dc6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dc8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dcc:	c8a9                	beqz	s1,80000e1e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dce:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dd2:	85ca                	mv	a1,s2
    80000dd4:	8552                	mv	a0,s4
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	92c080e7          	jalr	-1748(ra) # 80000702 <walkaddr>
    if(pa0 == 0)
    80000dde:	c131                	beqz	a0,80000e22 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000de0:	41790833          	sub	a6,s2,s7
    80000de4:	984e                	add	a6,a6,s3
    if(n > max)
    80000de6:	0104f363          	bgeu	s1,a6,80000dec <copyinstr+0x6e>
    80000dea:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000dec:	955e                	add	a0,a0,s7
    80000dee:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000df2:	fc080be3          	beqz	a6,80000dc8 <copyinstr+0x4a>
    80000df6:	985a                	add	a6,a6,s6
    80000df8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dfa:	41650633          	sub	a2,a0,s6
    80000dfe:	14fd                	addi	s1,s1,-1
    80000e00:	9b26                	add	s6,s6,s1
    80000e02:	00f60733          	add	a4,a2,a5
    80000e06:	00074703          	lbu	a4,0(a4)
    80000e0a:	df49                	beqz	a4,80000da4 <copyinstr+0x26>
        *dst = *p;
    80000e0c:	00e78023          	sb	a4,0(a5)
      --max;
    80000e10:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e14:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e16:	ff0796e3          	bne	a5,a6,80000e02 <copyinstr+0x84>
      dst++;
    80000e1a:	8b42                	mv	s6,a6
    80000e1c:	b775                	j	80000dc8 <copyinstr+0x4a>
    80000e1e:	4781                	li	a5,0
    80000e20:	b769                	j	80000daa <copyinstr+0x2c>
      return -1;
    80000e22:	557d                	li	a0,-1
    80000e24:	b779                	j	80000db2 <copyinstr+0x34>
  int got_null = 0;
    80000e26:	4781                	li	a5,0
  if(got_null){
    80000e28:	0017b793          	seqz	a5,a5
    80000e2c:	40f00533          	neg	a0,a5
}
    80000e30:	8082                	ret

0000000080000e32 <is_cow_fault>:

int is_cow_fault(pagetable_t pagetable, uint64 va)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e406                	sd	ra,8(sp)
    80000e36:	e022                	sd	s0,0(sp)
    80000e38:	0800                	addi	s0,sp,16
  va = PGROUNDDOWN(va);
  pte_t *pte = walk(pagetable, va, 0);
    80000e3a:	4601                	li	a2,0
    80000e3c:	77fd                	lui	a5,0xfffff
    80000e3e:	8dfd                	and	a1,a1,a5
    80000e40:	00000097          	auipc	ra,0x0
    80000e44:	81c080e7          	jalr	-2020(ra) # 8000065c <walk>
  if(pte == 0)
    80000e48:	c105                	beqz	a0,80000e68 <is_cow_fault+0x36>
    return 0;
  if((*pte & PTE_V) == 0)
    80000e4a:	611c                	ld	a5,0(a0)
    return 0;
  if((*pte & PTE_U) == 0)
    80000e4c:	0117f693          	andi	a3,a5,17
    80000e50:	4745                	li	a4,17
    return 0;
    80000e52:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000e54:	00e68663          	beq	a3,a4,80000e60 <is_cow_fault+0x2e>
  if((*pte & PTE_COW))
    return 1;
  return 0;
}
    80000e58:	60a2                	ld	ra,8(sp)
    80000e5a:	6402                	ld	s0,0(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret
  if((*pte & PTE_COW))
    80000e60:	83a1                	srli	a5,a5,0x8
    return 0;
    80000e62:	0017f513          	andi	a0,a5,1
    80000e66:	bfcd                	j	80000e58 <is_cow_fault+0x26>
    80000e68:	4501                	li	a0,0
    80000e6a:	b7fd                	j	80000e58 <is_cow_fault+0x26>

0000000080000e6c <cow_alloc>:

int cow_alloc(pagetable_t pagetable, uint64 va)
{
    80000e6c:	7139                	addi	sp,sp,-64
    80000e6e:	fc06                	sd	ra,56(sp)
    80000e70:	f822                	sd	s0,48(sp)
    80000e72:	f426                	sd	s1,40(sp)
    80000e74:	f04a                	sd	s2,32(sp)
    80000e76:	ec4e                	sd	s3,24(sp)
    80000e78:	e852                	sd	s4,16(sp)
    80000e7a:	e456                	sd	s5,8(sp)
    80000e7c:	0080                	addi	s0,sp,64
    80000e7e:	8a2a                	mv	s4,a0
  va = PGROUNDDOWN(va); 
    80000e80:	79fd                	lui	s3,0xfffff
    80000e82:	0135f9b3          	and	s3,a1,s3
  pte_t *pte;
  char *mem;
  if((pte = walk(pagetable, va, 0)) == 0)//返回页表中对应的虚拟地址的页表项
    80000e86:	4601                	li	a2,0
    80000e88:	85ce                	mv	a1,s3
    80000e8a:	fffff097          	auipc	ra,0xfffff
    80000e8e:	7d2080e7          	jalr	2002(ra) # 8000065c <walk>
    80000e92:	c12d                	beqz	a0,80000ef4 <cow_alloc+0x88>
      panic("uvmcopy: pte should exist");
  uint64 pa = PTE2PA(*pte);
    80000e94:	6118                	ld	a4,0(a0)
    80000e96:	00a75593          	srli	a1,a4,0xa
    80000e9a:	00c59a93          	slli	s5,a1,0xc

  uint flags = PTE_FLAGS(*pte);
  flags &= ~(PTE_COW);
    80000e9e:	2ff77713          	andi	a4,a4,767
  flags |= PTE_W;
    80000ea2:	00476493          	ori	s1,a4,4

  if((mem = kalloc()) == 0)//分配物理页面
    80000ea6:	fffff097          	auipc	ra,0xfffff
    80000eaa:	464080e7          	jalr	1124(ra) # 8000030a <kalloc>
    80000eae:	892a                	mv	s2,a0
    80000eb0:	c12d                	beqz	a0,80000f12 <cow_alloc+0xa6>
    goto err;
  memmove(mem, (char*)pa, PGSIZE);//把src的内容复制到dst上
    80000eb2:	6605                	lui	a2,0x1
    80000eb4:	85d6                	mv	a1,s5
    80000eb6:	fffff097          	auipc	ra,0xfffff
    80000eba:	51e080e7          	jalr	1310(ra) # 800003d4 <memmove>
  uvmunmap(pagetable, va, 1, 1);
    80000ebe:	4685                	li	a3,1
    80000ec0:	4605                	li	a2,1
    80000ec2:	85ce                	mv	a1,s3
    80000ec4:	8552                	mv	a0,s4
    80000ec6:	00000097          	auipc	ra,0x0
    80000eca:	a44080e7          	jalr	-1468(ra) # 8000090a <uvmunmap>
  if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0){
    80000ece:	8726                	mv	a4,s1
    80000ed0:	86ca                	mv	a3,s2
    80000ed2:	6605                	lui	a2,0x1
    80000ed4:	85ce                	mv	a1,s3
    80000ed6:	8552                	mv	a0,s4
    80000ed8:	00000097          	auipc	ra,0x0
    80000edc:	86c080e7          	jalr	-1940(ra) # 80000744 <mappages>
    80000ee0:	e115                	bnez	a0,80000f04 <cow_alloc+0x98>
  }
  return 0;

  err:
    return -1;
    80000ee2:	70e2                	ld	ra,56(sp)
    80000ee4:	7442                	ld	s0,48(sp)
    80000ee6:	74a2                	ld	s1,40(sp)
    80000ee8:	7902                	ld	s2,32(sp)
    80000eea:	69e2                	ld	s3,24(sp)
    80000eec:	6a42                	ld	s4,16(sp)
    80000eee:	6aa2                	ld	s5,8(sp)
    80000ef0:	6121                	addi	sp,sp,64
    80000ef2:	8082                	ret
      panic("uvmcopy: pte should exist");
    80000ef4:	00007517          	auipc	a0,0x7
    80000ef8:	22c50513          	addi	a0,a0,556 # 80008120 <etext+0x120>
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	f9c080e7          	jalr	-100(ra) # 80005e98 <panic>
    kfree(mem);
    80000f04:	854a                	mv	a0,s2
    80000f06:	fffff097          	auipc	ra,0xfffff
    80000f0a:	23e080e7          	jalr	574(ra) # 80000144 <kfree>
    return -1;
    80000f0e:	557d                	li	a0,-1
    goto err;
    80000f10:	bfc9                	j	80000ee2 <cow_alloc+0x76>
    return -1;
    80000f12:	557d                	li	a0,-1
    80000f14:	b7f9                	j	80000ee2 <cow_alloc+0x76>

0000000080000f16 <copyout>:
  while(len > 0){
    80000f16:	c2c5                	beqz	a3,80000fb6 <copyout+0xa0>
{
    80000f18:	715d                	addi	sp,sp,-80
    80000f1a:	e486                	sd	ra,72(sp)
    80000f1c:	e0a2                	sd	s0,64(sp)
    80000f1e:	fc26                	sd	s1,56(sp)
    80000f20:	f84a                	sd	s2,48(sp)
    80000f22:	f44e                	sd	s3,40(sp)
    80000f24:	f052                	sd	s4,32(sp)
    80000f26:	ec56                	sd	s5,24(sp)
    80000f28:	e85a                	sd	s6,16(sp)
    80000f2a:	e45e                	sd	s7,8(sp)
    80000f2c:	e062                	sd	s8,0(sp)
    80000f2e:	0880                	addi	s0,sp,80
    80000f30:	8b2a                	mv	s6,a0
    80000f32:	89ae                	mv	s3,a1
    80000f34:	8ab2                	mv	s5,a2
    80000f36:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000f38:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80000f3a:	6b85                	lui	s7,0x1
    80000f3c:	a825                	j	80000f74 <copyout+0x5e>
        printf("copyout: cow_alloc fail!\n");
    80000f3e:	00007517          	auipc	a0,0x7
    80000f42:	23250513          	addi	a0,a0,562 # 80008170 <etext+0x170>
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	f9c080e7          	jalr	-100(ra) # 80005ee2 <printf>
        return -1;
    80000f4e:	557d                	li	a0,-1
    80000f50:	a0b5                	j	80000fbc <copyout+0xa6>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000f52:	412989b3          	sub	s3,s3,s2
    80000f56:	0004861b          	sext.w	a2,s1
    80000f5a:	85d6                	mv	a1,s5
    80000f5c:	954e                	add	a0,a0,s3
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	476080e7          	jalr	1142(ra) # 800003d4 <memmove>
    len -= n;
    80000f66:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000f6a:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000f6c:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000f70:	040a0163          	beqz	s4,80000fb2 <copyout+0x9c>
    va0 = PGROUNDDOWN(dstva);
    80000f74:	0189f933          	and	s2,s3,s8
    if(is_cow_fault(pagetable, va0))
    80000f78:	85ca                	mv	a1,s2
    80000f7a:	855a                	mv	a0,s6
    80000f7c:	00000097          	auipc	ra,0x0
    80000f80:	eb6080e7          	jalr	-330(ra) # 80000e32 <is_cow_fault>
    80000f84:	c909                	beqz	a0,80000f96 <copyout+0x80>
      if(cow_alloc(pagetable, va0) < 0)
    80000f86:	85ca                	mv	a1,s2
    80000f88:	855a                	mv	a0,s6
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	ee2080e7          	jalr	-286(ra) # 80000e6c <cow_alloc>
    80000f92:	fa0546e3          	bltz	a0,80000f3e <copyout+0x28>
    pa0 = walkaddr(pagetable, va0);
    80000f96:	85ca                	mv	a1,s2
    80000f98:	855a                	mv	a0,s6
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	768080e7          	jalr	1896(ra) # 80000702 <walkaddr>
    if(pa0 == 0)
    80000fa2:	cd01                	beqz	a0,80000fba <copyout+0xa4>
    n = PGSIZE - (dstva - va0);
    80000fa4:	413904b3          	sub	s1,s2,s3
    80000fa8:	94de                	add	s1,s1,s7
    if(n > len)
    80000faa:	fa9a74e3          	bgeu	s4,s1,80000f52 <copyout+0x3c>
    80000fae:	84d2                	mv	s1,s4
    80000fb0:	b74d                	j	80000f52 <copyout+0x3c>
  return 0;
    80000fb2:	4501                	li	a0,0
    80000fb4:	a021                	j	80000fbc <copyout+0xa6>
    80000fb6:	4501                	li	a0,0
}
    80000fb8:	8082                	ret
      return -1;
    80000fba:	557d                	li	a0,-1
}
    80000fbc:	60a6                	ld	ra,72(sp)
    80000fbe:	6406                	ld	s0,64(sp)
    80000fc0:	74e2                	ld	s1,56(sp)
    80000fc2:	7942                	ld	s2,48(sp)
    80000fc4:	79a2                	ld	s3,40(sp)
    80000fc6:	7a02                	ld	s4,32(sp)
    80000fc8:	6ae2                	ld	s5,24(sp)
    80000fca:	6b42                	ld	s6,16(sp)
    80000fcc:	6ba2                	ld	s7,8(sp)
    80000fce:	6c02                	ld	s8,0(sp)
    80000fd0:	6161                	addi	sp,sp,80
    80000fd2:	8082                	ret

0000000080000fd4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000fd4:	7139                	addi	sp,sp,-64
    80000fd6:	fc06                	sd	ra,56(sp)
    80000fd8:	f822                	sd	s0,48(sp)
    80000fda:	f426                	sd	s1,40(sp)
    80000fdc:	f04a                	sd	s2,32(sp)
    80000fde:	ec4e                	sd	s3,24(sp)
    80000fe0:	e852                	sd	s4,16(sp)
    80000fe2:	e456                	sd	s5,8(sp)
    80000fe4:	e05a                	sd	s6,0(sp)
    80000fe6:	0080                	addi	s0,sp,64
    80000fe8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fea:	00008497          	auipc	s1,0x8
    80000fee:	4ae48493          	addi	s1,s1,1198 # 80009498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ff2:	8b26                	mv	s6,s1
    80000ff4:	00007a97          	auipc	s5,0x7
    80000ff8:	00ca8a93          	addi	s5,s5,12 # 80008000 <etext>
    80000ffc:	04000937          	lui	s2,0x4000
    80001000:	197d                	addi	s2,s2,-1
    80001002:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001004:	0000ea17          	auipc	s4,0xe
    80001008:	e94a0a13          	addi	s4,s4,-364 # 8000ee98 <tickslock>
    char *pa = kalloc();
    8000100c:	fffff097          	auipc	ra,0xfffff
    80001010:	2fe080e7          	jalr	766(ra) # 8000030a <kalloc>
    80001014:	862a                	mv	a2,a0
    if(pa == 0)
    80001016:	c131                	beqz	a0,8000105a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001018:	416485b3          	sub	a1,s1,s6
    8000101c:	858d                	srai	a1,a1,0x3
    8000101e:	000ab783          	ld	a5,0(s5)
    80001022:	02f585b3          	mul	a1,a1,a5
    80001026:	2585                	addiw	a1,a1,1
    80001028:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000102c:	4719                	li	a4,6
    8000102e:	6685                	lui	a3,0x1
    80001030:	40b905b3          	sub	a1,s2,a1
    80001034:	854e                	mv	a0,s3
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	7ae080e7          	jalr	1966(ra) # 800007e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000103e:	16848493          	addi	s1,s1,360
    80001042:	fd4495e3          	bne	s1,s4,8000100c <proc_mapstacks+0x38>
  }
}
    80001046:	70e2                	ld	ra,56(sp)
    80001048:	7442                	ld	s0,48(sp)
    8000104a:	74a2                	ld	s1,40(sp)
    8000104c:	7902                	ld	s2,32(sp)
    8000104e:	69e2                	ld	s3,24(sp)
    80001050:	6a42                	ld	s4,16(sp)
    80001052:	6aa2                	ld	s5,8(sp)
    80001054:	6b02                	ld	s6,0(sp)
    80001056:	6121                	addi	sp,sp,64
    80001058:	8082                	ret
      panic("kalloc");
    8000105a:	00007517          	auipc	a0,0x7
    8000105e:	13650513          	addi	a0,a0,310 # 80008190 <etext+0x190>
    80001062:	00005097          	auipc	ra,0x5
    80001066:	e36080e7          	jalr	-458(ra) # 80005e98 <panic>

000000008000106a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    8000106a:	7139                	addi	sp,sp,-64
    8000106c:	fc06                	sd	ra,56(sp)
    8000106e:	f822                	sd	s0,48(sp)
    80001070:	f426                	sd	s1,40(sp)
    80001072:	f04a                	sd	s2,32(sp)
    80001074:	ec4e                	sd	s3,24(sp)
    80001076:	e852                	sd	s4,16(sp)
    80001078:	e456                	sd	s5,8(sp)
    8000107a:	e05a                	sd	s6,0(sp)
    8000107c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000107e:	00007597          	auipc	a1,0x7
    80001082:	11a58593          	addi	a1,a1,282 # 80008198 <etext+0x198>
    80001086:	00008517          	auipc	a0,0x8
    8000108a:	fe250513          	addi	a0,a0,-30 # 80009068 <pid_lock>
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	2c4080e7          	jalr	708(ra) # 80006352 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001096:	00007597          	auipc	a1,0x7
    8000109a:	10a58593          	addi	a1,a1,266 # 800081a0 <etext+0x1a0>
    8000109e:	00008517          	auipc	a0,0x8
    800010a2:	fe250513          	addi	a0,a0,-30 # 80009080 <wait_lock>
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	2ac080e7          	jalr	684(ra) # 80006352 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ae:	00008497          	auipc	s1,0x8
    800010b2:	3ea48493          	addi	s1,s1,1002 # 80009498 <proc>
      initlock(&p->lock, "proc");
    800010b6:	00007b17          	auipc	s6,0x7
    800010ba:	0fab0b13          	addi	s6,s6,250 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    800010be:	8aa6                	mv	s5,s1
    800010c0:	00007a17          	auipc	s4,0x7
    800010c4:	f40a0a13          	addi	s4,s4,-192 # 80008000 <etext>
    800010c8:	04000937          	lui	s2,0x4000
    800010cc:	197d                	addi	s2,s2,-1
    800010ce:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	0000e997          	auipc	s3,0xe
    800010d4:	dc898993          	addi	s3,s3,-568 # 8000ee98 <tickslock>
      initlock(&p->lock, "proc");
    800010d8:	85da                	mv	a1,s6
    800010da:	8526                	mv	a0,s1
    800010dc:	00005097          	auipc	ra,0x5
    800010e0:	276080e7          	jalr	630(ra) # 80006352 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    800010e4:	415487b3          	sub	a5,s1,s5
    800010e8:	878d                	srai	a5,a5,0x3
    800010ea:	000a3703          	ld	a4,0(s4)
    800010ee:	02e787b3          	mul	a5,a5,a4
    800010f2:	2785                	addiw	a5,a5,1
    800010f4:	00d7979b          	slliw	a5,a5,0xd
    800010f8:	40f907b3          	sub	a5,s2,a5
    800010fc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010fe:	16848493          	addi	s1,s1,360
    80001102:	fd349be3          	bne	s1,s3,800010d8 <procinit+0x6e>
  }
}
    80001106:	70e2                	ld	ra,56(sp)
    80001108:	7442                	ld	s0,48(sp)
    8000110a:	74a2                	ld	s1,40(sp)
    8000110c:	7902                	ld	s2,32(sp)
    8000110e:	69e2                	ld	s3,24(sp)
    80001110:	6a42                	ld	s4,16(sp)
    80001112:	6aa2                	ld	s5,8(sp)
    80001114:	6b02                	ld	s6,0(sp)
    80001116:	6121                	addi	sp,sp,64
    80001118:	8082                	ret

000000008000111a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000111a:	1141                	addi	sp,sp,-16
    8000111c:	e422                	sd	s0,8(sp)
    8000111e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001120:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001122:	2501                	sext.w	a0,a0
    80001124:	6422                	ld	s0,8(sp)
    80001126:	0141                	addi	sp,sp,16
    80001128:	8082                	ret

000000008000112a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000112a:	1141                	addi	sp,sp,-16
    8000112c:	e422                	sd	s0,8(sp)
    8000112e:	0800                	addi	s0,sp,16
    80001130:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001132:	2781                	sext.w	a5,a5
    80001134:	079e                	slli	a5,a5,0x7
  return c;
}
    80001136:	00008517          	auipc	a0,0x8
    8000113a:	f6250513          	addi	a0,a0,-158 # 80009098 <cpus>
    8000113e:	953e                	add	a0,a0,a5
    80001140:	6422                	ld	s0,8(sp)
    80001142:	0141                	addi	sp,sp,16
    80001144:	8082                	ret

0000000080001146 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001146:	1101                	addi	sp,sp,-32
    80001148:	ec06                	sd	ra,24(sp)
    8000114a:	e822                	sd	s0,16(sp)
    8000114c:	e426                	sd	s1,8(sp)
    8000114e:	1000                	addi	s0,sp,32
  push_off();
    80001150:	00005097          	auipc	ra,0x5
    80001154:	246080e7          	jalr	582(ra) # 80006396 <push_off>
    80001158:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000115a:	2781                	sext.w	a5,a5
    8000115c:	079e                	slli	a5,a5,0x7
    8000115e:	00008717          	auipc	a4,0x8
    80001162:	f0a70713          	addi	a4,a4,-246 # 80009068 <pid_lock>
    80001166:	97ba                	add	a5,a5,a4
    80001168:	7b84                	ld	s1,48(a5)
  pop_off();
    8000116a:	00005097          	auipc	ra,0x5
    8000116e:	2cc080e7          	jalr	716(ra) # 80006436 <pop_off>
  return p;
}
    80001172:	8526                	mv	a0,s1
    80001174:	60e2                	ld	ra,24(sp)
    80001176:	6442                	ld	s0,16(sp)
    80001178:	64a2                	ld	s1,8(sp)
    8000117a:	6105                	addi	sp,sp,32
    8000117c:	8082                	ret

000000008000117e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000117e:	1141                	addi	sp,sp,-16
    80001180:	e406                	sd	ra,8(sp)
    80001182:	e022                	sd	s0,0(sp)
    80001184:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	fc0080e7          	jalr	-64(ra) # 80001146 <myproc>
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	308080e7          	jalr	776(ra) # 80006496 <release>

  if (first) {
    80001196:	00007797          	auipc	a5,0x7
    8000119a:	6da7a783          	lw	a5,1754(a5) # 80008870 <first.1680>
    8000119e:	eb89                	bnez	a5,800011b0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800011a0:	00001097          	auipc	ra,0x1
    800011a4:	c0a080e7          	jalr	-1014(ra) # 80001daa <usertrapret>
}
    800011a8:	60a2                	ld	ra,8(sp)
    800011aa:	6402                	ld	s0,0(sp)
    800011ac:	0141                	addi	sp,sp,16
    800011ae:	8082                	ret
    first = 0;
    800011b0:	00007797          	auipc	a5,0x7
    800011b4:	6c07a023          	sw	zero,1728(a5) # 80008870 <first.1680>
    fsinit(ROOTDEV);
    800011b8:	4505                	li	a0,1
    800011ba:	00002097          	auipc	ra,0x2
    800011be:	9b6080e7          	jalr	-1610(ra) # 80002b70 <fsinit>
    800011c2:	bff9                	j	800011a0 <forkret+0x22>

00000000800011c4 <allocpid>:
allocpid() {
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011d0:	00008917          	auipc	s2,0x8
    800011d4:	e9890913          	addi	s2,s2,-360 # 80009068 <pid_lock>
    800011d8:	854a                	mv	a0,s2
    800011da:	00005097          	auipc	ra,0x5
    800011de:	208080e7          	jalr	520(ra) # 800063e2 <acquire>
  pid = nextpid;
    800011e2:	00007797          	auipc	a5,0x7
    800011e6:	69278793          	addi	a5,a5,1682 # 80008874 <nextpid>
    800011ea:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011ec:	0014871b          	addiw	a4,s1,1
    800011f0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011f2:	854a                	mv	a0,s2
    800011f4:	00005097          	auipc	ra,0x5
    800011f8:	2a2080e7          	jalr	674(ra) # 80006496 <release>
}
    800011fc:	8526                	mv	a0,s1
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6902                	ld	s2,0(sp)
    80001206:	6105                	addi	sp,sp,32
    80001208:	8082                	ret

000000008000120a <proc_pagetable>:
{
    8000120a:	1101                	addi	sp,sp,-32
    8000120c:	ec06                	sd	ra,24(sp)
    8000120e:	e822                	sd	s0,16(sp)
    80001210:	e426                	sd	s1,8(sp)
    80001212:	e04a                	sd	s2,0(sp)
    80001214:	1000                	addi	s0,sp,32
    80001216:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	7b6080e7          	jalr	1974(ra) # 800009ce <uvmcreate>
    80001220:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001222:	c121                	beqz	a0,80001262 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001224:	4729                	li	a4,10
    80001226:	00006697          	auipc	a3,0x6
    8000122a:	dda68693          	addi	a3,a3,-550 # 80007000 <_trampoline>
    8000122e:	6605                	lui	a2,0x1
    80001230:	040005b7          	lui	a1,0x4000
    80001234:	15fd                	addi	a1,a1,-1
    80001236:	05b2                	slli	a1,a1,0xc
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	50c080e7          	jalr	1292(ra) # 80000744 <mappages>
    80001240:	02054863          	bltz	a0,80001270 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001244:	4719                	li	a4,6
    80001246:	05893683          	ld	a3,88(s2)
    8000124a:	6605                	lui	a2,0x1
    8000124c:	020005b7          	lui	a1,0x2000
    80001250:	15fd                	addi	a1,a1,-1
    80001252:	05b6                	slli	a1,a1,0xd
    80001254:	8526                	mv	a0,s1
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	4ee080e7          	jalr	1262(ra) # 80000744 <mappages>
    8000125e:	02054163          	bltz	a0,80001280 <proc_pagetable+0x76>
}
    80001262:	8526                	mv	a0,s1
    80001264:	60e2                	ld	ra,24(sp)
    80001266:	6442                	ld	s0,16(sp)
    80001268:	64a2                	ld	s1,8(sp)
    8000126a:	6902                	ld	s2,0(sp)
    8000126c:	6105                	addi	sp,sp,32
    8000126e:	8082                	ret
    uvmfree(pagetable, 0);
    80001270:	4581                	li	a1,0
    80001272:	8526                	mv	a0,s1
    80001274:	00000097          	auipc	ra,0x0
    80001278:	956080e7          	jalr	-1706(ra) # 80000bca <uvmfree>
    return 0;
    8000127c:	4481                	li	s1,0
    8000127e:	b7d5                	j	80001262 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001280:	4681                	li	a3,0
    80001282:	4605                	li	a2,1
    80001284:	040005b7          	lui	a1,0x4000
    80001288:	15fd                	addi	a1,a1,-1
    8000128a:	05b2                	slli	a1,a1,0xc
    8000128c:	8526                	mv	a0,s1
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	67c080e7          	jalr	1660(ra) # 8000090a <uvmunmap>
    uvmfree(pagetable, 0);
    80001296:	4581                	li	a1,0
    80001298:	8526                	mv	a0,s1
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	930080e7          	jalr	-1744(ra) # 80000bca <uvmfree>
    return 0;
    800012a2:	4481                	li	s1,0
    800012a4:	bf7d                	j	80001262 <proc_pagetable+0x58>

00000000800012a6 <proc_freepagetable>:
{
    800012a6:	1101                	addi	sp,sp,-32
    800012a8:	ec06                	sd	ra,24(sp)
    800012aa:	e822                	sd	s0,16(sp)
    800012ac:	e426                	sd	s1,8(sp)
    800012ae:	e04a                	sd	s2,0(sp)
    800012b0:	1000                	addi	s0,sp,32
    800012b2:	84aa                	mv	s1,a0
    800012b4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012b6:	4681                	li	a3,0
    800012b8:	4605                	li	a2,1
    800012ba:	040005b7          	lui	a1,0x4000
    800012be:	15fd                	addi	a1,a1,-1
    800012c0:	05b2                	slli	a1,a1,0xc
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	648080e7          	jalr	1608(ra) # 8000090a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012ca:	4681                	li	a3,0
    800012cc:	4605                	li	a2,1
    800012ce:	020005b7          	lui	a1,0x2000
    800012d2:	15fd                	addi	a1,a1,-1
    800012d4:	05b6                	slli	a1,a1,0xd
    800012d6:	8526                	mv	a0,s1
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	632080e7          	jalr	1586(ra) # 8000090a <uvmunmap>
  uvmfree(pagetable, sz);
    800012e0:	85ca                	mv	a1,s2
    800012e2:	8526                	mv	a0,s1
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	8e6080e7          	jalr	-1818(ra) # 80000bca <uvmfree>
}
    800012ec:	60e2                	ld	ra,24(sp)
    800012ee:	6442                	ld	s0,16(sp)
    800012f0:	64a2                	ld	s1,8(sp)
    800012f2:	6902                	ld	s2,0(sp)
    800012f4:	6105                	addi	sp,sp,32
    800012f6:	8082                	ret

00000000800012f8 <freeproc>:
{
    800012f8:	1101                	addi	sp,sp,-32
    800012fa:	ec06                	sd	ra,24(sp)
    800012fc:	e822                	sd	s0,16(sp)
    800012fe:	e426                	sd	s1,8(sp)
    80001300:	1000                	addi	s0,sp,32
    80001302:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001304:	6d28                	ld	a0,88(a0)
    80001306:	c509                	beqz	a0,80001310 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	e3c080e7          	jalr	-452(ra) # 80000144 <kfree>
  p->trapframe = 0;
    80001310:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001314:	68a8                	ld	a0,80(s1)
    80001316:	c511                	beqz	a0,80001322 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001318:	64ac                	ld	a1,72(s1)
    8000131a:	00000097          	auipc	ra,0x0
    8000131e:	f8c080e7          	jalr	-116(ra) # 800012a6 <proc_freepagetable>
  p->pagetable = 0;
    80001322:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001326:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000132a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000132e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001332:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001336:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000133a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000133e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001342:	0004ac23          	sw	zero,24(s1)
}
    80001346:	60e2                	ld	ra,24(sp)
    80001348:	6442                	ld	s0,16(sp)
    8000134a:	64a2                	ld	s1,8(sp)
    8000134c:	6105                	addi	sp,sp,32
    8000134e:	8082                	ret

0000000080001350 <allocproc>:
{
    80001350:	1101                	addi	sp,sp,-32
    80001352:	ec06                	sd	ra,24(sp)
    80001354:	e822                	sd	s0,16(sp)
    80001356:	e426                	sd	s1,8(sp)
    80001358:	e04a                	sd	s2,0(sp)
    8000135a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000135c:	00008497          	auipc	s1,0x8
    80001360:	13c48493          	addi	s1,s1,316 # 80009498 <proc>
    80001364:	0000e917          	auipc	s2,0xe
    80001368:	b3490913          	addi	s2,s2,-1228 # 8000ee98 <tickslock>
    acquire(&p->lock);
    8000136c:	8526                	mv	a0,s1
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	074080e7          	jalr	116(ra) # 800063e2 <acquire>
    if(p->state == UNUSED) {
    80001376:	4c9c                	lw	a5,24(s1)
    80001378:	cf81                	beqz	a5,80001390 <allocproc+0x40>
      release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	11a080e7          	jalr	282(ra) # 80006496 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001384:	16848493          	addi	s1,s1,360
    80001388:	ff2492e3          	bne	s1,s2,8000136c <allocproc+0x1c>
  return 0;
    8000138c:	4481                	li	s1,0
    8000138e:	a889                	j	800013e0 <allocproc+0x90>
  p->pid = allocpid();
    80001390:	00000097          	auipc	ra,0x0
    80001394:	e34080e7          	jalr	-460(ra) # 800011c4 <allocpid>
    80001398:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000139a:	4785                	li	a5,1
    8000139c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	f6c080e7          	jalr	-148(ra) # 8000030a <kalloc>
    800013a6:	892a                	mv	s2,a0
    800013a8:	eca8                	sd	a0,88(s1)
    800013aa:	c131                	beqz	a0,800013ee <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00000097          	auipc	ra,0x0
    800013b2:	e5c080e7          	jalr	-420(ra) # 8000120a <proc_pagetable>
    800013b6:	892a                	mv	s2,a0
    800013b8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800013ba:	c531                	beqz	a0,80001406 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013bc:	07000613          	li	a2,112
    800013c0:	4581                	li	a1,0
    800013c2:	06048513          	addi	a0,s1,96
    800013c6:	fffff097          	auipc	ra,0xfffff
    800013ca:	fae080e7          	jalr	-82(ra) # 80000374 <memset>
  p->context.ra = (uint64)forkret;
    800013ce:	00000797          	auipc	a5,0x0
    800013d2:	db078793          	addi	a5,a5,-592 # 8000117e <forkret>
    800013d6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013d8:	60bc                	ld	a5,64(s1)
    800013da:	6705                	lui	a4,0x1
    800013dc:	97ba                	add	a5,a5,a4
    800013de:	f4bc                	sd	a5,104(s1)
}
    800013e0:	8526                	mv	a0,s1
    800013e2:	60e2                	ld	ra,24(sp)
    800013e4:	6442                	ld	s0,16(sp)
    800013e6:	64a2                	ld	s1,8(sp)
    800013e8:	6902                	ld	s2,0(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret
    freeproc(p);
    800013ee:	8526                	mv	a0,s1
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	f08080e7          	jalr	-248(ra) # 800012f8 <freeproc>
    release(&p->lock);
    800013f8:	8526                	mv	a0,s1
    800013fa:	00005097          	auipc	ra,0x5
    800013fe:	09c080e7          	jalr	156(ra) # 80006496 <release>
    return 0;
    80001402:	84ca                	mv	s1,s2
    80001404:	bff1                	j	800013e0 <allocproc+0x90>
    freeproc(p);
    80001406:	8526                	mv	a0,s1
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	ef0080e7          	jalr	-272(ra) # 800012f8 <freeproc>
    release(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	00005097          	auipc	ra,0x5
    80001416:	084080e7          	jalr	132(ra) # 80006496 <release>
    return 0;
    8000141a:	84ca                	mv	s1,s2
    8000141c:	b7d1                	j	800013e0 <allocproc+0x90>

000000008000141e <userinit>:
{
    8000141e:	1101                	addi	sp,sp,-32
    80001420:	ec06                	sd	ra,24(sp)
    80001422:	e822                	sd	s0,16(sp)
    80001424:	e426                	sd	s1,8(sp)
    80001426:	1000                	addi	s0,sp,32
  p = allocproc();
    80001428:	00000097          	auipc	ra,0x0
    8000142c:	f28080e7          	jalr	-216(ra) # 80001350 <allocproc>
    80001430:	84aa                	mv	s1,a0
  initproc = p;
    80001432:	00008797          	auipc	a5,0x8
    80001436:	bca7bf23          	sd	a0,-1058(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000143a:	03400613          	li	a2,52
    8000143e:	00007597          	auipc	a1,0x7
    80001442:	44258593          	addi	a1,a1,1090 # 80008880 <initcode>
    80001446:	6928                	ld	a0,80(a0)
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	5b4080e7          	jalr	1460(ra) # 800009fc <uvminit>
  p->sz = PGSIZE;
    80001450:	6785                	lui	a5,0x1
    80001452:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001454:	6cb8                	ld	a4,88(s1)
    80001456:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000145a:	6cb8                	ld	a4,88(s1)
    8000145c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000145e:	4641                	li	a2,16
    80001460:	00007597          	auipc	a1,0x7
    80001464:	d5858593          	addi	a1,a1,-680 # 800081b8 <etext+0x1b8>
    80001468:	15848513          	addi	a0,s1,344
    8000146c:	fffff097          	auipc	ra,0xfffff
    80001470:	05a080e7          	jalr	90(ra) # 800004c6 <safestrcpy>
  p->cwd = namei("/");
    80001474:	00007517          	auipc	a0,0x7
    80001478:	d5450513          	addi	a0,a0,-684 # 800081c8 <etext+0x1c8>
    8000147c:	00002097          	auipc	ra,0x2
    80001480:	122080e7          	jalr	290(ra) # 8000359e <namei>
    80001484:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001488:	478d                	li	a5,3
    8000148a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000148c:	8526                	mv	a0,s1
    8000148e:	00005097          	auipc	ra,0x5
    80001492:	008080e7          	jalr	8(ra) # 80006496 <release>
}
    80001496:	60e2                	ld	ra,24(sp)
    80001498:	6442                	ld	s0,16(sp)
    8000149a:	64a2                	ld	s1,8(sp)
    8000149c:	6105                	addi	sp,sp,32
    8000149e:	8082                	ret

00000000800014a0 <growproc>:
{
    800014a0:	1101                	addi	sp,sp,-32
    800014a2:	ec06                	sd	ra,24(sp)
    800014a4:	e822                	sd	s0,16(sp)
    800014a6:	e426                	sd	s1,8(sp)
    800014a8:	e04a                	sd	s2,0(sp)
    800014aa:	1000                	addi	s0,sp,32
    800014ac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	c98080e7          	jalr	-872(ra) # 80001146 <myproc>
    800014b6:	892a                	mv	s2,a0
  sz = p->sz;
    800014b8:	652c                	ld	a1,72(a0)
    800014ba:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800014be:	00904f63          	bgtz	s1,800014dc <growproc+0x3c>
  } else if(n < 0){
    800014c2:	0204cc63          	bltz	s1,800014fa <growproc+0x5a>
  p->sz = sz;
    800014c6:	1602                	slli	a2,a2,0x20
    800014c8:	9201                	srli	a2,a2,0x20
    800014ca:	04c93423          	sd	a2,72(s2)
  return 0;
    800014ce:	4501                	li	a0,0
}
    800014d0:	60e2                	ld	ra,24(sp)
    800014d2:	6442                	ld	s0,16(sp)
    800014d4:	64a2                	ld	s1,8(sp)
    800014d6:	6902                	ld	s2,0(sp)
    800014d8:	6105                	addi	sp,sp,32
    800014da:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800014dc:	9e25                	addw	a2,a2,s1
    800014de:	1602                	slli	a2,a2,0x20
    800014e0:	9201                	srli	a2,a2,0x20
    800014e2:	1582                	slli	a1,a1,0x20
    800014e4:	9181                	srli	a1,a1,0x20
    800014e6:	6928                	ld	a0,80(a0)
    800014e8:	fffff097          	auipc	ra,0xfffff
    800014ec:	5ce080e7          	jalr	1486(ra) # 80000ab6 <uvmalloc>
    800014f0:	0005061b          	sext.w	a2,a0
    800014f4:	fa69                	bnez	a2,800014c6 <growproc+0x26>
      return -1;
    800014f6:	557d                	li	a0,-1
    800014f8:	bfe1                	j	800014d0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014fa:	9e25                	addw	a2,a2,s1
    800014fc:	1602                	slli	a2,a2,0x20
    800014fe:	9201                	srli	a2,a2,0x20
    80001500:	1582                	slli	a1,a1,0x20
    80001502:	9181                	srli	a1,a1,0x20
    80001504:	6928                	ld	a0,80(a0)
    80001506:	fffff097          	auipc	ra,0xfffff
    8000150a:	568080e7          	jalr	1384(ra) # 80000a6e <uvmdealloc>
    8000150e:	0005061b          	sext.w	a2,a0
    80001512:	bf55                	j	800014c6 <growproc+0x26>

0000000080001514 <fork>:
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	e052                	sd	s4,0(sp)
    80001522:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	c22080e7          	jalr	-990(ra) # 80001146 <myproc>
    8000152c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	e22080e7          	jalr	-478(ra) # 80001350 <allocproc>
    80001536:	10050b63          	beqz	a0,8000164c <fork+0x138>
    8000153a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000153c:	04893603          	ld	a2,72(s2)
    80001540:	692c                	ld	a1,80(a0)
    80001542:	05093503          	ld	a0,80(s2)
    80001546:	fffff097          	auipc	ra,0xfffff
    8000154a:	6bc080e7          	jalr	1724(ra) # 80000c02 <uvmcopy>
    8000154e:	04054663          	bltz	a0,8000159a <fork+0x86>
  np->sz = p->sz;
    80001552:	04893783          	ld	a5,72(s2)
    80001556:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000155a:	05893683          	ld	a3,88(s2)
    8000155e:	87b6                	mv	a5,a3
    80001560:	0589b703          	ld	a4,88(s3)
    80001564:	12068693          	addi	a3,a3,288
    80001568:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000156c:	6788                	ld	a0,8(a5)
    8000156e:	6b8c                	ld	a1,16(a5)
    80001570:	6f90                	ld	a2,24(a5)
    80001572:	01073023          	sd	a6,0(a4)
    80001576:	e708                	sd	a0,8(a4)
    80001578:	eb0c                	sd	a1,16(a4)
    8000157a:	ef10                	sd	a2,24(a4)
    8000157c:	02078793          	addi	a5,a5,32
    80001580:	02070713          	addi	a4,a4,32
    80001584:	fed792e3          	bne	a5,a3,80001568 <fork+0x54>
  np->trapframe->a0 = 0;
    80001588:	0589b783          	ld	a5,88(s3)
    8000158c:	0607b823          	sd	zero,112(a5)
    80001590:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001594:	15000a13          	li	s4,336
    80001598:	a03d                	j	800015c6 <fork+0xb2>
    freeproc(np);
    8000159a:	854e                	mv	a0,s3
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	d5c080e7          	jalr	-676(ra) # 800012f8 <freeproc>
    release(&np->lock);
    800015a4:	854e                	mv	a0,s3
    800015a6:	00005097          	auipc	ra,0x5
    800015aa:	ef0080e7          	jalr	-272(ra) # 80006496 <release>
    return -1;
    800015ae:	5a7d                	li	s4,-1
    800015b0:	a069                	j	8000163a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800015b2:	00002097          	auipc	ra,0x2
    800015b6:	682080e7          	jalr	1666(ra) # 80003c34 <filedup>
    800015ba:	009987b3          	add	a5,s3,s1
    800015be:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800015c0:	04a1                	addi	s1,s1,8
    800015c2:	01448763          	beq	s1,s4,800015d0 <fork+0xbc>
    if(p->ofile[i])
    800015c6:	009907b3          	add	a5,s2,s1
    800015ca:	6388                	ld	a0,0(a5)
    800015cc:	f17d                	bnez	a0,800015b2 <fork+0x9e>
    800015ce:	bfcd                	j	800015c0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800015d0:	15093503          	ld	a0,336(s2)
    800015d4:	00001097          	auipc	ra,0x1
    800015d8:	7d6080e7          	jalr	2006(ra) # 80002daa <idup>
    800015dc:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015e0:	4641                	li	a2,16
    800015e2:	15890593          	addi	a1,s2,344
    800015e6:	15898513          	addi	a0,s3,344
    800015ea:	fffff097          	auipc	ra,0xfffff
    800015ee:	edc080e7          	jalr	-292(ra) # 800004c6 <safestrcpy>
  pid = np->pid;
    800015f2:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800015f6:	854e                	mv	a0,s3
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	e9e080e7          	jalr	-354(ra) # 80006496 <release>
  acquire(&wait_lock);
    80001600:	00008497          	auipc	s1,0x8
    80001604:	a8048493          	addi	s1,s1,-1408 # 80009080 <wait_lock>
    80001608:	8526                	mv	a0,s1
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	dd8080e7          	jalr	-552(ra) # 800063e2 <acquire>
  np->parent = p;
    80001612:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001616:	8526                	mv	a0,s1
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	e7e080e7          	jalr	-386(ra) # 80006496 <release>
  acquire(&np->lock);
    80001620:	854e                	mv	a0,s3
    80001622:	00005097          	auipc	ra,0x5
    80001626:	dc0080e7          	jalr	-576(ra) # 800063e2 <acquire>
  np->state = RUNNABLE;
    8000162a:	478d                	li	a5,3
    8000162c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001630:	854e                	mv	a0,s3
    80001632:	00005097          	auipc	ra,0x5
    80001636:	e64080e7          	jalr	-412(ra) # 80006496 <release>
}
    8000163a:	8552                	mv	a0,s4
    8000163c:	70a2                	ld	ra,40(sp)
    8000163e:	7402                	ld	s0,32(sp)
    80001640:	64e2                	ld	s1,24(sp)
    80001642:	6942                	ld	s2,16(sp)
    80001644:	69a2                	ld	s3,8(sp)
    80001646:	6a02                	ld	s4,0(sp)
    80001648:	6145                	addi	sp,sp,48
    8000164a:	8082                	ret
    return -1;
    8000164c:	5a7d                	li	s4,-1
    8000164e:	b7f5                	j	8000163a <fork+0x126>

0000000080001650 <scheduler>:
{
    80001650:	7139                	addi	sp,sp,-64
    80001652:	fc06                	sd	ra,56(sp)
    80001654:	f822                	sd	s0,48(sp)
    80001656:	f426                	sd	s1,40(sp)
    80001658:	f04a                	sd	s2,32(sp)
    8000165a:	ec4e                	sd	s3,24(sp)
    8000165c:	e852                	sd	s4,16(sp)
    8000165e:	e456                	sd	s5,8(sp)
    80001660:	e05a                	sd	s6,0(sp)
    80001662:	0080                	addi	s0,sp,64
    80001664:	8792                	mv	a5,tp
  int id = r_tp();
    80001666:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001668:	00779a93          	slli	s5,a5,0x7
    8000166c:	00008717          	auipc	a4,0x8
    80001670:	9fc70713          	addi	a4,a4,-1540 # 80009068 <pid_lock>
    80001674:	9756                	add	a4,a4,s5
    80001676:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000167a:	00008717          	auipc	a4,0x8
    8000167e:	a2670713          	addi	a4,a4,-1498 # 800090a0 <cpus+0x8>
    80001682:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001684:	498d                	li	s3,3
        p->state = RUNNING;
    80001686:	4b11                	li	s6,4
        c->proc = p;
    80001688:	079e                	slli	a5,a5,0x7
    8000168a:	00008a17          	auipc	s4,0x8
    8000168e:	9dea0a13          	addi	s4,s4,-1570 # 80009068 <pid_lock>
    80001692:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001694:	0000e917          	auipc	s2,0xe
    80001698:	80490913          	addi	s2,s2,-2044 # 8000ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000169c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800016a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800016a4:	10079073          	csrw	sstatus,a5
    800016a8:	00008497          	auipc	s1,0x8
    800016ac:	df048493          	addi	s1,s1,-528 # 80009498 <proc>
    800016b0:	a03d                	j	800016de <scheduler+0x8e>
        p->state = RUNNING;
    800016b2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016b6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016ba:	06048593          	addi	a1,s1,96
    800016be:	8556                	mv	a0,s5
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	640080e7          	jalr	1600(ra) # 80001d00 <swtch>
        c->proc = 0;
    800016c8:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	dc8080e7          	jalr	-568(ra) # 80006496 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800016d6:	16848493          	addi	s1,s1,360
    800016da:	fd2481e3          	beq	s1,s2,8000169c <scheduler+0x4c>
      acquire(&p->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	d02080e7          	jalr	-766(ra) # 800063e2 <acquire>
      if(p->state == RUNNABLE) {
    800016e8:	4c9c                	lw	a5,24(s1)
    800016ea:	ff3791e3          	bne	a5,s3,800016cc <scheduler+0x7c>
    800016ee:	b7d1                	j	800016b2 <scheduler+0x62>

00000000800016f0 <sched>:
{
    800016f0:	7179                	addi	sp,sp,-48
    800016f2:	f406                	sd	ra,40(sp)
    800016f4:	f022                	sd	s0,32(sp)
    800016f6:	ec26                	sd	s1,24(sp)
    800016f8:	e84a                	sd	s2,16(sp)
    800016fa:	e44e                	sd	s3,8(sp)
    800016fc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	a48080e7          	jalr	-1464(ra) # 80001146 <myproc>
    80001706:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	c60080e7          	jalr	-928(ra) # 80006368 <holding>
    80001710:	c93d                	beqz	a0,80001786 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001712:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001714:	2781                	sext.w	a5,a5
    80001716:	079e                	slli	a5,a5,0x7
    80001718:	00008717          	auipc	a4,0x8
    8000171c:	95070713          	addi	a4,a4,-1712 # 80009068 <pid_lock>
    80001720:	97ba                	add	a5,a5,a4
    80001722:	0a87a703          	lw	a4,168(a5)
    80001726:	4785                	li	a5,1
    80001728:	06f71763          	bne	a4,a5,80001796 <sched+0xa6>
  if(p->state == RUNNING)
    8000172c:	4c98                	lw	a4,24(s1)
    8000172e:	4791                	li	a5,4
    80001730:	06f70b63          	beq	a4,a5,800017a6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001734:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001738:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000173a:	efb5                	bnez	a5,800017b6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000173c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000173e:	00008917          	auipc	s2,0x8
    80001742:	92a90913          	addi	s2,s2,-1750 # 80009068 <pid_lock>
    80001746:	2781                	sext.w	a5,a5
    80001748:	079e                	slli	a5,a5,0x7
    8000174a:	97ca                	add	a5,a5,s2
    8000174c:	0ac7a983          	lw	s3,172(a5)
    80001750:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001752:	2781                	sext.w	a5,a5
    80001754:	079e                	slli	a5,a5,0x7
    80001756:	00008597          	auipc	a1,0x8
    8000175a:	94a58593          	addi	a1,a1,-1718 # 800090a0 <cpus+0x8>
    8000175e:	95be                	add	a1,a1,a5
    80001760:	06048513          	addi	a0,s1,96
    80001764:	00000097          	auipc	ra,0x0
    80001768:	59c080e7          	jalr	1436(ra) # 80001d00 <swtch>
    8000176c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000176e:	2781                	sext.w	a5,a5
    80001770:	079e                	slli	a5,a5,0x7
    80001772:	97ca                	add	a5,a5,s2
    80001774:	0b37a623          	sw	s3,172(a5)
}
    80001778:	70a2                	ld	ra,40(sp)
    8000177a:	7402                	ld	s0,32(sp)
    8000177c:	64e2                	ld	s1,24(sp)
    8000177e:	6942                	ld	s2,16(sp)
    80001780:	69a2                	ld	s3,8(sp)
    80001782:	6145                	addi	sp,sp,48
    80001784:	8082                	ret
    panic("sched p->lock");
    80001786:	00007517          	auipc	a0,0x7
    8000178a:	a4a50513          	addi	a0,a0,-1462 # 800081d0 <etext+0x1d0>
    8000178e:	00004097          	auipc	ra,0x4
    80001792:	70a080e7          	jalr	1802(ra) # 80005e98 <panic>
    panic("sched locks");
    80001796:	00007517          	auipc	a0,0x7
    8000179a:	a4a50513          	addi	a0,a0,-1462 # 800081e0 <etext+0x1e0>
    8000179e:	00004097          	auipc	ra,0x4
    800017a2:	6fa080e7          	jalr	1786(ra) # 80005e98 <panic>
    panic("sched running");
    800017a6:	00007517          	auipc	a0,0x7
    800017aa:	a4a50513          	addi	a0,a0,-1462 # 800081f0 <etext+0x1f0>
    800017ae:	00004097          	auipc	ra,0x4
    800017b2:	6ea080e7          	jalr	1770(ra) # 80005e98 <panic>
    panic("sched interruptible");
    800017b6:	00007517          	auipc	a0,0x7
    800017ba:	a4a50513          	addi	a0,a0,-1462 # 80008200 <etext+0x200>
    800017be:	00004097          	auipc	ra,0x4
    800017c2:	6da080e7          	jalr	1754(ra) # 80005e98 <panic>

00000000800017c6 <yield>:
{
    800017c6:	1101                	addi	sp,sp,-32
    800017c8:	ec06                	sd	ra,24(sp)
    800017ca:	e822                	sd	s0,16(sp)
    800017cc:	e426                	sd	s1,8(sp)
    800017ce:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017d0:	00000097          	auipc	ra,0x0
    800017d4:	976080e7          	jalr	-1674(ra) # 80001146 <myproc>
    800017d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017da:	00005097          	auipc	ra,0x5
    800017de:	c08080e7          	jalr	-1016(ra) # 800063e2 <acquire>
  p->state = RUNNABLE;
    800017e2:	478d                	li	a5,3
    800017e4:	cc9c                	sw	a5,24(s1)
  sched();
    800017e6:	00000097          	auipc	ra,0x0
    800017ea:	f0a080e7          	jalr	-246(ra) # 800016f0 <sched>
  release(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	ca6080e7          	jalr	-858(ra) # 80006496 <release>
}
    800017f8:	60e2                	ld	ra,24(sp)
    800017fa:	6442                	ld	s0,16(sp)
    800017fc:	64a2                	ld	s1,8(sp)
    800017fe:	6105                	addi	sp,sp,32
    80001800:	8082                	ret

0000000080001802 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001802:	7179                	addi	sp,sp,-48
    80001804:	f406                	sd	ra,40(sp)
    80001806:	f022                	sd	s0,32(sp)
    80001808:	ec26                	sd	s1,24(sp)
    8000180a:	e84a                	sd	s2,16(sp)
    8000180c:	e44e                	sd	s3,8(sp)
    8000180e:	1800                	addi	s0,sp,48
    80001810:	89aa                	mv	s3,a0
    80001812:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001814:	00000097          	auipc	ra,0x0
    80001818:	932080e7          	jalr	-1742(ra) # 80001146 <myproc>
    8000181c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	bc4080e7          	jalr	-1084(ra) # 800063e2 <acquire>
  release(lk);
    80001826:	854a                	mv	a0,s2
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	c6e080e7          	jalr	-914(ra) # 80006496 <release>

  // Go to sleep.
  p->chan = chan;
    80001830:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001834:	4789                	li	a5,2
    80001836:	cc9c                	sw	a5,24(s1)

  sched();
    80001838:	00000097          	auipc	ra,0x0
    8000183c:	eb8080e7          	jalr	-328(ra) # 800016f0 <sched>

  // Tidy up.
  p->chan = 0;
    80001840:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	c50080e7          	jalr	-944(ra) # 80006496 <release>
  acquire(lk);
    8000184e:	854a                	mv	a0,s2
    80001850:	00005097          	auipc	ra,0x5
    80001854:	b92080e7          	jalr	-1134(ra) # 800063e2 <acquire>
}
    80001858:	70a2                	ld	ra,40(sp)
    8000185a:	7402                	ld	s0,32(sp)
    8000185c:	64e2                	ld	s1,24(sp)
    8000185e:	6942                	ld	s2,16(sp)
    80001860:	69a2                	ld	s3,8(sp)
    80001862:	6145                	addi	sp,sp,48
    80001864:	8082                	ret

0000000080001866 <wait>:
{
    80001866:	715d                	addi	sp,sp,-80
    80001868:	e486                	sd	ra,72(sp)
    8000186a:	e0a2                	sd	s0,64(sp)
    8000186c:	fc26                	sd	s1,56(sp)
    8000186e:	f84a                	sd	s2,48(sp)
    80001870:	f44e                	sd	s3,40(sp)
    80001872:	f052                	sd	s4,32(sp)
    80001874:	ec56                	sd	s5,24(sp)
    80001876:	e85a                	sd	s6,16(sp)
    80001878:	e45e                	sd	s7,8(sp)
    8000187a:	e062                	sd	s8,0(sp)
    8000187c:	0880                	addi	s0,sp,80
    8000187e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001880:	00000097          	auipc	ra,0x0
    80001884:	8c6080e7          	jalr	-1850(ra) # 80001146 <myproc>
    80001888:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000188a:	00007517          	auipc	a0,0x7
    8000188e:	7f650513          	addi	a0,a0,2038 # 80009080 <wait_lock>
    80001892:	00005097          	auipc	ra,0x5
    80001896:	b50080e7          	jalr	-1200(ra) # 800063e2 <acquire>
    havekids = 0;
    8000189a:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000189c:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000189e:	0000d997          	auipc	s3,0xd
    800018a2:	5fa98993          	addi	s3,s3,1530 # 8000ee98 <tickslock>
        havekids = 1;
    800018a6:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a8:	00007c17          	auipc	s8,0x7
    800018ac:	7d8c0c13          	addi	s8,s8,2008 # 80009080 <wait_lock>
    havekids = 0;
    800018b0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800018b2:	00008497          	auipc	s1,0x8
    800018b6:	be648493          	addi	s1,s1,-1050 # 80009498 <proc>
    800018ba:	a0bd                	j	80001928 <wait+0xc2>
          pid = np->pid;
    800018bc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800018c0:	000b0e63          	beqz	s6,800018dc <wait+0x76>
    800018c4:	4691                	li	a3,4
    800018c6:	02c48613          	addi	a2,s1,44
    800018ca:	85da                	mv	a1,s6
    800018cc:	05093503          	ld	a0,80(s2)
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	646080e7          	jalr	1606(ra) # 80000f16 <copyout>
    800018d8:	02054563          	bltz	a0,80001902 <wait+0x9c>
          freeproc(np);
    800018dc:	8526                	mv	a0,s1
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	a1a080e7          	jalr	-1510(ra) # 800012f8 <freeproc>
          release(&np->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	bae080e7          	jalr	-1106(ra) # 80006496 <release>
          release(&wait_lock);
    800018f0:	00007517          	auipc	a0,0x7
    800018f4:	79050513          	addi	a0,a0,1936 # 80009080 <wait_lock>
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	b9e080e7          	jalr	-1122(ra) # 80006496 <release>
          return pid;
    80001900:	a09d                	j	80001966 <wait+0x100>
            release(&np->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	b92080e7          	jalr	-1134(ra) # 80006496 <release>
            release(&wait_lock);
    8000190c:	00007517          	auipc	a0,0x7
    80001910:	77450513          	addi	a0,a0,1908 # 80009080 <wait_lock>
    80001914:	00005097          	auipc	ra,0x5
    80001918:	b82080e7          	jalr	-1150(ra) # 80006496 <release>
            return -1;
    8000191c:	59fd                	li	s3,-1
    8000191e:	a0a1                	j	80001966 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001920:	16848493          	addi	s1,s1,360
    80001924:	03348463          	beq	s1,s3,8000194c <wait+0xe6>
      if(np->parent == p){
    80001928:	7c9c                	ld	a5,56(s1)
    8000192a:	ff279be3          	bne	a5,s2,80001920 <wait+0xba>
        acquire(&np->lock);
    8000192e:	8526                	mv	a0,s1
    80001930:	00005097          	auipc	ra,0x5
    80001934:	ab2080e7          	jalr	-1358(ra) # 800063e2 <acquire>
        if(np->state == ZOMBIE){
    80001938:	4c9c                	lw	a5,24(s1)
    8000193a:	f94781e3          	beq	a5,s4,800018bc <wait+0x56>
        release(&np->lock);
    8000193e:	8526                	mv	a0,s1
    80001940:	00005097          	auipc	ra,0x5
    80001944:	b56080e7          	jalr	-1194(ra) # 80006496 <release>
        havekids = 1;
    80001948:	8756                	mv	a4,s5
    8000194a:	bfd9                	j	80001920 <wait+0xba>
    if(!havekids || p->killed){
    8000194c:	c701                	beqz	a4,80001954 <wait+0xee>
    8000194e:	02892783          	lw	a5,40(s2)
    80001952:	c79d                	beqz	a5,80001980 <wait+0x11a>
      release(&wait_lock);
    80001954:	00007517          	auipc	a0,0x7
    80001958:	72c50513          	addi	a0,a0,1836 # 80009080 <wait_lock>
    8000195c:	00005097          	auipc	ra,0x5
    80001960:	b3a080e7          	jalr	-1222(ra) # 80006496 <release>
      return -1;
    80001964:	59fd                	li	s3,-1
}
    80001966:	854e                	mv	a0,s3
    80001968:	60a6                	ld	ra,72(sp)
    8000196a:	6406                	ld	s0,64(sp)
    8000196c:	74e2                	ld	s1,56(sp)
    8000196e:	7942                	ld	s2,48(sp)
    80001970:	79a2                	ld	s3,40(sp)
    80001972:	7a02                	ld	s4,32(sp)
    80001974:	6ae2                	ld	s5,24(sp)
    80001976:	6b42                	ld	s6,16(sp)
    80001978:	6ba2                	ld	s7,8(sp)
    8000197a:	6c02                	ld	s8,0(sp)
    8000197c:	6161                	addi	sp,sp,80
    8000197e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001980:	85e2                	mv	a1,s8
    80001982:	854a                	mv	a0,s2
    80001984:	00000097          	auipc	ra,0x0
    80001988:	e7e080e7          	jalr	-386(ra) # 80001802 <sleep>
    havekids = 0;
    8000198c:	b715                	j	800018b0 <wait+0x4a>

000000008000198e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000198e:	7139                	addi	sp,sp,-64
    80001990:	fc06                	sd	ra,56(sp)
    80001992:	f822                	sd	s0,48(sp)
    80001994:	f426                	sd	s1,40(sp)
    80001996:	f04a                	sd	s2,32(sp)
    80001998:	ec4e                	sd	s3,24(sp)
    8000199a:	e852                	sd	s4,16(sp)
    8000199c:	e456                	sd	s5,8(sp)
    8000199e:	0080                	addi	s0,sp,64
    800019a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800019a2:	00008497          	auipc	s1,0x8
    800019a6:	af648493          	addi	s1,s1,-1290 # 80009498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800019aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800019ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800019ae:	0000d917          	auipc	s2,0xd
    800019b2:	4ea90913          	addi	s2,s2,1258 # 8000ee98 <tickslock>
    800019b6:	a821                	j	800019ce <wakeup+0x40>
        p->state = RUNNABLE;
    800019b8:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800019bc:	8526                	mv	a0,s1
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	ad8080e7          	jalr	-1320(ra) # 80006496 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	03248463          	beq	s1,s2,800019f2 <wakeup+0x64>
    if(p != myproc()){
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	778080e7          	jalr	1912(ra) # 80001146 <myproc>
    800019d6:	fea488e3          	beq	s1,a0,800019c6 <wakeup+0x38>
      acquire(&p->lock);
    800019da:	8526                	mv	a0,s1
    800019dc:	00005097          	auipc	ra,0x5
    800019e0:	a06080e7          	jalr	-1530(ra) # 800063e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800019e4:	4c9c                	lw	a5,24(s1)
    800019e6:	fd379be3          	bne	a5,s3,800019bc <wakeup+0x2e>
    800019ea:	709c                	ld	a5,32(s1)
    800019ec:	fd4798e3          	bne	a5,s4,800019bc <wakeup+0x2e>
    800019f0:	b7e1                	j	800019b8 <wakeup+0x2a>
    }
  }
}
    800019f2:	70e2                	ld	ra,56(sp)
    800019f4:	7442                	ld	s0,48(sp)
    800019f6:	74a2                	ld	s1,40(sp)
    800019f8:	7902                	ld	s2,32(sp)
    800019fa:	69e2                	ld	s3,24(sp)
    800019fc:	6a42                	ld	s4,16(sp)
    800019fe:	6aa2                	ld	s5,8(sp)
    80001a00:	6121                	addi	sp,sp,64
    80001a02:	8082                	ret

0000000080001a04 <reparent>:
{
    80001a04:	7179                	addi	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	e052                	sd	s4,0(sp)
    80001a12:	1800                	addi	s0,sp,48
    80001a14:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a16:	00008497          	auipc	s1,0x8
    80001a1a:	a8248493          	addi	s1,s1,-1406 # 80009498 <proc>
      pp->parent = initproc;
    80001a1e:	00007a17          	auipc	s4,0x7
    80001a22:	5f2a0a13          	addi	s4,s4,1522 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a26:	0000d997          	auipc	s3,0xd
    80001a2a:	47298993          	addi	s3,s3,1138 # 8000ee98 <tickslock>
    80001a2e:	a029                	j	80001a38 <reparent+0x34>
    80001a30:	16848493          	addi	s1,s1,360
    80001a34:	01348d63          	beq	s1,s3,80001a4e <reparent+0x4a>
    if(pp->parent == p){
    80001a38:	7c9c                	ld	a5,56(s1)
    80001a3a:	ff279be3          	bne	a5,s2,80001a30 <reparent+0x2c>
      pp->parent = initproc;
    80001a3e:	000a3503          	ld	a0,0(s4)
    80001a42:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001a44:	00000097          	auipc	ra,0x0
    80001a48:	f4a080e7          	jalr	-182(ra) # 8000198e <wakeup>
    80001a4c:	b7d5                	j	80001a30 <reparent+0x2c>
}
    80001a4e:	70a2                	ld	ra,40(sp)
    80001a50:	7402                	ld	s0,32(sp)
    80001a52:	64e2                	ld	s1,24(sp)
    80001a54:	6942                	ld	s2,16(sp)
    80001a56:	69a2                	ld	s3,8(sp)
    80001a58:	6a02                	ld	s4,0(sp)
    80001a5a:	6145                	addi	sp,sp,48
    80001a5c:	8082                	ret

0000000080001a5e <exit>:
{
    80001a5e:	7179                	addi	sp,sp,-48
    80001a60:	f406                	sd	ra,40(sp)
    80001a62:	f022                	sd	s0,32(sp)
    80001a64:	ec26                	sd	s1,24(sp)
    80001a66:	e84a                	sd	s2,16(sp)
    80001a68:	e44e                	sd	s3,8(sp)
    80001a6a:	e052                	sd	s4,0(sp)
    80001a6c:	1800                	addi	s0,sp,48
    80001a6e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	6d6080e7          	jalr	1750(ra) # 80001146 <myproc>
    80001a78:	89aa                	mv	s3,a0
  if(p == initproc)
    80001a7a:	00007797          	auipc	a5,0x7
    80001a7e:	5967b783          	ld	a5,1430(a5) # 80009010 <initproc>
    80001a82:	0d050493          	addi	s1,a0,208
    80001a86:	15050913          	addi	s2,a0,336
    80001a8a:	02a79363          	bne	a5,a0,80001ab0 <exit+0x52>
    panic("init exiting");
    80001a8e:	00006517          	auipc	a0,0x6
    80001a92:	78a50513          	addi	a0,a0,1930 # 80008218 <etext+0x218>
    80001a96:	00004097          	auipc	ra,0x4
    80001a9a:	402080e7          	jalr	1026(ra) # 80005e98 <panic>
      fileclose(f);
    80001a9e:	00002097          	auipc	ra,0x2
    80001aa2:	1e8080e7          	jalr	488(ra) # 80003c86 <fileclose>
      p->ofile[fd] = 0;
    80001aa6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001aaa:	04a1                	addi	s1,s1,8
    80001aac:	01248563          	beq	s1,s2,80001ab6 <exit+0x58>
    if(p->ofile[fd]){
    80001ab0:	6088                	ld	a0,0(s1)
    80001ab2:	f575                	bnez	a0,80001a9e <exit+0x40>
    80001ab4:	bfdd                	j	80001aaa <exit+0x4c>
  begin_op();
    80001ab6:	00002097          	auipc	ra,0x2
    80001aba:	d04080e7          	jalr	-764(ra) # 800037ba <begin_op>
  iput(p->cwd);
    80001abe:	1509b503          	ld	a0,336(s3)
    80001ac2:	00001097          	auipc	ra,0x1
    80001ac6:	4e0080e7          	jalr	1248(ra) # 80002fa2 <iput>
  end_op();
    80001aca:	00002097          	auipc	ra,0x2
    80001ace:	d70080e7          	jalr	-656(ra) # 8000383a <end_op>
  p->cwd = 0;
    80001ad2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001ad6:	00007497          	auipc	s1,0x7
    80001ada:	5aa48493          	addi	s1,s1,1450 # 80009080 <wait_lock>
    80001ade:	8526                	mv	a0,s1
    80001ae0:	00005097          	auipc	ra,0x5
    80001ae4:	902080e7          	jalr	-1790(ra) # 800063e2 <acquire>
  reparent(p);
    80001ae8:	854e                	mv	a0,s3
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	f1a080e7          	jalr	-230(ra) # 80001a04 <reparent>
  wakeup(p->parent);
    80001af2:	0389b503          	ld	a0,56(s3)
    80001af6:	00000097          	auipc	ra,0x0
    80001afa:	e98080e7          	jalr	-360(ra) # 8000198e <wakeup>
  acquire(&p->lock);
    80001afe:	854e                	mv	a0,s3
    80001b00:	00005097          	auipc	ra,0x5
    80001b04:	8e2080e7          	jalr	-1822(ra) # 800063e2 <acquire>
  p->xstate = status;
    80001b08:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001b0c:	4795                	li	a5,5
    80001b0e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001b12:	8526                	mv	a0,s1
    80001b14:	00005097          	auipc	ra,0x5
    80001b18:	982080e7          	jalr	-1662(ra) # 80006496 <release>
  sched();
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	bd4080e7          	jalr	-1068(ra) # 800016f0 <sched>
  panic("zombie exit");
    80001b24:	00006517          	auipc	a0,0x6
    80001b28:	70450513          	addi	a0,a0,1796 # 80008228 <etext+0x228>
    80001b2c:	00004097          	auipc	ra,0x4
    80001b30:	36c080e7          	jalr	876(ra) # 80005e98 <panic>

0000000080001b34 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001b34:	7179                	addi	sp,sp,-48
    80001b36:	f406                	sd	ra,40(sp)
    80001b38:	f022                	sd	s0,32(sp)
    80001b3a:	ec26                	sd	s1,24(sp)
    80001b3c:	e84a                	sd	s2,16(sp)
    80001b3e:	e44e                	sd	s3,8(sp)
    80001b40:	1800                	addi	s0,sp,48
    80001b42:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b44:	00008497          	auipc	s1,0x8
    80001b48:	95448493          	addi	s1,s1,-1708 # 80009498 <proc>
    80001b4c:	0000d997          	auipc	s3,0xd
    80001b50:	34c98993          	addi	s3,s3,844 # 8000ee98 <tickslock>
    acquire(&p->lock);
    80001b54:	8526                	mv	a0,s1
    80001b56:	00005097          	auipc	ra,0x5
    80001b5a:	88c080e7          	jalr	-1908(ra) # 800063e2 <acquire>
    if(p->pid == pid){
    80001b5e:	589c                	lw	a5,48(s1)
    80001b60:	01278d63          	beq	a5,s2,80001b7a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b64:	8526                	mv	a0,s1
    80001b66:	00005097          	auipc	ra,0x5
    80001b6a:	930080e7          	jalr	-1744(ra) # 80006496 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b6e:	16848493          	addi	s1,s1,360
    80001b72:	ff3491e3          	bne	s1,s3,80001b54 <kill+0x20>
  }
  return -1;
    80001b76:	557d                	li	a0,-1
    80001b78:	a829                	j	80001b92 <kill+0x5e>
      p->killed = 1;
    80001b7a:	4785                	li	a5,1
    80001b7c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001b7e:	4c98                	lw	a4,24(s1)
    80001b80:	4789                	li	a5,2
    80001b82:	00f70f63          	beq	a4,a5,80001ba0 <kill+0x6c>
      release(&p->lock);
    80001b86:	8526                	mv	a0,s1
    80001b88:	00005097          	auipc	ra,0x5
    80001b8c:	90e080e7          	jalr	-1778(ra) # 80006496 <release>
      return 0;
    80001b90:	4501                	li	a0,0
}
    80001b92:	70a2                	ld	ra,40(sp)
    80001b94:	7402                	ld	s0,32(sp)
    80001b96:	64e2                	ld	s1,24(sp)
    80001b98:	6942                	ld	s2,16(sp)
    80001b9a:	69a2                	ld	s3,8(sp)
    80001b9c:	6145                	addi	sp,sp,48
    80001b9e:	8082                	ret
        p->state = RUNNABLE;
    80001ba0:	478d                	li	a5,3
    80001ba2:	cc9c                	sw	a5,24(s1)
    80001ba4:	b7cd                	j	80001b86 <kill+0x52>

0000000080001ba6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ba6:	7179                	addi	sp,sp,-48
    80001ba8:	f406                	sd	ra,40(sp)
    80001baa:	f022                	sd	s0,32(sp)
    80001bac:	ec26                	sd	s1,24(sp)
    80001bae:	e84a                	sd	s2,16(sp)
    80001bb0:	e44e                	sd	s3,8(sp)
    80001bb2:	e052                	sd	s4,0(sp)
    80001bb4:	1800                	addi	s0,sp,48
    80001bb6:	84aa                	mv	s1,a0
    80001bb8:	892e                	mv	s2,a1
    80001bba:	89b2                	mv	s3,a2
    80001bbc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bbe:	fffff097          	auipc	ra,0xfffff
    80001bc2:	588080e7          	jalr	1416(ra) # 80001146 <myproc>
  if(user_dst){
    80001bc6:	c08d                	beqz	s1,80001be8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001bc8:	86d2                	mv	a3,s4
    80001bca:	864e                	mv	a2,s3
    80001bcc:	85ca                	mv	a1,s2
    80001bce:	6928                	ld	a0,80(a0)
    80001bd0:	fffff097          	auipc	ra,0xfffff
    80001bd4:	346080e7          	jalr	838(ra) # 80000f16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001bd8:	70a2                	ld	ra,40(sp)
    80001bda:	7402                	ld	s0,32(sp)
    80001bdc:	64e2                	ld	s1,24(sp)
    80001bde:	6942                	ld	s2,16(sp)
    80001be0:	69a2                	ld	s3,8(sp)
    80001be2:	6a02                	ld	s4,0(sp)
    80001be4:	6145                	addi	sp,sp,48
    80001be6:	8082                	ret
    memmove((char *)dst, src, len);
    80001be8:	000a061b          	sext.w	a2,s4
    80001bec:	85ce                	mv	a1,s3
    80001bee:	854a                	mv	a0,s2
    80001bf0:	ffffe097          	auipc	ra,0xffffe
    80001bf4:	7e4080e7          	jalr	2020(ra) # 800003d4 <memmove>
    return 0;
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	bff9                	j	80001bd8 <either_copyout+0x32>

0000000080001bfc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001bfc:	7179                	addi	sp,sp,-48
    80001bfe:	f406                	sd	ra,40(sp)
    80001c00:	f022                	sd	s0,32(sp)
    80001c02:	ec26                	sd	s1,24(sp)
    80001c04:	e84a                	sd	s2,16(sp)
    80001c06:	e44e                	sd	s3,8(sp)
    80001c08:	e052                	sd	s4,0(sp)
    80001c0a:	1800                	addi	s0,sp,48
    80001c0c:	892a                	mv	s2,a0
    80001c0e:	84ae                	mv	s1,a1
    80001c10:	89b2                	mv	s3,a2
    80001c12:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	532080e7          	jalr	1330(ra) # 80001146 <myproc>
  if(user_src){
    80001c1c:	c08d                	beqz	s1,80001c3e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c1e:	86d2                	mv	a3,s4
    80001c20:	864e                	mv	a2,s3
    80001c22:	85ca                	mv	a1,s2
    80001c24:	6928                	ld	a0,80(a0)
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	0cc080e7          	jalr	204(ra) # 80000cf2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001c2e:	70a2                	ld	ra,40(sp)
    80001c30:	7402                	ld	s0,32(sp)
    80001c32:	64e2                	ld	s1,24(sp)
    80001c34:	6942                	ld	s2,16(sp)
    80001c36:	69a2                	ld	s3,8(sp)
    80001c38:	6a02                	ld	s4,0(sp)
    80001c3a:	6145                	addi	sp,sp,48
    80001c3c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001c3e:	000a061b          	sext.w	a2,s4
    80001c42:	85ce                	mv	a1,s3
    80001c44:	854a                	mv	a0,s2
    80001c46:	ffffe097          	auipc	ra,0xffffe
    80001c4a:	78e080e7          	jalr	1934(ra) # 800003d4 <memmove>
    return 0;
    80001c4e:	8526                	mv	a0,s1
    80001c50:	bff9                	j	80001c2e <either_copyin+0x32>

0000000080001c52 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c52:	715d                	addi	sp,sp,-80
    80001c54:	e486                	sd	ra,72(sp)
    80001c56:	e0a2                	sd	s0,64(sp)
    80001c58:	fc26                	sd	s1,56(sp)
    80001c5a:	f84a                	sd	s2,48(sp)
    80001c5c:	f44e                	sd	s3,40(sp)
    80001c5e:	f052                	sd	s4,32(sp)
    80001c60:	ec56                	sd	s5,24(sp)
    80001c62:	e85a                	sd	s6,16(sp)
    80001c64:	e45e                	sd	s7,8(sp)
    80001c66:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c68:	00006517          	auipc	a0,0x6
    80001c6c:	52050513          	addi	a0,a0,1312 # 80008188 <etext+0x188>
    80001c70:	00004097          	auipc	ra,0x4
    80001c74:	272080e7          	jalr	626(ra) # 80005ee2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c78:	00008497          	auipc	s1,0x8
    80001c7c:	97848493          	addi	s1,s1,-1672 # 800095f0 <proc+0x158>
    80001c80:	0000d917          	auipc	s2,0xd
    80001c84:	37090913          	addi	s2,s2,880 # 8000eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c88:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c8a:	00006997          	auipc	s3,0x6
    80001c8e:	5ae98993          	addi	s3,s3,1454 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001c92:	00006a97          	auipc	s5,0x6
    80001c96:	5aea8a93          	addi	s5,s5,1454 # 80008240 <etext+0x240>
    printf("\n");
    80001c9a:	00006a17          	auipc	s4,0x6
    80001c9e:	4eea0a13          	addi	s4,s4,1262 # 80008188 <etext+0x188>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ca2:	00006b97          	auipc	s7,0x6
    80001ca6:	5d6b8b93          	addi	s7,s7,1494 # 80008278 <states.1717>
    80001caa:	a00d                	j	80001ccc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001cac:	ed86a583          	lw	a1,-296(a3)
    80001cb0:	8556                	mv	a0,s5
    80001cb2:	00004097          	auipc	ra,0x4
    80001cb6:	230080e7          	jalr	560(ra) # 80005ee2 <printf>
    printf("\n");
    80001cba:	8552                	mv	a0,s4
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	226080e7          	jalr	550(ra) # 80005ee2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001cc4:	16848493          	addi	s1,s1,360
    80001cc8:	03248163          	beq	s1,s2,80001cea <procdump+0x98>
    if(p->state == UNUSED)
    80001ccc:	86a6                	mv	a3,s1
    80001cce:	ec04a783          	lw	a5,-320(s1)
    80001cd2:	dbed                	beqz	a5,80001cc4 <procdump+0x72>
      state = "???";
    80001cd4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cd6:	fcfb6be3          	bltu	s6,a5,80001cac <procdump+0x5a>
    80001cda:	1782                	slli	a5,a5,0x20
    80001cdc:	9381                	srli	a5,a5,0x20
    80001cde:	078e                	slli	a5,a5,0x3
    80001ce0:	97de                	add	a5,a5,s7
    80001ce2:	6390                	ld	a2,0(a5)
    80001ce4:	f661                	bnez	a2,80001cac <procdump+0x5a>
      state = "???";
    80001ce6:	864e                	mv	a2,s3
    80001ce8:	b7d1                	j	80001cac <procdump+0x5a>
  }
}
    80001cea:	60a6                	ld	ra,72(sp)
    80001cec:	6406                	ld	s0,64(sp)
    80001cee:	74e2                	ld	s1,56(sp)
    80001cf0:	7942                	ld	s2,48(sp)
    80001cf2:	79a2                	ld	s3,40(sp)
    80001cf4:	7a02                	ld	s4,32(sp)
    80001cf6:	6ae2                	ld	s5,24(sp)
    80001cf8:	6b42                	ld	s6,16(sp)
    80001cfa:	6ba2                	ld	s7,8(sp)
    80001cfc:	6161                	addi	sp,sp,80
    80001cfe:	8082                	ret

0000000080001d00 <swtch>:
    80001d00:	00153023          	sd	ra,0(a0)
    80001d04:	00253423          	sd	sp,8(a0)
    80001d08:	e900                	sd	s0,16(a0)
    80001d0a:	ed04                	sd	s1,24(a0)
    80001d0c:	03253023          	sd	s2,32(a0)
    80001d10:	03353423          	sd	s3,40(a0)
    80001d14:	03453823          	sd	s4,48(a0)
    80001d18:	03553c23          	sd	s5,56(a0)
    80001d1c:	05653023          	sd	s6,64(a0)
    80001d20:	05753423          	sd	s7,72(a0)
    80001d24:	05853823          	sd	s8,80(a0)
    80001d28:	05953c23          	sd	s9,88(a0)
    80001d2c:	07a53023          	sd	s10,96(a0)
    80001d30:	07b53423          	sd	s11,104(a0)
    80001d34:	0005b083          	ld	ra,0(a1)
    80001d38:	0085b103          	ld	sp,8(a1)
    80001d3c:	6980                	ld	s0,16(a1)
    80001d3e:	6d84                	ld	s1,24(a1)
    80001d40:	0205b903          	ld	s2,32(a1)
    80001d44:	0285b983          	ld	s3,40(a1)
    80001d48:	0305ba03          	ld	s4,48(a1)
    80001d4c:	0385ba83          	ld	s5,56(a1)
    80001d50:	0405bb03          	ld	s6,64(a1)
    80001d54:	0485bb83          	ld	s7,72(a1)
    80001d58:	0505bc03          	ld	s8,80(a1)
    80001d5c:	0585bc83          	ld	s9,88(a1)
    80001d60:	0605bd03          	ld	s10,96(a1)
    80001d64:	0685bd83          	ld	s11,104(a1)
    80001d68:	8082                	ret

0000000080001d6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d6a:	1141                	addi	sp,sp,-16
    80001d6c:	e406                	sd	ra,8(sp)
    80001d6e:	e022                	sd	s0,0(sp)
    80001d70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d72:	00006597          	auipc	a1,0x6
    80001d76:	53658593          	addi	a1,a1,1334 # 800082a8 <states.1717+0x30>
    80001d7a:	0000d517          	auipc	a0,0xd
    80001d7e:	11e50513          	addi	a0,a0,286 # 8000ee98 <tickslock>
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	5d0080e7          	jalr	1488(ra) # 80006352 <initlock>
}
    80001d8a:	60a2                	ld	ra,8(sp)
    80001d8c:	6402                	ld	s0,0(sp)
    80001d8e:	0141                	addi	sp,sp,16
    80001d90:	8082                	ret

0000000080001d92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d92:	1141                	addi	sp,sp,-16
    80001d94:	e422                	sd	s0,8(sp)
    80001d96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d98:	00003797          	auipc	a5,0x3
    80001d9c:	50878793          	addi	a5,a5,1288 # 800052a0 <kernelvec>
    80001da0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001da4:	6422                	ld	s0,8(sp)
    80001da6:	0141                	addi	sp,sp,16
    80001da8:	8082                	ret

0000000080001daa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001daa:	1141                	addi	sp,sp,-16
    80001dac:	e406                	sd	ra,8(sp)
    80001dae:	e022                	sd	s0,0(sp)
    80001db0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001db2:	fffff097          	auipc	ra,0xfffff
    80001db6:	394080e7          	jalr	916(ra) # 80001146 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001dbe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001dc4:	00005617          	auipc	a2,0x5
    80001dc8:	23c60613          	addi	a2,a2,572 # 80007000 <_trampoline>
    80001dcc:	00005697          	auipc	a3,0x5
    80001dd0:	23468693          	addi	a3,a3,564 # 80007000 <_trampoline>
    80001dd4:	8e91                	sub	a3,a3,a2
    80001dd6:	040007b7          	lui	a5,0x4000
    80001dda:	17fd                	addi	a5,a5,-1
    80001ddc:	07b2                	slli	a5,a5,0xc
    80001dde:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001de0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001de4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001de6:	180026f3          	csrr	a3,satp
    80001dea:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dec:	6d38                	ld	a4,88(a0)
    80001dee:	6134                	ld	a3,64(a0)
    80001df0:	6585                	lui	a1,0x1
    80001df2:	96ae                	add	a3,a3,a1
    80001df4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001df6:	6d38                	ld	a4,88(a0)
    80001df8:	00000697          	auipc	a3,0x0
    80001dfc:	13868693          	addi	a3,a3,312 # 80001f30 <usertrap>
    80001e00:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001e02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e04:	8692                	mv	a3,tp
    80001e06:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e08:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001e0c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001e10:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e14:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e1a:	6f18                	ld	a4,24(a4)
    80001e1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e20:	692c                	ld	a1,80(a0)
    80001e22:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001e24:	00005717          	auipc	a4,0x5
    80001e28:	26c70713          	addi	a4,a4,620 # 80007090 <userret>
    80001e2c:	8f11                	sub	a4,a4,a2
    80001e2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001e30:	577d                	li	a4,-1
    80001e32:	177e                	slli	a4,a4,0x3f
    80001e34:	8dd9                	or	a1,a1,a4
    80001e36:	02000537          	lui	a0,0x2000
    80001e3a:	157d                	addi	a0,a0,-1
    80001e3c:	0536                	slli	a0,a0,0xd
    80001e3e:	9782                	jalr	a5
}
    80001e40:	60a2                	ld	ra,8(sp)
    80001e42:	6402                	ld	s0,0(sp)
    80001e44:	0141                	addi	sp,sp,16
    80001e46:	8082                	ret

0000000080001e48 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e48:	1101                	addi	sp,sp,-32
    80001e4a:	ec06                	sd	ra,24(sp)
    80001e4c:	e822                	sd	s0,16(sp)
    80001e4e:	e426                	sd	s1,8(sp)
    80001e50:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e52:	0000d497          	auipc	s1,0xd
    80001e56:	04648493          	addi	s1,s1,70 # 8000ee98 <tickslock>
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	586080e7          	jalr	1414(ra) # 800063e2 <acquire>
  ticks++;
    80001e64:	00007517          	auipc	a0,0x7
    80001e68:	1b450513          	addi	a0,a0,436 # 80009018 <ticks>
    80001e6c:	411c                	lw	a5,0(a0)
    80001e6e:	2785                	addiw	a5,a5,1
    80001e70:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e72:	00000097          	auipc	ra,0x0
    80001e76:	b1c080e7          	jalr	-1252(ra) # 8000198e <wakeup>
  release(&tickslock);
    80001e7a:	8526                	mv	a0,s1
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	61a080e7          	jalr	1562(ra) # 80006496 <release>
}
    80001e84:	60e2                	ld	ra,24(sp)
    80001e86:	6442                	ld	s0,16(sp)
    80001e88:	64a2                	ld	s1,8(sp)
    80001e8a:	6105                	addi	sp,sp,32
    80001e8c:	8082                	ret

0000000080001e8e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e8e:	1101                	addi	sp,sp,-32
    80001e90:	ec06                	sd	ra,24(sp)
    80001e92:	e822                	sd	s0,16(sp)
    80001e94:	e426                	sd	s1,8(sp)
    80001e96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e98:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e9c:	00074d63          	bltz	a4,80001eb6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ea0:	57fd                	li	a5,-1
    80001ea2:	17fe                	slli	a5,a5,0x3f
    80001ea4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ea6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ea8:	06f70363          	beq	a4,a5,80001f0e <devintr+0x80>
  }
}
    80001eac:	60e2                	ld	ra,24(sp)
    80001eae:	6442                	ld	s0,16(sp)
    80001eb0:	64a2                	ld	s1,8(sp)
    80001eb2:	6105                	addi	sp,sp,32
    80001eb4:	8082                	ret
     (scause & 0xff) == 9){
    80001eb6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001eba:	46a5                	li	a3,9
    80001ebc:	fed792e3          	bne	a5,a3,80001ea0 <devintr+0x12>
    int irq = plic_claim();
    80001ec0:	00003097          	auipc	ra,0x3
    80001ec4:	4e8080e7          	jalr	1256(ra) # 800053a8 <plic_claim>
    80001ec8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001eca:	47a9                	li	a5,10
    80001ecc:	02f50763          	beq	a0,a5,80001efa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ed0:	4785                	li	a5,1
    80001ed2:	02f50963          	beq	a0,a5,80001f04 <devintr+0x76>
    return 1;
    80001ed6:	4505                	li	a0,1
    } else if(irq){
    80001ed8:	d8f1                	beqz	s1,80001eac <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001eda:	85a6                	mv	a1,s1
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	3d450513          	addi	a0,a0,980 # 800082b0 <states.1717+0x38>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	ffe080e7          	jalr	-2(ra) # 80005ee2 <printf>
      plic_complete(irq);
    80001eec:	8526                	mv	a0,s1
    80001eee:	00003097          	auipc	ra,0x3
    80001ef2:	4de080e7          	jalr	1246(ra) # 800053cc <plic_complete>
    return 1;
    80001ef6:	4505                	li	a0,1
    80001ef8:	bf55                	j	80001eac <devintr+0x1e>
      uartintr();
    80001efa:	00004097          	auipc	ra,0x4
    80001efe:	408080e7          	jalr	1032(ra) # 80006302 <uartintr>
    80001f02:	b7ed                	j	80001eec <devintr+0x5e>
      virtio_disk_intr();
    80001f04:	00004097          	auipc	ra,0x4
    80001f08:	9a8080e7          	jalr	-1624(ra) # 800058ac <virtio_disk_intr>
    80001f0c:	b7c5                	j	80001eec <devintr+0x5e>
    if(cpuid() == 0){
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	20c080e7          	jalr	524(ra) # 8000111a <cpuid>
    80001f16:	c901                	beqz	a0,80001f26 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001f18:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001f1e:	14479073          	csrw	sip,a5
    return 2;
    80001f22:	4509                	li	a0,2
    80001f24:	b761                	j	80001eac <devintr+0x1e>
      clockintr();
    80001f26:	00000097          	auipc	ra,0x0
    80001f2a:	f22080e7          	jalr	-222(ra) # 80001e48 <clockintr>
    80001f2e:	b7ed                	j	80001f18 <devintr+0x8a>

0000000080001f30 <usertrap>:
{
    80001f30:	7179                	addi	sp,sp,-48
    80001f32:	f406                	sd	ra,40(sp)
    80001f34:	f022                	sd	s0,32(sp)
    80001f36:	ec26                	sd	s1,24(sp)
    80001f38:	e84a                	sd	s2,16(sp)
    80001f3a:	e44e                	sd	s3,8(sp)
    80001f3c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f42:	1007f793          	andi	a5,a5,256
    80001f46:	e3b5                	bnez	a5,80001faa <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f48:	00003797          	auipc	a5,0x3
    80001f4c:	35878793          	addi	a5,a5,856 # 800052a0 <kernelvec>
    80001f50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	1f2080e7          	jalr	498(ra) # 80001146 <myproc>
    80001f5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f60:	14102773          	csrr	a4,sepc
    80001f64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f6a:	47a1                	li	a5,8
    80001f6c:	04f71d63          	bne	a4,a5,80001fc6 <usertrap+0x96>
    if(p->killed)
    80001f70:	551c                	lw	a5,40(a0)
    80001f72:	e7a1                	bnez	a5,80001fba <usertrap+0x8a>
    p->trapframe->epc += 4;
    80001f74:	6cb8                	ld	a4,88(s1)
    80001f76:	6f1c                	ld	a5,24(a4)
    80001f78:	0791                	addi	a5,a5,4
    80001f7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f84:	10079073          	csrw	sstatus,a5
    syscall();
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	362080e7          	jalr	866(ra) # 800022ea <syscall>
  if(p->killed)
    80001f90:	549c                	lw	a5,40(s1)
    80001f92:	efed                	bnez	a5,8000208c <usertrap+0x15c>
  usertrapret();
    80001f94:	00000097          	auipc	ra,0x0
    80001f98:	e16080e7          	jalr	-490(ra) # 80001daa <usertrapret>
}
    80001f9c:	70a2                	ld	ra,40(sp)
    80001f9e:	7402                	ld	s0,32(sp)
    80001fa0:	64e2                	ld	s1,24(sp)
    80001fa2:	6942                	ld	s2,16(sp)
    80001fa4:	69a2                	ld	s3,8(sp)
    80001fa6:	6145                	addi	sp,sp,48
    80001fa8:	8082                	ret
    panic("usertrap: not from user mode");
    80001faa:	00006517          	auipc	a0,0x6
    80001fae:	32650513          	addi	a0,a0,806 # 800082d0 <states.1717+0x58>
    80001fb2:	00004097          	auipc	ra,0x4
    80001fb6:	ee6080e7          	jalr	-282(ra) # 80005e98 <panic>
      exit(-1);
    80001fba:	557d                	li	a0,-1
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	aa2080e7          	jalr	-1374(ra) # 80001a5e <exit>
    80001fc4:	bf45                	j	80001f74 <usertrap+0x44>
  } else if((which_dev = devintr()) != 0){
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	ec8080e7          	jalr	-312(ra) # 80001e8e <devintr>
    80001fce:	892a                	mv	s2,a0
    80001fd0:	e95d                	bnez	a0,80002086 <usertrap+0x156>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd2:	14202773          	csrr	a4,scause
  else if(r_scause() == 15 || r_scause() == 13)
    80001fd6:	47bd                	li	a5,15
    80001fd8:	00f70763          	beq	a4,a5,80001fe6 <usertrap+0xb6>
    80001fdc:	14202773          	csrr	a4,scause
    80001fe0:	47b5                	li	a5,13
    80001fe2:	06f71863          	bne	a4,a5,80002052 <usertrap+0x122>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fe6:	143029f3          	csrr	s3,stval
    if(is_cow_fault(p->pagetable, va))
    80001fea:	85ce                	mv	a1,s3
    80001fec:	68a8                	ld	a0,80(s1)
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	e44080e7          	jalr	-444(ra) # 80000e32 <is_cow_fault>
    80001ff6:	c505                	beqz	a0,8000201e <usertrap+0xee>
      if(cow_alloc(p->pagetable, va) < 0)
    80001ff8:	85ce                	mv	a1,s3
    80001ffa:	68a8                	ld	a0,80(s1)
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	e70080e7          	jalr	-400(ra) # 80000e6c <cow_alloc>
    80002004:	f80556e3          	bgez	a0,80001f90 <usertrap+0x60>
        printf("usertrap(): cow_alloc failed!");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	2e850513          	addi	a0,a0,744 # 800082f0 <states.1717+0x78>
    80002010:	00004097          	auipc	ra,0x4
    80002014:	ed2080e7          	jalr	-302(ra) # 80005ee2 <printf>
        p->killed = 1;
    80002018:	4785                	li	a5,1
    8000201a:	d49c                	sw	a5,40(s1)
    8000201c:	a88d                	j	8000208e <usertrap+0x15e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000201e:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002022:	5890                	lw	a2,48(s1)
    80002024:	00006517          	auipc	a0,0x6
    80002028:	2ec50513          	addi	a0,a0,748 # 80008310 <states.1717+0x98>
    8000202c:	00004097          	auipc	ra,0x4
    80002030:	eb6080e7          	jalr	-330(ra) # 80005ee2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002034:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002038:	14302673          	csrr	a2,stval
      printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000203c:	00006517          	auipc	a0,0x6
    80002040:	30450513          	addi	a0,a0,772 # 80008340 <states.1717+0xc8>
    80002044:	00004097          	auipc	ra,0x4
    80002048:	e9e080e7          	jalr	-354(ra) # 80005ee2 <printf>
      p->killed = 1;
    8000204c:	4785                	li	a5,1
    8000204e:	d49c                	sw	a5,40(s1)
    80002050:	a83d                	j	8000208e <usertrap+0x15e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002052:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002056:	5890                	lw	a2,48(s1)
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	2b850513          	addi	a0,a0,696 # 80008310 <states.1717+0x98>
    80002060:	00004097          	auipc	ra,0x4
    80002064:	e82080e7          	jalr	-382(ra) # 80005ee2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002068:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000206c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002070:	00006517          	auipc	a0,0x6
    80002074:	2d050513          	addi	a0,a0,720 # 80008340 <states.1717+0xc8>
    80002078:	00004097          	auipc	ra,0x4
    8000207c:	e6a080e7          	jalr	-406(ra) # 80005ee2 <printf>
    p->killed = 1;
    80002080:	4785                	li	a5,1
    80002082:	d49c                	sw	a5,40(s1)
    80002084:	a029                	j	8000208e <usertrap+0x15e>
  if(p->killed)
    80002086:	549c                	lw	a5,40(s1)
    80002088:	cb81                	beqz	a5,80002098 <usertrap+0x168>
    8000208a:	a011                	j	8000208e <usertrap+0x15e>
    8000208c:	4901                	li	s2,0
    exit(-1);
    8000208e:	557d                	li	a0,-1
    80002090:	00000097          	auipc	ra,0x0
    80002094:	9ce080e7          	jalr	-1586(ra) # 80001a5e <exit>
  if(which_dev == 2)
    80002098:	4789                	li	a5,2
    8000209a:	eef91de3          	bne	s2,a5,80001f94 <usertrap+0x64>
    yield();
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	728080e7          	jalr	1832(ra) # 800017c6 <yield>
    800020a6:	b5fd                	j	80001f94 <usertrap+0x64>

00000000800020a8 <kerneltrap>:
{
    800020a8:	7179                	addi	sp,sp,-48
    800020aa:	f406                	sd	ra,40(sp)
    800020ac:	f022                	sd	s0,32(sp)
    800020ae:	ec26                	sd	s1,24(sp)
    800020b0:	e84a                	sd	s2,16(sp)
    800020b2:	e44e                	sd	s3,8(sp)
    800020b4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020b6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ba:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020be:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800020c2:	1004f793          	andi	a5,s1,256
    800020c6:	cb85                	beqz	a5,800020f6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020cc:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800020ce:	ef85                	bnez	a5,80002106 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	dbe080e7          	jalr	-578(ra) # 80001e8e <devintr>
    800020d8:	cd1d                	beqz	a0,80002116 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020da:	4789                	li	a5,2
    800020dc:	06f50a63          	beq	a0,a5,80002150 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800020e0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020e4:	10049073          	csrw	sstatus,s1
}
    800020e8:	70a2                	ld	ra,40(sp)
    800020ea:	7402                	ld	s0,32(sp)
    800020ec:	64e2                	ld	s1,24(sp)
    800020ee:	6942                	ld	s2,16(sp)
    800020f0:	69a2                	ld	s3,8(sp)
    800020f2:	6145                	addi	sp,sp,48
    800020f4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020f6:	00006517          	auipc	a0,0x6
    800020fa:	26a50513          	addi	a0,a0,618 # 80008360 <states.1717+0xe8>
    800020fe:	00004097          	auipc	ra,0x4
    80002102:	d9a080e7          	jalr	-614(ra) # 80005e98 <panic>
    panic("kerneltrap: interrupts enabled");
    80002106:	00006517          	auipc	a0,0x6
    8000210a:	28250513          	addi	a0,a0,642 # 80008388 <states.1717+0x110>
    8000210e:	00004097          	auipc	ra,0x4
    80002112:	d8a080e7          	jalr	-630(ra) # 80005e98 <panic>
    printf("scause %p\n", scause);
    80002116:	85ce                	mv	a1,s3
    80002118:	00006517          	auipc	a0,0x6
    8000211c:	29050513          	addi	a0,a0,656 # 800083a8 <states.1717+0x130>
    80002120:	00004097          	auipc	ra,0x4
    80002124:	dc2080e7          	jalr	-574(ra) # 80005ee2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002128:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000212c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002130:	00006517          	auipc	a0,0x6
    80002134:	28850513          	addi	a0,a0,648 # 800083b8 <states.1717+0x140>
    80002138:	00004097          	auipc	ra,0x4
    8000213c:	daa080e7          	jalr	-598(ra) # 80005ee2 <printf>
    panic("kerneltrap");
    80002140:	00006517          	auipc	a0,0x6
    80002144:	29050513          	addi	a0,a0,656 # 800083d0 <states.1717+0x158>
    80002148:	00004097          	auipc	ra,0x4
    8000214c:	d50080e7          	jalr	-688(ra) # 80005e98 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	ff6080e7          	jalr	-10(ra) # 80001146 <myproc>
    80002158:	d541                	beqz	a0,800020e0 <kerneltrap+0x38>
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	fec080e7          	jalr	-20(ra) # 80001146 <myproc>
    80002162:	4d18                	lw	a4,24(a0)
    80002164:	4791                	li	a5,4
    80002166:	f6f71de3          	bne	a4,a5,800020e0 <kerneltrap+0x38>
    yield();
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	65c080e7          	jalr	1628(ra) # 800017c6 <yield>
    80002172:	b7bd                	j	800020e0 <kerneltrap+0x38>

0000000080002174 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002174:	1101                	addi	sp,sp,-32
    80002176:	ec06                	sd	ra,24(sp)
    80002178:	e822                	sd	s0,16(sp)
    8000217a:	e426                	sd	s1,8(sp)
    8000217c:	1000                	addi	s0,sp,32
    8000217e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	fc6080e7          	jalr	-58(ra) # 80001146 <myproc>
  switch (n) {
    80002188:	4795                	li	a5,5
    8000218a:	0497e163          	bltu	a5,s1,800021cc <argraw+0x58>
    8000218e:	048a                	slli	s1,s1,0x2
    80002190:	00006717          	auipc	a4,0x6
    80002194:	27870713          	addi	a4,a4,632 # 80008408 <states.1717+0x190>
    80002198:	94ba                	add	s1,s1,a4
    8000219a:	409c                	lw	a5,0(s1)
    8000219c:	97ba                	add	a5,a5,a4
    8000219e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800021a0:	6d3c                	ld	a5,88(a0)
    800021a2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021a4:	60e2                	ld	ra,24(sp)
    800021a6:	6442                	ld	s0,16(sp)
    800021a8:	64a2                	ld	s1,8(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret
    return p->trapframe->a1;
    800021ae:	6d3c                	ld	a5,88(a0)
    800021b0:	7fa8                	ld	a0,120(a5)
    800021b2:	bfcd                	j	800021a4 <argraw+0x30>
    return p->trapframe->a2;
    800021b4:	6d3c                	ld	a5,88(a0)
    800021b6:	63c8                	ld	a0,128(a5)
    800021b8:	b7f5                	j	800021a4 <argraw+0x30>
    return p->trapframe->a3;
    800021ba:	6d3c                	ld	a5,88(a0)
    800021bc:	67c8                	ld	a0,136(a5)
    800021be:	b7dd                	j	800021a4 <argraw+0x30>
    return p->trapframe->a4;
    800021c0:	6d3c                	ld	a5,88(a0)
    800021c2:	6bc8                	ld	a0,144(a5)
    800021c4:	b7c5                	j	800021a4 <argraw+0x30>
    return p->trapframe->a5;
    800021c6:	6d3c                	ld	a5,88(a0)
    800021c8:	6fc8                	ld	a0,152(a5)
    800021ca:	bfe9                	j	800021a4 <argraw+0x30>
  panic("argraw");
    800021cc:	00006517          	auipc	a0,0x6
    800021d0:	21450513          	addi	a0,a0,532 # 800083e0 <states.1717+0x168>
    800021d4:	00004097          	auipc	ra,0x4
    800021d8:	cc4080e7          	jalr	-828(ra) # 80005e98 <panic>

00000000800021dc <fetchaddr>:
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	e426                	sd	s1,8(sp)
    800021e4:	e04a                	sd	s2,0(sp)
    800021e6:	1000                	addi	s0,sp,32
    800021e8:	84aa                	mv	s1,a0
    800021ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	f5a080e7          	jalr	-166(ra) # 80001146 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021f4:	653c                	ld	a5,72(a0)
    800021f6:	02f4f863          	bgeu	s1,a5,80002226 <fetchaddr+0x4a>
    800021fa:	00848713          	addi	a4,s1,8
    800021fe:	02e7e663          	bltu	a5,a4,8000222a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002202:	46a1                	li	a3,8
    80002204:	8626                	mv	a2,s1
    80002206:	85ca                	mv	a1,s2
    80002208:	6928                	ld	a0,80(a0)
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	ae8080e7          	jalr	-1304(ra) # 80000cf2 <copyin>
    80002212:	00a03533          	snez	a0,a0
    80002216:	40a00533          	neg	a0,a0
}
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	64a2                	ld	s1,8(sp)
    80002220:	6902                	ld	s2,0(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret
    return -1;
    80002226:	557d                	li	a0,-1
    80002228:	bfcd                	j	8000221a <fetchaddr+0x3e>
    8000222a:	557d                	li	a0,-1
    8000222c:	b7fd                	j	8000221a <fetchaddr+0x3e>

000000008000222e <fetchstr>:
{
    8000222e:	7179                	addi	sp,sp,-48
    80002230:	f406                	sd	ra,40(sp)
    80002232:	f022                	sd	s0,32(sp)
    80002234:	ec26                	sd	s1,24(sp)
    80002236:	e84a                	sd	s2,16(sp)
    80002238:	e44e                	sd	s3,8(sp)
    8000223a:	1800                	addi	s0,sp,48
    8000223c:	892a                	mv	s2,a0
    8000223e:	84ae                	mv	s1,a1
    80002240:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	f04080e7          	jalr	-252(ra) # 80001146 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000224a:	86ce                	mv	a3,s3
    8000224c:	864a                	mv	a2,s2
    8000224e:	85a6                	mv	a1,s1
    80002250:	6928                	ld	a0,80(a0)
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	b2c080e7          	jalr	-1236(ra) # 80000d7e <copyinstr>
  if(err < 0)
    8000225a:	00054763          	bltz	a0,80002268 <fetchstr+0x3a>
  return strlen(buf);
    8000225e:	8526                	mv	a0,s1
    80002260:	ffffe097          	auipc	ra,0xffffe
    80002264:	298080e7          	jalr	664(ra) # 800004f8 <strlen>
}
    80002268:	70a2                	ld	ra,40(sp)
    8000226a:	7402                	ld	s0,32(sp)
    8000226c:	64e2                	ld	s1,24(sp)
    8000226e:	6942                	ld	s2,16(sp)
    80002270:	69a2                	ld	s3,8(sp)
    80002272:	6145                	addi	sp,sp,48
    80002274:	8082                	ret

0000000080002276 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002276:	1101                	addi	sp,sp,-32
    80002278:	ec06                	sd	ra,24(sp)
    8000227a:	e822                	sd	s0,16(sp)
    8000227c:	e426                	sd	s1,8(sp)
    8000227e:	1000                	addi	s0,sp,32
    80002280:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002282:	00000097          	auipc	ra,0x0
    80002286:	ef2080e7          	jalr	-270(ra) # 80002174 <argraw>
    8000228a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000228c:	4501                	li	a0,0
    8000228e:	60e2                	ld	ra,24(sp)
    80002290:	6442                	ld	s0,16(sp)
    80002292:	64a2                	ld	s1,8(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002298:	1101                	addi	sp,sp,-32
    8000229a:	ec06                	sd	ra,24(sp)
    8000229c:	e822                	sd	s0,16(sp)
    8000229e:	e426                	sd	s1,8(sp)
    800022a0:	1000                	addi	s0,sp,32
    800022a2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	ed0080e7          	jalr	-304(ra) # 80002174 <argraw>
    800022ac:	e088                	sd	a0,0(s1)
  return 0;
}
    800022ae:	4501                	li	a0,0
    800022b0:	60e2                	ld	ra,24(sp)
    800022b2:	6442                	ld	s0,16(sp)
    800022b4:	64a2                	ld	s1,8(sp)
    800022b6:	6105                	addi	sp,sp,32
    800022b8:	8082                	ret

00000000800022ba <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	e426                	sd	s1,8(sp)
    800022c2:	e04a                	sd	s2,0(sp)
    800022c4:	1000                	addi	s0,sp,32
    800022c6:	84ae                	mv	s1,a1
    800022c8:	8932                	mv	s2,a2
  *ip = argraw(n);
    800022ca:	00000097          	auipc	ra,0x0
    800022ce:	eaa080e7          	jalr	-342(ra) # 80002174 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800022d2:	864a                	mv	a2,s2
    800022d4:	85a6                	mv	a1,s1
    800022d6:	00000097          	auipc	ra,0x0
    800022da:	f58080e7          	jalr	-168(ra) # 8000222e <fetchstr>
}
    800022de:	60e2                	ld	ra,24(sp)
    800022e0:	6442                	ld	s0,16(sp)
    800022e2:	64a2                	ld	s1,8(sp)
    800022e4:	6902                	ld	s2,0(sp)
    800022e6:	6105                	addi	sp,sp,32
    800022e8:	8082                	ret

00000000800022ea <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800022ea:	1101                	addi	sp,sp,-32
    800022ec:	ec06                	sd	ra,24(sp)
    800022ee:	e822                	sd	s0,16(sp)
    800022f0:	e426                	sd	s1,8(sp)
    800022f2:	e04a                	sd	s2,0(sp)
    800022f4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	e50080e7          	jalr	-432(ra) # 80001146 <myproc>
    800022fe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002300:	05853903          	ld	s2,88(a0)
    80002304:	0a893783          	ld	a5,168(s2)
    80002308:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000230c:	37fd                	addiw	a5,a5,-1
    8000230e:	4751                	li	a4,20
    80002310:	00f76f63          	bltu	a4,a5,8000232e <syscall+0x44>
    80002314:	00369713          	slli	a4,a3,0x3
    80002318:	00006797          	auipc	a5,0x6
    8000231c:	10878793          	addi	a5,a5,264 # 80008420 <syscalls>
    80002320:	97ba                	add	a5,a5,a4
    80002322:	639c                	ld	a5,0(a5)
    80002324:	c789                	beqz	a5,8000232e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002326:	9782                	jalr	a5
    80002328:	06a93823          	sd	a0,112(s2)
    8000232c:	a839                	j	8000234a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000232e:	15848613          	addi	a2,s1,344
    80002332:	588c                	lw	a1,48(s1)
    80002334:	00006517          	auipc	a0,0x6
    80002338:	0b450513          	addi	a0,a0,180 # 800083e8 <states.1717+0x170>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	ba6080e7          	jalr	-1114(ra) # 80005ee2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002344:	6cbc                	ld	a5,88(s1)
    80002346:	577d                	li	a4,-1
    80002348:	fbb8                	sd	a4,112(a5)
  }
}
    8000234a:	60e2                	ld	ra,24(sp)
    8000234c:	6442                	ld	s0,16(sp)
    8000234e:	64a2                	ld	s1,8(sp)
    80002350:	6902                	ld	s2,0(sp)
    80002352:	6105                	addi	sp,sp,32
    80002354:	8082                	ret

0000000080002356 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000235e:	fec40593          	addi	a1,s0,-20
    80002362:	4501                	li	a0,0
    80002364:	00000097          	auipc	ra,0x0
    80002368:	f12080e7          	jalr	-238(ra) # 80002276 <argint>
    return -1;
    8000236c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000236e:	00054963          	bltz	a0,80002380 <sys_exit+0x2a>
  exit(n);
    80002372:	fec42503          	lw	a0,-20(s0)
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	6e8080e7          	jalr	1768(ra) # 80001a5e <exit>
  return 0;  // not reached
    8000237e:	4781                	li	a5,0
}
    80002380:	853e                	mv	a0,a5
    80002382:	60e2                	ld	ra,24(sp)
    80002384:	6442                	ld	s0,16(sp)
    80002386:	6105                	addi	sp,sp,32
    80002388:	8082                	ret

000000008000238a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000238a:	1141                	addi	sp,sp,-16
    8000238c:	e406                	sd	ra,8(sp)
    8000238e:	e022                	sd	s0,0(sp)
    80002390:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	db4080e7          	jalr	-588(ra) # 80001146 <myproc>
}
    8000239a:	5908                	lw	a0,48(a0)
    8000239c:	60a2                	ld	ra,8(sp)
    8000239e:	6402                	ld	s0,0(sp)
    800023a0:	0141                	addi	sp,sp,16
    800023a2:	8082                	ret

00000000800023a4 <sys_fork>:

uint64
sys_fork(void)
{
    800023a4:	1141                	addi	sp,sp,-16
    800023a6:	e406                	sd	ra,8(sp)
    800023a8:	e022                	sd	s0,0(sp)
    800023aa:	0800                	addi	s0,sp,16
  return fork();
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	168080e7          	jalr	360(ra) # 80001514 <fork>
}
    800023b4:	60a2                	ld	ra,8(sp)
    800023b6:	6402                	ld	s0,0(sp)
    800023b8:	0141                	addi	sp,sp,16
    800023ba:	8082                	ret

00000000800023bc <sys_wait>:

uint64
sys_wait(void)
{
    800023bc:	1101                	addi	sp,sp,-32
    800023be:	ec06                	sd	ra,24(sp)
    800023c0:	e822                	sd	s0,16(sp)
    800023c2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800023c4:	fe840593          	addi	a1,s0,-24
    800023c8:	4501                	li	a0,0
    800023ca:	00000097          	auipc	ra,0x0
    800023ce:	ece080e7          	jalr	-306(ra) # 80002298 <argaddr>
    800023d2:	87aa                	mv	a5,a0
    return -1;
    800023d4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800023d6:	0007c863          	bltz	a5,800023e6 <sys_wait+0x2a>
  return wait(p);
    800023da:	fe843503          	ld	a0,-24(s0)
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	488080e7          	jalr	1160(ra) # 80001866 <wait>
}
    800023e6:	60e2                	ld	ra,24(sp)
    800023e8:	6442                	ld	s0,16(sp)
    800023ea:	6105                	addi	sp,sp,32
    800023ec:	8082                	ret

00000000800023ee <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023ee:	7179                	addi	sp,sp,-48
    800023f0:	f406                	sd	ra,40(sp)
    800023f2:	f022                	sd	s0,32(sp)
    800023f4:	ec26                	sd	s1,24(sp)
    800023f6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023f8:	fdc40593          	addi	a1,s0,-36
    800023fc:	4501                	li	a0,0
    800023fe:	00000097          	auipc	ra,0x0
    80002402:	e78080e7          	jalr	-392(ra) # 80002276 <argint>
    80002406:	87aa                	mv	a5,a0
    return -1;
    80002408:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000240a:	0207c063          	bltz	a5,8000242a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	d38080e7          	jalr	-712(ra) # 80001146 <myproc>
    80002416:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002418:	fdc42503          	lw	a0,-36(s0)
    8000241c:	fffff097          	auipc	ra,0xfffff
    80002420:	084080e7          	jalr	132(ra) # 800014a0 <growproc>
    80002424:	00054863          	bltz	a0,80002434 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002428:	8526                	mv	a0,s1
}
    8000242a:	70a2                	ld	ra,40(sp)
    8000242c:	7402                	ld	s0,32(sp)
    8000242e:	64e2                	ld	s1,24(sp)
    80002430:	6145                	addi	sp,sp,48
    80002432:	8082                	ret
    return -1;
    80002434:	557d                	li	a0,-1
    80002436:	bfd5                	j	8000242a <sys_sbrk+0x3c>

0000000080002438 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002438:	7139                	addi	sp,sp,-64
    8000243a:	fc06                	sd	ra,56(sp)
    8000243c:	f822                	sd	s0,48(sp)
    8000243e:	f426                	sd	s1,40(sp)
    80002440:	f04a                	sd	s2,32(sp)
    80002442:	ec4e                	sd	s3,24(sp)
    80002444:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002446:	fcc40593          	addi	a1,s0,-52
    8000244a:	4501                	li	a0,0
    8000244c:	00000097          	auipc	ra,0x0
    80002450:	e2a080e7          	jalr	-470(ra) # 80002276 <argint>
    return -1;
    80002454:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002456:	06054563          	bltz	a0,800024c0 <sys_sleep+0x88>
  acquire(&tickslock);
    8000245a:	0000d517          	auipc	a0,0xd
    8000245e:	a3e50513          	addi	a0,a0,-1474 # 8000ee98 <tickslock>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	f80080e7          	jalr	-128(ra) # 800063e2 <acquire>
  ticks0 = ticks;
    8000246a:	00007917          	auipc	s2,0x7
    8000246e:	bae92903          	lw	s2,-1106(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002472:	fcc42783          	lw	a5,-52(s0)
    80002476:	cf85                	beqz	a5,800024ae <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002478:	0000d997          	auipc	s3,0xd
    8000247c:	a2098993          	addi	s3,s3,-1504 # 8000ee98 <tickslock>
    80002480:	00007497          	auipc	s1,0x7
    80002484:	b9848493          	addi	s1,s1,-1128 # 80009018 <ticks>
    if(myproc()->killed){
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	cbe080e7          	jalr	-834(ra) # 80001146 <myproc>
    80002490:	551c                	lw	a5,40(a0)
    80002492:	ef9d                	bnez	a5,800024d0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002494:	85ce                	mv	a1,s3
    80002496:	8526                	mv	a0,s1
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	36a080e7          	jalr	874(ra) # 80001802 <sleep>
  while(ticks - ticks0 < n){
    800024a0:	409c                	lw	a5,0(s1)
    800024a2:	412787bb          	subw	a5,a5,s2
    800024a6:	fcc42703          	lw	a4,-52(s0)
    800024aa:	fce7efe3          	bltu	a5,a4,80002488 <sys_sleep+0x50>
  }
  release(&tickslock);
    800024ae:	0000d517          	auipc	a0,0xd
    800024b2:	9ea50513          	addi	a0,a0,-1558 # 8000ee98 <tickslock>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	fe0080e7          	jalr	-32(ra) # 80006496 <release>
  return 0;
    800024be:	4781                	li	a5,0
}
    800024c0:	853e                	mv	a0,a5
    800024c2:	70e2                	ld	ra,56(sp)
    800024c4:	7442                	ld	s0,48(sp)
    800024c6:	74a2                	ld	s1,40(sp)
    800024c8:	7902                	ld	s2,32(sp)
    800024ca:	69e2                	ld	s3,24(sp)
    800024cc:	6121                	addi	sp,sp,64
    800024ce:	8082                	ret
      release(&tickslock);
    800024d0:	0000d517          	auipc	a0,0xd
    800024d4:	9c850513          	addi	a0,a0,-1592 # 8000ee98 <tickslock>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	fbe080e7          	jalr	-66(ra) # 80006496 <release>
      return -1;
    800024e0:	57fd                	li	a5,-1
    800024e2:	bff9                	j	800024c0 <sys_sleep+0x88>

00000000800024e4 <sys_kill>:

uint64
sys_kill(void)
{
    800024e4:	1101                	addi	sp,sp,-32
    800024e6:	ec06                	sd	ra,24(sp)
    800024e8:	e822                	sd	s0,16(sp)
    800024ea:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024ec:	fec40593          	addi	a1,s0,-20
    800024f0:	4501                	li	a0,0
    800024f2:	00000097          	auipc	ra,0x0
    800024f6:	d84080e7          	jalr	-636(ra) # 80002276 <argint>
    800024fa:	87aa                	mv	a5,a0
    return -1;
    800024fc:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024fe:	0007c863          	bltz	a5,8000250e <sys_kill+0x2a>
  return kill(pid);
    80002502:	fec42503          	lw	a0,-20(s0)
    80002506:	fffff097          	auipc	ra,0xfffff
    8000250a:	62e080e7          	jalr	1582(ra) # 80001b34 <kill>
}
    8000250e:	60e2                	ld	ra,24(sp)
    80002510:	6442                	ld	s0,16(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret

0000000080002516 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002520:	0000d517          	auipc	a0,0xd
    80002524:	97850513          	addi	a0,a0,-1672 # 8000ee98 <tickslock>
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	eba080e7          	jalr	-326(ra) # 800063e2 <acquire>
  xticks = ticks;
    80002530:	00007497          	auipc	s1,0x7
    80002534:	ae84a483          	lw	s1,-1304(s1) # 80009018 <ticks>
  release(&tickslock);
    80002538:	0000d517          	auipc	a0,0xd
    8000253c:	96050513          	addi	a0,a0,-1696 # 8000ee98 <tickslock>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	f56080e7          	jalr	-170(ra) # 80006496 <release>
  return xticks;
}
    80002548:	02049513          	slli	a0,s1,0x20
    8000254c:	9101                	srli	a0,a0,0x20
    8000254e:	60e2                	ld	ra,24(sp)
    80002550:	6442                	ld	s0,16(sp)
    80002552:	64a2                	ld	s1,8(sp)
    80002554:	6105                	addi	sp,sp,32
    80002556:	8082                	ret

0000000080002558 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002558:	7179                	addi	sp,sp,-48
    8000255a:	f406                	sd	ra,40(sp)
    8000255c:	f022                	sd	s0,32(sp)
    8000255e:	ec26                	sd	s1,24(sp)
    80002560:	e84a                	sd	s2,16(sp)
    80002562:	e44e                	sd	s3,8(sp)
    80002564:	e052                	sd	s4,0(sp)
    80002566:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002568:	00006597          	auipc	a1,0x6
    8000256c:	f6858593          	addi	a1,a1,-152 # 800084d0 <syscalls+0xb0>
    80002570:	0000d517          	auipc	a0,0xd
    80002574:	94050513          	addi	a0,a0,-1728 # 8000eeb0 <bcache>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	dda080e7          	jalr	-550(ra) # 80006352 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002580:	00015797          	auipc	a5,0x15
    80002584:	93078793          	addi	a5,a5,-1744 # 80016eb0 <bcache+0x8000>
    80002588:	00015717          	auipc	a4,0x15
    8000258c:	b9070713          	addi	a4,a4,-1136 # 80017118 <bcache+0x8268>
    80002590:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002594:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002598:	0000d497          	auipc	s1,0xd
    8000259c:	93048493          	addi	s1,s1,-1744 # 8000eec8 <bcache+0x18>
    b->next = bcache.head.next;
    800025a0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025a2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025a4:	00006a17          	auipc	s4,0x6
    800025a8:	f34a0a13          	addi	s4,s4,-204 # 800084d8 <syscalls+0xb8>
    b->next = bcache.head.next;
    800025ac:	2b893783          	ld	a5,696(s2)
    800025b0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025b2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025b6:	85d2                	mv	a1,s4
    800025b8:	01048513          	addi	a0,s1,16
    800025bc:	00001097          	auipc	ra,0x1
    800025c0:	4bc080e7          	jalr	1212(ra) # 80003a78 <initsleeplock>
    bcache.head.next->prev = b;
    800025c4:	2b893783          	ld	a5,696(s2)
    800025c8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025ca:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025ce:	45848493          	addi	s1,s1,1112
    800025d2:	fd349de3          	bne	s1,s3,800025ac <binit+0x54>
  }
}
    800025d6:	70a2                	ld	ra,40(sp)
    800025d8:	7402                	ld	s0,32(sp)
    800025da:	64e2                	ld	s1,24(sp)
    800025dc:	6942                	ld	s2,16(sp)
    800025de:	69a2                	ld	s3,8(sp)
    800025e0:	6a02                	ld	s4,0(sp)
    800025e2:	6145                	addi	sp,sp,48
    800025e4:	8082                	ret

00000000800025e6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025e6:	7179                	addi	sp,sp,-48
    800025e8:	f406                	sd	ra,40(sp)
    800025ea:	f022                	sd	s0,32(sp)
    800025ec:	ec26                	sd	s1,24(sp)
    800025ee:	e84a                	sd	s2,16(sp)
    800025f0:	e44e                	sd	s3,8(sp)
    800025f2:	1800                	addi	s0,sp,48
    800025f4:	89aa                	mv	s3,a0
    800025f6:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800025f8:	0000d517          	auipc	a0,0xd
    800025fc:	8b850513          	addi	a0,a0,-1864 # 8000eeb0 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	de2080e7          	jalr	-542(ra) # 800063e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002608:	00015497          	auipc	s1,0x15
    8000260c:	b604b483          	ld	s1,-1184(s1) # 80017168 <bcache+0x82b8>
    80002610:	00015797          	auipc	a5,0x15
    80002614:	b0878793          	addi	a5,a5,-1272 # 80017118 <bcache+0x8268>
    80002618:	02f48f63          	beq	s1,a5,80002656 <bread+0x70>
    8000261c:	873e                	mv	a4,a5
    8000261e:	a021                	j	80002626 <bread+0x40>
    80002620:	68a4                	ld	s1,80(s1)
    80002622:	02e48a63          	beq	s1,a4,80002656 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002626:	449c                	lw	a5,8(s1)
    80002628:	ff379ce3          	bne	a5,s3,80002620 <bread+0x3a>
    8000262c:	44dc                	lw	a5,12(s1)
    8000262e:	ff2799e3          	bne	a5,s2,80002620 <bread+0x3a>
      b->refcnt++;
    80002632:	40bc                	lw	a5,64(s1)
    80002634:	2785                	addiw	a5,a5,1
    80002636:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002638:	0000d517          	auipc	a0,0xd
    8000263c:	87850513          	addi	a0,a0,-1928 # 8000eeb0 <bcache>
    80002640:	00004097          	auipc	ra,0x4
    80002644:	e56080e7          	jalr	-426(ra) # 80006496 <release>
      acquiresleep(&b->lock);
    80002648:	01048513          	addi	a0,s1,16
    8000264c:	00001097          	auipc	ra,0x1
    80002650:	466080e7          	jalr	1126(ra) # 80003ab2 <acquiresleep>
      return b;
    80002654:	a8b9                	j	800026b2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002656:	00015497          	auipc	s1,0x15
    8000265a:	b0a4b483          	ld	s1,-1270(s1) # 80017160 <bcache+0x82b0>
    8000265e:	00015797          	auipc	a5,0x15
    80002662:	aba78793          	addi	a5,a5,-1350 # 80017118 <bcache+0x8268>
    80002666:	00f48863          	beq	s1,a5,80002676 <bread+0x90>
    8000266a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000266c:	40bc                	lw	a5,64(s1)
    8000266e:	cf81                	beqz	a5,80002686 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002670:	64a4                	ld	s1,72(s1)
    80002672:	fee49de3          	bne	s1,a4,8000266c <bread+0x86>
  panic("bget: no buffers");
    80002676:	00006517          	auipc	a0,0x6
    8000267a:	e6a50513          	addi	a0,a0,-406 # 800084e0 <syscalls+0xc0>
    8000267e:	00004097          	auipc	ra,0x4
    80002682:	81a080e7          	jalr	-2022(ra) # 80005e98 <panic>
      b->dev = dev;
    80002686:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000268a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000268e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002692:	4785                	li	a5,1
    80002694:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002696:	0000d517          	auipc	a0,0xd
    8000269a:	81a50513          	addi	a0,a0,-2022 # 8000eeb0 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	df8080e7          	jalr	-520(ra) # 80006496 <release>
      acquiresleep(&b->lock);
    800026a6:	01048513          	addi	a0,s1,16
    800026aa:	00001097          	auipc	ra,0x1
    800026ae:	408080e7          	jalr	1032(ra) # 80003ab2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026b2:	409c                	lw	a5,0(s1)
    800026b4:	cb89                	beqz	a5,800026c6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026b6:	8526                	mv	a0,s1
    800026b8:	70a2                	ld	ra,40(sp)
    800026ba:	7402                	ld	s0,32(sp)
    800026bc:	64e2                	ld	s1,24(sp)
    800026be:	6942                	ld	s2,16(sp)
    800026c0:	69a2                	ld	s3,8(sp)
    800026c2:	6145                	addi	sp,sp,48
    800026c4:	8082                	ret
    virtio_disk_rw(b, 0);
    800026c6:	4581                	li	a1,0
    800026c8:	8526                	mv	a0,s1
    800026ca:	00003097          	auipc	ra,0x3
    800026ce:	f0c080e7          	jalr	-244(ra) # 800055d6 <virtio_disk_rw>
    b->valid = 1;
    800026d2:	4785                	li	a5,1
    800026d4:	c09c                	sw	a5,0(s1)
  return b;
    800026d6:	b7c5                	j	800026b6 <bread+0xd0>

00000000800026d8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026e4:	0541                	addi	a0,a0,16
    800026e6:	00001097          	auipc	ra,0x1
    800026ea:	466080e7          	jalr	1126(ra) # 80003b4c <holdingsleep>
    800026ee:	cd01                	beqz	a0,80002706 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026f0:	4585                	li	a1,1
    800026f2:	8526                	mv	a0,s1
    800026f4:	00003097          	auipc	ra,0x3
    800026f8:	ee2080e7          	jalr	-286(ra) # 800055d6 <virtio_disk_rw>
}
    800026fc:	60e2                	ld	ra,24(sp)
    800026fe:	6442                	ld	s0,16(sp)
    80002700:	64a2                	ld	s1,8(sp)
    80002702:	6105                	addi	sp,sp,32
    80002704:	8082                	ret
    panic("bwrite");
    80002706:	00006517          	auipc	a0,0x6
    8000270a:	df250513          	addi	a0,a0,-526 # 800084f8 <syscalls+0xd8>
    8000270e:	00003097          	auipc	ra,0x3
    80002712:	78a080e7          	jalr	1930(ra) # 80005e98 <panic>

0000000080002716 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	e04a                	sd	s2,0(sp)
    80002720:	1000                	addi	s0,sp,32
    80002722:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002724:	01050913          	addi	s2,a0,16
    80002728:	854a                	mv	a0,s2
    8000272a:	00001097          	auipc	ra,0x1
    8000272e:	422080e7          	jalr	1058(ra) # 80003b4c <holdingsleep>
    80002732:	c92d                	beqz	a0,800027a4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002734:	854a                	mv	a0,s2
    80002736:	00001097          	auipc	ra,0x1
    8000273a:	3d2080e7          	jalr	978(ra) # 80003b08 <releasesleep>

  acquire(&bcache.lock);
    8000273e:	0000c517          	auipc	a0,0xc
    80002742:	77250513          	addi	a0,a0,1906 # 8000eeb0 <bcache>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	c9c080e7          	jalr	-868(ra) # 800063e2 <acquire>
  b->refcnt--;
    8000274e:	40bc                	lw	a5,64(s1)
    80002750:	37fd                	addiw	a5,a5,-1
    80002752:	0007871b          	sext.w	a4,a5
    80002756:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002758:	eb05                	bnez	a4,80002788 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000275a:	68bc                	ld	a5,80(s1)
    8000275c:	64b8                	ld	a4,72(s1)
    8000275e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002760:	64bc                	ld	a5,72(s1)
    80002762:	68b8                	ld	a4,80(s1)
    80002764:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002766:	00014797          	auipc	a5,0x14
    8000276a:	74a78793          	addi	a5,a5,1866 # 80016eb0 <bcache+0x8000>
    8000276e:	2b87b703          	ld	a4,696(a5)
    80002772:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002774:	00015717          	auipc	a4,0x15
    80002778:	9a470713          	addi	a4,a4,-1628 # 80017118 <bcache+0x8268>
    8000277c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000277e:	2b87b703          	ld	a4,696(a5)
    80002782:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002784:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002788:	0000c517          	auipc	a0,0xc
    8000278c:	72850513          	addi	a0,a0,1832 # 8000eeb0 <bcache>
    80002790:	00004097          	auipc	ra,0x4
    80002794:	d06080e7          	jalr	-762(ra) # 80006496 <release>
}
    80002798:	60e2                	ld	ra,24(sp)
    8000279a:	6442                	ld	s0,16(sp)
    8000279c:	64a2                	ld	s1,8(sp)
    8000279e:	6902                	ld	s2,0(sp)
    800027a0:	6105                	addi	sp,sp,32
    800027a2:	8082                	ret
    panic("brelse");
    800027a4:	00006517          	auipc	a0,0x6
    800027a8:	d5c50513          	addi	a0,a0,-676 # 80008500 <syscalls+0xe0>
    800027ac:	00003097          	auipc	ra,0x3
    800027b0:	6ec080e7          	jalr	1772(ra) # 80005e98 <panic>

00000000800027b4 <bpin>:

void
bpin(struct buf *b) {
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	e426                	sd	s1,8(sp)
    800027bc:	1000                	addi	s0,sp,32
    800027be:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027c0:	0000c517          	auipc	a0,0xc
    800027c4:	6f050513          	addi	a0,a0,1776 # 8000eeb0 <bcache>
    800027c8:	00004097          	auipc	ra,0x4
    800027cc:	c1a080e7          	jalr	-998(ra) # 800063e2 <acquire>
  b->refcnt++;
    800027d0:	40bc                	lw	a5,64(s1)
    800027d2:	2785                	addiw	a5,a5,1
    800027d4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027d6:	0000c517          	auipc	a0,0xc
    800027da:	6da50513          	addi	a0,a0,1754 # 8000eeb0 <bcache>
    800027de:	00004097          	auipc	ra,0x4
    800027e2:	cb8080e7          	jalr	-840(ra) # 80006496 <release>
}
    800027e6:	60e2                	ld	ra,24(sp)
    800027e8:	6442                	ld	s0,16(sp)
    800027ea:	64a2                	ld	s1,8(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret

00000000800027f0 <bunpin>:

void
bunpin(struct buf *b) {
    800027f0:	1101                	addi	sp,sp,-32
    800027f2:	ec06                	sd	ra,24(sp)
    800027f4:	e822                	sd	s0,16(sp)
    800027f6:	e426                	sd	s1,8(sp)
    800027f8:	1000                	addi	s0,sp,32
    800027fa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027fc:	0000c517          	auipc	a0,0xc
    80002800:	6b450513          	addi	a0,a0,1716 # 8000eeb0 <bcache>
    80002804:	00004097          	auipc	ra,0x4
    80002808:	bde080e7          	jalr	-1058(ra) # 800063e2 <acquire>
  b->refcnt--;
    8000280c:	40bc                	lw	a5,64(s1)
    8000280e:	37fd                	addiw	a5,a5,-1
    80002810:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002812:	0000c517          	auipc	a0,0xc
    80002816:	69e50513          	addi	a0,a0,1694 # 8000eeb0 <bcache>
    8000281a:	00004097          	auipc	ra,0x4
    8000281e:	c7c080e7          	jalr	-900(ra) # 80006496 <release>
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret

000000008000282c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000282c:	1101                	addi	sp,sp,-32
    8000282e:	ec06                	sd	ra,24(sp)
    80002830:	e822                	sd	s0,16(sp)
    80002832:	e426                	sd	s1,8(sp)
    80002834:	e04a                	sd	s2,0(sp)
    80002836:	1000                	addi	s0,sp,32
    80002838:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000283a:	00d5d59b          	srliw	a1,a1,0xd
    8000283e:	00015797          	auipc	a5,0x15
    80002842:	d4e7a783          	lw	a5,-690(a5) # 8001758c <sb+0x1c>
    80002846:	9dbd                	addw	a1,a1,a5
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	d9e080e7          	jalr	-610(ra) # 800025e6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002850:	0074f713          	andi	a4,s1,7
    80002854:	4785                	li	a5,1
    80002856:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000285a:	14ce                	slli	s1,s1,0x33
    8000285c:	90d9                	srli	s1,s1,0x36
    8000285e:	00950733          	add	a4,a0,s1
    80002862:	05874703          	lbu	a4,88(a4)
    80002866:	00e7f6b3          	and	a3,a5,a4
    8000286a:	c69d                	beqz	a3,80002898 <bfree+0x6c>
    8000286c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000286e:	94aa                	add	s1,s1,a0
    80002870:	fff7c793          	not	a5,a5
    80002874:	8ff9                	and	a5,a5,a4
    80002876:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000287a:	00001097          	auipc	ra,0x1
    8000287e:	118080e7          	jalr	280(ra) # 80003992 <log_write>
  brelse(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e92080e7          	jalr	-366(ra) # 80002716 <brelse>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6902                	ld	s2,0(sp)
    80002894:	6105                	addi	sp,sp,32
    80002896:	8082                	ret
    panic("freeing free block");
    80002898:	00006517          	auipc	a0,0x6
    8000289c:	c7050513          	addi	a0,a0,-912 # 80008508 <syscalls+0xe8>
    800028a0:	00003097          	auipc	ra,0x3
    800028a4:	5f8080e7          	jalr	1528(ra) # 80005e98 <panic>

00000000800028a8 <balloc>:
{
    800028a8:	711d                	addi	sp,sp,-96
    800028aa:	ec86                	sd	ra,88(sp)
    800028ac:	e8a2                	sd	s0,80(sp)
    800028ae:	e4a6                	sd	s1,72(sp)
    800028b0:	e0ca                	sd	s2,64(sp)
    800028b2:	fc4e                	sd	s3,56(sp)
    800028b4:	f852                	sd	s4,48(sp)
    800028b6:	f456                	sd	s5,40(sp)
    800028b8:	f05a                	sd	s6,32(sp)
    800028ba:	ec5e                	sd	s7,24(sp)
    800028bc:	e862                	sd	s8,16(sp)
    800028be:	e466                	sd	s9,8(sp)
    800028c0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028c2:	00015797          	auipc	a5,0x15
    800028c6:	cb27a783          	lw	a5,-846(a5) # 80017574 <sb+0x4>
    800028ca:	cbd1                	beqz	a5,8000295e <balloc+0xb6>
    800028cc:	8baa                	mv	s7,a0
    800028ce:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028d0:	00015b17          	auipc	s6,0x15
    800028d4:	ca0b0b13          	addi	s6,s6,-864 # 80017570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028da:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028dc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028de:	6c89                	lui	s9,0x2
    800028e0:	a831                	j	800028fc <balloc+0x54>
    brelse(bp);
    800028e2:	854a                	mv	a0,s2
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	e32080e7          	jalr	-462(ra) # 80002716 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ec:	015c87bb          	addw	a5,s9,s5
    800028f0:	00078a9b          	sext.w	s5,a5
    800028f4:	004b2703          	lw	a4,4(s6)
    800028f8:	06eaf363          	bgeu	s5,a4,8000295e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028fc:	41fad79b          	sraiw	a5,s5,0x1f
    80002900:	0137d79b          	srliw	a5,a5,0x13
    80002904:	015787bb          	addw	a5,a5,s5
    80002908:	40d7d79b          	sraiw	a5,a5,0xd
    8000290c:	01cb2583          	lw	a1,28(s6)
    80002910:	9dbd                	addw	a1,a1,a5
    80002912:	855e                	mv	a0,s7
    80002914:	00000097          	auipc	ra,0x0
    80002918:	cd2080e7          	jalr	-814(ra) # 800025e6 <bread>
    8000291c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000291e:	004b2503          	lw	a0,4(s6)
    80002922:	000a849b          	sext.w	s1,s5
    80002926:	8662                	mv	a2,s8
    80002928:	faa4fde3          	bgeu	s1,a0,800028e2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000292c:	41f6579b          	sraiw	a5,a2,0x1f
    80002930:	01d7d69b          	srliw	a3,a5,0x1d
    80002934:	00c6873b          	addw	a4,a3,a2
    80002938:	00777793          	andi	a5,a4,7
    8000293c:	9f95                	subw	a5,a5,a3
    8000293e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002942:	4037571b          	sraiw	a4,a4,0x3
    80002946:	00e906b3          	add	a3,s2,a4
    8000294a:	0586c683          	lbu	a3,88(a3)
    8000294e:	00d7f5b3          	and	a1,a5,a3
    80002952:	cd91                	beqz	a1,8000296e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002954:	2605                	addiw	a2,a2,1
    80002956:	2485                	addiw	s1,s1,1
    80002958:	fd4618e3          	bne	a2,s4,80002928 <balloc+0x80>
    8000295c:	b759                	j	800028e2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000295e:	00006517          	auipc	a0,0x6
    80002962:	bc250513          	addi	a0,a0,-1086 # 80008520 <syscalls+0x100>
    80002966:	00003097          	auipc	ra,0x3
    8000296a:	532080e7          	jalr	1330(ra) # 80005e98 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000296e:	974a                	add	a4,a4,s2
    80002970:	8fd5                	or	a5,a5,a3
    80002972:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002976:	854a                	mv	a0,s2
    80002978:	00001097          	auipc	ra,0x1
    8000297c:	01a080e7          	jalr	26(ra) # 80003992 <log_write>
        brelse(bp);
    80002980:	854a                	mv	a0,s2
    80002982:	00000097          	auipc	ra,0x0
    80002986:	d94080e7          	jalr	-620(ra) # 80002716 <brelse>
  bp = bread(dev, bno);
    8000298a:	85a6                	mv	a1,s1
    8000298c:	855e                	mv	a0,s7
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	c58080e7          	jalr	-936(ra) # 800025e6 <bread>
    80002996:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002998:	40000613          	li	a2,1024
    8000299c:	4581                	li	a1,0
    8000299e:	05850513          	addi	a0,a0,88
    800029a2:	ffffe097          	auipc	ra,0xffffe
    800029a6:	9d2080e7          	jalr	-1582(ra) # 80000374 <memset>
  log_write(bp);
    800029aa:	854a                	mv	a0,s2
    800029ac:	00001097          	auipc	ra,0x1
    800029b0:	fe6080e7          	jalr	-26(ra) # 80003992 <log_write>
  brelse(bp);
    800029b4:	854a                	mv	a0,s2
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	d60080e7          	jalr	-672(ra) # 80002716 <brelse>
}
    800029be:	8526                	mv	a0,s1
    800029c0:	60e6                	ld	ra,88(sp)
    800029c2:	6446                	ld	s0,80(sp)
    800029c4:	64a6                	ld	s1,72(sp)
    800029c6:	6906                	ld	s2,64(sp)
    800029c8:	79e2                	ld	s3,56(sp)
    800029ca:	7a42                	ld	s4,48(sp)
    800029cc:	7aa2                	ld	s5,40(sp)
    800029ce:	7b02                	ld	s6,32(sp)
    800029d0:	6be2                	ld	s7,24(sp)
    800029d2:	6c42                	ld	s8,16(sp)
    800029d4:	6ca2                	ld	s9,8(sp)
    800029d6:	6125                	addi	sp,sp,96
    800029d8:	8082                	ret

00000000800029da <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029da:	7179                	addi	sp,sp,-48
    800029dc:	f406                	sd	ra,40(sp)
    800029de:	f022                	sd	s0,32(sp)
    800029e0:	ec26                	sd	s1,24(sp)
    800029e2:	e84a                	sd	s2,16(sp)
    800029e4:	e44e                	sd	s3,8(sp)
    800029e6:	e052                	sd	s4,0(sp)
    800029e8:	1800                	addi	s0,sp,48
    800029ea:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029ec:	47ad                	li	a5,11
    800029ee:	04b7fe63          	bgeu	a5,a1,80002a4a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029f2:	ff45849b          	addiw	s1,a1,-12
    800029f6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029fa:	0ff00793          	li	a5,255
    800029fe:	0ae7e363          	bltu	a5,a4,80002aa4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a02:	08052583          	lw	a1,128(a0)
    80002a06:	c5ad                	beqz	a1,80002a70 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a08:	00092503          	lw	a0,0(s2)
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	bda080e7          	jalr	-1062(ra) # 800025e6 <bread>
    80002a14:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a16:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a1a:	02049593          	slli	a1,s1,0x20
    80002a1e:	9181                	srli	a1,a1,0x20
    80002a20:	058a                	slli	a1,a1,0x2
    80002a22:	00b784b3          	add	s1,a5,a1
    80002a26:	0004a983          	lw	s3,0(s1)
    80002a2a:	04098d63          	beqz	s3,80002a84 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a2e:	8552                	mv	a0,s4
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	ce6080e7          	jalr	-794(ra) # 80002716 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a38:	854e                	mv	a0,s3
    80002a3a:	70a2                	ld	ra,40(sp)
    80002a3c:	7402                	ld	s0,32(sp)
    80002a3e:	64e2                	ld	s1,24(sp)
    80002a40:	6942                	ld	s2,16(sp)
    80002a42:	69a2                	ld	s3,8(sp)
    80002a44:	6a02                	ld	s4,0(sp)
    80002a46:	6145                	addi	sp,sp,48
    80002a48:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a4a:	02059493          	slli	s1,a1,0x20
    80002a4e:	9081                	srli	s1,s1,0x20
    80002a50:	048a                	slli	s1,s1,0x2
    80002a52:	94aa                	add	s1,s1,a0
    80002a54:	0504a983          	lw	s3,80(s1)
    80002a58:	fe0990e3          	bnez	s3,80002a38 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a5c:	4108                	lw	a0,0(a0)
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	e4a080e7          	jalr	-438(ra) # 800028a8 <balloc>
    80002a66:	0005099b          	sext.w	s3,a0
    80002a6a:	0534a823          	sw	s3,80(s1)
    80002a6e:	b7e9                	j	80002a38 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a70:	4108                	lw	a0,0(a0)
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	e36080e7          	jalr	-458(ra) # 800028a8 <balloc>
    80002a7a:	0005059b          	sext.w	a1,a0
    80002a7e:	08b92023          	sw	a1,128(s2)
    80002a82:	b759                	j	80002a08 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a84:	00092503          	lw	a0,0(s2)
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	e20080e7          	jalr	-480(ra) # 800028a8 <balloc>
    80002a90:	0005099b          	sext.w	s3,a0
    80002a94:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a98:	8552                	mv	a0,s4
    80002a9a:	00001097          	auipc	ra,0x1
    80002a9e:	ef8080e7          	jalr	-264(ra) # 80003992 <log_write>
    80002aa2:	b771                	j	80002a2e <bmap+0x54>
  panic("bmap: out of range");
    80002aa4:	00006517          	auipc	a0,0x6
    80002aa8:	a9450513          	addi	a0,a0,-1388 # 80008538 <syscalls+0x118>
    80002aac:	00003097          	auipc	ra,0x3
    80002ab0:	3ec080e7          	jalr	1004(ra) # 80005e98 <panic>

0000000080002ab4 <iget>:
{
    80002ab4:	7179                	addi	sp,sp,-48
    80002ab6:	f406                	sd	ra,40(sp)
    80002ab8:	f022                	sd	s0,32(sp)
    80002aba:	ec26                	sd	s1,24(sp)
    80002abc:	e84a                	sd	s2,16(sp)
    80002abe:	e44e                	sd	s3,8(sp)
    80002ac0:	e052                	sd	s4,0(sp)
    80002ac2:	1800                	addi	s0,sp,48
    80002ac4:	89aa                	mv	s3,a0
    80002ac6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ac8:	00015517          	auipc	a0,0x15
    80002acc:	ac850513          	addi	a0,a0,-1336 # 80017590 <itable>
    80002ad0:	00004097          	auipc	ra,0x4
    80002ad4:	912080e7          	jalr	-1774(ra) # 800063e2 <acquire>
  empty = 0;
    80002ad8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ada:	00015497          	auipc	s1,0x15
    80002ade:	ace48493          	addi	s1,s1,-1330 # 800175a8 <itable+0x18>
    80002ae2:	00016697          	auipc	a3,0x16
    80002ae6:	55668693          	addi	a3,a3,1366 # 80019038 <log>
    80002aea:	a039                	j	80002af8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aec:	02090b63          	beqz	s2,80002b22 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002af0:	08848493          	addi	s1,s1,136
    80002af4:	02d48a63          	beq	s1,a3,80002b28 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002af8:	449c                	lw	a5,8(s1)
    80002afa:	fef059e3          	blez	a5,80002aec <iget+0x38>
    80002afe:	4098                	lw	a4,0(s1)
    80002b00:	ff3716e3          	bne	a4,s3,80002aec <iget+0x38>
    80002b04:	40d8                	lw	a4,4(s1)
    80002b06:	ff4713e3          	bne	a4,s4,80002aec <iget+0x38>
      ip->ref++;
    80002b0a:	2785                	addiw	a5,a5,1
    80002b0c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b0e:	00015517          	auipc	a0,0x15
    80002b12:	a8250513          	addi	a0,a0,-1406 # 80017590 <itable>
    80002b16:	00004097          	auipc	ra,0x4
    80002b1a:	980080e7          	jalr	-1664(ra) # 80006496 <release>
      return ip;
    80002b1e:	8926                	mv	s2,s1
    80002b20:	a03d                	j	80002b4e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b22:	f7f9                	bnez	a5,80002af0 <iget+0x3c>
    80002b24:	8926                	mv	s2,s1
    80002b26:	b7e9                	j	80002af0 <iget+0x3c>
  if(empty == 0)
    80002b28:	02090c63          	beqz	s2,80002b60 <iget+0xac>
  ip->dev = dev;
    80002b2c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b30:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b34:	4785                	li	a5,1
    80002b36:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b3a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b3e:	00015517          	auipc	a0,0x15
    80002b42:	a5250513          	addi	a0,a0,-1454 # 80017590 <itable>
    80002b46:	00004097          	auipc	ra,0x4
    80002b4a:	950080e7          	jalr	-1712(ra) # 80006496 <release>
}
    80002b4e:	854a                	mv	a0,s2
    80002b50:	70a2                	ld	ra,40(sp)
    80002b52:	7402                	ld	s0,32(sp)
    80002b54:	64e2                	ld	s1,24(sp)
    80002b56:	6942                	ld	s2,16(sp)
    80002b58:	69a2                	ld	s3,8(sp)
    80002b5a:	6a02                	ld	s4,0(sp)
    80002b5c:	6145                	addi	sp,sp,48
    80002b5e:	8082                	ret
    panic("iget: no inodes");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	9f050513          	addi	a0,a0,-1552 # 80008550 <syscalls+0x130>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	330080e7          	jalr	816(ra) # 80005e98 <panic>

0000000080002b70 <fsinit>:
fsinit(int dev) {
    80002b70:	7179                	addi	sp,sp,-48
    80002b72:	f406                	sd	ra,40(sp)
    80002b74:	f022                	sd	s0,32(sp)
    80002b76:	ec26                	sd	s1,24(sp)
    80002b78:	e84a                	sd	s2,16(sp)
    80002b7a:	e44e                	sd	s3,8(sp)
    80002b7c:	1800                	addi	s0,sp,48
    80002b7e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b80:	4585                	li	a1,1
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	a64080e7          	jalr	-1436(ra) # 800025e6 <bread>
    80002b8a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b8c:	00015997          	auipc	s3,0x15
    80002b90:	9e498993          	addi	s3,s3,-1564 # 80017570 <sb>
    80002b94:	02000613          	li	a2,32
    80002b98:	05850593          	addi	a1,a0,88
    80002b9c:	854e                	mv	a0,s3
    80002b9e:	ffffe097          	auipc	ra,0xffffe
    80002ba2:	836080e7          	jalr	-1994(ra) # 800003d4 <memmove>
  brelse(bp);
    80002ba6:	8526                	mv	a0,s1
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	b6e080e7          	jalr	-1170(ra) # 80002716 <brelse>
  if(sb.magic != FSMAGIC)
    80002bb0:	0009a703          	lw	a4,0(s3)
    80002bb4:	102037b7          	lui	a5,0x10203
    80002bb8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bbc:	02f71263          	bne	a4,a5,80002be0 <fsinit+0x70>
  initlog(dev, &sb);
    80002bc0:	00015597          	auipc	a1,0x15
    80002bc4:	9b058593          	addi	a1,a1,-1616 # 80017570 <sb>
    80002bc8:	854a                	mv	a0,s2
    80002bca:	00001097          	auipc	ra,0x1
    80002bce:	b4c080e7          	jalr	-1204(ra) # 80003716 <initlog>
}
    80002bd2:	70a2                	ld	ra,40(sp)
    80002bd4:	7402                	ld	s0,32(sp)
    80002bd6:	64e2                	ld	s1,24(sp)
    80002bd8:	6942                	ld	s2,16(sp)
    80002bda:	69a2                	ld	s3,8(sp)
    80002bdc:	6145                	addi	sp,sp,48
    80002bde:	8082                	ret
    panic("invalid file system");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	98050513          	addi	a0,a0,-1664 # 80008560 <syscalls+0x140>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	2b0080e7          	jalr	688(ra) # 80005e98 <panic>

0000000080002bf0 <iinit>:
{
    80002bf0:	7179                	addi	sp,sp,-48
    80002bf2:	f406                	sd	ra,40(sp)
    80002bf4:	f022                	sd	s0,32(sp)
    80002bf6:	ec26                	sd	s1,24(sp)
    80002bf8:	e84a                	sd	s2,16(sp)
    80002bfa:	e44e                	sd	s3,8(sp)
    80002bfc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bfe:	00006597          	auipc	a1,0x6
    80002c02:	97a58593          	addi	a1,a1,-1670 # 80008578 <syscalls+0x158>
    80002c06:	00015517          	auipc	a0,0x15
    80002c0a:	98a50513          	addi	a0,a0,-1654 # 80017590 <itable>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	744080e7          	jalr	1860(ra) # 80006352 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c16:	00015497          	auipc	s1,0x15
    80002c1a:	9a248493          	addi	s1,s1,-1630 # 800175b8 <itable+0x28>
    80002c1e:	00016997          	auipc	s3,0x16
    80002c22:	42a98993          	addi	s3,s3,1066 # 80019048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c26:	00006917          	auipc	s2,0x6
    80002c2a:	95a90913          	addi	s2,s2,-1702 # 80008580 <syscalls+0x160>
    80002c2e:	85ca                	mv	a1,s2
    80002c30:	8526                	mv	a0,s1
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	e46080e7          	jalr	-442(ra) # 80003a78 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c3a:	08848493          	addi	s1,s1,136
    80002c3e:	ff3498e3          	bne	s1,s3,80002c2e <iinit+0x3e>
}
    80002c42:	70a2                	ld	ra,40(sp)
    80002c44:	7402                	ld	s0,32(sp)
    80002c46:	64e2                	ld	s1,24(sp)
    80002c48:	6942                	ld	s2,16(sp)
    80002c4a:	69a2                	ld	s3,8(sp)
    80002c4c:	6145                	addi	sp,sp,48
    80002c4e:	8082                	ret

0000000080002c50 <ialloc>:
{
    80002c50:	715d                	addi	sp,sp,-80
    80002c52:	e486                	sd	ra,72(sp)
    80002c54:	e0a2                	sd	s0,64(sp)
    80002c56:	fc26                	sd	s1,56(sp)
    80002c58:	f84a                	sd	s2,48(sp)
    80002c5a:	f44e                	sd	s3,40(sp)
    80002c5c:	f052                	sd	s4,32(sp)
    80002c5e:	ec56                	sd	s5,24(sp)
    80002c60:	e85a                	sd	s6,16(sp)
    80002c62:	e45e                	sd	s7,8(sp)
    80002c64:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c66:	00015717          	auipc	a4,0x15
    80002c6a:	91672703          	lw	a4,-1770(a4) # 8001757c <sb+0xc>
    80002c6e:	4785                	li	a5,1
    80002c70:	04e7fa63          	bgeu	a5,a4,80002cc4 <ialloc+0x74>
    80002c74:	8aaa                	mv	s5,a0
    80002c76:	8bae                	mv	s7,a1
    80002c78:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c7a:	00015a17          	auipc	s4,0x15
    80002c7e:	8f6a0a13          	addi	s4,s4,-1802 # 80017570 <sb>
    80002c82:	00048b1b          	sext.w	s6,s1
    80002c86:	0044d593          	srli	a1,s1,0x4
    80002c8a:	018a2783          	lw	a5,24(s4)
    80002c8e:	9dbd                	addw	a1,a1,a5
    80002c90:	8556                	mv	a0,s5
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	954080e7          	jalr	-1708(ra) # 800025e6 <bread>
    80002c9a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c9c:	05850993          	addi	s3,a0,88
    80002ca0:	00f4f793          	andi	a5,s1,15
    80002ca4:	079a                	slli	a5,a5,0x6
    80002ca6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ca8:	00099783          	lh	a5,0(s3)
    80002cac:	c785                	beqz	a5,80002cd4 <ialloc+0x84>
    brelse(bp);
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	a68080e7          	jalr	-1432(ra) # 80002716 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cb6:	0485                	addi	s1,s1,1
    80002cb8:	00ca2703          	lw	a4,12(s4)
    80002cbc:	0004879b          	sext.w	a5,s1
    80002cc0:	fce7e1e3          	bltu	a5,a4,80002c82 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cc4:	00006517          	auipc	a0,0x6
    80002cc8:	8c450513          	addi	a0,a0,-1852 # 80008588 <syscalls+0x168>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	1cc080e7          	jalr	460(ra) # 80005e98 <panic>
      memset(dip, 0, sizeof(*dip));
    80002cd4:	04000613          	li	a2,64
    80002cd8:	4581                	li	a1,0
    80002cda:	854e                	mv	a0,s3
    80002cdc:	ffffd097          	auipc	ra,0xffffd
    80002ce0:	698080e7          	jalr	1688(ra) # 80000374 <memset>
      dip->type = type;
    80002ce4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ce8:	854a                	mv	a0,s2
    80002cea:	00001097          	auipc	ra,0x1
    80002cee:	ca8080e7          	jalr	-856(ra) # 80003992 <log_write>
      brelse(bp);
    80002cf2:	854a                	mv	a0,s2
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	a22080e7          	jalr	-1502(ra) # 80002716 <brelse>
      return iget(dev, inum);
    80002cfc:	85da                	mv	a1,s6
    80002cfe:	8556                	mv	a0,s5
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	db4080e7          	jalr	-588(ra) # 80002ab4 <iget>
}
    80002d08:	60a6                	ld	ra,72(sp)
    80002d0a:	6406                	ld	s0,64(sp)
    80002d0c:	74e2                	ld	s1,56(sp)
    80002d0e:	7942                	ld	s2,48(sp)
    80002d10:	79a2                	ld	s3,40(sp)
    80002d12:	7a02                	ld	s4,32(sp)
    80002d14:	6ae2                	ld	s5,24(sp)
    80002d16:	6b42                	ld	s6,16(sp)
    80002d18:	6ba2                	ld	s7,8(sp)
    80002d1a:	6161                	addi	sp,sp,80
    80002d1c:	8082                	ret

0000000080002d1e <iupdate>:
{
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	e426                	sd	s1,8(sp)
    80002d26:	e04a                	sd	s2,0(sp)
    80002d28:	1000                	addi	s0,sp,32
    80002d2a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d2c:	415c                	lw	a5,4(a0)
    80002d2e:	0047d79b          	srliw	a5,a5,0x4
    80002d32:	00015597          	auipc	a1,0x15
    80002d36:	8565a583          	lw	a1,-1962(a1) # 80017588 <sb+0x18>
    80002d3a:	9dbd                	addw	a1,a1,a5
    80002d3c:	4108                	lw	a0,0(a0)
    80002d3e:	00000097          	auipc	ra,0x0
    80002d42:	8a8080e7          	jalr	-1880(ra) # 800025e6 <bread>
    80002d46:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d48:	05850793          	addi	a5,a0,88
    80002d4c:	40c8                	lw	a0,4(s1)
    80002d4e:	893d                	andi	a0,a0,15
    80002d50:	051a                	slli	a0,a0,0x6
    80002d52:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d54:	04449703          	lh	a4,68(s1)
    80002d58:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d5c:	04649703          	lh	a4,70(s1)
    80002d60:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d64:	04849703          	lh	a4,72(s1)
    80002d68:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d6c:	04a49703          	lh	a4,74(s1)
    80002d70:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d74:	44f8                	lw	a4,76(s1)
    80002d76:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d78:	03400613          	li	a2,52
    80002d7c:	05048593          	addi	a1,s1,80
    80002d80:	0531                	addi	a0,a0,12
    80002d82:	ffffd097          	auipc	ra,0xffffd
    80002d86:	652080e7          	jalr	1618(ra) # 800003d4 <memmove>
  log_write(bp);
    80002d8a:	854a                	mv	a0,s2
    80002d8c:	00001097          	auipc	ra,0x1
    80002d90:	c06080e7          	jalr	-1018(ra) # 80003992 <log_write>
  brelse(bp);
    80002d94:	854a                	mv	a0,s2
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	980080e7          	jalr	-1664(ra) # 80002716 <brelse>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret

0000000080002daa <idup>:
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	e426                	sd	s1,8(sp)
    80002db2:	1000                	addi	s0,sp,32
    80002db4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db6:	00014517          	auipc	a0,0x14
    80002dba:	7da50513          	addi	a0,a0,2010 # 80017590 <itable>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	624080e7          	jalr	1572(ra) # 800063e2 <acquire>
  ip->ref++;
    80002dc6:	449c                	lw	a5,8(s1)
    80002dc8:	2785                	addiw	a5,a5,1
    80002dca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dcc:	00014517          	auipc	a0,0x14
    80002dd0:	7c450513          	addi	a0,a0,1988 # 80017590 <itable>
    80002dd4:	00003097          	auipc	ra,0x3
    80002dd8:	6c2080e7          	jalr	1730(ra) # 80006496 <release>
}
    80002ddc:	8526                	mv	a0,s1
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	64a2                	ld	s1,8(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret

0000000080002de8 <ilock>:
{
    80002de8:	1101                	addi	sp,sp,-32
    80002dea:	ec06                	sd	ra,24(sp)
    80002dec:	e822                	sd	s0,16(sp)
    80002dee:	e426                	sd	s1,8(sp)
    80002df0:	e04a                	sd	s2,0(sp)
    80002df2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002df4:	c115                	beqz	a0,80002e18 <ilock+0x30>
    80002df6:	84aa                	mv	s1,a0
    80002df8:	451c                	lw	a5,8(a0)
    80002dfa:	00f05f63          	blez	a5,80002e18 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002dfe:	0541                	addi	a0,a0,16
    80002e00:	00001097          	auipc	ra,0x1
    80002e04:	cb2080e7          	jalr	-846(ra) # 80003ab2 <acquiresleep>
  if(ip->valid == 0){
    80002e08:	40bc                	lw	a5,64(s1)
    80002e0a:	cf99                	beqz	a5,80002e28 <ilock+0x40>
}
    80002e0c:	60e2                	ld	ra,24(sp)
    80002e0e:	6442                	ld	s0,16(sp)
    80002e10:	64a2                	ld	s1,8(sp)
    80002e12:	6902                	ld	s2,0(sp)
    80002e14:	6105                	addi	sp,sp,32
    80002e16:	8082                	ret
    panic("ilock");
    80002e18:	00005517          	auipc	a0,0x5
    80002e1c:	78850513          	addi	a0,a0,1928 # 800085a0 <syscalls+0x180>
    80002e20:	00003097          	auipc	ra,0x3
    80002e24:	078080e7          	jalr	120(ra) # 80005e98 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e28:	40dc                	lw	a5,4(s1)
    80002e2a:	0047d79b          	srliw	a5,a5,0x4
    80002e2e:	00014597          	auipc	a1,0x14
    80002e32:	75a5a583          	lw	a1,1882(a1) # 80017588 <sb+0x18>
    80002e36:	9dbd                	addw	a1,a1,a5
    80002e38:	4088                	lw	a0,0(s1)
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	7ac080e7          	jalr	1964(ra) # 800025e6 <bread>
    80002e42:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e44:	05850593          	addi	a1,a0,88
    80002e48:	40dc                	lw	a5,4(s1)
    80002e4a:	8bbd                	andi	a5,a5,15
    80002e4c:	079a                	slli	a5,a5,0x6
    80002e4e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e50:	00059783          	lh	a5,0(a1)
    80002e54:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e58:	00259783          	lh	a5,2(a1)
    80002e5c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e60:	00459783          	lh	a5,4(a1)
    80002e64:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e68:	00659783          	lh	a5,6(a1)
    80002e6c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e70:	459c                	lw	a5,8(a1)
    80002e72:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e74:	03400613          	li	a2,52
    80002e78:	05b1                	addi	a1,a1,12
    80002e7a:	05048513          	addi	a0,s1,80
    80002e7e:	ffffd097          	auipc	ra,0xffffd
    80002e82:	556080e7          	jalr	1366(ra) # 800003d4 <memmove>
    brelse(bp);
    80002e86:	854a                	mv	a0,s2
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	88e080e7          	jalr	-1906(ra) # 80002716 <brelse>
    ip->valid = 1;
    80002e90:	4785                	li	a5,1
    80002e92:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e94:	04449783          	lh	a5,68(s1)
    80002e98:	fbb5                	bnez	a5,80002e0c <ilock+0x24>
      panic("ilock: no type");
    80002e9a:	00005517          	auipc	a0,0x5
    80002e9e:	70e50513          	addi	a0,a0,1806 # 800085a8 <syscalls+0x188>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	ff6080e7          	jalr	-10(ra) # 80005e98 <panic>

0000000080002eaa <iunlock>:
{
    80002eaa:	1101                	addi	sp,sp,-32
    80002eac:	ec06                	sd	ra,24(sp)
    80002eae:	e822                	sd	s0,16(sp)
    80002eb0:	e426                	sd	s1,8(sp)
    80002eb2:	e04a                	sd	s2,0(sp)
    80002eb4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002eb6:	c905                	beqz	a0,80002ee6 <iunlock+0x3c>
    80002eb8:	84aa                	mv	s1,a0
    80002eba:	01050913          	addi	s2,a0,16
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	00001097          	auipc	ra,0x1
    80002ec4:	c8c080e7          	jalr	-884(ra) # 80003b4c <holdingsleep>
    80002ec8:	cd19                	beqz	a0,80002ee6 <iunlock+0x3c>
    80002eca:	449c                	lw	a5,8(s1)
    80002ecc:	00f05d63          	blez	a5,80002ee6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	00001097          	auipc	ra,0x1
    80002ed6:	c36080e7          	jalr	-970(ra) # 80003b08 <releasesleep>
}
    80002eda:	60e2                	ld	ra,24(sp)
    80002edc:	6442                	ld	s0,16(sp)
    80002ede:	64a2                	ld	s1,8(sp)
    80002ee0:	6902                	ld	s2,0(sp)
    80002ee2:	6105                	addi	sp,sp,32
    80002ee4:	8082                	ret
    panic("iunlock");
    80002ee6:	00005517          	auipc	a0,0x5
    80002eea:	6d250513          	addi	a0,a0,1746 # 800085b8 <syscalls+0x198>
    80002eee:	00003097          	auipc	ra,0x3
    80002ef2:	faa080e7          	jalr	-86(ra) # 80005e98 <panic>

0000000080002ef6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ef6:	7179                	addi	sp,sp,-48
    80002ef8:	f406                	sd	ra,40(sp)
    80002efa:	f022                	sd	s0,32(sp)
    80002efc:	ec26                	sd	s1,24(sp)
    80002efe:	e84a                	sd	s2,16(sp)
    80002f00:	e44e                	sd	s3,8(sp)
    80002f02:	e052                	sd	s4,0(sp)
    80002f04:	1800                	addi	s0,sp,48
    80002f06:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f08:	05050493          	addi	s1,a0,80
    80002f0c:	08050913          	addi	s2,a0,128
    80002f10:	a021                	j	80002f18 <itrunc+0x22>
    80002f12:	0491                	addi	s1,s1,4
    80002f14:	01248d63          	beq	s1,s2,80002f2e <itrunc+0x38>
    if(ip->addrs[i]){
    80002f18:	408c                	lw	a1,0(s1)
    80002f1a:	dde5                	beqz	a1,80002f12 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f1c:	0009a503          	lw	a0,0(s3)
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	90c080e7          	jalr	-1780(ra) # 8000282c <bfree>
      ip->addrs[i] = 0;
    80002f28:	0004a023          	sw	zero,0(s1)
    80002f2c:	b7dd                	j	80002f12 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f2e:	0809a583          	lw	a1,128(s3)
    80002f32:	e185                	bnez	a1,80002f52 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f34:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f38:	854e                	mv	a0,s3
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	de4080e7          	jalr	-540(ra) # 80002d1e <iupdate>
}
    80002f42:	70a2                	ld	ra,40(sp)
    80002f44:	7402                	ld	s0,32(sp)
    80002f46:	64e2                	ld	s1,24(sp)
    80002f48:	6942                	ld	s2,16(sp)
    80002f4a:	69a2                	ld	s3,8(sp)
    80002f4c:	6a02                	ld	s4,0(sp)
    80002f4e:	6145                	addi	sp,sp,48
    80002f50:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f52:	0009a503          	lw	a0,0(s3)
    80002f56:	fffff097          	auipc	ra,0xfffff
    80002f5a:	690080e7          	jalr	1680(ra) # 800025e6 <bread>
    80002f5e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f60:	05850493          	addi	s1,a0,88
    80002f64:	45850913          	addi	s2,a0,1112
    80002f68:	a811                	j	80002f7c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f6a:	0009a503          	lw	a0,0(s3)
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	8be080e7          	jalr	-1858(ra) # 8000282c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f76:	0491                	addi	s1,s1,4
    80002f78:	01248563          	beq	s1,s2,80002f82 <itrunc+0x8c>
      if(a[j])
    80002f7c:	408c                	lw	a1,0(s1)
    80002f7e:	dde5                	beqz	a1,80002f76 <itrunc+0x80>
    80002f80:	b7ed                	j	80002f6a <itrunc+0x74>
    brelse(bp);
    80002f82:	8552                	mv	a0,s4
    80002f84:	fffff097          	auipc	ra,0xfffff
    80002f88:	792080e7          	jalr	1938(ra) # 80002716 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f8c:	0809a583          	lw	a1,128(s3)
    80002f90:	0009a503          	lw	a0,0(s3)
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	898080e7          	jalr	-1896(ra) # 8000282c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f9c:	0809a023          	sw	zero,128(s3)
    80002fa0:	bf51                	j	80002f34 <itrunc+0x3e>

0000000080002fa2 <iput>:
{
    80002fa2:	1101                	addi	sp,sp,-32
    80002fa4:	ec06                	sd	ra,24(sp)
    80002fa6:	e822                	sd	s0,16(sp)
    80002fa8:	e426                	sd	s1,8(sp)
    80002faa:	e04a                	sd	s2,0(sp)
    80002fac:	1000                	addi	s0,sp,32
    80002fae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fb0:	00014517          	auipc	a0,0x14
    80002fb4:	5e050513          	addi	a0,a0,1504 # 80017590 <itable>
    80002fb8:	00003097          	auipc	ra,0x3
    80002fbc:	42a080e7          	jalr	1066(ra) # 800063e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fc0:	4498                	lw	a4,8(s1)
    80002fc2:	4785                	li	a5,1
    80002fc4:	02f70363          	beq	a4,a5,80002fea <iput+0x48>
  ip->ref--;
    80002fc8:	449c                	lw	a5,8(s1)
    80002fca:	37fd                	addiw	a5,a5,-1
    80002fcc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fce:	00014517          	auipc	a0,0x14
    80002fd2:	5c250513          	addi	a0,a0,1474 # 80017590 <itable>
    80002fd6:	00003097          	auipc	ra,0x3
    80002fda:	4c0080e7          	jalr	1216(ra) # 80006496 <release>
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6902                	ld	s2,0(sp)
    80002fe6:	6105                	addi	sp,sp,32
    80002fe8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fea:	40bc                	lw	a5,64(s1)
    80002fec:	dff1                	beqz	a5,80002fc8 <iput+0x26>
    80002fee:	04a49783          	lh	a5,74(s1)
    80002ff2:	fbf9                	bnez	a5,80002fc8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ff4:	01048913          	addi	s2,s1,16
    80002ff8:	854a                	mv	a0,s2
    80002ffa:	00001097          	auipc	ra,0x1
    80002ffe:	ab8080e7          	jalr	-1352(ra) # 80003ab2 <acquiresleep>
    release(&itable.lock);
    80003002:	00014517          	auipc	a0,0x14
    80003006:	58e50513          	addi	a0,a0,1422 # 80017590 <itable>
    8000300a:	00003097          	auipc	ra,0x3
    8000300e:	48c080e7          	jalr	1164(ra) # 80006496 <release>
    itrunc(ip);
    80003012:	8526                	mv	a0,s1
    80003014:	00000097          	auipc	ra,0x0
    80003018:	ee2080e7          	jalr	-286(ra) # 80002ef6 <itrunc>
    ip->type = 0;
    8000301c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003020:	8526                	mv	a0,s1
    80003022:	00000097          	auipc	ra,0x0
    80003026:	cfc080e7          	jalr	-772(ra) # 80002d1e <iupdate>
    ip->valid = 0;
    8000302a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000302e:	854a                	mv	a0,s2
    80003030:	00001097          	auipc	ra,0x1
    80003034:	ad8080e7          	jalr	-1320(ra) # 80003b08 <releasesleep>
    acquire(&itable.lock);
    80003038:	00014517          	auipc	a0,0x14
    8000303c:	55850513          	addi	a0,a0,1368 # 80017590 <itable>
    80003040:	00003097          	auipc	ra,0x3
    80003044:	3a2080e7          	jalr	930(ra) # 800063e2 <acquire>
    80003048:	b741                	j	80002fc8 <iput+0x26>

000000008000304a <iunlockput>:
{
    8000304a:	1101                	addi	sp,sp,-32
    8000304c:	ec06                	sd	ra,24(sp)
    8000304e:	e822                	sd	s0,16(sp)
    80003050:	e426                	sd	s1,8(sp)
    80003052:	1000                	addi	s0,sp,32
    80003054:	84aa                	mv	s1,a0
  iunlock(ip);
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	e54080e7          	jalr	-428(ra) # 80002eaa <iunlock>
  iput(ip);
    8000305e:	8526                	mv	a0,s1
    80003060:	00000097          	auipc	ra,0x0
    80003064:	f42080e7          	jalr	-190(ra) # 80002fa2 <iput>
}
    80003068:	60e2                	ld	ra,24(sp)
    8000306a:	6442                	ld	s0,16(sp)
    8000306c:	64a2                	ld	s1,8(sp)
    8000306e:	6105                	addi	sp,sp,32
    80003070:	8082                	ret

0000000080003072 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003072:	1141                	addi	sp,sp,-16
    80003074:	e422                	sd	s0,8(sp)
    80003076:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003078:	411c                	lw	a5,0(a0)
    8000307a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000307c:	415c                	lw	a5,4(a0)
    8000307e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003080:	04451783          	lh	a5,68(a0)
    80003084:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003088:	04a51783          	lh	a5,74(a0)
    8000308c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003090:	04c56783          	lwu	a5,76(a0)
    80003094:	e99c                	sd	a5,16(a1)
}
    80003096:	6422                	ld	s0,8(sp)
    80003098:	0141                	addi	sp,sp,16
    8000309a:	8082                	ret

000000008000309c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000309c:	457c                	lw	a5,76(a0)
    8000309e:	0ed7e963          	bltu	a5,a3,80003190 <readi+0xf4>
{
    800030a2:	7159                	addi	sp,sp,-112
    800030a4:	f486                	sd	ra,104(sp)
    800030a6:	f0a2                	sd	s0,96(sp)
    800030a8:	eca6                	sd	s1,88(sp)
    800030aa:	e8ca                	sd	s2,80(sp)
    800030ac:	e4ce                	sd	s3,72(sp)
    800030ae:	e0d2                	sd	s4,64(sp)
    800030b0:	fc56                	sd	s5,56(sp)
    800030b2:	f85a                	sd	s6,48(sp)
    800030b4:	f45e                	sd	s7,40(sp)
    800030b6:	f062                	sd	s8,32(sp)
    800030b8:	ec66                	sd	s9,24(sp)
    800030ba:	e86a                	sd	s10,16(sp)
    800030bc:	e46e                	sd	s11,8(sp)
    800030be:	1880                	addi	s0,sp,112
    800030c0:	8baa                	mv	s7,a0
    800030c2:	8c2e                	mv	s8,a1
    800030c4:	8ab2                	mv	s5,a2
    800030c6:	84b6                	mv	s1,a3
    800030c8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030ca:	9f35                	addw	a4,a4,a3
    return 0;
    800030cc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030ce:	0ad76063          	bltu	a4,a3,8000316e <readi+0xd2>
  if(off + n > ip->size)
    800030d2:	00e7f463          	bgeu	a5,a4,800030da <readi+0x3e>
    n = ip->size - off;
    800030d6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030da:	0a0b0963          	beqz	s6,8000318c <readi+0xf0>
    800030de:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030e4:	5cfd                	li	s9,-1
    800030e6:	a82d                	j	80003120 <readi+0x84>
    800030e8:	020a1d93          	slli	s11,s4,0x20
    800030ec:	020ddd93          	srli	s11,s11,0x20
    800030f0:	05890613          	addi	a2,s2,88
    800030f4:	86ee                	mv	a3,s11
    800030f6:	963a                	add	a2,a2,a4
    800030f8:	85d6                	mv	a1,s5
    800030fa:	8562                	mv	a0,s8
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	aaa080e7          	jalr	-1366(ra) # 80001ba6 <either_copyout>
    80003104:	05950d63          	beq	a0,s9,8000315e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003108:	854a                	mv	a0,s2
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	60c080e7          	jalr	1548(ra) # 80002716 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003112:	013a09bb          	addw	s3,s4,s3
    80003116:	009a04bb          	addw	s1,s4,s1
    8000311a:	9aee                	add	s5,s5,s11
    8000311c:	0569f763          	bgeu	s3,s6,8000316a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003120:	000ba903          	lw	s2,0(s7)
    80003124:	00a4d59b          	srliw	a1,s1,0xa
    80003128:	855e                	mv	a0,s7
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	8b0080e7          	jalr	-1872(ra) # 800029da <bmap>
    80003132:	0005059b          	sext.w	a1,a0
    80003136:	854a                	mv	a0,s2
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	4ae080e7          	jalr	1198(ra) # 800025e6 <bread>
    80003140:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003142:	3ff4f713          	andi	a4,s1,1023
    80003146:	40ed07bb          	subw	a5,s10,a4
    8000314a:	413b06bb          	subw	a3,s6,s3
    8000314e:	8a3e                	mv	s4,a5
    80003150:	2781                	sext.w	a5,a5
    80003152:	0006861b          	sext.w	a2,a3
    80003156:	f8f679e3          	bgeu	a2,a5,800030e8 <readi+0x4c>
    8000315a:	8a36                	mv	s4,a3
    8000315c:	b771                	j	800030e8 <readi+0x4c>
      brelse(bp);
    8000315e:	854a                	mv	a0,s2
    80003160:	fffff097          	auipc	ra,0xfffff
    80003164:	5b6080e7          	jalr	1462(ra) # 80002716 <brelse>
      tot = -1;
    80003168:	59fd                	li	s3,-1
  }
  return tot;
    8000316a:	0009851b          	sext.w	a0,s3
}
    8000316e:	70a6                	ld	ra,104(sp)
    80003170:	7406                	ld	s0,96(sp)
    80003172:	64e6                	ld	s1,88(sp)
    80003174:	6946                	ld	s2,80(sp)
    80003176:	69a6                	ld	s3,72(sp)
    80003178:	6a06                	ld	s4,64(sp)
    8000317a:	7ae2                	ld	s5,56(sp)
    8000317c:	7b42                	ld	s6,48(sp)
    8000317e:	7ba2                	ld	s7,40(sp)
    80003180:	7c02                	ld	s8,32(sp)
    80003182:	6ce2                	ld	s9,24(sp)
    80003184:	6d42                	ld	s10,16(sp)
    80003186:	6da2                	ld	s11,8(sp)
    80003188:	6165                	addi	sp,sp,112
    8000318a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000318c:	89da                	mv	s3,s6
    8000318e:	bff1                	j	8000316a <readi+0xce>
    return 0;
    80003190:	4501                	li	a0,0
}
    80003192:	8082                	ret

0000000080003194 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003194:	457c                	lw	a5,76(a0)
    80003196:	10d7e863          	bltu	a5,a3,800032a6 <writei+0x112>
{
    8000319a:	7159                	addi	sp,sp,-112
    8000319c:	f486                	sd	ra,104(sp)
    8000319e:	f0a2                	sd	s0,96(sp)
    800031a0:	eca6                	sd	s1,88(sp)
    800031a2:	e8ca                	sd	s2,80(sp)
    800031a4:	e4ce                	sd	s3,72(sp)
    800031a6:	e0d2                	sd	s4,64(sp)
    800031a8:	fc56                	sd	s5,56(sp)
    800031aa:	f85a                	sd	s6,48(sp)
    800031ac:	f45e                	sd	s7,40(sp)
    800031ae:	f062                	sd	s8,32(sp)
    800031b0:	ec66                	sd	s9,24(sp)
    800031b2:	e86a                	sd	s10,16(sp)
    800031b4:	e46e                	sd	s11,8(sp)
    800031b6:	1880                	addi	s0,sp,112
    800031b8:	8b2a                	mv	s6,a0
    800031ba:	8c2e                	mv	s8,a1
    800031bc:	8ab2                	mv	s5,a2
    800031be:	8936                	mv	s2,a3
    800031c0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031c2:	00e687bb          	addw	a5,a3,a4
    800031c6:	0ed7e263          	bltu	a5,a3,800032aa <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031ca:	00043737          	lui	a4,0x43
    800031ce:	0ef76063          	bltu	a4,a5,800032ae <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d2:	0c0b8863          	beqz	s7,800032a2 <writei+0x10e>
    800031d6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031dc:	5cfd                	li	s9,-1
    800031de:	a091                	j	80003222 <writei+0x8e>
    800031e0:	02099d93          	slli	s11,s3,0x20
    800031e4:	020ddd93          	srli	s11,s11,0x20
    800031e8:	05848513          	addi	a0,s1,88
    800031ec:	86ee                	mv	a3,s11
    800031ee:	8656                	mv	a2,s5
    800031f0:	85e2                	mv	a1,s8
    800031f2:	953a                	add	a0,a0,a4
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	a08080e7          	jalr	-1528(ra) # 80001bfc <either_copyin>
    800031fc:	07950263          	beq	a0,s9,80003260 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003200:	8526                	mv	a0,s1
    80003202:	00000097          	auipc	ra,0x0
    80003206:	790080e7          	jalr	1936(ra) # 80003992 <log_write>
    brelse(bp);
    8000320a:	8526                	mv	a0,s1
    8000320c:	fffff097          	auipc	ra,0xfffff
    80003210:	50a080e7          	jalr	1290(ra) # 80002716 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003214:	01498a3b          	addw	s4,s3,s4
    80003218:	0129893b          	addw	s2,s3,s2
    8000321c:	9aee                	add	s5,s5,s11
    8000321e:	057a7663          	bgeu	s4,s7,8000326a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003222:	000b2483          	lw	s1,0(s6)
    80003226:	00a9559b          	srliw	a1,s2,0xa
    8000322a:	855a                	mv	a0,s6
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	7ae080e7          	jalr	1966(ra) # 800029da <bmap>
    80003234:	0005059b          	sext.w	a1,a0
    80003238:	8526                	mv	a0,s1
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	3ac080e7          	jalr	940(ra) # 800025e6 <bread>
    80003242:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003244:	3ff97713          	andi	a4,s2,1023
    80003248:	40ed07bb          	subw	a5,s10,a4
    8000324c:	414b86bb          	subw	a3,s7,s4
    80003250:	89be                	mv	s3,a5
    80003252:	2781                	sext.w	a5,a5
    80003254:	0006861b          	sext.w	a2,a3
    80003258:	f8f674e3          	bgeu	a2,a5,800031e0 <writei+0x4c>
    8000325c:	89b6                	mv	s3,a3
    8000325e:	b749                	j	800031e0 <writei+0x4c>
      brelse(bp);
    80003260:	8526                	mv	a0,s1
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	4b4080e7          	jalr	1204(ra) # 80002716 <brelse>
  }

  if(off > ip->size)
    8000326a:	04cb2783          	lw	a5,76(s6)
    8000326e:	0127f463          	bgeu	a5,s2,80003276 <writei+0xe2>
    ip->size = off;
    80003272:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003276:	855a                	mv	a0,s6
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	aa6080e7          	jalr	-1370(ra) # 80002d1e <iupdate>

  return tot;
    80003280:	000a051b          	sext.w	a0,s4
}
    80003284:	70a6                	ld	ra,104(sp)
    80003286:	7406                	ld	s0,96(sp)
    80003288:	64e6                	ld	s1,88(sp)
    8000328a:	6946                	ld	s2,80(sp)
    8000328c:	69a6                	ld	s3,72(sp)
    8000328e:	6a06                	ld	s4,64(sp)
    80003290:	7ae2                	ld	s5,56(sp)
    80003292:	7b42                	ld	s6,48(sp)
    80003294:	7ba2                	ld	s7,40(sp)
    80003296:	7c02                	ld	s8,32(sp)
    80003298:	6ce2                	ld	s9,24(sp)
    8000329a:	6d42                	ld	s10,16(sp)
    8000329c:	6da2                	ld	s11,8(sp)
    8000329e:	6165                	addi	sp,sp,112
    800032a0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032a2:	8a5e                	mv	s4,s7
    800032a4:	bfc9                	j	80003276 <writei+0xe2>
    return -1;
    800032a6:	557d                	li	a0,-1
}
    800032a8:	8082                	ret
    return -1;
    800032aa:	557d                	li	a0,-1
    800032ac:	bfe1                	j	80003284 <writei+0xf0>
    return -1;
    800032ae:	557d                	li	a0,-1
    800032b0:	bfd1                	j	80003284 <writei+0xf0>

00000000800032b2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032b2:	1141                	addi	sp,sp,-16
    800032b4:	e406                	sd	ra,8(sp)
    800032b6:	e022                	sd	s0,0(sp)
    800032b8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032ba:	4639                	li	a2,14
    800032bc:	ffffd097          	auipc	ra,0xffffd
    800032c0:	190080e7          	jalr	400(ra) # 8000044c <strncmp>
}
    800032c4:	60a2                	ld	ra,8(sp)
    800032c6:	6402                	ld	s0,0(sp)
    800032c8:	0141                	addi	sp,sp,16
    800032ca:	8082                	ret

00000000800032cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032cc:	7139                	addi	sp,sp,-64
    800032ce:	fc06                	sd	ra,56(sp)
    800032d0:	f822                	sd	s0,48(sp)
    800032d2:	f426                	sd	s1,40(sp)
    800032d4:	f04a                	sd	s2,32(sp)
    800032d6:	ec4e                	sd	s3,24(sp)
    800032d8:	e852                	sd	s4,16(sp)
    800032da:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032dc:	04451703          	lh	a4,68(a0)
    800032e0:	4785                	li	a5,1
    800032e2:	00f71a63          	bne	a4,a5,800032f6 <dirlookup+0x2a>
    800032e6:	892a                	mv	s2,a0
    800032e8:	89ae                	mv	s3,a1
    800032ea:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ec:	457c                	lw	a5,76(a0)
    800032ee:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032f0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f2:	e79d                	bnez	a5,80003320 <dirlookup+0x54>
    800032f4:	a8a5                	j	8000336c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032f6:	00005517          	auipc	a0,0x5
    800032fa:	2ca50513          	addi	a0,a0,714 # 800085c0 <syscalls+0x1a0>
    800032fe:	00003097          	auipc	ra,0x3
    80003302:	b9a080e7          	jalr	-1126(ra) # 80005e98 <panic>
      panic("dirlookup read");
    80003306:	00005517          	auipc	a0,0x5
    8000330a:	2d250513          	addi	a0,a0,722 # 800085d8 <syscalls+0x1b8>
    8000330e:	00003097          	auipc	ra,0x3
    80003312:	b8a080e7          	jalr	-1142(ra) # 80005e98 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003316:	24c1                	addiw	s1,s1,16
    80003318:	04c92783          	lw	a5,76(s2)
    8000331c:	04f4f763          	bgeu	s1,a5,8000336a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003320:	4741                	li	a4,16
    80003322:	86a6                	mv	a3,s1
    80003324:	fc040613          	addi	a2,s0,-64
    80003328:	4581                	li	a1,0
    8000332a:	854a                	mv	a0,s2
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	d70080e7          	jalr	-656(ra) # 8000309c <readi>
    80003334:	47c1                	li	a5,16
    80003336:	fcf518e3          	bne	a0,a5,80003306 <dirlookup+0x3a>
    if(de.inum == 0)
    8000333a:	fc045783          	lhu	a5,-64(s0)
    8000333e:	dfe1                	beqz	a5,80003316 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003340:	fc240593          	addi	a1,s0,-62
    80003344:	854e                	mv	a0,s3
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	f6c080e7          	jalr	-148(ra) # 800032b2 <namecmp>
    8000334e:	f561                	bnez	a0,80003316 <dirlookup+0x4a>
      if(poff)
    80003350:	000a0463          	beqz	s4,80003358 <dirlookup+0x8c>
        *poff = off;
    80003354:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003358:	fc045583          	lhu	a1,-64(s0)
    8000335c:	00092503          	lw	a0,0(s2)
    80003360:	fffff097          	auipc	ra,0xfffff
    80003364:	754080e7          	jalr	1876(ra) # 80002ab4 <iget>
    80003368:	a011                	j	8000336c <dirlookup+0xa0>
  return 0;
    8000336a:	4501                	li	a0,0
}
    8000336c:	70e2                	ld	ra,56(sp)
    8000336e:	7442                	ld	s0,48(sp)
    80003370:	74a2                	ld	s1,40(sp)
    80003372:	7902                	ld	s2,32(sp)
    80003374:	69e2                	ld	s3,24(sp)
    80003376:	6a42                	ld	s4,16(sp)
    80003378:	6121                	addi	sp,sp,64
    8000337a:	8082                	ret

000000008000337c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000337c:	711d                	addi	sp,sp,-96
    8000337e:	ec86                	sd	ra,88(sp)
    80003380:	e8a2                	sd	s0,80(sp)
    80003382:	e4a6                	sd	s1,72(sp)
    80003384:	e0ca                	sd	s2,64(sp)
    80003386:	fc4e                	sd	s3,56(sp)
    80003388:	f852                	sd	s4,48(sp)
    8000338a:	f456                	sd	s5,40(sp)
    8000338c:	f05a                	sd	s6,32(sp)
    8000338e:	ec5e                	sd	s7,24(sp)
    80003390:	e862                	sd	s8,16(sp)
    80003392:	e466                	sd	s9,8(sp)
    80003394:	1080                	addi	s0,sp,96
    80003396:	84aa                	mv	s1,a0
    80003398:	8b2e                	mv	s6,a1
    8000339a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000339c:	00054703          	lbu	a4,0(a0)
    800033a0:	02f00793          	li	a5,47
    800033a4:	02f70363          	beq	a4,a5,800033ca <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	d9e080e7          	jalr	-610(ra) # 80001146 <myproc>
    800033b0:	15053503          	ld	a0,336(a0)
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	9f6080e7          	jalr	-1546(ra) # 80002daa <idup>
    800033bc:	89aa                	mv	s3,a0
  while(*path == '/')
    800033be:	02f00913          	li	s2,47
  len = path - s;
    800033c2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033c4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033c6:	4c05                	li	s8,1
    800033c8:	a865                	j	80003480 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033ca:	4585                	li	a1,1
    800033cc:	4505                	li	a0,1
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	6e6080e7          	jalr	1766(ra) # 80002ab4 <iget>
    800033d6:	89aa                	mv	s3,a0
    800033d8:	b7dd                	j	800033be <namex+0x42>
      iunlockput(ip);
    800033da:	854e                	mv	a0,s3
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	c6e080e7          	jalr	-914(ra) # 8000304a <iunlockput>
      return 0;
    800033e4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033e6:	854e                	mv	a0,s3
    800033e8:	60e6                	ld	ra,88(sp)
    800033ea:	6446                	ld	s0,80(sp)
    800033ec:	64a6                	ld	s1,72(sp)
    800033ee:	6906                	ld	s2,64(sp)
    800033f0:	79e2                	ld	s3,56(sp)
    800033f2:	7a42                	ld	s4,48(sp)
    800033f4:	7aa2                	ld	s5,40(sp)
    800033f6:	7b02                	ld	s6,32(sp)
    800033f8:	6be2                	ld	s7,24(sp)
    800033fa:	6c42                	ld	s8,16(sp)
    800033fc:	6ca2                	ld	s9,8(sp)
    800033fe:	6125                	addi	sp,sp,96
    80003400:	8082                	ret
      iunlock(ip);
    80003402:	854e                	mv	a0,s3
    80003404:	00000097          	auipc	ra,0x0
    80003408:	aa6080e7          	jalr	-1370(ra) # 80002eaa <iunlock>
      return ip;
    8000340c:	bfe9                	j	800033e6 <namex+0x6a>
      iunlockput(ip);
    8000340e:	854e                	mv	a0,s3
    80003410:	00000097          	auipc	ra,0x0
    80003414:	c3a080e7          	jalr	-966(ra) # 8000304a <iunlockput>
      return 0;
    80003418:	89d2                	mv	s3,s4
    8000341a:	b7f1                	j	800033e6 <namex+0x6a>
  len = path - s;
    8000341c:	40b48633          	sub	a2,s1,a1
    80003420:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003424:	094cd463          	bge	s9,s4,800034ac <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003428:	4639                	li	a2,14
    8000342a:	8556                	mv	a0,s5
    8000342c:	ffffd097          	auipc	ra,0xffffd
    80003430:	fa8080e7          	jalr	-88(ra) # 800003d4 <memmove>
  while(*path == '/')
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	01279763          	bne	a5,s2,80003446 <namex+0xca>
    path++;
    8000343c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000343e:	0004c783          	lbu	a5,0(s1)
    80003442:	ff278de3          	beq	a5,s2,8000343c <namex+0xc0>
    ilock(ip);
    80003446:	854e                	mv	a0,s3
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	9a0080e7          	jalr	-1632(ra) # 80002de8 <ilock>
    if(ip->type != T_DIR){
    80003450:	04499783          	lh	a5,68(s3)
    80003454:	f98793e3          	bne	a5,s8,800033da <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003458:	000b0563          	beqz	s6,80003462 <namex+0xe6>
    8000345c:	0004c783          	lbu	a5,0(s1)
    80003460:	d3cd                	beqz	a5,80003402 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003462:	865e                	mv	a2,s7
    80003464:	85d6                	mv	a1,s5
    80003466:	854e                	mv	a0,s3
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	e64080e7          	jalr	-412(ra) # 800032cc <dirlookup>
    80003470:	8a2a                	mv	s4,a0
    80003472:	dd51                	beqz	a0,8000340e <namex+0x92>
    iunlockput(ip);
    80003474:	854e                	mv	a0,s3
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	bd4080e7          	jalr	-1068(ra) # 8000304a <iunlockput>
    ip = next;
    8000347e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003480:	0004c783          	lbu	a5,0(s1)
    80003484:	05279763          	bne	a5,s2,800034d2 <namex+0x156>
    path++;
    80003488:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000348a:	0004c783          	lbu	a5,0(s1)
    8000348e:	ff278de3          	beq	a5,s2,80003488 <namex+0x10c>
  if(*path == 0)
    80003492:	c79d                	beqz	a5,800034c0 <namex+0x144>
    path++;
    80003494:	85a6                	mv	a1,s1
  len = path - s;
    80003496:	8a5e                	mv	s4,s7
    80003498:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000349a:	01278963          	beq	a5,s2,800034ac <namex+0x130>
    8000349e:	dfbd                	beqz	a5,8000341c <namex+0xa0>
    path++;
    800034a0:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800034a2:	0004c783          	lbu	a5,0(s1)
    800034a6:	ff279ce3          	bne	a5,s2,8000349e <namex+0x122>
    800034aa:	bf8d                	j	8000341c <namex+0xa0>
    memmove(name, s, len);
    800034ac:	2601                	sext.w	a2,a2
    800034ae:	8556                	mv	a0,s5
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	f24080e7          	jalr	-220(ra) # 800003d4 <memmove>
    name[len] = 0;
    800034b8:	9a56                	add	s4,s4,s5
    800034ba:	000a0023          	sb	zero,0(s4)
    800034be:	bf9d                	j	80003434 <namex+0xb8>
  if(nameiparent){
    800034c0:	f20b03e3          	beqz	s6,800033e6 <namex+0x6a>
    iput(ip);
    800034c4:	854e                	mv	a0,s3
    800034c6:	00000097          	auipc	ra,0x0
    800034ca:	adc080e7          	jalr	-1316(ra) # 80002fa2 <iput>
    return 0;
    800034ce:	4981                	li	s3,0
    800034d0:	bf19                	j	800033e6 <namex+0x6a>
  if(*path == 0)
    800034d2:	d7fd                	beqz	a5,800034c0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800034d4:	0004c783          	lbu	a5,0(s1)
    800034d8:	85a6                	mv	a1,s1
    800034da:	b7d1                	j	8000349e <namex+0x122>

00000000800034dc <dirlink>:
{
    800034dc:	7139                	addi	sp,sp,-64
    800034de:	fc06                	sd	ra,56(sp)
    800034e0:	f822                	sd	s0,48(sp)
    800034e2:	f426                	sd	s1,40(sp)
    800034e4:	f04a                	sd	s2,32(sp)
    800034e6:	ec4e                	sd	s3,24(sp)
    800034e8:	e852                	sd	s4,16(sp)
    800034ea:	0080                	addi	s0,sp,64
    800034ec:	892a                	mv	s2,a0
    800034ee:	8a2e                	mv	s4,a1
    800034f0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034f2:	4601                	li	a2,0
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	dd8080e7          	jalr	-552(ra) # 800032cc <dirlookup>
    800034fc:	e93d                	bnez	a0,80003572 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034fe:	04c92483          	lw	s1,76(s2)
    80003502:	c49d                	beqz	s1,80003530 <dirlink+0x54>
    80003504:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003506:	4741                	li	a4,16
    80003508:	86a6                	mv	a3,s1
    8000350a:	fc040613          	addi	a2,s0,-64
    8000350e:	4581                	li	a1,0
    80003510:	854a                	mv	a0,s2
    80003512:	00000097          	auipc	ra,0x0
    80003516:	b8a080e7          	jalr	-1142(ra) # 8000309c <readi>
    8000351a:	47c1                	li	a5,16
    8000351c:	06f51163          	bne	a0,a5,8000357e <dirlink+0xa2>
    if(de.inum == 0)
    80003520:	fc045783          	lhu	a5,-64(s0)
    80003524:	c791                	beqz	a5,80003530 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003526:	24c1                	addiw	s1,s1,16
    80003528:	04c92783          	lw	a5,76(s2)
    8000352c:	fcf4ede3          	bltu	s1,a5,80003506 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003530:	4639                	li	a2,14
    80003532:	85d2                	mv	a1,s4
    80003534:	fc240513          	addi	a0,s0,-62
    80003538:	ffffd097          	auipc	ra,0xffffd
    8000353c:	f50080e7          	jalr	-176(ra) # 80000488 <strncpy>
  de.inum = inum;
    80003540:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003544:	4741                	li	a4,16
    80003546:	86a6                	mv	a3,s1
    80003548:	fc040613          	addi	a2,s0,-64
    8000354c:	4581                	li	a1,0
    8000354e:	854a                	mv	a0,s2
    80003550:	00000097          	auipc	ra,0x0
    80003554:	c44080e7          	jalr	-956(ra) # 80003194 <writei>
    80003558:	872a                	mv	a4,a0
    8000355a:	47c1                	li	a5,16
  return 0;
    8000355c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000355e:	02f71863          	bne	a4,a5,8000358e <dirlink+0xb2>
}
    80003562:	70e2                	ld	ra,56(sp)
    80003564:	7442                	ld	s0,48(sp)
    80003566:	74a2                	ld	s1,40(sp)
    80003568:	7902                	ld	s2,32(sp)
    8000356a:	69e2                	ld	s3,24(sp)
    8000356c:	6a42                	ld	s4,16(sp)
    8000356e:	6121                	addi	sp,sp,64
    80003570:	8082                	ret
    iput(ip);
    80003572:	00000097          	auipc	ra,0x0
    80003576:	a30080e7          	jalr	-1488(ra) # 80002fa2 <iput>
    return -1;
    8000357a:	557d                	li	a0,-1
    8000357c:	b7dd                	j	80003562 <dirlink+0x86>
      panic("dirlink read");
    8000357e:	00005517          	auipc	a0,0x5
    80003582:	06a50513          	addi	a0,a0,106 # 800085e8 <syscalls+0x1c8>
    80003586:	00003097          	auipc	ra,0x3
    8000358a:	912080e7          	jalr	-1774(ra) # 80005e98 <panic>
    panic("dirlink");
    8000358e:	00005517          	auipc	a0,0x5
    80003592:	16a50513          	addi	a0,a0,362 # 800086f8 <syscalls+0x2d8>
    80003596:	00003097          	auipc	ra,0x3
    8000359a:	902080e7          	jalr	-1790(ra) # 80005e98 <panic>

000000008000359e <namei>:

struct inode*
namei(char *path)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035a6:	fe040613          	addi	a2,s0,-32
    800035aa:	4581                	li	a1,0
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	dd0080e7          	jalr	-560(ra) # 8000337c <namex>
}
    800035b4:	60e2                	ld	ra,24(sp)
    800035b6:	6442                	ld	s0,16(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret

00000000800035bc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035bc:	1141                	addi	sp,sp,-16
    800035be:	e406                	sd	ra,8(sp)
    800035c0:	e022                	sd	s0,0(sp)
    800035c2:	0800                	addi	s0,sp,16
    800035c4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035c6:	4585                	li	a1,1
    800035c8:	00000097          	auipc	ra,0x0
    800035cc:	db4080e7          	jalr	-588(ra) # 8000337c <namex>
}
    800035d0:	60a2                	ld	ra,8(sp)
    800035d2:	6402                	ld	s0,0(sp)
    800035d4:	0141                	addi	sp,sp,16
    800035d6:	8082                	ret

00000000800035d8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035d8:	1101                	addi	sp,sp,-32
    800035da:	ec06                	sd	ra,24(sp)
    800035dc:	e822                	sd	s0,16(sp)
    800035de:	e426                	sd	s1,8(sp)
    800035e0:	e04a                	sd	s2,0(sp)
    800035e2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035e4:	00016917          	auipc	s2,0x16
    800035e8:	a5490913          	addi	s2,s2,-1452 # 80019038 <log>
    800035ec:	01892583          	lw	a1,24(s2)
    800035f0:	02892503          	lw	a0,40(s2)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	ff2080e7          	jalr	-14(ra) # 800025e6 <bread>
    800035fc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035fe:	02c92683          	lw	a3,44(s2)
    80003602:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003604:	02d05763          	blez	a3,80003632 <write_head+0x5a>
    80003608:	00016797          	auipc	a5,0x16
    8000360c:	a6078793          	addi	a5,a5,-1440 # 80019068 <log+0x30>
    80003610:	05c50713          	addi	a4,a0,92
    80003614:	36fd                	addiw	a3,a3,-1
    80003616:	1682                	slli	a3,a3,0x20
    80003618:	9281                	srli	a3,a3,0x20
    8000361a:	068a                	slli	a3,a3,0x2
    8000361c:	00016617          	auipc	a2,0x16
    80003620:	a5060613          	addi	a2,a2,-1456 # 8001906c <log+0x34>
    80003624:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003626:	4390                	lw	a2,0(a5)
    80003628:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000362a:	0791                	addi	a5,a5,4
    8000362c:	0711                	addi	a4,a4,4
    8000362e:	fed79ce3          	bne	a5,a3,80003626 <write_head+0x4e>
  }
  bwrite(buf);
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	0a4080e7          	jalr	164(ra) # 800026d8 <bwrite>
  brelse(buf);
    8000363c:	8526                	mv	a0,s1
    8000363e:	fffff097          	auipc	ra,0xfffff
    80003642:	0d8080e7          	jalr	216(ra) # 80002716 <brelse>
}
    80003646:	60e2                	ld	ra,24(sp)
    80003648:	6442                	ld	s0,16(sp)
    8000364a:	64a2                	ld	s1,8(sp)
    8000364c:	6902                	ld	s2,0(sp)
    8000364e:	6105                	addi	sp,sp,32
    80003650:	8082                	ret

0000000080003652 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003652:	00016797          	auipc	a5,0x16
    80003656:	a127a783          	lw	a5,-1518(a5) # 80019064 <log+0x2c>
    8000365a:	0af05d63          	blez	a5,80003714 <install_trans+0xc2>
{
    8000365e:	7139                	addi	sp,sp,-64
    80003660:	fc06                	sd	ra,56(sp)
    80003662:	f822                	sd	s0,48(sp)
    80003664:	f426                	sd	s1,40(sp)
    80003666:	f04a                	sd	s2,32(sp)
    80003668:	ec4e                	sd	s3,24(sp)
    8000366a:	e852                	sd	s4,16(sp)
    8000366c:	e456                	sd	s5,8(sp)
    8000366e:	e05a                	sd	s6,0(sp)
    80003670:	0080                	addi	s0,sp,64
    80003672:	8b2a                	mv	s6,a0
    80003674:	00016a97          	auipc	s5,0x16
    80003678:	9f4a8a93          	addi	s5,s5,-1548 # 80019068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000367c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000367e:	00016997          	auipc	s3,0x16
    80003682:	9ba98993          	addi	s3,s3,-1606 # 80019038 <log>
    80003686:	a035                	j	800036b2 <install_trans+0x60>
      bunpin(dbuf);
    80003688:	8526                	mv	a0,s1
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	166080e7          	jalr	358(ra) # 800027f0 <bunpin>
    brelse(lbuf);
    80003692:	854a                	mv	a0,s2
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	082080e7          	jalr	130(ra) # 80002716 <brelse>
    brelse(dbuf);
    8000369c:	8526                	mv	a0,s1
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	078080e7          	jalr	120(ra) # 80002716 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a6:	2a05                	addiw	s4,s4,1
    800036a8:	0a91                	addi	s5,s5,4
    800036aa:	02c9a783          	lw	a5,44(s3)
    800036ae:	04fa5963          	bge	s4,a5,80003700 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036b2:	0189a583          	lw	a1,24(s3)
    800036b6:	014585bb          	addw	a1,a1,s4
    800036ba:	2585                	addiw	a1,a1,1
    800036bc:	0289a503          	lw	a0,40(s3)
    800036c0:	fffff097          	auipc	ra,0xfffff
    800036c4:	f26080e7          	jalr	-218(ra) # 800025e6 <bread>
    800036c8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036ca:	000aa583          	lw	a1,0(s5)
    800036ce:	0289a503          	lw	a0,40(s3)
    800036d2:	fffff097          	auipc	ra,0xfffff
    800036d6:	f14080e7          	jalr	-236(ra) # 800025e6 <bread>
    800036da:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036dc:	40000613          	li	a2,1024
    800036e0:	05890593          	addi	a1,s2,88
    800036e4:	05850513          	addi	a0,a0,88
    800036e8:	ffffd097          	auipc	ra,0xffffd
    800036ec:	cec080e7          	jalr	-788(ra) # 800003d4 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036f0:	8526                	mv	a0,s1
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	fe6080e7          	jalr	-26(ra) # 800026d8 <bwrite>
    if(recovering == 0)
    800036fa:	f80b1ce3          	bnez	s6,80003692 <install_trans+0x40>
    800036fe:	b769                	j	80003688 <install_trans+0x36>
}
    80003700:	70e2                	ld	ra,56(sp)
    80003702:	7442                	ld	s0,48(sp)
    80003704:	74a2                	ld	s1,40(sp)
    80003706:	7902                	ld	s2,32(sp)
    80003708:	69e2                	ld	s3,24(sp)
    8000370a:	6a42                	ld	s4,16(sp)
    8000370c:	6aa2                	ld	s5,8(sp)
    8000370e:	6b02                	ld	s6,0(sp)
    80003710:	6121                	addi	sp,sp,64
    80003712:	8082                	ret
    80003714:	8082                	ret

0000000080003716 <initlog>:
{
    80003716:	7179                	addi	sp,sp,-48
    80003718:	f406                	sd	ra,40(sp)
    8000371a:	f022                	sd	s0,32(sp)
    8000371c:	ec26                	sd	s1,24(sp)
    8000371e:	e84a                	sd	s2,16(sp)
    80003720:	e44e                	sd	s3,8(sp)
    80003722:	1800                	addi	s0,sp,48
    80003724:	892a                	mv	s2,a0
    80003726:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003728:	00016497          	auipc	s1,0x16
    8000372c:	91048493          	addi	s1,s1,-1776 # 80019038 <log>
    80003730:	00005597          	auipc	a1,0x5
    80003734:	ec858593          	addi	a1,a1,-312 # 800085f8 <syscalls+0x1d8>
    80003738:	8526                	mv	a0,s1
    8000373a:	00003097          	auipc	ra,0x3
    8000373e:	c18080e7          	jalr	-1000(ra) # 80006352 <initlock>
  log.start = sb->logstart;
    80003742:	0149a583          	lw	a1,20(s3)
    80003746:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003748:	0109a783          	lw	a5,16(s3)
    8000374c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000374e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003752:	854a                	mv	a0,s2
    80003754:	fffff097          	auipc	ra,0xfffff
    80003758:	e92080e7          	jalr	-366(ra) # 800025e6 <bread>
  log.lh.n = lh->n;
    8000375c:	4d3c                	lw	a5,88(a0)
    8000375e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003760:	02f05563          	blez	a5,8000378a <initlog+0x74>
    80003764:	05c50713          	addi	a4,a0,92
    80003768:	00016697          	auipc	a3,0x16
    8000376c:	90068693          	addi	a3,a3,-1792 # 80019068 <log+0x30>
    80003770:	37fd                	addiw	a5,a5,-1
    80003772:	1782                	slli	a5,a5,0x20
    80003774:	9381                	srli	a5,a5,0x20
    80003776:	078a                	slli	a5,a5,0x2
    80003778:	06050613          	addi	a2,a0,96
    8000377c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000377e:	4310                	lw	a2,0(a4)
    80003780:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003782:	0711                	addi	a4,a4,4
    80003784:	0691                	addi	a3,a3,4
    80003786:	fef71ce3          	bne	a4,a5,8000377e <initlog+0x68>
  brelse(buf);
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	f8c080e7          	jalr	-116(ra) # 80002716 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003792:	4505                	li	a0,1
    80003794:	00000097          	auipc	ra,0x0
    80003798:	ebe080e7          	jalr	-322(ra) # 80003652 <install_trans>
  log.lh.n = 0;
    8000379c:	00016797          	auipc	a5,0x16
    800037a0:	8c07a423          	sw	zero,-1848(a5) # 80019064 <log+0x2c>
  write_head(); // clear the log
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	e34080e7          	jalr	-460(ra) # 800035d8 <write_head>
}
    800037ac:	70a2                	ld	ra,40(sp)
    800037ae:	7402                	ld	s0,32(sp)
    800037b0:	64e2                	ld	s1,24(sp)
    800037b2:	6942                	ld	s2,16(sp)
    800037b4:	69a2                	ld	s3,8(sp)
    800037b6:	6145                	addi	sp,sp,48
    800037b8:	8082                	ret

00000000800037ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037c6:	00016517          	auipc	a0,0x16
    800037ca:	87250513          	addi	a0,a0,-1934 # 80019038 <log>
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	c14080e7          	jalr	-1004(ra) # 800063e2 <acquire>
  while(1){
    if(log.committing){
    800037d6:	00016497          	auipc	s1,0x16
    800037da:	86248493          	addi	s1,s1,-1950 # 80019038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037de:	4979                	li	s2,30
    800037e0:	a039                	j	800037ee <begin_op+0x34>
      sleep(&log, &log.lock);
    800037e2:	85a6                	mv	a1,s1
    800037e4:	8526                	mv	a0,s1
    800037e6:	ffffe097          	auipc	ra,0xffffe
    800037ea:	01c080e7          	jalr	28(ra) # 80001802 <sleep>
    if(log.committing){
    800037ee:	50dc                	lw	a5,36(s1)
    800037f0:	fbed                	bnez	a5,800037e2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037f2:	509c                	lw	a5,32(s1)
    800037f4:	0017871b          	addiw	a4,a5,1
    800037f8:	0007069b          	sext.w	a3,a4
    800037fc:	0027179b          	slliw	a5,a4,0x2
    80003800:	9fb9                	addw	a5,a5,a4
    80003802:	0017979b          	slliw	a5,a5,0x1
    80003806:	54d8                	lw	a4,44(s1)
    80003808:	9fb9                	addw	a5,a5,a4
    8000380a:	00f95963          	bge	s2,a5,8000381c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000380e:	85a6                	mv	a1,s1
    80003810:	8526                	mv	a0,s1
    80003812:	ffffe097          	auipc	ra,0xffffe
    80003816:	ff0080e7          	jalr	-16(ra) # 80001802 <sleep>
    8000381a:	bfd1                	j	800037ee <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000381c:	00016517          	auipc	a0,0x16
    80003820:	81c50513          	addi	a0,a0,-2020 # 80019038 <log>
    80003824:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	c70080e7          	jalr	-912(ra) # 80006496 <release>
      break;
    }
  }
}
    8000382e:	60e2                	ld	ra,24(sp)
    80003830:	6442                	ld	s0,16(sp)
    80003832:	64a2                	ld	s1,8(sp)
    80003834:	6902                	ld	s2,0(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret

000000008000383a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000383a:	7139                	addi	sp,sp,-64
    8000383c:	fc06                	sd	ra,56(sp)
    8000383e:	f822                	sd	s0,48(sp)
    80003840:	f426                	sd	s1,40(sp)
    80003842:	f04a                	sd	s2,32(sp)
    80003844:	ec4e                	sd	s3,24(sp)
    80003846:	e852                	sd	s4,16(sp)
    80003848:	e456                	sd	s5,8(sp)
    8000384a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000384c:	00015497          	auipc	s1,0x15
    80003850:	7ec48493          	addi	s1,s1,2028 # 80019038 <log>
    80003854:	8526                	mv	a0,s1
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	b8c080e7          	jalr	-1140(ra) # 800063e2 <acquire>
  log.outstanding -= 1;
    8000385e:	509c                	lw	a5,32(s1)
    80003860:	37fd                	addiw	a5,a5,-1
    80003862:	0007891b          	sext.w	s2,a5
    80003866:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003868:	50dc                	lw	a5,36(s1)
    8000386a:	efb9                	bnez	a5,800038c8 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000386c:	06091663          	bnez	s2,800038d8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003870:	00015497          	auipc	s1,0x15
    80003874:	7c848493          	addi	s1,s1,1992 # 80019038 <log>
    80003878:	4785                	li	a5,1
    8000387a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000387c:	8526                	mv	a0,s1
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	c18080e7          	jalr	-1000(ra) # 80006496 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003886:	54dc                	lw	a5,44(s1)
    80003888:	06f04763          	bgtz	a5,800038f6 <end_op+0xbc>
    acquire(&log.lock);
    8000388c:	00015497          	auipc	s1,0x15
    80003890:	7ac48493          	addi	s1,s1,1964 # 80019038 <log>
    80003894:	8526                	mv	a0,s1
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	b4c080e7          	jalr	-1204(ra) # 800063e2 <acquire>
    log.committing = 0;
    8000389e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038a2:	8526                	mv	a0,s1
    800038a4:	ffffe097          	auipc	ra,0xffffe
    800038a8:	0ea080e7          	jalr	234(ra) # 8000198e <wakeup>
    release(&log.lock);
    800038ac:	8526                	mv	a0,s1
    800038ae:	00003097          	auipc	ra,0x3
    800038b2:	be8080e7          	jalr	-1048(ra) # 80006496 <release>
}
    800038b6:	70e2                	ld	ra,56(sp)
    800038b8:	7442                	ld	s0,48(sp)
    800038ba:	74a2                	ld	s1,40(sp)
    800038bc:	7902                	ld	s2,32(sp)
    800038be:	69e2                	ld	s3,24(sp)
    800038c0:	6a42                	ld	s4,16(sp)
    800038c2:	6aa2                	ld	s5,8(sp)
    800038c4:	6121                	addi	sp,sp,64
    800038c6:	8082                	ret
    panic("log.committing");
    800038c8:	00005517          	auipc	a0,0x5
    800038cc:	d3850513          	addi	a0,a0,-712 # 80008600 <syscalls+0x1e0>
    800038d0:	00002097          	auipc	ra,0x2
    800038d4:	5c8080e7          	jalr	1480(ra) # 80005e98 <panic>
    wakeup(&log);
    800038d8:	00015497          	auipc	s1,0x15
    800038dc:	76048493          	addi	s1,s1,1888 # 80019038 <log>
    800038e0:	8526                	mv	a0,s1
    800038e2:	ffffe097          	auipc	ra,0xffffe
    800038e6:	0ac080e7          	jalr	172(ra) # 8000198e <wakeup>
  release(&log.lock);
    800038ea:	8526                	mv	a0,s1
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	baa080e7          	jalr	-1110(ra) # 80006496 <release>
  if(do_commit){
    800038f4:	b7c9                	j	800038b6 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f6:	00015a97          	auipc	s5,0x15
    800038fa:	772a8a93          	addi	s5,s5,1906 # 80019068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038fe:	00015a17          	auipc	s4,0x15
    80003902:	73aa0a13          	addi	s4,s4,1850 # 80019038 <log>
    80003906:	018a2583          	lw	a1,24(s4)
    8000390a:	012585bb          	addw	a1,a1,s2
    8000390e:	2585                	addiw	a1,a1,1
    80003910:	028a2503          	lw	a0,40(s4)
    80003914:	fffff097          	auipc	ra,0xfffff
    80003918:	cd2080e7          	jalr	-814(ra) # 800025e6 <bread>
    8000391c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000391e:	000aa583          	lw	a1,0(s5)
    80003922:	028a2503          	lw	a0,40(s4)
    80003926:	fffff097          	auipc	ra,0xfffff
    8000392a:	cc0080e7          	jalr	-832(ra) # 800025e6 <bread>
    8000392e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003930:	40000613          	li	a2,1024
    80003934:	05850593          	addi	a1,a0,88
    80003938:	05848513          	addi	a0,s1,88
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	a98080e7          	jalr	-1384(ra) # 800003d4 <memmove>
    bwrite(to);  // write the log
    80003944:	8526                	mv	a0,s1
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	d92080e7          	jalr	-622(ra) # 800026d8 <bwrite>
    brelse(from);
    8000394e:	854e                	mv	a0,s3
    80003950:	fffff097          	auipc	ra,0xfffff
    80003954:	dc6080e7          	jalr	-570(ra) # 80002716 <brelse>
    brelse(to);
    80003958:	8526                	mv	a0,s1
    8000395a:	fffff097          	auipc	ra,0xfffff
    8000395e:	dbc080e7          	jalr	-580(ra) # 80002716 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003962:	2905                	addiw	s2,s2,1
    80003964:	0a91                	addi	s5,s5,4
    80003966:	02ca2783          	lw	a5,44(s4)
    8000396a:	f8f94ee3          	blt	s2,a5,80003906 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000396e:	00000097          	auipc	ra,0x0
    80003972:	c6a080e7          	jalr	-918(ra) # 800035d8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003976:	4501                	li	a0,0
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	cda080e7          	jalr	-806(ra) # 80003652 <install_trans>
    log.lh.n = 0;
    80003980:	00015797          	auipc	a5,0x15
    80003984:	6e07a223          	sw	zero,1764(a5) # 80019064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003988:	00000097          	auipc	ra,0x0
    8000398c:	c50080e7          	jalr	-944(ra) # 800035d8 <write_head>
    80003990:	bdf5                	j	8000388c <end_op+0x52>

0000000080003992 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003992:	1101                	addi	sp,sp,-32
    80003994:	ec06                	sd	ra,24(sp)
    80003996:	e822                	sd	s0,16(sp)
    80003998:	e426                	sd	s1,8(sp)
    8000399a:	e04a                	sd	s2,0(sp)
    8000399c:	1000                	addi	s0,sp,32
    8000399e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039a0:	00015917          	auipc	s2,0x15
    800039a4:	69890913          	addi	s2,s2,1688 # 80019038 <log>
    800039a8:	854a                	mv	a0,s2
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	a38080e7          	jalr	-1480(ra) # 800063e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039b2:	02c92603          	lw	a2,44(s2)
    800039b6:	47f5                	li	a5,29
    800039b8:	06c7c563          	blt	a5,a2,80003a22 <log_write+0x90>
    800039bc:	00015797          	auipc	a5,0x15
    800039c0:	6987a783          	lw	a5,1688(a5) # 80019054 <log+0x1c>
    800039c4:	37fd                	addiw	a5,a5,-1
    800039c6:	04f65e63          	bge	a2,a5,80003a22 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039ca:	00015797          	auipc	a5,0x15
    800039ce:	68e7a783          	lw	a5,1678(a5) # 80019058 <log+0x20>
    800039d2:	06f05063          	blez	a5,80003a32 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039d6:	4781                	li	a5,0
    800039d8:	06c05563          	blez	a2,80003a42 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039dc:	44cc                	lw	a1,12(s1)
    800039de:	00015717          	auipc	a4,0x15
    800039e2:	68a70713          	addi	a4,a4,1674 # 80019068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039e6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039e8:	4314                	lw	a3,0(a4)
    800039ea:	04b68c63          	beq	a3,a1,80003a42 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039ee:	2785                	addiw	a5,a5,1
    800039f0:	0711                	addi	a4,a4,4
    800039f2:	fef61be3          	bne	a2,a5,800039e8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039f6:	0621                	addi	a2,a2,8
    800039f8:	060a                	slli	a2,a2,0x2
    800039fa:	00015797          	auipc	a5,0x15
    800039fe:	63e78793          	addi	a5,a5,1598 # 80019038 <log>
    80003a02:	963e                	add	a2,a2,a5
    80003a04:	44dc                	lw	a5,12(s1)
    80003a06:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	fffff097          	auipc	ra,0xfffff
    80003a0e:	daa080e7          	jalr	-598(ra) # 800027b4 <bpin>
    log.lh.n++;
    80003a12:	00015717          	auipc	a4,0x15
    80003a16:	62670713          	addi	a4,a4,1574 # 80019038 <log>
    80003a1a:	575c                	lw	a5,44(a4)
    80003a1c:	2785                	addiw	a5,a5,1
    80003a1e:	d75c                	sw	a5,44(a4)
    80003a20:	a835                	j	80003a5c <log_write+0xca>
    panic("too big a transaction");
    80003a22:	00005517          	auipc	a0,0x5
    80003a26:	bee50513          	addi	a0,a0,-1042 # 80008610 <syscalls+0x1f0>
    80003a2a:	00002097          	auipc	ra,0x2
    80003a2e:	46e080e7          	jalr	1134(ra) # 80005e98 <panic>
    panic("log_write outside of trans");
    80003a32:	00005517          	auipc	a0,0x5
    80003a36:	bf650513          	addi	a0,a0,-1034 # 80008628 <syscalls+0x208>
    80003a3a:	00002097          	auipc	ra,0x2
    80003a3e:	45e080e7          	jalr	1118(ra) # 80005e98 <panic>
  log.lh.block[i] = b->blockno;
    80003a42:	00878713          	addi	a4,a5,8
    80003a46:	00271693          	slli	a3,a4,0x2
    80003a4a:	00015717          	auipc	a4,0x15
    80003a4e:	5ee70713          	addi	a4,a4,1518 # 80019038 <log>
    80003a52:	9736                	add	a4,a4,a3
    80003a54:	44d4                	lw	a3,12(s1)
    80003a56:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a58:	faf608e3          	beq	a2,a5,80003a08 <log_write+0x76>
  }
  release(&log.lock);
    80003a5c:	00015517          	auipc	a0,0x15
    80003a60:	5dc50513          	addi	a0,a0,1500 # 80019038 <log>
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	a32080e7          	jalr	-1486(ra) # 80006496 <release>
}
    80003a6c:	60e2                	ld	ra,24(sp)
    80003a6e:	6442                	ld	s0,16(sp)
    80003a70:	64a2                	ld	s1,8(sp)
    80003a72:	6902                	ld	s2,0(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret

0000000080003a78 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	e426                	sd	s1,8(sp)
    80003a80:	e04a                	sd	s2,0(sp)
    80003a82:	1000                	addi	s0,sp,32
    80003a84:	84aa                	mv	s1,a0
    80003a86:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a88:	00005597          	auipc	a1,0x5
    80003a8c:	bc058593          	addi	a1,a1,-1088 # 80008648 <syscalls+0x228>
    80003a90:	0521                	addi	a0,a0,8
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	8c0080e7          	jalr	-1856(ra) # 80006352 <initlock>
  lk->name = name;
    80003a9a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a9e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa2:	0204a423          	sw	zero,40(s1)
}
    80003aa6:	60e2                	ld	ra,24(sp)
    80003aa8:	6442                	ld	s0,16(sp)
    80003aaa:	64a2                	ld	s1,8(sp)
    80003aac:	6902                	ld	s2,0(sp)
    80003aae:	6105                	addi	sp,sp,32
    80003ab0:	8082                	ret

0000000080003ab2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ab2:	1101                	addi	sp,sp,-32
    80003ab4:	ec06                	sd	ra,24(sp)
    80003ab6:	e822                	sd	s0,16(sp)
    80003ab8:	e426                	sd	s1,8(sp)
    80003aba:	e04a                	sd	s2,0(sp)
    80003abc:	1000                	addi	s0,sp,32
    80003abe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ac0:	00850913          	addi	s2,a0,8
    80003ac4:	854a                	mv	a0,s2
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	91c080e7          	jalr	-1764(ra) # 800063e2 <acquire>
  while (lk->locked) {
    80003ace:	409c                	lw	a5,0(s1)
    80003ad0:	cb89                	beqz	a5,80003ae2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ad2:	85ca                	mv	a1,s2
    80003ad4:	8526                	mv	a0,s1
    80003ad6:	ffffe097          	auipc	ra,0xffffe
    80003ada:	d2c080e7          	jalr	-724(ra) # 80001802 <sleep>
  while (lk->locked) {
    80003ade:	409c                	lw	a5,0(s1)
    80003ae0:	fbed                	bnez	a5,80003ad2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ae2:	4785                	li	a5,1
    80003ae4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ae6:	ffffd097          	auipc	ra,0xffffd
    80003aea:	660080e7          	jalr	1632(ra) # 80001146 <myproc>
    80003aee:	591c                	lw	a5,48(a0)
    80003af0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003af2:	854a                	mv	a0,s2
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	9a2080e7          	jalr	-1630(ra) # 80006496 <release>
}
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b08:	1101                	addi	sp,sp,-32
    80003b0a:	ec06                	sd	ra,24(sp)
    80003b0c:	e822                	sd	s0,16(sp)
    80003b0e:	e426                	sd	s1,8(sp)
    80003b10:	e04a                	sd	s2,0(sp)
    80003b12:	1000                	addi	s0,sp,32
    80003b14:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b16:	00850913          	addi	s2,a0,8
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	8c6080e7          	jalr	-1850(ra) # 800063e2 <acquire>
  lk->locked = 0;
    80003b24:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b28:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b2c:	8526                	mv	a0,s1
    80003b2e:	ffffe097          	auipc	ra,0xffffe
    80003b32:	e60080e7          	jalr	-416(ra) # 8000198e <wakeup>
  release(&lk->lk);
    80003b36:	854a                	mv	a0,s2
    80003b38:	00003097          	auipc	ra,0x3
    80003b3c:	95e080e7          	jalr	-1698(ra) # 80006496 <release>
}
    80003b40:	60e2                	ld	ra,24(sp)
    80003b42:	6442                	ld	s0,16(sp)
    80003b44:	64a2                	ld	s1,8(sp)
    80003b46:	6902                	ld	s2,0(sp)
    80003b48:	6105                	addi	sp,sp,32
    80003b4a:	8082                	ret

0000000080003b4c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b4c:	7179                	addi	sp,sp,-48
    80003b4e:	f406                	sd	ra,40(sp)
    80003b50:	f022                	sd	s0,32(sp)
    80003b52:	ec26                	sd	s1,24(sp)
    80003b54:	e84a                	sd	s2,16(sp)
    80003b56:	e44e                	sd	s3,8(sp)
    80003b58:	1800                	addi	s0,sp,48
    80003b5a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b5c:	00850913          	addi	s2,a0,8
    80003b60:	854a                	mv	a0,s2
    80003b62:	00003097          	auipc	ra,0x3
    80003b66:	880080e7          	jalr	-1920(ra) # 800063e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b6a:	409c                	lw	a5,0(s1)
    80003b6c:	ef99                	bnez	a5,80003b8a <holdingsleep+0x3e>
    80003b6e:	4481                	li	s1,0
  release(&lk->lk);
    80003b70:	854a                	mv	a0,s2
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	924080e7          	jalr	-1756(ra) # 80006496 <release>
  return r;
}
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	70a2                	ld	ra,40(sp)
    80003b7e:	7402                	ld	s0,32(sp)
    80003b80:	64e2                	ld	s1,24(sp)
    80003b82:	6942                	ld	s2,16(sp)
    80003b84:	69a2                	ld	s3,8(sp)
    80003b86:	6145                	addi	sp,sp,48
    80003b88:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b8a:	0284a983          	lw	s3,40(s1)
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	5b8080e7          	jalr	1464(ra) # 80001146 <myproc>
    80003b96:	5904                	lw	s1,48(a0)
    80003b98:	413484b3          	sub	s1,s1,s3
    80003b9c:	0014b493          	seqz	s1,s1
    80003ba0:	bfc1                	j	80003b70 <holdingsleep+0x24>

0000000080003ba2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ba2:	1141                	addi	sp,sp,-16
    80003ba4:	e406                	sd	ra,8(sp)
    80003ba6:	e022                	sd	s0,0(sp)
    80003ba8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003baa:	00005597          	auipc	a1,0x5
    80003bae:	aae58593          	addi	a1,a1,-1362 # 80008658 <syscalls+0x238>
    80003bb2:	00015517          	auipc	a0,0x15
    80003bb6:	5ce50513          	addi	a0,a0,1486 # 80019180 <ftable>
    80003bba:	00002097          	auipc	ra,0x2
    80003bbe:	798080e7          	jalr	1944(ra) # 80006352 <initlock>
}
    80003bc2:	60a2                	ld	ra,8(sp)
    80003bc4:	6402                	ld	s0,0(sp)
    80003bc6:	0141                	addi	sp,sp,16
    80003bc8:	8082                	ret

0000000080003bca <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bd4:	00015517          	auipc	a0,0x15
    80003bd8:	5ac50513          	addi	a0,a0,1452 # 80019180 <ftable>
    80003bdc:	00003097          	auipc	ra,0x3
    80003be0:	806080e7          	jalr	-2042(ra) # 800063e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003be4:	00015497          	auipc	s1,0x15
    80003be8:	5b448493          	addi	s1,s1,1460 # 80019198 <ftable+0x18>
    80003bec:	00016717          	auipc	a4,0x16
    80003bf0:	54c70713          	addi	a4,a4,1356 # 8001a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003bf4:	40dc                	lw	a5,4(s1)
    80003bf6:	cf99                	beqz	a5,80003c14 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bf8:	02848493          	addi	s1,s1,40
    80003bfc:	fee49ce3          	bne	s1,a4,80003bf4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c00:	00015517          	auipc	a0,0x15
    80003c04:	58050513          	addi	a0,a0,1408 # 80019180 <ftable>
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	88e080e7          	jalr	-1906(ra) # 80006496 <release>
  return 0;
    80003c10:	4481                	li	s1,0
    80003c12:	a819                	j	80003c28 <filealloc+0x5e>
      f->ref = 1;
    80003c14:	4785                	li	a5,1
    80003c16:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c18:	00015517          	auipc	a0,0x15
    80003c1c:	56850513          	addi	a0,a0,1384 # 80019180 <ftable>
    80003c20:	00003097          	auipc	ra,0x3
    80003c24:	876080e7          	jalr	-1930(ra) # 80006496 <release>
}
    80003c28:	8526                	mv	a0,s1
    80003c2a:	60e2                	ld	ra,24(sp)
    80003c2c:	6442                	ld	s0,16(sp)
    80003c2e:	64a2                	ld	s1,8(sp)
    80003c30:	6105                	addi	sp,sp,32
    80003c32:	8082                	ret

0000000080003c34 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c34:	1101                	addi	sp,sp,-32
    80003c36:	ec06                	sd	ra,24(sp)
    80003c38:	e822                	sd	s0,16(sp)
    80003c3a:	e426                	sd	s1,8(sp)
    80003c3c:	1000                	addi	s0,sp,32
    80003c3e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c40:	00015517          	auipc	a0,0x15
    80003c44:	54050513          	addi	a0,a0,1344 # 80019180 <ftable>
    80003c48:	00002097          	auipc	ra,0x2
    80003c4c:	79a080e7          	jalr	1946(ra) # 800063e2 <acquire>
  if(f->ref < 1)
    80003c50:	40dc                	lw	a5,4(s1)
    80003c52:	02f05263          	blez	a5,80003c76 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c56:	2785                	addiw	a5,a5,1
    80003c58:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c5a:	00015517          	auipc	a0,0x15
    80003c5e:	52650513          	addi	a0,a0,1318 # 80019180 <ftable>
    80003c62:	00003097          	auipc	ra,0x3
    80003c66:	834080e7          	jalr	-1996(ra) # 80006496 <release>
  return f;
}
    80003c6a:	8526                	mv	a0,s1
    80003c6c:	60e2                	ld	ra,24(sp)
    80003c6e:	6442                	ld	s0,16(sp)
    80003c70:	64a2                	ld	s1,8(sp)
    80003c72:	6105                	addi	sp,sp,32
    80003c74:	8082                	ret
    panic("filedup");
    80003c76:	00005517          	auipc	a0,0x5
    80003c7a:	9ea50513          	addi	a0,a0,-1558 # 80008660 <syscalls+0x240>
    80003c7e:	00002097          	auipc	ra,0x2
    80003c82:	21a080e7          	jalr	538(ra) # 80005e98 <panic>

0000000080003c86 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c86:	7139                	addi	sp,sp,-64
    80003c88:	fc06                	sd	ra,56(sp)
    80003c8a:	f822                	sd	s0,48(sp)
    80003c8c:	f426                	sd	s1,40(sp)
    80003c8e:	f04a                	sd	s2,32(sp)
    80003c90:	ec4e                	sd	s3,24(sp)
    80003c92:	e852                	sd	s4,16(sp)
    80003c94:	e456                	sd	s5,8(sp)
    80003c96:	0080                	addi	s0,sp,64
    80003c98:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c9a:	00015517          	auipc	a0,0x15
    80003c9e:	4e650513          	addi	a0,a0,1254 # 80019180 <ftable>
    80003ca2:	00002097          	auipc	ra,0x2
    80003ca6:	740080e7          	jalr	1856(ra) # 800063e2 <acquire>
  if(f->ref < 1)
    80003caa:	40dc                	lw	a5,4(s1)
    80003cac:	06f05163          	blez	a5,80003d0e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cb0:	37fd                	addiw	a5,a5,-1
    80003cb2:	0007871b          	sext.w	a4,a5
    80003cb6:	c0dc                	sw	a5,4(s1)
    80003cb8:	06e04363          	bgtz	a4,80003d1e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cbc:	0004a903          	lw	s2,0(s1)
    80003cc0:	0094ca83          	lbu	s5,9(s1)
    80003cc4:	0104ba03          	ld	s4,16(s1)
    80003cc8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ccc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cd0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cd4:	00015517          	auipc	a0,0x15
    80003cd8:	4ac50513          	addi	a0,a0,1196 # 80019180 <ftable>
    80003cdc:	00002097          	auipc	ra,0x2
    80003ce0:	7ba080e7          	jalr	1978(ra) # 80006496 <release>

  if(ff.type == FD_PIPE){
    80003ce4:	4785                	li	a5,1
    80003ce6:	04f90d63          	beq	s2,a5,80003d40 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cea:	3979                	addiw	s2,s2,-2
    80003cec:	4785                	li	a5,1
    80003cee:	0527e063          	bltu	a5,s2,80003d2e <fileclose+0xa8>
    begin_op();
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	ac8080e7          	jalr	-1336(ra) # 800037ba <begin_op>
    iput(ff.ip);
    80003cfa:	854e                	mv	a0,s3
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	2a6080e7          	jalr	678(ra) # 80002fa2 <iput>
    end_op();
    80003d04:	00000097          	auipc	ra,0x0
    80003d08:	b36080e7          	jalr	-1226(ra) # 8000383a <end_op>
    80003d0c:	a00d                	j	80003d2e <fileclose+0xa8>
    panic("fileclose");
    80003d0e:	00005517          	auipc	a0,0x5
    80003d12:	95a50513          	addi	a0,a0,-1702 # 80008668 <syscalls+0x248>
    80003d16:	00002097          	auipc	ra,0x2
    80003d1a:	182080e7          	jalr	386(ra) # 80005e98 <panic>
    release(&ftable.lock);
    80003d1e:	00015517          	auipc	a0,0x15
    80003d22:	46250513          	addi	a0,a0,1122 # 80019180 <ftable>
    80003d26:	00002097          	auipc	ra,0x2
    80003d2a:	770080e7          	jalr	1904(ra) # 80006496 <release>
  }
}
    80003d2e:	70e2                	ld	ra,56(sp)
    80003d30:	7442                	ld	s0,48(sp)
    80003d32:	74a2                	ld	s1,40(sp)
    80003d34:	7902                	ld	s2,32(sp)
    80003d36:	69e2                	ld	s3,24(sp)
    80003d38:	6a42                	ld	s4,16(sp)
    80003d3a:	6aa2                	ld	s5,8(sp)
    80003d3c:	6121                	addi	sp,sp,64
    80003d3e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d40:	85d6                	mv	a1,s5
    80003d42:	8552                	mv	a0,s4
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	34c080e7          	jalr	844(ra) # 80004090 <pipeclose>
    80003d4c:	b7cd                	j	80003d2e <fileclose+0xa8>

0000000080003d4e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d4e:	715d                	addi	sp,sp,-80
    80003d50:	e486                	sd	ra,72(sp)
    80003d52:	e0a2                	sd	s0,64(sp)
    80003d54:	fc26                	sd	s1,56(sp)
    80003d56:	f84a                	sd	s2,48(sp)
    80003d58:	f44e                	sd	s3,40(sp)
    80003d5a:	0880                	addi	s0,sp,80
    80003d5c:	84aa                	mv	s1,a0
    80003d5e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d60:	ffffd097          	auipc	ra,0xffffd
    80003d64:	3e6080e7          	jalr	998(ra) # 80001146 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d68:	409c                	lw	a5,0(s1)
    80003d6a:	37f9                	addiw	a5,a5,-2
    80003d6c:	4705                	li	a4,1
    80003d6e:	04f76763          	bltu	a4,a5,80003dbc <filestat+0x6e>
    80003d72:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d74:	6c88                	ld	a0,24(s1)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	072080e7          	jalr	114(ra) # 80002de8 <ilock>
    stati(f->ip, &st);
    80003d7e:	fb840593          	addi	a1,s0,-72
    80003d82:	6c88                	ld	a0,24(s1)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	2ee080e7          	jalr	750(ra) # 80003072 <stati>
    iunlock(f->ip);
    80003d8c:	6c88                	ld	a0,24(s1)
    80003d8e:	fffff097          	auipc	ra,0xfffff
    80003d92:	11c080e7          	jalr	284(ra) # 80002eaa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d96:	46e1                	li	a3,24
    80003d98:	fb840613          	addi	a2,s0,-72
    80003d9c:	85ce                	mv	a1,s3
    80003d9e:	05093503          	ld	a0,80(s2)
    80003da2:	ffffd097          	auipc	ra,0xffffd
    80003da6:	174080e7          	jalr	372(ra) # 80000f16 <copyout>
    80003daa:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003dae:	60a6                	ld	ra,72(sp)
    80003db0:	6406                	ld	s0,64(sp)
    80003db2:	74e2                	ld	s1,56(sp)
    80003db4:	7942                	ld	s2,48(sp)
    80003db6:	79a2                	ld	s3,40(sp)
    80003db8:	6161                	addi	sp,sp,80
    80003dba:	8082                	ret
  return -1;
    80003dbc:	557d                	li	a0,-1
    80003dbe:	bfc5                	j	80003dae <filestat+0x60>

0000000080003dc0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dc0:	7179                	addi	sp,sp,-48
    80003dc2:	f406                	sd	ra,40(sp)
    80003dc4:	f022                	sd	s0,32(sp)
    80003dc6:	ec26                	sd	s1,24(sp)
    80003dc8:	e84a                	sd	s2,16(sp)
    80003dca:	e44e                	sd	s3,8(sp)
    80003dcc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003dce:	00854783          	lbu	a5,8(a0)
    80003dd2:	c3d5                	beqz	a5,80003e76 <fileread+0xb6>
    80003dd4:	84aa                	mv	s1,a0
    80003dd6:	89ae                	mv	s3,a1
    80003dd8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dda:	411c                	lw	a5,0(a0)
    80003ddc:	4705                	li	a4,1
    80003dde:	04e78963          	beq	a5,a4,80003e30 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003de2:	470d                	li	a4,3
    80003de4:	04e78d63          	beq	a5,a4,80003e3e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de8:	4709                	li	a4,2
    80003dea:	06e79e63          	bne	a5,a4,80003e66 <fileread+0xa6>
    ilock(f->ip);
    80003dee:	6d08                	ld	a0,24(a0)
    80003df0:	fffff097          	auipc	ra,0xfffff
    80003df4:	ff8080e7          	jalr	-8(ra) # 80002de8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003df8:	874a                	mv	a4,s2
    80003dfa:	5094                	lw	a3,32(s1)
    80003dfc:	864e                	mv	a2,s3
    80003dfe:	4585                	li	a1,1
    80003e00:	6c88                	ld	a0,24(s1)
    80003e02:	fffff097          	auipc	ra,0xfffff
    80003e06:	29a080e7          	jalr	666(ra) # 8000309c <readi>
    80003e0a:	892a                	mv	s2,a0
    80003e0c:	00a05563          	blez	a0,80003e16 <fileread+0x56>
      f->off += r;
    80003e10:	509c                	lw	a5,32(s1)
    80003e12:	9fa9                	addw	a5,a5,a0
    80003e14:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e16:	6c88                	ld	a0,24(s1)
    80003e18:	fffff097          	auipc	ra,0xfffff
    80003e1c:	092080e7          	jalr	146(ra) # 80002eaa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e20:	854a                	mv	a0,s2
    80003e22:	70a2                	ld	ra,40(sp)
    80003e24:	7402                	ld	s0,32(sp)
    80003e26:	64e2                	ld	s1,24(sp)
    80003e28:	6942                	ld	s2,16(sp)
    80003e2a:	69a2                	ld	s3,8(sp)
    80003e2c:	6145                	addi	sp,sp,48
    80003e2e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e30:	6908                	ld	a0,16(a0)
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	3c8080e7          	jalr	968(ra) # 800041fa <piperead>
    80003e3a:	892a                	mv	s2,a0
    80003e3c:	b7d5                	j	80003e20 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e3e:	02451783          	lh	a5,36(a0)
    80003e42:	03079693          	slli	a3,a5,0x30
    80003e46:	92c1                	srli	a3,a3,0x30
    80003e48:	4725                	li	a4,9
    80003e4a:	02d76863          	bltu	a4,a3,80003e7a <fileread+0xba>
    80003e4e:	0792                	slli	a5,a5,0x4
    80003e50:	00015717          	auipc	a4,0x15
    80003e54:	29070713          	addi	a4,a4,656 # 800190e0 <devsw>
    80003e58:	97ba                	add	a5,a5,a4
    80003e5a:	639c                	ld	a5,0(a5)
    80003e5c:	c38d                	beqz	a5,80003e7e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e5e:	4505                	li	a0,1
    80003e60:	9782                	jalr	a5
    80003e62:	892a                	mv	s2,a0
    80003e64:	bf75                	j	80003e20 <fileread+0x60>
    panic("fileread");
    80003e66:	00005517          	auipc	a0,0x5
    80003e6a:	81250513          	addi	a0,a0,-2030 # 80008678 <syscalls+0x258>
    80003e6e:	00002097          	auipc	ra,0x2
    80003e72:	02a080e7          	jalr	42(ra) # 80005e98 <panic>
    return -1;
    80003e76:	597d                	li	s2,-1
    80003e78:	b765                	j	80003e20 <fileread+0x60>
      return -1;
    80003e7a:	597d                	li	s2,-1
    80003e7c:	b755                	j	80003e20 <fileread+0x60>
    80003e7e:	597d                	li	s2,-1
    80003e80:	b745                	j	80003e20 <fileread+0x60>

0000000080003e82 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e82:	715d                	addi	sp,sp,-80
    80003e84:	e486                	sd	ra,72(sp)
    80003e86:	e0a2                	sd	s0,64(sp)
    80003e88:	fc26                	sd	s1,56(sp)
    80003e8a:	f84a                	sd	s2,48(sp)
    80003e8c:	f44e                	sd	s3,40(sp)
    80003e8e:	f052                	sd	s4,32(sp)
    80003e90:	ec56                	sd	s5,24(sp)
    80003e92:	e85a                	sd	s6,16(sp)
    80003e94:	e45e                	sd	s7,8(sp)
    80003e96:	e062                	sd	s8,0(sp)
    80003e98:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e9a:	00954783          	lbu	a5,9(a0)
    80003e9e:	10078663          	beqz	a5,80003faa <filewrite+0x128>
    80003ea2:	892a                	mv	s2,a0
    80003ea4:	8aae                	mv	s5,a1
    80003ea6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ea8:	411c                	lw	a5,0(a0)
    80003eaa:	4705                	li	a4,1
    80003eac:	02e78263          	beq	a5,a4,80003ed0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb0:	470d                	li	a4,3
    80003eb2:	02e78663          	beq	a5,a4,80003ede <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eb6:	4709                	li	a4,2
    80003eb8:	0ee79163          	bne	a5,a4,80003f9a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ebc:	0ac05d63          	blez	a2,80003f76 <filewrite+0xf4>
    int i = 0;
    80003ec0:	4981                	li	s3,0
    80003ec2:	6b05                	lui	s6,0x1
    80003ec4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ec8:	6b85                	lui	s7,0x1
    80003eca:	c00b8b9b          	addiw	s7,s7,-1024
    80003ece:	a861                	j	80003f66 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ed0:	6908                	ld	a0,16(a0)
    80003ed2:	00000097          	auipc	ra,0x0
    80003ed6:	22e080e7          	jalr	558(ra) # 80004100 <pipewrite>
    80003eda:	8a2a                	mv	s4,a0
    80003edc:	a045                	j	80003f7c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ede:	02451783          	lh	a5,36(a0)
    80003ee2:	03079693          	slli	a3,a5,0x30
    80003ee6:	92c1                	srli	a3,a3,0x30
    80003ee8:	4725                	li	a4,9
    80003eea:	0cd76263          	bltu	a4,a3,80003fae <filewrite+0x12c>
    80003eee:	0792                	slli	a5,a5,0x4
    80003ef0:	00015717          	auipc	a4,0x15
    80003ef4:	1f070713          	addi	a4,a4,496 # 800190e0 <devsw>
    80003ef8:	97ba                	add	a5,a5,a4
    80003efa:	679c                	ld	a5,8(a5)
    80003efc:	cbdd                	beqz	a5,80003fb2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003efe:	4505                	li	a0,1
    80003f00:	9782                	jalr	a5
    80003f02:	8a2a                	mv	s4,a0
    80003f04:	a8a5                	j	80003f7c <filewrite+0xfa>
    80003f06:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	8b0080e7          	jalr	-1872(ra) # 800037ba <begin_op>
      ilock(f->ip);
    80003f12:	01893503          	ld	a0,24(s2)
    80003f16:	fffff097          	auipc	ra,0xfffff
    80003f1a:	ed2080e7          	jalr	-302(ra) # 80002de8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f1e:	8762                	mv	a4,s8
    80003f20:	02092683          	lw	a3,32(s2)
    80003f24:	01598633          	add	a2,s3,s5
    80003f28:	4585                	li	a1,1
    80003f2a:	01893503          	ld	a0,24(s2)
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	266080e7          	jalr	614(ra) # 80003194 <writei>
    80003f36:	84aa                	mv	s1,a0
    80003f38:	00a05763          	blez	a0,80003f46 <filewrite+0xc4>
        f->off += r;
    80003f3c:	02092783          	lw	a5,32(s2)
    80003f40:	9fa9                	addw	a5,a5,a0
    80003f42:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f46:	01893503          	ld	a0,24(s2)
    80003f4a:	fffff097          	auipc	ra,0xfffff
    80003f4e:	f60080e7          	jalr	-160(ra) # 80002eaa <iunlock>
      end_op();
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	8e8080e7          	jalr	-1816(ra) # 8000383a <end_op>

      if(r != n1){
    80003f5a:	009c1f63          	bne	s8,s1,80003f78 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f5e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f62:	0149db63          	bge	s3,s4,80003f78 <filewrite+0xf6>
      int n1 = n - i;
    80003f66:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f6a:	84be                	mv	s1,a5
    80003f6c:	2781                	sext.w	a5,a5
    80003f6e:	f8fb5ce3          	bge	s6,a5,80003f06 <filewrite+0x84>
    80003f72:	84de                	mv	s1,s7
    80003f74:	bf49                	j	80003f06 <filewrite+0x84>
    int i = 0;
    80003f76:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f78:	013a1f63          	bne	s4,s3,80003f96 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f7c:	8552                	mv	a0,s4
    80003f7e:	60a6                	ld	ra,72(sp)
    80003f80:	6406                	ld	s0,64(sp)
    80003f82:	74e2                	ld	s1,56(sp)
    80003f84:	7942                	ld	s2,48(sp)
    80003f86:	79a2                	ld	s3,40(sp)
    80003f88:	7a02                	ld	s4,32(sp)
    80003f8a:	6ae2                	ld	s5,24(sp)
    80003f8c:	6b42                	ld	s6,16(sp)
    80003f8e:	6ba2                	ld	s7,8(sp)
    80003f90:	6c02                	ld	s8,0(sp)
    80003f92:	6161                	addi	sp,sp,80
    80003f94:	8082                	ret
    ret = (i == n ? n : -1);
    80003f96:	5a7d                	li	s4,-1
    80003f98:	b7d5                	j	80003f7c <filewrite+0xfa>
    panic("filewrite");
    80003f9a:	00004517          	auipc	a0,0x4
    80003f9e:	6ee50513          	addi	a0,a0,1774 # 80008688 <syscalls+0x268>
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	ef6080e7          	jalr	-266(ra) # 80005e98 <panic>
    return -1;
    80003faa:	5a7d                	li	s4,-1
    80003fac:	bfc1                	j	80003f7c <filewrite+0xfa>
      return -1;
    80003fae:	5a7d                	li	s4,-1
    80003fb0:	b7f1                	j	80003f7c <filewrite+0xfa>
    80003fb2:	5a7d                	li	s4,-1
    80003fb4:	b7e1                	j	80003f7c <filewrite+0xfa>

0000000080003fb6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fb6:	7179                	addi	sp,sp,-48
    80003fb8:	f406                	sd	ra,40(sp)
    80003fba:	f022                	sd	s0,32(sp)
    80003fbc:	ec26                	sd	s1,24(sp)
    80003fbe:	e84a                	sd	s2,16(sp)
    80003fc0:	e44e                	sd	s3,8(sp)
    80003fc2:	e052                	sd	s4,0(sp)
    80003fc4:	1800                	addi	s0,sp,48
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fca:	0005b023          	sd	zero,0(a1)
    80003fce:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	bf8080e7          	jalr	-1032(ra) # 80003bca <filealloc>
    80003fda:	e088                	sd	a0,0(s1)
    80003fdc:	c551                	beqz	a0,80004068 <pipealloc+0xb2>
    80003fde:	00000097          	auipc	ra,0x0
    80003fe2:	bec080e7          	jalr	-1044(ra) # 80003bca <filealloc>
    80003fe6:	00aa3023          	sd	a0,0(s4)
    80003fea:	c92d                	beqz	a0,8000405c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fec:	ffffc097          	auipc	ra,0xffffc
    80003ff0:	31e080e7          	jalr	798(ra) # 8000030a <kalloc>
    80003ff4:	892a                	mv	s2,a0
    80003ff6:	c125                	beqz	a0,80004056 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ff8:	4985                	li	s3,1
    80003ffa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ffe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004002:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004006:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000400a:	00004597          	auipc	a1,0x4
    8000400e:	68e58593          	addi	a1,a1,1678 # 80008698 <syscalls+0x278>
    80004012:	00002097          	auipc	ra,0x2
    80004016:	340080e7          	jalr	832(ra) # 80006352 <initlock>
  (*f0)->type = FD_PIPE;
    8000401a:	609c                	ld	a5,0(s1)
    8000401c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004020:	609c                	ld	a5,0(s1)
    80004022:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004026:	609c                	ld	a5,0(s1)
    80004028:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000402c:	609c                	ld	a5,0(s1)
    8000402e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004032:	000a3783          	ld	a5,0(s4)
    80004036:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000403a:	000a3783          	ld	a5,0(s4)
    8000403e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004042:	000a3783          	ld	a5,0(s4)
    80004046:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000404a:	000a3783          	ld	a5,0(s4)
    8000404e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004052:	4501                	li	a0,0
    80004054:	a025                	j	8000407c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004056:	6088                	ld	a0,0(s1)
    80004058:	e501                	bnez	a0,80004060 <pipealloc+0xaa>
    8000405a:	a039                	j	80004068 <pipealloc+0xb2>
    8000405c:	6088                	ld	a0,0(s1)
    8000405e:	c51d                	beqz	a0,8000408c <pipealloc+0xd6>
    fileclose(*f0);
    80004060:	00000097          	auipc	ra,0x0
    80004064:	c26080e7          	jalr	-986(ra) # 80003c86 <fileclose>
  if(*f1)
    80004068:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000406c:	557d                	li	a0,-1
  if(*f1)
    8000406e:	c799                	beqz	a5,8000407c <pipealloc+0xc6>
    fileclose(*f1);
    80004070:	853e                	mv	a0,a5
    80004072:	00000097          	auipc	ra,0x0
    80004076:	c14080e7          	jalr	-1004(ra) # 80003c86 <fileclose>
  return -1;
    8000407a:	557d                	li	a0,-1
}
    8000407c:	70a2                	ld	ra,40(sp)
    8000407e:	7402                	ld	s0,32(sp)
    80004080:	64e2                	ld	s1,24(sp)
    80004082:	6942                	ld	s2,16(sp)
    80004084:	69a2                	ld	s3,8(sp)
    80004086:	6a02                	ld	s4,0(sp)
    80004088:	6145                	addi	sp,sp,48
    8000408a:	8082                	ret
  return -1;
    8000408c:	557d                	li	a0,-1
    8000408e:	b7fd                	j	8000407c <pipealloc+0xc6>

0000000080004090 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004090:	1101                	addi	sp,sp,-32
    80004092:	ec06                	sd	ra,24(sp)
    80004094:	e822                	sd	s0,16(sp)
    80004096:	e426                	sd	s1,8(sp)
    80004098:	e04a                	sd	s2,0(sp)
    8000409a:	1000                	addi	s0,sp,32
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040a0:	00002097          	auipc	ra,0x2
    800040a4:	342080e7          	jalr	834(ra) # 800063e2 <acquire>
  if(writable){
    800040a8:	02090d63          	beqz	s2,800040e2 <pipeclose+0x52>
    pi->writeopen = 0;
    800040ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040b0:	21848513          	addi	a0,s1,536
    800040b4:	ffffe097          	auipc	ra,0xffffe
    800040b8:	8da080e7          	jalr	-1830(ra) # 8000198e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040bc:	2204b783          	ld	a5,544(s1)
    800040c0:	eb95                	bnez	a5,800040f4 <pipeclose+0x64>
    release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	3d2080e7          	jalr	978(ra) # 80006496 <release>
    kfree((char*)pi);
    800040cc:	8526                	mv	a0,s1
    800040ce:	ffffc097          	auipc	ra,0xffffc
    800040d2:	076080e7          	jalr	118(ra) # 80000144 <kfree>
  } else
    release(&pi->lock);
}
    800040d6:	60e2                	ld	ra,24(sp)
    800040d8:	6442                	ld	s0,16(sp)
    800040da:	64a2                	ld	s1,8(sp)
    800040dc:	6902                	ld	s2,0(sp)
    800040de:	6105                	addi	sp,sp,32
    800040e0:	8082                	ret
    pi->readopen = 0;
    800040e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040e6:	21c48513          	addi	a0,s1,540
    800040ea:	ffffe097          	auipc	ra,0xffffe
    800040ee:	8a4080e7          	jalr	-1884(ra) # 8000198e <wakeup>
    800040f2:	b7e9                	j	800040bc <pipeclose+0x2c>
    release(&pi->lock);
    800040f4:	8526                	mv	a0,s1
    800040f6:	00002097          	auipc	ra,0x2
    800040fa:	3a0080e7          	jalr	928(ra) # 80006496 <release>
}
    800040fe:	bfe1                	j	800040d6 <pipeclose+0x46>

0000000080004100 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004100:	7159                	addi	sp,sp,-112
    80004102:	f486                	sd	ra,104(sp)
    80004104:	f0a2                	sd	s0,96(sp)
    80004106:	eca6                	sd	s1,88(sp)
    80004108:	e8ca                	sd	s2,80(sp)
    8000410a:	e4ce                	sd	s3,72(sp)
    8000410c:	e0d2                	sd	s4,64(sp)
    8000410e:	fc56                	sd	s5,56(sp)
    80004110:	f85a                	sd	s6,48(sp)
    80004112:	f45e                	sd	s7,40(sp)
    80004114:	f062                	sd	s8,32(sp)
    80004116:	ec66                	sd	s9,24(sp)
    80004118:	1880                	addi	s0,sp,112
    8000411a:	84aa                	mv	s1,a0
    8000411c:	8aae                	mv	s5,a1
    8000411e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	026080e7          	jalr	38(ra) # 80001146 <myproc>
    80004128:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000412a:	8526                	mv	a0,s1
    8000412c:	00002097          	auipc	ra,0x2
    80004130:	2b6080e7          	jalr	694(ra) # 800063e2 <acquire>
  while(i < n){
    80004134:	0d405163          	blez	s4,800041f6 <pipewrite+0xf6>
    80004138:	8ba6                	mv	s7,s1
  int i = 0;
    8000413a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000413e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004142:	21c48c13          	addi	s8,s1,540
    80004146:	a08d                	j	800041a8 <pipewrite+0xa8>
      release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	34c080e7          	jalr	844(ra) # 80006496 <release>
      return -1;
    80004152:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004154:	854a                	mv	a0,s2
    80004156:	70a6                	ld	ra,104(sp)
    80004158:	7406                	ld	s0,96(sp)
    8000415a:	64e6                	ld	s1,88(sp)
    8000415c:	6946                	ld	s2,80(sp)
    8000415e:	69a6                	ld	s3,72(sp)
    80004160:	6a06                	ld	s4,64(sp)
    80004162:	7ae2                	ld	s5,56(sp)
    80004164:	7b42                	ld	s6,48(sp)
    80004166:	7ba2                	ld	s7,40(sp)
    80004168:	7c02                	ld	s8,32(sp)
    8000416a:	6ce2                	ld	s9,24(sp)
    8000416c:	6165                	addi	sp,sp,112
    8000416e:	8082                	ret
      wakeup(&pi->nread);
    80004170:	8566                	mv	a0,s9
    80004172:	ffffe097          	auipc	ra,0xffffe
    80004176:	81c080e7          	jalr	-2020(ra) # 8000198e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000417a:	85de                	mv	a1,s7
    8000417c:	8562                	mv	a0,s8
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	684080e7          	jalr	1668(ra) # 80001802 <sleep>
    80004186:	a839                	j	800041a4 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004188:	21c4a783          	lw	a5,540(s1)
    8000418c:	0017871b          	addiw	a4,a5,1
    80004190:	20e4ae23          	sw	a4,540(s1)
    80004194:	1ff7f793          	andi	a5,a5,511
    80004198:	97a6                	add	a5,a5,s1
    8000419a:	f9f44703          	lbu	a4,-97(s0)
    8000419e:	00e78c23          	sb	a4,24(a5)
      i++;
    800041a2:	2905                	addiw	s2,s2,1
  while(i < n){
    800041a4:	03495d63          	bge	s2,s4,800041de <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800041a8:	2204a783          	lw	a5,544(s1)
    800041ac:	dfd1                	beqz	a5,80004148 <pipewrite+0x48>
    800041ae:	0289a783          	lw	a5,40(s3)
    800041b2:	fbd9                	bnez	a5,80004148 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041b4:	2184a783          	lw	a5,536(s1)
    800041b8:	21c4a703          	lw	a4,540(s1)
    800041bc:	2007879b          	addiw	a5,a5,512
    800041c0:	faf708e3          	beq	a4,a5,80004170 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041c4:	4685                	li	a3,1
    800041c6:	01590633          	add	a2,s2,s5
    800041ca:	f9f40593          	addi	a1,s0,-97
    800041ce:	0509b503          	ld	a0,80(s3)
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	b20080e7          	jalr	-1248(ra) # 80000cf2 <copyin>
    800041da:	fb6517e3          	bne	a0,s6,80004188 <pipewrite+0x88>
  wakeup(&pi->nread);
    800041de:	21848513          	addi	a0,s1,536
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	7ac080e7          	jalr	1964(ra) # 8000198e <wakeup>
  release(&pi->lock);
    800041ea:	8526                	mv	a0,s1
    800041ec:	00002097          	auipc	ra,0x2
    800041f0:	2aa080e7          	jalr	682(ra) # 80006496 <release>
  return i;
    800041f4:	b785                	j	80004154 <pipewrite+0x54>
  int i = 0;
    800041f6:	4901                	li	s2,0
    800041f8:	b7dd                	j	800041de <pipewrite+0xde>

00000000800041fa <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041fa:	715d                	addi	sp,sp,-80
    800041fc:	e486                	sd	ra,72(sp)
    800041fe:	e0a2                	sd	s0,64(sp)
    80004200:	fc26                	sd	s1,56(sp)
    80004202:	f84a                	sd	s2,48(sp)
    80004204:	f44e                	sd	s3,40(sp)
    80004206:	f052                	sd	s4,32(sp)
    80004208:	ec56                	sd	s5,24(sp)
    8000420a:	e85a                	sd	s6,16(sp)
    8000420c:	0880                	addi	s0,sp,80
    8000420e:	84aa                	mv	s1,a0
    80004210:	892e                	mv	s2,a1
    80004212:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004214:	ffffd097          	auipc	ra,0xffffd
    80004218:	f32080e7          	jalr	-206(ra) # 80001146 <myproc>
    8000421c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000421e:	8b26                	mv	s6,s1
    80004220:	8526                	mv	a0,s1
    80004222:	00002097          	auipc	ra,0x2
    80004226:	1c0080e7          	jalr	448(ra) # 800063e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000422a:	2184a703          	lw	a4,536(s1)
    8000422e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004232:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004236:	02f71463          	bne	a4,a5,8000425e <piperead+0x64>
    8000423a:	2244a783          	lw	a5,548(s1)
    8000423e:	c385                	beqz	a5,8000425e <piperead+0x64>
    if(pr->killed){
    80004240:	028a2783          	lw	a5,40(s4)
    80004244:	ebc1                	bnez	a5,800042d4 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004246:	85da                	mv	a1,s6
    80004248:	854e                	mv	a0,s3
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	5b8080e7          	jalr	1464(ra) # 80001802 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004252:	2184a703          	lw	a4,536(s1)
    80004256:	21c4a783          	lw	a5,540(s1)
    8000425a:	fef700e3          	beq	a4,a5,8000423a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000425e:	09505263          	blez	s5,800042e2 <piperead+0xe8>
    80004262:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004264:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004266:	2184a783          	lw	a5,536(s1)
    8000426a:	21c4a703          	lw	a4,540(s1)
    8000426e:	02f70d63          	beq	a4,a5,800042a8 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004272:	0017871b          	addiw	a4,a5,1
    80004276:	20e4ac23          	sw	a4,536(s1)
    8000427a:	1ff7f793          	andi	a5,a5,511
    8000427e:	97a6                	add	a5,a5,s1
    80004280:	0187c783          	lbu	a5,24(a5)
    80004284:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004288:	4685                	li	a3,1
    8000428a:	fbf40613          	addi	a2,s0,-65
    8000428e:	85ca                	mv	a1,s2
    80004290:	050a3503          	ld	a0,80(s4)
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	c82080e7          	jalr	-894(ra) # 80000f16 <copyout>
    8000429c:	01650663          	beq	a0,s6,800042a8 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a0:	2985                	addiw	s3,s3,1
    800042a2:	0905                	addi	s2,s2,1
    800042a4:	fd3a91e3          	bne	s5,s3,80004266 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042a8:	21c48513          	addi	a0,s1,540
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	6e2080e7          	jalr	1762(ra) # 8000198e <wakeup>
  release(&pi->lock);
    800042b4:	8526                	mv	a0,s1
    800042b6:	00002097          	auipc	ra,0x2
    800042ba:	1e0080e7          	jalr	480(ra) # 80006496 <release>
  return i;
}
    800042be:	854e                	mv	a0,s3
    800042c0:	60a6                	ld	ra,72(sp)
    800042c2:	6406                	ld	s0,64(sp)
    800042c4:	74e2                	ld	s1,56(sp)
    800042c6:	7942                	ld	s2,48(sp)
    800042c8:	79a2                	ld	s3,40(sp)
    800042ca:	7a02                	ld	s4,32(sp)
    800042cc:	6ae2                	ld	s5,24(sp)
    800042ce:	6b42                	ld	s6,16(sp)
    800042d0:	6161                	addi	sp,sp,80
    800042d2:	8082                	ret
      release(&pi->lock);
    800042d4:	8526                	mv	a0,s1
    800042d6:	00002097          	auipc	ra,0x2
    800042da:	1c0080e7          	jalr	448(ra) # 80006496 <release>
      return -1;
    800042de:	59fd                	li	s3,-1
    800042e0:	bff9                	j	800042be <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042e2:	4981                	li	s3,0
    800042e4:	b7d1                	j	800042a8 <piperead+0xae>

00000000800042e6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042e6:	df010113          	addi	sp,sp,-528
    800042ea:	20113423          	sd	ra,520(sp)
    800042ee:	20813023          	sd	s0,512(sp)
    800042f2:	ffa6                	sd	s1,504(sp)
    800042f4:	fbca                	sd	s2,496(sp)
    800042f6:	f7ce                	sd	s3,488(sp)
    800042f8:	f3d2                	sd	s4,480(sp)
    800042fa:	efd6                	sd	s5,472(sp)
    800042fc:	ebda                	sd	s6,464(sp)
    800042fe:	e7de                	sd	s7,456(sp)
    80004300:	e3e2                	sd	s8,448(sp)
    80004302:	ff66                	sd	s9,440(sp)
    80004304:	fb6a                	sd	s10,432(sp)
    80004306:	f76e                	sd	s11,424(sp)
    80004308:	0c00                	addi	s0,sp,528
    8000430a:	84aa                	mv	s1,a0
    8000430c:	dea43c23          	sd	a0,-520(s0)
    80004310:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004314:	ffffd097          	auipc	ra,0xffffd
    80004318:	e32080e7          	jalr	-462(ra) # 80001146 <myproc>
    8000431c:	892a                	mv	s2,a0

  begin_op();
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	49c080e7          	jalr	1180(ra) # 800037ba <begin_op>

  if((ip = namei(path)) == 0){
    80004326:	8526                	mv	a0,s1
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	276080e7          	jalr	630(ra) # 8000359e <namei>
    80004330:	c92d                	beqz	a0,800043a2 <exec+0xbc>
    80004332:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	ab4080e7          	jalr	-1356(ra) # 80002de8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000433c:	04000713          	li	a4,64
    80004340:	4681                	li	a3,0
    80004342:	e5040613          	addi	a2,s0,-432
    80004346:	4581                	li	a1,0
    80004348:	8526                	mv	a0,s1
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	d52080e7          	jalr	-686(ra) # 8000309c <readi>
    80004352:	04000793          	li	a5,64
    80004356:	00f51a63          	bne	a0,a5,8000436a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000435a:	e5042703          	lw	a4,-432(s0)
    8000435e:	464c47b7          	lui	a5,0x464c4
    80004362:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004366:	04f70463          	beq	a4,a5,800043ae <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000436a:	8526                	mv	a0,s1
    8000436c:	fffff097          	auipc	ra,0xfffff
    80004370:	cde080e7          	jalr	-802(ra) # 8000304a <iunlockput>
    end_op();
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	4c6080e7          	jalr	1222(ra) # 8000383a <end_op>
  }
  return -1;
    8000437c:	557d                	li	a0,-1
}
    8000437e:	20813083          	ld	ra,520(sp)
    80004382:	20013403          	ld	s0,512(sp)
    80004386:	74fe                	ld	s1,504(sp)
    80004388:	795e                	ld	s2,496(sp)
    8000438a:	79be                	ld	s3,488(sp)
    8000438c:	7a1e                	ld	s4,480(sp)
    8000438e:	6afe                	ld	s5,472(sp)
    80004390:	6b5e                	ld	s6,464(sp)
    80004392:	6bbe                	ld	s7,456(sp)
    80004394:	6c1e                	ld	s8,448(sp)
    80004396:	7cfa                	ld	s9,440(sp)
    80004398:	7d5a                	ld	s10,432(sp)
    8000439a:	7dba                	ld	s11,424(sp)
    8000439c:	21010113          	addi	sp,sp,528
    800043a0:	8082                	ret
    end_op();
    800043a2:	fffff097          	auipc	ra,0xfffff
    800043a6:	498080e7          	jalr	1176(ra) # 8000383a <end_op>
    return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	bfc9                	j	8000437e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043ae:	854a                	mv	a0,s2
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	e5a080e7          	jalr	-422(ra) # 8000120a <proc_pagetable>
    800043b8:	8baa                	mv	s7,a0
    800043ba:	d945                	beqz	a0,8000436a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043bc:	e7042983          	lw	s3,-400(s0)
    800043c0:	e8845783          	lhu	a5,-376(s0)
    800043c4:	c7ad                	beqz	a5,8000442e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043c6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c8:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800043ca:	6c85                	lui	s9,0x1
    800043cc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043d0:	def43823          	sd	a5,-528(s0)
    800043d4:	a42d                	j	800045fe <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043d6:	00004517          	auipc	a0,0x4
    800043da:	2ca50513          	addi	a0,a0,714 # 800086a0 <syscalls+0x280>
    800043de:	00002097          	auipc	ra,0x2
    800043e2:	aba080e7          	jalr	-1350(ra) # 80005e98 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043e6:	8756                	mv	a4,s5
    800043e8:	012d86bb          	addw	a3,s11,s2
    800043ec:	4581                	li	a1,0
    800043ee:	8526                	mv	a0,s1
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	cac080e7          	jalr	-852(ra) # 8000309c <readi>
    800043f8:	2501                	sext.w	a0,a0
    800043fa:	1aaa9963          	bne	s5,a0,800045ac <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800043fe:	6785                	lui	a5,0x1
    80004400:	0127893b          	addw	s2,a5,s2
    80004404:	77fd                	lui	a5,0xfffff
    80004406:	01478a3b          	addw	s4,a5,s4
    8000440a:	1f897163          	bgeu	s2,s8,800045ec <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000440e:	02091593          	slli	a1,s2,0x20
    80004412:	9181                	srli	a1,a1,0x20
    80004414:	95ea                	add	a1,a1,s10
    80004416:	855e                	mv	a0,s7
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	2ea080e7          	jalr	746(ra) # 80000702 <walkaddr>
    80004420:	862a                	mv	a2,a0
    if(pa == 0)
    80004422:	d955                	beqz	a0,800043d6 <exec+0xf0>
      n = PGSIZE;
    80004424:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004426:	fd9a70e3          	bgeu	s4,s9,800043e6 <exec+0x100>
      n = sz - i;
    8000442a:	8ad2                	mv	s5,s4
    8000442c:	bf6d                	j	800043e6 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000442e:	4901                	li	s2,0
  iunlockput(ip);
    80004430:	8526                	mv	a0,s1
    80004432:	fffff097          	auipc	ra,0xfffff
    80004436:	c18080e7          	jalr	-1000(ra) # 8000304a <iunlockput>
  end_op();
    8000443a:	fffff097          	auipc	ra,0xfffff
    8000443e:	400080e7          	jalr	1024(ra) # 8000383a <end_op>
  p = myproc();
    80004442:	ffffd097          	auipc	ra,0xffffd
    80004446:	d04080e7          	jalr	-764(ra) # 80001146 <myproc>
    8000444a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000444c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004450:	6785                	lui	a5,0x1
    80004452:	17fd                	addi	a5,a5,-1
    80004454:	993e                	add	s2,s2,a5
    80004456:	757d                	lui	a0,0xfffff
    80004458:	00a977b3          	and	a5,s2,a0
    8000445c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004460:	6609                	lui	a2,0x2
    80004462:	963e                	add	a2,a2,a5
    80004464:	85be                	mv	a1,a5
    80004466:	855e                	mv	a0,s7
    80004468:	ffffc097          	auipc	ra,0xffffc
    8000446c:	64e080e7          	jalr	1614(ra) # 80000ab6 <uvmalloc>
    80004470:	8b2a                	mv	s6,a0
  ip = 0;
    80004472:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004474:	12050c63          	beqz	a0,800045ac <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004478:	75f9                	lui	a1,0xffffe
    8000447a:	95aa                	add	a1,a1,a0
    8000447c:	855e                	mv	a0,s7
    8000447e:	ffffd097          	auipc	ra,0xffffd
    80004482:	842080e7          	jalr	-1982(ra) # 80000cc0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004486:	7c7d                	lui	s8,0xfffff
    80004488:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000448a:	e0043783          	ld	a5,-512(s0)
    8000448e:	6388                	ld	a0,0(a5)
    80004490:	c535                	beqz	a0,800044fc <exec+0x216>
    80004492:	e9040993          	addi	s3,s0,-368
    80004496:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000449a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	05c080e7          	jalr	92(ra) # 800004f8 <strlen>
    800044a4:	2505                	addiw	a0,a0,1
    800044a6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044aa:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800044ae:	13896363          	bltu	s2,s8,800045d4 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044b2:	e0043d83          	ld	s11,-512(s0)
    800044b6:	000dba03          	ld	s4,0(s11)
    800044ba:	8552                	mv	a0,s4
    800044bc:	ffffc097          	auipc	ra,0xffffc
    800044c0:	03c080e7          	jalr	60(ra) # 800004f8 <strlen>
    800044c4:	0015069b          	addiw	a3,a0,1
    800044c8:	8652                	mv	a2,s4
    800044ca:	85ca                	mv	a1,s2
    800044cc:	855e                	mv	a0,s7
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	a48080e7          	jalr	-1464(ra) # 80000f16 <copyout>
    800044d6:	10054363          	bltz	a0,800045dc <exec+0x2f6>
    ustack[argc] = sp;
    800044da:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044de:	0485                	addi	s1,s1,1
    800044e0:	008d8793          	addi	a5,s11,8
    800044e4:	e0f43023          	sd	a5,-512(s0)
    800044e8:	008db503          	ld	a0,8(s11)
    800044ec:	c911                	beqz	a0,80004500 <exec+0x21a>
    if(argc >= MAXARG)
    800044ee:	09a1                	addi	s3,s3,8
    800044f0:	fb3c96e3          	bne	s9,s3,8000449c <exec+0x1b6>
  sz = sz1;
    800044f4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044f8:	4481                	li	s1,0
    800044fa:	a84d                	j	800045ac <exec+0x2c6>
  sp = sz;
    800044fc:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044fe:	4481                	li	s1,0
  ustack[argc] = 0;
    80004500:	00349793          	slli	a5,s1,0x3
    80004504:	f9040713          	addi	a4,s0,-112
    80004508:	97ba                	add	a5,a5,a4
    8000450a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000450e:	00148693          	addi	a3,s1,1
    80004512:	068e                	slli	a3,a3,0x3
    80004514:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004518:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000451c:	01897663          	bgeu	s2,s8,80004528 <exec+0x242>
  sz = sz1;
    80004520:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004524:	4481                	li	s1,0
    80004526:	a059                	j	800045ac <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004528:	e9040613          	addi	a2,s0,-368
    8000452c:	85ca                	mv	a1,s2
    8000452e:	855e                	mv	a0,s7
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	9e6080e7          	jalr	-1562(ra) # 80000f16 <copyout>
    80004538:	0a054663          	bltz	a0,800045e4 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000453c:	058ab783          	ld	a5,88(s5)
    80004540:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004544:	df843783          	ld	a5,-520(s0)
    80004548:	0007c703          	lbu	a4,0(a5)
    8000454c:	cf11                	beqz	a4,80004568 <exec+0x282>
    8000454e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004550:	02f00693          	li	a3,47
    80004554:	a039                	j	80004562 <exec+0x27c>
      last = s+1;
    80004556:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000455a:	0785                	addi	a5,a5,1
    8000455c:	fff7c703          	lbu	a4,-1(a5)
    80004560:	c701                	beqz	a4,80004568 <exec+0x282>
    if(*s == '/')
    80004562:	fed71ce3          	bne	a4,a3,8000455a <exec+0x274>
    80004566:	bfc5                	j	80004556 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004568:	4641                	li	a2,16
    8000456a:	df843583          	ld	a1,-520(s0)
    8000456e:	158a8513          	addi	a0,s5,344
    80004572:	ffffc097          	auipc	ra,0xffffc
    80004576:	f54080e7          	jalr	-172(ra) # 800004c6 <safestrcpy>
  oldpagetable = p->pagetable;
    8000457a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000457e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004582:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004586:	058ab783          	ld	a5,88(s5)
    8000458a:	e6843703          	ld	a4,-408(s0)
    8000458e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004590:	058ab783          	ld	a5,88(s5)
    80004594:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004598:	85ea                	mv	a1,s10
    8000459a:	ffffd097          	auipc	ra,0xffffd
    8000459e:	d0c080e7          	jalr	-756(ra) # 800012a6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a2:	0004851b          	sext.w	a0,s1
    800045a6:	bbe1                	j	8000437e <exec+0x98>
    800045a8:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045ac:	e0843583          	ld	a1,-504(s0)
    800045b0:	855e                	mv	a0,s7
    800045b2:	ffffd097          	auipc	ra,0xffffd
    800045b6:	cf4080e7          	jalr	-780(ra) # 800012a6 <proc_freepagetable>
  if(ip){
    800045ba:	da0498e3          	bnez	s1,8000436a <exec+0x84>
  return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	bb7d                	j	8000437e <exec+0x98>
    800045c2:	e1243423          	sd	s2,-504(s0)
    800045c6:	b7dd                	j	800045ac <exec+0x2c6>
    800045c8:	e1243423          	sd	s2,-504(s0)
    800045cc:	b7c5                	j	800045ac <exec+0x2c6>
    800045ce:	e1243423          	sd	s2,-504(s0)
    800045d2:	bfe9                	j	800045ac <exec+0x2c6>
  sz = sz1;
    800045d4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045d8:	4481                	li	s1,0
    800045da:	bfc9                	j	800045ac <exec+0x2c6>
  sz = sz1;
    800045dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045e0:	4481                	li	s1,0
    800045e2:	b7e9                	j	800045ac <exec+0x2c6>
  sz = sz1;
    800045e4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045e8:	4481                	li	s1,0
    800045ea:	b7c9                	j	800045ac <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045ec:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045f0:	2b05                	addiw	s6,s6,1
    800045f2:	0389899b          	addiw	s3,s3,56
    800045f6:	e8845783          	lhu	a5,-376(s0)
    800045fa:	e2fb5be3          	bge	s6,a5,80004430 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045fe:	2981                	sext.w	s3,s3
    80004600:	03800713          	li	a4,56
    80004604:	86ce                	mv	a3,s3
    80004606:	e1840613          	addi	a2,s0,-488
    8000460a:	4581                	li	a1,0
    8000460c:	8526                	mv	a0,s1
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	a8e080e7          	jalr	-1394(ra) # 8000309c <readi>
    80004616:	03800793          	li	a5,56
    8000461a:	f8f517e3          	bne	a0,a5,800045a8 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000461e:	e1842783          	lw	a5,-488(s0)
    80004622:	4705                	li	a4,1
    80004624:	fce796e3          	bne	a5,a4,800045f0 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004628:	e4043603          	ld	a2,-448(s0)
    8000462c:	e3843783          	ld	a5,-456(s0)
    80004630:	f8f669e3          	bltu	a2,a5,800045c2 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004634:	e2843783          	ld	a5,-472(s0)
    80004638:	963e                	add	a2,a2,a5
    8000463a:	f8f667e3          	bltu	a2,a5,800045c8 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000463e:	85ca                	mv	a1,s2
    80004640:	855e                	mv	a0,s7
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	474080e7          	jalr	1140(ra) # 80000ab6 <uvmalloc>
    8000464a:	e0a43423          	sd	a0,-504(s0)
    8000464e:	d141                	beqz	a0,800045ce <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004650:	e2843d03          	ld	s10,-472(s0)
    80004654:	df043783          	ld	a5,-528(s0)
    80004658:	00fd77b3          	and	a5,s10,a5
    8000465c:	fba1                	bnez	a5,800045ac <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000465e:	e2042d83          	lw	s11,-480(s0)
    80004662:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004666:	f80c03e3          	beqz	s8,800045ec <exec+0x306>
    8000466a:	8a62                	mv	s4,s8
    8000466c:	4901                	li	s2,0
    8000466e:	b345                	j	8000440e <exec+0x128>

0000000080004670 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004670:	7179                	addi	sp,sp,-48
    80004672:	f406                	sd	ra,40(sp)
    80004674:	f022                	sd	s0,32(sp)
    80004676:	ec26                	sd	s1,24(sp)
    80004678:	e84a                	sd	s2,16(sp)
    8000467a:	1800                	addi	s0,sp,48
    8000467c:	892e                	mv	s2,a1
    8000467e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004680:	fdc40593          	addi	a1,s0,-36
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	bf2080e7          	jalr	-1038(ra) # 80002276 <argint>
    8000468c:	04054063          	bltz	a0,800046cc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004690:	fdc42703          	lw	a4,-36(s0)
    80004694:	47bd                	li	a5,15
    80004696:	02e7ed63          	bltu	a5,a4,800046d0 <argfd+0x60>
    8000469a:	ffffd097          	auipc	ra,0xffffd
    8000469e:	aac080e7          	jalr	-1364(ra) # 80001146 <myproc>
    800046a2:	fdc42703          	lw	a4,-36(s0)
    800046a6:	01a70793          	addi	a5,a4,26
    800046aa:	078e                	slli	a5,a5,0x3
    800046ac:	953e                	add	a0,a0,a5
    800046ae:	611c                	ld	a5,0(a0)
    800046b0:	c395                	beqz	a5,800046d4 <argfd+0x64>
    return -1;
  if(pfd)
    800046b2:	00090463          	beqz	s2,800046ba <argfd+0x4a>
    *pfd = fd;
    800046b6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046ba:	4501                	li	a0,0
  if(pf)
    800046bc:	c091                	beqz	s1,800046c0 <argfd+0x50>
    *pf = f;
    800046be:	e09c                	sd	a5,0(s1)
}
    800046c0:	70a2                	ld	ra,40(sp)
    800046c2:	7402                	ld	s0,32(sp)
    800046c4:	64e2                	ld	s1,24(sp)
    800046c6:	6942                	ld	s2,16(sp)
    800046c8:	6145                	addi	sp,sp,48
    800046ca:	8082                	ret
    return -1;
    800046cc:	557d                	li	a0,-1
    800046ce:	bfcd                	j	800046c0 <argfd+0x50>
    return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	b7fd                	j	800046c0 <argfd+0x50>
    800046d4:	557d                	li	a0,-1
    800046d6:	b7ed                	j	800046c0 <argfd+0x50>

00000000800046d8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046d8:	1101                	addi	sp,sp,-32
    800046da:	ec06                	sd	ra,24(sp)
    800046dc:	e822                	sd	s0,16(sp)
    800046de:	e426                	sd	s1,8(sp)
    800046e0:	1000                	addi	s0,sp,32
    800046e2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046e4:	ffffd097          	auipc	ra,0xffffd
    800046e8:	a62080e7          	jalr	-1438(ra) # 80001146 <myproc>
    800046ec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046ee:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800046f2:	4501                	li	a0,0
    800046f4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046f6:	6398                	ld	a4,0(a5)
    800046f8:	cb19                	beqz	a4,8000470e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046fa:	2505                	addiw	a0,a0,1
    800046fc:	07a1                	addi	a5,a5,8
    800046fe:	fed51ce3          	bne	a0,a3,800046f6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004702:	557d                	li	a0,-1
}
    80004704:	60e2                	ld	ra,24(sp)
    80004706:	6442                	ld	s0,16(sp)
    80004708:	64a2                	ld	s1,8(sp)
    8000470a:	6105                	addi	sp,sp,32
    8000470c:	8082                	ret
      p->ofile[fd] = f;
    8000470e:	01a50793          	addi	a5,a0,26
    80004712:	078e                	slli	a5,a5,0x3
    80004714:	963e                	add	a2,a2,a5
    80004716:	e204                	sd	s1,0(a2)
      return fd;
    80004718:	b7f5                	j	80004704 <fdalloc+0x2c>

000000008000471a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000471a:	715d                	addi	sp,sp,-80
    8000471c:	e486                	sd	ra,72(sp)
    8000471e:	e0a2                	sd	s0,64(sp)
    80004720:	fc26                	sd	s1,56(sp)
    80004722:	f84a                	sd	s2,48(sp)
    80004724:	f44e                	sd	s3,40(sp)
    80004726:	f052                	sd	s4,32(sp)
    80004728:	ec56                	sd	s5,24(sp)
    8000472a:	0880                	addi	s0,sp,80
    8000472c:	89ae                	mv	s3,a1
    8000472e:	8ab2                	mv	s5,a2
    80004730:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004732:	fb040593          	addi	a1,s0,-80
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	e86080e7          	jalr	-378(ra) # 800035bc <nameiparent>
    8000473e:	892a                	mv	s2,a0
    80004740:	12050f63          	beqz	a0,8000487e <create+0x164>
    return 0;

  ilock(dp);
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	6a4080e7          	jalr	1700(ra) # 80002de8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000474c:	4601                	li	a2,0
    8000474e:	fb040593          	addi	a1,s0,-80
    80004752:	854a                	mv	a0,s2
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	b78080e7          	jalr	-1160(ra) # 800032cc <dirlookup>
    8000475c:	84aa                	mv	s1,a0
    8000475e:	c921                	beqz	a0,800047ae <create+0x94>
    iunlockput(dp);
    80004760:	854a                	mv	a0,s2
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	8e8080e7          	jalr	-1816(ra) # 8000304a <iunlockput>
    ilock(ip);
    8000476a:	8526                	mv	a0,s1
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	67c080e7          	jalr	1660(ra) # 80002de8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004774:	2981                	sext.w	s3,s3
    80004776:	4789                	li	a5,2
    80004778:	02f99463          	bne	s3,a5,800047a0 <create+0x86>
    8000477c:	0444d783          	lhu	a5,68(s1)
    80004780:	37f9                	addiw	a5,a5,-2
    80004782:	17c2                	slli	a5,a5,0x30
    80004784:	93c1                	srli	a5,a5,0x30
    80004786:	4705                	li	a4,1
    80004788:	00f76c63          	bltu	a4,a5,800047a0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000478c:	8526                	mv	a0,s1
    8000478e:	60a6                	ld	ra,72(sp)
    80004790:	6406                	ld	s0,64(sp)
    80004792:	74e2                	ld	s1,56(sp)
    80004794:	7942                	ld	s2,48(sp)
    80004796:	79a2                	ld	s3,40(sp)
    80004798:	7a02                	ld	s4,32(sp)
    8000479a:	6ae2                	ld	s5,24(sp)
    8000479c:	6161                	addi	sp,sp,80
    8000479e:	8082                	ret
    iunlockput(ip);
    800047a0:	8526                	mv	a0,s1
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	8a8080e7          	jalr	-1880(ra) # 8000304a <iunlockput>
    return 0;
    800047aa:	4481                	li	s1,0
    800047ac:	b7c5                	j	8000478c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047ae:	85ce                	mv	a1,s3
    800047b0:	00092503          	lw	a0,0(s2)
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	49c080e7          	jalr	1180(ra) # 80002c50 <ialloc>
    800047bc:	84aa                	mv	s1,a0
    800047be:	c529                	beqz	a0,80004808 <create+0xee>
  ilock(ip);
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	628080e7          	jalr	1576(ra) # 80002de8 <ilock>
  ip->major = major;
    800047c8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800047cc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800047d0:	4785                	li	a5,1
    800047d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	546080e7          	jalr	1350(ra) # 80002d1e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047e0:	2981                	sext.w	s3,s3
    800047e2:	4785                	li	a5,1
    800047e4:	02f98a63          	beq	s3,a5,80004818 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047e8:	40d0                	lw	a2,4(s1)
    800047ea:	fb040593          	addi	a1,s0,-80
    800047ee:	854a                	mv	a0,s2
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	cec080e7          	jalr	-788(ra) # 800034dc <dirlink>
    800047f8:	06054b63          	bltz	a0,8000486e <create+0x154>
  iunlockput(dp);
    800047fc:	854a                	mv	a0,s2
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	84c080e7          	jalr	-1972(ra) # 8000304a <iunlockput>
  return ip;
    80004806:	b759                	j	8000478c <create+0x72>
    panic("create: ialloc");
    80004808:	00004517          	auipc	a0,0x4
    8000480c:	eb850513          	addi	a0,a0,-328 # 800086c0 <syscalls+0x2a0>
    80004810:	00001097          	auipc	ra,0x1
    80004814:	688080e7          	jalr	1672(ra) # 80005e98 <panic>
    dp->nlink++;  // for ".."
    80004818:	04a95783          	lhu	a5,74(s2)
    8000481c:	2785                	addiw	a5,a5,1
    8000481e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004822:	854a                	mv	a0,s2
    80004824:	ffffe097          	auipc	ra,0xffffe
    80004828:	4fa080e7          	jalr	1274(ra) # 80002d1e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000482c:	40d0                	lw	a2,4(s1)
    8000482e:	00004597          	auipc	a1,0x4
    80004832:	ea258593          	addi	a1,a1,-350 # 800086d0 <syscalls+0x2b0>
    80004836:	8526                	mv	a0,s1
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	ca4080e7          	jalr	-860(ra) # 800034dc <dirlink>
    80004840:	00054f63          	bltz	a0,8000485e <create+0x144>
    80004844:	00492603          	lw	a2,4(s2)
    80004848:	00004597          	auipc	a1,0x4
    8000484c:	e9058593          	addi	a1,a1,-368 # 800086d8 <syscalls+0x2b8>
    80004850:	8526                	mv	a0,s1
    80004852:	fffff097          	auipc	ra,0xfffff
    80004856:	c8a080e7          	jalr	-886(ra) # 800034dc <dirlink>
    8000485a:	f80557e3          	bgez	a0,800047e8 <create+0xce>
      panic("create dots");
    8000485e:	00004517          	auipc	a0,0x4
    80004862:	e8250513          	addi	a0,a0,-382 # 800086e0 <syscalls+0x2c0>
    80004866:	00001097          	auipc	ra,0x1
    8000486a:	632080e7          	jalr	1586(ra) # 80005e98 <panic>
    panic("create: dirlink");
    8000486e:	00004517          	auipc	a0,0x4
    80004872:	e8250513          	addi	a0,a0,-382 # 800086f0 <syscalls+0x2d0>
    80004876:	00001097          	auipc	ra,0x1
    8000487a:	622080e7          	jalr	1570(ra) # 80005e98 <panic>
    return 0;
    8000487e:	84aa                	mv	s1,a0
    80004880:	b731                	j	8000478c <create+0x72>

0000000080004882 <sys_dup>:
{
    80004882:	7179                	addi	sp,sp,-48
    80004884:	f406                	sd	ra,40(sp)
    80004886:	f022                	sd	s0,32(sp)
    80004888:	ec26                	sd	s1,24(sp)
    8000488a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000488c:	fd840613          	addi	a2,s0,-40
    80004890:	4581                	li	a1,0
    80004892:	4501                	li	a0,0
    80004894:	00000097          	auipc	ra,0x0
    80004898:	ddc080e7          	jalr	-548(ra) # 80004670 <argfd>
    return -1;
    8000489c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000489e:	02054363          	bltz	a0,800048c4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048a2:	fd843503          	ld	a0,-40(s0)
    800048a6:	00000097          	auipc	ra,0x0
    800048aa:	e32080e7          	jalr	-462(ra) # 800046d8 <fdalloc>
    800048ae:	84aa                	mv	s1,a0
    return -1;
    800048b0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048b2:	00054963          	bltz	a0,800048c4 <sys_dup+0x42>
  filedup(f);
    800048b6:	fd843503          	ld	a0,-40(s0)
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	37a080e7          	jalr	890(ra) # 80003c34 <filedup>
  return fd;
    800048c2:	87a6                	mv	a5,s1
}
    800048c4:	853e                	mv	a0,a5
    800048c6:	70a2                	ld	ra,40(sp)
    800048c8:	7402                	ld	s0,32(sp)
    800048ca:	64e2                	ld	s1,24(sp)
    800048cc:	6145                	addi	sp,sp,48
    800048ce:	8082                	ret

00000000800048d0 <sys_read>:
{
    800048d0:	7179                	addi	sp,sp,-48
    800048d2:	f406                	sd	ra,40(sp)
    800048d4:	f022                	sd	s0,32(sp)
    800048d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d8:	fe840613          	addi	a2,s0,-24
    800048dc:	4581                	li	a1,0
    800048de:	4501                	li	a0,0
    800048e0:	00000097          	auipc	ra,0x0
    800048e4:	d90080e7          	jalr	-624(ra) # 80004670 <argfd>
    return -1;
    800048e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ea:	04054163          	bltz	a0,8000492c <sys_read+0x5c>
    800048ee:	fe440593          	addi	a1,s0,-28
    800048f2:	4509                	li	a0,2
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	982080e7          	jalr	-1662(ra) # 80002276 <argint>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fe:	02054763          	bltz	a0,8000492c <sys_read+0x5c>
    80004902:	fd840593          	addi	a1,s0,-40
    80004906:	4505                	li	a0,1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	990080e7          	jalr	-1648(ra) # 80002298 <argaddr>
    return -1;
    80004910:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004912:	00054d63          	bltz	a0,8000492c <sys_read+0x5c>
  return fileread(f, p, n);
    80004916:	fe442603          	lw	a2,-28(s0)
    8000491a:	fd843583          	ld	a1,-40(s0)
    8000491e:	fe843503          	ld	a0,-24(s0)
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	49e080e7          	jalr	1182(ra) # 80003dc0 <fileread>
    8000492a:	87aa                	mv	a5,a0
}
    8000492c:	853e                	mv	a0,a5
    8000492e:	70a2                	ld	ra,40(sp)
    80004930:	7402                	ld	s0,32(sp)
    80004932:	6145                	addi	sp,sp,48
    80004934:	8082                	ret

0000000080004936 <sys_write>:
{
    80004936:	7179                	addi	sp,sp,-48
    80004938:	f406                	sd	ra,40(sp)
    8000493a:	f022                	sd	s0,32(sp)
    8000493c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493e:	fe840613          	addi	a2,s0,-24
    80004942:	4581                	li	a1,0
    80004944:	4501                	li	a0,0
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	d2a080e7          	jalr	-726(ra) # 80004670 <argfd>
    return -1;
    8000494e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004950:	04054163          	bltz	a0,80004992 <sys_write+0x5c>
    80004954:	fe440593          	addi	a1,s0,-28
    80004958:	4509                	li	a0,2
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	91c080e7          	jalr	-1764(ra) # 80002276 <argint>
    return -1;
    80004962:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004964:	02054763          	bltz	a0,80004992 <sys_write+0x5c>
    80004968:	fd840593          	addi	a1,s0,-40
    8000496c:	4505                	li	a0,1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	92a080e7          	jalr	-1750(ra) # 80002298 <argaddr>
    return -1;
    80004976:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004978:	00054d63          	bltz	a0,80004992 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000497c:	fe442603          	lw	a2,-28(s0)
    80004980:	fd843583          	ld	a1,-40(s0)
    80004984:	fe843503          	ld	a0,-24(s0)
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	4fa080e7          	jalr	1274(ra) # 80003e82 <filewrite>
    80004990:	87aa                	mv	a5,a0
}
    80004992:	853e                	mv	a0,a5
    80004994:	70a2                	ld	ra,40(sp)
    80004996:	7402                	ld	s0,32(sp)
    80004998:	6145                	addi	sp,sp,48
    8000499a:	8082                	ret

000000008000499c <sys_close>:
{
    8000499c:	1101                	addi	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049a4:	fe040613          	addi	a2,s0,-32
    800049a8:	fec40593          	addi	a1,s0,-20
    800049ac:	4501                	li	a0,0
    800049ae:	00000097          	auipc	ra,0x0
    800049b2:	cc2080e7          	jalr	-830(ra) # 80004670 <argfd>
    return -1;
    800049b6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049b8:	02054463          	bltz	a0,800049e0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049bc:	ffffc097          	auipc	ra,0xffffc
    800049c0:	78a080e7          	jalr	1930(ra) # 80001146 <myproc>
    800049c4:	fec42783          	lw	a5,-20(s0)
    800049c8:	07e9                	addi	a5,a5,26
    800049ca:	078e                	slli	a5,a5,0x3
    800049cc:	97aa                	add	a5,a5,a0
    800049ce:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800049d2:	fe043503          	ld	a0,-32(s0)
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	2b0080e7          	jalr	688(ra) # 80003c86 <fileclose>
  return 0;
    800049de:	4781                	li	a5,0
}
    800049e0:	853e                	mv	a0,a5
    800049e2:	60e2                	ld	ra,24(sp)
    800049e4:	6442                	ld	s0,16(sp)
    800049e6:	6105                	addi	sp,sp,32
    800049e8:	8082                	ret

00000000800049ea <sys_fstat>:
{
    800049ea:	1101                	addi	sp,sp,-32
    800049ec:	ec06                	sd	ra,24(sp)
    800049ee:	e822                	sd	s0,16(sp)
    800049f0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049f2:	fe840613          	addi	a2,s0,-24
    800049f6:	4581                	li	a1,0
    800049f8:	4501                	li	a0,0
    800049fa:	00000097          	auipc	ra,0x0
    800049fe:	c76080e7          	jalr	-906(ra) # 80004670 <argfd>
    return -1;
    80004a02:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a04:	02054563          	bltz	a0,80004a2e <sys_fstat+0x44>
    80004a08:	fe040593          	addi	a1,s0,-32
    80004a0c:	4505                	li	a0,1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	88a080e7          	jalr	-1910(ra) # 80002298 <argaddr>
    return -1;
    80004a16:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a18:	00054b63          	bltz	a0,80004a2e <sys_fstat+0x44>
  return filestat(f, st);
    80004a1c:	fe043583          	ld	a1,-32(s0)
    80004a20:	fe843503          	ld	a0,-24(s0)
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	32a080e7          	jalr	810(ra) # 80003d4e <filestat>
    80004a2c:	87aa                	mv	a5,a0
}
    80004a2e:	853e                	mv	a0,a5
    80004a30:	60e2                	ld	ra,24(sp)
    80004a32:	6442                	ld	s0,16(sp)
    80004a34:	6105                	addi	sp,sp,32
    80004a36:	8082                	ret

0000000080004a38 <sys_link>:
{
    80004a38:	7169                	addi	sp,sp,-304
    80004a3a:	f606                	sd	ra,296(sp)
    80004a3c:	f222                	sd	s0,288(sp)
    80004a3e:	ee26                	sd	s1,280(sp)
    80004a40:	ea4a                	sd	s2,272(sp)
    80004a42:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a44:	08000613          	li	a2,128
    80004a48:	ed040593          	addi	a1,s0,-304
    80004a4c:	4501                	li	a0,0
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	86c080e7          	jalr	-1940(ra) # 800022ba <argstr>
    return -1;
    80004a56:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a58:	10054e63          	bltz	a0,80004b74 <sys_link+0x13c>
    80004a5c:	08000613          	li	a2,128
    80004a60:	f5040593          	addi	a1,s0,-176
    80004a64:	4505                	li	a0,1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	854080e7          	jalr	-1964(ra) # 800022ba <argstr>
    return -1;
    80004a6e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a70:	10054263          	bltz	a0,80004b74 <sys_link+0x13c>
  begin_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	d46080e7          	jalr	-698(ra) # 800037ba <begin_op>
  if((ip = namei(old)) == 0){
    80004a7c:	ed040513          	addi	a0,s0,-304
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	b1e080e7          	jalr	-1250(ra) # 8000359e <namei>
    80004a88:	84aa                	mv	s1,a0
    80004a8a:	c551                	beqz	a0,80004b16 <sys_link+0xde>
  ilock(ip);
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	35c080e7          	jalr	860(ra) # 80002de8 <ilock>
  if(ip->type == T_DIR){
    80004a94:	04449703          	lh	a4,68(s1)
    80004a98:	4785                	li	a5,1
    80004a9a:	08f70463          	beq	a4,a5,80004b22 <sys_link+0xea>
  ip->nlink++;
    80004a9e:	04a4d783          	lhu	a5,74(s1)
    80004aa2:	2785                	addiw	a5,a5,1
    80004aa4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	274080e7          	jalr	628(ra) # 80002d1e <iupdate>
  iunlock(ip);
    80004ab2:	8526                	mv	a0,s1
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	3f6080e7          	jalr	1014(ra) # 80002eaa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004abc:	fd040593          	addi	a1,s0,-48
    80004ac0:	f5040513          	addi	a0,s0,-176
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	af8080e7          	jalr	-1288(ra) # 800035bc <nameiparent>
    80004acc:	892a                	mv	s2,a0
    80004ace:	c935                	beqz	a0,80004b42 <sys_link+0x10a>
  ilock(dp);
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	318080e7          	jalr	792(ra) # 80002de8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ad8:	00092703          	lw	a4,0(s2)
    80004adc:	409c                	lw	a5,0(s1)
    80004ade:	04f71d63          	bne	a4,a5,80004b38 <sys_link+0x100>
    80004ae2:	40d0                	lw	a2,4(s1)
    80004ae4:	fd040593          	addi	a1,s0,-48
    80004ae8:	854a                	mv	a0,s2
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	9f2080e7          	jalr	-1550(ra) # 800034dc <dirlink>
    80004af2:	04054363          	bltz	a0,80004b38 <sys_link+0x100>
  iunlockput(dp);
    80004af6:	854a                	mv	a0,s2
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	552080e7          	jalr	1362(ra) # 8000304a <iunlockput>
  iput(ip);
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	4a0080e7          	jalr	1184(ra) # 80002fa2 <iput>
  end_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	d30080e7          	jalr	-720(ra) # 8000383a <end_op>
  return 0;
    80004b12:	4781                	li	a5,0
    80004b14:	a085                	j	80004b74 <sys_link+0x13c>
    end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	d24080e7          	jalr	-732(ra) # 8000383a <end_op>
    return -1;
    80004b1e:	57fd                	li	a5,-1
    80004b20:	a891                	j	80004b74 <sys_link+0x13c>
    iunlockput(ip);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	526080e7          	jalr	1318(ra) # 8000304a <iunlockput>
    end_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	d0e080e7          	jalr	-754(ra) # 8000383a <end_op>
    return -1;
    80004b34:	57fd                	li	a5,-1
    80004b36:	a83d                	j	80004b74 <sys_link+0x13c>
    iunlockput(dp);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	510080e7          	jalr	1296(ra) # 8000304a <iunlockput>
  ilock(ip);
    80004b42:	8526                	mv	a0,s1
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	2a4080e7          	jalr	676(ra) # 80002de8 <ilock>
  ip->nlink--;
    80004b4c:	04a4d783          	lhu	a5,74(s1)
    80004b50:	37fd                	addiw	a5,a5,-1
    80004b52:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	1c6080e7          	jalr	454(ra) # 80002d1e <iupdate>
  iunlockput(ip);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	4e8080e7          	jalr	1256(ra) # 8000304a <iunlockput>
  end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	cd0080e7          	jalr	-816(ra) # 8000383a <end_op>
  return -1;
    80004b72:	57fd                	li	a5,-1
}
    80004b74:	853e                	mv	a0,a5
    80004b76:	70b2                	ld	ra,296(sp)
    80004b78:	7412                	ld	s0,288(sp)
    80004b7a:	64f2                	ld	s1,280(sp)
    80004b7c:	6952                	ld	s2,272(sp)
    80004b7e:	6155                	addi	sp,sp,304
    80004b80:	8082                	ret

0000000080004b82 <sys_unlink>:
{
    80004b82:	7151                	addi	sp,sp,-240
    80004b84:	f586                	sd	ra,232(sp)
    80004b86:	f1a2                	sd	s0,224(sp)
    80004b88:	eda6                	sd	s1,216(sp)
    80004b8a:	e9ca                	sd	s2,208(sp)
    80004b8c:	e5ce                	sd	s3,200(sp)
    80004b8e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b90:	08000613          	li	a2,128
    80004b94:	f3040593          	addi	a1,s0,-208
    80004b98:	4501                	li	a0,0
    80004b9a:	ffffd097          	auipc	ra,0xffffd
    80004b9e:	720080e7          	jalr	1824(ra) # 800022ba <argstr>
    80004ba2:	18054163          	bltz	a0,80004d24 <sys_unlink+0x1a2>
  begin_op();
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	c14080e7          	jalr	-1004(ra) # 800037ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bae:	fb040593          	addi	a1,s0,-80
    80004bb2:	f3040513          	addi	a0,s0,-208
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	a06080e7          	jalr	-1530(ra) # 800035bc <nameiparent>
    80004bbe:	84aa                	mv	s1,a0
    80004bc0:	c979                	beqz	a0,80004c96 <sys_unlink+0x114>
  ilock(dp);
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	226080e7          	jalr	550(ra) # 80002de8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bca:	00004597          	auipc	a1,0x4
    80004bce:	b0658593          	addi	a1,a1,-1274 # 800086d0 <syscalls+0x2b0>
    80004bd2:	fb040513          	addi	a0,s0,-80
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	6dc080e7          	jalr	1756(ra) # 800032b2 <namecmp>
    80004bde:	14050a63          	beqz	a0,80004d32 <sys_unlink+0x1b0>
    80004be2:	00004597          	auipc	a1,0x4
    80004be6:	af658593          	addi	a1,a1,-1290 # 800086d8 <syscalls+0x2b8>
    80004bea:	fb040513          	addi	a0,s0,-80
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	6c4080e7          	jalr	1732(ra) # 800032b2 <namecmp>
    80004bf6:	12050e63          	beqz	a0,80004d32 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bfa:	f2c40613          	addi	a2,s0,-212
    80004bfe:	fb040593          	addi	a1,s0,-80
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	6c8080e7          	jalr	1736(ra) # 800032cc <dirlookup>
    80004c0c:	892a                	mv	s2,a0
    80004c0e:	12050263          	beqz	a0,80004d32 <sys_unlink+0x1b0>
  ilock(ip);
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	1d6080e7          	jalr	470(ra) # 80002de8 <ilock>
  if(ip->nlink < 1)
    80004c1a:	04a91783          	lh	a5,74(s2)
    80004c1e:	08f05263          	blez	a5,80004ca2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c22:	04491703          	lh	a4,68(s2)
    80004c26:	4785                	li	a5,1
    80004c28:	08f70563          	beq	a4,a5,80004cb2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c2c:	4641                	li	a2,16
    80004c2e:	4581                	li	a1,0
    80004c30:	fc040513          	addi	a0,s0,-64
    80004c34:	ffffb097          	auipc	ra,0xffffb
    80004c38:	740080e7          	jalr	1856(ra) # 80000374 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3c:	4741                	li	a4,16
    80004c3e:	f2c42683          	lw	a3,-212(s0)
    80004c42:	fc040613          	addi	a2,s0,-64
    80004c46:	4581                	li	a1,0
    80004c48:	8526                	mv	a0,s1
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	54a080e7          	jalr	1354(ra) # 80003194 <writei>
    80004c52:	47c1                	li	a5,16
    80004c54:	0af51563          	bne	a0,a5,80004cfe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c58:	04491703          	lh	a4,68(s2)
    80004c5c:	4785                	li	a5,1
    80004c5e:	0af70863          	beq	a4,a5,80004d0e <sys_unlink+0x18c>
  iunlockput(dp);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	3e6080e7          	jalr	998(ra) # 8000304a <iunlockput>
  ip->nlink--;
    80004c6c:	04a95783          	lhu	a5,74(s2)
    80004c70:	37fd                	addiw	a5,a5,-1
    80004c72:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	0a6080e7          	jalr	166(ra) # 80002d1e <iupdate>
  iunlockput(ip);
    80004c80:	854a                	mv	a0,s2
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	3c8080e7          	jalr	968(ra) # 8000304a <iunlockput>
  end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	bb0080e7          	jalr	-1104(ra) # 8000383a <end_op>
  return 0;
    80004c92:	4501                	li	a0,0
    80004c94:	a84d                	j	80004d46 <sys_unlink+0x1c4>
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	ba4080e7          	jalr	-1116(ra) # 8000383a <end_op>
    return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	a05d                	j	80004d46 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ca2:	00004517          	auipc	a0,0x4
    80004ca6:	a5e50513          	addi	a0,a0,-1442 # 80008700 <syscalls+0x2e0>
    80004caa:	00001097          	auipc	ra,0x1
    80004cae:	1ee080e7          	jalr	494(ra) # 80005e98 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb2:	04c92703          	lw	a4,76(s2)
    80004cb6:	02000793          	li	a5,32
    80004cba:	f6e7f9e3          	bgeu	a5,a4,80004c2c <sys_unlink+0xaa>
    80004cbe:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cc2:	4741                	li	a4,16
    80004cc4:	86ce                	mv	a3,s3
    80004cc6:	f1840613          	addi	a2,s0,-232
    80004cca:	4581                	li	a1,0
    80004ccc:	854a                	mv	a0,s2
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	3ce080e7          	jalr	974(ra) # 8000309c <readi>
    80004cd6:	47c1                	li	a5,16
    80004cd8:	00f51b63          	bne	a0,a5,80004cee <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cdc:	f1845783          	lhu	a5,-232(s0)
    80004ce0:	e7a1                	bnez	a5,80004d28 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ce2:	29c1                	addiw	s3,s3,16
    80004ce4:	04c92783          	lw	a5,76(s2)
    80004ce8:	fcf9ede3          	bltu	s3,a5,80004cc2 <sys_unlink+0x140>
    80004cec:	b781                	j	80004c2c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cee:	00004517          	auipc	a0,0x4
    80004cf2:	a2a50513          	addi	a0,a0,-1494 # 80008718 <syscalls+0x2f8>
    80004cf6:	00001097          	auipc	ra,0x1
    80004cfa:	1a2080e7          	jalr	418(ra) # 80005e98 <panic>
    panic("unlink: writei");
    80004cfe:	00004517          	auipc	a0,0x4
    80004d02:	a3250513          	addi	a0,a0,-1486 # 80008730 <syscalls+0x310>
    80004d06:	00001097          	auipc	ra,0x1
    80004d0a:	192080e7          	jalr	402(ra) # 80005e98 <panic>
    dp->nlink--;
    80004d0e:	04a4d783          	lhu	a5,74(s1)
    80004d12:	37fd                	addiw	a5,a5,-1
    80004d14:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d18:	8526                	mv	a0,s1
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	004080e7          	jalr	4(ra) # 80002d1e <iupdate>
    80004d22:	b781                	j	80004c62 <sys_unlink+0xe0>
    return -1;
    80004d24:	557d                	li	a0,-1
    80004d26:	a005                	j	80004d46 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d28:	854a                	mv	a0,s2
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	320080e7          	jalr	800(ra) # 8000304a <iunlockput>
  iunlockput(dp);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	316080e7          	jalr	790(ra) # 8000304a <iunlockput>
  end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	afe080e7          	jalr	-1282(ra) # 8000383a <end_op>
  return -1;
    80004d44:	557d                	li	a0,-1
}
    80004d46:	70ae                	ld	ra,232(sp)
    80004d48:	740e                	ld	s0,224(sp)
    80004d4a:	64ee                	ld	s1,216(sp)
    80004d4c:	694e                	ld	s2,208(sp)
    80004d4e:	69ae                	ld	s3,200(sp)
    80004d50:	616d                	addi	sp,sp,240
    80004d52:	8082                	ret

0000000080004d54 <sys_open>:

uint64
sys_open(void)
{
    80004d54:	7131                	addi	sp,sp,-192
    80004d56:	fd06                	sd	ra,184(sp)
    80004d58:	f922                	sd	s0,176(sp)
    80004d5a:	f526                	sd	s1,168(sp)
    80004d5c:	f14a                	sd	s2,160(sp)
    80004d5e:	ed4e                	sd	s3,152(sp)
    80004d60:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d62:	08000613          	li	a2,128
    80004d66:	f5040593          	addi	a1,s0,-176
    80004d6a:	4501                	li	a0,0
    80004d6c:	ffffd097          	auipc	ra,0xffffd
    80004d70:	54e080e7          	jalr	1358(ra) # 800022ba <argstr>
    return -1;
    80004d74:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d76:	0c054163          	bltz	a0,80004e38 <sys_open+0xe4>
    80004d7a:	f4c40593          	addi	a1,s0,-180
    80004d7e:	4505                	li	a0,1
    80004d80:	ffffd097          	auipc	ra,0xffffd
    80004d84:	4f6080e7          	jalr	1270(ra) # 80002276 <argint>
    80004d88:	0a054863          	bltz	a0,80004e38 <sys_open+0xe4>

  begin_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	a2e080e7          	jalr	-1490(ra) # 800037ba <begin_op>

  if(omode & O_CREATE){
    80004d94:	f4c42783          	lw	a5,-180(s0)
    80004d98:	2007f793          	andi	a5,a5,512
    80004d9c:	cbdd                	beqz	a5,80004e52 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d9e:	4681                	li	a3,0
    80004da0:	4601                	li	a2,0
    80004da2:	4589                	li	a1,2
    80004da4:	f5040513          	addi	a0,s0,-176
    80004da8:	00000097          	auipc	ra,0x0
    80004dac:	972080e7          	jalr	-1678(ra) # 8000471a <create>
    80004db0:	892a                	mv	s2,a0
    if(ip == 0){
    80004db2:	c959                	beqz	a0,80004e48 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004db4:	04491703          	lh	a4,68(s2)
    80004db8:	478d                	li	a5,3
    80004dba:	00f71763          	bne	a4,a5,80004dc8 <sys_open+0x74>
    80004dbe:	04695703          	lhu	a4,70(s2)
    80004dc2:	47a5                	li	a5,9
    80004dc4:	0ce7ec63          	bltu	a5,a4,80004e9c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	e02080e7          	jalr	-510(ra) # 80003bca <filealloc>
    80004dd0:	89aa                	mv	s3,a0
    80004dd2:	10050263          	beqz	a0,80004ed6 <sys_open+0x182>
    80004dd6:	00000097          	auipc	ra,0x0
    80004dda:	902080e7          	jalr	-1790(ra) # 800046d8 <fdalloc>
    80004dde:	84aa                	mv	s1,a0
    80004de0:	0e054663          	bltz	a0,80004ecc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004de4:	04491703          	lh	a4,68(s2)
    80004de8:	478d                	li	a5,3
    80004dea:	0cf70463          	beq	a4,a5,80004eb2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dee:	4789                	li	a5,2
    80004df0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004df4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004df8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dfc:	f4c42783          	lw	a5,-180(s0)
    80004e00:	0017c713          	xori	a4,a5,1
    80004e04:	8b05                	andi	a4,a4,1
    80004e06:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e0a:	0037f713          	andi	a4,a5,3
    80004e0e:	00e03733          	snez	a4,a4
    80004e12:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e16:	4007f793          	andi	a5,a5,1024
    80004e1a:	c791                	beqz	a5,80004e26 <sys_open+0xd2>
    80004e1c:	04491703          	lh	a4,68(s2)
    80004e20:	4789                	li	a5,2
    80004e22:	08f70f63          	beq	a4,a5,80004ec0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e26:	854a                	mv	a0,s2
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	082080e7          	jalr	130(ra) # 80002eaa <iunlock>
  end_op();
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	a0a080e7          	jalr	-1526(ra) # 8000383a <end_op>

  return fd;
}
    80004e38:	8526                	mv	a0,s1
    80004e3a:	70ea                	ld	ra,184(sp)
    80004e3c:	744a                	ld	s0,176(sp)
    80004e3e:	74aa                	ld	s1,168(sp)
    80004e40:	790a                	ld	s2,160(sp)
    80004e42:	69ea                	ld	s3,152(sp)
    80004e44:	6129                	addi	sp,sp,192
    80004e46:	8082                	ret
      end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	9f2080e7          	jalr	-1550(ra) # 8000383a <end_op>
      return -1;
    80004e50:	b7e5                	j	80004e38 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e52:	f5040513          	addi	a0,s0,-176
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	748080e7          	jalr	1864(ra) # 8000359e <namei>
    80004e5e:	892a                	mv	s2,a0
    80004e60:	c905                	beqz	a0,80004e90 <sys_open+0x13c>
    ilock(ip);
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	f86080e7          	jalr	-122(ra) # 80002de8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e6a:	04491703          	lh	a4,68(s2)
    80004e6e:	4785                	li	a5,1
    80004e70:	f4f712e3          	bne	a4,a5,80004db4 <sys_open+0x60>
    80004e74:	f4c42783          	lw	a5,-180(s0)
    80004e78:	dba1                	beqz	a5,80004dc8 <sys_open+0x74>
      iunlockput(ip);
    80004e7a:	854a                	mv	a0,s2
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	1ce080e7          	jalr	462(ra) # 8000304a <iunlockput>
      end_op();
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	9b6080e7          	jalr	-1610(ra) # 8000383a <end_op>
      return -1;
    80004e8c:	54fd                	li	s1,-1
    80004e8e:	b76d                	j	80004e38 <sys_open+0xe4>
      end_op();
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	9aa080e7          	jalr	-1622(ra) # 8000383a <end_op>
      return -1;
    80004e98:	54fd                	li	s1,-1
    80004e9a:	bf79                	j	80004e38 <sys_open+0xe4>
    iunlockput(ip);
    80004e9c:	854a                	mv	a0,s2
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	1ac080e7          	jalr	428(ra) # 8000304a <iunlockput>
    end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	994080e7          	jalr	-1644(ra) # 8000383a <end_op>
    return -1;
    80004eae:	54fd                	li	s1,-1
    80004eb0:	b761                	j	80004e38 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004eb2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004eb6:	04691783          	lh	a5,70(s2)
    80004eba:	02f99223          	sh	a5,36(s3)
    80004ebe:	bf2d                	j	80004df8 <sys_open+0xa4>
    itrunc(ip);
    80004ec0:	854a                	mv	a0,s2
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	034080e7          	jalr	52(ra) # 80002ef6 <itrunc>
    80004eca:	bfb1                	j	80004e26 <sys_open+0xd2>
      fileclose(f);
    80004ecc:	854e                	mv	a0,s3
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	db8080e7          	jalr	-584(ra) # 80003c86 <fileclose>
    iunlockput(ip);
    80004ed6:	854a                	mv	a0,s2
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	172080e7          	jalr	370(ra) # 8000304a <iunlockput>
    end_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	95a080e7          	jalr	-1702(ra) # 8000383a <end_op>
    return -1;
    80004ee8:	54fd                	li	s1,-1
    80004eea:	b7b9                	j	80004e38 <sys_open+0xe4>

0000000080004eec <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eec:	7175                	addi	sp,sp,-144
    80004eee:	e506                	sd	ra,136(sp)
    80004ef0:	e122                	sd	s0,128(sp)
    80004ef2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	8c6080e7          	jalr	-1850(ra) # 800037ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004efc:	08000613          	li	a2,128
    80004f00:	f7040593          	addi	a1,s0,-144
    80004f04:	4501                	li	a0,0
    80004f06:	ffffd097          	auipc	ra,0xffffd
    80004f0a:	3b4080e7          	jalr	948(ra) # 800022ba <argstr>
    80004f0e:	02054963          	bltz	a0,80004f40 <sys_mkdir+0x54>
    80004f12:	4681                	li	a3,0
    80004f14:	4601                	li	a2,0
    80004f16:	4585                	li	a1,1
    80004f18:	f7040513          	addi	a0,s0,-144
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	7fe080e7          	jalr	2046(ra) # 8000471a <create>
    80004f24:	cd11                	beqz	a0,80004f40 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	124080e7          	jalr	292(ra) # 8000304a <iunlockput>
  end_op();
    80004f2e:	fffff097          	auipc	ra,0xfffff
    80004f32:	90c080e7          	jalr	-1780(ra) # 8000383a <end_op>
  return 0;
    80004f36:	4501                	li	a0,0
}
    80004f38:	60aa                	ld	ra,136(sp)
    80004f3a:	640a                	ld	s0,128(sp)
    80004f3c:	6149                	addi	sp,sp,144
    80004f3e:	8082                	ret
    end_op();
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	8fa080e7          	jalr	-1798(ra) # 8000383a <end_op>
    return -1;
    80004f48:	557d                	li	a0,-1
    80004f4a:	b7fd                	j	80004f38 <sys_mkdir+0x4c>

0000000080004f4c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f4c:	7135                	addi	sp,sp,-160
    80004f4e:	ed06                	sd	ra,152(sp)
    80004f50:	e922                	sd	s0,144(sp)
    80004f52:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	866080e7          	jalr	-1946(ra) # 800037ba <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f5c:	08000613          	li	a2,128
    80004f60:	f7040593          	addi	a1,s0,-144
    80004f64:	4501                	li	a0,0
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	354080e7          	jalr	852(ra) # 800022ba <argstr>
    80004f6e:	04054a63          	bltz	a0,80004fc2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f72:	f6c40593          	addi	a1,s0,-148
    80004f76:	4505                	li	a0,1
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	2fe080e7          	jalr	766(ra) # 80002276 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f80:	04054163          	bltz	a0,80004fc2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f84:	f6840593          	addi	a1,s0,-152
    80004f88:	4509                	li	a0,2
    80004f8a:	ffffd097          	auipc	ra,0xffffd
    80004f8e:	2ec080e7          	jalr	748(ra) # 80002276 <argint>
     argint(1, &major) < 0 ||
    80004f92:	02054863          	bltz	a0,80004fc2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f96:	f6841683          	lh	a3,-152(s0)
    80004f9a:	f6c41603          	lh	a2,-148(s0)
    80004f9e:	458d                	li	a1,3
    80004fa0:	f7040513          	addi	a0,s0,-144
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	776080e7          	jalr	1910(ra) # 8000471a <create>
     argint(2, &minor) < 0 ||
    80004fac:	c919                	beqz	a0,80004fc2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	09c080e7          	jalr	156(ra) # 8000304a <iunlockput>
  end_op();
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	884080e7          	jalr	-1916(ra) # 8000383a <end_op>
  return 0;
    80004fbe:	4501                	li	a0,0
    80004fc0:	a031                	j	80004fcc <sys_mknod+0x80>
    end_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	878080e7          	jalr	-1928(ra) # 8000383a <end_op>
    return -1;
    80004fca:	557d                	li	a0,-1
}
    80004fcc:	60ea                	ld	ra,152(sp)
    80004fce:	644a                	ld	s0,144(sp)
    80004fd0:	610d                	addi	sp,sp,160
    80004fd2:	8082                	ret

0000000080004fd4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fd4:	7135                	addi	sp,sp,-160
    80004fd6:	ed06                	sd	ra,152(sp)
    80004fd8:	e922                	sd	s0,144(sp)
    80004fda:	e526                	sd	s1,136(sp)
    80004fdc:	e14a                	sd	s2,128(sp)
    80004fde:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fe0:	ffffc097          	auipc	ra,0xffffc
    80004fe4:	166080e7          	jalr	358(ra) # 80001146 <myproc>
    80004fe8:	892a                	mv	s2,a0
  
  begin_op();
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	7d0080e7          	jalr	2000(ra) # 800037ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ff2:	08000613          	li	a2,128
    80004ff6:	f6040593          	addi	a1,s0,-160
    80004ffa:	4501                	li	a0,0
    80004ffc:	ffffd097          	auipc	ra,0xffffd
    80005000:	2be080e7          	jalr	702(ra) # 800022ba <argstr>
    80005004:	04054b63          	bltz	a0,8000505a <sys_chdir+0x86>
    80005008:	f6040513          	addi	a0,s0,-160
    8000500c:	ffffe097          	auipc	ra,0xffffe
    80005010:	592080e7          	jalr	1426(ra) # 8000359e <namei>
    80005014:	84aa                	mv	s1,a0
    80005016:	c131                	beqz	a0,8000505a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	dd0080e7          	jalr	-560(ra) # 80002de8 <ilock>
  if(ip->type != T_DIR){
    80005020:	04449703          	lh	a4,68(s1)
    80005024:	4785                	li	a5,1
    80005026:	04f71063          	bne	a4,a5,80005066 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000502a:	8526                	mv	a0,s1
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	e7e080e7          	jalr	-386(ra) # 80002eaa <iunlock>
  iput(p->cwd);
    80005034:	15093503          	ld	a0,336(s2)
    80005038:	ffffe097          	auipc	ra,0xffffe
    8000503c:	f6a080e7          	jalr	-150(ra) # 80002fa2 <iput>
  end_op();
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	7fa080e7          	jalr	2042(ra) # 8000383a <end_op>
  p->cwd = ip;
    80005048:	14993823          	sd	s1,336(s2)
  return 0;
    8000504c:	4501                	li	a0,0
}
    8000504e:	60ea                	ld	ra,152(sp)
    80005050:	644a                	ld	s0,144(sp)
    80005052:	64aa                	ld	s1,136(sp)
    80005054:	690a                	ld	s2,128(sp)
    80005056:	610d                	addi	sp,sp,160
    80005058:	8082                	ret
    end_op();
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	7e0080e7          	jalr	2016(ra) # 8000383a <end_op>
    return -1;
    80005062:	557d                	li	a0,-1
    80005064:	b7ed                	j	8000504e <sys_chdir+0x7a>
    iunlockput(ip);
    80005066:	8526                	mv	a0,s1
    80005068:	ffffe097          	auipc	ra,0xffffe
    8000506c:	fe2080e7          	jalr	-30(ra) # 8000304a <iunlockput>
    end_op();
    80005070:	ffffe097          	auipc	ra,0xffffe
    80005074:	7ca080e7          	jalr	1994(ra) # 8000383a <end_op>
    return -1;
    80005078:	557d                	li	a0,-1
    8000507a:	bfd1                	j	8000504e <sys_chdir+0x7a>

000000008000507c <sys_exec>:

uint64
sys_exec(void)
{
    8000507c:	7145                	addi	sp,sp,-464
    8000507e:	e786                	sd	ra,456(sp)
    80005080:	e3a2                	sd	s0,448(sp)
    80005082:	ff26                	sd	s1,440(sp)
    80005084:	fb4a                	sd	s2,432(sp)
    80005086:	f74e                	sd	s3,424(sp)
    80005088:	f352                	sd	s4,416(sp)
    8000508a:	ef56                	sd	s5,408(sp)
    8000508c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000508e:	08000613          	li	a2,128
    80005092:	f4040593          	addi	a1,s0,-192
    80005096:	4501                	li	a0,0
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	222080e7          	jalr	546(ra) # 800022ba <argstr>
    return -1;
    800050a0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a2:	0c054a63          	bltz	a0,80005176 <sys_exec+0xfa>
    800050a6:	e3840593          	addi	a1,s0,-456
    800050aa:	4505                	li	a0,1
    800050ac:	ffffd097          	auipc	ra,0xffffd
    800050b0:	1ec080e7          	jalr	492(ra) # 80002298 <argaddr>
    800050b4:	0c054163          	bltz	a0,80005176 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050b8:	10000613          	li	a2,256
    800050bc:	4581                	li	a1,0
    800050be:	e4040513          	addi	a0,s0,-448
    800050c2:	ffffb097          	auipc	ra,0xffffb
    800050c6:	2b2080e7          	jalr	690(ra) # 80000374 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050ca:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050ce:	89a6                	mv	s3,s1
    800050d0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050d2:	02000a13          	li	s4,32
    800050d6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050da:	00391513          	slli	a0,s2,0x3
    800050de:	e3040593          	addi	a1,s0,-464
    800050e2:	e3843783          	ld	a5,-456(s0)
    800050e6:	953e                	add	a0,a0,a5
    800050e8:	ffffd097          	auipc	ra,0xffffd
    800050ec:	0f4080e7          	jalr	244(ra) # 800021dc <fetchaddr>
    800050f0:	02054a63          	bltz	a0,80005124 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050f4:	e3043783          	ld	a5,-464(s0)
    800050f8:	c3b9                	beqz	a5,8000513e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050fa:	ffffb097          	auipc	ra,0xffffb
    800050fe:	210080e7          	jalr	528(ra) # 8000030a <kalloc>
    80005102:	85aa                	mv	a1,a0
    80005104:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005108:	cd11                	beqz	a0,80005124 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000510a:	6605                	lui	a2,0x1
    8000510c:	e3043503          	ld	a0,-464(s0)
    80005110:	ffffd097          	auipc	ra,0xffffd
    80005114:	11e080e7          	jalr	286(ra) # 8000222e <fetchstr>
    80005118:	00054663          	bltz	a0,80005124 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000511c:	0905                	addi	s2,s2,1
    8000511e:	09a1                	addi	s3,s3,8
    80005120:	fb491be3          	bne	s2,s4,800050d6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005124:	10048913          	addi	s2,s1,256
    80005128:	6088                	ld	a0,0(s1)
    8000512a:	c529                	beqz	a0,80005174 <sys_exec+0xf8>
    kfree(argv[i]);
    8000512c:	ffffb097          	auipc	ra,0xffffb
    80005130:	018080e7          	jalr	24(ra) # 80000144 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005134:	04a1                	addi	s1,s1,8
    80005136:	ff2499e3          	bne	s1,s2,80005128 <sys_exec+0xac>
  return -1;
    8000513a:	597d                	li	s2,-1
    8000513c:	a82d                	j	80005176 <sys_exec+0xfa>
      argv[i] = 0;
    8000513e:	0a8e                	slli	s5,s5,0x3
    80005140:	fc040793          	addi	a5,s0,-64
    80005144:	9abe                	add	s5,s5,a5
    80005146:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000514a:	e4040593          	addi	a1,s0,-448
    8000514e:	f4040513          	addi	a0,s0,-192
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	194080e7          	jalr	404(ra) # 800042e6 <exec>
    8000515a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000515c:	10048993          	addi	s3,s1,256
    80005160:	6088                	ld	a0,0(s1)
    80005162:	c911                	beqz	a0,80005176 <sys_exec+0xfa>
    kfree(argv[i]);
    80005164:	ffffb097          	auipc	ra,0xffffb
    80005168:	fe0080e7          	jalr	-32(ra) # 80000144 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000516c:	04a1                	addi	s1,s1,8
    8000516e:	ff3499e3          	bne	s1,s3,80005160 <sys_exec+0xe4>
    80005172:	a011                	j	80005176 <sys_exec+0xfa>
  return -1;
    80005174:	597d                	li	s2,-1
}
    80005176:	854a                	mv	a0,s2
    80005178:	60be                	ld	ra,456(sp)
    8000517a:	641e                	ld	s0,448(sp)
    8000517c:	74fa                	ld	s1,440(sp)
    8000517e:	795a                	ld	s2,432(sp)
    80005180:	79ba                	ld	s3,424(sp)
    80005182:	7a1a                	ld	s4,416(sp)
    80005184:	6afa                	ld	s5,408(sp)
    80005186:	6179                	addi	sp,sp,464
    80005188:	8082                	ret

000000008000518a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000518a:	7139                	addi	sp,sp,-64
    8000518c:	fc06                	sd	ra,56(sp)
    8000518e:	f822                	sd	s0,48(sp)
    80005190:	f426                	sd	s1,40(sp)
    80005192:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	fb2080e7          	jalr	-78(ra) # 80001146 <myproc>
    8000519c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000519e:	fd840593          	addi	a1,s0,-40
    800051a2:	4501                	li	a0,0
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	0f4080e7          	jalr	244(ra) # 80002298 <argaddr>
    return -1;
    800051ac:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051ae:	0e054063          	bltz	a0,8000528e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051b2:	fc840593          	addi	a1,s0,-56
    800051b6:	fd040513          	addi	a0,s0,-48
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	dfc080e7          	jalr	-516(ra) # 80003fb6 <pipealloc>
    return -1;
    800051c2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051c4:	0c054563          	bltz	a0,8000528e <sys_pipe+0x104>
  fd0 = -1;
    800051c8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051cc:	fd043503          	ld	a0,-48(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	508080e7          	jalr	1288(ra) # 800046d8 <fdalloc>
    800051d8:	fca42223          	sw	a0,-60(s0)
    800051dc:	08054c63          	bltz	a0,80005274 <sys_pipe+0xea>
    800051e0:	fc843503          	ld	a0,-56(s0)
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	4f4080e7          	jalr	1268(ra) # 800046d8 <fdalloc>
    800051ec:	fca42023          	sw	a0,-64(s0)
    800051f0:	06054863          	bltz	a0,80005260 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051f4:	4691                	li	a3,4
    800051f6:	fc440613          	addi	a2,s0,-60
    800051fa:	fd843583          	ld	a1,-40(s0)
    800051fe:	68a8                	ld	a0,80(s1)
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	d16080e7          	jalr	-746(ra) # 80000f16 <copyout>
    80005208:	02054063          	bltz	a0,80005228 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000520c:	4691                	li	a3,4
    8000520e:	fc040613          	addi	a2,s0,-64
    80005212:	fd843583          	ld	a1,-40(s0)
    80005216:	0591                	addi	a1,a1,4
    80005218:	68a8                	ld	a0,80(s1)
    8000521a:	ffffc097          	auipc	ra,0xffffc
    8000521e:	cfc080e7          	jalr	-772(ra) # 80000f16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005222:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005224:	06055563          	bgez	a0,8000528e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005228:	fc442783          	lw	a5,-60(s0)
    8000522c:	07e9                	addi	a5,a5,26
    8000522e:	078e                	slli	a5,a5,0x3
    80005230:	97a6                	add	a5,a5,s1
    80005232:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005236:	fc042503          	lw	a0,-64(s0)
    8000523a:	0569                	addi	a0,a0,26
    8000523c:	050e                	slli	a0,a0,0x3
    8000523e:	9526                	add	a0,a0,s1
    80005240:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005244:	fd043503          	ld	a0,-48(s0)
    80005248:	fffff097          	auipc	ra,0xfffff
    8000524c:	a3e080e7          	jalr	-1474(ra) # 80003c86 <fileclose>
    fileclose(wf);
    80005250:	fc843503          	ld	a0,-56(s0)
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	a32080e7          	jalr	-1486(ra) # 80003c86 <fileclose>
    return -1;
    8000525c:	57fd                	li	a5,-1
    8000525e:	a805                	j	8000528e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005260:	fc442783          	lw	a5,-60(s0)
    80005264:	0007c863          	bltz	a5,80005274 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005268:	01a78513          	addi	a0,a5,26
    8000526c:	050e                	slli	a0,a0,0x3
    8000526e:	9526                	add	a0,a0,s1
    80005270:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005274:	fd043503          	ld	a0,-48(s0)
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	a0e080e7          	jalr	-1522(ra) # 80003c86 <fileclose>
    fileclose(wf);
    80005280:	fc843503          	ld	a0,-56(s0)
    80005284:	fffff097          	auipc	ra,0xfffff
    80005288:	a02080e7          	jalr	-1534(ra) # 80003c86 <fileclose>
    return -1;
    8000528c:	57fd                	li	a5,-1
}
    8000528e:	853e                	mv	a0,a5
    80005290:	70e2                	ld	ra,56(sp)
    80005292:	7442                	ld	s0,48(sp)
    80005294:	74a2                	ld	s1,40(sp)
    80005296:	6121                	addi	sp,sp,64
    80005298:	8082                	ret
    8000529a:	0000                	unimp
    8000529c:	0000                	unimp
	...

00000000800052a0 <kernelvec>:
    800052a0:	7111                	addi	sp,sp,-256
    800052a2:	e006                	sd	ra,0(sp)
    800052a4:	e40a                	sd	sp,8(sp)
    800052a6:	e80e                	sd	gp,16(sp)
    800052a8:	ec12                	sd	tp,24(sp)
    800052aa:	f016                	sd	t0,32(sp)
    800052ac:	f41a                	sd	t1,40(sp)
    800052ae:	f81e                	sd	t2,48(sp)
    800052b0:	fc22                	sd	s0,56(sp)
    800052b2:	e0a6                	sd	s1,64(sp)
    800052b4:	e4aa                	sd	a0,72(sp)
    800052b6:	e8ae                	sd	a1,80(sp)
    800052b8:	ecb2                	sd	a2,88(sp)
    800052ba:	f0b6                	sd	a3,96(sp)
    800052bc:	f4ba                	sd	a4,104(sp)
    800052be:	f8be                	sd	a5,112(sp)
    800052c0:	fcc2                	sd	a6,120(sp)
    800052c2:	e146                	sd	a7,128(sp)
    800052c4:	e54a                	sd	s2,136(sp)
    800052c6:	e94e                	sd	s3,144(sp)
    800052c8:	ed52                	sd	s4,152(sp)
    800052ca:	f156                	sd	s5,160(sp)
    800052cc:	f55a                	sd	s6,168(sp)
    800052ce:	f95e                	sd	s7,176(sp)
    800052d0:	fd62                	sd	s8,184(sp)
    800052d2:	e1e6                	sd	s9,192(sp)
    800052d4:	e5ea                	sd	s10,200(sp)
    800052d6:	e9ee                	sd	s11,208(sp)
    800052d8:	edf2                	sd	t3,216(sp)
    800052da:	f1f6                	sd	t4,224(sp)
    800052dc:	f5fa                	sd	t5,232(sp)
    800052de:	f9fe                	sd	t6,240(sp)
    800052e0:	dc9fc0ef          	jal	ra,800020a8 <kerneltrap>
    800052e4:	6082                	ld	ra,0(sp)
    800052e6:	6122                	ld	sp,8(sp)
    800052e8:	61c2                	ld	gp,16(sp)
    800052ea:	7282                	ld	t0,32(sp)
    800052ec:	7322                	ld	t1,40(sp)
    800052ee:	73c2                	ld	t2,48(sp)
    800052f0:	7462                	ld	s0,56(sp)
    800052f2:	6486                	ld	s1,64(sp)
    800052f4:	6526                	ld	a0,72(sp)
    800052f6:	65c6                	ld	a1,80(sp)
    800052f8:	6666                	ld	a2,88(sp)
    800052fa:	7686                	ld	a3,96(sp)
    800052fc:	7726                	ld	a4,104(sp)
    800052fe:	77c6                	ld	a5,112(sp)
    80005300:	7866                	ld	a6,120(sp)
    80005302:	688a                	ld	a7,128(sp)
    80005304:	692a                	ld	s2,136(sp)
    80005306:	69ca                	ld	s3,144(sp)
    80005308:	6a6a                	ld	s4,152(sp)
    8000530a:	7a8a                	ld	s5,160(sp)
    8000530c:	7b2a                	ld	s6,168(sp)
    8000530e:	7bca                	ld	s7,176(sp)
    80005310:	7c6a                	ld	s8,184(sp)
    80005312:	6c8e                	ld	s9,192(sp)
    80005314:	6d2e                	ld	s10,200(sp)
    80005316:	6dce                	ld	s11,208(sp)
    80005318:	6e6e                	ld	t3,216(sp)
    8000531a:	7e8e                	ld	t4,224(sp)
    8000531c:	7f2e                	ld	t5,232(sp)
    8000531e:	7fce                	ld	t6,240(sp)
    80005320:	6111                	addi	sp,sp,256
    80005322:	10200073          	sret
    80005326:	00000013          	nop
    8000532a:	00000013          	nop
    8000532e:	0001                	nop

0000000080005330 <timervec>:
    80005330:	34051573          	csrrw	a0,mscratch,a0
    80005334:	e10c                	sd	a1,0(a0)
    80005336:	e510                	sd	a2,8(a0)
    80005338:	e914                	sd	a3,16(a0)
    8000533a:	6d0c                	ld	a1,24(a0)
    8000533c:	7110                	ld	a2,32(a0)
    8000533e:	6194                	ld	a3,0(a1)
    80005340:	96b2                	add	a3,a3,a2
    80005342:	e194                	sd	a3,0(a1)
    80005344:	4589                	li	a1,2
    80005346:	14459073          	csrw	sip,a1
    8000534a:	6914                	ld	a3,16(a0)
    8000534c:	6510                	ld	a2,8(a0)
    8000534e:	610c                	ld	a1,0(a0)
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	30200073          	mret
	...

000000008000535a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000535a:	1141                	addi	sp,sp,-16
    8000535c:	e422                	sd	s0,8(sp)
    8000535e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005360:	0c0007b7          	lui	a5,0xc000
    80005364:	4705                	li	a4,1
    80005366:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005368:	c3d8                	sw	a4,4(a5)
}
    8000536a:	6422                	ld	s0,8(sp)
    8000536c:	0141                	addi	sp,sp,16
    8000536e:	8082                	ret

0000000080005370 <plicinithart>:

void
plicinithart(void)
{
    80005370:	1141                	addi	sp,sp,-16
    80005372:	e406                	sd	ra,8(sp)
    80005374:	e022                	sd	s0,0(sp)
    80005376:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	da2080e7          	jalr	-606(ra) # 8000111a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005380:	0085171b          	slliw	a4,a0,0x8
    80005384:	0c0027b7          	lui	a5,0xc002
    80005388:	97ba                	add	a5,a5,a4
    8000538a:	40200713          	li	a4,1026
    8000538e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005392:	00d5151b          	slliw	a0,a0,0xd
    80005396:	0c2017b7          	lui	a5,0xc201
    8000539a:	953e                	add	a0,a0,a5
    8000539c:	00052023          	sw	zero,0(a0)
}
    800053a0:	60a2                	ld	ra,8(sp)
    800053a2:	6402                	ld	s0,0(sp)
    800053a4:	0141                	addi	sp,sp,16
    800053a6:	8082                	ret

00000000800053a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053a8:	1141                	addi	sp,sp,-16
    800053aa:	e406                	sd	ra,8(sp)
    800053ac:	e022                	sd	s0,0(sp)
    800053ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	d6a080e7          	jalr	-662(ra) # 8000111a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053b8:	00d5179b          	slliw	a5,a0,0xd
    800053bc:	0c201537          	lui	a0,0xc201
    800053c0:	953e                	add	a0,a0,a5
  return irq;
}
    800053c2:	4148                	lw	a0,4(a0)
    800053c4:	60a2                	ld	ra,8(sp)
    800053c6:	6402                	ld	s0,0(sp)
    800053c8:	0141                	addi	sp,sp,16
    800053ca:	8082                	ret

00000000800053cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053cc:	1101                	addi	sp,sp,-32
    800053ce:	ec06                	sd	ra,24(sp)
    800053d0:	e822                	sd	s0,16(sp)
    800053d2:	e426                	sd	s1,8(sp)
    800053d4:	1000                	addi	s0,sp,32
    800053d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	d42080e7          	jalr	-702(ra) # 8000111a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053e0:	00d5151b          	slliw	a0,a0,0xd
    800053e4:	0c2017b7          	lui	a5,0xc201
    800053e8:	97aa                	add	a5,a5,a0
    800053ea:	c3c4                	sw	s1,4(a5)
}
    800053ec:	60e2                	ld	ra,24(sp)
    800053ee:	6442                	ld	s0,16(sp)
    800053f0:	64a2                	ld	s1,8(sp)
    800053f2:	6105                	addi	sp,sp,32
    800053f4:	8082                	ret

00000000800053f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053f6:	1141                	addi	sp,sp,-16
    800053f8:	e406                	sd	ra,8(sp)
    800053fa:	e022                	sd	s0,0(sp)
    800053fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053fe:	479d                	li	a5,7
    80005400:	06a7c963          	blt	a5,a0,80005472 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005404:	00016797          	auipc	a5,0x16
    80005408:	bfc78793          	addi	a5,a5,-1028 # 8001b000 <disk>
    8000540c:	00a78733          	add	a4,a5,a0
    80005410:	6789                	lui	a5,0x2
    80005412:	97ba                	add	a5,a5,a4
    80005414:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005418:	e7ad                	bnez	a5,80005482 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000541a:	00451793          	slli	a5,a0,0x4
    8000541e:	00018717          	auipc	a4,0x18
    80005422:	be270713          	addi	a4,a4,-1054 # 8001d000 <disk+0x2000>
    80005426:	6314                	ld	a3,0(a4)
    80005428:	96be                	add	a3,a3,a5
    8000542a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000542e:	6314                	ld	a3,0(a4)
    80005430:	96be                	add	a3,a3,a5
    80005432:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005436:	6314                	ld	a3,0(a4)
    80005438:	96be                	add	a3,a3,a5
    8000543a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000543e:	6318                	ld	a4,0(a4)
    80005440:	97ba                	add	a5,a5,a4
    80005442:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005446:	00016797          	auipc	a5,0x16
    8000544a:	bba78793          	addi	a5,a5,-1094 # 8001b000 <disk>
    8000544e:	97aa                	add	a5,a5,a0
    80005450:	6509                	lui	a0,0x2
    80005452:	953e                	add	a0,a0,a5
    80005454:	4785                	li	a5,1
    80005456:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000545a:	00018517          	auipc	a0,0x18
    8000545e:	bbe50513          	addi	a0,a0,-1090 # 8001d018 <disk+0x2018>
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	52c080e7          	jalr	1324(ra) # 8000198e <wakeup>
}
    8000546a:	60a2                	ld	ra,8(sp)
    8000546c:	6402                	ld	s0,0(sp)
    8000546e:	0141                	addi	sp,sp,16
    80005470:	8082                	ret
    panic("free_desc 1");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	2ce50513          	addi	a0,a0,718 # 80008740 <syscalls+0x320>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	a1e080e7          	jalr	-1506(ra) # 80005e98 <panic>
    panic("free_desc 2");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	2ce50513          	addi	a0,a0,718 # 80008750 <syscalls+0x330>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	a0e080e7          	jalr	-1522(ra) # 80005e98 <panic>

0000000080005492 <virtio_disk_init>:
{
    80005492:	1101                	addi	sp,sp,-32
    80005494:	ec06                	sd	ra,24(sp)
    80005496:	e822                	sd	s0,16(sp)
    80005498:	e426                	sd	s1,8(sp)
    8000549a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000549c:	00003597          	auipc	a1,0x3
    800054a0:	2c458593          	addi	a1,a1,708 # 80008760 <syscalls+0x340>
    800054a4:	00018517          	auipc	a0,0x18
    800054a8:	c8450513          	addi	a0,a0,-892 # 8001d128 <disk+0x2128>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	ea6080e7          	jalr	-346(ra) # 80006352 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054b4:	100017b7          	lui	a5,0x10001
    800054b8:	4398                	lw	a4,0(a5)
    800054ba:	2701                	sext.w	a4,a4
    800054bc:	747277b7          	lui	a5,0x74727
    800054c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054c4:	0ef71163          	bne	a4,a5,800055a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	43dc                	lw	a5,4(a5)
    800054ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d0:	4705                	li	a4,1
    800054d2:	0ce79a63          	bne	a5,a4,800055a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054d6:	100017b7          	lui	a5,0x10001
    800054da:	479c                	lw	a5,8(a5)
    800054dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054de:	4709                	li	a4,2
    800054e0:	0ce79363          	bne	a5,a4,800055a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054e4:	100017b7          	lui	a5,0x10001
    800054e8:	47d8                	lw	a4,12(a5)
    800054ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ec:	554d47b7          	lui	a5,0x554d4
    800054f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054f4:	0af71963          	bne	a4,a5,800055a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f8:	100017b7          	lui	a5,0x10001
    800054fc:	4705                	li	a4,1
    800054fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005500:	470d                	li	a4,3
    80005502:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005504:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005506:	c7ffe737          	lui	a4,0xc7ffe
    8000550a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000550e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005510:	2701                	sext.w	a4,a4
    80005512:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005514:	472d                	li	a4,11
    80005516:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005518:	473d                	li	a4,15
    8000551a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000551c:	6705                	lui	a4,0x1
    8000551e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005520:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005524:	5bdc                	lw	a5,52(a5)
    80005526:	2781                	sext.w	a5,a5
  if(max == 0)
    80005528:	c7d9                	beqz	a5,800055b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000552a:	471d                	li	a4,7
    8000552c:	08f77d63          	bgeu	a4,a5,800055c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005530:	100014b7          	lui	s1,0x10001
    80005534:	47a1                	li	a5,8
    80005536:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005538:	6609                	lui	a2,0x2
    8000553a:	4581                	li	a1,0
    8000553c:	00016517          	auipc	a0,0x16
    80005540:	ac450513          	addi	a0,a0,-1340 # 8001b000 <disk>
    80005544:	ffffb097          	auipc	ra,0xffffb
    80005548:	e30080e7          	jalr	-464(ra) # 80000374 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000554c:	00016717          	auipc	a4,0x16
    80005550:	ab470713          	addi	a4,a4,-1356 # 8001b000 <disk>
    80005554:	00c75793          	srli	a5,a4,0xc
    80005558:	2781                	sext.w	a5,a5
    8000555a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000555c:	00018797          	auipc	a5,0x18
    80005560:	aa478793          	addi	a5,a5,-1372 # 8001d000 <disk+0x2000>
    80005564:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005566:	00016717          	auipc	a4,0x16
    8000556a:	b1a70713          	addi	a4,a4,-1254 # 8001b080 <disk+0x80>
    8000556e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005570:	00017717          	auipc	a4,0x17
    80005574:	a9070713          	addi	a4,a4,-1392 # 8001c000 <disk+0x1000>
    80005578:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000557a:	4705                	li	a4,1
    8000557c:	00e78c23          	sb	a4,24(a5)
    80005580:	00e78ca3          	sb	a4,25(a5)
    80005584:	00e78d23          	sb	a4,26(a5)
    80005588:	00e78da3          	sb	a4,27(a5)
    8000558c:	00e78e23          	sb	a4,28(a5)
    80005590:	00e78ea3          	sb	a4,29(a5)
    80005594:	00e78f23          	sb	a4,30(a5)
    80005598:	00e78fa3          	sb	a4,31(a5)
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6105                	addi	sp,sp,32
    800055a4:	8082                	ret
    panic("could not find virtio disk");
    800055a6:	00003517          	auipc	a0,0x3
    800055aa:	1ca50513          	addi	a0,a0,458 # 80008770 <syscalls+0x350>
    800055ae:	00001097          	auipc	ra,0x1
    800055b2:	8ea080e7          	jalr	-1814(ra) # 80005e98 <panic>
    panic("virtio disk has no queue 0");
    800055b6:	00003517          	auipc	a0,0x3
    800055ba:	1da50513          	addi	a0,a0,474 # 80008790 <syscalls+0x370>
    800055be:	00001097          	auipc	ra,0x1
    800055c2:	8da080e7          	jalr	-1830(ra) # 80005e98 <panic>
    panic("virtio disk max queue too short");
    800055c6:	00003517          	auipc	a0,0x3
    800055ca:	1ea50513          	addi	a0,a0,490 # 800087b0 <syscalls+0x390>
    800055ce:	00001097          	auipc	ra,0x1
    800055d2:	8ca080e7          	jalr	-1846(ra) # 80005e98 <panic>

00000000800055d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055d6:	7159                	addi	sp,sp,-112
    800055d8:	f486                	sd	ra,104(sp)
    800055da:	f0a2                	sd	s0,96(sp)
    800055dc:	eca6                	sd	s1,88(sp)
    800055de:	e8ca                	sd	s2,80(sp)
    800055e0:	e4ce                	sd	s3,72(sp)
    800055e2:	e0d2                	sd	s4,64(sp)
    800055e4:	fc56                	sd	s5,56(sp)
    800055e6:	f85a                	sd	s6,48(sp)
    800055e8:	f45e                	sd	s7,40(sp)
    800055ea:	f062                	sd	s8,32(sp)
    800055ec:	ec66                	sd	s9,24(sp)
    800055ee:	e86a                	sd	s10,16(sp)
    800055f0:	1880                	addi	s0,sp,112
    800055f2:	892a                	mv	s2,a0
    800055f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055f6:	00c52c83          	lw	s9,12(a0)
    800055fa:	001c9c9b          	slliw	s9,s9,0x1
    800055fe:	1c82                	slli	s9,s9,0x20
    80005600:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005604:	00018517          	auipc	a0,0x18
    80005608:	b2450513          	addi	a0,a0,-1244 # 8001d128 <disk+0x2128>
    8000560c:	00001097          	auipc	ra,0x1
    80005610:	dd6080e7          	jalr	-554(ra) # 800063e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005614:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005616:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005618:	00016b97          	auipc	s7,0x16
    8000561c:	9e8b8b93          	addi	s7,s7,-1560 # 8001b000 <disk>
    80005620:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005622:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005624:	8a4e                	mv	s4,s3
    80005626:	a051                	j	800056aa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005628:	00fb86b3          	add	a3,s7,a5
    8000562c:	96da                	add	a3,a3,s6
    8000562e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005632:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005634:	0207c563          	bltz	a5,8000565e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005638:	2485                	addiw	s1,s1,1
    8000563a:	0711                	addi	a4,a4,4
    8000563c:	25548063          	beq	s1,s5,8000587c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005640:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005642:	00018697          	auipc	a3,0x18
    80005646:	9d668693          	addi	a3,a3,-1578 # 8001d018 <disk+0x2018>
    8000564a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000564c:	0006c583          	lbu	a1,0(a3)
    80005650:	fde1                	bnez	a1,80005628 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005652:	2785                	addiw	a5,a5,1
    80005654:	0685                	addi	a3,a3,1
    80005656:	ff879be3          	bne	a5,s8,8000564c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000565a:	57fd                	li	a5,-1
    8000565c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000565e:	02905a63          	blez	s1,80005692 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005662:	f9042503          	lw	a0,-112(s0)
    80005666:	00000097          	auipc	ra,0x0
    8000566a:	d90080e7          	jalr	-624(ra) # 800053f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000566e:	4785                	li	a5,1
    80005670:	0297d163          	bge	a5,s1,80005692 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005674:	f9442503          	lw	a0,-108(s0)
    80005678:	00000097          	auipc	ra,0x0
    8000567c:	d7e080e7          	jalr	-642(ra) # 800053f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005680:	4789                	li	a5,2
    80005682:	0097d863          	bge	a5,s1,80005692 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005686:	f9842503          	lw	a0,-104(s0)
    8000568a:	00000097          	auipc	ra,0x0
    8000568e:	d6c080e7          	jalr	-660(ra) # 800053f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005692:	00018597          	auipc	a1,0x18
    80005696:	a9658593          	addi	a1,a1,-1386 # 8001d128 <disk+0x2128>
    8000569a:	00018517          	auipc	a0,0x18
    8000569e:	97e50513          	addi	a0,a0,-1666 # 8001d018 <disk+0x2018>
    800056a2:	ffffc097          	auipc	ra,0xffffc
    800056a6:	160080e7          	jalr	352(ra) # 80001802 <sleep>
  for(int i = 0; i < 3; i++){
    800056aa:	f9040713          	addi	a4,s0,-112
    800056ae:	84ce                	mv	s1,s3
    800056b0:	bf41                	j	80005640 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056b2:	20058713          	addi	a4,a1,512
    800056b6:	00471693          	slli	a3,a4,0x4
    800056ba:	00016717          	auipc	a4,0x16
    800056be:	94670713          	addi	a4,a4,-1722 # 8001b000 <disk>
    800056c2:	9736                	add	a4,a4,a3
    800056c4:	4685                	li	a3,1
    800056c6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056ca:	20058713          	addi	a4,a1,512
    800056ce:	00471693          	slli	a3,a4,0x4
    800056d2:	00016717          	auipc	a4,0x16
    800056d6:	92e70713          	addi	a4,a4,-1746 # 8001b000 <disk>
    800056da:	9736                	add	a4,a4,a3
    800056dc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800056e0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056e4:	7679                	lui	a2,0xffffe
    800056e6:	963e                	add	a2,a2,a5
    800056e8:	00018697          	auipc	a3,0x18
    800056ec:	91868693          	addi	a3,a3,-1768 # 8001d000 <disk+0x2000>
    800056f0:	6298                	ld	a4,0(a3)
    800056f2:	9732                	add	a4,a4,a2
    800056f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056f6:	6298                	ld	a4,0(a3)
    800056f8:	9732                	add	a4,a4,a2
    800056fa:	4541                	li	a0,16
    800056fc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056fe:	6298                	ld	a4,0(a3)
    80005700:	9732                	add	a4,a4,a2
    80005702:	4505                	li	a0,1
    80005704:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005708:	f9442703          	lw	a4,-108(s0)
    8000570c:	6288                	ld	a0,0(a3)
    8000570e:	962a                	add	a2,a2,a0
    80005710:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005714:	0712                	slli	a4,a4,0x4
    80005716:	6290                	ld	a2,0(a3)
    80005718:	963a                	add	a2,a2,a4
    8000571a:	05890513          	addi	a0,s2,88
    8000571e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005720:	6294                	ld	a3,0(a3)
    80005722:	96ba                	add	a3,a3,a4
    80005724:	40000613          	li	a2,1024
    80005728:	c690                	sw	a2,8(a3)
  if(write)
    8000572a:	140d0063          	beqz	s10,8000586a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000572e:	00018697          	auipc	a3,0x18
    80005732:	8d26b683          	ld	a3,-1838(a3) # 8001d000 <disk+0x2000>
    80005736:	96ba                	add	a3,a3,a4
    80005738:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000573c:	00016817          	auipc	a6,0x16
    80005740:	8c480813          	addi	a6,a6,-1852 # 8001b000 <disk>
    80005744:	00018517          	auipc	a0,0x18
    80005748:	8bc50513          	addi	a0,a0,-1860 # 8001d000 <disk+0x2000>
    8000574c:	6114                	ld	a3,0(a0)
    8000574e:	96ba                	add	a3,a3,a4
    80005750:	00c6d603          	lhu	a2,12(a3)
    80005754:	00166613          	ori	a2,a2,1
    80005758:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000575c:	f9842683          	lw	a3,-104(s0)
    80005760:	6110                	ld	a2,0(a0)
    80005762:	9732                	add	a4,a4,a2
    80005764:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005768:	20058613          	addi	a2,a1,512
    8000576c:	0612                	slli	a2,a2,0x4
    8000576e:	9642                	add	a2,a2,a6
    80005770:	577d                	li	a4,-1
    80005772:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005776:	00469713          	slli	a4,a3,0x4
    8000577a:	6114                	ld	a3,0(a0)
    8000577c:	96ba                	add	a3,a3,a4
    8000577e:	03078793          	addi	a5,a5,48
    80005782:	97c2                	add	a5,a5,a6
    80005784:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005786:	611c                	ld	a5,0(a0)
    80005788:	97ba                	add	a5,a5,a4
    8000578a:	4685                	li	a3,1
    8000578c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000578e:	611c                	ld	a5,0(a0)
    80005790:	97ba                	add	a5,a5,a4
    80005792:	4809                	li	a6,2
    80005794:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005798:	611c                	ld	a5,0(a0)
    8000579a:	973e                	add	a4,a4,a5
    8000579c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057a0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800057a4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057a8:	6518                	ld	a4,8(a0)
    800057aa:	00275783          	lhu	a5,2(a4)
    800057ae:	8b9d                	andi	a5,a5,7
    800057b0:	0786                	slli	a5,a5,0x1
    800057b2:	97ba                	add	a5,a5,a4
    800057b4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057b8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057bc:	6518                	ld	a4,8(a0)
    800057be:	00275783          	lhu	a5,2(a4)
    800057c2:	2785                	addiw	a5,a5,1
    800057c4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057c8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057cc:	100017b7          	lui	a5,0x10001
    800057d0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057d4:	00492703          	lw	a4,4(s2)
    800057d8:	4785                	li	a5,1
    800057da:	02f71163          	bne	a4,a5,800057fc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800057de:	00018997          	auipc	s3,0x18
    800057e2:	94a98993          	addi	s3,s3,-1718 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800057e6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057e8:	85ce                	mv	a1,s3
    800057ea:	854a                	mv	a0,s2
    800057ec:	ffffc097          	auipc	ra,0xffffc
    800057f0:	016080e7          	jalr	22(ra) # 80001802 <sleep>
  while(b->disk == 1) {
    800057f4:	00492783          	lw	a5,4(s2)
    800057f8:	fe9788e3          	beq	a5,s1,800057e8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800057fc:	f9042903          	lw	s2,-112(s0)
    80005800:	20090793          	addi	a5,s2,512
    80005804:	00479713          	slli	a4,a5,0x4
    80005808:	00015797          	auipc	a5,0x15
    8000580c:	7f878793          	addi	a5,a5,2040 # 8001b000 <disk>
    80005810:	97ba                	add	a5,a5,a4
    80005812:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005816:	00017997          	auipc	s3,0x17
    8000581a:	7ea98993          	addi	s3,s3,2026 # 8001d000 <disk+0x2000>
    8000581e:	00491713          	slli	a4,s2,0x4
    80005822:	0009b783          	ld	a5,0(s3)
    80005826:	97ba                	add	a5,a5,a4
    80005828:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000582c:	854a                	mv	a0,s2
    8000582e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005832:	00000097          	auipc	ra,0x0
    80005836:	bc4080e7          	jalr	-1084(ra) # 800053f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000583a:	8885                	andi	s1,s1,1
    8000583c:	f0ed                	bnez	s1,8000581e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000583e:	00018517          	auipc	a0,0x18
    80005842:	8ea50513          	addi	a0,a0,-1814 # 8001d128 <disk+0x2128>
    80005846:	00001097          	auipc	ra,0x1
    8000584a:	c50080e7          	jalr	-944(ra) # 80006496 <release>
}
    8000584e:	70a6                	ld	ra,104(sp)
    80005850:	7406                	ld	s0,96(sp)
    80005852:	64e6                	ld	s1,88(sp)
    80005854:	6946                	ld	s2,80(sp)
    80005856:	69a6                	ld	s3,72(sp)
    80005858:	6a06                	ld	s4,64(sp)
    8000585a:	7ae2                	ld	s5,56(sp)
    8000585c:	7b42                	ld	s6,48(sp)
    8000585e:	7ba2                	ld	s7,40(sp)
    80005860:	7c02                	ld	s8,32(sp)
    80005862:	6ce2                	ld	s9,24(sp)
    80005864:	6d42                	ld	s10,16(sp)
    80005866:	6165                	addi	sp,sp,112
    80005868:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000586a:	00017697          	auipc	a3,0x17
    8000586e:	7966b683          	ld	a3,1942(a3) # 8001d000 <disk+0x2000>
    80005872:	96ba                	add	a3,a3,a4
    80005874:	4609                	li	a2,2
    80005876:	00c69623          	sh	a2,12(a3)
    8000587a:	b5c9                	j	8000573c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000587c:	f9042583          	lw	a1,-112(s0)
    80005880:	20058793          	addi	a5,a1,512
    80005884:	0792                	slli	a5,a5,0x4
    80005886:	00016517          	auipc	a0,0x16
    8000588a:	82250513          	addi	a0,a0,-2014 # 8001b0a8 <disk+0xa8>
    8000588e:	953e                	add	a0,a0,a5
  if(write)
    80005890:	e20d11e3          	bnez	s10,800056b2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005894:	20058713          	addi	a4,a1,512
    80005898:	00471693          	slli	a3,a4,0x4
    8000589c:	00015717          	auipc	a4,0x15
    800058a0:	76470713          	addi	a4,a4,1892 # 8001b000 <disk>
    800058a4:	9736                	add	a4,a4,a3
    800058a6:	0a072423          	sw	zero,168(a4)
    800058aa:	b505                	j	800056ca <virtio_disk_rw+0xf4>

00000000800058ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058ac:	1101                	addi	sp,sp,-32
    800058ae:	ec06                	sd	ra,24(sp)
    800058b0:	e822                	sd	s0,16(sp)
    800058b2:	e426                	sd	s1,8(sp)
    800058b4:	e04a                	sd	s2,0(sp)
    800058b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058b8:	00018517          	auipc	a0,0x18
    800058bc:	87050513          	addi	a0,a0,-1936 # 8001d128 <disk+0x2128>
    800058c0:	00001097          	auipc	ra,0x1
    800058c4:	b22080e7          	jalr	-1246(ra) # 800063e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058c8:	10001737          	lui	a4,0x10001
    800058cc:	533c                	lw	a5,96(a4)
    800058ce:	8b8d                	andi	a5,a5,3
    800058d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058d6:	00017797          	auipc	a5,0x17
    800058da:	72a78793          	addi	a5,a5,1834 # 8001d000 <disk+0x2000>
    800058de:	6b94                	ld	a3,16(a5)
    800058e0:	0207d703          	lhu	a4,32(a5)
    800058e4:	0026d783          	lhu	a5,2(a3)
    800058e8:	06f70163          	beq	a4,a5,8000594a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058ec:	00015917          	auipc	s2,0x15
    800058f0:	71490913          	addi	s2,s2,1812 # 8001b000 <disk>
    800058f4:	00017497          	auipc	s1,0x17
    800058f8:	70c48493          	addi	s1,s1,1804 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800058fc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005900:	6898                	ld	a4,16(s1)
    80005902:	0204d783          	lhu	a5,32(s1)
    80005906:	8b9d                	andi	a5,a5,7
    80005908:	078e                	slli	a5,a5,0x3
    8000590a:	97ba                	add	a5,a5,a4
    8000590c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000590e:	20078713          	addi	a4,a5,512
    80005912:	0712                	slli	a4,a4,0x4
    80005914:	974a                	add	a4,a4,s2
    80005916:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000591a:	e731                	bnez	a4,80005966 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000591c:	20078793          	addi	a5,a5,512
    80005920:	0792                	slli	a5,a5,0x4
    80005922:	97ca                	add	a5,a5,s2
    80005924:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005926:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	064080e7          	jalr	100(ra) # 8000198e <wakeup>

    disk.used_idx += 1;
    80005932:	0204d783          	lhu	a5,32(s1)
    80005936:	2785                	addiw	a5,a5,1
    80005938:	17c2                	slli	a5,a5,0x30
    8000593a:	93c1                	srli	a5,a5,0x30
    8000593c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005940:	6898                	ld	a4,16(s1)
    80005942:	00275703          	lhu	a4,2(a4)
    80005946:	faf71be3          	bne	a4,a5,800058fc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000594a:	00017517          	auipc	a0,0x17
    8000594e:	7de50513          	addi	a0,a0,2014 # 8001d128 <disk+0x2128>
    80005952:	00001097          	auipc	ra,0x1
    80005956:	b44080e7          	jalr	-1212(ra) # 80006496 <release>
}
    8000595a:	60e2                	ld	ra,24(sp)
    8000595c:	6442                	ld	s0,16(sp)
    8000595e:	64a2                	ld	s1,8(sp)
    80005960:	6902                	ld	s2,0(sp)
    80005962:	6105                	addi	sp,sp,32
    80005964:	8082                	ret
      panic("virtio_disk_intr status");
    80005966:	00003517          	auipc	a0,0x3
    8000596a:	e6a50513          	addi	a0,a0,-406 # 800087d0 <syscalls+0x3b0>
    8000596e:	00000097          	auipc	ra,0x0
    80005972:	52a080e7          	jalr	1322(ra) # 80005e98 <panic>

0000000080005976 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005976:	1141                	addi	sp,sp,-16
    80005978:	e422                	sd	s0,8(sp)
    8000597a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000597c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005980:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005984:	0037979b          	slliw	a5,a5,0x3
    80005988:	02004737          	lui	a4,0x2004
    8000598c:	97ba                	add	a5,a5,a4
    8000598e:	0200c737          	lui	a4,0x200c
    80005992:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005996:	000f4637          	lui	a2,0xf4
    8000599a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000599e:	95b2                	add	a1,a1,a2
    800059a0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059a2:	00269713          	slli	a4,a3,0x2
    800059a6:	9736                	add	a4,a4,a3
    800059a8:	00371693          	slli	a3,a4,0x3
    800059ac:	00018717          	auipc	a4,0x18
    800059b0:	65470713          	addi	a4,a4,1620 # 8001e000 <timer_scratch>
    800059b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059be:	00000797          	auipc	a5,0x0
    800059c2:	97278793          	addi	a5,a5,-1678 # 80005330 <timervec>
    800059c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059de:	30479073          	csrw	mie,a5
}
    800059e2:	6422                	ld	s0,8(sp)
    800059e4:	0141                	addi	sp,sp,16
    800059e6:	8082                	ret

00000000800059e8 <start>:
{
    800059e8:	1141                	addi	sp,sp,-16
    800059ea:	e406                	sd	ra,8(sp)
    800059ec:	e022                	sd	s0,0(sp)
    800059ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059f4:	7779                	lui	a4,0xffffe
    800059f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800059fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059fc:	6705                	lui	a4,0x1
    800059fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a02:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a04:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a08:	ffffb797          	auipc	a5,0xffffb
    80005a0c:	b1a78793          	addi	a5,a5,-1254 # 80000522 <main>
    80005a10:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a14:	4781                	li	a5,0
    80005a16:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a1a:	67c1                	lui	a5,0x10
    80005a1c:	17fd                	addi	a5,a5,-1
    80005a1e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a22:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a26:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a2a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a2e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a32:	57fd                	li	a5,-1
    80005a34:	83a9                	srli	a5,a5,0xa
    80005a36:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a3a:	47bd                	li	a5,15
    80005a3c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	f36080e7          	jalr	-202(ra) # 80005976 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a48:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a4c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a4e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a50:	30200073          	mret
}
    80005a54:	60a2                	ld	ra,8(sp)
    80005a56:	6402                	ld	s0,0(sp)
    80005a58:	0141                	addi	sp,sp,16
    80005a5a:	8082                	ret

0000000080005a5c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a5c:	715d                	addi	sp,sp,-80
    80005a5e:	e486                	sd	ra,72(sp)
    80005a60:	e0a2                	sd	s0,64(sp)
    80005a62:	fc26                	sd	s1,56(sp)
    80005a64:	f84a                	sd	s2,48(sp)
    80005a66:	f44e                	sd	s3,40(sp)
    80005a68:	f052                	sd	s4,32(sp)
    80005a6a:	ec56                	sd	s5,24(sp)
    80005a6c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a6e:	04c05663          	blez	a2,80005aba <consolewrite+0x5e>
    80005a72:	8a2a                	mv	s4,a0
    80005a74:	84ae                	mv	s1,a1
    80005a76:	89b2                	mv	s3,a2
    80005a78:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a7a:	5afd                	li	s5,-1
    80005a7c:	4685                	li	a3,1
    80005a7e:	8626                	mv	a2,s1
    80005a80:	85d2                	mv	a1,s4
    80005a82:	fbf40513          	addi	a0,s0,-65
    80005a86:	ffffc097          	auipc	ra,0xffffc
    80005a8a:	176080e7          	jalr	374(ra) # 80001bfc <either_copyin>
    80005a8e:	01550c63          	beq	a0,s5,80005aa6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a92:	fbf44503          	lbu	a0,-65(s0)
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	78e080e7          	jalr	1934(ra) # 80006224 <uartputc>
  for(i = 0; i < n; i++){
    80005a9e:	2905                	addiw	s2,s2,1
    80005aa0:	0485                	addi	s1,s1,1
    80005aa2:	fd299de3          	bne	s3,s2,80005a7c <consolewrite+0x20>
  }

  return i;
}
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	60a6                	ld	ra,72(sp)
    80005aaa:	6406                	ld	s0,64(sp)
    80005aac:	74e2                	ld	s1,56(sp)
    80005aae:	7942                	ld	s2,48(sp)
    80005ab0:	79a2                	ld	s3,40(sp)
    80005ab2:	7a02                	ld	s4,32(sp)
    80005ab4:	6ae2                	ld	s5,24(sp)
    80005ab6:	6161                	addi	sp,sp,80
    80005ab8:	8082                	ret
  for(i = 0; i < n; i++){
    80005aba:	4901                	li	s2,0
    80005abc:	b7ed                	j	80005aa6 <consolewrite+0x4a>

0000000080005abe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005abe:	7119                	addi	sp,sp,-128
    80005ac0:	fc86                	sd	ra,120(sp)
    80005ac2:	f8a2                	sd	s0,112(sp)
    80005ac4:	f4a6                	sd	s1,104(sp)
    80005ac6:	f0ca                	sd	s2,96(sp)
    80005ac8:	ecce                	sd	s3,88(sp)
    80005aca:	e8d2                	sd	s4,80(sp)
    80005acc:	e4d6                	sd	s5,72(sp)
    80005ace:	e0da                	sd	s6,64(sp)
    80005ad0:	fc5e                	sd	s7,56(sp)
    80005ad2:	f862                	sd	s8,48(sp)
    80005ad4:	f466                	sd	s9,40(sp)
    80005ad6:	f06a                	sd	s10,32(sp)
    80005ad8:	ec6e                	sd	s11,24(sp)
    80005ada:	0100                	addi	s0,sp,128
    80005adc:	8b2a                	mv	s6,a0
    80005ade:	8aae                	mv	s5,a1
    80005ae0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ae2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005ae6:	00020517          	auipc	a0,0x20
    80005aea:	65a50513          	addi	a0,a0,1626 # 80026140 <cons>
    80005aee:	00001097          	auipc	ra,0x1
    80005af2:	8f4080e7          	jalr	-1804(ra) # 800063e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005af6:	00020497          	auipc	s1,0x20
    80005afa:	64a48493          	addi	s1,s1,1610 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005afe:	89a6                	mv	s3,s1
    80005b00:	00020917          	auipc	s2,0x20
    80005b04:	6d890913          	addi	s2,s2,1752 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005b08:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b0a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b0c:	4da9                	li	s11,10
  while(n > 0){
    80005b0e:	07405863          	blez	s4,80005b7e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005b12:	0984a783          	lw	a5,152(s1)
    80005b16:	09c4a703          	lw	a4,156(s1)
    80005b1a:	02f71463          	bne	a4,a5,80005b42 <consoleread+0x84>
      if(myproc()->killed){
    80005b1e:	ffffb097          	auipc	ra,0xffffb
    80005b22:	628080e7          	jalr	1576(ra) # 80001146 <myproc>
    80005b26:	551c                	lw	a5,40(a0)
    80005b28:	e7b5                	bnez	a5,80005b94 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005b2a:	85ce                	mv	a1,s3
    80005b2c:	854a                	mv	a0,s2
    80005b2e:	ffffc097          	auipc	ra,0xffffc
    80005b32:	cd4080e7          	jalr	-812(ra) # 80001802 <sleep>
    while(cons.r == cons.w){
    80005b36:	0984a783          	lw	a5,152(s1)
    80005b3a:	09c4a703          	lw	a4,156(s1)
    80005b3e:	fef700e3          	beq	a4,a5,80005b1e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b42:	0017871b          	addiw	a4,a5,1
    80005b46:	08e4ac23          	sw	a4,152(s1)
    80005b4a:	07f7f713          	andi	a4,a5,127
    80005b4e:	9726                	add	a4,a4,s1
    80005b50:	01874703          	lbu	a4,24(a4)
    80005b54:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b58:	079c0663          	beq	s8,s9,80005bc4 <consoleread+0x106>
    cbuf = c;
    80005b5c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b60:	4685                	li	a3,1
    80005b62:	f8f40613          	addi	a2,s0,-113
    80005b66:	85d6                	mv	a1,s5
    80005b68:	855a                	mv	a0,s6
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	03c080e7          	jalr	60(ra) # 80001ba6 <either_copyout>
    80005b72:	01a50663          	beq	a0,s10,80005b7e <consoleread+0xc0>
    dst++;
    80005b76:	0a85                	addi	s5,s5,1
    --n;
    80005b78:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b7a:	f9bc1ae3          	bne	s8,s11,80005b0e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b7e:	00020517          	auipc	a0,0x20
    80005b82:	5c250513          	addi	a0,a0,1474 # 80026140 <cons>
    80005b86:	00001097          	auipc	ra,0x1
    80005b8a:	910080e7          	jalr	-1776(ra) # 80006496 <release>

  return target - n;
    80005b8e:	414b853b          	subw	a0,s7,s4
    80005b92:	a811                	j	80005ba6 <consoleread+0xe8>
        release(&cons.lock);
    80005b94:	00020517          	auipc	a0,0x20
    80005b98:	5ac50513          	addi	a0,a0,1452 # 80026140 <cons>
    80005b9c:	00001097          	auipc	ra,0x1
    80005ba0:	8fa080e7          	jalr	-1798(ra) # 80006496 <release>
        return -1;
    80005ba4:	557d                	li	a0,-1
}
    80005ba6:	70e6                	ld	ra,120(sp)
    80005ba8:	7446                	ld	s0,112(sp)
    80005baa:	74a6                	ld	s1,104(sp)
    80005bac:	7906                	ld	s2,96(sp)
    80005bae:	69e6                	ld	s3,88(sp)
    80005bb0:	6a46                	ld	s4,80(sp)
    80005bb2:	6aa6                	ld	s5,72(sp)
    80005bb4:	6b06                	ld	s6,64(sp)
    80005bb6:	7be2                	ld	s7,56(sp)
    80005bb8:	7c42                	ld	s8,48(sp)
    80005bba:	7ca2                	ld	s9,40(sp)
    80005bbc:	7d02                	ld	s10,32(sp)
    80005bbe:	6de2                	ld	s11,24(sp)
    80005bc0:	6109                	addi	sp,sp,128
    80005bc2:	8082                	ret
      if(n < target){
    80005bc4:	000a071b          	sext.w	a4,s4
    80005bc8:	fb777be3          	bgeu	a4,s7,80005b7e <consoleread+0xc0>
        cons.r--;
    80005bcc:	00020717          	auipc	a4,0x20
    80005bd0:	60f72623          	sw	a5,1548(a4) # 800261d8 <cons+0x98>
    80005bd4:	b76d                	j	80005b7e <consoleread+0xc0>

0000000080005bd6 <consputc>:
{
    80005bd6:	1141                	addi	sp,sp,-16
    80005bd8:	e406                	sd	ra,8(sp)
    80005bda:	e022                	sd	s0,0(sp)
    80005bdc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bde:	10000793          	li	a5,256
    80005be2:	00f50a63          	beq	a0,a5,80005bf6 <consputc+0x20>
    uartputc_sync(c);
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	564080e7          	jalr	1380(ra) # 8000614a <uartputc_sync>
}
    80005bee:	60a2                	ld	ra,8(sp)
    80005bf0:	6402                	ld	s0,0(sp)
    80005bf2:	0141                	addi	sp,sp,16
    80005bf4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005bf6:	4521                	li	a0,8
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	552080e7          	jalr	1362(ra) # 8000614a <uartputc_sync>
    80005c00:	02000513          	li	a0,32
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	546080e7          	jalr	1350(ra) # 8000614a <uartputc_sync>
    80005c0c:	4521                	li	a0,8
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	53c080e7          	jalr	1340(ra) # 8000614a <uartputc_sync>
    80005c16:	bfe1                	j	80005bee <consputc+0x18>

0000000080005c18 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c18:	1101                	addi	sp,sp,-32
    80005c1a:	ec06                	sd	ra,24(sp)
    80005c1c:	e822                	sd	s0,16(sp)
    80005c1e:	e426                	sd	s1,8(sp)
    80005c20:	e04a                	sd	s2,0(sp)
    80005c22:	1000                	addi	s0,sp,32
    80005c24:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c26:	00020517          	auipc	a0,0x20
    80005c2a:	51a50513          	addi	a0,a0,1306 # 80026140 <cons>
    80005c2e:	00000097          	auipc	ra,0x0
    80005c32:	7b4080e7          	jalr	1972(ra) # 800063e2 <acquire>

  switch(c){
    80005c36:	47d5                	li	a5,21
    80005c38:	0af48663          	beq	s1,a5,80005ce4 <consoleintr+0xcc>
    80005c3c:	0297ca63          	blt	a5,s1,80005c70 <consoleintr+0x58>
    80005c40:	47a1                	li	a5,8
    80005c42:	0ef48763          	beq	s1,a5,80005d30 <consoleintr+0x118>
    80005c46:	47c1                	li	a5,16
    80005c48:	10f49a63          	bne	s1,a5,80005d5c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c4c:	ffffc097          	auipc	ra,0xffffc
    80005c50:	006080e7          	jalr	6(ra) # 80001c52 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c54:	00020517          	auipc	a0,0x20
    80005c58:	4ec50513          	addi	a0,a0,1260 # 80026140 <cons>
    80005c5c:	00001097          	auipc	ra,0x1
    80005c60:	83a080e7          	jalr	-1990(ra) # 80006496 <release>
}
    80005c64:	60e2                	ld	ra,24(sp)
    80005c66:	6442                	ld	s0,16(sp)
    80005c68:	64a2                	ld	s1,8(sp)
    80005c6a:	6902                	ld	s2,0(sp)
    80005c6c:	6105                	addi	sp,sp,32
    80005c6e:	8082                	ret
  switch(c){
    80005c70:	07f00793          	li	a5,127
    80005c74:	0af48e63          	beq	s1,a5,80005d30 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c78:	00020717          	auipc	a4,0x20
    80005c7c:	4c870713          	addi	a4,a4,1224 # 80026140 <cons>
    80005c80:	0a072783          	lw	a5,160(a4)
    80005c84:	09872703          	lw	a4,152(a4)
    80005c88:	9f99                	subw	a5,a5,a4
    80005c8a:	07f00713          	li	a4,127
    80005c8e:	fcf763e3          	bltu	a4,a5,80005c54 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c92:	47b5                	li	a5,13
    80005c94:	0cf48763          	beq	s1,a5,80005d62 <consoleintr+0x14a>
      consputc(c);
    80005c98:	8526                	mv	a0,s1
    80005c9a:	00000097          	auipc	ra,0x0
    80005c9e:	f3c080e7          	jalr	-196(ra) # 80005bd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ca2:	00020797          	auipc	a5,0x20
    80005ca6:	49e78793          	addi	a5,a5,1182 # 80026140 <cons>
    80005caa:	0a07a703          	lw	a4,160(a5)
    80005cae:	0017069b          	addiw	a3,a4,1
    80005cb2:	0006861b          	sext.w	a2,a3
    80005cb6:	0ad7a023          	sw	a3,160(a5)
    80005cba:	07f77713          	andi	a4,a4,127
    80005cbe:	97ba                	add	a5,a5,a4
    80005cc0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cc4:	47a9                	li	a5,10
    80005cc6:	0cf48563          	beq	s1,a5,80005d90 <consoleintr+0x178>
    80005cca:	4791                	li	a5,4
    80005ccc:	0cf48263          	beq	s1,a5,80005d90 <consoleintr+0x178>
    80005cd0:	00020797          	auipc	a5,0x20
    80005cd4:	5087a783          	lw	a5,1288(a5) # 800261d8 <cons+0x98>
    80005cd8:	0807879b          	addiw	a5,a5,128
    80005cdc:	f6f61ce3          	bne	a2,a5,80005c54 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ce0:	863e                	mv	a2,a5
    80005ce2:	a07d                	j	80005d90 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ce4:	00020717          	auipc	a4,0x20
    80005ce8:	45c70713          	addi	a4,a4,1116 # 80026140 <cons>
    80005cec:	0a072783          	lw	a5,160(a4)
    80005cf0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cf4:	00020497          	auipc	s1,0x20
    80005cf8:	44c48493          	addi	s1,s1,1100 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005cfc:	4929                	li	s2,10
    80005cfe:	f4f70be3          	beq	a4,a5,80005c54 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d02:	37fd                	addiw	a5,a5,-1
    80005d04:	07f7f713          	andi	a4,a5,127
    80005d08:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d0a:	01874703          	lbu	a4,24(a4)
    80005d0e:	f52703e3          	beq	a4,s2,80005c54 <consoleintr+0x3c>
      cons.e--;
    80005d12:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d16:	10000513          	li	a0,256
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	ebc080e7          	jalr	-324(ra) # 80005bd6 <consputc>
    while(cons.e != cons.w &&
    80005d22:	0a04a783          	lw	a5,160(s1)
    80005d26:	09c4a703          	lw	a4,156(s1)
    80005d2a:	fcf71ce3          	bne	a4,a5,80005d02 <consoleintr+0xea>
    80005d2e:	b71d                	j	80005c54 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d30:	00020717          	auipc	a4,0x20
    80005d34:	41070713          	addi	a4,a4,1040 # 80026140 <cons>
    80005d38:	0a072783          	lw	a5,160(a4)
    80005d3c:	09c72703          	lw	a4,156(a4)
    80005d40:	f0f70ae3          	beq	a4,a5,80005c54 <consoleintr+0x3c>
      cons.e--;
    80005d44:	37fd                	addiw	a5,a5,-1
    80005d46:	00020717          	auipc	a4,0x20
    80005d4a:	48f72d23          	sw	a5,1178(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d4e:	10000513          	li	a0,256
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	e84080e7          	jalr	-380(ra) # 80005bd6 <consputc>
    80005d5a:	bded                	j	80005c54 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d5c:	ee048ce3          	beqz	s1,80005c54 <consoleintr+0x3c>
    80005d60:	bf21                	j	80005c78 <consoleintr+0x60>
      consputc(c);
    80005d62:	4529                	li	a0,10
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	e72080e7          	jalr	-398(ra) # 80005bd6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d6c:	00020797          	auipc	a5,0x20
    80005d70:	3d478793          	addi	a5,a5,980 # 80026140 <cons>
    80005d74:	0a07a703          	lw	a4,160(a5)
    80005d78:	0017069b          	addiw	a3,a4,1
    80005d7c:	0006861b          	sext.w	a2,a3
    80005d80:	0ad7a023          	sw	a3,160(a5)
    80005d84:	07f77713          	andi	a4,a4,127
    80005d88:	97ba                	add	a5,a5,a4
    80005d8a:	4729                	li	a4,10
    80005d8c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d90:	00020797          	auipc	a5,0x20
    80005d94:	44c7a623          	sw	a2,1100(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005d98:	00020517          	auipc	a0,0x20
    80005d9c:	44050513          	addi	a0,a0,1088 # 800261d8 <cons+0x98>
    80005da0:	ffffc097          	auipc	ra,0xffffc
    80005da4:	bee080e7          	jalr	-1042(ra) # 8000198e <wakeup>
    80005da8:	b575                	j	80005c54 <consoleintr+0x3c>

0000000080005daa <consoleinit>:

void
consoleinit(void)
{
    80005daa:	1141                	addi	sp,sp,-16
    80005dac:	e406                	sd	ra,8(sp)
    80005dae:	e022                	sd	s0,0(sp)
    80005db0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005db2:	00003597          	auipc	a1,0x3
    80005db6:	a3658593          	addi	a1,a1,-1482 # 800087e8 <syscalls+0x3c8>
    80005dba:	00020517          	auipc	a0,0x20
    80005dbe:	38650513          	addi	a0,a0,902 # 80026140 <cons>
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	590080e7          	jalr	1424(ra) # 80006352 <initlock>

  uartinit();
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	330080e7          	jalr	816(ra) # 800060fa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dd2:	00013797          	auipc	a5,0x13
    80005dd6:	30e78793          	addi	a5,a5,782 # 800190e0 <devsw>
    80005dda:	00000717          	auipc	a4,0x0
    80005dde:	ce470713          	addi	a4,a4,-796 # 80005abe <consoleread>
    80005de2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005de4:	00000717          	auipc	a4,0x0
    80005de8:	c7870713          	addi	a4,a4,-904 # 80005a5c <consolewrite>
    80005dec:	ef98                	sd	a4,24(a5)
}
    80005dee:	60a2                	ld	ra,8(sp)
    80005df0:	6402                	ld	s0,0(sp)
    80005df2:	0141                	addi	sp,sp,16
    80005df4:	8082                	ret

0000000080005df6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005df6:	7179                	addi	sp,sp,-48
    80005df8:	f406                	sd	ra,40(sp)
    80005dfa:	f022                	sd	s0,32(sp)
    80005dfc:	ec26                	sd	s1,24(sp)
    80005dfe:	e84a                	sd	s2,16(sp)
    80005e00:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e02:	c219                	beqz	a2,80005e08 <printint+0x12>
    80005e04:	08054663          	bltz	a0,80005e90 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005e08:	2501                	sext.w	a0,a0
    80005e0a:	4881                	li	a7,0
    80005e0c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e10:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e12:	2581                	sext.w	a1,a1
    80005e14:	00003617          	auipc	a2,0x3
    80005e18:	a0460613          	addi	a2,a2,-1532 # 80008818 <digits>
    80005e1c:	883a                	mv	a6,a4
    80005e1e:	2705                	addiw	a4,a4,1
    80005e20:	02b577bb          	remuw	a5,a0,a1
    80005e24:	1782                	slli	a5,a5,0x20
    80005e26:	9381                	srli	a5,a5,0x20
    80005e28:	97b2                	add	a5,a5,a2
    80005e2a:	0007c783          	lbu	a5,0(a5)
    80005e2e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e32:	0005079b          	sext.w	a5,a0
    80005e36:	02b5553b          	divuw	a0,a0,a1
    80005e3a:	0685                	addi	a3,a3,1
    80005e3c:	feb7f0e3          	bgeu	a5,a1,80005e1c <printint+0x26>

  if(sign)
    80005e40:	00088b63          	beqz	a7,80005e56 <printint+0x60>
    buf[i++] = '-';
    80005e44:	fe040793          	addi	a5,s0,-32
    80005e48:	973e                	add	a4,a4,a5
    80005e4a:	02d00793          	li	a5,45
    80005e4e:	fef70823          	sb	a5,-16(a4)
    80005e52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e56:	02e05763          	blez	a4,80005e84 <printint+0x8e>
    80005e5a:	fd040793          	addi	a5,s0,-48
    80005e5e:	00e784b3          	add	s1,a5,a4
    80005e62:	fff78913          	addi	s2,a5,-1
    80005e66:	993a                	add	s2,s2,a4
    80005e68:	377d                	addiw	a4,a4,-1
    80005e6a:	1702                	slli	a4,a4,0x20
    80005e6c:	9301                	srli	a4,a4,0x20
    80005e6e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e72:	fff4c503          	lbu	a0,-1(s1)
    80005e76:	00000097          	auipc	ra,0x0
    80005e7a:	d60080e7          	jalr	-672(ra) # 80005bd6 <consputc>
  while(--i >= 0)
    80005e7e:	14fd                	addi	s1,s1,-1
    80005e80:	ff2499e3          	bne	s1,s2,80005e72 <printint+0x7c>
}
    80005e84:	70a2                	ld	ra,40(sp)
    80005e86:	7402                	ld	s0,32(sp)
    80005e88:	64e2                	ld	s1,24(sp)
    80005e8a:	6942                	ld	s2,16(sp)
    80005e8c:	6145                	addi	sp,sp,48
    80005e8e:	8082                	ret
    x = -xx;
    80005e90:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e94:	4885                	li	a7,1
    x = -xx;
    80005e96:	bf9d                	j	80005e0c <printint+0x16>

0000000080005e98 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	1000                	addi	s0,sp,32
    80005ea2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ea4:	00020797          	auipc	a5,0x20
    80005ea8:	3407ae23          	sw	zero,860(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005eac:	00003517          	auipc	a0,0x3
    80005eb0:	94450513          	addi	a0,a0,-1724 # 800087f0 <syscalls+0x3d0>
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	02e080e7          	jalr	46(ra) # 80005ee2 <printf>
  printf(s);
    80005ebc:	8526                	mv	a0,s1
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	024080e7          	jalr	36(ra) # 80005ee2 <printf>
  printf("\n");
    80005ec6:	00002517          	auipc	a0,0x2
    80005eca:	2c250513          	addi	a0,a0,706 # 80008188 <etext+0x188>
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	014080e7          	jalr	20(ra) # 80005ee2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ed6:	4785                	li	a5,1
    80005ed8:	00003717          	auipc	a4,0x3
    80005edc:	14f72223          	sw	a5,324(a4) # 8000901c <panicked>
  for(;;)
    80005ee0:	a001                	j	80005ee0 <panic+0x48>

0000000080005ee2 <printf>:
{
    80005ee2:	7131                	addi	sp,sp,-192
    80005ee4:	fc86                	sd	ra,120(sp)
    80005ee6:	f8a2                	sd	s0,112(sp)
    80005ee8:	f4a6                	sd	s1,104(sp)
    80005eea:	f0ca                	sd	s2,96(sp)
    80005eec:	ecce                	sd	s3,88(sp)
    80005eee:	e8d2                	sd	s4,80(sp)
    80005ef0:	e4d6                	sd	s5,72(sp)
    80005ef2:	e0da                	sd	s6,64(sp)
    80005ef4:	fc5e                	sd	s7,56(sp)
    80005ef6:	f862                	sd	s8,48(sp)
    80005ef8:	f466                	sd	s9,40(sp)
    80005efa:	f06a                	sd	s10,32(sp)
    80005efc:	ec6e                	sd	s11,24(sp)
    80005efe:	0100                	addi	s0,sp,128
    80005f00:	8a2a                	mv	s4,a0
    80005f02:	e40c                	sd	a1,8(s0)
    80005f04:	e810                	sd	a2,16(s0)
    80005f06:	ec14                	sd	a3,24(s0)
    80005f08:	f018                	sd	a4,32(s0)
    80005f0a:	f41c                	sd	a5,40(s0)
    80005f0c:	03043823          	sd	a6,48(s0)
    80005f10:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f14:	00020d97          	auipc	s11,0x20
    80005f18:	2ecdad83          	lw	s11,748(s11) # 80026200 <pr+0x18>
  if(locking)
    80005f1c:	020d9b63          	bnez	s11,80005f52 <printf+0x70>
  if (fmt == 0)
    80005f20:	040a0263          	beqz	s4,80005f64 <printf+0x82>
  va_start(ap, fmt);
    80005f24:	00840793          	addi	a5,s0,8
    80005f28:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f2c:	000a4503          	lbu	a0,0(s4)
    80005f30:	16050263          	beqz	a0,80006094 <printf+0x1b2>
    80005f34:	4481                	li	s1,0
    if(c != '%'){
    80005f36:	02500a93          	li	s5,37
    switch(c){
    80005f3a:	07000b13          	li	s6,112
  consputc('x');
    80005f3e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f40:	00003b97          	auipc	s7,0x3
    80005f44:	8d8b8b93          	addi	s7,s7,-1832 # 80008818 <digits>
    switch(c){
    80005f48:	07300c93          	li	s9,115
    80005f4c:	06400c13          	li	s8,100
    80005f50:	a82d                	j	80005f8a <printf+0xa8>
    acquire(&pr.lock);
    80005f52:	00020517          	auipc	a0,0x20
    80005f56:	29650513          	addi	a0,a0,662 # 800261e8 <pr>
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	488080e7          	jalr	1160(ra) # 800063e2 <acquire>
    80005f62:	bf7d                	j	80005f20 <printf+0x3e>
    panic("null fmt");
    80005f64:	00003517          	auipc	a0,0x3
    80005f68:	89c50513          	addi	a0,a0,-1892 # 80008800 <syscalls+0x3e0>
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	f2c080e7          	jalr	-212(ra) # 80005e98 <panic>
      consputc(c);
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	c62080e7          	jalr	-926(ra) # 80005bd6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f7c:	2485                	addiw	s1,s1,1
    80005f7e:	009a07b3          	add	a5,s4,s1
    80005f82:	0007c503          	lbu	a0,0(a5)
    80005f86:	10050763          	beqz	a0,80006094 <printf+0x1b2>
    if(c != '%'){
    80005f8a:	ff5515e3          	bne	a0,s5,80005f74 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f8e:	2485                	addiw	s1,s1,1
    80005f90:	009a07b3          	add	a5,s4,s1
    80005f94:	0007c783          	lbu	a5,0(a5)
    80005f98:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f9c:	cfe5                	beqz	a5,80006094 <printf+0x1b2>
    switch(c){
    80005f9e:	05678a63          	beq	a5,s6,80005ff2 <printf+0x110>
    80005fa2:	02fb7663          	bgeu	s6,a5,80005fce <printf+0xec>
    80005fa6:	09978963          	beq	a5,s9,80006038 <printf+0x156>
    80005faa:	07800713          	li	a4,120
    80005fae:	0ce79863          	bne	a5,a4,8000607e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005fb2:	f8843783          	ld	a5,-120(s0)
    80005fb6:	00878713          	addi	a4,a5,8
    80005fba:	f8e43423          	sd	a4,-120(s0)
    80005fbe:	4605                	li	a2,1
    80005fc0:	85ea                	mv	a1,s10
    80005fc2:	4388                	lw	a0,0(a5)
    80005fc4:	00000097          	auipc	ra,0x0
    80005fc8:	e32080e7          	jalr	-462(ra) # 80005df6 <printint>
      break;
    80005fcc:	bf45                	j	80005f7c <printf+0x9a>
    switch(c){
    80005fce:	0b578263          	beq	a5,s5,80006072 <printf+0x190>
    80005fd2:	0b879663          	bne	a5,s8,8000607e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fd6:	f8843783          	ld	a5,-120(s0)
    80005fda:	00878713          	addi	a4,a5,8
    80005fde:	f8e43423          	sd	a4,-120(s0)
    80005fe2:	4605                	li	a2,1
    80005fe4:	45a9                	li	a1,10
    80005fe6:	4388                	lw	a0,0(a5)
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	e0e080e7          	jalr	-498(ra) # 80005df6 <printint>
      break;
    80005ff0:	b771                	j	80005f7c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ff2:	f8843783          	ld	a5,-120(s0)
    80005ff6:	00878713          	addi	a4,a5,8
    80005ffa:	f8e43423          	sd	a4,-120(s0)
    80005ffe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006002:	03000513          	li	a0,48
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	bd0080e7          	jalr	-1072(ra) # 80005bd6 <consputc>
  consputc('x');
    8000600e:	07800513          	li	a0,120
    80006012:	00000097          	auipc	ra,0x0
    80006016:	bc4080e7          	jalr	-1084(ra) # 80005bd6 <consputc>
    8000601a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000601c:	03c9d793          	srli	a5,s3,0x3c
    80006020:	97de                	add	a5,a5,s7
    80006022:	0007c503          	lbu	a0,0(a5)
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	bb0080e7          	jalr	-1104(ra) # 80005bd6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000602e:	0992                	slli	s3,s3,0x4
    80006030:	397d                	addiw	s2,s2,-1
    80006032:	fe0915e3          	bnez	s2,8000601c <printf+0x13a>
    80006036:	b799                	j	80005f7c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006038:	f8843783          	ld	a5,-120(s0)
    8000603c:	00878713          	addi	a4,a5,8
    80006040:	f8e43423          	sd	a4,-120(s0)
    80006044:	0007b903          	ld	s2,0(a5)
    80006048:	00090e63          	beqz	s2,80006064 <printf+0x182>
      for(; *s; s++)
    8000604c:	00094503          	lbu	a0,0(s2)
    80006050:	d515                	beqz	a0,80005f7c <printf+0x9a>
        consputc(*s);
    80006052:	00000097          	auipc	ra,0x0
    80006056:	b84080e7          	jalr	-1148(ra) # 80005bd6 <consputc>
      for(; *s; s++)
    8000605a:	0905                	addi	s2,s2,1
    8000605c:	00094503          	lbu	a0,0(s2)
    80006060:	f96d                	bnez	a0,80006052 <printf+0x170>
    80006062:	bf29                	j	80005f7c <printf+0x9a>
        s = "(null)";
    80006064:	00002917          	auipc	s2,0x2
    80006068:	79490913          	addi	s2,s2,1940 # 800087f8 <syscalls+0x3d8>
      for(; *s; s++)
    8000606c:	02800513          	li	a0,40
    80006070:	b7cd                	j	80006052 <printf+0x170>
      consputc('%');
    80006072:	8556                	mv	a0,s5
    80006074:	00000097          	auipc	ra,0x0
    80006078:	b62080e7          	jalr	-1182(ra) # 80005bd6 <consputc>
      break;
    8000607c:	b701                	j	80005f7c <printf+0x9a>
      consputc('%');
    8000607e:	8556                	mv	a0,s5
    80006080:	00000097          	auipc	ra,0x0
    80006084:	b56080e7          	jalr	-1194(ra) # 80005bd6 <consputc>
      consputc(c);
    80006088:	854a                	mv	a0,s2
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	b4c080e7          	jalr	-1204(ra) # 80005bd6 <consputc>
      break;
    80006092:	b5ed                	j	80005f7c <printf+0x9a>
  if(locking)
    80006094:	020d9163          	bnez	s11,800060b6 <printf+0x1d4>
}
    80006098:	70e6                	ld	ra,120(sp)
    8000609a:	7446                	ld	s0,112(sp)
    8000609c:	74a6                	ld	s1,104(sp)
    8000609e:	7906                	ld	s2,96(sp)
    800060a0:	69e6                	ld	s3,88(sp)
    800060a2:	6a46                	ld	s4,80(sp)
    800060a4:	6aa6                	ld	s5,72(sp)
    800060a6:	6b06                	ld	s6,64(sp)
    800060a8:	7be2                	ld	s7,56(sp)
    800060aa:	7c42                	ld	s8,48(sp)
    800060ac:	7ca2                	ld	s9,40(sp)
    800060ae:	7d02                	ld	s10,32(sp)
    800060b0:	6de2                	ld	s11,24(sp)
    800060b2:	6129                	addi	sp,sp,192
    800060b4:	8082                	ret
    release(&pr.lock);
    800060b6:	00020517          	auipc	a0,0x20
    800060ba:	13250513          	addi	a0,a0,306 # 800261e8 <pr>
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	3d8080e7          	jalr	984(ra) # 80006496 <release>
}
    800060c6:	bfc9                	j	80006098 <printf+0x1b6>

00000000800060c8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060c8:	1101                	addi	sp,sp,-32
    800060ca:	ec06                	sd	ra,24(sp)
    800060cc:	e822                	sd	s0,16(sp)
    800060ce:	e426                	sd	s1,8(sp)
    800060d0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060d2:	00020497          	auipc	s1,0x20
    800060d6:	11648493          	addi	s1,s1,278 # 800261e8 <pr>
    800060da:	00002597          	auipc	a1,0x2
    800060de:	73658593          	addi	a1,a1,1846 # 80008810 <syscalls+0x3f0>
    800060e2:	8526                	mv	a0,s1
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	26e080e7          	jalr	622(ra) # 80006352 <initlock>
  pr.locking = 1;
    800060ec:	4785                	li	a5,1
    800060ee:	cc9c                	sw	a5,24(s1)
}
    800060f0:	60e2                	ld	ra,24(sp)
    800060f2:	6442                	ld	s0,16(sp)
    800060f4:	64a2                	ld	s1,8(sp)
    800060f6:	6105                	addi	sp,sp,32
    800060f8:	8082                	ret

00000000800060fa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060fa:	1141                	addi	sp,sp,-16
    800060fc:	e406                	sd	ra,8(sp)
    800060fe:	e022                	sd	s0,0(sp)
    80006100:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006102:	100007b7          	lui	a5,0x10000
    80006106:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000610a:	f8000713          	li	a4,-128
    8000610e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006112:	470d                	li	a4,3
    80006114:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006118:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000611c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006120:	469d                	li	a3,7
    80006122:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006126:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000612a:	00002597          	auipc	a1,0x2
    8000612e:	70658593          	addi	a1,a1,1798 # 80008830 <digits+0x18>
    80006132:	00020517          	auipc	a0,0x20
    80006136:	0d650513          	addi	a0,a0,214 # 80026208 <uart_tx_lock>
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	218080e7          	jalr	536(ra) # 80006352 <initlock>
}
    80006142:	60a2                	ld	ra,8(sp)
    80006144:	6402                	ld	s0,0(sp)
    80006146:	0141                	addi	sp,sp,16
    80006148:	8082                	ret

000000008000614a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000614a:	1101                	addi	sp,sp,-32
    8000614c:	ec06                	sd	ra,24(sp)
    8000614e:	e822                	sd	s0,16(sp)
    80006150:	e426                	sd	s1,8(sp)
    80006152:	1000                	addi	s0,sp,32
    80006154:	84aa                	mv	s1,a0
  push_off();
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	240080e7          	jalr	576(ra) # 80006396 <push_off>

  if(panicked){
    8000615e:	00003797          	auipc	a5,0x3
    80006162:	ebe7a783          	lw	a5,-322(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006166:	10000737          	lui	a4,0x10000
  if(panicked){
    8000616a:	c391                	beqz	a5,8000616e <uartputc_sync+0x24>
    for(;;)
    8000616c:	a001                	j	8000616c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000616e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006172:	0ff7f793          	andi	a5,a5,255
    80006176:	0207f793          	andi	a5,a5,32
    8000617a:	dbf5                	beqz	a5,8000616e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000617c:	0ff4f793          	andi	a5,s1,255
    80006180:	10000737          	lui	a4,0x10000
    80006184:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	2ae080e7          	jalr	686(ra) # 80006436 <pop_off>
}
    80006190:	60e2                	ld	ra,24(sp)
    80006192:	6442                	ld	s0,16(sp)
    80006194:	64a2                	ld	s1,8(sp)
    80006196:	6105                	addi	sp,sp,32
    80006198:	8082                	ret

000000008000619a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000619a:	00003717          	auipc	a4,0x3
    8000619e:	e8673703          	ld	a4,-378(a4) # 80009020 <uart_tx_r>
    800061a2:	00003797          	auipc	a5,0x3
    800061a6:	e867b783          	ld	a5,-378(a5) # 80009028 <uart_tx_w>
    800061aa:	06e78c63          	beq	a5,a4,80006222 <uartstart+0x88>
{
    800061ae:	7139                	addi	sp,sp,-64
    800061b0:	fc06                	sd	ra,56(sp)
    800061b2:	f822                	sd	s0,48(sp)
    800061b4:	f426                	sd	s1,40(sp)
    800061b6:	f04a                	sd	s2,32(sp)
    800061b8:	ec4e                	sd	s3,24(sp)
    800061ba:	e852                	sd	s4,16(sp)
    800061bc:	e456                	sd	s5,8(sp)
    800061be:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061c4:	00020a17          	auipc	s4,0x20
    800061c8:	044a0a13          	addi	s4,s4,68 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800061cc:	00003497          	auipc	s1,0x3
    800061d0:	e5448493          	addi	s1,s1,-428 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061d4:	00003997          	auipc	s3,0x3
    800061d8:	e5498993          	addi	s3,s3,-428 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061dc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061e0:	0ff7f793          	andi	a5,a5,255
    800061e4:	0207f793          	andi	a5,a5,32
    800061e8:	c785                	beqz	a5,80006210 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ea:	01f77793          	andi	a5,a4,31
    800061ee:	97d2                	add	a5,a5,s4
    800061f0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061f4:	0705                	addi	a4,a4,1
    800061f6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061f8:	8526                	mv	a0,s1
    800061fa:	ffffb097          	auipc	ra,0xffffb
    800061fe:	794080e7          	jalr	1940(ra) # 8000198e <wakeup>
    
    WriteReg(THR, c);
    80006202:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006206:	6098                	ld	a4,0(s1)
    80006208:	0009b783          	ld	a5,0(s3)
    8000620c:	fce798e3          	bne	a5,a4,800061dc <uartstart+0x42>
  }
}
    80006210:	70e2                	ld	ra,56(sp)
    80006212:	7442                	ld	s0,48(sp)
    80006214:	74a2                	ld	s1,40(sp)
    80006216:	7902                	ld	s2,32(sp)
    80006218:	69e2                	ld	s3,24(sp)
    8000621a:	6a42                	ld	s4,16(sp)
    8000621c:	6aa2                	ld	s5,8(sp)
    8000621e:	6121                	addi	sp,sp,64
    80006220:	8082                	ret
    80006222:	8082                	ret

0000000080006224 <uartputc>:
{
    80006224:	7179                	addi	sp,sp,-48
    80006226:	f406                	sd	ra,40(sp)
    80006228:	f022                	sd	s0,32(sp)
    8000622a:	ec26                	sd	s1,24(sp)
    8000622c:	e84a                	sd	s2,16(sp)
    8000622e:	e44e                	sd	s3,8(sp)
    80006230:	e052                	sd	s4,0(sp)
    80006232:	1800                	addi	s0,sp,48
    80006234:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006236:	00020517          	auipc	a0,0x20
    8000623a:	fd250513          	addi	a0,a0,-46 # 80026208 <uart_tx_lock>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	1a4080e7          	jalr	420(ra) # 800063e2 <acquire>
  if(panicked){
    80006246:	00003797          	auipc	a5,0x3
    8000624a:	dd67a783          	lw	a5,-554(a5) # 8000901c <panicked>
    8000624e:	c391                	beqz	a5,80006252 <uartputc+0x2e>
    for(;;)
    80006250:	a001                	j	80006250 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006252:	00003797          	auipc	a5,0x3
    80006256:	dd67b783          	ld	a5,-554(a5) # 80009028 <uart_tx_w>
    8000625a:	00003717          	auipc	a4,0x3
    8000625e:	dc673703          	ld	a4,-570(a4) # 80009020 <uart_tx_r>
    80006262:	02070713          	addi	a4,a4,32
    80006266:	02f71b63          	bne	a4,a5,8000629c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000626a:	00020a17          	auipc	s4,0x20
    8000626e:	f9ea0a13          	addi	s4,s4,-98 # 80026208 <uart_tx_lock>
    80006272:	00003497          	auipc	s1,0x3
    80006276:	dae48493          	addi	s1,s1,-594 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627a:	00003917          	auipc	s2,0x3
    8000627e:	dae90913          	addi	s2,s2,-594 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006282:	85d2                	mv	a1,s4
    80006284:	8526                	mv	a0,s1
    80006286:	ffffb097          	auipc	ra,0xffffb
    8000628a:	57c080e7          	jalr	1404(ra) # 80001802 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000628e:	00093783          	ld	a5,0(s2)
    80006292:	6098                	ld	a4,0(s1)
    80006294:	02070713          	addi	a4,a4,32
    80006298:	fef705e3          	beq	a4,a5,80006282 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000629c:	00020497          	auipc	s1,0x20
    800062a0:	f6c48493          	addi	s1,s1,-148 # 80026208 <uart_tx_lock>
    800062a4:	01f7f713          	andi	a4,a5,31
    800062a8:	9726                	add	a4,a4,s1
    800062aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800062ae:	0785                	addi	a5,a5,1
    800062b0:	00003717          	auipc	a4,0x3
    800062b4:	d6f73c23          	sd	a5,-648(a4) # 80009028 <uart_tx_w>
      uartstart();
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	ee2080e7          	jalr	-286(ra) # 8000619a <uartstart>
      release(&uart_tx_lock);
    800062c0:	8526                	mv	a0,s1
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	1d4080e7          	jalr	468(ra) # 80006496 <release>
}
    800062ca:	70a2                	ld	ra,40(sp)
    800062cc:	7402                	ld	s0,32(sp)
    800062ce:	64e2                	ld	s1,24(sp)
    800062d0:	6942                	ld	s2,16(sp)
    800062d2:	69a2                	ld	s3,8(sp)
    800062d4:	6a02                	ld	s4,0(sp)
    800062d6:	6145                	addi	sp,sp,48
    800062d8:	8082                	ret

00000000800062da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062da:	1141                	addi	sp,sp,-16
    800062dc:	e422                	sd	s0,8(sp)
    800062de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062e0:	100007b7          	lui	a5,0x10000
    800062e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062e8:	8b85                	andi	a5,a5,1
    800062ea:	cb91                	beqz	a5,800062fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062ec:	100007b7          	lui	a5,0x10000
    800062f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062f8:	6422                	ld	s0,8(sp)
    800062fa:	0141                	addi	sp,sp,16
    800062fc:	8082                	ret
    return -1;
    800062fe:	557d                	li	a0,-1
    80006300:	bfe5                	j	800062f8 <uartgetc+0x1e>

0000000080006302 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006302:	1101                	addi	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000630c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	fcc080e7          	jalr	-52(ra) # 800062da <uartgetc>
    if(c == -1)
    80006316:	00950763          	beq	a0,s1,80006324 <uartintr+0x22>
      break;
    consoleintr(c);
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	8fe080e7          	jalr	-1794(ra) # 80005c18 <consoleintr>
  while(1){
    80006322:	b7f5                	j	8000630e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006324:	00020497          	auipc	s1,0x20
    80006328:	ee448493          	addi	s1,s1,-284 # 80026208 <uart_tx_lock>
    8000632c:	8526                	mv	a0,s1
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	0b4080e7          	jalr	180(ra) # 800063e2 <acquire>
  uartstart();
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	e64080e7          	jalr	-412(ra) # 8000619a <uartstart>
  release(&uart_tx_lock);
    8000633e:	8526                	mv	a0,s1
    80006340:	00000097          	auipc	ra,0x0
    80006344:	156080e7          	jalr	342(ra) # 80006496 <release>
}
    80006348:	60e2                	ld	ra,24(sp)
    8000634a:	6442                	ld	s0,16(sp)
    8000634c:	64a2                	ld	s1,8(sp)
    8000634e:	6105                	addi	sp,sp,32
    80006350:	8082                	ret

0000000080006352 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006352:	1141                	addi	sp,sp,-16
    80006354:	e422                	sd	s0,8(sp)
    80006356:	0800                	addi	s0,sp,16
  lk->name = name;
    80006358:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000635a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000635e:	00053823          	sd	zero,16(a0)
}
    80006362:	6422                	ld	s0,8(sp)
    80006364:	0141                	addi	sp,sp,16
    80006366:	8082                	ret

0000000080006368 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006368:	411c                	lw	a5,0(a0)
    8000636a:	e399                	bnez	a5,80006370 <holding+0x8>
    8000636c:	4501                	li	a0,0
  return r;
}
    8000636e:	8082                	ret
{
    80006370:	1101                	addi	sp,sp,-32
    80006372:	ec06                	sd	ra,24(sp)
    80006374:	e822                	sd	s0,16(sp)
    80006376:	e426                	sd	s1,8(sp)
    80006378:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000637a:	6904                	ld	s1,16(a0)
    8000637c:	ffffb097          	auipc	ra,0xffffb
    80006380:	dae080e7          	jalr	-594(ra) # 8000112a <mycpu>
    80006384:	40a48533          	sub	a0,s1,a0
    80006388:	00153513          	seqz	a0,a0
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6105                	addi	sp,sp,32
    80006394:	8082                	ret

0000000080006396 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006396:	1101                	addi	sp,sp,-32
    80006398:	ec06                	sd	ra,24(sp)
    8000639a:	e822                	sd	s0,16(sp)
    8000639c:	e426                	sd	s1,8(sp)
    8000639e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063a0:	100024f3          	csrr	s1,sstatus
    800063a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063ae:	ffffb097          	auipc	ra,0xffffb
    800063b2:	d7c080e7          	jalr	-644(ra) # 8000112a <mycpu>
    800063b6:	5d3c                	lw	a5,120(a0)
    800063b8:	cf89                	beqz	a5,800063d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063ba:	ffffb097          	auipc	ra,0xffffb
    800063be:	d70080e7          	jalr	-656(ra) # 8000112a <mycpu>
    800063c2:	5d3c                	lw	a5,120(a0)
    800063c4:	2785                	addiw	a5,a5,1
    800063c6:	dd3c                	sw	a5,120(a0)
}
    800063c8:	60e2                	ld	ra,24(sp)
    800063ca:	6442                	ld	s0,16(sp)
    800063cc:	64a2                	ld	s1,8(sp)
    800063ce:	6105                	addi	sp,sp,32
    800063d0:	8082                	ret
    mycpu()->intena = old;
    800063d2:	ffffb097          	auipc	ra,0xffffb
    800063d6:	d58080e7          	jalr	-680(ra) # 8000112a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063da:	8085                	srli	s1,s1,0x1
    800063dc:	8885                	andi	s1,s1,1
    800063de:	dd64                	sw	s1,124(a0)
    800063e0:	bfe9                	j	800063ba <push_off+0x24>

00000000800063e2 <acquire>:
{
    800063e2:	1101                	addi	sp,sp,-32
    800063e4:	ec06                	sd	ra,24(sp)
    800063e6:	e822                	sd	s0,16(sp)
    800063e8:	e426                	sd	s1,8(sp)
    800063ea:	1000                	addi	s0,sp,32
    800063ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	fa8080e7          	jalr	-88(ra) # 80006396 <push_off>
  if(holding(lk))
    800063f6:	8526                	mv	a0,s1
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	f70080e7          	jalr	-144(ra) # 80006368 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006400:	4705                	li	a4,1
  if(holding(lk))
    80006402:	e115                	bnez	a0,80006426 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006404:	87ba                	mv	a5,a4
    80006406:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000640a:	2781                	sext.w	a5,a5
    8000640c:	ffe5                	bnez	a5,80006404 <acquire+0x22>
  __sync_synchronize();
    8000640e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006412:	ffffb097          	auipc	ra,0xffffb
    80006416:	d18080e7          	jalr	-744(ra) # 8000112a <mycpu>
    8000641a:	e888                	sd	a0,16(s1)
}
    8000641c:	60e2                	ld	ra,24(sp)
    8000641e:	6442                	ld	s0,16(sp)
    80006420:	64a2                	ld	s1,8(sp)
    80006422:	6105                	addi	sp,sp,32
    80006424:	8082                	ret
    panic("acquire");
    80006426:	00002517          	auipc	a0,0x2
    8000642a:	41250513          	addi	a0,a0,1042 # 80008838 <digits+0x20>
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	a6a080e7          	jalr	-1430(ra) # 80005e98 <panic>

0000000080006436 <pop_off>:

void
pop_off(void)
{
    80006436:	1141                	addi	sp,sp,-16
    80006438:	e406                	sd	ra,8(sp)
    8000643a:	e022                	sd	s0,0(sp)
    8000643c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000643e:	ffffb097          	auipc	ra,0xffffb
    80006442:	cec080e7          	jalr	-788(ra) # 8000112a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006446:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000644a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000644c:	e78d                	bnez	a5,80006476 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000644e:	5d3c                	lw	a5,120(a0)
    80006450:	02f05b63          	blez	a5,80006486 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006454:	37fd                	addiw	a5,a5,-1
    80006456:	0007871b          	sext.w	a4,a5
    8000645a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000645c:	eb09                	bnez	a4,8000646e <pop_off+0x38>
    8000645e:	5d7c                	lw	a5,124(a0)
    80006460:	c799                	beqz	a5,8000646e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006462:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006466:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000646a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000646e:	60a2                	ld	ra,8(sp)
    80006470:	6402                	ld	s0,0(sp)
    80006472:	0141                	addi	sp,sp,16
    80006474:	8082                	ret
    panic("pop_off - interruptible");
    80006476:	00002517          	auipc	a0,0x2
    8000647a:	3ca50513          	addi	a0,a0,970 # 80008840 <digits+0x28>
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	a1a080e7          	jalr	-1510(ra) # 80005e98 <panic>
    panic("pop_off");
    80006486:	00002517          	auipc	a0,0x2
    8000648a:	3d250513          	addi	a0,a0,978 # 80008858 <digits+0x40>
    8000648e:	00000097          	auipc	ra,0x0
    80006492:	a0a080e7          	jalr	-1526(ra) # 80005e98 <panic>

0000000080006496 <release>:
{
    80006496:	1101                	addi	sp,sp,-32
    80006498:	ec06                	sd	ra,24(sp)
    8000649a:	e822                	sd	s0,16(sp)
    8000649c:	e426                	sd	s1,8(sp)
    8000649e:	1000                	addi	s0,sp,32
    800064a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	ec6080e7          	jalr	-314(ra) # 80006368 <holding>
    800064aa:	c115                	beqz	a0,800064ce <release+0x38>
  lk->cpu = 0;
    800064ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064b4:	0f50000f          	fence	iorw,ow
    800064b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	f7a080e7          	jalr	-134(ra) # 80006436 <pop_off>
}
    800064c4:	60e2                	ld	ra,24(sp)
    800064c6:	6442                	ld	s0,16(sp)
    800064c8:	64a2                	ld	s1,8(sp)
    800064ca:	6105                	addi	sp,sp,32
    800064cc:	8082                	ret
    panic("release");
    800064ce:	00002517          	auipc	a0,0x2
    800064d2:	39250513          	addi	a0,a0,914 # 80008860 <digits+0x48>
    800064d6:	00000097          	auipc	ra,0x0
    800064da:	9c2080e7          	jalr	-1598(ra) # 80005e98 <panic>
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
